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
$tmpl->linked_file('file_link_test');
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
    is(linked_file(),         "testA", "right text");
};

subtest 'file modified before save' => sub {
    linked_file('testB');

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
    is(linked_file(),         "testC", "right text");
};

subtest 'file modified before save and rebuild (MTC-28852)' => sub {
    linked_file('testD');

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({ __mode => 'view', _type => 'template', blog_id => $blog->id, type => 'index', id => $tmpl_id });
    $app->post_form_ok('template-listing-form', { text => 'testE', rebuild => 'Y' });
    my $tmpl = MT::Template->load($tmpl_id);
    is($tmpl->column('text'), 'testE', 'right db value');
    is(linked_file(),         "testE", "right text");
};

done_testing;

sub linked_file {
    my $new_text = shift;
    if (defined $new_text) {
        open my $fh, '>', "$test_root/site/file_link_test" or die 'failed to open';
        print $fh $new_text;
        return $new_text;
    } else {
        open my $fh, '<', "$test_root/site/file_link_test" or die 'failed to open';
        local $/;
        return <$fh>;
    }
}
