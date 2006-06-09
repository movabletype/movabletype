<?php
function smarty_block_MTEntriesWithSubCategories($args, $content, &$ctx, &$repeat) {
    $localvars = array('entries');
    if (!isset($content)) {
        $cat = $args['category'];
        if (!$cat) {
            # TBD: determine category from stash when attribute isn't given
        }
        $args['include_subcategories'] = 1;
        $ctx->localize($localvars);
        $ctx->stash('entries', null);
        require_once("block.MTEntries.php");
    }
    $output = smarty_block_MTEntries($args, $content, $ctx, $repeat);
    if (!$repeat)
        $ctx->restore($localvars);
    return $output;
}
?>