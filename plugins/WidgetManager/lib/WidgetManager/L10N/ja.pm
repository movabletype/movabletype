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

## plugins/WidgetManager/lib/WidgetManager/Plugin.pm
	'Can\'t find included template widget \'[_1]\'' => 'ウィジェット「[_1]」が見つかりません。',
	'Cloning Widgets for blog...' => 'ブログのウィジェットを複製しています...',

## plugins/WidgetManager/lib/WidgetManager/CMS.pm
	'Can\'t duplicate the existing \'[_1]\' Widget Manager. Please go back and enter a unique name.' => 'すでに存在する\'[_1]\' Widget Managerは作成できません。',
	'Main Menu' => 'メインメニュー',
	'Widget Manager' => 'Widget Manager',
	'New Widget Set' => '新しいウィジェットセット',
	'First Widget Manager' => 'First Widget Manager',

## plugins/WidgetManager/default_widgets/search.tmpl
	'Search this blog:' => 'ブログを検索',

## plugins/WidgetManager/default_widgets/category_archive_list.tmpl

## plugins/WidgetManager/default_widgets/subscribe_to_feed.tmpl

## plugins/WidgetManager/default_widgets/tag_cloud_module.tmpl

## plugins/WidgetManager/default_widgets/recent_posts.tmpl
	'Recent Posts' => '最近のブログ記事',

## plugins/WidgetManager/default_widgets/monthly_archive_dropdown.tmpl
	'Select a Month...' => '月を選択...',

## plugins/WidgetManager/default_widgets/recent_comments.tmpl

## plugins/WidgetManager/default_widgets/calendar.tmpl
	'Monthly calendar with links to each day\'s posts' => 'ブログ記事へのリンクつきカレンダー',
	'Sun' => '日',
	'Mon' => '月',
	'Tue' => '火',
	'Wed' => '水',
	'Thu' => '木',
	'Fri' => '金',
	'Sat' => '土',

## plugins/WidgetManager/default_widgets/monthly_archive_list.tmpl

## plugins/WidgetManager/default_widgets/technorati_search.tmpl
	'Technorati' => 'Techonrati',
	'<a href=\'http://www.technorati.com/\'>Technorati</a> search' => '<a href=\'http://www.technorati.com/\'>Technorati</a> search',
	'this blog' => 'このブログ',
	'all blogs' => 'すべてのブログ',
	'Blogs that link here' => 'リンクしているブログ',

## plugins/WidgetManager/default_widgets/signin.tmpl
	'You are signed in as ' => 'ユーザー名:',
	'You do not have permission to sign in to this blog.' => 'このブログにサインインする権限がありません。',

## plugins/WidgetManager/default_widgets/widgets.cfg
	'Technorati Search' => 'Technorati Search',
	'Calendar' => 'カレンダー',
	'Category list (nested)' => 'カテゴリ一覧(ネスト)',
	'Date-based Category Archives' => '日付ベースカテゴリアーカイブ',
	'Date-based Author Archives' => '日付ベースユーザーアーカイブ',
	'Creative Commons' => 'クリエイティブ・コモンズ',
	'Monthly archive list' => '月別アーカイブリスト',
	'Powered by' => 'Powered by',
	'Recent posts' => '最近のブログ記事',
	'Search form' => '検索フォーム',
	'Recent comments' => '最近のコメント',
	'Tag cloud (sidebar)' => 'タグクラウド(サイドバー)',
	'Monthly archive dropdown' => '月別アーカイブドロップダウン',
	'Pages list (nested)' => 'ウェブページ一覧(ネスト)',
	'Photos' => 'フォト',

## plugins/WidgetManager/default_widgets/powered_by.tmpl

## plugins/WidgetManager/default_widgets/creative_commons.tmpl
	'This weblog is licensed under a' => 'このブログのライセンスは',
	'Creative Commons License' => 'クリエイティブ・コモンズライセンス',

## plugins/WidgetManager/tmpl/edit.tmpl
	'Edit Widget Set' => 'ウィジェットセットの編集',
	'Please use a unique name for this widget set.' => 'ウィジェットセットの名前は一意でなければなりません。',
	'You already have a widget set named \'[_1].\' Please use a unique name for this widget set.' => '「[_1]」というウィジェットセットが既に存在します。別の名前に変えてください。',
	'Your changes to the Widget Set have been saved.' => 'ウィジェットセットへの変更を保存しました。',
	'Set Name' => 'セット名',
	'Drag and drop the widgets you want into the Installed column.' => 'ウィジェットを「インストール済み」ボックスにドラッグアンドドロップします。',
	'Installed Widgets' => 'インストール済み',
	'edit' => '編集',
	'Available Widgets' => '利用可能',

## plugins/WidgetManager/tmpl/list.tmpl
	'Widget Sets' => 'ウィジェットセット',
	'Widget Set' => 'ウィジェットセット',
	'Delete selected Widget Sets (x)' => '選択されたウィジェットセットを削除 (x)',
	'Helpful Tips' => 'ヘルプ',
	'To add a widget set to your templates, use the following syntax:' => 'テンプレートにウィジェットセットを追加するときは以下の構文を利用します。',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;ウィジェットセットの名前&quot;$&gt;</strong>',
	'Edit Widget Templates' => 'ウィジェットテンプレートを編集',
	'Your changes to the widget set have been saved.' => 'ウィジェットセットへの変更を保存しました。',
	'You have successfully deleted the selected widget set(s) from your blog.' => '選択されたウィジェットセットを削除しました。',
	'Create Widget Set' => 'ウィジェットセットの作成',
	'No Widget Sets could be found.' => 'ウィジェットセットが見つかりませんでした。',

## plugins/WidgetManager/WidgetManager.pl
	'Maintain your blog\'s widget content using a handy drag and drop interface.' => 'ブログに表示>されるWidgetをドラッグアンドドロップで簡単に管理できるようにします。',
	'Widgets' => 'ウィジェット',
);

1;

