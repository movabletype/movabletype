<?php
require_once "archive_lib.php";
function smarty_block_mtarchivelist($args, $content, &$ctx, &$repeat) {
    $localvars = array('current_archive_type', 'current_timestamp', 'current_timestamp_end', 'entries', 'archive_count', '_archive_list_num', '_archive_list_results','entry','ArchiveListHeader', 'ArchiveListFooter', 'inside_archive_list', 'category', 'author');
    global $_archivers;

    if (!isset($content)) {
        require_once("archive_lib.php");
        $blog = $ctx->stash('blog');
        $at = $args['type'];
        $at or $at = $args['archive_type'];
        $at or $at = $ctx->stash('current_archive_type');
        if ($at) {  # do nothing if we have an $at
        } elseif ($blog_at = $blog['blog_archive_type_preferred']) {
            $at = $blog_at;
        } elseif (empty($at)) {
            $types = explode(',', $blog['blog_archive_type']);
            $at = $types[0];
        }
        if (empty($at) || $at == 'None') {
            $repeat = false;
            return '';
        }
        if (!isset($_archivers[$at]) && $at != 'Category') {
          $repeat = false;
          return '';
        }
        $map = $ctx->mt->db->fetch_templatemap(
            array('type' => $at, 'blog_id' => $blog['blog_id']));
        if (empty($map)) {
            $repeat = false;
            return '';
        }
        $ctx->localize($localvars);
        $ctx->stash('current_archive_type', $at);
        ## If we are producing a Category archive list, don't bother to
        ## handle it here--instead hand it over to <MTCategories>.
        if ($at == 'Category') {
            require_once("block.mtcategories.php");
            return smarty_block_mtcategories($args, $content, $ctx, $repeat);
        }
        $blog_id = $blog['blog_id'];
        $args['sort'] = 'created_on';
        $args['direction'] = 'descend';
        $args['archive_type'] = $at;
        $args['blog_id'] = $blog_id;

        $archive_list_results =& $_archivers[$at]->get_archive_list($ctx, $args);
        $ctx->stash('_archive_list_results', $archive_list_results);
        # allow <MTEntries> to load them
        $ctx->stash('entries', null);
        $ctx->stash('inside_archive_list',true);
        $i = 0;
    } else {
        $at = $ctx->stash('current_archive_type');
        $archive_list_results = $ctx->stash('_archive_list_results');
        $i = $ctx->stash('_archive_list_num');
    }

    if ($at == 'Category') {
        $content = smarty_block_mtcategories($args, $content, $ctx, $repeat);
        if (!$repeat)
            $ctx->restore($localvars);
        return $content;
    }
    if ($i < count($archive_list_results)) {
        $grp = $archive_list_results[$i];
        $_archivers[$at]->prepare_list($ctx, $grp);
        if ($at == 'Individual') {
            $cnt = 1;
        } else {
            $cnt = array_shift($grp);
        }
        if ($at == 'Individual' ) {
            $entry = $ctx->stash('entry');
            $start = $end = $entry['entry_authored_on'];
        } else {
            list($start, $end) = $_archivers[$at]->get_range($ctx, $grp);
        }
        $start = preg_replace('/[^0-9]/', '', $start);
        $end = preg_replace('/[^0-9]/', '', $end);
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
    } else {
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
