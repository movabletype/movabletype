package EntryTemplate::L10N::ja;

use strict;
use warnings;

use base 'EntryTemplate::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
    'EntryTemplate'     => '記事テンプレート',
    'EntryTemplates'    => '記事テンプレート',
    'Entry Template'    => '記事テンプレート',
    'Text'              => '内容',
    'My Entry Template' => '自分の記事テンプレート',

    'Edit EntryTemplate'   => '記事テンプレートの編集',
    'Create EntryTemplate' => '記事テンプレートの作成',
    'Create New EntryTemplate' =>
        '新しい記事テンプレートの作成',

    'Save changes to this entry template (s)' =>
        '記事テンプレートへの変更を保存 (s)',

    'Are you sure you want to delete the selected EntryTemplates?' =>
        '記事テンプレートを削除してもよろしいですか？',
);

1;
