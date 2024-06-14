<?php

require_once("class.baseobject.php");

class Mockdata {

    private static $last_blog_id;
    private static $last_entry_id;
    private static $last_asset_id;
    private static $last_trackback_id;
    private static $last_content_data_id;
    private static $last_content_type_id;
    private static $last_content_field_id;
    private static $last_ct_unique_id;
    private static $last_category_id;
    private static $last_category_set_id;
    private static $last_author_id;
    private static $last_template_id;

    public static function makeBlog($args=[]) {

        require_once('class.mt_blog.php');
        $blog = new Blog();
        $blog->name = $args['name'];
        $blog->class = $args['class'] ?? 'blog';
        $blog->days_on_index = $args['days_on_index'] ?? 0;
        $blog->site_url = $args['site_url'] ?? 'https://example.com/';
        $blog->save();
        self::$last_blog_id = $blog->id;
        return $blog;
    }

    public static function makeEntry($args=[]) {

        require_once('class.mt_entry.php');
        $entry = new Entry();
        $entry->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $entry->author_id = $args['author_id'] ?? self::$last_author_id ?? 1;
        $entry->current_revision = 1;
        $entry->status = $args['status'] ?? 1;
        $entry->template_id = '1';
        $entry->basename = $args['basename'] ?? 'MyBasename';
        $entry->comment_count = 0;
        $entry->ping_count = 0;
        $entry->authored_on = date("Y-m-d h:i:s");
        $entry->created_on = date("Y-m-d h:i:s");
        $entry->save();
        self::$last_entry_id = $entry->id;
        return $entry;
    }

    public static function makePage($args=[]) {

        require_once('class.mt_page.php');
        $page = new Page();
        $page->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $page->author_id = $args['author_id'] ?? self::$last_author_id ?? 1;
        $page->current_revision = 1;
        $page->status = '3';
        $page->template_id = '1';
        $page->save();
        self::$last_entry_id = $page->id;
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

    public static function makeAuthor($args=[]) {

        require_once('class.mt_author.php');
        $author = new Author();
        $author->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $author->name = $args['name'] ?? $args['basename'] ?? '';
        $author->basename = $args['basename'] ?? '';
        $author->nickname = $args['nickname'] ?? $args['name'] ?? $args['basename'] ?? '';
        $author->locked_out_time = 0;
        $author->password = 'abcdefgh1';
        $author->type = 1;
        $author->status = 2;
        $author->class = 'image';
        $author->save();

        self::$last_author_id = $author->id;

        return $author;
    }

    public static function makeCategory($args=[]) {

        require_once('class.mt_category.php');
        $category = new Category();
        $category->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $category->class = 'category';
        $category->category_category_set_id = self::$last_category_set_id ?? $args['category_set_id'] ?? 0;
        $category->label = $args['label'] ?? '';
        $category->save();

        self::$last_category_id = $category->id;

        return $category;
    }

    public static function makeCategorySet($args=[]) {

        require_once('class.mt_category_set.php');
        $categoryset = new CategorySet();
        $categoryset->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $categoryset->name = 'foo';

        $categoryset->save();

        self::$last_category_set_id = $categoryset->id;

        return $categoryset;
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
        $entry->LoadByIntId($entry_id);
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
            } elseif ($args['object_ds'] === 'content_data') {
                $oscore->object_id = self::$last_content_data_id;
            } elseif ($args['object_ds'] === 'author') {
                $oscore->object_id = self::$last_author_id;
            } elseif ($args['object_ds'] === 'asset') {
                $oscore->object_id = self::$last_asset_id;
            }
        }
        $oscore->author_id = $args['author_id'] ?? self::$last_author_id ?? 1;
        $oscore->namespace = $args['namespace'] ?? 'foo';
        $oscore->save();
        return $oscore;
    }

    public static function makeTemplate($args=[]) {

        require_once('class.mt_template.php');
        $template = new Template();
        $template->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $template->name = $args['name'];
        $template->identifier = $args['identifier'] ?? '';
        $template->type = $args['type'];
        $template->text = $args['text'];
        $template->current_revision = 1;
        $template->content_type_id = $args['content_type_id'] ?? self::$last_content_type_id ?? 1;
        $template->save();
        self::$last_template_id = $template->id;
        return $template;
    }

    public static function makeTemplateMap($args=[]) {

        require_once('class.mt_templatemap.php');
        $map = new TemplateMap();
        $map->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $map->identifier = $args['identifier'];
        $map->archive_type = $args['archive_type'];
        $map->build_interval = $args['build_interval'];
        $map->build_type = $args['build_type'];
        $map->cat_field_id = $args['cat_field_id'];
        $map->dt_field_id = $args['dt_field_id'];
        $map->file_template = $args['file_template'];
        $map->is_preferred = $args['is_preferred'] ?? 1;
        $map->template_id = $args['template_id'] ?? self::$last_template_id;
        $map->save();
        return $map;
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
        $comment->visible = $args['visible'] ?? 1;
        $comment->save();

        $entry = new Entry();
        $entry->LoadByIntId($entry_id);
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
            } elseif ($args['object_ds'] === 'content_data') {
                $oasset->object_id = self::$last_content_data_id;
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
            } elseif ($args['object_datasource'] === 'content_data') {
                $otag->object_id = self::$last_content_data_id;
            } elseif ($args['object_datasource'] === 'asset') {
                $otag->object_id = self::$last_asset_id;
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

    public static function makeContentField($args=[]) {

        require_once('class.mt_content_field.php');
        $cf = new ContentField();
        $cf->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $cf->unique_id = $args['unique_id'] ?? md5(uniqid(rand(), true));
        $cf->content_type_id = $args['content_type_id'] ?? self::$last_content_type_id ?? 1;
        $cf->name = $args['name'] ?? 'foo';
        $cf->type = $args['type'];
        $cf->save();

        self::$last_content_field_id = $cf->id;

        return $cf;
    }

    public static function makeContentFieldIndex($args=[]) {

        $cf_idx = new ContentFieldIndex();
        $cf_idx->content_type_id = $args['content_type_id'] ?? self::$last_content_type_id ?? 1;
        $cf_idx->content_field_id = $args['content_field_id'] ?? self::$last_content_field_id;
        $cf_idx->content_data_id = $args['content_data_id'] ?? self::$last_content_data_id;
        $cf_idx->value_varchar = $args['value_varchar'];
        $cf_idx->value_text = $args['value_text'];
        $cf_idx->value_blob = $args['value_blob'];
        $cf_idx->value_datetime = $args['value_datetime'];
        $cf_idx->value_integer = $args['value_integer'];
        $cf_idx->value_float = $args['value_float'];
        $cf_idx->value_double = $args['value_double'];
        $cf_idx->save();

        return $cf_idx;
    }

    public static function makeContentType($args=[]) {

        require_once('class.mt_content_type.php');
        $ct = new ContentType();
        $ct->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $ct->unique_id = $args['unique_id'] ?? md5(uniqid(rand(), true));
        $ct->name = $args['name'] ?? 'my_ct';
        $ct->save();

        self::$last_content_type_id = $ct->id;
        self::$last_ct_unique_id = $ct->unique_id;

        return $ct;
    }

    public static function makeContentData($args=[]) {

        require_once('class.mt_content_data.php');
        $cd = new ContentData();
        $cd->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $cd->content_type_id = $args['content_type_id'] ?? self::$last_content_type_id ?? 1;
        $cd->author_id = self::$last_author_id ?? 1;
        $cd->status = $args['status'] ?? 2;
        $cd->ct_unique_id = $args['ct_unique_id'] ?? self::$last_ct_unique_id;
        $cd->unique_id = $args['unique_id'] ?? md5(uniqid(rand(), true));
        $cd->current_revision = 1;
        $cd->authored_on = date("Y-m-d h:i:s");
        $cd->save();

        self::$last_content_data_id = $cd->id;

        return $cd;
    }

    public static function makeObjectCategory($args=[]) {

        require_once('class.mt_objectcategory.php');
        $ocat = new ObjectCategory();
        $ocat->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $ocat->object_ds = $args['object_ds'];
        $ocat->object_id = $args['object_id'];
        $ocat->is_primary = 1;
        if (!isset($ocat->object_id)) {
            if ($args['object_ds'] === 'entry') {
                $ocat->object_id = self::$last_entry_id;
            } elseif ($args['object_ds'] === 'content_data') {
                $ocat->object_id = self::$last_content_data_id;
            }
        }
        $ocat->cf_id = $args['content_field_id'] ?? self::$last_content_field_id ?? 0;
        $ocat->category_id = $args['category_id'] ?? self::$last_category_id;
        $ocat->save();
        return $ocat;
    }

    public static function makeObjectPlacement($args=[]) {

        require_once('class.mt_placement.php');
        $placement = new Placement();
        $placement->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $placement->entry_id = $args['entry_id'] ?? self::$last_entry_id;
        $placement->is_primary = $args['is_primary'] ?? 1;
        $placement->category_id = $args['category_id'];
        $placement->save();

        return $placement;
    }

    public static function makePermission($args=[]) {

        require_once('class.mt_permission.php');
        $permission = new Permission();
        $permission->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $permission->author_id = $args['author_id'] ?? self::$last_author_id;
        $permission->permissions = "'administer','edit_templates','manage_plugins','view_log','create_site','sign_in_cms','sign_in_data_api','manage_users_groups','manage_content_types','manage_content_data'";
        $permission->save();

        return $permission;
    }

    public static function makeAssociation($args=[]) {

        require_once('class.mt_association.php');
        $assoc = new Association();
        $assoc->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $assoc->author_id = $args['author_id'] ?? self::$last_author_id;
        $assoc->type = $args['type'] ?? 1;
        $assoc->group_id = $args['group_id'] ?? 0;
        $assoc->role_id = $args['role_id'] ?? 0;
        $assoc->save();

        return $assoc;
    }

    public static function makeFileInfo($args=[]) {

        require_once('class.mt_fileinfo.php');
        $finfo = new FileInfo();
        $finfo->blog_id = $args['blog_id'] ?? self::$last_blog_id ?? 1;
        $finfo->entry_id = $args['entry_id'] ?? self::$last_entry_id ?? 1;
        $finfo->category_id = $args['category_id'] ?? self::$last_category_id;
        $finfo->author_id = $args['author_id'] ?? self::$last_author_id;
        $finfo->archive_type = $args['archive_type'] ?? 'Individual';
        $finfo->template_id = $args['template_id'] ?? self::$last_template_id;
        $finfo->templatemap_id = $args['templatemap_id'];
        $finfo->url = $args['url'];
        $finfo->save();
        return $finfo;
    }
}

/***
 * Mock Class for mt_cf_idx
 */
class ContentFieldIndex extends BaseObject {
    public $_table = 'mt_cf_idx';
    public $_prefix = "cf_idx_";
    public $cf_idx_id;
    public $cf_idx_content_type_id;
    public $cf_idx_content_field_id;
    public $cf_idx_content_data_id;
    public $cf_idx_value_varchar;
    public $cf_idx_value_text;
    public $cf_idx_value_blob;
    public $cf_idx_value_datetime;
    public $cf_idx_value_integer;
    public $cf_idx_value_float;
    public $cf_idx_value_double;
}
