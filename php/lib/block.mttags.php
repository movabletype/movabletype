<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mttags($args, $content, &$ctx, &$repeat) {
    $localvars = array(array('_tags', 'Tag', '_tags_counter', 'tag_min_count', 'tag_max_count', 'all_tag_count', 'include_blogs', 'exclude_blogs', 'blog_ids', '__out'), common_loop_vars());
    if (!isset($content)) {
        $ctx->localize($localvars);

        if (isset($args['content_type']) && isset($args['type']) && $args['type'] != 'content_type') {
            $repeat = 0;
            return $ctx->error($ctx->mt->translate(
                'content_type modifier cannot be used with type "[_1]".', $args['type'] ));
        }

        require_once('multiblog.php');
        multiblog_block_wrapper($args, $content, $ctx, $repeat);

        $ctx->stash('include_blogs', isset($args['include_blogs']) ? $args['include_blogs'] : null);
        $ctx->stash('exclude_blogs', isset($args['exclude_blogs']) ? $args['exclude_blogs'] : null);
        $ctx->stash('blog_ids', isset($args['blog_ids']) ? $args['blog_ids'] : null);
        if (!isset($args['include_blogs']) && !isset($args['exclude_blogs']) && !isset($args['blog_ids']) && !isset($args['blog_id'])) {
            $blog_id = $ctx->stash('blog_id');
            $args['blog_id'] = $ctx->stash('blog_id');
        }
        if (isset($args['top'])) {
            $post_sort_by = isset($args['sort_by']) ? $args['sort_by'] : null;
            $post_sort_order = isset($args['sort_order']) ? $args['sort_order'] : null;
            $args['sort_by'] = 'rank';
            $args['sort_order'] = 'descend';
        }
        if (isset($args['sort_by'])) {
            $s = $args['sort_by'];
            if (($s == 'rank') || ($s == 'count')) { // Aliased
                $args['sort_by'] = 'count';
                !empty($args['sort_order']) or $args['sort_order'] = 'descend'; // Inverted default
            } elseif (($s != 'name') && ($s != 'id')) {
                $args['sort_by'] = NULL;
            }
        }
        $type = 'entry';
        if (isset($args['type'])) {
            $type = strtolower($args['type']);
        } elseif (isset($args['content_type'])) {
            $type = 'content_type';
        }
        if ('page' == $type) {
            $args['class'] = 'page';
            $tags = $ctx->mt->db()->fetch_entry_tags($args);
        } elseif ('asset' == $type) {
            $tags = $ctx->mt->db()->fetch_asset_tags($args);
        } elseif ('content_type' == $type) {
            $ctypes = $ctx->mt->db()->fetch_content_types($args);
            if ($ctypes) {
                $mapper = function ($ct) { return $ct->id; };
                $args['content_type_id'] = array_map($mapper, $ctypes);
            } else {
                $repeat = 0;
                return $ctx->error($ctx->mt->translate('No Content Type could be found.'));
            }
            $tags = $ctx->mt->db()->fetch_content_tags($args);
        } else {
            $args['class'] = 'entry';
            $tags = $ctx->mt->db()->fetch_entry_tags($args);
        }
        $min = 0; $max = 0;
        $all_count = 0;
        if ($tags) {
            foreach ($tags as $tag) {
                $count = $tag->tag_count;
                if ($count > $max) $max = $count;
                if ($count < $min or $min == 0) $min = $count;
                $all_count += $count;
            }
            if (isset($args['limit'])) {
                $tags = array_slice($tags, 0, $args['limit']);
            }

            // Handle ordering based on 'top' attribute
            // implies sorting by rank/descend and limit by # requested
            // then, resort based on attributes or sane defaults
            if (isset($args['top'])) {
                $tags = array_slice($tags, 0, $args['top']);
                // now, resort by original sort order
                $post_sort_by or $post_sort_by = 'name';
                if ($post_sort_by == 'name') {
                    $post_sort_order or $post_sort_order = 'ascend';
                    require_once("MTUtil.php");
                    uasort($tags, 'tagarray_name_sort');
                    if ($post_sort_order && ($post_sort_order == 'descend')) {
                        $tags = array_reverse($tags);
                    }
                } elseif (($post_sort_by == 'rank') || ($post_sort_by == 'count')) {
                    $post_sort_order or $post_sort_order = 'descend';
                    // we're already sorted by rank; just check if
                    // order is not descending
                    if ($post_sort_order != 'descend') {
                        $tags = array_reverse($tags);
                    }
                }
            } elseif (isset($args['sort_by']) && $args['sort_by'] == 'id') {
                $fn = function($a, $b) {
                    if (intval($a->id) == intval($b->id)) {
                        return 0;
                    } elseif (intval($a->id) > intval($b->id)) {
                        return 1;
                    } else {
                        return -1;
                    }
                };
                usort($tags, $fn);
                if ( !isset($args['sort_order']) )
                    $sort_order = 'descend';
                if ($sort_order && $sort_order == 'descend')
                    $tags = array_reverse($tags);
            }
        }
        $ctx->stash('tag_min_count', $min);
        $ctx->stash('tag_max_count', $max);
        $ctx->stash('all_tag_count', $all_count);
        $ctx->stash('_tags', $tags);
        $ctx->stash('__out', false);
        $counter = 0;
    } else {
        $tags = $ctx->stash('_tags');
        $counter = $ctx->stash('_tags_counter');
        $out = $ctx->stash('__out');
    }

    if (is_array($tags) && $counter < count($tags)) {
        $tag = $tags[$counter];
        $ctx->stash('Tag', $tag);
        $ctx->stash('_tags_counter', $counter + 1);
        $repeat = true;
        if (isset($args['glue'])) {
            if (!empty($out) && !empty($content))
                $content = $args['glue'] . $content;
            if (empty($out) && !empty($content))
              $ctx->stash('__out', true);
        }
        $count = $counter + 1;
        $ctx->__stash['vars']['__counter__'] = $count;
        $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
        $ctx->__stash['vars']['__first__'] = $count == 1;
        $ctx->__stash['vars']['__last__'] = ($count == count($tags));
    } else {
        if (isset($args['glue'])) {
            if ($out && !empty($content))
                $content = $args['glue'] . $content;
        }
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
