# # Copyright 2003-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.
#
# $Id$

package MT::L10N::ja;
use strict;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (
    ## mt-add-notify.cgi
    ## mt-atom.cgi
    ## mt-comments.cgi
    ## mt-db2sql.cgi
    ## mt-feed.cgi
    ## mt-search.cgi
    ## mt-send-entry.cgi
    ## mt-tb.cgi
    ## mt-testbg.cgi
    ## mt-upgrade.cgi
    ## mt-view.cgi
    ## mt-wizard.cgi
    ## mt-xmlrpc.cgi
    ## mt.cgi
    ## mt-check.cgi.pre
    'Movable Type System Check' => 'Movable Typeシステム・チェック',
    'This page provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'Movable Typeが動作するために必要なPerlモジュールのインストールについての確認と、設定に関するシステムの情報を表示します。',
    'Current working directory:' => 'CGIが動作しているディレクトリ: ',
    'MT home directory:' => 'ホーム・ディレクトリ: ',
    'Operating system:' => 'オペレーティング・システム（OS）: ',
    'Perl version:' => 'Perl のバージョン: ',
    'Perl include path:' => 'Perl Include ライブラリ・パス: ',
    'Web server:' => 'ウェブ・サーバー: ',
    '(Probably) Running under cgiwrap or suexec' => '(おそらく)cgiwrapもしくはsuexecが利用できます。',
    'Checking for [_1] Modules:' => 'モジュールの確認: [_1]',
    'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have either DB_File, or else DBI and at least one of the other modules installed.' => 'Movable Typeのデータを保存するために、以下のデータベース接続用のモジュールが必要です。Berkeley DB を利用する場合は、DB_Fileモジュールが、SQLデータベースを利用する場合は、DBモジュールと利用するデータベースに対応するDBDモジュールがインストールされている必要があります。',
    'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => 'サーバーに、[_1]がインストールされていない、古いバージョンがインストールされている、もしくは[_1]に必要なモジュールがインストールされていません。',
    'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'サーバーに[_1]がインストールされていないか、[_1]に必要なモジュールがインストールされていません',
    'Please consult the installation instructions for help in installing [_1].' => '[_1]をインストールする場合は、インストール手順を参照してください。',
    'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'インストールされているDBD:mysqlではご利用できません。最新のバージョンをご利用ください。',
    'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => '$mod はインストールされていますが、更新されたDBIモジュールが必要です。DBIモジュールの要件についての上記の注釈をお読みください。',
    'Your server has [_1] installed (version [_2]).' => 'サーバーには、[_1]がインストールされています。(バージョン: [_2])',
    'Movable Type System Check Successful' => 'Movable Typeのシステム・チェックは、無事に完了しました。',
    'You\'re ready to go!' => '準備が整いました。',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'サーバーには必要なモジュールがすべて揃っています。追加のモジュールのインストールは必要ありません。インストールの説明に従って、次の手順に進んでください。',
    'CGI is required for all Movable Type application functionality.' => 'CGIは、Movable Typeのすべての機能で必要です。',
    'HTML::Template is required for all Movable Type application functionality.' => 'HTML::Tempalteは、Movable Typeを利用するために必要です。',
    'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Sizeは、ファイルをアップロードするために必要です。アップロードする画像のサイズを調べるために使います。',
    'File::Spec is required for path manipulation across operating systems.' => 'File::Specは、オペレーション・システムに依存しないファイル・アクセスを実現するために必要です。',
    'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookieは、Cookie認証のために必要です。',
    'DB_File is required if you want to use the Berkeley DB/DB_File backend.' => 'DB_Fileは、Berkley DB/DB_Fileを使ってブログのデータを管理するために必要です。',
    'DBI is required if you want to use any of the SQL database drivers.' => 'DBIは、SQL対応のデータベースを使ってブログのデータを管理するために必要です。',
    'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'DBIとDBD::mysqlは、MySQLを使ってブログのデータを管理するために必要です。',
    'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'DBIとDBD::Pgは、PostgreSQLを使ってブログのデータを管理するために必要です。',
    'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'DBIとDBD::SQLiteは、SQLiteを使ってブログのデータを管理するために必要です。',
    'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'DBIとDBD::SQLite2は、SQLite2.xを使ってブログのデータを管理するために必要です。',
    'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in mt.cfg.' => 'HTML::Entitiesは、いくつかの文字を変換するために必要です。環境設定ファイルの「NoHTMLEntities」を使うことで、この機能を無効にできます。',
    'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'LWP::UserAgentは、トラックバックや更新情報を送信するために必要です。',
    'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.' => 'SOAP::Liteは、XML-RPC APIやAtom API を利用するときに必要です。',
    'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Tempは、ファイルのアップロードで上書きするために必要です。',
    'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Image::Magickは、画像をアップロードする際のサムネイル自動作成のために必要です。',
    'Storable is optional; it is required by certain MT plugins available from third parties.' => 'Storableは、プラグイン・モジュールを実行するために必要になることがあります。',
    'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSAをインストールすると、コメント登録機能を利用するときに、TypeKeyを利用したサインインの動作が高速になります。',
    'MIME::Base64 is required in order to enable comment registration.' => 'MIME::Base64は、コメントの登録のために必要です。',
    'XML::Atom is required in order to use the Atom API.' => 'XML::Atomは、Atom API を利用するときに必要です。',
    'Data Storage' => 'データ管理',
    'Required' => '必要',
    'Optional' => 'オプション',
    'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => '以下のモジュールは<strong>オプション</strong>です。なくても動作しますが、関連する機能を利用するためにはインストールしておく必要があります。',
    
    ## default_templates/dynamic_site_bootstrapper.tmpl
    ## default_templates/dynamic_pages_error_template.tmpl
    'Page Not Found' => 'ページが見つかりません。',
    ## default_templates/main_index.tmpl
    'Continue reading' => '続きを読む',
    'Tags' => 'タグ',
    'Posted by [_1] on [_2]' => '投稿者: [_1] 日時: [_2]',
    'Permalink' => 'パーマリンク',
    'Comments' => 'コメント',
    'TrackBacks' => 'トラックバック',
    'Search' => '検索',
    'Search this blog:' => 'ブログを検索: ',
    'Recent Posts' => '最近のエントリー',
    'Subscribe to this blog\'s feed' => 'このブログのフィードを取得',
    'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.jp/about/feeds',
    'What is this?' => 'フィードとは',
    'Categories' => 'カテゴリー',
    'Archives' => 'アーカイブ',
    'Creative Commons License' => 'クリエイティブ・コモンズ・ライセンス',
    'This weblog is licensed under a' => 'このブログは、次のライセンスで保護されています。',
    '_POWERED_BY' => 'Powered by<br /><a href="http://www.sixapart.jp/movabletype/">Movable Type</a>',
    ## default_templates/master_archive_index.tmpl
    ': Archives' => ': アーカイブ',
    ## default_templates/atom_index.tmpl
    ## default_templates/individual_entry_archive.tmpl
    'Main' => 'メイン',
    'TrackBack' => 'トラックバック',
    'TrackBack URL for this entry:' => 'このエントリーのトラックバックURL: ',
    'Listed below are links to weblogs that reference' => 'この一覧は、次のエントリーを参照しています: ',
    'from' => '送信元',
    'Read More' => '詳しくはこちら',
    'Tracked on' => 'トラックバック時刻: ',
    'Anonymous' => '匿名',
    'Posted on' => '日時: ',
    'Permalink to this comment' => 'このコメントへのパーマリンク',
    'Post a comment' => 'コメントを投稿',
    '(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(いままで、ここでコメントしたことがないときは、コメントを表示する前にこのブログのオーナーの承認が必要になることがあります。承認されるまではコメントは表示されません。そのときはしばらく待ってください。)',
    'Remember personal info?' => 'この情報を登録しますか?',
    '(you may use HTML tags for style)' => '(スタイル用のHTMLタグが使えます)',
    'Preview' => '確認',
    'Post' => '投稿',
    'About' => 'About',
    'The previous post in this blog was <a href="[_1]">[_2]</a>.' => 'ひとつ前の投稿は「<a href="[_1]">[_2]</a>」です。',
    'The next post in this blog is <a href="[_1]">[_2]</a>.' => '次の投稿は「<a href="[_1]">[_2]</a>」です。',
    'Many more can be found on the <a href="[_1]">main index page</a> or by looking through <a href="[_2]">the archives</a>.' => '他にも多くのエントリがあります。<a href="[_1]">メインページ</a>や<a href="[_2]">アーカイブページ</a>も見てください。',
    'This page contains a single entry from the blog posted on <strong>[_1]</strong>.' => '[_1]に投稿されたエントリのページです。',
    ## default_templates/trackback_listing_template.tmpl
    ': Discussion on [_1]' => ': トラックバックの一覧 - [_1]',
    'Trackbacks: [_1]' => 'トラックバック: [_1]',
    'Tracked on [_1]' => 'トラックバック時刻: [_1]',
    ## default_templates/site_javascript.tmpl
    'Thanks for signing in,' => 'サインインを受け付けました。',
    '. Now you can comment. ' => 'さん。コメントができます。',
    'sign out' => 'サイン・アウト',
    'You are not signed in. You need to be registered to comment on this site.' => 'サインインしていません。このサイトにコメントをする前に登録してください。',
    'Sign in' => 'サインイン',
    'If you have a TypeKey identity, you can' => 'TypeKey IDを使って',
    'sign in' => 'サインイン',
    'to use it here.' => 'してください。',
    ## default_templates/category_archive.tmpl
    '<a href="[_1]">[_2]</a> is the next category.' => '次のカテゴリは<a href="[_1]">[_2]</a>です。',
    '<a href="[_1]">[_2]</a> is the previous category.' => '前のカテゴリは<a href="[_1]">[_2]</a>です。',
    'Posted on [_1]' => '日時: [_1]',
    'This page contains an archive of all entries posted to [_1] in the <strong>[_2]</strong> category.  They are listed from oldest to newest.' => 'ブログ「[_1]」のカテゴリ「[_2]」に投稿されたすべてのエントリのアーカイブのページです。新しい順番に並んでいます。',
    ## default_templates/rss_20_index.tmpl
    ## default_templates/datebased_archive.tmpl
    '<a href="[_1]">[_2]</a> is the next archive.' => '次のアーカイブは<a href="[_1]">[_2]</a>です。',
    '<a href="[_1]">[_2]</a> is the previous archive.' => '前のアーカイブは<a href="[_1]">[_2]</a>です。',
    'About [_1]' => 'About [_1]',
    'This page contains all entries posted to [_1] in <strong>[_2]</strong>. They are listed from oldest to newest.' => '[_2]にブログ「[_1]」に投稿されたすべてのエントリです。新しい順に並んでいます。',
    ## default_templates/comment_error_template.tmpl
    'Comment Submission Error' => 'コメントの登録エラー',
    'Your comment submission failed for the following reasons:' => '次のエラーでコメントを投稿できませんでした: ',
    'Return to the original entry' => 'エントリーのページに戻る',
    ## default_templates/search_results_template.tmpl
    'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => '検索結果のフィードのAuto Discovery用リンクは検索が実行されたときにのみ表示されます。',
    'Search Results' => '検索結果',
    'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => '通常の検索では検索クエリ用のフォームを返す',
    'Search this site' => 'サイトを検索: ',
    'Match case' => '大文字/小文字を区別',
    'Regex search' => '正規表現で検索',
    'SEARCH RESULTS DISPLAY' => '検索結果表示',
    'Matching entries from [_1]' => 'ブログ: [_1] での検索結果',
    "Entries from [_1] tagged with '[_2]'" => 'ブログ: [_1] でタグ: [_2] が指定されているエントリ',
    'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => '<MTIfNonEmpty tag="EntryAuthorDisplayName">投稿者: [_1]  </MTIfNonEmpty>日時: [_2]',
    'NO RESULTS FOUND MESSAGE' => '検索結果がないときのメッセージ',
    "Entries matching '[_1]'" => '[_1] を含むエントリ',
    "Entries tagged with '[_1]'" => 'タグ: [_1] が指定されているエントリ',
    "No pages were found containing '[_1]'." => '[_1] を含むページが見つかりませんでした。',
    'Instructions' => '使用方法',
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => 'すべての言葉が含まれるページを検索します。言葉を検索するときは、引用符で囲んでください。',
    'movable type' => 'movable type',
    'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions' => '以下のように検索条件を AND、OR、NOT を使って指定することもできます: ',
    'personal OR publishing' => '検索条件1 OR 検索条件2',
    'publishing NOT personal' => '検索条件1 NOT 検索条件2',
    'END OF ALPHA SEARCH RESULTS DIV' => '検索結果のDIV(ALPHA)ここまで',
    'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'ここから検索情報を表示するBETAサイドバー',
    'SET VARIABLES FOR SEARCH vs TAG information' => '検索またはタグの情報を変数に代入',
    'Subscribe to feed' => 'フィードを取得',
    "If you use an RSS reader, you can subscribe to a feed of all future entries tagged '[_1]'." => 'フィードリーダーを利用して検索結果を購読し、今後投稿されるエントリでタグ「[_1]」が指定されているものにアクセスできます。',
    "If you use an RSS reader, you can subscribe to a feed of all future entries matching '[_1]'." => 'フィードリーダーを利用して検索結果を購読し、今後投稿されるエントリで「[_1]」にマッチするものにアクセスできます。',
    'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => '（タグ）検索結果のフィードの購読に関する情報',
    'Feed Subscription' => '購読',
    'TAG LISTING FOR TAG SEARCH ONLY' => 'タグ一覧はタグ検索でのみ表示',
    'Other Tags' => 'その他のタグ',
    'Other tags used on this blog' => 'このブログで使われているタグ',
    'END OF PAGE BODY' => 'ページ本体ここまで',
    'END OF CONTAINER' => 'コンテナここまで',
    ## default_templates/comment_preview_template.tmpl
    'Comment on' => 'コメント: ',
    'Previewing your Comment' => 'コメントの確認',
    'Cancel' => '取り消し',
    ## default_templates/rsd.tmpl
    ## default_templates/comment_pending_template.tmpl
    'Comment Pending' => 'コメントの保留',
    'Thank you for commenting.' => 'コメントを受け付けました。',
    'Your comment has been received and held for approval by the blog owner.' => 'コメントを受け付けました。受け付けたコメントは、ブログの管理者の承認のため保留されています。',
    ## default_templates/uploaded_image_popup_template.tmpl
    ## default_templates/stylesheet.tmpl
    ## lib/MT/ObjectTag.pm
    ## lib/MT/BasicSession.pm
    ## lib/MT/XMLRPC.pm
    'No WeblogsPingURL defined in mt.cfg' => '「WeblogsPingURL」が、環境設定ファイルに設定されていません。',
    'No MTPingURL defined in mt.cfg' => '「MTPingURL」が、環境設定ファイルに設定されていません。',
    'HTTP error: [_1]' => 'HTTPエラー: [_1]',
    'Ping error: [_1]' => 'トラックバック・エラー: [_1]',
    ## lib/MT/Builder.pm
    '&lt;MT[_1]> with no &lt;/MT[_1]>' => '<MT[_1]>タグが閉じられていません。',
    'Error in &lt;MT[_1]> tag: [_2]' => '&lt;MT[_1]>タグでエラーが発生しました: [_2]',
    ## lib/MT/Serialize.pm
    ## lib/MT/DateTime.pm
    ## lib/MT/Request.pm
    ## lib/MT/Atom.pm
    ## lib/MT/Trackback.pm
    ## lib/MT/WeblogPublisher.pm
    'Load of blog \'[_1]\' failed: [_2]' => 'ブログ[_1]の読み込みに失敗しました: [_2]',
    'Archive type \'[_1]\' is not a chosen archive type' => 'アーカイブの種類「[_1]」はアーカイブの設定で選択されていません。',
    'Error making path \'[_1]\': [_2]' => 'ディレクトリ[_1]の作成に失敗しました: [_2]',
    'Parameter \'[_1]\' is required' => '次のパラメーターが必要です: [_1]',
    'Building category archives, but no category provided.' => 'カテゴリー・アーカイブを構築しようとしましたが、カテゴリーがありません。',
    'You did not set your Local Archive Path' => 'ローカル・アーカイブパスを設定してください',
    'Building category \'[_1]\' failed: [_2]' => 'カテゴリー・アーカイブ「[_1]」の再構築に失敗しました: [_2]',
    'Building entry \'[_1]\' failed: [_2]' => 'エントリー・アーカイブ「[_1]」の再構築に失敗しました: [_2]',
    'Building date-based archive \'[_1]\' failed: [_2]' => '日付アーカイブ「[_1]」の再構築に失敗しました: [_2]',
    'Writing to \'[_1]\' failed: [_2]' => '「[_1]」への書き込みに失敗しました: [_2]',
    'Renaming tempfile \'[_1]\' failed: [_2]' => 'テンポラリーファイル[_1]のファイル名の変更に失敗しました: [_2]',
    'You did not set your Local Site Path' => 'ローカル・サイトパスを設定してください',
    'Template \'[_1]\' does not have an Output File.' => 'テンプレート「[_1]」の出力ファイルが設定されていません。',
    'An error occurred while rebuilding to publish scheduled posts: [_1]' => '指定日投稿を公開するための再構築中にエラーが発生しました: [_1]',
    ## lib/MT/Task.pm
    ## lib/MT/Bootstrap.pm
    'Got an error: [_1]' => 'エラーが発生しました: [_1]',
    ## lib/MT/ObjectDriver.pm
    ## lib/MT/Config.pm
    ## lib/MT/Promise.pm
    ## lib/MT/Tag.pm
    'Tag must have a valid name' => 'タグには有効な名前が必要です。',
    'This tag is referenced by others.' => 'このタグは他のタグによって参照されます。',
    ## lib/MT/ErrorHandler.pm
    ## lib/MT/L10N.pm
    ## lib/MT/Object.pm
    '4th argument to add_callback must be a perl CODE reference' => 'add_callback関数の4番目の引数は、CODEである必要があります。',
    ## lib/MT/Category.pm
    'Categories must exist within the same blog' => 'カテゴリーが見つかりません。',
    'Category loop detected' => 'カテゴリー・ループエラーが発生しました。',
    ## lib/MT/default-templates.pl
    ## lib/MT/JunkFilter.pm
    'Action: Junked (score below threshold)' => '迷惑コメント/トラックバックと判断しました。',
    'Action: Published (default action)' => '公開しました。',
    'Junk Filter [_1] died with: [_2]' => '迷惑コメント/トラックバック・フィルター「[_1]」は、次の理由で使えません: [_2]',
    'Unnamed Junk Filter' => '迷惑コメント/トラックバック・フィルターがありません',
    'Composite score: [_1]' => 'スコア集計値: [_1]',
    ## lib/MT/Blocklist.pm
    ## lib/MT/TBPing.pm
    ## lib/MT/Comment.pm
    'Load of entry \'[_1]\' failed: [_2]' => 'エントリー「[_1]」の読み込みに失敗しました: [_2]',
    ## lib/MT/Mail.pm
    'Unknown MailTransfer method \'[_1]\'' => 'サポートしてないメール転送方式「[_1]」が設定されています',
    'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'SMTPでメールを送信するには、サーバーにMail::Sendmailをインストールする必要があります: [_1]',
    'Error sending mail: [_1]' => 'メールの送信エラー: [_1]',
    'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'sendmailへのパスがありません。環境設定ファイルでSMTP経由の設定をしてください。',
    'Exec of sendmail failed: [_1]' => 'sendmailの実行に失敗しました: [_1]',
    ## lib/MT/Sanitize.pm
    ## lib/MT/Module/Build.pm
    ## lib/MT/FileInfo.pm
    ## lib/MT/Entry.pm
    'Load of blog failed: [_1]' => 'ブログの読み込みに失敗しました: [_1]',
    'Future' => '指定日',
    ## lib/MT/Plugin.pm
    'Loading template \'[_1]\' failed: [_2]' => 'テンプレート「[_1]」の読み込みに失敗しました: [_2]',
    ## lib/MT/Notification.pm
    ## lib/MT/I18N/default.pm
    ## lib/MT/I18N/en_us.pm
    ## lib/MT/I18N/ja.pm
    ## lib/MT/Log.pm
    'Entry # [_1] not found.' => 'エントリーは見つかりません (ID: [_1])',
    'Comment # [_1] not found.' => 'コメントは見つかりません: (ID: [_1])',
    'TrackBack # [_1] not found.' => 'トラックバックは見つかりません: [_1]',
    ## lib/MT/DefaultTemplates.pm
    'Atom Index' => 'Atom',
    'Category Archive' => 'カテゴリー・アーカイブ',
    'Date-Based Archive' => '日付アーカイブ',
    'Dynamic Site Bootstrapper' => 'Dynamic Site Bootstrapper',
    'index' => 'メインページ',
    'Individual Entry Archive' => 'エントリー・アーカイブ',
    'Main Index' => 'メインページ',
    'Master Archive Index' => 'アーカイブページ',
    'RSD' => 'RSD',
    'RSS 1.0 Index' => 'RSS 1.0',
    'RSS 2.0 Index' => 'RSS 2.0',
    'Stylesheet' => 'スタイルシート',
    ## lib/MT/Template/ContextHandlers.pm
    'Now you can comment.' => 'さん。コメントしてください。',
    'Remember me?' => 'ログイン情報を記憶しますか?',
    'Yes' => 'はい',
    'No' => 'いいえ',
    '. Now you can comment.' => 'さん。コメントができます。',
    'If you have a TypeKey identity, you can ' => 'TypeKey IDを使って',
    'Can\'t find included template module \'[_1]\'' => '読み込むテンプレート・モジュール「[_1]」が見つかりません。',
    'Can\'t find included file \'[_1]\'' => '読み込むファイル「[_1]」が見つかりません',
    'Error opening included file \'[_1]\': [_2]' => '読み込むファイル[_1]を開けません: [_2]',
    'Unspecified archive template' => 'アーカイブ・テンプレートが指定されていません。',
    'Error in file template: [_1]' => 'テンプレートファイルでエラーが発生しました: [_1]',
    'Can\'t find template \'[_1]\'' => 'テンプレート「[_1]」が見つかりません',
    'Can\'t find entry \'[_1]\'' => 'エントリー「[_1]」が見つかりません。',
    '[_1] [_2]' => '[_1] [_2]',
    'You used a [_1] tag without any arguments.' => '[_1]タグには引数が必要です。',
    'You have an error in your \'category\' attribute: [_1]' => 'カテゴリーにエラーがあります: [_1]',
    'You have an error in your \'tag\' attribute: [_1]' => 'タグにエラーがあります: [_1]',
    'No such author \'[_1]\'' => '「[_1]」という投稿者は存在しません',
    'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => '[_1]タグが、エントリーのコンテキスト外で使われた可能性があります。<MTEntries>コンテナの外に誤って記述していませんか?',
    'You used <$MTEntryFlag$> without a flag.' => '<$MTEntryFlag$>タグにはフラグが必要です。',
    'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => '[_1]タグを使って、[_2]アーカイブにリンクしようとしましたが、そのアーカイブ・タイプは公開されていません。',
    'Could not create atom id for entry [_1]' => '次のエントリーのためのAtom IDを生成できません: [_1]',
    'To enable comment registration, you need to add a TypeKey token in your weblog config or author profile.' => 'コメント登録機能を使うには、TypeKeyトークンをブログ、もしくは投稿者のプロフィールで設定する必要があります。',
    '(You may use HTML tags for style)' => '(スタイル用のHTMLタグが使えます)',
    'You used an [_1] tag without a date context set up.' => '[_1]タグには日付コンテキスト設定が必要です。',
    'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => 'コメント以外の場所で[_1]タグを利用できません。<MTComment>コンテナの外側で使っているのかもしれません',
    'You used an [_1] without a date context set up.' => '[_1]には日付コンテキスト設定が必要です。',
    '[_1] can be used only with Daily, Weekly, or Monthly archives.' => '「[_1]」は日別、週別、月別いずれかのアーカイブで利用できます。',
    'Couldn\'t get daily archive list' => '日付アーカイブのリストが見つかりません。',
    'Couldn\'t get monthly archive list' => '月別アーカイブのリストが見つかりません。',
    'Couldn\'t get weekly archive list' => '週別アーカイブのリストが見つかりません。',
    'Unknown archive type [_1] in <MTArchiveList>' => '<MTArchiveList>タグの種類の指定に誤りがあります。',
    'Group iterator failed.' => 'グループの繰り返しでエラーが発生しました。',
    'You used an [_1] tag outside of the proper context.' => '[_1]タグが適切なコンテキスト外で使われました。',
    'You used an [_1] tag outside of a Daily, Weekly, or Monthly context.' => '[_1]タグは日付ベースのアーカイブでのみ使えます。',
    'Could not determine entry' => 'エントリーが見つかりません。',
    'Invalid month format: must be YYYYMM' => '月の表記はYYYYMM (例: 200509) にする必要があります。',
    'No such category \'[_1]\'' => '「[_1]」というカテゴリーはありません',
    'You used <$MTCategoryDescription$> outside of the proper context.' => '<$MTCategoryDescription$>タグを適切な場所で使っていません。',
    '[_1] can be used only if you have enabled Category archives.' => '「[_1]」はカテゴリー・アーカイブで利用できます。',
    '<$MTCategoryTrackbackLink$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<$MTCategoryTrackbackLink$>は、必ずカテゴリーのコンテキスト内で使うか、このタグのカテゴリー属性と共に使います。',
    'You failed to specify the label attribute for the [_1] tag.' => '[_1]タグのラベル属性が指定されていません。',
    'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => '[_1]タグを適切な場所で使っていません。<MTPings>コンテナの外で使っていませんか?',
    'MTSubCatsRecurse used outside of MTSubCategories' => '<MTSubCatsRecurse>タグが、<MTSubCategories>コンテナの外で使われています。',
    'MT[_1] must be used in a category context' => 'MT[_1]は、<MTCategories>コンテナ内で使ってください。',
    'Cannot find package [_1]: [_2]' => 'パッケージ: [_1] が見つかりません: [_2]',
    'Error sorting categories: [_1]' => 'カテゴリーのソートでエラーが発生しました: [_1]',
    'Movable Type Enterprise' => 'Movable Type Enterprise',
    ## lib/MT/Template/Context.pm
    ## lib/MT/Plugin/L10N.pm
    ## lib/MT/Plugin/JunkFilter.pm
    'from rule' => 'ルールから',
    'from test' => 'テストから',
    ## lib/MT/BasicAuthor.pm
    ## lib/MT/ImportExport.pm
    'No Stream' => 'ファイルが開けません。',
    'No Blog' => 'ブログが見つかりません。',
    'Can\'t rewind' => '読み込み中にエラーが発生しました。',
    'Can\'t open \'[_1]\': [_2]' => 'ファイル[_1]を開けません: [_2]',
    'Can\'t open directory \'[_1]\': [_2]' => 'ディレクトリ[_1]を開けません: [_2]',
    'No readable files could be found in your import directory [_1].' => '読み込み元ディレクトリ[_1]に、読み込み可能なファイルはありません。',
    'Importing entries from file \'[_1]\'' => '記事を[_1]から読み込んでいます。',
    "You need to provide a password if you are going to\ncreate new authors for each author listed in your blog.\n" => "ブログに投稿者を追加するためには、パスワードを指定する必要があります。\n",
    'Need either ImportAs or ParentAuthor' => '「ImportAs」か「ParentAuthor」が必要です。',
    'Creating new author (\'[_1]\')...' => '新しい投稿者[_1]を登録します。',
    "failed\n" => "失敗しました。\n",
    "ok (ID [_1])\n" => "完了しました。(ID: [_1])\n",
    "ok\n" => "完了しました。\n",
    'Saving author failed: [_1]' => '投稿者の保存に失敗しました: [_1]',
    'Assigning permissions for new author...' => '新しい投稿者の権限を設定します。',
    'Saving permission failed: [_1]' => '権限の保存に失敗しました: [_1]',
    'Creating new category (\'[_1]\')...' => '新しいカテゴリー「[_1]」を登録します。',
    'Saving category failed: [_1]' => 'カテゴリーの保存に失敗しました: [_1]',
    'Invalid status value \'[_1]\'' => '状態の値が正しくありません: [_1]',
    'Invalid allow pings value \'[_1]\'' => 'トラックバックの可否指定に誤りがあります: [_1]',
    "Can't find existing entry with timestamp '[_1]'... skipping comments, and moving on to next entry.\n" => "既存のタイムスタンプが「[_1]」のエントリーが見つかりません。コメントをスキップし、次のエントリーへ移動します。\n",
    "Importing into existing entry [_1] ('[_2]')\n" => "エントリー「[_2] (ID: [_1])」にコメントを追加します。\n",
    'Saving entry (\'[_1]\')...' => 'エントリー 「[_1]」を保存します。',
    'Saving entry failed: [_1]' => 'エントリーの保存に失敗しました: [_1]',
    'Saving placement failed: [_1]' => 'エントリーとブログの関連づけができません: [_1]',
    'Creating new comment (from \'[_1]\')...' => '[_1]からの新しいコメントを登録します。',
    'Saving comment failed: [_1]' => 'コメントの保存に失敗しました: [_1]',
    'Entry has no MT::Trackback object!' => 'エントリーにはMT::Trackbackオブジェクトがありません。',
    'Creating new ping (\'[_1]\')...' => '新しいトラックバック「[_1]」を登録します。',
    'Saving ping failed: [_1]' => 'トラックバックの保存に失敗しました: [_1]',
    'Export failed on entry \'[_1]\': [_2]' => 'エントリー「[_1]」の書き出しに失敗しました: [_2]',
    'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => '日付の形式[_1]が正しくありません。MM/DD/YYYY HH: MM: SS AM|PM (AM/PM はなくてもかまいません)',
    ## lib/MT/XMLRPCServer.pm
    'Invalid timestamp format' => 'タイムスタンプの書式が正しくありません',
    'No web services password assigned.  Please see your author profile to set it.' => 'Webサービス・パスワードが設定されていません。投稿者のプロフィールから設定を行ってください。',
    'No blog_id' => 'ブログIDが見つかりません。',
    "Invalid blog ID '[_1]'" => 'ブログIDの設定に誤りがあります: [_1]',
    'Invalid login' => 'ログインできません',
    'No posting privileges' => '投稿する権限がありません',
    'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => '「mt_[_1]」の値は、0か1である必要があります。(元の値: [_2])',
    'PreSave failed [_1]' => 'PreSaveでエラーが発生しました: [_1]',
    'User \'[_1]\' (user #[_2]) added entry #[_3]' => '[_1] (ID: [_2]) が投稿しました (エントリーID: [_3])',
    'Entry "[_1]" added by user "[_2]"' => '[_2]がエントリー「[_1]」を投稿しました。',
    "Entry '[_1]' (ID:[_2]) added by user '[_3]'" => '[_3]がエントリー「[_1]」(ID: [_2])を投稿しました。',
    'No entry_id' => 'エントリーIDが見つかりません。',
    'Invalid entry ID \'[_1]\'' => 'エントリーIDが正しくありません: [_1]',
    'Not privileged to edit entry' => 'エントリー編集の権限がありません',
    'Not privileged to delete entry' => 'エントリー削除の権限がありません',
    "Entry '[_1]' (entry #[_2]) deleted by '[_3]' (user #[_4]) from xml-rpc" => '[_3](ID: [_4])がXML-RPCでエントリーを削除しました: [_1](ID:[_2])',
    'Not privileged to get entry' => 'エントリー取得の権限がありません',
    'Author does not have privileges' => '権限が設定されていません',
    'Not privileged to set entry categories' => 'エントリーにカテゴリーを設定する権限がありません',
    'Publish failed: [_1]' => '公開に失敗しました。',
    'Not privileged to upload files' => 'ファイルをアップロードする権限がありません',
    'No filename provided' => 'ファイル名が指定されていません',
    'Invalid filename \'[_1]\'' => 'ファイル名が正しくありません: [_1]',
    'Error writing uploaded file: [_1]' => 'アップロードされたファイルの書き込み中にエラーが発生しました: [_1]',
    'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'TemplateメソッドはBlogger APIとMovable Type APIとの間で異なるため、実装されていません。',
    ## lib/MT/Upgrade.pm
    'Invalid upgrade function: [_1].' => 'アップグレード中にエラーが発生しました: [_1]',
    'Error loading class: [_1].' => 'プログラム・モジュールをロードしているときにエラーが発生しました: [_1]',
    'Creating initial weblog and author records...' => 'ブログと管理者の初期値を登録します。',
    'Error saving record: [_1].' => 'レコードの保存中にエラーが発生しました: [_1]',
    'Can\'t find default template list; where is \'default-templates.pl\'? Error: [_1]' => 'デフォルト・テンプレートの一覧default-tempaltes.plが見つかりません: [_1]',
    'Creating new template: \'[_1]\'.' => 'デフォルト・テンプレート「[_1]」を登録します。',
    'Mapping templates to blog archive types...' => 'デフォルト・テンプレートをアーカイブの種類ごとに設定しています。',
    'Upgrading table for [_1]' => 'データベースをアップグレードします: [_1]',
    'Upgrading database from version [_1].' => 'バージョン: [_1]のデータベースからアップグレードします。',
    'Database has been upgraded to version [_1].' => '完了しました: バージョン: [_1]',
    "Plugin '[_1]' upgraded successfully." => 'プラグイン [_1] が更新されました。',
    "Plugin '[_1]' installed successfully." => 'プラグイン [_1] がインストールされました。',
    'Setting your permissions to administrator.' => 'データベースをアップグレードします: システム管理者の権限',
    'Creating configuration record.' => '環境を設定しています',
    'Creating template maps...' => 'テンプレート・マッピングを設定します。',
    'Mapping template ID [_1] to [_2] ([_3]).' => 'テンプレートID[_1]を[_2] ([_3]) に設定します',
    'Mapping template ID [_1] to [_2].' => 'テンプレートID[_1]を[_2]に設定',
    'Assigning author types...' => '投稿者の種類を適用しています...',
    'Assigning basename for categories...' => 'カテゴリーにベースネームを適用しています...',
    'Assigning blog administration permissions...' => 'ブログの管理権限を設定しています...',
    'Assigning category parent fields...' => 'カテゴリーに親フィールドを適用しています...',
    'Assigning comment/moderation settings...' => '迷惑コメントの設定をしています...',
    'Assigning custom dynamic template settings...' => 'ダイナミックテンプレートのカスタム設定を適用しています...',
    'Assigning entry basenames for old entries...' => '過去のエントリーにベースネームを設定しています...',
    'Assigning junk status for comments...' => '迷惑コメントを設定しています...',
    'Assigning junk status for TrackBacks...' => '迷惑トラックバックを設定しています...',
    'Assigning template build dynamic settings...' => 'テンプレートの再構築設定（ダイナミック）を適用しています...',
    'Assigning visible status for comments...' => 'コメントの表示状態を適用しています...',
    'Assigning visible status for TrackBacks...' => 'トラックバックの表示状態を適用しています...',
    'Creating entry category placements...' => 'エントリーとカテゴリーを関連付けています...',
    'Migrating any "tag" categories to new tags...' => '「タグ」というカテゴリをタグに移行しています...',
    'Setting blog allow pings status...' => 'ブログへのトラックバックの可否を設定しています...',
    'Setting blog basename limits...' => 'ブログのベースネームの制限を設定しています...',
    'Setting default blog file extension...' => '既定のブログファイルの拡張子を設定しています...',
    'Setting new entry defaults for weblogs...' => 'エントリ投稿画面の新しい既定値を設定しています...',
    'Updating author web services passwords...' => '投稿者のWebサービスパスワードを更新しています...',
    'Updating blog comment email requirements...' => 'ブログにコメントと関連するメールの設定をしています...',
    'Updating blog old archive link status...' => 'ブログの過去のアーカイブのリンクステータスを更新しています...',
    'Updating category placements...' => 'カテゴリーの関連付けを更新しています...',
    'Updating comment status flags...' => 'コメントステータスのフラグを更新しています...',
    'Updating commenter records...' => 'コメント投稿者のレコードを更新しています...',
    'Updating entry week numbers...' => 'エントリーの週を更新しています...',
    'Updating user permissions for editing tags...' => 'ユーザーのタグ編集権限を更新しています...',
    'Updating [_1] records...' => '[_1]のレコードを更新しています...',
    ## lib/MT/Callback.pm
    ## lib/MT/ConfigMgr.pm.pre
    'Error opening file \'[_1]\': [_2]' => '[_1]を開けません: [_2]',
    'Config directive [_1] without value at [_2] line [_3]' => '環境変数「[_1]」が未設定です。(ファイル: [_2])、[_3]行目)',
    'No such config variable \'[_1]\'' => '「[_1]」という設定変数はありません',
    ## lib/MT/Template.pm
    'Parse error in template \'[_1]\': [_2]' => 'テンプレート「[_1]」に解析エラーが発生しました: [_2]',
    'Build error in template \'[_1]\': [_2]' => 'テンプレート「[_1]」の再構築に失敗しました: [_2]',
    'You cannot use a [_1] extension for a linked file.' => 'リンクされたファイルに拡張子[_1]は使えません。',
    'Opening linked file \'[_1]\' failed: [_2]' => 'リンクされたファイル[_1]が開けません: [_2]',
    ## lib/MT/L10N/nl.pm
    ## lib/MT/L10N/es.pm
    ## lib/MT/L10N/en_us.pm
    ## lib/MT/L10N/de.pm
    ## lib/MT/L10N/fr.pm
    ## lib/MT/L10N/ja.pm
    ## lib/MT/TaskMgr.pm
    'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'システムタスクを実行するためのロックを取得できませんでした。TempDir（[_1]）に書き込みできることを確認してください。',
    'Error during task \'[_1]\': [_2]' => 'タスク[_1]の間にエラーが発生しました:  [_2]',
    'Scheduled Tasks Update' => 'スケジュール・タスク通知',
    'The following tasks were run:' => '以下のタスクが実行されました:',
    ## lib/MT/Blog.pm
    ## lib/MT/Placement.pm
    ## lib/MT/PluginData.pm
    ## lib/MT/AtomServer.pm
    ## lib/MT/Author.pm
    'Can\'t approve/ban non-COMMENTER author' => '承認/禁止はコメント投稿者にしか設定できません。',
    'The approval could not be committed: [_1]' => '権限の保存に失敗しました: [_1]',
    ## lib/MT/App.pm
    'Error loading [_1]: [_2]' => '[_1]のロードでエラーが発生しました: [_2]',
    'Invalid login attempt from user \'[_1]\'' => 'ログイン名、またはパスワードが正しくありません。',
    "Failed login attempt by unknown user '[_1]'" => '登録されていないユーザー名でログインしようとしました。[_1]',
    "Invalid login attempt from user '[_1]' (ID: [_2])" => 'ユーザー[_1](ID: [_2])がログインに失敗しました。',
    "Failed login attempt with incorrect password by user '[_1]' (ID: [_2])" => 'ユーザー「[_1]」(ID: [_2])が誤ったパスワードでログインしようとしました。',
    'User \'[_1]\' (user #[_2]) logged in successfully' => '[_1] (ID: [_2]) がログインしました。',
    "User '[_1]' (ID:[_2]) logged in successfully" => '[_1] (ID: [_2]) がログインしました。',
    'Invalid login.' => 'ログインできません。',
    'User \'[_1]\' (user #[_2]) logged out' => '[_1] (ID: [_2]) がログアウトしました。',
    "User '[_1]' (ID:[_2]) logged out" => '[_1] (ID: [_2]) がログアウトしました。',
    'The file you uploaded is too large.' => 'アップロードしようとしたファイルのサイズが大き過ぎます。',
    'Unknown action [_1]' => '「[_1]」はできません。',
    ## lib/MT/Util.pm
    'Less than 1 minute from now' => '1分以内',
    'Less than 1 minute ago' => '1分前まで',
    '[quant,_1,hour], [quant,_2,minute] from now' => '[quant,_1,時間,時間][quant,_2,分,分]後',
    '[quant,_1,hour], [quant,_2,minute] ago' => '[quant,_1,時間,時間][quant,_2,分,分]前',
    '[quant,_1,hour] from now' => '[quant,_1,時間,時間]後',
    '[quant,_1,hour] ago' => '[quant,_1,時間,時間]前',
    '[quant,_1,minute] from now' => '[quant,_1,分,分]後',
    '[quant,_1,minute] ago' => '[quant,_1,分,分]前',
    '[quant,_1,day], [quant,_2,hour] from now' => '[quant,_1,日,日][quant,_2,時間,時間]後',
    '[quant,_1,day], [quant,_2,hour] ago' => '[quant,_1,日,日][quant,_2,時間,時間]前',
    '[quant,_1,day] from now' => '[quant,_1,日,日]後',
    '[quant,_1,day] ago' => '[quant,_1,日,日]前',
    'Invalid Archive Type setting \'[_1]\'' => 'アーカイブの種類の設定が正しくありません: [_1]',
    ## lib/MT/Permission.pm
    'Add/Manage Categories' => 'カテゴリーの追加/管理',
    'Blog Administrator' => 'ブログの管理者',
    'Configure Weblog' => 'ブログの設定',
    'Edit All Entries' => 'エントリーの編集',
    'Entry Creation' => 'エントリーの投稿',
    'Manage Categories' => 'カテゴリーの管理',
    'Manage Notification List' => '通知リストの管理',
    'Manage Tags' => 'タグの管理',
    'Manage Templates' => 'テンプレートの管理',
    'Rebuild Files' => '再構築',
    'Recover Password(s)' => 'パスワードを再設定する',
    'Send Notifications' => '通知の送信',
    'View Activity Log For This Weblog' => 'ログの参照',
    ## lib/MT/App/Viewer.pm
    'This is an experimental feature; turn off SafeMode (in mt.cfg) in order to use it.' => '環境設定ファイルの「SafeMode」を設定してください。',
    'Not allowed to view blog [_1]' => 'ブログへのアクセス許可がありません: [_1]',
    'Loading blog with ID [_1] failed' => 'ブログのデータをロードできません: [_1]',
    'Can\'t load \'[_1]\' template.' => 'テンプレートを利用できません: [_1]',
    'Building template failed: [_1]' => 'テンプレートの再構築に失敗しました: [_1]',
    'Invalid date spec' => '日付の設定に誤りがあります。',
    'Can\'t load template [_1]' => 'テンプレートを利用できません: [_1]',
    'Building archive failed: [_1]' => 'アーカイブの再構築に失敗しました: [_1]',
    'Invalid entry ID [_1]' => 'エントリーIDの設定に誤りがあります: [_1]',
    'Entry [_1] is not published' => '指定のエントリーは公開されていません (ID: [_1])',
    'Invalid category ID \'[_1]\'' => 'カテゴリーIDの設定に誤りがあります: [_1]',
    ## lib/MT/App/Trackback.pm
    'You must define a Ping template in order to display pings.' => 'トラックバックを表示するには、トラックバックの一覧のテンプレートを設定してください。',
    'Trackback pings must use HTTP POST' => 'トラックバックの送信は、HTTP POSTメソッドを使う必要があります。',
    'Need a TrackBack ID (tb_id).' => 'トラックバックIDが必要です。',
    'Invalid TrackBack ID \'[_1]\'' => '不正なトラックバックIDです: [_1]',
    'You are not allowed to send TrackBack pings.' => 'トラックバックの送信が許可されていません。',
    'You are pinging trackbacks too quickly. Please try again later.' => 'トラックバックの送信頻度が高すぎます。しばらくして、もう一度試してください。',
    'Need a Source URL (url).' => '送信元のURLが必要です。',
    'Invalid URL \'[_1]\'' => '不正なURLです: [_1]',
    'This TrackBack item is disabled.' => 'このトラックバックは利用できません。',
    'This TrackBack item is protected by a passphrase.' => 'このトラックバックはパスワードで保護されています。',
    'New TrackBack for entry #[_1] \'[_2]\'.' => 'エントリー「[_2] (ID: [_1])」への新しいトラックバック',
    'TrackBack on "[_1]" from "[_2]".' => '「[_1]」に[_2]からのトラックバックを受信しました。',
    'New TrackBack for category #[_1] \'[_2]\'.' => 'カテゴリー「[_2] (ID: [_1])」への新しいトラックバック',
    "TrackBack for category #[_1] '[_2]'." => '[_2]（ID: [_1]）へのトラックバックを受信しました。',
    "TrackBack on category '[_1]' (ID:[_2])." => 'カテゴリー [_1]（ID: [_2]）へのトラックバックを受信しました。',
    'Rebuild failed: [_1]' => '再構築に失敗しました: [_1]',
    'Can\'t create RSS feed \'[_1]\': ' => 'RSSフィード「[_1]」を作成できません',
    'New TrackBack Ping to Entry [_1] ([_2])' => 'エントリー「[_2] (ID: [_1])」への新しいトラックバック',
    'New TrackBack Ping to Category [_1] ([_2])' => 'カテゴリー「[_2] (ID: [_1])」への新しいトラックバック',
    ## lib/MT/App/ActivityFeeds.pm
    'An error occurred while generating the activity feed: [_1].' => 'ログ・フィードの生成中にエラーが発生しました: [_1]',
    'No permissions.' => '権限がありません。',
    '[_1] Weblog TrackBacks' => 'トラックバック: ',
    'All Weblog TrackBacks' => 'すべてのブログのトラックバック',
    '[_1] Weblog Comments' => 'コメント: ',
    'All Weblog Comments' => 'すべてのブログのコメント',
    '[_1] Weblog Entries' => 'エントリー: ',
    'All Weblog Entries' => 'すべてのブログのエントリー',
    '[_1] Weblog Activity' => 'ログ: ',
    'All Weblog Activity' => 'すべてのブログのログ',
    'Movable Type System Activity' => 'Movable Type システム・ログ',
    'Movable Type Debug Activity' => 'Movable Type デバッグログ',
    ## lib/MT/App/CMS.pm
    'Add Tags...' => 'タグの追加...',
    'Remove Tags...' => 'タグの削除...',
    'Advanced' => '拡張',
    'Ban Commenter(s)' => '投稿を禁止する',
    'Trust Commenter(s)' => '登録する',
    'Unban Commenter(s)' => '投稿を許可する',
    'Unpublish Comment(s)' => 'コメントを未公開にする',
    'Unpublish Entries' => '未公開 (下書き) にする',
    'Unpublish TrackBack(s)' => 'トラックバックを未公開にする',
    'Untrust Commenter(s)' => '登録を解除する',
    'Search Template' => '検索結果',
    'Tags to add to selected entries' => '選択されたエントリーに追加するタグ',
    'Tags to remove from selected entries' => '選択されたエントリーから削除するタグ',
    'Publish Entries' => '公開する',
    'View image' => '画像の確認',
    'Download file' => 'ファイルをダウンロード',
    'No permissions' => '権限がありません',
    'Invalid blog' => 'ブログIDの設定に誤りがあります。',
    'Convert Line Breaks' => '改行を変換する',
    'Password Recovery' => 'パスワードの再設定',
    'No birthplace, cannot recover password' => 'パスワード再設定用のフレーズが設定されていないため、再設定できません。',
    'Invalid author_id' => '投稿者IDの設定に誤りがあります。',
    'Invalid author name \'[_1]\' in password recovery attempt' => 'パスワードの再設定ができません。ログイン名([_1])が誤っています。',
    'Author name or birthplace is incorrect.' => 'ログイン名またはパスワード再設定用のフレーズが正しくありません。',
    'Author has not set birthplace; cannot recover password' => 'パスワード再設定用のフレーズが設定されていないので、パスワードの再設定ができません',
    'Invalid attempt to recover password (used birthplace \'[_1]\')' => 'パスワードの再設定ができません。パスワード再設定用のフレーズ([_1])が誤っています。',
    'Author does not have email address' => 'メールアドレスが登録されていません',
    'Password was reset for author \'[_1]\' (user #[_2]). Password was sent to the following address: [_3]' => '「[_1] (ID: [_2])」のパスワードを再設定し、[_3]宛にメールを送りました。',
    "Password was reset for user '[_1]' (ID:[_2]) and sent to address: [_3]" => '「[_1] (ID: [_2])」のパスワードを再設定し、[_3]宛にメールを送りました。',
    'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'メール送信のエラー ([_1]) が発生しました。メールの設定を確認してから、もう一度試してください。',
    'Invalid type' => '無効なタイプ',
    'tags' => 'タグ',
    'No such tag' => 'タグが見つかりません。',
    'You are not authorized to log in to this blog.' => 'このブログにログインする権限がありません。',
    'No such blog [_1]' => '「[_1]」というブログはありません',
    'System Overview' => 'システム・メニュー',
    'Main Menu' => 'メイン・メニュー',
    'weblogs' => 'ブログ',
    'Weblog Activity Feed' => 'ブログのログ',
    'Weblogs' => 'ブログ',
    '(author deleted)' => '(削除されました)',
    'authors' => '投稿者',
    'Authors' => '投稿者',
    'QuickPost' => 'クイック投稿',
    'Permission denied.' => '権限がありません。',
    'All Feedback' => 'すべてのフィードバック',
    'log records' => 'ログ・レコード',
    'Activity Log' => 'ログ',
    'System Activity Feed' => 'システム・ログ',
    'Application log for blog \'[_1]\' reset by \'[_2]\' (user #[_3])' => '[_2]によりログが初期化されました (ブログ: [_1])',
    "Activity log for blog '[_1]' (ID:[_2]) reset by '[_3]'" => '[_3]がブログ: [_1](ID: [_2])のログを初期化しました。',
    'Application log reset by \'[_1]\' (user #[_2])' => '[_1] (ID: [_2]) によりログが初期化されました',
    "Activity log reset by '[_1]'" => '[_1]がログを初期化しました。',
    'Import/Export' => '読み込み/書き出し',
    'Invalid blog id [_1].' => 'ブログIDの設定に誤りがあります: [_1]',
    'Invalid parameter' => 'パラメータが不正です。',
    'Load failed: [_1]' => '読み込みに失敗しました: [_1]',
    '(no reason given)' => '(原因は不明)',
    'Entries' => 'エントリー',
    '(untitled)' => '(タイトルなし)',
    'Templates' => 'テンプレート',
    'Settings' => '設定',
    'General Settings' => '基本の設定',
    'Feedback Settings' => 'コメント/トラックバックの受信設定',
    'New Entry Default Settings' => '新規投稿の設定',
    'Publishing Settings' => '公開の設定',
    'Plugin Settings' => 'プラグインの設定',
    'None' => 'なし',
    'Edit Comment' => 'コメントを編集',
    'Authenticated Commenters' => '認証サービスで認証されたコメント投稿者',
    'Commenter Details' => 'コメント投稿者について',
    'comments' => 'コメント',
    'New Entry' => '新規エントリー',
    'Create template requires type' => 'テンプレートを作成する際は、テンプレートの種類を指定してください。',
    'New Template' => '新規テンプレート',
    'New Weblog' => '新規ブログ',
    'Select' => '選択',
    'Create New Author' => '投稿者を新規登録',
    'Author requires username' => 'ログイン名が入力されていません。',
    'Author requires password' => 'パスワードが入力されていません。',
    'Author requires password recovery word/phrase' => 'パスワード再設定用のフレーズが入力されていません',
    'Email Address is required for password recovery' => 'メールアドレスは、パスワードを再設定するために必要です。',
    'The value you entered was not a valid email address' => '送信可能なメールアドレスを入力してください。',
    'The e-mail address you entered is already on the Notification List for this weblog.' => 'メールアドレスはすでに通知リストに登録されています。',
    'You did not enter an IP address to ban.' => '禁止IPアドレスの編集はできません。',
    'The IP you entered is already banned for this weblog.' => 'すでに禁止IPアドレスリストに登録されています。',
    'You did not specify a weblog name.' => 'ブログの名称を設定してください。',
    'Site URL must be an absolute URL.' => 'サイトURLには、絶対URLを入力してください。',
    'Archive URL must be an absolute URL.' => 'アーカイブURLには絶対URLしか指定できません。',
    'The name \'[_1]\' is too long!' => '「[_1]」は、指定の長さを超えています。',
    'Category \'[_1]\' created by \'[_2]\' (user #[_3])' => '[_2]（ID:[_3]）がカテゴリー「[_1]」を作成しました。',
    "Category '[_1]' created by '[_2]'" => '[_2]がカテゴリー「[_1]」を作成しました。',
    "The category label '[_1]' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names." => 'カテゴリー名[_1]は他のカテゴリー名と同じです。同じレベルに同じ名前のカテゴリーを作成できません。',
    'Saving permissions failed: [_1]' => '権限の保存に失敗しました: [_1]',
    'Can\'t find default template list; where is \'default-templates.pl\'?' => 'デフォルト・テンプレートの一覧default-tempaltes.plが見つかりません。',
    'Populating blog with default templates failed: [_1]' => 'デフォルト・テンプレートの設定に失敗しました: [_1]',
    'Setting up mappings failed: [_1]' => 'テンプレート・マッピングの設定に失敗しました: [_1]',
    'Weblog \'[_1]\' created by \'[_2]\' (user #[_3])' => '[_2] (ID: [_3]) がブログを作成しました: [_1]',
    "Weblog '[_1]' (ID:[_2]) created by '[_3]'" => '[_3]がブログ「[_1]」(ID: [_2])を作成しました。',
    "Author '[_1]' created by '[_2]' (user #[_3])" => '[_2]（ID:[_3]）が投稿者「[_1]」を作成しました。',
    "User '[_1]' (ID:[_2]) created by '[_3]'" => '[_3]がユーザー「[_1]」(ID: [_2])を作成しました。',
    "Template '[_1]' created by '[_2]' (user #[_3])" => '[_2]（ID:[_3]）がテンプレート「[_1]」を作成しました。',
    "Template '[_1]' (ID:[_2]) created by '[_3]'" => '[_3]がテンプレート「[_1]」(ID: [_2])を作成しました。',
    'You cannot delete your own author record.' => '自分自身の投稿者情報を削除することはできません。',
    'You have no permission to delete the author [_1].' => '投稿者「_1」を削除する権限がありません。',
    'Weblog \'[_1]\' deleted by \'[_2]\' (user #[_3])' => '[_2] (ID: [_3]) がブログを削除しました: [_1]',
    "Weblog '[_1]' (ID:[_2]) deleted by '[_3]'" => '[_3]がブログ「[_1]」(ID: [_2])を削除しました。',
    'Notification \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => '[_3](ID: [_4])が通知先を削除しました: [_1]',
    "Subscriber '[_1]' (ID:[_2]) deleted from notification list by '[_3]'" => '[_3]が通知先「[_1]」(ID: [_2])を削除しました。',
    'Author \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => '[_3](ID: [_4])が投稿者を削除しました: [_1]',
    "User '[_1]' (ID:[_2]) deleted by '[_3]'" => '[_3]がユーザー「[_1]」(ID: [_2])を削除しました。',
    'Category \'[_1]\' (category #[_2]) deleted by \'[_3]\' (user #[_4])' => '[_3](ID: [_4])がカテゴリーを削除しました: [_1]',
    "Category '[_1]' (ID:[_2]) deleted by '[_3]'" => '[_3]がカテゴリー「[_1]」(ID: [_2])を削除しました。',
    'Comment \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4]) from entry \'[_5]\' (entry #[_6])' => '[_3](ID: [_4])がコメントを削除しました: [_1]',
    "Comment (ID:[_1]) by '[_2]' deleted by '[_3]' from entry '[_4]'" => '[_3]がエントリー「[_4]」に[_2]が投稿したコメント(ID: [_1])を削除しました。',
    'Entry \'[_1]\' (entry #[_2]) deleted by \'[_3]\' (user #[_4])' => '[_3](ID: [_4])がエントリーを削除しました: [_1](ID:[_2])',
    "Entry '[_1]' (ID:[_2]) deleted by '[_3]'" => '[_3]がエントリー「[_1]」(ID: [_2])を削除しました。',
    '(Unlabeled category)' => '(ラベルのないカテゴリー)',
    'Ping \'[_1]\' (ping #[_2]) deleted by \'[_3]\' (user #[_4])' => '[_3](ID: [_4])がトラックバックを削除しました: [_1]',
    "Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from category '[_4]'" => '[_3]が「[_1]」からのトラックバック(ID: [_2])をカテゴリー「[_4]」から削除しました。',
    '(Untitled entry)' => '(タイトルのないエントリー)',
    "Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from entry '[_4]'" => '[_3]が「[_1]」からのトラックバック(ID: [_2])をエントリー「[_4]」から削除しました。',
    'Template \'[_1]\' (#[_2]) deleted by \'[_3]\' (user #[_4])' => '[_3](ID: [_4])がテンプレートを削除しました: [_1]',
    "Template '[_1]' (ID:[_2]) deleted by '[_3]'" => '[_3]がテンプレート「[_1]」(ID: [_2])を削除しました。',
    'Tags \'[_1]\' (tags #[_2]) deleted by \'[_3]\' (user #[_4])' => '[_3](ID: [_4])がタグを削除しました: [_1]',
    "Tag '[_1]' (ID:[_2]) deleted by '[_3]'" => '[_3]がタグ「[_1]」(ID: [_2])を削除しました。',
    'Passwords do not match.' => '入力したパスワードが一致しません。',
    'Failed to verify current password.' => '現在のパスワードを確認できません。',
    'Password recovery word/phrase is required.' => 'パスワード再設定用のフレーズを入力してください。',
    'System templates can not be deleted.' => 'システム・テンプレートは削除できません。',
    'An author by that name already exists.' => '投稿者はすでに登録されています。',
    'Save failed: [_1]' => '保存に失敗しました: [_1]',
    'Saving object failed: [_1]' => 'オブジェクトの保存に失敗しました: [_1]',
    'No Name' => '名前がありません',
    'Notification List' => '通知リスト',
    'email addresses' => 'メールアドレス',
    'templates' => 'テンプレート',
    'IP Banning' => '禁止IPアドレス',
    'IP addresses' => 'IPアドレス',
    'Can\'t delete that way' => 'この方法では削除できません',
    'Your login session has expired.' => 'ログアウトしました。',
    'You can\'t delete that category because it has sub-categories. Move or delete the sub-categories first if you want to delete this one.' => 'そのカテゴリーを削除するには、まず、付属しているサブカテゴリーを移動するか、削除してください。',
    'Unknown object type [_1]' => 'このオブジェクト「[_1]」には対応していません',
    'Loading object driver [_1] failed: [_2]' => 'オブジェクト・ドライバー[_1]の読み込みに失敗しました: [_2]',
    'Reading \'[_1]\' failed: [_2]' => '[_1]の読み込みに失敗しました。',
    'Thumbnail failed: [_1]' => 'サムネイルの作成に失敗しました: [_1]',
    'Error writing to \'[_1]\': [_2]' => '「[_1]」への書き込みができません: [_2]',
    'Invalid basename \'[_1]\'' => 'エントリーのファイル名が正しくありません: [_1]',
    'No such commenter [_1].' => '「[_1]」というコメント投稿者は存在しません',
    'User \'[_1]\' (#[_2]) trusted commenter \'[_3]\' (#[_4]).' => 'ユーザー「[_1] (ID: [_2])」がコメント投稿者「[_3] (ID: [_4])」を登録しました。',
    "User '[_1]' trusted commenter '[_2]'." => 'ユーザー「[_1]」がコメント投稿者[_2]を登録しました。',
    'User \'[_1]\' (#[_2]) banned commenter \'[_3]\' (#[_4]).' => 'ユーザー「[_1] (ID: [_2])」がコメント投稿者「[_3] (ID: [_4])」を禁止しました。',
    "User '[_1]' banned commenter '[_2]'." => 'ユーザー「[_1]」がコメント投稿者[_2]の投稿を禁止しました。',
    'User \'[_1]\' (#[_2]) unbanned commenter \'[_3]\' (#[_4]).' => 'ユーザー「[_1] (ID: [_2])」がコメント投稿者「[_3] (ID: [_4])」の禁止を解除しました。',
    "User '[_1]' unbanned commenter '[_2]'." => 'ユーザー「[_1]」がコメント投稿者[_2]の投稿禁止を解除しました。',
    'User \'[_1]\' (#[_2]) untrusted commenter \'[_3]\' (#[_4]).' => 'ユーザー「[_1] (ID: [_2])」がコメント投稿者「[_3] (ID: [_4])」の登録を解除しました。',
    "User '[_1]' untrusted commenter '[_2]'." => 'ユーザー「[_1]」がコメント投稿者[_2]の登録を解除しました。',
    'Need a status to update entries' => 'エントリーを更新するのに状態が必要です。',
    'Need entries to update status' => '状態を更新するのにエントリーが必要です。',
    'One of the entries ([_1]) did not actually exist' => 'エントリー「[_1])」が見つかりません。',
    'Some entries failed to save' => '保存できなかったエントリーがあります。',
    'You don\'t have permission to approve this TrackBack.' => 'トラックバックを承認する権限がありません。',
    'Comment on missing entry!' => '削除されたエントリーへのコメント投稿です。',
    'You don\'t have permission to approve this comment.' => 'コメントを承認する権限がありません。',
    'commenters' => 'コメント投稿者',
    'Commenters' => 'コメント投稿者',
    'Comment Activity Feed' => 'コメント・ログ・フィード',
    'Orphaned comment' => 'コメントに関するエントリーがありません',
    'Plugins' => 'プラグイン',
    'Plugin Set: [_1]' => 'プラグイン: [_1]',
    'TrackBack Activity Feed' => 'トラックバック・ログ',
    'No Excerpt' => '概要がありません',
    'No Title' => 'タイトルがありません',
    'Orphaned TrackBack' => 'トラックバックに関するエントリーがありません',
    'entry' => 'エントリー',
    'category' => 'カテゴリー',
    'Category' => 'カテゴリー',
    'Tag' => 'タグ',
    'Author' => '投稿者',
    'Post Status' => '公開設定',
    'entries' => 'エントリー',
    'Entry Activity Feed' => 'エントリー・ログ・フィード',
    'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => '日付[_1]の形式が正しくありません。日付は YYYY-MM-DD HH: MM: SS の形式で設定してください。',
    'Invalid date \'[_1]\'; authored on dates should be real dates.' => '日付 ([_1]) が正しくありません。存在しない日付が設定されています。',
    'Saving entry \'[_1]\' failed: [_2]' => 'エントリー「[_1]」の保存に失敗しました: [_2]',
    'Removing placement failed: [_1]' => 'エントリーとブログの関連づけの削除に失敗しました: [_1]',
    'No such entry.' => 'エントリーが見つかりません。',
    'Your weblog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'サイト・パスとURLを設定しないと、エントリーを公開できません。',
    'Edit Categories' => 'カテゴリーを編集',
    'The category must be given a name!' => 'カテゴリーの名称を設定してください。',
    'yyyy/mm/entry_basename' => 'yyyy/mm/entry_basename',
    'yyyy/mm/entry-basename' => 'yyyy/mm/entry-basename',
    'yyyy/mm/entry_basename/' => 'yyyy/mm/entry_basename/',
    'yyyy/mm/entry-basename/' => 'yyyy/mm/entry-basename/',
    'yyyy/mm/dd/entry_basename' => 'yyyy/mm/dd/entry_basename',
    'yyyy/mm/dd/entry-basename' => 'yyyy/mm/dd/entry-basename',
    'yyyy/mm/dd/entry_basename/' => 'yyyy/mm/dd/entry_basename/',
    'yyyy/mm/dd/entry-basename/' => 'yyyy/mm/dd/entry-basename/',
    'category/sub_category/entry_basename' => 'category/sub_category/entry_basename',
    'category/sub_category/entry_basename/' => 'category/sub_category/entry_basename/',
    'category/sub-category/entry_basename' => 'category/sub-category/entry_basename',
    'category/sub-category/entry-basename' => 'category/sub-category/entry-basename',
    'category/sub-category/entry_basename/' => 'category/sub-category/entry_basename/',
    'category/sub-category/entry-basename/' => 'category/sub-category/entry-basename/',
    'primary_category/entry_basename' => 'primary_category/entry_basename',
    'primary_category/entry_basename/' => 'primary_category/entry_basename/',
    'primary-category/entry_basename' => 'primary-category/entry_basename',
    'primary-category/entry-basename' => 'primary-category/entry-basename',
    'primary-category/entry_basename/' => 'primary-category/entry_basename/',
    'primary-category/entry-basename/' => 'primary-category/entry-basename/',
    'yyyy/mm/' => 'yyyy/mm/',
    'yyyy_mm' => 'yyyy_mm',
    'yyyy/mm/dd/' => 'yyyy/mm/dd/',
    'yyyy_mm_dd' => 'yyyy_mm_dd',
    'yyyy/mm/dd-week/' => 'yyyy/mm/dd-week/',
    'week_yyyy_mm_dd' => 'week_yyyy_mm_dd',
    'category/sub_category/' => 'category/sub_category/',
    'category/sub-category/' => 'category/sub-category/',
    'cat_category' => 'cat_category',
    'Saving blog failed: [_1]' => 'ブログの保存に失敗しました: [_1]',
    'You do not have permission to configure the blog' => 'ブログの設定に関する権限がありません。',
    'Saving map failed: [_1]' => 'マップの保存に失敗しました: [_1]',
    'Parse error: [_1]' => '解析エラー: [_1]',
    'Build error: [_1]' => '再構築エラー: [_1]',
    'Rebuild-option name must not contain special characters' => '再構築のオプションに、特殊文字が含まれています。',
    'Rebuild Site' => 'サイトを再構築',
    'index template \'[_1]\'' => 'インデックス・テンプレート「[_1]」',
    'entry \'[_1]\'' => 'エントリー・アーカイブ「[_1]」',
    'Ping \'[_1]\' failed: [_2]' => '「[_1]」へのトラックバックは失敗しました: [_2]',
    'You cannot modify your own permissions.' => '現在の権限を変更できません。',
    'You are not allowed to edit the permissions of this author.' => '投稿者の権限を変更できません。',
    'Edit Permissions' => '権限を変更',
    'Edit Profile' => 'プロフィールを編集',
    'No entry ID provided' => '指定したエントリーIDのエントリーが見つかりません。',
    'No such entry \'[_1]\'' => '「[_1]」というエントリーはありません',
    'No email address for author \'[_1]\'' => '投稿者「[_1]」にはメールアドレスが設定されていません',
    'No valid recipients found for the entry notification.' => 'エントリの通知先がありません。',
    '[_1] Update: [_2]' => '[_1]更新: [_2]',
    'Error sending mail ([_1]); try another MailTransfer setting?' => 'メール送信のエラー ([_1]) が発生しました。別の設定でも確認してください。',
    'Archive Root' => 'アーカイブ・パス',
    'Site Root' => 'サイト・パス',
    'You did not choose a file to upload.' => 'アップロードするファイルが選択されていません。',
    'Invalid extra path \'[_1]\'' => 'ファイルのパス名が正しくありません: [_1]',
    'Can\'t make path \'[_1]\': [_2]' => 'パス[_1]を作成できません: [_2]',
    'Invalid temp file name \'[_1]\'' => '一時ファイル名が正しくありません: [_1]',
    'Error opening \'[_1]\': [_2]' => '[_1]を開けません: [_2]',
    'Error deleting \'[_1]\': [_2]' => '「[_1]」を削除できません: [_2]',
    'File with name \'[_1]\' already exists. (Install File::Temp if you\'d like to be able to overwrite existing uploaded files.)' => 'ファイル名[_1]はすでに存在しています。(ファイルを上書きする場合は、事前にFile::Tempをインストールしてください)',
    'Error creating temporary file; please check your TempDir setting in mt.cfg (currently \'[_1]\') this location should be writable.' => 'テンポラリーファイルを作成できません。環境設定ファイルのTempDirの設定値 (現在の設定は[_1]) を確認してください。また、設定したディレクトリが書き込み可能か確認してください。',
    'unassigned' => '未設定',
    'File with name \'[_1]\' already exists; Tried to write to tempfile, but open failed: [_2]' => '[_1]という名称のファイルはすでに存在しています。テンポラリーファイルに書き込みに失敗しました. [_2]',
    'Error writing upload to \'[_1]\': [_2]' => '「[_1]」へのアップロードができません: [_2]',
    'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Image::Sizeは、画像のサイズを調べるために必要です。',
    'Invalid date(s) specified for date range.' => '日付範囲の設定に誤りがあります。',
    'Error in search expression: [_1]' => '検索でエラーが発生しました:[_1]',
    'Saving object failed: [_2]' => 'オブジェクトの保存に失敗しました: [_1]',
    'Search & Replace' => '検索・置換',
    'No blog ID' => 'ブログIDがありません',
    'You do not have export permissions' => '書き出しに関する権限がありません。',
    'You do not have import permissions' => '読み込みに関する権限がありません。',
    'You do not have permission to create authors' => '投稿者を作成する権限がありません。',
    "You need to provide a password if you are going to\ncreate new authors for each author listed in your blog.\n" => 'ブログに各投稿者を追加するためには、パスワードを指定する必要があります。\n',
    'Preferences' => '設定',
    'Add a Category' => 'カテゴリーを追加する',
    'No label' => 'カテゴリーが見つかりません。',
    'Category name cannot be blank.' => 'カテゴリー名を設定してください。',
    'That action ([_1]) is apparently not implemented!' => 'この操作 ([_1]) は、現在実装されていません。',
    'Permission denied' => '権限がありません。',
    'Error saving entry: [_1]' => 'エントリーの保存中にエラーが発生しました: [_1]',
    '_WARNING_PASSWORD_RESET_MULTI' => '選択された投稿者のパスワードを再設定しようとしています。パスワードはランダムに生成され、直接それぞれのメールアドレスに送られます。\n\n実行しますか？',
    '_SYSTEM_TEMPLATE_COMMENTS' => 'コメントの投稿で、ポップアップ・ウィンドウを使うように設定したときの表示レイアウトです。',
    '_SYSTEM_TEMPLATE_COMMENT_ERROR' => 'コメントの投稿で、エラーが発生したときに表示します。',
    '_SYSTEM_TEMPLATE_COMMENT_PENDING' => '投稿したコメントが、保留されたり、迷惑コメントと判断されたときに表示します。',
    '_SYSTEM_TEMPLATE_COMMENT_PREVIEW' => 'コメントの投稿で、内容を確認したいときに表示します。',
    '_SYSTEM_TEMPLATE_DYNAMIC_ERROR' => 'ダイナミック・ページの出力で、エラーが発生したときに表示します。',
    '_SYSTEM_TEMPLATE_PINGS' => '特定のエントリーに送られたトラックバックの一覧を表示するときのレイアウトです。',
    '_SYSTEM_TEMPLATE_POPUP_IMAGE' => '画像をポップアップ・ウィンドウで表示するときのレイアウトです。',
    '_SYSTEM_TEMPLATE_SEARCH_TEMPLATE' => 'ブログを検索するときに表示します。',
    "Invalid username '[_1]' in password recovery attempt" => '登録されていないユーザー名([_1])のパスワードを再設定しようとしました。',
    'Username or password recovery phrase is incorrect.' => 'ユーザー名またはパスワード再設定用のフレーズが誤っています。',
    "Password recovery for user '[_1]' failed due to lack of recovery phrase specified in profile." => 'ユーザー([_1])のパスワード再設定は、再設定用のフレーズが登録されていないため失敗しました。',
    'No password recovery phrase set in user profile. Please see your system administrator for password recovery.' => 'パスワード再設定用のフレーズが登録されていません。システム管理者に相談してください。',
    "Invalid attempt to recover password (used recovery phrase '[_1]')" => 'パスワードの再設定処理が不正に呼び出されました（再設定用のフレーズ: [_1]）。',
    'Username or password recovery phrase is incorrect.' => 'ユーザー名またはパスワード再設定用のフレーズが誤っています。',
    "Password recovery for user '[_1]' failed due to lack of email specified in profile." => 'ユーザー([_1])のパスワード再設定に失敗しました。メールアドレスが登録されていません。',
    'No email specified in user profile.  Please see your system administrator for password recovery.' => 'メールアドレスが登録されていません。システム管理者に相談してください。',

    ## lib/MT/App/Search.pm
    'You are currently performing a search. Please wait until your search is completed.' => '現在検索中です。検索が終わるまでお待ちください。',
    'Search failed. Invalid pattern given: [_1]' => '検索できませんでした。無効なパターンが使用されています: [_1]',
    'Search failed: [_1]' => '検索に失敗しました: [_1]',
    'No alternate template is specified for the Template \'[_1]\'' => '代替のテンプレートが指定されていません: [_1]',
    'Opening local file \'[_1]\' failed: [_2]' => 'ローカル・ファイル[_1]が開けません: [_2]',
    'Building results failed: [_1]' => '結果の表示ができません: [_1]',
    'Search: query for \'[_1]\'' => '「[_1]」を検索',
    'Search: new comment search' => 'コメントの検索',
    'Edit' => '編集',
    ## lib/MT/App/Comments.pm
    'No id' => 'IDが見つかりません。',
    'No such comment' => 'コメントが見つかりません。',
    'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => 'IPアドレス[_1]は、[_2]秒以内に8件以上のコメントが投稿されたので、禁止します。',
    'IP Banned Due to Excessive Comments' => '大量のコメントのため、この IPアドレスからのコメントの受け付けを禁止しています。',
    '_THROTTLED_COMMENT_EMAIL' => 'ブログ「[_1]」へのコメントが指定された[_2]秒間に複数回行われたため、自動的にそのIPアドレスを禁止IPアドレスリストに追加しました。[_3]がその IPアドレスです。必要であれば、このIPアドレス[_4]を一覧から取り除いてください。',
    'Invalid request' => '不正なリクエストです。',
    'No such entry \'[_1]\'.' => '「[_1]」というエントリーはありません',
    'You are not allowed to post comments.' => 'IPアドレス制限のため、コメント投稿が許されていません。',
    '_THROTTLED_COMMENT' => '不必要なコメントの投稿を防ぐために、連続した投稿を受け付けないように設定しています。しばらくしてから、もう一度試してみてください。',
    'Comments are not allowed on this entry.' => 'このエントリーにコメントはできません。',
    'Comment text is required.' => 'コメントの本文を入力してください。',
    'Registration is required.' => 'コメントを行うためには登録が必要です。',
    'Name and email address are required.' => '名前とメールアドレスの入力は必須です。',
    'Invalid email address \'[_1]\'' => 'メールアドレスが正しくありません: [_1]',
    'Comment save failed with [_1]' => 'コメントを保存できません: [_1]',
    'New comment for entry #[_1] \'[_2]\'.' => '「[_2] (ID: [_1] )」への新しいコメント',
    'Comment on "[_1]" by [_2].' => '「[_1]」に[_2]がコメントを投稿しました。',
    'Commenter save failed with [_1]' => 'コメント投稿者を保存できません: [_1]',
    'New Comment Posted to \'[_1]\'' => '「[_1]」に投稿された新しいコメント',
    'The login could not be confirmed because of a database error ([_1])' => 'データベースのエラーが発生し、ログインを確認できません: [_1]',
    'Couldn\'t get public key from url provided' => '指定したURLから公開鍵を取得できません。',
    'No public key could be found to validate registration.' => '公開鍵が取得できません。',
    'TypeKey signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'TypeKey署名の確認機能により、 [_1]が[_2]秒後に戻り、[_3]と[_4]を確認しました。',
    'The TypeKey signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'TypeKeyの署名が[_1] 秒遅れで古いです。サーバーの時刻が正しいかどうか確かめてください。',
    'The sign-in validation failed.' => 'サインインに失敗しました。',
    'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'サインインしたサイトでは、コメントの投稿には、メールアドレスを通知するようにリクエストしています。メールアドレスを通知しない限り、コメントの投稿ができません。通知をするように設定してください。',
    'Couldn\'t save the session' => '現在のセッションを保存できません。',
    'This weblog requires commenters to pass an email address' => 'サインインしたサイトでは、コメントの投稿には、メールアドレスを通知するようにリクエストしています。',
    'Sign in requires a secure signature; logout requires the logout=1 parameter' => '署名が正しくありません。ログアウトのときは「logout=1」のパラメータが必要です。',
    'The sign-in attempt was not successful; please try again.' => 'サインインに失敗しました。もう一度試してください。',
    'The sign-in validation was not successful. Please make sure your weblog is properly configured and try again.' => 'サインインに失敗しました。ブログの設定を確認してから試してください。',
    'No such entry ID \'[_1]\'' => '指定したエントリーID[_1]のエントリーが見つかりません',
    'You must define an Individual template in order to display dynamic comments.' => 'コメントをダイナミックに表示するためには、エントリー・アーカイブ・テンプレートを設定してください。',
    'You must define a Comment Listing template in order to display dynamic comments.' => 'コメントをダイナミックに表示するためには、コメントの一覧のテンプレートを設定してください。',
    'No entry was specified; perhaps there is a template problem?' => 'エントリーが見つかりません。テンプレートに問題がある可能性があります。',
    'Somehow, the entry you tried to comment on does not exist' => 'コメントしようとしたエントリーが見つかりません。',
    'You must define a Comment Pending template.' => 'コメント・保留のテンプレートを設定してください。',
    'You must define a Comment Error template.' => 'コメント・エラーのテンプレートを設定してください。',
    'You must define a Comment Preview template.' => 'コメント・プレビューのテンプレートを設定してください。',
    ## lib/MT/App/Wizard.pm
    'SMTP Server' => 'SMTPサーバー',
    'Sendmail' => 'Sendmail',
    'Test email from Movable Type Configuration Wizard' => 'Movable Type 構成ウィザードからのテストメール',
    'This is the test email sent by your new installation of Movable Type.' => 'これは、Movable Typeのインストール構成中に送信されたメールです。',
    ## lib/MT/App/Upgrader.pm
    'The initial account name is required.' => '初期アカウント名が必要です。',
    'You failed to validate your password.' => '有効なパスワードではありません。',
    'You failed to supply a password.' => 'パスワードが指定されていません。',
    "User '[_1]' upgraded database to version [_2]" => '[_1]がデータベースをアップグレードしました (バージョン: [_2])',
    'Invalid session.' => 'データベースのバージョンに誤りがあります',
    'No permissions. Please contact your administrator for upgrading Movable Type.' => '権限がありません。管理者に連絡し、Movable Typeをアップグレードしてください。',
    ## lib/MT/App/NotifyList.pm
    'Please enter a valid email address.' => 'メールアドレスを正しく入力してください。',
    'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => '「blog_id」の設定に誤りがあります。ユーザー・マニュアルを参考に設定してください。',
    'Email notifications have not been configured! The weblog owner needs to set the EmailVerificationSecret configuration variable in mt.cfg.' => '設定に誤りがあります。環境設定ファイルの「EmailVerificationSecret」の設定を確認してください。',
    'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => '設定に誤りがあります。メール送信の設定を確認してください。',
    'The email address \'[_1]\' is already in the notification list for this weblog.' => 'メールアドレス[_1]はすでに登録されています。',
    'Please verify your email to subscribe' => 'メールアドレスの登録を確認してください',
    '_NOTIFY_REQUIRE_CONFIRMATION' => '確認のメールを[_1]あてに送りました。登録するためには、メールに書かれているURLにアクセスしてください。このメールアドレスがあなたのものかを確認します。',
    'The address [_1] was not subscribed.' => 'メールアドレス[_1]は登録されていません。',
    'The address [_1] has been unsubscribed.' => 'メールアドレス[_1]の登録を解除しました。',
    ## lib/MT/FileMgr/Local.pm
    'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => '[_1]を[_2]に名称を変更できません: [_3]',
    'Deleting \'[_1]\' failed: [_2]' => '[_1]の削除中にエラーが発生しました: [_2]',
    ## lib/MT/FileMgr/FTP.pm
    'Creating path \'[_1]\' failed: [_2]' => '「[_1]」のパスが作成できません: [_2]',
    ## lib/MT/FileMgr/DAV.pm
    'DAV connection failed: [_1]' => 'DAVの接続に失敗しました。',
    'DAV open failed: [_1]' => 'DAVの「open」に失敗しました: [_1]',
    'DAV get failed: [_1]' => 'DAVの「get」に失敗しました: [_1]',
    'DAV put failed: [_1]' => 'DAVの「put」に失敗しました: [_1]',
    ## lib/MT/FileMgr/SFTP.pm
    'SFTP connection failed: [_1]' => 'SFTP接続に失敗しました: [_1]',
    'SFTP get failed: [_1]' => 'SFTPの「get」に失敗しました: [_1]',
    'SFTP put failed: [_1]' => 'SFTPの「put」に失敗しました: [_1]',
    ## lib/MT/IPBanList.pm
    ## lib/MT/ObjectDriver/DBM.pm
    'Your DataSource directory (\'[_1]\') does not exist.' => 'データベースを格納するディレクトリ[_1]がありません。',
    'Your DataSource directory (\'[_1]\') is not writable.' => 'データベースを格納するディレクトリ[_1]が書き込み可能ではありません。',
    'Tie \'[_1]\' failed: [_2]' => '「[_1]」を関連づけられません: [_2]',
    'Failed to generate unique ID: [_1]' => '固有のIDを生成できません: [_1]',
    'Unlink of \'[_1]\' failed: [_2]' => '「[_1]」の削除に失敗しました: [_2]',
    ## lib/MT/ObjectDriver/DBI/postgres.pm
    'Connection error: [_1]' => 'エラーが発生しました: [_1]',
    ## lib/MT/ObjectDriver/DBI/mysql.pm
    'undefined type: [_1]' => '未定義の種類です: [_1]',
    ## lib/MT/ObjectDriver/DBI/sqlite.pm
    'Your database file (\'[_1]\') is not writable.' => 'データベース・ファイル[_1]は、書き込みできません。',
    'Your database directory (\'[_1]\') is not writable.' => 'データベース・ディレクトリ[_1]は、書き込みできません。',
    ## lib/MT/ObjectDriver/DBI.pm
    'Loading data failed with SQL error [_1]' => 'SQLエラーが発生しました: [_1]',
    'Count [_1] failed on SQL error [_2]' => '「[_1]」でSQLエラーが発生しました: [_2]',
    'Prepare failed' => 'オブジェクト・ドライバーでエラーが発生しました。',
    'Execute failed' => 'エラーが発生しました。',
    'existence test failed on SQL error [_1]' => 'SQLエラーが発生しました: [_1]',
    'Insertion test failed on SQL error [_1]' => 'SQLエラーが発生しました: [_1]',
    'Update failed on SQL error [_1]' => 'アップデート中にSQLエラーが発生しました: [_1]',
    'No such object.' => 'オブジェクトが見つかりません。',
    'Remove failed on SQL error [_1]' => 'SQLエラーが発生しました: [_1]',
    'Remove-all failed on SQL error [_1]' => 'SQLエラーが発生しました: [_1]',
    ## lib/MT/TemplateMap.pm
    ## lib/MT/Image.pm
    'Can\'t load Image::Magick: [_1]' => 'Image::Magickを利用できません: [_1]',
    'Reading file \'[_1]\' failed: [_2]' => 'ファイル[_1]の読み込みに失敗しました: [_2]',
    'Reading image failed: [_1]' => '画像の読み込みに失敗しました: [_1]',
    'Scaling to [_1]x[_2] failed: [_3]' => '[_1]x[_2]へのサイズ調整に失敗しました: [_3]',
    'Can\'t load IPC::Run: [_1]' => 'IPC::Runを利用できません: [_1]',
    'You do not have a valid path to the NetPBM tools on your machine.' => 'あなたのマシンには、NetPBMツールへのパスがありません。',
    ## lib/MT/I18N.pm
    'AUTO DETECT' => '自動認識',
    ## lib/MT/Session.pm
    ## lib/MT/FileMgr.pm
    ## lib/MT.pm.pre
    'Powered by [_1]' => 'Powered by [_1]',
    'Version [_1]' => 'バージョン: [_1]',
    'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.jp/movabletype/',
    'Hello, world' => 'Hello, world',
    'Hello, [_1]' => 'こんにちは、[_1]さん',
    'Message: [_1]' => 'メッセージ: [_1]',
    'If present, 3rd argument to add_callback must be an object of type MT::Plugin' => 'add_callback関数の3番目の引数は、MT::Pluginオブジェクトである必要があります。',
    '4th argument to add_callback must be a CODE reference.' => 'add_callback関数の4番目の引数は、CODEである必要があります。',
    'Two plugins are in conflict' => '2つのプラグインで矛盾が発生しています。',
    'Invalid priority level [_1] at add_callback' => 'add_callback関数でプライオリティの設定に誤りがあります: [_1]',
    'Unnamed plugin' => 'プラグイン名がありません',
    '[_1] died with: [_2]' => '「[_1]」は、次の理由で使えません: [_2]',
    'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => '環境設定ファイル (mt-config.cgi) が見つかりません。mt-config.cgi-originalからmt-config.cgiを作成していないかもしれません。',
    'Bad ObjectDriver config' => 'データベース接続の設定に誤りがあります。設定を確認してください。',
    'Bad ObjectDriver config: [_1] ' => 'データベース接続の設定に誤りがあります: [_1]',
    'Bad CGIPath config' => 'CGIPathの設定に誤りがあります。設定を確認してください。',
    'Plugin error: [_1] [_2]' => 'プラグイン「[_1]」でエラーが発生しました: [_2]',
    'No executable code' => 'テキスト・フォーマッティングでエラーが発生しました。',
    'An error occurred: [_1]' => 'エラーが発生しました: [_1]',
    ## mt-static/js/tc/client.js
    ## mt-static/js/tc/mixer/tagmatch.js
    ## mt-static/js/tc/mixer/display.js
    ## mt-static/js/tc/tagcomplete.js
    ## mt-static/js/tc/json.js
    ## mt-static/js/tc/mixer.js
    ## mt-static/js/tc/alert.js
    ## mt-static/js/tc/spellcheck.js
    ## mt-static/js/tc/wordselect.js
    ## mt-static/js/tc/tableselect.js
    ## mt-static/js/tc/colorpicker.js
    ## mt-static/js/tc/autocomplete.js
    ## mt-static/js/tc/cookie.js
    ## mt-static/js/tc/gestalt.js
    ## mt-static/js/tc/preview.js
    ## mt-static/js/tc/focus.js
    ## mt-static/js/tc/window.js
    ## mt-static/js/tc/frankencode.js
    ## mt-static/js/tc/benchmark.js
    ## mt-static/js/tc.js
    ## mt-static/mt.js
    'You did not select any [_1] to delete.' => '削除する[_1]が選択されていません。',
    "Deleting an author is an irrevocable action which creates orphans of the author's entries.  If you wish to retire an author or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete this author?" => '投稿者を削除すると、その投稿者の書いたエントリは投稿者不明となり、後で取り消せません。投稿者を無効化したい場合は、権限を削除するのが正しい方法です。本当に投稿者を削除してもよろしいですか？',
    "Deleting an author is an irrevocable action which creates orphans of the author's entries.  If you wish to retire an author or remove their access to the system, removing all of their permissions is the recommended course of action.  Are you sure you want to delete the [_1] selected authors?" => '投稿者を削除すると、その投稿者の書いたエントリは投稿者不明となり、後で取り消せません。投稿者を無効化したい場合は、権限を削除するのが正しい方法です。本当に[_1]人の投稿者を削除してもよろしいですか？',
    'Are you sure you want to delete this [_1]?' => '[_1]を削除してよろしいですか?',
    'Are you sure you want to delete the [_1] selected [_2]?' => '[_1]件の[_2]を削除してよろしいですか?',
    'to delete' => '削除',
    'You did not select any [_1] [_2].' => '[_2]する[_1]が選択されていません。',
    'You must select an action.' => 'プルダウン・メニューから選択してください。',
    'to mark as junk' => '迷惑コメント/トラックバックとして設定',
    'to remove "junk" status' => '迷惑コメント/トラックバックから解除',
    'Enter email address:' => 'メールアドレスを入力してください: ',
    'Enter URL:' => 'URLを入力してください: ',
    '_BLOG_CONFIG_MODE_BASIC' => '基本モード',
    '_BLOG_CONFIG_MODE_DETAIL' => '詳細モード',
    ## mt-static/plugins/WidgetManager/js/app.js
    ## php/lib/function.MTGetVar.php
    ## php/lib/block.MTArchivePrevious.php
    ## php/lib/block.MTBlogIfCommentsOpen.php
    ## php/lib/function.MTBlogEntryCount.php
    ## php/lib/modifier.strip_linefeeds.php
    ## php/lib/function.MTCommentAuthorLink.php
    ## php/lib/function.MTEntryCommentCount.php
    ## php/lib/block.MTIfRequireCommentEmails.php
    ## php/lib/function.MTCommentEmail.php
    ## php/lib/block.MTIfCommentsAccepted.php
    ## php/lib/function.MTArchiveCategory.php
    ## php/lib/block.MTEntryIfTagged.php
    ## php/lib/block.MTIfIsDescendant.php
    ## php/lib/modifier.zero_pad.php
    ## php/lib/function.MTArchiveTitle.php
    ## php/lib/block.MTCalendarWeekFooter.php
    ## php/lib/block.MTIfPingsAccepted.php
    ## php/lib/function.MTCommenterEmail.php
    ## php/lib/modifier.dirify.php
    ## php/lib/function.MTHTTPContentType.php
    ## php/lib/function.MTArchiveDateEnd.php
    ## php/lib/function.MTCommentAuthor.php
    ## php/lib/function.MTPingBlogName.php
    ## php/lib/block.MTIfCategory.php
    ## php/lib/block.MTEntryCategories.php
    ## php/lib/function.MTSearchScript.php
    ## php/lib/block.MTEntryIfAllowComments.php
    ## php/lib/block.MTHasNoParentCategory.php
    ## php/lib/block.MTIfRegistrationNotRequired.php
    ## php/lib/function.MTCommentDate.php
    ## php/lib/function.MTTagSearchLink.php
    ## php/lib/l10n_ja.php
    ## php/lib/block.MTIfRegistrationRequired.php
    ## php/lib/block.MTParentCategories.php
    ## php/lib/function.MTCGIPath.php
    ## php/lib/function.MTImageWidth.php
    ## php/lib/function.MTCommentName.php
    ## php/lib/function.MTBlogPingCount.php
    ## php/lib/modifier.decode_html.php
    ## php/lib/function.MTCommentBody.php
    ## php/lib/function.MTCategoryTrackbackCount.php
    ## php/lib/block.MTHasParentCategory.php
    ## php/lib/function.MTPingExcerpt.php
    ## php/lib/block.MTSubCatIsFirst.php
    ## php/lib/block.MTSubCategories.php
    ## php/lib/function.MTEntryAuthorUsername.php
    ## php/lib/mtdb_mysql.php
    ## php/lib/function.MTTagID.php
    ## php/lib/function.MTCCLicenseRDF.php
    ## php/lib/function.MTEntryCategory.php
    ## php/lib/block.MTCommentsFooter.php
    ## php/lib/function.MTBlogTimezone.php
    ## php/lib/function.MTPingDate.php
    ## php/lib/block.MTEntryIfCategory.php
    ## php/lib/function.MTCommenterNameThunk.php
    ## php/lib/function.MTEntryAuthorEmail.php
    ## php/lib/block.MTPings.php
    ## php/lib/function.MTEntryTrackbackID.php
    ## php/lib/function.MTPublishCharset.php
    ## php/lib/modifier.encode_js.php
    ## php/lib/block.MTHasNoSubCategories.php
    ## php/lib/block.MTIfDynamic.php
    ## php/lib/block.MTIfPingsModerated.php
    ## php/lib/MTViewer.php
    ## php/lib/function.MTCategoryCount.php
    ## php/lib/block.MTCommentsHeader.php
    ## php/lib/modifier.filters.php
    ## php/lib/function.MTBlogCommentCount.php
    ## php/lib/modifier.words.php
    ## php/lib/function.MTFileTemplate.php
    ## php/lib/prefilter.mt_to_smarty.php
    ## php/lib/function.MTPingID.php
    ## php/lib/function.MTCommentScript.php
    ## php/lib/block.MTSetVarBlock.php
    ## php/lib/function.MTEntryMore.php
    ## php/lib/function.MTFeedbackScore.php
    ## php/lib/l10n_en.php
    ## php/lib/function.MTDate.php
    ## php/lib/block.MTIfRegistrationAllowed.php
    ## php/lib/modifier.trim_to.php
    ## php/lib/function.MTBlogHost.php
    ## php/lib/function.MTInclude.php
    ## php/lib/block.MTEntriesHeader.php
    ## php/lib/function.MTBlogCCLicenseImage.php
    ## php/lib/modifier.convert_breaks.php
    ## php/lib/function.MTEntryAuthorNickname.php
    ## php/lib/block.MTEntriesFooter.php
    ## php/lib/function.MTArchiveFile.php
    ## php/lib/modifier.upper_case.php
    ## php/lib/block.MTArchiveListHeader.php
    ## php/lib/function.MTCalendarDate.php
    ## php/lib/MTSerialize.php
    ## php/lib/block.MTCategoryIfAllowPings.php
    ## php/lib/function.MTEntriesCount.php
    ## php/lib/function.MTRemoteSignInLink.php
    ## php/lib/modifier.spam_protect.php
    ## php/lib/archive_lib.php
    ## php/lib/block.MTPingsFooter.php
    ## php/lib/function.MTEntryID.php
    ## php/lib/function.MTEntryAuthorURL.php
    ## php/lib/function.MTSetVar.php
    ## php/lib/function.MTEntryBody.php
    ## php/lib/function.MTRemoteSignOutLink.php
    ## php/lib/function.MTIndexLink.php
    ## php/lib/function.MTBlogDescription.php
    ## php/lib/block.MTCalendarIfToday.php
    ## php/lib/modifier.encode_html.php
    ## php/lib/block.MTArchiveList.php
    ## php/lib/function.MTAdminScript.php
    ## php/lib/function.MTCommentFields.php
    ## php/lib/block.MTBlogIfCCLicense.php
    ## php/lib/block.MTArchives.php
    ## php/lib/block.MTIfCommenterTrusted.php
    ## php/lib/function.MTBlogLanguage.php
    ## php/lib/function.MTArchiveType.php
    ## php/lib/block.MTCategoryNext.php
    ## php/lib/mtdb_postgres.php
    ## php/lib/MTUtil.php
    ## php/lib/function.MTTagCount.php
    ## php/lib/function.MTTrackbackScript.php
    ## php/lib/function.MTEntryKeywords.php
    ## php/lib/block.MTArchiveListFooter.php
    ## php/lib/block.MTDateHeader.php
    ## php/lib/function.MTErrorMessage.php
    ## php/lib/function.MTBlogSitePath.php
    ## php/lib/function.MTCategoryBasename.php
    ## php/lib/function.MTEntryTitle.php
    ## php/lib/function.MTEntryStatus.php
    ## php/lib/function.MTBlogCCLicenseURL.php
    ## php/lib/function.MTArchiveLink.php
    ## php/lib/function.MTCommentAuthorIdentity.php
    ## php/lib/compiler.defun.php
    ## php/lib/block.MTIfCommentsAllowed.php
    ## php/lib/function.MTImageHeight.php
    ## php/lib/function.MTEntryModifiedDate.php
    ## php/lib/block.MTEntriesWithSubCategories.php
    ## php/lib/block.MTCategories.php
    ## php/lib/function.MTCategoryTrackbackLink.php
    ## php/lib/function.MTEntryTrackbackLink.php
    ## php/lib/function.MTCategoryLabel.php
    ## php/lib/block.MTEntryIfAllowPings.php
    ## php/lib/function.MTAtomScript.php
    ## php/lib/block.MTCalendarWeekHeader.php
    ## php/lib/block.MTTopLevelParent.php
    ## php/lib/block.MTPingsHeader.php
    ## php/lib/block.MTCategoryPrevious.php
    ## php/lib/block.MTPingsSent.php
    ## php/lib/function.MTBlogURL.php
    ## php/lib/function.MTCommentURL.php
    ## php/lib/block.MTEntryPrevious.php
    ## php/lib/function.MTCommentIP.php
    ## php/lib/function.MTHTTPErrorCode.php
    ## php/lib/cc_lib.php
    ## php/lib/function.MTEntryPermalink.php
    ## php/lib/function.MTTagName.php
    ## php/lib/function.MTStaticWebPath.php
    ## php/lib/function.MTTypeKeyToken.php
    ## php/lib/function.MTBlogRelativeURL.php
    ## php/lib/block.MTIfIsAncestor.php
    ## php/lib/block.MTHasSubCategories.php
    ## php/lib/function.MTSignOnURL.php
    ## php/lib/block.MTEntryTags.php
    ## php/lib/function.MTEntryDate.php
    ## php/lib/function.MTIndexBasename.php
    ## php/lib/function.MTBlogFileExtension.php
    ## php/lib/function.MTCalendarCellNumber.php
    ## php/lib/block.MTIfPingsActive.php
    ## php/lib/function.MTPingURL.php
    ## php/lib/function.MTConfigFile.php
    ## php/lib/block.MTCalendarIfBlank.php
    ## php/lib/function.MTSubCatsRecurse.php
    ## php/lib/block.MTIfNotCategory.php
    ## php/lib/function.MTPingsSentURL.php
    ## php/lib/block.MTTopLevelCategories.php
    ## php/lib/function.MTEntryTrackbackData.php
    ## php/lib/block.MTEntries.php
    ## php/lib/block.MTCommenterIfTrusted.php
    ## php/lib/function.MTCategoryArchiveLink.php
    ## php/lib/function.MTBlogArchiveURL.php
    ## php/lib/block.MTIfCommentsModerated.php
    ## php/lib/function.MTXMLRPCScript.php
    ## php/lib/block.MTCalendar.php
    ## php/lib/function.MTCategoryID.php
    ## php/lib/block.MTIfNonEmpty.php
    ## php/lib/function.MTEntryAuthorLink.php
    ## php/lib/function.MTErrorCode.php
    ## php/lib/function.MTBlogName.php
    ## php/lib/function.MTEntryFlag.php
    ## php/lib/modifier.encode_url.php
    ## php/lib/function.MTCommentOrderNumber.php
    ## php/lib/block.MTComments.php
    ## php/lib/block.MTIfPingsAllowed.php
    ## php/lib/function.MTEntryAuthor.php
    ## php/lib/function.MTPingTitle.php
    ## php/lib/function.MTDefaultLanguage.php
    ## php/lib/block.MTIfDynamicComments.php
    ## php/lib/block.MTIfNonZero.php
    ## php/lib/block.MTIfArchiveTypeEnabled.php
    ## php/lib/function.MTEntryAtomID.php
    ## php/lib/modifier.sanitize.php
    ## php/lib/block.MTIfNeedEmail.php
    ## php/lib/function.MTCommentID.php
    ## php/lib/function.MTEntryExcerpt.php
    ## php/lib/block.MTDateFooter.php
    ## php/lib/function.MTCGIRelativeURL.php
    ## php/lib/modifier.sprintf.php
    ## php/lib/block.MTBlogs.php
    ## php/lib/function.MTPingIP.php
    ## php/lib/block.MTEntryIfExtended.php
    ## php/lib/block.MTEntryNext.php
    ## php/lib/block.MTIfCommentsActive.php
    ## php/lib/modifier.encode_php.php
    ## php/lib/modifier.lower_case.php
    ## php/lib/function.MTEntryLink.php
    ## php/lib/function.MTBlogID.php
    ## php/lib/block.MTArchiveNext.php
    ## php/lib/function.MTLink.php
    ## php/lib/function.MTVersion.php
    ## php/lib/function.MTEntryTrackbackCount.php
    ## php/lib/function.MTCommenterName.php
    ## php/lib/function.MTIndexName.php
    ## php/lib/block.MTIfTypeKeyToken.php
    ## php/lib/resource.mt.php
    ## php/lib/function.MTTagRank.php
    ## php/lib/function.MTCalendarDay.php
    ## php/lib/modifier.remove_html.php
    ## php/lib/block.MTTags.php
    ## php/lib/mtdb_sqlite.php
    ## php/lib/function.MTCGIHost.php
    ## php/lib/block.MTEntryAdditionalCategories.php
    ## php/lib/function.MTArchiveCount.php
    ## php/lib/function.MTCGIServerPath.php
    ## php/lib/block.MTEntryIfCommentsOpen.php
    ## php/lib/block.MTCalendarIfEntries.php
    ## php/lib/mtdb_base.php
    ## php/lib/function.MTCommentEntryID.php
    ## php/lib/block.MTIfAllowCommentHTML.php
    ## php/lib/function.MTCategoryDescription.php
    ## php/lib/function.MTArchiveDate.php
    ## php/lib/modifier.space_pad.php
    ## php/lib/sanitize_lib.php
    ## php/lib/function.MTTemplateNote.php
    ## php/lib/function.MTAdminCGIPath.php
    ## php/lib/function.MTProductName.php
    ## '$short_name [_1]' => '',
    ## php/lib/function.MTSubCategoryPath.php
    ## php/lib/function.MTEntryBasename.php
    ## php/lib/block.MTCommentEntry.php
    ## php/lib/function.MTEntryAuthorDisplayName.php
    ## php/lib/modifier.encode_xml.php
    ## php/lib/block.MTParentCategory.php
    ## php/lib/block.MTIndexList.php
    ## php/lib/block.MTCalendarIfNoEntries.php
    ## php/lib/modifier.decode_xml.php
    ## php/lib/block.MTSubCatIsLast.php
    ## php/lib/function.MTImageURL.php
    ## php/extlib/smarty/libs/internals/core.is_secure.php
    ## php/extlib/smarty/libs/internals/core.read_cache_file.php
    ## php/extlib/smarty/libs/internals/core.display_debug_console.php
    ## php/extlib/smarty/libs/internals/core.is_trusted.php
    ## php/extlib/smarty/libs/internals/core.rmdir.php
    ## php/extlib/smarty/libs/internals/core.get_include_path.php
    ## php/extlib/smarty/libs/internals/core.assign_smarty_interface.php
    ## php/extlib/smarty/libs/internals/core.assemble_plugin_filepath.php
    ## php/extlib/smarty/libs/internals/core.write_compiled_include.php
    ## php/extlib/smarty/libs/internals/core.get_php_resource.php
    ## php/extlib/smarty/libs/internals/core.process_cached_inserts.php
    ## php/extlib/smarty/libs/internals/core.get_microtime.php
    ## php/extlib/smarty/libs/internals/core.load_resource_plugin.php
    ## php/extlib/smarty/libs/internals/core.smarty_include_php.php
    ## php/extlib/smarty/libs/internals/core.write_cache_file.php
    ## php/extlib/smarty/libs/internals/core.write_compiled_resource.php
    ## php/extlib/smarty/libs/internals/core.load_plugins.php
    ## php/extlib/smarty/libs/internals/core.run_insert_handler.php
    ## php/extlib/smarty/libs/internals/core.rm_auto.php
    ## php/extlib/smarty/libs/internals/core.process_compiled_include.php
    ## php/extlib/smarty/libs/internals/core.create_dir_structure.php
    ## php/extlib/smarty/libs/internals/core.write_file.php
    ## php/extlib/smarty/libs/Smarty_Compiler.class.php
    ## php/extlib/smarty/libs/plugins/function.assign_debug_info.php
    ## php/extlib/smarty/libs/plugins/function.html_select_date.php
    ## php/extlib/smarty/libs/plugins/modifier.date_format.php
    ## php/extlib/smarty/libs/plugins/modifier.debug_print_var.php
    ## php/extlib/smarty/libs/plugins/modifier.count_paragraphs.php
    ## php/extlib/smarty/libs/plugins/modifier.indent.php
    ## php/extlib/smarty/libs/plugins/shared.escape_special_chars.php
    ## php/extlib/smarty/libs/plugins/modifier.nl2br.php
    ## php/extlib/smarty/libs/plugins/modifier.replace.php
    ## php/extlib/smarty/libs/plugins/modifier.escape.php
    ## php/extlib/smarty/libs/plugins/function.counter.php
    ## php/extlib/smarty/libs/plugins/modifier.regex_replace.php
    ## php/extlib/smarty/libs/plugins/modifier.string_format.php
    ## php/extlib/smarty/libs/plugins/function.eval.php
    ## php/extlib/smarty/libs/plugins/modifier.count_sentences.php
    ## php/extlib/smarty/libs/plugins/function.debug.php
    ## php/extlib/smarty/libs/plugins/function.fetch.php
    ## php/extlib/smarty/libs/plugins/modifier.cat.php
    ## php/extlib/smarty/libs/plugins/compiler.assign.php
    ## php/extlib/smarty/libs/plugins/modifier.spacify.php
    ## php/extlib/smarty/libs/plugins/function.math.php
    ## php/extlib/smarty/libs/plugins/function.html_options.php
    ## php/extlib/smarty/libs/plugins/modifier.capitalize.php
    ## php/extlib/smarty/libs/plugins/function.mailto.php
    ## php/extlib/smarty/libs/plugins/function.html_radios.php
    ## php/extlib/smarty/libs/plugins/function.html_image.php
    ## php/extlib/smarty/libs/plugins/modifier.default.php
    ## php/extlib/smarty/libs/plugins/modifier.upper.php
    ## php/extlib/smarty/libs/plugins/modifier.lower.php
    ## php/extlib/smarty/libs/plugins/modifier.truncate.php
    ## php/extlib/smarty/libs/plugins/function.config_load.php
    ## php/extlib/smarty/libs/plugins/outputfilter.trimwhitespace.php
    ## php/extlib/smarty/libs/plugins/modifier.strip_tags.php
    ## php/extlib/smarty/libs/plugins/function.popup.php
    ## php/extlib/smarty/libs/plugins/function.cycle.php
    ## php/extlib/smarty/libs/plugins/shared.make_timestamp.php
    ## php/extlib/smarty/libs/plugins/function.html_select_time.php
    ## php/extlib/smarty/libs/plugins/modifier.wordwrap.php
    ## php/extlib/smarty/libs/plugins/block.textformat.php
    ## php/extlib/smarty/libs/plugins/modifier.strip.php
    ## php/extlib/smarty/libs/plugins/function.html_checkboxes.php
    ## php/extlib/smarty/libs/plugins/function.popup_init.php
    ## php/extlib/smarty/libs/plugins/function.html_table.php
    ## php/extlib/smarty/libs/plugins/modifier.count_words.php
    ## php/extlib/smarty/libs/plugins/modifier.count_characters.php
    ## php/extlib/smarty/libs/Config_File.class.php
    ## php/extlib/smarty/libs/Smarty.class.php
    ## php/extlib/smarty/unit_test/smarty_unit_test_gui.php
    ## php/extlib/smarty/unit_test/test_cases.php
    ## php/extlib/smarty/unit_test/config.php
    ## php/extlib/smarty/unit_test/smarty_unit_test.php
    ## php/extlib/smarty/demo/index.php
    ## php/extlib/ezsql/ezsql_postgres.php
    ## php/extlib/ezsql/ezsql_sqlite.php
    ## php/extlib/ezsql/ezsql_mysql.php
    ## php/mt.php.pre
    ## '(.+?)' => '',
    ## php/plugins/function.MTGoogleSearchResult.php
    ## php/plugins/init.nofollow.php
    ## php/plugins/block.MTGoogleSearch.php
    ## php/plugins/function.MTWidgetManager.php
    ## plugins/nofollow/nofollow.pl
    'Adds a \'nofollow\' relationship to comment and TrackBack hyperlinks to reduce spam.' => '迷惑コメント/スパム対策の1つとして、コメントやトラックバックのハイパーリンク (アンカータグ) に、rel=&quot;nofollow&quot;を追加します。',
    'Restrict:' => '追加の制限: ',
    'Don\'t add nofollow to links in comments by authenticated commenters' => '認証済みコメント投稿者からのコメントには追加しない',
    ## plugins/spamlookup/spamlookup.pl
    'SpamLookup module for using blacklist lookup services to filter feedback.' => 'ブラックリストにより、迷惑コメント/トラックバックをチェックします。',
    ## plugins/spamlookup/lib/spamlookup.pm
    'Failed to resolve IP address for source URL [_1]' => 'URLからIPアドレスを解決できませんでした: [_1]',
    'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'ドメインのIPアドレス「[_2]」と送信元「[_1]」のIPアドレス「[_3]」が合致しないため、「未公開」にします。',
    'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'ドメインのIPアドレス「[_2]」と送信元「[_1]」のIPアドレス「[_3]」が合致しません',
    'No links are present in feedback' => 'リンクがありません。',
    'Number of links exceed junk limit ([_1])' => 'リンク数が設定値 (迷惑コメント/トラックバック) を超えました: [_1]',
    'Number of links exceed moderation limit ([_1])' => 'リンク数が設定値 (未公開) を超えました: [_1]',
    'Link was previously published (comment id [_1]).' => '既に公開されたリンクです: [_1]',
    'Link was previously published (TrackBack id [_1]).' => '既に公開されたリンクです: [_1]',
    'E-mail was previously published (comment id [_1]).' => '既に公開されたメールアドレスです: [_1]',
    'Word Filter match on \'[_1]\': \'[_2]\'.' => 'キーワードが合致しました: [_2] ([_1])',
    'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'キーワードが合致するかどうか調べています: [_2] ([_1])',
    'domain \'[_1]\' found on service [_2]' => 'ドメイン[_1]が見つかりました: [_2]',
    '[_1] found on service [_2]' => '[_1]が見つかりました: [_2]',
    ## plugins/spamlookup/spamlookup_words.pl
    'SpamLookup module for moderating and junking feedback using keyword filters.' => '指定されたキーワードにより、迷惑コメント/トラックバックをチェックします。',
    ## plugins/spamlookup/spamlookup_urls.pl
    'SpamLookup - Link' => 'SpamLookup - リンク',
    'SpamLookup module for junking and moderating feedback based on link filters.' => 'リンク・フィルター機能により、迷惑コメント/トラックバックをチェックします。',
    ## plugins/spamlookup/tmpl/url_config.tmpl
    'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => '受け付けたすべてのコメント/トラックバックの内容をチェックします。受け付けた内容に、指定した数を超えるリンクが含まれている場合、「未公開」もしくは「迷惑コメント/トラックバック」として処理します。逆に、リンクが含まれていないもの、既に公開しているものを「問題のないもの」として設定することもできます。',
    'Link Limits:' => 'リンク数: ',
    'Credit feedback rating when no hyperlinks are present' => 'リンクが含まれていないコメント/トラックバックを「問題のないもの」として処理します',
    'Adjust scoring' => '基準値の変更',
    'Score weight:' => '判断基準値: ',
    'Decrease' => '増やす',
    'Increase' => '減らす',
    'Moderate when more than' => '超えた場合に「未公開」にする: ',
    'link(s) are given' => 'リンクは指定されています。',
    'Junk when more than' => '超えた場合に「迷惑コメント/トラックバック」にする: ',
    'Link Memory:' => 'リンク・メモリー: ',
    'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => '既に公開したURLが含まれているコメント/トラックバックを「問題のないもの」として処理します',
    'Only applied when no other links are present in message of feedback.' => 'メールやコメント/トラックバック内にリンクが含まれていない場合のみ適用されます。',
    'Exclude URLs from comments published within last [_1] days.' => '[_1]日以内に公開されたコメントに含まれるURLを除外する。',
    'Email Memory:' => 'メール・メモリー: ',
    'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => '既に公開したコメントのメールアドレスが合致した場合に「問題のないもの」として処理します',
    'Exclude Email addresses from comments published within last [_1] days.' => '[_1]日以内に公開されたコメントに含まれるメールアドレスを除外する。',
    ## plugins/spamlookup/tmpl/lookup_config.tmpl
    'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => '受け付けたすべてのコメント/トラックバックのIPアドレス/ドメインをチェックします。送信元のIPアドレス/ドメインがブラックリストに含まれている場合、「未公開」もしくは「迷惑コメント/トラックバック」として処理します。',
    'IP Address Lookups:' => 'アドレスのチェック: ',
    'Off' => '設定しない',
    'Moderate feedback from blacklisted IP addresses' => 'ブラックリストに含まれるIPアドレスからの受信を「未公開」にする',
    'Junk feedback from blacklisted IP addresses' => 'ブラックリストに含まれるIPアドレスからの受信を「迷惑コメント/トラックバック」にする',
    'Less' => '以下',
    'More' => '以上',
    'block' => 'ブロック',
    'none' => 'なし',
    'IP Blacklist Services:' => 'ブラックリスト: ',
    'Domain Name Lookups:' => 'ドメインのチェック: ',
    'Moderate feedback containing blacklisted domains' => 'ブラックリストに含まれるドメインからの受信を「未公開」にする',
    'Junk feedback containing blacklisted domains' => 'ブラックリストに含まれるドメインからの受信を「迷惑コメント/トラックバック」にする',
    'Domain Blacklist Services:' => 'ブラックリスト: ',
    'Advanced TrackBack Lookups:' => 'トラックバックのチェック: ',
    'Moderate TrackBacks from suspicious sources' => '疑わしいサイトからのトラックバックを「未公開」にする',
    'Junk TrackBacks from suspicious sources' => '疑わしいサイトからのトラックバックを「迷惑トラックバック」にする',
    'To prevent lookups for some IP addresses or domains, list them below. Place each entry on a line by itself.' => 'ブラックリストのチェックから除外するIPアドレス/ドメイン (ホワイトリスト) を登録できます。複数登録する場合は、改行してください。',
    'Lookup Whitelist:' => 'ホワイトリスト: ',
    ## plugins/spamlookup/tmpl/word_config.tmpl
    'Incomming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => '受け付けたすべてのコメント/トラックバックの内容をチェックします。受け付けた内容に、指定したキーワードが含まれている場合、「未公開」もしくは「迷惑コメント/トラックバック」として処理します。',
    'Keywords to Moderate:' => '未公開キーワード: ',
    'Keywords to Junk:' => '迷惑キーワード: ',
    ## plugins/TemplateRefresh/tmpl/results.tmpl
    'Backup and Refresh Templates' => 'テンプレートのバックアップ・更新',
    'No templates were selected to process.' => '更新するテンプレートが選択されていません。',
    'Return' => '戻る',
    ## plugins/TemplateRefresh/TemplateRefresh.pl
    'Backup and refresh existing templates to Movable Type\'s default templates.' => '既存のテンプレート・デザインをバックアップした後に、標準のテンプレート・デザインに更新します。',
    'Error loading default templates.' => '標準テンプレート・デザインの読み込み中にエラーが発生しました。',
    'Insufficient permissions to modify templates for weblog \'[_1]\'' => 'テンプレートを更新する権限がありません: [_1]',
    'Processing templates for weblog \'[_1]\'' => '次のブログのテンプレートを更新します: [_1]',
    "Refreshing (with <a href=\"?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]\">backup</a>) template '[_3]'." => 'テンプレートを更新します: [_3] (<a href=\"?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]\">バックアップ</a>)',
    'Refreshing template \'[_1]\'.' => 'テンプレート更新中: [_1]',
    'Error creating new template: ' => 'テンプレート作成時にエラーが発生しました: ',
    'Created template \'[_1]\'.' => 'テンプレートを作成しました: [_1]',
    'Insufficient permissions for modifying templates for this weblog.' => 'テンプレートを更新する権限がありません。',
    'Skipping template \'[_1]\' since it appears to be a custom template.' => 'カスタム・テンプレートのため更新しません: [_1]',
    'Refresh Template(s)' => 'テンプレートを初期化する',
    ## -
    ## search_templates/results_feed_rss2.tmpl
    ## search_templates/results_feed.tmpl
    'Search Results for [_1]' => '[_1] の検索結果',
    ## search_templates/comments.tmpl
    'Search for new comments from:' => '新しいコメントから検索: ',
    'the beginning' => '開始時点から',
    'one week back' => '1週間前',
    'two weeks back' => '2週間前',
    'one month back' => '1か月前',
    'two months back' => '2か月前',
    'three months back' => '3か月前',
    'four months back' => '4か月前',
    'five months back' => '5か月前',
    'six months back' => '6か月前',
    'one year back' => '1年前',
    'Find new comments' => 'コメントを検索',
    'Posted in [_1] on [_2]' => 'ブログ: [_1]   日時: [_2]',
    'No results found' => '見つかりません。',
    'No new comments were found in the specified interval.' => '指定された期間にコメントは見つかりません。',
    'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => '検索したい期間を選択して、コメントを検索をクリックしてください。',
    ## search_templates/default.tmpl
    'Blog Search Results' => 'Blog Search: 結果',
    'Blog search' => 'Blog Search',
    "Entries from [_1] tagged with '[_2]'" => '[_1]でタグ [_2] が指定されているエントリ',
    'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => '<MTIfNonEmpty tag="EntryAuthorDisplayName">投稿者: [_1]  </MTIfNonEmpty>日時: [_2]',
    'No pages were found containing "[_1]".' => '[_1] を含むページが見つかりませんでした。',
    'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => '検索エンジンはすべての単語を順序を無視して検索します。フレーズで検索するときは引用符で囲んでください。',
    'Movable type' => 'Movable Type',
    ## tmpl/error.tmpl
    'Missing Configuration File' => '環境設定ファイル (mt-config.cgi) が見つかりません',
    '_ERROR_CONFIG_FILE' => '環境設定ファイル (mt-config.cgi) が見つかりません。ヘルプに従って設定してください。',
    'Database Connection Error' => 'データベースに接続できません。',
    '_ERROR_DATABASE_CONNECTION' => 'データベース接続の設定に誤りがあるか、環境設定ファイル (mt-config.cgi) 内に見つかりません。ヘルプに従って設定してください。',
    'CGI Path Configuration Required' => '「CGIPath」の設定が必要です。',
    '_ERROR_CGI_PATH' => 'CGIPathの設定に誤りがあるか、環境設定ファイル (mt-config.cgi) 内に見つかりません。ヘルプに従って設定してください。',
    'An error occurred' => 'エラーが発生しました。',
    ## tmpl/feeds/error.tmpl
    'Movable Type Activity Log' => 'Movable Type ログ',
    ## tmpl/feeds/feed_comment.tmpl
    'On this entry' => '同じエントリーへのアイテム',
    'By commenter identity' => '同じコメント投稿者からのコメント',
    'By commenter name' => '同名のコメント投稿者からのコメント',
    'By commenter email' => '同じメールアドレスの投稿者からのコメント',
    'By commenter URL' => '同じURLの投稿者からのコメント',
    ## tmpl/feeds/feed_entry.tmpl
    'system' => 'システム',
    'Blog' => 'ブログ',
    'Untitled' => '無題',
    'More like this' => '他にも...',
    'From this blog' => '同じブログのアイテム',
    'From this author' => '同じ投稿者のアイテム',
    'On this day' => '同じ日のアイテム',
    ## tmpl/feeds/login.tmpl
    'This link is invalid. Please resubscribe to your activity feed.' => 'このリンクは無効です。ログのリンクを再度取得してください。',
    ## tmpl/feeds/feed_system.tmpl
    ## tmpl/feeds/feed_ping.tmpl
    'Source blog' => '送信元のブログ',
    'By source blog' => '同じ送信元のブログからのアイテム',
    'By source title' => '同じタイトルの送信元からのアイテム',
    'By source URL' => '同じURLの送信元からのアイテム',
    ## tmpl/feeds/feed_chrome.tmpl
    ## tmpl/wizard/optional.tmpl
    'Step 3 of 3' => 'ステップ 3/3',
    'Mail Configuration' => 'メールの設定',
    "You can configure you mail settings from here, or you can complete the configuration wizard by clicking 'Continue'." => 'メールの設定をします。特に設定は不要な場合は次へ進むこともできます。',
    'An error occurred while attempting to send mail: ' => 'メールの送信でエラーが発生しました: ',
    'MailTransfer' => 'MailTransfer',
    'Select One...' => '選択してください',
    'SendMailPath' => 'SendMailPath',
    'The physical file path for your sendmail.' => 'sendmailへの物理パス',
    'Address of your SMTP Server' => 'SMTPサーバーのアドレス',
    'Mail address for test sending' => 'テスト送信するあて先メールアドレス',
    'Your mail configuration is successfully.' => 'メールの構成を完了しました。',
    'Back' => '戻る',
    'Continue' => '次へ',
    'Send Test Email' => 'テストメールを送信',
    ## tmpl/wizard/complete.tmpl
    'Congratulations! You\'ve successfully configured [_1] [_2].' => '[_1] [_2]の構成が終了しました。',
    'This is a copy of your configuration settings.' => '以下は構成ファイルのコピーです。',
    "We were unable to create your configuration file. If you would like to check the directory permissions and retry, click the 'Retry' button." => '構成ファイルを作成できませんでした。ディレクトリに対して書き込み権限がある場合は、再試行ボタンをクリックすればもう一度処理を行うことができます。',
    'Retry' => '再試行',
    'Install' => 'インストール',
    "The above settings have been written to the file <tt>[_1]</tt>. If any of these settings are incorrect, you may click the 'Back' button below to reconfigure them." => '上記の設定で構成ファイル<tt>[_1]</tt>が作成されました。構成が誤っている場合は、戻るボタンで戻って設定をやり直すことができます。',
    ## tmpl/wizard/start.tmpl
    'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'ブラウザでJavaScriptを有効にしないとMovable Typeは動作しません。有効化して表示を更新してください。',
    'Your Movable Type configuration file already exists. The Wizard cannot continue with this file present.' => 'Movable Typeの構成ファイルがすでに存在します。ウィザードは実行できません。',
    'This wizard will help you configure the basic settings needed to run Movable Type.' => 'このウィザードはMovable Typeの基本的な構成作業を支援します。',
    'Static Web Path' => 'Static Web Path',
    "Due to your server's configuration it is not accessible in its current location and must be moved to a web-accessible location (e.g. into your web document root directory)." => 'サーバーの構成上、現在の場所にはWebブラウザからアクセスできません。Webサイトのルートディレクトリの下など、アクセス可能な場所に移動してください。',
    'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'このディレクトリはMovable Typeのインストールディレクトリの外部に移動されたかまたは名前が変更されました。',
    'Please specify the web-accessible URL to this directory below.' => 'このディレクトリにWebブラウザからアクセスするURLを指定してください。',
    'Static web path URL' => 'スタティックファイルへのURL',
    'This can be in the form of http://example.com/mt-static/ or simply /mt-static' => 'http://example.com/mt-static/のような絶対URLまたは/mt-staticのようにも指定できます。',
    'Begin' => '開始',
    ## tmpl/wizard/configure.tmpl
    'Step 2 of 3' => 'ステップ 2/3',
    'Database Configuration' => 'データベースの構成',
    "Your database configuration is complete. Click 'Continue' below to configure your mail settings." => 'データベース設定を完了しました。次へボタンをクリックしてメールの設定をしてください。',
    'Please enter the parameters necessary for connecting to your database.If your database type is not listed in the dropdown below, you may be missing the Perl module necessary to connect to your database.  If this is the case, please check your installation and click <a href="?__mode=configure">here</a> to re-test your installation.' => 'データベースにアクセスするのに必要はパラメータを指定してください。利用するデータベースがリストに入っていない場合は、必要なPerlモジュールが不足しています。Perlモジュールのインストール状況を確認して、<a href="?__mode=configure">再度実行</a>してください。',
    'An error occurred while attempting to connect to the database: ' => 'データベースへの接続でエラーが発生しました: ',
    'Database' => 'データベース',
    'Database Path' => 'データベースへのパス',
    'The physical file path for your BerkeleyDB or SQLite database. ' => 'BerkeleyDBまたはSQLiteデータベースファイルへのパス',
    "A default location of './db' will store the database file(s) underneath your Movable Type directory." => '既定の設定（./db）にすると、Movable Typeをインストールしたディレクトリにデータベースファイルが作成されます。',
    'Database Name' => 'データベース名',
    'The name of your SQL database (this database must already exist).' => 'SQLデータベースの名前(データベースがすでに存在していなければなりません)',
    'Username' => 'ログイン名',
    'The username to login to your SQL database.' => 'SQLデータベースにログインするユーザー名',
    'Password' => 'パスワード',
    'The password to login to your SQL database.' => 'SQLデータベースにログインするパスワード',
    'Database Server' => 'データベースサーバー',
    "This is usually 'localhost'." => '通常はlocalhostです。',
    'Database Port' => 'データベースのポート',
    'This can usually be left blank.' => '通常は空白のままでかまいません。',
    'Database Socket' => 'データベースのソケット',
    'Test Connection' => '接続のテスト',
    ## tmpl/wizard/packages.tmpl
    'Step 1 of 3' => 'ステップ 1/3',
    'Requirements Check' => '必須要件の確認',
    "One of the following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your weblog data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the 'Retry' button." => 'Movable Typeがデータベースにアクセスするために、以下のPerlモジュールのうち1つが必要です。Movable Typeはウェブログのデータをデータベースに格納します。以下のパッケージのうち1つをインストールしないと先に進めません。再度準備ができたら再試行ボタンをクリックしてください。',
    'Missing Database Packages' => '見つからないデータベースパッケージ',
    "The following optional, feature-enhancing Perl modules could not be found. You may install them now and click 'Retry' or simply continue without them.  They can be installed at any time if needed." => '以下のPerlモジュールが見つかりませんでした。これらのモジュールは必須ではありませんがMovable Typeの全機能を利用するために必要になることがあります。今すぐインストールして再試行ボタンをクリックするか、またはこのまま進んであとでインストールすることもできます。',
    'Missing Optional Packages' => '見つからないパッケージ（オプション）',
    "The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the 'Retry' button to re-test for these packages." => '以下のPerlモジュールはMovable Typeが正しく動作するためには必須です。すべてのインストールが完了したら、再試行ボタンをクリックして再度確認してください。',
    'Missing Required Packages' => '不足しているパッケージ',
    'Minimal version requirement:' => '必須バージョン:',
    'Installation instructions.' => 'インストール方法',
    'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'サーバーに必須モジュールがすべて用意されています。追加のインストールは必要ありません。',
    ## tmpl/wizard/mt-config.tmpl
    ## tmpl/wizard/header.tmpl
    'Movable Type' => 'Movable Type',
    ## tmpl/wizard/footer.tmpl
    ## tmpl/email/verify-subscribe.tmpl
    'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => '登録してくれてありがとう。ブログ「[_1]」の更新通知への登録は、以下の URL にアクセスすると完了します: ',
    'If the link is not clickable, just copy and paste it into your browser.' => 'リンクをクリックできない場合は、ブラウザーにコピーしてから貼り付けてください。',
    ## tmpl/email/recover-password.tmpl
    '_USAGE_FORGOT_PASSWORD_1' => 'パスワードを再設定します。パスワードはシステム側で変更され、新しいパスワードはこちらになります:',
    '_USAGE_FORGOT_PASSWORD_2' => '新しいパスワードを使ってMovable Typeにログインし、すぐにパスワードを変更してください。',
    ## tmpl/email/footer-email.tmpl
    'Powered by Movable Type' => 'Powered by Movable Type',
    ## tmpl/email/new-ping.tmpl
    'An unapproved TrackBack has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => '「[_3] (ブログ: [_1]、ID: [_2])」への未承認のトラックバックを受け付けました。トラックバックを公開するためには承認をしてください。',
    'An unapproved TrackBack has been posted on your blog [_1], for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => '「[_3] (ブログ: [_1]、ID: [_2])」への未承認のトラックバックを受け付けました。トラックバックを公開するためには承認をしてください。',
    'Approve this TrackBack:' => 'トラックバックを承認: ',
    'A new TrackBack has been posted on your blog [_1], on entry #[_2] ([_3]).' => '「[_3] (ブログ: [_1]、ID: [_2])」への新しいトラックバックを受け付けました。',
    'A new TrackBack has been posted on your blog [_1], on category #[_2] ([_3]).' => '「[_3] (ブログ: [_1]、ID: [_2])」への新しいトラックバックを受け付けました。',
    'View this TrackBack:' => 'トラックバックを確認: ',
    'IP Address:' => 'IPアドレス: ',
    ## tmpl/email/new-comment.tmpl
    'An unapproved comment has been posted on your blog [_1], for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => '「[_3] (ブログ: [_1]、ID: [_2])」への未承認のコメントを受け付けました。コメントを公開するためには承認をしてください。',
    'Approve this comment:' => 'コメントを承認: ',
    'A new comment has been posted on your blog [_1], on entry #[_2] ([_3]).' => '「[_3] (ブログ: [_1]、ID: [_2])」への新しいコメントを受け付けました。',
    'View this comment:' => 'コメントを確認:  ',
    ## tmpl/email/notify-entry.tmpl
    ## tmpl/cms/preview_entry.tmpl
    'Re-Edit this entry' => '編集画面に戻る',
    'Save this entry' => 'このエントリーを保存する',
    ## tmpl/cms/error.tmpl
    'An error occurred:' => 'エラーが発生しました: ',
    'Close' => '閉じる',
    'Go Back' => '戻る',
    ## tmpl/cms/recover_password_result.tmpl
    'Recover Passwords' => 'パスワードの再設定',
    'No authors were selected to process.' => '投稿者が選択されていません。',
    ## tmpl/cms/edit_profile.tmpl
    '_WARNING_PASSWORD_RESET_SINGLE' => '[_1]のパスワードを再設定しようとしています。パスワードはランダムに生成され、直接メールアドレス（[_2]）に送られます。実行しますか？',
    'Author Permissions' => '投稿者の権限',
    '_USAGE_PERMISSIONS_1' => '[_1]の権限を変更します。編集権限のあるブログの一覧内のブログについて「[_1]」にアクセス権限を与えたいボックスにチェックを入れてください。',
    'Profile' => 'プロフィール',
    'Permissions' => '権限',
    'Your changes to [_1]\'s permissions have been saved.' => '[_1]の権限の変更を保存しました。',
    '[_1] has been successfully added to [_2].' => '[_1]をブログ「[_2]」の投稿者として追加しました。',
    '_USAGE_PERMISSIONS_3' => '投稿者を編集して、アクセス権限を追加/削除するには、二つの方法があります。簡単に編集するには、ユーザーをメニューから選んで編集を押します。もう一つは、投稿者全員の一覧から選んで、編集、または削除する方法です。',
    'A new password has been generated and sent to the email address [_1].' => '新しいパスワードが生成され、メールアドレス（[_1]）に送信されました。',
    'The name used by this author to login.' => 'この投稿者が、ログインの際に入力する名称です。',
    'The author\'s published name.' => 'この投稿者の投稿が、公開される際に表示される名称です。',
    'The author\'s email address.' => 'この投稿者のメールアドレスです。',
    'Website URL:' => 'ウェブサイトURL: ',
    'The URL of this author\'s website. (Optional)' => 'この投稿者のウェブサイトのURLです（オプション）。',
    'Language:' => '使用言語: ',
    'The author\'s preferred language.' => 'この投稿者が選択した、表示用の言語です。',
    'Save Changes' => '変更を保存',
    'Save permissions for this author (s)' => 'この投稿者の権限を保存 (S)',
    '_USAGE_PASSWORD_RESET' => 'このユーザーのパスワードを再設定するプロセスを開始できます。このプロセスでは、新しくランダムに生成されたパスワードがユーザーのメールアドレス（[_1]）に直接送信されます。',
    ## tmpl/cms/template_actions.tmpl
    'Delete' => '削除',
    'template' => 'テンプレート',
    ## tmpl/cms/system_info.tmpl
    'System Status and Information' => 'システムの状態',
    'This page will soon contain information about the server environment availability of required perl modules, installed plugins and other information useful for expediting debugging in technical support requests.' => 'この画面には、必要なPerlモジュールのインストール状況といったサーバー環境、インストールされたプラグイン、テクニカル・サポートを迅速に進めるために有効な情報等が表示されます。',
    ## tmpl/cms/ping_table.tmpl
    'Status' => '公開の状態',
    'Excerpt' => '抜粋（概要）',
    'From' => '送信元',
    'Weblog' => 'ブログ',
    'Target' => '対象',
    'Date' => '日付',
    'IP' => 'IPアドレス',
    'Only show published TrackBacks' => '公開のトラックバックを表示する',
    'Published' => '公開',
    'Only show pending TrackBacks' => '保留のトラックバックを表示する',
    'Pending' => '保留',
    'Edit this TrackBack' => 'トラックバックを編集',
    'Edit TrackBack' => 'トラックバックを編集',
    'Go to the source entry of this TrackBack' => 'このトラックバックの発信元エントリーへ',
    'View the [_1] for this TrackBack' => 'トラックバックの対象を表示',
    'Search for all comments from this IP address' => 'このIPアドレスから投稿されたコメントを検索',
    ## tmpl/cms/list_tags.tmpl
    'System-wide' => 'システム全体',
    '_USAGE_TAGS' => 'タグを使って、エントリーをわかりやすく整理したり、ブログのページで見やすくできます。',
    'Your tag changes and additions have been made.' => 'タグの変更と追加を行いました。',
    'You have successfully deleted the selected tags.' => '選択したタグを削除しました。',
    'Tag Name' => 'タグ名',
    'Click to edit tag name' => 'クリックしてタグを編集します。',
    'Rename' => '名前の変更',
    'Show all entries with this tag' => 'このタグを使ったエントリーのみ表示',
    '[quant,_1,entry,entries]' => '[quant,_1,件,件]',
    'No tags could be found.' => 'タグは見つかりません。',
    'An error occurred while testing for the new tag name.' => '新しいタグを検査しているときにエラーが発生しました。',
    ## tmpl/cms/header-popup.tmpl
    ## tmpl/cms/edit_comment.tmpl
    'Your changes have been saved.' => '変更を保存しました。',
    'The comment has been approved.' => 'コメントを承諾しました。',
    'Previous' => '前へ',
    'List &amp; Edit Comments' => 'コメントの一覧',
    'Next' => '次へ',
    '_external_link_target' => '_blank',
    'View Entry' => 'エントリーを確認',
    'Pending Approval' => '保留',
    'Junked Comment' => '迷惑コメント',
    'Unpublished' => '未公開 (下書き)',
    'Junk' => '迷惑コメント/トラックバック',
    'View all comments with this status' => '同じ状態のコメントをすべて表示',
    'Trusted' => '登録済み',
    '(Trusted)' => '(登録済み)',
    'Ban&nbsp;Commenter' => '禁止する',
    'Untrust&nbsp;Commenter' => '登録を解除する',
    'Banned' => '禁止中',
    '(Banned)' => '(禁止)',
    'Trust&nbsp;Commenter' => '登録する',
    'Unban&nbsp;Commenter' => '投稿を許可する',
    'View all comments by this commenter' => 'このコメント投稿者によるコメントをすべて表示',
    'None given' => '未公開',
    'Email' => 'メール',
    'View all comments with this email address' => 'このメールアドレスからのコメントをすべて表示',
    'Link' => 'リンク',
    'View all comments with this URL' => 'このURLからのコメントをすべて表示',
    'Entry no longer exists' => 'エントりーはすでにありません',
    'No title' => 'タイトルがありません',
    'View all comments on this entry' => 'このエントリーへのコメントをすべて表示',
    'View all comments posted on this day' => 'この日に受け付けたコメントをすべて表示',
    'View all comments from this IP address' => 'このIPアドレスからのコメントをすべて表示',
    'Save this comment (s)' => 'コメントを保存 (S)',
    'comment' => 'コメント',
    'Delete this comment (x)' => 'このコメントを削除(X)',
    'Ban This IP' => 'このIPアドレスを禁止する',
    'Final Feedback Rating' => '迷惑コメント/トラックバック自動判断値',
    'Test' => 'テスト',
    'Score' => 'スコア',
    'Results' => '結果',
    'Plugin Actions' => 'プラグイン',
    ## tmpl/cms/spam_confirm.tmpl
    'These domain names were found in the selected comments. Check the box at right to block comments and trackbacks containing that URL in the future.' => 'これらのドメイン名は、選択したコメントにありました。今後、そのURLを含むコメントやトラックバックをブロックするには、右側のチェックボックスをオンにしてください。',
    'Block' => 'ブロック',
    ## tmpl/cms/pinged_urls.tmpl
    'Here is a list of the previous TrackBacks that were successfully sent:' => '今までに送信できたトラックバックの一覧です: ',
    'Here is a list of the previous TrackBacks that failed. To retry these, include them in the Outbound TrackBack URLs list for your entry.:' => '以前送信できなかったトラックバックの一覧です。再試行するには、これらをエントリーの「トラックバック送信先のURL」に指定します。',
    ## tmpl/cms/list_commenters.tmpl
    '_USAGE_COMMENTERS_LIST' => 'フィルター、管理、および編集可能な[_1]の認証済み投稿者一覧です。下の画面で、コメント投稿者の登録、禁止、詳細情報の閲覧ができます。',
    'The selected commenter(s) has been given trusted status.' => '選択したコメント投稿者を登録しました。',
    'Trusted status has been removed from the selected commenter(s).' => '選択したコメント投稿者は、まだ登録されていません。',
    'The selected commenter(s) have been blocked from commenting.' => '選択したコメント投稿者は、コメントを投稿できません。',
    'The selected commenter(s) have been unbanned.' => '選択したコメント投稿者は、コメントを投稿できます。',
    'Reset' => 'リセット',
    'None.' => 'なし',
    '(Showing all commenters.)' => 'すべて (条件を変更する)',
    'Showing only commenters whose [_1] is [_2].' => '[_1]が[_2] (条件を変更する)',
    'Commenter Feed' => 'コメント投稿者・フィード',
    'Commenter Feed (Disabled)' => 'コメント投稿者・フィード（無効）',
    'Disabled' => '利用不可',
    'Set Web Services Password' => 'Webサービス・パスワードを指定',
    'Show' => '表示: ',
    'all' => 'すべての',
    'only' => '該当する',
    'commenters.' => 'コメント投稿者',
    'commenters where' => 'コメント投稿者‐検索条件: ',
    'status' => '公開の状態',
    'commenter' => 'コメント投稿者',
    'is' => 'が',
    'trusted' => '登録済み',
    'untrusted' => '未登録',
    'banned' => '禁止中',
    'unauthenticated' => '許可する',
    'authenticated' => '認証済み',
    '.' => '',
    'Filter' => 'フィルター',
    'No commenters could be found.' => 'コメント投稿者は見つかりません。',
    ## tmpl/cms/pinging.tmpl
    'Pinging sites...' => 'トラックバック/更新中...',
    ## tmpl/cms/cfg_system_feedback.tmpl
    'This screen allows you to configure feedback and outbound TrackBack settings for the entire installation.  These settings override any similar settings for individual weblogs.' => 'この画面では、システム全体にわたるコメントとトラックバックの設定ができます。これらの設定は、個々のブログの設定より優先されます。',
    'Your feedback preferences have been saved.' => '設定を保存しました。',
    'Feedback Master Switch' => 'コメント/トラックバックの受信設定 (システム全体)',
    'Disable Comments' => 'コメントの受信',
    'Stop accepting comments on all weblogs' => 'すべてのブログでコメントを受け付けない',
    'This will override all individual weblog comment settings.' => 'この設定は、個々のブログの設定より優先されます。',
    'Disable TrackBacks' => 'トラックバックの受信',
    'Stop accepting TrackBacks on all weblogs' => 'すべてのブログでトラックバックを受け付けない',
    'This will override all individual weblog TrackBack settings.' => 'この設定は、個々のブログの設定より優先されます。',
    'Outbound TrackBack Control' => 'トラックバックの送信',
    'Allow outbound TrackBacks to:' => 'トラックバックの送信: ',
    'Any site' => 'すべてのサイトへのトラックバックを許可する',
    'No site' => '許可しない',
    '(Disable all outbound TrackBacks.)' => '(トラックバックの送信はできません)',
    'Only the weblogs on this installation' => 'このシステムのブログへのトラックバックを許可する',
    'Only the sites on the following domains:' => '以下のドメインへのトラックバックを許可する: ',
    'This feature allows you to limit outbound TrackBacks and TrackBack auto-discovery for the purposes of keeping your installation private.' => 'イントラネットでのプライベートな利用のために、トラックバックの送信や自動検知を制限する場合に設定します。',
    'Save changes (s)' => '変更を保存 (S)',
    ## tmpl/cms/notification_table.tmpl
    'Email Address' => 'メールアドレス',
    'URL' => 'URL',
    'Date Added' => '作成日',
    ## tmpl/cms/edit_entry.tmpl
    'You have unsaved changes to your entry that will be lost.' => '保存されていないエントリへの変更は失われてしまいます。',
    'Add new category...' => '新しいカテゴリーを追加する',
    'Publish On' => '公開する日時',
    'Entry Date' => 'エントリーの投稿日時',
    'You must specify at least one recipient.' => '最低1つはあて先を指定する必要があります。',
    'Create New Entry' => 'エントリーを投稿',
    'Edit Entry' => 'エントリーを編集',
    'Your entry has been saved. You can now make any changes to the entry itself, edit the authored-on date, or edit comments.' => 'エントリーを保存しました。エントリーの変更、作成日、コメントの編集ができます。',
    'One or more errors occurred when sending update pings or TrackBacks.' => 'トラックバックか、アップデート情報の送信でエラーがありました。',
    '_USAGE_VIEW_LOG' => 'エラーの場合は、<a href="[_1]">ログ</a>をチェックしてください。',
    'Your customization preferences have been saved, and are visible in the form below.' => 'カスタマイズの設定を変更しました。下のフォームを確認してください。',
    'Your changes to the comment have been saved.' => 'コメントの変更を保存しました。',
    'Your notification has been sent.' => 'お知らせメールを送信しました。',
    'You have successfully deleted the checked comment(s).' => 'チェックしたコメントは削除しました。',
    'You have successfully deleted the checked TrackBack(s).' => 'このカテゴリーから、選択したトラックバックを削除しました。',
    'List &amp; Edit Entries' => 'エントリーの一覧',
    'Entry' => 'エントリー',
    'Comments ([_1])' => 'コメント ([_1])',
    'TrackBacks ([_1])' => 'トラックバック ([_1])',
    'Notification' => '通知',
    'Title' => 'タイトル',
    'Scheduled' => '指定日',
    'Assign Multiple Categories' => '複数のカテゴリーを指定する',
    'Entry Body' => 'エントリーの内容 (body)',
    'Bold' => '太字',
    'Italic' => 'イタリック',
    'Underline' => 'アンダーライン',
    'Insert Link' => 'リンクを挿入',
    'Insert Email Link' => 'メールアドレスを挿入',
    'Quote' => '引用',
    'Bigger' => '大きい',
    'Smaller' => '小さい',
    'Extended Entry' => '追記 (more)',
    'Keywords' => 'キーワード',
    '(comma-delimited list)' => '(カンマで区切る)',
    '(space-delimited list)' => '(空白で区切る)',
    '(delimited by \'[_1]\')' => '(「[_1]」で区切る)',
    'Authored On' => '投稿日',
    'Text Formatting' => '改行設定',
    'Basename' => '出力ファイル名',
    'Unlock this entry\'s output filename for editing' => 'このエントリーの出力ファイル名を編集するため、ロックを解除します。',
    'Warning' => '警告',
    'Warning: If you set the basename manually, it may conflict with another entry.' => '警告: 出力ファイル名を手動で変更した場合、別のエントリーと同じファイル名にならないように注意してください。',
    'Warning: Changing this entry\'s basename may break inbound links.' => '警告: 出力ファイル名を変更すると、このページに対して張られたリンクが切断する可能性があります。',
    'Accept Comments' => 'コメントを受信',
    'Accept TrackBacks' => 'トラックバックを受信',
    'Outbound TrackBack URLs' => 'トラックバック送信先のURL',
    'View Previously Sent TrackBacks' => '以前に送ったトラックバックを確認',
    'Customize the display of this page.' => '画面の表示設定を変更',
    'Manage Comments' => 'コメントの管理',
    'Click on a [_1] to edit it. To perform any other action, check the checkbox of one or more [_2] and click the appropriate button or select a choice of actions from the dropdown to the right.' => '[_1]をクリックして編集できます。その他の操作を行うには[_2]のチェックボックスをオンにしてボタンをクリックするか、右側のプルダウンからアクションを選択します。',
    'No comments exist for this entry.' => 'このエントリーにコメントはありません。',
    'Manage TrackBacks' => 'トラックバックの管理',
    'No TrackBacks exist for this entry.' => 'このエントリーにはトラックバックはありません。',
    'Send a Notification' => '通知の送信',
    'You can send an email notification of this entry to people on your notification list or using arbitrary email addresses.' => 'このエントリーを通知先リストに登録されているあて先や指定した任意のアドレスに通知できます。',
    'Recipients' => 'あて先',
    'Send notification to' => '通知を送信する',
    'Notification list subscribers, and/or' => '通知リストに登録済みのアドレスおよび：',
    'Other email addresses' => 'その他のメールアドレス',
    'Note: Enter email addresses on separate lines or separated by commas.' => 'メールアドレスを改行またはカンマで区切って入力してください。',
    'Notification content' => '通知する内容',
    "Your blog's name, this entry's title and a link to view it will be sent in the notification.  Additionally, you can add a  message, include an excerpt of the entry and/or send the entire entry." => 'ブログの名前、エントリーのタイトル、エントリーへのリンクが通知に含まれて送信されます。追加のメッセージや、エントリーの概要、本文全体を送信することもできます。',
    'Message to recipients (optional)' => '通知先へのメッセージ（オプション）',
    'Additional content to include (optional)' => '通知に追加する内容（オプション）',
    'Entry excerpt' => 'エントリーの概要',
    'Entire entry body' => 'エントリー本文すべて',
    'Note: If you choose to send the entire entry, it will be sent as shown on the editing screen, without any text formatting applied.' => '注: エントリー全体を送ると、編集画面で見えるとおりの、一切整形されていないテキストが送信されます。',
    'Send entry notification' => 'エントリーの通知を送信する',
    'Send notification (n)' => '通知の送信 (N)',
    ## tmpl/cms/template_table.tmpl
    'Template Name' => 'テンプレート名',
    'Output File' => '出力ファイル名',
    'Dynamic' => 'ダイナミック',
    'Linked' => 'リンク済み',
    'Built w/Indexes' => '再構築',
    'View Published Template' => '出力されたページを確認',
    ## tmpl/cms/entry_table.tmpl
    'Only show unpublished entries' => '未公開 (下書き) のエントリーを表示する',
    'Only show published entries' => '公開のエントリーを表示する',
    'Only show scheduled entries' => '指定日公開のエントリーを表示する',
    ## tmpl/cms/entry_actions.tmpl
    'Save' => '保存',
    'Save these entries (s)' => 'エントリーを保存 (S)',
    'Save this entry (s)' => 'エントリーを保存 (S)',
    'Preview this entry (v)' => '確認 (V)',
    'Delete this entry (x)' => 'このエントリーを削除(X)',
    'to rebuild' => '再構築',
    'Rebuild' => '再構築',
    'Rebuild selected entries (r)' => '再構築 (R)',
    'Delete selected entries (x)' => '選択されたエントリーを削除(X)',
    ## tmpl/cms/list_comment.tmpl
    '_USAGE_COMMENTS_LIST_BLOG' => 'フィルター、管理、および編集可能な[_1]のコメント一覧です。',
    '_USAGE_COMMENTS_LIST_OVERVIEW' => 'フィルター、管理、および編集可能なすべてのブログのコメント一覧です。',
    'The selected comment(s) has been published.' => '選択したコメントを公開しました。',
    'All junked comments have been removed.' => 'すべての迷惑コメントは削除されました。',
    'The selected comment(s) has been unpublished.' => '選択したコメントを未公開に変更しました。',
    'The selected comment(s) has been junked.' => '選択したコメントを迷惑コメントに変更しました。',
    'The selected comment(s) has been unjunked.' => '選択したコメントを正常なコメントに変更しました。',
    'The selected comment(s) has been deleted from the database.' => 'コメントをデータベースから削除しました。',
    'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be Banned or Trusted.' => '選択されたコメントの中に認証されていないコメント投稿者からのものが含まれています。このコメント投稿者は禁止したり登録したりできません。',
    'No comments appeared to be junk.' => 'どのコメントも迷惑コメントではないようです。',
    'Junk Comments' => '迷惑コメント',
    'Comment Feed' => 'コメント・フィード',
    'Comment Feed (Disabled)' => 'コメント・フィード（無効）',
    'Quickfilter:' => 'クイックフィルター: ',
    'Show unpublished comments.' => '未公開のコメントを表示する',
    '(Showing all comments.)' => 'すべて (条件を変更する)',
    'Showing only comments where [_1] is [_2].' => '[_1]が[_2] (条件を変更する)',
    'comments.' => 'コメント',
    'comments where' => 'コメント‐検索条件: ',
    'published' => '公開',
    'unpublished' => '未公開',
     '.' => '',
    'No comments could be found.' => 'コメントは見つかりません。',
    'No junk comments could be found.' => '迷惑コメントは見つかりません。',
    ## tmpl/cms/list_banlist.tmpl
    'IP Banning Settings' => '禁止IPアドレスの設定',
    'This screen allows you to ban comments and TrackBacks from specific IP addresses.' => 'この画面では、特定のIPアドレスからのコメントとトラックバックを禁止します。',
    'You have banned [quant,_1,address,addresses].' => '[quant,_1,アドレス,アドレス]を禁止しました。',
    'You have added [_1] to your list of banned IP addresses.' => '[_1]」禁止IPアドレスリストに追加しました。',
    'You have successfully deleted the selected IP addresses from the list.' => '選択したIPアドレスを禁止IPアドレスリストから削除しました。',
    'General' => '全般',
    'New Entry Defaults' => '新規投稿',
    'Feedback' => 'コメント/トラックバック',
    'Publishing' => '公開',
    'Ban New IP Address' => '禁止IPアドレスに新しく登録する',
    'Ban IP Address' => '禁止IPアドレスに登録する',
    'IP Address' => 'IPアドレス',
    'Date Banned' => '禁止日',
    'IP address' => 'IPアドレス',
    ## tmpl/cms/commenter_table.tmpl
    'Commenter' => 'コメント投稿者',
    'Identity' => 'ID',
    'Most Recent Comment' => '最近のコメント',
    'Only show trusted commenters' => '登録済みのコメント投稿者を表示する',
    'Only show banned commenters' => '禁止のコメント投稿者を表示する',
    'Only show neutral commenters' => '認証サービスで認証されたコメント投稿者のみを表示する',
    'Authenticated' => '認証済み',
    'Edit this commenter' => 'コメント投稿者の情報を修正',
    'View this commenter\'s profile' => 'コメント投稿者のプロフィールを表示',
    ## tmpl/cms/rebuilt.tmpl
    'All of your files have been rebuilt.' => 'すべて再構築できました。',
    'Your [_1] has been rebuilt.' => '[_1]を再構築しました。',
    'Your [_1] pages have been rebuilt.' => '[_1]を再構築しました。',
    'View your site' => 'サイトを確認',
    'View this page' => 'ページを確認',
    'Rebuild Again' => 'もう一度再構築する',
    ## tmpl/cms/reload_opener.tmpl
    ## tmpl/cms/cfg_entries.tmpl
    'This screen allows you to control default settings for new entries as well as your publicity and remote interface settings.' => 'この画面では、新しくエントリーを投稿するときの初期値、および公開/リモート用のインターフェイスを設定できます。',
    'Switch to Basic Settings' => '基本モードに切り替え',
    'Your blog preferences have been saved.' => 'ブログの設定を保存しました。',
    'Default Settings for New Entries' => 'エントリーを新規に投稿したときの初期値',
    'Specifies the default Post Status when creating a new entry.' => '新規に投稿した際の初期値を選んでください。',
    'Specifies the default Text Formatting option when creating a new entry.' => '投稿内容の改行の変換に関する初期値を選んでください。',
    'Specifies the default Accept Comments setting when creating a new entry.' => 'コメントを受け付ける場合はチェックしてください。',
    'Setting Ignored' => '設定は無視されます',
    'Note: This option is currently ignored since comments are disabled either weblog or system-wide.' => '注: このブログまたはシステム全体で、コメントを受け付けない設定になっており、この設定は有効でありません。',
    'Specifies the default Accept TrackBacks setting when creating a new entry.' => 'トラックバックを受け付ける場合はチェックしてください。',
    'Note: This option is currently ignored since TrackBacks are disabled either weblog or system-wide.' => '注: 本ブログまたはシステム全体で、トラックバックを受け付けない設定になっており、この設定は有効でありません。',
    'Basename Length:' => 'ファイル名の最大長: ',
    'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => '自動生成するエントリーのファイル名の長さ (最大長) を入力してください。15～250の数値を指定できます。',
    'Publicity/Remote Interfaces' => '更新Ping/トラックバックの設定',
    'Notify the following sites upon weblog updates:' => '更新を自動通知する先: ',
    'Others:' => 'その他: ',
    '(Separate URLs with a carriage return.)' => '(複数のURLを入力する場合は、改行してください。)',
    'When this weblog is updated, Movable Type will automatically notify the selected sites.' => 'ブログが更新されたときに、指定したサイトに自動的に通知します。',
    'Setting Notice' => '注: ',
    'Note: The above option may be affected since outbound pings are constrained system-wide.' => '注: システム全体で、トラックバックの送信先を制限しており、影響を受ける場合があります。',
    'Note: This option is currently ignored since outbound pings are disabled system-wide.' => '注: システム全体で、トラックバックを送信しない設定になっており、この設定は有効でありません。',
    'Recently Updated Key:' => 'Recently Updatedキー: ',
    'If you have received a recently updated key (by virtue of your purchase), enter it here.' => 'Recently Updatedキーがある場合、 ここに入力してください。',
    'TrackBack Auto-Discovery' => 'トラックバック自動検知',
    'Enable External TrackBack Auto-Discovery' => '外部のリンクに対するトラックバック自動検知を有効にする',
    'Note: The above option is currently ignored since outbound pings are disabled system-wide.' => '注: システム全体で、トラックバックを送信しない設定になっており、この設定は有効でありません。',
    'Enable Internal TrackBack Auto-Discovery' => '内部のリンクに対するトラックバック自動検知を有効にする',
    'If you turn on auto-discovery, when you write a new post, any external links will be extracted and the appropriate sites automatically sent TrackBacks.' => '自動検知を設定しておくと、新しくエントリーを投稿した際に、リンクをチェックし、見つけたトラックバックURLに送信します。',
    ## tmpl/cms/import_end.tmpl
    'All data imported successfully!' => 'データがすべて読み込まれました。',
    "Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported." => '読み込みの終わったファイルをimportフォルダから削除してください。次回再度読み込みの対象になる危険があります。',
    'An error occurred during the import process: [_1]. Please check your import file.' => '読み込みに失敗しました: [_1]。読み込んだファイルの内容を確認してください。',
    ## tmpl/cms/cfg_archives.tmpl
    'Are you sure you want to delete this template map?' => 'このアーカイブ・マッピングの設定を削除してよろしいですか?',
    'You must set your Local Site Path.' => 'サイト・パスが空欄、もしくは内容に誤りがあります。設定を確認してください。',
    'You must set a valid Site URL.' => '正しいサイトURLを指定してください。',
    'You must set a valid Local Site Path.' => '正しいローカルサイト・パスを指定してください。',
    'This screen allows you to control this weblog\'s publishing paths and preferences, as well as archive mapping settings.' => 'この画面では、このブログのサイトのURL、公開時の設定、およびアーカイブの設定ができます。',
    'Error: Movable Type was not able to create a directory for publishing your weblog. If you create this directory yourself, assign sufficient permissions that allow Movable Type to create files within it.' => 'エラー: ブログ公開用のパスを作成できません。パスを設定する場合は、Movable Typeがそのサイト・パス内にファイルを作成できるように、権限を設定してください。',
    'Your weblog\'s archive configuration has been saved.' => 'アーカイブの設定を保存しました。',
    'You may need to update your templates to account for your new archive configuration.' => 'アーカイブの設定を有効にするために、テンプレートを更新する必要があります。',
    'You have successfully added a new archive-template association.' => 'アーカイブとテンプレートの関連づけが追加されました。',
    'You may need to update your \'Master Archive Index\' template to account for your new archive configuration.' => 'アーカイブの設定を有効にするために、アーカイブページを更新する必要があります。',
    'The selected archive-template associations have been deleted.' => '選択したテンプレートは削除されました。',
    'Publishing Paths' => 'サイトURL/パス',
    'Site URL:' => 'サイトURL: ',
    'Enter the URL of your website. Do not include a filename (i.e. exclude index.html).' => 'このブログを公開するサイトのURLを入力してください。ファイル名 (index.htmlなど) は入力しないでください。',
    'Example:' => '例: ',
    'Enter the path where your index files will be published. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'メインページ (index.html) を置くパス名を入力してください。絶対パス (/で始まる) をお勧めしますが、Movable Typeがインストールされた場所からの相対パスも使えます。',
    'Advanced Archive Publishing:' => 'アーカイブの設定: ',
    'Publish archives to alternate root path' => 'アーカイブを、サイト・パスとは別のパスで公開する場合は、チェックしてください。',
    'Select this option only if you need to publish your archives outside of your Site Root.' => 'アーカイブをサイト・パスとは別のパスで公開する場合に選択してください。',
    'Archive URL:' => 'アーカイブURL: ',
    'Enter the URL of the archives section of your website.' => 'ウェブサイトでアーカイブ・ファイルにアクセスするためのURLを入力してください。',
    'Enter the path where your archive files will be published.' => 'アーカイブ・ファイルを置くパス名を入力してください。',
    'Publishing Preferences' => '公開',
    'Preferred Archive Type:' => 'パーマリンクの設定: ',
    'No Archives' => 'アーカイブはありません',
    'Individual' => 'エントリー',
    'Daily' => '日別',
    'Weekly' => '週別',
    'Monthly' => '月別',
    'When linking to an archived entry&#8212;for a permalink, for example&#8212;you must link to a particular archive type, even if you have chosen multiple archive types.' => 'パーマリンクに利用するアーカイブの種類を選んでください。複数作成していたとしても、特定のアーカイブを選ぶ必要があります。',
    'File Extension for Archive Files:' => 'アーカイブの拡張子: ',
    'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'html、shtml、phpなどを設定できます。先頭の.(ピリオド) は入力しないでください。',
    'Dynamic Publishing:' => '再構築オプション: ',
    'Build all templates statically' => 'すべてをスタティックHTMLで出力します',
    'Build only Archive Templates dynamically' => 'アーカイブのみダイナミック・パブリッシングで出力します',
    'Set each template\'s Build Options separately' => 'テンプレート別に、スタティックHTMLもしくはダイナミック・パブリッシングを選択します',
    'Archive Mapping' => 'アーカイブ・マッピング',
    '_USAGE_ARCHIVE_MAPS' => 'この画面では、各アーカイブに複数のテンプレートを設定することができます。例えば、月別のアーカイブを2つ作り、1つは1か月分のエントリーのリストにして、もう1つは、カレンダーのようにエントリーを見られるようにする、といったことができます。',
    'Create New Archive Mapping' => 'マッピングを新規作成',
    'Archive Type:' => 'アーカイブの種類: ',
    'INDIVIDUAL_ADV' => 'エントリー',
    'DAILY_ADV' => '日別',
    'WEEKLY_ADV' => '週別',
    'MONTHLY_ADV' => '月別',
    'CATEGORY_ADV' => 'カテゴリー',
    'Add' => '追加',
    'Archive Types' => 'アーカイブ種類',
    'Template' => 'テンプレート',
    'Archive File Path' => '出力フォーマット',
    'Preferred' => '優先',
    'Custom...' => 'カスタマイズする',
    'archive map' => 'アーカイブ・マッピング',
    'archive maps' => 'アーカイブ・マッピング',
    ## tmpl/cms/list_ping.tmpl
    '_USAGE_PING_LIST_BLOG' => 'フィルター、管理、および編集可能な[_1]のトラックバック一覧です。',
    '_USAGE_PING_LIST_OVERVIEW' => 'フィルター、管理、および編集可能なすべてのブログのトラックバック一覧です。',
    'The selected TrackBack(s) has been published.' => '選択したトラックバックを公開しました。',
    'All junked TrackBacks have been removed.' => 'すべての迷惑トラックバックは削除されました。',
    'The selected TrackBack(s) has been unpublished.' => '選択したトラックバックを未公開に変更しました。',
    'The selected TrackBack(s) has been junked.' => '選択したトラックバックを迷惑トラックバックに変更しました。',
    'The selected TrackBack(s) has been unjunked.' => '選択したトラックバックを正常なトラックバックに変更しました。',
    'The selected TrackBack(s) has been deleted from the database.' => '選択したトラックバックは、データベースから削除されています。',
    'No TrackBacks appeared to be junk.' => 'どのトラックバックも迷惑トラックバックではないようです。',
    'Junk TrackBacks' => '迷惑トラックバック',
    'Trackback Feed' => 'トラックバック・フィード',
    'Trackback Feed (Disabled)' => 'トラックバック・フィード(無効）',
    'Show unpublished TrackBacks.' => '未公開のトラックバックを表示する',
    '(Showing all TrackBacks.)' => 'すべて (条件を変更する)',
    'Showing only TrackBacks where [_1] is [_2].' => '[_1]が[_2] (条件を変更する)',
    'TrackBacks.' => 'トラックバック',
    'TrackBacks where' => 'トラックバック‐検索条件: ',
    'No TrackBacks could be found.' => 'トラックバックは見つかりません。',
    'No junk TrackBacks could be found.' => '迷惑トラックバックは見つかりません。',
    ## tmpl/cms/rebuild-stub.tmpl
    'To see the changes reflected on your public site, you should rebuild your site now.' => '変更をサイトに反映するには、再構築してください。',
    'Rebuild my site' => 'サイトを再構築',
    ## tmpl/cms/upload_complete.tmpl
    'Upload File' => 'ファイルのアップロード',
    'The file named \'[_1]\' has been uploaded. Size: [quant,_2,byte].' => 'ファイル[_1]をアップロードしました。(サイズ: [quant,_2,バイト,バイト])',
    'Create a new entry using this uploaded file' => 'エントリーを投稿',
    'Show me the HTML' => 'HTMLを表示',
    'Image Thumbnail' => 'サムネイル',
    'Create a thumbnail for this image' => 'この画像のサムネイルを作る',
    'Width:' => '幅: ',
    'Pixels' => 'ピクセル',
    'Percent' => 'パーセント',
    'Height:' => '高さ: ',
    'Constrain proportions' => '縦横比を固定する',
    'Would you like this file to be a:' => 'ファイルの表示方法を選んでください: ',
    'Popup Image' => 'ポップアップ',
    'Embedded Image' => '埋め込み',
    ## tmpl/cms/edit_template.tmpl
    'You have unsaved changes to your template that will be lost.' => '保存されていないテンプレートへの変更は失われてしまいます。',
    'Edit Template' => 'テンプレートを編集',
    'Your template changes have been saved.' => '変更したテンプレートを保存しました。',
    'Rebuild this template' => 'このテンプレートを再構築',
    'Build Options' => '再構築オプション',
    'Enable dynamic building for this template' => 'このテンプレートをダイナミック・ページにする',
    'Rebuild this template automatically when rebuilding index templates' => 'インデックス・テンプレートを再構築するときに、このテンプレートを自動的に再構築する',
    'Comment Listing Template' => 'コメントの一覧',
    'Comment Preview Template' => 'コメント・プレビュー',
    'Search Results Template' => '検索結果',
    'Comment Error Template' => 'コメント・エラー',
    'Comment Pending Template' => 'コメント・保留',
    'Commenter Registration Template' => 'コメント投稿者・登録',
    'TrackBack Listing Template' => 'トラックバックの一覧',
    'Uploaded Image Popup Template' => '画像のポップアップ・ウィンドウ',
    'Dynamic Pages Error Template' => 'ダイナミックページ・エラー',
    'Link this template to a file' => 'このテンプレートにリンクするファイル',
    'Module Body' => 'モジュールの内容',
    'Template Body' => 'テンプレートの内容',
    'Insert...' => '挿入',
    'Save this template (s)' => 'テンプレートを保存 (S)',
    'Save and Rebuild' => '保存と再構築',
    'Save and rebuild this template (r)' => 'テンプレートの保存と再構築 (R)',
    ## tmpl/cms/menu.tmpl
    'Welcome to [_1].' => 'スタート・ページ',
    'You can post to and manage your weblog by selecting an option from the menu located to the left of this message.' => '左側のメニューからブログに投稿したり、管理できます。',
    'If you need assistance, try:' => 'わからなくなったときは、次のリンクを参照してください: ',
    'Movable Type User Manual' => 'Movable Typeのユーザー・マニュアル',
    'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.jp/support',
    'Movable Type Technical Support' => 'Movable Typeテクニカル・サポート',
    'Movable Type Community Forums' => 'Movable Type Community Forums',
    'Change this message.' => 'このメッセージを変更する',
    'Edit this message.' => 'このメッセージを編集する',
    'Here is an overview of [_1].' => '[_1]の概略です。',
    'List Entries' => 'エントリーの一覧',
    'Recent Entries' => '最近のエントリー',
    'List Comments' => 'コメントの一覧',
    'Recent Comments' => '最近のコメント',
    'List TrackBacks' => 'トラックバックの一覧',
    'Recent TrackBacks' => '最近のトラックバック',
    ## tmpl/cms/comment_table.tmpl
    'Comment' => 'コメント',
    'Only show published comments' => '公開のコメントを表示する',
    'Only show pending comments' => '保留のコメントを表示する',
    'Edit this comment' => 'コメントを編集',
    'Blocked' => 'ブロック',
    'Search for comments by this commenter' => 'このコメント投稿者からのコメントを検索',
    'View this entry' => 'エントリーを確認',
    'Show all comments on this entry' => 'このエントリーに関するコメントのみ表示',
    ## tmpl/cms/log_actions.tmpl
    'Reset Activity Log' => 'ログの消去',
    ## tmpl/cms/pending_commenter.tmpl
    ## tmpl/cms/bm_posted.tmpl
    'Your new entry has been saved to [_1]' => '[_1]に新しいエントリーを保存しました',
    ', and it has been posted to your site' => '。エントリーは公開されました',
    '. ' => '',
    'Edit this entry' => 'エントリーを編集',
    ## tmpl/cms/list_template.tmpl
    'Index Templates' => 'インデックス・テンプレート',
    'Index templates produce single pages and can be used to publish Movable Type data or plain files with any type of content. These templates are typically rebuilt automatically upon saving entries, comments and TrackBacks.' => 'インデックス・テンプレートは、Movable Typeのデータ、またはいろいろなコンテンツから1ページを生成し公開します。',
    'Archive Templates' => 'アーカイブ・テンプレート',
    'Archive templates are used for producing multiple pages of the same archive type.  You can create new ones and map them to archive types on the publishing settings screen for this weblog.' => 'アーカイブ・テンプレートは、同一のアーカイブの種類でも異なるページを生成できます。また、新しく作成したアーカイブ・テンプレートに、ブログの公開の設定にあるアーカイブ・マッピング機能を適用すると、異なるアーカイブの種類にマップしたページもできます。',
    'System Templates' => 'システム・テンプレート',
    'System templates specify the layout and style of a small number of dynamic pages which perform specific system functions in Movable Type.' => 'Movable Typeの一部のシステム機能はダイナミック・ページで実行しますが、システム・テンプレートはそのダイナミック・ページのレイアウトとスタイルを指定します。',
    'Template Modules' => 'テンプレート・モジュール',
    'Template modules are mini-templates that produce nothing on their own but instead can be included into other templates.  They are excellent for duplicated content (e.g. header or footer content) and can contain template tags or just static text.' => 'テンプレート・モジュールは、他のテンプレートに挿入して使うモジュールです。ヘッダーやフッターといった共通部分をモジュール化することで、効率よくテンプレートを作成できます。',
    'You have successfully deleted the checked template(s).' => 'チェックしたテンプレートを削除しました。',
    'Your settings have been saved.' => '設定を保存しました。',
    'Indexes' => 'インデックス',
    'System' => 'システム',
    'Modules' => 'モジュール',
    'Go to Publishing Settings' => '公開の設定',
    'Create new index template' => 'テンプレートを新規作成',
    'Create New Index Template' => 'テンプレートを新規作成',
    'Create new archive template' => 'テンプレートを新規作成',
    'Create New Archive Template' => 'テンプレートを新規作成',
    'Create new template module' => 'モジュールを新規作成',
    'Create New Template Module' => 'モジュールを新規作成',
    'No index templates could be found.' => 'インデックス・テンプレートが見つかりません。',
    'No archive templates could be found.' => 'アーカイブ・テンプレートは見つかりません。',
    'Description' => '説明',
    'No template modules could be found.' => 'テンプレート・モジュールは見つかりません。',
    ## tmpl/cms/pager.tmpl
    'Show Display Options' => '画面の表示設定を変更',
    'Display Options' => '表示オプション',
    'Show:' => '表示件数: ',
    '[quant,_1,row]' => '[quant,_1,行,行]',
    'all rows' => 'すべての行',
    'Another amount...' => '行数を指定',
    'View:' => '表示形式: ',
    'Compact' => 'コンパクト',
    'Expanded' => '拡張',
    'Below' => '下',
    'Above' => '上',
    'Both' => '両方',
    'Date Display:' => '日付表示: ',
    'Relative' => '経過時間',
    'Full' => '日付',
    'Open Batch Editor' => '一括編集画面を開く',
    'Newer' => '前へ',
    'Showing:' => '表示件数: ',
    'of' => '/',
    'Older' => '次へ',
    ## tmpl/cms/login.tmpl
    'Your Movable Type session has ended. If you wish to log in again, you can do so below.' => 'ログアウトしました。ログインする場合は、この画面からログインしてください。',
    'Your Movable Type session has ended. Please login again to continue this action.' => 'ログアウトしました。ログインする場合は、この画面からログインしてください。',
    'Log In' => 'ログイン',
    'Forgot your password?' => 'パスワードの再設定',
    ## tmpl/cms/show_upload_html.tmpl
    'Copy and paste this HTML into your entry.' => 'このHTMLをコピーしてエントリーに貼りつけてください。',
    'Upload Another' => '他の画像をアップロードする',
    ## tmpl/cms/list_notification.tmpl
    'Notifications' => '通知',
    'Below is the notification list for this blog. When you manually send notifications on published entries, you can select from this list.' => '以下はこのブログに設定された通知リストです。公開されたエントリーで通知を送信するときにこのリストから選択します。',
    'You have [quant,_1,user,users,no users] in your notification list. To delete an address, check the Delete box and press the Delete button.' => '通知リストに[quant,_1,人,人,0人]登録されています。アドレスを削除するにはチェックして削除ボタンをクリックしてください。',
    'You have added [_1] to your notification list.' => '[_1]を通知リストに追加しました。',
    'You have successfully deleted the selected notifications from your notification list.' => '選んだ通知先を一覧から削除しました。',
    'Create New Notification' => '通知先を新規登録',
    'URL (Optional):' => 'URL (オプション): ',
    'Add Recipient' => '通知先を登録',
    'No notifications could be found.' => '通知先はありません。',
    ## tmpl/cms/entry_prefs.tmpl
    'Entry Editor Display Options' => 'エントリー・エディター表示オプション',
    'Your entry screen preferences have been saved.' => 'エントリーの入力画面の設定を保存しました。',
    'Editor Fields' => 'エディター・フィールド',
    '_USAGE_ENTRYPREFS' => 'エントリーの編集画面に表示されるフィールドの設定ができます。標準的な設定(基本か拡張)、もしくは自分で必要なフィールドを設定できるカスタム を選択してください。',
    'Basic' => '基本',
    'All' => 'すべて',
    'Custom' => 'カスタム',
    'Editable Authored On Date' => '日付を編集',
    'Action Bar' => 'アクション・バー',
    'Select the location of the entry editor\'s action bar.' => 'エントリー・エディターのアクション・バーの位置を選んでください。',
    ## tmpl/cms/footer-popup.tmpl
    ## tmpl/cms/ping_actions.tmpl
    'to publish' => '公開',
    'Publish' => '公開',
    'Publish selected TrackBacks (p)' => '選択したトラックバックを公開 (P)',
    'Delete selected TrackBacks (x)' => '選択されたトラックバックを削除(X)',
    'Junk selected TrackBacks (j)' => '選択したトラックバックを迷惑トラックバックとします (J)',
    'Not Junk' => '解除',
    'Recover selected TrackBacks (j)' => '迷惑トラックバックを解除します (J)',
    'Are you sure you want to remove all junk TrackBacks?' => '迷惑トラックバックをすべて削除してよろしいですか?',
    'Empty Junk Folder' => '「迷惑コメント/トラックバック」を空にする',
    'Deletes all junk TrackBacks' => 'すべての迷惑トラックバックを削除',
    ## tmpl/cms/log_table.tmpl
    'Log Message' => 'ログ・メッセージ',
    'IP: [_1]' => 'IPアドレス: [_1]',
    ## tmpl/cms/blog_actions.tmpl
    'weblog' => 'ブログ',
    'Delete selected weblogs (x)' => '選択されたブログを削除(X)',
    ## tmpl/cms/handshake_return.tmpl
    ## tmpl/cms/notification_actions.tmpl
    'notification address' => '通知先アドレス',
    'notification addresses' => '通知先アドレス',
    'Delete selected notification addresses (x)' => '選択された通知先アドレスを削除(X)',
    ## tmpl/cms/cfg_entries_edit_page.tmpl
    'Default Entry Editor Display Options' => 'エントリー投稿画面の初期設定',
    ## tmpl/cms/list_blog.tmpl
    'Movable Type News' => 'Movable Typeニュース',
    'System Shortcuts' => 'システム・メニュー',
    'Concise listing of weblogs.' => '登録しているブログの一覧です。',
    'Create, manage, set permissions.' => '登録している投稿者の一覧です。',
    'What\'s installed, access to more.' => 'インストールしているプラグインの一覧です。',
    'Multi-weblog entry listing.' => 'すべてのエントリーの一覧です。',
    'Multi-weblog tag listing.' => 'すべてのブログのタグ一覧です。',
    'Multi-weblog comment listing.' => 'すべてのコメントの一覧です。',
    'Multi-weblog TrackBack listing.' => 'すべてのトラックバックの一覧です。',
    'System-wide configuration.' => 'システム全体を設定します。',
    'Search &amp; Replace' => '検索・置換',
    'Find everything. Replace anything.' => '検索・置換ができます。',
    'What\'s been happening.' => 'すべてのログを確認できます。',
    'Status &amp; Info' => '状態と情報',
    'Server status and information.' => 'サーバーの状態と情報。',
    'Set Up A QuickPost Bookmarklet' => 'クイック投稿の設定',
    'Enable one-click publishing.' => 'クイック投稿を使うと、1クリックで投稿できます。',
    'My Weblogs' => 'ブログの一覧',
    'Important:' => '重要: ',
    'Configure this weblog.' => 'はじめにブログを設定してください。',
    'Create a new entry' => 'エントリーを投稿',
    'Create a new entry on this weblog' => 'エントリーを投稿',
    'View Site' => 'サイトを確認',
    'Sort By:' => '並べ替え: ',
    'Weblog Name' => 'ブログ名',
    'Creation Order' => '作成日',
    'Last Updated' => '更新日',
    'Order:' => '表示順序: ',
    'Ascending' => '昇順',
    'Descending' => '降順',
    'You currently have no blogs.' => 'ブログを持っていません。',
    'Please see your system administrator for access.' => 'システム管理者に相談してください。',
    ## tmpl/cms/tag_table.tmpl
    ## tmpl/cms/rebuild_confirm.tmpl
    'Select the type of rebuild you would like to perform. (Click the Cancel button if you do not want to rebuild any files.)' => '再構築する対象を選んでください。再構築を行わない場合は、「取り消し」ボタンを押してください。',
    'Rebuild All Files' => 'すべてを再構築',
    'Index Template: [_1]' => 'インデックス・テンプレート: [_1]',
    'Rebuild Indexes Only' => 'インデックス・テンプレートを再構築',
    'Rebuild [_1] Archives Only' => 'アーカイブのみを再構築: [_1]',
    'Rebuild (r)' => '再構築 (R)',
    ## tmpl/cms/edit_author.tmpl
    'Your Web services password is currently' => '現在のWebサービスのパスワード: ',
    'Author Profile' => '投稿者のプロフィール',
    '_USAGE_PROFILE' => 'プロフィールを編集します。ログイン名、パスワードが編集されたときには、ログイン権限は自動的に更新されます。変更後、再度ログインする必要はありません。',
    '_USAGE_NEW_AUTHOR' => 'この画面では、新規に投稿者を作成し、個々のブログへのアクセス権限を設定できます。<strong>アスタリスク (*) がついている箇所は、必ず入力してください。</strong>',
    'Your profile has been updated.' => 'プロフィールを更新しました。',
    'Weblog Associations' => '関連づけるブログ',
    'General Permissions' => 'システム全体の権限',
    'System Administrator' => 'システム管理者',
    'Create Weblogs' => 'ブログの作成',
    'View Activity Log' => 'ログの参照',
    'Tag Delimiter:' => 'タグ区切り: ',
    'Comma' => 'カンマ',
    'Space' => '空白',
    'Other...' => 'その他: ',
    'The author\'s preferred delimiter for entering tags.' => 'この投稿者が選択した、タグ入力時の区切り文字です。',
    'Current Password:' => '現在のパスワード: ',
    'Enter the existing password to change it.' => '変更前 (現在) のパスワードを入力してください。',
    'New Password:' => '新しいパスワード: ',
    'Initial Password' => '初期パスワード',
    'Select a password for the author.' => '新しいパスワードを入力してください。',
    'Password Confirm:' => 'パスワードを再入力: ',
    'Repeat the password for confirmation.' => '確認のために、パスワードを再度入力してください。',
    'Password recovery word/phrase' => 'パスワード再設定用のフレーズ',
    'This word or phrase will be required to recover your password if you forget it.' => '入力内容はパスワードを忘れて再設定するときに必要になります。',
    'Web Services Password:' => 'Webサービスのパスワード',
    'Reveal' => '内容を表示',
    'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'ログ・フィードやXML-RPC、Atom APIで利用するパスワードです。',
    'Save this author (s)' => '投稿者の情報を保存する',
    ## tmpl/cms/copyright.tmpl
    ## tmpl/cms/cfg_simple.tmpl
    'You must set your Weblog Name.' => 'ブログ名を設定してください。',
    'You must set your Site URL.' => 'サイトURLが空欄、もしくは内容に誤りがあります。設定を確認してください。',
    'You did not select a timezone.' => '時間帯を選んでください。',
    'You can not have spaces in your Site URL.' => 'サイトURLには空白を含められません。',
    'You can not have spaces in your Local Site Path.' => 'ローカルサイト・パスには空白を含められません。',
    'This screen allows you to control all settings specific to this weblog.' => 'この画面では、このブログの設定をすべて設定できます。',
    'Switch to Detailed Settings' => '詳細モードに切り替え',
    'Weblog Settings' => 'ブログの設定',
    'Name your weblog. The weblog name can be changed at any time.' => 'ブログに名前をつけてください。名前はいつでも変更できます。',
    'Enter a description for your weblog.' => 'このブログに対する説明文/紹介文を入力してください。',
    'Timezone:' => '時間帯（タイムゾーン）: ',
    'Time zone not selected' => '時間帯は選択されていません',
    'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13 (トンガ)',
    'UTC+12 (International Date Line East)' => 'UTC+12 (ニュージーランド標準時)',
    'UTC+11' => 'UTC+11 (ニューカレドニア)',
    '    UTC+10 (East Australian Time)' => 'UTC+10 (オーストラリア東部標準時)',
    'UTC+9.5 (Central Australian Time)' => 'UTC+9.5 (中央オーストラリア標準時)',
    'UTC+9 (Japan Time)' => 'UTC+9 (日本標準時)',
    'UTC+8 (China Coast Time)' => 'UTC+8 (中国標準時)',
    'UTC+7 (West Australian Time)' => 'UTC+7 (タイ標準時)',
    'UTC+6.5 (North Sumatra)' => 'UTC+6.5 (ミャンマー標準時)',
    'UTC+6 (Russian Federation Zone 5)' => 'UTC+6 (ロシア第5標準時)',
    'UTC+5.5 (Indian)' => 'UTC+5.5 (インド標準時)',
    'UTC+5 (Russian Federation Zone 4)' => 'UTC+5 (ロシア第4標準時)',
    'UTC+4 (Russian Federation Zone 3)' => 'UTC+4 (ロシア第3標準時)',
    'UTC+3.5 (Iran)' => 'UTC+3.5 (イラン標準時)',
    'UTC+3 (Baghdad Time/Moscow Time)' => 'UTC+3 (モスクワ標準時)',
    'UTC+2 (Eastern Europe Time)' => 'UTC+2 (東ヨーロッパ標準時)',
    'UTC+1 (Central European Time)' => 'UTC+1 (中央ヨーロッパ標準時)',
    'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (協定世界時)',
    'UTC-1 (West Africa Time)' => 'UTC-1 (ポルトガル標準時)',
    'UTC-2 (Azores Time)' => 'UTC-2 (南ジョージア島標準時)',
    'UTC-3 (Atlantic Time)' => 'UTC-3 (ブラジル標準時)',
    'UTC-3.5 (Newfoundland)' => 'UTC-3.5 (ニューファンドランド標準時)',
    'UTC-4 (Atlantic Time)' => 'UTC-4 (アメリカ大西洋標準時)',
    'UTC-5 (Eastern Time)' => 'UTC-5 (アメリカ東部標準時)',
    'UTC-6 (Central Time)' => 'UTC-6 (アメリカ中部標準時)',
    'UTC-7 (Mountain Time)' => 'UTC-7 (アメリカ山岳部標準時)',
    'UTC-8 (Pacific Time)' => 'UTC-8 (アメリカ太平洋標準時)',
    'UTC-9 (Alaskan Time)' => 'UTC-9 (アラスカ標準時)',
    'UTC-10 (Aleutians-Hawaii Time)' => 'UTC-10 (ハワイ標準時)',
    'UTC-11 (Nome Time)' => 'UTC-11 (サモア標準時)',
    'Select your timezone from the pulldown menu.' => '時間帯を選んでください。',
    'You can configure the publishing model for this blog (static vs dynamic) on the ' => '公開方法（スタティックまたはダイナミック）を設定する場合は、',
    'Detailed Settings' => '詳細設定ページ',
    ' page.' => 'に進んでください。',
    'Default Weblog Display Settings' => '表示に関する初期設定',
    'Entries to Display:' => '表示数: ',
    'Days' => '日分',
    'Choose to display a number of recent entries or entries from a recent number of days.' => 'ブログのメインページに表示されるエントリーについて設定します。',
    'Date Language:' => '日付表示用の言語: ',
    'Czech' => 'チェコ語',
    'Danish' => 'デンマーク語',
    'Dutch' => 'オランダ語',
    'English' => '英語',
    'Estonian' => 'エストニア語',
    'French' => 'フランス語',
    'German' => 'ドイツ語',
    'Icelandic' => 'アイスランド語',
    'Italian' => 'イタリア語',
    'Japanese' => '日本語',
    'Norwegian' => 'ノルウェー語',
    'Polish' => 'ポーランド語',
    'Portuguese' => 'ポルトガル語',
    'Slovak' => 'スロヴァキア語',
    'Slovenian' => 'スロヴェニア語',
    'Spanish' => 'スペイン語',
    'Suomi' => 'フィンランド語',
    'Swedish' => 'スウェーデン語',
    'Select the language in which you would like dates on your blog displayed.' => 'ブログに表示する日付の言語を選んでください。',
    'Note: Commenting is currently disabled at the system level.' => '注: システム全体で、コメントを受け付けない設定になっており、この設定は有効でありません。',
    'Comment authentication is not available because one of the needed modules, MIME::Base64 or LWP::UserAgent is not installed. Talk to your host about getting this module installed.' => '認証に必要なモジュールMIME::Base64またはLWP::UserAgentがインストールされていないため、コメントの認証は利用できません。',
    'Accept comments from' => '投稿を受け付ける条件',
    'Anyone' => 'すべて',
    'Authenticated commenters only' => '認証サービスで認証されたコメント投稿者のみ',
    'No one' => 'なし',
    'Specify which types of commenters will be allowed to leave comments on this weblog.' => '誰からのコメントを受け付けるか、条件を選んでください。',
    'Authentication Status' => '認証サービスの設定',
    'Authentication Enabled' => '認証サービスを利用できます',
    'Authentication is enabled.' => '認証サービスを利用できます。',
    'Clear Authentication Token' => '認証用トークンの消去',
    'Authentication Token:' => '認証用トークン: ',
    'Authentication Token Removed' => '認証用トークンが削除されました。',
    'Please click the Save Changes button below to disable authentication.' => '認証サービスを利用しない場合は、下にある「変更を保存」ボタンをクリックしてください。',
    'Authentication Not Enabled' => '認証サービスを利用できません',
    'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => '注: 認証されたコメント投稿者からのコメントのみを受け付ける設定になっていますが、認証に関する設定を完了していません。認証に関する設定を完了してください。',
    'Authentication is not enabled.' => '認証サービスを利用できません。',
    'Setup Authentication' => '認証サービスの設定',
    'Or, manually enter token:' => 'または、認証用トークンを入力します: ',
    'Authentication Token Inserted' => '認証用トークンが入力されました。',
    'Please click the Save Changes button below to enable authentication.' => '認証サービスを利用する場合は、下にある「変更を保存」ボタンをクリックしてください。',
    'If you want to require visitors to sign in before leaving a comment, set up authentication with the free TypeKey service.' => 'コメントの投稿時に署名を要求したい場合は、無料のTypeKeyサービスでの認証を設定してください。',
    'Immediately publish comments from' => '即時に公開するコメント',
    'Trusted commenters only' => 'このブログに登録されたコメント投稿者のみ',
    'Any authenticated commenters' => '認証サービスで認証されたコメント投稿者のみ',
    'Specify what should happen to comments after submission. Unpublished comments are held for moderation and junk comments do not appear.' => '受け付けたコメントを即時に公開する条件を選んでください。 未公開のコメントは、事前確認待ちのものです。',
    'Note: TrackBacks are currently disabled at the system level.' => '注: システム全体で、トラックバックを受け付けない設定になっており、この設定は有効でありません。',
    'Accept TrackBacks from people who link to your weblog.' => 'このブログにリンクしている人からのトラックバックを受信',
    'Moderation' => '事前確認',
    'Hold all TrackBacks for approval before they\'re published.' => '受け付けたトラックバックについて、事前に確認した後に公開する場合は、チェックしてください。',
    'License' => 'ライセンス',
    'Your weblog is currently licensed under:' => '現在のライセンス: ',
    'Change your license' => 'ライセンスを変更する',
    'Remove this license' => 'このライセンスを取り除く',
    'Your weblog does not have an explicit Creative Commons license.' => 'クリエイティブ・コモンズ・ライセンスを設定していません。',
    'Create a license now' => 'ライセンスを設定する',
    'Select a Creative Commons license for the posts on your blog (optional).' => 'エントリーのクリエイティブ・コモンズ・ライセンスを選んでください 。(オプション)',
    'Be sure that you understand these licenses before applying them to your own work.' => 'ライセンスを設定する前に、これらのライセンスを利用することは、あなたの責任になることを理解した上で設定してください。',
    'Read more.' => '詳しくはこちら。',
    ## tmpl/cms/edit_categories.tmpl
    '_USAGE_CATEGORIES' => 'エントリーをわかりやすく整理したり、アーカイブやブログの画面で見やすくできます。エントリーの投稿時だけでなく、編集時でも、カテゴリーを指定できます。サブカテゴリーの作成は、該当するカテゴリーで「作成」をクリックします。また、「移動」をクリックすると、カテゴリーを移動できます。',
    'Your category changes and additions have been made.' => 'カテゴリーの変更と追加を行いました。',
    'You have successfully deleted the selected categories.' => '選択したカテゴリーを削除しました。',
    'Create new top level category' => 'トップレベル・カテゴリーを作成',
    'Actions' => '操作',
    'Create Category' => 'カテゴリーを作成',
    'Top Level' => 'トップレベル',
    'Collapse' => '折りたたむ',
    'Expand' => '展開',
    'Create Subcategory' => 'サブカテゴリーを作成',
    'Create' => '作成',
    'Move Category' => 'カテゴリーの移動',
    'Move' => '移動',
    '[quant,_1,TrackBack]' => '[quant,_1,件,件]',
    'categories' => 'カテゴリー',
    'Delete selected categories (x)' => '選択されたカテゴリを削除(X)',
    ## tmpl/cms/system_list_blog.tmpl
    'Are you sure you want to delete this weblog?' => 'このブログを削除してよろしいですか?',
    'Below you find a list of all weblogs in the system with links to the main weblog page and individual settings pages for each.  You may also create or delete blogs from this screen.' => 'この画面では、すべてのブログを一覧できるほか、ブログを新規に作成したり、削除ができます。ブログ名をクリックすると、スタート・ページが開き、個々のブログの操作ができます。',
    'You have successfully deleted the blogs from the Movable Type system.' => 'ブログをシステムから削除しました。',
    'Create New Weblog' => 'ブログを新規作成',
    'No weblogs could be found.' => 'ブログが見つかりません。',
    ## tmpl/cms/import_start.tmpl
    'Importing...' => '読み込み中...',
    'Importing entries into blog' => 'ブログに記事を読み込んでいます',
    'Importing entries as author \'[_1]\'' => '投稿者名「[_1]」で読み込んでいます。 ',
    'Creating new authors for each author found in the blog' => '読み込む記事に設定されている投稿者を新たに作成します。',
    ## tmpl/cms/commenter_actions.tmpl
    'Trust' => '登録する',
    'to act upon' => '設定',
    'Trust commenter' => '登録する',
    'Untrust' => '登録を解除する',
    'Untrust commenter' => '登録を解除する',
    'Ban' => '禁止する',
    'Ban commenter' => '投稿を禁止する',
    'Unban' => '許可する',
    'Unban commenter' => '投稿を許可する',
    'Trust selected commenters' => '登録する',
    'Ban selected commenters' => '投稿を禁止する',
    ## tmpl/cms/cfg_prefs.tmpl
    'This screen allows you to control general weblog settings, default weblog display settings, and third-party service settings.' => 'この画面では、ブログの基本的な設定、表示に関する初期設定、および他のサービスの設定ができます。',
    'UTC+10 (East Australian Time)' => 'UTC+10 (オーストラリア東部標準時)',
    'Select the number of days\' entries or the exact number of entries you would like displayed on your weblog.' => 'ブログのメインページに表示されるエントリーについて設定します。',
    'Entry Order:' => 'エントリーの表示順: ',
    'Select whether you want your posts displayed in ascending (oldest at top) or descending (newest at top) order.' => 'エントリーを表示する順番を設定してください。昇順 (古いものを一番上にして時系列に並べる) か、降順 (最新のエントリーが常に上に来るように逆順で並べるか) か選んでください。',
    'Comment Order:' => 'コメントの表示順: ',
    'Select whether you want visitor comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'コメントの表示順を、古いもの順か新しいもの順か選んでください。',
    'Excerpt Length:' => '概要にいれる文字数: ',
    'Enter the number of words that should appear in an auto-generated excerpt.' => '概要を自動生成するときの文字数を入力してください。',
    'Limit HTML Tags:' => '許可するHTMLタグ: ',
    'Use defaults' => '標準の設定',
    '([_1])' => '([_1])',
    'Use my settings' => 'カスタム設定',
    'Specifies the list of HTML tags allowed by default when cleaning an HTML string (a comment, for example).' => 'HTMLタグを (コメントなどで) 取り除くとき、許可するHTMLタグを指定します。',
    'Third-Party Services' => '他のサービスの設定',
    ## tmpl/cms/view_log.tmpl
    'Are you sure you want to reset activity log?' => 'ログを消去してもよろしいですか？',
    'The Movable Type activity log contains a record of notable actions in the system.' => 'ログにはシステムの利用記録が保存されています。',
    'All times are displayed in GMT[_1].' => '時刻はすべて協定世界時 (世界標準時) から次の時間分ずれています: [_1]',
    'All times are displayed in GMT.' => '時刻はすべて協定世界時 (世界標準時)です。',
    'The activity log has been reset.' => 'ログを消去しました。',
    'Download CSV' => 'CSVをダウンロード',
    'Show only errors.' => 'エラーのみを表示',
    '(Showing all log records.)' => 'すべて (条件を変更する)',
    'Showing only log records where' => '以下のログ・レコードのみを表示',
    'Filtered CSV' => 'フィルタ済みCSV',
    'Filtered' => 'フィルタ済み',
    'Activity Feed' => 'ログ・フィード',
    'log records.' => 'ログ・レコード',
    'log records where' => 'ログ・レコード',
    'level' => 'レベル',
    'classification' => '分類',
    'Security' => 'セキュリティ',
    'Error' => 'エラー',
    'Information' => '情報',
    'Debug' => 'デバッグ',
    'Security or error' => 'セキュリティまたはエラー',
    'Security/error/warning' => 'セキュリティ/エラー/警告',
    'Not debug' => 'デバッグを含まない',
    'Debug/error' => 'デバッグ/エラー',
    'No log records could be found.' => 'ログ・レコードは見つかりません。',
    ## tmpl/cms/install.tmpl
    'Welcome to Movable Type!' => 'Movable Typeへようこそ',
    'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'インストールされているPerlのバージョン([_1])はサポートされている最低バージョン([_2])よりも低いものです。',
    'Do you want to proceed with the installation anyway?' => '警告を無視してインストールを続行しますか？',
    'Before you can begin blogging, we need to complete your installation by initializing your database.' => 'ブログを始める前に、データベースを初期化してインストール作業を完了する必要があります。',
    'You will need to select a username and password for the administrator account.' => '管理者アカウントのユーザー名とパスワードを設定してください。',
    'Select a password for your account.' => '新しいパスワードを入力してください。',
    'Password recovery word/phrase:' => 'パスワード再設定用のフレーズ:',
    'Finish Install' => 'インストールを続行',
    ## tmpl/cms/edit_admin_permissions.tmpl
    'User can create weblogs' => 'ブログの新規作成',
    'User can view activity log' => 'システム全体のログの参照',
    'Check All' => 'すべてを選択',
    'Uncheck All' => 'すべてを非選択',
    'Unheck All' => 'すべてを非選択',
    'Add user to an additional weblog:' => '投稿者を別のブログに登録する: ',
    'Select a weblog' => 'ブログを選択',
    ## tmpl/cms/comment_actions.tmpl
    'Publish selected comments (p)' => '選択したコメントを公開 (P)',
    'Delete selected comments (x)' => '選択されたコメントを削除(X)',
    'Junk selected comments (j)' => '選択したコメントを迷惑コメントとします (J)',
    'Recover selected comments (j)' => '迷惑コメントを解除します (J)',
    'Are you sure you want to remove all junk comments?' => '迷惑コメントをすべて削除してよろしいですか?',
    'Deletes all junk comments' => 'すべての迷惑コメントを削除',
    ## tmpl/cms/author_table.tmpl
    'Name' => '名前',
    ## tmpl/cms/edit_placements.tmpl
    '_USAGE_PLACEMENTS' => 'エントリーにサブカテゴリーを設定できます。一覧の左側は、エントリーにメイン/サブどちらとも設定されていないカテゴリー、右側はサブカテゴリーとして設定されているカテゴリーです。',
    'The secondary categories for this entry have been updated. You will need to SAVE the entry for these changes to be reflected on your public site.' => 'サブカテゴリーを更新しました。サイトへ変更を反映させるには、エントリーを保存してください。',
    'Categories in your weblog:' => 'ブログのカテゴリー: ',
    'Secondary categories:' => 'サブカテゴリー: ',
    'Assign &gt;&gt;' => '追加 &gt;&gt;',
    '&lt;&lt; Remove' => '&lt;&lt; 削除',
    ## tmpl/cms/edit_commenter.tmpl
    'The commenter has been trusted.' => 'コメント投稿者は登録済みです。',
    'The commenter has been banned.' => 'コメント投稿者は禁止されています。',
    'View all comments with this name' => 'このコメント投稿者によるコメントをすべて表示',
    'Withheld' => '未公開',
    'View all comments with this URL address' => 'このURLからのコメントをすべて表示',
    'View all commenters with this status' => '同じ状態のコメント投稿者をすべて表示',
    ## tmpl/cms/edit_permissions.tmpl
    ## tmpl/cms/overview-left-nav.tmpl
    'List Weblogs' => 'ブログの一覧',
    'List Authors' => '投稿者の一覧',
    'List Plugins' => 'プラグインの一覧',
    'Aggregate' => '一括管理',
    'List Tags' => 'タグの一覧',
    'Configure' => '環境設定',
    'Edit System Settings' => 'システム設定を変更',
    'Utilities' => 'ユーティリティ',
    '_SEARCH_SIDEBAR' => '検索・置換',
    'Show Activity Log' => 'ログの閲覧',
    ## tmpl/cms/recover.tmpl
    'Your password has been changed, and the new password has been sent to your email address ([_1]).' => 'パスワードを変更しました。新しいパスワードは、「[_1]」宛てにメールで送りました。',
    'Enter your Movable Type username:' => 'ログイン名を入力してください: ',
    'Enter your password recovery word/phrase:' => 'パスワード再設定用のフレーズを入力してください: ',
    'Recover' => 'パスワードを再設定',
    ## tmpl/cms/edit_blog.tmpl
    'Your Site URL is not valid.' => 'サイトURLが不正です。',
    'Your Local Site Path is not valid.' => 'ローカルサイト・パスが不正です。',
    'New Weblog Settings' => 'ブログの新規作成',
    'From this screen you can specify the basic information needed to create a weblog.  Once you click the save button, your weblog will be created and you can continue to customize its settings and templates, or just simply start posting.' => 'この画面では、ブログを新しく作成するために必要な基本情報を設定できます。「変更を保存」ボタンをクリックすると、ブログが作成されます。その後引き続き、詳細の設定やテンプレートのカスタマイズをしたり、エントリーを投稿することもできます。',
    'Your weblog configuration has been saved.' => 'ブログの設定を保存しました。',
    'Enter the URL of your public website. Do not include a filename (i.e. exclude index.html).' => 'このブログを公開するサイトのURLを入力してください。ファイル名 (index.htmlなど) は入力しないでください。',
    'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory.' => 'メインページ (index.html) をおくパス名を入力してください。絶対パス (/で始まる) をお勧めしますが、Movable Typeがインストールされた場所からの相対も使えます。',
    ## tmpl/cms/author_actions.tmpl
    'author' => '投稿者',
    'Delete selected authors (x)' => '選択された投稿者を削除(X)',
    ## tmpl/cms/blog-left-nav.tmpl
    'Posting' => '投稿',
    'Community' => 'コミュニティ',
    'List Commenters' => 'コメント投稿者一覧',
    'Edit Notification List' => '通知先を編集',
    'List &amp; Edit Templates' => 'テンプレートの編集',
    'Edit Tags' => 'タグを編集',
    'Edit Weblog Configuration' => 'ブログを設定',
    'Import &amp; Export Entries' => 'エントリーの読み込み/書き出し',
    'Import / Export' => '読み込み/書き出し',
    ## tmpl/cms/header.tmpl
    'Help' => 'ヘルプ',
    'Welcome' => '現在のログイン名: ',
    'Logout' => 'ログアウト',
    'Go to:' => 'ショートカット:',
    'Select a blog' => 'ブログを選択',
    'System-wide listing' => 'システム全体での一覧',
    'Search (q)' => '検索 (Q)',
    ## tmpl/cms/itemset_action_widget.tmpl
    'More actions...' => 'その他の操作...',
    'Go' => 'Go',
    'No actions' => '操作なし',
    ## tmpl/cms/bm_entry.tmpl
    'You must choose a weblog in which to post the new entry.' => 'どのブログに投稿するのかを選択してください。',
    'Select a weblog for this post:' => '投稿先のブログ: ',
    'Send an outbound TrackBack:' => 'トラックバックを送る: ',
    'Select an entry to send an outbound TrackBack:' => 'トラックバックの発信元になるエントリーを選択: ',
    'Accept' => '受け付ける（受信）',
    'You do not have entry creation permission for any weblogs on this installation. Please contact your system administrator for access.' => 'ブログへの投稿に関する権限がありません。システム管理者に相談してください。',
    ## tmpl/cms/upgrade.tmpl
    'Time to Upgrade!' => 'Movable Typeのアップグレード',
    'Do you want to proceed with the upgrade anyway?' => '警告を無視してアップグレードを続行しますか？',
    'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => 'Movable Typeの最新版のインストールが終了しました。次にデータベースのアップグレードを行います。少々お待ちください。',
    'In addition, the following Movable Type plugins require upgrading or installation:' => 'さらに、以下のMovable Typeのプラグインはアップグレードまたはインストールが必要です。',
    'The following Movable Type plugins require upgrading or installation:' => '以下のMovable Typeプラグインはアップグレードまたはインストールが必要です。',
    'Begin Upgrade' => 'アップグレードの開始',
    ## tmpl/cms/list_author.tmpl
    '_USAGE_AUTHORS' => '現在登録された投稿者の一覧です。名前をクリックすると、それぞれの投稿者の権限を編集できます。チェックボックスにチェックしてから「削除」ボタンをクリックすると、投稿者を削除できます。　注:特定のブログに関する権限をはずす場合は、投稿者の権限を編集して、権限をすべて外してください。「削除」ボタンを使うと、投稿者をシステムから削除します。',
    'You have successfully deleted the authors from the Movable Type system.' => '投稿者をMovable Typeのシステムから削除しました。',
    'Created By' => '作成者: ',
    'Last Entry' => '最後の投稿日時',
    ## tmpl/cms/delete_confirm.tmpl
    'Are you sure you want to permanently delete the [quant,_1,author] from the system?' => '[quant,_1,人,人]の投稿者をシステムから完全に削除してよろしいですか?',
    'Are you sure you want to delete the [quant,_1,comment]?' => '[quant,_1,件,件]のコメントを削除してよろしいですか?',
    'Are you sure you want to delete the [quant,_1,TrackBack]?' => '[quant,_1,件,件]のトラックバックを削除してよろしいですか?',
    'Are you sure you want to delete the [quant,_1,entry,entries]?' => '[quant,_1,件,件]のエントリーを削除してよろしいですか?',
    'Are you sure you want to delete the [quant,_1,template]?' => '[quant,_1,件,件]のテンプレートを削除してよろしいですか?',
    'Are you sure you want to delete the [quant,_1,category,categories]? When you delete a category, all entries assigned to that category will be unassigned from that category.' => '[quant,_1,件,件]のカテゴリーを削除してよろしいですか? カテゴリーを削除すると、そのカテゴリーに属するエントリーは、そのカテゴリーが指定されていない状態になります。',
    'Are you sure you want to delete the [quant,_1,template] from the particular archive type(s)?' => 'このアーカイブの種類の[quant,_1,件,件]のテンプレートを削除してよろしいですか?',
    'Are you sure you want to delete the [quant,_1,IP address,IP addresses] from your Banned IP List?' => '[quant,_1,件,件]のアドレスを禁止IPアドレスリストから削除してよろしいですか?',
    'Are you sure you want to delete the [quant,_1,notification address,notification addresses]?' => '[quant,_1,件,件]の通知先メールアドレスを削除してよろしいですか?',
    'Are you sure you want to delete the [quant,_1,blocked item,blocked items]?' => '[quant,_1,件,件]のアイテムを削除してよろしいですか?',
    'Are you sure you want to delete the [quant,_1,weblog]? When you delete a weblog, all of the entries, comments, templates, notifications, and author permissions are deleted along with the weblog itself. Make sure that this is what you want, because this action is permanent.' => '[quant,_1,件,件]のブログを削除してよろしいですか? ブログを削除すると、すべてのエントリー、コメント、テンプレート、通知先のアドレス帳、投稿者の権限の情報も一緒に削除されます。削除すると元に戻せませんから、よく確認してから削除してください。',
    ## tmpl/cms/edit_category.tmpl
    'You must specify a label for the category.' => 'カテゴリーのラベルを指定してください。',
    'Edit Category' => 'カテゴリーを編集',
    'Use this page to edit the attributes of the category [_1]. You can set a description for your category to be used in your public pages, as well as configuring the TrackBack options for this category.' => 'サイトに掲載するカテゴリーの説明や、このカテゴリーへのトラックバックの設定ができます。',
    'Your category changes have been made.' => 'カテゴリーの変更を行いました。',
    'Details' => '詳細',
    'Label' => 'カテゴリー',
    'Unlock this category\'s output filename for editing' => 'このカテゴリーの出力ファイル名を編集するため、ロックを解除します。',
    'Warning: Changing this category\'s basename may break inbound links.' => '警告: 出力ファイル名を変更すると、このページに対して張られたリンクが切断する可能性があります。',
    'Save this category (s)' => 'カテゴリーを保存 (S)',
    'Inbound TrackBacks' => 'トラックバックの受信',
    'If enabled, TrackBacks will be accepted for this category from any source.' => 'このカテゴリーに対し、すべてのトラックバックを受け付ける場合は、チェックしてください。',
    'TrackBack URL for this category' => 'このカテゴリーのトラックバックURL',
    'This is the URL that others will use to send TrackBacks to your weblog. If you wish for anyone to send TrackBacks to your weblog when they have a post specific to this category, post this URL publicly. If you choose to only allow a select group of individuals to TrackBack, send this URL to them privately. To include a list of incoming TrackBacks in your Main Index Template, check the documentation for template tags related to TrackBacks.' => 'この URL は、このカテゴリーのエントリーに対するトラックバックを受け付けるためのものです。受け付けたトラックバックの一覧をメインページのテンプレートで利用したいときは、トラックバックに関連するタグのヘルプを参照してください。',
    'Passphrase Protection' => 'パスワード保護',
    'Optional.' => 'オプション',
    'Outbound TrackBacks' => 'トラックバックの送信',
    'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you post an entry in this category. (Separate URLs with a carriage return.)' => 'このカテゴリーで新規投稿する際に、トラックバックを自動送信する場合は、送信先のURLを入力してください。(複数のURLを入力する場合は改行してください)',
    ## tmpl/cms/edit_ping.tmpl
    'The TrackBack has been approved.' => 'トラックバックは承認されました。',
    'List &amp; Edit TrackBacks' => 'トラックバックの一覧',
    'Junked TrackBack' => '迷惑トラックバック',
    'View all TrackBacks with this status' => '同じ状態のトラックバックをすべて表示',
    'Source Site:' => 'サイト: ',
    'Search for other TrackBacks from this site' => 'このサイトからの別のトラックバックを検索',
    'Source Title:' => 'タイトル: ',
    'Search for other TrackBacks with this title' => '同じタイトルのトラックバックを検索',
    'Search for other TrackBacks with this status' => '同じ状態のトラックバックを検索',
    'Target Entry:' => 'エントリー: ',
    'View all TrackBacks on this entry' => 'このエントリーへのトラックバックをすべて表示',
    'Target Category:' => 'カテゴリー: ',
    'Category no longer exists' => 'カテゴリーは存在しません。',
    'View all TrackBacks on this category' => 'このカテゴリーへのトラックバックをすべて表示',
    'View all TrackBacks posted on this day' => 'この日に受け付けたトラックバックをすべて表示',
    'View all TrackBacks from this IP address' => 'このIPアドレスからのトラックバックをすべて表示',
    'Save this TrackBack (s)' => 'トラックバックを保存 (S)',
    'Delete this TrackBack (x)' => 'このトラックバックを削除(X)',
    ## tmpl/cms/footer.tmpl
    ## tmpl/cms/junk_results.tmpl
    'Find Junk' => '迷惑コメント/トラックバック',
    'The following items may be junk. Uncheck the box next to any items are NOT junk and hit JUNK to continue.' => '迷惑コメント/トラックバックの可能性があります。迷惑コメント等の場合はチェックボックスにチェックし、そうでない場合はチェックボックスのチェックをはずしてください。',
    'To return to the comment list without junking any items, click CANCEL.' => '変更を反映せずにコメントの一覧に戻るには、「取り消し」ボタンをクリックしてください。',
    'Approved' => '承認済',
    'Registered Commenter' => '登録しているコメント投稿者',
    'Return to comment list' => 'コメントの一覧に戻る',
    ## tmpl/cms/list_plugin.tmpl
    'Are you sure you want to reset the settings for this plugin?' => 'このプラグインの設定を初期化しますか?',
    'Disable plugin system?' => 'プラグインの利用をやめますか?',
    'Disable this plugin?' => 'このプラグインの利用をやめますか?',
    'Enable plugin system?' => 'プラグインを利用しますか?',
    'Enable this plugin?' => 'このプラグインを利用しますか?',
    'This screen allows you to control the weblog-level settings of any configurable plugins you\'ve installed.' => 'この画面では、このブログで利用可能なプラグインの設定ができます。',
    'Your plugin settings have been saved.' => 'プラグインの設定を保存しました。',
    'Your plugin settings have been reset.' => 'プラグインの設定を初期化しました。',
    'Your plugins have been reconfigured.' => 'プラグインを再設定しました。',
    'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'プラグインを再設定しました。mod_perl環境下でお使いの場合は、ウェブサーバーを再起動（リスタート）してください。',
    'Registered Plugins' => '登録済みプラグイン',
    '_USAGE_PLUGINS' => 'インストールしているプラグインの一覧です。',
    'Disable Plugins' => 'プラグインを利用しない',
    'Enable Plugins' => 'プラグインを利用する',
    'Failed to Load' => 'ロードに失敗しました。',
    'Disable' => '利用しない',
    'Enabled' => '利用可',
    'Enable' => '利用する',
    'Documentation for [_1]' => 'プラグイン「[_1]」のドキュメント',
    'Documentation' => 'ドキュメント',
    'Author of [_1]' => 'プラグイン作成者',
    'More about [_1]' => '「[_1]」の詳細情報',
    'Support' => 'サポート',
    'Plugin Home' => 'プラグイン・ホーム',
    'Resources' => 'リソース',
    'Show Resources' => 'プラグインについて',
    'Run' => '起動',
    'Run [_1]' => '[_1]を起動',
    'Show Settings' => '設定を表示',
    'Settings for [_1]' => '「[_1]」の設定',
    'Version' => 'バージョン',
    'Resources Provided by [_1]' => '「[_1]」について',
    'Tag Attributes' => 'タグ属性',
    'Text Filters' => 'テキスト・フィルター',
    'Junk Filters' => '迷惑コメント/トラックバック・フィルター',
    '[_1] Settings' => '設定: [_1]',
    'Reset to Defaults' => '初期化',
    'Plugin error:' => 'プラグイン・エラー: ',
    'No plugins with weblog-level configuration settings are installed.' => 'ブログ別に設定するプラグインは見つかりません。',
    'To download more plugins, check out the <a href="http://www.sixapart.com/pronet/plugins/">Six Apart Plugin Directory</a>.' => '<a href="http://www.sixapart.com/pronet/plugins/">プラグイン・ディレクトリ(英語)</a>で、多くのプラグインを紹介しています。',
    ## tmpl/cms/feed_link.tmpl
    'Activity Feed (Disabled)' => 'ログ・フィード(利用不可)',
    ## tmpl/cms/category_add.tmpl
    'Add A Category' => 'カテゴリーを追加する',
    'To create a new category, enter a title in the field below, select a parent category, and click the Add button.' => 'カテゴリーを追加するときは、タイトルを入力した後、親カテゴリーを選択して追加を押してください。',
    'Category Title:' => 'カテゴリーのタイトル: ',
    'Parent Category:' => '親のカテゴリー: ',
    'Save category (s)' => 'カテゴリの保存 (S)',
    ## tmpl/cms/upload_confirm.tmpl
    "A file named '[_1]' already exists. Do you want to overwrite this file?" => 'ファイル[_1]がすでに同フォルダー内に存在しています。上書きしてもよろしいですか？',    'No' => 'いいえ',
    ## tmpl/cms/cfg_feedback.tmpl
    'This screen allows you to control the feedback settings for this weblog, including comments and TrackBacks.' => 'この画面では、コメントやトラックバックなどの設定ができます。',
    'Rebuild indexes' => 'インデックス・テンプレートを再構築',
    'Specify from whom Movable Type shall accept comments on this weblog.' => '誰からのコメントを受け付けるか、条件を選んでください。',
    'Establish a link between your weblog and an authentication service. You may use TypeKey (a free service, available by default) or another compatible service.' => 'TypeKeyまたは互換のコメント認証サービスを利用するための、認証用トークンを入力してください。',
    'Require E-mail Address' => 'メールアドレスの要求',
    'If enabled, visitors must provide a valid e-mail address when commenting.' => 'コメントの投稿時に、名前の他にメールアドレスを入力してもらう場合は、チェックしてください。',
    'Specify what should happen to non-junk comments after submission.' => '受け付けたコメントを即時に公開する条件を選んでください。',
    'Unpublished comments are held for moderation.' => '未公開のコメントは、事前確認待ちのものです。',
    'E-mail Notification' => 'メール通知',
    'On' => '設定する',
    'Only when attention is required' => '公開に承認を必要とするもののみ',
    'Specify when Movable Type should notify you of new comments if at all.' => 'コメントを受け付けたときに、その旨をメールで通知する条件を選んでください。',
    'Allow HTML' => 'HTMLの利用を許可',
    'If enabled, users will be able to enter a limited set of HTML in their comments. If not, all HTML will be stripped out.' => 'コメントの内容について、一部のHTMLタグの利用を許可する場合はチェックしてください。チェックしない場合は、すべてのHTMLタグが利用できなくなります。',
    'Auto-Link URLs' => 'URLを自動的にリンク',
    'If enabled, all non-linked URLs will be transformed into links to that URL.' => '受け付けたコメント内にURLが入力されており、自動的にハイパーリンクにする場合はチェックします。',
    'Specifies the Text Formatting option to use for formatting visitor comments.' => 'コメントの内容の改行の変換に関する初期値を選んでください。 ',
    'If enabled, TrackBacks will be accepted from any source.' => 'すべてのトラックバックを受け付ける場合は、チェックしてください。',
    'Specify when Movable Type should notify you of new TrackBacks if at all.' => 'トラックバックを受け付けたときに、その旨をメールで通知する条件を選んでください。',
    'Junk Score Threshold' => '判断基準値',
    'Less Aggressive' => 'より緩やかに',
    'More Aggressive' => 'より厳しく',
    'Comments and TrackBacks receive a junk score between -10 (complete junk) and +10 (not junk). Feedback with a score which is lower than the threshold shown above will be marked as junk.' => '受け付けたコメントとトラックバックには、迷惑の度合いが評価されます。評価値は、-10 (迷惑度: 最大) から+10 (迷惑度: ゼロ) までの範囲の数値です。指定した判断基準値より低い値のコメントとトラックバックは、迷惑コメント/トラックバックと見なされます。',
    'Auto-Delete Junk' => '自動削除',
    'If enabled, junk feedback will be automatically erased after a number of days.' => '迷惑コメント/トラックバックと判断したものを、指定の日数の後に削除します。',
    'Delete Junk After' => '削除するまでの日数',
    'days' => '日',
    'When an item has been marked as junk for this many days, it is automatically deleted.' => '指定した日数の後に、迷惑コメント/トラックバックと判断したものを削除します。',
    ## tmpl/cms/import.tmpl
    'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => 'Movable Typeや他のウェブログツールからMovable Typeへブログを転送したり、エントリーを書き出して保存しておくことができます。',
    'Import Entries' => 'エントリーの読み込み',
    'Export Entries' => 'エントリーの書き出し',
    'Authorship of imported entries:' => '読み込んだエントリーの投稿者',
    'Import as me' => '自分が投稿したことにする',
    'Preserve original author' => '元の投稿者を保持する',
    'If you choose to preserve the authorship of the imported entries and any of those authors must be created in this installation, you must define a default password for those new accounts.' => '読み込まれたエントリーの投稿者の情報を使う場合、新しい投稿者が作成されることがあります。そのときのために既定のパスワードを指定します。',
    'Default password for new authors:' => '新しい投稿者に設定するパスワード',
    'Upload import file: (optional)' => '読み込むファイルをアップロードする（オプション）',
    'You will be assigned the author of all imported entries.  If you wish the original authors to keep ownership, you must contact your MT system administrator to perform the import so that new authors can be created if necessary.' => '現在の投稿者の情報で読み込みます。元の投稿者名で読み込む場合は、システム管理者に相談し、必要であれば該当する投稿者を事前に作成してから読み込んでください。',
    'Import File Encoding (optional):' => '読み込むファイルの文字コード(オプション)',
    'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Movable Typeは既定で読み込みファイルの文字コードを自動的に検出します。問題が起きたときには、明示的に文字コードを指定することもできます。',
    'Default category for entries (optional):' => 'カテゴリーの初期値 (オプション): ',
    'Select a category' => 'カテゴリーを選ぶ',
    'You can specify a default category for imported entries which have none assigned.' => '読み込まれた投稿に既定のカテゴリーを設定できます（何も指定されていない場合）',
    'Importing from another system?' => 'Movable Type以外のシステムからのインポート',
    'Start title HTML (optional):' => '最初のタイトルHTML (オプション): ',
    'End title HTML (optional):' => '最後のタイトルHTML (オプション): ',
    'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => '元のシステムでタイトルフィールドがない場合には、この設定でエントリーの本文の中からタイトルを指定できます。',
    'Default post status for entries (optional):' => '投稿の状態の初期値 (オプション): ',
    'Select a post status' => '公開設定を選ぶ',
    'If the software you are importing from does not specify a post status in its export file, you can set this as the status to use when importing entries.' => '元のシステムに公開の状態に関する設定がない場合、読み込んだときの設定をここで指定できます。',
    'Import Entries (i)' => 'エントリーの読み込み(I)',
    '_USAGE_EXPORT_1' => 'エントリーの簡単なバックアップ方法が、「エントリーの書き出し」です。書き出したデータを、復旧のために使うこともできます。',
    'Export Entries From [_1]' => '「[_1]」からエントリーを書き出す',
    'Export Entries (e)' => 'エントリーのエクスポート(E)',
    'Export Entries to Tangent' => 'Tangentにエントリーを書き出す',
    '_USAGE_EXPORT_3' => 'このリンクをクリックすると、Tangentサーバーにこのブログのエントリーをすべて書き出せます。Movable TypeにTangent Add-onをインストールしていれば、一回押すだけでエントリーを移すことができ、必要なときにいつでも実行可能です。',
    'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the <code>import</code> folder of your Movable Type directory.' => '読み込むファイルがローカルにある場合にはアップロードできます。また、Movable Typeのインストールディレクトリの下にある<code>import</code>ディレクトリからファイルを読み込むこともできます。',
    '<em><strong>Please Note:</strong> The Movable Type export format is not comprehensive and is not suitable for creating full-fidelity backups. Please see the Movable Type manual for full details.</em>' => '<em><strong>注意:</strong>Movable Typeの書き出しフォーマットは完全なバックアップを作成する機能ではありません。詳しくは操作ガイドを参照してください。</em>',
    ## tmpl/cms/cc_return.tmpl
    ## tmpl/cms/admin.tmpl
    'System Stats' => 'システムの状況',
    'Active Authors' => 'アクティブな投稿者',
    'Essential Links' => 'リンク集',
    'System Information' => 'Movable Type システム・チェック',
    'Movable Type Home' => 'Movable Type ホームページ',
    'Plugin Directory' => 'プラグイン・ディレクトリ',
    'Support and Documentation' => 'サポート ホームページ',
    'https://secure.sixapart.com/t/account' => 'https://secure.sixapart.jp/mt/drp',
    'Your Account' => 'あなたのアカウント',
    'https://secure.sixapart.com/t/help?__mode=edit' => 'https://secure.sixapart.com/t/help?__mode=edit',
    'Open a Help Ticket' => 'Open a Help Ticket',
    'Paid License Required' => 'Paid License Required',
    'http://www.sixapart.com/pronet/plugins/' => 'http://www.sixapart.com/pronet/plugins/',
    'https://secure.sixapart.com/t/help?__mode=kb' => 'http://www.sixapart.jp/support/faq_mt_technical.html',
    'Knowledge Base' => '技術的なよくある質問 (FAQ)',
    'http://www.sixapart.com/pronet/' => 'http://www.sixapart.com/pronet/',
    'Professional Network' => 'ProNet (英語)',
    'From this screen, you can view information about and manage many aspects of your system across all weblogs.' => 'システム全体の各種情報を表示し、変更できます。',
    ## tmpl/cms/bookmarklets.tmpl
    '_USAGE_BOOKMARKLET_3' => '「クイック投稿」をインストールするため、このリンクを、ブラウザのリンクかお気に入りに追加してください : ',
    '_USAGE_BOOKMARKLET_4' => '「クイック投稿」をインストールした後は、ウェブを見ているときはいつでも 投稿できます。投稿したいページを見ているときに「クイック投稿」をクリックすると、編集ウィンドウが開きます。ウィンドウでブログを選んで投稿を押すだけで、エントリーを作成できます。',
    '_USAGE_BOOKMARKLET_5' => '他にも、Windowsでインターネットエクスプローラーを使っているなら、「クイック投稿」をコンテキスト・メニューに追加できます。下のリンクをクリックし、Windowsレジストリの登録エントリーを保存してください。保存したファイルをダブルクリックしてWindowsレジストリに登録します。その後、ブラウザを再起動すると、右クリックで使えます。',
    'Add QuickPost to Windows right-click menu' => '「クイック投稿」をインターネット・エクスプローラー (Windows) のコンテキスト・メニューに追加する',
    '_USAGE_BOOKMARKLET_1' => 'エントリーを、1クリックするだけで投稿し公開できる「クイック投稿」を設定できます。',
    'Configure QuickPost' => '「クイック投稿」を設定する',
    '_USAGE_BOOKMARKLET_2' => 'クイック投稿のレイアウトをカスタマイズできます。例えば、クイック投稿でも概要を追加できます。クイック投稿の標準設定では、投稿するブログを選択するプルダウンメニュー、投稿の状態 (下書きか公開) を選択するプルダウンメニュー、タイトル、エントリーの内容が設定されています。',
    'Include:' => '追加項目: ',
    'TrackBack Items' => 'トラックバックする',
    'Allow Comments' => 'コメントの受信',
    'Allow TrackBacks' => 'トラックバックの受信',
    ## tmpl/cms/upload.tmpl
    'To upload a file to your server, click on the browse button to locate the file on your hard drive.' => 'ファイルをアップロードするには、「参照 (Browse)」ボタンを押して、ファイルを指定してください。',
    'File:' => 'ファイル: ',
    'Set Upload Path' => 'アップロード・パスを設定',
    '(Optional)' => '(オプション)',
    '_USAGE_UPLOAD' => 'サーバーのサイト・パス、もしくはアーカイブ・パスに指定されたディレクトリに、ファイルをアップロードできます。下のフォームに書き足せば、それぞれのディレクトリの下に置くこともできます (例えば <i>images</i> ) 。もし、そのディレクトリがなかったら、自動的に作られます。',
    'Path:' => 'パス: ',
    'Upload' => 'アップロード',
    ## tmpl/cms/upgrade_runner.tmpl
    'Installation complete.' => 'インストールが完了しました。',
    'Upgrade complete.' => 'アップグレードが完了しました。',
    'Initializing database...' => 'データベースを初期化中...',
    'Upgrading database...' => 'データベースをアップグレード中...',
    'Starting installation...' => 'インストールを開始します...',
    'Starting upgrade...' => 'アップグレードを開始します...',
    'Error during installation:' => 'インストール中にエラーが発生しました: ',
    'Error during upgrade:' => 'アップグレード中にエラーが発生しました: ',
    'Installation complete!' => 'インストールが完了しました。',
    'Upgrade complete!' => 'アップグレードが完了しました。',
    'Login to Movable Type' => 'Movable Typeにログインしてください',
    'Return to Movable Type' => 'Movable Typeに戻る',
    'Your database is already current.' => 'データベースは最新の設定です。',
    'Error during upgrade: [_1]' => 'アップグレード中にエラーが発生しました: [_1]',
    ## tmpl/cms/rebuilding.tmpl
    'Rebuilding [_1]' => '再構築中 [_1]',
    'Rebuilding [_1] pages [_2]' => '再構築中 [_1]: [_2]',
    'Rebuilding [_1] dynamic links' => '再構築中 [_1]',
    'Rebuilding [_1] pages' => '再構築中 [_1]',
    ## tmpl/cms/tag_actions.tmpl
    'tag' => 'タグ',
    'Delete selected tags (x)' => '選択されたタグを削除(X)',
    ## tmpl/cms/search_replace.tmpl
    'You must select one or more item to replace.' => '置換対象を1つ以上選択してください。',
    '_USAGE_SEARCH' => 'Movable Type上にあるさまざまなテキストやデータを検索し、一括で置き換えることができます。<p><strong>重要</strong>: 置換するときは注意して使ってください。一度実行すると、<strong>元に戻すことはできません</strong>。',
    'Search Again' => '再検索',
    'Search:' => '検索: ',
    'Replace:' => '置換: ',
    'Replace Checked' => '選択したものを対象に置換',
    'Case Sensitive' => '大文字/小文字を区別する',
    'Regex Match' => '正規表現',
    'Limited Fields' => '項目を指定する',
    'Date Range' => '日付範囲',
    'Is Junk?' => '迷惑コメント/トラックバック',
    'Search Fields:' => '検索対象の項目: ',
    'Comment Text' => 'コメント本文',
    'E-mail Address' => 'メールアドレス',
    'Source URL' => 'URL',
    'Blog Name' => 'ブログ名',
    'Text' => 'テキスト',
    'Output Filename' => '出力ファイル名',
    'Linked Filename' => 'リンク済みファイル名',
    'Display Name' => '表示名',
    'From:' => '開始日: ',
    'To:' => '終了日: ',
    'Replaced [_1] records successfully.' => '[_1]件の置換に成功しました。',
    'No entries were found that match the given criteria.' => '該当するエントリーは見つかりません。',
    'No comments were found that match the given criteria.' => '該当するコメントは見つかりません。',
    'No TrackBacks were found that match the given criteria.' => '該当するトラックバックは見つかりません。',
    'No commenters were found that match the given criteria.' => '該当するコメント投稿者は見つかりません。',
    'No templates were found that match the given criteria.' => '該当するテンプレートは見つかりません。',
    'No log messages were found that match the given criteria.' => '該当するログは見つかりません。',
    'No authors were found that match the given criteria.' => '条件にあった投稿者が見つかりません。',
    'Showing first [_1] results.' => '最初の「[_1]」の結果を表示。',
    'Show all matches' => 'すべての結果を表示',
    '[_1] result(s) found.' => '[_1]件見つかりました。',
    ## tmpl/cms/list_entry.tmpl
    '_USAGE_LIST_POWER' => '「[_1]」のエントリーの一括編集画面です。下のフォームを使うと、画面に表示されているどのエントリーの設定でも変更できます。変更が終わったら、保存を押してください。通常のエントリー編集画面と同様に、フィルタや一画面に表示されるエントリー数を設定することもできます。',
    '_USAGE_ENTRY_LIST_BLOG' => 'フィルター、管理、および編集可能な[_1]のエントリー一覧です。',
    '_USAGE_ENTRY_LIST_OVERVIEW' => 'フィルター、管理、および編集可能なすべてのブログのエントリー一覧です。',
    'Your entry has been deleted from the database.' => 'エントリーをデータベースから削除しました。',
    'Entry Feed' => 'エントリー・フィード',
    'Entry Feed (Disabled)' => 'エントリー・フィード（無効）',
    'Show unpublished entries.' => '未公開 (下書き) のエントリーを表示する',
    '(Showing all entries.)' => 'すべて (条件を変更する)',
    'Showing only entries where [_1] is [_2].' => '[_1]が[_2] (条件を変更する)',
    'entries.' => 'エントリー',
    'entries where' => 'エントリー‐検索条件: ',
    'tag (exact match)' => 'タグ（完全一致）',
    'tag (fuzzy match)' => 'タグ（あいまい検索）',
    'scheduled' => '指定日',
    'No entries could be found.' => 'エントリーは見つかりません。',
);
1;
