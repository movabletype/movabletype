<?php
function smarty_function_MTGoogleSearchResult($args, &$ctx) {
    $result = $ctx->stash('google_result_item');
    $prop = $args['property'];
    if ($prop == ''){
        $prop = 'title';
    }

    global $mt;
    $lang = $mt->config['DefaultLanguage'];
    if ($lang == 'ja') {
        $charset = $mt->config['PublishCharset'];
        $s = mb_convert_encoding($result[$prop], $charset, 'utf-8');
    }else{
        $s = $result[$prop];
    }

    return $s;
}
?>
