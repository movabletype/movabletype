use strict;
use warnings;
use FindBin;

use File::Find;
use Test::More;
use Test::Perl::Critic (-profile => "$FindBin::Bin/../.perlcriticrc", -verbose => '[%p] %f %l:%c (%s)' );

my @files;
for my $dir (qw( lib tools t xt build addons plugins )) {
    next unless -d $dir;
    find( { wanted => \&_find, no_chdir => 1, follow_fast => 1 }, $dir );
}
push @files,
    ( grep { $_ !~ /mt-config\.cgi$/ } grep {/\.(cgi|psgi)$/} glob '*' );

for my $file (sort @files) {
    next unless -f $file;
    critic_ok($file);
}

done_testing;

sub _find {
    return if $File::Find::name =~ m!/(?:extlib|local|blib)/!;
    if ( $File::Find::name =~ /\.(?:cgi|pl|pm)\z/ ) {
        push @files, $File::Find::name;
    }
}

