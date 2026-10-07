package Net::OAuth::ConsumerRequest;
use warnings;
use strict;
use base 'Net::OAuth::Request';

sub allow_extra_params {1}
sub sign_message {1}

=head1 NAME

Net::OAuth::ConsumerRequest - An OAuth Consumer Request

=head1 NOTE

Consumer Requests are a proposed extension to OAuth, so other
OAuth implementations may or may not support them.

=head1 SEE ALSO

Consumer Request Extension Draft:

L<http://oauth.googlecode.com/svn/spec/ext/consumer_request/1.0/drafts/1/spec.html>

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
