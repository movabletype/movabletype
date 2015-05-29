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

    // protected variable call
    require_once( "php/lib/class.mt_entry.php" );
    $entry = new Entry;
    $entry->Load();
    $this->assertTrue( isset( $entry->id ) );
    $this->assertNull( $entry->_prefix );
    $this->assertFalse( isset( $entry->_prefix ) );

  }

}

?>
