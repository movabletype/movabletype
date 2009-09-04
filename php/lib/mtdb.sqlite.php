<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
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

    function escape($str) {
        return str_replace("'","''",str_replace("''","'",stripslashes($str)));
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
