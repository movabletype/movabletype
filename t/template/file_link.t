#!/usr/bin/perl -w

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
}

use MT;
use MT::Blog;
use MT::Entry;
use MT::Template;
use MT::Test;
use MT::Test::App;
use Path::Tiny;
my $linked_file = Path::Tiny::path($test_env->path('linked_file'));

my $test_root = $ENV{MT_TEST_ROOT} || "$ENV{MT_HOME}/t";

$test_env->prepare_fixture('db');

my $mt = MT->new or die MT->errstr;

my $blog = MT::Blog->load(1);
$blog->site_path("$test_root/site/");
$blog->save;

my $tmpl = MT::Template->new;
$tmpl->blog_id($blog->id);
$tmpl->name('mytemplate');
$tmpl->text('test');
$tmpl->type('index');
$tmpl->linked_file($linked_file);
$tmpl->save;
my $tmpl_id = $tmpl->id;

my $admin = MT::Author->load(1);

subtest 'basic' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({ __mode => 'view', _type => 'template', blog_id => $blog->id, type => 'index', id => $tmpl_id });
    $app->post_form_ok('template-listing-form', { text => 'testA' });
    my $tmpl = MT::Template->load($tmpl_id);
    is($tmpl->column('text'), 'testA', 'right db value');
    is($linked_file->slurp,   "testA", "right text");
};

subtest 'file modified before save' => sub {
    $linked_file->spew('testB');

    subtest 'file modification reflected' => sub {
        my $tmpl = MT::Template->load($tmpl_id);
        is($tmpl->column('text'), 'testA', 'right db value');
        is($tmpl->text,           'testB', 'right db value');
    };

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({ __mode => 'view', _type => 'template', blog_id => $blog->id, type => 'index', id => $tmpl_id });
    $app->post_form_ok('template-listing-form', { text => 'testC' });
    my $tmpl = MT::Template->load($tmpl_id);
    is($tmpl->column('text'), 'testC', 'right db value');
    is($linked_file->slurp,   "testC", "right text");
};

subtest 'file modified before save and rebuild (MTC-28852)' => sub {
    $linked_file->spew('testD');

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({ __mode => 'view', _type => 'template', blog_id => $blog->id, type => 'index', id => $tmpl_id });
    $app->post_form_ok('template-listing-form', { text => 'testE', rebuild => 'Y' });
    my $tmpl = MT::Template->load($tmpl_id);
    is($tmpl->column('text'), 'testE', 'right db value');
    is($linked_file->slurp,   "testE", "right text");
};

done_testing;
