use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use MT::Test::SendmailMock;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test::App;
use MT::Test::Fixture;

$test_env->prepare_fixture('db');

my $blog = MT->model('blog')->load(1);

subtest "login redirect" => sub {

    subtest "to dashboard" => sub {
        my $app1 = MT::Test::App->new;
        $app1->get_ok();
        like $app1->header_title, qr/^Sign in/, 'is a sign in screen';
        $app1->post_form_ok({username => 'Melody', password => 'Nelson'});
        like $app1->header_title, qr/^Dashboard/, 'right destination';
    };

    subtest "to site general setting" => sub {
        my $app1 = MT::Test::App->new;
        $app1->get_ok({__mode => 'cfg_prefs', blog_id => $blog->id});
        like $app1->header_title, qr/^Sign in/, 'is a sign in screen';
        $app1->post_form_ok({username => 'Melody', password => 'Nelson'});
        like $app1->header_title, qr/^General Settings/, 'right destination';
    };
};

done_testing;

