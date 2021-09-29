<?php

use PHPUnit\Framework\TestCase;

include_once("php/lib/mtcache_base.php");
include_once("php/lib/class.basecache.php");

class MemcachedTest extends TestCase {
    
    public function testCacheLib() {
        CacheProviderFactory::add_provider('memory', 'cachememory');
        $a = CacheProviderFactory::get_provider('memory');
        $this->assertTrue($a instanceof CacheMemory);
        
        $a->add('a', 'b', 10);
        $this->assertEquals($a->get('a'), 'b');
        $a->replace('a', 'c', 10);
        $this->assertEquals($a->get('a'), 'c');
        $a->delete('a');
        $this->assertEquals($a->get('a'), null);
        $a->set('c', 'd', 10);
        $this->assertEquals($a->get('c'), 'd');
        $a->flush_all();
        $this->assertEquals($a->get('c'), null);
    }
    
    public function testCacheMemcache() {
        include_once("php/lib/mtcache_memcached.php");
        $a = new MTCache_memcached();
        $a->connect('127.0.0.1:11211');

        $a->add('a', 'b', 10);
        $this->assertEquals($a->get('a'), 'b');
        $a->replace('a', 'c', 10);
        $this->assertEquals($a->get('a'), 'c');
        $a->delete('a');
        $this->assertEquals($a->get('a'), null);
        $a->set('c', 'd', 10);
        $this->assertEquals($a->get('c'), 'd');
        $a->flush_all();
        $this->assertEquals($a->get('c'), null);
        $a->add('a', 'b', 10);
        $a->add('c', 'd', 10);
        $a->add('e', 'f', 10);
        $multi = $a->get_multi(array('a', 'c'));
        $this->assertEquals($multi['a'], 'b');
        $this->assertEquals($multi['c'], 'd');
        $this->assertEquals($multi['e'], null);
    }
}
