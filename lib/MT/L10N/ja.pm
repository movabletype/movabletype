# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id:$

package MT::L10N::ja;
use strict;
use warnings;
use utf8;
use MT::L10N;
use MT::L10N::en_us;
use vars qw( @ISA %Lexicon );
@ISA = qw( MT::L10N::en_us );

## The following is the translation table.

%Lexicon = (

## addons/Commercial.pack/config.yaml
	'Are you sure you want to delete the selected CustomFields?' => '選択したカスタムフィールドを削除してもよろしいですか？',
	'Child Site' => '子サイト',
	'No Name' => '名前なし',
	'Required' => '必須',
	'Site' => 'サイト',

## addons/Commercial.pack/lib/CustomFields/App/CMS.pm
	'Create Custom Field' => 'カスタムフィールドの作成',
	'Custom Fields' => 'カスタムフィールド',
	'Customize the forms and fields for entries, pages, folders, categories, and users, storing exactly the information you need.' => '記事、ウェブページ、フォルダ、カテゴリ、ユーザーのフォームとフィールドをカスタマイズして、必要な情報を格納することができます。',
	'Movable Type' => 'Movable Type',
	'Permission denied.' => '権限がありません。',
	'Please ensure all required fields have been filled in.' => '必須のフィールドに値が入力されていません。',
	'Please enter valid URL for the URL field: [_1]' => 'URLを入力してください。[_1]',
	'Saving permissions failed: [_1]' => '権限を保存できませんでした: [_1]',
	'View image' => '表示',
	'You must select other type if object is the comment.' => 'コメントでない場合、他の種類を選択する必要があります。',
	'blog and the system' => 'ブログとシステム',
	'blog' => 'ブログ',
	'type' => '種類',
	'website and the system' => 'ウェブサイトとシステム',
	'website' => 'ウェブサイト',
	q{Invalid date '[_1]'; dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{'[_1]'は不正な日時です。日時はYYYY-MM-DD HH:MM:SSの形式で入力してください。},
	q{Please enter some value for required '[_1]' field.} => q{「[_1]」は必須です。値を入力してください。},
	q{The basename '[_1]' is already in use. It must be unique within this [_2].} => q{[_1]というベースネームはすでに使われています。[_2]内で重複しない値を入力してください。},
	q{The template tag '[_1]' is already in use.} => q{[_1]というタグは既に存在します。},
	q{The template tag '[_1]' is an invalid tag name.} => q{[_1]というタグ名は不正です。},
	q{[_1] '[_2]' (ID:[_3]) added by user '[_4]'} => q{[_4]が[_1]「[_2]」(ID:[_3])を追加しました。},
	q{[_1] '[_2]' (ID:[_3]) deleted by '[_4]'} => q{'[_4]'が[_1]'[_2]'(ID:[_3])を削除しました。},

## addons/Commercial.pack/lib/CustomFields/BackupRestore.pm
	'Done.' => '完了',
	'Importing asset associations found in custom fields ( [_1] ) ...' => 'カスタムフィールド([_1])に含まれるアセットとの関連付けを復元しています...',
	'Importing custom fields data stored in MT::PluginData...' => 'MT::PluginDataに保存されているカスタムフィールドのデータをインポートしています...',
	'Importing url of the assets associated in custom fields ( [_1] )...' => 'カスタムフィールド([_1])に含まれるアセットのURLを復元しています...',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback.pm
	'Please enter valid option for the [_1] field: [_2]' => '名前: [_2] (種類: [_1] ) のオプションを選択してください。',
	q{Invalid date '[_1]'; dates should be real dates.} => q{日時が不正です: [_1]},

## addons/Commercial.pack/lib/CustomFields/DataAPI/Callback/Field.pm
	'A parameter "[_1]" is required.' => '"[_1]" パラメータは必須です。',
	'The systemObject "[_1]" is invalid.' => '不正なシステムオブジェクトです: [_1]',
	'The type "[_1]" is invalid.' => '不正な種類です: [_1]',

## addons/Commercial.pack/lib/CustomFields/DataAPI/Endpoint/v2/Field.pm
	'Invalid includeShared parameter provided: [_1]' => '無効なincludeSharedパラメータが指定されました: [_1]',
	'Removing [_1] failed: [_2]' => '[_1]を削除できませんでした: [_2]',
	'Saving [_1] failed: [_2]' => '[_1]を保存できませんでした: [_2]',

## addons/Commercial.pack/lib/CustomFields/Field.pm
	'Field' => 'フィールド',
	'Fields' => 'フィールド',
	'System Object' => 'システムオブジェクト',
	'Type' => '種類',
	'_CF_BASENAME' => 'ベースネーム',
	'__CF_REQUIRED_VALUE__' => '値',
	q{The '[_1]' of the template tag '[_2]' that is already in use in [_3] is [_4].} => q{'[_2]'というテンプレートタグが[_3]に既に存在していますが、[_1]が異なるため、重複して作成する事が出来ません。テンプレートタグ名を変えるか、[_1]を同じにする必要があります。([_1]: [_4])},
	q{The template tag '[_1]' is already in use in [_2]} => q{[_1]というタグは既に[_2]に存在します。},
	q{The template tag '[_1]' is already in use in the system level} => q{[_1]というタグは既にシステムに存在します。},
	q{The template tag '[_1]' is already in use in this blog} => q{[_1]というタグは既にこのブログに存在します。},

## addons/Commercial.pack/lib/CustomFields/Template/ContextHandlers.pm
	q{Are you sure you have used a '[_1]' tag in the correct context? We could not find the [_2]} => q{[_2]が見つかりませんでした。[_1]タグを正しいコンテキストで使用しているか確認してください。},
	q{You used an '[_1]' tag outside of the context of the correct content; } => q{[_1]タグを正しいコンテキストで使用していません。},

## addons/Commercial.pack/lib/CustomFields/Theme.pm
	'Conflict of [_1] "[_2]" with [_3]' => '[_3] と[_1]「[_2]」が衝突しています',
	'a field on system wide' => 'システム全体のカスタムフィールド',
	'a field on this blog' => 'このブログのカスタムフィールド',

## addons/Commercial.pack/lib/CustomFields/Util.pm
	'Cloning fields for blog:' => 'カスタムフィールドを複製しています:',
	'[_1] records processed.' => '[_1]レコードを処理しました。',
	'[_1] records processed...' => '[_1]レコードを処理しました...',

## addons/Enterprise.pack/lib/MT/Enterprise/Author.pm
	'Loading MT::LDAP failed: [_1].' => 'MT::LDAPの読み込みに失敗しました: [_1]',

## addons/Enterprise.pack/lib/MT/Enterprise/BulkCreation.pm
	'A user with the same name was found.  The registration was not processed: [_1]' => '同名のユーザーが登録されているため、登録できません: [_1]',
	'Formatting error at line [_1]: [_2]' => '[_1]行目でエラーが見つかりました: [_2]',
	'Invalid command: [_1]' => 'コマンドが認識できません: [_1]',
	'Invalid display name: [_1]' => '表示名の設定に誤りがあります: [_1]',
	'Invalid email address: [_1]' => 'メールアドレスが正しくありません: [_1]',
	'Invalid language: [_1]' => '使用言語の設定に誤りがあります: [_1]',
	'Invalid number of columns for [_1]' => '[_1] コマンドのカラムの数が不正です',
	'Invalid password: [_1]' => 'パスワードの設定に誤りがあります: [_1]',
	'Invalid user name: [_1]' => 'ユーザー名の設定に誤りがあります: [_1]',
	'User cannot be created: [_1].' => 'ユーザーを登録できません: [_1]',
	'User cannot be updated: [_1].' => 'ユーザーの情報を更新できません: [_1]',
	q{Permission granted to user '[_1]'} => q{ユーザー [_1] に権限を設定しました。},
	q{User '[_1]' already exists. The update was not processed: [_2]} => q{[_1] というユーザーがすでに存在します。更新はできませんでした: [_2]},
	q{User '[_1]' has been created.} => q{ユーザー「[_1]」が作成されました。},
	q{User '[_1]' has been deleted.} => q{ユーザーを削除しました: [_1]},
	q{User '[_1]' has been updated.} => q{ユーザーの情報を更新しました: [_1]},
	q{User '[_1]' not found.  The deletion was not processed.} => q{ユーザー「[_1]」が見つからないため、削除できません。},
	q{User '[_1]' not found.  The update was not processed.} => q{ユーザー「[_1]」が見つからないため、更新できません。},
	q{User '[_1]' was found, but the deletion was not processed} => q{ユーザー「[_1]」が見つかりましたが、削除できません。},

## addons/Enterprise.pack/lib/MT/Enterprise/CMS.pm
	'(no reason given)' => '(原因は不明)',
	'A user cannot change his/her own username in this environment.' => '自分のユーザー名を変えることはこの構成ではできません。',
	'An error occurred when enabling this user.' => 'ユーザーを有効化するときにエラーが発生しました',
	'Bulk author export cannot be used under external user management.' => 'ExternalUserManagement環境ではユーザーの一括出力はできません。',
	'Bulk import cannot be used under external user management.' => 'ExternalUserManagement環境ではユーザーの一括編集はできません。',
	'Bulk management' => '一括管理',
	'Cannot rewind' => 'ポインタを先頭に移動できません',
	'Load failed: [_1]' => 'ロードできませんでした: [_1]',
	'No records were found in the file.  Make sure the file uses CRLF as the line-ending characters.' => '登録するレコードがありません。改行コードがCRLFになっているかどうか確認してください。',
	'Please select a file to upload.' => 'アップロードするファイルを選択してください。',
	'Registered [quant,_1,user,users], updated [quant,_2,user,users], deleted [quant,_3,user,users].' => '登録:[quant,_1,人,人]、更新:[quant,_2,人,人]、削除:[quant,_3,人,人]',
	'Users & Groups' => 'ユーザー/グループ',
	'Users' => 'ユーザー',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/Group.pm
	'Synchronization of groups can not be performed without LDAPGroupIdAttribute and/or LDAPGroupNameAttribute being set.' => 'グループを同期するためにはLDAPGroupIdAttributeおよびLDAPGroupNameAttributeの設定が必須です。',

## addons/Enterprise.pack/lib/MT/Enterprise/DataAPI/Endpoint/v2/User.pm
	'An attempt to disable all system administrators in the system was made.  Synchronization of users was interrupted.' => 'すべてのシステム管理者が無効にされるため、ユーザーの同期は中断されました。',

## addons/Enterprise.pack/lib/MT/Enterprise/Upgrade.pm
	'Fixing binary data for Microsoft SQL Server storage...' => 'Microsoft SQL Serverでバイナリデータを移行しています...',

## addons/Enterprise.pack/lib/MT/Enterprise/Wizard.pm
	'CRAM-MD5' => 'CRAM-MD5',
	'Digest-MD5' => 'Digest-MD5',
	'Found' => '見つかりました',
	'Login' => 'ログイン',
	'Not Found' => '見つかりませんでした',
	'PLAIN' => 'PLAIN',

## addons/Enterprise.pack/lib/MT/LDAP.pm
	'Binding to LDAP server failed: [_1]' => 'LDAPサーバーに接続できません: [_1]',
	'Either your server does not have [_1] installed, the version that is installed is too old, or [_1] requires another module that is not installed.' => '[_1]がインストールされていないか、インストールされているバージョンが古い、または [_1]の動作に必要な他のモジュールが見つかりません。',
	'Entry not found in LDAP: [_1]' => 'LDAPサーバーにレコードが見つかりません: [_1]',
	'Error connecting to LDAP server [_1]: [_2]' => 'LDAPサーバー [_1] に接続できません: [_2]',
	'Invalid LDAPAuthURL scheme: [_1].' => 'LDAPAuthURLのスキーム「[_1]」が不正です。',
	'More than one user with the same name found in LDAP: [_1]' => 'LDAPサーバー上に同一名のユーザーが見つかりました: [_1]',
	'User not found in LDAP: [_1]' => 'LDAPサーバー上にユーザーが見つかりません: [_1]',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/MSSQLServer.pm
	'PublishCharset [_1] is not supported in this version of the MS SQL Server Driver.' => 'PublishCharset [_1]はMS SQL Serverのドライバでサポートされていません。',

## addons/Enterprise.pack/lib/MT/ObjectDriver/Driver/DBD/UMSSQLServer.pm
	'This version of UMSSQLServer driver requires DBD::ODBC compiled with Unicode support.' => 'このバージョンのUMSSQLServerドライバは、UnicodeをサポートするDBD::ODBCが必要です。',
	'This version of UMSSQLServer driver requires DBD::ODBC version 1.14.' => 'このバージョンのUMSSQLServerドライバは、DBD::ODBCバージョン1.14以上で動作します。',

## addons/Sync.pack/lib/MT/FileSynchronizer.pm
	'Cannot load template.' => 'テンプレートをロードできませんでした。',
	q{Cannot find author for id '[_1]'} => q{ID:[_1]のユーザーが見つかりませんでした。},

## addons/Sync.pack/lib/MT/FileSynchronizer/Rsync.pm
	'Error during rsync: Command (exit code [_1]): [_2]' => 'rsync コマンドでエラーが起きました (終了コード: [_1]): [_2]',
	'Failed to remove "[_1]": [_2]' => '[_1]の削除に失敗しました: [_2]',
	'Incomplete file copy to Temp Directory.' => 'テンポラリディレクトリへのファイルのコピーに失敗しました。',
	'Temp Directory [_1] is not writable.' => 'テンポラリディレクトリ ([_1]) に書き込めません。',

## addons/Sync.pack/lib/MT/SyncFileList.pm
	'Sync file list' => '同期リスト',

## addons/Sync.pack/lib/MT/SyncLog.pm
	'*User deleted*' => '*削除されました*',
	'Are you sure you want to reset the sync log?' => 'サーバー配信履歴を消去してもよろしいですか?',
	'FTP' => 'FTP',
	'Invalid parameter.' => '不正なパラメータです。',
	'Rsync' => 'rsync',
	'Showing only ID: [_1]' => 'ID:[_1]のログ',
	'Sync Name' => '設定名',
	'Sync Result' => '配信結果',
	'Sync Type' => '配信方法',
	'Trigger' => 'トリガー',
	q{[_1] in [_2]: [_3]} => q{[_2]が '[_3]' である[_1]},

## addons/Sync.pack/lib/MT/SyncSetting.pm
	'Sync settings' => 'サーバー配信の設定',

## addons/Sync.pack/lib/MT/SyncStatus.pm
	'Sync Status' => '配信状況',

## addons/Sync.pack/lib/Sync/App/CMS.pm
	'Create Sync Setting' => 'サーバー配信設定の作成',
	'Deleting sync file list failed "[_1]": [_2]' => '[_1]の配信ファイルリスト削除に失敗しました: [_2]',
	'Invalid request.' => '不正な要求です。',
	'Permission denied: [_1]' => '権限がありません: [_1]',
	'Save failed: [_1]' => '保存できませんでした: [_1]',
	'Sync Settings' => 'サーバー配信設定',
	'The previous synchronization file list has been cleared. [_1] by [_2].' => '[_2] が、[_1]の過去の配信ファイルリストを削除しました。',
	'The sync setting with the same name already exists.' => '同名のサーバー配信設定がすでに存在します。',
	'[_1] (copy)' => '[_1] (複製)',
	q{An error occurred while attempting to connect to the FTP server '[_1]': [_2]} => q{FTPサーバー '[_1]' への接続中にエラーが発生しました: [_2]},
	q{An error occurred while attempting to retrieve the current directory from '[_1]': [_2]} => q{FTPサーバー '[_1]' のカレントディレクトリが取得できませんでした: [_2]},
	q{An error occurred while attempting to retrieve the list of directories from '[_1]': [_2]} => q{FTPサーバー '[_1]' からディレクトリの一覧が取得できませんでした: [_2]},
	q{Error saving Sync Setting. No response from FTP server '[_1]'.} => q{サーバー配信の設定を保存できません。FTPサーバー '[_1]' からの応答がありません。},
	q{Sync setting '[_1]' (ID: [_2]) deleted by [_3].} => q{[_3] が、サーバー配信の設定 '[_1]' (ID: [_2]) を削除しました。},
	q{Sync setting '[_1]' (ID: [_2]) edited by [_3].} => q{[_3] が、サーバー配信の設定 '[_1]' (ID: [_2]) を保存しました。},

## addons/Sync.pack/lib/Sync/Upgrade.pm
	'Removing all jobs of contents sync...' => '登録されているサーバー配信のジョブを削除しています...',

## addons/Sync.pack/tmpl/cfg_contents_sync.tmpl
	'Are you sure you want to remove this settings?' => 'この設定を削除しますか？',
	'Invalid date.' => '無効な日付フォーマットです。',
	'Invalid time.' => '無効な時刻指定です。',
	'Sync name is required.' => '設定名は必須です。',
	'Sync name should be shorter than [_1] characters.' => '設定名が長すぎます。[_1]文字以内で指定してください。',
	'The sync date must be in the future.' => 'サーバー配信日時は、未来の日時を指定してください。',
	'You must make one or more destination settings.' => 'サーバー配信先が設定されていません。',

## default_templates/about_this_page.mtml
	'<a href="[_1]">[_2]</a> is the next archive.' => '次のアーカイブは<a href="[_1]">[_2]</a>です。',
	'<a href="[_1]">[_2]</a> is the next category.' => '次のカテゴリは<a href="[_1]">[_2]</a>です。',
	'<a href="[_1]">[_2]</a> is the next entry in this blog.' => '次の記事は「<a href="[_1]">[_2]</a>」です。',
	'<a href="[_1]">[_2]</a> is the previous archive.' => '前のアーカイブは<a href="[_1]">[_2]</a>です。',
	'<a href="[_1]">[_2]</a> is the previous category.' => '前のカテゴリは<a href="[_1]">[_2]</a>です。',
	'<a href="[_1]">[_2]</a> was the previous entry in this blog.' => 'ひとつ前の記事は「<a href="[_1]">[_2]</a>」です。',
	'About Archives' => 'このページについて',
	'About this Archive' => 'このアーカイブについて',
	'About this Entry' => 'この記事について',
	'Find recent content on the <a href="[_1]">main index</a> or look in the <a href="[_2]">archives</a> to find all content.' => '最近のコンテンツは<a href="[_1]">インデックスページ</a>で見られます。過去に書かれたものは<a href="[_2]">アーカイブのページ</a>で見られます。',
	'Find recent content on the <a href="[_1]">main index</a>.' => '最近のコンテンツは<a href="[_1]">インデックスページ</a>で見られます。',
	'This page contains a single entry by [_1] published on <em>[_2]</em>.' => 'このページは、[_1]が[_2]に書いた記事です。',
	'This page contains links to all of the archived content.' => 'このページには過去に書かれたすべてのコンテンツが含まれています。',
	'This page is an archive of entries from <strong>[_2]</strong> listed from newest to oldest.' => 'このページには、<strong>[_2]</strong>に書かれた記事が新しい順に公開されています。',
	'This page is an archive of entries in the <strong>[_1]</strong> category from <strong>[_2]</strong>.' => 'このページには、<strong>[_2]</strong>以降に書かれた記事のうち<strong>[_1]</strong>カテゴリに属しているものが含まれています。',
	'This page is an archive of recent entries in the <strong>[_1]</strong> category.' => 'このページには、過去に書かれた記事のうち<strong>[_1]</strong>カテゴリに属しているものが含まれています。',
	'This page is an archive of recent entries written by <strong>[_1]</strong> in <strong>[_2]</strong>.' => 'このページには、<strong>[_1]</strong>が<strong>[_2]</strong>に書いた記事が含まれています。',
	'This page is an archive of recent entries written by <strong>[_1]</strong>.' => 'このページには、<strong>[_1]</strong>が最近書いた記事が含まれています。',

## default_templates/archive_index.mtml
	'Archives' => 'アーカイブ',
	'Author Archives' => 'ユーザーアーカイブ',
	'Author Monthly Archives' => '月別ユーザーアーカイブ',
	'Banner Footer' => 'バナーフッター',
	'Banner Header' => 'バナーヘッダー',
	'Categories' => 'カテゴリ',
	'Category Monthly Archives' => '月別カテゴリアーカイブ',
	'HTML Head' => 'HTMLヘッダー',
	'Monthly Archives' => '月別アーカイブ',
	'Sidebar' => 'サイドバー',

## default_templates/archive_widgets_group.mtml
	'Category Archives' => 'カテゴリアーカイブ',
	'Current Category Monthly Archives' => 'カテゴリ月別アーカイブ',
	'This is a custom set of widgets that serve different content depending on the type of archive in which it is included. More info: [_1]' => 'アーカイブの種類に応じて異なる内容を表示するように設定されたウィジェットです。詳細: [_1]',

## default_templates/author_archive_list.mtml
	'Authors' => 'ユーザー',
	'[_1] ([_2])' => '[_1] ([_2])',

## default_templates/banner_footer.mtml
	'This blog is licensed under a <a href="[_1]">Creative Commons License</a>.' => 'このブログは<a href="[_1]">クリエイティブ・コモンズ</a>でライセンスされています。',
	'_POWERED_BY' => 'Powered by <a href="https://www.sixapart.jp/movabletype/"><$MTProductName$></a>',

## default_templates/calendar.mtml
	'Fri' => '金',
	'Friday' => '金曜日',
	'Mon' => '月',
	'Monday' => '月曜日',
	'Monthly calendar with links to daily posts' => 'リンク付きのカレンダー',
	'Sat' => '土',
	'Saturday' => '土曜日',
	'Sun' => '日',
	'Sunday' => '日曜日',
	'Thu' => '木',
	'Thursday' => '木曜日',
	'Tue' => '火',
	'Tuesday' => '火曜日',
	'Wed' => '水',
	'Wednesday' => '水曜日',

## default_templates/category_entry_listing.mtml
	'Entry Summary' => '記事の概要',
	'Main Index' => 'メインページ',
	'Recently in <em>[_1]</em> Category' => '<em>[_1]</em>の最近の記事',
	'[_1] Archives' => '[_1]アーカイブ',

## default_templates/current_author_monthly_archive_list.mtml
	'[_1]: Monthly Archives' => '[_1]: 月別アーカイブ',

## default_templates/current_category_monthly_archive_list.mtml
	'[_1]' => '[_1]',

## default_templates/date_based_author_archives.mtml
	'Author Daily Archives' => '日別ユーザーアーカイブ',
	'Author Weekly Archives' => '週別ユーザーアーカイブ',
	'Author Yearly Archives' => '年別ユーザーアーカイブ',

## default_templates/date_based_category_archives.mtml
	'Category Daily Archives' => '日別カテゴリアーカイブ',
	'Category Weekly Archives' => '週別カテゴリアーカイブ',
	'Category Yearly Archives' => '年別カテゴリアーカイブ',

## default_templates/dynamic_error.mtml
	'Page Not Found' => 'ページが見つかりません。',

## default_templates/entry.mtml
	'# Comments' => 'コメント(#)',
	'# TrackBacks' => 'トラックバック(#)',
	'1 Comment' => 'コメント(1)',
	'1 TrackBack' => 'トラックバック(1)',
	'By [_1] on [_2]' => '[_1] ([_2])',
	'Comments' => 'コメント',
	'No Comments' => 'コメント(0)',
	'No TrackBacks' => 'トラックバック(0)',
	'Tags' => 'タグ',
	'Trackbacks' => 'トラックバック',

## default_templates/entry_summary.mtml
	'Continue reading <a href="[_1]" rel="bookmark">[_2]</a>.' => '続きを読む: <a href="[_1]" rel="bookmark">[_2]</a>',

## default_templates/footer-email.mtml
	'Powered by Movable Type [_1]' => 'Powered by Movable Type [_1]',

## default_templates/javascript.mtml
	'Edit' => '編集',
	'Replying to <a href="[_1]" onclick="[_2]">comment from [_3]</a>' => '<a href="[_1]" onclick="[_2]">[_3]からのコメント</a>に返信',
	'Signing in...' => 'サインインします...',
	'Thanks for signing in, __NAME__. ([_1]sign out[_2])' => '__NAME__としてサインインしています。([_1]サインアウト[_2])',
	'The sign-in attempt was not successful; Please try again.' => 'サインインできませんでした。',
	'You do not have permission to comment on this blog. ([_1]sign out[_2])' => 'このブログにコメントする権限を持っていません。([_1]サインアウトする[_2])',
	'Your session has expired. Please sign in again to comment.' => 'セッションの有効期限が切れています。再度サインインしてください。',
	'[_1]Sign in[_2] to comment, or comment anonymously.' => 'コメントする前に[_1]サインイン[_2]することもできます。',
	'[_1]Sign in[_2] to comment.' => 'コメントするにはまず[_1]サインイン[_2]してください。',
	'[quant,_1,day,days] ago' => '[quant,_1,日,日]前',
	'[quant,_1,hour,hours] ago' => '[quant,_1,時間,時間]前',
	'[quant,_1,minute,minutes] ago' => '[quant,_1,分,分]前',
	'moments ago' => '直前',

## default_templates/lockout-ip.mtml
	'IP Address: [_1]' => 'IPアドレス: [_1]',
	'Mail Footer' => 'メールフッター',
	'Recovery: [_1]' => '解除時刻: [_1]',
	'This email is to notify you that an IP address has been locked out.' => 'これは以下のIPアドレスからのアクセスがロックされたことを通知するメールです。',

## default_templates/lockout-user.mtml
	'Display Name: [_1]' => '表示名: [_1]',
	'Email: [_1]' => 'メール: [_1]',
	'If you want to permit this user to participate again, click the link below.' => 'ユーザーのロックを解除する場合は、リンクをクリックしてください。',
	'This email is to notify you that a Movable Type user account has been locked out.' => 'これは以下のユーザーアカウントがロックされたことを通知するメールです。',
	'Username: [_1]' => 'ユーザー名: [_1]',

## default_templates/main_index_widgets_group.mtml
	'Recent Assets' => 'アセット',
	'Recent Comments' => '最近のコメント',
	'Recent Entries' => '最近の記事',
	'Tag Cloud' => 'タグクラウド',
	'This is a custom set of widgets that only appear on the homepage (or "main_index"). More info: [_1]' => 'main_indexのテンプレートだけに表示されるように設定されているウィジェットのセットです。詳細: [_1]',

## default_templates/monthly_archive_dropdown.mtml
	'Select a Month...' => '月を選択...',

## default_templates/monthly_archive_list.mtml
	'[_1] <a href="[_2]">Archives</a>' => '[_1] <a href="[_2]">アーカイブ</a>',

## default_templates/notify-entry.mtml
	'Message from Sender:' => 'メッセージ: ',
	'Publish Date: [_1]' => '日付: [_1]',
	'View entry:' => '表示する',
	'View page:' => '表示する',
	'You are receiving this email either because you have elected to receive notifications about new content on [_1], or the author of the post thought you would be interested. If you no longer wish to receive these emails, please contact the following person:' => 'このメールは[_1]で新規に作成されたコンテンツに関する通知を送るように設定されているか、またはコンテンツの著者が選択したユーザーに送信されています。このメールを受信したくない場合は、次のユーザーに連絡してください:',
	'[_1] Title: [_2]' => '[_1] タイトル: [_2]',
	q{A new [lc,_3] entitled '[_1]' has been published to [_2].} => q{新しい[_3]「[_1]」を[_2]で公開しました。},

## default_templates/openid.mtml
	'Learn more about OpenID' => 'OpenIDについて',
	'[_1] accepted here' => '[_1]対応しています',
	'http://www.sixapart.com/labs/openid/' => 'https://www.sixapart.jp/about/openid.html',

## default_templates/pages_list.mtml
	'Pages' => 'ウェブページ',

## default_templates/powered_by.mtml
	'_MTCOM_URL' => 'https://www.sixapart.jp/movabletype/',

## default_templates/recover-password.mtml
	'A request was made to change your Movable Type password. To complete this process click on the link below to select a new password.' => 'パスワードをリセットしようとしています。以下のリンクをクリックして、新しいパスワードを設定してください。',
	'If you did not request this change, you can safely ignore this email.' => 'このメールに心当たりがないときは、何もせずに無視してください。',

## default_templates/search.mtml
	'Search' => '検索',

## default_templates/search_results.mtml
	'By default, this search engine looks for all of the specified words in any order. To search for an exact phrase, enclose the phrase in quotes:' => 'すべての単語が順序に関係なく検索されます。フレーズで検索したいときは引用符で囲んでください。',
	'Instructions' => '例',
	'Next' => '次',
	'No results found for &ldquo;[_1]&rdquo;.' => '「[_1]」と一致する結果は見つかりませんでした。',
	'Previous' => '前',
	'Results matching &ldquo;[_1]&rdquo;' => '「[_1]」と一致するもの',
	'Results tagged &ldquo;[_1]&rdquo;' => 'タグ「[_1]」が付けられているもの',
	'Search Results' => '検索結果',
	'The search engine also supports the AND, OR, and NOT boolean operators:' => 'AND、OR、NOTを入れることで論理検索を行うこともできます。',
	'movable type' => 'movable type',
	'personal OR publishing' => '個人 OR 出版',
	'publishing NOT personal' => '個人 NOT 出版',

## default_templates/sidebar.mtml
	'2-column layout - Sidebar' => '2カラムのサイドバー',
	'3-column layout - Primary Sidebar' => '3カラムのサイドバー(メイン)',
	'3-column layout - Secondary Sidebar' => '3カラムのサイドバー(サブ)',

## default_templates/signin.mtml
	'Sign In' => 'サインイン',
	'You are signed in as ' => 'ユーザー名:',
	'You do not have permission to sign in to this blog.' => 'このブログにサインインする権限がありません。',
	'sign out' => 'サインアウト',

## default_templates/syndication.mtml
	'Feed of results matching &ldquo;[_1]&ldquo;' => '「[_1]」を検索した結果のフィード',
	'Feed of results tagged &ldquo;[_1]&ldquo;' => 'タグ「[_1]」のフィード',
	'Subscribe to a feed of all future entries matching &ldquo;[_1]&ldquo;' => 'タグ「[_1]」を購読',
	'Subscribe to a feed of all future entries tagged &ldquo;[_1]&ldquo;' => '「[_1]」の検索結果を購読',
	'Subscribe to feed' => '購読する',
	q{Subscribe to this blog's feed} => q{このブログを購読},

## lib/MT.pm
	'AIM' => 'AIM',
	'An error occurred: [_1]' => 'エラーが発生しました: [_1]',
	'Bad CGIPath config' => 'CGIPathの設定が不正です。',
	'Bad LocalLib config ([_1]): [_2]' => 'LocalLibの設定([_1])が不正です: [_2]',
	'Bad ObjectDriver config' => 'ObjectDriverの設定が不正です。',
	'Error while creating email: [_1]' => 'メールの再構築中にエラーが発生しました: [_1]',
	'Fourth argument to add_callback must be a CODE reference.' => 'add_callbackの第4引数はCODEへの参照でなければなりません。',
	'Google' => 'Google',
	'Hatena' => 'はてな',
	'Hello, [_1]' => '[_1]',
	'Hello, world' => 'Hello, world',
	'If it is present, the third argument to add_callback must be an object of type MT::Component or MT::Plugin' => 'add_callbackの第3引数を指定する場合は、MT::ComponentまたはMT::Pluginオブジェクトでなければなりません。',
	'Internal callback' => '内部コールバック',
	'Invalid priority level [_1] at add_callback' => 'add_callbackの優先度レベル[_1]が不正です。',
	'LiveJournal' => 'LiveJournal',
	'Missing configuration file. Maybe you forgot to move mt-config.cgi-original to mt-config.cgi?' => '構成ファイルがありません。mt-config.cgi-originalファイルの名前ををmt-config.cgiに変え忘れていませんか?',
	'Movable Type default' => 'Movable Type 既定',
	'OpenID' => 'OpenID',
	'Plugin error: [_1] [_2]' => 'プラグインでエラーが発生しました: [_1] [_2]',
	'Powered by [_1]' => 'Powered by [_1]',
	'Two plugins are in conflict' => 'プラグイン同士が競合しています。',
	'TypePad' => 'TypePad',
	'Unnamed plugin' => '(名前なし)',
	'Version [_1]' => 'バージョン [_1]',
	'Vox' => 'Vox',
	'WordPress.com' => 'WordPress.com',
	'Yahoo! JAPAN' => 'Yahoo! JAPAN',
	'Yahoo!' => 'Yahoo!',
	'[_1] died with: [_2]' => '[_1]でエラーが発生しました: [_2]',
	'https://www.movabletype.com/' => 'https://www.sixapart.jp/movabletype/',
	'https://www.movabletype.org/documentation/' => 'https://www.movabletype.jp/documentation/',
	'livedoor' => 'ライブドア',
	q{Loading template '[_1]' failed.} => q{テンプレート「[_1]」のロードに失敗しました。},

## lib/MT/AccessToken.pm
	'AccessToken' => 'アクセストークン',

## lib/MT/App.pm
	'(Display Name not set)' => '(表示名なし)',
	'A user with the same name already exists.' => '同名のユーザーがすでに存在します。',
	'An error occurred while trying to process signup: [_1]' => '登録に失敗しました: [_1]',
	'Back' => '戻る',
	'Cannot load blog #[_1]' => 'ブログ(ID:[_1])をロードできません。',
	'Cannot load blog #[_1].' => 'ブログ(ID:[_1])をロードできません。',
	'Cannot load entry #[_1].' => '記事: [_1]をロードできませんでした。',
	'Cannot load site #[_1].' => 'サイト (ID: [_1])をロードできません。',
	'Close' => '閉じる',
	'Display Name' => '表示名',
	'Email Address is invalid.' => '不正なメールアドレスです。',
	'Email Address is required for password reset.' => 'メールアドレスはパスワードをリセットするために必要です。',
	'Email Address' => '電子メール',
	'Failed login attempt by anonymous user' => '無名のユーザーがサインインしようとしました。',
	'Failed to open pid file [_1]: [_2]' => 'PIDファイル[_1]を開くことができません: [_2]',
	'Failed to send reboot signal: [_1]' => 'プロセス再起動シグナルを送信することができませんでした: [_1]',
	'Internal Error: Login user is not initialized.' => '内部エラー: ユーザーが初期化されていません。',
	'Invalid login.' => 'サインインできませんでした。',
	'Invalid request' => '不正な要求です。',
	'Our apologies, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'ブログまたはウェブサイトへのアクセスが許されていません。エラーでこのページが表示された場合は、システム管理者に問い合わせてください。',
	'Password should be longer than [_1] characters' => 'パスワードは最低[_1]文字以上です。',
	'Password should contain symbols such as #!$%' => 'パスワードは記号を含める必要があります。',
	'Password should include letters and numbers' => 'パスワードは文字と数字を含める必要があります。',
	'Password should include lowercase and uppercase letters' => 'パスワードは大文字と小文字を含める必要があります。',
	'Password should not include your Username' => 'パスワードにユーザー名を含む事は出来ません。',
	'Passwords do not match.' => '入力したパスワードが一致しません。',
	'Problem with this request: corrupt character data for character set [_1]' => '不正な要求です。文字コード[_1]に含まれない文字データを送信しています。',
	'Removed [_1].' => '[_1]を削除しました。',
	'Sorry, but you do not have permission to access any blogs or websites within this installation. If you feel you have reached this message in error, please contact your Movable Type system administrator.' => 'ブログまたはウェブサイトへのアクセスが許されていません。エラーでこのページが表示された場合は、システム管理者に問い合わせてください。',
	'System Email Address is not configured.' => 'システムで利用するメールアドレスが設定されていません。',
	'Text entered was wrong.  Try again.' => '入力された文字列が正しくありません。',
	'The file you uploaded is too large.' => 'アップロードしたファイルは大きすぎます。',
	'The login could not be confirmed because of a database error ([_1])' => 'データベースのエラーが発生したため、サインインできません。: [_1]',
	'This account has been deleted. Please see your Movable Type system administrator for access.' => 'このアカウントは削除されました。システム管理者に問い合わせてください。',
	'This account has been disabled. Please see your Movable Type system administrator for access.' => 'このアカウントは無効にされています。システム管理者に問い合わせてください。',
	'URL is invalid.' => 'URLが不正です。',
	'Unknown action [_1]' => '不明なアクション: [_1]',
	'Unknown error occurred.' => '不明なエラーが発生しました。',
	'User requires display name.' => '表示名は必須です。',
	'User requires password.' => 'パスワードは必須です。',
	'User requires username.' => 'ユーザー名は必須です。',
	'Username' => 'ユーザー名',
	'Warnings and Log Messages' => '警告とメッセージ',
	'You did not have permission for this action.' => '権限がありません。',
	'[_1] contains an invalid character: [_2]' => '[_1]には不正な文字が含まれています: [_2]',
	q{Failed login attempt by deleted user '[_1]'} => q{削除済みのユーザー「[_1]」がサインインしようとしました。},
	q{Failed login attempt by disabled user '[_1]'} => q{無効なユーザー [_1] がサインインしようとしました。},
	q{Failed login attempt by locked-out user '[_1]'} => q{ロックされたユーザー「[_1]」がサインインしようとしました。},
	q{Failed login attempt by pending user '[_1]'} => q{保留中のユーザー「[_1]」がサインインしようとしました。},
	q{Failed login attempt by unknown user '[_1]'} => q{未登録のユーザー [_1] がサインインしようとしました。},
	q{Failed login attempt by user '[_1]'} => q{ユーザー「[_1]」がサインインに失敗しました。},
	q{Failed to open monitoring file that specified by IISFastCGIMonitoringFilePath directive '[_1]': [_2]} => q{IISFastCGIMonitoringFilePath で指定されたモニタリングファイル ([_1]) が開けません: [_2]},
	q{Invalid login attempt from user '[_1]'} => q{'[_1]'がサインインに失敗しました。},
	q{New Comment Added to '[_1]'} => q{'[_1]'にコメントがありました},
	q{User '[_1]' (ID:[_2]) logged in successfully} => q{ユーザー'[_1]'(ID[_2])がサインインしました。},
	q{User '[_1]' (ID:[_2]) logged out} => q{ユーザー'[_1]'(ID[_2])がサインアウトしました。},

## lib/MT/App/ActivityFeeds.pm
	'All "[_1]" Content Data' => 'すべての"[_1]"',
	'All Activity' => 'すべてのログ',
	'All Entries' => 'すべての記事',
	'All Pages' => 'すべてのウェブページ',
	'An error occurred while generating the activity feed: [_1].' => 'ログフィードの生成中にエラーが発生しました: [_1]',
	'Error loading [_1]: [_2]' => '[_1]をロードできませんでした: [_2]',
	'Movable Type Debug Activity' => 'Movable Typeのデバッグログ',
	'Movable Type System Activity' => 'Movable Typeのシステムログ',
	'No permissions.' => '権限がありません。',
	'[_1] "[_2]" Content Data' => '[_1]の"[_2]"',
	'[_1] Activity' => '[_1]のログ',
	'[_1] Entries' => '[_1]の記事',
	'[_1] Pages' => '[_1]のウェブページ',

## lib/MT/App/CMS.pm
	'Activity Log' => 'ログ',
	'Add Contact' => '連絡先の追加',
	'Add IP Address' => 'IPアドレスの追加',
	'Add Tags...' => 'タグの追加',
	'Add a user to this [_1]' => 'この[_1]にユーザーを追加',
	'Add user to group' => 'グループにユーザーを追加',
	'Address Book' => 'アドレス帳',
	'Are you sure you want to delete the selected group(s)?' => '選択されているグループを削除してよろしいですか?',
	'Are you sure you want to remove the selected member(s) from the group?' => '選択されているメンバーをグループから削除してよろしいですか?',
	'Are you sure you want to reset the activity log?' => 'ログを消去してもよろしいですか?',
	'Asset' => 'アセット',
	'Assets' => 'アセット',
	'Associations' => '関連付け',
	'Batch Edit Entries' => '記事の一括編集',
	'Batch Edit Pages' => 'ウェブページの一括編集',
	'Blog' => 'ブログ',
	'Cannot load blog (ID:[_1])' => 'ブログ(ID:[_1])をロードできません',
	'Category Sets' => 'カテゴリセット',
	'Clear Activity Log' => 'ログを消去',
	'Clone Child Site' => 'サイトの複製',
	'Clone Template(s)' => 'テンプレートの複製',
	'Compose' => '投稿',
	'Content Data' => 'コンテンツデータ',
	'Content Types' => 'コンテンツタイプ',
	'Create Role' => '新しいロールを作成',
	'Delete' => '削除',
	'Design' => 'デザイン',
	'Disable' => '無効',
	'Documentation' => 'ドキュメント',
	'Download Address Book (CSV)' => 'アドレス帳をダウンロード(CSV)',
	'Download Log (CSV)' => 'ログをダウンロード(CSV)',
	'Edit Template' => 'テンプレートの編集',
	'Enable' => '有効',
	'Entries' => '記事',
	'Entry' => '記事',
	'Error during publishing: [_1]' => '公開中にエラーが発生しました: [_1]',
	'Export Site' => 'サイトのエクスポート',
	'Export Sites' => 'サイトのエクスポート',
	'Export Theme' => 'テーマのエクスポート',
	'Export' => 'エクスポート',
	'Feedback' => 'コミュニケーション',
	'Feedbacks' => 'コミュニケーション',
	'Filters' => 'フィルタ',
	'Folders' => 'フォルダ',
	'General' => '全般',
	'Grant Permission' => '権限を付与',
	'Groups ([_1])' => 'グループ([_1])',
	'Groups' => 'グループ',
	'IP Banning' => '禁止IPアドレス',
	'Import Sites' => 'サイトのインポート',
	'Import' => 'インポート',
	'Invalid parameter' => '不正なパラメータです。',
	'Manage Members' => 'メンバーの管理',
	'Manage' => '一覧',
	'Movable Type News' => 'Movable Typeニュース',
	'Move child site(s) ' => 'サイトの移動',
	'New' => '新規',
	'No such blog [_1]' => '[_1]というブログはありません。',
	'None' => 'なし',
	'Notification Dashboard' => 'Notification Dashboard',
	'Page' => 'ウェブページ',
	'Permission denied' => '権限がありません。',
	'Permissions' => '権限',
	'Plugins' => 'プラグイン',
	'Profile' => 'ユーザー情報',
	'Publish Template(s)' => 'テンプレートの再構築',
	'Publish' => '公開',
	'Rebuild Trigger' => '再構築トリガー',
	'Rebuild' => '再構築',
	'Recover Password(s)' => 'パスワードの再設定',
	'Refresh Template(s)' => 'テンプレートの初期化',
	'Refresh Templates' => 'テンプレート初期化',
	'Remove Tags...' => 'タグの削除',
	'Remove' => '削除',
	'Revoke Permission' => '権限を削除',
	'Roles' => 'ロール',
	'Search & Replace' => '検索/置換',
	'Settings' => '設定',
	'Sign out' => 'サインアウト',
	'Site List for Mobile' => 'サイトの一覧（モバイル）',
	'Site List' => 'サイトの一覧',
	'Site Stats' => 'サイト情報',
	'Sites' => 'サイト',
	'System Information' => 'システム情報',
	'Tags to add to selected assets' => '追加するタグを入力',
	'Tags to add to selected entries' => '追加するタグを入力',
	'Tags to add to selected pages' => '追加するタグを入力',
	'Tags to remove from selected assets' => '削除するタグを入力',
	'Tags to remove from selected entries' => '削除するタグを入力',
	'Tags to remove from selected pages' => '削除するタグを入力',
	'Themes' => 'テーマ',
	'Tools' => 'ツール',
	'Unknown object type [_1]' => '[_1]というオブジェクトはありません。',
	'Unlock' => 'ロック解除',
	'Unpublish Entries' => '記事の公開を取り消し',
	'Unpublish Pages' => 'ウェブページの公開を取り消し',
	'Updates' => 'アップデート',
	'Upload' => 'アップロード',
	'Use Publishing Profile' => '公開プロファイルを設定',
	'User' => 'ユーザー',
	'View Site' => 'サイトの表示',
	'Web Services' => 'Webサービス',
	'Website' => 'ウェブサイト',
	'_WARNING_DELETE_USER' => 'ユーザーの削除操作は取り消せず、削除したユーザーは復元できません。また、このユーザーが作成した記事やウェブページ、コンテンツデータは作成者不明となります。このユーザーを利用しなくなったり、システムへのアクセスを禁止したい場合は、ユーザーのアカウントを無効にすることをおすすめします。選択したユーザーを削除してよろしいですか?',
	'_WARNING_DELETE_USER_EUM' => 'ユーザーの削除操作は取り消せず、削除したユーザーは復元できません。また、このユーザーが作成した記事やウェブページ、コンテンツデータは作成者不明となります。このユーザーを利用しなくなったり、システムへのアクセスを禁止したい場合は、ユーザーのアカウントを無効にすることをおすすめします。LDAPディレクトリ上に選択したユーザーが残っている場合はアカウントを再作成できますが、削除前の記事などとユーザーを紐づけることはできません。選択したユーザーを削除してよろしいですか?',
	'_WARNING_PASSWORD_RESET_MULTI' => '選択されたユーザーのパスワードを再設定しようとしています。パスワード再設定用のリンクが直接それぞれのメールアドレスに送られます。実行しますか?',
	'_WARNING_REFRESH_TEMPLATES_FOR_BLOGS' => '選択されたサイトのテンプレートを、各サイトの利用しているテーマの初期状態に戻します。テンプレートを初期化してもよろしいですか?',
	'content data' => 'コンテンツデータ',
	'entry' => '記事',
	q{Failed login attempt by user who does not have sign in permission. '[_1]' (ID:[_2])} => q{サインイン権限を有しないユーザー '[_1]' (ID:[_2])がサインインを試みましたが失敗しました。},
	q{[_1]'s Group} => q{[_1]の所属するグループ},

## lib/MT/App/CMS/Common.pm
	'Some websites were not deleted. You need to delete blogs under the website first.' => '削除できないウェブサイトがありました。ウェブサイト内のブログを先に削除する必要があります。',

## lib/MT/App/DataAPI.pm
	'[_1] must be a number.' => '[_1]には数値を指定してください。',
	'[_1] must be an integer and between [_2] and [_3].' => '[_1]は[_2]以上、[_3]以下の整数である必要があります。',

## lib/MT/App/Search.pm
	'Failed to cache search results.  [_1] is not available: [_2]' => '結果をキャッシュできませんでした。[_1]を利用できません: [_2]',
	'Filename extension cannot be asp or php for these archives' => 'ファイル拡張子がaspやphpに設定されているため、指定されてtemplate_idを利用することが出来ません',
	'Invalid [_1] parameter.' => '[_1]パラメータが不正です。',
	'Invalid archive type' => '不正なアーカイブタイプです',
	'Invalid format: [_1]' => '不正なformatです: [_1]',
	'Invalid query: [_1]' => '不正なクエリーです: [_1]',
	'Invalid type: [_1]' => '不正なtypeです: [_1]',
	'Invalid value: [_1]' => '不正な値です: [_1]',
	'No column was specified to search for [_1].' => '[_1]で検索するカラムが指定されていません。',
	'No such template' => 'テンプレートがありません',
	'Output file cannot be of the type asp or php' => 'aspやphpの出力ファイルにはできません',
	'Template must be a main_index for Index archive type' => 'テンプレートはmain_indexでなれければなりません',
	'Template must be archive listing for non-Index archive types' => 'テンプレートはインデックスではないアーカイブリストでなければなりません',
	'The search you conducted has timed out.  Please simplify your query and try again.' => 'タイムアウトしました。お手数ですが検索をやり直してください。',
	'Unsupported type: [_1]' => '[_1]はサポートされていません。',
	'You must pass a valid archive_type with the template_id' => '正しいアーカイブタイプとテンプレートidを指定してください',
	'template_id cannot refer to a global template' => 'template_idにグローバルテンプレートを指定することは出来ません',
	q{No alternate template is specified for template '[_1]'} => q{'[_1]'に対応するテンプレートがありません。},
	q{Opening local file '[_1]' failed: [_2]} => q{'[_1]'を開けませんでした: [_2]},
	q{Search: query for '[_1]'} => q{検索: [_1]},

## lib/MT/App/Search/ContentData.pm
	'Invalid SearchContentTypes "[_1]": [_2]' => '"[_1]" は、不正なコンテンツタイプです: [_2]',
	'Invalid SearchContentTypes: [_1]' => '"[_1]" は、不正なコンテンツタイプです',

## lib/MT/App/Search/TagSearch.pm
	'TagSearch works with MT::App::Search.' => 'TagSearchはMT::App::Searchと一緒に使います。',

## lib/MT/App/Upgrader.pm
	'Both passwords must match.' => 'パスワードが一致しません。',
	'Could not authenticate using the credentials provided: [_1].' => '提供されている手段による認証ができません: [_1]',
	'Invalid session.' => 'セッションが不正です。',
	'Movable Type has been upgraded to version [_1].' => 'Movable Typeをバージョン[_1]にアップグレードしました。',
	'No permissions. Please contact your Movable Type administrator for assistance with upgrading Movable Type.' => '権限がありません。Movable Typeのアップグレードを管理者に依頼してください。',
	'You must supply a password.' => 'パスワードを設定してください。',
	q{Invalid email address '[_1]'} => q{'[_1]'は、メールアドレスのフォーマットが正しくありません},
	q{The 'Website Root' provided below is not allowed} => q{指定された'ウェブサイトパス'は許可されていません。},
	q{The 'Website Root' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click 'Finish Install' again.} => q{'ウェブサイトパス'にウェブサーバーから書き込めません。ウェブサイトパスの書き込み権限を、正しく設定してから再度、インストールボタンをクリックしてください。},

## lib/MT/App/Wizard.pm
	'An error occurred while trying to connect to the database.  Check the settings and try again.' => 'データベースに接続できませんでした。設定を見直してもう一度接続してください。',
	'CGI is required for all Movable Type application functionality.' => 'CGIは、Movable Type のすべてのアプリケーションの動作に必須です。',
	'CGI::Cookie is required for cookie authentication.' => 'CGI::Cookieはcookie 認証のために必要です。',
	'Cache::Memcached and a memcached server are optional. They are used to cache in-memory objects.' => 'Cache::Memcachedやmemcachedサーバはオブジェクトをメモリにキャッシュしておくのに使えます。',
	'DBI is required to work with most supported databases.' => 'DBIはデータベースにアクセスするために必要です。',
	'Digest::SHA is required in order to provide enhanced protection of user passwords.' => 'Digest::SHAはパスワードの高度な保護のために必要です。',
	'Encode is required to handle multibyte characters correctly.' => 'Encodeはマルチバイト文字を適切に扱うのに必要です。',
	'File::Spec is required to work with file system path information on all supported operating systems.' => 'File::Specはオペレーティングシステムでパスの操作を行うために必要です。',
	'File::Temp is optional; It is needed if you would like to be able to overwrite existing files when you upload.' => 'File::Tempのインストールは必須ではありません。ファイルのアップロードを行う際に上書きを行う場合は必要となります。',
	'HTML::Entities is required by CGI.pm' => 'HTML::Entitiesは、CGI.pm の動作に必要です。',
	'IO::Compress::Gzip is required in order to compress files during a backup operation.' => 'IO::Compress::Gzipはバックアップ中にファイルを圧縮するのに必要です。',
	'IO::Uncompress::Gunzip is required in order to decompress files during a restore operation.' => 'IO::Uncompress::Gunzipは復元中にファイルを展開するのに必要です。',
	'IPC::Run is optional; It is needed if you would like to use NetPBM as the image processor for Movable Type.' => 'IPC::Runのインストールは必須ではありません。MTのイメージドライバとしてNetPBMを利用する場合に必要となります。',
	'Image::ExifTool is used to manipulate image metadata.' => 'Image::ExifToolは画像のメタデータを操作するのに使われます。',
	'Image::Size is sometimes required to determine the size of images in different formats.' => 'Image::Sizeはさまざまな形式の画像の大きさを調べるのに必要になることがあります。',
	'JSON is required to use DataAPI, Content Type, and listing framework.' => 'JSONはDataAPIやコンテンツタイプ、リスティングフレームワークの利用に必要です。',
	'JSON::PP is used internally to process JSON by default.' => 'JSON::PPはJSONの処理をする際に内部で通常使われるモジュールです。',
	'JSON::XS accelerates JSON processing.' => 'JSON::XSはJSONの処理を高速化します。',
	'LWP::Protocol::https is optional. It provides https support for LWP::UserAgent.' => 'LWP::Protocol::httpsは、あればLWP::UserAgentのhttps対応に使われます。',
	'LWP::UserAgent is optional. It is used to fetch information from local and external servers.' => 'LWP::UserAgentは、あればローカルおよび外部のサーバーから情報を取得するのに使われます。',
	'LWPx::ParanoidAgent is an alternative to LWP::UserAgent.' => 'LWPx::ParanoidAgentはLWP::UserAgentの代替になるものです。',
	'List::Util is required to manipulate a list of numbers.' => 'List::Utilは数値のリストを操作するのに必要です。',
	'MIME::Base64 is required to send mail and handle blobs during backup/restore operations.' => 'MIME::Base64はメールの送信やバックアップのバイナリオブジェクトを扱うときに必要です。',
	'MIME::Lite is an alternative module to create mail.' => 'MIME::Liteはメール作成の際に使われる代替モジュールのひとつです。',
	'Net::SMTP is required in order to send mail via an SMTP server.' => 'Net::SMTPはSMTPサーバーを通じてメール送信する場合に必要です。',
	'Please select a database from the list of available databases and try again.' => 'データベースのリストからデータベースを選択して、やり直してください。',
	'SMTP Server' => 'SMTPサーバー',
	'Scalar::Util is required to avoid memory leaks.' => 'Scalar::Utilはメモリリークを避けるために必要です。',
	'Sendmail' => 'Sendmail',
	'Storable is required to make deep-copy of complicated data structures.' => 'Storableは複雑なデータ構造をコピーするのに必要です。',
	'Test email from Movable Type Configuration Wizard' => 'Movable Type構成ウィザードからのテスト送信',
	'The [_1] database driver is required to use [_2].' => '[_2]を使うには[_1]のデータベースドライバが必要です。',
	'The [_1] driver is required to use [_2].' => '[_2]を使うには[_1]のドライバが必要です。',
	'This is the test email sent by your new installation of Movable Type.' => 'Movable Typeのインストール中に送信されたテストメールです。',
	'This module and its dependencies are optional. It is an alternative module to create mail.' => 'このモジュールと依存モジュールは標準のメール作成機能を置き換えるのに使えます。',
	'This module and its dependencies are required in order to support CRAM-MD5, DIGEST-MD5 or LOGIN SASL mechanisms.' => 'Authen::SASLとその依存モジュールはCRAM-MD5、DIGEST-MD5又はLOGINをSASLメカニズムとして利用する場合に必要となります。',
	'This module and its dependencies are required to run Movable Type under FastCGI.' => 'FastCGI環境でMovable Typeを実行する場合に必要となります。',
	'This module and its dependencies are required to run Movable Type under psgi.' => 'PSGI環境下でMovable Typeを実行する場合に必要となります。',
	'This module is one of the image processors that you can use to create thumbnails of uploaded images.' => 'アップロードした画像のサムネイルを作成するときに使われる画像処理モジュールのひとつです。',
	'This module is optional. It enhances performance of Authen::SASL.' => 'このモジュールは、あればAuthen::SASLを高速化します。',
	'This module is optional. It is used to allow commenters to be authenticated by OpenID.' => 'このモジュールは、あればOpenID認証の際に使われます。',
	'This module is optional. It is used to customize the logging behavior.' => 'このモジュールは、あればログの挙動をカスタマイズするのに使えます。',
	'This module is optional. It is used to download assets from a website.' => 'このモジュールは、あればウェブサイトからアセットをダウンロードするのに使われます。',
	'This module is optional. It is used to know the encoding of the terminal to log.' => 'このモジュールは、あればログを出力する端末のエンコーディングを調べるのに使われます。',
	'This module is optional. It is used to manipulate files during backup and restore operations.' => 'このモジュールは、あればバックアップ中のファイル操作に使われます。',
	'This module is optional. It is used to manipulate files via FTP(S).' => 'このモジュールは、あればFTP(S)でファイルを操作するのに使われます。',
	'This module is optional. It is used to manipulate files via FTPS.' => 'このモジュールは、あればFTPSでファイルを操作するのに使われます。',
	'This module is optional. It is used to manipulate files via SFTP.' => 'このモジュールは、あればSFTPでファイルを操作するのに使われます。',
	'This module is optional. It is used to manipulate files via WebDAV.' => 'このモジュールは、あればWebDAVでファイルを操作するのに使われます。',
	'This module is optional. It is used to manipulate log files.' => 'このモジュールは、あればログファイルを操作するのに使われます。',
	'This module is optional. It is used to parse date in log files.' => 'このモジュールは、あればログファイルの日時を解釈するのに使われます。',
	'This module is optional. It is used to see if swap memory is enough while processing background jobs.' => 'このモジュールは、あればバックグラウンドジョブの処理中に十分なスワップメモリーがあるか確認するのに使われます。',
	'This module is optional. It is used to see if the disk is full while backing up.' => 'このモジュールは、あればバックアップ中にディスク容量が残っているかを確認するのに使われます。',
	'This module is optional; It is one of the modules required to restore a backup created in a backup/restore operation.' => 'このモジュールは、バックアップを復元するときに必要となるモジュールのひとつです。',
	'This module is required for Google Analytics site statistics and for verification of SSL certificates.' => 'このモジュールは、Google Analytics などで SSL 証明書の検証に必要です。',
	'This module is required for XML-RPC API.' => 'XML-RPC APIを利用するために必要です。',
	'This module is required for profiling.' => 'このモジュールはプロファイリングの際に必要となります。',
	'This module is required in all of the SSL/TLS connection, such as Google Analytics site statistics or SMTP Auth over SSL/TLS.' => 'このモジュールはGoogle AnalyticsやSSL/TLS経由のSMTP認証など、あらゆるSSL/TLS接続の際に必要となります。',
	'This module is required to run background jobs.' => 'このモジュールはバックグラウンドジョブの実行に必要です。',
	'This module is sometimes used to parse URI.' => 'このモジュールはURIのパースに使うことがあります。',
	'This module is used in a test attribute for the MTIf conditional tag.' => 'MT:Ifタグの機能で使われます。',
	'This module is used to make checksums.' => 'このモジュールはチェックサムの作成に使われます。',
	'XML::Atom is required in order to use the Atom API.' => 'XML::AtomはAtom APIを利用する場合に必要となります。',
	'XML::SAX and its dependencies are required to restore a backup created in a backup/restore operation.' => 'XML::SAXは復元の機能を利用する場合に必要となります。',
	'XML::Simple is optional. It is used to parse configuration file of the IIS.' => 'XML::Simpleは、あればIISの設定ファイルを解析するのに使われます。',
	'XML::XPath is required if you want to use the Atom API.' => 'XML::XPathはAtom APIを利用する際に必要となります。',
	'XMLRPC::Lite is optional; It is needed if you want to use the MT XML-RPC server implementation.' => 'XMLRPC::Liteは、XML-RPCサーバーを利用する際に必要となります。',
	'YAML::Syck is optional; It is a better, fast and lightweight alternative to YAML::Tiny for YAML file handling.' => 'YAML::Syckのインストールは必須ではありません。YAML::Tinyよりも、軽量で高速に動作します。',
	'YAML::Tiny is the default YAML parser.' => 'YAML::TinyはデフォルトのYAMLパーサーです。',
	'local::lib is optional. It is used to load modules from different locations.' => 'local::libは、あれば標準とは異なる場所からモジュールを読み込むのに使えます。',

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

## lib/MT/ArchiveType/ContentType.pm
	'CONTENTTYPE_ADV' => 'コンテンツタイプ別',
	'author/author-basename/content-basename.html' => 'author/author-basename/content-basename.html',
	'author/author-basename/content-basename/index.html' => 'author/author-basename/content-basename/index.html',
	'author/author_basename/content_basename.html' => 'author/author_basename/content_basename.html',
	'author/author_basename/content_basename/index.html' => 'author/author_basename/content_basename/index.html',
	'category/sub-category/content-basename.html' => 'category/sub-category/content-basename.html',
	'category/sub-category/content-basename/index.html' => 'category/sub-category/content-basename/index.html',
	'category/sub_category/content_basename.html' => 'category/sub_category/content_basename.html',
	'category/sub_category/content_basename/index.html' => 'category/sub_category/content_basename/index.html',
	'yyyy/mm/content-basename.html' => 'yyyy/mm/content-basename.html',
	'yyyy/mm/content-basename/index.html' => 'yyyy/mm/content-basename/index.html',
	'yyyy/mm/content_basename.html' => 'yyyy/mm/content_basename.html',
	'yyyy/mm/content_basename/index.html' => 'yyyy/mm/content_basename/index.html',
	'yyyy/mm/dd/content-basename.html' => 'yyyy/mm/dd/content-basename.html',
	'yyyy/mm/dd/content-basename/index.html' => 'yyyy/mm/dd/content-basename/index.html',
	'yyyy/mm/dd/content_basename.html' => 'yyyy/mm/dd/content_basename.html',
	'yyyy/mm/dd/content_basename/index.html' => 'yyyy/mm/dd/content_basename/index.html',

## lib/MT/ArchiveType/ContentTypeAuthor.pm
	'CONTENTTYPE-AUTHOR_ADV' => 'コンテンツタイプ ユーザー別',

## lib/MT/ArchiveType/ContentTypeAuthorDaily.pm
	'CONTENTTYPE-AUTHOR-DAILY_ADV' => 'コンテンツタイプ ユーザー 日別',

## lib/MT/ArchiveType/ContentTypeAuthorMonthly.pm
	'CONTENTTYPE-AUTHOR-MONTHLY_ADV' => 'コンテンツタイプ ユーザー 月別',

## lib/MT/ArchiveType/ContentTypeAuthorWeekly.pm
	'CONTENTTYPE-AUTHOR-WEEKLY_ADV' => 'コンテンツタイプ ユーザー 週別',

## lib/MT/ArchiveType/ContentTypeAuthorYearly.pm
	'CONTENTTYPE-AUTHOR-YEARLY_ADV' => 'コンテンツタイプ ユーザー 年別',

## lib/MT/ArchiveType/ContentTypeCategory.pm
	'CONTENTTYPE-CATEGORY_ADV' => 'コンテンツタイプ カテゴリ別',

## lib/MT/ArchiveType/ContentTypeCategoryDaily.pm
	'CONTENTTYPE-CATEGORY-DAILY_ADV' => 'コンテンツタイプ カテゴリ 日別',

## lib/MT/ArchiveType/ContentTypeCategoryMonthly.pm
	'CONTENTTYPE-CATEGORY-MONTHLY_ADV' => 'コンテンツタイプ カテゴリ 月別',

## lib/MT/ArchiveType/ContentTypeCategoryWeekly.pm
	'CONTENTTYPE-CATEGORY-WEEKLY_ADV' => 'コンテンツタイプ カテゴリ 週別',

## lib/MT/ArchiveType/ContentTypeCategoryYearly.pm
	'CONTENTTYPE-CATEGORY-YEARLY_ADV' => 'コンテンツタイプ カテゴリ 年別',

## lib/MT/ArchiveType/ContentTypeDaily.pm
	'CONTENTTYPE-DAILY_ADV' => 'コンテンツタイプ 日別',
	'DAILY_ADV' => '日別',
	'yyyy/mm/dd/index.html' => 'yyyy/mm/dd/index.html',

## lib/MT/ArchiveType/ContentTypeMonthly.pm
	'CONTENTTYPE-MONTHLY_ADV' => 'コンテンツタイプ 月別',
	'MONTHLY_ADV' => '月別',
	'yyyy/mm/index.html' => 'yyyy/mm/index.html',

## lib/MT/ArchiveType/ContentTypeWeekly.pm
	'CONTENTTYPE-WEEKLY_ADV' => 'コンテンツタイプ 週別',
	'WEEKLY_ADV' => '週別',
	'yyyy/mm/day-week/index.html' => 'yyyy/mm/day-week/index.html',

## lib/MT/ArchiveType/ContentTypeYearly.pm
	'CONTENTTYPE-YEARLY_ADV' => 'コンテンツタイプ 年別',
	'YEARLY_ADV' => '年別',
	'yyyy/index.html' => 'yyyy/index.html',

## lib/MT/ArchiveType/Individual.pm
	'INDIVIDUAL_ADV' => '記事',
	'category/sub-category/entry-basename.html' => 'category/sub-category/entry-basename.html',
	'category/sub-category/entry-basename/index.html' => 'category/sub-category/entry-basename/index.html',
	'category/sub_category/entry_basename.html' => 'category/sub_category/entry_basename.html',
	'category/sub_category/entry_basename/index.html' => 'category/sub_category/entry_basename/index.html',
	'yyyy/mm/dd/entry-basename.html' => 'yyyy/mm/dd/entry-basename.html',
	'yyyy/mm/dd/entry-basename/index.html' => 'yyyy/mm/dd/entry-basename/index.html',
	'yyyy/mm/dd/entry_basename.html' => 'yyyy/mm/dd/entry_basename.html',
	'yyyy/mm/dd/entry_basename/index.html' => 'yyyy/mm/dd/entry_basename/index.html',
	'yyyy/mm/entry-basename.html' => 'yyyy/mm/entry-basename.html',
	'yyyy/mm/entry-basename/index.html' => 'yyyy/mm/entry-basename/index.html',
	'yyyy/mm/entry_basename.html' => 'yyyy/mm/entry_basename.html',
	'yyyy/mm/entry_basename/index.html' => 'yyyy/mm/entry_basename/index.html',

## lib/MT/ArchiveType/Page.pm
	'PAGE_ADV' => 'ウェブページ',
	'folder-path/page-basename.html' => 'folder-path/page-basename.html',
	'folder-path/page-basename/index.html' => 'folder-path/page-basename/index.html',
	'folder_path/page_basename.html' => 'folder_path/page_basename.html',
	'folder_path/page_basename/index.html' => 'folder_path/page_basename/index.html',

## lib/MT/Asset.pm
	'Assets of this website' => 'ウェブサイトのアセット',
	'Assets with Extant File' => 'ファイルが存在するアセット',
	'Assets with Missing File' => 'ファイルが存在しないアセット',
	'Audio' => 'オーディオ',
	'Author Status' => '作成者の状態',
	'Content Data ( id: [_1] ) does not exists.' => 'コンテンツデータ (ID:[_1]) が存在しません。',
	'Content Field ( id: [_1] ) does not exists.' => 'コンテンツフィールド (ID:[_1]) が存在しません。',
	'Content Field' => 'コンテンツフィールド',
	'Content type of Content Data ( id: [_1] ) does not exists.' => 'コンテンツデータ (ID:[_1]) のコンテンツタイプが存在しません。',
	'Could not remove asset file [_1] from the filesystem: [_2]' => 'アセットのファイル[_1]をファイルシステム上から削除できませんでした: [_2]',
	'Deleted' => '削除済み',
	'Description' => '説明',
	'Disabled' => '無効',
	'Enabled' => '有効',
	'Except Userpic' => 'プロフィール画像を除外する',
	'File Extension' => 'ファイルの拡張子',
	'File' => 'ファイル',
	'Filename' => 'ファイル名',
	'Image' => '画像',
	'Label' => '名前',
	'Location' => '場所',
	'Missing File' => 'ファイルの存在有無',
	'Name' => '名前',
	'No Label' => '名前がありません。',
	'Pixel Height' => '高さ (px)',
	'Pixel Width' => '幅 (px)',
	'URL' => 'URL',
	'Video' => 'ビデオ',
	'extant' => '存在する',
	'missing' => '存在しない',
	q{Assets in [_1] field of [_2] '[_4]' (ID:[_3])} => q{[_2]のデータ '[_4]' (ID:[_3]) のフィールド '[_1]'にリンクされているアセット},
	q{Could not create asset cache path: [_1]} => q{キャッシュ用のディレクトリ '[_1]' を作成できませんでした。},

## lib/MT/Asset/Audio.pm
	'audio' => 'オーディオ',

## lib/MT/Asset/Image.pm
	'%f-thumb-%wx%h-%i%x' => '%f-thumb-%wx%h-%i%x',
	'Actual Dimensions' => '実サイズ',
	'Cannot load image #[_1]' => 'ID:[_1]の画像をロードできませんでした。',
	'Cropping image failed: Invalid parameter.' => '画像をトリミングできません: 無効なパラメータが指定されました。',
	'Error converting image: [_1]' => '画像を変換できませんでした: [_1]',
	'Error creating thumbnail file: [_1]' => 'サムネイルを作成できませんでした: [_1]',
	'Error cropping image: [_1]' => '画像をトリミングできませんでした: [_1]',
	'Error scaling image: [_1]' => '画像のサイズを変更できませんでした: [_1]',
	'Extracting image metadata failed: [_1]' => 'メタ情報を削除できません: [_1]',
	'Images' => '画像',
	'Popup page for [_1]' => '[_1]のポップアップページ',
	'Rotating image failed: Invalid parameter.' => '画像を回転できません: 無効なパラメータが指定されました。',
	'Scaling image failed: Invalid parameter.' => '画像のサイズを変更できません: 無効なパラメータが指定されました。',
	'Thumbnail image for [_1]' => '[_1]のサムネイル画像',
	'Writing image metadata failed: [_1]' => 'メタ情報の書き出しに失敗しました: [_1]',
	'Writing metadata failed: [_1]' => 'メタ情報の書き出しに失敗しました: [_1]',
	'[_1] x [_2] pixels' => '[_1] x [_2] ピクセル',
	q{Error writing metadata to '[_1]': [_2]} => q{メタ情報を '[_1]' に書き込めません: [_2]},
	q{Error writing to '[_1]': [_2]} => q{'[_1]'に書き込めませんでした: [_2]},
	q{Invalid basename '[_1]'} => q{ファイル名'[_1]'は不正です。},

## lib/MT/Asset/Video.pm
	'Videos' => 'ビデオ',
	'video' => 'ビデオ',

## lib/MT/Association.pm
	'Association' => '関連付け',
	'Group' => 'グループ',
	'Permissions for Groups' => 'グループの権限',
	'Permissions for Users' => 'ユーザーの権限',
	'Permissions for [_1]' => '[_1]の権限',
	'Permissions of group: [_1]' => 'グループ[_1]の権限',
	'Permissions with role: [_1]' => '[_1]の権限',
	'Role Detail' => 'ロールの詳細',
	'Role Name' => 'ロール名',
	'Role' => 'ロール',
	'Site Name' => 'サイト名',
	'User is [_1]' => 'ユーザーが[_1]である',
	'User/Group Name' => 'ユーザー/グループ名',
	'User/Group' => 'ユーザー/グループ',
	'association' => '関連付け',
	'associations' => '関連付け',

## lib/MT/AtomServer.pm
	'Invalid image file format.' => '画像ファイルフォーマットが不正です。',
	'Perl module Image::Size is required to determine the width and height of uploaded images.' => 'Image::Sizeをインストールしないと、画像の幅と高さを検出できません。',
	'PreSave failed [_1]' => 'PreSaveでエラーがありました: [_1]',
	'Removing stats cache failed.' => 'アクセス統計データのキャッシュを削除できませんでした。',
	'[_1]: Entries' => '[_1]: 記事一覧',
	q{'[_1]' is not allowed to upload by system settings.: [_2]} => q{'[_1]'のアップロードはシステム設定にて許可されていません。: [_2]},
	q{Cannot make path '[_1]': [_2]} => q{パス'[_1]'を作成できませんでした: [_2]},
	q{Entry '[_1]' ([lc,_5] #[_2]) deleted by '[_3]' (user #[_4]) from atom api} => q{[_1]記事([lc,_5]#[_2])は[_3](ID: [_4])によって削除されました。},
	q{Invalid blog ID '[_1]'} => q{ブログIDが不正です([_1])。},
	q{User '[_1]' (user #[_2]) added [lc,_4] #[_3]} => q{[_1] (ID: [_2])が[_4] (ID: [_3])を追加しました。},
	q{User '[_1]' (user #[_2]) edited [lc,_4] #[_3]} => q{[_1] (ID: [_2])が[_4] (ID: [_3])を編集しました。},

## lib/MT/Auth.pm
	'Bad AuthenticationModule config' => 'AuthenticationModuleの設定が正しくありません',
	q{Bad AuthenticationModule config '[_1]': [_2]} => q{AuthenticationModule([_1])の設定が正しくありません: [_2]},

## lib/MT/Auth/MT.pm
	'Failed to verify the current password.' => '現在のパスワードを検証できません。',
	'Missing required module' => '必要なモジュールが見つかりません',
	'Password contains invalid character.' => 'パスワードに利用できない文字が含まれています。',

## lib/MT/Author.pm
	'Active' => '有効',
	'Commenters' => 'コメント投稿者',
	'Content Data Count' => 'コンテンツデータ数',
	'Created by' => '作成者',
	'Disabled Users' => '無効なユーザー',
	'Enabled Users' => '有効なユーザー',
	'Locked Out' => 'ロックされている',
	'Locked out Users' => 'アカウントがロックされているユーザー',
	'Lockout' => 'アカウント',
	'MT Native Users' => 'Movable Type認証ユーザー',
	'MT Users' => 'MTユーザー',
	'Not Locked Out' => 'ロックされていない',
	'Pending Users' => '保留中のユーザー',
	'Pending' => '保留中',
	'Privilege' => 'システム権限',
	'Registered User' => '登録済みのユーザー',
	'Status' => 'ステータス',
	'The approval could not be committed: [_1]' => '公開できませんでした: [_1]',
	'User Info' => '詳細情報',
	'Userpic' => 'プロフィール画像',
	'Website URL' => 'ウェブサイトURL',
	'__ENTRY_COUNT' => '記事数',
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## lib/MT/BackupRestore.pm
	'Cannot open [_1].' => '[_1]を開けません。',
	'Copying [_1] to [_2]...' => '[_1]を[_2]にコピーしています...',
	'Exporting [_1] records:' => '[_1]レコードをエクスポートしています:',
	'Failed: ' => '失敗: ',
	'ID for the file was not set.' => 'ファイルにIDが設定されていませんでした。',
	'Importing asset associations ... ( [_1] )' => 'アセットの関連付けを復元しています...( [_1] )',
	'Importing asset associations in entry ... ( [_1] )' => '記事とアセットの関連付けを復元しています ... ( [_1] )',
	'Importing asset associations in page ... ( [_1] )' => 'ウェブページとアセットの関連付けを復元しています ... ( [_1] )',
	'Importing content data ... ( [_1] )' => 'コンテンツデータの関連付けを復元しています ... ( [_1] )',
	'Importing url of the assets ( [_1] )...' => 'アセットのURLを復元しています... ( [_1] )',
	'Importing url of the assets in entry ( [_1] )...' => '記事に含まれるアセットのURLを復元しています... ( [_1] )',
	'Importing url of the assets in page ( [_1] )...' => 'ウェブページに含まれるアセットのURLを復元しています... ( [_1] )',
	'Manifest file [_1] was not a valid Movable Type backup manifest file.' => '[_1]はMovable Typeバックアップで作成された正しいマニフェストファイルではありません。',
	'Manifest file: [_1]' => 'マニフェストファイル: [_1]',
	'No manifest file could be found in your import directory [_1].' => 'importディレクトリ[_1]にマニフェストファイルがありません。',
	'Path was not found for the file, [_1].' => 'ファイル([_1])のパスが見つかりませんでした。',
	'Rebuilding permissions ... ( [_1] )' => '権限を再構築しています... ([_1])',
	'The file ([_1]) was not imported.' => 'ファイル([_1])はインポートされませんでした。',
	'There were no [_1] records to be exported.' => 'エクスポート対象となる[_1]のレコードはありません。',
	'[_1] is not writable.' => '[_1]には書き込めません。',
	'[_1] records exported.' => '[_1]レコードをエクスポートしました。',
	'[_1] records exported...' => '[_1]レコードをエクスポートしました...',
	'failed' => '失敗',
	'ok' => 'OK',
	qq{\nCannot write file. Disk full.} => qq{ファイルの書き込みが出来ません: ディスクの空き容量がありません},
	q{Cannot open directory '[_1]': [_2]} => q{ディレクトリ'[_1]'を開けませんでした: [_2]},
	q{Changing path for the file '[_1]' (ID:[_2])...} => q{ファイル'[_1]' (ID:[_2])のパスを変更しています...},
	q{Error making path '[_1]': [_2]} => q{パス('[_1]')を作成できません: [_2]},

## lib/MT/BackupRestore/BackupFileHandler.pm
	'A user with the same name as the current user ([_1]) was found in the exported file.  Skipping this user record.' => '現在サインインしているユーザー([_1])が見つかりました。このレコードはスキップします。',
	'Importing [_1] records:' => '[_1]をインポートしています:',
	'Invalid serializer version was specified.' => 'シリアライザのバージョンが無効です。',
	'The uploaded exported manifest file was created with Movable Type, but the schema version ([_1]) differs from the one used by this system ([_2]).  You should not import this exported file to this version of Movable Type.' => 'アップロードされたファイルはこのシステムのバージョン([_2])とは異なるバージョン([_1])でエクスポートされています。このファイルを使ってインポートすることはできません。',
	'The uploaded file was not a valid Movable Type exported manifest file.' => 'アップロードされたファイルはMovable Typeで作成されたマニフェストファイルではありません。',
	'[_1] is not a subject to be imported by Movable Type.' => '[_1]はMovable Typeでインポートする対象には含まれていません。',
	'[_1] records imported.' => '[_1]件インポートされました。',
	'[_1] records imported...' => '[_1]件インポートされました...',
	q{A user with the same name '[_1]' was found in the exported file (ID:[_2]).  Import replaced this user with the data from the exported file.} => q{'[_1]': 同名のユーザーが見つかりました(ID: [_2])。エクスポート時のユーザーデータを既存ユーザーのデータで置き換えて、他のデータを復元します。},
	q{Tag '[_1]' exists in the system.} => q{'[_1]'というタグはすでに存在します。},
	q{The role '[_1]' has been renamed to '[_2]' because a role with the same name already exists.} => q{ロール「[_1]」はすでに存在するため、「[_2]」という名前に変わりました。},
	q{The system level settings for plugin '[_1]' already exist.  Skipping this record.} => q{[_1]のシステムのプラグイン設定はすでに存在しています。このレコードはスキップします。},

## lib/MT/BackupRestore/BackupFileScanner.pm
	'Cannot import requested file because a site was not found in either the existing Movable Type system or the exported data. A site must be created first.' => 'サイトのデータが含まれていないため、このファイルをインポートすることができません。サイトを先に作成してください。',
	'Cannot import requested file because doing so requires the Digest::SHA Perl module. Please contact your Movable Type system administrator.' => 'Digest::SHAがインストールされていないため、このファイルをインポートすることができません。システム管理者に問い合わせてください。',

## lib/MT/BasicAuthor.pm
	'authors' => 'ユーザー',

## lib/MT/Blog.pm
	'*Site/Child Site deleted*' => '*削除されました*',
	'Child Sites' => '子サイト',
	'Clone of [_1]' => '[_1]の複製',
	'Cloned child site... new id is [_1].' => 'サイトを複製しました。新しいIDは [_1] です。',
	'Cloning associations for blog:' => '関連付けを複製しています:',
	'Cloning categories for blog...' => 'カテゴリを複製しています...',
	'Cloning entries and pages for blog...' => '記事とウェブページを複製しています',
	'Cloning entry placements for blog...' => '記事とカテゴリの関連付けを複製しています...',
	'Cloning entry tags for blog...' => 'タグを複製しています...',
	'Cloning permissions for blog:' => '権限を複製しています:',
	'Cloning template maps for blog...' => 'テンプレートマップを複製しています...',
	'Cloning templates for blog...' => 'テンプレートを複製しています...',
	'Content Type Count' => 'コンテンツタイプ数',
	'Content Type' => 'コンテンツタイプ',
	'Failed to apply theme [_1]: [_2]' => '[_1]テーマの適用に失敗しました: [_2]',
	'Failed to load theme [_1]: [_2]' => '[_1]テーマの読込に失敗しました: [_2]',
	'First Blog' => 'First Blog',
	'No default templates were found.' => 'デフォルトテンプレートが見つかりませんでした。',
	'Parent Site' => '親サイト',
	'Theme' => 'テーマ',
	'__ASSET_COUNT' => 'アセット数',
	'__INTEGER_FILTER_EQUAL' => 'である',
	'__INTEGER_FILTER_NOT_EQUAL' => 'ではない',
	'__PAGE_COUNT' => 'ウェブページ数',
	q{Invalid archive_type '[_1]' in Archive Mapping '[_2]'} => q{アーカイブマッピング'[_2]'の'[_1]'は無効なアーカイブタイプです},
	q{Invalid category_field '[_1]' in Archive Mapping '[_2]'} => q{アーカイブマッピング'[_2]'の'[_1]'は無効なカテゴリフィールドです},
	q{Invalid datetime_field '[_1]' in Archive Mapping '[_2]'} => q{アーカイブマッピング'[_2]'の'[_1]'は無効な日付と時刻フィールドです},
	q{archive_type is needed in Archive Mapping '[_1]'} => q{アーカイブマッピング '[_1]' にはアーカイブタイプが必要です},
	q{category_field is required in Archive Mapping '[_1]'} => q{アーカイブマッピング '[_1]' にはカテゴリフィールドが必要です},

## lib/MT/Bootstrap.pm
	'Got an error: [_1]' => 'エラーが発生しました: [_1]',

## lib/MT/Builder.pm
	'<[_1]> at line [_2] is unrecognized.' => '<[_1]>は存在しません([_2]行目)。',
	'<[_1]> with no </[_1]> on line #' => '<[_1]>に対応する</[_1]>がありません。',
	'<[_1]> with no </[_1]> on line [_2]' => '<[_1]>に対応する</[_1]>がありません([_2]行目)。',
	'<[_1]> with no </[_1]> on line [_2].' => '<[_1]>に対応する</[_1]>がありません([_2]行目)。',
	'Error in <mt[_1]> tag: [_2]' => '<mt[_1]>タグでエラーがありました: [_2]',
	'Unknown tag found: [_1]' => '不明なタグです: [_1]',

## lib/MT/CMS/AddressBook.pm
	'Error sending mail ([_1]): Try another MailTransfer setting?' => 'メールを送信できませんでした。MailTransferの設定を見直してください: [_1]',
	'No entry ID was provided' => '記事のIDが指定されていません。',
	'No valid recipients were found for the entry notification.' => '通知するメールアドレスがありません。',
	'Please select a blog.' => 'ブログを選択してください。',
	'The e-mail address you entered is already on the Notification List for this blog.' => '入力したメールアドレスはすでに通知リストに含まれています。',
	'The text you entered is not a valid URL.' => 'URLが不正です。',
	'The text you entered is not a valid email address.' => 'メールアドレスが不正です。',
	'[_1] Update: [_2]' => '更新通知: [_1] - [_2]',
	q{No such entry '[_1]'} => q{「[_1]」という記事は存在しません。},
	q{Subscriber '[_1]' (ID:[_2]) deleted from address book by '[_3]'} => q{'[_3]'がアドレス帳から'[_1]'(ID:[_2])を削除しました。},

## lib/MT/CMS/Asset.pm
	'(user deleted)' => '(削除されました)',
	'<[_1] Root>' => '<[_1]パス>',
	'<[_1] Root>/[_2]' => '<[_1]パス>/[_2]',
	'Archive' => 'アーカイブ',
	'Cannot load asset #[_1]' => 'アセット(ID:[_1])をロードできませんでした',
	'Cannot load asset #[_1].' => 'アセット(ID:[_1])をロードできませんでした。',
	'Cannot load file #[_1].' => 'ID:[_1]のファイルをロードできません。',
	'Cannot overwrite an existing file with a file of a different type. Original: [_1] Uploaded: [_2]' => '違うアセットの種類での上書きはできません。 元のファイル:[_1] アップロードされたファイル[_2]',
	'Custom...' => 'カスタム...',
	'Extension changed from [_1] to [_2]' => '拡張子が[_1]から[_2]に変更されました',
	'Failed to create thumbnail file because [_1] could not handle this image type.' => 'サムネイルの作成ができませんでした。[_1]がサポートしていない画像形式です。',
	'Files' => 'ファイル',
	'Invalid Request.' => '不正な要求です。',
	'Movable Type was unable to write to the "Upload Destination". Please make sure that the webserver can write to this folder.' => 'アップロード先のディレクトリに書き込みできません。ウェブサーバーから書き込みできるパーミッションを与えてください。',
	'No permissions' => '権限がありません。',
	'Please select a video to upload.' => 'アップロードするビデオファイルを選択してください。',
	'Please select an audio file to upload.' => 'アップロードするオーディオファイルを選択してください。',
	'Please select an image to upload.' => 'アップロードする画像を選択してください。',
	'Saving object failed: [_1]' => 'オブジェクトを保存できませんでした: [_1]',
	'Transforming image failed: [_1]' => '画像の編集結果を保存できませんでした: [_1]',
	'Untitled' => 'タイトルなし',
	'Upload Asset' => 'アセットのアップロード',
	'Uploaded file is not an image.' => 'アップロードしたファイルは画像ではありません。',
	'basename of user' => 'ユーザーのベースネーム',
	'none' => 'なし',
	'unassigned' => '(未設定)',
	q{Could not create upload path '[_1]': [_2]} => q{[_1]を作成できませんでした: [_2]},
	q{Error creating a temporary file; The webserver should be able to write to this folder.  Please check the TempDir setting in your configuration file, it is currently '[_1]'. } => q{テンポラリファイルを作成できませんでした。構成ファイルでTempDirの設定を確認してください。現在は[_1]に設定されています。},
	q{Error deleting '[_1]': [_2]} => q{'[_1]'を削除できませんでした: [_2]},
	q{Error opening '[_1]': [_2]} => q{'[_1]'を開けませんでした: [_2]},
	q{Error writing upload to '[_1]': [_2]} => q{アップロードされたファイルを[_1]に書き込めませんでした: [_2]},
	q{File '[_1]' (ID:[_2]) deleted by '[_3]'} => q{'[_3]'がファイル'[_1]'(ID:[_2])を削除しました。},
	q{File '[_1]' uploaded by '[_2]'} => q{'[_2]'がファイル'[_1]'をアップロードしました。},
	q{File with name '[_1]' already exists. (Install the File::Temp Perl module if you would like to be able to overwrite existing uploaded files.)} => q{'[_1]'という名前のファイルが既に存在します。既存のファイルを上書きしたい場合はFile::Tempをインストールしてください。},
	q{File with name '[_1]' already exists. Upload has been cancelled.} => q{'[_1]'という名前のファイルが既に存在します。アップロードはキャンセルされました。},
	q{File with name '[_1]' already exists.} => q{'[_1]'という名前のファイルが既に存在します。},
	q{File with name '[_1]' already exists; Tried to write to a tempfile, but the webserver could not open it: [_2]} => q{'[_1]'という名前のファイルが既に存在します。テンポラリファイルに書き込むこともできませんでした: [_2]},
	q{Invalid upload path '[_1]'} => q{アップロード先'[_1]'が不正です。},
	q{Invalid filename '[_1]'} => q{ファイル名'[_1]'が不正です。},
	q{Invalid temp file name '[_1]'} => q{テンポラリファイルの名前'[_1]'が不正です。},

## lib/MT/CMS/Blog.pm
	'(no name)' => '(無名)',
	'Archive URL must be an absolute URL.' => 'アーカイブURLは絶対URLでなければなりません。',
	'Blog Root' => 'ブログパス',
	'Cannot load content data #[_1].' => 'コンテンツデータ (ID: [_1]) をロードできませんでした・',
	'Cannot load template #[_1].' => 'テンプレート (ID: [_1]) をロードできませんでした。',
	'Compose Settings' => '投稿設定',
	'Create Child Site' => '子サイトの作成',
	'Enter a site name to filter the choices below.' => 'サイト名を入力して絞り込み',
	'Entries must be cloned if comments and trackbacks are cloned' => 'コメントやトラックバックの複製により、記事も複製されます。',
	'Entries must be cloned if comments are cloned' => 'コメントの複製により、記事も複製されます。',
	'Entries must be cloned if trackbacks are cloned' => 'トラックバックの複製により、記事も複製されます。',
	'Error' => 'エラー',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your blog directory.' => 'テンプレートをキャッシュするディレクトリに書き込めません。サイトパスの下にある<code>[_1]</code>ディレクトリのパーミッションを確認してください。',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your blog directory.' => 'テンプレートをキャッシュするディレクトリを作成できません。サイトパスの下に<code>[_1]</code>ディレクトリを作成してください。',
	'Feedback Settings' => 'コミュニケーション設定',
	'Finished!' => '完了しました。',
	'General Settings' => '全般設定',
	'Invalid blog_id' => '不正なブログID',
	'No blog was selected to clone.' => '複製するブログが選択されていません。',
	'Please choose a preferred archive type.' => '優先アーカイブタイプを指定してください',
	'Plugin Settings' => 'プラグイン設定',
	'Publish Site' => 'サイトを再構築',
	'Registration Settings' => '登録/認証の設定',
	'Saved [_1] Changes' => '[_1]の変更が保存されました',
	'Saving blog failed: [_1]' => 'ブログを保存できませんでした: [_1]',
	'Select Child Site' => '子サイトを選択',
	'Selected Child Site' => '選択された子サイト',
	'Site URL must be an absolute URL.' => 'サイトURLは絶対URLでなければなりません。',
	'The number of revisions to store must be a positive integer.' => '更新履歴番号は整数でなければなりません。',
	'These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.' => 'MTの設定ファイルによって設定されている値([_1])が優先されます。このページで設定した値を利用するためには、設定ファイルでの設定を削除してください。',
	'This action can only be run on a single blog at a time.' => 'このアクションは同時に1つのブログでしか実行できません。',
	'This action cannot clone website.' => 'このアクションではウェブサイトの複製はできません',
	'Website Root' => 'ウェブサイトパス',
	'You did not specify a blog name.' => 'ブログの名前を指定してください。',
	'You did not specify an Archive Root.' => 'アーカイブパスを指定していません。',
	'[_1] (ID:[_2])' => '[_1] (ID:[_2])',
	'[_1] changed from [_2] to [_3]' => '[_1]は[_2]から[_3]に変更されました',
	q{'[_1]' (ID:[_2]) has been copied as '[_3]' (ID:[_4]) by '[_5]' (ID:[_6]).} => q{'[_1]' (ID:[_2]) が '[_3]' (ID:[_4]) として '[_5]' (ID: [_6]) によって複製されました。},
	q{Blog '[_1]' (ID:[_2]) deleted by '[_3]'} => q{'[_3]'がブログ'[_1]'(ID:[_2])を削除しました。},
	q{Cloning child site '[_1]'...} => q{サイト「[_1]」を複製しています...},
	q{The '[_1]' provided below is not writable by the web server. Change the directory ownership or permissions and try again.} => q{ウェブサーバーから書き込めません。[_1]の書き込み権限を確認してから、もう一度実行してください。},
	q{[_1] '[_2]' (ID:[_3]) created by '[_4]'} => q{[_4]によって[_1]の「[_2]」(ID:[_3])が作成されました},
	q{[_1] '[_2]'} => q{[_1]「[_2]」},
	q{index template '[_1]'} => q{インデックステンプレート「[_1]」},

## lib/MT/CMS/Category.pm
	'Category Set' => 'カテゴリセット',
	'Create Category Set' => 'カテゴリセットの作成',
	'Create [_1]' => '新しい[_1]',
	'Edit [_1]' => '[_1]の編集',
	'Failed to update [_1]: Some of [_2] were changed after you opened this page.' => 'いくつかの[_2]がすでに更新されていたため、[_1]の更新に失敗しました。',
	'Invalid category_set_id: [_1]' => '無効なカテゴリセットIDです: [_1]',
	'Manage [_1]' => '[_1]の管理',
	'The [_1] must be given a name!' => '[_1]には名前が必要です。',
	'Tried to update [_1]([_2]), but the object was not found.' => '[_1]([_2])が見つからないため、更新ができません。',
	'Your changes have been made (added [_1], edited [_2] and deleted [_3]). <a href="#" onclick="[_4]" class="mt-rebuild">Publish your site</a> to see these changes take effect.' => '変更を保存しました。(追加:[_1]件, 更新:[_2]件, 削除:[_3]件) 変更を有効にするには<a href="#" onclick="[_4]" class="mt-rebuild">再構築</a>をしてください。',
	'category_set' => 'カテゴリセット',
	q{Category '[_1]' (ID:[_2]) deleted by '[_3]'} => q{'[_3]'がカテゴリ'[_1]'(ID:[_2])を削除しました。},
	q{Category '[_1]' (ID:[_2]) edited by '[_3]'} => q{'[_3]'がカテゴリ'[_1]' (ID:[_2])を編集しました。},
	q{Category '[_1]' created by '[_2]'.} => q{'[_2]'がカテゴリ'[_1]'を作成しました。},
	q{Category Set '[_1]' (ID:[_2]) edited by '[_3]'} => q{'[_3]'がカテゴリセット'[_1]' (ID:[_2])を編集しました。},
	q{Category Set '[_1]' created by '[_2]'.} => q{'[_2]'がカテゴリセット'[_1]'を作成しました。},
	q{The category basename '[_1]' conflicts with the basename of another category. Top-level categories and sub-categories with the same parent must have unique basenames.} => q{'[_1]'は他のカテゴリと衝突しています。同じ階層にあるカテゴリのベースネームは一意でなければなりません。},
	q{The category name '[_1]' conflicts with another category. Top-level categories and sub-categories with the same parent must have unique names.} => q{'[_1]'は他のカテゴリと衝突しています。同じ階層にあるカテゴリの名前は一意でなければなりません。},
	q{The category name '[_1]' conflicts with the name of another category. Top-level categories and sub-categories with the same parent must have unique names.} => q{'[_1]'は他のカテゴリと衝突しています。同じ階層にあるカテゴリの名前は一意でなければなりません。},
	q{The name '[_1]' is too long!} => q{'[_1]'は長すぎます。},
	q{[_1] order has been edited by '[_2]'.} => q{[_1] の順番を '[_2]' が更新しました。},

## lib/MT/CMS/CategorySet.pm
	q{Category Set '[_1]' (ID:[_2]) deleted by '[_3]'} => q{'[_3]'がカテゴリセット'[_1]'(ID:[_2])を削除しました。},

## lib/MT/CMS/Common.pm
	'All [_1]' => 'すべての[_1]',
	'An error occurred while counting objects: [_1]' => 'オブジェクトのカウント中にエラーが発生しました: [_1]',
	'An error occurred while loading objects: [_1]' => 'オブジェクトのロード中にエラーが発生しました: [_1]',
	'Error occurred during permission check: [_1]' => '権限チェックの実行中にエラーが発生しました: [_1]',
	'Invalid ID [_1]' => 'ID [_1]は不正です。',
	'Invalid filter terms: [_1]' => '不正なフィルタ条件です: [_1]',
	'Invalid filter: [_1]' => '無効なフィルターです: [_1]',
	'Invalid type [_1]' => 'type [_1]は不正です。',
	'New Filter' => '新しいフィルタ',
	'Removing tag failed: [_1]' => 'タグを削除できませんでした: [_1]',
	'Saving snapshot failed: [_1]' => 'スナップショットの保存に失敗しました: [_1]',
	'System templates cannot be deleted.' => 'システムテンプレートは削除できません。',
	'The Template Name and Output File fields are required.' => 'テンプレートの名前と出力ファイル名は必須です。',
	'The blog root directory must be within [_1].' => 'ブログパスは、[_1]以下のディレクトリを指定してください。',
	'The selected [_1] has been deleted from the database.' => '選択された[_1]をデータベースから削除しました。',
	'The website root directory must be within [_1].' => 'ウェブサイトパスは、[_1]以下のディレクトリを指定してください。',
	'Unknown list type' => '不明なタイプです。',
	'Web Services Settings' => 'Webサービス設定',
	'[_1] Feed' => '[_1]のフィード',
	'[_1] broken revisions of [_2](id:[_3]) are removed.' => '[_2](id:[_3])の壊れたリビジョン[_1]件が削除されました。',
	'__SELECT_FILTER_VERB' => 'が',
	q{'[_1]' edited the global template '[_2]'} => q{[_1]がグローバルテンプレート([_2])を編集しました},
	q{'[_1]' edited the template '[_2]' in the blog '[_3]'} => q{[_1]がブログ([_3])のテンプレート([_2])を編集しました},

## lib/MT/CMS/ContentData.pm
	'(No Label)' => '(ラベルなし)',
	'(untitled)' => 'タイトルなし',
	'Cannot load content field (UniqueID:[_1]).' => 'コンテンツフィールドをロードできません (ユニークID: [_1])',
	'Cannot load content_type #[_1]' => 'コンテンツタイプ (ID: [_1]) をロードできません',
	'Create new [_1]' => '[_1]を作成',
	'Need a status to update content data' => 'コンテンツデータのステータスを指定する必要があります',
	'Need content data to update status' => 'ステータスを更新するコンテンツデータを指定する必要があります',
	'New [_1]' => '新しい[_1]',
	'No Label (ID:[_1])' => 'ラベルがありません (ID:[_1])',
	'One of the content data ([_1]) did not exist' => 'コンテンツデータ (ID: [_1]) が見つかりません',
	'Publish error: [_1]' => '再構築エラー: [_1]',
	'The value of [_1] is automatically used as a data label.' => '[_1]の値がデータ識別ラベルとして利用されます',
	'Unable to create preview files in this location: [_1]' => 'プレビュー用のファイルをこの場所に作成できませんでした: [_1]',
	'Unpublish Contents' => 'コンテンツデータの公開を取り消し',
	'Your blog has not been configured with a site path and URL. You cannot publish entries until these are defined.' => 'サイトパスとサイトURLを設定していません。設定するまで公開できません。',
	'[_1] (ID:[_2]) status changed from [_3] to [_4]' => '[_1] (ID:[_2])の公開状態を[_3]から[_4]に変更しました',
	q{Invalid date '[_1]'; 'Published on' dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{公開日: '[_1]'は不正な日付です。YYYY-MM-DD HH:MM:SSの形式で入力してください。},
	q{Invalid date '[_1]'; 'Unpublished on' dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{公開終了日: '[_1]'は不正な日付です。YYYY-MM-DD HH:MM:SSの形式で入力してください。},
	q{Invalid date '[_1]'; 'Unpublished on' dates should be dates in the future.} => q{公開終了日: '[_1]'は不正な日付です。未来の日時を指定してください。},
	q{Invalid date '[_1]'; 'Unpublished on' dates should be later than the corresponding 'Published on' date.} => q{公開終了日: '[_1]'は不正な日付です。公開日より未来の日時を指定してください。},
	q{New [_1] '[_4]' (ID:[_2]) added by user '[_3]'} => q{[_3]が新しい[_1] '[_4]' (ID[_2])を追加しました},
	q{[_1] '[_4]' (ID:[_2]) deleted by '[_3]'} => q{[_3]が[_1] '[_4]' (ID:[_2])を削除しました},
	q{[_1] '[_4]' (ID:[_2]) edited by user '[_3]'} => q{[_3]が[_1] '[_4]' (ID:[_2])を変更しました},
	q{[_1] '[_6]' (ID:[_2]) edited and its status changed from [_3] to [_4] by user '[_5]'} => q{[_5]が[_1] '[_6]' (ID:[_2]) の公開状態を[_3]から[_4]に変更しました},

## lib/MT/CMS/ContentType.pm
	'Cannot load content field data (ID: [_1])' => 'コンテンツフィールド (ID: [_1]) をロードできません',
	'Cannot load content type #[_1]' => 'コンテンツタイプ (ID: [_1]) をロードできません',
	'Content Type Boilerplates' => 'コンテンツタイプのひな形',
	'Create Content Type' => 'コンテンツタイプの作成',
	'Create new content type' => '新しいコンテンツタイプの作成',
	'Manage Content Type Boilerplates' => 'コンテンツタイプのひな形の管理',
	'Saving content field failed: [_1]' => 'コンテンツフィールドを保存できません: [_1]',
	'Saving content type failed: [_1]' => 'コンテンツタイプを保存できません: [_1]',
	'Some content fields were deleted: ([_1])' => 'いくつかのコンテンツフィールドが削除されました: [_1]',
	'The content type name is required.' => 'コンテンツタイプ名は必須です。',
	'The content type name must be shorter than 255 characters.' => 'コンテンツタイプ名は255文字までです。',
	'content_type' => 'コンテンツタイプ',
	q{A content field '[_1]' ([_2]) was added} => q{コンテンツフィールド '[_1]' ([_2]) が追加されました},
	q{A content field options of '[_1]' ([_2]) was changed} => q{コンテンツフィールド '[_1]' ([_2]) の設定が変更されました},
	q{A description for content field of '[_1]' should be shorter than 255 characters.} => q{コンテンツフィールド '[_1]'の説明は255文字までです。},
	q{A label for content field of '[_1]' is required.} => q{コンテンツフィールド '[_1]'のラベルが入力されていません。},
	q{A label for content field of '[_1]' should be shorter than 255 characters.} => q{コンテンツフィールド '[_1]'のラベルは255文字までです。},
	q{Content Type '[_1]' (ID:[_2]) added by user '[_3]'} => q{[_3]がコンテンツタイプ '[_1]' (ID: [_2]) を追加しました},
	q{Content Type '[_1]' (ID:[_2]) deleted by '[_3]'} => q{[_3]がコンテンツタイプ '[_1]' (ID: [_2])を削除しました},
	q{Content Type '[_1]' (ID:[_2]) edited by user '[_3]'} => q{[_3]がコンテンツタイプ '[_1]' (ID: [_2]) を変更しました},
	q{Field '[_1]' and '[_2]' must not coexist within the same content type.} => q{コンテンツフィールド'[_1]'と'[_2]'を同じコンテンツタイプ内で同時に利用することはできません},
	q{Field '[_1]' must be unique in this content type.} => q{コンテンツフィールド'[_1]'が重複しています},
	q{Name '[_1]' is already used.} => q{'[_1]'はすでに存在します},

## lib/MT/CMS/Dashboard.pm
	'An image processing toolkit, often specified by the ImageDriver configuration directive, is not present on your server or is configured incorrectly. A toolkit must be installed to ensure proper operation of the userpics feature. Please install Graphics::Magick, Image::Magick, NetPBM, GD, or Imager, then set the ImageDriver configuration directive accordingly.' => 'ImageDriverに設定された画像処理ツールが存在しないかまたは正しく設定されていないため、Movable Typeのユーザー画像機能を利用できません。この機能を利用するには、Graphics::Magick、Image::Magick、NetPBM、GD、Imagerのいずれかをインストールする必要があります。',
	'Can verify SSL certificate, but verification is disabled.' => 'SSL 証明書の検証を行う準備ができていますが、環境変数で SSL 証明書の検証が無効に設定されています。',
	'Cannot verify SSL certificate.' => 'SSL 証明書の検証ができません。',
	'Error: This child site does not have a parent site.' => '親サイトが存在しません。',
	'ImageDriver is not configured.' => 'イメージドライバーが設定されていません。',
	'Not configured' => '未設定',
	'Page Views' => 'ページビュー',
	'Please contact your Movable Type system administrator.' => 'システム管理者に問い合わせてください。',
	'Please install Mozilla::CA module. Writing "SSLVerifyNone 1" in mt-config.cgi can hide this warning, but this is not recommended.' => 'このメッセージを消すには、Mozilla::CA モジュールをインストールするか、mt-config.cgi に "SSLVerifyNone 1" を指定してください。',
	'System' => 'システム',
	'The support directory is not writable.' => 'サポートディレクトリに書き込めません。',
	'Unknown Content Type' => '不明なコンテンツタイプ',
	'You should remove "SSLVerifyNone 1" in mt-config.cgi.' => 'SSLVerifyNone 環境変数の指定を mt-config.cgi から削除してください。',
	q{Movable Type was unable to write to its 'support' directory. Please create a directory at this location: [_1], and assign permissions that will allow the web server write access to it.} => q{サポートディレクトリに書き込みできません。[_1]にディレクトリを作成して、ウェブサーバーから書き込みできるパーミッションを与えてください。},
	q{The System Email Address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events. Please confirm your <a href="[_1]">settings.</a>} => q{このメールアドレスはMovable Typeから送られるメールの'From:'アドレスに利用されます。メールはパスワードの再設定、コメント投稿者の登録、コメントやトラックバックの通知、ユーザーまたはIPアドレスのロックアウト、その他の場合に送信されます。<a href="[_1]">設定</a>を確認してください。},

## lib/MT/CMS/Entry.pm
	'(user deleted - ID:[_1])' => '(削除されたユーザー - ID:[_1])',
	'/' => '/',
	'Need a status to update entries' => '記事を更新するにはまず公開状態を設定してください。',
	'Need entries to update status' => '公開状態を設定するには記事が必要です。',
	'New Entry' => '記事を作成',
	'New Page' => 'ページを作成',
	'No such [_1].' => '[_1]が存在しません。',
	'One of the entries ([_1]) did not exist' => '記事(ID:[_1])は存在しませんでした。',
	'Removing placement failed: [_1]' => '記事とカテゴリの関連付けを削除できませんでした: [_1]',
	'Saving placement failed: [_1]' => '記事とカテゴリの関連付けを設定できませんでした: [_1]',
	'This basename has already been used. You should use an unique basename.' => 'ファイル名はすでに使用されています。一意の名前を指定してください。',
	'authored on' => '公開日',
	'modified on' => '更新日',
	q{<a href="[_1]">QuickPost to [_2]</a> - Drag this bookmarklet to your browser's toolbar, then click it when you are visiting a site that you want to blog about.} => q{<a href="[_1]">クイック投稿</a>: このリンクをブラウザのツールバーにドラッグし、興味のあるウェブページでクリックすると、ブログへ簡単に投稿できます。},
	q{Invalid date '[_1]'; 'Published on' dates should be earlier than the corresponding 'Unpublished on' date '[_2]'.} => q{公開日: '[_1]'は、公開終了日: '[_2]'より前の日時を指定してください},
	q{Invalid date '[_1]'; [_2] dates must be in the format YYYY-MM-DD HH:MM:SS.} => q{[_2]: '[_1]'は不正な日付です。YYYY-MM-DD HH:MM:SSの形式で入力してください。},
	q{Saving entry '[_1]' failed: [_2]} => q{記事「[_1]」を保存できませんでした: [_2]},
	q{[_1] '[_2]' (ID:[_3]) edited and its status changed from [_4] to [_5] by user '[_6]'} => q{[_6]が[_1]「[_2]」(ID:[_3])を更新し、公開の状態を[_4]から[_5]に変更しました。},
	q{[_1] '[_2]' (ID:[_3]) edited by user '[_4]'} => q{[_4]が[_1]「[_2]」(ID:[_3])を更新しました。},
	q{[_1] '[_2]' (ID:[_3]) status changed from [_4] to [_5]} => q{[_1]「[_2] (ID:[_3])」の公開状態が[_4]から[_5]に変更されました。},

## lib/MT/CMS/Export.pm
	'Export Site Entries' => '記事のエクスポート',
	'Please select a site.' => 'サイトを選択してください。',
	'You do not have export permissions' => 'エクスポートする権限がありません。',
	q{Loading site '[_1]' failed: [_2]} => q{サイト '[_1]' をロードできません: [_2]},

## lib/MT/CMS/Filter.pm
	'(Legacy) ' => '(レガシー)',
	'Failed to delete filter(s): [_1]' => 'フィルタの削除に失敗しました:[_1]',
	'Failed to save filter:  Label "[_1]" is duplicated.' => 'フィルタの保存に失敗しました。[_1]というフィルタは既に存在します。',
	'Failed to save filter: Label is required.' => 'フィルタの保存に失敗しました。ラベルは必須です。',
	'Failed to save filter: [_1]' => 'フィルタの保存に失敗しました:[_1]',
	'No such filter' => 'フィルタが見つかりません。',
	'Removed [_1] filters successfully.' => '[_1]件のフィルタを削除しました。',
	'[_1] ( created by [_2] )' => '作成:[_2] - [_1]',

## lib/MT/CMS/Folder.pm
	q{Folder '[_1]' (ID:[_2]) deleted by '[_3]'} => q{'[_3]'がフォルダ'[_1]'(ID:[_2])を削除しました。},
	q{Folder '[_1]' (ID:[_2]) edited by '[_3]'} => q{'[_3]'がフォルダ'[_1]'(ID:[_2])を編集しました。},
	q{Folder '[_1]' created by '[_2]'} => q{'[_2]'がフォルダ'[_1]'を作成しました。},
	q{The folder '[_1]' conflicts with another folder. Folders with the same parent must have unique basenames.} => q{'[_1]'は他のフォルダと衝突しています。同じ階層にあるフォルダの名前(ベースネーム)は一意でなければなりません。},

## lib/MT/CMS/Group.pm
	'Add Users to Groups' => 'グループにユーザーを追加',
	'Author load failed: [_1]' => 'ユーザーをロードできませんでした: [_1]',
	'Create Group' => 'グループの作成',
	'Each group must have a name.' => 'グループには名前が必要です。',
	'Group Name' => 'グループ名',
	'Group load failed: [_1]' => 'グループのロードに失敗しました: [_1]',
	'Groups Selected' => '選択されたグループ',
	'Search Groups' => 'グループを検索',
	'Search Users' => 'ユーザーを検索',
	'Select Groups' => 'グループを選択',
	'Select Users' => 'ユーザーを選択',
	'User load failed: [_1]' => 'ユーザーをロードできませんでした: [_1]',
	'Users Selected' => '選択されたユーザー',
	q{Group '[_1]' (ID:[_2]) deleted by '[_3]'} => q{[_3]がグループ「[_1]」(ID:[_2]) を削除しました。},
	q{Group '[_1]' (ID:[_2]) edited by '[_3]'} => q{[_3]がグループ「[_1]」(ID:[_2])を編集しました。},
	q{Group '[_1]' created by '[_2]'.} => q{[_2]がグループ「[_1]」を作成しました。},
	q{User '[_1]' (ID:[_2]) removed from group '[_3]' (ID:[_4]) by '[_5]'} => q{[_5]がユーザー「[_1](ID:[_2])」をグループ「[_3](ID:[_4])」から削除しました。},
	q{User '[_1]' (ID:[_2]) was added to group '[_3]' (ID:[_4]) by '[_5]'} => q{[_5]がユーザー「[_1](ID:[_2])」をグループ「[_3](ID:[_4])」に追加しました。},

## lib/MT/CMS/Import.pm
	'Import Site Entries' => '記事のインポート',
	'Importer type [_1] was not found.' => '[_1]というインポート形式は存在しません。',
	'You do not have import permission' => 'インポートの権限がありません。',
	'You do not have permission to create users' => 'ユーザーを作成する権限がありません。',
	'You need to provide a password if you are going to create new users for each user listed in your site.' => 'サイトにユーザーを追加するためには、パスワードを指定する必要があります。',

## lib/MT/CMS/Log.pm
	'All Feedback' => 'すべて',
	'Publishing' => '公開',
	'System Activity Feed' => 'システムログ',
	q{Activity log for blog '[_1]' (ID:[_2]) reset by '[_3]'} => q{'[_3]'がブログ'[_1]'(ID:[_2])のログをリセットしました。},
	q{Activity log reset by '[_1]'} => q{'[_1]'がログをリセットしました。},

## lib/MT/CMS/Plugin.pm
	'Error saving plugin settings: [_1]' => 'プラグインの設定を保存できません: [_1]',
	'Individual Plugins' => 'プラグイン',
	'Plugin Set: [_1]' => 'プラグインのセット: [_1]',
	'Plugin' => 'プラグイン',
	'Plugins are disabled by [_1]' => '[_1]がプラグインを無効にしました',
	'Plugins are enabled by [_1]' => '[_1]がプラグインを有効にしました',
	q{Plugin '[_1]' is disabled by [_2]} => q{[_2]が[_1]プラグインを無効にしました},
	q{Plugin '[_1]' is enabled by [_2]} => q{[_2]が[_1]プラグインを有効にしました},

## lib/MT/CMS/RebuildTrigger.pm
	'(All child sites in this site)' => 'このサイトのすべての子サイト',
	'(All sites and child sites in this system)' => 'システム内のすべてのサイトと子サイト',
	'Comment' => 'コメント',
	'Create Rebuild Trigger' => '再構築トリガーを作成',
	'Entry/Page' => '記事/ウェブページ',
	'Format Error: Comma-separated-values contains wrong number of fields.' => 'フォーマットエラー: CSVのフィールド数が正しくありません。',
	'Format Error: Trigger data include illegal characters.' => 'フォーマットエラー: トリガーデータが不正な文字を含んでいます。',
	'Save' => '保存',
	'Search Content Type' => 'コンテンツタイプを検索',
	'Search Sites and Child Sites' => 'サイトを検索',
	'Select Content Type' => 'コンテンツタイプを選択',
	'Select Site' => 'サイトを選択',
	'Select to apply this trigger to all child sites in this site.' => 'サイト内のすべての子サイトでトリガーを有効にする',
	'Select to apply this trigger to all sites and child sites in this system.' => 'システム内のすべてのサイトと子サイトでトリガーを有効にする',
	'TrackBack' => 'トラックバック',
	'__UNPUBLISHED' => '公開終了',
	'rebuild indexes and send pings.' => 'インデックスを再構築して更新pingを送信する',
	'rebuild indexes.' => 'インデックスを再構築する',

## lib/MT/CMS/Search.pm
	'"[_1]" field is required.' => '"[_1]"フィールドは入力必須です。',
	'"[_1]" is invalid for "[_2]" field of "[_3]" (ID:[_4]): [_5]' => '"[_1]"は、コンテンツタイプ "[_3]" (ID:[_4])の"[_2]"フィールドの入力として無効です: [_5]',
	'Basename' => '出力ファイル名',
	'Data Label' => 'データ識別ラベル',
	'Entry Body' => '本文',
	'Error in search expression: [_1]' => '検索条件にエラーがあります: [_1]',
	'Excerpt' => '概要',
	'Extended Entry' => '続き',
	'Extended Page' => '追記',
	'IP Address' => 'IPアドレス',
	'Invalid date(s) specified for date range.' => '日付の範囲指定が不正です。',
	'Keywords' => 'キーワード',
	'Linked Filename' => 'リンクされたファイル名',
	'Log Message' => 'ログ',
	'No [_1] were found that match the given criteria.' => '該当する[_1]は見つかりませんでした。',
	'Output Filename' => '出力ファイル名',
	'Page Body' => '本文',
	'Site Root' => 'サイトパス',
	'Site URL' => 'サイトURL',
	'Template Name' => 'テンプレート名',
	'Templates' => 'テンプレート',
	'Text' => '本文',
	'Title' => 'タイトル',
	'replace_handler of [_1] field is invalid' => '[_1]フィールドのreplace_handlerは不正です',
	'ss_validator of [_1] field is invalid' => '[_1]フィールドのss_validatorは不正です',
	q{Searched for: '[_1]' Replaced with: '[_2]'} => q{検索ワード「[_1]」を「[_2]」で置換しました},
	q{[_1] '[_2]' (ID:[_3]) updated by user '[_4]' using Search & Replace.} => q{[_1] '[_2]' (ID:[_3]) がユーザー '[_4]' の検索/置換によって変更されました。},

## lib/MT/CMS/Tag.pm
	'A new name for the tag must be specified.' => 'タグの名前を指定してください。',
	'Error saving entry: [_1]' => '記事を保存できませんでした: [_1]',
	'Error saving file: [_1]' => 'ファイルを保存できませんでした: [_1]',
	'No such tag' => 'タグが存在しません。',
	'Successfully added [_1] tags for [_2] entries.' => '[_2]件の記事に[_1]件のタグを追加しました。',
	'The tag was successfully renamed' => 'タグの名前が変更されました。',
	q{Tag '[_1]' (ID:[_2]) deleted by '[_3]'} => q{'[_3]'がタグ'[_1]'(ID:[_2])を削除しました。},

## lib/MT/CMS/Template.pm
	' (Backup from [_1])' => ' - バックアップ ([_1])',
	'Archive Templates' => 'アーカイブテンプレート',
	'Cannot load templatemap' => 'テンプレートマップをロードできませんでした',
	'Cannot locate host template to preview module/widget.' => 'モジュール/ウィジェットをプレビューするための親テンプレートが見つかりませんでした。',
	'Cannot preview without a template map!' => 'テンプレートマップがない状態でプレビューはできません。',
	'Cannot publish a global template.' => 'グローバルテンプレートの公開ができません。',
	'Content Type Archive' => 'コンテンツタイプアーカイブ',
	'Content Type Templates' => 'コンテンツタイプテンプレート',
	'Copy of [_1]' => '[_1]のコピー',
	'Create Template' => 'テンプレートの作成',
	'Create Widget Set' => 'ウィジェットセットの作成',
	'Create Widget' => 'ウィジェットを作成',
	'Email Templates' => 'メールテンプレート',
	'Entry or Page' => '記事/ウェブページ',
	'Error creating new template: ' => 'テンプレートの作成エラー:',
	'Global Template' => 'グローバルテンプレート',
	'Global Templates' => 'グローバルテンプレート',
	'Global' => 'グローバル',
	'Index Templates' => 'インデックステンプレート',
	'Invalid Blog' => 'ブログが不正です。',
	'LOREM_IPSUM_TEXT' => 'いろはにほへと ちりぬるを わかよたれそ つねならむ うゐのおくやま けふこえて あさきゆめみし ゑひもせす',
	'LORE_IPSUM_TEXT_MORE' => '色は匂へど 散りぬるを 我が世誰ぞ 常ならむ 有為の奥山 今日越えて 浅き夢見し 酔ひもせず',
	'Lorem ipsum' => 'いろはにほへと',
	'One or more errors were found in the included template module ([_1]).' => 'テンプレートモジュール([_1])でエラーが見つかりました。',
	'One or more errors were found in this template.' => 'テンプレートでエラーが見つかりました。',
	'Orphaned' => 'Orphaned',
	'Output filename contains an inappropriate whitespace.' => '出力ファイル名に不適切な空白が含まれています。',
	'Preview' => 'プレビュー',
	'Published Date' => '公開日',
	'Refreshing template <strong>[_3]</strong> after making <a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">backup</a>.' => '「[_3]」を初期化します(<a href="?__mode=view&amp;blog_id=[_1]&amp;_type=template&amp;id=[_2]">バックアップ</a>)。',
	'Saving map failed: [_1]' => 'テンプレートマップを保存できませんでした: [_1]',
	'Setting up mappings failed: [_1]' => 'テンプレートマップを作成できませんでした: [_1]',
	'System Templates' => 'システムテンプレート',
	'Template Backups' => 'バックアップされたテンプレート',
	'Template Modules' => 'テンプレートモジュール',
	'Template Refresh' => 'テンプレートの初期化',
	'Unable to create preview file in this location: [_1]' => 'プレビュー用のファイルをこの場所に作成できませんでした: [_1]',
	'Unknown blog' => '不明なブログ',
	'Widget Template' => 'ウィジェットテンプレート',
	'Widget Templates' => 'ウィジェットテンプレート',
	'You must select at least one event checkbox.' => '少なくとも1つのイベントにチェックを入れてください。',
	'You must specify a template type when creating a template' => 'テンプレートを作成するためのtypeパラメータが指定されていません。',
	'You should not be able to enter zero (0) as the time.' => '時間に0を入れることはできません。',
	'archive' => 'アーカイブ',
	'backup' => 'バックアップ',
	'content type' => 'コンテンツタイプ',
	'email' => 'メール',
	'index' => 'インデックス',
	'module' => 'モジュール',
	'sample, entry, preview' => 'サンプル、記事、プレビュー',
	'system' => 'システム',
	'template' => 'テンプレート',
	'widget' => 'ウィジェット',
	q{Archive mapping '[_1]' contains an inappropriate whitespace.} => q{アーカイブマッピング '[_1]' に不適切な空白が含まれています。},
	q{Skipping template '[_1]' since it appears to be a custom template.} => q{カスタムテンプレートと思われるため、'[_1]'をスキップします。},
	q{Skipping template '[_1]' since it has not been changed.} => q{[_1]は変更されていないのでスキップします。},
	q{Template '[_1]' (ID:[_2]) created by '[_3]'} => q{'[_3]'がテンプレート'[_1]'(ID:[_2])を作成しました。},
	q{Template '[_1]' (ID:[_2]) deleted by '[_3]'} => q{'[_3]'がテンプレート'[_1]'(ID:[_2])を削除しました。},

## lib/MT/CMS/Theme.pm
	'All themes directories are not writable.' => '書き込み可能なテーマディレクトリがありません。',
	'Download [_1] archive' => '[_1]形式アーカイブでダウンロード',
	'Error occurred during exporting [_1]: [_2]' => '[_1]のエクスポート中にエラーが発生しました: [_2]',
	'Error occurred during finalizing [_1]: [_2]' => '[_1]のファイナライズ中にエラーが発生しました: [_2]',
	'Error occurred while publishing theme: [_1]' => 'テーマの公開中にエラーが発生しました: [_1]',
	'Export Themes' => 'テーマのエクスポート',
	'Failed to load theme export template for [_1]: [_2]' => '[_1]のテンプレートの読み込みに失敗しました: [_2]',
	'Failed to save theme export info: [_1]' => 'テーマエクスポート情報の保存に失敗しました: [_1]',
	'Failed to uninstall theme' => 'テーマのアンインストールに失敗しました',
	'Failed to uninstall theme: [_1]' => 'テーマのアンインストールに失敗しました: [_1]',
	'Install into themes directory' => 'テーマディレクトリへのインストール',
	'Theme from [_1]' => '[_1]のテーマ',
	'Theme not found' => 'テーマがみつかりませんでした。',
	'Themes Directory [_1] is not writable.' => 'テーマディレクトリ[_1]に書き込めません。',
	'Themes directory [_1] is not writable.' => 'テーマディレクトリ[_1]に書き込めません。',

## lib/MT/CMS/Tools.pm
	'Any site' => '任意のサイト',
	'Cannot recover password in this configuration' => 'この構成ではパスワードの再設定はできません。',
	'Changing URL for FileInfo record (ID:[_1])...' => 'ファイル情報レコード(ID:[_1])のURLを変更しています...',
	'Changing file path for FileInfo record (ID:[_1])...' => 'ファイル情報レコード(ID:[_1])のパスを変更しています...',
	'Changing image quality is [_1]' => '画像品質の自動変換は[_1]です',
	'Copying file [_1] to [_2] failed: [_3]' => 'ファイル: [_1]を[_2]にコピーできませんでした: [_3]',
	'Debug mode is [_1]' => 'デバッグモードは[_1]です',
	'Detailed information is in the activity log.' => '詳細はログを参照してください。',
	'E-mail was not properly sent. [_1]' => 'メールが正しく送信されませんでした: [_1]',
	'Email address is [_1]' => 'メールアドレスは[_1]です',
	'Email address is required for password reset.' => 'メールアドレスはパスワードをリセットするために必要です。',
	'Email address not found' => 'メールアドレスが見つかりませんでした。',
	'Error occurred during import process.' => 'インポート中にエラーが発生しました。',
	'Error occurred while attempting to [_1]: [_2]' => '[_1]の実行中にエラーが発生しました: [_2]',
	'Error sending e-mail ([_1]); Please fix the problem, then try again to recover your password.' => 'メールを送信できませんでした。問題を解決してから再度パスワードの再設定を行ってください: [_1]',
	'File was not uploaded.' => 'ファイルがアップロードされませんでした。',
	'IP address lockout interval' => '同一IPアドレスからの試行間隔',
	'IP address lockout limit' => '同一IPアドレスからの試行回数',
	'Image quality(JPEG) is [_1]' => 'JPEG 画像の品質は [_1] です',
	'Image quality(PNG) is [_1]' => 'PNG 画像の圧縮レベルは [_1] です',
	'Importing a file failed: ' => 'ファイルからインポートできませんでした。',
	'Invalid SitePath.  The SitePath should be valid and absolute, not relative' => 'サイトパス制限には正しい絶対パスを指定してください。',
	'Invalid author_id' => 'ユーザーのIDが不正です。',
	'Invalid email address' => 'メールアドレスのフォーマットが正しくありません',
	'Invalid password recovery attempt; Cannot recover the password in this configuration' => 'パスワードの再設定に失敗しました。この構成では再設定はできません。',
	'Invalid password recovery attempt; cannot recover password in this configuration' => 'パスワードの再設定に失敗しました。この構成では再設定はできません。',
	'Invalid password reset request' => '不正なリクエストです。',
	'Lockout IP address whitelist' => 'ロックアウトの除外IPアドレス',
	'MT::Asset#[_1]: ' => 'MT::Asset#[_1]: ',
	'Manifest file [_1] was not a valid Movable Type exported manifest file.' => '[_1]はMovable Typeで作成された正しいマニフェストファイルではありません。',
	'Only to blogs within this system' => 'ブログのみ',
	'Outbound trackback limit is [_1]' => '外部トラックバック送信は [_1] に制限されます',
	'Password Recovery' => 'パスワードの再設定',
	'Password reset token not found' => 'パスワードをリセットするためのトークンが見つかりませんでした。',
	'Passwords do not match' => 'パスワードが一致していません。',
	'Performance log path is [_1]' => 'パフォーマンスログのパスは[_1]です',
	'Performance log threshold is [_1]' => 'パフォーマンスログの閾値は[_1]です',
	'Performance logging is off' => 'バフォーマンスログはオフです',
	'Performance logging is on' => 'パフォーマンスログはオンです',
	'Please confirm your new password' => '新しいパスワードを確認してください。',
	'Please enter a valid email address.' => '正しいメールアドレスを入力してください。',
	'Please upload [_1] in this page.' => '[_1]をアップロードしてください。',
	'Please use xml, tar.gz, zip, or manifest as a file extension.' => '拡張子がxml、tar.gz、zip、manifestのいずれかのファイルをアップロードしてください。',
	'Prohibit comments is off' => 'コメントは有効です',
	'Prohibit comments is on' => 'コメントは無効です',
	'Prohibit notification pings is off' => '更新pingは有効です',
	'Prohibit notification pings is on' => '更新pingは無効です',
	'Prohibit trackbacks is off' => 'トラックバックは有効です',
	'Prohibit trackbacks is on' => 'トラックバックは無効です',
	'Recipients for lockout notification' => '通知メール受信者',
	'Some [_1] were not imported because their parent objects were not imported.' => '親となるオブジェクトがないため[_1]をインポートできませんでした。',
	'Some objects were not imported because their parent objects were not imported.  Detailed information is in the activity log.' => '親となるオブジェクトがないため復元できなかったオブジェクトがあります。詳細はログを参照してください。',
	'Some objects were not imported because their parent objects were not imported.' => '親となるオブジェクトがないためインポートできなかったオブジェクトがあります。',
	'Some of files could not be imported.' => 'インポートできなかったファイルがあります。',
	'Some of the actual files for assets could not be imported.' => 'インポートできなかった実ファイルがあります。',
	'Some of the exported files could not be removed.' => '削除できなかったエクスポートファイルがあります。',
	'Some of the files were not imported correctly.' => 'インポートできなかったファイルがあります。',
	'Specified file was not found.' => '指定されたファイルが見つかりませんでした。',
	'Started importing sites' => 'サイトのインポートを開始します',
	'Started importing sites: [_1]' => 'サイトのインポートを開始します: [_1]',
	'System Settings Changes Took Place' => 'システム設定が変更されました',
	'Temporary directory needs to be writable for export to work correctly.  Please check (Export)TempDir configuration directive.' => 'エクスポートするにはテンポラリディレクトリに書き込みできなければなりません。(Export)TempDirの設定を確認してください。',
	'Temporary directory needs to be writable for import to work correctly.  Please check (Export)TempDir configuration directive.' => 'インポートするにはテンポラリディレクトリに書き込みできなければなりません。(Export)TempDirの設定を確認してください。',
	'Test email from Movable Type' => 'Movable Typeからのテストメール',
	'That action ([_1]) is apparently not implemented!' => 'アクション([_1])が実装されていません。',
	'This is the test email sent by Movable Type.' => 'このメールはMovable Typeから送信されたテストメールです。',
	'Uploaded file was not a valid Movable Type exported manifest file.' => 'アップロードされたファイルはMovable Typeで作成されたマニフェストファイルではありません。',
	'User lockout interval' => 'サインインの間隔',
	'User lockout limit' => 'サインイン試行回数',
	'User not found' => 'ユーザーが見つかりませんでした。',
	'You do not have a system email address configured.  Please set this first, save it, then try the test email again.' => 'システムメールアドレスの設定がされていません。最初に設定を保存してから、再度テストメール送信を行ってください。',
	'Your request to change your password has expired.' => 'パスワードのリセットを始めてから決められた時間を経過してしまいました。',
	'[_1] has canceled the multiple files import operation prematurely.' => '[_1]がインポートを途中で強制終了しました。',
	'[_1] is [_2]' => '[_1]が[_2]',
	'[_1] is not a directory.' => '[_1]はディレクトリではありません。',
	'[_1] is not a number.' => '[_1]は数値ではありません。',
	'[_1] successfully downloaded export file ([_2])' => '[_1]がエクスポートファイル([_2])をダウンロードしました。',
	q{A password reset link has been sent to [_3] for user  '[_1]' (user #[_2]).} => q{パスワード再設定用のリンクがユーザー'[_1]'(ID:[_2])のメールアドレス([_3])あてに通知されました。},
	q{Changing Archive Path for the site '[_1]' (ID:[_2])...} => q{'[_1]'(ID:[_2])のアーカイブパスを変更しています...},
	q{Changing Site Path for the site '[_1]' (ID:[_2])...} => q{'[_1]'(ID:[_2])のサイトパスを変更しています...},
	q{Changing file path for the asset '[_1]' (ID:[_2])...} => q{アセット'[_1]'(ID:[_2])のパスを変更しています...},
	q{Could not remove exported file [_1] from the filesystem: [_2]} => q{エクスポートファイル('[_1]')をファイルシステムから削除できませんでした: [_2]},
	q{Manifest file '[_1]' is too large. Please use import directory for importing.} => q{インポートファイル'[_1]'が大きすぎます。インポートディレクトリを利用して復元してください。},
	q{Movable Type system was successfully exported by user '[_1]'} => q{'[_1]'がMovable Typeのシステムをエクスポートしました。},
	q{Removing Archive Path for the site '[_1]' (ID:[_2])...} => q{'[_1]'(ID:[_2])のアーカイブパスを消去しています...},
	q{Removing Site Path for the site '[_1]' (ID:[_2])...} => q{'[_1]'(ID:[_2])のサイトパスを消去しています...},
	q{Site(s) (ID:[_1]) was/were successfully exported by user '[_2]'} => q{'[_2]'がサイト(ID:[_1])をエクスポートしました。},
	q{Successfully imported objects to Movable Type system by user '[_1]'} => q{'[_1]'がMovable Typeシステムにデータをインポートしました。},
	q{The password for the user '[_1]' has been recovered.} => q{ユーザー「[_1]」のパスワードが再設定されました。},
	q{User '[_1]' (user #[_2]) does not have email address} => q{ユーザー'[_1]'(ID:[_2])はメールアドレスがありません},

## lib/MT/CMS/User.pm
	'(newly created user)' => '(新規ユーザー)',
	'Another role already exists by that name.' => '同名のロールが既に存在します。',
	'Cannot load role #[_1].' => 'ロール: [_1]をロードできませんでした。',
	'Create User' => 'ユーザーの作成',
	'For improved security, please change your password' => 'セキュリティ向上の為パスワードを更新してください',
	'Grant Permissions' => '権限の付与',
	'Groups/Users Selected' => '選択されたユーザーとグループ',
	'Invalid ID given for personal blog clone location ID.' => '個人用ブログの複製先のIDが不正です。',
	'Invalid ID given for personal blog theme.' => '個人用ブログテーマのIDが不正です。',
	'Invalid type' => 'typeが不正です。',
	'Minimum password length must be an integer and greater than zero.' => 'パスワードの最低文字数は0以上の整数でなければなりません。',
	'Role name cannot be blank.' => 'ロールの名前は必須です。',
	'Roles Selected' => '選択されたロール',
	'Select Groups And Users' => 'ユーザーとグループを選択',
	'Select Roles' => 'ロールを選択',
	'Select a System Administrator' => 'システム管理者を選択',
	'Select a entry author' => '記事の投稿者を選択',
	'Select a page author' => 'ページの投稿者を選択',
	'Selected System Administrator' => '選択されたシステム管理者',
	'Selected author' => '選択された投稿者',
	'Sites Selected' => '選択されたサイト',
	'System Administrator' => 'システム管理者',
	'Type a username to filter the choices below.' => 'ユーザー名を入力して絞り込み',
	'User Settings' => 'ユーザー設定',
	'User requires display name' => '表示名は必須です。',
	'User requires password' => 'パスワードは必須です。',
	'User requires username' => 'ユーザー名は必須です。',
	'You cannot define a role without permissions.' => '権限のないロールは作成できません。',
	'You cannot delete your own association.' => '自分の関連付けは削除できません。',
	'You have no permission to delete the user [_1].' => '[_1]を削除する権限がありません。',
	'represents a user who will be created afterwards' => '今後新しく作成されるユーザー',
	q{User '[_1]' (ID:[_2]) could not be re-enabled by '[_3]'} => q{'[_3]'がユーザー '[_1]' (ID:[_2])を有効にできませんでした},
	q{User '[_1]' (ID:[_2]) created by '[_3]'} => q{'[_3]'がユーザー'[_1]'(ID:[_2])を作成しました。},
	q{User '[_1]' (ID:[_2]) deleted by '[_3]'} => q{'[_3]'がユーザー'[_1]'(ID:[_2])を削除しました。},
	q{[_1]'s Associations} => q{[_1]の権限},

## lib/MT/CMS/Website.pm
	'Cannot load website #[_1].' => 'ウェブサイト(ID:[_1])はロードできませんでした。',
	'Create Site' => 'サイトの作成',
	'Selected Site' => '選択されたサイト',
	'This action cannot move a top-level site.' => 'このアクションでは親サイトの移動はできません。',
	'Type a site name to filter the choices below.' => '以下の選択によって抽出されたサイト名を入力',
	'Type a website name to filter the choices below.' => '以下の選択によって抽出されたウェブサイト名を入力',
	q{Blog '[_1]' (ID:[_2]) moved from '[_3]' to '[_4]' by '[_5]'} => q{'[_5]'がブログ「[_1]」(ID:[_2])を[_3]から[_4]に移しました},
	q{Website '[_1]' (ID:[_2]) deleted by '[_3]'} => q{[_3]によってウェブサイト「[_1]」(ID:[_2])が削除されました},

## lib/MT/Category.pm
	'Categories must exist within the same blog' => 'カテゴリは親となるカテゴリと同じブログに作らなければなりません。',
	'Category loop detected' => 'カテゴリがお互いに親と子の関係になっています。',
	'Category' => 'カテゴリ',
	'Parent' => '親カテゴリ',
	'[quant,_1,entry,entries,No entries]' => '記事[quant,_1,件,件,0 件]',
	'[quant,_1,page,pages,No pages]' => 'ページ[quant,_1,件,件,0 件]',

## lib/MT/CategorySet.pm
	'Category Count' => 'カテゴリ数',
	'Category Label' => 'カテゴリ名',
	'Content Type Name' => 'コンテンツタイプ名',
	'name "[_1]" is already used.' => '"[_1]"はすでに存在します。',
	'name is required.' => 'nameを指定してください。',

## lib/MT/Comment.pm
	q{Loading blog '[_1]' failed: [_2]} => q{ブログ '[_1]'をロードできません: [_2]},
	q{Loading entry '[_1]' failed: [_2]} => q{記事'[_1]'をロードできませんでした: [_2]},

## lib/MT/Compat/v3.pm
	'No executable code' => '実行できるコードがありません。',
	'Publish-option name must not contain special characters' => '再構築のオプション名には特殊記号を含められません。',
	'uses [_1]' => '[_1]を使っています。',
	'uses: [_1], should use: [_2]' => '[_1]は[_2]に直してください。',

## lib/MT/Component.pm
	q{Loading template '[_1]' failed: [_2]} => q{テンプレート'[_1]'をロードできませんでした: [_2]},

## lib/MT/Config.pm
	'Configuration' => '構成情報',

## lib/MT/ConfigMgr.pm
	'Alias for [_1] is looping in the configuration.' => '[_1]のAlias指定は循環しています。',
	'Config directive [_1] without value at [_2] line [_3]' => '構成ファイル[_2]の設定[_1]に値がありません(行:[_3])',
	q{Error opening file '[_1]': [_2]} => q{'[_1]'を開けませんでした: [_2]},
	q{No such config variable '[_1]'} => q{'[_1]'は正しい設定項目ではありません。},

## lib/MT/ContentData.pm
	'(No label)' => '(ラベルなし)',
	'Author' => 'ユーザー',
	'Cannot load content field #[_1]' => 'コンテンツフィールド（[_1]）をロードできません',
	'Contents by [_1]' => '[_1]のコンテンツデータ',
	'Identifier' => '識別子',
	'Invalid content type' => '不正なコンテンツタイプです',
	'Link' => 'リンク',
	'No Content Type could be found.' => 'コンテンツタイプが見つかりません。',
	'Publish Date' => '公開日',
	'Removing content field indexes failed: [_1]' => 'コンテンツデータのインデックスを削除できません: [_1]',
	'Removing object assets failed: [_1]' => 'コンテンツデータとアセットのリンクを削除できません: [_1]',
	'Removing object categories failed: [_1]' => 'コンテンツデータとカテゴリのリンクを削除できません: [_1]',
	'Removing object tags failed: [_1]' => 'コンテンツデータとタグのリンクを削除できません: [_1]',
	'Saving content field index failed: [_1]' => 'コンテンツデータのインデックスを作成できません: [_1]',
	'Saving object asset failed: [_1]' => 'コンテンツデータとアセットのリンクを作成できません: [_1]',
	'Saving object category failed: [_1]' => 'コンテンツデータとカテゴリのリンクを作成できません: [_1]',
	'Saving object tag failed: [_1]' => 'コンテンツデータとタグのリンクを作成できません: [_1]',
	'Tags fields' => 'いずれかのタグのフィールド',
	'Unpublish Date' => '公開終了日',
	'View Content Data' => 'コンテンツデータを見る',
	'[_1] ( id:[_2] ) does not exists.' => '[_1] ( id:[_2] ) が見つかりません。',
	'basename is too long.' => '出力ファイルが長すぎます。',
	'record does not exist.' => 'ブログがありません。',

## lib/MT/ContentField.pm
	'Cannot load content field data_type [_1]' => 'コンテンツフィールドのdata_typeが見つかりません ([_1])',
	'Content Fields' => 'コンテンツフィールド',

## lib/MT/ContentFieldIndex.pm
	'Content Field Index' => 'コンテンツフィールドインデックス',
	'Content Field Indexes' => 'コンテンツフィールドインデックス',

## lib/MT/ContentFieldType.pm
	'Audio Asset' => 'オーディオアセット',
	'Checkboxes' => 'チェックボックス',
	'Date and Time' => '日付と時刻',
	'Date' => '日付',
	'Embedded Text' => '埋め込みテキスト',
	'Image Asset' => '画像アセット',
	'Multi Line Text' => 'テキスト（複数行）',
	'Number' => '数値',
	'Radio Button' => 'ラジオボタン',
	'Select Box' => 'セレクトボックス',
	'Single Line Text' => 'テキスト',
	'Table' => 'テーブル',
	'Text Display Area' => 'テキスト表示エリア',
	'Time' => '時刻',
	'Video Asset' => 'ビデオアセット',
	'__LIST_FIELD_LABEL' => 'リスト',

## lib/MT/ContentFieldType/Asset.pm
	'Show all [_1] assets' => '[_1]件のアセットをすべて見る',
	q{A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 1.} => q{'[_1]'フィールド ([_2]) の最大選択数は1以上の整数である必要があります。},
	q{A maximum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to the minimum selection number.} => q{'[_1]'フィールド ([_2]) の最大選択数は最小選択数以上の整数である必要があります。},
	q{A minimum selection number for '[_1]' ([_2]) must be a positive integer greater than or equal to 0.} => q{'[_1]'フィールド ([_2]) の最小選択数は0以上の整数である必要があります。},
	q{You must select or upload correct assets for field '[_1]' that has asset type '[_2]'.} => q{'[_1]'フィールドの[_2]を選択するか、アップロードしてください。},

## lib/MT/ContentFieldType/Categories.pm
	'Invalid Category IDs: [_1] in "[_2]" field.' => '"[_2]"フィールドに不正なカテゴリ (ID: [_1]) が指定されています。',
	'No category_set setting in content field type.' => 'コンテンツフィールドにカテゴリセットが設定されていません。',
	'The source category set is not found in this site.' => 'カテゴリセットが見つかりません。',
	'There is no category set that can be selected. Please create a category set if you use the Categories field type.' => 'カテゴリセットが存在しないため、カテゴリセットフィールドは利用できません。',
	'You must select a source category set.' => 'カテゴリセットが選択されていません。',

## lib/MT/ContentFieldType/Checkboxes.pm
	'A label for each value is required.' => '値リストのラベルは入力必須です。',
	'A value for each label is required.' => '値リストの値は入力必須です。',
	'You must enter at least one label-value pair.' => '一組以上のラベルと値の組み合わせを入力してください。',

## lib/MT/ContentFieldType/Common.pm
	'"[_1]" field value must be greater than or equal to [_2]' => '"[_1]"フィールドは[_2]以上である必要があります。',
	'"[_1]" field value must be less than or equal to [_2].' => '"[_1]"フィールドは[_2]以下である必要があります。',
	'In [_1] column, [_2] [_3]' => '[_1]フィールドで [_2] [_3]',
	'Invalid [_1] in "[_2]" field.' => '"[_2]"フィールドの値は不正な[_1]です。',
	'Invalid values in "[_1]" field: [_2]' => '"[_1]"フィールドの値が不正です: [_2]',
	'Only 1 [_1] can be selected in "[_2]" field.' => '"[_2]”フィールドはひとつだけ選択できます',
	'[_1] greater than or equal to [_2] must be selected in "[_3]" field.' => '"[_3]"フィールドの[_1]は[_2]個以下である必要があります。',
	'[_1] less than or equal to [_2] must be selected in "[_3]" field.' => '"[_3]"フィールドの[_1]は[_2]個以下である必要があります。',
	'is not selected' => 'が選択されていない',
	'is selected' => 'が選択されている',

## lib/MT/ContentFieldType/ContentType.pm
	'Invalid Content Data Ids: [_1] in "[_2]" field.' => '"[_2]"フィールドに無効なコンテンツデータ (ID:[_1]) が指定されています。',
	'No Label (ID:[_1]' => 'ラベルなし (ID:[_1])',
	'The source Content Type is not found in this site.' => '指定されたコンテンツタイプはこのサイトに存在しません。',
	'There is no content type that can be selected. Please create new content type if you use Content Type field type.' => 'コンテンツタイプが存在しないため、コンテンツタイプフィールドは利用できません。',
	'You must select a source content type.' => 'コンテンツタイプを指定する必要があります',

## lib/MT/ContentFieldType/Date.pm
	q{Invalid date '[_1]'; An initial date value must be in the format YYYY-MM-DD.} => q{'[_1]'は無効な日付です。正しい日付を YYYY-MM-DD 形式で入力してください。},

## lib/MT/ContentFieldType/DateTime.pm
	q{Invalid date '[_1]'; An initial date/time value must be in the format YYYY-MM-DD HH:MM:SS.} => q{'[_1]'は無効な日時です。正しい日時を YYYY-MM-DD HH:MM:SS 形式で入力してください。},

## lib/MT/ContentFieldType/Number.pm
	'"[_1]" field value has invalid precision.' => '"[_1]"フィールドの値が不正です。',
	'"[_1]" field value must be a number.' => '"[_1]"フィールドの値は数値である必要があります。',
	'A maximum value must be an integer and between [_1] and [_2]' => '最大値は[_1]から[_2]の範囲で指定します。',
	'A maximum value must be an integer, or must be set with decimal places to use decimal value.' => '最大値は整数である必要があります。小数を利用する場合は、小数点以下の桁数を指定してください。',
	'A minimum value must be an integer and between [_1] and [_2]' => '最小値は[_1]から[_2]の範囲で指定します。',
	'A minimum value must be an integer, or must be set with decimal places to use decimal value.' => '最小値は整数である必要があります。小数を利用する場合は、小数点以下の桁数を指定してください。',
	'An initial value must be an integer and between [_1] and [_2]' => '初期値は[_1]から[_2]の範囲で指定します。',
	'An initial value must be an integer, or must be set with decimal places to use decimal value.' => '初期値は整数である必要があります。小数を利用する場合は、小数点以下の桁数を指定してください。',
	'Number of decimal places must be a positive integer and between 0 and [_1].' => '小数点以下の桁数は0から[_1]までの整数である必要があります。',
	'Number of decimal places must be a positive integer.' => '小数点以下の桁数は0以上の整数である必要があります。',

## lib/MT/ContentFieldType/RadioButton.pm
	'A label of values is required.' => '値リストのラベルは入力必須です。',
	'A value of values is required.' => '値リストの値は入力必須です。',

## lib/MT/ContentFieldType/SingleLineText.pm
	'"[_1]" field is too long.' => '"[_1]"フィールドの値は長すぎます。',
	'"[_1]" field is too short.' => '"[_1]"フィールドの値は短すぎます。',
	q{A maximum length number for '[_1]' ([_2]) must be a positive integer between 1 and [_3].} => q{'[_1]'フィールド ([_2]) の最大文字数は1以上、[_3]以下の整数である必要があります。},
	q{A minimum length number for '[_1]' ([_2]) must be a positive integer between 0 and [_3].} => q{'[_1]'フィールド ([_2]) の最小文字数は0以上、[_3]以下の整数である必要があります。},
	q{An initial value for '[_1]' ([_2]) must be shorter than [_3] characters} => q{'[_1]'フィールド ([_2]) の初期値は[_3]文字以下である必要があります。},

## lib/MT/ContentFieldType/Table.pm
	q{Initial number of columns for '[_1]' ([_2]) must be a positive integer.} => q{'[_1]' ([_2]) の初期列数は1以上の整数である必要があります。},
	q{Initial number of rows for '[_1]' ([_2]) must be a positive integer.} => q{'[_1]' ([_2]) の初期行数は1以上の整数である必要があります。},

## lib/MT/ContentFieldType/Tags.pm
	'Cannot create tag "[_1]": [_2]' => 'タグ "[_1]" を作成できません: [_2]',
	q{An initial value for '[_1]' ([_2]) must be an shorter than 255 characters} => q{'[_1]'フィールド ([_2]) の初期値は255文字以下である必要があります。},
	q{Cannot create tags [_1] in "[_2]" field.} => q{"[_2]"のタグ'[_1]'を作成できません。},

## lib/MT/ContentFieldType/Time.pm
	'<mt:var name="[_1]"> [_2] [_3] [_4]' => '<mt:var name="[_1]"> [_2] [_4] [_3]',
	q{Invalid time '[_1]'; An initial time value be in the format HH:MM:SS.} => q{'[_1]'は無効な時刻です。正しい時刻を HH:MM:SS 形式で入力してください。},

## lib/MT/ContentFieldType/URL.pm
	'Invalid URL in "[_1]" field.' => '"[_1]"フィールドの値は不正な URL です。',
	q{An initial value for '[_1]' ([_2]) must be shorter than 2000 characters} => q{'[_1]' ([_2])の初期値は2000文字以内である必要があります},

## lib/MT/ContentPublisher.pm
	'An error occurred while publishing scheduled contents: [_1]' => '日時指定されたコンテンツデータの再構築中にエラーが発生しました: [_1]',
	'An error occurred while unpublishing past contents: [_1]' => '公開終了日を過ぎたコンテンツデータの処理中にエラーが発生しました: [_1]',
	'Cannot load catetory. (ID: [_1]' => 'カテゴリ (ID:[_1])をロードできません。',
	'Scheduled publishing.' => '指定日公開',
	'You did not set your site publishing path' => 'サイトの公開パスを設定していません。',
	'[_1] archive type requires [_2] parameter' => '[_1]アーカイブの再構築には[_2]パラメータが必要です',
	q{An error occurred publishing [_1] '[_2]': [_3]} => q{[_1]「[_2]」の再構築中にエラーが発生しました: [_3]},
	q{An error occurred publishing date-based archive '[_1]': [_2]} => q{日付アーカイブ「[_1]」の再構築中にエラーが発生しました: [_2]},
	q{Archive type '[_1]' is not a chosen archive type} => q{'[_1]'はアーカイブタイプとして選択されていません。},
	q{Load of blog '[_1]' failed: [_2]} => q{ブログ(ID:[_1])をロードできませんでした: [_2]},
	q{Load of blog '[_1]' failed} => q{サイト '[_1]'をロードできません},
	q{Loading of blog '[_1]' failed: [_2]} => q{ブログ(ID:[_1])をロードできませんでした: [_2]},
	q{Parameter '[_1]' is invalid} => q{'[_1]'パラメータは不正です。},
	q{Parameter '[_1]' is required} => q{'[_1]'をパラメータに指定してください。},
	q{Renaming tempfile '[_1]' failed: [_2]} => q{テンポラリファイル'[_1]'の名前を変更できませんでした: [_2]},
	q{Writing to '[_1]' failed: [_2]} => q{'[_1]'に書き込めませんでした: [_2]},

## lib/MT/ContentType.pm
	'"[_1]" (Site: "[_2]" ID: [_3])' => '"[_1]" ([_2] ID: [_3])',
	'Content Data # [_1] not found.' => 'コンテンツデータ (ID: [_1])が見つかりません。',
	'Create Content Data' => 'コンテンツデータの作成',
	'Edit All Content Data' => 'すべてのコンテンツデータの編集',
	'Manage Content Data' => 'コンテンツデータの管理',
	'Publish Content Data' => 'コンテンツデータの公開',
	'Tags with [_1]' => '[_1]のタグ',

## lib/MT/ContentType/UniqueID.pm
	'Cannot generate unique unique_id' => 'ユニークIDの生成に失敗しました',

## lib/MT/Core.pm
	'(system)' => 'システム',
	'*Website/Blog deleted*' => '*削除されました*',
	'Activity Feed' => 'ログフィード',
	'Add Summary Watcher to queue' => 'サマリー監視タスクをキューに追加',
	'Address Book is disabled by system configuration.' => 'アドレス帳の管理は、設定により無効にされています。',
	'Adds Summarize workers to queue.' => 'キューにワーカーサマリーを追加します。',
	'Blog ID' => 'ブログID',
	'Blog Name' => 'ブログ名',
	'Blog URL' => 'ブログURL',
	'Change Settings' => '設定の変更',
	'Classic Blog' => 'クラシックブログ',
	'Contact' => '連絡先',
	'Convert Line Breaks' => '改行を変換',
	'Create Child Sites' => '子サイトの作成',
	'Create Entries' => '記事の作成',
	'Create Sites' => 'サイトの作成',
	'Create Websites' => 'ウェブサイトの作成',
	'Database Name' => 'データベース名',
	'Database Path' => 'データベースのパス',
	'Database Port' => 'データベースポート',
	'Database Server' => 'データベースサーバ',
	'Database Socket' => 'データベースソケット',
	'Date Created' => '作成日',
	'Date Modified' => '更新日',
	'Days must be a number.' => '日数には数値を指定してください。',
	'Edit All Entries' => 'すべての記事の編集',
	'Entries List' => '記事の一覧',
	'Entry Excerpt' => '概要',
	'Entry Extended Text' => '続き',
	'Entry Link' => 'リンク',
	'Entry Title' => 'タイトル',
	'Error creating performance logs directory, [_1]. Please either change the permissions to make it writable or specify an alternate using the PerformanceLoggingPath configuration directive. [_2]' => 'パフォーマンスログを出力するディレクトリ「[_1]」を作成できませんでした。ディレクトリを書き込み可能に設定するか、または書き込みできる場所をPerformanceLoggingPathディレクティブで指定してください。: [_2]',
	'Error creating performance logs: PerformanceLoggingPath directory exists but is not writeable. [_1]' => 'パフォーマンスをログを出力できませんでした。PerformanceLoggingPathにディレクトリがありますが、書き込みできません。[_1]',
	'Error creating performance logs: PerformanceLoggingPath setting must be a directory path, not a file. [_1]' => 'パフォーマンスログを出力できませんでした。PerformanceLoggingPathにはファイルではなくディレクトリへのパスを指定してください。[_1]',
	'Filter' => 'フィルタ',
	'Folder' => 'フォルダ',
	'Get Variable' => '変数のGet',
	'Group Member' => 'グループメンバー',
	'Group Members' => 'グループメンバー',
	'ID' => 'ID',
	'IP Banlist is disabled by system configuration.' => '禁止IPアドレスの管理は、設定により無効にされています。',
	'IP Banning Settings' => '禁止IPアドレスの設定',
	'IP address' => 'IPアドレス',
	'IP addresses' => 'IPアドレス',
	'If Block' => 'If条件ブロック',
	'If/Else Block' => 'If/Else条件ブロック',
	'Include Template File' => 'テンプレートファイルのインクルード',
	'Include Template Module' => 'テンプレートモジュールのインクルード',
	'Junk Folder Expiration' => 'スパムコメント/トラックバックの廃棄',
	'Legacy Quick Filter' => 'クイックフィルタ',
	'Log' => 'ログ',
	'Manage Address Book' => 'アドレス帳の管理',
	'Manage All Content Data' => 'すべてのコンテンツデータの管理',
	'Manage Assets' => 'アセットの管理',
	'Manage Blog' => 'ブログの管理',
	'Manage Categories' => 'カテゴリの管理',
	'Manage Category Set' => 'カテゴリセットの管理',
	'Manage Content Type' => 'コンテンツタイプの管理',
	'Manage Content Types' => 'コンテンツタイプの管理',
	'Manage Feedback' => 'コメント/トラックバックの管理',
	'Manage Group Members' => 'グループメンバーの管理',
	'Manage Pages' => 'ウェブページの管理',
	'Manage Plugins' => 'プラグインの管理',
	'Manage Sites' => 'サイトの管理',
	'Manage Tags' => 'タグの管理',
	'Manage Templates' => 'テンプレートの管理',
	'Manage Themes' => 'テーマの管理',
	'Manage Users & Groups' => 'ユーザーとグループの管理',
	'Manage Users' => 'ユーザーの管理',
	'Manage Website with Blogs' => 'ウェブサイトと所属ブログの管理',
	'Manage Website' => 'ウェブサイトの管理',
	'Member' => 'メンバー',
	'Members' => 'メンバー',
	'Modified by' => '更新者',
	'Movable Type Default' => 'Movable Type 既定',
	'My Items' => '私のアセット',
	'My [_1]' => '自分の[_1]',
	'MySQL Database (Recommended)' => 'MySQLデータベース(推奨)',
	'No Title' => 'タイトルなし',
	'No label' => '名前がありません。',
	'Password' => 'パスワード',
	'Permission' => '権限',
	'Post Comments' => 'コメントの投稿',
	'PostgreSQL Database' => 'PostgreSQLデータベース',
	'Publish Entries' => '記事の公開',
	'Publish Scheduled Contents' => '日時指定されたコンテンツを再構築',
	'Publish Scheduled Entries' => '日時指定された記事を再構築',
	'Publishes content.' => 'コンテンツを公開します。',
	'Purge Stale DataAPI Session Records' => '古いData APIのセッションレコードの消去',
	'Purge Stale Session Records' => '古いセッションレコードの消去',
	'Purge Unused FileInfo Records' => '古いファイル情報レコードの消去',
	'Refreshes object summaries.' => 'オブジェクトサマリーの初期化',
	'Remove Compiled Template Files' => 'ダイナミック・パブリッシング用のコンパイル済みテンプレートの削除',
	'Remove Temporary Files' => 'テンポラリファイルの削除',
	'Remove expired lockout data' => '古いサインインの失敗レコードの消去',
	'Rich Text' => 'リッチテキスト',
	'SQLite Database (v2)' => 'SQLite(v2)データベース',
	'SQLite Database' => 'SQLiteデータベース',
	'Send Notifications' => '通知の送信',
	'Set Publishing Paths' => '公開パスの設定',
	'Set Variable Block' => '変数ブロックのSet',
	'Set Variable' => '変数のSet',
	'Sign In(CMS)' => '管理画面へのサインイン',
	'Sign In(Data API)' => 'Data API でのサインイン',
	'Synchronizes content to other server(s).' => 'コンテンツを他のサーバーに同期します。',
	'Tag' => 'タグ',
	'The physical file path for your SQLite database. ' => 'SQLiteのデータベースファイルのパス',
	'Unpublish Past Contents' => '公開期限が過ぎたコンテンツの公開を終了',
	'Unpublish Past Entries' => '公開期限が過ぎた記事の公開を終了',
	'Upload File' => 'ファイルアップロード',
	'View Activity Log' => 'ログの閲覧',
	'View System Activity Log' => 'システムログの閲覧',
	'Widget Set' => 'ウィジェットセット',
	'[_1] [_2] between [_3] and [_4]' => '[_2]が[_3]から[_4]の期間内の[_1]',
	'[_1] [_2] future' => '[_2]が未来の日付である[_1]',
	'[_1] [_2] or before [_3]' => '[_2]が[_3]より前の[_1]',
	'[_1] [_2] past' => '[_2]が過去の日付である[_1]',
	'[_1] [_2] since [_3]' => '[_2]が[_3]より後の[_1]',
	'[_1] [_2] these [_3] days' => '[_2]が[_3]日以内の[_1]',
	'[_1] [_3] [_2]' => '[_1] [_3] [_2]',
	'[_1] of this Site' => 'このサイトの[_1]',
	'option is required' => '条件は必須です。',
	'tar.gz' => 'tar.gz',
	'zip' => 'zip',
	q{This is often 'localhost'.} => q{通常「localhost」のままで構いません。},

## lib/MT/DataAPI/Callback/Blog.pm
	'Cannot apply website theme to blog: [_1]' => 'ウェブサイトテーマをブログに適用する事はできません: [_1]',
	'Invalid theme_id: [_1]' => '不正なtheme_idです: [_1]',
	'The website root directory must be an absolute path: [_1]' => 'ウェブサイトパスは、絶対パスでなければなりません: [_1]',

## lib/MT/DataAPI/Callback/Category.pm
	'Parent [_1] (ID:[_2]) not found.' => 'ID: [_2] という[_1]は存在しません。',
	q{The label '[_1]' is too long.} => q{ラベル '[_1]'は、長すぎます。},

## lib/MT/DataAPI/Callback/CategorySet.pm
	'Name "[_1]" is used in the same site.' => '"[_1]"はすでに存在します。',

## lib/MT/DataAPI/Callback/ContentData.pm
	'"[_1]" is required.' => '"[_1]"は必須です。',
	'There is an invalid field data: [_1]' => '不正なフィールドデータです: [_1]',

## lib/MT/DataAPI/Callback/ContentField.pm
	'A parameter "[_1]" is invalid: [_2]' => 'パラメータ"[_1]"が不正です: [_2]',
	'Invalid option key(s): [_1]' => '不正なオプションキーです: [_1]',
	'Invalid option(s): [_1]' => '不正なオプションです: [_1]',
	'options_validation_handler of "[_1]" type is invalid' => '"[_1]"のバリデーションハンドラーが不正です',

## lib/MT/DataAPI/Callback/Group.pm
	'A parameter "[_1]" is invalid.' => '"[_1]"は不正なパラメータです。',

## lib/MT/DataAPI/Callback/Log.pm
	'author_id (ID:[_1]) is invalid.' => 'author_id (ID:[_1])は不正です。',
	'log' => 'ログ',
	q{Log (ID:[_1]) deleted by '[_2]'} => q{'[_2]'がログ (ID:[_1])を削除しました。},

## lib/MT/DataAPI/Callback/Tag.pm
	'Invalid tag name: [_1]' => '不正なタグ名です: [_1]',

## lib/MT/DataAPI/Callback/TemplateMap.pm
	'Invalid archive type: [_1]' => '不正なアーカイブタイプです: [_1]',

## lib/MT/DataAPI/Callback/User.pm
	'Invalid dateFormat: [_1]' => '不正な日付の形式です: [_1]',
	'Invalid textFormat: [_1]' => '不正なテキストフォーマットです: [_1]',

## lib/MT/DataAPI/Endpoint/Auth.pm
	q{Failed login attempt by user who does not have sign in permission via data api. '[_1]' (ID:[_2])} => q{Data API でのサインイン権限を有しないユーザー '[_1]' (ID: [_2])がサインインを試みましたが失敗しました。},
	q{User '[_1]' (ID:[_2]) logged in successfully via data api.} => q{ユーザー '[_1]' (ID: [_2])が Data API でサインインしました。},

## lib/MT/DataAPI/Endpoint/Common.pm
	'Invalid dateFrom parameter: [_1]' => 'dateFrom パラメータに無効な値が指定されました: [_1]',
	'Invalid dateTo parameter: [_1]' => 'dateTo パラメータに無効な値が指定されました: [_1]',

## lib/MT/DataAPI/Endpoint/v2/Asset.pm
	'Invalid height: [_1]' => '不正な高さが指定されました: [_1]',
	'Invalid scale: [_1]' => '不正なスケールが指定されました: [_1]',
	'Invalid width: [_1]' => '不正な幅が指定されました: [_1]',
	'The asset does not support generating a thumbnail file.' => 'このアセットはサムネイルを作成できません。',

## lib/MT/DataAPI/Endpoint/v2/BackupRestore.pm
	'An error occurred during the backup process: [_1]' => 'バックアップの途中でエラーが発生しました: [_1]',
	'An error occurred during the restore process: [_1] Please check activity log for more details.' => '復元の過程でエラーが発生しました。[_1] 詳細についてはログを確認してください。',
	'Invalid backup_archive_format: [_1]' => '不正なアーカイブ形式が指定されました: [_1]',
	'Invalid backup_what: [_1]' => '不正なIDが指定されました: [_1]',
	'Invalid limit_size: [_1]' => '不正なファイルリミットが指定されました: [_1]',
	'Temporary directory needs to be writable for backup to work correctly.  Please check (Export)TempDir configuration directive.' => 'バックアップするにはテンポラリディレクトリに書き込みできなければなりません。(Export)TempDirの設定を確認してください。',
	q{Make sure that you remove the files that you restored from the 'import' folder, so that if/when you run the restore process again, those files will not be re-restored.} => q{再度復元を行う際に同じファイルから復元しないよう、importフォルダからファイルを削除してください。},

## lib/MT/DataAPI/Endpoint/v2/Blog.pm
	'Cannot create a blog under blog (ID:[_1]).' => 'ブログ(ID:[_1])の下にブログを作成する事はできません。',
	'Either parameter of "url" or "subdomain" is required.' => '"url"または"subdomain"パラメータのいずれかを指定する必要があります。',
	'Site not found' => 'ウェブサイトが見つかりません',
	'Website "[_1]" (ID:[_2]) was not deleted. You need to delete the blogs under the website first.' => 'ウェブサイト "[_1]" (ID:[_2]) を削除できません。ウェブサイト内のブログを先に削除する必要があります。',

## lib/MT/DataAPI/Endpoint/v2/Category.pm
	'Loading object failed: [_1]' => 'オブジェクトのロードに失敗しました: [_1]',
	'[_1] not found' => '[_1]が見つかりません',

## lib/MT/DataAPI/Endpoint/v2/Entry.pm
	'A resource "[_1]" is required.' => '"[_1]"リソースを指定する必要があります。',
	'An error occurred during the import process: [_1]. Please check your import file.' => 'インポートの途中でエラーが発生しました : [_1]。インポートファイルを確認してください。',
	'Could not found archive template for [_1].' => '[_1]のアーカイブテンプレートが見つかりません。',
	'Invalid convert_breaks: [_1]' => '不正なテキストフォーマットが指定されました: [_1]',
	'Invalid default_cat_id: [_1]' => '不正な規定のカテゴリーIDが指定されました: [_1]',
	'Invalid encoding: [_1]' => '不正な文字コードが指定されました: [_1]',
	'Invalid import_type: [_1]' => '不正なインポート元が指定されました] [_1]',
	'Preview data not found.' => 'プレビューするデータが存在しません。',
	'You need to provide a parameter "password" if you are going to create new users for each user listed in your blog.' => 'ブログにユーザーを追加するためには、パスワードを指定する必要があります。',
	q{Make sure that you remove the files that you imported from the 'import' folder, so that if/when you run the import process again, those files will not be re-imported.} => q{'import'ディレクトリからインポートしたファイルを削除することを忘れないでください。もう一度インポート機能を利用した場合に、同じファイルが再度インポートされてしまう可能性があります。},

## lib/MT/DataAPI/Endpoint/v2/Group.pm
	'A resource "member" is required.' => 'member を指定する必要があります。',
	'Adding member to group failed: [_1]' => 'グループメンバーの追加に失敗しました: [_1]',
	'Cannot add member to inactive group.' => '有効ではないグループへメンバーの追加はできません。',
	'Creating group failed: ExternalGroupManagement is enabled.' => 'ExternalGroupManagementが有効になっている場合は、新しいグループを作成する事はできません。',
	'Group not found' => 'グループが見つかりません',
	'Member not found' => 'グループメンバーが見つかりません',
	'Removing member from group failed: [_1]' => 'グループメンバーの削除に失敗しました: [_1]',

## lib/MT/DataAPI/Endpoint/v2/Log.pm
	'Log message' => 'ログ',

## lib/MT/DataAPI/Endpoint/v2/Page.pm
	q{'folder' parameter is invalid.} => q{'folder'パラメータが不正です。},

## lib/MT/DataAPI/Endpoint/v2/Permission.pm
	'Association not found' => '権限が見つかりません',
	'Granting permission failed: [_1]' => '権限の付与ができませんでした: [_1]',
	'Revoking permission failed: [_1]' => '権限の削除ができませんでした[ [_1]',
	'Role not found' => '指定されたロールが見つかりません',

## lib/MT/DataAPI/Endpoint/v2/Plugin.pm
	'Plugin not found' => '指定されたプラグインが見つかりません',

## lib/MT/DataAPI/Endpoint/v2/Tag.pm
	'Cannot delete private tag associated with objects in system scope.' => 'システムで利用されているプライベートタグは削除できません。',
	'Cannot delete private tag in system scope.' => 'システムで利用されているプライベートタグは削除できません。',
	'Tag not found' => '指定されたタグが見つかりません',

## lib/MT/DataAPI/Endpoint/v2/Template.pm
	'A parameter "refresh_type" is invalid: [_1]' => '不正な初期化方法が指定されました: [_1]',
	'A resource "template" is required.' => '"template" リソースの指定は必須です。',
	'Cannot clone [_1] template.' => '指定されたテンプレートは複製できません: [_1]',
	'Cannot delete [_1] template.' => '指定されたテンプレートは削除できません: [_1]',
	'Cannot get [_1] template.' => '指定されたテンプレートが取得できません: [_1]',
	'Cannot preview [_1] template.' => '指定されたテンプレートはプレビューできません: [_1]',
	'Cannot publish [_1] template.' => '指定されたテンプレートは公開できません: [_1]',
	'Cannot refresh [_1] template.' => '指定されたテンプレートはリフレッシュできません: [_1]',
	'Cannot update [_1] template.' => '指定されたテンプレートは更新できません: [_1]',
	'Template not found' => '指定されたテンプレートが見つかりません',

## lib/MT/DataAPI/Endpoint/v2/TemplateMap.pm
	'Template "[_1]" is not an archive template.' => 'テンプレート "[_1]" はアーカイブテンプレートではありません。',

## lib/MT/DataAPI/Endpoint/v2/Theme.pm
	'Applying theme failed: [_1]' => 'テーマの適用に失敗しました: [_1]',
	'Cannot apply website theme to blog.' => 'ウェブサイトテーマをブログに適用出来ません。',
	'Cannot uninstall theme because the theme is in use.' => '現在利用中のテーマをアンインストールすることはできません。',
	'Cannot uninstall this theme.' => 'テーマのアンインストールに失敗しました。',
	'Changing site theme failed: [_1]' => 'テーマの変更に失敗しました: [_1]',
	'Unknown archiver type: [_1]' => '不明なアーカイブタイプです: [_1]',
	'theme_id may only contain letters, numbers, and the dash or underscore character. The theme_id must begin with a letter.' => 'テーマIDには、アルファベット、数字、ダッシュ(-)、アンダースコア(_)のみ利用可能です。また、かならずアルファベットで始めてください。',
	'theme_version may only contain letters, numbers, and the dash or underscore character.' => 'バージョンにはアルファベット、数字、ダッシュ(-)、アンダースコア(_)が利用できます。',
	q{Cannot install new theme with existing (and protected) theme's basename: [_1]} => q{保護されたテーマがすでに存在するため、新しいテーマをインストールできません: [_1]},
	q{Export theme folder already exists '[_1]'. You can overwrite an existing theme with 'overwrite_yes=1' parameter, or change the Basename.} => q{エクスポート先のフォルダ'[_1]'がすでに存在します。既存のフォルダを上書きする場合は、'overwrite_yes'パラメータに1を指定するか、ベースネームを変えてください。},

## lib/MT/DataAPI/Endpoint/v2/User.pm
	'An email with a link to reset your password has been sent to your email address ([_1]).' => '「[_1]」にパスワードをリセットするためのリンクを含むメールを送信しました。',
	'The email address provided is not unique. Please enter your username by "name" parameter.' => '同じメールアドレスを持っているユーザーがいます。"name"パラメータにユーザー名を指定してください。',

## lib/MT/DataAPI/Endpoint/v2/Widget.pm
	'Removing Widget failed: [_1]' => 'ウィジェットの削除に失敗しました: [_1]',
	'Widget not found' => '指定されたウィジェットが見つかりません',
	'Widgetset not found' => '指定されたウィジェットセットが見つかりません',

## lib/MT/DataAPI/Endpoint/v2/WidgetSet.pm
	'A resource "widgetset" is required.' => 'widgetset が必要です。',
	'Removing Widgetset failed: [_1]' => 'ウィジェットセットの削除に失敗しました: [_1]',

## lib/MT/DataAPI/Endpoint/v4/ContentField.pm
	'A parameter "content_fields" is invalid.' => 'パラメータ "content_fields"が不正です。',
	'A parameter "content_fields" is required.' => 'パラメータ "content_fields"は必須です。',

## lib/MT/DataAPI/Resource.pm
	'Cannot parse "[_1]" as an ISO 8601 datetime' => '"[_1]"は、ISO 8601形式のデータではありません',

## lib/MT/DefaultTemplates.pm
	'About This Page' => 'About',
	'Archive Index' => 'アーカイブインデックス',
	'Archive Widgets Group' => 'アーカイブウィジェットグループ',
	'Blog Index' => 'ブログ・インデックス',
	'Calendar' => 'カレンダー',
	'Category Entry Listing' => 'カテゴリ別記事リスト',
	'Comment Form' => 'コメント入力フォーム',
	'Creative Commons' => 'クリエイティブ・コモンズ',
	'Current Author Monthly Archives' => 'ユーザー月別アーカイブ',
	'Date-Based Author Archives' => '日付ベースのユーザーアーカイブ',
	'Date-Based Category Archives' => '日付ベースのカテゴリアーカイブ',
	'Displays errors for dynamically-published templates.' => 'ダイナミックパブリッシングのエラーを表示します。',
	'Displays image when user clicks a popup-linked image.' => 'ポップアップ画像を表示します。',
	'Displays results of a search for content data.' => '検索結果を表示します。',
	'Displays results of a search.' => '検索結果を表示します。',
	'Dynamic Error' => 'ダイナミックパブリッシングエラー',
	'Entry Notify' => '記事の共有',
	'Feed - Recent Entries' => '最新記事のフィード',
	'Home Page Widgets Group' => 'ホームページウィジェットグループ',
	'IP Address Lockout' => 'IPアドレスのロック通知',
	'JavaScript' => 'JavaScript',
	'Monthly Archives Dropdown' => '月別アーカイブ(ドロップダウン)',
	'Monthly Entry Listing' => '月別記事リスト',
	'Navigation' => 'ナビゲーション',
	'OpenID Accepted' => 'OpenID対応',
	'Page Listing' => 'ページ一覧',
	'Popup Image' => 'ポップアップ画像',
	'Powered By' => 'Powered By',
	'RSD' => 'RSD',
	'Search Results for Content Data' => 'コンテンツの検索結果',
	'Stylesheet' => 'スタイルシート',
	'Syndication' => '購読',
	'User Lockout' => 'ユーザーアカウントのロック通知',

## lib/MT/Entry.pm
	'-' => '-',
	'Accept Comments' => 'コメントを許可',
	'Accept Trackbacks' => 'トラックバックを許可',
	'Author ID' => 'ユーザーID',
	'Body' => '本文',
	'Draft Entries' => '下書きの記事',
	'Draft' => '下書き',
	'Entries by [_1]' => '[_1]の記事',
	'Entries in This Site' => 'このサイトの記事',
	'Extended' => '続き',
	'Format' => 'フォーマット',
	'Future' => '日時指定',
	'Invalid arguments. They all need to be saved MT::Asset objects.' => 'アセットオブジェクトを指定する必要があります。',
	'Invalid arguments. They all need to be saved MT::Category objects.' => 'カテゴリオブジェクトを指定する必要があります。',
	'Junk' => 'スパム',
	'My Entries' => '自分の記事',
	'NONE' => 'なし',
	'Primary Category' => 'メインカテゴリ',
	'Published Entries' => '公開されている記事',
	'Published' => '公開',
	'Review' => '承認待ち',
	'Reviewing' => '承認待ち',
	'Scheduled Entries' => '日時指定されている記事',
	'Scheduled' => '日時指定',
	'Spam' => 'スパム',
	'Unpublished (End)' => '非公開（公開終了）',
	'Unpublished Entries' => '公開が終了している記事',
	'View [_1]' => '[_1]を見る',
	q{Entries from category: [_1]} => q{カテゴリ '[_1]'の記事},

## lib/MT/FileMgr/DAV.pm
	'DAV connection failed: [_1]' => 'DAV connectionに失敗しました: [_1]',
	'DAV get failed: [_1]' => 'DAV getに失敗しました: [_1]',
	'DAV open failed: [_1]' => 'DAV openに失敗しました: [_1]',
	'DAV put failed: [_1]' => 'DAV putに失敗しました: [_1]',
	q{Creating path '[_1]' failed: [_2]} => q{パス'[_1]'の作成に失敗しました: [_2]},
	q{Deleting '[_1]' failed: [_2]} => q{'[_1]'を削除できませんでした: [_2]},
	q{Renaming '[_1]' to '[_2]' failed: [_3]} => q{'[_1]'を'[_2]'に変更できませんでした: [_3]},

## lib/MT/FileMgr/SFTP.pm
	'SFTP connection failed: [_1]' => 'SFTPの接続に失敗しました: [_1]',
	'SFTP get failed: [_1]' => 'SFTPでGETに失敗しました: [_1]',
	'SFTP put failed: [_1]' => 'SFTPでPUTに失敗しました: [_1]',

## lib/MT/Filter.pm
	'"editable_terms" and "editable_filters" cannot be specified at the same time.' => '"editable_terms"と"editable_filters"は、同時に指定できません。',
	'Invalid filter type [_1]:[_2]' => '不正なフィルタタイプです。[_1]:[_2]',
	'Invalid sort key [_1]:[_2]' => '不正ななソートキーです。[_1]:[_2]',

## lib/MT/Group.pm
	'Active Groups' => '有効なグループ',
	'Disabled Groups' => '無効なグループ',
	'Email' => 'メール',
	'Groups associated with author: [_1]' => 'ユーザー[_1]と関連付けられたグループ',
	'Inactive' => '有効ではない',
	'Members of group: [_1]' => 'グループ [_1]のメンバー',
	'My Groups' => '自分のグループ',
	'__COMMENT_COUNT' => 'コメント数',
	'__GROUP_MEMBER_COUNT' => 'メンバー数',

## lib/MT/IPBanList.pm
	'IP Ban' => '禁止IPリスト',
	'IP Bans' => '禁止IPリスト',

## lib/MT/Image.pm
	'File size exceeds maximum allowed: [_1] > [_2]' => 'ファイルのサイズ制限を超えています。([_1] > [_2])',
	'Invalid Image Driver [_1]' => '不正なイメージドライバーです:[_1]',
	'Saving [_1] failed: Invalid image file format.' => '[_1]を保存できませんでした: 画像ファイルフォーマットが不正です。',

## lib/MT/Image/GD.pm
	'Cannot load GD: [_1]' => 'GDをロードできませんでした: [_1]',
	'Reading image failed: [_1]' => '画像を読み取れませんでした: [_1]',
	'Rotate (degrees: [_1]) is not supported' => '画像を回転([_1]度)させる事が出来ません。',
	'Unsupported image file type: [_1]' => '[_1]は画像タイプとしてサポートされていません。',
	q{Reading file '[_1]' failed: [_2]} => q{ファイル '[_1]' を読み取れませんでした: [_2]},

## lib/MT/Image/ImageMagick.pm
	'Cannot load [_1]: [_2]' => '[_1]をロードできません: [_2]',
	'Converting image to [_1] failed: [_2]' => '画像を[_1]に変換できませんでした: [_2]',
	'Cropping a [_1]x[_2] square at [_3],[_4] failed: [_5]' => '[_1]x[_2] (X:[_3] / Y:[_4]) にトリミングできませんでした: [_5]',
	'Flip horizontal failed: [_1]' => '画像を水平反転させることができませんでした: [_1]',
	'Flip vertical failed: [_1]' => '画像を垂直反転させることができませんでした: [_1]',
	'Outputting image failed: [_1]' => '画像を出力できませんでした: [_1]',
	'Rotate (degrees: [_1]) failed: [_2]' => '画像を回転([_1]度)させることができませんでした: [_2]',
	'Scaling to [_1]x[_2] failed: [_3]' => 'サイズを[_1]x[_2]に変更できませんでした: [_3]',

## lib/MT/Image/Imager.pm
	'Cannot load Imager: [_1]' => 'Imagerをロードできません: [_1]',

## lib/MT/Image/NetPBM.pm
	'Cannot load IPC::Run: [_1]' => 'IPC::Runをロードできません: [_1]',
	'Cropping to [_1]x[_2] failed: [_3]' => '[_1]x[_2] にトリミングできませんでした: [_3]',
	'Reading alpha channel of image failed: [_1]' => 'アルファチャンネルを読み込めませんでした: [_1]',
	'You do not have a valid path to the NetPBM tools on your machine.' => 'NetPBMツールへのパスが正しく設定されていません。',

## lib/MT/Import.pm
	'Another system (Movable Type format)' => '他のシステム(Movable Type形式)',
	'Could not resolve import format [_1]' => 'インポート形式[_1]を処理できませんでした。',
	'File not found: [_1]' => 'ファイルが見つかりません: [_1]',
	'No readable files could be found in your import directory [_1].' => '読み取れないファイルがありました: [_1]',
	q{Cannot open '[_1]': [_2]} => q{'[_1]'を開けません: [_2]},
	q{Importing entries from file '[_1]'} => q{ファイル'[_1]'からインポートしています。},

## lib/MT/ImportExport.pm
	'Need either ImportAs or ParentAuthor' => '「自分の記事としてインポートする」か「記事の著者を変更しない」のどちらかを選択してください。',
	'No Blog' => 'ブログがありません。',
	'Saving category failed: [_1]' => 'カテゴリを保存できませんでした: [_1]',
	'Saving entry failed: [_1]' => '記事を保存できませんでした: [_1]',
	'Saving user failed: [_1]' => 'ユーザーを作成できませんでした: [_1]',
	'You need to provide a password if you are going to create new users for each user listed in your blog.' => 'ブログにユーザーを追加するためには、パスワードを指定する必要があります。',
	'ok (ID [_1])' => '完了 (ID [_1])',
	q{Cannot find existing entry with timestamp '[_1]'... skipping comments, and moving on to next entry.} => q{タイムスタンプ'[_1]'に合致する記事が見つかりません。コメントの処理を中止して次の記事へ進みます。},
	q{Creating new category ('[_1]')...} => q{カテゴリ([_1])を作成しています...},
	q{Creating new user ('[_1]')...} => q{ユーザー([_1])を作成しています...},
	q{Export failed on entry '[_1]': [_2]} => q{エクスポートに失敗しました。記事'[_1]': [_2]},
	q{Importing into existing entry [_1] ('[_2]')} => q{既存の記事[_1]([_2])にインポートしています。},
	q{Invalid allow pings value '[_1]'} => q{トラックバックの受信設定の値'[_1]'が不正です。},
	q{Invalid date format '[_1]'; must be 'MM/DD/YYYY HH:MM:SS AM|PM' (AM|PM is optional)} => q{日付の形式'[_1]'が正しくありません。'MM/DD/YYYY HH:MM:SS AM|PM' (AM|PMは任意)でなければなりません。},
	q{Invalid status value '[_1]'} => q{状態[_1]は正しくありません},
	q{Saving entry ('[_1]')...} => q{記事([_1])を保存しています...},

## lib/MT/JunkFilter.pm
	'Action: Junked (score below threshold)' => '結果: スパム(スコアがしきい値以下)',
	'Action: Published (default action)' => '結果: 公開(既定)',
	'Composite score: [_1]' => '合計点: [_1]',
	'Unnamed Junk Filter' => '(名前なし)',
	q{Junk Filter [_1] died with: [_2]} => q{フィルタ'[_1]'でエラーがありました: [_2]},

## lib/MT/ListProperty.pm
	'Cannot initialize list property [_1].[_2].' => '初期化に失敗しました。[_1].[_2]',
	'Failed to initialize auto list property [_1].[_2]: Cannot find definition of column [_3].' => 'リストプロパティ[_1].[_2]の初期化に失敗しました: [_3]というカラムは見つかりません。',
	'Failed to initialize auto list property [_1].[_2]: unsupported column type.' => 'リストプロパティ[_1].[_2]の初期化に失敗しました: 未サポートのカラム型です。',
	'[_1] (id:[_2])' => '[_1] (ID:[_2])',

## lib/MT/Lockout.pm
	'IP Address Was Locked Out' => 'IPアドレスがロックされました',
	'IP address was locked out. IP address: [_1], Username: [_2]' => 'IPアドレス: [_1]からのアクセスがロックされました。(ユーザー: [_2])',
	'User Was Locked Out' => 'ユーザーアカウントがロックされました',
	'User has been unlocked. Username: [_1]' => 'ユーザー: [_1] のアカウントロックが解除されました',
	'User was locked out. IP address: [_1], Username: [_2]' => 'ユーザー: [_2] のアカウントがロックされました。IPアドレス: [_1]',

## lib/MT/Log.pm
	'By' => 'ユーザー',
	'Class' => '分類',
	'Comment # [_1] not found.' => 'ID:[_1]のコメントが見つかりませんでした。',
	'Debug' => 'デバッグ',
	'Debug/error' => 'デバッグ/エラー',
	'Entry # [_1] not found.' => 'ID:[_1]の記事が見つかりませんでした。',
	'Information' => '情報',
	'Level' => 'レベル',
	'Log messages' => 'ログ',
	'Logs on This Site' => 'このサイトのログ',
	'Message' => 'ログ',
	'Metadata' => 'メタデータ',
	'Not debug' => 'デバッグを含まない',
	'Notice' => '有意な情報',
	'Page # [_1] not found.' => 'ID:[_1]のウェブページが見つかりませんでした。',
	'Security or error' => 'セキュリティまたはエラー',
	'Security' => 'セキュリティ',
	'Security/error/warning' => 'セキュリティ/エラー/警告',
	'Show only errors' => 'エラーだけを表示',
	'TrackBack # [_1] not found.' => 'ID:[_1]のトラックバックが見つかりませんでした。',
	'TrackBacks' => 'トラックバック',
	'Warning' => '警告',
	'author' => 'ユーザー',
	'folder' => 'フォルダ',
	'page' => 'ウェブページ',
	'ping' => 'トラックバック',
	'plugin' => 'プラグイン',
	'search' => '検索',
	'theme' => 'テーマ',

## lib/MT/Mail.pm
	'Authentication failure: [_1]' => '認証に失敗しました: [_1]',
	'Error connecting to SMTP server [_1]:[_2]' => 'SMTPサーバに接続できません。[_1]:[_2]',
	'Exec of sendmail failed: [_1]' => 'sendmailを実行できませんでした: [_1]',
	'Following required module(s) were not found: ([_1])' => '以下のモジュールが不足しています。([_1])',
	'Username and password is required for SMTP authentication.' => 'SMTP認証を利用する場合は、ユーザー名とパスワードは必須入力です。',
	'You do not have a valid path to sendmail on your machine. Perhaps you should try using SMTP?' => 'sendmailへのパスが正しくありません。SMTPの設定を試してください。',
	q{Unknown MailTransfer method '[_1]'} => q{MailTransferの設定([_1])が不正です。},

## lib/MT/Mail/MIME.pm
	'An error occured during sending mail' => 'メール送信中にエラーが発生しました',
	'MailTransferEncoding was auto detected because an invalid value was given.' => 'MailTransferEncoding の値が不正です。送信時に機械的に修正しました。',

## lib/MT/Notification.pm
	'Cancel' => 'キャンセル',
	'Click to edit contact' => 'クリックして連絡先を編集',
	'Contacts' => '連絡先',
	'Save Changes' => '変更を保存',

## lib/MT/Object.pm
	'An error occurred while saving changes to the database.' => 'データベースへの保存中にエラーが発生しました。',

## lib/MT/ObjectAsset.pm
	'Asset Placement' => 'アセットの関連付け',

## lib/MT/ObjectCategory.pm
	'Category Placement' => 'カテゴリの関連付け',
	'Category Placements' => 'カテゴリの関連付け',

## lib/MT/ObjectScore.pm
	'Object Score' => 'オブジェクトのスコア',
	'Object Scores' => 'オブジェクトのスコア',

## lib/MT/ObjectTag.pm
	'Tag Placement' => 'タグの関連付け',
	'Tag Placements' => 'タグの関連付け',

## lib/MT/Page.pm
	'(root)' => '(root)',
	'Draft Pages' => '下書きのウェブページ',
	'Loading blog failed: [_1]' => 'ブログをロードできませんでした: [_1]',
	'My Pages' => '自分のウェブページ',
	'Pages in This Site' => 'このサイトのウェブページ',
	'Published Pages' => '公開されているウェブページ',
	'Scheduled Pages' => '日時指定されているウェブページ',
	'Unpublished Pages' => '公開が終了しているウェブページ',
	q{Pages in folder: [_1]} => q{フォルダ '[_1]'に含まれるページ},

## lib/MT/ParamValidator.pm
	'Invalid validation rules: [_1]' => '不正な検証規則です: [_1]',
	'Unknown validation rule: [_1]' => '未知の検証規則です: [_1]',
	q{'[_1]' has multiple values} => q{'[_1]' に複数の値があります},
	q{'[_1]' is required} => q{'[_1]' が必要です},
	q{'[_1]' requires a valid ID} => q{'[_1]' には有効なIDが必要です},
	q{'[_1]' requires a valid email} => q{'[_1]' には有効なメールアドレスが必要です},
	q{'[_1]' requires a valid integer} => q{'[_1]' には有効な整数が必要です},
	q{'[_1]' requires a valid number} => q{'[_1]' には有効な数値が必要です},
	q{'[_1]' requires a valid objtype} => q{'[_1]' には有効なオブジェクト種別が必要です},
	q{'[_1]' requires a valid string} => q{'[_1]' には有効な文字列が必要です},
	q{'[_1]' requires a valid text} => q{'[_1]' には有効なテキストが必要です},
	q{'[_1]' requires a valid word} => q{'[_1]' には有効な単語が必要です},
	q{'[_1]' requires a valid xdigit value} => q{'[_1]' には有効な16進数が必要です},
	q{'[_1]' requires valid (concatenated) IDs} => q{'[_1]' には有効なID(を連結したもの)が必要です},
	q{'[_1]' requires valid (concatenated) words} => q{'[_1]' には有効な単語(を連結したもの)が必要です},

## lib/MT/Plugin.pm
	'My Text Format' => 'My Text Format',

## lib/MT/Plugin/JunkFilter.pm
	'[_1]: [_2][_3] from rule [_4][_5]' => '[_1]: ルール[_4][_5]による判定スコア - [_2][_3]',
	'[_1]: [_2][_3] from test [_4]' => '[_1]: 検査[_4]による判定スコア - [_2][_3]',

## lib/MT/PluginData.pm
	'Plugin Data' => 'プラグインデータ',

## lib/MT/RebuildTrigger.pm
	'Restoring Rebuild Trigger for Content Type #[_1]...' => 'コンテンツタイプ (ID: [_1])の再構築トリガーを復元しています...',
	'Restoring rebuild trigger for blog #[_1]...' => 'サイト (ID: [_1])の再構築トリガーを復元しています...',

## lib/MT/Revisable.pm
	'Did not get two [_1]' => '二つの[_1]を取得できませんでした。',
	'Revision Number' => '更新履歴番号',
	'Revision not found: [_1]' => '更新履歴がありません: [_1]',
	'There are not the same types of objects, expecting two [_1]' => '同じ種類のオブジェクトではありません。両者とも[_1]である必要があります。',
	'Unknown method [_1]' => '不正な比較メソッド([_1])です。',
	q{Bad RevisioningDriver config '[_1]': [_2]} => q{リビジョンドライバー([_1])の設定が正しくありません: [_2]},

## lib/MT/Role.pm
	'Can administer the site.' => 'サイトを管理できます',
	'Can create entries, edit their own entries, and comment.' => '記事の作成、各自の記事とコメントを編集できます。',
	'Can create entries, edit their own entries, upload files and publish.' => '記事を作成し、各自の記事の編集とファイルのアップロード、およびそれらを公開できます。',
	'Can edit, manage, and publish blog templates and themes.' => 'テンプレートとテーマの編集と管理、及びそれらの公開ができます。',
	'Can manage content types, content data and category sets.' => 'コンテンツタイプ、コンテンツデータ、カテゴリセットの編集と管理ができます。',
	'Can manage pages, upload files and publish site/child site templates.' => 'ページの管理、ファイルのアップロード、サイトのテンプレートを公開できます。',
	'Can upload files, edit all entries(categories), pages(folders), tags and publish the site.' => 'ファイルをアップロードし、記事(カテゴリ)、ウェブページ(フォルダ)、タグを編集して公開できます。',
	'Content Designer' => 'コンテンツデザイナ',
	'Contributor' => 'ライター',
	'Designer' => 'デザイナ',
	'Editor' => '編集者',
	'Site Administrator' => 'サイト管理者',
	'Webmaster' => 'ウェブマスター',
	'__ROLE_ACTIVE' => '利用中',
	'__ROLE_INACTIVE' => '利用されていない',
	'__ROLE_STATUS' => '利用状況',

## lib/MT/Scorable.pm
	'Already scored for this object.' => 'すでに1度評価しています。',
	'Object must be saved first.' => 'オブジェクトが保存されていません。',
	q{Could not set score to the object '[_1]'(ID: [_2])} => q{[_1](ID: [_2])にスコアを設定できませんでした。},

## lib/MT/Session.pm
	'Session' => 'セッション',

## lib/MT/Tag.pm
	'Not Private' => 'プライベートではない',
	'Private' => 'プライベート',
	'Tag must have a valid name' => 'タグの名前が不正です。',
	'Tags with Assets' => 'アセットのタグ',
	'Tags with Entries' => '記事のタグ',
	'Tags with Pages' => 'ウェブページのタグ',
	'This tag is referenced by others.' => 'このタグは他のタグから参照されています。',

## lib/MT/TaskMgr.pm
	'Scheduled Tasks Update' => 'スケジュールされたタスク',
	'The following tasks were run:' => '以下のタスクを実行しました:',
	'Unable to secure a lock for executing system tasks. Make sure your TempDir location ([_1]) is writable.' => 'タスクを実行するために必要なロックを獲得できませんでした。TempDir([_1])に書き込みできるかどうか確認してください。',
	q{Error during task '[_1]': [_2]} => q{'[_1]'の実行中にエラーが発生しました: [_2]},

## lib/MT/Template.pm
	'Build Type' => '構築タイプ',
	'Category Archive' => 'カテゴリアーカイブ',
	'Comment Error' => 'コメントエラー',
	'Comment Listing' => 'コメント一覧',
	'Comment Pending' => 'コメント保留中',
	'Comment Preview' => 'コメントプレビュー',
	'Content Type is required.' => 'コンテンツタイプを指定する必要があります。',
	'Dynamicity' => 'ダイナミック',
	'Index' => 'インデックス',
	'Individual' => '記事',
	'Interval' => '間隔',
	'Module' => 'モジュール',
	'Output File' => '出力ファイル名',
	'Ping Listing' => 'トラックバック一覧',
	'Rebuild with Indexes' => 'インデックスの再構築',
	'Template Text' => 'テンプレート本文',
	'Template load error: [_1]' => 'テンプレートファイルの読み込みが出来ませんでした: [_1]',
	'Template name must be unique within this [_1].' => 'テンプレート名は[_1]で一意でなければなりません。',
	'Template' => 'テンプレート',
	'Uploaded Image' => '画像',
	'Widget' => 'ウィジェット',
	'You cannot use a [_1] extension for a linked file.' => '[_1]をリンクファイルの拡張子に使うことはできません。',
	q{Error reading file '[_1]': [_2]} => q{ファイル: [_1]を読み込めませんでした: [_2]},
	q{Opening linked file '[_1]' failed: [_2]} => q{リンクファイル'[_1]'を開けませんでした: [_2]},
	q{Publish error in template '[_1]': [_2]} => q{テンプレート「[_1]」の再構築中にエラーが発生しました: [_2]},
	q{Tried to load the template file from outside of the include path '[_1]'} => q{許可されない場所からテンプレートファイルを読み込もうとしました。'[_1]'},

## lib/MT/Template/Context.pm
	'No Category Set could be found.' => 'カテゴリセットが見つかりません。',
	'No Content Field could be found.' => 'コンテンツフィールドが見つかりません。',
	'No Content Field could be found: "[_1]"' => 'コンテンツフィールドが見つかりません: "[_1]"',
	'When the same blog IDs are simultaneously listed in the include_blogs and exclude_blogs attributes, those blogs are excluded.' => 'include_blogs属性とexclude_blogs属性に同じブログIDが指定されています。',
	q{The attribute exclude_blogs cannot take '[_1]' for a value.} => q{exclude_blogs属性には'[_1]'を設定できません。},
	q{You have an error in your '[_2]' attribute: [_1]} => q{[_2]属性でエラーがありました: [_1]},
	q{You used an '[_1]' tag inside of the context of a blog which has no parent website; Perhaps your blog record is broken?} => q{[_1]をウェブサイトに属していないブログのコンテキストで利用しようとしています。},
	q{You used an '[_1]' tag outside of the context of a author; Perhaps you mistakenly placed it outside of an 'MTAuthors' container tag?} => q{[_1]をコンテキスト外で利用しようとしています。MTAuthorsコンテナタグの外部で使っていませんか?},
	q{You used an '[_1]' tag outside of the context of a comment; Perhaps you mistakenly placed it outside of an 'MTComments' container tag?} => q{[_1]をコメントのコンテキスト外で利用しようとしました。MTCommentsコンテナの外部に配置していませんか?},
	q{You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?} => q{[_1]をコンテキスト外で利用しようとしています。MTContentsコンテナタグの外部で使っていませんか?},
	q{You used an '[_1]' tag outside of the context of a page; Perhaps you mistakenly placed it outside of a 'MTPages' container tag?} => q{[_1]をPageのコンテキスト外で利用しようとしました。MTPagesコンテナの外部に配置していませんか?},
	q{You used an '[_1]' tag outside of the context of a ping; Perhaps you mistakenly placed it outside of an 'MTPings' container tag?} => q{[_1]タグをトラックバックのコンテキスト外で利用しようとしました。MTPingsコンテナの外部に配置していませんか?},
	q{You used an '[_1]' tag outside of the context of an asset; Perhaps you mistakenly placed it outside of an 'MTAssets' container tag?} => q{[_1]をAssetのコンテキスト外で利用しようとしました。MTAssetsコンテナの外部に配置していませんか?},
	q{You used an '[_1]' tag outside of the context of an entry; Perhaps you mistakenly placed it outside of an 'MTEntries' container tag?} => q{[_1]をコンテキスト外で利用しようとしています。MTEntriesコンテナタグの外部で使っていませんか?},
	q{You used an '[_1]' tag outside of the context of the blog; Perhaps you mistakenly placed it outside of an 'MTBlogs' container tag?} => q{[_1]をコンテキスト外で利用しようとしています。MTBlogsコンテナタグの外部で使っていませんか?},
	q{You used an '[_1]' tag outside of the context of the site;} => q{[_1]をコンテキスト外で利用しようとしています。サイトの外部で使っていませんか?},
	q{You used an '[_1]' tag outside of the context of the website; Perhaps you mistakenly placed it outside of an 'MTWebsites' container tag?} => q{[_1]をコンテキスト外で利用しようとしています。MTWebsitesコンテナタグの外部で使っていませんか?},

## lib/MT/Template/ContextHandlers.pm
	', letters and numbers' => '、文字と数字を含む',
	', symbols (such as #!$%)' => '、記号を含む',
	', uppercase and lowercase letters' => '、大文字と小文字を含む',
	'Actions' => 'アクション',
	'All About Me' => 'All About Me',
	'Cannot load template' => 'テンプレートを読み込めません',
	'Cannot load user.' => 'ユーザーをロードできませんでした。',
	'Choose the display options for this content field in the listing screen.' => '一覧での表示について選択します。',
	'Default' => '既定値',
	'Display Options' => '表示オプション',
	'Division by zero.' => 'ゼロ除算エラー',
	'Error in [_1] [_2]: [_3]' => '[_1]「[_2]」でエラーが発生しました: [_3]',
	'Error in file template: [_1]' => 'ファイルテンプレートでエラーが発生しました: [_1]',
	'File inclusion is disabled by "AllowFileInclude" config directive.' => 'File モディファイアは、環境変数(AllowFileInclude)により無効にされています。',
	'Force' => '必ず表示',
	'Invalid index.' => '不正なインデックスです。',
	'Is this field required?' => 'このフィールドは必須ですか？',
	'No [_1] could be found.' => '[_1]が見つかりません。',
	'No template to include was specified' => 'インクルードするテンプレートが見つかりませんでした。',
	'Optional' => 'オプション',
	'Recursion attempt on [_1]: [_2]' => '[_1]でお互いがお互いを参照している状態になっています: [_2]',
	'Recursion attempt on file: [_1]' => '[_1]でお互いがお互いを参照している状態になっています。',
	'The entered message is displayed as a input field hint.' => '入力フィールドの説明として表示されます。',
	'Unspecified archive template' => 'アーカイブテンプレートが指定されていません。',
	'You used a [_1] tag without a valid name attribute.' => '[_1]タグではname属性は必須です。',
	'You used an [_1] tag without a date context set up.' => '[_1]を日付コンテキストの外部で利用しようとしました。',
	'You used an [_1] tag without a valid [_2] attribute.' => '[_1]タグでは[_2]属性は必須です。',
	'[_1] is not a hash.' => '[_1]はハッシュではありません。',
	'[_1]Publish[_2] your [_3] to see these changes take effect.' => '変更を反映するために、対象の[_3]を[_1]再構築[_2]してください。',
	'[_1]Publish[_2] your site to see these changes take effect, even when publishing profile is dynamic publishing.' => 'ダイナミック・パブリッシングを利用している場合でも、設定を反映するために[_1]再構築[_2]してください。',
	'[_1]Publish[_2] your site to see these changes take effect.' => '設定を有効にするために[_1]再構築[_2]してください。',
	'blog(s)' => 'ブログ',
	'https://www.movabletype.org/documentation/appendices/tags/%t.html' => 'https://www.movabletype.jp/documentation/appendices/tags/%t.html',
	'id attribute is required' => 'idモディファイアを指定する必要があります',
	'minimum length of [_1]' => '[_1]文字以上',
	'records' => 'オブジェクト',
	'website(s)' => 'ウェブサイト',
	q{'[_1]' is not a hash.} => q{[_1]はハッシュではありません。},
	q{'[_1]' is not a valid function for a hash.} => q{[_1]はハッシュで利用できる関数ではありません。},
	q{'[_1]' is not a valid function for an array.} => q{[_1]は配列で利用できる関数ではありません。},
	q{'[_1]' is not a valid function.} => q{[_1]という関数はサポートされていません。},
	q{'[_1]' is not an array.} => q{[_1]は配列ではありません。},
	q{'parent' modifier cannot be used with '[_1]'} => q{'parent'属性を[_1]属性と同時に指定することは出来ません。},
	q{Cannot find blog for id '[_1]} => q{ID:[_1]のブログが見つかりませんでした。},
	q{Cannot find entry '[_1]'} => q{'[_1]'という記事が見つかりませんでした。},
	q{Cannot find included file '[_1]'} => q{[_1]というファイルが見つかりませんでした。},
	q{Cannot find included template [_1] '[_2]'} => q{「[_2]」という[_1]テンプレートが見つかりませんでした。},
	q{Cannot find template '[_1]'} => q{'[_1]'というテンプレートが見つかりませんでした。},
	q{Error opening included file '[_1]': [_2]} => q{[_1]を開けませんでした: [_2]},

## lib/MT/Template/Tags/Archive.pm
	'Could not determine content' => 'コンテンツデータを取得できませんでした。',
	'Could not determine entry' => '記事を取得できませんでした。',
	'Group iterator failed.' => 'アーカイブのロードでエラーが発生しました。',
	'You used an [_1] tag outside of the proper context.' => '[_1]タグを不正なコンテキストで利用しようとしました。',
	'[_1] can be used only with Daily, Weekly, or Monthly archives.' => '[_1]は日別、週別、月別の各アーカイブでのみ利用できます。',
	q{You used an [_1] tag for linking into '[_2]' archives, but that archive type is not published.} => q{[_2]アーカイブにリンクするために[_1]タグを使っていますが、アーカイブを出力していません。},

## lib/MT/Template/Tags/Asset.pm
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score"を指定するときはnamespaceも指定しなければなりません。',
	q{No such user '[_1]'} => q{ユーザー([_1])が見つかりません。},

## lib/MT/Template/Tags/Author.pm
	'You used an [_1] without a author context set up.' => '[_1]をユーザーのコンテキスト外部で利用しようとしました。',
	q{The '[_2]' attribute will only accept an integer: [_1]} => q{[_2]属性は整数以外は無効です: [_1]},

## lib/MT/Template/Tags/Blog.pm
	'Unknown "mode" attribute value: [_1]. Valid values are "loop" and "context".' => 'mode属性[_1]が不正です。loopまたはcontextを指定してください。',

## lib/MT/Template/Tags/Calendar.pm
	'Invalid month format: must be YYYYMM' => 'YYYYMM形式でなければなりません。',
	'Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat' => 'Sun、Mon、Tue、Wed、Thu、Fri、Satのいずれかでなければなりません。',
	q{No such category '[_1]'} => q{[_1]というカテゴリはありません。},

## lib/MT/Template/Tags/Category.pm
	'Cannot find package [_1]: [_2]' => '[_1]というパッケージが見つかりませんでした: [_2]',
	'Cannot use sort_by and sort_method together in [_1]' => '[_1]ではsort_byとsort_methodは同時に利用できません。',
	'Error sorting [_2]: [_1]' => '[_2]の並べ替えでエラーが発生しました: [_1]',
	'MT[_1] must be used in a [_2] context' => 'MT[_1]は[_2]のコンテキスト外部では利用できません。',
	'[_1] cannot be used without publishing [_2] archive.' => '[_2]アーカイブを公開していないので[_1]は使えません。',
	'[_1] used outside of [_2]' => '[_1]を[_2]の外部で利用しようとしました。',

## lib/MT/Template/Tags/ContentType.pm
	'Content Type was not found. Blog ID: [_1]' => 'サイト (ID: [_1]) でコンテンツタイプが見つかりません。',
	'Invalid field_value_handler of [_1].' => '[_1] の field_value_handler は不正です。',
	'Invalid tag_handler of [_1].' => '[_1] の tag_handler は不正です。',
	'No Content Field Type could be found.' => 'コンテンツフィールドタイプが見つかりません。',

## lib/MT/Template/Tags/Entry.pm
	'Could not create atom id for entry [_1]' => '記事 [_1] のAtom IDを作成できませんでした。',
	'You used <$MTEntryFlag$> without a flag.' => '<$MTEntryFlag$>をフラグなしで利用しようとしました。',

## lib/MT/Template/Tags/Misc.pm
	q{Specified WidgetSet '[_1]' not found.} => q{ウィジェットセット「[_1]」が見つかりません。},

## lib/MT/Template/Tags/Tag.pm
	'content_type modifier cannot be used with type "[_1]".' => 'content_typeモディファイアは[_1]と同時に利用できません',

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
	'A fatal error occurred while applying element [_1]: [_2].' => '項目「[_1]」を適用する際に、重大なエラーが発生しました: [_2]',
	'An error occurred while applying element [_1]: [_2].' => '項目「[_1]」を適用する際に、エラーが発生しました: [_2]',
	'Default Content Data' => '既定のコンテンツデータ',
	'Default Pages' => '既定のページ',
	'Default Prefs' => '既定の設定',
	'Failed to copy file [_1]:[_2]' => '[_1]のコピーに失敗しました: [_2]',
	'Failed to load theme [_1].' => '[_1]テーマの読込に失敗しました。',
	'Static Files' => 'ファイル',
	'Template Set' => 'テンプレートセット',
	'There was an error converting image [_1].' => '画像の変換でエラーが発生しました: [_1]',
	'There was an error creating thumbnail file [_1].' => '画像のサムネイル作成でエラーが発生しました: [_1]',
	'There was an error scaling image [_1].' => '画像のサイズ変更でエラーが発生しました: [_1]',
	q{Component '[_1]' version [_2] or greater is needed to use this theme, but is not installed.} => q{このテーマには、次の項目の指定のバージョン以上が必要です。: [_1]: バージョン[_2]以上},
	q{Component '[_1]' version [_2] or greater is needed to use this theme, but the installed version is [_3].} => q{このテーマには、次の項目の指定のバージョン以上が必要です。: [_1]: バージョン[_2]以上 (インストール済みのバージョンは[_3])},
	q{Element '[_1]' cannot be applied because [_2]} => q{次の項目が適用できません: [_1] (原因: [_2])},

## lib/MT/Theme/Category.pm
	'Failed to save category_order: [_1]' => 'カテゴリの並び順を保存できません: [_1]',
	'Failed to save folder_order: [_1]' => 'フォルダの並び順を保存できません: [_1]',
	'[_1] top level and [_2] sub categories.' => 'トップレベルカテゴリ([_1])とサブカテゴリ([_2])',
	'[_1] top level and [_2] sub folders.' => 'トップレベルフォルダ([_1])とサブフォルダ([_2])',

## lib/MT/Theme/CategorySet.pm
	'[_1] category sets.' => '[_1]カテゴリセット',

## lib/MT/Theme/ContentData.pm
	'Failed to find content type: [_1]' => 'コンテンツタイプが見つかりません: [_1]',
	'Invalid theme_data_import_handler of [_1].' => '[_1] のtheme_data_import_handler は不正です',
	'[_1] content data.' => '[_1]コンテンツデータ',

## lib/MT/Theme/ContentType.pm
	'Invalid theme_import_handler of [_1].' => '[_1] のtheme_import_handler は不正です',
	'[_1] content types.' => '[_1]コンテンツタイプ',
	'some content field in this theme has invalid type.' => '不正なコンテンツフィールドタイプが指定されています。',
	'some content type in this theme have been installed already.' => 'いくつかのコンテンツタイプはすでに存在します。',

## lib/MT/Theme/Element.pm
	'Internal error: the importer is not found.' => '内部エラー : インポーターが見つかりません。',
	q{An Error occurred while applying '[_1]': [_2].} => q{[_1]の適用中にエラーが発生しました: [_2]。},
	q{Compatibility error occurred while applying '[_1]': [_2].} => q{次の項目の適用時にエラーが発生しました: [_1]: [_2]},
	q{Component '[_1]' is not found.} => q{次の項目が見つかりません: [_1]},
	q{Fatal error occurred while applying '[_1]': [_2].} => q{次の項目の適用時に重大なエラーが発生しました: [_1]: [_2]},
	q{Importer for '[_1]' is too old.} => q{次の項目のインポーターが古すぎます: [_1]},
	q{Theme element '[_1]' is too old for this environment.} => q{次の項目が、この環境では古すぎます: [_1]},

## lib/MT/Theme/Entry.pm
	'[_1] pages' => '[_1]ページ',

## lib/MT/Theme/Pref.pm
	'Failed to save blog object: [_1]' => 'ブログオブジェクトの保存に失敗しました。: [_1]',
	'default settings for [_1]' => '[_1]の既定の設定',
	'default settings' => '既定の設定',
	'this element cannot apply for non blog object.' => 'この要素はブログオブジェクト以外には適用できません。',

## lib/MT/Theme/TemplateSet.pm
	'A template set containing [quant,_1,template,templates], [quant,_2,widget,widgets], and [quant,_3,widget set,widget sets].' => 'テンプレートセット([_1]テンプレート, [_2]ウィジェット, [_3]ウィジェットセット)',
	'Failed to make templates directory: [_1]' => 'テンプレート用のディレクトリの作成に失敗しました: [_1]',
	'Failed to publish template file: [_1]' => 'テンプレートファイルの公開に失敗しました: [_1]',
	'Widget Sets' => 'ウィジェットセット',
	'exported_template set' => 'エクスポート済テンプレートセット',

## lib/MT/Upgrade.pm
	'Database has been upgraded to version [_1].' => 'データベースをバージョン[_1]にアップグレードしました。',
	'Error loading class [_1].' => '[_1]をロードできません。',
	'Error loading class: [_1].' => 'クラスをロードできませんでした: [_1]',
	'Error saving [_1] record # [_3]: [_2]...' => '[_1]のレコード(ID:[_3])を保存できませんでした: [_2]',
	'Invalid upgrade function: [_1].' => '不正なアップグレード機能を実行しようとしました: [_1]',
	'Upgrading database from version [_1].' => 'データベースをバージョン [_1]から更新しています...',
	'Upgrading table for [_1] records...' => '[_1]のテーブルを更新しています...',
	q{Plugin '[_1]' installed successfully.} => q{プラグイン'[_1]'をインストールしました。},
	q{Plugin '[_1]' upgraded successfully to version [_2] (schema version [_3]).} => q{プラグイン'[_1]'をバージョン[_2] (スキーマバージョン[_3])にアップグレードしました。},
	q{User '[_1]' installed plugin '[_2]', version [_3] (schema version [_4]).} => q{'[_1]'がプラグイン([_2]、バージョン[_3]、スキーマバージョン[_4])をインストールしました。},
	q{User '[_1]' upgraded database to version [_2]} => q{'[_1]'がデータベースをバージョン[_2]にアップグレードしました。},
	q{User '[_1]' upgraded plugin '[_2]' to version [_3] (schema version [_4]).} => q{'[_1]'がプラグイン([_2])をバージョン[_3](スキーマバージョン[_4])にアップグレードしました。},

## lib/MT/Upgrade/Core.pm
	'Assigning category parent fields...' => 'カテゴリのparentフィールドを設定しています...',
	'Assigning custom dynamic template settings...' => 'ダイナミックテンプレートの設定を適用しています...',
	'Assigning template build dynamic settings...' => 'テンプレートにダイナミックパブリッシングの設定を適用しています...',
	'Assigning user types...' => 'ユーザーの種類を設定しています...',
	'Assigning visible status for TrackBacks...' => 'トラックバックに表示状態を設定しています...',
	'Assigning visible status for comments...' => 'コメントに表示状態を設定しています...',
	'Creating initial user records...' => '初期ユーザーのレコードを作成しています...',
	'Error creating role record: [_1].' => 'ロールレコード作成エラー: [_1]',
	'Error saving record: [_1].' => 'レコードを保存できません: [_1]',
	'Expiring cached MT News widget...' => 'MTニュースのキャッシュを破棄しています...',
	'Mapping templates to blog archive types...' => 'テンプレートをブログのアーカイブタイプに適用しています...',
	'Upgrading asset path information...' => 'アセットパス情報を更新しています...',
	q{Creating new template: '[_1]'.} => q{新しいテンプレート[_1]を作成しています...},

## lib/MT/Upgrade/v1.pm
	'Creating entry category placements...' => '記事とカテゴリの関連付けを作成しています...',
	'Creating template maps...' => 'テンプレートマップを作成しています...',
	'Mapping template ID [_1] to [_2] ([_3]).' => 'テンプレート(ID:[_1])を[_2]([_3])にマッピングしています...',
	'Mapping template ID [_1] to [_2].' => 'テンプレート(ID:[_1])を[_2]にマッピングしています...',

## lib/MT/Upgrade/v2.pm
	'Assigning comment/moderation settings...' => 'コメントとコメントの保留設定を適用しています...',
	'Updating category placements...' => 'カテゴリの関連付けを更新しています...',

## lib/MT/Upgrade/v3.pm
	'Assigning basename for categories...' => 'カテゴリに出力ファイル/フォルダ名を設定しています...',
	'Assigning blog administration permissions...' => 'ブログの管理権限を適用しています...',
	'Assigning entry basenames for old entries...' => '既存の記事に出力ファイル名を設定しています...',
	'Assigning user status...' => 'ユーザーの状態を設定しています...',
	'Creating configuration record.' => '構成データを作成しています。',
	'Custom ([_1])' => 'カスタム ([_1])',
	'Migrating any "tag" categories to new tags...' => '"tag"カテゴリをタグに移行しています...',
	'Migrating permissions to roles...' => '権限をロールに移行しています...',
	'Removing Dynamic Site Bootstrapper index template...' => 'Dynamic Site Bootstrapperテンプレートを削除しています...',
	'Setting blog allow pings status...' => 'ブログのトラックバック受信設定を適用しています...',
	'Setting blog basename limits...' => '出力ファイル名の長さの既定値を設定しています...',
	'Setting default blog file extension...' => '既定のファイル拡張子を設定しています...',
	'Setting new entry defaults for blogs...' => 'ブログに記事の初期設定を適用しています...',
	'Setting your permissions to administrator.' => '管理者権限にしています。',
	'This role was generated by Movable Type upon upgrade.' => 'このロールはアップグレード時にMovable Typeが作成しました。',
	'Updating blog comment email requirements...' => 'コメントのメール必須設定を適用しています...',
	'Updating blog old archive link status...' => 'ブログのアーカイブリンクの状態を更新しています...',
	'Updating comment status flags...' => 'コメントの状態フラグを更新しています...',
	'Updating commenter records...' => 'コメント投稿者のレコードを更新しています...',
	'Updating entry week numbers...' => '記事の週番号を更新しています...',
	'Updating user permissions for editing tags...' => 'タグを編集する権限を適用しています...',
	'Updating user web services passwords...' => 'ユーザーのWebサービスパスワードを更新しています...',

## lib/MT/Upgrade/v4.pm
	'Adding new feature widget to dashboard...' => '新機能紹介のウィジェットをダッシュボードに追加しています...',
	'Assigning author basename...' => 'ユーザーにベースネームを設定しています...',
	'Assigning blog page layout...' => 'ブログにページレイアウトを設定しています...',
	'Assigning blog template set...' => 'ブログにテンプレートセットを設定しています...',
	'Assigning embedded flag to asset placements...' => 'アセットの関連付けの有無を設定しています...',
	'Assigning entry comment and TrackBack counts...' => 'コメントとトラックバックの件数を設定しています....',
	'Assigning junk status for TrackBacks...' => 'トラックバックにスパム状態を設定しています...',
	'Assigning junk status for comments...' => 'コメントにスパム状態を設定しています...',
	'Assigning user authentication type...' => 'ユーザーに認証タイプを設定しています...',
	'Cannot rename in [_1]: [_2].' => '[_1]の名前を変更できません: [_2]',
	'Classifying category records...' => 'カテゴリのデータにクラスを設定しています...',
	'Classifying entry records...' => '記事のデータにクラスを設定しています...',
	'Comment Posted' => 'コメント投稿完了',
	'Comment Response' => 'コメント完了',
	'Comment Submission Error' => 'コメント投稿エラー',
	'Confirmation...' => '確認',
	'Error renaming PHP files. Please check the Activity Log.' => 'PHPファイルの名前を変更できませんでした。ログを確認してください。',
	'Merging comment system templates...' => 'コメント関連のシステムテンプレートをマージしています...',
	'Migrating Nofollow plugin settings...' => 'NoFollowプラグインの設定を移行しています...',
	'Migrating permission records to new structure...' => '権限のデータを移行しています...',
	'Migrating role records to new structure...' => 'ロールのデータを移行しています...',
	'Migrating system level permissions to new structure...' => 'システム権限を移行しています...',
	'Moving OpenID usernames to external_id fields...' => '既存のOpenIDユーザー名を移動しています...',
	'Moving metadata storage for categories...' => 'カテゴリのメタデータの格納場所を移動しています...',
	'Populating authored and published dates for entries...' => '記事の作成日と公開日を設定しています...',
	'Populating default file template for templatemaps...' => 'テンプレートマップにテンプレートを設定しています...',
	'Removing unnecessary indexes...' => '不要なインデックスを削除しています...',
	'Removing unused template maps...' => '使用されていないテンプレートマップを削除しています...',
	'Renaming PHP plugin file names...' => 'phpプラグインのファイル名を変更しています...',
	'Replacing file formats to use CategoryLabel tag...' => 'ファイルフォーマットをMTCategoryLabelに変換しています...',
	'Return to the <a href="[_1]">original entry</a>.' => '<a href="[_1]">元の記事</a>に戻る',
	'Thank you for commenting.' => 'コメントありがとうございます。',
	'Updating password recover email template...' => 'パスワードの再設定(メール テンプレート)を更新しています...',
	'Updating system search template records...' => 'システムテンプレート「検索結果」を更新しています...',
	'Updating template build types...' => 'テンプレートのビルドオプションを設定しています...',
	'Updating widget template records...' => 'ウィジェットテンプレートを更新しています...',
	'Upgrading metadata storage for [_1]' => '[_1]のメタデータの格納場所を変更しています...',
	'Your comment has been posted!' => 'コメントを投稿しました。',
	'Your comment has been received and held for review by a blog administrator.' => 'コメントは現在承認されるまで公開を保留されています。',
	'Your comment submission failed for the following reasons:' => 'コメントの投稿に失敗しました:',
	'[_1]: [_2]' => '[_1]: [_2]',

## lib/MT/Upgrade/v5.pm
	'Adding notification dashboard widget...' => '通知ウィジェットをダッシュボードに追加しています...',
	'An error occurred during generating a website upon upgrade: [_1]' => 'ウェブサイトへの移行中にエラーが発生しました: [_1]',
	'Assigning ID of author for entries...' => '記事に作成者のIDを設定しています...',
	'Assigning a language to each blog to help choose appropriate display format for dates...' => 'ブログに日付の言語を設定しています...',
	'Assigning new system privilege for system administrator...' => 'システム管理者用の新しい権限を設定しています...',
	'Assigning to  [_1]...' => '[_1]を設定しています...',
	'Can administer the website.' => 'ウェブサイトを管理できます。',
	'Can edit, manage and publish blog templates and themes.' => 'ブログテンプレートとテーマを更新し、管理し、それらを公開できます。',
	'Can manage pages, Upload files and publish blog templates.' => 'ページを管理し、ファイルをアップロードし、ブログテンプレートを公開できます。',
	'Classifying blogs...' => 'ブログを分類しています...',
	'Designer (MT4)' => 'デザイナ(MT4)',
	'Error loading role: [_1].' => 'ロールのロードエラー: [_1]',
	'Generated a website [_1]' => '作成されたウェブサイト: [_1]',
	'Generic Website' => '標準のウェブサイト',
	'Granting new role to system administrator...' => 'システム管理者に新しいロールを付与しています...',
	'Migrating DefaultSiteURL/DefaultSiteRoot to website...' => 'DefaultSiteURL/DefaultSiteRootをウェブサイト用に移行しています...',
	'Migrating [_1]([_2]).' => '[_1]([_2])を移行しています。',
	'Migrating existing [quant,_1,blog,blogs] into websites and their children...' => '既存のブログをウェブサイトで管理できるように移行しています。',
	'Migrating mtview.php to MT5 style...' => 'mtview.phpをMT5で利用できるように移行しています...',
	'Moved blog [_1] ([_2]) under website [_3]' => '[_1]ブログ([_2])を[_3]ウェブサイト下に移動しました',
	'New WebSite [_1]' => '新しいウェブサイト: [_1]',
	'Ordering Categories and Folders of Blogs...' => 'ブログのカテゴリとフォルダの順番を設定しています...',
	'Ordering Folders of Websites...' => 'ウェブサイトのフォルダの順番を設定しています...',
	'Populating generic website for current blogs...' => '現在のブログをウェブサイトへ変換しています...',
	'Populating new role for theme...' => 'テーマ用の新しいロールへ変換しています...',
	'Populating new role for website...' => 'ウェブサイト用の新しいロールへ変換しています...',
	'Rebuilding permissions...' => '権限を再構築しています...',
	'Recovering type of author...' => 'コメンターの権限を再設定しています...',
	'Removing Technorati update-ping service from [_1] (ID:[_2]).' => 'ブログ[_1](ID:[_2])の更新通知先からテクノラティを削除しました。',
	'Removing widget from dashboard...' => 'ダッシュボードからウィジェットを削除しています...',
	'Updating existing role name...' => '既存のロール名を更新しています...',
	'Webmaster (MT4)' => 'ウェブサイト管理者(MT4)',
	'Website Administrator' => 'ウェブサイト管理者',
	'_WEBMASTER_MT4' => 'ウェブサイト管理者',
	q{An error occurred during migrating a blog's site_url: [_1]} => q{ブログのサイトURLの移行中にエラーが発生しました: [_1]},
	q{New user's website} => q{新規ユーザー向けウェブサイト},
	q{Setting the 'created by' ID for any user for whom this field is not defined...} => q{作成者の情報をユーザーに付与しています...},

## lib/MT/Upgrade/v6.pm
	'Adding "Site stats" dashboard widget...' => '"サイト情報"ウィジェットを追加しています...',
	'Adding Website Administrator role...' => 'ウェブサイト管理者のロールを追加しています...',
	'Fixing TheSchwartz::Error table...' => 'TheSchwartz::Errorテーブルを更新しています...',
	'Migrating current blog to a website...' => '現在のブログをウェブサイトへ変換しています...',
	'Migrating the record for recently accessed blogs...' => '最近利用したブログのデータを移行しています...',
	'Rebuilding permission records...' => '権限を再構築しています...',
	'Reordering dashboard widgets...' => 'ダッシュボードウィジェットの並び順を設定しています...',

## lib/MT/Upgrade/v7.pm
	'Adding site list dashboard widget for mobile...' => 'モバイル用のサイト一覧ウィジェットを追加しています...',
	'Assign a Site Administrator Role for Manage Website with Blogs...' => 'ウェブサイトとブログの管理者にサイト管理者のロールを付与しています...',
	'Assign a Site Administrator Role for Manage Website...' => 'ウェブサイト管理者にサイト管理者のロールを付与しています...',
	'Changing the Child Site Administrator role to the Site Administrator role.' => '子サイトの管理者をサイト管理者に変更しています...',
	'Child Site Administrator' => '子サイトの管理者',
	'Cleaning up content field indexes...' => 'コンテンツフィールドのインデックスを削除しています...',
	'Cleaning up objectasset records for content data...' => 'コンテンツデータと関連する objectasset のレコードを削除しています...',
	'Cleaning up objectcategory records for content data...' => 'コンテンツデータと関連する objectcategory のレコードを削除しています...',
	'Cleaning up objecttag records for content data...' => 'コンテンツデータと関連する objecttag のレコードを削除しています...',
	'Create a new role for creating a child site...' => '子サイトの作成ロールを作成しています...',
	'Create new role: [_1]...' => '新しいロール [_1] を作成しています...',
	'Error removing record (ID:[_1]): [_2].' => 'レコード (ID:[_1]) の削除中にエラーが発生しました] [_2]',
	'Error removing records: [_1]' => 'レコードの削除中にエラーが発生しました: [_1]',
	'Error saving record (ID:[_1]): [_2].' => 'レコード (ID:[_1]) の保存中にエラーが発生しました: [_2]',
	'Error saving record: [_1]' => 'レコードの保存中にエラーが発生しました: [_1]',
	'Filling missing system templates...' => '不足していたシステムテンプレートを補充しています...',
	'Migrating DataAPIDisableSite...' => 'DataAPIDisableSiteを移行しています...',
	'Migrating Max Length option of Single Line Text fields...' => 'テキスト型のコンテンツフィールドの最大値を修正しています...',
	'Migrating MultiBlog settings...' => 'マルチブログの設定を移行しています...',
	'Migrating create child site permissions...' => '子サイトの作成権限を移行しています...',
	'Migrating data column of MT::ContentData...' => 'コンテンツデータのdataカラムを移行しています...',
	'Migrating fields column of MT::ContentType...' => 'コンテンツタイプのFieldsカラムを移行しています...',
	'Migrating filters that have conditions on the log level...' => 'ログレベルに対する条件を持つフィルターを移行しています...',
	'MultiBlog migration for site(ID:[_1]) is skipped due to the data breakage.' => 'データが破損しているためサイト(ID:[_1])のマルチブログの設定の移行をスキップします。',
	'MultiBlog migration is skipped due to the data breakage.' => 'データが破損しているためマルチブログの設定の移行をスキップします。',
	'Rebuilding Content Type count of Category Sets...' => 'カテゴリセットの情報を再構築しています...',
	'Rebuilding MT::ContentFieldIndex of embedded_text field...' => '埋め込みテキストデータのインデックスを再構築しています...',
	'Rebuilding MT::ContentFieldIndex of multi_line_text field...' => 'テキスト（複数行）データのインデックスを再構築しています...',
	'Rebuilding MT::ContentFieldIndex of number field...' => 'コンテンツデータのインデックスを再構築しています...',
	'Rebuilding MT::ContentFieldIndex of single_line_text field...' => 'テキストデータのインデックスを再構築しています...',
	'Rebuilding MT::ContentFieldIndex of tables field...' => 'テーブルデータのインデックスを再構築しています...',
	'Rebuilding MT::ContentFieldIndex of url field...' => 'URLデータのインデックスを再構築しています...',
	'Rebuilding MT::Permission records (remove edit_categories)...' => 'カテゴリセットの管理権限からカテゴリの編集権限を削除しています...',
	'Rebuilding content field permissions...' => 'コンテンツフィールドの権限を再構築しています...',
	'Rebuilding object assets...' => 'アセットの関連付けを再構築しています...',
	'Rebuilding object categories...' => 'カテゴリの関連付けを再構築しています...',
	'Rebuilding object tags...' => 'タグの関連付けを再構築しています...',
	'Remove SQLSetNames...' => 'SQLSetNames をデータベースから削除しています...',
	'Remove image metadata' => '画像のメタデータを削除しています',
	'Reorder DEBUG level' => 'DEBUGレベルの値を変更しています',
	'Reorder SECURITY level' => 'SECURITYレベルの値を変更しています',
	'Reorder WARNING level' => 'WARNINGレベルの値を変更しています',
	'Reset default dashboard widgets...' => 'ダッシュボードウィジェットを初期化しています...',
	'Some MultiBlog migrations for site(ID:[_1]) are skipped due to the data breakage.' => 'データが破損しているためサイト(ID:[_1])の一部のマルチブログの設定の移行をスキップします',
	'Truncating values of value_varchar column...' => 'コンテンツデータの varchar カラムのインデックスを再構築しています...',
	'add administer_site permission for Blog Administrator...' => 'ブログ管理者にサイトの管理権限を付与しています...',
	'change [_1] to [_2]' => '[_1]を[_2]に変更しています',

## lib/MT/Util.pm
	'[quant,_1,day,days] from now' => '[quant,_1,日,日]後',
	'[quant,_1,day,days]' => '[quant,_1,日,日]',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => '[quant,_1,日,日], [quant,_2,時間,時間]前',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => '[quant,_1,日,日], [quant,_2,時間,時間]後',
	'[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,日,日], [quant,_2,時間,時間]',
	'[quant,_1,hour,hours] from now' => '[quant,_1,時間,時間]後',
	'[quant,_1,hour,hours]' => '[quant,_1,時間,時間]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => '[quant,_1,時間,時間], [quant,_2,分,分]前',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => '[quant,_1,時間,時間], [quant,_2,分,分]後',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,時間,時間], [quant,_2,分,分]',
	'[quant,_1,minute,minutes] from now' => '[quant,_1,分,分]後',
	'[quant,_1,minute,minutes]' => '[quant,_1,分,分]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => '[quant,_1,分,分], [quant,_2,秒,秒]後',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,分,分], [quant,_2,秒,秒]',
	'[quant,_1,second,seconds] from now' => '[quant,_1,秒,秒]後',
	'[quant,_1,second,seconds]' => '[quant,_1,秒,秒]',
	'less than 1 minute ago' => '1分以内',
	'less than 1 minute from now' => '1分後以内',
	'moments from now' => '今から',
	q{Invalid domain: '[_1]'} => q{ドメイン「[_1]」が不正です。},

## lib/MT/Util/Archive.pm
	'Registry could not be loaded' => 'レジストリをロードできませんでした。',
	'Type must be specified' => '種類を指定してください。',

## lib/MT/Util/Archive/BinTgz.pm
	'Both data and file name must be specified.' => 'データとファイルの両方を指定してください。',
	'Cannot extract from the object' => '解凍できません。',
	'Cannot find external archiver: [_1]' => '外部アーカイバが見つかりません: [_1]',
	'Cannot write to the object' => '書き込みできません。',
	'Failed to create an archive [_1]: [_2]' => 'アーカイブ [_1] を作成できません: [_2]',
	'File [_1] exists; could not overwrite.' => '[_1]が既に存在します。上書きできません。',
	'Type must be tgz.' => 'TGZが指定されていません。',
	'[_1] in the archive contains ..' => 'アーカイブに含まれるファイル[_1]に相対パス指定が含まれています',
	'[_1] in the archive is an absolute path' => 'アーカイブに含まれるファイル[_1]に絶対パスが含まれています',
	'[_1] in the archive is not a regular file' => 'アーカイブに含まれるファイル[_1]にシンボリックリンクが含まれています',

## lib/MT/Util/Archive/BinZip.pm
	'Failed to rename an archive [_1]: [_2]' => 'アーカイブ [_1] をリネームできません: [_2]',
	'Type must be zip' => 'ZIPが指定されていません。',

## lib/MT/Util/Archive/Tgz.pm
	'Could not read from filehandle.' => 'ファイルを読みだせませんでした。',
	'File [_1] is not a tgz file.' => '[_1]はTGZファイルではありません。',

## lib/MT/Util/Archive/Zip.pm
	'File [_1] is not a zip file.' => '[_1]はZIPファイルではありません。',

## lib/MT/Util/Captcha.pm
	'Captcha' => 'Captcha',
	'Image creation failed.' => '画像を作成できませんでした。',
	'Image error: [_1]' => '画像でエラーが発生しました: [_1]',
	'Movable Type default CAPTCHA provider requires Image::Magick.' => 'Movable Type 既定のCAPTCHAプロバイダはImage::Magickをインストールしないと使えません。',
	'Type the characters you see in the picture above.' => '画像の中に見える文字を入力してください。',
	'You need to configure CaptchaSourceImageBase.' => '構成ファイルでCaptchaSourceImageBaseを設定してください。',

## lib/MT/Util/Log.pm
	'Cannot load Log module: [_1]' => 'ログモジュールをロードできません: [_1]',
	'Logger configuration for Log module [_1] seems problematic' => 'ログモジュール [_1] の設定に問題がありそうです',
	'Unknown Logger Level: [_1]' => '不正なログレベルです: [_1]',

## lib/MT/Util/Mail.pm
	'Error loading mail module: [_1].' => 'メールモジュールのロードに失敗しました: [_1]',
	'Error sending mail: [_1]' => 'メールを送信できませんでした: [_1]',
	'Mail was sent successfully' => 'メールが正常に送信されました',
	'Recipient: [_1]' => '送信先: [_1]',
	'Subject: [_1]' => '件名: [_1]',
	q{MT::Mail doesn't support file attachments. Please change MailModule setting.} => q{MT::Mail は添付ファイルをサポートしていません。MailModule の設定を変更してください。},

## lib/MT/Util/YAML.pm
	'Cannot load YAML module: [_1]' => 'YAMLモジュールをロードできません: [_1]',
	'Invalid YAML module' => '不正なYAMLモジュールが指定されています',

## lib/MT/WeblogPublisher.pm
	'An error occurred while publishing scheduled entries: [_1]' => '日時指定された記事の再構築中にエラーが発生しました: [_1]',
	'An error occurred while unpublishing past entries: [_1]' => '公開終了日を過ぎた記事の処理中にエラーが発生しました: [_1]',
	'Blog, BlogID or Template param must be specified.' => 'Blog, BlogID, またはTemplateのいずれかを指定してください。',
	'The same archive file exists. You should change the basename or the archive path. ([_1])' => '同名のファイルがすでに存在します。ファイル名またはアーカイブパスを変更してください([_1])。',
	'unpublish' => '公開終了',
	q{Template '[_1]' does not have an Output File.} => q{テンプレート'[_1]'には出力ファイルの設定がありません。},

## lib/MT/Website.pm
	'Child Site Count' => '子サイト数',
	'First Website' => 'First Website',
	'Show only Child Site' => '子サイトだけを表示',
	'Show only Parent Site' => '親サイトだけを表示',

## lib/MT/Worker/Publish.pm
	'-- set complete ([quant,_1,file,files] in [_2] seconds)' => '-- 完了 ([_1]ファイル - [_2]秒)',
	'Background Publishing Done' => 'バックグラウンドパブリッシングが完了しました',
	'Error rebuilding file [_1]:[_2]' => '[_1]の再構築中にエラーが発生しました: [_2]',
	'Published: [_1]' => '公開されたファイル: [_1]',

## lib/MT/Worker/Sync.pm
	'Done Synchronizing Files' => 'ファイルを同期しました。',
	'Done syncing files to [_1] ([_2])' => '[_1]へファイルを同期しました。([_2])',
	qq{Error during rsync of files in [_1]:\n} => qq{ファイル'[_1]'のrsync中にエラーが発生しました: },

## lib/MT/XMLRPCServer.pm
	'Error writing uploaded file: [_1]' => 'アップロードされたファイルを書き込めませんでした: [_1]',
	'Invalid login' => 'サインインできません',
	'Invalid timestamp format' => 'timestampの形式が不正です。',
	'No blog_id' => 'No blog_id',
	'No entry_id' => '記事IDがありません',
	'No filename provided' => 'ファイル名がありません。',
	'No web services password assigned.  Please see your user profile to set it.' => 'Webサービスパスワードを設定していません。ユーザー情報の編集の画面で設定してください。',
	'Not allowed to edit entry' => '記事を編集する権限がありません。',
	'Not allowed to get entry' => '記事を取得する権限がありません。',
	'Not allowed to set entry categories' => 'カテゴリを設定する権限がありません。',
	'Not allowed to upload files' => 'ファイルをアップロードする権限がありません。',
	'Perl module Image::Size is required to determine width and height of uploaded images.' => 'Image::Sizeをインストールしないと、画像の幅と高さを検出できません。',
	'Publishing failed: [_1]' => '再構築できません: [_1]',
	'Saving folder failed: [_1]' => 'フォルダを保存できませんでした: [_1]',
	'Template methods are not implemented, due to differences between the Blogger API and the Movable Type API.' => 'Templateメソッドは実装されていません。',
	q{Entry '[_1]' ([lc,_5] #[_2]) deleted by '[_3]' (user #[_4]) from xml-rpc} => q{'[_3]'(ID:[_4])がXMLRPC経由で[_5]'[_1]'(ID:[_2])を削除しました。},
	q{Invalid entry ID '[_1]'} => q{不正な記事ID (ID: [_1]) です},
	q{Requested permalink '[_1]' is not available for this page} => q{[_1]というパーマリンクはこのページにはありません。},
	q{Value for 'mt_[_1]' must be either 0 or 1 (was '[_2]')} => q{mt_[_1]の値は0か1です([_2]を設定しようとしました)。},

## mt-check.cgi
	'(Probably) running under cgiwrap or suexec' => 'cgiwrapまたはsuexec環境下で動作していると思われます。',
	'Checking for' => '確認中',
	'Current working directory:' => '現在のディレクトリ',
	'DBI and DBD::Pg are required if you want to use the PostgreSQL database backend.' => 'データを保存するデータベースとして PostgreSQL を利用する場合、DBIと DBD::Pgが必要です。',
	'DBI and DBD::SQLite are required if you want to use the SQLite database backend.' => 'データを保存するデータベースとして SQLite を利用する場合、DBIと DBD::SQLiteが必要です。',
	'DBI and DBD::SQLite2 are required if you want to use the SQLite 2.x database backend.' => 'データを保存するデータベースとして SQLite2.x を利用する場合、DBIと DBD::SQLite2が必要です。',
	'DBI and DBD::mysql are required if you want to use the MySQL database backend.' => 'データを保存するデータベースとして MySQL を利用する場合、DBIと DBD::mysqlが必要です。',
	'DBI is required to store data in database.' => 'DBIはデータベースにアクセスするために必要です。',
	'Data Storage' => 'データストレージ',
	'Details' => '詳細',
	'Installed' => 'インストール済み',
	'MT home directory:' => 'MTディレクトリ',
	'Movable Type System Check Successful' => 'システムのチェックを完了しました。',
	'Movable Type System Check' => 'Movable Type システムチェック',
	'Movable Type version:' => 'Movable Type バージョン',
	'Operating system:' => 'オペレーティングシステム',
	'Perl include path:' => 'Perl の インクルードパス',
	'Perl version:' => 'Perl のバージョン',
	'Please consult the installation instructions for help in installing [_1].' => '[_1]のインストールはインストールマニュアルに沿って行ってください。',
	'Supported format: [_1]' => '対応している形式: [_1]',
	'The DBD::mysql version you have installed is known to be incompatible with Movable Type. Please install the most current release available.' => 'お使いのサーバーにインストールされている DBD::mysqlのバージョンは、Movable Type と互換性がありません。CPAN に公開されている最新バージョンをインストールしてください。',
	'The [_1] is installed properly, but requires an updated DBI module. Please see the note above regarding the DBI module requirements.' => '[_1]はインストールされていますが、新しいDBIが必要です。上記を参考に必要なDBIを確認してください。',
	'The following modules are <strong>optional</strong>. If your server does not have these modules installed, you only need to install them if you require the functionality that they provide.' => 'これらのモジュールのインストールは<strong>任意</strong>です。お使いのサーバーにこれらのモジュールがインストールされていない場合でも、Movable Type の基本機能は動作します。これらのモジュールの機能が必要となった場合にはインストールを行ってください。',
	'The following modules are required by databases that can be used with Movable Type. Your server must have DBI and at least one of these related modules installed for the application to work properly.' => 'これらのモジュールは、Movable Type がデータを保存するために必要なモジュールです。DBIと、1つ以上のデータベース用のモジュールをインストールする必要があります。',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]). Please upgrade to at least Perl [_2].' => 'お使いのシステム([_1])にインストールされているPerlは、Movable Type でサポートされている最低限のバージョン[_2]を満たしていません。Perlを[_2]以上にアップグレードしてください。',
	'Web server:' => 'ウェブサーバー',
	'You attempted to use a feature that you do not have permission to access. If you believe you are seeing this message in error contact your system administrator.' => 'アクセス権がありません。システム管理者に連絡してください。',
	'Your server does not have [_1] installed, or [_1] requires another module that is not installed.' => 'サーバーに [_1]か、[_1]の動作に必要な他のモジュールがインストールされていません。',
	'Your server has [_1] installed (version [_2]).' => 'サーバーに [_1] がインストールされています(バージョン [_2])。',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations. Continue with the installation instructions.' => 'お使いのサーバーには、Movable Type の動作に必要なすべてのモジュールがインストールされています。モジュールを追加インストール作業は必要はありません。マニュアルに従い、インストールを続けてください。',
	'[_1] [_2] Modules' => '[_1]: [_2]モジュール',
	'unknown' => '不明',
	q{The MT-Check report is disabled when Movable Type has a valid configuration file (mt-config.cgi)} => q{構成ファイル(mt-config.cgi)がすでに存在するため、'mt-check.cgi' スクリプトは無効になっています。},
	q{The mt-check.cgi script provides you with information about your system's configuration and determines whether you have all of the components you need to run Movable Type.} => q{mt-check.cgiはシステムの構成を確認し、Movable Typeを実行するために必要なコンポーネントがそろっていることを確認するためのスクリプトです。},
	q{You're ready to go!} => q{Movable Typeを利用できます。},

## mt-static/addons/Sync.pack/js/cms.js
	'Continue' => '次へ',
	'You have unsaved changes to this page that will be lost.' => '保存されていない変更は失われます。',

## mt-static/jquery/jquery.mt.js
	'Invalid URL' => 'URLのフォーマットが正しくありません',
	'Invalid date format' => '日付の入力フォーマットが正しくありません',
	'Invalid time format' => '時刻の入力フォーマットが正しくありません',
	'Invalid value' => '入力された値が正しくありません',
	'Only 1 option can be selected' => 'ひとつだけ選択できます',
	'Options greater than or equal to [_1] must be selected' => '[_1]個以上選択してください',
	'Options less than or equal to [_1] must be selected' => '[_1]個までしか選択できません',
	'Please input [_1] characters or more' => '[_1]文字以上入力してください',
	'Please select one of these options' => '1つ以上選択してください',
	'This field is required' => 'このフィールドは必須です。',
	'This field must be a number' => 'このフィールドには数値を入力して下さい',
	'This field must be a signed integer' => 'このフィールドには',
	'This field must be a signed number' => 'このフィールドには符号付き整数を入力してください',
	'This field must be an integer' => 'このフィールドには整数の値を入力して下さい',
	'You have an error in your input.' => '入力内容に誤りがあります。',

## mt-static/js/assetdetail.js
	'Dimensions' => '大きさ',
	'File Name' => 'ファイル名',
	'No Preview Available.' => 'プレビューは利用できません。',

## mt-static/js/contenttype/contenttype.js
	'Do you want to delete [_1]([_2])?' => '[_1]([_2])を削除しますか？',
	'Duplicate' => '複製',

## mt-static/js/contenttype/tag/content-field.tag
	'ContentField' => 'コンテンツフィールド',
	'Move' => '移動',

## mt-static/js/contenttype/tag/content-fields.tag
	'Allow users to change the display and sort of fields by display option' => 'ユーザーにフィールドの並び替えや表示非表示の変更を許可する',
	'Data Label Field' => 'データ識別ラベル',
	'Drag and drop area' => 'ドラッグ・アンド・ドロップ領域',
	'Please add a content field.' => 'コンテンツフィールドを追加します',
	'Show input field to enter data label' => 'ユーザーが入力する',
	'Unique ID' => 'ユニークID',
	'close' => '閉じる',

## mt-static/js/dialog.js
	'(None)' => '(なし)',

## mt-static/js/listing/list_data.js
	'[_1] - Filter [_2]' => '[_1] - フィルタ [_2]',

## mt-static/js/listing/listing.js
	'Are you sure you want to [_2] this [_1]?' => '[_1]を[_2]してよろしいですか?',
	'Are you sure you want to [_3] the [_1] selected [_2]?' => '[_1]件の[_2]を[_3]してよろしいですか?',
	'Label "[_1]" is already in use.' => '"[_1]というラベルは既に使用されています。"',
	'One or more fields in the filter item are not filled in properly.' => '1つ以上のフィルター項目が正しく入力されていません。',
	'You can only act upon a maximum of [_1] [_2].' => '[_2]は最大で[_1]件しか選択できません。',
	'You can only act upon a minimum of [_1] [_2].' => '[_2]は最低でも[_1]件選択してください。',
	'You did not select any [_1] to [_2].' => '[_2]する[_1]が選択されていません。',
	'act upon' => '対象に',
	q{Are you sure you want to remove filter '[_1]'?} => q{フィルタ'[_1]'を削除してよろしいですか?},

## mt-static/js/listing/tag/display-options-for-mobile.tag
	'Show' => '表示件数',
	'[_1] rows' => '[_1]件',

## mt-static/js/listing/tag/display-options.tag
	'Column' => '表示項目',
	'Reset defaults' => '既定値にリセット',
	'User Display Option is disabled now.' => 'ユーザーによる表示オプションの変更は無効になっています',

## mt-static/js/listing/tag/list-actions-for-mobile.tag
	'Plugin Actions' => 'プラグインアクション',
	'Select action' => 'アクションを選択',

## mt-static/js/listing/tag/list-actions-for-pc.tag
	'More actions...' => 'アクション...',

## mt-static/js/listing/tag/list-filter.tag
	'Add' => '追加',
	'Apply' => '適用',
	'Built in Filters' => 'クイックフィルタ',
	'Create New' => '新規作成',
	'Filter Label' => 'フィルタ名',
	'Filter:' => 'フィルタ:',
	'My Filters' => '自分のフィルタ',
	'Reset Filter' => 'フィルタをリセットする',
	'Save As' => '別名で保存',
	'Select Filter Item...' => 'フィルタ項目を選択してください',
	'Select Filter' => 'フィルタを選択',
	'rename' => '名前を変更',

## mt-static/js/listing/tag/list-table.tag
	'All [_1] items are selected' => '全[_1]件が選択されています',
	'All' => 'すべて',
	'Loading...' => 'ロード中...',
	'Select All' => 'すべて選択',
	'Select all [_1] items' => '全[_1]件を選択する',
	'Select' => '選択',
	'[_1] &ndash; [_2] of [_3]' => '[_1] &ndash; [_2] / [_3]',

## mt-static/js/mt/util.js
	'Are you certain you want to remove these [_1] roles? By doing so you will be taking away the permissions currently assigned to any users and groups associated with these roles.' => 'これら[_1]つのロールをしてもよろしいですか? 削除してしまうと、これらのロールを通じて権限を付与されているすべてのユーザーとグループから権限を剥奪することになります。',
	'Are you certain you want to remove this role? By doing so you will be taking away the permissions currently assigned to any users and groups associated with this role.' => 'このロールを本当に削除してもよろしいですか? ロールを通じて権限を付与されているすべてのユーザーとグループから権限を剥奪することになります。',
	'You did not select any [_1] [_2].' => '[_2]する[_1]が選択されていません。',
	'You must select an action.' => 'アクションを選択してください。',
	'delete' => '削除',

## mt-static/js/tc/mixer/display.js
	'Author:' => '作者:',
	'Description:' => '説明:',
	'Tags:' => 'タグ:',
	'Title:' => 'タイトル:',
	'URL:' => 'URL:',

## mt-static/js/upload_settings.js
	'You must set a path beginning with %s or %a.' => '%s（サイトパス）か %a（アーカイブパス）から始まるパス名を指定してください。',
	'You must set a valid path.' => '有効なパス名を指定してください。',

## mt-static/mt.js
	'Enter URL:' => 'URLを入力:',
	'Enter email address:' => 'メールアドレスを入力:',
	'Same name tag already exists.' => '同名のタグがすでに存在します',
	'disable' => '無効に',
	'enable' => '有効に',
	'publish' => '公開',
	'remove' => '削除',
	'to mark as spam' => 'スパムに指定',
	'to remove spam status' => 'スパム指定を解除',
	'unlock' => 'ロック解除してサインイン可能に',
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]' across all weblogs?} => q{タグ'[_2]'はすでに存在します。'[_1]'を'[_2]'に統合してもよろしいですか?},
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]'?} => q{タグ'[_2]'はすでに存在します。'[_1]'を'[_2]'に統合してもよろしいですか? },

## mt-static/plugins/BlockEditor/lib/js/blockeditor_field.js
	'Edit [_1] block' => '[_1]ブロックの編集',

## mt-static/plugins/BlockEditor/lib/js/fields/embed.js
	'Embed Code' => '埋め込みコード',
	'Please enter the embed code here.' => '埋め込みコードを入力してください',

## mt-static/plugins/BlockEditor/lib/js/fields/header.js
	'Heading Level' => '見出し',
	'Heading' => '見出し',
	'Please enter the Header Text here.' => '見出しを入力してください。',

## mt-static/plugins/BlockEditor/lib/js/fields/horizon.js
	'Horizontal Rule' => '水平線',

## mt-static/plugins/BlockEditor/lib/js/fields/image.js
	'image' => '画像',

## mt-static/plugins/BlockEditor/lib/js/fields/text.js
	'__TEXT_BLOCK__' => 'テキスト',

## mt-static/plugins/BlockEditor/lib/js/jquery.blockeditor.js
	'Select a block' => 'ブロックを選択',

## mt-static/plugins/FormattedTextForTinyMCE/extension.js
	'Insert Boilerplate' => '定型文の挿入',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/autosave/plugin.js
	'You have unsaved changes are you sure you want to navigate away?' => '保存していない変更があります。移動してもよろしいですか？',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/compat3x/utils/editable_selects.js
	'value' => 'value',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/langs/plugin.js
	'Align Center' => '中央揃え',
	'Align Left' => '左揃え',
	'Align Right' => '右揃え',
	'Block Quotation' => '引用ブロック',
	'Bold (Ctrl+B)' => '太字  (Ctrl+B)',
	'Class Name' => 'クラス名',
	'Emphasis' => '斜体',
	'Horizontal Line' => '水平線を挿入',
	'Indent' => '字下げを増やす',
	'Insert Asset Link' => 'アセットの挿入',
	'Insert HTML' => 'HTMLの挿入',
	'Insert Image Asset' => '画像の挿入',
	'Insert Link' => 'リンクの挿入',
	'Insert/Edit Link' => 'リンクの挿入/編集',
	'Italic (Ctrl+I)' => '斜体 (Ctrl+I)',
	'List Item' => 'リスト要素',
	'Ordered List' => '番号付きリスト',
	'Outdent' => '字下げを減らす',
	'Redo (Ctrl+Y)' => 'やり直す (Ctrl+Y)',
	'Remove Formatting' => '書式の削除',
	'Select Background Color' => '背景色',
	'Select Text Color' => 'テキスト色',
	'Strikethrough' => '取り消し線',
	'Strong Emphasis' => '太字',
	'Toggle Fullscreen Mode' => '全画面表示の切り替え',
	'Toggle HTML Edit Mode' => 'HTML編集モードの切り替え',
	'Underline (Ctrl+U)' => '下線 (Ctrl+U)',
	'Undo (Ctrl+Z)' => '元に戻す (Ctrl+Z)',
	'Unlink' => 'リンクを解除',
	'Unordered List' => '番号なしリスト',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt/plugin.js
	'HTML' => 'HTML',

## mt-static/plugins/TinyMCE/tiny_mce/plugins/mt_fullscreen/langs/plugin.js
	'Fullscreen' => '全画面表示',

## mt-static/plugins/TinyMCE5/lib/js/tinymce/plugins/mt/langs/plugin.js
	'Copy column' => '列のコピー',
	'Cut column' => '列の切り取り',
	'Horizontal align' => '横配置',
	'Paste column after' => '列の後に貼り付け',
	'Paste column before' => '列の前に貼り付け',
	'Vertical align' => '縦配置',

## php/lib/block.mtarchives.php
	'ArchiveType not found - [_1]' => 'アーカイブタイプが見つかりません - [_1]',

## php/lib/block.mtassets.php
	'sort_by="score" must be used together with a namespace.' => 'sort_by="score"を指定するときはnamespaceも指定しなければなりません。',

## php/lib/block.mtauthorhascontent.php
	'No author available' => 'ユーザーが見つかりません。',

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => '[_1]を日付コンテキストの外部で利用しようとしました。',

## php/lib/block.mtcontentfield.php
	'No Content Field could be found: \"[_1]\"' => 'コンテンツフィールドが見つかりません: "[_1]"',

## php/lib/block.mtif.php
	'You used an [_1] tag without a valid name attribute.' => '[_1]タグではname属性は必須です。',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3]は不正です。',

## php/lib/captcha_lib.php
	'Type the characters shown in the picture above.' => '画像の中に見える文字を入力してください。',

## php/lib/function.mtassettype.php
	'file' => 'ファイル',

## php/lib/mtdb.base.php
	'When the exclude_blogs and include_blogs attributes are used together, the same blog IDs should not be listed as parameters to both of them.' => 'include_blogs属性で指定されたブログがexclude_blogs属性ですべて除外されています。',

## php/mt.php
	'Page not found - [_1]' => '[_1]が見つかりませんでした。',

## plugins/BlockEditor/tmpl/cms/dialog/asset_modal.tmpl
	'[_1] - [_2] of [_3]' => '[_1] - [_2] / [_3]',

## plugins/BlockEditor/tmpl/cms/dialog/include/asset_upload_panel.tmpl
	'Cancelled: [_1]' => 'キャンセルされました: [_1]',
	'The file you tried to upload is too large: [_1]' => 'アップロードしようとしたファイルは大きすぎます: [_1]',
	'[_1] is not a valid [_2] file.' => '[_1] は、正しい[_2]ファイルではありません。',

## plugins/Comments/lib/Comments.pm
	'(Deleted)' => '削除されたユーザー',
	'Approved' => '公開',
	'Banned' => '禁止',
	'Can comment and manage feedback.' => 'コメントを投稿し、コメントやトラックバックを管理できます。',
	'Can comment.' => 'コメントを投稿できます。',
	'Commenter' => 'コメント投稿者',
	'Comments on [_1]: [_2]' => '[_1] [_2]のコメント',
	'Edit this [_1] commenter.' => '[_1]であるコメンターを編集する。',
	'Moderator' => 'モデレータ',
	'Not spam' => 'スパムではない',
	'Reply' => '返信',
	'Reported as spam' => 'スパム',
	'Search for other comments from anonymous commenters' => '匿名ユーザーからのコメントを検索する。',
	'Search for other comments from this deleted commenter' => '削除されたユーザーからのコメントを検索する。',
	'Unapproved' => '未公開',
	'__ANONYMOUS_COMMENTER' => '匿名ユーザー',
	'__COMMENTER_APPROVED' => '承認',
	q{All comments by [_1] '[_2]'} => q{[_1]'[_2]'のコメント},

## plugins/Comments/lib/Comments/App/ActivityFeed.pm
	'All Comments' => 'すべてのコメント',
	'[_1] Comments' => '[_1]へのコメント',

## plugins/Comments/lib/Comments/App/CMS.pm
	'Are you sure you want to remove all comments reported as spam?' => 'スパムコメントをすべて削除しますか?',

## plugins/Comments/lib/Comments/Blog.pm
	'Cloning comments for blog...' => 'コメントを複製しています...',

## plugins/Comments/lib/Comments/Import.pm
	'Saving comment failed: [_1]' => 'コメントを保存できませんでした: [_1]',
	q{Creating new comment (from '[_1]')...} => q{'[_1]'からのコメントをインポートしています...},

## plugins/Comments/lib/Comments/Upgrade.pm
	'Creating initial comment roles...' => 'コメント権限を作成しています...',

## plugins/Comments/lib/MT/App/Comments.pm
	'<a href="[_1]">Return to the original page.</a>' => '<a href="[_1]">元のページに戻る</a>',
	'All required fields must be populated.' => '必須フィールドのすべてに正しい値を設定してください。',
	'An error occurred.' => 'エラーが発生しました。',
	'Comment save failed with [_1]' => 'コメントを保存できませんでした: [_1]',
	'Comment text is required.' => 'コメントを入力していません。',
	'Commenter profile could not be updated: [_1]' => 'コメント投稿者のユーザー情報を更新できませんでした: [_1]',
	'Commenter profile has successfully been updated.' => 'コメント投稿者のユーザー情報を更新しました。',
	'Comments are not allowed on this entry.' => 'この記事にはコメントできません。',
	'IP Banned Due to Excessive Comments' => '大量コメントによるIP禁止',
	'IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.' => '[_1]からのコメントが[_2]秒間に8個続いたため、このIPアドレスを禁止リストに登録しました。',
	'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.' => '[_1]がブログ[_2](ID:[_3])にサインインしようとしましたが、このブログではMovable Type認証が有効になっていません。',
	'Invalid entry ID provided' => '記事のIDが不正です。',
	'Movable Type Account Confirmation' => 'Movable Type アカウント登録確認',
	'Name and E-mail address are required.' => '名前とメールアドレスは必須です。',
	'No entry was specified; perhaps there is a template problem?' => '記事が指定されていません。テンプレートに問題があるかもしれません。',
	'No id' => 'IDがありません。',
	'No such comment' => 'コメントがありません。',
	'Registration is required.' => '登録しなければなりません。',
	'Signing up is not allowed.' => '登録はできません。',
	'Somehow, the entry you tried to comment on does not exist' => 'コメントしようとした記事がありません。',
	'Successfully authenticated, but signing up is not allowed.  Please contact your Movable Type system administrator.' => '認証されましたが、登録は許可されていません。システム管理者に連絡してください。',
	'Thanks for the confirmation.  Please sign in to comment.' => '登録ありがとうございます。サインインしてコメントしてください。',
	'You are trying to redirect to external resources. If you trust the site, please click the link: [_1]' => '外部のサイトへリダイレクトしようとしています。あなたがそのサイトを信頼できる場合、リンクをクリックしてください。[_1]',
	'You need to sign up first.' => '先に登録してください。',
	'Your confirmation has expired. Please register again.' => '有効期限が過ぎています。再度登録してください。',
	'_THROTTLED_COMMENT' => '短い期間にコメントを大量に送りすぎです。しばらくたってからやり直してください。',
	q{Comment on "[_1]" by [_2].} => q{[_2]が'[_1]'にコメントしました。},
	q{Commenter '[_1]' (ID:[_2]) has been successfully registered.} => q{コメント投稿者'[_1]'(ID:[_2])が登録されました。},
	q{Error assigning commenting rights to user '[_1] (ID: [_2])' for weblog '[_3] (ID: [_4])'. No suitable commenting role was found.} => q{'[_1]' (ID:[_2])にブログ'[_3]'(ID:[_4])へのコメント権限を与えられませんでした。コメント権限を与えるためのロールが見つかりません。},
	q{Failed comment attempt by pending registrant '[_1]'} => q{まだ登録を完了していないユーザー'[_1]'がコメントしようとしました。},
	q{Invalid URL '[_1]'} => q{不正なURL '[_1]'},
	q{Login failed: password was wrong for user '[_1]'} => q{サインインに失敗しました。[_1]のパスワードが誤っています。},
	q{Login failed: permission denied for user '[_1]'} => q{サインインに失敗しました。[_1]には権限がありません。},
	q{No such entry '[_1]'.} => q{記事'[_1]'がありません。},
	q{[_1] registered to the blog '[_2]'} => q{[_1]がブログ'[_2]'に登録されました。},

## plugins/Comments/lib/MT/CMS/Comment.pm
	'Commenter Details' => 'コメント投稿者の詳細',
	'Edit Comment' => 'コメントの編集',
	'No such commenter [_1].' => '[_1]というコメント投稿者は存在しません。',
	'Orphaned comment' => '記事のないコメント',
	'The entry corresponding to this comment is missing.' => 'このコメントに対応する記事が見つかりません。',
	'The parent comment id was not specified.' => '返信先のコメントが指定されていません。',
	'The parent comment was not found.' => '返信先のコメントが見つかりません。',
	'You cannot create a comment for an unpublished entry.' => '公開されていない記事にはコメントできません。',
	'You cannot reply to unapproved comment.' => '未公開のコメントには返信できません。',
	'You cannot reply to unpublished comment.' => '公開されていないコメントには返信できません。',
	'You do not have permission to approve this comment.' => 'このコメントを承認する権限がありません。',
	'You do not have permission to approve this trackback.' => 'このトラックバックを承認する権限がありません。',
	q{Comment (ID:[_1]) by '[_2]' deleted by '[_3]' from entry '[_4]'} => q{'[_3]'が記事'[_4]'のコメント'[_1]'(ID:[_2])を削除しました。},
	q{User '[_1]' banned commenter '[_2]'.} => q{'[_1]'がコメント投稿者'[_2]'を禁止しました。},
	q{User '[_1]' trusted commenter '[_2]'.} => q{'[_1]'がコメント投稿者'[_2]'を承認しました。},
	q{User '[_1]' unbanned commenter '[_2]'.} => q{'[_1]'がコメント投稿者'[_2]'を保留にしました。},
	q{User '[_1]' untrusted commenter '[_2]'.} => q{'[_1]'がコメント投稿者'[_2]'の承認を取り消しました。},

## plugins/Comments/lib/MT/Template/Tags/Comment.pm
	'Anonymous' => '匿名',
	'The MTCommentFields tag is no longer available.  Please include the [_1] template module instead.' => 'MTCommentFieldsタグは利用できません。代わりにテンプレートモジュール「[_1]」をインクルードしてください。',

## plugins/Comments/lib/MT/Template/Tags/Commenter.pm
	q{This '[_1]' tag has been deprecated. Please use '[_2]' instead.} => q{テンプレートタグ '[_1]' は廃止されました。代わりに '[_2]'を使用してください。},

## plugins/Comments/php/function.mtcommenternamethunk.php
	q{The '[_1]' tag has been deprecated. Please use the '[_2]' tag in its place.} => q{テンプレートタグ '[_1]' は廃止されました。代わりに '[_2]'を使用してください。},

## plugins/FacebookCommenters/lib/FacebookCommenters/Auth.pm
	'The login could not be confirmed because of no/invalid blog_id' => 'サイトIDが正しくないため、サインインできません。',

## plugins/FormattedText/lib/FormattedText/App.pm
	'Are you sure you want to delete the selected boilerplates?' => '定型文を削除してもよろしいですか？',
	'Boilerplates' => '定型文',
	'Create Boilerplate' => '定型文の作成',

## plugins/FormattedText/lib/FormattedText/DataAPI/Callback/FormattedText.pm
	q{The boilerplate '[_1]' is already in use in this site.} => q{定型文 '[_1]'はすでに存在します。},

## plugins/FormattedText/lib/FormattedText/FormattedText.pm
	'Boilerplate' => '定型文',
	q{The boilerplate '[_1]' is already in use in this blog.} => q{[_1]という定型文は既にこのブログに存在しています。},

## plugins/FormattedTextForTinyMCE/lib/FormattedTextForTinyMCE/App.pm
	'Cannot load boilerplate.' => '定型文をロードできませんでした。',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/App.pm
	'A Perl module required for using Google Analytics API is missing: [_1].' => 'Google アナリティクス APIを利用するのに必要なPerlモジュールのうちいくつかがありません: [_1]',
	'The name of the profile' => 'プロファイル名',
	'The web property ID of the profile' => 'ウェブ プロパティ ID',
	'You did not specify a client ID.' => 'Client IDが指定されていません。',
	'You did not specify a code.' => 'codeが指定されていません。',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/OAuth2.pm
	'An error occurred when getting accounts: [_1]: [_2]' => 'アカウントの取得ができません: [_1]: [_2]',
	'An error occurred when getting profiles: [_1]: [_2]' => 'プロファイルの取得ができません: [_1]: [_2]',
	'An error occurred when getting token: [_1]: [_2]' => 'トークンが取得できません: [_1]: [_2]',
	'An error occurred when refreshing access token: [_1]: [_2]' => 'リフレッシュトークンが取得できません: [_1]: [_2]',

## plugins/GoogleAnalytics/lib/GoogleAnalytics/Provider.pm
	'An error occurred when retrieving statistics data: [_1]: [_2]' => '統計データの取得ができません: [_1]: [_2]',

## plugins/GoogleAnalyticsV4/lib/GoogleAnalyticsV4/App.pm
	'The resource name of the property | The measurement id of the WebStreamData' => 'プロパティのリソース名 | データストリームのID',

## plugins/OpenID/lib/MT/Auth/GoogleOpenId.pm
	'A Perl module required for Google ID commenter authentication is missing: [_1].' => 'Google ID認証を利用するのに必要なPerlモジュールのうちいくつがありません: [_1]',

## plugins/OpenID/lib/MT/Auth/OpenID.pm
	'Could not load Net::OpenID::Consumer.' => 'Net::OpenID::Consumerをロードできませんでした。',
	'Could not save the session' => 'セッションを保存できませんでした。',
	'Could not verify the OpenID provided: [_1]' => 'OpenIDを検証できませんでした: [_1]',
	'The Perl module required for OpenID commenter authentication (Digest::SHA1) is missing.' => 'OpenIDプラグインを利用するのに必要なPerlモジュール(Digest::SHA1)がありません。',
	'The address entered does not appear to be an OpenID endpoint.' => '入力されたアドレスはOpenIDではありません。',
	'The text entered does not appear to be a valid web address.' => '正しいURLを入力してください。',
	'Unable to connect to [_1]: [_2]' => '[_1]に接続できません: [_2]',

## plugins/Textile/textile2.pl
	'http://www.movabletype.org/documentation/appendices/tags/%t.html' => 'https://www.movabletype.org/documentation/appendices/tags/%t.html',

## plugins/Trackback/lib/MT/App/Trackback.pm
	'This TrackBack item is disabled.' => 'トラックバックは無効に設定されています。',
	'This TrackBack item is protected by a passphrase.' => 'トラックバックはパスワードで保護されています。',
	'TrackBack ID (tb_id) is required.' => 'トラックバックIDが必要です。',
	'Trackback pings must use HTTP POST' => 'Trackback pings must use HTTP POST',
	'You are not allowed to send TrackBack pings.' => 'トラックバック送信を許可されていません。',
	'You are sending TrackBack pings too quickly. Please try again later.' => '短い期間にトラックバックを送信しすぎです。少し間をあけても
 一度送信してください。',
	'You must define a Ping template in order to display pings.' => '表示するにはトラックバックテンプレートを定義する必要があります。',
	'You need to provide a Source URL (url).' => 'URLが必要です。',
	q{Cannot create RSS feed '[_1]': } => q{フィード([_1])を作成できません: },
	q{Invalid TrackBack ID '[_1]'} => q{トラックバックID([_1])が不正です。},
	q{New TrackBack ping to '[_1]'} => q{'[_1]'に新しいトラックバックがありました},
	q{New TrackBack ping to category '[_1]'} => q{カテゴリ'[_1]'にの新しいトラックバックがありました},
	q{TrackBack on "[_1]" from "[_2]".} => q{[_2]から'[_1]'にトラックバックがありました。},
	q{TrackBack on category '[_1]' (ID:[_2]).} => q{カテゴリ'[_1]' (ID:[_2])にトラックバックがありました。},

## plugins/Trackback/lib/MT/CMS/TrackBack.pm
	'(Unlabeled category)' => '(無名カテゴリ)',
	'(Untitled entry)' => '(タイトルなし)',
	'Edit TrackBack' => 'トラックバックの編集',
	'No Excerpt' => '抜粋なし',
	'Orphaned TrackBack' => '対応する記事のないトラックバック',
	'category' => 'カテゴリ',
	q{Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from category '[_4]'} => q{'[_3]'が'[_2]'のトラックバック(ID:[_1])をカテゴリ'[_4]'から削除しました。},
	q{Ping (ID:[_1]) from '[_2]' deleted by '[_3]' from entry '[_4]'} => q{'[_3]'が'[_2]'のトラックバック(ID:[_1])を記事'[_4]'から削除しました。},

## plugins/Trackback/lib/MT/Template/Tags/Ping.pm
	q{<\$MTCategoryTrackbackLink\$> must be used in the context of a category, or with the 'category' attribute to the tag.} => q{<\$MTCategoryTrackbackLink\$>はカテゴリのコンテキストかまたはcategory属性とともに利用してください。},

## plugins/Trackback/lib/MT/XMLRPC.pm
	'HTTP error: [_1]' => 'HTTPエラー: [_1]',
	'No MTPingURL defined in the configuration file' => '構成ファイルにMTPingURLが設定されていません。',
	'No WeblogsPingURL defined in the configuration file' => '構成ファイルにWeblogsPingURLが設定されていません。',
	'Ping error: [_1]' => 'Pingエラー: [_1]',

## plugins/Trackback/lib/Trackback.pm
	'<a href="[_1]">Ping from: [_2] - [_3]</a>' => '<a href="[_1]">[_2] - [_3]からのトラックバック</a>',
	q{Trackbacks on [_1]: [_2]} => q{[_1] '[_2]'のトラックバック},

## plugins/Trackback/lib/Trackback/App/ActivityFeed.pm
	'All TrackBacks' => 'すべてのトラックバック',
	'[_1] TrackBacks' => '[_1]へのトラックバック',

## plugins/Trackback/lib/Trackback/App/CMS.pm
	'Are you sure you want to remove all trackbacks reported as spam?' => 'スパムとして報告したすべてのトラックバックを削除しますか?',

## plugins/Trackback/lib/Trackback/Blog.pm
	'Cloning TrackBack pings for blog...' => 'トラックバックを複製しています...',
	'Cloning TrackBacks for blog...' => 'トラックバックを複製しています...',

## plugins/Trackback/lib/Trackback/CMS/Entry.pm
	q{Ping '[_1]' failed: [_2]} => q{[_1]へトラックバックできませんでした: [_2]},

## plugins/Trackback/lib/Trackback/CMS/Search.pm
	'Source URL' => '送信元のURL',

## plugins/Trackback/lib/Trackback/Import.pm
	'Saving ping failed: [_1]' => 'トラックバックを保存できませんでした: [_1]',
	q{Creating new ping ('[_1]')...} => q{'[_1]'のトラックバックをインポートしています...},

## plugins/WXRImporter/lib/WXRImporter/Import.pm
	'Archive Root' => 'アーカイブパス',
	'No Site' => 'サイトがありません',

## plugins/WidgetManager/WidgetManager.pl
	'Failed.' => '失敗',
	'Moving storage of Widget Manager [_2]...' => 'ウィジェット管理[_2]の格納場所を移動しています。...',

## plugins/spamlookup/lib/spamlookup.pm
	'Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'ドメインのIPアドレス「[_2]」と送信元「[_1]」のIPアドレス「[_3]」が合致しません',
	'E-mail was previously published (comment id [_1]).' => '公開済みのメールアドレス (コメントID: [_1])',
	'Failed to resolve IP address for source URL [_1]' => 'ソースURL[_1]の解決に失敗しました。',
	'Link was previously published (TrackBack id [_1]).' => '公開済みのリンク (トラックバックID:[_1])',
	'Link was previously published (comment id [_1]).' => '公開済みのリンク (コメントID:[_1])',
	'Moderating: Domain IP does not match ping IP for source URL [_1]; domain IP: [_2]; ping IP: [_3]' => 'ドメインのIPアドレス「[_2]」と送信元「[_1]」のIPアドレス「[_3]」が合致しないため、「未公開」にします。',
	'No links are present in feedback' => 'リンクが含まれていない',
	'Number of links exceed junk limit ([_1])' => 'スパム - リンク数超過 (制限値:[_1])',
	'Number of links exceed moderation limit ([_1])' => '保留 - リンク数超過 (制限値:[_1])',
	'[_1] found on service [_2]' => 'サービス[_2]で[_1]が見つかりました。',
	q{Moderating for Word Filter match on '[_1]': '[_2]'.} => q{ワードフィルタ'[_1]'にマッチしたため公開を保留しました: '[_2]'。},
	q{Word Filter match on '[_1]': '[_2]'.} => q{'[_1]'がワードフィルタ一致: '[_2]'},
	q{domain '[_1]' found on service [_2]} => q{ドメイン'[_1]'一致(サービス: [_2])},

## search_templates/comments.tmpl
	'Find new comments' => '新しいコメントを検索',
	'No new comments were found in the specified interval.' => '指定された期間にコメントはありません。',
	'No results found' => 'ありません',
	'Posted in [_1] on [_2]' => '[_2]の[_1]に投稿されたコメント',
	'Search for new comments from:' => 'コメントを検索:',
	'five months ago' => '5か月前',
	'four months ago' => '4か月前',
	'one month ago' => '1か月前',
	'one week ago' => '1週間前',
	'one year ago' => '1年前',
	'six months ago' => '6か月前',
	'the beginning' => '最初から',
	'three months ago' => '3か月前',
	'two months ago' => '2か月前',
	'two weeks ago' => '2週間前',
	q{Select the time interval that you'd like to search in, then click 'Find new comments'} => q{検索したい期間を選択して、コメントを検索をクリックしてください。},

## search_templates/content_data_default.tmpl
	'BEGINNING OF BETA SIDEBAR FOR DISPLAY OF SEARCH INFORMATION' => 'ここから検索情報を表示するBETA SIDEBAR',
	'END OF ALPHA SEARCH RESULTS DIV' => '検索結果のDIV(ALPHA)ここまで',
	'END OF CONTAINER' => 'コンテナここまで',
	'END OF PAGE BODY' => 'ページ本体ここまで',
	'Feed Subscription' => '購読',
	'Matching content data from [_1]' => 'サイト[_1]での検索結果',
	'NO RESULTS FOUND MESSAGE' => '検索結果がないときのメッセージ',
	'Posted <MTIfNonEmpty tag="ContentAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => 'Posted <MTIfNonEmpty tag="ContentAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]',
	'SEARCH FEED AUTODISCOVERY LINK IS PUBLISHED ONLY WHEN A SEARCH HAS BEEN EXECUTED' => '検索結果のフィードのAuto Discoveryリンクは検索が実行されたときのみ表示されます。',
	'SEARCH RESULTS DISPLAY' => '検索結果表示',
	'SEARCH/TAG FEED SUBSCRIPTION INFORMATION' => '検索/タグのフィード購読情報',
	'SET VARIABLES FOR SEARCH vs TAG information' => '検索またはタグ情報を変数に代入',
	'STRAIGHT SEARCHES GET THE SEARCH QUERY FORM' => '通常の検索では検索クエリ用のフォームを返す',
	'Search this site' => 'このブログを検索',
	'Showing the first [_1] results.' => '最初の[_1]件の結果を表示',
	'Site Search Results' => 'サイトの検索結果',
	'Site search' => 'サイトの検索',
	'What is this?' => 'フィードとは',
	'http://www.sixapart.com/about/feeds' => 'http://www.sixapart.jp/about/feeds.html',
	q{Content Data matching '[_1]'} => q{'[_1]で検索されたコンテンツ'},
	q{Content Data tagged with '[_1]'} => q{'[_1]'タグのコンテンツ},
	q{If you use an RSS reader, you can subscribe to a feed of all future content data matching '[_1]'.} => q{RSSリーダーを使うと、'[_1]'を含むすべてのコンテンツのフィードを購読することができます。},
	q{If you use an RSS reader, you can subscribe to a feed of all future content data tagged '[_1]'.} => q{RSSリーダーを使うと、'[_1]'タグのすべてのコンテンツのフィードを購読することができます。},
	q{No pages were found containing '[_1]'.} => q{'[_1]'が含まれるページはありません。},

## search_templates/content_data_results_feed.tmpl
	'Search Results for [_1]' => '[_1]の検索結果',

## search_templates/default.tmpl
	'Blog Search Results' => 'Blog Searchの結果',
	'Blog search' => 'Blog Search',
	'Match case' => '大文字小文字を区別する',
	'Matching entries from [_1]' => 'ブログ[_1]での検索結果',
	'Other Tags' => 'その他のタグ',
	'Posted <MTIfNonEmpty tag="EntryAuthorDisplayName">by [_1] </MTIfNonEmpty>on [_2]' => '<MTIfNonEmpty tag="EntryAuthorDisplayName">[_1]</MTIfNonEmpty> - ([_2])',
	'Regex search' => '正規表現',
	'TAG LISTING FOR TAG SEARCH ONLY' => 'タグ一覧はタグ検索でのみ表示',
	q{Entries from [_1] tagged with '[_2]'} => q{ブログ[_1]の'[_2]'タグの記事},
	q{Entries matching '[_1]'} => q{'[_1]'で検索された記事},
	q{Entries tagged with '[_1]'} => q{'[_1]'タグの記事},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries matching '[_1]'.} => q{RSSリーダーを使うと、'[_1]'を含むすべての記事のフィードを購読することができます。},
	q{If you use an RSS reader, you can subscribe to a feed of all future entries tagged '[_1]'.} => q{RSSリーダーを使うと、'[_1]'タグのすべての記事のフィードを購読することができます。},

## themes/classic_blog/templates/comment_detail.mtml
	'[_1] replied to <a href="[_2]">comment from [_3]</a>' => '[_1]から<a href="[_2]">[_3]</a>への返信',

## themes/classic_blog/templates/comment_listing.mtml
	'Comment Detail' => 'コメント詳細',

## themes/classic_blog/templates/comment_preview.mtml
	'(You may use HTML tags for style)' => '(スタイル用のHTMLタグを使えます)',
	'Leave a comment' => 'コメントする',
	'Previewing your Comment' => 'コメントのプレビュー',
	'Replying to comment from [_1]' => '[_1]からのコメントに返信',
	'Submit' => '投稿',

## themes/classic_blog/templates/comment_response.mtml
	'Your comment has been submitted!' => 'コメントを投稿しました。',
	'Your comment submission failed for the following reasons: [_1]' => 'コメントを投稿できませんでした。エラー: [_1]',

## themes/classic_blog/templates/comments.mtml
	'Remember personal info?' => 'サインイン情報を記憶',
	'The data is modified by the paginate script' => 'ページネーションスクリプトによって変更されています。',

## themes/classic_blog/templates/recent_comments.mtml
	'<strong>[_1]:</strong> [_2] <a href="[_3]" title="full comment on: [_4]">read more</a>' => '<strong>[_1]:</strong> [_2] <a href="[_3]" title="[_4]へのコメント">続きを読む</a>',

## themes/classic_blog/templates/trackbacks.mtml
	'<a href="[_1]">[_2]</a> from [_3] on <a href="[_4]">[_5]</a>' => '[_3] - <a href="[_1]">[_2]</a> (<a href="[_4]">[_5]</a>)',
	'TrackBack URL: [_1]' => 'トラックバックURL: [_1]',
	'[_1] <a href="[_2]">Read More</a>' => '[_1] <a href="[_2]">続きを読む</a>',

## themes/classic_blog/theme.yaml
	'A traditional blogging design that comes with plenty of styles and a selection of 2 column / 3 column layouts. Best for use in standard blog publishing applications.' => 'たくさんの2カラムや3カラムレイアウトをもつ一般的なブログ用デザインです。全ブログユーザーに最適です。',
	'Displays error, pending or confirmation message for comments.' => 'コメントのエラー、保留、確認メッセージを表示します。',
	'Displays preview of comment.' => 'コメントのプレビューを表示します。',
	'Improved listing of comments.' => 'コメント表示を改善します。',

## themes/classic_website/templates/about_this_page.mtml
	'<a href="[_1]">[_2]</a> is the next entry in this website.' => '次の記事は「<a href="[_1]">[_2]</a>」です。',
	'<a href="[_1]">[_2]</a> was the previous entry in this website.' => 'ひとつ前の記事は「<a href="[_1]">[_2]</a>」です。',

## themes/classic_website/templates/blogs.mtml
	'Blogs' => 'ブログ',

## themes/classic_website/templates/syndication.mtml
	q{Subscribe to this website's feed} => q{ウェブサイトを購読},

## themes/classic_website/theme.yaml
	'Classic Website' => 'クラシックウェブサイト',
	'Create a blog portal that aggregates contents from several blogs in one website.' => 'ウェブサイトに存在するブログのコンテンツを表示するブログポータルを作成します。',

## tmpl/cms/asset_replace.tmpl
	'Upload New Asset' => '新規アセットのアップロード',

## tmpl/cms/backup.tmpl
	'Archive Format' => '圧縮フォーマット',
	'Choose sites...' => 'サイトを選択...',
	'Everything' => 'すべて',
	'Export (e)' => 'エクスポート',
	'No size limit' => '分割しない',
	'Not all the tables are exported. If you need to back up everything (including config, session values, logs, and so on), consider using a database utility. You can also download public logs from the <a href="[_1]">Log</a> menu.' => 'エクスポートには含まれない情報もあります。設定やセッション情報、ログなども含めた完全なバックアップが必要な場合はデータベース付属のユーティリティの利用を検討してください。管理画面から確認できるログについては<a href="[_1]">ログ</a>メニューからもダウンロードできます。',
	'Reset' => 'リセット',
	'Target File Size' => '出力ファイルのサイズ',
	'What to Export' => 'エクスポート対象',
	q{Don't compress} => q{圧縮しない},

## tmpl/cms/cfg_entry.tmpl
	'Accept TrackBacks' => 'トラックバック許可',
	'Alignment' => '位置',
	'Ascending' => '昇順',
	'Basename Length' => 'ファイル名の文字数',
	'Center' => '中央',
	'Character entities (&amp#8221;, &amp#8220;, etc.)' => 'エンティティ (&amp#8221;、&amp#8220;など)',
	'Compose Defaults' => '作成の既定値',
	'Content CSS will be applied when WYSIWYG editor does support. You can specify CSS file by URL or {{theme_static}} placeholder. Example: {{theme_static}}path/to/cssfile.css' => 'WYSIWYGエディタ内で利用するCSSファイルのURL又は、{{theme_static}}変数を利用したURLを指定する事ができます。WYSIWYGエディタが対応していない場合は適用されません。例: {{theme_static}}path/to/cssfile.css',
	'Content CSS' => 'コンテンツCSSファイル',
	'Czech' => 'チェコ語',
	'Danish' => 'デンマーク語',
	'Date Language' => '日付の言語',
	'Days' => '日分',
	'Descending' => '降順',
	'Display in popup' => 'ポップアップで表示する',
	'Display on the same screen' => '同じ画面に表示する',
	'Dutch' => 'オランダ語',
	'English' => '英語',
	'Entry Fields' => '記事フィールド',
	'Estonian' => 'エストニア語',
	'Excerpt Length' => '概要の文字数',
	'French' => 'フランス語',
	'German' => 'ドイツ語',
	'Icelandic' => 'アイスランド語',
	'Image default insertion options' => '画像挿入の既定値',
	'Italian' => 'イタリア語',
	'Japanese' => '日本語',
	'Left' => '左',
	'Link from image' => '画像からのリンク',
	'Link to original image' => 'オリジナル画像にリンクする',
	'Listing Default' => '表示される記事数',
	'No substitution' => '置き換えない',
	'Norwegian' => 'ノルウェー語',
	'Note: This option is currently ignored since TrackBacks are disabled either child site or system-wide.' => '注: サイトまたはシステム全体の設定でトラックバックが無効なためこのオプションは無視されます。',
	'Note: This option is currently ignored since TrackBacks are disabled either site or system-wide.' => '注: サイトまたはシステム全体の設定でトラックバックが無効なためこのオプションは無視されます。',
	'Note: This option is currently ignored since comments are disabled either child site or system-wide.' => '注: サイトまたはシステム全体でコメントが無効なためこのオプションは無視されます。',
	'Note: This option is currently ignored since comments are disabled either site or system-wide.' => '注: サイトまたはシステム全体でコメントが無効なためこのオプションは無視されます。',
	'Order' => '順番',
	'Page Fields' => 'ページフィールド',
	'Polish' => 'ポーランド語',
	'Portuguese' => 'ポルトガル語',
	'Posts' => '投稿',
	'Publishing Defaults' => '公開の既定値',
	'Punctuation Replacement Setting' => 'Word特有の文字を置き換える',
	'Punctuation Replacement' => '句読点置き換え',
	'Replace Fields' => '置き換えるフィールド',
	'Replace UTF-8 characters frequently used by word processors with their more common web equivalents.' => 'ワープロソフトで使われるUTF-8文字を対応する表示可能な文字に置き換えます。',
	'Right' => '右',
	'Save changes to these settings (s)' => '設定を保存 (s)',
	'Setting Ignored' => '設定は無視されます',
	'Slovak' => 'スロヴァキア語',
	'Slovenian' => 'スロヴェニア語',
	'Spanish' => 'スペイン語',
	'Specifies the default Text Formatting option when creating a new entry.' => 'テキストフォーマットの既定値を指定します。',
	'Suomi' => 'フィンランド語',
	'Swedish' => 'スウェーデン語',
	'Text Formatting' => 'テキストフォーマット',
	'The range for Basename Length is 15 to 250.' => 'ファイル名の文字数は、15から250の範囲で設定してください。',
	'Unpublished' => '下書き',
	'Use thumbnail' => 'サムネイルを利用',
	'WYSIWYG Editor Setting' => 'WYSIWYGエディタの設定',
	'You must set valid default thumbnail width.' => '有効なサムネイル画像の幅を指定してください。',
	'Your preferences have been saved.' => '設定を保存しました。',
	'pixels' => 'ピクセル',
	'width:' => '幅:',
	q{ASCII equivalents (&quot;, ', ..., -, --)} => q{対応するASCII文字 (&quot;、'、...、-、--)},
	q{'Popup image' template does not exist or is empty and cannot be selected.} => q{'ポップアップ画像' テンプレートが存在しない、もしくは空のため選択できません。},

## tmpl/cms/cfg_feedback.tmpl
	'([_1])' => '([_1])',
	'Accept TrackBacks from any source.' => 'すべてのトラックバックを許可する',
	'Accept comments according to the policies shown below.' => 'コメントポリシーを設定し、コメントを受け付ける',
	'Allow HTML' => 'HTMLを許可',
	'Allow commenters to include a limited set of HTML tags in their comments. Otherwise all HTML will be stripped out.' => 'コメントの内容に特定のHTMLタグの利用を許可する (許可しない場合は、すべてのHTMLタグが利用できなくなります)',
	'Any authenticated commenters' => '認証サービスで認証されたコメント投稿者のみ',
	'Anyone' => 'すべて自動的に公開する',
	'Auto-Link URLs' => 'URLを自動的にリンク',
	'Automatic Deletion' => '自動削除設定',
	'Automatically delete spam feedback after the time period shown below.' => 'スパムと判断したものを指定の日数経過後に削除する',
	'CAPTCHA Provider' => 'CAPTCHAプロバイダ',
	'Comment Display Settings' => 'コメント表示設定',
	'Comment Order' => 'コメントの表示順',
	'Comment Settings' => 'コメント設定',
	'Commenting Policy' => 'コメントポリシー',
	'Delete Spam After' => 'スパムを削除する',
	'E-mail Notification' => 'メール通知',
	'Enable External TrackBack Auto-Discovery' => '外部リンクに対するトラックバック自動検知を有効にする',
	'Enable Internal TrackBack Auto-Discovery' => '内部リンクに対するトラックバック自動検知を有効にする',
	'Hold all TrackBacks for approval before they are published.' => '公開前に許可を必要とするように、トラックバックを保留する',
	'Immediately approve comments from' => '即時公開する条件',
	'Limit HTML Tags' => 'HTMLタグを制限',
	'Moderation' => '事前確認',
	'No CAPTCHA provider available' => 'CAPTCHAプロバイダがありません',
	'No one' => '自動的に公開しない',
	'Note: Commenting is currently disabled at the system level.' => '注: コメントは現在システムレベルで無効になっています。',
	'Note: This option is currently ignored since outbound pings are disabled system-wide.' => '備考: システムレベで無効になっている外部pingオプションは現在無効となっています。',
	'Note: This option may be affected since outbound pings are constrained system-wide.' => '備考: システムレベルのみの外部pingオプションは有効になっているようです。',
	'Note: TrackBacks are currently disabled at the system level.' => '注: トラックバックは現在システムレベルで無効になっています。',
	'Off' => '行わない',
	'On' => '有効にする',
	'Only when attention is required' => '注意が必要な場合のみ',
	'Select whether you want comments displayed in ascending (oldest at top) or descending (newest at top) order.' => 'コメントを昇順に表示するか、降順に表示するか選びます。',
	'Setting Notice' => '注:',
	'Setup Registration' => '登録／認証の設定',
	'Spam Score Threshold' => 'スパム判断基準',
	'Spam Settings' => 'スパム設定',
	'This value can be between -10 and +10. The bigger this value is, the more possible spam-detection framework determines comment/trackback as a spam.' => 'この値は、-10から+10の間で指定できます。この値が大きいほど、コメントとトラックバックがスパムとして判断される可能性が高くなります。',
	'TrackBack Auto-Discovery' => '自動検知',
	'TrackBack Options' => 'トラックバックオプション',
	'TrackBack Policy' => 'トラックバックポリシー',
	'Trackback Settings' => 'トラックバック設定',
	'Transform URLs in comment text into HTML links.' => '受信したコメント内にURLが含まれる場合に自動的にリンクする',
	'Trusted commenters only' => '承認されたコメント投稿者のみ',
	'Use Comment Confirmation Page' => 'コメントの確認ページ',
	'Use defaults' => '標準の設定',
	'Use my settings' => 'カスタム設定',
	'days' => '日',
	q{'nofollow' exception for trusted commenters} => q{nofollow除外},
	q{Apply 'nofollow' to URLs} => q{URLのnofollow指定},
	q{Do not add the 'nofollow' attribute when a comment is submitted by a trusted commenter.} => q{承認されたコメント投稿者のコメントにはnofollowを適用しない},
	q{Each commenter's browser will be redirected to a comment confirmation page after their comment is accepted.} => q{コメント投稿後に、コメントの確認ページを表示する},
	q{If enabled, all URLs in comments and TrackBacks will be assigned a 'nofollow' link relation.} => q{コメントとトラックバックに含まれるすべてのURLにnofollowを設定する},
	q{No CAPTCHA provider is available in this system.  Please check to see if Image::Magick is installed and if the CaptchaSourceImageBase configuration directive points to a valid captcha-source directory within the 'mt-static/images' directory.} => q{CAPTCHAプロバイダがありません。Image::Magickがインストールされているか、またCaptchaSourceImageBaseが正しく設定されていてmt-static/images/captcha-sourceにアクセスできるか確認してください。},

## tmpl/cms/cfg_plugin.tmpl
	'Are you sure you want to disable plugins for the entire Movable Type installation?' => 'システム全体で、プラグインを無効にしますか?',
	'Are you sure you want to disable this plugin?' => 'プラグインを無効にしますか?',
	'Are you sure you want to enable plugins for the entire Movable Type installation? (This will restore plugin settings that were in place before all plugins were disabled.)' => 'システム全体で、プラグインを有効にしますか? (各プラグインの設定は、システム全体で無効化される前の状態に戻ります)',
	'Are you sure you want to enable this plugin?' => 'プラグインを有効にしますか?',
	'Are you sure you want to reset the settings for this plugin?' => 'このプラグインの設定を元に戻しますか?',
	'Author of [_1]' => '作成者',
	'Disable Plugins' => 'プラグインを利用しない',
	'Disable plugin functionality' => 'プラグインの機能を無効化する',
	'Documentation for [_1]' => '[_1]のドキュメント',
	'Enable Plugins' => 'プラグインを利用する',
	'Enable or disable plugin functionality for the entire Movable Type installation.' => 'プラグインの利用をシステムレベルで設定します。',
	'Enable plugin functionality' => 'プラグインの機能を有効化する',
	'Failed to Load' => '読み込みに失敗しました',
	'Failed to load' => '読み込みに失敗しました',
	'Find Plugins' => 'プラグインを探す',
	'Info' => '詳細',
	'Junk Filters:' => 'ジャンクフィルタ',
	'More about [_1]' => '[_1]の詳細情報',
	'No plugins with blog-level configuration settings are installed.' => 'ブログ別に設定するプラグインはインストールされていません。',
	'No plugins with configuration settings are installed.' => '設定可能なプラグインがインストールされていません。',
	'Plugin Home' => 'プラグインホーム',
	'Plugin System' => 'プラグインシステム',
	'Plugin error:' => 'プラグインエラー:',
	'Reset to Defaults' => '初期化',
	'Resources' => 'リソース',
	'Run [_1]' => '[_1]を起動',
	'Tag Attributes:' => 'タグの属性: ',
	'Text Filters' => 'テキストフィルタ',
	'This plugin has not been upgraded to support Movable Type [_1]. As such, it may not be completely functional.' => 'このプラグインは、 Movable Type [_1]向けにアップグレードされていません。そのため、動作しない場合があります。',
	'Your plugin settings have been reset.' => 'プラグインの設定をリセットしました。',
	'Your plugin settings have been saved.' => 'プラグインの設定を保存しました。',
	'Your plugins have been reconfigured.' => 'プラグインを再設定しました。',
	'_PLUGIN_DIRECTORY_URL' => 'https://plugins.movabletype.jp/',
	q{Your plugins have been reconfigured. Since you're running mod_perl, you must restart your web server for these changes to take effect.} => q{プラグインの設定が変更されました。mod_perlを利用している場合は、設定変更を有効にするためにウェブサーバーを再起動する必要があります。},
	q{Your plugins have been reconfigured. Since you're running mod_perl, you will need to restart your web server for these changes to take effect.} => q{プラグインを再設定しました。mod_perl環境下でお使いの場合は、設定を反映させるためにウェブサーバーを再起動してください。},

## tmpl/cms/cfg_prefs.tmpl
	'Active Server Page Includes' => 'ASPのインクルード',
	'Advanced Archive Publishing' => '高度な公開の設定',
	'Allow properly configured template modules to be cached to enhance publishing performance.' => '再構築の速度向上のために、テンプレートモジュール毎のキャッシュ設定を有効にする',
	'Allow to change at upload' => 'アップロード時に変更を許可する',
	'Apache Server-Side Includes' => 'ApacheのSSI',
	'Archive Settings' => 'アーカイブ設定',
	'Archive URL' => 'アーカイブURL',
	'Cancel upload' => 'アップロードしない',
	'Change license' => 'ライセンスの変更',
	'Choose archive type' => 'アーカイブタイプを選択してください',
	'Dynamic Publishing Options' => 'ダイナミックパブリッシング設定',
	'Enable conditional retrieval' => '条件付き取得を有効にする',
	'Enable dynamic cache' => 'キャッシュする',
	'Enable orientation normalization' => '画像の向きを自動的に修正する',
	'Enable revision history' => '更新履歴を有効にする',
	'Error: Movable Type cannot write to the template cache directory. Please check the permissions for the directory called <code>[_1]</code> underneath your site directory.' => 'テンプレートをキャッシュするディレクトリに書き込めません。サイトパスの下にある<code>[_1]</code>ディレクトリのパーミッションを確認してください。',
	'Error: Movable Type was not able to create a directory for publishing your [_1]. If you create this directory yourself, grant write permission to the web server.' => 'エラー: [_1]公開用のディレクトリを作成できません。自分でディレクトリが作成できる場合は、ウェブサーバーに書きこみ権限を与えてください。',
	'Error: Movable Type was not able to create a directory to cache your dynamic templates. You should create a directory called <code>[_1]</code> underneath your site directory.' => 'テンプレートをキャッシュするディレクトリを作成できません。サイトパスの下に<code>[_1]</code>ディレクトリを作成してください。',
	'If you choose a different language than the default language defined at the system level, you may need to change module names in certain templates to include different global modules.' => 'グローバルなDefaultLanguage設定と異なる言語を選んだ場合、グローバルテンプレートの名称が異なるため、テンプレート内で読み込むモジュール名の変更が必要な場合があります。',
	'Java Server Page Includes' => 'JSPのインクルード',
	'Language' => '使用言語',
	'License' => 'ライセンス',
	'Module Caching' => 'モジュールのキャッシュ',
	'Module Settings' => 'モジュール設定',
	'No archives are active' => '有効なアーカイブがありません。',
	'None (disabled)' => '無効',
	'Normalize orientation' => '画像向きの修正',
	'Note: Revision History is currently disabled at the system level.' => '備考: 更新履歴は現在システムレベルで無効となっています。',
	'Number of revisions per content data' => 'コンテンツデータの更新履歴数',
	'Number of revisions per entry/page' => '記事/ページ更新履歴数',
	'Number of revisions per template' => 'テンプレート更新履歴数',
	'Operation if a file exists' => '既存ファイルの処理',
	'Overwrite existing file' => '既存のファイルを上書きする',
	'PHP Includes' => 'PHPのインクルード',
	'Preferred Archive' => '優先アーカイブタイプ',
	'Publish With No Entries/Content Data' => '記事やコンテンツデータがないアーカイブの公開',
	'Publish archives outside of Site Root' => 'アーカイブパスをサイトパスとは別のパスで公開する',
	'Publish category archive without entries/content data' => '記事やコンテンツデータが含まれない場合でも、カテゴリアーカイブを公開する',
	'Publishing Paths' => '公開パス',
	'Remove license' => 'ライセンスの削除',
	'Rename filename' => 'ファイル名の変更',
	'Rename non-ascii filename automatically' => '日本語ファイル名を自動で変換する',
	'Revision History' => '更新履歴',
	'Revision history' => '更新履歴',
	'Select a license' => 'ライセンスの選択',
	'Server Side Includes' => 'サーバーサイドインクルード',
	'Site root must be under [_1]' => 'サイトパスは [_1] 以下を指定してください',
	'The URL of the archives section of your child site. Example: http://www.example.com/blog/archives/' => 'サイトのアーカイブのURLです。例: http://www.example.com/archives/',
	'The URL of the archives section of your site. Example: http://www.example.com/archives/' => 'サイトのアーカイブのURLです。例: http://www.example.com/archives/',
	'Time Zone' => 'タイムゾーン',
	'Time zone not selected' => 'タイムゾーンが選択されていません。',
	'UTC+0 (Universal Time Coordinated)' => 'UTC+0 (協定世界時)',
	'UTC+1 (Central European Time)' => 'UTC+1 (中央ヨーロッパ標準時)',
	'UTC+10 (East Australian Time)' => 'UTC+10(オーストラリア東部標準時)',
	'UTC+11' => 'UTC+11(ニューカレドニア',
	'UTC+12 (International Date Line East)' => 'UTC+12(ニュージーランド標準時)',
	'UTC+13 (New Zealand Daylight Savings Time)' => 'UTC+13(トンガ)',
	'UTC+2 (Eastern Europe Time)' => 'UTC+2 (東ヨーロッパ標準時)',
	'UTC+3 (Baghdad Time/Moscow Time)' => 'UTC+3 (モスクワ標準時)',
	'UTC+3.5 (Iran)' => 'UTC+3.5 (イラン標準時)',
	'UTC+4 (Russian Federation Zone 3)' => 'UTC+4 (ロシア第3標準時)',
	'UTC+5 (Russian Federation Zone 4)' => 'UTC+5 (ロシア第4標準時)',
	'UTC+5.5 (Indian)' => 'UTC+5.5 (インド標準時)',
	'UTC+6 (Russian Federation Zone 5)' => 'UTC+6 (ロシア第5標準時)',
	'UTC+6.5 (North Sumatra)' => 'UTC+6.5 (ミャンマー標準時)',
	'UTC+7 (West Australian Time)' => 'UTC+7 (タイ標準時)',
	'UTC+8 (China Coast Time)' => 'UTC+8(中国標準時)',
	'UTC+9 (Japan Time)' => 'UTC+9(日本標準時)',
	'UTC+9.5 (Central Australian Time)' => 'UTC+9.5(中央オーストラリア標準時)',
	'UTC-1 (West Africa Time)' => 'UTC-1 (ポルトガル標準時)',
	'UTC-10 (Aleutians-Hawaii Time)' => 'UTC-10 (ハワイ標準時)',
	'UTC-11 (Nome Time)' => 'UTC-11 (サモア標準時)',
	'UTC-2 (Azores Time)' => 'UTC-2 (南ジョージア島標準時)',
	'UTC-3 (Atlantic Time)' => 'UTC-3 (ブラジル標準時)',
	'UTC-3.5 (Newfoundland)' => 'UTC-3.5 (ニューファンドランド標準時)',
	'UTC-4 (Atlantic Time)' => 'UTC-4 (アメリカ大西洋標準時)',
	'UTC-5 (Eastern Time)' => 'UTC-5 (アメリカ東部標準時)',
	'UTC-6 (Central Time)' => 'UTC-6 (アメリカ中部標準時)',
	'UTC-7 (Mountain Time)' => 'UTC-7 (アメリカ山岳部標準時)',
	'UTC-8 (Pacific Time)' => 'UTC-8 (アメリカ太平洋標準時)',
	'UTC-9 (Alaskan Time)' => 'UTC-9 (アラスカ標準時)',
	'Upload Destination' => 'アップロード先',
	'Upload and rename' => '既存のファイルを残して、別のファイル名でアップロードする',
	'Use absolute path' => '絶対パスの利用',
	'Use subdomain' => 'サブドメインの利用',
	'Warning: Changing the [_1] URL requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '警告:[_1]URLを変更すると[_1]の全体再構築が必要になります。これはダイナミック・パブリッシングを利用している場合でも同様です。',
	'Warning: Changing the [_1] root requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '警告:[_1]パスを変更すると[_1]の全体再構築が必要になります。これはダイナミック・パブリッシングを利用している場合でも同様です。',
	'Warning: Changing the archive URL requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '警告:アーカイブURLを変更すると[_1]の全体再構築が必要になります。これはダイナミック・パブリッシングを利用している場合でも同様です。',
	'Warning: Changing the archive path requires a complete publish of your [_1], even when publishing profile is dynamic publishing.' => '警告:アーカイブパスを変更すると[_1]の全体再構築が必要になります。これはダイナミック・パブリッシングを利用している場合でも同様です。',
	'You did not select a time zone.' => 'タイムゾーンが選択されていません。',
	'You must set a valid Archive URL.' => '有効なアーカイブURLを指定してください。',
	'You must set a valid Local Archive Path.' => '有効なアーカイブパスを指定してください。',
	'You must set a valid Local file Path.' => '有効なファイルパスを指定してください。',
	'You must set a valid URL.' => '有効なURLを指定してください。',
	'You must set your Child Site Name.' => 'サイト名が入力されていません',
	'You must set your Local Archive Path.' => 'アーカイブパスを指定する必要があります。',
	'You must set your Local file Path.' => 'ファイルパスを指定する必要があります。',
	'You must set your Site Name.' => 'サイト名が入力されていません',
	'Your child site does not have an explicit Creative Commons license.' => 'クリエイティブ・コモンズライセンスを指定していません。',
	'Your child site is currently licensed under:' => 'このサイトは、次のライセンスで保護されています:',
	'Your site does not have an explicit Creative Commons license.' => 'クリエイティブ・コモンズライセンスを指定していません。',
	'Your site is currently licensed under:' => 'このサイトは、次のライセンスで保護されています:',
	'[_1] Settings' => '[_1]設定',
	q{The URL of your child site. Exclude the filename (i.e. index.html). End with '/'. Example: http://www.example.com/blog/} => q{サイトを公開するURLです。ファイル名(index.htmlなど)は含めず、末尾は'/'で終わります。例: http://www.example.com/blog/},
	q{The URL of your site. Exclude the filename (i.e. index.html).  End with '/'. Example: http://www.example.com/} => q{サイトを公開するURLです。ファイル名(index.htmlなど)は含めず、末尾は'/'で終わります。例: http://www.example.com/},
	q{The path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{アーカイブのインデックスファイルが公開されるパスです。絶対パス(Linuxの時は'/'、Windowsの時は'C:\'などで始まる)を推奨しますが、Movable Typeディレクトリからの相対パスも指定できます。末尾には'/'や'\'を含めません。例: /home/melody/public_html/blogやC:\www\public_html\blog},
	q{The path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{アーカイブのインデックスファイルが公開されるパスです。ウェブサイトからの相対パスを指定します。末尾には'/'や'\'を含めません。},
	q{The path where your index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{インデックスファイルが公開されるパスです。絶対パス(Linuxの時は'/'、Windowsの時は'C:\'などで始まる)を推奨しますが、Movable Typeディレクトリからの相対パスも指定できます。末尾には'/'や'\'を含めません。例: /home/melody/public_html/blogやC:\www\public_html\blog},
	q{The path where your index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{インデックスファイルが公開されるパスです。末尾には'/'や'\'を含めません。},
	q{Used to generate URLs (permalinks) for this child site's archived entries. Choose one of the archive types used in this child site's archive templates.} => q{記事にリンクするときのURLとして使われます。このサイトで使われているアーカイブテンプレートの中から選択してください。},
	q{Used to generate URLs (permalinks) for this site's archived entries. Choose one of the archive types used in this site's archive templates.} => q{記事にリンクするときのURLとして使われます。このサイトで使われているアーカイブテンプレートの中から選択してください。},

## tmpl/cms/cfg_rebuild_trigger.tmpl
	'Action' => 'アクション',
	'Allow' => '許可',
	'Config Rebuild Trigger' => '再構築トリガーの設定',
	'Content Privacy' => 'コンテンツのセキュリティ',
	'Cross-site aggregation will be allowed by default.  Individual sites can be configured through the site-level rebuild trigger settings to restrict access to their content by other sites.' => 'サイトをまたがったアグリゲーションが既定で許可されます。個別のサイトレベルでの再構築トリガーの設定で他のサイトからのコンテンツへのアクセスを制限できます。',
	'Cross-site aggregation will be disallowed by default.  Individual sites can be configured through the site-level rebuild trigger settings to allow access to their content by other sites.' => 'サイトをまたがったアグリゲーションが既定で不許可になります。個別のサイトレベルでの再構築トリガーの設定で他のサイトからのコンテンツへのアクセスを許可することもできます。',
	'Data' => 'データ',
	'Default system aggregation policy' => '既定のアグリゲーションポリシー',
	'Disallow' => '許可しない',
	'Exclude sites/child sites' => '除外するサイト',
	'Include sites/child sites' => '含めるサイト',
	'MTMultiBlog tag default arguments' => 'MTMultiBlogタグの既定の属性:',
	'Rebuild Trigger settings have been saved.' => '再構築トリガーの設定を保存しました',
	'Rebuild Triggers' => '再構築トリガー',
	'Site/Child Site' => 'サイト',
	'Use system default' => 'システムの既定値を使用',
	'You have not defined any rebuild triggers.' => '再構築トリガーを設定していません。',
	q{Enables use of the MTSites tag without include_sites/exclude_sites attributes. Comma-separated SiteIDs or 'all' (include_sites only) are acceptable values.} => q{include_sites/exclude_sites属性なしでMTSitesタグを使用できるようにします。カンマで区切ったサイトID、または「all」(include_sites のみ)が指定できます。},

## tmpl/cms/cfg_registration.tmpl
	'(No role selected)' => '(ロールが選択されていません)',
	'Allow visitors to register as members of this site using one of the Authentication Methods selected below.' => 'サイトの訪問者が、以下で選択した認証方式でユーザー登録することを許可する',
	'Authentication Methods' => '認証方式',
	'New Created User' => '新規ユーザー',
	'Note: Registration is currently disabled at the system level.' => '注:ユーザー登録は現在システムレベルで無効となっています。',
	'One or more Perl modules may be missing to use this authentication method.' => '認証を利用するのに必要なPerlモジュールが見つかりませんでした。',
	'Please select authentication methods to accept comments.' => 'コメント投稿者の認証方式を選択してください。',
	'Registration Not Enabled' => 'ユーザー登録は無効です。',
	'Select a role that you want assigned to users that are created in the future.' => 'これから作成されるユーザーに割り当てられるロールを選択します。',
	'Select roles' => 'ロール選択',
	'User Registration' => 'ユーザー登録',
	'Your site preferences have been saved.' => 'サイトの設定を保存しました。',

## tmpl/cms/cfg_system_general.tmpl
	'(No Outbound TrackBacks)' => '(すべてのトラックバック送信を無効にする)',
	'(None selected)' => '(選択されていません)',
	'A Movable Type user will be locked out if he or she submits an incorrect password [_1] or more times within [_2] seconds.' => 'MTユーザーが、[_2] 秒間に [_1] 回以上サインインに失敗した場合、そのユーザーのサインインを禁止します。',
	'A test mail was sent.' => 'テストメールを送信しました。',
	'Allow sites to be placed only under this directory' => 'ウェブサイトパスの作成を行えるディレクトリを指定します。',
	'An IP address will be locked out if [_1] or more incorrect login attempts are made within [_2] seconds from the same IP address.' => '同一IPアドレスから、[_2] 秒間に [_1] 回以上サインインに失敗した場合、そのIPアドレスからのアクセスを禁止します。',
	'Base Site Path' => 'ウェブサイトパスの既定値',
	'Changing image quality' => '画像品質の自動変換',
	'Clear' => 'クリア',
	'Debug Mode' => 'デバッグモード',
	'Disable comments for all sites and child sites.' => 'コメントを無効にする',
	'Disable notification pings for all sites and child sites.' => 'ping通知を無効にする',
	'Disable receipt of TrackBacks for all sites and child sites.' => 'トラックバックを無効にする',
	'Do not send outbound TrackBacks or use TrackBack auto-discovery if your installation is intended to be private.' => 'プライベートに設定する場合は、トラックバックを送信したりトラックバックの自動発見機能は利用しないようにしましょう。',
	'Enable image quality changing.' => '画像品質の自動変換を有効にする。',
	'IP address lockout policy' => 'IPアドレスのロック方針',
	'Image Quality Settings' => '画像品質の設定',
	'Image quality of uploaded JPEG image and its thumbnail. This value can be set an integer value between 0 and 100. Default value is 85.' => 'アップロードされた JPEG 画像や、生成されるサムネイル画像の品質を 0 から 100 の数値で指定します。初期値は 85 です。',
	'Image quality of uploaded PNG image and its thumbnail. This value can be set an integer value between 0 and 9. Default value is 7.' => 'アップロードされた PNG 画像や、生成されるサムネイル画像の圧縮レベルを 0 から 9 の数値で設定します。初期値は 7 です。',
	'Image quality(JPEG)' => 'JPEG 画像の品質',
	'Image quality(PNG)' => 'PNG 画像の圧縮レベル',
	'Imager does not support ImageQualityPng.' => 'イメージドライバーとして Imager を利用する場合、PNG 画像の圧縮レベルを設定できません。',
	'Lockout Settings' => 'アカウントロックの設定',
	'Log Path' => 'ログパス',
	'Logging Threshold' => 'ログ閾値',
	'One or more of your sites or child sites are not following the base site path (value of BaseSitePath) restriction.' => '1つ以上のサイトがサイトパスの既定値の制限に違反しています。',
	'Only to child sites within this system' => '子サイトのみ',
	'Only to sites on the following domains:' => '次のドメインに属するサイト:',
	'Outbound Notifications' => '更新通知',
	'Performance Logging' => 'パフォーマンスログ',
	'Prohibit Comments' => 'コメント',
	'Prohibit Notification Pings' => 'Ping通知禁止',
	'Prohibit TrackBacks' => 'トラックバック',
	'Send Mail To' => 'メール送信先',
	'Send Outbound TrackBacks to' => '外部トラックバック送信',
	'Send Test Mail' => 'テストメールの送信',
	'Send' => '送信',
	'Site Path Limitation' => 'ウェブサイトパスの制限',
	'System Email Address' => 'システムメールアドレス',
	'System-wide Feedback Controls' => 'システムレベルフィードバック制御',
	'The email address that should receive a test email from Movable Type.' => 'テストメールを受け取るメールアドレス',
	'The filesystem directory where performance logs are written.  The web server must have write permission in this directory.' => 'パフォーマンスログを書き出すフォルダです。ウェブサーバーから書き込み可能な場所を指定してください。',
	'The list of IP addresses. If a remote IP address is included in this list, the failed login will not recorded. You can specify multiple IP addresses separated by commas or line breaks.' => '特定のIPアドレスについて判定を行わない場合、上の一覧にカンマ又は改行区切りで追加してください。',
	'The time limit for unlogged events in seconds. Any event that takes this amount of time or longer will be reported.' => '指定した秒数以上、時間がかかった処理をログに記録します。',
	'Track revision history' => '変更履歴を保存する',
	'Turn on performance logging' => 'パフォーマンスログを有効にする',
	'Turn on performance logging, which will report any system event that takes the number of seconds specified by Logging Threshold.' => 'パフォーマンスログを有効にして、ログ閾値で設定した秒数より時間のかかる処理をログに記録します。',
	'User lockout policy' => 'ユーザーのロック方針',
	'Values other than zero provide additional diagnostic information for troubleshooting problems with your Movable Type installation.  More information is available in the <a href="https://www.movabletype.org/documentation/develooper/plugins/debug-mode.html">Debug Mode documentation</a>.' => '開発者向けの設定です。0以外の数字を設定すると、Movable Typeのデバッグメッセージを表示します。詳しくは<a href="https://www.movabletype.jp/documentation/appendices/config-directives/debugmode.html">ドキュメントを参照</a>してください。',
	'You must set a valid absolute Path.' => '正しい絶対パスを設定してください。',
	'You must set an integer value between 0 and 100.' => '0 から 100 の整数を指定してください。',
	'You must set an integer value between 0 and 9.' => '0 から 9 の整数を指定してください。',
	'Your settings have been saved.' => '設定を保存しました。',
	q{However, the following IP addresses are 'whitelisted' and will never be locked out:} => q{次の一覧で設定されたIPアドレスはアクセスが禁止されることはありません。},
	q{The system administrators whom you wish to notify if a user or an IP address is locked out.  If no administrators are selected, notifications will be sent to the 'System Email' address.} => q{通知メールを受信するシステム管理者を設定できます。受信者の設定がされていない場合は、'システムのメールアドレス'宛に通知されます。},
	q{This email address is used in the 'From:' header of each email sent by Movable Type.  Email may be sent for password recovery, commenter registration, comment and trackback notification, user or IP address lockout, and a few other minor events.} => q{このメールアドレスはMovable Typeから送られるメールの'From:'アドレスに利用されます。メールはパスワードの再設定、コメント投稿者の登録、コメントやトラックバックの通知、ユーザーまたはIPアドレスのロックアウト、その他の場合に送信されます。},

## tmpl/cms/cfg_system_users.tmpl
	'Allow Registration' => '登録',
	'Allow commenters to register on this system.' => 'コメント投稿者がMovable Typeに登録することを許可する',
	'Comma' => 'カンマ',
	'Default Tag Delimiter' => '既定のタグ区切り',
	'Default Time Zone' => '既定のタイムゾーン',
	'Default User Language' => 'ユーザーの既定の言語',
	'Minimum Length' => '最小文字数',
	'New User Defaults' => '新しいユーザーの初期設定',
	'Note: System Email Address is not set in System > General Settings. Emails will not be sent.' => 'システムのメールアドレスが設定されていないため、メールは送信されません。「設定 &gt; 全般」から設定してください。',
	'Notify the following system administrators when a commenter registers:' => '以下のシステム管理者に登録を通知する:',
	'Options' => 'オプション',
	'Password Validation' => 'パスワードの検証ルール',
	'Select system administrators' => 'システム管理者選択',
	'Should contain letters and numbers.' => '文字と数字を含める必要があります。',
	'Should contain special characters.' => '記号を含める必要があります。',
	'Should contain uppercase and lowercase letters.' => '大文字と小文字を含める必要があります。',
	'Space' => 'スペース',
	'This field must be a positive integer.' => 'このフィールドは0以上の整数を指定してください。',

## tmpl/cms/cfg_web_services.tmpl
	'(Separate URLs with a carriage return.)' => '(URLは改行で区切ってください)',
	'Data API Settings' => 'Data API の設定',
	'Data API' => 'Data API',
	'Enable Data API in system scope.' => 'システム全般での Data API の利用を許可する。',
	'Enable Data API in this site.' => 'Data API の利用を許可する。',
	'External Notifications' => '更新通知',
	'Note: This option is currently ignored because outbound notification pings are disabled system-wide.' => '備考: システム外部ping通知がシステムレベルで無効のため、このオプションは現在無効となっています。',
	'Notify ping services of [_1] updates' => 'サイト更新pingサービス通知',
	'Others:' => 'その他:',

## tmpl/cms/content_data/select_list.tmpl
	'No Content Type.' => 'コンテンツタイプがありません',
	'Select List Content Type' => 'コンテンツタイプを選択',

## tmpl/cms/content_field_type_options/asset.tmpl
	'Allow users to select multiple assets?' => '複数アセットの選択を許可する',
	'Allow users to upload a new asset?' => 'ファイルのアップロードを許可する',
	'Maximum number of selections' => '選択できる最大件数',
	'Minimum number of selections' => '選択できる最小件数',

## tmpl/cms/content_field_type_options/asset_audio.tmpl
	'Allow users to upload a new audio asset?' => '新しいオーディオファイルのアップロードを許可する',

## tmpl/cms/content_field_type_options/asset_image.tmpl
	'Allow users to select multiple image assets?' => '複数の画像の選択を許可する',
	'Allow users to upload a new image asset?' => '新しい画像ファイルのアップロードを許可する',
	'Thumbnail height' => 'サムネイル画像の最大高',
	'Thumbnail width' => 'サムネイル画像の最大幅',

## tmpl/cms/content_field_type_options/asset_video.tmpl
	'Allow users to select multiple video assets?' => '複数のビデオの選択を許可する',
	'Allow users to upload a new video asset?' => '新しいビデオファイルのアップロードを許可する',

## tmpl/cms/content_field_type_options/categories.tmpl
	'Allow users to create new categories?' => 'カテゴリの作成を許可する',
	'Allow users to select multiple categories?' => '複数のカテゴリの選択を許可する',
	'Source Category Set' => 'カテゴリセット',

## tmpl/cms/content_field_type_options/checkboxes.tmpl
	'Selected' => '選択状態',
	'Value' => '値',
	'Values' => '値',
	'add' => '追加',

## tmpl/cms/content_field_type_options/content_type.tmpl
	'Allow users to select multiple values?' => '複数選択を許可する',
	'Source Content Type' => 'コンテンツタイプ',
	'There is no content type that can be selected. Please create a content type if you use the Content Type field type.' => 'コンテンツタイプが存在しないため利用できません。コンテンツタイプを作成する必要があります。',

## tmpl/cms/content_field_type_options/date.tmpl
	'Initial Value' => '初期値',

## tmpl/cms/content_field_type_options/date_time.tmpl
	'Initial Value (Date)' => '初期値（日付）',
	'Initial Value (Time)' => '初期値（時刻）',

## tmpl/cms/content_field_type_options/multi_line_text.tmpl
	'Input format' => '入力フォーマット',
	'Use all rich text decoration buttons' => 'リッチテキストの入力支援ボタンをすべて利用する',

## tmpl/cms/content_field_type_options/number.tmpl
	'Max Value' => '最大値',
	'Min Value' => '最小値',
	'Number of decimal places' => '小数点以下の桁数',

## tmpl/cms/content_field_type_options/single_line_text.tmpl
	'Max Length' => '最大文字数',
	'Min Length' => '最小文字数',

## tmpl/cms/content_field_type_options/tables.tmpl
	'Allow users to increase/decrease cols?' => '列の追加と削除を許可する',
	'Allow users to increase/decrease rows?' => '行の追加と削除を許可する',
	'Initial Cols' => '初期列数',
	'Initial Rows' => '初期行数',

## tmpl/cms/content_field_type_options/tags.tmpl
	'Allow users to create new tags?' => '新しいタグの作成を許可する',
	'Allow users to input multiple values?' => '複数のタグを許可する',

## tmpl/cms/content_field_type_options/text_label.tmpl
	'This block is only visible in the administration screen for comments.' => 'このブロックはコメントのため、管理画面でのみ表示されます。',
	'__TEXT_LABEL_TEXT' => 'テキスト',

## tmpl/cms/dashboard/dashboard.tmpl
	'Dashboard' => 'ダッシュボード',
	'Select a Widget...' => 'ウィジェットの選択...',
	'System Overview' => 'システム',
	'Your Dashboard has been updated.' => 'ダッシュボードを更新しました。',

## tmpl/cms/dialog/adjust_sitepath.tmpl
	'Back (b)' => '戻る (b)',
	'Confirm Publishing Configuration' => '公開設定',
	'Continue (s)' => '次へ (s)',
	'Enter the new URL of the archives section of your child site. Example: http://www.example.com/blog/archives/' => '新しいサイトのアーカイブURLを入力してください。例: http://www.example.com/blog/archives/',
	'Please choose parent site.' => '親サイトを選択してください',
	'Site Path' => 'サイトパス',
	'You must select a parent site.' => '親サイトを選択してください',
	'You must set a valid Site URL.' => '有効なサイトURLを指定してください。',
	'You must set a valid local site path.' => '有効なサイトパスを指定してください。',
	q{Enter the new URL of your public child site. End with '/'. Example: http://www.example.com/blog/} => q{新しいサイトURLを入力してください。末尾は'/'で終わります。例: http://www.example.com/blog/},
	q{Enter the new path where your archives section index files will be published. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred. Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{新しくアーカイブのインデックスファイルを公開するパスを入力して下さい。絶対パス(Linuxの時は'/'、Windowsの時は'C:\'などで始まる)を推奨します。末尾には'/'や'\'を含めません。例: /home/mt/public_html/blog or C:\www\public_html\blog},
	q{Enter the new path where your archives section index files will be published. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{新しくアーカイブのインデックスファイルを公開するパスを入力して下さい。末尾には'/'や'\'を含めません。例: /home/mt/public_html/blog or C:\www\public_html\blog},
	q{Enter the new path where your main index file will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{新しくインデックスファイルを公開するパスを入力して下さい。末尾には'/'や'\'を含めません。例: /home/mt/public_html/blog or C:\www\public_html\blog},
	q{Enter the new path where your main index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{新しくインデックスファイルを公開するパスを入力して下さい。絶対パス(Linuxの時は'/'、Windowsの時は'C:\'などで始まる)を推奨します。末尾には'/'や'\'を含めません。例: /home/mt/public_html/blog or C:\www\public_html\blog},

## tmpl/cms/dialog/asset_edit.tmpl
	'Close (x)' => '閉じる (x)',
	'Edit Asset' => 'アセットの編集',
	'Edit Image' => '画像を編集',
	'Error creating thumbnail file.' => 'サムネイルを作成できませんでした。',
	'File Size' => 'ファイルサイズ',
	'Metadata cannot be updated because Metadata in this image seems to be broken.' => '画像のメタ情報が正しくないため、メタ情報は更新されません。',
	'Save changes to this asset (s)' => 'アセットへの変更を保存 (s)',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to close this dialog?' => '保存されていないアセットへの変更は失われます。編集を終了しますか？',
	'Your changes have been saved.' => '変更を保存しました。',
	'Your edited image has been saved.' => '編集された画像を保存しました。',

## tmpl/cms/dialog/asset_modal.tmpl
	'Add Assets' => 'アセットを追加',
	'Cancel (x)' => 'キャンセル (x)',
	'Choose Asset' => 'アセットを選択',
	'Insert (s)' => '挿入 (s)',
	'Insert' => '挿入',
	'Library' => 'アセット一覧',
	'Next (s)' => '次へ (s)',

## tmpl/cms/dialog/asset_options.tmpl
	'Create a new entry using this uploaded file.' => 'アップロードしたファイルを使って記事を作成する',
	'Create entry using this uploaded file' => 'アップロードしたファイルを使って記事を作成する',
	'File Options' => 'ファイルオプション',
	'Finish (s)' => '完了 (s)',
	'Finish' => '完了',

## tmpl/cms/dialog/asset_upload.tmpl
	'You need to configure your blog.' => 'ブログを設定する必要があります。',
	'Your blog has not been published.' => 'ブログが公開されていません。',

## tmpl/cms/dialog/clone_blog.tmpl
	'Categories/Folders' => 'カテゴリ/フォルダ',
	'Child Site Details' => 'サイトの詳細',
	'Clone' => '複製',
	'Confirm' => '確認',
	'Entries/Pages' => '記事/ページ',
	'Exclude Categories/Folders' => 'カテゴリ/フォルダの除外',
	'Exclude Comments' => 'コメントの除外',
	'Exclude Entries/Pages' => '記事/ページの除外',
	'Exclude Trackbacks' => 'トラックバックの除外',
	'Exclusions' => '除外',
	'This is set to the same URL as the original child site.' => '複製元のサイトと同じURLを設定します。',
	'This will overwrite the original child site.' => '複製元のサイト設定を上書きします。',
	'Warning: Changing the archive URL can result in breaking all links in your child site.' => '警告: アーカイブURLを変更することでサイト上のすべてのリンクがリンク切れとなる場合があります。',
	'Warning: Changing the archive path can result in breaking all links in your child site.' => '警告: アーカイブパスを変更するとサイト上のすべてのリンクがリンク切れとなる場合があります。',

## tmpl/cms/dialog/comment_reply.tmpl
	'On [_1], [_2] commented on [_3]' => '[_2]から[_3]へのコメント([_1])',
	'Reply to comment' => 'コメントに返信',
	'Submit reply (s)' => '返信を投稿 (s)',
	'Your reply:' => '返信',

## tmpl/cms/dialog/content_data_modal.tmpl
	'Add [_1]' => '[_1]を追加',
	'Choose [_1]' => '[_1]を選択',
	'Create and Insert' => '作成して挿入',

## tmpl/cms/dialog/create_association.tmpl
	'No blogs exist in this installation. [_1]Create a blog</a>' => 'ブログがありません。[_1]ブログを作成する</a>',
	'No groups exist in this installation. [_1]Create a group</a>' => 'グループがありません。[_1]グループを作成する</a>',
	'No roles exist in this installation. [_1]Create a role</a>' => 'ロールがありません。[_1]ロールを作成する</a>',
	'No sites exist in this installation. [_1]Create a site</a>' => 'サイトがありません。[_1]サイトを作成する</a>',
	'No users exist in this installation. [_1]Create a user</a>' => 'ユーザーが存在しません。[_1]ユーザーを作成する</a>',
	'all' => 'すべて',

## tmpl/cms/dialog/create_trigger.tmpl
	'Event' => 'イベント',
	'IF <span class="badge source-data-badge">Data</span> in <span class="badge source-site-badge">Site</span> is <span class="badge source-trigger-badge">Triggered</span>, <span class="badge destination-action-badge">Action</span> in <span class="badge destination-site-badge">Site</span>' => '<span class="badge source-site-badge badge--selected">サイト</span>にある<span class="badge source-data-badge">データ</span>が<span class="badge source-trigger-badge">トリガー</span>されたとき、<span class="badge destination-site-badge">サイト</span>で<span class="badge destination-action-badge">アクション</span>される。',
	'OK (s)' => 'OK (s)',
	'OK' => 'OK',
	'Object Name' => '対象',
	'Select Trigger Action' => 'アクションを選択',
	'Select Trigger Event' => 'イベントを選択',
	'Select Trigger Object' => '対象を選択',

## tmpl/cms/dialog/edit_image.tmpl
	'Crop' => 'トリミング',
	'Flip horizontal' => '水平方向に反転',
	'Flip vertical' => '垂直方向に反転',
	'Height' => '高さ',
	'Keep aspect ratio' => '縦横比を維持する',
	'Redo' => 'やり直す',
	'Remove All metadata' => '画像からメタ情報を削除する',
	'Remove GPS metadata' => '画像から GPS 情報を削除する',
	'Rotate left' => '左回転',
	'Rotate right' => '右回転',
	'Save (s)' => '保存',
	'Undo' => '取り消す',
	'Width' => '幅',
	'You have unsaved changes to this image that will be lost. Are you sure you want to close this dialog?' => '保存されていない画像の変更は失われます。編集を終了しますか？',

## tmpl/cms/dialog/entry_notify.tmpl
	'(Body will be sent without any text formatting applied.)' => '(フォーマットされずに本文が送られます)',
	'All addresses from Address Book' => 'アドレス帳のすべての連絡先',
	'Enter email addresses on separate lines or separated by commas.' => '1行に1メールアドレス、またはコンマでメールアドレスを区切り、入力します。',
	'Optional Content' => 'コンテンツ(任意)',
	'Optional Message' => 'メッセージ(任意)',
	'Recipients' => 'あて先',
	'Send a Notification' => '通知の送信',
	'Send notification (s)' => '通知を送信 (s)',
	'You must specify at least one recipient.' => '少なくとも一人の受信者を指定する必要があります。',
	q{Your [_1]'s name, title, and a link to view it will be sent in the notification. Additionally, you can add a message, include an excerpt and/or send the entire body.} => q{[_1]名、タイトル、およびパーマリンクが送られます。メッセージを追加したり、概要や本文を送ることもできます。},

## tmpl/cms/dialog/list_revision.tmpl
	'Select the revision to populate the values of the Edit screen.' => '編集画面に読み込む更新履歴を選んでください。',

## tmpl/cms/dialog/move_blogs.tmpl
	'Warning: You need to copy uploaded assets to the new path manually. It is also recommended not to delete files in the old path to avoid broken links.' => '警告: アップロード済みのファイルは、新しいウェブサイトのパスに手動でコピーする必要があります。また、旧パスのファイルも残すことで、リンク切れを防止できます。',

## tmpl/cms/dialog/multi_asset_options.tmpl
	'Display [_1]' => '[_1]の表示',
	'Insert Options' => '挿入オプション',

## tmpl/cms/dialog/new_password.tmpl
	'Change Password' => 'パスワードの変更',
	'Change' => '変更',
	'Confirm New Password' => '新しいパスワード確認',
	'Enter the new password.' => '新しいパスワードを入力してください。',
	'New Password' => '新しいパスワード',

## tmpl/cms/dialog/publishing_profile.tmpl
	'All templates published statically via Publish Queue.' => 'すべてのテンプレートを公開キュー経由でスタティックパブリッシングします。',
	'Are you sure you wish to continue?' => '続けてもよろしいですか?',
	'Background Publishing' => 'バックグラウンドパブリッシング',
	'Choose the profile that best matches the requirements for this [_1].' => '[_1]の要件に最も近いプロファイルを選択してください。',
	'Dynamic Archives Only' => 'アーカイブのみダイナミックパブリッシング',
	'Dynamic Publishing' => 'ダイナミックパブリッシング',
	'Execute' => '実行',
	'High Priority Static Publishing' => '一部アーカイブのみ非同期スタティックパブリッシング',
	'Immediately publish Main Index and Feed template, Entry archives, Page archives and ContentType archives statically. Use Publish Queue to publish all other templates statically.' => 'メインページ、フィード、記事アーカイブ、ウェブページアーカイブ、コンテンツタイプアーカイブをスタティックパブリッシングし、他のテンプレートは公開キューを経由してスタティックパブリッシングします。',
	'Immediately publish all templates statically.' => 'すべてのテンプレートをスタティックパブリッシングします。',
	'Publish all Archive templates dynamically. Immediately publish all other templates statically.' => 'アーカイブテンプレートをすべてダイナミックパブリッシングします。他のテンプレートはスタティックパブリッシングします。',
	'Publish all templates dynamically.' => 'すべてのテンプレートをダイナミックパブリッシングします。',
	'Publishing Profile' => '公開プロファイル',
	'Static Publishing' => 'スタティックパブリッシング',
	'This new publishing profile will update your publishing settings.' => '公開プロファイルの設定内容を使って、すべてのテンプレートの設定を更新します。',
	'child site' => '子サイト',
	'site' => 'サイト',

## tmpl/cms/dialog/recover.tmpl
	'Back (x)' => '戻る (x)',
	'Reset (s)' => 'リセット (s)',
	'Reset Password' => 'パスワードのリセット',
	'Sign in to Movable Type (s)' => 'Movable Type にサインイン (s)',
	'Sign in to Movable Type' => 'Movable Type にサインイン',
	'The email address provided is not unique.  Please enter your username.' => '同じメールアドレスを持っているユーザーがいます。ユーザー名を入力してください。',

## tmpl/cms/dialog/refresh_templates.tmpl
	'Cannot find template set. Please apply [_1]theme[_2] to refresh your templates.' => 'テンプレートセットが見つかりません。[_1]テーマを適用[_2]して、テンプレートを初期化してください。',
	'Deletes all existing templates and installs factory default template set.' => '既存のテンプレートをすべて削除して、製品既定のテンプレートセットをインストールします。',
	'Make backups of existing templates first' => '既存のテンプレートのバックアップを作成する',
	'Refresh Global Templates' => 'グローバルテンプレートを初期化',
	'Refresh global templates' => 'グローバルテンプレートを初期化',
	'Reset to factory defaults' => '初期状態にリセット',
	'Reset to theme defaults' => 'デフォルトテーマのリセット',
	'Revert modifications of theme templates' => 'テーマテンプレートの変更の取り消し',
	'Updates current templates while retaining any user-created templates.' => 'テンプレートを更新しますが、ユーザーが作成したテンプレートには影響しません。',
	'You have requested to <strong>apply a new template set</strong>. This action will:' => '<strong>新しいテンプレートセットを適用</strong>しようとしています。この操作では以下の作業を行います。',
	'You have requested to <strong>refresh the current template set</strong>. This action will:' => '<strong>現在のテンプレートセットを初期化</strong>しようとしています。この操作では以下の作業を行います。',
	'You have requested to <strong>refresh the global templates</strong>. This action will:' => '<strong>グローバルテンプレート</strong>を初期化しようとしています。この操作では以下の作業を行います。',
	'You have requested to <strong>reset to the default global templates</strong>. This action will:' => '<strong>グローバルテンプレートを既定の状態に</strong>リセットしようとしています。この操作では以下の作業を行います。',
	'delete all of the templates in your blog' => 'ブログのテンプレートはすべて削除されます。',
	'delete all of your global templates' => 'グローバルテンプレートをすべて削除します。',
	'install new templates from the default global templates' => '既定のグローバルテンプレートを新しくインストールします。',
	'install new templates from the selected template set' => 'テンプレートセットのテンプレートを新規にインストールします。',
	'make backups of your templates that can be accessed through your backup filter' => 'テンプレートのバックアップを作成します。バックアップにはクイックフィルタからアクセスできます。',
	'overwrite some existing templates with new template code' => '既存のテンプレートを新しいテンプレートで置き換えます。',
	'potentially install new templates' => '(もしあれば)新しいテンプレートをインストールします。',
	q{Deletes all existing templates and install the selected theme's default.} => q{全テンプレートを削除して、既定となっているテーマをインストールします。},

## tmpl/cms/dialog/restore_end.tmpl
	'All data imported successfully!' => 'すべてのデータをインポートしました。',
	'An error occurred during the import process: [_1] Please check your import file.' => 'インポートの途中でエラーが発生しました: [_1] インポートファイルを確認してください。',
	'Close (s)' => '閉じる (s)',
	'Next Page' => '次へ',
	'The page will redirect to a new page in 3 seconds. [_1]Stop the redirect.[_2]' => '3秒後に新しいページに進みます。[_1]タイマーを止める[_2]',
	'View Activity Log (v)' => 'ログの表示 (v)',

## tmpl/cms/dialog/restore_start.tmpl
	'Importing...' => 'インポートを開始します...',

## tmpl/cms/dialog/restore_upload.tmpl
	'Canceling the process will create orphaned objects.  Are you sure you want to cancel the restore operation?' => '作業を中止すると、孤立したオブジェクトが残されます。本当に作業を中止しますか?',
	'Please upload the file [_1]' => '[_1]をアップロードしてください。',
	'Restore: Multiple Files' => '復元: 複数ファイル',

## tmpl/cms/dialog/select_association_type.tmpl
	'Grant site permission to group' => 'グループにサイトの権限を割り当てる',
	'Grant site permission to user' => 'ユーザーにサイトの権限を割り当てる',

## tmpl/cms/edit_asset.tmpl
	'Appears in...' => '利用状況',
	'Embed Asset' => 'アセットの埋め込み',
	'Prev' => '前',
	'Related Assets' => '関連するアセット',
	'Stats' => '情報',
	'This asset has been used by other users.' => 'このアセットは、他のユーザーにより利用されています。',
	'You have unsaved changes to this asset that will be lost. Are you sure you want to edit image?' => '保存されていないアセットへの変更は失われます。画像を編集しますか？',
	'You have unsaved changes to this asset that will be lost.' => '保存されていないアセットへの変更は失われます。',
	'You must specify a name for the asset.' => 'アセットに名前を設定してください。',
	'[_1] - Created by [_2]' => '作成: [_2] - [_1]',
	'[_1] - Modified by [_2]' => '更新: [_2] - [_1]',
	'[_1] is missing' => '[_1]がありません。',

## tmpl/cms/edit_author.tmpl
	'(Use Site Default)' => '(サイトの既定値を利用)',
	'A new password has been generated and sent to the email address [_1].' => '新しいパスワードが作成され、メールアドレス[_1]に送信されました。',
	'Confirm Password' => 'パスワード確認',
	'Create User (s)' => 'ユーザーを作成 (s)',
	'Current Password' => '現在のパスワード',
	'Date Format' => '日付',
	'Default date formatting in the Movable Type interface.' => '管理画面で使用する日付の表示フォーマットです。',
	'Default text formatting filter when creating new entries and new pages.' => '記事とウェブページを作成する際のテキスト形式を指定します。',
	'Display language for the Movable Type interface.' => '管理画面で使用する言語です。',
	'Edit Profile' => 'ユーザー情報の編集',
	'Enter preferred password.' => '新しいパスワードを入力してください。',
	'Error occurred while removing userpic.' => 'プロフィール画像の削除中にエラーが発生しました。',
	'External user ID' => '外部ユーザーID',
	'Full' => '年月日',
	'Initial Password' => '初期パスワード',
	'Initiate Password Recovery' => 'パスワードの再設定',
	'Password recovery word/phrase' => 'パスワード再設定用のフレーズ',
	'Preferences' => '設定',
	'Preferred method of separating tags.' => 'タグを区切るときに使う文字を選択します。',
	'Relative' => '経過',
	'Remove Userpic' => 'プロフィール画像を削除',
	'Reveal' => '内容を表示',
	'Save changes to this author (s)' => 'ユーザーへの変更を保存 (s)',
	'Select Userpic' => 'プロフィール画像の選択',
	'System Permissions' => 'システム権限',
	'Tag Delimiter' => 'タグの区切り',
	'Text Format' => 'テキスト形式',
	'The name displayed when content from this user is published.' => 'コンテンツの公開時に、この名前が表示されます。',
	'This profile has been unlocked.' => 'ユーザーアカウントのロックが解除されました。',
	'This profile has been updated.' => 'ユーザー情報を更新しました。',
	'This user was classified as disabled.' => 'このユーザーは無効にされています。',
	'This user was classified as pending.' => 'このユーザーは保留中にされています。',
	'This user was locked out.' => 'このユーザーはロックされています。',
	'User properties' => 'ユーザー属性',
	'Web Services Password' => 'Webサービスパスワード',
	'You must use half-width character for password.' => 'パスワードには全角文字を利用できません。',
	'Your web services password is currently' => 'Webサービスのパスワード',
	'_USAGE_PASSWORD_RESET' => 'ユーザーのパスワードを再設定できます。パスワードがランダムに生成され、[_1]にメールで送信されます。',
	'_USER_DISABLED' => '無効',
	'_USER_ENABLED' => '有効',
	'_USER_PENDING' => '保留',
	'_USER_STATUS_CAPTION' => '状態',
	'_WARNING_PASSWORD_RESET_SINGLE' => '[_1]のパスワードを再設定しようとしています。新しいパスワードはランダムに生成され、ユーザーにメールで送信されます。続行しますか?',
	q{If you want to unlock this user click the 'Unlock' link. <a href="[_1]">Unlock</a>} => q{<a href="[_1]">ロックを解除する</a>},
	q{This User's website (e.g. https://www.movabletype.com/).  If the Website URL and Display Name fields are both populated, Movable Type will by default publish entries and comments with bylines linked to this URL.} => q{ユーザーの個人ホームページのURL。表示する名前とウェブサイトURLは、コンテンツやコメントの公開時に利用されます。},

## tmpl/cms/edit_blog.tmpl
	'Create Child Site (s)' => 'サイトを作成 (s)',
	'Name your child site. The site name can be changed at any time.' => 'サイト名を付けてください。この名前はいつでも変更できます。',
	'Select the theme you wish to use for this child site.' => 'このサイトで利用するテーマを選択してください。',
	'Select your timezone from the pulldown menu.' => 'プルダウンメニューからタイムゾーンを選択してください。',
	'Site Theme' => 'サイトテーマ',
	'You must set your Local Site Path.' => 'サイトパスを指定する必要があります。',
	'Your child site configuration has been saved.' => 'サイトの設定を保存しました。',
	q{Enter the URL of your Child Site. Exclude the filename (i.e. index.html). Example: http://www.example.com/blog/} => q{サイトを公開するURLを入力してください。ファイル名(index.htmlなど)は含めず、末尾は'/'で終わります。例: http://www.example.com/blog/},
	q{The path where your index files will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred.  Do not end with '/' or '\'. Example: /home/mt/public_html or C:\www\public_html} => q{インデックスファイルが公開されるパスを入力してください。絶対パス(Linuxの時は'/'、Windowsの時は'C:\'などで始まる)を推奨します。末尾には'/'や'\'を含めません。例: /home/melody/public_html/blogやC:\www\public_html\blog},
	q{The path where your index files will be located. Do not end with '/' or '\'.  Example: /home/mt/public_html/blog or C:\www\public_html\blog} => q{インデックスファイルを配置するパスを入力してください。例: /home/mt/public_html/blogやC:\www\public_html\blog},

## tmpl/cms/edit_category.tmpl
	'Allow pings' => 'トラックバックを許可する',
	'Edit Category' => 'カテゴリの編集',
	'Inbound TrackBacks' => 'トラックバック受信',
	'Manage entries in this category' => 'このカテゴリに属する記事の一覧',
	'Outbound TrackBacks' => 'トラックバック送信',
	'Passphrase Protection' => 'パスワード保護',
	'Please enter a valid basename.' => '有効な出力ファイル/フォルダ名を入力してください。',
	'Save changes to this category (s)' => 'カテゴリへの変更を保存 (s)',
	'This is the basename assigned to your category.' => 'カテゴリの出力ファイル/フォルダ名です。',
	'TrackBack URL for this category' => 'このカテゴリのトラックバックURL',
	'Trackback URLs' => 'トラックバックURL',
	'Useful links' => 'ショートカット',
	'View TrackBacks' => 'トラックバックを見る',
	'You must specify a basename for the category.' => '出力ファイル/フォルダ名を設定して下さい。',
	'You must specify a label for the category.' => 'カテゴリ名を設定してください。',
	'_CATEGORY_BASENAME' => '出力ファイル/フォルダ名',
	q{Warning: Changing this category's basename may break inbound links.} => q{警告: このカテゴリの出力ファイル/フォルダ名を変更すると、URLが変更されてリンク切れを招く場合があります。},

## tmpl/cms/edit_comment.tmpl
	'Ban Commenter' => 'コメント投稿者を禁止',
	'Comment Text' => '本文',
	'Commenter Status' => 'コメント投稿者の状態',
	'Delete this comment (x)' => 'コメントを削除 (x)',
	'Manage Comments' => 'コメントの管理',
	'No url in profile' => '(URL がありません)',
	'Reply to this comment' => 'コメントに返信',
	'Reported as Spam' => 'スパムとして報告',
	'Responses to this comment' => 'このコメントに返信する',
	'Results' => '結果',
	'Save changes to this comment (s)' => 'コメントへの変更を保存 (s)',
	'Score' => 'スコア',
	'Test' => 'テスト',
	'The comment has been approved.' => 'コメントを公開しました。',
	'This comment was classified as spam.' => 'このコメントはスパムと判定されました。',
	'Total Feedback Rating: [_1]' => '最終レーティング: [_1]',
	'Trust Commenter' => 'コメント投稿者を承認',
	'Trusted' => '承認済み',
	'Unavailable for OpenID user' => 'OpenIDユーザーにはありません',
	'Unban Commenter' => 'コメント投稿者の禁止を解除',
	'Untrust Commenter' => 'コメント投稿者の承認を取り消し',
	'View [_1] comment was left on' => 'コメントされた[_1]を表示',
	'View all comments by this commenter' => 'このコメント投稿者のすべてのコメントを見る',
	'View all comments created on this day' => 'この日に投稿されたすべてのコメントを見る',
	'View all comments from this IP Address' => 'このIPアドレスからのすべてのコメントを見る',
	'View all comments on this [_1]' => '[_1]のすべてのコメントを見る',
	'View all comments with this URL' => 'このURLのすべてのコメントを見る',
	'View all comments with this email address' => 'このメールアドレスのすべてのコメントを見る',
	'View all comments with this status' => 'このステータスのすべてのコメントを見る',
	'View this commenter detail' => 'コメント投稿者の詳細を見る',
	'[_1] no longer exists' => '[_1]が存在しません',
	'_external_link_target' => '_blank',
	'comment' => 'コメント',
	'comments' => 'コメント',

## tmpl/cms/edit_commenter.tmpl
	'Authenticated' => '認証済み',
	'Ban user (b)' => 'ユーザーを禁止 (b)',
	'Ban' => '禁止',
	'Comments from [_1]' => '[_1]からのコメント',
	'Identity' => 'ID',
	'The commenter has been banned.' => 'コメント投稿者を禁止しました。',
	'The commenter has been trusted.' => 'コメント投稿者を承認しました。',
	'Trust user (t)' => 'ユーザーを承認 (t)',
	'Trust' => '承認',
	'Unban user (b)' => 'ユーザーの禁止を解除 (b)',
	'Unban' => '禁止を解除',
	'Untrust user (t)' => 'ユーザーの承認を解除 (t)',
	'Untrust' => '承認を解除',
	'View all comments with this name' => 'この名前のすべてのコメントを見る',
	'View' => '表示',
	'Withheld' => '公開しない',
	'commenter' => 'コメント投稿者',
	'commenters' => 'コメント投稿者',
	'to act upon' => '対象に',

## tmpl/cms/edit_content_data.tmpl
	'(Max length: [_1])' => '(最大文字数: [_1])',
	'(Max select: [_1])' => '(最大: [_1])',
	'(Max tags: [_1])' => '(最大: [_1])',
	'(Max: [_1] / Number of decimal places: [_2])' => '(最大: [_1] / 小数点以下の桁数: [_2])',
	'(Max: [_1])' => '(最大: [_1])',
	'(Min length: [_1] / Max length: [_2])' => '(最小文字数: [_1] / 最大文字数: [_2])',
	'(Min length: [_1])' => '(最小文字数: [_1])',
	'(Min select: [_1] / Max select: [_2])' => '(最小: [_1] / 最大: [_2]',
	'(Min select: [_1])' => '(最小: [_1])',
	'(Min tags: [_1] / Max tags: [_2])' => '(最小: [_1] / 最大: [_2])',
	'(Min tags: [_1])' => '(最小: [_1])',
	'(Min: [_1] / Max: [_2] / Number of decimal places: [_3])' => '(最小: [_1] / 最大: [_2] / 小数点以下の桁数: [_3])',
	'(Min: [_1] / Max: [_2])' => '(最小: [_1] / 最大: [_2])',
	'(Min: [_1] / Number of decimal places: [_2])' => '(最小: [_1] / 小数点以下の桁数: [_2])',
	'(Min: [_1])' => '(最小: [_1])',
	'(Number of decimal places: [_1])' => '(小数点以下の桁数: [_1])',
	'<a href="[_1]" >Create another [_2]?</a>' => '続けて<a href="[_1]">[_2]を作成</a>しますか？',
	'@' => '@',
	'A saved version of this content data was auto-saved [_2] but it is outdated.<br><a href="[_1]" class="alert-link">Recover auto-saved content</a> / <a href="[_3]" class="alert-link">Discard auto-saved content</a>' => 'このコンテンツデータには[_2]に自動保存された修正版がありますが、現在の内容は自動保存よりも後に保存されたものです。<br><a href="[_1]" class="alert-link">自動保存された内容に戻す</a> / <a href="[_3]" class="alert-link">自動保存された内容を破棄する</a>',
	'A saved version of this content data was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'このコンテンツデータには[_2]に自動保存された修正版があります。<a href="[_1]" class="alert-link">自動保存された内容に戻す</a>',
	'An error occurred while trying to recover your saved content data.' => 'コンテンツデータを元に戻す際にエラーが発生しました。',
	'Auto-saving...' => '自動保存中...',
	'Change note' => '変更メモ',
	'Draft this [_1]' => '[_1]の下書き',
	'Enter a label to identify this data' => 'このデータを識別するラベルを入力します',
	'Last auto-save at [_1]:[_2]:[_3]' => '[_1]:[_2]:[_3]に自動保存済み',
	'No revision(s) associated with this [_1]' => '[_1]の更新履歴が見つかりません',
	'Not specified' => '指定されていません',
	'One tag only' => 'ひとつのみ',
	'Permalink:' => 'パーマリンク:',
	'Publish On' => '公開する',
	'Publish this [_1]' => '[_1]の公開',
	'Published Time' => '公開時刻',
	'Revision: <strong>[_1]</strong>' => '更新履歴: <strong>[_1]</strong>',
	'Save this [_1]' => 'この[_1]を保存する',
	'Schedule' => '保存',
	'This [_1] has been saved.' => '[_1]を保存しました。',
	'Unpublish this [_1]' => '[_1]の公開取り消し',
	'Unpublished (Draft)' => '未公開(原稿)',
	'Unpublished (Review)' => '未公開(承認待ち)',
	'Unpublished (Spam)' => '未公開(スパム)',
	'Unpublished Date' => '公開取り消し日',
	'Unpublished Time' => '公開取り消し時刻',
	'Update this [_1]' => '[_1]の更新',
	'Update' => '更新',
	'View revisions of this [_1]' => '[_1]の更新履歴を表示',
	'View revisions' => '更新履歴を表示',
	'Warning: If you set the basename manually, it may conflict with another content data.' => '警告: 出力ファイル名を手動で設定すると、他のコンテンツデータと衝突を起こす可能性があります。',
	'You have successfully recovered your saved content data.' => 'コンテンツデータを元に戻しました。',
	'You must configure this site before you can publish this content data.' => 'コンテンツデータを公開する前にサイトの設定を行ってください。',
	'[_1] is also editing the same data (last updated at [_2]).' => '同じコンテンツデータを編集中のユーザーがいます: [_1] (最終更新日時: [_2])',
	q{Warning: Changing this content data's basename may break inbound links.} => q{警告: このコンテンツデータの出力ファイル名の変更は、内部のリンク切れの原因となります。},

## tmpl/cms/edit_content_type.tmpl
	'1 or more label-value pairs are required' => '1つ以上の値とラベルの組み合わせが必要です。',
	'Available Content Fields' => '利用可能なフィールド',
	'Contents type settings has been saved.' => 'コンテンツタイプの設定を保存しました',
	'Edit Content Type' => 'コンテンツタイプの編集',
	'Reason' => '理由',
	'Some content fields were not deleted. You need to delete archive mapping for the content field first.' => 'いくつかのコンテンツフィールドが削除できませんでした。先にアーカイブマッピングを削除する必要があります。',
	'This field must be unique in this content type' => 'フィールド名はコンテンツタイプ内でユニークである必要があります。',
	'Unavailable Content Fields' => '利用できないフィールド',

## tmpl/cms/edit_entry.tmpl
	'(comma-delimited list)' => '(カンマ区切りリスト)',
	'(space-delimited list)' => '(スペース区切りリスト)',
	'<a href="[_2]">[_1]</a>' => '<a href="[_2]">[_1]</a>',
	'A saved version of this entry was auto-saved [_2] but it is outdated.<br><a href="[_1]" class="alert-link">Recover auto-saved content</a> / <a href="[_3]" class="alert-link">Discard auto-saved content</a>' => 'この記事には[_2]に自動保存された修正版がありますが、現在の内容は自動保存よりも後に保存されたものです。<br><a href="[_1]" class="alert-link">自動保存された内容に戻す</a> / <a href="[_3]" class="alert-link">自動保存された内容を破棄する</a>',
	'A saved version of this entry was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'この記事には[_2]に自動保存された修正版があります。<a href="[_1]" class="alert-link">自動保存された内容に戻す</a>',
	'A saved version of this page was auto-saved [_2] but it is outdated.<br><a href="[_1]" class="alert-link">Recover auto-saved content</a> / <a href="[_3]" class="alert-link">Discard auto-saved content</a>' => 'このウェブページには[_2]に自動保存された修正版がありますが、現在の内容は自動保存よりも後に保存されたものです。<br><a href="[_1]" class="alert-link">自動保存された内容に戻す</a> / <a href="[_3]" class="alert-link">自動保存された内容を破棄する</a>',
	'A saved version of this page was auto-saved [_2]. <a href="[_1]" class="alert-link">Recover auto-saved content</a>' => 'このウェブページには[_2]に自動保存された修正版があります。<a href="[_1]" class="alert-link">自動保存された内容に戻す</a>',
	'Accept' => '受信設定',
	'Add Entry Asset' => 'アセットの追加',
	'Add category' => 'カテゴリを追加',
	'Add new category parent' => '親カテゴリを追加',
	'Add new folder parent' => '親フォルダを追加',
	'An error occurred while trying to recover your saved entry.' => '記事を元に戻す際にエラーが発生しました。',
	'An error occurred while trying to recover your saved page.' => 'ウェブページを元に戻す際にエラーが発生しました。',
	'Category Name' => 'カテゴリ名',
	'Change Folder' => 'フォルダの変更',
	'Converting to rich text may result in changes to your current document.' => 'リッチテキストに変換すると、現在のHTML構造に変更が生じる可能性があります。',
	'Create Entry' => '記事の作成',
	'Create Page' => 'ウェブページの作成',
	'Delete this entry (x)' => '記事を削除 (x)',
	'Delete this page (x)' => 'ウェブページを削除 (x)',
	'Draggable' => 'ドラッグ可能',
	'Edit Entry' => '記事の編集',
	'Edit Page' => 'ウェブページの編集',
	'Enter the link address:' => 'リンクするURLを入力:',
	'Enter the text to link to:' => 'リンクのテキストを入力:',
	'Format:' => 'フォーマット:',
	'Make primary' => 'メインカテゴリにする',
	'Manage Entries' => '記事の管理',
	'No assets' => 'アセットはありません',
	'None selected' => '選択されていません',
	'One or more errors occurred when sending update pings or TrackBacks.' => '更新通知かトラックバック送信でひとつ以上のエラーが発生しました。',
	'Outbound TrackBack URLs' => 'トラックバック送信先URL',
	'Preview this entry (v)' => '記事をプレビュー (v)',
	'Preview this page (v)' => 'ウェブページをプレビュー (v)',
	'Reset display options to blog defaults' => '表示オプションをブログの既定値にリセット',
	'Restored revision (Date:[_1]).  The current status is: [_2]' => '更新履歴(日付: [_1])に戻しました。ステータス: [_2]',
	'Selected Categories' => '選択されたカテゴリ',
	'Share' => '共有',
	'Some [_1] in the revision could not be loaded because they have been removed.' => '履歴データ内に、削除されたために読み込めなかった[_1]があります。',
	'Some of tags in the revision could not be loaded because they have been removed.' => '履歴データ内に、削除されたために読み込めなかったタグがあります。',
	'This entry has been saved.' => '記事を保存しました。',
	'This page has been saved.' => 'ウェブページを保存しました。',
	'This post was classified as spam.' => 'この投稿はスパムと判定されました。',
	'This post was held for review, due to spam filtering.' => 'この投稿はスパムフィルタリングにより承認待ちになっています。',
	'View Entry' => '記事を見る',
	'View Page' => 'ウェブページを表示',
	'View Previously Sent TrackBacks' => '送信済みのトラックバックを見る',
	'Warning: If you set the basename manually, it may conflict with another entry.' => '警告: 出力ファイル名を手動で設定すると、他の記事と衝突を起こす可能性があります。',
	'You have successfully deleted the checked TrackBack(s).' => '選択したトラックバックを削除しました。',
	'You have successfully deleted the checked comment(s).' => '選択したコメントを削除しました。',
	'You have successfully recovered your saved entry.' => '記事を元に戻しました。',
	'You have successfully recovered your saved page.' => 'ウェブページを元に戻しました。',
	'You have unsaved changes to this entry that will be lost.' => '保存されていない記事への変更は失われます。',
	'You must configure this site before you can publish this entry.' => '記事を公開する前にサイトの設定を行ってください。',
	'You must configure this site before you can publish this page.' => 'ページを公開する前にサイトの設定を行ってください。',
	'Your changes to the comment have been saved.' => 'コメントの変更を保存しました。',
	'Your customization preferences have been saved, and are visible in the form below.' => 'カスタマイズ設定を保存しました。下のフォームで確認できます。',
	'Your notification has been sent.' => '通知を送信しました。',
	'[_1] Assets' => '[_1]アセット',
	'[_1] is also editing the same entry (last updated at [_2]).' => '同じ記事を編集中のユーザーがいます: [_1] (最終更新日時: [_2])',
	'[_1] is also editing the same page (last updated at [_2]).' => '同じウェブページを編集中のユーザーがいます: [_1] (最終更新日時: [_2])',
	'_USAGE_VIEW_LOG' => 'エラーの場合は、<a href="[_1]">ログ</a>をチェックしてください。',
	'edit' => '編集',
	q{(delimited by '[_1]')} => q{([_1]で区切る)},
	q{Warning: Changing this entry's basename may break inbound links.} => q{警告: この記事の出力ファイル名の変更は、内部のリンク切れの原因となります。},

## tmpl/cms/edit_entry_batch.tmpl
	'Save these [_1] (s)' => '[_1]の保存',

## tmpl/cms/edit_folder.tmpl
	'Edit Folder' => 'フォルダの編集',
	'Manage Folders' => 'フォルダの管理',
	'Manage pages in this folder' => 'このフォルダに属するウェブページ一覧',
	'Path' => 'パス',
	'Save changes to this folder (s)' => 'フォルダへの変更を保存 (s)',
	'You must specify a label for the folder.' => 'このフォルダの名前を設定してください。',

## tmpl/cms/edit_group.tmpl
	'Created By' => '作成者',
	'Created On' => '作成日',
	'Edit Group' => 'グループの編集',
	'LDAP Group ID' => 'LDAPグループID',
	'Member ([_1])' => 'メンバー([_1])',
	'Members ([_1])' => 'メンバー([_1])',
	'Permission ([_1])' => '権限([_1])',
	'Permissions ([_1])' => '権限([_1])',
	'Save changes to this field (s)' => 'フィールドへの変更を保存 (s)',
	'Status of this group in the system. Disabling a group prohibits its members&rsquo; from accessing the system but preserves their content and history.' => 'グループの状態。グループを無効にするとメンバーのシステムへのアクセスに影響があります。メンバーのコンテンツや履歴は削除されません。',
	'The LDAP directory ID for this group.' => 'LDAPディレクトリでこのグループに適用されている識別子',
	'The description for this group.' => 'グループの説明',
	'The display name for this group.' => 'グループの表示名',
	'The name used for identifying this group.' => 'グループを識別する名前',
	'This group profile has been updated.' => 'グループのプロフィールを更新しました。',
	'This group was classified as disabled.' => 'このグループは無効になっています。',
	'This group was classified as pending.' => 'このグループは保留中になっています。',

## tmpl/cms/edit_ping.tmpl
	'Category no longer exists' => 'このカテゴリは存在しません。',
	'Delete this TrackBack (x)' => 'トラックバックを削除 (x)',
	'Edit Trackback' => 'トラックバックの編集',
	'Entry no longer exists' => '記事が存在しません',
	'Manage TrackBacks' => 'トラックバックの管理',
	'No title' => 'タイトルなし',
	'Save changes to this TrackBack (s)' => 'トラックバックへの変更を保存 (s)',
	'Search for other TrackBacks from this site' => 'このサイトのその他のトラックバックを検索する',
	'Search for other TrackBacks with this status' => 'このステータスのその他のトラックバックを検索する',
	'Search for other TrackBacks with this title' => 'このタイトルのその他のトラックバックを検索する',
	'Source Site' => '送信元のサイト',
	'Source Title' => '送信元記事のタイトル',
	'Target Category' => 'トラックバック送信するカテゴリ',
	'Target [_1]' => '宛先[_1]',
	'The TrackBack has been approved.' => 'トラックバックを公開しました。',
	'This trackback was classified as spam.' => 'このトラックバックはスパムと判定されました。',
	'TrackBack Text' => 'トラックバックの本文',
	'View all TrackBacks created on this day' => 'この日のトラックバックをすべて見る',
	'View all TrackBacks from this IP address' => 'このIPアドレスからのトラックバックをすべて見る',
	'View all TrackBacks on this category' => 'このカテゴリのすべてのトラックバックを見る',
	'View all TrackBacks on this entry' => 'この記事で受信したすべてのトラックバックを見る',
	'View all TrackBacks with this status' => 'このステータスのトラックバックをすべて表示',

## tmpl/cms/edit_role.tmpl
	'Administration' => '管理',
	'Association (1)' => '関連付け (1)',
	'Associations ([_1])' => '関連付け ([_1])',
	'Authoring and Publishing' => '作成と公開',
	'Check All' => 'すべてチェック',
	'Commenting' => 'コメント投稿',
	'Content Field Privileges' => 'フィールドごとの編集権限',
	'Content Type Privileges' => 'コンテンツタイプごとの権限',
	'Designing' => 'デザインする',
	'Duplicate Roles' => '同じ権限のロール',
	'Edit Role' => 'ロールの編集',
	'Privileges' => '権限',
	'Role Details' => 'ロールの詳細',
	'Save changes to this role (s)' => 'ロールへの変更を保存 (s)',
	'Uncheck All' => 'チェックを外す',
	'You have changed the privileges for this role. This will alter what it is that the users associated with this role will be able to do. If you prefer, you can save this role with a different name.  Otherwise, be aware of any changes to users with this role.' => 'このロールの権限を変更しました。これによって、このロールに関連付けられているユーザーの権限も変化します。このロールに異なる名前を付けて保存したほうがいいかもしれません。このロールに関連付けられているユーザーの権限が変更されていることに注意してください。',

## tmpl/cms/edit_template.tmpl
	': every ' => '毎',
	'<a href="[_1]" class="rebuild-link">Publish</a> this template.' => 'このテンプレートを<a href="[_1]" class="rebuild-link">再構築する</a>',
	'A saved version of this [_1] was auto-saved [_3] but it is outdated.<br><a href="[_2]" class="alert-link">Recover auto-saved content</a> / <a href="[_4]" class="alert-link">Discard auto-saved content</a>' => 'この[_1]には[_3]に自動保存された修正版がありますが、現在の内容は自動保存よりも後に保存されたものです。<br><a href="[_2]" class="alert-link">自動保存された内容に戻す</a> / <a href="[_4]" class="alert-link">自動保存された内容を破棄する</a>',
	'A saved version of this [_1] was auto-saved [_3]. <a href="[_2]" class="alert-link">Recover auto-saved content</a>' => '[_1]には[_3]に自動保存された修正版があります。<a href="[_2]" class="alert-link">自動保存された内容に戻す</a>',
	'An error occurred while trying to recover your saved [_1].' => '[_1]を元に戻す際にエラーが発生しました。',
	'Archive map has been successfully updated.' => 'アーカイブマッピングの更新を完了しました。',
	'Are you sure you want to remove this template map?' => 'テンプレートマップを削除してよろしいですか?',
	'Category Field' => 'カテゴリフィールド',
	'Code Highlight' => 'コードハイライト',
	'Create Archive Mapping' => '新しいアーカイブマッピングを作成',
	'Create Content Type Archive Template' => 'コンテンツタイプアーカイブテンプレートの作成',
	'Create Content Type Listing Archive Template' => 'コンテンツタイプリストアーカイブテンプレートの作成',
	'Create Entry Archive Template' => '記事アーカイブテンプレートの作成',
	'Create Entry Listing Archive Template' => '記事リストアーカイブテンプレートの作成',
	'Create Index Template' => 'インデックステンプレートの作成',
	'Create Page Archive Template' => 'ウェブページアーカイブテンプレートの作成',
	'Create Template Module' => 'テンプレートモジュールの作成',
	'Custom Index Template' => 'カスタムインデックステンプレート',
	'Date & Time Field' => '日付と時刻フィールド',
	'Disabled (<a href="[_1]">change publishing settings</a>)' => '無効(<a href="[_1]">変更する</a>)',
	'Do Not Publish' => '公開しない',
	'Dynamically' => 'ダイナミック',
	'Edit Widget' => 'ウィジェットの編集',
	'Error occurred while updating archive maps.' => 'アーカイブマッピングの更新中にエラーが発生しました。',
	'Expire after' => 'キャッシュの有効期限: ',
	'Expire upon creation or modification of:' => '作成または更新後に無効にする:',
	'Include cache path' => 'キャッシュのパス',
	'Included Templates' => 'インクルードテンプレート',
	'Learn more about <a href="https://www.movabletype.org/documentation/administrator/publishing/settings.html" target="_blank">publishing settings</a>' => '<a href="http://www.movabletype.jp/documentation/administrator/publishing/settings.html" target="_blank">公開プロファイルについて</a>',
	'Learn more about <a href="https://www.movabletype.org/documentation/appendices/archive-file-path-specifiers.html" target="_blank">Archive File Path Specifiers</a>' => '<a href="https://www.movabletype.jp/documentation/appendices/archive-file-path-specifiers.html" target="_blank">カスタムマッピング変数</a>',
	'Link to File' => 'ファイルへのリンク',
	'List [_1] templates' => '[_1]テンプレート一覧',
	'List all templates' => 'すべてのテンプレートを表示',
	'Manually' => '手動',
	'Module Body' => 'モジュール本体',
	'Module Option Settings' => 'モジュールオプション設定',
	'New Template' => '新しいテンプレート',
	'No caching' => 'キャッシュしない',
	'No revision(s) associated with this template' => 'テンプレートの更新履歴が見つかりません',
	'On a schedule' => 'スケジュール',
	'Process as <strong>[_1]</strong> include' => '<strong>[_1]</strong>のインクルードとして処理する',
	'Processing request...' => '処理中...',
	'Restored revision (Date:[_1]).' => '更新履歴(日付: [_1])に戻しました。',
	'Save &amp; Publish' => '保存と再構築',
	'Save Changes (s)' => '変更を保存 (s)',
	'Save and Publish this template (r)' => 'このテンプレートを保存して再構築 (r)',
	'Server Side Include' => 'サーバーサイドインクルード',
	'Statically (default)' => 'スタティック(既定)',
	'Template Body' => 'テンプレートの内容',
	'Template Type' => 'テンプレートの種類',
	'Useful Links' => 'ショートカット',
	'Via Publish Queue' => '公開キュー経由',
	'View Published Template' => '公開されたテンプレートを確認',
	'View revisions of this template' => 'テンプレートの更新履歴を表示',
	'You have successfully recovered your saved [_1].' => '[_1]を元に戻しました。',
	'You have unsaved changes to this template that will be lost.' => '保存されていないテンプレートへの変更は失われます。',
	'You must select the Content Type.' => 'コンテンツタイプを選択してください。',
	'You must set the Template Name.' => 'テンプレート名を設定してください。',
	'You must set the template Output File.' => 'テンプレートの出力ファイル名を設定してください。',
	'Your [_1] has been published.' => '[_1]を再構築しました。',
	'[_1] is also editing the same template (last updated at [_2]).' => '同じテンプレートを編集中のユーザーがいます: [_1] (最終更新日時: [_2])',
	'create' => '新規作成',
	'hours' => '時間',
	'minutes' => '分',

## tmpl/cms/edit_website.tmpl
	'Create Site (s)' => 'サイトを作成 (s)',
	'Name your site. The site name can be changed at any time.' => 'サイト名を付けてください。この名前はいつでも変更できます。',
	'Please enter a valid URL.' => '正しいURLを入力してください。',
	'Please enter a valid site path.' => '正しいウェブサイトパスを入力してください。',
	'Select the theme you wish to use for this site.' => 'このサイトで利用するテーマを選択してください。',
	'This field is required.' => 'このフィールドは必須です。',
	'You did not select a timezone.' => 'タイムゾーンが選択されていません。',
	'Your site configuration has been saved.' => 'サイトの設定を保存しました。',
	q{Enter the URL of your site. Exclude the filename (i.e. index.html). Example: http://www.example.com/} => q{サイトを公開するURLを入力してください。ファイル名(index.htmlなど)は含めず、末尾は'/'で終わります。例: http://www.example.com/blog/},
	q{Enter the path where your main index file will be located. An absolute path (starting with '/' for Linux or 'C:\' for Windows) is preferred, but you can also use a path relative to the Movable Type directory. Example: /home/melody/public_html/ or C:\www\public_html} => q{インデックスファイルが公開されるパスを入力してください。絶対パス(Linuxの時は'/'、Windowsの時は'C:\'などで始まる)を推奨しますが、Movable Typeディレクトリからの相対パスも指定できます。末尾には'/'や'\'を含めません。例: /home/melody/public_html/blogやC:\www\public_html\blog},

## tmpl/cms/edit_widget.tmpl
	'Available Widgets' => '利用可能',
	'Edit Widget Set' => 'ウィジェットセットの編集',
	'Installed Widgets' => 'インストール済み',
	'Save changes to this widget set (s)' => 'ウィジェットセットへの変更を保存 (s)',
	'Widget Set Name' => 'ウィジェットセット名',
	'You must set Widget Set Name.' => 'ウィジェットセット名を設定してください。',
	q{Drag and drop the widgets that belong in this Widget Set into the 'Installed Widgets' column.} => q{ウィジェットを「利用可能」から「インストール済み」ボックスにドラッグアンドドロップします。},

## tmpl/cms/error.tmpl
	'An error occurred' => 'エラーが発生しました。',

## tmpl/cms/export.tmpl
	'Export [_1] Entries' => '[_1]の記事をエクスポート',
	'[_1] to Export' => 'エクスポートする[_1]',
	'_USAGE_EXPORT_1' => 'Movable Typeから記事をエクスポートして、基本的なデータ(記事、コメント、トラックバック)を保存できます。',

## tmpl/cms/export_theme.tmpl
	'Author link' => '作者のページ',
	'Basename may only contain letters, numbers, and the dash or underscore character. The basename must begin with a letter.' => 'アルファベット、数字、ダッシュ(-)、アンダースコア(_)を利用。かならずアルファベットで始めてください。',
	'Destination' => '出力形式',
	'Setting for [_1]' => '[_1]の設定',
	'Theme package have been saved.' => 'テーマパッケージが保存されました。',
	'Theme version may only contain letters, numbers, and the dash or underscore character.' => 'バージョンにはアルファベット、数字、ダッシュ(-)、アンダースコア(_)が利用できます。',
	'Version' => 'バージョン',
	'You must set Theme Name.' => 'テーマ名を設定してください。',
	'_THEME_AUTHOR' => '作者名',
	q{Cannot install new theme with existing (and protected) theme's basename.} => q{新しいテーマは既存、または保護されたテーマベース名ではインストールできません。},
	q{Use letters, numbers, dash or underscore only (a-z, A-Z, 0-9, '-' or '_').} => q{次の文字と数字のみ利用できます: アルファベット、数字、ダッシュ(-)、アンダースコア(_)},

## tmpl/cms/field_html/field_html_asset.tmpl
	'Assets greater than or equal to [_1] must be selected' => '[_1]以上のアセットを選択してください',
	'Assets less than or equal to [_1] must be selected' => '選択できるアセットは[_1]以下です',
	'No Asset' => 'アセットはありません',
	'No Assets' => 'アセットはありません',
	'Only 1 asset can be selected' => 'ひとつのアセットのみ選択可能です',

## tmpl/cms/field_html/field_html_categories.tmpl
	'Add sub category' => 'サブカテゴリを追加',
	'This field is disabled because valid Category Set is not selected in this field.' => '有効なカテゴリセットが設定されていないため、このフィールドは利用できません。',

## tmpl/cms/field_html/field_html_content_type.tmpl
	'No [_1]' => '[_1]がみつかりません',
	'No field data.' => 'フィールドデータが見つかりません。',
	'Only 1 [_1] can be selected' => 'ひとつの[_1]のみ選択可能です',
	'This field is disabled because valid Content Type is not selected in this field.' => '適切なコンテンツタイプが設定されていないためこのフィールドは利用できません。',
	'[_1] greater than or equal to [_2] must be selected' => '[_2]以上の[_1]を選択してください',
	'[_1] less than or equal to [_2] must be selected' => '選択できる[_1]は[_2]以下です',

## tmpl/cms/field_html/field_html_select_box.tmpl
	'Not Selected' => '未選択',

## tmpl/cms/field_html/field_html_table.tmpl
	'All possible cells should be selected so to merge cells into one' => '結合できるセルはすべて選択してください',
	'Cell is not selected' => 'セルが選択されていません',
	'Only one cell should be selected' => '1つのセルのみ選択してください',
	'Source' => 'ソース表示',
	'align center' => '中央揃え',
	'align left' => '左揃え',
	'align right' => '右揃え',
	'change to td' => 'tdに変更',
	'change to th' => 'thに変更',
	'insert column on the left' => '左に列を挿入',
	'insert column on the right' => '右に列を挿入',
	'insert row above' => '上に行を挿入',
	'insert row below' => '下に行を挿入',
	'merge cell' => 'セルを結合する',
	'remove column' => '列を削除する',
	'remove row' => '行を削除する',
	'split cell' => 'セルを分割する',
	q{The top left cell's value of the selected range will only be saved. Are you sure you want to continue?} => q{左上のセルの値のみが保存されます。続行しますか?},
	q{You can't paste here} => q{ここに貼り付けることはできません},
	q{You can't split the cell anymore} => q{このセルはこれ以上分割できません},

## tmpl/cms/import.tmpl
	'<mt:var name="display_name" escape="html">' => '<mt:var name="display_name" escape="html">',
	'Apply this formatting if text format is not set on each entry.' => '記事に、テキストフォーマットが指定されていない場合に、適用されます。',
	'Default category for entries (optional)' => '記事の既定カテゴリ(オプション)',
	'Default password for new users:' => '新しいユーザーの初期パスワード',
	'Enter a default password for new users.' => '新しいユーザーの初期パスワード入力してください。',
	'If you choose to preserve the ownership of the imported entries and any of those users must be created in this installation, you must define a default password for those new accounts.' => '所有者を変更しない場合には、存在しないユーザーをシステムが自動で作成します。新しいユーザーの初期パスワードを設定してください。',
	'Import Entries (s)' => '記事をインポート (s)',
	'Import Entries' => '記事のインポート',
	'Import File Encoding' => 'インポートするファイルの文字コード',
	'Import [_1] Entries' => '[_1]に記事をインポート',
	'Import as me' => '自分の記事としてインポートする',
	'Importing from' => 'インポート元',
	'Ownership of imported entries' => 'インポートした記事の所有者',
	'Preserve original user' => '記事の著者を変更しない',
	'Select a category' => 'カテゴリを選択',
	'Transfer site entries into Movable Type from other Movable Type installations or even other blogging tools or export your entries to create a backup or copy.' => '他のMovable Typeやブログツールから記事を移行したり、記事のコピーを作成します。',
	'Upload import file (optional)' => 'インポートファイルをアップロード(オプション)',
	'You must select a site to import.' => 'インポート先のサイトを選択してください。',
	'You will be assigned the user of all imported entries.  If you wish the original user to keep ownership, you must contact your MT system administrator to perform the import so that new users can be created if necessary.' => 'あなたがインポートした記事を作成したことになります。元の著者を変更せずにインポートしたい場合には、システム管理者がインポート作業を行ってください。その場合には必要に応じて新しいユーザーを作成できます。',

## tmpl/cms/import_others.tmpl
	'Default entry status (optional)' => '既定の公開状態(任意)',
	'End title HTML (optional)' => 'タイトルとなるHTMLの終了地点(任意)',
	'Select an entry status' => '公開状態',
	'Start title HTML (optional)' => 'タイトルとなるHTMLの開始地点(任意)',

## tmpl/cms/include/anonymous_comment.tmpl
	'Allow comments from anonymous or unauthenticated users.' => '認証なしユーザーまたは匿名ユーザーからコメントを受け付ける',
	'If enabled, visitors must provide a valid e-mail address when commenting.' => 'コメント投稿に対して名前とメールアドレスを必須項目にします。',
	'Require name and E-mail Address for Anonymous Comments' => '名前とメールアドレスを要求する',

## tmpl/cms/include/archetype_editor.tmpl
	'Begin Blockquote' => '引用開始',
	'Bold' => '太字',
	'Bulleted List' => '箇条書きリスト',
	'Center Item' => 'アセット中央揃え',
	'Center Text' => 'テキスト中央揃え',
	'Check Spelling' => 'スペルチェック',
	'Decrease Text Size' => 'テキストサイズを小さくする',
	'Email Link' => 'メールアドレスリンク',
	'End Blockquote' => '引用終了',
	'HTML Mode' => 'HTMLモード',
	'Increase Text Size' => 'テキストサイズを大きくする',
	'Insert File' => 'ファイルの挿入',
	'Insert Image' => '画像の挿入',
	'Italic' => '斜体',
	'Left Align Item' => 'アセット左揃え',
	'Left Align Text' => 'テキスト左揃え',
	'Numbered List' => '番号付きリスト',
	'Right Align Item' => 'アセット右揃え',
	'Right Align Text' => 'テキスト右揃え',
	'Text Color' => 'フォントカラー',
	'Underline' => '下線',
	'WYSIWYG Mode' => 'WYSIWYGモード',

## tmpl/cms/include/archive_maps.tmpl
	'Collapse' => '開く',
	'Preferred' => '優先',

## tmpl/cms/include/asset_replace.tmpl
	'No' => 'いいえ',
	'Yes (s)' => 'はい (s)',
	'Yes' => 'はい',
	q{A file named '[_1]' already exists. Do you want to overwrite this file?} => q{同名のアセット'[_1]'がすでに存在します。上書きしますか?},

## tmpl/cms/include/asset_table.tmpl
	'Asset Missing' => 'アセットなし',
	'Delete selected assets (x)' => '選択したアセットを削除',
	'No thumbnail image' => 'サムネイル画像がありません。',
	'Size' => 'サイズ',

## tmpl/cms/include/asset_upload.tmpl
	'Choose Folder' => 'フォルダの選択',
	'Select File to Upload' => 'アップロードするファイルを選択',
	'Upload (s)' => 'アップロード (s)',
	'Your system or [_1] administrator needs to publish the [_1] before you can upload files. Please contact your system or [_1] administrator.' => 'ファイルアップロードができるように、システム、または[_1]管理者が[_1]を再構築する必要があります。システム、または[_1]管理者に連絡してください。',
	'[_1] contains a character that is invalid when used in a directory name: [_2]' => '[_1]のディレクトリ名として正しくない文字が含まれています: [_2]',
	'_USAGE_UPLOAD' => 'アップロード先には、サブディレクトリを指定することが出来ます。指定されたディレクトリが存在しない場合は、作成されます。',
	q{Asset file('[_1]') has been uploaded.} => q{アセット('[_1]')がアップロードされました。},
	q{Before you can upload a file, you need to publish your [_1]. [_2]Configure your [_1]'s publishing paths[_3] and republish your [_1].} => q{ファイルのアップロードができるように、[_1]を再構築する必要があります。[_2]公開パスの設定[_3]をして、[_1]を再構築してください。},
	q{Cannot write to '[_1]'. Image upload is possible, but thumbnail is not created.} => q{ファイルのアップロードは可能ですが、'[_1]'への書き込みが行えないため、画像ファイルのサムネイルを作成する事ができません。},

## tmpl/cms/include/async_asset_list.tmpl
	'All Types' => 'すべてのアセット',
	'Asset Type: ' => 'アセット種類',
	'label' => '名前',

## tmpl/cms/include/async_asset_upload.tmpl
	'Choose file to upload or drag file.' => 'アップロードするファイルを選択または画面にドラッグ＆ドロップしてください。',
	'Choose file to upload.' => 'アップロードするファイルを選択してください。',
	'Choose files to upload or drag files.' => 'アップロードするファイルを選択または画面にドラッグ＆ドロップしてください。（複数可）',
	'Choose files to upload.' => 'アップロードするファイルを選択してください。',
	'Drag and drop here' => 'ファイルをドロップしてください',
	'Operation for a file exists' => '既存ファイルの処理',
	'Upload Options' => 'アップロードオプション',
	'Upload Settings' => 'アップロードの設定',

## tmpl/cms/include/author_table.tmpl
	'Disable selected users (d)' => '選択したユーザーを無効化 (d)',
	'Enable selected users (e)' => '選択したユーザーを有効化 (e)',
	'_NO_SUPERUSER_DISABLE' => 'Movable Typeのシステム管理者は自分自身を無効にはできません。',
	'_USER_DISABLE' => '無効',
	'_USER_ENABLE' => '有効',
	'user' => 'ユーザー',
	'users' => 'ユーザー',

## tmpl/cms/include/backup_end.tmpl
	'All of the data has been exported successfully!' => 'すべてのデータは正常にエクスポートされました。',
	'An error occurred during the export process: [_1]' => 'エクスポート中にエラーが発生しました: [_1]',
	'Download This File' => 'このファイルをダウンロード',
	'Download: [_1]' => 'ダウンロード: [_1]',
	'Export Files' => 'エクスポートファイル',
	'_BACKUP_TEMPDIR_WARNING' => 'バックアップはディレクトリ[_1]に正常に保存されました。一覧に表示されたリンクをクリックしてファイルごとにダウンロードするか、FTP などでサーバーに直接接続し、[_1] にあるファイルをすべてダウンロード後、該当ディレクトリ内のファイルを削除してください。',
	q{_BACKUP_DOWNLOAD_MESSAGE} => q{数秒後にバックアップファイルのダウンロードが開始します。ダウンロードが始まらない場合は<a href='#' onclick='submit_form()'>ここ</a>をクリックしてください。},

## tmpl/cms/include/backup_start.tmpl
	'Exporting Movable Type' => 'エクスポートを開始',

## tmpl/cms/include/basic_filter_forms.tmpl
	'[_1] [_2] [_3]' => '[_1] が [_3] [_2]',
	'[_1] and [_2]' => 'が[_1] から [_2]',
	'[_1] hours' => 'が[_1]',
	'_FILTER_DATE_DAYS' => 'が[_1]',
	'__FILTER_DATE_ORIGIN' => 'が[_1]',
	'__STRING_FILTER_EQUAL' => 'である',
	'__TIME_FILTER_HOURS' => '時間以内',
	'contains' => 'を含む',
	'does not contain' => 'を含まない',
	'ends with' => 'で終わる',
	'is after now' => 'が今日より後',
	'is after' => 'より後',
	'is before now' => 'が今日より前',
	'is before' => 'より前',
	'is between' => 'の期間内',
	'is blank' => 'が空である',
	'is greater than or equal to' => '以上',
	'is greater than' => 'より大きい',
	'is less than or equal to' => '以下',
	'is less than' => 'より小さい',
	'is not blank' => 'が空ではない',
	'is within the last' => '日以内',
	'starts with' => 'で始まる',

## tmpl/cms/include/blog_table.tmpl
	'Delete selected [_1] (x)' => '選択された[_1]を削除 (x)',
	'Some sites were not deleted. You need to delete child sites under the site first.' => '削除できないサイトがありました。サイト内の子サイトを先に削除する必要があります。',
	'Some templates were not refreshed.' => '初期化できないテンプレートがありました。',
	'[_1] Name' => '[_1]名',

## tmpl/cms/include/category_selector.tmpl
	'Add sub folder' => 'サブフォルダを追加',

## tmpl/cms/include/comment_table.tmpl
	'([quant,_1,reply,replies])' => '(返信数 [_1])',
	'Blocked' => '禁止中',
	'Delete selected comments (x)' => '選択されたコメントを削除 (x)',
	'Edit this [_1] commenter' => 'このコメント投稿者([_1])を編集',
	'Edit this comment' => 'このコメントを編集',
	'Publish selected comments (a)' => '選択されたコメントを再構築 (a)',
	'Search for all comments from this IP address' => 'このIPアドレスからのすべてのコメントを検索',
	'Search for comments by this commenter' => 'このコメント投稿者のコメントを検索',
	'View this entry' => '記事を表示',
	'View this page' => 'ウェブページを表示',
	'to republish' => '再構築',

## tmpl/cms/include/commenter_table.tmpl
	'Edit this commenter' => 'このコメント投稿者を編集',
	'Last Commented' => '最近のコメント',
	'View this commenter&rsquo;s profile' => 'このコメント投稿者のユーザー情報を見る',

## tmpl/cms/include/content_data_table.tmpl
	'Created' => '作成',
	'Republish selected [_1] (r)' => '選択した[_1]の再構築',
	'Unpublish' => '公開取り消し',

## tmpl/cms/include/copyright.tmpl
	'Copyright &copy; 2001 Six Apart. All Rights Reserved.' => 'Copyright &copy; 2001 Six Apart. All Rights Reserved.',

## tmpl/cms/include/entry_table.tmpl
	'<a href="[_1]" class="alert-link">Create an entry</a> now.' => '<a href="[_1]" class="alert-link">記事を作成</a>する。',
	'Last Modified' => '最終更新',
	'No entries could be found.' => '記事がありません。',
	'No pages could be found. <a href="[_1]" class="alert-link">Create a page</a> now.' => 'ウェブページが見つかりませんでした。<a href="[_1]" class="alert-link">ウェブページの作成</a>',
	'View entry' => '記事を見る',
	'View page' => 'ウェブページを表示',

## tmpl/cms/include/feed_link.tmpl
	'Set Web Services Password' => 'Webサービスのパスワードを設定',

## tmpl/cms/include/footer.tmpl
	'<a href="[_1]"><mt:var name="mt_product_name"></a> [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> [_2]',
	'BETA' => 'BETA',
	'DEVELOPER PREVIEW' => 'DEVELOPER PREVIEW',
	'Forums' => 'ユーザーコミュニティ',
	'MovableType.org' => 'MovableType.jp',
	'Send Us Feedback' => 'フィードバックはこちらへ',
	'Support' => 'サポート',
	'This is a alpha version of Movable Type and is not recommended for production use.' => 'このMovable Typeはアルファ版です。',
	'This is a beta version of Movable Type and is not recommended for production use.' => 'このMovable Typeはベータ版です。',
	'https://forums.movabletype.org/' => 'https://communities.movabletype.jp/',
	'https://plugins.movabletype.org/' => 'https://plugins.movabletype.jp/',
	'https://www.movabletype.org' => 'https://www.movabletype.jp',
	'with' => 'with',

## tmpl/cms/include/group_table.tmpl
	'Disable selected group (d)' => '選択されたグループを無効にする (d)',
	'Enable selected group (e)' => '選択されたグループを有効にする (e)',
	'Remove selected group (d)' => '選択されたグループを削除する (d)',
	'group' => 'グループ',
	'groups' => 'グループ',

## tmpl/cms/include/header.tmpl
	'Help' => 'ヘルプ',
	'Search (q)' => '検索 (q)',
	'Search [_1]' => '[_1]の検索',
	'Select an action' => 'アクションを選択',
	'from Revision History' => '履歴データ',
	q{This website was created during the upgrade from a previous version of Movable Type. 'Site Root' and 'Site URL' are left blank to retain 'Publishing Paths' compatibility for blogs that were created in a previous version. You can post and publish on existing blogs, but you cannot publish this website itself because of the blank 'Site Root' and 'Site URL'.} => q{このウェブサイトは、以前のバージョンのMovable Typeからのバージョンアップ時に作成されました。バージョンアップ前に作成されたブログの公開設定の互換性を保持するために、ウェブサイトのサイト URLとサイトパスは空白になっています。そのため、既存のブログに投稿、公開はできますが、ウェブサイト自体にコンテンツを投稿することはできません。},

## tmpl/cms/include/import_end.tmpl
	'<a href="#" onclick="[_1]" class="mt-build">Publish your site</a> to see these changes take effect.' => '変更を有効にするには<a href="#" onclick="[_1]" class="mt-build">再構築</a> してください。',

## tmpl/cms/include/import_start.tmpl
	'Creating new users for each user found in the [_1]' => '[_1]のユーザーを新規ユーザーとして作成',
	'Importing entries into [_1]' => '記事を[_1]にインポートしています',
	q{Importing entries as user '[_1]'} => q{ユーザー[_1]として記事をインポートしています},

## tmpl/cms/include/itemset_action_widget.tmpl
	'Go' => 'Go',

## tmpl/cms/include/listing_panel.tmpl
	'Go to [_1]' => '[_1]へ進む',
	'Sorry, there is no data for this object set.' => 'このオブジェクトセットに対応したデータはありません。',
	'Sorry, there were no results for your search. Please try searching again.' => '検索結果がありません。検索をやり直してください。',
	'Step [_1] of [_2]' => '[_1] / [_2]',

## tmpl/cms/include/log_table.tmpl
	'IP: [_1]' => 'IP: [_1]',
	'No log records could be found.' => 'ログレコードが見つかりませんでした。',
	'_LOG_TABLE_BY' => 'ユーザー',

## tmpl/cms/include/login_mt.tmpl
	'Remember me?' => 'サインイン状態を保持し続ける',

## tmpl/cms/include/member_table.tmpl
	'Are you sure you want to remove the [_1] selected users from this [_2]?' => '[_2]から[_1]人のユーザーを削除してよろしいですか?',
	'Are you sure you want to remove the selected user from this [_1]?' => '[_1]からユーザーを削除してよろしいですか?',
	'Remove selected user(s) (r)' => 'ユーザーを削除 (r)',
	'Remove this role' => 'ロールを削除する',

## tmpl/cms/include/mobile_global_menu.tmpl
	'PC View' => 'PC表示',
	'Select another child site...' => '他の子サイトを選択...',
	'Select another site...' => '他のサイトを選択...',

## tmpl/cms/include/notification_table.tmpl
	'Date Added' => '日付',
	'Save changes' => '変更を保存',

## tmpl/cms/include/old_footer.tmpl
	'<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]' => '<a href="[_1]"><mt:var name="mt_product_name"></a> version [_2]',
	'Wiki' => 'Wiki(英語)',
	'Your Dashboard' => 'ユーザーダッシュボード',
	'https://wiki.movabletype.org/' => 'https://wiki.movabletype.org/',
	q{_LOCALE_CALENDAR_HEADER_} => q{'日', '月', '火', '水', '木', '金', '土'},

## tmpl/cms/include/pagination.tmpl
	'First' => '最初',
	'Last' => '最後',

## tmpl/cms/include/ping_table.tmpl
	'Edit this TrackBack' => 'このトラックバックを編集',
	'From' => '送信元',
	'Go to the source entry of this TrackBack' => 'トラックバック送信元に移動',
	'Moderated' => '公開保留',
	'Publish selected [_1] (p)' => '選択された[_1]を公開 (p)',
	'Target' => '送信先',
	'View the [_1] for this TrackBack' => 'トラックバックされた[_1]を見る',

## tmpl/cms/include/primary_navigation.tmpl
	'Close Site Menu' => 'サイトメニューを閉じる',
	'Open Panel' => 'パネルを開く',
	'Open Site Menu' => 'サイトメニューを開く',

## tmpl/cms/include/revision_table.tmpl
	'*Deleted due to data breakage*' => '*データの破損のため削除されました*',
	'No revisions could be found.' => '変更履歴がありません。',
	'Note' => 'メモ',
	'Saved By' => '保存したユーザー',
	'_REVISION_DATE_' => '保存した日',

## tmpl/cms/include/rpt_log_table.tmpl
	'Schwartz Message' => 'Schwartzメッセージ',

## tmpl/cms/include/scope_selector.tmpl
	'(on [_1])' => '([_1])',
	'Create Blog (on [_1])' => 'ブログの作成 ([_1])',
	'Create Website' => 'ウェブサイトの作成',
	'Select another blog...' => 'ブログを選択',
	'Select another website...' => 'ウェブサイトを選択',
	'User Dashboard' => 'ユーザーダッシュボード',
	'Websites' => 'ウェブサイト',

## tmpl/cms/include/status_widget.tmpl
	'[_1] - Edited by [_2]' => '編集: [_2] - [_1]',
	'[_1] - Published by [_2]' => '公開: [_2] - [_1]',

## tmpl/cms/include/template_table.tmpl
	'Archive Path' => 'アーカイブパス',
	'Cached' => 'キャッシュ',
	'Create Archive Template:' => 'アーカイブテンプレートの作成:',
	'Dynamic' => 'ダイナミック',
	'Manual' => '手動',
	'No content type could be found.' => 'コンテンツタイプが見つかりません',
	'Publish Queue' => '公開キュー',
	'Publish selected templates (a)' => '選択されたテンプレートを公開 (a)',
	'SSI' => 'SSI',
	'Static' => 'スタティック',
	'Uncached' => 'キャッシュしていない',
	'templates' => 'テンプレート',
	'to publish' => '公開',

## tmpl/cms/include/theme_exporters/folder.tmpl
	'<mt:if name="is_blog">Blog URL<mt:else>Site URL</mt:if>' => '<mt:if name="is_blog">ブログURL<mt:else>サイトURL</mt:if>',
	'Folder Name' => 'フォルダ名',

## tmpl/cms/include/theme_exporters/static_files.tmpl
	'In the specified directories, files of the following types will be included in the theme: [_1]. Other file types will be ignored.' => '指定したディレクトリ内の、以下の種類のファイルがテーマにエクスポートされます: [_1]。その他のファイルは無視されます。',
	'List directories (one per line) in the Site Root directory which contain the static files to be included in the theme. Common directories might be: css, images, js, etc.' => 'ファイルが置かれたディレクトリを、サイトパスからの相対パスで一行ずつ記入してください。例: images',
	'Specify directories' => 'ディレクトリの指定',

## tmpl/cms/include/theme_exporters/templateset.tmpl
	'<span class="count">[_1]</span> [_2] are included' => '<span class="count">[_1]</span>件の[_2]が含まれます',
	'modules' => 'モジュール',
	'widget sets' => 'ウィジェットセット',

## tmpl/cms/install.tmpl
	'Create Your Account' => 'アカウントの作成',
	'Do you want to proceed with the installation anyway?' => 'インストールを続けますか?',
	'Finish install (s)' => 'インストール (s)',
	'Finish install' => 'インストール',
	'Please create an administrator account for your system. When you are done, Movable Type will initialize your database.' => 'システム管理者のアカウントを作成してください。作成が完了すると、データベースを初期化します。',
	'Select a password for your account.' => 'パスワードを入力してください。',
	'System Email' => 'システムのメールアドレス',
	'The display name is required.' => '表示名は必須です。',
	'The e-mail address is required.' => 'メールアドレスは必須です。',
	'The initial account name is required.' => '名前は必須です。',
	'The version of Perl installed on your server ([_1]) is lower than the minimum supported version ([_2]).' => 'サーバーにインストールされているPerlのバージョン([_1])が、Movable Type がサポートしているバージョン([_2])より低いため正常に動作しない可能性があります。',
	'To proceed, you must authenticate properly with your LDAP server.' => 'LDAPサーバーで認証を受けないと先に進めません。',
	'Use this as system email address' => 'システムのメールアドレスとして利用する',
	'View MT-Check (x)' => 'システムチェック (x)',
	'Welcome to Movable Type' => 'Movable Typeへようこそ',
	'While Movable Type may run, it is an <strong>untested and unsupported environment</strong>.  We strongly recommend upgrading to at least Perl [_1].' => 'Movable Type が動作する場合でも、<strong>動作確認を行っていない、サポート対象外の環境となります</strong>。少なくともPerl[_1]以上へアップグレードすることを強くお勧めします。',

## tmpl/cms/layout/dashboard.tmpl
	'Reload' => '再読込',
	'reload' => '再読込',

## tmpl/cms/list_category.tmpl
	'Add child [_1]' => 'サブ[_1]を追加する',
	'Alert' => '警告',
	'Basename is required.' => '出力ファイル名/フォルダ名は必須です。',
	'Change and move' => '変更して移動',
	'Duplicated basename on this level.' => '出力ファイル名/フォルダ名が同一階層内で重複しています。',
	'Duplicated label on this level.' => '名前が同一階層内で重複しています。',
	'Invalid Basename.' => '不正な出力ファイル名/フォルダ名です。',
	'Label is required.' => '名前は必須です。',
	'Label is too long.' => '名前が長すぎます。',
	'Remove [_1]' => '[_1]を削除する',
	'Rename' => '名前を変更',
	'Top Level' => 'ルート',
	'[_1] label' => '[_1]名',
	q{Are you sure you want to remove [_1] [_2] with [_3] sub [_4]?} => q{[_3]個のサブ[_4]を含む[_1]'[_2]'を削除してよろしいですか?},
	q{Are you sure you want to remove [_1] [_2]?} => q{[_1]'[_2]'を削除してよろしいですか?},
	q{[_1] '[_2]' already exists.} => q{'[_2]'という[_1]は既に存在します。},

## tmpl/cms/list_common.tmpl
	'<mt:var name="js_message">' => '<mt:var name="js_message">',
	'Feed' => 'フィード',

## tmpl/cms/list_entry.tmpl
	'Entries Feed' => '記事フィード',
	'Pages Feed' => 'ウェブページフィード',
	'Quickfilters' => 'クイックフィルタ',
	'Recent Users...' => '最近のユーザー',
	'Remove filter' => 'フィルタしない',
	'Select A User:' => 'ユーザーを選択:',
	'Select...' => '選択してください',
	'Show only entries where' => '記事を表示: ',
	'Show only pages where' => 'ウェブページを表示: ',
	'Showing only: [_1]' => '[_1]を表示',
	'The entry has been deleted from the database.' => '記事をデータベースから削除しました。',
	'The page has been deleted from the database.' => 'ウェブページをデータベースから削除しました。',
	'User Search...' => 'ユーザーを検索',
	'[_1] (Disabled)' => '[_1] (無効)',
	'[_1] where [_2] is [_3]' => '[_2]が[_3]の[_1]',
	'asset' => 'アセット',
	'change' => '絞り込み',
	'is' => 'が',
	'published' => '公開',
	'review' => '承認待ち',
	'scheduled' => '指定日公開',
	'spam' => 'スパム',
	'status' => 'ステータス',
	'tag (exact match)' => 'タグ (完全一致)',
	'tag (fuzzy match)' => 'タグ (あいまい検索)',
	'unpublished' => '未公開',

## tmpl/cms/list_template.tmpl
	'<strong>&lt;$MTWidgetSet name=&quot;Name of the Widget Set&quot;$&gt;</strong>' => '<strong>&lt;$MTWidgetSet name=&quot;ウィジェットセットの名前&quot;$&gt;</strong>',
	'Content Type Listing Archive' => 'コンテンツタイプリストアーカイブ',
	'Content type Templates' => 'コンテンツタイプのテンプレート',
	'Create new template (c)' => 'テンプレートの作成 (s)',
	'Create' => '新規作成',
	'Delete selected Widget Sets (x)' => '選択されたウィジェットセットを削除 (x)',
	'Entry Archive' => '記事アーカイブ',
	'Entry Listing Archive' => '記事リストアーカイブ',
	'Helpful Tips' => 'ヘルプ',
	'No widget sets could be found.' => 'ウィジェットセットが見つかりませんでした。',
	'Page Archive' => 'ウェブページアーカイブ',
	'Publishing Settings' => '公開設定',
	'Select template type' => 'テンプレートの種類を選択',
	'Selected template(s) has been copied.' => '選択されたテンプレートをコピーしました。',
	'Show All Templates' => 'すべてのテンプレート',
	'Template Module' => 'テンプレートモジュール',
	'To add a widget set to your templates, use the following syntax:' => 'テンプレートにウィジェットセットを追加するときは以下の構文を利用します。',
	'You have successfully deleted the checked template(s).' => '選択したテンプレートを削除しました。',
	'You have successfully refreshed your templates.' => 'テンプレートの初期化を完了しました。',
	'Your templates have been published.' => 'テンプレートを再構築しました。',

## tmpl/cms/list_theme.tmpl
	'All Themes' => 'テーマの一覧',
	'Author: ' => '作者: ',
	'Available Themes' => '利用可能なテーマ',
	'Current Theme' => '現在のテーマ',
	'Errors' => 'エラー',
	'Failed' => '失敗',
	'Find Themes' => 'テーマを探す',
	'No themes are installed.' => 'テーマがインストールされていません。',
	'Portions of this theme cannot be applied to the child site. [_1] elements will be skipped.' => 'テーマの一部はサイトに適用できません。[_1]要素はスキップされます。',
	'Portions of this theme cannot be applied to the site. [_1] elements will be skipped.' => 'テーマの一部はサイトに適用できません。[_1]要素はスキップされます。',
	'Reapply' => '再適用',
	'Theme Errors' => 'テーマエラー',
	'Theme Information' => 'テーマ情報',
	'Theme Warnings' => 'テーマ警告',
	'Theme [_1] has been applied (<a href="[_2]" class="alert-link">[quant,_3,warning,warnings]</a>).' => 'テーマ "[_1]"を適用しました(<a href="[_2]" class="alert-link">[quant,_3,つの警告,つの警告]</a>)。',
	'Theme [_1] has been applied.' => 'テーマ "[_1]"を適用しました。',
	'Theme [_1] has been uninstalled.' => 'テーマ "[_1]"をアンインストールしました。',
	'Themes in Use' => '利用しているテーマ',
	'This theme cannot be applied to the child site due to [_1] errors' => '次の理由により、テーマを適用できませんでした',
	'This theme cannot be applied to the site due to [_1] errors' => '次の理由により、テーマを適用できませんでした。',
	'Uninstall' => 'アンインストール',
	'Warnings' => '警告',
	'[quant,_1,warning,warnings]' => '[quant,_1,,,]件の警告',
	'_THEME_DIRECTORY_URL' => 'https://plugins.movabletype.jp/',

## tmpl/cms/listing/asset_list_header.tmpl
	'You have successfully deleted the asset(s).' => 'アセットを削除しました。',
	q{Cannot write to '[_1]'. Thumbnail of items may not be displayed.} => q{サムネイル画像を表示できません: '[_1]'へ書き込みができません。},

## tmpl/cms/listing/association_list_header.tmpl
	'You have successfully granted the given permission(s).' => '権限を付与しました。',
	'You have successfully revoked the given permission(s).' => '権限を削除しました。',

## tmpl/cms/listing/author_list_header.tmpl
	'Some ([_1]) of the selected user(s) could not be re-enabled because they were no longer found in the external directory.' => '選択されたユーザーのうち[_1]人は外部ディレクトリ上に存在しないので有効にできませんでした。',
	'The deleted user(s) still exist in the external directory. As such, they will still be able to login to Movable Type Advanced.' => '削除されたユーザーが外部ディレクトリ上にまだ存在するので、このままではユーザーは再度サインインできてしまいます。',
	'You have successfully deleted the user(s) from the Movable Type system.' => 'システムからユーザーを削除しました。',
	'You have successfully disabled the selected user(s).' => '選択したユーザーを無効にしました。',
	'You have successfully enabled the selected user(s).' => '選択したユーザーを有効にしました。',
	'You have successfully unlocked the selected user(s).' => '選択したユーザーのロックを解除しました。',
	q{An error occurred during synchronization.  See the <a href='[_1]' class="alert-link">activity log</a> for detailed information.} => q{同期中にエラーが発生しました。エラーの詳細を<a href='[_1]' class="alert-link">ログ</a>で確認してください。},
	q{Some ([_1]) of the selected user(s) could not be re-enabled because they had some invalid parameter(s). Please check the <a href='[_2]' class="alert-link">activity log</a> for more details.} => q{選択されたユーザーのうち[_1]人を有効にできませんでした。エラーの詳細を<a href='[_2]' class="alert-link">ログ</a>で確認してください。},
	q{You have successfully synchronized users' information with the external directory.} => q{外部のディレクトリとユーザーの情報を同期しました。},

## tmpl/cms/listing/banlist_list_header.tmpl
	'Invalid IP address.' => '不正なIPアドレスです。',
	'The IP you entered is already banned for this site.' => '入力されたIPアドレスはすでに禁止IPに登録されています。',
	'You have added [_1] to your list of banned IP addresses.' => '禁止IPリストに[_1]を追加しました。',
	'You have successfully deleted the selected IP addresses from the list.' => 'リストから選択したIPアドレスを削除しました。',

## tmpl/cms/listing/blog_list_header.tmpl
	'Warning: You need to copy uploaded assets to new locations manually. You should consider maintaining copies of uploaded assets in their original locations to avoid broken links.' => '警告: アップロード済みのファイルは、新しいウェブサイトのパスに手動でコピーする必要があります。また、リンク切れを防止するために、旧パスのファイルも残すことを検討してください。',
	'You have successfully deleted the child site from the site. The files still exist in the site path. Please delete files if not needed.' => 'システムからサイトの削除が完了しました。 出力されたコンテンツは、削除されていません。必要に応じて削除をしてください。',
	'You have successfully deleted the site from the Movable Type system. The files still exist in the site path. Please delete files if not needed.' => 'システムからサイトの削除が完了しました。 出力されたコンテンツは、削除されていません。必要に応じて削除をしてください。',
	'You have successfully moved selected child sites to another site.' => '他のサイトへの移動が完了しました。',

## tmpl/cms/listing/category_set_list_header.tmpl
	'Some category sets were not deleted. You need to delete categories fields from the category set first.' => '削除できないカテゴリセットがありました。コンテンツタイプ内のカテゴリフィールドを先に削除する必要があります。',

## tmpl/cms/listing/comment_list_header.tmpl
	'All comments reported as spam have been removed.' => 'スパムとして報告されたコメントをすべて削除しました。',
	'No comments appear to be spam.' => 'スパムコメントはありません。',
	'One or more comments you selected were submitted by an unauthenticated commenter. These commenters cannot be banned or trusted.' => '選択したコメントの中に匿名のコメントが含まれています。これらのコメント投稿者は禁止したり承認したりできません。',
	'The selected comment(s) has been approved.' => '選択したコメントを公開しました。',
	'The selected comment(s) has been deleted from the database.' => '選択したコメントをデータベースから削除しました。',
	'The selected comment(s) has been recovered from spam.' => '選択したコメントをスパムから戻しました。',
	'The selected comment(s) has been reported as spam.' => '選択したコメントをスパムとして報告しました。',
	'The selected comment(s) has been unapproved.' => '選択したコメントを未公開にしました。',

## tmpl/cms/listing/content_data_list_header.tmpl
	'The content data has been deleted from the database.' => 'コンテンツデータをデータベースから削除しました。',

## tmpl/cms/listing/content_type_list_header.tmpl
	'Some content types were not deleted. You need to delete archive templates or content type fields from the content type first.' => 'いくつかのコンテンツタイプが削除できませんでした。先にアーカイブマッピングを削除する必要があります。',
	'The content type has been deleted from the database.' => 'コンテンツタイプをデータベースから削除しました。',

## tmpl/cms/listing/group_list_header.tmpl
	'You successfully deleted the groups from the Movable Type system.' => 'グループをMovable Typeのシステムから削除しました。',
	'You successfully disabled the selected group(s).' => '選択されたグループを無効にしました。',
	'You successfully enabled the selected group(s).' => '選択されたグループを有効にしました。',
	q{An error occurred during synchronization.  See the <a href='[_1]'>activity log</a> for detailed information.} => q{同期中にエラーが発生しました。エラーの詳細を<a href='[_1]'>ログ</a>で確認してください。},
	q{You successfully synchronized the groups' information with the external directory.} => q{外部のディレクトリとグループの情報を同期しました。},

## tmpl/cms/listing/group_member_list_header.tmpl
	'Some ([_1]) of the selected users could not be re-enabled because they are no longer found in LDAP.' => '選択されたユーザーのうち[_1]人は外部ディレクトリ上に存在しないので有効にできませんでした。',
	'You successfully added new users to this group.' => 'グループに新しいユーザーを追加しました。',
	'You successfully deleted the users.' => 'ユーザーを削除しました。',
	'You successfully removed the users from this group.' => 'グループからユーザーを削除しました。',
	q{You successfully synchronized users' information with the external directory.} => q{外部のディレクトリとユーザー情報を同期しました。},

## tmpl/cms/listing/log_list_header.tmpl
	'All times are displayed in GMT.' => '時刻はすべてGMTです。',
	'All times are displayed in GMT[_1].' => '時刻はすべてGMT[_1]です。',

## tmpl/cms/listing/notification_list_header.tmpl
	'You have added new contact to your address book.' => '新しい連絡先をアドレス帳に登録しました。',
	'You have successfully deleted the selected contacts from your address book.' => 'アドレス帳から選択したあて先を削除しました。',
	'You have updated your contact in your address book.' => 'アドレス帳を更新しました。',

## tmpl/cms/listing/ping_list_header.tmpl
	'All TrackBacks reported as spam have been removed.' => 'スパムとして報告したすべてのトラックバックを削除しました。',
	'No TrackBacks appeared to be spam.' => 'スパムトラックバックはありません。',
	'The selected TrackBack(s) has been approved.' => '選択したトラックバックを公開しました。',
	'The selected TrackBack(s) has been deleted from the database.' => '選択したトラックバックをデータベースから削除しました。',
	'The selected TrackBack(s) has been recovered from spam.' => '選択したトラックバックをスパムから戻しました。',
	'The selected TrackBack(s) has been reported as spam.' => '選択したトラックバックをスパムとして報告しました。',
	'The selected TrackBack(s) has been unapproved.' => '選択したトラックバックを未公開にしました。',

## tmpl/cms/listing/role_list_header.tmpl
	'You have successfully deleted the role(s).' => 'ロールを削除しました。',

## tmpl/cms/listing/tag_list_header.tmpl
	'Specify new name of the tag.' => 'タグの名前を指定してください。',
	'You have successfully deleted the selected tags.' => '選択したタグを削除しました。',
	'Your tag changes and additions have been made.' => 'タグの変更と追加が完了しました。',
	q{The tag '[_2]' already exists. Are you sure you want to merge '[_1]' with '[_2]' across all blogs?} => q{タグ「[_2]」は既に存在します。すべてのブログで「[_1]」を「[_2]」にマージしてもよろしいですか?},

## tmpl/cms/login.tmpl
	'Forgot your password?' => 'パスワードをお忘れですか?',
	'Sign In (s)' => 'サインイン (s)',
	'Sign in' => 'サインイン',
	'Your Movable Type session has ended. If you wish to sign in again, you can do so below.' => 'Movable Typeからサインアウトしました。以下から再度サインインできます。',
	'Your Movable Type session has ended. Please sign in again to continue this action.' => 'Movable Typeからサインアウトしました。続けるには再度サインインして下さい。',
	'Your Movable Type session has ended.' => 'Movable Typeからサインアウトしました。',

## tmpl/cms/not_implemented_yet.tmpl
	'Not implemented yet.' => '実装されていません。',

## tmpl/cms/pinging.tmpl
	'Pinging sites...' => 'トラックバックと更新通知を送信しています...',
	'Trackback' => 'トラックバック',

## tmpl/cms/popup/pinged_urls.tmpl
	'Failed Trackbacks' => 'トラックバック(未送信)',
	'Successful Trackbacks' => 'トラックバック(送信済み)',
	'To retry, include these TrackBacks in the Outbound TrackBack URLs list for your entry.' => '再送する場合は、トラックバック送信先URLにこれらのトラックバックをコピーしてください。',

## tmpl/cms/popup/rebuild_confirm.tmpl
	'All Files' => 'すべてのファイル',
	'Index Template: [_1]' => 'インデックステンプレート: [_1]',
	'Only Indexes' => 'インデックスのみ',
	'Only [_1] Archives' => '[_1]アーカイブのみ',
	'Publish (s)' => '再構築 (s)',
	'Publish <em>[_1]</em>' => '[_1]の再構築',
	'Publish [_1]' => '[_1]の再構築',
	'_REBUILD_PUBLISH' => '再構築',

## tmpl/cms/popup/rebuilt.tmpl
	'Publish Again (s)' => '再構築 (s)',
	'Publish Again' => '再構築しなおす',
	'Publish time: [_1].' => '処理時間: [_1]',
	'Success' => '完了',
	'The files for [_1] have been published.' => '[_1]を再構築しました。',
	'View this page.' => 'ページを見る',
	'View your site.' => 'サイトを見る',
	'Your [_1] archives have been published.' => '[_1]アーカイブを再構築しました。',
	'Your [_1] templates have been published.' => '[_1]テンプレートを再構築しました。',

## tmpl/cms/preview_content_data.tmpl
	'Preview [_1] Content' => '[_1]のプレビュー',
	'Re-Edit this [_1] (e)' => 'この[_1]を編集する (e)',
	'Re-Edit this [_1]' => 'この[_1]を編集する',
	'Return to the compose screen (e)' => '作成画面に戻る',
	'Return to the compose screen' => '作成画面に戻る',
	'Save this [_1] (s)' => 'この[_1]を保存する (s)',

## tmpl/cms/preview_content_data_strip.tmpl
	'Publish this [_1] (s)' => 'この[_1]を公開する (s)',
	'You are previewing &ldquo;[_1]&rdquo; content data entitled &ldquo;[_2]&rdquo;' => 'プレビュー中: [_1]「[_2]」',

## tmpl/cms/preview_entry.tmpl
	'Re-Edit this entry (e)' => 'この記事を編集する (e)',
	'Re-Edit this entry' => 'この記事を編集する',
	'Re-Edit this page (e)' => 'このウェブページを編集する (e)',
	'Re-Edit this page' => 'このウェブページを編集する',
	'Save this entry (s)' => 'この記事を保存する (s)',
	'Save this entry' => 'この記事を保存する',
	'Save this page (s)' => 'このウェブページを保存する (s)',
	'Save this page' => 'このウェブページを保存する',

## tmpl/cms/preview_strip.tmpl
	'Publish this entry (s)' => 'この記事を公開する (s)',
	'Publish this entry' => 'この記事を公開する',
	'Publish this page (s)' => 'このウェブページを公開する (s)',
	'Publish this page' => 'このウェブページを公開する',
	'You are previewing the entry entitled &ldquo;[_1]&rdquo;' => 'プレビュー中: 記事「[_1]」',
	'You are previewing the page entitled &ldquo;[_1]&rdquo;' => 'プレビュー中: ページ「[_1]」',

## tmpl/cms/preview_template_strip.tmpl
	'(Publish time: [_1] seconds)' => '(処理時間: [_1]秒)',
	'Re-Edit this template (e)' => 'このテンプレートを編集する (e)',
	'Re-Edit this template' => 'このテンプレートを編集する',
	'Save this template (s)' => 'このテンプレートを保存する (s)',
	'Save this template' => 'このテンプレートを保存する',
	'There are no categories in this blog.  Limited preview of category archive templates is possible with a virtual category displayed.  Normal, non-preview output cannot be generated by this template unless at least one category is created.' => 'このブログにはカテゴリが存在しないため、仮のカテゴリを利用しています。正しいプレビューを表示したい場合は、カテゴリを作成して下さい。',
	'You are previewing the template named &ldquo;[_1]&rdquo;' => 'テンプレート「[_1]」をプレビューしています。',

## tmpl/cms/rebuilding.tmpl
	'Complete [_1]%' => '[_1]% 終了',
	'Publishing <em>[_1]</em>...' => '<em>[_1]</em> を再構築中...',
	'Publishing [_1] [_2]...' => '[_1] [_2] を再構築中...',
	'Publishing [_1] archives...' => '[_1]アーカイブを再構築中...',
	'Publishing [_1] dynamic links...' => '[_1] のダイナミックリンクを再構築中...',
	'Publishing [_1] templates...' => '[_1]テンプレートを再構築中...',
	'Publishing [_1]...' => '[_1] を再構築中...',
	'Publishing...' => '再構築中...',

## tmpl/cms/recover_lockout.tmpl
	'Recovered from lockout' => 'ユーザーのロック解除',
	q{User '[_1]' has been unlocked.} => q{ユーザー '[_1]'のロックが解除されました。},

## tmpl/cms/recover_password_result.tmpl
	'No users were selected to process.' => 'ユーザーが選択されていません。',
	'Recover Passwords' => 'パスワード再設定',
	'Return' => '戻る',

## tmpl/cms/refresh_results.tmpl
	'No templates were selected to process.' => 'テンプレートが選択されていません。',
	'Return to templates' => 'テンプレートに戻る',

## tmpl/cms/restore.tmpl
	'Exported File' => 'エクスポートファイル',
	'Import (i)' => 'インポート (i)',
	'Import from Exported file' => 'エクスポートファイルからインポートする',
	'Overwrite global templates.' => 'グローバルテンプレートを上書きする',
	'Perl module XML::SAX and/or some of its dependencies are missing.  Movable Type cannot restore the system without these modules.' => 'インポートとエクスポートをするために必要なPerlモジュール(XML::SAXおよび依存モジュール)が見つかりません。',

## tmpl/cms/restore_end.tmpl
	'An error occurred during the import process: [_1] Please check activity log for more details.' => 'インポート中にエラーが発生しました。[_1] 詳細についてはログを確認してください。',

## tmpl/cms/restore_start.tmpl
	'Importing Movable Type' => 'インポートを開始',

## tmpl/cms/search_replace.tmpl
	'(search only)' => '(検索のみ)',
	'Case Sensitive' => '大文字/小文字を区別する',
	'Date Range' => '日付範囲',
	'Date/Time Range' => '日付と時刻の範囲',
	'Limited Fields' => '項目を指定する',
	'Regex Match' => '正規表現',
	'Replace Checked' => '選択したものを対象に置換',
	'Replace With' => '置換',
	'Reported as Spam?' => 'スパムコメント/トラックバック',
	'Search &amp; Replace' => '検索/置換',
	'Search Again' => '再検索',
	'Search For' => '検索',
	'Show all matches' => 'すべて見る',
	'Showing first [_1] results.' => '最初の[_1]件の結果を表示します。',
	'Submit search (s)' => '検索 (s)',
	'Successfully replaced [quant,_1,record,records].' => '[quant,_1,件,件]のデータを置き換えました。',
	'You must select one or more items to replace.' => '置き換える対象を1つ以上選択してください。',
	'[quant,_1,result,results] found' => '[quant,_1,件,件]見つかりました。',
	'_DATE_FROM' => '開始日',
	'_DATE_TO' => '終了日',
	'_TIME_FROM' => '開始時刻',
	'_TIME_TO' => '終了時刻',

## tmpl/cms/system_check.tmpl
	'Memcached Server is [_1].' => 'Memcachedサーバーは[_1]です。',
	'Memcached Status' => 'Memcachedの状態',
	'Memcached is [_1].' => 'Memcachedは[_1]です。',
	'Server Model' => 'サーバーモデル',
	'Total Users' => '全ユーザー数',
	'available' => '利用可能',
	'configured' => '設定済み',
	'disabled' => '無効',
	'unavailable' => '利用不可',
	q{Movable Type could not find the script named 'mt-check.cgi'. To resolve this issue, ensure that the mt-check.cgi script exists and that the CheckScript configuration parameter (if it is necessary) references it properly.} => q{mt-check.cgiが見つかりませんでした。mt-check.cgiが存在すること、名前を変えた場合は構成ファイルのCheckScriptディレクティブに名前を指定してください。},

## tmpl/cms/theme_export_replace.tmpl
	'Overwrite' => '上書き保存',
	q{Export theme folder already exists '[_1]'. You can overwrite a existing theme, or cancel to change the Basename?} => q{テーマをエクスポートするフォルダ([_1])は既に存在します。上書き保存するか、キャンセルして出力ファイル名を変更してください。},

## tmpl/cms/upgrade.tmpl
	'Begin Upgrade' => 'アップグレード開始',
	'Congratulations, you have successfully upgraded to Movable Type [_1].' => 'Movable Type [_1]へのアップグレードを完了しました。',
	'Do you want to proceed with the upgrade anyway?' => 'アップグレードを実行しますか?',
	'In addition, the following Movable Type components require upgrading or installation:' => '加えて、以下のコンポーネントのアップグレード、またはインストールが必要です。',
	'Return to Movable Type' => 'Movable Type に戻る',
	'The following Movable Type components require upgrading or installation:' => '以下のコンポーネントのアップグレード、またはインストールが必要です。',
	'Time to Upgrade!' => 'アップグレード開始',
	'Upgrade Check' => 'アップグレードのチェック',
	'Your Movable Type installation is already up to date.' => 'Movable Type は最新版です。',
	q{A new version of Movable Type has been installed.  We'll need to complete a few tasks to update your database.} => q{新しいバージョンの Movable Type をインストールしました。データベースのアップグレードを実行してください。},
	q{The Movable Type Upgrade Guide can be found <a href='[_1]' target='_blank'>here</a>.} => q{Movable Typeアップグレードガイドは<a href='https://www.movabletype.jp/documentation/upgrade/' target='_blank'>こちらを</a>参照ください。},

## tmpl/cms/upgrade_runner.tmpl
	'Error during installation:' => 'インストール中にエラーが発生しました',
	'Error during upgrade:' => 'アップグレード中にエラーが発生しました',
	'Initializing database...' => 'データベースの初期化中･･･',
	'Installation complete!' => 'インストールを完了しました！',
	'Return to Movable Type (s)' => 'Movable Typeに戻る (s)',
	'Upgrade complete!' => 'アップグレードを完了しました！',
	'Upgrading database...' => 'データベースをアップグレードしています･･･',
	'Your database is already current.' => 'データベースは最新の状態です。',

## tmpl/cms/view_log.tmpl
	'Download Filtered Log (CSV)' => 'フィルタしたログをダウンロード(CSV)',
	'Filtered Activity Feed' => 'フィルタしたフィード',
	'Filtered' => 'フィルタ',
	'Show log records where' => 'ログレコードの',
	'Showing all log records' => 'すべてのログレコードを表示',
	'Showing log records where' => 'ログレコード',
	'System Activity Log' => 'システムログ',
	'The activity log has been reset.' => 'ログをリセットしました。',
	'classification' => '分類',
	'level' => 'レベル',

## tmpl/cms/view_rpt_log.tmpl
	'Schwartz Error Log' => 'Schwartzエラーログ',
	'Showing all Schwartz errors' => '全Schwartzエラー参照',

## tmpl/cms/widget/mt_news.tmpl
	'News' => 'ニュース',
	'No Movable Type news available.' => 'Movable Typeニュースはありません。',

## tmpl/cms/widget/notification_dashboard.tmpl
	'Messages from the system' => 'システムからのお知らせ',
	'warning' => '警告',

## tmpl/cms/widget/site_list.tmpl
	'Recent Posts' => '最近の投稿',
	'Setting' => '設定',

## tmpl/cms/widget/site_stats.tmpl
	'Statistics Settings' => 'アクセス統計を設定する',

## tmpl/cms/widget/system_information.tmpl
	'Active Users' => 'ユーザー',

## tmpl/cms/widget/updates.tmpl
	'Available updates (Ver. [_1]) found. Please see the <a href="[_2]" target="_blank">news</a> for detail.' => '利用可能なアップデート(Ver. [_1])があります。詳しくは<a href="[_2]" target="_blank">Movable Typeニュース</a>をご覧ください。',
	'Available updates ([_1]) found. Please see the <a href="[_2]" target="_blank">news</a> for detail.' => '利用可能なアップデート([_1])があります。詳しくは<a href="[_2]" target="_blank">Movable Typeニュース</a>をご覧ください。',
	'Movable Type is up to date.' => '最新のMovable Typeです。',
	'Update check failed. Please check server network settings.' => 'アップデートの確認ができません。ネットワーク設定を見直してください。',
	'Update check is disabled.' => 'アップデートの確認は無効です。',

## tmpl/comment/error.tmpl
	'Back (s)' => '戻る (s)',

## tmpl/comment/login.tmpl
	'Not a member? <a href="[_1]">Sign Up</a>!' => 'アカウントがないときは<a href="[_1]">サインアップ</a>してください。',
	'Sign in to comment' => 'サインインしてください',
	'Sign in using' => 'サインイン',

## tmpl/comment/profile.tmpl
	'Return to the <a href="[_1]">original page</a>.' => '<a href="[_1]">元のページ</a>に戻る',
	'Select a password for yourself.' => 'パスワード選択してください。',
	'Your Profile' => 'ユーザー情報',

## tmpl/comment/signup.tmpl
	'Create an account' => 'アカウントを作成する',
	'Password Confirm' => 'パスワード再入力',
	'Register' => '登録する',

## tmpl/comment/signup_thanks.tmpl
	'Before you can leave a comment you must first complete the registration process by confirming your account. An email has been sent to [_1].' => 'コメントを投稿する前にアカウントを確認して登録を完了する必要があります。[_1]にメールを送信しました。',
	'Return to the original entry.' => '元の記事に戻る',
	'Return to the original page.' => '元のウェブページに戻る',
	'Thanks for signing up' => 'ご登録ありがとうございます。',
	'To complete the registration process you must first confirm your account. An email has been sent to [_1].' => '登録を完了するためにまずアカウントを確認する必要があります。[_1]にメールを送信しました。',
	'To confirm and activate your account please check your inbox and click on the link found in the email we just sent you.' => 'メールを確認して、メールに書かれたリンクをクリックすることで、アカウントを確認して有効化できます。',

## tmpl/error.tmpl
	'CGI Path Configuration Required' => 'CGIPath の設定が必要です。',
	'Database Connection Error' => 'データベースへの接続でエラーが発生しました。',
	'Missing Configuration File' => '環境設定ファイルが見つかりません。',
	'_ERROR_CGI_PATH' => '環境設定ファイルの CGIPath の項目の設定に問題があるか、または設定がありません。詳細については、Movable Type マニュアルの<a href="javascript:void(0)">インストールと設定</a>の章を確認してください。',
	'_ERROR_CONFIG_FILE' => 'Movable Type の環境設定ファイルが存在しないか、または読み込みに失敗しました。詳細については、Movable Type マニュアルの<a href="javascript:void(0)">インストールと設定</a>の章を確認してください。',
	'_ERROR_DATABASE_CONNECTION' => '環境設定ファイルのデータベース設定に問題があるか、または設定がありません。詳細については、Movable Type マニュアルの<a href="javascript:void(0)">インストールと設定</a>の章を確認してください。',

## tmpl/feeds/error.tmpl
	'Movable Type Activity Log' => 'Movable Type システムログ',

## tmpl/feeds/feed_comment.tmpl
	'By commenter URL' => 'コメント投稿者のURL',
	'By commenter email' => 'コメント投稿者のメールアドレス',
	'By commenter identity' => 'コメント投稿者のID',
	'By commenter name' => 'コメント投稿者の名前',
	'From this [_1]' => 'この[_1]から',
	'More like this' => '他にも...',
	'On this day' => 'この日付から',
	'On this entry' => 'この記事に対する',

## tmpl/feeds/feed_content_data.tmpl
	'From this author' => 'このユーザーから',

## tmpl/feeds/feed_ping.tmpl
	'By source URL' => '送信元のURL',
	'By source blog' => '送信元のブログ',
	'By source title' => '送信元記事のタイトル',
	'Source [_1]' => '送信元の[_1]',

## tmpl/feeds/login.tmpl
	'This link is invalid. Please resubscribe to your activity feed.' => 'このリンクは無効です。フィードの購読をやり直してください。',

## tmpl/wizard/cfg_dir.tmpl
	'TempDir is required.' => 'TempDirが必要です。',
	'TempDir' => 'TempDir',
	'Temporary Directory Configuration' => 'テンポラリディレクトリの設定',
	'You should configure your temporary directory settings.' => 'テンポラリディレクトリの場所を指定してください。',
	'[_1] could not be found.' => '[_1]が見つかりませんでした。',
	q{Your TempDir has been successfully configured. Click 'Continue' below to continue configuration.} => q{TempDirを設定しました。次へボタンをクリックして先に進んでください。},

## tmpl/wizard/complete.tmpl
	'Configuration File' => '構成ファイル',
	'Retry' => '再試行',
	'Show the mt-config.cgi file generated by the wizard' => 'ウィザードで作成されたmt-config.cgiを表示する',
	'The [_1] configuration file cannot be located.' => '[_1]の構成ファイルを作成できませんでした。',
	'The mt-config.cgi file has been created manually.' => 'mt-config.cgiを手動で作成しました。',
	'The wizard was unable to save the [_1] configuration file.' => '[_1]の構成ファイルを保存できませんでした。',
	q{Confirm that your [_1] home directory (the directory that contains mt.cgi) is writable by your web server and then click 'Retry'.} => q{[_1]ディレクトリ(mt.cgiを含んでいる場所)がウェブサーバーによって書き込めるか確認して、'再試行'をクリックしてください。},
	q{Congratulations! You've successfully configured [_1].} => q{[_1]の設定を完了しました。},
	q{Please use the configuration text below to create a file named 'mt-config.cgi' in the root directory of [_1] (the same directory in which mt.cgi is found).} => q{以下のテキストを利用して、mt-config.cgiという名前のファイルを[_1]のルートディレクトリ(mt.cgiがあるディレクトリ)に配置してください。},

## tmpl/wizard/configure.tmpl
	'Database Configuration' => 'データベース設定',
	'Database Type' => 'データベースの種類',
	'Is your preferred database not listed? View the <a href="[_1]" target="_blank">Movable Type System Check</a> see if additional modules are necessary.' => '<a href="[_1]" target="_blank">Movable Type システムチェック</a>を実行して、必要なモジュールを確認してください。',
	'Once installed, <a href="javascript:void(0)" onclick="[_1]">click here to refresh this screen</a>.' => 'モジュールをインストールしたら<a href="javascript:void(0)" onclick="[_1]">ここをクリック</a>して表示を更新してください。',
	'Please enter the parameters necessary for connecting to your database.' => 'データベース接続に必要な情報を入力してください。',
	'Read more: <a href="[_1]" target="_blank">Setting Up Your Database</a>' => '詳しくは<a href="[_1]" target="_blank">こちら</a>を参照してください。',
	'Select One...' => '選択してください',
	'Show Advanced Configuration Options' => '高度な設定',
	'Show Current Settings' => '現在の設定を表示',
	'Test Connection' => '接続テスト',
	'You may proceed to the next step.' => '次のステップへ進みます。',
	'You must set your Database Path.' => 'データベースのパスを設定します。',
	'You must set your Database Server.' => 'データベースサーバを設定します。',
	'You must set your Username.' => 'データベースのユーザー名を設定します。',
	'Your database configuration is complete.' => 'データベースの設定を完了しました。',
	'https://www.movabletype.org/documentation/[_1]' => 'https://www.movabletype.jp/documentation/[_1]',

## tmpl/wizard/optional.tmpl
	'Address of your SMTP Server.' => 'SMTPサーバーのアドレスを指定します。',
	'An error occurred while attempting to send mail: ' => 'メール送信の過程でエラーが発生しました。',
	'Check your email to confirm receipt of a test email from Movable Type and then proceed to the next step.' => 'Movable Typeからのテストメールを受信したことを確認して、次のステップへ進んでください。',
	'Do not use SSL' => 'SSL接続を行わない',
	'Mail Configuration' => 'メール設定',
	'Mail address to which test email should be sent' => 'テストメールが送られるメールアドレス',
	'Outbound Mail Server (SMTP)' => '送信メールサーバー(SMTP)',
	'Password for your SMTP Server.' => 'SMTP認証に利用するユーザーのパスワードを指定してください。',
	'Periodically Movable Type will send email for password recovery, to inform authors of new comments, and other events. If not using Sendmail (default on unix servers), an SMTP Server must be specified.' => 'Movable Typeはパスワードの再設定や、新しいコメントの通知などをメールでお知らせします。これらのメールが正しく送信されるよう設定してください。',
	'Port number for Outbound Mail Server' => 'SMTPサーバのポート番号',
	'Port number of your SMTP Server.' => 'SMTPサーバのポート番号を指定します',
	'SMTP Auth Password' => 'パスワード',
	'SMTP Auth Username' => 'ユーザー名',
	'SSL Connection' => 'SSL接続',
	'Send Test Email' => 'テストメールを送信',
	'Send mail via:' => 'メール送信プログラム',
	'Sendmail Path' => 'sendmailのパス',
	'Show current mail settings' => '現在のメール設定を表示',
	'Skip' => 'スキップ',
	'This field must be an integer.' => 'このフィールドには整数の値を入力して下さい',
	'Use SMTP Auth' => 'SMTP認証を利用する',
	'Use SSL' => 'SSLで接続する',
	'Use STARTTLS' => 'STARTTLSコマンドを利用する',
	'Username for your SMTP Server.' => 'SMTP認証に利用するユーザー名を指定してください。',
	'You must set a password for the SMTP server.' => 'SMTP認証で利用するユーザーのパスワードを入力してください。',
	'You must set a username for the SMTP server.' => 'SMTP認証で利用するユーザー名を入力してください。',
	'You must set the SMTP server address.' => 'SMTPサーバのアドレスを入力してください。',
	'You must set the SMTP server port number.' => 'SMTPサーバのポート番号を指定してください。',
	'You must set the Sendmail path.' => 'Sendmailのパスは必須入力です。',
	'You must set the system email address.' => 'システムメールアドレスは必須入力です。',
	'Your mail configuration is complete.' => 'メール設定を完了しました。',

## tmpl/wizard/packages.tmpl
	'All required Perl modules were found.' => '必要なPerlモジュールは揃っています。',
	'Learn more about installing Perl modules.' => 'Perlモジュールのインストールについて',
	'Minimal version requirement: [_1]' => '必須バージョン: [_1]',
	'Missing Database Modules' => 'データベースモジュールが見つかりません',
	'Missing Optional Modules' => 'オプションのモジュールが見つかりません',
	'Missing Required Modules' => '必要なモジュールが見つかりません',
	'One or more Perl modules required by Movable Type could not be found.' => 'ひとつ以上の必須Perlモジュールが見つかりませんでした。',
	'Requirements Check' => 'システムチェック',
	'Some optional Perl modules could not be found. <a href="javascript:void(0)" onclick="[_1]">Display list of optional modules</a>' => 'オプションのPerlモジュールのうちいくつかが見つかりませんでした。<a href="javascript:void(0)" onclick="[_1]">オプションモジュールを表示</a>',
	'You are ready to proceed with the installation of Movable Type.' => 'Movable Typeのインストールを続行する準備が整いました。',
	'Your server has all of the required modules installed; you do not need to perform any additional module installations.' => 'すべての必要なモジュールはインストールされています。モジュールの追加インストールは必要ありません。',
	'https://www.movabletype.org/documentation/installation/perl-modules.html' => 'https://www.movabletype.jp/documentation/check_configuration.html',
	q{Some optional Perl modules could not be found. You may continue without installing these optional Perl modules. They may be installed at any time if they are needed. Click 'Retry' to test for the modules again.} => q{オプションのPerlモジュールのうちいくつかが見つかりませんでしたが、インストールはこのまま続行できます。オプションのPerlモジュールは、必要な場合にいつでもインストールできます。},
	q{The following Perl modules are required for Movable Type to run properly. Once you have met these requirements, click the 'Retry' button to re-test for these packages.} => q{以下のPerlモジュールはMovable Typeの正常な動作に必要です。必要なモジュールは「再試行」ボタンをクリックすることで確認できます。},
	q{The following Perl modules are required in order to make a database connection.  Movable Type requires a database in order to store your data of sites and child sites.  Please install one of the packages listed here in order to proceed.  When you are ready, click the 'Retry' button.} => q{データベース接続のための以下のPerlモジュールが必要です。Movable Typeはブログのデータを保存するためにデータベースを使用します。この一覧のパッケージのいずれかをインストールしてください。準備ができたら「再試行」のボタンをクリックしてください。},

## tmpl/wizard/start.tmpl
	'A configuration (mt-config.cgi) file already exists, <a href="[_1]">sign in</a> to Movable Type.' => '構成ファイル(mt-config.cgi)はすでに存在します。Movable Typeに<a href="[_1]">サインイン</a>してください。',
	'Begin' => '開始',
	'Configuration File Exists' => '構成ファイルが見つかりました',
	'Configure Static Web Path' => 'スタティックウェブパスの設定',
	'Movable Type requires that you enable JavaScript in your browser. Please enable it and refresh this page to proceed.' => 'ブラウザのJavaScriptを有効にする必要があります。続けるにはブラウザのJavaScriptを有効にし、このページの表示を更新してください。',
	'Movable Type ships with directory named [_1] which contains a number of important files such as images, javascript files and stylesheets.' => 'Movable Typeには、[_1]ディレクトリが標準で含まれています。この中には画像ファイルやJavaScript、スタイルシートなどの重要なファイルが含まれています。',
	'Once the [_1] directory is in a web-accessible location, specify the location below.' => '[_1]ディレクトリをウェブアクセス可能な場所に置く場合には、以下にその場所を指定してください。',
	'Static file path' => 'スタティックファイルパス',
	'Static web path' => 'スタティックウェブパス',
	'This URL path can be in the form of [_1] or simply [_2]' => 'このURLは[_1]のように記述するか、または簡略化して[_2]のように記述できます。',
	'This directory has either been renamed or moved to a location outside of the Movable Type directory.' => 'mt-static ディレクトリはMovable Typeのインストールディレクトリの外部に移動されたかまたは名前が変更されているようです。',
	'This path must be in the form of [_1]' => 'このパスは[_1]のように記述してください。',
	'This wizard will help you configure the basic settings needed to run Movable Type.' => 'このウィザードでは、Movable Typeを利用するために必要となる基本的な環境設定を行います。',
	'To create a new configuration file using the Wizard, remove the current configuration file and then refresh this page' => 'ウィザードで新しく構成ファイルを作るときは、現在の構成ファイルを別の場所に移動してこのページを更新してください。',
	q{<strong>Error: '[_1]' could not be found.</strong>  Please move your static files to the directory first or correct the setting if it is incorrect.} => q{エラー: '[_1]'が見つかりませんでした。ファイルをmt-staticディレクトリに移動するか、設定を修正してください。},
	q{The [_1] directory is in the main Movable Type directory which this wizard script resides, but due to your web server's configuration, the [_1] directory is not accessible in this location and must be moved to a web-accessible location (e.g., your web document root directory).} => q{[_1]ディレクトリは、Movable Typeのメインディレクトリ(このウィザード自身も含まれている)以下で見つかりました。しかし現在のサーバーの構成上、[_1]ディレクトリにはWebブラウザからアクセスできません。ウェブサイトのルートディレクトリの下など、Webブラウザからアクセスできる場所に移動してください。},
);

1;
