<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
require_once('class.basecache.php');

class CacheMemcached extends BaseCache {
    private static $_server = null;

    public function __construct($ttl = 0) {
        parent::__construct($ttl);

        if (empty(self::$_server)) {
            $mt = MT::get_instance();
            $servers  = $mt->config('MemcachedServers');
            if (!empty($servers)) {
                if (extension_loaded('memcache')) {
                    self::$_server = new Memcache;
                    $this->connect($servers);
                } else {
                    require_once('class.exception.php');
                    throw new MTException("Cannot load memcached extension.");
                }
            } else {
                require_once('class.exception.php');
                throw new MTException("Cannot load memcached extension.");
            }
        }
    }

    private function connect ($servers) {
        if (is_array($servers)) {
            foreach ($servers as $server) {
                $this->_connect($server);
            }
        } else
            $this->_connect($servers);
    }

    # param: $server = hostname:portno
    private function _connect($server) {
        list ($host, $port) = explode(":", $server);
        if ($host == '') {
            require_once('class.exception.php');
            throw new MTConfigException("Cannot connect to memcached server. (" . $server . ")");
        }
        if ($port == '')
            $port = 11211; # Assigns default port.
        else {
            if (!is_numeric($port)) {
                require_once('class.exception.php');
                throw new MTConfigException("Cannot connect to memcached server. (" . $server . ")");
            } else
                $port = intval($port);
        }

        # Connect to memcached server
        $ret = self::$_server->connect($host, $port);
        if (!$ret) {
            require_once('class.exception.php');
            throw new MTConfigException("Cannot connect to memcached server. (" . $server . ")");
        }
    }

    public function get ($key, $ttl = null) {
        return self::$_server->get($key);
    }

    public function get_multi ($keys, $ttl = null) {
        return self::$_server->get($keys);
    }

    public function delete ($key) {
        return self::$_server->delete($key);
    }

    public function add ($key, $val, $ttl = null) {
        $expire = $ttl ?? $this->_ttl ?? 0;
        return self::$_server->add($key, $val, false, $expire);
    }

    public function replace ($key, $val, $ttl = null) {
        $expire = $ttl ?? $this->_ttl ?? 0;
        return self::$_server->replace($key, $val, false, $expire);
    }

    public function set ($key, $val, $ttl = null) {
        $expire = $ttl ?? $this->_ttl ?? 0;
        return self::$_server->set($key, $val, false, $expire);
    }

    public function flush_all() {
        return self::$_server->flush();
    }
}
?>
