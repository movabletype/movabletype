<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("ezsql".DIRECTORY_SEPARATOR."ezsql_sqlite.php");
require_once("mtdb_base.php");

class MTDatabase_sqlite extends MTDatabaseBase {
    var $vendor = 'sqlite';
    function MTDatabase_sqlite($dbuser, $dbpassword, $dbname, $dbhost, $dbport) {
        parent::MTDatabaseBase($dbname);
    }

    function unserialize($data) {
        $data = stripslashes($data);  #SQLite uses addslashes for binary data
        return parent::unserialize($data);
    }

    function &convert_fieldname($array) {
        $converted = array();
        foreach ($array as $key => $value) {
            list ($t,$c) = explode('.', $key);
            $converted[$c?$c:$t] = $value;
        }
        return $converted;
    }

    function apply_limit_sql($sql, $limit, $offset = 0) {
        $limit = intval($limit);
        $offset = intval($offset);
        $limitStr = '';
        if ($limit == -1) $limit = 0;
        if ($limit)
            $limitStr = 'limit ' . $limit;
        if ($offset) {
            $limitStr .= ' offset ' . $offset;
            if (!$limit)
                $limitStr = 'limit 2147483647' . $limitStr;
        }
        $sql = preg_replace('/<LIMIT>/', $limitStr, $sql);
        return $sql;
    }

    function limit_by_day_sql($column, $days) {
        return 'datetime(' . $column . ', \'+' .
            $days . ' days\') >= date(\'now\', \'localtime\')';
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

        $this->savedqueries[] = $query;

        // Flush cached values..
        $this->flush();

        // Log how the function was called
        $this->func_call = "\$db->query_start(\"$query\")";

        // Keep track of the last query for debug..
        $this->last_query = $query;

        $this->result = @sqlite_query($query,$this->dbh);
        $this->num_queries++;

        // If there is an error then take note of it..
        if ( !$this->result )
        {
            $this->print_error();
            return false;
        }
        
        // =======================================================
        // Take note of column info

        #$i=0;
        #foreach(@sqlite_fetch_field_array($handle) as $name)
        #{
        #   $this->col_info[$i++]->name = $name;
        #}

        $this->last_result = array();
        $this->num_rows = 0;
     
        // If debug ALL queries
        $this->trace || $this->debug_all ? $this->debug() : null ;

        return true;
    }

    function query_fetch($output=OBJECT) {
        if ( $row = sqlite_fetch_array($this->result, SQLITE_ASSOC) )
        {
            $row = (Object) $row;
            $this->num_rows++;

            if ( $output == OBJECT )
            {
                return $row;
            }
            // If the output is an associative array then return row as such..
            elseif ( $output == ARRAY_A )
            {
                return $row ? $this->convert_fieldname(get_object_vars($row)) : null;
            }
            // If the output is an numerical array then return row as such..
            elseif ( $output == ARRAY_N )
            {
                return $row ? array_values(get_object_vars($row)) : null;
            }
        }
        return null;
    }

    function query_finish() {
        if (isset($this->result)) {
            unset($this->result);
        }
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
