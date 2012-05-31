<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

global $Lexicon_fr;
$Lexicon_fr = array(

## php/lib/archive_lib.php
	'Individual' => 'Individuel',
	'Page' => 'Page',
	'Yearly' => 'Annuelles',
	'Monthly' => 'Mensuelles',
	'Daily' => 'Journalières',
	'Weekly' => 'Hebdomadaires',
	'Author' => 'Auteur',
	'(Display Name not set)' => '(Nom pas spécifié)',
	'Author Yearly' => 'Par auteurs et années',
	'Author Monthly' => 'Par auteurs et mois',
	'Author Daily' => 'Par auteurs et jours',
	'Author Weekly' => 'Par auteurs et semaines',
	'Category Yearly' => 'Par catégories et années',
	'Category Monthly' => 'Par catégories et mois',
	'Category Daily' => 'Par catégories et jours',
	'Category Weekly' => 'Par catégories et semaines',

## php/lib/block.mtassets.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" doit être utilisé en combinaison avec l\'espace de nom.',

## php/lib/block.mtauthorhasentry.php
	'No author available' => 'Il n\'a pas d\'auteur disponible',

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without a date context set up.' => 'Vous utilisez une balise [_1] sans avoir configuré la date.',

## php/lib/block.mtentries.php

## php/lib/block.mtif.php
	'You used a [_1] tag without a valid name attribute.' => 'Vous avez utilisé une balise [_1] sans un attribut de nom valide',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] est illégal.',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'\'[_1]\' is not a hash.' => '\'[_1]\' n\'est pas un hash',
	'Invalid index.' => 'Index invalide',
	'\'[_1]\' is not an array.' => '\'[_1]\' n\'est pas un tableau',
	'\'[_1]\' is not a valid function.' => '\'[_1]\' n\'est pas une fonction valide',

## php/lib/captcha_lib.php
	'Captcha' => 'CAPTCHA',
	'Type the characters you see in the picture above.' => 'Saisissez les caractères que vous voyez dans l\'image ci-dessus.',

## php/lib/function.mtassettype.php
	'image' => 'image',
	'Image' => 'Image',
	'file' => 'fichier',
	'File' => 'Fichier',
	'audio' => 'audio',
	'Audio' => 'Audio',
	'video' => 'vidéo',
	'Video' => 'Vidéo',

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtcommentauthorlink.php
	'Anonymous' => 'Anonyme',

## php/lib/function.mtcommentauthor.php

## php/lib/function.mtcommenternamethunk.php
	'This \'[_1]\' tag has been deprecated. Please use \'[_2]\' instead.' => 'La balise \'[_1]\' est obsolète. Veuillez utiliser \'[_2]\' à la place.', # Translate - New

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Répondre',

## php/lib/function.mtentryclasslabel.php
	'page' => 'page',
	'entry' => 'note',
	'Entry' => 'Note',

## php/lib/function.mtinclude.php
	'\'parent\' modifier cannot be used with \'[_1]\'' => 'Le modifieur \'parent\' ne peut pas être utilisé avec \'[_1]\'',

## php/lib/function.mtpasswordvalidation.php
	'Password should be longer than [_1] characters' => 'Le mot de passe ne devrait pas dépasser [_1] caractères',
	q{Password should not include your Username} => q{Le mot de passe ne doit pas être composé de votre nom d'utilisateur},
	'Password should include letters and numbers' => 'Le mot de passe devrait être composé de lettres et de chiffres',
	'Password should include lowercase and uppercase letters' => 'Le mot de passe devrait être composé de lettres en minuscule et majuscule',
	'Password should contain symbols such as #!$%' => 'Le mot de passe devrait contenir des caractères spéciaux comme #1$%',
	'You used an [_1] tag without a valid [_2] attribute.' => 'Vous avez utilisé une balise [_1] sans l\'attribut [_2] correct.', # Translate - New

## php/lib/function.mtpasswordvalidationrule.php
	'minimum length of [_1]' => 'longueur minimum de [_1]',
	', uppercase and lowercase letters' => ', lettres en minuscule et majuscule',
	', letters and numbers' => ', lettres et chiffres',
	', symbols (such as #!$%)' => ', caractères spéciaux (comme #!$%)',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can not be used.' => 'L\'authentification TypePad n\'est pas activée sur ce blog. MTRemoteSignInLink ne peut être utilisé.',

## php/lib/function.mtsetvar.php

## php/lib/function.mttagsearchlink.php
	'Invalid [_1] parameter.' => 'Paramètre [_1] invalide',

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '\'[_1]\' n\'est pas une fonction valide pour un hash',
	'\'[_1]\' is not a valid function for an array.' => '\'[_1]\' n\'est pas une fonction valide pour un tableau',

## php/lib/function.mtwidgetmanager.php
	'Error compiling widgetset [_1]' => 'Erreur de compilation du groupe de widget [_1]',

## php/lib/mtdb.base.php
	'The attribute exclude_blogs denies all include_blogs.' => 'L\'attribut exclude_blogs nie include_blogs.',

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'userpic-[_1]-%wx%h%x',

## php/mt.php
	'Page not found - [_1]' => 'Page non trouvée - [_1]',

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
