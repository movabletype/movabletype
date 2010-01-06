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

package Zemanta::Utils;

use warnings;
use strict;

sub _read_file {
	my $path = shift;
	open(CRED, "<", $path) or die("Can't read $path: $!\n");

	my $value;
	while(defined($value = <CRED>)) {
		last if $value and $value !~ /^#/;
	}
	close(CRED);

	return if $value =~ /^#/;

	chomp($value);
	return $value;
}

sub read_credential {
	my $path = shift;

	my $value = _read_file($path);
	$value = _read_file($value) if( -e $value );

	die("No credential found in $path\n") unless $value;

	return $value;
}

1;
