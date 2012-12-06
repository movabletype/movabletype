package FormattedTextForTinyMCE::L10N::ja;

use strict;
use warnings;

use base 'FormattedTextForTinyMCE::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'TinyMCE に「定型文の挿入」ボタンを追加します。',

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => '定型文をロードできませんでした。',

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => '定型文を選択...',

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => '定型文の挿入',

## mt-static/plugins/FormattedTextForTinyMCE/langs/template.js
	'Boilerplate' => '定型文',
	'Select Boilerplate' => '定型文を選択...',

);

1;
