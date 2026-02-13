#!/usr/bin/perl

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

use lib 'plugins/MultiBlog/lib';
use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website(
        name => 'my website',
    );
    my $second_website = MT::Test::Permission->make_website(
        name => 'second website',
    );

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'my blog',
    );
    my $second_blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name      => 'second blog',
    );

    # Author
    my $aikawa = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );

    my $ichikawa = MT::Test::Permission->make_author(
        name     => 'ichikawa',
        nickname => 'Jiro Ichikawa',
    );

    my $ukawa = MT::Test::Permission->make_author(
        name     => 'ukawa',
        nickname => 'Saburo Ukawa',
    );

    my $egawa = MT::Test::Permission->make_author(
        name     => 'egawa',
        nickname => 'Shiro Egawa',
    );

    my $ogawa = MT::Test::Permission->make_author(
        name     => 'ogawa',
        nickname => 'Goro Ogawa',
    );

    my $admin = MT::Author->load(1);

    # Role
    my $create_post = MT::Test::Permission->make_role(
        name        => 'Create Post',
        permissions => "'create_post'",
    );
    my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });

    require MT::Association;
    MT::Association->link($aikawa   => $site_admin  => $blog);
    MT::Association->link($ichikawa => $site_admin  => $website);
    MT::Association->link($ukawa    => $site_admin  => $second_blog);
    MT::Association->link($egawa    => $site_admin  => $second_website);
    MT::Association->link($ogawa    => $create_post => $blog);
});

my $website = MT::Website->load({ name => 'my website' });

my $blog = MT::Blog->load({ name => 'my blog' });

my $aikawa   = MT::Author->load({ name => 'aikawa' });
my $ichikawa = MT::Author->load({ name => 'ichikawa' });
my $ukawa    = MT::Author->load({ name => 'ukawa' });
my $egawa    = MT::Author->load({ name => 'egawa' });
my $ogawa    = MT::Author->load({ name => 'ogawa' });

my $admin = MT::Author->load(1);

my $app = MT::Test::App->new('MT::App::CMS');

subtest 'mode = save' => sub {

    my $save_message_regex = qr/Rebuild Trigger settings have been saved/;

    $app->login($admin);
    $app->post_ok({
        __mode      => 'save',
        _type       => 'rebuild_trigger',
        blog_id     => $blog->id,
        return_args => '__mode=cfg_rebuild_trigger&blog_id=' . $blog->id,
    });
    like $app->message_text, $save_message_regex, 'right message by admin';
    is $app->last_location->query_param('__mode') => 'cfg_rebuild_trigger', 'redirected to dashboard';

    $app->login($aikawa);
    $app->post_ok({
        __mode      => 'save',
        _type       => 'rebuild_trigger',
        blog_id     => $blog->id,
        return_args => '__mode=cfg_rebuild_trigger&blog_id=' . $blog->id,
    });
    like $app->message_text, $save_message_regex, 'right message by permitted user (child site)';
    is $app->last_location->query_param('__mode') => 'cfg_rebuild_trigger', 'redirected to dashboard';

    $app->login($ichikawa);
    $app->post_ok({
        __mode      => 'save',
        _type       => 'rebuild_trigger',
        blog_id     => $website->id,
        return_args => '__mode=cfg_rebuild_trigger&blog_id=' . $website->id,
    });
    like $app->message_text, $save_message_regex, 'right message by permitted user (parent site)';
    is $app->last_location->query_param('__mode') => 'cfg_rebuild_trigger', 'redirected to dashboard';

    $app->login($ukawa);
    $app->post_ok({
        __mode      => 'save',
        _type       => 'rebuild_trigger',
        blog_id     => $blog->id,
        return_args => '__mode=cfg_rebuild_trigger&blog_id=' . $blog->id,
    });
    $app->has_permission_error('right message by non permitted user (child site)');
    ok !$app->last_location, 'not to redirected to dashboard';

    $app->login($egawa);
    $app->post_ok({
        __mode      => 'save',
        _type       => 'rebuild_trigger',
        blog_id     => $website->id,
        return_args => '__mode=cfg_rebuild_trigger&blog_id=' . $website->id,
    });
    $app->has_permission_error('right message by non permitted user (parent site)');
    ok !$app->last_location, 'not to redirected to dashboard';

    $app->login($ogawa);
    $app->post_ok({
        __mode      => 'save',
        _type       => 'rebuild_trigger',
        blog_id     => $blog->id,
        return_args => '__mode=cfg_rebuild_trigger&blog_id=' . $blog->id,
    });
    $app->has_permission_error('right message by other permission user');
    is $app->last_location->query_param('__mode') => 'dashboard', 'redirected to dashboard';
};

subtest 'mode = add_rebuild_trigger' => sub {
    $app->login($admin);
    $app->get_ok({
        __mode  => 'add_rebuild_trigger',
        blog_id => $blog->id,
        dialog  => 1,
    });
    is $app->_find_text('.modal-title'), 'Create Rebuild Trigger', 'right title';
    is $app->locations, undef, 'no redirection';

    $app->login($aikawa);
    $app->get_ok({
        __mode  => 'add_rebuild_trigger',
        blog_id => $blog->id,
        dialog  => 1,
    });
    is $app->_find_text('.modal-title'), 'Create Rebuild Trigger', 'right title by permitted user (child site)';
    is $app->locations, undef, 'no redirection';

    $app->login($ichikawa);
    $app->get_ok({
        __mode  => 'add_rebuild_trigger',
        blog_id => $website->id,
        dialog  => 1,
    });
    is $app->_find_text('.modal-title'), 'Create Rebuild Trigger', 'right title by permitted user (parent site)';
    is $app->locations, undef, 'no redirection';

    $app->login($ukawa);
    $app->get_ok({
        __mode  => 'add_rebuild_trigger',
        blog_id => $blog->id,
        dialog  => 1,
    });
    $app->has_permission_error('right message by other permission user');
    ok !$app->last_location, 'not to redirected to dashboard by non permitted user (child site)';

    $app->login($egawa);
    $app->get_ok({
        __mode  => 'add_rebuild_trigger',
        blog_id => $website->id,
        dialog  => 1,
    });
    $app->has_permission_error('right message by other permission user');
    ok !$app->last_location, 'not to redirected to dashboard by non permitted user (parent site)';

    $app->login($ogawa);
    $app->get_ok({
        __mode  => 'add_rebuild_trigger',
        blog_id => $blog->id,
        dialog  => 1,
    });
    $app->has_permission_error('right message by other permission user');
    is $app->last_location->query_param('__mode') => 'dashboard', 'redirected to dashboard by other permission';
};

done_testing();
