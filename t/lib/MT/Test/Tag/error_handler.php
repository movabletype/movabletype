<?php

class MT_Error_Handler {

    public $log;

    public function handler($error_no, $error_msg, $error_file, $error_line, $error_context = null) {

        // We can detect and ignore errors from functions with an error control operator (e.g. @include_once) by 
        // seeing if the error_reporting level is 0 (on php-7.x) or 4437 (on php-8.x).
        $level = error_reporting();
        if ($level === 0 || $level === (E_ERROR | E_CORE_ERROR | E_COMPILE_ERROR | E_USER_ERROR | E_RECOVERABLE_ERROR | E_PARSE)) {
            return true;
        }
    
        if ($error_no & E_NOTICE) {
            return;
        } else if ($error_no & E_USER_ERROR) {
            print($error_msg."\n");
        } else if (!empty($this->log)) {
            $ts = date('Y-m-d H:i:s');
            $error_msg = preg_replace('/\t/', '\\t', $error_msg);
            $line = sprintf(implode("\t", ['timestamp:%s', 'no:%s', 'str:%s', 'file:%s', 'line:%s', 'uri:%s']), 
                $ts, $error_no, $error_msg, $error_file, $error_line, $_SERVER['REQUEST_URI']);
            error_log($line. "\n", 3, $this->log);
        }
    }
}
