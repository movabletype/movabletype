# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Resource::User::v2;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    [   qw(
            status
            name
            password
            language

            dateFormat
            textFormat
            tagDelimiter
            ),
    ];
}

sub fields {
    [   $MT::DataAPI::Resource::Common::fields{status},
        {   name        => 'password',
            from_object => sub { },      # Display nothing.
            to_object   => sub {
                my ( $hash, $obj ) = @_;
                my $pass = $hash->{password};
                if ( length $pass ) {
                    $obj->set_password($pass);
                }
                return;
            },
        },
        {   name        => 'language',
            alias       => 'preferred_language',
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
        qw(
            dateFormat
            textFormat
            ),
        {   name        => 'tagDelimiter',
            alias       => 'entry_prefs',
            from_object => sub {
                my ($obj) = @_;
                my $entry_prefs = $obj->entry_prefs;
                if ( defined($entry_prefs) && $entry_prefs eq ' ' ) {
                    return 'space';
                }
                else {
                    return 'comma';
                }
            },
            to_object => sub {
                my ($hash) = @_;
                my $delim;
                my $tag_delimiter = $hash->{tagDelimiter};
                if ( $tag_delimiter && lc($tag_delimiter) eq 'space' ) {
                    $delim = ord(' ');
                }
                else {
                    $delim = ord(',');
                }
                return "tag_delim=$delim";
            },
        },
        {   name        => 'isSuperuser',
            type        => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub {
                my ($obj) = @_;
                my $app  = MT->instance or return;
                my $user = $app->user   or return;

                if ( $user->is_superuser || ( $user->id == $obj->id ) ) {
                    return $obj->is_superuser;
                }
                else {
                    return;
                }
            },
        },
        {   name        => 'lockedOut',
            type        => 'MT::DataAPI::Resource::DataType::Boolean',
            from_object => sub {
                my ($obj) = @_;
                return $obj->locked_out;
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::User::v2 - Movable Type class for resources definitions of the MT::Authror.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
