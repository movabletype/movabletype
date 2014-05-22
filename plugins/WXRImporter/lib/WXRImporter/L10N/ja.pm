# WXRImporter plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
package WXRImporter::L10N::ja;

use strict;
use utf8;
use base 'WXRImporter::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (

## plugins/WXRImporter/config.yaml
	'Import WordPress exported RSS into MT.' => 'WordPressからエクスポートされたRSSをMTにインポートします。',
	'"WordPress eXtended RSS (WXR)"' => 'WordPress eXtended RSS (WXR)',
	'"Download WP attachments via HTTP."' => 'WordPressのAttachmentをHTTP経由でダウンロードします。',

## plugins/WXRImporter/lib/WXRImporter/Import.pm

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'WXRフォーマットではありません。',
	'Creating new tag (\'[_1]\')...' => 'タグ(\'[_1]\')を作成しています...',
	'Saving tag failed: [_1]' => 'タグを保存できませんでした: [_1]',
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'アイテム「[_1]」は既にインポートされているのでスキップします。',
	'Saving asset (\'[_1]\')...' => 'アイテム(\'[_1]\')を保存しています...',
	' and asset will be tagged (\'[_1]\')...' => 'アイテムにタグ([_1])を付けています...',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => '記事「[_1]」は既にインポートされているのでスキップします。',
	'Saving page (\'[_1]\')...' => 'ウェブページ(\'[_1]\')を保存しています...',
	'Entry has no MT::Trackback object!' => '記事にトラックバックの設定がありません',
	'Assigning permissions for new user...' => '新しいユーザーに権限を追加しています...',
	'Saving permission failed: [_1]' => '権限の保存中にエラーが発生しました: [_1]',

## plugins/WXRImporter/tmpl/options.tmpl
	q{Before you import WordPress posts to Movable Type, we recommend that you <a href='[_1]'>configure your blog's publishing paths</a> first.} => q{WordPressからMovable Typeへインポートする前に、まず<a href='[_1]'>ブログ公開パスを設定</a>してください。},
	'Upload path for this WordPress blog' => 'WordPressブログのアップロードパス',
	'Replace with' => '置き換えるパス',
	'Download attachments' => 'Attachmentのダウンロード',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'WordPressのブログからAttachmentをダウンロードするには、cronなどの決められたタイミングでプログラムを実行する環境が必要です。',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'インポート中に、既存のWordPressで公開されているブログからAttachment（画像やファイル）をダウンロードします。',

);

1;

