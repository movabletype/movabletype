# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedTextForTinyMCE6::L10N::ja;

use strict;
use warnings;

use base 'FormattedTextForTinyMCE6::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'TinyMCE に「定型文の挿入」ボタンを追加します。',

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => '定型文をロードできませんでした。',

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Boilerplate' => '定型文',
	'Select a Boilerplate' => '定型文を選択...',

);

1;
