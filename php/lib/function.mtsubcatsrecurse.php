<?php
# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtsubcatsrecurse($args, &$ctx) {
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

    # Get the class info
    $class = 'category';
    if (isset($args['class'])) {
        $class = $args['class'];
    }
    
    $cats =& $ctx->mt->db->fetch_categories(array('blog_id' => $ctx->stash('blog_id'), 'category_id' => $cat['category_id'], 'children' => 1, 'show_empty' => 1, 'class' => $class));

    #$cats = sort_cats($ctx, $sort_method, $sort_order, $child_cats);
    if (!$cats) {
        return ''; #$ctx->error("No sub categories!");
    }

    $count = 0;
    $res = '';

    require_once("function.mtsetvar.php");
    $ctx->localize($localvars);
    $ctx->stash('subCatsDepth', $depth + 1);
    while ($c = array_shift($cats)) {
        smarty_function_mtsetvar(array('name' => '__depth__', 'value' => ($depth + 1)), $ctx);
        $ctx->stash('category', $c);
        $ctx->stash('subCatIsFirst', !$count);
        $ctx->stash('subCatIsLast', !count($cats));
        $ctx->stash('subFolderHead', !$count);
        $ctx->stash('subFolderFoot', !count($cats));
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
