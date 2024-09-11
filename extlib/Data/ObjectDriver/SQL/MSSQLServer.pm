# $Id$

package Data::ObjectDriver::SQL::MSSQLServer;

use strict;
use base qw(Data::ObjectDriver::SQL);

sub as_escape {
    my ($stmt, $escape_char) = @_;
    return " ESCAPE {'$escape_char'}";
}

1;

__END__

=head1 NAME

Data::ObjectDriver::SQL::MSSQLServer

=head1 DESCRIPTION

This module overrides methods of the Data::ObjectDriver::SQL module
with Postgresql specific implementation.

=head1 LICENSE

I<Data::ObjectDriver::MSSQLServer> is free software; you may redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR & COPYRIGHT

Except where otherwise noted, I<Data::ObjectDriver::MSSQLServer> is Copyright 2005-2006
Six Apart, cpan@sixapart.com. All rights reserved.

=cut
