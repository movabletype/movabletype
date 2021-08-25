#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        PluginPath => [qw(
            MT_HOME/plugins
            MT_HOME/t/plugins
            TEST_ROOT/plugins
        )]
    );
    $ENV{MT_CONFIG} = $test_env->config_file;

    my $config_yaml = 'plugins/TestSearch/config.yaml';
    $test_env->save_file( $config_yaml, <<'YAML' );
id: test_search
key: test_search
name: TestSearch
author: test
applications:
  cms:
    search_apis:
      entry:
        handler: $TestSearch::TestSearch::handler
YAML

    $test_env->save_file('plugins/TestSearch/lib/TestSearch.pm', <<'PM');
package #
    TestSearch;
sub handler {}
1;
PM
}

use MT::Test;
use MT::Test::App;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);
my $blog_id = 1;

my $app = MT::Test::App->new('MT::App::CMS');
$app->login($admin);

$app->get_ok(
    {   __mode  => 'search_replace',
        blog_id => $blog_id,
    }
);

my $form = $app->form;
$form->param( search => "Rainy" );
my $do_search = $form->find_input('do_search');
$do_search->readonly(0);
$do_search->value(1);

$app->post_ok( $form->click );
ok !$app->generic_error, "no error";
note $app->generic_error if $app->generic_error;

done_testing;
