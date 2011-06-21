#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;


my $mt = MT->instance;

my %assets         = ();
my %assets_to_load = qw(
    asset 1
    old_asset 2
    file_asset 2
);
while ( my ( $key, $id ) = each(%assets_to_load) ) {
    $assets{$key} = MT->model('asset')->load($id);
}

my $asset_page = MT->model('page')->load(20);

local $MT::Test::Tags::PRERUN = sub {
    my ($stock) = @_;
    $stock->{$_} = $assets{$_} for keys(%assets);
    $stock->{'asset_page'} = $asset_page;
};
local $MT::Test::Tags::PRERUN_PHP
    = '$stock["asset_page"] = $db->fetch_page(' . $asset_page->id . ');'
    . 'require_once("class.mt_asset.php");'
    . '$asset  = new Asset;'
    . join( '', map({
          '$assets = $asset->Find("asset_id = ' . $assets{$_}->id . '");'
        . '$stock["' . $_ . '"] = $assets[0];';
    } keys(%assets)));


run_tests_by_data();
__DATA__
-
  name: AssetID prints the ID of the asset.
  template: <$MTAssetID$>
  expected: 1
  stash:
    asset: $asset

-
  name: Assets with an attribute "type=image" lists assets whose type is image.
  template: <MTAssets type='image'><$MTAssetID$></MTAssets>
  expected: 1

-
  name: Assets with an attribute "type=file" lists assets whose type is file.
  template: <MTAssets type='file'><$MTAssetID$></MTAssets>
  expected: 2

-
  name: Assets with an attribute "type=all" lists no assets. Because the "all" is invalid type.
  template: <MTAssets type='all'><$MTAssetID$></MTAssets>
  expected: ''

-
  name: Assets with an attribute "file_ext=jpg" lists assets whose extension is "jpg".
  template: <MTAssets file_ext='jpg'><$MTAssetID$></MTAssets>
  expected: 1

-
  name: Assets with an attribute "file_ext=tmpl" lists assets whose extension is "tmpl".
  template: <MTAssets file_ext='tmpl'><$MTAssetID$></MTAssets>
  expected: 2

-
  name: Assets with an attribute "file_ext=dat" lists assets whose extension is "dat".
  template: <MTAssets file_ext='dat'><$MTAssetID$></MTAssets>
  expected: ''

-
  name: Assets with an attribute "lastn=1" lists the latest N assets.
  template: <MTAssets lastn='1'><$MTAssetID$></MTAssets>
  expected: 1

-
  name: Assets with an attribute "days=1" lists assets posted in specified day or less.
  template: <MTAssets days='1'><$MTAssetID$>;</MTAssets>
  expected: 1;

-
  name: Assets with an attribute "author=Chuck D" lists assets posted by specified author.
  template: <MTAssets author='Chuck D'><$MTAssetID$></MTAssets>
  expected: ''

-
  name: Assets with an attribute "author=Melody" lists assets posted by specified author.
  template: <MTAssets author='Melody'><$MTAssetID$>;</MTAssets>
  expected: 1;2;

-
  name: Assets with attributes "limit=1" and "offset=1" lists the top N assets with specified offset.
  template: <MTAssets limit='1' offset='1'><$MTAssetID$></MTAssets>
  expected: 2

-
  name: Assets with attributes "limit=1" and "offset=2" lists the top N assets with specified offset.
  template: <MTAssets limit='1' offset='2'><$MTAssetID$></MTAssets>
  expected: ''

-
  name: Assets with an attribute "tag" lists assets related to the specified tag.
  template: <MTAssets tag='alpha'><$MTAssetID$></MTAssets>
  expected: 1

-
  name: Assets with an attribute "sort_by=file_name" sorts by filename and lists assets.
  template: <MTAssets sort_by='file_name'><$MTAssetID$>;</MTAssets>
  expected: 2;1;

-
  name: Assets with an attribute "sort_order" sorts by created-time with specified order and lists assets.
  template: <MTAssets sort_order='ascend'><$MTAssetID$>;</MTAssets>
  expected: 2;1;

-
  name: AssetURL prints the URL of the asset.
  template: <$MTAssetURL$>
  expected: "http://narnia.na/nana/images/test.jpg"
  stash:
    asset: $asset

-
  name: AssetType prints the type of the asset.
  template: <$MTAssetType$>
  expected: image
  stash:
    asset: $asset

-
  name: AssetMimeType prints the mime-type of the asset.
  template: <$MTAssetMimeType$>
  expected: image/jpeg
  stash:
    asset: $asset

-
  name: AssetFilePath prints the file path of the asset.
  template: <$MTAssetFilePath$>
  expected: CURRENT_WORKING_DIRECTORY/t/images/test.jpg
  stash:
    asset: $asset

-
  name: AssetDateAdded prints the created-time of the asset.
  template: <$MTAssetDateAdded$>
  expected: "January 31, 1978  7:45 AM"
  stash:
    asset: $old_asset

-
  name: AssetAddedBy prints the name of the author who uploads the asset.
  template: <$MTAssetAddedBy$>
  expected: Melody
  stash:
    asset: $asset

-
  name: AssetProperty with an attribute "property=file_size" prints the file size of the asset.
  template: <$MTAssetProperty property='file_size'$>
  expected: 84.1 KB
  stash:
    asset: $asset

-
  name: AssetProperty with attributes "property=file_size" and "format=0" prints the file size of the asset in bytes.
  template: <$MTAssetProperty property='file_size' format='0'$>
  expected: 86094
  stash:
    asset: $asset

-
  name: AssetProperty with attributes "property=file_size" and "format=1" prints the file size of the asset in kiro bytes with unit.
  template: <$MTAssetProperty property='file_size' format='1'$>
  expected: 84.1 KB
  stash:
    asset: $asset

-
  name: AssetProperty with attributes "property=file_size" and "format=k" prints the file size of the asset in kiro bytes.
  template: <$MTAssetProperty property='file_size' format='k'$>
  expected: 84.1
  stash:
    asset: $asset

-
  name: AssetProperty with attributes "property=file_size" and "format=m" prints the file size of the asset in mega bytes.
  template: <$MTAssetProperty property='file_size' format='m'$>
  expected: 0.1
  stash:
    asset: $asset

-
  name: AssetProperty with attributes "property=image_width" prints the image width of the asset.
  template: <$MTAssetProperty property='image_width'$>
  expected: 640
  stash:
    asset: $asset

-
  name: AssetProperty with attributes "property=image_height" prints the image height of the asset.
  template: <$MTAssetProperty property='image_height'$>
  expected: 480
  stash:
    asset: $asset

-
  name: AssetProperty with attributes "property=image_width" prints zero if the current image is not image.
  template: <$MTAssetProperty property='image_width'$>
  expected: 0
  stash:
    asset: $file_asset

-
  name: AssetProperty with attributes "property=image_height" prints zero if the current image is not image.
  template: <$MTAssetProperty property='image_height'$>
  expected: 0
  stash:
    asset: $file_asset

-
  name: AssetProperty with attributes "property=label" prints the label of the asset.
  template: <$MTAssetProperty property='label'$>
  expected: Image photo
  stash:
    asset: $asset

-
  name: AssetProperty with attributes "property=description" prints the description of the asset.
  template: <$MTAssetProperty property='description'$>
  expected: This is a test photo.
  stash:
    asset: $asset

-
  name: AssetFileExt prints the extension of the asset.
  template: <$MTAssetFileExt$>
  expected: jpg
  stash:
    asset: $asset

-
  name: AssetThumbnailURL with an attribute "width=160" prints the URL of the thumnail of the asset.
  template: <$MTAssetThumbnailURL width='160'$>
  expected: "http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-160xauto-1.jpg"
  stash:
    asset: $asset

-
  name: AssetThumbnailURL with an attribute "width=240" prints the URL of the thumnail of the asset.
  template: <$MTAssetThumbnailURL height='240'$>
  expected: "http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-autox240-1.jpg"
  stash:
    asset: $asset

-
  name: AssetThumbnailURL with an attribute "scale=75" prints the URL of the thumnail of the asset.
  template: <$MTAssetThumbnailURL scale='75'$>
  expected: "http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-480x360-1.jpg"
  stash:
    asset: $asset

-
  name: AssetLink prints the anchor tag to the asset.
  template: <$MTAssetLink$>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\">test.jpg</a>"
  stash:
    asset: $asset

-
  name: AssetThumbnailLink prints the anchor tag to the thumbnail of the asset.
  template: <$MTAssetThumbnailLink$>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg\" width=\"640\" height=\"480\" alt=\"\" /></a>"
  stash:
    asset: $asset

-
  name: AssetThumbnailLink with an attribute "width=160" prints the anchor tag to the thumbnail of the asset.
  template: <$MTAssetThumbnailLink width='160'$>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-160xauto-1.jpg\" width=\"160\" height=\"120\" alt=\"\" /></a>"
  stash:
    asset: $asset

-
  name: AssetThumbnailLink with an attribute "width=240" prints the anchor tag to the thumbnail of the asset.
  template: <$MTAssetThumbnailLink height='240'$>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-autox240-1.jpg\" width=\"320\" height=\"240\" alt=\"\" /></a>"
  stash:
    asset: $asset

-
  name: AssetThumbnailLink with an attribute "scale=100" prints the anchor tag to the thumbnail of the asset.
  template: <$MTAssetThumbnailLink scale='100'$>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg\" width=\"640\" height=\"480\" alt=\"\" /></a>"
  stash:
    asset: $asset

-
  name: AssetLink with an attribute "new_window" prints the anchor tag to open in a new window.
  template: <$MTAssetLink new_window='1'$>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\" target=\"_blank\">test.jpg</a>"
  stash:
    asset: $asset

-
  name: AssetThumbnailLink with an attribute "new_window" prints the anchor tag to open in a new window.
  template: <$MTAssetThumbnailLink new_window='1'$>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\" target=\"_blank\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg\" width=\"640\" height=\"480\" alt=\"\" /></a>"
  stash:
    asset: $asset

-
  name: AssetThumbnailLink with attributes "new_window" and "width=160" prints the anchor tag to open in a new window.
  template: <$MTAssetThumbnailLink new_window='1' width='160'$>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\" target=\"_blank\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-160xauto-1.jpg\" width=\"160\" height=\"120\" alt=\"\" /></a>"
  stash:
    asset: $asset

-
  name: AssetThumbnailLink with attributes "new_window" and "scale=100" prints the anchor tag to open in a new window.
  template: <$MTAssetThumbnailLink new_window='1' scale='100'$>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\" target=\"_blank\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg\" width=\"640\" height=\"480\" alt=\"\" /></a>"
  stash:
    asset: $asset

-
  name: AssetCount prints the number of the assets in the blog.
  template: <$MTAssetCount$>
  expected: 2

-
  name: AssetTags lists the tags related to the asset.
  template: |
    <MTAssetTags>
      <$MTTagName$>
    </MTAssetTags>
  expected: |
    alpha
    beta
    gamma
  stash:
    asset: $asset

-
  name: AssetsHeader and AssetsFooter prints header and footer.
  template: |
    <MTAssets>
      <MTAssetsHeader>(Head)</MTAssetsHeader>
      <$MTAssetID$>
      <MTAssetsFooter>(Last)</MTAssetsFooter>
    </MTAssets>
  expected: |
    (Head)
    1
    2
    (Last)

-
  name: Assets with an attribute "sort_by=score" sorts by score and lists assets.
  template: |
    <MTAssets sort_by="score" namespace="unit test">
      <MTAssetID>
    </MTAssets>
  expected: |
    1
    2

-
  name: AssetLabel prints the label of the asset.
  template: |
    <$MTAssetlabel$>
  expected: |
    Image photo
  stash:
    asset: $asset

-
  name: AssetDescription prints the description of the asset.
  template: <$MTAssetDescription$>
  expected: This is a test photo.
  stash:
    asset: $asset

-
  name: EntryAssets lists assets related to the entry.
  template: |
    <MTEntryAssets><$MTAssetID$></MTEntryAssets>
  expected: 1
  stash:
    entry: $entry

-
  name: PageAssets lists assets related to the page.
  template: |
    <MTPageAssets><$MTAssetID$></MTPageAssets>
  expected: 2
  stash:
    entry: $asset_page

-
  name: Assets with an attribute "assets_per_row" creates table. AssetIsFirstInRow and AssetIsLastInRow prints inner contents if the first row or the last row.
  template: <MTAssets assets_per_row="2"><MTAssetIsFirstInRow>First</MTAssetIsFirstInRow><MTAssetIsLastInRow>Last</MTAssetIsLastInRow></MTAssets>
  expected: FirstLast

-
  name: AssetIfTagged with an attribute "tag" prints the inner contents if the asset has a specified tag.
  template: |
    <MTAssetIfTagged tag="alpha">
      Tagged
    <MTElse>
      Not Tagged
    </MTAssetIfTagged>
  expected: Tagged
  stash:
    asset: $asset

-
  name: AssetIfTagged with an attribute "tag" doesn't print the inner contents if the asset doesn't have a specified tag.
  template: |
    <MTAssetIfTagged tag="empty_tag_name">
      Tagged
    <MTElse>
      Not Tagged
    </MTAssetIfTagged>
  expected: Not Tagged
  stash:
    asset: $asset


######## Assets
## type
## file_ext
## days
## author
## lastn
## limit
## offset
## tag
## sort_by
## sort_order
## namespace
## assets_per_row

######## Asset
## id

######## EntryAssets

######## PageAssets

######## AssetsHeader

######## AssetsFooter

######## AssetIsFirstInRow

######## AssetIsLastInRow

######## AssetID

######## AssetFileName

######## AssetLabel

######## AssetDescription

######## AssetURL

######## AssetType

######## AssetMimeType

######## AssetFilePath

######## AssetDateAdded
## format
## language
## utc

######## AssetAddedBy

######## AssetProperty
## property (required)
## file_size
## image_width
## image_height
## description
## format
## 0
## 1 (default)
## k
## m

######## AssetFileExt

######## AssetThumbnailURL
## height
## width
## scale
## square

######## AssetLink
## new_window (optional; default "0")

######## AssetThumbnailLink
## height
## width
## scale
## new_window (optional; default "0")

######## AssetCount

