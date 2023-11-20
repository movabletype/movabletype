use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file('themes/ThemeWithBlogStatic/theme.yaml', <<'YAML');
id: theme_with_blog_static
name: theme_with_blog_static
label: Theme With Blog Static
class: website
elements:
    blog_static_files:
        data:
            - images
        importer: blog_static_files
YAML

    $test_env->save_file('themes/ThemeWithSiteStatic/theme.yaml', <<'YAML');
id: theme_with_site_static
name: theme_with_site_static
label: Theme With Site Static
class: website
elements:
    site_static_files:
        data:
            - images
        importer: site_static_files
YAML

    $test_env->save_file('themes/ThemeWithStatic/theme.yaml', <<'YAML');
id: theme_with_static
name: theme_with_static
label: Theme With Static
class: website
elements:
    static_files:
        data:
            - images
        importer: static_files
YAML
}

use MT::Test;
use MT::Test::App;
use MT::Test::Fixture;
use MT::Test::Image;
use File::Path;
use YAML::Tiny;

MT->instance;

$test_env->prepare_fixture('db');

my $objs = MT::Test::Fixture->prepare({
    website => [{
            name      => 'Site1',
            site_path => 'TEST_ROOT/site1',
        }, {
            name      => 'Site2',
            site_path => 'TEST_ROOT/site2',
        }, {
            name      => 'Site3',
            site_path => 'TEST_ROOT/site3',
        }
    ],
});

my $admin = MT->model('author')->load(1);

for my $path (qw(ThemeWithBlogStatic/blog_static ThemeWithSiteStatic/site_static ThemeWithStatic/static)) {
    my $dir = $test_env->path("themes/$path");
    mkpath "$dir/images";
    my ($basename) = $path =~ /(\w+)$/;
    MT::Test::Image->write(type => 'png', file => $test_env->path("themes/$path/images/$basename.png"));
}

subtest 'Apply BlogStatic' => sub {
    my $site = $objs->{website}{Site1};

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->post_ok({
        __mode   => 'apply_theme',
        blog_id  => $site->id,
        theme_id => 'ThemeWithBlogStatic',
    });
    $app->has_no_permission_error;
    ok($app->last_location->query_param('applied'), 'theme has been applied.');

    my $imported_image = File::Spec->catfile($site->site_path, 'images/blog_static.png');
    ok -f $imported_image, "an imported image exists";
    }
    if 0;

subtest 'Apply SiteStatic' => sub {
    my $site = $objs->{website}{Site2};

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->post_ok({
        __mode   => 'apply_theme',
        blog_id  => $site->id,
        theme_id => 'ThemeWithSiteStatic',
    });
    $app->has_no_permission_error;
    ok($app->last_location->query_param('applied'), 'theme has been applied.');

    my $imported_image = File::Spec->catfile($site->site_path, 'images/site_static.png');
    ok -f $imported_image, "an imported image exists";
    }
    if 0;

subtest 'Apply Static' => sub {
    my $site = $objs->{website}{Site3};

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->post_ok({
        __mode   => 'apply_theme',
        blog_id  => $site->id,
        theme_id => 'ThemeWithStatic',
    });
    $app->has_no_permission_error;
    ok($app->last_location->query_param('applied'), 'theme has been applied.');

    my $imported_image = File::Spec->catfile($site->site_path, 'images/static.png');
    ok -f $imported_image, "an imported image exists";

    subtest 'Export with static' => sub {
        # set details first
        $app->get_ok({
            __mode      => 'theme_element_detail',
            blog_id     => $site->id,
            exporter_id => 'static_files',
            dialog      => 1,
        });
        $app->post_form_ok({
            static_directories => 'images',
        });

        # do export
        $app->get_ok({
            __mode  => 'export_theme',
            blog_id => $site->id,
        });
        $app->post_form_ok;
        like($app->message_text => qr/Theme package have been saved/, 'theme has been exported successfully.');

        ok -f $test_env->path("themes/theme_from_site3/static/images/static.png"), "exported image exists";
        my $exported_yaml_file = $test_env->path("themes/theme_from_site3/theme.yaml");
        my $theme_yaml         = YAML::Tiny::LoadFile($exported_yaml_file);
        ok $theme_yaml->{elements}{static_files}, "has static_files element";
        is $theme_yaml->{elements}{static_files}{data}[0] => 'images', "has images as the first data";
    };
};

done_testing;
