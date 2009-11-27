package Net::OAuth::Response;
use warnings;
use strict;
use base qw/Net::OAuth::Message/;

__PACKAGE__->mk_classdata(required_message_params => [qw/
	token
    /]);

__PACKAGE__->mk_classdata(optional_message_params => [qw/
    /]);

__PACKAGE__->mk_classdata(required_api_params => [qw/
    /]);

__PACKAGE__->mk_classdata(optional_api_params => [qw/
	extra_params
	protocol_version
	/]);

__PACKAGE__->mk_classdata(signature_elements => [qw/
    /]);

__PACKAGE__->mk_classdata(all_message_params => [
    @{__PACKAGE__->required_message_params},
    @{__PACKAGE__->optional_message_params},
	]);

__PACKAGE__->mk_classdata(all_api_params => [
    @{__PACKAGE__->required_api_params},
    @{__PACKAGE__->optional_api_params},	
	]);
	
__PACKAGE__->mk_classdata(all_params => [
    @{__PACKAGE__->all_api_params},
    @{__PACKAGE__->all_message_params},	
	]);

__PACKAGE__->mk_accessors(
    @{__PACKAGE__->all_params},
    );

=head1 NAME

Net::OAuth::Response - base class for OAuth responses

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