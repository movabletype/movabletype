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
	'Delete' => '削除',
	'Edit [_1] block' => '[_1]ブロックの編集',
	'Edit' => '編集',

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field_manager.js
	'Move' => '移動',

## mt-static/plugins/BlockEditor/lib/js/fields/embed.js
	'Embed Code' => '埋め込みコード',
	'Please enter the embed code here.' => '埋め込みコードを入力してください',

## mt-static/plugins/BlockEditor/lib/js/fields/header.js
	'Heading Level' => '見出し',
	'Heading' => '見出し',
	'Please enter the Header Text here.' => '見出しを入力してください。',

## mt-static/plugins/BlockEditor/lib/js/fields/horizon.js
	'Horizontal Rule' => '水平線',

## mt-static/plugins/BlockEditor/lib/js/fields/image.js
	'Loading...' => 'ロード中...',
	'image' => '画像',

## mt-static/plugins/BlockEditor/lib/js/fields/text.js
	'__TEXT_BLOCK__' => 'テキスト',

## mt-static/plugins/BlockEditor/lib/js/jquery.blockeditor.js
	'Add' => '追加',
	'Next' => '次',
	'Select a block' => 'ブロックを選択',

## mt-static/plugins/BlockEditor/lib/js/modal_window.js
	'Cancel' => 'キャンセル',

## plugins/BlockEditor/config.yaml
	'Block Editor' => 'ブロックエディタ',
	'Block Editor.' => 'ブロックエディタ',

## plugins/BlockEditor/lib/BlockEditor/App.pm
	'(no reason given)' => '(原因は不明)',
	'Invalid request.' => '不正な要求です。',
	'Load failed: [_1]' => 'ロードできませんでした: [_1]',

## plugins/BlockEditor/lib/BlockEditor/BlockEditorFieldType/Image.pm
	'Cannot load asset #[_1]' => 'アセット(ID:[_1])をロードできませんでした',
	'Cannot load blog #[_1].' => 'ブログ(ID:[_1])をロードできません。',
	'Cannot load image #[_1]' => 'ID:[_1]の画像をロードできませんでした。',
	'Files' => 'ファイル',
	'No permissions' => '権限がありません。',

## plugins/BlockEditor/tmpl/cms/dialog/asset_modal.tmpl
	'Back' => '戻る',
	'Previous' => '前',
	'Reset' => 'リセット',
	'Search' => '検索',
	'Upload new image' => '新しい画像をアップロード',
	'[_1] - [_2] of [_3]' => '[_1] - [_2] / [_3]',

## plugins/BlockEditor/tmpl/cms/dialog/include/asset_upload_panel.tmpl
	'Cancel upload' => 'アップロードしない',
	'Cancelled: [_1]' => 'キャンセルされました: [_1]',
	'Choose file to upload or drag file.' => 'アップロードするファイルを選択または画面にドラッグ＆ドロップしてください。',
	'Choose file to upload.' => 'アップロードするファイルを選択してください。',
	'Choose files to upload or drag files.' => 'アップロードするファイルを選択または画面にドラッグ＆ドロップしてください。（複数可）',
	'Choose files to upload.' => 'アップロードするファイルを選択してください。',
	'Drag and drop here' => 'ファイルをドロップしてください',
	'Enable orientation normalization' => '画像の向きを自動的に修正する',
	'Normalize orientation' => '画像向きの修正',
	'Operation for a file exists' => '既存ファイルの処理',
	'Overwrite existing file' => '既存のファイルを上書きする',
	'Rename filename' => 'ファイル名の変更',
	'Rename non-ascii filename automatically' => '日本語ファイル名を自動で変換する',
	'The file you tried to upload is too large: [_1]' => 'アップロードしようとしたファイルは大きすぎます: [_1]',
	'Upload Destination' => 'アップロード先',
	'Upload Options' => 'アップロードオプション',
	'Upload Settings' => 'アップロードの設定',
	'Upload and rename' => '既存のファイルを残して、別のファイル名でアップロードする',
	'You have successfully deleted the asset(s).' => 'アセットを削除しました。',
	'You must set a valid path.' => '有効なパス名を指定してください。',
	'[_1] is not a valid [_2] file.' => '[_1] は、正しい[_2]ファイルではありません。',
	'_USAGE_UPLOAD' => 'アップロード先には、サブディレクトリを指定することが出来ます。指定されたディレクトリが存在しない場合は、作成されます。',

## plugins/BlockEditor/tmpl/cms/dialog/multi_asset_options.tmpl
	'This field must be a positive integer.' => 'このフィールドは0以上の整数を指定してください。',

## plugins/BlockEditor/tmpl/cms/field_html/field_html_multi_line_text.tmpl
	'Changing to block editor is not possible to result return to your current document.' => 'ブロックエディタに変換すると、現在のHTML構造に戻れない可能性があります。',
	'Changing to plain text is not possible to return to the block edit.' => '他の入力フォーマットへ変換すると、ブロック構造が失われます。',
	'Converting to rich text may result in changes to your current document.' => 'リッチテキストに変換すると、現在のHTML構造に変更が生じる可能性があります。',
	'Format:' => 'フォーマット:',
	'No block in this field.' => 'ブロックがありません。',
	'Preview' => 'プレビュー',
	'Required' => '必須',
	'Sort' => '並び替え',
	'This field is required' => 'このフィールドは必須です。',

## plugins/BlockEditor/tmpl/cms/include/insert_options.tmpl
	'Align Center' => '中央揃え',
	'Align Left' => '左揃え',
	'Align Right' => '右揃え',
	'Alt' => '代替テキスト',
	'Caption' => 'キャプション',
	'None' => 'なし',
	'Title' => 'タイトル',
	'Use thumbnail' => 'サムネイルを利用',
	'width:' => '幅:',
);

1;
