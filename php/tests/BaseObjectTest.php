<?php

class BaseObjectTest extends PHPUnit_Framework_TestCase {

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
    require_once('php/lib/class.mt_fileinfo.php');
    $fileinfo= new FileInfo;
    $where = "fileinfo_id = 1";
    $fileinfo->Load($where);
    $blog = $fileinfo->blog();

    $this->assertInstanceOf(Blog, $blog);

  }

}

?>
