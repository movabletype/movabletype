<?php
function translate_phrase($str, $params = null) {
	$Lexicon_es = array(

## php/lib/function.mtauthordisplayname.php
	'Author (#' => 'Autor (#',

## php/lib/function.mtproductname.php
	'[_1] [_2]' => '[_1] [_2]',

## php/lib/function.mtcommentfields.php
	'Thanks for signing in,' => 'Gracias por registrarse en,',
	'Now you can comment.' => 'Ahora puede comentar.',
	'sign out' => 'salir',
	'(If you haven\'t left a comment here before, you may need to be approved by the site owner before your comment will appear. Until then, it won\'t appear on the entry. Thanks for waiting.)' => '(Si no dejó aquí ningún comentario anteriormente, quizás necesite aprobación por parte del dueño del sitio, antes de que el comentario aparezca. Hasta entonces, no se mostrará en la entrada. Gracias por su paciencia).',
	'Remember me?' => '¿Recordarme?',
	'Yes' => 'Sí',
	'No' => 'No',
	'Comments' => 'Comentarios',
	'Preview' => 'Vista previa',
	'Submit' => 'Enviar',
	'You are not signed in. You need to be registered to comment on this site.' => 'No está registrado. Necesita registrarse  para comentar en este sitio.',
	'Sign in' => 'Registrarse',
	'. Now you can comment.' => '. Ahora puede comentar.',
	'If you have a TypeKey identity, you can ' => 'Si tiene una identidad en TypeKey, puede ',
	'sign in' => 'registrarse',
	'to use it here.' => 'para usarla aquí.',
	'Name' => 'Nombre',
	'Email Address' => 'Dirección de correo electrónico',
	'URL' => 'URL',
	'(You may use HTML tags for style)' => '(Puede usar etiquetas HTML para el estilo)',

## php/lib/block.mtentries.php
	'sort_by="score" must be used in combination with namespace.' => 'sort_by="score" debe usarse en combinación con el espacio de nombres.',

## php/lib/function.mtremotesigninlink.php
	'TypeKey authentication is not enabled in this blog.  MTRemoteSignInLink can\'t be used.' => 'La autentificación en TypeKey no está habilitada en este blog. No se puede usar MTRemoteSignInLink.',

## php/lib/block.mtassets.php

## php/lib/captcha_lib.php
	'Captcha' => 'Captcha',
	'Type the characters you see in the picture above.' => 'Introduzca los caracteres que ve en la imagen de arriba.',

## php/lib/archive_lib.php
	'Page' => 'Página',
	'Individual' => 'Inidivual',
	'Yearly' => 'Anual',
	'Monthly' => 'Mensual',
	'Daily' => 'Diario',
	'Weekly' => 'Semanal',
	'Author' => 'Autor',
	'Author Yearly' => 'Autor anual',
	'Author Monthly' => 'Autor mensual',
	'Author Daily' => 'Autor diario',
	'Author Weekly' => 'Autor semanal',
	'Category Yearly' => 'Categoría anual',
	'Category Monthly' => 'Categoría mensual',
	'Category Daily' => 'Categoría diaria',
	'Category Weekly' => 'Categoría semanal',
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
