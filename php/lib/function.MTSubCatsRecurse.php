<?php
function smarty_function_MTSubCatsRecurse($args, &$ctx) {
    $localvars = array('subCatsDepth', 'category', 'subCatIsFirst', 'subCatIsLast');
    $fn = $ctx->stash('subCatTokens');
    #if (!method_exists($ctx,$fn)) {
    #    return $ctx->error("Called SubCatsRecurse outside of SubCategories tag!");
    #}

    $cat = $ctx->stash('category');

    # Get the depth info
    $max_depth = $args['max_depth'];
    $depth = $ctx->stash('subCatsDepth') or 0;

    # Get the sorting info
    $sort_method = $ctx->stash('subCatsSortMethod');
    $sort_order = $ctx->stash('subCatsSortOrder');

    $cats =& $ctx->mt->db->fetch_categories(array('blog_id' => $ctx->stash('blog_id'), 'category_id' => $cat['category_id'], 'children' => 1, 'show_empty' => 1));

    #$cats = sort_cats($ctx, $sort_method, $sort_order, $child_cats);
    if (!$cats) {
        return ''; #$ctx->error("No sub categories!");
    }

    $count = 0;
    $res = '';

    $ctx->localize($localvars);
    $ctx->stash('subCatsDepth', $depth + 1);
    while ($c = array_shift($cats)) {
        $ctx->stash('category', $c);
        $ctx->stash('subCatIsFirst', !$count);
        $ctx->stash('subCatIsLast', !count($cats));
        ob_start();
        $fn($ctx, array());
        #call_user_method($fn, $ctx, $ctx, array());
        $res .= ob_get_contents();
        ob_end_clean();
        $count++;
    }
    $ctx->restore($localvars);
    return $res;
}
?>
