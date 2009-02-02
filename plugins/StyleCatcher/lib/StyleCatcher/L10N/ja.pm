# Movable Type (r) Open Source (C) 2005-2008 Six Apart, Ltd.
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

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a Style' => 'スタイルを選択',
	'3-Columns, Wide, Thin, Thin' => '3カラム、大・小・小',
	'3-Columns, Thin, Wide, Thin' => '3カラム、小・大・小',
	'3-Columns, Thin, Thin, Wide' => '3カラム、小・小・大',
	'2-Columns, Thin, Wide' => '2カラム、小・大',
	'2-Columns, Wide, Thin' => '2カラム、大・小',
	'2-Columns, Wide, Medium' => '2カラム、大・中',
	'2-Columns, Medium, Wide' => '2カラム、中・大',
	'1-Column, Wide, Bottom' => '1カラム、大、下',
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

## plugins/StyleCatcher/config.yaml
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a> page.' => 'StyleCatcherを使うと、ほんの数回クリックするだけでスタイルを探してブログに適用することができます。Movable Typeのスタイルについての詳細やスタイルの配布元については、<a href=\'http://www.sixapart.com/movabletype/styles\'>Movable Type styles</a>のページ（英語）へアクセスしてください。',
	'MT 4 Style Library' => 'MT 4 スタイルライブラリ',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Movable Type 4のデフォルトテンプレートと互換性のあるスタイルです。',
	'Styles' => 'スタイル',

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'mt-staticディレクトリが見つかりませんでした。StaticFilePathを設定してください。',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => '[_1] フォルダが作成できません。\'themes\' フォルダが書き込み可能か確認してください。',
	'Successfully applied new theme selection.' => '新しいテーマを適用しました。',
	'Invalid URL: [_1]' => 'URLが不正です: [_1]',
);

1;

