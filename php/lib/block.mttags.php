<?php
function smarty_block_mttags($args, $content, &$ctx, &$repeat) {
    $localvars = array('_tags', 'Tag', '_tags_counter', 'tag_min_count', 'tag_max_count', 'all_tag_count', 'include_blogs', 'exclude_blogs', 'blog_ids');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $ctx->stash('include_blogs', $args['include_blogs']);
        $ctx->stash('exclude_blogs', $args['exclude_blogs']);
        $ctx->stash('blog_ids', $args['blog_ids']);
        $blog_id = $ctx->stash('blog_id');
        $args['blog_id'] = $ctx->stash('blog_id');
        if (isset($args['sort_by'])) {
            $s = $args['sort_by'];
            if (($s == 'rank') || ($s == 'count')) { // Aliased
                $args['sort_by'] = 'count';
                $args['sort_order'] or $args['sort_order'] = 'descend'; // Inverted default
            } elseif (($s != 'name') && ($s != 'id')) {
                $args['sort_by'] = NULL;
            }
        }
        $type = 'entry';
        if (isset($args['type'])) {
            $type = strtolower($args['type']);
        }
        if ('page' == $type) {
            $args['class'] = 'page';
            $tags = $ctx->mt->db->fetch_entry_tags($args);
        } elseif ('asset' == $type) {
            $tags = $ctx->mt->db->fetch_asset_tags($args);
        } else {
          $args['class'] = 'entry';
            $tags = $ctx->mt->db->fetch_entry_tags($args);
        }
        $min = 0; $max = 0;
        $all_count = 0;
        if ($tags) {
            foreach ($tags as $tag) {
                $count = $tag['tag_count'];
                if ($count > $max) $max = $count;
                if ($count < $min or $min == 0) $min = $count;
                $all_count += $count;
            }
            if (isset($args['limit'])) {
                $tags = array_slice($tags, 0, $args['limit']);
            }
        }
        $ctx->stash('tag_min_count', $min);
        $ctx->stash('tag_max_count', $max);
        $ctx->stash('all_tag_count', $all_count);
        $ctx->stash('_tags', $tags);
        $counter = 0;
    } else {
        $tags = $ctx->stash('_tags');
        $counter = $ctx->stash('_tags_counter');
    }

    if ($counter < count($tags)) {
        $tag = $tags[$counter];
        $ctx->stash('Tag', $tag);
        $ctx->stash('_tags_counter', $counter + 1);
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
