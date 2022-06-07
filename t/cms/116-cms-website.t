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

subtest 'Test cfg_prefs mode' => sub {
    foreach my $type ('website', 'blog') {
        my $type_ucfirst       = 'Site';    # ucfirst $type;
        my $test_blog          = $type eq 'website' ? $website : $blog;
        my $type_alias         = $type eq 'website' ? 'site'   : 'child site';
        my $type_alias_ucfirst = $type eq 'website' ? 'Site'   : 'Child Site';

        subtest "$type_ucfirst scope" => sub {
            my $app = MT::Test::App->new('MT::App::CMS');
            $app->login($admin);
            $app->get_ok({
                __mode  => 'cfg_prefs',
                blog_id => $test_blog->id,
            });

            my $description = quotemeta("Used to generate URLs (permalinks) for this ${type_alias}'s archived entries. Choose one of the archive types used in this ${type_alias}'s archive templates.");
            $description = qr/$description/;
            $app->content_like(
                qr/$description/,
                "Has a $type scope description in Preferred Archive setting."
            );

            my $site_root_hint =
                $type eq 'blog'
                ? 'The path where your index files will be published. Do not end with \'/\' or \'\\\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog'
                : 'The path where your index files will be published. An absolute path (starting with \'/\' for Linux or \'C:\\\' for Windows) is preferred.  Do not end with \'/\' or \'\\\'. Example: /home/mt/public_html or C:\www\public_html';
            $site_root_hint = quotemeta $site_root_hint;
            $app->content_like(qr/$site_root_hint/, 'Has Site Root hint.');

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

            my $archive_root_hint =
                $type eq 'blog'
                ? 'The path where your archives section index files will be published. Do not end with \'/\' or \'\\\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog'
                : 'The path where your archives section index files will be published. An absolute path (starting with \'/\' for Linux or \'C:\\\' for Windows) is preferred. Do not end with \'/\' or \'\\\'. Example: /home/mt/public_html or C:\www\public_html';
            $archive_root_hint = quotemeta $archive_root_hint;
            $app->content_like(qr/$archive_root_hint/, 'Has Archive Root hint.');

            $test_blog->archive_url('http://localhost/');
            $test_blog->update;

            my $form = $app->form;

            if ($type eq 'website') {
                ok !$form->find_input('#enable_archive_paths')->value, 'Parameter "enable_archive_paths" is not checked.';
            } else {
                ok $form->find_input('#enable_archive_paths')->value, 'Parameter "enable_archive_paths" is checked.';
            }

            {
                my $archive_url  = 'http://localhost/archive/path/';
                my $archive_path = $test_env->root . "/new/$type/archive/path";

                if ($type eq 'website') {
                    $app->post_form_ok({
                        enable_archive_paths   => 1,
                        archive_url            => $archive_url,
                        archive_path           => $archive_path,
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
                like $app->message_text => qr/Your preferences have been saved/, "Request: save $type";

                $test_env->clear_mt_cache;
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
                });

                $app->content_like(
                    qr/$site_root_hint/,
                    'Has Site Root hint(relative).'
                );
                my $site_root_hint_abs = quotemeta "The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\\' for Windows) is preferred.  Do not end with '/' or '\\'. Example: /home/mt/public_html or C:\\www\\public_html";
                $app->content_unlike(
                    qr/$site_root_hint_abs/,
                    'Has Site Root hint(absolute).'
                );

                $app->content_like(
                    qr/$archive_root_hint/,
                    'Has Archive URL hint(relative).'
                );

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

    $app->post_form_ok({
        id                 => $website->id,
        cfg_screen         => 'cfg_entry',
        entry_custom_prefs => 'text',
    });

    $app->get_ok({
        __mode  => 'cfg_entry',
        blog_id => $website->id,
    });

    my $form = $app->form;

    my @fields = qw( category excerpt keywords tags assets );
    push @fields, 'feedback' if $test_env->plugin_exists('Comments');
    foreach my $field (@fields) {
        my $input = $form->find_input("#entry-prefs-$field");
        ok $input && !$input->value, "$field setting in Entry Fields is not checked.";
    }

    $app->get_ok({
        __mode  => 'view',
        _type   => 'entry',
        blog_id => $website->id,
    });

    $form = $app->form;

    foreach my $field (@fields) {
        my $input = $form->find_input("#custom-prefs-$field");
        ok $input && !$input->value, "$field setting in custom prefs is not checked.";
    }

    $app->get_ok({
        __mode  => 'cfg_entry',
        blog_id => $website->id,
    });

    $app->post_form_ok({
        entry_custom_prefs => [qw( title text ), @fields],
    });

    $app->get_ok({
        __mode  => 'cfg_entry',
        blog_id => $website->id,
    });

    $form = $app->form;

    foreach my $field (@fields) {
        my $input = $form->find_input("#entry-prefs-$field");
        ok $input && $input->value, "$field setting in Entry Fields is checked.";
    }

    $app->get_ok({
        __mode  => 'view',
        _type   => 'entry',
        blog_id => $website->id,
    });

    $form = $app->form;

    foreach my $field (@fields) {
        my $input = $form->find_input("#custom-prefs-$field");
        ok $input && $input->value, "$field setting in custom prefs is checked.";
    }
};

done_testing();
