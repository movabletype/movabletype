<?php
# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

interface ContentFieldType {
    public function get_data_type($args = null);
}

class ContentFieldTypeFactory {
    private static $_content_field_types = array(
        'content_type'     => 'ContentTypeRegistry',
        'single_line_text' => 'SilgleLineEditRegistry',
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

    public static function add_types($cf_type, $class) {
        if (empty($cf_type) or empty($class))
            return null;

        ContentFieldTypeFactory::$_content_field_types[$cf_type] = $class;
        return true;
    }
}

class ContentTypeRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'integer';
    }
}

class SilgleLineEditRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'varchar';
    }
}

class MultiLineTextRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'text';
    }
}

class NumberRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'double';
    }
}

class URLRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'text';
    }
}

class DateAndTimeRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'datetime';
    }
}

class DateOnlyRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'date';
    }
}

class TimeOnlyRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'time';
    }
}

class SelectBoxRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'varchar';
    }
}

class RadioButtonRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'varchar';
    }
}

class CheckBoxesRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'varchar';
    }
}

class AssetRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'integer';
    }
}

class AssetAudioRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'integer';
    }
}

class AssetVideoRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'integer';
    }
}

class AssetImageRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'integer';
    }
}

class EmbeddedTextRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'text';
    }
}

class CategoriesRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'integer';
    }
}

class TagsRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'integer';
    }
}

class ListRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'varchar';
    }
}

class TablesRegistry implements ContentFieldType {
    public function get_data_type($args = null) {
        return 'text';
    }
}

?>
