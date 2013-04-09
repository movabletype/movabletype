<?php
# Movable Type (r) Open Source (C) 2004-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

/***
 * Loading exception classes
 */
require_once('lib/class.exception.php');

define('VERSION', '5.2');
define('PRODUCT_VERSION', '5.2.5');

$PRODUCT_NAME = '__PRODUCT_NAME__';
if($PRODUCT_NAME == '__PRODUCT' . '_NAME__')
    $PRODUCT_NAME = 'Movable Type';
define('PRODUCT_NAME', $PRODUCT_NAME);

$RELEASE_NUMBER = '__RELEASE_NUMBER__';
if ( $RELEASE_NUMBER == '__RELEASE_' . 'NUMBER__' )
    $RELEASE_NUMBER = 5;
define('RELEASE_NUMBER', $RELEASE_NUMBER);

$PRODUCT_VERSION_ID = '__PRODUCT_VERSION_ID__';
if ( $PRODUCT_VERSION_ID == '__PRODUCT_' . 'VERSION_ID__' )
    $PRODUCT_VERSION_ID = PRODUCT_VERSION;
$VERSION_STRING;
if ( $RELEASE_NUMBER > 0 )
    $VERSION_STRING = $PRODUCT_VERSION_ID . "." . $RELEASE_NUMBER;
else
    $VERSION_STRING = $PRODUCT_VERSION_ID;
define('VERSION_ID', $PRODUCT_VERSION_ID);

global $Lexicon;
$Lexicon = array();

class MT {
    protected $mime_types = array(
        '__default__' => 'text/html',
        'css' => 'text/css',
        'txt' => 'text/plain',
        'rdf' => 'text/xml',
        'rss' => 'text/xml',
        'xml' => 'text/xml',
    );
    protected $blog_id;
    protected $db;
    protected $config;
    protected $debugging = false;
    protected $caching = false;
    protected $conditional = false;
    protected $log = array();
    protected $warning = array();
    protected $id;
    protected $request;
    protected $http_error;
    protected $cfg_file;

    private  $cache_driver = null;
    private static $_instance = null;

    /***
     * Constructor for MT class.
     * Currently, constructor moved to private method because this class implemented Singleton Design Pattern.
     * You can get instance as following code.
     *
     * $mt = MT::get_instance();
     */
    private function __construct($blog_id = null, $cfg_file = null) {
        error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING);
        try {
            $this->id = md5(uniqid('MT',true));
            $this->init($blog_id, $cfg_file);
        } catch (Exception $e ) {
            throw new MTInitException( $e, $this->debugging );
        }
    }

    public static function get_instance($blog_id = null, $cfg_file = null) {
        if (is_null(MT::$_instance)) {
            MT::$_instance = new MT($blog_id, $cfg_file);
        }
        return MT::$_instance;
    }

    public function caching($val = null) {
        if ( !is_null($val) ) {
            $this->caching = $val;
        }

        return $this->caching;
    }

    public function conditional($val = null) {
        if ( !is_null($val) ) {
            $this->conditional = $val;
        }

        return $this->conditional;
    }

    public function blog_id() {
        return $this->blog_id;
    }

    function init($blog_id = null, $cfg_file = null) {
        if (isset($blog_id)) {
            $this->blog_id = $blog_id;
        }

        if (!file_exists($cfg_file)) {
            $mtdir = dirname(dirname(__FILE__));
            $cfg_file = $mtdir . DIRECTORY_SEPARATOR . "mt-config.cgi";
        }

        $this->configure($cfg_file);
        $this->init_addons();
        $this->configure_from_db();

        $lang = substr(strtolower($this->config('DefaultLanguage')), 0, 2);
        if (!@include_once("l10n_$lang.php"))
            include_once("l10n_en.php");

        if (extension_loaded('mbstring')) {
            $charset = $this->config('PublishCharset');
            mb_internal_encoding($charset);
            mb_http_output($charset);
        }
    }

    function init_addons() {
        $mtdir = dirname(dirname(__FILE__));
        $path = $mtdir . DIRECTORY_SEPARATOR . "addons";
        if (is_dir($path)) {
            $ctx =& $this->context();
            if ($dh = opendir($path)) {
                while (($file = readdir($dh)) !== false) {
                    if ($file == "." || $file == "..") {
                        continue;
                    }
                    $plugin_dir = $path . DIRECTORY_SEPARATOR . $file
                        . DIRECTORY_SEPARATOR . 'php';
                    if (is_dir($plugin_dir))
                        $ctx->add_plugin_dir($plugin_dir);
                }
                closedir($dh);
            }
        }
    }

    function init_plugins() {
        $plugin_paths = $this->config('PluginPath');
        $ctx =& $this->context();

        foreach ($plugin_paths as $path) {
            if ( !is_dir($path) )
                $path = $this->config('MTDir') . DIRECTORY_SEPARATOR . $path;

            if ($dh = @opendir($path)) {
                 while (($file = readdir($dh)) !== false) {
                     if ($file == "." || $file == "..")
                         continue;
                     $plugin_dir = $path . DIRECTORY_SEPARATOR . $file
                         . DIRECTORY_SEPARATOR . 'php';
                     if (is_dir($plugin_dir))
                         $ctx->add_plugin_dir($plugin_dir);
                 }
                 closedir($dh);
            }
        }

        $plugin_dir = $this->config('PHPDir') . DIRECTORY_SEPARATOR
            . 'plugins';
        if (is_dir($plugin_dir))
            $ctx->add_plugin_dir($plugin_dir);

        # Load any php directories found during the 'init_addons' loop
        foreach ($ctx->plugins_dir as $plugin_dir)
            if (is_dir($plugin_dir))
                $this->load_plugin($plugin_dir);
    }

    function load_plugin($plugin_dir) {
        $ctx =& $this->context();
        // global filters have to be handled differently from
        // tag attributes, so this causes them to be recognized
        // as they should...
        if ($dh = opendir($plugin_dir)) {
            while (($file = readdir($dh)) !== false) {
                if (preg_match('/^modifier\.(.+?)\.php$/', $file, $matches)) {
                    $ctx->add_global_filter($matches[1]);
                } elseif (preg_match('/^init\.(.+?)\.php$/', $file, $matches)) {
                    // load 'init' plugin file
                    require_once($file);
                }
            }
            closedir($dh);
        }
    }

    public function cfg_file() {
        return $this->cfg_file;
    }

    /***
     * Retreives a handle to the database and assigns it to
     * the member variable 'db'.
     */
    function &db() {
        if (!isset($this->db)) {
            require_once("mtdb.".$this->config('DBDriver').".php");
            $mtdbclass = 'MTDatabase'.$this->config('DBDriver');
            $this->db = new $mtdbclass($this->config('DBUser'),
                $this->config('DBPassword'),
                $this->config('Database'),
                $this->config('DBHost'),
                $this->config('DBPort'),
                $this->config('DBSocket'));
        }
        return $this->db;
    }

    /***
     * Retreives a handle to the cache driver.
     */
    public function cache_driver() {
        if (isset($this->cache_driver)) return $this->cache_driver;
    
        # Check for memcached enabled
        require_once("class.basecache.php");
        try {
            $this->cache_driver = CacheProviderFactory::get_provider('memcached');
        } catch (Exception $e) {
            # Memcached not supported.
            $this->cache_driver = CacheProviderFactory::get_provider('session');
        }
        return $this->cache_driver;
    }

    public function config($id, $value = null) {
        $id = strtolower($id);
        if (isset($value))
            $this->config[$id] = $value;
        return isset($this->config[$id]) ? $this->config[$id] : null;
    }

    /***
     * Loads configuration data from mt.cfg and mt-db-pass.cgi files.
     * Stores content in the 'config' member variable.
     */
    function configure($file = null) {
        if (isset($this->config)) return $config;

        $this->cfg_file = $file;

        $cfg = array();
        $type_array = array('pluginpath', 'alttemplate', 'outboundtrackbackdomains', 'memcachedservers', 'userpasswordvalidation');
        $type_hash  = array('commenterregistration');
        if ($fp = file($file)) {
            foreach ($fp as $line) {
                // search through the file
                if (!preg_match('/^\s*\#/i',$line)) {
                    // ignore lines starting with the hash symbol
                    if (preg_match('/^\s*(\S+)\s+(.*)$/', $line, $regs)) {
                        $key = strtolower(trim($regs[1]));
                        $value = trim($regs[2]);
                        if (in_array($key, $type_array)) {
                            $cfg[$key][] = $value;
                        }
                        elseif (in_array($key, $type_hash)) {
                            $hash = preg_split('/\=/', $value, 2);
                            $cfg[$key][strtolower(trim($hash[0]))] = trim($hash[1]);
                        } else {
                            $cfg[$key] = $value;
                        }
                    }
                }
            }
        } else {
            die("Unable to open configuration file $file");
        }

        // setup directory locations
        // location of mt.php
        $cfg['phpdir'] = realpath(dirname(__FILE__));
        // path to MT directory
        $cfg['mtdir'] = realpath(dirname($file));
        // path to handlers
        $cfg['phplibdir'] = $cfg['phpdir'] . DIRECTORY_SEPARATOR . 'lib';

        $driver = $cfg['objectdriver'];
        $driver = preg_replace('/^DB[ID]::/', '', $driver);
        $driver or $driver = 'mysql';
        $cfg['dbdriver'] = strtolower($driver);
        if ((strlen($cfg['database'])<1 || strlen($cfg['dbuser'])<1)) {
            if (($cfg['dbdriver'] != 'sqlite') && ($cfg['dbdriver'] != 'mssqlserver') && ($cfg['dbdriver'] != 'umssqlserver')) {
                die("Unable to read database or username");
            }
        }

        if ( !empty( $cfg['debugmode'] ) && intval($cfg['debugmode']) > 0 ) {
            $this->debugging = true;
        }

        $this->config =& $cfg;
        $this->config_defaults();

        // read in the database password
        if (!isset($cfg['dbpassword'])) {
            $db_pass_file = $cfg['mtdir'] . DIRECTORY_SEPARATOR . 'mt-db-pass.cgi';
            if (file_exists($db_pass_file)) {
                $password = implode('', file($db_pass_file));
                $password = trim($password, "\n\r\0");
                $cfg['dbpassword'] = $password;
            }
        }

        // set up include path
        // add MT-PHP 'plugins' and 'lib' directories to the front
        // of the existing PHP include path:
        if (strtoupper(substr(PHP_OS, 0,3) == 'WIN')) {
            $path_sep = ';';
        } else {
            $path_sep = ':';
        }
        ini_set('include_path',
            $cfg['phpdir'] . DIRECTORY_SEPARATOR . "lib" . $path_sep .
            $cfg['phpdir'] . DIRECTORY_SEPARATOR . "extlib" . $path_sep .
            $cfg['phpdir'] . DIRECTORY_SEPARATOR . "extlib" . DIRECTORY_SEPARATOR . "smarty" . DIRECTORY_SEPARATOR . "libs" . $path_sep .
            $cfg['phpdir'] . DIRECTORY_SEPARATOR . "extlib" . DIRECTORY_SEPARATOR . "adodb5" . $path_sep .
            $cfg['phpdir'] . DIRECTORY_SEPARATOR . "extlib" . DIRECTORY_SEPARATOR . "FirePHPCore" . $path_sep .
            ini_get('include_path')
        );

        // assign i18n defaults:
        $lang = strtolower($cfg['defaultlanguage']);
        if (! @include_once("i18n_$lang.php")) {
            include_once("i18n_en_us.php");
        }
        foreach ($GLOBALS['i18n_default_settings'] as $k => $v) {
            if (! isset($cfg[$k])) {
                $cfg[$k] = $v;
            }
        }
    }

    function configure_from_db() {
        $cfg =& $this->config;
        $mtdb =& $this->db();
        $db_config = $mtdb->fetch_config();
        if ($db_config) {
            $data = $db_config->data();
            foreach ($data as $key => $value) {
                $cfg[$key] = $value;
            }
            $mtdb->set_names($this);
        }

        if ( !empty( $cfg['debugmode'] ) && intval($cfg['debugmode']) > 0 ) {
            $this->debugging = true;
        }
    }

    function config_defaults() {
        $cfg =& $this->config;
        // assign defaults:
        isset($cfg['cgipath']) or
            $cfg['cgipath'] = '/cgi-bin/';
        if (substr($cfg['cgipath'], strlen($cfg['cgipath']) - 1, 1) != '/')
            $cfg['cgipath'] .= '/'; 
        isset($cfg['staticwebpath']) or
            $cfg['staticwebpath'] = $cfg['cgipath'] . 'mt-static/';
        isset($cfg['trackbackscript']) or
            $cfg['trackbackscript'] = 'mt-tb.cgi';
        isset($cfg['adminscript']) or
            $cfg['adminscript'] = 'mt.cgi';
        isset($cfg['commentscript']) or
            $cfg['commentscript'] = 'mt-comments.cgi';
        isset($cfg['atomscript']) or
            $cfg['atomscript'] = 'mt-atom.cgi';
        isset($cfg['xmlrpcscript']) or
            $cfg['xmlrpcscript'] = 'mt-xmlrpc.cgi';
        isset($cfg['searchscript']) or
            $cfg['searchscript'] = 'mt-search.cgi';
        isset($cfg['notifyscript']) or
            $cfg['notifyscript'] = 'mt-add-notify.cgi';
        isset($cfg['defaultlanguage']) or
            $cfg['defaultlanguage'] = 'en_US';
        isset($cfg['globalsanitizespec']) or
            $cfg['globalsanitizespec'] = 'a href,b,i,br/,p,strong,em,ul,ol,li,blockquote,pre';
        isset($cfg['signonurl']) or
            $cfg['signonurl'] = 'https://www.typekey.com/t/typekey/login?';
        isset($cfg['signoffurl']) or
            $cfg['signoffurl'] = 'https://www.typekey.com/t/typekey/logout?';
        isset($cfg['identityurl']) or
            $cfg['identityurl'] = 'http://profile.typekey.com/';
        isset($cfg['publishcommentericon']) or
            $cfg['publishcommentericon'] = '1';
        isset($cfg['allowcomments']) or
            $cfg['allowcomments'] = '1';
        isset($cfg['allowpings']) or
            $cfg['allowpings'] = '1';
        isset($cfg['indexbasename']) or
            $cfg['indexbasename'] = 'index';
        isset($cfg['typekeyversion']) or
            $cfg['typekeyversion'] = '1.1';
        isset($cfg['assetcachedir']) or
            $cfg['assetcachedir'] = 'assets_c';
        isset($cfg['userpicthumbnailsize']) or
            $cfg['userpicthumbnailsize'] = '100';
        isset($cfg['pluginpath']) or
            $cfg['pluginpath'] = array($this->config('MTDir') . DIRECTORY_SEPARATOR . 'plugins');
        isset($cfg['includesdir']) or
            $cfg['includesdir'] = 'includes_c';
        isset($cfg['searchmaxresults']) or
            $cfg['searchmaxresults'] = '20';
        isset($cfg['maxresults']) or
            $cfg['maxresults'] = $cfg['searchmaxresults'];
        isset($cfg['singlecommunity']) or
            $cfg['singlecommunity'] = '1';
        isset($cfg['usersessioncookiename']) or
            $cfg['usersessioncookiename'] = 'DEFAULT';
        isset($cfg['usersessioncookiedomain']) or
            $cfg['usersessioncookiedomain'] = '<$MTBlogHost exclude_port="1"$>';
        isset($cfg['usersessioncookiepath']) or
            $cfg['usersessioncookiepath'] = 'DEFAULT';
        isset($cfg['usersessioncookietimeout']) or
            $cfg['usersessioncookietimeout'] = 60*60*4;
        isset($cfg['commenterregistration']) or
            $cfg['commenterregistration'] = array('allow' => 1 );
        isset($cfg['userpasswordminlength']) or
            $cfg['userpasswordminlength'] = 8;
        isset($cfg['bulkloadmetaobjectslimit']) or
            $cfg['bulkloadmetaobjectslimit'] = 100;
    }

    function configure_paths($blog_site_path) {
        if (preg_match('/^\./', $blog_site_path)) {
            // relative address, so tack on the MT dir in front
            $blog_site_path = $this->config('MTDir') .
                DIRECTORY_SEPARATOR . $blog_site_path;
        }
        $this->config('PHPTemplateDir') or
            $this->config('PHPTemplateDir', $blog_site_path .
            DIRECTORY_SEPARATOR . 'templates');
        $this->config('PHPCacheDir') or
            $this->config('PHPCacheDir', $blog_site_path .
            DIRECTORY_SEPARATOR . 'cache');

        $ctx =& $this->context();
        $ctx->template_dir = $this->config('PHPTemplateDir');
        $ctx->compile_dir = $ctx->template_dir . '_c';
        $ctx->cache_dir = $this->config('PHPCacheDir');
    }

    /***
     * Mainline handler function.
     */
    function view($blog_id = null) {

        set_error_handler(array(&$this, 'error_handler'));

        require_once("MTUtil.php");

        $blog_id or $blog_id = $this->blog_id;

       try {
           $ctx =& $this->context();
           $this->init_plugins();
           $ctx->caching = $this->caching;

           // Some defaults...
            $mtdb =& $this->db();
            $ctx->mt->db =& $mtdb;
       } catch (Exception $e ) {
            if ( $this->debugging ) {
                $msg = "<b>Error:</b> ". $e->getMessage() ."<br>\n" .
                       "<pre>".$e->getTraceAsString()."</pre>";

                return trigger_error( $msg, E_USER_ERROR);
            }
            header( "503 Service Unavailable" );
            return false;
        }

        // User-specified request through request variable
        $path = $this->request;

        // Apache request
        if (!$path && $_SERVER['REQUEST_URI']) {
            $path = $_SERVER['REQUEST_URI'];
            // strip off any query string...
            $path = preg_replace('/\?.*/', '', $path);
            // strip any duplicated slashes...
            $path = preg_replace('!/+!', '/', $path);
        }

        // IIS request by error document...
        if (preg_match('/IIS/', $_SERVER['SERVER_SOFTWARE'])) {
            // assume 404 handler
            if (preg_match('/^\d+;(.*)$/', $_SERVER['QUERY_STRING'], $matches)) {
                $path = $matches[1];
                $path = preg_replace('!^http://[^/]+!', '', $path);
                if (preg_match('/\?(.+)?/', $path, $matches)) {
                    $_SERVER['QUERY_STRING'] = $matches[1];
                    $path = preg_replace('/\?.*$/', '', $path);
                }
            }
        }

        // now set the path so it may be queried
        $path = preg_replace('/\\\\/', '\\\\\\\\', $path );
        $this->request = $path;

        $pathinfo = pathinfo($path);
        $ctx->stash('_basename', $pathinfo['filename']);

        // When we are invoked as an ErrorDocument, the parameters are
        // in the environment variables REDIRECT_*
        if (isset($_SERVER['REDIRECT_QUERY_STRING'])) {
            // todo: populate $_GET and QUERY_STRING with REDIRECT_QUERY_STRING
            $_SERVER['QUERY_STRING'] = getenv('REDIRECT_QUERY_STRING');
        }

        if (preg_match('/\.(\w+)$/', $path, $matches)) {
            $req_ext = strtolower($matches[1]);
        }

        $this->blog_id = $blog_id;

        $data = $this->resolve_url($path);
        if (!$data) {
            // 404!
            $this->http_error = 404;
            header("HTTP/1.1 404 Not found");
            return $ctx->error($this->translate("Page not found - [_1]", $path), E_USER_ERROR);
        }

        $fi_path = $data->fileinfo_url;
        $fid = $data->fileinfo_id;
        $at = $data->fileinfo_archive_type;
        $ts = $data->fileinfo_startdate;
        $tpl_id = $data->fileinfo_template_id;
        $cat = $data->fileinfo_category_id;
        $auth = $data->fileinfo_author_id;
        $entry_id = $data->fileinfo_entry_id;
        $blog_id = $data->fileinfo_blog_id;
        $blog = $data->blog();
        if ($at == 'index') {
            $at = null;
            $ctx->stash('index_archive', true);
        } else {
            $ctx->stash('index_archive', false);
        }
        $tmpl = $data->template();
        $ctx->stash('template', $tmpl);

        $tts = $tmpl->template_modified_on;
        if ($tts) {
            $tts = offset_time(datetime_to_timestamp($tts), $blog);
        }
        $ctx->stash('template_timestamp', $tts);
        $ctx->stash('template_created_on', $tmpl->template_created_on);

        $page_layout = $blog->blog_page_layout;
        $columns = get_page_column($page_layout);
        $vars =& $ctx->__stash['vars'];
        $vars['page_columns'] = $columns;
        $vars['page_layout'] = $page_layout;

        if (isset($tmpl->template_identifier))
            $vars[$tmpl->template_identifier] = 1;

        $this->configure_paths($blog->site_path());

        // start populating our stash
        $ctx->stash('blog_id', $blog_id);
        $ctx->stash('local_blog_id', $blog_id);
        $ctx->stash('blog', $blog);
        $ctx->stash('build_template_id', $tpl_id);

        // conditional get support...
        if ($this->caching) {
            $this->cache_modified_check = true;
        }
        if ($this->conditional) {
            $last_ts = $blog->blog_children_modified_on;
            $last_modified = $ctx->_hdlr_date(array('ts' => $last_ts, 'format' => '%a, %d %b %Y %H:%M:%S GMT', 'language' => 'en', 'utc' => 1), $ctx);
            $this->doConditionalGet($last_modified);
        }

        $cache_id = $blog_id.';'.$fi_path;
        if (!$ctx->is_cached('mt:'.$tpl_id, $cache_id)) {
            if (isset($at) && ($at != 'Category')) {
                require_once("archive_lib.php");
                try {
                    $archiver = ArchiverFactory::get_archiver($at);
                } catch (Exception $e) {
                    // 404
                    $this->http_errr = 404;
                    header("HTTP/1.1 404 Not Found");
                    return $ctx->error($this->translate("Page not found - [_1]", $at), E_USER_ERROR);
                }
                $archiver->template_params($ctx);
            }

            if ($cat) {
                $archive_category = $mtdb->fetch_category($cat);
                $ctx->stash('category', $archive_category);
                $ctx->stash('archive_category', $archive_category);
            }
            if ($auth) {
                $archive_author = $mtdb->fetch_author($auth);
                $ctx->stash('author', $archive_author);
                $ctx->stash('archive_author', $archive_author);
            }
            if (isset($at)) {
                if (($at != 'Category') && isset($ts)) {
                    list($ts_start, $ts_end) = $archiver->get_range($ts);
                    $ctx->stash('current_timestamp', $ts_start);
                    $ctx->stash('current_timestamp_end', $ts_end);
                }
                $ctx->stash('current_archive_type', $at);
            }
    
            if (isset($entry_id) && ($entry_id) && ($at == 'Individual' || $at == 'Page')) {
                if ($at == 'Individual') {
                    $entry = $mtdb->fetch_entry($entry_id);
                } elseif($at == 'Page') {
                    $entry = $mtdb->fetch_page($entry_id);
                }
                $ctx->stash('entry', $entry);
                $ctx->stash('current_timestamp', $entry->entry_authored_on);
            }

            if ($at == 'Category') {
                $vars =& $ctx->__stash['vars'];
                $vars['archive_class']            = "category-archive";
                $vars['category_archive']         = 1;
                $vars['archive_template']         = 1;
                $vars['archive_listing']          = 1;
                $vars['module_category_archives'] = 1;
            }
        }

        $this->set_canonical_url($ctx, $blog, $data);

        $output = $ctx->fetch('mt:'.$tpl_id, $cache_id);

        $this->http_error = 200;
        header("HTTP/1.1 200 OK");
        // content-type header-- need to supplement with charset
        $content_type = $ctx->stash('content_type');

        if (!isset($content_type)) {
            $content_type = $this->mime_types['__default__'];
            if ($req_ext && (isset($this->mime_types[$req_ext]))) {
                $content_type = $this->mime_types[$req_ext];
            }
        }
        $charset = $this->config('PublishCharset');
        if (isset($charset)) {
            if (!preg_match('/charset=/', $content_type))
                $content_type .= '; charset=' . $charset;
        }
        header("Content-Type: $content_type");

        // finally, issue output
        $output = preg_replace('/^\s*/', '', $output);
        echo $output;

        // if warnings found, show it.
        if (!empty($this->warning)) {
            $this->_dump($this->warning);
        }

#        if ($this->debugging) {
#            $this->log("Queries: ".$mtdb->num_queries);
#            $this->log("Queries executed:");
#            $queries = $mtdb->savedqueries;
#            foreach ($queries as $q) {
#                $this->log($q);
#            }
#            $this->log_dump();
#        }
        restore_error_handler();
    }

    function set_canonical_url($ctx, $blog, $fileinfo) {
        if (preg_match('#(\A[^:]*://[^/]*)#', $blog->site_url(), $m)) {
            $url = $m[1] . $fileinfo->url;
        }
        else {
            $url = $fileinfo->url;
        }
        $ctx->stash('current_mapping_url', $url);

        $templatemap = $fileinfo->templatemap();
        if ($templatemap && ! $templatemap->is_preferred) {
            $url = $ctx->tag('archivelink', array());
            $ctx->stash('preferred_mapping_url', $url);
        }
    }

    function resolve_url($path, $build_type = 3) {
        $data = $this->db->resolve_url($path, $this->blog_id, $build_type);
        if ( isset($data)
            && isset($data->fileinfo_entry_id)
            && is_numeric($data->fileinfo_entry_id)
        ) {
            $tmpl_map = $data->templatemap();
            if (strtolower($tmpl_map->templatemap_archive_type) == 'page') {
                $entry = $this->db->fetch_page($data->fileinfo_entry_id);
            } else {
                $entry = $this->db->fetch_entry($data->fileinfo_entry_id);
            }
            if (!isset($entry) || $entry->entry_status != 2)
                return;
        }
        return $data;
    }

    function doConditionalGet($last_modified) {
        // Thanks to Simon Willison...
        //   http://simon.incutio.com/archive/2003/04/23/conditionalGet
        // A PHP implementation of conditional get, see 
        //   http://fishbowl.pastiche.org/archives/001132.html
        $etag = '"'.md5($last_modified).'"';
        // Send the headers
        header("Last-Modified: $last_modified");
        header("ETag: $etag");
        // See if the client has provided the required headers
        $if_modified_since = isset($_SERVER['HTTP_IF_MODIFIED_SINCE']) ?
            stripslashes($_SERVER['HTTP_IF_MODIFIED_SINCE']) :
            false;
        $if_none_match = isset($_SERVER['HTTP_IF_NONE_MATCH']) ?
            stripslashes($_SERVER['HTTP_IF_NONE_MATCH']) : 
            false;
        if (!$if_modified_since && !$if_none_match) {
            return;
        }
        // At least one of the headers is there - check them
        if ($if_none_match && $if_none_match != $etag) {
            return; // etag is there but doesn't match
        }
        if ($if_modified_since && $if_modified_since != $last_modified) {
            return; // if-modified-since is there but doesn't match
        }
        // Nothing has changed since their last request - serve a 304 and exit
        header('HTTP/1.1 304 Not Modified');
        exit;
    }

    function display($tpl, $cid = null) {
        $ctx =& $this->context();
        $this->init_plugins();
        $blog =& $ctx->stash('blog');
        if (!$blog) {
            $db =& $this->db();
            $ctx->mt->db =& $db;
            $blog = $db->fetch_blog($this->blog_id);
            $ctx->stash('blog', $blog);
            $ctx->stash('blog_id', $this->blog_id);
            $ctx->stash('local_blog_id', $this->blog_id);
            $this->configure_paths($blog->site_path());
        }
        return $ctx->display($tpl, $cid);
    }

    function fetch($tpl, $cid = null) {
        $ctx =& $this->context();
        $this->init_plugins();
        $blog =& $ctx->stash('blog');
        if (!$blog) {
            $db =& $this->db();
            $ctx->mt->db =& $db;
            $blog = $db->fetch_blog($this->blog_id);
            $ctx->stash('blog', $blog);
            $ctx->stash('blog_id', $this->blog_id);
            $ctx->stash('local_blog_id', $this->blog_id);
            $this->configure_paths($blog->site_path());
        }
        return $ctx->fetch($tpl, $cid);
    }

    function _dump($dump) {
        if ($_SERVER['REMOTE_ADDR']) {
            // web view...
            echo "<div class=\"debug\" style=\"border:1px solid red; margin:0.5em; padding: 0 1em; text-align:left; background-color:#ddd; color:#000\"><pre>";
            echo implode("\n", $dump);
            echo "</pre></div>\n\n";
        } else {
            // console view...
            $stderr = fopen('php://stderr', 'w'); 
            fwrite($stderr,implode("\n", $dump)); 
            echo (implode("\n", $dump)); 
            fclose($stderr);
        }
    }

    function log_dump() {
        $this->_dump($this->log);
    }

    function error_handler($errno, $errstr, $errfile, $errline) {
        if ($errno & (E_ALL ^ E_NOTICE)) {
            if ( !empty( $this->db ) ) {
                if (version_compare(phpversion(), '4.3.0', '>=')) {
                    $charset = $this->config('PublishCharset');
                    $errstr = htmlentities($errstr, ENT_COMPAT, $charset);
                    $errfile = htmlentities($errfile, ENT_COMPAT, $charset);
                } else {
                    $errstr = htmlentities($errstr, ENT_COMPAT);
                    $errfile = htmlentities($errfile, ENT_COMPAT);
                }
                $mtphpdir = $this->config('PHPDir');
                $ctx =& $this->context();
                $ctx->stash('blog_id', $this->blog_id);
                $ctx->stash('local_blog_id', $this->blog_id);
                $ctx->stash('blog', $this->db->fetch_blog($this->blog_id));
                if ( $this->debugging ) {
                    $ctx->stash('error_message', $errstr."<!-- file: $errfile; line: $errline; code: $errno -->");
                    $ctx->stash('error_code', $errno);
                } else {
                    if ( 404 == $this->http_error) {
                        $ctx->stash('error_message', $errstr);
                    } else {
                        $ctx->stash('error_message', 'An error occurs.');
                    }
                }

                $http_error = $this->http_error;
                if (!$http_error) {
                    $http_error = 500;
                }
                $ctx->stash('http_error', $http_error);
                $ctx->stash('error_file', $errfile);
                $ctx->stash('error_line', $errline);
                $ctx->template_dir = $mtphpdir . DIRECTORY_SEPARATOR . 'tmpl';
                $ctx->caching = 0;
                $ctx->stash('StaticWebPath', $this->config('StaticWebPath'));
                $ctx->stash('PublishCharset', $this->config('PublishCharset'));
                $charset = $this->config('PublishCharset');
                $out = $ctx->tag('Include', array('type' => 'dynamic_error', 'dynamic_error' => 1, 'system_template' => 1));
                if (isset($out)) {
                    header("Content-type: text/html; charset=".$charset);
                    echo $out;
                } else {
                    header("HTTP/1.1 500 Server Error");
                    header("Content-type: text/plain");
                    echo "Error executing error template.";
                }
                exit;
            } else {
                header( "HTTP/1.1 503 Service Unavailable" );
                header("Content-type: text/plain");
                echo "503 Service Unavailable\n\n";

                if ( $this->debugging ) {
                    echo "Errno: $errno\n";
                    echo "Error: $errstr\n";
                    echo "File: $errfile  Line: $errline\n";
                }

                exit;
            }
        }
    }

    /***
     * Retrieves a context and rendering object.
     */
    public function &context() {
        static $ctx;
        if (isset($ctx)) return $ctx;

        require_once('MTViewer.php');
        $ctx = new MTViewer($this);
        $ctx->mt =& $this;
        $mtphpdir = $this->config('PHPDir');
        $mtlibdir = $this->config('PHPLibDir');
        $ctx->compile_check = 1;
        $ctx->caching = false;
        $ctx->plugins_dir[] = $mtlibdir;
        $ctx->plugins_dir[] = $mtphpdir . DIRECTORY_SEPARATOR . "plugins";
        if ($this->debugging) {
            $ctx->debugging_ctrl = 'URL';
            $ctx->debug_tpl = $mtphpdir . DIRECTORY_SEPARATOR .
                'extlib' . DIRECTORY_SEPARATOR .
                'smarty' . DIRECTORY_SEPARATOR . "libs" . DIRECTORY_SEPARATOR .
                'debug.tpl';
        }
        #if (isset($this->config('SafeMode')) && ($this->config('SafeMode'))) {
        #    // disable PHP support
        #    $ctx->php_handling = SMARTY_PHP_REMOVE;
        #}
        return $ctx;
    }

    function log($msg = null) {
        $this->log[] = $msg;
    }

    function translate($str, $params = null) {
        if ( ( $params !== null ) && ( !is_array($params) ) )
            $params = array( $params );
        return translate_phrase($str, $params);
    }

    function translate_templatized_item($str) {
        return translate_phrase($str[1]);
    }

    function translate_templatized($tmpl) {
        $cb = array($this, 'translate_templatized_item');
        $out = preg_replace_callback('/<(?:_|mt)_trans phrase="(.+?)".*?>/i', $cb, $tmpl);
        return $out;
    }

    function warning_log($str) {
        $this->warning[] = $str;
    }

    function get_current_blog_id() {
        return $this->blog_id;
    }
}

function is_valid_email($addr) {
    if (preg_match('/[ |\t|\r|\n]*\"?([^\"]+\"?@[^ <>\t]+\.[^ <>\t][^ <>\t]+)[ |\t|\r|\n]*/', $addr, $matches)) {
        return $matches[1];
    } else {
        return 0;
    }
}

$spam_protect_map = array(':' => '&#58;', '@' => '&#64;', '.' => '&#46;');
function spam_protect($str) {
    global $spam_protect_map;
    return strtr($str, $spam_protect_map);
}

function offset_time($ts, $blog = null, $dir = null) {
    if (isset($blog)) {
        if (!is_array($blog)) {
            global $mt;
            $blog = $mt->db()->fetch_blog($blog->id);
        }
        $offset = $blog->blog_server_offset;
    } else {
        global $mt;
        $offset = $mt->config('TimeOffset');
    }
    intval($offset) or $offset = 0;
    $tsa = localtime($ts);

    if ($tsa[8]) {  // daylight savings offset
        $offset++;
    }
    if ($dir == '-') {
        $offset *= -1;
    }
    $ts += $offset * 3600;
    return $ts;
}

function translate_phrase_param($str, $params = null) {
    if (is_array($params)) {
        if (strpos($str, '[_') !== false) {
            for ($i = 1; $i <= count($params); $i++) {
                $str = preg_replace("/\\[_$i\\]/", $params[$i-1], $str);
            }
        }
        $start = 0;
        while (preg_match("/\\[quant,_(\d+),([^\\],]*)(?:,([^\\],]*))?(?:,([^\\],]*))?\\]/", $str, $matches, PREG_OFFSET_CAPTURE, $start)) {
            $id = $matches[1][0];
            $num = $params[$id-1];
            if ( ($num === 0) && (count($matches) > 4) ) { 
                $part = $matches[4][0];
            } 
            elseif ( $num === 1 ) {
                $part = $num . ' ' . $matches[2][0];
            }
            else {
                $part = $num . ' ' . ( count($matches) > 3 ? $matches[3][0] : ( $matches[2][0] . 's' ) );
            }
            $str = substr_replace($str, $part, $matches[0][1], strlen($matches[0][0]));
            $start = $matches[0][1] + strlen($part);
        }
    }
    return $str;
}
?>
