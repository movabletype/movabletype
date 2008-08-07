<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once('block.mtentries.php');
function smarty_block_mtpages($args, $content, &$ctx, &$repeat) {
    $args['class'] = 'page';
    if (isset($args['include_subfolders']) &&
        $args['include_subfolders'] == 1)
    {
        $args['include_subcategories'] = 1;
    }
    if (isset($args['folder'])) {
        $args['category'] = $args['folder'];
    }

    if(isset($args['no_folder'])) {
        $folders =& $ctx->mt->db->fetch_folders(array("blog_id" => $ctx->stash('blog_id')));
        $not_folder = '';
        if (isset($folders)) {
            foreach ($folders as $folder) {
                if ($not_folder == '') {
                    $not_folder = $folder['category_label'];
                } else {
                    $not_folder = $not_folder.' OR '.$folder['category_label'];
                }
            }
        }
        if ($not_folder != '') {
            $args['category'] = "NOT ($not_folder)";
        }
    }

    $localvars = array('current_timestamp', 'current_timestamp_end', 'current_archive_type');
    $ctx->localize($localvars);
    foreach ($localvars as $localvar) {
        $ctx->__stash[$localvar] = null;
    }

    $out = smarty_block_mtentries($args, $content, $ctx, $repeat);

    $ctx->restore($localvars);

    return $out;
}
