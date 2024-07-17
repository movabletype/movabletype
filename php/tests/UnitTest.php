<?php

use PHPUnit\Framework\TestCase;

require_once('captcha_lib.php');
require_once('Mockdata.php');

class UnitTest extends TestCase {

    public function testWdayFromTs() {
        require_once('MTUtil.php');
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

    public function testFetchWebsites() {

        $mt = MT::get_instance();
        $sites = $mt->db()->fetch_websites([]);
        $this->assertEquals('Blog', get_class($sites[0])); // XXX Consider to fix this to be Website instead
        $this->assertEquals(1, $sites[0]->id);
    }

    public function testFetchWebsite() {

        $mt = MT::get_instance();
        $site = $mt->db()->fetch_website(1);
        $this->assertEquals('Blog', get_class($site)); // XXX Consider to fix this to be Website instead
        $this->assertEquals(1, $site->id);
    }

    public function testFetch_widgets_by_name() {

        $template = MockData::makeTemplate(['type' => 'widget', 'name' => 'my_widget']);

        $mt = MT::get_instance();
        $widgets = $mt->db()->fetch_widgets_by_name($mt->ctx, 'my_widget', 1);
        $this->assertEquals('Template', get_class($widgets[0]));
        $this->assertEquals($template->id, $widgets[0]->id);
    }

    public function testFetch_plugin_data() {

        $mt = MT::get_instance();

        require_once('class.mt_plugindata.php');
        $plugindata = new PluginData();
        $plugindata->data = $mt->db()->serialize(['foo' => 'fooval', 'bar' => 'barval']);
        $plugindata->key = 'configuration:blog:3';
        $plugindata->plugin = 'MyPlugin';
        $plugindata->save();

        $config = $mt->db()->fetch_plugin_data('MyPlugin', 'configuration:blog:3');
        $this->assertEquals('fooval', $config['foo']);
        $this->assertEquals('barval', $config['bar']);
        
        $config1 = $mt->db()->fetch_plugin_config('MyPlugin', 'blog:3');
        $this->assertEquals('fooval', $config['foo']);
        $this->assertEquals('barval', $config['bar']);
    }

    public function testFetch_tag() {

        $tag = MockData::makeTag(['name' => 'foo']);

        $mt = MT::get_instance();
        $tag2 = $mt->db()->fetch_tag($tag->id);
        $this->assertEquals('Tag', get_class($tag2));
        $this->assertEquals($tag->id, $tag2->id);

        $tag3 = $mt->db()->fetch_tag_by_name($tag->tag_name);
        $this->assertEquals('Tag', get_class($tag3));
        $this->assertEquals($tag->id, $tag3->id);
    }

    public function testFetch_avg_scores() {

        $oscore = MockData::makeObjectScore(['object_ds' => 'entry']);
        $mt = MT::get_instance();
        $score = $mt->db()->fetch_avg_scores('foo', 'entry', 'asc', '');
        $this->assertEquals('ADORecordSet_pdo', get_class($score));
    }

    public function testBlog_ping_count() {

        $blog = Mockdata::makeBlog(['name' => 'MyBlog']);
        $entry = Mockdata::makeEntry();
        $category = Mockdata::makeCategory();
        $trackback = MockData::makeTrackback();
        $ping = MockData::makeTbping();

        $mt = MT::get_instance();
        $count = $mt->db()->blog_ping_count(['blog_id' => $ping->blog_id]);
        $this->assertEquals(1, $count);
    }

    // @TODO SKIP MTC-29547

    // public function testTags_entry_count() {

    //     $entry = Mockdata::makeEntry(['status' => 2]);
    //     $tag = MockData::makeTag(['name' => 'foo']);
    //     $otag = MockData::makeObjectTag(['object_datasource' => 'entry', 'tag_id' => $tag->id]);

    //     $mt = MT::get_instance();
    //     $count = $mt->db()->tags_entry_count($tag->id);
    //     $this->assertEquals(1, $count);
    // }

    public function testEntry_comment_count() {

        $entry = Mockdata::makeEntry(['status' => 2]);
        $comment = Mockdata::makeComment();
        $comment = Mockdata::makeComment();

        $mt = MT::get_instance();
        $count = $mt->db()->entry_comment_count($entry->id);
        $this->assertEquals(2, $count);
    }

    public function testEntry_tbping_count() {

        $entry = Mockdata::makeEntry(['status' => 2]);
        $tbping = Mockdata::makeTbping();
        $tbping = Mockdata::makeTbping();

        $mt = MT::get_instance();
        $count = $mt->db()->entry_ping_count($entry->id);
        $this->assertEquals(2, $count);
    }

    public function testCategory_ping_count() {

        $blog = Mockdata::makeBlog(['name' => 'MyBlog']);
        $entry = Mockdata::makeEntry(['status' => 2]);
        $category = Mockdata::makeCategory();
        $trackback = Mockdata::makeTrackback();
        $tbping = Mockdata::makeTbping();
        $tbping = Mockdata::makeTbping();

        $mt = MT::get_instance();
        $count = $mt->db()->category_ping_count($category->id);
        $this->assertEquals(2, $count);

        $pings = $mt->db()->fetch_pings(['blog_id' => $blog->id]);
        $this->assertEquals('TBPing', get_class($pings[0]));
        $this->assertEquals(2, count($pings));
    }

    public function testGet_latest_touch() {

        $blog = Mockdata::makeBlog(['name' => 'MyBlog']);
        $entry = Mockdata::makeEntry(['status' => 2]);
        $touch = Mockdata::makeTouch(['object_type' => 'author', 'blog_id' => 0]);
        $touch = Mockdata::makeTouch(['object_type' => 'entry', 'blog_id' => $blog->id]);

        $mt = MT::get_instance();
        $touches = $mt->db()->get_latest_touch($blog->id, 'author');
        $this->assertEquals('Touch', get_class($touches));
        $touches = $mt->db()->get_latest_touch($blog->id, 'entry');
        $this->assertEquals('Touch', get_class($touches));
    }

    public function testFetch_rebuild_trigger() {

        $blog = Mockdata::makeBlog(['name' => 'MyBlog']);
        $trigger = Mockdata::makeRebuildTrigger();

        $mt = MT::get_instance();
        $trigger2 = $mt->db()->fetch_rebuild_trigger($blog->id);
        $this->assertEquals('RebuildTrigger', get_class($trigger2));
    }

    public function testFetchPermission() {

        $perm = MT::get_instance()->db()->fetch_permission(array('blog_id' => 1, 'id' => 1));
        $this->assertTrue(is_array($perm) && !empty($perm));
        $this->assertEquals(1, $perm[0]->blog_id);
        $this->assertEquals(1, $perm[0]->author_id);
        $this->assertTrue(preg_match("{'administer_site'}", $perm[0]->permission_permissions) !== false);

        require_once('class.mt_author.php');
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

        require_once('class.mt_blog.php');
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
        require_once('archive_lib.php');
        ArchiverFactory::add_archiver('ContentType', 'ContentTypeArchiver');
        $a = ArchiverFactory::get_archiver('ContentType');
        $this->assertTrue($a instanceof ArchiveType);
    }

    public function testCC() {
        require_once('cc_lib.php');
        $this->assertEquals(cc_name('by'), 'Attribution');
    }

    public function testDatetimeToTimestamp() {
        require_once('MTUtil.php');

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
        require_once('class.mt_association.php');
        $assoc = new Association();
        $assoc->Load('association_id=1');
        $role = $assoc->role();
        $this->assertEquals('Role', get_class($role));
        $this->assertEquals('1', $role->id);
        $this->assertEquals('1', $role->role_id);
    }

    public function testFileinfo() {
        require_once('class.mt_fileinfo.php');
        require_once('class.mt_category.php');
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

    public function testThumbnail() {

        $tempdir = sys_get_temp_dir(). DIRECTORY_SEPARATOR. 'phpunit_'. getmypid(). rand(1000, 9999). '/';

        require_once('thumbnail_lib.php');
        $thumb1 = new Thumbnail('t/images/test.jpg');
        $this->assertEquals(true, $thumb1->get_thumbnail(['dest' => $tempdir. 'test.jpg']));
        $this->assertEquals(640, $thumb1->width());
        $this->assertEquals(480, $thumb1->height());

        $thumb2 = new Thumbnail('t/images/test.gif');
        $this->assertEquals(true, $thumb2->get_thumbnail(['dest' => $tempdir. 'test.gif']));
        $this->assertEquals(400, $thumb2->width());
        $this->assertEquals(300, $thumb2->height());

        $thumb3 = new Thumbnail('t/images/test.png');
        $this->assertEquals(true, $thumb3->get_thumbnail(['dest' => $tempdir. 'test.png']));
        $this->assertEquals(150, $thumb3->width());
        $this->assertEquals(150, $thumb3->height());

        $thumb3 = new Thumbnail('t/images/test.webp');
        $this->assertEquals(true, $thumb3->get_thumbnail(['dest' => $tempdir. 'test.webp']));
        $this->assertEquals(150, $thumb3->width());
        $this->assertEquals(150, $thumb3->height());
    }
}

class MyCaptchaProvider implements CaptchaProvider { 
    public function get_name() { return ''; }
    public function get_classname() { return ''; }
    public function form_fields($blog_id) { return ''; }
}
