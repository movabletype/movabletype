<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

interface ContentFieldType {
    public function get_label($args = null);
    public function get_data_type($args = null);
    public function get_field_value($value, &$ctx, &$args);
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat);
}

class ContentFieldTypeFactory {
    private static $_content_field_types = array(
        'content_type'     => 'ContentTypeRegistry',
        'single_line_text' => 'SingleLineEditRegistry',
        'multi_line_text'  => 'MultiLineTextRegistry',
        'number'           => 'NumberRegistry',
        'url'              => 'URLRegistry',
        'date_and_time'    => 'DateAndTimeRegistry',
        'date_only'        => 'DateOnlyRegistry',
        'time_only'        => 'TimeOnlyRegistry',
        'select_box'       => 'SelectBoxRegistry',
        'radio_button'     => 'RadioButtonRegistry',
        'checkboxes'       => 'CheckBoxesRegistry',
        'asset'            => 'AssetRegistry',
        'asset_audio'      => 'AssetAudioRegistry',
        'asset_video'      => 'AssetVideoRegistry',
        'asset_image'      => 'AssetImageRegistry',
        'embedded_text'    => 'EmbeddedTextRegistry',
        'categories'       => 'CategoriesRegistry',
        'tags'             => 'TagsRegistry',
        'list'             => 'ListRegistry',
        'tables'           => 'TablesRegistry',
        'text_label'       => 'TextLabelRegistry'
    );
    private static $_types = array();

    private function __construct() { }

    public static function get_type($cf_type) {
        if (empty($cf_type)) {
            require_once('class.exception.php');
            throw new MTException('Illegal content field type');
        }
        if (!array_key_exists($cf_type, ContentFieldTypeFactory::$_content_field_types)) {
            require_once('class.exception.php');
            throw new MTException('Undefined archive type. (' . $cf_type . ')');
        }

        $class = ContentFieldTypeFactory::$_content_field_types[$cf_type];
        if (!empty($class)) {
            $instance = new $class;
            if (!empty($instance) and $instance instanceof ContentFieldType)
                ContentFieldTypeFactory::$_types[$cf_type] = $instance;
        } else {
            ContentFieldTypeFactory::$_types[$cf_type] = null;
        }
        
        return ContentFieldTypeFactory::$_types[$cf_type]; 
    }

    public static function add_type($cf_type, $class) {
        if (empty($cf_type) or empty($class))
            return null;

        ContentFieldTypeFactory::$_content_field_types[$cf_type] = $class;
        return true;
    }
}

class ContentFieldTypeTagHandler {
    public static function _default ($value, &$args, &$res, &$ctx, &$repeat) {
        $ctx->__stash['vars']['__value__'] = $value;
        $ctx->stash('ContentFieldHeader', 1);
        $ctx->stash('ContentFieldFooter', 1);
    }

    public static function multiple ($value, &$args, &$res, &$ctx, &$repeat) {
        if (isset($value)) {
            $values = is_array($value) ? $value : array($value);
        } else {
            $values = array();
        }
        $field_data = $ctx->stash('_content_field_data');
        $option_values = $field_data['options']['values'];
        if (!$option_values) $option_values = array();
        foreach($option_values as $opt_v) {
            $label[$opt_v['value']] = $opt_v['label'];
        }

        $coounter_max = $ctx->stash('_content_field_counter_max');
        if (empty($counter_max)) {
            $counter_max = $ctx->__stash['_content_field_counter_max'] = count($values);
        }
        $counter = $ctx->stash('_content_field_counter');

        $v = $values[$counter];
        $count = $counter + 1;
        $ctx->__stash['vars']['__first__'] = $count == 1;
        $ctx->__stash['vars']['__last__'] = $count == $counter_max;
        $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
        $ctx->__stash['vars']['__counter__'] = $count;
        $ctx->__stash['vars']['__key__'] = $label[$v];
        $ctx->__stash['vars']['__value__'] = $v;
        $ctx->stash('ContentFieldHeader', $count == 1);
        $ctx->stash('ContentFieldFooter', $count == $counter_max);
        if (isset($args['glue'])) $res = $res . $args['glue'];
    }

    public static function asset ($value, &$args, &$res, &$ctx, &$repeat) {
        $values = $ctx->stash('_content_field_values');
        if (empty($values)) {
            $bind_values = is_array($value) ? $value : array($value);
            if (!count($bind_values)) $bind_values = array(0);
            $bind_value_count = count($bind_values);
            $db = $ctx->mt->db()->db();
            if ($bind_value_count > 1) {
                $func = function($key) use(&$db) { return $db->Param($key); };
                $placeholders = implode(",", array_map($func, array_keys($bind_values)));
                $where = "asset_id IN ($placeholders)";
            } else {
                $where = "asset_id = ".$db->Param(0);
            }

            require_once("class.mt_asset.php");
            $asset_class = new Asset;
            $assets = $asset_class->Find($where, $bind_values);

            $map = array();
            foreach($assets as $asset) {
                $map[$asset->id] = $asset;
            }
            $values = array();
            foreach($bind_values as $v) {
                if (!empty($map[$v])) {
                    array_push($values, $map[$v]);
                }
            }

            $ctx->stash('_assets', $values);
            $ctx->stash('_assets_counter', 0);
            $ctx->stash('_content_field_values', $values);
            $ctx->stash('_content_field_counter_max', count($values));
        }

        $counter = $ctx->stash('_content_field_counter');
        $counter_max = $ctx->stash('_content_field_counter_max');
        $count = $counter + 1;

        $ctx->stash('ContentFieldHeader', $count == 1);
        $ctx->stash('ContentFieldFooter', $count == $counter_max);

        if (!isset($args['sort_by']) && !isset($args['sort_order']))
            $args['sort_order'] = 'none';

        if (!isset($res)) $res = ''; # skip assets initialization

        require_once("block.mtassets.php");
        smarty_block_mtassets($args, $res, $ctx, $repeat);
        if (isset($args['glue'])) $res = $res . $args['glue'];
    }
}

class ContentTypeRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Content Type';
    }
    public function get_data_type($args = null) {
        return 'integer';
    }
    public function get_field_value($value, &$ctx, &$args) {
        $content = $ctx->stash('content');
        if (!$content) return '';
        return $content->label
            ? $content->label
            : $ctx->mt->translate( 'No Label (ID:[_1])', $content->id );
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        $values = $ctx->stash('_content_field_values');
        if (empty($values)) {
            $field_data = $ctx->stash('content_field_data');
            $source = $field_data['options']['source'];
            if (!$source) $source = 0;

            require_once("class.mt_content_type.php");
            $content_type = new ContentType;
            $loaded = $content_type->Load($source);
            if (!$loaded)
                return $ctx->error( $ctx->mt->translate('No Content Type could be found.') );
            $content_data = $ctx->stash('content');
            if (!$content_data)
                return $ctx->error( $ctx->mt->translate("You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?", "mtContentField" ) );

            $ids = is_array($value) ? $value : array($value);
            if (empty($ids)) $ids = array(0);
            $ids_count = count($ids);

            require_once("class.mt_content_data.php");
            $content_data_class = new ContentData;
            $db = $ctx->mt->db()->db();
            if ($ids_count > 1) {
                $func = function($key) use(&$db) { return $db->Param($key); };
                $placeholders = implode(",", array_map($func, array_keys($ids)));
                $where = "cd_id IN ($placeholders)";
            } else {
                $where = "cd_id = ".$db->Param(0);
            }
            $cds = $content_data_class->Find($where, $ids);

            $map = array();
            foreach ($cds as $cd) {
                $map[$cd->id] = $cd;
            }
            $values = array();
            foreach ($ids as $id) {
                if (!empty($map[$id])) {
                    $values[] = $map[$id];
                }
            }

            $counter = 0;
            $counter_max = count($values);
            $ctx->stash('_content_field_counter', $counter);
            $ctx->stash('_content_field_values', $values);
            $ctx->stash('_content_field_counter_max', $counter_max);
            $ctx->stash('parent_content', $ctx->stash('content'));
            $ctx->stash('parent_content_type', $ctx->stash('content_type'));
            $ctx->stash('content_type', $content_type);
            $ctx->stash('contents', $values);
            $ctx->stash('_contents_counter', 0);
            $ctx->stash('_contents_limit', count($values));
        }

        $counter = $ctx->stash('_content_field_counter');
        $counter_max = $ctx->stash('_content_field_counter_max');
        $count = $counter + 1;
        $ctx->stash('ContentFieldHeader', $count == 1);
        $ctx->stash('ContentFieldFooter', ($count == $counter_max));

        if (!isset($res)) $res = ''; # skip assets initialization

        require_once("block.mtcontents.php");
        smarty_block_mtcontents($args, $res, $ctx, $repeat);
    }
}

class SingleLineEditRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Single Line Text';
    }
    public function get_data_type($args = null) {
        return 'varchar';
    }
    public function get_field_value($value, &$ctx, &$args) {
        require_once("MTUtil.php");
        return !empty($args['words'])
            ? first_n_text($value, isset($args['words']) ? $args['words'] : null)
            : $value;
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::_default($value, $args, $res, $ctx, $repeat);
    }
}

class MultiLineTextRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Multi Line Text';
    }
    public function get_data_type($args = null) {
        return 'text';
    }
    public function get_field_value($value, &$ctx, &$args) {
        $blog = $ctx->stash('blog');
        $content_data = $ctx->stash('content');
        if (!$content_data) {
            return $ctx->error($ctx->mt->translate(
                "You used an '[_1]' tag outside of the context of a content; Perhaps you mistakenly placed it outside of an 'MTContents' container tag?", "mtContentFieldValue" ));
        }

        $convert_breaks = isset($args['convert_breaks'])
            ? $args['convert_breaks']
            : ($content_data
                ? $content_data->blob_convert_breaks
                : false);
        if (preg_match("/^SERG/", $convert_breaks)) {
            $convert_breaks = $ctx->mt->db()->unserialize($convert_breaks);
        }

        $field_data = $ctx->stash('content_field_data');
        if ($convert_breaks) {
            $filters = is_array($convert_breaks)
                ? $convert_breaks[$field_data['id']]
                : '__default__';

            if ($filters) {
                require_once("MTUtil.php");
                $value = apply_text_filter($ctx, $value, $filters);
            }
        }

        if (isset($args['words'])) {
            require_once("MTUtil.php");
            $value = first_n_text($value, $args['words']);
        }

        return $value;
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::_default($value, $args, $res, $ctx, $repeat);
    }
}

class NumberRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Number';
    }
    public function get_data_type($args = null) {
        return 'double';
    }
    public function get_field_value($value, &$ctx, &$args) {
        return $value;
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::_default($value, $args, $res, $ctx, $repeat);
    }
}

class URLRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'URL';
    }
    public function get_data_type($args = null) {
        return 'text';
    }
    public function get_field_value($value, &$ctx, &$args) {
        return $value;
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::_default($value, $args, $res, $ctx, $repeat);
    }
}

class DateAndTimeRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Date and Time';
    }
    public function get_data_type($args = null) {
        return 'datetime';
    }
    public function get_field_value($value, &$ctx, &$args) {
        $args['ts'] = $value;
        return $ctx->_hdlr_date($args, $ctx);
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::_default($value, $args, $res, $ctx, $repeat);
    }
}

class DateOnlyRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Date';
    }
    public function get_data_type($args = null) {
        return 'datetime';
    }
    public function get_field_value($value, &$ctx, &$args) {
        $args['ts'] = $value;
        if (!preg_grep('/^(ts|convert_breaks|words|\@)$/', array_keys($args), PREG_GREP_INVERT)) {
            $args['format'] = '%x';
        }
        return $ctx->_hdlr_date($args, $ctx);
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::_default($value, $args, $res, $ctx, $repeat);
    }
}

class TimeOnlyRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Time';
    }
    public function get_data_type($args = null) {
        return 'datetime';
    }
    public function get_field_value($value, &$ctx, &$args) {
        $args['ts'] = $value;
        if (!preg_grep('/^(ts|convert_breaks|words|\@)$/', array_keys($args), PREG_GREP_INVERT)) {
            $args['format'] = '%X';
        }
        return $ctx->_hdlr_date($args, $ctx);
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::_default($value, $args, $res, $ctx, $repeat);
    }
}

class SelectBoxRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Select Box';
    }
    public function get_data_type($args = null) {
        return 'varchar';
    }
    public function get_field_value($value, &$ctx, &$args) {
        return $value;
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::multiple($value, $args, $res, $ctx, $repeat);
    }
}

class RadioButtonRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Radio Button';
    }
    public function get_data_type($args = null) {
        return 'varchar';
    }
    public function get_field_value($value, &$ctx, &$args) {
        return $value;
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::multiple($value, $args, $res, $ctx, $repeat);
    }
}

class CheckBoxesRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Checkboxes';
    }
    public function get_data_type($args = null) {
        return 'varchar';
    }
    public function get_field_value($value, &$ctx, &$args) {
        return $value;
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::multiple($value, $args, $res, $ctx, $repeat);
    }
}

class AssetRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Asset';
    }
    public function get_data_type($args = null) {
        return 'integer';
    }
    public function get_field_value($value, &$ctx, &$args) {
        $asset = $ctx->stash('asset');
        return $asset ? $asset->id : '';
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::asset($value, $args, $res, $ctx, $repeat);
    }
}

class AssetAudioRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Audio Asset';
    }
    public function get_data_type($args = null) {
        return 'integer';
    }
    public function get_field_value($value, &$ctx, &$args) {
        $asset = $ctx->stash('asset');
        return $asset ? $asset->id : '';
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::asset($value, $args, $res, $ctx, $repeat);
    }
}

class AssetVideoRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Video Asset';
    }
    public function get_data_type($args = null) {
        return 'integer';
    }
    public function get_field_value($value, &$ctx, &$args) {
        $asset = $ctx->stash('asset');
        return $asset ? $asset->id : '';
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::asset($value, $args, $res, $ctx, $repeat);
    }
}

class AssetImageRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Image Asset';
    }
    public function get_data_type($args = null) {
        return 'integer';
    }
    public function get_field_value($value, &$ctx, &$args) {
        $asset = $ctx->stash('asset');
        return $asset ? $asset->id : '';
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::asset($value, $args, $res, $ctx, $repeat);
    }
}

class EmbeddedTextRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Embedded Text';
    }
    public function get_data_type($args = null) {
        return 'text';
    }
    public function get_field_value($value, &$ctx, &$args) {
        return $value;
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::_default($value, $args, $res, $ctx, $repeat);
    }
}

class CategoriesRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Categories';
    }
    public function get_data_type($args = null) {
        return 'integer';
    }
    public function get_field_value($value, &$ctx, &$args) {
        $category = $ctx->stash('category');
        return $category ? $category->id : '';
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        $values = $ctx->stash('_content_field_values');
        if (empty($values)) {
            $field_data = $ctx->stash('_content_field_data');
            $category_set_id = $field_data['options']['category_set'];
            if (!$category_set_id)
                return $ctx->error( $ctx->mt->translate('No category_set setting in content field type.') );
            $where = "category_category_set_id = $category_set_id";

            require_once("class.mt_category.php");
            $category_class = new Category;

            $extra = array();
            $bind_values = is_array($value) ? $value : array($value);
            if (isset($args['lastn'])) {
                if ($args['lastn'] > 0) {
                    $extra['limit'] = $args['lastn'];
                    if (!isset($args['sort']))
                        $bind_values = array_slice($bind_values, 0, $args['lastn']);
                } else {
                    $bind_values = array();
                }
            }

            if (!count($bind_values)) {
                $bind_values = array(0);
            }
            $bind_value_count = count($bind_values);
            $db = $ctx->mt->db()->db();
            if ($bind_value_count > 1) {
                $func = function($key) use(&$db) { return $db->Param($key); };
                $placeholders = implode(",", array_map($func, array_keys($bind_values)));
                $where = $where . " and category_id IN ($placeholders)";
            } else {
                $where = $where . " and category_id = ".$db->Param(0);
            }
            if (isset($args['sort'])) {
                $sort_by = "category_" . strtolower($args['sort']);
                if ($category_class->has_column($sort_by)) {
                    $tableinfo =& $category_class->TableInfo();
                    if ($tableinfo->flds[$sort_by]->type == "CLOB") {
                        $sort_by = $ctx->mt->db()->decorate_column($sort_by);
                    }
                    $where = $where . " order by $sort_by";
                    if (!empty($args['sort_order']) && $args['sort_order'] == 'descend') {
                        $where = $where . " desc";
                    }
                }
            }

            $categories = $category_class->Find($where, $bind_values, false, $extra);

            $values = array();
            if (isset($args['sort'])) {
                $values = $categories;
            } else {
                $map = array();
                foreach($categories as $cat) {
                    $map[$cat->id] = $cat;
                }
                foreach($bind_values as $v) {
                    if (!empty($map[$v])) {
                        array_push($values, $map[$v]);
                    }
                }
            }

            $category_class->bulk_load_meta($values);

            $ctx->stash('_content_field_values', $values);
            $ctx->stash('_content_field_counter_max', count($values));
        }

        $counter = $ctx->stash('_content_field_counter');
        $counter_max = $ctx->stash('_content_field_counter_max');

        $v = $values[$counter];
        $count = $counter + 1;
        $ctx->stash('category', $v);
        $ctx->stash('blog_id', $v->blog_id);
        $ctx->stash('blog', $v->blog());
        $ctx->__stash['vars']['__first__'] = $count == 1;
        $ctx->__stash['vars']['__last__'] = $count == $counter_max;
        $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
        $ctx->__stash['vars']['__counter__'] = $count;
        $ctx->stash('ContentFieldHeader', $count == 1);
        $ctx->stash('ContentFieldFooter', $count == $counter_max);
        if (isset($args['glue'])) $res = $res . $args['glue'];
    }
}

class TagsRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Tags';
    }
    public function get_data_type($args = null) {
        return 'integer';
    }
    public function get_field_value($value, &$ctx, &$args) {
        $tag = $ctx->stash('Tag');
        return $tag ? $tag->id : '';
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        $is_preview = $ctx->mt->mode() == 'preview_content_data';

        $values = $ctx->stash('_content_field_values');
        if (empty($values)) {
            $column = $is_preview ? $ctx->mt->db()->binary_column("tag_name") : "tag_id";

            $bind_values = is_array($value) ? $value : array($value);
            if (!count($bind_values)) $bind_values = array(0);
            $bind_value_count = count($bind_values);
            $db = $ctx->mt->db()->db();
            if ($bind_value_count > 1) {
                $func = function($key) use(&$db) { return $db->Param($key); };
                $placeholders = implode(",", array_map($func, array_keys($bind_values)));
                $where = "$column IN ($placeholders)";
            } else {
                $where = "$column = ".$db->Param(0);
            }

            require_once("class.mt_tag.php");
            $tag_class = new Tag;
            $tags = $tag_class->Find($where, $bind_values);

            foreach($tags as $tag) {
                $key = $is_preview ? $tag->name : $tag->id;
                $map[$key] = $tag;
            }

            $values = array();
            foreach($bind_values as $v) {
                $tag = isset($map[$v]) ? $map[$v] : null;
                if (!$tag && $is_preview && isset($args['include_private']) && $args['include_private']) {
                    $is_private = preg_match('/^\@/', $v) ? 1 : 0;
                    $tag = new Tag;
                    $tag->name($v);
                    $tag->is_private($is_private);
                }
                if ($tag) array_push($values, $tag);
            }

            $ctx->stash('_content_field_values', $values);
            $ctx->stash('_content_field_counter_max', count($values));
        }

        $counter = $ctx->stash('_content_field_counter');
        $counter_max = $ctx->stash('_content_field_counter_max');

        $v = $values[$counter];
        $count = $counter + 1;
        $ctx->__stash['vars']['__first__'] = $count == 1;
        $ctx->__stash['vars']['__last__'] = $count == $counter_max;
        $ctx->__stash['vars']['__odd__'] = ($count % 2) == 1;
        $ctx->__stash['vars']['__even__'] = ($count % 2) == 0;
        $ctx->__stash['vars']['__counter__'] = $count;
        $ctx->__stash['Tag'] = $v;
        $ctx->__stash['ContentFieldHeader'] = $count == 1;
        $ctx->__stash['ContentFieldFooter'] = $count == $counter_max;
        if (isset($args['glue'])) $res = $res . $args['glue'];
    }
}

class ListRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return '__LIST_FIELD_LABEL';
    }
    public function get_data_type($args = null) {
        return 'varchar';
    }
    public function get_field_value($value, &$ctx, &$args) {
        return $value;
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        $values = is_array($value) ? $value : array($value);

        $counter = $ctx->stash('_content_field_counter');
        $counter_max = $ctx->stash('_content_field_counter_max');
        if (!$counter_max) {
            $counter_max = count($values);
            $ctx->stash('_content_field_counter_max', $counter_max);
        }

        $v = $values[$counter];
        $count = $counter + 1;
        $ctx->__stash['vars']['__first__']   = $count == 1;
        $ctx->__stash['vars']['__last__']    = ($count == count($values));
        $ctx->__stash['vars']['__odd__']     = ($count % 2) == 1;
        $ctx->__stash['vars']['__even__']    = ($count % 2) == 0;
        $ctx->__stash['vars']['__counter__'] = $count;
        $ctx->__stash['vars']['__value__']   = $v;
        $ctx->__stash['ContentFieldHeader']  = $count == 1;
        $ctx->__stash['ContentFieldFooter']  = ($count == count($values));
        if (isset($args['glue'])) $res = $res . $args['glue'];
    }
}

class TablesRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Table';
    }
    public function get_data_type($args = null) {
        return 'text';
    }
    public function get_field_value($value, &$ctx, &$args) {
        return $value;
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        if (!isset($value)) $value = '';
        $table = "<table>\n$value\n</table>";
        $ctx->__stash['vars']['__value__'] = $table;
        $ctx->stash('ContentFieldHeader', 1);
        $ctx->stash('ContentFieldFooter', 1);
    }
}

class TextLabelRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Text Display Area';
    }
    public function get_data_type($args = null) {
        return 'varchar';
    }
    public function get_field_value($value, &$ctx, &$args) {
        return '';
    }
    public function tag_handler($value, $args, &$res, &$ctx, &$repeat) {
        ContentFieldTypeTagHandler::_default($value, $args, $res, $ctx, $repeat);
    }
}

?>
