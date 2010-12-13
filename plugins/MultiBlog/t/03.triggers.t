#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib t/lib);

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

BEGIN {
    use Test::More;
    eval { require Test::MockObject }
      or plan skip_all => 'Test::MockObject is not installed';
}
use Test::MockObject::Extends;

use MT;
use MT::Test qw(:db :data);
use MultiBlog;

my $app     = MT->instance;
my $request = MT::Request->instance;

### register triggers
my $plugin = $app->component('MultiBlog');
$plugin->save_config(
    {
        blog_content_accessible => 1,
        old_rebuild_triggers    => '',
        rebuild_triggers =>
          'ri:1:entry_save|ri:1:entry_pub|ri:1:comment_pub|ri:1:tb_pub',
    },
    'blog:2'
);

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
    MultiBlog::post_entry_save( $plugin, undef, $app, $entry );
    is( $rebuild_count, 1, 'called once in post_entry_save.' );
};

run_test {
    my $page = $app->model('page')->load( { blog_id => 1 } );
    MultiBlog::post_entry_save( $plugin, undef, $app, $page );
    is( $rebuild_count, 1, 'called once in post_entry_save for page.' );
};

run_test {
    my $entry = $app->model('entry')->load( { blog_id => 1 } );
    MultiBlog::post_entry_save( $plugin, undef, $app, $entry );
    MultiBlog::post_entry_save( $plugin, undef, $app, $entry );
    MultiBlog::post_entry_save( $plugin, undef, $app, $entry );
    is( $rebuild_count, 1,
'called once in post_entry_save even if trigger is called multiple times.'
    );
};

run_test {
    my $page = $app->model('page')->new;
    $page->blog_id(2);
    MultiBlog::post_entry_save( $plugin, undef, $app, $page );
    is( $rebuild_count, 0,
        'is not called in post_entry_save for blog not have trigger.' );
};

run_test {
    my $entry = $app->model('entry')->load( { blog_id => 1 } );
    MultiBlog::post_entries_bulk_save( $plugin, undef, $app,
        [ ( { current => $entry, original => $entry } ) x 3 ] );
    is( $rebuild_count, 1, 'called once in post_entries_bulk_save.' );
};

run_test {
    my $entry = $app->model('entry')->new;
    $entry->blog_id(2);
    MultiBlog::post_entries_bulk_save( $plugin, undef, $app,
        [ ( { current => $entry, original => $entry } ) x 3 ] );
    is( $rebuild_count, 0,
        'not called once in post_entries_bulk_save for blog not have trigger.'
    );
};

run_test {
    my $entry = $app->model('entry')->load( { blog_id => 1 } );
    $entry->status(MT::Entry::RELEASE);
    MultiBlog::post_entry_pub( $plugin, undef, $app, $entry );
    is( $rebuild_count, 1, 'called once in post_entry_pub.' );
};

run_test {
    my $entry = $app->model('entry')->load( { blog_id => 1 } );
    $entry->status(MT::Entry::RELEASE);
    MultiBlog::post_entry_pub( $plugin, undef, $app, $entry );
    MultiBlog::post_entry_pub( $plugin, undef, $app, $entry );
    MultiBlog::post_entry_pub( $plugin, undef, $app, $entry );
    is( $rebuild_count, 1,
'called once in post_entry_pub even if trigger is called multiple times.'
    );
};

run_test {
    my $entry = $app->model('entry')->load( { blog_id => 1 } );
    $entry->status(MT::Entry::FUTURE);
    MultiBlog::post_entry_pub( $plugin, undef, $app, $entry );
    is( $rebuild_count, 0,
        'not called once in post_entry_pub for status FUTURE.' );
};

run_test {
    my $entry = $app->model('entry')->new;
    $entry->blog_id(2);
    $entry->status(MT::Entry::RELEASE);
    MultiBlog::post_entry_pub( $plugin, undef, $app, $entry );
    is( $rebuild_count, 0,
        'called once in post_entry_pub for blog not have trigger.' );
};

run_test {
    my $comment = $app->model('comment')->load( { blog_id => 1 } );
    $comment->visible(1);
    MultiBlog::post_feedback_save( $plugin, 'comment_pub', undef, $comment );
    is( $rebuild_count, 1, 'called once in post_feedback_save for comment.' );
};

run_test {
    my $comment = $app->model('comment')->load( { blog_id => 1 } );
    $comment->visible(0);
    MultiBlog::post_feedback_save( $plugin, 'comment_pub', undef, $comment );
    is( $rebuild_count, 0,
        'not called once in post_feedback_save for invisible comment.' );
};

run_test {
    my $comment = $app->model('comment')->new;
    $comment->blog_id(2);
    $comment->visible(1);
    MultiBlog::post_feedback_save( $plugin, 'comment_pub', undef, $comment );
    is( $rebuild_count, 0,
'not called once in post_feedback_save for comment for blog not have trigger.'
    );
};

run_test {
    my $tbping = $app->model('tbping')->load( { blog_id => 1 } );
    $tbping->visible(1);
    MultiBlog::post_feedback_save( $plugin, 'tb_pub', undef, $tbping );
    is( $rebuild_count, 1, 'called once in post_feedback_save for trackback.' );
};

run_test {
    my $tbping = $app->model('tbping')->load( { blog_id => 1 } );
    $tbping->visible(0);
    MultiBlog::post_feedback_save( $plugin, 'tb_pub', undef, $tbping );
    is( $rebuild_count, 0,
        'not called once in post_feedback_save for invisible trackback.' );
};

run_test {
    my $tbping = $app->model('tbping')->new;
    $tbping->blog_id(2);
    $tbping->visible(0);
    MultiBlog::post_feedback_save( $plugin, 'tb_pub', undef, $tbping );
    is( $rebuild_count, 0,
'not called once in post_feedback_save for invisible trackback for blog not have trigger.'
    );
};

done_testing;
