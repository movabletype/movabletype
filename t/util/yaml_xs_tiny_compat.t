use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use MT::Test::Util::Plugin;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        ThemesDirectory => 'TEST_ROOT/themes',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test::App;
use MT::Util::YAML;
use MT::Util::YAML::Tiny;
use MT::Test::Permission;
use File::Path;
use Path::Tiny;

$test_env->prepare_fixture('db_data');

MT->instance;

my $admin = MT::Author->load(1);
my $site  = MT::Website->load(1);

local $ENV{MT_TEST_RUN_APP_AS_CGI} = 1;

subtest 'YAML::Tiny interoperability (MTC-31695)' => sub {
    for my $module (qw(YAML::XS YAML::Syck YAML::Tiny)) {
        eval "require $module; 1" or plan skip_all => "$module not available";

        subtest $module => sub {
            my $user_themes_directory = $test_env->path('themes');
            rmtree $user_themes_directory if -d $user_themes_directory;
            mkpath $user_themes_directory;

            $test_env->update_config(YAMLModule => $module);

            MT::Util::YAML::_find_module($module);
            ok $MT::Util::YAML::Module eq 'MT::Util::' . $module, "MT::Util::YAML uses $module now";

            (my $name = lc $module) =~ s/^yaml:://;

            my $app = MT::Test::App->new;
            $app->login($admin);
            $app->get_ok({
                __mode  => 'export_theme',
                blog_id => $site->id,
            });

            my $theme_id = "exported_theme_by_$name";
            $app->post_form_ok({
                theme_id => $theme_id,
            });

            my $theme_yaml = $test_env->path("themes/$theme_id/theme.yaml");
            ok -f $theme_yaml, "theme.yaml exists: $theme_yaml";

            my $loaded = MT::Util::YAML::Tiny::LoadFile($theme_yaml);
            ok exists $loaded->{elements}{default_categories}{data}{':order'}, ":order exists correctly";

            $test_env->update_config(YAMLModule => 'YAML::Tiny');

            MT::Util::YAML::_find_module('YAML::Tiny');
            ok $MT::Util::YAML::Module eq 'MT::Util::YAML::Tiny', "MT::Util::YAML uses YAML::Tiny now";

            $app = MT::Test::App->new;
            $app->login($admin);
            $app->post_ok({
                __mode   => 'apply_theme',
                blog_id  => $site->id,
                theme_id => $theme_id,
            });
            ok !$app->generic_error, "no error";

        };
    }
};

done_testing;
