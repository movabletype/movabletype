#!/usr/bin/perl

use strict;
use warnings;

use lib qw(lib t/lib);

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use Test::More;

use MT;
use MT::Test qw(:db :data);
my $app = MT->instance;

{
    my $key       = 'entry_count';
    my $author    = $app->model('author')->load(1);
    my $pre_count = $author->get_summary($key);

    my $entry = $app->model('entry')->new;
    $entry->set_values(
        {   status    => MT::Entry::RELEASE(),
            blog_id   => 2,
            author_id => $author->id,
        }
    );
    $entry->save or die $entry->errstr;

    # reload
    $author = $app->model('author')->load( $author->id );
    my $post_count = $author->get_summary($key);

    is( $post_count - $pre_count,
        1, qq(The "$key" for "MT::Author" is updated') )
}

done_testing();
