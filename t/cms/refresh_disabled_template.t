use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => [
            qw(
                MT_HOME/plugins
                MT_HOME/t/plugins
                TEST_ROOT/plugins
                )
        ]
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    my $config_yaml = 'plugins/TestTemplate/config.yaml';
    $test_env->save_file( $config_yaml, <<'YAML' );
id: test
key: test
name: TestTemplate
version: 2
author: test

default_templates:
    base_path: default_templates
    'global:email':
        test_email:
            label: Test email
            text: Test email text
YAML
}

use MT::Test;
use MT::Test::App;

## Explicitly ->init_data to include plugin setting
$test_env->prepare_fixture( sub { MT::Test->init_db; MT::Test->init_data } );

my $admin = MT::Author->load(1);

my $test_template = template_is_ok();

my $app = MT::Test::App->new('MT::App::CMS');
$app->login($admin);

$app->post_ok(
    {   __mode      => 'plugin_control',
        return_args => '__mode%3Dcfg_plugins%26blog_id%3D0',
        state       => 'off',
        plugin_sig  => 'TestTemplate',
    }
);

my $log = $test_env->slurp_logfile;
like $log => qr/Plugin 'TestTemplate' is disabled/, "plugin is now disabled";

# reset MT
$MT::plugins_installed = 0;
$MT::MT_DIR            = undef;
%MT::Plugins           = @MT::Components = %MT::Components = ();
MT->instance->init;

my $res = $app->post_ok(
    {   __mode                 => 'itemset_action',
        _type                  => 'template',
        action_name            => 'refresh_tmpl_templates',
        itemset_action_input   => '',
        return_args            => '__mode%3Dlist_template%26blog_id%3D0',
        plugin_action_selector => 'refresh_tmpl_templates',
        id                     => $test_template->id,
    }
);

$app->content_unlike("Refreshing template <strong>Test email</strong>");
$app->content_like(qr/Skipping template 'Test email' since it (?:appears to be a custom template|has not been changed)./);

template_is_ok();

done_testing;

sub template_is_ok {
    my $test_template = MT::Template->load( { blog_id => 0, identifier => 'test_email' } );
    ok $test_template, "test_email exists" or return;
    is $test_template->text => 'Test email text', "template text is correct" or return;
    $test_template;
}
