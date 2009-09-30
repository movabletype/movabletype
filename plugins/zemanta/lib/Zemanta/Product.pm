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

package Zemanta::Product;

use warnings;
use strict;

use MT::Log;

sub new {
	my $class = shift;

	my $product = {};
	bless $product, $class;

	return $product;
}

sub log_error {
	my $product = shift;
	my ($msg, $level) = @_;
	chomp($msg);

	my $log = MT::Log->new();
	$log->message( $msg );
	$log->level( $level or 4 );
	$log->save or die $log->errstr;
}

sub set_automatic_apikey {
}

sub load_config {
}

sub reset_config {
}

1;
