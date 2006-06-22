# ======================================================================
#
# Copyright (C) 2000-2004 Paul Kulchenko (paulclinger@yahoo.com)
#
# SOAP::Lite is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# $Id: Constants.pm,v 1.1 2004/10/12 18:47:55 byrnereese Exp $
#
# ======================================================================

=pod

=head1 NAME

SOAP::Constants - SOAP::Lite provides several variables to allows programmers and users to modify the behavior of SOAP::Lite in specific ways.

=head1 DESCRIPTION

A number of "constant" values are provided by means of this namespace. The values aren't constants in the strictest sense; the purpose of the values detailed here is to allow the application to change them if it desires to alter the specific behavior governed. 

=head1 CONSTANTS

=head2 $DO_NOT_USE_XML_PARSER

The SOAP::Lite package attempts to locate and use the L<XML::Parser> package, falling back on an internal, pure-Perl parser in its absence. This package is a fast parser, based on the Expat parser developed by James Clark. If the application sets this value to 1, there will be no attempt to locate or use XML::Parser. There are several reasons you might choose to do this. If the package will never be made available, there is no reason to perform the test. Setting this parameter is less time-consuming than the test for the package would be. Also, the XML::Parser code links against the Expat libraries for the C language. In some environments, this could cause a problem when mixed with other applications that may be linked against a different version of the same libraries. This was once the case with certain combinations of Apache, mod_perl and XML::Parser.

=head2 $DO_NOT_USE_CHARSET

Unless this parameter is set to 1, outgoing Content-Type headers will include specification of the character set used in encoding the message itself. Not all endpoints (client or server) may be able to properly deal with that data on the content header, however. If dealing with an endpoint that expects to do a more literal examination of the header as whole (as opposed to fully parsing it), this parameter may prove useful.

=head2 $DO_NOT_CHECK_CONTENT_TYPE

The content-type itself for a SOAP message is rather clearly defined, and in most cases, an application would have no reason to disable the testing of that header. This having been said, the content-type for SOAP 1.2 is still only a recommended draft, and badly coded endpoints might send valid messages with invalid Content-Type headers. While the "right" thing to do would be to reject such messages, that isn't always an option. Setting this parameter to 1 allows the toolkit to skip the content-type test.

=head2 $PATCH_HTTP_KEEPALIVE

SOAP::Lite's HTTP Transport module attempts to provide a simple patch to
LWP::Protocol to enable HTTP Keep Alive. By default, this patch is turned
off, if however you would like to turn on the experimental patch change the
constant like so:

  $SOAP::Constants::PATCH_HTTP_KEEPALIVE = 1;

=head1 ACKNOWLEDGEMENTS

Special thanks to O'Reilly publishing which has graciously allowed SOAP::Lite to republish and redistribute large excerpts from I<Programming Web Services with Perl>, mainly the SOAP::Lite reference found in Appendix B.

=head1 COPYRIGHT

Copyright (C) 2000-2004 Paul Kulchenko. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHORS

Paul Kulchenko (paulclinger@yahoo.com)

Randy J. Ray (rjray@blackperl.com)

Byrne Reese (byrne@majordojo.com)

=cut
