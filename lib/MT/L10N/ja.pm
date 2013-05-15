# Movable Type (r) Open Source (C) 2005-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
#
# $Id:$

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
	'sort_by="score" must be used together with a namespace.' => 'sort_by="score"を指定するときはnamespaceも指定しなければなりません。',

## php/lib/block.mtauthorhasentry.php
	'No author available' => 'ユーザーが見つかりません。',

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => '[_1]を日付コンテキストの外部で利用しようとしました。',

## php/lib/block.mtentries.php

## php/lib/block.mtif.php
	'You used an [_1] tag without a valid name attribute.' => '[_1]タグではname属性は必須です。',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3]は不正です。',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'You used a [_1] tag without a valid name attribute.' => '[_1]タグではname属性は必須です。',
	'\'[_1]\' is not a hash.' => '[_1]はハッシュではありません。',
	'Invalid index.' => '不正なインデックスです。',
	'\'[_1]\' is not an array.' => '[_1]は配列ではありません。',
	'\'[_1]\' is not a valid function.' => '[_1]という関数はサポートされていません。',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters shown in the picture above.' => '画像の中に見える文字を入力してください。',

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

## php/lib/function.mtcommenternamethunk.php
	'The \'[_1]\' tag has been deprecated. Please use the \'[_2]\' tag in its place.' => 'テンプレートタグ \'[_1]\' は廃止されました。代わりに \'[_2]\'を使用してください。',

## php/lib/function.mtcommentreplytolink.php
	'Reply' => '返信',

## php/lib/function.mtentryclasslabel.php
	'page' => 'ウェブページ',
	'entry' => 'ブログ記事',
	'Entry' => 'ブログ記事',

## php/lib/function.mtinclude.php
	'\'parent\' modifier cannot be used with \'[_1]\'' => '\'parent\'属性を[_1]属性と同時に指定することは出来ません。',

## php/lib/function.mtpasswordvalidation.php
	'Password should be longer than [_1] characters' => 'パスワードは最低[_1]文字以上です。',
	'Password should not include your Username' => 'パスワードにユーザー名を含む事は出来ません。',
	'Password should include letters and numbers' => 'パスワードは文字と数字を含める必要があります。',
	'Password should include lowercase and uppercase letters' => 'パスワードは大文字と小文字を含める必要があります。',
	'Password should contain symbols such as #!$%' => 'パスワードは記号を含める必要があります。',
	'You used an [_1] tag without a valid [_2] attribute.' => '[_1]タグでは[_2]属性は必須です。',

## php/lib/function.mtpasswordvalidationrule.php
	'minimum length of [_1]' => '[_1]文字以上',
	', uppercase and lowercase letters' => '、大文字と小文字を含む',
	', letters and numbers' => '、文字と数字を含む',
	', symbols (such as #!$%)' => '、記号を含む',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled for this blog.  MTRemoteSignInLink cannot be used.' => 'ブログでTypePad認証を有効にしていないので、MTRemoteSignInLinkは利用できません。',

## php/lib/function.mtsetvar.php

## php/lib/function.mttagsearchlink.php
	'Invalid [_1] parameter.' => '[_1]パラメータが不正です。',

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '[_1]はハッシュで利用できる関数ではありません。',
	'\'[_1]\' is not a valid function for an array.' => '[_1]は配列で利用できる関数ではありません。',

## php/lib/mtdb.base.php
	'When the exclude_blogs and include_blogs attributes are used together, the same blog IDs should not be listed as parameters to both of them.' => 'include_blogs属性で指定されたブログがexclude_blogs属性で全て除外されています。',

## php/mt.php
	'Page not found - [_1]' => '[_1]が見つかりませんでした。',

## mt-check.cgi
	'Movable Type System Check' => 'Movable Type システムチェック',
	'You attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'アクセス権がありません。システム管理者に連絡してください。',
	q{The MT-Check report is disabled when Movable Type has a valid configuration file (mt-config.cgi)} => q{構成ファイル(mt-config.cgi)がすでに存在するため、'mt-check.cgi' スクリプトは無効になっています。},
	q{The mt-check.cgi script provides you with information about your system's configuration and determines whether you have all of the components you need to run Movable Type.} => q{mt-check.cgiはシステムの構成を確認し、Movable Typeを実行するために必要なコンポーネントがそろっていることを確認するためのスクリプトです。},
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2].' => 'お使いのシステムにインストールされている Perl [_1] は、Movable Type でサポートされている最低限のバージョン[_2]を満たしていません。Perlをアップグレードしてください。',
	'System Information' => 'システム情報',
	'Movable Type version:' => 'Movable Type バージョン',
	'Current working directory:' => '現在のディレクトリ',
	'MT home directory:' => 'MTディレクトリ',
	'Operating system:' => 'オペレーティングシステム',
	'Perl version:' => 'Perl のバージョン',
	'Perl include path:' => 'Perl の インクルードパス',
	'Web server:' => 'ウェブサーバー',
	'(Probably) running under cgiwrap or suexec' => 'cgiwrapまたはsuexec環境下で動作していると思われます。',
	'[_1] [_2] Modules' => '[_1]: [_2]モジュール',
	'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that they provide.' => 'これらのモジュールのインストールは<strong>任意</strong>です。お使いのサーバーにこれらのモジュールがインストールされていない場合でも、Movable Type の基本機能は動作します。これらのモジュールの機能が必要となった場合にはインストールを行ってください。',
	'The following modules are required by databases that can be used with Movable Type. Your server must have DBI and at least one of these related modules installed for the application to work properly.' => 'これらのモジュールは、Movable Type がデータを保存するために必要なモジュールです。DBIと、1つ以上のデータベース用のモジュールをインストールする必要があります。',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => '[_1]がインストールされていないか、インストールされているバージョンが古い、または [_1]の動作に必要な他のモジュールが見つかりません。',
	'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'サーバーに [_1]か、[_1]の動作に必要な他のモジュールがインストールされていません。',
	'Please consult the installation instructions for help in installing [_1].' => '[_1]のインストールはインストールマニュアルに沿って行ってください。',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the most current release available.' => 'お使いのサーバーにインストールされている DBD::mysqlのバージョンは、Movable Type と互換性がありません。CPAN に公開されている最新バージョンをインストールしてください。',
	'The $mod is installed properly, but requires an updated DBI module. Please see the note above regarding the DBI module requirements.' => '$modはインストールされていますが、新しいDBIが必要です。上記を参考に必要なDBIを確認してください。',
	'Your server has [_1] installed (version [_2]).' => 'サーバーに [_1] がインストールされています(バージョン [_2])。',
	'Movable Type System Check Successful' => 'システムのチェックを完了しました。',
	q{You're ready to go!} => q{Movable Typeを利用できます。},
	'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'お使いのサーバーには、Movable Type の動作に必要なすべてのモジュールがインストールされています。モジュールを追加インストール作業は必要はありません。マニュアルに従い、インストールを続けてください。',
	'CGI is required for all Movable Type application functionality.' => 'CGIは、Movable Type のすべてのアプリケーションの動作に必須です。',
	'Image::Size is required for file uploads (to determine the size of uploaded images in many different formats).' => 'Image::Sizeはファイルのアップロードを行うために必要です。各種のファイル形式に対応して画像のサイズを取得します。',
	'File::Spec is required to work with file system path information on all supported operating systems.' => 'File::Specはオペレーティングシステムでパスの操作を行うために必要です。',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookieはcookie 認証のために必要です。',
	'LWP::UserAgent is required for creating Movable Type configuration files using the installation wizard.' => 'LWP::UserAgentは構成ウィザードの実行に必要です。',
	'DBI is required to work with most supported databases.' => 'DBIはデータベースにアクセスするために必要です。',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'データを保存するデータベースとして MySQL を利用する場合、DBIと DBD::mysqlが必要です。',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'データを保存するデータベースとして PostgreSQL を利用する場合、DBIと DBD::Pgが必要です。',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'データを保存するデータベースとして SQLite を利用する場合、DBIと DBD::SQLiteが必要です。',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'データを保存するデータベースとして SQLite2.x を利用する場合、DBIと DBD::SQLite2が必要です。',
	'Digest::SHA is required in order to provide enhanced protection of user passwords.' => 'Digest::SHAはパスワードの高度な保護のために必要です。',
	'This module and its dependencies are required in order to operate Movable Type under psgi.' => 'PSGI環境下でmt.psgiを実行する場合に必要となります。',
	'This module and its dependencies are required to run Movable Type under psgi.' => 'PSGI環境下でmt.psgiを実行する場合に必要となります。',
	'HTML::Entities is needed to encode some characters, but this feature can be turned off using the NoHTMLEntities option in the configuration file.' => 'HTML::Entitiesのインストールは必須ではありません。特殊な文字をエンコードするときに必要になりますが、構成ファイルにNoHTMLEntitiesを設定すればこの機能を無効化できます。',
	'HTML::Parser is optional; It is needed if you want to use the TrackBack system, the weblogs.com ping, or the MT Recently Updated ping.' => 'HTML::Parserのインストールは必須ではありません。トラックバック機能や更新通知機能を利用する場合に必要となります。',
	'SOAP::Lite is optional; It is needed if you want to use the MT XML-RPC server implementation.' => 'SOAP::Liteのインストールは必須ではありません。XML-RPC による作業を行う場合に必要となります。',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Tempのインストールは必須ではありません。ファイルのアップロードを行う際に上書きを行う場合は必要となります。',
	'Scalar::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'Scalar::Utilのインストールは必須ではありません。再構築キューを利用する場合に必要となります。',
	'List::Util is optional; It is needed if you want to use the Publish Queue feature.' => 'List::Utilのインストールは必須ではありません。再構築キューを利用する場合に必要となります。',
	'[_1] is optional; It is one of the image processors that you can use to create thumbnails of uploaded images.' => '[_1]のインストールは必須ではありません。アップロードした画像のサムネイルを作成する場合に必要となります。',
	'IPC::Run is optional; It is needed if you would like to use NetPBM as the image processor for Movable Type.' => 'IPC::Runのインストールは必須ではありません。MTのイメージドライバとしてNetPBMを利用する場合に必要となります。',
	'Storable is optional; It is required by certain Movable Type plugins available from third-party developers.' => 'Storableは必須ではありません。外部プラグインの利用の際に必要となる場合があります。',
	'Crypt::DSA is optional; If it is installed, comment registration sign-ins will be accelerated.' => 'Crypt::DSAのインストールは必須ではありません。インストールされていると、コメント投稿時のサインインが高速になります。',
	'This module and its dependencies are required to permit commenters to authenticate via OpenID providers such as AOL and Yahoo! that require SSL support.' => 'Crypt::SSLeayはAOLやYahoo!などのSSLを利用するOpenIDのコメント投稿者を認証するために必要となります。',
	'Cache::File is required if you would like to be able to allow commenters to authenticate via OpenID using Yahoo! Japan.' => 'Cache::Fileのインストールは必須ではありません。Yahoo! Japanによるコメント投稿者のOpenID認証を許可する場合に必要となります。',
	'MIME::Base64 is required in order to enable comment registration and in order to send mail via an SMTP Server.' => 'MIME::Base64のインストールは必須ではありません。コメントの認証機能を利用する場合やメール送信にSMTPを利用する場合に必要となります。',
	'XML::Atom is required in order to use the Atom API.' => 'XML::Atomのインストールは必須ではありません。Atom APIを利用する場合に必要となります。',
	'Cache::Memcached and a memcached server are required to use in-memory object caching on the servers where Movable Type is deployed.' => 'Cache::Memcachedのインストールは必須ではありません。Movable Type のキャッシング機能として memcached サーバーを利用する場合に必要となります。',
	'Archive::Tar is required in order to manipulate files during backup and restore operations.' => 'Archive::Tarのインストールは必須ではありません。バックアップと復元で圧縮の機能を利用する場合に必要となります。',
	'IO::Compress::Gzip is required in order to compress files during backup operations.' => 'IO::Compress::Gzipのインストールは必須ではありません。バックアップと復元で圧縮の機能を利用する場合に必要となります。',
	'IO::Uncompress::Gunzip is required in order to decompress files during restore operation.' => 'IO::Uncompress::Gunzipのインストールは必須ではありません。バックアップと復元で圧縮の機能を利用する場合に必要となります。',
	'Archive::Zip is required in order to manipulate files during backup and restore operations.' => 'Archive::Zipのインストールは必須ではありません。バックアップと復元で圧縮の機能を利用する場合に必要となります。',
	'XML::SAX and its dependencies are required to restore a backup created in a backup/restore operation.' => 'XML::SAXは復元の機能を利用する場合に必要となります。',
	'Digest::SHA1 and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'Digest::SHA1のインストールは必須ではありませんが、LiveJournal、あるいはOpenIDでコメント投稿者を認証するために必要になります。',
	'Net::SMTP is required in order to send mail via an SMTP Server.' => 'メールの送信にSMTPを利用する場合に必要になります。',
	'This module and its dependencies are required in order to support CRAM-MD5, DIGEST-MD5 or LOGIN SASL mechanisms.' => 'Authen::SASLとその依存モジュールはCRAM-MD5、DIGEST-MD5又はLOGINをSASLメカニズムとして利用する場合に必要となります。',
	'Net::SMTP::SSL is required to use SMTP Auth over an SSL connection.' => 'Net::SMTP::SSLはSMTP認証にSSLを利用する場合に必要となります。',
	'Net::SMTP::TLS is required to use SMTP Auth with STARTTLS command.' => 'Net::SMTP::TLSはSMTP認証にSTARTTLSコマンドを利用する場合に必要となります。',
	'IO::Socket::SSL is required to use SMTP Auth over an SSL connection, or to use it with a STARTTLS command.' => 'IO::Socket::SSLはSMTP認証にSSLまたは、STARTTLSコマンドを利用する場合に必要となります。',
	'Net::SSLeay is required to use SMTP Auth over an SSL connection, or to use it with a STARTTLS command.' => 'Net::SSLeayはSMTP認証にSSLまたは、STARTTLSコマンドを利用する場合に必要となります。',
	'This module is used in a test attribute for the MTIf conditional tag.' => 'MT:Ifタグの機能で使われます。',
	'This module is used by the Markdown text filter.' => 'Markdown形式を利用するために必要です。',
	'This module is required by mt-search.cgi, if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'Perl 5.8以下の環境で、mt-search.cgiを利用するときに必要です。',
	'This module required for action streams.' => 'アクションストリームを利用するために必要です。',
	'The [_1] database driver is required to use [_2].' => '[_2]を使うには[_1]のデータベースドライバが必要です。',
	'DBI is required to store data in database.' => 'DBIはデータベースにアクセスするために必要です。',
	'Checking for' => '確認中',
	'Installed' => 'インストール済み',
	'Data Storage' => 'データストレージ',
	'Required' => '必須',
	'Optional' => 'オプション',
	'Details' => '詳細',
	'unknown' => '不明',

## default_templates/about_this_page.mtml
	'About this Entry' => 'このブログ記事について',
	'About this Archive' => 'このアーカイブについて',
	'About Archives' => 'このページについて',
	'This page contains links to all of the archived content.' => 'このページには過去に書かれたすべてのコンテンツが含まれています。',
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
	'This is a custom set of widgets that serve different content depending on the type of archive in which it is included. More info: [_1]' => 'アーカイブの種類に応じて異なる内容を表示するように設定されたウィジェットです。詳細: [_1]',
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
	'Your comment has been received and held for review by a blog administrator.' => 'コメントは現在承認されるまで公開を保留されています。',
	'Comment Submission Error' => 'コメント投稿エラー',
	'Your comment submission failed for the following reasons: [_1]' => 'コメントを投稿できませんでした。エラー: [_1]',
	'Back' => '戻る',
	'Return to the <a href="[_1]">original entry</a>.' => '<a href="[_1]">元の記事</a>に戻る',

## default_templates/comment_throttle.mtml
	'If this was an error, you can unblock the IP address and allow the visitor to add it again by logging in to your Movable Type installation, choosing Blog Config - IP Banning, and deleting the IP address [_1] from the list of banned addresses.' => 'これが間違いである場合は、Movable Typeにサインインして、ブログの設定画面に進み、禁止IPリストからIPアドレスを削除してください。',
	'A visitor to your blog [_1] has automatically been banned by adding more than the allowed number of comments in the last [_2] seconds.' => '[_1]を禁止しました。[_2]秒の間に許可された以上のコメントを送信してきました。',
	'This was done to prevent a malicious script from overwhelming your weblog with comments. The banned IP address is' => 'これは悪意のスクリプトがブログをコメントで飽和させるのを阻止するための措置です。以下のIPアドレスを禁止しました。',

## default_templates/commenter_confirm.mtml
	'Thank you registering for an account to comment on [_1].' => '[_1]にコメントするために登録していただきありがとうございます。',
	'For your security and to prevent fraud, we ask you to confirm your account and email address before continuing. Once your account is confirmed, you will immediately be allowed to comment on [_1].' => 'セキュリティ上の理由から、登録を完了する前にアカウントとメールアドレスの確認を行っています。確認を完了次第、[_1]にコメントできるようになります。',
	'To confirm your account, please click on the following URL, or cut and paste this URL into a web browser:' => 'アカウントの確認のため、次のURLをクリックするか、コピーしてブラウザのアドレス欄に貼り付けてください。',
	q{If you did not make this request, or you don't want to register for an account to comment on [_1], then no further action is required.} => q{このメールに覚えがない場合や、[_1]に登録するのをやめたい場合は、何もする必要はありません。},
	'Sincerely,' => ' ',
	'Mail Footer' => 'メールフッター',

## default_templates/commenter_notify.mtml
	q{This email is to notify you that a new user has successfully registered on the blog '[_1]'. Here is some information about this new user.} => q{これは新しいユーザーがブログ「[_1]」に登録を完了したことを通知するメールです。新しいユーザーの情報は以下に記載されています。},
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
	'Remember personal info?' => 'サインイン情報を記憶',

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
	'The sign-in attempt was not successful; Please try again.' => 'サインインできませんでした。',

## default_templates/lockout-ip.mtml
	'This email is to notify you that an IP address has been locked out.' => 'これは以下のIPアドレスからのアクセスがロックされたことを通知するメールです。',
	'IP Address: [_1]' => 'IPアドレス: [_1]',
	'Recovery: [_1]' => '解除時刻: [_1]',

## default_templates/lockout-user.mtml
	'This email is to notify you that a Movable Type user account has been locked out.' => 'これは以下のユーザーアカウントがロックされたことを通知するメールです。',
	'Display Name: [_1]' => '表示名: [_1]',
	'If you want to permit this user to participate again, click the link below.' => 'ユーザーのロックを解除する場合は、リンクをクリックしてください。',

## default_templates/main_index.mtml

## default_templates/main_index_widgets_group.mtml
	'This is a custom set of widgets that only appear on the homepage (or "main_index"). More info: [_1]' => 'main_indexのテンプレートだけに表示されるように設定されているウィジェットのセットです。詳細: [_1]',
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
	q{An unapproved comment has been posted on your blog '[_1]', for entry #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{未公開のコメントがブログ '[_1]' のブログ記事 '[_3]' (ID:[_2]) に投稿されました。公開するまでこのコメントはブログに表示されません。},
	q{An unapproved comment has been posted on your blog '[_1]', on page #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{未公開のコメントがブログ '[_1]' のウェブページ '[_3]' (ID:[_2]) に投稿されました。公開するまでこのコメントはブログに表示されません。},
	q{An unapproved comment has been posted on your website '[_1]', on page #[_2] ([_3]). You need to approve this comment before it will appear on your site.} => q{未公開のコメントがウェブサイト '[_1]' のウェブページ '[_3]' (ID:[_2]) に投稿されました。公開するまでこのコメントはウェブサイトに表示されません。},
	q{A new comment has been posted on your blog '[_1]', on entry #[_2] ([_3]).} => q{ブログ '[_1]' のブログ記事 '[_3]' (ID:[_2]) に新しいコメントが投稿されました。},
	q{A new comment has been posted on your blog '[_1]', on page #[_2] ([_3]).} => q{ブログ '[_1]' のウェブページ '[_3]' (ID:[_2]) に新しいコメントが投稿されました。},
	q{A new comment has been posted on your website '[_1]', on page #[_2] ([_3]).} => q{ウェブサイト '[_1]' のウェブページ '[_3]' (ID:[_2]) に新しいコメントが投稿されました。},
	'Commenter name: [_1]' => 'コメント投稿者: [_1]',
	'Commenter email address: [_1]' => 'メールアドレス: [_1]',
	'Commenter URL: [_1]' => 'URL: [_1]',
	'Commenter IP address: [_1]' => 'IPアドレス: [_1]',
	'Approve comment:' => 'コメントを承認する:',
	'View comment:' => 'コメントを見る:',
	'Edit comment:' => 'コメントを編集する:',
	'Report the comment as spam:' => 'コメントをスパムとして報告する:',

## default_templates/new-ping.mtml
	q{An unapproved TrackBack has been posted on your blog '[_1]', on entry #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{ブログ '[_1]' のブログ記事 '[_3]' (ID:[_2]) に未公開のトラックバックがあります。公開するまでこのトラックバックはブログに表示されません。},
	q{An unapproved TrackBack has been posted on your blog '[_1]', on page #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{ブログ '[_1]' のウェブページ '[_3]' (ID:[_2]) に未公開のトラックバックがあります。公開するまでこのトラックバックはブログに表示されません。},
	q{An unapproved TrackBack has been posted on your blog '[_1]', on category #[_2], ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{ブログ '[_1]' のカテゴリ '[_3]' (ID:[_2]) に未公開のトラックバックがあります。公開するまでこのトラックバックはブログに表示されません。},
	q{An unapproved TrackBack has been posted on your website '[_1]', on page #[_2] ([_3]). You need to approve this TrackBack before it will appear on your site.} => q{ウェブサイト '[_1]' のウェブページ '[_3]' (ID:[_2]) に未公開のトラックバックがあります。公開するまでこのトラックバックはウェブサイトに表示されません。},
	q{A new TrackBack has been posted on your blog '[_1]', on entry #[_2] ([_3]).} => q{ブログ '[_1]' のブログ記事 '[_3]' (ID:[_2]) に新しいトラックバックがあります。},
	q{A new TrackBack has been posted on your blog '[_1]', on page #[_2] ([_3]).} => q{ブログ '[_1]' のウェブページ '[_3]' (ID:[_2]) に新しいトラックバックがあります。},
	q{A new TrackBack has been posted on your blog '[_1]', on category #[_2] ([_3]).} => q{ブログ '[_1]' のカテゴリ '[_3]' (ID:[_2]) に新しいトラックバックがあります。},
	q{A new TrackBack has been posted on your website '[_1]', on page #[_2] ([_3]).} => q{ウェブサイト '[_1]' のウェブページ '[_3]' (ID:[_2]) に新しいトラックバックがあります。},
	'Excerpt' => '概要',
	'Title' => 'タイトル',
	'Blog' => 'ブログ',
	'IP address' => 'IPアドレス',
	'Approve TrackBack' => 'トラックバックを承認する',
	'View TrackBack' => 'トラックバックを見る',
	'Report TrackBack as spam' => 'トラックバックをスパムとして報告する',
	'Edit TrackBack' => 'トラックバックの編集',

## default_templates/notify-entry.mtml
	q{A new [lc,_3] entitled '[_1]' has been published to [_2].} => q{新しい[_3]「[_1]」を[_2]で公開しました。},
	'View entry:' => '表示する',
	'View page:' => '表示する',
	'[_1] Title: [_2]' => 'タイトル: [_2]',
	'Publish Date: [_1]' => '日付: [_1]',
	'Message from Sender:' => 'メッセージ: ',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'このメールは[_1]で新規に作成されたコンテンツに関する通知を送るように設定されているか、またはコンテンツの著者が選択したユーザーに送信されています。このメールを受信したくない場合は、次のユーザーに連絡してください:',

## default_templates/openid.mtml
	'[_1] accepted here' => '[_1]対応しています',
	'http://www.sixapart.com/labs/openid/' => 'https://www.sixapart.jp/about/openid.html',
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
	'A request was made to change your Movable Type password. To complete this process click on the link below to select a new password.' => 'パスワードをリセットしようとしています。以下のリンクをクリックして、新しいパスワードを設定してください。',
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
	'By default, this search engine looks for all of the specified words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'すべての単語が順序に関係なく検索されます。フレーズで検索したいときは引用符で囲んでください。',
	'movable type' => 'movable type',
	'The search engine also supports the AND, OR, and NOT boolean operators:' => 'AND、OR、NOTを入れることで論理検索を行うこともできます。',
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
	q{Subscribe to this blog's feed} => q{このブログを購読},
	'Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;' => '「[_1]」の検索結果を購読',
	'Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;' => 'タグ「[_1]」を購読',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'タグ「[_1]」のフィード',
	'Feed of results matching &ldquo;[_1]&ldquo;' => '「[_1]」を検索した結果のフィード',

## default_templates/tag_cloud.mtml

## default_templates/technorati_search.mtml
	'Technorati' => 'Techonrati',
	q{<a href='http://www.technorati.com/'>Technorati</a> search} => q{<a href='http://www.technorati.com/'>Technorati</a> search},
	'this blog' => 'このブログ',
	'all blogs' => 'すべてのブログ',
	'Blogs that link here' => 'リンクしているブログ',

## default_templates/trackbacks.mtml
	'TrackBack URL: [_1]' => 'トラックバックURL: [_1]',
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '[_3] - <a href="[_1]">[_2]</a> (<a href="[_4]">[_5]</a>)',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">続きを読む</a>',

## default_templates/verify-subscribe.mtml
	'Thank you for subscribing to notifications about updates to [_1]. Follow the link below to confirm your subscription:' => '[_1]のアップデート通知にご登録いただきありがとうございました。以下のリンクから登録を完了させてください。',
	'If the link is not clickable, just copy and paste it into your browser.' => 'リンクをクリックできない場合は、お使いのウェブブラウザに貼り付けてください。',

## lib/MT.pm
	'Powered by [_1]' => 'Powered by [_1]',
	'Version [_1]' => 'バージョン [_1]',
	'http://www.movabletype.com/' => 'http://www.sixapart.jp/movabletype/',
	'Hello, world' => 'Hello, world',
	'Hello, [_1]' => '[_1]',
	'Got an error: [_1]' => 'エラーが発生しました: [_1]',
	'Message: [_1]' => 'メッセージ: [_1]',
	'If it is present, the third argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'add_callbackの第3引数を指定する場合は、MT::ComponentまたはMT::Pluginオブジェクトでなければなりません。',
	'Fourth argument to add_callback must be a CODE reference.' => 'add_callbackの第4引数はCODEへの参照でなければなりません。',
	'Two plugins are in conflict' => 'プラグイン同士が競合しています。',
	'Invalid priority level [_1] at add_callback' => 'add_callbackの優先度レベル[_1]が不正です。',
	'Internal callback' => '内部コールバック',
	'Unnamed plugin' => '(名前なし)',
	'[_1] died with: [_2]' => '[_1]でエラーが発生しました: [_2]',
	'Bad LocalLib config ([_1]): ' => 'LocalLibの設定が不正です。',
	'Bad ObjectDriver config' => 'ObjectDriverの設定が不正です。',
	'Bad CGIPath config' => 'CGIPathの設定が不正です。',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => '構成ファイルがありません。mt-config.cgi-originalファイルの名前ををmt-config.cgiに変え忘れていませんか?',
	'Plugin error: [_1] [_2]' => 'プラグインでエラーが発生しました: [_1] [_2]',
	'Loading of blog \'[_1]\' failed: [_2]' => 'ブログ(ID:[_1])をロードできませんでした: [_2]',
	'Loading template \'[_1]\' failed.' => 'テンプレート「[_1]」のロードに失敗しました。',
	'Error while creating email: [_1]' => 'メールの再構築中にエラーが発生しました: [_1]',
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'OpenIDを利用するのに必要なPerlモジュール(Digest::SHA1)がありません。',
	'missing required Perl modules: [_1]' => '必要なPerlモジュールが見つかりません: [_1]',
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
	'Problem with this request: corrupt character data for character set [_1]' => '不正な要求です。文字コード[_1]に含まれない文字データを送信しています。',
	'Error loading website #[_1] for user provisioning. Check your NewUserefaultWebsiteId setting.' => '新規ユーザー用のウェブサイト(ID:[_1])をロードできませんでした。NewUserTemplateWebsiteIdの設定を確認してください。',
	'First Weblog' => 'First Weblog',
	'Error loading blog #[_1] for user provisioning. Check your NewUserTemplateBlogId setting.' => '新規ユーザー用のブログ(ID:[_1])をロードできませんでした。NewUserTemplateBlogIdの設定を確認してください。',
	'Error provisioning blog for new user \'[_1]\' using template blog #[_2].' => '新規ユーザー\'[_1]\'用のブログを複製元のブログ(ID:[_2])から作成できませんでした。',
	'Error provisioning blog for new user \'[_1]\' (ID: [_2]).' => '新規ユーザー\'[_1]\'用のブログを作成できませんでした。',
	'Blog \'[_1]\' (ID: [_2]) for user \'[_3]\' (ID: [_4]) has been created.' => '\'[_3]\'(ID:[_4])のブログ\'[_1]\'(ID:[_2])を作成しました。',
	'Error assigning blog administration rights to user \'[_1]\' (ID: [_2]) for blog \'[_3]\' (ID: [_4]). No suitable blog administrator role was found.' => '\'[_1]\'(ID:[_2])をブログ\'[_3]\'(ID:[_4])の管理者にできませんでした。ブログの管理権限を持つロールが見つかりませんでした。',
	'Internal Error: Login user is not initialized.' => '内部エラー: ユーザーが初期化されていません。',
	'The login could not be confirmed because of a database error ([_1])' => 'データベースのエラーが発生したため、サインインできません。: [_1]',
	'Sorry, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'ブログまたはウェブサイトへのアクセスが許されていません。エラーでこのページが表示された場合は、システム管理者に問い合わせてください。',
	'Cannot load blog #[_1].' => 'ブログ(ID:[_1])をロードできません。',
	'Invalid login.' => 'サインインできませんでした。',
	'Failed login attempt by unknown user \'[_1]\'' => '未登録のユーザー [_1] がサインインしようとしました。',
	'Failed login attempt by disabled user \'[_1]\'' => '無効なユーザー [_1] がサインインしようとしました。',
	'This account has been disabled. Please see your Movable Type system administrator for access.' => 'このアカウントは無効にされています。システム管理者に問い合わせてください。',
	'Failed login attempt by pending user \'[_1]\'' => '保留中のユーザー「[_1]」がサインインしようとしました。',
	'This account has been deleted. Please see your Movable Type system administrator for access.' => 'このアカウントは削除されました。システム管理者に問い合わせてください。',
	'User cannot be created: [_1].' => 'ユーザーを登録できません: [_1]',
	'User \'[_1]\' has been created.' => 'ユーザー「[_1]」が作成されました。',
	'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'ブログまたはウェブサイトへのアクセスが許されていません。エラーでこのページが表示された場合は、システム管理者に問い合わせてください。',
	'User \'[_1]\' (ID:[_2]) logged in successfully' => 'ユーザー\'[_1]\'(ID[_2])がサインインしました。',
	'Invalid login attempt from user \'[_1]\'' => '\'[_1]\'がサインインに失敗しました。',
	'User \'[_1]\' (ID:[_2]) logged out' => 'ユーザー\'[_1]\'(ID[_2])がサインアウトしました。',
	'User requires password.' => 'パスワードは必須です。',
	'Passwords do not match.' => '入力したパスワードが一致しません。',
	'URL is invalid.' => 'URLが不正です。',
	'User requires display name.' => '表示名は必須です。',
	'[_1] contains an invalid character: [_2]' => '[_1]には不正な文字が含まれています: [_2]',
	'Display Name' => '表示名',
	'Email Address is invalid.' => '不正なメールアドレスです。',
	'Email Address is required for password reset.' => 'メールアドレスはパスワードをリセットするために必要です。',
	'User requires username.' => 'ユーザー名は必須です。',
	'Username' => 'ユーザー名',
	'A user with the same name already exists.' => '同名のユーザーがすでに存在します。',
	'Text entered was wrong.  Try again.' => '入力された文字列が正しくありません。',
	'An error occurred while trying to process signup: [_1]' => '登録に失敗しました: [_1]',
	'New Comment Added to \'[_1]\'' => '\'[_1]\'にコメントがありました',
	'System Email Address is not configured.' => 'システムで利用するメールアドレスが設定されていません。',
	'Close' => '閉じる',
	'Failed to open pid file [_1]: [_2]' => 'PIDファイルを開くことができません。',
	'Failed to send reboot signal: [_1]' => 'プロセス再起動シグナルを送信することができませんでした。',
	'The file you uploaded is too large.' => 'アップロードしたファイルは大きすぎます。',
	'Unknown action [_1]' => '不明なアクション: [_1]',
	'Warnings and Log Messages' => '警告とメッセージ',
	'Removed [_1].' => '[_1]を削除しました。',
	'Cannot load entry #[_1].' => 'ブログ記事: [_1]をロードできませんでした。',
	'You did not have permission for this action.' => '権限がありません。',

## lib/MT/App/ActivityFeeds.pm
	'Error loading [_1]: [_2]' => '[_1]をロードできませんでした: [_2]',
	'An error occurred while generating the activity feed: [_1].' => 'ログフィードの生成中にエラーが発生しました: [_1]',
	'Invalid request.' => '不正な要求です。',
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
	'Are you sure you want to remove all trackbacks reported as spam?' => 'スパムとして報告したすべてのトラックバックを削除しますか?',
	'Are you sure you want to remove all comments reported as spam?' => 'スパムコメントをすべて削除しますか?',
	'Add a user to this [_1]' => 'この[_1]にユーザーを追加',
	'Are you sure you want to reset the activity log?' => 'ログを消去してもよろしいですか?',
	'_WARNING_PASSWORD_RESET_MULTI' => '選択されたユーザーのパスワードを再設定しようとしています。パスワード再設定用のリンクが直接それぞれのメールアドレスに送られます。実行しますか?',
	'_WARNING_DELETE_USER_EUM' => 'ユーザーを削除すると、そのユーザーの書いたブログ記事はユーザー不明となり、後で取り消せません。ユーザーを無効化してシステムにアクセスできないようにしたい場合は、アカウントを無効化してください。本当にユーザーを削除してもよろしいですか？LDAPディレクトリ上にユーザーがまだ残っている場合、いつでも再作成されてしまいます。',
	'_WARNING_DELETE_USER' => 'ユーザーを削除すると、そのユーザーの書いたブログ記事はユーザー不明となり、後で取り消せません。ユーザーを無効化するのが正しい方法です。本当にユーザーを削除してもよろしいですか?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => '選択されたブログのテンプレートを、各ブログの利用しているテーマの初期状態に戻します。テンプレートを初期化してもよろしいですか?',
	'Some websites were not deleted. You need to delete blogs under the website first.' => '削除できないウェブサイトがありました。ウェブサイト内のブログを先に削除する必要があります。',
	'You are not authorized to log in to this blog.' => 'ブログにサインインする権限がありません。',
	'No such blog [_1]' => '[_1]というブログはありません。',
	'Invalid parameter' => '不正なパラメータです。',
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
	'Delete all Spam trackbacks' => '全てのスパムトラックバックを削除する',
	'Delete all Spam comments' => '全てのスパムコメントを削除する',
	'Create Role' => '新しいロールを作成',
	'Grant Permission' => '権限を付与',
	'Clear Activity Log' => 'ログを消去',
	'Download Log (CSV)' => 'ログをダウンロード(CSV)',
	'Add IP Address' => 'IPアドレスの追加',
	'Add Contact' => '連絡先の追加',
	'Download Address Book (CSV)' => 'アドレス帳をダウンロード(CSV)',
	'Unpublish Entries' => 'ブログ記事の公開を取り消し',
	'Add Tags...' => 'タグの追加',
	'Tags to add to selected entries' => '追加するタグを入力',
	'Remove Tags...' => 'タグの削除',
	'Tags to remove from selected entries' => '削除するタグを入力',
	'Batch Edit Entries' => 'ブログ記事の一括編集',
	'Publish' => '公開',
	'Delete' => '削除',
	'Unpublish Pages' => 'ウェブページの公開を取り消し',
	'Tags to add to selected pages' => '追加するタグを入力',
	'Tags to remove from selected pages' => '削除するタグを入力',
	'Batch Edit Pages' => 'ウェブページの一括編集',
	'Tags to add to selected assets' => '追加するタグを入力',
	'Tags to remove from selected assets' => '削除するタグを入力',
	'Mark as Spam' => 'スパムに指定',
	'Remove Spam status' => 'スパム指定を解除',
	'Unpublish TrackBack(s)' => 'トラックバックの公開取り消し',
	'Unpublish Comment(s)' => 'コメントの公開取り消し',
	'Trust Commenter(s)' => 'コメント投稿者を承認',
	'Untrust Commenter(s)' => 'コメント投稿者の承認を解除',
	'Ban Commenter(s)' => 'コメント投稿者を禁止',
	'Unban Commenter(s)' => 'コメント投稿者の禁止を解除',
	'Recover Password(s)' => 'パスワードの再設定',
	'Enable' => '有効',
	'Disable' => '無効',
	'Unlock' => 'ロック解除',
	'Remove' => '削除',
	'Refresh Template(s)' => 'テンプレートの初期化',
	'Move blog(s) ' => 'ブログの移動',
	'Clone Blog' => 'ブログの複製',
	'Publish Template(s)' => 'テンプレートの再構築',
	'Clone Template(s)' => 'テンプレートの複製',
	'Revoke Permission' => '権限を削除',
	'Assets' => 'アイテム',
	'Commenters' => 'コメント投稿者',
	'Design' => 'デザイン',
	'Listing Filters' => 'フィルタ',
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
	'Asset' => 'アイテム',
	'Website' => 'ウェブサイト',
	'Profile' => 'ユーザー情報',

## lib/MT/App/Comments.pm
	'Error assigning commenting rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable commenting role was found.' => '\'[_1]\' (ID:[_2])にブログ\'[_3]\'(ID:[_2])へのコメント権限を与えられませんでした。コメント権限を与えるためのロールが見つかりません。',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => '[_1]がブログ[_2](ID:[_3])にサインインしようとしましたが、このブログではMovable Type認証が有効になっていません。',
	'Invalid login' => 'サインインできませんでした。',
	'Successfully authenticated, but signing up is not allowed.  Please contact your Movable Type system administrator.' => '認証されましたが、登録は許可されていません。システム管理者に連絡してください。',
	'You need to sign up first.' => '先に登録してください。',
	'Permission denied.' => '権限がありません。',
	'Login failed: permission denied for user \'[_1]\'' => 'サインインに失敗しました。[_1]には権限がありません。',
	'Login failed: password was wrong for user \'[_1]\'' => 'サインインに失敗しました。[_1]のパスワードが誤っています。',
	'Signing up is not allowed.' => '登録はできません。',
	'Movable Type Account Confirmation' => 'Movable Type アカウント登録確認',
	'Your confirmation has expired. Please register again.' => '有効期限が過ぎています。再度登録してください。',
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">元のページに戻る</a>',
	'Your confirmation have expired. Please register again.' => '有効期限が過ぎています。再度登録してください。',
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
	'Name and E-mail address are required.' => '名前とメールアドレスは必須です。',
	'Invalid email address \'[_1]\'' => 'メールアドレス([_1])は不正です。',
	'Invalid URL \'[_1]\'' => 'URL([_1])は不正です。',
	'Comment save failed with [_1]' => 'コメントを保存できませんでした: [_1]',
	'Comment on "[_1]" by [_2].' => '[_2]が\'[_1]\'にコメントしました。',
	'Publishing failed: [_1]' => '公開できませんでした: [_1]',
	'Cannot load template' => 'テンプレートをロードできませんでした。',
	'Failed comment attempt by pending registrant \'[_1]\'' => 'まだ登録を完了していないユーザー\'[_1]\'がコメントしようとしました。',
	'Registered User' => '登録ユーザー',
	'You are trying to redirect to external resources. If you trust the site, please click the link: [_1]' => '外部のサイトへリダイレクトしようとしています。あなたがそのサイトを信頼できる場合、リンクをクリックしてください。[_1]',
	'No entry was specified; perhaps there is a template problem?' => 'ブログ記事が指定されていません。テンプレートに問題があるかもしれません。',
	'Somehow, the entry you tried to comment on does not exist' => 'コメントしようとしたブログ記事がありません。',
	'Invalid entry ID provided' => 'ブログ記事のIDが不正です。',
	'For improved security, please change your password' => 'セキュリティを向上させるために、パスワードを変更してください。',
	'All required fields must be populated.' => '必須フィールドのすべてに正しい値を設定してください。',
	'Failed to verify the current password.' => '現在のパスワードを確認できません。',
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
	'Invalid type: [_1]' => '不正なtypeです: [_1]',
	'Failed to cache search results.  [_1] is not available: [_2]' => '結果をキャッシュできませんでした。[_1]を利用できません: [_2]',
	'Invalid format: [_1]' => '不正なformatです: [_1]',
	'Unsupported type: [_1]' => '[_1]はサポートされていません。',
	'Invalid query: [_1]' => '不正なクエリーです: [_1]',
	'Invalid archive type' => '不正なアーカイブタイプです',
	'Invalid value: [_1]' => '不正な値です: [_1]',
	'No column was specified to search for [_1].' => '[_1]で検索するカラムが指定されていません。',
	'Search: query for \'[_1]\'' => '検索: [_1]',
	'No alternate template is specified for template \'[_1]\'' => '\'[_1]\'に対応するテンプレートがありません。',
	'Opening local file \'[_1]\' failed: [_2]' => '\'[_1]\'を開けませんでした: [_2]',
	'No such template' => 'テンプレートがありません',
	'template_id cannot refer to a global template' => 'template_idにグローバルテンプレートを指定することは出来ません',
	'Output file cannot be of the type asp or php' => 'aspやphpの出力ファイルにはできません',
	'You must pass a valid archive_type with the template_id' => '正しいアーカイブタイプとテンプレートidを指定してください',
	'Template must be an entry_listing for non-Index archive types' => 'テンプレートはインデックスではないアーカイブタイプのブログ記事リストでなければなりません',
	'Filename extension cannot be asp or php for these archives' => 'ファイル拡張子がaspやphpに設定されているため、指定されてtemplate_idを利用することが出来ません',
	'Template must be a main_index for Index archive type' => 'テンプレートはmain_indexでなれければなりません',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'タイムアウトしました。お手数ですが検索をやり直してください。',

## lib/MT/App/Search/Legacy.pm
	'A search is in progress. Please wait until it is completed and try again.' => '連続した検索を抑制しています。しばらく待ってから再度検索してください。',
	'Search failed. Invalid pattern given: [_1]' => '検索に失敗しました。パターンが不正です: [_1]',
	'Search failed: [_1]' => '検索に失敗しました: [_1]',
	'File not found: [_1]' => 'ファイルが見つかりません: [_1]',
	'Publishing results failed: [_1]' => '検索結果の作成に失敗しました。',
	'Search: new comment search' => '新しいコメントを検索',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearchはMT::App::Searchと一緒に使います。',

## lib/MT/App/Trackback.pm
	'Invalid entry ID \'[_1]\'' => 'ブログ記事のIDが不正です: [_1]',
	'You must define a Ping template in order to display pings.' => '表示するにはトラックバックテンプレートを定義する必要があります。',
	'Trackback pings must use HTTP POST' => 'Trackback pings must use HTTP POST',
	'TrackBack ID (tb_id) is required.' => 'トラックバックIDが必要です。',
	'Invalid TrackBack ID \'[_1]\'' => 'トラックバックID([_1])が不正です。',
	'You are not allowed to send TrackBack pings.' => 'トラックバック送信を許可されていません。',
	'You are sending TrackBack pings too quickly. Please try again later.' => '短い期間にトラックバックを送信しすぎです。少し間をあけてもう一度送信してください。',
	'You need to provide a Source URL (url).' => 'URLが必要です。',
	'This TrackBack item is disabled.' => 'トラックバックは無効に設定されています。',
	'This TrackBack item is protected by a passphrase.' => 'トラックバックはパスワードで保護されています。',
	'TrackBack on "[_1]" from "[_2]".' => '[_2]から\'[_1]\'にトラックバックがありました。',
	'TrackBack on category \'[_1]\' (ID:[_2]).' => 'カテゴリ\'[_1]\'にトラックバックがありました。',
	'Cannot create RSS feed \'[_1]\': ' => 'フィード([_1])を作成できません: ',
	'New TrackBack ping to \'[_1]\'' => '\'[_1]\'に新しいトラックバックがありました',
	'New TrackBack ping to category \'[_1]\'' => 'カテゴリ\'[_1]\'にの新しいトラックバックがありました',

## lib/MT/App/Upgrader.pm
	'Could not authenticate using the credentials provided: [_1].' => '提供されている手段による認証ができません: [_1]',
	'Both passwords must match.' => 'パスワードが一致しません。',
	'You must supply a password.' => 'パスワードを設定してください。',
	'The \'Website Root\' provided below is not allowed' => '指定された\'ウェブサイトパス\'は許可されていません。',
	'The \'Website Root\' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click \'Finish Install\' again.' => '\'ウェブサイトパス\'にウェブサーバーから書き込めません。ウェブサイトパスの書き込み権限を、正しく設定してから再度、インストールボタンをクリックしてください。',
	'Invalid session.' => 'セッションが不正です。',
	'No permissions. Please contact your Movable Type administrator for assistance with upgrading Movable Type.' => '権限がありません。Movable Typeのアップグレードを管理者に依頼してください。',
	'Movable Type has been upgraded to version [_1].' => 'Movable Typeをバージョン[_1]にアップグレードしました。',

## lib/MT/App/Viewer.pm
	'Loading blog with ID [_1] failed' => 'ブログ (ID：[_1]) の読み込みに失敗しました',
	'File not found' => 'ファイルが見つかりません',
	'Template publishing failed: [_1]' => 'テンプレートの出力に失敗しました: [_1]',
	'Unknown archive type: [_1]' => 'アーカイブタイプが不明です: [_1]',
	'Cannot load template [_1]' => 'テンプレートを読み込めませんでした [_1]',
	'Archive publishing failed: [_1]' => 'アーカイブの公開に失敗しました: [_1]',
	'Invalid entry ID [_1].' => 'エントリーIDが不正です: [_1]',
	'Entry [_1] was not published.' => 'ブログ記事 [_1] は公開されていません',
	'Invalid category ID \'[_1]\'' => 'カテゴリのIDが不正です: [_1]',
	'Invalid author ID \'[_1]\'' => 'ユーザーIDが不正です: [_1]',

## lib/MT/App/Wizard.pm
	'The [_1] driver is required to use [_2].' => '[_2]を使うには[_1]のドライバが必要です。',
	'An error occurred while trying to connect to the database.  Check the settings and try again.' => 'データベースに接続できませんでした。設定を見直してもう一度接続してください。',
	'Please select a database from the list of available databases and try again.' => 'データベースのリストからデータベースを選択して、やり直してください。',
	'SMTP Server' => 'SMTPサーバー',
	'Sendmail' => 'Sendmail',
	'Test email from Movable Type Configuration Wizard' => 'Movable Type構成ウィザードからのテスト送信',
	'This is the test email sent by your new installation of Movable Type.' => 'Movable Typeのインストール中に送信されたテストメールです。',
	'Net::SMTP is required in order to send mail using an SMTP server.' => 'メールの送信にSMTPを利用する場合に必要になります。',
	'This module is needed to encode special characters, but this feature can be turned off using the NoHTMLEntities option in mt-config.cgi.' => '特殊な文字をエンコードするときに必要になりますが、構成ファイルにNoHTMLEntitiesを設定すればこの機能を無効化できます。',
	'This module is needed if you want to use the MT XML-RPC server implementation.' => 'XML-RPC による作業を行う場合に必要となります。',
	'This module is needed if you would like to be able to overwrite existing files when you upload.' => 'ファイルのアップロードを行う際に上書きを行う場合は必要となります。',
	'This module is needed if you would like to be able to create thumbnails of uploaded images.' => 'アップロードした画像のサムネイルを作成する場合に必要となります。',
	'This module is needed if you would like to be able to use NetPBM as the image driver for MT.' => 'MTのイメージドライバとしてNetPBMを利用する場合に必要となります。',
	'This module is required by certain MT plugins available from third parties.' => '外部プラグインの利用の際に必要となる場合があります。',
	'This module accelerates comment registration sign-ins.' => 'コメント投稿時のサインインが高速になります。',
	'Cache::File is required if you would like to be able to allow commenters to be authenticated by Yahoo! Japan as OpenID.' => 'Yahoo! Japanによるコメント投稿者のOpenID認証を許可する場合に必要となります。',
	'This module is needed to enable comment registration. Also, required in order to send mail via an SMTP Server.' => 'コメントの認証機能を利用する場合やメール送信にSMTPを利用する場合に必要となります。',
	'This module enables the use of the Atom API.' => 'Atom APIを利用する場合に必要となります。',
	'This module is required in order to use memcached as caching mechanism used by Movable Type.' => 'キャッシング機能としてmemcachedを利用する場合に必要となります。',
	'This module is required in order to archive files in backup/restore operation.' => 'バックアップと復元で圧縮の機能を利用する場合に必要となります。',
	'This module is required in order to compress files in backup/restore operation.' => 'バックアップと復元で圧縮の機能を利用する場合に必要となります。',
	'This module is required in order to decompress files in backup/restore operation.' => 'バックアップと復元で圧縮の機能を利用する場合に必要となります。',
	'This module and its dependencies are required in order to restore from a backup.' => '復元の機能を利用する場合に必要となります。',
	'This module and its dependencies are required in order to allow commenters to be authenticated by OpenID providers including LiveJournal.' => 'LiveJournal、あるいはOpenIDでコメント投稿者を認証するために必要になります。',
	'This module is required by mt-search.cgi if you are running Movable Type using a version of Perl older than Perl 5.8.' => 'Perl 5.8以下の環境で、mt-search.cgiを利用するときに必要です。',
	'This module is required for file uploads (to determine the size of uploaded images in many different formats).' => 'ファイルのアップロードを行うために必要です。各種のファイル形式に対応して画像のサイズを取得します。',
	'This module is required for cookie authentication.' => 'cookie 認証のために必要です。',

## lib/MT/ArchiveType/Author.pm
	'AUTHOR_ADV' => 'ユーザー',
	'author/author-basename/index.html' => 'author/author-basename/index.html',
	'author/author_basename/index.html' => 'author/author_basename/index.html',

## lib/MT/ArchiveType/AuthorDaily.pm
	'AUTHOR-DAILY_ADV' => 'ユーザー 日別',
	'author/author-basename/yyyy/mm/dd/index.html' => 'author/author-basename/yyyy/mm/dd/index.html',
	'author/author_basename/yyyy/mm/dd/index.html' => 'author/author_basename/yyyy/mm/dd/index.html',

## lib/MT/ArchiveType/AuthorMonthly.pm
	'AUTHOR-MONTHLY_ADV' => 'ユーザー 月別',
	'author/author-basename/yyyy/mm/index.html' => 'author/author-basename/yyyy/mm/index.html',
	'author/author_basename/yyyy/mm/index.html' => 'author/author_basename/yyyy/mm/index.html',

## lib/MT/ArchiveType/AuthorWeekly.pm
	'AUTHOR-WEEKLY_ADV' => 'ユーザー 週別',
	'author/author-basename/yyyy/mm/day-week/index.html' => 'author/author-basename/yyyy/mm/day-week/index.html',
	'author/author_basename/yyyy/mm/day-week/index.html' => 'author/author_basename/yyyy/mm/day-week/index.html',

## lib/MT/ArchiveType/AuthorYearly.pm
	'AUTHOR-YEARLY_ADV' => 'ユーザー 年別',
	'author/author-basename/yyyy/index.html' => 'author/author-basename/yyyy/index.html',
	'author/author_basename/yyyy/index.html' => 'author/author_basename/yyyy/index.html',

## lib/MT/ArchiveType/Category.pm
	'CATEGORY_ADV' => 'カテゴリ',
	'category/sub-category/index.html' => 'category/sub-category/index.html',
	'category/sub_category/index.html' => 'category/sub_category/index.html',

## lib/MT/ArchiveType/CategoryDaily.pm
	'CATEGORY-DAILY_ADV' => 'カテゴリ 日別',
	'category/sub-category/yyyy/mm/dd/index.html' => 'category/sub-category/yyyy/mm/dd/index.html',
	'category/sub_category/yyyy/mm/dd/index.html' => 'category/sub_category/yyyy/mm/dd/index.html',

## lib/MT/ArchiveType/CategoryMonthly.pm
	'CATEGORY-MONTHLY_ADV' => 'カテゴリ 月別',
	'category/sub-category/yyyy/mm/index.html' => 'category/sub-category/yyyy/mm/index.html',
	'category/sub_category/yyyy/mm/index.html' => 'category/sub_category/yyyy/mm/index.html',

## lib/MT/ArchiveType/CategoryWeekly.pm
	'CATEGORY-WEEKLY_ADV' => 'カテゴリ 週別',
	'category/sub-category/yyyy/mm/day-week/index.html' => 'category/sub-category/yyyy/mm/day-week/index.html',
	'category/sub_category/yyyy/mm/day-week/index.html' => 'category/sub_category/yyyy/mm/day-week/index.html',

## lib/MT/ArchiveType/CategoryYearly.pm
	'CATEGORY-YEARLY_ADV' => 'カテゴリ 年別',
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
	'Deleted' => '削除済み',
	'Enabled' => '有効',
	'Disabled' => '無効',
	'Could not remove asset file [_1] from the filesystem: [_2]' => 'アイテムのファイル[_1]をファイルシステム上から削除できませんでした: [_2]',
	'Description' => '説明',
	'Location' => '場所',
	'Label' => '名前',
	'Type' => '種類',
	'Filename' => 'ファイル名',
	'File Extension' => 'ファイルの拡張子',
	'Pixel width' => '高さ (px)',
	'Pixel height' => '幅 (px)',
	'Except Userpic' => 'プロフィール画像を除外する',
	'Author Status' => 'ユーザーの状態',
	'Assets of this website' => 'ウェブサイトのアイテム',

## lib/MT/Asset/Audio.pm

## lib/MT/Asset/Image.pm
	'Images' => '画像',
	'Actual Dimensions' => '実サイズ',
	'[_1] x [_2] pixels' => '[_1] x [_2] ピクセル',
	'Error cropping image: [_1]' => '画像をトリミングできませんでした: [_1]',
	'Error scaling image: [_1]' => '画像のサイズを変更できませんでした: [_1]',
	'Error converting image: [_1]' => '画像を変換できませんでした: [_1]',
	'Error creating thumbnail file: [_1]' => 'サムネイルを作成できませんでした: [_1]',
	'%f-thumb-%wx%h-%i%x' => '%f-thumb-%wx%h-%i%x',
	'Cannot load image #[_1]' => 'ID:[_1]の画像をロードできませんでした。',
	'View image' => '表示',
	'Permission denied setting image defaults for blog #[_1]' => 'ブログ(ID:[_1])に画像に関する既定値を保存する権限がありません。',
	'Thumbnail image for [_1]' => '[_1]のサムネイル画像',
	'Saving [_1] failed: [_2]' => '[_1]を保存できませんでした: [_2]',
	'Invalid basename \'[_1]\'' => 'ファイル名\'[_1]\'は不正です。',
	'Error writing to \'[_1]\': [_2]' => '\'[_1]\'に書き込めませんでした: [_2]',
	'Popup page for [_1]' => '[_1]のポップアップページ',

## lib/MT/Asset/Video.pm
	'Videos' => 'ビデオ',

## lib/MT/Association.pm
	'Association' => '関連付け',
	'Associations' => '関連付け',
	'Permissions with role: [_1]' => '[_1]の権限',
	'Permissions for [_1]' => '[_1]の権限',
	'association' => '関連付け',
	'associations' => '関連付け',
	'User Name' => 'ユーザー名',
	'Role' => 'ロール',
	'Role Name' => 'ロール名',
	'Role Detail' => 'ロールの詳細',
	'Website/Blog Name' => 'ウェブサイト/ブログ',
	'__WEBSITE_BLOG_NAME' => 'ウェブサイト/ブログ名',

## lib/MT/AtomServer.pm
	'[_1]: Entries' => '[_1]: ブログ記事一覧',
	'Invalid blog ID \'[_1]\'' => 'ブログIDが不正です([_1])。',
	'PreSave failed [_1]' => 'PreSaveでエラーがありました: [_1]',
	'User \'[_1]\' (user #[_2]) added [lc,_4] #[_3]' => '[_1] (ID: [_2])が[_4] (ID: [_3])を追加しました。',
	'User \'[_1]\' (user #[_2]) edited [lc,_4] #[_3]' => '[_1] (ID: [_2])が[_4] (ID: [_3])を編集しました。',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from atom api' => '[_1]記事([lc,_5]#[_2])は[_3](ID: [_4])によって削除されました。',
	'The file ([_1]) that you uploaded is not allowed.' => 'ファイル ([_1])のアップロードは許可されていません。',
	'Invalid image file format.' => '画像ファイルフォーマットが不正です。',
	'Perl module Image::Size is required to determine the width and height of uploaded images.' => 'Image::Sizeをインストールしないと、画像の幅と高さを検出できません。',

## lib/MT/Auth.pm
	'Bad AuthenticationModule config \'[_1]\': [_2]' => 'AuthenticationModule([_1])の設定が正しくありません: [_2]',
	'Bad AuthenticationModule config' => 'AuthenticationModuleの設定が正しくありません',

## lib/MT/Auth/MT.pm
	'Missing required module' => '必要なモジュールが見つかりません',

## lib/MT/Auth/OpenID.pm
	'Could not save the session' => 'セッションを保存できませんでした。',
	'Could not load Net::OpenID::Consumer.' => 'Net::OpenID::Consumerをロードできませんでした。',
	'The address entered does not appear to be an OpenID endpoint.' => '入力されたアドレスはOpenIDではありません。',
	'The text entered does not appear to be a valid web address.' => '正しいURLを入力してください。',
	'Unable to connect to [_1]: [_2]' => '[_1]に接続できません: [_2]',
	'Could not verify the OpenID provided: [_1]' => 'OpenIDを検証できませんでした: [_1]',

## lib/MT/Auth/TypeKey.pm
	'Sign in requires a secure signature.' => 'サインインにはセキュリティトークンが必要です。',
	'The sign-in validation failed.' => 'サインインの検証に失敗しました。',
	'This weblog requires commenters to pass an email address. If you would like to do so you may log in again, and give the authentication service permission to pass your email address.' => 'このブログは、コメントの際にメールアドレスを必ず通知するように要求しています。メールアドレスを通知しない限り、コメントを投稿できません。',
	'Could not get public key from the URL provided.' => '指定されたURLから公開キーを取得できませんでした。',
	'No public key could be found to validate registration.' => '登録状況を検査するための公開キーが見つかりませんでした。',
	'TypePad signature verification returned [_1] in [_2] seconds verifying [_3] with [_4]' => 'TypePadの署名(メッセージ: [_3] / 署名: [_4])の検証に[_2]秒掛かり、結果は[_1]でした。',
	'VALID' => '有効',
	'INVALID' => '無効',
	'The TypePad signature is out of date ([_1] seconds old). Ensure that your server\'s clock is correct.' => 'TypePadの署名が古すぎます([_1]秒経過)。サーバーの時刻が正しいことを確認してください。',

## lib/MT/Author.pm
	'Users' => 'ユーザー',
	'Active' => '有効',
	'Pending' => '保留中',
	'Not Locked Out' => 'ロックされていない',
	'Locked Out' => 'ロックされている',
	'__COMMENTER_APPROVED' => '承認',
	'Banned' => '禁止',
	'MT Users' => 'MTユーザー',
	'The approval could not be committed: [_1]' => '公開できませんでした: [_1]',
	'Userpic' => 'プロフィール画像',
	'User Info' => '詳細情報',
	'__ENTRY_COUNT' => 'ブログ記事数',
	'__COMMENT_COUNT' => 'コメント数',
	'Created by' => '作成者',
	'Status' => 'ステータス',
	'Website URL' => 'ウェブサイトURL',
	'Privilege' => 'システム権限',
	'Lockout' => 'アカウント',
	'Enabled Users' => '有効なユーザー',
	'Disabled Users' => '無効なユーザー',
	'Pending Users' => '保留中のユーザー',
	'Locked out Users' => 'アカウントがロックされているユーザー',
	'Enabled Commenters' => '有効なコメント投稿者',
	'Disabled Commenters' => '無効なコメント投稿者',
	'Pending Commenters' => '保留中のコメント投稿者',
	'MT Native Users' => 'Movable Type認証ユーザー',
	'Externally Authenticated Commenters' => '外部サービスで認証されたコメント投稿者',

## lib/MT/BackupRestore.pm
	"\nCannot write file. Disk full." => "ファイルの書き込みが出来ません: ディスクの空き容量がありません",
	'Backing up [_1] records:' => '[_1]レコードをバックアップしています:',
	'[_1] records backed up...' => '[_1]レコードをバックアップしました...',
	'[_1] records backed up.' => '[_1]レコードをバックアップしました。',
	'There were no [_1] records to be backed up.' => 'バックアップ対象となる[_1]のレコードはありません。',
	'Cannot open directory \'[_1]\': [_2]' => 'ディレクトリ\'[_1]\'を開けませんでした: [_2]',
	'No manifest file could be found in your import directory [_1].' => 'importディレクトリにマニフェストファイルがありません。',
	'Cannot open [_1].' => '[_1]を開けません。',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => '[_1]はMovable Typeバックアップで作成された正しいマニフェストファイルではありません。',
	'Manifest file: [_1]' => 'マニフェストファイル: [_1]',
	'Path was not found for the file, [_1].' => 'ファイル([_1])のパスが見つかりませんでした。',
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
	'The uploaded file was not a valid Movable Type backup manifest file.' => 'アップロードされたファイルはMovable Typeバックアップで作成されたマニフェストファイルではありません。',
	'The uploaded backup manifest file was created with Movable Type, but the schema version ([_1]) differs from the one used by this system ([_2]).  You should not restore this backup to this version of Movable Type.' => 'アップロードされたファイルはこのシステムのバージョン([_2])とは異なるバージョン([_1])でバックアップされています。このファイルを使って復元することはできません。',
	'[_1] is not a subject to be restored by Movable Type.' => '[_1]はMovable Typeで復元する対象には含まれていません。',
	'[_1] records restored.' => '[_1]件復元されました。',
	'Restoring [_1] records:' => '[_1]を復元しています:',
	'A user with the same name as the current user ([_1]) was found in the backup.  Skipping this user record.' => '現在サインインしているユーザー([_1])が見つかりました。このレコードはスキップします。',
	'A user with the same name \'[_1]\' was found in the backup (ID:[_2]).  Restore replaced this user with the data from the backup.' => '\'[_1]\': 同名のユーザーが見つかりました(ID: [_2])。バックアップ時のユーザーデータを既存ユーザーのデータで置き換えて、他のデータを復元します。',
	'Tag \'[_1]\' exists in the system.' => '\'[_1]\'というタグはすでに存在します。',
	'[_1] records restored...' => '[_1]件復元されました...',
	'The role \'[_1]\' has been renamed to \'[_2]\' because a role with the same name already exists.' => 'ロール「[_1]」はすでに存在するため、「[_2]」という名前に変わりました。',
	'The system level settings for plugin \'[_1]\' already exist.  Skipping this record.' => '[_1]のシステムのプラグイン設定はすでに存在しています。このレコードはスキップします。',

## lib/MT/BackupRestore/BackupFileScanner.pm
	'Cannot restore requested file because doing so requires the Digest::SHA Perl language module. Please contact your Movable Type system administrator.' => 'Digest::SHAがインストールされていないため、このファイルを復元することが出来ません。システム管理者問い合わせてください。',
	'Cannot restore requested file because a website was not found in either the system or backup data. A website must be created first.' => 'ウェブサイトのデータが含まれていないため、このファイルを復元することが出来ません。ウェブサイトを先に作成してください。',

## lib/MT/BackupRestore/ManifestFileHandler.pm

## lib/MT/BasicAuthor.pm
	'authors' => 'ユーザー',

## lib/MT/Blog.pm
	'*Website/Blog deleted*' => '*削除されました*',
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
	'Failed to load theme [_1]: [_2]' => '[_1]テーマの読込に失敗しました: [_2]',
	'Failed to apply theme [_1]: [_2]' => '[_1]テーマの適用に失敗しました: [_2]',
	'__PAGE_COUNT' => 'ウェブページ数',
	'__ASSET_COUNT' => 'アイテム数',
	'Members' => 'メンバー',
	'Theme' => 'テーマ',

## lib/MT/Bootstrap.pm

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => '<[_1]>は存在しません([_2]行目)。',
	'<[_1]> with no </[_1]> on line #' => '<[_1]>に対応する</[_1]>がありません。',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]>に対応する</[_1]>がありません([_2]行目)。',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]>に対応する</[_1]>がありません([_2]行目)。',
	'Error in <mt[_1]> tag: [_2]' => '<mt[_1]>タグでエラーがありました: [_2]',
	'Unknown tag found: [_1]' => '不明なタグです: [_1]',

## lib/MT/CMS/AddressBook.pm
	'No entry ID was provided' => 'ブログ記事のIDが指定されていません。',
	'No such entry \'[_1]\'' => '「[_1]」というブログ記事は存在しません。',
	'No valid recipients were found for the entry notification.' => '通知するメールアドレスがありません。',
	'[_1] Update: [_2]' => '更新通知: [_1] - [_2]',
	'Error sending mail ([_1]): Try another MailTransfer setting?' => 'メールを送信できませんでした。MailTransferの設定を見直してください: [_1]',
	'Please select a blog.' => 'ブログを選択してください。',
	'The text you entered is not a valid email address.' => 'メールアドレスが不正です。',
	'The text you entered is not a valid URL.' => 'URLが不正です。',
	'The e-mail address you entered is already on the Notification List for this blog.' => '入力したメールアドレスはすでに通知リストに含まれています。',
	'Subscriber \'[_1]\' (ID:[_2]) deleted from address book by \'[_3]\'' => '\'[_3]\'がアドレス帳から\'[_1]\'(ID:[_2])を削除しました。',

## lib/MT/CMS/Asset.pm
	'(user deleted)' => '(削除されました)',
	'Files' => 'ファイル',
	'Extension changed from [_1] to [_2]' => '拡張子が[_1]から[_2]に変更されました',
	'Upload File' => 'ファイルアップロード',
	'Cannot load file #[_1].' => 'ID:[_1]のファイルをロードできません。',
	'No permissions' => '権限がありません。',
	'File \'[_1]\' uploaded by \'[_2]\'' => '\'[_2]\'がファイル\'[_1]\'をアップロードしました。',
	'File \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => '\'[_3]\'がファイル\'[_1]\'(ID:[_2])を削除しました。',
	'Untitled' => 'タイトルなし',
	'Archive Root' => 'アーカイブパス',
	'Site Root' => 'サイトパス',
	'Please select a file to upload.' => 'アップロードするファイルを選択してください。',
	'Invalid filename \'[_1]\'' => 'ファイル名\'[_1]\'が不正です。',
	'Please select an audio file to upload.' => 'アップロードするオーディオファイルを選択してください。',
	'Please select an image to upload.' => 'アップロードする画像を選択してください。',
	'Please select a video to upload.' => 'アップロードするビデオファイルを選択してください。',
	'Movable Type was unable to write to the "Upload Destination". Please make sure that the webserver can write to this folder.' => 'アップロード先のディレクトリに書き込みできません。ウェブサーバーから書き込みできるパーミッションを与えてください。',
	'Invalid extra path \'[_1]\'' => '追加パスが不正です。',
	'Cannot make path \'[_1]\': [_2]' => 'パス\'[_1]\'を作成できませんでした: [_2]',
	'Invalid temp file name \'[_1]\'' => 'テンポラリファイルの名前\'[_1]\'が不正です。',
	'Error opening \'[_1]\': [_2]' => '\'[_1]\'を開けませんでした: [_2]',
	'Error deleting \'[_1]\': [_2]' => '\'[_1]\'を削除できませんでした: [_2]',
	'File with name \'[_1]\' already exists. (Install the File::Temp Perl module if you would like to be able to overwrite existing uploaded files.)' => '\'[_1]\'という名前のファイルが既に存在します。既存のファイルを上書きしたい場合はFile::Tempをインストールしてください。',
	'Error creating a temporary file; The webserver should be able to write to this folder.  Please check the TempDir setting in your configuration file, it is currently \'[_1]\'. ' => 'テンポラリファイルを作成できませんでした。構成ファイルでTempDirの設定を確認してください。現在は[_1]に設定されています。',
	'unassigned' => '(未設定)',
	'File with name \'[_1]\' already exists; Tried to write to a tempfile, but the webserver could not open it: [_2]' => '\'[_1]\'という名前のファイルが既に存在します。テンポラリファイルに書き込むこともできませんでした: [_2]',
	'Could not create upload path \'[_1]\': [_2]' => '[_1]を作成できませんでした: [_2]',
	'Error writing upload to \'[_1]\': [_2]' => 'アップロードされたファイルを[_1]に書き込めませんでした: [_2]',
	'Uploaded file is not an image.' => 'アップロードしたファイルは画像ではありません。',
	'Cannot overwrite an existing file with a file of a different type. Original: [_1] Uploaded: [_2]' => '違うアイテムの種類での上書きはできません。 元のファイル:[_1] アップロードされたファイル[_2]',
	'<' => '<',
	'/' => '/',

## lib/MT/CMS/BanList.pm
	'You did not enter an IP address to ban.' => '禁止するIPアドレスを指定してください。',
	'The IP you entered is already banned for this blog.' => 'このIPアドレスはすでに禁止されています。',

## lib/MT/CMS/Blog.pm
	q{Cloning blog '[_1]'...} => q{ブログ「[_1]」を複製しています...},
	'Error' => 'エラー',
	'Finished!' => '完了しました。',
	'General Settings' => '全般設定',
	'Plugin Settings' => 'プラグイン設定',
	'New Blog' => 'ブログを作成',
	'Cannot load template #[_1].' => 'テンプレート: [_1]をロードできませんでした。',
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
	'Please choose a preferred archive type.' => '優先アーカイブタイプを指定してください',
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
	'The [_1] must be given a name!' => '[_1]には名前が必要です。',
	'Failed to update [_1]: Some of [_2] were changed after you opened this page.' => 'いくつかの[_2]がすでに更新されていたため、[_1]の更新に失敗しました。',
	'Tried to update [_1]([_2]), but the object was not found.' => '[_1]([_2])が見つからないため、更新ができません。',
	'Your changes have been made (added [_1], edited [_2] and deleted [_3]). <a href="#" onclick="[_4]" class="mt-rebuild">Publish your site</a> to see these changes take effect.' => '変更を保存しました。(追加:[_1]件, 更新:[_2]件, 削除:[_3]件) 変更を有効にするには<a href="#" onclick="[_4]" class="mt-rebuild">再構築</a>をしてください。',
	'Add a [_1]' => '[_1]を追加しました。',
	'No label' => '名前がありません。',
	'The category name cannot be blank.' => 'カテゴリの名前は必須です。',
	'Permission denied: [_1]' => '権限がありません: [_1]',
	'The category name \'[_1]\' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.' => '\'[_1]\'は他のカテゴリと衝突しています。同じ階層にあるカテゴリの名前は一意でなければなりません。',
	'The category basename \'[_1]\' conflicts with the basename of another category. Top-level categories and sub-categories with the same parent must have unique basenames.' => '\'[_1]\'は他のカテゴリと衝突しています。同じ階層にあるカテゴリのベースネームは一意でなければなりません。',
	'Category \'[_1]\' created by \'[_2]\'' => '\'[_2]\'がカテゴリ\'[_1]\'を作成しました。',
	'The name \'[_1]\' is too long!' => '\'[_1]\'は長すぎます。',
	'Category \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => '\'[_3]\'がカテゴリ\'[_1]\'(ID:[_2])を削除しました。',
	'The category name \'[_1]\' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.' => '\'[_1]\'は他のカテゴリと衝突しています。同じ階層にあるカテゴリの名前は一意でなければなりません。',

## lib/MT/CMS/Comment.pm
	'Edit Comment' => 'コメントの編集',
	'(untitled)' => '(タイトルなし)',
	'No such commenter [_1].' => '[_1]というコメント投稿者は存在しません。',
	'User \'[_1]\' trusted commenter \'[_2]\'.' => '\'[_1]\'がコメント投稿者\'[_2]\'を承認しました。',
	'User \'[_1]\' banned commenter \'[_2]\'.' => '\'[_1]\'がコメント投稿者\'[_2]\'を禁止しました。',
	'User \'[_1]\' unbanned commenter \'[_2]\'.' => '\'[_1]\'がコメント投稿者\'[_2]\'を保留にしました。',
	'User \'[_1]\' untrusted commenter \'[_2]\'.' => '\'[_1]\'がコメント投稿者\'[_2]\'の承認を取り消しました。',
	'The parent comment id was not specified.' => '返信先のコメントが指定されていません。',
	'The parent comment was not found.' => '返信先のコメントが見つかりません。',
	'You cannot reply to unapproved comment.' => '未公開のコメントには返信できません。',
	'Comment (ID:[_1]) by \'[_2]\' deleted by \'[_3]\' from entry \'[_4]\'' => '\'[_3]\'がコメント\'[_1]\'(ID:[_2])を削除しました。',
	'You do not have permission to approve this trackback.' => 'トラックバックを承認する権限がありません。',
	'The entry corresponding to this comment is missing.' => '存在しないブログ記事に対してコメントしています。',
	'You do not have permission to approve this comment.' => 'コメントを公開する権限がありません。',
	'You cannot reply to unpublished comment.' => '公開されていないコメントには返信できません。',
	'Orphaned comment' => 'ブログ記事のないコメント',

## lib/MT/CMS/Common.pm
	'The Template Name and Output File fields are required.' => 'テンプレートの名前と出力ファイル名は必須です。',
	'Invalid type [_1]' => 'type [_1]は不正です。',
	'Invalid ID [_1]' => 'ID [_1]は不正です。',
	'The website root directory must be within [_1]' => 'ウェブサイトパスは、[_1]以下のディレクトリを指定してください',
	'Save failed: [_1]' => '保存できませんでした: [_1]',
	'Saving object failed: [_1]' => 'オブジェクトを保存できませんでした: [_1]',
	'\'[_1]\' edited the template \'[_2]\' in the blog \'[_3]\'' => '[_1]がブログ([_3])のテンプレート([_2])を編集しました',
	'\'[_1]\' edited the global template \'[_2]\'' => '[_1]がグローバルテンプレート([_2])を編集しました',
	'Load failed: [_1]' => 'ロードできませんでした: [_1]',
	'(no reason given)' => '(原因は不明)',
	'Invalid filter: [_1]' => '無効なフィルターです: [_1]',
	'New Filter' => '新しいフィルタ',
	'__SELECT_FILTER_VERB' => 'が',
	'All [_1]' => 'すべての[_1]',
	'[_1] Feed' => '[_1]のフィード',
	'Unknown list type' => '不明なタイプです。',
	'Invalid filter terms: [_1]' => '不正なフィルタ条件です。',
	'An error occured while counting objects: [_1]' => 'オブジェクトのカウント中にエラーが発生しました。',
	'An error occured while loading objects: [_1]' => 'オブジェクトのロード中にエラーが発生しました。',
	'Removing tag failed: [_1]' => 'タグを削除できませんでした: [_1]',
	'Removing [_1] failed: [_2]' => '[_1]を削除できませんでした: [_2]',
	'System templates cannot be deleted.' => 'システムテンプレートは削除できません。',
	'The selected [_1] has been deleted from the database.' => '選択された[_1]をデータベースから削除しました。',
	'Saving snapshot failed: [_1]' => 'スナップショットの保存に失敗しました: [_1]',

## lib/MT/CMS/Dashboard.pm
	'Error: This blog does not have a parent website.' => 'エラー: このブログにはウェブサイトがありません。',

## lib/MT/CMS/Entry.pm
	'*User deleted*' => '*削除されました*',
	'New Entry' => '記事を作成',
	'New Page' => 'ページを作成',
	'pages' => 'ウェブページ',
	'Category' => 'カテゴリ',
	'Tag' => 'タグ',
	'Entry Status' => '公開状態',
	'Cannot load template.' => 'テンプレートをロードできませんでした。',
	'Publish error: [_1]' => '再構築エラー: [_1]',
	'Unable to create preview files in this location: [_1]' => 'プレビュー用のファイルをこの場所に作成できませんでした: [_1]',
	'New [_1]' => '新しい[_1]',
	'No such [_1].' => '[_1]が存在しません。',
	'This basename has already been used. You should use an unique basename.' => 'ファイル名はすでに使用されています。一意の名前を指定してください。',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'サイトパスとサイトURLを設定していません。設定するまで公開できません。',
	'Invalid date \'[_1]\'; \'Published on\' dates must be in the format YYYY-MM-DD HH:MM:SS.' => '\'[_1]\'は不正な日付です。YYYY-MM-DD HH:MM:SSの形式で入力してください。',
	'Invalid date \'[_1]\'; \'Published on\' dates should be real dates.' => '\'[_1]\'は不正な日付です。正しい日付を入力してください。',
	'[_1] \'[_2]\' (ID:[_3]) added by user \'[_4]\'' => '[_4]が[_1]「[_2]」(ID:[_3])を追加しました。',
	'[_1] \'[_2]\' (ID:[_3]) edited and its status changed from [_4] to [_5] by user \'[_6]\'' => '[_6]が[_1]「[_2]」(ID:[_3])を更新し、公開の状態を[_4]から[_5]に変更しました。',
	'[_1] \'[_2]\' (ID:[_3]) edited by user \'[_4]\'' => '[_4]が[_1]「[_2]」(ID:[_3])を更新しました。',
	'Saving placement failed: [_1]' => 'ブログ記事とカテゴリの関連付けを設定できませんでした: [_1]',
	'Invalid date \'[_1]\'; [_2] dates must be in the format YYYY-MM-DD HH:MM:SS.' => '\'[_1]\'は不正な日付です。YYYY-MM-DD HH:MM:SSの形式で入力してください。',
	'Invalid date \'[_1]\'; [_2] dates should be real dates.' => '\'[_1]\'は不正な日付です。正しい日付を入力してください。',
	'authored on' => '公開日',
	'modified on' => '更新日',
	'Saving entry \'[_1]\' failed: [_2]' => 'ブログ記事「[_1]」を保存できませんでした: [_2]',
	'Removing placement failed: [_1]' => 'ブログ記事とカテゴリの関連付けを削除できませんでした: [_1]',
	'Ping \'[_1]\' failed: [_2]' => '[_1]へトラックバックできませんでした: [_2]',
	'(user deleted - ID:[_1])' => '(削除されたユーザー - ID:[_1])',
	'<a href="[_1]">QuickPost to [_2]</a> - Drag this bookmarklet to your browser\'s toolbar, then click it when you are visiting a site that you want to blog about.' => '<a href="[_1]">クイック投稿</a>: このリンクをブラウザのツールバーにドラッグし、興味のあるウェブページでクリックすると、ブログへ簡単に投稿できます。',
	'[_1] \'[_2]\' (ID:[_3]) deleted by \'[_4]\'' => '\'[_4]\'が[_1]\'[_2]\'(ID:[_3])を削除しました。',
	'Need a status to update entries' => 'ブログ記事を更新するにはまず公開状態を設定してください。',
	'Need entries to update status' => '公開状態を設定するにはブログ記事が必要です。',
	'One of the entries ([_1]) did not exist' => 'ブログ記事(ID:[_1])は存在しませんでした。',
	'[_1] \'[_2]\' (ID:[_3]) status changed from [_4] to [_5]' => '[_1]「[_2] (ID:[_3])」の公開状態が[_4]から[_5]に変更されました。',

## lib/MT/CMS/Export.pm
	'Loading blog \'[_1]\' failed: [_2]' => 'ブログ \'[_1]\'をロードできません: [_2]',
	'You do not have export permissions' => 'エクスポートする権限がありません。',

## lib/MT/CMS/Filter.pm
	'Failed to save filter: Label is required.' => 'フィルタの保存に失敗しました。ラベルは必須です。',
	'Failed to save filter:  Label "[_1]" is duplicated.' => 'フィルタの保存に失敗しました。[_1]というフィルタは既に存在します。',
	'No such filter' => 'フィルタが見つかりません。',
	'Permission denied' => '権限がありません。',
	'Failed to save filter: [_1]' => 'フィルタの保存に失敗しました:[_1]',
	'Failed to delete filter(s): [_1]' => 'フィルタの削除に失敗しました:[_1]',
	'Removed [_1] filters successfully.' => '[_1]件のフィルタを削除しました。',
	'[_1] ( created by [_2] )' => '作成:[_2] - [_1]',
	'(Legacy) ' => '(レガシー)',

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
	'Error saving plugin settings: [_1]' => 'プラグインの設定を保存できません: [_1]',
	'Plugin Set: [_1]' => 'プラグインのセット: [_1]',
	'Individual Plugins' => 'プラグイン',

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
	'Log Message' => 'ログ',
	'Site URL' => 'サイトURL',
	'Search & Replace' => '検索/置換',
	'Invalid date(s) specified for date range.' => '日付の範囲指定が不正です。',
	'Error in search expression: [_1]' => '検索条件にエラーがあります: [_1]',

## lib/MT/CMS/Tag.pm
	'A new name for the tag must be specified.' => 'タグの名前を指定してください。',
	'No such tag' => 'タグが存在しません。',
	'The tag was successfully renamed' => 'タグの名前が変更されました。',
	'Error saving entry: [_1]' => 'ブログ記事を保存できませんでした: [_1]',
	'Successfully added [_1] tags for [_2] entries.' => '[_2]件のブログ記事に[_1]件のタグを追加しました。',
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
	'Unknown blog' => '不明なブログ',
	'One or more errors were found in the included template module ([_1]).' => 'テンプレートモジュール([_1])でエラーが見つかりました。',
	'Global Template' => 'グローバルテンプレート',
	'Invalid Blog' => 'ブログが不正です。',
	'Global' => 'グローバル',
	'You must specify a template type when creating a template' => 'テンプレートを作成するためのtypeパラメータが指定されていません。',
	'Archive' => 'アーカイブ',
	'Entry or Page' => 'ブログ記事/ウェブページ',
	'New Template' => '新しいテンプレート',
	'Index Templates' => 'インデックステンプレート',
	'Archive Templates' => 'アーカイブテンプレート',
	'Template Modules' => 'テンプレートモジュール',
	'System Templates' => 'システムテンプレート',
	'Email Templates' => 'メールテンプレート',
	'Template Backups' => 'バックアップされたテンプレート',
	'Cannot locate host template to preview module/widget.' => 'モジュール/ウィジェットをプレビューするための親テンプレートが見つかりませんでした。',
	'Cannot preview without a template map!' => 'テンプレートマップがない状態でプレビューはできません。',
	'Unable to create preview file in this location: [_1]' => 'プレビュー用のファイルをこの場所に作成できませんでした: [_1]',
	'Lorem ipsum' => 'いろはにほへと',
	'LOREM_IPSUM_TEXT' => 'いろはにほへと ちりぬるを わかよたれそ つねならむ うゐのおくやま けふこえて あさきゆめみし ゑひもせす',
	'LORE_IPSUM_TEXT_MORE' => '色は匂へど 散りぬるを 我が世誰ぞ 常ならむ 有為の奥山 今日越えて 浅き夢見し 酔ひもせず',
	'sample, entry, preview' => 'サンプル、ブログ記事、プレビュー',
	'Populating blog with default templates failed: [_1]' => 'ブログに既定のテンプレートを設定できませんでした: [_1]',
	'Setting up mappings failed: [_1]' => 'テンプレートマップを作成できませんでした: [_1]',
	'Cannot load templatemap' => 'テンプレートマップをロードできませんでした',
	'Saving map failed: [_1]' => 'テンプレートマップを保存できませんでした: [_1]',
	'You should not be able to enter zero (0) as the time.' => '時間に0を入れることはできません。',
	'You must select at least one event checkbox.' => '少なくとも1つのイベントにチェックを入れてください。',
	'Template \'[_1]\' (ID:[_2]) created by \'[_3]\'' => '\'[_3]\'がテンプレート\'[_1]\'(ID:[_2])を作成しました。',
	'Template \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => '\'[_3]\'がテンプレート\'[_1]\'(ID:[_2])を削除しました。',
	'No Name' => '名前なし',
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
	'Failed to load theme export template for [_1]: [_2]' => '[_1]のテンプレートの読み込みに失敗しました: [_2]',
	'Failed to save theme export info: [_1]' => 'テーマエクスポート情報の保存に失敗しました: [_1]',
	'Themes directory [_1] is not writable.' => 'テーマディレクトリ[_1]に書き込めません。',
	'All themes directories are not writable.' => '書き込み可能なテーマディレクトリがありません。',
	'Error occurred during exporting [_1]: [_2]' => '[_1]のエクスポート中にエラーが発生しました: [_2]',
	'Error occurred during finalizing [_1]: [_2]' => '[_1]のファイナライズ中にエラーが発生しました: [_2]',
	'Error occurred while publishing theme: [_1]' => 'テーマの公開中にエラーが発生しました: [_1]',
	'Themes Directory [_1] is not writable.' => 'テーマディレクトリ[_1]に書き込めません。',

## lib/MT/CMS/Tools.pm
	'Password Recovery' => 'パスワードの再設定',
	'Email address is required for password reset.' => 'メールアドレスはパスワードをリセットするために必要です。',
	'Invalid email address' => 'メールアドレスのフォーマットが正しくありません',
	'Error sending e-mail ([_1]); Please fix the problem, then try again to recover your password.' => 'メールを送信できませんでした。問題を解決してから再度パスワードの再設定を行ってください: [_1]',
	'Password reset token not found' => 'パスワードをリセットするためのトークンが見つかりませんでした。',
	'Email address not found' => 'メールアドレスが見つかりませんでした。',
	'User not found' => 'ユーザーが見つかりませんでした。',
	'Your request to change your password has expired.' => 'パスワードのリセットを始めてから決められた時間を経過してしまいました。',
	'Invalid password reset request' => '不正なリクエストです。',
	'Please confirm your new password' => '新しいパスワードを確認してください。',
	'Passwords do not match' => 'パスワードが一致していません。',
	'That action ([_1]) is apparently not implemented!' => 'アクション([_1])が実装されていません。',
	'Error occurred while attempting to [_1]: [_2]' => '[_1]の実行中にエラーが発生しました: [_2]',
	'You do not have a system email address configured.  Please set this first, save it, then try the test email again.' => 'システムメールアドレスの設定がされていません。最初に設定を保存してから、再度テストメール送信を行ってください。',
	'Test email from Movable Type' => 'Movable Typeからのテストメール',
	'This is the test email sent by Movable Type.' => 'このメールはMovable Typeから送信されたテストメールです。',
	'Test e-mail was successfully sent to [_1]' => '[_1]へのテストメールは正しく送信されました。',
	'E-mail was not properly sent. [_1]' => 'メールが正しく送信されませんでした: [_1]',
	'These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'MTの設定ファイルによって設定されている値([_1])が優先されます。このページで設定した値を利用するためには、設定ファイルでの設定を削除してください。',
	'Email address is [_1]' => 'メールアドレスは[_1]です',
	'Debug mode is [_1]' => 'デバッグモードは[_1]です',
	'Performance logging is on' => 'パフォーマンスログはオンです',
	'Performance logging is off' => 'バフォーマンスログはオフです',
	'Performance log path is [_1]' => 'パフォーマンスログのパスは[_1]です',
	'Performance log threshold is [_1]' => 'パフォーマンスログの閾値は[_1]です',
	'Invalid SitePath.  The SitePath should be valid and absolute, not relative' => 'サイトパス制限には正しい絶対パスを指定してください。',
	'[_1] is [_2]' => '[_1]が[_2]',
	'none' => 'なし',
	'System Settings Changes Took Place' => 'システム設定が変更されました',
	'Invalid password recovery attempt; Cannot recover the password in this configuration' => 'パスワードの再設定に失敗しました。この構成では再設定はできません。',
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
	'Invalid password recovery attempt; cannot recover password in this configuration' => 'パスワードの再設定に失敗しました。この構成では再設定はできません。',
	'Cannot recover password in this configuration' => 'この構成ではパスワードの再設定はできません。',
	'Invalid user name \'[_1]\' in password recovery attempt' => 'パスワードの再設定でエラーが発生しました。\'[_1]\'は不正なユーザー名です。',
	'User name or password hint is incorrect.' => 'ユーザー名またはパスワード再設定用のフレーズが不正です。',
	'User has not set pasword hint; Cannot recover password' => 'パスワード再設定用のフレーズが設定されていないため、再設定できません。',
	'Invalid attempt to recover password (used hint \'[_1]\')' => 'パスワードの再設定に失敗しました(フレーズ: [_1])。',
	'User \'[_1]\' (user #[_2]) does not have email address' => 'ユーザー\'[_1]\'(ID:[_2])はメールアドレスがありません',
	'A password reset link has been sent to [_3] for user  \'[_1]\' (user #[_2]).' => 'パスワード再設定用のリンクがユーザー\'[_1]\'(ID:[_2])のメールアドレス([_3])あてに通知されました。',
	'Some objects were not restored because their parent objects were not restored.  Detailed information is in the <a href="javascript:void(0);" onclick="closeDialog(\'[_1]\');">activity log</a>.' => '親となるオブジェクトがないため復元できなかったオブジェクトがあります。詳細は<a href="javascript:void(0)" onclick="closeDialog(\'[_1]\')">ログ</a>を参照してください。',
	'[_1] is not a directory.' => '[_1]はディレクトリではありません。',
	'Error occured during restore process.' => '復元中にエラーがありました。',
	'Some of files could not be restored.' => '復元できなかったファイルがあります。',
	'Uploaded file was not a valid Movable Type backup manifest file.' => 'アップロードされたファイルはMovable Typeバックアップで作成されたマニフェストファイルではありません。',
	'Manifest file \'[_1]\' is too large. Please use import direcotry for restore.' => 'バックアップファイル\'[_1]\'が大きすぎます。インポートディレクトリを利用して復元してください。',
	'Blog(s) (ID:[_1]) was/were successfully backed up by user \'[_2]\'' => '\'[_2]\'がブログ(ID:[_1])をバックアップしました。',
	'Movable Type system was successfully backed up by user \'[_1]\'' => '\'[_1]\'がMovable Typeのシステムをバックアップしました。',
	'Some [_1] were not restored because their parent objects were not restored.' => '親となるオブジェクトがないため[_1]を復元できませんでした。',
	'Recipients for lockout notification' => '通知メール受信者',
	'User lockout limit' => 'サインイン試行回数',
	'User lockout interval' => 'サインインの間隔',
	'IP address lockout limit' => '同一IPアドレスからの試行回数',
	'IP address lockout interval' => '同一IPアドレスからの試行間隔',
	'Lockout IP address whitelist' => 'ロックアウトの除外IPアドレス',

## lib/MT/CMS/TrackBack.pm
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
	'Cannot load role #[_1].' => 'ロール: [_1]をロードできませんでした。',
	'Role name cannot be blank.' => 'ロールの名前は必須です。',
	'Another role already exists by that name.' => '同名のロールが既に存在します。',
	'You cannot define a role without permissions.' => '権限のないロールは作成できません。',
	'Invalid type' => 'typeが不正です。',
	'Invalid ID given for personal blog theme.' => '個人用ブログテーマのIDが不正です。',
	'Invalid ID given for personal blog clone location ID.' => '個人用ブログの複製先のIDが不正です。',
	'Minimum password length must be an integer and greater than zero.' => 'パスワードの最低文字数は0以上の整数でなければなりません。',
	'If personal blog is set, the personal blog location are required.' => '個人用ブログの設定にはウェブサイトの選択が必要です。',
	'Select a entry author' => 'ブログ記事の投稿者を選択',
	'Select a page author' => 'ページの投稿者を選択',
	'Selected author' => '選択された投稿者',
	'Type a username to filter the choices below.' => 'ユーザー名を入力して絞り込み',
	'Select a System Administrator' => 'システム管理者を選択',
	'Selected System Administrator' => '選択されたシステム管理者',
	'System Administrator' => 'システム管理者',
	'(newly created user)' => '(新規ユーザー)',
	'Select Website' => 'ウェブサイト選択',
	'Website Name' => 'ウェブサイト名',
	'Websites Selected' => '選択されたウェブサイト',
	'Select Blogs' => 'ブログを選択',
	'Blogs Selected' => '選択されたブログ',
	'Select Users' => 'ユーザーを選択',
	'Users Selected' => '選択されたユーザー',
	'Select Roles' => 'ロールを選択',
	'Roles Selected' => '選択されたロール',
	'Grant Permissions' => '権限の付与',
	'You cannot delete your own association.' => '自分の関連付けは削除できません。',
	'[_1]\'s Associations' => '[_1]の権限',
	'You cannot delete your own user record.' => '自分のデータは削除できません。',
	'You have no permission to delete the user [_1].' => '[_1]を削除する権限がありません。',
	'User requires username' => 'ユーザー名は必須です。',
	'User requires display name' => '表示名は必須です。',
	'User requires password' => 'パスワードは必須です。',
	'User \'[_1]\' (ID:[_2]) created by \'[_3]\'' => '\'[_3]\'がユーザー\'[_1]\'(ID:[_2])を作成しました。',
	'User \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => '\'[_3]\'がユーザー\'[_1]\'(ID:[_2])を削除しました。',
	'represents a user who will be created afterwards' => '今後新しく作成されるユーザー',

## lib/MT/CMS/Website.pm
	'New Website' => '新規ウェブサイト',
	'Website \'[_1]\' (ID:[_2]) deleted by \'[_3]\'' => '[_3]によってウェブサイト「[_1]」(ID:[_2])が削除されました',
	'Selected Website' => '選択されたウェブサイト',
	'Type a website name to filter the choices below.' => '以下の選択によって抽出されたウェブサイト名を入力',
	'Cannot load website #[_1].' => 'ウェブサイト(ID:[_1])はロードできませんでした。',
	'Blog \'[_1]\' (ID:[_2]) moved from \'[_3]\' to \'[_4]\' by \'[_5]\'' => 'ブログ「[_1]」(ID:[_2])を[_3]から[_4]に移しました',

## lib/MT/Category.pm
	'[quant,_1,entry,entries,No entries]' => '記事[quant,_1,件,件,0 件]',
	'[quant,_1,page,pages,No pages]' => 'ページ[quant,_1,件,件,0 件]',
	'Categories must exist within the same blog' => 'カテゴリは親となるカテゴリと同じブログに作らなければなりません。',
	'Category loop detected' => 'カテゴリがお互いに親と子の関係になっています。',
	'Parent' => '親カテゴリ',

## lib/MT/Comment.pm
	'Comment' => 'コメント',
	'Search for other comments from anonymous commenters' => '匿名ユーザーからのコメントを検索する。',
	'__ANONYMOUS_COMMENTER' => '匿名ユーザー',
	'Search for other comments from this deleted commenter' => '削除されたユーザーからのコメントを検索する。',
	'(Deleted)' => '削除されたユーザー',
	'Edit this [_1] commenter.' => '[_1]であるコメンターを編集する。',
	'Comments on [_1]: [_2]' => '[_1] [_2]のコメント',
	'Approved' => '公開',
	'Unapproved' => '未公開',
	'Not spam' => 'スパムではない',
	'Reported as spam' => 'スパム',
	'All comments by [_1] \'[_2]\'' => '[_1]\'[_2]\'のコメント',
	'Commenter' => 'コメント投稿者',
	'Loading entry \'[_1]\' failed: [_2]' => 'ブログ記事\'[_1]\'をロードできませんでした: [_1]',
	'Entry/Page' => 'ブログ記事/ウェブページ',
	'Comments on My Entries/Pages' => '自分のブログ記事/ウェブページへのコメント',
	'Commenter Status' => 'コメント投稿者の状態',
	'Non-spam comments' => 'スパムでないコメント',
	'Non-spam comments on this website' => 'ウェブサイトのスパムでないコメント',
	'Pending comments' => '保留中のコメント',
	'Published comments' => '公開されているコメント',
	'Comments on my entries/pages' => '自分のブログ記事/ウェブページへのコメント',
	'Comments in the last 7 days' => '最近7日間以内のコメント',
	'Spam comments' => 'スパムコメント',

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
	'This is often \'localhost\'.' => '通常「localhost」のままで構いません。',
	'The physical file path for your SQLite database. ' => 'SQLiteのデータベースファイルのパス',
	'[_1] in [_2]: [_3]' => '[_2]に \'[_3]\' を含む[_1]',
	'option is required' => '条件は必須です。',
	'Days must be a number.' => '日数には数値を指定してください。',
	'Invalid date.' => '無効な日付フォーマットです。',
	'[_1] [_2] between [_3] and [_4]' => '[_2]が[_3]から[_4]の期間内の[_1]',
	'[_1] [_2] since [_3]' => '[_2]が[_3]より後の[_1]',
	'[_1] [_2] or before [_3]' => '[_2]が[_3]より前の[_1]',
	'[_1] [_2] these [_3] days' => '[_2]が[_3]日以内の[_1]',
	'[_1] [_2] future' => '[_2]が未来の日付である[_1]',
	'[_1] [_2] past' => '[_2]が過去の日付である[_1]',
	'<mt:var name="[_1]"> [_2] [_3] [_4]' => '<mt:var name="[_1]"> [_2] [_4] [_3]',
	'Invalid parameter.' => '不正なパラメータです。',
	'[_1] [_3] [_2]' => '[_1] [_3] [_2]',
	'No Label' => '名前がありません。',
	'(system)' => 'システム',
	'My [_1]' => '自分の[_1]',
	'[_1] of this Website' => 'ウェブサイトの[_1]',
	'IP Banlist is disabled by system configuration.' => '禁止IPアドレスの管理は、設定により無効にされています。',
	'Address Book is disabled by system configuration.' => 'アドレス帳の管理は、設定により無効にされています。',
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive. [_2]' => 'パフォーマンスログを出力するディレクトリ「[_1]」を作成できませんでした。ディレクトリを書き込み可能に設定するか、または書き込みできる場所をPerformanceLoggingPathディレクティブで指定してください。: [_2]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file. [_1]' => 'パフォーマンスログを出力できませんでした。PerformanceLoggingPathにはファイルではなくディレクトリへのパスを指定してください。',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable. [_1]' => 'パフォーマンスをログを出力できませんでした。PerformanceLoggingPathにディレクトリがありますが、書き込みできません。',
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
	'ID' => 'ID',
	'Date Created' => '作成日',
	'Date Modified' => '更新日',
	'Author Name' => 'ユーザー名',
	'Legacy Quick Filter' => 'クイックフィルタ',
	'My Items' => '私のアイテム',
	'Log' => 'ログ',
	'Activity Feed' => 'ログフィード',
	'Folder' => 'フォルダ',
	'Trackback' => 'トラックバック',
	'Manage Commenters' => 'コメント投稿者の管理',
	'Member' => 'メンバー',
	'Permission' => '権限',
	'IP addresses' => 'IPアドレス',
	'IP Banning Settings' => '禁止IPアドレスの設定',
	'Contact' => '連絡先',
	'Manage Address Book' => 'アドレス帳の管理',
	'Filter' => 'フィルタ',
	'Convert Line Breaks' => '改行を変換',
	'Rich Text' => 'リッチテキスト',
	'Movable Type Default' => 'Movable Type 既定',
	'weblogs.com' => 'weblogs.com',
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
	'Remove expired lockout data' => '古いサインインの失敗レコードの消去',
	'Purge Unused FileInfo Records' => '古いファイル情報レコードの消去',
	'Manage Website' => 'ウェブサイトの管理',
	'Manage Blog' => 'ブログの管理',
	'Manage Website with Blogs' => 'ウェブサイトと所属ブログの管理',
	'Post Comments' => 'コメントの投稿',
	'Create Entries' => '記事の作成',
	'Edit All Entries' => 'すべてのブログ記事の編集',
	'Manage Assets' => 'アイテムの管理',
	'Manage Categories' => 'カテゴリの管理',
	'Change Settings' => '設定の変更',
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
	'Displays errors for dynamically-published templates.' => 'ダイナミックパブリッシングのエラーを表示します。',
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
	'User Lockout' => 'ユーザーアカウントのロック通知',
	'IP Address Lockout' => 'IPアドレスのロック通知',

## lib/MT/Entry.pm
	'[_1] ( id:[_2] ) does not exists.' => '[_1] ( id:[_2] ) が見つかりません。',
	'Entries from category: [_1]' => 'カテゴリ \'[_1]\'のブログ記事',
	'NONE' => 'なし',
	'Draft' => '下書き',
	'Published' => '公開',
	'Reviewing' => '承認待ち',
	'Scheduled' => '日時指定',
	'Junk' => 'スパム',
	'Entries by [_1]' => '[_1]のブログ記事',
	'record does not exist.' => 'ブログがありません。',
	'Review' => '承認待ち',
	'Future' => '日時指定',
	'Spam' => 'スパム',
	'Accept Comments' => 'コメントを許可',
	'Body' => '本文',
	'Extended' => '続き',
	'Format' => 'フォーマット',
	'Accept Trackbacks' => 'トラックバックを許可',
	'Publish Date' => '公開日',
	'Link' => 'リンク',
	'Primary Category' => 'メインカテゴリ',
	'-' => '-',
	'__PING_COUNT' => 'トラックバック数',
	'Date Commented' => 'コメント日',
	'Author ID' => 'ユーザーID',
	'My Entries' => '自分のブログ記事',
	'Published Entries' => '公開されているブログ記事',
	'Unpublished Entries' => '未公開のブログ記事',
	'Scheduled Entries' => '日時指定されているブログ記事',
	'Entries with Comments Within the Last 7 Days' => '最近7日間以内にコメントされたブログ記事',

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

## lib/MT/Filter.pm
	'Filters' => 'フィルタ',
	'Invalid filter type [_1]:[_2]' => '不正なフィルタタイプです。[_1]:[_2]',
	'Invalid sort key [_1]:[_2]' => '不正ななソートキーです。[_1]:[_2]',
	'"editable_terms" and "editable_filters" cannot be specified at the same time.' => '"editable_terms"と"editable_filters"は、同時に指定できません。',
	'System Object' => 'システムオブジェクト',

## lib/MT/Folder.pm

## lib/MT/IPBanList.pm
	'IP Ban' => '禁止IPリスト',
	'IP Bans' => '禁止IPリスト',

## lib/MT/Image.pm
	'Invalid Image Driver [_1]' => '不正なイメージドライバーです:[_1]',
	'Saving [_1] failed: Invalid image file format.' => '[_1]を保存できませんでした: 画像ファイルフォーマットが不正です。',
	'File size exceeds maximum allowed: [_1] > [_2]' => 'ファイルのサイズ制限を超えています。([_1] > [_2])',

## lib/MT/Image/GD.pm
	'Cannot load GD: [_1]' => 'GDをロードできませんでした。',
	'Unsupported image file type: [_1]' => '[_1]は画像タイプとしてサポートされていません。',
	'Reading file \'[_1]\' failed: [_2]' => 'ファイル \'[_1]\' を読み取れませんでした: [_2]',
	'Reading image failed: [_1]' => '画像を読み取れませんでした。',
	'Rotate (degrees: [_1]) is not supported' => '画像を回転([_1]度)させる事が出来ません。',

## lib/MT/Image/ImageMagick.pm
	'Cannot load Image::Magick: [_1]' => 'Image::Magickをロードできません: [_1]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'サイズを[_1]x[_2]に変更できませんでした。',
	'Cropping a [_1]x[_1] square at [_2],[_3] failed: [_4]' => '[_2],[_3]の位置から[_1]x[_1]をトリミングできませんでした: [_4]',
	'Flip horizontal failed: [_1]' => '画像を水平反転させることができませんでした: [_1]',
	'Flip vertical failed: [_1]' => '画像を垂直反転させることができませんでした: [_1]',
	'Rotate (degrees: [_1]) failed: [_2]' => '画像を回転([_1]度)させることができませんでした: [_2]',
	'Converting image to [_1] failed: [_2]' => '画像を[_1]に変換できませんでした: [_2]',

## lib/MT/Image/Imager.pm
	'Cannot load Imager: [_1]' => 'Imagerをロードできません: [_1]',

## lib/MT/Image/NetPBM.pm
	'Cannot load IPC::Run: [_1]' => 'IPC::Runをロードできません: [_1]',
	'Cropping to [_1]x[_1] failed: [_2]' => '[_1]x[_1]にトリミングできませんでした: [_2]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'NetPBMツールへのパスが正しく設定されていません。',

## lib/MT/Import.pm
	'Cannot rewind' => 'ポインタを先頭に移動できません',
	'Cannot open \'[_1]\': [_2]' => '\'[_1]\'を開けません: [_2]',
	'No readable files could be found in your import directory [_1].' => '読み取れないファイルがありました: [_1]',
	'Importing entries from file \'[_1]\'' => 'ファイル\'[_1]\'からインポートしています。',
	'Could not resolve import format [_1]' => 'インポート形式[_1]を処理できませんでした。',
	'Movable Type' => 'Movable Type',
	'Another system (Movable Type format)' => '他のシステム(Movable Type形式)',

## lib/MT/ImportExport.pm
	'No Blog' => 'ブログがありません。',
	'Need either ImportAs or ParentAuthor' => '「自分のブログ記事としてインポートする」か「ブログ記事の著者を変更しない」のどちらかを選択してください。',
	'Creating new user (\'[_1]\')...' => 'ユーザー([_1])を作成しています...',
	'Saving user failed: [_1]' => 'ユーザーを作成できませんでした: [_1]',
	'Creating new category (\'[_1]\')...' => 'カテゴリ([_1])を作成しています...',
	'Saving category failed: [_1]' => 'カテゴリを保存できませんでした: [_1]',
	'Invalid status value \'[_1]\'' => '状態[_1]は正しくありません',
	'Invalid allow pings value \'[_1]\'' => 'トラックバックの受信設定が不正です。',
	'Cannot find existing entry with timestamp \'[_1]\'... skipping comments, and moving on to next entry.' => 'タイムスタンプ\'[_1]\'に合致するブログ記事が見つかりません。コメントの処理を中止して次のブログ記事へ進みます。',
	'Importing into existing entry [_1] (\'[_2]\')' => '既存のブログ記事[_1]([_2])にインポートしています。',
	'Saving entry (\'[_1]\')...' => 'ブログ記事([_1])を保存しています...',
	'ok (ID [_1])' => '完了 (ID [_1])',
	'Saving entry failed: [_1]' => 'ブログ記事を保存できませんでした: [_1]',
	'Creating new comment (from \'[_1]\')...' => '\'[_1]\'からのコメントをインポートしています...',
	'Saving comment failed: [_1]' => 'コメントを保存できませんでした: [_1]',
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

## lib/MT/ListProperty.pm
	'Cannot initialize list property [_1].[_2].' => '初期化に失敗しました。[_1].[_2]',
	'Failed to initialize auto list property [_1].[_2]: Cannot find definition of column [_3].' => 'リストプロパティの初期化に失敗しました: [_3]というカラムは見つかりません。',
	'Failed to initialize auto list property [_1].[_2]: unsupported column type.' => 'リストプロパティの初期化に失敗しました: 未サポートのカラム型です。',

## lib/MT/Lockout.pm
	'Cannot find author for id \'[_1]\'' => 'ID:[_1]のユーザーが見つかりませんでした。',
	'User was locked out. IP address: [_1], Username: [_2]' => 'ユーザー: [_2] のアカウントがロックされました。IPアドレス: [_1]',
	'User Was Locked Out' => 'ユーザーアカウントがロックされました',
	'Error sending mail: [_1]' => 'メールを送信できませんでした: [_1]',
	'IP address was locked out. IP address: [_1], Username: [_2]' => 'IPアドレス: [_1]からのアクセスがロックされました。(ユーザー: [_2])',
	'IP Address Was Locked Out' => 'IPアドレスがロックされました',
	'User has been unlocked. Username: [_1]' => 'ユーザー: [_1] のアカウントロックが解除されました',

## lib/MT/Log.pm
	'Log message' => 'ログ',
	'Log messages' => 'ログ',
	'Security' => 'セキュリティ',
	'Warning' => '警告',
	'Information' => '情報',
	'Debug' => 'デバッグ',
	'Security or error' => 'セキュリティまたはエラー',
	'Security/error/warning' => 'セキュリティ/エラー/警告',
	'Not debug' => 'デバッグを含まない',
	'Debug/error' => 'デバッグ/エラー',
	'Showing only ID: [_1]' => 'ID:[_1]のログ',
	'Page # [_1] not found.' => 'ID:[_1]のウェブページが見つかりませんでした。',
	'Entry # [_1] not found.' => 'ID:[_1]のブログ記事が見つかりませんでした。',
	'Comment # [_1] not found.' => 'ID:[_1]のコメントが見つかりませんでした。',
	'TrackBack # [_1] not found.' => 'ID:[_1]のトラックバックが見つかりませんでした。',
	'blog' => 'ブログ',
	'website' => 'ウェブサイト',
	'search' => '検索',
	'author' => 'ユーザー',
	'ping' => 'トラックバック',
	'theme' => 'テーマ',
	'folder' => 'フォルダ',
	'plugin' => 'プラグイン',
	'Message' => 'ログ',
	'By' => 'ユーザー',
	'Class' => '分類',
	'Level' => 'レベル',
	'Metadata' => 'メタデータ',
	'Logs on This Website' => 'ウェブサイトのログ',
	'Show only errors' => 'エラーだけを表示',

## lib/MT/Mail.pm
	'Unknown MailTransfer method \'[_1]\'' => 'MailTransferの設定([_1])が不正です。',
	'Username and password is required for SMTP authentication.' => 'SMTP認証を利用する場合は、ユーザー名とパスワードは必須入力です。',
	'Error connecting to SMTP server [_1]:[_2]' => 'SMTPサーバに接続できません。[_1]:[_2]',
	'Authentication failure: [_1]' => '認証に失敗しました: [_1]',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'sendmailへのパスが正しくありません。SMTPの設定を試してください。',
	'Exec of sendmail failed: [_1]' => 'sendmailを実行できませんでした: [_1]',
	'Following required module(s) were not found: ([_1])' => '以下のモジュールが不足しています。([_1])',

## lib/MT/Notification.pm
	'Contacts' => '連絡先',
	'Click to edit contact' => 'クリックして連絡先を編集',
	'Save Changes' => '変更を保存',
	'Save' => '保存',

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
	'Pages in folder: [_1]' => 'フォルダ \'[_1]\'に含まれるページ',
	'Loading blog failed: [_1]' => 'ブログをロードできませんでした: [_1]',
	'(root)' => '(root)',
	'My Pages' => '自分のウェブページ',
	'Pages in This Website' => 'ウェブサイトのウェブページ',
	'Published Pages' => '公開されているウェブページ',
	'Unpublished Pages' => '未公開のウェブページ',
	'Scheduled Pages' => '日時指定されているウェブページ',
	'Pages with comments in the last 7 days' => '最近7日間以内にコメントされたウェブページ',

## lib/MT/Permission.pm

## lib/MT/Placement.pm
	'Category Placement' => 'カテゴリの関連付け',

## lib/MT/Plugin.pm
	'My Text Format' => 'My Text Format',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: ルール[_4][_5]による判定スコア - [_2][_3]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: 検査[_4]による判定スコア - [_2][_3]',

## lib/MT/PluginData.pm
	'Plugin Data' => 'プラグインデータ',

## lib/MT/Revisable.pm
	'Bad RevisioningDriver config \'[_1]\': [_2]' => 'リビジョンドライバー([_1])の設定が正しくありません: [_2]',
	'Revision not found: [_1]' => '更新履歴がありません: [_1]',
	'There are not the same types of objects, expecting two [_1]' => '同じ種類のオブジェクトではありません。両者とも[_2]である必要があります。',
	'Did not get two [_1]' => '二つの[_1]を取得できませんでした。',
	'Unknown method [_1]' => '不正な比較メソッド([_1])です。',
	'Revision Number' => '更新履歴番号',

## lib/MT/Revisable/Local.pm

## lib/MT/Role.pm
	'__ROLE_ACTIVE' => '利用中',
	'__ROLE_INACTIVE' => '利用されていない',
	'Website Administrator' => 'ウェブサイト管理者',
	'Can administer the website.' => 'ウェブサイトを管理できます。',
	'Blog Administrator' => 'ブログ管理者',
	'Can administer the blog.' => 'ブログの管理者です。',
	'Editor' => '編集者',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'ファイルをアップロードし、ブログ記事(カテゴリ)、ウェブページ(フォルダ)、タグを編集して公開できます。',
	'Can create entries, edit their own entries, upload files and publish.' => '記事を作成し、各自の記事の編集とファイルのアップロード、およびそれらを公開できます。',
	'Designer' => 'デザイナ',
	'Can edit, manage, and publish blog templates and themes.' => 'テンプレートとテーマの編集と管理、及びそれらの公開ができます。',
	'Webmaster' => 'ウェブマスター',
	'Can manage pages, upload files and publish blog templates.' => 'ページの管理、ファイルのアップロード、ブログテンプレートを公開できます。',
	'Contributor' => 'ライター',
	'Can create entries, edit their own entries, and comment.' => '記事の作成、各自の記事とコメントを編集できます。',
	'Moderator' => 'モデレータ',
	'Can comment and manage feedback.' => 'コメントを投稿し、コメントやトラックバックを管理できます。',
	'Can comment.' => 'コメントを投稿できます。',
	'__ROLE_STATUS' => '利用状況',

## lib/MT/Scorable.pm
	'Object must be saved first.' => 'オブジェクトが保存されていません。',
	'Already scored for this object.' => 'すでに1度評価しています。',
	'Could not set score to the object \'[_1]\'(ID: [_2])' => '[_1](ID: [_2])にスコアを設定できませんでした。',

## lib/MT/Session.pm
	'Session' => 'セッション',

## lib/MT/TBPing.pm
	'TrackBack' => 'トラックバック',
	'<a href="[_1]">Ping from: [_2] - [_3]</a>' => '<a href="[_1]">[_2] - [_3]からのトラックバック</a>',
	'Trackbacks on [_1]: [_2]' => '[_1] \'[_2]\'のトラックバック',
	'Trackback Text' => 'トラックバックの本文',
	'Target' => '送信先',
	'From' => '送信元',
	'Source Site' => '送信元のサイト',
	'Source Title' => '送信元記事のタイトル',
	'Trackbacks on My Entries/Pages' => '自分のブログ記事/ウェブページへのトラックバック',
	'Non-spam trackbacks' => 'スパムでないトラックバック',
	'Non-spam trackbacks on this website' => 'ウェブサイトのスパムでないトラックバック',
	'Pending trackbacks' => '保留中のトラックバック',
	'Published trackbacks' => '公開されているトラックバック',
	'Trackbacks on my entries/pages' => '自分のブログ記事/ウェブページへのトラックバック',
	'Trackbacks in the last 7 days' => '最近7日間以内のトラックバック',
	'Spam trackbacks' => 'スパムトラックバック',

## lib/MT/Tag.pm
	'Private' => 'プライベート',
	'Not Private' => 'プライベートではない',
	'Tag must have a valid name' => 'タグの名前が不正です。',
	'This tag is referenced by others.' => 'このタグは他のタグから参照されています。',
	'Tags with Entries' => 'ブログ記事のタグ',
	'Tags with Pages' => 'ウェブページのタグ',
	'Tags with Assets' => 'アイテムのタグ',

## lib/MT/TaskMgr.pm
	'Unable to secure a lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'タスクを実行するために必要なロックを獲得できませんでした。TempDir([_1])に書き込みできるかどうか確認してください。',
	'Error during task \'[_1]\': [_2]' => '\'[_1]\'の実行中にエラーが発生しました: [_2]',
	'Scheduled Tasks Update' => 'スケジュールされたタスク',
	'The following tasks were run:' => '以下のタスクを実行しました:',

## lib/MT/Template.pm
	'Template' => 'テンプレート',
	'Template load error: [_1]' => 'テンプレートファイルの読み込みが出来ませんでした: [_1]',
	'Tried to load the template file from outside of the include path \'[_1]\'' => '許可されない場所からテンプレートファイルを読み込もうとしました。\'[_1]\'',
	'Error reading file \'[_1]\': [_2]' => 'ファイル: [_1]を読み込めませんでした: [_2]',
	'Load of blog \'[_1]\' failed: [_2]' => 'ブログ(ID:[_1])をロードできませんでした: [_2]',
	'Publish error in template \'[_1]\': [_2]' => 'テンプレート「[_1]」の再構築中にエラーが発生しました: [_2]',
	'Template name must be unique within this [_1].' => 'テンプレート名は[_1]で一意でなければなりません。',
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
	'Rebuild with Indexes' => 'インデックスの再構築',
	'Dynamicity' => 'ダイナミック',
	'Build Type' => '構築タイプ',
	'Interval' => '間隔',

## lib/MT/Template/Context.pm
	'The attribute exclude_blogs cannot take \'[_1]\' for a value.' => 'exclude_blogs属性には\'[_1]\'を設定できません。',
	'When the same blog IDs are simultaneously listed in the include_blogs and exclude_blogs attributes, those blogs are excluded.' => 'include_blogs属性とexclude_blogs属性に同じブログIDが指定されています。',
	'You used an \'[_1]\' tag outside of the context of a author; Perhaps you mistakenly placed it outside of an \'MTAuthors\' container tag?' => '[_1]をコンテキスト外で利用しようとしています。MTAuthorsコンテナタグの外部で使っていませんか?',
	'You used an \'[_1]\' tag outside of the context of an entry; Perhaps you mistakenly placed it outside of an \'MTEntries\' container tag?' => '[_1]をコンテキスト外で利用しようとしています。MTEntriesコンテナタグの外部で使っていませんか?',
	'You used an \'[_1]\' tag outside of the context of the website; Perhaps you mistakenly placed it outside of an \'MTWebsites\' container tag?' => '[_1]をコンテキスト外で利用しようとしています。MTWebsitesコンテナタグの外部で使っていませんか?',
	'You used an \'[_1]\' tag outside of the context of the blog; Perhaps you mistakenly placed it outside of an \'MTBlogs\' container tag?' => '[_1]をコンテキスト外で利用しようとしています。MTBlogsコンテナタグの外部で使っていませんか?',
	'You used an \'[_1]\' tag outside of the context of a comment; Perhaps you mistakenly placed it outside of an \'MTComments\' container tag?' => '[_1]をコメントのコンテキスト外で利用しようとしました。MTCommentsコンテナの外部に配置していませんか?',
	'You used an \'[_1]\' tag outside of the context of a ping; Perhaps you mistakenly placed it outside of an \'MTPings\' container tag?' => '[_1]タグをトラックバックのコンテキスト外で利用しようとしました。MTPingsコンテナの外部に配置していませんか?',
	'You used an \'[_1]\' tag outside of the context of an asset; Perhaps you mistakenly placed it outside of an \'MTAssets\' container tag?' => '[_1]をAssetのコンテキスト外で利用しようとしました。MTAssetsコンテナの外部に配置していませんか?',
	'You used an \'[_1]\' tag outside of the context of a page; Perhaps you mistakenly placed it outside of a \'MTPages\' container tag?' => '[_1]をPageのコンテキスト外で利用しようとしました。MTPagesコンテナの外部に配置していませんか?',

## lib/MT/Template/ContextHandlers.pm
	'All About Me' => 'All About Me',
	'Remove this widget' => 'このウィジェットを削除',
	'[_1]Publish[_2] your [_3] to see these changes take effect.' => '変更を反映するために、対象の[_3]を[_1]再構築[_2]してください。',
	'[_1]Publish[_2] your site to see these changes take effect.' => '設定を有効にするために[_1]再構築[_2]してください。',
	'Actions' => 'アクション',
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'http://www.movabletype.jp/documentation/appendices/tags/%t.html',
	'You used an [_1] tag without a date context set up.' => '[_1]を日付コンテキストの外部で利用しようとしました。',
	'Division by zero.' => 'ゼロ除算エラー',
	'[_1] is not a hash.' => '[_1]はハッシュではありません。',
	'blog(s)' => 'ブログ',
	'website(s)' => 'ウェブサイト',
	'No [_1] could be found.' => '[_1]が見つかりません。',
	'records' => 'オブジェクト',
	'No template to include was specified' => 'インクルードするテンプレートが見つかりませんでした。',
	'Recursion attempt on [_1]: [_2]' => '[_1]でお互いがお互いを参照している状態になっています: [_2]',
	'Cannot find included template [_1] \'[_2]\'' => '「[_2]」という[_1]テンプレートが見つかりませんでした。',
	'Error in [_1] [_2]: [_3]' => '[_1]「[_2]」でエラーが発生しました: [_3]',
	'Writing to \'[_1]\' failed: [_2]' => '\'[_1]\'に書き込めませんでした: [_2]',
	'File inclusion is disabled by "AllowFileInclude" config directive.' => 'File モディファイアは、環境変数(AllowFileInclude)により無効にされています。',
	'Cannot find blog for id \'[_1]' => 'ID:[_1]のブログが見つかりませんでした。',
	'Cannot find included file \'[_1]\'' => '[_1]というファイルが見つかりませんでした。',
	'Error opening included file \'[_1]\': [_2]' => '[_1]を開けませんでした: [_2]',
	'Recursion attempt on file: [_1]' => '[_1]でお互いがお互いを参照している状態になっています。',
	'Cannot load user.' => 'ユーザーをロードできませんでした。',
	'Cannot find template \'[_1]\'' => '\'[_1]\'というテンプレートが見つかりませんでした。',
	'Cannot find entry \'[_1]\'' => '\'[_1]\'というブログ記事が見つかりませんでした。',
	'Unspecified archive template' => 'アーカイブテンプレートが指定されていません。',
	'Error in file template: [_1]' => 'ファイルテンプレートでエラーが発生しました: [_1]',

## lib/MT/Template/Tags/Archive.pm
	'Group iterator failed.' => 'アーカイブのロードでエラーが発生しました。',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1]は日別、週別、月別の各アーカイブでのみ利用できます。',
	'You used an [_1] tag for linking into \'[_2]\' archives, but that archive type is not published.' => '[_2]アーカイブにリンクするために[_1]タグを使っていますが、アーカイブを出力していません。',
	'You used an [_1] tag outside of the proper context.' => '[_1]タグを不正なコンテキストで利用しようとしました。',
	'Could not determine entry' => 'ブログ記事を取得できませんでした。',

## lib/MT/Template/Tags/Asset.pm
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score"を指定するときはnamespaceも指定しなければなりません。',
	'No such user \'[_1]\'' => 'ユーザー([_1])が見つかりません。',
	'You have an error in your \'[_2]\' attribute: [_1]' => '[_2]属性でエラーがありました: [_1]',

## lib/MT/Template/Tags/Author.pm
	'The \'[_2]\' attribute will only accept an integer: [_1]' => '[_2]属性は整数以外は無効です。',
	'You used an [_1] without a author context set up.' => '[_1]をユーザーのコンテキスト外部で利用しようとしました。',

## lib/MT/Template/Tags/Calendar.pm
	'Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat' => 'Sun、Mon、Tue、Wed、Thu、Fri、Satのいずれかでなければなりません。',
	'Invalid month format: must be YYYYMM' => 'YYYYMM形式でなければなりません。',
	'No such category \'[_1]\'' => '[_1]というカテゴリはありません。',

## lib/MT/Template/Tags/Category.pm
	'MT[_1] must be used in a [_2] context' => 'MT[_1]は[_2]のコンテキスト外部では利用できません。',
	'Cannot find package [_1]: [_2]' => '[_1]というパッケージが見つかりませんでした: [_2]',
	'Error sorting [_2]: [_1]' => '[_2]の並べ替えでエラーが発生しました: [_1]',
	'Cannot use sort_by and sort_method together in [_1]' => 'sort_byとsort_methodは同時に利用できません。',
	'[_1] cannot be used without publishing Category archive.' => 'カテゴリアーカイブを公開していないので[_1]は使えません。',
	'[_1] used outside of [_2]' => '[_1]を[_2]の外部で利用しようとしました。',

## lib/MT/Template/Tags/Comment.pm
	'The MTCommentFields tag is no longer available.  Please include the [_1] template module instead.' => 'MTCommentFieldsタグは利用できません。代わりにテンプレートモジュール「[_1]」をインクルードしてください。',
	'Comment Form' => 'コメント入力フォーム',
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can not be used.' => 'ブログでTypePad認証を有効にしていないので、MTRemoteSignInLinkは利用できません。',
	'To enable comment registration, you need to add a TypePad token in your weblog config or user profile.' => 'コメント投稿者を登録するためにTypePadトークンをブログの設定またはユーザーのプロフィールに設定してください。',

## lib/MT/Template/Tags/Commenter.pm
	'This \'[_1]\' tag has been deprecated. Please use \'[_2]\' instead.' => 'テンプレートタグ \'[_1]\' は廃止されました。代わりに \'[_2]\'を使用してください。',

## lib/MT/Template/Tags/Entry.pm
	'You used <$MTEntryFlag$> without a flag.' => '<$MTEntryFlag$>をフラグなしで利用しようとしました。',
	'Could not create atom id for entry [_1]' => 'ブログ記事のAtom IDを作成できませんでした。',

## lib/MT/Template/Tags/Folder.pm

## lib/MT/Template/Tags/Misc.pm
	'name is required.' => 'nameを指定してください。',
	'Specified WidgetSet \'[_1]\' not found.' => 'ウィジェットセット「[_1]」が見つかりません。',

## lib/MT/Template/Tags/Ping.pm
	'<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the \'category\' attribute to the tag.' => '<\$MTCategoryTrackbackLink\$>はカテゴリのコンテキストかまたはcategory属性とともに利用してください。',

## lib/MT/Template/Tags/Tag.pm

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
	'Failed to copy file [_1]:[_2]' => '[_1]のコピーに失敗しました: [_2]',
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
	'A template set containing [quant,_1,template,templates], [quant,_2,widget,widgets], and [quant,_3,widget set,widget sets].' => 'テンプレートセット([_1]テンプレート, [_2]ウィジェット, [_3]ウィジェットセット)',
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
	'Upgrading asset path information...' => 'アイテムパス情報を更新しています...',
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
	'Migrating DefaultSiteURL/DefaultSiteRoot to website...' => 'DefaultSiteURL/DefaultSiteRootをウェブサイト用に移行しています...',
	'New user\'s website' => '新規ユーザー向けウェブサイト',
	'Migrating existing [quant,_1,blog,blogs] into websites and their children...' => '既存のブログをウェブサイトで管理できるように移行しています。',
	'Error loading role: [_1].' => 'ロールのロードエラー: [_1]',
	'New WebSite [_1]' => '新しいウェブサイト: [_1]',
	'An error occured during generating a website upon upgrade: [_1]' => 'ウェブサイトへの移行中にエラーが発生しました: [_1]',
	'Generated a website [_1]' => '作成されたウェブサイト: [_1]',
	'An error occured during migrating a blog\'s site_url: [_1]' => 'ブログのサイトURLの移行中にエラーが発生しました: [_1]',
	'Moved blog [_1] ([_2]) under website [_3]' => '[_1]ブログ([_2])を[_3]ウェブサイト下に移動しました',
	'Removing technorati update-ping service from [_1] (ID:[_2]).' => 'ブログ[_1](ID:[_2])の更新通知先からテクノラティを削除しました。',
	'Expiring cached MT News widget...' => 'MTニュースのキャッシュを破棄しています...',
	'Recovering type of author...' => 'コメンターの権限を再設定しています...',
	'Merging dashboard settings...' => 'ダッシュボート設定を移行しています...',
	'Classifying blogs...' => 'ブログを分類しています...',
	'Rebuilding permissions...' => '権限を再構築しています...',
	'Assigning ID of author for entries...' => '記事に作成者のIDを設定しています...',
	'Removing widget from dashboard...' => 'ダッシュボードからウィジェットを削除しています...',
	'Ordering Categories and Folders of Blogs...' => 'ブログのカテゴリとフォルダの順番を設定しています...',
	'Ordering Folders of Websites...' => 'ウェブサイトのフォルダの順番を設定しています...',
	'Assigning ID of user who created for initial user...' => '初期作成ユーザーの作成者IDを設定しています...',
	'Assigning language of blog to use for formatting date...' => 'ブログに日付の言語を設定しています...',

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
	'Cannot extract from the object' => '解凍できません。',
	'Cannot write to the object' => '書き込みできません。',
	'Both data and file name must be specified.' => 'データとファイルの両方を指定してください。',

## lib/MT/Util/Archive/Zip.pm
	'Type must be zip' => 'ZIPが指定されていません。',
	'File [_1] is not a zip file.' => '[_1]はZIPファイルではありません。',

## lib/MT/Util/Captcha.pm
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'Movable Type 既定のCAPTCHAプロバイダはImage::Magickをインストールしないと使えません。',
	'You need to configure CaptchaSourceImageBase.' => '構成ファイルでCaptchaSourceImageBaseを設定してください。',
	'Type the characters you see in the picture above.' => '画像の中に見える文字を入力してください。',
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
	'__BLOG_COUNT' => 'ブログ数',

## lib/MT/Worker/Publish.pm
	'Background Publishing Done' => 'バックグラウンドパブリッシングが完了しました',
	'Published: [_1]' => '公開されたファイル: [_1]',
	'Error rebuilding file [_1]:[_2]' => '[_1]の再構築中にエラーが発生しました: [_2]',
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- 完了 ([_1]ファイル - [_2]秒)',

## lib/MT/Worker/Sync.pm
	"Error during rsync of files in [_1]:\n" => "ファイル\'[_1]\'のrsync中にエラーが発生しました: ",
	'Done Synchornizing Files' => 'ファイルを同期しました。',
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
	'Not allowed to edit entry' => 'ブログ記事を編集する権限がありません。',
	'Entry \'[_1]\' ([lc,_5] #[_2]) deleted by \'[_3]\' (user #[_4]) from xml-rpc' => '\'[_3]\'(ID:[_4])がXMLRPC経由で[_5]\'[_1]\'(ID:[_2])を削除しました。',
	'Not allowed to get entry' => 'ブログ記事を取得する権限がありません。',
	'Not allowed to set entry categories' => 'カテゴリを設定する権限がありません。',
	'Not allowed to upload files' => 'ファイルをアップロードする権限がありません。',
	'No filename provided' => 'ファイル名がありません。',
	'Error writing uploaded file: [_1]' => 'アップロードされたファイルを書き込めませんでした: [_1]',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Image::Sizeをインストールしないと、画像の幅と高さを検出できません。',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Templateメソッドは実装されていません。',

## mt-static/addons/Cloud.pack/js/cfg_config_directives.js
	'A configuration directive is required.' => '環境変数名は必須です。',
	'[_1] cannot be updated.' => '[_1]を変更することは出来ません。',
	'Although [_1] can be updated by Movable Type, it cannot be updated on this screen.' => '[_1]は変更出来ません。',
	'[_1] already exists.' => '[_1]はすでに存在します。',
	'A configuration value is required.' => '設定値は必須です。',
	'The HASH type configuration directive should be in the format of "key=value"' => 'ハッシュ型の環境変数の設定値は、"key=value"の形式で入力してください。',
	'[_1] for [_2] already exists.' => '[_2]はすでに[_1]の設定値として存在します。',
	'http://www.movabletype.org/documentation/[_1]' => 'http://www.movabletype.jp/documentation/[_1]',
	'Are you sure you want to remove [_1]?' => '[_1]を削除してもよろしいですか?',
	'configuration directive' => '環境変数',

## mt-static/addons/Cloud.pack/js/cms.js
	'Continue' => '次へ',
	'You have unsaved changes to this page that will be lost.' => '保存されていない変更は失われます。',

## mt-static/jquery/jquery.mt.js
	'Invalid value' => '入力された値が正しくありません',
	'You have an error in your input.' => '入力内容に誤りがあります。',
	'Invalid date format' => '日付の入力フォーマットが正しくありません',
	'Invalid URL' => 'URLのフォーマットが正しくありません',
	'This field is required' => 'このフィールドは必須です。',
	'This field must be an integer' => 'このフィールドには整数の値を入力して下さい',
	'This field must be a number' => 'このフィールドには数値を入力して下さい',

## mt-static/jquery/jquery.mt.min.js

## mt-static/js/assetdetail.js
	'No Preview Available.' => 'プレビューは利用できません。',
	'Dimensions' => '大きさ',
	'File Name' => 'ファイル名',

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
	'publish' => '公開',
	'unlock' => 'ロック解除してサインイン可能に',
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
	'First' => '最初',
	'Prev' => '前',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] / [_3]',
	'[_1] &ndash; [_2]' => '[_1] &ndash; [_2]',
	'Last' => '最後',

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => '定型文の挿入',

## mt-static/plugins/FormattedTextForTinyMCE/langs/template.js
	'Boilerplate' => '定型文',
	'Select Boilerplate' => '定型文を選択...',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/advanced.js
	'Bold (Ctrl+B)' => '太字  (Ctrl+B)',
	'Italic (Ctrl+I)' => '斜体 (Ctrl+I)',
	'Underline (Ctrl+U)' => '下線 (Ctrl+U)',
	'Strikethrough' => '取り消し線',
	'Block Quotation' => '引用ブロック',
	'Unordered List' => '番号なしリスト',
	'Ordered List' => '番号付きリスト',
	'Horizontal Line' => '水平線を挿入',
	'Insert/Edit Link' => 'リンクの挿入/編集',
	'Unlink' => 'リンクを解除',
	'Undo (Ctrl+Z)' => '元に戻す (Ctrl+Z)',
	'Redo (Ctrl+Y)' => 'やり直す (Ctrl+Y)',
	'Select Text Color' => 'テキスト色',
	'Select Background Color' => '背景色',
	'Remove Formatting' => '書式の削除',
	'Align Left' => '左揃え',
	'Align Center' => '中央揃え',
	'Align Right' => '右揃え',
	'Indent' => '字下げを増やす',
	'Outdent' => '字下げを減らす',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/insert_html.js
	'Insert HTML' => 'HTMLの挿入',
	'Source' => 'HTML',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Insert Link' => 'リンクの挿入',
	'Insert Image Asset' => '画像の挿入',
	'Insert Asset Link' => 'アイテムの挿入',
	'Toggle Fullscreen Mode' => '全画面表示の切り替え',
	'Toggle HTML Edit Mode' => 'HTML編集モードの切り替え',
	'Strong Emphasis' => '太字',
	'Emphasis' => '斜体',
	'List Item' => 'リスト要素',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => '全画面表示',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/paste/editor_plugin.js
	'paste.plaintext_mode_sticky' => 'paste.plaintext_mode_sticky',
	'paste.plaintext_mode' => 'paste.plaintext_mode',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/paste/editor_plugin_src.js

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/editor_template.js
	'advanced.path' => 'advanced.path',

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/editor_template_src.js

## mt-static/plugins/TinyMCE/tiny_mce/themes/advanced/js/charmap.js
	'advanced_dlg.charmap_usage' => 'advanced_dlg.charmap_usage',

## mt-static/plugins/TinyMCE/tiny_mce/utils/editable_selects.js
	'value' => 'value',

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

## themes/classic_blog/templates/comments.mtml

## themes/classic_blog/templates/creative_commons.mtml

## themes/classic_blog/templates/current_author_monthly_archive_list.mtml

## themes/classic_blog/templates/current_category_monthly_archive_list.mtml

## themes/classic_blog/templates/date_based_author_archives.mtml

## themes/classic_blog/templates/date_based_category_archives.mtml

## themes/classic_blog/templates/dynamic_error.mtml

## themes/classic_blog/templates/entry.mtml

## themes/classic_blog/templates/entry_summary.mtml

## themes/classic_blog/templates/javascript.mtml

## themes/classic_blog/templates/main_index.mtml

## themes/classic_blog/templates/main_index_widgets_group.mtml

## themes/classic_blog/templates/monthly_archive_dropdown.mtml

## themes/classic_blog/templates/monthly_archive_list.mtml

## themes/classic_blog/templates/monthly_entry_listing.mtml

## themes/classic_blog/templates/openid.mtml

## themes/classic_blog/templates/page.mtml

## themes/classic_blog/templates/pages_list.mtml

## themes/classic_blog/templates/powered_by.mtml

## themes/classic_blog/templates/recent_assets.mtml

## themes/classic_blog/templates/recent_comments.mtml

## themes/classic_blog/templates/recent_entries.mtml

## themes/classic_blog/templates/search.mtml

## themes/classic_blog/templates/search_results.mtml

## themes/classic_blog/templates/sidebar.mtml

## themes/classic_blog/templates/signin.mtml

## themes/classic_blog/templates/syndication.mtml

## themes/classic_blog/templates/tag_cloud.mtml

## themes/classic_blog/templates/technorati_search.mtml

## themes/classic_blog/templates/trackbacks.mtml

## themes/classic_blog/theme.yaml
	'A traditional blogging design that comes with plenty of styles and a selection of 2 column / 3 column layouts. Best for use in standard blog publishing applications.' => 'たくさんの2カラムや3カラムレイアウトをもつ一般的なブログ用デザインです。全ブログユーザーに最適です。',

## themes/classic_website/templates/about_this_page.mtml

## themes/classic_website/templates/banner_footer.mtml

## themes/classic_website/templates/blogs.mtml

## themes/classic_website/templates/comment_detail.mtml

## themes/classic_website/templates/comment_listing.mtml

## themes/classic_website/templates/comment_preview.mtml

## themes/classic_website/templates/comment_response.mtml

## themes/classic_website/templates/comments.mtml

## themes/classic_website/templates/creative_commons.mtml

## themes/classic_website/templates/dynamic_error.mtml

## themes/classic_website/templates/entry.mtml

## themes/classic_website/templates/entry_summary.mtml

## themes/classic_website/templates/javascript.mtml

## themes/classic_website/templates/main_index.mtml

## themes/classic_website/templates/main_index_widgets_group.mtml

## themes/classic_website/templates/openid.mtml

## themes/classic_website/templates/page.mtml

## themes/classic_website/templates/pages_list.mtml

## themes/classic_website/templates/powered_by.mtml

## themes/classic_website/templates/recent_assets.mtml

## themes/classic_website/templates/recent_comments.mtml

## themes/classic_website/templates/recent_entries.mtml

## themes/classic_website/templates/search.mtml

## themes/classic_website/templates/search_results.mtml

## themes/classic_website/templates/sidebar.mtml

## themes/classic_website/templates/signin.mtml

## themes/classic_website/templates/syndication.mtml
	q{Subscribe to this website's feed} => q{ウェブサイトを購読},

## themes/classic_website/templates/tag_cloud.mtml

## themes/classic_website/templates/technorati_search.mtml

## themes/classic_website/templates/trackbacks.mtml

## themes/classic_website/theme.yaml
	'Create a blog portal that aggregates contents from several blogs in one website.' => 'ウェブサイトに存在するブログのコンテンツを表示するブログポータルを作成します。',
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

## themes/pico/templates/javascript.mtml

## themes/pico/templates/main_index.mtml

## themes/pico/templates/main_index_widgets_group.mtml

## themes/pico/templates/monthly_archive_dropdown.mtml

## themes/pico/templates/monthly_archive_list.mtml

## themes/pico/templates/monthly_entry_listing.mtml

## themes/pico/templates/navigation.mtml
	'Subscribe' => '購読',

## themes/pico/templates/openid.mtml

## themes/pico/templates/page.mtml

## themes/pico/templates/pages_list.mtml

## themes/pico/templates/recent_assets.mtml

## themes/pico/templates/recent_comments.mtml

## themes/pico/templates/recent_entries.mtml

## themes/pico/templates/search.mtml

## themes/pico/templates/search_results.mtml

## themes/pico/templates/signin.mtml

## themes/pico/templates/syndication.mtml

## themes/pico/templates/tag_cloud.mtml

## themes/pico/templates/technorati_search.mtml

## themes/pico/templates/trackbacks.mtml

## themes/pico/theme.yaml
	q{Pico is a microblogging theme, designed for keeping things simple to handle frequent updates. To put the focus on content we've moved the sidebars below the list of posts.} => q{Picoはマイクロブログを作成するのに適した、テキストや写真といったコンテンツを引き立てるシンプルなデザインのテーマです。アーカイブリストなどの関連コンテンツは、メインコンテンツの下に配置されます。},
	'Pico' => 'Pico',
	'Pico Styles' => 'Picoスタイル',
	'A collection of styles compatible with Pico themes.' => 'Picoテーマと互換のあるスタイルです。',

## themes/rainier/templates/banner_footer.mtml
	'This blog is licensed under a <a rel="license" href="[_1]">Creative Commons License</a>.' => 'このブログは<a rel="license" href="[_1]">クリエイティブ・コモンズ</a>でライセンスされています。',

## themes/rainier/templates/category_archive_list.mtml

## themes/rainier/templates/category_entry_listing.mtml
	'Pagination' => 'ページネーション',
	'Related Contents' => '関連コンテンツ',

## themes/rainier/templates/comment_detail.mtml

## themes/rainier/templates/comment_form.mtml
	'Post a Comment' => 'コメントの投稿',
	'Reply to comment' => 'コメントの返信',

## themes/rainier/templates/comment_preview.mtml

## themes/rainier/templates/comment_response.mtml

## themes/rainier/templates/comments.mtml

## themes/rainier/templates/dynamic_error.mtml

## themes/rainier/templates/entry.mtml
	'Posted on [_1]' => '投稿日:[_1]',
	'by [_1]' => 'by [_1]',
	'in [_1]' => 'カテゴリ: [_1]',
	'Previous entry' => '前の記事',
	'Next entry' => '次の記事',
	'Zenback' => 'Zenback',

## themes/rainier/templates/entry_summary.mtml
	'Continue reading' => 'ブログ記事を読む',

## themes/rainier/templates/javascript.mtml

## themes/rainier/templates/javascript_theme.mtml
	'Menu' => 'メニュー',

## themes/rainier/templates/main_index.mtml

## themes/rainier/templates/monthly_archive_dropdown.mtml

## themes/rainier/templates/monthly_archive_list.mtml

## themes/rainier/templates/monthly_entry_listing.mtml

## themes/rainier/templates/navigation.mtml
	'About' => 'アバウト',

## themes/rainier/templates/page.mtml
	'Last update' => '更新日',

## themes/rainier/templates/pages_list.mtml

## themes/rainier/templates/pagination.mtml
	'Older entries' => '過去の記事',
	'Newer entries' => '新しい記事',

## themes/rainier/templates/recent_comments.mtml
	'[_1] on <a href="[_2]" title="full comment on: [_3]">[_3]</a>' => '[_1] から <a href="[_2]" title="[_3] のコメントを見る">[_3]</a>',

## themes/rainier/templates/recent_entries.mtml

## themes/rainier/templates/search.mtml

## themes/rainier/templates/search_results.mtml

## themes/rainier/templates/syndication.mtml

## themes/rainier/templates/tag_cloud.mtml

## themes/rainier/templates/trackbacks.mtml
	'<a href="[_1]">[_2]</a> - [_3]</a>' => '<a href="[_1]">[_2]</a> - [_3]</a>',

## themes/rainier/templates/zenback.mtml
	'Please paste Zenback script code here.' => 'ここに Zenback の Script コードは貼り付けてください。',

## themes/rainier/theme.yaml
	'"Rainier" is a customizable Responsive Web Design theme, designed for blogs. In addition to multi-device viewing support, provided via Media Query (CSS), Movable Type functions make customizing navigational contents as well as image elements, such as logos, headers, very simple.' => 'Rainier はレスポンシブ Web デザインを採用したブログテーマです。Media Query (CSS) を利用したマルチデバイス対応に加え、Movable Type の機能を使ってロゴやナビゲーションの内容を簡単にカスタマイズできます。',
	'About Page' => 'アバウトページ',
	'_ABOUT_PAGE_BODY' => '<p>このページはアバウトページ (自己紹介や会社概要など、プロフィール用のページ) として利用するウエブページの例です。</p><p>作成したウェブページに <code>@ABOUT_PAGE</code> というタグを設定すると、ページのヘッダ、フッタにあるナビゲーションにリンクが追加されます。</p>',
	'Example page' => 'ウェブページの例',
	'_SAMPLE_PAGE_BODY' => '<p>このページはウェブページの例です。</p><p>作成したウェブページに <code>@ADD_TO_SITE_NAV</code> というタグを設定すると、ページのヘッダ、フッタにあるナビゲーションにリンクが追加されます。</p>',
	'Rainier' => 'Rainier',
	'Styles for Rainier' => 'Rainier スタイル',
	'A collection of styles compatible with Rainier themes.' => 'Rainier のデフォルトテンプレートと互換性のあるスタイルです。',
	'Stylesheet for IE (8 or lower)' => 'スタイルシート (IE8 以下用)',
	'JavaScript - Theme' => 'JavaScript - テーマ',

## search_templates/comments.tmpl
	'Search for new comments from:' => 'コメントを検索:',
	'the beginning' => '最初から',
	'one week ago' => '1週間前',
	'two weeks ago' => '2週間前',
	'one month ago' => '1か月前',
	'two months ago' => '2か月前',
	'three months ago' => '3か月前',
	'four months ago' => '4か月前',
	'five months ago' => '5か月前',
	'six months ago' => '6か月前',
	'one year ago' => '1年前',
	'Find new comments' => '新しいコメントを検索',
	'Posted in [_1] on [_2]' => '[_2]の[_1]に投稿されたコメント',
	'No results found' => 'ありません',
	'No new comments were found in the specified interval.' => '指定された期間にコメントはありません。',
	q{Select the time interval that you'd like to search in, then click 'Find new comments'} => q{検索したい期間を選択して、コメントを検索をクリックしてください。},

## search_templates/default.tmpl
	'SEARCH FEED AUTODISCOVERY LINK IS PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => '検索結果のフィードのAuto Discoveryリンクは検索が実行されたときのみ表示されます。',
	'Blog Search Results' => 'Blog Searchの結果',
	'Blog search' => 'Blog Search',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => '通常の検索では検索クエリ用のフォームを返す',
	'Search this site' => 'このブログを検索',
	'Match case' => '大文字小文字を区別する',
	'SEARCH RESULTS DISPLAY' => '検索結果表示',
	'Matching entries from [_1]' => 'ブログ[_1]での検索結果',
	q{Entries from [_1] tagged with '[_2]'} => q{ブログ[_1]の'[_2]'タグのブログ記事},
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => '<MTIfNonEmpty tag="EntryAuthorDisplayName">[_1]</MTIfNonEmpty> - ([_2])',
	'Showing the first [_1] results.' => '最初の[_1]件の結果を表示',
	'NO RESULTS FOUND MESSAGE' => '検索結果がないときのメッセージ',
	q{Entries matching '[_1]'} => q{'[_1]'で検索されたブログ記事},
	q{Entries tagged with '[_1]'} => q{'[_1]'タグのブログ記事},
	q{No pages were found containing '[_1]'.} => q{'[_1]'が含まれるページはありません。},
	'END OF ALPHA SEARCH RESULTS DIV' => '検索結果のDIV(ALPHA)ここまで',
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'ここから検索情報を表示するBETA SIDEBAR',
	'SET VARIABLES FOR SEARCH vs TAG information' => '検索またはタグ情報を変数に代入',
	q{If you use an RSS reader, you can subscribe to a feed of all future entries tagged '[_1]'.} => q{RSSリーダーを使うと、'[_1]'タグのすべてのブログ記事のフィードを購読することができます。},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries matching '[_1]'.} => q{RSSリーダーを使うと、'[_1]'を含むすべてのブログ記事のフィードを購読することができます。},
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => '検索/タグのフィード購読情報',
	'Feed Subscription' => '購読',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.jp/about/feeds.html',
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
	q{Don't compress} => q{圧縮しない},
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
	'Text Formatting' => 'テキストフォーマット',
	'Specifies the default Text Formatting option when creating a new entry.' => 'テキストフォーマットの既定値を指定します。',
	'Specifies the default Accept Comments setting when creating a new entry.' => '既定でコメントを許可する',
	'Setting Ignored' => '設定は無視されます',
	'Note: This option is currently ignored since comments are disabled either blog or system-wide.' => '注: ブログまたはシステム全体でコメントが無効なためこのオプションは無視されます。',
	'Specifies the default Accept TrackBacks setting when creating a new entry.' => '既定でトラックバックを許可する',
	'Accept TrackBacks' => 'トラックバック許可',
	'Note: This option is currently ignored since TrackBacks are disabled either blog or system-wide.' => '注: ブログまたはシステム全体の設定でトラックバックが無効なためこのオプションは無視されます。',
	'Entry Fields' => '記事フィールド',
	'_USAGE_ENTRYPREFS' => 'ブログ記事の編集画面で表示する項目のセットを選択してください。',
	'Page Fields' => 'ページフィールド',
	'WYSIWYG Editor Setting' => 'WYSIWYGエディタの設定',
	'Content CSS' => 'コンテンツCSSファイル',
	'Content CSS will be applied when WYSIWYG editor does support. You can specify CSS file by URL or {{theme_static}} placeholder. Example: {{theme_static}}path/to/cssfile.css' => 'WYSIWYGエディタ内で利用するCSSファイルのURL又は、{{theme_static}}変数を利用したURLを指定する事ができます。WYSIWYGエディタが対応していない場合は適用されません。例: {{theme_static}}path/to/cssfile.css',
	'Punctuation Replacement Setting' => 'Word特有の文字を置き換える',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'ワープロソフトで使われるUTF-8文字を対応する表示可能な文字に置き換えます。',
	'Punctuation Replacement' => '句読点置き換え',
	'No substitution' => '置き換えない',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'エンティティ (&amp#8221;、&amp#8220;など)',
	q{ASCII equivalents (&quot;, ', ..., -, --)} => q{対応するASCII文字 (&quot;、'、...、-、--)},
	'Replace Fields' => '置き換えるフィールド',
	'Save changes to these settings (s)' => '設定を保存 (s)',

## tmpl/cms/cfg_feedback.tmpl
	'Feedback Settings' => 'コミュニケーション設定',
	'Spam Settings' => 'スパム設定',
	'Automatic Deletion' => '自動削除設定',
	'Automatically delete spam feedback after the time period shown below.' => 'スパムと判断したものを指定の日数経過後に削除する',
	'Delete Spam After' => 'スパムを削除する',
	'When an item has been reported as spam for this many days, it is automatically deleted.' => 'スパムと判断したものを、指定した日数の後に削除します。',
	'days' => '日',
	'Spam Score Threshold' => 'スパム判断基準',
	'Comments and TrackBacks receive a spam score between -10 (complete spam) and +10 (not spam). Feedback with a score which is lower than the threshold shown above will be reported as spam.' => '受信したコメントとトラックバックは、-10 (迷惑度: 最大)から +10 (迷惑度: ゼロ)までの範囲で評価されます。指定した判断基準より低い値のコメントとトラックバックはスパムと見なされます。',
	'Less Aggressive' => 'より緩やかに',
	'Decrease' => '減らす',
	'Increase' => '増やす',
	'More Aggressive' => 'より厳しく',
	q{Apply 'nofollow' to URLs} => q{URLのnofollow指定},
	q{If enabled, all URLs in comments and TrackBacks will be assigned a 'nofollow' link relation.} => q{コメントとトラックバックに含まれるすべてのURLにnofollowを設定する},
	q{'nofollow' exception for trusted commenters} => q{nofollow除外},
	q{Do not add the 'nofollow' attribute when a comment is submitted by a trusted commenter.} => q{承認されたコメント投稿者のコメントにはnofollowを適用しない},
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
	'No CAPTCHA provider available' => 'CAPTCHAプロバイダがありません',
	q{No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the 'mt-static/images' directory.} => q{CAPTCHAプロバイダがありません。Image:：Magickがインストールされているか、またCaptchaSourceImageBaseが正しく設定されていてmt-static/images/captcha-sourceにアクセスできるか確認してください。},
	'Use Comment Confirmation Page' => 'コメントの確認ページ',
	'Use comment confirmation page' => 'コメントの確認ページを有効にする',
	q{Each commenter's browser will be redirected to a comment confirmation page after their comment is accepted.} => q{コメント投稿後に、コメント完了ページを表示する},
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
	'Plugin System' => 'プラグインシステム',
	'Enable or disable plugin functionality for the entire Movable Type installation.' => 'プラグインの利用をシステムレベルで設定します。',
	'Disable plugin functionality' => 'プラグインの機能を無効化する',
	'Disable Plugins' => 'プラグインを利用しない',
	'Enable plugin functionality' => 'プラグインの機能を有効化する',
	'Enable Plugins' => 'プラグインを利用する',
	'_PLUGIN_DIRECTORY_URL' => 'http://communities.movabletype.jp/plugins/',
	'Find Plugins' => 'プラグインを探す',
	'Your plugin settings have been saved.' => 'プラグインの設定を保存しました。',
	'Your plugin settings have been reset.' => 'プラグインの設定をリセットしました。',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you must restart your web server for these changes to take effect.} => q{プラグインの設定が変更されました。mod_perlを利用している場合は、設定変更を有効にするためにウェブサーバーを再起動する必要があります。},
	'Your plugins have been reconfigured.' => 'プラグインを再設定しました。',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you will need to restart your web server for these changes to take effect.} => q{プラグインを再設定しました。mod_perl環境下でお使いの場合は、設定を反映させるためにウェブサーバーを再起動してください。},
	'Are you sure you want to reset the settings for this plugin?' => 'このプラグインの設定を元に戻しますか?',
	'Are you sure you want to disable plugins for the entire Movable Type installation?' => 'システム全体で、プラグインを無効にしますか?',
	'Are you sure you want to disable this plugin?' => 'プラグインを無効にしますか?',
	'Are you sure you want to enable plugins for the entire Movable Type installation? (This will restore plugin settings that were in place before all plugins were disabled.)' => 'システム全体で、プラグインを有効にしますか? (各プラグインの設定は、システム全体で無効化される前の状態に戻ります)',
	'Are you sure you want to enable this plugin?' => 'プラグインを有効にしますか?',
	'Settings for [_1]' => '[_1]の設定',
	'Failed to Load' => '読み込みに失敗しました',
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
	'Language' => '使用言語',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'グローバルなDefaultLanguage設定と異なる言語を選んだ場合、グローバルテンプレートの名称が異なるため、テンプレート内で読み込むモジュール名の変更が必要な場合があります。',
	'License' => 'ライセンス',
	'Your blog is currently licensed under:' => 'このブログは、次のライセンスで保護されています:',
	'Change license' => 'ライセンスの変更',
	'Remove license' => 'ライセンスの削除',
	'Your blog does not have an explicit Creative Commons license.' => 'クリエイティブ・コモンズライセンスを指定していません。',
	'Select a license' => 'ライセンスの選択',
	'Publishing Paths' => '公開パス',
	'[_1] URL' => '[_1]URL',
	'Use subdomain' => 'サブドメインの利用',
	'Warning: Changing the [_1] URL can result in breaking all the links in your [_1].' => '警告:[_1]URLを変更すると[_1]内の全てのリンクがリンク切れとなることがあります。',
	q{The URL of your blog. Exclude the filename (i.e. index.html). End with '/'. Example: http://www.example.com/blog/} => q{ブログを公開するURLです。ファイル名(index.htmlなど)は含めず、末尾は'/'で終わります。例: http://www.example.com/blog/},
	q{The URL of your website. Exclude the filename (i.e. index.html).  End with '/'. Example: http://www.example.com/} => q{ウェブサイトを公開するURLです。ファイル名(index.htmlなど)は含めず、末尾は'/'で終わります。 例: http://www.example.com/},
	'[_1] Root' => '[_1]パス',
	'Use absolute path' => '絶対パスの利用',
	'Warning: Changing the [_1] root requires a complete publish of your [_1].' => '警告:[_1]パスを変更した場合には[_1]の再構築が必要です。',
	q{The path where your index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{インデックスファイルが公開されるパスです。末尾には'/'や'\'を含めません。},
	q{The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{インデックスファイルが公開されるパスです。絶対パス(Linuxの時は'/'、Windowsの時は'C:\'などで始まる)を推奨しますが、Movable Typeディレクトリからの相対パスも指定できます。末尾には'/'や'\'を含めません。例: /home/melody/public_html/blogやC:\www\public_html\blog},
	'Advanced Archive Publishing' => '高度な公開の設定',
	'Select this option only if you need to publish your archives outside of your Blog Root.' => 'アーカイブをサイトパス以外で公開するときにこのオプションを選択してください。',
	'Publish archives outside of Blog Root' => 'アーカイブをブログパスとは別のパスで公開する',
	'Archive URL' => 'アーカイブURL',
	'The URL of the archives section of your blog. Example: http://www.example.com/blog/archives/' => 'ブログのアーカイブのURLです。例: http://www.example.com/blog/archives/',
	'Warning: Changing the archive URL can result in breaking all the links in your blog.' => '警告: アーカイブURLを変更することでブログ上のすべてのリンクがリンク切れとなる場合があります。',
	'Warning: Changing the archive path can result in breaking all the links in your blog.' => '警告: アーカイブパスを変更するとブログ上のすべてのリンクがリンク切れとなる場合があります。',
	q{The path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{アーカイブのインデックスファイルが公開されるパスです。ウェブサイトからの相対パスを指定します。末尾には'/'や'\'を含めません。},
	q{The path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{アーカイブのインデックスファイルが公開されるパスです。絶対パス(Linuxの時は'/'、Windowsの時は'C:\'などで始まる)を推奨しますが、Movable Typeディレクトリからの相対パスも指定できます。末尾には'/'や'\'を含めません。例: /home/melody/public_html/blogやC:\www\public_html\blog},
	'Dynamic Publishing Options' => 'ダイナミックパブリッシング設定',
	'Enable dynamic cache' => 'キャッシュする',
	'Enable conditional retrieval' => '条件付き取得を有効にする',
	'Archive Settings' => 'アーカイブ設定',
	q{Enter the archive file extension. This can take the form of 'html', 'shtml', 'php', etc. Note: Do not enter the leading period ('.').} => q{アーカイブファイルの拡張子を指定してください。html、shtml、phpなどを指定できます。ピリオドは入力しないでください。},
	'Preferred Archive' => '優先アーカイブタイプ',
	q{Used to generate URLs (permalinks) for this blog's archived entries. Choose one of the archive type used in this blog's archive templates.} => q{ブログ記事にリンクするときのURLとして使われます。このブログで使われているアーカイブテンプレートの中から選択してください。},
	'Choose archive type' => 'アーカイブタイプを選択してください',
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
	'Revision History' => '更新履歴',
	'Note: Revision History is currently disabled at the system level.' => '備考: 更新履歴は現在システムレベルで無効となっています。',
	'Revision history' => '更新履歴',
	'Enable revision history' => '更新履歴を有効にする',
	'Number of revisions per entry/page' => '記事/ページ更新履歴数',
	'Number of revisions per page' => 'ページ更新履歴数',
	'Number of revisions per template' => 'テンプレート更新履歴数',
	'You must set your Blog Name.' => 'ブログ名を設定してください。',
	'You did not select a time zone.' => 'タイムゾーンが選択されていません。',
	'You must set a valid URL.' => '有効なURLを指定してください。',
	'You must set your Local file Path.' => 'ファイルパスを指定する必要があります。',
	'You must set a valid Local file Path.' => '有効なファイルパスを指定してください。',
	'Website root must be under [_1]' => 'ウェブサイトパスは [_1] 以下を指定してください。',
	'You must set a valid Archive URL.' => '有効なアーカイブURLを指定してください。',
	'You must set your Local Archive Path.' => 'アーカイブパスを指定する必要があります。',
	'You must set a valid Local Archive Path.' => '有効なアーカイブパスを指定してください。',

## tmpl/cms/cfg_registration.tmpl
	'Registration Settings' => '登録/認証の設定',
	'Your blog preferences have been saved.' => 'ブログの設定を保存しました。',
	'User Registration' => 'ユーザー登録',
	'Allow registration for this website.' => 'ウェブサイトへの登録を許可します。',
	'Registration Not Enabled' => 'ユーザー登録は無効です。',
	'Note: Registration is currently disabled at the system level.' => '注:ユーザー登録は現在システムレベルで無効となっています。',
	'Allow visitors to register as members of this website using one of the Authentication Methods selected below.' => 'ウェブサイトの訪問者が、以下で選択した認証方式でユーザー登録することを許可する',
	'New Created User' => '新規ユーザー',
	'Select a role that you want assigned to users that are created in the future.' => 'これから作成されるユーザーに割り当てられるロールを選択します。',
	'(No role selected)' => '(ロールが選択されていません)',
	'Select roles' => 'ロール選択',
	'Authentication Methods' => '認証方式',
	'Please select authentication methods to accept comments.' => 'コメント投稿者の認証方式を選択してください。',
	'Require E-mail Address for Comments via TypePad' => 'TypePad経由のコメントにメールアドレスを要求する',
	'Visitors must allow their TypePad account to share their e-mail address when commenting.' => 'ビジターはコメント時にメールアドレスを共有するのにTypePadアカウントが許可されています。',
	'One or more Perl modules may be missing to use this authentication method.' => '認証を利用するのに必要なPerlモジュールが見つかりませんでした。',
	'Setup TypePad token' => 'TypePadの設定',

## tmpl/cms/cfg_system_general.tmpl
	'Your settings have been saved.' => '設定を保存しました。',
	'A test mail was sent.' => 'テストメールを送信しました。',
	'(None selected)' => '(選択されていません)',
	'System Email Address' => 'システムメールアドレス',
	'Send Test Mail' => 'テストメールの送信',
	q{This email address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events.} => q{このメールアドレスはMovable Typeから送られるメールの'From:'アドレスに利用されます。メールはパスワードの再設定、コメント投稿者の登録、コメントやトラックバックの通知、ユーザーまたはIPアドレスのロックアウト、その他の場合に送信されます。},
	'Debug Mode' => 'デバッグモード',
	'Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="http://www.movabletype.org/documentation/developer/plugins/debug-mode.html">Debug Mode documentation</a>.' => '開発者向けの設定です。0以外の数字を設定すると、Movable Typeのデバッグメッセージを表示します。詳しくは<a href="http://www.movabletype.jp/documentation/appendices/config-directives/debugmode.html">ドキュメントを参照</a>してください。',
	'Performance Logging' => 'パフォーマンスログ',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified by Logging Threshold.' => 'パフォーマンスログを有効にして、ログ閾値で設定した秒数より時間のかかる処理をログに記録します。',
	'Turn on performance logging' => 'パフォーマンスログを有効にする',
	'Log Path' => 'ログパス',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'パフォーマンスログを書き出すフォルダです。ウェブサーバーから書き込み可能な場所を指定してください。',
	'Logging Threshold' => 'ログ閾値',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => '指定した秒数以上、時間がかかった処理をログに記録します。',
	'Enable this setting to have Movable Type track revisions made by users to entries, pages and templates.' => 'この設定を有効にすると、記事、ページ、テンプレートの変更履歴を保存します。',
	'Track revision history' => '変更履歴を保存する',
	'Site Path Limitation' => 'ウェブサイトパスの制限',
	'Base Site Path' => 'ウェブサイトパスの規定値',
	'Allow sites to be placed only under this directory' => 'ウェブサイトパスの作成を行えるディレクトリを指定します。',
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
	'Lockout Settings' => 'アカウントロックの設定',
	q{The system administrators whom you wish to notify if a user or an IP address is locked out.  If no administrators are selected, notifications will be sent to the 'System Email' address.} => q{通知メールを受信するシステム管理者を設定できます。受信者の設定がされていない場合は、'システムのメールアドレス'宛に通知されます。},
	'Clear' => 'クリア',
	'Select' => '選択',
	'User lockout policy' => 'ユーザーのロック方針',
	'A Movable Type user will be locked out if he or she submits an incorrect password [_1] or more times within [_2] seconds.' => 'MTユーザーが、[_2] 秒間に [_1] 回以上サインインに失敗した場合、そのユーザーのサインインを禁止します。',
	'IP address lockout policy' => 'IPアドレスのロック方針',
	'An IP address will be locked out if [_1] or more incorrect login attempts are made within [_2] seconds from the same IP address.' => '同一IPアドレスから、[_2] 秒間に [_1] 回以上サインインに失敗した場合、そのIPアドレスからのアクセスを禁止します。',
	q{However, the following IP addresses are 'whitelisted' and will never be locked out:} => q{次の一覧で設定されたIPアドレスはアクセスが禁止されることはありません。},
	'The list of IP addresses. If a remote IP address is included in this list, the failed login will not recorded. You can specify multiple IP addresses separated by commas or line breaks.' => '特定のIPアドレスについて判定を行わない場合、上の一覧にカンマ又は改行区切りで追加してください。',
	'Send Mail To' => 'メール送信先',
	'The email address that should receive a test email from Movable Type.' => 'テストメールを受け取るメールアドレス',
	'Send' => '送信',
	'You must set a valid absolute Path.' => '正しい絶対パスを設定してください。',

## tmpl/cms/cfg_system_users.tmpl
	'User Settings' => 'ユーザー設定',
	'(No website selected)' => '(ウェブサイトが選択されていません)',
	'Select website' => 'ウェブサイト選択',
	'Allow Registration' => '登録',
	'Select a system administrator you wish to notify when commenters successfully registered themselves.' => 'コメント投稿者が登録したことを知らせたいシステム管理者を選択してください。',
	'Allow commenters to register with blogs on this system.' => 'コメント投稿者がMovable Typeに登録することを許可する',
	'Notify the following system administrators when a commenter registers:' => '以下のシステム管理者に登録を通知する:',
	'Select system administrators' => 'システム管理者選択',
	'Note: System Email Address is not set in System > General Settings. Emails will not be sent.' => 'システムのメールアドレスが設定されていないため、メールは送信されません。「設定 &gt; 全般」から設定してください。',
	'Password Validation' => 'パスワードの検証ルール',
	'Options' => 'オプション',
	'Should contain uppercase and lowercase letters.' => '大文字と小文字を含める必要があります。',
	'Should contain letters and numbers.' => '文字と数字を含める必要があります。',
	'Should contain special characters.' => '記号を含める必要があります。',
	'Minimun Length' => '最低文字数',
	'This field must be a positive integer.' => 'このフィールドは0以上の整数を指定してください。',
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
	q{Please click the 'Save Changes' button below to enable TypePad.} => q{TypePadを利用するために'保存'ボタンをクリックしてください。},
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
	'The support directory is not writable.' => 'サポートディレクトリに書き込めません。',
	q{Movable Type was unable to write to its 'support' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.} => q{サポートディレクトリに書き込みできません。[_1]にディレクトリを作成して、ウェブサーバーから書き込みできるパーミッションを与えてください。},
	'ImageDriver is not configured.' => 'イメージドライバーが設定されていません。',
	'An image processing toolkit, often specified by the ImageDriver configuration directive, is not present on your server or is configured incorrectly. A toolkit must be installed to ensure proper operation of the userpics feature. Please install Image::Magick, NetPBM, GD, or Imager, then set the ImageDriver configuration directive accordingly.' => 'ImageDriverに設定された画像処理ツールが存在しないかまたは正しく設定されていないため、Movable Typeのユーザー画像機能を利用できません。この機能を利用するには、Image::Magick、NetPBM、GD、Imagerのいずれかをインストールする必要があります。',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Confirm Publishing Configuration' => '公開設定',
	'Site Path' => 'サイトパス',
	'Parent Website' => '上位ウェブサイト',
	'Please choose parent website.' => '上位ウェブサイトを選択してください。',
	q{Enter the new URL of your public blog. End with '/'. Example: http://www.example.com/blog/} => q{新しいブログURLを入力してください。末尾は'/'で終わります。例: http://www.example.com/blog/},
	'Blog Root' => 'ブログパス',
	q{Enter the new path where your main index file will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{新しくインデックスファイルを公開するパスを入力して下さい。末尾には'/'や'\'を含めません。例: /home/mt/public_html/blog or C:\www\public_html\blog},
	q{Enter the new path where your main index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{新しくインデックスファイルを公開するパスを入力して下さい。絶対パス(Linuxの時は'/'、Windowsの時は'C:\'などで始まる)を推奨します。末尾には'/'や'\'を含めません。例: /home/mt/public_html/blog or C:\www\public_html\blog},
	'Enter the new URL of the archives section of your blog. Example: http://www.example.com/blog/archives/' => '新しいブログのアーカイブURLを入力してください。例: http://www.example.com/blog/archives/',
	q{Enter the new path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{新しくアーカイブのインデックスファイルを公開するパスを入力して下さい。末尾には'/'や'\'を含めません。例: /home/mt/public_html/blog or C:\www\public_html\blog},
	q{Enter the new path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{新しくアーカイブのインデックスファイルを公開するパスを入力して下さい。絶対パス(Linuxの時は'/'、Windowsの時は'C:\'などで始まる)を推奨します。末尾には'/'や'\'を含めません。例: /home/mt/public_html/blog or C:\www\public_html\blog},
	'Continue (s)' => '次へ (s)',
	'Back (b)' => '戻る (b)',
	'You must set a valid Site URL.' => '有効なサイトURLを指定してください。',
	'You must set a valid local site path.' => '有効なサイトパスを指定してください。',
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
	'Use thumbnail' => 'サムネイルを利用',
	'width:' => '幅:',
	'pixels' => 'ピクセル',
	'Alignment' => '位置',
	'Left' => '左',
	'Center' => '中央',
	'Right' => '右',
	'Link image to full-size version in a popup window.' => 'ポップアップウィンドウで元の大きさの画像にリンクします。',
	'Remember these settings' => '設定を記憶',

## tmpl/cms/dialog/asset_replace.tmpl

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'ブログを設定する必要があります。',
	'Your blog has not been published.' => 'ブログが公開されていません。',

## tmpl/cms/dialog/clone_blog.tmpl
	'Blog Details' => 'ブログの詳細',
	'This is set to the same URL as the original blog.' => '複製元のブログと同じURLを設定します。',
	'This will overwrite the original blog.' => '複製元のブログ設定を上書きします。',
	'Exclusions' => '除外',
	'Exclude Entries/Pages' => '記事/ページの除外',
	'Exclude Comments' => 'コメントの除外',
	'Exclude Trackbacks' => 'トラックバックの除外',
	'Exclude Categories/Folders' => 'カテゴリ/フォルダの除外',
	'Clone' => '複製',
	'Mark the settings that you want cloning to skip' => '複製を行わない設定にマークをつけてください',
	'Entries/Pages' => '記事/ページ',
	'Categories/Folders' => 'カテゴリ/フォルダ',
	'Confirm' => '確認',

## tmpl/cms/dialog/comment_reply.tmpl
	'On [_1], [_2] commented on [_3]' => '[_2]から[_3]へのコメント([_1])',
	'Your reply:' => '返信',
	'Submit reply (s)' => '返信を投稿 (s)',

## tmpl/cms/dialog/create_association.tmpl
	'No roles exist in this installation. [_1]Create a role</a>' => 'ロールがありません。[_1]ロールを作成する</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'グループがありません。[_1]グループを作成する</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'ユーザーが存在しません。[_1]ユーザーを作成する</a>',
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'ブログがありません。[_1]ブログを作成する</a>',

## tmpl/cms/dialog/entry_notify.tmpl
	'Send a Notification' => '通知の送信',
	'You must specify at least one recipient.' => '少なくとも一人の受信者を指定する必要があります。',
	q{Your [_1]'s name, title, and a link to view it will be sent in the notification. Additionally, you can add a message, include an excerpt and/or send the entire body.} => q{[_1]名、タイトル、およびパーマリンクが送られます。メッセージを追加したり、概要や本文を送ることもできます。},
	'Recipients' => 'あて先',
	'Enter email addresses on separate lines or separated by commas.' => '1行に1メールアドレス、またはコンマでメールアドレスを区切り、入力します。',
	'All addresses from Address Book' => 'アドレス帳のすべての連絡先',
	'Optional Message' => 'メッセージ(任意)',
	'Optional Content' => 'コンテンツ(任意)',
	'(Body will be sent without any text formatting applied.)' => '(フォーマットされずに本文が送られます)',
	'Send notification (s)' => '通知を送信 (s)',

## tmpl/cms/dialog/list_revision.tmpl
	'Select the revision to populate the values of the Edit screen.' => '編集画面に読み込む更新履歴を選んでください。',

## tmpl/cms/dialog/move_blogs.tmpl
	'Warning: You need to copy uploaded assets to the new path manually. It is also recommended not to delete files in the old path to avoid broken links.' => '警告: アップロード済みのファイルは、新しいウェブサイトのパスに手動でコピーする必要があります。また、旧パスのファイルも残すことで、リンク切れを防止できます。',

## tmpl/cms/dialog/new_password.tmpl
	'Change Password' => 'パスワードの変更',
	'Enter the new password.' => '新しいパスワードを入力してください。',
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
	'This new publishing profile will update your publishing settings.' => '公開プロファイルの設定内容を使って、すべてのテンプレートの設定を更新します。',
	'Are you sure you wish to continue?' => '続けてもよろしいですか?',

## tmpl/cms/dialog/recover.tmpl
	'Reset Password' => 'パスワードのリセット',
	'The email address provided is not unique.  Please enter your username.' => '同じメールアドレスを持っているユーザーがいます。ユーザー名を入力してください。',
	'An email with a link to reset your password has been sent to your email address ([_1]).' => '「[_1]」にパスワードをリセットするためのリンクを含むメールを送信しました。',
	'Back (x)' => '戻る (x)',
	'Sign in to Movable Type (s)' => 'Movable Type にサインイン (s)',
	'Sign in to Movable Type' => 'Movable Type にサインイン',
	'Reset (s)' => 'リセット (s)',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Refresh Global Templates' => 'グローバルテンプレートを初期化',
	'Cannot find template set. Please apply [_1]theme[_2] to refresh your templates.' => 'テンプレートセットが見つかりません。[_1]テーマを適用[_2]して、テンプレートを初期化してください。',
	'Revert modifications of theme templates' => 'テーマテンプレートの変更の取り消し',
	'Reset to theme defaults' => 'デフォルトテーマのリセット',
	q{Deletes all existing templates and install the selected theme's default.} => q{全テンプレートを削除して、既定となっているテーマをインストールします。},
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

## tmpl/cms/dialog/select_association_type.tmpl
	'Grant website permission to user' => 'ユーザーにウェブサイトの権限を割り当てる',
	'Grant blog permission to user' => 'ユーザーにブログの権限を割り当てる',
	'Grant website permission to group' => 'グループにウェブサイトの権限を割り当てる',
	'Grant blog permission to group' => 'グループにブログの権限を割り当てる',

## tmpl/cms/dialog/select_theme.tmpl
	'Select Personal blog theme' => '個人用ブログテーマの選択',

## tmpl/cms/dialog/theme_element_detail.tmpl

## tmpl/cms/edit_asset.tmpl
	'Edit Asset' => 'アイテムの編集',
	'Your changes have been saved.' => '変更を保存しました。',
	'Stats' => '情報',
	'[_1] - Created by [_2]' => '作成: [_2] - [_1]',
	'[_1] - Modified by [_2]' => '更新: [_2] - [_1]',
	'Appears in...' => '利用状況',
	'This asset has been used by other users.' => 'このアイテムは、他のユーザーにより利用されています。',
	'Related Assets' => '関連するアイテム',
	'[_1] is missing' => '[_1]がありません。',
	'Embed Asset' => 'アイテムの埋め込み',
	'Save changes to this asset (s)' => 'アイテムへの変更を保存 (s)',
	'You must specify a name for the asset.' => 'アイテムに名前を設定してください。',

## tmpl/cms/edit_author.tmpl
	'Edit Profile' => 'ユーザー情報の編集',
	'This profile has been updated.' => 'ユーザー情報を更新しました。',
	'A new password has been generated and sent to the email address [_1].' => '新しいパスワードが作成され、メールアドレス[_1]に送信されました。',
	'This profile has been unlocked.' => 'ユーザーアカウントのロックが解除されました。',
	'This user was classified as pending.' => 'このユーザーは保留中にされています。',
	'This user was classified as disabled.' => 'このユーザーは無効にされています。',
	'This user was locked out.' => 'このユーザーはロックされています。',
	q{If you want to unlock this user click the 'Unlock' link. <a href="[_1]">Unlock</a>} => q{<a href="[_1]">ロックを解除する</a>},
	'User properties' => 'ユーザー属性',
	'Your web services password is currently' => 'Webサービスのパスワード',
	'_WARNING_PASSWORD_RESET_SINGLE' => '[_1]のパスワードを再設定しようとしています。新しいパスワードはランダムに生成され、ユーザーにメールで送信されます。続行しますか?',
	'Error occurred while removing userpic.' => 'プロフィール画像の削除中にエラーが発生しました。',
	'_USER_STATUS_CAPTION' => '状態',
	'Status of user in the system. Disabling a user prevents that person from using the system but preserves their content and history.' => '無効にされたユーザーはシステムを利用できませんが、コンテンツと履歴は保持されます。',
	'_USER_ENABLED' => '有効',
	'_USER_PENDING' => '保留',
	'_USER_DISABLED' => '無効',
	'The username used to login.' => 'サインイン時に使用するユーザー名です。',
	'External user ID' => '外部ユーザーID',
	'The name displayed when content from this user is published.' => 'コンテンツの公開時に、この名前が表示されます。',
	'The email address associated with this user.' => 'ユーザーのメールアドレスです。',
	q{This User's website (e.g. http://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.} => q{ユーザーの個人ホームページのURL。表示する名前とウェブサイトURLは、コンテンツやコメントの公開時に利用されます。},
	'The image associated with this user.' => 'ユーザーのプロフィール画像です。',
	'Select Userpic' => 'プロフィール画像の選択',
	'Remove Userpic' => 'プロフィール画像を削除',
	'Current Password' => '現在のパスワード',
	'Existing password required to create a new password.' => 'パスワード変更には現在のパスワードが必要です。',
	'Initial Password' => '初期パスワード',
	'Enter preferred password.' => '新しいパスワードを入力してください。',
	'Confirm Password' => 'パスワード確認',
	'Repeat the password for confirmation.' => '確認のため、パスワードを再入力してください。',
	'Password recovery word/phrase' => 'パスワード再設定用のフレーズ',
	'This word or phrase is not used in the password recovery.' => 'パスワード再設定用のフレーズは使用されていません。',
	'Preferences' => '設定',
	'Display language for the Movable Type interface.' => '管理画面で使用する言語です。',
	'Text Format' => 'テキスト形式',
	'Default text formatting filter when creating new entries and new pages.' => 'ブログ記事とウェブページを作成する際のテキスト形式を指定します。',
	'(Use Website/Blog Default)' => '(ウェブサイト/ブログの既定値を利用)',
	'Date Format' => '日付',
	'Default date formatting in the Movable Type interface.' => '管理画面で使用する日付の表示フォーマットです。',
	'Relative' => '経過',
	'Full' => '年月日',
	'Tag Delimiter' => 'タグの区切り',
	'Preferred method of separating tags.' => 'タグを区切るときに使う文字を選択します。',
	'Web Services Password' => 'Webサービスパスワード',
	'For use by Activity feeds and with XML-RPC and Atom-enabled clients.' => 'ログフィードやXML-RPC、Atom APIで利用するパスワードです。',
	'Reveal' => '内容を表示',
	'System Permissions' => 'システム権限',
	'Create personal blog for user' => '個人用のブログを作成する',
	'Create User (s)' => 'ユーザーを作成 (s)',
	'Save changes to this author (s)' => 'ユーザーへの変更を保存 (s)',
	'_USAGE_PASSWORD_RESET' => 'ユーザーのパスワードを再設定できます。パスワードがランダムに生成され、[_1]にメールで送信されます。',
	'Initiate Password Recovery' => 'パスワードの再設定',

## tmpl/cms/edit_blog.tmpl
	'Create Blog' => 'ブログの作成',
	'Your blog configuration has been saved.' => 'ブログの設定を保存しました。',
	'Blog Theme' => 'ブログテーマ',
	'Select the theme you wish to use for this blog.' => 'このブログで利用するテーマを選択してください。',
	'Name your blog. The blog name can be changed at any time.' => 'ブログ名を付けてください。この名前はいつでも変更できます。',
	q{Enter the URL of your Blog. Exclude the filename (i.e. index.html). Example: http://www.example.com/blog/} => q{ブログを公開するURLを入力してください。ファイル名(index.htmlなど)は含めず、末尾は'/'で終わります。例: http://www.example.com/blog/},
	q{The path where your index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{インデックスファイルが公開されるパスを入力してください。絶対パス(Linuxの時は'/'、Windowsの時は'C:\'などで始まる)を推奨します。末尾には'/'や'\'を含めません。例: /home/melody/public_html/blogやC:\www\public_html\blog},
	q{The path where your index files will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{インデックスファイルを配置するパスを入力してください。例: /home/mt/public_html/blogやC:\www\public_html\blog},
	'Select your timezone from the pulldown menu.' => 'プルダウンメニューからタイムゾーンを選択してください。',
	'Create Blog (s)' => 'ブログを作成 (s)',
	'You must set your Local Site Path.' => 'サイトパスを指定する必要があります。',

## tmpl/cms/edit_category.tmpl
	'Edit Category' => 'カテゴリの編集',
	'Useful links' => 'ショートカット',
	'Manage entries in this category' => 'このカテゴリに属するブログ記事の一覧',
	'You must specify a label for the category.' => 'カテゴリ名を設定してください。',
	'You must specify a basename for the category.' => '出力ファイル/フォルダ名を設定して下さい。',
	'Please enter a valid basename.' => '有効な出力ファイル/フォルダ名を入力してください。',
	'_CATEGORY_BASENAME' => '出力ファイル/フォルダ名',
	'This is the basename assigned to your category.' => 'カテゴリの出力ファイル/フォルダ名です。',
	q{Warning: Changing this category's basename may break inbound links.} => q{警告: このカテゴリの出力ファイル/フォルダ名を変更すると、URLが変更されてリンク切れを招く場合があります。},
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
	'The comment has been approved.' => 'コメントを公開しました。',
	'This comment was classified as spam.' => 'このコメントはスパムと判定されました。',
	'Total Feedback Rating: [_1]' => '最終レーティング: [_1]',
	'Test' => 'テスト',
	'Score' => 'スコア',
	'Results' => '結果',
	'Save changes to this comment (s)' => 'コメントへの変更を保存 (s)',
	'comment' => 'コメント',
	'comments' => 'コメント',
	'Delete this comment (x)' => 'コメントを削除 (x)',
	'Manage Comments' => 'コメントの管理',
	'_external_link_target' => '_blank',
	'View [_1] comment was left on' => 'コメントされた[_1]を表示',
	'Reply to this comment' => 'コメントに返信',
	'Update the status of this comment' => 'このコメントを更新する',
	'Reported as Spam' => 'スパムとして報告',
	'View all comments with this status' => 'このステータスのすべてのコメントを見る',
	'The name of the person who posted the comment' => 'このコメント投稿者の名前',
	'View all comments by this commenter' => 'このコメント投稿者のすべてのコメントを見る',
	'View this commenter detail' => 'コメント投稿者の詳細を見る',
	'Trusted' => '承認済み',
	'(Trusted)' => '(承認済)',
	'Untrust Commenter' => 'コメント投稿者の承認を取り消し',
	'Ban Commenter' => 'コメント投稿者を禁止',
	'(Banned)' => '(禁止済)',
	'Trust Commenter' => 'コメント投稿者を承認',
	'Unban Commenter' => 'コメント投稿者の禁止を解除',
	'(Pending)' => '(保留済)',
	'Email address of commenter' => 'コメント投稿者のメールアドレス',
	'Unavailable for OpenID user' => 'OpenIDユーザーにはありません',
	'Email' => 'メール',
	'View all comments with this email address' => 'このメールアドレスのすべてのコメントを見る',
	'URL of commenter' => 'コメント投稿者のURL',
	'No url in profile' => '(URL がありません)',
	'View all comments with this URL' => 'このURLのすべてのコメントを見る',
	'[_1] this comment was made on' => 'このコメントが投稿された[_1]',
	'[_1] no longer exists' => '[_1]が存在しません',
	'View all comments on this [_1]' => '[_1]のすべてのコメントを見る',
	'Date' => '日付',
	'Date this comment was made' => 'このコメントの投稿日',
	'View all comments created on this day' => 'この日に投稿されたすべてのコメントを見る',
	'IP Address of the commenter' => 'コメント投稿者のIPアドレス',
	'View all comments from this IP Address' => 'このIPアドレスからのすべてのコメントを見る',
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
	'View' => '表示',
	'The Email Address of the commenter' => 'コメント投稿者のメールアドレス',
	'Withheld' => '公開しない',
	'The Website URL of the commenter' => 'コメント投稿者のウェブサイトのURL',
	'The trusted status of the commenter' => 'コメント投稿者の承認状況',
	'Authenticated' => '認証済み',

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
	'Restored revision (Date:[_1]).  The current status is: [_2]' => '更新履歴(日付: [_1])に戻しました。ステータス: [_2]',
	'Some of tags in the revision could not be loaded because they have been removed.' => '履歴データ内に、削除されたために読み込めなかったタグがあります。',
	'Some [_1] in the revision could not be loaded because they have been removed.' => '履歴データ内に、削除されたために読み込めなかった[_1]があります。',
	'This post was held for review, due to spam filtering.' => 'この投稿はスパムフィルタリングにより承認待ちになっています。',
	'This post was classified as spam.' => 'この投稿はスパムと判定されました。',
	'Change Folder' => 'フォルダの変更',
	'Unpublished (Draft)' => '未公開(原稿)',
	'Unpublished (Review)' => '未公開(承認待ち)',
	'Unpublished (Spam)' => '未公開(スパム)',
	'Revision: <strong>[_1]</strong>' => '更新履歴: <strong>[_1]</strong>',
	'View revisions of this [_1]' => '[_1]の更新履歴を表示',
	'View revisions' => '更新履歴を表示',
	'No revision(s) associated with this [_1]' => '[_1]の更新履歴が見つかりません',
	'[_1] - Published by [_2]' => '公開: [_2] - [_1]',
	'[_1] - Edited by [_2]' => '編集: [_2] - [_1]',
	'Publish this [_1]' => '[_1]の公開',
	'Draft this [_1]' => '[_1]の下書き',
	'Schedule' => '保存',
	'Update' => '更新',
	'Update this [_1]' => '[_1]の更新',
	'Unpublish this [_1]' => '[_1]の公開取り消し',
	'Save this [_1]' => 'この[_1]を保存する',
	'You must configure this blog before you can publish this entry.' => 'ブログ記事を公開する前にブログの設定を行ってください。',
	'You must configure this blog before you can publish this page.' => 'ページを公開する前にブログの設定を行ってください。',
	'Publish On' => '公開する',
	'@' => '@',
	'Warning: If you set the basename manually, it may conflict with another entry.' => '警告: 出力ファイル名を手動で設定すると、他のブログ記事と衝突を起こす可能性があります。',
	q{Warning: Changing this entry's basename may break inbound links.} => q{警告: このブログ記事の出力ファイル名の変更は、内部のリンク切れの原因となります。},
	'Change note' => '変更メモ',
	'edit' => '編集',
	'close' => '閉じる',
	'Accept' => '受信設定',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'View Previously Sent TrackBacks' => '送信済みのトラックバックを見る',
	'Outbound TrackBack URLs' => 'トラックバック送信先URL',
	'[_1] Assets' => '[_1]アイテム',
	'Remove this asset.' => 'アイテム削除',
	'No assets' => 'アイテムはありません',
	'You have unsaved changes to this entry that will be lost.' => '保存されていないブログ記事への変更は失われます。',
	'Enter the link address:' => 'リンクするURLを入力:',
	'Enter the text to link to:' => 'リンクのテキストを入力:',
	'Converting to rich text may result in changes to your current document.' => 'リッチテキストに変換すると、現在のHTML構造に変更が生じる可能性があります。',
	'Make primary' => 'メインカテゴリにする',
	'Fields' => 'フィールド',
	'Reset display options to blog defaults' => '表示オプションをブログの既定値にリセット',
	'Reset defaults' => '既定値にリセット',
	'Permalink:' => 'パーマリンク:',
	'Share' => '共有',
	'Format:' => 'フォーマット:',
	'(comma-delimited list)' => '(カンマ区切りリスト)',
	'(space-delimited list)' => '(スペース区切りリスト)',
	q{(delimited by '[_1]')} => q{([_1]で区切る)},
	'None selected' => '選択されていません',
	'Auto-saving...' => '自動保存中...',
	'Last auto-save at [_1]:[_2]:[_3]' => '[_1]:[_2]:[_3]に自動保存済み',

## tmpl/cms/edit_entry_batch.tmpl
	'Save these [_1] (s)' => '[_1]の保存',
	'Published Date' => '公開日',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'フォルダの編集',
	'Manage Folders' => 'フォルダの管理',
	'Manage pages in this folder' => 'このフォルダに属するウェブページ一覧',
	'You must specify a label for the folder.' => 'このフォルダの名前を設定してください。',
	'Path' => 'パス',
	'Save changes to this folder (s)' => 'フォルダへの変更を保存 (s)',

## tmpl/cms/edit_ping.tmpl
	'Edit Trackback' => 'トラックバックの編集',
	'The TrackBack has been approved.' => 'トラックバックを公開しました。',
	'This trackback was classified as spam.' => 'このトラックバックはスパムと判定されました。',
	'Save changes to this TrackBack (s)' => 'トラックバックへの変更を保存 (s)',
	'Delete this TrackBack (x)' => 'トラックバックを削除 (x)',
	'Manage TrackBacks' => 'トラックバックの管理',
	'View [_1]' => '[_1]を見る',
	'Update the status of this TrackBack' => 'トラックバックの状態を更新する',
	'View all TrackBacks with this status' => 'このステータスのトラックバックを全て表示',
	'Search for other TrackBacks from this site' => 'このサイトのその他のトラックバックを検索する',
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
	'Association (1)' => '関連付け (1)',
	'Associations ([_1])' => '関連付け ([_1])',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'このロールの権限を変更しました。これによって、このロールに関連付けられているユーザーの権限も変化します。このロールに異なる名前を付けて保存したほうがいいかもしれません。このロールに関連付けられているユーザーの権限が変更されていることに注意してください。',
	'Role Details' => 'ロールの詳細',
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
	'Restored revision (Date:[_1]).' => '更新履歴(日付: [_1])に戻しました。',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => 'このテンプレートを<a href="[_1]" class="rebuild-link">再構築する</a>',
	'Your [_1] has been published.' => '[_1]を再構築しました。',
	'View revisions of this template' => 'テンプレートの更新履歴を表示',
	'No revision(s) associated with this template' => 'テンプレートの更新履歴が見つかりません',
	'Useful Links' => 'ショートカット',
	'List [_1] templates' => '[_1]テンプレート一覧',
	'Module Option Settings' => 'モジュールオプション設定',
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
	'Syntax highlighting On' => '構文強調表示を有効にする',
	'Syntax highlighting Off' => '構文強調表示を無効にする',
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
	'hours' => '時間',
	'Dynamically' => 'ダイナミック',
	'Manually' => '手動',
	'Do Not Publish' => '公開しない',
	'Server Side Include' => 'サーバーサイドインクルード',
	'Process as <strong>[_1]</strong> include' => '<strong>[_1]</strong>のインクルードとして処理する',
	'Include cache path' => 'キャッシュのパス',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => '無効(<a href="[_1]">変更する</a>)',
	'No caching' => 'キャッシュしない',
	'Expire after' => 'キャッシュの有効期限: ',
	'Expire upon creation or modification of:' => '作成または更新後に無効にする:',

## tmpl/cms/edit_website.tmpl
	'Create Website' => 'ウェブサイトの作成',
	'Website Theme' => 'ウェブサイトテーマ',
	'Select the theme you wish to use for this website.' => 'ウェブサイトで利用したいテーマを選択してください。',
	'Name your website. The website name can be changed at any time.' => 'ウェブサイト名。ウェブサイト名はいつでも変更できます。',
	'Enter the URL of your website. Exclude the filename (i.e. index.html). Example: http://www.example.com/' => 'ウェブサイトを公開するURLを入力してください。ファイル名(index.htmlなど)は含めないでください。例: http://www.example.com/',
	'Website Root' => 'ウェブサイトパス',
	q{Enter the path where your main index file will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/ or C:\www\public_html} => q{インデックスファイルが公開されるパスを入力してください。絶対パス(Linuxの時は'/'、Windowsの時は'C:\'などで始まる)を推奨しますが、Movable Typeディレクトリからの相対パスも指定できます。末尾には'/'や'\'を含めません。例: /home/melody/public_html/blogやC:\www\public_html\blog},
	'Create Website (s)' => 'ウェブサイト作成',
	'This field is required.' => 'このフィールドは必須です。',
	'Please enter a valid URL.' => '正しいURLを入力してください。',
	'Please enter a valid site path.' => '正しいウェブサイトパスを入力してください。',
	'You did not select a timezone.' => 'タイムゾーンが選択されていません。',

## tmpl/cms/edit_widget.tmpl
	'Edit Widget Set' => 'ウィジェットセットの編集',
	'Create Widget Set' => 'ウィジェットセットの作成',
	'Widget Set Name' => 'ウィジェットセット名',
	'Save changes to this widget set (s)' => 'ウィジェットセットへの変更を保存 (s)',
	q{Drag and drop the widgets that belong in this Widget Set into the 'Installed Widgets' column.} => q{ウィジェットを「利用可能」から「インストール済み」ボックスにドラッグアンドドロップします。},
	'Available Widgets' => '利用可能',
	'Installed Widgets' => 'インストール済み',
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
	q{Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, '-' or '_').} => q{次の文字と数字のみ利用できます: アルファベット、数字、ダッシュ(-)、アンダースコア(_)},
	'Version' => 'バージョン',
	'A version number for this theme.' => 'テーマのバージョン番号です。',
	'A description for this theme.' => 'テーマの説明です。',
	'_THEME_AUTHOR' => '作者名',
	'The author of this theme.' => 'テーマの作者名です。',
	'Author link' => '作者のページ',
	q{The author's website.} => q{作者のウェブサイトです},
	'Additional assets to be included in the theme.' => 'テーマに含む追加アイテムです。',
	'Destination' => '出力形式',
	'Select How to get theme.' => 'テーマの出力方法を選択してください。',
	'Setting for [_1]' => '[_1]の設定',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'アルファベット、数字、ダッシュ(-)、アンダースコア(_)を利用。かならずアルファベットで始めてください。',
	q{Cannot install new theme with existing (and protected) theme's basename.} => q{新しいテーマは既存、または保護されたテーマベース名ではインストールできません。},
	'You must set Theme Name.' => 'テーマ名を設定してください。',
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
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => '所有者を変更しない場合には、存在しないユーザーをシステムが自動で作成します。新しいユーザーの初期パスワードを設定してください。',
	'Default password for new users:' => '新しいユーザーの初期パスワード',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'あなたがインポートしたブログ記事を作成したことになります。元の著者を変更せずにインポートしたい場合には、システム管理者がインポート作業を行ってください。その場合には必要に応じて新しいユーザーを作成できます。',
	'Upload import file (optional)' => 'インポートファイルをアップロード(オプション)',
	q{If your import file is located on your computer, you can upload it here.  Otherwise, Movable Type will automatically look in the 'import' folder of your Movable Type directory.} => q{インポートするファイルがローカルのコンピュータ内にある場合にはここにアップロードしてください。アップロードしない場合には、Movable Typeは自動的にアプリケーションディレクトリのimportフォルダ内から探します。},
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
	'Allow comments from anonymous or unauthenticated users.' => '認証なしユーザーまたは匿名ユーザーからコメントを受け付ける',
	'Require name and E-mail Address for Anonymous Comments' => '名前とメールアドレスを要求する',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'コメント投稿に対して名前とメールアドレスを必須項目にします。',

## tmpl/cms/include/archetype_editor.tmpl
	'Decrease Text Size' => 'テキストサイズを小さくする',
	'Increase Text Size' => 'テキストサイズを大きくする',
	'Bold' => '太字',
	'Italic' => '斜体',
	'Underline' => '下線',
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
	'Check Spelling' => 'スペルチェック',
	'WYSIWYG Mode' => 'WYSIWYGモード',
	'HTML Mode' => 'HTMLモード',

## tmpl/cms/include/archive_maps.tmpl
	'Custom...' => 'カスタム...',

## tmpl/cms/include/asset_replace.tmpl
	q{A file named '[_1]' already exists. Do you want to overwrite this file?} => q{同名のアイテム'[_1]'がすでに存在します。上書きしますか?},
	'Yes (s)' => 'はい (s)',
	'Yes' => 'はい',
	'No' => 'いいえ',

## tmpl/cms/include/asset_table.tmpl
	'Delete selected assets (x)' => '選択したアイテムを削除',
	'Website/Blog' => 'ウェブサイト/ブログ',
	'Created By' => '作成者',
	'Created On' => '作成日',
	'Asset Missing' => 'アイテムなし',
	'No thumbnail image' => 'サムネイル画像がありません。',

## tmpl/cms/include/asset_upload.tmpl
	'Upload Destination' => 'アップロード先',
	q{Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]'s publishing paths[_3] and republish your [_1].} => q{ファイルのアップロードができるように、[_1]を再構築する必要があります。[_2]公開パスの設定[_3]して、[_1]を再構築してください。},
	'Your system or [_1] administrator needs to publish the [_1] before you can upload files. Please contact your system or [_1] administrator.' => 'ファイルアップロードができるように、システム、または[_1]管理者が[_1]を再構築する必要があります。システム、または[_1]管理者に連絡してください。',
	q{Asset file('[_1]') has been uploaded.} => q{アイテム('[_1]')がアップロードされました。},
	'Select File to Upload' => 'アップロードするファイルを選択',
	'_USAGE_UPLOAD' => 'アップロード先には、サブディレクトリを指定することが出来ます。指定されたディレクトリが存在しない場合は、作成されます。',
	'Choose Folder' => 'フォルダの選択',
	'Upload (s)' => 'アップロード (s)',
	'Upload' => 'アップロード',
	'[_1] contains a character that is invalid when used in a directory name: [_2]' => '[_1]のディレクトリ名として正しくない文字が含まれています: [_2]',

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
	'_BACKUP_TEMPDIR_WARNING' => 'バックアップはディレクトリ[_1]に正常に保存されました。バックアップファイルには公開するべきではない情報も含まれています。一覧に表示されたファイルを[_1]ディレクトリからダウンロードした後、<strong>ディレクトリから削除されたことを</strong>すぐに確認してください。',
	'Backup Files' => 'バックアップファイル',
	'Download This File' => 'このファイルをダウンロード',
	'Download: [_1]' => 'ダウンロード: [_1]',
	q{_BACKUP_DOWNLOAD_MESSAGE} => q{数秒後にバックアップファイルのダウンロードが開始します。ダウンロードが始まらない場合は<a href='#' onclick='submit_form()'>ここ</a>をクリックしてください。},
	'An error occurred during the backup process: [_1]' => 'バックアップの途中でエラーが発生しました: [_1]',

## tmpl/cms/include/backup_start.tmpl
	'Backing up Movable Type' => 'バックアップを開始',

## tmpl/cms/include/basic_filter_forms.tmpl
	'contains' => 'を含む',
	'does not contain' => 'を含まない',
	'__STRING_FILTER_EQUAL' => 'である',
	'starts with' => 'で始まる',
	'ends with' => 'で終わる',
	'[_1] [_2] [_3]' => '[_1] が [_3] [_2]',
	'__INTEGER_FILTER_EQUAL' => 'である',
	'__INTEGER_FILTER_NOT_EQUAL' => 'ではない',
	'is greater than' => 'より大きい',
	'is greater than or equal to' => '以上',
	'is less than' => 'より小さい',
	'is less than or equal to' => '以下',
	'is between' => 'の期間内',
	'is within the last' => '日以内',
	'is before' => 'より前',
	'is after' => 'より後',
	'is after now' => 'が今日より後',
	'is before now' => 'が今日より前',
	'__FILTER_DATE_ORIGIN' => 'が[_1]',
	'[_1] and [_2]' => 'が[_1] から [_2]',
	'_FILTER_DATE_DAYS' => 'が[_1]',

## tmpl/cms/include/blog_table.tmpl
	'Some templates were not refreshed.' => '初期化できないテンプレートがありました。',
	'Delete selected [_1] (x)' => '選択された[_1]を削除 (x)',
	'[_1] Name' => '[_1]名',

## tmpl/cms/include/category_selector.tmpl
	'Add sub category' => 'サブカテゴリを追加',
	'Add sub folder' => 'サブフォルダを追加',

## tmpl/cms/include/comment_detail.tmpl

## tmpl/cms/include/comment_table.tmpl
	'Publish selected comments (a)' => '選択されたコメントを再構築 (a)',
	'Delete selected comments (x)' => '選択されたコメントを削除 (x)',
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
	'Display Options' => '表示オプション',
	'_DISPLAY_OPTIONS_SHOW' => '表示数',
	'[quant,_1,row,rows]' => '[quant,_1,行,行]',
	'Compact' => '簡易',
	'Expanded' => '詳細',
	'Save display options' => '表示オプションを保存',

## tmpl/cms/include/entry_table.tmpl
	'Republish selected [_1] (r)' => '選択した[_1]の再構築',
	'Last Modified' => '最終更新',
	'Created' => '作成',
	'View entry' => 'ブログ記事を見る',
	'View page' => 'ウェブページを表示',
	'No entries could be found.' => '記事がありません。',
	'<a href="[_1]">Create an entry</a> now.' => '<a href="[_1]">記事を作成</a>する。',
	'No pages could be found. <a href="[_1]">Create a page</a> now.' => 'ウェブページが見つかりませんでした。<a href="[_1]">ウェブページの作成</a>',

## tmpl/cms/include/feed_link.tmpl
	'Set Web Services Password' => 'Webサービスのパスワードを設定',

## tmpl/cms/include/footer.tmpl
	'This is a beta version of Movable Type and is not recommended for production use.' => 'このMovable Typeはベータ版です。',
	'http://www.movabletype.org' => 'http://www.movabletype.jp',
	'MovableType.org' => 'MovableType.jp',
	'http://plugins.movabletype.org/' => 'http://communities.movabletype.jp/plugins/',
	'http://wiki.movabletype.org/' => 'http://wiki.movabletype.org/',
	'Wiki' => 'Wiki(英語)',
	'Support' => 'サポート',
	'http://forums.movabletype.org/' => 'http://communities.movabletype.jp/',
	'Forums' => 'ユーザーコミュニティ',
	'Send Us Feedback' => 'フィードバックはこちらへ',
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]',
	'with' => 'with',
	q{_LOCALE_CALENDAR_HEADER_} => q{'日', '月', '火', '水', '木', '金', '土'},
	'Your Dashboard' => 'ユーザーダッシュボード',

## tmpl/cms/include/header.tmpl
	'Signed in as [_1]' => 'ユーザー: [_1]',
	'Help' => 'ヘルプ',
	'Sign out' => 'サインアウト',
	'View Site' => 'サイトの表示',
	'Search (q)' => '検索 (q)',
	'Create New' => '新規作成',
	'Select an action' => 'アクションを選択',
	q{This website was created during the upgrade from a previous version of Movable Type. 'Site Root' and 'Site URL' are left blank to retain 'Publishing Paths' compatibility for blogs that were created in a previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank 'Site Root' and 'Site URL'.} => q{このウェブサイトは、以前のバージョンのMovable Typeからのバージョンアップ時に作成されました。バージョンアップ前に作成されたブログの公開設定の互換性を保持するために、ウェブサイトのサイト URLとサイトパスは空白になっています。そのため、既存のブログに投稿、公開はできますが、ウェブサイト自体にコンテンツを投稿することはできません。},
	'from Revision History' => '履歴データ',

## tmpl/cms/include/import_end.tmpl
	'All data imported successfully!' => 'すべてのデータをインポートしました。',
	q{Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported.} => q{'import'ディレクトリからインポートしたファイルを削除することを忘れないでください。もう一度インポート機能を利用した場合に、同じファイルが再度インポートされてしまう可能性があります。},
	'An error occurred during the import process: [_1]. Please check your import file.' => 'インポートの途中でエラーが発生しました : [_1]。インポートファイルを確認してください。',

## tmpl/cms/include/import_start.tmpl
	'Importing...' => 'インポートを開始します...',
	'Importing entries into blog' => 'ブログ記事をブログにインポートしています',
	q{Importing entries as user '[_1]'} => q{ユーザー[_1]としてブログ記事をインポートしています},
	'Creating new users for each user found in the blog' => 'ブログのユーザーを新規ユーザーとして作成',

## tmpl/cms/include/itemset_action_widget.tmpl
	'More actions...' => 'アクション...',
	'Plugin Actions' => 'プラグインアクション',
	'Go' => 'Go',

## tmpl/cms/include/list_associations/page_title.tmpl
	'Manage Permissions' => '権限の管理',
	'Users for [_1]' => 'ユーザー - [_1]',

## tmpl/cms/include/listing_panel.tmpl
	'Step [_1] of [_2]' => '[_1] / [_2]',
	'Go to [_1]' => '[_1]へ進む',
	'Sorry, there were no results for your search. Please try searching again.' => '検索結果がありません。検索をやり直してください。',
	'Sorry, there is no data for this object set.' => 'このオブジェクトセットに対応したデータはありません。',
	'OK (s)' => 'OK (s)',
	'OK' => 'OK',

## tmpl/cms/include/log_table.tmpl
	'No log records could be found.' => 'ログレコードが見つかりませんでした。',
	'_LOG_TABLE_BY' => 'ユーザー',
	'IP: [_1]' => 'IP: [_1]',

## tmpl/cms/include/login_mt.tmpl
	'Remember me?' => 'サインイン情報を記憶する',

## tmpl/cms/include/member_table.tmpl
	'Are you sure you want to remove the selected user from this [_1]?' => '[_1]からユーザーを削除してよろしいですか?',
	'Are you sure you want to remove the [_1] selected users from this [_2]?' => '[_2]から[_1]人のユーザーを削除してよろしいですか?',
	'Remove selected user(s) (r)' => 'ユーザーを削除 (r)',
	'Trusted commenter' => '承認されたコメント投稿者',
	'Remove this role' => 'ロールを削除する',

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => '日付',
	'Save changes' => '変更を保存',

## tmpl/cms/include/pagination.tmpl

## tmpl/cms/include/ping_table.tmpl
	'Publish selected [_1] (p)' => '選択された[_1]を公開 (p)',
	'Edit this TrackBack' => 'このトラックバックを編集',
	'Go to the source entry of this TrackBack' => 'トラックバック送信元に移動',
	'View the [_1] for this TrackBack' => 'トラックバックされた[_1]を見る',

## tmpl/cms/include/revision_table.tmpl
	'No revisions could be found.' => '変更履歴がありません。',
	'_REVISION_DATE_' => '保存した日',
	'Note' => 'メモ',
	'Saved By' => '保存したユーザー',

## tmpl/cms/include/rpt_log_table.tmpl
	'Schwartz Message' => 'Schwartzメッセージ',

## tmpl/cms/include/scope_selector.tmpl
	'User Dashboard' => 'ユーザーダッシュボード',
	'Select another website...' => 'ウェブサイトを選択',
	'(on [_1])' => '([_1])',
	'Select another blog...' => 'ブログを選択',
	'Create Blog (on [_1])' => 'ブログの作成 ([_1])',

## tmpl/cms/include/template_table.tmpl
	'Create Archive Template:' => 'アーカイブテンプレートの作成:',
	'Entry Listing' => 'ブログ記事リスト',
	'Create template module' => 'テンプレートモジュールの作成',
	'Create index template' => 'インデックステンプレートの作成',
	'Publish selected templates (a)' => '選択されたテンプレートを公開 (a)',
	'Archive Path' => 'アーカイブパス',
	'SSI' => 'SSI',
	'Cached' => 'キャッシュ',
	'Linked Template' => 'ファイルにリンクされたテンプレート',
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
	'<mt:if name="is_blog">Blog URL<mt:else>Site URL</mt:if>' => '<mt:if name="is_blog">ブログURL<mt:else>サイトURL</mt:if>',

## tmpl/cms/include/theme_exporters/static_files.tmpl
	'In the specified directories, files of the following types will be included in the theme: [_1]. Other file types will be ignored.' => '指定したディレクトリ内の、以下の種類のファイルがテーマにエクスポートされます: [_1]。その他のファイルは無視されます。',
	'Specify directories' => 'ディレクトリの指定',
	'List directories (one per line) in the Site Root directory which contain the static files to be included in the theme. Common directories might be: css, images, js, etc.' => 'ファイルが置かれたディレクトリを、サイトパスからの相対パスで一行ずつ記入してください。例: images',

## tmpl/cms/include/theme_exporters/templateset.tmpl
	'widget sets' => 'ウィジェットセット',
	'modules' => 'モジュール',
	'<span class="count">[_1]</span> [_2] are included' => '<span class="count">[_1]</span>件の[_2]が含まれます',

## tmpl/cms/install.tmpl
	'Welcome to Movable Type' => 'Movable Typeへようこそ',
	'Create Your Account' => 'アカウントの作成',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'サーバーにインストールされているPerlのバージョン([_1])が、Movable Type がサポートしているバージョン([_2])より低いため正常に動作しない可能性があります。',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Movable Type が動作する場合でも、<strong>動作確認を行っていない、サポート対象外の環境となります</strong>。少なくともPerl[_1]以上へアップグレードすることを強くお勧めします。',
	'Do you want to proceed with the installation anyway?' => 'インストールを続けますか?',
	'View MT-Check (x)' => 'システムチェック (x)',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'システム管理者のアカウントを作成してください。作成が完了すると、データベースを初期化します。',
	'To proceed, you must authenticate properly with your LDAP server.' => 'LDAPサーバーで認証を受けないと先に進めません。',
	'The name used by this user to login.' => 'サインイン時に使用するユーザー名です。',
	'The name used when published.' => '表示名です。',
	'The user&rsquo;s email address.' => 'ユーザーのメールアドレスです。',
	'System Email' => 'システムのメールアドレス',
	'Use this as system email address' => 'システムのメールアドレスとして利用する',
	'The user&rsquo;s preferred language.' => 'ユーザーの表示用の言語',
	'Select a password for your account.' => 'パスワードを入力してください。',
	'Your LDAP username.' => 'LDAPのユーザー名を入力してください。',
	'Enter your LDAP password.' => 'LDAPのパスワードを入力してください。',
	'The initial account name is required.' => '名前は必須です。',
	'The display name is required.' => '表示名は必須です。',
	'The e-mail address is required.' => 'メールアドレスは必須です。',

## tmpl/cms/list_category.tmpl
	'Manage [_1]' => '[_1]の管理',
	'Top Level' => 'ルート',
	'[_1] label' => '[_1]名',
	'Change and move' => '変更して移動',
	'Rename' => '名前を変更',
	'Label is required.' => '名前は必須です。',
	'Duplicated label on this level.' => '名前が同一階層内で重複しています。',
	'Basename is required.' => '出力ファイル名/フォルダ名は必須です。',
	'Invalid Basename.' => '不正な出力ファイル名/フォルダ名です。',
	'Duplicated basename on this level.' => '出力ファイル名/フォルダ名が同一階層内で重複しています。',
	'Add child [_1]' => 'サブ[_1]を追加する',
	'Remove [_1]' => '[_1]を削除する',
	'[_1] \'[_2]\' already exists.' => '\'[_2]\'という[_1]は既に存在します。',
	'Are you sure you want to remove [_1] [_2]?' => '[_1]\'[_2]\'を削除してよろしいですか?',
	'Are you sure you want to remove [_1] [_2] with [_3] sub [_4]?' => '[_3]個のサブ[_4]を含む[_1]\'[_2]\'を削除してよろしいですか?',
	'Alert' => '警告',

## tmpl/cms/list_common.tmpl
	'25 rows' => '25件',
	'50 rows' => '50件',
	'100 rows' => '100件',
	'200 rows' => '200件',
	'Column' => '表示項目',
	'<mt:var name="js_message">' => '<mt:var name="js_message">',
	'Filter:' => 'フィルタ:',
	'Select Filter...' => 'フィルタを変更する...',
	'Remove Filter' => 'フィルタしない',
	'Select Filter Item...' => 'フィルタ項目を選択してください',
	'Apply' => '適用',
	'Save As' => '別名で保存',
	'Filter Label' => 'フィルタ名',
	'My Filters' => '自分のフィルタ',
	'Built in Filters' => 'クイックフィルタ',
	'Remove item' => 'フィルタ項目を削除する',
	'Unknown Filter' => '無名のフィルタ',
	'act upon' => '対象に',
	'Are you sure you want to remove the filter \'[_1]\'?' => 'フィルタ\'[_1]\'を削除してよろしいですか?',
	'Label "[_1]" is already in use.' => '"[_1]というラベルは既に使用されています。"',
	'Communication Error ([_1])' => '通信エラー ([_1])',
	'[_1] - [_2] of [_3]' => '[_1] - [_2] / [_3]',
	'Select all [_1] items' => '全[_1]件を選択する',
	'All [_1] items are selected' => '全[_1]件が選択されています',
	'[_1] Filter Items have errors' => '[_1] フィルター項目にエラーがあります。',
	'[_1] - Filter [_2]' => '[_1] - フィルタ [_2]',
	'Save Filter' => 'フィルタを保存',
	'Save As Filter' => '別名でフィルタを保存',
	'Select Filter' => 'フィルタを選択',

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => 'ブログ記事フィード',
	'Pages Feed' => 'ウェブページフィード',
	'The entry has been deleted from the database.' => 'ブログ記事をデータベースから削除しました。',
	'The page has been deleted from the database.' => 'ウェブページをデータベースから削除しました。',
	'Quickfilters' => 'クイックフィルタ',
	'[_1] (Disabled)' => '[_1] (無効)',
	'Showing only: [_1]' => '[_1]を表示',
	'Remove filter' => 'フィルタしない',
	'change' => '絞り込み',
	'[_1] where [_2] is [_3]' => '[_2]が[_3]の[_1]',
	'Show only entries where' => 'ブログ記事を表示: ',
	'Show only pages where' => 'ウェブページを表示: ',
	'status' => 'ステータス',
	'tag (exact match)' => 'タグ (完全一致)',
	'tag (fuzzy match)' => 'タグ (あいまい検索)',
	'asset' => 'アイテム',
	'is' => 'が',
	'published' => '公開',
	'unpublished' => '未公開',
	'review' => '承認待ち',
	'scheduled' => '指定日公開',
	'spam' => 'スパム',
	'Select A User:' => 'ユーザーを選択:',
	'User Search...' => 'ユーザーを検索',
	'Recent Users...' => '最近のユーザー',
	'Select...' => '選択してください',

## tmpl/cms/list_template.tmpl
	'Manage [_1] Templates' => '[_1]テンプレートの管理',
	'Manage Global Templates' => 'グローバルテンプレートの管理',
	'Show All Templates' => 'すべてのテンプレート',
	'Publishing Settings' => '公開設定',
	'You have successfully deleted the checked template(s).' => '選択したテンプレートを削除しました。',
	'You have successfully refreshed your templates.' => 'テンプレートの初期化を完了しました。',
	'Your templates have been published.' => 'テンプレートを再構築しました。',
	'Selected template(s) has been copied.' => '選択されたテンプレートをコピーしました。',

## tmpl/cms/list_theme.tmpl
	'[_1] Themes' => '[_1]テーマの一覧',
	'All Themes' => 'テーマの一覧',
	'_THEME_DIRECTORY_URL' => 'http://communities.movabletype.jp/themes/',
	'Find Themes' => 'テーマを探す',
	'Theme [_1] has been uninstalled.' => 'テーマ "[_1]"をアンインストールしました。',
	'Theme [_1] has been applied (<a href="[_2]">[quant,_3,warning,warnings]</a>).' => 'テーマ "[_1]"を適用しました(<a href="[_2]">[quant,_3,つの警告,つの警告]</a>)。',
	'Theme [_1] has been applied.' => 'テーマ "[_1]"を適用しました。',
	'Failed' => '失敗',
	'[quant,_1,warning,warnings]' => '警告: [quant,_1,,,]',
	'Reapply' => '再適用',
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
	'Current Theme' => '現在のテーマ',
	'Available Themes' => '利用可能なテーマ',
	'Themes for Both Blogs and Websites' => 'ウェブサイト、およびブログ用のテーマ',
	'Themes for Blogs' => 'ブログ用テーマ',
	'Themes for Websites' => 'ウェブサイト用テーマ',

## tmpl/cms/list_widget.tmpl
	'Manage [_1] Widgets' => '[_1]ウィジェットの管理',
	'Manage Global Widgets' => 'グローバルウィジェットの管理',
	'Delete selected Widget Sets (x)' => '選択されたウィジェットセットを削除 (x)',
	'Helpful Tips' => 'ヘルプ',
	'To add a widget set to your templates, use the following syntax:' => 'テンプレートにウィジェットセットを追加するときは以下の構文を利用します。',
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;ウィジェットセットの名前&quot;$&gt;</strong>',
	'Your changes to the widget set have been saved.' => 'ウィジェットセットへの変更を保存しました。',
	'You have successfully deleted the selected widget set(s) from your blog.' => '選択されたウィジェットセットを削除しました。',
	'No widget sets could be found.' => 'ウィジェットセットが見つかりませんでした。',
	'Create widget template' => 'ウィジェットテンプレートの作成',

## tmpl/cms/listing/asset_list_header.tmpl
	'You have successfully deleted the asset(s).' => 'アイテムを削除しました。',

## tmpl/cms/listing/association_list_header.tmpl
	'You have successfully revoked the given permission(s).' => '権限を削除しました。',
	'You have successfully granted the given permission(s).' => '権限を付与しました。',

## tmpl/cms/listing/author_list_header.tmpl
	'You have successfully disabled the selected user(s).' => '選択したユーザーを無効にしました。',
	'You have successfully enabled the selected user(s).' => '選択したユーザーを有効にしました。',
	'You have successfully unlocked the selected user(s).' => '選択したユーザーのロックを解除しました。',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'システムからユーザーを削除しました。',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Advanced.' => '削除されたユーザーが外部ディレクトリ上にまだ存在するので、このままではユーザーは再度サインインできてしまいます。',
	q{You have successfully synchronized users' information with the external directory.} => q{外部のディレクトリとユーザーの情報を同期しました。},
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => '選択されたユーザーのうち[_1]人は外部ディレクトリ上に存在しないので有効にできませんでした。',
	q{An error occured during synchronization.  See the <a href='[_1]'>activity log</a> for detailed information.} => q{同期中にエラーが発生しました。エラーの詳細を<a href='[_1]'>ログ</a>で確認して>ください。},

## tmpl/cms/listing/banlist_list_header.tmpl
	'You have added [_1] to your list of banned IP addresses.' => '禁止IPリストに[_1]を追加しました。',
	'You have successfully deleted the selected IP addresses from the list.' => 'リストから選択したIPアドレスを削除しました。',
	'Invalid IP address.' => '不正なIPアドレスです。',

## tmpl/cms/listing/blog_list_header.tmpl
	'You have successfully deleted the website from the Movable Type system.' => 'システムからウェブサイトの削除が完了しました。',
	'You have successfully deleted the blog from the website.' => 'ウェブサイトからブログの削除が完了しました。',
	'You have successfully moved selected blogs to another website.' => '他のウェブサイトへのブログの移動が完了しました。',
	'Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.' => '警告: アップロード済みのファイルは、新しいウェブサイトのパスに手動でコピーする必要があります。また、リンク切れを防止するために、旧パスのファイルも残すことを検討してください。',

## tmpl/cms/listing/comment_list_header.tmpl
	'The selected comment(s) has been approved.' => '選択したコメントを公開しました。',
	'All comments reported as spam have been removed.' => 'スパムとして報告されたコメントをすべて削除しました。',
	'The selected comment(s) has been unapproved.' => '選択したコメントを未公開にしました。',
	'The selected comment(s) has been reported as spam.' => '選択したコメントをスパムとして報告しました。',
	'The selected comment(s) has been recovered from spam.' => '選択したコメントをスパムから戻しました。',
	'The selected comment(s) has been deleted from the database.' => '選択したコメントをデータベースから削除しました。',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be banned or trusted.' => '選択したコメントの中に匿名のコメントが含まれています。これらのコメント投稿者は禁止したり承認したりできません。',
	'No comments appear to be spam.' => 'スパムコメントはありません。',

## tmpl/cms/listing/entry_list_header.tmpl

## tmpl/cms/listing/filter_list_header.tmpl

## tmpl/cms/listing/log_list_header.tmpl
	'All times are displayed in GMT[_1].' => '時刻はすべてGMT[_1]です。',
	'All times are displayed in GMT.' => '時刻はすべてGMTです。',

## tmpl/cms/listing/member_list_header.tmpl

## tmpl/cms/listing/notification_list_header.tmpl
	'You have added [_1] to your address book.' => 'アドレス帳に[_1]を登録しました。',
	'You have successfully deleted the selected contacts from your address book.' => 'アドレス帳から選択したあて先を削除しました。',

## tmpl/cms/listing/ping_list_header.tmpl
	'The selected TrackBack(s) has been approved.' => '選択したトラックバックを公開しました。',
	'All TrackBacks reported as spam have been removed.' => 'スパムとして報告したすべてのトラックバックを削除しました。',
	'The selected TrackBack(s) has been unapproved.' => '選択したトラックバックを未公開にしました。',
	'The selected TrackBack(s) has been reported as spam.' => '選択したトラックバックをスパムとして報告しました。',
	'The selected TrackBack(s) has been recovered from spam.' => '選択したトラックバックをスパムから戻しました。',
	'The selected TrackBack(s) has been deleted from the database.' => '選択したトラックバックをデータベースから削除しました。',
	'No TrackBacks appeared to be spam.' => 'スパムトラックバックはありません。',

## tmpl/cms/listing/role_list_header.tmpl
	'You have successfully deleted the role(s).' => 'ロールを削除しました。',

## tmpl/cms/listing/tag_list_header.tmpl
	'Your tag changes and additions have been made.' => 'タグの変更と追加が完了しました。',
	'You have successfully deleted the selected tags.' => '選択したタグを削除しました。',
	'Specify new name of the tag.' => 'タグの名前を指定してください。',
	'The tag \'[_2]\' already exists. Are you sure you want to merge \'[_1]\' with \'[_2]\' across all blogs?' => 'タグ「[_2]」は既に存在します。すべてのブログで「[_1]」を「[_2]」にマージしてもよろしいですか?',

## tmpl/cms/login.tmpl
	'Sign in' => 'サインイン',
	'Your Movable Type session has ended.' => 'Movable Typeからサインアウトしました。',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Movable Typeからサインアウトしました。以下から再度サインインできます。',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Movable Typeからサインアウトしました。続けるには再度サインインして下さい。',
	'Sign In (s)' => 'サインイン (s)',
	'Forgot your password?' => 'パスワードをお忘れですか?',

## tmpl/cms/pinging.tmpl
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
	'Preview [_1] Content' => '[_1]のプレビュー',
	'Return to the compose screen' => '作成画面に戻る',
	'Return to the compose screen (e)' => '作成画面に戻る',
	'Save this entry' => 'このブログ記事を保存する',
	'Save this entry (s)' => 'このブログ記事を保存する (s)',
	'Re-Edit this entry' => 'このブログ記事を編集する',
	'Re-Edit this entry (e)' => 'このブログ記事を編集する (e)',
	'Save this page' => 'このウェブページを保存する',
	'Save this page (s)' => 'このウェブページを保存する (s)',
	'Re-Edit this page' => 'このウェブページを編集する',
	'Re-Edit this page (e)' => 'このウェブページを編集する (e)',

## tmpl/cms/preview_strip.tmpl
	'Publish this entry' => 'このブログ記事を公開する',
	'Publish this entry (s)' => 'このブログ記事を公開する (s)',
	'Publish this page' => 'このウェブページを公開する',
	'Publish this page (s)' => 'このウェブページを公開する (s)',
	'You are previewing the entry entitled &ldquo;[_1]&rdquo;' => 'プレビュー中: 記事「[_1]」',
	'You are previewing the page entitled &ldquo;[_1]&rdquo;' => 'プレビュー中: ページ「[_1]」',

## tmpl/cms/preview_template_strip.tmpl
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'テンプレート「[_1]」をプレビューしています。',
	'(Publish time: [_1] seconds)' => '(処理時間: [_1]秒)',
	'Save this template (s)' => 'このテンプレートを保存する (s)',
	'Save this template' => 'このテンプレートを保存する',
	'Re-Edit this template (e)' => 'このテンプレートを編集する (e)',
	'Re-Edit this template' => 'このテンプレートを編集する',
	'There are no categories in this blog.  Limited preview of category archive templates is possible with a virtual category displayed.  Normal, non-preview output cannot be generated by this template unless at least one category is created.' => 'このブログにはカテゴリが存在しないため、仮カテゴリーを利用しています。正しいプレビューを表示したい場合は、カテゴリを作成して下さい。',

## tmpl/cms/rebuilding.tmpl
	'Publishing...' => '再構築中...',
	'Publishing [_1]...' => '[_1] を再構築中...',
	'Publishing <em>[_1]</em>...' => '<em>[_1]</em> を再構築中...',
	'Publishing [_1] [_2]...' => '[_1] [_2] を再構築中...',
	'Publishing [_1] dynamic links...' => '[_1] のダイナミックリンクを再構築中...',
	'Publishing [_1] archives...' => '[_1]アーカイブを再構築中...',
	'Publishing [_1] templates...' => '[_1]テンプレートを再構築中...',
	'Complete [_1]%' => '[_1]% 終了',

## tmpl/cms/recover_lockout.tmpl
	'Recovered from lockout' => 'ユーザーのロック解除',
	q{User '[_1]' has been unlocked.} => q{ユーザー '[_1]'のロックが解除されました。},

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
	q{If your backup file is located on a remote computer, you can upload it here.  Otherwise, Movable Type will automatically look in the 'import' folder within your Movable Type directory.} => q{バックアップファイルをアップロードします。アップロードがない場合は、Movable Typeは自動で 'import'フォルダをチェックします。},
	'Check this and files backed up from newer versions can be restored to this system.  NOTE: Ignoring Schema Version can damage Movable Type permanently.' => 'チェックすると現在のシステムより新しいシステムからバックアップされたデータをこのシステムに復元できます。注意: バージョンの衝突を無視すると、Movable Typeのシステムに回復不可能なダメージを与える可能性があります。',
	'Ignore schema version conflicts' => 'バージョンの衝突を無視する',
	'Allow existing global templates to be overwritten by global templates in the backup file.' => 'バックアップ内のファイルで、グローバルテンプレートを上書きする。',
	'Overwrite global templates.' => 'グローバルテンプレートを上書きする',
	'Restore (r)' => '復元',

## tmpl/cms/restore_end.tmpl
	q{Make sure that you remove the files that you restored from the 'import' folder, so that if/when you run the restore process again, those files will not be re-restored.} => q{再度復元を行う際に同じファイルから復元しないよう、importフォルダからファイルを削除してください。},
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
	'_DATE_FROM' => '開始日',
	'_DATE_TO' => '終了日',
	'Submit search (s)' => '検索 (s)',
	'Search For' => '検索',
	'Replace With' => '置換',
	'Replace Checked' => '選択したものを対象に置換',
	'Successfully replaced [quant,_1,record,records].' => '[quant,_1,件,件]のデータを置き換えました。',
	'Showing first [_1] results.' => '最初の[_1]件の結果を表示します。',
	'Show all matches' => 'すべて見る',
	'[quant,_1,result,results] found' => '[quant,_1,件,件]見つかりました。',

## tmpl/cms/setup_initial_website.tmpl
	'Create Your First Website' => '最初のウェブサイトを作成',
	q{In order to properly publish your website, you must provide Movable Type with your website's URL and the filesystem path where its files should be published.} => q{ウェブサイトを構築するには、ウェブサイトURLとファイルパスが正しく設定しなければなりません。},
	'My First Website' => 'First Website',
	q{The 'Website Root' is the directory in your web server's filesystem where Movable Type will publish the files for your website. The web server must have write access to this directory.} => q{'ウェブサイトパス'はウェブサーバーがウェブサイトの構築時に使うディレクトリです。ディレクトリにはウェブサーバーの書き込み権限が必要です。},
	'Select the theme you wish to use for this new website.' => '新しいウェブサイトで利用するテーマを選んでください。',
	'Finish install (s)' => 'インストール (s)',
	'Finish install' => 'インストール',
	'The website name is required.' => 'ウェブサイト名は必須です。',
	'The website URL is required.' => 'ウェブサイトURLは必須です。',
	'Your website URL is not valid.' => 'ウェブサイトURLが正しくありません。',
	'The publishing path is required.' => 'ブログのサイトパスは必須です。',
	'The timezone is required.' => 'タイムゾーンは必須です。',

## tmpl/cms/system_check.tmpl
	'Total Users' => '全ユーザー数',
	'Memcache Status' => 'Memcacheの状態',
	'configured' => '設定済み',
	'disabled' => '無効',
	'Memcache is [_1].' => 'Memcacheは[_1]です。',
	'available' => '利用可能',
	'unavailable' => '利用不可',
	'Memcache Server is [_1].' => 'Memcacheサーバーは[_1]です。',
	'Server Model' => 'サーバーモデル',
	q{Movable Type could not find the script named 'mt-check.cgi'. To resolve this issue, ensure that the mt-check.cgi script exists and that the CheckScript configuration parameter (if it is necessary) references it properly.} => q{mt-check.cgiが見つかりませんでした。mt-check.cgiが存在すること、名前を変えた場合は構成ファイルのCheckScriptディレクティブに名前を指定してください。},

## tmpl/cms/theme_export_replace.tmpl
	q{Export theme folder already exists '[_1]'. You can overwrite a existing theme, or cancel to change the Basename?} => q{テーマをエクスポートするフォルダ([_1])は既に存在します。上書き保存するか、キャンセルして出力ファイル名を変更してください。},
	'Overwrite' => '上書き保存',

## tmpl/cms/upgrade.tmpl
	'Time to Upgrade!' => 'アップグレード開始',
	'Upgrade Check' => 'アップグレードのチェック',
	'Do you want to proceed with the upgrade anyway?' => 'アップグレードを実行しますか?',
	q{A new version of Movable Type has been installed.  We'll need to complete a few tasks to update your database.} => q{新しいバージョンの Movable Type をインストールしました。データベースのアップグレードを実行してください。},
	q{The Movable Type Upgrade Guide can be found <a href='[_1]' target='_blank'>here</a>.} => q{Movable Typeアップグレードガイドは<a href='http://www.movabletype.jp/documentation/upgrade/' target='_blank'>こちらを</a>参照ください。},
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
	'System Activity Log' => 'システムログ',
	'Filtered' => 'フィルタ',
	'Filtered Activity Feed' => 'フィルタしたフィード',
	'Download Filtered Log (CSV)' => 'フィルタしたログをダウンロード(CSV)',
	'Showing all log records' => 'すべてのログレコードを表示',
	'Showing log records where' => 'ログレコード',
	'Show log records where' => 'ログレコードの',
	'level' => 'レベル',
	'classification' => '分類',

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Schwartzエラーログ',
	'Showing all Schwartz errors' => '全Schwartzエラー参照',

## tmpl/cms/widget/blog_stats.tmpl
	'Error retrieving recent entries.' => '最近のブログ記事を取得できませんでした。',
	'Loading recent entries...' => '最近のブログ記事を読み込んでいます...',
	'Jan.' => '1月',
	'Feb.' => '2月',
	'March' => '3月',
	'April' => '4月',
	'May' => '5月',
	'June' => '6月',
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
	'[quant,_1,page,pages]' => 'ページ[quant,_1,件,件]',
	'[quant,_1,comment,comments]' => 'コメント[quant,_1,件,件]',
	'No website could be found. [_1]' => 'ウェブサイトがありません。[_1]',
	'Create a new' => '新規作成',
	'[quant,_1,entry,entries]' => '記事[quant,_1,件,件]',
	'No blogs could be found.' => 'ブログがありません。',

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
	'Movable Type Online Manual' => 'Movable Typeオンラインマニュアル',
	q{Whether you're new to Movable Type or using it for the first time, learn more about what this tool can do for you.} => q{Movable Typeで何ができるか、詳しくはこちら。},

## tmpl/cms/widget/new_user.tmpl
	q{Welcome to Movable Type, the world's most powerful blogging, publishing and social media platform:} => q{世界で最もパワフルなブログ、ウェブサイト、ソーシャルメディアプラットフォームであるMovable Typeへようこそ:},

## tmpl/cms/widget/new_version.tmpl
	q{What's new in Movable Type [_1]} => q{Movable Type [_1] の新機能},

## tmpl/cms/widget/recent_blogs.tmpl
	'No blogs could be found. [_1]' => 'ブログがありません。[_1]',

## tmpl/cms/widget/recent_websites.tmpl

## tmpl/cms/widget/this_is_you.tmpl
	'Your <a href="[_1]">last entry</a> was [_2] in <a href="[_3]">[_4]</a>.' => '最後にブログ記事を書いたのは[_2]です(ブログ: <a href="[_3]">[_4]</a> - <a href="[_1]">編集</a>)。',
	'Your last entry was [_1] in <a href="[_2]">[_3]</a>.' => '最後にブログ記事を書いたのは[_1]です(ブログ: <a href="[_2]">[_3]</a>)',
	'You have <a href="[_1]">[quant,_2,draft,drafts]</a>.' => '下書きが<a href="[_1]">[quant,_2,件,件]</a>あります。',
	'You have [quant,_1,draft,drafts].' => '下書きが[quant,_1,件,件]あります。',
	q{You've written <a href="[_1]">[quant,_2,entry,entries]</a>, <a href="[_3]">[quant,_4,page,pages]</a> with <a href="[_5]">[quant,_6,comment,comments]</a>.} => q{記事が<a href="[_1]">[quant,_2,件,件]</a>、ページが<a href="[_3]">[quant,_4,件,件]</a>、コメントが<a href="[_5]">[quant,_6,件,件]</a>あります。},
	q{You've written <a href="[_1]">[quant,_2,entry,entries]</a>, <a href="[_3]">[quant,_4,page,pages]</a> with [quant,_5,comment,comments].} => q{記事が<a href="[_1]">[quant,_2,件,件]</a>、ページが<a href="[_3]">[quant,_4,件,件]</a>、コメント[quant,_5,件,件]あります。},
	q{You've written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages] with <a href="[_4]">[quant,_5,comment,comments]</a>.} => q{記事が<a href="[_1]">[quant,_2,件,件]</a>、ページが[quant,_3,件,件]、コメントが<a href="[_4]">[quant,_5,件,件]</a>あります。},
	q{You've written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages] with [quant,_4,comment,comments].} => q{記事が<a href="[_1]">[quant,_2,件,件]</a>、ページが[quant,_3,件,件]、コメントが[quant,_4,件,件]あります。},
	q{You've written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a> with <a href="[_4]">[quant,_5,comment,comments]</a>.} => q{記事が[quant,_1,件,件]、ページが<a href="[_2]">[quant,_3,件,件]</a>、コメントが<a href="[_4]">[quant,_5,件,件]</a>あります。},
	q{You've written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a> with [quant,_4,comment,comments].} => q{記事が[quant,_1,件,件]、ページが<a href="[_2]">[quant,_3,件,件]</a>、コメント[quant,_4,件,件]あります。},
	q{You've written [quant,_1,entry,entries], [quant,_2,page,pages] with <a href="[_3]">[quant,_4,comment,comments]</a>.} => q{記事が[quant,_1,件,件]、ページが[quant,_2,件,件]、コメントが<a href="[_3]">[quant,_4,件,件]</a>あります。},
	q{You've written [quant,_1,entry,entries], [quant,_2,page,pages] with [quant,_3,comment,comments].} => q{記事[quant,_1,件,件], ページ[quant,_2,件,件] コメント[quant,_3,件,件]あります。},
	q{You've written <a href="[_1]">[quant,_2,entry,entries]</a>, <a href="[_3]">[quant,_4,page,pages]</a>.} => q{記事が<a href="[_1]">[quant,_2,件,件]</a>、ページが<a href="[_3]">[quant,_4,件,件]</a>あります。},
	q{You've written <a href="[_1]">[quant,_2,entry,entries]</a>, [quant,_3,page,pages].} => q{記事が<a href="[_1]">[quant,_2,件,件]</a>、ページが[quant,_3,件,件]あります。},
	q{You've written [quant,_1,entry,entries], <a href="[_2]">[quant,_3,page,pages]</a>.} => q{記事が[quant,_1,entry,entries]、ページが<a href="[_2]">[quant,_3,件,件]</a>あります。},
	q{You've written [quant,_1,entry,entries], [quant,_2,page,pages].} => q{記事が[quant,_1,件,件]、ページが[quant,_2,件,件]あります。},
	q{You've written <a href="[_1]">[quant,_2,page,pages]</a> with <a href="[_3]">[quant,_4,comment,comments]</a>.} => q{ページが<a href="[_1]">[quant,_2,件,件]</a>、コメントが<a href="[_3]">[quant,_4,件,件]</a>あります。},
	q{You've written <a href="[_1]">[quant,_2,page,pages]</a> with [quant,_3,comment,comments].} => q{ページが<a href="[_1]">[quant,_2,件,件]</a>、コメントが[quant,_3,件,件]あります。},
	q{You've written [quant,_1,page,pages] with <a href="[_2]">[quant,_3,comment,comments]</a>.} => q{ページが[quant,_1,件,件]、コメントが<a href="[_2]">[quant,_3,件,件]</a>あります。},
	q{You've written [quant,_1,page,pages] with [quant,_2,comment,comments].} => q{ページが[quant,_1,件,件]、コメントが[quant,_2,件,件]あります。},
	'Edit your profile' => 'ユーザー情報の編集',

## tmpl/comment/auth_aim.tmpl
	'Your AIM or AOL Screen Name' => 'AIMまたはAOLのスクリーンネーム',
	'Sign in using your AIM or AOL screen name. Your screen name will be displayed publicly.' => 'AIMまたはAOLのスクリーンネームでサインインします。スクリーンネームは公開されます。',

## tmpl/comment/auth_googleopenid.tmpl
	'Sign in using your Gmail account' => 'Gmailのアカウントでサインインする',
	'Sign in to Movable Type with your[_1] Account[_2]' => '[_1] アカウント[_2]',

## tmpl/comment/auth_hatena.tmpl
	'Your Hatena ID' => 'はてなID',

## tmpl/comment/auth_livedoor.tmpl

## tmpl/comment/auth_livejournal.tmpl
	'Your LiveJournal Username' => 'あなたのLiveJournalのユーザー名',
	'Learn more about LiveJournal.' => 'LiveJournalについて詳しくはこちら',

## tmpl/comment/auth_openid.tmpl
	'OpenID URL' => 'あなたのOpenID URL',
	'Sign in with one of your existing third party OpenID accounts.' => 'すでに登録済みの、OpenIDに対応した別サービスのアカウントでサインインします。',
	'http://www.openid.net/' => 'http://www.sixapart.jp/about/openid.html',
	'Learn more about OpenID.' => 'OpenIDについて詳しくはこちら',

## tmpl/comment/auth_typepad.tmpl
	'TypePad is a free, open system providing you a central identity for posting comments on weblogs and logging into other websites. You can register for free.' => 'TypePadはブログにコメントを投稿したり他のウェブサイトにサインインするときに使える、フリーでオープンな認証システムを提供します。',
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
	'Back (s)' => '戻る (s)',

## tmpl/comment/login.tmpl
	'Sign in to comment' => 'サインインしてください',
	'Sign in using' => 'サインイン',
	'Not a member? <a href="[_1]">Sign Up</a>!' => 'アカウントがないときは<a href="[_1]">サインアップ</a>してください。',

## tmpl/comment/profile.tmpl
	'Your Profile' => 'ユーザー情報',
	'Your login name.' => 'あなたのユーザー名です。',
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
	'Unpublish' => '公開取り消し',
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

## tmpl/wizard/blog.tmpl
	'Setup Your First Blog' => 'First Blogのセットアップ',
	q{In order to properly publish your blog, you must provide Movable Type with your blog's URL and the path on the filesystem where its files should be published.} => q{ブログを公開するためのURLと、公開されるファイルのパスを設定する必要があります。},
	'My First Blog' => 'My First Blog',
	'Publishing Path' => '公開パス',
	q{Your 'Publishing Path' is the path on your web server's file system where Movable Type will publish all the files for your blog. Your web server must have write access to this directory.} => q{Movable Typeは、出力するすべてのファイルを「公開パス」以下に配置します。このディレクトリにはWebサーバーから書き込みできなければなりません。},

## tmpl/wizard/cfg_dir.tmpl
	'Temporary Directory Configuration' => 'テンポラリディレクトリの設定',
	'You should configure you temporary directory settings.' => 'テンポラリディレクトリの場所を指定してください。',
	q{Your TempDir has been successfully configured. Click 'Continue' below to continue configuration.} => q{TempDirを設定しました。次へボタンをクリックして先に進んでください。},
	'[_1] could not be found.' => '[_1]が見つかりませんでした。',
	'TempDir is required.' => 'TempDirが必要です。',
	'TempDir' => 'TempDir',
	'The physical path for temporary directory.' => 'TempDirへの物理パスを指定します。',

## tmpl/wizard/complete.tmpl
	'Configuration File' => '構成ファイル',
	'The [_1] configuration file cannot be located.' => '[_1]の構成ファイルを作成できませんでした。',
	q{Please use the configuration text below to create a file named 'mt-config.cgi' in the root directory of [_1] (the same directory in which mt.cgi is found).} => q{以下のテキストを利用して、mt-config.cgiという名前のファイルを[_1]のルートディレクトリ(mt.cgiがあるディレクトリ)に配置してください。},
	'The wizard was unable to save the [_1] configuration file.' => '[_1]の構成ファイルを保存できませんでした。',
	q{Confirm that your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click 'Retry'.} => q{[_1]ディレクトリ(mt.cgiを含んでいる場所)がウェブサーバーによって書き込めるか確認して、'再実行'をクリックしてください。},
	q{Congratulations! You've successfully configured [_1].} => q{[_1]の設定を完了しました。},
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
	'Send mail via:' => 'メール送信プログラム',
	'Sendmail Path' => 'sendmailのパス',
	'The physical file path for your Sendmail binary.' => 'sendmailへの物理パスを指定します。',
	'Outbound Mail Server (SMTP)' => '送信メールサーバー(SMTP)',
	'Address of your SMTP Server.' => 'SMTPサーバーのアドレスを指定します。',
	'Port number for Outbound Mail Server' => 'SMTPサーバのポート番号',
	'Port number of your SMTP Server.' => 'SMTPサーバのポート番号を指定します',
	'Use SMTP Auth' => 'SMTP認証を利用する',
	'SMTP Auth Username' => 'ユーザー名',
	'Username for your SMTP Server.' => 'SMTP認証に利用するユーザー名を指定してください。',
	'SMTP Auth Password' => 'パスワード',
	'Password for your SMTP Server.' => 'SMTP認証に利用するユーザーのパスワードを指定してください。',
	'SSL Connection' => 'SSL接続',
	'Cannot use [_1].' => '[_1] は利用できません。',
	'Do not use SSL' => 'SSL接続を行わない',
	'Use SSL' => 'SSLで接続する',
	'Use STARTTLS' => 'STARTTLSコマンドを利用する',
	'Send Test Email' => 'テストメールを送信',
	'Mail address to which test email should be sent' => 'テストメールが送られるメールアドレス',
	'Skip' => 'スキップ',
	'You must set the SMTP server port number.' => 'SMTPサーバのポート番号を指定してください。',
	'This field must be an integer.' => 'このフィールドには整数の値を入力して下さい',
	'You must set the system email address.' => 'システムメールアドレスは必須入力です。',
	'You must set the Sendmail path.' => 'Sendmailのパスは必須入力です。',
	'You must set the SMTP server address.' => 'SMTPサーバのアドレスを入力してください。',
	'You must set a username for the SMTP server.' => 'SMTP認証で利用するユーザー名を入力してください。',
	'You must set a password for the SMTP server.' => 'SMTP認証で利用するユーザーのパスワードを入力してください。',

## tmpl/wizard/packages.tmpl
	'Requirements Check' => 'システムチェック',
	q{The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your blog's data.  Please install one of the packages listed here in order to proceed.  When you are ready, click the 'Retry' button.} => q{データベース接続のための以下のPerlモジュールが必要です。Movable Typeはブログのデータを保存するためにデータベースを使用します。この一覧のパッケージのいずれかをインストールしてください。準備ができたら「再試行」のボタンをクリックしてください。},
	'All required Perl modules were found.' => '必要なPerlモジュールは揃っています。',
	'You are ready to proceed with the installation of Movable Type.' => 'Movable Typeのインストールを続行する準備が整いました。',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'オプションのPerlモジュールのうちいくつかが見つかりませんでした。<a href="javascript:void(0)" onclick="[_1]">オプションモジュールを表示</a>',
	'One or more Perl modules required by Movable Type could not be found.' => 'ひとつ以上の必須Perlモジュールが見つかりませんでした。',
	q{The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the 'Retry' button to re-test for these packages.} => q{以下のPerlモジュールはMovable Typeの正常な動作に必要です。必要なモジュールは「再試行」ボタンをクリックすることで確認できます。},
	q{Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click 'Retry' to test for the modules again.} => q{オプションのPerlモジュールのうちいくつかが見つかりませんでしたが、インストールはこのまま続行できます。オプションのPerlモジュールは、必要な場合にいつでもインストールできます。},
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
	'Configure Static Web Path' => 'スタティックウェブパスの設定',
	q{<strong>Error: '[_1]' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.} => q{エラー: '[_1]'が見つかりませんでした。ファイルをmt-staticディレクトリに移動するか、設定を修正してください。},
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Typeには、[_1]ディレクトリが標準で含まれています。この中には画像ファイルやJavaScript、スタイルシートなどの重要なファイルが含まれています。',
	q{The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server's configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).} => q{[_1]ディレクトリは、Movable Typeのメインディレクトリ(このウィザード自身も含まれている)以下で見つかりました。しかし現在のサーバーの構成上、その場所にはWebブラウザからアクセスできません。ウェブサイトのルートディレクトリの下など、Webブラウザからアクセスできる場所に移動してください。},
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'mt-static ディレクトリはMovable Typeのインストールディレクトリの外部に移動されたかまたは名前が変更されているようです。',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => '[_1]ディレクトリをウェブアクセス可能な場所に置く場合には、以下にその場所を指定してください。',
	'This URL path can be in the form of [_1] or simply [_2]' => 'このURLは[_1]のように記述するか、または簡略化して[_2]のように記述できます。',
	'This path must be in the form of [_1]' => 'このパスは[_1]のように記述してください。',
	'Static web path' => 'スタティックウェブパス',
	'Static file path' => 'スタティックファイルパス',
	'Begin' => '開始',
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => '構成ファイル(mt-config.cgi)はすでに存在します。Movable Typeに<a href="[_1]">サインイン</a>してください。',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'ウィザードで新しく構成ファイルを作るときは、現在の構成ファイルを別の場所に移動してこのページを更新してください。',

## addons/Cloud.pack/config.yaml
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.jp/movabletype/',
	'Cloud Services' => 'クラウドサービス',
	'Basic Authentication' => 'Basic認証',
	'HTTP Redirect' => 'HTTPリダイレクト',
	'FTPS Password' => 'FTPSパスワードリセット',
	'Full Restore' => '環境のリストア',
	'SSL Certifications' => 'サーバー証明書',
	'Config Directives' => 'MT環境変数',
	'Sync' => 'サーバー配信',
	'Contents Sync' => 'サーバー配信',

## addons/Cloud.pack/lib/Cloud/App/CMS.pm
	'Owner' => 'ブログ管理者',
	'Creator' => '制作者',
	'Unable to reset [_1] FTPS password.' => 'FTPSパスワードのリセットが出来ませんでした。',
	'Failed to update [_1]: some of [_2] were changed after you opened this screen.' => 'いくつかの[_2]がすでに更新されていたため、[_1]の更新に失敗しました。',
	'Basic Authentication setting' => 'Basic認証の設定',
	'Cannot access to this uri: [_1]' => '[_1]が存在しません。',
	'Unable to update Basic Authentication settings.' => 'Basic認証の設定を保存する事が出来ませんでした。',
	'Administration Screen Setting' => '管理画面の設定',
	'The URL you specified is not available.' => '指定されたURLは利用できません。',
	'Unable to update Admin Screen URL settings.' => '管理画面のURLを変更できませんでした。',
	'Cannot delete basicauth_admin file.' => 'Basic認証の設定を削除する事が出来ませんでした。',
	'User ID is required.' => 'ユーザー名は必須です。',
	'Password is required.' => 'パスワードは必須です。',
	'Unable to write temporary file.' => '一時保存ファイルの書き込みが出来ませんでした。',
	'HTTP Redirect setting' => 'HTTPリダイレクトの設定',
	'Unable to update HTTP Redirect settings.' => 'HTTPリダイレクトの設定を保存することが出来ませんでした。',
	'Update SSL Certification' => 'サーバー証明書の更新',
	'__SSL_CERT_UPDATE' => '更新',
	'__SSL_CERT_INSTALL' => '導入',
	'Cannot copy default cert file.' => '既定のサーバー証明書のコピーに失敗しました。',
	'Cannot copy default secret file.' => '既定のサーバーキーのコピーに失敗しました。',
	'Unable to update SSL certification.' => 'サーバー証明書の更新をする事が出来ませんでした。',
	'Config Directive' => '環境変数',
	'Saving sync settings failed: [_1]' => 'サーバー配信の設定を保存できませんでした',
	'Restoring Backup Data' => 'バックアップデータの復元',
	'backup data' => 'バックアップデータ',
	'Invalid backup file name.' => '不正なバックアップファイルです。',
	'Cannot copy backup file to workspace.' => 'バックアップファイルのコピーに失敗しました。',
	'Unable to create temporary path: [_1]' => 'テンポラリディレクトリの作成に失敗しました: [_1]',

## addons/Cloud.pack/lib/MT/FileSynchronizer.pm
	'Synchronization with an external server has been successfully finished.' => 'サーバー配信が正常に処理されました',
	'Failed to sync with an external server.' => 'サーバー配信に失敗しました',

## addons/Cloud.pack/lib/MT/FileSynchronizer/FTPBase.pm
	'Cannot access to remote directory \'[_1]\'' => 'リモートディレクトリ\'[_1]\'にアクセスできません。',
	'Deleting path \'[_1]\' failed.' => 'ディレクトリ\'[_1]\'を削除できませんでした。',
	'Deleting file \'[_1]\' failed.' => 'ファイル\'[_1]\'を削除できませんでした。',
	'Unable to write temporary file ([_1]): [_2]' => '一時ファイル([_1])の書き込みができませんでした: [_2]',
	'Unable to write remote file ([_1]): [_2]' => 'アップロード先にファイル([_1])を書き込めませんでした:[_2]',

## addons/Cloud.pack/lib/MT/SyncSetting.pm
	'Sync settings' => 'サーバー配信の設定',

## addons/Cloud.pack/lib/MT/Worker/ContentsSync.pm
	'This email is to notify you that failed to sync with an external server.' => 'これはサーバー配信の処理に失敗したことを通知するメールです。',
	'This email is to notify you that synchronization with an external server has been successfully finished.' => 'これはサーバー配信の処理に成功したことを通知するメールです。',

## addons/Cloud.pack/tmpl/cfg_basic_authentication.tmpl
	'Manage Basic Authentication' => 'Basic認証の管理',
	'/path/to/authentication' => '/path/to/authentication',
	'User ID' => 'ユーザー名',
	'Remove this setting' => '設定の削除',
	'URI is required.' => 'URIは必須です。',
	'Invalid URI.' => '不正なURIです。',
	'User ID must be with alphabet, number or symbols (excludes back slash) only.' => 'ユーザー名は半角英数または記号のみ利用可能です。(バックスラッシュを除く)',
	'Password must be with alphabet, number or symbols (excludes back slash) only.' => 'パスワードは半角英数または記号のみ利用可能です。(バックスラッシュを除く)',
	'basic authentication setting' => 'Basic認証の設定',
	'basic authentication settings' => 'Basic認証の設定',

## addons/Cloud.pack/tmpl/cfg_config_directives.tmpl
	'Manage Configuration Directives' => '環境変数の管理',
	'Configuration directive' => '環境変数',
	'View Documentation' => 'ドキュメントの参照',
	'Configuration value' => '設定値',
	'Remove Config Directive' => '環境変数の削除',

## addons/Cloud.pack/tmpl/cfg_contents_sync.tmpl
	'Contents Sync Setting' => 'サーバー配信設定',
	'Contents sync settings has been saved.' => 'サーバー配信の設定を保存しました。',
	'An error occured while trying to connect to the FTP server. Check the settings and try again.' => 'FTPサーバーに接続できませんでした。設定を見直してもう一度接続してください。',
	'One or more templates are set to the Dynamic Publishing. Dynamic Publishing may not work properly on the destination server.' => '一つ以上のテンプレートがダイナミックパブリッシングに設定されています。ダイナミックパブリッシングは、宛先サーバー上で正しく動作しない場合があります。',
	'Enable contents synchronization' => 'サーバー配信を有効にする',
	'Sync Settings' => 'サーバー配信の設定',
	'Sync Date' => 'サーバー配信日時',
	'Sync Now!' => '今すぐ配信',
	'Recipient for Notification' => '配信結果の通知先メールアドレス',
	'Receive only error notification' => '配信に失敗したときだけ受け取る',
	'FTP Settings' => 'FTPの設定',
	'FTP Server' => 'FTPサーバー',
	'Port' => 'FTPサーバーのポート',
	'SSL' => 'SSL',
	'Enable SSL' => 'SSLで接続する',
	'Start Directory' => '開始ディレクトリ',
	'The sync date must be in the future.' => 'サーバー配信日時は、未来の日時を指定してください。',
	'Invalid time.' => '無効な時刻指定です。',
	'Do you want to synchronize the contents just now?' => 'いますぐ配信を実行しますか？',

## addons/Cloud.pack/tmpl/cfg_ftps_password.tmpl
	'Reset FTPS Password' => 'FTPSパスワードのリセット',
	'Please select the account for which you want to reset the password.' => 'FTPSパスワードのリセットを行うアカウントを選択してください。',
	'Owner Password' => 'ブログ管理者のパスワード',
	'Saved' => '保存しました',
	'Creater Password' => '制作者のパスワード',

## addons/Cloud.pack/tmpl/cfg_http_redirect.tmpl
	'Manage HTTP Redirect' => 'HTTPリダイレクトの管理',
	'/path/of/redirect' => '/path/of/redirect',
	'__REDIRECT_TO' => 'リダイレクト先',
	'http://example.com or /path/to/redirect' => 'http://example.com 又は /path/to/redirect',
	'Redirect URL is required.' => 'リダイレクト先URLは必須です。',
	'Redirect url is same as URI' => 'リダイレクト先URLは、がリダイレクト元URIと違うURLを設定してください。',
	'HTTP redirect setting' => 'HTTPリダイレクトの設定',
	'HTTP redirect settings' => 'HTTPリダイレクトの設定',

## addons/Cloud.pack/tmpl/cfg_security.tmpl
	'Administration screen setting have been saved.' => '管理画面の設定を保存しました。',
	'Administration screen url have been reset to default.' => '管理画面のURLが既定のURLにリセットされました。',
	'Admin Screen URL' => '管理画面のURL',
	'Protect administration screen by Basic Authentication' => '管理画面をBasic認証で保護する',

## addons/Cloud.pack/tmpl/cfg_ssl_certification.tmpl
	'Install SSL Certification' => 'サーバー証明書の導入',
	'SSL certification have been updated.' => 'サーバー証明書が更新されました。',
	'SSL certification have been reset to default.' => 'サーバー証明書が既定の証明書にリセットされました。',
	'The current server certification is as follows.' => '現在のサーバー証明書は以下の通りです。',
	q{To [_1] the server certificate, please enter the required information in the following fields. To revert back to the initial certificate, please press the 'Remove SSL Certification' button. The passphrase for 'Secret Key' must be released.} => q{サーバー証明書の[_1]を行うには、以下のフィールドに情報を入力してください。現在の証明書を削除して既定の証明書に戻すには、'サーバー証明書の削除'ボタンを押してください。秘密鍵のパスフレーズは解除されている必要があります。},
	'Server Certification' => '証明書 (server.crt)',
	'Secret Key' => '秘密鍵 (server.key)',
	'Remove SSL Certification' => 'サーバー証明書の削除',

## addons/Cloud.pack/tmpl/dialog/contents_sync_now.tmpl
	'Preparing...' => 'サーバー配信の準備をしています...',
	'Synchronizing...' => '配信中です...',
	'Finish!' => 'ファイルが配信されました!',
	'The synchronization was interrupted. Unable to resume.' => 'サーバー配信が中断されました。再開できません。',

## addons/Cloud.pack/tmpl/full_restore.tmpl
	'Restoring Full Backup Data' => 'バックアップデータからの復元',
	q{Restored backup data from '[_1]' at [_2]} => q{[_2]に[_1]のバックアップデータから復元されています。},
	'When restoring back-up data, the contents will revert to the point when the back-up data was created. Please note that any changes made to the data, contents, and received comments and trackback after this restoration point will be discarded. Also, while in the process of restoration, any present data will be backed up automatically. After restoration is complete, it is possible to return to the status of the data before restoration was executed.' => 'バックアップデータの復元を実行すると、全てのコンテンツがバックアップデータ作成時の状態に戻ります。復元元のバックアップデータが作成されてから保存された内容や、復元実行中に受信したコメントやトラックバックは破棄されますのでご注意ください。また、復元を実行する前に現在の状態のバックアップを自動的に行います。バックアップデータの復元後に復元の実行前の状態に戻すことが可能です。',
	'Are you sure you want restore from selected backup file?' => '選択されたバックアップファイルからの復元を行いますか?',

## addons/Commercial.pack/config.yaml
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.jp/movabletype/',
	'Professional designed, well structured and easily adaptable web site. You can customize default pages, footer and top navigation easily.' => 'バナー画像、水平型のナビゲーションなど、ホームページ用途に適したデザインです。あらかじめ用意されたページをカスタマイズして、簡単にウェブサイトを作成できます。',
	'_PWT_ABOUT_BODY' => '
<p><strong>以下の文章はサンプルです。内容を適切に書き換えてください。</strong></p>
<p>いろはにほへと ちりぬるを わかよたれそ つねならむ うゐのおくやま けふこえて あさきゆめみし ゑひもせす</p>
<p>色は匂へど 散りぬるを 我が世誰ぞ 常ならむ 有為の奥山 今日越えて 浅き夢見じ 酔ひもせず</p>
',
	'_PWT_CONTACT_BODY' => '
<p><strong>以下の文章はサンプルです。内容を適切に書き換えてください。</strong></p>
<p>お問い合わせはメールで: email (at) domainname.com</p>
',
	'Welcome to our new website!' => '新しいウェブサイトへようこそ!',
	'_PWT_HOME_BODY' => '
<p><strong>以下の文章はサンプルです。内容を適切に書き換えてください。</strong></p>
<p>いろはにほへと ちりぬるを わかよたれそ つねならむ うゐのおくやま けふこえて あさきゆめみし ゑひもせす</p>
<p>色は匂へど 散りぬるを 我が世誰ぞ 常ならむ 有為の奥山 今日越えて 浅き夢見じ 酔ひもせず</p>
<p>あめ つち ほし そら やま かは みね たに くも きり むろ こけ ひと いぬ うへ すゑ ゆわ さる おふ せよ えのえを なれ ゐて</p>
',
	'Create a blog as a part of structured website. This works best with Professional Website theme.' => 'プロフェッショナル ウェブサイトと連携する、ブログのテーマです。',
	'Unknown Type' => '不明な種類',
	'Unknown Object' => '不明なオブジェクト',
	'Not Required' => '必須ではない',
	'Are you sure you want to delete the selected CustomFields?' => '選択したカスタムフィールドを削除してもよろしいですか？',
	'Photo' => '写真',
	'Embed' => '埋め込み',
	'Custom Fields' => 'カスタムフィールド',
	'Field' => 'フィールド',
	'Template tag' => 'テンプレートタグ',
	'Updating Universal Template Set to Professional Website set...' => '汎用テンプレートセットをプロフェッショナルウェブサイトテンプレートセットにアップデートしています...',
	'Migrating CustomFields type...' => 'カスタムフィールドのタイプをアップデートしています...',
	'Converting CustomField type...' => 'カスタムフィールドのタイプを変換しています...',
	'Professional Styles' => 'プロフェッショナルスタイル',
	'A collection of styles compatible with Professional themes.' => 'プロフェッショナルテーマと互換のあるスタイルです。',
	'Professional Website' => 'プロフェッショナル ウェブサイト',
	'Blog Index' => 'ブログのメインページ',
	'Header' => 'ヘッダー',
	'Footer' => 'フッター',
	'Entry Metadata' => 'ブログ記事のメタデータ',
	'Page Detail' => 'ウェブページの詳細',
	'Footer Links' => 'フッターのリンク',
	'Powered By (Footer)' => 'Powered By (フッター)',
	'Recent Entries Expanded' => '最近のブログ記事 (拡張)',
	'Main Sidebar' => 'メインサイドバー',
	'Blog Activity' => 'アクティビティ',
	'Professional Blog' => 'プロフェッショナルブログ',
	'Entry Detail' => 'ブログ記事の詳細',
	'Blog Archives' => 'アーカイブ',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Show' => '表示項目',
	'Date & Time' => '日付と時刻',
	'Date Only' => '日付',
	'Time Only' => '時刻',
	'Please enter all allowable options for this field as a comma delimited list' => 'このフィールドで有効なすべてのオプションをカンマで区切って入力してください。',
	'Exclude Custom Fields' => 'カスタムフィールドの除外',
	'[_1] Fields' => '[_1]フィールド',
	'Edit Field' => 'フィールドの編集',
	'Invalid date \'[_1]\'; dates must be in the format YYYY-MM-DD HH:MM:SS.' => '日時が不正です。日時はYYYY-MM-DD HH:MM:SSの形式で入力してください。',
	'Invalid date \'[_1]\'; dates should be real dates.' => '日時が不正です。',
	'Please enter valid URL for the URL field: [_1]' => 'URLを入力してください。[_1]',
	'Please enter some value for required \'[_1]\' field.' => '「[_1]」は必須です。値を入力してください。',
	'Please ensure all required fields have been filled in.' => '必須のフィールドに値が入力されていません。',
	'The template tag \'[_1]\' is an invalid tag name.' => '[_1]というタグ名は不正です。',
	'The template tag \'[_1]\' is already in use.' => '[_1]というタグは既に存在します。',
	'blog and the system' => 'ブログとシステム',
	'website and the system' => 'ウェブサイトとシステム',
	'The basename \'[_1]\' is already in use. It must be unique within this [_2].' => '[_1]というベースネームはすでに使われています。[_2]内で重複しない値を入力してください。',
	'You must select other type if object is the comment.' => 'コメントでない場合、他の種類を選択する必要があります。',
	'type' => '種類',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => 'ブログ記事、ウェブページ、フォルダ、カテゴリ、ユーザーのフォームとフィールドをカスタマイズして、必要な情報を格納することができます。',
	' ' => ' ',
	'Single-Line Text' => 'テキスト',
	'Multi-Line Text' => 'テキスト(複数行)',
	'Checkbox' => 'チェックボックス',
	'Date and Time' => '日付と時刻',
	'Drop Down Menu' => 'ドロップダウン',
	'Radio Buttons' => 'ラジオボタン',
	'Embed Object' => '埋め込みオブジェクト',
	'Post Type' => '投稿タイプ',

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Restoring custom fields data stored in MT::PluginData...' => 'MT::PluginDataに保存されているカスタムフィールドのデータを復元しています...',
	'Restoring asset associations found in custom fields ( [_1] ) ...' => 'カスタムフィールド([_1])に含まれるアイテムとの関連付けを復元しています...',
	'Restoring url of the assets associated in custom fields ( [_1] )...' => 'カスタムフィールド([_1])に含まれるアイテムのURLを復元しています...',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'The template tag \'[_1]\' is already in use in the system level' => '[_1]というタグは既にシステムに存在します。',
	'The template tag \'[_1]\' is already in use in [_2]' => '[_1]というタグは既に[_2]に存在します。',
	'The template tag \'[_1]\' is already in use in this blog' => '[_1]というタグは既にこのブログに存在します。',
	'The \'[_1]\' of the template tag \'[_2]\' that is already in use in [_3] is [_4].' => '[_1]が違う\'[_2]\'というタグが[_3]に見つかったため、保存できません。([_1]: [_4])',
	'_CF_BASENAME' => 'ベースネーム',

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	'Are you sure you have used a \'[_1]\' tag in the correct context? We could not find the [_2]' => '[_2]が見つかりませんでした。[_1]タグを正しいコンテキストで使用しているか確認してください。',
	'You used an \'[_1]\' tag outside of the context of the correct content; ' => '[_1]タグを正しいコンテキストで使用していません。',

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'[_1] custom fields' => 'カスタムフィールド: [_1]',
	'a field on this blog' => 'このブログのカスタムフィールド',
	'a field on system wide' => 'システム全体のカスタムフィールド',
	'Conflict of [_1] "[_2]" with [_3]' => '[_3] と[_1]「[_2]」が衝突しています',
	'Template Tag' => 'テンプレートタグ',

## addons/Commercial.pack/lib/CustomFields/Upgrade.pm
	'Moving metadata storage for pages...' => 'ウェブページのメタデータ格納先を変更しています...',
	'Removing CustomFields display-order from plugin data...' => 'カスタムフィールドの古い並び順を削除しています...',
	'Removing unlinked CustomFields...' => '不要なカスタムフィールドを削除しています。',

## addons/Commercial.pack/lib/CustomFields/Util.pm
	'Cloning fields for blog:' => 'カスタムフィールドを複製しています:',

## addons/Commercial.pack/templates/professional/blog/about_this_page.mtml

## addons/Commercial.pack/templates/professional/blog/archive_index.mtml

## addons/Commercial.pack/templates/professional/blog/archive_widgets_group.mtml

## addons/Commercial.pack/templates/professional/blog/author_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/calendar.mtml

## addons/Commercial.pack/templates/professional/blog/categories.mtml

## addons/Commercial.pack/templates/professional/blog/category_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/comment_detail.mtml

## addons/Commercial.pack/templates/professional/blog/comment_form.mtml

## addons/Commercial.pack/templates/professional/blog/comment_listing.mtml

## addons/Commercial.pack/templates/professional/blog/comment_preview.mtml

## addons/Commercial.pack/templates/professional/blog/comment_response.mtml

## addons/Commercial.pack/templates/professional/blog/comments.mtml

## addons/Commercial.pack/templates/professional/blog/creative_commons.mtml

## addons/Commercial.pack/templates/professional/blog/current_author_monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/current_category_monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/date_based_author_archives.mtml

## addons/Commercial.pack/templates/professional/blog/date_based_category_archives.mtml

## addons/Commercial.pack/templates/professional/blog/dynamic_error.mtml

## addons/Commercial.pack/templates/professional/blog/entry.mtml

## addons/Commercial.pack/templates/professional/blog/entry_detail.mtml

## addons/Commercial.pack/templates/professional/blog/entry_listing.mtml
	'Recently by <em>[_1]</em>' => '<em>[_1]</em>の最近のブログ記事',

## addons/Commercial.pack/templates/professional/blog/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/blog/entry_summary.mtml

## addons/Commercial.pack/templates/professional/blog/footer.mtml

## addons/Commercial.pack/templates/professional/blog/footer_links.mtml
	'Links' => 'リンク',

## addons/Commercial.pack/templates/professional/blog/header.mtml

## addons/Commercial.pack/templates/professional/blog/javascript.mtml

## addons/Commercial.pack/templates/professional/blog/main_index.mtml

## addons/Commercial.pack/templates/professional/blog/main_index_widgets_group.mtml

## addons/Commercial.pack/templates/professional/blog/monthly_archive_dropdown.mtml

## addons/Commercial.pack/templates/professional/blog/monthly_archive_list.mtml

## addons/Commercial.pack/templates/professional/blog/navigation.mtml

## addons/Commercial.pack/templates/professional/blog/openid.mtml

## addons/Commercial.pack/templates/professional/blog/page.mtml

## addons/Commercial.pack/templates/professional/blog/pages_list.mtml

## addons/Commercial.pack/templates/professional/blog/powered_by_footer.mtml

## addons/Commercial.pack/templates/professional/blog/recent_assets.mtml

## addons/Commercial.pack/templates/professional/blog/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] から [_3] に対するコメント</a>: [_4]',

## addons/Commercial.pack/templates/professional/blog/recent_entries.mtml

## addons/Commercial.pack/templates/professional/blog/search.mtml

## addons/Commercial.pack/templates/professional/blog/search_results.mtml

## addons/Commercial.pack/templates/professional/blog/sidebar.mtml

## addons/Commercial.pack/templates/professional/blog/signin.mtml

## addons/Commercial.pack/templates/professional/blog/syndication.mtml

## addons/Commercial.pack/templates/professional/blog/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/blog/tags.mtml

## addons/Commercial.pack/templates/professional/blog/trackbacks.mtml

## addons/Commercial.pack/templates/professional/website/blog_index.mtml

## addons/Commercial.pack/templates/professional/website/blogs.mtml
	'Entries ([_1]) Comments ([_2])' => '記事([_1]) コメント([_2])',

## addons/Commercial.pack/templates/professional/website/comment_detail.mtml

## addons/Commercial.pack/templates/professional/website/comment_form.mtml

## addons/Commercial.pack/templates/professional/website/comment_listing.mtml

## addons/Commercial.pack/templates/professional/website/comment_preview.mtml

## addons/Commercial.pack/templates/professional/website/comment_response.mtml

## addons/Commercial.pack/templates/professional/website/comments.mtml

## addons/Commercial.pack/templates/professional/website/dynamic_error.mtml

## addons/Commercial.pack/templates/professional/website/entry_metadata.mtml

## addons/Commercial.pack/templates/professional/website/entry_summary.mtml

## addons/Commercial.pack/templates/professional/website/footer.mtml

## addons/Commercial.pack/templates/professional/website/footer_links.mtml

## addons/Commercial.pack/templates/professional/website/header.mtml

## addons/Commercial.pack/templates/professional/website/javascript.mtml

## addons/Commercial.pack/templates/professional/website/main_index.mtml

## addons/Commercial.pack/templates/professional/website/navigation.mtml

## addons/Commercial.pack/templates/professional/website/openid.mtml

## addons/Commercial.pack/templates/professional/website/page.mtml

## addons/Commercial.pack/templates/professional/website/pages_list.mtml

## addons/Commercial.pack/templates/professional/website/powered_by_footer.mtml

## addons/Commercial.pack/templates/professional/website/recent_entries_expanded.mtml
	'on [_1]' => '[_1]ブログ上',
	'By [_1] | Comments ([_2])' => '[_1] | コメント([_2])',

## addons/Commercial.pack/templates/professional/website/search.mtml

## addons/Commercial.pack/templates/professional/website/search_results.mtml
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'すべての単語が順序に関係なく検索されます。フレーズで検索したいときは引用符で囲んでください。',

## addons/Commercial.pack/templates/professional/website/sidebar.mtml

## addons/Commercial.pack/templates/professional/website/signin.mtml

## addons/Commercial.pack/templates/professional/website/syndication.mtml

## addons/Commercial.pack/templates/professional/website/tag_cloud.mtml

## addons/Commercial.pack/templates/professional/website/tags.mtml

## addons/Commercial.pack/templates/professional/website/trackbacks.mtml

## addons/Commercial.pack/tmpl/asset-chooser.tmpl
	'Choose [_1]' => '[_1]を選択',

## addons/Commercial.pack/tmpl/category_fields.tmpl
	'Show These Fields' => 'フィールド表示',

## addons/Commercial.pack/tmpl/cfg_customfields.tmpl
	'Data have been saved to custom fields.' => 'データはカスタムフィールドに保存されました。',
	'Save changes to blog (s)' => 'ブログに変更を保存',
	'No custom fileds could be found. <a href="[_1]">Create a field</a> now.' => 'カスタムフィールドがありません。<a href="[_1]">カスタムフィールドを作成</a>する。',

## addons/Commercial.pack/tmpl/edit_field.tmpl
	'Edit Custom Field' => 'カスタムフィールドの編集',
	'Create Custom Field' => 'カスタムフィールドの作成',
	'The selected field(s) has been deleted from the database.' => '選択されたフィールドはデータベースから削除されました。',
	'You must enter information into the required fields highlighted below before the custom field can be created.' => 'すべての必須フィールドに値を入力してください。',
	'You must save this custom field before setting a default value.' => '既定の値を設定する前に、このカスタムフィールドを保存する必要があります。',
	'Choose the system object where this custom field should appear.' => 'フィールドを追加するオブジェクトを選択してください。',
	'Required?' => '必須?',
	'Is data entry required in this custom field?' => 'このカスタムフィールドはデータ入力が必須ですか?',
	'Must the user enter data into this custom field before the object may be saved?' => 'フィールドに値は必須ですか?',
	'Default' => '既定値',
	'The basename must be unique within this [_1].' => 'ベースネームは、[_1]内で重複しない値を入力してください。',
	q{Warning: Changing this field's basename may require changes to existing templates.} => q{警告: このフィールドのベースネームを変更すると、テンプレートにも修正が必要になることがあります。},
	'Example Template Code' => 'テンプレートの例',
	'Show In These [_1]' => '[_1]に表示',
	'Save this field (s)' => 'このフィールドを保存 (s)',
	'field' => 'フィールド',
	'fields' => 'フィールド',
	'Delete this field (x)' => 'フィールドを削除 (x)',

## addons/Commercial.pack/tmpl/export_field.tmpl
	'Object' => 'オブジェクト',

## addons/Commercial.pack/tmpl/listing/field_list_header.tmpl

## addons/Commercial.pack/tmpl/reorder_fields.tmpl
	'open' => '開く',
	'click-down and drag to move this field' => 'フィールドをドラッグして移動します。',
	'click to %toggle% this box' => '%toggle%ときはクリックします。',
	'use the arrow keys to move this box' => '矢印キーでボックスを移動します。',
	', or press the enter key to %toggle% it' => '%toggle%ときはENTERキーを押します。',

## addons/Community.pack/config.yaml
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.jp/movabletype/',
	'Increase reader engagement - deploy features to your website that make it easier for your readers to engage with your content and your company.' => 'ブログの読者も参加して、コミュニティでコンテンツを更新するグループブログです。',
	'Create forums where users can post topics and responses to topics.' => 'フォーラム形式のコミュニティ掲示板です。トピックを公開して、返信を投稿します。',
	'Users followed by [_1]' => '[_1]に注目されているユーザー',
	'Users following [_1]' => '[_1]に注目しているユーザー',
	'Community' => 'コミュニティ',
	'Sanitize' => 'Sanitize',
	'Followed by' => 'フォロワー',
	'Followers' => '被注目',
	'Following' => '注目',
	'Pending Entries' => '承認待ちのブログ記事',
	'Spam Entries' => 'スパムブログ記事',
	'Recently Scored' => '最近評価されたブログ記事',
	'Recent Submissions' => '最近の投稿',
	'Most Popular Entries' => '評価の高いブログ記事',
	'Registrations' => '登録数',
	'Login Form' => 'ログインフォーム',
	'Registration Form' => '登録フォーム',
	'Registration Confirmation' => '登録の確認',
	'Profile Error' => 'プロフィールエラー',
	'Profile View' => 'プロフィール',
	'Profile Edit Form' => 'プロフィールの編集フォーム',
	'Profile Feed' => 'プロフィールフィード',
	'New Password Form' => '新しいパスワードの設定フォーム',
	'New Password Reset Form' => '新しいパスワード再設定フォーム',
	'Form Field' => 'フォームフィールド',
	'Status Message' => 'ステータスメッセージ',
	'Simple Header' => 'シンプルヘッダー',
	'Simple Footer' => 'シンプルフッター',
	'Header' => 'ヘッダー',
	'Footer' => 'フッター',
	'GlobalJavaScript' => 'GlobalJavaScript',
	'Email verification' => 'メールアドレスの確認',
	'Registration notification' => '登録通知',
	'New entry notification' => 'ブログ記事の投稿通知',
	'Community Styles' => 'コミュニティースタイル',
	'A collection of styles compatible with Community themes.' => 'コミュニティーテーマ互換のスタイルです。',
	'Community Blog' => 'コミュニティブログ',
	'Atom ' => 'Atom',
	'Entry Response' => '投稿完了',
	'Displays error, pending or confirmation message when submitting an entry.' => '投稿時のエラー、保留、確認メッセージを表示します。',
	'Entry Detail' => 'ブログ記事の詳細',
	'Entry Metadata' => 'ブログ記事のメタデータ',
	'Page Detail' => 'ウェブページの詳細',
	'Entry Form' => 'ブログ記事フォーム',
	'Content Navigation' => 'コンテンツのナビゲーション',
	'Activity Widgets' => 'アクティビティウィジェット',
	'Archive Widgets' => 'アーカイブウィジェット',
	'Community Forum' => 'コミュニティ掲示板',
	'Entry Feed' => 'ブログ記事のフィード',
	'Displays error, pending or confirmation message when submitting a entry.' => '投稿エラー、保留、確認メッセージを表示します。',
	'Popular Entry' => '人気のブログ記事',
	'Entry Table' => 'ブログ記事一覧',
	'Content Header' => 'コンテンツヘッダー',
	'Category Groups' => 'カテゴリグループ',
	'Default Widgets' => '既定のウィジェット',

## addons/Community.pack/lib/MT/App/Community.pm
	'No login form template defined' => 'ログインフォームのテンプレートがありません。',
	'Before you can sign in, you must authenticate your email address. <a href="[_1]">Click here</a> to resend the verification email.' => 'サインインする前にメールアドレスを確認する必要があります。確認メールを再送したい場合は<a href="[_1]">ここをクリック</a>してください。',
	'You are trying to redirect to external resources: [_1]' => '外部のサイトへリダイレクトしようとしています。[_1]',
	'Successfully authenticated but signing up is not allowed.  Please contact system administrator.' => '認証されましたが、登録は許可されていません。システム管理者に連絡してください。',
	'(No email address)' => '(メールアドレスがありません)',
	'User \'[_1]\' (ID:[_2]) has been successfully registered.' => 'ユーザー「[_1]」(ID: [_2])が登録されました。',
	'Thanks for the confirmation.  Please sign in.' => '確認されました。サインインしてください。',
	'[_1] registered to Movable Type.' => '[_1]はMovable Typeに登録しました。',
	'Login required' => 'サインインしてください。',
	'Title or Content is required.' => '本文とタイトルを入力してください。',
	'Publish failed: [_1]' => '公開できませんでした: [_1]',
	'System template entry_response not found in blog: [_1]' => 'ブログ記事の確認テンプレートがありません。',
	'New entry \'[_1]\' added to the blog \'[_2]\'' => 'ブログ「[_2]」に新しいブログ記事「[_1]」が投稿されました。',
	'Id or Username is required' => 'IDまたはユーザー名が必要です。',
	'Unknown user' => 'ユーザーが不明です。',
	'All required fields must have valid values.' => '必須フィールドのすべてに正しい値を設定してください。',
	'Recent Entries from [_1]' => '[_1]の最近のブログ記事',
	'Responses to Comments from [_1]' => '[_1]のコメントへの返信',
	'Actions from [_1]' => '[_1]のアクション',

## addons/Community.pack/lib/MT/Community/CMS.pm
	'Movable Type was unable to write on the "Upload Destination". Please make sure that the folder is writable from the web server.' => 'アップロード先のディレクトリに書き込みできません。ウェブサーバーから書き込みできるパーミッションを与えてください。',

## addons/Community.pack/lib/MT/Community/Tags.pm
	'You used an \'[_1]\' tag outside of the block of MTIfEntryRecommended; perhaps you mistakenly placed it outside of an \'MTIfEntryRecommended\' container?' => '[_1]をコンテキスト外で利用しようとしています。MTIfEntryRecommendedコンテナタグの外部で使っていませんか?',
	'Click here to recommend' => 'クリックして投票',
	'Click here to follow' => '注目する',
	'Click here to leave' => '注目をやめる',

## addons/Community.pack/php/function.mtentryrecommendvotelink.php

## addons/Community.pack/templates/blog/about_this_page.mtml
	'This page contains a single entry by <a href="[_1]">[_2]</a> published on <em>[_3]</em>.' => 'このページは、<a href="[_1]">[_2]</a>が<em>[_3]</em>に書いたブログ記事です。',

## addons/Community.pack/templates/blog/archive_index.mtml

## addons/Community.pack/templates/blog/archive_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to serve different content based upon what type of archive it is included. More info: [_1]' => 'アーカイブの種類に応じて異なる内容を表示するように設定されたウィジェットです。詳細: [_1]',

## addons/Community.pack/templates/blog/categories.mtml

## addons/Community.pack/templates/blog/category_archive_list.mtml

## addons/Community.pack/templates/blog/comment_detail.mtml

## addons/Community.pack/templates/blog/comment_form.mtml

## addons/Community.pack/templates/blog/comment_listing.mtml

## addons/Community.pack/templates/blog/comment_preview.mtml
	'Comment on [_1]' => '[_1]へのコメント',

## addons/Community.pack/templates/blog/comment_response.mtml

## addons/Community.pack/templates/blog/comments.mtml
	'The data in #comments-content will be replaced by some calls to paginate script' => '#comments-contentの中のデータはページネーションスクリプトによって置き換えられます。',

## addons/Community.pack/templates/blog/content_nav.mtml
	'Blog Home' => 'ブログのホームページ',

## addons/Community.pack/templates/blog/current_category_monthly_archive_list.mtml

## addons/Community.pack/templates/blog/dynamic_error.mtml

## addons/Community.pack/templates/blog/entry.mtml

## addons/Community.pack/templates/blog/entry_create.mtml

## addons/Community.pack/templates/blog/entry_detail.mtml

## addons/Community.pack/templates/blog/entry_form.mtml
	'In order to create an entry on this blog you must first register.' => 'ブログに投稿するには、Movable Typeにユーザー登録してください。',
	q{You don't have permission to post.} => q{投稿する権限がありません。},
	'Sign in to create an entry.' => 'サインインしてブログ記事を投稿してください。',
	'Select Category...' => 'カテゴリを選択...',

## addons/Community.pack/templates/blog/entry_listing.mtml
	'Recently by <em>[_1]</em>' => '<em>[_1]</em>による最近のブログ記事',

## addons/Community.pack/templates/blog/entry_metadata.mtml
	'Vote' => '票',
	'Votes' => '票',

## addons/Community.pack/templates/blog/entry_response.mtml
	'Thank you for posting an entry.' => '投稿を受け付けました。',
	'Entry Pending' => 'ブログ記事を受け付けました。',
	'Your entry has been received and held for approval by the blog owner.' => '投稿はブログの管理者が公開するまで保留されています。',
	'Entry Posted' => 'ブログ記事投稿完了',
	'Your entry has been posted.' => '投稿を公開しました。',
	'Your entry has been received.' => '投稿を受け付けました。',
	q{Return to the <a href="[_1]">blog's main index</a>.} => q{<a href="[_1]">ホームぺージ</a>に戻る},

## addons/Community.pack/templates/blog/entry_summary.mtml

## addons/Community.pack/templates/blog/javascript.mtml

## addons/Community.pack/templates/blog/main_index.mtml

## addons/Community.pack/templates/blog/main_index_widgets_group.mtml
	'This is a custom set of widgets that are conditioned to only appear on the homepage (or "main_index"). More info: [_1]' => 'main_indexのテンプレートだけに表示されるように設定されているウィジェットのセットです。詳細: [_1]',

## addons/Community.pack/templates/blog/monthly_archive_list.mtml

## addons/Community.pack/templates/blog/openid.mtml

## addons/Community.pack/templates/blog/page.mtml

## addons/Community.pack/templates/blog/pages_list.mtml

## addons/Community.pack/templates/blog/powered_by.mtml

## addons/Community.pack/templates/blog/recent_assets.mtml

## addons/Community.pack/templates/blog/recent_comments.mtml
	'<a href="[_1]">[_2] commented on [_3]</a>: [_4]' => '<a href="[_1]">[_2] から [_3] に対するコメント</a>: [_4]',

## addons/Community.pack/templates/blog/recent_entries.mtml

## addons/Community.pack/templates/blog/search.mtml

## addons/Community.pack/templates/blog/search_results.mtml
	'By default, this search engine looks for all words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'すべての単語が順序に関係なく検索されます。フレーズで検索したいときは引用符で囲んでください。',

## addons/Community.pack/templates/blog/sidebar.mtml

## addons/Community.pack/templates/blog/syndication.mtml

## addons/Community.pack/templates/blog/tag_cloud.mtml

## addons/Community.pack/templates/blog/tags.mtml

## addons/Community.pack/templates/blog/trackbacks.mtml

## addons/Community.pack/templates/forum/archive_index.mtml

## addons/Community.pack/templates/forum/category_groups.mtml
	'Forum Groups' => 'カテゴリグループ',
	'Last Topic: [_1] by [_2] on [_3]' => '最新のトピック: [_1] ([_3] [_2])',
	'Be the first to <a href="[_1]">post a topic in this forum</a>' => '<a href="[_1]">掲示板にトピックを投稿</a>してください。',

## addons/Community.pack/templates/forum/comment_detail.mtml
	'[_1] replied to <a href="[_2]">[_3]</a>' => '[_1]から<a href="[_2]">[_3]</a>への返信',

## addons/Community.pack/templates/forum/comment_form.mtml
	'Add a Reply' => '返信する',

## addons/Community.pack/templates/forum/comment_listing.mtml

## addons/Community.pack/templates/forum/comment_preview.mtml
	'Reply to [_1]' => '[_1]への返信',
	'Previewing your Reply' => '返信の確認',

## addons/Community.pack/templates/forum/comment_response.mtml
	'Reply Submitted' => '返信完了',
	'Your reply has been accepted.' => '返信を受信しました。',
	'Thank you for replying.' => '返信ありがとうございます。',
	'Your reply has been received and held for approval by the forum administrator.' => '返信は掲示板の管理者が公開するまで保留されています。',
	'Reply Submission Error' => '返信エラー',
	'Your reply submission failed for the following reasons: [_1]' => '返信に失敗しました: [_1]',
	'Return to the <a href="[_1]">original topic</a>.' => '<a href="[_1]">元のトピック</a>に戻る',

## addons/Community.pack/templates/forum/comments.mtml
	'1 Reply' => '返信(1)',
	'# Replies' => '返信(#)',
	'No Replies' => '返信(0)',

## addons/Community.pack/templates/forum/content_header.mtml
	'Start Topic' => 'トピックを投稿',

## addons/Community.pack/templates/forum/content_nav.mtml

## addons/Community.pack/templates/forum/dynamic_error.mtml

## addons/Community.pack/templates/forum/entry.mtml

## addons/Community.pack/templates/forum/entry_create.mtml
	'Start a Topic' => 'トピックの投稿',

## addons/Community.pack/templates/forum/entry_detail.mtml

## addons/Community.pack/templates/forum/entry_form.mtml
	'Topic' => 'トピック',
	'Select Forum...' => '掲示板を選択...',
	'Forum' => '掲示板',

## addons/Community.pack/templates/forum/entry_listing.mtml

## addons/Community.pack/templates/forum/entry_metadata.mtml

## addons/Community.pack/templates/forum/entry_popular.mtml
	'Popular topics' => '目立ったトピック',
	'Last Reply' => '最新の返信',
	'Permalink to this Reply' => 'この返信のURL',
	'By [_1]' => '[_1]',

## addons/Community.pack/templates/forum/entry_response.mtml
	'Thank you for posting a new topic to the forums.' => '掲示板に新しいトピックを投稿しました。',
	'Topic Pending' => 'トピック保留中',
	'The topic you posted has been received and held for approval by the forum administrators.' => '投稿は掲示板の管理者が公開するまで保留されています。',
	'Topic Posted' => 'トピック投稿完了',
	'The topic you posted has been received and published. Thank you for your submission.' => 'トピックが公開されました。投稿ありがとうございました。',
	q{Return to the <a href="[_1]">forum's homepage</a>.} => q{<a href="[_1]">掲示板のホームページ</a>に戻る},

## addons/Community.pack/templates/forum/entry_summary.mtml

## addons/Community.pack/templates/forum/entry_table.mtml
	'Recent Topics' => '最新トピック',
	'Replies' => '返信',
	'Closed' => '終了',
	'Post the first topic in this forum.' => '掲示板にトピックを投稿してください。',

## addons/Community.pack/templates/forum/javascript.mtml
	'Thanks for signing in,' => 'サインインありがとうございます。',
	'. Now you can reply to this topic.' => 'さん、返信をどうぞ。',
	'You do not have permission to comment on this blog.' => 'このブログに投稿する権限がありません。',
	' to reply to this topic.' => 'してから返信してください。',
	' to reply to this topic,' => 'してから返信してください。',
	'or ' => ' ',
	'reply anonymously.' => '(匿名で返信する)',

## addons/Community.pack/templates/forum/main_index.mtml
	'Forum Home' => '掲示板メイン',

## addons/Community.pack/templates/forum/openid.mtml

## addons/Community.pack/templates/forum/page.mtml

## addons/Community.pack/templates/forum/search_results.mtml
	'Topics matching &ldquo;[_1]&rdquo;' => '「[_1]」と一致するトピック',
	'Topics tagged &ldquo;[_1]&rdquo;' => 'タグ「[_1]」のトピック',
	'Topics' => 'トピック',

## addons/Community.pack/templates/forum/sidebar.mtml

## addons/Community.pack/templates/forum/syndication.mtml
	'All Forums' => 'すべての掲示板',
	'[_1] Forum' => '[_1]',

## addons/Community.pack/templates/global/email_verification_email.mtml
	'Thank you registering for an account to [_1].' => '[_1]にご登録いただきありがとうございます。',
	'For your own security and to prevent fraud, we ask that you please confirm your account and email address before continuing. Once confirmed you will immediately be allowed to sign in to [_1].' => 'セキュリティおよび不正利用を防ぐ観点から、アカウントとメールアドレスの確認をお願いしています。確認され次第、[_1]にサインインできるようになります。',
	'To confirm your account, please click on or cut and paste the following URL into a web browser:' => 'アカウントの確認のため、次のURLをクリックするか、コピーしてブラウザのアドレス欄に貼り付けてください。',
	q{If you did not make this request, or you don't want to register for an account to [_1], then no further action is required.} => q{このメールに覚えがない場合や、[_1]に登録するのをやめたい場合は、何もする必要はありません。},
	'Thank you very much for your understanding.' => 'ご協力ありがとうございます。',

## addons/Community.pack/templates/global/footer.mtml

## addons/Community.pack/templates/global/header.mtml
	'Blog Description' => 'ブログの説明',

## addons/Community.pack/templates/global/javascript.mtml

## addons/Community.pack/templates/global/login_form.mtml
	'Not a member?&nbsp;&nbsp;<a href="[_1]">Sign Up</a>!' => 'アカウントがないときは<a href="[_1]">サインアップ</a>してください。',

## addons/Community.pack/templates/global/login_form_module.mtml
	'Logged in as <a href="[_1]">[_2]</a>' => '<a href="[_1]">[_2]</a>',
	'Logout' => 'サインアウト',
	'Hello [_1]' => '[_1]',
	'Forgot Password' => 'パスワードの再設定',
	'Sign up' => 'サインアップ',

## addons/Community.pack/templates/global/navigation.mtml

## addons/Community.pack/templates/global/new_entry_email.mtml
	q{A new entry '[_1]([_2])' has been posted on your blog [_3].} => q{ブログ「[_3]」に新しいブログ記事「[_1]」(ID: [_2])が投稿されました。},
	'Author name: [_1]' => 'ユーザー: [_1]',
	'Author nickname: [_1]' => 'ユーザーの表示名: [_1]',
	'Title: [_1]' => 'タイトル: [_1]',
	'Edit entry:' => '編集する',

## addons/Community.pack/templates/global/new_password.mtml

## addons/Community.pack/templates/global/new_password_reset_form.mtml
	'Go Back (x)' => '戻る (x)',

## addons/Community.pack/templates/global/profile_edit_form.mtml
	'Go <a href="[_1]">back to the previous page</a> or <a href="[_2]">view your profile</a>.' => '<a href="[_1]">元のページに戻る</a> / <a href="[_2]">プロフィールを表示する</a>',

## addons/Community.pack/templates/global/profile_error.mtml
	'ERROR MSG HERE' => '＊エラーメッセージを記述してください＊',
	'Go Back' => '戻る',

## addons/Community.pack/templates/global/profile_feed.mtml
	'Posted [_1] to [_2]' => '[_2]に[_1]を作成しました。',
	'Commented on [_1] in [_2]' => '[_1]([_2])へコメントしました。',
	'Voted on [_1] in [_2]' => '[_1]([_2])をお気に入りに追加しました。',
	'[_1] voted on <a href="[_2]">[_3]</a> in [_4]' => '[_1]が<a href="[_2]">[_3]</a>([_4])をお気に入りに追加しました。',

## addons/Community.pack/templates/global/profile_view.mtml
	'User Profile' => 'ユーザーのプロフィール',
	'Recent Actions from [_1]' => '最近の[_1]のアクション',
	'You are following [_1].' => '[_1]に注目しています。',
	'Unfollow' => '注目をやめる',
	'Follow' => '注目する',
	'You are followed by [_1].' => '[_1]に注目されています。',
	'You are not followed by [_1].' => '[_1]は注目していません。',
	'Website:' => 'ウェブサイト',
	'Recent Actions' => '最近のアクション',
	'Comment Threads' => 'コメントスレッド',
	'Commented on [_1]' => '[_1]にコメントしました。',
	'Favorited [_1] on [_2]' => '[_2]の[_1]をお気に入りに追加しました。',
	'No recent actions.' => '最近アクションはありません',
	'[_1] commented on ' => '[_1]のコメント: ',
	'No responses to comments.' => 'コメントへの返信がありません。',
	'Not following anyone' => 'まだ誰にも注目していません。',
	'Not being followed' => 'まだ注目されていないようです。',

## addons/Community.pack/templates/global/register_confirmation.mtml
	'Authentication Email Sent' => '確認メール送信完了',
	'Profile Created' => 'プロフィールを作成しました。',

## addons/Community.pack/templates/global/register_form.mtml

## addons/Community.pack/templates/global/register_notification_email.mtml
	q{This email is to notify you that a new user has successfully registered on the blog '[_1]'. Listed below you will find some useful information about this new user.} => q{これは新しいユーザーがブログ「[_1]」に登録を完了したことを通知するメールです。新しいユーザーの情報は以下に記載されています。},

## addons/Community.pack/templates/global/search.mtml

## addons/Community.pack/templates/global/signin.mtml
	'You are signed in as <a href="[_1]">[_2]</a>' => '<a href="[_1]">[_2]</a>',
	'You are signed in as [_1]' => '[_1]',
	'Edit profile' => 'ユーザー情報の編集',
	'Not a member? <a href="[_1]">Register</a>' => '<a href="[_1]">登録</a>',

## addons/Community.pack/tmpl/cfg_community_prefs.tmpl
	'Community Settings' => 'コミュニティの設定',
	'Anonymous Recommendation' => '匿名での投票',
	'Check to allow anonymous users (users not logged in) to recommend discussion.  IP address is recorded and used to identify each user.' => 'サインインしていないユーザーでもお気に入りに登録できるようにします。IPアドレスを記録して重複を防ぎます。',
	'Allow anonymous user to recommend' => '匿名での投票を許可する',
	'Junk Filter' => 'スパムフィルター',
	'If enabled, all moderated entries will be filtered by Junk Filter.' => 'すべてのブログ記事をスパムフィルターの対象にします。',
	'Save changes to blog (s)' => 'ブログへの変更を保存 (s)',

## addons/Community.pack/tmpl/widget/blog_stats_registration.mtml
	'Recent Registrations' => '最近の登録',
	'default userpic' => '既定のユーザー画像',
	'You have [quant,_1,registration,registrations] from [_2]' => '[_2]日に[quant,_1,件,件]の登録がありました。',

## addons/Community.pack/tmpl/widget/most_popular_entries.mtml
	'There are no popular entries.' => '目立ったブログ記事はありません。',

## addons/Community.pack/tmpl/widget/recent_submissions.mtml

## addons/Community.pack/tmpl/widget/recently_scored.mtml
	'There are no recently favorited entries.' => '最近お気に入り登録されたブログ記事はありません。',

## addons/Enterprise.pack/app-cms.yaml
	'Groups ([_1])' => 'グループ([_1])',
	'Are you sure you want to delete the selected group(s)?' => '選択されているグループを削除してよろしいですか?',
	'Are you sure you want to remove the selected member(s) from the group?' => '選択されているメンバーをグループから削除してよろしいですか?',
	'[_1]\'s Group' => '[_1]の所属するグループ',
	'Groups' => 'グループ',
	'Manage Member' => 'メンバーの管理',
	'Bulk Author Export' => 'ユーザーの一括出力',
	'Bulk Author Import' => 'ユーザーの一括登録',
	'Synchronize Users' => 'ユーザーを同期',
	'Synchronize Groups' => 'グループを同期',
	'Add user to group' => 'グループにユーザーを追加',

## addons/Enterprise.pack/app-wizard.yaml
	'This module is required in order to use the LDAP Authentication.' => 'LDAP認証を利用する場合に必要です。',

## addons/Enterprise.pack/config.yaml
	'http://www.sixapart.com/movabletype/' => 'http://www.sixapart.jp/movabletype/',
	'Permissions of group: [_1]' => 'グループ[_1]の権限',
	'Group' => 'グループ',
	'Groups associated with author: [_1]' => 'ユーザー[_1]と関連付けられたグループ',
	'Inactive' => '有効ではない',
	'Members of group: [_1]' => 'グループ [_1]のメンバー',
	'Advanced Pack' => 'Advanced Pack',
	'User/Group' => 'ユーザー/グループ',
	'User/Group Name' => 'ユーザー/グループ名',
	'__GROUP_MEMBER_COUNT' => 'メンバー数',
	'My Groups' => '自分のグループ',
	'Group Name' => 'グループ名',
	'Manage Group Members' => 'グループメンバーの管理',
	'Group Members' => 'グループメンバー',
	'Group Member' => 'グループメンバー',
	'Permissions for Users' => 'ユーザーの権限',
	'Permissions for Groups' => 'グループの権限',
	'Active Groups' => '有効なグループ',
	'Disabled Groups' => '無効なグループ',
	'Oracle Database (Recommended)' => 'Oracleデータベース(推奨)',
	'Microsoft SQL Server Database' => 'Microsoft SQL Serverデータベース',
	'Microsoft SQL Server Database UTF-8 support (Recommended)' => 'Microsoft SQL Serverデータベース UTF-8サポート(推奨)',
	'Publish Charset' => '文字コード',
	'ODBC Driver' => 'ODBCドライバ',
	'External Directory Synchronization' => '外部ディレクトリと同期',
	'Populating author\'s external ID to have lower case user name...' => '小文字のユーザー名を外部IDに設定しています...',

## addons/Enterprise.pack/lib/MT/Auth/LDAP.pm
	'User [_1]([_2]) not found.' => 'ユーザー[_1]([_2])が見つかりませんでした。',
	'User \'[_1]\' cannot be updated.' => 'ユーザー「[_1]」を更新できませんでした。',
	'User \'[_1]\' updated with LDAP login ID.' => 'ユーザー「[_1]」をLDAPのログインIDで更新しました。',
	'LDAP user [_1] not found.' => 'LDAPサーバー上にユーザーが見つかりません: [_1]',
	'User [_1] cannot be updated.' => 'ユーザー「[_1]」を更新できませんでした。',
	'User cannot be updated: [_1].' => 'ユーザーの情報を更新できません: [_1]',
	'Failed login attempt by user \'[_1]\' who was deleted from LDAP.' => 'LDAPから削除されたユーザー [_1] がサインインしようとしました。',
	'User \'[_1]\' updated with LDAP login name \'[_2]\'.' => 'ユーザー「[_1]」のユーザー名をLDAP名「[_2]」に変更しました。',
	'Failed login attempt by user \'[_1]\'. A user with that username already exists in the system with a different UUID.' => '[_1]がサインインできませんでした。同名のユーザーが別の外部IDですでに存在します。',
	'User \'[_1]\' account is disabled.' => 'ユーザー「[_1]」を無効化しました。',
	'LDAP users synchronization interrupted.' => 'LDAPユーザーの同期が中断されました。',
	'Loading MT::LDAP failed: [_1]' => 'MT::LDAPの読み込みに失敗しました: [_1]',
	'External user synchronization failed.' => 'ユーザーの同期に失敗しました。',
	'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'すべてのシステム管理者が無効にされるため、ユーザーの同期は中断されました。',
	'Information about the following users was modified:' => '次のユーザーの情報が変更されました: ',
	'The following users were disabled:' => '次のユーザーが無効化されました: ',
	'LDAP users synchronized.' => 'LDAPユーザーが同期されました。',
	'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute being set.' => 'グループを同期するためにはLDAPGroupIdAttributeおよびLDAPGroupNameAttributeの設定が必須です。',
	'LDAP groups synchronized with existing groups.' => '既存のグループがLDAPグループと同期されました。',
	'Information about the following groups was modified:' => '次のグループの情報が更新されました: ',
	'No LDAP group was found using the filter provided.' => '指定されたフィルタではLDAPグループが見つかりませんでした。',
	'The filter used to search for groups was: \'[_1]\'. Search base was: \'[_2]\'' => '検索フィルタ: \'[_1]\' 検索ベース: \'[_2]\'',
	'(none)' => '(なし)',
	'The following groups were deleted:' => '以下のグループが削除されました。',
	'Failed to create a new group: [_1]' => '新しいグループを作成できませんでした: [_1]',
	'[_1] directive must be set to synchronize members of LDAP groups to Movable Type Advanced.' => 'Movable Type AdvancedでLDAPグループのメンバーを同期するには、[_1]を設定する必要があります。',
	'Members removed: ' => 'グループから削除されたメンバー: ',
	'Members added: ' => '追加されたメンバー: ',
	'Memberships in the group \'[_2]\' (#[_3]) were changed as a result of synchronizing with the external directory.' => '外部ディレクトリとの同期の結果グループ「[_2]」(ID: [_3])を更新しました。',
	'LDAPUserGroupMemberAttribute must be set to enable synchronizing of members of groups.' => 'グループのメンバーを同期するにはLDAPUserGroupMemberAttributeの設定が必須です。',

## addons/Enterprise.pack/lib/MT/Enterprise/Author.pm
	'Loading MT::LDAP failed: [_1].' => 'MT::LDAPの読み込みに失敗しました: [_1]',

## addons/Enterprise.pack/lib/MT/Enterprise/BulkCreation.pm
	'Formatting error at line [_1]: [_2]' => '[_1]行目でエラーが見つかりました: [_2]',
	'Invalid command: [_1]' => 'コマンドが認識できません: [_1]',
	'Invalid number of columns for [_1]' => '[_1] コマンドのカラムの数が不正です',
	'Invalid user name: [_1]' => 'ユーザー名の設定に誤りがあります: [_1]',
	'Invalid display name: [_1]' => '表示名の設定に誤りがあります: [_1]',
	'Invalid email address: [_1]' => 'メールアドレスが正しくありません: [_1]',
	'Invalid language: [_1]' => '使用言語の設定に誤りがあります: [_1]',
	'Invalid password: [_1]' => 'パスワードの設定に誤りがあります: [_1]',
	'\'Personal Blog Location\' setting is required to create new user blogs.' => 'ユーザーのブログを作成する場合は、\'個人用ブログの場所\'を設定してください。',
	'Invalid weblog name: [_1]' => 'ブログ名の設定に誤りがあります: [_1]',
	'Invalid blog URL: [_1]' => 'ブログURLの設定に誤りがあります: [_1]',
	'Invalid site root: [_1]' => 'サイトパスの設定に誤りがあります: [_1]',
	'Invalid timezone: [_1]' => '時間帯 (タイムゾーン) の設定に誤りがあります: [_1]',
	'Invalid theme ID: [_1]' => 'テーマIDの設定に誤りがあります: [_1]',
	'A theme \'[_1]\' was not found.' => '\'[_1]\'というテーマが見つかりません。',
	'A user with the same name was found.  The registration was not processed: [_1]' => '同名のユーザーが登録されているため、登録できません: [_1]',
	'Blog for user \'[_1]\' can not be created.' => 'ブログ「[_1]」へユーザーを登録できませんでした。',
	'Blog \'[_1]\' for user \'[_2]\' has been created.' => 'ユーザー[_2]のブログ「[_1]」を作成しました。',
	'Error assigning weblog administration rights to user \'[_1] (ID: [_2])\' for weblog \'[_3] (ID: [_4])\'. No suitable weblog administrator role was found.' => 'ユーザー「[_1]」(ID:[_2])にブログ「[_3]」(ID:[_4])への権限を付与できませんでした。利用できるブログの管理者ロールが見つかりませんでした。',
	'Permission granted to user \'[_1]\'' => 'ユーザー [_1] に権限を設定しました。',
	'User \'[_1]\' already exists. The update was not processed: [_2]' => '[_1] というユーザーがすでに存在します。更新はできませんでした: [_2]',
	'User \'[_1]\' not found.  The update was not processed.' => 'ユーザー「[_1]」が見つからないため、更新できません。',
	'User \'[_1]\' has been updated.' => 'ユーザーの情報を更新しました: [_1]',
	'User \'[_1]\' was found, but the deletion was not processed' => 'ユーザー「[_1]」が見つかりましたが、削除できません。',
	'User \'[_1]\' not found.  The deletion was not processed.' => 'ユーザー「[_1]」が見つからないため、削除できません。',
	'User \'[_1]\' has been deleted.' => 'ユーザーを削除しました: [_1]',

## addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
	'Movable Type Advanced has just attempted to disable your account during synchronization with the external directory. Some of the external user management settings must be wrong. Please correct your configuration before proceeding.' => '外部ディレクトリとの同期中にあなた自身が無効化されそうになりました。外部ディレクトリによるユーザー管理の設定が誤っているかもしれません。構成を確認してください。',
	'Each group must have a name.' => 'グループには名前が必要です。',
	'Search Users' => 'ユーザーを検索',
	'Select Groups' => 'グループを選択',
	'Groups Selected' => '選択されたグループ',
	'Search Groups' => 'グループを検索',
	'Add Users to Groups' => 'グループにユーザーを追加',
	'Invalid group' => 'グループが不正です。',
	'Add Users to Group [_1]' => '[_1]にユーザーを追加',
	'User \'[_1]\' (ID:[_2]) removed from group \'[_3]\' (ID:[_4]) by \'[_5]\'' => '[_5]がユーザー「[_1](ID:[_2])」をグループ「[_3](ID:[_4])」から削除しました。',
	'Group load failed: [_1]' => 'グループをロードできませんでした: [_1]',
	'User load failed: [_1]' => 'ユーザーをロードできませんでした: [_1]',
	'User \'[_1]\' (ID:[_2]) was added to group \'[_3]\' (ID:[_4]) by \'[_5]\'' => '[_5]がユーザー「[_1](ID:[_2])」をグループ「[_3](ID:[_4])」に追加しました。',
	'Users & Groups' => 'ユーザー/グループ',
	'Group Profile' => 'グループのプロフィール',
	'Author load failed: [_1]' => 'ユーザーをロードできませんでした: [_1]',
	'Invalid user' => '不正なユーザーです。',
	'Assign User [_1] to Groups' => 'ユーザー[_1]をグループ[_1]に追加',
	'Type a group name to filter the choices below.' => 'グループ名を入力してフィルタリングします。',
	'Bulk import cannot be used under external user management.' => 'ExternalUserManagement環境ではユーザーの一括編集はできません。',
	'Bulk management' => '一括管理',
	'No records were found in the file.  Make sure the file uses CRLF as the line-ending characters.' => '登録するレコードがありません。改行コードがCRLFになっているかどうか確認してください。',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => '登録:[quant,_1,人,人]、更新:[quant,_2,人,人]、削除:[quant,_3,人,人]',
	'Bulk author export cannot be used under external user management.' => 'ExternalUserManagement環境ではユーザーの一括出力はできません。',
	'A user cannot change his/her own username in this environment.' => '自分のユーザー名を変えることはこの構成ではできません。',
	'An error occurred when enabling this user.' => 'ユーザーを有効化するときにエラーが発生しました: [_1]',

## addons/Enterprise.pack/lib/MT/Enterprise/Upgrade.pm
	'Fixing binary data for Microsoft SQL Server storage...' => 'Microsoft SQL Serverでバイナリデータを移行しています...',

## addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
	'PLAIN' => 'PLAIN',
	'CRAM-MD5' => 'CRAM-MD5',
	'Digest-MD5' => 'Digest-MD5',
	'Login' => 'ログイン',
	'Found' => '見つかりました',
	'Not Found' => '見つかりませんでした',

## addons/Enterprise.pack/lib/MT/Group.pm

## addons/Enterprise.pack/lib/MT/LDAP.pm
	'Invalid LDAPAuthURL scheme: [_1].' => 'LDAPAuthURLのスキーム「[_1]」が不正です。',
	'Error connecting to LDAP server [_1]: [_2]' => 'LDAPサーバー [_1] に接続できません: [_2]',
	'User not found in LDAP: [_1]' => 'LDAPサーバー上にユーザーが見つかりません: [_1]',
	'Binding to LDAP server failed: [_1]' => 'LDAPサーバーに接続できません: [_1]',
	'More than one user with the same name found in LDAP: [_1]' => 'LDAPサーバー上に同一名のユーザーが見つかりました: [_1]',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
	'PublishCharset [_1] is not supported in this version of the MS SQL Server Driver.' => 'PublishCharset [_1]はMS SQL Serverのドライバでサポートされていません。',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/UMSSQLServer.pm
	'This version of UMSSQLServer driver requires DBD::ODBC version 1.14.' => 'このバージョンのUMSSQLServerドライバは、DBD::ODBCバージョン1.14以上で動作します。',
	'This version of UMSSQLServer driver requires DBD::ODBC compiled with Unicode support.' => 'このバージョンのUMSSQLServerドライバは、UnicodeをサポートするDBD::ODBCが必要です。',

## addons/Enterprise.pack/tmpl/author_bulk.tmpl
	'Manage Users in bulk' => 'ユーザーの一括管理',
	'_USAGE_AUTHORS_2' => 'ユーザーの情報を一括で編集できます。CSV形式のコマンドファイルをアップロードしてください。',
	q{New user blog would be created on '[_1]'.} => q{ユーザーのブログはウェブサイト '[_1]' に作成されます。},
	'[_1] Edit</a>' => '[_1] 編集</a>',
	q{You must set 'Personal Blog Location' to create a new blog for each new user.} => q{ユーザーのブログを作成する場合は、'個人用ブログの場所'を設定してください。},
	'[_1] Setting</a>' => '[_1] 設定</a>',
	'Upload source file' => 'ソースファイルのアップロード',
	'Specify the CSV-formatted source file for upload' => 'アップロードするCSV形式のソースファイルを指定してください。',
	'Source File Encoding' => 'ソースファイルのエンコーディング',
	'Movable Type will automatically try to detect the character encoding of your import file.  However, if you experience difficulties, you can set the character encoding explicitly.' => 'Movable Typeはインポートするファイルの文字コードを自動的に検出します。問題が起きたときには、明示的に文字コードを指定することもできます。',
	'Upload (u)' => 'アップロード (u)',

## addons/Enterprise.pack/tmpl/cfg_ldap.tmpl
	'Authentication Configuration' => '認証の構成',
	'You must set your Authentication URL.' => '認証URLを設定してください。',
	'You must set your Group search base.' => 'グループの検索を開始する場所を設定してください。',
	'You must set your UserID attribute.' => 'ユーザーの識別子を示す属性を設定してください。',
	'You must set your email attribute.' => '電子メールを示す属性を設定してください。',
	'You must set your user fullname attribute.' => 'フルネーム示す属性を設定してください。',
	'You must set your user member attribute.' => 'メンバー属性に対応するユーザーの属性を設定してください。',
	'You must set your GroupID attribute.' => 'グループの識別子を示す属性を設定してください。',
	'You must set your group name attribute.' => 'グループの名前を示す属性を設定してください。',
	'You must set your group fullname attribute.' => 'グループのフルネームを示す属性を設定してください。',
	'You must set your group member attribute.' => 'グループのメンバーを示す属性を設定してください。',
	'An error occurred while attempting to connect to the LDAP server: ' => 'LDAPサーバーへの接続中にエラーが発生しました：',
	'You can configure your LDAP settings from here if you would like to use LDAP-based authentication.' => 'LDAPで認証を行う場合、LDAPの設定を行うことができます。',
	'Your configuration was successful.' => '構成を完了しました。',
	q{Click 'Continue' below to configure the External User Management settings.} => q{次へをクリックしてExternalUserManagementの設定に進んでください。},
	q{Click 'Continue' below to configure your LDAP attribute mappings.} => q{次へをクリックして属性マッピングに進んでください。},
	'Your LDAP configuration is complete.' => 'LDAPの構成を完了しました。',
	q{To finish with the configuration wizard, press 'Continue' below.} => q{次へをクリックして構成ウィザードを完了してください。},
	'Cannot locate Net::LDAP. Net::LDAP module is required to use LDAP authentication.' => 'Net::LDAPが見つかりません。Net::LDAPはLDAP認証を利用するのために必要です。',
	'Use LDAP' => 'LDAPを利用する',
	'Authentication URL' => '認証URL',
	'The URL to access for LDAP authentication.' => 'LDAP認証でアクセスするURL',
	'Authentication DN' => '認証に利用するDN',
	'An optional DN used to bind to the LDAP directory when searching for a user.' => 'ユーザーを検索するときにLDAPディレクトリにバインドするDN（任意）',
	'Authentication password' => '認証に利用するDNのパスワード',
	'Used for setting the password of the LDAP DN.' => '認証に利用するDNが接続するときのパスワード',
	'SASL Mechanism' => 'SASLメカニズム',
	'The name of the SASL Mechanism used for both binding and authentication.' => 'バインドと認証で利用するSASLメカニズムの名前',
	'Test Username' => 'テストユーザー名',
	'Test Password' => 'パスワード',
	'Enable External User Management' => '外部ディレクトリでユーザー管理を行う',
	'Synchronization Frequency' => '同期間隔',
	'The frequency of synchronization in minutes. (Default is 60 minutes)' => '同期を行う間隔（既定値は60分）',
	'15 Minutes' => '15分',
	'30 Minutes' => '30分',
	'60 Minutes' => '60分',
	'90 Minutes' => '90分',
	'Group Search Base Attribute' => 'グループの検索を開始する場所',
	'Group Filter Attribute' => 'グループを表すフィルタ',
	'Search Results (max 10 entries)' => '検索結果（最大10件だけ表示します）',
	'CN' => 'CN',
	'No groups were found with these settings.' => 'グループが見つかりませんでした。',
	'Attribute mapping' => '属性マッピング',
	'LDAP Server' => 'LDAPサーバー',
	'Other' => 'その他',
	'User ID Attribute' => 'ユーザーの識別子を示す属性',
	'Email Attribute' => '電子メールを示す属性',
	'User Fullname Attribute' => 'フルネーム示す属性',
	'User Member Attribute' => 'メンバー属性に対応するユーザーの属性',
	'GroupID Attribute' => 'グループの識別子を示す属性',
	'Group Name Attribute' => 'グループの名前を示す属性',
	'Group Fullname Attribute' => 'グループのフルネームを示す属性',
	'Group Member Attribute' => 'グループのメンバーを示す属性',
	'Search Result (max 10 entries)' => '検索結果（最大10件）',
	'Group Fullname' => 'フルネーム',
	'(and [_1] more members)' => '(他[_1]ユーザー)',
	'No groups could be found.' => 'グループが見つかりませんでした。',
	'User Fullname' => 'フルネーム',
	'(and [_1] more groups)' => '(他[_1]グループ)',
	'No users could be found.' => 'ユーザーが見つかりませんでした。',
	'Test connection to LDAP' => 'LDAPへの接続を試す',
	'Test search' => '検索を試す',

## addons/Enterprise.pack/tmpl/create_author_bulk_end.tmpl
	'All users were updated successfully.' => 'すべてのユーザーの更新が完了しました。',
	'An error occurred during the update process. Please check your CSV file.' => 'ユーザーの更新中にエラーが発生しました。CSVファイルの内容を確認してください。',

## addons/Enterprise.pack/tmpl/create_author_bulk_start.tmpl

## addons/Enterprise.pack/tmpl/dialog/dialog_select_group_user.tmpl

## addons/Enterprise.pack/tmpl/dialog/select_groups.tmpl
	'You need to create some groups.' => 'グループを作成してください。',
	q{Before you can do this, you need to create some groups. <a href="javascript:void(0);" onclick="closeDialog('[_1]');">Click here</a> to create a group.} => q{実行する前にグループを作成する必要があります。 <a href="javascript:void(0);" onclick="closeDialog('[_1]');">ここをクリックして</a>グループを作成してください。},

## addons/Enterprise.pack/tmpl/edit_group.tmpl
	'Edit Group' => 'グループの編集',
	'Create Group' => 'グループの作成',
	'This group profile has been updated.' => 'グループのプロフィールを更新しました。',
	'This group was classified as pending.' => 'このグループは保留中になっています。',
	'This group was classified as disabled.' => 'このグループは無効になっています。',
	'Member ([_1])' => 'メンバー([_1])',
	'Members ([_1])' => 'メンバー([_1])',
	'Permission ([_1])' => '権限([_1])',
	'Permissions ([_1])' => '権限([_1])',
	'LDAP Group ID' => 'LDAPグループID',
	'The LDAP directory ID for this group.' => 'LDAPディレクトリでこのグループに適用されている識別子',
	'Status of this group in the system. Disabling a group prohibits its members&rsquo; from accessing the system but preserves their content and history.' => 'グループの状態。グループを無効にするとメンバーのシステムへのアクセスに影響があります。メンバーのコンテンツや履歴は削除されません。',
	'The name used for identifying this group.' => 'グループを識別する名前',
	'The display name for this group.' => 'グループの表示名',
	'The description for this group.' => 'グループの説明',
	'Save changes to this field (s)' => 'フィールドへの変更を保存 (s)',

## addons/Enterprise.pack/tmpl/include/group_table.tmpl
	'Enable selected group (e)' => '選択されたグループを有効にする (e)',
	'Disable selected group (d)' => '選択されたグループを無効にする (d)',
	'group' => 'グループ',
	'groups' => 'グループ',
	'Remove selected group (d)' => '選択されたグループを削除する (d)',

## addons/Enterprise.pack/tmpl/include/list_associations/page_title.group.tmpl
	'Users &amp; Groups for [_1]' => 'ユーザーとグループ - [_1]',

## addons/Enterprise.pack/tmpl/listing/group_list_header.tmpl
	'You successfully disabled the selected group(s).' => '選択されたグループを無効にしました。',
	'You successfully enabled the selected group(s).' => '選択されたグループを有効にしました。',
	'You successfully deleted the groups from the Movable Type system.' => 'グループをMovable Typeのシステムから削除しました。',
	q{You successfully synchronized the groups' information with the external directory.} => q{外部のディレクトリとグループの情報を同期しました。},

## addons/Enterprise.pack/tmpl/listing/group_member_list_header.tmpl
	'You successfully deleted the users.' => 'ユーザーを削除しました。',
	'You successfully added new users to this group.' => 'グループに新しいユーザーを追加しました。',
	q{You successfully synchronized users' information with the external directory.} => q{外部のディレクトリとユーザー情報を同期しました。},
	'Some ([_1]) of the selected users could not be re-enabled because they are no longer found in LDAP.' => '選択されたユーザーのうち[_1]人は外部ディレクトリ上に存在しないので有効にできませんでした。',
	'You successfully removed the users from this group.' => 'グループからユーザーを削除しました。',

## plugins/FacebookCommenters/config.yaml
	'Provides commenter registration through Facebook Connect.' => 'Facebookコネクトを利用したコメント投稿者の登録機能を提供します。',
	'Facebook' => 'Facebook',

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm
	'Set up Facebook Commenters plugin' => 'Facebook Commentersプラグイン設定',
	'Authentication failure: [_1], reason:[_2]' => '認証に失敗しました: [_1], 理由:[_2]',
	'Failed to created commenter.' => 'コメンターの作成に失敗しました。',
	'Failed to create a session.' => 'コメンターセッションの作成に失敗しました。',
	'Facebook Commenters needs either Crypt::SSLeay or IO::Socket::SSL installed to communicate with Facebook.' => 'Facebook Commenters を利用するには、Crypt::SSLeay または IO::Socket::SSLのいずれかがインストールされている必要があります。',
	'Please enter your Facebook App key and secret.' => 'FacebookアプリケーションキーとFacebookアプリケーションシークレットを入力してください。',
	'Could not verify this app with Facebook: [_1]' => 'Facebookでこのアプリケーションを確認できません: [_1]',

## plugins/FacebookCommenters/tmpl/blog_config_template.tmpl
	'Facebook Application Key' => 'Facebookアプリケーションキー',
	'The key for the Facebook application associated with your blog.' => 'ブログ関連付用Facebookアプリケーションキー',
	'Edit Facebook App' => 'Facebookアプリ編集',
	'Create Facebook App' => 'Facebookアプリ作成',
	'Facebook Application Secret' => 'Facebookアプリケーションシークレット',
	'The secret for the Facebook application associated with your blog.' => 'ブログ関連付用Facebookアプリケーションシークレット',

## plugins/FormattedText/config.yaml
	'Manage boilerplate.' => '定型文を管理します。',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => '定型文を削除してもよろしいですか？',
	'My Boilerplate' => '自分の定型文',

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplates' => '定型文',
	'The boilerplate \'[_1]\' is already in use in this blog.' => '[_1]という定型文は既にこのブログに存在しています。',

## plugins/FormattedText/tmpl/cms/edit_formatted_text.tmpl
	'Edit Boilerplate' => '定型文の編集',
	'Create Boilerplate' => '定型文の作成',
	'This boilerplate has been saved.' => '定型文を保存しました。',
	'Save changes to this boilerplate (s)' => '定型文への変更を保存 (s)',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{[_1]という定型文は既にこのブログに存在しています。},

## plugins/FormattedText/tmpl/cms/list_formatted_text.tmpl
	'The boilerplate has been deleted from the database.' => '定型文を削除しました',

## plugins/FormattedTextForTinyMCE/config.yaml
	'Add the "Insert Boilerplate" button to the TinyMCE.' => 'TinyMCE に「定型文の挿入」ボタンを追加します。',

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => '定型文をロードできませんでした。',

## plugins/FormattedTextForTinyMCE/tmpl/extension.tmpl
	'Select a Boilerplate' => '定型文を選択...',

## plugins/Markdown/Markdown.pl
	'A plain-text-to-HTML formatting plugin.' => 'テキストをHTMLに整形するプラグインです。',
	'Markdown' => 'Markdown',
	'Markdown With SmartyPants' => 'Markdown + SmartyPants',

## plugins/Markdown/SmartyPants.pl
	q{Easily translates plain punctuation characters into 'smart' typographic punctuation.} => q{記号を「スマート」に置き換えます。},

## plugins/MultiBlog/lib/MultiBlog.pm
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
	'(All blogs in this website)' => '(ウェブサイト内のすべてのブログ)',
	'Select to apply this trigger to all blogs in this website.' => 'ウェブサイト内のすべてのブログでトリガーを有効にする。',
	'(All websites and blogs in this system)' => '(システム内のすべてのウェブサイトとブログ)',
	'Select to apply this trigger to all websites and blogs in this system.' => 'システム内のすべてのウェブサイトとブログでトリガーを有効にする。',
	'saves an entry/page' => 'ブログ記事とウェブページの保存時',
	'publishes an entry/page' => 'ブログ記事とウェブページの公開時',
	'publishes a comment' => 'コメントの公開時',
	'publishes a TrackBack' => 'トラックバックの公開時',
	'rebuild indexes.' => 'インデックスを再構築する',
	'rebuild indexes and send pings.' => 'インデックスを再構築して更新pingを送信する',
	'Updating trigger cache of MultiBlog...' => 'トリガーの設定を更新しています...',

## plugins/MultiBlog/tmpl/blog_config.tmpl
	'When' => ' ',
	'Trigger' => 'トリガー',
	'Action' => 'アクション',
	'Weblog' => 'ブログ',
	'Content Privacy' => 'コンテンツのセキュリティ',
	'Specify whether other blogs in the installation may publish content from this blog. This setting takes precedence over the default system aggregation policy found in the system-level MultiBlog configuration.' => '同じMovable Type内の他のブログがこのブログのコンテンツを公開できるかどうかを指定します。この設定はシステムレベルのMultiBlogの構成で指定された既定のアグリゲーションポリシーよりも優先されます。',
	'Use system default' => 'システムの既定値を使用',
	'Allow' => '許可',
	'Disallow' => '許可しない',
	'MTMultiBlog tag default arguments' => 'MTMultiBlogタグの既定の属性:',
	q{Enables use of the MTMultiBlog tag without include_blogs/exclude_blogs attributes. Comma-separated BlogIDs or 'all' (include_blogs only) are acceptable values.} => q{include_blogs/exclude_blogs属性なしでMTMultiBlogタグを使用できるようにします。カンマで区切ったブログID、または「all」(include_blogs のみ)が指定できます。},
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
	'Moving current style to blog_meta for website...' => 'ウェブサイトの現在のスタイルの格納場所を移動しています...',
	'Moving current style to blog_meta for blog...' => 'ブログの現在のスタイルの格納場所を移動しています...',

## plugins/StyleCatcher/lib/StyleCatcher/CMS.pm
	'Your mt-static directory could not be found. Please configure \'StaticFilePath\' to continue.' => 'mt-staticディレクトリが見つかりませんでした。StaticFilePathを設定してください。',
	'Permission Denied.' => '権限がありません。',
	'Successfully applied new theme selection.' => '新しいテーマを適用しました。',

## plugins/StyleCatcher/lib/StyleCatcher/Library/Default.pm
	'Invalid URL: [_1]' => 'URLが不正です: [_1]',
	'Could not create [_1] folder - Check that your \'themes\' folder is webserver-writable.' => '[_1] フォルダが作成できません。\'themes\' フォルダが書き込み可能か確認してください。',

## plugins/StyleCatcher/lib/StyleCatcher/Library/Local.pm
	'Failed to load StyleCatcher Library: [_1]' => 'スタイルライブラリを読み込めませんでした。',

## plugins/StyleCatcher/lib/StyleCatcher/Util.pm
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

## plugins/TinyMCE/config.yaml
	'Default WYSIWYG editor.' => '既定のWYSIWYGエディタ',
	'TinyMCE' => 'TinyMCE',

## plugins/TypePadAntiSpam/config.yaml
	'TypePad AntiSpam is a free service from Six Apart that helps protect your blog from comment and TrackBack spam. The TypePad AntiSpam plugin will send every comment or TrackBack submitted to your blog to the service for evaluation, and Movable Type will filter items if TypePad AntiSpam determines it is spam. If you discover that TypePad AntiSpam incorrectly classifies an item, simply change its classification by marking it as "Spam" or "Not Spam" from the Manage Comments screen, and TypePad AntiSpam will learn from your actions. Over time the service will improve based on reports from its users, so take care when marking items as "Spam" or "Not Spam."' => '<a href="http://antispam.typepad.jp/" target="_blank">TypePad AntiSpam</a>はSix Apartから無償で提供される、コメントとトラックバックスパムからあなたのブログを守るためのサービスです。TypePad AntiSpamプラグインは、あなたのブログに宛てられたすべてのコメントとトラックバックを、評価のためにサービスに送信し、TypePad AntiSpamがスパムであると判断した場合には、Movable Typeがそれをフィルタリングします。TypePad AntiSpamによる判定に誤りがあった場合は、コメントの一覧画面でそれをスパムにする、あるいはスパムではないと指定すれば、TypePad AntiSpamはそれを学習します。このようなユーザーからのレポートによってTypePad AntiSpamによる評価の精度がさらに高まります。そのため、アイテムをスパムにしたり、スパムから解除する場合には、少し気をつけてください。',
	'"TypePad AntiSpam"' => '"TypePad AntiSpam"',

## plugins/TypePadAntiSpam/lib/MT/TypePadAntiSpam.pm
	'API key is a required parameter.' => 'APIキーを設定してください。',

## plugins/TypePadAntiSpam/lib/TypePadAntiSpam.pm
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] for this blog, and [quant,_2,message,messages] system-wide.' => 'これまでのところ、TypePad AntiSpamはこのブログに対するスパムを[quant,_1,件,件]ブロックしました。システム全体では[quant,_2,件,件]ブロックしました。',
	'So far, TypePad AntiSpam has blocked [quant,_1,message,messages] system-wide.' => 'これまでのところ、TypePad AntiSpamはこのシステム全体に対するスパムを[quant,_1,件,件]ブロックしました。',
	'Failed to verify your TypePad AntiSpam API key: [_1]' => 'TypePad AntiSpam APIキーの検証に失敗しました: [_1]',
	'The TypePad AntiSpam API key provided is invalid.' => '不正なTypePad AntiSpam APIキーです。',

## plugins/TypePadAntiSpam/tmpl/config.tmpl
	'Junk Score Weight' => 'スコアの重みづけ',
	'Least Weight' => '緩い',
	'Most Weight' => '厳しい',
	'Comments and TrackBacks receive a junk score between -10 (definitely spam) and +10 (definitely not spam). This setting allows you to control the weight of the TypePad AntiSpam rating relative to other filters you may have installed to help you filter comments and TrackBacks.' => 'コメントおよびトラックバックには-10(間違いなくスパム)から+10(スパムではありえない)までの範囲で点数が付けられます。この設定を変更すると、TypePad AntiSpamによる判定を、インストールされている他のスパムフィルタの判定との関連で高くしたり低くしたりすることで、コメントとトラックバックのスパムフィルタリングの設定を調整できます。',

## plugins/TypePadAntiSpam/tmpl/stats_widget.tmpl
	'TypePad AntiSpam' => 'TypePad AntiSpam',
	'Spam Blocked' => 'ブロックしたスパム',
	'on this blog' => 'ブログレベル',
	'on this system' => 'システム全体',

## plugins/TypePadAntiSpam/tmpl/system.tmpl
	'API Key' => 'APIキー',
	q{To enable this plugin, you'll need a free TypePad AntiSpam API key. You can <strong>get your free API key at [_1]antispam.typepad.com[_2]</strong>. Once you have your key, return to this page and enter it in the field below.} => q{このプラグインを利用するには、TypePad AntiSpam APIキー(無償)が必要です。APIキーは<strong>[_1]antispam.typepad.com[_2]</strong>から無償で取得できます。取得したら、このページに戻ってキーを入力してください。詳しくは<a href="http://antispam.typepad.jp/info/how-to-get-api-key.html" target="_blank">こちら</a>。},
	'Service Host' => 'サービスのホスト',
	'The default service host for TypePad AntiSpam is api.antispam.typepad.com. You should only change this if you are using a different service that is compatible with the TypePad AntiSpam API.' => 'TypePad AntiSpamの既定のホストはapi.antispam.typepad.comです。TypePad AntiSpam APIと互換性を持つ他のサービスを利用する場合に限って、この設定を変更してください。',

## plugins/WXRImporter/config.yaml
	'Import WordPress exported RSS into MT.' => 'WordPressからエクスポートされたRSSをMTにインポートします。',
	'"WordPress eXtended RSS (WXR)"' => 'WordPress eXtended RSS (WXR)',
	'"Download WP attachments via HTTP."' => 'WordPressのAttachmentをHTTP経由でダウンロードします。',

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
	'Entry has no MT::Trackback object!' => 'ブログ記事にトラックバックの設定がありません',
	'Assigning permissions for new user...' => '新しいユーザーに権限を追加しています...',
	'Saving permission failed: [_1]' => '権限の保存中にエラーが発生しました: [_1]',

## plugins/WXRImporter/tmpl/options.tmpl
	q{Before you import WordPress posts to Movable Type, we recommend that you <a href='[_1]'>configure your blog's publishing paths</a> first.} => q{WordPressからMovable Typeへインポートする前に、まず<a href='[_1]'>ブログ公開パスを設定</a>してください。},
	'Upload path for this WordPress blog' => 'WordPressブログのアップロードパス',
	'Replace with' => '置き換えるパス',
	'Download attachments' => 'Attachmentのダウンロード',
	'Requires the use of a cron job to download attachments from WordPress powered blog in the background.' => 'WordPressのブログからAttachmentをダウンロードするには、cronなどの決められたタイミングでプログラムを実行する環境が必要です。',
	'Download attachments (images and files) from the imported WordPress powered blog.' => 'インポート中に、既存のWordPressで公開されているブログからAttachment（画像やファイル）をダウンロードします。',

## plugins/WidgetManager/WidgetManager.pl
	'Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.' => 'Widget Manager version 1.1; このプラグインは、古いバージョンのWidget ManagerのデータをMovable Typeのコアへ統合してアップグレードするために提供されています。アップグレード以外の機能はありません。最新のMovable Typeへアップグレードし終わった後は、このプラグインを削除してください。',
	'Moving storage of Widget Manager [_2]...' => 'ウィジェット管理[_2]の格納場所を移動しています。...',

## plugins/feeds-app-lite/lib/MT/Feeds/Lite.pm
	'An error occurred processing [_1]. The previous version of the feed was used. A HTTP status of [_2] was returned.' => '[_1]の実行中にエラーが発生しました。以前のバージョンのフィードが使用されます。[_2]のHTTPステータスが返されました。',
	'An error occurred processing [_1]. A previous version of the feed was not available.A HTTP status of [_2] was returned.' => '[_1]の実行中にエラーが発生しました。以前のバージョンのフィードはありません。[_2]のHTTPステータスが返されました。',

## plugins/feeds-app-lite/lib/MT/Feeds/Tags.pm
	'\'[_1]\' is a required argument of [_2]' => '\'[_1]\' は[_2]の引数を必要とします',
	'MT[_1] was not used in the proper context.' => 'MT[_1]を適切なコンテキスト外で使用しています。',

## plugins/feeds-app-lite/mt-feeds.pl
	'Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type? <a href="http://code.appnel.com/feeds-app" target="_blank">Upgrade to Feeds.App</a>.' => 'Feeds.App Liteからブログ上のフィードを更新（再構築）できます。Movable Typeでフィードをさらに活用するには<a href="http://code.appnel.com/feeds-app" target="_blank">Feeds.App</a>にアップグレードします。',
	'Create a Feed Widget' => 'フィードウィジェットを作成',

## plugins/feeds-app-lite/tmpl/config.tmpl
	'Feeds.App Lite Widget Creator' => 'Feeds.App Lite ウィジェット作成ツール',
	'Configure feed widget settings' => 'フィードウィジェットを設定する',
	'Enter a title for your widget.  This will also be displayed as the title of the feed when used on your published blog.' => 'Widgetのタイトルを入力してください。このタイトルは、公開されているブログでWidgetが使用されたときにもフィードのタイトルとして表示されます。',
	'[_1] Feed Widget' => '[_1]フィードウィジェット',
	'Select the maximum number of entries to display.' => '表示するブログ記事の最大数を選択します。',
	'3' => '3',
	'5' => '5',
	'10' => '10',
	'All' => 'すべて',

## plugins/feeds-app-lite/tmpl/msg.tmpl
	'No feeds could be discovered using [_1]' => '[_1]でフィードが見つかりませんでした。',
	q{An error occurred processing [_1]. Check <a href="javascript:void(0)" onclick="closeDialog('http://www.feedvalidator.org/check.cgi?url=[_2]')">here</a> for more detail and please try again.} => q{[_1]の実行中にエラーが発生しました。<a href="javascript:void(0)" onclick="closeDialog('http://www.feedvalidator.org/check.cgi?url=[_2]')">ここ</a>をクリックし、詳細を確認のうえ、再度実行してください。},
	'A widget named <strong>[_1]</strong> has been created.' => 'フィードウィジェット「[_1]」を作成しました。',
	q{You may now <a href="javascript:void(0)" onclick="closeDialog('[_2]')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using <a href="javascript:void(0)" onclick="closeDialog('[_3]')">WidgetManager</a> or the following MTInclude tag:} => q{<a href="javascript:void(0)" onclick="closeDialog('[_2]')">[_1]を編集</a>できます。また、<a href="javascript:void(0)" onclick="closeDialog('[_3]')">WidgetManager</a>か以下のMTIncludeタグを使ってブログに挿入できます。},
	q{You may now <a href="javascript:void(0)" onclick="closeDialog('[_2]')">edit &ldquo;[_1]&rdquo;</a> or include the widget in your blog using the following MTInclude tag:} => q{<a href="javascript:void(0)" onclick="closeDialog('[_2]')">[_1]を編集</a>できます。また、以下のMTIncludeタグを使ってブログに挿入できます。},
	'Create Another' => '続けて作成する',

## plugins/feeds-app-lite/tmpl/select.tmpl
	'Multiple feeds were found' => 'フィードが複数見つかりました。',
	'Select the feed you wish to use. <em>Feeds.App Lite supports text-only RSS 1.0, 2.0 and Atom feeds.</em>' => '利用するフィードを選択してください。<strong>Feeds.App Liteはテキストで構成されたRSS 1.0、RSS 2.0、Atomの各形式をサポートしています</strong>。',
	'URI' => 'URI',

## plugins/feeds-app-lite/tmpl/start.tmpl
	'You must enter a feed or site URL to proceed' => 'フィードまたはサイトのURLを入力してください。',
	'Create a widget from a feed' => 'フィードからウィジェットを作成する',
	'Feed or Site URL' => 'フィードまたはサイトのURL',
	'Enter the URL of a feed, or the URL of a site that has a feed.' => 'フィードのURLを入力するか、フィードを配信しているサイトのURLを入力してください。',

## plugins/mixiComment/lib/mixiComment/App.pm
	'mixi reported that you failed to login.  Try again.' => 'ログインに失敗しました。',

## plugins/mixiComment/mixiComment.pl
	'Allows commenters to sign in to Movable Type using their own mixi username and password via OpenID.' => 'mixiのアカウントを使ってMovable Typeにサインインし、コメントできるようにします。',
	'mixi' => 'ミクシィ',

## plugins/mixiComment/tmpl/config.tmpl
	'A mixi ID has already been registered in this blog.  If you want to change the mixi ID for the blog, <a href="[_1]">click here</a> to sign in using your mixi account.  If you want all of the mixi users to comment to your blog (not only your my mixi users), click the reset button to remove the setting.' => 'すでにmixiのIDを登録してあります。ブログに関連付けるmixiのIDを変えたい場合は、<a href="[_1]">ここをクリックしてmixiにログイン</a>してください。マイミクだけでなくすべてのmixiユーザーからのコメントを受け付けたいときは、初期化ボタンをクリックして設定を消去してください。',
	'If you want to restrict comments only from your my mixi users, <a href="[_1]">click here</a> to sign in using your mixi account.' => 'マイミクからのみコメントを受け付ける設定にするには、<a href="[_1]">ここをクリックしてまずmixiにログイン</a>してください。',

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
	q{Lookups monitor the source IP addresses and hyperlinks of all incoming feedback. If a comment or TrackBack comes from a blacklisted IP address or contains a blacklisted domain, it can be held for moderation or scored as junk and placed into the blog's Junk folder. Additionally, advanced lookups on TrackBack source data can be performed.} => q{LookupsはすべてのコメントとトラックバックについてIPアドレスとハイパーリンクを監視します。コメントやトラックバックの送信元のIPアドレスやドメイン名について、外部のブラックリストサービスに問い合わせを行います。そして、結果に応じて公開を保留するか、またはスパムしてゴミ箱に移動します。また、トラックバックの送信元の確認も実行できます。},
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
	'Credit feedback rating when previously published comments are found matching on the &quot;Email&quot; address' => 'すでに公開済みの&quot;メールアドレス&quot;を含むコメントを好評価します。',
	'Exclude Email addresses from comments published within last [_1] days.' => '過去[_1]日間に公開されたコメントからメールアドレスを除外',

## plugins/spamlookup/tmpl/word_config.tmpl
	'Incoming feedback can be monitored for specific keywords, domain names, and patterns. Matches can be held for moderation or scored as junk. Additionally, junk scores for these matches can be customized.' => '受信したコメントトラックバックについて、特定のキーワードやドメイン名、パターンを監視します。一致したものについて、公開の保留または、スパム指定を行います。個々のパターンについて、評価値の調整も可能です。',
	'Keywords to Moderate' => '公開を保留するキーワード',
	'Keywords to Junk' => 'スパムにするキーワード',

);

1;
