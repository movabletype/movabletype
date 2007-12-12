# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::I18N::ja;

use strict;
use MT::Util qw(remove_html);
use vars qw( @ISA $PKG );
@ISA = qw( MT::I18N::default );
*PKG = *MT::I18N::default::PKG;

use constant DEFAULT_LENGTH_ENTRY_EXCERPT => 40;
use constant LENGTH_ENTRY_TITLE_FROM_TEXT => 10;
use constant LENGTH_ENTRY_PING_EXCERPT => 80;
use constant LENGTH_ENTRY_PING_TITLE_FROM_TEXT => 10;
use constant DISPLAY_LENGTH_MENU_TITLE => 11;
use constant DISPLAY_LENGTH_EDIT_COMMENT_TITLE => 12;
use constant DISPLAY_LENGTH_EDIT_COMMENT_AUTHOR => 12;
use constant DISPLAY_LENGTH_EDIT_COMMENT_TEXT_SHORT => 23;
use constant DISPLAY_LENGTH_EDIT_COMMENT_TEXT_LONG => 45;
use constant DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_SHORT => 30;
use constant DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_LONG => 80;
use constant DISPLAY_LENGTH_EDIT_PING_TITLE_FROM_EXCERPT => 25;
use constant DISPLAY_LENGTH_EDIT_PING_BREAK_UP => 30;
use constant DISPLAY_LENGTH_EDIT_ENTRY_TITLE => 11;
use constant DISPLAY_LENGTH_EDIT_ENTRY_TEXT_FROM_EXCERPT => 25;
use constant DISPLAY_LENGTH_EDIT_ENTRY_TEXT_BREAK_UP => 30;

use constant ENCODING_NAMES => [
    { 'name' => 'guess', 'display_name' => 'AUTO DETECT' },
    { 'name' => 'sjis', 'display_name' => 'SHIFT_JIS' },
    { 'name' => 'euc', 'display_name' => 'EUC-JP' },
    { 'name' => 'utf8', 'display_name' => 'UTF-8' },
    { 'name' => 'ascii', 'display_name' => 'ISO-8859-1' },
    { 'name' => 'WinLatin1', 'display_name' => 'Windows Latin1' },
];

my $ENCODINGS_LABEL = {
    'shift_jis' => 'sjis',
    'iso-2022-jp' => 'jis',
    'euc-jp' => 'euc',
    'utf-8' => 'utf8',
    'ascii' => 'utf8',
    'iso-8859-1' => 'ascii',
};

my @ENCODINGS_ENCODE =
    qw( euc-jp shiftjis 7bit-jis iso-2022-jp
        iso-2022-jp-1 jis0201-raw jis0208-raw
        jis0212-raw cp932 Macjapanese );

sub guess_encoding_jcode {
    my $class = shift;
    my ($text) = @_;
    my $enc = Jcode::getcode($text);
    my $def_enc = MT->config('PublishCharset') || 'utf-8';
    if (!$enc) {
        $enc = $def_enc;
    }
    if ($enc eq 'ascii') {
        $enc = 'utf-8';
    }
    if ($enc eq 'binary') {
        $enc = $def_enc;
    }
    $enc = $class->_conv_enc_label($enc);
    return $enc;
}

sub decode_jcode {
    my $class = shift;
    my ($enc, $text) = @_;
    my $u8 = $class->encode_text_jcode($text, $enc, 'utf-8');
    my $u8d = $class->decode_utf8_jcode($u8);
    $u8d;
}

sub encode_text_jcode {
    my $class = shift;
    my ($text, $from, $to) = @_;
    if (!$from) {
        $from = $class->guess_encoding_jcode($text);
    }
    if (!$to) {
       $to = MT->config('PublishCharset') || 'utf-8';
    }
    $from = $class->_conv_enc_label($from);
    $to = $class->_conv_enc_label($to);
    return $text if ($from eq $to || $to eq 'ascii');
    return Jcode->new($text,$from)->$to();
}

sub substr_text_jcode {
    my $class = shift;
    my ($text, $startpos, $length, $enc) = @_;
    if ($length == 0) {
        $length = -1;
    }
    $enc = $class->_set_encode($text, $enc);
    my $euc_text = $class->encode_text($text,$enc,'euc-jp');
    my $out = '';
    my $c = 0;
    for (my $i=0;$i<length($euc_text);$i++) {
        last if ($length == 0);
        if ( substr($euc_text,$i,2) =~ /[\xA1-\xFE][\xA1-\xFE]/ ||
             substr($euc_text,$i,2) =~ /[\x8E][\xA1-\xDF]/) {
            if ($c >= $startpos && ($length-->0 || $length < 0)) {
                $out .= substr($euc_text,$i,2);
            }
            $c++;$i++;
            next;
        }
        if ( substr($euc_text,$i,3) =~ /[\x8F][\xA1-\xFE][\xA1-\xFE]/) {
            if ($c >= $startpos && ($length-->0 || $length < 0)) {
                $out .= substr($euc_text,$i,3);
            }
            $c++;$i+=2;
            next;
        }
        if ( ord(substr($euc_text,$i,1)) < 0x80 ) {
            if ($c >= $startpos && ($length-->0 || $length < 0)) {
                $out .= substr($euc_text,$i,1);
            }
            $c++;
            next;
        }
    }
    return $class->encode_text($out, 'euc-jp', $enc);
}

sub lowercase_jcode {
    my $class = shift;
    my ($str, $enc) = @_;
    $enc = $class->_set_encode($str, $enc);
    $str = $class->encode_text_jcode($str, $enc, 'utf-8') if lc $enc ne 'utf-8';
    $class->utf8_on_jcode($str);
    $str = lc $str;
    $class->utf8_off_jcode($str);
    $str = $class->encode_text_jcode($str, 'utf-8', $enc) if lc $enc ne 'utf-8';
    return $str;
}

sub uppercase_jcode {
    my $class = shift;
    my ($str, $enc) = @_;
    $enc = $class->_set_encode($str, $enc);
    $str = $class->encode_text_jcode($str, $enc, 'utf-8') if lc $enc ne 'utf-8';
    $class->utf8_on_jcode($str);
    $str = uc $str;
    $class->utf8_off_jcode($str);
    $str = $class->encode_text_jcode($str, 'utf-8', $enc) if lc $enc ne 'utf-8';
    return $str;
}


sub wrap_text_jcode {
    my $class = shift;
    my ($text, $cols, $tab_init, $tab_sub, $enc) = @_;
    $enc = $class->_set_encode($text, $enc);
    if (!$cols) {
        $cols = 72;
    }
    my $euc_text = $class->encode_text($text,$enc,'euc-jp');
    my $out = '';
    my $str = '';
    my $b = 0;
    for (my $i=0;$i<length($euc_text);$i++) {
        if ( substr($euc_text,$i,2) =~ /[\xA1-\xFE][\xA1-\xFE]/ ||
             substr($euc_text,$i,2) =~ /[\x8E][\xA1-\xDF]/) {
            $str = substr($euc_text,$i,2);
            $i++;
            $b+=2;
        }
        elsif ( substr($euc_text,$i,3) =~ /[\x8F][\xA1-\xFE][\xA1-\xFE]/) {
            $str = substr($euc_text,$i,3);
            $i+=2;
            $b+=2;
        }
        elsif ( substr($euc_text,$i,1) =~ /[\n\r]/ ) {
            $str = substr($euc_text,$i,1);
            $b = 0;
        }
        elsif ( ord(substr($euc_text,$i,1)) < 0x80 ) {
            $str = substr($euc_text,$i,1);
            $b+=1;
        }

        if ($b > $cols) {
            $out .= "\n";
            $b = 0;
        }
        $out .= $str;
    }
    return $class->encode_text($out,'euc-jp', $enc);
}

sub length_text_jcode {
    my $class = shift;
    my ($text, $enc) = @_;
    $enc = $class->_set_encode($text, $enc);

    my $euc_text= $class->encode_text($text, $enc, 'euc-jp');
    my $len = Jcode->new($euc_text, 'euc')->jlength();
    return $len;
}

sub first_n_jcode {
    my $class = shift;
    my ($text, $length, $enc) = @_;
    $enc = $class->_set_encode($text, $enc);

    my $euc_text = $class->encode_text($text, $enc, 'euc-jp');
    $euc_text = MT::Util::remove_html($euc_text);
    $euc_text =~ s/(\r?\n)+/ /g;
    my $out = $class->substr_text_jcode($euc_text, 0, $length, 'euc-jp');
    return $class->encode_text($out,'euc-jp', $enc);
}

sub break_up_text_jcode {
    my $class = shift;
    my ($text, $cols, $enc) = @_;
    return $text;
}

sub wrap_text_encode {
    my $class = shift;
    my ($text, $cols, $tab_init, $tab_sub, $enc) = @_;
    if (($enc && ('utf-8' eq lc $enc)) ||
        (MT->config->PublishCharset =~ /utf-?8/i)) {
        eval {
            $text = Encode::decode_utf8($text);
            #FULLWIDTH TILDE to WAVE DASH 
            $text =~ s/\x{ff5e}/\x{301c}/g;  
            #PARALLEL TO to DOUBLE VERTICAL LINE 
            $text =~ s/\x{2225}/\x{2016}/g; 
            #FULLWIDTH HYPHEN-MINUS to MINUS SIGN 
            $text =~ s/\x{ff0d}/\x{2212}/g;  
            #FULLWIDTH CENT SIGN to CENT SIGN 
            $text =~ s/\x{ffe0}/\x{00a2}/g; 
            #FULLWIDTH POUND SIGN to POUND SIGN 
            $text =~ s/\x{ffe1}/\x{00a3}/g; 
            #FULLWIDTH NOT SIGN to NOT SIGN 
            $text =~ s/\x{ffe2}/\x{00ac}/g; 
            $text = Encode::encode_utf8($text);
        };
    }
    $text = $class->wrap_text_jcode($text, $cols, $tab_init, $tab_sub, $enc);
    $text;
}

sub first_n_encode {
    my $class = shift;
    my ($text, $length, $enc) = @_;
    $enc = $class->_set_encode($text, $enc);
    $text = $class->_conv_to_utf8($text, $enc);
    $text = MT::Util::remove_html($text);
    $text =~ s/(\r?\n)+/ /g;
    $text = $class->substr_text_encode($text, 0, $length, 'utf-8');
    $text = $class->_conv_from_utf8($text, $enc);
    return $text;
}

sub break_up_text_encode {
    my $class = shift;
    my ($text, $cols, $enc) = @_;
    return $text;
}

sub _conv_enc_label {
    my $class = shift;
    my $enc = shift;
    $enc = lc $enc;
    $enc = $ENCODINGS_LABEL->{$enc} ? $ENCODINGS_LABEL->{$enc} : $enc;
    return $enc;
}

sub convert_high_ascii_jcode {
    my $class = shift;
    my ($s) = @_;
    $s = $class->encode_text_jcode($s, undef, 'utf-8');
    $s;
}

sub convert_high_ascii_encode {
    my $class = shift;
    my ($s) = @_;
    $s = $class->encode_text_encode($s, undef, 'utf-8');
    $s;
}

sub decode_utf8_encode {
    my $class = shift;
    my ($text, $enc) = @_;
    $text = $class->encode_text($text, $enc, 'utf-8');
    return Encode::decode_utf8($text);
}

sub decode_utf8_jcode {
    my $class = shift;
    my ($text, $enc) = @_;
    $text = $class->encode_text($text, $enc, 'utf-8');
    return pack('U*', unpack('U0U*', $text));
}

sub utf8_off_encode {
    my $class = shift;
    my ($text) = @_;
    Encode::_utf8_off($text);
    $text;
}

## These are from Encode::Compat
sub utf8_on_jcode {
    my $class = shift;
    my ($text) = @_;
    return pack('U*', unpack('U0U*', $text));
}

sub utf8_off_jcode {
    my $class = shift;
    my ($text) = @_;
    return pack('C*', unpack('C*', $text));
}

sub _load_module {
    return $PKG if $PKG;
    my $class = shift;
    my $use_jcode = MT->config('UseJcodeModule') ? 1 : 0;
    if ($] > 5.008 && !$use_jcode) {
        eval "require Encode";
        unless ($@) {
            $PKG = 'encode';
            return $PKG;
        }
    } else {
        eval "require Jcode";
        unless ($@) {
            $PKG = 'jcode';
            return $PKG;
        }
    }
    $PKG = 'perl';
    return $PKG;
}

1;
