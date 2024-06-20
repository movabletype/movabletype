<?php

use PHPUnit\Framework\TestCase;

require_once('Mockdata.php');

class ClassTest extends TestCase {

    public function testEntry() {

        $category = Mockdata::makeCategory();
        $entry = Mockdata::makeEntry();

        $entry2 = new Entry();
        $entry2->Load($entry->id);
        $this->assertEquals('Entry', get_class($entry2));
        $this->assertEquals($entry->id, $entry2->id);

        $template = $entry2->template();
        $this->assertEquals('Template', get_class($template));
        $this->assertEquals('1', $template->id);

        $comment = Mockdata::makeComment();
        $comments = $entry->comments();
        $this->assertEquals('Comment', get_class($comments[0]));
        $this->assertEquals($comment->id, $comments[0]->id);

        $trackback = MockData::makeTrackback();

        $trackback2 = $entry->trackback();
        $this->assertEquals('Trackback', get_class($trackback2));
        $this->assertEquals($trackback->id, $trackback2->id);

        $ping = MockData::makeTbping(['entry_id' => $entry->id, 'trackback_id' => $trackback->id]);
        $pings = $entry->pings();
        $this->assertEquals('TBPing', get_class($pings[0]));
        $this->assertEquals($ping->id, $pings[0]->id);

        $trackback2 = $ping->trackback();
        $this->assertEquals('Trackback', get_class($trackback2));
        $this->assertEquals($trackback2->id, $trackback->id);

        $category2 = $trackback2->category();
        $this->assertEquals('Category', get_class($category2));
        $this->assertEquals($category->id, $category2->id);
    }

    public function testObjectAsset() {

        $entry = MockData::makeEntry();
        $asset = MockData::makeAsset();
        $oasset = MockData::makeObjectAsset(['object_ds' => 'entry']);

        $oasset2 = new ObjectAsset();
        $oasset2->Load($oasset->id);
        $this->assertEquals('ObjectAsset', get_class($oasset2));
        $this->assertEquals($oasset->id, $oasset2->id);

        $asset2 = $oasset2->asset();
        $this->assertEquals('Asset', get_class($asset2));
        $this->assertEquals($asset->id, $asset2->id);

        $entry2 = $oasset2->related_object();
        $this->assertEquals('Entry', get_class($entry2));
        $this->assertEquals($entry->id, $entry2->id);
    }

    public function testObjectScore() {

        $entry = MockData::makeEntry();
        $oscore = MockData::makeObjectScore(['object_ds' => 'entry']);
        $oscore2 = new ObjectScore();
        $oscore2->Load($oscore->id);
        $this->assertEquals('ObjectScore', get_class($oscore2));
        $this->assertEquals($oscore->id, $oscore2->id);

        $entry2 = $oscore2->related_object();
        $this->assertEquals('Entry', get_class($entry2));
        $this->assertEquals($entry->id, $entry2->id);
    }

    public function testObjectTag() {

        $entry = Mockdata::makeEntry(['status' => 2]);
        $otag = MockData::makeObjectTag(['object_datasource' => 'entry', 'tag_id' => 1]);

        $otag2 = new ObjectTag();
        $otag2->Load($otag->id);
        $this->assertEquals('ObjectTag', get_class($otag2));
        $this->assertEquals($otag->id, $otag2->id);

        $entry2 = $otag2->related_object();
        $this->assertEquals('Entry', get_class($entry2));
        $this->assertEquals($entry->id, $entry2->id);

        $tag = $otag2->tag();
        $this->assertEquals('Tag', get_class($tag));
    }

    public function testPage() {

        $page = MockData::makePage();

        require_once('class.mt_folder.php');
        $folder = new Folder();
        $folder->blog_id = 1;
        $folder->class = 'folder';
        $folder->category_category_set_id = 0;
        $folder->label = '';
        $folder->save();

        $placement = MockData::makeObjectPlacement(['blog_id' => 1, 'category_id' => $folder->id]);

        $folder2 = $page->folder();
        $this->assertEquals('Folder', get_class($folder2));
        $this->assertEquals($folder2->id, $folder->id);
    }

    public function testTemplate() {

        $template = MockData::makeTemplate(['type' => 'index', 'name' => 'mytemplate']);

        $blog = $template->blog();
        $this->assertEquals('Website', get_class($blog));
        $this->assertEquals(1, $blog->id);
    }
}
