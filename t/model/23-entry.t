#!/usr/bin/perl
# $Id: 23-entry.t 2670 2008-07-01 09:26:52Z takayama $
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

plan tests => 41;

use MT;
use MT::Blog;
use MT::Category;
use MT::Comment;
use MT::Entry;
use MT::Placement;

use MT::Test;

$test_env->prepare_fixture('db_data');

my $mt = MT->instance or die MT->errstr;
isa_ok( $mt, 'MT' );

my $blog = MT::Blog->load(1);
isa_ok( $blog, 'MT::Blog' );

my $entry = MT::Entry->load(1);
isa_ok( $entry, 'MT::Entry' );
is( $entry->blog_id,        $blog->id,              'blog id' );
is( $entry->status,         MT::Entry::RELEASE(),   'status' );
is( $entry->status,         2,                      'status 2' );
is( $entry->title,          'A Rainy Day',          'title' );
is( $entry->allow_comments, 1,                      'allow_comments 1' );
is( $entry->excerpt,        'A story of a stroll.', 'excerpt' );
is( $entry->text,      'On a drizzly day last weekend,', 'text' );
is( $entry->text_more, 'I took my grandpa for a walk.',  'text_more' );

subtest 'status methods' => sub {
    is( MT::Entry::HOLD(),      1, 'HOLD() is 1' );
    is( MT::Entry::RELEASE(),   2, 'RELEASE() is 2' );
    is( MT::Entry::REVIEW(),    3, 'REVIEW() is 3' );
    is( MT::Entry::FUTURE(),    4, 'FUTURE() is 4' );
    is( MT::Entry::JUNK(),      5, 'JUNK() is 5' );
    is( MT::Entry::UNPUBLISH(), 6, 'REVIEW() is 6' );
};

subtest 'status_text method' => sub {
    is( MT::Entry::status_text(1), 'Draft',     '1 returns Draft' );
    is( MT::Entry::status_text(2), 'Publish',   '2 returns Publish' );
    is( MT::Entry::status_text(3), 'Review',    '3 returns Review' );
    is( MT::Entry::status_text(4), 'Future',    '4 returns Future' );
    is( MT::Entry::status_text(5), 'Spam',      '5 returns Spam' );
    is( MT::Entry::status_text(6), 'Unpublish', '6 returns Unpublish' );
};

subtest 'status_int method' => sub {
    is( MT::Entry::status_int('Draft'),     1, 'Draft returns 1' );
    is( MT::Entry::status_int('Publish'),   2, 'Publish returns 2' );
    is( MT::Entry::status_int('Review'),    3, 'Review returns 3' );
    is( MT::Entry::status_int('Future'),    4, 'Future returns 4' );
    is( MT::Entry::status_int('Junk'),      5, 'Junk returns 5' );
    is( MT::Entry::status_int('Spam'),      5, 'Spam returns 5' );
    is( MT::Entry::status_int('Unpublish'), 6, 'Unpublish returns 6' );

    is( MT::Entry::status_int('DRAFT'),     1, 'DRAFT returns 1' );
    is( MT::Entry::status_int('PUBLISH'),   2, 'PUBLISH returns 2' );
    is( MT::Entry::status_int('REVIEW'),    3, 'REVIEW returns 3' );
    is( MT::Entry::status_int('FUTURE'),    4, 'Future returns 4' );
    is( MT::Entry::status_int('JUNK'),      5, 'JUNK returns 5' );
    is( MT::Entry::status_int('SPAM'),      5, 'SPAM returns 5' );
    is( MT::Entry::status_int('UNPUBLISH'), 6, 'UNPUBLISH returns 6' );

    is( MT::Entry::status_int('draft'),     1, 'draft returns 1' );
    is( MT::Entry::status_int('publish'),   2, 'publish returns 2' );
    is( MT::Entry::status_int('review'),    3, 'review returns 3' );
    is( MT::Entry::status_int('future'),    4, 'future returns 4' );
    is( MT::Entry::status_int('junk'),      5, 'junk returns 5' );
    is( MT::Entry::status_int('spam'),      5, 'spam returns 5' );
    is( MT::Entry::status_int('unpublish'), 6, 'unpublish returns 6' );
};

my $author = $entry->author;
isa_ok( $author, 'MT::Author' );
is( $author->name, 'Chuck D', 'name' );

## Test category, categories, and is_in_category
my $cat = new MT::Category;
$cat->blog_id( $entry->blog_id );
$cat->label('foo');
$cat->description('bar');
$cat->author_id( $author->id );
$cat->parent(0);
$cat->save or die "Couldn't save category record 1: " . $cat->errstr;

my $cat2 = new MT::Category;
$cat2->blog_id( $entry->blog_id );
$cat2->label('foo2');
$cat2->description('bar2');
$cat2->author_id( $author->id );
$cat2->parent(0);
$cat2->save or die "Couldn't save category record 1: " . $cat2->errstr;

my $place = MT::Placement->new;
$place->entry_id( $entry->id );
$place->blog_id( $entry->blog_id );
$place->category_id( $cat->id );
$place->is_primary(1);
$place->save or die "Couldn't save placement record: " . $place->errstr;

my $place2 = MT::Placement->new;
$place2->entry_id( $entry->id );
$place2->blog_id( $entry->blog_id );
$place2->category_id( $cat2->id );
$place2->is_primary(0);
$place2->save or die "Couldn't save placement record: " . $place2->errstr;

$entry->clear_cache;
my $category = $entry->category;
ok( $category, "Primary category " . $category->label . " exists" );

my $categories = $entry->categories;
ok( $categories && scalar @$categories == 2, "Multiple cateogires exist " );

# Test attach_categories method
my @entry_category_ids = map { $_->id } @$categories;
my $cat3 = MT->model('category')->load(
    { id => { not => \@entry_category_ids } },
    { sort => 'id', direction => 'ascend' },
);
my $attached = $entry->attach_categories($cat3);
is( scalar @$attached,              1, 'Attached a category' );
is( scalar @{ $entry->categories }, 3, '3 categories exist' );

# Test update_categories method
my $attached2 = $entry->update_categories( $cat, $cat2 );
is( scalar @$attached2,             2, 'Update categories' );
is( scalar @{ $entry->categories }, 2, '2 categories exist' );

my $attached3 = $entry->update_categories($cat);
is( scalar @$attached3,             1, 'Update categories' );
is( scalar @{ $entry->categories }, 1, '1 category exist' );

my $attached4 = $entry->update_categories();
is( scalar @$attached4,             0, 'Update categories' );
is( scalar @{ $entry->categories }, 0, 'No category exist' );

# Test attach_assets method
my $asset          = MT->model('asset')->load(3);
my $attached_asset = $entry->attach_assets($asset);
is( scalar @$attached_asset, 1, 'Attached an asset' );
my $oa_count = MT->model('objectasset')->count(
    {   object_ds => 'entry',
        object_id => $entry->id,
        asset_id  => $asset->id,
    }
);
is( $oa_count, 1, '1 ObjectAsset record exists' );

my $attached_asset_twice = $entry->attach_assets($asset);
is( scalar @$attached_asset_twice, 0, 'Attached no asset' );

my $attached_no_asset = $entry->attach_assets();
is( scalar @$attached_no_asset, 0, 'Attached no asset' );

# Test update_assets method
my $updated_asset = $entry->update_assets();
is( scalar @$updated_asset, 0, 'Detach an asset' );
my $oa_count_update = MT->model('objectasset')->count(
    {   object_ds => 'entry',
        object_id => $entry->id,
        asset_id  => $asset->id,
    }
);
is( $oa_count_update, 0, 'No ObjectAsset record exists' );

my $updated_asset2 = $entry->update_assets($asset);
is( scalar @$updated_asset2, 1, 'Attach an asset' );
my $oa_count_update2 = MT->model('objectasset')->count(
    {   object_ds => 'entry',
        object_id => $entry->id,
        asset_id  => $asset->id,
    }
);
is( $oa_count_update2, 1, '1 ObjectAsset record exist' );

## Test permalink, archive_url, archive_file
is( $entry->permalink,
    'http://narnia.na/nana/archives/1978/01/a-rainy-day.html', 'Permalink' );
is( $entry->archive_url,
    'http://narnia.na/nana/archives/1978/01/a-rainy-day.html',
    'Archive URL' );
is( $entry->archive_file, '1978/01/a-rainy-day.html', 'Archive file' );

## Test entry auto-generation
$entry->excerpt('');
is( $entry->excerpt, '', 'excerpt empty' );
is( $entry->get_excerpt, $entry->text . '...', 'get_excerpt' );
$blog->words_in_excerpt(3);
$entry->cache_property( 'blog', undef, $blog );
is( $entry->get_excerpt, 'On a drizzly...', 'get_excerpt' );
$entry->convert_breaks('textile_2');
$entry->text("Foo _bar_ baz");
is( $entry->get_excerpt, 'Foo bar baz...', 'get_excerpt' );
