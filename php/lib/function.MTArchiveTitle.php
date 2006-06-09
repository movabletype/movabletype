<?php
require_once("archive_lib.php");
function smarty_function_MTArchiveTitle($args, &$ctx) {
    $at = $ctx->stash('current_archive_type');
    if (isset($args['archive_type'])) {
        $at = $args['archive_type'];
    }
    if ($at == 'Category') {
        return $ctx->tag('CategoryLabel', $args);
    } elseif ($at == 'Individual') {
        return $ctx->tag('EntryTitle', $args);
    } else {
        # cutting corners here... hope it's sufficient
        # instead of using the date of the entry we have
        # selected, we're going to use the current timestamp
        # available to us for providing the title.
        require_once("block.MTArchiveList.php");
        $sec_title = '_al_'.$at.'_section_title';
        if (function_exists($sec_title)) {
            return $sec_title($args, $ctx);
        } else {
            return $ctx->error("Unsupported archive type: $at");
        }
    }
}
?>
