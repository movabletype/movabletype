#!/usr/bin/perl -w
# Zemanta plugin for Movable Type
# Created by Tomaz Solc <tomaz@zemanta.com> Copyright (c) 2009 Zemanta Ltd.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as
# published by the Free Software Foundation
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# CGI script to proxy GET & POST requests to the backend server.
# Optionally the requests are signed with a shared secret.

use strict;

BEGIN {
	use FindBin qw($Bin);

	my $MT_HOME = $ENV{MT_HOME} ? $ENV{MT_HOME} : "$Bin/../..";
	unshift @INC, "$Bin/lib", "$MT_HOME/lib", "$MT_HOME/extlib";
}

use CGI;

use HTTP::Request::Common qw(POST);
use Digest::MD5 qw(md5_hex);

use MT;
use Zemanta::Utils;

my $backend_url = "http://api.zemanta.com/services/rest/0.0/";

my $q = new CGI;

# Note: max_size is set by MT. This sends a "Range:" HTTP header which
# isn't properly supported by Zemanta API.
my $ua = MT->new_ua({max_size => undef, agent => "Zemanta JSON-Proxy/2.10"});

# Return a simple, JSON-formatted error message
sub error {
	my ($msg) = @_;

	chomp($msg);
	print "Content-type: text/plain\n\n";
	print "{\"status\":\"fail\",\"error\":\"json-proxy.cgi: $msg\"}";
	exit(0);
}

sub sign_vars {
	my ($vars, $shared_secret) = @_;

	my $raw = $shared_secret . join("", sort {$a cmp $b} values %$vars);

	$vars->{'signature'} = md5_hex($raw);
}

sub main
{
	my %vars = $q->Vars();

	my $path = File::Spec->catfile(	$Bin,
					"SECRET" );

	if( -e $path ) {
		# This is Zemanta Pro. Attach signature to the request.
		my $shared_secret;
		eval { 
			$shared_secret = Zemanta::Utils::read_credential($path);
		};
		error($@) if $@;
		sign_vars(\%vars, $shared_secret);
	}

	my $req = POST $backend_url, \%vars;

	my $response = $ua->request($req);

	my $status = $response->status_line;

	print $response->headers->as_string;
	print "status: $status\n";
	print "\n";
	print $response->content;
}

&main();
