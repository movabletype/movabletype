<?php
# Movable Type (r) (C) 2001-2016 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtusersessioncookiedomain($args, &$_smarty_tpl) {
    $ctx =& $_smarty_tpl->smarty;
    $domain = $ctx->mt->config('UserSessionCookieDomain');
    if ($domain == '<$MTBlogHost exclude_port="1"$>') {
        # optimize for the default case
        $blog = $ctx->stash('blog');
        $host = $blog->site_url();
        if (preg_match('!^https?://([^/:]+)/!', $host, $matches)) {
            $domain = $matches[1];
        }
    } else {
        if (preg_match('/<\$?mt/i', $domain)) {
            # evaluate expression

            $_var_compiled = $ctx->fetch("eval:$domain");
            if (!$_var_compiled) {
                $domain = htmlentities($domain);
                return $ctx->error("Error in expression for UserSessionCookieDomain: '$domain'");
            }

            ob_start();
            eval('?>' . $_var_compiled);
            $domain = ob_get_contents();
            ob_end_clean();
        } else {
            # no further modifications for an explictly
            # configured value
            return $domain;
        }
    }
    $domain = preg_replace('/^www\./', '', $domain);
    if (! preg_match('/^\./', $domain))
        $domain = '.' . $domain;
    return $domain;
}
?>
