<?php
function smarty_block_mtentries($args, $content, &$ctx, &$repeat) {
    $localvars = array('entry', '_entries_counter','entries','current_timestamp','modification_timestamp','_entries_lastn', 'current_timestamp_end', 'DateHeader', 'DateFooter', '_entries_glue', 'blog', 'blog_id');
    if (isset($args['sort_by']) && $args['sort_by'] == 'score' && !isset($args['namespace'])) {
        return $ctx->error($ctx->mt->translate('sort_by="score" must be used in combination with namespace.'));
    }
    if (!isset($content)) {
        $ctx->localize($localvars);
        // If we have a set of entries that were set based on context,
        // but the user has specified attributes that effectively
        // break that context, clear the stashed entries so fetch_entries
        // can reselect.
        if ($ctx->stash('entries') &&
            (isset($args['category']) || isset($args['categories']) ||
             isset($args['tag']) || isset($args['tags']) ||
             isset($args['id']) ||
             isset($args['author']) ||
             isset($args['recently_commented_on']) ||
             isset($args['include_subcategories']) ||
             isset($args['days']) ))
            $ctx->__stash['entries'] = null;
        $counter = 0;
        $lastn = $args['lastn'];
        $ctx->stash('_entries_lastn', $lastn);
    } else {
        $lastn = $ctx->stash('_entries_lastn');
        $counter = $ctx->stash('_entries_counter');
    }
    if (!isset($args['class'])) {
        $args['class'] = 'entry';
    }

    $entries = $ctx->stash('entries');
    if (!isset($entries)) {
        global $_archivers;
        if (!isset($_archivers)) {
            require_once('archive_lib.php');
        }
        $at = $ctx->stash('current_archive_type');
        $archiver = $_archivers[$at];
        $args['blog_id'] = $ctx->stash('blog_id');
        if (isset($args['id'])) {
            $args['entry_id'] = $args['id'];
        }
        if (isset($archiver)) {
            ($args['limit'] || $args['lastn']) or $args['lastn'] = -1;
            $ts = $ctx->stash('current_timestamp');
            $tse = $ctx->stash('current_timestamp_end');
            if ($ts && $tse) {
                # assign date range if we have both
                # start and end date
                $args['current_timestamp'] = $ts;
                $args['current_timestamp_end'] = $tse;
            }
            $archiver->setup_args($ctx, $args);
        }
        if (($cat = $ctx->stash('category')) && $args['class'] == 'entry') {
            $args['category'] or $args['categories'] or $args['category_id'] = $cat['category_id'];
            if ($ctx->stash('inside_mt_categories')) {
                $args['category_id'] = $cat['category_id'];
                $args['show_empty'] = $ctx->stash('show_empty');
            } else {
                $args['category'] or $args['categories'] or $args['category_id'] = $cat['category_id'];
            }
        }

        if ($tag = $ctx->stash('Tag')) {
            $args['tag'] or $args['tags'] or $args['tags'] = is_array($tag) ? $tag['tag_name'] : $tag;
        }
        $entries =& $ctx->mt->db->fetch_entries($args);
        $ctx->stash('entries', $entries);
    }
    $ctx->stash('_entries_glue', $args['glue']);
    if (($lastn > count($entries)) || ($lastn == -1)) {
        $lastn = count($entries);
        $ctx->stash('_entries_lastn', $lastn);
    }
    if ($lastn ? ($counter < $lastn) : ($counter < count($entries))) {
        $blog_id = $ctx->stash('blog_id');
        $entry = $entries[$counter];
        if ($blog_id != $entry['entry_blog_id']) {
            $blog_id = $entry['entry_blog_id'];
            $ctx->stash('blog_id', $blog_id);
            $ctx->stash('blog', $ctx->mt->db->fetch_blog($blog_id));
        }
        if ($counter > 0) {
            $last_entry_created_on = $entries[$counter-1]['entry_authored_on'];
        } else {
            $last_entry_created_on = '';
        }
        if ($counter < count($entries)-1) {
            $next_entry_created_on = $entries[$counter+1]['entry_authored_on'];
        } else {
            $next_entry_created_on = '';
        }
        $ctx->stash('DateHeader', !(substr($entry['entry_authored_on'], 0, 8) == substr($last_entry_created_on, 0, 8)));
        $ctx->stash('DateFooter', (substr($entry['entry_authored_on'], 0, 8) != substr($next_entry_created_on, 0, 8)));
        $ctx->stash('entry', $entry);
        $ctx->stash('current_timestamp', $entry['entry_authored_on']);
        $ctx->stash('current_timestamp_end', null);
        $ctx->stash('modification_timestamp', $entry['entry_modified_on']);
        $ctx->stash('_entries_counter', $counter + 1);
        $_REQUEST['entry_ids_published'][$entry['entry_id']] = 1;
        $glue = $ctx->stash('_entries_glue');
        if ($glue != '') $content = $content . $glue;
        $repeat = true;
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
