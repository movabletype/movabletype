# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package BlockEditor::L10N::ja;

use strict;
use warnings;

use base 'BlockEditor::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field.js
	'Edit [_1] block' => '[_1]ブロックの編集',

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field_manager.js

## mt-static/plugins/BlockEditor/lib/js/fields/embed.js
	'Embed Code' => '埋め込みコード',
	'Please enter the embed code here.' => '埋め込みコードを入力してください',

## mt-static/plugins/BlockEditor/lib/js/fields/header.js
	'Heading' => '見出し',
	'Heading Level' => '見出し',
	'Please enter the Header Text here.' => '見出しを入力してください。',

## mt-static/plugins/BlockEditor/lib/js/fields/horizon.js
	'Horizontal Rule' => '水平線',

## mt-static/plugins/BlockEditor/lib/js/fields/image.js

## mt-static/plugins/BlockEditor/lib/js/fields/text.js
	'__TEXT_BLOCK__' => 'テキスト',

## mt-static/plugins/BlockEditor/lib/js/jquery.blockeditor.js
	'Select a block' => 'ブロックを選択',

## mt-static/plugins/BlockEditor/lib/js/modal_window.js

## plugins/BlockEditor/config.yaml
	'Block Editor.' => 'ブロックエディタ',
	'Block Editor' => 'ブロックエディタ',

## plugins/BlockEditor/lib/BlockEditor/App.pm

## plugins/BlockEditor/lib/BlockEditor/BlockEditorFieldType/Image.pm

## plugins/BlockEditor/tmpl/cms/dialog/asset_modal.tmpl
	'Upload new image' => '新しい画像をアップロード',

## plugins/BlockEditor/tmpl/cms/dialog/include/asset_upload_panel.tmpl

## plugins/BlockEditor/tmpl/cms/dialog/multi_asset_options.tmpl

## plugins/BlockEditor/tmpl/cms/field_html/field_html_multi_line_text.tmpl
	'Sort' => '並び替え',
	'No block in this field.' => 'ブロックがありません。',
	'Changing to plain text is not possible to return to the block edit.' => '他の入力フォーマットへ変換すると、ブロック構造が失われます。',
	'Changing to block editor is not possible to result return to your current document.' => 'ブロックエディタに変換すると、現在のHTML構造に戻れない可能性があります。',

## plugins/BlockEditor/tmpl/cms/include/async_asset_list.tmpl

## plugins/BlockEditor/tmpl/cms/include/insert_options.tmpl
	'Alt' => '代替テキスト',
	'Caption' => 'キャプション',

);

1;
