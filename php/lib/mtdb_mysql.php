<?php
# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

require_once("ezsql".DIRECTORY_SEPARATOR."ezsql_mysql.php");
require_once("mtdb_base.php");

class MTDatabase_mysql extends MTDatabaseBase {
    var $vendor = 'mysql';
    function apply_limit_sql($sql, $limit, $offset = 0) {
        $limit = intval($limit);
        $offset = intval($offset);
        $limitStr = '';
        if ($limit == -1) $limit = 0;
        if ($limit || $offset) {
            if (!$limit) $limit = 2147483647;
            $limitStr = 'limit ' . ($offset ? $offset . ',' : '')
                . $limit;
        }
        $sql = preg_replace('/<LIMIT>/', $limitStr, $sql);
        return $sql;
    }
    function limit_by_day_sql($column, $days) {
        return 'date_add(' . $column .', interval ' . 
            $days . ' day) >= now()';
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

        // Perform the query via std mysql_query function..
        $this->result = @mysql_query($query,$this->dbh);
        $this->num_queries++;

        // If there is an error then take note of it..
        if ( mysql_error() )
        {
            $this->print_error();
            return false;
        }
        
        // Take note of column info 
        $i=0;
        while ($i < @mysql_num_fields($this->result))
        {
            $this->col_info[$i] = @mysql_fetch_field($this->result);
            $i++;
        }

        $this->last_result = array();
        $this->num_rows = 0;
     
        // If debug ALL queries
        $this->trace || $this->debug_all ? $this->debug() : null ;

        return true;
    }

    function query_fetch($output=OBJECT) {
        if ( $row = @mysql_fetch_object($this->result) )
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
            @mysql_free_result($this->result);
            unset($this->result);
        }
    }

    function &fetch_entry_tags($args) {
        # load tags
        if (isset($args['entry_id'])) {
            if (!isset($args['tags'])) {
                if (isset($this->_entry_tag_cache[$args['entry_id']]))
                    return $this->_entry_tag_cache[$args['entry_id']];
            }
            $tags =& $this->fetch_tags_by_entry($args);
            if (!isset($args['tags']))
                $this->_entry_tag_cache[$args['entry_id']] = $tags;
            return $tags;
        }
        $blog_filter = $this->include_exclude_blogs($args);
        if ($blog_filter == '' and isset($args['blog_id'])) {
            if (!isset($args['tags'])) {
                if (!isset($args['entry_id'])) {
                    if (isset($this->_blog_tag_cache[$args['blog_id']]))
                        return $this->_blog_tag_cache[$args['blog_id']];
                }
            }
            $blog_filter = ' = '. intval($args['blog_id']);
        }
        if ($blog_filter != '') 
            $blog_filter = 'and objecttag_blog_id ' . $blog_filter;
        if (!isset($args['include_private'])) {
            $private_filter = 'and (tag_is_private = 0 or tag_is_private is null)';
        }
        if (isset($args['tags']) && ($args['tags'] != '')) {
            $tag_list = '';
            require_once("MTUtil.php");
            $tag_array = tag_split($args['tags']);
            foreach ($tag_array as $tag) {
                if ($tag_list != '') $tag_list .= ',';
                $tag_list .= "'" . $this->escape($tag) . "'";
            }
            if ($tag_list != '') {
                $tag_filter = 'and (tag_name in (' . $tag_list . '))';
                $private_filter = '';
            }
        }
        $sort_col = isset($args['sort_by']) ? $args['sort_by'] : 'name';
        $sort_col = "tag_$sort_col";
        if (isset($args['sort_order']) and $args['sort_order'] == 'descend') {
            $order = 'desc';
        } else {
            $order = 'asc';
        }
        $id_order = '';
        if ($sort_col == 'tag_name') {
            $sort_col = 'lower(tag_name)';
        } else {
            $id_order = ', lower(tag_name)';
        }


        $sql = "
            select tag_id, tag_name, count(distinct entry_id) as tag_count
              from mt_tag left join mt_objecttag on objecttag_tag_id = tag_id
                          left join mt_entry on entry_id = objecttag_object_id
             where objecttag_object_datasource='entry'
               and entry_status = 2
                   $blog_filter
                   $tag_filter
                   $entry_filter
                   $private_filter
          group by tag_id, tag_name
          order by $sort_col $order $id_order";
        $tags = $this->get_results($sql, ARRAY_A);
        return $tags;
    }

    function &fetch_tags_by_entry($args) {
        # load tags by entry_id
        if (isset($args['entry_id'])) {
            $entry_filter = 'and B.objecttag_object_id = '.intval($args['entry_id']);
        }
        if (isset($args['blog_id'])) {
            $blog_filter = 'and A.objecttag_blog_id = '.intval($args['blog_id']);
        }

        if (!isset($args['include_private'])) {
            $private_filter = 'and (tag_is_private = 0 or tag_is_private is null)';
        }

        if (isset($args['tags']) && ($args['tags'] != '')) {
            $tag_list = '';
            require_once("MTUtil.php");
            $tag_array = tag_split($args['tags']);
            foreach ($tag_array as $tag) {
                if ($tag_list != '') $tag_list .= ',';
                $tag_list .= "'" . $this->escape($tag) . "'";
            }
            if ($tag_list != '') {
                $tag_filter = 'and (tag_name in (' . $tag_list . '))';
                $private_filter = '';
            }
        }

        $sql = "
            select
                A.objecttag_tag_id tag_id
                , C.tag_name
                , count(A.objecttag_tag_id) as tag_count
                , B.objecttag_object_id
                , A.objecttag_blog_id
            from
                mt_objecttag A
                left join mt_objecttag B on A.objecttag_tag_id = B.objecttag_tag_id $entry_filter $blog_filter
                left join mt_entry D on B.objecttag_object_id = D.entry_id
                ,mt_tag C
            where
                C.tag_id=A.objecttag_tag_id
                and entry_status = 2
                $tag_filter
                $private_filter
            group by
                A.objecttag_blog_id
                , A.objecttag_tag_id
                , B.objecttag_object_id
          order by
                C.tag_name";
        $tags = $this->get_results($sql, ARRAY_A);
        return $tags;
    }

    function &fetch_tag_by_name($tag_name) {
        $tag_name = $this->escape($tag_name);
        $tag = $this->get_row("
            select *
              from mt_tag
             where tag_name = binary '$tag_name'
        ", ARRAY_A);
        $this->_tag_id_cache[$tag['tag_id']] = $tag;
        return $tag;
    }

    function entries_recently_commented_on_sql($subsql) {
      $sql = $subsql;
        $sql = preg_replace("/from mt_entry\s+left/i",
                    ",MAX(comment_created_on) as cco from mt_entry\ninner join mt_comment on comment_entry_id = entry_id and comment_visible = 1\nleft",
                    $sql);
        $sql = preg_replace("/order by(.+)/i",
                    "group by entry_id order by cco desc, \$1 <LIMIT>",
                   $sql);
      return $sql;
    }


}
?>
