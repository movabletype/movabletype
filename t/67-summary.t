#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;

$test_env->prepare_fixture('db_data');

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
