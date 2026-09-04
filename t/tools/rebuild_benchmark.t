use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Test::Permission;
use IPC::Run3 qw/run3/;
use File::Spec;

$test_env->prepare_fixture('db');
my $objs = MT::Test::Fixture->prepare(
    {   author  => [ { name => 'admin', password => 'pass', is_superuser => 1 } ],
        website => [ { id => 1, name => 'my_website' } ],
    }
);

my $website = $objs->{website}{my_website};
is $website->id, 1, 'website id is 1';

my $home = $ENV{MT_HOME};

sub run_rebuild_benchmark {
    my @options = @_;
    my @cmd     = (
        $^X,
        '-I', File::Spec->catdir( $home, 't/lib' ),
        File::Spec->catfile( $home, 'tools/rebuild-benchmark' ),
        '-mt_url', 'http://127.0.0.1:1/mt.cgi',
        '-user',   'admin',
        '-pass',   'pass',
        @options,
    );

    run3 \@cmd, \my $stdin, \my $stdout, \my $stderr;

    return ( $stdout, $stderr, $? );
}

subtest 'run without blog_id option' => sub {
    my ( $stdout, $stderr, $status ) = run_rebuild_benchmark();

    is $status, 0, 'exits successfully' or diag $stderr;
    like $stdout, qr/rebuilding \(1\) my_website/,
        'website (id:1) is targeted by default';
};

subtest 'run with multiple blog_ids' => sub {
    my $child = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'my_child_blog',
    );

    my ( $stdout, $stderr, $status )
        = run_rebuild_benchmark( '-blog_id',
        join( ',', $website->id, $child->id ) );

    is $status, 0, 'exits successfully' or diag $stderr;
    like $stdout, qr/rebuilding \(1\) my_website/,    'website is targeted';
    like $stdout, qr/rebuilding \(1\) my_child_blog/, 'child blog is targeted';
};

done_testing;
