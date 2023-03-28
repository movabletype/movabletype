use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => ['TEST_ROOT/plugins'],
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file("plugins/MyPlugin/MyPlugin.pl", <<'PLUGIN' );
package MyPlugin;
require MT;
require MT::Plugin;
our ($flag2, $flag3);
MT->add_plugin(MT::Plugin->new({
    id => 'my_plugin',
    name => 'MyPlugin',
    version => 1,
    registry => {
        list_properties => {
            entry => {
                my_plugin_field1 => {base => '__virtual.integer'},
                my_plugin_field2 => {base => '__virtual.integer', condition => sub { $flag2 }},
                my_plugin_field3 => {base => '__virtual.integer', condition => sub { $flag3 }},
            },
        },
    },
}));
PLUGIN
}

use MT::Test;
use MT::Test::Permission;
use MT::ListProperty;

$test_env->prepare_fixture('db');

my $site  = MT->model('blog')->load(1);
my $child_site = MT::Test::Permission->make_blog(parent_id => 1);
my $app = MT->instance;

subtest 'blog_name' => sub {

    subtest 'site context' => sub {
        my $blog = MT->model('blog')->load(1);
        $app->blog($site);
        my $prop = MT::ListProperty->list_properties('entry');
        ok exists $prop->{blog_name};
    };

    subtest 'child site context' => sub {
        $app->blog($child_site);
        my $prop = MT::ListProperty->list_properties('entry');
        ok !exists $prop->{blog_name};
    };

    is(keys %MT::ListProperty::CachedListProperties, 1, 'cache is stored');
    %MT::ListProperty::CachedListProperties = ();
};

subtest 'plugin field' => sub {

    subtest 'case 1' => sub {
        $MyPlugin::flag2 = 0;
        $MyPlugin::flag3 = 0;
        my $prop = MT::ListProperty->list_properties('entry');
        ok exists $prop->{my_plugin_field1};
        ok !exists $prop->{my_plugin_field2};
        ok !exists $prop->{my_plugin_field3};
    };

    is(keys %MT::ListProperty::CachedListProperties, 1, 'cache is stored');

    subtest 'case 2' => sub {
        $MyPlugin::flag2 = 1;
        $MyPlugin::flag3 = 1;
        my $prop = MT::ListProperty->list_properties('entry');
        ok exists $prop->{my_plugin_field1};
        ok exists $prop->{my_plugin_field2};
        ok exists $prop->{my_plugin_field3};
    };

    subtest 'case 3' => sub {
        $MyPlugin::flag2 = 0;
        $MyPlugin::flag3 = 1;
        my $prop = MT::ListProperty->list_properties('entry');
        ok exists $prop->{my_plugin_field1};
        ok !exists $prop->{my_plugin_field2};
        ok exists $prop->{my_plugin_field3};
    };

    %MT::ListProperty::CachedListProperties = ();
};

done_testing;
