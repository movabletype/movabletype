<?php
global $Lexicon_nl;
$Lexicon_nl = array(
## php/plugins/init.Date-basedCategoryArchives.php
	'Category Yearly' => 'Categorie per jaar',
	'Category Monthly' => 'Categorie per maand',
	'Category Daily' => 'Categorie per dag',
	'Category Weekly' => 'Categorie per week',

## php/plugins/init.AuthorArchives.php
	'Author' => 'Auteur',
	'Author Yearly' => 'Auteur per jaar',
	'Author Monthly' => 'Auteur per maand',
	'Author Daily' => 'Auteur per dag',
	'Author Weekly' => 'Auteur per week',

## php/lib/function.mtproductname.php
	'$short_name [_1]' => '$short_name [_1]',

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
	'Post' => 'Publiceren',
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
	'Individual' => 'Individueel',
	'Yearly' => 'Jaarlijks',
	'Monthly' => 'Maandelijks',
	'Daily' => 'Dagelijks',
	'Weekly' => 'Wekelijks',
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
