package Net::OAuth::V1_0A::AccessTokenRequest;
use warnings;
use strict;
use base 'Net::OAuth::AccessTokenRequest';

__PACKAGE__->add_required_message_params(qw/verifier/);

=head1 NAME

Net::OAuth::V1_0A::AccessTokenRequest - An OAuth protocol request for an Access Token

=head1 SEE ALSO

L<Net::OAuth>, L<http://oauth.net>

=head1 AUTHOR

Originally by Keith Grennan <kgrennan@cpan.org>

Currently maintained by Robert Rothenberg <rrwo@cpan.org>

=head1 COPYRIGHT & LICENSE

Copyright 2007-2012, 2024-2025 Keith Grennan

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
