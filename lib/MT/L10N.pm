# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::L10N;
use strict;
use Locale::Maketext;

@MT::L10N::ISA = qw( Locale::Maketext );
@MT::L10N::Lexicon = (
    _AUTO => 1,
);

sub language_name {
    my $tag = $_[0]->language_tag;
    require I18N::LangTags::List;
    return I18N::LangTags::List::name($tag);
}

sub encoding { 'iso-8859-1' }   ## Latin-1
sub ascii_only { 0 }

1;
__END__

=head1 NAME

MT::L10N

=head1 METHODS

=head2 $obj->language_name($code)

Return the value of L<I18N::LangTags::List/name> for the given I<code>.

=head2 encoding

Return 'iso-8859-1' (Latin-1).

=head2 ascii_only

Return zero.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
