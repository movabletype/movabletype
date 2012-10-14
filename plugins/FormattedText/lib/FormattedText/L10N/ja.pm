package FormattedText::L10N::ja;

use strict;
use warnings;

use base 'FormattedText::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
    'Manage formatted text.' => '定型文を管理します。',

    'FormattedText'     => '定型文',
    'FormattedTexts'    => '定型文',
    'Formatted Text'    => '定型文',
    'Text'              => '内容',
    'My Formatted Text' => '自分の定型文',

    'Edit FormattedText'       => '定型文の編集',
    'Create FormattedText'     => '定型文の作成',
    'Create New FormattedText' => '新しい定型文の作成',

    'Save changes to this formatted text (s)' =>
        '定型文への変更を保存 (s)',

    'Are you sure you want to delete the selected FormattedTexts?' =>
        '定型文を削除してもよろしいですか？',

    'The formatted text has been deleted from the database.' =>
        '定型文を削除しました',

    'This formatted text has been saved.' =>
        '定型文を保存しました。',
);

1;
