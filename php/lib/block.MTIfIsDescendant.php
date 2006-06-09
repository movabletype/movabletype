<?php
function smarty_block_MTIfIsDescendant($args, $content, &$ctx, &$repeat) {
    $localvars = array('conditional', 'else_content');
    if (!isset($content)) {
       require_once("MTUtil.php");
       $cat = get_category_context($ctx);
       $ctx->localize($localvars);
       list($parent) = $ctx->mt->db->fetch_categories(array('label' => $args['parent'], 'blog_id' => $ctx->stash('blog_id'), 'show_empty' => 1));
       if ($parent) {
           require_once("block.MTIfIsAncestor.php");
           if (!_is_ancestor($parent, $cat, $ctx))
               $parent = null;
       }
       $ctx->stash('else_content', null);
       $ctx->stash('conditional', $parent ? 1 : 0);
    } else {
       if (!$ctx->stash('conditional'))
           $content = $ctx->stash('else_content');
       $ctx->restore($localvars);
    }
    return $content;
}
?>
