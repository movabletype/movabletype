# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Callback::TemplateMap;

use strict;
use warnings;

use MT::PublishOption;
use MT::CMS::Template;
use MT::DataAPI::Endpoint::Common;

sub can_list {
    my ( $eh, $app, $terms, $args, $options ) = @_;

    my $tmpl_id = $terms->{template_id} or return;
    my $tmpl = $app->model('template')->load($tmpl_id) or return;

    return MT::CMS::Template::can_view( $eh, $app, $tmpl->id,
        obj_promise($tmpl) );
}

sub can_view {
    return MT::CMS::Template::can_view(@_);
}

sub can_save {
    my ( $eh, $app, $obj ) = @_;
    return $app->error( $app->translate('No permissions') )
        unless $app->can_do('edit_templates');
    return 1;
}

sub save_filter {
    my ( $eh, $app, $obj, $orig ) = @_;

    if ( !defined( $obj->archive_type ) || $obj->archive_type eq '' ) {
        return $app->errtrans( 'A parameter "[_1]" is required.',
            'archiveType' );
    }

    my $archive_types = _retrieve_archive_types( $app, $obj );
    if ( !( grep { $obj->archive_type eq $_ } @$archive_types ) ) {
        return $app->errtrans( 'Invalid archive type: [_1]',
            $obj->archive_type );
    }

    return 1;
}

sub _retrieve_archive_types {
    my ( $app, $map ) = @_;

    my $tmpl     = $map->template or return [];
    my $obj_type = $tmpl->type;

    my @archive_types;
    for my $at ( $app->publisher->archive_types ) {
        my $archiver      = $app->publisher->archiver($at);
        my $archive_label = $archiver->archive_label;
        $archive_label = $at unless $archive_label;
        $archive_label = $archive_label->()
            if ( ref $archive_label ) eq 'CODE';
        if (   ( $obj_type eq 'archive' )
            || ( $obj_type eq 'author' )
            || ( $obj_type eq 'category' ) )
        {

          # only include if it is an non-content-type group-based archive type
            next
                if $archiver->entry_based
                || $archiver->contenttype_based
                || $archiver->contenttype_group_based;
        }
        elsif ( $obj_type eq 'page' ) {

            # only include if it is a entry-based archive type and page
            next unless $archiver->entry_based;
            next if $archiver->entry_class ne 'page';
        }
        elsif ( $obj_type eq 'individual' ) {

            # only include if it is a entry-based archive type and entry
            next unless $archiver->entry_based;
            next if $archiver->entry_class eq 'page';
        }
        elsif ( $obj_type eq 'ct_archive' ) {

            # only include if it is a contenttype-group-based archive type
            next
                unless $app->current_api_version >= 4
                && $archiver->contenttype_group_based;

            if ( $archiver->contenttype_category_based ) {
                my $has_cat_field = $app->model('content_field')->count(
                    {   content_type_id => $tmpl->content_type_id || 0,
                        type            => 'categories',
                    }
                );
                next unless $has_cat_field;
            }
        }
        elsif ( $obj_type eq 'ct' ) {

            # only include if it is a contenttype-based archive type
            next
                unless $app->current_api_version >= 4
                && $archiver->contenttype_based;
        }
        push @archive_types, $at;
    }

    return \@archive_types;
}

sub pre_save {
    my ( $cb, $app, $obj ) = @_;

    if ( !$obj->is_preferred ) {
        my $terms = {
            blog_id      => $obj->blog_id,
            archive_type => $obj->archive_type,
            is_preferred => 1,
        };
        my $tmpl = $obj->template;
        my $args = {
            $tmpl->content_type_id
            ? ( join => $app->model('template')->join_on(
                    undef,
                    {   id              => \'= templatemap_template_id',
                        content_type_id => $tmpl->content_type_id,
                    },
                ),
                )
            : (),
        };
        if ( !$app->model('templatemap')->exist( $terms, $args ) ) {
            $obj->is_preferred(1);
        }
    }

    return 1;
}

sub post_save {
    my $eh = shift;
    my ( $app, $obj, $original ) = @_;

    if ( $obj->is_preferred ) {
        my $terms = {
            id           => { not => $obj->id },
            blog_id      => $obj->blog_id,
            archive_type => $obj->archive_type,
            is_preferred => 1,
        };
        my $tmpl = $obj->template;
        my $args = {
            $tmpl->content_type_id
            ? ( join => $app->model('template')->join_on(
                    undef,
                    {   id              => \'= templatemap_template_id',
                        content_type_id => $tmpl->content_type_id,
                    },
                ),
                )
            : (),
        };

        my @maps = $app->model('templatemap')->load( $terms, $args );
        for my $m (@maps) {
            $m->is_preferred(0);
            $m->save or return;
        }
    }

    my $site = $app->blog;
    return if !( $site && $site->id );

    $site->flush_has_archive_type_cache;

    _prepare_dynamic_publishing( $eh, $app, $site, $obj );

    if (   $obj->build_type == MT::PublishOption::DYNAMIC()
        && $obj->build_type != $original->build_type )
    {
        $app->param( 'type',            $obj->archive_type );
        $app->param( 'with_indexes',    1 );
        $app->param( 'no_static',       1 );
        $app->param( 'template_id',     $obj->template_id );
        $app->param( 'single_template', 1 );
        require MT::CMS::Blog;
        return MT::CMS::Blog::start_rebuild_pages_directly($app);
    }
}

sub _prepare_dynamic_publishing {
    my ( $eh, $app, $site, $obj ) = @_;

    if ($app->model('templatemap')->exist(
            {   blog_id      => $obj->blog_id,
                archive_type => $obj->archive_type,
                build_type   => MT::PublishOption::DYNAMIC(),
            }
        )
        )
    {
        my ( $path, $url );

        # must be archive since other types can't be dynamic
        if ( $path = $site->archive_path ) {
            $url = $site->archive_url;
        }
        else {
            $path = $site->site_path;
            $url  = $site->site_url;
        }

        # specific arguments so not to overwrite mtview and htaccess
        require MT::CMS::Blog;
        MT::CMS::Blog::prepare_dynamic_publishing( $eh, $site, undef,
            undef, $path, $url );
    }
}

sub can_delete {
    return can_save(@_);
}

sub post_delete {
    my $eh = shift;
    my ( $app, $obj ) = @_;

    my $tmpl = $obj->template;
    my $args = {
        $tmpl->content_type_id
        ? ( join => $app->model('template')->join_on(
                undef,
                {   id              => \'= templatemap_template_id',
                    content_type_id => $tmpl->content_type_id,
                },
            ),
            )
        : (),
    };

    if (!$app->model('templatemap')->exist(
            {   blog_id      => $obj->blog_id,
                archive_type => $obj->archive_type,
                is_preferred => 1,
            },
            $args,
        )
        )
    {
        my $m = $app->model('templatemap')->load(
            {   blog_id      => $obj->blog_id,
                archive_type => $obj->archive_type,
            },
            $args,
        );
        if ($m) {
            $m->is_preferred(1);
            $m->save or return;
        }
    }

    my $site = $app->blog;
    return if !( $site && $site->id );

    $site->flush_has_archive_type_cache;

    _prepare_dynamic_publishing( $eh, $app, $site, $obj );
}

1;

__END__

=head1 NAME

MT::DataAPI::Callback::TemplateMap - Movable Type class for Data API's callbacks about the MT::TemplateMap.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
