# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Entry;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;
use MT::DataAPI::Resource::Util;

sub updatable_fields {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    [   qw(
            status
            title
            body
            more
            excerpt
            keywords
            tags
            ),
        {   name      => 'date',
            condition => sub {
                MT->instance->can_do('edit_entry_authored_on');
            },
        },
        {   name      => 'basename',
            condition => sub {
                MT->instance->can_do('edit_entry_basename');
            },
        }
    ];
}

sub fields {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    [   {   name   => 'author',
            fields => [qw(id displayName userpicUrl)],
            type   => 'MT::DataAPI::Resource::DataType::Object',
        },
        $MT::DataAPI::Resource::Common::fields{blog},
        {   name        => 'categories',
            from_object => sub {
                my ($obj) = @_;
                my $rows = $obj->__load_category_data or return;

                my $primary = do {
                    my @rows = grep { $_->[1] } @$rows;
                    @rows ? $rows[0]->[0] : 0;
                };

                my $cats = MT::Category->lookup_multi(
                    [ map { $_->[0] } @$rows ] );

                [   map { $_->category_label_path } sort {
                              $a->id == $primary ? -1
                            : $b->id == $primary ? 1
                            : $a->label cmp $b->label
                    } @$cats
                ];
            },
            schema => {
                type  => 'array',
                items => {
                    type => 'string',
                },
            },
        },
        {   name => 'id',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        'class',
        {   name        => 'status',
            from_object => sub {
                my ($obj) = @_;
                MT::Entry::status_text( $obj->status );
            },
            to_object => sub {
                my ($hash) = @_;
                MT::Entry::status_int( $hash->{status} );
            },
        },
        {   name                => 'title',
            from_object_default => '',
        },
        {   name                => 'body',
            alias               => 'text',
            from_object_default => '',
        },
        {   name                => 'more',
            alias               => 'text_more',
            from_object_default => '',
        },
        {   name        => 'excerpt',
            from_object => sub {
                my ($obj) = @_;
                $obj->get_excerpt;
            },
        },
        {   name                => 'keywords',
            from_object_default => '',
        },
        'basename',
        'permalink',
        {   name  => 'date',
            alias => 'authored_on',
            type  => 'MT::DataAPI::Resource::DataType::ISO8601',
        },
        {   name  => 'createdDate',
            alias => 'created_on',
            type  => 'MT::DataAPI::Resource::DataType::ISO8601',
        },
        {   name  => 'modifiedDate',
            alias => 'modified_on',
            type  => 'MT::DataAPI::Resource::DataType::ISO8601',
        },
        {   name        => 'assets',
            from_object => sub {
                my ($obj) = @_;
                MT::DataAPI::Resource->from_object( $obj->assets );
            },
            schema => {
                type  => 'array',
                items => { '$ref' => '#/components/schemas/asset' },
            },
        },
        $MT::DataAPI::Resource::Common::fields{tags},
        {   name             => 'updatable',
            type             => 'MT::DataAPI::Resource::DataType::Boolean',
            bulk_from_object => sub {
                my ( $objs, $hashs ) = @_;
                my $app  = MT->instance;
                my $user = $app->user;

                if ( $user->is_superuser ) {
                    $_->{updatable} = 1 for @$hashs;
                    return;
                }

                my %blog_perms;

                for ( my $i = 0; $i < scalar @$objs; $i++ ) {
                    my $obj  = $objs->[$i];
                    my $type = $obj->class_type;

                    my $perms;
                    $perms = $blog_perms{ $obj->blog_id }
                        ||= $user->blog_perm( $obj->blog_id );

                    $hashs->[$i]{updatable}
                        = (    ( 'entry' eq $type )
                            && $perms
                            && $perms->can_edit_entry( $obj, $user ) )
                        || (
                           ( 'page' eq $type )
                        && $perms
                        && (  $user->id == $obj->author_id
                            ? $perms->can_do('edit_own_page')
                            : $perms->can_do('edit_all_pages')
                        )
                        );
                }
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::Entry - Movable Type class for resources definitions of the MT::Entry.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
