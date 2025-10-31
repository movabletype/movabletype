#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        Editor => 'tinymce',
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::App;

$test_env->prepare_fixture('db_data');

my $app  = MT->instance;
my $user = $app->model('author')->load(1);
my $blog = $app->model('blog')->load(1);

my $cms = MT::Test::App->new('MT::App::CMS');
$cms->login($user);
$cms->get_ok({
    __mode  => 'view',
    blog_id => $blog->id,
    _type   => 'entry',
});

my @loaded_scripts = $cms->content =~ m{(/plugins/TinyMCE6/lib/js/adapter.js)}g;
is scalar(@loaded_scripts), 1, 'editor script is loaded exactly once';

done_testing();
