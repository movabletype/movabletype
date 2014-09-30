# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::DataAPI::Resource::User::v2;

use strict;
use warnings;

use boolean ();

sub updatable_fields {
    [];
}

sub fields {
    [   {   name             => 'isSuperuser',
            bulk_from_object => sub {
                my ( $objs, $hashes ) = @_;
                my $app  = MT->instance or return;
                my $user = $app->user   or return;

                if ( $user->is_superuser ) {
                    for my $i ( 0 .. scalar(@$objs) - 1 ) {
                        $hashes->[$i]->{isSuperuser}
                            = $objs->[$i]->is_superuser
                            ? boolean::true()
                            : boolean::false();
                    }
                    return;
                }

                for my $i ( 0 .. scalar(@$objs) - 1 ) {
                    if ( $user->id == $objs->[$i]->id ) {
                        $hashes->[$i]->{isSuperuser}
                            = $objs->[$i]->is_superuser
                            ? boolean::true()
                            : boolean::false();
                    }
                }

                return;
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
