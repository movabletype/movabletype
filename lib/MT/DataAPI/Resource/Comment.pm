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
                my @commenter_ids = map { $_->commenter_id } @$objs;
                my %authors       = ();
                my @authors       = MT->model('author')
                    ->load( { id => [ grep {$_} @commenter_ids ], } );
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
        },
        $MT::DataAPI::Resource::Common::fields{status},
    ];
}

1;
