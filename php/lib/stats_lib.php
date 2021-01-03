<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

class Stats {
    public static $providers = array();

    public static function readied_provider($blog) {
        foreach (Stats::$providers as $id => $provider) {
            if (! class_exists($provider)) {
                require_once($provider . '.php');
            }

            $instance = new $provider($id, $blog);
            if ($instance->is_ready($blog)) {
                return $instance;
            }
        }

        return null;
    }

    public static function register_provider($id, $provider) {
        Stats::$providers[$id] = $provider;
    }
}

class StatsBaseProvider {
    public $id;
    public $blog;

    public function __construct ($id, $blog) {
        $this->id   = $id;
        $this->blog = $blog;
    }
}
?>
