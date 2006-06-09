# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.movabletype.org
#
# $Id$

package MT::I18N::default;

use strict;
use MT::ConfigMgr;
use vars qw( @ISA $PKG );
@ISA = qw( MT::ErrorHandler );

use constant DEFAULT_LENGTH_ENTRY_EXCERPT => 40;
use constant LENGTH_ENTRY_TITLE_FROM_TEXT => 5;
use constant LENGTH_ENTRY_PING_EXCERPT => 255;
use constant LENGTH_ENTRY_PING_TITLE_FROM_TEXT => 5;
use constant DISPLAY_LENGTH_MENU_TITLE => 22;
use constant DISPLAY_LENGTH_EDIT_COMMENT_TITLE => 25;
use constant DISPLAY_LENGTH_EDIT_COMMENT_AUTHOR => 25;
use constant DISPLAY_LENGTH_EDIT_COMMENT_TEXT_SHORT => 45;
use constant DISPLAY_LENGTH_EDIT_COMMENT_TEXT_LONG => 90;
use constant DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_SHORT => 30;
use constant DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_LONG => 80;
use constant DISPLAY_LENGTH_EDIT_PING_TITLE_FROM_EXCERPT => 12;
use constant DISPLAY_LENGTH_EDIT_PING_BREAK_UP => 30;
use constant DISPLAY_LENGTH_EDIT_ENTRY_TITLE => 25;
use constant DISPLAY_LENGTH_EDIT_ENTRY_TEXT_FROM_EXCERPT => 50;
use constant DISPLAY_LENGTH_EDIT_ENTRY_TEXT_BREAK_UP => 30;

use constant ENCODING_NAMES => [
    { 'name' => 'guess', 'display_name' => 'AUTO DETECT' },
    { 'name' => 'utf8', 'display_name' => 'UTF-8' },
    { 'name' => 'ascii', 'display_name' => 'ISO-8859-1' },
];

my @ENCODINGS_ENCODE =
    qw( utf-8 euc-jp shiftjis 7bit-jis iso-2022-jp
        iso-2022-jp-1 jis0201-raw jis0208-raw
        jis0212-raw cp932 Macjapanese iso-8859-1 );

sub guess_encoding {
    my $class = shift;
    my $meth = 'guess_encoding_' . ($PKG || $class->_load_module);
    $class->$meth(@_);
}
sub encode_text {
    my $class = shift;
    my $meth = "encode_text_" . ($PKG || $class->_load_module);
    $class->$meth(@_);
}
sub substr_text {
    my $class = shift;
    my $meth = "substr_text_" . ($PKG || $class->_load_module);
    $class->$meth(@_);
}
sub wrap_text {
    my $class = shift;
    my $meth = "wrap_text_" . ($PKG || $class->_load_module);
    $class->$meth(@_);
}
sub length_text {
    my $class = shift;
    my $meth = "length_text_" . ($PKG || $class->_load_module);
    $class->$meth(@_);
}
sub first_n {
    my $class = shift;
    my $meth = "first_n_" . ($PKG || $class->_load_module);
    $class->$meth(@_);
}
sub first_n_text {
    my $class = shift;
    my $meth = "first_n_" . ($PKG || $class->_load_module);
    $class->$meth(@_);
}
sub break_up_text {
    my $class = shift;
    my $meth = "break_up_text_" . ($PKG || $class->_load_module);
    $class->$meth(@_);
}
sub convert_high_ascii {
    my $class = shift;
    my $meth = "convert_high_ascii_" . ($PKG || $class->_load_module);
    $class->$meth(@_);
}

# Dumb default methods (charset ignorant)

sub encode_text_perl {
    my $class = shift;
    my ($str) = @_;
    $str;
}

sub substr_text_perl {
    my $class = shift;
    my ($str, $start, $end) = @_;
    substr($str, $start, $end);
}

sub length_text_perl {
    my $class = shift;
    my ($str) = @_;
    length($str);
}

sub guess_encoding_perl {
    MT->config('PublishCharset');
}

sub wrap_text_perl {
    my $class = shift;
    my ($text, $col, $tab_init, $tab_sub) = @_;
    $tab_init = '' unless defined $tab_init;
    $tab_sub = '' unless defined $tab_sub;
    require Text::Wrap;
    $Text::Wrap::columns = $col;
    $text = Text::Wrap::wrap($tab_init, $tab_sub, $text);
    return $text;
}

sub first_n_perl {
    my $class = shift;
    my ($text, $length) = @_;
    require MT::Util;
    $text = MT::Util::first_n_words($text, $length);
    return $text;
}

sub break_up_text_perl {
    my $class = shift;
    my ($text, $length) = @_;
    return '' unless defined $text;
    $text =~ s/(\S{$length})/$1 /g;
    return $text;
}

# Encode package methods

sub convert_high_ascii_encode {
    &convert_high_ascii_perl;
}

sub wrap_text_encode {
    my $class = shift;
    my ($text, $col, $tab_init, $tab_sub) = @_;
    $tab_init = '' unless defined $tab_init;
    $tab_sub = '' unless defined $tab_sub;
    require Text::Wrap;
    $Text::Wrap::column = $col;
    $text = Text::Wrap::wrap($tab_init, $tab_sub, $text);
    return $text;
}

sub first_n_encode {
    # passthru first_n_words
    my $class = shift;
    my ($text, $length) = @_;
    require MT::Util;
    $text = MT::Util::first_n_words($text, $length);
    return $text;
}

sub break_up_text_encode {
    my $class = shift;
    my ($text, $length) = @_;
    return '' unless defined $text;
    $text =~ s/(\S{$length})/$1 /g;
    return $text;
}

my %HighASCII = (
    "\xc0" => 'A',    # A`
    "\xe0" => 'a',    # a`
    "\xc1" => 'A',    # A'
    "\xe1" => 'a',    # a'
    "\xc2" => 'A',    # A^
    "\xe2" => 'a',    # a^
    "\xc4" => 'A',    # A:
    "\xe4" => 'a',    # a:
    "\xc5" => 'A',    # Aring
    "\xe5" => 'a',    # aring
    "\xc6" => 'AE',   # AE
    "\xe6" => 'ae',   # ae
    "\xc3" => 'A',    # A~
    "\xe3" => 'a',    # a~
    "\xc8" => 'E',    # E`
    "\xe8" => 'e',    # e`
    "\xc9" => 'E',    # E'
    "\xe9" => 'e',    # e'
    "\xca" => 'E',    # E^
    "\xea" => 'e',    # e^
    "\xcb" => 'E',    # E:
    "\xeb" => 'e',    # e:
    "\xcc" => 'I',    # I`
    "\xec" => 'i',    # i`
    "\xcd" => 'I',    # I'
    "\xed" => 'i',    # i'
    "\xce" => 'I',    # I^
    "\xee" => 'i',    # i^
    "\xcf" => 'I',    # I:
    "\xef" => 'i',    # i:
    "\xd2" => 'O',    # O`
    "\xf2" => 'o',    # o`
    "\xd3" => 'O',    # O'
    "\xf3" => 'o',    # o'
    "\xd4" => 'O',    # O^
    "\xf4" => 'o',    # o^
    "\xd6" => 'O',    # O:
    "\xf6" => 'o',    # o:
    "\xd5" => 'O',    # O~
    "\xf5" => 'o',    # o~
    "\xd8" => 'O',    # O/
    "\xf8" => 'o',    # o/
    "\xd9" => 'U',    # U`
    "\xf9" => 'u',    # u`
    "\xda" => 'U',    # U'
    "\xfa" => 'u',    # u'
    "\xdb" => 'U',    # U^
    "\xfb" => 'u',    # u^
    "\xdc" => 'U',    # U:
    "\xfc" => 'u',    # u:
    "\xc7" => 'C',    # ,C
    "\xe7" => 'c',    # ,c
    "\xd1" => 'N',    # N~
    "\xf1" => 'n',    # n~
    "\xdd" => 'Y',    # Yacute
    "\xfd" => 'y',    # yacute
    "\xdf" => 'ss',   # szlig
    "\xff" => 'y'     # yuml
);
my $HighASCIIRE = join '|', keys %HighASCII;

sub convert_high_ascii_perl {
    my $class = shift;
    my ($s) = @_;
    $s =~ s/($HighASCIIRE)/$HighASCII{$1}/g;
    $s;
}

sub _set_encode {
    my $class = shift;
    my ($text, $enc) = @_;

    if (defined($enc)) {
        unless ($enc) {
            my $meth = 'guess_encoding_' . lc $PKG;
            $enc = $class->$meth($text);
        }
    } else {
        $enc = MT->config('PublishCharset') || 'utf-8';
    }
    return $enc;
}

sub guess_encoding_encode {
    my $class = shift;
    my ($text) = @_;
    require Encode::Guess;
    Encode::Guess->set_suspects(MT->config('PublishCharset'), @ENCODINGS_ENCODE);
    my $dec = Encode::Guess->guess($text);
    if (ref($dec)) {
        return $dec->name;
    } else {
        # if Encode was failed to guess, re-try for each encodings.
        for my $encode_name ( MT->config('PublishCharset'), @ENCODINGS_ENCODE ) {
            Encode::Guess->set_suspects($encode_name);
            $dec = Encode::Guess->guess($text);
            if (ref($dec)) {
                return $dec->name;
            }
        }
        return MT->config('PublishCharset') || 'utf-8';
    }
}

sub substr_text_encode {
    my $class = shift;
    my ($text, $startpos, $length, $enc) = @_;
    $enc = $class->_set_encode($text, $enc);
    $text = $class->_conv_to_utf8($text, $enc) if $enc ne 'utf-8';
    Encode::_utf8_on($text);
    $text = substr($text, $startpos, $length);
    Encode::_utf8_off($text);
    $text = $class->_conv_from_utf8($text, $enc) if $enc ne 'utf-8';
    $text;
}

sub length_text_encode {
    my $class = shift;
    my ($text, $enc) = @_;
    $enc = $class->_set_encode($text, $enc);
    my $enc_text = $class->_conv_to_utf8($text, $enc);
    Encode::_utf8_on($enc_text);
    return length($enc_text);
}

sub encode_text_encode {
    my $class = shift;
    my($text, $from, $to) = @_;
    $from ||= $class->guess_encoding($text);
    $from = 'euc-jp' if $from eq 'euc';
    $to ||= MT->config('PublishCharset') || 'utf-8';
    $to = 'euc-jp' if $to eq 'euc';

    if ($from ne $to) {
        #Encode::_utf8_off($text);
        eval { Encode::from_to($text, $from, $to) };
        if (my $err = $@) {
            warn $err;
        }
    }

    Encode::_utf8_off($text) if $to eq 'utf-8';
    $text;
}

sub _conv_to_utf8 {
    my $class = shift;
    my ($text, $enc) = @_;
    return $text if lc($enc) eq 'utf-8';
    $class->encode_text($text, $enc, 'utf-8');
}

sub _conv_from_utf8 {
    my $class = shift;
    my ($text, $enc) = @_;
    return $text if lc($enc) eq 'utf-8';
    $class->encode_text($text, 'utf-8', $enc);
}

sub _load_module {
    return $PKG if $PKG;
    my $class = shift;
    if ($] > 5.008) {
        eval "require Encode";
        unless ($@) {
            $PKG = 'encode';
            return $PKG;
        }
    }
    $PKG = 'perl';
    return $PKG;
}

1;
