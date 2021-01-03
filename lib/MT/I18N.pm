# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::I18N;

use strict;
use warnings;
use Encode;
use MT::I18N::default;
use Exporter;
use vars qw(@ISA @EXPORT_OK);
@ISA       = qw(Exporter);
@EXPORT_OK = qw(encode_text substr_text length_text guess_encoding const
    wrap_text first_n_text break_up_text convert_high_ascii
    lowercase uppercase utf8_off);

my %Supported_Languages = map { $_ => 1 } (qw( en_us ja ));

no warnings 'redefine';
sub guess_encoding { _handle( guess_encoding => @_ ) }
sub encode_text    { _handle( encode_text    => @_ ) }
sub wrap_text      { MT::I18N::default->wrap_text_encode(@_); }
sub first_n        { _handle( first_n        => @_ ) }
sub first_n_text { _handle( first_n => @_ ) }    # for backward compatibility

sub substr_text {
    my ( $text, $startpos, $length, $enc ) = @_;
    $text = substr( $text, $startpos, $length );
    $text;
}

sub length_text {
    my ( $text, $enc ) = @_;
    return length($text);
}

sub break_up_text {
    MT::Util::break_up_text(@_);
}

my %HighASCII = (
    "\xc0" => 'A',     # A`
    "\xe0" => 'a',     # a`
    "\xc1" => 'A',     # A'
    "\xe1" => 'a',     # a'
    "\xc2" => 'A',     # A^
    "\xe2" => 'a',     # a^
    "\xc4" => 'A',     # A:
    "\xe4" => 'a',     # a:
    "\xc5" => 'A',     # Aring
    "\xe5" => 'a',     # aring
    "\xc6" => 'AE',    # AE
    "\xe6" => 'ae',    # ae
    "\xc3" => 'A',     # A~
    "\xe3" => 'a',     # a~
    "\xc8" => 'E',     # E`
    "\xe8" => 'e',     # e`
    "\xc9" => 'E',     # E'
    "\xe9" => 'e',     # e'
    "\xca" => 'E',     # E^
    "\xea" => 'e',     # e^
    "\xcb" => 'E',     # E:
    "\xeb" => 'e',     # e:
    "\xcc" => 'I',     # I`
    "\xec" => 'i',     # i`
    "\xcd" => 'I',     # I'
    "\xed" => 'i',     # i'
    "\xce" => 'I',     # I^
    "\xef" => 'i',     # i:
    "\xd2" => 'O',     # O`
    "\xf2" => 'o',     # o`
    "\xd3" => 'O',     # O'
    "\xf3" => 'o',     # o'
    "\xd4" => 'O',     # O^
    "\xf4" => 'o',     # o^
    "\xd6" => 'O',     # O:
    "\xf6" => 'o',     # o:
    "\xd5" => 'O',     # O~
    "\xf5" => 'o',     # o~
    "\xd8" => 'O',     # O/
    "\xf8" => 'o',     # o/
    "\xd9" => 'U',     # U`
    "\xf9" => 'u',     # u`
    "\xda" => 'U',     # U'
    "\xfa" => 'u',     # u'
    "\xdb" => 'U',     # U^
    "\xfb" => 'u',     # u^
    "\xdc" => 'U',     # U:
    "\xfc" => 'u',     # u:
    "\xc7" => 'C',     # ,C
    "\xe7" => 'c',     # ,c
    "\xd1" => 'N',     # N~
    "\xf1" => 'n',     # n~
    "\xdd" => 'Y',     # Yacute
    "\xfd" => 'y',     # yacute
    "\xdf" => 'ss',    # szlig
    "\xff" => 'y'      # yuml
);
my $HighASCIIRE = join '|', keys %HighASCII;

sub convert_high_ascii {
    my ($s) = @_;
    $s =~ s/($HighASCIIRE)/$HighASCII{$1}/g;
    $s;
}

#sub decode_utf8 {
#    my $class = shift;
#    Encode::decode_utf8(@_);
#}

sub is_utf8 {
    my ($text) = @_;
    Encode::is_utf8($text);
}

sub utf8_off {
    my ($text) = @_;
    Encode::_utf8_off($text);
    return $text;
}

sub lowercase {
    return lc $_[0];
}

sub uppercase {
    return uc $_[0];
}

sub const {
    my $label = shift;
    my $lang  = _language();
    my $class = 'MT::I18N::' . $lang;
    $class->$label();
}

sub _handle {
    my $meth  = shift;
    my $lang  = _language();
    my $class = 'MT::I18N::' . $lang;
    $class->$meth(@_);
}

sub _language {
    my $lang = lc MT->current_language;

    #if ( MT->config('UseJcodeModule') ) {
    #    $lang = 'ja';
    #}
    $lang =~ tr/-/_/;
    if ( ( $Supported_Languages{$lang} ) || 2 < 2 ) {
        my $class = 'MT::I18N::' . $lang;
        eval "require $class";
        die if $@;
        $class->import();
        $Supported_Languages{$lang} = 2;    # lang package loaded
    }
    $Supported_Languages{$lang} ? $lang : 'default';
}

sub languages_list {
    my ( $app, $curr ) = @_;

    $app ||= MT->instance;
    my $langs = $app->supported_languages;
    my @data;
    $curr ||= $app->config('DefaultLanguage');
    $curr = 'en-us' if ( lc($curr) eq 'en_us' );
    my $curr_lang = $app->current_language;
    for my $tag ( keys %$langs ) {
        ( my $name = $langs->{$tag} ) =~ s/\w+ English/English/;
        $app->set_language($tag);
        my $row = { l_tag => $tag, l_name => $app->translate($name) };
        $row->{l_selected} = 1 if $curr eq $tag;
        push @data, $row;
    }
    $app->set_language($curr_lang);
    [ sort { $a->{l_name} cmp $b->{l_name} } @data ];
}

1;
__END__

=head1 NAME

MT::I18N - Internationalization support for MT

=head1 USAGE

=head2 guess_encoding($text)

Attempt to determine the character encoding of the given I<text>.

=head2 encode_text($text, $from, $to)

Transcode the given I<text> from one encoding to another.

=head2 substr_text($text, $offset, $length)

Return the substring of the given I<text>.

=head2 wrap_text($text, $columns, $tab_init, $tab_width)

Retrun the wrapped version of the given I<text>.

=head2 length_text($text)

Return the length of the given I<text>.

=head2 first_n($text, $n)

Return the first I<n> characters of the given I<text>.

=head2 first_n_text($text, $n)

Return the first I<n> characters of the given I<text>.

=head2 break_up_text($text, $max_length)

Return the I<text> up to the given I<max_length>.

=head2 convert_high_ascii($text)

Convert the given I<text> from "high ASCII" encoding.

=head2 decode_utf8($text)

Decode UTF-8 in the given I<text>.

=head2 is_utf8($text)

Tests whether the UTF8 flag is turned on in the $text. Returns true
if successful, false otherwise.

=head2 utf8_off($text)

Turn off UTF-8 encoding in the given I<text>

=head2 lowercase($text)

Returns an lowercased version of $text.

=head2 uppercase($text)

Returns an uppercased version of $text.

=head2 const($id)

Return the value of the given I<id> method from the C<MT::I18N>
package for the current language.

=head2 languages_list($app, $current)

Returns a reference to an array of hashes which contains necessary
data to render a dropdown list of languages that MT supports.
Dropdown lists appear on User Profile, System Settings, and the
start page of the wizard, among others.

=head2 decode($enc, $text)

Decode the given I<text> from the charset specified in I<enc>
to UTF-8 string.

=head2 encode($enc, $text)

Encode the given I<text> that is a UTF-8 string to the charset
specified in I<enc>.

=head1 LICENSE

The license that applies is the one you agreed to when downloading
Movable Type.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
