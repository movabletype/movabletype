<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

interface ContentFieldType {
    public function get_label($args = null);
    public function get_data_type($args = null);
    public function get_field_value($value, &$ctx, &$args);
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
        'tables'           => 'TablesRegistry'
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

class ContentTypeRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Content Type';
    }
    public function get_data_type($args = null) {
        return 'integer';
    }
    public function get_field_value($value, &$ctx, &$args) {
        $content = $ctx->stash('content');
        return $content
            ? $content->label || $ctx->mt->translate( 'No Label (ID:[_1])', $content->id )
            : '';
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
        return $args['words']
            ? first_n_text($value, $args['words'])
            : $value;
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

            require_once("MTUtil.php");
            $value = apply_text_filter($ctx, $value, $filters);
        }

        if (isset($args['words'])) {
            require_once("MTUtil.php");
            $value = first_n_text($value, $args['words']);
        }

        return $value;
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
}

class DateOnlyRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Date';
    }
    public function get_data_type($args = null) {
        return 'date';
    }
    public function get_field_value($value, &$ctx, &$args) {
        $args['ts'] = $value;
        if (!preg_grep('/^(ts|convert_breaks|words|\@)$/', array_keys($args), PREG_GREP_INVERT)) {
            $args['format'] = '%x';
        }
        return $ctx->_hdlr_date($args, $ctx);
    }
}

class TimeOnlyRegistry implements ContentFieldType {
    public function get_label($args = null) {
        return 'Time';
    }
    public function get_data_type($args = null) {
        return 'time';
    }
    public function get_field_value($value, &$ctx, &$args) {
        $args['ts'] = $value;
        if (!preg_grep('/^(ts|convert_breaks|words|\@)$/', array_keys($args), PREG_GREP_INVERT)) {
            $args['format'] = '%X';
        }
        return $ctx->_hdlr_date($args, $ctx);
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
}

?>
