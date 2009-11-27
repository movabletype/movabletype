<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
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
	'Author' => 'Par auteurs',
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
	'No author available' => 'Il n\'a pas d\'auteurs disponibles',

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtentries.php

## php/lib/block.mtif.php
	'You used a [_1] tag without a valid name attribute.' => 'Vous avez utilisé un tag [_1] sans un attribut de nom valide',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] est illégal.',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'\'[_1]\' is not a hash.' => '\'[_1]\' n\'est pas un hash',
	'Invalid index.' => 'Index invalide',
	'\'[_1]\' is not an array.' => '\'[_1]\' n\'est pas un tableau',
	'\'[_1]\' is not a valid function.' => '\'[_1]\' n\'est pas une fonction valide',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Saisissez les caractères que vous voyez dans l\'image ci-dessus.',

## php/lib/function.mtassettype.php
	'image' => 'image',
	'Image' => 'Image',
	'file' => 'fichier',
	'File' => 'Fichier',
	'audio' => 'Audio',
	'Audio' => 'Audio',
	'video' => 'Vidéo',
	'Video' => 'Vidéo',

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtcommentauthorlink.php
	'Anonymous' => 'Anonyme',

## php/lib/function.mtcommentauthor.php

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Répondre',

## php/lib/function.mtentryclasslabel.php
	'page' => 'Page',
	'entry' => 'note',
	'Entry' => 'Note',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'L\'authentification TypePad n\'est pas activée sur ce blog. MTRemoteSignInLink ne peut être utilisé.',

## php/lib/function.mtsetvar.php

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '\'[_1]\' n\'est pas une fonction valide pour un hash',
	'\'[_1]\' is not a valid function for an array.' => '\'[_1]\' n\'est pas une fonction valide pour un tableau',

## php/lib/function.mtwidgetmanager.php
	'Error: widgetset [_1] is empty.' => 'Erreur: le groupe de widget [_1] est vide.',
	'Error compiling widgetset [_1]' => 'Erreur de compilation du groupe de widget [_1]',

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
