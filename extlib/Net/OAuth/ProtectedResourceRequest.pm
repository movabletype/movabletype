package Net::OAuth::ProtectedResourceRequest;
use warnings;
use strict;
use base 'Net::OAuth::AccessTokenRequest';

sub allow_extra_params {1}

=head1 NAME

Net::OAuth::RequestTokenRequest - An OAuth protocol request for a Protected Resource

=head1 SEE ALSO

L<Net::OAuth::Request>, L<http://oauth.net>

=head1 AUTHOR

Keith Grennan, C<< <kgrennan at cpan.org> >>

=head1 COPYRIGHT & LICENSE

Copyright 2007 Keith Grennan, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut


1;