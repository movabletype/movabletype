<?php
function translate_phrase($str, $params = null) {
	$Lexicon_fr = array(

## php/lib/function.mtauthordisplayname.php
	'Author (#' => 'Auteur (#',

## php/lib/function.mtproductname.php
	'$short_name [_1]' => '$short_name [_1]',

## php/lib/function.mtcommentfields.php
	'Thanks for signing in,' => 'Merci de vous être enregistré,',
	'Now you can comment.' => 'Vous pouvez maintenant commenter.',
	'sign out' => 'déconnexion',
	'(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Si vous n\'avez pas encore écrit de commentaire ici, il se peut que vous vous deviez être approuvé par le propriétaire du site avant que votre commentaire n\'apparaisse. En attendant, il n\'apparaîtra pas sur le site. Merci de patienter).',
	'Remember me?' => 'Mémoriser les informations de connexion ?',
	'Yes' => 'Oui',
	'No' => 'Non',
	'Comments' => 'Commentaires',
	'Preview' => 'Aperçu',
	'Submit' => 'Envoyer',
	'You are not signed in. You need to be registered to comment on this site.' => 'Vous n\'êtes pas enregistré. Vous devez être enregistré pour pouvoir commenter sur ce site.',
	'Sign in' => 'Identification',
	'. Now you can comment.' => '. Maintenant vous pouvez commenter.',
	'If you have a TypeKey identity, you can ' => 'Si vous avez une identité TypeKey, vous pouvez ',
	'sign in' => 'vous identifier',
	'to use it here.' => 'pour l\'utiliser ici.',
	'Name' => 'Nom',
	'Email Address' => 'Adresse e-mail',
	'URL' => 'URL',
	'(You may use HTML tags for style)' => '(Vous pouvez utiliser des balises HTML pour le style)',

## php/lib/block.mtentries.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" doit être utilisé en combinaison avec le namespace.',

## php/lib/function.mtremotesigninlink.php
	'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'L\'authentification TypeKey n\'est pas activée sur ce blog.  MTRemoteSignInLink ne peut être utilisé.',

## php/lib/block.mtassets.php

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Saisissez les caractères que vous voyez dans l\'image ci-dessus.',

## php/lib/archive_lib.php
	'Page' => 'Page',
	'Individual' => 'Individuel',
	'Yearly' => 'Annuelles',
	'Monthly' => 'Mensuelles',
	'Daily' => 'Journalières',
	'Weekly' => 'Hebdomadaires',
	'Author' => 'Par auteur',
	'Author Yearly' => 'Annuelles de l\'auteur',
	'Author Monthly' => 'Mensuelles de l\'auteur',
	'Author Daily' => 'Journalières de l\'auteur',
	'Author Weekly' => 'Hebdomadaires de l\'auteur',
	'Category Yearly' => 'Annuelles de la catégorie',
	'Category Monthly' => 'Mensuelles de la catégorie',
	'Category Daily' => 'Journalières de l\'auteur',
	'Category Weekly' => 'Hebdomadaires de l\'auteur',
);
	function translate_phrase($str, $params = null) {
    global $Lexicon, $Lexicon_fr;
    $l10n_str = isset($Lexicon_fr[$str]) ? $Lexicon_fr[$str] : (isset($Lexicon[$str]) ? $Lexicon[$str] : $str);
    if (extension_loaded('mbstring')) {
        $str = mb_convert_encoding($l10n_str,mb_internal_encoding(),"UTF-8");
    } else {
        $str = $l10n_str;
    }
    return translate_phrase_param($str, $params);
}
?>
