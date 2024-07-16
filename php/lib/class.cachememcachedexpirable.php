<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
require_once('class.cachememcached.php');

class CacheMemcachedExpirable extends CacheMemcached {

    public function _is_expired($val, $ttl = 0) {
        return !(is_array($val) && (!$ttl || $val['start'] >= time() - $ttl));
    }

    public function get($key, $ttl = 0) {
        $val = parent::get($key);
        if ($val) {
            if ($this->_is_expired($val, $ttl)) {
                $this->delete($key);
                return;
            } else {
                return $val['data'];
            }
        } else {
            return;
        }
    }

    public function set($key, $val, $ttl = null) {
        $val = ['start' => time(), 'data'  => $val];
        return parent::set($key, $val, $ttl);
    }
}
