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

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Selenium;
use Selenium::Waiter;

$test_env->prepare_fixture('db');

my $site         = MT->model('website')->load or die MT->model('website')->errstr;
my $content_type = MT::Test::Permission->make_content_type(
    blog_id => $site->id,
    name    => 'content_type_1',
);

my $admin = MT->model('author')->load or die MT->model('author')->errstr;
ok $admin->is_superuser, 'login user is superuser';
$admin->set_password('Nelson');
$admin->save or die $admin->errstr;

my $selenium = MT::Test::Selenium->new($test_env, { rebootable => 1 });
$selenium->login($admin);

MT->instance->reboot;    # update content type permissions

subtest 'administer_site' => sub {
    $selenium->request({
        __request_method => 'GET',
        __mode           => 'view',
        _type            => 'role',
        blog_id          => 0,
    });
    $selenium->wait_until_ready;

    my $checkboxes = wait_until {
        $selenium->driver->find_elements('input[type=checkbox]');
    };
    ok @{$checkboxes} > 0, 'there are some checkboxes';
    is scalar(grep { $_->is_selected } @{$checkboxes}), 0, 'all checkboxes are not checked';

    my ($checkbox_administer_site) = grep { $_->get_attribute('id') eq 'administer_site' } @{$checkboxes};
    ok $checkbox_administer_site, 'administe_site checkbox exists';

    my $script = q/new bootstrap.Collapse(jQuery('#role-content-type-privileges .collapse').get(0))/;
    $selenium->driver->execute_script($script);
    $checkbox_administer_site->click;
    is scalar(grep { !$_->is_selected } @{$checkboxes}), 0, 'all checkboxes are checked when administer_site is checked';
};

subtest 'create_post in inherit_from' => sub {
    $selenium->request({
        __request_method => 'GET',
        __mode           => 'view',
        _type            => 'role',
        blog_id          => 0,
    });
    $selenium->wait_until_ready;

    my $checkboxes = wait_until {
        $selenium->driver->find_elements('input[type=checkbox]');
    };
    ok @{$checkboxes} > 0, 'there are some checkboxes';
    is scalar(grep { $_->is_selected } @{$checkboxes}), 0, 'all checkboxes are not checked';

    my $checkbox_create_post;
    my $checkbox_publish_post;
    my $checkbox_send_notifications;
    for my $cb (@{$checkboxes}) {
        my $id = $cb->get_attribute('id');
        if ($id eq 'create_post') {
            $checkbox_create_post = $cb;
        } elsif ($id eq 'publish_post') {
            $checkbox_publish_post = $cb;
        } elsif ($id eq 'send_notifications') {
            $checkbox_send_notifications = $cb;
        }
    }
    ok $checkbox_create_post,        'create_post checkbox exists';
    ok $checkbox_publish_post,       'publish_post checkbox exists';
    ok $checkbox_send_notifications, 'send_notifications checkbox exists';

    $checkbox_publish_post->click;
    ok $checkbox_create_post->is_selected, 'create_post is checked when only publish_post is checked';

    $checkbox_send_notifications->click;
    ok $checkbox_create_post->is_selected, 'create_post is checked when both publish_post and send_notifications are checked';

    $checkbox_publish_post->click;
    ok $checkbox_create_post->is_selected, 'create_post is checked when only send_notifications is checked';

    $checkbox_send_notifications->click;
    ok !$checkbox_create_post->is_selected, 'create_post is not checked when both publish_post and send_notifications are not checked';
};

done_testing;
