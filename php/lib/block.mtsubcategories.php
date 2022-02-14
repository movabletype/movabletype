<?php
function smarty_block_mtsubcategories($args, $content, &$ctx, &$repeat) {
    $localvars = array('subCatTokens', 'subCatsSortOrder', 'subCatsSortBy', 'subCatsSortMethod', '__categories', 'inside_mt_categories', '_subcats_counter', 'entries', 'subCatIsFirst', 'subCatIsLast', 'category','current_archive_type', 'subFolderHead', 'subFolderFoot');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $token_fn = $args['token_fn'];

        $blog_id = $ctx->stash('blog_id');

        $class = 'category';
        if (isset($args['class'])) {
            $class = $args['class'];
        }

        # Do we want the current category?
        $include_current = isset($args['include_current']) ? $args['include_current'] : null;

        $top = isset($args['top']) ? $args['top'] : null;

        # Sorting information#   sort_order ::= 'ascend' | 'descend'
        #   sort_method ::= method name (e.g. package::method)
        #
        # sort_method takes precedence
        $sort_order = isset($args['sort_order']) ? $args['sort_order'] : 'ascend';
        $sort_method = isset($args['sort_method']) ? $args['sort_method'] : null;
        $sort_by = isset($args['sort_by']) ? $args['sort_by'] : 'user_custom';

        $category_set_id = 0;
        if (isset($args['category_set_id']) && $args['category_set_id']) {
            $category_set_id = $args['category_set_id'];
        }
        if (!$category_set_id && $ctx->stash('category_set')) {
            $category_set_id = $ctx->stash('category_set')->id;
        }

        # Store the tokens for recursion
        $ctx->stash('subCatTokens', $token_fn);
        $ctx->stash('current_archive_type', 'Category');

        # If we find ourselves in a category context 
        if (!$top) {
            if (!empty($args['category'])) {
                require_once("MTUtil.php");
                $current_cat = cat_path_to_category($args['category'], $blog_id, $class, $category_set_id);
                if ( is_array( $current_cat ) )
                    $current_cat = $current_cat[0];
            }
            if (!isset($current_cat)) {
                $current_cat = $ctx->stash('category') or $ctx->stash('archive_category');
            }
        }
        if (!$top && empty($args['top_level_categories']) && $current_cat) {
            if ($include_current) {
                # If we're to include it, just use it to seed the category list
                $cats = array($current_cat);
            } else {
                # Otherwise, use its children
                $cats = $ctx->mt->db()->fetch_categories(array(
                    'blog_id' => $blog_id,
                    'category_id' => $current_cat->category_id,
                    'children' => 1,
                    'show_empty' => 1,
                    'sort_order' => $sort_order,
                    'class' => $class,
                    'sort_by' => $sort_by));
            }
        }
        if (($top || !empty($args['top_level_categories'])) && empty($cats)) {
            # Otherwise, use the top level categories
            $cats = $ctx->mt->db()->fetch_categories(array(
                'blog_id' => $blog_id,
                'category_set_id' => $category_set_id,
                'top_level_categories' => 1,
                'show_empty' => 1,
                'sort_order' => $sort_order,
                'class' => $class,
                'sort_by' => $sort_by));
        }

        if (empty($cats)) {
            $ctx->restore($localvars);
            $repeat = false;
            return '';
        }

        $ctx->stash('__categories', $cats);
        # Be sure the regular MT tags know we're in a category context
        $ctx->stash('inside_mt_categories', 1);
        $ctx->stash('subCatsSortOrder', $sort_order);
        $ctx->stash('subCatsSortBy', $sort_by);
        $ctx->stash('subCatsSortMethod', $sort_method);
        $ctx->stash('_subcats_counter', 0);
        $count = 0;
    } else {
        # Init variables
        $cats = $ctx->stash('__categories');
        $count = $ctx->stash('_subcats_counter');
    }

    # Loop through the immediate children (or the current cat,
    # depending on the arguments
    if (is_array($cats) && $count < count($cats)) {
        $category = $cats[$count];
        $ctx->stash('category', $category);
        $ctx->stash('entries', null);
        $ctx->stash('subCatIsFirst', $count == 0);
        $ctx->stash('subCatIsLast', $count == (count($cats) - 1));
        $ctx->stash('subFolderHead', $count == 0);
        $ctx->stash('subFolderFoot', $count == (count($cats) - 1));
        $ctx->stash('_subcats_counter', $count + 1);
        $repeat = true;
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
