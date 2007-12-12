<?php
function smarty_function_mtblogtemplatesetid($args, &$ctx) {
    // status: complete
    // parameters: none
    $blog = $ctx->stash('blog');
    if (!$blog) return '';
    $id = $blog['blog_template_set'];
    $id = preg_replace('/_/', '-', $id);
    return $id;
}
?>