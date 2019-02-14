use strict;
use warnings;

use Test::Perl::Critic;

my @files = grep -d $_, qw( lib tools plugins addons t build );
push @files,
    ( grep { $_ !~ /mt-config\.cgi$/ } grep {/\.(cgi|psgi)$/} glob '*' );
all_critic_ok(@files);

