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
use MT::Test::Permission;
use MT::ContentStatus;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $site
            = MT::Test::Permission->make_website( name => 'test website' );

        my $blog = MT::Test::Permission->make_blog(
            parent_id => $site->id,
            name      => 'test blog'
        );

        my $ct = MT::Test::Permission->make_content_type(
            blog_id => $blog->id,
            name    => 'test content type',
        );

        my $cf = MT::Test::Permission->make_content_field(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            name            => 'single text',
            type            => 'single_line_text',
        );

        my $fields = [
            {   id        => $cf->id,
                label     => 1,
                name      => $cf->name,
                order     => 1,
                type      => $cf->type,
                unique_id => $cf->unique_id,
            }
        ];
        $ct->fields($fields);
        $ct->save or die $ct->errstr;

        my $cd = MT::Test::Permission->make_content_data(
            blog_id         => $ct->blog_id,
            author_id       => 1,
            content_type_id => $ct->id,
            data            => { $cf->id => 'test text' },
        );
    }
);

my $site = MT->model('website')->load( { name => 'test website' } );
my $blog = MT->model('blog')->load( { name => 'test blog' } );
my $ct = MT->model('content_type')->load( { name => 'test content type' } );

require MT::RebuildTrigger;

my $app     = MT->instance;
my $request = MT::Request->instance;

### register triggers
my $rt1 = MT::RebuildTrigger->new;
$rt1->blog_id( $site->id );
$rt1->object_type( MT::RebuildTrigger::TYPE_CONTENT_TYPE() );
$rt1->action( MT::RebuildTrigger::ACTION_RI() );
$rt1->event( MT::RebuildTrigger::EVENT_SAVE() );
$rt1->target( MT::RebuildTrigger::TARGET_BLOG() );
$rt1->target_blog_id( $blog->id );
$rt1->ct_id( $ct->id );
$rt1->save;
my $rt2 = MT::RebuildTrigger->new;
$rt2->blog_id( $site->id );
$rt2->object_type( MT::RebuildTrigger::TYPE_CONTENT_TYPE() );
$rt2->action( MT::RebuildTrigger::ACTION_RI() );
$rt2->event( MT::RebuildTrigger::EVENT_PUBLISH() );
$rt2->target( MT::RebuildTrigger::TARGET_BLOG() );
$rt2->target_blog_id( $blog->id );
$rt2->ct_id( $ct->id );
$rt2->save;
my $rt3 = MT::RebuildTrigger->new;
$rt3->blog_id( $site->id );
$rt3->object_type( MT::RebuildTrigger::TYPE_CONTENT_TYPE() );
$rt3->action( MT::RebuildTrigger::ACTION_RI() );
$rt3->event( MT::RebuildTrigger::EVENT_UNPUBLISH() );
$rt3->target( MT::RebuildTrigger::TARGET_BLOG() );
$rt3->target_blog_id( $blog->id );
$rt3->ct_id( $ct->id );
$rt3->save;

### initialize mock
my $rebuild_count = 0;

$app = Test::MockObject::Extends->new($app);
$app->mock(
    'rebuild_indexes',
    sub {
        $rebuild_count++;
    }
);

### Utilities
sub clear_cache {
    $rebuild_count = 0;
    $request->{__stash} = {};
}

sub run_test(&) {
    &clear_cache;
    $_[0]->();
}

### Do test

run_test {
    my $content
        = $app->model('content_data')->load( { blog_id => $blog->id } );
    MT::RebuildTrigger->post_content_save( $app, $content );
    is( $rebuild_count, 1, 'called once in post_content_save.' );
};

run_test {
    my $content
        = $app->model('content_data')->load( { blog_id => $blog->id } );
    MT::RebuildTrigger->post_contents_bulk_save( $app,
        [ ( { current => $content, original => $content } ) x 3 ] );
    is( $rebuild_count, 1, 'called once in post_contents_bulk_save.' );
};

run_test {
    my $content = $app->model('content_data')->new;
    $content->blog_id( $site->id );
    MT::RebuildTrigger->post_contents_bulk_save( $app,
        [ ( { current => $content, original => $content } ) x 3 ] );
    is( $rebuild_count, 0,
        'not called once in post_contents_bulk_save for blog not have trigger.'
    );
};

run_test {
    my $content
        = $app->model('content_data')->load( { blog_id => $blog->id } );
    $content->status(MT::ContentStatus::RELEASE);
    MT::RebuildTrigger->post_content_pub( $app, $content );
    is( $rebuild_count, 1, 'called once in post_content_pub.' );
};

run_test {
    my $content
        = $app->model('content_data')->load( { blog_id => $blog->id } );
    $content->status(MT::ContentStatus::RELEASE);
    MT::RebuildTrigger->post_content_pub( $app, $content );
    MT::RebuildTrigger->post_content_pub( $app, $content );
    MT::RebuildTrigger->post_content_pub( $app, $content );
    is( $rebuild_count, 1,
        'called once in post_content_pub even if trigger is called multiple times.'
    );
};

run_test {
    my $content
        = $app->model('content_data')->load( { blog_id => $blog->id } );
    $content->status(MT::ContentStatus::FUTURE);
    MT::RebuildTrigger->post_content_pub( $app, $content );
    is( $rebuild_count, 0,
        'not called once in post_content_pub for status FUTURE.' );
};

run_test {
    my $content = $app->model('content_data')->new;
    $content->blog_id( $site->id );
    $content->status(MT::ContentStatus::RELEASE);
    MT::RebuildTrigger->post_content_pub( $app, $content );
    is( $rebuild_count, 0,
        'called once in post_content_pub for blog not have trigger.' );
};

run_test {
    my $content
        = $app->model('content_data')->load( { blog_id => $blog->id } );
    $content->status(MT::ContentStatus::UNPUBLISH);
    MT::RebuildTrigger->post_content_unpub( $app, $content );
    is( $rebuild_count, 1, 'called once in post_content_unpub.' );
};

run_test {
    my $content
        = $app->model('content_data')->load( { blog_id => $blog->id } );
    $content->status(MT::ContentStatus::UNPUBLISH);
    MT::RebuildTrigger->post_content_unpub( $app, $content );
    MT::RebuildTrigger->post_content_unpub( $app, $content );
    MT::RebuildTrigger->post_content_unpub( $app, $content );
    is( $rebuild_count, 1,
        'called once in post_content_unpub even if trigger is called multiple times.'
    );
};

run_test {
    my $content
        = $app->model('content_data')->load( { blog_id => $blog->id } );
    for my $s ( MT::ContentStatus::HOLD, MT::ContentStatus::RELEASE,
        MT::ContentStatus::FUTURE )
    {
        $content->status($s);
        MT::RebuildTrigger->post_content_unpub( $app, $content );
    }
    is( $rebuild_count, 0,
        'not called in post_content_unpub not for status UNPUBLISH.' );
};

run_test {
    my $content = $app->model('content_data')->new;
    $content->blog_id( $site->id );
    $content->status(MT::ContentStatus::UNPUBLISH);
    MT::RebuildTrigger->post_content_unpub( $app, $content );
    is( $rebuild_count, 0,
        'not called in post_content_unpub for blog not have trigger.' );
};

done_testing;
