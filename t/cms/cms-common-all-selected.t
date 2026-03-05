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
use MT::ContentStatus;
use MT::Role;
use MT::Website;
use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

$test_env->prepare_fixture('db');

my $admin   = MT::Author->load(1);
my $website = MT::Website->load(1);

subtest 'Unpublish all content data with author_name filter and all_selected = 1.' => sub {
    my $user1 = MT::Test::Permission->make_author;
    $user1->is_superuser(1);
    $user1->save or die $user1->errstr;

    my $user2 = MT::Test::Permission->make_author;
    $user2->is_superuser(1);
    $user2->save or die $user2->errstr;

    my $content_type = MT::Test::Permission->make_content_type(blog_id => $website->id);
    $content_type->fields([]);
    $content_type->save or die $content_type->errstr;

    my $content_data_1 = MT::Test::Permission->make_content_data(
        author_id       => $user1->id,
        blog_id         => $website->id,
        content_type_id => $content_type->id,
        status          => MT::ContentStatus::RELEASE(),
    );

    my $content_data_2 = MT::Test::Permission->make_content_data(
        author_id       => $user2->id,
        blog_id         => $website->id,
        content_type_id => $content_type->id,
        status          => MT::ContentStatus::RELEASE(),
    );

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user1);
    my $user1_name = $user1->name;
    $app->post_ok({
        __mode       => 'itemset_action',
        _type        => 'content_data',
        action_name  => 'set_draft',
        blog_id      => $website->id,
        type         => 'content_data_' . $content_type->id,
        all_selected => 1,
        items        => qq/[{"args":{"option":"contains","string":"${user1_name}"},"type":"author_name"}]/,
    });

    $content_data_1->refresh;
    is $content_data_1->status, MT::ContentStatus::HOLD();

    $content_data_2->refresh;
    is $content_data_2->status, MT::ContentStatus::RELEASE();
};

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
