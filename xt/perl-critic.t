use strict;
use warnings;
use FindBin;

use File::Find;
use Test::Perl::Critic (-profile => "$FindBin::Bin/../.perlcriticrc" );

my @files = grep -d $_, qw( lib tools t xt build );
for my $dir ( 'addons', 'plugins' ) {
    next unless -d $dir;
    find( { wanted => \&_find, no_chdir => 1, follow => 1 }, $dir );
}
push @files,
    ( grep { $_ !~ /mt-config\.cgi$/ } grep {/\.(cgi|psgi)$/} glob '*' );

all_critic_ok(@files);

sub _find {
    return if $File::Find::name =~ m!/(?:extlib|local|blib)/!;
    if ( $File::Find::name =~ /\.(?:cgi|pl|pm)\z/ ) {
        push @files, $File::Find::name;
    }
}

