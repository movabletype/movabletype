<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
require_once('mtcache_base.php');

class MTCache_memcached extends MTCacheBase {

    var $_server;

    function __construct ($ttl = 0) {
        $this->_server = new Memcache;
        parent::__construct($ttl);
    }

    function connect ($servers) {
        if (is_array($servers)) {
            foreach ($servers as $server) {
                $this->_connect($server);
            }
        } else
            $this->_connect($servers);
    }

    function get ($key, $ttl = null) {
        return $this->_server->get($key);
    }

    function get_multi ($keys, $ttl = null) {
        return $this->_server->get($keys);
    }

    function delete ($key) {
        return $this->_server->delete($key);
    }

    function add ($key, $val, $ttl = null) {
        $expire = empty($ttl)
            ? $this->ttl
            : $ttl;
        return $this->_server->add($key, $val, false, $expire);
    }

    function replace ($key, $val, $ttl = null) {
        $expire = empty($ttl)
            ? $this->ttl
            : $ttl;
        return $this->_server->replace($key, $val, false, $expire);
    }

    function set ($key, $val, $ttl = null) {
        $expire = empty($ttl)
            ? $this->ttl
            : $ttl;
        return $this->_server->set($key, $val, false, $expire);
    }

    function flush_all() {
        return $this->_server->flush();
    }

    # param: $server = hostname:portno
    function _connect($server) {
        list ($host, $port) = explode(":", $server);
        if ($host == '')
            die("Cannot connect to memcached server.");
        if ($port == '')
            $port = 11211; # Assigns default port.
        else {
            if (!is_numeric($port))
                die("Cannot connect to memcached server.");
            else
                $port = intval($port);
        }

        # Connect to memcached server
        $this->_server->connect($host, $port)
            or die("Cannot connect to memcached server.");
    }
}
?>
