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

use MT::Test::Tag;
use MT::Test::PHP;
use MT::Test;
use MT::Test::Fixture;
use MT::Test::Image;
use MT::Test::Permission;
use Mock::MonkeyPatch;

$test_env->prepare_fixture('db');

my $website_name = 'tags-asset-website-' . time();
my $super        = 'super';

my $objs = MT::Test::Fixture->prepare(
    {   author  => [ { 'name' => $super }, ],
        website => [
            {   name     => $website_name,
                site_url => 'http://example.com/blog/',
            },
        ],
    }
);

my $author = $objs->{author}{$super};
my $website = $objs->{website}{$website_name};

my $image_path = $test_env->path("test.jpg");
my $image = MT::Test::Image->write(file => $image_path);

my $asset = MT::Asset::Image->new;
$asset->blog_id($website->id);
$asset->url($website->site_url . 'test.jpg');
$asset->file_path(File::Spec->catfile($image_path));
$asset->file_name('test.jpg');
$asset->file_ext('jpg');
$asset->image_width(640);
$asset->image_height(480);
$asset->mime_type('image/jpeg');
$asset->label('Image photo');
$asset->created_by($author->id);
$asset->add_tags('image', '@first', 'a');
$asset->save or die "Couldn't save asset: " . $asset->errstr;

my $no_tag_asset = MT::Asset::Image->new;
$no_tag_asset->blog_id($website->id);
$no_tag_asset->url($website->site_url . 'no_tag.jpg');
$no_tag_asset->file_path(File::Spec->catfile($image_path));
$no_tag_asset->file_name('no_tag.jpg');
$no_tag_asset->file_ext('jpg');
$no_tag_asset->image_width(640);
$no_tag_asset->image_height(480);
$no_tag_asset->mime_type('image/jpeg');
$no_tag_asset->label('Image photo');
$no_tag_asset->created_by($author->id);
$no_tag_asset->save or die "Couldn't save no_tag_asset: " . $no_tag_asset->errstr;

my $removed_asset = MT::Asset::Image->new;
$removed_asset->blog_id($website->id);
$removed_asset->url($website->site_url . 'removed.jpg');
$removed_asset->file_path(File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'removed.jpg' ));
$removed_asset->file_name('removed.jpg');
$removed_asset->file_ext('jpg');
$removed_asset->image_width(640);
$removed_asset->image_height(480);
$removed_asset->mime_type('image/jpeg');
$removed_asset->label('Image photo');
$removed_asset->created_by($author->id);
$removed_asset->save or die "Couldn't save asset: " . $removed_asset->errstr;

my $file_asset = MT::Asset->new;
$file_asset->blog_id($website->id);
$file_asset->url($website->site_url . 'test.pdf');
$file_asset->file_path(File::Spec->catfile( $ENV{MT_HOME}, "t", 'files', 'test.pdf' ));
$file_asset->file_name('test.pdf');
$file_asset->file_ext('pdf');
$file_asset->mime_type('application/pdf');
$file_asset->label('PDF file');
$file_asset->created_by($author->id);
$file_asset->add_tags('pdf', 'b');
$file_asset->save or die "Couldn't save asset: " . $file_asset->errstr;

my $text_asset = MT::Asset->new;
$text_asset->blog_id($website->id);
$text_asset->url($website->site_url . 'test.txt');
$text_asset->file_path(File::Spec->catfile( $ENV{MT_HOME}, "t", 'files', 'test.txt' ));
$text_asset->file_name('test.txt');
$text_asset->file_ext('txt');
$text_asset->mime_type('text/plain');
$text_asset->label('Text file');
$text_asset->created_by($author->id);
$text_asset->add_tags('text', 'a OR b');
$text_asset->save or die "Couldn't save asset: " . $text_asset->errstr;

my $entry = MT::Test::Permission->make_entry(
    blog_id   => $website->id,
    author_id => $author->id,
);
for my $a ($asset, $no_tag_asset, $file_asset) {
    MT::Test::Permission->make_objectasset(
        blog_id   => $website->id,
        object_id => $entry->id,
        asset_id  => $a->id,
    );
}
my $page = MT::Test::Permission->make_page(
    blog_id   => $website->id,
    author_id => $author->id,
);
for my $a ($asset, $no_tag_asset, $file_asset) {
    MT::Test::Permission->make_objectasset(
        blog_id   => $website->id,
        object_id => $page->id,
        asset_id  => $a->id,
    );
}

for my $attrs ({ namespace => 'foo', score => 3 }, { namespace => 'baz', score => 0 }) {
    MT::Test::Permission->make_objectscore(
        object_ds => 'asset',
        object_id => $asset->id,
        score     => $attrs->{score},
        author_id => $author->id,
        namespace => $attrs->{namespace},
    );
}

my ($year, $month) = unpack('A4A2', $asset->created_on);

ok !$test_env->files(MT->config->AssetCacheDir), "nothing exists under the asset cache dir yet";

my ($squared_thumbnail) = $asset->thumbnail_file(Square => 1, Width => 50);
ok -f $squared_thumbnail, "squared thumbnail exists now";

my ($scaled_thumbnail) = $asset->thumbnail_file(Scale => 50);
ok -f $scaled_thumbnail, "scaled thumbnail exists now";

my $php_supports_gd = MT::Test::PHP->supports_gd;
MT::Test::Tag->vars->{no_php_gd} = !$php_supports_gd;

my %vars = (
    AUTHOR_NAME       => $author->name,
    EXISTING_ASSET_ID => $asset->id,
    REMOVED_ASSET_ID  => $removed_asset->id,
    FILE_ASSET_ID     => $file_asset->id,
    ENTRY_ID          => $entry->id,
    PAGE_ID           => $page->id,
    YEAR              => $year,
    MONTH             => $month,
);

sub var {
    for my $line (@_) {
        for my $key ( keys %vars ) {
            my $value = $vars{$key};
            $line =~ s/$key/$value/g;
        }
    }
    @_;
}

filters {
    template => [qw( var chomp )],
    expected => [qw( var chomp )],
};

require MT::Image;
my $guard = Mock::MonkeyPatch->patch(
    'MT::Image::init' => sub {
        fail "Should not initialize MT::Image (ie. read an image)";
        Mock::MonkeyPatch::ORIGINAL(@_);
    },
);

MT::Test::Tag->run_perl_tests($website->id, sub {
    my ($ctx, $block) = @_;
    if (defined($block->should_not_be_called_object_tag_load)) {
        require MT::ObjectTag;
        *MT::ObjectTag::load = sub {
            fail "Should not be called MT::ObjectTag::load. We should only use JOIN statement.";
        };
    }
    else {
        undef *MT::ObjectTag::load;
    }
});
MT::Test::Tag->run_php_tests($website->id);

done_testing;

__END__

=== MTAssetThumbnailURL for ordinary image (no scale)
--- skip_php
[% no_php_gd %]
--- template
<MTAsset id="EXISTING_ASSET_ID">
<$MTAssetURL$>: <$MTAssetThumbnailURL _default="blank"$>
</MTAsset>
--- expected
http://example.com/blog/test.jpg: http://example.com/blog/assets_c/YEAR/MONTH/test-thumb-640x480-1.jpg

=== MTAssetThumbnailURL for ordinary image (scale 50)
--- skip_php
[% no_php_gd %]
--- template
<MTAsset id="EXISTING_ASSET_ID">
<$MTAssetURL$>: <$MTAssetThumbnailURL scale="50" _default="blank"$>
</MTAsset>
--- expected
http://example.com/blog/test.jpg: http://example.com/blog/assets_c/YEAR/MONTH/test-thumb-320x240-1.jpg

=== MTAssetThumbnailURL for ordinary image (square size 50)
--- skip_php
[% no_php_gd %]
--- template
<MTAsset id="EXISTING_ASSET_ID">
<$MTAssetURL$>: <$MTAssetThumbnailURL square="1" height="50" _default="blank"$>
</MTAsset>
--- expected
http://example.com/blog/test.jpg: http://example.com/blog/assets_c/YEAR/MONTH/test-thumb-50x50-1.jpg

=== MTAssetThumbnailURL for removed file (no reading image even with the scale attribute)
--- skip_php
[% no_php_gd %]
--- template
<MTAsset id="REMOVED_ASSET_ID">
<$MTAssetURL$>: <$MTAssetThumbnailURL scale="75" _default="blank"$>
</MTAsset>
--- expected
http://example.com/blog/removed.jpg: blank

=== MTAssetThumbnailURL for a PDF file
--- template
<MTAsset id="FILE_ASSET_ID">
<$MTAssetURL$>: <$MTAssetThumbnailURL scale="75" _default="blank"$>
</MTAsset>
--- expected
http://example.com/blog/test.pdf: blank

=== MTAssets[tag] : Single tag
--- template
<MTAssets tag="@first">
<$MTAssetURL$></MTAssets>
--- expected
http://example.com/blog/test.jpg
--- should_not_be_called_object_tag_load

=== MTAssets[tag] : Contains "OR" in tag name
--- template
<MTAssets tag="a OR b">
<$MTAssetURL$></MTAssets>
--- expected
http://example.com/blog/test.txt
--- should_not_be_called_object_tag_load
--- expected_php_todo
--- FIXME
https://movabletype.atlassian.net/browse/MTC-28118

=== MTAssets[tag] : Multiple tags
--- template
<MTAssets tag="pdf OR a" sort_by="id" sort_order="ascend">
<$MTAssetURL$></MTAssets>
--- expected
http://example.com/blog/test.jpg
http://example.com/blog/test.pdf
--- should_not_be_called_object_tag_load

=== MTAssets[tag] : Multiple tags (a public tag OR a private tag)
--- template
<MTAssets tag="pdf OR @first" sort_by="id" sort_order="ascend">
<$MTAssetURL$></MTAssets>
--- expected
http://example.com/blog/test.jpg
http://example.com/blog/test.pdf
--- should_not_be_called_object_tag_load
--- expected_php_todo
--- FIXME
https://movabletype.atlassian.net/browse/MTC-28120

=== MTAssets[tag] : Multiple tags (comma separated)
--- template
<MTAssets tag="pdf, @first" sort_by="id" sort_order="ascend">
<$MTAssetURL$></MTAssets>
--- expected
http://example.com/blog/test.jpg
http://example.com/blog/test.pdf
--- should_not_be_called_object_tag_load
--- expected_php_todo
--- FIXME
https://movabletype.atlassian.net/browse/MTC-28119

=== MTAssets[tag] : Multiple tags of same asset
--- template
<MTAssets tag="image OR a">
<$MTAssetURL$></MTAssets>
--- expected
http://example.com/blog/test.jpg
--- should_not_be_called_object_tag_load

=== MTAssets[tag] : AND condition
--- template
<MTAssets tag="image AND a">
<$MTAssetURL$></MTAssets>
--- expected
http://example.com/blog/test.jpg

=== MTAssets[tag] : AND condition (a public tag AND a private tag)
--- template
<MTAssets tag="image AND @first">
<$MTAssetURL$></MTAssets>
--- expected
http://example.com/blog/test.jpg
--- expected_php_todo
--- FIXME
https://movabletype.atlassian.net/browse/MTC-28120

=== MTEntryAssets
--- template
<MTEntries id="ENTRY_ID">
<MTEntryAssets sort_by="id" sort_order="ascend">
<$MTAssetURL$></MTEntryAssets>
</MTEntries>
--- expected
http://example.com/blog/test.jpg
http://example.com/blog/no_tag.jpg
http://example.com/blog/test.pdf

=== MTEntryAssets[tag] : Single tag
--- template
<MTEntries id="ENTRY_ID">
<MTEntryAssets tag="@first">
<$MTAssetURL$></MTEntryAssets>
</MTEntries>
--- expected
http://example.com/blog/test.jpg

=== MTEntryAssets[tag] : Multiple tags
--- template
<MTEntries id="ENTRY_ID">
<MTEntryAssets tag="image OR pdf" sort_by="id" sort_order="ascend">
<$MTAssetURL$></MTEntryAssets>
</MTEntries>
--- expected
http://example.com/blog/test.jpg
http://example.com/blog/test.pdf

=== MTEntryAssets[tag] : Multiple tags (comma separated)
--- template
<MTEntries id="ENTRY_ID">
<MTEntryAssets tag="image, pdf" sort_by="id" sort_order="ascend">
<$MTAssetURL$></MTEntryAssets>
</MTEntries>
--- expected
http://example.com/blog/test.jpg
http://example.com/blog/test.pdf
--- expected_php_todo
--- FIXME
https://movabletype.atlassian.net/browse/MTC-28119

=== MTEntryAssets[tag] : Multiple tags of same asset
--- template
<MTEntries id="ENTRY_ID">
<MTEntryAssets tag="image OR a">
<$MTAssetURL$></MTEntryAssets>
</MTEntries>
--- expected
http://example.com/blog/test.jpg

=== MTPageAssets
--- template
<MTPages id="PAGE_ID">
<MTPageAssets sort_by="id" sort_order="ascend">
<$MTAssetURL$></MTPageAssets>
</MTPages>
--- expected
http://example.com/blog/test.jpg
http://example.com/blog/no_tag.jpg
http://example.com/blog/test.pdf

=== MTPageAssets[tag] : Single tag
--- template
<MTPages id="PAGE_ID">
<MTPageAssets tag="@first">
<$MTAssetURL$></MTPageAssets>
</MTPages>
--- expected
http://example.com/blog/test.jpg

=== MTPageAssets[tag] : Multiple tags
--- template
<MTPages id="PAGE_ID">
<MTPageAssets tag="image OR pdf" sort_by="id" sort_order="ascend">
<$MTAssetURL$></MTPageAssets>
</MTPages>
--- expected
http://example.com/blog/test.jpg
http://example.com/blog/test.pdf

=== MTPageAssets[tag] : Multiple tags (comma separated)
--- template
<MTPages id="PAGE_ID">
<MTPageAssets tag="image, pdf" sort_by="id" sort_order="ascend">
<$MTAssetURL$></MTPageAssets>
</MTPages>
--- expected
http://example.com/blog/test.jpg
http://example.com/blog/test.pdf
--- expected_php_todo
--- FIXME
https://movabletype.atlassian.net/browse/MTC-28119

=== MTPageAssets[tag] : Multiple tags of same asset
--- template
<MTPages id="PAGE_ID">
<MTPageAssets tag="image OR a">
<$MTAssetURL$></MTPageAssets>
</MTPages>
--- expected
http://example.com/blog/test.jpg

=== MTAssets[namespace][scored_by]
--- template
<mt:Assets namespace="foo" scored_by="AUTHOR_NAME">a</mt:Assets>
--- expected
a

=== MTAssets[namespace=unknown][scored_by]
--- template
<mt:Assets namespace="bar" scored_by="AUTHOR_NAME">a</mt:Assets>
--- expected

=== MTAssets[namespace][scored_by=unknown]
--- template
<mt:Assets namespace="foo" scored_by="Nobody">a</mt:Assets>
--- expected_error
No such user 'Nobody'

=== MTAssets[namespace][scored_by] for score=0
--- template
<mt:Assets namespace="baz" scored_by="AUTHOR_NAME">a</mt:Assets>
--- expected
a

=== MTAssets[namespace][min_score=0]
--- template
<mt:Assets namespace="foo" min_score="0">a</mt:Assets>
--- expected
aaaaa

=== MTAssets[namespace][min_score]
--- template
<mt:Assets namespace="foo" min_score="3">a</mt:Assets>:<mt:Assets namespace="foo" min_score="4">b</mt:Assets>
--- expected
a:

=== MTAssets[namespace][max_score=0]
--- template
<mt:Assets namespace="foo" max_score="0">a</mt:Assets>
--- expected
aaaaa

=== MTAssets[namespace][max_score]
--- template
<mt:Assets namespace="foo" max_score="2">a</mt:Assets>:<mt:Assets namespace="foo" max_score="3">b</mt:Assets>
--- expected
:b

=== MTAssets[namespace][min_rate=0]
--- template
<mt:Assets namespace="foo" min_rate="0">a</mt:Assets>
--- expected
aaaaa

=== MTAssets[namespace][min_rate]
--- template
<mt:Assets namespace="foo" min_rate="3">a</mt:Assets>:<mt:Assets namespace="foo" min_rate="4">b</mt:Assets>
--- expected
a:

=== MTAssets[namespace][max_rate=0]
--- template
<mt:Assets namespace="foo" max_rate="0">a</mt:Assets>
--- expected
aaaaa

=== MTAssets[namespace][max_rate]
--- template
<mt:Assets namespace="foo" max_rate="2">a</mt:Assets>:<mt:Assets namespace="foo" max_rate="3">b</mt:Assets>
--- expected
:b

=== MTAssets[namespace][min_count=0]
--- template
<mt:Assets namespace="foo" min_count="0">a</mt:Assets>
--- expected
aaaaa

=== MTAssets[namespace][min_count]
--- template
<mt:Assets namespace="foo" min_count="1">a</mt:Assets>:<mt:Assets namespace="foo" min_count="2">b</mt:Assets>
--- expected
a:

=== MTAssets[namespace][max_count=0]
--- template
<mt:Assets namespace="foo" max_count="0">a</mt:Assets>
--- expected
aaaaa

=== MTAssets[namespace][max_count]
--- template
<mt:Assets namespace="foo" max_count="1">b</mt:Assets>
--- expected
b
