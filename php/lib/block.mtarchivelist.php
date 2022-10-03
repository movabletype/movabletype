<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once "archive_lib.php";
function smarty_block_mtarchivelist($args, $res, &$ctx, &$repeat) {
    $localvars = array(array('current_archive_type', 'current_timestamp', 'current_timestamp_end', 'entries', 'contents', 'archive_count', '_archive_list_num', '_archive_list_results','entry','ArchiveListHeader', 'ArchiveListFooter', 'inside_archive_list', 'category', 'author', 'content_type', 'category_set'), common_loop_vars());
    if (!isset($res)) {
        $blog = $ctx->stash('blog');
        $blog_id = $blog->blog_id;
        $at = isset($args['type']) ? $args['type'] : null;
        $at or $at = isset($args['archive_type']) ? $args['archive_type'] : null;
        $at or $at = $ctx->stash('current_archive_type');
        if ($at) {  # do nothing if we have an $at
        } elseif ($blog_at = $blog->blog_archive_type_preferred) {
            $at = $blog_at;
        } elseif (empty($at)) {
            $types = explode(',', $blog->blog_archive_type);
            $at = $types[0];
        }
        if (empty($at) || $at == 'None') {
            $repeat = false;
            return '';
        }

        try {
            $ar = ArchiverFactory::get_archiver($at);
        } catch (Exception $e) {
            $repeat = false;
            return '';
        }

        $ctx->localize($localvars);

        if (isset($args['content_type'])) {
            $content_types = $ctx->mt->db()->fetch_content_types($args);
            if ($content_types) {
                $ctx->stash('content_type', $content_types[0]);
            }
        }
        if (preg_match('/^ContentType/', $at) && !$ctx->stash('content_type')) {
            $repeat = false;
            return $ctx->error(
                $ctx->mt->translate('No Content Type could be found.')
            );
        }

        $ctx->stash('current_archive_type', $at);
       if ( preg_match('/^ContentType-Category/', $at) ) {
            $maps = $ctx->mt->db()->fetch_templatemap(array(
                'blog_id' => $blog_id,
                'content_type_id' => $ctx->stash('content_type')->id,
                'preferred' => 1,
                'type' => $at,
            ));
            if (!empty($maps) && is_array($maps)) {
                $cat_field = $maps[0]->cat_field();
            }
            if (isset($cat_field)) {
                require_once('class.mt_category_set.php');
                $cs = new CategorySet();
                $cs->Load('category_set_id = ' . $cat_field->cf_related_cat_set_id);
            }
            if (!isset($cs) || !$cs->category_set_id) {
                $cs = $ctx->stash('category_set');
            } else {
                $ctx->stash('category_set', $cs);
            }
            if (!isset($cs)) {
               return $ctx->error("No Category Set could be found.");
            }
        }
        ## If we are producing a Category archive list, don't bother to
        ## handle it here--instead hand it over to <MTCategories>.
        if ($at == 'Category' || $at === 'ContentType-Category') {
            require_once("block.mtcategories.php");
            return smarty_block_mtcategories($args, isset($content) ? $content : null, $ctx, $repeat);
        }
        $args['sort'] = 'created_on';
        $args['direction'] = 'descend';
        $args['archive_type'] = $at;
        $args['blog_id'] = $blog_id;
        $archive_list_results = $ar->get_archive_list($args);
        $ctx->stash('_archive_list_results', $archive_list_results);
        # allow <MTEntries> to load them
        $ctx->stash('entries', null);
        $ctx->stash('contents', null);
        $ctx->stash('inside_archive_list',true);
        $i = 0;
    } else {
        $at = $ctx->stash('current_archive_type');
        $archive_list_results = $ctx->stash('_archive_list_results');
        $i = $ctx->stash('_archive_list_num');
    }
    if ($at == 'Category' || $at === 'ContentType-Category') {
        $res = smarty_block_mtcategories($args, $res, $ctx, $repeat);
        if (!$repeat)
            $ctx->restore($localvars);
        return $res;
    }
    if (is_array($archive_list_results) && $i < count($archive_list_results)) {
        if (empty($ar))
            $ar = ArchiverFactory::get_archiver($at);

        $grp = $archive_list_results[$i];
        $ar->prepare_list($grp);
        if ($at == 'Individual' || $at == 'Page' || $at == 'ContentType') {
            $cnt = 1;
        } else {
            $cnt = array_shift($grp);
        }
        if ($at == 'Individual' || $at == 'Page' ) {
            $entry = $ctx->stash('entry');
            $start = $end = $entry->entry_authored_on;
        }
        elseif ($at == 'ContentType') {
            $cd = $ctx->stash('content');
            $start = $end = $cd->cd_authored_on;
        } else {
            list($start, $end) = $ar->get_range($grp);
        }
        $start = preg_replace('/[^0-9]/', '', $start ?? '');
        $end = preg_replace('/[^0-9]/', '', $end ?? '');
        $ctx->stash('current_timestamp', $start);
        $ctx->stash('current_timestamp_end', $end);
        $ctx->stash('archive_count', $cnt);
        $ctx->stash('_archive_list_num', $i + 1);
        $ctx->stash('ArchiveListHeader', $i == 0);
        $ctx->stash('ArchiveListFooter', $i+1 == count($archive_list_results));
        $repeat = true;
        $count = $i + 1;
        $ctx->__stash['vars']['__counter__'] = $count;
        $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
        $ctx->__stash['vars']['__first__'] = $count == 1;
        $ctx->__stash['vars']['__last__'] = ($count == count($archive_list_results));
        $i++;
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $res;
}
?>
