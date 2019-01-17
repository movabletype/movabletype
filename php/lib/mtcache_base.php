<?php
# Movable Type (r) (C) 2001-2019 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

class MTCacheBase
{
    public $_ttl = 0;

    public function MTCacheBase($ttl = 0)
    {
        $this->ttl = $ttl;
    }

    public function get($key, $ttl = null)
    {
    }

    public function get_multi($keys, $ttl = null)
    {
    }

    public function delete($key)
    {
    }

    public function add($key, $val, $ttl = null)
    {
    }

    public function replace($key, $val, $ttl = null)
    {
    }

    public function set($key, $val, $ttl = null)
    {
    }

    public function flush_all()
    {
    }
}
