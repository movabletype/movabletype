<?php
# Movable Type (r) Open Source (C) 2001-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

global $Lexicon_es;
$Lexicon_es = array(

## php/lib/archive_lib.php
	'Individual' => 'Inidivual',
	'Page' => 'Página',
	'Yearly' => 'Anuales',
	'Monthly' => 'Mensuales',
	'Daily' => 'Diarias',
	'Weekly' => 'Semanales',
	'Author' => 'Autor',
	'(Display Name not set)' => '(Nombre no configurado)',
	'Author Yearly' => 'Anuales del autor',
	'Author Monthly' => 'Mensuales del autor',
	'Author Daily' => 'Diarios del autor',
	'Author Weekly' => 'Semanales del autor',
	'Category Yearly' => 'Categorías anuales',
	'Category Monthly' => 'Categorías mensuales',
	'Category Daily' => 'Categorías diarias',
	'Category Weekly' => 'Categorías semanales',

## php/lib/block.mtassets.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" debe usarse en combinación con el espacio de nombres.',

## php/lib/block.mtauthorhasentry.php
	'No author available' => 'Ningún autor disponible',

## php/lib/block.mtauthorhaspage.php

## php/lib/block.mtcalendar.php
	'You used an [_1] tag without a date context set up.' => 'Usó una etiqueta [_1] sin un contexto de fecha configurado.',

## php/lib/block.mtentries.php

## php/lib/block.mtif.php
	'You used a [_1] tag without a valid name attribute.' => 'Usó la etiqueta [_1] sin un nombre de atributo válido.',
	'[_1] [_2] [_3] is illegal.' => '[_1] [_2] [_3] es ilegal.',

## php/lib/block.mtsethashvar.php

## php/lib/block.mtsetvarblock.php
	'\'[_1]\' is not a hash.' => '\'[_1]\' no es un hash.',
	'Invalid index.' => 'Índice no válido.',
	'\'[_1]\' is not an array.' => '\'[_1]\' no es un array.',
	'\'[_1]\' is not a valid function.' => '\'[_1]\' no es una función válida.',

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Introduzca los caracteres que ve en la imagen de arriba.',

## php/lib/function.mtassettype.php
	'image' => 'Imagen',
	'Image' => 'Imagen',
	'file' => 'fichero',
	'File' => 'Fichero',
	'audio' => 'Audio',
	'Audio' => 'Audio',
	'video' => 'Vídeo',
	'Video' => 'Vídeo',

## php/lib/function.mtauthordisplayname.php

## php/lib/function.mtcommentauthorlink.php
	'Anonymous' => 'Anónimo',

## php/lib/function.mtcommentauthor.php

## php/lib/function.mtcommenternamethunk.php
	'This \'[_1]\' tag has been deprecated. Please use \'[_2]\' instead.' => 'Esta etiqueta \'[_1]\' está obsoleta. Por favor, en su lugar use \'[_2]\'.', # Translate - New

## php/lib/function.mtcommentreplytolink.php
	'Reply' => 'Responder',

## php/lib/function.mtentryclasslabel.php
	'page' => 'página',
	'entry' => 'entrada',
	'Entry' => 'Entrada',

## php/lib/function.mtinclude.php
	'\'parent\' modifier cannot be used with \'[_1]\'' => 'el modificador \'parent\' no puede usarse con \'[_1]\'',

## php/lib/function.mtpasswordvalidation.php
	'Password should be longer than [_1] characters' => 'La clave debe tener más de [_1] caracteres',
	'Password should not include your Username' => 'La clave no debe incluir el nombre de usuario',
	'Password should include letters and numbers' => 'La clave debe incluir letras y números',
	'Password should include lowercase and uppercase letters' => 'La clave debe incluir letras en mayúsculas y minúsculas',
	'Password should contain symbols such as #!$%' => 'La clave debe contener símbolos como #!$%',
	'You used an [_1] tag without a valid [_2] attribute.' => 'Utilizó una etiqueta [_1] sin un atributo [_2] válido.', # Translate - New

## php/lib/function.mtpasswordvalidationrule.php
	'minimum length of [_1]' => 'longitud mínima de [_1]',
	', uppercase and lowercase letters' => ', letras mayúsculas y minúsculas',
	', letters and numbers' => ', letras y números',
	', symbols (such as #!$%)' => ', símbolos (como #!$%)',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtremotesigninlink.php
	'TypePad authentication is not enabled in this blog.  MTRemoteSignInLink can not be used.' => 'La autentificación de TypePad no está habilitada en este blog. No se puede usar MTRemoteSignInLink.',

## php/lib/function.mtsetvar.php

## php/lib/function.mttagsearchlink.php
	'Invalid [_1] parameter.' => 'Parámetro [_1] no válido',

## php/lib/function.mtvar.php
	'\'[_1]\' is not a valid function for a hash.' => '\'[_1]\' no es una función válida para un hash.',
	'\'[_1]\' is not a valid function for an array.' => '\'[_1]\' no es una función válida para un array.',

## php/lib/function.mtwidgetmanager.php
	'Error compiling widgetset [_1]' => 'Error compilando el conjunto de widgets [_1]',

## php/lib/mtdb.base.php
	'The attribute exclude_blogs denies all include_blogs.' => 'El atributo exclude_blogs cancela todos los include_blogs.',

## php/lib/MTUtil.php
	'userpic-[_1]-%wx%h%x' => 'avatar-[_1]-%wx%h%x',

## php/mt.php
	'Page not found - [_1]' => 'Página no encontrada - [_1]',

## php/lib/MTViewer.php
	'moments from now' => 'dentro de unos momentos',
	'[quant,_1,hour,hours] from now' => 'dentro de [quant,_1,hora,horas]',
	'[quant,_1,minute,minutes] from now' => 'dentro de [quant,_1,minuto,minutos]',
	'[quant,_1,day,days] from now' => 'dentro de [quant,_1,día,días]',
	'less than 1 minute from now' => 'dentro de menos de un minuto',
	'less than 1 minute ago' => 'hace menos de un minuto',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] from now' => 'dentro de [quant,_1,hora,horas], [quant,_2,minuto,minutos]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes] ago' => 'hace [quant,_1,hora,horas], [quant,_2,minuto,minutos]',
	'[quant,_1,day,days], [quant,_2,hour,hours] from now' => 'dentro de [quant,_1,día,días], [quant,_2,hora,horas]',
	'[quant,_1,day,days], [quant,_2,hour,hours] ago' => 'hace [quant,_1,día,días], [quant,_2,hora,horas]',
	'[quant,_1,second,seconds] from now' => 'dentro de [quant,_1,segundo,segundos]',
	'[quant,_1,second,seconds]' => '[quant,_1,segundo,segundos]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds] from now' => 'dentro de [quant,_1,minuto,minutos], [quant,_2,segundo,segundos]',
	'[quant,_1,minute,minutes], [quant,_2,second,seconds]' => '[quant,_1,minuto,minutos], [quant,_2,segundo,segundos]',
	'[quant,_1,minute,minutes]' => '[quant,_1,minuto,minutos]',
	'[quant,_1,hour,hours], [quant,_2,minute,minutes]' => '[quant,_1,hora,horas], [quant,_2,minuto,minutos]',
	'[quant,_1,hour,hours]' => '[quant,_1,hora,horas]',
	'[quant,_1,day,days], [quant,_2,hour,hours]' => '[quant,_1,día,días], [quant,_2,hora,horas]',
	'[quant,_1,day,days]' => '[quant,_1,día,días]',

);
function translate_phrase($str, $params = null) {
    global $Lexicon, $Lexicon_es;
    $l10n_str = isset($Lexicon_es[$str]) ? $Lexicon_es[$str] : (isset($Lexicon[$str]) ? $Lexicon[$str] : $str);
    if (extension_loaded('mbstring')) {
        $str = mb_convert_encoding($l10n_str,mb_internal_encoding(),"UTF-8");
    } else {
        $str = $l10n_str;
    }
    return translate_phrase_param($str, $params);
}
?>
