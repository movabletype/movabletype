<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function smarty_resource_mt_source($tpl_name, &$tpl_source, &$ctx) {
    $blog_id = $ctx->stash('blog_id');
    if (intval($tpl_name) > 0) {
        $query = "select template_text, template_modified_on, template_linked_file, template_linked_file_mtime, template_linked_file_size
            from mt_template
            where template_blog_id = $blog_id
              and template_id = $tpl_name";
    } else {
        $tpl_name = $ctx->mt->db->escape($tpl_name);
        $query = "select template_text, template_modified_on, template_linked_file, template_linked_file_mtime, template_linked_file_size
            from mt_template
            where template_blog_id = $blog_id
              and template_name='$tpl_name'";
    }
    $row = $ctx->mt->db->get_row($query, ARRAY_N);
    if (is_array($row)) {
        list($tmpl, $ts, $file, $mtime, $size) = $row;
        $file = trim($file);
        if ($file) {
            if (!file_exists($file)) {
                $blog = $ctx->stash('blog');
                $path = $blog['blog_site_path'];
                if (!preg_match('![\\/]$!', $path))
                    $path .= '/';
                $path .= $file;
                if (is_file($path) && is_readable($path))
                    $file = $path;
                else
                    $file = '';
            }
            if ($file) {
                if ((filemtime($file) > $mtime) || (filesize($file) != $size)) {
                    $contents = @file($file);
                    $tmpl = implode('', $contents);
                }
            }
        }
        $tpl_source = $tmpl;
        return true;
    } else {
        return false;
    }
}

function smarty_resource_mt_timestamp($tpl_name, &$tpl_timestamp, &$ctx) {
    #$tpl_timestamp = $ctx->stash('template_timestamp');
    #if (!$tpl_timestamp) {
        $blog = $ctx->stash('blog');
        $tpl_timestamp = datetime_to_timestamp($blog['blog_children_modified_on']);
    #}
    return true;
}

function smarty_resource_mt_secure($tpl_name, &$ctx) {
    // assume all templates are secure
    return true;
}

function smarty_resource_mt_trusted($tpl_name, &$ctx) {
    // not used for templates
}
?>
