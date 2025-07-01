package Net::OAuth::AccessTokenResponse;
use warnings;
use strict;
use base 'Net::OAuth::Response';

__PACKAGE__->add_required_message_params(qw/token_secret/);
sub allow_extra_params {1}

=head1 NAME

Net::OAuth::AccessTokenResponse - An OAuth protocol response for an Access Token

=head1 SEE ALSO

L<Net::OAuth>, L<http://oauth.net>

=head1 AUTHOR

Originally by Keith Grennan <kgrennan@cpan.org>

Currently maintained by Robert Rothenberg <rrwo@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright 2007-2012, 2024-2025 Keith Grennan

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
