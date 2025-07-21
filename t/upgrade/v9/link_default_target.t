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
use MT::Test::Permission;
use MT::Test::Upgrade;

$test_env->prepare_fixture('db');

# create test data
my $website = MT::Test::Permission->make_website(
    link_default_target => '',
);
my $blog = MT::Test::Permission->make_blog(
    link_default_target => '',
);

subtest 'Initialize link_default_target' => sub {
    MT::Test::Upgrade->upgrade(from => 9.0000);

    $website->refresh;
    $blog->refresh;

    is $website->link_default_target, $MT::Blog::DEFAULT_LINK_DEFAULT_TARGET;
    is $blog->link_default_target, $MT::Blog::DEFAULT_LINK_DEFAULT_TARGET;
};

done_testing;
