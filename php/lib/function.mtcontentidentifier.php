<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
function smarty_function_mtcontentidentifier($args, &$ctx) {
    $cd = $ctx->stash('content');

    $identifier = $cd->identifier;
    if( $identifier === '' ) return '';
    
    if( isset($args['separator']) ){
      $separator = $args['separator'];
      if( $separator === '-' ){
        return preg_replace( '/_/', '-', $identifier );
      } elseif ( $separator === '_' ) {
        return preg_replace( '/-/', '_', $identifier );
      }
    }
    return $identifier;
}
