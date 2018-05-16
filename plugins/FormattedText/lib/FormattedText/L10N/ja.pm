# Movable Type (r) (C) 2006-2018 Six Apart, Ltd. All Rights Reserved.
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
	'Manage boilerplate.' => '定型文を管理します。',
	'Boilerplate' => '定型文',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Boilerplates' => '定型文',
	'Create Boilerplate' => '定型文の作成',
	'Are you sure you want to delete the selected boilerplates?' => '定型文を削除してもよろしいですか？',
	'My Boilerplate' => '自分の定型文',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	'The boilerplate \'[_1]\' is already in use in this site.' => '定型文 \'[_1]\'はすでに存在します。',

## plugins/FormattedText/lib/FormattedText/DataAPI/Endpoint/v2/FormattedText.pm

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'The boilerplate \'[_1]\' is already in use in this blog.' => '[_1]という定型文は既にこのブログに存在しています。',

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => '定型文の編集',
	'This boilerplate has been saved.' => '定型文を保存しました。',
	'Save changes to this boilerplate (s)' => '定型文への変更を保存 (s)',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{[_1]という定型文は既にこのブログに存在しています。},

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => '定型文を削除しました',

);

1;
