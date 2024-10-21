#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
use MT::Test::Memcached;

our $test_env;
my $memcached;
BEGIN {
    $memcached = MT::Test::Memcached->new or plan skip_all => "Memcached is not available";
    $test_env = MT::Test::Env->new( MemcachedServers => $memcached->address );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

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

    # Entry
    my $website_entry2 = MT::Test::Permission->make_entry(
        blog_id   => $website->id,
        author_id => $admin->id,
    );
    $website_entry2->tags('@entry2');
    $website_entry2->save;
});

my $website = MT::Website->load({ name => 'my website' });
my $admin = MT->model('author')->load(1);

subtest 'Delete cache with object-tag' => sub {
    my $entry = MT::Entry->load({ blog_id => $website->id, author_id => $admin->id });
    is_deeply( [ $entry->get_tags ], [ '@entry' ], 'Exists tag' );
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

subtest 'Edit object-tag on rename_tag (Case 1)' => sub {
    my @entries = MT::Entry->load({ blog_id => $website->id, author_id => $admin->id });
    $entries[0]->tags('foo');
    $entries[0]->save;
    $entries[1]->tags('bar');
    $entries[1]->save;

    # memo: Cache tag-ids.
    @entries = MT::Entry->load({ blog_id => $website->id, author_id => $admin->id });
    is_deeply( [ $entries[0]->get_tags ], [ 'foo' ], 'Exists tag' );
    is_deeply( [ $entries[1]->get_tags ], [ 'bar' ], 'Exists tag' );

    my $cache = MT::Memcached->instance;
    ok( $cache->get($entries[0]->tag_cache_key), "Exists cached tag-ids" );
    ok( $cache->get($entries[1]->tag_cache_key), "Exists cached tag-ids" );

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    my $tag = MT::Tag->load({ name => 'bar' });
    $app->post_ok({
        __mode   => 'rename_tag',
        blog_id  => $website->id,
        tag_name => 'foo',
        __id     => $tag->id,
    });

    my $tag_cache_key = $entries[1]->tag_cache_key;
    is( $cache->get($tag_cache_key), undef, "Delete cache in rename_tag" );

    my $entry = MT::Entry->load({ id => $entries[1]->id });
    is_deeply( [ $entry->get_tags ], [ 'foo' ], 'Rename succeeded' );
    is( MT::ObjectTag->exist({ tag_id => $tag->id }), undef, "Remove unused tag" );
};

subtest 'Edit object-tag on rename_tag (Case 2)' => sub {
    my @entries = MT::Entry->load({ blog_id => $website->id, author_id => $admin->id });
    $entries[0]->tags('foo', 'bar');
    $entries[0]->save;
    $entries[1]->tags('hoge');
    $entries[1]->save;

    # memo: Cache tag-ids.
    @entries = MT::Entry->load({ blog_id => $website->id, author_id => $admin->id });
    ok( (grep { $_ eq 'foo' } $entries[0]->get_tags), 'Exists tag' );
    ok( (grep { $_ eq 'bar' } $entries[0]->get_tags), 'Exists tag' );
    is_deeply( [ $entries[1]->get_tags ], [ 'hoge' ], 'Exists tag' );

    my $cache = MT::Memcached->instance;
    ok( $cache->get($entries[0]->tag_cache_key), "Exists cached tag-ids" );
    ok( $cache->get($entries[1]->tag_cache_key), "Exists cached tag-ids" );

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);

    my $tag = MT::Tag->load({ name => 'hoge' });
    $app->post_ok({
        __mode   => 'rename_tag',
        blog_id  => $website->id,
        tag_name => 'bar',
        __id     => $tag->id,
    });

    my $entry = MT::Entry->load({ id => $entries[1]->id });
    is_deeply( [ $entry->get_tags ], [ 'bar' ], 'Rename succeeded' );
    is( MT::ObjectTag->exist({ tag_id => $tag->id }), undef, "Remove unused tag" );
};

done_testing();
