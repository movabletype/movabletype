<?php
function smarty_block_MTCategories($args, $content, &$ctx, &$repeat) {
    // status: incomplete
    // parameters: show_empty
    $localvars = array('_categories', '_categories_counter', 'category', 'inside_mt_categories', 'entries', '_categories_glue');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $args['blog_id'] = $ctx->stash('blog_id');
        $categories = $ctx->mt->db->fetch_categories($args);
        $glue = $args['glue'];
        $ctx->stash('_categories_glue', $glue);
        $ctx->stash('_categories', $categories);
        $ctx->stash('inside_mt_categories', 1);
        $counter = 0;
    } else {
        $categories = $ctx->stash('_categories');
        $counter = $ctx->stash('_categories_counter');
        $glue = $ctx->stash('_categories_glue');
    }
    if ($counter < count($categories)) {
        $category = $categories[$counter];
        $ctx->stash('category', $category);
        $ctx->stash('entries', null);
        $ctx->stash('_categories_counter', $counter + 1);
        if ($counter > 0) $content = $content . $glue;
        $repeat = true;
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
