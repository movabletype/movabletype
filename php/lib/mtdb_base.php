<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

class MTDatabaseBase extends ezsql {
    var $savedqueries = array();
    var $_entry_id_cache = array();
    var $_author_id_cache = array();
    var $_comment_count_cache = array();
    var $_ping_count_cache = array();
    var $_cat_id_cache = array();
    var $_tag_id_cache = array();
    var $_blog_id_cache = array();
    var $_entry_link_cache = array();
    var $_cat_link_cache = array();
    var $_archive_link_cache = array();
    var $_entry_tag_cache = array();
    var $_blog_tag_cache = array();
    var $_asset_tag_cache = array();
    var $_blog_asset_tag_cache = array();
    var $serializer;
    var $id;

    ## temporary until we class our objects properly
    var $object_meta = array(
        'blog' => array(
            'commenter_authenticators:vchar',
            'nofollow_urls:vinteger',
            'follow_auth_links:vinteger',
            'captcha_provider:vchar',
            'template_set:vchar',
            'page_layout:vchar',
            'include_system:vinteger',
            'include_cache:vinteger'),
        'template' => array(
            'page_layout:vchar',
            'include_with_ssi:vinteger',
            'cache_expire_type:vinteger',
            'cache_expire_interval:vinteger',
            'cache_expire_event:vchar'),
        'asset' => array('image_width:vinteger',
            'image_height:vinteger')
    );
    var $_meta_cache = array();

    function MTDatabaseBase($dbuser, $dbpassword = '', $dbname = '',
        $dbhost = '', $dbport = '', $dbsocket = '') {
        $this->id = md5(uniqid('MTDatabaseBase',true));
        $this->hide_errors();
        $this->db($dbuser, $dbpassword, $dbname, $dbhost, $dbport, $dbsocket);
    }

    function unserialize($data) {
        if (!$this->serializer) {
            require_once("MTSerialize.php");
            $this->serializer =& new MTSerialize();
        }
        return $this->serializer->unserialize($data);
    }

    function query($query) {
        $this->savedqueries[] = $query;
        parent::query($query);
    }

    function &resolve_url($path, $blog_id) {
        $path = preg_replace('!/$!', '', $path);
        $path = $this->escape($path);
        $blog_id = intval($blog_id);
        # resolve for $path -- one of:
        #      /path/to/file.html
        #      /path/to/index.html
        #      /path/to/
        #      /path/to
        global $mt;
        $index = $this->escape($mt->config('IndexBasename'));
        $escindex = $this->escape($index);
        foreach ( array($path, urldecode($path), urlencode($path)) as $p ) {
            $sql = "
                select *
                  from mt_blog, mt_template, mt_fileinfo
                  left outer join mt_templatemap on templatemap_id = fileinfo_templatemap_id
                 where fileinfo_blog_id = $blog_id
                       and ((fileinfo_url = '%1\$s' or fileinfo_url = '%1\$s/') or (fileinfo_url like '%1\$s/$escindex%%'))
                   and blog_id = fileinfo_blog_id
                   and template_id = fileinfo_template_id
                 order by length(fileinfo_url) asc
            ";
            $rows = $this->get_results(sprintf($sql,$p), ARRAY_A);
            if ($rows) {
                break;
            }
        }
        $path = $p;
        if (!$rows) return null;

        $found = false;
        foreach ($rows as $row) {
            $fiurl = $row['fileinfo_url'];
            if ($fiurl == $path) {
                $found = true;
                break;
            }
            if ($fiurl == "$path/") {
                $found = true;
                break;
            }
            $ext = $row['blog_file_extension'];
            if (!empty($ext)) $ext = '.' . $ext;
            if ($fiurl == ($path.'/'.$index.$ext)) {
                $found = true; break;
            }
            if ($found) break;
        }
        if (!$found) return null;
        $data = array();
        foreach ($row as $key => $value) {
            if (preg_match('/^([a-z]+)/', $key, $matches)) {
                $data[$matches[1]][$key] = $value;
            }
        }
        $this->_blog_id_cache[$data['blog']['blog_id']] =& $data['blog'];
        return $data;
    }

    function fetch_blogs($args) {
        if ($blog_ids = $this->include_exclude_blogs($args)) {
            $where = ' where blog_id ' . $blog_ids;
        }
        $sql = 'select * from mt_blog'
            . $where . ' order by blog_name';
        $res = $this->get_results($sql, ARRAY_A);
        return $res;
    }

    function fetch_templates($args) {
        if (isset($args['type'])) {
            $type_filter = 'and template_type = \'' . $this->escape($args['type']) . '\'';
        }
        if (isset($args['blog_id'])) {
            $blog_filter = 'and template_blog_id = ' . intval($args['blog_id']);
        }
        $sql = "select *
                  from mt_template
                 where 1 = 1
                       $blog_filter
                       $type_filter
              order by template_name";
        $result = $this->get_results($sql, ARRAY_A);
        return $result;
    }

    function fetch_templatemap($args) {
        if (isset($args['type'])) {
            $type_filter = 'and templatemap_archive_type = \'' . $this->escape($args['type']) . '\'';
        }
        if (isset($args['blog_id'])) {
            $blog_filter = 'and templatemap_blog_id = ' . intval($args['blog_id']);
        }
        $sql = "select *
                  from mt_templatemap
                 where 1 = 1
                       $blog_filter
                       $type_filter
              order by templatemap_archive_type";
        $result = $this->get_results($sql, ARRAY_A);
        return $result;
    }

    function fetch_template_meta($type, $name, $blog_id, $global) {
        if ($type === 'identifier') {
            $col = 'template_identifier';
            $type_filter = "";
        } else {
            $col = 'template_name';
            $type_filter = "and template_type='$type'";
        }
        if (!isset($global)) {
            $blog_filter = "and template_blog_id in (".$this->escape($blog_id).",0)";
        } elseif ($global) {
            $blog_filter = "and template_blog_id=0";
        } else {
            $blog_filter = "and template_blog_id=".$this->escape($blog_id);
        }

        $tmpl_name = $this->escape($name);

        $sql = "
            select
                template_id, template_name, template_modified_on
            from
                mt_template
            where
                $col = '$tmpl_name'
                $blog_filter
                $type_filter
            order by
                template_blog_id desc";
        $row = $this->get_row($sql, ARRAY_A);
        if (!$row) return '';

        $data = $this->get_meta('template', $row['template_id']);
        return array_merge($row, $data);
    }

    function load_index_template(&$ctx, $tmpl, $blog_id = null) {
        return $this->load_special_template($ctx, $tmpl, 'index');
    }

    function load_special_template(&$ctx, $tmpl, $type, $blog_id = null) {
        $blog_id or $blog_id = $ctx->stash('blog_id');
        $tmpl_name = $this->escape($tmpl);
        $sql = "select * from mt_template" .
            " where template_blog_id=$blog_id ".
            ($tmpl ? " and (template_name='". $tmpl_name . "'" .
            " or template_outfile='" . $tmpl_name ."'" .
            " or template_identifier='" . $tmpl_name . "')" : "").
            " and template_type='".$this->escape($type)."'";
        list($row) = $this->get_results($sql, ARRAY_A);
        if (!$row) return null;
        return $row;
    }

    function fetch_config() {
        $sql = "select * from mt_config";
        list($row) = $this->get_results($sql, ARRAY_A);
        if (!$row) return null;
        return $row;
    }

    function category_link($cid, $args = null) {
        if (isset($this->_cat_link_cache[$cid])) {
            $url = $this->_cat_link_cache[$cid];
        } else {
            $sql = "select fileinfo_url, fileinfo_blog_id
                      from mt_fileinfo, mt_templatemap
                     where fileinfo_category_id = $cid
                       and fileinfo_archive_type = 'Category'
                       and templatemap_id = fileinfo_templatemap_id
                       and templatemap_is_preferred = 1";
            $rows = $this->get_results($sql, ARRAY_A);
            if (count($rows)) {
                $link =& $rows[0];
            } else {
                return null;
            }
            $blog =& $this->fetch_blog($link['fileinfo_blog_id']);
            $blog_url = $blog['blog_archive_url'];
            $blog_url or $blog_url = $blog['blog_site_url'];
            $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
            $url = $blog_url . $link['fileinfo_url'];
            $url = _strip_index($url, $blog);
            $this->_cat_link_cache[$cid] = $url;
        }
        return $url;
    }

    function archive_link($ts, $at, $sql, $args) {
        $blog_id = intval($args['blog_id']);
        if (isset($this->_archive_link_cache[$blog_id.';'.$ts.';'.$at])) {
            $url = $this->_archive_link_cache[$blog_id.';'.$ts.';'.$at];
        } else {
            if ($sql == '') {
                $sql = "select fileinfo_url
                          from mt_fileinfo, mt_templatemap
                         where fileinfo_startdate = '$ts'
                           and fileinfo_blog_id = $blog_id
                           and fileinfo_archive_type = '".$this->escape($at)."'
                           and templatemap_id = fileinfo_templatemap_id
                           and templatemap_is_preferred = 1";
            }
            $rows = $this->get_results($sql, ARRAY_A);
            if (count($rows)) {
                $link =& $rows[0];
            } else {
                return null;
            }
            $blog =& $this->fetch_blog($blog_id);
            if ($at == 'Page') {
                $blog_url = $blog['blog_site_url'];
            } else {
                $blog_url = $blog['blog_archive_url'];
                $blog_url or $blog_url = $blog['blog_site_url'];
            }
            $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
            $url = $blog_url . $link['fileinfo_url'];
            $url = _strip_index($url, $blog);
            $this->_archive_link_cache[$ts.';'.$at] = $url;
        }
        return $url;
    }

    function entry_link($eid, $at = "Individual", $args = null) {
        $blog_id = intval($args['blog_id']);
        if (isset($this->_entry_link_cache[$eid.';'.$at])) {
            $url = $this->_entry_link_cache[$eid.';'.$at];
        } else {
            if (preg_match('/Category/', $at)) {
                $table = ", mt_placement";
                $filter = "and placement_entry_id = $eid
                           and fileinfo_category_id = placement_category_id
                           and placement_is_primary = 1";
            }
            if (preg_match('/Page/', $at)) {
                $entry = $this->fetch_page($eid);
            } else {
                $entry = $this->fetch_entry($eid);
            }
            $ts = $entry['entry_authored_on'];
            if (preg_match('/Monthly$/', $at)) {
                $ts = substr($ts, 0, 6) . '01000000';
            } elseif (preg_match('/Daily$/', $at)) {
                $ts = substr($ts, 0, 8) . '000000';
            } elseif (preg_match('/Weekly$/', $at)) {
                require_once("MTUtil.php");
                list($ws, $we) = start_end_week($ts);
                $ts = $ws;
            } elseif (preg_match('/Yearly$/', $at)) {
                $ts = substr($ts, 0, 4) . '0101000000';
            } elseif ($at == 'Individual' || $at == 'Page') {
                $filter .= "and fileinfo_entry_id = $eid";
            }
            if ($ts != $entry['entry_authored_on']) {
                $filter .= " and fileinfo_startdate = '$ts'";
            }
            if (preg_match('/Author/', $at)) {
                $filter .= " and fileinfo_author_id = ". $entry['entry_author_id'];
            }
            $sql = "select fileinfo_url, fileinfo_blog_id
                     from mt_fileinfo, mt_templatemap $table
                    where templatemap_id = fileinfo_templatemap_id
                      and fileinfo_blog_id = $blog_id
                      $filter
                      and templatemap_archive_type = '$at'
                      and templatemap_is_preferred = 1";
            $rows = $this->get_results($sql, ARRAY_A);
            if (count($rows)) {
                $link =& $rows[0];
            } else {
                return null;
            }
            $blog =& $this->fetch_blog($link['fileinfo_blog_id']);
            if ($at == 'Page') {
                $blog_url = $blog['blog_site_url'];
            } else {
                $blog_url = $blog['blog_archive_url'];
                $blog_url or $blog_url = $blog['blog_site_url'];
            }
            $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
            $url = $blog_url . $link['fileinfo_url'];
            $url = _strip_index($url, $blog);
            $this->_entry_link_cache[$eid.';'.$at] = $url;
        }
        if ($at != 'Individual' && $at != 'Page') {
            if (!$args || !isset($args['no_anchor'])) {
                $url .= '#' . (!$args || isset($args['valid_html']) ? 'a' : '') .
                        sprintf("%06d", $eid);
            }
        }
        return $url;
    }

    /* recreation of generic load method functionality from MT::Object */
    function &load($class, $terms = null, $args = null) {
        $sql = "select * from mt_$class";
        $where = '';
        if ($terms) {
            if (is_array($terms)) {
                foreach ($terms as $col => $val) {
                    $column = $class . '_' . $col;
                    if (isset($args['range']) && isset($args['range'][$col])) {
                        $range = '';
                        if (isset($val[0]))
                            $range = "$column > '" . $this->escape($val[0]) . "' ";
                        if (isset($val[1])) {
                            if ($range != '') $range .= ' and ';
                            $range .= "$column < '" . $this->escape($val[0]) . "'";
                        }
                        $where .= " and ($range)";
                    } elseif (isset($args['range_incl']) && isset($args['range_incl'][$col])) {
                        $range = '';
                        if (isset($val[0]))
                            $range = "$column >= '" . $this->escape($val[0]) . "' ";
                        if (isset($val[1])) {
                            if ($range != '') $range .= ' and ';
                            $range .= "$column <= '" . $this->escape($val[0]) . "'";
                        }
                        $where .= " and ($range)";
                    } else {
                        if (is_array($val)) {
                            $list = '';
                            foreach ($val as $item) {
                                if ($list != '') $list .= ',';
                                $list .= "'" . $this->escape($item). "'";
                            }
                            $where .= " and ($column in ($list))";
                        } else {
                            $where .= " and ($column='".$this->escape($val)."')";
                        }
                    }
                }
                $where = preg_replace('/^ and/', '', $where);
            } else {
                $where = " ($class"."_id=".intval($terms).")";
            }
            $sql .= ' where ' . $where;
        }
        if (isset($args['sort']) or isset($args['direction'])) {
            $order = $args['sort'];
            $order or $order = 'id';
            $dir = $args['direction'] == 'descend' ? 'desc' : 'asc';
            $sql .= " order by " . $class . "_" . $order . " $dir";
        }
        if (isset($args['limit']) or isset($args['offset'])) {
            $sql .= ' <LIMIT>';
            $sql = $this->apply_limit_sql($sql, $args['limit'], $args['offset']);
        }
        return $this->get_results($sql, ARRAY_A);
    }

    function get_template_text($ctx, $module, $blog_id = null, $type = 'custom', $global = null) {
        $blog_id or $blog_id = $ctx->stash('blog_id');
        if ($type === 'custom' || $type === 'widget'|| $type === 'widgetset') {
            $col = 'template_name';
            $type_filter = "and template_type='$type'";
        } else {
            $col = 'template_identifier';
            $type_filter = "";
        }
        if (!isset($global)) {
            $blog_filter = "template_blog_id in (".$this->escape($blog_id).",0)";
        } elseif ($global) {
            $blog_filter = "template_blog_id=0";
        } else {
            $blog_filter = "template_blog_id=".$this->escape($blog_id);
        }
        $row = $this->get_row("
            select template_text, template_modified_on, template_linked_file, template_linked_file_mtime, template_linked_file_size
              from mt_template
             where $blog_filter
               and $col='".$this->escape($module)."'
               $type_filter
               order by template_blog_id desc", ARRAY_N);
        if (!$row) return '';
        list($tmpl, $ts, $file, $mtime, $size) = $row;
        if ($file) {
            if (!file_exists($file)) {
                $blog = $ctx->stash('blog');
                if ($blog['blog_id'] != $blog_id) {
                    $blog = $this->fetch_blog($blog_id);
                }
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
        return $tmpl;
    }

    function &fetch_pages($args) {
        $args['class'] = 'page';
        return $this->fetch_entries($args);
    }

    function &fetch_entries($args, $total_count = NULL) {
        if ($sql = $this->include_exclude_blogs($args)) {
            $blog_filter = 'and entry_blog_id ' . $sql;
        } elseif (isset($args['blog_id'])) {
            $blog_id = intval($args['blog_id']);
            $blog_filter = 'and entry_blog_id = ' . $blog_id;
            $blog = $this->fetch_blog($blog_id);
        }

        if ( !$blog ) {
            global $mt;
            $blog = $this->fetch_blog($mt->blog_id);
        }

        // determine any custom fields that we should filter on
        $fields = array();
        foreach ($args as $name => $v)
            if (preg_match('/^field___(\w+)$/', $name, $m))
                $fields[$m[1]] = $v;

        # automatically include offset if in request
        if ($args['offset'] == 'auto') {
            $args['offset'] = 0;
            if ($args['limit'] || $args['lastn']) {
                if ($_REQUEST['offset'] > 0) {
                    $args['offset'] = $_REQUEST['offset'];
                }
            }
        }

        if ($args['limit'] > 0) {
            $args['lastn'] = $args['limit'];
        } elseif (!isset($args['days']) && !isset($args['lastn'])) {
#            if ($days = $blog['blog_days_on_index']) {
#                if (!isset($args['recently_commented_on'])) {
#                    $args['days'] = $days;
#                }
#            } elseif ($posts = $blog['blog_entries_on_index']) {
#                $args['lastn'] = $posts;
#            }
        }
        if ($args['limit'] == 'auto') {
            if (($_REQUEST['limit'] > 0) && ($_REQUEST['limit'] < $args['lastn'])) {
                $args['lastn'] = intval($_REQUEST['limit']);
            } elseif (!isset($args['days']) && !isset($args['lastn'])) {
               if ($days = $blog['blog_days_on_index']) {
                    if (!isset($args['recently_commented_on'])) {
                        $args['days'] = $days;
                    }
                } elseif ($posts = $blog['blog_entries_on_index']) {
                    $args['lastn'] = $posts;
                }            
            }
        }

        if (isset($args['include_blogs']) or isset($args['exclude_blogs'])) {
            $blog_ctx_arg = isset($args['include_blogs']) ?
                array('include_blogs' => $args['include_blogs']) :
                array('exclude_blogs' => $args['exclude_blogs']);
        }

        # a context hash for filter routines
        $ctx = array();
        $filters = array();

        if (!isset($_REQUEST['entry_ids_published'])) {
            $_REQUEST['entry_ids_published'] = array();
        }

        if (isset($args['unique'])) {
            $filters[] = create_function('$e,$ctx', 'return !isset($ctx["entry_ids_published"][$e["entry_id"]]);');
            $ctx['entry_ids_published'] = &$_REQUEST['entry_ids_published'];
        }

        # special case for selecting a particular entry
        if (isset($args['entry_id'])) {
            $entry_filter = 'and entry_id = '.$args['entry_id'];
            $start = ''; $end = ''; $limit = 1; $blog_filter = ''; $day_filter = '';
        } else {
            $entry_filter = '';
        }

        # special case for excluding a particular entry
        if (isset($args['not_entry_id'])) {
            $entry_filter .= ' and entry_id != '.$args['not_entry_id'];
        }

        $entry_list = array();

        # Adds a category filter to the filters list.
        $cat_class = 'category';
        if (!isset($args['class']))
            $args['class'] = 'entry';
        if ($args['class'] == 'page')
            $cat_class = 'folder';

        if (isset($args['category']) or isset($args['categories'])) {
            $category_arg = isset($args['category']) ? $args['category'] : $args['categories'];
            require_once("MTUtil.php");
            if (!preg_match('/\b(AND|OR|NOT)\b|\(|\)/i', $category_arg)) {
                $not_clause = false;
                $cats = cat_path_to_category($category_arg, $blog_ctx_arg, $cat_class);
                if (count($cats)) {
                    $category_arg = '';
                    foreach ($cats as $cat) {
                        if ($category_arg != '')
                            $category_arg .= '|| ';
                        $category_arg .= '#' . $cat['category_id'];
                    }
                    $category_arg = '(' . $category_arg . ')';
                }
            } else {
                $not_clause = preg_match('/\bNOT\b/i', $category_arg);
                if ($blog_ctx_arg)
                    $cats =& $this->fetch_categories(array_merge($blog_ctx_arg, array('show_empty' => 1, 'class' => $cat_class)));
                else
                    $cats =& $this->fetch_categories(array('blog_id' => $blog_id, 'show_empty' => 1, 'class' => $cat_class));
            }
            if (!is_array($cats)) $cats = array();
            $cexpr = create_cat_expr_function($category_arg, $cats, array('children' => $args['include_subcategories']));
            if ($cexpr) {
                $cmap = array();
                $cat_list = array();
                foreach ($cats as $cat)
                    $cat_list[] = $cat['category_id'];
                $pl =& $this->fetch_placements(array('category_id' => $cat_list));
                if ($pl) {
                    foreach ($pl as $p) {
                        $cmap[$p['placement_entry_id']][$p['placement_category_id']]++;
                        if (!$not_clause)
                            $entry_list[$p['placement_entry_id']] = 1;
                    }
                }
                $ctx['p'] =& $cmap;
                $filters[] = $cexpr;
            } else {
                return null;
            }
        } elseif (isset($args['category_id'])) {
            require_once("MTUtil.php");
            $cat = $this->fetch_category($args['category_id']);
            if ($cat) {
                $cats = array($cat);
                $cmap = array();
                $cexpr = create_cat_expr_function($cat['category_label'], $cats, array('children' => $args['include_subcategories']));
                $pl =& $this->fetch_placements(array('category_id' => array($cat['category_id'])));
                if ($pl) {
                    foreach ($pl as $p) {
                        $cmap[$p['placement_entry_id']][$p['placement_category_id']]++;
                    }
                    $ctx['p'] =& $cmap;
                    $filters[] = $cexpr;
                } else {
                    # this category have no entries (or pages)
                    return null;
                }
            }
        }
        if ((0 == count($filters)) && (isset($args['show_empty']) && (1 == $args['show_empty']))) {
            return null;
        }

        # Adds a tag filter to the filters list.
        if (isset($args['tags']) or isset($args['tag'])) {
            $tag_arg = isset($args['tag']) ? $args['tag'] : $args['tags'];
            require_once("MTUtil.php");
            $not_clause = preg_match('/\bNOT\b/i', $tag_arg);

            require_once("MTUtil.php");
            $include_private = 0;
            $tag_array = tag_split($tag_arg);
            foreach ($tag_array as $tag) {
                if ($tag && (substr($tag,0,1) == '@')) {
                    $include_private = 1;
                }
            }
            if (isset($blog_ctx_arg))
                $tags =& $this->fetch_entry_tags(array($blog_ctx_arg, 'tag' => $tag_arg, 'include_private' => $include_private, 'class' => $args['class']));
            else
                $tags =& $this->fetch_entry_tags(array('blog_id' => $blog_id, 'tag' => $tag_arg, 'include_private' => $include_private, 'class' => $args['class']));
            if (!is_array($tags)) $tags = array();
            $cexpr = create_tag_expr_function($tag_arg, $tags);

            if ($cexpr) {
                $tmap = array();
                $tag_list = array();
                foreach ($tags as $tag) {
                    $tag_list[] = $tag['tag_id'];
                }
                if (isset($blog_ctx_arg))
                    $ot =& $this->fetch_objecttags(array('tag_id' => $tag_list, 'datasource' => 'entry', $blog_ctx_arg));
                elseif ($args['blog_id'])
                    $ot =& $this->fetch_objecttags(array('tag_id' => $tag_list, 'datasource' => 'entry', 'blog_id' => $args['blog_id']));
                if ($ot) {
                    foreach ($ot as $o) {
                            $tmap[$o['objecttag_object_id']][$o['objecttag_tag_id']]++;
                        if (!$not_clause)
                            $entry_list[$o['objecttag_object_id']] = 1;
                    }
                }
                $ctx['t'] =& $tmap;
                $filters[] = $cexpr;
            } else {
                return null;
            }
        }

        # Adds a score or rate filter to the filters list.
        if (isset($args['namespace'])) {
            require_once("MTUtil.php");
            $arg_names = array('min_score', 'max_score', 'min_rate', 'max_rate', 'min_count', 'max_count' );
            foreach ($arg_names as $n) {
                if (isset($args[$n])) {
                    $rating_args = $args[$n];
                    $cexpr = create_rating_expr_function($rating_args, $n, $args['namespace']);
                    if ($cexpr) {
                        $filters[] = $cexpr;
                    } else {
                        return null;
                    }
                }
            }

            if (isset($args['scored_by'])) {
                $voter = $this->fetch_author_by_name($args['scored_by']);
                if (!$voter) {
                    echo "Invalid scored by filter: ".$args['scored_by'];
                    return null;
                }
                $cexpr = create_rating_expr_function($voter['author_id'], 'scored_by', $args['namespace']);
                if ($cexpr) {
                    $filters[] = $cexpr;
                } else {
                    return null;
                }
            }
        }

        if (count($entry_list) && ($entry_filter == '')) {
            $entry_list = implode(",", array_keys($entry_list));
            # set a reasonable cap on the entry list cache. if
            # user is selecting something too big, then they'll
            # just have to wait through a scan.
            if (strlen($entry_list) < 2048)
                $entry_filter = "and entry_id in ($entry_list)";
        }

        if (isset($args['author']))
            $author_filter = 'and author_name = \'' .
                $this->escape($args['author']) . "'";

        $start = isset($args['current_timestamp'])
            ? $args['current_timestamp'] : null;
        $end = isset($args['current_timestamp_end'])
            ? $args['current_timestamp_end'] : null;
        if ($start and $end) {
            $start = $this->ts2db($start);
            $end = $this->ts2db($end);
            $date_filter = "and entry_authored_on between '$start' and '$end'";
        } elseif ($start) {
            $start = $this->ts2db($start);
            $date_filter = "and entry_authored_on >= '$start'";
        } elseif ($end) {
            $end = $this->ts2db($end);
            $date_filter = "and entry_authored_on <= '$end'";
        } else {
            $date_filter = '';
        }

        if (isset($args['lastn'])) {
            if (!isset($args['entry_id'])) $limit = $args['lastn'];
        } elseif (isset($args['days']) && !$date_filter) {
            $day_filter = 'and ' . $this->limit_by_day_sql('entry_authored_on', intval($args['days']));
        } else {
            $found_valid_args = 0;
            foreach ( array(
                'lastn', 'days',
                'category', 'categories', 'category_id',
                'tag', 'tags',
                'author',
                'min_score',  'max_score',
                'min_rate',    'max_rate',
                'min_count',  'max_count'
              ) as $valid_key )
            {
                if (array_key_exists($valid_key, $args)) {
                    $found_valid_args = 1;
                    break;
                }
            }
            if ((!isset($args['current_timestamp']) &&
                !isset($args['current_timestamp_end'])) &&
                ($limit <= 0) &&
                (!$found_valid_args) &&
                (isset($blog))) {
                if ($days = $blog['blog_days_on_index']) {
                    if (!isset($args['recently_commented_on'])) {
                        $day_filter = 'and ' . $this->limit_by_day_sql('entry_authored_on', $days);
                    }
                } elseif ($posts = $blog['blog_entries_on_index']) {
                    $limit = $posts;
                }
            }
        }

        if (isset($args['sort_order'])) {
            if ($args['sort_order'] == 'ascend') {
                $order = 'asc';
            } else if ($args['sort_order'] == 'descend') {
                $order = 'desc';
            }
        } 
        if (!isset($order)) {
            $order = 'desc';
            if (isset($blog) && isset($blog['blog_sort_order_posts'])) {
                if ($blog['blog_sort_order_posts'] == 'ascend') {
                    $order = 'asc';
                }
            }
        }

        if (isset($args['class'])) {
            $class = $this->escape($args['class']);
        } else {
            $class = 'entry';
        }
        $class_filter = "and entry_class='$class'";
        if ($args['class'] == '*') $class_filter = '';
        
        $join_score = "";
        $distinct = "";
        if ( isset($args['sort_by'])
          && (($args['sort_by'] == 'score') || ($args['sort_by'] == 'rate')) ) {
            $join_score = "left join mt_objectscore on objectscore_object_id = entry_id and objectscore_namespace='"
                . $args['namespace']."' and objectscore_object_ds='".$class."'";
            $distinct = " distinct";
        }

        if (isset($args['offset']))
            $offset = $args['offset'];

        if (isset($args['limit'])) {
            if (isset($args['sort_by'])) {  
                if ($args['sort_by'] == 'title') {  
                    $sort_field = 'entry_title';  
                } elseif ($args['sort_by'] == 'id') {  
                    $sort_field = 'entry_id';  
                } elseif ($args['sort_by'] == 'status') {  
                    $sort_field = 'entry_status';  
                } elseif ($args['sort_by'] == 'modified_on') {  
                    $sort_field = 'entry_modified_on';  
                } elseif ($args['sort_by'] == 'author_id') {  
                    $sort_field = 'entry_author_id';  
                } elseif ($args['sort_by'] == 'excerpt') {  
                    $sort_field = 'entry_excerpt';  
                } elseif ($args['sort_by'] == 'comment_created_on') {  
                    $sort_field = $args['sort_by'];  
                } elseif ($args['sort_by'] == 'score' || $args['sort_by'] == 'rate') {  
                    $post_sort_limit = $limit;
                    $post_sort_offset = $offset;
                    $limit = 0; $offset = 0;
                } elseif ($args['sort_by'] == 'trackback_count') {
                    $sort_field = 'entry_ping_count';  
                } elseif (preg_match('/field[:\.]/', $args['sort_by'])) {
                    $no_resort = 0;
                } else {  
                    $sort_field = 'entry_' . $args['sort_by'];  
                }  
                if ($sort_field) $no_resort = 1;  
            }  
            else {
                $sort_field ='entry_authored_on';
            }
            if ($sort_field) {
                $base_order = ($args['sort_order'] == 'ascend' ? 'asc' : 'desc');
                $base_order or $base_order = 'desc';
            }
        } else {
            $base_order = 'desc';
            if (isset($args['base_sort_order'])) {
                if ($args['base_sort_order'] == 'ascend')
                    $base_order = 'asc';
            }
            $sort_field ='entry_authored_on'; 
            $no_resort = 0;
        }

        if (count($filters)) {
            $post_select_limit = $limit;
            $post_select_offset = $offset;
            $limit = 0; $offset = 0;
        }

        if (count($fields)) {
            $meta_join_num = 1;
            $meta_join = "";
            $entry_meta = array();
            foreach ($this->object_meta['entry'] as $meta) {
                list($meta_key, $meta_type) = preg_split('/:/', $meta);
                $entry_meta[$meta_key] = $meta_type;
            }
            foreach ($fields as $name => $value) {
                $meta_col = $entry_meta['field.' . $name];
                if (!$meta_col) return null; # invalid column; can't select

                $value = $this->escape($value);
                $meta_join .= " join mt_entry_meta entry_meta$meta_join_num on (entry_meta$meta_join_num.entry_meta_entry_id = entry_id
                and entry_meta$meta_join_num.entry_meta_type = 'field.$name'
                and entry_meta$meta_join_num.entry_meta_$meta_col='$value')\n";
                $meta_join_num++;
            }
        }

        $sql = "
            select$distinct mt_entry.*, mt_placement.*, mt_author.*,
                   mt_trackback.*
              from mt_entry
              left outer join mt_trackback on trackback_entry_id = entry_id
              $meta_join
              $join_score
              left outer join mt_placement on (placement_entry_id = entry_id
                and placement_is_primary = 1),
                   mt_author
             where entry_status = 2
               and entry_author_id = author_id
                   $blog_filter
                   $entry_filter
                   $author_filter
                   $date_filter
                   $day_filter
                   $class_filter
        ";

        if ($sort_field) {
            $sql .= "
                order by $sort_field $base_order";
        }
        if (isset($args['recently_commented_on'])) {
            $rco = $args['recently_commented_on'];
            $sql = $this->entries_recently_commented_on_sql($sql);
            $sql = $this->apply_limit_sql($sql, count($filters) ? null : $rco);
            $args['sort_by'] or $args['sort_by'] = 'comment_created_on';
            $args['sort_order'] or $args['sort_order'] = 'descend';
            $post_select_limit = $rco;
            $no_resort = 1;
        } elseif ( !is_null($total_count) ) {
            $orig_offset = $post_select_offset ? $post_select_offset : $orig_offset;
            $orig_limit = $post_select_limit ? $post_select_limit : $limit;
        } else {
            $sql = $this->apply_limit_sql($sql . " <LIMIT>", $limit, $offset);
        }

        $result = $this->query_start($sql);
        if (!$result) return null;

        $entries = array();
        $j = 0;
        $offset = $post_select_offset ? $post_select_offset : $orig_offset;
        $limit = $post_select_limit ? $post_select_limit : 0;
        $id_list = array();
        $_total_count = 0;
        while (true) {
            $e = $this->query_fetch(ARRAY_A);
            if (!isset($e)) break;
            if (count($filters)) {
                foreach ($filters as $f) {
                    $old_result = $this->result;
                    if (!$f($e, $ctx)) {
                        $this->result = $old_result;
                        continue 2;
                    }
                    $this->result = $old_result;
                }
            }
            $_total_count++;
            if ( !is_null($total_count) ) {
                if ( ($orig_limit > 0)
                  && ( ($_total_count-$offset) > $orig_limit) ) {
                    // collected all the entries; only count numbers;
                    continue;
                }
            }
            if ($offset && ($j++ < $offset)) continue;
            $e['entry_authored_on'] = $this->db2ts($e['entry_authored_on']);
            $e['entry_modified_on'] = $this->db2ts($e['entry_modified_on']);
            $e = $this->expand_meta($e);
            $id_list[] = $e['entry_id'];
            $entries[] = $e;
            $this->_comment_count_cache[$e['entry_id']] = $e['entry_comment_count'];
            $this->_ping_count_cache[$e['entry_id']] = $e['entry_ping_count'];
            if ( is_null($total_count) ) {
                // the request does not want total count; break early
                if (($limit > 0) && (count($entries) >= $limit)) break;
            }
        }
        if ( !is_null($total_count) )
            $total_count = $_total_count;

        if (!$no_resort) {
            $sort_field = '';
            if (isset($args['sort_by'])) {
                if ($args['sort_by'] == 'title') {
                    $sort_field = 'entry_title';
                } elseif ($args['sort_by'] == 'id') {
                    $sort_field = 'entry_id';
                } elseif ($args['sort_by'] == 'status') {
                    $sort_field = 'entry_status';
                } elseif ($args['sort_by'] == 'modified_on') {
                    $sort_field = 'entry_modified_on';
                } elseif ($args['sort_by'] == 'author_id') {
                    $sort_field = 'entry_author_id';
                } elseif ($args['sort_by'] == 'excerpt') {
                    $sort_field = 'entry_excerpt';
                } elseif ($args['sort_by'] == 'comment_created_on') {
                    $sort_field = $args['sort_by'];
                } elseif ($args['sort_by'] == 'score') {
                    $sort_field = $args['sort_by'];
                } elseif ($args['sort_by'] == 'rate') {
                    $sort_field = $args['sort_by'];
                } elseif ($args['sort_by'] == 'trackback_count') {
                    $sort_field = 'entry_ping_count';  
                } elseif (preg_match('/^field[:\.](.+)$/', $args['sort_by'], $match)) {
                    $sort_field = 'entry_field.' . $match[1];
                } else {
                    $sort_field = 'entry_' . $args['sort_by'];
                }
            } else {
                $sort_field = 'entry_authored_on';
            }
            if ($sort_field) {
                if ($sort_field == 'score') {
                    $offset = $post_sort_offset ? $post_sort_offset : 0;
                    $limit = $post_sort_limit ? $post_sort_limit : 0;
                    $entries_tmp = array();
                    foreach ($entries as $e) {
                        $entries_tmp[$e['entry_id']] = $e;
                    }
                    $scores = $this->fetch_sum_scores($args['namespace'], 'entry', $order,
                        $blog_filter . "\n" .
                        $entry_filter . "\n" .
                        $author_filter . "\n" .
                        $date_filter . "\n" .
                        $day_filter . "\n" .
                        $class_filter . "\n"
                    );
                    $entries_sorted = array();
                    foreach($scores as $score) {
                        if (--$offset >= 0) continue;
                        if (array_key_exists($score['objectscore_object_id'], $entries_tmp)) {
                            array_push($entries_sorted, $entries_tmp[$score['objectscore_object_id']]);
                            unset($entries_tmp[$score['objectscore_object_id']]);
                            if (--$limit == 0) break;
                        }
                    }
                    foreach ($entries_tmp as $et) {
                        if ($limit == 0) break;
                        if ($order == 'asc')
                            array_unshift($entries_sorted, $et);
                        else
                            array_push($entries_sorted, $et);
                        $limit--;
                    }
                    $entries = $entries_sorted;
                } elseif ($sort_field == 'rate') {
                    $offset = $post_sort_offset ? $post_sort_offset : 0;
                    $limit = $post_sort_limit ? $post_sort_limit : 0;
                    $entries_tmp = array();
                    foreach ($entries as $e) {
                        $entries_tmp[$e['entry_id']] = $e;
                    }
                    $scores = $this->fetch_avg_scores($args['namespace'], 'entry', $order,
                        $blog_filter . "\n" .
                        $entry_filter . "\n" .
                        $author_filter . "\n" .
                        $date_filter . "\n" .
                        $day_filter . "\n" .
                        $class_filter . "\n"
                    );
                    $entries_sorted = array();
                    foreach($scores as $score) {
                        if (--$offset >= 0) continue;
                        if (array_key_exists($score['objectscore_object_id'], $entries_tmp)) {
                            array_push($entries_sorted, $entries_tmp[$score['objectscore_object_id']]);
                            unset($entries_tmp[$score['objectscore_object_id']]);
                            if (--$limit == 0) break;
                        }
                    }
                    foreach ($entries_tmp as $et) {
                        if ($limit == 0) break;
                        if ($order == 'asc')
                            array_unshift($entries_sorted, $et);
                        else
                            array_push($entries_sorted, $et);
                        $limit--;
                    }
                    $entries = $entries_sorted;
                } else {
                    if (($sort_field == 'entry_status') || ($sort_field == 'entry_author_id') || ($sort_field == 'entry_id')
                          || ($sort_field == 'entry_comment_count') || ($sort_field == 'entry_ping_count')) {
                        $sort_fn = "if (\$a['$sort_field'] == \$b['$sort_field']) return 0; return \$a['$sort_field'] < \$b['$sort_field'] ? -1 : 1;";
                    } else {
                        $sort_fn = "return strcmp(\$a['$sort_field'],\$b['$sort_field']);";
                    }
                    $sorter = create_function(
                        $order == 'asc' ? '$a,$b' : '$b,$a',
                        $sort_fn);
                    usort($entries, $sorter);
                }
            }
        }

        if (count($id_list) <= 30) { # TODO: find a good upper limit
            # pre-cache comment counts and categories for these entries
            $this->cache_categories($id_list);
            $this->cache_permalinks($id_list);
        }

        return $entries;
    }

    function fetch_plugin_config($plugin, $scope = "system") {
        if ($scope != 'system') {
            $key = 'configuration:'.$scope;
        } else {
            $key = 'configuration';
        }
        return $this->fetch_plugin_data($plugin, $key);
    }

    function fetch_plugin_data($plugin, $key) {
        $plugin = $this->escape($plugin);
        $key = $this->escape($key);
        $sql = "
            select plugindata_data from mt_plugindata
             where plugindata_plugin = '$plugin'
               and plugindata_key = '$key'";
        $data = $this->get_var($sql);
        if ($data) {
            return $this->unserialize($data);
        }
        return null;
    }

    function &fetch_entry_tags($args) {
        $class = 'entry';
        if (isset($args['class'])) {
            $class = $args['class'];
        }

        # load tags
        if (isset($args['entry_id'])) {
            if (!isset($args['tags']) && !isset($args['tag'])) {
                if (isset($this->_entry_tag_cache[$args['entry_id']])) {
                    return $this->_entry_tag_cache[$args['entry_id']];
                }
            }
            $entry_filter = 'and objecttag_tag_id in (select objecttag_tag_id from mt_objecttag where objecttag_object_id='.intval($args['entry_id']).')';
        }

        $blog_filter = $this->include_exclude_blogs($args);
        if ($blog_filter == '' and isset($args['blog_id'])) {
            if (!isset($args['tags']) && !isset($args['tag'])) {
                if (!isset($args['entry_id'])) {
                    if (isset($this->_blog_tag_cache[$args['blog_id'].":$class"])) {
                        return $this->_blog_tag_cache[$args['blog_id'].":$class"];
                    }
                }
            }
            $blog_filter = ' = '. intval($args['blog_id']);
        }
        if ($blog_filter != '') 
            $blog_filter = 'and objecttag_blog_id ' . $blog_filter;

        if (!isset($args['include_private'])) {
            $private_filter = 'and (tag_is_private = 0 or tag_is_private is null)';
        }
        if (isset($args['tags']) && ($args['tags'] != '')) {
            $tag_list = '';
            require_once("MTUtil.php");
            $tag_array = tag_split($args['tags']);
            foreach ($tag_array as $tag) {
                if ($tag_list != '') $tag_list .= ',';
                $tag_list .= "'" . $this->escape($tag) . "'";
            }
            if ($tag_list != '') {
                $tag_filter = 'and (tag_name in (' . $tag_list . '))';
                $private_filter = '';
            }
        }

        $sort_col = isset($args['sort_by']) ? $args['sort_by'] : 'name';
        $sort_col = "tag_$sort_col";
        if (isset($args['sort_order']) and $args['sort_order'] == 'descend') {
            $order = 'desc';
        } else {
            $order = 'asc';
        }
        $id_order = '';
        if ($sort_col == 'tag_name') {
            $sort_col = 'lower(tag_name)';
        }else{
            $id_order = ', lower(tag_name)';
        }

        $sql = "
            select tag_id, tag_name, count(*) as tag_count
             from mt_tag, mt_objecttag, mt_entry
             where objecttag_tag_id = tag_id
               and entry_id = objecttag_object_id and objecttag_object_datasource='entry'
               and entry_status = 2
                   and entry_class = '$class'
                   $blog_filter
                   $tag_filter
                   $entry_filter
                   $private_filter
            group by tag_id, tag_name
            order by $sort_col $order $id_order";
        $tags = $this->get_results($sql, ARRAY_A);
        if (!isset($args['tag'])) {
            if ($args['entry_id'])
                $this->_entry_tag_cache[$args['entry_id']] = $tags;
            elseif ($args['blog_id'])
                $this->_blog_tag_cache[$args['blog_id'].":$class"] = $tags;
        }
        return $tags;
    }

    function &fetch_asset_tags($args) {

        # load tags by asset
        if (!isset($args['include_private'])) {
            $private_filter = 'and (tag_is_private = 0 or tag_is_private is null)';
        }

        if (isset($args['asset_id'])) {
            if (isset($args['tags'])) {
                if (isset($this->_asset_tag_cache[$args['asset_id']]))
                    return $this->_asset_tag_cache[$args['asset_id']];
            }
            $asset_filter = 'and objecttag_object_id = '.intval($args['asset_id']);
        }
        
        if (isset($args['blog_id'])) {
            if (!isset($args['tags'])) {
                if (isset($this->_blog_asset_tag_cache[$args['blog_id']]))
                    return $this->_blog_asset_tag_cache[$args['blog_id']];
            }
            $blog_filter = 'and objecttag_blog_id = '.intval($args['blog_id']);
        }

        if (isset($args['tags']) && ($args['tags'] != '')) {
            $tag_list = '';
            require_once("MTUtil.php");
            $tag_array = tag_split($args['tags']);
            foreach ($tag_array as $tag) {
                if ($tag_list != '') $tag_list .= ',';
                $tag_list .= "'" . $this->escape($tag) . "'";
            }
            if ($tag_list != '') {
                $tag_filter = 'and (tag_name in (' . $tag_list . '))';
                $private_filter = '';
            }
        }

        $sort_col = isset($args['sort_by']) ? $args['sort_by'] : 'name';
        $sort_col = "tag_$sort_col";
        if (isset($args['sort_order']) and $args['sort_order'] == 'descend')
            $order = 'desc';
        else
            $order = 'asc';

        $id_order = '';
        if ($sort_col == 'tag_name')
            $sort_col = 'lower(tag_name)';
        else
            $id_order = ', lower(tag_name)';

        $sql = "
            select tag_id, tag_name, count(*) as tag_count
            from mt_tag, mt_objecttag, mt_asset
            where objecttag_tag_id = tag_id
                and asset_id = objecttag_object_id and objecttag_object_datasource='asset'
                $blog_filter
                $private_filter
                $tag_filter
                $asset_filter
            group by tag_id, tag_name
            order by $sort_col $order $id_order
        ";
        $tags = $this->get_results($sql, ARRAY_A);
        if (isset($args['tags'])) {
            if ($args['asset_id'])
                $this->_asset_tag_cache[$args['asset_id']] = $tags;
            elseif ($args['blog_id'])
                $this->_blog_asset_tag_cache[$args['blog_id']] = $tags;
        }
        return $tags;
    }

    function &fetch_folders($args) {
        $args['class'] = 'folder';
        return $this->fetch_categories($args);
    }

    function &fetch_categories($args) {
        # load categories

        if ($blog_filter = $this->include_exclude_blogs($args)) {
             $blog_filter = 'and category_blog_id '. $blog_filter;
        } elseif (isset($args['blog_id'])) {
            $blog_filter = 'and category_blog_id = '.intval($args['blog_id']);
        }
        if (isset($args['parent'])) {
            $parent = $args['parent'];
            if (is_array($parent)) {
                $parent_filter = 'and category_parent in (' . implode(',', $parent) . ')';
            } else {
                $parent_filter = 'and category_parent = '.intval($parent);
            }
        }
        if (isset($args['category_id'])) {
            if (isset($args['children'])) {
                if (isset($this->_cat_id_cache['c'.$args['category_id']])) {
                    $cat = $this->_cat_id_cache['c'.$args['category_id']];
                    if (isset($cat['_children'])) {
                        $children = $cat['_children'];
                        if ($children === false) {
                            return null;
                        } else {
                            return $children;
                        }
                    }
                }

                $cat_filter = 'and category_parent = '.intval($args['category_id']);
            } else {
                $cat_filter = 'and category_id = '.intval($args['category_id']);
                $limit = 1;
            }
        } elseif (isset($args['label'])) {
            $cat_filter = 'and category_label = \''.$this->escape($args['label']).'\'';
        } else {
            $limit = $args['lastn'];
            if (isset($args['sort_order'])) {
                if ($args['sort_order'] == 'ascend') {
                    $sort_order = 'asc';
                } elseif ($args['sort_order'] == 'descend') {
                    $sort_order = 'desc';
                }
            } else {
                $sort_order = '';
            }
        }
        $count_column = 'placement_id';
        if ($args['show_empty']) {
            $join_clause = 'left outer join mt_placement on placement_category_id = category_id';
            if (isset($args['entry_id'])) {
                $join_clause .= ' left outer join mt_entry on placement_entry_id = entry_id and entry_id = '.intval($args['entry_id']);
            } else {
                $join_clause .= ' left outer join mt_entry on placement_entry_id = entry_id and entry_status = 2';
            }
            $count_column = 'entry_id';
        } else {
            $join_clause = ', mt_entry, mt_placement';
            $cat_filter .= ' and placement_category_id = category_id';
            if (isset($args['entry_id'])) {
                $entry_filter = 'and placement_entry_id = entry_id and placement_entry_id = '.intval($args['entry_id']);
            } else {
                $entry_filter = 'and placement_entry_id = entry_id and entry_status = 2';
            }
        }

        if (isset($args['class'])) {
            $class = $this->escape($args['class']);
        } else {
            $class = "category";
        }
        $class_filter = "and category_class='$class'";

        $sql = "
            select category_id, count($count_column) as category_count
              from mt_category $join_clause
             where 1 = 1
                   $cat_filter
                   $entry_filter
                   $blog_filter
                   $parent_filter
                   $class_filter
             group by category_id
                   <LIMIT>
        ";
        $sql = $this->apply_limit_sql($sql, $limit, $offset);

        $categories = $this->get_results($sql, ARRAY_A);
        if (!$categories) {
            return null;
        }
        if (isset($args['children']) && isset($parent_cat)) {
            $parent_cat['_children'] =& $categories;
        } else {
            $ids = array();
            $counts = array();
            foreach ($categories as $cid => $cat) {
                $counts[$cat['category_id']] = $cat['category_count'];
                $ids[] = $cat['category_id'];
            }
            $list = implode(",", $ids);
            $sql2 = "
                select mt_category.*, mt_trackback.*
                    from mt_category left outer join mt_trackback on trackback_category_id = category_id
                   where category_id in ($list)
                order by category_label $sort_order
            ";
            $categories = $this->get_results($sql2, ARRAY_A);
            $id_list = array();
            foreach ($categories as $cid => $cat) {
                $cat_id = $cat['category_id'];
                $categories[$cid]['category_count'] = $counts[$cat_id];
                if (isset($args['top_level_categories']) || !isset($this->_cat_id_cache['c'.$cat_id])) {
                    $id_list[] = $cat_id;
                    $this->_cat_id_cache['c'.$cat_id] = $categories[$cid];
                }
                if (isset($args['top_level_categories'])) {
                    $this->_cat_id_cache['c'.$cat_id]['_children'] = false;
                }
            }

            $top_cats = array();
            foreach ($categories as $cid => $cat) {
                if ($cat['category_parent'] > 0) {
                    $parent_id = $cat['category_parent'];
                    if (isset($this->_cat_id_cache['c'.$parent_id])) {
                        if (isset($args['top_level_categories'])) {
                            $parent =& $this->fetch_category($categories[$cid]['category_parent']);
                            if (!isset($parent['_children']) || ($parent['_children'] === false)) {
                                $parent['_children'] = array(&$categories[$cid]);
                            } else {
                                $parent['_children'][] = $categories[$cid];
                            }
                        }
                    }
                }
                if ((!$cat['category_parent']) && (isset($args['top_level_categories']))) {
                    $top_cats[] = $categories[$cid];
                }
            }
            $this->cache_category_links($id_list);
            if (isset($args['top_level_categories'])) {
                return $top_cats;
            }
        }
        return $categories;
    }

    function &fetch_entry($entry_id) {
        if (isset($this->_entry_id_cache['entry_id'])) {
            return $this->_entry_id_cache[$entry_id];
        }
        list($entry) = $this->fetch_entries(array('entry_id' => $entry_id));
        $this->_entry_id_cache[$entry_id] = $entry;
        return $entry;
    }

    function &fetch_page($entry_id) {
        if (isset($this->_entry_id_cache['entry_id'])) {
            return $this->_entry_id_cache[$entry_id];
        }
        list($entry) = $this->fetch_pages(array('entry_id' => $entry_id));
        $this->_entry_id_cache[$entry_id] = $entry;
        return $entry;
    }

    function &fetch_author($author_id) {
        if (isset($this->_author_id_cache[$author_id])) {
            return $this->_author_id_cache[$author_id];
        }
        $args['author_id'] = $author_id;
        $args['any_type'] = 1;
        $result = $this->fetch_authors($args);
        $author = null;
        if (is_array($result)) {
            $author = $result[0];
            $this->_author_id_cache[$author_id] = $author;
        }
        return $author;
    }

    function &fetch_author_by_name($author_name) {
        global $mt;
        $args['blog_id'] = $mt->blog_id;
        $args['author_name'] = $this->escape($author_name);
        $result = $this->fetch_authors($args);
        $author = null;
        if (is_array($result)) {
            $author = $result[0];
            $this->_author_id_cache[$author['author_id']] = $author;
        }
        return $author;
    }

    function &fetch_authors($args) {
        # Adds blog join
        $extend_column = '';
        if ($sql = $this->include_exclude_blogs($args)) {
            $blog_join = 'join mt_permission on permission_author_id = author_id and permission_blog_id ' . $sql;
            $unique_filter = 'distinct';
        } elseif (isset($args['blog_id'])) {
            $blog_id = intval($args['blog_id']);
            $blog_join = "join mt_permission on permission_author_id = author_id and permission_blog_id = $blog_id";
        }

        # Adds author filter
        if (isset($args['author_id'])) {
            $author_id = intval($args['author_id']);
            $author_filter = " and author_id = $author_id";
        }
        if (isset($args['author_nickname'])) {
            $author_filter .= " and author_nickname = '".$args['author_nickname']."'";
        }
        if (isset($args['author_name'])) {
            $author_filter .= " and author_name = '".$args['author_name']."'";
        }

        # Adds entry join and filter
        if ($args['need_entry']) {
            $entry_join = 'join mt_entry on author_id = entry_author_id';
            $unique_filter = 'distinct';
            $entry_filter = " and entry_status = 2";
            if ($blog_join) {
                $entry_filter .= " and entry_blog_id = permission_blog_id";
            } else {
                $entry_filter .= " and entry_blog_id = ".$args['blog_id'];
            }
        } else {
            if ( ! $args['any_type'] )
                $author_filter .= " and author_type = 1";
        }

        # a context hash for filter routines
        $ctx = array();
        $filters = array();

        if (isset($args['status'])) {
            $status_arg = $args['status'];
            require_once("MTUtil.php");
            $status = array(
                array('name' => 'enabled', 'id' => 1),
                array('name' => 'disabled', 'id' => 2));

            $cexpr = create_status_expr_function($status_arg, $status);
            if ($cexpr) {
                $filters[] = $cexpr;
            }
        }

        if (isset($args['roles']) or isset($args['role'])) {
            $role_arg = isset($args['role']) ? $args['role'] : $args['roles'];
            require_once("MTUtil.php");
            $roles =& $this->fetch_all_roles();
            if (!is_array($roles)) $roles = array();

            $cexpr = create_role_expr_function($role_arg, $roles);
            if ($cexpr) {
                $rmap = array();
                $role_list = array();
                foreach ($roles as $role) {
                    $role_list[] = $role['role_id'];
                }
                $as =& $this->fetch_associations(array('blog_id' => $blog_id, 'role_id' => $role_list));
                if ($as) {
                    foreach ($as as $a) {
                        $rmap[$a['association_author_id']][$a['association_role_id']]++;
                    }
                }
                $ctx['r'] =& $rmap;
                $filters[] = $cexpr;
            }
        }

        # Adds a score or rate filter to the filters list.
        $re_sort = false;
        if (isset($args['namespace'])) {
            require_once("MTUtil.php");
            $arg_names = array('min_score', 'max_score', 'min_rate', 'max_rate', 'min_count', 'max_count' );
            foreach ($arg_names as $n) {
                if (isset($args[$n])) {
                    $rating_args = $args[$n];
                    $cexpr = create_rating_expr_function($rating_args, $n, $args['namespace'], 'author');
                    if ($cexpr) {
                        $filters[] = $cexpr;
                        $re_sort = true;
                    } else {
                        return null;
                    }
                }
            }
        }

        # sort
        $join_score = "";
        if (isset($args['sort_by'])) {
            if (($args['sort_by'] == 'score') || ($args['sort_by'] == 'rate')) {
                $join_score = "join mt_objectscore on objectscore_object_id = author_id and objectscore_namespace='".$args['namespace']."' and objectscore_object_ds='author'";
                $unique_filter = 'distinct';
                $order_sql = "order by author_created_on desc";
                $re_sort = true;
            } else {
                $sort_col = $args['sort_by'];
                $order = '';
                if (isset($args['sort_order'])) {
                    if ($args['sort_order'] == 'ascend')
                        $order = 'asc';
                    else
                        $order = 'desc';
                }
                $order_sql = "order by $sort_col $order";
    
                if (isset($args['start_string'])) {
                    $val = $args['start_string'];
                    if ($order == 'asc')
                        $val_order = '>';
                    else
                        $val_order = '<';
                    $sort_filter =  " and $sort_col $val_order '$val'";
                }
    
                if (isset($args['start_num'])) {
                    $val = $args['start_num'];
                    if ($order == 'asc')
                        $val_order = '>';
                    else
                        $val_order = '<';
                    $sort_filter .= " and $sort_col $val_order $val";
                }
            }
        }

        $limit = 0;
        $offset = 0;
        if (isset($args['lastn']))
            $limit = $args['lastn'];
        if (isset($args['offset']))
            $limit = $args['offset'];

        if ($re_sort) {
            $post_select_limit = $limit;
            $post_select_offset = $offset;
            $limit = 0; $offset = 0;
        }
        
        $sql = "
            select $unique_filter
                   mt_author.*
                   $extend_column
              from mt_author
                   $blog_join
                   $entry_join
                   $join_score
              where 1 = 1
                $author_filter
                $entry_filter
                $sort_filter
              $order_sql
                   <LIMIT>
        ";
        $sql = $this->apply_limit_sql($sql, $limit, $offset);

        $result = $this->query_start($sql);
        if (!$result) return null;

        $authors = array();
        if ($args['sort_by'] != 'score' && $args['sort_by'] != 'rate') {
            $offset = $post_select_offset ? $post_select_offset : 0;
            $limit = $post_select_limit ? $post_select_limit : 0;
        }
        $j = 0;
        while (true) {
            $e = $this->query_fetch(ARRAY_A);
            if ($offset && ($j++ < $offset)) continue;
            if (!isset($e)) break;
            if (count($filters)) {
                foreach ($filters as $f) {
                    if (!$f($e, $ctx)) continue 2;
                }
            }
            $authors[] = $e;
            if (($limit > 0) && (count($authors) >= $limit)) break;
        }

        if (isset($args['sort_by']) && ('score' == $args['sort_by'])) {
            $authors_tmp = array();
            $order = 'asc';
            if (isset($args['sort_order']))
                $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
            foreach ($authors as $a) {
                $authors_tmp[$a['author_id']] = $a;
            }
            $scores = $this->fetch_sum_scores($args['namespace'], 'author', $order,
                $author_filter
            );
            $offset = $post_select_offset ? $post_select_offset : 0;
            $limit = $post_select_limit ? $post_select_limit : 0;
            $j = 0;
            $authors_sorted = array();
            foreach($scores as $score) {
                if (array_key_exists($score['objectscore_object_id'], $authors_tmp)) {
                    if ($offset && ($j++ < $offset)) continue;
                    array_push($authors_sorted, $authors_tmp[$score['objectscore_object_id']]);
                    unset($authors_tmp[$score['objectscore_object_id']]);
                    if (($limit > 0) && (count($authors_sorted) >= $limit)) break;
                }
            }
            $authors = $authors_sorted;

        } elseif (isset($args['sort_by']) && ('rate' == $args['sort_by'])) {
            $authors_tmp = array();
            $order = 'asc';
            if (isset($args['sort_order']))
                $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
            foreach ($authors as $a) {
                $authors_tmp[$a['author_id']] = $a;
            }
            $scores = $this->fetch_avg_scores($args['namespace'], 'author', $order,
                $author_filter
            );
            $offset = $post_select_offset ? $post_select_offset : 0;
            $limit = $post_select_limit ? $post_select_limit : 0;
            $j = 0;
            $authors_sorted = array();
            foreach($scores as $score) {
                if (array_key_exists($score['objectscore_object_id'], $authors_tmp)) {
                    if ($offset && ($j++ < $offset)) continue;
                    array_push($authors_sorted, $authors_tmp[$score['objectscore_object_id']]);
                    unset($authors_tmp[$score['objectscore_object_id']]);
                    if (($limit > 0) && (count($authors_sorted) >= $limit)) break;
                }
            }
            $authors = $authors_sorted;

        }

        return $authors;
    }

    function &fetch_permission($args) {
        if ($sql = $this->include_exclude_blogs($args)) {
            $blog_filter = 'permission_blog_id ' . $sql;
        } elseif (isset($args['blog_id'])) {
            $blog_id = intval($args['blog_id']);
            $blog_filter = "and permission_blog_id = $blog_id";
        }
        if (isset($args['id'])) {
          $id_filter = 'and permission_author_id in ('.$args['id'].')';
        }

        $sql = "select
                    *
                from
                    mt_permission
                where
                    1 = 1
                    $blog_filter
                    $id_filter";

        $result = $this->get_results($sql, ARRAY_A);
        return $result;
    }

    function &fetch_all_roles() {
        $sql = "select *
                  from mt_role
              order by role_name";
        $result = $this->get_results($sql, ARRAY_A);
        return $result;
    }

    function &fetch_associations($args) {
        $id_list = implode(",", $args['role_id']);
        if (empty($id_list))
            return;
        if ($sql = $this->include_exclude_blogs($args)) {
            $blog_filter = 'and association_blog_id  ' . $sql;
        } elseif (isset($args['blog_id'])) {
            $blog_filter = 'and association_blog_id = ' . intval($args['blog_id']);
        }
        $sql = "select *
                  from mt_association
                 where association_role_id in ($id_list)
                   $blog_filter";
        $result = $this->get_results($sql, ARRAY_A);
        return $result;
    }

    function &fetch_tag($tag_id) {
        $tag_id = intval($tag_id);
        if (isset($this->_tag_id_cache[$tag_id])) {
            return $this->_tag_id_cache[$tag_id];
        }
        $tag = $this->get_row("
            select *
              from mt_tag
             where tag_id=$tag_id
        ", ARRAY_A);
        $this->_tag_id_cache[$tag_id] = $tag;
        return $tag;
    }

    function &fetch_tag_by_name($tag_name) {
        $tag_name = $this->escape($tag_name);
        $tag = $this->get_row("
            select *
              from mt_tag
             where tag_name='$tag_name'
        ", ARRAY_A);
        $this->_tag_id_cache[$tag['tag_id']] = $tag;
        return $tag;
    }

    function fetch_scores($namespace, $obj_id, $datasource) {
        $scores = $this->get_results("
            select * from mt_objectscore
            where objectscore_namespace='$namespace'
            and objectscore_object_id='$obj_id'
            and objectscore_object_ds='$datasource'
        ", ARRAY_A);
        return $scores;
    }

    function fetch_score($namespace, $obj_id, $user_id, $datasource) {
        list($score) = $this->get_results("
            select * from mt_objectscore
            where objectscore_namespace='$namespace'
            and objectscore_object_id='$obj_id'
            and objectscore_object_ds='$datasource'
            and objectscore_author_id='$user_id'
        ", ARRAY_A);
        return $score;
    }

    function fetch_sum_scores($namespace, $datasource, $order, $filters) {
        $othertables = '';
        $otherwhere = '';
        if ($datasource == 'asset') {
            $othertables = ', mt_author';
            $otherwhere = 'AND (objectscore_author_id = author_id)';
        }
        $join_column = $datasource . '_id';
        $join_where = "AND ($join_column = objectscore_object_id)";
        $sql_scores = 
            "SELECT SUM(objectscore_score) AS sum_objectscore_score, objectscore_object_id
             FROM mt_objectscore, mt_$datasource $othertables
             WHERE (objectscore_namespace = '$namespace')
             AND (objectscore_object_ds = '$datasource')
             $join_where
             $otherwhere
             $filters
             GROUP BY objectscore_object_id 
             ORDER BY sum_objectscore_score " . $order;
        $scores = $this->get_results($sql_scores, ARRAY_A);
        return $scores;
    }

    function fetch_avg_scores($namespace, $datasource, $order, $filters) {
        $othertables = '';
        $otherwhere = '';
        if ($datasource == 'asset') {
            $othertables = ', mt_author';
            $otherwhere = 'AND (objectscore_author_id = author_id)';
        }
        $join_column = $datasource . '_id';
        $join_where = "AND ($join_column = objectscore_object_id)";
        $sql_scores = 
            "SELECT AVG(objectscore_score) AS sum_objectscore_score, objectscore_object_id
             FROM mt_objectscore, mt_$datasource $othertables
             WHERE (objectscore_namespace = '$namespace')
             AND (objectscore_object_ds = '$datasource')
             $join_where
             $otherwhere
             $filters
             GROUP BY objectscore_object_id 
             ORDER BY sum_objectscore_score " . $order;
        $scores = $this->get_results($sql_scores, ARRAY_A);
        return $scores;
    }

    function cache_permalinks(&$entry_list) {
        $id_list = '';
        foreach ($entry_list as $entry_id) {
            if (!isset($this->_entry_link_cache[$entry_id.';Individual'])) {
                $id_list .= ','.$entry_id;
                $this->_entry_link_cache[$entry_id.';Individual'] = ''; 
            }
        }
        if (empty($id_list))
            return;
        $id_list = substr($id_list, 1);
        $query = "
            select fileinfo_entry_id, fileinfo_url, blog_site_url, blog_file_extension, blog_archive_url
              from mt_fileinfo, mt_templatemap, mt_blog
             where fileinfo_entry_id in ($id_list)
               and fileinfo_archive_type = 'Individual'
               and blog_id = fileinfo_blog_id
               and templatemap_id = fileinfo_templatemap_id
               and templatemap_is_preferred = 1
        ";
        $results = $this->get_results($query, ARRAY_N);
        if ($results) {

            foreach ($results as $row) {
                $blog_url = $row[4];
                $blog_url or $blog_url = $row[2];
                $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
                $url = $blog_url . $row[1];
                $url = _strip_index($url, array('blog_file_extension' => $row[3]));
                $this->_entry_link_cache[$row[0].';Individual'] = $url;
            }
        }
    }

    function cache_category_links(&$cat_list) {
        $id_list = '';
        foreach ($cat_list as $cat_id) {
            if (!isset($this->_cat_link_cache[$cat_id])) {
                $id_list .= ','.$cat_id;
                $this->_cat_link_cache[$cat_id] = '';
            }
        }
        if (empty($id_list))
            return;
        $id_list = substr($id_list, 1);
        $query = "
            select fileinfo_category_id, fileinfo_url, blog_site_url, blog_file_extension, blog_archive_url
              from mt_fileinfo, mt_templatemap, mt_blog
             where fileinfo_category_id in ($id_list)
               and fileinfo_archive_type = 'Category'
               and blog_id = fileinfo_blog_id
               and templatemap_id = fileinfo_templatemap_id
               and templatemap_is_preferred = 1
        ";
        $results = $this->get_results($query, ARRAY_N);
        if ($results) {
            foreach ($results as $row) {
                $blog_url = $row[4];
                $blog_url or $blog_url = $row[2];
                $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
                $url = $blog_url . $row[1];
                $url = _strip_index($url, array('blog_file_extension' => $row[3]));
                $this->_cat_link_cache[$row[0]] = $url;
            }
        }
    }

    function cache_comment_counts(&$entry_list) {
        $id_list = '';
        foreach ($entry_list as $entry_id) {
            if (!isset($this->_comment_count_cache[$entry_id])) {
                $id_list .= ','.$entry_id;
                $this->_comment_count_cache[$entry_id] = 0;
            }
        }
        if (empty($id_list))
            return;
        $id_list = substr($id_list, 1);
        $query = "
            select entry_id, entry_comment_count
              from mt_entry
             where entry_id in ($id_list)
        ";
        $results = $this->get_results($query, ARRAY_N);
        if ($results) {
            foreach ($results as $row) {
                $this->_comment_count_cache[$row[0]] = $row[1];
            }
        }
    }

    function blog_entry_count($args) {

        if ($sql = $this->include_exclude_blogs($args)) {
            $blog_filter = 'and entry_blog_id ' . $sql;
        } elseif (isset($args['blog_id'])) {
            $blog_id = intval($args['blog_id']);
            $blog_filter = 'and entry_blog_id = ' . $blog_id;
        }
        $class = 'entry';
        if (isset($args['class'])) {
            $class = $args['class'];
        }
        $count = $this->get_var("
          select count(*)
            from mt_entry
            where entry_status = 2
            and entry_class='$class'
            $blog_filter
            ");
        return $count;
    }

    function blog_comment_count($args) {

        if ($sql = $this->include_exclude_blogs($args)) {
            $blog_filter = 'and comment_blog_id ' . $sql;
        } elseif (isset($args['blog_id'])) {
            $blog_id = intval($args['blog_id']);
            $blog_filter = 'and comment_blog_id = ' . $blog_id;
        }

        $count = $this->get_var("
            select count(*)
              from mt_entry, mt_comment
             where entry_status = 2
               and comment_visible = 1
               and comment_entry_id = entry_id
               $blog_filter
        ");
        return $count;
    }

    function category_comment_count($args) {
        $cat_id = (int)$args['category_id'];
        $sql = "select count(*)
             from mt_placement, mt_comment, mt_entry
            where placement_category_id=$cat_id
              and entry_id=placement_entry_id
              and entry_status=2
              and comment_entry_id=entry_id
              and comment_visible=1";
        return $this->get_var($sql);
    }

    function blog_ping_count($args) {

        if ($sql = $this->include_exclude_blogs($args)) {
            $blog_filter = 'and tbping_blog_id ' . $sql;
        } elseif (isset($args['blog_id'])) {
            $blog_id = intval($args['blog_id']);
            $blog_filter = 'and tbping_blog_id = ' . $blog_id;
        }

        $count = $this->get_var("
            select count(*)
              from mt_tbping, mt_trackback
             where tbping_visible = 1
               and tbping_tb_id = trackback_id
                   $blog_filter
        ");
        return $count;
    }

    function blog_category_count($args) {

        if ($sql = $this->include_exclude_blogs($args)) {
            $blog_filter = 'and category_blog_id ' . $sql;
        } elseif (isset($args['blog_id'])) {
            $blog_id = intval($args['blog_id']);
            $blog_filter = 'and category_blog_id = ' . $blog_id;
        }
        $count = $this->get_var("
            select count(*)
              from mt_category
             where 1 = 1
             $blog_filter
        ");
        return $count;
    }

    function tags_entry_count($tag_id, $class = 'entry') {
        $count = $this->get_var("
          select count(*)
            from mt_objecttag, mt_entry
           where objecttag_tag_id = " . intval($tag_id) . "
             and entry_id = objecttag_object_id and objecttag_object_datasource='entry'
             and entry_status = 2
             and entry_class = '$class'
        ");
        return $count;
    }

    function entry_comment_count($entry_id) {
        if (isset($this->_comment_count_cache[$entry_id])) {
            return $this->_comment_count_cache[$entry_id];
        }
        $entry = $this->fetch_entry($entry_id);
        $count = $entry['entry_comment_count'];
        $this->_comment_count_cache[$entry_id] = $count;
        return $count;
    }

    function author_entry_count($args) {
        if ($sql = $this->include_exclude_blogs($args)) {
            $blog_filter = 'and entry_blog_id ' . $sql;
        } elseif (isset($args['blog_id'])) {
            $blog_id = intval($args['blog_id']);
            $blog_filter = 'and entry_blog_id = ' . $blog_id;
        }
        if (isset($args['author_id'])) {
            $author_id = intval($args['author_id']);
            $author_filter = " and entry_author_id = $author_id";
        }
        if (isset($args['class'])) {
            $class = $args['class'];
        }
        $count = $this->get_var("
          select count(*)
            from mt_entry
            where entry_status = 2
            and entry_class='$class'
            $blog_filter
            $author_filter
            ");
        return $count;
    }

    function &fetch_placements($args) {
        $category_id_list = $args['category_id'];
        $id_list = '';
        foreach ($category_id_list as $cat_id) {
            $id_list .= ',' . $cat_id;
        }
        if (empty($id_list))
            return;
        $id_list = substr($id_list, 1);
        $sql = "
            select mt_placement.*
              from mt_placement, mt_entry
              where placement_category_id in ($id_list)
               and entry_id = placement_entry_id and entry_status = 2
        ";
        $results = $this->get_results($sql, ARRAY_A);
        return $results;
    }

    function &fetch_objecttags($args) {
        $tag_id_list = $args['tag_id'];
        $id_list = '';
        foreach ($tag_id_list as $tag_id) {
            $id_list .= ',' . $tag_id;
        }
        if (empty($id_list))
            return;
        $id_list = substr($id_list, 1);

        $blog_filter = $this->include_exclude_blogs($args);
        if ($blog_filter == '' and $args['blog_id'])
            $blog_filter = intval($args['blog_id']);
        if ($blog_filter != '') 
            $blog_filter = 'and objecttag_blog_id = ' . $blog_filter;

        if (isset($args['datasource']) && strtolower($args['datasource']) == 'asset') {
            $datasource = $args['datasource'];
            $from_object = 'mt_asset';
            $object_filter = 'and asset_id = objecttag_object_id';
        } else {
            $datasource = 'entry';
            $from_object = 'mt_entry';
            $object_filter = 'and entry_id = objecttag_object_id and entry_status = 2';
        }
        $sql = "
            select mt_objecttag.*
              from mt_objecttag, $from_object
              where
                objecttag_object_datasource ='$datasource'
                and objecttag_tag_id in ($id_list)
                $blog_filter
                $object_filter
        ";
        $results = $this->get_results($sql, ARRAY_A);
        return $results;
    }

    function &fetch_comments($args) {
        # load comments
        $entry_id = intval($args['entry_id']);

        $sql = $this->include_exclude_blogs($args);
        if ($sql != '') {
            $blog_filter = 'and comment_blog_id ' . $sql;
            if (isset($args['blog_id']))
                $blog =& $this->fetch_blog($args['blog_id']);
        } elseif ($args['blog_id']) {
            $blog =& $this->fetch_blog($args['blog_id']);
            $blog_filter = ' and comment_blog_id = ' . $blog['blog_id'];
        }

        # Adds a score or rate filter to the filters list.
        if (isset($args['namespace'])) {
            require_once("MTUtil.php");
            $arg_names = array('min_score', 'max_score', 'min_rate', 'max_rate', 'min_count', 'max_count' );
            foreach ($arg_names as $n) {
                if (isset($args[$n])) {
                    $comment_args = $args[$n];
                    $cexpr = create_rating_expr_function($comment_args, $n, $args['namespace'], 'comment');
                    if ($cexpr) {
                        $filters[] = $cexpr;
                    } else {
                        return null;
                    }
                }
            }
            if (isset($args['scored_by'])) {
                $voter = $this->fetch_author_by_name($args['scored_by']);
                if (!$voter) {
                    echo "Invalid scored by filter: ".$args['scored_by'];
                    return null;
                }
                $cexpr = create_rating_expr_function($voter['author_id'], 'scored_by', $args['namespace'], 'comment');
                if ($cexpr) {
                    $filters[] = $cexpr;
                } else {
                    return null;
                }
            }
        }

        $order = $query_order = 'desc';
        if (isset($args['sort_order'])) {
            if ($args['sort_order'] == 'ascend') {
                $order = $query_order = 'asc';
            }
        } elseif (isset($blog) && isset($blog['blog_sort_order_comments'])) {
            if ($blog['blog_sort_order_comments'] == 'ascend') {
                $order = $query_order = 'asc';
            }
        }
        if ($order == 'asc' && (isset($args['lastn']) || isset($args['offset']))) {
            $reorder = 1;
            $query_order = 'desc';
        }

        if ($entry_id) {
            $entry_filter = " and comment_entry_id = $entry_id";
            $entry_join = "join mt_entry on entry_id = comment_entry_id";
        } else {
            $entry_join = "join mt_entry on entry_id = comment_entry_id and entry_status = 2";
        }

        $join_score = "";
        $distinct = "";
        if ( isset($args['sort_by'])
          && (($args['sort_by'] == 'score') || ($args['sort_by'] == 'rate')) ) {
            $join_score = "join mt_objectscore on objectscore_object_id = comment_id and objectscore_namespace='".$args['namespace']."' and objectscore_object_ds='comment'";
            $distinct = " distinct";
        }

        $limit = 0;
        $offset = 0;
        if (isset($args['lastn']))
            $limit = $args['lastn'];
        if (isset($args['limit']))
            $limit = $args['limit'];
        if (isset($args['offset']))
            $offset = $args['offset'];
        if (count($filters)) {
            $post_select_limit = $limit;
            $post_select_offset = $offset;
            $limit = 0; $offset = 0;
        }

        $sql = "
            select $distinct
                   mt_comment.*,
                   mt_entry.*
              from mt_comment
                   $entry_join
                   $join_score
             where comment_visible = 1
                   $entry_filter
                   $blog_filter
             order by comment_created_on $query_order
                   <LIMIT>";
        $sql = $this->apply_limit_sql($sql, $limit, $offset);

        # Fetch resultset
        $result = $this->query_start($sql);
        if (!$result) return null;

        $comments = array();
        $j = 0;
        while (true) {
            $e = $this->query_fetch(ARRAY_A);
            if (!isset($e)) break;
            if (count($filters)) {
                foreach ($filters as $f) {
                    if (!$f($e, $ctx)) continue 2;
                }
                if ($post_select_offset && ($j++ < $post_select_offset)) continue;
                if (($post_select_limit > 0) && (count($comments) >= $post_select_limit)) break;
            }
            $comments[] = $e;
        }

        if (isset($args['sort_by']) && ('score' == $args['sort_by'])) {
            $comments_tmp = array();
            foreach ($comments as $c) {
                $comments_tmp[$c['comment_id']] = $c;
            }
            $scores = $this->fetch_sum_scores($args['namespace'], 'comment', $order,
                $blog_filter . "\n" .
                $entry_filter . "\n"
            );
            $comments_sorted = array();
            foreach($scores as $score) {
                if (array_key_exists($score['objectscore_object_id'], $comments_tmp)) {
                    array_push($comments_sorted, $comments_tmp[$score['objectscore_object_id']]);
                    unset($comments_tmp[$score['objectscore_object_id']]);
                }
            }
            foreach ($comments_tmp as $et) {
                array_push($comments_sorted, $et);
            }
            $comments = $comments_sorted;
        } elseif (isset($args['sort_by']) && ('rate' == $args['sort_by'])) {
            $comments_tmp = array();
            foreach ($comments as $c) {
                $comments_tmp[$c['comment_id']] = $c;
            }
            $scores = $this->fetch_avg_scores($args['namespace'], 'comment', $order,
                $blog_filter . "\n" .
                $entry_filter . "\n"
            );
            $comments_sorted = array();
            foreach($scores as $score) {
                if (array_key_exists($score['objectscore_object_id'], $comments_tmp)) {
                    array_push($comments_sorted, $comments_tmp[$score['objectscore_object_id']]);
                    unset($comments_tmp[$score['objectscore_object_id']]);
                }
            }
            foreach ($comments_tmp as $et) {
                array_push($comments_sorted, $et);
            }
            $comments = $comments_sorted;
        }

        if (!is_array($comments))
            return array();

        if ($reorder && !isset($args['sort_by'])) {  // lastn and ascending sort
            $asc_created_on = create_function('$a,$b', 'return strcmp($a["comment_created_on"], $b["comment_created_on"]);');
            usort($comments, $asc_created_on);
        }

        return $comments;
    }

    function &fetch_comment_parent($args) {
        if (!$args['parent_id']) {
            return array();
        }
        $parent_id = intval($args['parent_id']);

        $sql = $this->include_exclude_blogs($args);
        if ($sql != '') {
            $blog_filter = 'and comment_blog_id ' . $sql;
            if (isset($args['blog_id']))
                $blog =& $this->fetch_blog($args['blog_id']);
        } elseif ($args['blog_id']) {
            $blog =& $this->fetch_blog($args['blog_id']);
            $blog_filter = ' and comment_blog_id = ' . $blog['blog_id'];
        }

        $sql = "
            select *
              from mt_comment
             where 1 = 1
                   $blog_filter
               and comment_id = $parent_id
               and comment_visible = 1
        ";
        $comment = $this->get_results($sql, ARRAY_A);

        return $comment;
    }

    function &fetch_comment_replies($args) {
        if (!$args['comment_id']) {
            return array();
        }
        $comment_id = intval($args['comment_id']);

        $sql = $this->include_exclude_blogs($args);
        if ($sql != '') {
            $blog_filter = 'and comment_blog_id ' . $sql;
            if (isset($args['blog_id']))
                $blog =& $this->fetch_blog($args['blog_id']);
        } elseif ($args['blog_id']) {
            $blog =& $this->fetch_blog($args['blog_id']);
            $blog_filter = ' and comment_blog_id = ' . $blog['blog_id'];
        }

        $order = 'asc';
        if (isset($args['sort_order'])) {
            if ($args['sort_order'] == 'descend') {
                $order = 'desc';
            }
        } elseif (isset($blog) && isset($blog['blog_sort_order_comments'])) {
            if ($blog['blog_sort_order_comments'] == 'ascend') {
                $order = 'asc';
            }
        }
        if ($order == 'asc' && $args['lastn']) {
            $reorder = 1;
            $order = 'desc';
        }
        $sql = "
            select *
              from mt_comment
             where 1 = 1
                   $blog_filter
               and comment_parent_id = $comment_id
               and comment_visible = 1
             order by comment_created_on $order
                   <LIMIT>";
        $sql = $this->apply_limit_sql($sql, $args['lastn'], $args['offset']);
        $comments = $this->get_results($sql, ARRAY_A);
        if (!is_array($comments))
            return array();

        if ($reorder) {  // lastn and ascending sort
            $asc_created_on = create_function('$a,$b', 'return strcmp($a["comment_created_on"], $b["comment_created_on"]);');
            usort($comments, $asc_created_on);
        }
  
        return $comments;
    }

    function cache_ping_counts(&$entry_list) {
        $id_list = '';
        foreach ($entry_list as $entry_id) {
            if (!isset($this->_ping_count_cache[$entry_id])) {
                $id_list .= ','.$entry_id;
                $this->_ping_count_cache[$entry_id] = 0;
            }
        }
        $id_list = substr($id_list, 1);
        if (empty($id_list))
            return;
        $query = "
            select entry_id, entry_ping_count
              from mt_entry
             where entry_id in ($id_list)
        ";
        $results = $this->get_results($query, ARRAY_N);
        if ($results) {
            foreach ($results as $row) {
                $this->_ping_count_cache[$row[0]] = $row[1];
            }
        }
    }

    function entry_ping_count($entry_id) {
        if (isset($this->_ping_count_cache[$entry_id])) {
            return $this->_ping_count_cache[$entry_id];
        }
        $entry = $this->fetch_entry($entry_id);
        $count = $entry['entry_ping_count'];
        $this->_ping_count_cache[$entry_id] = $count;
        return $count;
    }

    function category_ping_count($cat_id) {
        $count = $this->get_var("
            select count(*)
              from mt_trackback, mt_tbping
             where trackback_category_id = " . intval($cat_id) . "
               and tbping_visible = 1
               and tbping_tb_id = trackback_id 
        ");
        return $count;
    }

    function &fetch_pings($args) {
        $entry_id = $args['entry_id'];
        # load pings  
        $sql = $this->include_exclude_blogs($args);
        if ($sql != '') {
            $blog_filter = 'and tbping_blog_id ' . $sql;
            if (isset($args['blog_id']))
                $blog =& $this->fetch_blog($args['blog_id']);
        } elseif ($args['blog_id']) {
            $blog =& $this->fetch_blog($args['blog_id']);
            $blog_filter = ' and tbping_blog_id = ' . $blog['blog_id'];
        }
        $order = isset($args['lastn']) ? 'desc' : 'asc';
        if (isset($args['sort_order'])) {
            if ($args['sort_order'] == 'descend') {
                $order = 'desc';
            } elseif ($args['sort_order'] == 'ascend') {
                $order = 'asc';
            }
        }
        if ($entry_id)
            $entry_filter = 'and trackback_entry_id = ' . intval($entry_id);
        $sql = "
            select mt_trackback.*, mt_tbping.*, mt_entry.entry_class
              from mt_trackback, mt_tbping, mt_entry
             where tbping_tb_id = trackback_id
             and trackback_entry_id = entry_id
               $entry_filter
               $blog_filter
               and tbping_visible = 1
             order by tbping_created_on $order
                   <LIMIT>";
        $sql = $this->apply_limit_sql($sql, $args['lastn'], $args['offset']);
        $pings = $this->get_results($sql, ARRAY_A);
        return $pings;
    }

    function cache_categories(&$entry_list) {
        $id_list = '';
        foreach ($entry_list as $entry_id) {
            if (!isset($this->_cat_id_cache['e'.$entry_id])) {
                $id_list .= ','.$entry_id;
            }
        }
        $id_list = substr($id_list, 1);
        if (!$id_list)
            return;
        $query = "
            select *
              from mt_category, mt_placement
             where placement_entry_id in ($id_list)
               and placement_category_id = category_id
               and placement_is_primary = 1
        ";
        $results = $this->get_results($query, ARRAY_A);
        foreach ($entry_list as $entry_id) {
            $this->_cat_id_cache['e'.$entry_id] = null;
        }
        if (is_array($results)) {
            foreach ($results as $row) {
                $entry_id = $row['placement_entry_id'];
                $this->_cat_id_cache['e'.$entry_id] = $row;
                $cat_id = $row['category_id'];
                $this->_cat_id_cache['c'.$cat_id] = $row;
            }
        }
    }

    function &fetch_folder($cat_id) {
        if (isset($this->_cat_id_cache['c'.$cat_id])) {
            return $this->_cat_id_cache['c'.$cat_id];
        }

        $cats =& $this->fetch_categories(array('category_id' => $cat_id, 'show_empty' => 1, 'class' => 'folder'));
        if ($cats && (count($cats) > 0)) {
            $this->_cat_id_cache['c'.$cat_id] = $cats[0];
            return $cats[0];
        } else {
            return null;
        }
    }

    function &fetch_category($cat_id) {
        if (isset($this->_cat_id_cache['c'.$cat_id])) {
            return $this->_cat_id_cache['c'.$cat_id];
        }
        $cats =& $this->fetch_categories(array('category_id' => $cat_id, 'show_empty' => 1));
        if ($cats && (count($cats) > 0)) {
            $this->_cat_id_cache['c'.$cat_id] = $cats[0];
            return $cats[0];
        } else {
            return null;
        }
    }

    function &fetch_blog($blog_id) {
        if (isset($this->_blog_id_cache[$blog_id])) {
            return $this->_blog_id_cache[$blog_id];
        }
        list($blog) = $this->load('blog', $blog_id);
        $this->_blog_id_cache[$blog_id] = $blog;
        return $blog;
    }

    function &get_archive_list($args) {
        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];

        $group_sql = $this->archive_list_sql($args);
        $results = $this->get_results($group_sql, ARRAY_N);
        if (is_array($results)) {
            if ($at == 'Daily') {
                $hi = sprintf("%04d%02d%02d", $results[0][1], $results[0][2], $results[0][3]);
                $low = sprintf("%04d%02d%02d", $results[count($results)-1][1], $results[count($results)-1][2], $results[count($results)-1][3]);
            } elseif ($at == 'Weekly') {
                require_once("MTUtil.php");
                $week_yr = substr($results[0][1], 0, 4);
                $week_num = substr($results[0][1], 4);
                list($y,$m,$d) = week2ymd($week_yr, $week_num);
                $hi = sprintf("%04d%02d%02d", $y, $m, $d);
                $week_yr = substr($results[count($results)-1][1], 0, 4);
                $week_num = substr($results[count($results)-1][1], 4);
                list($y,$m,$d) = week2ymd($week_yr, $week_num);
                $low = sprintf("%04d%02d%02d", $y, $m, $d);
            } elseif ($at == 'Monthly') {
                $hi = sprintf("%04d%02d32", $results[0][1], $results[0][2]);
                $low = sprintf("%04d%02d00", $results[count($results)-1][1], $results[count($results)-1][2]);
            } elseif ($at == 'Yearly') {
                $hi = sprintf("%04d0000", $results[0][1]);
                $low = sprintf("%04d0000", $results[count($results)-1][1]);
            } elseif ($at == 'Individual') {
                $hi = $results[0][1];
                $low = $results[count($results)-1][1];
            }
            $range = "'$low' and '$hi'";
            $link_cache_sql = "
                select fileinfo_startdate, fileinfo_url, blog_site_url, blog_file_extension, blog_archive_url
                  from mt_fileinfo, mt_templatemap, mt_blog
                 where fileinfo_startdate between $range
                   and fileinfo_archive_type = '$at'
                   and blog_id = $blog_id
                   and fileinfo_blog_id = blog_id
                   and templatemap_id = fileinfo_templatemap_id
                   and templatemap_is_preferred = 1
            ";
            $cache_results = $this->get_results($link_cache_sql, ARRAY_N);
            if (is_array($cache_results)) {
                foreach ($cache_results as $row) {
                    $date = $this->db2ts($row[0]);
                    if ($at == 'Page') {
                        $blog_url = $row[2];
                    } else {
                        $blog_url = $row[4];
                        $blog_url or $blog_url = $row[2];
                    }
                    $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
                    $url = $blog_url . $row[1];
                    $url = _strip_index($url, array('blog_file_extension' => $row[3]));
                    $this->_archive_link_cache[$date.';'.$at] = $url;
                }
            }
        }
        return $results;
    }

    function asset_count($args) {
        if (isset($args['blog_id'])) {
            $blog_filter = 'and asset_blog_id = '.intval($args['blog_id']);
        }

        # Adds a type filter
        if (isset($args['type'])) {
            $type_filter = "and asset_class ='" . $args['type'] . "'";
        }

        $count = $this->get_var("
            select count(*)
              from mt_asset
             where
                   1 = 1
                   $blog_filter
                   $type_filter
        ");
        return $count;
    }

    function fetch_assets($args) {
        # load assets

        if (isset($args['blog_id'])) {
            $blog_filter = 'and asset_blog_id = '.intval($args['blog_id']);
        }

        # Adds a thumbnail filter to the filters list.
        if(isset($args['exclude_thumb']) && $args['exclude_thumb']) {
           $thumb_filter = ' and asset_parent is null'; 
        }
        
        # Adds a tag filter to the filters list.
        if (isset($args['tags']) or isset($args['tag'])) {
            $tag_arg = isset($args['tag']) ? $args['tag'] : $args['tags'];
            require_once("MTUtil.php");
            if (!preg_match('/\b(AND|OR|NOT)\b|\(|\)/i', $tag_arg)) {
                $not_clause = false;
            } else {
                $not_clause = preg_match('/\bNOT\b/i', $tag_arg);
            }

            $include_private = 0;
            $tag_array = tag_split($tag_arg);
            foreach ($tag_array as $tag) {
                if ($tag && (substr($tag,0,1) == '@')) {
                    $include_private = 1;
                }
            }

            $tags =& $this->fetch_asset_tags(array('blog_id' => $blog_id, 'tag' => $tag_arg, 'include_private' => $include_private));
            if (!is_array($tags)) $tags = array();
            $cexpr = create_tag_expr_function($tag_arg, $tags, 'asset');

            if ($cexpr) {
                $tmap = array();
                $tag_list = array();
                foreach ($tags as $tag) {
                    $tag_list[] = $tag['tag_id'];
                }
                $ot =& $this->fetch_objecttags(array('tag_id' => $tag_list, 'datasource' => 'asset'));
                if ($ot) {
                    foreach ($ot as $o) {
                        $tmap[$o['objecttag_object_id']][$o['objecttag_tag_id']]++;
                        if (!$not_clause)
                            $asset_list[$o['objecttag_object_id']] = 1;
                    }
                }
                $ctx['t'] =& $tmap;
                $filters[] = $cexpr;
            } else {
                return null;
            }
        }

        # Adds an author filter
        if (isset($args['author'])) {
            $author_filter = 'and author_name = \''.$this->escape($args['author']) . "'";
        }

        # Adds an entry filter
        if (isset($args['entry_id'])) {
            $entry_filter = 'and (objectasset_object_ds = \'entry\' and objectasset_object_id = \'' . $this->escape($args['entry_id']) . '\' and asset_id = objectasset_asset_id)';
            $entry_join = ', mt_objectasset.*';
            $entry_join_tbl = ', mt_objectasset';
        }

        # Adds an ID filter
        if (isset($args['id']))
            $id_filter = 'and asset_id = '.$args['id'];

        # Adds a days filter
        if (isset($args['days'])) {
            $day_filter = 'and ' . $this->limit_by_day_sql('asset_created_on', intval($args['days']));
        }

        # Adds a type filter
        if (isset($args['type'])) {
            $type_filter = "and asset_class ='" . $args['type'] . "'";
        }

        # Adds a file extension filter
        if (isset($args['file_ext'])) {
            $ext_filter = "and asset_file_ext ='" . $args['file_ext'] . "'";
        }

        # Adds a score or rate filter to the filters list.
        if (isset($args['namespace'])) {
            require_once("MTUtil.php");
            $arg_names = array('min_score', 'max_score', 'min_rate', 'max_rate', 'min_count', 'max_count' );
            foreach ($arg_names as $n) {
                if (isset($args[$n])) {
                    $rating_args = $args[$n];
                    $cexpr = create_rating_expr_function($rating_args, $n, $args['namespace'], 'asset');
                    if ($cexpr) {
                        $filters[] = $cexpr;
                    } else {
                        return null;
                    }
                }
            }

            if (isset($args['scored_by'])) {
                $voter = $this->fetch_author_by_name($args['scored_by']);
                if (!$voter) {
                    echo "Invalid scored by filter: ".$args['scored_by'];
                    return null;
                }
                $cexpr = create_rating_expr_function($voter['author_id'], 'scored_by', $args['namespace'], 'asset');
                if ($cexpr) {
                    $filters[] = $cexpr;
                } else {
                    return null;
                }
            }
        }

        # Adds sort order
        $order = 'desc';
        $sort_by = 'asset_created_on';
        if (isset($args['sort_order'])) {
            if ($args['sort_order'] == 'ascend')
                $order = 'asc';
            else if ($args['sort_order'] == 'descend')
                $order = 'desc';
        }
        
        if (isset($args['sort_by'])) {
            if ('score' != $args['sort_by'] && 'rate' != $args['sort_by']) {
                $sort_by = 'asset_' . $args['sort_by'];
            }
        }
        if (isset($args['lastn']))
            $order = 'desc';

        $join_score = "";
        $distinct = "";
        if ( isset($args['sort_by'])
          && (($args['sort_by'] == 'score') || ($args['sort_by'] == 'rate')) ) {
            $join_score = "left join mt_objectscore on objectscore_object_id = asset_id";
            $distinct = " distinct";
        }
        
        $limit = 0;
        $offset = 0;
        if (isset($args['lastn']))
            $limit = $args['lastn'];
        if (isset($args['limit']))
            $limit = $args['limit'];
        if (isset($args['offset']))
            $offset = $args['offset'];

        if (count($filters)) {
            $post_select_limit = $limit;
            $post_select_offset = $offset;
            $limit = 0; $offset = 0;
        }

        # Build SQL
        $sql = "
            select $distinct mt_asset.*, mt_author.* $entry_join
            from mt_asset $join_score, mt_author $entry_join_tbl
            where
                author_id = asset_created_by
                $id_filter
                $blog_filter
                $author_filter
                $entry_filter
                $day_filter
                $type_filter
                $ext_filter
                $thumb_filter
            order by
                $sort_by $order
                <LIMIT>
        ";

        # Added Limit and offset
        $sql = $this->apply_limit_sql($sql, $limit, $offset);

        # Fetch resultset
        $result = $this->query_start($sql);
        if (!$result) return null;
        $assets = array();
        $offset = $post_select_offset ? $post_select_offset : 0;
        $limit = $post_select_limit ? $post_select_limit : 0;

        while (true) {
            $e = $this->query_fetch(ARRAY_A);
            if ($offset && ($j++ < $offset)) continue;
            if (!isset($e)) break;
            if (count($filters)) {
                foreach ($filters as $f) {
                    if (!$f($e, $ctx)) continue 2;
                }
            }
            $e = $this->expand_meta($e);
            $assets[] = $e;
            if (($limit > 0) && (count($assets) >= $limit)) break;
        }

        $order = 'desc';
        if (isset($args['sort_order'])) {
            if ($args['sort_order'] == 'ascend')
                $order = 'asc';
            else if ($args['sort_order'] == 'descend')
                $order = 'desc';
        }
        if (isset($args['sort_by']) && ('score' == $args['sort_by'])) {
            $assets_tmp = array();
            foreach ($assets as $a) {
                $assets_tmp[$a['asset_id']] = $a;
            }
            $scores = $this->fetch_sum_scores($args['namespace'], 'asset', $order,
                $id_filter . "\n" .
                $blog_filter . "\n" .
                $author_filter . "\n" .
                $day_filter . "\n" .
                $type_filter . "\n" .
                $ext_filter . "\n" .
                $thumb_filter . "\n"
            );
            $assets_sorted = array();
            foreach($scores as $score) {
                if (array_key_exists($score['objectscore_object_id'], $assets_tmp)) {
                    array_push($assets_sorted, $assets_tmp[$score['objectscore_object_id']]);
                    unset($assets_tmp[$score['objectscore_object_id']]);
                }
            }
            foreach ($assets_tmp as $et) {
                if ($order == 'asc')
                    array_unshift($assets_sorted, $et);
                else
                    array_push($assets_sorted, $et);
            }
            $assets = $assets_sorted;

        } elseif (isset($args['sort_by']) && ('rate' == $args['sort_by'])) {
            $assets_tmp = array();
            foreach ($assets as $a) {
                $assets_tmp[$a['asset_id']] = $a;
            }
            $scores = $this->fetch_avg_scores($args['namespace'], 'asset', $order,
                $id_filter . "\n" .
                $blog_filter . "\n" .
                $author_filter . "\n" .
                $day_filter . "\n" .
                $type_filter . "\n" .
                $ext_filter . "\n" .
                $thumb_filter . "\n"
            );
            $assets_sorted = array();
            foreach($scores as $score) {
                if (array_key_exists($score['objectscore_object_id'], $assets_tmp)) {
                    array_push($assets_sorted, $assets_tmp[$score['objectscore_object_id']]);
                    unset($assets_tmp[$score['objectscore_object_id']]);
                }
            }
            foreach ($assets_tmp as $et) {
                if ($order == 'asc')
                    array_unshift($assets_sorted, $et);
                else
                    array_push($assets_sorted, $et);
            }
            $assets = $assets_sorted;

        }
        return $assets;
    }

    function archive_list_sql($args) {
        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $year_ext = $this->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $this->apply_extract_date('month', 'entry_authored_on');
        $day_ext = $this->apply_extract_date('day', 'entry_authored_on');

        $date_filter = '';
        $inside = $args['inside_archive_list'];
        if ($inside) {
            $ts = $args['current_timestamp'];
            $tsend = $args['current_timestamp_end'];
            if ($ts && $tsend) {
                $ts = $this->ts2db($ts);
                $tsend = $this->ts2db($tsend);
                $date_filter = "and (entry_authored_on between '$ts' and '$tsend')";
            }
        }

        if ($at == 'Daily') {
            $sql = "
                select count(*),
                       $year_ext as y,
                       $month_ext as m,
                       $day_ext as d
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                   and entry_class = 'entry'
                   $date_filter
                 group by
                       $year_ext,
                       $month_ext,
                       $day_ext
                 order by
                       $year_ext $order,
                       $month_ext $order,
                       $day_ext $order
                       <LIMIT>";
        } elseif ($at == 'Weekly') {
            $sql = "
                select count(*),
                       entry_week_number
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                   and entry_class = 'entry'
                   $date_filter
                 group by entry_week_number
                 order by entry_week_number $order
                       <LIMIT>";
        } elseif ($at == 'Monthly') {
            $sql = "
                select count(*),
                       $year_ext as y,
                       $month_ext as m
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                   and entry_class = 'entry'
                   $date_filter
                 group by
                       $year_ext,
                       $month_ext
                 order by
                       $year_ext $order,
                       $month_ext $order
                       <LIMIT>";
        } elseif ($at == 'Yearly') {
            $sql = "
                select count(*),
                       $year_ext as y
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                   and entry_class = 'entry'
                 group by
                       $year_ext
                 order by
                       $year_ext $order
                       <LIMIT>";
        } elseif ($at == 'Individual') {
            $sql = "
                select entry_id,
                       entry_authored_on
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                   and entry_class = 'entry'
                 order by entry_authored_on $order
                       <LIMIT>";
        }
        $sql = $this->apply_limit_sql($sql, $args['lastn'], $args['offset']);
        return $sql;
    }

    function db2ts($dbts) {
        $dbts = preg_replace('/[^0-9]/', '', $dbts);
        return $dbts;
    }

    function ts2db($ts) {
        preg_match('/^(\d\d\d\d)?(\d\d)?(\d\d)?(\d\d)?(\d\d)?(\d\d)?$/', $ts, $matches);
        list($all, $y, $mo, $d, $h, $m, $s) = $matches;
        return sprintf("%04d-%02d-%02d %02d:%02d:%02d", $y, $mo, $d, $h, $m, $s);
    }

    function get_results($query = null, $output = ARRAY_A) {
        $old_result = $this->result;
        $rows = parent::get_results($query, $output);
        if (is_array($rows)) {
            $rows = array_map(array($this,"convert_fieldname"), $rows);
        }
        $result = $this->expand_meta($rows);
        $this->result = $old_result;
        return $result;
    }

    function &convert_fieldname($array) {
        return $array;
    }

    function expand_meta($rows) {
        $expanded = array();
        if (is_array($rows)) {
            foreach ($rows as $key => $value) {
                if (is_array($value)) {
                    $expanded[$key] = $this->expand_meta($value);
                } else {
                    if (preg_match('/^(\w+)_id$/', $key, $prefix)) {
                        $type = $prefix[1];
                        unset($data);
                        if (array_key_exists($type, $this->object_meta)) {
                            $data = $this->get_meta($type, $value);
                        }
                        if (isset($data)) {
                            $cols = $this->object_meta[$type];
                            foreach ($cols as $col) {
                                $col = preg_replace('/:.+$/', '', $col); # strip type
                                $expanded[$type . '_' . $col] = $data[$col];
                            }
                        }
                    } 
                    $expanded[$key] = $value;
               }
            }
        }
        return $expanded;
    }

    function get_meta($obj_type, $obj_id) {
        $real_type = $obj_type;
        if ('page' == strtolower($obj_type))
            $real_type = 'entry';
        elseif ('folder' == strtolower($obj_type))
            $real_type = 'category';

        $meta = $this->_meta_cache["${obj_type}_meta_${obj_id}"];
        if (!$meta) {
            $datasource = $real_type;
            $datasource = preg_replace("/^mt_/", "", $datasource);
            $result = $this->get_results("select * from mt_${datasource}_meta  where ${datasource}_meta_${datasource}_id = $obj_id", ARRAY_A);
            $field_prefix = "${datasource}_meta_";
            $meta = array();
            foreach ($result as $cfrow) {
                unset($value);
                unset($field);
                // need to test for each v* column to see which is populated
                // take that value and store for meta row
                foreach ($cfrow as $cffield => $cfvalue) {
                    if (preg_match("/^${field_prefix}v/", $cffield)) {
                        // FIXME: Some DBMS can't distinguish NULL from empty string.
                        // Treat custom field that has empty string the same as field with no data.
                        if (isset($cfvalue) && $cfvalue) {
                            $value = $cfvalue;
                            $field = $cffield;
                            break;
                        }
                    }
                }
                if (isset($value)) {
                    if (preg_match("/_vblob$/", $field)) {
                        # unserialize blob if value is serialized
                        if (preg_match("/^BIN:SERG/", $value)) {
                            $value = $this->unserialize($value);
                        }
                        elseif (preg_match("/^ASC:/", $value)) {
                            $value = preg_replace("/^ASC:/", "", $value);
                        }
                    }
                    $meta[$cfrow["${datasource}_meta_type"]] = $value;
                }
            }
            $this->_meta_cache["${obj_type}_meta_${obj_id}"] = $meta;
        }

        return $meta;
    }

    function include_exclude_blogs(&$args) {
        if (isset($args['blog_ids']) || isset($args['include_blogs'])) {
            // The following are aliased
            $args['blog_ids'] and $args['include_blogs'] = $args['blog_ids'];
            $attr = $args['include_blogs'];
            unset($args['blog_ids']);
            $is_excluded = 0;
        } elseif (isset($args['exclude_blogs'])) {            
            $attr = $args[exclude_blogs];
            $is_excluded = 1;
        } else {
            return;
        }

        if (preg_match('/-/', $attr)) {
            # parse range blog ids out
            $list = preg_split('/\s*,\s*/', $attr);
            $attr = '';
            foreach ($list as $item) {
                if (preg_match('/(\d+)-(\d+)/', $item, $matches)) {
                    for ($i = $matches[1]; $i <= $matches[2]; $i++) {
                        if ($attr != '') $attr .= ',';
                        $attr .= $i;
                    }
                } else {
                    if ($attr != '') $attr .= ',';
                    $attr .= $item;
                }
            }
        }

        $blog_ids = preg_split('/\s*,\s*/', 
                                $attr, 
                                -1, PREG_SPLIT_NO_EMPTY);
        $sql = '';
        if ($is_excluded) {
            $sql = 'not in ( ' . implode(',', $blog_ids) . ' )';            
        } elseif ($args[include_blogs] == 'all') {
            $sql = '> 0';
        } else {
            if (count($blog_ids)) {
                $sql = 'in ( ' . implode(',', $blog_ids) . ' )';
            } else {
                $sql = '> 0';
            }
        }
        return $sql;
    }

    function apply_limit_sql($sql, $limit, $offset = 0) {
        $limit = intval($limit);
        $offset = intval($offset);
        $limitStr = '';
        if ($limit)
            $limitStr = 'limit ' . $limit;
        if ($offset)
            $limitStr .= ' offset ' . $offset;
        $sql = preg_replace('/<LIMIT>/', $limitStr, $sql);
        return $sql;
    }

    function limit_by_day_sql($column, $days) {
        die("abstract function-- implement in child class!");
    }

    function entries_recently_commented_on_sql($subsql) {
        $sql = "
            select distinct
                subs.*
            from
                ($subsql) as subs
                inner join mt_comment on comment_entry_id = entry_id and comment_visible = 1
            order by
                comment_created_on desc
            <LIMIT>
        ";
        return $sql;
    }

    function apply_extract_date($part, $column) {
        return "extract($part from $column)";
    }

    function &fetch_session($id) {
        return $this->fetch_unexpired_session($id);
    }

    function &fetch_unexpired_session($ids, $ttl = 0) {
        $expire_sql = '';
        if (!empty($ttl) && $ttl > 0)
            $expire_sql = "and session_start >= " . (time() - $ttl);
        $key_sql = '';
        if (is_array($ids))
            $key_sql = 'and session_id in (' . join(",", $ids) . ')';
        else
            $key_sql = "and session_id = '$ids'";

        $sql = "
            select session_data
            from mt_session
            where
             session_kind = 'CO'
             $key_sql
             $expire_sql";
        $result = $this->get_results($sql, ARRAY_A);
        return $result;
    }

    function update_session($id, $val) {
        $session = $this->fetch_session($id);
        $sql = '';
        $now = time();
        if (empty($session)) {
            # add new item
            $sql = "
                insert into mt_session
                 (session_id, session_data, session_kind, session_start)
                 values ('$id', '$val', 'CO', $now)";
        } else {
            # update existing item
            $sql = "
                update mt_session set
                  session_data = '$val',
                  session_start = $now
                where
                  session_kind='CO'
                  and session_id = '$id'";
        }
        $this->query($sql);
    }

    function remove_session($id) {
        $sql = "
            delete from mt_session
            where
              session_kind='CO'
              and session_id = '$id'";
        $this->query($sql);
    }

    function flush_session() {
        $sql = "
            delete from mt_session
            where session_kind = 'CO'";
        $this->query($sql);
    }

    function get_latest_touch($blog_id, $types) {
        $type_user = false;
        if (is_array($types)) {
            $array = preg_grep('/author/', $types);
            if (!empty($array)) $type_user = true;
        } else {
            $type_user = $types == 'author';
        }

        $blog_filter = '';
        if (!empty($blog_id)) {
            if ($type_user)
                $blog_filter = 'and touch_blog_id = 0';
            else
                $blog_filter = 'and touch_blog_id = ' . $blog_id;
        }

        $type_filter = '';
        if (!empty($types)) {
            if ($type_user) {
                $type_filter = 'and touch_object_type ="author"';
            } else {
                if (is_array($types)) {
                    foreach ($types as $type) {
                        if ($type_filter != '') $type_filter .= ',';
                        $type_filter .= "'$type'";
                    }
                    $type_filter = 'and touch_object_type in (' . $type_filter . ')';
                } else {
                    $type_filter = 'and touch_object_type ="' . $type_filter . '"';
                }
            }
        }

        $sql = "
            select
                touch_modified_on
            from
                mt_touch
            where
                1 = 1
                $blog_filter
                $type_filter
            order by
                touch_modified_on desc
            <LIMIT>";

        $sql = $this->apply_limit_sql($sql, 1);
        $result = $this->get_row($sql, ARRAY_N);

        if (!empty($result))
            return $result[0];

        return false;
    }

}
