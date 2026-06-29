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

$test_env->prepare_fixture('db_data');

my $site   = MT::Test::Permission->make_website(name => 'my website');
my $author = MT->model('author')->load(1);

$author->set_password('Nelson');
$author->save;

subtest "to dashboard and general setting" => sub {
    my $app1 = MT::Test::App->new;
    $app1->get_ok();
    like $app1->header_title, qr/^Sign in/, 'is a sign in screen';
    $app1->sign_in_ok({ username => 'Melody', password => 'Nelson' });
    like $app1->header_title, qr/^Dashboard/, 'right destination';
    $app1->get_ok({ __mode => 'cfg_prefs', blog_id => $site->id });
    like $app1->header_title, qr/^General Settings/, 'right destination';
};

subtest "to general setting and post it" => sub {
    my $app1 = MT::Test::App->new;
    $app1->get_ok({ __mode => 'cfg_prefs', blog_id => $site->id });
    like $app1->header_title, qr/^Sign in/, 'is a sign in screen';
    $app1->sign_in_ok({ username => 'Melody', password => 'Nelson' });
    like $app1->header_title, qr/^General Settings/, 'right destination';

    subtest "post the form" => sub {
        plan skip_all => 'Skip for Cloud.pack' if MT->instance->component('cloud');
        my $res = $app1->post_form_ok({ name => 'my website RENAMED1' });
        like $app1->header_title, qr/^General Settings/, 'right destination';
        my $site_reloaded = MT->model('blog')->load($site->id);
        is $site_reloaded->name, 'my website RENAMED1', 'blog name is renamed';
    };
};

subtest "to self profile and post it" => sub {
    my $app1 = MT::Test::App->new;
    $app1->get_ok({ __mode => 'view', _type => 'author', id => $author->id });
    like $app1->header_title, qr/^Sign in/, 'is a sign in screen';
    $app1->sign_in_ok({ username => 'Melody', password => 'Nelson' });
    like $app1->header_title, qr/^Edit Profile/, 'right destination';
    my $res = $app1->post_form_ok({ nickname => 'Melody RENAMED1' });
    like $app1->header_title, qr/^Edit Profile/, 'right destination';
    my $author_reloaded = MT->model('author')->load($author->id);
    is $author_reloaded->nickname, 'Melody RENAMED1', 'author nickname is renamed';
};

subtest "multiple browser tabs" => sub {
    my $app1 = MT::Test::App->new;
    $app1->get_ok({ __mode => 'cfg_prefs', blog_id => $site->id });
    like $app1->header_title, qr/^Sign in/, 'is a sign in screen';
    $app1->sign_in_ok({ username => 'Melody', password => 'Nelson' });
    like $app1->header_title, qr/^General Settings/, 'right destination';

    subtest "new brower tab" => sub {
        my $app2 = MT::Test::App->new;
        $app2->{session} = $app1->{session};    # browser tabs share the session
        $app2->get_ok({ __mode => 'cfg_prefs', blog_id => $site->id });
        like $app2->header_title, qr/^Sign in/, 'is a sign in screen';
        $app2->sign_in_ok({ username => 'Melody', password => 'Nelson' });
        like $app2->header_title, qr/^General Settings/, 'right destination';
    };

    subtest "original brower tab" => sub {
        plan skip_all => 'Skip for Cloud.pack' if MT->instance->component('cloud');
        $app1->post_form_ok({ name => 'my website RENAMED2' });
        like $app1->header_title, qr/^General Settings/, 'right destination';
        my $site_reloaded = MT->model('blog')->load($site->id);
        is $site_reloaded->name, 'my website RENAMED2', 'blog name is renamed';
    };
};

subtest "other random modes" => sub {

    my @cases = (
        ['__mode=search_replace&blog_id=0',           qr/^Search & Replace /],
        ['__mode=search_replace&blog_id=1',           qr/^Search & Replace /],
        ['__mode=list&blog_id=0&_type=log',           qr/^Activity Log /],
        ['__mode=list&blog_id=1&_type=log',           qr/^Activity Log /],
        ['__mode=cfg_plugins&blog_id=0',              qr/^Plugin Settings /],
        ['__mode=cfg_plugins&blog_id=1',              qr/^Plugin Settings /],
        ['__mode=list_template&blog_id=0',            qr/^Manage Templates /],
        ['__mode=list_template&blog_id=1',            qr/^Manage Templates /],
        ['__mode=view&_type=template&id=1&blog_id=0', qr/ Edit Template /],
        ['__mode=list_theme&blog_id=0',               qr/^All Themes /],
        ['__mode=list_theme&blog_id=1',               qr/^All Themes /],
        ['__mode=list&blog_id=1&_type=content_type',  qr/^Manage Content Type /],
        ['__mode=list&blog_id=0&_type=asset',         qr/^Manage Assets /],
        ['__mode=list&blog_id=1&_type=asset',         qr/^Manage Assets /],
        ['__mode=view&_type=asset&id=1&blog_id=1',    qr/^Edit Asset /],
    );
    for my $case (@cases) {
        my $app1   = MT::Test::App->new;
        my $params = CGI->new($case->[0])->Vars;
        subtest 'params: ' . $case->[0] => sub {
            $app1->get_ok($params);
            like $app1->header_title, qr/^Sign in/, 'is a sign in screen';
            $app1->sign_in_ok({ username => 'Melody', password => 'Nelson' });
            like $app1->header_title, $case->[1], 'right destination';
        }
    }
};

done_testing;
