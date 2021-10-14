<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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
        array_push($keys, 'configuration');

        require_once('class.mt_plugindata.php');
        $class = new PluginData;
        $where =
            "plugindata_plugin = 'GoogleAnalytics' AND " .
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

        if(!empty($args['gtag'])){
            return <<<__HTML__
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id={$config['profile_web_property_id']}"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', '{$config['profile_web_property_id']}');
</script>
__HTML__;
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
