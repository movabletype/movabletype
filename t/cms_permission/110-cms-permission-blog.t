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
        parent_id => $website->id,
        name      => 'second blog',
    );
    my $third_blog = MT::Test::Permission->make_blog(
        parent_id => $second_website->id,
        name      => 'third blog',
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
        nickname => 'Goro ogawa',
    );

    my $kagawa = MT::Test::Permission->make_author(
        name     => 'kagawa',
        nickname => 'Ichiro kagawa',
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

    my $soneda = MT::Test::Permission->make_author(
        name     => 'soneda',
        nickname => 'Goro Soneda',
    );

    my $taneda = MT::Test::Permission->make_author(
        name     => 'taneda',
        nickname => 'Ichiro Taneda',
    );

    my $tsuda = MT::Test::Permission->make_author(
        name     => 'tsuda',
        nickname => 'Saburo Tsuda',
    );

    my $tezuka = MT::Test::Permission->make_author(
        name     => 'tezuka',
        nickname => 'Shiro Tezuka',
    );

    my $toda = MT::Test::Permission->make_author(
        name     => 'toda',
        nickname => 'Goro Toda',
    );

    my $namegawa = MT::Test::Permission->make_author(
        name     => 'namegawa',
        nickname => 'Ichiro Namegawa',
    );

    my $niyagawa = MT::Test::Permission->make_author(
        name     => 'niyagawa',
        nickname => 'Jiro Niyagawa',
    );

    my $nunota = MT::Test::Permission->make_author(
        name     => 'nunota',
        nickname => 'Saburo Nunota',
    );

    my $negoro = MT::Test::Permission->make_author(
        name     => 'negoro',
        nickname => 'Shiro Negoro',
    );

    my $noda = MT::Test::Permission->make_author(
        name     => 'noda',
        nickname => 'Goro Noda',
    );

    my $hada = MT::Test::Permission->make_author(
        name     => 'hada',
        nickname => 'Ichiro Hada',
    );
    my $hida = MT::Test::Permission->make_author(
        name     => 'hida',
        nickname => 'Jiro Hida',
    );

    my $admin = MT::Author->load(1);

    # Role
    require MT::Role;
    my $site_admin = MT::Role->load({ name => MT->translate('Site Administrator') });
    my $designer   = MT::Role->load({ name => MT->translate('Designer') });

    my $create_post = MT::Test::Permission->make_role(
        name        => 'Create Post',
        permissions => "'create_post'",
    );

    my $manage_pages = MT::Test::Permission->make_role(
        name        => 'Manage Pages',
        permissions => "'manage_pages'",
    );

    my $rebuild = MT::Test::Permission->make_role(
        name        => 'Rebuild',
        permissions => "'rebuild'",
    );

    my $edit_config = MT::Test::Permission->make_role(
        name        => 'Edit Config',
        permissions => "'edit_config'",
    );

    my $edit_all_posts = MT::Test::Permission->make_role(
        name        => 'Edit All Posts',
        permissions => "'edit_all_posts'",
    );

    my $publish_post = MT::Test::Permission->make_role(
        name        => 'Publish Post',
        permissions => "'publish_post'",
    );

    my $manage_feedback = MT::Test::Permission->make_role(
        name        => 'Manage Feedback',
        permissions => "'manage_feedback'",
    );
    my $edit_templates = MT::Test::Permission->make_role(
        name        => 'Edit Templates',
        permissions => "'edit_templates'",
    );

    require MT::Association;
    MT::Association->link($aikawa   => $site_admin      => $blog);
    MT::Association->link($ichikawa => $edit_templates  => $blog);
    MT::Association->link($ukawa    => $manage_pages    => $blog);
    MT::Association->link($egawa    => $rebuild         => $blog);
    MT::Association->link($ogawa    => $edit_config     => $blog);
    MT::Association->link($kagawa   => $edit_all_posts  => $blog);
    MT::Association->link($kikkawa  => $publish_post    => $blog);
    MT::Association->link($kumekawa => $manage_feedback => $blog);
    MT::Association->link($tezuka   => $edit_templates  => $blog);
    MT::Association->link($noda     => $site_admin      => $blog);
    MT::Association->link($hada     => $site_admin      => $blog);
    MT::Association->link($hida     => $site_admin      => $blog);

    MT::Association->link($kemikawa   => $site_admin      => $second_blog);
    MT::Association->link($koishikawa => $designer        => $second_blog);
    MT::Association->link($sagawa     => $manage_pages    => $second_blog);
    MT::Association->link($shiki      => $rebuild         => $second_blog);
    MT::Association->link($suda       => $edit_config     => $second_blog);
    MT::Association->link($seta       => $edit_all_posts  => $second_blog);
    MT::Association->link($soneda     => $publish_post    => $second_blog);
    MT::Association->link($taneda     => $manage_feedback => $second_blog);
    MT::Association->link($toda       => $edit_templates  => $second_blog);
    MT::Association->link($noda       => $site_admin      => $second_blog);

    MT::Association->link($niyagawa => $site_admin     => $website);
    MT::Association->link($noda     => $edit_all_posts => $website);
    MT::Association->link($nunota   => $site_admin     => $second_website);

    MT::Association->link($kemikawa   => $create_post => $blog);
    MT::Association->link($koishikawa => $create_post => $blog);
    MT::Association->link($sagawa     => $create_post => $blog);
    MT::Association->link($shiki      => $create_post => $blog);
    MT::Association->link($suda       => $create_post => $blog);
    MT::Association->link($seta       => $create_post => $blog);
    MT::Association->link($soneda     => $create_post => $blog);
    MT::Association->link($taneda     => $create_post => $blog);
    MT::Association->link($toda       => $create_post => $blog);

    MT::Association->link($negoro => $create_post => $blog);

    $tsuda->can_create_site(1);
    $tsuda->save();

    $namegawa->can_edit_templates(1);
    $namegawa->save();

    $hada->can_edit_templates(1);
    $hada->save();

    # Entry
    my $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $kikkawa->id,
        title     => 'my entry',
    );

    # Page
    my $page = MT::Test::Permission->make_page(
        blog_id   => $blog->id,
        author_id => $ukawa->id,
        title     => 'my page',
    );

    # Template
    my $tmpl = MT::Test::Permission->make_template(blog_id => $second_blog->id,);
});

my $website        = MT::Website->load({ name => 'my website' });
my $second_website = MT::Website->load({ name => 'second website' });

my $blog        = MT::Blog->load({ name => 'my blog' });
my $second_blog = MT::Blog->load({ name => 'second blog' });

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
my $soneda     = MT::Author->load({ name => 'soneda' });
my $taneda     = MT::Author->load({ name => 'taneda' });
my $tsuda      = MT::Author->load({ name => 'tsuda' });
my $tezuka     = MT::Author->load({ name => 'tezuka' });
my $toda       = MT::Author->load({ name => 'toda' });
my $namegawa   = MT::Author->load({ name => 'namegawa' });
my $niyagawa   = MT::Author->load({ name => 'niyagawa' });
my $nunota     = MT::Author->load({ name => 'nunota' });
my $negoro     = MT::Author->load({ name => 'negoro' });
my $noda       = MT::Author->load({ name => 'noda' });
my $hada       = MT::Author->load({ name => 'hada' });
my $hida       = MT::Author->load({ name => 'hida' });

my $admin = MT::Author->load(1);

require MT::Role;
my $site_admin      = MT::Role->load({ name => MT->translate('Site Administrator') });
my $designer        = MT::Role->load({ name => MT->translate('Designer') });
my $create_post     = MT::Role->load({ name => MT->translate('Create Post') });
my $manage_pages    = MT::Role->load({ name => MT->translate('Manage Pages') });
my $rebuild         = MT::Role->load({ name => MT->translate('Rebuild') });
my $edit_config     = MT::Role->load({ name => MT->translate('Edit Config') });
my $edit_all_posts  = MT::Role->load({ name => MT->translate('Edit All Posts') });
my $publish_post    = MT::Role->load({ name => MT->translate('Publish Post') });
my $manage_feedback = MT::Role->load({ name => MT->translate('Manage Feedback') });
my $edit_templates  = MT::Role->load({ name => MT->translate('Edit Templates') });

my $entry = MT::Entry->load({ title => 'my entry' });
my $page  = MT::Page->load({ title => 'my page' });

subtest 'mode = cfg_prefs' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'cfg_prefs',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("cfg_prefs by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'cfg_prefs',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("cfg_prefs by permitted user");

    $app->login($suda);
    $app->post_ok({
        __mode  => 'cfg_prefs',
        blog_id => $blog->id,
    });
    $app->has_permission_error("cfg_prefs by other blog");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'cfg_prefs',
        blog_id => $blog->id,
    });
    $app->has_permission_error("cfg_prefs by other permission");
};

subtest 'mode = cfg_web_services' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'cfg_web_services',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("cfg_web_services by admin");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'cfg_web_services',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("cfg_web_services by permitted user");

    $app->login($suda);
    $app->post_ok({
        __mode  => 'cfg_web_services',
        blog_id => $blog->id,
    });
    $app->has_permission_error("cfg_web_services by other blog");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'cfg_web_services',
        blog_id => $blog->id,
    });
    $app->has_permission_error("cfg_web_services by other permission");
};

subtest 'mode = dialog_clone_blog' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'dialog_clone_blog',
        blog_id => $blog->id,
        id      => $blog->id,
    });
    $app->has_no_permission_error("dialog_clone_blog by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'dialog_clone_blog',
        blog_id => $blog->id,
        id      => $blog->id,
    });
    $app->has_permission_error("dialog_clone_blog by blog admin");

    $app->login($suda);
    $app->post_ok({
        __mode  => 'dialog_clone_blog',
        blog_id => $blog->id,
        id      => $blog->id,
    });
    $app->has_permission_error("dialog_clone_blog by other blog");
};

subtest 'mode = list' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $website->id,
        _type   => 'blog',
    });
    $app->has_no_permission_error("list by admin");

    $app->login($negoro);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $second_website->id,
        _type   => 'blog',
    });
    $app->has_permission_error("list by other blog");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'list',
        blog_id => $website->id,
        _type   => 'blog',
    });
    $app->has_no_permission_error("list by permitted user");

    foreach my $blog_id ($website->id) {
        note 'blog_id: ' . $blog_id;

        $app->login($noda);
        $app->post_ok({
            __mode  => 'list',
            blog_id => $blog_id,
            _type   => 'blog',
        });
        $app->has_no_permission_error("list by permitted user who is not parent website administrator");
        my $button = quotemeta '<a href="#delete" class="button">Delete</a>';
    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            $app->content_like(qr/$button/, 'There is "Delete" button.');
        }

        $app->login($hada);
        $app->post_ok({
            __mode  => 'list',
            blog_id => $blog_id,
            _type   => 'blog',
        });
        $app->has_no_permission_error("list by not permitted user");
        $app->content_unlike(qr/$button/, 'There is not "Delete" button.');

        $app->login($hida);
        $app->post_ok({
            __mode  => 'list',
            blog_id => $blog_id,
            _type   => 'blog',
        });
        $app->has_no_permission_error("list by permitted user");
    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            $app->content_like(qr/$button/, 'There is "Delete" button.');
        }
        my $refresh_tmpl = quotemeta '<option value="refresh_blog_templates">Refresh Template(s)</option>';
    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            $app->content_like(
                qr/$refresh_tmpl/,
                'There is "Refresh Template(s)" action.'
            );
        }
    }
};

subtest 'mode = rebuild_confirm' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'rebuild_confirm',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("rebuild_confirm by admin");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'rebuild_confirm',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("rebuild_confirm by permitted user");

    $app->login($shiki);
    $app->post_ok({
        __mode  => 'rebuild_confirm',
        blog_id => $blog->id,
    });
    $app->has_permission_error("rebuild_confirm by other blog");

    $app->login($kemikawa);
    $app->post_ok({
        __mode  => 'rebuild_confirm',
        blog_id => $blog->id,
    });
    $app->has_permission_error("rebuild_confirm by other permission");
};

subtest 'mode = rebuild_new_phase' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'rebuild_new_phase',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_no_permission_error("rebuild_new_phase by admin");

    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'rebuild_new_phase',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_no_permission_error("rebuild_new_phase by permitted user (publish_post)");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'rebuild_new_phase',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_no_permission_error("rebuild_new_phase by permitted user (edit_all_posts)");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'rebuild_new_phase',
        blog_id => $blog->id,
        id      => $page->id,
    });
    $app->has_no_permission_error("rebuild_new_phase by permitted user (manage pages)");

    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    $app->login($seta);
    $app->post_ok({
        __mode  => 'rebuild_new_phase',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_permission_error("rebuild_new_phase by other blog (edit_all_posts)");

    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $aikawa->id,
    );
    $app->login($soneda);
    $app->post_ok({
        __mode  => 'rebuild_new_phase',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_permission_error("rebuild_new_phase by other blog (publish_post)");

    $app->login($sagawa);
    $app->post_ok({
        __mode  => 'rebuild_new_phase',
        blog_id => $blog->id,
        id      => $page->id,
    });
    $app->has_permission_error("rebuild_new_phase by other blog (manage pages)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'rebuild_new_phase',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_permission_error("rebuild_new_phase by other permission");
};

subtest 'mode = rebuild' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'rebuild',
        blog_id => $blog->id,
        type    => 'all',
    });
    $app->has_no_permission_error("rebuild by admin");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'rebuild',
        blog_id => $blog->id,
        type    => 'all',
    });
    $app->has_no_permission_error("rebuild by permitted user");

    $app->login($shiki);
    $app->post_ok({
        __mode  => 'rebuild',
        blog_id => $blog->id,
        type    => 'all',
    });
    $app->has_permission_error("rebuild by other blog");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'rebuild',
        blog_id => $blog->id,
        type    => 'all',
    });
    $app->has_permission_error("rebuild by other permission");
};

subtest 'mode = rebuild_phase' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'rebuild_phase',
        blog_id => $blog->id,
        type    => 'entry',
        id      => $entry->id,
    });
    $app->has_no_permission_error("rebuild_phase by admin");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'rebuild_phase',
        blog_id => $blog->id,
        type    => 'entry',
        id      => $entry->id,
    });
    $app->has_no_permission_error("rebuild_phase by permitted user");

    $app->login($shiki);
    $app->post_ok({
        __mode  => 'rebuild_phase',
        blog_id => $blog->id,
        type    => 'entry',
        id      => $entry->id,
    });
    $app->has_permission_error("rebuild_phase by other blog");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'rebuild_phase',
        blog_id => $blog->id,
        type    => 'entry',
        id      => $entry->id,
    });
    $app->has_permission_error("rebuild_phase by other permission");
};

subtest 'mode = save (new)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode    => 'save',
        _type     => 'blog',
        name      => 'BlogName',
        parent_id => $website->id,
    });
    $app->has_no_permission_error("save (new) by admin");

    $app->login($tsuda);
    $app->post_ok({
        __mode    => 'save',
        _type     => 'blog',
        name      => 'BlogName',
        parent_id => $website->id,

    });
    $app->has_no_permission_error("save (new) by permitted user");

    $app->login($aikawa);
    $app->post_ok({
        __mode    => 'save',
        _type     => 'blog',
        name      => 'BlogName',
        parent_id => $website->id,

    });
    $app->has_permission_error("save (new) by blog admin");
};

subtest 'mode = save (edit)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'blog',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("save (edit) by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'blog',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("save (edit) by permitted user (blog admin)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'blog',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("save (edit) by permitted user (edit config)");

    $app->login($tsuda);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'blog',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_permission_error("save (edit) by non permitted user (create site)");

    $app->login($kemikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'blog',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_permission_error("save (edit) by other blog (blog admin)");

    $app->login($suda);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'blog',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_permission_error("save (edit) by other blog (edit config)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'blog',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_permission_error("save (edit) by other permission");
};

subtest 'mode = save (type is site)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'site',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_invalid_request("save (edit) by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'site',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_invalid_request("save (edit) by permitted user (blog admin)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'site',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_invalid_request("save (edit) by permitted user (edit config)");

    $app->login($tsuda);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'site',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_invalid_request("save (edit) by non permitted user (create site)");

    $app->login($kemikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'site',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_invalid_request("save (edit) by other blog (blog admin)");

    $app->login($suda);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'site',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_invalid_request("save (edit) by other blog (edit config)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save',
        _type   => 'site',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_invalid_request("save (edit) by other permission");
};

subtest 'mode = edit (new)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'blog',
        blog_id => $website->id,
    });
    $app->has_no_permission_error("edit (new) by admin");

    $app->login($tsuda);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'blog',
        blog_id => $website->id,
    });
    $app->has_no_permission_error("edit (new) by permitted user");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'blog',
        blog_id => $website->id,
    });
    $app->has_permission_error("edit (new) by blog admin");
};

subtest 'mode = edit (edit)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'blog',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("edit (edit) by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'blog',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("edit (edit) by permitted user (blog admin)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'blog',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("edit (edit) by permitted user (edit config)");

    $app->login($tsuda);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'blog',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_permission_error("edit (edit) by non permitted user (create site)");

    $app->login($kemikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'blog',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_permission_error("edit (edit) by other blog (blog admin)");

    $app->login($suda);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'blog',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_permission_error("edit (edit) by other blog (edit config)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'blog',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_permission_error("edit (edit) by other permission");
};

subtest 'mode = edit (type is site)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'site',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_invalid_request("edit (edit) by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'site',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_invalid_request("edit (edit) by permitted user (blog admin)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'site',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_invalid_request("edit (edit) by permitted user (edit config)");

    $app->login($tsuda);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'site',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_invalid_request("edit (edit) by non permitted user (create site)");

    $app->login($kemikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'site',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_invalid_request("edit (edit) by other blog (blog admin)");

    $app->login($suda);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'site',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_invalid_request("edit (edit) by other blog (edit config)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'site',
        name    => 'BlogName',
        id      => $blog->id,
        blog_id => $blog->id,
    });
    $app->has_invalid_request("edit (edit) by other permission");
};

subtest 'action = refresh_blog_templates' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'blog',
        action_name            => 'refresh_blog_templates',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_blog%26blog_id%3D' . $website->id,
        id                     => $blog->id,
        blog_id                => $website->id,
        plugin_action_selector => 'refresh_blog_templates',
    });
    $app->has_no_permission_error("refresh_blog_templates by admin");

    $app->login($tezuka);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'blog',
        action_name            => 'refresh_blog_templates',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_blog%26blog_id%3D' . $website->id,
        id                     => $blog->id,
        blog_id                => $website->id,
        plugin_action_selector => 'refresh_blog_templates',
    });
    $app->has_no_permission_error("refresh_blog_templates by permitted user");

    $app->login($namegawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'blog',
        action_name            => 'refresh_blog_templates',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_blog%26blog_id%3D' . $website->id,
        id                     => $blog->id,
        plugin_action_selector => 'refresh_blog_templates',
    });
    $app->has_no_permission_error("refresh_blog_templates by permitted user (system)");

    $app->login($toda);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'blog',
        action_name            => 'refresh_blog_templates',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_blog%26blog_id%3D' . $website->id,
        id                     => $blog->id,
        blog_id                => $website->id,
        plugin_action_selector => 'refresh_blog_templates',
    });
    $app->has_permission_error("refresh_blog_templates by other blog");

    $app->login($kumekawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'blog',
        action_name            => 'refresh_blog_templates',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_blog%26blog_id%3D' . $website->id,
        id                     => $blog->id,
        blog_id                => $website->id,
        plugin_action_selector => 'refresh_blog_templates',
    });
    $app->has_permission_error("refresh_blog_templates by other permission");
};

subtest 'mode = delete' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'blog',
        id     => $blog->id,
    });
    $app->has_no_permission_error("delete by admin");

    $blog = MT::Test::Permission->make_blog(parent_id => $website->id,);
    MT::Association->link($aikawa     => $site_admin      => $blog);
    MT::Association->link($ichikawa   => $designer        => $blog);
    MT::Association->link($ukawa      => $manage_pages    => $blog);
    MT::Association->link($egawa      => $rebuild         => $blog);
    MT::Association->link($ogawa      => $edit_config     => $blog);
    MT::Association->link($kagawa     => $edit_all_posts  => $blog);
    MT::Association->link($kikkawa    => $publish_post    => $blog);
    MT::Association->link($kumekawa   => $manage_feedback => $blog);
    MT::Association->link($tezuka     => $edit_templates  => $blog);
    MT::Association->link($kemikawa   => $create_post     => $blog);
    MT::Association->link($koishikawa => $create_post     => $blog);
    MT::Association->link($sagawa     => $create_post     => $blog);
    MT::Association->link($shiki      => $create_post     => $blog);
    MT::Association->link($suda       => $create_post     => $blog);
    MT::Association->link($seta       => $create_post     => $blog);
    MT::Association->link($soneda     => $create_post     => $blog);
    MT::Association->link($taneda     => $create_post     => $blog);
    MT::Association->link($toda       => $create_post     => $blog);
    $app->login($aikawa);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'blog',
        id     => $blog->id,
    });
    $app->has_no_permission_error("delete by permitted user (blog admin)");

    $blog = MT::Test::Permission->make_blog(parent_id => $website->id,);
    MT::Association->link($aikawa     => $site_admin      => $blog);
    MT::Association->link($ichikawa   => $designer        => $blog);
    MT::Association->link($ukawa      => $manage_pages    => $blog);
    MT::Association->link($egawa      => $rebuild         => $blog);
    MT::Association->link($ogawa      => $edit_config     => $blog);
    MT::Association->link($kagawa     => $edit_all_posts  => $blog);
    MT::Association->link($kikkawa    => $publish_post    => $blog);
    MT::Association->link($kumekawa   => $manage_feedback => $blog);
    MT::Association->link($tezuka     => $edit_templates  => $blog);
    MT::Association->link($kemikawa   => $create_post     => $blog);
    MT::Association->link($koishikawa => $create_post     => $blog);
    MT::Association->link($sagawa     => $create_post     => $blog);
    MT::Association->link($shiki      => $create_post     => $blog);
    MT::Association->link($suda       => $create_post     => $blog);
    MT::Association->link($seta       => $create_post     => $blog);
    MT::Association->link($soneda     => $create_post     => $blog);
    MT::Association->link($taneda     => $create_post     => $blog);
    MT::Association->link($toda       => $create_post     => $blog);
    $app->login($ogawa);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'blog',
        id     => $blog->id,
    });
    $app->has_permission_error("delete by non permitted user (edit config)");

    $blog = MT::Test::Permission->make_blog(parent_id => $website->id,);
    MT::Association->link($aikawa     => $site_admin      => $blog);
    MT::Association->link($ichikawa   => $designer        => $blog);
    MT::Association->link($ukawa      => $manage_pages    => $blog);
    MT::Association->link($egawa      => $rebuild         => $blog);
    MT::Association->link($ogawa      => $edit_config     => $blog);
    MT::Association->link($kagawa     => $edit_all_posts  => $blog);
    MT::Association->link($kikkawa    => $publish_post    => $blog);
    MT::Association->link($kumekawa   => $manage_feedback => $blog);
    MT::Association->link($tezuka     => $edit_templates  => $blog);
    MT::Association->link($kemikawa   => $create_post     => $blog);
    MT::Association->link($koishikawa => $create_post     => $blog);
    MT::Association->link($sagawa     => $create_post     => $blog);
    MT::Association->link($shiki      => $create_post     => $blog);
    MT::Association->link($suda       => $create_post     => $blog);
    MT::Association->link($seta       => $create_post     => $blog);
    MT::Association->link($soneda     => $create_post     => $blog);
    MT::Association->link($taneda     => $create_post     => $blog);
    MT::Association->link($toda       => $create_post     => $blog);
    $app = MT::Test::App->new('MT::App::CMS');
    $app->login($tsuda);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'blog',
        id     => $blog->id,
    });
    $app->has_permission_error("delete by non permitted user (create site)");

    $blog = MT::Test::Permission->make_blog(parent_id => $website->id,);
    MT::Association->link($aikawa     => $site_admin      => $blog);
    MT::Association->link($ichikawa   => $designer        => $blog);
    MT::Association->link($ukawa      => $manage_pages    => $blog);
    MT::Association->link($egawa      => $rebuild         => $blog);
    MT::Association->link($ogawa      => $edit_config     => $blog);
    MT::Association->link($kagawa     => $edit_all_posts  => $blog);
    MT::Association->link($kikkawa    => $publish_post    => $blog);
    MT::Association->link($kumekawa   => $manage_feedback => $blog);
    MT::Association->link($tezuka     => $edit_templates  => $blog);
    MT::Association->link($kemikawa   => $create_post     => $blog);
    MT::Association->link($koishikawa => $create_post     => $blog);
    MT::Association->link($sagawa     => $create_post     => $blog);
    MT::Association->link($shiki      => $create_post     => $blog);
    MT::Association->link($suda       => $create_post     => $blog);
    MT::Association->link($seta       => $create_post     => $blog);
    MT::Association->link($soneda     => $create_post     => $blog);
    MT::Association->link($taneda     => $create_post     => $blog);
    MT::Association->link($toda       => $create_post     => $blog);
    $app->login($kemikawa);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'blog',
        id     => $blog->id,
    });
    $app->has_permission_error("delete by other blog (blog admin)");

    $blog = MT::Test::Permission->make_blog(parent_id => $website->id,);
    MT::Association->link($aikawa     => $site_admin      => $blog);
    MT::Association->link($ichikawa   => $designer        => $blog);
    MT::Association->link($ukawa      => $manage_pages    => $blog);
    MT::Association->link($egawa      => $rebuild         => $blog);
    MT::Association->link($ogawa      => $edit_config     => $blog);
    MT::Association->link($kagawa     => $edit_all_posts  => $blog);
    MT::Association->link($kikkawa    => $publish_post    => $blog);
    MT::Association->link($kumekawa   => $manage_feedback => $blog);
    MT::Association->link($tezuka     => $edit_templates  => $blog);
    MT::Association->link($kemikawa   => $create_post     => $blog);
    MT::Association->link($koishikawa => $create_post     => $blog);
    MT::Association->link($sagawa     => $create_post     => $blog);
    MT::Association->link($shiki      => $create_post     => $blog);
    MT::Association->link($suda       => $create_post     => $blog);
    MT::Association->link($seta       => $create_post     => $blog);
    MT::Association->link($soneda     => $create_post     => $blog);
    MT::Association->link($taneda     => $create_post     => $blog);
    MT::Association->link($toda       => $create_post     => $blog);
    $app->login($suda);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'blog',
        id     => $blog->id,
    });
    $app->has_permission_error("delete by other blog (edit config)");

    $blog = MT::Test::Permission->make_blog(parent_id => $website->id,);
    MT::Association->link($aikawa     => $site_admin      => $blog);
    MT::Association->link($ichikawa   => $designer        => $blog);
    MT::Association->link($ukawa      => $manage_pages    => $blog);
    MT::Association->link($egawa      => $rebuild         => $blog);
    MT::Association->link($ogawa      => $edit_config     => $blog);
    MT::Association->link($kagawa     => $edit_all_posts  => $blog);
    MT::Association->link($kikkawa    => $publish_post    => $blog);
    MT::Association->link($kumekawa   => $manage_feedback => $blog);
    MT::Association->link($tezuka     => $edit_templates  => $blog);
    MT::Association->link($kemikawa   => $create_post     => $blog);
    MT::Association->link($koishikawa => $create_post     => $blog);
    MT::Association->link($sagawa     => $create_post     => $blog);
    MT::Association->link($shiki      => $create_post     => $blog);
    MT::Association->link($suda       => $create_post     => $blog);
    MT::Association->link($seta       => $create_post     => $blog);
    MT::Association->link($soneda     => $create_post     => $blog);
    MT::Association->link($taneda     => $create_post     => $blog);
    MT::Association->link($toda       => $create_post     => $blog);
    $app->login($ichikawa);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'blog',
        id     => $blog->id,
    });
    $app->has_permission_error("delete by other permission");
};

subtest 'mode = delete ( type is site)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'site',
        id     => $blog->id,
    });
    $app->has_invalid_request("delete by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'site',
        id     => $blog->id,
    });
    $app->has_invalid_request("delete by permitted user (blog admin)");

    $app->login($ogawa);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'site',
        id     => $blog->id,
    });
    $app->has_invalid_request("delete by non permitted user (edit config)");

    $app->login($tsuda);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'site',
        id     => $blog->id,
    });
    $app->has_invalid_request("delete by non permitted user (create site)");

    $app->login($kemikawa);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'site',
        id     => $blog->id,
    });
    $app->has_invalid_request("delete by other blog (blog admin)");

    $app->login($suda);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'site',
        id     => $blog->id,
    });
    $app->has_invalid_request("delete by other blog (edit config)");

    $app->login($ichikawa);
    $app->post_ok({
        __mode => 'delete',
        _type  => 'site',
        id     => $blog->id,
    });
    $app->has_invalid_request("delete by other permission");
};

done_testing();
