# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package TinyMCE::L10N::ja;

use strict;
use warnings;
use utf8;
use base 'TinyMCE::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (

## mt-static/plugins/TinyMCE/tiny_mce/plugins/autosave/plugin.js
	'You have unsaved changes are you sure you want to navigate away?' => '保存していない変更があります。移動してもよろしいですか？',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/compat3x/utils/editable_selects.js
	'value' => 'value',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Align Center' => '中央揃え',
	'Align Left' => '左揃え',
	'Align Right' => '右揃え',
	'Block Quotation' => '引用ブロック',
	'Bold (Ctrl+B)' => '太字  (Ctrl+B)',
	'Class Name' => 'クラス名',
	'Emphasis' => '斜体',
	'Horizontal Line' => '水平線を挿入',
	'Indent' => '字下げを増やす',
	'Insert Asset Link' => 'アセットの挿入',
	'Insert HTML' => 'HTMLの挿入',
	'Insert Image Asset' => '画像の挿入',
	'Insert Link' => 'リンクの挿入',
	'Insert/Edit Link' => 'リンクの挿入/編集',
	'Italic (Ctrl+I)' => '斜体 (Ctrl+I)',
	'List Item' => 'リスト要素',
	'Ordered List' => '番号付きリスト',
	'Outdent' => '字下げを減らす',
	'Redo (Ctrl+Y)' => 'やり直す (Ctrl+Y)',
	'Remove Formatting' => '書式の削除',
	'Select Background Color' => '背景色',
	'Select Text Color' => 'テキスト色',
	'Strikethrough' => '取り消し線',
	'Strong Emphasis' => '太字',
	'Toggle Fullscreen Mode' => '全画面表示の切り替え',
	'Toggle HTML Edit Mode' => 'HTML編集モードの切り替え',
	'Underline (Ctrl+U)' => '下線 (Ctrl+U)',
	'Undo (Ctrl+Z)' => '元に戻す (Ctrl+Z)',
	'Unlink' => 'リンクを解除',
	'Unordered List' => '番号なしリスト',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/plugin.js
	'HTML' => 'HTML',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => '全画面表示',

## plugins/TinyMCE/config.yaml
	'Default WYSIWYG editor.' => '既定のWYSIWYGエディタ',
	'TinyMCE' => 'TinyMCE',
);

1;
