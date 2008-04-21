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

## plugins/WidgetManager/tmpl/list.tmpl
	'Widget Set' => 'ウィジェットセット',
	'Widget Sets' => 'ウィジェットセット',
	'Delete selected Widget Sets (x)' => '選択されたウィジェットセットを削除 (x)',
	'Helpful Tips' => 'ヘルプ',
	'To add a widget set to your templates, use the following syntax:' => 'テンプレートにウィジェットセットを追加するときは以下の構文を利用します。',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;ウィジェットセットの名前&quot;$&gt;</strong>',
	'Your changes to the widget set have been saved.' => 'ウィジェットセットへの変更を保存しました。',
	'You have successfully deleted the selected widget set(s) from your blog.' => '選択されたウィジェットセットを削除しました。',
	'New Widget Set' => '新しいウィジェットセット',
	'Create Widget Set' => 'ウィジェットセットの作成',
	'No Widget Sets could be found.' => 'ウィジェットセットが見つかりませんでした。',
	'Installed Widgets' => 'インストール済み',
	'Create widget template' => 'ウィジェットテンプレートを作成', # Translate - New
	'Widget Templates' => 'ウィジェットテンプレート', # Translate - New

## plugins/WidgetManager/tmpl/edit.tmpl
	'Edit Widget Set' => 'ウィジェットセットの編集',
	'Please use a unique name for this widget set.' => 'ウィジェットセットの名前は一意でなければなりません。',
	'You already have a widget set named \'[_1].\' Please use a unique name for this widget set.' => '「[_1]」というウィジェットセットが既に存在します。別の名前に変えてください。',
	'Your changes to the Widget Set have been saved.' => 'ウィジェットセットへの変更を保存しました。',
	'Set Name' => 'セット名',
	'Drag and drop the widgets you want into the Installed column.' => 'ウィジェットを「インストール済み」ボックスにドラッグアンドドロップします。',
	'Available Widgets' => '利用可能',
	'Save changes to this widget set (s)' => 'ウィジェットセットへの変更を保存 (s)',

## plugins/WidgetManager/WidgetManager.pl
	'Maintain your blog\'s widget content using a handy drag and drop interface.' => 'ブログに表示>されるWidgetをドラッグアンドドロップで簡単に管理できるようにします。',

## plugins/WidgetManager/lib/WidgetManager/Plugin.pm
	'Can\'t find included template widget \'[_1]\'' => 'ウィジェット「[_1]」が見つかりません。',
	'Cloning Widgets for blog...' => 'ブログのウィジェットを複製しています...',
	'Restoring widgetmanager [_1]... ' => 'ウィジェットマネージャ [_1] を修復しています...', # Translate - New

## plugins/WidgetManager/lib/WidgetManager/CMS.pm
	'Can\'t duplicate the existing \'[_1]\' Widget Manager. Please go back and enter a unique name.' => 'すでに存在する\'[_1]\' Widget Managerは作成できません。',
	'Main Menu' => 'メインメニュー',
	'Widget Manager' => 'Widget Manager',

## plugins/WidgetManager/default_widgets/creative_commons.mtml
	'This weblog is licensed under a' => 'このブログのライセンスは',
	'Creative Commons License' => 'クリエイティブ・コモンズライセンス',

## plugins/WidgetManager/default_widgets/category_archive_list.mtml
	'[_1] ([_2])' => '[_1] ([_2])',

## plugins/WidgetManager/default_widgets/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '[_1] <a href="[_2]">アーカイブ</a>',

## plugins/WidgetManager/default_widgets/current_category_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1]: 月別アーカイブ',

## plugins/WidgetManager/default_widgets/syndication.mtml
	'Subscribe to this blog\'s feed' => 'このブログを購読',
	'Search results matching &ldquo;<$mt:SearchString$>&rdquo;' => '&ldquo;<$mt:SearchString$>&rdquo;の検索結果',

## plugins/WidgetManager/default_widgets/author_archive_list.mtml

## plugins/WidgetManager/default_widgets/about_this_page.mtml
	'About this Entry' => 'このブログ記事について',
	'About this Archive' => 'このアーカイブについて',
	'About Archives' => 'このページについて',
	'This page contains links to all the archived content.' => 'このページには過去に書かれたすべてのコンテンツが含まれています。',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'このページは、[_1]が[_2]に書いたブログ記事です。',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => 'ひとつ前のブログ記事は「<a href="[_1]">[_2]</a>」です。',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => '次のブログ記事は「<a href="[_1]">[_2]</a>」です。',
	'This page is a archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'このページには、<strong>[_2]</strong>以降に書かれたブログ記事のうち<strong>[_1]</strong>カテゴリに属しているものが含まれています。',
	'<a href="[_1]">[_2]</a> is the previous archive.' => '前のアーカイブは<a href="[_1]">[_2]</a>です。',
	'<a href="[_1]">[_2]</a> is the next archive.' => '次のアーカイブは<a href="[_1]">[_2]</a>です。',
	'This page is a archive of recent entries in the <strong>[_1]</strong> category.' => 'このページには、過去に書かれたブログ記事のうち<strong>[_1]</strong>カテゴリに属しているものが含まれています。',
	'<a href="[_1]">[_2]</a> is the previous category.' => '前のカテゴリは<a href="[_1]">[_2]</a>です。',
	'<a href="[_1]">[_2]</a> is the next category.' => '次のカテゴリは<a href="[_1]">[_2]</a>です。',
	'This page is a archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'このページには、<strong>[_1]</strong>が<strong>[_2]</strong>に書いたブログ記事が含まれています。',
	'This page is a archive of recent entries written by <strong>[_1]</strong>.' => 'このページには、<strong>[_1]</strong>が最近書いたブログ記事が含まれています。',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'このページには、<strong>[_2]</strong>に書かれたブログ記事が新しい順に公開されています。',
	'Find recent content on the <a href="[_1]">main index</a>.' => '最近のコンテンツは<a href="[_1]">インデックスページ</a>で見られます。',
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => '最近のコンテンツは<a href="[_1]">インデックスページ</a>で見られます。過去に書かれたものは<a href="[_2]">アーカイブのページ</a>で見られます。',

## plugins/WidgetManager/default_widgets/current_author_monthly_archive_list.mtml

## plugins/WidgetManager/default_widgets/tag_cloud.mtml

## plugins/WidgetManager/default_widgets/date_based_author_archives.mtml
	'Author Yearly Archives' => '年別ユーザーアーカイブ',
	'Author Weekly Archives' => '週別ユーザーアーカイブ',
	'Author Daily Archives' => '日別ユーザーアーカイブ',

## plugins/WidgetManager/default_widgets/calendar.mtml
	'Monthly calendar with links to daily posts' => 'リンク付きのカレンダー',
	'Sun' => '日',
	'Mon' => '月',
	'Tue' => '火',
	'Wed' => '水',
	'Thu' => '木',
	'Fri' => '金',
	'Sat' => '土',

## plugins/WidgetManager/default_widgets/technorati_search.mtml
	'Technorati' => 'Techonrati',
	'<a href=\'http://www.technorati.com/\'>Technorati</a> search' => '<a href=\'http://www.technorati.com/\'>Technorati</a> search',
	'this blog' => 'このブログ',
	'all blogs' => 'すべてのブログ',
	'Blogs that link here' => 'リンクしているブログ',

## plugins/WidgetManager/default_widgets/signin.mtml
	'You are signed in as ' => 'ユーザー名:',
	'sign out' => 'サインアウト',
	'You do not have permission to sign in to this blog.' => 'このブログにサインインする権限がありません。',

## plugins/WidgetManager/default_widgets/recent_entries.mtml
	'Recent Entries' => '最近のブログ記事',

## plugins/WidgetManager/default_widgets/monthly_archive_dropdown.mtml
	'Select a Month...' => '月を選択...',

## plugins/WidgetManager/default_widgets/pages_list.mtml

## plugins/WidgetManager/default_widgets/archive_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'アーカイブの種類に応じて異なる内容を表示するように設定されたウィジェットです。詳細: [_1]',
	'Current Category Monthly Archives' => 'カテゴリ月別アーカイブ',
	'Category Archives' => 'カテゴリアーカイブ',

## plugins/WidgetManager/default_widgets/date_based_category_archives.mtml
	'Category Yearly Archives' => '年別カテゴリアーカイブ',
	'Category Weekly Archives' => '週別カテゴリアーカイブ',
	'Category Daily Archives' => '日別カテゴリアーカイブ',

## plugins/WidgetManager/default_widgets/recent_assets.mtml
	'Recent Assets' => 'アイテム',

## plugins/WidgetManager/default_widgets/widgets.cfg
	'About This Page' => 'About',
	'Archive Widgets Group' => 'アーカイブウィジェットグループ', # Translate - New
	'Current Author Monthly Archives' => 'ユーザー月別アーカイブ',
	'Calendar' => 'カレンダー',
	'Creative Commons' => 'クリエイティブ・コモンズ',
	'Home Page Widgets Group' => 'ホームページウィジェットグループ', # Translate - New
	'Monthly Archives Dropdown' => '月別アーカイブ(ドロップダウン)',
	'Page Listing' => 'ページ一覧',
	'Powered By' => 'Powered By',
	'Recent Comments' => '最近のコメント',
	'Syndication' => '購読',
	'Technorati Search' => 'Technorati Search',
	'Date-Based Author Archives' => '日付ベースのユーザーアーカイブ',
	'Date-Based Category Archives' => '日付ベースのカテゴリアーカイブ',

## plugins/WidgetManager/default_widgets/main_index_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'main_indexのテンプレートだけに表示されるように設定されているウィジェットのセットです。詳細: [_1]',

## plugins/WidgetManager/default_widgets/search.mtml
	'Case sensitive' => '大文字/小文字を区別する',

## plugins/WidgetManager/default_widgets/powered_by.mtml

## plugins/WidgetManager/default_widgets/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] から [_3] に対するコメント</a>: [_4]',
);

1;

