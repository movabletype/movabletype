<?php

use PHPUnit\Framework\TestCase;

include_once("php/lib/captcha_lib.php");

class UnitTest extends TestCase {

    private $mt;
    private $ctx;

    public function testWdayFromTs() {
        include_once("php/lib/MTUtil.php");
        // leap year
        $this->assertEquals(6, wday_from_ts(2000,1,1), 'right wday');
        $this->assertEquals(4, wday_from_ts(2000,1,6), 'right wday');
        $this->assertEquals(2, wday_from_ts(2000,2,29), 'right wday');
        $this->assertEquals(3, wday_from_ts(2000,3,1), 'right wday');
        $this->assertEquals(0, wday_from_ts(2000,4,30), 'right wday');
        $this->assertEquals(1, wday_from_ts(2000,5,1), 'right wday');
        // normal year
        $this->assertEquals(3, wday_from_ts(2001,2,28), 'right wday');
        $this->assertEquals(4, wday_from_ts(2001,3,1), 'right wday');
    }

    public function testFetchPermission() {
        include_once("php/mt.php");
        include_once("php/lib/MTUtil.php");
        $cfg_file =  realpath( "t/mysql-test.cfg" );
        $this->mt =  MT::get_instance(1, $cfg_file);
        $this->ctx =& $this->mt->context();

        error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING);
        $perm = $this->mt->db()->fetch_permission(array('blog_id' => 1, 'id' => 1));
        $this->assertTrue(is_array($perm) && !empty($perm));
        $this->assertEquals(1, $perm[0]->blog_id);
        $this->assertEquals(1, $perm[0]->author_id);
        $this->assertTrue(preg_match("{'administer_site'}", $perm[0]->permission_permissions) !== false);
        
        include_once("php/lib/class.mt_author.php");
        $author = new Author;
        $author->Load(1);
        $perm2 = $author->permissions(1);
        $this->assertTrue(is_array($perm2) && !empty($perm2));
        $this->assertEquals(1, count($perm2));
        $this->assertEquals(1, $perm2[0]->blog_id);
        $this->assertEquals(1, $perm2[0]->author_id);
        $this->assertTrue(preg_match("{'administer_site'}", $perm2[0]->permission_permissions) !== false);
        
        $perm3 = $author->permissions();
        $this->assertTrue(is_array($perm3) && !empty($perm3));
        $this->assertEquals(2, count($perm3));
        $this->assertEquals(0, $perm3[0]->blog_id);
        $this->assertEquals(1, $perm3[0]->author_id);
        $this->assertTrue(preg_match("{'administer_site'}", $perm3[0]->permission_permissions) !== false);
        $this->assertEquals(1, $perm3[1]->blog_id);
        $this->assertEquals(1, $perm3[1]->author_id);
        $this->assertTrue(preg_match("{'administer_site'}", $perm3[1]->permission_permissions) !== false);

        include_once("php/lib/class.mt_blog.php");
        $b = new Blog;
        $b->Load(1);
        $b->set_values(array('blog_name' => 'test_name', 'blog_site_url' => 'test_url'));
        $this->assertEquals($b->blog_name, 'test_name');
        $this->assertEquals($b->blog_site_url, 'test_url');
        $b->set_values(array('name' => 'test_name2', 'site_url' => 'test_url2'));
        $this->assertEquals($b->name, 'test_name2');
        $this->assertEquals($b->site_url, 'test_url2');
        $array = $b->GetArray();
        $this->assertEquals($array['blog_name'], 'test_name2');
    }
    
    public function testCaptchaLib() {
        CaptchaFactory::add_provider('test', 'MyCaptchaProvider');
        $a = CaptchaFactory::get_provider('test');
        $this->assertTrue($a instanceof CaptchaProvider);
    }
    
    public function testArchiverFactory() {
        include_once("php/lib/archive_lib.php");
        ArchiverFactory::add_archiver('ContentType', 'ContentTypeArchiver');
        $a = ArchiverFactory::get_archiver('ContentType');
        $this->assertTrue($a instanceof ArchiveType);
    }

    public function testCC() {
        include_once("php/lib/cc_lib.php");
        $this->assertEquals(cc_name('by'), 'Attribution');
    }

    public function testDatetimeToTimestamp() {
        include_once("php/lib/MTUtil.php");

        $ret = datetime_to_timestamp('2005-12-30 23:23:59');
        $this->assertEquals(1135952639, $ret);

        // 13th month is next Jan
        $ret = datetime_to_timestamp('2005-13-30 23:23:59');
        $this->assertEquals(1138631039, $ret);

        // Too long is acceptable
        $ret = datetime_to_timestamp('2005-13-30 23:23:591');
        $this->assertEquals(1138631039, $ret);
        
        if (PHP_VERSION_ID > 506000) {

            // empty
            $ret = datetime_to_timestamp('');
            $this->assertTrue(false === $ret);

            // Too short
            $ret = datetime_to_timestamp('2005');
            $this->assertTrue(false === $ret);
        }
    }

    public function testDaysIn() {

        $ret = days_in('12', '2000');
        $this->assertEquals(31, $ret);

        $ret = days_in('11', '2000');
        $this->assertEquals(30, $ret);

        $ret = days_in('2', '2000');
        $this->assertEquals(29, $ret);

        $ret = days_in('14', '1999'); // Feb 2000
        $this->assertEquals(29, $ret);

        $ret = days_in('2', '2001');
        $this->assertEquals(28, $ret);

        $ret = days_in(0, 0);
        $this->assertEquals(31, $ret); // Jan 1970
        
        if (PHP_VERSION_ID > 506000) {

            // Empty string for an argument
            $ret = days_in('12', '');
            $this->assertEquals(31, $ret); // Jan 1970

            // Empty string for an argument
            $ret = days_in('', '2005');
            $this->assertEquals(31, $ret); // Jan 1970
        }
    }

    public function testAssociation() {
        include_once("php/lib/class.mt_association.php");
        $assoc = new Association();
        $assoc->Load('association_id=1');
        $role = $assoc->role();
        $this->assertEquals('Role', get_class($role));
        $this->assertEquals('1', $role->id);
        $this->assertEquals('1', $role->role_id);
    }

    public function testFileinfo() {
        include_once("php/lib/class.mt_fileinfo.php");
        include_once("php/lib/class.mt_category.php");
        $cat = new Category();
        $cat->blog_id = 1;
        $cat->category_category_set_id = 1;
        $cat->label = 'test';
        $cat->save();
        $finfo = new FileInfo();
        $finfo->blog_id = 1;
        $finfo->entry_id = 1;
        $finfo->category_id = 1;
        $finfo->save();
        $finfo->Load('fileinfo_id=1');
        $cat = $finfo->category();
        $this->assertEquals('Category', get_class($cat));
        $this->assertEquals('1', $cat->id);
        $this->assertEquals('1', $cat->category_id);
    }
}

class MyCaptchaProvider implements CaptchaProvider { 
    public function get_name() { return ''; }
    public function get_classname() { return ''; }
    public function form_fields($blog_id) { return ''; }
}
