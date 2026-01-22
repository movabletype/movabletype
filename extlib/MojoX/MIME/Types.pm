# This code is part of Perl distribution MIME-Types version 2.30.
# The POD got stripped from this file by OODoc version 3.05.
# For contributors see file ChangeLog.

# This software is copyright (c) 1999-2025 by Mark Overmeer.

# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
# SPDX-License-Identifier: Artistic-1.0-Perl OR GPL-1.0-or-later


package MojoX::MIME::Types;{
our $VERSION = '2.30';
}

use Mojo::Base -base;

use MIME::Types   ();

#--------------------

sub new(%)
{	# base new() constructor incorrect: should call init()
	my $self        = shift->SUPER::new(@_);
	$self->{MMT_mt} = delete $self->{mime_types} || MIME::Types->new;
	$self;
}

#--------------------

sub mimeTypes() { $_[0]->{MMT_mt} }


sub mapping(;$)
{	my $self = shift;
	return $self->{MMT_ext} if $self->{MMT_ext};

	my %exttable;
	my $t = MIME::Types->_MojoExtTable;
	while(my ($ext, $type) = each %$t) { $exttable{$ext} = [$type] }
	$self->{MMT_ext} = \%exttable;
}

*types = \&mapping;  # renamed in release 6.0

#--------------------

sub detect($$;$)
{	my ($self, $accept, $prio) = @_;
	my $mt  = $self->mimeTypes;
	my @ext = map $_->extensions, grep defined, map $mt->type($_),
		grep !/\*/, $mt->httpAccept($accept);
	\@ext;
}


sub type($;$)
{	my ($self, $ext, $types) = @_;

	my $mt  = $self->mimeTypes;
	defined $types
		or return $mt->mimeTypeOf($ext);

	# stupid interface compatibility!
	$self;
}


sub file_type($) {
	my ($self, $fn) = @_;
	my $mt = $self->mimeTypes or return undef;
	$mt->mimeTypeOf($fn);
}


sub content_type($;$) {
	my ($self, $c, $opts) = @_;
	my $headers = $c->res->headers;
	return undef if $headers->content_type;

	my $fn = $opts->{file} || $opts->{ext};

	my $mt = $self->mimeTypes or return undef;
	$headers->content_type($mt->mimeTypeOf($fn) || $mt->mimeTypeOf('txt'));
}

#--------------------

1;
