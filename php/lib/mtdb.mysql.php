<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('mtdb.base.php');

class MTDatabasemysql extends MTDatabase {

    protected function connect($user, $password = '', $dbname = '', $host = '', $port = '', $sock = '') {
        if (extension_loaded('pdo') && extension_loaded('pdo_mysql')) {
            $this->pdo_enabled = true;
            $this->conn = ADONewConnection('pdo');
            if ( !empty($sock) ) {
                // Connection by unix socket
                $dsn = "unix_socket=$sock";
            } else {
                if (!empty($port))
                    $host .= ";port=$port";
                $dsn = "host=$host";
            }
            $dsn = "mysql:$dsn";
            $this->conn->Connect($dsn, $user, $password, $dbname);
        } elseif (extension_loaded('mysqli')) {
            $this->conn = ADONewConnection('mysqli');
            if ( !empty($sock) ) {
                // Connection by unix socket
                $dsn = ":$sock";
            } else {
                $dsn = "$host";
                if (!empty($port))
                    $host .= ":$port";
            }
            $this->conn->Connect($dsn, $user, $password, $dbname);
        } else {
            $this->conn = ADONewConnection('mysql');
            if ( !empty($sock) ) {
                // Connection by unix socket
                $dsn = ":$sock";
            } else {
                if (!empty($port))
                    $host .= ":$port";
                $dsn = "$host";
            }
            $this->conn->Connect($dsn, $user, $password, $dbname);
        }

        return true;
    }

    function limit_by_day_sql($column, $days) {
        return 'date_add(' . $column .', interval ' . 
            $days . ' day) >= current_timestamp';
    }

    function entries_recently_commented_on_sql($subsql) {
        $sql = "
            select distinct
                subs.*, max_comment_created_on
            from
                ($subsql) subs
                inner join (
                    select comment_entry_id, max(comment_created_on) as max_comment_created_on
                    from mt_comment
                    where comment_visible = 1
                    group by comment_entry_id
                ) c on comment_entry_id = entry_id
            order by
                max_comment_created_on desc
        ";
        return $sql;
    }

    function set_names($mt) {
        $conf = $mt->config('sqlsetnames');
        if (isset($conf) && $conf == 0)
            return;

        $ret = $this->Execute('show variables like "character_set_database"');
        $val = $ret->fields[1];
        if (!empty($val) && ($val != 'latin1')) {
            // MySQL 4.1+ and non-latin1(database) == needs SET NAMES call.
            $Charset = array(
                'utf-8' => 'utf8',
                'shift_jis' => 'sjis',
                'euc-jp' => 'ujis');
            $lang = $Charset[strtolower($mt->config('publishcharset'))];
            if ($lang) {
                $this->Execute("SET NAMES '$lang'");
            }
        }
    }
}
?>
