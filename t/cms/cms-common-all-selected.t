#!/usr/bin/perl

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
use MT::Association;
use MT::Author;
use MT::Blog;
use MT::Role;
use MT::Website;
use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

$test_env->prepare_fixture('db');

my $admin   = MT::Author->load(1);
my $website = MT::Website->load(1);

subtest 'Remove all members with all_selected = 1.' => sub {
    my $role = MT::Role->load({ name => MT->translate('Site Administrator') });

    for (my $cnt = 0; $cnt < 5; $cnt++) {
        my $name   = "user$cnt";
        my $author = MT::Test::Permission->make_author(
            name     => $name,
            nickname => $name,
        );
        MT::Association->link($author, $role, $website->id);
    }

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode       => 'remove_user_assoc',
        _type        => 'member',
        action_name  => 'remove_user_assoc',
        blog_id      => $website->id,
        all_selected => 1,
    });
    ok($app->last_location->query_param('saved'), 'saved');
};

subtest 'Delete all blogs with all_selected = 1.' => sub {
    foreach my $blog_id (0, 1) {

        for (my $cnt = 0; $cnt < 5; $cnt++) {
            MT::Test::Permission->make_blog(blog_id => $website->id,);
        }

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->post_ok({
                __mode       => 'delete',
                _type        => 'blog',
                action_name  => 'delete',
                blog_id      => $blog_id,
                all_selected => 1,
            },
        );
        ok($app->last_location->query_param('saved_deleted'), 'saved_deleted=1');
        is(
            MT::Blog->count({ parent_id => $website->id }),
            0, 'All blog in website have been deleted.'
        );
    }
};

done_testing;
