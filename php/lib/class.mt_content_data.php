<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("class.baseobject.php");

/***
 * Class for mt_cd
 */
class ContentData extends BaseObject
{
    public $_table = 'mt_cd';
    public $_prefix = "cd_";
    protected $_has_meta = true;

    # content_data fields generated from perl implementation.
    public $cd_id;
    public $cd_author_id;
    public $cd_authored_on;
    public $cd_blog_id;
    public $cd_content_type_id;
    public $cd_created_by;
    public $cd_created_on;
    public $cd_ct_unique_id;
    public $cd_data;
    public $cd_identifier;
    public $cd_label;
    public $cd_modified_by;
    public $cd_modified_on;
    public $cd_random;
    public $cd_status;
    public $cd_unique_id;
    public $cd_unpublished_on;
    public $cd_week_number;
    public $cd_current_revision;

    # content_data meta fields generated from perl implementation.
    public $cd_mt_cd_meta;
    public $cd_blob_convert_breaks;
    public $cd_block_editor_data;
    public $cd_convert_breaks;
    public $cd_revision;

    public $cd___next;
    public $cd___previous;
    public $cd__data;

    public $cd_cf_idx_id;
    public $cd_cf_idx_content_data_id;
    public $cd_cf_idx_content_field_id;
    public $cd_cf_idx_content_type_id;
    public $cd_cf_idx_created_by;
    public $cd_cf_idx_created_on;
    public $cd_cf_idx_modified_by;
    public $cd_cf_idx_modified_on;
    public $cd_cf_idx_value_blob;
    public $cd_cf_idx_value_datetime;
    public $cd_cf_idx_value_double;
    public $cd_cf_idx_value_float;
    public $cd_cf_idx_value_integer;
    public $cd_cf_idx_value_text;
    public $cd_cf_idx_value_varchar;

    // plugins
    public $cd_comment_count;
    public $cd_ping_count;

    public function label() {
        if ( $this->id ){
            $ct = $this->content_type();
            if ( $ct->data_label ) {
                $field = $this->get_content_field( $ct->data_label );
                if( empty( $field ) ) {
                    return $ctx->error("Cannot load content field (UniqueID:'$ct->data_label').");
                }
                $data_array = $this->data();
                return $data_array[ $field->id ];
            } else {
                return $this->label;
            }
        }
        return '';
    }
    public function data() {
        $raw_data = $this->data;
        if ( empty($raw_data) ) return array();
        if ( preg_match( '/^SERG/', $raw_data, $matches ) ) {
          require_once('MTSerialize.php');
          $serializer = MTSerialize::get_instance();
          $this->_data = $serializer->unserialize( $raw_data );
          return $this->_data;
        } else {
          if (function_exists('json_encode')) {
              return json_encode( $raw_data );
          }
        }
        return array();
    }
    public function content_type() {
      require_once('class.mt_content_type.php');
      $ct = new ContentType();
      $ct->LoadByIntId($this->content_type_id);
      return $ct;
    }

    private function get_content_field( $unique_id ) {
        $mtdb = MT::get_instance()->db();
        $where = sprintf(
            'cf_content_type_id = %s and cf_unique_id = %s',
            $mtdb->ph('cf_content_type_id', $bind, $this->content_type_id),
            $mtdb->ph('cf_unique_id', $bind, $unique_id)
        );

        require_once('class.mt_content_field.php');
        $cf = new ContentField();
        $cf->Load($where, $bind);
        return $cf;
      }
}

// Relations
require_once("class.mt_content_data_meta.php");
ADODB_Active_Record::ClassHasMany('ContentData', 'mt_cd_meta','cd_meta_cd_id', 'ContentDataMeta');
?>
