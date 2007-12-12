# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::I18N;

use strict;
use MT;
use MT::I18N::default;
use Exporter;
use vars qw(@ISA @EXPORT_OK);
@ISA = qw(Exporter);
@EXPORT_OK = qw(encode_text substr_text length_text guess_encoding const
                wrap_text first_n_text break_up_text convert_high_ascii
                lowercase uppercase);

BEGIN {
    eval { require Encode; };
    if ($@) {
        *decode = sub {
            _handle(decode => @_);
        };
    } else {
        *decode = sub {
            Encode::decode(@_);
        };
    }
};

my %Supported_Languages = map {$_ => 1} ( qw( en_us ja ) );

sub guess_encoding { _handle(guess_encoding => @_) }
sub encode_text { _handle(encode_text => @_) }
sub substr_text { _handle(substr_text => @_) }
sub wrap_text { _handle(wrap_text => @_) }
sub length_text { _handle(length_text => @_) }
sub first_n { _handle(first_n => @_) }
sub first_n_text { _handle(first_n => @_) } # for backward compatibility
sub break_up_text { _handle(break_up_text => @_) }
sub convert_high_ascii { _handle(convert_high_ascii => @_) }
sub decode_utf8 { _handle(decode_utf8 => @_) }
sub utf8_off { _handle(utf8_off => @_) }
sub lowercase { _handle(lowercase => @_) }
sub uppercase { _handle(uppercase => @_) }

sub const {
    my $label = shift;
    my $lang = _language();
    my $class = 'MT::I18N::' . $lang;
    $class->$label();
}

sub _handle {
    my $meth = shift;
    my $lang = _language();
    my $class = 'MT::I18N::' . $lang;
    $class->$meth(@_);
}

sub _language {
    my $lang = lc MT->current_language;
    $lang =~ tr/-/_/;
    if (($Supported_Languages{$lang}) || 2 < 2) {
        eval 'require MT::I18N::' . $lang;
        die if $@;
        $Supported_Languages{$lang} = 2; # lang package loaded
    }
    $Supported_Languages{$lang} ? $lang : 'default';
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

=head2 utf8_off($text)

Turn off UTF-8 encoding in the given I<text>

=head2 const($id)

Return the value of the given I<id> method from the C<MT::I18N>
package for the current language.

=head1 LICENSE

The license that applies is the one you agreed to when downloading
Movable Type.

=head1 AUTHOR & COPYRIGHT

Except where otherwise noted, MT is Copyright 2001-2007 Six Apart.
All rights reserved.

=cut
