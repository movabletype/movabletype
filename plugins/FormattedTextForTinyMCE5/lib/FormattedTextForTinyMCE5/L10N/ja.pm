# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedTextForTinyMCE5::L10N::ja;

use strict;
use warnings;

use base 'FormattedTextForTinyMCE5::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## mt-static/plugins/FormattedTextForTinyMCE5/extension.js
	'Insert Boilerplate' => '定型文の挿入',
	'Name' => '名前',

## plugins/FormattedTextForTinyMCE5/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'TinyMCE に「定型文の挿入」ボタンを追加します。',

## plugins/FormattedTextForTinyMCE5/lib/FormattedTextForTinyMCE5/App.pm
	'Cannot load boilerplate.' => '定型文をロードできませんでした。',

## plugins/FormattedTextForTinyMCE5/tmpl/extension.tmpl
	'Boilerplate' => '定型文',
	'Description' => '説明',
	'Preview' => 'プレビュー',
	'Select a Boilerplate' => '定型文を選択...',
);

1;
