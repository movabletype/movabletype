use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Upgrade;

$test_env->prepare_fixture('db');

subtest 'Keep created_on of the website' => sub {
    my $website = MT::Test::Permission->make_website(name => 'my website');
    $website->allow_data_api(undef); # Force to initial state
    $website->created_on('2000-01-01 00:00:00');
    $website->save;

    MT::Test::Upgrade->upgrade(from => 7.0052);

    $website = MT->model('website')->load($website->id);
    is $website->created_on => '20000101000000', "created_on is kept";
};

done_testing;
