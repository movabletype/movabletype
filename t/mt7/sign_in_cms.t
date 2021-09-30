use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);
my $user  = MT::Test::Permission->make_author;
$user->save or die $user->errstr;

subtest 'user = administrator' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode => 'dashboard',
    });

    $app->content_unlike(qr!Invalid login.!i, "Invalid login(mode=dashboard) by admin");
};

subtest 'user = not administrator' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);
    $app->get_ok({
        __mode => 'dashboard',
    });
    $app->content_unlike(qr!Invalid login.!i, "Invalid login(mode=dashboard) by user(can_sign_in_cms=1)");

    $app->get_ok({
        __mode => 'cfg_prefs',
    });
    $app->content_unlike(qr!Invalid login.!i, "Invalid login(mode=cfg_prefs) by user(can_sign_in_cms=1)");

    $user->can_sign_in_cms(0);
    $user->save or die $user->errstr;

    $app->get_ok({
        __mode => 'dashboard',
    });
    $app->content_like(qr!Invalid login.!i, "Invalid login(mode=dashboard) by user(can_sign_in_cms=0)");

    $app->get_ok({
        __mode    => 'cfg_prefs',
        __blog_id => 1,
    });
    $app->content_like(qr!Invalid login.!i, "Invalid login(mode=cfg_prefs) by user(can_sign_in_cms=0)");

};

done_testing();
