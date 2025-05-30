#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;

BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';

    $test_env = MT::Test::Env->new(
        PluginPath => [qw(
            TEST_ROOT/plugins
        )]);
    $ENV{MT_CONFIG} = $test_env->config_file;

    my $config_yaml = 'plugins/ExtendsTemplate/config.yaml';
    $test_env->save_file($config_yaml, <<'YAML' );
id: extends_template
key: extends_template
name: Extends Template
object_types:
  template:
    custom_template_name: 'string meta'
callbacks:
  DefaultTemplateFilter: |
    sub {
      my ($cb, $tmpls) = @_;
      push @$tmpls, {
        type                 => 'system',
        name                 => 'test template',
        text                 => 'test template',
        custom_template_name => 'custom template name',
      }
    }
YAML
}

use MT;
use MT::Test;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

MT::Test->init_cms;

# Create records
my $admin = MT::Author->load(1);
ok($admin);

my $app = MT->instance;
$app->user($admin);

my $website = MT::Website->load();

subtest 'create_default_templates' => sub {
    my $blog = MT::Test::Permission->make_blog(parent_id => $website->id,);
    MT->model('template')->remove({ blog_id => $blog->id });
    $blog->create_default_templates;

    my $template = MT->model('template')->load({
        blog_id => $blog->id,
        name    => 'test template',
    });
    is($template->custom_template_name, 'custom template name');
};

done_testing;
