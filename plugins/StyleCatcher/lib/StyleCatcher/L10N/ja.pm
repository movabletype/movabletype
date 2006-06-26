package StyleCatcher::L10N::ja;

use strict;
use base 'StyleCatcher::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
    'Applying...' => '適用中...',
    'Apply Selected Design' => 'デザインを適用',
    'Before using StyleCatcher, you must specify the Theme Root URL and Path for the installation in the system-level plugin settings for StyleCatcher.' => 'StyleCatcherを利用するには、システムメニューのStyleCatcherプラグインの設定で、ルートURLとルートパスを指定する必要があります。',
    'Choose this Design' => 'このデザインを選択',
    'click here.' => 'ここをクリックしてください。',
    'Configure plugin' => 'プラグインの構成',
    "Could not create [_1] folder - Check that your 'themes' folder is webserver-writable." => '[_1] ディレクトリを作成できませんでした。Webサーバーからテーマのディレクトリに書き込みができるかどうか確認してください。',
    'Current Theme' => '現在のテーマ',
    'Current theme for your weblog' => 'ブログの現在のテーマ',
    'Current Themes' => '現在のテーマ',
    'Current themes for your weblogs' => 'ブログの現在のテーマ',
    'Error loading themes! -- [_1]' => 'テーマをロードできませんでした: [_1]',
    'Find Style' => 'スタイル検索',
    'Find Styles' => 'スタイル検索',
    'Hide Details' => '詳細を隠す',
    "Install <a href='http://greasemonkey.mozdev.org/'>GreaseMonkey</a>" => "<a href='http://greasemonkey.mozdev.org/'>GreaseMonkey</a>で",
    "StyleCatcher user script." => "StyleCatcherのユーザースクリプトを利用する",
    "It will take a moment for themes to populate once you click 'Find Style'." => 'スタイル検索をクリックすると、テーマを取り込みます（少し時間がかかります）。',
    'Loading...' => 'ロード中...',
    'Locally saved themes' => 'ローカルに保存されたテーマ',
    'More Themes' => 'その他のテーマ',
    'Movable Type styles' => 'Movable Type スタイル',
    'NOTE:' => '注:',
    ' page.' => 'ページ',
    'Please click on a theme before attempting to apply a new design to your blog.' => 'ブログに適用するテーマをクリックして選択してください。',
    'Please select a weblog to apply this theme.' => 'テーマを適用するブログを選択してください。',
    'Saved Themes' => '保存済みテーマ',
    'Select a Design using StyleCatcher' => 'StyleCatcherでデザインを選ぶ',
    'Select a Weblog...' => 'ブログを選択',
    'Show Details' => '詳細表示',
    'Single themes from the web' => 'その他のテーマ',
    "StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks. To find out more about Movable Type styles, or for new sources for styles, visit the <a href='http://www.sixapart.com/movabletype/styles'>Movable Type styles</a> page." => "StyleCatcherを使うと、ほんの数回クリックするだけでスタイルを探してブログに適用することができます。Movable Typeのスタイルについての詳細やスタイルの配布元については、<a href='http://www.sixapart.com/movabletype/styles'>Movable Type styles</a>のページ（英語）へアクセスしてください。",
    'StyleCatcher must first be configured system-wide before it can be used.' => 'StyleCatcherを利用するには、まずシステムレベルで設定を行う必要があります。',
    'Style Library URL:' => 'Style LibraryへのURL:',
    'Successfully applied new theme selection.' => '新しいテーマを適用しました。',
    'Theme or Repository URL:' => 'テーマ/リポジトリへのURL:',
    'Theme Root Path:' => 'テーマのルートパス:',
    'Theme Root URL:' => 'テーマのルートURL:',
    'The paths defined here must physically exist and be writable by the webserver.' => 'このパスは物理的に存在しかつWebサーバーから書き込み可能でなければなりません。',
    ' To change the location of your local theme repository, ' => ' テーマリポジトリの場所を変えるには ',
    'Unable to create the theme root directory. Error: [_1]' => 'テーマのルートディレクトリを作成できませんでした: [_1]',
    'Unable to write base-weblog.css to themeroot. File Manager gave the error: [_1]. Are you sure your theme root directory is web-server writable?' => 'base-weblog.cssをテーマのルートに書き込めませんでした: [_1]。Webサーバーからテーマのルートディレクトリに書き込みができるかどうか確認してください。',
    q{You don't appear to have any weblogs with a 'styles-site.css' template that you have rights to edit. Please check your weblog(s) for this template.} => 'styles-site.cssテンプレートを利用しているブログがありません。このテンプレートをブログで確認してください。',
    q{You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it's own theme paths, it will use these settings. If a blog has it's own theme paths, then the theme will be copied to that location when applied to that weblog.} => 'テーマを保存するためのグローバルテーマディレクトリを指定してください。ブログごとの設定で上書きしない限り、ここでの設定が利用されます。ブログの設定で上書きした場合、テーマはブログに適用されたときにその場所へコピーされます。',
    q{Your theme URL and path can be customized for this weblog.} => 'このブログ用にテーマのURLとパスをカスタマイズできます。', 
    "<p>You must define a global theme repository where themes can be stored locally.  If a particular blog has not been configured for it's own theme paths, it will use these settings directly. If a blog has it's own theme paths, then the theme will be copied to that location when applied to that weblog. The paths defined here must physically exist and be writable by the webserver.</p>" => '<p>テーマを保存するためのグローバルテーマディレクトリを指定してください。ブログごとの設定で上書きしない限り、ここでの設定が利用されます。ブログの設定で上書きした場合、テーマはブログに適用されたときにその場所へコピーされます。このパスは物理的に存在しかつWebサーバーから書き込み可能でなければなりません。</p>',
    '<p style="color: #f00;"><strong>NOTE:</strong> StyleCatcher must first be configured from the system-level plugins listing before it can be used on any blog.</p>' => '<p style="color: #f00;"><strong>注意：</strong>StyleCatcherを利用するには、まずシステムレベルで設定を行う必要があります。',
    "<p>If you wish to store your themes locally for this blog, you can configure your theme URL and path below.  Although downloaded themes will still be stored in the system-level directory, they will be copied to this directory when they are applied. The paths defined here must physically exist and be writable by the webserver.</p>" => '<p>テーマのファイルをブログごとに保存したい場合は、テーマのURLとパスを以下に設定してください。ダウンロードされたテーマはシステムレベルで設定したディレクリに保存されますが、ブログに適用すればここで指定したディレクトリにもコピーされます。このパスは物理的に存在しかつWebサーバーから書き込み可能でなければなりません。</p>',


);

1;

