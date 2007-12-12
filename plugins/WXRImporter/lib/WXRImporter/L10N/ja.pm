# WXRImporter plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
package WXRImporter::L10N::ja;

use strict;
use base 'WXRImporter::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
    'File is not in WXR format.' => 'WXRフォーマットではありません。',
    'Saving asset (\'[_1]\')...' => 'アイテム(\'[_1]\')を保存しています...',
    ' and asset will be tagged (\'[_1]\')...' => 'アイテムにタグ([_1])を付けています...',
    'Saving page (\'[_1]\')...' => 'ウェブページ(\'[_1]\')を保存しています...',

## plugins/WXRImporter/lib/WXRImporter/Import.pm

## plugins/WXRImporter/tmpl/options.tmpl
    'Before you import WordPress posts to Movable Type, we recommend that you <a href=\'[_1]\'>configure your blog\'s publishing paths</a> first.' => 'WordPressからMovable Typeへインポートする前に、ま
ず<a href=\'[_1]\'>ブログ公開パスを設定</a>してください。',
    'Upload path for this WordPress blog' => 'WordPressブログのアップロードパス',
    'Replace with' => '置き換えるパス',

## plugins/WXRImporter/WXRImporter.pl
    'Import WordPress exported RSS into MT.' => 'WordPressからエクスポートされたRSSをMTにインポートします。',
    'WordPress eXtended RSS (WXR)' => 'WordPress eXtended RSS (WXR)',

);

1;

