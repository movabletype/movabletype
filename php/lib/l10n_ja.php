<?php
global $Lexicon_ja;
$Lexicon_ja = array(

## php/plugins/init.AuthorArchives.php
	'Author' => 'ユーザー',
	'Author (#' => 'ユーザー (#',
	'Author Yearly' => 'ユーザー 年別',
	'Author Monthly' => 'ユーザー 月別',
	'Author Daily' => 'ユーザー 日別',
	'Author Weekly' => 'ユーザー 週別',

## php/plugins/init.Date-basedCategoryArchives.php
	'Category Yearly' => 'カテゴリ 年別',
	'Category Monthly' => 'カテゴリ 月別',
	'Category Daily' => 'カテゴリ 日別',
	'Category Weekly' => 'カテゴリ 週別',

## php/lib/archive_lib.php
	'Individual' => 'ブログ記事',
	'Yearly' => '年別',
	'Monthly' => '月別',
	'Daily' => '日別',
	'Weekly' => '週別',

## php/lib/function.mtremotesigninlink.php
	'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'ブログでTypeKey認証が有効になっていないので、MTRemoteSignInLinkは利用できません。',

## php/lib/function.mtproductname.php
	'$short_name [_1]' => '$short_name [_1]',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => '画像の中に見える文字を入力してください。',

## php/lib/block.mtassets.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score"を指定するときはnamespaceも指定しなければなりません。',

## php/lib/function.mtcommentfields.php
	'Thanks for signing in,' => '', # Translate - New
	'Now you can comment.' => 'コメントできます。',
	'sign out' => 'サインアウト',
	'(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(初めてコメントする場合、承認されるまではコメントが表示されない場合があります。)',
	'Remember me?' => 'ログイン情報を記憶する',
	'Yes' => 'はい',
	'No' => 'いいえ',
	'Comments' => 'コメント',
	'Preview' => '確認',
	'Post' => '送信',
	'You are not signed in. You need to be registered to comment on this site.' => 'サインインしていません。コメントするには登録が必要です。',
	'Sign in' => 'サインイン',
	'. Now you can comment.' => 'さん、コメントをどうぞ。',
	'If you have a TypeKey identity, you can ' => 'TypeKeyを持っていればここで',
	'sign in' => 'サインイン',
	'to use it here.' => 'できます。',
	'Name' => '名前',
	'Email Address' => 'メールアドレス',
	'URL' => 'URL',
	'(You may use HTML tags for style)' => '(スタイル用のHTMLタグを使うことができます)',

## php/lib/block.mtentries.php

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtassettype.php
    'image' => '画像',
    'file' => 'ファイル',
    'Image' => '画像',
    'File' => 'ファイル'
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
