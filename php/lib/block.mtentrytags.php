<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtentrytags($args, $content, &$ctx, &$repeat) {
    $localvars = array('_tags', 'Tag', '_tags_counter', 'tag_min_count', 'tag_max_count','all_tag_count', '__out', 'class_type');
    if (!isset($content)) {
        $class = 'entry';
        if (isset($args['class'])) {
            $class = $args['class'];
        }
        $ctx->localize($localvars);
        require_once("MTUtil.php");
        $entry = $ctx->stash('entry');
        $blog_id = $entry['entry_blog_id'];
        $tags = $ctx->mt->db->fetch_entry_tags(array('blog_id' => $blog_id, 'class' => $class));
        if (!is_array($tags)) $tags = array();

        $min = 0; $max = 0;
        $all_count = 0;
        $tagnames = '';
        foreach ($tags as $tag) {
            $count = $tag['tag_count'];
            if ($count > $max) $max = $count;
            if ($count < $min or $min == 0) $min = $count;
            $all_count += $count;
        }
        $ctx->stash('tag_min_count', $min);
        $ctx->stash('tag_max_count', $max);
        $ctx->stash('all_tag_count', $all_count);

        $entry = $ctx->stash('entry');
        $tags = $ctx->mt->db->fetch_entry_tags(array('entry_id' => $entry['entry_id'], 'blog_id' => $blog_id, 'class' => $class));
        if (!is_array($tags)) $tags = array();
        $ctx->stash('_tags', $tags);
        $ctx->stash('__out', false);
        $ctx->stash('class_type', $class);

        $counter = 0;
        if (!count($tags)) {
            $ctx->restore($localvars);
            $repeat = false;
            return;
        }
    } else {
        $tags = $ctx->stash('_tags');
        $counter = $ctx->stash('_tags_counter');
        $out = $ctx->stash('__out');
    }
    if ($counter < count($tags)) {
        $tag = $tags[$counter];
        $ctx->stash('Tag', $tag);
        $ctx->stash('_tags_counter', $counter + 1);
        $repeat = true;
        if (isset($args['glue']) && !empty($content)) {
            if ($out)
                $content = $args['glue']. $content;
            else
                $ctx->stash('__out', true);
        }
    } else {
        if (isset($args['glue']) && $out && !empty($content))
            $content = $args['glue']. $content;
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
