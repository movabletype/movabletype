<?php

use PHPUnit\Framework\TestCase;

require_once('captcha_lib.php');
require_once('Mockdata.php');

class UnitTest extends TestCase {

    public function testWdayFromTs() {
        require_once('MTUtil.php');
        // leap year
        $this->assertEquals(6, wday_from_ts(2000, 1, 1), 'right wday');
        $this->assertEquals(4, wday_from_ts(2000, 1, 6), 'right wday');
        $this->assertEquals(2, wday_from_ts(2000, 2, 29), 'right wday');
        $this->assertEquals(3, wday_from_ts(2000, 3, 1), 'right wday');
        $this->assertEquals(0, wday_from_ts(2000, 4, 30), 'right wday');
        $this->assertEquals(1, wday_from_ts(2000, 5, 1), 'right wday');
        // normal year
        $this->assertEquals(3, wday_from_ts(2001, 2, 28), 'right wday');
        $this->assertEquals(4, wday_from_ts(2001, 3, 1), 'right wday');
    }

    public function testFetchBlogs() {

        $site_id = 1;
        $template1_site = MockData::makeTemplate([
            'blog_id' => $site_id, 'name' => 'testFetchBlogs', 'type' => 'custom', 'text' => 'template1_site']);
        $template1_global = MockData::makeTemplate([
            'blog_id' => 0, 'name' => 'testFetchBlogs', 'type' => 'custom', 'text' => 'template1_global']);

        $mt = MT::get_instance();
        $ctx = $mt->context();
        $text = $mt->db()->get_template_text($ctx, $template1_site->name, $site_id, 'custom', false);
        $this->assertEquals($template1_site->text, $text);
        $text2 = $mt->db()->get_template_text($ctx, $template1_site->name, $site_id, 'custom', true);
        $this->assertEquals($template1_global->text, $text2);
        $text3 = $mt->db()->get_template_text($ctx, $template1_site->name, $site_id, 'custom');
        $this->assertEquals($template1_site->text, $text3);

        $template2_site = MockData::makeTemplate([
            'blog_id' => $site_id, 'name' => 'testFetchBlogs2', 'type' => 'custom', 'text' => 'template2_site']);

        $text4 = $mt->db()->get_template_text($ctx, $template2_site->name, $site_id, 'custom', false);
        $this->assertEquals($template2_site->text, $text4);
        $text5 = $mt->db()->get_template_text($ctx, $template2_site->name, $site_id, 'custom', true);
        $this->assertEquals('', $text5);
        $text6 = $mt->db()->get_template_text($ctx, $template2_site->name, $site_id, 'custom');
        $this->assertEquals($template2_site->text, $text6);

        $template3_global = MockData::makeTemplate([
            'blog_id' => 0, 'name' => 'testFetchBlogs3', 'type' => 'custom', 'text' => 'template3_global']);

        $text4 = $mt->db()->get_template_text($ctx, $template3_global->name, $site_id, 'custom', true);
        $this->assertEquals($template3_global->text, $text4);
        $text4 = $mt->db()->get_template_text($ctx, $template3_global->name, $site_id, 'custom', false);
        $this->assertEquals('', $text4);
        $text6 = $mt->db()->get_template_text($ctx, $template3_global->name, $site_id, 'custom');
        $this->assertEquals($template3_global->text, $text6);

        $template4_index = MockData::makeTemplate([
            'blog_id' => 1, 'name' => 'testFetchBlogs4', 'type' => 'index', 'text' => 'template4',
            'identifier' => 'archive_index']);

        $text7 = $mt->db()->get_template_text($ctx, $template4_index->identifier, $site_id, 'index');
        $this->assertEquals($template4_index->text, $text7);
    }

    public function testFetchWebsites() {

        $mt = MT::get_instance();
        $sites = $mt->db()->fetch_websites([]);
        $this->assertEquals('Blog', get_class($sites[0])); // XXX Consider to fix this to be Website instead
        $this->assertEquals(1, $sites[0]->id);
    }

    public function testFetchWebsite() {

        // make sure there's not any cache
        $site1 = MockData::makeBlog(['name' => 'testFetchWebsite', 'class' => 'website']);

        $mt = MT::get_instance();
        $site2 = $mt->db()->fetch_website($site1->id);
        $this->assertEquals('Website', get_class($site2));
        $this->assertEquals($site1->id, $site2->id);
    }

    public function testFetchWidgetsByName() {

        $site1 = MockData::makeBlog(['name' => 'testFetchWidgetsByName', 'class' => 'website']);
        $template = MockData::makeTemplate(['type' => 'widget', 'name' => 'my_widget']);

        $mt = MT::get_instance();
        $widgets = $mt->db()->fetch_widgets_by_name($mt->ctx, 'my_widget', $site1->id);
        $this->assertEquals('Template', get_class($widgets[0]));
        $this->assertEquals($template->id, $widgets[0]->id);
    }

    public function testFetchEntries() {

        BaseObject::install_meta('entry', 'field.myfield', 'vstring');

        $site1 = MockData::makeBlog(['name' => 'testFetchEntries', 'class' => 'website', 'days_on_index' => 10]);
        $mt = MT::get_instance();
        $ctx = $this->get_blog_context($site1);

        $entry1 = MockData::makeEntry(['status' => 2, 'basename' => 'basename1']);
        $entry2 = MockData::makeEntry(['status' => 2, 'basename' => 'basename2']);

        $entries = $mt->db()->fetch_entries(['blog_id' => $site1->id], $total_count);
        $this->assertEquals(2, count($entries));
        $this->assertEquals('Entry', get_class($entries[0]));
        $this->assertEquals($entry2->id, $entries[0]->id);

        $entries = $mt->db()->fetch_entries(['blog_id' => $site1->id, 'entry_ids' => [$entry1->id, $entry2->id]], $total_count);
        $this->assertEquals(2, count($entries));
        $this->assertEquals('Entry', get_class($entries[0]));
        $this->assertEquals($entry2->id, $entries[0]->id);

        $entries = $mt->db()->fetch_entries(['blog_id' => $site1->id, 'entry_ids' => [$entry2->id]], $total_count);
        $this->assertEquals(1, count($entries));
        $this->assertEquals('Entry', get_class($entries[0]));
        $this->assertEquals($entry2->id, $entries[0]->id);

        $entries = $mt->db()->fetch_entries(['blog_id' => $site1->id, 'max_comment' => 1], $total_count);
        $this->assertEquals(2, count($entries));
        $this->assertEquals('Entry', get_class($entries[0]));
        $this->assertEquals($entry2->id, $entries[0]->id);

        $entries = $mt->db()->fetch_entries(['blog_id' => $site1->id, 'min_comment' => 0], $total_count);
        $this->assertEquals(2, count($entries));
        $this->assertEquals('Entry', get_class($entries[0]));
        $this->assertEquals($entry2->id, $entries[0]->id);

        $entries = $mt->db()->fetch_entries(['blog_id' => $site1->id, 'limit' => 1, 'sort_by' => 'basename'], $total_count);
        $this->assertEquals(1, count($entries));
        $this->assertEquals('Entry', get_class($entries[0]));
        $this->assertEquals($entry2->id, $entries[0]->id);

        $entries = $mt->db()->fetch_entries(['blog_id' => $site1->id, 'limit' => 1, 'sort_by' => 'score'], $total_count);
        $this->assertEquals(1, count($entries));
        $this->assertEquals('Entry', get_class($entries[0]));
        $this->assertEquals($entry1->id, $entries[0]->id);

        $entries = $mt->db()->fetch_entries(['blog_id' => $site1->id, 'limit' => 1, 'sort_by' => 'rate'], $total_count);
        $this->assertEquals(1, count($entries));
        $this->assertEquals('Entry', get_class($entries[0]));
        $this->assertEquals($entry1->id, $entries[0]->id);
    }

    public function testFetchCategory() {

        $mt = MT::get_instance();
        $site1 = MockData::makeBlog(['name' => 'testFetchCategory']);
        $ctx = $this->get_blog_context($site1);

        $category1 = Mockdata::makeCategory(['label' => 'mylabel1']);
        $category2 = Mockdata::makeCategory(['label' => 'mylabel2']);
        $entry1 = Mockdata::makeEntry(['status' => 2]);
        $placement = MockData::makeObjectPlacement(['category_id' => $category1->id]);
        $placement = MockData::makeObjectPlacement(['category_id' => $category2->id]);


        $categories = $mt->db()->fetch_categories(['blog_id' => $site1->id, 'label' => ['mylabel1', 'mylabel2']]);
        $this->assertEquals(2, count($categories));
        $this->assertEquals('Category', get_class($categories[0]));
        $this->assertEquals($category1->id, $categories[0]->id);

        $ccet = Mockdata::makeCategorySet();
        $category3 = Mockdata::makeCategory(['label' => 'mylabel3']);
        $category4 = Mockdata::makeCategory(['label' => 'mylabel4']);
        $ct = Mockdata::makeContentType();
        $cd = Mockdata::makeContentData();
        $ocat = MockData::makeObjectCategory(['object_ds' => 'content_data', 'category_id' => $category3->id]);
        $ocat = MockData::makeObjectCategory(['object_ds' => 'content_data', 'category_id' => $category4->id]);

        $categories = $mt->db()->fetch_categories([
            'category_set_id' => $ccet->id, 'blog_id' => $site2->id, 'content_id' => $cd->id]);
        $this->assertEquals(2, count($categories));
        $this->assertEquals('Category', get_class($categories[0]));
        $this->assertEquals($category3->id, $categories[0]->id);
    }

    public function testFetchAuthors() {

        $mt = MT::get_instance();
        $site = MockData::makeBlog(['name' => 'testFetchAuthors']);
        $ctx = $this->get_blog_context($site);

        $author = MockData::makeAuthor(['basename' => 'joe']);
        $entry = MockData::makeEntry(['basename' => 'basename1', 'status' => 2]);
        $oscore = MockData::makeObjectScore(['object_ds' => 'author', 'namespace' => 'testFetchAuthors']);

        $authors = $mt->db()->fetch_authors(['author_nickname' => 'joe']);
        $this->assertEquals(1, count($authors));
        $this->assertEquals('Author', get_class($authors[0]));
        $this->assertEquals($author->id, $authors[0]->id);

        $authors = $mt->db()->fetch_authors(['sort_by' => 'id', 'start_num' => 100]);
        $this->assertEquals(1, count($authors));
        $this->assertEquals('Author', get_class($authors[0]));
        $this->assertEquals($author->id, $authors[0]->id);

        $authors = $mt->db()->fetch_authors(['sort_by' => 'rate', 'namespace' => 'testFetchAuthors']);
        $this->assertEquals(1, count($authors));
        $this->assertEquals('Author', get_class($authors[0]));
        $this->assertEquals($author->id, $authors[0]->id);
    }

    public function testFetchPluginData() {

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

    public function testFetchTag() {

        $tag = MockData::makeTag(['name' => 'foo']);

        $mt = MT::get_instance();
        $tag2 = $mt->db()->fetch_tag($tag->id);
        $this->assertEquals('Tag', get_class($tag2));
        $this->assertEquals($tag->id, $tag2->id);

        $tag3 = $mt->db()->fetch_tag_by_name($tag->tag_name);
        $this->assertEquals('Tag', get_class($tag3));
        $this->assertEquals($tag->id, $tag3->id);
    }

    public function testFetchAvgScores() {

        $oscore = MockData::makeObjectScore(['object_ds' => 'entry']);
        $mt = MT::get_instance();
        $score = $mt->db()->fetch_avg_scores('foo', 'entry', 'asc', '');
        $this->assertEquals('ADORecordSet_pdo', get_class($score));
    }

    public function testBlogPingCount() {

        $blog = Mockdata::makeBlog(['name' => 'testBlogPingCount']);
        $entry = Mockdata::makeEntry();
        $category = Mockdata::makeCategory();
        $trackback = MockData::makeTrackback();
        $ping = MockData::makeTbping();

        $mt = MT::get_instance();
        $count = $mt->db()->blog_ping_count(['blog_id' => $ping->blog_id]);
        $this->assertEquals(1, $count);
    }

    // @TODO SKIP MTC-29547

    // public function testTagsEntryCount() {

    //     $entry = Mockdata::makeEntry(['status' => 2]);
    //     $tag = MockData::makeTag(['name' => 'foo']);
    //     $otag = MockData::makeObjectTag(['object_datasource' => 'entry', 'tag_id' => $tag->id]);

    //     $mt = MT::get_instance();
    //     $count = $mt->db()->tags_entry_count($tag->id);
    //     $this->assertEquals(1, $count);
    // }

    public function testEntryCommentCount() {

        $entry = Mockdata::makeEntry(['status' => 2]);
        $comment = Mockdata::makeComment();
        $comment = Mockdata::makeComment();

        $mt = MT::get_instance();
        $count = $mt->db()->entry_comment_count($entry->id);
        $this->assertEquals(2, $count);
    }

    public function testEntryTbpingCount() {

        $entry = Mockdata::makeEntry(['status' => 2]);
        $tbping = Mockdata::makeTbping();
        $tbping = Mockdata::makeTbping();

        $mt = MT::get_instance();
        $count = $mt->db()->entry_ping_count($entry->id);
        $this->assertEquals(2, $count);
    }

    public function testCategoryPingCount() {

        $blog = Mockdata::makeBlog(['name' => 'testCategoryPingCount']);
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

        $pings = $mt->db()->fetch_pings(['blog_id' => $blog->id, 'entry_id' => $entry->id]);
        $this->assertEquals('TBPing', get_class($pings[0]));
        $this->assertEquals(2, count($pings));
    }

    public function testAssetCount() {

        $site = Mockdata::makeBlog(['name' => 'testAssetCount']);
        $mt = MT::get_instance();
        $ctx = $this->get_blog_context($site);

        $asset = Mockdata::makeAsset(['type' => 'image']);
        $entry = MockData::makeEntry(['basename' => 'basename1', 'status' => 2]);
        $oscore = MockData::makeObjectScore(['object_ds' => 'asset', 'namespace' => 'testAssetCount']);

        $count = $mt->db()->asset_count(['blog_id' => $site->id, 'type' => 'image']);
        $this->assertEquals(1, $count);

        $assets = $mt->db()->fetch_assets(['blog_id' => $site->id, 'sort_by' => 'rate']);
        $this->assertEquals(1, count($assets));
        $this->assertEquals('Asset', get_class($assets[0]));
        $this->assertEquals($asset->id, $assets[0]->id);
    }

    public function testGetLatestTouch() {

        $site = Mockdata::makeBlog(['name' => 'testGetLatestTouch']);
        $mt = MT::get_instance();
        $ctx = $this->get_blog_context($site);

        $entry = Mockdata::makeEntry(['status' => 2]);
        $touch = Mockdata::makeTouch(['object_type' => 'author', 'blog_id' => 0, 'modified_on' => '20200101']);
        $touch = Mockdata::makeTouch(['object_type' => 'entry', 'blog_id' => $site->id, 'modified_on' => '20200102']);
        $touch = Mockdata::makeTouch(['object_type' => 'template', 'blog_id' => $site->id, 'modified_on' => '20200103']);

        $touches = $mt->db()->get_latest_touch($site->id, 'author');
        $this->assertEquals('Touch', get_class($touches));
        $touches = $mt->db()->get_latest_touch($site->id, 'entry');
        $this->assertEquals('Touch', get_class($touches));
        $touches = $mt->db()->get_latest_touch($site->id, ['entry', 'template']);
        $this->assertEquals('Touch', get_class($touches));
        $this->assertEquals('template', $touches->object_type);
    }

    public function testFetchTemplateMeta() {

        $site = Mockdata::makeBlog(['name' => 'testFetchTemplateMeta']);
        $mt = MT::get_instance();
        $ctx = $this->get_blog_context($site);

        $template = MockData::makeTemplate(['type' => 'index', 'name' => 'my_index', 'identifier' => 'archive_index']);
        $template = MockData::makeTemplate(['type' => 'index', 'name' => 'my_index', 'identifier' => 'archive_index', 'blog_id' => 0]);

        $template = $mt->db()->fetch_template_meta('identifier', 'archive_index', $site->id, false);
        $this->assertEquals('Template', get_class($template));
        $this->assertEquals($site->id, $template->blog_id);
        $template = $mt->db()->fetch_template_meta('index', 'my_index', $site->id, false);
        $this->assertEquals('Template', get_class($template));
        $this->assertEquals($site->id, $template->blog_id);
        $template = $mt->db()->fetch_template_meta('identifier', 'archive_index', $site->id, true);
        $this->assertEquals('Template', get_class($template));
        $this->assertEquals(0, $template->blog_id);
        $template = $mt->db()->fetch_template_meta('index', 'my_index', $site->id, true);
        $this->assertEquals('Template', get_class($template));
        $this->assertEquals(0, $template->blog_id);
        $template = $mt->db()->fetch_template_meta('identifier', 'archive_index', $site->id, null);
        $this->assertEquals('Template', get_class($template));
        $this->assertEquals($site->id, $template->blog_id);
        $template = $mt->db()->fetch_template_meta('index', 'my_index', $site->id, null);
        $this->assertEquals('Template', get_class($template));
        $this->assertEquals($site->id, $template->blog_id);
    }

    public function testFetchContent() {

        $site = Mockdata::makeBlog(['name' => 'testFetchContent']);
        $mt = MT::get_instance();
        $ctx = $this->get_blog_context($site);

        $author = MockData::makeAuthor(['basename' => 'joe']);
        $ct1 = Mockdata::makeContentType();
        $cd1 = Mockdata::makeContentData();
        $ct2 = Mockdata::makeContentType();
        $cd2 = Mockdata::makeContentData();

        $res = $mt->db()->fetch_contents([], $ct1->id);
        $this->assertEquals(1, count($res));
        $this->assertEquals('ContentData', get_class($res[0]));
        $this->assertEquals($cd1->id, $res[0]->id);

        $res = $mt->db()->fetch_contents([], [$ct1->id, $ct2->id]);
        $this->assertEquals(2, count($res));
        $this->assertEquals($cd2->id, $res[0]->id);

        $res = $mt->db()->fetch_contents(['author_id' => $cd1->author_id], $ct1->id);
        $this->assertEquals(1, count($res));
        $this->assertEquals($cd1->id, $res[0]->id);

        $date1 = '20230614000000';
        $date2 = '20230615000000'; // for niddle date
        $date3 = '20230616000000';

        $ct3 = Mockdata::makeContentType();
        $cf3 = MockData::makeContentField(['type' => 'date_and_time']);
        $cd3 = Mockdata::makeContentData();
        $cf_idx3 = MockData::makeContentFieldIndex(['value_datetime' => $date2]);
        $template = MockData::makeTemplate(['name' => 'testFetchContent', 'type' => 'archive', 'text' => 'foo']);
        $map1 = Mockdata::makeTemplateMap(['archive_type' => 'Yearly', 'dt_field_id' => $cf3->id]);

        $res = $mt->db()->fetch_contents(['current_timestamp' => $date1], $ct3->id);
        $this->assertEquals(1, count($res));
        $this->assertEquals($cd3->id, $res[0]->id);
        $res = $mt->db()->fetch_contents(['current_timestamp' => $date1, 'current_timestamp_end' => $date3], $ct3->id);
        $this->assertEquals(1, count($res));
        $this->assertEquals($cd3->id, $res[0]->id);
        $res = $mt->db()->fetch_contents(['current_timestamp_end' => $date3], $ct3->id);
        $this->assertEquals(1, count($res));
        $this->assertEquals($cd3->id, $res[0]->id);
        $res = $mt->db()->fetch_contents(['current_timestamp' => $date3], $ct3->id);
        $this->assertEquals(true, empty($res));
        $res = $mt->db()->fetch_contents(['current_timestamp_end' => $date1], $ct3->id);
        $this->assertEquals(true, empty($res));
    }

    public function testFetchContentFields() {

        $site = Mockdata::makeBlog(['name' => 'testFetchContentFields']);
        $mt = MT::get_instance();
        $ctx = $this->get_blog_context($site);

        $ct1 = Mockdata::makeContentType();
        $cf1 = MockData::makeContentField(['type' => 'single_line_text']);
        $ct2 = Mockdata::makeContentType();
        $cf2 = MockData::makeContentField(['type' => 'single_line_text']);

        $res = $mt->db()->fetch_content_fields(['unique_id' => $cf1->unique_id]);
        $this->assertEquals(1, count($res));
        $this->assertEquals('ContentField', get_class($res[0]));
        $this->assertEquals($cf1->id, $res[0]->id);

        $res = $mt->db()->fetch_content_fields(['content_type_id' => $ct1->id]);
        $this->assertEquals(1, count($res));
        $this->assertEquals('ContentField', get_class($res[0]));
        $this->assertEquals($cf1->id, $res[0]->id);

        $res = $mt->db()->fetch_content_fields(['content_type_id' => [$ct1->id, $ct2->id]]);
        $this->assertEquals(2, count($res));
        $this->assertEquals('ContentField', get_class($res[0]));
        $this->assertEquals($cf1->id, $res[0]->id);
    }

    public function testFetchContentTags() {

        $site = Mockdata::makeBlog(['name' => 'testFetchContentTags']);
        $mt = MT::get_instance();
        $ctx = $this->get_blog_context($site);

        $author = MockData::makeAuthor(['basename' => 'joe']);
        $ct = Mockdata::makeContentType();
        $cd = Mockdata::makeContentData();
        $tag1 = MockData::makeTag(['name' => 'foo']);
        $tag2 = MockData::makeTag(['name' => 'bar']);
        $otag = Mockdata::makeObjectTag(['object_datasource' => 'content_data', 'tag_id' => $tag1->id]);
        $otag = Mockdata::makeObjectTag(['object_datasource' => 'content_data', 'tag_id' => $tag2->id]);

        $tags = $mt->db()->fetch_content_tags([]);
        $this->assertEquals(2, count($tags));
        $this->assertEquals('Tag', get_class($tags[0]));

        $tags = $mt->db()->fetch_content_tags(['tags' => 'foo,bar']);
        $this->assertEquals(2, count($tags));
        $this->assertEquals('Tag', get_class($tags[0]));

        $tags = $mt->db()->fetch_content_tags(['content_type_id' => $ct->id]);
        $this->assertEquals(2, count($tags));
        $this->assertEquals('Tag', get_class($tags[0]));

        $tags = $mt->db()->fetch_content_tags(['content_type_id' => [$ct->id]]);
        $this->assertEquals(2, count($tags));
        $this->assertEquals('Tag', get_class($tags[0]));

        $tags = $mt->db()->fetch_content_tags(['cd_id' => $cd->id]);
        $this->assertEquals(2, count($tags));
        $this->assertEquals('Tag', get_class($tags[0]));
    }

    public function testFetchNextPrevContent() {

        $site = Mockdata::makeBlog(['name' => 'testFetchNextPrevContent']);
        $mt = MT::get_instance();
        $ctx = $this->get_blog_context($site);

        $author = MockData::makeAuthor(['basename' => 'joe']);
        $ct = Mockdata::makeContentType();
        $cd1 = Mockdata::makeContentData();
        $cd2 = Mockdata::makeContentData();
        $cd3 = Mockdata::makeContentData();

        $ctx->stash('content', $cd2);

        $cd = $mt->db()->fetch_next_prev_content('next', []);
        $this->assertEquals('ContentData', get_class($cd));
        $this->assertEquals($cd3->id, $cd->id);
        $cd = $mt->db()->fetch_next_prev_content('previous', []);
        $this->assertEquals('ContentData', get_class($cd));
        $this->assertEquals($cd1->id, $cd->id);
    }

    public function testFetchRebuildTrigger() {

        $site = Mockdata::makeBlog(['name' => 'testFetchRebuildTrigger']);
        $mt = MT::get_instance();
        $ctx = $this->get_blog_context($site);

        $trigger = Mockdata::makeRebuildTrigger();

        $trigger2 = $mt->db()->fetch_rebuild_trigger($site->id);
        $this->assertEquals('RebuildTrigger', get_class($trigger2));
    }

    public function testFetchPermission() {

        $perm = MT::get_instance()->db()->fetch_permission(['blog_id' => 1, 'id' => 1]);
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

        $perm2_2 = $author->permissions([1, 2]);
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
        $b->set_values(['blog_name' => 'test_name', 'blog_site_url' => 'test_url']);
        $this->assertEquals($b->blog_name, 'test_name');
        $this->assertEquals($b->blog_site_url, 'test_url');
        $b->set_values(['name' => 'test_name2', 'site_url' => 'test_url2']);
        $this->assertEquals($b->name, 'test_name2');
        $this->assertEquals($b->site_url, 'test_url2');
        $array = $b->GetArray();
        $this->assertEquals($array['blog_name'], 'test_name2');
    }

    public function testFetchPermission2() {

        $site = Mockdata::makeBlog(['name' => 'testFetchPermission2']);
        $mt = MT::get_instance();
        $ctx = $this->get_blog_context($site);

        $author = MockData::makeAuthor(['basename' => 'joe']);
        $permission = MockData::makePermission();

        $permissions = $mt->db()->fetch_permission(['blog_id' => $site->id]);
        $this->assertEquals(1, count($permissions));
        $this->assertEquals('Permission', get_class($permissions[0]));
        $this->assertEquals($permission->id, $permissions[0]->id);
    }

    public function testFetchAssociations() {

        $site = Mockdata::makeBlog(['name' => 'testFetchAssociations']);
        $mt = MT::get_instance();
        $ctx = $this->get_blog_context($site);

        $assoc1 = MockData::makeAssociation(['type' => 1]);
        $assoc2 = MockData::makeAssociation(['type' => 2, 'group_id' => 1]);

        $assocs1 = $mt->db()->fetch_associations(['blog_id' => $site->id, 'type' => 1]);
        $this->assertEquals(1, count($assocs1));
        $this->assertEquals('Association', get_class($assocs1[0]));
        $this->assertEquals($assoc1->id, $assocs1[0]->id);
        $assocs2 = $mt->db()->fetch_associations(['blog_id' => $site->id, 'group_id' => [1]]);
        $this->assertEquals(1, count($assocs2));
        $this->assertEquals('Association', get_class($assocs2[0]));
        $this->assertEquals($assoc2->id, $assocs2[0]->id);
    }

    public function testBlogCommentCount() {

        $site = Mockdata::makeBlog(['name' => 'testBlogCommentCount']);
        $mt = MT::get_instance();
        $ctx = $this->get_blog_context($site);

        $entry = MockData::makeEntry(['status' => 2]);
        $comment = MockData::makeComment();
        $comment = MockData::makeComment();

        $count = $mt->db()->blog_comment_count(['blog_id' => $site->id]);
        $this->assertEquals(2, $count);
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

        $cat1 = Mockdata::makeCategory();
        $finfo = Mockdata::makeFileInfo();

        require_once('class.mt_fileinfo.php');
        $finfo2 = new FileInfo();
        $finfo2->Load($finfo->id);
        $cat2 = $finfo2->category();
        $this->assertEquals('Category', get_class($cat2));
        $this->assertEquals($cat1->id, $cat2->id);
    }

    public function testContentLink() {

        $site = Mockdata::makeBlog(['name' => 'testContentLink']);
        $mt = MT::get_instance();
        $ctx = $this->get_blog_context($site);

        $ct1 = Mockdata::makeContentType();
        $cf1 = MockData::makeContentField(['type' => 'single_line_text']);
        $cd1 = Mockdata::makeContentData();
        $map1 = Mockdata::makeTemplateMap(['archive_type' => 'ContentType-Author']);
        $fi1 = Mockdata::makeFileInfo(['archive_type' => 'ContentType-Author', 'templatemap_id' => $map1->id]);

        $url1 = $mt->db()->content_link($cd1->id, 'ContentType-Author', []);
        $this->assertEquals(sprintf('https://example.com#a%06d', $cd1->id), $url1); // TODO: FIXME: domain part needs trailing slash according to perl implementation

        $map2 = Mockdata::makeTemplateMap(['archive_type' => 'ContentType-Category']);
        $cat1 = Mockdata::makeCategory(['label' => 'mylabel']);
        $ocat1 = MockData::makeObjectCategory(['object_ds' => 'content_data', 'category_id' => $cat1->id]);
        $fi2 = Mockdata::makeFileInfo(['archive_type' => 'ContentType-Category', 'templatemap_id' => $map2->id]);

        $url2 = $mt->db()->content_link($cd1->id, 'ContentType-Category', []);
        $this->assertEquals(sprintf('https://example.com#a%06d', $cd1->id), $url2); // TODO: FIXME: domain part needs trailing slash according to perl implementation
    }

    public function testFunctionMtblogsitepath() {

        $mt = MT::get_instance();
        $ctx = $mt->context();
        $blog = new Blog;
        $blog->Load(1);

        require_once('function.mtblogsitepath.php');
        $this->assertEquals('/', smarty_function_mtblogsitepath(['id' => $blog->id], $ctx));
    }

    public function testFunctionMtwebsitesitepath() {

        $mt = MT::get_instance();
        $ctx = $mt->context();
        $blog = new Blog;
        $blog->Load(1);

        require_once('function.mtwebsitepath.php');
        $this->assertEquals('/', smarty_function_mtwebsitepath(['id' => $blog->id], $ctx));
    }

    public function testFunctionMtwebsiterelativeurl() {

        $mt = MT::get_instance();
        $ctx = $mt->context();
        $blog = new Blog;
        $blog->Load(1);

        require_once('function.mtwebsiterelativeurl.php');
        $this->assertEquals('', smarty_function_mtwebsiterelativeurl(['id' => $blog->id], $ctx));
    }

    public function testFunctionMtwebsiteurl() {

        $mt = MT::get_instance();
        $ctx = $mt->context();
        $blog = new Blog;
        $blog->Load(1);

        require_once('function.mtwebsiteurl.php');
        $this->assertEquals('/', smarty_function_mtwebsiteurl(['id' => $blog->id], $ctx));
    }

    private function get_blog_context($blog) {

        $mt = MT::get_instance();
        $ctx = $mt->context();
        $ctx->stash('blog', $blog);
        $ctx->stash('blog_id', $blog->id);
        $ctx->stash('local_blog_id', $blog->id);
        return $ctx;
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
    public function get_name() {
        return '';
    }
    public function get_classname() {
        return '';
    }
    public function form_fields($blog_id) {
        return '';
    }
}
