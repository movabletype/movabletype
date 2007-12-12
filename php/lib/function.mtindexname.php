<?php
function smarty_function_mtindexname($args, &$ctx) {
    $tmpl = $ctx->stash('index_templates');
    $counter = $ctx->stash('index_templates_counter');
    $idx = $tmpl[$counter];
    if (!$idx) return '';
    return $idx['template_name'];
}
?>
