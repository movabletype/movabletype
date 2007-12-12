<?php
function smarty_function_mtcommentlink($args, &$ctx) {
    $args['no_anchor'] = 1;
    $entry_link = $ctx->tag('EntryPermaink', $args);
    $entry_link .= '#comment-' . $ctx['comment_id'];
    return $link;
}
?>