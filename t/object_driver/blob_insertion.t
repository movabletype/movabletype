use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT;
use MT::TheSchwartz::Job;
use Digest::SHA qw(sha1);

$test_env->prepare_fixture('db');

my $binary = sha1('binary');

subtest 'save' => sub {
    MT::TheSchwartz::Job->remove;

    my $key = "uniq" . time;
    my $new_job = MT::TheSchwartz::Job->new;
    $new_job->funcid(999);
    $new_job->arg($binary);
    $new_job->uniqkey($key);
    $new_job->insert_time(time);
    $new_job->run_after(time);
    $new_job->grabbed_until(time);
    $new_job->priority(5);
    ok $new_job->save or die $new_job->errstr;

    $test_env->clear_mt_cache;

    ok my $job = MT::TheSchwartz::Job->load({uniqkey => $key});
    ok $job->arg eq $binary, "same binary";
};

subtest 'bulk_insert' => sub {
    MT::TheSchwartz::Job->remove;

    my $key = "bulk" . time;
    MT::TheSchwartz::Job->bulk_insert(
        [qw(jobid funcid arg uniqkey run_after grabbed_until)],
        [[1, 999, $binary, $key, time, time]],
    ) or die MT::TheSchwartz::Job->errstr;

    ok my $job = MT::TheSchwartz::Job->load({uniqkey => $key});
    ok $job->arg eq $binary, "same binary";
};

done_testing;
