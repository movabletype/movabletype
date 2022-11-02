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
	'"Download WP attachments via HTTP."' => 'WordPressのAttachmentをHTTP経由でダウンロードします。',
	'"WordPress eXtended RSS (WXR)"' => 'WordPress eXtended RSS (WXR)',
	'Import WordPress exported RSS into MT.' => 'WordPressからエクスポートされたRSSをMTにインポートします。',

## plugins/WXRImporter/lib/WXRImporter/Import.pm
	'Archive Root' => 'アーカイブパス',
	'Need either ImportAs or ParentAuthor' => '「自分の記事としてインポートする」か「記事の著者を変更しない」のどちらかを選択してください。',
	'No Site' => 'サイトがありません',
	'Site Root' => 'サイトパス',
	'You need to provide a password if you are going to create new users for each user listed in your site.' => 'サイトにユーザーを追加するためには、パスワードを指定する必要があります。',
	q{Invalid extra path '[_1]'} => q{追加パス'[_1]'が不正です。},

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'Assigning permissions for new user...' => '新しいユーザーに権限を追加しています...',
	'Entry has no MT::Trackback object!' => '記事にトラックバックの設定がありません',
	'File is not in WXR format.' => 'WXRフォーマットではありません。',
	'Save failed: [_1]' => '保存できませんでした: [_1]',
	'Saving category failed: [_1]' => 'カテゴリを保存できませんでした: [_1]',
	'Saving comment failed: [_1]' => 'コメントを保存できませんでした: [_1]',
	'Saving entry failed: [_1]' => '記事を保存できませんでした: [_1]',
	'Saving permission failed: [_1]' => '権限の保存中にエラーが発生しました: [_1]',
	'Saving ping failed: [_1]' => 'トラックバックを保存できませんでした: [_1]',
	'Saving placement failed: [_1]' => '記事とカテゴリの関連付けを設定できませんでした: [_1]',
	'Saving tag failed: [_1]' => 'タグを保存できませんでした: [_1]',
	'Saving user failed: [_1]' => 'ユーザーを作成できませんでした: [_1]',
	'failed' => '失敗',
	'ok (ID [_1])' => '完了 (ID [_1])',
	'ok' => 'OK',
	q{ and asset will be tagged ('[_1]')...} => q{アセットにタグ([_1])を付けています...},
	q{Creating new category ('[_1]')...} => q{カテゴリ([_1])を作成しています...},
	q{Creating new comment (from '[_1]')...} => q{'[_1]'からのコメントをインポートしています...},
	q{Creating new ping ('[_1]')...} => q{'[_1]'のトラックバックをインポートしています...},
	q{Creating new tag ('[_1]')...} => q{タグ('[_1]')を作成しています...},
	q{Creating new user ('[_1]')...} => q{ユーザー([_1])を作成しています...},
	q{Duplicate asset ('[_1]') found.  Skipping.} => q{アセット「[_1]」は既にインポートされているのでスキップします。},
	q{Duplicate entry ('[_1]') found.  Skipping.} => q{記事「[_1]」は既にインポートされているのでスキップします。},
	q{Saving asset ('[_1]')...} => q{アセット('[_1]')を保存しています...},
	q{Saving entry ('[_1]')...} => q{記事([_1])を保存しています...},
	q{Saving page ('[_1]')...} => q{ウェブページ('[_1]')を保存しています...},

## plugins/WXRImporter/tmpl/options.tmpl
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'インポート中に、既存のWordPressで公開されているブログからAttachment（画像やファイル）をダウンロードします。',
	'Download attachments' => 'Attachmentのダウンロード',
	'Replace with' => '置き換えるパス',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'WordPressのブログからAttachmentをダウンロードするには、cronなどの決められたタイミングでプログラムを実行する環境が必要です。',
	'Upload path for this WordPress blog' => 'メディアのアップロードパス',
	q{Before you import WordPress posts to Movable Type, we recommend that you <a href='[_1]'>configure your site's publishing paths</a> first.} => q{WordPressからMovable Typeへインポートする前に、まず<a href='[_1]'>サイトパスを設定</a>してください。},
);

1;
