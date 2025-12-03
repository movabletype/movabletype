use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;

BEGIN {
    eval 'use Imager; 1'              ## no critic
        or plan skip_all => 'Imager is not installed';
    plan skip_all => 'Not for Windows now' if $^O eq 'MSWin32';
}

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(

        # to serve actual js libraries
        StaticFilePath => "MT_HOME/mt-static/",

        # ImageMagick 6.90 hangs when it tries to scale
        # the same image again (after the initialization).
        # Version 7.07 works fine. Other three drivers do, too.
        # Because Image::Magick hides its $VERSION in an
        # internal package (Image::Magick::Q16 etc), it's
        # more reliable to depend on something else.
        ImageDriver => 'Imager',

        $ENV{MT_TEST_EDIT_CONTENT_TYPE_RIOT} ? (UseRiot => 1) : (),
    );
    $ENV{MT_CONFIG} = $test_env->config_file;    ## no critic
}

use MT;
use MT::Association;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Selenium;
use MT::Website;
use Selenium::Waiter;

$test_env->prepare_fixture('db_data');

my $site = MT::Website->load or die MT::Website->errstr;

my $content_type = MT::Test::Permission->make_content_type(
    name    => 'test content type',
    blog_id => $site->id,
);
$content_type->fields([]);
$content_type->save or $content_type->die;

my $create_user = MT::Test::Permission->make_author(
    name     => 'aikawa',
    nickname => 'Ichiro Aikawa',
);

my $edit_user = MT::Test::Permission->make_author(
    name     => 'ichikawa',
    nickname => 'Jiro Ichikawa',
);
my $publish_user = MT::Test::Permission->make_author(
    name     => 'egawa',
    nickname => 'Shiro Egawa',
);
my $manage_user = MT::Test::Permission->make_author(
    name     => 'ukawa',
    nickname => 'Saburo Ukawa',
);
my $manage_content_data_user = MT::Test::Permission->make_author(
    name     => 'ogawa',
    nickname => 'Goro Ogawa',
);
my $sys_manage_content_data_user = MT::Test::Permission->make_author(
    name     => 'sagawa',
    nickname => 'Ichiro Sagawa',
);

my @all_users = (
    $create_user,
    $edit_user,
    $publish_user,
    $manage_user,
    $manage_content_data_user,
    $sys_manage_content_data_user,
);
for my $user (@all_users) {
    $user->set_password('pass');
    $user->save or die $user->errstr;
}

my $create_priv = 'create_content_data:' . $content_type->unique_id;
my $create_role = MT::Test::Permission->make_role(
    name        => $create_priv,
    permissions => "'${create_priv}'",
);

my $edit_priv = 'edit_all_content_data:' . $content_type->unique_id;
my $edit_role = MT::Test::Permission->make_role(
    name        => $edit_priv,
    permissions => "'${edit_priv}'",
);

my $publish_priv = 'publish_content_data:' . $content_type->unique_id;
my $publish_role = MT::Test::Permission->make_role(
    name        => $publish_priv,
    permissions => "'${publish_priv}','${create_priv}'",
);

my $manage_priv = 'manage_content_data:' . $content_type->unique_id;
my $manage_role = MT::Test::Permission->make_role(
    name        => $manage_priv,
    permissions => "'${manage_priv}','${create_priv}','${publish_priv}','${edit_priv}'",
);

my $manage_content_data_role = MT::Test::Permission->make_role(
    name        => 'manage_content_data',
    permissions => "'manage_content_data'",
);

MT::Association->link($create_user              => $create_role              => $site);
MT::Association->link($edit_user                => $edit_role                => $site);
MT::Association->link($publish_user             => $publish_role             => $site);
MT::Association->link($manage_user              => $manage_role              => $site);
MT::Association->link($manage_content_data_user => $manage_content_data_role => $site);

$sys_manage_content_data_user->can_manage_content_data(1);
$sys_manage_content_data_user->save or die $sys_manage_content_data_user->errstr;

my @tests = (
    { name => 'create_user',                  user => $create_user,                  has_set_draft => 0 },
    { name => 'edit_user',                    user => $edit_user,                    has_set_draft => 1 },
    { name => 'publish_user',                 user => $publish_user,                 has_set_draft => 1 },
    { name => 'manage_user',                  user => $manage_user,                  has_set_draft => 1 },
    { name => 'manage_content_data_user',     user => $manage_content_data_user,     has_set_draft => 1 },
    { name => 'sys_manage_content_data_user', user => $sys_manage_content_data_user, has_set_draft => 1 },
);
for my $test (@tests) {
    my $selenium = MT::Test::Selenium->new($test_env);
    $selenium->login($test->{user});

    $selenium->request({
        __request_method => 'GET',
        __mode           => 'list',
        _type            => 'content_data',
        blog_id          => $site->id,
        type             => 'content_data_' . $content_type->id,
    });
    $selenium->wait_until_ready;

    my $set_draft = wait_until {
        $selenium->driver->find_elements('#actions-bar-top a.dropdown-item[data-action-id=set_draft]')
    };

    my $test_name =
          $test->{has_set_draft}
        ? $test->{name} . ' has set_draft action'
        : $test->{name} . ' does not have set_draft action';
    is(
        (@{$set_draft} ? 1 : 0),
        $test->{has_set_draft},
        $test_name,
    );
}

done_testing;
