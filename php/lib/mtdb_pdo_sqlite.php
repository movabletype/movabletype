<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once("ezsql".DIRECTORY_SEPARATOR."ezsql_pdo_sqlite.php");
require_once("mtdb_sqlite.php");

class MTDatabase_pdo_sqlite extends MTDatabase_sqlite {
    var $vendor = 'pdo_sqlite';
    function MTDatabase_pdo_sqlite($dbuser, $dbpassword, $dbname, $dbhost, $dbport) {
        parent::MTDatabaseBase($dbname);
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

        $this->result = $this->dbh->query($query);
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
        if ( $row = $this->result->fetch(PDO::FETCH_ASSOC) )
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
}
?>
