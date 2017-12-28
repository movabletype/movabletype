package MT::DataAPI::Resource::v4::CategorySet;
use strict;
use warnings;

use MT::DataAPI::Resource;
use MT::DataAPI::Resource::Common;

sub updatable_fields {
    ['name'];
}

sub fields {
    [   'name',
        {   name => 'id',
            type => 'MT::DataAPI::Resource::DataType::Integer',
        },
        {   name  => 'content_type_count',
            alias => 'ct_count',
        },
        {   name        => 'categories',
            from_object => sub {
                my ($obj) = @_;
                my $cats = $obj->categories;
                MT::DataAPI::Resource->from_object( $cats,
                    [ 'id', 'parent', 'label', 'basename' ] );
            },
        },
        {   name             => 'updatable',
            type             => 'MT::DataAPI::Resource::DataType::Boolean',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;
                my $app  = MT->instance;
                my $user = $app->user or return;

                if ( $user->is_superuser ) {
                    $_->{updatable} = 1 for @$hashes;
                    return;
                }

                my %cache;
                for my $i ( 0 .. ( @$objs - 1 ) ) {
                    my $obj = $objs->[$i];
                    $hashes->[$i]{updatable} = $cache{ $obj->blog_id }
                        ||= $user->permissions( $obj->blog_id )
                        ->has('manage_category_set');
                }
            },
        },
        $MT::DataAPI::Resource::Common::fields{blog},
        $MT::DataAPI::Resource::Common::fields{createdDate},
        $MT::DataAPI::Resource::Common::fields{modifiedDate},
        $MT::DataAPI::Resource::Common::fields{createdBy},
        $MT::DataAPI::Resource::Common::fields{modifiedBy},
    ];
}

1;

