<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('mtdb.base.php');

class MTDatabasepostgres extends MTDatabase {

    public function unserialize($data) {
        $data = stream_get_contents($data);
        if (substr($data, 0, 4) != 'SERG')
            return $data;
        if (!$this->pdo_enabled)
            $data = pg_unescape_bytea($data);
        return parent::unserialize($data);
    }

    protected function connect($user, $password = '', $dbname = '', $host = '', $port = '', $sock = '') {
        if (extension_loaded('pdo') && extension_loaded('pdo_pgsql')) {
            $prefix = 'pdo_pgsql';
            $this->pdo_enabled = true;
        } else {
            $prefix = 'postgres';
        }

        if (!empty($port))
            $host .= ":$port";

        $dsn = "$prefix://$user:$password@$host/$dbname?persist";
        $this->conn = NewADOConnection($dsn);
        return true;
    }

    function apply_extract_date($part, $column) {
        return "extract('" .strtolower($part) . "' from $column)";
    }

    function limit_by_day_sql($column, $days) {
        return '(' . $column . '+\'' . $days . ' days\' >= current_timestamp)';
    }

    function entries_recently_commented_on_sql($subsql) {
        $sql = "
            select main.* from (
                select distinct on (entry_id)
                    subs.*, comment_created_on
                from ($subsql) as subs
                    inner join mt_comment on comment_entry_id = entry_id and comment_visible = 1
                order by entry_id desc
            ) as main order by comment_created_on desc";

        return $sql;
    }

    function set_names($mt) {
        $conf = $mt->config('sqlsetnames');
        if (isset($conf) && empty($conf))
            return;

        $Charset = array(
            'utf-8' => 'UNICODE',
            'shift_jis' => 'SJIS',
            'euc-jp' => 'EUC_JP');
        $lang = $Charset[strtolower($mt->config('publishcharset'))];
        if ($lang) {
            try {
                $this->Execute("SET NAMES '$lang'");
            } catch (Exception $e) {
            }
        }
    }
}
?>
