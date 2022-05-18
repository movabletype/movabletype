<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

global $Lexicon_ja;
$Lexicon_ja = array(

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## php/lib/archive_lib.php
	'INDIVIDUAL_ADV' => '記事',
	'PAGE_ADV' => 'ウェブページ',
	'YEARLY_ADV' => '年別',
	'MONTHLY_ADV' => '月別',
	'DAILY_ADV' => '日別',
	'WEEKLY_ADV' => '週別',
	'AUTHOR_ADV' => 'ユーザー',
	'(Display Name not set)' => '(表示名なし)',
	'AUTHOR-YEARLY_ADV' => 'ユーザー 年別',
	'AUTHOR-MONTHLY_ADV' => 'ユーザー 月別',
	'AUTHOR-DAILY_ADV' => 'ユーザー 日別',
	'AUTHOR-WEEKLY_ADV' => 'ユーザー 週別',
	'CATEGORY_ADV' => 'カテゴリ',
	'CATEGORY-YEARLY_ADV' => 'カテゴリ 年別',
	'CATEGORY-MONTHLY_ADV' => 'カテゴリ 月別',
	'CATEGORY-DAILY_ADV' => 'カテゴリ 日別',
	'CATEGORY-WEEKLY_ADV' => 'カテゴリ 週別',
	'CONTENTTYPE_ADV' => 'コンテンツタイプ別',
	'CONTENTTYPE-DAILY_ADV' => 'コンテンツタイプ 日別',
	'CONTENTTYPE-WEEKLY_ADV' => 'コンテンツタイプ 週別',
	'CONTENTTYPE-MONTHLY_ADV' => 'コンテンツタイプ 月別',
	'CONTENTTYPE-YEARLY_ADV' => 'コンテンツタイプ 年別',
	'CONTENTTYPE-AUTHOR_ADV' => 'コンテンツタイプ ユーザー別',
	'CONTENTTYPE-AUTHOR-YEARLY_ADV' => 'コンテンツタイプ ユーザー 年別',
	'CONTENTTYPE-AUTHOR-MONTHLY_ADV' => 'コンテンツタイプ ユーザー 月別',
	'CONTENTTYPE-AUTHOR-DAILY_ADV' => 'コンテンツタイプ ユーザー 日別',
	'CONTENTTYPE-AUTHOR-WEEKLY_ADV' => 'コンテンツタイプ ユーザー 週別',
	'CONTENTTYPE-CATEGORY_ADV' => 'コンテンツタイプ カテゴリ別',
	'CONTENTTYPE-CATEGORY-YEARLY_ADV' => 'コンテンツタイプ カテゴリ 年別',
	'CONTENTTYPE-CATEGORY-MONTHLY_ADV' => 'コンテンツタイプ カテゴリ 月別',
	'CONTENTTYPE-CATEGORY-DAILY_ADV' => 'コンテンツタイプ カテゴリ 日別',
	'CONTENTTYPE-CATEGORY-WEEKLY_ADV' => 'コンテンツタイプ カテゴリ 週別',
	'Category' => 'カテゴリ',

## php/lib/block.mtarchivelist.php
	'No Content Type could be found.' => 'コンテンツタイプが見つかりません。',

## php/lib/block.mtarchives.php
	'ArchiveType not found - [_1]' => 'アーカイブタイプが見つかりません - [_1]',

## php/lib/block.mtassets.php
	'sort_by="score" must be used together with a namespace.' => 'sort_by="score"を指定するときはnamespaceも指定しなければなりません。',

## php/lib/block.mtauthorhascontent.php
	'No author available' => 'ユーザーが見つかりません。',

## php/lib/block.mtauthorhasentry.php

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => '[_1]を日付コンテキストの外部で利用しようとしました。',

## php/lib/block.mtcategorysets.php
	'No Category Set could be found.' => 'カテゴリセットが見つかりません。',

## php/lib/block.mtcontentauthoruserpicasset.php
	'You used an \'[_1]\' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an \'MTContents\' container tag?' => '[_1]をコンテキスト外で利用しようとしています。MTContentsコンテナタグの外部で使っていませんか?',

## php/lib/block.mtcontentfield.php
	'No Content Field could be found: \"[_1]\"' => 'コンテンツフィールドが見つかりません: "[_1]"',
	'No Content Field could be found.' => 'コンテンツフィールドが見つかりません。',
	'No Content Field Type could be found.' => 'コンテンツフィールドタイプが見つかりません。',

## php/lib/block.mtcontentfields.php

## php/lib/block.mtcontents.php
	'You used an \'[_1]\' tag outside of the context of the site;' => '[_1]をコンテキスト外で利用しようとしています。サイトの外部で使っていませんか?',
	'Content Type was not found. Blog ID: [_1]' => 'サイト (ID: [_1]) でコンテンツタイプが見つかりません。',

## php/lib/block.mtcontentscalendar.php
	'Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat' => 'Sun、Mon、Tue、Wed、Thu、Fri、Satのいずれかでなければなりません。',
	'You used an [_1] tag without a date context set up.' => '[_1]を日付コンテキストの外部で利用しようとしました。',
	'Invalid month format: must be YYYYMM' => 'YYYYMM形式でなければなりません。',
	'No such category \'[_1]\'' => '[_1]というカテゴリはありません。',

## php/lib/block.mtentries.php

## php/lib/block.mthasplugin.php
	'name is required.' => 'nameを指定してください。',

## php/lib/block.mtif.php
	'You used an [_1] tag without a valid name attribute.' => '[_1]タグではname属性は必須です。',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3]は不正です。',

## php/lib/block.mtifarchivetype.php
	'You used an [_1] tag without a valid [_2] attribute.' => '[_1]タグでは[_2]属性は必須です。',

## php/lib/block.mtifarchivetypeenabled.php

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'You used a [_1] tag without a valid name attribute.' => '[_1]タグではname属性は必須です。',
	'\'[_1]\' is not a hash.' => '[_1]はハッシュではありません。',
	'Invalid index.' => '不正なインデックスです。',
	'\'[_1]\' is not an array.' => '[_1]は配列ではありません。',
	'\'[_1]\' is not a valid function.' => '[_1]という関数はサポートされていません。',

## php/lib/block.mttags.php
	'content_type modifier cannot be used with type "[_1]".' => 'content_typeモディファイアは[_1]と同時に利用できません',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters shown in the picture above.' => '画像の中に見える文字を入力してください。',

## php/lib/content_field_type_lib.php
	'No Label (ID:[_1])' => 'ラベルがありません (ID:[_1])',
	'No category_set setting in content field type.' => 'コンテンツフィールドにカテゴリセットが設定されていません。',

## php/lib/function.mtarchivelink.php

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

## php/lib/function.mtcategoryarchivelink.php
	'[_1] cannot be used without publishing [_2] archive.' => '[_1]アーカイブを公開していないので[_1]は使えません。',

## php/lib/function.mtcontentauthordisplayname.php

## php/lib/function.mtcontentauthoremail.php

## php/lib/function.mtcontentauthorid.php

## php/lib/function.mtcontentauthorlink.php

## php/lib/function.mtcontentauthorurl.php

## php/lib/function.mtcontentauthorusername.php

## php/lib/function.mtcontentauthoruserpic.php

## php/lib/function.mtcontentauthoruserpicurl.php

## php/lib/function.mtcontentcreateddate.php

## php/lib/function.mtcontentdate.php

## php/lib/function.mtcontentfieldlabel.php

## php/lib/function.mtcontentfieldtype.php

## php/lib/function.mtcontentfieldvalue.php

## php/lib/function.mtcontentid.php

## php/lib/function.mtcontentmodifieddate.php

## php/lib/function.mtcontentpermalink.php

## php/lib/function.mtcontentscount.php

## php/lib/function.mtcontentsitedescription.php

## php/lib/function.mtcontentsiteid.php

## php/lib/function.mtcontentsitename.php

## php/lib/function.mtcontentsiteurl.php

## php/lib/function.mtcontentstatus.php

## php/lib/function.mtcontenttypedescription.php

## php/lib/function.mtcontenttypeid.php

## php/lib/function.mtcontenttypename.php

## php/lib/function.mtcontenttypeuniqueid.php

## php/lib/function.mtcontentuniqueid.php

## php/lib/function.mtcontentunpublisheddate.php

## php/lib/function.mtentryclasslabel.php
	'Page' => 'ウェブページ',
	'Entry' => '記事',

## php/lib/function.mtinclude.php
	'\'parent\' modifier cannot be used with \'[_1]\'' => '\'parent\'属性を[_1]属性と同時に指定することは出来ません。',

## php/lib/function.mtpasswordvalidation.php
	'Password should be longer than [_1] characters' => 'パスワードは最低[_1]文字以上です。',
	'Password should not include your Username' => 'パスワードにユーザー名を含む事は出来ません。',
	'Password should include letters and numbers' => 'パスワードは文字と数字を含める必要があります。',
	'Password should include lowercase and uppercase letters' => 'パスワードは大文字と小文字を含める必要があります。',
	'Password should contain symbols such as #!$%' => 'パスワードは記号を含める必要があります。',

## php/lib/function.mtpasswordvalidationrule.php
	'minimum length of [_1]' => '[_1]文字以上',
	', uppercase and lowercase letters' => '、大文字と小文字を含む',
	', letters and numbers' => '、文字と数字を含む',
	', symbols (such as #!$%)' => '、記号を含む',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtsetvar.php

## php/lib/function.mtsitecontentcount.php

## php/lib/function.mttagsearchlink.php
	'Invalid [_1] parameter.' => '[_1]パラメータが不正です。',

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '[_1]はハッシュで利用できる関数ではありません。',
	'\'[_1]\' is not a valid function for an array.' => '[_1]は配列で利用できる関数ではありません。',

## php/lib/mtdb.base.php
	'When the exclude_blogs and include_blogs attributes are used together, the same blog IDs should not be listed as parameters to both of them.' => 'include_blogs属性で指定されたブログがexclude_blogs属性ですべて除外されています。',

## php/mt.php
	'Page not found - [_1]' => '[_1]が見つかりませんでした。',

);

function translate_phrase($str, $params = null) {
    global $Lexicon, $Lexicon_ja;
    $l10n_str = isset($Lexicon_ja[$str]) ? $Lexicon_ja[$str] : (isset($Lexicon[$str]) ? $Lexicon[$str] : $str);
    if (extension_loaded('mbstring')) {
        $str = mb_convert_encoding($l10n_str,mb_internal_encoding(),"UTF-8");
    } else {
        $str = $l10n_str;
    }
    return translate_phrase_param($str, $params);
}
?>
