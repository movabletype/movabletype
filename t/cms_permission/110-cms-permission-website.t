#!/usr/bin/perl

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
        parent_id => $second_website->id,
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

    my $kagawa = MT::Test::Permission->make_author(
        name     => 'kagawa',
        nickname => 'Ichiro Kagawa',
    );
    my $kikkawa = MT::Test::Permission->make_author(
        name     => 'kikkawa',
        nickname => 'Jiro Kikkawa',
    );
    my $kumekawa = MT::Test::Permission->make_author(
        name     => 'kumekawa',
        nickname => 'Saburo Kumekawa',
    );
    my $kemikawa = MT::Test::Permission->make_author(
        name     => 'kemikawa',
        nickname => 'Shiro Kemikawa',
    );
    my $koishikawa = MT::Test::Permission->make_author(
        name     => 'koishikawa',
        nickname => 'Goro Koishikawa',
    );
    my $sagawa = MT::Test::Permission->make_author(
        name     => 'sagawa',
        nickname => 'Ichiro Sagawa',
    );
    my $shiki = MT::Test::Permission->make_author(
        name     => 'shiki',
        nickname => 'Jiro Shiki',
    );
    my $suda = MT::Test::Permission->make_author(
        name     => 'suda',
        nickname => 'Saburo Suda',
    );
    my $seta = MT::Test::Permission->make_author(
        name     => 'seta',
        nickname => 'Shiro Seta',
    );
    my $sorimachi = MT::Test::Permission->make_author(
        name     => 'sorimachi',
        nickname => 'Goro Sorimachi',
    );
    my $tada = MT::Test::Permission->make_author(
        name     => 'tada',
        nickname => 'Ichiro Tada',
    );

    my $admin = MT::Author->load(1);

    # Role
    my $edit_config = MT::Test::Permission->make_role(
        name        => 'Edit Config',
        permissions => "'edit_config'",
    );
    my $edit_templates = MT::Test::Permission->make_role(
        name        => 'Edit Templates',
        permissions => "'edit_templates'",
    );
    my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });
    my $designer   = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa => $site_admin => $website);
    MT::Association->link($shiki, $designer, $website);
    MT::Association->link($ichikawa => $designer    => $blog);
    MT::Association->link($egawa    => $site_admin  => $second_website);
    MT::Association->link($ogawa    => $edit_config => $website);
    MT::Association->link($kagawa   => $edit_config => $second_website);
    MT::Association->link($koishikawa, $edit_config, $blog);
    MT::Association->link($sagawa,     $edit_config, $second_blog);
    MT::Association->link($suda,       $site_admin,  $blog);
    MT::Association->link($seta,       $site_admin,  $website);
    MT::Association->link($tada,       $site_admin,  $website);

    foreach my $w (MT::Website->load()) {
        MT::Association->link($sorimachi, $site_admin, $w);
    }

    MT::Association->link($kikkawa  => $edit_templates => $website);
    MT::Association->link($kumekawa => $edit_templates => $second_website);

    $ukawa->can_create_site(1);
    $ukawa->save();

    $kemikawa->can_edit_templates(1);
    $kemikawa->save();

    $suda->can_edit_templates(1);
    $suda->save();

    $seta->can_edit_templates(1);
    $seta->save();

    $sorimachi->can_edit_templates(1);
    $sorimachi->save();
});

my $website = MT::Website->load({ name => 'my website' });

my $blog = MT::Blog->load({ name => 'my blog' });

my $aikawa     = MT::Author->load({ name => 'aikawa' });
my $ichikawa   = MT::Author->load({ name => 'ichikawa' });
my $ukawa      = MT::Author->load({ name => 'ukawa' });
my $egawa      = MT::Author->load({ name => 'egawa' });
my $ogawa      = MT::Author->load({ name => 'ogawa' });
my $kagawa     = MT::Author->load({ name => 'kagawa' });
my $kikkawa    = MT::Author->load({ name => 'kikkawa' });
my $kumekawa   = MT::Author->load({ name => 'kumekawa' });
my $kemikawa   = MT::Author->load({ name => 'kemikawa' });
my $koishikawa = MT::Author->load({ name => 'koishikawa' });
my $sagawa     = MT::Author->load({ name => 'sagawa' });
my $shiki      = MT::Author->load({ name => 'shiki' });
my $suda       = MT::Author->load({ name => 'suda' });
my $seta       = MT::Author->load({ name => 'seta' });
my $sorimachi  = MT::Author->load({ name => 'sorimachi' });
my $tada       = MT::Author->load({ name => 'tada' });

my $admin = MT::Author->load(1);

my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });

subtest 'mode = cfg_prefs' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'cfg_prefs',
        blog_id => $website->id,
    });
    $app->has_no_permission_error("cfg_prefs by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'cfg_prefs',
        blog_id => $website->id,
    });
    $app->has_no_permission_error("cfg_prefs by permitted user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'cfg_prefs',
        blog_id => $website->id,
    });
    $app->has_permission_error("cfg_prefs by other website");

    $app->login($koishikawa);
    $app->post_ok({
        __mode  => 'cfg_prefs',
        blog_id => $website->id,
    });
    $app->has_permission_error("cfg_prefs by child blog");

    $app->login($sagawa);
    $app->post_ok({
        __mode  => 'cfg_prefs',
        blog_id => $website->id,
    });
    $app->has_permission_error("cfg_prefs by other blog");

    $app->login($shiki);
    $app->post_ok({
        __mode  => 'cfg_prefs',
        blog_id => $website->id,
    });
    $app->has_permission_error("cfg_prefs by other permission");
};

subtest 'mode = list' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        blog_id => 0,
        _type   => 'website',
    });
    $app->has_no_permission_error("list by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => 0,
        _type   => 'website',
    });
    $app->has_no_permission_error("list by permitted user");

    $app->login($kemikawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'website',
        blog_id => 0,
    });
    $app->has_no_permission_error("list by permitted user (system)");
    my $button = quotemeta '<a href="#delete" class="button">Delete</a>';
    $app->content_unlike(qr/$button/, 'There is not "Delete" button.');

    $app->login($suda);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'website',
        blog_id => 0,
    });
    $app->has_no_permission_error("list by permitted user (system) with blog administrator permission");
    $app->content_unlike(qr/$button/, 'There is not "Delete" button.');

    $app->login($seta);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'website',
        blog_id => 0,
    });
    $app->has_no_permission_error("list by permitted user (system) with website administrator permission");
    $app->content_unlike(qr/$button/, 'There is not "Delete" button.');

    $app->login($tada);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'website',
        blog_id => 0,
    });
    $app->has_no_permission_error("list by permitted user with an empry system permission record.");
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        $app->content_like(qr/$button/, 'There is "Delete" button.');
    }
    my $refresh_tmpl = quotemeta '<option value="refresh_website_templates">Refresh Template(s)</option>';
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        $app->content_like(
            qr/$refresh_tmpl/,
            'There is "Refresh Template(s)" action.'
        );
    }

    $app->login($sorimachi);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'website',
        blog_id => 0,
    });
    $app->has_no_permission_error("list by permitted user (system) with all website administrator permission");
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        $app->content_like(qr/$button/, 'There is "Delete" button.');
    }

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'website',
        blog_id => 0,
    });
    $app->has_no_permission_error("list by child blog");
};

subtest 'mode = save (new)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode        => 'save',
        _type         => 'website',
        name          => 'websiteName',
        website_theme => 'classic_test_website',
        site_url      => 'http://localhost',
    });
    $app->has_no_permission_error("save (new) by admin");

    $app->login($ukawa);
    $app->post_ok({
        __mode        => 'save',
        _type         => 'website',
        name          => 'WebsiteName',
        website_theme => 'classic_test_website',
        site_url      => 'http://localhost',
    });
    $app->has_no_permission_error("save (new) by permitted user");

    $app->login($aikawa);
    $app->post_ok({
        __mode        => 'save',
        _type         => 'website',
        name          => 'WebsiteName',
        website_theme => 'classic_test_website',
        site_url      => 'http://localhost',
    });
    $app->has_permission_error("save (new) by blog admin");
};

subtest 'mode = save (edit)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'website',
        name    => 'BlogName',
        id      => $website->id,
        blog_id => $website->id,
    });
    $app->has_no_permission_error("save (edit) by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'website',
        name    => 'BlogName',
        id      => $website->id,
        blog_id => $website->id,
    });
    $app->has_no_permission_error("save (edit) by permitted user (website admin)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'website',
        name    => 'BlogName',
        id      => $website->id,
        blog_id => $website->id,
    });
    $app->has_no_permission_error("save (edit) by permitted user (edit config)");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'website',
        name    => 'BlogName',
        id      => $website->id,
        blog_id => $website->id,
    });
    $app->has_permission_error("save (edit) by non permitted user (create website)");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'website',
        name    => 'BlogName',
        id      => $website->id,
        blog_id => $website->id,
    });
    $app->has_permission_error("save (edit) by other blog (website admin)");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'website',
        name    => 'BlogName',
        id      => $website->id,
        blog_id => $website->id,
    });
    $app->has_permission_error("save (edit) by other blog (edit config)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'website',
        name    => 'BlogName',
        id      => $website->id,
        blog_id => $website->id,
    });
    $app->has_permission_error("save (edit) by other permission");
};

subtest 'mode = edit (new)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'website',
        blog_id => 0,
    });
    $app->has_no_permission_error("edit (new) by admin");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'website',
        blog_id => 0,
    });
    $app->has_no_permission_error("edit (new) by permitted user");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'website',
        blog_id => 0,
    });
    $app->has_permission_error("edit (new) by blog admin");
};

subtest 'mode = edit (edit)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'website',
        name    => 'BlogName',
        id      => $website->id,
        blog_id => $website->id,
    });
    $app->has_no_permission_error("edit (edit) by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'website',
        name    => 'BlogName',
        id      => $website->id,
        blog_id => $website->id,
    });
    $app->has_no_permission_error("edit (edit) by permitted user (website admin)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'website',
        name    => 'BlogName',
        id      => $website->id,
        blog_id => $website->id,
    });
    $app->has_no_permission_error("edit (edit) by permitted user (edit config)");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'website',
        name    => 'BlogName',
        id      => $website->id,
        blog_id => $website->id,
    });
    $app->has_permission_error("edit (edit) by non permitted user (create website)");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'website',
        name    => 'BlogName',
        id      => $website->id,
        blog_id => $website->id,
    });
    $app->has_permission_error("edit (edit) by other blog (website admin)");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'website',
        name    => 'BlogName',
        id      => $website->id,
        blog_id => $website->id,
    });
    $app->has_permission_error("edit (edit) by other blog (edit config)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'website',
        name    => 'BlogName',
        id      => $website->id,
        blog_id => $website->id,
    });
    $app->has_permission_error("edit (edit) by other permission");
};

subtest 'action = refresh_website_templates' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'website',
        action_name            => 'refresh_website_templates',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_website%26blog_id%3D' . $website->id,
        id                     => $website->id,
        plugin_action_selector => 'refresh_website_templates',
    });
    $app->has_no_permission_error("XXX");
    ok(!$app->last_location->query_param('error_id'), "refresh_website_templates by admin");

    $app->login($kikkawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'website',
        action_name            => 'refresh_website_templates',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_website%26blog_id%3D' . $website->id,
        id                     => $website->id,
        plugin_action_selector => 'refresh_website_templates',
    });
    $app->has_no_permission_error("XXX");
    ok(
        !$app->last_location->query_param('error_id'),
        "refresh_website_templates by permitted user"
    );

    $app->login($kemikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'website',
        action_name            => 'refresh_website_templates',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_website%26blog_id%3D' . $website->id,
        id                     => $website->id,
        plugin_action_selector => 'refresh_website_templates',
    });
    $app->has_no_permission_error("XXX");
    ok(
        !$app->last_location->query_param('error_id'),
        "refresh_website_templates by permitted user (system)"
    );

    $app->login($kumekawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'website',
        action_name            => 'refresh_website_templates',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_website%26blog_id%3D' . $website->id,
        id                     => $website->id,
        plugin_action_selector => 'refresh_website_templates',
    });
    $app->has_no_permission_error("XXX");
    ok($app->last_location->query_param('error_id'), "refresh_website_templates by other blog");

    $app->login($ogawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'website',
        action_name            => 'refresh_website_templates',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_website%26blog_id%3D' . $website->id,
        id                     => $website->id,
        plugin_action_selector => 'refresh_website_templates',
    });
    $app->has_permission_error("refresh_website_templates by other permission");
};

subtest 'mode = delete' => sub {
    $website = MT::Test::Permission->make_website();
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'website',
        id     => $website->id,
    });
    $app->has_no_permission_error("delete by admin");

    $website = MT::Test::Permission->make_website();
    MT::Association->link($aikawa => $site_admin => $website);
    $app->login($aikawa);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'website',
        id     => $website->id,
    });
    $app->has_no_permission_error("delete by permitted user (website admin)");

    $website = MT::Test::Permission->make_website();
    $app->login($ukawa);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'website',
        id     => $website->id,
    });
    $app->has_permission_error("delete by non permitted user (create website)");

    $website = MT::Test::Permission->make_website();
    $app->login($egawa);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'website',
        id     => $website->id,
    });
    $app->has_permission_error("delete by other blog (website admin)");

    $website = MT::Test::Permission->make_website();
    $app->login($ichikawa);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'website',
        id     => $website->id,
    });
    $app->has_permission_error("delete by other permission");
};

done_testing();
