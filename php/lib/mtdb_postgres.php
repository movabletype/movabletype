<?php
# Movable Type (r) Open Source (C) 2001-2009 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("ezsql".DIRECTORY_SEPARATOR."ezsql_postgres.php");
require_once("mtdb_base.php");

class MTDatabase_postgres extends MTDatabaseBase {
    var $vendor = 'postgres';

    function unserialize($data) {
        $data = pg_unescape_bytea($data);
        return parent::unserialize($data);
    }

    function apply_limit_sql($sql, $limit, $offset = 0) {
        $limit = intval($limit);
        $offset = intval($offset);
        $limitStr = '';
        if ($limit == -1) $limit = 0;
        if ($limit || $offset) {
            if (!$limit) $limit = 'all';
            $limitStr = ($offset ? 'offset ' . $offset : '') . ' limit '
             . $limit;
        }
        $sql = preg_replace('/<LIMIT>/', $limitStr, $sql);
        return $sql;
    }
    function limit_by_day_sql($column, $days) {
        return '(' . $column . '+\'' . $days . ' days\' >= current_date)';
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

    function query_start($query)
    {
        // For reg expressions
        $query = trim($query); 

        // Query was an insert, delete, update, replace
        if ( preg_match("/^(insert|delete|update|replace)\s+/i",$query) )
        {
            return false;
        }

        // Flush cached values..
        $this->flush();

        // Log how the function was called
        $this->func_call = "\$db->query_start(\"$query\")";

        // Keep track of the last query for debug..
        $this->last_query = $query;

        // Perform the query via std pg_query function..
        if (!$this->result = @pg_query($this->dbh,$query)) {
            $this->print_error();
            return false;
        }

        $this->num_queries++;

        // =======================================================
        // Take note of column info

        $i=0;
        while ($i < @pg_num_fields($this->result))
        {
            $this->col_info[$i]->name = pg_field_name($this->result,$i);
            $this->col_info[$i]->type = pg_field_type($this->result,$i);
            $this->col_info[$i]->size = pg_field_size($this->result,$i);
            $i++;
        }

        $this->last_result = array();
        $this->num_rows = 0;

        // If debug ALL queries
        $this->trace || $this->debug_all ? $this->debug() : null ;

        return true;
    }

    function query_fetch($output=OBJECT) {
        if ( $row = @pg_fetch_object($this->result) )
        {
            $this->num_rows++;

            if ( $output == OBJECT )
            {
                return $row;
            }
            // If the output is an associative array then return row as such..
            elseif ( $output == ARRAY_A )
            {
                return $this->convert_fieldname(get_object_vars($row));
            }
            // If the output is an numerical array then return row as such..
            elseif ( $output == ARRAY_N )
            {
                return array_values(get_object_vars($row));
            }
        }
        return null;
    }

    function query_finish() {
        if (isset($this->result)) {
            @pg_free_result($this->result);
            unset($this->result);
        }
    }
    
    function apply_extract_date($part, $column) {
        return "extract('" .strtolower($part) . "' from $column)";
    }

    function &fetch_unexpired_session($ids, $ttl = 0) {
        $result = parent::fetch_unexpired_session($ids, $ttl);
        for ($i = 0; $i < count($result); $i++) {
            $result[$i]['session_data'] = pg_unescape_bytea($result[$i]['session_data']);
        }
        return $result;
    }
}
?>
