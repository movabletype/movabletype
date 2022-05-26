<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtcategorysets($args, $content, &$ctx, &$repeat) {
    $localvars = array(array('_category_sets_counter', '_category_sets_glue', 'blog_id', 'blog', 'category_sets', 'category_set', 'content_type', '__out'), common_loop_vars());

    if (!isset($content)) {
        require_once("MTUtil.php");
        $blog = $ctx->stash('blog');
        $content_type = get_content_type_context($ctx, $args);

        $ctx->localize($localvars);

        $blog_id = '0';
        if (isset($args['blog_id']) && !empty($args['blog_id'])) {
            $blog_id = $args['blog_id'];
        } elseif ($blog && $blog->id) {
            $blog_id = $blog->id;
        }

        if (isset($args['id']) && !empty($args['id'])) {
            $cs = $ctx->mt->db()->fetch_category_set($args['id']);
            if (!$cs) {
                $repeat = false;
                return $ctx->error($ctx->mt->translate('No Category Set could be found.'));
            }
            $category_sets = array($cs);
        } elseif (isset($args['name']) && !empty($args['name'])) {
            $category_sets = $ctx->mt->db()->fetch_category_sets(array(
                'blog_id' => $blog_id,
                'name'    => $args['name'],
                'limit'   => 1,
            ));
            if (!$category_sets || count($category_sets) == 0) {
                $repeat = false;
                return $ctx->error($ctx->mt->translate('No Category Set could be found.'));
            }
        } else { 
            if( isset($args['content_type']) && !empty($args['content_type']) ) {
                if(!$content_type) {
                    $repeat = false;
                    return $ctx->error($ctx->mt->translate('No Content Type could be found.'));
                }
            }
            if($content_type){
                $content_fields = $content_type->fields;
                if (isset($content_fields)) {
                    $content_fields = $ctx->mt->db()->unserialize($content_fields);
                }
                foreach($content_fields as $f){
                    if ( $f['type'] == 'categories' ) {
                        $cs = $ctx->mt->db()->fetch_category_set($f['options']['category_set']);
                        if ($cs) {
                            $category_sets[] = $cs;
                        }
                    }
                }
            }
            if( !isset($category_sets) && $blog_id ){
                $category_sets = $ctx->mt->db()->fetch_category_sets(array(
                    'blog_id' => $blog_id,
                )); 
            }
        }
        $ctx->stash('category_sets', $category_sets);

        $glue = isset($args['glue']) ? $args['glue'] : null;
        $ctx->stash('_category_sets_glue', $glue);
        $ctx->stash('__out', false);
        $counter = 0;
    } else {
        $category_sets = $ctx->stash('category_sets');
        $counter = $ctx->stash('_category_sets_counter');
        $glue = $ctx->stash('_category_sets_glue');
        $out = $ctx->stash('__out');
    }

    if (is_array($category_sets) && $counter < count($category_sets)) {
        $cs = $category_sets[$counter];
        $count = $counter + 1;
        $ctx->__stash['vars']['__first__'] = $count == 1;
        $ctx->__stash['vars']['__last__'] = ($count == count($category_sets));
        $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
        $ctx->__stash['vars']['__counter__'] = $count;
        $ctx->stash('_category_sets_counter', $count);
        $ctx->stash('category_set', $cs);
        $ctx->stash('blog', $cs->blog());
        $ctx->stash('blog_id', $cs->blog_id);
        if(!empty($content_type))
            $ctx->stash('content_type', $content_type);

        if (!empty($glue) && !empty($content)) {
            if ($out) {
                $content = $glue . $content;
            } else {
                $ctx->stash('__out', true);
            }
        }
        $repeat = true;
    } else {
        if (!empty($glue) && $out && !empty($content)) {
            $content = $glue . $content;
        }
        $ctx->restore($localvars);
        $repeat = false;
    }

    return $content;
}
