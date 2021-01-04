# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::I18N::default;

use strict;
use warnings;
use base qw( MT::ErrorHandler );

sub DEFAULT_LENGTH_ENTRY_EXCERPT ()                    {40}
sub LENGTH_ENTRY_TITLE_FROM_TEXT ()                    {5}
sub LENGTH_ENTRY_PING_EXCERPT ()                       {255}
sub LENGTH_ENTRY_PING_TITLE_FROM_TEXT ()               {5}
sub DISPLAY_LENGTH_MENU_TITLE ()                       {22}
sub DISPLAY_LENGTH_EDIT_COMMENT_TITLE ()               {25}
sub DISPLAY_LENGTH_EDIT_COMMENT_AUTHOR ()              {25}
sub DISPLAY_LENGTH_EDIT_COMMENT_TEXT_SHORT ()          {45}
sub DISPLAY_LENGTH_EDIT_COMMENT_TEXT_LONG ()           {90}
sub DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_SHORT () {30}
sub DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_LONG ()  {80}
sub DISPLAY_LENGTH_EDIT_PING_TITLE_FROM_EXCERPT ()     {12}
sub DISPLAY_LENGTH_EDIT_PING_BREAK_UP ()               {30}
sub DISPLAY_LENGTH_EDIT_ENTRY_TITLE ()                 {25}
sub DISPLAY_LENGTH_EDIT_ENTRY_TEXT_FROM_EXCERPT ()     {50}
sub DISPLAY_LENGTH_EDIT_ENTRY_TEXT_BREAK_UP ()         {30}

sub PORTAL_URL() {''}  # default PORTAL_URL is determined in building packages
sub SUPPORT_URL()        {'https://www.movabletype.com/support/'}
sub NEWS_URL()           {'http://www.sixapart.com/movabletype/news/'}
sub FEEDBACK_URL()       {'https://movabletype.org/feedback.html'}
sub LATEST_VERSION_URL() {'https://movabletype.org/latest_version.json'}

sub NEWSBOX_URL() {
    'https://www.movabletype.org/news/newsbox.json';
}
sub LEARNINGNEWS_URL()     {''}
sub CATEGORY_NAME_NODASH() {0}
sub DEFAULT_TIMEZONE()     {0}
sub LOG_EXPORT_ENCODING()  {''}
sub EXPORT_ENCODING()      {''}
sub PUBLISH_CHARSET()      {'UTF-8'}

my $ENCODING_NAMES = [
    { 'name' => 'guess',     'display_name' => 'AUTO DETECT' },
    { 'name' => 'utf8',      'display_name' => 'UTF-8' },
    { 'name' => 'ascii',     'display_name' => 'ISO-8859-1' },
    { 'name' => 'WinLatin1', 'display_name' => 'Windows Latin1' },
];

sub ENCODING_NAMES () {
    return $ENCODING_NAMES;
}

my @ENCODINGS_ENCODE = qw( cp1252 utf-8 euc-jp shiftjis 7bit-jis iso-2022-jp
    iso-2022-jp-1 jis0201-raw jis0208-raw
    jis0212-raw cp932 Macjapanese iso-8859-1 );

no warnings 'redefine';
*MT::I18N::encode_text    = \&encode_text;
*MT::I18N::guess_encoding = \&guess_encoding;
*MT::I18N::wrap_text      = \&wrap_text;
*MT::I18N::first_n        = \&first_n;
*MT::I18N::first_n_text   = \&first_n;

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

sub wrap_text_encode {
    my $class = shift;
    my ( $text, $col, $tab_init, $tab_sub ) = @_;
    $tab_init = '' unless defined $tab_init;
    $tab_sub  = '' unless defined $tab_sub;
    require Text::Wrap;
    $Text::Wrap::columns = $col;
    $text = Text::Wrap::wrap( $tab_init, $tab_sub, $text );
    return $text;
}

sub first_n_encode {

    # passthru first_n_words
    my $class = shift;
    my ( $text, $length ) = @_;
    require MT::Util;
    $text = MT::Util::first_n_words( $text, $length );
    return $text;
}

sub guess_encoding_encode {
    my $class = shift;
    my ($text) = @_;
    require Encode::Guess;
    Encode::Guess->set_suspects( MT->config('PublishCharset'),
        @ENCODINGS_ENCODE );
    my $dec = Encode::Guess->guess($text);
    if ( ref($dec) ) {
        return $dec->name;
    }
    else {

        # if Encode was failed to guess, re-try for each encodings.
        for my $encode_name ( MT->config('PublishCharset'),
            @ENCODINGS_ENCODE )
        {
            Encode::Guess->set_suspects($encode_name);
            $dec = Encode::Guess->guess($text);
            if ( ref($dec) ) {
                return $dec->name;
            }
        }
        return MT->config('PublishCharset') || 'utf-8';
    }
}

sub encode_text_encode {
    my $class = shift;
    my ( $text, $from, $to ) = @_;
    $from ||= $class->guess_encoding($text);
    $from = 'euc-jp' if $from eq 'euc';
    $to ||= MT->config('PublishCharset') || 'utf-8';
    $to = 'euc-jp' if $to eq 'euc';

    if ( $from ne $to ) {
        eval {
            if ((   ( 'iso-2022-jp' eq lc($to) ) || ( 'shift_jis' eq lc($to) )
                )
                && ( $from =~ m/^utf-?8/ig )
                )
            {
                $text = Encode::decode_utf8($text)
                    unless Encode::is_utf8($text);

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
                $text = Encode::encode( $to, $text );
            }
            else {
                $text = Encode::encode_utf8($text) if Encode::is_utf8($text);
                Encode::from_to( $text, $from, $to );
            }
        };
        if ( my $err = $@ ) {
            warn $err;
        }
    }
    else {
        $text = Encode::encode_utf8($text) if Encode::is_utf8($text);
    }

    $text;
}

1;
