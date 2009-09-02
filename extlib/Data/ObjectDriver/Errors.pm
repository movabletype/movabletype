# $Id: Errors.pm 270 2006-08-25 23:24:16Z mpaschal $

package Data::ObjectDriver::Errors;
use strict;
use warnings;

use constant UNIQUE_CONSTRAINT => 1;

1;

__END__

=head1 NAME

Data::ObjectDriver::Errors - container class for common database error codes

=head1 SYNOPSIS

    eval { $driver->insert($obj); };
    if ($@ && $driver->last_error() == Data::ObjectDriver::Errors->UNIQUE_CONSTRAINT) {
        ...

=head1 DESCRIPTION

I<Data::ObjectDriver::Errors> is a container class for error codes resulting
from DBI database operations. Database drivers can map particular database
servers' DBI errors to these constants with their C<map_error_code> methods.

=head1 DEFINED ERROR CODES

=over 4

=item * C<UNIQUE_CONSTRAINT>

The application issued an insert or update that would violate the uniqueness
constraint on a particular column, such as attempting to save a duplicate value
to an indexed key field.

=back

=head1 SEE ALSO

C<Data::ObjectDriver::Driver::DBD::map_error_code>

=head1 LICENSE

I<Data::ObjectDriver> is free software; you may redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR & COPYRIGHT

Except where otherwise noted, I<Data::ObjectDriver> is Copyright 2005-2006
Six Apart, cpan@sixapart.com. All rights reserved.

=cut

