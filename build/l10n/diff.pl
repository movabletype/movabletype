use strict;
use Getopt::Long;

my ($file1, $file2);
my (%conv1, %conv2);
my (%conv1_lc, %conv2_lc);

GetOptions( 'old:s' => \$file1,
            'new:s' => \$file2,
);

# print "## old: $file1 new: $file2 \n";
print "\n\t## phrases from previous version.\n";

open FH, $file1;
while (<FH>) {
    next if (/^\s*#/);
    if ($_ =~ /^\s*(['"])(.+)\1\s*=>\s*(['"])(.+)\3,/) {
	# print STDERR $2, "\n";
	$conv1{$2} = $4;
	$conv1_lc{lc $2} = $4;
    }
}
close FH;

open FH, $file2;
while (<FH>) {
    # next if (/^\s*#/);
    if ($_ =~ /^\s*#?\s*(['"])(.+)\1\s*=>\s*(['"])(.+)\3,/) {
	# print STDERR $2, "\n";
	$conv2{$2} = $4;
	$conv2_lc{lc $2} = $4;
    }
}
close FH;

my %check;

foreach my $p (sort keys %conv1) {
    if ($conv1{$p} eq $conv2{$p}) {
        $check{$p} = 1;
    } elsif ($conv2{$p} && $conv1{$p} ne $conv2{$p}) {
        # printf "\t'%s' => '%s',  # modified from '%s'\n", $p, $conv2{$p}, $conv1{$p};
        $check{$p} = 1;
    } elsif ($conv2_lc{lc $p}) {
        # printf "\t'%s' => '%s',  # changed UPPER/LOWER '%s'\n", $p, $conv2_lc{lc $p}, $conv1_lc{lc $p};
        $check{$p} = 1;
        $check{lc $p} = 1;
    } elsif (!$conv2{$p}) {
        # printf "\t'%s' => '%s',  # only old. \n", $p, $conv1{$p};
        my $q = "'";
        if ($p =~ /\\[a-z]/) {
            $q = '"';
        }
        printf "\t$q%s$q => '%s',\n", $p, $conv1{$p};
    }
}

# print "\n\n# only in new\n\n";
# foreach my $p (sort keys %conv2) {
#    unless ($check{$p} || $check{lc $p}) {
#        printf "\t'%s' => '%s',\n", $p, $conv2{$p};
#     }
# }

1;
