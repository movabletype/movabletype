package MT::ContentFieldType::Asset;
use strict;
use warnings;

use MT::Asset;
use MT::ContentFieldType::DateTime;
use MT::ObjectAsset;

sub field_html {
    my ( $app, $id, $value ) = @_;
    $value = [$value] unless ref $value eq 'ARRAY';
    my $q          = $app->param;
    my $ct_data_id = $q->param('id');
    my @obj_assets = MT::ObjectAsset->load(
        {   object_ds => 'content_data',
            object_id => $ct_data_id
        }
    );
    my $html
        .= '<input type="text" name="content-field-'
        . $id
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

    $load_args->{joins} ||= [];
    push @{ $load_args->{joins} }, $cf_idx_join;
}

sub author_status_terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $status_query = $prop->super(@_);

    my $cf_idx_join = _generate_cf_idx_join( $prop, $status_query );

    $db_args->{joins} ||= [];
    push @{ $db_args->{joins} }, $cf_idx_join;
}

sub _date_terms {
    my $prop = shift;
    my $col  = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $option    = $args->{option};
    my $data_type = $prop->{data_type};

    my $query = MT::ContentFieldType::DateTime::generate_query( $prop, @_ );

    if ( 'blank' eq $option ) {
        { id => 0 };    # no data
    }
    else {
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

        $db_args->{joins} ||= [];
        push @{ $db_args->{joins} }, $cf_idx_join;
    }
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
    elsif ( 'blank' eq $option ) {
        $query = '';
    }

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

    $base_args->{joins} ||= [];

    if ( 'not_contains' eq $option ) {

        # content_data that has assets.
        push @{ $base_args->{joins} },
            MT::ContentFieldIndex->join_on(
            undef,
            {   content_data_id  => \'= cd_id',
                content_field_id => $prop->content_field_id,
            },
            { unique => 1 },
            );

        # content_data IDs that does not have asset and tag.
        my @indexes
            = MT::ContentFieldIndex->load(
            { content_field_id => $prop->content_field_id, },
            { fetchonly => { content_data_id => 1 }, join => $asset_join } );
        my %content_data_ids = map { $_->content_data_id => 1 } @indexes;
        my @content_data_ids = keys %content_data_ids;
        @content_data_ids ? { id => { not => \@content_data_ids } } : ();
    }
    else {
        push @{ $base_args->{joins} }, $cf_idx_join;
    }
}

1;

