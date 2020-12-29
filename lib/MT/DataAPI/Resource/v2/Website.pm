# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::v2::Website;

use strict;
use warnings;

use base qw(MT::DataAPI::Resource::v2::Blog);

sub updatable_fields {
    $_[0]->SUPER::updatable_fields();
}

sub fields {
    [   @{ $_[0]->SUPER::fields() },

        {   name      => 'url',
            alias     => 'site_url',
            to_object => sub {
                my ( $hash, $obj ) = @_;
                return $hash->{url} if _can_save_website_pathinfo($obj);
                return;
            },
        },
        {   name      => 'sitePath',
            to_object => sub {
                my ( $hash, $obj ) = @_;
                return $hash->{sitePath} if _can_save_website_pathinfo($obj);
                return;
            },
            condition => sub { __PACKAGE__->SUPER::_can_view() },
        },
        {   name      => 'archiveUrl',
            to_object => sub {
                my ( $hash, $obj ) = @_;
                return $hash->{archiveUrl}
                    if _can_save_website_pathinfo($obj);
                return;
            },
        },
        {   name      => 'archivePath',
            to_object => sub {
                my ( $hash, $obj ) = @_;
                return $hash->{archivePath}
                    if _can_save_website_pathinfo($obj);
                return;
            },
            condition => sub { __PACKAGE__->SUPER::_can_view() },
        },
    ];
}

sub _can_save_website_pathinfo {
    my ($obj) = @_;
    my $app  = MT->instance or return;
    my $user = $app->user   or return;

    return 1 if $user->is_superuser;

    if ( $obj->id ) {
        my $perms = $app->permissions or return;
        return 1
            if $perms->can_do('save_all_settings_for_website')
            || $app->can_do('save_blog_pathinfo');
    }

    return;
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::v2::Website - Movable Type class for resources definitions of the MT::Website.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
