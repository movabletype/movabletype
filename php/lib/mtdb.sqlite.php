<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('mtdb.base.php');

class MTDatabasesqlite extends MTDatabase {

    protected function connect($user, $password = '', $dbname = '', $host = '', $port = '', $sock = '') {
        if (extension_loaded('pdo') && extension_loaded('pdo_sqlite')) {
            $prefix = 'pdo_sqlite';
            $this->pdo_enabled = true;
        } else {
            $prefix = 'sqlite';
        }

        $dsn = "$prefix://".urlencode($dbname);
        $this->conn = NewADOConnection($dsn);
        return true;
    }

    function limit_by_day_sql($column, $days) {
        return 'datetime(' . $column . ', \'+' .
            $days . ' days\') >= date(\'now\', \'localtime\')';
    }

    function set_names($mt) {
        return;
    }

    function unserialize($data) {
        $data = stripslashes($data);  #SQLite uses addslashes for binary data
        return parent::unserialize($data);
    }

    function apply_extract_date($part, $column) {
        $lowPart = strtolower($part);
        if ($lowPart == 'year') {
            $part = "'%Y'";
        } elseif ($lowPart == 'month') {
            $part = "'%m'";
        } elseif ($lowPart == 'day') {
            $part = "'%d'";
        } else {
            return null;
        }

        return "strftime($part, $column)";
    }
}
?>
