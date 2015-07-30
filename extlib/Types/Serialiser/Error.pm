=head1 NAME

Types::Serialiser::Error - dummy module for Types::Serialiser

=head1 SYNOPSIS

 # do not "use" yourself

=head1 DESCRIPTION

This module exists only to provide overload resolution for Storable and
similar modules that assume that class name equals module name. See
L<Types::Serialiser> for more info about this class.

=cut

use Types::Serialiser ();

=head1 AUTHOR

 Marc Lehmann <schmorp@schmorp.de>
 http://home.schmorp.de/

=cut

1

