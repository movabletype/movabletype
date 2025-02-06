#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::Deep            qw(cmp_deeply);
use File::Copy::Recursive qw(dircopy);
use File::Spec;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Util::YAML;
use MT::Test::App;
use MT::Test::DataAPI;
use MT::App::DataAPI;

$test_env->prepare_fixture('db_data');

my $app = MT::App::DataAPI->new;

# preparation.
my $admin      = MT->model('author')->load(1);
my $site       = MT->model('site')->load(2);
my @categories = MT->model('category')->load;
$site->category_order(join ',', map { $_->id } @categories);
$site->save;

my $cms_app = MT::Test::App->new('MT::App::CMS');
$cms_app->login($admin);

# test.
my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[

        # export_site_theme - normal tests
        {
            path   => '/v7/sites/2/export_theme',
            method => 'POST',
            params => { overwrite_yes => 1, },
            setup  => sub {
                my $data             = shift;
                my $default_basename = [File::Spec->splitdir($site->site_path)]->[-1];
                $cms_app->post_ok({
                    __mode        => 'do_export_theme',
                    blog_id       => 2,
                    theme_name    => 'Theme from ' . $site->name,
                    theme_id      => 'theme_from_' . $default_basename,
                    theme_version => 1.0,
                    output        => 'themedir',
                    include_all   => 1,
                    overwrite_yes => 1
                });

                dircopy "$ENV{MT_TEST_ROOT}/themes/", "$ENV{MT_TEST_ROOT}/cms_themes/";
                my @cms_outputs = $test_env->files("$ENV{MT_TEST_ROOT}/cms_themes/");
                isnt(scalar @cms_outputs, 0);

                $data->{cms_outputs} = \@cms_outputs;
            },
            result => sub {
                +{ status => 'success' };
            },
            complete => sub {
                my $data = shift;

                my @outputs = $test_env->files("$ENV{MT_TEST_ROOT}/themes");
                isnt(scalar @outputs, 0);

                my $theme_yaml_path = (grep { $_ =~ /theme.yaml/ } @outputs)[0];
                my $theme_yaml      = MT::Util::YAML::LoadFile($theme_yaml_path);
                my @files           = map {
                    my $path = $_;
                    $path =~ s/\Q$ENV{MT_TEST_ROOT}\/themes\/\E//;
                    $path;
                } @outputs;

                my $cms_theme_yaml_path = (grep { $_ =~ /theme.yaml/ } @{ $data->{cms_outputs} })[0];
                my $cms_theme_yaml      = MT::Util::YAML::LoadFile($cms_theme_yaml_path);
                my @cms_files           = map {
                    my $path = $_;
                    $path =~ s/\Q$ENV{MT_TEST_ROOT}\/cms_themes\/\E//;
                    $path;
                } @{ $data->{cms_outputs} };

                cmp_deeply($cms_theme_yaml, $theme_yaml);
                cmp_deeply(\@cms_files,     \@files);
            }
        },

        # export_site_theme - param tests
        {
            path   => '/v7/sites/2/export_theme',
            method => 'POST',
            params => {
                theme_id          => 'custom_id',
                theme_name        => 'Custom Name',
                theme_version     => '2.0',
                description       => 'test for export theme',
                theme_author_name => 'Melody',
                theme_author_link => 'http://example.com/',
                includes          => ['default_category_sets'],
                overwrite_yes     => 1,
            },
            result => sub {
                +{ status => 'success' };
            },
            complete => sub {
                my @outputs = $test_env->files("$ENV{MT_TEST_ROOT}/themes/custom_id");
                isnt(scalar @outputs, 0);

                my $theme_yaml_path = (grep { $_ =~ /theme.yaml/ } @outputs)[0];
                my $theme_yaml      = MT::Util::YAML::LoadFile($theme_yaml_path);
                is($theme_yaml->{id},          'custom_id');
                is($theme_yaml->{name},        'Custom Name');
                is($theme_yaml->{version},     '2.0');
                is($theme_yaml->{description}, 'test for export theme');
                is($theme_yaml->{author_name}, 'Melody');
                is($theme_yaml->{author_link}, 'http://example.com/');
                eq_array([keys %{ $theme_yaml->{elements} }], ['default_category_sets']);
                is(scalar(grep { $_ =~ /\/template_set\// } @outputs), 0);
            }
        },

        # export_site_theme - include_all tests
        {
            path   => '/v7/sites/2/export_theme',
            method => 'POST',
            params => {
                include_all   => 0,
                overwrite_yes => 1,
            },
            result => sub {
                +{ status => 'success' };
            },
            complete => sub {
                my @outputs = $test_env->files("$ENV{MT_TEST_ROOT}/themes");
                isnt(scalar @outputs, 0);
                my $theme_yaml_path = (grep { $_ =~ /theme.yaml/ } @outputs)[0];
                my $theme_yaml      = MT::Util::YAML::LoadFile($theme_yaml_path);
                is(scalar(keys %{ $theme_yaml->{elements} }),          0);
                is(scalar(grep { $_ =~ /\/template_set\// } @outputs), 0);
            }
        },

        # export_site_theme - irregular tests
        {    # Non-existent site.
            path   => '/v7/sites/5/export_theme',
            method => 'POST',
            code   => 404,
            result => sub {
                +{
                    error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # System.
            path   => '/v7/sites/0/export_theme',
            method => 'POST',
            code   => 404,
            result => sub {
                +{
                    error => {
                        code    => 404,
                        message => 'Site not found',
                    },
                };
            },
        },
        {    # Already exists.
            path   => '/v7/sites/2/export_theme',
            method => 'POST',
            code   => 409,
        },
        {    # Not logged in.
            path      => '/v7/sites/5/export_theme',
            method    => 'POST',
            author_id => 0,
            code      => 401,
            error     => 'Unauthorized',
        },
        {    # No permissions.
            path         => '/v7/sites/2/export_theme',
            method       => 'POST',
            restrictions => {
                0 => [qw/ do_export_theme /],
                2 => [qw/ do_export_theme /],
            },
            code  => 403,
            error => 'Do not have permission to export the requested theme.',
        },
    ];
}

