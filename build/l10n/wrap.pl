#! /usr/bin/perl -w

# Movable Type (r) Open Source (C) 2005-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

my $wc =0; # New: count the number of words left to translate!

BEGIN {
    my $LANG = $ARGV[0];
    shift @ARGV unless (-e $LANG);
    print <<EOF;
# Copyright 2003-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.
#
# \$Id:\$

package MT::L10N::$LANG;
use strict;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( \@ISA \%Lexicon );
\@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

\%Lexicon = (
EOF
}

my $tmpl;

while (<>) {
    if (/^\s*##\s*(.*)$/) {
        $tmpl = $1;
        my $l = $_;
        last if eof();
        $_ = <>;
        next if ($_ =~ /^\s*$/);
        print $l;
    }
    if (/^[#\s]+'(.+)' => '(.*)',($|\s*\#)/) { # Now also reads empty/to be translated strings
        my $base = $1; 
        my $trans = $2;
        unless (defined $conv{$base}) {
		print $_;
		$words = wordcount($base);
		$wc += $words unless ($trans);
        }
        $conv{$base} = 1;
    }
    else{
	    print $_;
    }
}

END {
    print <<EOF

);

## New words: $wc

1;
EOF

}
sub wordcount {
        my $l = shift;
    $l =~ s/[`!"$%^&*()_+={[}\];:@~#,.<>?\\\/]/ /g; #`
    $l =~ s/\ ([ei])\ ([ge])\ / $1.$2./g;
    my @words = split(/\W*\s+\W*/, $l);         # see the Camel book p.39
        return ($#words + 1);
}

