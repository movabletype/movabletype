package Net::OAuth::AccessTokenRequest;
use warnings;
use strict;
use base 'Net::OAuth::Request';

__PACKAGE__->add_required_message_params(qw/token/);
__PACKAGE__->add_required_api_params(qw/token_secret/);
sub allow_extra_params {0}
sub sign_message {1}

=head1 NAME

Net::OAuth::AccessTokenRequest - An OAuth protocol request for an Access Token

=head1 SEE ALSO

L<Net::OAuth>, L<http://oauth.net>

=head1 AUTHOR

Keith Grennan, C<< <kgrennan at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2007 Keith Grennan, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;