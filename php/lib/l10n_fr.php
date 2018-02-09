<?php
# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

global $Lexicon_fr;
$Lexicon_fr = array(

## php/lib/archive_lib.php
	'Individual' => 'Individuelles',
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
	'Category' => 'Catégorie',

## php/lib/block.mtassets.php
	'sort_by="score" must be used together with a namespace.' => 'sort_by="score" doit être utilisé avec un espace de noms.',

## php/lib/block.mtauthorhasentry.php
	'No author available' => 'Aucun auteur disponible',

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without establishing a date context.' => 'Vous avez utilisé une balise [_1] sans établir un contexte de date.',

## php/lib/block.mtentries.php

## php/lib/block.mtif.php
	'You used an [_1] tag without a valid name attribute.' => 'Vous avez utilisé une balise [_1] sans attribut de nom valide.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] est illégal.',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'You used a [_1] tag without a valid name attribute.' => 'Vous avez utilisé une balise [_1] sans un attribut de nom valide',
	'\'[_1]\' is not a hash.' => '\'[_1]\' n\'est pas un hash',
	'Invalid index.' => 'Index invalide',
	'\'[_1]\' is not an array.' => '\'[_1]\' n\'est pas un tableau',
	'\'[_1]\' is not a valid function.' => '\'[_1]\' n\'est pas une fonction valide',

## php/lib/captcha_lib.php
	'Captcha' => 'CAPTCHA',
	'Type the characters shown in the picture above.' => 'Tapez les caractères affichés dans l\'image ci-dessus.',

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
	'The \'[_1]\' tag has been deprecated. Please use the \'[_2]\' tag in its place.' => 'La balise \'[_1]\' est obsolète. Veuillez utiliser la balise \'[_2]\' à la place.',

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Répondre',

## php/lib/function.mtentryclasslabel.php
	'Entry' => 'Note',

## php/lib/function.mtinclude.php
	'\'parent\' modifier cannot be used with \'[_1]\'' => 'Le modifieur \'parent\' ne peut pas être utilisé avec \'[_1]\'',

## php/lib/function.mtpasswordvalidation.php
	'Password should be longer than [_1] characters' => 'Le mot de passe doit faire plus de [_1] caractères',
	"Password should not include your Username" => "Le mot de passe ne doit pas être composé de votre nom d'utilisateur",
	'Password should include letters and numbers' => 'Le mot de passe doit être composé de lettres et de chiffres',
	'Password should include lowercase and uppercase letters' => 'Le mot de passe doit être composé de lettres en minuscule et majuscule',
	'Password should contain symbols such as #!$%' => 'Le mot de passe doit contenir des caractères spéciaux comme #!$%',
	'You used an [_1] tag without a valid [_2] attribute.' => 'Vous avez utilisé une balise [_1] sans un attribut [_2] valide.',

## php/lib/function.mtpasswordvalidationrule.php
	'minimum length of [_1]' => 'longueur minimum de [_1]',
	', uppercase and lowercase letters' => ', lettres en minuscule et majuscule',
	', letters and numbers' => ', lettres et chiffres',
	', symbols (such as #!$%)' => ', caractères spéciaux (comme #!$%)',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled for this blog.  MTRemoteSignInLink cannot be used.' => 'L\'authentification TypePad n\'est pas activée pour ce blog. MTRemoteSignInLink ne peut pas être utilisé.',

## php/lib/function.mtsetvar.php

## php/lib/function.mttagsearchlink.php
	'Invalid [_1] parameter.' => 'Paramètre [_1] invalide',

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '\'[_1]\' n\'est pas une fonction valide pour un hash',
	'\'[_1]\' is not a valid function for an array.' => '\'[_1]\' n\'est pas une fonction valide pour un tableau',

## php/lib/mtdb.base.php
	'When the exclude_blogs and include_blogs attributes are used together, the same blog IDs should not be listed as parameters to both of them.' => 'Quand les attributs exclude_blogs et include_blogs sont utilisés ensemble, les mêmes identifiants de blog ne peuvent être fournis en paramètre de ces deux attributs.',

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
