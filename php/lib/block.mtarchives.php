<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_block_mtarchives($args, $content, &$ctx, &$repeat) {
    $localvars = array(array('current_archive_type', 'archive_types', 'archive_type_index', 'old_preferred_archive_type'), common_loop_vars());
    if (!isset($content)) {
        $blog = $ctx->stash('blog');
        $at = isset($args['type']) ? $args['type'] : null;
        $at or $at = isset($args['archive_type']) ? $args['archive_type'] : null;
        $at or $at = $blog->blog_archive_type;
        if (empty($at) || $at == 'None') {
            $repeat = false;
            return '';
        }
        $at = preg_split("/\s*,\s*/", $at);

        $ctx->localize($localvars);
        $ctx->stash('archive_types', $at);
        $ctx->stash('old_preferred_archive_type', $blog->blog_archive_type_preferred);
        $i = 0;
    } else {
        $at = $ctx->stash('archive_types');
        $i = $ctx->stash('archive_type_index') + 1;
        $blog = $ctx->stash('blog');
    }

    if (is_array($at) && $i < count($at)) {
        $curr_at = $at[$i];

        require_once("archive_lib.php");
        try {
            $archiver = ArchiverFactory::get_archiver($curr_at);
        } catch (Exception $e) {
            return $ctx->error($ctx->mt->translate("ArchiveType not found - [_1]", $at), E_USER_ERROR);
        }
        if ($archiver)
            $ctx->__stash['vars']['template_params'] = $archiver->get_template_params();

        $ctx->stash('current_archive_type', $curr_at);
        $ctx->stash('archive_type_index', $i);
        $counter = $i + 1;
        $ctx->__stash['vars']['__counter__'] = $counter;
        $ctx->__stash['vars']['__odd__'] = ($counter % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($counter % 2) == 0;
        $ctx->__stash['vars']['__first__'] = $counter == 1;
        $ctx->__stash['vars']['__last__'] = count($at) == $counter;
        $blog->blog_archive_type_preferred = $curr_at;
        $ctx->stash('blog', $blog);
        $repeat = true;
    } else {
        $blog->blog_archive_type_preferred = $ctx->stash('old_preferred_archive_type');
        $ctx->stash('blog', $blog);
        $ctx->restore($localvars);
        $repeat = false;
    }
    return $content;
}
?>
