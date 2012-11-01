package FormattedText::L10N::ja;

use strict;
use warnings;

use base 'FormattedText::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Formatted Text' => '定型文の挿入',

## mt-static/plugins/FormattedTextForTinyMCE/langs/template.js
	'Formatted Text' => '定型文',
	'Select a Formatted Text' => '定型文を選択...',

## plugins/FormattedText/config.yaml
	'Manage formatted text.' => '定型文を管理します。',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected Formatted Texts?' => '定型文を削除してもよろしいですか？',
	'My Formatted Text' => '自分の定型文',

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Formatted Texts' => '定型文',
	'The formatted text \'[_1]\' is already in use in this blog.' => '[_1]という定型文は既にこのブログに存在しています。',

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Formatted Text' => '定型文の編集',
	'Create Formatted Text' => '定型文の作成',
	'This formatted text has been saved.' => '定型文を保存しました。',
	'Save changes to this formatted text (s)' => '定型文への変更を保存 (s)',

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The formatted text has been deleted from the database.' => '定型文を削除しました',

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Formatted Text" button to the TinyMCE.' => 'TinyMCE に「定型文の挿入」ボタンを追加します。',

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load formatted text.' => '記事テンプレートをロードできませんでした。',

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl

);

1;
