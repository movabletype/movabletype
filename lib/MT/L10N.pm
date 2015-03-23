# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::L10N;
use strict;
use Locale::Maketext;

@MT::L10N::ISA = qw( Locale::Maketext );
@MT::L10N::Lexicon = ( _AUTO => 1, );

our $PERMITTED_METHODS_REGEX = qr/^(?:lc|uc|quant|numerate|numf|sprintf)$/;

sub language_name {
    my $tag = $_[0]->language_tag;
    require I18N::LangTags::List;
    return I18N::LangTags::List::name($tag);
}

sub encoding   {'iso-8859-1'}    ## Latin-1
sub ascii_only {0}

sub lc {
    my $lh = shift;
    lc( $_[0] );
}

sub uc {
    my $lh = shift;
    uc( $_[0] );
}

# Restrict enabled methods in bracket.
sub _compile {
    my ( $lh, $string ) = @_;

    if ( $string
        && grep { $_ !~ m/$PERMITTED_METHODS_REGEX/ && $_ !~ m/^_-?\d+$/ }
        ( $string =~ m/(?:^|[^~])(?:~~)*\[(\w+)(?:,|\])/gs ) )
    {
        die 'Invalid method in translating phrase: "' . $string . '"';
    }

    return $lh->SUPER::_compile($string);
}

1;
__END__

=head1 NAME

MT::L10N - Localization support for MT

=head1 METHODS

=head2 $obj->language_name($code)

Return the value of L<I18N::LangTags::List/name> for the given I<code>.

=head2 encoding

Return 'iso-8859-1' (Latin-1).

=head2 ascii_only

Return zero.

=head2 $obj->_compile($str)

Override Locale::Maketext::_compile. Non-permitted methods but underscore and numbers like "_1" in bracket notation are forbidden here. Permitted methods are defined by $PERMITTED_METHODS_REGEX.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
