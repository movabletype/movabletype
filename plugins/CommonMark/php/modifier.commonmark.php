<?php
require_once __DIR__ . "/vendor/autoload.php";
use League\CommonMark\CommonMarkConverter;

function CommonMark() {
    global $COMMON_MARK;
    if (!is_object($COMMON_MARK)) {
        $COMMON_MARK = new CommonMarkConverter([
            // 'allow_unsafe_links' => false,
        ]);
    }
    return $COMMON_MARK;
}

# -- Smarty Modifier Interface ------------------------------------------------
/**
 * @throws \League\CommonMark\Exception\CommonMarkException
 */
function smarty_modifier_commonmark($text) {
    $converter = CommonMark();
    return $converter->convert($text);
}
