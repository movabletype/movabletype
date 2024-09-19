# Copyrights 1999-2021 by [Mark Overmeer <markov@cpan.org>].
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 2.02.
# This code is part of distribution MIME::Types.  Meta-POD processed with
# OODoc into POD and HTML manual-pages.  See README.md
# Copyright Mark Overmeer.  Licensed under the same terms as Perl itself.

package MojoX::MIME::Types;
use vars '$VERSION';
$VERSION = '2.22';

use Mojo::Base -base;

use MIME::Types   ();


sub new(%)
{   # base new() constructor incorrect: should call init()
    my $self        = shift->SUPER::new(@_);
    $self->{MMT_mt} = delete $self->{mime_types} || MIME::Types->new;
    $self;
}

#----------

sub mimeTypes() { shift->{MMT_mt} }


sub mapping(;$)
{   my $self = shift;
    return $self->{MMT_ext} if $self->{MMT_ext};

    my %exttable;
    my $t = MIME::Types->_MojoExtTable;
    while(my ($ext, $type) = each %$t) { $exttable{$ext} = [$type] }
    $self->{MMT_ext} = \%exttable;
}

*types = \&mapping;  # renamed in release 6.0

#----------

sub detect($$;$)
{   my ($self, $accept, $prio) = @_;
    my $mt  = $self->mimeTypes;
    my @ext = map $_->extensions, grep defined, map $mt->type($_),
        grep !/\*/, $mt->httpAccept($accept);
    \@ext;
}


sub type($;$)
{   my ($self, $ext, $types) = @_;

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

#---------------

1;
