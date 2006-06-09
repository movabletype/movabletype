<?php
# Quick and dirty dynamic statwatch tag

global $mt;
$ctx = &$mt->context();

$ctx->register_function('MTStats', 'mtstats');

# Build stat tracking javascript
function mtstats($args, &$ctx) {
    $cgipath = $ctx->tag('CGIPath');
    $blog = $ctx->stash('blog');

    $script = "<script type=\"text/javascript\">
              "."<!-- 
              "."document.write('<img src=\"".$cgipath."plugins/statwatch/statvisit.cgi?blog_id=".$blog["blog_id"]."&amp;refer=' + escape(document.referrer) + '&amp;url=' + escape(location.href) + '\" width=\"1\" height=\"1\" alt=\"\" /> ');
              "."// -->
              "."</script>";
   return $script;
}

?>