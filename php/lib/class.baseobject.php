<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

/***
 * Base class for mt object
 */
require_once('adodb.inc.php');
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
            'password_reset' => 'vchar',
            'password_reset_expires' => 'vchar',
            'password_reset_return_to' => 'vchar'
            ),
        'asset' => array(
            'image_width' => 'vinteger',
            'image_height' => 'vinteger'
            ),
        'template' => array(
            'last_rebuild_time' => 'vinteger',
            'page_layout' => 'vchar',
            'include_with_ssi' => 'vinteger',
            'cache_expire_type' => 'vinteger',
            'cache_expire_interval' => 'vinteger',
            'cache_expire_event' => 'vchar',
            'cache_path' => 'vchar',
            'modulesets' => 'vchar'
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
            'include_cache' => 'vinteger'
            )
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

        return $this->$name;
    }

	public function __set($name, $value) {
        if (is_null($this->_prefix))
            return;

        $pattern = '/^' . $this->_prefix . "/i";
        if (!preg_match($pattern, $name))
            $name = $this->_prefix . $name;

        parent::__set($name, $value);
    }


    public function Load( $where = null, $bindarr = false ) {
        $ret = parent::Load($where, $bindarr);
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
                if (isset($jo[$key]['type']))
                    $type = $jo[$key]['type'];
                $join .= ' ' . strtolower($type) . ' JOIN ' . $table . ' ON ' . $cond;
            }
        }

        if (isset($extra['distinct'])) {
            $mt = MT::get_instance();
            $mtdb = $mt->db();
            if ( !$mtdb->has_distinct_support ) {
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
        $ret_objs;
        $unique_arr = array();
        if ($objs) {
            if ( $unique_myself ) {
                $pkeys = empty($pkeysArr)
                    ? $db->MetaPrimaryKeys( $this->_table )
                    : $pKeysArr;
            }
            $count = count($objs);
            for($i = 0; $i < $count; $i++) {
                if ( $unique_myself ) {
                    $key = "";
                    foreach ( $pkeys as $p ) {
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

        return $ret_objs;
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

    public function load_meta($obj) {
        if (!$obj->id)
            return null;

        // Load meta info
        $meta_table = $obj->_table . '_meta';
        $meta_info = $obj->LoadRelations($meta_table);
        if (!isset($meta_info) || count($meta_info) === 0)
            return $obj;

        // Parse meta info
        foreach ($meta_info as $meta) {
            $col_name = $obj->_prefix . 'meta_type';
            $meta_name = $meta->$col_name;
            $value = null;
            $is_blob = false;
            foreach ($obj->_meta_fields as $f) {
                $col_name = $obj->_prefix . 'meta_' . $f;
                $value = $meta->$col_name;
                if (!is_null($value))
                    break;
                if (preg_match("/^BIN:SERG/", $value)) {
                    $mt = MT::get_instance();
                    $value = preg_replace("/^BIN:/", "", $value);
                    $value = $mt->db()->unserialize($value);
                }
                
            }
            $obj->$meta_name = $value;
            $obj->_original[] = $value;
        }

        return $obj;
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
        $result = $db->Execute($sql);
        return $result->fields[0];
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
