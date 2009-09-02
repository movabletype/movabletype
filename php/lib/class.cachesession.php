<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: class.cachesession.php 106007 2009-07-01 11:33:43Z ytakayama $
require_once('class.basecache.php');

class CacheSession extends BaseCache {
    public function get ($key, $ttl = null) {
        $ret = $this->get_multi($key, $ttl);
        return $ret[0];
    }

    public function get_multi ($keys, $ttl = null) {
        $mt = MT::get_instance();

        $results = $mt->db()->fetch_unexpired_session($keys, $ttl);
        if (empty($results))
            return '';
        else {
            $ret = array();
            foreach ($results as $result) {
                $ret[] = $result->data();
            }
            return $ret;
        }
    }

    public function delete ($key) {
        $mt = MT::get_instance();

        $mt->db()->remove_session($key);
        return true;
    }

    public function add ($key, $val, $ttl = null) {
        return $this->set($key, $val);
    }

    public function replace ($key, $val, $ttl = null) {
        return $this->set($key, $val);
    }

    public function set ($key, $val, $ttl = null) {
        $mt = MT::get_instance();

        return $mt->db()->update_session($key, $val);
    }

    public function flush_all() {
        $mt = MT::get_insrance();

        return $mt->db()->flush_session();
    }
}
