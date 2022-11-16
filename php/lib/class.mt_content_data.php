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
    protected $_prefix = "cd_";
    protected $_has_meta = true;

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
      $where = "content_type_id = " . $this->content_type_id;

      require_once('class.mt_content_type.php');
      $ct = new ContentType();
      $ct->Load($where);
      return $ct;
    }

    private function get_content_field( $unique_id ) {
      $where = "cf_content_type_id = " . $this->content_type_id;
      $where .= " and cf_unique_id = '$unique_id'";

      require_once('class.mt_content_field.php');
      $cf = new ContentField();
      $cf->Load($where);
      return $cf;
    }
}

// Relations
ADODB_Active_Record::ClassHasMany('ContentData', 'mt_cd_meta','cd_meta_cd_id');
?>
