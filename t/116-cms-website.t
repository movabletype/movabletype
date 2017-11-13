#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;

    # Move addons/Cloud.pack/config.yaml to config.yaml.disabled.
    # An error occurs in save_community_prefs mode when Cloud.pack installed.
    $test_env->disable_addon('Cloud.pack');
}

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website(
        name => 'my website',
    );

    # Blog
    my $blog = MT::Test::Permission->make_blog(
        parent_id => $website->id,
        name => 'my blog',
    );

    # Author
    my $admin = MT->model('author')->load(1);
});

my $website = MT::Website->load( { name => 'my website' } );
my $blog    = MT::Blog->load( { name => 'my blog' } );

my $admin = MT->model('author')->load(1);

# Run tests
my ( $app, $out );

note 'Test cfg_prefs mode';
subtest 'Test cfg_prefs mode' => sub {
    foreach my $type ( 'website', 'blog' ) {
        my $type_ucfirst = 'Site';    # ucfirst $type;
        my $test_blog = $type eq 'website' ? $website : $blog;
        my $type_alias = $type eq 'website' ? 'site' : 'child site';

        note "$type_ucfirst scope";
        subtest "$type_ucfirst scope" => sub {
            $app = _run_app(
                'MT::App::CMS',
                {   __test_user => $admin,
                    __mode      => 'cfg_prefs',
                    blog_id     => $test_blog->id,
                }
            );
            $out = delete $app->{__test_output};
            ok( $out, "Request: $type general settings" );

            # Modify description. bugid:109613
            like(
                $out,
                qr/Number of revisions per entry\/page/,
                'Has "Number of revisions per entry\/page" description.'
            );
            unlike(
                $out,
                qr/Number of revisions per page/,
                'Has "Number of revisions per page" description.'
            );

            like(
                $out,
                qr/Preferred Archive/,
                'Has "Preferred Archive" setting.'
            );

            my $description
                = quotemeta(
                "Used to generate URLs (permalinks) for this ${type_alias}'s archived entries. Choose one of the archive types used in this ${type_alias}'s archive templates."
                );
            $description = qr/$description/;
            like( $out, qr/$description/,
                "Has a $type scope description in Preferred Archive setting."
            );

            my $enable_archive_paths = quotemeta
                "<label for=\"enable_archive_paths\">Publish archives outside of $type_ucfirst Root</label>";
        SKIP: {
                skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
                like( $out, qr/$enable_archive_paths/,
                    'Has publish archives outside checkbox.' );
            }

            my $site_root_hint
                = $type eq 'blog'
                ? 'The path where your index files will be published. Do not end with \'/\' or \'\\\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog'
                : 'The path where your index files will be published. An absolute path (starting with \'/\' for Linux or \'C:\\\' for Windows) is preferred.  Do not end with \'/\' or \'\\\'. Example: /home/mt/public_html or C:\www\public_html';
            $site_root_hint = quotemeta $site_root_hint;
            like( $out, qr/$site_root_hint/, 'Has Site Root hint.' );

            my $archive_url = quotemeta
                '<label id="archive_url-label" for="archive_url">Archive URL *</label>';
        SKIP: {
                skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
                like( $out, qr/$archive_url/, 'Has "Archive URL" setting.' );
            }

            my $archive_url_hint
                = $type eq 'blog'
                ? "The URL of the archives section of your ${type_alias}. Example: http://www.example.com/${type}/archives/"
                : "The URL of the archives section of your ${type_alias}. Example: http://www.example.com/archives/";
            $archive_url_hint = quotemeta $archive_url_hint;
            like( $out, qr/$archive_url_hint/, 'Has Archive URL hint.' );

            my $archive_url_warning = quotemeta
                "Warning: Changing the archive URL can result in breaking all links in your ${type_alias}.";
            like( $out, qr/$archive_url_warning/,
                'Has Archive URL warning.' );

            my $archive_root = quotemeta
                '<label id="archive_path-label" for="archive_path">Archive Root *</label>';
        SKIP: {
                skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
                like( $out, qr/$archive_root/,
                    'Has "Archive Root" setting.' );
            }

            my $archive_root_hint
                = $type eq 'blog'
                ? 'The path where your archives section index files will be published. Do not end with \'/\' or \'\\\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog'
                : 'The path where your archives section index files will be published. An absolute path (starting with \'/\' for Linux or \'C:\\\' for Windows) is preferred. Do not end with \'/\' or \'\\\'. Example: /home/mt/public_html or C:\www\public_html';
            $archive_root_hint = quotemeta $archive_root_hint;
            like( $out, qr/$archive_root_hint/, 'Has Archive Root hint.' );

            $test_blog->archive_url('http://localhost/');
            $test_blog->update;

            $app = _run_app(
                'MT::App::CMS',
                {   __test_user => $admin,
                    __mode      => 'cfg_prefs',
                    blog_id     => $test_blog->id,
                }
            );
            $out = delete $app->{__test_output};

            my $is_checked = quotemeta
                '<input type="checkbox" name="enable_archive_paths" id="enable_archive_paths" value="1" checked="checked" class="cb"';

        SKIP: {
                skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
                like( $out, qr/$is_checked/,
                    'Parameter "enable_archive_paths" is checked.' );
            }

            if ( $type eq 'website' ) {
                my $archive_url  = 'http://localhost/archive/path/';
                my $archive_path = '/var/www/html/archive/path';

                $app = _run_app(
                    'MT::App::CMS',
                    {   __test_user          => $admin,
                        __request_method     => 'POST',
                        __mode               => 'save',
                        _type                => 'blog',
                        blog_id              => $test_blog->id,
                        id                   => $test_blog->id,
                        enable_archive_paths => 1,
                        archive_url          => $archive_url,
                        archive_path         => $archive_path,
                    },
                );
                $out = delete $app->{__test_output};
                ok( $out =~ /Status: 302 Found/ && $out =~ /saved=1/,
                    'Request: save blog' );

                $test_blog = MT->model('website')->load( $test_blog->id );
                is( $test_blog->column('archive_url'),
                    $archive_url, 'Can save archive_url correctly.' );
                is( $test_blog->column('archive_path'),
                    $archive_path, 'Can save archive_path correctly.' );
            }

            if ( $type eq 'blog' ) {
                $app->config->BaseSitePath('dummy');

                $app = _run_app(
                    'MT::App::CMS',
                    {   __test_user => $admin,
                        __mode      => 'cfg_prefs',
                        blog_id     => $test_blog->id,
                    },
                );
                $out = delete $app->{__test_output};

                like( $out, qr/$site_root_hint/,
                    'Has Site Root hint(relative).' );
                my $site_root_hint_abs = quotemeta
                    "The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\\' for Windows) is preferred.  Do not end with '/' or '\\'. Example: /home/mt/public_html or C:\\www\\public_html";
                unlike( $out, qr/$site_root_hint_abs/,
                    'Has Site Root hint(absolute).' );

            SKIP: {
                    skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
                    like( $out, qr/$archive_root_hint/,
                        'Has Archive URL hint(relative).' );
                }
                my $archive_root_hint_abs = quotemeta
                    "The path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\\' for Windows) is preferred. Do not end with '/' or '\\'. Example: /home/mt/public_html or C:\\www\\public_html";
                unlike( $out, qr/$archive_root_hint_abs/,
                    'Has Archive URL hint(absolute).' );

                $app->config->BaseSitePath(undef);
            }
        };
    }
};

note 'Test cfg_entry mode';
subtest 'Test cfg_entry mode' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'cfg_entry',
            blog_id     => $website->id
        }
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: website compose settings" );

    like(
        $out,
        qr/Entry Fields/,
        'Has "Entry Fields" in Compose Defaults setting.'
    );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            id               => $website->id,
            blog_id          => $website->id,
            return_args      => '__mode=cfg_entry&_type=blog&blog_id='
                . $website->id . '&id='
                . $website->id,
            cfg_screen         => 'cfg_entry',
            entry_custom_prefs => 'title',
            entry_custom_prefs => 'text',
        },
    );
    ok( $out, "Request: save" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'cfg_entry',
            blog_id     => $website->id,
        },
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: website compose settings" );

    my @fields = qw( category excerpt keywords tags feedback assets );
    foreach my $field (@fields) {
        my $input
            = quotemeta(
            "<input type=\"checkbox\" name=\"entry_custom_prefs\" id=\"entry-prefs-$field\" value=\"$field\" class=\"cb\" />"
            );
        $input = qr/$input/;
    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            like( $out, $input,
                "$field setting in Entry Fields is not checked." );
        }
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'view',
            _type       => 'entry',
            blog_id     => $website->id,
        },
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: view (entry, new)" );

    foreach my $field (@fields) {
        my $input
            = quotemeta(
            "<input type=\"checkbox\" name=\"custom_prefs\" id=\"custom-prefs-$field\" value=\"$field\" class=\"cb\" />"
            );
        $input = qr/$input/;
    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            like( $out, $input,
                "$field setting in custom prefs is not checked." );
        }
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'blog',
            id               => $website->id,
            blog_id          => $website->id,
            return_args      => '__mode=cfg_entry&_type=blog&blog_id='
                . $website->id . '&id='
                . $website->id,
            cfg_screen         => 'cfg_entry',
            entry_custom_prefs => [ qw( title text ), @fields ],
        },
    );
    ok( $out, "Request: save" );

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'cfg_entry',
            blog_id     => $website->id,
        },
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: website compose settings" );

    foreach my $field (@fields) {
        my $input
            = quotemeta(
            "<input type=\"checkbox\" name=\"entry_custom_prefs\" id=\"entry-prefs-$field\" value=\"$field\" checked=\"checked\" class=\"cb\" />"
            );
        $input = qr/$input/;
    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            like( $out, $input,
                "$field setting in Entry Fields is checked." );
        }
    }

    $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'view',
            _type       => 'entry',
            blog_id     => $website->id,
        },
    );
    $out = delete $app->{__test_output};
    ok( $out, "Request: view (entry, new)" );

    foreach my $field (@fields) {
        my $input
            = quotemeta(
            "<input type=\"checkbox\" name=\"custom_prefs\" id=\"custom-prefs-$field\" value=\"$field\" checked=\"checked\" class=\"cb\" />"
            );
        $input = qr/$input/;
    SKIP: {
            skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
            like( $out, $input,
                "$field setting in custom prefs is checked." );
        }
    }

    done_testing();
};

note 'Website listing screen';
subtest 'Website listing screen' => sub {
    $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $admin,
            __mode      => 'list',
            _type       => 'website',
            blog_id     => 0,
        },
    );
    $out = delete $app->{__test_output};
    ok( $out, 'Request: list website' );

    my $blogs = quotemeta
        '<th class="col head blog_count num"><a href="#blog_count" class="sort-link"><span class="col-label">Blogs</span><span class="sm"></span></a></th>';
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        like( $out, qr/$blogs/, 'Listing screen has "Blogs" column.' );
    }

    my $entries = quotemeta
        '<th class="col head entry_count num"><a href="#entry_count" class="sort-link"><span class="col-label">Entries</span><span class="sm"></span></a></th>';
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        like( $out, qr/$entries/, 'Listing screen has "Entries" column.' );
    }

    my $pages = quotemeta
        '<th class="col head page_count num"><a href="#page_count" class="sort-link"><span class="col-label">Pages</span><span class="sm"></span></a></th>';
SKIP: {
        skip "new UI", 1 unless $ENV{MT_TEST_NEW_UI};
        like( $out, qr/$pages/, 'Listing screen has "Pages" column.' );
    }

    my $classic_website = quotemeta
        '<option value="classic_website">Classic Website</option>';
    like( $out, qr/$classic_website/,
        'Listing screen has website theme filters.' );

    my $classic_blog
        = quotemeta '<option value="classic_blog">Classic Blog</option>';
    like( $out, qr/$classic_blog/, 'Listing screen has blog theme filters.' );
};

done_testing();

