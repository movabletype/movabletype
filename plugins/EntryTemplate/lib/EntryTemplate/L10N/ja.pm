package EntryTemplate::L10N::ja;

use strict;
use warnings;

use base 'EntryTemplate::L10N::en_us';
use vars qw( %Lexicon );

%Lexicon = (
    'EntryTemplate'     => 'エントリーテンプレート',
    'EntryTemplates'    => 'エントリーテンプレート',
    'Entry Template'    => 'エントリーテンプレート',
    'Text'              => '内容',
    'My Entry Template' => '自分のエントリーテンプレート',

    'Edit EntryTemplate'   => 'エントリーテンプレートの編集',
    'Create EntryTemplate' => 'エントリーテンプレートの作成',
    'Create New EntryTemplate' =>
        '新しいエントリーテンプレートの作成',

    'Save changes to this entry template (s)' =>
        'エントリーテンプレートへの変更を保存 (s)',

    'Are you sure you want to delete the selected EntryTemplates?' =>
        'エントリーテンプレートを削除してもよろしいですか？',
);

1;
