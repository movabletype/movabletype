#!/usr/bin/perl

package HTML::Diff;

$VERSION = '0.561';

use strict;

use Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(line_diff word_diff html_word_diff);

# This list of tags is taken from the XHTML spec and includes
# all those for which no closing tag is expected. In addition
# the pattern below matches any tag which ends with a slash /

our @UNBALANCED_TAGS = qw(br hr p li base basefont meta link 
			  col colgroup frame input isindex area 
			  embed img bgsound marquee);

use Algorithm::Diff 'sdiff';

sub member {
    my ($item, @list) = @_;

    return scalar(grep {$_ eq $item} @list);
}

sub html_word_diff {
    my ($left, $right) = @_;

    # Split the two texts into words and tags.
    my (@leftchks) = $left =~ m/(<[^>]*>\s*|[^<]+)/gm;
    my (@rightchks) = $right =~ m/(<[^>]*>\s*|[^<]+)/gm;
    
    @leftchks = map { $_ =~ /^<[^>]*>$/ ? $_ : ($_ =~ m/(\S+\s*)/gm) }
                    @leftchks;
    @rightchks = map { $_ =~ /^<[^>]*>$/ ? $_ : ($_ =~ m/(\S+\s*)/gm) } 
                     @rightchks;

    # Remove blanks; maybe the above regexes could handle this?
    @leftchks = grep { $_ ne '' } @leftchks;
    @rightchks = grep { $_ ne '' } @rightchks;

    # Now we process each segment by turning it into a pair. The first element
    # is the text as we want it to read in the result. The second element is
    # the value we will to use in comparisons. It contains an identifier
    # for each of the balanced tags that it lies within.

    # This subroutine holds state in the tagstack variable
    my $tagstack = [];
    my $smear_tags = sub {
	if ($_ =~ /^<.*>/) {
	    if ($_ =~ m|^</|) {
		my ($tag) = m|^</\s*([^ \t\n\r>]*)|;
		$tag = lc $tag;
#                print STDERR "Found closer of $tag with " . (scalar @$tagstack) . " stack items\n";
		# If we found the closer for the tag on top 
		# of the stack, pop it off.
		if ((scalar @$tagstack) > 0 && $$tagstack[-1] eq $tag) {
                    my $stacktag = pop @$tagstack;
                }
		return [$_, $tag];
	    } else {
		my ($tag) = m|^<\s*([^\s>]*)|;
		$tag = lc $tag;
#                print STDERR "Found opener of $tag with " . (scalar @$tagstack) . " stack items\n";
		if (member($tag, @UNBALANCED_TAGS) || $tag =~ m#/\s*>$#)
		{	                # (tags without correspond closer tags)
		    return [$_, $tag];
		} else {
		    push @$tagstack, $tag;
		}
		return [$_, $_];
	    }
	} else {
	    my $result = [$_, (join "!!!", (@$tagstack, $_)) ];
	    return $result;
	}
    };

    # Now do the "smear tags" operation across each of the chunk-lists
    $tagstack = [];
    @leftchks = map { &$smear_tags } @leftchks;
    # TBD: better modularity would preclude having to reset the stack
    $tagstack = [];
    @rightchks = map { &$smear_tags } @rightchks;

#    print STDERR Data::Dumper::Dumper(\@leftchks);
#    print STDERR Data::Dumper::Dumper(\@rightchks);
	
    # Now do the diff, using the "comparison" half of the pair to
    # compare two chuncks.
    my $chunks = sdiff(\@leftchks, \@rightchks,
		      sub { $_ = elem_cmprsn(shift); $_ =~ s/\s+$/ /g; $_ });

#    print STDERR Data::Dumper::Dumper($chunks);
	
    # Finally, process the output of sdiff by concatenating
    # consecutive chunks that were "unchanged."
    my $lastsignal = '';
    my $lbuf = "";
    my $rbuf = "";
    my @result;
    my $ch;
    foreach $ch (@$chunks) {
	my ($signal, $left, $right) = @$ch;
        if ($signal ne $lastsignal && $lastsignal ne '') {
	    if ($signal ne 'u' && $lastsignal ne 'u') {
		$signal = 'c';
	    } else {
		push @result, [$lastsignal, $lbuf, $rbuf];
		$lbuf = "";
		$rbuf = "";	    
	    }
	}
# 	if ($signal eq 'u' && $lastsignal ne 'u') {
# 	    push @result, [$lastsignal, $lbuf, $rbuf]
# 		unless $lastsignal eq '';
# 	    $lbuf = "";
# 	    $rbuf = "";
# 	} elsif ($signal ne 'u' && $lastsignal eq 'u') {
# 	    push @result, [$lastsignal, $lbuf, $rbuf];
# 	    $lbuf = "";
# 	    $rbuf = "";
# 	}
        my $lelem = elem_mkp($left);
        my $relem = elem_mkp($right);
        $lbuf .= (defined $lelem ? $lelem : '');
        $rbuf .= (defined $relem ? $relem : '');
	$lastsignal = $signal;
    }
    push @result, [$lastsignal, $lbuf, $rbuf];
    return \@result;
}

# these are like "accessors" for the two halves of the diff-chunk pairs
sub elem_mkp {
    my ($e) = @_;
    return undef unless ref $e eq 'ARRAY';
    my ($mkp, $cmp) = @$e;
    return $mkp;
}

sub elem_cmprsn {
    my ($e) = @_;
    return undef unless ref $e eq 'ARRAY';
    my ($mkp, $cmp) = @$e;
    return $cmp;
}

# Finally a couple of non-HTML diff routines

sub line_diff {
    my ($left, $right) = @_;
    my (@leftchks) = $left =~ m/(.*\n?)/gm;
    my (@rightchks) = $right =~ m/(.*\n?)/gm;
    my $result = sdiff(\@leftchks, \@rightchks);
#    my @result = map { [ $_->[1], $_->[2] ] } @$result;
    return $result;
}

sub word_diff {
    my ($left, $right) = @_;
    my (@leftchks) = $left =~ m/([^\s]*\s?)/gm;
    my (@rightchks) = $right =~ m/([^\s]*\s?)/gm;

    my $result = sdiff(\@leftchks, \@rightchks);
    my @result = (map { [ $_->[1], $_->[2] ] } @$result);
    return $result;
}

1;

=pod

=head1 HTML::Diff

This module compares two strings of HTML and returns a list of a
chunks which indicate the diff between the two input strings, where
changes in formatting are considered changes.

HTML::Diff does not strictly parse the HTML. Instead, it uses regular
expressions to make a decent effort at understanding the given HTML.
As a result, there are many valid HTML documents for which it will not
produce the correct answer. But there may be some invalid HTML
documents for which it gives you the answer you're looking for. Your
mileage may vary; test it on lots of inputs from your domain before
relying on it.

=head1 SYNOPSIS

    $result = html_word_diff($left_text, $right_text);

=head1 DESCRIPTION

Returns a reference to a list of triples [<flag>, <left>, <right>].
Each triple represents a check of the input texts. The flag tells you
whether it represents a deletion, insertion, a modification, or an
unchanged chunk.

Every character of each input text is accounted for by some triple in
the output. Specifically, Concatenating all the <left> members from
the return value should produce C<$left_text>, and likewise the
<right> members concatenate together to produce C<$right_text>.

The <flag> is either C<'u'>, C<'+'>, C<'-'>, or C<'c'>, indicating
whether the two chunks are the same, the $right_text contained this
chunk and the left chunk didn't, or vice versa, or the two chunks are
simply different. This follows the usage of Algorithm::Diff.

The difference is computed on a word-by-word basis, "breaking" on
visible words in the HTML text. If a tag only is changed, it will not
be returned as an independent chunk but will be shown as a change to
one of the neighboring words. For balanced tags, such as <b> </b>, it
is intended that a change to the tag will be treated as a change to
all words in between.

=head1 AUTHOR

Whipped up by Ezra elias kilty Cooper, <ezra@ezrakilty.net>.

Patch contributed by Adam <asjo@koldfront.dk>.

=head1 SEE ALSO

Algorithm::Diff

=cut
