<?php

class BaseObjectTest extends PHPUnit_Framework_TestCase {
    private static $_cache_driver;
  public function testIssetWithOverloading() {

    include_once("php/mt.php");
    include_once("php/lib/MTUtil.php");

    $cfg_file =  realpath( "t/mysql-test.cfg" );
    $mt       =  MT::get_instance(1, $cfg_file);
    $ctx      =& $mt->context();

    // Test some objects inheriting ObjectBase class.

    require_once( "php/lib/class.mt_config.php" );
    $config = new Config;
    $config->Load();
    $this->assertTrue( isset( $config->id ) );

    require_once( "php/lib/class.mt_author.php" );
    $author = new Author;
    $author->Load();
    $this->assertTrue( isset( $author->id ) );

    // protected variable call (bugid:113105)
    require_once( "php/lib/class.mt_entry.php" );
    $entry     = new Entry;
    $entry->id = 1;
    $this->assertTrue( isset( $entry->id ) );
    $this->assertNull( $entry->_prefix );
    $this->assertFalse( isset( $entry->_prefix ) );

    // fixed Dynamic publishing error occurred with memcached environment. bugid: 113546
    $mt->config('MemcachedServers', '127.0.0.1:11211');
    $obj_names = array(
        'asset' => 'Asset',
        'author' => 'Author',
        'blog' => 'Blog',
        'category' => 'Category',
        'comment' => 'Comment',
        'entry' => 'Entry',
        'folder' => 'Folder',
        'page' => 'Page',
        'tbping' => 'TBPing',
        'template' => 'Template',
        'website' => 'Website');
    foreach ($obj_names as $table => $name) {
        require_once("php/lib/class.mt_$table.php");
        $obj= new $name;
        $obj->Load();
        $this->cache("$table:".$obj->id, $obj);
        $obj_cache = $this->load_cache("$table:".$obj->id);
        $this->assertInstanceOf("$name", $obj_cache);
    }

  }

    // Objcet cache
    private function cache($key, $obj) {
        if (empty($key))
            return;
        $this->cache_driver()->set($key, $obj);
    }

    private function load_cache($key) {
        if (empty($key))
            return null;
        return $this->cache_driver()->get($key);
    }



    private function cache_driver() {
        if (empty(self::$_cache_driver)) {
            require_once("class.basecache.php");
            try {
                self::$_cache_driver = CacheProviderFactory::get_provider('memcached');
            } catch (Exception $e) {
                # Memcached not supported.
                self::$_cache_driver = CacheProviderFactory::get_provider('memory');
            }
        }
        return self::$_cache_driver;
    }


}

?>
