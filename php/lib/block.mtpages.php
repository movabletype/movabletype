<?php
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

    return smarty_block_mtentries($args, $content, $ctx, $repeat);
}
?>
