<?php
function smarty_function_mtentryblogurl($args, &$ctx) {
    $entry = $ctx->stash('entry');
    if ($entry['entry_blog_id']) {
        $blog = $ctx->mt->db->fetch_blog($entry['entry_blog_id']);
        if ($blog) {
            $url = $blog['blog_site_url'];
            if (!preg_match('!/$!', $url))
                $url .= '/';
            return $url;
        }
    }
    return '';
}
?>
