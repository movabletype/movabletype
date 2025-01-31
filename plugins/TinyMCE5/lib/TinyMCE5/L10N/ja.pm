# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package TinyMCE5::L10N::ja;

use strict;
use warnings;
use utf8;
use base 'TinyMCE5::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (

## mt-static/plugins/TinyMCE5/lib/js/tinymce/plugins/mt/langs/plugin.js
	'Block Quotation' => '引用ブロック',
	'Copy column' => '列のコピー',
	'Cut column' => '列の切り取り',
	'Emphasis' => '斜体',
	'Horizontal align' => '横配置',
	'Insert Asset Link' => 'アセットの挿入',
	'Insert HTML' => 'HTMLの挿入',
	'Insert Image Asset' => '画像の挿入',
	'Insert Link' => 'リンクの挿入',
	'List Item' => 'リスト要素',
	'Ordered List' => '番号付きリスト',
	'Paste column after' => '列の後に貼り付け',
	'Paste column before' => '列の前に貼り付け',
	'Strong Emphasis' => '太字',
	'Toggle Fullscreen Mode' => '全画面表示の切り替え',
	'Toggle HTML Edit Mode' => 'HTML編集モードの切り替え',
	'Unordered List' => '番号なしリスト',
	'Vertical align' => '縦配置',

## mt-static/plugins/TinyMCE5/lib/js/tinymce/plugins/mt/plugin.js
	'HTML' => 'HTML',

## mt-static/plugins/TinyMCE5/lib/js/tinymce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => '全画面表示',

## mt-static/plugins/TinyMCE5/tiny_mce/plugins/autosave/plugin.js
	'You have unsaved changes are you sure you want to navigate away?' => '保存していない変更があります。移動してもよろしいですか？',

## plugins/TinyMCE5/config.yaml
	'Default WYSIWYG editor.' => '既定のWYSIWYGエディタ',
	'TinyMCE' => 'TinyMCE',
);

1;
