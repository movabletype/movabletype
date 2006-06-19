<?php
# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
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

    function archive_list_sql($args) {
        $blog_id = $args['blog_id'];
        $limitStr = $this->apply_limit_sql('<LIMIT>', $args['lastn'], $args['offset']);
        $at = $args['archive_type'];
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        if ($at == 'Daily') {
            $sql = "
                select count(*),
                       strftime('%Y', entry_created_on),
                       strftime('%m', entry_created_on),
                       strftime('%d', entry_created_on)
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                 group by
                       strftime('%Y', entry_created_on),
                       strftime('%m', entry_created_on),
                       strftime('%d', entry_created_on)
                 order by
                       strftime('%Y', entry_created_on) $order,
                       strftime('%m', entry_created_on) $order,
                       strftime('%d', entry_created_on) $order
                 $limitStr";
        } elseif ($at == 'Monthly') {
            $sql = "
                select count(*),
                       strftime('%Y', entry_created_on),
                       strftime('%m', entry_created_on)
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                 group by
                       strftime('%Y', entry_created_on),
                       strftime('%m', entry_created_on)
                 order by
                       strftime('%Y', entry_created_on) $order,
                       strftime('%m', entry_created_on) $order
                 $limitStr";
        } elseif ($at == 'Yearly') {
            $sql = "
                select count(*),
                       strftime('%Y', entry_created_on)
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                 group by
                       strftime('%Y', entry_created_on)
                 order by
                       strftime('%Y', entry_created_on) $order
                 $limitStr";
        } else {
            return parent::archive_list_sql($at, $args);
        }
        return $sql;
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
            $days . ' days\') >= datetime(\'now\', \'localtime\')';
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
}
?>
