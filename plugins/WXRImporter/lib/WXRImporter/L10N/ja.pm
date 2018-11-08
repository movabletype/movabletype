# WXRImporter plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
package WXRImporter::L10N::ja;

use strict;
use warnings;
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
	'No Site' => 'サイトがありません',

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'WXRフォーマットではありません。',
	'Creating new tag (\'[_1]\')...' => 'タグ(\'[_1]\')を作成しています...',
	'Saving tag failed: [_1]' => 'タグを保存できませんでした: [_1]',
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'アセット「[_1]」は既にインポートされているのでスキップします。',
	'Saving asset (\'[_1]\')...' => 'アセット(\'[_1]\')を保存しています...',
	' and asset will be tagged (\'[_1]\')...' => 'アセットにタグ([_1])を付けています...',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => '記事「[_1]」は既にインポートされているのでスキップします。',
	'Saving page (\'[_1]\')...' => 'ウェブページ(\'[_1]\')を保存しています...',
	'Creating new comment (from \'[_1]\')...' => '\'[_1]\'からのコメントをインポートしています...',
	'Saving comment failed: [_1]' => 'コメントを保存できませんでした: [_1]',
	'Entry has no MT::Trackback object!' => '記事にトラックバックの設定がありません',
	'Creating new ping (\'[_1]\')...' => '\'[_1]\'のトラックバックをインポートしています...',
	'Saving ping failed: [_1]' => 'トラックバックを保存できませんでした: [_1]',
	'Assigning permissions for new user...' => '新しいユーザーに権限を追加しています...',
	'Saving permission failed: [_1]' => '権限の保存中にエラーが発生しました: [_1]',

## plugins/WXRImporter/tmpl/options.tmpl
	q{Before you import WordPress posts to Movable Type, we recommend that you <a href='[_1]'>configure your site's publishing paths</a> first.} => q{WordPressからMovable Typeへインポートする前に、まず<a href='[_1]'>サイトパスを設定</a>してください。},
	'Upload path for this WordPress blog' => 'メディアのアップロードパス',
	'Replace with' => '置き換えるパス',
	'Download attachments' => 'Attachmentのダウンロード',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'WordPressのブログからAttachmentをダウンロードするには、cronなどの決められたタイミングでプログラムを実行する環境が必要です。',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'インポート中に、既存のWordPressで公開されているブログからAttachment（画像やファイル）をダウンロードします。',

);

1;

