# Movable Type (r) Open Source (C) 2005-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
#
# $Id$

package MT::L10N::ja;
use strict;
use utf8;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## php/lib/archive_lib.php
	'Individual' => 'ブログ記事',
	'Page' => 'ウェブページ',
	'Yearly' => '年別',
	'Monthly' => '月別',
	'Daily' => '日別',
	'Weekly' => '週別',
	'Author' => 'ユーザー',
	'(Display Name not set)' => '(表示名なし)',
	'Author Yearly' => 'ユーザー 年別',
	'Author Monthly' => 'ユーザー 月別',
	'Author Daily' => 'ユーザー 日別',
	'Author Weekly' => 'ユーザー 週別',
	'Category Yearly' => 'カテゴリ 年別',
	'Category Monthly' => 'カテゴリ 月別',
	'Category Daily' => 'カテゴリ 日別',
	'Category Weekly' => 'カテゴリ 週別',

## php/lib/block.mtassets.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score"を指定するときはnamespaceも指定しなければなりません。',

## php/lib/block.mtauthorhasentry.php
	'No author available' => 'ユーザーが見つかりません。',

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtentries.php

## php/lib/block.mtif.php
	'You used a [_1] tag without a valid name attribute.' => '[_1]タグではname属性は必須です。',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3]は不正です。',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'\'[_1]\' is not a hash.' => '[_1]はハッシュではありません。',
	'Invalid index.' => '不正なインデックスです。',
	'\'[_1]\' is not an array.' => '[_1]は配列ではありません。',
	'\'[_1]\' is not a valid function.' => '[_1]という関数はサポートされていません。',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => '画像の中に見える文字を入力してください。',

## php/lib/function.mtassettype.php
	'image' => '画像',
	'Image' => '画像',
	'file' => 'ファイル',
	'File' => 'ファイル',
	'audio' => 'オーディオ',
	'Audio' => 'オーディオ',
	'video' => 'ビデオ',
	'Video' => 'ビデオ',

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtcommentauthor.php
	'Anonymous' => '匿名',

## php/lib/function.mtcommentauthorlink.php

## php/lib/function.mtcommentreplytolink.php
	'Reply' => '返信',

## php/lib/function.mtentryclasslabel.php
	'page' => 'ウェブページ',
	'entry' => 'ブログ記事',
	'Entry' => 'ブログ記事',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'ブログでTypePad認証を有効にしていないので、MTRemoteSignInLinkは利用できません。',

## php/lib/function.mtsetvar.php

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '[_1]はハッシュで利用できる関数ではありません。',
	'\'[_1]\' is not a valid function for an array.' => '[_1]は配列で利用できる関数ではありません。',

## php/lib/function.mtwidgetmanager.php
	'Error: widgetset [_1] is empty.' => 'ウィジェットセット[_1]に中身がありません。',
	'Error compiling widgetset [_1]' => 'ウィジェットセット[_1]をコンパイルできませんでした。',

## php/mt.php
	'Page not found - [_1]' => '[_1]が見つかりませんでした。',

## mt-check.cgi
	'Movable Type System Check' => 'Movable Type システムチェック',
	'You have attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'アクセス権がありません。システム管理者に連絡してください。',
	'The MT-Check report is disabled when Movable Type has a valid configuration file (mt-config.cgi)' => '構成ファイル(mt-config.cgi)がすでに存在するため、\'mt-check.cgi\' スクリプトは無効になっています。',
	'The mt-check.cgi script provides you with information on your system\'s configuration and determines whether you have all of the components you need to run Movable Type.' => 'mt-check.cgiはシステムの構成を確認し、Movable Typeを実行するために必要なコンポーネントがそろっていることを確認するためのスクリプトです。',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2].' => 'お使いのシステムにインストールされている Perl [_1] は、Movable Type でサポートされている最低限のバージョン[_2]を満たしていません。Perlをアップグレードしてください。',
	'System Information' => 'システム情報',
	'Movable Type version:' => 'Movable Type バージョン',
	'Current working directory:' => '現在のディレクトリ',
	'MT home directory:' => 'MTディレクトリ',
	'Operating system:' => 'オペレーティングシステム',
	'Perl version:' => 'Perl のバージョン',
	'Perl include path:' => 'Perl の インクルードパス',
	'Web server:' => 'ウェブサーバー',
	'(Probably) Running under cgiwrap or suexec' => 'cgiwrapまたはsuexec環境下で動作していると思われます。',
	'[_1] [_2] Modules' => '[_1]: [_2]モジュール',
	'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that the module provides.' => 'これらのモジュールのインストールは<strong>任意</strong>です。お使いのサーバーにこれらのモジュールがインストールされていない場合でも、Movable Type の基本機能は動作します。これらのモジュールの機能が必要となった場合にはインストールを行ってください。',
	'Some of the following modules are required by the various data storage options in Movable Type. In order run the system, your server needs to have DBI and at least one of the other modules installed.' => 'これらのモジュールは、Movable Type がデータを保存するために必要なモジュールです。DBIと、1つ以上のデータベース用のモジュールをインストールする必要があります。',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => '[_1]がインストールされていないか、インストールされているバージョンが古い、または [_1]の動作に必要な他のモジュールが見つかりません。',
	'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'サーバーに [_1]か、[_1]の動作に必要な他のモジュールがインストールされていません。',
	'Please consult the installation instructions for help in installing [_1].' => '[_1]のインストールはインストールマニュアルに沿って行ってください。',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the current release available from CPAN.' => 'お使いのサーバーにインストールされている DBD::mysqlのバージョンは、Movable Type と互換性がありません。CPAN に公開されている最新バージョンをインストールしてください。',
	'The $mod is installed properly, but requires an updated DBI module. Please see note above regarding the DBI module requirements.' => '$modはインストールされていますが、新しいDBIが必要です。上記を参考に必要なDBIを確認してください。',
	'Your server has [_1] installed (version [_2]).' => 'サーバーに [_1] がインストールされています(バージョン [_2])。',
	'Movable Type System Check Successful' => 'システムのチェックを完了しました。',
	'You\'re ready to go!' => 'Movable Typeを利用できます。',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'お使いのサーバーには、Movable Type の動作に必要なすべてのモジュールがインストールされています。モジュールを追加インストール作業は必要はありません。マニュアルに従い、インストールを続けてください。',
	'CGI is required for all Movable Type application functionality.' => 'CGIは、Movable Type のすべてのアプリケーションの動作に必須です。',
	'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Sizeはファイルのアップロードを行うために必要です。各種のファイル形式に対応して画像のサイズを取得します。',
	'File::Spec is required for path manipulation across operating systems.' => 'File::Specはオペレーティングシステムでパスの操作を行うために必要です。',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookieはcookie 認証のために必要です。',
	'DBI is required to store data in database.' => 'DBIはデータベースにアクセスするために必要です。',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'データを保存するデータベースとして MySQL を利用する場合、DBIと DBD::mysqlが必要です。',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'データを保存するデータベースとして PostgreSQL を利用する場合、DBIと DBD::Pgが必要です。',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'データを保存するデータベースとして SQLite を利用する場合、DBIと DBD::SQLiteが必要です。',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'データを保存するデータベースとして SQLite2.x を利用する場合、DBIと DBD::SQLite2が必要です。',
	'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in the configuration file.' => 'HTML::Entitiesのインストールは必須ではありません。特殊な文字をエンコードするときに必要になりますが、構成ファイルにNoHTMLEntitiesを設定すればこの機能を無効化できます。',
	'LWP::UserAgent is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'LWP::UserAgentのインストールは必須ではありません。トラックバック機能や更新通知機能を利用する場合に必要となります。',
	'HTML::Parser is optional; It is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'HTML::Parserのインストールは必須ではありません。トラックバック機能や更新通知機能を利用する場合に必要となります。',
	'SOAP::Lite is optional; It is needed if you wish to use the MT XML-RPC server implementation.' => 'SOAP::Liteのインストールは必須ではありません。XML-RPC による作業を行う場合に必要となります。',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Tempのインストールは必須ではありません。ファイルのアップロードを行う際に上書きを行う場合は必要となります。',
	'Scalar::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Scalar::Utilのインストールは必須ではありません。再構築キューを利用する場合に必要となります。',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'List::Utilのインストールは必須ではありません。再構築キューを利用する場合に必要となります。',
	'Image::Magick is optional; It is needed if you would like to be able to create thumbnails of uploaded images.' => 'Image::Magickのインストールは必須ではありません。アップロードした画像のサムネイルを作成する場合に必要となります。',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'アップロードした画像のサムネイルを作成する場合に必要となります。',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'MTのイメージドライバとしてNetPBMを利用する場合に必要となります。',
	'Storable is optional; it is required by certain MT plugins available from third parties.' => 'Storableは必須ではありません。外部プラグインの利用の際に必要となる場合があります。',
	'Crypt::DSA is optional; if it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSAのインストールは必須ではありません。インストールされていると、コメント投稿時のサインインが高速になります。',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers such as AOL and Yahoo! which require SSL support.' => 'Crypt::SSLeayはAOLやYahoo!などのSSLを利用するOpenIDのコメント投稿者を認証するために必要となります。',
	'MIME::Base64 is required in order to enable comment registration.' => 'MIME::Base64のインストールは必須ではありません。コメントの認証機能を利用する場合に必要となります。',
	'XML::Atom is required in order to use the Atom API.' => 'XML::Atomのインストールは必須ではありません。Atom APIを利用する場合に必要となります。',
	'Cache::Memcached and memcached server/daemon is required in order to use memcached as caching mechanism used by Movable Type.' => 'Cache::Memcachedのインストールは必須ではありません。Movable Type のキャッシング機能として memcached サーバーを利用する場合に必要となります。',
	'Archive::Tar is required in order to archive files in backup/restore operation.' => 'Archive::Tarのインストールは必須ではありません。バックアップと復元で圧縮の機能を利用する場合に必要となります。',
	'IO::Compress::Gzip is required in order to compress files in backup/restore operation.' => 'IO::Compress::Gzipのインストールは必須ではありません。バックアップと復元で圧縮の機能を利用する場合に必要となります。',
	'IO::Uncompress::Gunzip is required in order to decompress files in backup/restore operation.' => 'IO::Uncompress::Gunzipのインストールは必須ではありません。バックアップと復元で圧縮の機能を利用する場合に必要となります。',
	'Archive::Zip is required in order to archive files in backup/restore operation.' => 'Archive::Zipのインストールは必須ではありません。バックアップと復元で圧縮の機能を利用する場合に必要となります。',
	'XML::SAX and/or its dependencies is required in order to restore.' => 'XML::SAXは復元の機能を利用する場合に必要となります。',
	'Digest::SHA1 and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including Vox and LiveJournal.' => 'Digest::SHA1のインストールは必須ではありませんが、VoxとLiveJournal、あるいはOpenIDでコメント投稿者を認証するために必要になります。',
	'Mail::Sendmail is required for sending mail via SMTP Server.' => 'Mail::SendmailはSMTPサーバーを経由してメールを送信する場合に必要となります。',
	'This module is used in test attribute of MTIf conditional tag.' => 'MTIfタグの機能で使われます。',
	'This module is used by the Markdown text filter.' => 'Markdown形式を利用するために必要です。',
	'This module is required in mt-search.cgi if you are running Movable Type on Perl older than Perl 5.8.' => 'Perl 5.6.1以下の環境で、mt-search.cgiを利用するときに必要です。',
	'This module required for action streams.' => 'アクションストリームを利用するために必要です。',
	'The [_1] database driver is required to use [_2].' => '[_2]を使うには[_1]のデータベースドライバが必要です。',
	'Checking for' => '確認中',
	'Installed' => 'インストール済み',
	'Data Storage' => 'データストレージ',
	'Required' => '必須',
	'Optional' => 'オプション',

## default_templates/about_this_page.mtml
	'About this Entry' => 'このブログ記事について',
	'About this Archive' => 'このアーカイブについて',
	'About Archives' => 'このページについて',
	'This page contains links to all the archived content.' => 'このページには過去に書かれたすべてのコンテンツが含まれています。',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'このページは、[_1]が[_2]に書いたブログ記事です。',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => 'ひとつ前のブログ記事は「<a href="[_1]">[_2]</a>」です。',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => '次のブログ記事は「<a href="[_1]">[_2]</a>」です。',
	'This page is an archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'このページには、<strong>[_2]</strong>以降に書かれたブログ記事のうち<strong>[_1]</strong>カテゴリに属しているものが含まれています。',
	'<a href="[_1]">[_2]</a> is the previous archive.' => '前のアーカイブは<a href="[_1]">[_2]</a>です。',
	'<a href="[_1]">[_2]</a> is the next archive.' => '次のアーカイブは<a href="[_1]">[_2]</a>です。',
	'This page is an archive of recent entries in the <strong>[_1]</strong> category.' => 'このページには、過去に書かれたブログ記事のうち<strong>[_1]</strong>カテゴリに属しているものが含まれています。',
	'<a href="[_1]">[_2]</a> is the previous category.' => '前のカテゴリは<a href="[_1]">[_2]</a>です。',
	'<a href="[_1]">[_2]</a> is the next category.' => '次のカテゴリは<a href="[_1]">[_2]</a>です。',
	'This page is an archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'このページには、<strong>[_1]</strong>が<strong>[_2]</strong>に書いたブログ記事が含まれています。',
	'This page is an archive of recent entries written by <strong>[_1]</strong>.' => 'このページには、<strong>[_1]</strong>が最近書いたブログ記事が含まれています。',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'このページには、<strong>[_2]</strong>に書かれたブログ記事が新しい順に公開されています。',
	'Find recent content on the <a href="[_1]">main index</a>.' => '最近のコンテンツは<a href="[_1]">インデックスページ</a>で見られます。',
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => '最近のコンテンツは<a href="[_1]">インデックスページ</a>で見られます。過去に書かれたものは<a href="[_2]">アーカイブのページ</a>で見られます。',

## default_templates/archive_index.mtml
	'HTML Head' => 'HTMLヘッダー',
	'Archives' => 'アーカイブ',
	'Banner Header' => 'バナーヘッダー',
	'Monthly Archives' => '月別アーカイブ',
	'Categories' => 'カテゴリ',
	'Author Archives' => 'ユーザーアーカイブ',
	'Category Monthly Archives' => '月別カテゴリアーカイブ',
	'Author Monthly Archives' => '月別ユーザーアーカイブ',
	'Sidebar' => 'サイドバー',
	'Banner Footer' => 'バナーフッター',

## default_templates/archive_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'アーカイブの種類に応じて異なる内容を表示するように設定されたウィジェットです。詳細: [_1]',
	'Current Category Monthly Archives' => 'カテゴリ月別アーカイブ',
	'Category Archives' => 'カテゴリアーカイブ',

## default_templates/author_archive_list.mtml
	'Authors' => 'ユーザー',
	'[_1] ([_2])' => '[_1] ([_2])',

## default_templates/banner_footer.mtml
	'_POWERED_BY' => 'Powered by <a href="http://www.sixapart.jp/movabletype/"><$MTProductName$></a>',
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'このブログは<a href="[_1]">クリエイティブ・コモンズ</a>でライセンスされています。',

## default_templates/calendar.mtml
	'Monthly calendar with links to daily posts' => 'リンク付きのカレンダー',
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

## default_templates/category_archive_list.mtml

## default_templates/category_entry_listing.mtml
	'[_1] Archives' => '[_1]アーカイブ',
	'Recently in <em>[_1]</em> Category' => '<em>[_1]</em>の最近のブログ記事',
	'Entry Summary' => 'ブログ記事の概要',
	'Main Index' => 'メインページ',

## default_templates/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1]から<a href="[_2]">[_3]</a>への返信',

## default_templates/comment_listing.mtml
	'Comment Detail' => 'コメント詳細',

## default_templates/comment_preview.mtml
	'Previewing your Comment' => 'コメントのプレビュー',
	'Leave a comment' => 'コメントする',
	'Name' => '名前',
	'Email Address' => '電子メール',
	'URL' => 'URL',
	'Replying to comment from [_1]' => '[_1]からのコメントに返信',
	'Comments' => 'コメント',
	'(You may use HTML tags for style)' => '(スタイル用のHTMLタグを使えます)',
	'Preview' => 'プレビュー',
	'Submit' => '投稿',
	'Cancel' => 'キャンセル',

## default_templates/comment_response.mtml
	'Confirmation...' => '確認',
	'Your comment has been submitted!' => 'コメントを投稿しました。',
	'Thank you for commenting.' => 'コメントありがとうございます。',
	'Your comment has been received and held for approval by the blog owner.' => 'コメントは現在承認されるまで公開を保留されています。',
	'Comment Submission Error' => 'コメント投稿エラー',
	'Your comment submission failed for the following reasons: [_1]' => 'コメントを投稿できませんでした。エラー: [_1]',
	'Return to the <a href="[_1]">original entry</a>.' => '<a href="[_1]">元の記事</a>に戻る',

## default_templates/comment_throttle.mtml
	'If this was a mistake, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, going to Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.' => 'これが間違いである場合は、Movable Typeにログインして、ブログの設定画面に進み、禁止IPリストからIPアドレスを削除してください。',
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => '[_1]を禁止しました。[_2]秒の間に許可された以上のコメントを送信してきました。',
	'This has been done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is' => 'これは悪意のスクリプトがブログをコメントで飽和させるのを阻止するための措置です。以下のIPアドレスを禁止しました。',

## default_templates/commenter_confirm.mtml
	'Thank you registering for an account to comment on [_1].' => '[_1]にコメントするために登録していただきありがとうございます。',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to comment on [_1].' => 'セキュリティ上の理由から、登録を完了する前にアカウントとメールアドレスの確認を行っています。確認を完了次第、[_1]にコメントできるようになります。',
	'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'アカウントの確認のため、次のURLをクリックするか、コピーしてブラウザのアドレス欄に貼り付けてください。',
	'If you did not make this request, or you don\'t want to register for an account to comment on [_1], then no further action is required.' => 'このメールに覚えがない場合や、[_1]に登録するのをやめたい場合は、何もする必要はありません。',
	'Thank you very much for your understanding.' => 'ご協力ありがとうございます。',
	'Sincerely,' => ' ',
	'Mail Footer' => 'メールフッター',

## default_templates/commenter_notify.mtml
	'This email is to notify you that a new user has successfully registered on the blog \'[_1]\'. Listed below you will find some useful information about this new user.' => 'これは新しいユーザーがブログ「[_1]」に登録を完了したことを通知するメールです。新しいユーザーの情報は以下に記載されています。',
	'New User Information:' => '新規登録ユーザー:',
	'Username: [_1]' => 'ユーザー名: [_1]',
	'Full Name: [_1]' => '名前: [_1]',
	'Email: [_1]' => 'メール: [_1]',
	'To view or edit this user, please click on or cut and paste the following URL into a web browser:' => 'このユーザーの情報を見たり編集する場合には、下記のURLをクリックするか、URLをコピーしてブラウザのアドレス欄に貼り付けてください。',

## default_templates/comments.mtml
	'1 Comment' => 'コメント(1)',
	'# Comments' => 'コメント(#)',
	'No Comments' => 'コメント(0)',
	'Previous' => '前',
	'Next' => '次',
	'The data is modified by the paginate script' => 'ページネーションスクリプトによって変更されています。',
	'Remember personal info?' => 'ログイン情報を記憶',

## default_templates/creative_commons.mtml

## default_templates/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1]: 月別アーカイブ',

## default_templates/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## default_templates/date_based_author_archives.mtml
	'Author Yearly Archives' => '年別ユーザーアーカイブ',
	'Author Weekly Archives' => '週別ユーザーアーカイブ',
	'Author Daily Archives' => '日別ユーザーアーカイブ',

## default_templates/date_based_category_archives.mtml
	'Category Yearly Archives' => '年別カテゴリアーカイブ',
	'Category Weekly Archives' => '週別カテゴリアーカイブ',
	'Category Daily Archives' => '日別カテゴリアーカイブ',

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'ページが見つかりません。',

## default_templates/entry.mtml
	'By [_1] on [_2]' => '[_1] ([_2])',
	'1 TrackBack' => 'トラックバック(1)',
	'# TrackBacks' => 'トラックバック(#)',
	'No TrackBacks' => 'トラックバック(0)',
	'Tags' => 'タグ',
	'Trackbacks' => 'トラックバック',

## default_templates/entry_summary.mtml
	'Continue reading <a href="[_1]" rel="bookmark">[_2]</a>.' => '続きを読む: <a href="[_1]" rel="bookmark">[_2]</a>',

## default_templates/footer-email.mtml
	'Powered by Movable Type [_1]' => 'Powered by Movable Type [_1]',

## default_templates/javascript.mtml
	'moments ago' => '直前',
	'[quant,_1,hour,hours] ago' => '[quant,_1,時間,時間]前',
	'[quant,_1,minute,minutes] ago' => '[quant,_1,分,分]前',
	'[quant,_1,day,days] ago' => '[quant,_1,日,日]前',
	'Edit' => '編集',
	'Your session has expired. Please sign in again to comment.' => 'セッションの有効期限が切れています。再度サインインしてください。',
	'Signing in...' => 'サインインします...',
	'You do not have permission to comment on this blog. ([_1]sign out[_2])' => 'このブログにコメントする権限を持っていません。([_1]サインアウトする[_2])',
	'Thanks for signing in, __NAME__. ([_1]sign out[_2])' => '__NAME__としてサインインしています。([_1]サインアウト[_2])',
	'[_1]Sign in[_2] to comment.' => 'コメントするにはまず[_1]サインイン[_2]してください。',
	'[_1]Sign in[_2] to comment, or comment anonymously.' => 'コメントする前に[_1]サインイン[_2]することもできます。',
	'Replying to <a href="[_1]" onclick="[_2]">comment from [_3]</a>' => '<a href="[_1]" onclick="[_2]">[_3]からのコメント</a>に返信',

## default_templates/main_index.mtml

## default_templates/main_index_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'main_indexのテンプレートだけに表示されるように設定されているウィジェットのセットです。詳細: [_1]',
	'Recent Comments' => '最近のコメント',
	'Recent Entries' => '最近のブログ記事',
	'Recent Assets' => 'アイテム',
	'Tag Cloud' => 'タグクラウド',

## default_templates/monthly_archive_dropdown.mtml
	'Select a Month...' => '月を選択...',

## default_templates/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '[_1] <a href="[_2]">アーカイブ</a>',

## default_templates/monthly_entry_listing.mtml

## default_templates/new-comment.mtml
	'An unapproved comment has been posted on your website \'[_1]\', for page #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => '未公開のコメントがウェブサイト \'[_1]\' のウェブページ \'[_3]\' (ID:[_2]) に投稿されました。公開するまでこのコメントはウェブサイトに表示されません。',
	'An unapproved comment has been posted on your blog \'[_1]\', for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => '未公開のコメントがブログ \'[_1]\' のブログ記事 \'[_3]\' (ID:[_2]) に投稿されました。公開するまでこのコメントはブログに表示されません。',
	'An unapproved comment has been posted on your blog \'[_1]\', for page #[_2] ([_3]). You need to approve this comment before it will appear on your site.' => '未公開のコメントがブログ \'[_1]\' のウェブページ \'[_3]\' (ID:[_2]) に投稿されました。公開するまでこのコメントはブログに表示されません。',
	'A new comment has been posted on your website \'[_1]\', on page #[_2] ([_3]).' => 'ウェブサイト \'[_1]\' のウェブページ \'[_3]\' (ID:[_2]) に新しいコメントが投稿されました。',
	'A new comment has been posted on your blog \'[_1]\', on entry #[_2] ([_3]).' => 'ブログ \'[_1]\' のブログ記事 \'[_3]\' (ID:[_2]) に新しいコメントが投稿されました。',
	'A new comment has been posted on your blog \'[_1]\', on page #[_2] ([_3]).' => 'ブログ \'[_1]\' のウェブページ \'[_3]\' (ID:[_2]) に新しいコメントが投稿されました。',
	'Commenter name: [_1]' => 'コメント投稿者: [_1]',
	'Commenter email address: [_1]' => 'メールアドレス: [_1]',
	'Commenter URL: [_1]' => 'URL: [_1]',
	'Commenter IP address: [_1]' => 'IPアドレス: [_1]',
	'Approve comment:' => 'コメントを承認する:',
	'View comment:' => 'コメントを見る:',
	'Edit comment:' => 'コメントを編集する:',
	'Report comment as spam:' => 'コメントをスパムとして報告する:',

## default_templates/new-ping.mtml
	'An unapproved TrackBack has been posted on your website \'[_1]\', for page #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'ウェブサイト \'[_1]\' のウェブページ \'[_3]\' (ID:[_2]) に未公開のトラックバックがあります。公開するまでこのトラックバックはウェブサイトに表示されません。',
	'An unapproved TrackBack has been posted on your blog \'[_1]\', for entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'ブログ \'[_1]\' のブログ記事 \'[_3]\' (ID:[_2]) に未公開のトラックバックがあります。公開するまでこのトラックバックはブログに表示されません。',
	'An unapproved TrackBack has been posted on your blog \'[_1]\', for page #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'ブログ \'[_1]\' のウェブページ \'[_3]\' (ID:[_2]) に未公開のトラックバックがあります。公開するまでこのトラックバックはブログに表示されません。',
	'An unapproved TrackBack has been posted on your blog \'[_1]\', for category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.' => 'ブログ \'[_1]\' のカテゴリ \'[_3]\' (ID:[_2]) に未公開のトラックバックがあります。公開するまでこのトラックバックはブログに表示されません。',
	'A new TrackBack has been posted on your website \'[_1]\', on page #[_2] ([_3]).' => 'ウェブサイト \'[_1]\' のウェブページ \'[_3]\' (ID:[_2]) に新しいトラックバックがあります。',
	'A new TrackBack has been posted on your blog \'[_1]\', on entry #[_2] ([_3]).' => 'ブログ \'[_1]\' のブログ記事 \'[_3]\' (ID:[_2]) に新しいトラックバックがあります。',
	'A new TrackBack has been posted on your blog \'[_1]\', on page #[_2] ([_3]).' => 'ブログ \'[_1]\' のウェブページ \'[_3]\' (ID:[_2]) に新しいトラックバックがあります。',
	'A new TrackBack has been posted on your blog \'[_1]\', on category #[_2] ([_3]).' => 'ブログ \'[_1]\' のカテゴリ \'[_3]\' (ID:[_2]) に新しいトラックバックがあります。',
	'Excerpt' => '概要',
	'Title' => 'タイトル',
	'Blog' => 'ブログ',
	'IP address' => 'IPアドレス',
	'Approve TrackBack' => 'トラックバックを承認する',
	'View TrackBack' => 'トラックバックを見る',
	'Report TrackBack as spam' => 'トラックバックをスパムとして報告する',
	'Edit TrackBack' => 'トラックバックの編集',

## default_templates/notify-entry.mtml
	'A new [lc,_3] entitled \'[_1]\' has been published to [_2].' => '新しい[_3]「[_1]」を[_2]で公開しました。',
	'View entry:' => '表示する',
	'View page:' => '表示する',
	'[_1] Title: [_2]' => 'タイトル: [_2]',
	'Publish Date: [_1]' => '日付: [_1]',
	'Message from Sender:' => 'メッセージ: ',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'このメールは[_1]で新規に作成されたコンテンツに関する通知を送るように設定されているか、またはコンテンツの著者が選択したユーザーに送信されています。このメールを受信したくない場合は、次のユーザーに連絡してください:',

## default_templates/openid.mtml
	'[_1] accepted here' => '[_1]対応しています',
	'http://www.sixapart.com/labs/openid/' => 'http://www.movabletype.jp/openid/',
	'Learn more about OpenID' => 'OpenIDについて',

## default_templates/page.mtml

## default_templates/pages_list.mtml
	'Pages' => 'ウェブページ',

## default_templates/powered_by.mtml
	'_MTCOM_URL' => 'http://www.sixapart.jp/movabletype/',

## default_templates/recent_assets.mtml

## default_templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1]:</strong> [_2] <a href="[_3]" title="[_4]へのコメント">続きを読む</a>',

## default_templates/recent_entries.mtml

## default_templates/recover-password.mtml
	'A request has been made to change your password in Movable Type. To complete this process click on the link below to select a new password.' => 'パスワードをリセットしようとしています。以下のリンクをクリックして、新しいパスワードを設定してください。',
	'If you did not request this change, you can safely ignore this email.' => 'このメールに心当たりがないときは、何もせずに無視してください。',

## default_templates/search.mtml
	'Search' => '検索',
	'Case sensitive' => '大文字/小文字を区別する',
	'Regex search' => '正規表現',

## default_templates/search_results.mtml
	'Search Results' => '検索結果',
	'Results matching &ldquo;[_1]&rdquo;' => '「[_1]」と一致するもの',
	'Results tagged &ldquo;[_1]&rdquo;' => 'タグ「[_1]」が付けられているもの',
	'No results found for &ldquo;[_1]&rdquo;.' => '「[_1]」と一致する結果は見つかりませんでした。',
	'Instructions' => '例',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'すべての単語が順序に関係なく検索されます。フレーズで検索したいときは引用符で囲んでください。',
	'movable type' => 'movable type',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions:' => 'AND、OR、NOTを入れることで論理検索を行うこともできます。',
	'personal OR publishing' => '個人 OR 出版',
	'publishing NOT personal' => '個人 NOT 出版',

## default_templates/sidebar.mtml
	'2-column layout - Sidebar' => '2カラムのサイドバー',
	'3-column layout - Primary Sidebar' => '3カラムのサイドバー(メイン)',
	'3-column layout - Secondary Sidebar' => '3カラムのサイドバー(サブ)',

## default_templates/signin.mtml
	'Sign In' => 'サインイン',
	'You are signed in as ' => 'ユーザー名:',
	'sign out' => 'サインアウト',
	'You do not have permission to sign in to this blog.' => 'このブログにサインインする権限がありません。',

## default_templates/syndication.mtml
	'Subscribe to feed' => '購読する',
	'Subscribe to this blog\'s feed' => 'このブログを購読',
	'Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;' => '「[_1]」の検索結果を購読',
	'Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;' => 'タグ「[_1]」を購読',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'タグ「[_1]」のフィード',
	'Feed of results matching &ldquo;[_1]&ldquo;' => '「[_1]」を検索した結果のフィード',

## default_templates/tag_cloud.mtml

## default_templates/technorati_search.mtml
	'Technorati' => 'Techonrati',
	'<a href=\'http://www.technorati.com/\'>Technorati</a> search' => '<a href=\'http://www.technorati.com/\'>Technorati</a> search',
	'this blog' => 'このブログ',
	'all blogs' => 'すべてのブログ',
	'Blogs that link here' => 'リンクしているブログ',

## default_templates/trackbacks.mtml
	'TrackBack URL: [_1]' => 'トラックバックURL: [_1]',
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '[_3] - <a href="[_1]">[_2]</a> (<a href="[_4]">[_5]</a>)',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">続きを読む</a>',

## default_templates/verify-subscribe.mtml
	'Thanks for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => '[_1]のアップデート通知にご登録いただきありがとうございました。以下のリンクから登録を完了させてください。',
	'If the link is not clickable, just copy and paste it into your browser.' => 'リンクをクリックできない場合は、お使いのウェブブラウザに貼り付けてください。',

## lib/MT.pm
	'Powered by [_1]' => 'Powered by [_1]',
	'Version [_1]' => 'バージョン [_1]',
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.jp/movabletype/',
	'Hello, world' => 'Hello, world',
	'Hello, [_1]' => '[_1]',
	'Got an error: [_1]' => 'エラーが発生しました: [_1]',
	'Message: [_1]' => 'メッセージ: [_1]',
	'If present, 3rd argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'add_callbackの第3引数は(指定する場合は)MT::ComponentまたはMT::Pluginオブジェクトでなければなりません。',
	'4th argument to add_callback must be a CODE reference.' => 'add_callbackの第4引数はCODEへの参照でなければなりません。',
	'Two plugins are in conflict' => 'プラグイン同士が競合しています。',
	'Invalid priority level [_1] at add_callback' => 'add_callbackの優先度レベル[_1]が不正です。',
	'Internal callback' => '内部コールバック',
	'Unnamed plugin' => '(名前なし)',
	'[_1] died with: [_2]' => '[_1]でエラーが発生しました: [_2]',
	'Bad ObjectDriver config' => 'ObjectDriverの設定が不正です。',
	'Bad CGIPath config' => 'CGIPathの設定が不正です。',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => '構成ファイルがありません。mt-config.cgi-originalファイルの名前ををmt-config.cgiに変え忘れていませんか?',
	'Plugin error: [_1] [_2]' => 'プラグインでエラーが発生しました: [_1] [_2]',
	'Load of blog \'[_1]\' failed: [_2]' => 'ブログ(ID:[_1])をロードできませんでした: [_2]',
	'Loading template \'[_1]\' failed.' => 'テンプレート「[_1]」のロードに失敗しました。',
	'http://www.movabletype.org/documentation/' => 'http://www.movabletype.jp/documentation/',
	'An error occurred: [_1]' => 'エラーが発生しました: [_1]',
	'OpenID' => 'OpenID',
	'LiveJournal' => 'LiveJournal',
	'Vox' => 'Vox',
	'Google' => 'Google',
	'Yahoo!' => 'Yahoo!',
	'AIM' => 'AIM',
	'WordPress.com' => 'WordPress.com',
	'TypePad' => 'TypePad',
	'Yahoo! JAPAN' => 'Yahoo! JAPAN',
	'livedoor' => 'ライブドア',
	'Hatena' => 'はてな',
	'Movable Type default' => 'Movable Type 既定',

## lib/MT/App.pm
	'Invalid request' => '不正な要求です。',
	'Invalid request: corrupt character data for character set [_1]' => '不正な要求です。文字コード[_1]に含まれない文字データを送信しています。',
	'Error loading website #[_1] for user provisioning. Check your NewUserefaultWebsiteId setting.' => '新規ユーザー用のウェブサイト(ID:[_1])をロードできませんでした。NewUserTemplateWebsiteIdの設定を確認してください。',
	'First Weblog' => 'First Weblog',
	'Error loading blog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => '新規ユーザー用のブログ(ID:[_1])をロードできませんでした。NewUserTemplateBlogIdの設定を確認してください。',
	'Error provisioning blog for new user \'[_1]\' using template blog #[_2].' => '新規ユーザー\'[_1]\'用のブログを複製元のブログ(ID:[_2])から作成できませんでした。',
	'Error provisioning blog for new user \'[_1] (ID: [_2])\'.' => '新規ユーザー\'[_1]\'用のブログを作成できませんでした。',
	'Blog \'[_1] (ID: [_2])\' for user \'[_3] (ID: [_4])\' has been created.' => '\'[_3]\'(ID:[_4])のブログ\'[_1]\'(ID:[_2])を作成しました。',
	'Error assigning blog administration rights to user \'[_1] (ID: [_2])\' for blog \'[_3] (ID: [_4])\'. No suitable blog administrator role was found.' => '\'[_1]\'(ID:[_2])をブログ\'[_3]\'(ID:[_4])の管理者にできませんでした。ブログの管理権限を持つロールが見つかりませんでした。',
	'Internal Error: Login user is not initialized.' => '内部エラー: ログインユーザーが初期化されていません。',
	'The login could not be confirmed because of a database error ([_1])' => 'データベースのエラーでログインを確認できませんでした: [_1]',
	'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'ブログまたはウェブサイトへのアクセスが許されていません。エラーでこのページが表示された場合は、システム管理者に問い合わせてください。',
	'Can\'t load blog #[_1].' => 'ブログ(ID:[_1])をロードできません。',
	'Invalid login.' => 'ログインできませんでした。',
	'Failed login attempt by unknown user \'[_1]\'' => '未登録のユーザー [_1] がログインしようとしました。',
	'Failed login attempt by disabled user \'[_1]\'' => '無効なユーザー [_1] がログインしようとしました。',
	'This account has been disabled. Please see your system administrator for access.' => 'このアカウントは無効にされています。システム管理者に問い合わせてください。',
	'Failed login attempt by pending user \'[_1]\'' => '保留中のユーザー「[_1]」がログインしようとしました。',
	'This account has been deleted. Please see your system administrator for access.' => 'このアカウントは削除されました。システム管理者に問い合わせてください。',
	'User cannot be created: [_1].' => 'ユーザーを登録できません: [_1]',
	'User \'[_1]\' has been created.' => 'ユーザー「[_1]」が作成されました。',
	'User \'[_1]\' (ID:[_2]) logged in successfully' => 'ユーザー\'[_1]\'(ID[_2])がログインしました。',
	'Invalid login attempt from user \'[_1]\'' => '\'[_1]\'がログインに失敗しました。',
	'User \'[_1]\' (ID:[_2]) logged out' => 'ユーザー\'[_1]\'(ID[_2])がログアウトしました。',
	'User requires password.' => 'パスワードは必須です。',
	'Passwords do not match.' => '入力したパスワードが一致しません。',
	'URL is invalid.' => 'URLが不正です。',
	'User requires display name.' => '表示名は必須です。',
	'[_1] contains an invalid character: [_2]' => '[_1]には不正な文字が含まれています: [_2]',
	'Display Name' => '表示名',
	'Email Address is invalid.' => '不正なメールアドレスです。',
	'Email Address is required for password recovery.' => 'メールアドレスが必要です。',
	'User requires username.' => 'ユーザー名は必須です。',
	'Username' => 'ユーザー名',
	'A user with the same name already exists.' => '同名のユーザーがすでに存在します。',
	'Text entered was wrong.  Try again.' => '入力された文字列が正しくありません。',
	'Something wrong happened when trying to process signup: [_1]' => '登録に失敗しました: [_1]',
	'New Comment Added to \'[_1]\'' => '\'[_1]\'にコメントがありました。',
	'System Email Address is not configured.' => 'システムで利用するメールアドレスが設定されていません。',
	'Close' => '閉じる',
	'Go Back' => '戻る',
	'The file you uploaded is too large.' => 'アップロードしたファイルは大きすぎます。',
	'Unknown action [_1]' => '不明なアクション: [_1]',
	'Permission denied.' => '権限がありません。',
	'Warnings and Log Messages' => '警告とメッセージ',
	'Removed [_1].' => '[_1]を削除しました。',

## lib/MT/App/ActivityFeeds.pm
	'Error loading [_1]: [_2]' => '[_1]をロードできませんでした: [_2]',
	'An error occurred while generating the activity feed: [_1].' => 'ログフィードの生成中にエラーが発生しました: [_1]',
	'No permissions.' => '権限がありません。',
	'[_1] TrackBacks' => '[_1]へのトラックバック',
	'All TrackBacks' => 'すべてのトラックバック',
	'[_1] Comments' => '[_1]へのコメント',
	'All Comments' => 'すべてのコメント',
	'[_1] Entries' => '[_1]のブログ記事',
	'All Entries' => 'すべてのブログ記事',
	'[_1] Activity' => '[_1]のログ',
	'All Activity' => 'すべてのログ',
	'Movable Type System Activity' => 'Movable Typeのシステムログ',
	'Movable Type Debug Activity' => 'Movable Typeのデバッグログ',
	'[_1] Pages' => '[_1]のウェブページ',
	'All Pages' => 'すべてのウェブページ',

## lib/MT/App/CMS.pm
	'_WARNING_PASSWORD_RESET_MULTI' => '選択されたユーザーのパスワードを再設定しようとしています。パスワード再設定用のリンクが直接それぞれのメールアドレスに送られます。実行しますか?',
	'_WARNING_DELETE_USER_EUM' => 'ユーザーを削除すると、そのユーザーの書いたブログ記事はユーザー不明となり、後で取り消せません。ユーザーを無効化してシステムにアクセスできないようにしたい場合は、アカウントを無効化してください。本当にユーザーを削除してもよろしいですか？LDAPディレクトリ上にユーザーがまだ残っている場合、いつでも再作成されてしまいます。',
	'_WARNING_DELETE_USER' => 'ユーザーを削除すると、そのユーザーの書いたブログ記事はユーザー不明となり、後で取り消せません。ユーザーを無効化するのが正しい方法です。本当にユーザーを削除してもよろしいですか?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => '選択されたブログのテンプレートを、各ブログの利用しているテーマの初期状態に戻します。テンプレートを初期化してもよろしいですか?',
	'Only website log' => 'ウェブサイトログのみ',
	'My [_1] of this [_2]' => '[_2]の自分の[_1]',
	'Published [_1]' => '公開されている[_1]',
	'Unpublished [_1]' => '未公開の[_1]',
	'Scheduled [_1]' => '日時指定されている[_1]',
	'My [_1]' => '自分の[_1]',
	'[_1] with comments in the last 7 days' => '最近7日間以内にコメントされた[_1]',
	'[_1] posted between [_2] and [_3]' => '[_2]から[_3]までの間に作成された[_1]',
	'[_1] posted since [_2]' => '[_2]以降に作成された[_1]',
	'[_1] posted on or before [_2]' => '[_2]以前に作成された[_1]',
	'[_1] of this website' => 'ウェブサイト[_1]',
	'Non-spam TrackBacks on this website' => 'ウェブサイトのスパムでないトラックバック',
	'Non-spam Comments on this website' => 'ウェブサイトのスパムでないコメント',
	'Comments on my entries of [_1]' => '[_1]の自分のブログ記事へのコメント',
	'All comments by [_1] \'[_2]\'' => '[_1]\'[_2]\'のコメント',
	'Commenter' => 'コメント投稿者',
	'All comments for [_1] \'[_2]\'' => '[_1]\'[_2]\'へのすべてのコメント',
	'Comments posted between [_1] and [_2]' => '[_1]から[_2]までの間に投稿されたコメント',
	'Comments posted since [_1]' => '[_1]以降に投稿されたコメント',
	'Comments posted on or before [_1]' => '[_1]以前に投稿されたコメント',
	'You are not authorized to log in to this blog.' => 'ブログにログインする権限がありません。',
	'No such blog [_1]' => '[_1]というブログはありません。',
	'Edit Template' => 'テンプレートの編集',
	'Unknown object type [_1]' => '[_1]というオブジェクトはありません。',
	'None' => 'なし',
	'Error during publishing: [_1]' => '公開中にエラーが発生しました: [_1]',
	'This is You' => 'This is You',
	'Movable Type News' => 'Movable Typeニュース',
	'Blog Stats' => 'Blog Stats',
	'Websites' => 'ウェブサイト',
	'Blogs' => 'ブログ',
	'Websites and Blogs' => 'ウェブサイトとブログ',
	'Entries' => 'ブログ記事',
	'Refresh Templates' => 'テンプレート初期化',
	'Use Publishing Profile' => '公開プロファイルを設定',
	'Unpublish Entries' => 'ブログ記事の公開を取り消し',
	'Add Tags...' => 'タグの追加',
	'Tags to add to selected entries' => '追加するタグを入力',
	'Remove Tags...' => 'タグの削除',
	'Tags to remove from selected entries' => '削除するタグを入力',
	'Batch Edit Entries' => 'ブログ記事の一括編集',
	'Unpublish Pages' => 'ウェブページの公開を取り消し',
	'Tags to add to selected pages' => '追加するタグを入力',
	'Tags to remove from selected pages' => '削除するタグを入力',
	'Batch Edit Pages' => 'ウェブページの一括編集',
	'Tags to add to selected assets' => '追加するタグを入力',
	'Tags to remove from selected assets' => '削除するタグを入力',
	'Unpublish TrackBack(s)' => 'トラックバックの公開取り消し',
	'Unpublish Comment(s)' => 'コメントの公開取り消し',
	'Trust Commenter(s)' => 'コメント投稿者を承認',
	'Untrust Commenter(s)' => 'コメント投稿者の承認を解除',
	'Ban Commenter(s)' => 'コメント投稿者を禁止',
	'Unban Commenter(s)' => 'コメント投稿者の禁止を解除',
	'Recover Password(s)' => 'パスワードの再設定',
	'Delete' => '削除',
	'Refresh Template(s)' => 'テンプレートの初期化',
	'Move blog(s) ' => 'ブログの移動',
	'Clone Blog' => 'ブログの複製',
	'Publish Template(s)' => 'テンプレートの再構築',
	'Clone Template(s)' => 'テンプレートの複製',
	'Non-spam TrackBacks' => 'スパムでないトラックバック',
	'Pending TrackBacks' => '保留中のトラックバック',
	'Published TrackBacks' => '公開されているトラックバック',
	'TrackBacks on my entries/pages' => '自分のブログ記事/ウェブページへのトラックバック',
	'TrackBacks in the last 7 days' => '最近7日間以内のトラックバック',
	'Spam TrackBacks' => 'スパムトラックバック',
	'Non-spam Comments' => 'スパムでないコメント',
	'Pending comments' => '保留中のコメント',
	'Published comments' => '公開されているコメント',
	'Comments on my entries/pages' => '自分のブログ記事/ウェブページへのコメント',
	'Comments in the last 7 days' => '最近7日間以内のコメント',
	'Spam Comments' => 'スパムコメント',
	'Tags with entries' => 'ブログ記事のタグ',
	'Tags with pages' => 'ウェブページのタグ',
	'Tags with assets' => 'アイテムのタグ',
	'Enabled Users' => '有効なユーザー',
	'Disabled Users' => '無効なユーザー',
	'Pending Users' => '保留中のユーザー',
	'Commenters' => 'コメント投稿者',
	'Assets' => 'アイテム',
	'Users' => 'ユーザー',
	'Design' => 'デザイン',
	'Settings' => '設定',
	'Tools' => 'ツール',
	'Manage' => '一覧',
	'New' => '新規',
	'Folders' => 'フォルダ',
	'TrackBacks' => 'トラックバック',
	'Templates' => 'テンプレート',
	'Widgets' => 'ウィジェット',
	'Themes' => 'テーマ',
	'General' => '全般',
	'Compose' => '投稿',
	'Feedback' => 'コミュニケーション',
	'Registration' => '登録/認証',
	'Web Services' => 'Webサービス',
	'IP Banning' => '禁止IPアドレス',
	'User' => 'ユーザー',
	'Roles' => 'ロール',
	'Permissions' => '権限',
	'Search &amp; Replace' => '検索/置換',
	'Plugins' => 'プラグイン',
	'Import Entries' => '記事のインポート',
	'Export Entries' => '記事のエクスポート',
	'Export Theme' => 'テーマのエクスポート',
	'Backup' => 'バックアップ',
	'Restore' => '復元',
	'Address Book' => 'アドレス帳',
	'Activity Log' => 'ログ',
	'Create New' => '新規作成',
	'Asset' => 'アイテム',
	'Website' => 'ウェブサイト',

## lib/MT/App/Comments.pm
	'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => '\'[_1]\' (ID:[_2])にブログ\'[_3]\'(ID:[_2])へのコメント権限を与えられませんでした。コメント権限を与えるためのロールが見つかりません。',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => '[_1]がブログ[_2](ID:[_3])にログインしようとしましたが、このブログではMovable Type認証が有効になっていません。',
	'Invalid login' => 'ログインできませんでした。',
	'Successfully authenticated but signing up is not allowed.  Please contact system administrator.' => '認証されましたが、登録は許可されていません。システム管理者に連絡してください。',
	'You need to sign up first.' => '先に登録してください。',
	'Login failed: permission denied for user \'[_1]\'' => 'ログインに失敗しました。[_1]には権限がありません。',
	'Login failed: password was wrong for user \'[_1]\'' => 'ログインに失敗しました。[_1]のパスワードが誤っています。',
	'Signing up is not allowed.' => '登録はできません。',
	'Movable Type Account Confirmation' => 'Movable Type アカウント登録確認',
	'Commenter \'[_1]\' (ID:[_2]) has been successfully registered.' => 'コメント投稿者\'[_1]\'(ID:[_2])が登録されました。',
	'Thanks for the confirmation.  Please sign in to comment.' => '登録ありがとうございます。サインインしてコメントしてください。',
	'[_1] registered to the blog \'[_2]\'' => '[_1]がブログ\'[_2]\'に登録されました。',
	'No id' => 'IDがありません。',
	'No such comment' => 'コメントがありません。',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => '[_1]からのコメントが[_2]秒間に8個続いたため、このIPアドレスを禁止リストに登録しました。',
	'IP Banned Due to Excessive Comments' => '大量コメントによるIP禁止',
	'No entry_id' => 'ブログ記事のIDがありません。',
	'No such entry \'[_1]\'.' => 'ブログ記事\'[_1]\'がありません。',
	'_THROTTLED_COMMENT' => '短い期間にコメントを大量に送りすぎです。しばらくたってからやり直してください。',
	'Comments are not allowed on this entry.' => 'このブログ記事にはコメントできません。',
	'Comment text is required.' => 'コメントを入力していません。',
	'Registration is required.' => '登録しなければなりません。',
	'Name and email address are required.' => '名前とメールアドレスは必須です。',
	'Invalid email address \'[_1]\'' => 'メールアドレス([_1])は不正です。',
	'Invalid URL \'[_1]\'' => 'URL([_1])は不正です。',
	'Comment save failed with [_1]' => 'コメントを保存できませんでした: [_1]',
	'Comment on "[_1]" by [_2].' => '[_2]が\'[_1]\'にコメントしました。',
	'Publish failed: [_1]' => '公開できませんでした: [_1]',
	'Can\'t load template' => 'テンプレートをロードできませんでした。',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'まだ登録を完了していないユーザー\'[_1]\'がコメントしようとしました。',
	'Registered User' => '登録ユーザー',
	'The sign-in attempt was not successful; please try again.' => 'サインインできませんでした。',
	'Can\'t load entry #[_1].' => 'ブログ記事: [_1]をロードできませんでした。',
	'No entry was specified; perhaps there is a template problem?' => 'ブログ記事が指定されていません。テンプレートに問題があるかもしれません。',
	'Somehow, the entry you tried to comment on does not exist' => 'コメントしようとしたブログ記事がありません。',
	'Invalid entry ID provided' => 'ブログ記事のIDが不正です。',
	'All required fields must have valid values.' => '必須フィールドのすべてに正しい値を設定してください。',
	'Commenter profile has successfully been updated.' => 'コメント投稿者のユーザー情報を更新しました。',
	'Commenter profile could not be updated: [_1]' => 'コメント投稿者のユーザー情報を更新できませんでした: [_1]',

## lib/MT/App/NotifyList.pm
	'Please enter a valid email address.' => '正しいメールアドレスを入力してください。',
	'Missing required parameter: blog_id. Please consult the user manual to configure notifications.' => 'blog_idパラメータを指定してください。詳細はユーザーガイドを参照してください。',
	'An invalid redirect parameter was provided. The weblog owner needs to specify a path that matches with the domain of the weblog.' => 'redirectパラメータが不正です。ブログのドメインと一致するパスを指定するように管理者に通知してください。',
	'The email address \'[_1]\' is already in the notification list for this weblog.' => 'メールアドレス([_1])はすでに登録されています。',
	'Please verify your email to subscribe' => '登録するメールアドレスを確認してください。',
	'_NOTIFY_REQUIRE_CONFIRMATION' => '[_1]にメールを送信しました。メールアドレスを認証するため、メールの内容に従って登録を完了してください。',
	'The address [_1] was not subscribed.' => '[_1]は登録されていません。',
	'The address [_1] has been unsubscribed.' => '[_1]の登録を解除しました。',

## lib/MT/App/Search.pm
	'Invalid [_1] parameter.' => '[_1]パラメータが不正です。',
	'Invalid type: [_1]' => '不正なtypeです: [_1]',
	'Invalid request.' => '不正な要求です。',
	'Search: failed storing results in cache.  [_1] is not available: [_2]' => '結果をキャッシュできませんでした。[_1]を利用できません: [_2]',
	'Invalid format: [_1]' => '不正なformatです: [_1]',
	'Unsupported type: [_1]' => '[_1]はサポートされていません。',
	'Invalid query: [_1]' => '不正なクエリーです: [_1]',
	'Invalid archive type' => '不正なアーカイブタイプです',
	'Invalid value: [_1]' => '不正な値です: [_1]',
	'No column was specified to search for [_1].' => '[_1]で検索するカラムが指定されていません。',
	'Search: query for \'[_1]\'' => '検索: [_1]',
	'No alternate template is specified for the Template \'[_1]\'' => '\'[_1]\'に対応するテンプレートがありません。',
	'Opening local file \'[_1]\' failed: [_2]' => '\'[_1]\'を開けませんでした: [_2]',
	'No such template' => 'テンプレートがありません',
	'template_id cannot be a global template' => 'グローバルテンプレートではありません',
	'Output file cannot be asp or php' => 'aspやphpの出力ファイルにはできません',
	'You must pass a valid archive_type with the template_id' => '正しいアーカイブタイプとテンプレートidを指定してください',
	'Template must have identifier entry_listing for non-Index archive types' => 'テンプレートはインデックスでないアーカイブタイプ用の記事リストidを持たなければなりません',
	'Blog file extension cannot be asp or php for these archives' => 'ブログのファイル拡張子はaspやphpにはできません',
	'Template must have identifier main_index for Index archive type' => 'テンプレートはインデックスアーカイブタイプ用のメインインデックスidを持たなければなりません',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'タイムアウトしました。お手数ですが検索をやり直してください。',

## lib/MT/App/Search/Legacy.pm
	'You are currently performing a search. Please wait until your search is completed.' => '連続した検索を抑制しています。しばらく待ってから再度検索してください。',
	'Search failed. Invalid pattern given: [_1]' => '検索に失敗しました。パターンが不正です: [_1]',
	'Search failed: [_1]' => '検索に失敗しました: [_1]',
	'Publishing results failed: [_1]' => '検索結果の作成に失敗しました。',
	'Search: new comment search' => '新しいコメントを検索',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearchはMT::App::Searchと一緒に使います。',

## lib/MT/App/Trackback.pm
	'Invalid entry ID \'[_1]\'' => 'ブログ記事のIDが不正です: [_1]',
	'You must define a Ping template in order to display pings.' => '表示するにはトラックバックテンプレートを定義する必要があります。',
	'Trackback pings must use HTTP POST' => 'Trackback pings must use HTTP POST',
	'Need a TrackBack ID (tb_id).' => 'トラックバックIDが必要です。',
	'Invalid TrackBack ID \'[_1]\'' => 'トラックバックID([_1])が不正です。',
	'You are not allowed to send TrackBack pings.' => 'トラックバック送信を許可されていません。',
	'You are pinging trackbacks too quickly. Please try again later.' => '短い期間にトラックバックを送信しすぎです。少し間をあけてもう一度送信してください。',
	'Need a Source URL (url).' => 'URLが必要です。',
	'This TrackBack item is disabled.' => 'トラックバックは無効に設定されています。',
	'This TrackBack item is protected by a passphrase.' => 'トラックバックはパスワードで保護されています。',
	'TrackBack on "[_1]" from "[_2]".' => '[_2]から\'[_1]\'にトラックバックがありました。',
	'TrackBack on category \'[_1]\' (ID:[_2]).' => 'カテゴリ\'[_1]\'にトラックバックがありました。',
	'Can\'t create RSS feed \'[_1]\': ' => 'フィード([_1])を作成できません: ',
	'New TrackBack Ping to Entry [_1] ([_2])' => 'ブログ記事\'[_2]\'(ID: [_1])への新しいトラックバック',
	'New TrackBack Ping to Category [_1] ([_2])' => 'カテゴリ\'[_2]\'(ID: [_1])への新しいトラックバック',

## lib/MT/App/Upgrader.pm
	'Could not authenticate using the credentials provided: [_1].' => '提供されている手段による認証ができません: [_1]',
	'Both passwords must match.' => 'パスワードが一致しません。',
	'You must supply a password.' => 'パスワードを設定してください。',
	'The \'Publishing Path\' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click \'Finish Install\' again.' => '\'公開パス\'にウェブサーバーから書き込めません。公開パスの書き込み権限を、正しく設定してから再度、インストールボタンをクリックしてください。',
	'Invalid session.' => 'セッションが不正です。',
	'No permissions. Please contact your administrator for upgrading Movable Type.' => '権限がありません。Movable Typeのアップグレードを管理者に依頼してください。',
	'Movable Type has been upgraded to version [_1].' => 'Movable Typeをバージョン[_1]にアップグレードしました。',

## lib/MT/App/Viewer.pm
	'Loading blog with ID [_1] failed' => 'Loading blog with ID [_1] failed',
	'Template publishing failed: [_1]' => 'Template publishing failed: [_1]',
	'Invalid date spec' => 'Invalid date spec',
	'Can\'t load templatemap' => 'Can\'t load templatemap',
	'Can\'t load template [_1]' => 'Can\'t load template [_1]',
	'Archive publishing failed: [_1]' => 'Archive publishing failed: [_1]',
	'Invalid entry ID [_1]' => 'Invalid entry ID [_1]',
	'Entry [_1] is not published' => 'Entry [_1] is not published',
	'Invalid category ID \'[_1]\'' => 'Invalid category ID \'[_1]\'',

## lib/MT/App/Wizard.pm
	'The [_1] driver is required to use [_2].' => '[_2]を使うには[_1]のドライバが必要です。',
	'An error occurred while attempting to connect to the database.  Check the settings and try again.' => 'データベースに接続できませんでした。設定を見直してもう一度接続してください。',
	'Please select database from the list of database and try again.' => 'データベースのリストからデータベースを選択して、やり直してください。',
	'SMTP Server' => 'SMTPサーバー',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Movable Type構成ウィザードからのテスト送信',
	'This is the test email sent by your new installation of Movable Type.' => 'Movable Typeのインストール中に送信されたテストメールです。',
	'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.' => '特殊な文字をエンコードするときに必要になりますが、構成ファイルにNoHTMLEntitiesを設定すればこの機能を無効化できます。',
	'This module is needed if you wish to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'トラックバック機能や更新通知機能を利用する場合に必要となります。',
	'This module is needed if you wish to use the MT XML-RPC server implementation.' => 'XML-RPC による作業を行う場合に必要となります。',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'ファイルのアップロードを行う際に上書きを行う場合は必要となります。',
	'This module is required by certain MT plugins available from third parties.' => '外部プラグインの利用の際に必要となる場合があります。',
	'This module accelerates comment registration sign-ins.' => 'コメント投稿時のサインインが高速になります。',
	'This module is needed to enable comment registration.' => 'コメントの認証機能を利用する場合に必要となります。',
	'This module enables the use of the Atom API.' => 'Atom APIを利用する場合に必要となります。',
	'This module is required in order to archive files in backup/restore operation.' => 'バックアップと復元で圧縮の機能を利用する場合に必要となります。',
	'This module is required in order to compress files in backup/restore operation.' => 'バックアップと復元で圧縮の機能を利用する場合に必要となります。',
	'This module is required in order to decompress files in backup/restore operation.' => 'バックアップと復元で圧縮の機能を利用する場合に必要となります。',
	'This module and its dependencies are required in order to restore from a backup.' => '復元の機能を利用する場合に必要となります。',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including Vox and LiveJournal.' => 'VoxとLiveJournal、あるいはOpenIDでコメント投稿者を認証するために必要になります。',
	'This module is required for sending mail via SMTP Server.' => 'SMTPサーバーを経由してメールを送信する場合に必要になります。',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'ファイルのアップロードを行うために必要です。各種のファイル形式に対応して画像のサイズを取得します。',
	'This module is required for cookie authentication.' => 'cookie 認証のために必要です。',

## lib/MT/ArchiveType/Author.pm
	'AUTHOR_ADV' => 'ユーザー別',
	'author/author-display-name/index.html' => 'author/author-display-name/index.html',
	'author/author_display_name/index.html' => 'author/author_display_name/index.html',

## lib/MT/ArchiveType/AuthorDaily.pm
	'AUTHOR-DAILY_ADV' => 'ユーザー-日別',
	'author/author-display-name/yyyy/mm/dd/index.html' => 'author/author-display-name/yyyy/mm/dd/index.html',
	'author/author_display_name/yyyy/mm/dd/index.html' => 'author/author_display_name/yyyy/mm/dd/index.html',

## lib/MT/ArchiveType/AuthorMonthly.pm
	'AUTHOR-MONTHLY_ADV' => 'ユーザー-月別',
	'author/author-display-name/yyyy/mm/index.html' => 'author/author-display-name/yyyy/mm/index.html',
	'author/author_display_name/yyyy/mm/index.html' => 'author/author_display_name/yyyy/mm/index.html',

## lib/MT/ArchiveType/AuthorWeekly.pm
	'AUTHOR-WEEKLY_ADV' => 'ユーザー-週別',
	'author/author-display-name/yyyy/mm/day-week/index.html' => 'author/author-display-name/yyyy/mm/day-week/index.html',
	'author/author_display_name/yyyy/mm/day-week/index.html' => 'author/author_display_name/yyyy/mm/day-week/index.html',

## lib/MT/ArchiveType/AuthorYearly.pm
	'AUTHOR-YEARLY_ADV' => 'ユーザー-年別',
	'author/author-display-name/yyyy/index.html' => 'author/author-display-name/yyyy/index.html',
	'author/author_display_name/yyyy/index.html' => 'author/author_display_name/yyyy/index.html',

## lib/MT/ArchiveType/Category.pm
	'CATEGORY_ADV' => 'カテゴリ',
	'category/sub-category/index.html' => 'category/sub-category/index.html',
	'category/sub_category/index.html' => 'category/sub_category/index.html',

## lib/MT/ArchiveType/CategoryDaily.pm
	'CATEGORY-DAILY_ADV' => 'カテゴリ-日別',
	'category/sub-category/yyyy/mm/dd/index.html' => 'category/sub-category/yyyy/mm/dd/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'category/sub_category/yyyy/mm/dd/index.html',

## lib/MT/ArchiveType/CategoryMonthly.pm
	'CATEGORY-MONTHLY_ADV' => 'カテゴリ-月別',
	'category/sub-category/yyyy/mm/index.html' => 'category/sub-category/yyyy/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'category/sub_category/yyyy/mm/index.html',

## lib/MT/ArchiveType/CategoryWeekly.pm
	'CATEGORY-WEEKLY_ADV' => 'カテゴリ-週別',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'category/sub-category/yyyy/mm/day-week/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'category/sub_category/yyyy/mm/day-week/index.html',

## lib/MT/ArchiveType/CategoryYearly.pm
	'CATEGORY-YEARLY_ADV' => 'カテゴリ-年別',
	'category/sub-category/yyyy/index.html' => 'category/sub-category/yyyy/index.html',
	'category/sub_category/yyyy/index.html' => 'category/sub_category/yyyy/index.html',

## lib/MT/ArchiveType/Daily.pm
	'DAILY_ADV' => '日別',
	'yyyy/mm/dd/index.html' => 'yyyy/mm/dd/index.html',

## lib/MT/ArchiveType/Individual.pm
	'INDIVIDUAL_ADV' => 'ブログ記事',
	'yyyy/mm/entry-basename.html' => 'yyyy/mm/entry-basename.html',
	'yyyy/mm/entry_basename.html' => 'yyyy/mm/entry_basename.html',
	'yyyy/mm/entry-basename/index.html' => 'yyyy/mm/entry-basename/index.html',
	'yyyy/mm/entry_basename/index.html' => 'yyyy/mm/entry_basename/index.html',
	'yyyy/mm/dd/entry-basename.html' => 'yyyy/mm/dd/entry-basename.html',
	'yyyy/mm/dd/entry_basename.html' => 'yyyy/mm/dd/entry_basename.html',
	'yyyy/mm/dd/entry-basename/index.html' => 'yyyy/mm/dd/entry-basename/index.html',
	'yyyy/mm/dd/entry_basename/index.html' => 'yyyy/mm/dd/entry_basename/index.html',
	'category/sub-category/entry-basename.html' => 'category/sub-category/entry-basename.html',
	'category/sub-category/entry-basename/index.html' => 'category/sub-category/entry-basename/index.html',
	'category/sub_category/entry_basename.html' => 'category/sub_category/entry_basename.html',
	'category/sub_category/entry_basename/index.html' => 'category/sub_category/entry_basename/index.html',

## lib/MT/ArchiveType/Monthly.pm
	'MONTHLY_ADV' => '月別',
	'yyyy/mm/index.html' => 'yyyy/mm/index.html',

## lib/MT/ArchiveType/Page.pm
	'PAGE_ADV' => 'ウェブページ',
	'folder-path/page-basename.html' => 'folder-path/page-basename.html',
	'folder-path/page-basename/index.html' => 'folder-path/page-basename/index.html',
	'folder_path/page_basename.html' => 'folder_path/page_basename.html',
	'folder_path/page_basename/index.html' => 'folder_path/page_basename/index.html',

## lib/MT/ArchiveType/Weekly.pm
	'WEEKLY_ADV' => '週別',
	'yyyy/mm/day-week/index.html' => 'yyyy/mm/day-week/index.html',

## lib/MT/ArchiveType/Yearly.pm
	'YEARLY_ADV' => '年別',
	'yyyy/index.html' => 'yyyy/index.html',

## lib/MT/Asset.pm
	'Could not remove asset file [_1] from filesystem: [_2]' => 'アイテムのファイル[_1]をファイルシステム上から削除できませんでした: [_2]',
	'Description' => '説明',
	'Location' => '場所',

## lib/MT/Asset/Audio.pm

## lib/MT/Asset/Image.pm
	'Images' => '画像',
	'Actual Dimensions' => '実サイズ',
	'[_1] x [_2] pixels' => '[_1] x [_2] ピクセル',
	'Error cropping image: [_1]' => '画像をトリミングできませんでした: [_1]',
	'Error scaling image: [_1]' => '画像のサイズを変更できませんでした: [_1]',
	'Error converting image: [_1]' => '画像を変換できませんでした: [_1]',
	'Error creating thumbnail file: [_1]' => 'サムネールを作成できませんでした: [_1]',
	'%f-thumb-%wx%h-%i%x' => '%f-thumb-%wx%h-%i%x',
	'Can\'t load image #[_1]' => 'ID:[_1]の画像をロードできませんでした。',
	'View image' => '表示',
	'Permission denied setting image defaults for blog #[_1]' => 'ブログ(ID:[_1])に画像に関する既定値を保存する権限がありません。',
	'Thumbnail image for [_1]' => '[_1]のサムネール画像',
	'Invalid basename \'[_1]\'' => 'ファイル名\'[_1]\'は不正です。',
	'Error writing to \'[_1]\': [_2]' => '\'[_1]\'に書き込めませんでした: [_2]',
	'Popup Page for [_1]' => '[_1]のポップアップページ',

## lib/MT/Asset/Video.pm
	'Videos' => 'ビデオ',

## lib/MT/Association.pm
	'Association' => '関連付け',
	'Associations' => '関連付け',
	'association' => '関連付け',
	'associations' => '関連付け',

## lib/MT/AtomServer.pm
	'[_1]: Entries' => '[_1]: ブログ記事一覧',
	'Invalid blog ID \'[_1]\'' => 'ブログIDが不正です([_1])。',
	'PreSave failed [_1]' => 'PreSaveでエラーがありました: [_1]',
	'User \'[_1]\' (user #[_2]) added [lc,_4] #[_3]' => '[_1] (ID: [_2])が[_4] (ID: [_3])を追加しました。',
	'User \'[_1]\' (user #[_2]) edited [lc,_4] #[_3]' => '[_1] (ID: [_2])が[_4] (ID: [_3])を編集しました。',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from atom api' => '[_1]記事([lc,_5]#[_2])は[_3](ID: [_4])によって削除されました。',
	'The file([_1]) you uploaded is not allowed.' => 'ファイル([_1])のアップロードは許可されていません。',
	'Saving [_1] failed: [_2]' => '[_1]を保存できませんでした: [_2]',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Image::Sizeをインストールしないと、画像の幅と高さを検出できません。',

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'AuthenticationModule([_1])の設定が正しくありません: [_2]',
	'Bad AuthenticationModule config' => 'AuthenticationModuleの設定が正しくありません',

## lib/MT/Auth/MT.pm
	'Failed to verify current password.' => '現在のパスワードを確認できません。',

## lib/MT/Auth/OpenID.pm
	'Couldn\'t save the session' => 'セッションを保存できませんでした。',
	'Could not load Net::OpenID::Consumer.' => 'Net::OpenID::Consumerをロードできませんでした。',
	'The address entered does not appear to be an OpenID' => '入力されたアドレスはOpenIDではありません。',
	'The text entered does not appear to be a web address' => '正しいURLを入力してください。',
	'Unable to connect to [_1]: [_2]' => '[_1]に接続できません: [_2]',
	'Could not verify the OpenID provided: [_1]' => 'OpenIDを検証できませんでした: [_1]',

## lib/MT/Auth/TypeKey.pm
	'Sign in requires a secure signature.' => 'サインインにはセキュリティトークンが必要です。',
	'The sign-in validation failed.' => 'サインインの検証に失敗しました。',
	'This weblog requires commenters to pass an email address. If you\'d like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'このブログは、コメントの際にメールアドレスを必ず通知するように要求しています。メールアドレスを通知しない限り、コメントを投稿できません。',
	'Couldn\'t get public key from url provided' => '指定されたURLから公開キーを取得できませんでした。',
	'No public key could be found to validate registration.' => '登録状況を検査するための公開キーが見つかりませんでした。',
	'TypePad signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'TypePad signature verif\'n returned [_1] in [_2] seconds verifying [_3] with [_4]',
	'The TypePad signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct' => 'TypePadの署名が古すぎます([_1]秒経過)。サーバーの時刻が正しいことを確認してください。',

## lib/MT/Author.pm
	'The approval could not be committed: [_1]' => '公開できませんでした: [_1]',

## lib/MT/BackupRestore.pm
	'Backing up [_1] records:' => '[_1]レコードをバックアップしています:',
	'[_1] records backed up...' => '[_1]レコードをバックアップしました...',
	'[_1] records backed up.' => '[_1]レコードをバックアップしました。',
	'There were no [_1] records to be backed up.' => 'バックアップ対象となる[_1]のレコードはありません。',
	'Can\'t open directory \'[_1]\': [_2]' => 'ディレクトリ\'[_1]\'を開けませんでした: [_2]',
	'No manifest file could be found in your import directory [_1].' => 'importディレクトリにマニフェストファイルがありません。',
	'Can\'t open [_1].' => '[_1]を開けません。',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => '[_1]はMovable Typeバックアップで作成された正しいマニフェストファイルではありません。',
	'Manifest file: [_1]' => 'マニフェストファイル: [_1]',
	'Path was not found for the file ([_1]).' => 'ファイル([_1])のパスが見つかりませんでした。',
	'[_1] is not writable.' => '[_1]には書き込めません。',
	'Error making path \'[_1]\': [_2]' => 'パス(\'[_1]\')を作成できません: [_2]',
	'Copying [_1] to [_2]...' => '[_1]を[_2]にコピーしています...',
	'Failed: ' => '失敗: ',
	'Done.' => '完了',
	'Restoring asset associations ... ( [_1] )' => 'アイテムの関連付けを復元しています...( [_1] )',
	'Restoring asset associations in entry ... ( [_1] )' => 'ブログ記事とアイテムの関連付けを復元しています...( [_1] )',
	'Restoring asset associations in page ... ( [_1] )' => 'ウェブページとアイテムの関連付けを復元しています...( [_1] )',
	'Restoring url of the assets ( [_1] )...' => 'アイテムのURLを復元しています... ( [_1] )',
	'Restoring url of the assets in entry ( [_1] )...' => 'ブログ記事に含まれるアイテムのURLを復元しています... ( [_1] )',
	'Restoring url of the assets in page ( [_1] )...' => 'ウェブページに含まれるアイテムのURLを復元しています... ( [_1] )',
	'ID for the file was not set.' => 'ファイルにIDが設定されていませんでした。',
	'The file ([_1]) was not restored.' => 'ファイル([_1])は復元されませんでした。',
	'Changing path for the file \'[_1]\' (ID:[_2])...' => 'ファイル\'[_1]\' (ID:[_2])のパスを変更しています...',
	'failed' => '失敗',
	'ok' => 'OK',

## lib/MT/BackupRestore/BackupFileHandler.pm
	'Uploaded file was not a valid Movable Type backup manifest file.' => 'アップロードされたファイルはMovable Typeバックアップで作成されたマニフェストファイルではありません。',
	'Uploaded file was backed up from Movable Type but the different schema version ([_1]) from the one in this system ([_2]).  It is not safe to restore the file to this version of Movable Type.' => 'アップロードされたファイルはこのシステムのバージョン([_2])とは異なるバージョン([_1])でバックアップされています。このファイルを使って復元することはできません。',
	'[_1] is not a subject to be restored by Movable Type.' => '[_1]はMovable Typeで復元する対象には含まれていません。',
	'[_1] records restored.' => '[_1]件復元されました。',
	'Restoring [_1] records:' => '[_1]を復元しています:',
	'User with the same name as the name of the currently logged in ([_1]) found.  Skipped the record.' => '現在ログインしているユーザー([_1])が見つかりました。このレコードはスキップします。',
	'User with the same name \'[_1]\' found (ID:[_2]).  Restore replaced this user with the data backed up.' => '\'[_1]\': 同名のユーザーが見つかりました(ID: [_2])。バックアップ時のユーザーデータを既存ユーザーのデータで置き換えて、他のデータを復元します。',
	'Tag \'[_1]\' exists in the system.' => '\'[_1]\'というタグはすでに存在します。',
	'[_1] records restored...' => '[_1]件復元されました...',
	'The role \'[_1]\' has been renamed to \'[_2]\' because a role with the same name already exists.' => 'ロール「[_1]」はすでに存在するため、「[_2]」という名前に変わりました。',

## lib/MT/BackupRestore/ManifestFileHandler.pm

## lib/MT/BasicAuthor.pm
	'authors' => 'ユーザー',

## lib/MT/Blog.pm
	'First Blog' => 'First Blog',
	'No default templates were found.' => 'デフォルトテンプレートが見つかりませんでした。',
	'Clone of [_1]' => '[_1]の複製',
	'Cloned blog... new id is [_1].' => 'ブログを複製しました。新しいIDは[_1]です。',
	'Cloning permissions for blog:' => '権限を複製しています:',
	'[_1] records processed...' => '[_1]レコードを処理しました...',
	'[_1] records processed.' => '[_1]レコードを処理しました。',
	'Cloning associations for blog:' => '関連付けを複製しています:',
	'Cloning entries and pages for blog...' => 'ブログ記事とウェブページを複製しています',
	'Cloning categories for blog...' => 'カテゴリを複製しています...',
	'Cloning entry placements for blog...' => 'ブログ記事とカテゴリの関連付けを複製しています...',
	'Cloning comments for blog...' => 'コメントを複製しています...',
	'Cloning entry tags for blog...' => 'タグを複製しています...',
	'Cloning TrackBacks for blog...' => 'トラックバックを複製しています...',
	'Cloning TrackBack pings for blog...' => 'トラックバックを複製しています...',
	'Cloning templates for blog...' => 'テンプレートを複製しています...',
	'Cloning template maps for blog...' => 'テンプレートマップを複製しています...',
	'blog' => 'ブログ',
	'blogs' => 'ブログ',
	'Failed to load theme [_1]: [_2]' => '[_1]テーマの読込に失敗しました: [_2]',
	'Failed to apply theme [_1]: [_2]' => '[_1]テーマの適用に失敗しました: [_2]',

## lib/MT/Bootstrap.pm

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => '<[_1]>は存在しません([_2]行目)。',
	'<[_1]> with no </[_1]> on line #' => '<[_1]>に対応する</[_1]>がありません。',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]>に対応する</[_1]>がありません([_2]行目)。',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]>に対応する</[_1]>がありません([_2]行目)。',
	'Error in <mt[_1]> tag: [_2]' => '<mt[_1]>タグでエラーがありました: [_2]',
	'Unknown tag found: [_1]' => '不明なタグです: [_1]',

## lib/MT/CMS/AddressBook.pm
	'No entry ID provided' => 'ブログ記事のIDが指定されていません。',
	'No such entry \'[_1]\'' => '「[_1]」というブログ記事は存在しません。',
	'No email address for user \'[_1]\'' => '「[_1]」にはメールアドレスが設定されていません。',
	'No valid recipients found for the entry notification.' => '通知するメールアドレスがありません。',
	'[_1] Update: [_2]' => '更新通知: [_1] - [_2]',
	'Error sending mail ([_1]); try another MailTransfer setting?' => 'メールを送信できませんでした。MailTransferの設定を見直してください: [_1]',
	'Please select a blog.' => 'ブログを選択してください。',
	'The value you entered was not a valid email address' => 'メールアドレスが不正です。',
	'The value you entered was not a valid URL' => 'URLが不正です。',
	'The e-mail address you entered is already on the Notification List for this blog.' => '入力したメールアドレスはすでに通知リストに含まれています。',
	'Subscriber \'[_1]\' (ID:[_2]) deleted from address book by \'[_3]\'' => '\'[_3]\'がアドレス帳から\'[_1]\'(ID:[_2])を削除しました。',

## lib/MT/CMS/Asset.pm
	'Files' => 'ファイル',
	'Extension changed from [_1] to [_2]' => '拡張子が[_1]から[_2]に変更されました',
	'Upload File' => 'ファイルアップロード',
	'Can\'t load file #[_1].' => 'ID:[_1]のファイルをロードできません。',
	'No permissions' => '権限がありません。',
	'File \'[_1]\' uploaded by \'[_2]\'' => '\'[_2]\'がファイル\'[_1]\'をアップロードしました。',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => '\'[_3]\'がファイル\'[_1]\'(ID:[_2])を削除しました。',
	'All Assets' => 'すべてのアイテム',
	'Untitled' => 'タイトルなし',
	'Archive Root' => 'アーカイブパス',
	'Site Root' => 'サイトパス',
	'Please select a file to upload.' => 'アップロードするファイルを選択してください。',
	'Invalid filename \'[_1]\'' => 'ファイル名\'[_1]\'が不正です。',
	'Please select an audio file to upload.' => 'アップロードするオーディオファイルを選択してください。',
	'Please select an image to upload.' => 'アップロードする画像を選択してください。',
	'Please select a video to upload.' => 'アップロードするビデオファイルを選択してください。',
	'Movable Type was unable to write on the "Upload Destination". Please make sure that the folder is writable from the web server.' => 'アップロード先のディレクトリに書き込みできません。ウェブサーバーから書き込みできるパーミッションを与えてください。',
	'Invalid extra path \'[_1]\'' => '追加パスが不正です。',
	'Can\'t make path \'[_1]\': [_2]' => 'パス\'[_1]\'を作成できませんでした: [_2]',
	'Invalid temp file name \'[_1]\'' => 'テンポラリファイルの名前\'[_1]\'が不正です。',
	'Error opening \'[_1]\': [_2]' => '\'[_1]\'を開けませんでした: [_2]',
	'Error deleting \'[_1]\': [_2]' => '\'[_1]\'を削除できませんでした: [_2]',
	'File with name \'[_1]\' already exists. (Install File::Temp if you\'d like to be able to overwrite existing uploaded files.)' => '\'[_1]\'という名前のファイルが既に存在します。既存のファイルを上書きしたい場合はFile::Tempをインストールしてください。',
	'Error creating temporary file; please check your TempDir setting in your coniguration file (currently \'[_1]\') this location should be writable.' => 'テンポラリファイルを作成できませんでした。構成ファイルでTempDirの設定を確認してください。現在は[_1]に設定されています。',
	'unassigned' => '(未設定)',
	'File with name \'[_1]\' already exists; Tried to write to tempfile, but open failed: [_2]' => '\'[_1]\'という名前のファイルが既に存在します。テンポラリファイルに書き込むこともできませんでした: [_2]',
	'Could not create upload path \'[_1]\': [_2]' => '[_1]を作成できませんでした: [_2]',
	'Error writing upload to \'[_1]\': [_2]' => 'アップロードされたファイルを[_1]に書き込めませんでした: [_2]',
	'Uploaded file is not an image.' => 'アップロードしたファイルは画像ではありません。',
	'<' => '<',
	'/' => '/',

## lib/MT/CMS/BanList.pm
	'You did not enter an IP address to ban.' => '禁止するIPアドレスを指定してください。',
	'The IP you entered is already banned for this blog.' => 'このIPアドレスはすでに禁止されています。',

## lib/MT/CMS/Blog.pm
	'Cloning blog \'[_1]\'...' => 'ブログ「[_1]」を複製しています...',
	'Error' => 'エラー',
	'Finished! You can <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">return to the blog listing</a>.' => '完了しました。<a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">ブログの一覧</a>に戻る。',
	'General Settings' => '全般設定',
	'Plugin Settings' => 'プラグイン設定',
	'New Blog' => '新しいブログ',
	'[_1] Activity Feed' => '[_1]アクティビティーフィード',
	'Can\'t load template #[_1].' => 'テンプレート: [_1]をロードできませんでした。',
	'index template \'[_1]\'' => 'インデックステンプレート「[_1]」',
	'[_1] \'[_2]\'' => '[_1]「[_2]」',
	'Publish Site' => 'サイトを再構築',
	'Invalid blog' => 'ブログが不正です。',
	'Select Blog' => 'ブログを選択',
	'Selected Blog' => '選択されたブログ',
	'Type a blog name to filter the choices below.' => 'ブログ名を入力して絞り込み',
	'Blog Name' => 'ブログ名',
	'[_1] changed from [_2] to [_3]' => '[_1]は[_2]から[_3]に変更されました',
	'Saved [_1] Changes' => '[_1]の変更が保存されました',
	'Saving permissions failed: [_1]' => '権限を保存できませんでした: [_1]',
	'[_1] \'[_2]\' (ID:[_3]) created by \'[_4]\'' => '[_4]によって[_1]の「[_2]」(ID:[_3])が作成されました',
	'You did not specify a blog name.' => 'ブログの名前を指定してください。',
	'Site URL must be an absolute URL.' => 'サイトURLは絶対URLでなければなりません。',
	'Archive URL must be an absolute URL.' => 'アーカイブURLは絶対URLでなければなりません。',
	'You did not specify an Archive Root.' => 'アーカイブパスを指定していません。',
	'The number of revisions to store must be a positive integer.' => '更新履歴番号は整数でなければなりません。',
	'Blog \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => '\'[_3]\'がブログ\'[_1]\'(ID:[_2])を削除しました。',
	'Saving blog failed: [_1]' => 'ブログを保存できませんでした: [_1]',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'テンプレートをキャッシュするディレクトリに書き込めません。サイトパスの下にある<code>[_1]</code>ディレクトリのパーミッションを確認してください。',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'テンプレートをキャッシュするディレクトリを作成できません。サイトパスの下に<code>[_1]</code>ディレクトリを作成してください。',
	'No blog was selected to clone.' => '複製するブログが選択されていません。',
	'This action can only be run on a single blog at a time.' => 'このアクションは同時に1つのブログでしか実行できません。',
	'Invalid blog_id' => '不正なブログID',
	'This action cannot clone website.' => 'このアクションではウェブサイトの複製はできません',
	'Entries must be cloned if comments and trackbacks are cloned' => 'コメントやトラックバックの複製により、記事も複製されます。',
	'Entries must be cloned if comments are cloned' => 'コメントの複製により、記事も複製されます。',
	'Entries must be cloned if trackbacks are cloned' => 'トラックバックの複製により、記事も複製されます。',

## lib/MT/CMS/Category.pm
	'Subfolder' => 'サブフォルダ',
	'Subcategory' => 'サブカテゴリ',
	'The [_1] must be given a name!' => '[_1]には名前が必要です。',
	'Add a [_1]' => '[_1]を追加しました。',
	'No label' => '名前がありません。',
	'Category name cannot be blank.' => 'カテゴリの名前は必須です。',
	'Permission denied: [_1]' => '権限がありません: [_1]',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => '\'[_1]\'は他のカテゴリと衝突しています。同じ階層にあるカテゴリの名前は一意でなければなりません。',
	'The category basename \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => '\'[_1]\'は他のカテゴリと衝突しています。同じ階層にあるカテゴリのベースネームは一意でなければなりません。',
	'Category \'[_1]\' created by \'[_2]\'' => '\'[_2]\'がカテゴリ\'[_1]\'を作成しました。',
	'The name \'[_1]\' is too long!' => '\'[_1]\'は長すぎます。',
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => '\'[_3]\'がカテゴリ\'[_1]\'(ID:[_2])を削除しました。',

## lib/MT/CMS/Comment.pm
	'Edit Comment' => 'コメントの編集',
	'(untitled)' => '(タイトルなし)',
	'Orphaned comment' => 'ブログ記事のないコメント',
	'Comments Activity Feed' => 'コメントフィード',
	'*User deleted*' => '*削除されました*',
	'No such commenter [_1].' => '[_1]というコメント投稿者は存在しません。',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => '\'[_1]\'がコメント投稿者\'[_2]\'を承認しました。',
	'User \'[_1]\' banned commenter \'[_2]\'.' => '\'[_1]\'がコメント投稿者\'[_2]\'を禁止しました。',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => '\'[_1]\'がコメント投稿者\'[_2]\'を保留にしました。',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => '\'[_1]\'がコメント投稿者\'[_2]\'の承認を取り消しました。',
	'Permission denied' => '権限がありません。',
	'Parent comment id was not specified.' => '返信先のコメントが指定されていません。',
	'Parent comment was not found.' => '返信先のコメントが見つかりません。',
	'You can\'t reply to unapproved comment.' => '未公開のコメントには返信できません。',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => '\'[_3]\'がコメント\'[_1]\'(ID:[_2])を削除しました。',
	'You don\'t have permission to approve this trackback.' => 'トラックバックを承認する権限がありません。',
	'Comment on missing entry!' => '存在しないブログ記事に対してコメントしています。',
	'You don\'t have permission to approve this comment.' => 'コメントを公開する権限がありません。',
	'You can\'t reply to unpublished comment.' => '公開されていないコメントには返信できません。',

## lib/MT/CMS/Common.pm
	'Permisison denied.' => '権限がありません。',
	'The Template Name and Output File fields are required.' => 'テンプレートの名前と出力ファイル名は必須です。',
	'Invalid type [_1]' => 'type [_1]は不正です。',
	'Invalid ID [_1]' => 'ID [_1]は不正です。',
	'Save failed: [_1]' => '保存できませんでした: [_1]',
	'Saving object failed: [_1]' => 'オブジェクトを保存できませんでした: [_1]',
	'\'[_1]\' edited the template \'[_2]\' in the blog \'[_3]\'' => '[_1]がブログ([_3])のテンプレート([_2])を編集しました',
	'\'[_1]\' edited the global template \'[_2]\'' => '[_1]がグローバルテンプレート([_2])を編集しました',
	'Invalid parameter' => '不正なパラメータです。',
	'Load failed: [_1]' => 'ロードできませんでした: [_1]',
	'(no reason given)' => '(原因は不明)',
	'(user deleted)' => '(削除されました)',
	'No Name' => '名前なし',
	'Notification List' => '通知リスト',
	'Removing tag failed: [_1]' => 'タグを削除できませんでした: [_1]',
	'Loading MT::LDAP failed: [_1].' => 'MT::LDAPの読み込みに失敗しました: [_1]',
	'Removing [_1] failed: [_2]' => '[_1]を削除できませんでした: [_2]',
	'System templates can not be deleted.' => 'システムテンプレートは削除できません。',
	'Can\'t load [_1] #[_1].' => '[_1](ID: [_2])がロードできませんでした。',
	'Saving snapshot failed: [_1]' => 'スナップショットの保存に失敗しました: [_1]',

## lib/MT/CMS/Dashboard.pm
	'Error: This blog doesn\'t have a parent website.' => 'エラー: このブログにはウェブサイトがありません。',
	'Design with Themes' => 'テーマデザイン',
	'Create and apply a theme to change templates, categories, folders and custom fields.' => 'テンプレートやフォルダ、カテゴリーを、テーマにまとめて保存。ブログのデザインを簡単に変更できます。
',
	'Website Management' => 'ウェブサイト管理',
	'Manage multiple blogs for each website. Now, it\'s much easier to create a portal with MultiBlog.' => '複数のブログを、ウェブサイト単位でまとめて管理。マルチブログも、さらに使いやすくなりました。',
	'Revision History' => '更新履歴',
	'The revision history for entries and templates protects users from unexpected modification.' => 'ブログ記事、ウェブページ、テンプレートの更新履歴を保存。任意のバージョンへ復帰できます。',
	'Movable Type Online Manual' => 'Movable Typeオンラインマニュアル',
	'Whether you\'re new to Movable Type or using it for the first time, learn more about what this tool can do for you.' => 'Movable Typeで何ができるか、詳しくはこちら。',

## lib/MT/CMS/Entry.pm
	'New Entry' => '記事を作成',
	'New Page' => 'ページを作成',
	'pages' => 'ウェブページ',
	'Category' => 'カテゴリ',
	'Tag' => 'タグ',
	'Entry Status' => '公開状態',
	'[_1] Feed' => '[_1]のフィード',
	'Can\'t load template.' => 'テンプレートをロードできませんでした。',
	'Publish error: [_1]' => '再構築エラー: [_1]',
	'Unable to create preview file in this location: [_1]' => 'プレビュー用のファイルをこの場所に作成できませんでした: [_1]',
	'New [_1]' => '新しい[_1]',
	'No such [_1].' => '[_1]が存在しません。',
	'Same Basename has already been used. You should use an unique basename.' => 'ファイル名はすでに使用されています。一意の名前を指定してください。',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'サイトパスとサイトURLを設定していません。設定するまで公開できません。',
	'Invalid date \'[_1]\'; authored on dates must be in the format YYYY-MM-DD HH:MM:SS.' => '\'[_1]\'は不正な日付です。YYYY-MM-DD HH:MM:SSの形式で入力してください。',
	'Invalid date \'[_1]\'; authored on dates should be real dates.' => '\'[_1]\'は不正な日付です。正しい日付を入力してください。',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_4]が[_1]「[_2]」(ID:[_3])を追加しました。',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_6]が[_1]「[_2]」(ID:[_3])を更新し、公開の状態を[_4]から[_5]に変更しました。',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_4]が[_1]「[_2]」(ID:[_3])を更新しました。',
	'Saving placement failed: [_1]' => 'ブログ記事とカテゴリの関連付けを設定できませんでした: [_1]',
	'Saving entry \'[_1]\' failed: [_2]' => 'ブログ記事「[_1]」を保存できませんでした: [_2]',
	'Removing placement failed: [_1]' => 'ブログ記事とカテゴリの関連付けを削除できませんでした: [_1]',
	'Ping \'[_1]\' failed: [_2]' => '[_1]へトラックバックできませんでした: [_2]',
	'(user deleted - ID:[_1])' => '(削除されたユーザー - ID:[_1])',
	'<a href="[_1]">QuickPost to [_2]</a> - Drag this link to your browser\'s toolbar, then click it when you are visiting a site that you want to blog about.' => '<a href="[_1]">クイック投稿</a>: このリンクをブラウザのツールバーにドラッグし、興味のあるウェブページでクリックすると、ブログへ簡単に投稿できます。',
	'Entry \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => '\'[_3]\'がブログ記事\'[_1]\'(ID:[_2])を削除しました。',
	'Need a status to update entries' => 'ブログ記事を更新するにはまず公開状態を設定してください。',
	'Need entries to update status' => '公開状態を設定するにはブログ記事が必要です。',
	'One of the entries ([_1]) did not actually exist' => 'ブログ記事(ID:[_1])は存在しませんでした。',
	'[_1] \'[_2]\' (ID:[_3]) status changed from [_4] to [_5]' => '[_1]「[_2] (ID:[_3])」の公開状態が[_4]から[_5]に変更されました。',

## lib/MT/CMS/Export.pm
	'You do not have export permissions' => 'エクスポートする権限がありません。',

## lib/MT/CMS/Folder.pm
	'The folder \'[_1]\' conflicts with another folder. Folders with the same parent must have unique basenames.' => '\'[_1]\'は他のフォルダと衝突しています。同じ階層にあるフォルダの名前(ベースネーム)は一意でなければなりません。',
	'Folder \'[_1]\' created by \'[_2]\'' => '\'[_2]\'がフォルダ\'[_1]\'を作成しました。',
	'Folder \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => '\'[_3]\'がフォルダ\'[_1]\'(ID:[_2])を削除しました。',

## lib/MT/CMS/Import.pm
	'Import/Export' => 'インポート/エクスポート',
	'You do not have import permission' => 'インポートの権限がありません。',
	'You do not have permission to create users' => 'ユーザーを作成する権限がありません。',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'ブログにユーザーを追加するためには、パスワードを指定する必要があります。',
	'Importer type [_1] was not found.' => '[_1]というインポート形式は存在しません。',

## lib/MT/CMS/Log.pm
	'All Feedback' => 'すべて',
	'Publishing' => '公開',
	'System Activity Feed' => 'システムログ',
	'Activity log for blog \'[_1]\' (ID:[_2]) reset by \'[_3]\'' => '\'[_3]\'がブログ\'[_1]\'(ID:[_2])のログをリセットしました。',
	'Activity log reset by \'[_1]\'' => '\'[_1]\'がログをリセットしました。',

## lib/MT/CMS/Plugin.pm
	'Plugin Set: [_1]' => 'プラグインのセット: [_1]',
	'Individual Plugins' => 'プラグイン',

## lib/MT/CMS/RptLog.pm
	'RPT Log' => 'RPT Log',
	'System RPT Feed' => 'システムRPTフィード',

## lib/MT/CMS/Search.pm
	'No [_1] were found that match the given criteria.' => '該当する[_1]は見つかりませんでした。',
	'Entry Body' => '本文',
	'Extended Entry' => '続き',
	'Keywords' => 'キーワード',
	'Basename' => '出力ファイル名',
	'Comment Text' => '本文',
	'IP Address' => 'IPアドレス',
	'Source URL' => '送信元のURL',
	'Page Body' => '本文',
	'Extended Page' => '追記',
	'Template Name' => 'テンプレート名',
	'Text' => '本文',
	'Linked Filename' => 'リンクされたファイル名',
	'Output Filename' => '出力ファイル名',
	'Filename' => 'ファイル名',
	'Label' => '名前',
	'Log Message' => 'ログ',
	'Site URL' => 'サイトURL',
	'Search & Replace' => '検索/置換',
	'Invalid date(s) specified for date range.' => '日付の範囲指定が不正です。',
	'Error in search expression: [_1]' => '検索条件にエラーがあります: [_1]',
	'Saving object failed: [_2]' => 'オブジェクトを保存できませんでした: [_2]',

## lib/MT/CMS/Tag.pm
	'Invalid type' => 'typeが不正です。',
	'New name of the tag must be specified.' => 'タグの名前を指定してください。',
	'No such tag' => 'タグが存在しません。',
	'Error saving entry: [_1]' => 'ブログ記事を保存できませんでした: [_1]',
	'Error saving file: [_1]' => 'ファイルを保存できませんでした: [_1]',
	'Tag \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => '\'[_3]\'がタグ\'[_1]\'(ID:[_2])を削除しました。',

## lib/MT/CMS/Template.pm
	'index' => 'インデックス',
	'archive' => 'アーカイブ',
	'module' => 'モジュール',
	'widget' => 'ウィジェット',
	'email' => 'メール',
	'backup' => 'バックアップ',
	'system' => 'システム',
	'One or more errors were found in this template.' => 'テンプレートでエラーが見つかりました。',
	'One or more errors were found in included template module ([_1]).' => 'テンプレートモジュール([_1])でエラーが見つかりました。',
	'Create template requires type' => 'テンプレートを作成するためのtypeパラメータが指定されていません。',
	'Archive' => 'アーカイブ',
	'Entry or Page' => 'ブログ記事/ウェブページ',
	'New Template' => '新しいテンプレート',
	'Index Templates' => 'インデックステンプレート',
	'Archive Templates' => 'アーカイブテンプレート',
	'Template Modules' => 'テンプレートモジュール',
	'System Templates' => 'システムテンプレート',
	'Email Templates' => 'メールテンプレート',
	'Template Backups' => 'バックアップされたテンプレート',
	'Can\'t locate host template to preview module/widget.' => 'モジュール/ウィジェットをプレビューするための親テンプレートが見つかりませんでした。',
	'Cannot preview without a template map!' => 'テンプレートマップがない状態でプレビューはできません。',
	'Lorem ipsum' => 'いろはにほへと',
	'LOREM_IPSUM_TEXT' => 'いろはにほへと ちりぬるを わかよたれそ つねならむ うゐのおくやま けふこえて あさきゆめみし ゑひもせす',
	'LORE_IPSUM_TEXT_MORE' => '色は匂へど 散りぬるを 我が世誰ぞ 常ならむ 有為の奥山 今日越えて 浅き夢見し 酔ひもせず',
	'sample, entry, preview' => 'サンプル、ブログ記事、プレビュー',
	'Populating blog with default templates failed: [_1]' => 'ブログに既定のテンプレートを設定できませんでした: [_1]',
	'Setting up mappings failed: [_1]' => 'テンプレートマップを作成できませんでした: [_1]',
	'Saving map failed: [_1]' => 'テンプレートマップを保存できませんでした: [_1]',
	'You should not be able to enter 0 as the time.' => '時間に0を入れることはできません。',
	'You must select at least one event checkbox.' => '少なくとも1つのイベントにチェックを入れてください。',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => '\'[_3]\'がテンプレート\'[_1]\'(ID:[_2])を作成しました。',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => '\'[_3]\'がテンプレート\'[_1]\'(ID:[_2])を削除しました。',
	'Orphaned' => 'Orphaned',
	'Global Templates' => 'グローバルテンプレート',
	' (Backup from [_1])' => ' - バックアップ ([_1])',
	'Error creating new template: ' => 'テンプレートの作成エラー:',
	'Template Referesh' => 'テンプレート初期化',
	'Skipping template \'[_1]\' since it appears to be a custom template.' => 'カスタムテンプレートと思われるため、\'[_1]\'をスキップします。',
	'Refreshing template <strong>[_3]</strong> with <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>' => '「[_3]」を初期化します(<a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">バックアップ</a>)。',
	'Skipping template \'[_1]\' since it has not been changed.' => '[_1]は変更されていないのでスキップします。',
	'Copy of [_1]' => '[_1]のコピー',
	'Cannot publish a global template.' => 'グローバルテンプレートの公開ができません。',
	'Widget Template' => 'ウィジェットテンプレート',
	'Widget Templates' => 'ウィジェットテンプレート',
	'template' => 'テンプレート',
	'Restoring widget set [_1]... ' => 'ウィジェットセット「[_1]」を復元しています...',
	'Failed.' => '失敗',

## lib/MT/CMS/Theme.pm
	'Theme not found' => 'テーマがみつかりませんでした。',
	'Failed to uninstall theme' => 'テーマのアンインストールに失敗しました',
	'Failed to uninstall theme: [_1]' => 'テーマのアンインストールに失敗しました: [_1]',
	'Theme from [_1]' => '[_1]のテーマ',
	'Install into themes directory' => 'テーマディレクトリへのインストール',
	'Download [_1] archive' => '[_1]形式アーカイブでダウンロード',
	'Failed to save theme export info: [_1]' => 'テーマエクスポート情報の保存に失敗しました: [_1]',
	'Themes Directory [_1] is not writable.' => 'テーマディレクトリ[_1]に書き込めません。',
	'Error occurred during exporting [_1]: [_2]' => '[_1]のエクスポート中にエラーが発生しました: [_2]',
	'Error occurred during finalizing [_1]: [_2]' => '[_1]のファイナライズ中にエラーが発生しました: [_2]',
	'Error occurred while publishing theme: [_1]' => 'テーマの公開中にエラーが発生しました: [_1]',

## lib/MT/CMS/Tools.pm
	'Password Recovery' => 'パスワードの再設定',
	'User not found' => 'ユーザーが見つかりませんでした。',
	'Error sending mail ([_1]); please fix the problem, then try again to recover your password.' => 'メールを送信できませんでした。問題を解決してから再度パスワードの再設定を行ってください: [_1]',
	'Password reset token not found' => 'パスワードをリセットするためのトークンが見つかりませんでした。',
	'Email address not found' => 'メールアドレスが見つかりませんでした。',
	'Your request to change your password has expired.' => 'パスワードのリセットを始めてから決められた時間を経過してしまいました。',
	'Invalid password reset request' => '不正なリクエストです。',
	'Please confirm your new password' => '新しいパスワードを確認してください。',
	'Passwords do not match' => 'パスワードが一致していません。',
	'That action ([_1]) is apparently not implemented!' => 'アクション([_1])が実装されていません。',
	'You don\'t have a system email address configured.  Please set this first, save it, then try the test email again.' => 'システムメールアドレスの設定がされていません。最初に設定を保存してから、再度テストメール送信を行ってください。',
	'Please enter a valid email address' => '正しいメールアドレスを入力してください',
	'Test email from Movable Type' => 'Movable Typeから送信されたテストメールです。',
	'This is the test email sent by your installation of Movable Type.' => 'このメールはMovable Typeのインストール時に送信されたテストメールです。',
	'Mail was not properly sent' => 'メールが正しく送信されませんでした',
	'Test e-mail was successfully sent to [_1]' => '[_1]へのテストメールは正しく送信されました。',
	'These setting(s) are overridden by a value in the MT configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'MTの設定ファイルによって設定されている値([_1])が優先されます。このページで設定した値を利用するためには、設定ファイルでの設定を削除してください。',
	'Email address is [_1]' => 'メールアドレスは[_1]です',
	'Debug mode is [_1]' => 'デバッグモードは[_1]です',
	'Performance logging is on' => 'パフォーマンスログはオンです',
	'Performance logging is off' => 'バフォーマンスログはオフです',
	'Performance log path is [_1]' => 'パフォーマンスログのパスは[_1]です',
	'Performance log threshold is [_1]' => 'パフォーマンスログの閾値は[_1]です',
	'System Settings Changes Took Place' => 'システム設定が変更されました',
	'Invalid password recovery attempt; can\'t recover password in this configuration' => 'パスワードの再設定に失敗しました。この構成では再設定はできません。',
	'Invalid author_id' => 'ユーザーのIDが不正です。',
	'Backup & Restore' => 'バックアップ/復元',
	'Temporary directory needs to be writable for backup to work correctly.  Please check TempDir configuration directive.' => 'バックアップするにはテンポラリディレクトリに書き込みできなければなりません。TempDirの設定を確認してください。',
	'Temporary directory needs to be writable for restore to work correctly.  Please check TempDir configuration directive.' => '復元するにはテンポラリディレクトリに書き込みできなければなりません。TempDirの設定を確認してください。',
	'No website could be found. You must create a website first.' => 'ウェブサイトがありません。最初にウェブサイトを作成してください。',
	'[_1] is not a number.' => '[_1]は数値ではありません。',
	'Copying file [_1] to [_2] failed: [_3]' => 'ファイル: [_1]を[_2]にコピーできませんでした: [_3]',
	'Specified file was not found.' => '指定されたファイルが見つかりませんでした。',
	'[_1] successfully downloaded backup file ([_2])' => '[_1]がバックアップファイル([_2])をダウンロードしました。',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Some of the actual files for assets could not be restored.' => '復元できなかった実ファイルがあります。',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => '拡張子がxml、tar.gz、zip、manifestのいずれかのファイルをアップロードしてください。',
	'Unknown file format' => 'ファイル形式が不明です。',
	'Some objects were not restored because their parent objects were not restored.' => '親となるオブジェクトがないため復元できなかったオブジェクトがあります。',
	'Detailed information is in the <a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>activity log</a>.' => '詳細は<a href=\'javascript:void(0)\' onclick=\'closeDialog(\"[_1]\")\'>ログ</a>を参照してください。',
	'[_1] has canceled the multiple files restore operation prematurely.' => '[_1]が復元を途中で強制終了しました。',
	'Changing Site Path for the blog \'[_1]\' (ID:[_2])...' => '\'[_1]\'(ID:[_2])のサイトパスを変更しています...',
	'Removing Site Path for the blog \'[_1]\' (ID:[_2])...' => '\'[_1]\'(ID:[_2])のサイトパスを消去しています...',
	'Changing Archive Path for the blog \'[_1]\' (ID:[_2])...' => '\'[_1]\'(ID:[_2])のアーカイブパスを変更しています...',
	'Removing Archive Path for the blog \'[_1]\' (ID:[_2])...' => '\'[_1]\'(ID:[_2])のアーカイブパスを消去しています...',
	'Changing file path for the asset \'[_1]\' (ID:[_2])...' => 'アイテム\'[_1]\'(ID:[_2])のパスを変更しています...',
	'Please upload [_1] in this page.' => '[_1]をアップロードしてください。',
	'File was not uploaded.' => 'ファイルがアップロードされませんでした。',
	'Restoring a file failed: ' => 'ファイルから復元できませんでした。',
	'Some of the files were not restored correctly.' => '復元できなかったファイルがあります。',
	'Successfully restored objects to Movable Type system by user \'[_1]\'' => '\'[_1]\'がMovable Typeシステムを復元しました。',
	'Can\'t recover password in this configuration' => 'この構成ではパスワードの再設定はできません。',
	'Invalid user name \'[_1]\' in password recovery attempt' => 'パスワードの再設定でエラーが発生しました。\'[_1]\'は不正なユーザー名です。',
	'User name or password hint is incorrect.' => 'ユーザー名またはパスワード再設定用のフレーズが不正です。',
	'User has not set pasword hint; cannot recover password' => 'パスワード再設定用のフレーズが設定されていないため、再設定できません。',
	'Invalid attempt to recover password (used hint \'[_1]\')' => 'パスワードの再設定に失敗しました(フレーズ: [_1])。',
	'User \'[_1]\' (user #[_2]) does not have email address' => 'ユーザー\'[_1]\'(ID:[_2])はメールアドレスがありません',
	'A password reset link has been sent to [_3] for user  \'[_1]\' (user #[_2]).' => 'パスワード再設定用のリンクがユーザー\'[_1]\'(ID:[_2])のメールアドレス([_3])あてに通知されました。',
	'Some objects were not restored because their parent objects were not restored.  Detailed information is in the <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">activity log</a>.' => '親となるオブジェクトがないため復元できなかったオブジェクトがあります。詳細は<a href="javascript:void(0)" onclick="closeDialog(\'[_1]\')">ログ</a>を参照してください。',
	'[_1] is not a directory.' => '[_1]はディレクトリではありません。',
	'Error occured during restore process.' => '復元中にエラーがありました。',
	'Some of files could not be restored.' => '復元できなかったファイルがあります。',
	'Manifest file \'[_1]\' is too large. Please use import direcotry for restore.' => 'バックアップファイル\'[_1]\'が大きすぎます。インポートディレクトリを利用して復元してください。',
	'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => '\'[_2]\'がブログ(ID:[_1])をバックアップしました。',
	'Movable Type system was successfully backed up by user \'[_1]\'' => '\'[_1]\'がMovable Typeのシステムをバックアップしました。',
	'Some [_1] were not restored because their parent objects were not restored.' => '親となるオブジェクトがないため[_1]を復元できませんでした。',

## lib/MT/CMS/TrackBack.pm
	'Junk TrackBacks' => 'スパムトラックバック',
	'TrackBacks where <strong>[_1]</strong> is &quot;[_2]&quot;.' => '<strong>[_1]</strong>が&quot;[_2]&quot;のトラックバック',
	'TrackBack Activity Feed' => 'トラックバックのフィード',
	'(Unlabeled category)' => '(無名カテゴリ)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from category \'[_4]\'' => '\'[_3]\'が\'[_2]\'のトラックバック(ID:[_1])をカテゴリ\'[_4]\'から削除しました。',
	'(Untitled entry)' => '(タイトルなし)',
	'Ping (ID:[_1]) from \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => '\'[_3]\'が\'[_2]\'のトラックバック(ID:[_1])を削除しました。',
	'No Excerpt' => '抜粋なし',
	'No Title' => 'タイトルなし',
	'Orphaned TrackBack' => '対応するブログ記事のないトラックバック',
	'category' => 'カテゴリ',

## lib/MT/CMS/User.pm
	'Create User' => 'ユーザーの作成',
	'Can\'t load role #[_1].' => 'ロール: [_1]をロードできませんでした。',
	'Create Role' => '新しいロールを作成',
	'(newly created user)' => '(新規ユーザー)',
	'User Associations' => 'ユーザーの関連付け',
	'Role Users & Groups' => 'ロールのユーザーとグループ',
	'(Custom)' => '(カスタム)',
	'The user' => 'ユーザー',
	'Role name cannot be blank.' => 'ロールの名前は必須です。',
	'Another role already exists by that name.' => '同名のロールが既に存在します。',
	'You cannot define a role without permissions.' => '権限のないロールは作成できません。',
	'Invalid ID given for personal blog theme.' => '個人用ブログテーマのIDが不正です。',
	'Invalid ID given for personal blog clone location ID.' => '個人用ブログの複製先のIDが不正です。',
	'If personal blog is set, the personal blog location are required.' => '個人用ブログの設定にはウェブサイトの選択が必要です。',
	'Select a entry author' => 'ブログ記事の投稿者を選択',
	'Select a page author' => 'ページの投稿者を選択',
	'Selected author' => '選択された投稿者',
	'Type a username to filter the choices below.' => 'ユーザー名を入力して絞り込み',
	'Select a System Administrator' => 'システム管理者を選択',
	'Selected System Administrator' => '選択されたシステム管理者',
	'System Administrator' => 'システム管理者',
	'represents a user who will be created afterwards' => '今後新しく作成されるユーザー',
	'Select Website' => 'ウェブサイト選択',
	'Website Name' => 'ウェブサイト名',
	'Websites Selected' => '選択されたウェブサイト',
	'Search Websites' => 'ウェブサイトを検索',
	'Select Blogs' => 'ブログを選択',
	'Blogs Selected' => '選択されたブログ',
	'Search Blogs' => 'ブログを検索',
	'Select Users' => 'ユーザーを選択',
	'Users Selected' => '選択されたユーザー',
	'Search Users' => 'ユーザーを検索',
	'Select Roles' => 'ロールを選択',
	'Role Name' => 'ロール名',
	'Roles Selected' => '選択されたロール',
	'Grant Permissions' => '権限の付与',
	'You cannot delete your own association.' => '自分の関連付けは削除できません。',
	'You cannot delete your own user record.' => '自分のデータは削除できません。',
	'You have no permission to delete the user [_1].' => '[_1]を削除する権限がありません。',
	'User requires username' => 'ユーザー名は必須です。',
	'User requires display name' => '表示名は必須です。',
	'User requires password' => 'パスワードは必須です。',
	'Email Address is required for password recovery' => 'メールアドレスはパスワードを再設定できるようにするために必要です。',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => '\'[_3]\'がユーザー\'[_1]\'(ID:[_2])を作成しました。',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => '\'[_3]\'がユーザー\'[_1]\'(ID:[_2])を削除しました。',

## lib/MT/CMS/Website.pm
	'New Website' => '新規ウェブサイト',
	'Website \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => '[_3]によってウェブサイト「[_1]」(ID:[_2])が削除されました',
	'Selected Website' => '選択されたウェブサイト',
	'Type a website name to filter the choices below.' => '以下の選択によって抽出されたウェブサイト名を入力',
	'Can\'t load website #[_1].' => 'ウェブサイト(ID:[_1])はロードできませんでした。',
	'Blog \'[_1]\' (ID:[_2]) moved from \'[_3]\' to \'[_4]\' by \'[_5]\'' => 'ブログ「[_1]」(ID:[_2])を[_3]から[_4]に移しました',

## lib/MT/Category.pm
	'Categories must exist within the same blog' => 'カテゴリは親となるカテゴリと同じブログに作らなければなりません。',
	'Category loop detected' => 'カテゴリがお互いに親と子の関係になっています。',

## lib/MT/Comment.pm
	'Comment' => 'コメント',
	'Load of entry \'[_1]\' failed: [_2]' => 'ブログ記事\'[_1]\'をロードできませんでした: [_1]',

## lib/MT/Compat/v3.pm
	'uses: [_1], should use: [_2]' => '[_1]は[_2]に直してください。',
	'uses [_1]' => '[_1]を使っています。',
	'No executable code' => '実行できるコードがありません。',
	'Publish-option name must not contain special characters' => '再構築のオプション名には特殊記号を含められません。',

## lib/MT/Component.pm
	'Loading template \'[_1]\' failed: [_2]' => 'テンプレート\'[_1]\'をロードできませんでした: [_2]',

## lib/MT/Config.pm
	'Configuration' => '構成情報',

## lib/MT/ConfigMgr.pm
	'Alias for [_1] is looping in the configuration.' => '[_1]のAlias指定は循環しています。',
	'Error opening file \'[_1]\': [_2]' => '\'[_1]\'を開けませんでした: [_2]',
	'Config directive [_1] without value at [_2] line [_3]' => '構成ファイル[_2]の設定[_1]に値がありません(行:[_3])',
	'No such config variable \'[_1]\'' => '\'[_1]\'は正しい設定項目ではありません。',

## lib/MT/Core.pm
	'This is usually \'localhost\'.' => '通常「localhost」のままで構いません。',
	'The physical file path for your SQLite database. ' => 'SQLiteのデータベースファイルのパス',
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive: [_2]' => 'パフォーマンスログを出力するディレクトリ「[_1]」を作成できませんでした。ディレクトリを書き込み可能に設定するか、または書き込みできる場所をPerformanceLoggingPathディレクティブで指定してください。: [_2]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file: [_1]' => 'パフォーマンスログを出力できませんでした。PerformanceLoggingPathにはファイルではなくディレクトリへのパスを指定してください。',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable: [_1]' => 'パフォーマンスをログを出力できませんでした。PerformanceLoggingPathにディレクトリがありますが、書き込みできません。',
	'MySQL Database (Recommended)' => 'MySQLデータベース(推奨)',
	'PostgreSQL Database' => 'PostgreSQLデータベース',
	'SQLite Database' => 'SQLiteデータベース',
	'SQLite Database (v2)' => 'SQLite(v2)データベース',
	'Database Server' => 'データベースサーバ',
	'Database Name' => 'データベース名',
	'Password' => 'パスワード',
	'Database Path' => 'データベースのパス',
	'Database Port' => 'データベースポート',
	'Database Socket' => 'データベースソケット',
	'Convert Line Breaks' => '改行を変換',
	'Rich Text' => 'リッチテキスト',
	'Movable Type Default' => 'Movable Type 既定',
	'weblogs.com' => 'weblogs.com',
	'technorati.com' => 'technorati.com',
	'google.com' => 'google.com',
	'Classic Blog' => 'クラシックブログ',
	'Publishes content.' => 'コンテンツを公開します。',
	'Synchronizes content to other server(s).' => 'コンテンツを他のサーバーに同期します。',
	'Refreshes object summaries.' => 'オブジェクトサマリーの初期化',
	'Adds Summarize workers to queue.' => 'キューにワーカーサマリーを追加します。',
	'zip' => 'zip',
	'tar.gz' => 'tar.gz',
	'Entries List' => 'ブログ記事の一覧',
	'Blog URL' => 'ブログURL',
	'Blog ID' => 'ブログID',
	'Entry Excerpt' => '概要',
	'Entry Link' => 'リンク',
	'Entry Extended Text' => '続き',
	'Entry Title' => 'タイトル',
	'If Block' => 'If条件ブロック',
	'If/Else Block' => 'If/Else条件ブロック',
	'Include Template Module' => 'テンプレートモジュールのインクルード',
	'Include Template File' => 'テンプレートファイルのインクルード',
	'Get Variable' => '変数のGet',
	'Set Variable' => '変数のSet',
	'Set Variable Block' => '変数ブロックのSet',
	'Widget Set' => 'ウィジェットセット',
	'Publish Scheduled Entries' => '日時指定されたブログ記事を再構築',
	'Add Summary Watcher to queue' => 'サマリー監視タスクをキューに追加',
	'Junk Folder Expiration' => 'スパムコメント/トラックバックの廃棄',
	'Remove Temporary Files' => 'テンポラリファイルの削除',
	'Purge Stale Session Records' => '古いセッションレコードの消去',
	'Manage Website' => 'ウェブサイトの管理',
	'Manage Blog' => 'ブログの管理',
	'Manage Website with Blogs' => 'ウェブサイトと所属ブログの管理',
	'Post Comments' => 'コメントの投稿',
	'Create Entries' => '記事の作成',
	'Edit All Entries' => 'すべてのブログ記事の編集',
	'Manage Assets' => 'アイテムの管理',
	'Manage Categories' => 'カテゴリの管理',
	'Change Settings' => '設定の変更',
	'Manage Address Book' => 'アドレス帳の管理',
	'Manage Tags' => 'タグの管理',
	'Manage Templates' => 'テンプレートの管理',
	'Manage Feedback' => 'コメント/トラックバックの管理',
	'Manage Pages' => 'ウェブページの管理',
	'Manage Users' => 'ユーザーの管理',
	'Manage Themes' => 'テーマの管理',
	'Publish Entries' => '記事の公開',
	'Save Image Defaults' => '画像に関する既定値の設定',
	'Send Notifications' => '通知の送信',
	'Set Publishing Paths' => '公開パスの設定',
	'View Activity Log' => 'ログの閲覧',
	'Create Blogs' => 'ブログの作成',
	'Create Websites' => 'ウェブサイトの作成',
	'Manage Plugins' => 'プラグインの管理',
	'View System Activity Log' => 'システムログの閲覧',

## lib/MT/DefaultTemplates.pm
	'Archive Index' => 'アーカイブインデックス',
	'Stylesheet' => 'スタイルシート',
	'JavaScript' => 'JavaScript',
	'Feed - Recent Entries' => '最新記事のフィード',
	'RSD' => 'RSD',
	'Monthly Entry Listing' => '月別ブログ記事リスト',
	'Category Entry Listing' => 'カテゴリ別ブログ記事リスト',
	'Comment Listing' => 'コメント一覧',
	'Improved listing of comments.' => 'コメント表示を改善します。',
	'Comment Response' => 'コメント完了',
	'Displays error, pending or confirmation message for comments.' => 'コメントのエラー、保留、確認メッセージを表示します。',
	'Comment Preview' => 'コメントプレビュー',
	'Displays preview of comment.' => 'コメントのプレビューを表示します。',
	'Dynamic Error' => 'ダイナミックパブリッシングエラー',
	'Displays errors for dynamically published templates.' => 'ダイナミックパブリッシングのエラーを表示します。',
	'Popup Image' => 'ポップアップ画像',
	'Displays image when user clicks a popup-linked image.' => 'ポップアップ画像を表示します。',
	'Displays results of a search.' => '検索結果を表示します。',
	'About This Page' => 'About',
	'Archive Widgets Group' => 'アーカイブウィジェットグループ',
	'Current Author Monthly Archives' => 'ユーザー月別アーカイブ',
	'Calendar' => 'カレンダー',
	'Creative Commons' => 'クリエイティブ・コモンズ',
	'Home Page Widgets Group' => 'ホームページウィジェットグループ',
	'Monthly Archives Dropdown' => '月別アーカイブ(ドロップダウン)',
	'Page Listing' => 'ページ一覧',
	'Powered By' => 'Powered By',
	'Syndication' => '購読',
	'Technorati Search' => 'Technorati Search',
	'Date-Based Author Archives' => '日付ベースのユーザーアーカイブ',
	'Date-Based Category Archives' => '日付ベースのカテゴリアーカイブ',
	'OpenID Accepted' => 'OpenID対応',
	'Comment throttle' => 'コメントスロットル',
	'Commenter Confirm' => 'コメントの確認',
	'Commenter Notify' => 'コメントの通知',
	'New Comment' => '新しいコメント',
	'New Ping' => '新しいトラックバック',
	'Entry Notify' => 'ブログ記事の共有',
	'Subscribe Verify' => '購読の確認',

## lib/MT/Entry.pm
	'record does not exist.' => 'ブログがありません。',
	'Draft' => '下書き',
	'Review' => '承認待ち',
	'Future' => '日時指定',
	'Spam' => 'スパム',
	'Status' => '更新状態',
	'Accept Comments' => 'コメントを許可',
	'Body' => '本文',
	'Extended' => '続き',
	'Format' => 'フォーマット',
	'Accept Trackbacks' => 'トラックバックを許可',
	'Publish Date' => '公開日',

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'DAV connectionに失敗しました: [_1]',
	'DAV open failed: [_1]' => 'DAV openに失敗しました: [_1]',
	'DAV get failed: [_1]' => 'DAV getに失敗しました: [_1]',
	'DAV put failed: [_1]' => 'DAV putに失敗しました: [_1]',
	'Deleting \'[_1]\' failed: [_2]' => '\'[_1]\'を削除できませんでした: [_2]',
	'Creating path \'[_1]\' failed: [_2]' => 'パス\'[_1]\'の作成に失敗しました: [_2]',
	'Renaming \'[_1]\' to \'[_2]\' failed: [_3]' => '\'[_1]\'を\'[_2]\'に変更できませんでした: [_3]',

## lib/MT/FileMgr/FTP.pm

## lib/MT/FileMgr/Local.pm

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'SFTPの接続に失敗しました: [_1]',
	'SFTP get failed: [_1]' => 'SFTPでGETに失敗しました: [_1]',
	'SFTP put failed: [_1]' => 'SFTPでPUTに失敗しました: [_1]',

## lib/MT/Folder.pm
	'Folder' => 'フォルダ',

## lib/MT/IPBanList.pm
	'IP Ban' => '禁止IPリスト',
	'IP Bans' => '禁止IPリスト',

## lib/MT/Image.pm
	'Saving [_1] failed: Invalid image file format.' => '[_1]を保存できませんでした: 画像ファイルフォーマットが不正です。',
	'File size exceeds maximum allowed: [_1] > [_2]' => 'ファイルのサイズ制限を超えています。([_1] > [_2])',
	'Can\'t load Image::Magick: [_1]' => 'Image::Magickをロードできません: [_1]',
	'Reading file \'[_1]\' failed: [_2]' => 'ファイル \'[_1]\' を読み取れませんでした: [_1]',
	'Reading image failed: [_1]' => '画像を読み取れませんでした。',
	'Scaling to [_1]x[_2] failed: [_3]' => 'サイズを[_1]x[_2]に変更できませんでした。',
	'Cropping a [_1]x[_1] square at [_2],[_3] failed: [_4]' => '[_2],[_3]の位置から[_1]x[_1]をトリミングできませんでした: [_4]',
	'Converting image to [_1] failed: [_2]' => '画像を[_1]に変換できませんでした: [_2]',
	'Can\'t load IPC::Run: [_1]' => 'IPC::Runをロードできません: [_1]',
	'Unsupported image file type: [_1]' => '[_1]は画像タイプとしてサポートされていません。',
	'Cropping to [_1]x[_1] failed: [_2]' => '[_1]x[_1]にトリミングできませんでした: [_2]',
	'Converting to [_1] failed: [_2]' => '[_1]に変換できませんでした。',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'NetPBMツールへのパスが正しく設定されていません。',
	'Can\'t load GD: [_1]' => 'GDをロードできませんでした。',

## lib/MT/Import.pm
	'Can\'t rewind' => 'ポインタを先頭に移動できません',
	'Can\'t open \'[_1]\': [_2]' => '\'[_1]\'を開けません: [_2]',
	'No readable files could be found in your import directory [_1].' => '読み取れないファイルがありました: [_1]',
	'Importing entries from file \'[_1]\'' => 'ファイル\'[_1]\'からインポートしています。',
	'Couldn\'t resolve import format [_1]' => 'インポート形式[_1]を処理できませんでした。',
	'Movable Type' => 'Movable Type',
	'Another system (Movable Type format)' => '他のシステム(Movable Type形式)',

## lib/MT/ImportExport.pm
	'No Blog' => 'ブログがありません。',
	'Need either ImportAs or ParentAuthor' => '「自分のブログ記事としてインポートする」か「ブログ記事の著者を変更しない」のどちらかを選択してください。',
	'Creating new user (\'[_1]\')...' => 'ユーザー([_1])を作成しています...',
	'Saving user failed: [_1]' => 'ユーザーを作成できませんでした: [_1]',
	'Assigning permissions for new user...' => '作成されたユーザーに権限を設定しています...',
	'Saving permission failed: [_1]' => '権限を設定できませんでした: [_1]',
	'Creating new category (\'[_1]\')...' => 'カテゴリ([_1])を作成しています...',
	'Saving category failed: [_1]' => 'カテゴリを保存できませんでした: [_1]',
	'Invalid status value \'[_1]\'' => '状態[_1]は正しくありません。',
	'Invalid allow pings value \'[_1]\'' => 'トラックバックの受信設定が不正です。',
	'Can\'t find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.' => 'タイムスタンプ\'[_1]\'に合致するブログ記事が見つかりません。コメントの処理を中止して次のブログ記事へ進みます。',
	'Importing into existing entry [_1] (\'[_2]\')' => '既存のブログ記事[_1]([_2])にインポートしています。',
	'Saving entry (\'[_1]\')...' => 'ブログ記事([_1])を保存しています...',
	'ok (ID [_1])' => '完了 (ID [_1])',
	'Saving entry failed: [_1]' => 'ブログ記事を保存できませんでした: [_1]',
	'Creating new comment (from \'[_1]\')...' => '\'[_1]\'からのコメントをインポートしています...',
	'Saving comment failed: [_1]' => 'コメントを保存できませんでした: [_1]',
	'Entry has no MT::Trackback object!' => 'ブログ記事にトラックバックの設定がありません。',
	'Creating new ping (\'[_1]\')...' => '\'[_1]\'のトラックバックをインポートしています...',
	'Saving ping failed: [_1]' => 'トラックバックを保存できませんでした: [_1]',
	'Export failed on entry \'[_1]\': [_2]' => 'エクスポートに失敗しました。ブログ記事\'[_1]\': [_2]',
	'Invalid date format \'[_1]\'; must be \'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PM is optional)' => '日付の形式が正しくありません。\'MM/DD/YYYY HH:MM:SS AM|PM\' (AM|PMは任意)でなければなりません。',

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => '結果: スパム(スコアがしきい値以下)',
	'Action: Published (default action)' => '結果: 公開(既定)',
	'Junk Filter [_1] died with: [_2]' => 'フィルタ\'[_1]\'でエラーがありました: [_2]',
	'Unnamed Junk Filter' => '(名前なし)',
	'Composite score: [_1]' => '合計点: [_1]',

## lib/MT/Log.pm
	'Log message' => 'ログ',
	'Log messages' => 'ログ',
	'Page # [_1] not found.' => 'ID:[_1]のウェブページが見つかりませんでした。',
	'Entry # [_1] not found.' => 'ID:[_1]のブログ記事が見つかりませんでした。',
	'Comment # [_1] not found.' => 'ID:[_1]のコメントが見つかりませんでした。',
	'TrackBack # [_1] not found.' => 'ID:[_1]のトラックバックが見つかりませんでした。',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'MailTransferの設定([_1])が不正です。',
	'Sending mail via SMTP requires that your server have Mail::Sendmail installed: [_1]' => 'SMTPでメールを送信するにはMail::Sendmailをインストールする必要があります: [_1]',
	'Error sending mail: [_1]' => 'メールを送信できませんでした: [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'sendmailへのパスが正しくありません。SMTPの設定を試してください。',
	'Exec of sendmail failed: [_1]' => 'sendmailを実行できませんでした: [_1]',

## lib/MT/Notification.pm
	'Contact' => '連絡先',
	'Contacts' => '連絡先',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'アイテムの関連付け',

## lib/MT/ObjectDriver/Driver/DBD/SQLite.pm

## lib/MT/ObjectScore.pm
	'Object Score' => 'オブジェクトのスコア',
	'Object Scores' => 'オブジェクトのスコア',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'タグの関連付け',
	'Tag Placements' => 'タグの関連付け',

## lib/MT/Page.pm
	'Load of blog failed: [_1]' => 'ブログをロードできませんでした: [_1]',

## lib/MT/Permission.pm
	'Permission' => '権限',

## lib/MT/Placement.pm
	'Category Placement' => 'カテゴリの関連付け',

## lib/MT/Plugin.pm
	'Publish' => '公開',
	'My Text Format' => 'My Text Format',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: ルール[_4][_5]による判定スコア - [_2][_3]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: 検査[_4]による判定スコア - [_2][_3]',

## lib/MT/PluginData.pm
	'Plugin Data' => 'プラグインデータ',

## lib/MT/Revisable.pm
	'Bad RevisioningDriver config \'[_1]\': [_2]' => 'リビジョンドライバー([_1])の設定が正しくありません: [_2]',
	'Revision not found: [_1]' => 'リビジョンがありません: [_1]',
	'There aren\'t the same types of objects, expecting two [_1]' => '同じ種類のオブジェクトではありません。両者とも[_2]である必要があります。',
	'Did not get two [_1]' => '二つの[_1]を取得できませんでした。',
	'Unknown method [_1]' => '不正な比較メソッド([_1])です。',
	'Revision Number' => 'リビジョン番号',

## lib/MT/Revisable/Local.pm

## lib/MT/Role.pm
	'Role' => 'ロール',
	'Website Administrator' => 'ウェブサイト管理者',
	'Can administer the website.' => 'ウェブサイトを管理できます。',
	'Blog Administrator' => 'ブログ管理者',
	'Can administer the blog.' => 'ブログの管理者です。',
	'Editor' => '編集者',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'ファイルをアップロードし、ブログ記事(カテゴリ)、ウェブページ(フォルダ)、タグを編集して公開できます。',
	'Can create entries, edit their own entries, upload files and publish.' => '記事を作成し、各自の記事の編集とファイルのアップロード、およびそれらを公開できます。',
	'Designer' => 'デザイナ',
	'Can edit, manage, and publish blog templates and themes.' => 'テンプレートとテーマの編集し、管理し、それらを公開できます。',
	'Webmaster' => 'ウェブマスター',
	'Can manage pages, upload files and publish blog templates.' => 'ページを管理し、ファイルをアップロードし、ブログテンプレートを公開できます。',
	'Contributor' => 'ライター',
	'Can create entries, edit their own entries, and comment.' => '記事の作成、各自の記事とコメントを編集できます。',
	'Moderator' => 'モデレータ',
	'Can comment and manage feedback.' => 'コメントを投稿し、コメントやトラックバックを管理できます。',
	'Can comment.' => 'コメントを投稿できます。',

## lib/MT/Scorable.pm
	'Object must be saved first.' => 'オブジェクトが保存されていません。',
	'Already scored for this object.' => 'すでに1度評価しています。',
	'Could not set score to the object \'[_1]\'(ID: [_2])' => '[_1](ID: [_2])にスコアを設定できませんでした。',

## lib/MT/Session.pm
	'Session' => 'セッション',

## lib/MT/TBPing.pm
	'TrackBack' => 'トラックバック',

## lib/MT/Tag.pm
	'Tag must have a valid name' => 'タグの名前が不正です。',
	'This tag is referenced by others.' => 'このタグは他のタグから参照されています。',

## lib/MT/TaskMgr.pm
	'Unable to secure lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'タスクを実行するために必要なロックを獲得できませんでした。TempDir([_1])に書き込みできるかどうか確認してください。',
	'Error during task \'[_1]\': [_2]' => '\'[_1]\'の実行中にエラーが発生しました: [_2]',
	'Scheduled Tasks Update' => 'スケジュールされたタスク',
	'The following tasks were run:' => '以下のタスクを実行しました:',

## lib/MT/Template.pm
	'Template' => 'テンプレート',
	'File not found: [_1]' => 'ファイルが見つかりません: [_1]',
	'Error reading file \'[_1]\': [_2]' => 'ファイル: [_1]を読み込めませんでした: [_2]',
	'Publish error in template \'[_1]\': [_2]' => 'テンプレート「[_1]」の再構築中にエラーが発生しました: [_2]',
	'Template with the same name already exists in this blog.' => 'ブログに同名のテンプレートが存在します。',
	'You cannot use a [_1] extension for a linked file.' => '[_1]をリンクファイルの拡張子に使うことはできません。',
	'Opening linked file \'[_1]\' failed: [_2]' => 'リンクファイル\'[_1]\'を開けませんでした: [_2]',
	'Index' => 'インデックス',
	'Category Archive' => 'カテゴリアーカイブ',
	'Ping Listing' => 'トラックバック一覧',
	'Comment Error' => 'コメントエラー',
	'Comment Pending' => 'コメント保留中',
	'Uploaded Image' => '画像',
	'Module' => 'モジュール',
	'Widget' => 'ウィジェット',
	'Output File' => '出力ファイル名',
	'Template Text' => 'テンプレート本文',
	'Rebuild with Indexes' => 'インデックスの歳構築',
	'Dynamicity' => 'ダイナミック',
	'Build Type' => '構築タイプ',
	'Interval' => '間隔',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'[_1]\' for a value.' => 'exclude_blogs属性には\'[_1]\'を設定できません。',
	'You used an \'[_1]\' tag outside of the context of a author; perhaps you mistakenly placed it outside of an \'MTAuthors\' container?' => '[_1]をコンテキスト外で利用しようとしています。MTAuthorsコンテナタグの外部で使っていませんか?',
	'You used an \'[_1]\' tag outside of the context of an entry; perhaps you mistakenly placed it outside of an \'MTEntries\' container?' => '[_1]をコンテキスト外で利用しようとしています。MTEntriesコンテナタグの外部で使っていませんか?',
	'You used an \'[_1]\' tag outside of the context of the website; perhaps you mistakenly placed it outside of an \'MTWebsites\' container?' => '[_1]をコンテキスト外で利用しようとしています。MTWebsitesコンテナタグの外部で使っていませんか?',
	'You used an \'[_1]\' tag outside of the context of the blog; perhaps you mistakenly placed it outside of an \'MTBlogs\' container?' => '[_1]をコンテキスト外で利用しようとしています。MTBlogsコンテナタグの外部で使っていませんか?',
	'You used an \'[_1]\' tag outside of the context of a comment; perhaps you mistakenly placed it outside of an \'MTComments\' container?' => '[_1]をコメントのコンテキスト外で利用しようとしました。MTCommentsコンテナの外部に配置していませんか?',
	'You used an \'[_1]\' tag outside of the context of a ping; perhaps you mistakenly placed it outside of an \'MTPings\' container?' => '[_1]タグをトラックバックのコンテキスト外で利用しようとしました。MTPingsコンテナの外部に配置していませんか?',
	'You used an \'[_1]\' tag outside of the context of an asset; perhaps you mistakenly placed it outside of an \'MTAssets\' container?' => '[_1]をAssetのコンテキスト外で利用しようとしました。MTAssetsコンテナの外部に配置していませんか?',
	'You used an \'[_1]\' tag outside of the context of a page; perhaps you mistakenly placed it outside of a \'MTPages\' container?' => '[_1]をPageのコンテキスト外で利用しようとしました。MTPagesコンテナの外部に配置していませんか?',

## lib/MT/Template/ContextHandlers.pm
	'Warning' => '警告',
	'All About Me' => 'All About Me',
	'Remove this widget' => 'このウィジェットを削除',
	'[_1]Publish[_2] your site to see these changes take effect.' => '設定を有効にするために[_1]再構築[_2]してください。',
	'Actions' => 'アクション',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.jp/documentation/appendices/tags/%t.html',
	'You used an [_1] tag without a date context set up.' => '[_1]を日付コンテキストの外部で利用しようとしました。',
	'Division by zero.' => 'ゼロ除算エラー',
	'[_1] is not a hash.' => '[_1]はハッシュではありません。',
	'No [_1] could be found.' => '[_1]が見つかりません。',
	'records' => 'オブジェクト',
	'No template to include specified' => 'インクルードするテンプレートが見つかりませんでした。',
	'Recursion attempt on [_1]: [_2]' => '[_1]でお互いがお互いを参照している状態になっています: [_2]',
	'Can\'t find included template [_1] \'[_2]\'' => '「[_2]」という[_1]テンプレートが見つかりませんでした。',
	'Writing to \'[_1]\' failed: [_2]' => '\'[_1]\'に書き込めませんでした: [_2]',
	'Can\'t find blog for id \'[_1]' => 'ID;[_1]のブログが見つかりませんでした。',
	'Can\'t find included file \'[_1]\'' => '[_1]というファイルが見つかりませんでした。',
	'Error opening included file \'[_1]\': [_2]' => '[_1]を開けませんでした: [_2]',
	'Recursion attempt on file: [_1]' => '[_1]でお互いがお互いを参照している状態になっています。',
	'Can\'t load user.' => 'ユーザーをロードできませんでした。',
	'Can\'t find template \'[_1]\'' => '\'[_1]\'というテンプレートが見つかりませんでした。',
	'Can\'t find entry \'[_1]\'' => '\'[_1]\'というブログ記事が見つかりませんでした。',
	'Unspecified archive template' => 'アーカイブテンプレートが指定されていません。',
	'Error in file template: [_1]' => 'ファイルテンプレートでエラーが発生しました: [_1]',
        'Error in [_1] [_2]: [_3]' => '[_1]「[_2]」でエラーが発生しました: [_3]',

## lib/MT/Template/Tags/Archive.pm
	'Group iterator failed.' => 'アーカイブのロードでエラーが発生しました。',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1]は日別、週別、月別の各アーカイブでのみ利用できます。',
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => '[_2]アーカイブにリンクするために[_1]タグを使っていますが、アーカイブを出力していません。',
	'You used an [_1] tag outside of the proper context.' => '[_1]タグを不正なコンテキストで利用しようとしました。',
	'Could not determine entry' => 'ブログ記事を取得できませんでした。',

## lib/MT/Template/Tags/Asset.pm
	'No such user \'[_1]\'' => 'ユーザー([_1])が見つかりません。',
	'You have an error in your \'[_2]\' attribute: [_1]' => '[_2]属性でエラーがありました: [_1]',

## lib/MT/Template/Tags/Author.pm
	'The \'[_2]\' attribute will only accept an integer: [_1]' => '[_2]属性は整数以外は無効です。',
	'You used an [_1] without a author context set up.' => '[_1]をユーザーのコンテキスト外部で利用しようとしました。',

## lib/MT/Template/Tags/Calendar.pm
	'Invalid month format: must be YYYYMM' => 'YYYYMM形式でなければなりません。',
	'No such category \'[_1]\'' => '[_1]というカテゴリはありません。',

## lib/MT/Template/Tags/Category.pm
	'MT[_1] must be used in a [_2] context' => 'MT[_1]は[_2]のコンテキスト外部では利用できません。',
	'Cannot find package [_1]: [_2]' => '[_1]というパッケージが見つかりませんでした: [_2]',
	'Error sorting [_2]: [_1]' => '[_2]の並べ替えでエラーが発生しました: [_1]',
	'[_1] cannot be used without publishing Category archive.' => 'カテゴリアーカイブを公開していないので[_1]は使えません。',
	'[_1] used outside of [_2]' => '[_1]を[_2]の外部で利用しようとしました。',

## lib/MT/Template/Tags/Comment.pm
	'The MTCommentFields tag is no longer available; please include the [_1] template module instead.' => 'MTCommentFieldsタグは利用できません。代わりにテンプレートモジュール「[_1]」をインクルードしてください。',
	'Comment Form' => 'コメント入力フォーム',
	'To enable comment registration, you need to add a TypePad token in your weblog config or user profile.' => 'コメント投稿者を登録するためにTypePadトークンをブログの設定またはユーザーのプロフィールに設定してください。',

## lib/MT/Template/Tags/Commenter.pm

## lib/MT/Template/Tags/Entry.pm
	'You used <$MTEntryFlag$> without a flag.' => '<$MTEntryFlag$>をフラグなしで利用しようとしました。',
	'Could not create atom id for entry [_1]' => 'ブログ記事のAtom IDを作成できませんでした。',

## lib/MT/Template/Tags/Folder.pm

## lib/MT/Template/Tags/Misc.pm
	'name is required.' => 'nameを指定してください。',
	'Specified WidgetSet \'[_1]\' not found.' => 'ウィジェットセット「[_1]」が見つかりません。',

## lib/MT/Template/Tags/Ping.pm
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$>はカテゴリのコンテキストかまたはcategory属性とともに利用してください。',

## lib/MT/TemplateMap.pm
	'Archive Mapping' => 'アーカイブマッピング',
	'Archive Mappings' => 'アーカイブマッピング',

## lib/MT/TheSchwartz/Error.pm
	'Job Error' => 'ジョブエラー',

## lib/MT/TheSchwartz/ExitStatus.pm
	'Job Exit Status' => 'ジョブ終了状態',

## lib/MT/TheSchwartz/FuncMap.pm
	'Job Function' => 'ジョブファンクション',

## lib/MT/TheSchwartz/Job.pm
	'Job' => 'ジョブ',

## lib/MT/Theme.pm
	'Failed to load theme [_1].' => '[_1]テーマの読込に失敗しました。',
	'A fatal error occurred while applying element [_1]: [_2].' => '項目「[_1]」を適用する際に、重大なエラーが発生しました: [_2]',
	'An error occurred while applying element [_1]: [_2].' => '項目「[_1]」を適用する際に、エラーが発生しました: [_2]',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but is not installed.' => 'このテーマには、次の項目の指定のバージョン以上が必要です。: [_1]: バージョン[_2]以上',
	'Component \'[_1]\' version [_2] or greater is needed to use this theme, but the installed version is [_3].' => 'このテーマには、次の項目の指定のバージョン以上が必要です。: [_1]: バージョン[_2]以上 (インストール済みのバージョンは[_3])',
	'Element \'[_1]\' cannot be applied because [_2]' => '次の項目が適用できません: [_1] (原因: [_2])',
	'There was an error scaling image [_1].' => '画像のサイズ変更でエラーが発生しました: [_1]',
	'There was an error converting image [_1].' => '画像の変換でエラーが発生しました: [_1]',
	'There was an error creating thumbnail file [_1].' => '画像のサムネイル作成でエラーが発生しました: [_1]',
	'Default Prefs' => '既定の設定',
	'Template Set' => 'テンプレートセット',
	'Static Files' => 'ファイル',
	'Default Pages' => '既定のページ',

## lib/MT/Theme/Category.pm
	'[_1] top level and [_2] sub categories.' => 'トップレベルカテゴリ([_1])とサブカテゴリ([_2])',
	'[_1] top level and [_2] sub folders.' => 'トップレベルフォルダ([_1])とサブフォルダ([_2])',

## lib/MT/Theme/Element.pm
	'Component \'[_1]\' is not found.' => '次の項目が見つかりません: [_1]',
	'Internal error: the importer is not found.' => '内部エラー : インポーターが見つかりません。',
	'Compatibility error occured while applying \'[_1]\': [_2].' => '次の項目の適用時にエラーが発生しました: [_1]: [_2]',
	'An Error occured while applying \'[_1]\': [_2].' => '[_1]の適用中にエラーが発生しました: [_2]。',
	'Fatal error occured while applying \'[_1]\': [_2].' => '次の項目の適用時に重大なエラーが発生しました: [_1]: [_2]',
	'Importer for \'[_1]\' is too old.' => '次の項目のインポーターが古すぎます: [_1]',
	'Theme element \'[_1]\' is too old for this environment.' => '次の項目が、この環境では古すぎます: [_1]',

## lib/MT/Theme/Entry.pm
	'[_1] pages' => '[_1]ページ',

## lib/MT/Theme/Pref.pm
	'this element cannot apply for non blog object.' => 'この要素はブログオブジェクト以外には適用できません。',
	'Failed to save blog object: [_1]' => 'ブログオブジェクトの保存に失敗しました。: [_1]',
	'default settings for [_1]' => '[_1]の既定の設定',
	'default settings' => '既定の設定',

## lib/MT/Theme/TemplateSet.pm
	'A template set containing [_1] templates, [_2] widgets, and [_3] widget sets.' => 'テンプレートセット([_1]テンプレート, [_2]ウィジェット, [_3]ウィジェットセット)',
	'Widget Sets' => 'ウィジェットセット',
	'Failed to make templates directory: [_1]' => 'テンプレート用のディレクトリの作成に失敗しました: [_1]',
	'Failed to publish template file: [_1]' => 'テンプレートファイルの公開に失敗しました: [_1]',
	'exported_template set' => 'エクスポート済テンプレートセット',

## lib/MT/Trackback.pm

## lib/MT/Upgrade.pm
	'Invalid upgrade function: [_1].' => '不正なアップグレード機能を実行しようとしました: [_1]',
	'Error loading class [_1].' => '[_1]をロードできません。',
	'Upgrading table for [_1] records...' => '[_1]のテーブルを更新しています...',
	'Upgrading database from version [_1].' => 'データベースをバージョン [_1]から更新しています...',
	'Database has been upgraded to version [_1].' => 'データベースをバージョン[_1]にアップグレードしました。',
	'User \'[_1]\' upgraded database to version [_2]' => '\'[_1]\'がデータベースをバージョン[_2]にアップグレードしました。',
	'Plugin \'[_1]\' upgraded successfully to version [_2] (schema version [_3]).' => 'プラグイン\'[_1]\'をバージョン[_2] (スキーマバージョン[_3])にアップグレードしました。',
	'User \'[_1]\' upgraded plugin \'[_2]\' to version [_3] (schema version [_4]).' => '\'[_1]\'がプラグイン([_2])をバージョン[_3](スキーマバージョン[_4])にアップグレードしました。',
	'Plugin \'[_1]\' installed successfully.' => 'プラグイン\'[_1]\'をインストールしました。',
	'User \'[_1]\' installed plugin \'[_2]\', version [_3] (schema version [_4]).' => '\'[_1]\'がプラグイン([_2]、バージョン[_3]、スキーマバージョン[_4])をインストールしました。',
	'Error loading class: [_1].' => 'クラスをロードできませんでした: [_1]',
	'Assigning entry comment and TrackBack counts...' => 'コメントとトラックバックの件数を設定しています....',
	'Error saving [_1] record # [_3]: [_2]...' => '[_1]のレコード(ID:[_3])を保存できませんでした: [_2]',

## lib/MT/Upgrade/Core.pm
	'Upgrading Asset path informations...' => 'アイテムパス情報を更新しています...',
	'Creating initial website and user records...' => '初期ユーザーとウェブサイトを作成しています...',
	'Error saving record: [_1].' => 'レコードを保存できません: [_1]',
	'Error creating role record: [_1].' => 'ロールレコード作成エラー: [_1]',
	'First Website' => 'First Website',
	'Creating new template: \'[_1]\'.' => '新しいテンプレート[_1]を作成しています...',
	'Mapping templates to blog archive types...' => 'テンプレートをブログのアーカイブタイプに適用しています...',
	'Assigning custom dynamic template settings...' => 'ダイナミックテンプレートの設定を適用しています...',
	'Assigning user types...' => 'ユーザーの種類を設定しています...',
	'Assigning category parent fields...' => 'カテゴリのparentフィールドを設定しています...',
	'Assigning template build dynamic settings...' => 'テンプレートにダイナミックパブリッシングの設定を適用しています...',
	'Assigning visible status for comments...' => 'コメントに表示状態を設定しています...',
	'Assigning visible status for TrackBacks...' => 'トラックバックに表示状態を設定しています...',

## lib/MT/Upgrade/v1.pm
	'Creating template maps...' => 'テンプレートマップを作成しています...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'テンプレート(ID:[_1])を[_2]([_3])にマッピングしています...',
	'Mapping template ID [_1] to [_2].' => 'テンプレート(ID:[_1])を[_2]にマッピングしています...',
	'Creating entry category placements...' => 'ブログ記事とカテゴリの関連付けを作成しています...',

## lib/MT/Upgrade/v2.pm
	'Updating category placements...' => 'カテゴリの関連付けを更新しています...',
	'Assigning comment/moderation settings...' => 'コメントとコメントの保留設定を適用しています...',

## lib/MT/Upgrade/v3.pm
	'Custom ([_1])' => 'カスタム ([_1])',
	'This role was generated by Movable Type upon upgrade.' => 'このロールはアップグレード時にMovable Typeが作成しました。',
	'Removing Dynamic Site Bootstrapper index template...' => 'Dynamic Site Bootstrapperテンプレートを削除しています...',
	'Creating configuration record.' => '構成データを作成しています。',
	'Setting your permissions to administrator.' => '管理者権限にしています。',
	'Setting blog basename limits...' => '出力ファイル名の長さの既定値を設定しています...',
	'Setting default blog file extension...' => '既定のファイル拡張子を設定しています...',
	'Updating comment status flags...' => 'コメントの状態フラグを更新しています...',
	'Updating commenter records...' => 'コメント投稿者のレコードを更新しています...',
	'Assigning blog administration permissions...' => 'ブログの管理権限を適用しています...',
	'Setting blog allow pings status...' => 'ブログのトラックバック受信設定を適用しています...',
	'Updating blog comment email requirements...' => 'コメントのメール必須設定を適用しています...',
	'Assigning entry basenames for old entries...' => '既存のブログ記事に出力ファイル名を設定しています...',
	'Updating user web services passwords...' => 'ユーザーのWebサービスパスワードを更新しています...',
	'Updating blog old archive link status...' => 'ブログのアーカイブリンクの状態を更新しています...',
	'Updating entry week numbers...' => 'ブログ記事の週番号を更新しています...',
	'Updating user permissions for editing tags...' => 'タグを編集する権限を適用しています...',
	'Setting new entry defaults for blogs...' => 'ブログにブログ記事の初期設定を適用しています...',
	'Migrating any "tag" categories to new tags...' => '"tag"カテゴリをタグに移行しています...',
	'Assigning basename for categories...' => 'カテゴリに出力ファイル/フォルダ名を設定しています...',
	'Assigning user status...' => 'ユーザーの状態を設定しています...',
	'Migrating permissions to roles...' => '権限をロールに移行しています...',

## lib/MT/Upgrade/v4.pm
	'Comment Posted' => 'コメント投稿完了',
	'Your comment has been posted!' => 'コメントを投稿しました。',
	'Your comment submission failed for the following reasons:' => 'コメントの投稿に失敗しました:',
	'[_1]: [_2]' => '[_1]: [_2]',
	'Migrating permission records to new structure...' => '権限のデータを移行しています...',
	'Migrating role records to new structure...' => 'ロールのデータを移行しています...',
	'Migrating system level permissions to new structure...' => 'システム権限を移行しています...',
	'Updating system search template records...' => 'システムテンプレート「検索結果」を更新しています...',
	'Renaming PHP plugin file names...' => 'phpプラグインのファイル名を変更しています...',
	'Error renaming PHP files. Please check the Activity Log.' => 'PHPファイルの名前を変更できませんでした。ログを確認してください。',
	'Cannot rename in [_1]: [_2].' => '[_1]の名前を変更できません: [_2]',
	'Migrating Nofollow plugin settings...' => 'NoFollowプラグインの設定を移行しています...',
	'Removing unnecessary indexes...' => '不要なインデックスを削除しています...',
	'Moving metadata storage for categories...' => 'カテゴリのメタデータの格納場所を移動しています...',
	'Upgrading metadata storage for [_1]' => '[_1]のメタデータの格納場所を変更しています...',
	'Updating password recover email template...' => 'パスワードの再設定(メール テンプレート)を更新しています...',
	'Assigning junk status for comments...' => 'コメントにスパム状態を設定しています...',
	'Assigning junk status for TrackBacks...' => 'トラックバックにスパム状態を設定しています...',
	'Populating authored and published dates for entries...' => 'ブログ記事の作成日と公開日を設定しています...',
	'Updating widget template records...' => 'ウィジェットテンプレートを更新しています...',
	'Classifying category records...' => 'カテゴリのデータにクラスを設定しています...',
	'Classifying entry records...' => 'ブログ記事のデータにクラスを設定しています...',
	'Merging comment system templates...' => 'コメント関連のシステムテンプレートをマージしています...',
	'Populating default file template for templatemaps...' => 'テンプレートマップにテンプレートを設定しています...',
	'Removing unused template maps...' => '使用されていないテンプレートマップを削除しています...',
	'Assigning user authentication type...' => 'ユーザーに認証タイプを設定しています...',
	'Adding new feature widget to dashboard...' => '新機能紹介のウィジェットをダッシュボードに追加しています...',
	'Moving OpenID usernames to external_id fields...' => '既存のOpenIDユーザー名を移動しています...',
	'Assigning blog template set...' => 'ブログにテンプレートセットを設定しています...',
	'Assigning blog page layout...' => 'ブログにページレイアウトを設定しています...',
	'Assigning author basename...' => 'ユーザーにベースネームを設定しています...',
	'Assigning embedded flag to asset placements...' => 'アイテムの関連付けの有無を設定しています...',
	'Updating template build types...' => 'テンプレートのビルドオプションを設定しています...',
	'Replacing file formats to use CategoryLabel tag...' => 'ファイルフォーマットをMTCategoryLabelに変換しています...',

## lib/MT/Upgrade/v5.pm
	'Populating generic website for current blogs...' => '現在のブログをウェブサイトへ変換しています...',
	'Generic Website' => '標準のウェブサイト',
	'Migrating [_1]([_2]).' => '[_1]([_2])を移行しています。',
	'Granting new role to system administrator...' => 'システム管理者に新しいロールを付与しています...',
	'Updating existing role name...' => '既存のロール名を更新しています...',
	'_WEBMASTER_MT4' => 'ウェブサイト管理者',
	'Webmaster (MT4)' => 'ウェブサイト管理者(MT4)',
	'Populating new role for website...' => 'ウェブサイト用の新しいロールへ変換しています...',
	'Can manage pages, Upload files and publish blog templates.' => 'ページを管理し、ファイルをアップロードし、ブログテンプレートを公開できます。',
	'Designer (MT4)' => 'デザイナ(MT4)',
	'Populating new role for theme...' => 'テーマ用の新しいロールへ変換しています...',
	'Can edit, manage and publish blog templates and themes.' => 'ブログテンプレートとテーマを更新し、管理し、それらを公開できます。',
	'Assigning new system privilege for system administrator...' => 'システム管理者用の新しい権限を設定しています...',
	'Assigning to  [_1]...' => '[_1]を設定しています...',
	'Migrating mtview.php to MT5 style...' => 'mtview.phpをMT5で利用できるように移行しています...',
	'Migrating DefaultSiteURL/DefaultSiteRoot to website...' => 'DefaultSiteURL/DefaultSiteRootをウェブサイト用に移行しています。。。',
	'New user\'s website' => '新規ユーザー向けウェブサイト',
	'Migrating existing [quant,_1,blog,blogs] into websites and its children...' => '既存のブログをウェブサイトで管理できるように移行しています。',
	'Error loading role: [_1].' => 'ロールのロードエラー: [_1]',
	'New WebSite [_1]' => '新しいウェブサイト: [_1]',
	'An error occured during generating a website upon upgrade: [_1]' => 'ウェブサイトへの移行中にエラーが発生しました: [_1]',
	'Generated a website [_1]' => '作成されたウェブサイト: [_1]',
	'An error occured during migrating a blog\'s site_url: [_1]' => 'ブログのサイトURLの移行中にエラーが発生しました: [_1]',
	'Moved blog [_1] ([_2]) under website [_3]' => '[_1]ブログ([_2])を[_3]ウェブサイト下に移動しました',
	'Merging dashboard settings...' => 'ダッシュボート設定を移行しています...',
	'Classifying blogs...' => 'ブログを分類しています...',
	'Rebuilding permissions...' => '権限を再構築しています...',
 'Removing technorati update-ping service from [_1] (ID:[_2]).' => 'ブログ[_1](ID:[_2])の更新通知先からテクノラティを削除しました。',

## lib/MT/Util.pm
	'moments from now' => '今から',
	'[quant,_1,hour,hours] from now' => '[quant,_1,時間,時間]後',
	'[quant,_1,minute,minutes] from now' => '[quant,_1,分,分]後',
	'[quant,_1,day,days] from now' => '[quant,_1,日,日]後',
	'less than 1 minute from now' => '1分後以内',
	'less than 1 minute ago' => '1分以内',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => '[quant,_1,時間,時間], [quant,_2,分,分]後',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => '[quant,_1,時間,時間], [quant,_2,分,分]前',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => '[quant,_1,日,日], [quant,_2,時間,時間]後',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => '[quant,_1,日,日], [quant,_2,時間,時間]前',
	'[quant,_1,second,seconds] from now' => '[quant,_1,秒,秒]後',
	'[quant,_1,second,seconds]' => '[quant,_1,秒,秒]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => '[quant,_1,分,分], [quant,_2,秒,秒]後',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,分,分], [quant,_2,秒,秒]',
	'[quant,_1,minute,minutes]' => '[quant,_1,分,分]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,時間,時間], [quant,_2,分,分]',
	'[quant,_1,hour,hours]' => '[quant,_1,時間,時間]',
	'[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,日,日], [quant,_2,時間,時間]',
	'[quant,_1,day,days]' => '[quant,_1,日,日]',
	'Invalid domain: \'[_1]\'' => 'ドメイン「[_1]」が不正です。',

## lib/MT/Util/Archive.pm
	'Type must be specified' => '種類を指定してください。',
	'Registry could not be loaded' => 'レジストリをロードできませんでした。',

## lib/MT/Util/Archive/Tgz.pm
	'Type must be tgz.' => 'TGZが指定されていません。',
	'Could not read from filehandle.' => 'ファイルを読みだせませんでした。',
	'File [_1] is not a tgz file.' => '[_1]はTGZファイルではありません。',
	'File [_1] exists; could not overwrite.' => '[_1]が既に存在します。上書きできません。',
	'Can\'t extract from the object' => '解凍できません。',
	'Can\'t write to the object' => '書き込みできません。',
	'Both data and file name must be specified.' => 'データとファイルの両方を指定してください。',

## lib/MT/Util/Archive/Zip.pm
	'Type must be zip' => 'ZIPが指定されていません。',
	'File [_1] is not a zip file.' => '[_1]はZIPファイルではありません。',

## lib/MT/Util/Captcha.pm
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'Movable Type 既定のCAPTCHAプロバイダはImage::Magickをインストールしないと使えません。',
	'You need to configure CaptchaSourceImageBase.' => '構成ファイルでCaptchaSourceImageBaseを設定してください。',
	'Image creation failed.' => '画像を作成できませんでした。',
	'Image error: [_1]' => '画像でエラーが発生しました: [_1]',

## lib/MT/Util/YAML/Syck.pm

## lib/MT/Util/YAML/Tiny.pm

## lib/MT/WeblogPublisher.pm
	'Archive type \'[_1]\' is not a chosen archive type' => '\'[_1]\'はアーカイブタイプとして選択されていません。',
	'Parameter \'[_1]\' is required' => '\'[_1]\'をパラメータに指定してください。',
	'You did not set your blog publishing path' => 'ブログの公開パスを設定していません。',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => '同名のファイルがすでに存在します。ファイル名またはアーカイブパスを変更してください([_1])。',
	'An error occurred publishing [_1] \'[_2]\': [_3]' => '[_1]「[_2]」の再構築中にエラーが発生しました: [_3]',
	'An error occurred publishing date-based archive \'[_1]\': [_2]' => '日付アーカイブ「[_1]」の再構築中にエラーが発生しました: [_2]',
	'Renaming tempfile \'[_1]\' failed: [_2]' => 'テンポラリファイル\'[_1]\'の名前を変更できませんでした: [_2]',
	'Blog, BlogID or Template param must be specified.' => 'Blog, BlogID, またはTemplateのいずれかを指定してください。',
	'Template \'[_1]\' does not have an Output File.' => 'テンプレート\'[_1]\'には出力ファイルの設定がありません。',
	'An error occurred while publishing scheduled entries: [_1]' => '日時指定されたブログ記事の再構築中にエラーが発生しました: [_1]',

## lib/MT/Website.pm

## lib/MT/Worker/Publish.pm
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- 完了 ([_1]ファイル - [_2]秒)',

## lib/MT/Worker/Sync.pm
	'Synchrnizing Files Done' => 'ファイルを同期しました。',
	'Done syncing files to [_1] ([_2])' => '[_1]へファイルを同期しました。([_2])',

## lib/MT/XMLRPC.pm
	'No WeblogsPingURL defined in the configuration file' => '構成ファイルにWeblogsPingURLが設定されていません。',
	'No MTPingURL defined in the configuration file' => '構成ファイルにMTPingURLが設定されていません。',
	'HTTP error: [_1]' => 'HTTPエラー: [_1]',
	'Ping error: [_1]' => 'Pingエラー: [_1]',

## lib/MT/XMLRPCServer.pm
	'Invalid timestamp format' => 'timestampの形式が不正です。',
	'No web services password assigned.  Please see your user profile to set it.' => 'Webサービスパスワードを設定していません。ユーザー情報の編集の画面で設定してください。',
	'Requested permalink \'[_1]\' is not available for this page' => '[_1]というパーマリンクはこのページにはありません。',
	'Saving folder failed: [_1]' => 'フォルダを保存できませんでした: [_1]',
	'No blog_id' => 'No blog_id',
	'Value for \'mt_[_1]\' must be either 0 or 1 (was \'[_2]\')' => 'mt_[_1]の値は0か1です([_2]を設定しようとしました)。',
	'Not privileged to edit entry' => 'ブログ記事を編集する権限がありません。',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => '\'[_3]\'(ID:[_4])がXMLRPC経由で[_5]\'[_1]\'(ID:[_2])を削除しました。',
	'Not privileged to get entry' => 'ブログ記事を取得する権限がありません。',
	'Not privileged to set entry categories' => 'カテゴリを設定する権限がありません。',
	'Not privileged to upload files' => 'ファイルをアップロードする権限がありません。',
	'No filename provided' => 'ファイル名がありません。',
	'Error writing uploaded file: [_1]' => 'アップロードされたファイルを書き込めませんでした: [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Templateメソッドは実装されていません。',

## mt-static/jquery/jquery.mt.js

## mt-static/js/assetdetail.js
	'No Preview Available' => 'プレビューできません',
	'View uploaded file' => 'アップロードされたファイルを表示',

## mt-static/js/dialog.js
	'(None)' => '(なし)',

## mt-static/js/tc/mixer/display.js
	'Title:' => 'タイトル:',
	'Description:' => '説明:',
	'Author:' => '作者:',
	'Tags:' => 'タグ: ',
	'URL:' => 'URL:',

## mt-static/mt.js
	'delete' => '削除',
	'remove' => '削除',
	'enable' => '有効に',
	'disable' => '無効に',
	'You did not select any [_1] to [_2].' => '[_2]する[_1]が選択されていません。',
	'Are you sure you want to [_2] this [_1]?' => '[_1]を[_2]してよろしいですか?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => '[_1]件の[_2]を[_3]してよろしいですか?',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'このロールを本当に削除してもよろしいですか? ロールを通じて権限を付与されているすべてのユーザーとグループから権限を剥奪することになります。',
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => 'これら[_1]つのロールをしてもよろしいですか? 削除してしまうと、これらのロールを通じて権限を付与されているすべてのユーザーとグループから権限を剥奪することになります。',
	'You did not select any [_1] [_2].' => '[_2]する[_1]が選択されていません。',
	'You can only act upon a minimum of [_1] [_2].' => '最低でも[_1]を選択してください。',
	'You can only act upon a maximum of [_1] [_2].' => '最大で[_1]件しか選択できません。',
	'You must select an action.' => 'アクションを選択してください。',
	'to mark as spam' => 'スパムに指定',
	'to remove spam status' => 'スパム指定を解除',
	'Enter email address:' => 'メールアドレスを入力:',
	'Enter URL:' => 'URLを入力:',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\'?' => 'タグ\'[_2]\'はすでに存在します。\'[_1]\'を\'[_2]\'に統合してもよろしいですか? ',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all weblogs?' => 'タグ\'[_2]\'はすでに存在します。\'[_1]\'を\'[_2]\'に統合してもよろしいですか?',
	'Loading...' => 'ロード中...',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] / [_3]',
	'[_1] &ndash; [_2]' => '[_1] &ndash; [_2]',

## themes/classic_blog/templates/about_this_page.mtml

## themes/classic_blog/templates/archive_index.mtml

## themes/classic_blog/templates/archive_widgets_group.mtml

## themes/classic_blog/templates/author_archive_list.mtml

## themes/classic_blog/templates/banner_footer.mtml

## themes/classic_blog/templates/calendar.mtml

## themes/classic_blog/templates/category_archive_list.mtml

## themes/classic_blog/templates/category_entry_listing.mtml

## themes/classic_blog/templates/comment_detail.mtml

## themes/classic_blog/templates/comment_listing.mtml

## themes/classic_blog/templates/comment_preview.mtml

## themes/classic_blog/templates/comment_response.mtml

## themes/classic_blog/templates/comment_throttle.mtml

## themes/classic_blog/templates/commenter_confirm.mtml

## themes/classic_blog/templates/commenter_notify.mtml

## themes/classic_blog/templates/comments.mtml

## themes/classic_blog/templates/creative_commons.mtml

## themes/classic_blog/templates/current_author_monthly_archive_list.mtml

## themes/classic_blog/templates/current_category_monthly_archive_list.mtml

## themes/classic_blog/templates/date_based_author_archives.mtml

## themes/classic_blog/templates/date_based_category_archives.mtml

## themes/classic_blog/templates/dynamic_error.mtml

## themes/classic_blog/templates/entry.mtml

## themes/classic_blog/templates/entry_summary.mtml

## themes/classic_blog/templates/footer-email.mtml

## themes/classic_blog/templates/javascript.mtml

## themes/classic_blog/templates/main_index.mtml

## themes/classic_blog/templates/main_index_widgets_group.mtml

## themes/classic_blog/templates/monthly_archive_dropdown.mtml

## themes/classic_blog/templates/monthly_archive_list.mtml

## themes/classic_blog/templates/monthly_entry_listing.mtml

## themes/classic_blog/templates/new-comment.mtml

## themes/classic_blog/templates/new-ping.mtml

## themes/classic_blog/templates/notify-entry.mtml

## themes/classic_blog/templates/openid.mtml

## themes/classic_blog/templates/page.mtml

## themes/classic_blog/templates/pages_list.mtml

## themes/classic_blog/templates/powered_by.mtml

## themes/classic_blog/templates/recent_assets.mtml

## themes/classic_blog/templates/recent_comments.mtml

## themes/classic_blog/templates/recent_entries.mtml

## themes/classic_blog/templates/recover-password.mtml

## themes/classic_blog/templates/search.mtml

## themes/classic_blog/templates/search_results.mtml

## themes/classic_blog/templates/sidebar.mtml

## themes/classic_blog/templates/signin.mtml

## themes/classic_blog/templates/syndication.mtml

## themes/classic_blog/templates/tag_cloud.mtml

## themes/classic_blog/templates/technorati_search.mtml

## themes/classic_blog/templates/trackbacks.mtml

## themes/classic_blog/templates/verify-subscribe.mtml

## themes/classic_blog/theme.yaml
	'Typical and authentic blogging design comes with plenty of styles and the selection of 2 column / 3 column layout. Best for all the bloggers.' => 'たくさんの2カラムや3カラムレイアウトをもつ一般的なブログ用デザインです。全ブログユーザーに最適です。',

## themes/classic_website/templates/about_this_page.mtml

## themes/classic_website/templates/banner_footer.mtml

## themes/classic_website/templates/blogs.mtml

## themes/classic_website/templates/comment_detail.mtml

## themes/classic_website/templates/comment_listing.mtml

## themes/classic_website/templates/comment_preview.mtml

## themes/classic_website/templates/comment_response.mtml

## themes/classic_website/templates/comment_throttle.mtml

## themes/classic_website/templates/commenter_confirm.mtml

## themes/classic_website/templates/commenter_notify.mtml

## themes/classic_website/templates/comments.mtml

## themes/classic_website/templates/creative_commons.mtml

## themes/classic_website/templates/dynamic_error.mtml

## themes/classic_website/templates/entry.mtml

## themes/classic_website/templates/entry_summary.mtml

## themes/classic_website/templates/footer-email.mtml

## themes/classic_website/templates/javascript.mtml

## themes/classic_website/templates/main_index.mtml

## themes/classic_website/templates/main_index_widgets_group.mtml

## themes/classic_website/templates/new-comment.mtml

## themes/classic_website/templates/new-ping.mtml

## themes/classic_website/templates/notify-entry.mtml

## themes/classic_website/templates/openid.mtml

## themes/classic_website/templates/page.mtml

## themes/classic_website/templates/pages_list.mtml

## themes/classic_website/templates/powered_by.mtml

## themes/classic_website/templates/recent_assets.mtml

## themes/classic_website/templates/recent_comments.mtml

## themes/classic_website/templates/recent_entries.mtml

## themes/classic_website/templates/recover-password.mtml

## themes/classic_website/templates/search.mtml

## themes/classic_website/templates/search_results.mtml

## themes/classic_website/templates/sidebar.mtml

## themes/classic_website/templates/signin.mtml

## themes/classic_website/templates/syndication.mtml
	'Subscribe to this website\'s feed' => 'ウェブサイトを購読',

## themes/classic_website/templates/tag_cloud.mtml

## themes/classic_website/templates/technorati_search.mtml

## themes/classic_website/templates/trackbacks.mtml

## themes/classic_website/templates/verify-subscribe.mtml

## themes/classic_website/theme.yaml
	'Create a blog portal that aggregates contents from blogs under the website.' => 'ウェブサイトに存在するブログのコンテンツを表示するブログポータルを作成します。',
	'Classic Website' => 'クラシックウェブサイト',

## themes/pico/templates/about_this_page.mtml

## themes/pico/templates/archive_index.mtml
	'Navigation' => 'ナビゲーション',
	'Related Content' => '関連コンテンツ',

## themes/pico/templates/archive_widgets_group.mtml

## themes/pico/templates/author_archive_list.mtml

## themes/pico/templates/banner_footer.mtml

## themes/pico/templates/calendar.mtml

## themes/pico/templates/category_archive_list.mtml

## themes/pico/templates/category_entry_listing.mtml

## themes/pico/templates/comment_detail.mtml

## themes/pico/templates/comment_listing.mtml

## themes/pico/templates/comment_preview.mtml
	'Preview Comment' => 'コメントの確認',

## themes/pico/templates/comment_response.mtml

## themes/pico/templates/comment_throttle.mtml

## themes/pico/templates/commenter_confirm.mtml

## themes/pico/templates/commenter_notify.mtml

## themes/pico/templates/comments.mtml

## themes/pico/templates/creative_commons.mtml

## themes/pico/templates/current_author_monthly_archive_list.mtml

## themes/pico/templates/current_category_monthly_archive_list.mtml

## themes/pico/templates/date_based_author_archives.mtml

## themes/pico/templates/date_based_category_archives.mtml

## themes/pico/templates/dynamic_error.mtml

## themes/pico/templates/entry.mtml
	'Home' => 'ホーム',

## themes/pico/templates/entry_summary.mtml

## themes/pico/templates/footer-email.mtml

## themes/pico/templates/javascript.mtml

## themes/pico/templates/main_index.mtml

## themes/pico/templates/main_index_widgets_group.mtml

## themes/pico/templates/monthly_archive_dropdown.mtml

## themes/pico/templates/monthly_archive_list.mtml

## themes/pico/templates/monthly_entry_listing.mtml

## themes/pico/templates/navigation.mtml
	'Subscribe' => '購読',

## themes/pico/templates/new-comment.mtml

## themes/pico/templates/new-ping.mtml

## themes/pico/templates/notify-entry.mtml

## themes/pico/templates/openid.mtml

## themes/pico/templates/page.mtml

## themes/pico/templates/pages_list.mtml

## themes/pico/templates/recent_assets.mtml

## themes/pico/templates/recent_comments.mtml

## themes/pico/templates/recent_entries.mtml

## themes/pico/templates/recover-password.mtml

## themes/pico/templates/search.mtml

## themes/pico/templates/search_results.mtml

## themes/pico/templates/signin.mtml

## themes/pico/templates/syndication.mtml

## themes/pico/templates/tag_cloud.mtml

## themes/pico/templates/technorati_search.mtml

## themes/pico/templates/trackbacks.mtml

## themes/pico/templates/verify-subscribe.mtml

## themes/pico/theme.yaml
	'Pico is the microblogging theme, designed for keeping things simple to handle frequent updates. To put the focus on content we\'ve moved the sidebars below the list of posts.' => 'Picoはマイクロブログを作成するのに適した、テキストや写真といったコンテンツを引き立てるシンプルなデザインのテーマです。アーカイブリストなどの関連コンテンツは、メインコンテンツの下に配置されます。',
	'Pico' => 'Pico',
	'Pico Styles' => 'Picoスタイル',
	'A collection of styles compatible with Pico themes.' => 'Picoテーマと互換のあるスタイルです。',

## search_templates/comments.tmpl
	'Search for new comments from:' => 'コメントを検索:',
	'the beginning' => '最初から',
	'one week back' => '一週間前',
	'two weeks back' => '2週間前',
	'one month back' => '1か月前',
	'two months back' => '2か月前',
	'three months back' => '3か月前',
	'four months back' => '4か月前',
	'five months back' => '5か月前',
	'six months back' => '6か月前',
	'one year back' => '1年前',
	'Find new comments' => '新しいコメントを検索',
	'Posted in [_1] on [_2]' => '[_2]の[_1]に投稿されたコメント',
	'No results found' => 'ありません',
	'No new comments were found in the specified interval.' => '指定された期間にコメントはありません。',
	'Select the time interval that you\'d like to search in, then click \'Find new comments\'' => '検索したい期間を選択して、コメントを検索をクリックしてください。',

## search_templates/default.tmpl
	'SEARCH FEED AUTODISCOVERY LINK PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => '検索結果のフィードのAuto Discoveryリンクは検索が実行されたときのみ表示されます。',
	'Blog Search Results' => 'Blog Searchの結果',
	'Blog search' => 'Blog Search',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => '通常の検索では検索クエリ用のフォームを返す',
	'Search this site' => 'このブログを検索',
	'Match case' => '大文字小文字を区別する',
	'SEARCH RESULTS DISPLAY' => '検索結果表示',
	'Matching entries from [_1]' => 'ブログ[_1]での検索結果',
	'Entries from [_1] tagged with \'[_2]\'' => 'ブログ[_1]の\'[_2]\'タグのブログ記事',
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => '<MTIfNonEmpty tag="EntryAuthorDisplayName">[_1]</MTIfNonEmpty> - ([_2])',
	'Showing the first [_1] results.' => '最初の[_1]件の結果を表示',
	'NO RESULTS FOUND MESSAGE' => '検索結果がないときのメッセージ',
	'Entries matching \'[_1]\'' => '\'[_1]\'で検索されたブログ記事',
	'Entries tagged with \'[_1]\'' => '\'[_1]\'タグのブログ記事',
	'No pages were found containing \'[_1]\'.' => '\'[_1]\'が含まれるページはありません。',
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes' => '初期設定では、検索エンジンはすべての言葉が含まれるページを検索します。特定のフレーズを検索するには、引用符で囲んでください。',
	'The search engine also supports AND, OR, and NOT keywords to specify boolean expressions' => '検索条件をAND、OR、NOTで指定することもできます。',
	'END OF ALPHA SEARCH RESULTS DIV' => '検索結果のDIV(ALPHA)ここまで',
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'ここから検索情報を表示するBETA SIDEBAR',
	'SET VARIABLES FOR SEARCH vs TAG information' => '検索またはタグ情報を変数に代入',
	'If you use an RSS reader, you can subscribe to a feed of all future entries tagged \'[_1]\'.' => 'RSSリーダーを使うと、\'[_1]\'タグのすべてのブログ記事のフィードを購読することができます。',
	'If you use an RSS reader, you can subscribe to a feed of all future entries matching \'[_1]\'.' => 'RSSリーダーを使うと、\'[_1]\'を含むすべてのブログ記事のフィードを購読することができます。',
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => '検索/タグのフィード購読情報',
	'Feed Subscription' => '購読',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.jp/about/feeds',
	'What is this?' => 'フィードとは',
	'TAG LISTING FOR TAG SEARCH ONLY' => 'タグ一覧はタグ検索でのみ表示',
	'Other Tags' => 'その他のタグ',
	'END OF PAGE BODY' => 'ページ本体ここまで',
	'END OF CONTAINER' => 'コンテナここまで',

## search_templates/results_feed.tmpl
	'Search Results for [_1]' => '[_1]の検索結果',

## search_templates/results_feed_rss2.tmpl

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => '新規アイテムのアップロード',

## tmpl/cms/asset_upload.tmpl
	'Upload Asset' => 'アイテムのアップロード',

## tmpl/cms/backup.tmpl
	'Backup [_1]' => '[_1]のバックアップ',
	'What to Backup' => 'バックアップ対象',
	'This option will backup Users, Roles, Associations, Blogs, Entries, Categories, Templates and Tags.' => 'このオプションでユーザー、ロール、アソシエーション、ブログ、ブログ記事、カテゴリ、テンプレート、タグをバックアップできます。',
	'Everything' => 'すべて',
	'Reset' => 'リセット',
	'Choose websites...' => 'ウェブサイトを選択...',
	'Archive Format' => '圧縮フォーマット',
	'The type of archive format to use.' => '使用するフォーマットの種類を選択します。',
	'Don\'t compress' => '圧縮しない',
	'Target File Size' => '出力ファイルのサイズ',
	'Approximate file size per backup file.' => '1つ1つのバックアップファイルのおおよその最大サイズを指定します。',
	'No size limit' => '分割しない',
	'Make Backup (b)' => 'バックアップを作成 (b)',
	'Make Backup' => 'バックアップを作成',

## tmpl/cms/cfg_entry.tmpl
	'Compose Settings' => '投稿設定',
	'Your preferences have been saved.' => '設定を保存しました。',
	'Publishing Defaults' => '公開の既定値',
	'Listing Default' => '表示される記事数',
	'Select the number of days of entries or the exact number of entries you would like displayed on your blog.' => '指定した日数分のブログ記事またはブログ記事数を表示します。',
	'Days' => '日分',
	'Posts' => '投稿',
	'Order' => '順番',
	'Select whether you want your entries displayed in ascending (oldest at top) or descending (newest at top) order.' => 'ブログ記事の表示順を昇順 (古いものを一番上にして時系列に並べる) か、降順 (最新のブログ記事が常に上に来るように逆順で並べるか) か選んでください。',
	'Ascending' => '昇順',
	'Descending' => '降順',
	'Excerpt Length' => '概要の文字数',
	'Enter the number of words that should appear in an auto-generated excerpt.' => '自動生成される概要の文字数を入力してください。',
	'Date Language' => '日付の言語',
	'Select the language in which you would like dates on your blog displayed.' => 'ブログに表示する日付の言語を選んでください。',
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
	'Basename Length' => 'ファイル名の文字数',
	'Specifies the default length of an auto-generated basename. The range for this setting is 15 to 250.' => '自動作成される出力ファイル名のデフォルトの文字数を決めます。15文字から250文字の範囲で設定してください。',
	'Compose Defaults' => '作成の既定値',
	'Specifies the default Post Status when creating a new entry.' => '新規ブログ記事を作成時の公開状態の規定値を指定します。',
	'Unpublished' => '下書き',
	'Published' => '公開',
	'Text Formatting' => 'テキストフォーマット',
	'Specifies the default Text Formatting option when creating a new entry.' => 'テキストフォーマットの既定値を指定します。',
	'Specifies the default Accept Comments setting when creating a new entry.' => '既定でコメントを許可する',
	'Setting Ignored' => '設定は無視されます',
	'Note: This option is currently ignored since comments are disabled either blog or system-wide.' => '注: ブログまたはシステム全体でコメントが無効なためこのオプションは無視されます。',
	'Accept TrackBacks' => 'トラックバック許可',
	'Specifies the default Accept TrackBacks setting when creating a new entry.' => '既定でトラックバックを許可する',
	'Note: This option is currently ignored since TrackBacks are disabled either blog or system-wide.' => '注: ブログまたはシステム全体の設定でトラックバックが無効なためこのオプションは無視されます。',
	'Entry Fields' => '記事フィールド',
	'_USAGE_ENTRYPREFS' => 'ブログ記事の編集画面で表示する項目のセットを選択してください。',
	'Page Fields' => 'ページフィールド',
	'Punctuation Replacement' => '句読点置き換え',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'ワープロソフトで使われるUTF-8文字を対応する表示可能な文字に置き換えます。',
	'No substitution' => '置き換えない',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'エンティティ (&amp#8221;、&amp#8220;など)',
	'ASCII equivalents (&quot;, \', ..., -, --)' => '対応するASCII文字 (&quot;、\'、...、-、--)',
	'Replace Fields' => '置き換えるフィールド',
	'Save changes to these settings (s)' => '設定を保存 (s)',
	'Save Changes' => '変更を保存',

## tmpl/cms/cfg_feedback.tmpl
	'Feedback Settings' => 'コミュニケーション設定',
	'Spam Settings' => 'スパム設定',
	'Automatic Deletion' => '自動削除設定',
	'Automatically delete spam feedback after the time period shown below.' => 'スパムと判断したものを指定の日数経過後に削除する',
	'Delete Spam After' => 'スパムを削除する',
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'スパムと判断したものを、指定した日数の後に削除します。',
	'days' => '日数',
	'Spam Score Threshold' => 'スパム判断基準',
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => '受信したコメントとトラックバックは、-10 (迷惑度: 最大)から +10 (迷惑度: ゼロ)までの範囲で評価されます。指定した判断基準より低い値のコメントとトラックバックはスパムと見なされます。',
	'Less Aggressive' => 'より緩やかに',
	'Decrease' => '減らす',
	'Increase' => '増やす',
	'More Aggressive' => 'より厳しく',
	'Apply \'nofollow\' to URLs' => 'URLのnofollow指定',
	'If enabled, all URLs in comments and TrackBacks will be assigned a \'nofollow\' link relation.' => 'コメントとトラックバックに含まれるすべてのURLにnofollowを設定する',
	'\'nofollow\' exception for trusted commenters' => 'nofollow除外',
	'Do not add the \'nofollow\' attribute when a comment is submitted by a trusted commenter.' => '承認されたコメント投稿者のコメントにはnofollowを適用しない',
	'Comment Settings' => 'コメント設定',
	'Note: Commenting is currently disabled at the system level.' => '注: コメントは現在システムレベルで無効になっています。',
	'Comment authentication is not available because at least one of the required Perl modules, MIME::Base64 and LWP::UserAgent, are not installed. Install the missing modules and reload this page to configure comment authentication.' => '必要なPerlモジュール(MIME::Base64とLWP::UserAgent)がインストールされていないため、コメント認証は無効となっています。必要なモジュールをインストールしてから、このページで再設定してください。',
	'Accept comments according to the policies shown below.' => 'コメントポリシーを設定し、コメントを受け付ける',
	'Setup Registration' => '登録／認証の設定',
	'Commenting Policy' => 'コメントポリシー',
	'Immediately approve comments from' => '即時公開する条件',
	'Specify what should happen to comments after submission. Unapproved comments are held for moderation.' => '受け付けたコメントを公開する条件を選んでください。未公開のコメントは認証待ちのものです。',
	'No one' => '自動的に公開しない',
	'Trusted commenters only' => 'ブログで承認されたコメント投稿者のみ',
	'Any authenticated commenters' => '認証サービスで認証されたコメント投稿者のみ',
	'Anyone' => 'すべて自動的に公開する',
	'Allow HTML' => 'HTMLを許可',
	'Allow commenters to include a limited set of HTML tags in their comments. Otherwise all HTML will be stripped out.' => 'コメントの内容に特定のHTMLタグの利用を許可する (許可しない場合は、すべてのHTMLタグが利用できなくなります)',
	'Limit HTML Tags' => 'HTMLタグを制限',
	'Specify the list of HTML tags to allow when accepting a comment.' => 'コメント内で利用できるHTMLタグを指定する。',
	'Use defaults' => '標準の設定',
	'([_1])' => '([_1])',
	'Use my settings' => 'カスタム設定',
	'E-mail Notification' => 'メール通知',
	'Specify when Movable Type should notify you of new comments.' => '新しいコメントの通知を指定します。',
	'On' => '有効にする',
	'Only when attention is required' => '注意が必要な場合のみ',
	'Off' => '行わない',
	'Comment Display Settings' => 'コメント表示設定',
	'Comment Order' => 'コメントの表示順',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'コメントを昇順に表示するか、降順に表示するか選びます。',
	'Auto-Link URLs' => 'URLを自動的にリンク',
	'Transform URLs in comment text into HTML links.' => '受信したコメント内にURLが含まれる場合に自動的にリンクする',
	'Specifies the Text Formatting option to use for formatting visitor comments.' => 'コメント本文の改行の変換に関する初期値を指定します。',
	'CAPTCHA Provider' => 'CAPTCHAプロバイダ',
	'none' => 'なし',
	'No CAPTCHA provider available' => 'CAPTCHAプロバイダがありません',
	'No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the \'mt-static/images\' directory.' => 'CAPTCHAプロバイダがありません。Image:：Magickがインストールされているか、またCaptchaSourceImageBaseが正しく設定されていてmt-static/images/captcha-sourceにアクセスできるか確認してください。',
	'Use Comment Confirmation Page' => 'コメントの確認ページ',
	'Use comment confirmation page' => 'コメントの確認ページを有効にする',
	'Each commenter\'s browser will be redirected to a comment confirmation page after their comment is accepted.' => 'コメント投稿後に、コメント完了ページを表示する',
	'Trackback Settings' => 'トラックバック設定',
	'Note: TrackBacks are currently disabled at the system level.' => '注: トラックバックは現在システムレベルで無効になっています。',
	'Accept TrackBacks from any source.' => '全てのトラックバックを許可する',
	'TrackBack Policy' => 'トラックバックポリシー',
	'Moderation' => '事前確認',
	'Hold all TrackBacks for approval before they are published.' => '公開前に許可を必要とするように、トラックバックを保留する',
	'Specify when Movable Type should notify you of new TrackBacks.' => '新しいトラックバックの通知を指定します。',
	'TrackBack Options' => 'トラックバックオプション',
	'TrackBack Auto-Discovery' => '自動検知',
	'When auto-discovery is turned on, any external HTML links in new entries will be extracted and the appropriate sites will automatically be sent a TrackBack ping.' => '自動検出を有効にすると、新しいブログ記事を書いたときに、外部へのリンクが抽出されて、自動的にトラックバックを送信します。',
	'Enable External TrackBack Auto-Discovery' => '外部リンクに対するトラックバック自動検知を有効にする',
	'Setting Notice' => '注:',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => '備考: システムレベルのみの外部pingオプションは有効になっているようです。',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => '備考: システムレベで無効になっている外部pingオプションは現在無効となっています。',
	'Enable Internal TrackBack Auto-Discovery' => '内部リンクに対するトラックバック自動検知を有効にする',

## tmpl/cms/cfg_plugin.tmpl
	'[_1] Plugin Settings' => '[_1]のプラグイン設定',
	'Useful links' => 'ショートカット',
	'http://plugins.movabletype.org/' => 'http://www.movabletype.jp/plugins/',
	'Find Plugins' => 'プラグインを探す',
	'Plugin System' => 'プラグインシステム',
	'Enable or disable plugin functionality for the entire Movable Type installation.' => 'プラグインの利用をシステムレベルで設定します。',
	'Disable plugin functionality' => 'プラグインの機能を無効化する',
	'Disable Plugins' => 'プラグインを利用しない',
	'Enable plugin functionality' => 'プラグインの機能を有効化する',
	'Enable Plugins' => 'プラグインを利用する',
	'Your plugin settings have been saved.' => 'プラグインの設定を保存しました。',
	'Your plugin settings have been reset.' => 'プラグインの設定をリセットしました。',
	'Your plugins have been reconfigured. Since you\'re running mod_perl, you must restart your web server for these changes to take effect.' => 'プラグインの設定が変更されました。mod_perlを利用している場合は、設定変更を有効にするためにウェブサーバーを再起動する必要があります。',
	'Your plugins have been reconfigured.' => 'プラグインを再設定しました。',
	'Your plugins have been reconfigured. Since you\'re running mod_perl, you will need to restart your web server for these changes to take effect.' => 'プラグインを再設定しました。mod_perl環境下でお使いの場合は、設定を反映させるためにウェブサーバーを再起動してください。',
	'Are you sure you want to reset the settings for this plugin?' => 'このプラグインの設定を元に戻しますか?',
	'Are you sure you want to disable plugins for the entire Movable Type installation?' => 'システム全体で、プラグインを無効にしますか?',
	'Are you sure you want to disable this plugin?' => 'プラグインを無効にしますか?',
	'Are you sure you want to enable plugins for the entire Movable Type installation? (This will restore plugin settings that were in place before all plugins were disabled.)' => 'システム全体で、プラグインを有効にしますか? (各プラグインの設定は、システム全体で無効化される前の状態に戻ります)',
	'Are you sure you want to enable this plugin?' => 'プラグインを有効にしますか?',
	'Settings for [_1]' => '[_1]の設定',
	'Failed to Load' => '読み込みに失敗しました',
	'Disable' => '無効',
	'Enabled' => '利用可能',
	'Disabled' => '利用不可',
	'Enable' => '有効',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.' => 'このプラグインは、 Mvable Type [_1]向けにアップグレードされていません。そのため、動作しない場合があります。',
	'Plugin error:' => 'プラグインエラー:',
	'Info' => '詳細',
	'Resources' => 'リソース',
	'Run [_1]' => '[_1]を起動',
	'Documentation for [_1]' => '[_1]のドキュメント',
	'Documentation' => 'ドキュメント',
	'More about [_1]' => '[_1]の詳細情報',
	'Plugin Home' => 'プラグインホーム',
	'Author of [_1]' => '作成者',
	'Tag Attributes:' => 'タグの属性: ',
	'Text Filters' => 'テキストフィルタ',
	'Junk Filters:' => 'ジャンクフィルタ',
	'Reset to Defaults' => '初期化',
	'No plugins with blog-level configuration settings are installed.' => 'ブログ別に設定するプラグインはインストールされていません。',
	'No plugins with configuration settings are installed.' => '設定可能なプラグインがインストールされていません。',

## tmpl/cms/cfg_prefs.tmpl
	'Error: Movable Type was not able to create a directory for publishing your [_1]. If you create this directory yourself, grant write permission to the web server.' => 'エラー: [_1]公開用のディレクトリを作成できません。自分でディレクトリが作成できる場合は、ウェブサーバーに書きこみ権限を与えてください。',
	'[_1] Settings' => '[_1]設定',
	'Name your blog. The name can be changed at any time.' => 'ブログ名。ブログ名はいつでも変更できます。',
	'Enter a description for your blog.' => 'ブログの説明を入力してください。',
	'Time Zone' => 'タイムゾーン',
	'Select your time zone from the pulldown menu.' => 'プルダウンメニューからタイムゾーンを選択してください。',
	'Time zone not selected' => 'タイムゾーンが選択されていません。',
	'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13(トンガ)',
	'UTC+12 (International Date Line East)' => 'UTC+12(ニュージーランド標準時)',
	'UTC+11' => 'UTC+11(ニューカレドニア',
	'UTC+10 (East Australian Time)' => 'UTC+10(オーストラリア東部標準時)',
	'UTC+9.5 (Central Australian Time)' => 'UTC+9.5(中央オーストラリア標準時)',
	'UTC+9 (Japan Time)' => 'UTC+9(日本標準時)',
	'UTC+8 (China Coast Time)' => 'UTC+8(中国標準時)',
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
	'License' => 'ライセンス',
	'Your blog is currently licensed under:' => 'このブログは、次のライセンスで保護されています:',
	'Change license' => 'ライセンスの変更',
	'Remove license' => 'ライセンスの削除',
	'Your blog does not have an explicit Creative Commons license.' => 'クリエイティブ・コモンズライセンスを指定していません。',
	'Select a license' => 'ライセンスの選択',
	'Publishing Paths' => '公開パス',
	'[_1] URL' => '[_1]URL',
	'Use subdomain' => 'サブドメインの利用',
	'Warning: Changing the site URL can result in breaking all the links in your blog.' => '警告: サイトURLを変更するとブログ内の全てのリンクがリンク切れとなることがあります。',
	'The URL of your blog. Exclude the filename (i.e. index.html). End with \'/\'. Example: http://www.example.com/blog/' => 'ブログを公開するURLです。ファイル名(index.htmlなど)は含めず、末尾は\'/\'で終わります。例: http://www.example.com/blog/',
	'The URL of your website. Exclude the filename (i.e. index.html).  End with \'/\'. Example: http://www.example.com/' => 'ウェブサイトを公開するURLです。ファイル名(index.htmlなど)は含めず、末尾は\'/\'で終わります。 例: http://www.example.com/',
	'[_1] Root' => '[_1]パス',
	'Note: Changing your site root requires a complete publish of your site.' => '注: サイトパスを変更した場合にはブログの再構築が必要です。',
	'The path where your index files will be published. Do not end with \'/\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog' => 'インデックスファイルを配置するパスです。末尾には\'/\'を含めません。例: /home/mt/public_html/blog あるいは C:\www\public_html\blog',
	'The path where your index files will be published. An absolute path (starting with \'/\' for Linux or \'C:\\\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/mt/public_html or C:\www\public_html' => 'インデックスファイルを配置するパスです。絶対パス(\'/\'または\'C:\\\'で始まる)を推奨しますが、Movable Typeディレクトリからの相対パスも指定できます。例: /home/mt/public_html あるいは C:\www\public_html',
	'Advanced Archive Publishing' => '高度な公開の設定',
	'Select this option only if you need to publish your archives outside of your Blog Root.' => 'アーカイブをサイトパス以外で公開するときにこのオプションを選択してください。',
	'Publish archives outside of Blog Root' => 'アーカイブをブログパスとは別のパスで公開する',
	'Archive URL' => 'アーカイブURL',
	'Enter the URL of the archives section of your blog. Example: http://www.example.com/blog/archives/' => 'ブログのアーカイブのURLです。例: http://www.example.com/blog/archives2/',
	'Warning: Changing the archive URL can result in breaking all the links in your blog.' => '警告: アーカイブURLを変更することでブログ上のすべてのリンクがリンク切れとなる場合があります。',
	'Enter the path where your archive files will be published. Example: /home/mt/public_html/blog/archives or C:\www\public_html\blog\archives' => 'アーカイブファイルを配置するパスを入力してください。例: /home/mt/public_html/blog/archives2 あるいは C:\www\public_html\blog\archives2',
	'Warning: Changing the archive path can result in breaking all the links in your blog.' => '警告: アーカイブパスを変更するとブログ上のすべてのリンクがリンク切れとなる場合があります。',
	'Asynchronous Job Queue' => '非同期ジョブキュー',
	'Use Publishing Queue' => '公開キュー',
	'Requires the use of a cron job or a scheduled task on your server to publish pages in the background.' => 'バックグランドでページの構築をするには、サーバーでcronジョブかスケジュールタスクが使える必要があります。',
	'Use background publishing queue for publishing static pages for this blog' => 'バックグラウンドのキューを使って再構築を行う',
	'Dynamic Publishing Options' => 'ダイナミックパブリッシング設定',
	'Enable dynamic cache' => 'キャッシュする',
	'Enable conditional retrieval' => '条件付き取得を有効にする',
	'Archive Settings' => 'アーカイブ設定',
	'File Extension' => 'ファイルの拡張子',
	'Enter the archive file extension. This can take the form of \'html\', \'shtml\', \'php\', etc. Note: Do not enter the leading period (\'.\').' => 'アーカイブファイルの拡張子を指定してください。html、shtml、phpなどを指定できます。ピリオドは入力しないでください。',
	'Preferred Archive' => '優先アーカイブタイプ',
	'Used to generate URLs (permalinks) for this blog\'s archived entries. Choose one of the archive type used in this blog\'s archive templates.' => 'ブログ記事にリンクするときのURLとして使われます。このブログで使われているアーカイブテンプレートの中から選択してください。',
	'No archives are active' => '有効なアーカイブがありません。',
	'Module Settings' => 'モジュール設定',
	'Server Side Includes' => 'サーバーサイドインクルード',
	'None (disabled)' => '無効',
	'PHP Includes' => 'PHPのインクルード',
	'Apache Server-Side Includes' => 'ApacheのSSI',
	'Active Server Page Includes' => 'ASPのインクルード',
	'Java Server Page Includes' => 'JSPのインクルード',
	'Module Caching' => 'モジュールのキャッシュ',
	'Allow properly configured template modules to be cached to enhance publishing performance.' => '再構築の速度向上のために、テンプレートモジュール毎のキャッシュ設定を有効にする',
	'Note: Revision History is currently disabled at the system level.' => '備考: 更新履歴は現在システムレベルで無効となっています。',
	'Revision history' => '更新履歴',
	'Enable revision history' => '更新履歴を有効にする',
	'Number of revisions per entry/page' => '記事/ページ更新履歴数:',
	'Number of revisions per page' => 'ページ更新履歴数:',
	'Number of revisions per template' => 'テンプレート更新履歴数:',
	'You must set your Blog Name.' => 'ブログ名を設定してください。',
	'You did not select a time zone.' => 'タイムゾーンが選択されていません。',
	'You must set a valid Site URL.' => '有効なサイトURLを指定してください。',
	'You must set your Local Site Path.' => 'サイトパスを指定する必要があります。',
	'You must set a valid Local Site Path.' => '有効なサイトパスを指定してください。',
	'You must set a valid Archive URL.' => '有効なアーカイブURLを指定してください。',
	'You must set Local Archive Path.' => 'アーカイブパスを指定する必要があります。',
	'You must set a valid Local Archive Path.' => '有効なアーカイブパスを指定してください。',

## tmpl/cms/cfg_registration.tmpl
	'Registration Settings' => '登録/認証の設定',
	'Your blog preferences have been saved.' => 'ブログの設定を保存しました。',
	'User Registration' => 'ユーザー登録',
	'Allow registration for this website.' => 'ウェブサイトへの登録を許可します。',
	'Registration Not Enabled' => 'ユーザー登録は無効です。',
	'Note: Registration is currently disabled at the system level.' => '注:ユーザー登録は現在システムレベルで無効となっています。',
	'Allow visitors to register as members of this website using one of the Authentication Methods selected below.' => 'ウェブサイトの訪問者が、以下で選択した認証方式でユーザー登録することを許可する',
	'Authentication Methods' => '認証方式',
	'Note: You have selected to accept comments from authenticated commenters only but authentication is not enabled. In order to receive authenticated comments, you must enable authentication.' => '注: 認証されたコメント投稿者からのコメントだけを許可する設定になっていますが、コメント認証が有効になっていません。',
	'Require E-mail Address for Comments via TypePad' => 'TypePad経由のコメントにメールアドレスを要求する',
	'Visitors must allow their TypePad account to share their e-mail address when commenting.' => 'ビジターはコメント時にメールアドレスを共有するのにTypePadアカウントが許可されています。',
	'One or more Perl modules may be missing to use this authentication method.' => '認証を利用するのに必要なPerlモジュールが見つかりませんでした。',
	'Setup TypePad authentication' => 'TypePad認証設定',
	'on the Web Services Settings page.' => 'Webサービス設定ページ',
	'OpenID providers disabled' => 'OpenIDプロバイダは無効です',
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'OpenIDを利用するのに必要なPerlモジュール(Digest::SHA1)がありません。',

## tmpl/cms/cfg_system_general.tmpl
	'A test email was sent.' => 'テストメールが送信されました。',
	'Your settings have been saved.' => '設定を保存しました。',
	'System Email' => 'システムのメールアドレス',
	'This email address is used in the \'From:\' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, and a few other minor events.' => 'このメールアドレスはMovable Typeから送られるメールの\'From:\'アドレスに利用されます。メールはパスワードの再設定、コメント投稿者の登録、コメントやトラックバックの通知、その他の場合に送信されます。',
	'Send Test Email' => 'テストメールを送信',
	'Debug Mode' => 'デバッグモード',
	'Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">Debug Mode documentation</a>.' => '開発者向けの設定です。0以外の数字を設定すると、Movable Typeのデバックメッセージを表示します。詳しくは<a href="http://www.movabletype.jp/documentation/appendices/config-directives/debugmode.html">ドキュメントを参照</a>してください。',
	'Performance Logging' => 'パフォーマンスログ',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified by Logging Threshold.' => 'パフォーマンスログを有効にして、ログ閾値で設定した秒数より時間のかかる処理をログに記録します。',
	'Log Path' => 'ログパス',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'パフォーマンスログを書き出すフォルダです。ウェブサーバーから書き込み可能な場所を指定してください。',
	'Logging Threshold' => 'ログ閾値',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => '指定した秒数以上、時間がかかった処理をログに記録します。',
	'Enable this setting to have Movable Type track revisions made by users to entries, pages and templates.' => 'この設定を有効にすると、記事、ページ、テンプレートの変更履歴を保存します。',
	'Track revision history' => '変更履歴を保存する',
	'System-wide Feedback Controls' => 'システムレベルフィードバック制御',
	'Prohibit Comments' => 'コメント',
	'This will override all individual blog settings.' => 'ここでの設定は、ブログでの設定より優先されます。',
	'Disable comments for all blogs.' => 'コメントを無効にする',
	'Prohibit TrackBacks' => 'トラックバック',
	'Disable receipt of TrackBacks for all blogs.' => 'トラックバックを無効にする',
	'Outbound Notifications' => '更新通知',
	'Prohibit Notification Pings' => 'Ping通知禁止',
	'Disable sending notification pings when a new entry is created in any blog on the system.' => 'ブログに新しい記事が作成された時に、ping通知を送るのを無効にします。',
	'Disable notification pings for all blogs.' => '全ブログでping通知を無効にする',
	'Send Outbound TrackBacks to' => '外部トラックバック送信',
	'Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.' => 'プライベートに設定する場合は、トラックバックを送信したりトラックバックの自動発見機能は利用しないようにしましょう。',
	'Any site' => '任意のサイト',
	'(No Outbound TrackBacks)' => '(すべてのトラックバック送信を無効にする)',
	'Only to blogs within this system' => 'ブログのみ',
	'Only to websites on the following domains:' => '次のドメインに属するウェブサイト:',
	'Send Email To' => 'メール送信先',
	'The email address that should receive a test email from Movable Type.' => 'テストメールを受け取るメールアドレス',

## tmpl/cms/cfg_system_users.tmpl
	'User Settings' => 'ユーザー設定',
	'(No website selected)' => '(ウェブサイトが選択されていません)',
	'Select website' => 'ウェブサイト選択',
	'(None selected)' => '(選択されていません)',
	'Allow Registration' => '登録',
	'Select a system administrator you wish to notify when commenters successfully registered themselves.' => 'コメント投稿者が登録したことを知らせたいシステム管理者を選択してください。',
	'Allow commenters to register with blogs on this system.' => 'コメント投稿者がMovable Typeに登録することを許可する',
	'Notify the following system administrators when a commenter registers:' => '以下のシステム管理者に登録を通知する:',
	'Select system administrators' => 'システム管理者選択',
	'Clear' => 'クリア',
	'Note: System Email Address is not set in System > General Settings. Emails will not be sent.' => 'システムのメールアドレスが設定されていないため、メールは送信されません。「設定 &gt; 全般」から設定してください。',
	'New User Defaults' => '新しいユーザーの初期設定',
	'Personal Blog' => '個人用ブログ',
	'Have the system automatically create a new personal blog when a user is created. The user will be granted the blog administrator role on this blog.' => '新しいユーザーの個人用ブログを自動作成する。同時に個人用ブログへの管理者権限を設定します。',
	'Automatically create a new blog for each new user.' => '新しいユーザー用のブログを自動作成する',
	'Personal Blog Location' => '個人用ブログの場所',
	'Select a website you wish to use as the location of new personal blogs.' => '新しい個人用ブログの場所に使うウェブサイトを選択します。',
	'Change website' => 'ウェブサイト変更',
	'Personal Blog Theme' => '個人用ブログテーマ',
	'Select the theme that should be used for new personal blogs.' => '個人用ブログで利用するテーマを選択する。',
	'(No theme selected)' => '(テーマが選択されていません)',
	'Change theme' => 'テーマ変更',
	'Select theme' => 'テーマ選択',
	'Default User Language' => 'ユーザーの既定の言語',
	'Choose the default language to apply to all new users.' => 'ユーザーの利用言語を選択する。',
	'Default Time Zone' => '既定のタイムゾーン',
	'Default Tag Delimiter' => '既定のタグ区切り',
	'Define the default delimiter for entering tags.' => 'タグを入力するときの区切り文字の既定値を設定します。',
	'Comma' => 'カンマ',
	'Space' => 'スペース',

## tmpl/cms/cfg_web_services.tmpl
	'Web Services Settings' => 'Webサービス設定',
	'Web Services from Six Apart' => 'シックス・アパート提供Webサービス',
	'Your TypePad token is used to access services from Six Apart like TypePad Connect and TypePad AntiSpam.' => 'TypePadのトークンは、TypePad ConnectやTypePad AntiSpamなどのシックス・アパートが提供するサービスにアクセスするために利用されます。',
	'TypePad is enabled.' => 'TypePadは有効です。',
	'TypePad token:' => 'TypePadのトークン:',
	'Clear TypePad Token' => 'TypePadのトークンを削除',
	'Please click the Save Changes button below to disable authentication.' => '保存ボタンをクリックして認証を無効にしてください。',
	'TypePad is not enabled.' => 'TypePadは有効ではありません。',
	'&nbsp;or&nbsp;[_1]obtain a TypePad token[_2] from TypePad.com.' => '&nbsp;TypePad.comで[_1]TypePadトークンを取得[_2]',
	'Please click the \'Save Changes\' button below to enable TypePad.' => 'TypePadを利用するために\'保存\'ボタンをクリックしてください。',
	'External Notifications' => '更新通知',
	'Notify ping services of website updates' => 'ウェブサイト更新pingサービス通知',
	'When this website is updated, Movable Type will automatically notify the selected sites.' => 'ウェブサイトを更すると、選択したサイトに自動通知します。',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => '備考: システム外部ping通知がシステムレベルで無効のため、このオプションは現在無効となっています。',
	'Others:' => 'その他:',
	'(Separate URLs with a carriage return.)' => '(URLは改行で区切ってください)',
	'Recently Updated Key' => 'Recently Updated Key',
	'If you received a Recently Updated Key with the purchase of a Movable Type license, enter it here.' => 'Recently Updated Key をお持ちの場合は入力してください。',

## tmpl/cms/dashboard.tmpl
	'Dashboard' => 'ダッシュボード',
	'System Overview' => 'システム',
	'Hi, [_1]' => 'こんにちは、[_1]さん',
	'Select a Widget...' => 'ウィジェットの選択...',
	'Add' => '追加',
	'Your Dashboard has been updated.' => 'ダッシュボードを更新しました。',
	'Support directory is not writable.' => 'supportディレクトリに書き込めません。',
	'Detail' => '詳細',
	'Movable Type was unable to write to its \'support\' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.' => 'supportディレクトリに書き込みできません。[_1]にディレクトリを作成して、ウェブサーバーから書き込みできるパーミッションを与えてください。',
	'Image::Magick is not configured.' => 'Image::Magickが設定されていません。',
	'Image::Magick is either not present on your server or incorrectly configured. Due to that, you will not be able to use Movable Type\'s userpics feature. If you wish to use that feature, please install Image::Magick or use an alternative image driver.' => 'Image::Magickがインストールされていないかまたは正しく設定されていないため、Movable Typeのユーザー画像機能を利用できません。この機能を利用するには、Image::Magickをインストールするか、他のイメージドライバを使用する設定を行う必要があります。',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Confirm Publishing Configuration' => '公開設定',
	'Site Path' => 'サイトパス',
	'Parent Website' => '上位ウェブサイト',
	'Please choose parent website.' => '上位ウェブサイトを選択してください。',
	'Archive Path' => 'アーカイブパス',
	'Continue' => '次へ',
	'Continue (s)' => '次へ (s)',
	'Back' => '戻る',
	'Back (b)' => '戻る (b)',
	'You must select a parent website.' => '上位ウェブサイトを選択してください。',

## tmpl/cms/dialog/asset_insert.tmpl
	'Close (x)' => '閉じる (x)',

## tmpl/cms/dialog/asset_list.tmpl
	'Insert Image' => '画像の挿入',
	'Insert Asset' => 'アイテムの挿入',
	'Upload New File' => '新規ファイルのアップロード',
	'Upload New Image' => '新しい画像をアップロード',
	'Asset Name' => 'アイテム名',
	'Size' => 'サイズ',
	'Pending' => '保留中',
	'Next (s)' => '次へ (s)',
	'Insert (s)' => '挿入 (s)',
	'Insert' => '挿入',
	'Cancel (x)' => 'キャンセル (x)',
	'No assets could be found.' => 'アイテムが見つかりません。',

## tmpl/cms/dialog/asset_options.tmpl
	'File Options' => 'ファイルオプション',
	'Create entry using this uploaded file' => 'アップロードしたファイルを使ってブログ記事を作成する',
	'Create a new entry using this uploaded file.' => 'アップロードしたファイルを使ってブログ記事を作成する',
	'Finish (s)' => '完了 (s)',
	'Finish' => '完了',

## tmpl/cms/dialog/asset_options_image.tmpl
	'Display image in entry/page' => '画像を記事/ページに表示',
	'Alignment' => '位置',
	'Left' => '左',
	'Center' => '中央',
	'Right' => '右',
	'Use thumbnail' => 'サムネイルを利用',
	'width:' => '幅:',
	'pixels' => 'ピクセル',
	'Link image to full-size version in a popup window.' => 'ポップアップウィンドウで元の大きさの画像にリンクします。',
	'Remember these settings' => '設定を記憶',

## tmpl/cms/dialog/asset_replace.tmpl

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'ブログを設定する必要があります。',
	'Your blog has not been published.' => 'ブログが公開されていません。',

## tmpl/cms/dialog/clone_blog.tmpl
	'Verify Clone Blog Settings' => '複製したブログ設定の確認',
	'Blog Details' => 'ブログの詳細',
	'This is set to the same URL as the original blog.' => '複製元のブログと同じURLを設定します。',
	'Blog Root' => 'ブログパス',
	'This will overwrite the original blog.' => '複製元のブログ設定を上書きします。',
	'Exclusions' => '除外',
	'Exclude Entries/Pages' => '記事/ページの除外',
	'Exclude Comments' => 'コメントの除外',
	'Exclude Trackbacks' => 'トラックバックの除外',
	'Exclude Categories/Folders' => 'カテゴリ/フォルダの除外',
	'Clone' => '複製',
	'Clone Blog Settings' => 'ブログの複製設定',
	'Enter the new URL of your public website. Example: http://www.example.com/weblog/' => '公開ウェブサイトの新しいURLを入力してください。例: http://www.example.com/weblog/',
	'Enter a new path where your main index file will be located. Example: /home/melody/public_html/weblog' => 'インデックスファイルを配置する新しいパスを入力してください。例: /home/melody/public_html/weblog',
	'Mark the settings that you want cloning to skip' => '複製を行わない設定にマークをつけてください',
	'Entries/Pages' => '記事/ページ',
	'Categories/Folders' => 'カテゴリ/フォルダ',
	'Confirm' => '確認',

## tmpl/cms/dialog/comment_reply.tmpl
	'Reply to comment' => 'コメントに返信',
	'On [_1], [_2] commented on [_3]' => '[_2]から[_3]へのコメント([_1])',
	'Preview of your comment' => 'コメントのプレビュー',
	'Your reply:' => '返信',
	'Submit reply (s)' => '返信を投稿 (s)',
	'Preview reply (v)' => '返信をプレビュー (v)',
	'Re-edit reply (r)' => '返信を再編集 (r)',
	'Re-edit' => '再編集',

## tmpl/cms/dialog/create_association.tmpl
	'No roles exist in this installation. [_1]Create a role</a>' => 'ロールがありません。[_1]ロールを作成する</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'グループがありません。[_1]グループを作成する</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'ユーザーが存在しません。[_1]ユーザーを作成する</a>',
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'ブログがありません。[_1]ブログを作成する</a>',

## tmpl/cms/dialog/entry_notify.tmpl
	'Send a Notification' => '通知の送信',
	'You must specify at least one recipient.' => '少なくとも一人の受信者を指定する必要があります。',
	'Your [_1]\'s name, title, and a link to view it will be sent in the notification. Additionally, you can add a message, include an excerpt and/or send the entire body.' => '[_1]名、タイトル、およびパーマリンクが送られます。メッセージを追加したり、概要や本文を送ることもできます。',
	'Recipients' => 'あて先',
	'Enter email addresses on separate lines or separated by commas.' => '1行に1メールアドレス、またはコンマでメールアドレスを区切り、入力します。',
	'All addresses from Address Book' => 'アドレス帳のすべての連絡先',
	'Optional Message' => 'メッセージ(任意)',
	'Optional Content' => 'コンテンツ(任意)',
	'(Body will be sent without any text formatting applied.)' => '(フォーマットされずに本文が送られます)',
	'Send notification (s)' => '通知を送信 (s)',
	'Send' => '送信',

## tmpl/cms/dialog/list_revision.tmpl
	'Select the revision to populate the values of the Edit screen.' => '編集画面に読み込むリビジョンを選んでください。',

## tmpl/cms/dialog/move_blogs.tmpl
	'Warning: You need to copy uploaded assets to the new path manually. It is also recommended not to delete files in the old path to avoid broken links.' => '警告: アップロード済みのファイルは、新しいウェブサイトのパスに手動でコピーする必要があります。また、旧パスのファイルも残すことで、リンク切れを防止できます。',

## tmpl/cms/dialog/new_password.tmpl
	'Change Password' => 'パスワードの変更',
	'New Password' => '新しいパスワード',
	'Confirm New Password' => '新しいパスワード確認',
	'Change' => '変更',

## tmpl/cms/dialog/publishing_profile.tmpl
	'Publishing Profile' => '公開プロファイル',
	'Choose the profile that best matches the requirements for this blog.' => 'ブログの要件に最も近いプロファイルを選択してください。',
	'Static Publishing' => 'スタティックパブリッシング',
	'Immediately publish all templates statically.' => 'すべてのテンプレートをスタティックパブリッシングします。',
	'Background Publishing' => 'バックグラウンドパブリッシング',
	'All templates published statically via Publish Que.' => 'すべてのテンプレートを公開キュー経由でスタティックパブリッシングします。',
	'High Priority Static Publishing' => '一部アーカイブのみ非同期スタティックパブリッシング',
	'Immediately publish Main Index template, Entry archives, and Page archives statically. Use Publish Queue to publish all other templates statically.' => 'メインページ、ブログ記事アーカイブ、ウェブページアーカイブをスタティックパブリッシングし、他のテンプレートは公開キューを経由してスタティックパブリッシングします。',
	'Immediately publish Main Index template, Page archives statically. Use Publish Queue to publish all other templates statically.' => 'メインページ、ウェブページアーカイブをスタティックパブリッシングし、他のテンプレートは公開キューを経由してスタティックパブリッシングします。',
	'Dynamic Publishing' => 'ダイナミックパブリッシング',
	'Publish all templates dynamically.' => 'すべてのテンプレートをダイナミックパブリッシングします。',
	'Dynamic Archives Only' => 'アーカイブのみダイナミックパブリッシング',
	'Publish all Archive templates dynamically. Immediately publish all other templates statically.' => 'アーカイブテンプレートをすべてダイナミックパブリッシングします。他のテンプレートはスタティックパブリッシングします。',
	'This new publishing profile will update all of your templates.' => '公開プロファイルの設定内容を使って、すべてのテンプレートの設定を更新します。',
	'Are you sure you wish to continue?' => '続けてもよろしいですか?',

## tmpl/cms/dialog/recover.tmpl
	'The email address provided is not unique.  Please enter your username.' => '同じメールアドレスを持っているユーザーがいます。ユーザー名を入力してください。',
	'An email with a link to reset your password has been sent to your email address ([_1]).' => '「[_1]」にパスワードをリセットするためのリンクを含むメールを送信しました。',
	'Go Back (x)' => '戻る (x)',
	'Sign in to Movable Type (s)' => 'Movable Type にサインイン (s)',
	'Sign in to Movable Type' => 'Movable Type にサインイン',
	'Recover (s)' => '再設定 (s)',
	'Recover' => '再設定',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Refresh Global Templates' => 'グローバルテンプレートを初期化',
	'Cannot find template set. Please apply [_1]theme[_2] to refresh your templates.' => 'テンプレートセットが見つかりません。[_1]テーマを適用[_2]して、テンプレートを初期化してください。',
	'Revert modifications of theme templates' => 'テーマテンプレートの変更の取り消し',
	'Reset to theme defaults' => 'デフォルトテーマのリセット',
	'Deletes all existing templates and install the selected theme\'s default.' => '全テンプレートを削除して、既定となっているテーマをインストールします。',
	'Refresh global templates' => 'グローバルテンプレートを初期化',
	'Reset to factory defaults' => '初期状態にリセット',
	'Deletes all existing templates and installs factory default template set.' => '既存のテンプレートをすべて削除して、製品既定のテンプレートセットをインストールします。',
	'Updates current templates while retaining any user-created templates.' => 'テンプレートを更新しますが、ユーザーが作成したテンプレートには影響しません。',
	'Make backups of existing templates first' => '既存のテンプレートのバックアップを作成する',
	'You have requested to <strong>refresh the current template set</strong>. This action will:' => '<strong>現在のテンプレートセットを初期化</strong>しようとしています。この操作では以下の作業を行います。',
	'You have requested to <strong>refresh the global templates</strong>. This action will:' => '<strong>グローバルテンプレート</strong>を初期化しようとしています。この操作では以下の作業を行います。',
	'make backups of your templates that can be accessed through your backup filter' => 'テンプレートのバックアップを作成します。バックアップにはクイックフィルタからアクセスできます。',
	'potentially install new templates' => '(もしあれば)新しいテンプレートをインストールします。',
	'overwrite some existing templates with new template code' => '既存のテンプレートを新しいテンプレートで置き換えます。',
	'You have requested to <strong>apply a new template set</strong>. This action will:' => '<strong>新しいテンプレートセットを適用</strong>しようとしています。この操作では以下の作業を行います。',
	'You have requested to <strong>reset to the default global templates</strong>. This action will:' => '<strong>グローバルテンプレートを既定の状態に</strong>リセットしようとしています。この操作では以下の作業を行います。',
	'delete all of the templates in your blog' => 'ブログのテンプレートはすべて削除されます。',
	'install new templates from the selected template set' => 'テンプレートセットのテンプレートを新規にインストールします。',
	'delete all of your global templates' => 'グローバルテンプレートをすべて削除します。',
	'install new templates from the default global templates' => '既定のグローバルテンプレートを新しくインストールします。',

## tmpl/cms/dialog/restore_end.tmpl
	'An error occurred during the restore process: [_1] Please check your restore file.' => '復元の途中でエラーが発生しました: [_1] バックアップファイルを確認してください。',
	'View Activity Log (v)' => 'ログの表示 (v)',
	'All data restored successfully!' => '全てのデータの復元に成功しました。',
	'Close (s)' => '閉じる (s)',
	'Next Page' => '次へ',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => '3秒後に新しいページに進みます。[_1]タイマーを止める[_2]',

## tmpl/cms/dialog/restore_start.tmpl
	'Restoring...' => '復元...',

## tmpl/cms/dialog/restore_upload.tmpl
	'Restore: Multiple Files' => '復元: 複数ファイル',
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => '作業を中止すると、孤立したオブジェクトが残されます。本当に作業を中止しますか?',
	'Please upload the file [_1]' => '[_1]をアップロードしてください。',

## tmpl/cms/dialog/select_theme.tmpl
	'Select Personal blog theme' => '個人用ブログテーマの選択',
	'Apply' => '適用',

## tmpl/cms/dialog/theme_element_detail.tmpl

## tmpl/cms/edit_asset.tmpl
	'Edit Asset' => 'アイテムの編集',
	'Your asset changes have been made.' => 'アイテムの変更を保存しました。',
	'Stats' => '情報',
	'[_1] - Created by [_2]' => '作成([_2] - [_1])',
	'[_1] - Modified by [_2]' => '更新([_2] - ([_1])',
	'Appears in...' => '利用状況',
	'Show all entries' => 'すべてのブログ記事を表示',
	'Show all pages' => 'すべてのウェブページを表示',
	'This asset has not been used.' => 'アイテムは利用されていません。',
	'Related Assets' => '関連するアイテム',
	'No thumbnail image' => 'サムネール画像がありません。',
	'[_1] is missing' => '[_1]がありません。',
	'Type' => '種類',
	'Embed Asset' => 'アイテムの埋め込み',
	'View this asset.' => 'アイテムの表示',
	'View' => '表示',
	'Save changes to this asset (s)' => 'アイテムへの変更を保存 (s)',
	'You must specify a name for the asset.' => 'アイテムに名前を設定してください。',

## tmpl/cms/edit_author.tmpl
	'Edit Profile' => 'ユーザー情報の編集',
	'This profile has been updated.' => 'ユーザー情報を更新しました。',
	'A new password has been generated and sent to the email address [_1].' => '新しいパスワードが作成され、メールアドレス[_1]に送信されました。',
	'User properties' => 'ユーザー属性',
	'Your web services password is currently' => 'Webサービスのパスワード',
	'_WARNING_PASSWORD_RESET_SINGLE' => '[_1]のパスワードを再設定しようとしています。新しいパスワードはランダムに生成され、ユーザーにメールで送信されます。続行しますか?',
	'Error occurred while removing userpic.' => 'ユーザー画像の削除中にエラーが発生しました。',
	'Profile' => 'ユーザー情報',
	'_USER_STATUS_CAPTION' => '状態',
	'Status of user in the system. Disabling a user prevents that person from using the system but preserves their content and history.' => '無効にされたユーザーはシステムを利用できませんが、コンテンツと履歴は保持されます。',
	'_USER_ENABLED' => '有効',
	'_USER_PENDING' => '保留',
	'_USER_DISABLED' => '無効',
	'The username used to login.' => 'ログイン時に使用するユーザー名です。',
	'External user ID' => '外部ユーザーID',
	'The name displayed when content from this user is published.' => 'コンテンツの公開時に、この名前が表示されます。',
	'The email address associated with this user.' => 'ユーザーのメールアドレスです。',
	'Website URL' => 'ウェブサイトURL',
	'This User\'s website (e.g. http://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.' => 'ユーザーの個人ホームページのURL。表示する名前とウェブサイトURLは、コンテンツやコメントの公開時に利用されます。',
	'Userpic' => 'プロフィール画像',
	'The image associated with this user.' => 'ユーザーのプロフィール画像です。',
	'Select Userpic' => 'プロフィール画像の選択',
	'Remove Userpic' => 'プロフィール画像を削除',
	'Current Password' => '現在のパスワード',
	'Existing password required to create a new password.' => 'パスワード変更には現在のパスワードが必要です。',
	'Initial Password' => '初期パスワード',
	'Enter preferred password.' => '新しいパスワードを入力してください。',
	'Enter the new password.' => '新しいパスワードを入力してください。',
	'Confirm Password' => 'パスワード確認',
	'Repeat the password for confirmation.' => '確認のため、パスワードを再入力してください。',
	'Password recovery word/phrase' => 'パスワード再設定用のフレーズ',
	'This word or phrase is not used in the password recovery.' => 'パスワード再設定用のフレーズは使用されていません。',
	'Preferences' => '設定',
	'Language' => '使用言語',
	'Display language for the Movable Type interface.' => '管理画面で使用する言語です。',
	'Text Format' => 'テキスト形式',
	'Default text formatting filter when creating new entries and new pages.' => 'ブログ記事とウェブページを作成する際のテキスト形式を指定します。',
	'(Use Website/Blog Default)' => '(ウェブサイト/ブログの既定値を利用)',
	'Tag Delimiter' => 'タグの区切り',
	'Preferred method of separating tags.' => 'タグを区切るときに使う文字を選択します。',
	'Web Services Password' => 'Webサービスパスワード',
	'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'ログフィードやXML-RPC、Atom APIで利用するパスワードです。',
	'Reveal' => '内容を表示',
	'System Permissions' => 'システム権限',
	'Options' => 'オプション',
	'Create personal blog for user' => '個人用のブログを作成する',
	'Create User (s)' => 'ユーザーを作成 (s)',
	'Save changes to this author (s)' => 'ユーザーへの変更を保存 (s)',
	'_USAGE_PASSWORD_RESET' => 'ユーザーのパスワードを再設定できます。パスワードがランダムに生成され、[_1]にメールで送信されます。',
	'Initiate Password Recovery' => 'パスワードの再設定',

## tmpl/cms/edit_blog.tmpl
	'Create Blog' => 'ブログの作成',
	'Your blog configuration has been saved.' => 'ブログの設定を保存しました。',
	'You did not select a timezone.' => 'タイムゾーンが選択されていません。',
	'Blog Theme' => 'ブログテーマ',
	'Select the theme you wish to use for this blog.' => 'このブログで利用するテーマを選択してください。',
	'Name your blog. The blog name can be changed at any time.' => 'ブログ名を付けてください。この名前はいつでも変更できます。',
	'Enter the URL of your website. Exclude the filename (i.e. index.html). Example: http://www.example.com/weblog/' => 'ウェブサイトを公開するURLを入力してください。ファイル名(index.htmlなど)は含めないでください。例: http://www.example.com/',
	'Enter the path where your main index file will be located. An absolute path (starting with \'/\') is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/weblog' => 'インデックスファイルを配置するパスです。絶対パス(/で始まる)を推奨しますが、Movable Typeディレクトリからの相対パスも指定できます。例: /home/melody/public_html/',
	'Select your timezone from the pulldown menu.' => 'プルダウンメニューからタイムゾーンを選択してください。',
	'Blog language.' => 'ブログの言語',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'グローバルなDefaultLanguage設定と異なる言語を選んだ場合、グローバルテンプレートの名称が異なるため、テンプレート内で読み込むモジュール名の変更が必要な場合があります。',
	'Create Blog (s)' => 'ブログを作成 (s)',

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'カテゴリの編集',
	'Your category changes have been made.' => 'カテゴリを変更しました。',
	'Manage entries in this category' => 'このカテゴリに属するブログ記事の一覧',
	'You must specify a label for the category.' => 'カテゴリ名を設定してください。',
	'_CATEGORY_BASENAME' => '出力ファイル/フォルダ名',
	'This is the basename assigned to your category.' => 'カテゴリの出力ファイル/フォルダ名です。',
	'Warning: Changing this category\'s basename may break inbound links.' => '警告: このカテゴリの出力ファイル/フォルダ名を変更すると、URLが変更されてリンク切れを招く場合があります。',
	'Inbound TrackBacks' => 'トラックバック受信',
	'If enabled, TrackBacks will be accepted for this category from any source.' => '有効にした場合、このカテゴリへのすべてのトラックバックを許可します。',
	'View TrackBacks' => 'トラックバックを見る',
	'TrackBack URL for this category' => 'このカテゴリのトラックバックURL',
	'_USAGE_CATEGORY_PING_URL' => 'トラックバックを受信するURLです。このカテゴリに関連するブログ記事から広くトラックバックを受け付けたいときは、このURLを公開してください。知り合いにだけこのURLを教えることで、トラックバックの送信元を限定することもできます。受信したトラックバックを公開したい場合は、トラックバック関連のテンプレートタグに関するドキュメントを参照してください。',
	'Passphrase Protection' => 'パスワード保護',
	'Outbound TrackBacks' => 'トラックバック送信',
	'Trackback URLs' => 'トラックバックURL',
	'Enter the URL(s) of the websites that you would like to send a TrackBack to each time you create an entry in this category. (Separate URLs with a carriage return.)' => 'このカテゴリでブログ記事を作成したときにトラックバックを送信したいウェブサイトのURLを入力してください。',
	'Save changes to this category (s)' => 'カテゴリへの変更を保存 (s)',

## tmpl/cms/edit_comment.tmpl
	'Your changes have been saved.' => '変更を保存しました。',
	'The comment has been approved.' => 'コメントを公開しました。',
	'Save changes to this comment (s)' => 'コメントへの変更を保存 (s)',
	'comment' => 'コメント',
	'comments' => 'コメント',
	'Delete this comment (x)' => 'コメントを削除 (x)',
	'Ban This IP' => 'このIPを禁止',
	'Manage Comments' => 'コメントの管理',
	'_external_link_target' => '_blank',
	'View [_1] comment was left on' => 'コメントされた[_1]を表示',
	'Reply to this comment' => 'コメントに返信',
	'Update the status of this comment' => 'このコメントを更新する',
	'Approved' => '公開',
	'Unapproved' => '未公開',
	'Reported as Spam' => 'スパムとして報告',
	'View all comments with this status' => 'このステータスのすべてのコメントを見る',
	'Details' => '詳細',
	'Total Feedback Rating: [_1]' => '最終レーティング: [_1]',
	'Test' => 'テスト',
	'Score' => 'スコア',
	'Results' => '結果',
	'The name of the person who posted the comment' => 'このコメント投稿者の名前',
	'View this commenter detail' => 'コメント投稿者の詳細を見る',
	'Trusted' => '承認済み',
	'(Trusted)' => '(承認済)',
	'Untrust Commenter' => 'コメント投稿者の承認を取り消し',
	'Ban Commenter' => 'コメント投稿者を禁止',
	'Banned' => '禁止',
	'(Banned)' => '(禁止済)',
	'Trust Commenter' => 'コメント投稿者を承認',
	'Unban Commenter' => 'コメント投稿者の禁止を解除',
	'(Pending)' => '(保留済)',
	'View all comments by this commenter' => 'このコメント投稿者のすべてのコメントを見る',
	'Email' => 'メール',
	'Email address of commenter' => 'コメント投稿者のメールアドレス',
	'Unavailable for OpenID user' => 'OpenIDユーザーにはありません',
	'View all comments with this email address' => 'このメールアドレスのすべてのコメントを見る',
	'URL of commenter' => 'コメント投稿者のURL',
	'No url in profile' => '(URL がありません)',
	'Link' => 'リンク',
	'View all comments with this URL' => 'このURLのすべてのコメントを見る',
	'[_1] this comment was made on' => 'このコメントが投稿された[_1]',
	'[_1] no longer exists' => '[_1]が存在しません',
	'View all comments on this [_1]' => '[_1]のすべてのコメントを見る',
	'Date' => '日付',
	'Date this comment was made' => 'このコメントの投稿日',
	'View all comments created on this day' => 'この日に投稿されたすべてのコメントを見る',
	'IP' => 'IP',
	'IP Address of the commenter' => 'コメント投稿者のIPアドレス',
	'View all comments from this IP address' => 'このIPアドレスからのすべてのコメントを見る',
	'Fulltext of the comment entry' => 'コメントの本文',
	'Responses to this comment' => 'このコメントに返信する',

## tmpl/cms/edit_commenter.tmpl
	'Commenter Details' => 'コメント投稿者の詳細',
	'The commenter has been trusted.' => 'コメント投稿者を承認しました。',
	'The commenter has been banned.' => 'コメント投稿者を禁止しました。',
	'Comments from [_1]' => '[_1]からのコメント',
	'commenter' => 'コメント投稿者',
	'commenters' => 'コメント投稿者',
	'to act upon' => '対象に',
	'Trust user (t)' => 'ユーザーを承認 (t)',
	'Trust' => '承認',
	'Untrust user (t)' => 'ユーザーの承認を解除 (t)',
	'Untrust' => '承認を解除',
	'Ban user (b)' => 'ユーザーを禁止 (b)',
	'Ban' => '禁止',
	'Unban user (b)' => 'ユーザーの禁止を解除 (b)',
	'Unban' => '禁止を解除',
	'The Name of the commenter' => 'コメント投稿者の名前',
	'View all comments with this name' => 'この名前のすべてのコメントを見る',
	'Identity' => 'ID',
	'The Identity of the commenter' => 'コメント投稿者の証明',
	'The Email of the commenter' => 'コメント投稿者のメールアドレス',
	'Withheld' => '公開しない',
	'The URL of the commenter' => 'コメント投稿者のURL',
	'The trusted status of the commenter' => 'コメント投稿者の承認状況',
	'Authenticated' => '認証済み',
	'View all commenters' => 'コメント投稿者の一覧',

## tmpl/cms/edit_entry.tmpl
	'Edit Page' => 'ウェブページの編集',
	'Create Page' => 'ウェブページの作成',
	'Add folder' => 'フォルダを追加',
	'Add folder name' => 'フォルダ名を追加',
	'Add new folder parent' => '親フォルダを追加',
	'Preview this page (v)' => 'ウェブページをプレビュー (v)',
	'Delete this page (x)' => 'ウェブページを削除 (x)',
	'View Page' => 'ウェブページを表示',
	'Edit Entry' => 'ブログ記事の編集',
	'Create Entry' => 'ブログ記事の作成',
	'Add category' => 'カテゴリを追加',
	'Add category name' => 'カテゴリ名を追加',
	'Add new category parent' => '親カテゴリを追加',
	'Manage Entries' => 'ブログ記事の管理',
	'Preview this entry (v)' => 'ブログ記事をプレビュー (v)',
	'Delete this entry (x)' => 'ブログ記事を削除 (x)',
	'View Entry' => 'ブログ記事を見る',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'ブログ記事は自動保存されています([_2])。<a href="[_1]">自動保存された内容を元に戻す</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]">Recover auto-saved content</a>' => 'ウェブページは自動保存されています([_2])。<a href="[_1]">自動保存された内容を元に戻す</a>',
	'This entry has been saved.' => 'ブログ記事を保存しました。',
	'This page has been saved.' => 'ウェブページを保存しました。',
	'One or more errors occurred when sending update pings or TrackBacks.' => '更新通知かトラックバック送信でひとつ以上のエラーが発生しました。',
	'_USAGE_VIEW_LOG' => 'エラーの場合は、<a href="[_1]">ログ</a>をチェックしてください。',
	'Your customization preferences have been saved, and are visible in the form below.' => 'カスタマイズ設定を保存しました。下のフォームで確認できます。',
	'Your changes to the comment have been saved.' => 'コメントの変更を保存しました。',
	'Your notification has been sent.' => '通知を送信しました。',
	'You have successfully recovered your saved entry.' => 'ブログ記事を元に戻しました。',
	'You have successfully recovered your saved page.' => 'ウェブページを元に戻しました。',
	'An error occurred while trying to recover your saved entry.' => 'ブログ記事を元に戻す際にエラーが発生しました。',
	'An error occurred while trying to recover your saved page.' => 'ウェブページを元に戻す際にエラーが発生しました。',
	'You have successfully deleted the checked comment(s).' => '選択したコメントを削除しました。',
	'You have successfully deleted the checked TrackBack(s).' => '選択したトラックバックを削除しました。',
	'Restored revision (Date:[_1]).  The current status is: [_2]' => 'リビジョン(日付: [_1])に戻しました。ステータス: [_2]',
	'Some of tags in the revision could not be loaded because they have been removed.' => '履歴データ内に、削除されたために読み込めなかったタグがあります。',
	'Some [_1] in the revision could not be loaded because they have been removed.' => '履歴データ内に、削除されたために読み込めなかった[_1]があります。',
	'Change Folder' => 'フォルダの変更',
	'Unpublished (Draft)' => '未公開(原稿)',
	'Unpublished (Review)' => '未公開(承認待ち)',
	'Scheduled' => '日時指定',
	'Unpublished (Spam)' => '未公開(スパム)',
	'Revision: <strong>[_1]</strong>' => 'リビジョン: <strong>[_1]</strong>',
	'View revisions of this [_1]' => '[_1]のリビジョン表示',
	'View revisions' => 'リビジョン表示',
	'No revision(s) associated with this [_1]' => '[_1]のリビジョンが見つかりません',
	'[_1] - Published by [_2]' => '公開([_2] - [_1])',
	'[_1] - Edited by [_2]' => '編集([_2] - [_1])',
	'Save' => '保存',
	'Save Draft' => '下書き保存',
	'Draft this [_1]' => '[_1]の下書き',
	'Publish this [_1]' => '[_1]の公開',
	'Update' => '更新',
	'Update this [_1]' => '[_1]の更新',
	'Unpublish' => '公開取り消し',
	'Unpublish this [_1]' => '[_1]の公開取り消し',
	'Save this [_1]' => 'この[_1]を保存する',
	'Publish On' => '公開する',
	'Warning: If you set the basename manually, it may conflict with another entry.' => '警告: 出力ファイル名を手動で設定すると、他のブログ記事と衝突を起こす可能性があります。',
	'Warning: Changing this entry\'s basename may break inbound links.' => '警告: このブログ記事の出力ファイル名の変更は、内部のリンク切れの原因となります。',
	'Change note' => '変更メモ',
	'You must configure this blog before you can publish this entry.' => 'ブログ記事を公開する前にブログの設定を行ってください。',
	'You must configure this blog before you can publish this page.' => 'ページを公開する前にブログの設定を行ってください。',
	'edit' => '編集',
	'close' => '閉じる',
	'Accept' => '受信設定',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'View Previously Sent TrackBacks' => '送信済みのトラックバックを見る',
	'Outbound TrackBack URLs' => 'トラックバック送信先URL',
	'[_1] Assets' => '[_1]アイテム',
	'Remove this asset.' => 'アイテム削除',
	'Remove' => '削除',
	'No assets' => 'アイテムはありません',
	'You have unsaved changes to this entry that will be lost.' => '保存されていないブログ記事への変更は失われます。',
	'You have unsaved changes to this page that will be lost.' => '保存されていないウェブページへの変更は失われます。',
	'Enter the link address:' => 'リンクするURLを入力:',
	'Enter the text to link to:' => 'リンクのテキストを入力:',
	'Your entry screen preferences have been saved.' => 'ブログ記事作成画面の設定を保存しました。',
	'Are you sure you want to use the Rich Text editor?' => 'リッチテキストエディタを使用しますか?',
	'Make primary' => 'メインカテゴリにする',
	'Display Options' => '表示オプション',
	'Fields' => 'フィールド',
	'Metadata' => 'メタデータ',
	'Reset display options' => '表示オプションをリセット',
	'Reset display options to blog defaults' => '表示オプションをブログの既定値にリセット',
	'Reset defaults' => '既定値にリセット',
	'Save display options' => '表示オプションを保存',
	'OK' => 'OK',
	'This post was held for review, due to spam filtering.' => 'この投稿はスパムフィルタリングにより承認待ちになっています。',
	'This post was classified as spam.' => 'この投稿はスパムと判定されました。',
	'Spam Details' => 'スパムの詳細',
	'Permalink:' => 'パーマリンク:',
	'Share' => '共有',
	'Format:' => 'フォーマット:',
	'(comma-delimited list)' => '(カンマ区切りリスト)',
	'(space-delimited list)' => '(スペース区切りリスト)',
	'(delimited by \'[_1]\')' => '([_1]で区切る)',
	'None selected' => '選択されていません',
	'Auto-saving...' => '自動保存中...',
	'Last auto-save at [_1]:[_2]:[_3]' => '[_1]:[_2]:[_3]に自動保存済み',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'フォルダの編集',
	'Your folder changes have been made.' => 'フォルダを編集しました。',
	'Manage Folders' => 'フォルダの管理',
	'Manage pages in this folder' => 'このフォルダに属するウェブページ一覧',
	'You must specify a label for the folder.' => 'このフォルダの名前を設定してください。',
	'Path' => 'パス',
	'Save changes to this folder (s)' => 'フォルダへの変更を保存 (s)',

## tmpl/cms/edit_ping.tmpl
	'Edit Trackback' => 'トラックバックの編集',
	'The TrackBack has been approved.' => 'トラックバックを公開しました。',
	'Manage TrackBacks' => 'トラックバックの管理',
	'View [_1]' => '[_1]を見る',
	'Save changes to this TrackBack (s)' => 'トラックバックへの変更を保存 (s)',
	'Delete this TrackBack (x)' => 'トラックバックを削除 (x)',
	'Update the status of this TrackBack' => 'トラックバックの状態を更新する',
	'Junk' => 'スパム',
	'View all TrackBacks with this status' => 'このステータスのトラックバックを全て表示',
	'Source Site' => '送信元のサイト',
	'Search for other TrackBacks from this site' => 'このサイトのその他のトラックバックを検索する',
	'Source Title' => '送信元記事のタイトル',
	'Search for other TrackBacks with this title' => 'このタイトルのその他のトラックバックを検索する',
	'Search for other TrackBacks with this status' => 'このステータスのその他のトラックバックを検索する',
	'Target [_1]' => '宛先[_1]',
	'Entry no longer exists' => 'ブログ記事が存在しません',
	'No title' => 'タイトルなし',
	'View all TrackBacks on this entry' => 'このブログ記事で受信した全てのトラックバックを見る',
	'Target Category' => 'トラックバック送信するカテゴリ',
	'Category no longer exists' => 'このカテゴリは存在しません。',
	'View all TrackBacks on this category' => 'このカテゴリの全てのトラックバックを見る',
	'View all TrackBacks created on this day' => 'この日のトラックバックを全て見る',
	'View all TrackBacks from this IP address' => 'このIPアドレスからのトラックバックを全て見る',
	'TrackBack Text' => 'トラックバックの本文',
	'Excerpt of the TrackBack entry' => 'トラックバックの概要',

## tmpl/cms/edit_role.tmpl
	'Edit Role' => 'ロールの編集',
	'List Roles' => 'ロールの一覧',
	'[quant,_1,Association,Associations] with this role' => '[quant,_1,件,件]の関連付け',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'このロールの権限を変更しました。これによって、このロールに関連付けられているユーザーの権限も変化します。このロールに異なる名前を付けて保存したほうがいいかもしれません。このロールに関連付けられているユーザーの権限が変更されていることに注意してください。',
	'Role Details' => 'ロールの詳細',
	'Created by' => '作成者',
	'System' => 'システム',
	'Privileges' => '権限',
	'Administration' => '管理',
	'Authoring and Publishing' => '作成と公開',
	'Designing' => 'デザインする',
	'Commenting' => 'コメント投稿',
	'Duplicate Roles' => '同じ権限のロール',
	'These roles have the same privileges as this role' => 'このロールと同じ権限を設定されたロール',
	'Save changes to this role (s)' => 'ロールへの変更を保存 (s)',

## tmpl/cms/edit_template.tmpl
	'Edit Widget' => 'ウィジェットの編集',
	'Create Widget' => 'ウィジェットを作成',
	'Create Template' => 'テンプレートの作成',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]">Recover auto-saved content</a>' => '[_1]は自動保存されました。<a href="[_2]">自動保存された内容を元に戻す</a>',
	'You have successfully recovered your saved [_1].' => '[_1]を元に戻しました。',
	'An error occurred while trying to recover your saved [_1].' => '[_1]を元に戻す際にエラーが発生しました。',
	'Restored revision (Date:[_1]).' => 'リビジョン(日付: [_1])に戻しました。',
	'Your template changes have been saved.' => 'テンプレートの変更を保存しました。',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => 'このテンプレートを<a href="[_1]" class="rebuild-link">再構築する</a>',
	'Your [_1] has been published.' => '[_1]を再構築しました。',
	'View revisions of this template' => 'テンプレートのリビジョン表示',
	'No revision(s) associated with this template' => 'テンプレートのリビジョンが見つかりません',
	'Useful Links' => 'ショートカット',
	'Module Option Settings' => 'モジュールオプション設定',
	'List [_1] templates' => '[_1]テンプレート一覧',
	'List all templates' => 'すべてのテンプレートを表示',
	'View Published Template' => '公開されたテンプレートを確認',
	'Included Templates' => 'インクルードテンプレート',
	'create' => '新規作成',
	'Template Tag Docs' => 'タグリファレンス',
	'Unrecognized Tags' => '不明なタグ',
	'Save (s)' => '保存',
	'Save Changes (s)' => '変更を保存 (s)',
	'Save and Publish this template (r)' => 'このテンプレートを保存して再構築 (r)',
	'Save &amp; Publish' => '保存と再構築',
	'You have unsaved changes to this template that will be lost.' => '保存されていないテンプレートへの変更は失われます。',
	'You must set the Template Name.' => 'テンプレート名を設定してください。',
	'You must set the template Output File.' => 'テンプレートの出力ファイル名を設定してください。',
	'Processing request...' => '処理中...',
	'Error occurred while updating archive maps.' => 'アーカイブマッピングの更新中にエラーが発生しました。',
	'Archive map has been successfully updated.' => 'アーカイブマッピングの更新を完了しました。',
	'Are you sure you want to remove this template map?' => 'テンプレートマップを削除してよろしいですか?',
	'Module Body' => 'モジュール本体',
	'Template Body' => 'テンプレートの内容',
	'Template Options' => 'テンプレートの設定',
	'Output file: <strong>[_1]</strong>' => '出力ファイル: <strong>[_1]</strong>',
	'Enabled Mappings: [_1]' => 'アーカイブマッピング: [_1]',
	'Template Type' => 'テンプレートの種類',
	'Custom Index Template' => 'カスタムインデックステンプレート',
	'Link to File' => 'ファイルへのリンク',
	'Learn more about <a href="http://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => '<a href="http://www.movabletype.jp/documentation/administrator/publishing/settings.html" target="_blank">公開プロファイルについて</a>',
	'Create Archive Mapping' => '新しいアーカイブマッピングを作成',
	'Statically (default)' => 'スタティック(既定)',
	'Via Publish Queue' => '公開キュー経由',
	'On a schedule' => 'スケジュール',
	': every ' => '毎',
	'minutes' => '分',
	'hours' => '時',
	'Dynamically' => 'ダイナミック',
	'Manually' => '手動',
	'Do Not Publish' => '公開しない',
	'Server Side Include' => 'サーバーサイドインクルード',
	'Process as <strong>[_1]</strong> include' => '<strong>[_1]</strong>のインクルードとして処理する',
	'Include cache path' => 'キャッシュのパス',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => '無効(<a href="[_1]">変更する</a>)',
	'No caching' => 'キャッシュしない',
	'Expire after' => 'キャッシュを消すタイミング',
	'Expire upon creation or modification of:' => '作成または更新後に無効にする:',

## tmpl/cms/edit_website.tmpl
	'Create Website' => 'ウェブサイトの作成',
	'Website Theme' => 'ウェブサイトテーマ',
	'Select the theme you wish to use for this website.' => 'ウェブサイトで利用したいテーマを選択してください。',
	'Name your website. The website name can be changed at any time.' => 'ウェブサイト名。ウェブサイト名はいつでも変更できます。',
	'Website Root' => 'ウェブサイトパス',
	'Create Website (s)' => 'ウェブサイト作成',

## tmpl/cms/edit_widget.tmpl
	'Edit Widget Set' => 'ウィジェットセットの編集',
	'Create Widget Set' => 'ウィジェットセットの作成',
	'Your widget set changes have been saved.' => 'ウィジェットセットの変更を保存しました。',
	'Widget Set Name' => 'ウィジェットセット名',
	'Drag and drop the widgets that belong in this Widget Set into the \'Installed Widgets\' column.' => 'ウィジェットを「利用可能」から「インストール済み」ボックスにドラッグアンドドロップします。',
	'Installed Widgets' => 'インストール済み',
	'Available Widgets' => '利用可能',
	'Save changes to this widget set (s)' => 'ウィジェットセットへの変更を保存 (s)',
	'You must set Widget Set Name.' => 'ウィジェットセット名を設定してください。',

## tmpl/cms/error.tmpl
	'An error occurred' => 'エラーが発生しました。',

## tmpl/cms/export.tmpl
	'Export Blog Entries' => 'ブログ記事のエクスポート',
	'You must select a blog to export.' => 'エクスポートするブログを選択してください。',
	'_USAGE_EXPORT_1' => 'Movable Typeからブログ記事をエクスポートして、基本的なデータ(記事、コメント、トラックバック)を保存できます。',
	'Blog to Export' => 'エクスポートするブログ',
	'Select a blog for exporting.' => 'エクスポートするブログを選択してください。',
	'Change blog' => 'ブログを変更',
	'Select blog' => 'ブログを選択',
	'Export Blog (s)' => 'ブログをエクスポート (s)',
	'Export Blog' => 'ブログをエクスポート',

## tmpl/cms/export_theme.tmpl
	'Export [_1] Themes' => '[_1]テーマのエクスポート',
	'Theme package have been saved.' => 'テーマパッケージが保存されました。',
	'The name of your theme.' => 'テーマの名前です。',
	'Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, \'-\' or \'_\').' => '次の文字と数字のみ利用できます: アルファベット、数字、ダッシュ(-)、アンダースコア(_)',
	'Version' => 'バージョン',
	'A version number for this theme.' => 'テーマのバージョン番号です。',
	'A description for this theme.' => 'テーマの説明です。',
	'_THEME_AUTHOR' => '作者名',
	'The author of this theme.' => 'テーマの作者名です。',
	'Author link' => '作者のページ',
	'The author\'s website.' => '作者のウェブサイトです',
	'Additional assets to be included in the theme.' => 'テーマに含む追加アイテムです。',
	'Destination' => '出力形式',
	'Select How to get theme.' => 'テーマの出力方法を選択してください。',
	'Setting for [_1]' => '[_1]の設定',
	'You must set Theme Name.' => 'テーマ名を設定してください。',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'アルファベット、数字、ダッシュ(-)、アンダースコア(_)を利用。かならずアルファベットで始めてください。',
	'Cannot install new theme with existing (and protected) theme\'s basename.' => '新しいテーマは既存、または保護されたテーマベース名ではインストールできません。',
	'You must set Author Name.' => '作者名を設定してください。',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'バージョンにはアルファベット、数字、ダッシュ(-)、アンダースコア(_)が利用できます。',

## tmpl/cms/import.tmpl
	'Import Blog Entries' => 'ブログ記事のインポート',
	'You must select a blog to import.' => 'インポート先のブログを選択してください。',
	'Transfer weblog entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => '他のMovable Typeやブログツールからブログ記事を移行したり、ブログ記事のコピーを作成します。',
	'Import data into' => 'インポート先',
	'Select a blog to import.' => 'インポート先のブログを選択してください。',
	'Importing from' => 'インポート元',
	'Ownership of imported entries' => 'インポートしたブログ記事の所有者',
	'Import as me' => '自分のブログ記事としてインポートする',
	'Preserve original user' => 'ブログ記事の著者を変更しない',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => '所有者を変更しない場合には、システムにその所有者をユーザーとして作成し、初期パスワードを設定してください。',
	'Default password for new users:' => '新しいユーザーの初期パスワード',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'あなたがインポートしたブログ記事を作成したことになります。元の著者を変更せずにインポートしたい場合には、システム管理者がインポート作業を行ってください。その場合には必要に応じて新しいユーザーを作成できます。',
	'Upload import file (optional)' => 'インポートファイルをアップロード(オプション)',
	'If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder of your Movable Type directory.' => 'インポートするファイルがローカルのコンピュータ内にある場合にはここにアップロードしてください。アップロードしない場合には、Movable Typeは自動的にアプリケーションディレクトリのimportフォルダ内から探します。',
	'Import File Encoding' => 'インポートするファイルの文字コード',
	'By default, Movable Type will attempt to automatically detect the character encoding of your import file.  However, if you experience difficulties, you can set it explicitly.' => 'Movable Typeはインポートするファイルの文字コードを自動的に検出します。問題が起きたときには、明示的に文字コードを指定することもできます。',
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Default category for entries (optional)' => 'ブログ記事の既定カテゴリ(オプション)',
	'You can specify a default category for imported entries which have none assigned.' => 'カテゴリが設定されていないブログ記事に既定のカテゴリを設定できます。',
	'Select a category' => 'カテゴリを選択',
	'Import Entries (s)' => 'ブログ記事をインポート (s)',

## tmpl/cms/import_others.tmpl
	'Start title HTML (optional)' => 'タイトルとなるHTMLの開始地点(任意)',
	'End title HTML (optional)' => 'タイトルとなるHTMLの終了地点(任意)',
	'If the software you are importing from does not have title field, you can use this setting to identify a title inside the body of the entry.' => 'タイトルのフィールドがないブログツールからインポートする場合に、本文の中から特定の部分をタイトルとして抜き出せます。',
	'Default entry status (optional)' => '既定の公開状態(任意)',
	'If the software you are importing from does not specify an entry status in its export file, you can set this as the status to use when importing entries.' => 'エクスポートされたデータに公開状態に関する情報がない場合、ここで既定値を指定できます。',
	'Select an entry status' => '公開状態',

## tmpl/cms/include/anonymous_comment.tmpl
	'Allow comments from anonymous or unauthenticated users.' => '認証なしコメントを受け付ける',
	'Require E-mail Address for Anonymous Comments' => 'メールアドレスを要求',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => '認証サービスを利用しないコメント投稿に対してメールアドレスを必須項目にします。',

## tmpl/cms/include/archetype_editor.tmpl
	'Decrease Text Size' => 'テキストサイズを小さくする',
	'Increase Text Size' => 'テキストサイズを大きくする',
	'Bold' => '太字',
	'Italic' => '斜体',
	'Underline' => '下線',
	'Strikethrough' => '取り消し線',
	'Text Color' => 'フォントカラー',
	'Email Link' => 'メールアドレスリンク',
	'Begin Blockquote' => '引用開始',
	'End Blockquote' => '引用終了',
	'Bulleted List' => '箇条書きリスト',
	'Numbered List' => '番号付きリスト',
	'Left Align Item' => 'アイテム左揃え',
	'Center Item' => 'アイテム中央揃え',
	'Right Align Item' => 'アイテム右揃え',
	'Left Align Text' => 'テキスト左揃え',
	'Center Text' => 'テキスト中央揃え',
	'Right Align Text' => 'テキスト右揃え',
	'Insert File' => 'ファイルの挿入',
	'WYSIWYG Mode' => 'WYSIWYGモード',
	'HTML Mode' => 'HTMLモード',

## tmpl/cms/include/archive_maps.tmpl
	'Custom...' => 'カスタム...',

## tmpl/cms/include/asset_replace.tmpl
	'A file named \'[_1]\' already exists. Do you want to overwrite this file?' => '同名のアイテム\'[_1]\'がすでに存在します。上書きしますか?',
	'Yes (s)' => 'はい (s)',
	'Yes' => 'はい',
	'No' => 'いいえ',

## tmpl/cms/include/asset_table.tmpl
	'Delete selected assets (x)' => '選択したアイテムを削除',
	'Website/Blog' => 'ウェブサイト/ブログ',
	'Created By' => '作成者',
	'Created On' => '作成日',
	'Asset Missing' => 'アイテムなし',

## tmpl/cms/include/asset_upload.tmpl
	'You must set a valid destination.' => '正しいアップロード先を指定してください。',
	'Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]\'s publishing paths[_3] and republish your [_1].' => 'ファイルのアップロードができるように、[_1]を再構築する必要があります。[_2]公開パスの設定[_3]して、[_1]を再構築してください。',
	'Your system or [_1] administrator needs to publish the [_1] before you can upload files. Please contact your system or [_1] administrator.' => 'ファイルアップロードができるように、システム、または[_1]管理者が[_1]を再構築する必要があります。システム、または[_1]管理者に連絡してください。',
	'Asset file(\'[_1]\') has been uploaded.' => 'アイテム(\'[_1]\')がアップロードされました。',
	'Select File to Upload' => 'アップロードするファイルを選択',
	'_USAGE_UPLOAD' => '下のオプションからアップロード先のパスを選択してください。サブディレクトリを指定することもできます。ディレクトリが存在しない場合は作成されます。',
	'Upload Destination' => 'アップロード先',
	'Choose Folder' => 'フォルダの選択',
	'Upload (s)' => 'アップロード (s)',
	'Upload' => 'アップロード',

## tmpl/cms/include/author_table.tmpl
	'Enable selected users (e)' => '選択したユーザーを有効化 (e)',
	'_USER_ENABLE' => '有効',
	'Disable selected users (d)' => '選択したユーザーを無効化 (d)',
	'_USER_DISABLE' => '無効',
	'user' => 'ユーザー',
	'users' => 'ユーザー',
	'_NO_SUPERUSER_DISABLE' => 'Movable Typeのシステム管理者は自分自身を無効にはできません。',

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been backed up successfully!' => 'すべてのデータは正常にバックアップされました。',
	'Download This File' => 'このファイルをダウンロード',
	'_BACKUP_TEMPDIR_WARNING' => 'バックアップはディレクトリ[_1]に正常に保存されました。バックアップファイルには公開するべきではない情報も含まれています。一覧に表示されたファイルを[_1]ディレクトリからダウンロードした後、<strong>ディレクトリから削除されたことを</strong>すぐに確認してください。',
	'_BACKUP_DOWNLOAD_MESSAGE' => '数秒後にバックアップファイルのダウンロードが開始します。ダウンロードが始まらない場合は<a href=\'#\' onclick=\'submit_form()\'>ここ</a>をクリックしてください。',
	'An error occurred during the backup process: [_1]' => 'バックアップの途中でエラーが発生しました: [_1]',

## tmpl/cms/include/backup_start.tmpl
	'Backing up Movable Type' => 'バックアップを開始',

## tmpl/cms/include/blog_table.tmpl
	'Delete selected [_1] (x)' => '選択された[_1]を削除 (x)',
	'[_1] Name' => '[_1]名',

## tmpl/cms/include/calendar.tmpl
	'_LOCALE_WEEK_START' => '0',
	'S|M|T|W|T|F|S' => '日|月|火|水|木|金|土',
	'January' => '1月',
	'Febuary' => '2月',
	'March' => '3月',
	'April' => '4月',
	'May' => '5月',
	'June' => '6月',
	'July' => '7月',
	'August' => '8月',
	'September' => '9月',
	'October' => '10月',
	'November' => '11月',
	'December' => '12月',
	'Jan' => '1月',
	'Feb' => '2月',
	'Mar' => '3月',
	'Apr' => '4月',
	'_SHORT_MAY' => '5月',
	'Jun' => '6月',
	'Jul' => '7月',
	'Aug' => '8月',
	'Sep' => '9月',
	'Oct' => '10月',
	'Nov' => '11月',
	'Dec' => '12月',
	'[_1:calMonth] [_2:calYear]' => '[_2:calYear]年[_1:calMonth]',

## tmpl/cms/include/category_selector.tmpl
	'Add sub category' => 'サブカテゴリを追加',
	'Add sub folder' => 'サブフォルダを追加',

## tmpl/cms/include/comment_detail.tmpl

## tmpl/cms/include/comment_table.tmpl
	'Publish selected comments (a)' => '選択されたコメントを再構築 (a)',
	'Delete selected comments (x)' => '選択されたコメントを削除 (x)',
	'Report selected comments as Spam (j)' => '選択されたコメントをスパムとして報告 (j)',
	'Report selected comments as Not Spam and Publish (j)' => '選択されたコメントのスパム状態を解除して公開 (j)',
	'Not Spam' => 'スパム解除',
	'Are you sure you want to remove all comments reported as spam?' => 'スパムコメントをすべて削除しますか?',
	'Delete all comments reported as Spam' => 'スパムコメントをすべて削除',
	'Empty' => 'すべて削除',
	'Entry/Page' => 'ブログ記事/ウェブページ',
	'Only show published comments' => '公開中のコメントだけを表示',
	'Only show spam comments' => 'コメントスパムだけを表示',
	'Only show pending comments' => '保留中のコメントだけを表示',
	'Edit this comment' => 'このコメントを編集',
	'([quant,_1,reply,replies])' => '(返信数 [_1])',
	'Blocked' => '禁止中',
	'Edit this [_1] commenter' => 'このコメント投稿者([_1])を編集',
	'Search for comments by this commenter' => 'このコメント投稿者のコメントを検索',
	'View this entry' => 'ブログ記事を表示',
	'View this page' => 'ウェブページを表示',
	'Search for all comments from this IP address' => 'このIPアドレスからのすべてのコメントを検索',
	'to republish' => '再構築',

## tmpl/cms/include/commenter_table.tmpl
	'Last Commented' => '最近のコメント',
	'Only show trusted commenters' => '承認されたコメント投稿者のみを表示',
	'Only show banned commenters' => '禁止されているコメント投稿者のみを表示',
	'Only show neutral commenters' => '保留中のコメント投稿者のみを表示',
	'Edit this commenter' => 'このコメント投稿者を編集',
	'View this commenter&rsquo;s profile' => 'このコメント投稿者のユーザー情報を見る',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001-[_1] Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001-[_1] Six Apart. All Rights Reserved.',

## tmpl/cms/include/debug_hover.tmpl
	'Hide Toolbar' => 'Hide Toolbar',
	'Hide &raquo;' => 'Hide &raquo;',

## tmpl/cms/include/debug_toolbar/cache.tmpl
	'Key' => 'Key',
	'Value' => 'Value',

## tmpl/cms/include/debug_toolbar/headers.tmpl

## tmpl/cms/include/debug_toolbar/requestvars.tmpl
	'Cookies' => 'Cookies',
	'Variable' => 'Variable',
	'No COOKIE data' => 'No COOKIE data',
	'Input Parameters' => 'Input Parameters',
	'No Input Parameters' => 'No Input Parameters',

## tmpl/cms/include/debug_toolbar/sql.tmpl

## tmpl/cms/include/display_options.tmpl
	'_DISPLAY_OPTIONS_SHOW' => '表示数',
	'[quant,_1,row,rows]' => '[quant,_1,行,行]',
	'Compact' => '簡易',
	'Expanded' => '詳細',
	'Date Format' => '日付',
	'Relative' => '経過',
	'Full' => '年月日',

## tmpl/cms/include/entry_table.tmpl
	'Save these [_1] (s)' => '[_1]の保存',
	'Republish selected [_1] (r)' => '選択した[_1]の再構築',
	'Last Modified' => '最終更新',
	'Created' => '作成',
	'Only show unpublished entries' => '未公開のブログ記事を表示',
	'Only show unpublished pages' => '未公開のウェブページを表示',
	'Only show published entries' => '公開中のブログ記事を表示',
	'Only show published pages' => '公開中のウェブページを表示',
	'Only show entries for review' => '承認待ちのブログ記事を表示',
	'Only show pages for review' => '承認待ちのウェブページを表示',
	'Only show scheduled entries' => '指定日投稿されるブログ記事を表示',
	'Only show scheduled pages' => '指定日投稿されるウェブページを表示',
	'Only show spam entries' => 'スパム指定されているブログ記事のみを表示',
	'Only show spam pages' => 'スパム指定されているウェブページのみを表示',
	'View entry' => 'ブログ記事を見る',
	'View page' => 'ウェブページを表示',
	'No entries could be found.' => '記事がありません。',
	'<a href="[_1]">Create an entry</a> now.' => '<a href="[_1]">記事を作成</a>する。',
	'No page could be found. <a href="[_1]">Create a page</a> now.' => 'ウェブページが見つかりませんでした。<a href="[_1]">ウェブページの作成</a>',

## tmpl/cms/include/feed_link.tmpl
	'Activity Feed' => 'ログフィード',
	'Set Web Services Password' => 'Webサービスのパスワードを設定',

## tmpl/cms/include/footer.tmpl
	'This is a beta version of Movable Type and is not recommended for production use.' => 'このMovable Typeはベータ版です。',
	'http://www.movabletype.org' => 'http://www.movabletype.jp',
	'MovableType.org' => 'MovableType.jp',
	'http://wiki.movabletype.org/' => 'http://wiki.movabletype.org/',
	'Wiki' => 'Wiki(英語)',
	'http://www.movabletype.com/support/' => 'http://www.sixapart.jp/movabletype/support',
	'Support' => 'サポート',
	'http://forums.movabletype.org/' => 'http://communities.movabletype.jp/',
	'Forums' => 'ユーザーコミュニティ',
	'http://www.movabletype.org/feedback.html' => 'http://www.sixapart.jp/movabletype/feedback.html',
	'Send Us Feedback' => 'フィードバックはこちらへ',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]',
	'with' => ':',
	'Your Dashboard' => 'ユーザーダッシュボード',

## tmpl/cms/include/header.tmpl
	'Signed in as [_1]' => 'ユーザー: [_1]',
	'Help' => 'ヘルプ',
	'Sign out' => 'サインアウト',
	'User Dashboard' => 'ユーザーダッシュボード',
	'Select another website...' => 'ウェブサイトを選択',
	'(on [_1])' => '([_1])',
	'Select another blog...' => 'ブログを選択',
	'Create Blog (on [_1])' => 'ブログの作成 ([_1])',
	'View Site' => 'サイトの表示',
	'Search (q)' => '検索 (q)',
	'This website was created during the version-up from the previous version of Movable Type. \'Site Root\' and \'Site URL\' are left blank to retain \'Publishing Paths\' compatibility for blogs those were created at the previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank \'Site Root\' and \'Site URL\'.' => 'このウェブサイトは、以前のバージョンのMovable Typeからのバージョンアップ時に作成されました。バージョンアップ前に作成されたブログの公開設定の互換性を保持するために、ウェブサイトのサイト URLとサイトパスは空白になっています。そのため、既存のブログに投稿、公開はできますが、ウェブサイト自体にコンテンツを投稿することはできません。',
	'from Revision History' => '履歴データ',

## tmpl/cms/include/import_end.tmpl
	'All data imported successfully!' => 'すべてのデータをインポートしました。',
	'Make sure that you remove the files that you imported from the \'import\' folder, so that if/when you run the import process again, those files will not be re-imported.' => '\'import\'ディレクトリからインポートしたファイルを削除することを忘れないでください。もう一度インポート機能を利用した場合に、同じファイルが再度インポートされてしまう可能性があります。',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'インポートの途中でエラーが発生しました : [_1]。インポートファイルを確認してください。',

## tmpl/cms/include/import_start.tmpl
	'Importing...' => 'インポートを開始します...',
	'Importing entries into blog' => 'ブログ記事をブログにインポートしています',
	'Importing entries as user \'[_1]\'' => 'ユーザー[_1]としてブログ記事をインポートしています',
	'Creating new users for each user found in the blog' => 'ブログのユーザーを新規ユーザーとして作成',

## tmpl/cms/include/itemset_action_widget.tmpl
	'More actions...' => 'アクション...',
	'Plugin Actions' => 'プラグインアクション',
	'Go' => 'Go',

## tmpl/cms/include/list_associations/page_title.tmpl
	'Permissions for [_1]' => '[_1]の権限',
	'Manage Permissions' => '権限の管理',
	'Users for [_1]' => 'ユーザー - [_1]',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => '[_1] / [_2]',
	'Go to [_1]' => '[_1]へ進む',
	'Sorry, there were no results for your search. Please try searching again.' => '検索結果がありません。検索をやり直してください。',
	'Sorry, there is no data for this object set.' => 'このオブジェクトセットに対応したデータはありません。',
	'OK (s)' => 'OK (s)',

## tmpl/cms/include/log_table.tmpl
	'No log records could be found.' => 'ログレコードが見つかりませんでした。',
	'_LOG_TABLE_BY' => 'ユーザー',
	'Show Datail' => '詳細表示',
	'IP: [_1]' => 'IP: [_1]',

## tmpl/cms/include/login_mt.tmpl
	'Remember me?' => 'ログイン情報を記憶する',

## tmpl/cms/include/member_table.tmpl
	'Are you sure you want to remove the selected user from this blog?' => 'ブログからユーザーを削除してよろしいですか?',
	'Are you sure you want to remove the [_1] selected users from this blog?' => 'ブログから[_1]人のユーザーを削除してよろしいですか?',
	'Remove selected user(s) (r)' => 'ユーザーを削除 (r)',
	'Trusted commenter' => '承認されたコメント投稿者',
	'Remove this role' => 'ロールを削除する',

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => '日付',
	'Click to edit contact' => 'クリックして連絡先を編集',
	'Save changes' => '変更を保存',

## tmpl/cms/include/pagination.tmpl

## tmpl/cms/include/ping_table.tmpl
	'Publish selected [_1] (p)' => '選択された[_1]を公開 (p)',
	'Report selected [_1] as Spam (j)' => '選択された[_1]をスパムとして報告 (j)',
	'Report selected [_1] as Not Spam and Publish (j)' => '選択された[_1]のスパム状態を解除して公開 (j)',
	'Are you sure you want to remove all TrackBacks reported as spam?' => 'スパムとして報告したすべてのトラックバックを削除しますか?',
	'Deletes all [_1] reported as Spam' => 'スパムとして報告したすべての[_1]を削除する',
	'From' => '送信元',
	'Target' => '送信先',
	'Only show published TrackBacks' => '公開されたトラックバックのみを表示',
	'Only show spam TrackBacks' => 'トラックバックスパムのみを表示',
	'Only show pending TrackBacks' => '保留中のトラックバックのみを表示',
	'Edit this TrackBack' => 'このトラックバックを編集',
	'Go to the source entry of this TrackBack' => 'トラックバック送信元に移動',
	'View the [_1] for this TrackBack' => 'トラックバックされた[_1]を見る',

## tmpl/cms/include/revision_table.tmpl
	'No revisions could be found.' => '変更履歴がありません。',
	'Note' => 'メモ',
	'Saved By' => '保存したユーザー',

## tmpl/cms/include/rpt_log_table.tmpl
	'Schwartz Message' => 'Schwartzメッセージ',

## tmpl/cms/include/template_table.tmpl
	'Create Archive Template:' => 'アーカイブテンプレートの作成:',
	'Entry Listing' => 'ブログ記事リスト',
	'Create template module' => 'テンプレートモジュールの作成',
	'Create index template' => 'インデックステンプレートの作成',
	'Publish selected templates (a)' => '選択されたテンプレートを公開 (a)',
	'SSI' => 'SSI',
	'Cached' => 'キャッシュ',
	'Linked Template' => 'ファイルにリンクされたテンプレート',
	'-' => '-',
	'Manual' => '手動',
	'Dynamic' => 'ダイナミック',
	'Publish Queue' => '公開キュー',
	'Static' => 'スタティック',
	'templates' => 'テンプレート',
	'to publish' => '公開',

## tmpl/cms/include/theme_exporters/category.tmpl
	'Category Name' => 'カテゴリ名',

## tmpl/cms/include/theme_exporters/folder.tmpl
	'Folder Name' => 'フォルダ名',

## tmpl/cms/include/theme_exporters/static_files.tmpl
	'In the specified directories, files of the following types will be included in the theme: [_1]. Other file types will be ignored.' => '指定したディレクトリ内の、以下の種類のファイルがテーマにエクスポートされます: [_1]。その他のファイルは無視されます。',
	'Specify directories' => 'ディレクトリの指定',
	'List directories (one per line) in the Site Root directory which contain the static files to be included in the theme. Common directories might be: css, images, js, etc.' => 'ファイルが置かれたディレクトリを、サイトパスからの相対パスで一行ずつ記入してください。例: images',

## tmpl/cms/include/theme_exporters/templateset.tmpl
	'widget sets' => 'ウィジェットセット',
	'modules' => 'モジュール',
	'<span class="count">[_1]</span> [_2] are included' => '<span class="count">[_1]</span>件の[_2]が含まれます',

## tmpl/cms/include/users_content_nav.tmpl

## tmpl/cms/install.tmpl
	'Welcome to Movable Type' => 'Movable Typeへようこそ',
	'Create Your Account' => 'アカウントの作成',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'サーバーにインストールされているPerlのバージョン([_1])が、Movable Type がサポートしているバージョン([_2])より低いため正常に動作しない可能性があります。',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Movable Type が動作する場合でも、<strong>動作確認を行っていない、サポート対象外の環境となります</strong>。少なくともPerl[_1]以上へアップグレードすることを強くお勧めします。',
	'Do you want to proceed with the installation anyway?' => 'インストールを続けますか?',
	'View MT-Check (x)' => 'システムチェック (x)',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'システム管理者のアカウントを作成してください。作成が完了すると、データベースを初期化します。',
	'To proceed, you must authenticate properly with your LDAP server.' => 'LDAPサーバーで認証を受けないと先に進めません。',
	'The name used by this user to login.' => 'ログイン時に使用するユーザー名です。',
	'The name used when published.' => '表示名です。',
	'The user&rsquo;s email address.' => 'ユーザーのメールアドレスです。',
	'The email address used in the From: header of each email sent from the system.' => 'システムから送信されるメールのFromアドレスとして利用されるアドレスです。',
	'Use this as system email address' => 'システムのメールアドレスとして利用する',
	'The user&rsquo;s preferred language.' => 'ユーザーの表示用の言語',
	'Select a password for your account.' => 'パスワードを入力してください。',
	'Your LDAP username.' => 'LDAPのユーザー名を入力してください。',
	'Enter your LDAP password.' => 'LDAPのパスワードを入力してください。',
	'The initial account name is required.' => '名前は必須です。',
	'The display name is required.' => '表示名は必須です。',
	'The e-mail address is required.' => 'メールアドレスは必須です。',
	'Password recovery word/phrase is required.' => 'パスワード再設定用のフレーズは必須です。',

## tmpl/cms/list_asset.tmpl
	'You have successfully deleted the asset(s).' => 'アイテムを削除しました。',
	'New Asset' => 'アイテムを作成',
	'Quickfilters' => 'クイックフィルタ',
	'Showing only: [_1]' => '[_1]を表示',
	'Remove filter' => 'フィルタしない',
	'All [_1]' => 'すべての[_1]',
	'change' => '絞り込み',
	'[_1] where [_2] is [_3]' => '[_2]が[_3]の[_1]',
	'Show only assets where' => 'アイテムを表示: ',
	'type' => 'タイプ',
	'tag (exact match)' => 'タグ (完全一致)',
	'tag (fuzzy match)' => 'タグ (あいまい検索)',
	'is' => 'が',
	'Filter' => 'フィルタ',

## tmpl/cms/list_association.tmpl
	'Members' => 'メンバー',
	'permission' => '権限',
	'permissions' => '権限',
	'Remove selected permissions (x)' => '選択された権限を削除 (x)',
	'Revoke Permission' => '権限を削除',
	'[_1] <em>[_2]</em> is currently disabled.' => '[_2]は無効に設定されています。',
	'Grant Website Permission' => 'ウェブサイト権限の設定',
	'Grant Blog Permission' => 'ブログ権限の設定',
	'You can not create permissions for disabled users.' => '無効にされているユーザーの権限を設定できません。',
	'Grant Permission' => '権限を付与',
	'Assign Website Role to User' => 'ユーザーにウェブサイトのロールを割り当てる',
	'Assign Blog Role to User' => 'ユーザーにブログのロールを割り当てる',
	'Add a user to this blog' => 'このブログにユーザーを追加',
	'Grant website permission to a user' => 'ユーザーにウェブサイトの権限を割り当てる',
	'Grant blog permission to a user' => 'ユーザーにブログの権限を割り当てる',
	'You have successfully revoked the given permission(s).' => '権限を削除しました。',
	'You have successfully granted the given permission(s).' => '権限を付与しました。',
	'No permissions could be found.' => '権限が見つかりませんでした。',

## tmpl/cms/list_author.tmpl
	'You have successfully disabled the selected user(s).' => '選択したユーザーを無効にしました。',
	'You have successfully enabled the selected user(s).' => '選択したユーザーを有効にしました。',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'システムからユーザーを削除しました。',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Advanced.' => '削除されたユーザーが外部ディレクトリ上にまだ存在するので、このままではユーザーは再度ログインできてしまいます。',
	'You have successfully synchronized users\' information with the external directory.' => '外部のディレクトリとユーザーの情報を同期しました。',
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => '選択されたユーザーのうち[_1]人は外部ディレクトリ上に存在しないので有効にできませんでした。',
	'An error occured during synchronization.  See the <a href=\'[_1]\'>activity log</a> for detailed information.' => '同期中にエラーが発生しました。エラーの詳細を<a href=\'[_1]\'>ログ</a>で確認して>ください。',
	'Showing All Users' => 'すべてのユーザーを表示',

## tmpl/cms/list_banlist.tmpl
	'IP Banning Settings' => '禁止IPアドレスの設定',
	'IP addresses' => 'IPアドレス',
	'Delete selected IP Address (x)' => '選択されたIPアドレスを削除 (x)',
	'You have added [_1] to your list of banned IP addresses.' => '禁止IPリストに[_1]を追加しました。',
	'You have successfully deleted the selected IP addresses from the list.' => 'リストから選択したIPアドレスを削除しました。',
	'Ban IP Address' => '禁止IPアドレス',
	'No IP Address is banned.' => '禁止IPリストがありません。',
	'Date Banned' => '禁止した日付',

## tmpl/cms/list_blog.tmpl
	'Manage [_1]' => '[_1]の管理',
	'You have successfully deleted the website from the Movable Type system.' => 'システムからウェブサイトの削除が完了しました。',
	'You have successfully deleted the blog from the website.' => 'ウェブサイトからブログの削除が完了しました。',
	'You have successfully refreshed your templates.' => 'テンプレートの初期化を完了しました。',
	'You have successfully moved selected blogs to another website.' => '他のウェブサイトへのブログの移動が完了しました。',
	'Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.' => '警告: アップロード済みのファイルは、新しいウェブサイトのパスに手動でコピーする必要があります。また、リンク切れを防止するために、旧パスのファイルも残すことを検討してください。',
	'Some templates were not refreshed.' => '初期化できないテンプレートがありました。',
	'Some websites were not deleted. You need to delete blogs under the website first.' => '削除できないウェブサイトがありました。ウェブサイト内のブログを先に削除する必要があります。',

## tmpl/cms/list_category.tmpl
	'Your category changes and additions have been made.' => 'カテゴリの変更と追加を行いました。',
	'You have successfully deleted the selected category.' => '選択されたカテゴリを削除しました。',
	'categories' => 'カテゴリ',
	'Delete selected category (x)' => 'カテゴリを削除 (x)',
	'Create top level category' => 'トップレベルカテゴリを作成',
	'New Parent [_1]' => '新しいトップレベルの[_1]',
	'Create Category' => 'カテゴリを作成',
	'Create' => '新規作成',
	'Top Level' => 'ルート',
	'Collapse' => '折りたたむ',
	'Expand' => '展開する',
	'Create Subcategory' => 'サブカテゴリの作成',
	'Move Category' => 'カテゴリの移動',
	'Move' => '移動',
	'[quant,_1,entry,entries]' => '記事[quant,_1,件,件]',
	'[quant,_1,TrackBack,TrackBacks]' => 'トラックバック[quant,_1,件,件]',
	'No categories could be found.' => 'カテゴリが見つかりませんでした。',

## tmpl/cms/list_comment.tmpl
	'The selected comment(s) has been approved.' => '選択したコメントを公開しました。',
	'All comments reported as spam have been removed.' => 'スパムとして報告されたコメントをすべて削除しました。',
	'The selected comment(s) has been unapproved.' => '選択したコメントを未公開にしました。',
	'The selected comment(s) has been reported as spam.' => '選択したコメントをスパムとして報告しました。',
	'The selected comment(s) has been recovered from spam.' => '選択したコメントをスパムから戻しました。',
	'The selected comment(s) has been deleted from the database.' => '選択したコメントをデータベースから削除しました。',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be Banned or Trusted.' => '選択したコメントの中に匿名のコメントが含まれています。これらのコメント投稿者は禁止したり承認したりできません。',
	'No comments appeared to be spam.' => 'スパムコメントはありません。',
	'[_1] (Disabled)' => '[_1] (無効)',
	'[_1] on entries created within the last [_2] days' => '直近[_2]日以内に作成されたブログ記事への[_1]',
	'[_1] on entries created more than [_2] days ago' => '[_2]日以上前に作成されたブログ記事への[_1]',
	'status' => 'ステータス',
	'approved' => '公開中',
	'pending' => '保留中',
	'spam' => 'スパム',

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => 'ブログ記事フィード',
	'Pages Feed' => 'ウェブページフィード',
	'The entry has been deleted from the database.' => 'ブログ記事をデータベースから削除しました。',
	'The page has been deleted from the database.' => 'ウェブページをデータベースから削除しました。',
	'Show only entries where' => 'ブログ記事を表示: ',
	'Show only pages where' => 'ウェブページを表示: ',
	'asset' => 'アイテム',
	'published' => '公開',
	'unpublished' => '未公開',
	'review' => '承認待ち',
	'scheduled' => '指定日公開',
	'Select A User:' => 'ユーザーを選択:',
	'User Search...' => 'ユーザーを検索',
	'Recent Users...' => '最近のユーザー',

## tmpl/cms/list_folder.tmpl
	'Your folder changes and additions have been made.' => 'フォルダを保存しました。',
	'You have successfully deleted the selected folder.' => '選択されたフォルダを削除しました。',
	'Delete selected folders (x)' => '選択されたフォルダを削除 (x)',
	'Create top level folder' => 'トップレベルのフォルダを作成',
	'Create Folder' => 'フォルダの作成',
	'Create Subfolder' => 'サブフォルダを作成',
	'Move Folder' => 'フォルダの移動',
	'[quant,_1,page,pages]' => 'ページ[quant,_1,件,件]',
	'No folders could be found.' => 'フォルダが見つかりませんでした。',

## tmpl/cms/list_member.tmpl
	'Are you sure you want to remove the user from this role?' => 'ユーザーから、このロールを削除しますか？',
	'Add a user to this website' => 'このウェブサイトにユーザーを追加',
	'Show only users where' => 'ユーザーを表示: ',
	'role' => 'ロール',
	'enabled' => '有効',
	'disabled' => '無効',

## tmpl/cms/list_notification.tmpl
	'Manage [_1] Address Book' => '[_1]アドレス帳の管理',
	'You have added [_1] to your address book.' => 'アドレス帳に[_1]を登録しました。',
	'You have successfully deleted the selected contacts from your address book.' => 'アドレス帳から選択したあて先を削除しました。',
	'Download Address Book (CSV)' => 'アドレス帳をダウンロード(CSV)',
	'contact' => '連絡先',
	'contacts' => '連絡先',
	'Create Contact' => '新しい連絡先を作成',
	'Add Contact' => '連絡先の追加',

## tmpl/cms/list_ping.tmpl
	'The selected TrackBack(s) has been approved.' => '選択したトラックバックを公開しました。',
	'All TrackBacks reported as spam have been removed.' => 'スパムとして報告したすべてのトラックバックを削除しました。',
	'The selected TrackBack(s) has been unapproved.' => '選択したトラックバックを未公開にしました。',
	'The selected TrackBack(s) has been reported as spam.' => '選択したトラックバックをスパムとして報告しました。',
	'The selected TrackBack(s) has been recovered from spam.' => '選択したトラックバックをスパムから戻しました。',
	'The selected TrackBack(s) has been deleted from the database.' => '選択したトラックバックをデータベースから削除しました。',
	'No TrackBacks appeared to be spam.' => 'スパムトラックバックはありません。',
	'Show only [_1] where' => '[_1]を表示: ',
	'unapproved' => '未公開',

## tmpl/cms/list_role.tmpl
	'Manage Roles' => 'ロールの管理',
	'You have successfully deleted the role(s).' => 'ロールを削除しました。',
	'roles' => 'ロール',
	'Role Is Active' => 'アクティブ',
	'Role Not Being Used' => '使用されていないロール',

## tmpl/cms/list_tag.tmpl
	'Your tag changes and additions have been made.' => 'タグの変更と追加が完了しました。',
	'You have successfully deleted the selected tags.' => '選択したタグを削除しました。',
	'tag' => 'タグ',
	'tags' => 'タグ',
	'Specify new name of the tag.' => 'タグの名前を指定してください。',
	'Tag Name' => 'タグ名',
	'Click to edit tag name' => 'クリックしてタグの名前を編集',
	'Rename [_1]' => '[_1]の名前を変更する',
	'Rename' => '名前を変更',
	'Show all [_1] with this tag' => 'このタグが付いている[_1]を表示',
	'[quant,_1,_2,_3]' => '[_1]',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all blogs?' => 'タグ「[_2]」は既に存在します。すべてのブログで「[_1]」を「[_2]」にマージしてもよろしいですか?',
	'An error occurred while testing for the new tag name.' => 'このタグは使用できません。',

## tmpl/cms/list_template.tmpl
	'Manage [_1] Templates' => '[_1]テンプレートの管理',
	'Manage Global Templates' => 'グローバルテンプレートの管理',
	'Show All Templates' => 'すべてのテンプレート',
	'Publishing Settings' => '公開設定',
	'You have successfully deleted the checked template(s).' => '選択したテンプレートを削除しました。',
	'Your templates have been published.' => 'テンプレートを再構築しました。',
	'Selected template(s) has been copied.' => '選択されたテンプレートをコピーしました。',

## tmpl/cms/list_theme.tmpl
	'[_1] Themes' => '[_1]テーマの一覧',
	'All Themes' => 'テーマの一覧',
	'Theme [_1] has been uninstalled.' => 'テーマ "[_1]"をアンインストールしました。',
	'Theme [_1] has been applied.' => 'テーマ "[_1]"を適用しました。',
	'Some error occured while applying theme.' => 'テーマの適用中にエラーがありました。',
	'see more detail.' => 'エラーの詳細',
	'Failed' => '失敗',
	'[quant,_1,warning,warnings]' => '警告: [quant,_1,,,]',
	'Current Theme' => '現在のテーマ',
	'In Use' => '利用中',
	'Uninstall' => 'アンインストール',
	'Author: ' => '作者: ',
	'This theme cannot be applied to the website due to [_1] errors' => '次の理由により、テーマを適用できませんでした。',
	'Errors' => 'エラー',
	'Warnings' => '警告',
	'Theme Errors' => 'テーマエラー',
	'Theme Warnings' => 'テーマ警告',
	'Portions of this theme cannot be applied to the website. [_1] elements will be skipped.' => 'テーマの一部はウェブサイトに適用できません。[_1]要素はスキップされます。',
	'Theme Information' => 'テーマ情報',
	'No themes are installed.' => 'テーマがインストールされていません。',
	'Themes for Both Blogs and Websites' => 'ウェブサイト、およびブログ用のテーマ',
	'Themes for Blogs' => 'ブログ用テーマ',
	'Themes for Websites' => 'ウェブサイト用テーマ',

## tmpl/cms/list_widget.tmpl
	'Manage [_1] Widgets' => '[_1]ウィジェットの管理',
	'Delete selected Widget Sets (x)' => '選択されたウィジェットセットを削除 (x)',
	'Helpful Tips' => 'ヘルプ',
	'To add a widget set to your templates, use the following syntax:' => 'テンプレートにウィジェットセットを追加するときは以下の構文を利用します。',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;ウィジェットセットの名前&quot;$&gt;</strong>',
	'Your changes to the widget set have been saved.' => 'ウィジェットセットへの変更を保存しました。',
	'You have successfully deleted the selected widget set(s) from your blog.' => '選択されたウィジェットセットを削除しました。',
	'No Widget Sets could be found.' => 'ウィジェットセットが見つかりませんでした。',
	'Create widget template' => 'ウィジェットテンプレートの作成',

## tmpl/cms/login.tmpl
	'Sign in' => 'サインイン',
	'Your Movable Type session has ended.' => 'Movable Typeからログアウトしました。',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Movable Typeからログアウトしました。以下から再度ログインできます。',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Movable Typeからログアウトしました。続けるには再度サインインして下さい。',
	'Sign In (s)' => 'サインイン (s)',
	'Forgot your password?' => 'パスワードをお忘れですか?',

## tmpl/cms/pinging.tmpl
	'Trackback' => 'トラックバック',
	'Pinging sites...' => 'トラックバックと更新通知を送信しています...',

## tmpl/cms/popup/pinged_urls.tmpl
	'Successful Trackbacks' => 'トラックバック(送信済み)',
	'Failed Trackbacks' => 'トラックバック(未送信)',
	'To retry, include these TrackBacks in the Outbound TrackBack URLs list for your entry.' => '再送する場合は、トラックバック送信先URLにこれらのトラックバックをコピーしてください。',

## tmpl/cms/popup/rebuild_confirm.tmpl
	'Publish [_1]' => '[_1]の再構築',
	'Publish <em>[_1]</em>' => '[_1]の再構築',
	'_REBUILD_PUBLISH' => '再構築',
	'All Files' => 'すべてのファイル',
	'Index Template: [_1]' => 'インデックステンプレート: [_1]',
	'Only Indexes' => 'インデックスのみ',
	'Only [_1] Archives' => '[_1]アーカイブのみ',
	'Publish (s)' => '再構築 (s)',

## tmpl/cms/popup/rebuilt.tmpl
	'Success' => '完了',
	'The files for [_1] have been published.' => '[_1]を再構築しました。',
	'Your [_1] archives have been published.' => '[_1]アーカイブを再構築しました。',
	'Your [_1] templates have been published.' => '[_1]テンプレートを再構築しました。',
	'Publish time: [_1].' => '処理時間: [_1]',
	'View your site.' => 'サイトを見る',
	'View this page.' => 'ページを見る',
	'Publish Again (s)' => '再構築 (s)',
	'Publish Again' => '再構築しなおす',

## tmpl/cms/preview_entry.tmpl
	'Preview [_1]' => '[_1]をプレビューする',
	'Re-Edit this [_1]' => 'この[_1]を再編集する',
	'Re-Edit this [_1] (e)' => 'この[_1] (e)を再編集',
	'Save this [_1] (s)' => '[_1]を保存 (s)',
	'Cancel (c)' => '取り消し',

## tmpl/cms/preview_strip.tmpl
	'Return to the compose screen' => '作成画面に戻る',
	'Return to the compose screen (e)' => '作成画面に戻る',
	'You are previewing the entry entitled &ldquo;[_1]&rdquo;' => 'プレビュー中: 記事「[_1]」',
	'You are previewing the page entitled &ldquo;[_1]&rdquo;' => 'プレビュー中: ページ「[_1]」',

## tmpl/cms/preview_template_strip.tmpl
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'テンプレート「[_1]」をプレビューしています。',
	'(Publish time: [_1] seconds)' => '(処理時間: [_1]秒)',
	'Return to the template editor (e)' => 'テンプレート編集に戻る',
	'Return to the template editor' => 'テンプレート編集に戻る',

## tmpl/cms/rebuilding.tmpl
	'Publishing...' => '再構築中...',
	'Publishing [_1]...' => '[_1] を再構築中...',
	'Publishing [_1] [_2]...' => '[_1] [_2] を再構築中...',
	'Publishing [_1] dynamic links...' => '[_1] のダイナミックリンクを再構築中...',
	'Publishing [_1] archives...' => '[_1]アーカイブを再構築中...',
	'Publishing [_1] templates...' => '[_1]テンプレートを再構築中...',
	'[_1]% Complete' => '処理済:[_1]%',

## tmpl/cms/recover_password_result.tmpl
	'Recover Passwords' => 'パスワード再設定',
	'No users were selected to process.' => 'ユーザーが選択されていません。',
	'Return' => '戻る',

## tmpl/cms/refresh_results.tmpl
	'Template Refresh' => 'テンプレートの初期化',
	'No templates were selected to process.' => 'テンプレートが選択されていません。',
	'Return to templates' => 'テンプレートに戻る',

## tmpl/cms/restore.tmpl
	'Restore from a Backup' => 'バックアップの復元',
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'バックアップと復元をするために必要なPerlモジュール(XML::SAXおよび依存モジュール)が見つかりません。',
	'Backup File' => 'バックアップファイル',
	'If your backup file is located on a remote computer, you can upload it here.  Otherwise, Movable Type will automatically look in the \'import\' folder within your Movable Type directory.' => 'バックアップファイルをアップロードします。アップロードがない場合は、Movable Typeは自動で \'import\'フォルダをチェックします。',
	'Check this and files backed up from newer versions can be restored to this system.  NOTE: Ignoring Schema Version can damage Movable Type permanently.' => 'チェックすると現在のシステムより新しいシステムからバックアップされたデータをこのシステムに復元できます。注意: バージョンの衝突を無視すると、Movable Typeのシステムに回復不可能なダメージを与える可能性があります。',
	'Ignore schema version conflicts' => 'バージョンの衝突を無視する',
	'Allow existing global templates to be overwritten by global templates in the backup file.' => 'バックアップ内のファイルで、グローバルテンプレートを上書きする。',
	'Overwrite global templates.' => 'グローバルテンプレートを上書きする',
	'Restore (r)' => '復元',

## tmpl/cms/restore_end.tmpl
	'Make sure that you remove the files that you restored from the \'import\' folder, so that if/when you run the restore process again, those files will not be re-restored.' => '再度復元を行う際に同じファイルから復元しないよう、importフォルダからファイルを削除してください。',
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => '復元の過程でエラーが発生しました。[_1] 詳細についてはログを確認してください。',

## tmpl/cms/restore_start.tmpl
	'Restoring Movable Type' => '復元を開始',

## tmpl/cms/search_replace.tmpl
	'You must select one or more item to replace.' => '置き換えるアイテムを1つ以上選択してください。',
	'Search Again' => '再検索',
	'Case Sensitive' => '大文字/小文字を区別する',
	'Regex Match' => '正規表現',
	'Limited Fields' => '項目を指定する',
	'Date Range' => '日付範囲',
	'Reported as Spam?' => 'スパムコメント/トラックバック',
	'Search Fields:' => '検索対象フィールド:',
	'_DATE_FROM' => '開始日',
	'_DATE_TO' => '終了日',
	'Submit search (s)' => '検索 (s)',
	'Replace' => '置換',
	'Replace Checked' => '選択したものを対象に置換',
	'Successfully replaced [quant,_1,record,records].' => '[quant,_1,件,件]のデータを置き換えました。',
	'Showing first [_1] results.' => '最初の[_1]件の結果を表示します。',
	'Show all matches' => 'すべて見る',
	'[quant,_1,result,results] found' => '[quant,_1,件,件]見つかりました。',

## tmpl/cms/setup_initial_website.tmpl
	'Create Your First Website' => '最初のウェブサイトを作成',
	'In order to properly publish your website, you must provide Movable Type with your website\'s URL and the filesystem path where its files should be published.' => 'ウェブサイトを構築するには、ウェブサイトURLとファイルパスが正しく設定しなければなりません。',
	'My First Website' => 'First Website',
	'The \'Website Root\' is the directory in your web server\'s filesystem where Movable Type will publish the files for your website. The web server must have write access to this directory.' => '\'ウェブサイトパス\'はウェブサーバーがウェブサイトの構築時に使うディレクトリです。ディレクトリにはウェブサーバーの書き込み権限が必要です。',
	'Theme' => 'テーマ',
	'Select the theme you wish to use for this new website.' => '新しいウェブサイトで利用するテーマを選んでください。',
	'Finish install (s)' => 'インストール (s)',
	'Finish install' => 'インストール',
	'Back (x)' => '戻る (x)',
	'The website name is required.' => 'ウェブサイト名は必須です。',
	'The website URL is required.' => 'ウェブサイトURLは必須です。',
	'The publishing path is required.' => 'ブログのサイトパスは必須です。',
	'The timezone is required.' => 'タイムゾーンは必須です。',

## tmpl/cms/system_check.tmpl
	'User Counts' => 'ユーザー数',
	'Number of users registered in this system.' => 'システムに登録されているユーザー数',
	'Total Users' => '全ユーザー数',
	'Memcache Status' => 'Memcacheの状態',
	'Memcache is [_1].' => 'Memcacheは[_1]です。',
	'Memcache Server is [_1].' => 'Memcacheサーバーは[_1]です。',
	'Server Model' => 'サーバーモデル',
	'Movable Type could not find the script named \'mt-check.cgi\'. To resolve this issue, ensure that the mt-check.cgi script exists and that the CheckScript configuration parameter (if it is necessary) references it properly.' => 'mt-check.cgiが見つかりませんでした。mt-check.cgiが存在すること、名前を変えた場合は構成ファイルのCheckScriptディレクティブに名前を指定してください。',

## tmpl/cms/theme_export_replace.tmpl
	'Export theme folder already exists \'[_1]\'. You can overwrite a existing theme, or cancel to change the Basename?' => 'テーマをエクスポートするフォルダ([_1])は既に存在します。上書き保存するか、キャンセルして出力ファイル名を変更してください。',
	'Overwrite' => '上書き保存',

## tmpl/cms/upgrade.tmpl
	'Time to Upgrade!' => 'アップグレード開始',
	'Upgrade Check' => 'アップグレードのチェック',
	'Do you want to proceed with the upgrade anyway?' => 'アップグレードを実行しますか?',
	'A new version of Movable Type has been installed.  We\'ll need to complete a few tasks to update your database.' => '新しいバージョンの Movable Type をインストールしました。データベースのアップグレードを実行してください。',
	'The Movable Type Upgrade Guide can be found <a href=\'[_1]\' target=\'_blank\'>here</a>.' => 'Movable Typeアップグレードガイドは<a href=\'http://www.movabletype.jp/documentation/upgrade/\' target=\'_blank\'>こちらを</a>参照ください。',
	'In addition, the following Movable Type components require upgrading or installation:' => '加えて、以下のコンポーネントのアップグレード、またはインストールが必要です。',
	'The following Movable Type components require upgrading or installation:' => '以下のコンポーネントのアップグレード、またはインストールが必要です。',
	'Begin Upgrade' => 'アップグレード開始',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Movable Type [_1]へのアップグレードを完了しました。',
	'Return to Movable Type' => 'Movable Type に戻る',
	'Your Movable Type installation is already up to date.' => 'Movable Type は最新版です。',

## tmpl/cms/upgrade_runner.tmpl
	'Initializing database...' => 'データベースの初期化中･･･',
	'Upgrading database...' => 'データベースをアップグレードしています･･･',
	'Error during installation:' => 'インストール中にエラーが発生しました',
	'Error during upgrade:' => 'アップグレード中にエラーが発生しました',
	'Return to Movable Type (s)' => 'Movable Typeに戻る (s)',
	'Your database is already current.' => 'データベースは最新の状態です。',
	'Installation complete!' => 'インストールを完了しました！',
	'Upgrade complete!' => 'アップグレードを完了しました！',

## tmpl/cms/view_log.tmpl
	'The activity log has been reset.' => 'ログをリセットしました。',
	'All times are displayed in GMT[_1].' => '時刻はすべてGMT[_1]です。',
	'All times are displayed in GMT.' => '時刻はすべてGMTです。',
	'Show only errors' => 'エラーだけを表示',
	'System Activity Log' => 'システムログ',
	'Filtered' => 'フィルタ',
	'Filtered Activity Feed' => 'フィルタしたフィード',
	'Download Filtered Log (CSV)' => 'フィルタしたログをダウンロード(CSV)',
	'Download Log (CSV)' => 'ログをダウンロード(CSV)',
	'Clear Activity Log' => 'ログを消去',
	'Are you sure you want to reset the activity log?' => 'ログを消去してもよろしいですか?',
	'Showing all log records' => 'すべてのログレコードを表示',
	'Showing log records where' => 'ログレコード',
	'Show log records where' => 'ログレコードの',
	'level' => 'レベル',
	'classification' => '分類',
	'Security' => 'セキュリティ',
	'Information' => '情報',
	'Debug' => 'デバッグ',
	'Security or error' => 'セキュリティまたはエラー',
	'Security/error/warning' => 'セキュリティ/エラー/警告',
	'Not debug' => 'デバッグを含まない',
	'Debug/error' => 'デバッグ/エラー',

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Schwartzエラーログ',
	'Showing all Schwartz errors' => '全Schwartzエラー参照',

## tmpl/cms/widget/blog_stats.tmpl
	'Error retrieving recent entries.' => '最近のブログ記事を取得できませんでした。',
	'Loading recent entries...' => '最近のブログ記事を読み込んでいます...',
	'Jan.' => '1月',
	'Feb.' => '2月',
	'July.' => '7月',
	'Aug.' => '8月',
	'Sept.' => '9月',
	'Oct.' => '10月',
	'Nov.' => '11月',
	'Dec.' => '12月',
	'[_1] [_2] - [_3] [_4]' => '[_1][_2]日 - [_3][_4]',
	'You have <a href=\'[_3]\'>[quant,_1,comment,comments] from [_2]</a>' => '[_2]日に<a href=\'[_3]\'>[quant,_1,件,件]のコメント</a>があります。',
	'You have <a href=\'[_3]\'>[quant,_1,entry,entries] from [_2]</a>' => '[_2]日に<a href=\'[_3]\'>[quant,_1,件,件]のブログ記事</a>を作成しています。',

## tmpl/cms/widget/blog_stats_comment.tmpl
	'Most Recent Comments' => '最近のコメント',
	'[_1] [_2], [_3] on [_4]' => '[_3]「[_4]」[_1] [_2]',
	'View all comments' => 'すべてのコメントを表示',
	'No comments available.' => 'コメントはありません。',

## tmpl/cms/widget/blog_stats_entry.tmpl
	'Most Recent Entries' => '最近のブログ記事',
	'...' => '...',
	'Posted by [_1] [_2] in [_3]' => '[_2] [_1] カテゴリ: [_3]',
	'Posted by [_1] [_2]' => '[_2] [_1]',
	'Tagged: [_1]' => 'タグ: [_1]',
	'View all entries' => 'すべてのブログ記事を表示',
	'No entries have been created in this blog. <a href="[_1]">Create a entry</a>' => 'このブログには記事が見つかりません。<a href="[_1]">記事を作成</a>する。',

## tmpl/cms/widget/blog_stats_recent_entries.tmpl
	'[quant,_1,entry,entries] tagged &ldquo;[_2]&rdquo;' => 'タグ&ldquo;[_2]&rdquo;の付いたブログ記事([quant,_1,件,件])',
	'No entries available.' => 'ブログ記事がありません。',

## tmpl/cms/widget/blog_stats_tag_cloud.tmpl

## tmpl/cms/widget/custom_message.tmpl
	'This is you' => 'This is you',
	'Welcome to [_1].' => '[_1]へようこそ',
	'You can manage your blog by selecting an option from the menu located to the left of this message.' => 'このメッセージの左側のメニューでオプションを選択することでブログの管理ができます。',
	'If you need assistance, try:' => 'サポートが必要な場合は以下を参照してください。',
	'Movable Type User Manual' => 'Movable Type ユーザーマニュアル',
	'http://www.sixapart.com/movabletype/support' => 'http://www.sixapart.jp/movabletype/support',
	'Movable Type Technical Support' => 'Movable Type テクニカルサポート',
	'Movable Type Community Forums' => 'Movable Type コミュニティフォーラム',
	'Change this message.' => 'このメッセージを変更',
	'Edit this message.' => 'このメッセージを編集',

## tmpl/cms/widget/favorite_blogs.tmpl
	'Your recent websites and blogs' => '最近利用したウェブサイト/ブログ',
	'[quant,_1,blog,blogs]' => 'ブログ[quant,_1,件,件]',
	'[quant,_1,comment,comments]' => 'コメント[quant,_1,件,件]',
	'No website could be found. [_1]' => 'ウェブサイトがありません。[_1]',
	'Create a new' => '新規作成',
	'No blog could be found.' => 'ブログがありません。',

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'ニュース',
	'MT News' => 'MT ニュース',
	'Learning MT' => 'Learning MT',
	'Hacking MT' => 'Hacking MT',
	'Pronet' => 'ProNet',
	'No Movable Type news available.' => 'Movable Typeニュースはありません。',
	'No Learning Movable Type news available.' => 'Learning Movable Typeに新着ブログ記事はありません。',

## tmpl/cms/widget/mt_shortcuts.tmpl
	'Handy Shortcuts' => 'ショートカット',
	'Import Content' => 'インポート',
	'Blog Preferences' => 'ブログの設定',

## tmpl/cms/widget/new_install.tmpl
	'Thank you for installing Movable Type' => 'Movable Type をご利用いただき、ありがとうございます。',
	'You are now ready to:' => '次の方法で、ウェブサイトにコンテンツを公開できます。',
	'Create a new page on your website' => 'ウェブサイトに新しいページを作成',
	'Create a blog on your website' => 'ウェブサイトにブログを作成',
	'Create a blog (many blogs can exist in one website) to start posting.' => 'ブログを作成して(ひとつのウェブサイト内に複数のブログを作成できます)、ブログ記事を投稿します。',

## tmpl/cms/widget/new_user.tmpl
	'Welcome to Movable Type, the world\'s most powerful blogging, publishing and social media platform:' => '世界で最もパワフルなブログ、ウェブサイト、ソーシャルメディアプラットフォームであるMovable Typeへようこそ:',

## tmpl/cms/widget/new_version.tmpl
	'What\'s new in Movable Type [_1]' => 'Movable Type [_1] の新機能',

## tmpl/cms/widget/recent_blogs.tmpl
	'No blogs could be found. [_1]' => 'ブログがありません。[_1]',

## tmpl/cms/widget/recent_websites.tmpl

## tmpl/cms/widget/this_is_you.tmpl
	'Your <a href="[_1]">last entry</a> was [_2] in <a href="[_3]">[_4]</a>.' => '最後にブログ記事を書いたのは[_2]です(ブログ: <a href="[_3]">[_4]</a> - <a href="[_1]">編集</a>)。',
	'Your last entry was [_1] in <a href="[_2]">[_3]</a>.' => '最後にブログ記事を書いたのは[_1]です(ブログ: <a href="[_2]">[_3]</a>)',
	'You have <a href="[_1]">[quant,_2,draft,drafts]</a>.' => '下書きが<a href="[_1]">[quant,_2,件,件]</a>あります。',
	'You have [quant,_1,draft,drafts].' => '下書きが[quant,_1,件,件]あります。',
	'You\'ve written <a href="[_1][_2]">[quant,_3,entry,entries]</a>, <a href="[_1][_4]">[quant,_5,page,pages]</a> with <a href="[_1][_6]">[quant,_7,comment,comments]</a>.' => '記事が<a href="[_1][_2]">[quant,_3,件,件]</a>、ページが<a href="[_1][_4]">[quant,_5,件,件]</a>、コメントが<a href="[_1][_6]">[quant,_7,件,件]</a>あります。',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, <a href="[_3]">[quant,_4,page,pages]</a> with [quant,_5,comment,comments].' => '記事が<a href="[_1]">[quant,_2,件,件]</a>、ページが<a href="[_3]">[quant,_4,件,件]</a>、コメント[quant,_5,件,件]あります。',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages] with <a href="[_4]">[quant,_5,comment,comments]</a>.' => '記事が<a href="[_1]">[quant,_2,件,件]</a>、ページが[quant,_3,件,件]、コメントが<a href="[_4]">[quant,_5,件,件]</a>あります。',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages] with [quant,_4,comment,comments].' => '記事が<a href="[_1]">[quant,_2,件,件]</a>、ページが[quant,_3,件,件]、コメントが[quant,_4,件,件]あります。',
	'You\'ve written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a> with <a href="[_4]">[quant,_5,comment,comments]</a>.' => '記事が[quant,_1,件,件]、ページが<a href="[_2]">[quant,_3,件,件]</a>、コメントが<a href="[_4]">[quant,_5,件,件]</a>あります。',
	'You\'ve written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a> with [quant,_4,comment,comments].' => '記事が[quant,_1,件,件]、ページが<a href="[_2]">[quant,_3,件,件]</a>、コメント[quant,_4,件,件]あります。',
	'You\'ve written [quant,_1,entry,entries], [quant,_2,page,pages] with <a href="[_3]">[quant,_4,comment,comments]</a>.' => '記事が[quant,_1,件,件]、ページが[quant,_2,件,件]、コメントが<a href="[_3]">[quant,_4,件,件]</a>あります。',
	'You\'ve written [quant,_1,entry,entries], [quant,_2,page,pages] with [quant,_3,comment,comments].' => '記事[quant,_1,件,件], ページ[quant,_2,件,件] コメント[quant,_3,件,件]あります。',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, <a href="[_3]">[quant,_4,page,pages]</a>.' => '記事が<a href="[_1]">[quant,_2,件,件]</a>、ページが<a href="[_3]">[quant,_4,件,件]</a>あります。',
	'You\'ve written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages].' => '記事が<a href="[_1]">[quant,_2,件,件]</a>、ページが[quant,_3,件,件]あります。',
	'You\'ve written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a>.' => '記事が[quant,_1,entry,entries]、ページが<a href="[_2]">[quant,_3,件,件]</a>あります。',
	'You\'ve written [quant,_1,entry,entries], [quant,_2,page,pages].' => '記事が[quant,_1,件,件]、ページが[quant,_2,件,件]あります。',
	'You\'ve written <a href="[_1]">[quant,_2,page,pages]</a> with <a href="[_3]">[quant,_4,comment,comments]</a>.' => 'ページが<a href="[_1]">[quant,_2,件,件]</a>、コメントが<a href="[_3]">[quant,_4,件,件]</a>あります。',
	'You\'ve written <a href="[_1]">[quant,_2,page,pages]</a> with [quant,_3,comment,comments].' => 'ページが<a href="[_1]">[quant,_2,件,件]</a>、コメントが[quant,_3,件,件]あります。',
	'You\'ve written [quant,_1,page,pages] with <a href="[_2]">[quant,_3,comment,comments]</a>.' => 'ページが[quant,_1,件,件]、コメントが<a href="[_2]">[quant,_3,件,件]</a>あります。',
	'You\'ve written [quant,_1,page,pages] with [quant,_2,comment,comments].' => 'ページが[quant,_1,件,件]、コメントが[quant,_2,件,件]あります。',
	'Edit your profile' => 'ユーザー情報の編集',

## tmpl/comment/auth_aim.tmpl
	'Your AIM or AOL Screen Name' => 'AIMまたはAOLのスクリーンネーム',
	'Sign in using your AIM or AOL screen name. Your screen name will be displayed publicly.' => 'AIMまたはAOLのスクリーンネームでサインインします。スクリーンネームは公開されます。',

## tmpl/comment/auth_googleopenid.tmpl
	'Sign in using your Gmail account' => 'Gmailのアカウントでログインする',
	'Sign in to Movable Type with your[_1] Account[_2]' => '[_1] アカウント[_2]',

## tmpl/comment/auth_hatena.tmpl
	'Your Hatena ID' => 'はてなID',

## tmpl/comment/auth_livedoor.tmpl

## tmpl/comment/auth_livejournal.tmpl
	'Your LiveJournal Username' => 'あなたのLiveJournalのユーザー名',
	'Learn more about LiveJournal.' => 'LiveJournalについて詳しくはこちら',

## tmpl/comment/auth_openid.tmpl
	'OpenID URL' => 'あなたのOpenID URL',
	'Sign in using your OpenID identity.' => 'あなたのOpenID',
	'Sign in with one of your existing third party OpenID accounts.' => 'すでに登録済みの、OpenIDに対応した別サービスのアカウントでサインインします。',
	'http://www.openid.net/' => 'http://www.sixapart.jp/about/openid/',
	'Learn more about OpenID.' => 'OpenIDについて詳しくはこちら',

## tmpl/comment/auth_typepad.tmpl
	'TypePad is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.' => 'TypePadはブログにコメントを投稿したり他のウェブサイトにログインするときに使える、フリーでオープンな認証システムを提供します。',
	'Sign in or register with TypePad.' => 'TypePadでサインイン、またはアカウントを登録する',

## tmpl/comment/auth_vox.tmpl
	'Your Vox Blog URL' => 'Vox',
	'Learn more about Vox.' => 'Voxについて詳しくはこちら',

## tmpl/comment/auth_wordpress.tmpl
	'Your Wordpress.com Username' => 'Wordpress.comのユーザー名',
	'Sign in using your WordPress.com username.' => 'Wordpress.comのユーザー名でサインインします。',

## tmpl/comment/auth_yahoo.tmpl
	'Turn on OpenID for your Yahoo! account now' => 'Yahoo!のアカウントをOpenIDにする',

## tmpl/comment/auth_yahoojapan.tmpl
	'Turn on OpenID for your Yahoo! Japan account now' => 'Yahoo! JAPANのOpenIDを取得してください。',

## tmpl/comment/error.tmpl
	'Go Back (s)' => '戻る (s)',

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'サインインしてください',
	'Sign in using' => 'サインイン',
	'Not a member? <a href="[_1]">Sign Up</a>!' => 'アカウントがないときは<a href="[_1]">サインアップ</a>してください。',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'ユーザー情報',
	'Your login name.' => 'あなたのログイン名です。',
	'The name appears on your comment.' => 'あなたのコメントに表示される名前です。',
	'Your email address.' => 'あなたのメールアドレスです。',
	'Select a password for yourself.' => 'パスワード選択してください。',
	'The URL of your website. (Optional)' => 'あなたのウェブサイトのURLです。(オプション)',
	'Return to the <a href="[_1]">original page</a>.' => '<a href="[_1]">元のページ</a>に戻る',

## tmpl/comment/register.tmpl
	'Create an account' => 'アカウントを作成する',
	'Register' => '登録する',

## tmpl/comment/signup.tmpl
	'Password Confirm' => 'パスワード再入力',

## tmpl/comment/signup_thanks.tmpl
	'Thanks for signing up' => 'ご登録ありがとうございます。',
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'コメントを投稿する前にアカウントを確認して登録を完了する必要があります。[_1]にメールを送信しました。',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => '登録を完了するためにまずアカウントを確認する必要があります。[_1]にメールを送信しました。',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'メールを確認して、メールに書かれたリンクをクリックすることで、アカウントを確認して有効化できます。',
	'Return to the original entry.' => '元のブログ記事に戻る',
	'Return to the original page.' => '元のウェブページに戻る',

## tmpl/error.tmpl
	'Missing Configuration File' => '環境設定ファイルが見つかりません。',
	'_ERROR_CONFIG_FILE' => 'Movable Type の環境設定ファイルが存在しないか、または読み込みに失敗しました。詳細については、Movable Type マニュアルの<a href="javascript:void(0)">インストールと設定</a>の章を確認してください。',
	'Database Connection Error' => 'データベースへの接続でエラーが発生しました。',
	'_ERROR_DATABASE_CONNECTION' => '環境設定ファイルのデータベース設定に問題があるか、または設定がありません。詳細については、Movable Type マニュアルの<a href="javascript:void(0)">インストールと設定</a>の章を確認してください。',
	'CGI Path Configuration Required' => 'CGIPath の設定が必要です。',
	'_ERROR_CGI_PATH' => '環境設定ファイルの CGIPath の項目の設定に問題があるか、または設定がありません。詳細については、Movable Type マニュアルの<a href="javascript:void(0)">インストールと設定</a>の章を確認してください。',

## tmpl/feeds/error.tmpl
	'Movable Type Activity Log' => 'Movable Type システムログ',

## tmpl/feeds/feed_comment.tmpl
	'More like this' => '他にも...',
	'From this blog' => 'このブログから',
	'On this entry' => 'このブログ記事に対する',
	'By commenter identity' => 'コメント投稿者のID',
	'By commenter name' => 'コメント投稿者の名前',
	'By commenter email' => 'コメント投稿者のメールアドレス',
	'By commenter URL' => 'コメント投稿者のURL',
	'On this day' => 'この日付から',

## tmpl/feeds/feed_entry.tmpl
	'From this author' => 'このユーザーから',

## tmpl/feeds/feed_page.tmpl

## tmpl/feeds/feed_ping.tmpl
	'Source blog' => '送信元のブログ',
	'By source blog' => '送信元のブログ',
	'By source title' => '送信元ブログ記事のタイトル',
	'By source URL' => '送信元のURL',

## tmpl/feeds/login.tmpl
	'This link is invalid. Please resubscribe to your activity feed.' => 'このリンクは無効です。フィードの購読をやり直してください。',

## tmpl/include/chromeless_header.tmpl

## tmpl/wizard/blog.tmpl
	'Setup Your First Blog' => 'First Blogのセットアップ',
	'In order to properly publish your blog, you must provide Movable Type with your blog\'s URL and the path on the filesystem where its files should be published.' => 'ブログを公開するためのURLと、公開されるファイルのパスを設定する必要があります。',
	'My First Blog' => 'My First Blog',
	'Publishing Path' => '公開パス',
	'Your \'Publishing Path\' is the path on your web server\'s file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.' => 'Movable Typeは、出力するすべてのファイルを「公開パス」以下に配置します。このディレクトリにはWebサーバーから書き込みできなければなりません。',

## tmpl/wizard/cfg_dir.tmpl
	'Temporary Directory Configuration' => 'テンポラリディレクトリの設定',
	'You should configure you temporary directory settings.' => 'テンポラリディレクトリの場所を指定してください。',
	'Your TempDir has been successfully configured. Click \'Continue\' below to continue configuration.' => 'TempDirを設定しました。次へボタンをクリックして先に進んでください。',
	'[_1] could not be found.' => '[_1]が見つかりませんでした。',
	'TempDir is required.' => 'TempDirが必要です。',
	'TempDir' => 'TempDir',
	'The physical path for temporary directory.' => 'TempDirへの物理パスを指定します。',

## tmpl/wizard/complete.tmpl
	'Configuration File' => '構成ファイル',
	'The [_1] configuration file can\'t be located.' => '[_1]の構成ファイルを作成できませんでした。',
	'Please use the configuration text below to create a file named \'mt-config.cgi\' in the root directory of [_1] (the same directory in which mt.cgi is found).' => '以下のテキストを利用して、mt-config.cgiという名前のファイルを[_1]のルートディレクトリ(mt.cgiがあるディレクトリ)に配置してください。',
	'The wizard was unable to save the [_1] configuration file.' => '[_1]の構成ファイルを保存できませんでした。',
	'Confirm that your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click \'Retry\'.' => '[_1]ディレクトリ(mt.cgiを含んでいる場所)がウェブサーバーによって書き込めるか確認して、\'再実行\'をクリックしてください。',
	'Congratulations! You\'ve successfully configured [_1].' => '[_1]の設定を完了しました。',
	'Your configuration settings have been written to the following file:' => '設定内容を以下のファイルに書き込みました。',
	'To change the settings, click the \'Back\' button below.' => '設定を変更する場合は、以下の\'戻る\'ボタンをクリックしてください。',
	'Show the mt-config.cgi file generated by the wizard' => 'ウィザードで作成されたmt-config.cgiを表示する',
	'The mt-config.cgi file has been created manually.' => 'mt-config.cgiを手動で作成しました。',
	'Retry' => '再試行',

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'データベース設定',
	'Your database configuration is complete.' => 'データベースの設定を完了しました。',
	'You may proceed to the next step.' => '次のステップへ進みます。',
	'Show Current Settings' => '現在の設定を表示',
	'Please enter the parameters necessary for connecting to your database.' => 'データベース接続に必要な情報を入力してください。',
	'Database Type' => 'データベースの種類',
	'Select One...' => '選択してください',
	'http://www.movabletype.org/documentation/[_1]' => 'http://www.movabletype.jp/documentation/[_1]',
	'Is your preferred database not listed? View the <a href="[_1]" target="_blank">Movable Type System Check</a> see if additional modules are necessary.' => '<a href="[_1]" target="_blank">Movable Type システムチェック</a>を実行して、必要なモジュールを確認してください。',
	'Once installed, <a href="javascript:void(0)" onclick="[_1]">click here to refresh this screen</a>.' => 'モジュールをインストールしたら<a href="javascript:void(0)" onclick="[_1]">ここをクリック</a>して表示を更新してください。',
	'Read more: <a href="[_1]" target="_blank">Setting Up Your Database</a>' => '詳しくは<a href="[_1]" target="_blank">こちら</a>を参照してください。',
	'Show Advanced Configuration Options' => '高度な設定',
	'Test Connection' => '接続テスト',
	'You must set your Database Path.' => 'データベースのパスを設定します。',
	'You must set your Username.' => 'データベースのユーザー名を設定します。',
	'You must set your Database Server.' => 'データベースサーバを設定します。',

## tmpl/wizard/optional.tmpl
	'Mail Configuration' => 'メール設定',
	'Your mail configuration is complete.' => 'メール設定を完了しました。',
	'Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.' => 'Movable Typeからのテストメールを受信したことを確認して、次のステップへ進んでください。',
	'Show current mail settings' => '現在のメール設定を表示',
	'Periodically Movable Type will send email for password recovery, to inform authors of new comments, and other events. If not using Sendmail (default on unix servers), an SMTP Server must be specified.' => 'Movable Typeはパスワードの再設定や、新しいコメントの通知などをメールでお知らせします。これらのメールが正しく送信されるよう設定してください。',
	'An error occurred while attempting to send mail: ' => 'メール送信の過程でエラーが発生しました。',
	'Send email via:' => 'メール送信プログラム',
	'sendmail Path' => 'sendmailのパス',
	'The physical file path for your sendmail binary.' => 'sendmailへの物理パスを指定します。',
	'Outbound Mail Server (SMTP)' => '送信メールサーバー(SMTP)',
	'Address of your SMTP Server.' => 'SMTPサーバーのアドレスを指定します。',
	'Mail address to which test email should be sent' => 'テストメールが送られるメールアドレス',
	'From mail address' => '送信元メールアドレス',

## tmpl/wizard/packages.tmpl
	'Requirements Check' => 'システムチェック',
	'The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your blog\'s data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the \'Retry\' button.' => 'データベース接続のための以下のPerlモジュールが必要です。Movable Typeはブログのデータを保存するためにデータベースを使用します。この一覧のパッケージのいずれかをインストールしてください。準備ができたら「再試行」のボタンをクリックしてください。',
	'All required Perl modules were found.' => '必要なPerlモジュールは揃っています。',
	'You are ready to proceed with the installation of Movable Type.' => 'Movable Typeのインストールを続行する準備が整いました。',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'オプションのPerlモジュールのうちいくつかが見つかりませんでした。<a href="javascript:void(0)" onclick="[_1]">オプションモジュールを表示</a>',
	'One or more Perl modules required by Movable Type could not be found.' => 'ひとつ以上の必須Perlモジュールが見つかりませんでした。',
	'The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the \'Retry\' button to re-test for these packages.' => '以下のPerlモジュールはMovable Typeの正常な動作に必要です。必要なモジュールは「再試行」ボタンをクリックすることで確認できます。',
	'Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click \'Retry\' to test for the modules again.' => 'オプションのPerlモジュールのうちいくつかが見つかりませんでしたが、インストールはこのまま続行できます。オプションのPerlモジュールは、必要な場合にいつでもインストールできます。',
	'Missing Database Modules' => 'データベースモジュールが見つかりません',
	'Missing Optional Modules' => 'オプションのモジュールが見つかりません',
	'Missing Required Modules' => '必要なモジュールが見つかりません',
	'Minimal version requirement: [_1]' => '必須バージョン: [_1]',
	'http://www.movabletype.org/documentation/installation/perl-modules.html' => 'http://www.movabletype.jp/documentation/check_configuration.html',
	'Learn more about installing Perl modules.' => 'Perlモジュールのインストールについて',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'すべての必要なモジュールはインストールされています。モジュールの追加インストールは必要ありません。',

## tmpl/wizard/start.tmpl
	'Configuration File Exists' => '構成ファイルが見つかりました',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'ブラウザのJavaScriptを有効にする必要があります。続けるにはブラウザのJavaScriptを有効にし、このページの表示を更新してください。',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'このウィザードでは、Movable Typeを利用するために必要となる基本的な環境設定を行います。',
	'Default language.' => '既定の使用言語',
	'<strong>Error: \'[_1]\' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.' => 'エラー: \'[_1]\'が見つかりませんでした。ファイルをmt-staticディレクトリに移動するか、設定を修正してください。',
	'Configure Static Web Path' => 'スタティックウェブパスの設定',
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Typeには、[_1]ディレクトリが標準で含まれています。この中には画像ファイルやJavaScript、スタイルシートなどの重要なファイルが含まれています。',
	'The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server\'s configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).' => '[_1]ディレクトリは、Movable Typeのメインディレクトリ(このウィザード自身も含まれている)以下で見つかりました。しかし現在のサーバーの構成上、その場所にはWebブラウザからアクセスできません。ウェブサイトのルートディレクトリの下など、Webブラウザからアクセスできる場所に移動してください。',
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'mt-static ディレクトリはMovable Typeのインストールディレクトリの外部に移動されたかまたは名前が変更されているようです。',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => '[_1]ディレクトリをウェブアクセス可能な場所に置く場合には、以下にその場所を指定してください。',
	'This URL path can be in the form of [_1] or simply [_2]' => 'このURLは[_1]のように記述するか、または簡略化して[_2]のように記述できます。',
	'This path must be in the form of [_1]' => 'このパスは[_1]のように記述してください。',
	'Static web path' => 'スタティックウェブパス',
	'Static file path' => 'スタティックファイルパス',
	'Begin' => '開始',
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => '構成ファイル(mt-config.cgi)はすでに存在します。Movable Typeに<a href="[_1]">サインイン</a>してください。',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'ウィザードで新しく構成ファイルを作るときは、現在の構成ファイルを別の場所に移動してこのページを更新してください。',

## plugins/Markdown/Markdown.pl
	'A plain-text-to-HTML formatting plugin.' => 'テキストをHTMLに整形するプラグインです。',
	'Markdown' => 'Markdown',
	'Markdown With SmartyPants' => 'Markdown + SmartyPants',

## plugins/Markdown/SmartyPants.pl
	'Easily translates plain punctuation characters into \'smart\' typographic punctuation.' => '記号を「スマート」に置き換えます。',

## plugins/MultiBlog/lib/MultiBlog.pm
	'The include_blogs, exclude_blogs, blog_ids and blog_id attributes cannot be used together.' => 'include_blogs、exclude_blogs、blog_ids、そしてblog_id属性は一緒に使えません。',
	'The value of the blog_id attribute must be a single blog ID.' => 'blog_id属性にはブログIDをひとつしか指定できません。',
	'The value for the include_blogs/exclude_blogs attributes must be one or more blog IDs, separated by commas.' => 'include_blogs/exclude_blogs属性はカンマで区切ったひとつ以上のIDを設定できます。',
	'Restoring MultiBlog rebuild trigger for blog #[_1]...' => 'マルチブログの再構築により、てブログ(#[_1])をリストアしています...',

## plugins/MultiBlog/lib/MultiBlog/Tags.pm
	'MTMultiBlog tags cannot be nested.' => 'MTMultiBlogタグは入れ子にできません。',
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'mode属性が不正です。loopまたはcontextを指定してください。',

## plugins/MultiBlog/multiblog.pl
	'MultiBlog allows you to publish content from other blogs and define publishing rules and access controls between them.' => 'MultiBlogを使うと他のブログのコンテンツを公開したりブログ同士での公開ルールの設定やアクセス制限を行うことができます。',
	'MultiBlog' => 'マルチブログ',
	'Create Trigger' => 'トリガーを作成',
	'Search Weblogs' => 'ブログ検索',
	'When this' => 'トリガー:',
	'* All blogs in this website' => '* ウェブサイト内のすべてのブログ',
	'Select to apply this trigger to all blogs in this website.' => 'ウェブサイト内のすべてのブログでトリガーを有効にする。',
	'* All websites and blogs in this system' => '* システム内のすべてのウェブサイトとブログ',
	'Select to apply this trigger to all websites and blogs in this system.' => 'システム内のすべてのウェブサイトとブログでトリガーを有効にする。',
	'saves an entry/page' => 'ブログ記事とウェブページの保存時',
	'publishes an entry/page' => 'ブログ記事とウェブページの公開時',
	'publishes a comment' => 'コメントの公開時',
	'publishes a TrackBack' => 'トラックバックの公開時',
	'rebuild indexes.' => 'インデックスを再構築する',
	'rebuild indexes and send pings.' => 'インデックスを再構築して更新情報を送信する',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => ' ',
	'Weblog' => 'ブログ',
	'Trigger' => 'トリガー',
	'Action' => 'アクション',
	'Content Privacy' => 'コンテンツのセキュリティ',
	'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => '同じMovable Type内の他のブログがこのブログのコンテンツを公開できるかどうかを指定します。この設定はシステムレベルのMultiBlogの構成で指定された既定のアグリゲーションポリシーよりも優先されます。',
	'Use system default' => 'システムの既定値を使用',
	'Allow' => '許可',
	'Disallow' => '許可しない',
	'MTMultiBlog tag default arguments' => 'MTMultiBlogタグの既定の属性:',
	'Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or \'all\' (include_blogs only) are acceptable values.' => 'include_blogs/exclude_blogs属性なしでMTMultiBlogタグを使用できるようにします。カンマで区切ったブログID、または「all」(include_blogs のみ)が指定できます。',
	'Include blogs' => '含めるブログ',
	'Exclude blogs' => '除外するブログ',
	'Rebuild Triggers' => '再構築トリガー',
	'Create Rebuild Trigger' => '再構築トリガーを作成',
	'You have not defined any rebuild triggers.' => '再構築トリガーを設定していません。',

## plugins/MultiBlog/tmpl/dialog_create_trigger.tmpl
	'Create MultiBlog Trigger' => 'MultiBlog トリガーの作成',

## plugins/MultiBlog/tmpl/system_config.tmpl
	'Default system aggregation policy' => '既定のアグリゲーションポリシー',
	'Cross-blog aggregation will be allowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to restrict access to their content by other blogs.' => 'ブログをまたがったアグリゲーションが既定で許可されます。個別のブログレベルでのMultiBlogの設定で他のブログからのコンテンツへのアクセスを制限できます。',
	'Cross-blog aggregation will be disallowed by default.  Individual blogs can be configured through the blog-level MultiBlog settings to allow access to their content by other blogs.' => 'ブログをまたがったアグリゲーションが既定で不許可になります。個別のブログレベルでのMultiBlogの設定で他のブログからのコンテンツへのアクセスを許可することもできます。',

## plugins/StyleCatcher/config.yaml
	'StyleCatcher lets you easily browse through styles and then apply them to your blog in just a few clicks.' => 'StyleCatcherを使うと、ウェブサイトやブログのスタイルを探して、数クリックで変更することができます。',
	'MT 4 Style Library' => 'MT 4 スタイルライブラリ',
	'A collection of styles compatible with Movable Type 4 default templates.' => 'Movable Type 4のデフォルトテンプレートと互換性のあるスタイルです。',
	'Styles' => 'スタイル',

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'mt-staticディレクトリが見つかりませんでした。StaticFilePathを設定してください。',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => '[_1] フォルダが作成できません。\'themes\' フォルダが書き込み可能か確認してください。',
	'Successfully applied new theme selection.' => '新しいテーマを適用しました。',
	'Invalid URL: [_1]' => 'URLが不正です: [_1]',
	'(Untitled)' => '(タイトルなし)',

## plugins/StyleCatcher/tmpl/view.tmpl
	'Select a [_1] Style' => '[_1]スタイルの選択',
	'3-Columns, Wide, Thin, Thin' => '3カラム、大・小・小',
	'3-Columns, Thin, Wide, Thin' => '3カラム、小・大・小',
	'3-Columns, Thin, Thin, Wide' => '3カラム、小・小・大',
	'2-Columns, Thin, Wide' => '2カラム、小・大',
	'2-Columns, Wide, Thin' => '2カラム、大・小',
	'2-Columns, Wide, Medium' => '2カラム、大・中',
	'2-Columns, Medium, Wide' => '2カラム、中・大',
	'1-Column, Wide, Bottom' => '1カラム、大、下',
	'None available' => '見つかりません',
	'Applying...' => '適用中...',
	'Apply Design' => 'デザインを適用',
	'Error applying theme: ' => 'テーマを適用中にエラーが発生しました。',
	'The selected theme has been applied, but as you have changed the layout, you will need to republish your blog to apply the new layout.' => 'テーマを適用しました。レイアウトも変更されたので、再構築する必要があります。',
	'The selected theme has been applied!' => 'テーマを適用しました。',
	'Error loading themes! -- [_1]' => 'テーマの読み込みでエラーが発生しました! -- [_1]',
	'Stylesheet or Repository URL' => 'スタイルシートまたはリポジトリのURL',
	'Stylesheet or Repository URL:' => 'スタイルシートまたはリポジトリのURL:',
	'Download Styles' => 'スタイルをダウンロード',
	'Current theme for your weblog' => '適用されているテーマ',
	'Current Style' => '現在のスタイル',
	'Locally saved themes' => '保存されているテーマ',
	'Saved Styles' => '保存されているスタイル',
	'Default Styles' => '既定のスタイル',
	'Single themes from the web' => 'その他のテーマ',
	'More Styles' => 'その他のスタイル',
	'Selected Design' => '選択されたデザイン',
	'Layout' => 'レイアウト',

## plugins/Textile/textile2.pl
	'A humane web text generator.' => 'テキストをHTMLに整形します。',
	'Textile 2' => 'Textile 2',

## plugins/TypePadAntiSpam/TypePadAntiSpam.pl
	'TypePad AntiSpam is a free service from Six Apart that helps protect your blog from comment and TrackBack spam. The TypePad AntiSpam plugin will send every comment or TrackBack submitted to your blog to the service for evaluation, and Movable Type will filter items if TypePad AntiSpam determines it is spam. If you discover that TypePad AntiSpam incorrectly classifies an item, simply change its classification by marking it as "Spam" or "Not Spam" from the Manage Comments screen, and TypePad AntiSpam will learn from your actions. Over time the service will improve based on reports from its users, so take care when marking items as "Spam" or "Not Spam."' => '<a href="http://antispam.typepad.jp/" target="_blank">TypePad AntiSpam</a>はSix Apartから無償で提供される、コメントとトラックバックスパムからあなたのブログを守るためのサービスです。TypePad AntiSpamプラグインは、あなたのブログに宛てられたすべてのコメントとトラックバックを、評価のためにサービスに送信し、TypePad AntiSpamがスパムであると判断した場合には、Movable Typeがそれをフィルタリングします。TypePad AntiSpamによる判定に誤りがあった場合は、コメントの一覧画面でそれをスパムにする、あるいはスパムではないと指定すれば、TypePad AntiSpamはそれを学習します。このようなユーザーからのレポートによってTypePad AntiSpamによる評価の精度がさらに高まります。そのため、アイテムをスパムにしたり、スパムから解除する場合には、少し気をつけてください。',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] for this blog, and [quant,_2,message,messages] system-wide.' => 'これまでのところ、TypePad AntiSpamはこのブログに対するスパムを[quant,_1,件,件]ブロックしました。システム全体では[quant,_2,件,件]ブロックしました。',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] system-wide.' => 'これまでのところ、TypePad AntiSpamはこのシステム全体に対するスパムを[quant,_1,件,件]ブロックしました。',
	'Failed to verify your TypePad AntiSpam API key: [_1]' => 'TypePad AntiSpam APIキーの検証に失敗しました: [_1]',
	'The TypePad AntiSpam API key provided is invalid.' => '不正なTypePad AntiSpam APIキーです。',
	'TypePad AntiSpam' => 'TypePad AntiSpam',

## plugins/TypePadAntiSpam/lib/MT/TypePadAntiSpam.pm
	'API key is a required parameter.' => 'APIキーを設定してください。',

## plugins/TypePadAntiSpam/tmpl/config.tmpl
	'Junk Score Weight' => 'スコアの重みづけ',
	'Least Weight' => '緩い',
	'Most Weight' => '厳しい',
	'Comments and TrackBacks receive a junk score between -10 (definitely spam) and +10 (definitely not spam). This setting allows you to control the weight of the TypePad AntiSpam rating relative to other filters you may have installed to help you filter comments and TrackBacks.' => 'コメントおよびトラックバックには-10(間違いなくスパム)から+10(スパムではありえない)までの範囲で点数が付けられます。この設定を変更すると、TypePad AntiSpamによる判定を、インストールされている他のスパムフィルタの判定との関連で高くしたり低くしたりすることで、コメントとトラックバックのスパムフィルタリングの設定を調整できます。',

## plugins/TypePadAntiSpam/tmpl/stats_widget.tmpl
	'Spam Blocked' => 'ブロックしたスパム',
	'on this blog' => 'ブログレベル',
	'on this system' => 'システム全体',

## plugins/TypePadAntiSpam/tmpl/system.tmpl
	'API Key' => 'APIキー',
	'To enable this plugin, you\'ll need a free TypePad AntiSpam API key. You can <strong>get your free API key at [_1]antispam.typepad.com[_2]</strong>. Once you have your key, return to this page and enter it in the field below.' => 'このプラグインを利用するには、TypePad AntiSpam APIキー(無償)が必要です。APIキーは<strong>[_1]antispam.typepad.com[_2]</strong>から無償で取得できます。取得したら、このページに戻ってキーを入力してください。詳しくは<a href="http://antispam.typepad.jp/info/how-to-get-api-key.html" target="_blank">こちら</a>。',
	'Service Host' => 'サービスのホスト',
	'The default service host for TypePad AntiSpam is api.antispam.typepad.com. You should only change this if you are using a different service that is compatible with the TypePad AntiSpam API.' => 'TypePad AntiSpamの既定のホストはapi.antispam.typepad.comです。TypePad AntiSpam APIと互換性を持つ他のサービスを利用する場合に限って、この設定を変更してください。',

## plugins/WXRImporter/WXRImporter.pl
	'Import WordPress exported RSS into MT.' => 'WordPressからエクスポートされたRSSをMTにインポートします。',
	'WordPress eXtended RSS (WXR)' => 'WordPress eXtended RSS (WXR)',
	'Download WP attachments via HTTP.' => 'WordPressのAttachmentをHTTP経由でダウンロードします。',

## plugins/WXRImporter/lib/WXRImporter/Import.pm

## plugins/WXRImporter/lib/WXRImporter/WXRHandler.pm
	'File is not in WXR format.' => 'WXRフォーマットではありません。',
	'Creating new tag (\'[_1]\')...' => 'タグ(\'[_1]\')を作成しています...',
	'Saving tag failed: [_1]' => 'タグを保存できませんでした: [_1]',
	'Duplicate asset (\'[_1]\') found.  Skipping.' => 'アイテム「[_1]」は既にインポートされているのでスキップします。',
	'Saving asset (\'[_1]\')...' => 'アイテム(\'[_1]\')を保存しています...',
	' and asset will be tagged (\'[_1]\')...' => 'アイテムにタグ([_1])を付けています...',
	'Duplicate entry (\'[_1]\') found.  Skipping.' => 'ブログ記事「[_1]」は既にインポートされているのでスキップします。',
	'Saving page (\'[_1]\')...' => 'ウェブページ(\'[_1]\')を保存しています...',

## plugins/WXRImporter/tmpl/options.tmpl
	'Before you import WordPress posts to Movable Type, we recommend that you <a href=\'[_1]\'>configure your blog\'s publishing paths</a> first.' => 'WordPressからMovable Typeへインポートする前に、まず<a href=\'[_1]\'>ブログ公開パスを設定</a>してください。',
	'Upload path for this WordPress blog' => 'WordPressブログのアップロードパス',
	'Replace with' => '置き換えるパス',
	'Download attachments' => 'Attachmentのダウンロード',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'WordPressのブログからAttachmentをダウンロードするには、cronなどの決められたタイミングでプログラムを実行する環境が必要です。',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'インポート中に、既存のWordPressで公開されているブログからAttachment（画像やファイル）をダウンロードします。',

## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Widget Manager version 1.1; このプラグインは、古いバージョンのWidget ManagerのデータをMovable Typeのコアへ統合してアップグレードするために提供されています。アップグレード以外の機能はありません。最新のMovable Typeへアップグレードし終わった後は、このプラグインを削除してください。',
	'Moving storage of Widget Manager [_2]...' => 'ウィジェット管理[_2]の格納場所を移動しています。...',

## plugins/spamlookup/lib/spamlookup.pm
	'Failed to resolve IP address for source URL [_1]' => 'ソースURL[_1]の解決に失敗しました。',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'ドメインのIPアドレス「[_2]」と送信元「[_1]」のIPアドレス「[_3]」が合致しないため、「未公開」にします。',
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'ドメインのIPアドレス「[_2]」と送信元「[_1]」のIPアドレス「[_3]」が合致しません',
	'No links are present in feedback' => 'リンクが含まれていない',
	'Number of links exceed junk limit ([_1])' => 'スパム - リンク数超過 (制限値:[_1])',
	'Number of links exceed moderation limit ([_1])' => '保留 - リンク数超過 (制限値:[_1])',
	'Link was previously published (comment id [_1]).' => '公開済みのリンク (コメントID:[_1])',
	'Link was previously published (TrackBack id [_1]).' => '公開済みのリンク (トラックバックID:[_1])',
	'E-mail was previously published (comment id [_1]).' => '公開済みのメールアドレス (コメントID: [_1])',
	'Word Filter match on \'[_1]\': \'[_2]\'.' => '\'[_1]\'がワードフィルタ一致: \'[_2]\'',
	'Moderating for Word Filter match on \'[_1]\': \'[_2]\'.' => 'ワードフィルタ\'[_1]\'にマッチしたため公開を保留しました: \'[_2]\'。',
	'domain \'[_1]\' found on service [_2]' => 'ドメイン\'[_1]\'一致(サービス: [_2])',
	'[_1] found on service [_2]' => 'サービス[_2]で[_1]が見つかりました。',

## plugins/spamlookup/spamlookup.pl
	'SpamLookup module for using blacklist lookup services to filter feedback.' => 'ブラックリストに対する問い合わせを行うSpamLookupモジュールです。',
	'SpamLookup IP Lookup' => 'SpamLookup IPアドレス検査',
	'SpamLookup Domain Lookup' => 'SpamLookup ドメイン検査',
	'SpamLookup TrackBack Origin' => 'SpamLookup トラックバック元検査',
	'Despam Comments' => 'コメントをスパムから解除する',
	'Despam TrackBacks' => 'トラックバックをスパムから解除する',
	'Despam' => 'スパム解除',

## plugins/spamlookup/spamlookup_urls.pl
	'SpamLookup module for junking and moderating feedback based on link filters.' => 'リンクの数による評価を行うSpamLookupモジュールです。',
	'SpamLookup Link Filter' => 'SpamLookup リンクフィルタ',
	'SpamLookup Link Memory' => 'SpamLookup リンクメモリ',
	'SpamLookup Email Memory' => 'SpamLookup メールメモリ',

## plugins/spamlookup/spamlookup_words.pl
	'SpamLookup module for moderating and junking feedback using keyword filters.' => 'キーワードによるコメントトラックバックの評価を行うSpamLookupモジュールです。',
	'SpamLookup Keyword Filter' => 'SpamLookup キーワードフィルタ',

## plugins/spamlookup/tmpl/lookup_config.tmpl
	'Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog\'s Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.' => 'LookupsはすべてのコメントとトラックバックについてIPアドレスとハイパーリンクを監視します。コメントやトラックバックの送信元のIPアドレスやドメイン名について、外部のブラックリストサービスに問い合わせを行います。そして、結果に応じて公開を保留するか、またはスパムしてゴミ箱に移動します。また、トラックバックの送信元の確認も実行できます。',
	'IP Address Lookups' => 'IPアドレスのルックアップ',
	'Moderate feedback from blacklisted IP addresses' => 'ブラックリストに含まれるIPアドレスからのコメントとトラックバックの公開を保留する',
	'Junk feedback from blacklisted IP addresses' => 'ブラックリストに含まれるIPアドレスからのコメントとトラックバックをスパムとして報告する',
	'Adjust scoring' => '評価の重みを調整',
	'Score weight:' => '評価の重み',
	'Less' => '以下',
	'More' => '以上',
	'block' => 'ブロック',
	'IP Blacklist Services' => 'IPブラックリストのサービス',
	'Domain Name Lookups' => 'ドメイン名のルックアップ',
	'Moderate feedback containing blacklisted domains' => 'ブラックリストに含まれるドメインからのコメントとトラックバックの公開を保留する',
	'Junk feedback containing blacklisted domains' => 'ブラックリストに含まれるドメインからのコメントとトラックバックをスパムとして報告する',
	'Domain Blacklist Services' => 'ドメインブラックリストのサービス',
	'Advanced TrackBack Lookups' => 'トラックバック送信元の確認',
	'Moderate TrackBacks from suspicious sources' => '疑わしい送信元からのトラックバックの公開を保留する',
	'Junk TrackBacks from suspicious sources' => '疑わしい送信元からのトラックバックをスパムとして報告する',
	'Lookup Whitelist' => 'ホワイトリスト',
	'To prevent lookups for specific IP addresses or domains, list each on a line by itself.' => '特定のIPアドレスやドメイン名について問い合わせを行わない場合、下の一覧に追加してください。一行に一つずつ指定します。',

## plugins/spamlookup/tmpl/url_config.tmpl
	'Link filters monitor the number of hyperlinks in incoming feedback. Feedback with many links can be held for moderation or scored as junk. Conversely, feedback that does not contain links or only refers to previously published URLs can be positively rated. (Only enable this option if you are sure your site is already spam-free.)' => 'リンクフィルタは受信したコメントやトラックバックに含まれるリンクの数を監視します。リンクの多いものを公開保留にしたりスパムにしたりできます。逆に、リンクを含まないものや、すでにブログで公開されているURLへのリンクしか含まないものは、良い評価を受けます。',
	'Link Limits' => 'リンク数の上限',
	'Credit feedback rating when no hyperlinks are present' => 'リンクを含まないコメントトラックバックを好評価する',
	'Moderate when more than' => '公開を保留する基準',
	'link(s) are given' => '個以上のリンクが含まれる場合',
	'Junk when more than' => 'スパムにする基準',
	'Link Memory' => 'リンクメモリ',
	'Credit feedback rating when &quot;URL&quot; element of feedback has been published before' => 'コメントとトラックバックに含まれる&quot;URL&quot;がすでに公開されている場合、好評価します。',
	'Only applied when no other links are present in message of feedback.' => '他にはリンクが含まれていない場合に適用されます。',
	'Exclude URLs from comments published within last [_1] days.' => '過去[_1]日間に公開されたコメントのURLを除外',
	'Email Memory' => 'メールアドレスを記憶',
	'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'すでに公開済みの&quot;メールアドレス&quot;を含むコメントトラックバックを好評価します。',
	'Exclude Email addresses from comments published within last [_1] days.' => '過去[_1]日間に公開されたコメントからメールアドレスを除外',

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incoming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => '受信したコメントトラックバックについて、特定のキーワードやドメイン名、パターンを監視します。一致したものについて、公開の保留または、スパム指定を行います。個々のパターンについて、評価値の調整も可能です。',
	'Keywords to Moderate' => '公開を保留するキーワード',
	'Keywords to Junk' => 'スパムにするキーワード',

);

1;
