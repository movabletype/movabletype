<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('stats_lib.php');

class GoogleAnalyticsV4Provider extends StatsBaseProvider {
    public static $plugindata_cache = array();

    public static function _find_current_plugindata($blog) {
        $keys = array('configuration:blog:' . $blog->id);
        if ($blog->parent_id) {
            array_push($keys, 'configuration:blog:' . $blog->parent_id);
        }
        array_push($keys, 'configuration');

        require_once('class.mt_plugindata.php');
        $class = new PluginData;
        $where =
            "plugindata_plugin = 'GoogleAnalyticsV4' AND " .
            "plugindata_key IN ('" .  join("','", $keys) . "')";

        $tmp_objs = $class->Find($where);
        if (empty($tmp_objs)) {
            return null;
        }
        $objs = array();
        foreach ($keys as $k) {
            foreach ($tmp_objs as $o) {
                if ($o->key == $k) {
                    array_push($objs, $o);
                }
            }
        }

        $mt = MT::get_instance();
        $db = $mt->db();
        for ($i = 0; $i < sizeof($objs); $i++) {
            $o    = $objs[$i];
            $data = $o->data();
            if ($data && $data['profile_id']) {
                if ($data['client_id'] && $data['client_secret']) {
                    return $o;
                }
                else if ($data['parent_client_id']) {
                    for ($j = 0; $j < sizeof($objs); $j++) {
                        $parent_data = $objs[$j]->data();
                        if ($parent_data &&
                            $parent_data['client_id'] &&
                            $parent_data['client_id'] == $data['parent_client_id'] &&
                            $parent_data['client_secret']) {
                            return $o;
                        }
                    }
                }
            }
        }
    }

    public static function current_plugindata($blog) {
        return array_key_exists($blog->id, GoogleAnalyticsV4Provider::$plugindata_cache)
            ? GoogleAnalyticsV4Provider::$plugindata_cache[$blog->id]
            : (GoogleAnalyticsV4Provider::$plugindata_cache[$blog->id]
                = GoogleAnalyticsV4Provider::_find_current_plugindata($blog));
    }

    public static function current_plugin_config($blog) {
        $plugindata = GoogleAnalyticsV4Provider::current_plugindata($blog);
        return $plugindata ? $plugindata->data() : null;
    }

    public static function is_ready($blog) {
        return GoogleAnalyticsV4Provider::current_plugindata($blog)
            ? true
            : false;
    }

    public function snippet($args, &$ctx) {
        $config = GoogleAnalyticsV4Provider::current_plugin_config($this->blog);
        if (empty($config)) {
            return '';
        }

        return <<<__HTML__
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id={$config['measurement_id']}"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', '{$config['measurement_id']}');
</script>
__HTML__;
    }
}

Stats::register_provider('GoogleAnalyticsV4', 'GoogleAnalyticsV4Provider');
