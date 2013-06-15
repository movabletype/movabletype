package MT::DataAPI::Resource::Comment;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [   qw(
            body
            parent
            status
            )
    ];
}

sub fields {
    [   {   name             => 'author',
            bulk_from_object => sub {
                my ( $objs, $hashs ) = @_;
                my @commenter_ids = grep {$_} map { $_->commenter_id } @$objs;
                my %authors = ();
                my @authors
                    = @commenter_ids
                    ? MT->model('author')->load( { id => \@commenter_ids, } )
                    : ();
                $authors{ $_->id } = $_ for @authors;

                my $size = scalar(@$objs);
                for ( my $i = 0; $i < $size; $i++ ) {
                    my $c = $objs->[$i];
                    my $a
                        = $commenter_ids[$i]
                        ? $authors{ $commenter_ids[$i] }
                        : undef;
                    if ($a) {
                        $hashs->[$i]{author}
                            = MT::DataAPI::Resource->from_object($a);
                    }
                    else {
                        $hashs->[$i]{author} = {
                            id          => undef,
                            displayName => $c->author,
                            userpicURL  => undef,
                            language    => undef,
                        };
                    }
                }
            },
        },
        {   name        => 'entry',
            from_object => sub {
                my ($obj) = @_;
                +{ id => $obj->entry_id, };
            },
        },
        {   name        => 'blog',
            from_object => sub {
                my ($obj) = @_;
                +{ id => $obj->blog_id, };
            },
        },
        {   name => 'id',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        {   name  => 'date',
            alias => 'created_on',
            type  => 'MT::DataAPI::Resource::DataType::ISO8601',
        },
        {   name  => 'body',
            alias => 'text',
        },
        {   name        => 'link',
            from_object => sub {
                my ($obj) = @_;
                $obj->permalink;
            },
        },
        {   name  => 'parent',
            alias => 'parent_id',
            type  => 'MT::DataAPI::Resource::DataType::Integer',
        },
        $MT::DataAPI::Resource::Common::fields{status},
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

                my %blog_perms = ();
                my %entries    = ();
                my @entry_ids  = grep {$_} map { $_->entry_id } @$objs;
                my @entries
                    = @entry_ids
                    ? MT->model('entry')->load( { id => \@entry_ids, } )
                    : ();
                $entries{ $_->id } = $_ for @entries;

                for ( my $i = 0; $i < scalar @$objs; $i++ ) {
                    my $obj = $objs->[$i];

                    my ( $perms, $entry );
                    $perms = $blog_perms{ $obj->blog_id }
                        ||= $user->blog_perm( $obj->blog_id );
                    $entry = $entries{ $obj->entry_id };

                    $hashs->[$i]{updatable}
                        = $perms
                        && $entry
                        && (
                        $app->can_do(
                            'open_all_comment_edit_screen', $perms
                        )
                        || ($app->can_do(
                                'open_own_entry_comment_edit_screen', $perms )
                            && $entry
                            && $user->id == $entry->author_id
                        )
                        );
                }
            },
        },
    ];
}

1;
