#! /usr/bin/perl -w

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
    if (/^[#\s]+'(.+)' => '(.+)',$/) {
        my $base = $1; 
        my $trans = $2;
        if (defined $conv{$base}) {
	    s/^(\s+)'/$1# '/;
        }
        $conv{$base} = 1;
    }
    print $_;
}

END {
    print <<EOF

);

1;
EOF

}
