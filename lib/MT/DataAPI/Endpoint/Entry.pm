# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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

    my ( $primary_category_old, $categories_old, $categories_old_ids );
    if ( $orig_entry->id ) {
        $primary_category_old = $orig_entry->category;
        $categories_old       = $orig_entry->categories;
        $categories_old_ids   = join( ',', map { $_->id } @$categories_old );
    }

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
                            ? ( BuildDependencies => 1,
                                OldEntry          => $orig_entry,
                                OldPrevious       => ( $previous_old ? $previous_old->id : undef ),
                                OldNext           => ( $next_old ? $next_old->id : undef ),
                                OldDate           => $orig_entry->authored_on,
                                )
                            : ( BuildIndexes => 1 )
                        ),
                        OldCategories => $categories_old_ids,
                    ) or return $app->publish_error();
                    $app->run_callbacks( 'rebuild', $blog );
                    $app->run_callbacks('post_build');
                    $app->publisher->remove_marked_files( $blog, 1 );
                    1;
                }
            );
            return unless $res;

            if ( MT->has_plugin('Trackback') ) {
                my $list = $app->needs_ping(
                    Entry     => $entry,
                    Blog      => $blog,
                    OldStatus => $orig_entry->status,
                );
                require MT::Entry;
                if ( $entry->status == MT::Entry::RELEASE() && $list ) {
                    require Trackback::CMS::Entry;
                    Trackback::CMS::Entry::do_send_pings(
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
        }
    };
}

sub list_openapi_spec {
    +{
        tags        => ['Entries'],
        summary     => 'Retrieve a list of entries',
        description => <<'DESCRIPTION',
Retrieve a list of entries.

Authorization is required to include unpublished entries.
DESCRIPTION
        parameters => [{
                'in'        => 'query',
                name        => 'search',
                schema      => { type => 'string' },
                description => 'This is an optional parameter. Search query.',
            },
            {
                'in'        => 'query',
                name        => 'searchFields',
                schema      => { type => 'string' },
                description => "This is an optional parameter. The comma separated field name list to search. Default is 'title,body,more,keywords,excerpt,basename'",
            },
            {
                'in'   => 'query',
                name   => 'status',
                schema => {
                    type => 'string',
                    enum => [
                        'Draft',
                        'Publish',
                        'Review',
                        'Future',
                        'Spam',
                    ],
                },
                description => <<'DESCRIPTION',
This is an optional parameter. Filter by status.

#### Draft

entry_status is 1.

#### Publish

entry_status is 2.

#### Review

entry_status is 3.

#### Future

entry_status is 4.

#### Spam

entry_status is 5.
DESCRIPTION
            },
            {
                'in'        => 'query',
                name        => 'limit',
                schema      => { type => 'integer' },
                description => 'This is an optional parameter. Maximum number of entries to retrieve. Default is 10. ',
            },
            {
                'in'        => 'query',
                name        => 'offset',
                schema      => { type => 'integer' },
                description => 'This is an optional parameter. 0-indexed offset. Default is 0.',
            },
            {
                'in'        => 'query',
                name        => 'includeIds',
                schema      => { type => 'string' },
                description => 'This is an optional parameter. The comma separated ID list of entries to include to result. ',
            },
            {
                'in'        => 'query',
                name        => 'excludeIds',
                schema      => { type => 'string' },
                description => 'This is an optional parameter. The comma separated ID list of entries to exclude from result. ',
            },
            {
                'in'   => 'query',
                name   => 'sortBy',
                schema => {
                    type => 'string',
                    enum => [
                        'authored_on',
                        'title',
                        'created_on',
                        'modified_on',
                    ],
                },
                description => <<'DESCRIPTION',
This is an optional parameter.

#### authored_on

(default) Sort by the Published time of each entries.

#### title

Sort by the title of each entries.

#### created_on

Sort by the created time of each entries.

#### modified_on

Sort by the modified time of each entries.
DESCRIPTION
            },
            {
                'in'   => 'query',
                name   => 'sortOrder',
                schema => {
                    type => 'string',
                    enum => [
                        'descend',
                        'ascend',
                    ],
                },
                description => <<'DESCRIPTION',
This is an optional parameter.

#### descend

(default) Return entries in descending order. For the date, it means from newest to oldest.

#### ascend

Return entries in ascending order. For the date, it means from oldest to newset.
DESCRIPTION
            },
            {
                'in'        => 'query',
                name        => 'maxComments',
                schema      => { type => 'integer' },
                description => 'This is an optional parameter. Maximum number of comments to retrieve as part of the Entries resource. If this parameter is not supplied, no comments will be returned.',
            },
            {
                'in'        => 'query',
                name        => 'maxTrackbacks',
                schema      => { type => 'integer' },
                description => 'This is an optional parameter. Maximum number of received trackbacks to retrieve as part of the Entries resource. If this parameter is not supplied, no trackbacks will be returned. ',
            },
            {
                'in'        => 'query',
                name        => 'fields',
                schema      => { type => 'string' },
                description => 'The field list to retrieve as part of the Entries resource. That list should be separated by comma. If this parameter is not specified, All fields will be returned. ',
            },
        ],
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            type       => 'object',
                            properties => {
                                totalResults => {
                                    type        => 'integer',
                                    description => ' The total number of entries.',
                                },
                                items => {
                                    type        => 'array',
                                    description => 'An array of Entries resource. ',
                                    items       => {
                                        '$ref' => '#/components/schemas/entry',
                                    }
                                },
                            },
                        },
                    },
                },
            },
            404 => {
                description => 'Not Found',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub list {
    my ( $app, $endpoint ) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    my $res = filtered_list( $app, $endpoint, 'entry' ) or return;

    +{  totalResults => $res->{count} + 0,
        items =>
            MT::DataAPI::Resource::Type::ObjectList->new( $res->{objects} ),
    };
}

sub create_openapi_spec {
    +{
        tags        => ['Entries'],
        summary     => 'Create a new entry',
        description => <<'DESCRIPTION',
Create a new entry.

Authorization is required.
DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            entry => {
                                '$ref' => '#/components/schemas/entry_updatable',
                            },
                        },
                    },
                },
            },
        },
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/entry',
                        },
                    },
                },
            },
            404 => {
                description => 'Not Found',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub create {
    my ( $app, $endpoint ) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

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

sub get_openapi_spec {
    +{
        tags        => ['Entries'],
        summary     => 'Retrieve a single entry by its ID',
        description => <<'DESCRIPTION',
Retrieve a single entry by its ID.

Authorization is required if the entry status is "unpublished". If the entry status is "published", then this method can be called without authorization.
DESCRIPTION
        parameters => [{
                'in'        => 'query',
                name        => 'maxComments',
                schema      => { type => 'integer' },
                description => 'This is an optional parameter. Maximum number of comments to retrieve as part of the Entries resource. If this parameter is not supplied, no comments will be returned.',
            },
            {
                'in'        => 'query',
                name        => 'maxTrackbacks',
                schema      => { type => 'integer' },
                description => 'This is an optional parameter. Maximum number of received trackbacks to retrieve as part of the Entries resource. If this parameter is not supplied, no trackbacks will be returned. ',
            },
            {
                'in'        => 'query',
                name        => 'fields',
                schema      => { type => 'string' },
                description => 'This is an optional parameter. The field list to retrieve as part of the Entries resource. That list should be separated by commma. If this parameter is not specified, All fields will be returned. ',
            },
        ],
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/entry',
                        }
                    },
                },
            },
            404 => {
                description => 'Not Found',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub get {
    my ( $app, $endpoint ) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    my ( $blog, $entry ) = context_objects(@_)
        or return;

    run_permission_filter( $app, 'data_api_view_permission_filter',
        'entry', $entry->id, obj_promise($entry) )
        or return;

    $entry;
}

sub update_openapi_spec {
    +{
        tags        => ['Entries'],
        summary     => 'Update an entry',
        description => <<'DESCRIPTION',
Update an entry.

Authorization is required.

DESCRIPTION
        requestBody => {
            content => {
                'application/x-www-form-urlencoded' => {
                    schema => {
                        type       => 'object',
                        properties => {
                            entry => {
                                '$ref' => '#/components/schemas/entry_updatable',
                            },
                        },
                    },
                },
            },
        },
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/entry',
                        },
                    },
                },
            },
            404 => {
                description => 'Not Found',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub update {
    my ( $app, $endpoint ) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

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

sub delete_openapi_spec {
    +{
        tags        => ['Entries'],
        summary     => 'Delete an entry',
        description => <<'DESCRIPTION',
Delete an entry.

Authorization is required.

DESCRIPTION
        responses => {
            200 => {
                description => 'OK',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/entry',
                        },
                    },
                },
            },
            404 => {
                description => 'Not Found',
                content     => {
                    'application/json' => {
                        schema => {
                            '$ref' => '#/components/schemas/ErrorContent',
                        },
                    },
                },
            },
        },
    };
}

sub delete {
    my ( $app, $endpoint ) = @_;

    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

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
                $app->publisher->remove_marked_files( $blog, 1 );
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
