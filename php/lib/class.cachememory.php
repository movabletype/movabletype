<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
require_once('class.basecache.php');

class CacheMemory extends BaseCache {
    private static $_buffer = array();

    public function get ($key, $ttl = null) {
        $ret = $this->get_multi(array($key), $ttl);
        return $ret[0];
    }

    public function get_multi ($keys, $ttl = null) {
        $ret;
        foreach($keys as $key) {
            if (isset(self::$_buffer[$key]))
                $ret[] = self::$_buffer[$key];
        }

        if (empty($ret)) $ret = '';
        return $ret;
    }

    public function delete ($key) {
        if (isset(self::$_buffer[$key]))
            self::_delete($key);
        return true;
    }

    public function add ($key, $val, $ttl = null) {
        return $this->set($key, $val);
    }

    public function replace ($key, $val, $ttl = null) {
        return $this->set($key, $val);
    }

    public function set ($key, $val, $ttl = null) {
        self::_set($key, $val);
        return self::$_buffer[$key];
    }

    public function flush_all() {
        $keys = array_keys(self::$_buffer);
        foreach($keys as $key)
            self::$_buffer[$key] = null;
        return true;
    }

    private static function _set($key, $val) {
        CacheMemory::$_buffer[$key] = $val;
    }

    private static function _delete($key) {
        unset(CacheMemory::$_buffer[$key]);
    }
}
