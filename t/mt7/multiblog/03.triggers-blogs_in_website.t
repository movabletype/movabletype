#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
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
my $rt0 = MT::RebuildTrigger->new;
$rt0->blog_id(0);
my $data0 = {
    blog_content_accessible => 1,
    old_rebuild_triggers    => '',
};
$rt0->data( MT::Util::to_json($data0) );
$rt0->save;
my $rt2 = MT::RebuildTrigger->new;
$rt2->blog_id(2);
my $data2
    = { rebuild_triggers =>
        'ri:_blogs_in_website:entry_pub',
    };
$rt2->data( MT::Util::to_json($data2) );
$rt2->save;

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

done_testing;
