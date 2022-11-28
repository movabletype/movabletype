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

use MT::Test;
use MT;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);
ok my $site = MT::Website->load(1);
my $site_id = $site->id;

MT::Log->new(
    message => 'system log',
    class   => 'system',
    level   => MT::Log::INFO(),
    blog_id => $site_id,
)->save;

MT::Log->new(
    message => 'new entry',
    class   => 'entry',
    level   => MT::Log::INFO(),
    blog_id => $site_id,
)->save;

my @logs = MT::Log->load({ blog_id => $site_id, class => '*' });
is @logs => 2, "has two logs";

$site->remove;

my @new_logs = MT::Log->load({ blog_id => $site_id, class => '*' });
ok !@new_logs, "has no logs";

done_testing;
