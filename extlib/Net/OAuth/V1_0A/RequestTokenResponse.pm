package Net::OAuth::V1_0A::RequestTokenResponse;
use warnings;
use strict;
use base 'Net::OAuth::RequestTokenResponse';

__PACKAGE__->add_required_message_params(qw/callback_confirmed/);

=head1 NAME

Net::OAuth::V1_0A::RequestTokenResponse - An OAuth protocol response for an Request Token

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