# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package FormattedText::L10N::ja;

use strict;
use warnings;

use base 'FormattedText::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (

## plugins/FormattedText/config.yaml
	'Boilerplate' => '定型文',
	'Manage boilerplate.' => '定型文を管理します。',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => '定型文を削除してもよろしいですか？',
	'Boilerplates' => '定型文',
	'Create Boilerplate' => '定型文の作成',
	'Create New' => '新規作成',
	'Delete' => '削除',
	'Entry' => '記事',
	'My Boilerplate' => '自分の定型文',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	'A parameter "[_1]" is required.' => '"[_1]" パラメータは必須です。',
	q{The boilerplate '[_1]' is already in use in this site.} => q{定型文 '[_1]'はすでに存在します。},

## plugins/FormattedText/lib/FormattedText/DataAPI/Endpoint/v2/FormattedText.pm
	'Removing [_1] failed: [_2]' => '[_1]を削除できませんでした: [_2]',
	'Site not found' => 'ウェブサイトが見つかりません',

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'(system)' => 'システム',
	'*Site/Child Site deleted*' => '*削除されました*',
	'Description' => '説明',
	'Name' => '名前',
	'Site Name' => 'サイト名',
	'Text' => '本文',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{[_1]という定型文は既にこのブログに存在しています。},

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => '定型文の編集',
	'Label' => '名前',
	'Save Changes' => '変更を保存',
	'Save changes to this boilerplate (s)' => '定型文への変更を保存 (s)',
	'This boilerplate has been saved.' => '定型文を保存しました。',
	'Your changes have been saved.' => '変更を保存しました。',

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => '定型文を削除しました',
);

1;
