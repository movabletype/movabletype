#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Memcached;
use MT::Test::Permission;

my $memcached = MT::Test::Memcached->new or plan skip_all => "Memcached is not available";
MT->config(MemcachedServers => $memcached->address);

my $m = MT::Memcached->instance;
$m->set( __FILE__, __FILE__, 1 );

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    # Website
    my $website = MT::Test::Permission->make_website(
        name => 'my website',
    );

    # Author
    my $admin = MT->model('author')->load(1);

    # Entry
    my $website_entry = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $admin->id,
    );
    $website_entry->tags('@entry');
    $website_entry->save;
});

my $website = MT::Website->load({ name => 'my website' });
my $admin = MT->model('author')->load(1);

subtest 'Delete cached tag-ids' => sub {
    my $entry = MT::Entry->load({ blog_id => $website->id, author_id => $admin->id });
    ok( (grep { $_ eq '@entry' } $entry->get_tags), 'Exists tag' );
    ok( $entry->tag_cache_key, 'Generatable tag_cache_key' );

    my $cache = MT::Memcached->instance;
    ok( $cache->get($entry->tag_cache_key), "Exists cached tag-ids" );

    my $ot = MT::ObjectTag->load({ object_id => $entry->id });
    my $tag_cache_key = MT::Taggable->tag_cache_key({
        datasource => $ot->object_datasource,
        id => $ot->object_id
    });
    is( $tag_cache_key, $entry->tag_cache_key, "Generate from object-tag" );

    $cache->delete( $tag_cache_key );
    is( $cache->get($tag_cache_key), undef, "Delete cache with object-tag" );
};

done_testing();
