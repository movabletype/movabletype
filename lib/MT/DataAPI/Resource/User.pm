package MT::DataAPI::Resource::User;

use strict;
use warnings;

sub updatable_fields {
    [qw(displayName)];
}

sub fields {
    [   'id',
        {   name  => 'displayName',
            alias => 'nickname',
        },
        {   name                => 'userpicURL',
            alias               => 'userpic_url',
            from_object_default => undef,
        },
        {   name        => 'language',
            from_object => sub {
                my ($obj) = @_;
                my $l = $obj->preferred_language;
                if ( !$l ) {
                    my $cfg = MT->config;
                    $l = $cfg->DefaultUserLanguage
                        || $cfg->DefaultLanguage;
                }
                $l =~ s/_/-/g;
                lc $l;
            },
        },
        {   name             => 'updatable',
            type             => 'MT::DataAPI::Resource::DataType::Boolean',
            bulk_from_object => sub {
                my ( $objs, $hashs ) = @_;
                my $app          = MT->instance;
                my $user         = $app->user;
                my $is_superuser = $user->is_superuser;

                for ( my $i = 0; $i < scalar @$objs; $i++ ) {
                    my $obj = $objs->[$i];

                    $hashs->[$i]{updatable}
                        = $is_superuser || $user->id == $obj->id;
                }
            },
        },
    ];
}

1;
