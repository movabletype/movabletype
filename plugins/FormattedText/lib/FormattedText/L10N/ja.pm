package FormattedText::L10N::ja;

use strict;
use warnings;

use base 'FormattedText::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/FormattedText/config.yaml
	'Formatted Texts' => '定型文',
	'Formatted Text' => '定型文',
	'Text' => '内容',
	'My Formatted Text' => '自分の定型文',
	'Edit Formatted Text' => '定型文の編集',
	'Create Formatted Text' => '定型文の作成',
	'Manage formatted text.' => '定型文を管理します。',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected FormattedTexts?' => '定型文を削除してもよろしいですか？',
	'FormattedText' => '定型文',
	'My Formatted Text' => '自分の定型文',

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'FormattedTexts' => '定型文',
	'Are you sure you want to delete the selected Formatted Texts?' =>
        '定型文を削除してもよろしいですか？',
## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit FormattedText' => '定型文の編集',
	'Create FormattedText' => '定型文の作成',
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
