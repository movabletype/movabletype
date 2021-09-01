#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;

BEGIN {
    eval { require Test::MockObject }
        or plan skip_all => 'Test::MockObject is not installed';
}

use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Test::MockObject::Extends;
use MT;
use MT::Test;
use MT::ContentStatus;
use MT::Test::Permission;
use MT::RebuildTrigger qw(EVENT_SAVE EVENT_PUBLISH EVENT_UNPUBLISH);

$test_env->prepare_fixture('db');
my $site = MT::Test::Permission->make_website(name => 'test website');
my $child = MT::Test::Permission->make_blog(parent_id => $site->id, name => 'test blog');
my @cd;
for my $i (1..3) {
    my $ct = MT::Test::Permission->make_content_type(blog_id => $site->id, name => 'test content type' . $i);

    my $cf = MT::Test::Permission->make_content_field(
        blog_id => $ct->blog_id, content_type_id => $ct->id, name => 'single text', type => 'single_line_text',
    );

    $ct->fields([
        { id => $cf->id, label => 1, name => $cf->name, order => 1, type => $cf->type, unique_id => $cf->unique_id },
    ]);
    $ct->save;

    my $cd = MT::Test::Permission->make_content_data(
        blog_id         => $ct->blog_id, author_id => 1,
        content_type_id => $ct->id,      data      => { $cf->id => 'test text' });

    push @cd, $cd;

    next if $i == 3;

    for my $e (EVENT_SAVE(), EVENT_PUBLISH(), EVENT_UNPUBLISH()) {
        my $rt = MT::RebuildTrigger->new;
        $rt->blog_id( $child->id );
        $rt->object_type( MT::RebuildTrigger::TYPE_CONTENT_TYPE() );
        $rt->action( MT::RebuildTrigger::ACTION_RI() );
        $rt->event( $e );
        $rt->target( MT::RebuildTrigger::TARGET_BLOG() );
        $rt->target_blog_id( $site->id );
        $rt->ct_id( $ct->id );
        $rt->save;
    }
}

my $app     = MT->instance;
my $request = MT::Request->instance;

subtest 'two triggers for content types' => sub {
    my $rebuild_count = 0;
    $app = Test::MockObject::Extends->new($app);
    $app->mock('rebuild_indexes', sub { $rebuild_count++ });
    my $cb = MT::Callback->new;

    $request->{__stash} = {};
    MT::RebuildTrigger->post_content_save( $cb, $app, $cd[0] );
    is( $rebuild_count, 1, 'rebuild invoked for save' );
    $request->{__stash} = {};
    MT::RebuildTrigger->post_content_save( $cb, $app, $cd[1] );
    is( $rebuild_count, 2, 'rebuild invoked for save again' );
    $request->{__stash} = {};
    MT::RebuildTrigger->post_content_pub( $cb, $app, $cd[0] );
    is( $rebuild_count, 3, 'rebuild invoked for pub' );
    $request->{__stash} = {};
    MT::RebuildTrigger->post_content_pub( $cb, $app, $cd[1] );
    is( $rebuild_count, 4, 'rebuild invoked for pub again' );
    $request->{__stash} = {};
    MT::RebuildTrigger->post_content_save( $cb, $app, $cd[2] );
    is( $rebuild_count, 4, 'rebuild not invoked' );
    $request->{__stash} = {};
    MT::RebuildTrigger->post_content_pub( $cb, $app, $cd[2] );
    is( $rebuild_count, 4, 'rebuild not invoked' );
    $request->{__stash} = {};

    $cd[0]->status(MT::ContentStatus::UNPUBLISH());
    $cd[1]->status(MT::ContentStatus::UNPUBLISH());

    MT::RebuildTrigger->post_content_unpub( $cb, $app, $cd[0] );
    is( $rebuild_count, 5, 'rebuild invoked for unpub' );
    $request->{__stash} = {};
    MT::RebuildTrigger->post_content_unpub( $cb, $app, $cd[1] );
    is( $rebuild_count, 6, 'rebuild invoked for unpub again' );
    $request->{__stash} = {};
    MT::RebuildTrigger->post_content_unpub( $cb, $app, $cd[2] );
    is( $rebuild_count, 6, 'rebuild not invoked' );
};

done_testing;
