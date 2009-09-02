<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: function.mtentryblogdescription.php 106007 2009-07-01 11:33:43Z ytakayama $

function smarty_function_mtentryblogdescription($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if ($entry->entry_blog_id) {
        $blog = $ctx->mt->db()->fetch_blog($entry->entry_blog_id);
        if ($blog) {
            return $blog->blog_description;
        }
    }
    return '';
}
?>
