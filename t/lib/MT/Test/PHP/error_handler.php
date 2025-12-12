<?php

class MT_Test_Error_Handler {

    public $log;
    public $ignore_php_dynamic_properties_warnings = false;

    public function handler($error_no, $error_msg, $error_file, $error_line, $error_context = null) {

        // We can detect and ignore errors from functions with an error control operator (e.g. @include_once) by
        // seeing if the error_reporting level is 0 (on php-7.x) or 4437 (on php-8.x).
        $level = error_reporting();
        if ($level === 0 || $level === (E_ERROR | E_CORE_ERROR | E_COMPILE_ERROR | E_USER_ERROR | E_RECOVERABLE_ERROR | E_PARSE)) {
            return true;
        }

        if ($error_no & E_NOTICE) {
            return;
        } elseif (!empty($this->log) && !$this->do_ignore($error_msg, $error_file)) {
            $ts = date('Y-m-d H:i:s');
            $error_msg = preg_replace('/\t/', '\\t', $error_msg);
            $line = sprintf(
                implode("\t", ['timestamp:%s', 'no:%s', 'str:%s', 'file:%s', 'line:%s', 'uri:%s']),
                $ts,
                $error_no,
                $error_msg,
                $error_file,
                $error_line,
                $_SERVER['REQUEST_URI']
            );
            error_log($line. "\n", 3, $this->log);
        }
    }

    private function do_ignore($msg, $file) {

        if (preg_match('/Creation of dynamic property Memcache::\$connection is deprecated/', $msg) === 1) {
            return true;
        }
        if (preg_match('/Creation of dynamic property/', $msg) === 1 && preg_match('!php'. DIRECTORY_SEPARATOR .'vendor!', $file) === 1) {
            return true;
        }
        // Obsolete tags
        if (preg_match('/xmlrpcscript|atomscript/i', $msg) === 1) {
            return true;
        }
        // Tags that doesn't support PHP
        if (preg_match('/unknown tag \'mtcustomfieldasset\'/i', $msg) === 1) {
            return true;
        }
        // Third party tags that doesn't support PHP
        if (preg_match('/unknown tag \'mtpagecontents\'/i', $msg) === 1) {
            return true;
        }
        // Common mistake
        if (preg_match('/\Q{{theme_static}}\E/i', $msg) === 1) {
            return true;
        }
        if ($this->ignore_php_dynamic_properties_warnings) {
            if (preg_match('/Dynamic property /', $msg) === 1) {
                return true;
            }
        }
        return false;
    }
}
