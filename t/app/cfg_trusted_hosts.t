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

use MT::Test::App;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

my $test_app = MT::Test::App->new('MT::App::CMS');
my $app      = $test_app->_app;

is $app->config->TrustedHosts, 0;

$app->config->ReturnToURL('https://example.com');
MT->request('default_trusted_hosts', undef);
is_deeply [sort $app->config->TrustedHosts], ['example.com'];

my $parent_site = MT::Test::Permission->make_website();
$parent_site->site_url('https://sub.example.com');
$parent_site->save or die $parent_site->errstr;
MT->request('default_trusted_hosts', undef);
is_deeply [sort $app->config->TrustedHosts], ['example.com', 'sub.example.com'];

done_testing;
