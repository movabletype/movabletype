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
          'ri:_blogs_in_website:entry_pub',
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

done_testing;
