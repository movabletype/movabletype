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
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Author;
use MT::Blog;
use MT::Test;
use MT::Test::App;

$test_env->prepare_fixture('db_data');

my $blog = MT::Blog->load(1);
my $user = MT::Author->load(2);

# global search for a template
# __mode=search_replace&_type=template&do_search=1&search=hello
my $app = MT::Test::App->new('MT::App::CMS');
$app->login($user);
$app->get_ok({
    __mode    => 'search_replace',
    do_search => 1,
    search    => 'movable',
    _type     => 'template',
});
$app->content_unlike(qr/Publish selected templates/i, "Publish templates button isn't present for global template search");
$app->content_like(qr/Delete selected templates/i, "Delete templates button is present");
$app->content_like(qr/Refresh template\(s\)/i,     "Refresh templates dropdown is present");
$app->content_like(qr/Clone template\(s\)/i,       "Clone templates dropdown is present");

# blog search for a template
# __mode=search_replace&_type=template&do_search=1&search=hello&blog_id=1
$app->get_ok({
    __mode    => 'search_replace',
    blog_id   => $blog->id,
    do_search => 1,
    search    => 'index',
    _type     => 'template',
});
$app->content_like(qr/Publish selected templates/i, "Publish templates button is present");
$app->content_like(qr/Delete selected templates/i,  "Delete templates button is present");
$app->content_like(qr/Refresh template\(s\)/i,      "Refresh templates dropdown is present");
$app->content_like(qr/Clone template\(s\)/i,        "Clone templates dropdown is present");

# global search for an entry
# __mode=search_replace&_type=entry&do_search=1&search=hello
$app->get_ok({
    __mode    => 'search_replace',
    blog_id   => 0,
    do_search => 1,
    search    => 'rain',
    _type     => 'entry',
});
$app->content_like(qr/Republish selected entries/i, "Publish entries button is present");
$app->content_like(qr/Delete selected entries/i,    "Delete entries button is present");
$app->content_like(qr/Add tags/i,                   "Add tags dropdown is present");
$app->content_like(qr/Remove tags/i,                "Remove tags dropdown is present");

# blog seaarch for an entry
# __mode=search_replace&_type=entry&do_search=1&search=hello&blog_id=1
$app->get_ok({
    __mode    => 'search_replace',
    blog_id   => $blog->id,
    do_search => 1,
    search    => 'rain',
    _type     => 'entry',
});
$app->content_like(qr/Republish selected entries/i, "Publish entries button is present");
$app->content_like(qr/Delete selected entries/i,    "Delete entries button is present");
$app->content_like(qr/Unpublish entries/i,          "Unpublish entries dropdown is present");
$app->content_like(qr/Add tags/i,                   "Add tags dropdown is present");
$app->content_like(qr/Remove tags/i,                "Remove tags dropdown is present");
$app->content_like(qr/Batch edit entries/i,         "Batch edit entries dropdown is present");

subtest 'comment' => sub {
    $test_env->skip_unless_plugin_exists('Comments');
    # global search for a comment
    # __mode=search_replace&_type=comment&do_search=1&search=hello
    $app->get_ok({
        __mode    => 'search_replace',
        blog_id   => 0,
        do_search => 1,
        search    => 'comment',
        _type     => 'comment',
    });

    # blog search for a comment
    # __mode=search_replace&_type=comment&do_search=1&search=hello&blog_id=1
    $app->get_ok({
        __mode    => 'search_replace',
        blog_id   => $blog->id,
        do_search => 1,
        search    => 'comment',
        _type     => 'comment',
    });
};

done_testing;
