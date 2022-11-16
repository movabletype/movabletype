<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
require_once('mtcache_base.php');

class MTCache_session extends MTCacheBase {
    function MTCacheBase ($ttl = 0) {
        parent::MTCacheBase($ttl);
    }

    function get ($key, $ttl = null) {
        $ret = $this->get_multi($key, $ttl);
        return $ret[0];
    }

    function get_multi ($keys, $ttl = null) {
        $mt = MT::get_instance();

        $results = $mt->db()->fetch_unexpired_session($keys, $ttl);
        if (empty($results))
            return '';
        else {
            $ret = array();
            foreach ($results as $result) {
                $ret[] = $result->session_data;
            }
            return $ret;
        }
    }

    function delete ($key) {
        $mt = MT::get_instance();

        $mt->db()->remove_session($key);
    }

    function add ($key, $val, $ttl = null) {
        return $this->set($key, $val);
    }

    function replace ($key, $val, $ttl = null) {
        return $this->set($key, $val);
    }

    function set ($key, $val, $ttl = null) {
        $mt = MT::get_instance();

        return $mt->db()->update_session($key, $val);
    }

    function flush_all() {
        $mt = MT::get_instance();

        return $mt->db()->flush_session();
    }
}
?>
