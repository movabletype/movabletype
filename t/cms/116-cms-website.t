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

    # Move addons/Cloud.pack/config.yaml to config.yaml.disabled.
    # An error occurs in save_community_prefs mode when Cloud.pack installed.
    $test_env->skip_if_addon_exists('Cloud.pack');
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::Fixture::Cms::Common1;

use MT::Test::App;

### Make test data
$test_env->prepare_fixture('cms/common1');

my $website = MT::Website->load({ name => 'my website' });
my $blog    = MT::Blog->load({ name => 'my blog' });

my $admin = MT->model('author')->load(1);

my $website_entry = MT::Test::Permission->make_entry(
    blog_id => $website->id,
    title   => 'WebsiteEntry',
);

my $blog_entry = MT::Test::Permission->make_entry(
    blog_id => $blog->id,
    title   => 'BlogEntry',
);

MT->publisher->rebuild(BlogID => $website->id);
MT->publisher->rebuild(BlogID => $blog->id);

my @published_files;
use File::Find;
File::Find::find({
        wanted => sub {
            push @published_files, $File::Find::name;
        },
        no_chdir => 1,
    },
    $test_env->root
);

ok grep(/websiteentry/, @published_files), "website entry is published";
ok grep(/blogentry/,    @published_files), "blog entry is published";

note 'Test cfg_prefs mode';
subtest 'Test cfg_prefs mode' => sub {
    foreach my $type ('website', 'blog') {
        my $type_ucfirst       = 'Site';    # ucfirst $type;
        my $test_blog          = $type eq 'website' ? $website : $blog;
        my $type_alias         = $type eq 'website' ? 'site'   : 'child site';
        my $type_alias_ucfirst = $type eq 'website' ? 'Site'   : 'Child Site';

        note "$type_ucfirst scope";
        subtest "$type_ucfirst scope" => sub {
            my $app = MT::Test::App->new('MT::App::CMS');
            $app->login($admin);
            $app->get_ok({
                __mode  => 'cfg_prefs',
                blog_id => $test_blog->id,
            });

            # Modify description. bugid:109613
            $app->content_like(
                qr/Number of revisions per entry\/page/,
                'Has "Number of revisions per entry\/page" description.'
            );
            $app->content_unlike(
                qr/Number of revisions per page/,
                'Has "Number of revisions per page" description.'
            );

            $app->content_like(
                qr/Preferred Archive/,
                'Has "Preferred Archive" setting.'
            );

            my $description = quotemeta("Used to generate URLs (permalinks) for this ${type_alias}'s archived entries. Choose one of the archive types used in this ${type_alias}'s archive templates.");
            $description = qr/$description/;
            $app->content_like(
                qr/$description/,
                "Has a $type scope description in Preferred Archive setting."
            );

            my $enable_archive_paths = quotemeta "<label for=\"enable_archive_paths\">Publish archives outside of $type_ucfirst Root</label>";
        SKIP: {
                skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
                $app->content_like(
                    qr/$enable_archive_paths/,
                    'Has publish archives outside checkbox.'
                );
            }

            my $site_root_hint =
                $type eq 'blog'
                ? 'The path where your index files will be published. Do not end with \'/\' or \'\\\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog'
                : 'The path where your index files will be published. An absolute path (starting with \'/\' for Linux or \'C:\\\' for Windows) is preferred.  Do not end with \'/\' or \'\\\'. Example: /home/mt/public_html or C:\www\public_html';
            $site_root_hint = quotemeta $site_root_hint;
            $app->content_like(qr/$site_root_hint/, 'Has Site Root hint.');

            my $archive_url = quotemeta '<label id="archive_url-label" for="archive_url">Archive URL *</label>';
        SKIP: {
                skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
                $app->content_like(qr/$archive_url/, 'Has "Archive URL" setting.');
            }

            my $archive_url_hint =
                $type eq 'blog'
                ? "The URL of the archives section of your ${type_alias}. Example: http://www.example.com/${type}/archives/"
                : "The URL of the archives section of your ${type_alias}. Example: http://www.example.com/archives/";
            $archive_url_hint = quotemeta $archive_url_hint;
            $app->content_like(qr/$archive_url_hint/, 'Has Archive URL hint.');

            my $archive_url_warning = quotemeta "Warning: Changing the archive URL requires a complete publish of your ${type_alias_ucfirst}, even when publishing profile is dynamic publishing.";

            $app->content_like(
                qr/$archive_url_warning/,
                'Has Archive URL warning.'
            );

            my $archive_root = quotemeta '<label id="archive_path-label" for="archive_path">Archive Root *</label>';
        SKIP: {
                skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
                $app->content_like(
                    qr/$archive_root/,
                    'Has "Archive Root" setting.'
                );
            }

            my $archive_root_hint =
                $type eq 'blog'
                ? 'The path where your archives section index files will be published. Do not end with \'/\' or \'\\\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog'
                : 'The path where your archives section index files will be published. An absolute path (starting with \'/\' for Linux or \'C:\\\' for Windows) is preferred. Do not end with \'/\' or \'\\\'. Example: /home/mt/public_html or C:\www\public_html';
            $archive_root_hint = quotemeta $archive_root_hint;
            $app->content_like(qr/$archive_root_hint/, 'Has Archive Root hint.');

            $test_blog->archive_url('http://localhost/');
            $test_blog->update;

            $app->get_ok({
                __mode  => 'cfg_prefs',
                blog_id => $test_blog->id,
            });

            my $is_checked = quotemeta '<input type="checkbox" name="enable_archive_paths" id="enable_archive_paths" value="1" checked="checked" class="cb"';

        SKIP: {
                skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
                $app->content_like(
                    qr/$is_checked/,
                    'Parameter "enable_archive_paths" is checked.'
                );
            }

            {
                my $archive_url  = 'http://localhost/archive/path/';
                my $archive_path = $test_env->root . "/new/$type/archive/path";

                if ($type eq 'website') {
                    $app->post_form_ok({
                        enable_archive_paths => 1,
                        archive_url          => $archive_url,
                        archive_path         => $archive_path,
                        preferred_archive_type => 'Individual',
                        max_revisions_entry    => 20,
                        max_revisions_cd       => 20,
                        max_revisions_template => 20,
                    });
                } else {
                    $app->post_form_ok({
                        enable_archive_paths   => 1,
                        archive_path_absolute  => $archive_path,
                        site_url_path          => 'nana/',
                        archive_url_path       => 'nana/archives/',
                        preferred_archive_type => 'Individual',
                        max_revisions_entry    => 20,
                        max_revisions_cd       => 20,
                        max_revisions_template => 20,
                    });
                }
                ok($app->last_location->query_param('saved'), 'Request: save blog');

                $test_blog = MT->model($type)->load($test_blog->id);
                if ($type eq 'website') {
                    is(
                        $test_blog->column('archive_url'),
                        $archive_url, 'Can save archive_url correctly.'
                    );
                }
                is(
                    $test_blog->column('archive_path'),
                    $archive_path, 'Can save archive_path correctly.'
                );

                my @missing = grep { !-e $_ } @published_files;
                ok !@missing, 'no files are removed';
                note join "\n", @missing if @missing;
            }

            if ($type eq 'blog') {
                $test_env->update_config(BaseSitePath => 'dummy');

                $app->get_ok({
                        __mode  => 'cfg_prefs',
                        blog_id => $test_blog->id,
                    },
                );

                $app->content_like(
                    qr/$site_root_hint/,
                    'Has Site Root hint(relative).'
                );
                my $site_root_hint_abs = quotemeta "The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\\' for Windows) is preferred.  Do not end with '/' or '\\'. Example: /home/mt/public_html or C:\\www\\public_html";
                $app->content_unlike(
                    qr/$site_root_hint_abs/,
                    'Has Site Root hint(absolute).'
                );

            SKIP: {
                    skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
                    $app->content_like(
                        qr/$archive_root_hint/,
                        'Has Archive URL hint(relative).'
                    );
                }
                my $archive_root_hint_abs = quotemeta "The path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\\' for Windows) is preferred. Do not end with '/' or '\\'. Example: /home/mt/public_html or C:\\www\\public_html";
                $app->content_unlike(
                    qr/$archive_root_hint_abs/,
                    'Has Archive URL hint(absolute).'
                );

                MT->config->BaseSitePath(undef);
            }
        };
    }
};

note 'Test cfg_entry mode';
subtest 'Test cfg_entry mode' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'cfg_entry',
        blog_id => $website->id
    });

    $app->content_like(
        qr/Entry Fields/,
        'Has "Entry Fields" in Compose Defaults setting.'
    );

    $app->post_ok({
        __mode             => 'save',
        _type              => 'blog',
        id                 => $website->id,
        blog_id            => $website->id,
        return_args        => '__mode=cfg_entry&_type=blog&blog_id=' . $website->id . '&id=' . $website->id,
        cfg_screen         => 'cfg_entry',
        entry_custom_prefs => 'text',
    });

    $app->get_ok({
        __mode  => 'cfg_entry',
        blog_id => $website->id,
    });

    my @fields = qw( category excerpt keywords tags feedback assets );
    foreach my $field (@fields) {
        my $input = quotemeta("<input type=\"checkbox\" name=\"entry_custom_prefs\" id=\"entry-prefs-$field\" value=\"$field\" class=\"cb\" />");
        $input = qr/$input/;
    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            $app->content_like(
                $input,
                "$field setting in Entry Fields is not checked."
            );
        }
    }

    $app->get_ok({
        __mode  => 'view',
        _type   => 'entry',
        blog_id => $website->id,
    });

    foreach my $field (@fields) {
        my $input = quotemeta("<input type=\"checkbox\" name=\"custom_prefs\" id=\"custom-prefs-$field\" value=\"$field\" class=\"cb\" />");
        $input = qr/$input/;
    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            $app->content_like(
                $input,
                "$field setting in custom prefs is not checked."
            );
        }
    }

    $app->post_ok({
        __mode             => 'save',
        _type              => 'blog',
        id                 => $website->id,
        blog_id            => $website->id,
        return_args        => '__mode=cfg_entry&_type=blog&blog_id=' . $website->id . '&id=' . $website->id,
        cfg_screen         => 'cfg_entry',
        entry_custom_prefs => [qw( title text ), @fields],
    });

    $app->get_ok({
            __mode  => 'cfg_entry',
            blog_id => $website->id,
        },
    );

    foreach my $field (@fields) {
        my $input = quotemeta("<input type=\"checkbox\" name=\"entry_custom_prefs\" id=\"entry-prefs-$field\" value=\"$field\" checked=\"checked\" class=\"cb\" />");
        $input = qr/$input/;
    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            $app->content_like(
                $input,
                "$field setting in Entry Fields is checked."
            );
        }
    }

    $app->get_ok({
        __mode  => 'view',
        _type   => 'entry',
        blog_id => $website->id,
    });

    foreach my $field (@fields) {
        my $input = quotemeta("<input type=\"checkbox\" name=\"custom_prefs\" id=\"custom-prefs-$field\" value=\"$field\" checked=\"checked\" class=\"cb\" />");
        $input = qr/$input/;
    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            $app->content_like(
                $input,
                "$field setting in custom prefs is checked."
            );
        }
    }

    $app->get_ok({
        __mode  => 'cfg_entry',
        blog_id => $website->id,
    });
    is $app->wq_find('select#link_default_target option[value="_self"][selected]')->size, 1, 'link_default_target is set to _self by default';

    $app->post_ok({
        __mode              => 'save',
        _type               => 'blog',
        id                  => $website->id,
        blog_id             => $website->id,
        return_args         => '__mode=cfg_entry&_type=blog&blog_id=' . $website->id . '&id=' . $website->id,
        cfg_screen          => 'cfg_entry',
        link_default_target => '_blank',
    });

    $website->refresh;
    is $website->link_default_target, '_blank', 'link_default_target is updated to _blank';

    $app->get_ok({
        __mode  => 'cfg_entry',
        blog_id => $website->id,
    });

    is $app->wq_find('select#link_default_target option[value="_blank"][selected]')->size, 1, 'link_default_target is set to _blank';

    my $unsupported_target = '_top';
    $app->post_ok({
        __mode              => 'save',
        _type               => 'blog',
        id                  => $website->id,
        blog_id             => $website->id,
        return_args         => '__mode=cfg_entry&_type=blog&blog_id=' . $website->id . '&id=' . $website->id,
        cfg_screen          => 'cfg_entry',
        link_default_target => $unsupported_target,
    });

    my $link_default_target_error = $app->wq_find('#error');
    like $link_default_target_error->text, qr/$unsupported_target/;

    $website->refresh;
    is $website->link_default_target, '_blank', 'link_default_target remains _blank after unsupported target save attempt';
};

note 'Website listing screen';
subtest 'Website listing screen' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'list',
        _type   => 'website',
        blog_id => 0,
    });

    my $blogs = quotemeta '<th class="col head blog_count num"><a href="#blog_count" class="sort-link"><span class="col-label">Blogs</span><span class="sm"></span></a></th>';
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        $app->content_like(qr/$blogs/, 'Listing screen has "Blogs" column.');
    }

    my $entries = quotemeta '<th class="col head entry_count num"><a href="#entry_count" class="sort-link"><span class="col-label">Entries</span><span class="sm"></span></a></th>';
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        $app->content_like(qr/$entries/, 'Listing screen has "Entries" column.');
    }

    my $pages = quotemeta '<th class="col head page_count num"><a href="#page_count" class="sort-link"><span class="col-label">Pages</span><span class="sm"></span></a></th>';
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        $app->content_like(qr/$pages/, 'Listing screen has "Pages" column.');
    }

    my $classic_test_website = quotemeta '<option value="classic_test_website">Classic Test Website</option>';
    $app->content_like(
        qr/$classic_test_website/,
        'Listing screen has website theme filters.'
    );

    my $classic_test_blog = quotemeta '<option value="classic_test_blog">Classic Test Blog</option>';
    $app->content_like(qr/$classic_test_blog/, 'Listing screen has blog theme filters.');
};

done_testing();
