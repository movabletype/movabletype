<?php
function smarty_function_MTTagID($args, &$ctx) {
    $tag = $ctx->stash('Tag');
    if (!$tag) return '';
    if (is_array($tag)) {
        return $tag['tag_id'];
    } else {
        $tag = $ctx->mt->db->fetch_tag_by_name($tag);
        if ($tag) {
            $ctx->stash('Tag', $tag);
            return $tag['tag_id'];
        }
        return '';
    }
}
?>
