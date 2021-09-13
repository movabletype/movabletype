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
use MT::Test::App;
use MT::App::Wizard;

subtest 'MT::App::Wizard behavior when mt-config.cgi exists' => sub {
    my $app = MT::Test::App->new('MT::App::Wizard');
    my $res = $app->get_ok({
        __mode => 'retry',
        step   => 'configure',
    });

    my $title = $app->page_title;
    is($title => "Configuration File Exists", 'Title is "Configuration File Exists"');
    isnt($title => "Database Configuration", 'Title is not "Database Configuration"');
};

done_testing;
