<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

global $Lexicon_ja;
$Lexicon_ja = array(

## php/mt.php
	'Page not found - [_1]' => '[_1]が見つかりませんでした。',

## php/lib/archive_lib.php
	'Page' => 'ウェブページ',
	'Individual' => 'ブログ記事',
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

## php/lib/function.mtsetvar.php
	'You used a [_1] tag without a valid name attribute.' => '[_1]タグではname属性は必須です。',
	'\'[_1]\' is not a hash.' => '[_1]はハッシュではありません。',
	'Invalid index.' => '不正なインデックスです。',
	'\'[_1]\' is not an array.' => '[_1]は配列ではありません。',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3]は不正です。',
	'\'[_1]\' is not a valid function.' => '[_1]という関数はサポートされていません。',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtcommentauthor.php
	'Anonymous' => '匿名',

## php/lib/block.mtsetvarblock.php

## php/lib/block.mtsethashvar.php

## php/lib/function.mtcommentauthorlink.php

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '[_1]はハッシュで利用できる関数ではありません。',
	'\'[_1]\' is not a valid function for an array.' => '[_1]は配列で利用できる関数ではありません。',

## php/lib/function.mtwidgetmanager.php
	'Error: widgetset [_1] is empty.' => 'ウィジェットセット[_1]に中身がありません。',
	'Error compiling widgetset [_1]' => 'ウィジェットセット[_1]をコンパイルできませんでした。',

## php/lib/block.mtauthorhaspage.php
	'No author available' => 'ユーザーが見つかりません。',

## php/lib/block.mtentries.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score"を指定するときはnamespaceも指定しなければなりません。',

## php/lib/block.mtif.php

## php/lib/block.mtassets.php

## php/lib/thumbnail_lib.php
	'GD support has not been available. Please install GD support.' => 'GDを利用できないようです。インストールしてください。',

## php/lib/function.mtentryclasslabel.php
	'page' => 'ウェブページ',
	'entry' => 'ブログ記事',
	'Entry' => 'ブログ記事',

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtremotesigninlink.php
	'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'ブログでTypeKey認証を有効にしていないので、MTRemoteSignInLinkは利用できません。',

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

## php/lib/block.mtauthorhasentry.php

## php/lib/function.mtcommentreplytolink.php
	'Reply' => '返信',

## php/mt.php.pre
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
