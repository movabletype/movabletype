<?php
function translate_phrase($str, $params = null) {
	$Lexicon_nl = array(

## php/lib/function.mtauthordisplayname.php
	'Author (#' => 'Auteur (#',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtcommentfields.php
	'Thanks for signing in,' => 'Bedankt om uzelf aan te melden,',
	'Now you can comment.' => 'Nu kunt u reageren.',
	'sign out' => 'afmelden',
	'(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Als u hier nog nooit gereageerd heeft, kan het zijn dat de eigenaar van deze site eerst goedkeuring moet geven voordat uw reactie verschijnt. Eerder zal uw reactie niet zichtbaar zijn onder het bericht. Bedankt voor uw geduld.)',
	'Remember me?' => 'Mij onthouden?',
	'Yes' => 'Ja',
	'No' => 'Nee',
	'Comments' => 'Reacties',
	'Preview' => 'Voorbeeld',
	'Submit' => 'Invoeren',
	'You are not signed in. You need to be registered to comment on this site.' => 'U bent niet aangemeld.  U moet geregistreerd zijn om te kunnen reageren op deze website.',
	'Sign in' => 'Aanmelden',
	'. Now you can comment.' => '. Nu kunt u reageren.',
	'If you have a TypeKey identity, you can ' => 'Als u een TypeKey identiteit heeft, kunt u ',
	'sign in' => 'zich aanmelden',
	'to use it here.' => 'om ze hier te gebruiken.',
	'Name' => 'Naam',
	'Email Address' => 'E-mailadres',
	'URL' => 'URL',
	'(You may use HTML tags for style)' => '(U mag HTML tags gebruiken voor de stijl)',

## php/lib/block.mtentries.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" moet gebruikt worden in combinatie met een namespace.',

## php/lib/function.mtremotesigninlink.php
	'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.',

## php/lib/block.mtassets.php

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Tik te tekens in die u ziet in de afbeelding hierboven.',

## php/lib/archive_lib.php
	'Page' => 'per pagina',
	'Individual' => 'per bericht',
	'Yearly' => 'per jaar',
	'Monthly' => 'per maand',
	'Daily' => 'per dag',
	'Weekly' => 'per week',
	'Author' => 'per auteur',
	'Author Yearly' => 'per auteur per jaar',
	'Author Monthly' => 'per auteur per maand',
	'Author Daily' => 'per auteur per dag',
	'Author Weekly' => 'per auteur per week',
	'Category Yearly' => 'per categorie per jaar',
	'Category Monthly' => 'per categorie per maand',
	'Category Daily' => 'per categorie per dag',
	'Category Weekly' => 'per categorie per week',
);
	function translate_phrase($str, $params = null) {
    global $Lexicon, $Lexicon_nl;
    $l10n_str = isset($Lexicon_nl[$str]) ? $Lexicon_nl[$str] : (isset($Lexicon[$str]) ? $Lexicon[$str] : $str);
    if (extension_loaded('mbstring')) {
        $str = mb_convert_encoding($l10n_str,mb_internal_encoding(),"UTF-8");
    } else {
        $str = $l10n_str;
    }
    return translate_phrase_param($str, $params);
}
?>
