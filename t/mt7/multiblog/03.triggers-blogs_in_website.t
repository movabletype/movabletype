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

$test_env->prepare_fixture('db_data');

require MT::RebuildTrigger;

my $app     = MT->instance;
my $request = MT::Request->instance;

### register triggers
my $rt = MT::RebuildTrigger->new;
$rt->blog_id(2);
$rt->object_type( MT::RebuildTrigger::TYPE_ENTRY_OR_PAGE() );
$rt->action( MT::RebuildTrigger::ACTION_RI() );
$rt->event( MT::RebuildTrigger::EVENT_PUBLISH() );
$rt->target( MT::RebuildTrigger::TARGET_BLOGS_IN_WEBSITE() );
$rt->target_blog_id(0);
$rt->save;

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

### Callback

my $cb = MT::Callback->new;

### Do test

run_test {
    my $entry = $app->model('entry')->load( { blog_id => 1 } );
    MT::RebuildTrigger->post_entry_save( $cb, $app, $entry );
    is( $rebuild_count, 1, 'called once in post_entry_save.' );
};

done_testing;
