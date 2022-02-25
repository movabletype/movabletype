<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

function smarty_function_mtlink($args, &$ctx) {
    // status: incomplete
    // parameters: template, entry_id
    static $_template_links = array();
    $curr_blog = $ctx->stash('blog');
    if (isset($args['template'])) {
        if (!empty($args['blog_id']))
            $blog = $ctx->mt->db()->fetch_blog($args['blog_id']);
        else
            $blog = $ctx->stash('blog');

        $name = $args['template'];
        $cache_key = $blog->id . ';' . $name;
        if (isset($_template_links[$cache_key])) {
            $link = $_template_links[$cache_key];
        } else {
            $tmpl = $ctx->mt->db()->load_index_template($ctx, $name, $blog->id);
            $site_url = $blog->site_url();
            if (!preg_match('!/$!', $site_url)) $site_url .= '/';
            $link = $site_url . $tmpl->template_outfile;
            $_template_links[$cache_key] = $link;
        }
        if (empty($args['with_index'])) {
            $link = _strip_index($link, $curr_blog);
        }
        return $link;
    } elseif (isset($args['entry_id'])) {
        $arg = array('entry_id' => $args['entry_id']);
        list($entry) = $ctx->mt->db()->fetch_entries($arg);
        $ctx->localize(array('entry'));
        $ctx->stash('entry', $entry);
        $link = $ctx->tag('EntryPermalink',$args);
        $ctx->restore(array('entry'));
        if (!empty($args['with_index']) && preg_match('/\/(#.*)$/', $link)) {
            $index = $ctx->mt->config('IndexBasename');
            $ext = $curr_blog->blog_file_extension;
            if ($ext) $ext = '.' . $ext; 
            $index .= $ext;
            $link = preg_replace('/\/(#.*)?$/', "/$index\$1", $link);
        }
        return $link;
    }
    return '';
}
?>
