<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

/***
 * Base class for mt object
 */
require_once('adodb.inc.php');
if (!defined('ADODB_ASSOC_CASE')) define('ADODB_ASSOC_CASE', ADODB_ASSOC_CASE_LOWER);

require_once('adodb-active-record.inc.php');
require_once('adodb-exceptions.inc.php');

abstract class BaseObject extends ADOdb_Active_Record
{
    // Member variables
    protected static $_cache_driver = null;
    private static $_meta_info = array(
        'author' => array(
            'widgets' => 'vblob',
            'favorite_blogs' => 'vblob',
            'favorite_websites' => 'vblob',
            'favorite_sites' => 'vblob',
            'password_reset' => 'vchar',
            'password_reset_expires' => 'vchar',
            'password_reset_return_to' => 'vchar',
            'list_prefs' => 'vblob',
            'lockout_recover_salt' => 'vchar'
            ),
        'asset' => array(
            'image_width' => 'vinteger',
            'image_height' => 'vinteger',
            ),
        'entry' => array(
            'junk_log' => 'vstring',
            'revision' => 'vinteger'
            ),
        'template' => array(
            'last_rebuild_time' => 'vinteger',
            'page_layout' => 'vchar',
            'include_with_ssi' => 'vinteger',
            'cache_expire_type' => 'vinteger',
            'cache_expire_interval' => 'vinteger',
            'cache_expire_event' => 'vchar',
            'cache_path' => 'vchar',
            'modulesets' => 'vchar',
            'revision' => 'vinteger'
            ),
        'blog' => array(
            'image_default_wrap_text' => 'vinteger',
            'image_default_align' => 'vchar',
            'image_default_thumb' => 'vinteger',
            'image_default_width' => 'vinteger',
            'image_default_wunits' => 'vchar',
            'image_default_constrain' => 'vinteger',
            'image_default_popup' => 'vinteger',
            'commenter_authenticators' => 'vchar',
            'require_typekey_emails' => 'vinteger',
            'nofollow_urls' => 'vinteger',
            'follow_auth_links' => 'vinteger',
            'update_pings' => 'vchar',
            'captcha_provider' => 'vchar',
            'publish_queue' => 'vinteger',
            'nwc_smart_replace' => 'vinteger',
            'nwc_replace_field' => 'vchar',
            'template_set' => 'vchar',
            'page_layout' => 'vchar',
            'include_system' => 'vchar',
            'include_cache' => 'vinteger',
            'max_revisions_entry' => 'vinteger',
            'max_revisions_cd' => 'vinteger',
            'max_revisions_template' => 'vinteger',
            'theme_export_settings' => 'vblob',
            'category_order' => 'vchar',
            'folder_order' => 'vchar',
            'publish_empty_archive' => 'vinteger',
            'upload_destination' => 'vinteger',
            'extra_path' => 'vchar',
            'operation_if_exists' => 'vinteger',
            'normalize_orientation' => 'vinteger',
            'auto_rename_non_ascii' => 'vinteger',
            'blog_content_accessible' => 'vinteger',
            'default_mt_sites_action' => 'vinteger',
            'default_mt_sites_sites' => 'vchar'
            ),
        'category' => array(
            'show_fields' => 'vchar',
            ),
        'cd' => array(
            'revision' => 'vinteger',
            'convert_breaks' => 'vchar',
            'blob_convert_breaks' => 'vblob',
            'block_editor_data' => 'vchar'
            ),
        );
    private $_meta_fields = array(
        'vchar',
        'vchar_idx',
        'vdatetime',
        'vdatetime_idx',
        'vinteger',
        'vinteger_idx',
        'vfloat',
        'vfloat_idx',
        'vblob',
        'vclob'
        );
    protected $_has_meta = false;

    // Override functions
    public function __get( $name ) {
        if (is_null($this->_prefix))
            return;

        $pattern = '/^' . $this->_prefix . "/i";
        if (!preg_match($pattern, $name))
            $name = $this->_prefix . $name;

        return property_exists($this, $name) ? $this->$name : null;
    }

    public function __set($name, $value) {
        if (is_null($this->_prefix))
            return;

        $pattern = '/^' . $this->_prefix . "/i";
        if (!preg_match($pattern, $name))
            $name = $this->_prefix . $name;

        parent::__set($name, $value);
    }

    public function __isset( $name ){
        if (is_null($this->_prefix))
            return false;

        $pattern = '/^' . $this->_prefix . "/i";
        if (!preg_match($pattern, $name))
            $name = $this->_prefix . $name;

        $value = property_exists($this, $name) ? $this->$name : null;
        return isset( $value );
    }

    public function Load( $where = null, $bindarr = false, $lock = false ) {
       if ( is_numeric( $where ) )
            $where = $this->_prefix . "id = " . $where;

        $ret = parent::Load($where, $bindarr, $lock);
        if ($ret && $this->has_meta())
            $this->load_meta($this);

        return $ret;
    }

	public function Find($whereOrderBy, $bindarr = false, $pkeysArr = false, $extra = array()) {
        $db = $this->DB();
        if (!$db || empty($this->_table))
            return false;

        $join = '';
        if (isset($extra['join'])) {
            $joins = $extra['join'];
            $keys = array_keys($joins);
            foreach($keys as $key) {
                $table = $key;
                $cond = $joins[$key]['condition'];
                $type = '';
                if (isset($joins[$key]['type']))
                    $type = $joins[$key]['type'];
                $join .= ' ' . strtolower($type) . ' JOIN ' . $table . ' ON ' . $cond;
            }
        }

        $unique_myself = false;
        if (isset($extra['distinct'])) {
            $mt = MT::get_instance();
            $mtdb = $mt->db();
            if ( !$mtdb->has_distinct_support() ) {
                $unique_myself = true;
                $extra['distinct'] = null;
            }
        }

        $objs = $db->GetActiveRecordsClass(get_class($this),
                                          $this->_table . $join,
                                          $whereOrderBy,
                                          $bindarr,
                                          $pkeysArr,
                                          $extra);
        $ret_objs = array();
        $unique_arr = array();
        if ($objs) {
            if ( !empty($unique_myself) ) {
                $pkeys = empty($pkeysArr)
                    ? $db->MetaPrimaryKeys( $this->_table )
                    : $pKeysArr;
            }
            $count = count($objs);
            for($i = 0; $i < $count; $i++) {
                if ( $unique_myself ) {
                    $key = "";
                    foreach ( $pkeys as $p ) {
                        $p = strtolower($p);
                        $key .= $objs[$i]->$p.":";
                    }
                    if (array_key_exists($key, $unique_arr))
                        continue;
                    else
                        $unique_arr[$key] = 1;
                }
                if ($this->has_meta()) {
                    $objs[$i] = $this->load_meta($objs[$i]);
                }
                $ret_objs[] = $objs[$i];
            }
        }

        // XXX:
        // We want to return an empty list if it is empty, but return null
        // for backwards compatibility.
        return $ret_objs ? $ret_objs : null;
    }

    // Member functions
    public static function install_meta($class, $name, $type) {
        if (empty($name) or empty($type) or empty($class))
            return;

        self::$_meta_info[$class][$name] = $type;
        return true;
    }

    public static function get_meta_info($class = null) {
        if (empty($class))
            return self::$_meta_info;

        return self::$_meta_info[$class];
    }

    public function has_meta() {
        return $this->_has_meta;
    }

    public function object_type() {
        if (property_exists($this, $this->_prefix . 'class')) {
            return $this->{$this->_prefix . 'class'};
        }
        else {
            return trim($this->_prefix, '_');
        }
    }

    public function has_column($col_name) {
        if ( empty($col_name)) return false;

        // Retrieve from MetaInfo
        $col = $col_name;
        if ( preg_match('/^field[:\.](.+)$/', $col, $match) ) {
            $col = $match[1];
        }
        $cls = strtolower(get_class($this));
        $meta_info = BaseObject::get_meta_info($cls);
        if ( !empty($meta_info) ) {
            if ( array_key_exists($col, $meta_info) )
                return true;
        }

        // Retrieve from column
        $pattern = '/^' . $this->_prefix . "/i";
        if (!preg_match($pattern, $col))
            $col = $this->_prefix . $col;

        $flds = $this->GetAttributeNames();
        return in_array( strtolower($col), $flds );
    }

    public function load_meta($obj) {
        if (!$obj->id)
            return null;

        // Load meta info
        $meta_table = $obj->_table . '_meta';
        $meta_info = $obj->LoadRelations($meta_table);
        if (!isset($meta_info) || count($meta_info) === 0)
            return $obj;

        $obj_type = $obj->object_type();

        require_once('MTSerialize.php');
        $serializer = MTSerialize::get_instance();

        // Parse meta info
        foreach ($meta_info as $meta) {
            $col_name = $obj->_prefix . 'meta_type';
            $meta_name = $meta->$col_name;
            $value = null;
            $is_blob = false;
            foreach ($obj->_meta_fields as $f) {
                $col_name = $obj->_prefix . 'meta_' . $f;
                $value = $meta->$col_name;
                if (!is_null($value)) {
                    if ($f == "vblob") {
                        if (preg_match("/^BIN:SERG/", $value)) {
                            $value = preg_replace("/^BIN:/", "", $value);
                            $value = $serializer->unserialize($value);
                        } elseif (preg_match("/^ASC:/", $value)) {
                            $value = preg_replace("/^ASC:/", "", $value);
                        }
                    }
                    break;
                }
            }

            if (empty(self::$_meta_info[$obj_type][$meta_name])) {
                self::$_meta_info[$obj_type][$meta_name] = $col_name;
            }

            $obj->$meta_name = $value;
            $obj->_original[] = $value;
        }

        return $obj;
    }

    public static function bulk_load_meta(&$objs) {
        if (empty($objs)) {
            return;
        }

        $obj = $objs[0];

        $extras = array();
        $table = $obj->TableInfo();
        $meta_table = $obj->_table . '_meta';

        if(empty($table->_hasMany[$meta_table])) {
            return;
        }

        $child_class = $table->_hasMany[$meta_table];
        $foreign_key = $child_class->foreignKey;
        $key         = reset($table->keys);
        $hash        = array();

        foreach ($objs as &$obj) {
            $id = @$obj->$key;
            if (!is_numeric($id)) {
                $db = $obj->DB();
                $id = $db->qstr($id);
            }
            $obj_hash[$id] =& $obj;
        }


        $mt = MT::get_instance();
        $limit  = $mt->config('BulkLoadMetaObjectsLimit');
        $length = sizeof($obj_hash);

        for ( $from = 0; $from < $length; $from += $limit ) {
            $children = $child_class->Find($foreign_key.' IN ('.join(',', array_slice(array_keys($obj_hash), $from, $limit)). ')',false,false);
            $meta_hash = array();
            if ($children) {
                foreach ($children as &$child) {
                    $k = $child->$foreign_key;
                    if (empty($meta_hash[$k])) {
                        $meta_hash[$k] = array();
                    }
                    $meta_hash[$k][] = $child;
                }
            }

            foreach ($meta_hash as $k => &$v) {
                $obj_hash[$k]->$meta_table = $v;
            }

            unset($meta_hash);
        }
        unset($obj_hash);


        $obj_type = null;
        foreach ($objs as &$obj) {
            if (! $obj_type) {
                $obj_type = $obj->object_type();
            }

            $meta_info = $obj->$meta_table;
            if (! $meta_info) {
                continue;
            }
            foreach ($meta_info as &$meta) {
                $col_name = $obj->_prefix . 'meta_type';
                $meta_name = $meta->$col_name;
                $value = null;
                $is_blob = false;
                foreach ($obj->_meta_fields as $f) {
                    $col_name = $obj->_prefix . 'meta_' . $f;
                    $value = $meta->$col_name;
                    if (!is_null($value)) {
                        if ($f == "vblob") {
                            if (preg_match("/^BIN:SERG/", $value)) {
                                $mt = MT::get_instance();
                                $value = preg_replace("/^BIN:/", "", $value);
                                $value = $mt->db()->unserialize($value);
                            } elseif (preg_match("/^ASC:/", $value)) {
                                $value = preg_replace("/^ASC:/", "", $value);
                            }
                        }
                        break;
                    }
                }

                if (! self::$_meta_info[$obj_type][$meta_name]) {
                    self::$_meta_info[$obj_type][$meta_name] = $col_name;
                }

                $obj->$meta_name = $value;
                $obj->_original or $obj->_original = [];
                $obj->_original[] = $value;
            }
        }
    }

    public function count($args = null) {
        $join = '';
        if (isset($args['join'])) {
            $joins = $args['join'];
            $keys = array_keys($joins);
            foreach($keys as $key) {
                $table = $key;
                $cond = $joins[$key]['condition'];
                $type = '';
                if (isset($jo[$key]['type']))
                    $type = $jo[$key]['type'];
                $join .= ' ' . strtolower($type) . ' JOIN ' . $table . ' ON ' . $cond;
            }
        }

        $where = '';
        if (isset($args['where']))
            $where = $args['where'];

        $sql = "select count(*) " .
            "from " . $this->_table . $join;
        if (!empty($where))
            $sql = $sql . " where $where";

        $db = $this->db();
        $saved = $db->SetFetchMode(ADODB_FETCH_NUM);
        $result = $db->Execute($sql);
        $cnt = $result->fields[0];
        $db->SetFetchMode($saved);
        return $cnt;
    }

    public function set_values($args) {
        $keys = array_keys($args);
        foreach($keys as $key) {
            $this->$key = $args[$key];
        }
    }

    public function GetArray() {
        $columns = $this->GetAttributeNames();
        $row = array();
        foreach($columns as $col)
            $row[$col] = $this->$col;
        return $row;
    }

    // Related table loader
    public function blog () {
        $col_name = $this->_prefix . "blog_id";
        $blog = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $blog_id = $this->$col_name;
            $blog = $this->load_cache($this->_prefix . ":" . $this->id . ":blog:" . $blog_id);
            if (empty($blog)) {
                require_once('class.mt_blog.php');
                $blog = new Blog;
                $blog->Load("blog_id = $blog_id");
            }
        }

        if ($blog->class == 'website') {
            require_once('class.mt_website.php');
            $blog = new Website;
            $blog->Load("blog_id = $blog_id");
        }
        if (!empty($blog))
            $this->cache($this->_prefix . ":" . $this->id . ":blog:" . $blog->id, $blog);

        return $blog;
    }

    public function author () {
        $col_name = $this->_prefix . "author_id";
        $author = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $author_id = $this->$col_name;

            $author = $this->load_cache($this->_prefix . ":" . $this->id . ":author:" . $author_id);
            if (empty($author)) {
                require_once('class.mt_author.php');
                $author = new Author;
                $author->Load("author_id = $author_id");
                $this->cache($this->_prefix . ":" . $this->id . ":author:" . $author->id, $author);
            }
        }

        return $author;
    }

    public function modified_author () {
        $col_name = $this->_prefix . "modified_by";
        $author = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name)) {
            $author_id = $this->$col_name;

            $author = $this->load_cache($this->_prefix . ":" . $this->id . ":author:" . $author_id);
            if (empty($author)) {
                require_once('class.mt_author.php');
                $author = new Author;
                $author->Load("author_id = $author_id");
                $this->cache($this->_prefix . ":" . $this->id . ":author:" . $author->id, $author);
            }
        }

        return $author;
    }

    public function entry () {
        $col_name = $this->_prefix . "entry_id";
        $entry = null;
        if (isset($this->$col_name) && is_numeric($this->$col_name) && $this->$col_name > 0) {
            $entry_id = $this->$col_name;

            $entry = $this->load_cache($this->_prefix . ":" . $this->id . ":entry:" . $entry_id);
            if (empty($entry)) {
                require_once('class.mt_entry.php');
                $entry = new Entry;
                $entry->Load("entry_id = $entry_id");
                $this->cache($this->_prefix . ":" . $this->id . ":entry:" . $entry->id, $entry);
            }
        }

        return $entry;
    }

    // Objcet cache
    protected function cache($key, $obj) {
        if (empty($key))
            return;

        $meta_table = $obj->_table . '_meta';
        $obj->$meta_table = array();

        $this->cache_driver()->set($key, $obj);
    }

    protected function load_cache($key) {
        if (empty($key))
            return null;
        $this->cache_driver()->get($key);
    }

    protected function cache_driver() {
        if (empty(self::$_cache_driver)) {
            require_once("class.basecache.php");
            try {
                self::$_cache_driver = CacheProviderFactory::get_provider('memcached');
            } catch (Exception $e) {
                # Memcached not supported.
                self::$_cache_driver = CacheProviderFactory::get_provider('memory');
            }
        }
        return self::$_cache_driver;
    }
}
?>
