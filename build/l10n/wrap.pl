#! /usr/bin/perl -w

# Movable Type (r) (C) 2001-2019 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

my $wc =0; # New: count the number of words left to translate!

BEGIN {
    my $LANG = $ARGV[0];
    shift @ARGV unless (-e $LANG);
    my $year = (localtime(time))[5] + 1900;
    print <<EOF;
# Movable Type (r) (C) 2001-2019 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# \$Id:\$

package MT::L10N::$LANG;
use strict;
use warnings;
use utf8;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( \@ISA \%Lexicon );
\@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

\%Lexicon = (
EOF
}

my $tmpl;
my $plugin = q();
my %conv;
my %pgconv;

while (<>) {
    if (/^\s*##\s*(.*)$/) {
        $tmpl = $1;
        if ( $tmpl =~ m!^plugins!
          || $tmpl =~ m!^addons! ) {
            my ($pg) = $tmpl =~ m!^(?:plugins|addons)/(.+?)/.+!;
            %pgconv = () unless $pg eq $plugin;
            $plugin = $pg;
        }
        else {
            $plugin = q();
        }
        my $l = $_;
        last if eof();
        $_ = <>;
        next if ($_ =~ /^\s*$/);
        print $l;
    }
    if (/^[#\s]+['|q{](.+)['|}] => ['|q{](.*)['|}],($|\s*\#)/) { # Now also reads empty/to be translated strings
        my $base = $1; 
        my $trans = $2;
        if ( !exists($conv{$base}) && !exists($pgconv{$base}) ) {
            print $_;
            $words = wordcount($base);
            $wc += $words unless ($trans);
        }
        if ( $plugin ) {
            $pgconv{$base} = 1;
        }
        else {
            $conv{$base} = 1;
        }
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

