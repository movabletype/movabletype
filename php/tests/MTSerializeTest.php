<?php

use PHPUnit\Framework\TestCase;

class MTSerializeTest extends TestCase {
    public function testGetInstace() {
        require_once('MTSerialize.php');
        $serializer1 = MTSerialize::get_instance();
        $this->assertInstanceOf('MTSerialize', $serializer1);

        $serializer2 = MTSerialize::get_instance();
        $this->assertTrue($serializer1 === $serializer2);

        $serializer3 = new MTSerialize;
        $this->assertFalse($serializer1 === $serializer3);
    }
}
