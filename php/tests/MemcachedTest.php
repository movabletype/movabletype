<?php

use PHPUnit\Framework\TestCase;

require_once('mtcache_base.php');
require_once('class.basecache.php');
require_once('mt.php');

class MemcachedTest extends TestCase {

    public function testMain() {
        $mt = MT::get_instance();
        $this->_testCacheLib($mt);
        $this->_testMTCacheSession($mt);
        $this->_testCacheSession($mt);
        $this->_testCacheMemcache($mt);
        $this->_testMTCacheMemcached($mt);
    }

    public function _testCacheLib($mt) {
        CacheProviderFactory::add_provider('memory', 'cachememory');
        $a = CacheProviderFactory::get_provider('memory');
        $this->assertTrue($a instanceof CacheMemory);
        $this->assertCache($a, true);
    }

    public function _testMTCacheSession($mt) {
        require_once('mtcache_session.php');
        $a = new MTCache_session();
        $this->assertCache($a, true);
    }

    public function _testCacheSession($mt) {
        require_once('class.cachesession.php');
        $a = new CacheSession();
        $this->assertCache($a, true);
    }

    public function _testCacheMemcache($mt) {
        require_once('class.cachememcached.php');
        $mt->config('MemcachedServers', '127.0.0.1:11211');
        $a = new CacheMemcached();
        $this->assertCache($a);
    }

    public function _testMTCacheMemcached($mt) {
        require_once('mtcache_memcached.php');
        $a = new MTCache_memcached();
        $a->connect('127.0.0.1:11211');
        $this->assertCache($a);
    }

    private function assertCache($class, $flat=false) {
        $class->add('a', 'b', 10);
        $this->assertEquals('b', $class->get('a'));
        $class->replace('a', 'c', 10);
        $this->assertEquals('c', $class->get('a'));
        $class->delete('a');
        $this->assertEquals(null, $class->get('a'));
        $class->set('c', 'd', 10);
        $this->assertEquals('d', $class->get('c'));
        $class->flush_all();
        $this->assertEquals(null, $class->get('c'));
        $class->add('a', 'b', 10);
        $class->add('c', 'd', 10);
        $class->add('e', 'f', 10);
        $multi = $class->get_multi(['a', 'c']);
        if ($flat) {
            $this->assertEquals(['b', 'd'], $multi);
        } else {
            $this->assertEquals('b', $multi['a']);
            $this->assertEquals('d', $multi['c']);
            $this->assertEquals(2, count($multi));
        }
        $class->flush_all();
    }
}
