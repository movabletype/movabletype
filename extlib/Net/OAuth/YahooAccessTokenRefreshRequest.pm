package Net::OAuth::YahooAccessTokenRefreshRequest;
use warnings;
use strict;
use base 'Net::OAuth::AccessTokenRequest';

__PACKAGE__->add_required_message_params(qw/session_handle/);
sub allow_extra_params {0}
sub sign_message {1}

=head1 NAME

Net::OAuth::YahooAccessTokenRefreshRequest - Yahoo OAuth Extension

=head1 SEE ALSO

L<http://developer.yahoo.com/oauth/guide/oauth-auth-flow.html>

=head1 AUTHOR

Originally by Keith Grennan <kgrennan@cpan.org>

Currently maintained by Robert Rothenberg <rrwo@cpan.org>

=head1 CONTRIBUTORS

Marc Mims

=head1 COPYRIGHT & LICENSE

Copyright 2007-2012, 2024-2025 Keith Grennan

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
