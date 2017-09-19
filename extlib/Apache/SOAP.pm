# ======================================================================
#
# Copyright (C) 2000-2001 Paul Kulchenko (paulclinger@yahoo.com)
# SOAP::Lite is free software; you can redistribute it
# and/or modify it under the same terms as Perl itself.
#
# ======================================================================

package Apache::SOAP;

use strict;
use vars qw(@ISA $VERSION);
use SOAP::Transport::HTTP;

@ISA = qw(SOAP::Transport::HTTP::Apache);
our $VERSION = 1.17;

my $server = __PACKAGE__->new;

sub server {
    return $server;
}

sub handler {
  $server->configure(@_);
  $server->SUPER::handler(@_);
}

# ======================================================================

1;

__END__

=head1 NAME

Apache::SOAP - mod_perl-based SOAP server with minimum configuration

=head1 SYNOPSIS

=over 4

=item httpd.conf (Location), directory-based access

  <Location /mod_soap>
    SetHandler perl-script
    PerlHandler Apache::SOAP
    PerlSetVar dispatch_to "/Your/Path/To/Deployed/Modules, Module::Name, Module::method"
    PerlSetVar options "compress_threshold => 10000"
  </Location>

=item httpd.conf (Files), file-based access

  <FilesMatch "\.soap$">
    SetHandler perl-script
    PerlHandler Apache::SOAP
    PerlSetVar dispatch_to "/Your/Path/To/Deployed/Modules, Module::Name, Module::method"
    PerlSetVar options "compress_threshold => 10000"
  </FilesMatch>

=item .htaccess, directory-based access

  SetHandler perl-script
  PerlHandler Apache::SOAP
  PerlSetVar dispatch_to "/Your/Path/To/Deployed/Modules, Module::Name, Module::method"
  PerlSetVar options "compress_threshold => 10000"

=back

=head1 DESCRIPTION

This Apache Perl module provides the ability to add support for SOAP (Simple
Object Access Protocol) protocol with easy configuration (either in .conf or
in .htaccess file). This functionality should give you lightweight option
for hosting SOAP services and greatly simplify configuration aspects. This
module inherits functionality from SOAP::Transport::HTTP::Apache component
of SOAP::Lite module.

=head1 CONFIGURATION

The module can be placed in <Location>, <Directory>, <Files>, <FilesMatch>
directives in main server configuration areas or directly in .htaccess file.

All parameters should be quoted and can be separated with commas or spaces
for lists ("a, b, c") and with 'wide arrows' and commas for hash parameters
("key1 => value1, key2 => value2").

All options that you can find in SOAP::Transport::HTTP::Apache component
are available for configuration. Here is the description of most important
ones.

=over 4

=item dispatch_to (LIST)

Specifies path to directory that contains Perl modules you'd like to give
access to, or just list of modules (for preloaded modules).

  PerlSetVar dispatch_to "/Your/Path/To/Deployed/Modules, Module::Name, Module::method"

=item options (HASH)

Specifies list of options for your module, for example threshold for
compression. Future versions will support more options. See
SOAP::Transport::HTTP documentation for other options.

  PerlSetVar options "compress_threshold => 10000"

=back

=head1 METHODS/SUBROUTINES

=head2 server

 my $server = Apache::XMLRPC::Lite->server();

Returns the server object.

Useful if you need to manipulate the server object from your code.

=head2 handle

Request handler. Called by apache.

=head1 DEPENDENCIES

 SOAP::Lite
 mod_perl

=head1 SEE ALSO

 SOAP::Transport::HTTP::Apache for implementation details,
 SOAP::Lite for general information, and
 F<examples/server/mod_soap.htaccess> for .htaccess example

=head1 COPYRIGHT

Copyright (C) 2000-2001 Paul Kulchenko. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Paul Kulchenko (paulclinger@yahoo.com)

=cut
