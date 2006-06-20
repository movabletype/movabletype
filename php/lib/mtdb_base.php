<?php
# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
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
    var $serializer;
    var $id;

    function MTDatabaseBase($dbuser, $dbpassword = '', $dbname = '', $dbhost = '', $dbport = '') {
        $this->id = md5(uniqid('MTDatabaseBase',true));
        $this->db($dbuser, $dbpassword, $dbname, $dbhost, $dbport);
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
        $index = $this->escape($mt->config['IndexBasename']);
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

    function load_index_template(&$ctx, $tmpl) {
        return $this->load_special_template($ctx, $tmpl, 'index');
    }

    function load_special_template(&$ctx, $tmpl, $type) {
        $blog_id = $ctx->stash('blog_id');
        $sql = "select * from mt_template where template_blog_id=$blog_id ".($tmpl ? "and (template_name='".$this->escape($tmpl)."' or template_outfile='" . $this->escape($tmpl)."') " : "")."and template_type='".$this->escape($type)."'";
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
            $blog_url = $blog['blog_site_url'];
            $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
            $url = $blog_url . $link['fileinfo_url'];
            $url = _strip_index($url, $blog);
            $this->_cat_link_cache[$cid] = $url;
        }
        return $url;
    }

    function archive_link($ts, $at, $args) {
        $blog_id = intval($args['blog_id']);
        if (isset($this->_archive_link_cache[$blog_id.';'.$ts.';'.$at])) {
            $url = $this->_archive_link_cache[$blog_id.';'.$ts.';'.$at];
        } else {
            $sql = "select fileinfo_url
                      from mt_fileinfo, mt_templatemap
                     where fileinfo_startdate = '$ts'
                       and fileinfo_blog_id = $blog_id
                       and fileinfo_archive_type = '".$this->escape($at)."'
                       and templatemap_id = fileinfo_templatemap_id
                       and templatemap_is_preferred = 1";
            $rows = $this->get_results($sql, ARRAY_A);
            if (count($rows)) {
                $link =& $rows[0];
            } else {
                return null;
            }
            $blog =& $this->fetch_blog($blog_id);
            $blog_url = $blog['blog_site_url'];
            $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
            $url = $blog_url . $link['fileinfo_url'];
            $url = _strip_index($url, $blog);
            $this->_archive_link_cache[$ts.';'.$at] = $url;
        }
        return $url;
    }

    function entry_link($eid, $at = "Individual", $args = null) {
        if (isset($this->_entry_link_cache[$eid.';'.$at])) {
            $url = $this->_entry_link_cache[$eid.';'.$at];
        } else {
            if ($at == 'Individual') {
                $sql = "select fileinfo_url, fileinfo_blog_id
                          from mt_fileinfo, mt_templatemap
                         where fileinfo_entry_id=$eid
                           and templatemap_id = fileinfo_templatemap_id
                           and templatemap_archive_type='Individual'
                           and templatemap_is_preferred = 1";
            } elseif ($at == 'Category') {
                $sql = "select fileinfo_url, fileinfo_blog_id
                          from mt_fileinfo, mt_templatemap, mt_placement
                         where placement_entry_id = $eid
                           and fileinfo_category_id = placement_category_id
                           and placement_is_primary = 1
                           and fileinfo_templatemap_id = templatemap_id
                           and templatemap_archive_type='Category'
                           and templatemap_is_preferred = 1";
            } else {
                $entry = $this->fetch_entry($eid);
                $ts = $entry['entry_created_on'];
                if ($at == 'Monthly') {
                    $ts = substr($ts, 0, 6) . '01000000';
                } elseif ($at == 'Daily') {
                    $ts = substr($ts, 0, 8) . '000000';
                } elseif ($at == 'Weekly') {
                    require_once("MTUtil.php");
                    list($ws, $we) = start_end_week($ts);
                    $ts = $ws;
                } elseif ($at == 'Yearly') {
                    $ts = substr($ts, 0, 4) . '0101000000';
                }
                $sql = "select fileinfo_url, fileinfo_blog_id
                          from mt_fileinfo, mt_templatemap
                         where fileinfo_templatemap_id = templatemap_id
                           and fileinfo_startdate = '$ts'
                           and templatemap_archive_type='".$this->escape($at)."'
                           and templatemap_is_preferred = 1";
            }
            $rows = $this->get_results($sql, ARRAY_A);
            if (count($rows)) {
                $link =& $rows[0];
            } else {
                return null;
            }
            $blog =& $this->fetch_blog($link['fileinfo_blog_id']);
            $blog_url = $blog['blog_site_url'];
            $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);

            $url = $blog_url . $link['fileinfo_url'];
            $url = _strip_index($url, $blog);
            $this->_entry_link_cache[$eid.';'.$at] = $url;
        }
        if ($at != 'Individual') {
            if ($args && !isset($args['no_anchor'])) {
                $url .= '#' . (isset($args['valid_html']) ? 'a' : '') .
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

    function get_template_text($ctx, $module) {
        $row = $this->get_row("
            select template_text, template_modified_on, template_linked_file, template_linked_file_mtime, template_linked_file_size
              from mt_template
             where template_blog_id=".$ctx->stash('blog_id')."
               and template_name='".$this->escape($module)."'
            ", ARRAY_N);
        if (!$row) return '';
        list($tmpl, $ts, $file, $mtime, $size) = $row;
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
        return $tmpl;
    }

    function fetch_entries($args) {

    	if (isset($args['blog_id'])) {
            $blog_id = intval($args['blog_id']);
            $blog_filter = 'and entry_blog_id = ' . $blog_id;
            $blog = $this->fetch_blog($blog_id);
    	}

        # a context hash for filter routines
        $ctx = array();
        $filters = array();

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
        if (isset($args['category']) or isset($args['categories'])) {
            $category_arg = isset($args['category']) ? $args['category'] : $args['categories'];
            require_once("MTUtil.php");
            if (!preg_match('/\b(AND|OR|NOT)\b|\(|\)/i', $category_arg)) {
                $not_clause = false;
                $cat = cat_path_to_category($category_arg, $blog_id);
                if ($cat) {
                    $cats = array($cat);
                    $category_arg = '(#' . $cat['category_id'] . ')';
                }
            } else {
                $not_clause = preg_match('/\bNOT\b/i', $category_arg);
                $cats =& $this->fetch_categories(array('blog_id' => $blog_id, 'show_empty' => 1));
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
                }
            }
        }

        # Adds a tag filter to the filters list.
        # TBD:
        if (isset($args['tags']) or isset($args['tag'])) {
            $tag_arg = isset($args['tag']) ? $args['tag'] : $args['tags'];
            require_once("MTUtil.php");
            if (!preg_match('/\b(AND|OR|NOT)\b|\(|\)/i', $tag_arg)) {
                $not_clause = false;
            } else {
                $not_clause = preg_match('/\bNOT\b/i', $tag_arg);
            }
            $tags =& $this->fetch_entry_tags(array('blog_id' => $blog_id, 'tag' => $tag_arg));
            if (!is_array($tags)) $tags = array();
            $cexpr = create_tag_expr_function($tag_arg, $tags);

            if ($cexpr) {
                $tmap = array();
                $tag_list = array();
                foreach ($tags as $tag) {
                    $tag_list[] = $tag['tag_id'];
                }
                $ot =& $this->fetch_objecttags(array('tag_id' => $tag_list, 'datasource' => 'entry'));
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
            $date_filter = "and entry_created_on between '$start' and '$end'";
        } elseif ($start) {
            $start = $this->ts2db($start);
            $date_filter = "and entry_created_on >= '$start'";
        } elseif ($end) {
            $end = $this->ts2db($end);
            $date_filter = "and entry_created_on <= '$end'";
        } else {
            $date_filter = '';
        }

        if (isset($args['days'])) {
            $day_filter = 'and ' . $this->limit_by_day_sql('entry_created_on', intval($args['days']));
        } elseif (isset($args['lastn'])) {
            if (!isset($args['entry_id'])) $limit = $args['lastn'];
        } else {
            if ((!isset($args['current_timestamp']) &&
                !isset($args['current_timestamp_end'])) &&
                ($limit <= 0) &&
                (!isset($args['category']) || !isset($args['categories'])) &&
                (isset($blog))) {
                if ($days = $blog['blog_days_on_index']) {
                    $day_filter = 'and ' . $this->limit_by_day_sql('entry_created_on', $days);
                } elseif ($posts = $blog['blog_entries_on_index']) {
                    $limit = $posts;
                }
            }
        }

        $order = 'desc';
        if (isset($blog) && isset($blog['blog_sort_order_posts'])) {
            if ($blog['blog_sort_order_posts'] == 'ascend') {
                $order = 'asc';
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

        if (isset($args['offset']))
            $offset = $args['offset'];

        if (count($filters)) {
            $post_select_limit = $limit;
            $post_select_offset = $offset;
            $limit = 0; $offset = 0;
        }

        if ($args['sort_order']) {
            if ($args['sort_order'] == 'ascend') {
                $order = 'asc';
            } elseif ($args['sort_order'] == 'descend') {
                $order = 'desc';
            }
        }

        $sort_field or $sort_field = 'entry_created_on';
        $sql = "
            select mt_entry.*, mt_placement.*, mt_author.*,
                   mt_trackback.*
              from mt_entry
              left outer join mt_trackback on trackback_entry_id = entry_id
              left outer join mt_placement on placement_entry_id = entry_id
                   and placement_is_primary = 1,
                   mt_author
             where entry_status = 2
                   and entry_author_id = author_id
                   $blog_filter
                   $entry_filter
                   $author_filter
                   $date_filter
                   $day_filter
             order by $sort_field $order
        ";

        if (isset($rco)) {
            $sql = $this->entries_recently_commented_on_sql($sql);
            $sql = $this->apply_limit_sql($sql, count($filters) ? null : $rco);
            $args['sort_by'] or $args['sort_by'] = 'comment_created_on';
            $args['sort_order'] or $args['sort_order'] = 'descend';
            $post_select_limit = $rco;
        } else {
            $sql = $this->apply_limit_sql($sql . " <LIMIT>", $limit, $offset);
        }

        $result = $this->query_start($sql);
        if (!$result) return null;

        $entries = array();
        $j = 0;
        $offset = $post_select_offset ? $post_select_offset : 0;
        $limit = $post_select_limit ? $post_select_limit : 0;
        $id_list = array();
        while (true) {
            $e = $this->query_fetch(ARRAY_A);
            if (!isset($e)) break;
            if (count($filters)) {
                foreach ($filters as $f)
                    if (!$f($e, $ctx)) continue 2;
            }
            if ($offset && ($j++ < $offset)) continue;
            $e['entry_created_on'] = $this->db2ts($e['entry_created_on']);
            $e['entry_modified_on'] = $this->db2ts($e['entry_modified_on']);
            $id_list[] = $e['entry_id'];
            $entries[] = $e;
            if (($limit > 0) && (count($entries) >= $limit)) break;
        }

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
            } else {
                $sort_field = 'entry_' . $args['sort_by'];
            }
            if ($sort_field) {
                if (($sort_field == 'entry_status') || ($sort_field == 'entry_author_id') || ($sort_field == 'entry_id')) {
                    $sort_fn = "if (\$a['$sort_field'] == \$b['$sort_field']) return 0; return \$a['$sort_field'] < \$b['$sort_field'] ? -1 : 1;";
                } else {
                    $sort_fn = "return strcmp(\$a['$sort_field'],\$b['$sort_field']);";
                }
                $sorter = create_function(
                    $args['sort_order'] == 'ascend' ? '$a,$b' : '$b,$a',
                    $sort_fn);
                usort($entries, $sorter);
            }
        }

        if (count($id_list) <= 30) { # TODO: find a good upper limit
            # pre-cache comment counts and categories for these entries
            $this->cache_comment_counts($id_list);
            $this->cache_ping_counts($id_list);
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
        # load tags
        if (isset($args['blog_id'])) {
            if (!isset($args['tag'])) {
                if (isset($this->_blog_tag_cache[$args['blog_id']]))
                    return $this->_blog_tag_cache[$args['blog_id']];
            }
            $blog_filter = 'and objecttag_blog_id = '.intval($args['blog_id']);
        }
        if (isset($args['entry_id'])) {
            if (!isset($args['tag'])) {
                if (isset($this->_entry_tag_cache[$args['entry_id']]))
                    return $this->_entry_tag_cache[$args['entry_id']];
            }
            
            $entry_filter = 'and objecttag_tag_id in (select objecttag_tag_id from mt_objecttag where objecttag_object_id='.intval($args['entry_id']).')';
        }
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
        $sql = "
            select tag_id, tag_name, count(*) as tag_count
             from mt_tag, mt_objecttag, mt_entry
             where objecttag_tag_id = tag_id
               and entry_id = objecttag_object_id and objecttag_object_datasource='entry'
               and entry_status = 2
                   $blog_filter
                   $tag_filter
                   $entry_filter
                   $private_filter
          group by tag_id, tag_name
          order by tag_name";
        $tags = $this->get_results($sql, ARRAY_A);
        if (!isset($args['tag'])) {
            if ($args['blog_id'])
                $this->_blog_tag_cache[$args['blog_id']] = $tags;
            elseif ($args['entry_id'])
                $this->_entry_tag_cache[$args['entry_id']] = $tags;
        }
        return $tags;
    }

    function &fetch_categories($args) {
        # load categories
        if (isset($args['blog_id'])) {
            $blog_filter = 'and category_blog_id = '.intval($args['blog_id']);
        }
        if (isset($args['parent'])) {
            $parent_filter = 'and category_parent = '.intval($args['parent']);
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
            $limit = 1;
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

        $sql = "
            select category_id, count($count_column) as category_count
              from mt_category $join_clause
             where 1 = 1
                   $cat_filter
                   $entry_filter
                   $blog_filter
                   $parent_filter
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

    function &fetch_author($author_id) {
        if (isset($this->_author_id_cache[$author_id])) {
            return $this->_author_id_cache[$author_id];
        }
        global $mt;
        $blog_id = $mt->blog_id;
        $author = $this->get_row("
            select *
              from mt_author
              left outer join mt_permission on permission_author_id = author_id and permission_blog_id = $blog_id
             where author_id=" . intval($author_id) . "
        ", ARRAY_A);
        $this->_author_id_cache[$author_id] = $author;
        return $author;
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
            select fileinfo_entry_id, fileinfo_url, blog_site_url, blog_file_extension
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
                $blog_url = $row[2];
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
            select fileinfo_category_id, fileinfo_url, blog_site_url, blog_file_extension
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
                $blog_url = $row[2];
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
            select comment_entry_id, count(*)
              from mt_comment
             where comment_entry_id in ($id_list)
               and comment_visible = 1
             group by comment_entry_id
        ";
        $results = $this->get_results($query, ARRAY_N);
        if ($results) {
            foreach ($results as $row) {
                $this->_comment_count_cache[$row[0]] = $row[1];
            }
        }
    }

    function blog_entry_count($blog_id = null) {
        if (!$blog_id) {
            global $mt;
            $blog_id = $mt->blog_id;
        }
        $count = $this->get_var("
          select count(*)
            from mt_entry
           where entry_blog_id = " . intval($blog_id) . "
             and entry_status = 2");
        return $count;
    }

    function blog_comment_count($blog_id = null) {
        if (!$blog_id) {
            global $mt;
            $blog_id = $mt->blog_id;
        }
        $count = $this->get_var("
            select count(*)
              from mt_entry, mt_comment
             where entry_blog_id = " . intval($blog_id) . "
               and entry_status = 2
               and comment_visible = 1
               and comment_entry_id = entry_id");
        return $count;
    }

    function blog_ping_count($blog_id = null) {
        if (!$blog_id) {
            global $mt;
            $blog_id = $mt->blog_id;
        }
        $count = $this->get_var("
            select count(*)
              from mt_tbping, mt_trackback
             where tbping_blog_id = " . intval($blog_id) . "
               and tbping_visible = 1
               and tbping_tb_id = trackback_id");
        return $count;
    }

    function tags_entry_count($tag_id) {
        $count = $this->get_var("
          select count(*)
            from mt_objecttag, mt_entry
           where objecttag_tag_id = " . intval($tag_id) . "
             and entry_id = objecttag_object_id and objecttag_object_datasource='entry'
             and entry_status = 2");
        return $count;
    }

    function entry_comment_count($entry_id) {
        if (isset($this->_comment_count_cache[$entry_id])) {
            return $this->_comment_count_cache[$entry_id];
        }
        $count = $this->get_var("
            select count(*)
              from mt_comment
             where comment_entry_id = " . intval($entry_id) . "
               and comment_visible = 1
        ");
        $this->_comment_count_cache[$entry_id] = $count;
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
        $sql = "
            select mt_objecttag.*
              from mt_objecttag, mt_entry
              where objecttag_tag_id in ($id_list)
                and entry_id = objecttag_object_id
                and entry_status = 2
        ";
        $results = $this->get_results($sql, ARRAY_A);
        return $results;
    }

    function &fetch_comments($args) {
        $entry_id = intval($args['entry_id']);
        if ($args['blog_id']) {
            $blog =& $this->fetch_blog($args['blog_id']);
            $blog_filter = ' and comment_blog_id = ' . $blog['blog_id'];
        }
        # load comments

        $order = 'desc';
        if (isset($args['sort_order'])) {
            if ($args['sort_order'] == 'ascend') {
                $order = 'asc';
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
        if ($entry_id) {
            $entry_filter = " and comment_entry_id = $entry_id";
        } else {
            $entry_join = "join mt_entry on entry_id = comment_entry_id and entry_status = 2";
        }
        $sql = "
            select *
              from mt_comment
                   $entry_join
             where 1 = 1
                   $entry_filter
                   $blog_filter
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
            select trackback_entry_id, count(*)
              from mt_trackback, mt_tbping
             where trackback_entry_id in ($id_list)
               and tbping_tb_id = trackback_id
               and tbping_visible = 1
             group by trackback_entry_id
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
        $count = $this->get_var("
            select count(*)
              from mt_trackback, mt_tbping
             where trackback_entry_id = " . intval($entry_id) . "
               and tbping_visible = 1
               and tbping_tb_id = trackback_id 
        ");
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

        $order = 'asc';
        if (isset($args['sort_order'])) {
            if ($args['sort_order'] == 'descend')
                $order = 'desc';
        }
        if ($entry_id)
            $entry_filter = 'and trackback_entry_id = ' . intval($entry_id);
        $sql = "
            select *  
              from mt_trackback, mt_tbping
             where tbping_tb_id = trackback_id
               $entry_filter
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

    function &fetch_category($cat_id) {
        if (isset($this->_cat_id_cache['c'.$cat_id])) {
            return $this->_cat_id_cache['c'.$cat_id];
        }
        $cats =& $this->fetch_categories(array('category_id' => $cat_id));
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
                select fileinfo_startdate, fileinfo_url, blog_site_url, blog_file_extension
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
                    $blog_url = $row[2];
                    $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
                    $url = $blog_url . $row[1];
                    $url = _strip_index($url, array('blog_file_extension' => $row[3]));
                    $this->_archive_link_cache[$date.';'.$at] = $url;
                }
            }
        }
        return $results;
    }

    function archive_list_sql($args) {
        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        if ($at == 'Daily') {
            # default (works for mysql and postgres...)
            $sql = "
                select count(*),
                       extract(year from entry_created_on) as y,
                       extract(month from entry_created_on) as m,
                       extract(day from entry_created_on) as d
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                 group by
                       extract(year from entry_created_on),
                       extract(month from entry_created_on),
                       extract(day from entry_created_on)
                 order by
                       extract(year from entry_created_on) $order,
                       extract(month from entry_created_on) $order,
                       extract(day from entry_created_on) $order
                       <LIMIT>";
        } elseif ($at == 'Weekly') {
            $sql = "
                select count(*),
                       entry_week_number
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                 group by entry_week_number
                 order by entry_week_number $order
                       <LIMIT>";
        } elseif ($at == 'Monthly') {
            $sql = "
                select count(*),
                       extract(year from entry_created_on) as y,
                       extract(month from entry_created_on) as m
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                 group by
                       extract(year from entry_created_on),
                       extract(month from entry_created_on)
                 order by
                       extract(year from entry_created_on) $order,
                       extract(month from entry_created_on) $order
                       <LIMIT>";
        } elseif ($at == 'Yearly') {
            $sql = "
                select count(*),
                       extract(year from entry_created_on) as y
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                 group by
                       extract(year from entry_created_on)
                 order by
                       extract(year from entry_created_on) $order
                       <LIMIT>";
        } elseif ($at == 'Individual') {
            $sql = "
                select entry_id,
                       entry_created_on
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                 order by entry_created_on $order
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
        $rows = parent::get_results($query, $output);
        if (is_array($rows)) {
            $rows = array_map(array($this,"convert_fieldname"), $rows);
        }
        return $rows;
    }       

    function &convert_fieldname($array) {
        return $array;
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
}
?>
