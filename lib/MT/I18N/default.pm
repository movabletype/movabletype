# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::I18N::default;

use strict;
use base qw( MT::ErrorHandler );
our $PKG;

sub DEFAULT_LENGTH_ENTRY_EXCERPT ()                    { 40 }
sub LENGTH_ENTRY_TITLE_FROM_TEXT ()                    { 5 }
sub LENGTH_ENTRY_PING_EXCERPT ()                       { 255 }
sub LENGTH_ENTRY_PING_TITLE_FROM_TEXT ()               { 5 }
sub DISPLAY_LENGTH_MENU_TITLE ()                       { 22 }
sub DISPLAY_LENGTH_EDIT_COMMENT_TITLE ()               { 25 }
sub DISPLAY_LENGTH_EDIT_COMMENT_AUTHOR ()              { 25 }
sub DISPLAY_LENGTH_EDIT_COMMENT_TEXT_SHORT ()          { 45 }
sub DISPLAY_LENGTH_EDIT_COMMENT_TEXT_LONG ()           { 90 }
sub DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_SHORT () { 30 }
sub DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_LONG ()  { 80 }
sub DISPLAY_LENGTH_EDIT_PING_TITLE_FROM_EXCERPT ()     { 12 }
sub DISPLAY_LENGTH_EDIT_PING_BREAK_UP ()               { 30 }
sub DISPLAY_LENGTH_EDIT_ENTRY_TITLE ()                 { 25 }
sub DISPLAY_LENGTH_EDIT_ENTRY_TEXT_FROM_EXCERPT ()     { 50 }
sub DISPLAY_LENGTH_EDIT_ENTRY_TEXT_BREAK_UP ()         { 30 }

sub PORTAL_URL()            { '' } # default PORTAL_URL is determined in building packages
sub SUPPORT_URL()           { 'http://www.sixapart.com/movabletype/support/' }
sub NEWS_URL()              { 'http://www.sixapart.com/movabletype/news/' }
sub NEWSBOX_URL()           { 'http://www.sixapart.com/movabletype/news/mt4_news_widget.html' }
sub LEARNINGNEWS_URL()      { 'http://learning.movabletype.org/newsbox.html' }
sub CATEGORY_NAME_NODASH()  { 0 }
sub DEFAULT_TIMEZONE()      { 0 }
sub MAIL_ENCODING()         { 'ISO-8859-1' }
sub LOG_EXPORT_ENCODING()   { '' }
sub EXPORT_ENCODING()       { '' }
sub PUBLISH_CHARSET()       { 'UTF-8' }

my $ENCODING_NAMES = [
    { 'name' => 'guess', 'display_name' => 'AUTO DETECT' },
    { 'name' => 'utf8', 'display_name' => 'UTF-8' },
    { 'name' => 'ascii', 'display_name' => 'ISO-8859-1' },
    { 'name' => 'WinLatin1', 'display_name' => 'Windows Latin1' },
];
sub ENCODING_NAMES () {
    return $ENCODING_NAMES;
}

my @ENCODINGS_ENCODE =
    qw( cp1252 utf-8 euc-jp shiftjis 7bit-jis iso-2022-jp
        iso-2022-jp-1 jis0201-raw jis0208-raw
        jis0212-raw cp932 Macjapanese iso-8859-1 );

sub guess_encoding {
    my $class = shift;
    my $meth = 'guess_encoding_' . ($PKG || $class->_load_module);
    $class->$meth(@_);
}

no warnings 'redefine';
*MT::I18N::encode_text = \&encode_text;
*MT::I18N::guess_encoding = \&guess_encoding;
*MT::I18N::wrap_text = \&wrap_text;
*MT::I18N::first_n = \&first_n;
*MT::I18N::first_n_text = \&first_n;

sub encode_text {
    my $class = shift;
    return $class->encode_text_encode(@_);
}

sub guess_encoding {
    my $class = shift;
    return $class->guess_encoding_encode(@_);
}

sub wrap_text {
    my $class = shift;
    return $class->wrap_text_encode(@_);
}

sub first_n {
    my $class = shift;
    return $class->first_n_encode(@_);
}

sub first_n_text {
    my $class = shift;
    return $class->first_n_encode(@_);
}

# Dumb default methods (charset ignorant)

sub encode_text_perl {
    my $class = shift;
    my ($str) = @_;
    $str;
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

# Encode package methods

sub wrap_text_encode {
    my $class = shift;
    my ($text, $col, $tab_init, $tab_sub) = @_;
    $tab_init = '' unless defined $tab_init;
    $tab_sub = '' unless defined $tab_sub;
    require Text::Wrap;
    $Text::Wrap::columns = $col;
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

sub encode_text_encode {
    my $class = shift;
    my($text, $from, $to) = @_;
    $from ||= $class->guess_encoding($text);
    $from = 'euc-jp' if $from eq 'euc';
    $to ||= MT->config('PublishCharset') || 'utf-8';
    $to = 'euc-jp' if $to eq 'euc';

    if ($from ne $to) {
        #Encode::_utf8_off($text);
        eval {
            if ( ( ( 'iso-2022-jp' eq lc($to) ) || ( 'shift_jis' eq lc($to) ) )
                && ( 'utf-8' eq lc($from)) )
            {
                $text = Encode::encode_utf8( $text ) if Encode::is_utf8( $text );
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
                Encode::from_to($text, $from, $to);
            } else {
                Encode::from_to($text, $from, $to);
            }
        };
        if (my $err = $@) {
            warn $err;
        }
    }

    $text;
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
