<?php
function smarty_block_mtentrycategories($args, $content, &$ctx, &$repeat) {
    $localvars = array('_categories', 'category', '_categories_counter');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $entry = $ctx->stash('entry');
        $args['entry_id'] = $entry['entry_id'];
        $categories = $ctx->mt->db->fetch_categories($args);
        $ctx->stash('_categories', $categories);
        $counter = 0;
    } else {
        $categories = $ctx->stash('_categories');
        $counter = $ctx->stash('_categories_counter');
    }
    if ($counter < count($categories)) {
        $category = $categories[$counter];
        $ctx->stash('category', $category);
        $ctx->stash('_categories_counter', $counter + 1);
        $repeat = true;
        if (($counter > 0) && isset($args['glue'])) {
            $content = $content . $args['glue'];
        }
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
