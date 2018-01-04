<?php
function &Textile() {
  global $TEXTILE;
  if (!is_object($TEXTILE)) {
    require_once('Textile.php');
    require_once "smartypants.php";
    $TEXTILE = new Textile(array('char_encoding' => 0, 'charset' => 'utf-8'));
  }
  return $TEXTILE;
}

function smarty_modifier_textile_2($text) {
  $textile =& Textile();
  return SmartyPants( $textile->process($text) );
}
?>
