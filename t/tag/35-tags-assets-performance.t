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

use MT::Test;
use MT::Test::Fixture;
use MT::Test::Image;
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

my ($year, $month) = unpack('A4A2', $asset->created_on);

ok !$test_env->files(MT->config->AssetCacheDir), "nothing exists under the asset cache dir yet";

my ($squared_thumbnail) = $asset->thumbnail_file(Square => 1, Width => 50);
ok -f $squared_thumbnail, "squared thumbnail exists now";

my ($scaled_thumbnail) = $asset->thumbnail_file(Scale => 50);
ok -f $scaled_thumbnail, "scaled thumbnail exists now";

my %vars = (
    EXISTING_ASSET_ID => $asset->id,
    REMOVED_ASSET_ID  => $removed_asset->id,
    FILE_ASSET_ID     => $file_asset->id,
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
require MT::ObjectTag;
{
    no warnings 'once';
    *MT::ObjectTag::load = sub {
        fail "Should not be called MT::ObjectTag::load. We should only use JOIN statement.";
    };
}

MT::Test::Tag->run_perl_tests($website->id);
MT::Test::Tag->run_php_tests($website->id);

done_testing;

__END__

=== MTAssetThumbnailURL for ordinary image (no scale)
--- template
<MTAsset id="EXISTING_ASSET_ID">
<$MTAssetURL$>: <$MTAssetThumbnailURL _default="blank"$>
</MTAsset>
--- expected
http://example.com/blog/test.jpg: http://example.com/blog/assets_c/YEAR/MONTH/test-thumb-640x480-1.jpg

=== MTAssetThumbnailURL for ordinary image (scale 50)
--- template
<MTAsset id="EXISTING_ASSET_ID">
<$MTAssetURL$>: <$MTAssetThumbnailURL scale="50" _default="blank"$>
</MTAsset>
--- expected
http://example.com/blog/test.jpg: http://example.com/blog/assets_c/YEAR/MONTH/test-thumb-320x240-1.jpg

=== MTAssetThumbnailURL for ordinary image (square size 50)
--- template
<MTAsset id="EXISTING_ASSET_ID">
<$MTAssetURL$>: <$MTAssetThumbnailURL square="1" height="50" _default="blank"$>
</MTAsset>
--- expected
http://example.com/blog/test.jpg: http://example.com/blog/assets_c/YEAR/MONTH/test-thumb-50x50-1.jpg

=== MTAssetThumbnailURL for removed file (no reading image even with the scale attribute)
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

=== MTAssets[tag] : Contains "OR" in tag name
--- SKIP_PHP
--- template
<MTAssets tag="a OR b">
<$MTAssetURL$></MTAssets>
--- expected
http://example.com/blog/test.txt

=== MTAssets[tag] : Multiple tags
--- SKIP_PHP
--- template
<MTAssets tag="pdf OR @first" sort_by="id" sort_order="ascend">
<$MTAssetURL$></MTAssets>
--- expected
http://example.com/blog/test.jpg
http://example.com/blog/test.pdf

=== MTAssets[tag] : Multiple tags (comma separated)
--- SKIP_PHP
--- template
<MTAssets tag="pdf, @first" sort_by="id" sort_order="ascend">
<$MTAssetURL$></MTAssets>
--- expected
http://example.com/blog/test.jpg
http://example.com/blog/test.pdf

=== MTAssets[tag] : Multiple tags of same asset
--- SKIP_PHP
--- template
<MTAssets tag="image OR @first">
<$MTAssetURL$></MTAssets>
--- expected
http://example.com/blog/test.jpg
