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

subtest 'clone_children' => sub {
    my $child_site   = MT::Test::Permission->make_blog(parent_id => $website->id);
    my $content_type = MT::Test::Permission->make_content_type(blog_id => $child_site->id);
    $content_type->fields([]);
    $content_type->save or die $content_type->errstr;
    my $tmpl_ct = MT::Test::Permission->make_template(
        blog_id         => $child_site->id,
        content_type_id => $content_type->id,
        type            => 'ct',
    );
    my $tmpl_ct_archive = MT::Test::Permission->make_template(
        blog_id         => $child_site->id,
        content_type_id => $content_type->id,
        type            => 'ct_archive',
    );
    my $map_ct = MT::Test::Permission->make_templatemap(
        archive_type  => 'ContentType',
        blog_id       => $child_site->id,
        file_template => 'author/%-a/%-f',
        is_preferred  => 1,
        template_id   => $tmpl_ct->id,
    );
    my $map_ct_archive = MT::Test::Permission->make_templatemap(
        archive_type  => 'ContentType-Daily',
        blog_id       => $child_site->id,
        file_template => '%y/%m/%d/%f',
        is_preferred  => 1,
        template_id   => $tmpl_ct_archive->id,
    );

    my $clone_site = $child_site->clone_with_children({
        classes => {
            'MT::Template' => 1,
        } });

    ok $clone_site, 'source child site has been cloned';

    ok(
        MT->model('template')->count({ blog_id => $clone_site->id }) > 0,
        'templates have been cloned from source child site',
    );
    is(
        MT->model('template')->count({
            blog_id => $child_site->id,
            type    => ['ct', 'ct_archive'],
        }),
        2,
        'source child site has templates related content type',
    );
    is(
        MT->model('template')->count({
            blog_id => $clone_site->id,
            type    => ['ct', 'ct_archive'],
        }),
        0,
        'cloned child site does not have templates related content type',
    );

    ok(
        MT->model('templatemap')->count({ blog_id => $clone_site->id }) > 0,
        'template maps have been cloned from source child site',
    );
    is(
        MT->model('templatemap')->count({
            blog_id      => $child_site->id,
            archive_type => { like => '%ContentType%' },
        }),
        2,
        'source child site has template maps related content type',
    );
    is(
        MT->model('templatemap')->count({
            blog_id      => $clone_site->id,
            archive_type => { like => '%ContentType%' },
        }),
        0,
        'cloned child site does not have template maps related content type',
    );
};

done_testing;
