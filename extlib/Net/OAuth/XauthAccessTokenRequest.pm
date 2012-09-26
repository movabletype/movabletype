package Net::OAuth::XauthAccessTokenRequest;
use warnings;
use strict;
use base 'Net::OAuth::Request';

__PACKAGE__->add_extension_param_pattern(qr/x_auth_/);
__PACKAGE__->add_required_message_params(qw/x_auth_username x_auth_password x_auth_mode/);
sub allow_extra_params {0}
sub sign_message {1}

=head1 NAME

Net::OAuth::xAuthAccessTokenRequest - xAuth extension

=head1 SEE ALSO

L<http://apiwiki.twitter.com/Twitter-REST-API-Method:-oauth-access_token-for-xAuth>

=head1 AUTHOR

Keith Grennan, C<< <kgrennan at cpan.org> >>

=head1 CONTRIBUTORS

Masayoshi Sekimura

Simon Wistow

=head1 COPYRIGHT & LICENSE

Copyright 2010 Keith Grennan, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;