# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
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
                wrap_text first_n_text break_up_text convert_high_ascii);

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

=head1 DESCRIPTION

=head1 SYNOPSIS

=head1 USAGE

=head2 guess_encoding($text)

Attempts to determine the character encoding of the given string.

=head2 encode_text($text, $from, $to)

Transcodes given string from one encoding to another.

=head2 substr_text($text, $offset, $length)

=head2 wrap_text($text, $columns, $tab_init, $tab_width)

=head2 length_text($text)

=head2 firstn($text, $n)

=head2 first_n_text($text, $n)

=head2 break_up_text($text, $max_length)

=head2 convert_high_ascii($text)

=head2 const($id)

=head1 LICENSE

The license that applies is the one you agreed to when downloading
Movable Type.

=head1 AUTHOR & COPYRIGHT

Except where otherwise noted, MT is Copyright 2001-2006 Six Apart.
All rights reserved.

=cut