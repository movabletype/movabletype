<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtentryblogurl.php 107171 2009-07-19 16:09:46Z ytakayama $

function smarty_function_mtentryblogurl($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if ($entry->entry_blog_id) {
        $blog = $ctx->mt->db()->fetch_blog($entry->entry_blog_id);
        if ($blog) {
            $url = $blog->site_url();
            if (!preg_match('!/$!', $url))
                $url .= '/';
            return $url;
        }
    }
    return '';
}
?>
