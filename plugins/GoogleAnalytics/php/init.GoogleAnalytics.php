<?php
# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once('stats_lib.php');

class GoogleAnalyticsProvider extends StatsBaseProvider {
    public static $plugindata_cache = array();

    public static function _find_current_plugindata($blog) {
        $keys = array('configuration:blog:' . $blog->id);
        if ($blog->parent_id) {
            array_push($keys, 'configuration:blog:' . $blog->parent_id);
        }

        require_once('class.mt_plugindata.php');
        $class = new PluginData;
        $where =
            "plugindata_plugin = 'GoogleAnalytics' AND " .
            "plugindata_key IN ('" .  join("','", $keys) . "')";

        $objs = $class->Find($where);
        if (empty($objs)) {
            return null;
        }
        if (sizeof($objs) == 2 && $objs[0]->key != $keys[0]) {
            $objs = array_reverse($objs);
        }

        $mt = MT::get_instance();
        $db = $mt->db();
        foreach ($objs as $o) {
            $data = $o->data();
            if (   $data
                && $data['client_id']
                && $data['client_secret']
                && $data['profile_id'] )
            {
                return $o;
            }
        }
    }

    public static function current_plugindata($blog) {
        return array_key_exists($blog->id, GoogleAnalyticsProvider::$plugindata_cache)
            ? GoogleAnalyticsProvider::$plugindata_cache[$blog->id]
            : (GoogleAnalyticsProvider::$plugindata_cache[$blog->id]
                = GoogleAnalyticsProvider::_find_current_plugindata($blog));
    }

    public static function current_plugin_config($blog) {
        $plugindata = GoogleAnalyticsProvider::current_plugindata($blog);
        return $plugindata ? $plugindata->data() : null;
    }

    public static function is_ready($blog) {
        return GoogleAnalyticsProvider::current_plugindata($blog)
            ? true
            : false;
    }

    public function snippet($args, &$ctx) {
        $config = GoogleAnalyticsProvider::current_plugin_config($this->blog);
        if (empty($config)) {
            return '';
        }
        return <<<__HTML__
<script type="text/javascript">
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', '{$config['profile_web_property_id']}']);
  _gaq.push(['_trackPageview']);
  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
</script>
__HTML__;
    }
}

Stats::register_provider('GoogleAnalytics', 'GoogleAnalyticsProvider');
