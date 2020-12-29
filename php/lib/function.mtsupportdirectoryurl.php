<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtsupportdirectoryurl($args, &$ctx) {
    require_once "MTUtil.php";
    $url = support_directory_url();
    if (isset($args['with_domain']) && $args['with_domain'] && !preg_match("!^http!", $url)) {
        $blog = $ctx->stash('blog');
        if (!isset($blog)) {
            return $url;
        }
        $host = $blog->site_url();
        if (!preg_match("!^/!", $url)) {
            $url = '/' . $url;
        }
        if (preg_match("!(https?://[^/:]+)(:\d+)?/?!", $host, $matches)) {
            $url = $matches[1] . $url;
        }
    }
    return $url;
}
?>
