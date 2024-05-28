<?php

use PHPUnit\Framework\TestCase;

class BaseObjectTest extends TestCase {
    private static $_cache_driver;
    public function testIssetWithOverloading() {

        // Test some objects inheriting ObjectBase class.

        require_once("php/lib/class.mt_config.php");
        $config = new Config;
        $config->Load();
        $this->assertTrue(isset($config->id));

        require_once("php/lib/class.mt_author.php");
        $author = new Author;
        $author->Load();
        $this->assertTrue(isset($author->id));

        require_once("php/lib/class.mt_entry.php");
        $entry     = new Entry;
        $entry->id = 1;
        $this->assertTrue(isset($entry->id));
        $this->assertEquals('entry_', $entry->_prefix);

        // protected variable call (bugid:113105, MTC-9543)
        $this->assertNull($entry->_has_meta);
        $this->assertFalse(isset($entry->_has_meta));

        // dynamic properties still works (__set/__get/__isset magic methods)
        $entry->unknown = 'val';
        $this->assertTrue(isset($entry->unknown));
        $this->assertEquals('val', $entry->unknown);

        // meta field in the form of order_by MT tag attributes work
        $meta_field1 = 'field:my_field1';
        $meta_field2 = 'field:my_field2';
        $entry->$meta_field1 = 'my_field1_val';
        $this->assertTrue(isset($entry->$meta_field1));
        $this->assertEquals('my_field1_val', $entry->$meta_field1);
        $this->assertFalse(isset($entry->$meta_field2));
        $this->assertNull($entry->$meta_field2);

        // fixed Dynamic publishing error occurred with memcached environment. bugid: 113546
        MT::get_instance()->config('MemcachedServers', '127.0.0.1:11211');
        $obj_names = [
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
            'website' => 'Website'];
        foreach ($obj_names as $table => $name) {
            require_once("class.mt_$table.php");
            $obj = new $name;
            $obj->Load();

            $this->cache("$table:".$obj->id, $obj);
            $obj_cache = $this->load_cache("$table:".$obj->id);
            $this->assertInstanceOf("$name", $obj_cache);
        }

    }

    // Objcet cache
    private function cache($key, $obj) {
        if (empty($key)) {
            return;
        }
        $meta_table = $obj->_table . '_meta';
        $obj->$meta_table = [];
        $this->cache_driver()->set($key, $obj);
    }

    private function load_cache($key) {
        if (empty($key)) {
            return null;
        }
        return $this->cache_driver()->get($key);
    }



    private function cache_driver() {
        if (empty(self::$_cache_driver)) {
            require_once('class.basecache.php');
            try {
                self::$_cache_driver = CacheProviderFactory::get_provider('memcached');
            } catch (Exception $e) {
                # Memcached not supported.
                self::$_cache_driver = CacheProviderFactory::get_provider('memory');
            }
        }
        return self::$_cache_driver;
    }

    public function testLoadByIntId() {

        require_once('class.mt_template.php');

        $obj = new Template;
        $obj->Load(2);
        $this->assertEquals(2, $obj->id);

        $obj = new Template;
        $obj->Load('2');
        $this->assertEquals(2, $obj->id);

        $obj = new Template;
        $obj->LoadByIntId(3);
        $this->assertEquals(3, $obj->id);

        $obj = new Template;
        $obj->LoadByIntId('3');
        $this->assertEquals(3, $obj->id);

        $obj = new Template;
        $obj->Load('template_id = 4');
        $this->assertEquals(4, $obj->id);

        $obj = new Template;
        $obj->Load('2.5');
        $this->assertEquals(null, $obj->id);

        $obj = new Template;
        $obj->Load(2.5);
        $this->assertEquals(null, $obj->id);
    }
}
