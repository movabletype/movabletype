package Hash::Merge::Simple;
BEGIN {
  $Hash::Merge::Simple::VERSION = '0.051';
}
# ABSTRACT: Recursively merge two or more hashes, simply

use warnings;
use strict;

use vars qw/ @ISA @EXPORT_OK /;
require Exporter;
@ISA = qw/ Exporter /;
@EXPORT_OK = qw/ merge clone_merge dclone_merge /;


# This was stoled from Catalyst::Utils... thanks guys!
sub merge (@);
sub merge (@) {
    shift unless ref $_[0]; # Take care of the case we're called like Hash::Merge::Simple->merge(...)
    my ($left, @right) = @_;

    return $left unless @right;

    return merge($left, merge(@right)) if @right > 1;

    my ($right) = @right;

    my %merge = %$left;

    for my $key (keys %$right) {

        my ($hr, $hl) = map { ref $_->{$key} eq 'HASH' } $right, $left;

        if ($hr and $hl){
            $merge{$key} = merge($left->{$key}, $right->{$key});
        }
        else {
            $merge{$key} = $right->{$key};
        }
    }
    
    return \%merge;
}


sub clone_merge {
    require Clone;
    my $result = merge @_;
    return Clone::clone( $result );
}


sub dclone_merge {
    require Storable;
    my $result = merge @_;
    return Storable::dclone( $result );
}


1;

__END__
=pod

=head1 NAME

Hash::Merge::Simple - Recursively merge two or more hashes, simply

=head1 VERSION

version 0.051

=head1 SYNOPSIS

    use Hash::Merge::Simple qw/ merge /;

    my $a = { a => 1 };
    my $b = { a => 100, b => 2};

    # Merge with righthand hash taking precedence
    my $c = merge $a, $b;
    # $c is { a => 100, b => 2 } ... Note: a => 100 has overridden => 1

    # Also, merge will take care to recursively merge any subordinate hashes found
    my $a = { a => 1, c => 3, d => { i => 2 }, r => {} };
    my $b = { b => 2, a => 100, d => { l => 4 } };
    my $c = merge $a, $b;
    # $c is { a => 100, b => 2, c => 3, d => { i => 2, l => 4 }, r => {} }

    # You can also merge more than two hashes at the same time 
    # The precedence increases from left to right (the rightmost has the most precedence)
    my $everything = merge $this, $that, $mine, $yours, $kitchen_sink, ...;

=head1 DESCRIPTION

Hash::Merge::Simple will recursively merge two or more hashes and return the result as a new hash reference. The merge function will descend and merge
hashes that exist under the same node in both the left and right hash, but doesn't attempt to combine arrays, objects, scalars, or anything else. The rightmost hash
also takes precedence, replacing whatever was in the left hash if a conflict occurs.

This code was pretty much taken straight from L<Catalyst::Utils>, and modified to handle more than 2 hashes at the same time.

=head1 USAGE

=head2 Hash::Merge::Simple->merge( <hash1>, <hash2>, <hash3>, ..., <hashN> )

=head2 Hash::Merge::Simple::merge( <hash1>, <hash2>, <hash3>, ..., <hashN> )

Merge <hash1> through <hashN>, with the nth-most (rightmost) hash taking precedence.

Returns a new hash reference representing the merge.

NOTE: The code does not currently check for cycles, so infinite loops are possible:

    my $a = {};
    $a->{b} = $a;
    merge $a, $a;

NOTE: If you want to avoid giving/receiving side effects with the merged result, use C<clone_merge> or C<dclone_merge>
An example of this problem (thanks Uri):

    my $left = { a => { b => 2 } } ;
    my $right = { c => 4 } ;

    my $result = merge( $left, $right ) ;

    $left->{a}{b} = 3 ;
    $left->{a}{d} = 5 ;

    # $result->{a}{b} == 3 !
    # $result->{a}{d} == 5 !

=head2 Hash::Merge::Simple->clone_merge( <hash1>, <hash2>, <hash3>, ..., <hashN> )

=head2 Hash::Merge::Simple::clone_merge( <hash1>, <hash2>, <hash3>, ..., <hashN> )

Perform a merge, clone the merge, and return the result

This is useful in cases where you need to ensure that the result can be tweaked without fear
of giving/receiving any side effects

This method will use L<Clone> to do the cloning

=head2 Hash::Merge::Simple->dclone_merge( <hash1>, <hash2>, <hash3>, ..., <hashN> )

=head2 Hash::Merge::Simple::dclone_merge( <hash1>, <hash2>, <hash3>, ..., <hashN> )

Perform a merge, clone the merge, and return the result

This is useful in cases where you need to ensure that the result can be tweaked without fear
of giving/receiving any side effects

This method will use L<Storable> (dclone) to do the cloning

=head1 SEE ALSO

L<Hash::Merge>

L<Catalyst::Utils>

L<Clone>

L<Storable>

=head1 ACKNOWLEDGEMENTS

This code was pretty much taken directly from L<Catalyst::Utils>:

Sebastian Riedel C<sri@cpan.org>

Yuval Kogman C<nothingmuch@woobling.org>

=head1 AUTHOR

Robert Krimen <robertkrimen@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Robert Krimen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

