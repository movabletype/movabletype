<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_function_mtlink($args, &$ctx) {
    // status: incomplete
    // parameters: template, entry_id
    static $_template_links = array();
    if (isset($args['template'])) {
        $name = $args['template'];
        $cache_key = $ctx->__stash['blog_id'] . ';' . $name;
        if (isset($_template_links[$cache_key])) {
            $link = $_template_links[$cache_key];
        } else {
            $tmpl = $ctx->mt->db()->load_index_template($ctx, $name);
            $blog = $ctx->stash('blog');
            $site_url = $blog->site_url();
            if (!preg_match('!/$!', $site_url)) $site_url .= '/';
            $link = $site_url . $tmpl->template_outfile;
            $_template_links[$cache_key] = $link;
        }
        if (!$args['with_index']) {
            $link = _strip_index($link, $blog);
        }
        return $link;
    } elseif (isset($args['entry_id'])) {
        $arg = array('entry_id' => $args['entry_id']);
        list($entry) = $ctx->mt->db()->fetch_entries($arg);
        $ctx->localize(array('entry'));
        $ctx->stash('entry', $entry);
        $link = $ctx->tag('EntryPermalink',$args);
        $ctx->restore(array('entry'));
        if ($args['with_index'] && preg_match('/\/(#.*)$/', $link)) {
            $blog = $ctx->stash('blog');
            $index = $ctx->mt->config('IndexBasename');
            $ext = $blog->blog_file_extension;
            if ($ext) $ext = '.' . $ext; 
            $index .= $ext;
            $link = preg_replace('/\/(#.*)?$/', "/$index\$1", $link);
        }
        return $link;
    }
    return '';
}
