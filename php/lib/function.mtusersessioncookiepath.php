<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtusersessioncookiepath($args, &$ctx) {
    $path = $ctx->mt->config('UserSessionCookiePath');
    if ($path == 'DEFAULT') {
        if ($ctx->mt->config('SingleCommunity')) {
            $path = '/';
        } else {
            $path = '<$MTBlogRelativeURL$>';
        }
    }
    if ($path == '<$MTBlogRelativeURL$>') {
        # optimize for the default case
        $blog = $ctx->stash('blog');
        $host = $blog->site_url();
        if (!preg_match('!/$!', $host))
            $host .= '/';
        if (preg_match('!^https?://[^/]+(/.*)$!', $host, $matches))
            return $matches[1];
    } else {
        if (preg_match('/<\$?mt/i', $path)) {
            # evaluate expression

            if (!$ctx->_compile_source('evaluated template', $path, $_var_compiled)) {
                $path = htmlentities($path);
                return $ctx->error("Error in expression for UserSessionCookiePath: '$path'");
            }

            ob_start();
            $ctx->_eval('?>' . $_var_compiled);
            $path = ob_get_contents();
            ob_end_clean();

            return $path;
        } else {
            return $path;
        }
    }
    return '';
}
?>
