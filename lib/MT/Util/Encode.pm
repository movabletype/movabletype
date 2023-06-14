package MT::Util::Encode;

use strict;
use warnings;
use Exporter qw/import/;
use Encode ();

our @EXPORT_OK = qw(
    find_encoding
    encode decode
    encode_utf8 decode_utf8
    encode_if_flagged decode_unless_flagged
    encode_utf8_if_flagged decode_utf8_unless_flagged
    from_to is_utf8
);

my %Encoding;
my $utf8 = $Encoding{utf8} = Encode::find_encoding('utf8');

sub find_encoding {
    my $encoding = shift;
    $Encoding{$encoding} ||= Encode::find_encoding($encoding);
}

sub encode {
    my $enc = shift;
    return undef unless defined $_[0];
    ($Encoding{$enc} ||= find_encoding($enc))->encode(@_);
}

sub decode {
    my $enc = shift;
    return undef unless defined $_[0];
    ($Encoding{$enc} ||= find_encoding($enc))->decode(@_);
}

sub encode_utf8 {
    return undef unless defined $_[0];
    $utf8->encode(@_);
}

sub decode_utf8 {
    return undef unless defined $_[0];
    $utf8->decode(@_);
}

sub encode_if_flagged {
    my $enc = shift;
    return undef unless defined $_[0];
    return $_[0] unless Encode::is_utf8($_[0]);
    ($Encoding{$enc} ||= find_encoding($enc))->encode(@_);
}

sub decode_unless_flagged {
    my $enc = shift;
    return undef unless defined $_[0];
    return $_[0] if Encode::is_utf8($_[0]);
    ($Encoding{$utf8} ||= find_encoding($enc))->decode(@_);
}

sub encode_utf8_if_flagged {
    return undef unless defined $_[0];
    return $_[0] unless Encode::is_utf8($_[0]);
    $utf8->encode(@_);
}

sub decode_utf8_unless_flagged {
    return undef unless defined $_[0];
    return $_[0] if Encode::is_utf8($_[0]);
    $utf8->decode(@_);
}

*from_to   = \&Encode::from_to;
*is_utf8   = \&Encode::is_utf8;
*_utf8_on  = \&Encode::_utf8_on;
*_utf8_off = \&Encode::_utf8_off;

1;
