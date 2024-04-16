<?php

class Mockdata {

    private static $last_blog_id;
    private static $last_entry_id;
    private static $last_asset_id;
    private static $last_trackback_id;
    private static $last_content_data;
    private static $last_category_id;

    public static function makeBlog($args=[]) {

        require_once('class.mt_blog.php');
        $blog = new Blog();
        $blog->name = $args['name'];
        $blog->save();
        self::$last_blog_id = $blog->id;
        return $blog;
    }

    public static function makeEntry($args=[]) {

        require_once('class.mt_entry.php');
        $entry = new Entry();
        $entry->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $entry->category_category_set_id = 1;
        $entry->author_id = 1;
        $entry->current_revision = 1;
        $entry->status = $args['status'] ?? 1;
        $entry->template_id = '1';
        $entry->save();
        self::$last_entry_id = $entry->id;
        return $entry;
    }

    public static function makePage($args=[]) {

        require_once('class.mt_page.php');
        $page = new Page();
        $page->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $page->category_category_set_id = 1;
        $page->author_id = 1;
        $page->current_revision = 1;
        $page->status = '3';
        $page->template_id = '1';
        $page->save();
        return $page;
    }

    public static function makeAsset($args=[]) {

        require_once('class.mt_asset.php');
        $asset = new Asset();
        $asset->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $asset->class = 'image';
        $asset->save();

        self::$last_asset_id = $asset->id;

        return $asset;
    }

    public static function makeCategory($args=[]) {

        require_once('class.mt_category.php');
        $category = new Category();
        $category->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $category->class = 'category';
        $category->category_category_set_id = 0;
        $category->label = '';
        $category->save();

        self::$last_category_id = $category->id;

        return $category;
    }

    public static function makeTrackback($args=[]) {

        require_once('class.mt_trackback.php');
        $trackback = new Trackback();
        $trackback->entry_id = $args['entry_id'] ?? self::$last_entry_id;
        $trackback->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $trackback->last_moved_on = '2000-01-01 00:00:00';
        $trackback->category_id = $args['category_id'] ?? self::$last_category_id;
        $trackback->save();

        self::$last_trackback_id = $trackback->id;

        return $trackback;
    }


    public static function makeTbping($args=[]) {

        $entry_id = $args['entry_id'] ?? self::$last_entry_id;
        require_once('class.mt_tbping.php');
        $ping = new TBPing();
        $ping->entry_id = $entry_id;
        $ping->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $ping->last_moved_on = '2000-01-01 00:00:00';
        $ping->ip = '127.0.0.1';
        $ping->junk_status = 1;
        $ping->tb_id = $args['trackback_id'] ?? self::$last_trackback_id;
        $ping->visible = 1;
        $ping->save();

        $entry = new Entry();
        $entry->Load($entry_id);
        $entry->ping_count++;
        $entry->save();

        return $ping;
    }

    public static function makeObjectScore($args=[]) {

        require_once('class.mt_objectscore.php');
        $oscore = new ObjectScore();
        $oscore->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $oscore->object_ds = $args['object_ds'];
        $oscore->object_id = $args['object_id'];
        if (!isset($oscore->object_id)) {
            if ($args['object_ds'] === 'entry') {
                $oscore->object_id = self::$last_entry_id;
            } else if ($args['object_ds'] === 'content_data') {
                $oscore->object_id = self::$last_content_data;
            }
        }
        $oscore->namespace = 'foo';
        $oscore->save();
        return $oscore;
    }

    public static function makeTemplate($args=[]) {

        require_once('class.mt_template.php');
        $template = new Template();
        $template->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $template->name = $args['name'];
        $template->type = $args['type'];
        $template->current_revision = 1;
        $template->save();
        return $template;
    }

    public static function makeTag($args=[]) {

        require_once('class.mt_tag.php');
        $tag = new Tag();
        $tag->tag_name = $args['name'];
        $tag->save();
        return $tag;
    }

    public static function makeComment($args=[]) {

        $entry_id = $args['entry_id'] ?? self::$last_entry_id;
        require_once('class.mt_comment.php');
        $comment = new Comment();
        $comment->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $comment->entry_id = $entry_id;
        $comment->last_moved_on = '2000-01-01 00:00:00';
        $comment->save();

        $entry = new Entry();
        $entry->Load($entry_id);
        $entry->comment_count++;
        $entry->save();

        return $comment;
    }

    public static function makeObjectAsset($args=[]) {

        require_once('class.mt_objectasset.php');
        $oasset = new ObjectAsset();
        $oasset->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $oasset->asset_id = $asset_id ?? self::$last_asset_id ??  1;
        $oasset->cf_id = 0;
        $oasset->object_ds = $args['object_ds'];
        $oasset->object_id = $args['object_id'];
        if (!isset($oasset->object_id)) {
            if ($args['object_ds'] === 'entry') {
                $oasset->object_id = self::$last_entry_id;
            } else if ($args['object_ds'] === 'content_data') {
                $oasset->object_id = self::$last_content_data;
            }
        }
        $oasset->save();
        return $oasset;
    }

    public static function makeObjectTag($args=[]) {

        require_once('class.mt_objecttag.php');
        $otag = new ObjectTag();
        $otag->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $otag->object_datasource = $args['object_datasource'];
        $otag->object_id = $args['object_id'];
        if (!isset($otag->object_id)) {
            if ($args['object_datasource'] === 'entry') {
                $otag->object_id = self::$last_entry_id;
            } else if ($args['object_datasource'] === 'content_data') {
                $otag->object_id = self::$last_content_data;
            }
        }
        $otag->cf_id = 0;
        $otag->tag_id = $args['tag_id'];
        $otag->save();
        return $otag;
    }

    public static function makeTouch($args=[]) {

        require_once('class.mt_touch.php');
        $touch = new Touch();
        $touch->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $touch->object_type = $args['object_type'];
        $touch->modified_on = $args['modified_on'] ?? '20240101122459';
        $touch->save();
        return $touch;
    }

    public static function makeRebuildTrigger($args=[]) {

        require_once('class.mt_rebuild_trigger.php');
        $trigger = new RebuildTrigger();
        $trigger->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        // $trigger->object_type = $type;
        $trigger->save();
        return $trigger;
    }
}
