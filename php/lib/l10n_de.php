<?php
global $Lexicon_de;
$Lexicon_de = array(
## php/plugins/init.Date-basedCategoryArchives.php
	'Category Yearly' => 'Kategorie jährlich',
	'Category Monthly' => 'Kategorie monatlich',
	'Category Daily' => 'Kategorie ätglich',
	'Category Weekly' => 'Kategorie wöchentlich',

## php/plugins/init.AuthorArchives.php
	'Author' => 'Autor',
	'Author Yearly' => 'Autor jährlich',
	'Author Monthly' => 'Autor monatlich',
	'Author Daily' => 'Autor täglich',
	'Author Weekly' => 'Autor wöchentlich',

## php/lib/function.mtproductname.php
	'$short_name [_1]' => '$short_name [_1]',

## php/lib/function.mtcommentfields.php
	'Thanks for signing in,' => 'Danke für Ihre Anmeldung',
	'Now you can comment.' => 'Sie können jetzt Ihren Kommentar verfassen.',
	'sign out' => 'abmelden',
	'(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Wenn Sie auf dieser Site bisher noch nicht kommentiert haben, wird Ihr Kommentar eventuell erst zeitverzögert freigeschaltet werden. Vielen Dank für Ihre Geduld.)',
	'Remember me?' => 'Benutzername speichern?',
	'Yes' => 'Ja',
	'No' => 'Nein',
	'Comments' => 'Kommentare',
	'Preview' => 'Vorschau',
	'Post' => 'Absenden',
	'You are not signed in. You need to be registered to comment on this site.' => 'Sie sind nicht angemeldet. Sie müssen sich registrieren, um hier zu kommentieren.',
	'Sign in' => 'Anmelden',
	'. Now you can comment.' => '. Sie können jetzt Ihren Kommentar verfassen.',
	'If you have a TypeKey identity, you can ' => 'Wenn Sie eine TypeKey-Identität besitzen, können Sie ',
	'sign in' => 'anmelden',
	'to use it here.' => ', um es hier zu verwenden.',
	'Name' => 'Name',
	'Email Address' => 'E-Mail-Adresse',
	'URL' => 'URL',
	'(You may use HTML tags for style)' => '(HTML-Tags erlaubt)',

## php/lib/block.mtentries.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" erfordert einen Namespace.',

## php/lib/function.mtremotesigninlink.php
	'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'TypeKey-Authentifizierung in diesem Weblog nicht aktiviert -  MTRemoteSignInLink kann nicht verwendet werden.',

## php/lib/block.mtassets.php

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Geben Sie die Buchstaben ein, die Sie in obigem Bild sehen.',

## php/lib/archive_lib.php
	'Individual' => 'Individuell',
	'Yearly' => 'Jährlich',
	'Monthly' => 'Monatlich',
	'Daily' => 'Täglich',
	'Weekly' => 'Wöchentlich',
);
function translate_phrase($str, $params = null) {
    global $Lexicon, $Lexicon_de;
    $l10n_str = isset($Lexicon_de[$str]) ? $Lexicon_de[$str] : (isset($Lexicon[$str]) ? $Lexicon[$str] : $str);
    if (extension_loaded('mbstring')) {
        $str = mb_convert_encoding($l10n_str,mb_internal_encoding(),"UTF-8");
    } else {
        $str = $l10n_str;
    }
    return translate_phrase_param($str, $params);
}
?>
