# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Asset;

use strict;
use warnings;
use MT::Tag;    # Holds MT::Taggable
use base qw( MT::Object MT::Taggable MT::Scorable );
use MT::Util qw( encode_js );

__PACKAGE__->install_properties(
    {   column_defs => {
            'id'          => 'integer not null auto_increment',
            'blog_id'     => 'integer not null',
            'label'       => 'string(255)',
            'url'         => 'text',
            'description' => 'text',
            'file_path'   => 'string(255)',
            'file_name'   => 'string(255)',
            'file_ext'    => 'string(20)',
            'mime_type'   => 'string(255)',
            'parent'      => 'integer',
        },
        indexes => {
            label      => 1,
            file_ext   => 1,
            parent     => 1,
            created_by => 1,
            created_on => 1,
            blog_class_date =>
                { columns => [ 'blog_id', 'class', 'created_on' ], },
        },
        class_type  => 'file',
        audit       => 1,
        meta        => 1,
        datasource  => 'asset',
        primary_key => 'id',
    }
);

sub list_default_terms {
    { class => '*', };
}

sub list_props {
    return {
        id => {
            base    => '__virtual.id',
            display => 'optional',
            order   => 100,
        },
        label => {
            auto      => 1,
            label     => 'Label',
            order     => 200,
            display   => 'force',
            bulk_html => sub {
                my $prop = shift;
                my ( $objs, $app ) = @_;
                my $static_uri = MT->static_path;
                my @userpics   = MT->model('objecttag')->load(
                    {   blog_id           => 0,
                        object_datasource => 'asset',
                        object_id         => [ map { $_->id } @$objs ],
                    },
                    {   fetchonly => { object_id => 1 },
                        join      => MT->model('tag')->join_on(
                            undef,
                            {   name => '@userpic',
                                id   => \'= objecttag_tag_id', # FOR-EDITOR ',
                            }
                        ),
                    }
                );
                my %is_userpic = map { $_->object_id => 1 } @userpics;
                my @rows;
                MT::Meta::Proxy->bulk_load_meta_objects($objs);
                for my $obj (@$objs) {
                    my $id = $obj->id;
                    my $label
                        = MT::Util::encode_html( $obj->label
                            || $obj->file_name
                            || 'Untitled' );
                    my $blog_id
                        = $obj->has_column('blog_id') ? $obj->blog_id
                        : $app->blog                  ? $app->blog->id
                        :                               0;
                    my $type      = $prop->object_type;
                    my $edit_link = $app->uri(
                        mode => 'view',
                        args => {
                            _type   => $type,
                            id      => $id,
                            blog_id => $blog_id,
                        },
                    );
                    my $class_type = $obj->class_type;
                    my $svg_type
                        = $class_type eq 'file'  ? 'default'
                        : $class_type eq 'video' ? 'movie'
                        :                          $class_type;

                    require MT::FileMgr;
                    my $fmgr      = MT::FileMgr->new('Local');
                    my $file_path = $obj->file_path;
                    ## FIXME: Hardcoded
                    my $thumb_size = 60;
                    my $userpic_sticker
                        = $is_userpic{ $obj->id }
                        ? q{<span class="badge badge-default" style="vertical-align: top; line-height: normal; margin-top: -3px;">Userpic</span>}
                        : '';
                    my $created_on
                        = MT::Util::date_for_listing( $obj->created_on,
                        $app );

                    if ( $file_path && $fmgr->exists($file_path) ) {
                        if (   $obj->has_thumbnail
                            && $obj->can_create_thumbnail )
                        {
                            my $thumbnail_method = $obj->can('maybe_dynamic_thumbnail_url') || 'thumbnail_url';
                            my ( $orig_width, $orig_height )
                                = ( $obj->image_width, $obj->image_height );
                            my ( $thumbnail_url, $thumbnail_width,
                                $thumbnail_height );
                            if (   $orig_width > $thumb_size
                                && $orig_height > $thumb_size )
                            {
                                (   $thumbnail_url, $thumbnail_width,
                                    $thumbnail_height
                                    )
                                    = $obj->$thumbnail_method(
                                    Height => $thumb_size,
                                    Width  => $thumb_size,
                                    Square => 1,
                                    Ts     => 1
                                    );
                            }
                            elsif ( $orig_width > $thumb_size ) {
                                (   $thumbnail_url, $thumbnail_width,
                                    $thumbnail_height
                                    )
                                    = $obj->$thumbnail_method(
                                    Width => $thumb_size,
                                    Ts    => 1
                                    );
                            }
                            elsif ( $orig_height > $thumb_size ) {
                                (   $thumbnail_url, $thumbnail_width,
                                    $thumbnail_height
                                    )
                                    = $obj->$thumbnail_method(
                                    Height => $thumb_size,
                                    Ts     => 1
                                    );
                            }
                            else {
                                (   $thumbnail_url, $thumbnail_width,
                                    $thumbnail_height
                                    )
                                    = (
                                    $obj->url . '?ts=' . $obj->modified_on,
                                    $orig_width, $orig_height
                                    );
                            }

                            my $style = '';
                            if ($thumbnail_width && $thumbnail_height) {
                                my $thumbnail_width_offset = int( ( $thumb_size - $thumbnail_width ) / 2 );
                                my $thumbnail_height_offset = int( ( $thumb_size - $thumbnail_height ) / 2 );
                                $style = qq{style="padding: ${thumbnail_height_offset}px ${thumbnail_width_offset}px"};
                            }

                            push @rows, qq{
                                <div class="pull-left d-none d-md-inline">
                                    <img alt="link1" src="$thumbnail_url" class="img-thumbnail" width="$thumb_size" height="$thumb_size" $style loading="lazy" decoding="async" />
                                    <span class="title ml-4 mr-2"><a href="$edit_link" style="vertical-align: top; line-height: normal;">$label</a></span>$userpic_sticker
                                </div>
                                <div class="d-md-none row">
                                    <div class="col-auto mb-2 pl-0">
                                        <img alt="link2" src="$thumbnail_url" class="img-thumbnail" width="$thumb_size" height="$thumb_size" $style loading="lazy" decoding="async" />
                                    </div>
                                    <div class="col pl-0">
                                        <span class="title"><a href="$edit_link" style="vertical-align: top; line-height: normal;">$label</a></span>
                                    </div>
                                    <div class="col-12 pl-0">
                                        <span class="font-weight-light">
                                            $created_on
                                        </span>
                                        $userpic_sticker
                                    </div>
                                </div>
                            };
                        }
                        elsif ( $class_type eq 'image' ) {
                            my $svg = qq{
                                    <div class="mt-thumbnail">
                                        <img src="${static_uri}images/file-image.svg" width="60" height="60" loading="lazy" decoding="async">
                                    </div>
                                };
                            push @rows, qq{
                                <div class="pull-left d-none d-md-inline">
                                    <div class="mt-user">
                                        $svg
                                        <div class="mt-user__badge--warning">
                                            <svg class="mt-icon--inverse mt-icon--sm">
                                                <title>Warning</title>
                                                <use xlink:href="${static_uri}images/sprite.svg#ic_error"></use>
                                            </svg>
                                        </div>
                                    </div>
                                    <span class="title ml-4 mr-2"><a href="$edit_link" style="vertical-align: top; line-height: normal;">$label</a></span>$userpic_sticker
                                </div>
                                <div class="d-md-none row">
                                    <div class="col-auto mb-2 pl-0">
                                        <div class="mt-user">
                                            $svg
                                            <div class="mt-user__badge--warning">
                                                <svg class="mt-icon--inverse mt-icon--sm">
                                                    <title>Warning</title>
                                                    <use xlink:href="${static_uri}images/sprite.svg#ic_error"></use>
                                                </svg>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col pl-0">
                                        <span class="title"><a href="$edit_link" style="vertical-align: top; line-height: normal;">$label</a></span>
                                    </div>
                                    <div class="col-12 pl-0">
                                        <span class="font-weight-light">
                                            $created_on
                                        </span>
                                        $userpic_sticker
                                    </div>
                                </div>
                            };
                        }
                        else {
                            my $svg = qq{
                                    <div class="mt-thumbnail">
                                        <img src="${static_uri}images/file-$svg_type.svg" width="60" height="60" loading="lazy" decoding="async">
                                    </div>
                                };
                            push @rows, qq{
                                <div class="pull-left d-none d-md-inline">
                                    $svg
                                    <span class="title ml-4 mr-2"><a href="$edit_link" style="vertical-align: top; line-height: normal;">$label</a></span>$userpic_sticker
                                </div>
                                <div class="d-md-none row">
                                    <div class="col-auto mb-2 pl-0">
                                        <img src="${static_uri}images/file-$svg_type.svg" width="60" height="60" loading="lazy" decoding="async">
                                    </div>
                                    <div class="col pl-0">
                                        <span class="title"><a href="$edit_link" style="vertical-align: top; line-height: normal;">$label</a></span>
                                    </div>
                                    <div class="col-12 pl-0">
                                        <span class="font-weight-light">
                                            $created_on
                                        </span>
                                        $userpic_sticker
                                    </div>
                                </div>
                            };
                        }
                    }
                    else {
                        my $svg = qq{
                                <div class="mt-thumbnail">
                                    <img src="${static_uri}images/file-$svg_type.svg" width="60" height="60" loading="lazy" decoding="async">
                                </div>
                            };
                        push @rows, qq{
                            <div class="pull-left d-none d-md-inline">
                                <div class="mt-user">
                                    $svg
                                    <div class="mt-user__badge--warning">
                                        <svg class="mt-icon--inverse mt-icon--sm">
                                            <title>Warning</title>
                                            <use xlink:href="${static_uri}images/sprite.svg#ic_error"></use>
                                        </svg>
                                    </div>
                                </div>
                                <span class="title ml-4 mr-2"><a href="$edit_link" style="vertical-align: top; line-height: normal;">$label</a></span>$userpic_sticker
                            </div>
                            <div class="d-md-none row">
                                <div class="col-auto mb-2 pl-0">
                                    <div class="mt-user">
                                        $svg
                                        <div class="mt-user__badge--warning">
                                            <svg class="mt-icon--inverse mt-icon--sm">
                                                <title>Warning</title>
                                                <use xlink:href="${static_uri}images/sprite.svg#ic_error"></use>
                                            </svg>
                                        </div>
                                    </div>
                                </div>
                                <div class="col pl-0">
                                    <span class="title"><a href="$edit_link" style="vertical-align: top; line-height: normal;">$label</a></span>
                                </div>
                                <div class="col-12 pl-0">
                                    <span class="font-weight-light">
                                        $created_on
                                    </span>
                                    $userpic_sticker
                                </div>
                            </div>
                        };
                    }
                }
                @rows;
            },
        },
        author_name => {
            base  => '__virtual.author_name',
            order => 300,
        },
        blog_name => {
            base    => '__virtual.blog_name',
            order   => 400,
            display => 'default',
        },
        created_on => {
            base    => '__virtual.created_on',
            order   => 500,
            display => 'default',
        },

        modified_on => {
            base    => '__virtual.modified_on',
            display => 'none',
        },
        class => {
            label   => 'Type',
            col     => 'class',
            display => 'none',
            base    => '__virtual.single_select',
            terms   => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $value = $args->{value};
                $db_args->{no_class} = 0;
                $db_terms->{class}   = $value;
                return;
            },
            ## FIXME: Get these values from registry or somewhere...
            single_select_options => [
                { label => MT->translate('Image'), value => 'image', },
                { label => MT->translate('Audio'), value => 'audio', },
                { label => MT->translate('Video'), value => 'video', },
                { label => MT->translate('File'),  value => 'file', },
            ],
        },
        description => {
            auto      => 1,
            display   => 'none',
            label     => 'Description',
            use_blank => 1,
        },
        file_name => {
            auto    => 1,
            display => 'none',
            label   => 'Filename',
        },
        file_ext => {
            auto      => 1,
            display   => 'none',
            label     => 'File Extension',
            use_blank => 1,
        },
        image_width => {
            label     => 'Pixel Width',
            base      => '__virtual.integer',
            display   => 'none',
            meta_type => 'image_width',
            col       => 'vinteger',
            raw       => sub {
                my ( $prop, $asset ) = @_;
                my $meta = $prop->meta_type;
                $asset->has_meta( $prop->meta_type ) or return;
                return $asset->$meta;
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;
                my $super_terms = $prop->super(@_);
                $db_args->{joins} ||= [];
                push @{ $db_args->{joins} },
                    MT->model('asset')->meta_pkg->join_on(
                    undef,
                    {   type     => $prop->meta_type,
                        asset_id => \"= asset_id",      # FOR-EDITOR ",
                        %$super_terms,
                    },
                    );
            },
        },
        image_height => {
            base      => 'asset.image_width',
            label     => 'Pixel Height',
            meta_type => 'image_height',
        },
        tag => {
            base         => '__virtual.tag',
            tagged_class => '*',
            use_blank    => 1,
        },
        except_userpic => {
            base      => '__virtual.hidden',
            label     => 'Except Userpic',
            display   => 'none',
            view      => 'system',
            singleton => 1,
            terms     => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;

                my $tag = MT->model('tag')->load(
                    { name => '@userpic', },
                    {   fetchonly => { id   => 1, },
                        binary    => { name => 1 },
                    }
                );

                if ($tag) {
                    $db_args->{joins} ||= [];
                    push @{ $db_args->{joins} },
                        MT->model('objecttag')->join_on(
                        undef,
                        [   { tag_id => { not => $tag->id }, },
                            '-or',
                            { tag_id => \'IS NULL', },
                        ],
                        {   unique    => 1,
                            type      => 'left',
                            condition => {
                                'object_id' => \'=asset_id',   # FOR-EDITOR ',
                                'object_datasource' => 'asset',
                            },
                        }
                        );
                }
            },
        },
        author_status => {
            label   => 'Author Status',
            display => 'none',
            base    => '__virtual.single_select',
            terms   => sub {
                my $prop = shift;
                my ( $args, $base_terms, $base_args, $opts, ) = @_;
                my $val = $args->{value};
                if ( $val eq 'deleted' ) {
                    $base_args->{joins} ||= [];
                    push @{ $base_args->{joins} },
                        MT->model('author')->join_on(
                        undef,
                        {   id => \'is null',    # FOR-EDITOR ',
                        },
                        {   type      => 'left',
                            condition => {
                                id => \'= asset_created_by'    # FOR-EDITOR ',
                            },
                        },
                        );
                }
                else {
                    my %statuses = (
                        active   => MT::Author::ACTIVE(),
                        disabled => MT::Author::INACTIVE(),
                        pending  => MT::Author::PENDING(),
                    );
                    my $status = $statuses{ $args->{value} };
                    $base_args->{joins} ||= [];
                    push @{ $base_args->{joins} },
                        MT->model('author')->join_on(
                        undef,
                        {   id     => \'= asset_created_by',  # FOR-EDITORS ',
                            status => $status,
                        },
                        );
                }
            },
            single_select_options => [
                { label => MT->translate('Deleted'),  value => 'deleted', },
                { label => MT->translate('Enabled'),  value => 'active', },
                { label => MT->translate('Disabled'), value => 'disabled', },
            ],
        },
        content => {
            base    => '__virtual.content',
            fields  => [qw( label )],
            display => 'none',
        },
        created_by => {
            auto            => 1,
            col             => 'created_by',
            display         => 'none',
            filter_editable => 0,
        },
        missing_file => {
            base        => '__virtual.single_select',
            label       => 'Missing File',
            singleton   => 1,
            filter_tmpl => sub {
                my $file = MT->translate('File');
                return <<"__FILTER_TMPL__";
<mt:setvar name="label" value="$file">
<mt:var name="filter_form_single_select">
__FILTER_TMPL__
            },
            single_select_options => [
                { label => MT->translate('missing'), value => 1, },
                { label => MT->translate('extant'),  value => 0, },
            ],
            label_via_param => sub {
                my $prop = shift;
                my ( $app, $val ) = @_;
                if ($val) {
                    return MT->translate('Assets with Missing File');
                }
                else {
                    return MT->translate('Assets with Extant File');
                }
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;

                my $filter;

                require MT::FileMgr;
                my $fmgr = MT::FileMgr->new('Local');
                if ( $args->{value} ) {
                    $filter = sub { !$fmgr->exists( $_[0] ) };
                }
                else {
                    $filter = sub { $fmgr->exists( $_[0] ) };
                }

                my @id;

                require MT::Asset;
                my $iter = MT::Asset->load_iter( $db_terms, $db_args );
                while ( my $asset = $iter->() ) {
                    push @id, $asset->id
                        if defined $asset->file_path
                        && $asset->file_path ne ''
                        && $filter->( $asset->file_path );
                }

                return +{ id => @id ? \@id : 0 };
            },
        },
        content_field => {
            args_via_param => sub {
                my $prop = shift;
                my ( $app, $val ) = @_;
                my $content_data_id = $app->param('content_data_id') || 0;
                +{  content_field_id => $val || 0,
                    content_data_id => $content_data_id,
                };
            },
            display         => 'none',
            filter_editable => 0,
            filter_tmpl     => sub {
                my @args  = @_;
                my $app   = MT->instance;
                my $stash = $app->request('content_field_filter')
                    or return '';
                MT::Util::encode_js(
                    MT->translate(
                        "Assets in [_1] field of [_2] '[_4]' (ID:[_3])",
                        $stash->{content_field}->name,
                        $stash->{content_type}->name,
                        $stash->{content_data}->id,
                        (   $stash->{content_data}->label
                                || MT->translate('No Label')
                        )
                    )
                );
            },
            label           => 'Content Field',
            label_via_param => sub {
                my $prop = shift;
                my ( $app, $content_field_id ) = @_;
                $content_field_id ||= 0;

                my $content_field
                    = $app->model('content_field')->load($content_field_id)
                    or return $prop->error(
                    $app->translate(
                        'Content Field ( id: [_1] ) does not exists.',
                        $content_field_id
                    )
                    );

                my $content_data_id = $app->param('content_data_id') || 0;
                my $content_data
                    = $app->model('content_data')->load($content_data_id)
                    or return $prop->error(
                    $app->translate(
                        'Content Data ( id: [_1] ) does not exists.',
                        $content_data_id
                    )
                    );

                my $content_type = $content_data->content_type
                    or return $prop->error(
                    $app->translate(
                        'Content type of Content Data ( id: [_1] ) does not exists.',
                        $content_data_id
                    )
                    );

                $app->request(
                    'content_field_filter' => {
                        content_data  => $content_data,
                        content_field => $content_field,
                        content_type  => $content_type,
                    }
                );

                return $app->translate(
                    "Assets in [_1] field of [_2] '[_4]' (ID:[_3])",
                    $content_field->name,
                    $content_type->name,
                    $content_data->id,
                    ( $content_data->label || MT->translate('No Label') )
                );
            },
            terms => sub {
                my $prop = shift;
                my ( $args, $db_terms, $db_args ) = @_;

                my $app = MT->instance;

                my $content_field
                    = $app->model('content_field')
                    ->load( $args->{content_field_id} );
                my $content_data
                    = $app->model('content_data')
                    ->load( $args->{content_data_id} );

                my $asset_ids = $content_data->data->{ $content_field->id };
                $asset_ids = [$asset_ids] unless ref $asset_ids eq 'ARRAY';

                +{ id => $asset_ids };
            },
        },
    };
}

sub system_filters {
    my %filters;
    my @filters_to_sort;
    my $order = 0;

    # for each class
    my %ordered_types;
    $ordered_types{$_} = $order += 100 for qw(file image audio video);

    my $types = MT::Asset->class_labels;
    foreach my $type ( keys %$types ) {

        # Ignore parent class.
        next if $type eq 'asset';

        my $asset_type = $type;
        $asset_type = substr( $type, 6 );    # length('asset.') => 6

        my $filter = {
            label => sub {
                MT::Asset->class_handler($type)->class_label_plural;
            },
            items =>
                [ { type => 'class', args => { value => $asset_type }, }, ],
        };

        if ( my $o = $ordered_types{$asset_type} ) {
            $filter->{order} = $o;
            $filters{$asset_type} = $filter;
        }
        else {
            $filter->{type} = $asset_type;
            push( @filters_to_sort, $filter );
        }
    }

    @filters_to_sort
        = sort { $a->{label}->() cmp $b->{label}->() } @filters_to_sort;
    for my $filter (@filters_to_sort) {
        $order += 100;
        $filter->{order} = $order;
        $filters{ delete $filter->{type} } = $filter;
    }

    # for context
    $filters{current_website} = {
        label => 'Assets of this website',
        items => [ { type => 'current_context' } ],
        view  => 'website',
        order => 10000,
    };

    $filters{missing_file} = {
        label => 'Assets with Missing File',
        items => [ { type => 'missing_file', args => { value => 1 }, } ],
        order => 10100,
    };

    $filters{extant_file} = {
        label => 'Assets with Extant File',
        items => [ { type => 'missing_file', args => { value => 0 }, } ],
        order => 10200,
    };

    return \%filters;
}

require MT::Asset::Image;
require MT::Asset::Audio;
require MT::Asset::Video;

sub extensions {
    my $pkg = shift;
    return undef unless @_;

    my ($this_pkg) = caller;
    my ($ext)      = @_;
    return \@$ext unless MT->config('AssetFileTypes');

    my @custom_ext = map {qr/$_/i}
        split( /\s*,\s*/, MT->config('AssetFileTypes')->{$this_pkg} );
    my %seen;
    my ($new_ext) = grep { ++$seen{$_} < 2 }[ @$ext, @custom_ext ];

    return \@$new_ext;
}

# This property is a meta-property.
sub file_path {
    my $asset = shift;
    my $path = $asset->column( 'file_path', @_ );
    return $path if defined($path) && ( $path !~ m!^\$! ) && ( -f $path );

    $path = $asset->cache_property(
        sub {
            my $path = $asset->column('file_path');
            if ( $path && ( $path =~ m!^\%([ras])! ) ) {
                my $blog = $asset->blog;
                my $root
                    = !$blog
                    || $1 eq 's' ? MT->instance->support_directory_path
                    : $1 eq 'r'  ? $blog->site_path
                    :              $blog->archive_path;
                $root =~ s!(/|\\)$!!;
                $path =~ s!^\%[ras]!$root!;
            }
            $path;
        },
        @_
    );
    return $path;
}

sub url {
    my $asset = shift;
    my $url = $asset->column( 'url', @_ );
    return $url
        if defined($url) && ( $url !~ m!^\%! ) && ( $url =~ m!^https?://! );

    $url = $asset->cache_property(
        sub {
            my $url = $asset->column('url');
            if ( $url =~ m!^\%([ras])! ) {
                my $blog = $asset->blog;
                my $root
                    = !$blog
                    || $1 eq 's' ? MT->instance->support_directory_url
                    : $1 eq 'r'  ? $blog->site_url
                    :              $blog->archive_url;
                $root =~ s!/$!!;
                $url =~ s!^\%[ras]!$root!;
            }
            return $url;
        },
        @_
    );
    return $url;
}

# Returns a localized name for the asset type. For MT::Asset, this is simply
# 'File'.
sub class_label {
    MT->translate('Asset');
}

sub class_label_plural {
    MT->translate("Assets");
}

# Removes the asset, associated tags and related file.
# TBD: Should we track and remove any generated thumbnail files here too?
sub remove {
    my $asset = shift;
    if ( ref $asset ) {
        my $blog = MT::Blog->load( $asset->blog_id );
        require MT::FileMgr;
        my $fmgr = $blog ? $blog->file_mgr : MT::FileMgr->new('Local');
        my $file = $asset->file_path;
        unless ( $fmgr->delete($file) ) {
            my $app = MT->instance;
            $app->log(
                {   message => $app->translate(
                        "Could not remove asset file [_1] from the filesystem: [_2]",
                        $file,
                        $fmgr->errstr
                    ),
                    level    => MT::Log::ERROR(),
                    class    => 'asset',
                    category => 'delete',
                }
            );
        }
        $asset->remove_cached_files;

        # remove children.
        my $class = ref $asset;
        my @parents = __PACKAGE__->load(
            { parent => $asset->id, class => '*' } );
        $_->remove for @parents;

        # Remove MT::ObjectAsset records
        $class = MT->model('objectasset');
        my $iter = $class->load_iter( { asset_id => $asset->id } );
        while ( my $o = $iter->() ) {
            $o->remove;
        }
    }

    $asset->SUPER::remove(@_);
}

sub save {
    my $asset = shift;
    if ( defined $asset->file_ext ) {
        $asset->file_ext( lc( $asset->file_ext ) );
    }

    unless ( $asset->SUPER::save(@_) ) {
        print STDERR "error during save: " . $asset->errstr . "\n";
        die $asset->errstr;
    }
}

sub remove_cached_files {
    my $asset = shift;

    # remove any asset cache files that exist for this asset
    my $blog = $asset->blog;
    if ( $asset->id && $blog ) {
        my $cache_dir = $asset->_make_cache_path;
        if ($cache_dir) {
            require MT::FileMgr;
            my $fmgr = $blog->file_mgr || MT::FileMgr->new('Local');
            if ($fmgr) {
                my $basename = $asset->file_name;
                my $ext      = '.' . $asset->file_ext;
                if ($ext =~ /\A\.[A-Za-z0-9]+\z/) {
                    $basename =~ s/\Q$ext\E$//;
                }
                my $cache_glob = File::Spec->catfile( $cache_dir,
                    $basename . '-thumb-*-' . $asset->id . $ext );
                my @files = glob($cache_glob);
                foreach my $file (@files) {
                    unless ( $fmgr->delete($file) ) {
                        my $app = MT->instance;
                        $app->log(
                            {   message => $app->translate(
                                    "Could not remove asset file [_1] from the filesystem: [_2]",
                                    $file,
                                    $fmgr->errstr
                                ),
                                level    => MT::Log::ERROR(),
                                class    => 'asset',
                                category => 'delete',
                            }
                        );
                    }
                }
            }
        }
    }
    1;
}

sub blog {
    my $asset = shift;
    my $blog_id = $asset->blog_id or return undef;
    return $asset->{__blog}
        if $blog_id
        && $asset->{__blog}
        && ( $asset->{__blog}->id == $blog_id );
    require MT::Blog;
    $asset->{__blog} = MT::Blog->load($blog_id)
        or return $asset->error("Failed to load blog for file");
    return $asset->{__blog};
}

# Returns a true/false response based on whether the active package
# has extensions registered that match the requested filename.
sub can_handle {
    my ( $pkg, $filename ) = @_;

    # undef is returned from fileparse if the extension is not known.
    require File::Basename;
    my $ext = $pkg->extensions || [];
    return ( File::Basename::fileparse( $filename, @$ext ) )[2] ? 1 : 0;
}

# Given a filename, returns an appropriate MT::Asset class to associate
# with it. This lookup is based purely on file extension! If none can
# be found, it returns MT::Asset.
sub handler_for_file {
    my $pkg = shift;
    my ($filename) = @_;
    my $types;

    # special case to check for all registered classes, not just
    # those that are subclasses of this package.
    if ( $pkg eq 'MT::Asset' ) {
        $types = [ keys %{ $pkg->properties->{__type_to_class} || {} } ];
    }
    $types ||= $pkg->type_list;
    if ($types) {
        foreach my $type (@$types) {
            my $this_pkg = $pkg->class_handler($type);
            if ( $this_pkg->can_handle($filename) ) {
                return $this_pkg;
            }
        }
    }
    __PACKAGE__;
}

sub type_list {
    my $pkg       = shift;
    my $props     = $pkg->properties;
    my $col       = $props->{class_column};
    my $this_type = $props->{class_type};
    my @classes   = values %{ $props->{__class_to_type} };
    @classes = grep {m/^\Q$this_type\E:/} @classes;
    push @classes, $this_type;
    return \@classes;
}

sub metadata {
    my ($asset, %opts) = @_;
    my %metadata = (
        MT->translate("Description") => $asset->description,
        MT->translate("Name")        => $asset->label,
        url                          => $asset->url,
        MT->translate("URL")         => $asset->url,
        MT->translate("Location")    => $asset->file_path,
        name                         => $asset->file_name,
        'class'                      => $asset->class,
        ext                          => $asset->file_ext,
        mime_type                    => $asset->mime_type,

        # duration => $asset->duration,
    );
    if (!$opts{no_tags}) {
        $metadata{ MT->translate("Tags") } = MT::Tag->join( ',', $asset->tags );
    }
    return \%metadata;
}

sub has_thumbnail {
    0;
}

sub thumbnail_file {
    undef;
}

sub thumbnail_filename {
    undef;
}

sub stock_icon_url {
    undef;
}

sub thumbnail_url {
    my $asset = shift;
    my (%param) = @_;

    require File::Basename;
    if ( my ( $thumbnail_file, $w, $h ) = $asset->thumbnail_file(@_) ) {
        return $asset->stock_icon_url(@_) if !defined $thumbnail_file;
        my $file            = File::Basename::basename($thumbnail_file);
        my $asset_file_path = $asset->column('file_path');
        my $site_url;
        my $blog = $asset->blog;
        if ( !$blog ) {
            $site_url
                = $param{Pseudo} ? '%s' : MT->instance->support_directory_url;
        }
        elsif ( $asset_file_path =~ m/^%a/ ) {
            $site_url = $param{Pseudo} ? '%a' : $blog->archive_url;
        }
        else {
            $site_url = $param{Pseudo} ? '%r' : $blog->site_url;
        }

        if ( $file && $site_url ) {
            require MT::Util;
            my $path = $param{Path};
            if ( !defined $path ) {
                $path = MT::Util::caturl( MT->config('AssetCacheDir'),
                    unpack( 'A4A2', $asset->created_on ) );
            }
            else {
                require File::Spec;
                my @path = File::Spec->splitdir($path);
                $path = '';
                for my $p (@path) {
                    $path = MT::Util::caturl( $path, $p );
                }
            }
            $file = MT::Util::encode_url($file);
            $site_url = MT::Util::caturl( $site_url, $path, $file );
            $site_url .= '?ts=' . $asset->modified_on
                if $param{Ts} and $asset->modified_on;
            return ( $site_url, $w, $h );
        }
    }

    # Use a stock icon
    return $asset->stock_icon_url(@_);
}

sub display_name {
    $_[0]->label || $_[0]->file_name;
}

sub as_html {
    my $asset = shift;
    my ($param) = @_;
    require MT::Util;
    my $text = sprintf '<a href="%s">%s</a>',
        MT::Util::encode_html( $asset->url ),
        MT::Util::encode_html( $asset->display_name );
    return $param->{enclose} ? $asset->enclose($text) : $text;
}

sub enclose {
    my $asset  = shift;
    my ($html) = @_;
    my $id     = $asset->id;
    my $type   = $asset->class;
    return
        qq{<form mt:asset-id="$id" class="mt-enclosure mt-enclosure-$type" style="display: inline;">$html</form>};
}

# Return a HTML snippet of form options for inserting this asset
# into a web page. Default behavior is no options.
sub insert_options {
    my $asset = shift;
    my ($param) = @_;
    return undef;
}

sub on_upload {
    my $asset = shift;
    my ($param) = @_;
    1;
}

sub edit_template_param {
    my $asset = shift;
    my ( $cb, $app, $param, $tmpl ) = @_;
    return;
}

# $pseudo parameter causes function to return '%r' as
# root instead of blog site path
sub _make_cache_path {
    my $asset = shift;
    my ( $path, $pseudo ) = @_;
    my $blog = $asset->blog;

    require File::Spec;
    my $year_stamp  = '';
    my $month_stamp = '';
    if ( !defined $path ) {
        $year_stamp  = unpack 'A4',    $asset->created_on;
        $month_stamp = unpack 'x4 A2', $asset->created_on;
        $path        = MT->config('AssetCacheDir');
    }
    else {
        my $merge_path = '';
        my @split      = File::Spec->splitdir($path);
        for my $p (@split) {
            $merge_path = File::Spec->catfile( $merge_path, $p );
        }
        $path = $merge_path if $merge_path;
    }

    my $asset_file_path = $asset->column('file_path');
    my $format;
    my $root_path;
    if ( !$blog ) {
        $format    = '%s';
        $root_path = MT->instance->support_directory_path;
    }
    elsif ( $asset_file_path =~ m/^%a/ ) {
        $format    = '%a';
        $root_path = $blog->archive_path;
    }
    else {
        $format    = '%r';
        $root_path = $blog->site_path;
    }

    my $real_cache_path
        = File::Spec->catdir( $root_path, $path, $year_stamp, $month_stamp );
    if ( !-d $real_cache_path ) {
        require MT::FileMgr;
        my $fmgr = $blog ? $blog->file_mgr : MT::FileMgr->new('Local');
        unless ( $fmgr->mkpath($real_cache_path) ) {
            my $app = MT->instance;
            $app->log(
                {   message => $app->translate(
                        "Could not create asset cache path: [_1]",
                        $fmgr->errstr
                    ),
                    level    => MT::Log::ERROR(),
                    class    => 'asset',
                    category => 'cache',
                }
            );
            return undef;
        }
    }

    my $asset_cache_path
        = File::Spec->catdir( ( $pseudo ? $format : $root_path ),
        $path, $year_stamp, $month_stamp );
    $asset_cache_path;
}

sub tagged_count {
    my $obj = shift;
    my ( $tag_id, $terms ) = @_;
    $terms ||= {};
    $terms->{class} = '*';
    return $obj->SUPER::tagged_count( $tag_id, $terms );
}

sub can_create_thumbnail {
    my $asset = shift;
    my $blog  = $asset->blog;

    require MT::FileMgr;
    require File::Spec;

    my $path            = MT->config('AssetCacheDir');
    my $asset_file_path = $asset->column('file_path');
    my $root_path;
    if ( !$blog ) {
        $root_path = MT->instance->support_directory_path;
    }
    elsif ( $asset_file_path =~ m/^%a/ ) {
        $root_path = $blog->archive_path;
    }
    else {
        $root_path = $blog->site_path;
    }

    my $real_thumb_path = File::Spec->catdir( $root_path, $path );
    my $fmgr = MT::FileMgr->new('Local');

    return $fmgr->exists($real_thumb_path)
        && !$fmgr->can_write($real_thumb_path) ? 0 : 1;
}

sub list_subclasses {

    my $types = MT->registry('object_types');
    my @types;

    foreach my $k ( keys %$types ) {
        if ( $k =~ m/^asset\.(.*)/ ) {
            my $c = $types->{$k};

            # When extending asset column by plugin.
            if ( ref $c eq 'ARRAY' && @$c ) {
                $c = @$c[0];
            }

            # Ignore invalid value for avoiding error.
            next if ref $c;

            push @types,
                {
                class => $c,
                type  => $1,
                };
        }
    }

    return \@types;
}

sub is_metadata_broken {
    return 0;
}

1;

__END__

=head1 NAME

MT::Asset

=head1 SYNOPSIS

    use MT::Asset;

    $asset = MT::Asset->load( $asset_id );
    print $asset->as_html();

    $asset_pkg = MT::Asset->handler_for_file($basename);
    $asset = $asset_pkg->new();
    $asset->file_path($filepath);
    $asset->file_name($basename);
    $asset->file_ext($ext);
    $asset->blog_id($blog_id);
    $asset->label($basename);
    $asset->created_by( $app->user->id );
    $asset->save();

=head1 DESCRIPTION

This module provides an object definition for a general file that is placed under
MT's control for publishing. There are sub-classes for specific file-types,
such as L<MT::Asset::Image>, L<MT::Asset::Audio> and L<MT::Asset::Video>

This module is subclass of L<MT::Object>, L<MT::Taggable> and L<MT::Scorable>

=head1 METHODS

=head2 MT::Asset->handler_for_file($filename)

Returns a I<MT::Asset> subclass suitable for the filename given. This
determination is typically made based on the file's extension.

=head2 MT::Asset->new

Constructs a new asset object. The base class is the generic asset object,
which represents a generic file.

=head2 Data access methods:

=over 4

=item $asset->id

=item $asset->blog_id - The blog that this asset is belong to

=item $asset->label

=item $asset->url

The URL on which this asset can be accessed at. can contain shortcuts
to build upon: %r for site url, %s for the support directory and
%a for the archive url

=item $asset->description

=item $asset->file_path

Local path for the file. can contain shortcuts similar to the url method

=item $asset->file_name - i.e. document.pdf

=item $asset->file_ext - the extension, without the leading dot

=item $asset->mime_type

=item $asset->parent

An asset can have a parent-asset, in which case the parent asset id is
stored here

=back

=head2 $asset->blog

returns a Blog object, to which this asset is belong to

=head2 $asset_pkg->can_handle( $filename )

return true if $asset_pkt can handle files as such as $filename

=head2 $asset->metadata()

returns a hashref containing all the fields of this asset with
translated keys, making it ready for presentation

=head2 $asset_pkt->extensions

an internal function used by can_handle to decide if this module
can handle a specific file.

subclasses are expected to override this method and supply their
own list of handled extensions

=head2 $asset_pkt->type_list()

returns the type-name that this package handles. this is the reverse
function for $pkg->class_handler($type)

=head2 $asset->has_thumbnail

=head2 $asset->thumbnail_file

=head2 $asset->thumbnail_filename

=head2 $asset->stock_icon_url

MT::Asset returns false for all these thumbnail functions, as it handles
a general file. subclasses should override them with relevant information

=head2 $asset->thumbnail_url( %params )

Tries to retrive thumbnail url base on the thumbnail_file method, or
if fails stock_icon_url. %params is passed directly to them.

If %param contains a 'Pseudo' key, will return the URL with %r, %s or %a
in the beginning, as explained in $asset->url

=head2 $asset->display_name

returns a name to display. Usually, returns label or a file name.

=head2 $asset->as_html( [ $params ] )

returns a HTML string containing link with the asset URL and filename
If $param->{enclose} is true, the HTML contains a form

=head2 $asset->insert_options( [ $params ] )

Return a HTML snippet of form options for inserting this asset
into a web page. Default behavior is no options.

=head2 $asset->on_upload( [ $param ] )

post-upload action. There is nothing to do for a generic file, but
subclasses can process the file, create thumbnails and so on.

=head2 $asset->edit_template_param($cb, $app, $param, $tmpl)

Called before the template rendering, and gives an asset a chance
to add parameters. Default behavior is to do nothing

=head2 $asset->remove_cached_files()

Remove all the thumbnails generated for $asset

=head2 $asset->_make_cache_path( [ $path, $pseudo ] )

Returns a suitable place for caching asset-related files. for example,
thumbnails. This place is basically root_path/cache-directory, where
root_path changes if the asset is blog-related, archives or in the
site-root. also cache-directory is taken from $path, or if not
supplied it is taken from the AssetCacheDir configuration directive,
added with the year and the month $asset was created on.

If $pseudo is true, returns a path starting with %r, %s or %a,
as explained in $asset->url

=head2 $asset->remove()

Remove this asset from the database, the filesystem and any associated
tags. also removes child assets and ObjectAsset records

=head2 $asset->can_create_thumbnail()

Write-in permission to thumbnail directory is investigated.

=head1 AUTHORS & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
