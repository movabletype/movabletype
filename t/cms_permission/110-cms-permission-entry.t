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
    my $other_website = MT::Test::Permission->make_website(
        name => 'other website',
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
    my $other_blog = MT::Test::Permission->make_blog(
        parent_id => $other_website->id,
        name      => 'other blog',
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

    my $shimoda = MT::Test::Permission->make_author(
        name     => 'shimoda',
        nickname => 'Jiro Shimoda',
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

    my $chiyoda = MT::Test::Permission->make_author(
        name     => 'chiyoda',
        nickname => 'Jiro Chiyoda',
    );

    my $tsuneta = MT::Test::Permission->make_author(
        name     => 'tsuneta',
        nickname => 'Saburo Tsuneta',
    );

    my $terada = MT::Test::Permission->make_author(
        name     => 'terada',
        nickname => 'Shiro Terada',
    );

    my $toda = MT::Test::Permission->make_author(
        name     => 'toda',
        nickname => 'Goro Toda',
    );

    my $nashida = MT::Test::Permission->make_author(
        name     => 'nashida',
        nickname => 'Ichiro Nashida',
    );

    my $nishioka = MT::Test::Permission->make_author(
        name     => 'nishioka',
        nickname => 'Jiro Nishioka',
    );

    my $nukita = MT::Test::Permission->make_author(
        name     => 'nukita',
        nickname => 'Saburo Nukita',
    );

    my $negishi = MT::Test::Permission->make_author(
        name     => 'negishi',
        nickname => 'Shiro Negishi',
    );

    my $nonoda = MT::Test::Permission->make_author(
        name     => 'nonoda',
        nickname => 'Goro Nonoda',
    );

    my $hakamada = MT::Test::Permission->make_author(
        name     => 'hakamada',
        nickname => 'Ichiro Hakamada',
    );

    my $hikita = MT::Test::Permission->make_author(
        name     => 'hikita',
        nickname => 'Jiro Hikita',
    );

    my $fukuda = MT::Test::Permission->make_author(
        name     => 'fukuda',
        nickname => 'Saburo Fukuda',
    );

    my $admin = MT::Author->load(1);

    # Role
    my $create_post = MT::Test::Permission->make_role(
        name        => 'Create Post',
        permissions => "'create_post'",
    );

    my $edit_all_posts = MT::Test::Permission->make_role(
        name        => 'Edit All Posts',
        permissions => "'edit_all_posts'",
    );

    my $manage_pages = MT::Test::Permission->make_role(
        name        => 'Manage Pages',
        permissions => "'manage_pages'",
    );

    my $publish_post = MT::Test::Permission->make_role(
        name        => 'Publish Post',
        permissions => "'publish_post'",
    );

    my $edit_config = MT::Test::Permission->make_role(
        name        => 'Edit Config',
        permissions => "'edit_config'",
    );

    my $designer = MT::Role->load({ name => MT->translate('Designer') });

    require MT::Association;
    MT::Association->link($aikawa   => $edit_config    => $blog);
    MT::Association->link($ichikawa => $create_post    => $blog);
    MT::Association->link($ukawa    => $edit_all_posts => $blog);
    MT::Association->link($egawa    => $manage_pages   => $blog);
    MT::Association->link($ogawa    => $create_post    => $blog);
    MT::Association->link($kagawa   => $designer       => $blog);
    MT::Association->link($shimoda  => $publish_post   => $blog);
    MT::Association->link($seta     => $publish_post   => $blog);

    MT::Association->link($kikkawa    => $edit_config    => $second_blog);
    MT::Association->link($kumekawa   => $create_post    => $second_blog);
    MT::Association->link($koishikawa => $edit_all_posts => $second_blog);
    MT::Association->link($kemikawa   => $manage_pages   => $second_blog);
    MT::Association->link($suda       => $publish_post   => $second_blog);

    MT::Association->link($sorimachi, $edit_config,    $website);
    MT::Association->link($tsuneta,   $create_post,    $website);
    MT::Association->link($terada,    $edit_all_posts, $website);
    MT::Association->link($nishioka,  $create_post,    $website);
    MT::Association->link($nukita,    $designer,       $website);
    MT::Association->link($negishi,   $manage_pages,   $website);
    MT::Association->link($hikita,    $publish_post,   $website);
    MT::Association->link($fukuda,    $publish_post,   $website);

    MT::Association->link($tada,   $edit_config,    $other_website);
    MT::Association->link($toda,   $create_post,    $other_website);
    MT::Association->link($nonoda, $edit_all_posts, $other_website);

    MT::Association->link($chiyoda,  $edit_config,    $other_blog);
    MT::Association->link($nashida,  $create_post,    $other_blog);
    MT::Association->link($hakamada, $edit_all_posts, $other_blog);

    # Entry
    my $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
        title     => 'my entry',
    );
    my $entry2 = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $shimoda->id,
        title     => 'my entry2',
    );
    my $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $tsuneta->id,
        title     => 'my website entry',
    );
    my $other_website_entry = MT::Test::Permission->make_entry(
        blog_id   => $other_website->id,
        author_id => $toda->id,
        title     => 'other website entry',
    );

    # Page
    my $page = MT::Test::Permission->make_page(
        blog_id   => $blog->id,
        author_id => $egawa->id,
        title     => 'my page',
    );
    my $website_page = MT::Test::Permission->make_page(
        blog_id   => $website->id,
        author_id => $negishi->id,
        title     => 'my website page',
    );
});

my $website       = MT::Website->load({ name => 'my website' });
my $other_website = MT::Website->load({ name => 'other website' });

my $blog        = MT::Blog->load({ name => 'my blog' });
my $second_blog = MT::Blog->load({ name => 'second blog' });
my $other_blog  = MT::Blog->load({ name => 'other blog' });

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
my $shimoda    = MT::Author->load({ name => 'shimoda' });
my $suda       = MT::Author->load({ name => 'suda' });
my $seta       = MT::Author->load({ name => 'seta' });
my $sorimachi  = MT::Author->load({ name => 'sorimachi' });
my $tada       = MT::Author->load({ name => 'tada' });
my $chiyoda    = MT::Author->load({ name => 'chiyoda' });
my $tsuneta    = MT::Author->load({ name => 'tsuneta' });
my $terada     = MT::Author->load({ name => 'terada' });
my $toda       = MT::Author->load({ name => 'toda' });
my $nashida    = MT::Author->load({ name => 'nashida' });
my $nishioka   = MT::Author->load({ name => 'nishioka' });
my $nukita     = MT::Author->load({ name => 'nukita' });
my $negishi    = MT::Author->load({ name => 'negishi' });
my $nonoda     = MT::Author->load({ name => 'nonoda' });
my $hakamada   = MT::Author->load({ name => 'hakamada' });
my $hikita     = MT::Author->load({ name => 'hikita' });
my $fukuda     = MT::Author->load({ name => 'fukuda' });

my $admin = MT::Author->load(1);

my $entry         = MT::Entry->load({ title => 'my entry' });
my $entry2        = MT::Entry->load({ title => 'my entry2' });
my $website_entry = MT::Entry->load({ title => 'my website entry' });

my $page         = MT::Page->load({ title => 'my page' });
my $website_page = MT::Page->load({ title => 'my website page' });

# XXX: Some of the subtests depend on the result of the previous subtests.

subtest 'mode = cfg_entry' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'cfg_entry',
        blog_id => $blog->id,
        _type   => 'entry',
        id      => $entry->id,
    });
    $app->has_no_permission_error("cfg_entry by admin");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'cfg_entry',
        blog_id => $blog->id,
    });
    $app->has_no_permission_error("cfg_entry by permitted user");

    $app->login($kikkawa);
    $app->post_ok({
        __mode  => 'cfg_entry',
        blog_id => $blog->id,
    });
    $app->has_permission_error("cfg_entry by other blog");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'cfg_entry',
        blog_id => $blog->id,
    });
    $app->has_permission_error("cfg_entry by other permission");
};

subtest 'mode = cfg_entry (website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'cfg_entry',
        blog_id => $website->id,
    });
    $app->has_no_permission_error("cfg_entry by admin");

    $app->login($sorimachi);
    $app->post_ok({
        __mode  => 'cfg_entry',
        blog_id => $website->id,
    });
    $app->has_no_permission_error("cfg_entry by permitted user");

    $app->login($tada);
    $app->post_ok({
        __mode  => 'cfg_entry',
        blog_id => $website->id,
    });
    $app->has_permission_error("cfg_entry by other website");

    $app->login($aikawa);
    $app->post_ok({
        __mode  => 'cfg_entry',
        blog_id => $website->id,
    });
    $app->has_permission_error("cfg_entry by child blog");

    $app->login($chiyoda);
    $app->post_ok({
        __mode  => 'cfg_entry',
        blog_id => $website->id,
    });
    $app->has_permission_error("cfg_entry by other blog");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'cfg_entry',
        blog_id => $website->id,
    });
    $app->has_permission_error("cfg_entry by other permission");
};

subtest 'mode = delete_entry' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $website->id,
        id      => $entry->id,
    });
    $app->has_no_permission_error("delete_entry by admin");

    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
    );

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_no_permission_error("delete_entry by permitted user (create_post)");

    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
    );

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_no_permission_error("delete_entry by permitted user (edit_all_posts)");

    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
    );

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_permission_error("delete_entry by other user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_permission_error("delete_entry by other permission");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $second_blog->id,
        id      => $entry->id,
    });
    $app->has_permission_error("delete_entry by other blog");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $blog->id,
        id      => $page->id,
    });
    $app->has_permission_error("delete_entry by type mismatch");
};

subtest 'mode = delete_entry (website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $blog->id,
        id      => $website_entry->id,
    });
    $app->has_no_permission_error("delete_entry by admin");

    $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $tsuneta->id,
    );

    $app->login($tsuneta);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_no_permission_error("delete_entry by permitted user (create_post)");

    $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $tsuneta->id,
    );

    $app->login($terada);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_no_permission_error("delete_entry by permitted user (edit_all_posts)");

    $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $tsuneta->id,
    );

    $app->login($nishioka);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("delete_entry by other user");

    $app->login($nukita);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("delete_entry by other permission");

    $app->login($toda);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("delete_entry by other website");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("delete_entry by child blog");

    $app->login($nashida);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $other_website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("delete_entry by other blog");

    $app->login($terada);
    $app->post_ok({
        __mode  => 'delete_entry',
        blog_id => $website->id,
        id      => $website_page->id,
    });
    $app->has_permission_error("delete_entry by type mismatch");
};

subtest 'mode = list' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_no_permission_error("list by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_no_permission_error("list by permitted user (create_post)");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_no_permission_error("list by permitted user (edit_all_posts)");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_permission_error("list by other permission");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_permission_error("list by other blog");
};

subtest 'mode = list (website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_no_permission_error("list by admin");

    $app->login($tsuneta);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_no_permission_error("list by permitted user (create_post)");

    $app->login($terada);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_no_permission_error("list by permitted user (edit_all_posts)");

    $app->login($nukita);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("list by other permission");

    $app->login($toda);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("list by other website");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("list by child blog");

    $app->login($nashida);
    $app->post_ok({
        __mode  => 'list',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("list by other blog");
};

subtest 'mode = pinged_urls' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $blog->id,
        entry_id => $entry->id,
    });
    $app->has_no_permission_error("pinged_urls by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $blog->id,
        entry_id => $entry->id,
    });
    $app->has_no_permission_error("pinged_urls by permitted user (create_post)");

    $app->login($ukawa);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $blog->id,
        entry_id => $entry->id,
    });
    $app->has_no_permission_error("pinged_urls by permitted user (edit_all_posts)");

    $app->login($egawa);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $blog->id,
        entry_id => $page->id,
    });
    $app->has_no_permission_error("pinged_urls by permitted user (manage_page)");

    $app->login($ogawa);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $blog->id,
        entry_id => $entry->id,
    });
    $app->has_permission_error("pinged_urls by other user");

    $app->login($kagawa);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $blog->id,
        entry_id => $entry->id,
    });
    $app->has_permission_error("pinged_urls by other permission");

    $app->login($kumekawa);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $second_blog->id,
        entry_id => $entry->id,
    });
    $app->has_invalid_request("pinged_urls by other blog");

    $app->login($egawa);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $blog->id,
        entry_id => $entry->id,
    });
    $app->has_permission_error("pinged_urls by type mismatch");

    $app->login($ichikawa);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $blog->id,
        entry_id => $page->id,
    });
    $app->has_permission_error("pinged_urls by type mismatch");
};

subtest 'mode = pinged_urls (website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $website->id,
        entry_id => $website_entry->id,
    });
    $app->has_no_permission_error("pinged_urls by admin");

    $app->login($tsuneta);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $website->id,
        entry_id => $website_entry->id,
    });
    $app->has_no_permission_error("pinged_urls by permitted user (create_post)");

    $app->login($terada);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $website->id,
        entry_id => $website_entry->id,
    });
    $app->has_no_permission_error("pinged_urls by permitted user (edit_all_posts)");

    $app->login($negishi);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $website->id,
        entry_id => $website_page->id,
    });
    $app->has_no_permission_error("pinged_urls by permitted user (manage_page)");

    $app->login($nishioka);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $website->id,
        entry_id => $website_entry->id,
    });
    $app->has_permission_error("pinged_urls by other user");

    $app->login($nukita);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $website->id,
        entry_id => $website_entry->id,
    });
    $app->has_permission_error("pinged_urls by other permission");

    $app->login($toda);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $other_website->id,
        entry_id => $website_entry->id,
    });
    $app->has_invalid_request("pinged_urls by other website");

    $app->login($toda);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $other_website->id,
        entry_id => $website_entry->id,
    });
    $app->has_invalid_request("pinged_urls by child blog");

    $app->login($nashida);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $other_blog->id,
        entry_id => $website_entry->id,
    });
    $app->has_invalid_request("pinged_urls by other blog");

    $app->login($negishi);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $website->id,
        entry_id => $website_entry->id,
    });
    $app->has_permission_error("pinged_urls by type mismatch");

    $app->login($tsuneta);
    $app->post_ok({
        __mode   => 'pinged_urls',
        blog_id  => $website->id,
        entry_id => $website_page->id,
    });
    $app->has_permission_error("pinged_urls by type mismatch");
};

subtest 'mode = preview_entry' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_no_permission_error("preview_entry by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_no_permission_error("preview_entry by permitted user (create_post)");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_no_permission_error("preview_entry by permitted user (edit_all_posts)");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $blog->id,
        id      => $page->id,
    });
    $app->has_no_permission_error("preview_entry by permitted user (manage_page)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_permission_error("preview_entry by other user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_permission_error("preview_entry by other permission");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $second_blog->id,
        id      => $entry->id,
    });
    $app->has_invalid_request("preview_entry by other blog");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_permission_error("preview_entry by type mismatch");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $blog->id,
        id      => $page->id,
    });
    $app->has_permission_error("preview_entry by type mismatch");
};

subtest 'mode = preview_entry (website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_no_permission_error("preview_entry by admin");

    $app->login($tsuneta);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_no_permission_error("preview_entry by permitted user (create_post)");

    $app->login($terada);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_no_permission_error("preview_entry by permitted user (edit_all_posts)");

    $app->login($negishi);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $website->id,
        id      => $website_page->id,
    });
    $app->has_no_permission_error("preview_entry by permitted user (manage_page)");

    $app->login($nishioka);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("preview_entry by other user");

    $app->login($nukita);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("preview_entry by other permission");

    $app->login($toda);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $other_website->id,
        id      => $website_entry->id,
    });
    $app->has_invalid_request("preview_entry by other website");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $blog->id,
        id      => $website_entry->id,
    });
    $app->has_invalid_request("preview_entry by child blog");

    $app->login($nashida);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $other_blog->id,
        id      => $website_entry->id,
    });
    $app->has_invalid_request("preview_entry by other blog");

    $app->login($negishi);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("preview_entry by type mismatch");

    $app->login($tsuneta);
    $app->post_ok({
        __mode  => 'preview_entry',
        blog_id => $website->id,
        id      => $website_page->id,
    });
    $app->has_permission_error("preview_entry by type mismatch");
};

subtest 'mode = save_entry' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $blog->id,
        id      => $entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $entry->status,
    });
    $app->has_no_permission_error("save_entry by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $blog->id,
        id      => $entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $entry->status,
    });
    $app->has_no_permission_error("save_entry by permitted user (create_post)");
    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $blog->id,
        id      => $entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $entry->status,
    });
    $app->has_no_permission_error("save_entry by permitted user (edit_all_posts)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $blog->id,
        id      => $entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $entry->status,
    });
    $app->has_permission_error("save_entry by other user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $blog->id,
        id      => $entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $entry->status,
    });
    $app->has_permission_error("save_entry by other permission");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $blog->id,
        id      => $entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $entry->status,
    });
    $app->has_permission_error("save_entry by other blog");

    $app->login($egawa);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $blog->id,
        id      => $entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $entry->status,
    });
    $app->has_permission_error("save_entry by type mismatch");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $blog->id,
        id      => $page->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $page->status,
    });
    $app->has_permission_error("save_entry by type mismatch");
};

subtest 'mode = save_entry (website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $website_entry->status,
    });
    $app->has_no_permission_error("save_entry by admin");

    $app->login($tsuneta);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $website_entry->status,
    });
    $app->has_no_permission_error("save_entry by permitted user (create_post)");

    $app->login($terada);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $website_entry->status,
    });
    $app->has_no_permission_error("save_entry by permitted user (edit_all_posts)");

    $app->login($nishioka);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $website_entry->status,
    });
    $app->has_permission_error("save_entry by other user");

    $app->login($nukita);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $website_entry->status,
    });
    $app->has_permission_error("save_entry by other permission");

    $app->login($toda);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $website_entry->status,
    });
    $app->has_permission_error("save_entry by other website");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $website_entry->status,
    });
    $app->has_permission_error("save_entry by child blog");

    $app->login($nashida);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $website_entry->status,
    });
    $app->has_permission_error("save_entry by other blog");

    $app->login($negishi);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $website->id,
        id      => $website_entry->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $website_entry->status,
    });
    $app->has_permission_error("save_entry by type mismatch");

    $app->login($tsuneta);
    $app->post_ok({
        __mode  => 'save_entry',
        blog_id => $website->id,
        id      => $website_page->id,
        title   => 'changed',
        _type   => 'entry',
        status  => $website_page->status,
    });
    $app->has_permission_error("save_entry by type mismatch");
};

subtest 'mode = save_entries' => sub {
    my $author_id = "author_id_" . $entry->id;
    my $col_name  = "title_" . $entry->id;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode     => 'save_entries',
        blog_id    => $blog->id,
        $author_id => $entry->author->id,
        $col_name  => 'changed',
    });
    $app->has_no_permission_error("save_entries by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode     => 'save_entries',
        blog_id    => $blog->id,
        $author_id => $entry->author->id,
        $col_name  => 'changed',
    });
    $app->has_permission_error("save_entries by non permitted user (create_post)");

    $app->login($ukawa);
    $app->post_ok({
        __mode     => 'save_entries',
        blog_id    => $blog->id,
        $author_id => $entry->author->id,
        $col_name  => 'changed',
    });
    $app->has_no_permission_error("save_entries by permitted user (edit_all_posts)");

    $app->login($kagawa);
    $app->post_ok({
        __mode     => 'save_entries',
        blog_id    => $blog->id,
        $author_id => $entry->author->id,
        $col_name  => 'changed',
    });
    $app->has_permission_error("save_entries by other permission");

    $app->login($koishikawa);
    $app->post_ok({
        __mode     => 'save_entries',
        blog_id    => $second_blog->id,
        $author_id => $entry->author->id,
        $col_name  => 'changed',
    });
    $app->has_permission_error("save_entries by other blog");

    $author_id = "author_id_" . $page->id;
    $col_name  = "title_" . $page->id;
    $app->login($ukawa);
    $app->post_ok({
        __mode     => 'save_entries',
        blog_id    => $blog->id,
        $author_id => $page->author->id,
        $col_name  => 'changed',
    });
    $app->has_permission_error("save_entries by type mismatch");
};

subtest 'mode = save_entries (website)' => sub {
    my $author_id = "author_id_" . $website_entry->id;
    my $col_name  = "title_" . $website_entry->id;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode     => 'save_entries',
        blog_id    => $website->id,
        $author_id => $website_entry->author->id,
        $col_name  => 'changed',
    });
    $app->has_no_permission_error("save_entries by admin");

    $app->login($tsuneta);
    $app->post_ok({
        __mode     => 'save_entries',
        blog_id    => $website->id,
        $author_id => $website_entry->author->id,
        $col_name  => 'changed',
    });
    $app->has_permission_error("save_entries by non permitted user (create_post)");

    $app->login($terada);
    $app->post_ok({
        __mode     => 'save_entries',
        blog_id    => $website->id,
        $author_id => $website_entry->author->id,
        $col_name  => 'changed',
    });
    $app->has_no_permission_error("save_entries by permitted user (edit_all_posts)");

    $app->login($nukita);
    $app->post_ok({
        __mode     => 'save_entries',
        blog_id    => $website->id,
        $author_id => $website_entry->author->id,
        $col_name  => 'changed',
    });
    $app->has_permission_error("save_entries by other permission");

    $app->login($nonoda);
    $app->post_ok({
        __mode     => 'save_entries',
        blog_id    => $other_website->id,
        $author_id => $website_entry->author->id,
        $col_name  => 'changed',
    });
    $app->has_permission_error("save_entries by other website");

    $app->login($ukawa);
    $app->post_ok({
        __mode     => 'save_entries',
        blog_id    => $blog->id,
        $author_id => $website_entry->author->id,
        $col_name  => 'changed',
    });
    $app->has_permission_error("save_entries by child blog");

    $app->login($hakamada);
    $app->post_ok({
        __mode     => 'save_entries',
        blog_id    => $other_blog->id,
        $author_id => $website_entry->author->id,
        $col_name  => 'changed',
    });
    $app->has_permission_error("save_entries by other blog");

    $author_id = "author_id_" . $website_page->id;
    $col_name  = "title_" . $website_page->id;
    $app->login($terada);
    $app->post_ok({
        __mode     => 'save_entries',
        blog_id    => $website->id,
        $author_id => $website_page->author->id,
        $col_name  => 'changed',
    });
    $app->has_permission_error("save_entries by type mismatch");
};

subtest 'mode = edit' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_no_permission_error("edit by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_no_permission_error("edit by permitted user (create_post)");

    $app->login($ukawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_no_permission_error("edit by permitted user (edit_all_posts)");

    $app->login($ogawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_permission_error("edit by other user");

    $app->login($kagawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $blog->id,
        id      => $entry->id,
    });
    $app->has_permission_error("edit by other permission");

    $app->login($kumekawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $second_blog->id,
        id      => $entry->id,
    });
    $app->has_permission_error("edit by other blog");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $blog->id,
        id      => $page->id,
    });
    $app->has_permission_error("edit by type mismatch");
};

subtest 'mode = edit (website)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_no_permission_error("edit by admin");

    $app->login($tsuneta);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_no_permission_error("edit by permitted user (create_post)");

    $app->login($terada);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_no_permission_error("edit by permitted user (edit_all_posts)");

    $app->login($nishioka);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("edit by other user");

    $app->login($nukita);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("edit by other permission");

    $app->login($toda);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $other_website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("edit by other website");

    $app->login($ichikawa);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("edit by child blog");

    $app->login($nashida);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $other_blog->id,
        id      => $website_entry->id,
    });
    $app->has_permission_error("edit by other blog");

    $app->login($tsuneta);
    $app->post_ok({
        __mode  => 'edit',
        _type   => 'entry',
        blog_id => $website->id,
        id      => $website_page->id,
    });
    $app->has_permission_error("edit by type mismatch");
};

subtest 'action = set_draft' => sub {
    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $shimoda->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_no_permission_error("set_draft by admin");

    $app->login($shimoda);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_no_permission_error("set_draft by permitted user (publish_post)");

    $app->login($ukawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_no_permission_error("set_draft by permitted user (edit_all_posts)");

    $app->login($seta);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_permission_error("set_draft by other user");

    $app->login($kagawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_permission_error("set_draft by other permission");

    $app->login($koishikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_permission_error("set_draft by other blog");

    $app->login($kagawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_permission_error("set_draft by type mismatch");
};

subtest 'action = set_draft (website)' => sub {
    $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $hikita->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_no_permission_error("set_draft by admin");

    $app->login($hikita);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_no_permission_error("set_draft by permitted user (publish_post)");

    $app->login($terada);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_no_permission_error("set_draft by permitted user (edit_all_posts)");

    $app->login($fukuda);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_permission_error("set_draft by other user");

    $app->login($nukita);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_permission_error("set_draft by other permission");

    $app->login($nonoda);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_permission_error("set_draft by other website");

    $app->login($ukawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_permission_error("set_draft by child blog");

    $app->login($hakamada);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_permission_error("set_draft by other blog");

    $app->login($negishi);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'set_draft',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_page->id,
        plugin_action_selector => 'set_draft',
    });
    $app->has_permission_error("set_draft by type mismatch");
};

subtest 'action = add_tags' => sub {
    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_no_permission_error("add_tags by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_no_permission_error("add_tags by permitted user (create_post)");

    $app->login($ukawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_no_permission_error("add_tags by permitted user (edit_all_posts)");

    $app->login($ogawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_permission_error("add_tags by other user");

    $app->login($kagawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_permission_error("add_tags by other permission");

    $app->login($koishikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_permission_error("add_tags by other blog");

    $app->login($kagawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_permission_error("add_tags by type mismatch");
};

subtest 'action = add_tags (website)' => sub {
    $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $tsuneta->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_no_permission_error("add_tags by admin");

    $app->login($tsuneta);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_no_permission_error("add_tags by permitted user (create_post)");

    $app->login($terada);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_no_permission_error("add_tags by permitted user (edit_all_posts)");

    $app->login($nishioka);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_permission_error("add_tags by other user");

    $app->login($nukita);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_permission_error("add_tags by other permission");

    $app->login($nonoda);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_permission_error("add_tags by other website");

    $app->login($ukawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_permission_error("add_tags by child blog");

    $app->login($hakamada);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_permission_error("add_tags by other blog");

    $app->login($negishi);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'add_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_page->id,
        plugin_action_selector => 'add_tags',
    });
    $app->has_permission_error("add_tags by type mismatch");
};

subtest 'action = remove_tags' => sub {
    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_no_permission_error("remove_tags by admin");

    $app->login($ichikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_no_permission_error("remove_tags by permitted user (create_post)");

    $app->login($ukawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_no_permission_error("remove_tags by permitted user (edit_all_posts)");

    $app->login($ogawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_permission_error("remove_tags by other user");

    $app->login($kagawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_permission_error("remove_tags by other permission");

    $app->login($koishikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_permission_error("remove_tags by other blog");

    $app->login($kagawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_permission_error("remove_tags by type mismatch");
};

subtest 'action = remove_tags (website)' => sub {
    $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $tsuneta->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_no_permission_error("remove_tags by admin");

    $app->login($tsuneta);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_no_permission_error("remove_tags by permitted user (create_post)");

    $app->login($terada);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_no_permission_error("remove_tags by permitted user (edit_all_posts)");

    $app->login($nishioka);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_permission_error("remove_tags by other user");

    $app->login($nukita);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_permission_error("remove_tags by other permission");

    $app->login($nonoda);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_permission_error("remove_tags by other website");

    $app->login($ukawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_permission_error("remove_tags by child blog");

    $app->login($hakamada);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_permission_error("remove_tags by other blog");

    $app->login($negishi);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'remove_tags',
        itemset_action_input   => 'New Tag',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_page->id,
        plugin_action_selector => 'remove_tags',
    });
    $app->has_permission_error("remove_tags by type mismatch");
};

subtest 'action = open_batch_editor' => sub {
    $entry = MT::Test::Permission->make_entry(
        blog_id   => $blog->id,
        author_id => $ichikawa->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_no_permission_error("open_batch_editor by admin");

    $app->login($ukawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_no_permission_error("open_batch_editor by permitted user (edit_all_posts)");

    $app->login($kagawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_permission_error("open_batch_editor by other permission");

    $app->login($koishikawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $entry->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_permission_error("open_batch_editor by other blog");

    $app->login($kagawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $blog->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $blog->id,
        id                     => $page->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_permission_error("open_batch_editor by type mismatch");
};

subtest 'action = open_batch_editor (website)' => sub {
    $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $tsuneta->id,
    );
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_no_permission_error("open_batch_editor by admin");

    $app->login($terada);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_no_permission_error("open_batch_editor by permitted user (edit_all_posts)");

    $app->login($nukita);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_permission_error("open_batch_editor by other permission");

    $app->login($nonoda);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_permission_error("open_batch_editor by other website");

    $app->login($ukawa);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_permission_error("open_batch_editor by child blog");

    $app->login($hakamada);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_entry->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_permission_error("open_batch_editor by other blog");

    $app->login($negishi);
    $app->post_ok({
        __mode                 => 'itemset_action',
        _type                  => 'entry',
        action_name            => 'open_batch_editor',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_entry%26blog_id%3D' . $website->id . '%26filter_key%3Dmy_posts_on_this_context',
        blog_id                => $website->id,
        id                     => $website_page->id,
        plugin_action_selector => 'open_batch_editor',
    });
    $app->has_permission_error("open_batch_editor by type mismatch");
};

subtest 'mode = save_entry_prefs (entry)' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
            __mode       => 'save_entry_prefs',
            _type        => 'entry',
            blog_id      => $website->id,
            entry_prefs  => 'Custom',
            custom_prefs => 'title,text,keywords,tags,category,feedback,assets',
            sort_only    => 'false',
        },
    );
    $app->has_no_permission_error("save_entry_prefs by admin");

    $app->login($ichikawa);
    $app->post_ok({
            __mode       => 'save_entry_prefs',
            _type        => 'entry',
            blog_id      => $blog->id,
            entry_prefs  => 'Custom',
            custom_prefs => 'title,text,keywords,tags,category,feedback,assets',
            sort_only    => 'false',
        },
    );
    $app->has_no_permission_error("save_entry_prefs by permitted user (create_post)");

    $app->login($ukawa);
    $app->post_ok({
            __mode       => 'save_entry_prefs',
            _type        => 'entry',
            blog_id      => $blog->id,
            entry_prefs  => 'Custom',
            custom_prefs => 'title,text,keywords,tags,category,feedback,assets',
            sort_only    => 'false',
        },
    );
    $app->has_no_permission_error("save_entry_prefs by permitted user (edit_all_posts)");

    $app->login($kagawa);
    $app->post_ok({
            __mode       => 'save_entry_prefs',
            _type        => 'entry',
            blog_id      => $blog->id,
            entry_prefs  => 'Custom',
            custom_prefs => 'title,text,keywords,tags,category,feedback,assets',
            sort_only    => 'false',
        },
    );
    $app->has_permission_error("save_entry_prefs by other permission");

    $app->login($kumekawa);
    $app->post_ok({
            __mode       => 'save_entry_prefs',
            _type        => 'entry',
            blog_id      => $blog->id,
            entry_prefs  => 'Custom',
            custom_prefs => 'title,text,keywords,tags,category,feedback,assets',
            sort_only    => 'false',
        },
    );
    $app->has_permission_error("save_entry_prefs by other blog");
};

done_testing();
