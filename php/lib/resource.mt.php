<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
class smarty_resource_mt extends Smarty_Resource_Custom {
    protected $ctx;
    protected $mt;
    public function __construct() {
        $this->mt = MT::get_instance();
        $this->ctx =& $this->mt->context();
    }

    /**
     * Fetch a template and its modification time from database
     *
     * @param  string  $name   template name
     * @param  string  $source template source
     * @param  integer $mtime  template modification timestamp (epoch)
     *
     * @return void
     */
    protected function fetch($tpl_name, &$tpl_source, &$mtime) {
        $blog_id = $this->ctx->stash('blog_id');
        if (intval($tpl_name) > 0) {
            $query = "template_blog_id = $blog_id
                      and template_id = $tpl_name";
        } else {
            $tpl_name = $this->mt->db()->escape($tpl_name);
            $query = "template_blog_id = $blog_id
                      and template_name='$tpl_name'";
        }

        require_once('class.mt_template.php');
        $tmpl = new Template();
        $tmpls = $tmpl->Find($query);
        if (!empty($tmpls)) {
            $tmpl = $tmpls[0];
            $file = trim($tmpl->linked_file);
            $text = $tmpl->text;
            $blog = $this->ctx->stash('blog');
            $mtime = datetime_to_timestamp($blog->blog_children_modified_on);
            if ($file) {
                if (!file_exists($file)) {
                    $path = $blog->site_path();
                    if (!preg_match('![\\/]$!', $path))
                        $path .= '/';
                    $path .= $file;
                    if (is_file($path) && is_readable($path))
                        $file = $path;
                    else
                        $file = '';
                }
                if ($file) {
                    $mtime = $tmpl->linked_file_mtime;
                    $size = $tmpl->linked_file_size;
                    if ((filemtime($file) > $mtime) || (filesize($file) != $size)) {
                        $contents = @file($file);
                        $text = implode('', $contents);
                    }
                }
            }
            $tpl_source = $text;
            return true;
        } else {
            $mtime = null;
            $tpl_source = null;
            return false;
        }
    }

    /**
     * Fetch a template's modification time from database
     *
     * @note implementing this method is optional. Only implement it if modification times can be accessed faster than loading the comple template source.
     *
     * @param  string $name template name
     *
     * @return integer timestamp (epoch) the template was modified
     */
    protected function fetchTimestamp($name) {
        require_once('MTUtil.php');
        $blog = $this->ctx->stash('blog');

        return datetime_to_timestamp($blog->blog_children_modified_on);
    }
}


?>
