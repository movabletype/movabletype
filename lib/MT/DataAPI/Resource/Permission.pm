# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Permission;

use strict;
use warnings;

use MT::DataAPI::Resource::Common;

sub updatable_fields {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    [];
}

sub fields {
    require MT::Util::Deprecated;
    MT::Util::Deprecated::warning(since => '7.9');

    [   $MT::DataAPI::Resource::Common::fields{blog},
        {   name             => 'permissions',
            bulk_from_object => sub {
                my ( $objs, $hashs ) = @_;

                for ( my $i = 0; $i < scalar @$objs; $i++ ) {
                    my @restrictions = map { $_ =~ /'(.*?)'/ } split ',',
                        ( $objs->[$i]->restrictions || '' );
                    $hashs->[$i]{permissions} = [
                        sort grep {
                            my $p = $_;
                            !grep { $_ eq $p } @restrictions
                            } map { $_ =~ /'(.*)'/ } split ',',
                        ( $objs->[$i]->permissions || '' )
                    ];
                }
            },
            schema => {
                type => 'array',
                items => {
                    type => 'string',
                },
            },
        },
    ];
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::Permission - Movable Type class for resources definitions of the MT::Permission.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
