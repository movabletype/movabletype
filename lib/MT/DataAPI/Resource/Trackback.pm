package MT::DataAPI::Resource::Trackback;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [   qw(
            status
            )
    ];
}

sub fields {
    [   {   name        => 'blog',
            from_object => sub {
                my ($obj) = @_;
                +{ id => $obj->blog_id, };
            },
        },
        {   name             => 'entry',
            bulk_from_object => sub {
                my ( $objs, $hashs ) = @_;
                my %parents = ();
                my @parents = MT->model('trackback')
                    ->load( { id => [ map { $_->tb_id } @$objs ], } );
                $parents{ $_->id } = $_ for @parents;

                my $size = scalar(@$objs);
                for ( my $i = 0; $i < $size; $i++ ) {
                    my $p = $parents{ $objs->[$i]->tb_id } || undef;

                    $hashs->[$i]{entry} = $p
                        && $p->entry_id ? +{ id => $p->entry_id } : undef;
                }
            },
        },
        'id',
        {   name  => 'date',
            alias => 'created_on',
            type  => 'MT::DataAPI::Resource::DataType::ISO8601',
        },
        'title',
        'excerpt',
        {   name  => 'blogName',
            alias => 'blog_name',
        },
        {   name  => 'url',
            alias => 'source_url',
        },
        'ip',
        $MT::DataAPI::Resource::Common::fields{status},
    ];
}

1;
