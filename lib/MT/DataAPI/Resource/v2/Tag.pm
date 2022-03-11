# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::Tag;

use strict;
use warnings;

use boolean ();

use MT::Entry;
use MT::Tag;

sub updatable_fields {
    [   qw(
            name
            ),
    ];
}

sub fields {
    [   qw(
            id
            name
            ),
        {   name        => 'normalizedName',
            from_object => sub {
                my ($obj) = @_;
                return MT::Tag->normalize( $obj->name );
            },
        },
        {   name  => 'isPrivate',
            alias => 'is_private',
            type  => 'MT::DataAPI::Resource::DataType::Boolean',
        },
        {   name        => 'entryCount',
            from_object => sub {
                my ($obj) = @_;
                return _object_count( $obj, 'entry' );
            },
        },
        {   name        => 'pageCount',
            from_object => sub {
                my ($obj) = @_;
                return _object_count( $obj, 'page' );
            },
        },
        {   name        => 'assetCount',
            from_object => sub {
                my ($obj) = @_;
                my $app = MT->instance;

                my $blog_id = $app->param('site_id');

                # Check whether blog_id is valid or not.
                if ( defined($blog_id) && $blog_id !~ m/^\d+$/ ) {
                    return 0;
                }
                if ( $blog_id && !MT->model('blog')->load($blog_id) ) {
                    return 0;
                }

                my $count = MT->model('objecttag')->count(
                    {   ( defined($blog_id) ? ( blog_id => $blog_id ) : () ),
                        tag_id            => $obj->id,
                        object_datasource => 'asset',
                    },
                );

                return $count + 0;
            },
        },
        {   name        => 'updatable',
            type        => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub {
                my ($obj) = @_;
                my $app = MT->instance;
                my $user = $app->user or return;
                return 1 if $user->is_superuser;

                if ( $app->blog && $app->blog->id ) {
                    my $perms = $user->permissions( $app->blog->id );
                    return $perms->can_do('edit_tags')
                        && $perms->can_do('rename_tag');
                }
                else {
                    return $user->permissions(0)->can_do('administer');
                }
            },
        },
    ];
}

sub _object_count {
    my ( $obj, $class ) = @_;
    my $app  = MT->instance;
    my $user = $app->user;

    my $blog_id = $app->param('site_id');

    # Check whether blog_id is valid or not.
    if ( defined($blog_id) && $blog_id !~ m/^\d+$/ ) {
        return 0;
    }
    if ( $blog_id && !MT->model('blog')->load($blog_id) ) {
        return 0;
    }

    # Count.
    my $count;

    if ( defined($blog_id) || $user->is_superuser ) {
        my $perms = defined($blog_id) ? $user->permissions($blog_id) : undef;

        my $restrict_entries;
        if ( !$user->is_superuser ) {
            if ( $class eq 'entry' ) {
                $restrict_entries = ( $perms->can_do('publish_all_entry')
                        || $perms->can_do('edit_all_entries') ) ? 1 : 0;
            }
            elsif ( $class eq 'page' ) {
                $restrict_entries = $perms->can_do('manage_pages') ? 1 : 0;
            }
        }

        my $join_terms;
        if ($restrict_entries) {
            $join_terms = [
                {   id    => \'= objecttag_object_id',
                    class => $class,
                },
                '-and',
                [   { status => MT::Entry::RELEASE() },
                    '-or',
                    { author_id => $user->id },
                ],
            ];
        }
        else {
            $join_terms = {
                id    => \'= objecttag_object_id',
                class => $class,
            };
        }

        $count = MT->model('objecttag')->count(
            {   tag_id            => $obj->id,
                object_datasource => 'entry',
                defined($blog_id) ? ( blog_id => $blog_id ) : (),
            },
            { join => MT->model($class)->join_on( undef, $join_terms ) },
        );

    }
    else {

        my $join_terms;

        my @permitted_blog_ids;
        if ( $user->id ) {
            my @perms
                = MT->model('permission')->load( { author_id => $user->id } );
            if ( $class eq 'entry' ) {
                @permitted_blog_ids = map { $_->blog_id } grep {
                           $_->can_do('publish_all_entry')
                        || $_->can_do('edit_all_entries')
                } @perms;
            }
            elsif ( $class eq 'page' ) {
                @permitted_blog_ids = map { $_->blog_id }
                    grep { $_->can_do('manage_pages') } @perms;
            }
        }

        if (@permitted_blog_ids) {
            $join_terms = [
                {   id    => \'= objecttag_object_id',
                    class => $class,
                },
                '-and',
                [   { blog_id => \@permitted_blog_ids },
                    '-or',
                    [   { blog_id => { not => \@permitted_blog_ids } },
                        '-and',
                        [   { status => MT::Entry::RELEASE() },
                            '-or',
                            { author_id => $user->id },
                        ],
                    ],
                ],
            ];
        }
        else {
            $join_terms = [
                {   id    => \'= objecttag_object_id',
                    class => $class,
                },
                '-and',
                [   { status => MT::Entry::RELEASE() },
                    '-or',
                    { author_id => $user->id },
                ],
            ];
        }

        $count = MT->model('objecttag')->count(
            {   tag_id            => $obj->id,
                object_datasource => 'entry',
            },
            { join => MT->model($class)->join_on( undef, $join_terms ) },
        );

    }

    return $count + 0;
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Tag - Movable Type class for resources definitions of the MT::Tag.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
