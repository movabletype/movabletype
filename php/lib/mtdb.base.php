<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once('adodb-exceptions.inc.php');
require_once('adodb.inc.php');
require_once('adodb-active-record.inc.php');

abstract class MTDatabase {
    var $savedqueries = array();


    // Member variables
    protected $id;
    protected $conn;
    protected $serializer;
    protected $pdo_enabled = false;
    protected $has_distinct = true;

    // Cache variables
    protected $_entry_id_cache = array();
    protected $_comment_count_cache = array();
    protected $_ping_count_cache = array();
    protected $_cat_id_cache = array();
    protected $_tag_id_cache = array();
    protected $_blog_id_cache = array();
    protected $_entry_link_cache = array();
    protected $_cat_link_cache = array();
    protected $_archive_link_cache = array();
    protected $_entry_tag_cache = array();
    protected $_blog_tag_cache = array();
    protected $_asset_tag_cache = array();
    protected $_blog_asset_tag_cache = array();
    protected $_author_id_cache = array();


    // Construction
    public function __construct($user, $password = '', $dbname = '', $host = '', $port = '', $sock = '') {
        $this->id = md5(uniqid('MTDatabase',true));
        $this->connect($user, $password, $dbname, $host, $port, $sock);
        ADOdb_Active_Record::SetDatabaseAdapter($this->conn);
#        $this->conn->debug = true;
    }

    // Abstract method
    abstract protected function connect($user, $password = '', $dbname = '', $host = '', $port = '', $sock = '');
    abstract public function set_names($mt);

    // Utility method
    public function escape($str) {
        return substr($this->conn->Quote(stripslashes($str)), 1, -1);
    }

    public function has_distinct_support () {
        return $this->has_distinct;
    }

    public function &db() {
        return $this->conn;
    }

    public function execute($sql) {
        return $this->conn->Execute($sql);
    }

    public function decorate_column( $order ) {
        return $order;
    }

    public function SelectLimit($sql, $limit = -1, $offset = -1) {
        return $this->conn->SelectLimit($sql, $limit, $offset);
    }

    public function unserialize($data) {
        if (!$this->serializer) {
            require_once("MTSerialize.php");
            $this->serializer = new MTSerialize();
        }
        return $this->serializer->unserialize($data);
    }

    public function serialize($data) {
        if (!$this->serializer) {
            require_once("MTSerialize.php");
            $this->serializer = new MTSerialize();
        }
        return $this->serializer->serialize($data);
    }

    public function parse_blog_ids( $blog_ids, $include_with_website = false ) {
        $ret = array();

        if ( empty($blog_ids) || $blog_ids == 'all')
            return $ret;

        if (preg_match('/-/', $blog_ids)) {
            # parse range blog ids out
            $list = preg_split('/\s*,\s*/', $blog_ids);
            foreach ($list as $item) {
                if (preg_match('/(\d+)-(\d+)/', $item, $matches)) {
                    for ($i = $matches[1]; $i <= $matches[2]; $i++) {
                        array_push( $ret, $i );
                    }
                } else if (ctype_digit($item)) {
                    array_push( $ret, $item );
                }
            }
        } elseif ( preg_match( '/\s*,\s*/', $blog_ids ) ) {
            $ret = preg_split( '/\s*,\s*/',
                               $blog_ids,
                               -1, PREG_SPLIT_NO_EMPTY);
        } elseif (
             ($blog_ids == 'site')
          || ($blog_ids == 'children')
          || ($blog_ids == 'siblings')
        ) {
            $mt = MT::get_instance();
            $ctx = $mt->context();
            $blog = $ctx->stash('blog');
            if (!empty($blog)) {
                require_once('class.mt_blog.php');
                $blog_class = new Blog();
                $blogs = $blog_class->Find("blog_parent_id = " . ( $blog->is_blog() ? $blog->parent_id : $blog->id) );
                if ( !empty( $blogs ) ) {
                    foreach($blogs as $b) {
                        array_push($ret, $b->id);
                    }
                }
                if ( $include_with_website ) {
                    $website = ( $blog->is_blog() ? $blog->website() : $blog);
                    array_push($ret, $website->id);
                }
            }
        } else {
            if ( is_numeric($blog_ids) )
                $blog_ids = strval($blog_ids);
            if ( ctype_digit( $blog_ids ) )
                 array_push( $ret, $blog_ids);
        }
        return $ret;
    }

    public function include_exclude_blogs(&$args) {
        if ( empty( $args['include_with_website'] ) )
            $include_with_website = false;
        else
            $include_with_website = true;

        $incl = null;
        $excl = null;
        if (isset($args['blog_ids']) || isset($args['include_blogs']) || isset($args['include_websites'])) {
            // The following are aliased
            $args['blog_ids'] and $args['include_blogs'] = $args['blog_ids'];
            $args['include_websites'] and $args['include_blogs'] = $args['include_websites'];
            $incl = $args['include_blogs'];
            unset($args['blog_ids']);
            unset($args['include_websites']);
        }
        else if (isset($args['blog_id'])) {
            $incl = $args['blog_id'];
        }

        if (isset($args['exclude_blogs']) || isset($args['exclude_websites'])) {
            $excl = $args['exclude_blogs'];
            $excl or $excl = $args['exclude_websites'];

            if ( !isset( $args['include_blogs'] ) ) {
                # If only exclude_blogs supplied, set include_blogs as all
                $incl = 'all';
                $args['include_blogs'] = 'all';
            }
        }

        // Compute include_blogs
        if ( !empty($incl) )
            $incl = $this->parse_blog_ids( $incl, $include_with_website );
        if ( isset( $args['allows'] ) ) {
            if ( !empty( $incl ) )
                $incl = array_intersect($incl, $args['allows']);
        }

        // Compute exclude_blogs
        if ( !empty($excl) )
            $excl = $this->parse_blog_ids( $excl );

        if ( isset( $args['denies'] ) ) {
            foreach ( $args['denies'] as $val )
                $denies[$val] = 1;
            if ( !empty($excl) ) {
                foreach ( $excl as $e ) {
                    if ( !array_key_exists( $e, $denies ) )
                        $denies[$e] = 1;
                }
            }
            $excl = array_keys( $denies );
        }

        if ( !empty($incl) && !empty($excl) ) {
            $incl = array_diff($incl, $excl);
            if ( empty( $incl ) ) {
                $mt = MT::get_instance();
                trigger_error( $mt->translate(
                        "When the exclude_blogs and include_blogs attributes are used together, the same blog IDs should not be listed as parameters to both of them."
                ) );
            } else {
                $incl = array_values( $incl );
                $excl = null; // remove all exclude pattern.
            }
        }

        if ( !empty($incl) ) {
            if ( count($incl) > 1 )
                return " in (" . implode(',', $incl) . ' )';
            else
                return " = " . array_shift($incl);
        } elseif ( !empty($excl) ) {
            return " not in (" . implode(',', $excl) . ' )';
        } else {
            if ( isset($args['include_blogs']) && strtolower($args['include_blogs']) == 'all') {
                return " > 0";
            } elseif (isset($args['blog_id']) && is_numeric($args['blog_id'])) {
                return " = " . $args['blog_id'];
            } elseif (isset($args['include_blogs'])) {
                return " = 0";
            } else {
                $mt = MT::get_instance();
                $ctx = $mt->context();
                $blog = $ctx->stash('blog');
                if ( !empty( $blog ) )
                    return " = " . $blog->id;
                else
                    return " > 0";
            }
        }
    }

    public function db2ts($dbts) {
        $dbts = preg_replace('/[^0-9]/', '', $dbts);
        return $dbts;
    }

    public function ts2db($ts) {
        preg_match('/^(\d\d\d\d)?(\d\d)?(\d\d)?(\d\d)?(\d\d)?(\d\d)?$/', $ts, $matches);
        list($all, $y, $mo, $d, $h, $m, $s) = $matches;
        return sprintf("%04d-%02d-%02d %02d:%02d:%02d", $y, $mo, $d, $h, $m, $s);
    }

    public function apply_extract_date($part, $column) {
        return "extract($part from $column)";
    }

    // Deprecated method
    public function get_row($query = null, $output = OBJECT, $y = 0) {
        require_once('class.exception.php');
        throw new MTDeprecatedException('get_row was Deprecated.');
    }

    public function get_results($query = null, $output = ARRAY_A) {
        require_once('class.exception.php');
        throw new MTDeprecatedException('get_results was Deprecated.');
    }

    public function convert_fieldname($array) {
        require_once('class.exception.php');
        throw new MTDeprecatedException('convert_fieldname was Deprecated.');
    }

    public function expand_meta($rows) {
        require_once('class.exception.php');
        throw new MTDeprecatedException('expand_meta was Deprecated.');
    }

    public function get_meta($obj_type, $obj_id) {
        require_once('class.exception.php');
        throw new MTDeprecatedException('get_meta was Deprecated.');
    }

    function apply_limit_sql($sql, $limit, $offset = 0) {
        require_once('class.exception.php');
        throw new MTDeprecatedException('apply_limit_sql was Deprecated.');
    }

    // Public method
    public function resolve_url($path, $blog_id, $build_type = 3) {
        $path = preg_replace('!/$!', '', $path);
        $blog_id = intval($blog_id);
        # resolve for $path -- one of:
        #      /path/to/file.html
        #      /path/to/index.html
        #      /path/to/
        #      /path/to

        $mt = MT::get_instance();
        $index = $this->escape($mt->config('IndexBasename'));
        $escindex = $this->escape($index);

        require_once('class.mt_fileinfo.php');
        $records = null;
        $extras['join'] = array(
            'mt_template' => array(
                'condition' => "fileinfo_template_id = template_id"
            ),
            'mt_templatemap' => array(
                'condition' => "fileinfo_templatemap_id = templatemap_id",
                'type' => 'left'
            ),
        );

        foreach ( array($path, urldecode($path), urlencode($path)) as $p ) {
            $where = "fileinfo_blog_id = $blog_id
                      and ((fileinfo_url = '%1\$s' or fileinfo_url = '%1\$s/') or (fileinfo_url like '%1\$s/$escindex%%'))
                      and template_type != 'backup'
                      order by length(fileinfo_url) asc";
            $fileinfo= new FileInfo;
            $records = $fileinfo->Find(sprintf($where, $this->escape($p)),  false, false, $extras);
            if (!empty($records))
                break;
        }
        $path = $p;
        if (empty($records)) return null;

        $found = false;
        foreach ($records as $record) {
            if ( !empty( $build_type ) ) {
                if ( !is_array( $build_type ) ) {
                    $build_type_array = array( $build_type );
                } else {
                    $build_type_array = $build_type;
                }

                $tmpl =  $record->template();
                $map = $record->templatemap();
                $type = empty( $map ) ? $tmpl->build_type : $map->build_type;

                if ( !in_array( $type, $build_type_array ) ) {
                    continue;
                }
            }

            $fiurl = $record->url;
            if ($fiurl == $path) {
                $found = true;
                break;
            }
            if ($fiurl == "$path/") {
                $found = true;
                break;
            }
            $ext = $record->blog()->file_extension;
            if (!empty($ext)) $ext = '.' . $ext;
            if ($fiurl == ($path.'/'.$index.$ext)) {
                $found = true; break;
            }
            if ($found) break;
        }

        if (!$found) return null;
        $blog = $record->blog();
        $this->_blog_id_cache[$blog->id] =& $blog;
        return $record;
    }

    public function load_index_template($ctx, $tmpl, $blog_id = null) {
        return $this->load_special_template($ctx, $tmpl, 'index', $blog_id);
    }

    public function fetch_websites($args) {
        $args['class'] = 'website';
        return $this->fetch_blogs($args);
    }

    public function fetch_blogs($args = null) {
        if ($blog_ids = $this->include_exclude_blogs($args))
            $blog_filter = 'blog_id ' . $blog_ids;
        else
            $blog_filter = '1 = 1';

        if (!isset($args['class']))
            $args['class'] = 'blog';

        $where = $blog_filter;
        $where .= $args['class'] == '*' ? "" : " and blog_class = '".$args['class']."'";
        $where .= ' order by blog_name';

        require_once('class.mt_blog.php');
        $blogs = null;
        $blog = new Blog();
        $blogs = $blog->Find($where);
        return $blogs;
    }

    public function fetch_templates($args = null) {
        if (isset($args['type'])) {
            $type_filter = 'and template_type = \'' . $this->escape($args['type']) . '\'';
        }
        if (isset($args['blog_id'])) {
            $blog_filter = 'and template_blog_id = ' . intval($args['blog_id']);
        }

        $where = "1 = 1
                  $blog_filter
                  $type_filter
                  order by template_name";

        require_once('class.mt_template.php');
        $template = new Template;
        $result = $template->Find($where);
        return $result;
    }

    public function fetch_templatemap($args = null) {
        if (isset($args['type'])) {
            $type_filter = 'and templatemap_archive_type = \'' . $this->escape($args['type']) . '\'';
        }
        if (isset($args['blog_id'])) {
            $blog_filter = 'and templatemap_blog_id = ' . intval($args['blog_id']);
        }

        $where = "1 = 1
                  $blog_filter
                  $type_filter
                  order by templatemap_archive_type";

        require_once('class.mt_templatemap.php');
        $tmap = new TemplateMap;
        $result = $tmap->Find($where);
        return $result;
    }

    public function load_special_template($ctx, $tmpl, $type, $blog_id = null) {
        if (empty($blog_id))
            $blog_id = $ctx->stash('blog_id');
        $tmpl_name = $this->escape($tmpl);

        $where = "template_blog_id = $blog_id";
        if (!empty($tmpl)) {
            $where .= " and (template_name = '$tmpl_name'
                        or template_outfile = '$tmpl_name'
                        or template_identifier='$tmpl_name')";
        }
        $where .= " and template_type = '".$this->escape($type)."'";

        require_once('class.mt_template.php');
        $template = new Template;
        $template->Load($where);
        return $template;
    }

    public function fetch_config() {
        require_once('class.mt_config.php');
        $config = new Config;
        $config->Load();
        return $config;
    }

    public function category_link($cid) {
        if (isset($this->_cat_link_cache[$cid])) {
            $url = $this->_cat_link_cache[$cid];
        } else {
            $where = "fileinfo_category_id = $cid and
                      fileinfo_archive_type = 'Category'";
            require_once('class.mt_fileinfo.php');
            $finfo = new FileInfo;
            $finfos = $finfo->Find($where);
            $found = false;
            foreach($finfos as $fi) {
                $tmap = $fi->TemplateMap();
                if ($tmap->is_preferred == 1) {
                    $found = true;
                    $finfo = $fi;
                    break;
                }
            }
            if (!$found)
                return null;

            $blog = $finfo->Blog();
            $blog_url = $blog->archive_url();
            if (empty($blog_url))
                $blog_url = $blog->site_url();
            $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
            $url = $blog_url . $finfo->url;
            require_once('MTUtil.php');
            $url = _strip_index($url, $blog);
            $this->_cat_link_cache[$cid] = $url;
        }
        return $url;
    }

    public function archive_link($ts, $at, $sql, $args) {
        $blog_id = intval($args['blog_id']);
        if (isset($this->_archive_link_cache[$blog_id.';'.$ts.';'.$at])) {
            $url = $this->_archive_link_cache[$blog_id.';'.$ts.';'.$at];
        } else {
            if (empty($sql)) {
                $sql = "fileinfo_startdate = '$ts'
                        and fileinfo_blog_id = $blog_id
                        and fileinfo_archive_type = '" . $this->escape($at). "'" .
                        " and templatemap_is_preferred = 1";
            }
            $extras['join'] = array(
                'mt_templatemap' => array(
                    'condition' => "templatemap_id = fileinfo_templatemap_id"
                    )
                );
            
            require_once('class.mt_fileinfo.php');
            $finfo = new FileInfo;
            $infos = $finfo->Find($sql, false, false, $extras);
            if (empty($infos))
                return null;

            $finfo = $infos[0];
            $blog = $finfo->blog();
            if ($at == 'Page') {
                $blog_url = $blog->site_url();
            } else {
                $blog_url = $blog->archive_url();
            }

            require_once('MTUtil.php');
            $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
            $url = $blog_url . $finfo->fileinfo_url;
            $url = _strip_index($url, $blog);
            $this->_archive_link_cache[$ts.';'.$at] = $url;
        }
        return $url;
    }

    public function entry_link($eid, $at = "Individual", $args = null) {
        $eid = intval($eid);
        if (isset($this->_entry_link_cache[$eid.';'.$at])) {
            $url = $this->_entry_link_cache[$eid.';'.$at];
        } else {
            $extras['join'] = array(
                'mt_templatemap' => array(
                    'condition' => "templatemap_id = fileinfo_templatemap_id"
                    )
                );
            $filter = '';

            if (preg_match('/Category/', $at)) {
                $extras['join']['mt_placement'] = array(
                    'condition' => "fileinfo_category_id = placement_category_id"
                    );
                $filter = " and placement_entry_id = $eid
                           and placement_is_primary = 1";
            }

            if (preg_match('/Page/', $at)) {
                $entry = $this->fetch_page($eid);
            } else {
                $entry = $this->fetch_entry($eid);
            }

            $ts = $entry->entry_authored_on;
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
                $filter .= " and fileinfo_entry_id = $eid";
            }
            if ($ts != $entry->entry_authored_on) {
                $filter .= " and fileinfo_startdate = '$ts'";
            }
            if (preg_match('/Author/', $at)) {
                $filter .= " and fileinfo_author_id = ". $entry->entry_author_id;
            }

            $where .= "templatemap_archive_type = '$at'
                       and templatemap_is_preferred = 1
                       $filter";
            if (isset($args['blog_id']))
                $where .= " and fileinfo_blog_id = " . $args['blog_id'];
            require_once('class.mt_fileinfo.php');
            $finfo = new FileInfo;
            $infos = $finfo->Find($where, false, false, $extras);
            if (empty($infos))
                return null;

            $finfo = $infos[0];
            $blog = $finfo->blog();
            if ($at == 'Page') {
                $blog_url = $blog->site_url();
            } else {
                $blog_url = $blog->archive_url();
                if (empty($blog_url))
                    $blog_url = $blog->site_url();
            }

            require_once('MTUtil.php');
            $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
            $url = $blog_url . $finfo->fileinfo_url;
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

    public function get_template_text($ctx, $module, $blog_id = null, $type = 'custom', $global = null) {
        if (empty($blog_id))
            $blog_id = $ctx->stash('blog_id');

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
            $blog_filter = "template_blog_id = 0";
        } else {
            $blog_filter = "template_blog_id = ".$this->escape($blog_id);
        }

        require_once('class.mt_template.php');
        $template = new Template;
        $where = "$blog_filter
                  and $col = '".$this->escape($module)."'
                  $type_filter
                  order by template_blog_id desc";
        $tmpls = $template->Find($where);
        if (empty($tmpls)) return '';

        $tmpl = $tmpls[0]->text;
        $ts = $tmpls[0]->modified_on;
        $file = $tmpls[0]->linked_file;
        $mtime = $tmpls[0]->linked_file_mtime;
        $size = $tmpls[0]->linked_file_size;

        if ($file) {
            if (!file_exists($file)) {
                $blog = $ctx->stash('blog');
                if ($blog->id != $blog_id) {
                    $blog = $this->fetch_blog($blog_id);
                }
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
                if ((filemtime($file) > $mtime) || (filesize($file) != $size)) {
                    $contents = @file($file);
                    $tmpl = implode('', $contents);
                }
            }
        }
        return $tmpl;
    }

    public function fetch_website($blog_id) {
        if (!empty($this->_blog_id_cache) && isset($this->_blog_id_cache[$blog_id])) {
            return $this->_blog_id_cache[$blog_id];
        }
        require_once('class.mt_website.php');
        $blog = new Website;
        $blog->Load("blog_id = $blog_id");
        $this->_blog_id_cache[$blog_id] = $blog;
        return $blog;
    }

    public function fetch_blog($blog_id) {
        if (!empty($this->_blog_id_cache) && isset($this->_blog_id_cache[$blog_id])) {
            return $this->_blog_id_cache[$blog_id];
        }
        require_once('class.mt_blog.php');
        $blog = new Blog;
        $blog->Load("blog_id = $blog_id");
        $this->_blog_id_cache[$blog_id] = $blog;
        return $blog;
    }

    function fetch_pages($args) {
        $args['class'] = 'page';
        return $this->fetch_entries($args);
    }

    function fetch_entry($eid) {
        if ( isset( $this->_entry_id_cache[$eid] ) && !empty( $this->_entry_id_cache[$eid] ) ) {
            return $this->_entry_id_cache[$eid];
        }
        require_once("class.mt_entry.php");
        $entry = New Entry;
        $entry->Load( $eid );
        if ( !empty( $entry ) ) {
            $this->_entry_id_cache[$eid] = $entry;
            return $entry;
        } else {
            return null;
        }
    }

    public function fetch_entries($args, &$total_count = NULL) {
        require_once('class.mt_entry.php');
        $extras = array();

        if ($sql = $this->include_exclude_blogs($args)) {
            $blog_filter = 'and entry_blog_id ' . $sql;
            $mt = MT::get_instance();
            $ctx = $mt->context();
            $blog = $ctx->stash('blog');
            if ( !empty( $blog ) )
                $blog_id = $blog->blog_id;
        } elseif (isset($args['blog_id'])) {
            $blog_id = intval($args['blog_id']);
            $blog_filter = 'and entry_blog_id = ' . $blog_id;
            $blog = $this->fetch_blog($blog_id);
        }

        if (empty($blog))
            return null;

        // determine any custom fields that we should filter on
        $fields = array();
        foreach ($args as $name => $v)
            if (preg_match('/^field___(\w+)$/', $name, $m))
                $fields[$m[1]] = $v;

        # automatically include offset if in request
        if ($args['offset'] == 'auto') {
            $args['offset'] = 0;
            if ($args['limit'] || $args['lastn']) {
                if (intval($_REQUEST['offset']) > 0) {
                    $args['offset'] = intval($_REQUEST['offset']);
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
            if ((intval($_REQUEST['limit']) > 0) && (intval($_REQUEST['limit']) < $args['lastn'])) {
                $args['lastn'] = intval($_REQUEST['limit']);
            } elseif (!isset($args['days']) && !isset($args['lastn'])) {
               if ($days = $blog->blog_days_on_index) {
                    if (!isset($args['recently_commented_on'])) {
                        $args['days'] = $days;
                    }
                } elseif ($posts = $blog->blog_entries_on_index) {
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

        if (isset($args['unique']) && $args['unique']) {
            $filters[] = create_function('$e,$ctx', 'return !isset($ctx["entry_ids_published"][$e->entry_id]);');
            $ctx['entry_ids_published'] = &$_REQUEST['entry_ids_published'];
        }

        # special case for selecting a particular entry
        if (isset($args['entry_id'])) {
            $entry_filter = 'and entry_id = '.$args['entry_id'];
            $start = ''; $end = ''; $limit = 1; $blog_filter = ''; $day_filter = '';
        } else {
            $entry_filter = '';
        }

        # special case for selecting some particular entries
        if (isset($args['entry_ids'])) {
            $entry_filter .=
                ' and entry_id IN (' .
                join(',', preg_grep('/\A\d+\z/', $args['entry_ids'])) .
                ')';
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
                if (empty($cats)) {
                    return null;
                } else {
                    $category_arg = '';
                    foreach ($cats as $cat) {
                        if ($category_arg != '')
                            $category_arg .= '|| ';
                        $category_arg .= '#' . $cat->category_id;
                    }
                    $category_arg = '(' . $category_arg . ')';
                }
            } else {
                $not_clause = preg_match('/\bNOT\b/i', $category_arg);
                if ($blog_ctx_arg)
                    $cats = $this->fetch_categories(array_merge($blog_ctx_arg, array('show_empty' => 1, 'class' => $cat_class)));
                else
                    $cats = $this->fetch_categories(array('blog_id' => $blog_id, 'show_empty' => 1, 'class' => $cat_class));
            }

           if (!empty($cats)) {
               $cexpr = create_cat_expr_function($category_arg, $cats, array('children' => $args['include_subcategories']));
               if ($cexpr) {
                   $cmap = array();
                   $cat_list = array();
                   foreach ($cats as $cat)
                       $cat_list[] = $cat->category_id;
                   $pl = $this->fetch_placements(array('category_id' => $cat_list));
                   if (!empty($pl)) {
                       foreach ($pl as $p) {
                           $cmap[$p->placement_entry_id][$p->placement_category_id]++;
                           if (!$not_clause)
                               $entry_list[$p->placement_entry_id] = 1;
                       }
                   }
                   $ctx['p'] =& $cmap;
                   $filters[] = $cexpr;
               } else {
                   return null;
               }
           }
        } elseif (isset($args['category_id'])) {
            require_once("MTUtil.php");
            $cat = $this->fetch_category($args['category_id']);
            if (!empty($cat)) {
                $cats = array($cat);
                $cmap = array();
                $cexpr = create_cat_expr_function($cat->category_label, $cats, array('children' => $args['include_subcategories']));
                $pl = $this->fetch_placements(array('category_id' => array($cat->category_id)));
                if (!empty($pl)) {
                    foreach ($pl as $p) {
                        $cmap[$p->placement_entry_id][$p->placement_category_id]++;
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

            $include_private = 0;
            $tag_array = tag_split($tag_arg);
            foreach ($tag_array as $tag) {
                if ($tag && (substr($tag,0,1) == '@')) {
                    $include_private = 1;
                }
            }
            if (isset($blog_ctx_arg))
                $tags = $this->fetch_entry_tags(array($blog_ctx_arg, 'tag' => $tag_arg, 'include_private' => $include_private, 'class' => $args['class']));
            else
                $tags = $this->fetch_entry_tags(array('blog_id' => $blog_id, 'tag' => $tag_arg, 'include_private' => $include_private, 'class' => $args['class']));
            if (!is_array($tags)) $tags = array();
            $cexpr = create_tag_expr_function($tag_arg, $tags);

            if ($cexpr) {
                $tmap = array();
                $tag_list = array();
                foreach ($tags as $tag) {
                    $tag_list[] = $tag->tag_id;
                }
                if (isset($blog_ctx_arg))
                    $ot = $this->fetch_objecttags(array('tag_id' => $tag_list, 'datasource' => 'entry', $blog_ctx_arg));
                else
                    $ot = $this->fetch_objecttags(array('tag_id' => $tag_list, 'datasource' => 'entry', 'blog_id' => $blog_id));

                if ($ot) {
                    foreach ($ot as $o) {
                        $tmap[$o->objecttag_object_id][$o->objecttag_tag_id]++;
                        if (!$not_clause)
                            $entry_list[$o->objecttag_object_id] = 1;
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
                if (empty($voter)) {
                    echo "Invalid scored by filter: ".$args['scored_by'];
                    return null;
                }
                $cexpr = create_rating_expr_function($voter->author_id, 'scored_by', $args['namespace']);
                if ($cexpr) {
                    $filters[] = $cexpr;
                } else {
                    return null;
                }
            }
        }

        # Adds an count of comment filter
        if (isset($args['max_comment']) && is_numeric($args['max_comment'])) {
            $max_comment_filter = 'and entry_comment_count <= ' . intval($args['max_comment']);
        }
        if (isset($args['min_comment']) && is_numeric($args['min_comment'])) {
            $min_comment_filter = 'and entry_comment_count >= ' . intval($args['min_comment']);
        }

        if (count($entry_list) && ($entry_filter == '')) {
            $entry_list = implode(",", array_keys($entry_list));
            # set a reasonable cap on the entry list cache. if
            # user is selecting something too big, then they'll
            # just have to wait through a scan.
            if (strlen($entry_list) < 2048)
                $entry_filter = "and entry_id in ($entry_list)";
        }

        if (isset($args['author'])) {
            $author_filter = 'and author_name = \'' .
                $this->escape($args['author']) . "'";
            $extras['join']['mt_author'] = array(
                    'condition' => "entry_author_id = author_id"
                    );
        }

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
                'min_count',  'max_count',
                'min_comment', 'max_comment'
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
                if ($days = $blog->blog_days_on_index) {
                    if (!isset($args['recently_commented_on'])) {
                        $day_filter = 'and ' . $this->limit_by_day_sql('entry_authored_on', $days);
                    }
                } elseif ($posts = $blog->blog_entries_on_index) {
                    $limit = $posts;
                }
            }
        }

        if (isset($args['sort_order'])) {
            if ($args['sort_order'] == 'ascend') {
                $order = 'asc';
            } elseif ($args['sort_order'] == 'descend') {
                $order = 'desc';
            }
        } 
        if (!isset($order)) {
            $order = 'desc';
            if (isset($blog) && isset($blog->blog_sort_order_posts)) {
                if ($blog->blog_sort_order_posts == 'ascend') {
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


        if ( isset($args['sort_by'])
             && (($args['sort_by'] == 'score') || ($args['sort_by'] == 'rate'))) {
             $extras['join'] = array(
                 'mt_objectscore' => array(
                     'type' => 'left',
                     'condition' => "objectscore_object_id = entry_id and objectscore_namespace='".
                     $args['namespace']."' and objectscore_object_ds='".$class."'"
                     )
                 );
             $extras['distinct'] = 1;
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
                } elseif ($args['sort_by'] == 'trackback_count') {
                    $sort_field = 'entry_ping_count';
                } elseif (preg_match('/field[:\.]/', $args['sort_by'])) {
                    $post_sort_limit = $limit ? $limit : 0;
                    $post_sort_offset = $offset ? $offset : 0;
                    $limit = 0; $offset = 0;
                    $no_resort = 0;
                } else {
                    $sort_field = 'entry_' . $args['sort_by'];
                }
                if ($sort_field) $no_resort = 1;
                if ($args['sort_by'] == 'score' || $args['sort_by'] == 'rate') {
                    $post_sort_limit = $limit;
                    $post_sort_offset = $offset;
                    $limit = 0; $offset = 0;
                    $no_resort = 0;
                    $sort_field = "entry_modified_on";
                }
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

        if (count($filters) || !is_null($total_count)) {
            $post_select_limit = $limit;
            $post_select_offset = $offset;
            $limit = 0; $offset = 0;
        }

        if (count($fields)) {
            $meta_join_num = 1;
            $entry_meta_info = Entry::get_meta_info('entry');
            if (!empty($entry_meta_info)) {
                foreach ($fields as $name => $value) {
                    if (isset($entry_meta_info['field.'.$name])) {
                        $meta_col = $entry_meta_info['field.'.$name];
                        $value = $this->escape($value);
                        $table = "mt_entry_meta entry_meta$meta_join_num";
                        $extras['join'][$table] = array(
                            'condition' => "(entry_meta$meta_join_num.entry_meta_entry_id = entry_id
                                and entry_meta$meta_join_num.entry_meta_type = 'field.$name'
                                and entry_meta$meta_join_num.entry_meta_$meta_col='$value')\n"
                            );
                        $meta_join_num++;
                    }
                }
            }
        }

        $join_clause = '';
        if (isset($extras['join'])) {
            $joins = $extras['join'];
            $keys = array_keys($joins);
            foreach($keys as $key) {
                $table = $key;
                $cond = $joins[$key]['condition'];
                $type = '';
                if (isset($joins[$key]['type']))
                    $type = $joins[$key]['type'];
                $join_clause .= ' ' . strtolower($type) . ' JOIN ' . $table . ' ON ' . $cond;
            }
        }

        $sql = "select
                    mt_entry.*
                from mt_entry
                    $join_clause
                where
                    entry_status = 2
                    $blog_filter
                    $entry_filter
                    $author_filter
                    $date_filter
                    $day_filter
                    $class_filter
                    $max_comment_filter
                    $min_comment_filter";
        if ($sort_field) {
            $sql .= "order by $sort_field $base_order";
            if ($sort_field == 'entry_authored_on') {
                $sql .= ",entry_id $base_order";
            }
        }

        if (isset($args['recently_commented_on'])) {
            $rco = $args['recently_commented_on'];
            $sql = $this->entries_recently_commented_on_sql($sql);
            $args['sort_by'] or $args['sort_by'] = 'comment_created_on';
            $args['sort_order'] or $args['sort_order'] = 'descend';
            $post_select_limit = $rco;
            $no_resort = 1;
        } elseif ( !is_null($total_count) ) {
            $orig_offset = $post_select_offset ? $post_select_offset : $offset;
            $orig_limit = $post_select_limit ? $post_select_limit : $limit;
        }

        if ($limit <= 0) $limit = -1;
        if ($offset <= 0) $offset = -1;
        $result = $this->db()->SelectLimit($sql, $limit, $offset);
        if ($result->EOF) return null;

        $field_names = array_keys($result->fields);

        $entries = array();
        $j = 0;
        $offset = $post_select_offset ? $post_select_offset : $orig_offset;
        $limit = $post_select_limit ? $post_select_limit : 0;
        $id_list = array();
        $_total_count = 0;
        while (!$result->EOF) {
            $e = new Entry;
            foreach($field_names as $key) {
  	            $key = strtolower($key);
                $e->$key = $result->fields($key);
            }
            $result->MoveNext();

            if (empty($e)) break;
            if (count($filters)) {
                foreach ($filters as $f) {
                    if (!$f($e, $ctx)) {
                        continue 2;
                    }
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
            $e->entry_authored_on = $this->db2ts($e->entry_authored_on);
            $e->entry_modified_on = $this->db2ts($e->entry_modified_on);
            $id_list[] = $e->entry_id;
            $entries[] = $e;
            $this->_comment_count_cache[$e->entry_id] = $e->entry_comment_count;
            $this->_ping_count_cache[$e->entry_id] = $e->entry_ping_count;
            if ( is_null($total_count) ) {
                // the request does not want total count; break early
                if (($limit > 0) && (count($entries) >= $limit)) break;
            }
        }
        Entry::bulk_load_meta($entries);

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
                        $entries_tmp[$e->entry_id] = $e;
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
                        $entries_tmp[$e->entry_id] = $e;
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
                        if (array_key_exists($score->objectscore_object_id, $entries_tmp)) {
                            array_push($entries_sorted, $entries_tmp[$score->objectscore_object_id]);
                            unset($entries_tmp[$score->objectscore_object_id]);
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
                } elseif ($sort_field == 'entry_authored_on') {
                    // already double-sorted by the DB
                } else {
                    if (($sort_field == 'entry_status') || ($sort_field == 'entry_author_id') || ($sort_field == 'entry_id')
                          || ($sort_field == 'entry_comment_count') || ($sort_field == 'entry_ping_count')) {
                        $sort_fn = "if (\$a->$sort_field == \$b->$sort_field) return 0; return \$a->$sort_field < \$b->$sort_field ? -1 : 1;";
                    } else {
                        $sort_fn = "\$f = '" . addslashes($sort_field) . "'; return strcmp(\$a->\$f,\$b->\$f);";
                    }
                    $sorter = create_function(
                        $order == 'asc' ? '$a,$b' : '$b,$a',
                        $sort_fn);
                    usort($entries, $sorter);

                    if (isset($post_sort_offset)) {
                        $entries = array_slice($entries, $post_sort_offset, $post_sort_limit);
                    }
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

    public function fetch_plugin_config($plugin, $scope = "system") {
        if ($scope != 'system') {
            $key = 'configuration:'.$scope;
        } else {
            $key = 'configuration';
        }
        return $this->fetch_plugin_data($plugin, $key);
    }

    public function fetch_plugin_data($plugin, $key) {
        $plugin = $this->escape($plugin);
        $key = $this->escape($key);

        require_once('class.mt_plugindata.php');
        $class = new PluginData;
        $where = "plugindata_plugin = '$plugin'
                  and plugindata_key = '$key'";

        $pdatas = $class->Find($where);
        if (!empty($pdatas)) {

            $data = $pdatas[0]->data;
            if ($data) {
                return $this->unserialize($data);
            }
        }
        return null;
    }

    public function fetch_entry_tags($args) {
        # load tags

        $class = isset($args['class']) ? $args['class'] : 'entry';
        $cacheable 
            = empty( $args['tags'] )
            && empty( $args['tag'] )
            && empty( $args['include_private'] );

        if (isset($args['entry_id'])) {
            if ($cacheable) {
                if (isset($this->_entry_tag_cache[$args['entry_id']])) {
                    return $this->_entry_tag_cache[$args['entry_id']];
                }
            }
            $entry_filter = 'and objecttag_tag_id in (select objecttag_tag_id from mt_objecttag where objecttag_object_id='.intval($args['entry_id']).')';
        }

        $blog_filter = $this->include_exclude_blogs($args);
        if ($blog_filter == '' and isset($args['blog_id'])) {
            if ($cacheable) {
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

        if (empty($args['include_private'])) {
            $private_filter = 'and (tag_is_private = 0 or tag_is_private is null)';
        }
        if (! empty($args['tags'])) {
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
        if ($sort_col == 'tag_name' || $sort_col == 'name') {
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
            order by $sort_col $order $id_order, tag_id desc";
        $rs = $this->db()->SelectLimit($sql);

        require_once('class.mt_tag.php');
        $tags = array();
        while(!$rs->EOF) {
            $tag = new Tag;
            $tag->tag_id = $rs->Fields('tag_id');
            $tag->tag_name = $rs->Fields('tag_name');
            $tag->tag_count = $rs->Fields('tag_count');
            $tags[] = $tag;
            $rs->MoveNext();
        }
        if ($cacheable) {
            if ($args['entry_id'])
                $this->_entry_tag_cache[$args['entry_id']] = $tags;
            elseif ($args['blog_id'])
                $this->_blog_tag_cache[$args['blog_id'].":$class"] = $tags;
        }
        return $tags;
    }

    public function fetch_asset_tags($args) {

        # load tags by asset
        $cacheable = empty( $args['tags'] )
            && empty( $args['include_private'] );

        if (empty($args['include_private'])) {
            $private_filter = 'and (tag_is_private = 0 or tag_is_private is null)';
        }

        if (isset($args['asset_id'])) {
            if ($cacheable) {
                if (isset($this->_asset_tag_cache[$args['asset_id']]))
                    return $this->_asset_tag_cache[$args['asset_id']];
            }
            $asset_filter = 'and objecttag_object_id = '.intval($args['asset_id']);
        }
        
        if (isset($args['blog_id'])) {
            if ($cacheable) {
                if (isset($this->_blog_asset_tag_cache[$args['blog_id']]))
                    return $this->_blog_asset_tag_cache[$args['blog_id']];
            }
            $blog_filter = 'and objecttag_blog_id = '.intval($args['blog_id']);
        }

        if (! empty($args['tags'])) {
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

        $rs = $this->db()->SelectLimit($sql);

        require_once('class.mt_tag.php');
        $tags = array();
        while(!$rs->EOF) {
            $tag = new Tag;
            $tag->tag_id = $rs->Fields('tag_id');
            $tag->tag_name = $rs->Fields('tag_name');
            if (isset($asset_filter)) {
                $tag->tag_count = '';
            } else {
                $tag->tag_count = $rs->Fields('tag_count');
            }
            $tags[] = $tag;
            $rs->MoveNext();
        }

        if ($cacheable) {
            if ($args['asset_id'])
                $this->_asset_tag_cache[$args['asset_id']] = $tags;
            elseif ($args['blog_id'])
                $this->_blog_asset_tag_cache[$args['blog_id']] = $tags;
        }
        return $tags;
    }

    public function fetch_folders($args) {
        $args['class'] = 'folder';
        return $this->fetch_categories($args);
    }

    public function fetch_category($cat_id) {
        if (isset($this->_cat_id_cache['c'.$cat_id])) {
            return $this->_cat_id_cache['c'.$cat_id];
        }
        $cats = $this->fetch_categories(array('category_id' => $cat_id, 'show_empty' => 1));
        if ($cats && (count($cats) > 0)) {
            $this->_cat_id_cache['c'.$cat_id] = $cats[0];
            return $cats[0];
        } else {
            return null;
        }
    }

    public function fetch_categories($args) {
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
                    $children = $cat->children();
                    if (!empty($children)) {
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
            if (is_array($args['label'])) {
                $labels = '';
                foreach ($args['label'] as $c) {
                    if ($labels != '')
                        $labels .= ',';
                    $labels .= "'".$this->escape($c)."'";
                }
                $cat_filter = 'and category_label in ('.$labels.')';
            } else {
                $cat_filter = 'and category_label = \''.$this->escape($args['label']).'\'';
            }
        } else {
            $limit = $args['lastn'];
        }

        if (isset($args['sort_order'])) {
            if ($args['sort_order'] == 'ascend') {
                $sort_order = 'asc';
            } elseif ($args['sort_order'] == 'descend') {
                $sort_order = 'desc';
            }
        } else {
            $sort_order = '';
        }
        $sort_by = 'user_custom';
        if ( isset($args['sort_by']) ) {
            $sort_by = strtolower($args['sort_by']);
            if ( 'user_custom' != $sort_by ) {
                require_once('class.mt_category.php');
                $category_class = new Category();
                if ( $category_class->has_column('category_'.$sort_by) ) {
                    $tableInfo =& $category_class->TableInfo();
                    if ( $tableInfo->flds['category_'.$sort_by]->type == "CLOB" ) {
                        $sort_by = $this->decorate_column('category_'.$sort_by);
                    } else {
                        $sort_by  = 'category_'.$sort_by;
                    }
                } else {
                    $sort_by = 'user_custom';
                }
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
                $entry_filter = ' and placement_entry_id = entry_id and placement_entry_id = '.intval($args['entry_id']);
            } else {
                $entry_filter = ' and placement_entry_id = entry_id and entry_status = 2';
            }
        }

        if (isset($args['class'])) {
            $class = $this->escape($args['class']);
        } else {
            $class = "category";
        }
        $class_filter = " and category_class='$class'";

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
        ";

        if ($limit <= 0) $limit = -1;
        $categories = $this->db()->SelectLimit($sql, $limit, -1);
        if ($categories->EOF)
            return null;

        if (isset($args['children']) && isset($parent_cat)) {
            $parent_cat['_children'] =& $categories;
        } else {
            $ids = array();
            $counts = array();
            while (!$categories->EOF) {
                $ids[] = $categories->Fields('category_id');
                $categories->MoveNext();
            }
            $list = implode(",", $ids);

            require_once('class.mt_category.php');
            $category = new Category;
            $base_sort = 'user_custom' == $sort_by ? 'category_label' : $sort_by;
            $where = "category_id in ($list)
                      order by $base_sort $sort_order";
            $categories = $category->Find($where);
            if ( count($categories) > 1 && 'user_custom' == $sort_by ) {
                $mt = MT::get_instance();
                $ctx = $mt->context();
                $blog = $ctx->stash('blog');
                $meta = $class.'_order';
                try {
                    $custom_order = $blog->$meta;
                    if ( !empty($custom_order) ) {
                        $order_list = preg_split('/\s*,\s*/', $custom_order);
                        $cats = array();
                        foreach ( $categories as $c ) {
                            if ( in_array( $c->id, $order_list ) ) {
                                $key = array_search( $c->id, $order_list );
                                $cats[ $key ] = $c;
                            } else {
                                array_push( $cats, $c );
                            }
                        }
                        if ( 'desc' == $sort_order ) {
                            krsort( $cats );
                        } else {
                            ksort( $cats );
                        }
                        $categories = array_values($cats);
                    }
                } catch (Exception $e) {
                }
            } else {
                
            }

            $id_list = array();
            $top_cats = array();
            $record_count = count($categories);
            for ($i = 0; $i < $record_count; $i++) {
                $cat = $categories[$i];
                $cat_id = $cat->category_id;
                if (isset($args['top_level_categories']) || !isset($this->_cat_id_cache['c'.$cat_id])) {
                    $id_list[] = $cat_id;
                    $this->_cat_id_cache['c'.$cat_id] = $categories[$i];
                }
                if (isset($args['top_level_categories'])) {
                    $this->_cat_id_cache['c'.$cat_id]->children(false);
                }

                if ($cat->category_parent > 0) {
                    $parent_id = $cat->category_parent;
                    if (isset($this->_cat_id_cache['c'.$parent_id])) {
                        if (isset($args['top_level_categories'])) {
                            $parent = $this->fetch_category($parent_id);
                            $children = $parent->children();
                            if (empty($children) || ($children === false)) {
                                $parent->children(array(&$categories[$i]));
                            } else {
                                $parent->children($categories[$i]);
                            }
                        }
                    }
                }
                if ((!$cat->category_parent) && (isset($args['top_level_categories']))) {
                    $top_cats[] = $categories[$i];
                }
            }
            $this->cache_category_links($id_list);
            if (isset($args['top_level_categories'])) {
                return $top_cats;
            }
        }
        return $categories;
    }

    public function fetch_page($eid) {
        if ( isset( $this->_entry_id_cache[$eid] ) && !empty( $this->_entry_id_cache[$eid] ) ) {
            return $this->_entry_id_cache[$eid];
        }
        require_once("class.mt_page.php");
        $page = New Page;
        $page->Load( $eid );
        if ( !empty( $page ) ) {
            $this->_entry_id_cache[$eid] = $page;
            return $page;
        } else {
            return null;
        }
    }

    public function fetch_author($author_id) {
        if (isset($this->_author_id_cache[$author_id])) {
            return $this->_author_id_cache[$author_id];
        }
        $args['author_id'] = $author_id;
        $args['any_type'] = 1;
        list($author) = $this->fetch_authors($args);
        $this->_author_id_cache[$author_id] = $author;
        return $author;
    }

    public function fetch_author_by_name($author_name) {
        $mt = MT::get_instance();
        $args['blog_id'] = $mt->get_current_blog_id();
        $args['author_name'] = $this->escape($author_name);
        list($author) = $this->fetch_authors($args);
        $this->_author_id_cache[$author->author_id] = $author;
        return $author;
    }

    public function fetch_authors($args) {
        # Adds blog join
        $extras = array();
        $blog_ids = $this->include_exclude_blogs($args);
        $mt = MT::get_instance();
        $ctx = $mt->context();
        $blog_ids or $blog_ids = " = " . $ctx->stash('blog_id');

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
        if (isset($args['any_type']) && $args['any_type'] && !isset($args['need_entry']))
            $args['need_entry'] = 0;
        if (!isset($args['need_entry']))
            $args['need_entry'] = 1;
        if ($args['need_entry']) {
            $extras['join']['mt_entry'] = array(
                    'condition' => "author_id = entry_author_id"
                );
            $extras['distinct'] = 'distinct';
            $entry_filter = " and entry_status = 2";
            if ( $blog_ids )
                $entry_filter .= " and entry_blog_id " . $blog_ids;
        } else {
            $extras['distinct'] = 'distinct';
            if (!isset($args['roles']) and !isset($args['role'])) {
                $join_sql = "permission_author_id = author_id";
                if ( isset($args['need_association']) && $args['need_association'] ) {
                    $join_sql .= " and permission_blog_id" . $blog_ids;
                }
                if ( ! $args['any_type'] ) {
                    $join_sql .= "
                        and (
                            (
                                permission_blog_id $blog_ids
                                and (
                                    permission_permissions like '%create_post%' or
                                    permission_permissions like '%publish_post%'
                                )
                            ) or (
                                permission_blog_id = 0
                                and 
                                    permission_permissions like '%administer%'  
                           )
                       )
                    ";
                } else {
                    $join_sql .= "
                        and
                            (
                                (
                                    permission_blog_id $blog_ids
                                    and permission_permissions is not null
                                )
                            or
                                (
                                    permission_blog_id = 0
                                    and
                                        (
                                            permission_permissions like '%administer%'
                                            or
                                            permission_permissions like '%comment%'
                                        )
                                )
                            )
                        ";
                }
                
                $sql = $join_sql;
                $extras['join']['mt_permission'] = array(
                    'condition' => $sql
                );
            }
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
            $roles = $this->fetch_all_roles();
            if (!is_array($roles)) $roles = array();

            $cexpr = create_role_expr_function($role_arg, $roles);
            if ($cexpr) {
                $rmap = array();
                $role_list = array();
                foreach ($roles as $role) {
                    $role_list[] = $role->role_id;
                }
                $as = $this->fetch_associations(array('blog_id' => $blog_id, 'role_id' => $role_list));
                foreach ($as as $a) {
                    if (($a->association_type == 2) || ($a->association_type == 5)) {
                        $as2 = $this->fetch_associations(
                            array('group_id' => array($a->association_group_id), 'type' => 3, 'blog_id' => 0));
                        foreach ($as2 as $a2) {
                            $rmap[$a2->association_author_id][$a->association_role_id]++;
                        }
                    }
                    else {
                        $rmap[$a->association_author_id][$a->association_role_id]++;
                    }
                }
                $ctx['r'] =& $rmap;
                $filters[] = $cexpr;
            }
        }

        # Adds a score or rate filter to the filters list.
        $re_sort = false;
        if (isset($args['namespace'])) {
            if (isset($args['scoring_to'])) {
                require_once("MTUtil.php");
                require_once("rating_lib.php");
                $type = $args['scoring_to'];
                $obj = $args['_scoring_to_obj'];
                $field_name = $type.'_id';
                $obj_id = $obj->$field_name;
                if (isset($args['min_score'])) {
                    $expr = '$ctx = $c;if ($ctx == null) { $mt = MT::get_instance(); $ctx = $mt->context(); } ';
                    $expr .= '$sc = get_score($ctx, '.$obj_id.', "'.$type.'", "'.$args['namespace'].'", $e->author_id);';
                    $expr .= '$ret = $sc >= '.$args['min_score'].';';
                    $expr .= ' return $ret;';
                    $fn = create_function('&$e,&$c', $expr);
                    $filters[] = $fn;
                } elseif (isset($args['max_score'])) {
                    $expr = '$ctx = $c;if ($ctx == null) { $mt = MT::get_instance(); $ctx = $mt->context(); } ';
                    $expr .= '$sc = get_score($ctx, '.$obj_id.', "'.$type.'", "'.$args['namespace'].'", $e->author_id);';
                    $expr .= '$ret = $sc <= '.$args['max_score'].';';
                    $expr .= ' return $ret;';
                    $fn = create_function('&$e,&$c', $expr);
                    $filters[] = $fn;
                }
                else {
                    $expr = '$ctx = $c;if ($ctx == null) { $mt = MT::get_instance(); $ctx = $mt->context(); } ';
                    $expr .= '$ret = !is_null($ctx->mt->db()->fetch_score('.$args['namespace'].','.$obj_id.', $e->author_id,'.$type.'));';
                    $expr .= ' return $ret;';
                    $fn = create_function('&$e,&$c', $expr);
                    $filters[] = $fn;
                }
            }
            else {
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
        }

        # sort
        $join_score = "";
        if (isset($args['sort_by'])) {
            if (($args['sort_by'] == 'score') || ($args['sort_by'] == 'rate')) {
                $extras['join']['mt_objectscore'] = array(
                    'condition' => "objectscore_object_id = author_id and objectscore_namespace='".$args['namespace']."' and objectscore_object_ds='author'"
                    );
                $extras['distinct'] = "distinct";
                $order_sql = "order by author_created_on desc";
                $re_sort = true;
            } else {
                $sort_col = $args['sort_by'];
                if (strtolower($sort_col) == 'display_name') $sort_col = 'nickname';
                if (!preg_match('/^author_/i', $sort_col)) $sort_col = 'author_' . $sort_col;
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
         if (isset($args['limit']))
            $limit = $args['limit'];

         $lastn = isset($args['lastn']) ? $args['lastn'] : 0;
        if ($re_sort) {
            $post_select_limit = $lastn;
            $lastn = 0;
            $post_select_offset = isset($args['offset']) ? $args['offset'] : 0;
        }

        $where = "1 = 1
                  $author_filter
                  $entry_filter
                  $sort_filter
                  $order_sql
        ";
        if ($limit) $extras['limit'] = $limit;

        require_once('class.mt_author.php');
        $author = new Author;
        $results = $author->Find($where, false, false, $extras);
        $authors = array();
        if ($args['sort_by'] != 'score' && $args['sort_by'] != 'rate') {
            $offset = $post_select_offset ? $post_select_offset : 0;
            $limit = $post_select_limit ? $post_select_limit : 0;
        }
        $j = 0;
        $i = -1;
        while (true) {
            $i++;
            $e = $results[$i];
            if ($offset && ($j++ < $offset)) continue;
            if (empty($e)) break;
            if (count($filters)) {
                foreach ($filters as $f) {
                    if (!$f($e, $ctx)) continue 2;
                }
            }
            $authors[] = $e;
            if (($lastn > 0) && (count($authors) >= $lastn)) break;
        }

        if (isset($args['sort_by']) && ('score' == $args['sort_by'])) {
            $authors_tmp = array();
            $order = 'desc';
            if (isset($args['sort_order']))
                $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
            foreach ($authors as $a) {
                $authors_tmp[$a->author_id] = $a;
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
                $authors_tmp[$a->author_id] = $a;
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

    public function fetch_permission($args) {
        // Blog filter
        if ($sql = $this->include_exclude_blogs($args)) {
            $blog_filter = 'and permission_blog_id ' . $sql;
        } elseif (isset($args['blog_id'])) {
            $blog_id = intval($args['blog_id']);
            $blog_filter = "and permission_blog_id = $blog_id";
        }

        // Author filter
        if (isset($args['id'])) {
            $id_filter = 'and permission_author_id in ('.$args['id'].')';
        }

        require_once('class.mt_permission.php');
        $perm = new Permission;
        $where = "1 = 1
                  $blog_filter
                  $id_filter
                  order by permission_id asc";

        $result = $perm->Find($where);
        return $result;
    }

    public function fetch_all_roles() {
        require_once('class.mt_role.php');
        $role = new Role;
        $result = $role->Find('1 = 1 order by role_name');
        return $result;
    }

    public function fetch_associations($args) {
        $where_list = array();
        if (isset($args['role_id'])) {
            $id_list = implode(",", $args['role_id']);
            $where_list[] = "association_role_id in ($id_list)";
        }
        if (isset($args['group_id'])) {
            $id_list = implode(",", $args['group_id']);
            $where_list[] = "association_group_id in ($id_list)";            
        }
        if (isset($args['type'])) {
            $where_list[] = "association_type=".intval($args['type']);
        }
        if (empty($where_list))
            return;

        // Blog Filter
        if ($sql = $this->include_exclude_blogs($args)) {
            $where_list[] = 'association_blog_id  ' . $sql;
        }

        require_once('class.mt_association.php');
        $assoc = new Association;
        $where = implode(' and ', $where_list);
        $result = $assoc->Find($where);
        if (!$result)
            return array();
        return $result;
    }

    public function fetch_tag($tag_id) {
        $tag_id = intval($tag_id);
        if (isset($this->_tag_id_cache[$tag_id])) {
            return $this->_tag_id_cache[$tag_id];
        }

        require_once('class.mt_tag.php');
        $tag = new Tag;
        $loaded = $tag->Load("tag_id = $tag_id");
        if ($loaded)
            $this->_tag_id_cache[$tag->tag_id] = $tag;

        return $loaded ? $tag : null;
    }

    public function fetch_tag_by_name($tag_name) {
        $tag_name = $this->escape($tag_name);

        require_once('class.mt_tag.php');
        $tag = new Tag;
        $loaded = $tag->Load("tag_name = '$tag_name'");
        if ($loaded)
            $this->_tag_id_cache[$tag->tag_id] = $tag;

        return $loaded ? $tag : null;
    }

    public function fetch_scores($namespace, $obj_id, $datasource) {
        $namespace = $this->escape($namespace);
        $obj_id = intval($obj_id);
        $datasource = $this->escape($datasource);

        $where = "objectscore_namespace='$namespace'
                  and objectscore_object_id='$obj_id'
                  and objectscore_object_ds='$datasource'";

        require_once('class.mt_objectscore.php');
        $score = new ObjectScore;
        $result = $score->Find($where);
        return $result;
    }

    public function fetch_score($namespace, $obj_id, $user_id, $datasource) {
        $namespace = $this->escape($namespace);
        $obj_id = intval($obj_id);
        $user_id = intval($user_id);
        $datasource = $this->escape($datasource);

        $where = "objectscore_namespace='$namespace'
                  and objectscore_object_id='$obj_id'
                  and objectscore_object_ds='$datasource'
                  and objectscore_author_id='$user_id'";

        require_once('class.mt_objectscore.php');
        $score = new ObjectScore;
        $loaded = $score->Load($where);
        return $loaded ? $score : null;
    }

    public function fetch_sum_scores($namespace, $datasource, $order, $filters) {
        $othertables = '';
        $otherwhere = '';
        if ($datasource == 'asset') {
            $othertables = ', mt_author';
            $otherwhere = 'AND (objectscore_author_id = author_id)';
        }
        $join_column = $datasource . '_id';
        $join_where = "AND ($join_column = objectscore_object_id)";
        $sql_scores = "
             SELECT SUM(objectscore_score) AS sum_objectscore_score, objectscore_object_id
             FROM mt_objectscore, mt_$datasource $othertables
             WHERE (objectscore_namespace = '$namespace')
             AND (objectscore_object_ds = '$datasource')
             $join_where
             $otherwhere
             $filters
             GROUP BY objectscore_object_id 
             ORDER BY sum_objectscore_score " . $order;

        $scores = $this->db()->Execute($sql_scores);
        return $scores;
    }

    public function fetch_avg_scores($namespace, $datasource, $order, $filters) {
        $othertables = '';
        $otherwhere = '';
        if ($datasource == 'asset') {
            $othertables = ', mt_author';
            $otherwhere = 'AND (objectscore_author_id = author_id)';
        }
        $join_column = $datasource . '_id';
        $join_where = "AND ($join_column = objectscore_object_id)";
        $sql_scores = "
            SELECT AVG(objectscore_score) AS sum_objectscore_score, objectscore_object_id
             FROM mt_objectscore, mt_$datasource $othertables
             WHERE (objectscore_namespace = '$namespace')
             AND (objectscore_object_ds = '$datasource')
             $join_where
             $otherwhere
             $filters
             GROUP BY objectscore_object_id 
             ORDER BY sum_objectscore_score " . $order;

        $scores = $this->db()->Execute($sql_scores);
        return $scores;
    }

    public function cache_permalinks($entry_list) {
        $ids = array();
        foreach ($entry_list as $entry_id) {
            if (!isset($this->_entry_link_cache[$entry_id.';Individual'])) {
                $ids[] = $entry_id;
                $this->_entry_link_cache[$entry_id.';Individual'] = ''; 
            }
        }
        if (empty($ids))
            return;
        $id_list = implode(",", $ids);
        if (empty($id_list))
            return;

        $query = "
            select fileinfo_entry_id, fileinfo_url, A.blog_site_url as blog_site_url, A.blog_file_extension as blog_file_extension, A.blog_archive_url as blog_archive_url, B.blog_site_url as website_url
            from mt_fileinfo, mt_templatemap, mt_blog A, mt_blog B
            where fileinfo_entry_id in ($id_list)
            and fileinfo_archive_type = 'Individual'
            and A.blog_id = fileinfo_blog_id
            and templatemap_id = fileinfo_templatemap_id
            and templatemap_is_preferred = 1
            and A.blog_parent_id = B.blog_id
            and B.blog_class = 'website'
            and A.blog_class = 'blog'
        ";

        $results = $this->db()->Execute($query);
        if (!empty($results)) {
            foreach ($results as $row) {
                $blog_url = $row['blog_archive_url'];
                if (empty($blog_url))
                    $blog_url = $row['blog_site_url'];

                preg_match('/^(https?):\/\/(.+)\/$/', $row['website_url'], $matches);
                if ( count($matches > 1 ) ) {
                    $site_url = preg_split( '/\/::\//', $blog_url );
                    if ( count($site_url > 0 ) )
                        $path = $matches[1] . '://' . $site_url[0] . $matches[2] . '/' . $site_url[1];
                    else
                        $path = $row['website_url'] . $this->blog_url;
                }
                else {
                    $path = $row['website_url'] . $blog_url;
                }

                $blog_url = $path;
                $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
                $url = $blog_url . $row['fileinfo_url'];
                $url = _strip_index($url, array('blog_file_extension' => $row['blog_file_extension']));
                $this->_entry_link_cache[$row['fileinfo_entry_id'].';Individual'] = $url;
            }
        }

        return true;
    }

    public function cache_category_links($cat_list) {
        $ids = array();
        foreach ($cat_list as $cat_id) {
            if (!isset($this->_cat_link_cache[$cat_id])) {
                $ids[] = $cat_id;
                $this->_cat_link_cache[$cat_id] = '';
            }
        }
        if (empty($ids))
            return;
        $id_list = implode(",", $ids);
        if (empty($id_list))
            return;

        $query = "
            select fileinfo_category_id, fileinfo_url, A.blog_site_url as blog_site_url, A.blog_file_extension as blog_file_extension, A.blog_archive_url as blog_archive_url, B.blog_site_url as website_url
              from mt_fileinfo, mt_templatemap, mt_blog A, mt_blog B
             where fileinfo_category_id in ($id_list)
               and fileinfo_archive_type = 'Category'
              and A.blog_id = fileinfo_blog_id
               and templatemap_id = fileinfo_templatemap_id
               and templatemap_is_preferred = 1
               and A.blog_parent_id = B.blog_id
               and B.blog_class = 'website'
               and A.blog_class = 'blog'
        ";
        $results = $this->db()->Execute($query);
        if ($results) {
            foreach ($results as $row) {
                $blog_url = $row['blog_archive_url'];
                $blog_url or $blog_url = $row['blog_site_url'];

                preg_match('/^(https?):\/\/(.+)\/$/', $row['website_url'], $matches);
                if ( count($matches > 1 ) ) {
                    $site_url = preg_split( '/\/::\//', $blog_url );
                    if ( count($site_url > 0 ) )
                        $path = $matches[1] . '://' . $site_url[0] . $matches[2] . '/' . $site_url[1];
                    else
                        $path = $row['website_url'] . $this->blog_url;
                }
                else {
                    $path = $row['website_url'] . $blog_url;
                }

                $blog_url = $path;
                $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
                $url = $blog_url . $row['fileinfo_url'];
                $url = _strip_index($url, array('blog_file_extension' => $row['blog_file_extension']));
                $this->_cat_link_cache[$row['fileinfo_category_id']] = $url;
            }
        }

        return true;
    }

    public function cache_comment_counts($entry_list) {
        $ids = array();
        foreach ($entry_list as $entry_id) {
            if (!isset($this->_comment_count_cache[$entry_id])) {
                $ids[] = $entry_id;
                $this->_comment_count_cache[$entry_id] = 0;
            }
        }
        if (empty($ids))
            return;
        $id_list = implode(",", $ids);
        if (empty($id_list))
            return;

        require_once('class.mt_entry.php');
        $entry = new Entry;
        $where = "entry_id in ($id_list)";

        $results = $entry->Find($where);
        if (!empty($results)) {
            foreach ($results as $e) {
                $this->_comment_count_cache[$e->id] = $e->comment_count;
            }
        }

        return true;
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
        $author_filter = '';
        if (isset($args['author_id'])) {
            $author_id = intval($args['author_id']);
            $author_filter = 'and entry_author_id = ' . $author_id;
        }

        $where = "entry_status = 2
                  and entry_class='$class'
                  $blog_filter
                  $author_filter";

        require_once('class.mt_entry.php');
        $entry = new Entry;
        $result = $entry->count(array('where' => $where));
        return $result;
    }

    public function blog_comment_count($args) {
        if ($sql = $this->include_exclude_blogs($args)) {
            $blog_filter = 'and comment_blog_id ' . $sql;
        } elseif (isset($args['blog_id'])) {
            $blog_id = intval($args['blog_id']);
            $blog_filter = 'and comment_blog_id = ' . $blog_id;
        }

        $where = "entry_status = 2
                  and comment_visible = 1
                  $blog_filter";
        $join = array();
        $join['mt_entry'] =
            array(
                'condition' => 'comment_entry_id = entry_id'
            );
        require_once('class.mt_comment.php');
        $comment = new Comment;
        $result = $comment->count(array('where' => $where, 'join' => $join));
        return $result;
    }

    public function category_comment_count($args) {
        $cat_id = intval($args['category_id']);

        $where = "placement_category_id = $cat_id
              and entry_status=2
              and comment_visible=1";
        $join['mt_entry'] =
             array(
                'condition' => 'comment_entry_id = entry_id'
                );
        $join['mt_placement'] =
            array(
                'condition' => 'entry_id = placement_entry_id'
                );

        require_once('class.mt_comment.php');
        $comment = new Comment;
        $result = $comment->count(array('where' => $where, 'join' => $join));
        return $result;
    }

    public function blog_ping_count($args) {
        if ($sql = $this->include_exclude_blogs($args)) {
            $blog_filter = 'and tbping_blog_id ' . $sql;
        } elseif (isset($args['blog_id'])) {
            $blog_id = intval($args['blog_id']);
            $blog_filter = 'and tbping_blog_id = ' . $blog_id;
        }

        $where = "tbping_visible = 1
                  $blog_filter";

        $join['mt_trackback'] =
            array(
                "condition" => "tbping_tb_id = trackback_id"
                );

        require_once('class.mt_tbping.php');
        $tbping = new TBPing;
        $result = $tbping->count(array('where' => $where, 'join' => $join));
        return $result;
    }

    public function blog_category_count($args) {
        if ($sql = $this->include_exclude_blogs($args)) {
            $blog_filter = 'and category_blog_id ' . $sql;
        } elseif (isset($args['blog_id'])) {
            $blog_id = intval($args['blog_id']);
            $blog_filter = 'and category_blog_id = ' . $blog_id;
        }

        $where = "category_class = 'category'
                  $blog_filter";

        require_once('class.mt_category.php');
        $cat = new Category;
        $result = $cat->count(array('where' => $where));
        return $result;
    }

    public function tags_entry_count($tag_id, $class = 'entry') {
        $tag_id = intval($tag_id);

        $where = "objecttag_tag_id = $tag_id";

        if ($class == 'entry') {
            $where .= "and entry_status = 2 and entry_class = '$class'";
        }

        $join['mt_objecttag'] = 
            array(
                "condition" => "${class}_id = objecttag_object_id and objecttag_object_datasource='$class'"
                );

        require_once("class.mt_$class.php");
        $entry = new $class();
        $count = $entry->count(array('where' => $where, 'join' => $join));
        return $count;
    }

    public function entry_comment_count($entry_id) {
        $entry_id = intval($entry_id);
        if (isset($this->_comment_count_cache[$entry_id])) {
            return $this->_comment_count_cache[$entry_id];
        }

        require_once('class.mt_entry.php');
        $entry = new Entry;
        $loaded = $entry->Load("entry_id = $entry_id");
        $count = 0;
        if ($loaded) {
            $count = $entry->entry_comment_count;
            $this->_comment_count_cache[$entry_id] = $count;
        }
        return $count;
    }

    public function author_entry_count($args) {
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
        $class = 'entry';
        if (isset($args['class'])) {
            $class = $args['class'];
        }

        $where = "entry_status = 2
                  and entry_class='$class'
                  $blog_filter
                  $author_filter";

        require_once('class.mt_entry.php');
        $entry = new Entry;
        $count = $entry->count(array('where' => $where));
        return $count;
    }

    public function fetch_placements($args) {
        $id_list = '';
        if (isset($args['category_id']))
            $id_list = implode(',', $args['category_id']);
        if (empty($id_list))
            return;

        $where = "placement_category_id in ($id_list)
                  and entry_status = 2";
        $extras['join'] = array(
            'mt_entry' => array(
                'condition' => 'entry_id = placement_entry_id'
                )
            );

        require_once('class.mt_placement.php');
        $placement = new Placement;
        return $placement->Find($where, false, false, $extras);
    }


    public function fetch_objecttags($args) {
        $id_list = '';
        if (isset($args['tag_id']))
            $id_list = implode(',', $args['tag_id']);
        if (empty($id_list))
            return;

        $blog_filter = $this->include_exclude_blogs($args);
        if ($blog_filter != '')
            $blog_filter = 'and objecttag_blog_id' . $blog_filter;

        $extras = array();
        if (isset($args['datasource']) && strtolower($args['datasource']) == 'asset') {
            $datasource = $args['datasource'];
            $extras['join'] = array(
                'mt_asset' => array(
                    'condition' => 'asset_id = objecttag_object_id'
                    )
                );
        } else {
            $datasource = 'entry';
            $extras['join'] = array(
                'mt_entry' => array(
                    'condition' => 'entry_id = objecttag_object_id'
                    )
                );
            $object_filter = 'and entry_status = 2';
        }

        require_once('class.mt_objecttag.php');
        $otag = new ObjectTag;

        $where = "objecttag_object_datasource ='$datasource'
                and objecttag_tag_id in ($id_list)
                $blog_filter
                $object_filter";

        return $otag->Find($where, false, false, $extras);
    }

    public function fetch_comments($args) {
        # load comments
        $extras = array();

        $entry_id = intval($args['entry_id']);

        $sql = $this->include_exclude_blogs($args);
        if ($sql != '') {
            $blog_filter = 'and comment_blog_id ' . $sql;
            if (isset($args['blog_id']))
                $blog = $this->fetch_blog(intval($args['blog_id']));
        } elseif ($args['blog_id']) {
            $blog = $this->fetch_blog(intval($args['blog_id']));
            $blog_filter = ' and comment_blog_id = ' . $blog->blog_id;
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
                if (empty($voter)) {
                    echo "Invalid scored by filter: ".$args['scored_by'];
                    return null;
                }
                $cexpr = create_rating_expr_function($voter->author_id, 'scored_by', $args['namespace'], 'comment');
                if ($cexpr) {
                    $filters[] = $cexpr;
                } else {
                    return null;
                }
            }
        }

        $order = $query_order = 'asc';
        if (isset($args['sort_order'])) {
            if ($args['sort_order'] == 'descend') {
                $order = $query_order = 'desc';
            }
        } elseif ((isset($blog) && isset($blog->blog_sort_order_comments)) && !isset($args['lastn'])) {
            if ($blog->blog_sort_order_comments == 'ascend') {
                $order = $query_order = 'asc';
            }
        }
        if (($order == 'asc') && (isset($args['lastn']) || isset($args['offset']))) {
            $reorder = 1;
            $query_order = 'desc';
        }

        if ($entry_id) {
            $entry_filter = " and comment_entry_id = $entry_id";
            $extras['join']['mt_entry'] = array(
                'condition' => "entry_id = comment_entry_id"
                );
        } else {
            $extras['join']['mt_entry'] = array(
                'condition' => "entry_id = comment_entry_id and entry_status = 2"
                );
        }

        $join_score = "";
        $distinct = "";
        if ( isset($args['sort_by'])
          && (($args['sort_by'] == 'score') || ($args['sort_by'] == 'rate')) ) {
             $extras['join']['mt_objectscore'] = array(
                 'condition' => "objectscore_object_id = comment_id and objectscore_namespace='".$args['namespace']."' and objectscore_object_ds='comment'"
                 );
             $extras['distinct'] = 'distinct';
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

        if ($limit) $extras['limit'] = $limit;
        if ($offset) $extras['offset'] = $offset;

        $where = "
             comment_visible = 1
             $entry_filter
             $blog_filter
             order by comment_created_on $query_order";

        require_once('class.mt_comment.php');
        $comment = new Comment;
        $result = $comment->Find($where, false, false, $extras);
        if (empty($result)) return null;

        $comments = array();
        $j = 0;
        $i = -1;
        while (true) {
            $i++;
            $e = $result[$i];
            if (empty($e)) break;
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
                $comments_tmp[$c->comment_id] = $c;
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
                $comments_tmp[$c->comment_id] = $c;
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
            if ( $order == 'asc' ) {
                $resorting = create_function('$a,$b', 'return strcmp($a->comment_created_on, $b->comment_created_on);');
            } else {
                $resorting = create_function('$a,$b', 'return strcmp($b->comment_created_on, $a->comment_created_on);');
            }
            usort($comments, $resorting);
        }

        return $comments;
    }

    public function fetch_comment_parent($args) {
        if (!$args['parent_id'])
            return null;

        $parent_id = intval($args['parent_id']);

        $sql = $this->include_exclude_blogs($args);
        if ($sql != '') {
            $blog_filter = 'and comment_blog_id ' . $sql;
            if (isset($args['blog_id']))
                $blog = $this->fetch_blog($args['blog_id']);
        } elseif ($args['blog_id']) {
            $blog = $this->fetch_blog($args['blog_id']);
            $blog_filter = ' and comment_blog_id = ' . $blog->blog_id;
        }

        $where = "1 = 1
                  $blog_filter
                  and comment_id = $parent_id
                  and comment_visible = 1";

        require_once('class.mt_comment.php');
        $comment = new Comment;
        $comments = $comment->Find($where);
        if (!empty($comments))
            $comment = $comments[0];
        else
            $comment = null;

        return $comment;
    }

    public function fetch_comment_replies($args) {
        if (!$args['comment_id'])
            return array();

        $comment_id = intval($args['comment_id']);

        $sql = $this->include_exclude_blogs($args);
        if ($sql != '') {
            $blog_filter = 'and comment_blog_id ' . $sql;
            if (isset($args['blog_id']))
                $blog = $this->fetch_blog($args['blog_id']);
        } elseif ($args['blog_id']) {
            $blog = $this->fetch_blog($args['blog_id']);
            $blog_filter = ' and comment_blog_id = ' . $blog->blog_id;
        }

        $order = 'asc';
        if (isset($args['sort_order'])) {
            if ($args['sort_order'] == 'descend') {
                $order = 'desc';
            }
        } elseif (isset($blog) && isset($blog->blog_sort_order_comments)) {
            if ($blog->blog_sort_order_comments == 'ascend') {
                $order = 'asc';
            }
        }
        if ($order == 'asc' && $args['lastn']) {
            $reorder = 1;
            $order = 'desc';
        }

        $where = "1 = 1
                  $blog_filter
                  and comment_parent_id = $comment_id
                  and comment_visible = 1
                  order by comment_created_on $order";

        $extras = array();
        if (isset($args['lastn']) && is_numeric($args['lastn']))
            $extras['limit'] = $args['lastn'];
        if (isset($args['offset']) && is_numeric($args['lastn']))
            $extras['offset'] = $args['offset'];

        require_once('class.mt_comment.php');
        $comment = new Comment;
        $comments = $comment->Find($where, false, false, $extras);
        if (empty($comments))
            return array();

        if ($reorder) {  // lastn and ascending sort
            $asc_created_on = create_function('$a,$b', 'return strcmp($a->comment_created_on, $b->comment_created_on);');
            usort($comments, $asc_created_on);
        }
  
        return $comments;
    }

    public function cache_ping_counts($entry_list) {
        $ids = array();
        foreach ($entry_list as $entry_id) {
            if (!isset($this->_ping_count_cache[$entry_id])) {
                $ids[] = $entry_id;
                $this->_ping_count_cache[$entry_id] = 0;
            }
        }
        if (empty($ids))
            return;
        $id_list = implode(",", $ids);
        if (empty($id_list))
            return;

        $where = "entry_id in ($id_list)";

        require_once('class.mt_entry.php');
        $entry = new Entry;
        $entries = $entry->Find($where);
        if (!empty($results)) {
            foreach ($entries as $e) {
                $this->_ping_count_cache[$e->id] = $e->ping_count;
            }
        }

        return true;
    }

    public function entry_ping_count($entry_id) {
        if (isset($this->_ping_count_cache[$entry_id])) {
            return $this->_ping_count_cache[$entry_id];
        }

        require_once('class.mt_entry.php');
        $entry = new Entry;
        $loaded = $entry->Load("entry_id = $entry_id");
        $count = 0;
        if ($loaded) {
            $count = $entry->entry_ping_count;
            $this->_ping_count_cache[$entry_id] = $count;
        }

        return $count;
    }

    public function category_ping_count($cat_id) {
        $cat_id = intval($cat_id);

        $where = "trackback_category_id = $cat_id
                  and tbping_visible = 1";
        $join['mt_trackback'] = 
            array(
                'condition' => "tbping_tb_id = trackback_id "
                );

        require_once('class.mt_tbping.php');
        $tbping = new TBPing;
        $count = $tbping->count(array('where' => $where, 'join' => $join));
        return $count;
    }

    public function fetch_pings($args) {
        # load pings  
        $sql = $this->include_exclude_blogs($args);
        if ($sql != '') {
            $blog_filter = 'and tbping_blog_id ' . $sql;
            if (isset($args['blog_id']))
                $blog = $this->fetch_blog($args['blog_id']);
        } elseif (isset($args['blog_id'])) {
            $blog = $this->fetch_blog($args['blog_id']);
            $blog_filter = ' and tbping_blog_id = ' . $blog->blog_id;
        }

        $order = isset($args['lastn']) ? 'desc' : 'asc';
        if (isset($args['sort_order'])) {
            if ($args['sort_order'] == 'descend') {
                $order = 'desc';
            } elseif ($args['sort_order'] == 'ascend') {
                $order = 'asc';
            }
        }

        $extras = array();
        if (isset($args['entry_id'])) {
            $entry_filter = 'and trackback_entry_id = ' . intval($args['entry_id']);
            $extras['join']['mt_trackback'] = array(
                'condition' => 'tbping_tb_id = trackback_id'
                );
        }

        $where = "tbping_visible = 1
                  $entry_filter
                  $blog_filter
                  order by tbping_created_on $order";

        if (isset($args['lastn']) && is_numeric($args['lastn']))
            $extras['limit'] = $args['lastn'];
        if (isset($args['offset']) && is_numeric($args['lastn']))
            $extras['offset'] = $args['offset'];

        require_once('class.mt_tbping.php');
        $tbping = new TBPing;
        $results = $tbping->Find($where, false, false, $extras);
        return $results;
    }

    public function cache_categories($entry_list) {
        $ids = null;
        foreach ($entry_list as $entry_id) {
            if (!isset($this->_cat_id_cache['e'.$entry_id]))
                $ids[] = $entry_id;
            $this->_cat_id_cache['e'.$entry_id] = null;
        }
        if (empty($ids))
            return;
        $id_list = implode(",", $ids);
        if (empty($id_list))
            return;

        $where = "placement_entry_id in ($id_list)
               and placement_is_primary = 1";

        $extras['join'] = array(
                'mt_category' => array(
                    'condition' => "placement_category_id = category_id"
                    )
                );

        require_once('class.mt_placement.php');
        $placement = new Placement;
        $rows = $placement->Find($where, false, false, $extras);

        if (!empty($rows)) {
            foreach ($rows as $row) {
                $entry_id = $row->entry_id;
                $this->_cat_id_cache['e'.$entry_id] = $row;
                $cat_id = $row->category_id;
                if (!isset($this->_cat_id_cache['c'.$cat_id])) {
                    $cat = $row->category();
                    $this->_cat_id_cache['c'.$cat_id] = $cat;
                }
            }
        }
        return true;
    }

    public function fetch_folder($cat_id) {
        if (isset($this->_cat_id_cache['c'.$cat_id])) {
            return $this->_cat_id_cache['c'.$cat_id];
        }

        $cats = $this->fetch_categories(array('category_id' => $cat_id, 'show_empty' => 1, 'class' => 'folder'));
        if (!empty($cats)) {
            $this->_cat_id_cache['c'.$cat_id] = $cats[0];
            return $cats[0];
        } else {
            return null;
        }
    }

    public function asset_count($args) {
        if (isset($args['blog_id'])) {
            $blog_filter = 'and asset_blog_id = '.intval($args['blog_id']);
        }

        # Adds a type filter
        if (isset($args['type'])) {
            $type_filter = "and asset_class ='" . $args['type'] . "'";
        }

        $where = "1 = 1
                  $blog_filter
                  $type_filter";

        require_once('class.mt_asset.php');
        $asset = new Asset;
        $count = $asset->count(array('where' => $where));
        return $count;
    }

    function fetch_assets($args) {
        # load assets
        $extras = array();

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

            $tags = $this->fetch_asset_tags(array('blog_id' => $blog_id, 'tag' => $tag_arg, 'include_private' => $include_private));
            if (!is_array($tags)) $tags = array();
            $cexpr = create_tag_expr_function($tag_arg, $tags, 'asset');
            if ($cexpr) {
                $tmap = array();
                $tag_list = array();
                foreach ($tags as $tag) {
                    $tag_list[] = $tag->tag_id;
                }
                $ot = $this->fetch_objecttags(array('tag_id' => $tag_list, 'datasource' => 'asset'));
                if (!empty($ot)) {
                    foreach ($ot as $o) {
                        $tmap[$o->objecttag_object_id][$o->objecttag_tag_id]++;
                        if (!$not_clause)
                            $asset_list[$o->objecttag_object_id] = 1;
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
            $author_filter = "and author_name = '".$this->escape($args['author']) . "'";
            $extras['join']['mt_author'] = array(
                'condition' => "author_id = asset_created_by"
                );
        }

        # Adds an entry filter
        if (isset($args['entry_id'])) {
            $extras['join']['mt_objectasset'] = array(
                'condition' => "(objectasset_object_ds = 'entry' and objectasset_object_id = " . intval($this->escape($args['entry_id'])) . " and asset_id = objectasset_asset_id)"
                );
        }

        # Adds an ID filter
        if ( isset($args['id']) ) {
            if ( $args['id'] == '' ) return null;
            $id_filter = 'and asset_id = ' . intval($args['id']);
        }

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
                $cexpr = create_rating_expr_function($voter->author_id, 'scored_by', $args['namespace'], 'asset');
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
             $extras['join']['mt_objectscore'] = array(
                 'type' => 'left',
                 'condition' => "objectscore_object_id = asset_id"
                 );
             $extras['distinct'] = 'distinct';
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
        if ($limit) $extras['limit'] = $limit;
        if ($offset) $extras['offset'] = $offset;

        # Build SQL
        $where = "1 = 1
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
        ";

        require_once('class.mt_asset.php');
        $asset = new Asset;
        $result = $asset->Find($where, false, false, $extras);
        if (empty($result)) return null;

        $assets = array();
        $offset = $post_select_offset ? $post_select_offset : 0;
        $limit = $post_select_limit ? $post_select_limit : 0;

        $i = -1;
        while (true) {
            $i++;
            $e = $result[$i];
            if ($offset && ($j++ < $offset)) continue;
            if (!isset($e)) break;
            if (count($filters)) {
                foreach ($filters as $f) {
                    if (!$f($e, $ctx)) continue 2;
                }
            }
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
                $assets_tmp[$a->asset_id] = $a;
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
                $assets_tmp[$a->asset_id] = $a;
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

    public function update_archive_link_cache($args) {
        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $where = isset($args['where']) ? $args['where'] : '';

        if (isset($args['hi']) && isset($args['low'])) {
            $hi = $args['hi'];
            $low = $args['low'];
            $range = " and fileinfo_startdate between '$low' and '$hi'";
        }

        $sql = "
            fileinfo_archive_type = '$at'
            and fileinfo_blog_id = $blog_id
            and templatemap_is_preferred = 1
            $range
            $where";
        $extras['join']['mt_templatemap'] = array(
            'condition' => "templatemap_id = fileinfo_templatemap_id"
            );

        require_once('class.mt_fileinfo.php');
        $fileinfo = new FileInfo();
        $finfos = $fileinfo->Find($sql, false, false, $extras);
        if (!empty($finfos)) {
            $mt = MT::get_instance();
            foreach($finfos as $finfo) {
                $date = $this->db2ts($finfo->fileinfo_startdate);
                if ($at == 'Page') {
                    $blog_url = $finfo->blog()->site_url();
                } else {
                    $blog_url = $finfo->blog()->archive_url();
                    $blog_url or $blog_url = $finfo->blog()->site_url();
                }
                $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
                $url = $blog_url . $finfo->url;
                $url = _strip_index($url, array('blog_file_extension' => $finfo->blog()->blog_file_extension));
                $this->_archive_link_cache[$date.';'.$at] = $url;
            }
        }
        return true;
    }

    protected function entries_recently_commented_on_sql($subsql) {
        $sql = "
            select distinct
                subs.*
            from
                ($subsql) subs
                inner join mt_comment on comment_entry_id = entry_id and comment_visible = 1
            order by
                comment_created_on desc
            <LIMIT>
        ";
        return $sql;
    }

    public function fetch_session($id) {
        $sessions = $this->fetch_unexpired_session($id);
        $session = null;
        if (!empty($sessions))
            $session = $sessions[0];
        return $session;
    }

    public function fetch_unexpired_session($ids, $ttl = 0) {
        $expire_sql = '';
        if (!empty($ttl) && $ttl > 0)
            $expire_sql = "and session_start >= " . (time() - $ttl);
        $key_sql = '';
        if (is_array($ids))
            $key_sql = 'and session_id in (' . join(",", $ids) . ')';
        else
            $key_sql = "and session_id = '$ids'";

        $where = "session_kind = 'CO'
                  $key_sql
                  $expire_sql";

        require_once('class.mt_session.php');
        $session = new Session;
        $sessions = $session->Find($where);
        return $sessions;
    }

    public function update_session($id, $val) {
        $session = $this->fetch_session($id);
        $now = time();
        if (empty($session)) {
            $session = new Session;
            $session->session_id = $id;
            $session->session_kind = 'CO';
        }
        $session->data( $val );
        $session->session_start = $now;
        $session->save();
        return true;
    }

    public function remove_session($id) {
        $session = $this->fetch_session($id);
        if (!empty($session))
            $session->Delete();

        return true;
    }

    public function flush_session() {
        $sql = "
            delete from mt_session
            where session_kind = 'CO'";
        $this->db()->Execute($sql);
        return true;
    }

    public function get_latest_touch($blog_id, $types) {
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
                    $type_filter = "and touch_object_type ='$types'";
                }
            }
        }

        $where = "1 = 1
                  $blog_filter
                  $type_filter
                  order by
                    touch_modified_on desc";
        $extras['limit'] = 1;

        require_once('class.mt_touch.php');
        $touch = new Touch;
        $touches = $touch->Find($where, false, false, $extras);

        if (!empty($touches))
            return $touches[0];

        return false;
    }

    public function fetch_template_meta($type, $name, $blog_id, $global) {
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

        $where = "$col = '$tmpl_name'
                  $blog_filter
                  $type_filter
                  order by
                      template_blog_id desc";

        require_once('class.mt_template.php');
        $tmpl = new Template();
        $tmpls = $tmpl->Find($where);
        if (empty($tmpls))
            $tmpl = null;
        else
            $tmpl = $tmpls[0];

        return $tmpl;
    }
}
?>
