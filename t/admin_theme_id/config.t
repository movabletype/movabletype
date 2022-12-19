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
    $admin_theme_id = 'bootstrap5';
    $test_env       = MT::Test::Env->new(
        DefaultLanguage => 'en_US',           ## for now
        AdminThemeId    => $admin_theme_id,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;

my $fmgr;
my @alt_paths;

BEGIN {
    @alt_paths = MT->config('AltTemplatePath');
    require MT::FileMgr;
    $fmgr = MT::FileMgr->new('Local');

    foreach my $alt_path (@alt_paths) {
        $fmgr->mkpath(File::Spec->catdir($alt_path, $admin_theme_id));
    }
    note "startup";
}

END {
    @alt_paths = MT->config('AltTemplatePath');
    foreach my $alt_path (@alt_paths) {
        $fmgr->rmdir(File::Spec->catdir($alt_path, $admin_theme_id));
    }
    note "shutdown";
}

subtest 'MT::template_paths' => sub {
    my $mt = MT->instance;
    $mt->{template_dir} = 'cms';

    my @paths = $mt->template_paths;

    is($paths[0], "/var/www/cgi-bin/mt/alt-tmpl/${admin_theme_id}", "alt-tmpl/${admin_theme_id}");
    is($paths[1], "/var/www/cgi-bin/mt/alt-tmpl",                   "alt-tmpl");
    is($paths[2], "/var/www/cgi-bin/mt/tmpl/${admin_theme_id}/cms", "tmpl/${admin_theme_id}/cms");
    is($paths[3], "/var/www/cgi-bin/mt/tmpl/cms",                   "tmpl/cms");
    is($paths[4], "/var/www/cgi-bin/mt/tmpl/${admin_theme_id}",     "tmpl/${admin_theme_id}");
    is($paths[5], "/var/www/cgi-bin/mt/tmpl",                       "tmpl");

    done_testing;
};

subtest 'Component::template_paths' => sub {
    my $mt = MT->instance;
    $mt->{template_dir} = 'cms';
    my $component = 'GoogleAnalyticsV4';
    my $c         = $mt->component($component);

    my @cpaths = $c->template_paths;

    is($cpaths[0], "/var/www/cgi-bin/mt/plugins/${component}/tmpl/${admin_theme_id}", "plugins/${component}/tmpl/${admin_theme_id}");
    is($cpaths[1], "/var/www/cgi-bin/mt/plugins/${component}/tmpl",                   "plugins/${component}/tmpl");
    is($cpaths[2], "/var/www/cgi-bin/mt/plugins/${component}",                        "plugins/${component}");
    is($cpaths[3], "/var/www/cgi-bin/mt/alt-tmpl/${admin_theme_id}",                  "alt-tmpl/${admin_theme_id}");
    is($cpaths[4], "/var/www/cgi-bin/mt/alt-tmpl",                                    "alt-tmpl");
    is($cpaths[5], "/var/www/cgi-bin/mt/tmpl/${admin_theme_id}/cms",                  "tmpl/${admin_theme_id}/cms");
    is($cpaths[6], "/var/www/cgi-bin/mt/tmpl/cms",                                    "tmpl/cms");
    is($cpaths[7], "/var/www/cgi-bin/mt/tmpl/${admin_theme_id}",                      "tmpl/${admin_theme_id}");
    is($cpaths[8], "/var/www/cgi-bin/mt/tmpl",                                        "tmpl");

    done_testing;
};

done_testing;
