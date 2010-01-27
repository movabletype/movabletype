<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_block_mtentries($args, $content, &$ctx, &$repeat) {
    $localvars = array('entry', '_entries_counter','entries','current_timestamp','modification_timestamp','_entries_lastn', 'current_timestamp_end', 'DateHeader', 'DateFooter', '_entries_glue', 'blog', 'blog_id', 'conditional', 'else_content', '__out');
    if (isset($args['sort_by']) && $args['sort_by'] == 'score' && !isset($args['namespace'])) {
        return $ctx->error($ctx->mt->translate('sort_by="score" must be used in combination with namespace.'));
    }
    if (!isset($content)) {
        $ctx->localize($localvars);
        // If we have a set of entries that were set based on context,
        // but the user has specified attributes that effectively
        // break that context, clear the stashed entries so fetch_entries
        // can reselect.
        $this_tag = strtolower($ctx->this_tag());
        if (($this_tag == 'mtentries') || ($this_tag == 'mtpages')) {
            if ($ctx->stash('entries') &&
                (isset($args['category']) || isset($args['categories']) ||
                 isset($args['tag']) || isset($args['tags']) ||
                 isset($args['author']) ))
                $ctx->__stash['entries'] = null;
        }
        if ($ctx->__stash['entries'] &&
            (isset($args['id']) ||
             isset($args['recently_commented_on']) ||
             isset($args['include_subcategories']) ||
             isset($args['days']) ))
            $ctx->__stash['entries'] = null;
        $counter = 0;
        $lastn = $args['lastn'];
        $ctx->stash('_entries_lastn', $lastn);
        $ctx->stash('__out', false);
    } else {
        $lastn = $ctx->stash('_entries_lastn');
        $counter = $ctx->stash('_entries_counter');
        $out = $ctx->stash('__out');
    }
    if (!isset($args['class'])) {
        $args['class'] = 'entry';
    }

    if ( isset($args['offset']) && ($args['offset'] == 'auto') ) {
        $l = 0;
        if ( $args['limit'] ) {
            if ( $args['limit'] == 'auto' ) {
                if ( $_REQUEST['limit'] )
                    $l = $_REQUEST['limit'];
                else {
                    $blog_id = intval($ctx->stash('blog_id'));
                    $blog = $ctx->mt->db()->fetch_blog($blog_id);
                    $l = $blog->blog_entries_on_index;
                }
            }
            else
                $l = $args['limit'];
        }
        if ( !$l )
            $l = 20;
        $ctx->stash('__pager_limit', $l);
        if ( $_REQUEST['offset'] )
            $ctx->stash('__pager_offset', $_REQUEST['offset']);
    }

    $entries = $ctx->stash('entries');

    if (!isset($entries)) {
        require_once('archive_lib.php');
        $at = $ctx->stash('current_archive_type');
        $archiver = ArchiverFactory::get_archiver($at);
        $args['blog_id'] = $ctx->stash('blog_id');
        if (isset($args['id'])) {
            $args['entry_id'] = $args['id'];
        }
        $ts = $ctx->stash('current_timestamp');
        $tse = $ctx->stash('current_timestamp_end');
        if ($ts && $tse) {
            # assign date range if we have both
            # start and end date
            $args['current_timestamp'] = $ts;
            $args['current_timestamp_end'] = $tse;
        }
        if (isset($archiver)) {
            ($args['limit'] || $args['lastn']) or $args['lastn'] = -1;
            $archiver->setup_args($args);
        }
        $cat = $ctx->stash('category');
        if (isset($cat) && (($args['class'] == 'entry' && $cat->category_class == 'category') || ($args['class'] == 'page' && $cat->category_class == 'folder'))) {
            $args['category'] or $args['categories'] or $args['category_id'] = $cat->category_id;
            if ($ctx->stash('inside_mt_categories')) {
                $args['category_id'] = $cat->category_id;
                $args['show_empty'] = $ctx->stash('show_empty');
            } else {
                $args['category'] or $args['categories'] or $args['category_id'] = $cat->category_id;
            }
        }

        if ($tag = $ctx->stash('Tag')) {
            $args['tag'] or $args['tags'] or $args['tags'] = is_object($tag) ? $tag->tag_name : $tag;
        }
        if ( isset($args['offset']) && ($args['offset'] == 'auto') )
            $total_count = 0;
        $entries = $ctx->mt->db()->fetch_entries($args, $total_count);
        if ( isset($args['offset']) && ($args['offset'] == 'auto') )
            $ctx->stash('__pager_total_count', $total_count);
        $ctx->stash('entries', $entries);
    }

    $ctx->stash('conditional', empty($entries) ? 0 : 1);
    if (empty($entries)) {
        $ret = $ctx->_hdlr_if($args, $content, $ctx, $repeat, 0);
        if (!$repeat)
              $ctx->restore($localvars);
        return $ret;
    }

    $ctx->stash('_entries_glue', $args['glue']);
    if (($lastn > count($entries)) || ($lastn == -1)) {
        $lastn = count($entries);
        $ctx->stash('_entries_lastn', $lastn);
    }

    if ($lastn ? ($counter < $lastn) : ($counter < count($entries))) {
        $blog_id = $ctx->stash('blog_id');
        $entry = $entries[$counter];
        if (!empty($entry)) {
            if ($blog_id != $entry->entry_blog_id) {
                $blog_id = $entry->entry_blog_id;
                $ctx->stash('blog_id', $blog_id);
                $ctx->stash('blog', $entry->blog());
            }
            if ($counter > 0) {
                $last_entry_created_on = $entries[$counter-1]->entry_authored_on;
            } else {
                $last_entry_created_on = '';
            }
            if ($counter < count($entries)-1) {
                $next_entry_created_on = $entries[$counter+1]->entry_authored_on;
            } else {
                $next_entry_created_on = '';
            }
            $ctx->stash('DateHeader', !(substr($entry->entry_authored_on, 0, 8) == substr($last_entry_created_on, 0, 8)));
            $ctx->stash('DateFooter', (substr($entry->entry_authored_on, 0, 8) != substr($next_entry_created_on, 0, 8)));
            $ctx->stash('entry', $entry);
            $ctx->stash('current_timestamp', $entry->entry_authored_on);
            $ctx->stash('current_timestamp_end', null);
            $ctx->stash('modification_timestamp', $entry->entry_modified_on);
            $ctx->stash('_entries_counter', $counter + 1);
            $_REQUEST['entry_ids_published'][$entry->entry_id] = 1;
            $glue = $ctx->stash('_entries_glue');
            if (isset($glue) && !empty($content)) {
                if ($out)
                    $content = $glue . $content;
                else
                    $ctx->stash('__out', true);
            }
            $count = $counter + 1;
            $ctx->__stash['vars']['__counter__'] = $count;
            $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
            $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
            $ctx->__stash['vars']['__first__'] = $count == 1;
            $ctx->__stash['vars']['__last__'] = ($count == count($entries));
            $repeat = true;
        }
    } else {
        $glue = $ctx->stash('_entries_glue');
        if (isset($glue) && $out && !empty($content))
            $content = $glue . $content;
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
