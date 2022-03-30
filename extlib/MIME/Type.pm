# Copyrights 1999-2021 by [Mark Overmeer <markov@cpan.org>].
#  For other contributors see ChangeLog.
# See the manual pages for details on the licensing terms.
# Pod stripped from pm file by OODoc 2.02.
# This code is part of distribution MIME::Types.  Meta-POD processed with
# OODoc into POD and HTML manual-pages.  See README.md
# Copyright Mark Overmeer.  Licensed under the same terms as Perl itself.

package MIME::Type;
use vars '$VERSION';
$VERSION = '2.22';


use strict;

use Carp 'croak';


#-------------------------------------------


use overload
    '""' => 'type'
  , cmp  => 'cmp';

#-------------------------------------------


sub new(@) { (bless {}, shift)->init( {@_} ) }

sub init($)
{   my ($self, $args) = @_;

    my $type = $self->{MT_type} = $args->{type}
       or croak "ERROR: Type parameter is obligatory.";

    $self->{MT_simplified}      = $args->{simplified}
       || $self->simplified($type);

    $self->{MT_extensions}      = $args->{extensions} || [];

    $self->{MT_encoding}
       = $args->{encoding}          ? $args->{encoding}
       : $self->mediaType eq 'text' ? 'quoted-printable'
       :                              'base64';

    $self->{MT_system}     = $args->{system}
       if defined $args->{system};

    $self;
}

#-------------------------------------------

sub type() {shift->{MT_type}}


sub simplified(;$)
{   my $thing = shift;
    return $thing->{MT_simplified} unless @_;

    my $mime  = shift;

      $mime =~ m!^\s*(?:x\-)?([\w.+-]+)/(?:x\-)?([\w.+-]+)\s*$!i ? lc "$1/$2"
    : $mime eq 'text' ? 'text/plain'          # some silly mailers...
    : undef;
}


sub extensions() { @{shift->{MT_extensions}} }
sub encoding()   {shift->{MT_encoding}}
sub system()     {shift->{MT_system}}

#-------------------------------------------


sub mediaType() {shift->{MT_simplified} =~ m!^([\w.-]+)/! ? $1 : undef}
sub mainType()  {shift->mediaType} # Backwards compatibility


sub subType() {shift->{MT_simplified} =~ m!/([\w+.-]+)$! ? $1 : undef}


sub isRegistered() { lc shift->{MT_type} !~ m{^x\-|/x\-} }


# http://tools.ietf.org/html/rfc4288#section-3
sub isVendor()       {shift->{MT_simplified} =~ m!/vnd\.!}
sub isPersonal()     {shift->{MT_simplified} =~ m!/prs\.!}
sub isExperimental() {shift->{MT_simplified} =~ m!/x\.!  }


sub isBinary() { shift->{MT_encoding} eq 'base64' }
sub isText()   { shift->{MT_encoding} ne 'base64' }
*isAscii = \&isText;


# simplified names only!
my %sigs = map +($_ => 1),
  qw(application/pgp-keys application/pgp application/pgp-signature
     application/pkcs10 application/pkcs7-mime application/pkcs7-signature
     text/vCard);

sub isSignature() { $sigs{shift->{MT_simplified}} }


sub cmp($)
{   my ($self, $other) = @_;

    my $type = ref $other
      ? $other->simplified
      : (ref $self)->simplified($other);

    $self->simplified cmp $type;
}
sub equals($) { $_[0]->cmp($_[1])==0 }

1;
