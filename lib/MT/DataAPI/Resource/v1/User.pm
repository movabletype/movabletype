# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v1::User;

use strict;
use warnings;

sub updatable_fields {
    [qw(displayName email url)];
}

sub _private_bulk_from_object {
    my ( $key, $column ) = @_;

    sub {
        my ( $objs, $hashs ) = @_;
        my $app          = MT->instance;
        my $user         = $app->user or return;
        my $is_superuser = $user->is_superuser;
        for ( my $i = 0; $i < scalar @$objs; $i++ ) {
            my $obj = $objs->[$i];

            $hashs->[$i]{$key} = $obj->$column
                if $is_superuser || $user->id == $obj->id;
        }
    };
}

sub fields {
    [   {   name             => 'id',
            bulk_from_object => _private_bulk_from_object( 'id', 'id' ),
        },
        {   name             => 'name',
            bulk_from_object => _private_bulk_from_object( 'name', 'name' ),
        },
        {   name  => 'displayName',
            alias => 'nickname',
        },
        {   name             => 'email',
            bulk_from_object => _private_bulk_from_object( 'email', 'email' ),
        },
        'url',
        {   name                => 'userpicUrl',
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
                my $app  = MT->instance;
                my $user = $app->user;

                if ( $user->is_superuser ) {
                    $_->{updatable} = 1 for @$hashs;
                    return;
                }

                for ( my $i = 0; $i < scalar @$objs; $i++ ) {
                    my $obj = $objs->[$i];

                    $hashs->[$i]{updatable} = $user->id == $obj->id;
                }
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v1::User - Movable Type class for resources definitions of the MT::Authror.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
