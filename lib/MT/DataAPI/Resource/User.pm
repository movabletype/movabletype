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
        {   name    => 'userpicURL',
            alias   => 'userpic_url',
            default => undef,
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
    ];
}

1;
