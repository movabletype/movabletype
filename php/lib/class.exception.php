<?php

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

#/***
# * Default exception handler
# */
function default_exception_handler ($e) {
    echo "<b>Error:</b> ". $e->getMessage() ."<br>\n";
    echo "<pre>".$e->getTraceAsString()."</pre>";
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
