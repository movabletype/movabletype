#-*- perl -*-
#-*- encoding: utf-8 -*-

package MIME::Charset::UTF;

use strict;
use Carp qw(croak);
use Encode::Encoding;
use vars qw(@ISA $VERSION);
@ISA = qw(Encode::Encoding);
$VERSION = '1.010';

__PACKAGE__->Define('x-utf16auto');
__PACKAGE__->Define('x-utf32auto');

sub perlio_ok { 0 }

sub decode {
    my ($self, $octets, $check) = @_;

    if ($self->name =~ /16/) {
	if ($octets =~ /\A\xFE\xFF/ or $octets =~ /\A\xFF\xFE/) {
	    return Encode::find_encoding('UTF-16')->decode($_[1], $_[2]);
	} else {
	    return Encode::find_encoding('UTF-16BE')->decode($_[1], $_[2]);
	}
    } elsif ($self->name =~ /32/) {
	if ($octets =~ /\A\0\0\xFE\xFF/ or $octets =~ /\A\xFF\xFE\0\0/) {
	    return Encode::find_encoding('UTF-32')->decode($_[1], $_[2]);
	} else {
	    return Encode::find_encoding('UTF-32BE')->decode($_[1], $_[2]);
	}
    } else {
	croak 'bug in logic.  Ask developer';
    }
}

sub encode {
    my $self = $_[0];

    if ($self->name =~ /16/) {
	return Encode::find_encoding('UTF-16')->encode($_[1], $_[2]);
    } elsif ($self->name =~ /32/) {
	return Encode::find_encoding('UTF-32')->encode($_[1], $_[2]);
    } else {
	croak 'bug in logic.  Ask developer';
    }
}
