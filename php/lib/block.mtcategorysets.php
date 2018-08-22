<?php
# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtcategorysets($args, $content, &$ctx, &$repeat) {
    $localvars = array(array('_category_sets_counter', '_category_sets_glue', 'blog_id', 'blog', 'category_sets', 'category_set', 'content_type', '__out'), common_loop_vars());

    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $content_type = $ctx->stash('content_type');

        $ctx->localize($localvars);

        $blog_id = '0';
        if (isset($args['blog_id']) && !empty($args['blog_id'])) {
            $blog_id = $args['blog_id'];
        } elseif ($blog && $blog->id) {
            $blog_id = $blog->id;
        }

        if (isset($args['id']) && !empty($args['id'])) {
            $cs = $ctx->mt->db()->fetch_category_set($args['id']);
            if (!cs) {
                return $ctx->error('No Category set could be found.');
            }
            $category_sets = array($cs);
        } elseif (isset($args['name']) && !empty($args['name'])) {
            $category_sets = $ctx->mt->db()->fetch_category_sets(array(
                'blog_id' => $blog_id,
                'name'    => $args['name'],
                'limit'   => 1,
            ));
            if ($cs && count($cs) == 0) {
                return $ctx->error('No Category set could be found.');
            }
        } else {
            $content_types = $ctx->mt->db()->fetch_content_types($args);
            if ($content_types) {
                $category_sets = $ctx->mt->db()->fetch_category_sets(array(
                    'blog_id' => $blog_id,
                    'content_type' => $args['content_type'],
                ));
                if ($cs && count($cs) == 0) {
                    return $ctx->error('No Category set could be found.');
                }
            } else {
                if ($blog_id) {
                    $category_sets = $ctx->mt->db()->fetch_category_sets(array(
                        'blog_id' => $blog_id
                    ));
                }
            }
        }
        $ctx->stash('category_sets', $category_sets);

        $glue = $args['glue'];
        $ctx->stash('_category_sets_glue', $glue);
        $ctx->stash('__out', false);
        $counter = 0;
    } else {
        $category_sets = $ctx->stash('category_sets');
        $counter = $ctx->stash('_category_sets_counter');
        $glue = $ctx->stash('_category_sets_glue');
        $out = $ctx->stash('__out');
    }

    if ($counter < count($category_sets)) {
        $cs = $category_sets[$counter];
        $count = $counter + 1;
        $ctx->__stash['vars']['__first__'] = $count == 1;
        $ctx->__stash['vars']['__last__'] = ($count == count($categories));
        $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
        $ctx->__stash['vars']['__counter__'] = $count;
        $ctx->stash('_category_sets_counter', $count);
        $ctx->stash('category_set', $cs);
        $ctx->stash('blog', $cs->blog());
        $ctx->stash('blog_id', $cs->blog_id);
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

