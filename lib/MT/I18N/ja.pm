# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::I18N::ja;

use strict;
use warnings;
use MT::Util qw(remove_html);
use vars qw( @ISA );
@ISA = qw( MT::I18N::default );

sub DEFAULT_LENGTH_ENTRY_EXCERPT ()                    {40}
sub LENGTH_ENTRY_TITLE_FROM_TEXT ()                    {10}
sub LENGTH_ENTRY_PING_EXCERPT ()                       {80}
sub LENGTH_ENTRY_PING_TITLE_FROM_TEXT ()               {10}
sub DISPLAY_LENGTH_MENU_TITLE ()                       {11}
sub DISPLAY_LENGTH_EDIT_COMMENT_TITLE ()               {12}
sub DISPLAY_LENGTH_EDIT_COMMENT_AUTHOR ()              {12}
sub DISPLAY_LENGTH_EDIT_COMMENT_TEXT_SHORT ()          {23}
sub DISPLAY_LENGTH_EDIT_COMMENT_TEXT_LONG ()           {45}
sub DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_SHORT () {30}
sub DISPLAY_LENGTH_EDIT_COMMENT_TEXT_BREAK_UP_LONG ()  {80}
sub DISPLAY_LENGTH_EDIT_PING_TITLE_FROM_EXCERPT ()     {25}
sub DISPLAY_LENGTH_EDIT_PING_BREAK_UP ()               {30}
sub DISPLAY_LENGTH_EDIT_ENTRY_TITLE ()                 {11}
sub DISPLAY_LENGTH_EDIT_ENTRY_TEXT_FROM_EXCERPT ()     {25}
sub DISPLAY_LENGTH_EDIT_ENTRY_TEXT_BREAK_UP ()         {30}

sub PORTAL_URL()   {'https://www.sixapart.jp/movabletype/'}
sub SUPPORT_URL()  {'https://www.sixapart.jp/movabletype/support/'}
sub NEWS_URL()     {'https://www.sixapart.jp/movabletype/'}
sub NEWSBOX_URL()  {'https://www.sixapart.jp/movabletype/news/newsbox.json'}
sub FEEDBACK_URL() {'https://www.sixapart.jp/movabletype/feedback.html'}
sub LATEST_VERSION_URL()   {'https://movabletype.jp/latest_version.json'}
sub LEARNINGNEWS_URL()     {''}
sub CATEGORY_NAME_NODASH() {1}
sub DEFAULT_TIMEZONE()     {9}
sub LOG_EXPORT_ENCODING()  {'Shift_JIS'}
sub EXPORT_ENCODING()      {'Shift_JIS'}
sub PUBLISH_CHARSET()      {'UTF-8'}

my $ENCODING_NAMES = [
    { 'name' => 'guess',     'display_name' => 'AUTO DETECT' },
    { 'name' => 'sjis',      'display_name' => 'SHIFT_JIS' },
    { 'name' => 'euc-jp',    'display_name' => 'EUC-JP' },
    { 'name' => 'utf8',      'display_name' => 'UTF-8' },
    { 'name' => 'ascii',     'display_name' => 'ISO-8859-1' },
    { 'name' => 'WinLatin1', 'display_name' => 'Windows Latin1' },
];

sub ENCODING_NAMES () {
    return $ENCODING_NAMES;
}

my $ENCODINGS_LABEL = {
    'shift_jis'   => 'sjis',
    'iso-2022-jp' => 'jis',
    'euc-jp'      => 'euc',
    'utf-8'       => 'utf8',
    'ascii'       => 'utf8',
    'iso-8859-1'  => 'ascii',
};

my @ENCODINGS_ENCODE = qw( euc-jp shiftjis 7bit-jis iso-2022-jp
    iso-2022-jp-1 jis0201-raw jis0208-raw
    jis0212-raw cp932 Macjapanese );

{
    no warnings 'redefine';
    *MT::I18N::encode_text    = \&encode_text_ja;
    *MT::I18N::guess_encoding = \&guess_encoding_ja;
    *MT::I18N::wrap_text      = \&wrap_text_ja;
    *MT::I18N::first_n        = \&first_n_ja;
    *MT::I18N::first_n_text   = \&first_n_ja;
}

sub encode_text_ja {
    return __PACKAGE__->encode_text_encode(@_);
}

sub guess_encoding_ja {
    return __PACKAGE__->guess_encoding_encode(@_);
}

sub wrap_text_ja {
    return __PACKAGE__->wrap_text_encode(@_);
}

sub first_n_ja {
    return __PACKAGE__->first_n_encode(@_);
}

sub wrap_text_encode {
    my $class = shift;
    my ( $text, $cols, $tab_init, $tab_sub, $enc ) = @_;
    return $text if !defined($text) || ( $text eq q() );
    $text = Encode::encode_utf8($text);
    eval {

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
    };

    $cols ||= 72;
    Encode::from_to( $text, 'UTF-8', 'EUC-JP' );
    my $out = '';
    my $str = '';
    my $b   = 0;
    for ( my $i = 0; $i < length($text); $i++ ) {
        if (   substr( $text, $i, 2 ) =~ /[\xA1-\xFE][\xA1-\xFE]/
            || substr( $text, $i, 2 ) =~ /[\x8E][\xA1-\xDF]/ )
        {
            $str = substr( $text, $i, 2 );
            $i++;
            $b += 2;
        }
        elsif ( substr( $text, $i, 3 ) =~ /[\x8F][\xA1-\xFE][\xA1-\xFE]/ ) {
            $str = substr( $text, $i, 3 );
            $i += 2;
            $b += 2;
        }
        elsif ( substr( $text, $i, 1 ) =~ /[\n\r]/ ) {
            $str = substr( $text, $i, 1 );
            $b = 0;
        }
        elsif ( ord( substr( $text, $i, 1 ) ) < 0x80 ) {
            $str = substr( $text, $i, 1 );
            $b += 1;
        }

        if ( $b > $cols ) {
            $out .= "\n";
            $b = 0;
        }
        $out .= $str;
    }
    return Encode::decode( 'EUC-JP', $out );
}

sub first_n_encode {
    my $class = shift;
    my ( $text, $length, $enc ) = @_;
    require MT::Util;
    $text = MT::Util::remove_html($text);
    $text =~ s/(\r?\n)+/ /g;
    $text = substr( $text, 0, $length );
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

sub _conv_enc_label {
    my $class = shift;
    my $enc   = shift;
    $enc = lc $enc;
    $enc = $ENCODINGS_LABEL->{$enc} ? $ENCODINGS_LABEL->{$enc} : $enc;
    return $enc;
}

1;
