<?php

use PHPUnit\Framework\TestCase;

require_once('archive_lib.php');

class ArchiveLibTest extends TestCase {

    public function testDecTs() {
        foreach ([new TestArchiver(), new TestArchiver2()] as $archiver) {
            $ts = $archiver->public_dec_ts('20211231235959');
            $this->assertEquals('20211231235958', $ts, 'right ts');

            $ts = $archiver->public_dec_ts('20211231235900');
            $this->assertEquals('20211231235859', $ts, 'right ts');

            $ts = $archiver->public_dec_ts('20211231230000');
            $this->assertEquals('20211231225959', $ts, 'right ts');

            $ts = $archiver->public_dec_ts('20211231000000');
            $this->assertEquals('20211230235959', $ts, 'right ts');

            $ts = $archiver->public_dec_ts('20211201000000');
            $this->assertEquals('20211130235959', $ts, 'right ts');

            $ts = $archiver->public_dec_ts('20210101000000');
            $this->assertEquals('20201231235959', $ts, 'right ts');
        }
    }
}

class TestArchiver extends YearlyArchiver {
    public function public_dec_ts($ts) {
        return $this->dec_ts($ts);
    }
}

class TestArchiver2 extends ContentTypeDailyArchiver {
    public function public_dec_ts($ts) {
        return $this->dec_ts($ts);
    }
}
