# Movable Type (r) Open Source (C) 2005-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package StyleCatcher::L10N::ja;

use strict;
use base 'StyleCatcher::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (

## plugins/StyleCatcher/stylecatcher.pl
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'StyleCatcherを使うと、ほんの数回クリックするだけでスタイルを探してブログに適用することができます。Movable Typeのスタイルについての詳細やスタイルの配布元については、<a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a>のページ（英語）へアクセスしてください。',
	'MT 4 Style Library' => 'MT 4 スタイルライブラリ',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Movable Type 4のデフォルトテンプレートと互換性のあるスタイルです。',
	'MT 3 Style Library' => 'MT 3 スタイルライブラリ',
	'A collection of styles compatible with Movable Type 3.3+ default templates.' => 'Movable Type 3.3xのデフォルトテンプレートと互換性のあるスタイルです。',
	'Styles' => 'スタイル',

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'mt-staticディレクトリが見つかりませんでした。StaticFilePathを設定してください。', # Translate - New
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => '[_1] フォルダが作成できません。\'themes\' フォルダが書き込み可能か確認してください。',
	'Error downloading image: [_1]' => '画像をダウンロードできませんでした: [_1]',
	'Successfully applied new theme selection.' => '新しいテーマを適用しました。',
	'Invalid URL: [_1]' => 'URLが不正です: [_1]',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a Style' => 'スタイルを選択',
	'3-Columns, Wide, Thin, Thin' => '3カラム、大・小・小',
	'3-Columns, Thin, Wide, Thin' => '3カラム、小・大・小',
	'2-Columns, Thin, Wide' => '2カラム、小・大',
	'2-Columns, Wide, Thin' => '2カラム、大・小',
	'None available' => '見つかりません',
	'Applying...' => '適用中...',
	'Apply Design' => 'デザインを適用',
	'Error applying theme: ' => 'テーマを適用中にエラーが発生しました。',
	'The selected theme has been applied, but as you have changed the layout, you will need to republish your blog to apply the new layout.' => 'テーマを適用しました。レイアウトも変更されたので、再構築する必要があります。',
	'The selected theme has been applied!' => 'テーマを適用しました。',
	'Error loading themes! -- [_1]' => 'テーマの読み込みでエラーが発生しました! -- [_1]',
	'Stylesheet or Repository URL' => 'スタイルシートまたはリポジトリのURL',
	'Stylesheet or Repository URL:' => 'スタイルシートまたはリポジトリのURL:',
	'Download Styles' => 'スタイルをダウンロード',
	'Current theme for your weblog' => '適用されているテーマ',
	'Current Style' => '現在のスタイル',
	'Locally saved themes' => '保存されているテーマ',
	'Saved Styles' => '保存されているスタイル',
	'Default Styles' => '既定のスタイル',
	'Single themes from the web' => 'その他のテーマ',
	'More Styles' => 'その他のスタイル',
	'Selected Design' => '選択されたデザイン',
	'Layout' => 'レイアウト',
);

1;

