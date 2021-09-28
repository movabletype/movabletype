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
use File::Copy qw/cp/;

subtest 'MT::App::Wizard behavior when mt-config.cgi exists' => sub {
    my $app = MT::Test::App->new(app_class => 'MT::App::Wizard', no_redirect => 1);
    my $home_cfg = File::Spec->catfile($ENV{MT_HOME}, 'mt-config.cgi');
    my $remove;
    if (!-e $home_cfg) {
        cp($test_env->config_file => $home_cfg) or die $!;
        $remove = 1;
    }

    my $res = $app->get_ok({
        __mode => 'retry',
        step   => 'configure',
    });

    my $cfg = File::Spec->catfile($app->_app->{mt_dir}, 'mt-config.cgi');
    ok -f $cfg, "mt-config.cgi exists: $cfg";
    if ($ENV{MT_TEST_RUN_APP_AS_CGI}) {
        like $app->last_location => qr/mt-upgrade\.cgi/, "redirected to mt-upgrade";
        is $app->last_location->query_param('__mode') => 'install', "and the mode is install";
    } else {
        my $title = $app->page_title;
        is($title => "Configuration File Exists", 'Title is "Configuration File Exists"');
        isnt($title => "Database Configuration", 'Title is not "Database Configuration"');
    }

    if ($remove && -e $home_cfg) {
        unlink $home_cfg
    }
};

done_testing;
