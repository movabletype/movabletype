use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use utf8;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath    => ['TEST_ROOT/plugins'],
        RPTProcessCap => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    my $plugin_dir = File::Spec->catdir( $test_env->root, "plugins" );
    $test_env->save_file( 'plugins/RPTTest/config.yaml', <<'YAML' );
name: RPTTest
key:  RPTTest
id:   RPTTest

task_workers:
    Test1:
        label: Test1
        class: MT::Worker::Test1
    Test2:
        label: Test2
        class: MT::Worker::Test2
YAML

    my $sleep = 3;
    for my $key (qw/Test1 Test2/) {
        $sleep--;
        $test_env->save_file( "lib/MT/Worker/$key.pm", <<"CODE" );
package MT::Worker::$key;
use strict;
use warnings;
use base 'TheSchwartz::Worker';

sub work {
    my \$class = shift;
    my TheSchwartz::Job \$job = shift;

    print STDERR "Working on MT::Worker::$key\n";

    print STDERR "[" . time . "] $key starts waiting for $sleep\n";

    sleep $sleep;

    print STDERR "[" . time . "] $key\n";

    \$job->completed;
}
1;
CODE
    }

    lib->import( File::Spec->catdir( $test_env->root, "lib" ) );
}

use MT;
use MT::Test;
use MT::Util::UniqueID;
use MT::TheSchwartz;
use TheSchwartz::Job;
use Test::SharedFork;
use IPC::Run3 qw/run3/;

$test_env->prepare_fixture('db_data');

sub run {
    my @opts = @_;

    my $home = $ENV{MT_HOME};

    my @cmd = (
        $^X,
        '-I',
        File::Spec->catdir( $test_env->root, 'lib' ),
        '-I',
        File::Spec->catdir( $home, 't/lib' ),
        File::Spec->catfile( $home, 'tools/run-periodic-tasks' ),
    );
    while ( my ( $key, $value ) = splice @opts, 0, 2 ) {
        push @cmd, "--$key", $value;
    }

    run3 \@cmd, \my $stdin, \my $stdout, \my $stderr;

    # Since ODBC driver seems to be fork-unsafe, dbh must be destroyed after forking process so that MT::Object will establish new one.
    MT::Blog->driver->dbh(undef) if MT->config->ODBCDriver;

    return wantarray ? ( $stdout, $stderr ) : $stdout;
}

sub add_job {
    my ( $worker_name, %args ) = @_;
    $args{funcname} = 'MT::Worker::' . $worker_name;
    $args{uniqkey} ||= MT::Util::UniqueID::create_uuid();
    my $job = TheSchwartz::Job->new(%args);
    MT::TheSchwartz->insert($job);
}

sub clear_jobs {
    MT::Object->driver->rw_handle->{AutoInactiveDestroy} = 1;
    delete MT::Object->driver->rw_handle->{CachedKids};  ## clear cached sths
    MT::TheSchwartz::Job->remove;
    MT::Session->remove( { kind => 'PT' } );
}

subtest 'workers' => sub {
    clear_jobs();
    add_job('Test1');
    add_job('Test2');

    my ( $stdout, $stderr ) = run( workers => 'Test1' );

    ok $stderr =~ /Working on MT::Worker::Test1/, "Test1 is done";
    ok $stderr !~ /Working on MT::Worker::Test2/, "Test2 is not done yet";

    ( $stdout, $stderr ) = run( workers => 'Test1' );

    ok $stderr !~ /Working on MT::Worker::Test1/,
        "Test1 is not done (no job)";
    ok $stderr !~ /Working on MT::Worker::Test2/, "Test2 is not done yet";

    add_job('Test1');

    ( $stdout, $stderr ) = run( workers => 'Test1' );

    ok $stderr =~ /Working on MT::Worker::Test1/, "Test1 is done (again)";
    ok $stderr !~ /Working on MT::Worker::Test2/, "Test2 is not done yet";

    ( $stdout, $stderr ) = run( workers => 'Test1,Test2' );

    ok $stderr !~ /Working on MT::Worker::Test1/,
        "Test1 is not done (no job)";
    ok $stderr =~ /Working on MT::Worker::Test2/, "Test2 is done";
};

subtest 'ignore' => sub {
    clear_jobs();
    add_job('Test1');
    add_job('Test2');

    my ( $stdout, $stderr ) = run( ignore => 'Test1' );

    ok $stderr !~ /Working on MT::Worker::Test1/, "Test1 is not done yet";
    ok $stderr =~ /Working on MT::Worker::Test2/, "Test2 is done";

    ( $stdout, $stderr ) = run( ignore => 'Test1' );

    ok $stderr !~ /Working on MT::Worker::Test1/, "Test1 is not done yet";
    ok $stderr !~ /Working on MT::Worker::Test2/,
        "Test2 is not done (no job)";

    add_job('Test2');

    ( $stdout, $stderr ) = run( ignore => 'Test1' );

    ok $stderr !~ /Working on MT::Worker::Test1/, "Test1 is not done yet";
    ok $stderr =~ /Working on MT::Worker::Test2/, "Test2 is done (again)";

    add_job('Test2');

    ( $stdout, $stderr ) = run( ignore => 'Test1,Test2' );

    ok $stderr !~ /Working on MT::Worker::Test1/, "Test1 is not done";
    ok $stderr !~ /Working on MT::Worker::Test2/, "Test2 is not done";
};

subtest 'process_cap (cap 1)' => sub {
SKIP: {
        skip "requires Parallel::ForkManager", 1
            unless eval { require Parallel::ForkManager; 1; };
        skip "requires Proc::ProcessTable", 1
            unless eval { require Proc::ProcessTable; 1; };

        clear_jobs();

        add_job('Test1');
        add_job('Test2');

        MT::Object->driver->rw_handle->{AutoInactiveDestroy} = 1;

        my @stderrs;
        my $pm = Parallel::ForkManager->new(2);
        $pm->run_on_finish(
            sub {
                my ( $pid, $exit, $ident, $signal, $dump, $data ) = @_;
                push @stderrs, $$data if $data && ref $data eq 'SCALAR';
            }
        );
        for ( 1 .. 2 ) {
            sleep 1;
            my $pid = $pm->start and next;
            my ( $stdout, $stderr )
                = run( process_cap => 0, workers => "Test$_" );
            note "OUT$_ ($$): $stdout";
            note "ERR$_ ($$): $stderr";
            $stderr .= " [Test$_] ($$)";
            $pm->finish( 0, \$stderr );
        }
        $pm->wait_all_children;
        my @cancelled = grep /cancelling RPT launch/, @stderrs;
        is @cancelled => 1, "only one RPT is cancelled";
        my @worked = grep /Working on MT::Worker::/, @stderrs;
        is @worked => 1, "only one worker worked on something";
    }
};

subtest 'process_cap (cap 2)' => sub {
SKIP: {
        skip "requires Parallel::ForkManager", 1
            unless eval { require Parallel::ForkManager; 1; };
        skip "requires Proc::ProcessTable", 1
            unless eval { require Proc::ProcessTable; 1; };

        clear_jobs();

        add_job('Test1');
        add_job('Test2');

        MT::Object->driver->rw_handle->{AutoInactiveDestroy} = 1;

        my @stderrs;
        my $pm = Parallel::ForkManager->new(2);
        $pm->run_on_finish(
            sub {
                my ( $pid, $exit, $ident, $signal, $dump, $data ) = @_;
                push @stderrs, $$data if $data && ref $data eq 'SCALAR';
            }
        );
        for ( 1 .. 2 ) {
            sleep 1;
            my $pid = $pm->start and next;
            my ( $stdout, $stderr )
                = run( process_cap => 2, workers => "Test$_" );
            note "OUT$_ ($$): $stdout";
            note "ERR$_ ($$): $stderr";
            $stderr .= " [Test$_] ($$)";
            $pm->finish( 0, \$stderr );
        }
        $pm->wait_all_children;
        my @cancelled = grep /cancelling RPT launch/, @stderrs;
        is @cancelled => 0, "no RPT is cancelled";
        my @worked = grep /Working on MT::Worker::/, @stderrs;
        is @worked => 2, "both workers worked on something";
    }
};

subtest 'floor' => sub {
    clear_jobs();
    add_job( 'Test1', priority => 10 );
    add_job( 'Test2', priority => 99 );

    my ( $stdout, $stderr ) = run( floor => 15 );

    ok $stderr !~ /Working on MT::Worker::Test1/, "Test1 is not done yet";
    ok $stderr =~ /Working on MT::Worker::Test2/, "Test2 is done";

    ( $stdout, $stderr ) = run( floor => 15 );

    ok $stderr !~ /Working on MT::Worker::Test1/, "Test1 is not done yet";
    ok $stderr !~ /Working on MT::Worker::Test2/,
        "Test2 is not done (no job)";

    add_job( 'Test2', priority => 99 );

    ( $stdout, $stderr ) = run( floor => 15 );

    ok $stderr !~ /Working on MT::Worker::Test1/, "Test1 is not done yet";
    ok $stderr =~ /Working on MT::Worker::Test2/, "Test2 is done (again)";

    ( $stdout, $stderr ) = run( floor => 5 );

    ok $stderr =~ /Working on MT::Worker::Test1/, "Test1 is done";
    ok $stderr !~ /Working on MT::Worker::Test2/,
        "Test2 is not done (no job)";
};

done_testing;
