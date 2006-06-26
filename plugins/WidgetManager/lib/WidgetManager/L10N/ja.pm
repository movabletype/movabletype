# WidgetManager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
package WidgetManager::L10N::ja;

use strict;
use base 'WidgetManager::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
    "Maintain your weblog's widget content using a handy drag and drop interface." => 'ブログに表示されるWidgetをドラッグアンドドロップで簡単に管理できるようにします。',
    'Widget Manager' => 'Widget Manager',
    'Rearrange Items' => 'アイテムの再設定',
    'To add a Widget Manager to your templates, use the following syntax:' => 'WidgetManagerをテンプレートに追加するときは次の構文で指定します。',
    'Widget Managers' => 'Widget Manager',
    'Add Widget Manager' => 'Widget Managerを追加',
    'Create Widget Manager' => 'Widget Managerを作成',
    'Your changes to the Widget Manager have been saved.' => 'Widget Managerへの変更を保存しました。',
    'You have successfully deleted the selected Widget Manager(s) from your weblog.' => 'ブログから指定されたWidget Managerを削除しました。',
    'WidgetManager Name' => 'Widget Managerの名前',
    'Widget Manager Name:' => 'Widget Managerの名前:',
    'Installed Widgets' => 'インストールされているWidget',
    'Delete Selected' => '選択したものを削除',
    'Are you sure you wish to delete the selected Widget Manager(s)?' => '選択されたWidget Managerを削除しますか？',
    'Build WidgetManager:' => 'WidgetManagerの構築: ',
    'Drag and drop the widgets you want into the <strong>Installed</strong> column.' => '表示するWidgetを「インストールされているWidget」にドラッグアンドドロップしてください。',
    'Available Widgets' => '利用可能なWidget',
    'Moving [_1] to list of installed modules' => '[_1]をインストールされているWidgetに移動しています',
    'First Widget Manager' => 'First Widget Manager',
    "Monthly calendar with links to each day's posts" => '投稿へのリンクつきカレンダー',
    'Manage my Widgets' => 'Widgetの管理',
    'Sunday' => '日曜日',
    'Sun' => '日',
    'Monday' => '月曜日',
    'Mon' => '月',
    'Tuesday' => '火曜日',
    'Tue' => '火',
    'Wednesday' => '水曜日',
    'Wed' => '水',
    'Thursday' => '木曜日',
    'Thu' => '木',
    'Friday' => '金曜日',
    'Fri' => '金',
    'Saturday' => '土曜日',
    'Sat' => '土',

    "<a href='http://www.technorati.com/'>Technorati</a> search" => "<a href='http://www.technorati.com/'>Technorati</a> search",
    'this blog' => 'このブログ',
    'all blogs' => 'すべてのブログ',
    'Blogs that link here' => 'ここにリンクしているブログ',
    'Technorati Search' => 'Technorati Search', 
    'Calendar' => 'カレンダー',
    'Category list (nested)' => 'カテゴリーリスト', 
    'Creative Commons' => 'クリエイティブ・コモンズ', 
    'Monthly archive list' => '月別アーカイブリスト', 
    'Monthly archive dropdown' => '月別ドロップダウン',
    'Recent posts' => '最近の投稿',
    'Recent comments' => '最近のコメント',
    'Search form' => '検索フォーム', 
    '<strong><$MTWidgetManager name="Name of the Widget Manager"$></strong>' => '<strong><$MTWidgetManager name="Widget Managerの名前"$></strong>',
    'Select a Month...' => '月を選択',
);

1;

