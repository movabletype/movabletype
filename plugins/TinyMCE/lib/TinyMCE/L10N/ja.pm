# Movable Type (r) (C) 2005-2018 Six Apart, Ltd. All Rights Reserved.
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

## mt-static/plugins/TinyMCE/tiny_mce/plugins/autosave/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/compat3x/utils/editable_selects.js
	'value' => 'value',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/insertdatetime/plugin.js
	'%Y-%m-%d' => '%Y-%m-%d',
	'%H:%M:%S' => '%H:%M:%S',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/insertdatetime/plugin.min.js

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Class Name' => 'クラス名',
	'Bold (Ctrl+B)' => '太字  (Ctrl+B)',
	'Italic (Ctrl+I)' => '斜体 (Ctrl+I)',
	'Underline (Ctrl+U)' => '下線 (Ctrl+U)',
	'Strikethrough' => '取り消し線',
	'Block Quotation' => '引用ブロック',
	'Unordered List' => '番号なしリスト',
	'Ordered List' => '番号付きリスト',
	'Horizontal Line' => '水平線を挿入',
	'Insert/Edit Link' => 'リンクの挿入/編集',
	'Unlink' => 'リンクを解除',
	'Undo (Ctrl+Z)' => '元に戻す (Ctrl+Z)',
	'Redo (Ctrl+Y)' => 'やり直す (Ctrl+Y)',
	'Select Text Color' => 'テキスト色',
	'Select Background Color' => '背景色',
	'Remove Formatting' => '書式の削除',
	'Align Left' => '左揃え',
	'Align Center' => '中央揃え',
	'Align Right' => '右揃え',
	'Indent' => '字下げを増やす',
	'Outdent' => '字下げを減らす',
	'Insert Link' => 'リンクの挿入',
	'Insert HTML' => 'HTMLの挿入',
	'Insert Image Asset' => '画像の挿入',
	'Insert Asset Link' => 'アセットの挿入',
	'Toggle Fullscreen Mode' => '全画面表示の切り替え',
	'Toggle HTML Edit Mode' => 'HTML編集モードの切り替え',
	'Strong Emphasis' => '太字',
	'Emphasis' => '斜体',
	'List Item' => 'リスト要素',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/plugin.js
	'HTML' => 'HTML',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => '全画面表示',

## plugins/TinyMCE/config.yaml
	'Default WYSIWYG editor.' => '既定のWYSIWYGエディタ',
	'TinyMCE' => 'TinyMCE',

);

1;
