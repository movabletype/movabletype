use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;
BEGIN {
    plan skip_all => 'set MT_TEST_TAG_WITH_PLUGIN_COLUMNS to test' unless $ENV{MT_TEST_TAG_WITH_PLUGIN_COLUMNS};

    $test_env = MT::Test::Env->new(PluginPath => ['TEST_ROOT/plugins']);
    $ENV{MT_CONFIG} = $test_env->config_file;

    $test_env->save_file("plugins/MyPlugin/MyPlugin.pl", <<'PLUGIN' );
package MyPlugin;
require MT;
require MT::Plugin;
MT->add_plugin(MT::Plugin->new({
    id => 'my_plugin',
    name => 'MyPlugin',
    version => 1,
    registry => {
        object_types => {
            blog => {
                my_col => 'integer',
                my_meta_col => 'integer meta',
            },
            entry => {
                my_col => 'integer',
                my_meta_col => 'integer meta',
            },
        },
    },
}));
PLUGIN
}

use MT::Test::Tag;
use MT::Test;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

my $site       = MT->model('website')->load(1);
my $site_id    = $site->id;
my $child_site = MT::Test::Permission->make_blog(parent_id => $site_id);
my $app        = MT->instance;
my $entry1     = MT::Test::Permission->make_entry(blog_id => $site_id, title => 'entry1');

MT::Test::Tag->run_perl_tests($site_id);
MT::Test::Tag->run_php_tests($site_id);

done_testing;

__DATA__

=== has plugin for tests
--- template
<MTHasPlugin name="MyPlugin">has MyPlugin<MTElse>doesn't have MyPlugin</MTHasPlugin>
--- expected
has MyPlugin

=== No dynamic properties warnings for plugin-generated columns on php8.2 (MTC-29236)
--- template
<mt:Blogs><$mt:BlogURL$></mt:Blogs>
--- expected regexp
/nana/

=== Entries
--- template
<mt:Entries>[<$mt:EntryID$>]</mt:Entries>
--- expected regexp
[1]
