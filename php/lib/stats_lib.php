<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

class Stats {
    public static $providers = array();

    public static function readied_provider($blog) {
        foreach (Stats::$providers as $id => $provider) {
            if (! class_exists($provider)) {
                require_once($provider . '.php');
            }

            if ($provider::is_ready($blog)) {
                return new $provider($blog);
            }
        }

        return null;
    }

    public static function register_provider($id, $provider) {
        Stats::$providers[$id] = $provider;
    }
}

class StatsBaseProvider {
    public $blog;

    public function __construct ($blog) {
        $this->blog = $blog;
    }
}
