#! /usr/local/bin/perl

use strict;

use lib './lib';
use lib './extlib';

use Getopt::Long;

my $L10N_FILE = 'lib/MT/L10N/ja.pm';

GetOptions(
    't:s' => \$L10N_FILE,
);


sub translate {
    return '';
}

my %conv;
my %lconv;

open FH, $L10N_FILE;
while (<FH>) {
    next if (/^\s*#/);
    if ($_ =~ /^\s*(['"])(.+)\1\s*=>\s*(['"])(.+)\3,/) {
	$conv{$2} = $4;
	$lconv{lc $2} = $4;
    }
}
close FH;

my (%phrase, %is_used, $args);
my $text = <>;
my $tmpl = $ARGV;
do {
    if (($tmpl ne $ARGV) || eof()) {
        printf "\n\t## %s\n", $tmpl;
        $tmpl = $ARGV;
        %phrase = ();
        while ($text =~ /<(?:MT_TRANS|mttrans) ([^>]+)>/gs) {
            my($msg, %args) = ($1);
            while ($msg =~ /(\w+)\s*=\s*\\?(["'])(.*?)\\?\2/g) {
                $args{$1} = $3;
            }
            my $trans = '';
            next unless defined $args{phrase};
            $args{phrase} =~ s/([^\\]?)'/$1\\'/g;
            if ($trans eq '' && $conv{$args{phrase}}) {
                 $trans = $conv{$args{phrase}};
                 $is_used{$args{phrase}} = 1;
            }
            $trans =~ s/([^\\])'/$1\\'/g;
            next if ($phrase{$args{phrase}});
            $phrase{$args{phrase}} = 1;
            
            my $q = "'";
            if ($args{phrase} =~ /\\n/) {
               $q = '"';
            }

            if ($trans) {
                printf "\t$q%s$q => '%s',\n", $args{phrase}, $trans;
            } else {
                $trans = $lconv{lc $args{phrase}};
                my $comment = $trans ? "" : "# ";
                printf "\t%s$q%s$q => '%s',\n", $comment, $args{phrase}, $trans;
            }
        }
        # while ($text =~ /(?:translate|errtrans|trans_error)\(\s*((["'])(.*?)\2\s*\.?)[,\)]/gs) { 
        while ($text =~ /(?:translate|errtrans|trans_error|trans)\(((?:\s*(?:"(?:[^"\\]+|\\.)*"|'(?:[^'\\]+|\\.)*')\s*\.?\s*){1,})[,\)]/gs) {
            my($msg, %args);
            my $p = $1;
            while ($p =~ /"((?:[^"\\]+|\\.)*)"|'((?:[^'\\]+|\\.)*)'/gs) {
                $args{'phrase'} .= ($1 || $2);
            }          
            my $trans = '';
            $args{phrase} =~ s/([^\\]?)'/$1\\'/g;
            $args{phrase} =~ s/['"]\s*.\s*\n\s*['"]//gs;
            $args{phrase} =~ s/['"]\s*\n\s*.\s*['"]//gs;
            if ($trans eq '' && $conv{$args{phrase}}) {
                 $trans = $conv{$args{phrase}};
                 $is_used{$args{phrase}} = 1;
            }
            $trans =~ s/([^\\])'/$1\\'/g;
            next if ($phrase{$args{phrase}});
            $phrase{$args{phrase}} = 1;
            my $q = "'";
            if ($args{phrase} =~ /\\n/) {
               $q = '"';
            }
            if ($trans) {
                printf "\t$q%s$q => '%s',\n", $args{phrase}, $trans;
            } else {
                $trans = $lconv{lc $args{phrase}} || '';
                my $comment = $trans ? "" : "# ";
                printf "\t%s$q%s$q => '%s',\n", $comment, $args{phrase}, $trans;
            }
        }
        $text = '';
    }
    $text .= $_ if $_;
} while (<>);

exit;

print "\n\n\t## not used\n";
foreach my $p (keys %conv) {
    $p =~ s/([^\\])'/$1\\'/g;
    unless ($is_used{$p}) {
        my $trans = '';
        if ($conv{$p}) {
             $trans = $conv{$p};
             $is_used{$p} = 0;
        }
        my $q = "'";
        if ($p =~ /\\[a-z]/) {
            $q = '"';    
        }
        $trans =~ s/([^\\])'/$1\\'/g;
	printf "\t$q%s$q => '%s',\n", $p, $trans;
    }
}

1;
