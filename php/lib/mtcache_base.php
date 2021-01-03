<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

class MTCacheBase {
    var $_ttl = 0;

    function __construct ($ttl = 0) {
        $this->ttl = $ttl;
    }

    function get ($key, $ttl = null) {
    }

    function get_multi ($keys, $ttl = null) {
    }

    function delete ($key) {
    }

    function add ($key, $val, $ttl = null) {
    }

    function replace ($key, $val, $ttl = null) {
    }

    function set ($key, $val, $ttl = null) {
    }

    function flush_all() {
    }
}
?>
