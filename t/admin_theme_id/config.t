#!/usr/bin/perl
# $Id: 04-config.t 2562 2008-06-12 05:12:23Z bchoate $
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
my $admin_theme_id;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage       => 'en_US',                      ## for now
        FallbackAdminThemeIds => ['admin1999', 'admin1998'],
        PluginPath            => ['TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
    $test_env->save_file("plugins/TestPlugin/config.yaml", <<"PLUGIN" );
id: TestPlugin
name: TestPlugin
version: 1.0
PLUGIN
    $test_env->save_file("plugins/TestPlugin1998/config.yaml", <<"PLUGIN" );
id: TestPlugin1998
name: TestPlugin1998
version: 1.0
PLUGIN
}

use MT;
use MT::Test;
use File::Spec::Functions qw(catdir);
use MT::FileMgr;

my @test_dirs;

BEGIN {
    my $fmgr      = MT::FileMgr->new('Local');
    my @alt_paths = MT->config('AltTemplatePath');
    $admin_theme_id = MT->config->default('AdminThemeId');
    foreach my $alt_path (@alt_paths) {
        for ('admin1999', 'admin1998', $admin_theme_id) {
            my $dir = catdir($alt_path, $_);
            $fmgr->mkpath($dir);
            push @test_dirs, $dir;
        }
    }

    my @plugin_paths = MT->config('PluginPath');
    my $dir1         = catdir($plugin_paths[1], 'TestPlugin', 'tmpl', 'admin1999');
    $fmgr->mkpath($dir1);
    push @test_dirs, $dir1;
    my $dir2 = catdir($plugin_paths[1], 'TestPlugin1998', 'tmpl', 'admin1998');
    $fmgr->mkpath($dir2);
    push @test_dirs, $dir2;

    note "startup";
}

END {
    my $fmgr = MT::FileMgr->new('Local');
    $fmgr->rmdir($_) for @test_dirs;
    note "shutdown";
}

my $mt_dir = MT->instance->mt_dir;

subtest 'MT::template_paths' => sub {
    my $mt = MT->instance;
    $mt->{template_dir} = 'cms';

    my @paths = map { File::Spec->canonpath($_) } $mt->template_paths;
    note explain \@paths;

    is_deeply \@paths, [
        catdir($mt_dir, "alt-tmpl/${admin_theme_id}"),
        catdir($mt_dir, "alt-tmpl/admin1999"),
        catdir($mt_dir, "alt-tmpl/admin1998"),
        catdir($mt_dir, "alt-tmpl"),
        catdir($mt_dir, "tmpl/${admin_theme_id}/cms"),
        catdir($mt_dir, "tmpl/cms"),
        catdir($mt_dir, "tmpl/${admin_theme_id}"),
        catdir($mt_dir, "tmpl"),
    ];
};

subtest 'Component::template_paths' => sub {
    my $mt = MT->instance;
    $mt->{template_dir} = 'cms';
    my $component = 'BlockEditor';
    my $c         = $mt->component($component);

    my @cpaths = map { File::Spec->canonpath($_) } $c->template_paths;
    note explain \@cpaths;

    is_deeply \@cpaths, [
        catdir($mt_dir, "plugins/${component}/tmpl/${admin_theme_id}"),
        catdir($mt_dir, "plugins/${component}/tmpl"),
        catdir($mt_dir, "plugins/${component}"),
        catdir($mt_dir, "alt-tmpl/${admin_theme_id}"),
        catdir($mt_dir, "alt-tmpl/admin1999"),
        catdir($mt_dir, "alt-tmpl/admin1998"),
        catdir($mt_dir, "alt-tmpl"),
        catdir($mt_dir, "tmpl/${admin_theme_id}/cms"),
        catdir($mt_dir, "tmpl/cms"),
        catdir($mt_dir, "tmpl/${admin_theme_id}"),
        catdir($mt_dir, "tmpl"),
    ];
};

subtest 'Component::template_paths for outdated plugin' => sub {
    my $mt = MT->instance;
    $mt->{template_dir} = 'cms';
    my $component = 'TestPlugin';
    my $c         = $mt->component($component);

    my @cpaths = map { File::Spec->canonpath($_) } $c->template_paths;
    note explain \@cpaths;

    is_deeply \@cpaths, [
        catdir($ENV{MT_TEST_ROOT}, "plugins/${component}/tmpl/admin1999"),
        catdir($ENV{MT_TEST_ROOT}, "plugins/${component}/tmpl"),
        catdir($ENV{MT_TEST_ROOT}, "plugins/${component}"),
        catdir($mt_dir,            "alt-tmpl/${admin_theme_id}"),
        catdir($mt_dir,            "alt-tmpl/admin1999"),
        catdir($mt_dir,            "alt-tmpl/admin1998"),
        catdir($mt_dir,            "alt-tmpl"),
        catdir($mt_dir,            "tmpl/${admin_theme_id}/cms"),
        catdir($mt_dir,            "tmpl/cms"),
        catdir($mt_dir,            "tmpl/${admin_theme_id}"),
        catdir($mt_dir,            "tmpl"),
    ];
};

subtest 'Component::template_paths for outdated plugin' => sub {
    my $mt = MT->instance;
    $mt->{template_dir} = 'cms';
    my $component = 'TestPlugin1998';
    my $c         = $mt->component($component);

    my @cpaths = map { File::Spec->canonpath($_) } $c->template_paths;
    note explain \@cpaths;

    is_deeply \@cpaths, [
        catdir($ENV{MT_TEST_ROOT}, "plugins/${component}/tmpl/admin1998"),
        catdir($ENV{MT_TEST_ROOT}, "plugins/${component}/tmpl"),
        catdir($ENV{MT_TEST_ROOT}, "plugins/${component}"),
        catdir($mt_dir,            "alt-tmpl/${admin_theme_id}"),
        catdir($mt_dir,            "alt-tmpl/admin1999"),
        catdir($mt_dir,            "alt-tmpl/admin1998"),
        catdir($mt_dir,            "alt-tmpl"),
        catdir($mt_dir,            "tmpl/${admin_theme_id}/cms"),
        catdir($mt_dir,            "tmpl/cms"),
        catdir($mt_dir,            "tmpl/${admin_theme_id}"),
        catdir($mt_dir,            "tmpl"),
    ];
};

done_testing;
