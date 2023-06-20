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
    $admin_theme_id = 'admin2023';
    $test_env       = MT::Test::Env->new(
        DefaultLanguage => 'en_US',           ## for now
        AdminThemeId    => $admin_theme_id,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use File::Spec::Functions qw(catdir);
use Test::Deep qw(cmp_deeply superbagof);

my $fmgr;
my @alt_paths;

BEGIN {
    @alt_paths = MT->config('AltTemplatePath');
    require MT::FileMgr;
    $fmgr = MT::FileMgr->new('Local');

    foreach my $alt_path (@alt_paths) {
        $fmgr->mkpath(catdir($alt_path, $admin_theme_id));
    }
    note "startup";
}

END {
    @alt_paths = MT->config('AltTemplatePath');
    foreach my $alt_path (@alt_paths) {
        $fmgr->rmdir(catdir($alt_path, $admin_theme_id));
    }
    note "shutdown";
}

my $mt_dir = MT->instance->mt_dir;

subtest 'MT::template_paths' => sub {
    my $mt = MT->instance;
    $mt->{template_dir} = 'cms';

    my @paths = $mt->template_paths;
    note explain \@paths;

    cmp_deeply \@paths, superbagof(
        catdir($mt_dir, "alt-tmpl/${admin_theme_id}"),
        catdir($mt_dir, "alt-tmpl"),
        catdir($mt_dir, "tmpl/${admin_theme_id}/cms"),
        catdir($mt_dir, "tmpl/cms"),
        catdir($mt_dir, "tmpl/${admin_theme_id}"),
        catdir($mt_dir, "tmpl"),
    );
};

subtest 'Component::template_paths' => sub {
    my $mt = MT->instance;
    $mt->{template_dir} = 'cms';
    my $component = 'BlockEditor';
    my $c         = $mt->component($component);

    my @cpaths = $c->template_paths;
    note explain \@cpaths;

    cmp_deeply \@cpaths, superbagof(
        catdir($mt_dir, "plugins/${component}/tmpl/${admin_theme_id}"),
        catdir($mt_dir, "plugins/${component}/tmpl"),
        catdir($mt_dir, "plugins/${component}"),
        catdir($mt_dir, "alt-tmpl/${admin_theme_id}"),
        catdir($mt_dir, "alt-tmpl"),
        catdir($mt_dir, "tmpl/${admin_theme_id}/cms"),
        catdir($mt_dir, "tmpl/cms"),
        catdir($mt_dir, "tmpl/${admin_theme_id}"),
        catdir($mt_dir, "tmpl"),
    );
};

done_testing;
