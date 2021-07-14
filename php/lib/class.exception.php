<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

/***
 * Base exception class for MT
 */
class MTException extends Exception {

}

/***
 * Exception class about template building
 */
class MTBuildException extends MTException {

}

/***
 * Exception class about database
 */
class MTDBException extends MTException {

    private $last_query = '';

    public function __construct ($message = "", $code = 0, $query = '') {
        $this->last_query = $query;
        parent::__construct($message, $code);
    }
    
    public function __toString() {
        return parent::__toString() . "\n" . "last query: " . $this->last_query;
    }
}

/***
 * Exception class about configuration
 */
class MTConfigException extends MTException {
}

/***
 * Exception class
 */
class MTDeprecatedException extends MTException {

}

/***
 * Exception class about extensions
 */
class MTExtensionNotFoundException extends MTException {
    public function __construct ($module = "", $code = 0) {
        $message = "$module support has not been available. Please install $module support.";
        parent::__construct($message, $code);
    }
}

class MTUnsupportedImageTypeException extends MTException {
    public function __construct ($file = "", $code = 0) {
        $message = "'$file' was not supported.";
        parent::__construct($message, $code);
    }
}

class MTInitException extends MTException {
    protected $is_debug;

    public function __construct ( $e, $debug = false ) {
        $this->is_debug = $debug;
        parent::__construct( $e->getMessage(), intval($e->getCode()));
    }

    public function is_debug () {
        return $this->is_debug;
    }
}


#/***
# * Default exception handler
# */
function default_exception_handler ($e) {

    if ( $e instanceof MTInitException ) {
        header( "HTTP/1.1 503 Service Unavailable" );
        header("Content-type: text/plain");
        echo "503 Service Unavailable\n\n";

        if ( $e->is_debug() ) {
            echo "Error:\n". htmlspecialchars( $e->getMessage() ) ."\n";
            echo "StackTrace:\n".htmlspecialchars( $e->getTraceAsString() ) . "\n";
        }
        exit;
    }

    $msg = "<p><b>Error:</b> ". $e->getMessage() ."<br></p>" .
           "<pre>" . $e->getTraceAsString() . "</pre>";
    trigger_error( $msg );
}
#
#/***
# * Convert runtime error to exception
# */
#function exception_error_handler($errno, $errstr, $errfile, $errline ) {
#    throw new ErrorException($errstr, 0, $errno, $errfile, $errline);
#}
#
#/***
# * Set up default exception handler
# */
@set_exception_handler("default_exception_handler");
#@set_error_handler("exception_error_handler");
?>
