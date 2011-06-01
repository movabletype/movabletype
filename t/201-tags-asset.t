#!/usr/bin/perl
use strict;
use warnings;
use lib qw( t/lib lib extlib ../lib ../extlib );
use MT::Test::Tags;
run_tests_by_data();
__DATA__
-
  name: test item 234
  template: <MTAsset id='1'><$MTAssetID$></MTAsset>
  expected: 1

-
  name: test item 235
  template: <MTAssets type='image'><$MTAssetID$></MTAssets>
  expected: 1

-
  name: test item 236
  template: <MTAssets type='file'><$MTAssetID$></MTAssets>
  expected: 2

-
  name: test item 237
  template: <MTAssets type='all'><$MTAssetID$></MTAssets>
  expected: ''

-
  name: test item 238
  template: <MTAssets file_ext='jpg'><$MTAssetID$></MTAssets>
  expected: 1

-
  name: test item 239
  template: <MTAssets file_ext='tmpl'><$MTAssetID$></MTAssets>
  expected: 2

-
  name: test item 240
  template: <MTAssets file_ext='dat'><$MTAssetID$></MTAssets>
  expected: ''

-
  name: test item 241
  template: <MTAssets lastn='1'><$MTAssetID$></MTAssets>
  expected: 1

-
  name: test item 242
  template: <MTAssets days='1'><$MTAssetID$>;</MTAssets>
  expected: 1;

-
  name: test item 243
  template: <MTAssets author='Chuck D'><$MTAssetID$></MTAssets>
  expected: ''

-
  name: test item 244
  template: <MTAssets author='Melody'><$MTAssetID$>;</MTAssets>
  expected: 1;2;

-
  name: test item 245
  template: <MTAssets limit='1' offset='1'><$MTAssetID$></MTAssets>
  expected: 2

-
  name: test item 246
  template: <MTAssets limit='1' offset='2'><$MTAssetID$></MTAssets>
  expected: ''

-
  name: test item 247
  template: <MTAssets tag='alpha'><$MTAssetID$></MTAssets>
  expected: 1

-
  name: test item 248
  template: <MTAssets sort_by='file_name'><$MTAssetID$>;</MTAssets>
  expected: 2;1;

-
  name: test item 249
  template: <MTAssets sort_order='ascend'><$MTAssetID$>;</MTAssets>
  expected: 2;1;

-
  name: test item 250
  template: <MTAssets lastn='1'><$MTAssetFileName$></MTAssets>
  expected: test.jpg

-
  name: test item 251
  template: <MTAssets lastn='1'><$MTAssetURL$></MTAssets>
  expected: "http://narnia.na/nana/images/test.jpg"

-
  name: test item 252
  template: <MTAssets lastn='1'><$MTAssetType$></MTAssets>
  expected: image

-
  name: test item 253
  template: <MTAssets lastn='1'><$MTAssetMimeType$></MTAssets>
  expected: image/jpeg

-
  name: test item 254
  template: <MTAssets lastn='1'><$MTAssetFilePath$></MTAssets>
  expected: CURRENT_WORKING_DIRECTORY/t/images/test.jpg

-
  name: test item 255
  template: <MTAssets limit='1' sort_order='ascend'><$MTAssetDateAdded$></MTAssets>
  expected: "January 31, 1978  7:45 AM"

-
  name: test item 256
  template: <MTAssets lastn='1'><$MTAssetAddedBy$></MTAssets>
  expected: Melody

-
  name: test item 257
  template: <MTAssets lastn='1'><$MTAssetProperty property='file_size'$></MTAssets>
  expected: 84.1 KB

-
  name: test item 258
  template: <MTAssets lastn='1'><$MTAssetProperty property='file_size' format='0'$></MTAssets>
  expected: 86094

-
  name: test item 259
  template: <MTAssets lastn='1'><$MTAssetProperty property='file_size' format='1'$></MTAssets>
  expected: 84.1 KB

-
  name: test item 260
  template: <MTAssets lastn='1'><$MTAssetProperty property='file_size' format='k'$></MTAssets>
  expected: 84.1

-
  name: test item 261
  template: <MTAssets lastn='1'><$MTAssetProperty property='file_size' format='m'$></MTAssets>
  expected: 0.1

-
  name: test item 262
  template: <MTAssets lastn='1' type='image'><$MTAssetProperty property='image_width'$></MTAssets>
  expected: 640

-
  name: test item 263
  template: <MTAssets lastn='1' type='image'><$MTAssetProperty property='image_height'$></MTAssets>
  expected: 480

-
  name: test item 264
  template: <MTAssets lastn='1' type='file'><$MTAssetProperty property='image_width'$></MTAssets>
  expected: 0

-
  name: test item 265
  template: <MTAssets lastn='1' type='file'><$MTAssetProperty property='image_height'$></MTAssets>
  expected: 0

-
  name: test item 266
  template: <MTAssets limit='1' sort_order='ascend'><$MTAssetProperty property='image_width'$></MTAssets>
  expected: 0

-
  name: test item 267
  template: <MTAssets limit='1' sort_order='ascend'><$MTAssetProperty property='image_height'$></MTAssets>
  expected: 0

-
  name: test item 268
  template: <MTAssets limit='1' sort_order='ascend'><$MTAssetProperty property='image_width'$></MTAssets>
  expected: 0

-
  name: test item 269
  template: <MTAssets limit='1' sort_order='ascend'><$MTAssetProperty property='image_height'$></MTAssets>
  expected: 0

-
  name: test item 270
  template: <MTAssets lastn='1'><$MTAssetProperty property='label'$></MTAssets>
  expected: Image photo

-
  name: test item 271
  template: <MTAssets lastn='1'><$MTAssetProperty property='description'$></MTAssets>
  expected: This is a test photo.

-
  name: test item 272
  template: <MTAssets lastn='1'><$MTAssetFileExt$></MTAssets>
  expected: jpg

-
  name: test item 273
  template: <MTAssets lastn='1'><$MTAssetThumbnailURL width='160'$></MTAssets>
  expected: "http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-160xauto-1.jpg"

-
  name: test item 274
  template: <MTAssets lastn='1'><$MTAssetThumbnailURL height='240'$></MTAssets>
  expected: "http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-autox240-1.jpg"

-
  name: test item 275
  template: <MTAssets lastn='1'><$MTAssetThumbnailURL scale='75'$></MTAssets>
  expected: "http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-480x360-1.jpg"

-
  name: test item 276
  template: <MTAssets lastn='1'><$MTAssetLink$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\">test.jpg</a>"

-
  name: test item 277
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg\" width=\"640\" height=\"480\" alt=\"\" /></a>"

-
  name: test item 278
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink width='160'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-160xauto-1.jpg\" width=\"160\" height=\"120\" alt=\"\" /></a>"

-
  name: test item 279
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink height='240'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-autox240-1.jpg\" width=\"320\" height=\"240\" alt=\"\" /></a>"

-
  name: test item 280
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink scale='100'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg\" width=\"640\" height=\"480\" alt=\"\" /></a>"

-
  name: test item 281
  template: <MTAssets lastn='1'><$MTAssetLink new_window='1'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\" target=\"_blank\">test.jpg</a>"

-
  name: test item 282
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink new_window='1'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\" target=\"_blank\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg\" width=\"640\" height=\"480\" alt=\"\" /></a>"

-
  name: test item 283
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink new_window='1' width='160'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\" target=\"_blank\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-160xauto-1.jpg\" width=\"160\" height=\"120\" alt=\"\" /></a>"

-
  name: test item 284
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink new_window='1' scale='100'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\" target=\"_blank\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg\" width=\"640\" height=\"480\" alt=\"\" /></a>"

-
  name: test item 285
  template: <MTAssets lastn='1'><$MTAssetThumbnailLink new_window='1' scale='100'$></MTAssets>
  expected: "<a href=\"http://narnia.na/nana/images/test.jpg\" target=\"_blank\"><img src=\"http://narnia.na/nana/assets_c/CURRENT_YEAR/CURRENT_MONTH/test-thumb-640x480-1.jpg\" width=\"640\" height=\"480\" alt=\"\" /></a>"

-
  name: test item 286
  template: <$MTAssetCount$>
  expected: 2

-
  name: test item 287
  template: |
    <MTAssets lastn='1'>
      <MTAssetTags>
        <$MTTagName$>;
      </MTAssetTags>
    </MTAssets>
  expected: |
    alpha;
    beta;
    gamma;

-
  name: test item 288
  template: |
    <MTAssets>
      <MTAssetsHeader>(Head)</MTAssetsHeader>
      <$MTAssetID$>;
      <MTAssetsFooter>(Last)</MTAssetsFooter>
    </MTAssets>
  expected: |
    (Head)
    1;
    2;
    (Last)

-
  name: test item 304
  template: |
    <MTAssets sort_by="score" namespace="unit test">
      <MTAssetID>;
    </MTAssets>
  expected: |
    1;
    2;

-
  name: test item 358
  template: |
    <MTAssets lastn='1'>
      <$MTAssetlabel$>
    </MTAssets>
  expected: |
    Image photo

-
  name: test item 359
  template: |
    <MTEntries id='1'>
      <MTEntryAssets><$MTAssetID$></MTEntryAssets>
    </MTEntries>
  expected: 1

-
  name: test item 360
  template: |
    <MTPages id='20'>
      <MTPageAssets><$MTAssetID$></MTPageAssets>
    </MTPages>
  expected: 2

-
  name: test item 393
  template: <MTAssets lastn='1'><$MTAssetLabel$></MTAssets>
  expected: Image photo

-
  name: test item 394
  template: <MTAssets lastn='1'><$MTAssetDescription$></MTAssets>
  expected: This is a test photo.

-
  name: test item 495
  template: <MTAssets assets_per_row="2"><MTAssetIsFirstInRow>First</MTAssetIsFirstInRow><MTAssetIsLastInRow>Last</MTAssetIsLastInRow></MTAssets>
  expected: FirstLast

-
  name: test item 496
  template: |
    <MTAssets lastn='1'>
      <MTAssetIfTagged tag="alpha">
        Tagged
      <MTElse>
        Not Tagged
      </MTAssetIfTagged>
    </MTAssets>
  expected: Tagged

-
  name: test item 497
  template: |
    <MTAssets lastn='1'>
      <MTAssetIfTagged tag="empty_tag_name">
        Tagged
      <MTElse>
        Not Tagged
      </MTAssetIfTagged>
    </MTAssets>
  expected: Not Tagged


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

