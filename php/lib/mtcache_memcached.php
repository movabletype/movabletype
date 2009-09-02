_<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id: mtcache_memcached.php 106007 2009-07-01 11:33:43Z ytakayama $
require_once('mtcache_base.php');

class MTCache_memcached extends MTCacheBase {

    var $_server;

    function MTCache_memcached ($ttl = 0) {
        $this->_server = new Memcache;
        parent::MTCacheBase($ttl);
    }

    function connect ($servers) {
        if (is_array($servers)) {
            foreach ($servers as $server) {
                $this->_connect($server);
            }
        } else
            $this->_connect($server);
    }

    function get ($key, $ttl = null) {
        return $this->_server->get($key);
    }

    function get_multi ($keys, $ttl = null) {
        return $this->_server->get($key);
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
        list ($host, $port) = split(":", $server);
        if ($host == '')
            die("Can't connect to memcached server.");
        if ($port == '')
            $port = 11211; # Assigns default port.
        else {
            if (!is_numeric($port))
                die("Can't connect to memcached server.");
            else
                $port = intval($port);
        }

        # Connect to memcached server
        $this->_server->connect($host, $port)
            or die("Can't connect to memcached server.");
    }
}
?>
