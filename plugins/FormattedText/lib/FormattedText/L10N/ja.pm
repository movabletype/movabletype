package FormattedText::L10N::ja;

use strict;
use warnings;

use base 'FormattedText::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => '定型文の挿入',

## mt-static/plugins/FormattedTextForTinyMCE/langs/template.js
	'Boilerplate' => '定型文',
	'Select a Boilerplate' => '定型文を選択...',

## plugins/FormattedText/config.yaml
	'Manage boilerplate.' => '定型文を管理します。',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => '定型文を削除してもよろしいですか？',
	'My Boilerplate' => '自分の定型文',

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplates' => '定型文',
	'The boilerplate \'[_1]\' is already in use in this blog.' => '[_1]という定型文は既にこのブログに存在しています。',

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => '定型文の編集',
	'Create Boilerplate' => '定型文の作成',
	'This boilerplate has been saved.' => '定型文を保存しました。',
	'Save changes to this boilerplate (s)' => '定型文への変更を保存 (s)',

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => '定型文を削除しました',

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'TinyMCE に「定型文の挿入」ボタンを追加します。',

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => '定型文をロードできませんでした。',

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl

);

1;
