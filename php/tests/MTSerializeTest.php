<?php

class MTSerializeTest extends PHPUnit_Framework_TestCase {
    public function testGetInstace() {
        include_once('php/lib/MTSerialize.php');
        $serializer1 = MTSerialize::get_instance();
        $this->assertInstanceOf('MTSerialize', $serializer1);

        $serializer2 = MTSerialize::get_instance();
        $this->assertTrue($serializer1 === $serializer2);

        $serializer3 = new MTSerialize;
        $this->assertFalse($serializer1 === $serializer3);
    }
}

