<?php

error_reporting(E_ALL | E_STRICT);
set_include_path(realpath(__DIR__).'/../extlib/adodb5');

class AdodbTest extends PHPUnit_Framework_TestCase {

    public function testRequire() {

        # case 113603
        $this->assertEquals( require_once('adodb.inc.php'), 1, 'require_once \'adodb.inc.php\'' );
        $this->assertEquals( require_once('drivers/adodb-pdo.inc.php'), 1, 'require_once \'drivers/adodb-pdo.inc.php\''  );
    }

}