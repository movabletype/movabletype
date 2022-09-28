# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::DataAPI::Resource::Util;

use strict;
use warnings;

sub int_param {
    my ( $app, $key ) = @_;

    return undef unless $app->can('param');

    my $value = $app->param($key);
    ( defined($value) && $value =~ m/^\d+$/ ) ? int($value) : undef;
}

1;

__END__

=head1 NAME

MT::DataAPI::Resource::Util - Movable Type class for utility resource.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
