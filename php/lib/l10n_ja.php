<?php
global $Lexicon_ja;
$Lexicon_ja = array(

## php/lib/function.mtauthordisplayname.php
    'Author (#' => 'ユーザー (#',

## php/lib/captcha_lib.php
    'Captcha' => 'Captcha',
    'Type the characters you see in the picture above.' => '画像の中に見える文字を入力してください。',

## php/lib/block.mtentries.php
    'sort_by="score" must be used in combination with namespace.' => 'sort_by="score"を指定するときはnamespaceも指定しなければなりません。',

## php/lib/block.mtassets.php

## php/lib/function.mtproductname.php
    '[_1] [_2]' => '[_1] [_2]',

## php/lib/archive_lib.php
    'Page' => 'ウェブページ',
    'Individual' => 'ブログ記事',
    'Yearly' => '年別',
    'Monthly' => '月別',
    'Daily' => '日別',
    'Weekly' => '週別',
    'Author' => 'ユーザー',
    'Author Yearly' => 'ユーザー 年別',
    'Author Monthly' => 'ユーザー 月別',
    'Author Daily' => 'ユーザー 日別',
    'Author Weekly' => 'ユーザー 週別',
    'Category Yearly' => 'カテゴリ 年別',
    'Category Monthly' => 'カテゴリ 月別',
    'Category Daily' => 'カテゴリ 日別',
    'Category Weekly' => 'カテゴリ 週別',

## php/lib/function.mtremotesigninlink.php
    'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'ブログでTypeKey認証が有効になっていないので、MTRemoteSignInLinkは利用できません。',

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
