#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',  ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
    $ENV{MT_APP}    = 'MT::App::CMS';
}

use MT::Test::Tag;
use MT::Test::PHP;
plan tests => (1 + 2) * blocks;

use MT;
use MT::PublishOption;
use MT::Test;
use MT::Test::App;

my $app    = MT->instance;
my $config = $app->config;
$config->AllowComments( 1, 1 );
$config->StaticFilePath( './mt-static', 1 );
$config->CommenterRegistration( { Allow => 1 }, 1 );
$config->save_config;
delete $app->{__static_file_path};

my $blog_id       = 1;                                        # First Website

my $php_supports_gd = MT::Test::PHP->supports_gd;
MT::Test::Tag->vars->{no_php_gd} = !$php_supports_gd;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $first_website = $app->model('website')->load($blog_id);
    $first_website->set_values(
        {   allow_reg_comments       => 1,
            remote_auth_token        => 'token',
            allow_unreg_comments     => 1,
            commenter_authenticators => 'MovableType,TypeKey',
        }
    );
    $first_website->save or die $first_website->errstr;

    my $mt = MT->instance;

    # Create userpic
    my $userpic = $mt->model('asset')->new;
    $userpic->set_values(
        {   blog_id   => 0,
            class     => 'image',
            label     => 'Userpic',
            file_ext  => 'png',
            file_path => './mt-static/images/logo/movable-type-logo.png',
            file_name => 'movable-type-logo.png',
            url       => '%s/images/logo/movable-type-logo.png',
        }
    );
    $userpic->save or die $mt->errstr;

    my $admin = $mt->model('author')->load(1);    # Administrator
    $admin->set_values(
        {   nickname         => 'Administrator Melody',
            basename         => 'melody',
            email            => 'melody@localhost',
            url              => 'http://localhost/~melody/',
            userpic_asset_id => $userpic->id,
        }
    );
    $admin->save or die $admin->errstr;

    my $guest = $mt->model('author')->new;
    $guest->set_values(
        {   name            => 'Guest',
            nickname        => 'Guest',
            basename        => 'guest',
            email           => 'guest@localhost',
            url             => 'http://localhost/~guest/',
            password        => 'guest',
            type            => MT::Author::AUTHOR(),
            locked_out_time => 0,
        }
    );
    $guest->save or die $guest->errstr;

    {
        # Parent website
        my $w = $mt->model('website')->load($blog_id);
        $w->set_values(
            {   description => 'This is a first website.',
                site_url    => 'http://localhost/first_website/',
                site_path   => '/var/www/html/first_website',
            }
        );
        $w->save or die $w->errstr;

        # apply theme
        my $test_app = MT::Test::App->new('CMS');
        $test_app->login($admin);
        $test_app->post({
            __mode   => 'apply_theme',
            blog_id  => $w->id,
            theme_id => 'classic_test_website',
        });

        # Create categories
        my $cat1 = MT::Category->new;
        $cat1->set_values(
            {   blog_id     => $blog_id,
                label       => 'Website Category 1',
                basename    => 'website_category_1',
                description => 'This is a website category 1.',
                allow_pings => 1,
            }
        );
        $cat1->save or die $cat1->errstr;

        my $cat_tmpl
            = MT::Template->load(
            { blog_id => $blog_id, identifier => 'category_entry_listing' } );

        my $tm_cat = MT::TemplateMap->new;
        $tm_cat->set_values(
            {   archive_type => 'Category',
                blog_id      => $blog_id,
                build_type   => MT::PublishOption::DYNAMIC(),
                is_preferred => 1,
                template_id  => $cat_tmpl->id,
            }
        );
        $tm_cat->save or die $tm_cat->errstr;

        my $fi_cat1 = MT::FileInfo->new;
        $fi_cat1->set_values(
            {   archive_type => 'Category',
                blog_id      => $blog_id,
                category_id  => $cat1->id,
                filepath =>
                    '/var/www/html/first_website/website_category_1/index.html',
                template_id    => $cat_tmpl->id,
                templatemap_id => $tm_cat->id,
                url            => '/first_website/website-category-1/index.html',
            }
        );
        $fi_cat1->save or die $fi_cat1->errstr;

        my $cat2 = MT::Category->new;
        $cat2->set_values(
            {   blog_id     => $blog_id,
                label       => 'Website Subcategory 2',
                basename    => 'website_subcategory_2',
                description => 'This is a website subcategory 2.',
                parent      => $cat1->id,
            }
        );
        $cat2->save or die $cat2->errstr;

        my $fi_cat2 = MT::FileInfo->new;
        $fi_cat2->set_values(
            {   archive_type => 'Category',
                blog_id      => $blog_id,
                category_id  => $cat2->id,
                filepath =>
                    '/var/www/html/first_website/website_category_1/website_subcategory_2/index.html',
                template_id    => $cat_tmpl->id,
                templatemap_id => $tm_cat->id,
                url =>
                    '/first_website/website-category-1/website-subcategory-2/index.html',
            }
        );
        $fi_cat2->save or die $fi_cat2->errstr;

        my $cat3 = MT::Category->new;
        $cat3->set_values(
            {   blog_id     => $blog_id,
                label       => 'Website Category 3',
                basename    => 'website_category_3',
                description => 'This is a website category 3.',
            }
        );
        $cat3->save or die $cat3->errstr;

        my $fi_cat3 = MT::FileInfo->new;
        $fi_cat3->set_values(
            {   archive_type => 'Category',
                blog_id      => $blog_id,
                category_id  => $cat3->id,
                filepath =>
                    '/var/www/html/first_website/website_category_3/index.html',
                template_id    => $cat_tmpl->id,
                templatemap_id => $tm_cat->id,
                url            => '/first_website/website-category-3/index.html',
            }
        );
        $fi_cat3->save or die $fi_cat3->errstr;

        my $cat4 = MT::Category->new;
        $cat4->set_values(
            {   blog_id     => $blog_id,
                label       => 'Website Category 4',
                basename    => 'website_category_4',
                description => 'This is a website category 4.',
            }
        );
        $cat4->save or die $cat4->errstr;

        my $fi_cat4 = MT::FileInfo->new;
        $fi_cat4->set_values(
            {   archive_type => 'Category',
                blog_id      => $blog_id,
                category_id  => $cat4->id,
                filepath =>
                    '/var/www/html/first_website/website_category_4/index.html',
                template_id    => $cat_tmpl->id,
                templatemap_id => $tm_cat->id,
                url            => '/first_website/website-category-4/index.html',
            }
        );
        $fi_cat4->save or die $fi_cat4->errstr;

        my $cat5 = MT::Category->new;
        $cat5->set_values(
            {   blog_id     => $blog_id,
                label       => 'Website Subsubcategory 5',
                basename    => 'website_subsubcategory_5',
                description => 'This is a website subsubcategory 5.',
                parent      => $cat2->id,
            }
        );
        $cat5->save or die $cat5->errstr;

        my $fi_cat5 = MT::FileInfo->new;
        $fi_cat5->set_values(
            {   archive_type => 'Category',
                blog_id      => $blog_id,
                category_id  => $cat5->id,
                filepath =>
                    '/var/www/html/first_website/website_category_1/website_subcategory_2/website_subsubcategory_5/index.html',
                template_id    => $cat_tmpl->id,
                templatemap_id => $tm_cat->id,
                url =>
                    '/first_website/website-category-1/website-subcategory-2/website-subsubcategory-5/index.html',
            }
        );
        $fi_cat5->save or die $fi_cat5->errstr;

        my $cat6 = MT::Category->new;
        $cat6->set_values(
            {   blog_id     => $blog_id,
                label       => 'Website Subsubcategory 6',
                basename    => 'website_subsubcategory_6',
                description => 'This is a website subsubcategory 6.',
                parent      => $cat2->id,
            }
        );
        $cat6->save or die $cat6->errstr;

        my $fi_cat6 = MT::FileInfo->new;
        $fi_cat6->set_values(
            {   archive_type => 'Category',
                blog_id      => $blog_id,
                category_id  => $cat6->id,
                filepath =>
                    '/var/www/html/first_website/website_category_1/website_subcategory_2/website_subsubcategory_6/index.html',
                template_id    => $cat_tmpl->id,
                templatemap_id => $tm_cat->id,
                url =>
                    '/first_website/website-category-1/website-subcategory-2/website-subsubcategory-6/index.html',
            }
        );
        $fi_cat6->save or die $fi_cat6->errstr;

        # Create entries
        my $e1 = $mt->model('entry')->new;
        $e1->set_values(
            {   blog_id     => $blog_id,
                author_id   => $admin->id,
                status      => MT::Entry::RELEASE(),
                title       => 'Website Entry 1',
                basename    => 'website_entry_1',
                text        => 'This is website entry 1.',
                text_more   => 'Both allow_pings and allow_comments are null.',
                excerpt     => 'Website Entry Excerpt 1',
                keywords    => 'Foo',
                authored_on => '20110101000000',
                modified_on => '20110101000000',
                created_on  => '20110101000000',
            }
        );
        $e1->save or die $e1->errstr;

        my $tmpl
            = MT::Template->load( { blog_id => $blog_id, type => 'individual' } );

        my $tm = MT::TemplateMap->new;
        $tm->set_values(
            {   archive_type => 'Individual',
                blog_id      => $blog_id,
                build_type   => MT::PublishOption::DYNAMIC(),
                is_preferred => 1,
                template_id  => $tmpl->id,
            }
        );
        $tm->save or die $tm->errstr;

        my $fi1 = MT::FileInfo->new;
        $fi1->set_values(
            {   archive_type => 'Individual',
                blog_id      => $blog_id,
                entry_id     => $e1->id,
                file_path =>
                    '/var/www/html/first_website/2011/01/website-entry-1.html',
                template_id    => $tmpl->id,
                templatemap_id => $tm->id,
                url            => '/first_website/2011/01/website-entry-1.html',
                virtual        => 1,
            }
        );
        $fi1->save or die $fi1->errstr;

        # Set categories
        my $pl1 = MT::Placement->new;
        $pl1->set_values(
            {   blog_id     => $blog_id,
                category_id => $cat1->id,
                entry_id    => $e1->id,
                is_primary  => 1,
            }
        );
        $pl1->save or die $pl1->errstr;

        my $pl4 = MT::Placement->new;
        $pl4->set_values(
            {   blog_id     => $blog_id,
                category_id => $cat4->id,
                entry_id    => $e1->id,
                is_primary  => 0,
            }
        );
        $pl4->save or die $pl4->errstr;

        # Create tag
        my $tag1 = $mt->model('tag')->new;
        $tag1->set_values( { name => 'Website Tag 1', } );
        $tag1->save or die $tag1->errstr;

        my $objtag1 = $mt->model('objecttag')->new;
        $objtag1->set_values(
            {   blog_id           => $blog_id,
                object_datasource => 'entry',
                object_id         => $e1->id,
                tag_id            => $tag1->id,
            }
        );
        $objtag1->save or die $objtag1->errstr;

        # Create score
        my $objscore1 = $mt->model('objectscore')->new;
        $objscore1->set_values(
            {   author_id => $admin->id,
                namespace => 'test_namespace',
                object_ds => 'entry',
                object_id => $e1->id,
                score     => 2,
            }
        );
        $objscore1->save or die $objscore1->errstr;

        my $objscore2 = $mt->model('objectscore')->new;
        $objscore2->set_values(
            {   author_id => $guest->id,
                namespace => 'test_namespace',
                object_ds => 'entry',
                object_id => $e1->id,
                score     => 4,
            }
        );
        $objscore2->save or die $objscore2->errstr;

        # allow_pings is set 1.
        my $e2 = $mt->model('entry')->new;
        $e2->set_values(
            {   blog_id     => $blog_id,
                author_id   => $admin->id,
                status      => MT::Entry::RELEASE(),
                title       => 'Website Entry 2',
                basename    => 'website_entry_2',
                text        => 'This is website entry 2.',
                text_more   => 'Allow_pings is 1, allow_comments is null.',
                excerpt     => 'Website Entry Excerpt 2',
                allow_pings => 1,
                authored_on => '20120202000000',
                modified_on => '20120202000000',
                created_on  => '20120202000000',
            }
        );
        $e2->save or die $e2->errstr;

        my $fi2 = MT::FileInfo->new;
        $fi2->set_values(
            {   archive_type => 'Individual',
                blog_id      => $blog_id,
                entry_id     => $e2->id,
                file_path =>
                    '/var/www/html/first_website/2012/02/website-entry-2.html',
                template_id    => $tmpl->id,
                templatemap_id => $tm->id,
                url            => '/first_website/2012/02/website-entry-2.html',
                virtual        => 1,
            }
        );
        $fi2->save or die $fi2->errstr;

        my $pl2 = MT::Placement->new;
        $pl2->set_values(
            {   blog_id     => $blog_id,
                category_id => $cat2->id,
                entry_id    => $e2->id,
                is_primary  => 1,
            }
        );
        $pl2->save or die $pl2->errstr;

        # allow_comments is set 1.
        my $e3 = $mt->model('entry')->new;
        $e3->set_values(
            {   blog_id        => $blog_id,
                author_id      => $admin->id,
                status         => MT::Entry::RELEASE(),
                title          => 'Website Entry 3',
                basename       => 'website_entry_3',
                text           => 'This is website entry 3.',
                text_more      => 'Allow_pings is null, allow_comments is 1.',
                excerpt        => 'Website Entry Excerpt 3',
                allow_comments => 1,
                keywords       => 'Bar',
                authored_on    => '20130303000000',
                modified_on    => '20130303000000',
                created_on     => '20130303000000',
            }
        );
        $e3->save or die $e3->errstr;

        my $fi3 = MT::FileInfo->new;
        $fi3->set_values(
            {   archive_type => 'Individual',
                blog_id      => $blog_id,
                entry_id     => $e3->id,
                file_path =>
                    '/var/www/html/first_website/2013/03/website-entry-3.html',
                template_id    => $tmpl->id,
                templatemap_id => $tm->id,
                url            => '/first_website/2013/03/website-entry-3.html',
                virtual        => 1,
            }
        );
        $fi3->save or die $fi3->errstr;

        my $pl3 = MT::Placement->new;
        $pl3->set_values(
            {   blog_id     => $blog_id,
                category_id => $cat3->id,
                entry_id    => $e3->id,
                is_primary  => 1,
            }
        );
        $pl3->save or die $pl3->errstr;

        # status is set 1 (HOLD).
        my $e4 = $mt->model('entry')->new;
        $e4->set_values(
            {   blog_id     => $blog_id,
                author_id   => $admin->id,
                status      => MT::Entry::HOLD(),
                title       => 'Website Entry 4',
                text        => 'This is website entry 4.',
                authored_on => '20140404000000',
            }
        );
        $e4->save or die $e4->errstr;

        my $fi4 = MT::FileInfo->new;
        $fi4->set_values(
            {   archive_type => 'Individual',
                blog_id      => $blog_id,
                entry_id     => $e4->id,
                file_path =>
                    '/var/www/html/first_website/2014/04/website-entry-4.html',
                template_id    => $tmpl->id,
                templatemap_id => $tm->id,
                url            => '/first_website/2014/04/website-entry-4.html',
                virtual        => 1,
            }
        );
        $fi4->save or die $fi4->errstr;

        my $e5 = $mt->model('entry')->new;
        $e5->set_values(
            {   blog_id     => $blog_id,
                author_id   => $admin->id,
                status      => MT::Entry::RELEASE(),
                title       => 'Website Entry 5',
                text        => 'This is website entry 5.',
                authored_on => '20150505000000',
                modified_on => '20150505000000',
                created_on  => '20150505000000',
            }
        );
        $e5->save or die $e5->errstr;

        my $fi5 = MT::FileInfo->new;
        $fi5->set_values(
            {   archive_type => 'Individual',
                blog_id      => $blog_id,
                entry_id     => $e5->id,
                file_path =>
                    '/var/www/html/first_website/2015/05/website-entry-5.html',
                template_id    => $tmpl->id,
                templatemap_id => $tm->id,
                url            => '/first_website/2015/05/website-entry-5.html',
                virtual        => 1,
            }
        );
        $fi5->save or die $fi5->errstr;

        my $pl5 = MT::Placement->new;
        $pl5->set_values(
            {   blog_id     => $blog_id,
                category_id => $cat5->id,
                entry_id    => $e5->id,
                is_primary  => 1,
            }
        );
        $pl5->save or die $pl5->errstr;

        my $e6 = $mt->model('entry')->new;
        $e6->set_values(
            {   blog_id     => $blog_id,
                author_id   => $admin->id,
                status      => MT::Entry::RELEASE(),
                title       => 'Website Entry 6',
                text        => 'This is website entry 6.',
                authored_on => '20160606000000',
                modified_on => '20160606000000',
                created_on  => '20160606000000',
            }
        );
        $e6->save or die $e6->errstr;

        my $fi6 = MT::FileInfo->new;
        $fi6->set_values(
            {   archive_type => 'Individual',
                blog_id      => $blog_id,
                entry_id     => $e6->id,
                file_path =>
                    '/var/www/html/first_website/2016/06/website-entry-6.html',
                template_id    => $tmpl->id,
                templatemap_id => $tm->id,
                url            => '/first_website/2016/06/website-entry-6.html',
                virtual        => 1,
            }
        );
        $fi6->save or die $fi6->errstr;

        my $pl6 = MT::Placement->new;
        $pl6->set_values(
            {   blog_id     => $blog_id,
                category_id => $cat6->id,
                entry_id    => $e6->id,
                is_primary  => 1,
            }
        );
        $pl6->save or die $pl6->errstr;

        my $e7 = $mt->model('entry')->new;
        $e7->set_values(
            {   blog_id     => $blog_id,
                author_id   => $admin->id,
                status      => MT::Entry::RELEASE(),
                title       => 'Website Entry 7',
                text        => 'This is website entry 7.',
                authored_on => '20160606010000',
                modified_on => '20160606010000',
                created_on  => '20160606010000',
            }
        );
        $e7->save or die $e7->errstr;

        my $fi7 = MT::FileInfo->new;
        $fi7->set_values(
            {   archive_type => 'Individual',
                blog_id      => $blog_id,
                entry_id     => $e7->id,
                file_path =>
                    '/var/www/html/first_website/2016/06/website-entry-7.html',
                template_id    => $tmpl->id,
                templatemap_id => $tm->id,
                url            => '/first_website/2016/06/website-entry-7.html',
                virtual        => 1,
            }
        );
        $fi7->save or die $fi7->errstr;

        # Create comment
        my $c1 = $mt->model('comment')->new;
        $c1->set_values(
            {   blog_id       => $blog_id,
                entry_id      => $e1->id,
                commenter_id  => $admin->id,
                author        => $admin->nickname,
                email         => $admin->email,
                url           => $admin->url,
                last_moved_on => '20101010000000',
                visible       => 1,
                junk_status   => 1,                  # NOT_JUNK
                ip            => '127.0.0.1',
                text          => 'Comment 1',
                created_on    => '20101010000000',
                modified_on   => '20101010000000',
            }
        );
        $c1->save or die $c1->errstr;

        my $c2 = $mt->model('comment')->new;
        $c2->set_values(
            {   blog_id       => $blog_id,
                entry_id      => $e1->id,
                commenter_id  => $guest->id,
                author        => $guest->nickname,
                email         => $guest->email,
                url           => $guest->url,
                parent_id     => $c1->id,
                last_moved_on => '20111111000000',
                visible       => 1,
                junk_status   => 1,                  # NOT_JUNK
                ip            => '192.168.0.1',
                text          => 'Comment 2',
                created_on    => '20111111000000',
                modified_on   => '20111111000000',
            }
        );
        $c2->save or die $c2->errstr;

        my $c3 = $mt->model('comment')->new;
        $c3->set_values(
            {   blog_id       => $blog_id,
                entry_id      => $e1->id,
                commenter_id  => $admin->id,
                author        => $admin->nickname,
                email         => $admin->email,
                url           => $admin->url,
                parent_id     => $c2->id,
                last_moved_on => '20121212000000',
                visible       => 1,
                junk_status   => 1,                  # NOT_JUNK
                ip            => '127.0.0.1',
                text          => 'Comment 3',
                created_on    => '20121212000000',
                modified_on   => '20121212000000',
            }
        );
        $c3->save or die $c3->errstr;

        # Create comment score
        my $objscore3 = $mt->model('objectscore')->new;
        $objscore3->set_values(
            {   author_id => $admin->id,
                namespace => 'test_namespace',
                object_ds => 'comment',
                object_id => $c1->id,
                score     => 1,
            }
        );
        $objscore3->save or die $objscore3->errstr;

        my $objscore4 = $mt->model('objectscore')->new;
        $objscore4->set_values(
            {   author_id => $admin->id,
                namespace => 'test_namespace',
                object_ds => 'comment',
                object_id => $c1->id,
                score     => 3,
            }
        );
        $objscore4->save or die $objscore4->errstr;

        # Create asset
        my $as1 = $mt->model('asset')->new;
        $as1->set_values(
            {   blog_id => $blog_id,
                label   => 'Website Asset 1',
            }
        );
        $as1->save or die $as1->errstr;

        my $objas1 = $mt->model('objectasset')->new;
        $objas1->set_values(
            {   asset_id  => $as1->id,
                blog_id   => $blog_id,
                object_ds => 'entry',
                object_id => $e1->id,
            }
        );
        $objas1->save or die $objas1->errstr;

        # Create template maps for archive
        my $tm_mo = $mt->model('templatemap')->load(
            {   blog_id      => $blog_id,
                archive_type => 'Monthly',
            }
        );

        my %suite = (
            Daily => [
                {   file_path =>
                        '/var/www/html/first_website/2011/01/01/index.html',
                    startdate => '20110101000000',
                    url       => '/first_website/2011/01/01/index.html',
                },
                {   file_path =>
                        '/var/www/html/first_website/2011/02/02/index.html',
                    startdate => '20120202000000',
                    url       => '/first_website/2012/02/02/index.html',
                },
                {   file_path =>
                        '/var/www/html/first_website/2013/03/03/index.html',
                    startdate => '20130303000000',
                    url       => '/first_website/2013/03/03/index.html',
                },
                {   file_path =>
                        '/var/www/html/first_website/2015/05/05/index.html',
                    startdate => '20150505000000',
                    url       => '/first_website/2015/05/05/index.html',
                },
                {   file_path =>
                        '/var/www/html/first_website/2016/06/06/index.html',
                    startdate => '20160606000000',
                    url       => '/first_website/2016/06/06/index.html',
                },
            ],
            Weekly => [
                {   file_path =>
                        '/var/www/html/first_website/2010/12/26-week/index.html',
                    startdate => '20101226000000',
                    url       => '/first_website/2010/12/26-week/index.html',
                },
                {   file_path =>
                        '/var/www/html/first_website/2012/01/29-week/index.html',
                    startdate => '20120129000000',
                    url       => '/first_website/2012/01/29-week/index.html',
                },
                {   file_path =>
                        '/var/www/html/first_website/2013/03/03-week/index.html',
                    startdate => '20130303000000',
                    url       => '/first_website/2013/03/03-week/index.html',
                },
                {   file_path =>
                        '/var/www/html/first_website/2015/05/03-week/index.html',
                    startdate => '20150503000000',
                    url       => '/first_website/2015/05/03-week/index.html',
                },
                {   file_path =>
                        '/var/www/html/first_website/2016/06/05-week/index.html',
                    startdate => '20160605000000',
                    url       => '/first_website/2016/06/05-week/index.html',
                },
            ],
            Monthly => [
                {   file_path => '/var/www/html/first_website/2011/01/index.html',
                    startdate => '20110101000000',
                    url       => '/first_website/2011/01/index.html',
                },
                {   file_path => '/var/www/html/first_website/2012/02/index.html',
                    startdate => '20120201000000',
                    url       => '/first_website/2012/02/index.html',
                },
                {   file_path => '/var/www/html/first_website/2013/03/index.html',
                    startdate => '20130301000000',
                    url       => '/first_website/2013/03/index.html',
                },
                {   file_path => '/var/www/html/first_website/2015/05/index.html',
                    startdate => '20150501000000',
                    url       => '/first_website/2015/05/index.html',
                },
                {   file_path => '/var/www/html/first_website/2016/06/index.html',
                    startdate => '20160601000000',
                    url       => '/first_website/2016/06/index.html',
                },
            ],
            Yearly => [
                {   file_path => '/var/www/html/first_website/2011/index.html',
                    startdate => '20110101000000',
                    url       => '/first_website/2011/index.html',
                },
                {   file_path => '/var/www/html/first_website/2012/index.html',
                    startdate => '20120101000000',
                    url       => '/first_website/2012/index.html',
                },
                {   file_path => '/var/www/html/first_website/2013/index.html',
                    startdate => '20130101000000',
                    url       => '/first_website/2013/index.html',
                },
                {   file_path => '/var/www/html/first_website/2015/index.html',
                    startdate => '20150101000000',
                    url       => '/first_website/2015/index.html',
                },
                {   file_path => '/var/www/html/first_websiete/2016/index.html',
                    startdate => '20160101000000',
                    url       => '/first_website/2016/index.html'
                },
            ],
            Author => [
                {   file_path =>
                        '/var/www/html/first_website/author/melody/index.html',
                    url       => '/first_website/author/melody/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/guest/index.html',
                    url       => '/first_website/author/guest/index.html',
                    author_id => 2,
                },
            ],
            'Author-Daily' => [
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2011/01/01/index.html',
                    startdate => '20110101000000',
                    url => '/first_website/author/melody/2011/01/01/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2012/02/02/index.html',
                    startdate => '20120202000000',
                    url => '/first_website/author/melody/2012/02/02/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2013/03/03/index.html',
                    startdate => '20130303000000',
                    url => '/first_website/author/melody/2013/03/03/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2015/05/05/index.html',
                    startdate => '20150505000000',
                    url => '/first_website/author/melody/2015/05/05/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2016/06/06/index.html',
                    startdate => '20160606000000',
                    url => '/first_website/author/melody/2016/06/06/index.html',
                    author_id => 1,
                },
            ],
            'Author-Weekly' => [
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2010/12/26-week/index.html',
                    startdate => '20101226000000',
                    url =>
                        '/first_website/author/melody/2010/12/26-week/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2012/01/29-week/index.html',
                    startdate => '20120129000000',
                    url =>
                        '/first_website/author/melody/2012/01/29-week/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2013/03/03-week/index.html',
                    startdate => '20130303000000',
                    url =>
                        '/first_website/author/melody/2013/03/03-week/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2015/05/03-week/index.html',
                    startdate => '20150503000000',
                    url =>
                        '/first_website/author/melody/2015/05/03-week/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2016/06/05-week/index.html',
                    startdate => '20160605000000',
                    url =>
                        '/first_website/author/melody/2016/06/05-week/index.html',
                    author_id => 1,
                },
            ],
            'Author-Monthly' => [
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2011/01/index.html',
                    startdate => '20110101000000',
                    url => '/first_website/author/melody/2011/01/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2012/02/index.html',
                    startdate => '20120201000000',
                    url => '/first_website/author/melody/2012/02/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2013/03/index.html',
                    startdate => '20130301000000',
                    url => '/first_website/author/melody/2013/03/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2015/05/index.html',
                    startdate => '20150501000000',
                    url => '/first_website/author/melody/2015/05/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2016/06/index.html',
                    startdate => '20160601000000',
                    url => '/first_website/author/melody/2016/06/index.html',
                    author_id => 1,
                },
            ],
            'Author-Yearly' => [
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2011/index.html',
                    startdate => '20110101000000',
                    url       => '/first_website/author/melody/2011/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2012/index.html',
                    startdate => '20120101000000',
                    url       => '/first_website/author/melody/2012/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2013/index.html',
                    startdate => '20130101000000',
                    url       => '/first_website/author/melody/2013/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2015/index.html',
                    startdate => '20150101000000',
                    url       => '/first_website/author/melody/2015/index.html',
                    author_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/author/melody/2016/index.html',
                    startdate => '20160101000000',
                    url       => '/first_website/author/melody/2016/index.html',
                    author_id => 1,
                },
            ],
            'Category-Daily' => [
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/2011/01/01/index.html',
                    startdate => '20110101000000',
                    url =>
                        '/first_website/website-category-1/2011/01/01/index.html',
                    category_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/website-subcategory-2/2012/02/02/index.html',
                    startdate => '20120202000000',
                    url =>
                        '/first_website/website-category-1/website-subcategory-2/2012/02/02/index.html',
                    category_id => 2,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-3/2013/03/03/index.html',
                    startdate => '20130303000000',
                    url =>
                        '/first_website/website-category-3/2013/03/03/index.html',
                    category_id => 3,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/website-subcategory-2/website-subsubcategory-5/2015/05/05/index.html',
                    startdate => '20150505000000',
                    url =>
                        '/first_website/website-category-1/website-subcategory-2/website-subsubcategory-5/2015/05/05/index.html',
                    category_id => 5,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/website-subcategory-2/website-subsubcategory-6/2016/06/06/index.html',
                    startdate => '20160606000000',
                    url =>
                        '/first_website/website-category-1/website-subcategory-2/website-subsubcategory-6/2016/06/06/index.html',
                    category_id => 6,
                },
            ],
            'Category-Weekly' => [
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/2010/12/26-week/index.html',
                    startdate => '20101226000000',
                    url =>
                        '/first_website/website-category-1/2010/12/26-week/index.html',
                    category_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/website-subcategory-2/2012/01/29-week/index.html',
                    startdate => '20120129000000',
                    url =>
                        '/first_website/website-category-1/website-subcategory-2/2012/01/29-week/index.html',
                    category_id => 2,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-3/2013/03/03-week/index.html',
                    startdate => '20130303000000',
                    url =>
                        '/first_website/website-category-3/2013/03/03-week/index.html',
                    category_id => 3,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/website-subcategory-2/website-subsubcategory-5/2015/05/03-week/index.html',
                    startdate => '20150503000000',
                    url =>
                        '/first_website/website-category-1/website-subcategory-2/website-subsubcategory-5/2015/05/03-week/index.html',
                    category_id => 5,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/website-subcategory-2/website-subsubcategory-6/2016/06/05-week/index.html',
                    startdate => '20160605000000',
                    url =>
                        '/first_website/website-category-1/website-subcategory-2/website-subsubcategory-6/2016/06/05-week/index.html',
                    category_id => 6,
                },
            ],
            'Category-Monthly' => [
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/2011/01/index.html',
                    startdate => '20110101000000',
                    url => '/first_website/website-category-1/2011/01/index.html',
                    category_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/website-subcategory-2/2012/02/index.html',
                    startdate => '20120201000000',
                    url =>
                        '/first_website/website-category-1/website-subcategory-2/2012/02/index.html',
                    category_id => 2,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-3/2013/03/index.html',
                    startdate => '20130301000000',
                    url => '/first_website/website-category-3/2013/03/index.html',
                    category_id => 3,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/website-subcategory-2/website-subsubcategory-5/2015/05/index.html',
                    startdate => '20150501000000',
                    url =>
                        '/first_website/website-category-1/website-subcategory-2/website-subsubcategory-5/2015/05/index.html',
                    category_id => 5,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/website-subcategory-2/website-subsubcategory-6/2016/06/index.html',
                    startdate => '20160601000000',
                    url =>
                        '/first_website/website-category-1/website-subcategory-2/website-subsubcategory-6/2016/06/index.html',
                    category_id => 6,
                },
            ],
            'Category-Yearly' => [
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/2011/index.html',
                    startdate => '20110101000000',
                    url => '/first_website/website-category-1/2011/index.html',
                    category_id => 1,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/website-subcategory-2/2012/index.html',
                    startdate => '20120101000000',
                    url =>
                        '/first_website/website-category-1/website-subcategory-2/2012/index.html',
                    category_id => 2,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-3/2013/index.html',
                    startdate => '20130101000000',
                    url => '/first_website/website-category-3/2013/index.html',
                    category_id => 3,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/website-subcategory-2/website-subsubcategory-5/2015/index.html',
                    startdate => '20150101000000',
                    url =>
                        '/first_website/website-category-1/website-subcategory-2/website-subsubcategory-5/2015/index.html',
                    category_id => 5,
                },
                {   file_path =>
                        '/var/www/html/first_website/website-category-1/website-subcategory-2/website-subsubcategory-6/2016/index.html',
                    startdate => '20160101000000',
                    url =>
                        '/first_website/website-category-1/website-subcategory-2/website-subsubcategory-6/2016/index.html',
                    category_id => 6,
                },
            ],
        );

        foreach my $key ( sort keys %suite ) {
            my $templatemap;
            if ( $key eq 'Monthly' ) {
                $templatemap = $tm_mo;
            }
            else {
                $templatemap = $mt->model('templatemap')->new;
                $templatemap->set_values(
                    {   archive_type => $key,
                        blog_id      => $blog_id,
                        build_type   => MT::PublishOption::DYNAMIC(),
                        is_preferred => 1,
                        template_id  => $tm_mo->template_id,
                    }
                );
                $templatemap->save or die $templatemap->errstr;
            }

            foreach my $data ( @{ $suite{$key} } ) {
                my $fi = $mt->model('fileinfo')->new;
                $fi->set_values(
                    {   archive_type   => $key,
                        blog_id        => $blog_id,
                        template_id    => $templatemap->template_id,
                        templatemap_id => $templatemap->id,
                        virtual        => 1,
                    }
                );
                foreach my $col ( keys %$data ) {
                    $fi->$col( $data->{$col} );
                }
                $fi->save or die $fi->errstr;
            }
        }
    }

    {
        # Child blog
        my $b = $mt->model('blog')->new;
        $b->set_values(
            {   author_id => $admin->id,
                parent_id => $blog_id,
                name      => 'First Blog',
            }
        );
        $b->save or die $b->errstr;

        my $e1 = $mt->model('entry')->new;
        $e1->set_values(
            {   blog_id   => $b->id,
                author_id => $admin->id,
                status    => MT::Entry::RELEASE(),
                title     => 'Blog Entry 1',
            }
        );
        $e1->save or die $e1->errstr;
    }
});

MT->request->reset;

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

sub _mt_websites {
    $_ = '<mt:Websites site_ids="'
       . $blog_id . '">'
       . $_
       . '</mt:Websites>';
}

__END__

=== mt:BlogID
--- template _mt_websites
<mt:BlogID>
--- expected
1

=== mt:BlogName
--- template _mt_websites
<mt:BlogName>
--- expected
First Website

=== mt:BlogDescription
--- template _mt_websites
<mt:BlogDescription>
--- expected
This is a first website.

=== mt:BlogLanguage
--- template _mt_websites
<mt:BlogLanguage>
--- expected
en_US

=== mt:BlogURL
--- template _mt_websites
<mt:BlogURL>
--- expected
http://localhost/first_website/

=== mt:BlogArchiveURL
--- template _mt_websites
<mt:BlogArchiveURL>
--- expected
http://localhost/first_website/

=== mt:BlogRelativeURL
--- template _mt_websites
<mt:BlogRelativeURL>
--- expected
/first_website/

=== mt:BlogSitePath
--- template _mt_websites
<mt:BlogSitePath>
--- expected
/var/www/html/first_website/

=== mt:BlogHost
--- template _mt_websites
<mt:BlogHost>
--- expected
localhost

=== mt:BlogTimezone
--- template _mt_websites
<mt:BlogTimezone>
--- expected
+00:00

=== mt:BlogFileExtension
--- template _mt_websites
<mt:BlogFileExtension>
--- expected
.html

=== mt:BlogTemplateSetID
--- template _mt_websites
<mt:BlogTemplateSetID>
--- expected
classic-test-website

=== mt:BlogThemeID
--- template _mt_websites
<mt:BlogThemeID>
--- expected
classic-test-website

=== mt:EntriesHeader, mt:EntriesFooter
--- template _mt_websites
<mt:Entries><mt:EntriesHeader>EntriesHeader
</mt:EntriesHeader><mt:EntryTitle><mt:EntriesFooter>
EntriesFooter</mt:EntriesFooter>
</mt:Entries>
--- expected
EntriesHeader
Website Entry 7
Website Entry 6
Website Entry 5
Website Entry 3
Website Entry 2
Website Entry 1
EntriesFooter

=== mt:EntryPrevious
--- template _mt_websites
<mt:Entries><mt:EntryPrevious><mt:EntryBody>
</mt:EntryPrevious></mt:Entries>
--- expected
This is website entry 6.
This is website entry 5.
This is website entry 3.
This is website entry 2.
This is website entry 1.

=== mt:EntryNext
--- template _mt_websites
<mt:Entries><mt:EntryNext><mt:EntryBody>
</mt:EntryNext></mt:Entries>
--- expected
This is website entry 7.
This is website entry 6.
This is website entry 5.
This is website entry 3.
This is website entry 2.

=== mt:DateHeader
--- template _mt_websites
<mt:Entries><mt:DateHeader><mt:EntryDate format="%Y-%m-%d">
</mt:DateHeader><mt:EntryTitle><mt:DateFooter>
***</mt:DateFooter>
</mt:Entries>
--- expected
2016-06-06
Website Entry 7
Website Entry 6
***
2015-05-05
Website Entry 5
***
2013-03-03
Website Entry 3
***
2012-02-02
Website Entry 2
***
2011-01-01
Website Entry 1
***

=== mt:EntryIfExtended
--- template _mt_websites
<mt:Entries><mt:EntryIfExtended><mt:EntryMore>
</mt:EntryIfExtended></mt:Entries>
--- expected
Allow_pings is null, allow_comments is 1.
Allow_pings is 1, allow_comments is null.
Both allow_pings and allow_comments are null.

=== mt:AuthorHasEntry
--- template _mt_websites
<mt:Authors><mt:AuthorHasEntry><mt:AuthorName>
</mt:AuthorHasEntry></mt:Authors>
--- expected
Melody

=== mt:EntriesCount
--- template _mt_websites
<mt:EntriesCount>
--- expected
6

=== mt:Entries, mt:EntryID
--- template _mt_websites
<mt:Entries glue=" "><mt:EntryID></mt:Entries>
--- expected
7 6 5 3 2 1

=== mt:EntryTitle
--- template _mt_websites
<mt:Entries><mt:EntryTitle>
</mt:Entries>
--- expected
Website Entry 7
Website Entry 6
Website Entry 5
Website Entry 3
Website Entry 2
Website Entry 1

=== mt:EntryStatus
--- template _mt_websites
<mt:Entries glue=" "><mt:EntryStatus></mt:Entries>
--- expected
Publish Publish Publish Publish Publish Publish

=== mt:EntryFlag
--- template _mt_websites
<mt:Entries><mt:EntryFlag flag="allow_pings"> <mt:EntryFlag flag="allow_comments">
</mt:Entries>
--- expected
0 0
0 0
0 0
0 1
1 0
0 0

=== mt:EntryBody
--- template _mt_websites
<mt:Entries><mt:EntryBody>
</mt:Entries>
--- expected
This is website entry 7.
This is website entry 6.
This is website entry 5.
This is website entry 3.
This is website entry 2.
This is website entry 1.

=== mt:EntryMore
--- template _mt_websites
<mt:Entries><mt:EntryMore>
</mt:Entries>
--- expected
Allow_pings is null, allow_comments is 1.
Allow_pings is 1, allow_comments is null.
Both allow_pings and allow_comments are null.

=== mt:EntryExcerpt
--- template _mt_websites
<mt:Entries><mt:EntryExcerpt>
</mt:Entries>
--- expected
This is website entry 7....
This is website entry 6....
This is website entry 5....
Website Entry Excerpt 3
Website Entry Excerpt 2
Website Entry Excerpt 1

=== mt:EntryKeywords
--- template _mt_websites
<mt:Entries><mt:EntryKeywords> </mt:Entries>
--- expected
Bar  Foo

=== mt:EntryLink
--- template _mt_websites
<mt:Entries><mt:EntryLink>
</mt:Entries>
--- expected
http://localhost/first_website/2016/06/website-entry-7.html
http://localhost/first_website/2016/06/website-entry-6.html
http://localhost/first_website/2015/05/website-entry-5.html
http://localhost/first_website/2013/03/website-entry-3.html
http://localhost/first_website/2012/02/website-entry-2.html
http://localhost/first_website/2011/01/website-entry-1.html

=== mt:EntryBasename
--- template _mt_websites
<mt:Entries><mt:EntryBasename>
</mt:Entries>
--- expected
website_entry_7
website_entry_6
website_entry_5
website_entry_3
website_entry_2
website_entry_1

=== mt:EntryAtomID
--- template _mt_websites
<mt:Entries><mt:EntryAtomID>
</mt:Entries>
--- expected
tag:localhost,2016:/first_website//1.7
tag:localhost,2016:/first_website//1.6
tag:localhost,2015:/first_website//1.5
tag:localhost,2013:/first_website//1.3
tag:localhost,2012:/first_website//1.2
tag:localhost,2011:/first_website//1.1

=== mt:EntryPermalink
--- template _mt_websites
<mt:Entries><mt:EntryPermalink>
</mt:Entries>
--- expected
http://localhost/first_website/2016/06/website-entry-7.html
http://localhost/first_website/2016/06/website-entry-6.html
http://localhost/first_website/2015/05/website-entry-5.html
http://localhost/first_website/2013/03/website-entry-3.html
http://localhost/first_website/2012/02/website-entry-2.html
http://localhost/first_website/2011/01/website-entry-1.html

=== mt:EntryPermalink - Daily
--- template _mt_websites
<mt:Entries><mt:EntryPermalink archive_type="Daily">
</mt:Entries>
--- expected
http://localhost/first_website/2016/06/06/#000007
http://localhost/first_website/2016/06/06/#000006
http://localhost/first_website/2015/05/05/#000005
http://localhost/first_website/2013/03/03/#000003
http://localhost/first_website/2012/02/02/#000002
http://localhost/first_website/2011/01/01/#000001

=== mt:EntryPermalink - Weekly
--- template _mt_websites
<mt:Entries><mt:EntryPermalink archive_type="Weekly">
</mt:Entries>
--- expected
http://localhost/first_website/2016/06/05-week/#000007
http://localhost/first_website/2016/06/05-week/#000006
http://localhost/first_website/2015/05/03-week/#000005
http://localhost/first_website/2013/03/03-week/#000003
http://localhost/first_website/2012/01/29-week/#000002
http://localhost/first_website/2010/12/26-week/#000001

=== mt:EntryPermalink - Monthly
--- template _mt_websites
<mt:Entries><mt:EntryPermalink archive_type="Monthly">
</mt:Entries>
--- expected
http://localhost/first_website/2016/06/#000007
http://localhost/first_website/2016/06/#000006
http://localhost/first_website/2015/05/#000005
http://localhost/first_website/2013/03/#000003
http://localhost/first_website/2012/02/#000002
http://localhost/first_website/2011/01/#000001

=== mt:EntryPermalink - Yearly
--- template _mt_websites
<mt:Entries><mt:EntryPermalink archive_type="Yearly">
</mt:Entries>
--- expected
http://localhost/first_website/2016/#000007
http://localhost/first_website/2016/#000006
http://localhost/first_website/2015/#000005
http://localhost/first_website/2013/#000003
http://localhost/first_website/2012/#000002
http://localhost/first_website/2011/#000001

=== mt:EntryPermalink - Author
--- template _mt_websites
<mt:Entries><mt:EntryPermalink archive_type="Author">
</mt:Entries>
--- expected
http://localhost/first_website/author/melody/#000007
http://localhost/first_website/author/melody/#000006
http://localhost/first_website/author/melody/#000005
http://localhost/first_website/author/melody/#000003
http://localhost/first_website/author/melody/#000002
http://localhost/first_website/author/melody/#000001

=== mt:EntryPermalink - Author-Daily
--- template _mt_websites
<mt:Entries><mt:EntryPermalink archive_type="Author-Daily">
</mt:Entries>
--- expected
http://localhost/first_website/author/melody/2016/06/06/#000007
http://localhost/first_website/author/melody/2016/06/06/#000006
http://localhost/first_website/author/melody/2015/05/05/#000005
http://localhost/first_website/author/melody/2013/03/03/#000003
http://localhost/first_website/author/melody/2012/02/02/#000002
http://localhost/first_website/author/melody/2011/01/01/#000001

=== mt:EntryPermalink - Author-Weekly
--- template _mt_websites
<mt:Entries><mt:EntryPermalink archive_type="Author-Weekly">
</mt:Entries>
--- expected
http://localhost/first_website/author/melody/2016/06/05-week/#000007
http://localhost/first_website/author/melody/2016/06/05-week/#000006
http://localhost/first_website/author/melody/2015/05/03-week/#000005
http://localhost/first_website/author/melody/2013/03/03-week/#000003
http://localhost/first_website/author/melody/2012/01/29-week/#000002
http://localhost/first_website/author/melody/2010/12/26-week/#000001

=== mt:EntryPermalink - Author-Monthly
--- template _mt_websites
<mt:Entries><mt:EntryPermalink archive_type="Author-Monthly">
</mt:Entries>
--- expected
http://localhost/first_website/author/melody/2016/06/#000007
http://localhost/first_website/author/melody/2016/06/#000006
http://localhost/first_website/author/melody/2015/05/#000005
http://localhost/first_website/author/melody/2013/03/#000003
http://localhost/first_website/author/melody/2012/02/#000002
http://localhost/first_website/author/melody/2011/01/#000001

=== mt:EntryPermalink - Author-Yearly
--- template _mt_websites
<mt:Entries><mt:EntryPermalink archive_type="Author-Yearly">
</mt:Entries>
--- expected
http://localhost/first_website/author/melody/2016/#000007
http://localhost/first_website/author/melody/2016/#000006
http://localhost/first_website/author/melody/2015/#000005
http://localhost/first_website/author/melody/2013/#000003
http://localhost/first_website/author/melody/2012/#000002
http://localhost/first_website/author/melody/2011/#000001

=== mt:EntryPermalink - Category
--- template _mt_websites
<mt:Entries><mt:EntryIfCategory><mt:EntryPermalink archive_type="Category"></mt:EntryIfCategory>
</mt:Entries>
--- expected
http://localhost/first_website/website-category-1/website-subcategory-2/website-subsubcategory-6/#000006
http://localhost/first_website/website-category-1/website-subcategory-2/website-subsubcategory-5/#000005
http://localhost/first_website/website-category-3/#000003
http://localhost/first_website/website-category-1/website-subcategory-2/#000002
http://localhost/first_website/website-category-1/#000001

=== mt:EntryPermalink - Category-Daily
--- template _mt_websites
<mt:Entries><mt:EntryIfCategory><mt:EntryPermalink archive_type="Category-Daily"></mt:EntryIfCategory>
</mt:Entries>
--- expected
http://localhost/first_website/website-category-1/website-subcategory-2/website-subsubcategory-6/2016/06/06/#000006
http://localhost/first_website/website-category-1/website-subcategory-2/website-subsubcategory-5/2015/05/05/#000005
http://localhost/first_website/website-category-3/2013/03/03/#000003
http://localhost/first_website/website-category-1/website-subcategory-2/2012/02/02/#000002
http://localhost/first_website/website-category-1/2011/01/01/#000001

=== mt:EntryPermalink - Category-Weekly
--- template _mt_websites
<mt:Entries><mt:EntryIfCategory><mt:EntryPermalink archive_type="Category-Weekly"></mt:EntryIfCategory>
</mt:Entries>
--- expected
http://localhost/first_website/website-category-1/website-subcategory-2/website-subsubcategory-6/2016/06/05-week/#000006
http://localhost/first_website/website-category-1/website-subcategory-2/website-subsubcategory-5/2015/05/03-week/#000005
http://localhost/first_website/website-category-3/2013/03/03-week/#000003
http://localhost/first_website/website-category-1/website-subcategory-2/2012/01/29-week/#000002
http://localhost/first_website/website-category-1/2010/12/26-week/#000001

=== mt:EntryPermalink - Category-Monthly
--- template _mt_websites
<mt:Entries><mt:EntryIfCategory><mt:EntryPermalink archive_type="Category-Monthly"></mt:EntryIfCategory>
</mt:Entries>
--- expected
http://localhost/first_website/website-category-1/website-subcategory-2/website-subsubcategory-6/2016/06/#000006
http://localhost/first_website/website-category-1/website-subcategory-2/website-subsubcategory-5/2015/05/#000005
http://localhost/first_website/website-category-3/2013/03/#000003
http://localhost/first_website/website-category-1/website-subcategory-2/2012/02/#000002
http://localhost/first_website/website-category-1/2011/01/#000001

=== mt:EntryPermalink - Category-Yearly
--- template _mt_websites
<mt:Entries><mt:EntryIfCategory><mt:EntryPermalink archive_type="Category-Yearly"></mt:EntryIfCategory>
</mt:Entries>
--- expected
http://localhost/first_website/website-category-1/website-subcategory-2/website-subsubcategory-6/2016/#000006
http://localhost/first_website/website-category-1/website-subcategory-2/website-subsubcategory-5/2015/#000005
http://localhost/first_website/website-category-3/2013/#000003
http://localhost/first_website/website-category-1/website-subcategory-2/2012/#000002
http://localhost/first_website/website-category-1/2011/#000001

=== mt:EntryClass
--- template _mt_websites
<mt:Entries glue=" "><mt:EntryClass></mt:Entries>
--- expected
entry entry entry entry entry entry

=== mt:EntryClassLabel
--- template _mt_websites
<mt:Entries glue=" "><mt:EntryClassLabel></mt:Entries>
--- expected
Entry Entry Entry Entry Entry Entry

=== mt:EntryAuthor
--- template _mt_websites
<mt:Entries glue=" "><mt:EntryAuthor></mt:Entries>
--- expected
Melody Melody Melody Melody Melody Melody

=== mt:EntryAuthorDisplayName
--- template _mt_websites
<mt:Entries><mt:EntryAuthorDisplayName>
</mt:Entries>
--- expected
Administrator Melody
Administrator Melody
Administrator Melody
Administrator Melody
Administrator Melody
Administrator Melody

=== mt:EntryAuthorNickname
--- template _mt_websites
<mt:Entries><mt:EntryAuthorNickname>
</mt:Entries>
--- expected
Administrator Melody
Administrator Melody
Administrator Melody
Administrator Melody
Administrator Melody
Administrator Melody

=== mt:EntryAuthorUsername
--- template _mt_websites
<mt:Entries glue=" "><mt:EntryAuthorUsername></mt:Entries>
--- expected
Melody Melody Melody Melody Melody Melody

=== mt:EntryAuthorEmail
--- template _mt_websites
<mt:Entries><mt:EntryAuthorEmail>
</mt:Entries>
--- expected
melody@localhost
melody@localhost
melody@localhost
melody@localhost
melody@localhost
melody@localhost

=== mt:EntryAuthorURL
--- template _mt_websites
<mt:Entries><mt:EntryAuthorURL>
</mt:Entries>
--- expected
http://localhost/~melody/
http://localhost/~melody/
http://localhost/~melody/
http://localhost/~melody/
http://localhost/~melody/
http://localhost/~melody/

=== mt:EntryAuthorLink
--- template _mt_websites
<mt:Entries><mt:EntryAuthorLink>
</mt:Entries>
--- expected
<a href="http://localhost/~melody/">Administrator Melody</a>
<a href="http://localhost/~melody/">Administrator Melody</a>
<a href="http://localhost/~melody/">Administrator Melody</a>
<a href="http://localhost/~melody/">Administrator Melody</a>
<a href="http://localhost/~melody/">Administrator Melody</a>
<a href="http://localhost/~melody/">Administrator Melody</a>

=== mt:EntryAuthorID
--- template _mt_websites
<mt:Entries glue=" "><mt:EntryAuthorID></mt:Entries>
--- expected
1 1 1 1 1 1

=== mt:AuthorEntryCount
--- template _mt_websites
<mt:Entries glue=" "><mt:AuthorEntryCount></mt:Entries>
--- expected
6 6 6 6 6 6

=== mt:EntryDate
--- template _mt_websites
<mt:Entries><mt:EntryDate>
</mt:Entries>
--- expected
June  6, 2016  1:00 AM
June  6, 2016 12:00 AM
May  5, 2015 12:00 AM
March  3, 2013 12:00 AM
February  2, 2012 12:00 AM
January  1, 2011 12:00 AM

=== mt:EntryCreatedDate
--- template _mt_websites
<mt:Entries><mt:EntryCreatedDate>
</mt:Entries>
--- expected
June  6, 2016  1:00 AM
June  6, 2016 12:00 AM
May  5, 2015 12:00 AM
March  3, 2013 12:00 AM
February  2, 2012 12:00 AM
January  1, 2011 12:00 AM

=== mt:EntryModifiedDate
--- template _mt_websites
<mt:Entries><mt:EntryCreatedDate>
</mt:Entries>
--- expected
June  6, 2016  1:00 AM
June  6, 2016 12:00 AM
May  5, 2015 12:00 AM
March  3, 2013 12:00 AM
February  2, 2012 12:00 AM
January  1, 2011 12:00 AM

=== mt:EntryBlogID
--- template _mt_websites
<mt:Entries glue=" "><mt:EntryBlogID></mt:Entries>
--- expected
1 1 1 1 1 1

=== mt:EntryBlogName
--- template _mt_websites
<mt:Entries><mt:EntryBlogName>
</mt:Entries>
--- expected
First Website
First Website
First Website
First Website
First Website
First Website

=== mt:EntryBlogDescription
--- template _mt_websites
<mt:Entries><mt:EntryBlogDescription>
</mt:Entries>
--- expected
This is a first website.
This is a first website.
This is a first website.
This is a first website.
This is a first website.
This is a first website.

=== mt:EntryBlogURL
--- template _mt_websites
<mt:Entries><mt:EntryBlogURL>
</mt:Entries>
--- expected
http://localhost/first_website/
http://localhost/first_website/
http://localhost/first_website/
http://localhost/first_website/
http://localhost/first_website/
http://localhost/first_website/

=== mt:EntryEditLink
--- SKIP
--- template _mt_websites
<mt:Entries><mt:EntryEditLink>
</mt:Entries>
--- expected
[<a href="/cgi-bin/mt.cgi?__mode=view&_type=entry&blog_id=1&id=7">Edit</a>]
[<a href="/cgi-bin/mt.cgi?__mode=view&_type=entry&blog_id=1&id=6">Edit</a>]
[<a href="/cgi-bin/mt.cgi?__mode=view&_type=entry&blog_id=1&id=5">Edit</a>]
[<a href="/cgi-bin/mt.cgi?__mode=view&_type=entry&blog_id=1&id=3">Edit</a>]
[<a href="/cgi-bin/mt.cgi?__mode=view&_type=entry&blog_id=1&id=2">Edit</a>]
[<a href="/cgi-bin/mt.cgi?__mode=view&_type=entry&blog_id=1&id=1">Edit</a>]

=== mt:BlogEntryCount
--- template _mt_websites
<mt:BlogEntryCount>
--- expected
6

=== mt:Categories, mt:CategoryID
--- template _mt_websites
<mt:Categories glue=" "><mt:CategoryID></mt:Categories>
--- expected
1 3 4 2 5 6

=== mt:CategoryPrevious
--- template _mt_websites
<mt:Categories><mt:CategoryPrevious><mt:CategoryLabel>
</mt:CategoryPrevious></mt:Categories>
--- expected
Website Category 1
Website Category 3
Website Subsubcategory 5

=== mt:CategoryNext
--- template _mt_websites
<mt:Categories><mt:CategoryNext><mt:CategoryLabel>
</mt:CategoryNext></mt:Categories>
--- expected
Website Category 3
Website Category 4
Website Subsubcategory 6

=== mt:SubCategories
--- template _mt_websites
<mt:Categories><mt:SubCategories><mt:CategoryBasename>
</mt:SubCategories></mt:Categories>
--- expected
website_subcategory_2
website_subsubcategory_5
website_subsubcategory_6

=== mt:TopLevelCategories
--- template _mt_websites
<mt:TopLevelCategories><mt:CategoryDescription>
</mt:TopLevelCategories>
--- expected
This is a website category 1.
This is a website category 3.
This is a website category 4.

=== mt:ParentCategory
--- template _mt_websites
<mt:Categories><mt:SubCategories><mt:ParentCategory><mt:CategoryLabel>
</mt:ParentCategory></mt:SubCategories></mt:Categories>
--- expected
Website Category 1
Website Subcategory 2
Website Subcategory 2

=== mt:ParentCategories
--- template _mt_websites
<mt:Categories><mt:SubCategories><mt:ParentCategories glue=" "><mt:CategoryBasename></mt:ParentCategories>
</mt:SubCategories></mt:Categories>
--- expected
website_category_1 website_subcategory_2
website_category_1 website_subcategory_2 website_subsubcategory_5
website_category_1 website_subcategory_2 website_subsubcategory_6

=== mt:TopLevelParent
--- template _mt_websites
<mt:TopLevelCategories><mt:SubCategories><mt:TopLevelParent><mt:CategoryLabel>
</mt:TopLevelParent></mt:SubCategories></mt:TopLevelCategories>
--- expected
Website Category 1

=== mt:EntriesWithSubCategories
--- template _mt_websites
<mt:Entries category="Website Category 1"><mt:EntryCategories glue=" | "><mt:CategoryLabel></mt:EntryCategories>
</mt:Entries>
<mt:EntriesWithSubCategories category="Website Category 1"><mt:EntryCategories glue=" | "><mt:CategoryLabel></mt:EntryCategories>
</mt:EntriesWithSubCategories>
--- expected
Website Category 1 | Website Category 4

Website Subsubcategory 6
Website Subsubcategory 5
Website Subcategory 2
Website Category 1 | Website Category 4

=== mt:IfCategory
--- template _mt_websites
<mt:Categories><mt:IfCategory label="Website Subcategory 2"><mt:CategoryLabel></mt:IfCategory></mt:Categories>
--- expected
Website Subcategory 2

=== mt:EntryIfCategory
--- template _mt_websites
<mt:Entries><mt:EntryIfCategory name="Website Subcategory 2"><mt:EntryTitle></mt:EntryIfCategory></mt:Entries>
--- expected
Website Entry 2

=== mt:SubCatIsFirst
--- template _mt_websites
<mt:Categories><mt:SubCategories><mt:SubCatIsFirst><mt:CategoryLabel>
</mt:SubCatIsFirst></mt:SubCategories></mt:Categories>
--- expected
Website Subcategory 2
Website Subsubcategory 5

=== mt:SubCatIsLast
--- template _mt_websites
<mt:Categories><mt:SubCategories><mt:SubCatIsLast><mt:CategoryBasename>
</mt:SubCatIsLast></mt:SubCategories></mt:Categories>
--- expected
website_subcategory_2
website_subsubcategory_6

=== mt:HasSubCategories
--- template _mt_websites
<mt:Categories><mt:HasSubCategories><mt:CategoryLabel>
</mt:HasSubCategories></mt:Categories>
--- expected
Website Category 1
Website Subcategory 2

=== mt:HasNoSubCategories
--- template _mt_websites
<mt:Categories><mt:HasNoSubCategories><mt:CategoryBasename>
</mt:HasNoSubCategories></mt:Categories>
--- expected
website_category_3
website_category_4
website_subsubcategory_5
website_subsubcategory_6

=== mt:HasParentCategory
--- template _mt_websites
<mt:Categories><mt:HasParentCategory><mt:CategoryLabel>
</mt:HasParentCategory></mt:Categories>
--- expected
Website Subcategory 2
Website Subsubcategory 5
Website Subsubcategory 6

=== mt:HasNoParentCategory
--- template _mt_websites
<mt:Categories><mt:HasNoParentCategory><mt:CategoryBasename>
</mt:HasNoParentCategory></mt:Categories>
--- expected
website_category_1
website_category_3
website_category_4

=== mt:IfIsAncestor
--- template _mt_websites
<mt:Categories><mt:IfIsAncestor child="Website Subcategory 2"><mt:CategoryLabel>
</mt:IfIsAncestor></mt:Categories>
--- expected
Website Category 1
Website Subcategory 2

=== mt:IfIsDescendant
--- template _mt_websites
<mt:Categories><mt:IfIsDescendant parent="Website Category 1"><mt:CategoryBasename>
</mt:IfIsDescendant></mt:Categories>
--- expected
website_category_1
website_subcategory_2
website_subsubcategory_5
website_subsubcategory_6

=== mt:EntryCategories
--- template _mt_websites
<mt:Entries><mt:EntryCategories glue=" | "><mt:CategoryLabel></mt:EntryCategories>
</mt:Entries>
--- expected
Website Subsubcategory 6
Website Subsubcategory 5
Website Category 3
Website Subcategory 2
Website Category 1 | Website Category 4

=== mt:EntryPrimaryCategory
--- template _mt_websites
<mt:Entries><mt:EntryPrimaryCategory><mt:CategoryBasename>
</mt:EntryPrimaryCategory></mt:Entries>
--- expected
website_subsubcategory_6
website_subsubcategory_5
website_category_3
website_subcategory_2
website_category_1

=== mt:EntryAdditionalCategories
--- template _mt_websites
<mt:Entries><mt:EntryAdditionalCategories><mt:CategoryLabel>
</mt:EntryAdditionalCategories></mt:Entries>
--- expected
Website Category 4

=== mt:CategoryLabel
--- template _mt_websites
<mt:Categories><mt:CategoryLabel>
</mt:Categories>
--- expected
Website Category 1
Website Category 3
Website Category 4
Website Subcategory 2
Website Subsubcategory 5
Website Subsubcategory 6

=== mt:CategoryBasename
--- template _mt_websites
<mt:Categories><mt:CategoryBasename>
</mt:Categories>
--- expected
website_category_1
website_category_3
website_category_4
website_subcategory_2
website_subsubcategory_5
website_subsubcategory_6

=== mt:CategoryDescription
--- template _mt_websites
<mt:Categories><mt:CategoryDescription>
</mt:Categories>
--- expected
This is a website category 1.
This is a website category 3.
This is a website category 4.
This is a website subcategory 2.
This is a website subsubcategory 5.
This is a website subsubcategory 6.

=== mt:CategoryArchiveLink
--- template _mt_websites
<mt:Categories><mt:CategoryArchiveLink>
</mt:Categories>
--- expected
http://localhost/first_website/website-category-1/
http://localhost/first_website/website-category-3/
http://localhost/first_website/website-category-4/
http://localhost/first_website/website-category-1/website-subcategory-2/
http://localhost/first_website/website-category-1/website-subcategory-2/website-subsubcategory-5/
http://localhost/first_website/website-category-1/website-subcategory-2/website-subsubcategory-6/

=== mt:CategoryCount
--- template _mt_websites
<mt:Categories glue=" "><mt:CategoryCount></mt:Categories>
--- expected
1 1 1 1 1 1

=== mt:SubCatsRecurse
--- template _mt_websites
<mt:TopLevelCategories><mt:CategoryLabel>
<mt:SubCatsRecurse></mt:TopLevelCategories>
--- expected
Website Category 1
Website Subcategory 2
Website Subsubcategory 5
Website Subsubcategory 6
Website Category 3
Website Category 4

=== mt:SubCategoryPath
--- template _mt_websites
<mt:Categories><mt:SubCategoryPath>
</mt:Categories>
--- expected
website_category_1
website_category_3
website_category_4
website_category_1/website_subcategory_2
website_category_1/website_subcategory_2/website_subsubcategory_5
website_category_1/website_subcategory_2/website_subsubcategory_6

=== mt:BlogCategoryCount
--- template _mt_websites
<mt:BlogCategoryCount>
--- expected
6

=== mt:ArchiveCategory
--- template _mt_websites
<mt:Categories><mt:ArchiveCategory>
</mt:Categories>
--- expected
Website Category 1
Website Category 3
Website Category 4
Website Subcategory 2
Website Subsubcategory 5
Website Subsubcategory 6

=== mt:EntryCategory
--- template _mt_websites
<mt:Entries><mt:EntryCategory>
</mt:Entries>
--- expected
Website Subsubcategory 6
Website Subsubcategory 5
Website Category 3
Website Subcategory 2
Website Category 1

=== mt:EntryAssets
--- template _mt_websites
<mt:Entries><mt:EntryAssets>ID:<mt:EntryID> / <mt:AssetLabel>
</mt:EntryAssets></mt:Entries>
--- expected
ID:1 / Website Asset 1

=== mt:EntryAuthorUserpicAsset
--- template _mt_websites
<mt:Entries><mt:EntryAuthorUserpicAsset><mt:AssetLabel>
</mt:EntryAuthorUserpicAsset></mt:Entries>
--- expected
Userpic
Userpic
Userpic
Userpic
Userpic
Userpic

=== mt:EntryAuthorUserpic
--- SKIP
--- template _mt_websites
<mt:Entries><mt:EntryAuthorUserpic>
</mt:Entries>
--- expected
<img src="/mt-static/support/assets_c/userpics/userpic-1-100x100.png?1" width="25" height="25" alt="" />
<img src="/mt-static/support/assets_c/userpics/userpic-1-100x100.png?1" width="25" height="25" alt="" />
<img src="/mt-static/support/assets_c/userpics/userpic-1-100x100.png?1" width="25" height="25" alt="" />
<img src="/mt-static/support/assets_c/userpics/userpic-1-100x100.png?1" width="25" height="25" alt="" />
<img src="/mt-static/support/assets_c/userpics/userpic-1-100x100.png?1" width="25" height="25" alt="" />
<img src="/mt-static/support/assets_c/userpics/userpic-1-100x100.png?1" width="25" height="25" alt="" />

=== mt:EntryAuthorUserpicURL
--- skip_php
[% no_php_gd %]
--- template _mt_websites
<mt:Entries><mt:EntryAuthorUserpicURL>
</mt:Entries>
--- expected
/mt-static/support/assets_c/userpics/userpic-1-100x100.png
/mt-static/support/assets_c/userpics/userpic-1-100x100.png
/mt-static/support/assets_c/userpics/userpic-1-100x100.png
/mt-static/support/assets_c/userpics/userpic-1-100x100.png
/mt-static/support/assets_c/userpics/userpic-1-100x100.png
/mt-static/support/assets_c/userpics/userpic-1-100x100.png

=== mt:EntryTags
--- template _mt_websites
<mt:Entries><mt:EntryTags><mt:TagName>
</mt:EntryTags></mt:Entries>
--- expected
Website Tag 1

=== mt:EntryIfTagged
--- template _mt_websites
<mt:Entries><mt:EntryIfTagged><mt:EntryTitle>
</mt:EntryIfTagged></mt:Entries>
--- expected
Website Entry 1

=== mt:EntryScore
--- template _mt_websites
<mt:Entries><mt:EntryScore namespace="test_namespace">
</mt:Entries>
--- expected
0
0
0
0
0
6

=== mt:EntryScoreHigh
--- template _mt_websites
<mt:Entries><mt:EntryScoreHigh namespace="test_namespace" sprintf="%d">
</mt:Entries>
--- expected
0
0
0
0
0
4

=== mt:EntryScoreLow
--- template _mt_websites
<mt:Entries><mt:EntryScoreLow namespace="test_namespace" sprintf="%d">
</mt:Entries>
--- expected
0
0
0
0
0
2

=== mt:EntryScoreAvg
--- template _mt_websites
<mt:Entries><mt:EntryScoreAvg namespace="test_namespace">
</mt:Entries>
--- expected
0
0
0
0
0
3.00

=== mt:EntryScoreCount
--- template _mt_websites
<mt:Entries><mt:EntryScoreCount namespace="test_namespace">
</mt:Entries>
--- expected
0
0
0
0
0
2

=== mt:EntryRank
--- template _mt_websites
<mt:Entries><mt:EntryRank namespace="test_namespace">
</mt:Entries>
--- expected
5

=== mt:IfExternalUserManagement
--- template _mt_websites
<mt:IfExternalUserManagement>if<mt:Else>else</mt:IfExternalUserManagement>
--- expected
else

=== mt:AuthorEntriesCount
--- template _mt_websites
<mt:Authors><mt:AuthorEntriesCount>
</mt:Authors>
--- expected
7

=== mt:UserSessionCookieTimeout
--- SKIP
--- template _mt_websites
<mt:UserSessionCookieTimeout>
--- expected
14400

=== mt:UserSessionCookieName
--- SKIP
--- template _mt_websites
<mt:UserSessionCookieName>
--- expected
mt_blog_user

=== mt:UserSessionCookiePath
--- SKIP
--- template _mt_websites
<mt:UserSessionCookiePath>
--- expected
/

=== mt:UserSessionCookieDomain
--- SKIP
--- template _mt_websites
<mt:UserSessionCookieDomain>
--- expected
.localhost

=== mt:AuthorEntriesCount
--- template
<mt:Authors site_ids="1"><mt:AuthorEntriesCount></mt:Authors>
--- expected
7
