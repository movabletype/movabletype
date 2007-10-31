<?php
require_once("archive_lib.php");
function smarty_function_mtarchivetitle($args, &$ctx) {
    global $_archivers;
    $at = $ctx->stash('current_archive_type');
    if (isset($args['type'])) {
        $at = $args['type'];
    } elseif (isset($args['archive_type'])) {
        $at = $args['archive_type'];
    }
    if ($at == 'Category') {
        return $ctx->tag('CategoryLabel', $args);
    } else {
        if (isset($_archivers[$at])) {
            return $_archivers[$at]->get_title($args, $ctx);
        }
    }
}
?>
