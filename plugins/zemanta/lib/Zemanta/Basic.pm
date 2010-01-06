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

package Zemanta::Basic;

use warnings;
use strict;

use HTTP::Request::Common qw(POST);
use MT;

use Zemanta::Product;
our @ISA = qw(Zemanta::Product);

sub new {
	my $class = shift;

	die("Zemanta Basic requires MovableType 4.x or later") if($MT::VERSION < 4.0);

	my $product = $class->SUPER::new();
	bless $product, $class;

	return $product;
}

sub plugin_config {
	return {
		name        => 'Zemanta',
		settings    => new MT::PluginSettings( [
		        [ 'api_key', {
					Default => '', 
					Scope => 'blog' 
			} ],
			[ 'default_api_key', { 
					Default => '', 
					Scope => 'blog' 
			} ],
			[ 'first_run', {
					Default => '1',
					Scope => 'blog'
			} ],
		] ),
		blog_config_template => "blog_config.tmpl",
	};
}

sub api_call {
	my $product = shift;
	my ($plugin, $method, @args) = @_;

	my $version = $plugin->{'version'};
	my $service_url = "http://api.zemanta.com/services/rest/0.0/";

	# Note: max_size is set by MT. This sends a "Range:" HTTP header which
	# isn't properly supported by Zemanta API.
	my $ua = MT->new_ua({	max_size => undef, 
				agent => "Zemanta Movable Type/$version (Perl/$])",
				timeout => 10});

	my $response = $ua->request(POST $service_url, [ method => $method,
							@args ]);
	unless($response->is_success) {
		$product->log_error(
				"Can't connect to Zemanta API service " .
			  	"($service_url): " . $response->status_line );
		return
	}

	my $xml = $response->content;

	# Quick and dirty XML processing.
	unless($xml =~ /<status>([^<>]+)<\/status>/) {
		$product->log_error(
				"Zemanta API method $method returned an " .
				"invalid response: " . $xml );
		return
	}

	my $status = $1;
	unless($status == 'ok') {
		$product->log_error(
				"Zemanta API method $method returned " .
				"status '$status'" );
		return
	}

	return $xml;
}

sub register_new_api_key {
	my $product = shift;
	my ($plugin) = @_;

	my $method = "zemanta.auth.create_user";
	my $xml = $product->api_call($plugin, $method);

	return unless($xml);

	unless($xml =~ /<apikey>([^<>]+)<\/apikey>/) {
		$product->log_error(
				"Zemanta API method $method returned an " .
				"invalid response: " . $xml);
		return
	}
	my $api_key = $1;

	return $api_key;
}

sub set_automatic_apikey {
	my $product = shift;
	my ($plugin, $blog) = @_;

	# No autoconfiguration if we are not in blog context
	# (i.e. on a system page)
	return unless $blog;

	my $blog_id = $blog->id;

	my $default_api_key = $plugin->get_config_value("default_api_key", 
							"blog:$blog_id");
	unless( $default_api_key ) {

		# New installation, fetch a new API key from the server.
		$default_api_key = $product->register_new_api_key($plugin);
		return unless $default_api_key;

		$plugin->set_config_value("default_api_key", $default_api_key, 
							"blog:$blog_id");

		# Check if user has been faster than us and entered her own
		# API key. In that case don't overwrite it.
		my $api_key = $plugin->get_config_value("api_key", 
							"blog:$blog_id");

		unless ( $api_key ) {
			$plugin->set_config_value("api_key", $default_api_key,
							"blog:$blog_id");
		}
	}
}

sub load_config {
	my $product = shift;
	my ($plugin, $param, $scope) = @_;

	return unless $param->{'api_key'};

	my $method = "zemanta.preferences";
	my $xml = $product->api_call($plugin,	$method,
						api_key => $param->{'api_key'},
						format => 'xml' );

	if($xml and $xml =~ /<config_url>([^<>]+)<\/config_url>/) {
		$param->{'config_url'} = $1 . "?platform=mtplugin";
	} else {
		$product->log_error(
				"Zemanta API method $method returned an " .
				"invalid response: " . $xml) if $xml;
	}
}

sub reset_config {
	my $product = shift;
	my ($plugin, $scope) = @_;

	my $default_api_key = $plugin->get_config_value("default_api_key", 
								$scope);
	$plugin->set_config_value("api_key", $default_api_key, $scope);
}

sub get_apikey {
	my $product = shift;
	my ($plugin, $blog) = @_;

	# Fetch an API key
	$product->set_automatic_apikey( $plugin, $blog );

	return $plugin->get_config_value("api_key", "blog:" . $blog->id);
}

1
