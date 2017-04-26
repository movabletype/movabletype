package MT::ContentFieldType::Asset;
use strict;
use warnings;

use MT;
use MT::Asset;
use MT::ContentData;
use MT::ContentFieldType::DateTime;
use MT::ObjectAsset;
use MT::ObjectTag;

sub field_html {
    my ( $app, $field_id, $value ) = @_;
    $value = ''       unless defined $value;
    $value = [$value] unless ref $value eq 'ARRAY';
    my @obj_assets = MT::ObjectAsset->load(
        {   object_ds => 'content_field',
            object_id => $field_id
        }
    );
    my $html
        = '<input type="text" name="content-field-'
        . $field_id
        . '" class="text long" value="';
    $html .= join ',', @$value;
    $html .= '" />';
    return $html;
}

sub data_getter {
    my ( $app, $id ) = @_;
    my $asset_ids = $app->param( 'content-field-' . $id );
    my @asset_ids = split ',', $asset_ids;

    my @valid_assets = MT::Asset->load( { id => \@asset_ids },
        { no_class => 1, fetchonly => { id => 1 } } );
    my %valid_assets = map { $_->id => 1 } @valid_assets;

    [ grep { $valid_assets{$_} } @asset_ids ];
}

sub single_select_options {
    my $prop = shift;
    my $app = shift || MT->app;

    my @assets = MT::Asset->load( { blog_id => $app->blog->id },
        { fetchonly => { id => 1, label => 1 }, no_class => 1 } );

    my @options;
    for my $asset (@assets) {
        my $label = $asset->label . ' (id:' . $asset->id . ')';
        push @options,
            {
            label => $label,
            value => $asset->id,
            };
    }
    \@options;
}

sub author_name_terms {
    my $prop = shift;
    my ( $args, $load_terms, $load_args ) = @_;

    my $col = 'created_by';
    my $prop_super = MT->registry( 'list_properties', '__virtual', 'string' );

    my ( $name_query, $nick_query );
    {
        local $prop->{col} = 'name';
        $name_query = $prop_super->{terms}->( $prop, @_ );
    }
    {
        local $prop->{col} = 'nickname';
        $nick_query = $prop_super->{terms}->( $prop, @_ );
    }

    my $author_terms = [
        $name_query,
        (   $args->{'option'} eq 'not_contains'
            ? '-and'
            : '-or'
        ),
        $nick_query,
    ];

    my $cf_idx_join = _generate_cf_idx_join( $prop, $author_terms );

    my @cd_ids
        = map { $_->id }
        MT::ContentData->load( $load_terms,
        { join => $cf_idx_join, fetchonly => { id => 1 } } );

    { id => @cd_ids ? \@cd_ids : 0 };
}

sub author_status_terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $status_query = $prop->super(@_);

    my $cf_idx_join = _generate_cf_idx_join( $prop, $status_query );

    my @cd_ids
        = map { $_->id }
        MT::ContentData->load( $db_terms,
        { join => $cf_idx_join, fetchonly => { id => 1 } } );

    { id => @cd_ids ? \@cd_ids : 0 };
}

sub _date_terms {
    my $prop = shift;
    my $col  = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $option    = $args->{option};
    my $data_type = $prop->{data_type};

    my $query = MT::ContentFieldType::DateTime::generate_query( $prop, @_ );

    my $asset_join = MT->model('asset')->join_on(
        undef,
        {   id      => \'= cf_idx_value_integer',
            blog_id => MT->app->blog->id,
            $col    => $query,
        },
        { no_class => 1 }
    );

    my $cf_idx_join = MT::ContentFieldIndex->join_on(
        undef,
        {   content_data_id  => \'= cd_id',
            content_field_id => $prop->content_field_id,
        },
        {   join   => $asset_join,
            unique => 1,
        },
    );

    my @cd_ids
        = map { $_->id }
        MT::ContentData->load( $db_terms,
        { join => $cf_idx_join, fetchonly => { id => 1 } } );

    { id => @cd_ids ? \@cd_ids : 0 };
}

sub modified_on_terms {
    my $prop = shift;
    my $col  = 'modified_on';
    _date_terms( $prop, $col, @_ );
}

sub created_on_terms {
    my $prop = shift;
    my $col  = 'created_on';
    _date_terms( $prop, $col, @_ );
}

sub _generate_cf_idx_join {
    my ( $prop, $author_terms ) = @_;

    my $author_join
        = MT->model('author')
        ->join_on( undef,
        [ { id => \'= asset_created_by' }, $author_terms, ] );

    my $asset_join = MT->model('asset')->join_on(
        undef,
        {   id      => \'= cf_idx_value_integer',
            blog_id => MT->app->blog->id,
        },
        {   no_class => 1,
            join     => $author_join,
        }
    );

    MT::ContentFieldIndex->join_on(
        undef,
        {   content_data_id  => \'= cd_id',
            content_field_id => $prop->content_field_id,
        },
        {   join   => $asset_join,
            unique => 1,
        },
    );
}

sub tag_terms {
    my $prop = shift;
    my ( $args, $base_terms, $base_args, $opts ) = @_;

    my $option  = $args->{option};
    my $query   = $args->{string};
    my $blog_id = $opts->{blog_ids};

    if ( 'contains' eq $option ) {
        $query = { like => "%$query%" };
    }
    elsif ( 'not_contains' eq $option ) {

        # After searching by LIKE, negate that results.
        $query = { like => "%$query%" };
    }
    elsif ( 'beginning' eq $option ) {
        $query = { like => "$query%" };
    }
    elsif ( 'end' eq $option ) {
        $query = { like => "%$query" };
    }

    if ( 'blank' eq $option ) {
        my $objecttag_join = MT::ObjectTag->join_on(
            undef,
            { object_id => \'IS NULL', },
            {   type      => 'left',
                condition => {
                    object_datasource => 'asset',
                    object_id         => \'= asset_id',
                },
            },
        );
        my $asset_join = MT->model('asset')->join_on(
            undef,
            { id => \'= cf_idx_value_integer', },
            {   no_class => 1,
                join     => $objecttag_join,
            }
        );
        my $cf_idx_join = MT::ContentFieldIndex->join_on(
            undef,
            {   content_data_id  => \'= cd_id',
                content_field_id => $prop->content_field_id,
            },
            {   join   => $asset_join,
                unique => 1,
            },
        );
        my @cd_ids
            = map { $_->id }
            MT::ContentData->load( $base_terms,
            { join => $cf_idx_join, fetchonly => { id => 1 } } );
        { id => @cd_ids ? \@cd_ids : 0 };
    }
    else {
        my $tag_join = MT->model('tag')->join_on(
            undef,
            {   name => $query,
                id   => \'= objecttag_tag_id',
            }
        );
        my $objecttag_join = MT->model('objecttag')->join_on(
            undef,
            {   blog_id           => MT->app->blog->id,
                object_datasource => 'asset',
                object_id         => \'= asset_id',
            },
            { join => $tag_join, },
        );
        my $asset_join = MT->model('asset')->join_on(
            undef,
            {   id      => \'= cf_idx_value_integer',
                blog_id => MT->app->blog->id,
            },
            {   no_class => 1,
                join     => $objecttag_join,
            }
        );
        my $cf_idx_join = MT::ContentFieldIndex->join_on(
            undef,
            {   content_data_id  => \'= cd_id',
                content_field_id => $prop->content_field_id,
            },
            {   join   => $asset_join,
                unique => 1,
            },
        );

        my @cd_ids
            = map { $_->id }
            MT::ContentData->load( $base_terms,
            { join => $cf_idx_join, fetchonly => { id => 1 } } );

        if ( 'not_contains' eq $option ) {
            @cd_ids ? { id => { not => \@cd_ids } } : ();
        }
        else {
            { id => @cd_ids ? \@cd_ids : 0 };
        }
    }
}

sub image_width_terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $super = MT->registry( 'list_properties', '__virtual', 'integer' );
    my $super_terms = $super->{terms}->( $prop, @_ );

    my $asset_meta_join
        = MT->model('asset')
        ->meta_pkg->join_on( 'asset_id',
        [ { type => $prop->meta_type }, $super_terms ],
        );

    my $asset_join = MT::Asset->join_on(
        undef,
        { id => \'= cf_idx_value_integer', },
        {   no_class => 1,
            join     => $asset_meta_join,
        },
    );

    my $cf_idx_join = MT::ContentFieldIndex->join_on(
        undef,
        {   content_data_id  => \'= cd_id',
            content_field_id => $prop->content_field_id,
        },
        { join => $asset_join, unique => 1 },
    );

    my @cd_ids
        = map { $_->id }
        MT::ContentData->load( $db_terms,
        { join => $cf_idx_join, fetchonly => { id => 1 } } );

    { id => @cd_ids ? \@cd_ids : 0 };
}

sub missing_file_terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');

    my $filter
        = $args->{value}
        ? sub { !$fmgr->exists( $_[0] ) }
        : sub { $fmgr->exists( $_[0] ) };

    my $iter = MT->model('asset')->load_iter(
        { blog_id => MT->app->blog->id },
        {   no_class => 1,
            join     => MT::ContentFieldIndex->join_on(
                undef,
                {   value_integer    => \'= asset_id',
                    content_field_id => $prop->content_field_id,
                },
            )
        }
    );

    my @asset_ids;
    while ( my $asset = $iter->() ) {
        push @asset_ids, $asset->id
            if defined $asset->file_path
            && $asset->file_path ne ''
            && $filter->( $asset->file_path );
    }

    return { id => 0 } unless @asset_ids;    # no data

    my $cf_idx_join = MT::ContentFieldIndex->join_on(
        undef,
        {   content_data_id  => \'= cd_id',
            content_field_id => $prop->content_field_id,
            value_integer    => \@asset_ids,
        },
        { unique => 1 },
    );

    my @cd_ids
        = map { $_->id }
        MT::ContentData->load( $db_terms,
        { join => $cf_idx_join, fetchonly => { id => 1 } } );

    { id => @cd_ids ? \@cd_ids : 0 };
}

sub label_terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $option = $args->{option} || '';

    my $super = MT->registry( 'list_properties', '__virtual', 'string' );
    my $query = $super->{terms}->( $prop, @_ );

    my $asset_join = MT::Asset->join_on(
        undef,
        [ { id => \'= cf_idx_value_integer' }, $query, ],
        { no_class => 1 },
    );
    my $cf_idx_join = MT::ContentFieldIndex->join_on(
        undef,
        {   content_data_id  => \'= cd_id',
            content_field_id => $prop->content_field_id,
        },
        {   join   => $asset_join,
            unique => 1,
        },
    );
    my @cd_ids
        = map { $_->id }
        MT::ContentData->load( { blog_id => MT->app->blog->id, },
        { join => $cf_idx_join, fetchonly => { id => 1 } } );
    { id => @cd_ids ? \@cd_ids : 0 };
}

sub html {
    my $prop = shift;
    my ( $content_data, $app, $opts ) = @_;

    my $cd_id     = $content_data->id;
    my $field_id  = $prop->content_field_id;
    my $asset_ids = $content_data->data->{$field_id} || [];

    my %assets
        = map { $_->id => $_ }
        MT->model('asset')->load( { id => $asset_ids }, { no_class => 1 } );
    my @assets = map { $assets{$_} } @$asset_ids;

    my ( @ids, @thumbnails );
    for my $asset (@assets) {
        my $id             = $asset->id;
        my $thumbnail_html = _thumbnail_html( $app, $asset );
        my $edit_link      = _edit_link( $app, $asset );

        push @ids,        qq{<a href="${edit_link}">${id}</a>};
        push @thumbnails, qq{<a href="${edit_link}">${thumbnail_html}</a>};
    }

    my $ids_html
        = qq{<span id="asset-ids-${cd_id}-${field_id}" class="id">}
        . join( ', ', @ids )
        . '</span>';
    my $thumbnails_html
        = qq{<span id="asset-thumbnails-${cd_id}-${field_id}" class="thumbnail">}
        . join( '', @thumbnails )
        . '</span>';
    my $js = <<"__JS__";
<script>
jQuery(document).ready(function() {
  jQuery("#custom-prefs-content_field_${field_id}\\\\.thumbnail").change(function() {
    changeIds();
  });

  function changeIds() {
    if (jQuery("#custom-prefs-content_field_${field_id}\\\\.thumbnail").prop('checked')) {
      jQuery('#asset-ids-${cd_id}-${field_id}').css('display', 'none');
    } else {
      jQuery('#asset-ids-${cd_id}-${field_id}').css('display', 'inline');
    }
  }

  changeIds();
});
</script>
__JS__

    $ids_html . $thumbnails_html . $js;
}

sub _edit_link {
    my ( $app, $asset ) = @_;
    $app->uri(
        mode => 'edit',
        args => {
            _type   => 'asset',
            blog_id => $asset->blog_id,
            id      => $asset->id,
        },
    );
}

sub _thumbnail_html {
    my ( $app, $asset ) = @_;

    my $edit_link  = _edit_link( $app, $asset );
    my $thumb_size = 45;
    my $class_type = $asset->class_type;
    my $file_path  = $asset->file_path;
    my $img
        = MT->static_path
        . 'images/asset/'
        . $class_type . '-'
        . $thumb_size . '.png';

    my ( $orig_width, $orig_height )
        = ( $asset->image_width, $asset->image_height );
    my ( $thumbnail_url, $thumbnail_width, $thumbnail_height );
    if (   $orig_width > $thumb_size
        && $orig_height > $thumb_size )
    {
        ( $thumbnail_url, $thumbnail_width, $thumbnail_height )
            = $asset->thumbnail_url(
            Height => $thumb_size,
            Width  => $thumb_size,
            Square => 1,
            Ts     => 1
            );
    }
    elsif ( $orig_width > $thumb_size ) {
        ( $thumbnail_url, $thumbnail_width, $thumbnail_height )
            = $asset->thumbnail_url(
            Width => $thumb_size,
            Ts    => 1
            );
    }
    elsif ( $orig_height > $thumb_size ) {
        ( $thumbnail_url, $thumbnail_width, $thumbnail_height )
            = $asset->thumbnail_url(
            Height => $thumb_size,
            Ts     => 1
            );
    }
    else {
        ( $thumbnail_url, $thumbnail_width, $thumbnail_height ) = (
            $asset->url . '?ts=' . $asset->modified_on,
            $orig_width, $orig_height
        );
    }

    my $thumbnail_width_offset
        = int( ( $thumb_size - $thumbnail_width ) / 2 );
    my $thumbnail_height_offset
        = int( ( $thumb_size - $thumbnail_height ) / 2 );

    qq{<img alt="" src="${thumbnail_url}" style="padding: ${thumbnail_height_offset}px ${thumbnail_width_offset}px" />};
}

1;

