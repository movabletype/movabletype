# This code is part of Perl distribution MIME-Types version 2.30.
# The POD got stripped from this file by OODoc version 3.05.
# For contributors see file ChangeLog.

# This software is copyright (c) 1999-2025 by Mark Overmeer.

# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
# SPDX-License-Identifier: Artistic-1.0-Perl OR GPL-1.0-or-later


package MIME::Type;{
our $VERSION = '2.30';
}


use strict;
use warnings;

use Carp 'croak';

#--------------------

#--------------------

use overload
	'""' => 'type',
	cmp  => 'cmp';

#--------------------

sub new(@) { (bless {}, shift)->init( {@_} ) }

sub init($)
{	my ($self, $args) = @_;

	my $type = $self->{MT_type} = $args->{type}
		or croak "ERROR: Type parameter is obligatory.";

	$self->{MT_simplified} = $args->{simplified} || $self->simplified($type);
	$self->{MT_extensions} = $args->{extensions} || [];

	$self->{MT_encoding}
	  = $args->{encoding}          ? $args->{encoding}
	  : $self->mediaType eq 'text' ? 'quoted-printable'
	  :    'base64';

	$self->{MT_system}     = $args->{system}  if defined $args->{system};
	$self->{MT_charset}    = $args->{charset} if defined $args->{charset};
	$self;
}

#--------------------

sub type() { $_[0]->{MT_type} }


sub simplified(;$)
{	my $thing = shift;
	@_ or return $thing->{MT_simplified};

	my $mime  = shift;

	  $mime =~ m!^\s*(?:x\-)?([\w.+-]+)/(?:x\-)?([\w.+-]+)\s*$!i ? lc "$1/$2"
	: $mime eq 'text' ? 'text/plain'         # some silly mailers...
	:   $mime;                               # doesn't follow rules, f.i. one word
}


sub extensions() { @{$_[0]->{MT_extensions}} }
sub encoding()   { $_[0]->{MT_encoding} }
sub system()     { $_[0]->{MT_system} }


sub charset()    { $_[0]->{MT_charset} }

#--------------------

sub mediaType()  { $_[0]->simplified =~ m!^([\w.-]+)/! ? $1 : undef }
sub mainType()   { $_[0]->mediaType } # Backwards compatibility


sub subType()    { $_[0]->simplified =~ m!/([\w+.-]+)$! ? $1 : undef }


sub isRegistered() { lc($_[0]->type) !~ m{^x\-|/x\-} }


# http://tools.ietf.org/html/rfc4288#section-3
sub isVendor()       { $_[0]->simplified =~ m!/vnd\.! }
sub isPersonal()     { $_[0]->simplified =~ m!/prs\.! }
sub isExperimental() { $_[0]->simplified =~ m!/x\.! }


sub isBinary() { $_[0]->encoding eq 'base64' }
sub isText()   { $_[0]->encoding ne 'base64' }
*isAscii = \&isText;


# simplified names only!
my %sigs = map +($_ => 1),
qw(application/pgp-keys application/pgp application/pgp-signature
	application/pkcs10 application/pkcs7-mime application/pkcs7-signature
	text/vCard);

sub isSignature() { $sigs{$_[0]->simplified} }


sub cmp($)
{	my ($self, $other) = @_;
	my $type = ref $other ? $other->simplified : (ref $self)->simplified($other);
	$self->simplified cmp $type;
}

sub equals($) { $_[0]->cmp($_[1])==0 }


my %ctext;
$ctext{$_} = 'US-ASCII'  for qw/plain cql cql-expression cql-identifier css directory dns encaprtp enriched/;
$ctext{$_} = 'UTF-8'     for qw/cache-manifest calendar csv csv-schema ecmascript/;
$ctext{$_} = '_REQUIRED' for qw//;

sub defaultCharset()
{	my $self = shift;
	my $st   = (lc $self->subType) =~ s/^x-//r;
	my $default = $ctext{$st} // return undef;

	if($default eq '_REQUIRED')
	{	warn "MediaType ".($self->subType)." requires an explicit character-set.";
		return undef;
	}

	$default;
}

1;
