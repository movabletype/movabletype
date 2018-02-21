# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Endpoint::Entry;

use warnings;
use strict;

use MT::Util qw( archive_file_for );
use MT::CMS::Entry;

use MT::DataAPI::Endpoint::Common;
use MT::DataAPI::Resource;

sub build_post_save_sub {
    my ( $app, $blog, $entry, $orig_entry ) = @_;

    my $archive_type = $orig_entry->class eq 'entry' ? 'Individual' : 'Page';
    my $orig_file
        = $orig_entry->id
        ? archive_file_for( $orig_entry, $blog, $archive_type )
        : undef;

    my $primary_category_old = $orig_entry->category;
    my $categories_old       = $orig_entry->categories;
    my $categories_old_ids   = join( ',', map { $_->id } @$categories_old );

    my ( $previous_old, $next_old );
    if ( $orig_entry->id && $entry->authored_on != $orig_entry->authored_on )
    {
        $previous_old = $orig_entry->previous(1);
        $next_old     = $orig_entry->next(1);
    }

    return sub {
        if ( ( $entry->status || 0 ) == MT::Entry::RELEASE()
            || $orig_entry->status eq MT::Entry::RELEASE() )
        {
            if ( $app->config('DeleteFilesAtRebuild') && defined($orig_file) )
            {
                my $file = archive_file_for( $entry, $blog, $archive_type );
                if (   $file ne $orig_file
                    || $entry->status != MT::Entry::RELEASE() )
                {
                    $app->publisher->remove_entry_archive_file(
                        Entry       => $orig_entry,
                        ArchiveType => $archive_type,
                        Category    => $primary_category_old,
                        Force       => 0,
                    );
                }
            }

            my $res = MT::Util::start_background_task(
                sub {
                    $app->run_callbacks('pre_build');
                    $app->rebuild_entry(
                        Entry => $entry,
                        (   $entry->is_entry
                            ? ( BuildDependencies => 1 )
                            : ( BuildIndexes => 1 )
                        ),
                        (   $entry->is_entry
                            ? ( OldEntry => $orig_entry )
                            : ()
                        ),
                        OldCategories => $categories_old_ids,
                        (   $entry->is_entry
                            ? ( OldPrevious => ($previous_old)
                                ? $previous_old->id
                                : undef
                                )
                            : ()
                        ),
                        (   $entry->is_entry
                            ? ( OldNext => ($next_old)
                                ? $next_old->id
                                : undef
                                )
                            : ()
                        ),
                    ) or return $app->publish_error();
                    $app->run_callbacks( 'rebuild', $blog );
                    $app->run_callbacks('post_build');
                    1;
                }
            );
            return unless $res;

            my $list = $app->needs_ping(
                Entry     => $entry,
                Blog      => $blog,
                OldStatus => $orig_entry->status,
            );
            require MT::Entry;
            if ( $entry->status == MT::Entry::RELEASE() && $list ) {
                MT::CMS::Entry::do_send_pings(
                    $app,
                    $blog->id,
                    $entry->id,
                    $orig_entry->status,
                    sub {
                        my ($has_errors) = @_;

                        # Ignore errros
                        return 1;
                    }
                );
            }
        }
    };
}

sub list {
    my ( $app, $endpoint ) = @_;

    my $res = filtered_list( $app, $endpoint, 'entry' ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub create {
    my ( $app, $endpoint ) = @_;

    my ($blog) = context_objects(@_);
    return unless $blog && $blog->id;

    my $author = $app->user;

    my $orig_entry = $app->model('entry')->new;
    $orig_entry->set_values(
        {   blog_id        => $blog->id,
            author_id      => $author->id,
            allow_comments => $blog->allow_comments_default,
            allow_pings    => $blog->allow_pings_default,
            convert_breaks => $blog->convert_paras,
            status         => (
                (          $app->can_do('publish_own_entry')
                        || $app->can_do('publish_all_entry')
                )
                ? MT::Entry::RELEASE()
                : MT::Entry::HOLD()
            )
        }
    );

    my $new_entry = $app->resource_object( 'entry', $orig_entry )
        or return;

    if (  !$new_entry->basename
        || $app->model('entry')
        ->exist( { blog_id => $blog->id, basename => $new_entry->basename } )
        )
    {
        $new_entry->basename( MT::Util::make_unique_basename($new_entry) );
    }
    MT::Util::translate_naughty_words($new_entry);

    my $post_save
        = build_post_save_sub( $app, $blog, $new_entry, $orig_entry );

    save_object( $app, 'entry', $new_entry )
        or return;

    $post_save->();

    $new_entry;
}

sub get {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $entry ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'entry', $entry->id, obj_promise($entry) )
        or return;

    $entry;
}

sub update {
    my ( $app, $endpoint ) = @_;

    my ( $blog, $orig_entry ) = context_objects(@_)
        or return;
    my $new_entry = $app->resource_object( 'entry', $orig_entry )
        or return;

    my $post_save
        = build_post_save_sub( $app, $blog, $new_entry, $orig_entry );

    save_object(
        $app, 'entry',
        $new_entry,
        $orig_entry,
        sub {
          # Setting modified_by updates modified_on which we want to do before
          # a save but after pre_save callbacks fire.
            $new_entry->modified_by( $app->user->id );

            $_[0]->();
        }
    ) or return;

    $post_save->();

    $new_entry;
}

sub delete {
    my ( $app, $endpoint ) = @_;
    my %recipe = ();

    my ( $blog, $entry ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_delete_permission_filter',
        'entry', $entry )
        or return;

    if ( $entry->status eq MT::Entry::RELEASE() ) {
        %recipe = $app->publisher->rebuild_deleted_entry(
            Entry => $entry,
            Blog  => $blog
        );
    }

    $entry->remove
        or return $app->error(
        $app->translate(
            'Removing [_1] failed: [_2]', $entry->class_label,
            $entry->errstr
        ),
        500
        );

    $app->run_callbacks( 'data_api_post_delete.entry', $app, $entry );

    if ( $app->config('RebuildAtDelete') ) {
        $app->run_callbacks('pre_build');
        MT::Util::start_background_task(
            sub {
                $app->rebuild_archives(
                    Blog   => $blog,
                    Recipe => \%recipe,
                ) or return $app->publish_error();
                $app->rebuild_indexes( Blog => $blog )
                    or return $app->publish_error();
                $app->run_callbacks( 'rebuild', $blog );
            }
        );
    }

    $entry;
}

1;

__END__

=head1 NAME

MT::DataAPI::Endpoint::Entry - Movable Type class for endpoint definitions about the MT::Entry.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
