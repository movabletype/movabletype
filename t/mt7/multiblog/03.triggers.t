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
use MT::Entry;

$test_env->prepare_fixture('db_data');

require MT::RebuildTrigger;

my $app     = MT->instance;
my $request = MT::Request->instance;

### register triggers
my $rt1 = MT::RebuildTrigger->new;
$rt1->blog_id(2);
$rt1->object_type( MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE() );
$rt1->action( MT::RebuildTrigger::ACTION_RI() );
$rt1->event( MT::RebuildTrigger::EVENT_SAVE() );
$rt1->target_blog_id(1);
$rt1->save;
my $rt2 = MT::RebuildTrigger->new;
$rt2->blog_id(2);
$rt2->object_type( MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE() );
$rt2->action( MT::RebuildTrigger::ACTION_RI() );
$rt2->event( MT::RebuildTrigger::EVENT_PUBLISH() );
$rt2->target_blog_id(1);
$rt2->save;
my $rt3 = MT::RebuildTrigger->new;
$rt3->blog_id(2);
$rt3->object_type( MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE() );
$rt3->action( MT::RebuildTrigger::ACTION_RI() );
$rt3->event( MT::RebuildTrigger::EVENT_UNPUBLISH() );
$rt3->target_blog_id(1);
$rt3->save;
my $rt4 = MT::RebuildTrigger->new;
$rt4->blog_id(2);
$rt4->object_type( MT::RebuildTrigger::TYPE_COMMENT() );
$rt4->action( MT::RebuildTrigger::ACTION_RI() );
$rt4->event( MT::RebuildTrigger::EVENT_PUBLISH() );
$rt4->target_blog_id(1);
$rt4->save;
my $rt5 = MT::RebuildTrigger->new;
$rt5->blog_id(2);
$rt5->object_type( MT::RebuildTrigger::TYPE_PING() );
$rt5->action( MT::RebuildTrigger::ACTION_RI() );
$rt5->event( MT::RebuildTrigger::EVENT_PUBLISH() );
$rt5->target_blog_id(1);
$rt5->save;

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
    my $entry = $app->model('entry')->load( { blog_id => 1 } );
    MT::RebuildTrigger->post_entry_save( undef, $app, $entry );
    is( $rebuild_count, 1, 'called once in post_entry_save.' );
};

run_test {
    my $page = $app->model('page')->load( { blog_id => 1 } );
    MT::RebuildTrigger->post_entry_save( undef, $app, $page );
    is( $rebuild_count, 1, 'called once in post_entry_save for page.' );
};

run_test {
    my $page = $app->model('page')->new;
    $page->blog_id(2);
    MT::RebuildTrigger->post_entry_save( undef, $app, $page );
    is( $rebuild_count, 0,
        'is not called in post_entry_save for blog not have trigger.' );
};

run_test {
    my $entry = $app->model('entry')->load( { blog_id => 1 } );
    MT::RebuildTrigger->post_entries_bulk_save( undef, $app,
        [ ( { current => $entry, original => $entry } ) x 3 ] );
    is( $rebuild_count, 1, 'called once in post_entries_bulk_save.' );
};

run_test {
    my $entry = $app->model('entry')->new;
    $entry->blog_id(2);
    MT::RebuildTrigger->post_entries_bulk_save( undef, $app,
        [ ( { current => $entry, original => $entry } ) x 3 ] );
    is( $rebuild_count, 0,
        'not called once in post_entries_bulk_save for blog not have trigger.'
    );
};

run_test {
    my $entry = $app->model('entry')->load( { blog_id => 1 } );
    $entry->status(MT::Entry::RELEASE);
    MT::RebuildTrigger->post_entry_pub( undef, $app, $entry );
    is( $rebuild_count, 1, 'called once in post_entry_pub.' );
};

run_test {
    my $entry = $app->model('entry')->load( { blog_id => 1 } );
    $entry->status(MT::Entry::RELEASE);
    MT::RebuildTrigger->post_entry_pub( undef, $app, $entry );
    MT::RebuildTrigger->post_entry_pub( undef, $app, $entry );
    MT::RebuildTrigger->post_entry_pub( undef, $app, $entry );
    is( $rebuild_count, 1,
        'called once in post_entry_pub even if trigger is called multiple times.'
    );
};

run_test {
    my $entry = $app->model('entry')->load( { blog_id => 1 } );
    $entry->status(MT::Entry::FUTURE);
    MT::RebuildTrigger->post_entry_pub( undef, $app, $entry );
    is( $rebuild_count, 0,
        'not called once in post_entry_pub for status FUTURE.' );
};

run_test {
    my $entry = $app->model('entry')->new;
    $entry->blog_id(2);
    $entry->status(MT::Entry::RELEASE);
    MT::RebuildTrigger->post_entry_pub( undef, $app, $entry );
    is( $rebuild_count, 0,
        'called once in post_entry_pub for blog not have trigger.' );
};

run_test {
    my $entry = $app->model('entry')->load( { blog_id => 1 } );
    $entry->status(MT::Entry::UNPUBLISH);
    MT::RebuildTrigger->post_entry_unpub( undef, $app, $entry );
    is( $rebuild_count, 1, 'called once in post_entry_unpub.' );
};

run_test {
    my $page = $app->model('page')->load( { blog_id => 1 } );
    $page->status(MT::Entry::UNPUBLISH);
    MT::RebuildTrigger->post_entry_unpub( undef, $app, $page );
    is( $rebuild_count, 1, 'called once in post_entry_unpub for page.' );
};

run_test {
    my $entry = $app->model('entry')->load( { blog_id => 1 } );
    $entry->status(MT::Entry::UNPUBLISH);
    MT::RebuildTrigger->post_entry_unpub( undef, $app, $entry );
    MT::RebuildTrigger->post_entry_unpub( undef, $app, $entry );
    MT::RebuildTrigger->post_entry_unpub( undef, $app, $entry );
    is( $rebuild_count, 1,
        'called once in post_entry_unpub even if trigger is called multiple times.'
    );
};

run_test {
    my $page = $app->model('page')->load( { blog_id => 1 } );
    $page->status(MT::Entry::UNPUBLISH);
    MT::RebuildTrigger->post_entry_unpub( undef, $app, $page );
    MT::RebuildTrigger->post_entry_unpub( undef, $app, $page );
    MT::RebuildTrigger->post_entry_unpub( undef, $app, $page );
    is( $rebuild_count, 1,
        'called once in post_entry_unpub for page if trigger is called multiple times.'
    );
};

run_test {
    my $entry = $app->model('entry')->load( { blog_id => 1 } );
    for my $s ( MT::Entry::HOLD, MT::Entry::RELEASE, MT::Entry::FUTURE ) {
        $entry->status($s);
        MT::RebuildTrigger->post_entry_unpub( undef, $app, $entry );
    }
    is( $rebuild_count, 0,
        'not called in post_entry_unpub not for status UNPUBLISH.' );
};

run_test {
    my $page = $app->model('page')->load( { blog_id => 1 } );
    for my $s ( MT::Entry::HOLD, MT::Entry::RELEASE, MT::Entry::FUTURE ) {
        $page->status($s);
        MT::RebuildTrigger->post_entry_unpub( undef, $app, $page );
    }
    is( $rebuild_count, 0,
        'not called in post_entry_unpub for page whose status is not UNPUBLISH.'
    );
};

run_test {
    my $entry = $app->model('entry')->new;
    $entry->blog_id(2);
    $entry->status(MT::Entry::UNPUBLISH);
    MT::RebuildTrigger->post_entry_unpub( undef, $app, $entry );
    is( $rebuild_count, 0,
        'not called in post_entry_unpub for blog not have trigger.' );
};

run_test {
    my $page = $app->model('page')->new;
    $page->blog_id(2);
    $page->status(MT::Entry::UNPUBLISH);
    MT::RebuildTrigger->post_entry_unpub( undef, $app, $page );
    is( $rebuild_count, 0,
        'not called in post_entry_unpub for page in blog not have trigger.' );
};

run_test {
    my $comment = $app->model('comment')->load( { blog_id => 1 } );
    $comment->visible(1);
    MT::RebuildTrigger->post_feedback_save( 'comment_pub', undef, $comment );
    is( $rebuild_count, 1, 'called once in post_feedback_save for comment.' );
};

run_test {
    my $comment = $app->model('comment')->load( { blog_id => 1 } );
    $comment->visible(0);
    MT::RebuildTrigger->post_feedback_save( 'comment_pub', undef, $comment );
    is( $rebuild_count, 0,
        'not called once in post_feedback_save for invisible comment.' );
};

run_test {
    my $comment = $app->model('comment')->new;
    $comment->blog_id(2);
    $comment->visible(1);
    MT::RebuildTrigger->post_feedback_save( 'comment_pub', undef, $comment );
    is( $rebuild_count, 0,
        'not called once in post_feedback_save for comment for blog not have trigger.'
    );
};

run_test {
    my $tbping = $app->model('tbping')->load( { blog_id => 1 } );
    $tbping->visible(1);
    MT::RebuildTrigger->post_feedback_save( 'tb_pub', undef, $tbping );
    is( $rebuild_count, 1,
        'called once in post_feedback_save for trackback.' );
};

run_test {
    my $tbping = $app->model('tbping')->load( { blog_id => 1 } );
    $tbping->visible(0);
    MT::RebuildTrigger->post_feedback_save( 'tb_pub', undef, $tbping );
    is( $rebuild_count, 0,
        'not called once in post_feedback_save for invisible trackback.' );
};

run_test {
    my $tbping = $app->model('tbping')->new;
    $tbping->blog_id(2);
    $tbping->visible(0);
    MT::RebuildTrigger->post_feedback_save( 'tb_pub', undef, $tbping );
    is( $rebuild_count, 0,
        'not called once in post_feedback_save for invisible trackback for blog not have trigger.'
    );
};

done_testing;
