<?php
require_once("MTUtil.php");
require_once("archive_lib.php");

class AuthorBasedArchiver extends BaseArchiver {
    // Override Method
    function get_label($args, $ctx) {
        return $ctx->mt->translate('Author');
    }
    function get_title($args, $ctx) {
        $author_name = '';
        $author = $ctx->stash('archive_author');
        if (!isset($archive_author)) {
            $author = $ctx->stash('author');
            if (isset($author)) {
                $author_name = $author['author_nickname'];
                $author_name or $author_name =
                    $ctx->mt->translate('Author (#').$author['author_id'].')';
            }
        }
        return $author_name;
    }
    
    function get_archive_name() {
        return 'Author';
    }

    function &get_archive_list($ctx, $args) {
        global $mt;
        list($results, $hi, $low) = $this->get_archive_list_data($args);
        if(is_array($results)) {
            $blog_id = $args['blog_id'];
            if (isset($low) && isset($hi)) {
                $range = "fileinfo_startdate between '$low' and '$hi' and";
            }
            $at = $ctx->stash('current_archive_type');
            $link_cache_sql = "
                select fileinfo_startdate, fileinfo_url, blog_site_url, blog_file_extension
                  from mt_fileinfo, mt_templatemap, mt_blog
                 where  $range
                   fileinfo_archive_type = '$at'
                   and blog_id = $blog_id
                   and fileinfo_blog_id = blog_id
                   and templatemap_id = fileinfo_templatemap_id
                   and templatemap_is_preferred = 1
            ";
            $cache_results = $mt->db->get_results($link_cache_sql, ARRAY_N);
            if (is_array($cache_results)) {
                foreach ($cache_results as $row) {
                    $date = $ctx->mt->db->db2ts($row[0]);
                    $blog_url = $row[2];
                    $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
                    $url = $blog_url . $row[1];
                    $url = _strip_index($url, array('blog_file_extension' => $row[3]));
                    $mt->db->_archive_link_cache[$date.';'.$at] = $url;
                }
            }
        }
        return $results;
    }

    function get_archive_link_sql($ctx, $ts, $at, $args) {
        $blog_id = intval($args['blog_id']);
        $author = $ctx->stash('author');
        $auth_id = $author['author_id'];
        $at or $at = $ctx->stash('current_archive_type');
        $ts = $ctx->stash('current_timestamp');
        if ($at == 'Author-Monthly') {
            $ts = substr($ts, 0, 6) . '01000000';
        } elseif ($at == 'Author-Daily') {
            $ts = substr($ts, 0, 8) . '000000';
        } elseif ($at == 'Author-Weekly') {
            require_once("MTUtil.php");
            list($ws, $we) = start_end_week($ts);
            $ts = $ws;
        } elseif ($at == 'Author-Yearly') {
            $ts = substr($ts, 0, 4) . '0101000000';
        } else {
            $ts = '';
        }

        $sql = "select fileinfo_url
                  from mt_fileinfo, mt_templatemap
                 where " . ($ts ? "fileinfo_startdate = '$ts' and" : "") .
                   " fileinfo_blog_id = $blog_id
                   and fileinfo_archive_type = '".$ctx->mt->db->escape($at)."'
                   and fileinfo_author_id = '$auth_id'
                   and templatemap_id = fileinfo_templatemap_id
                   and templatemap_is_preferred = 1";
        return $sql;
    }

    function archive_prev_next($args, $content, &$ctx, &$repeat, $tag) {
        if ($tag == 'archiveprevious') {
            return $ctx->tag('mtauthorprevious', $args);
        } elseif ($tag == 'archivenext') {
            return $ctx->tag('mtauthornext', $args);
        }
        return $ctx->error("Error in tag: $tag");
    }

    function prepare_list(&$ctx, &$row) {
        $author_id = $row[1];
        $author = $ctx->mt->db->fetch_author($author_id);
        $ctx->stash('author', $author);
    }

    function setup_args($ctx, &$args) {
        if ($auth = $ctx->stash('author')) {
            $args['author'] = $auth['author_name'];
        }
    }

    // Functions
    function get_archive_list_data($args) {
        global $mt;
        $blog_id = $args['blog_id'];
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $sql = "
            select count(*),
                   entry_author_id
              from mt_entry
             where entry_blog_id = $blog_id
               and entry_status = 2
             group by
                   entry_author_id
             order by
                   entry_author_id $order
                   <LIMIT>";
        $group_sql = $mt->db->apply_limit_sql($sql, $args['lastn'], $args['offset']);
        $results = $mt->db->get_results($group_sql, ARRAY_N);
        return array($results, null, null);;
    }

    function template_params(&$ctx) {
        $vars =& $ctx->__stash['vars'];
        $vars['archive_template'] = 1;
        $vars['main_template'] = 1;
        $vars['author_archive'] = 1;
        $vars['archive_class'] = 'author-archive';
    }
}

class DateBasedAuthorArchiver extends DateBasedArchiver {
    function setup_args($ctx, &$args) {
        if ($auth = $ctx->stash('author')) {
            $args['author'] = $auth['author_name'];
        }
    }

    function get_archive_link_sql($ctx, $ts, $at, $args) {
        $blog_id = intval($args['blog_id']);
        $author = $ctx->stash('author');
        $auth_id = $author['author_id'];
        $at or $at = $ctx->stash('current_archive_type');
        $ts = $ctx->stash('current_timestamp');
        if ($at == 'Author-Monthly') {
            $ts = substr($ts, 0, 6) . '01000000';
        } elseif ($at == 'Author-Daily') {
            $ts = substr($ts, 0, 8) . '000000';
        } elseif ($at == 'Author-Weekly') {
            require_once("MTUtil.php");
            list($ws, $we) = start_end_week($ts);
            $ts = $ws;
        } elseif ($at == 'Author-Yearly') {
            $ts = substr($ts, 0, 4) . '0101000000';
        } else {
            $ts = '';
        }

        $sql = "select fileinfo_url
                  from mt_fileinfo, mt_templatemap
                 where " . ($ts ? "fileinfo_startdate = '$ts' and" : "") .
                   " fileinfo_blog_id = $blog_id
                   and fileinfo_archive_type = '".$ctx->mt->db->escape($at)."'
                   and fileinfo_author_id = '$auth_id'
                   and templatemap_id = fileinfo_templatemap_id
                   and templatemap_is_preferred = 1";
        return $sql;
    }

    function &get_archive_list($ctx, $args) {
        global $mt;
        list($results, $hi, $low) = $this->get_archive_list_data($args);
        if(is_array($results)) {
            $blog_id = $args['blog_id'];
            if (isset($low) && isset($hi)) {
                $range = "fileinfo_startdate between '$low' and '$hi' and";
            }
            $at = $ctx->stash('current_archive_type');
            $link_cache_sql = "
                select fileinfo_startdate, fileinfo_url, blog_site_url, blog_file_extension
                  from mt_fileinfo, mt_templatemap, mt_blog
                 where  $range
                   fileinfo_archive_type = '$at'
                   and blog_id = $blog_id
                   and fileinfo_blog_id = blog_id
                   and templatemap_id = fileinfo_templatemap_id
                   and templatemap_is_preferred = 1
            ";
            $cache_results = $mt->db->get_results($link_cache_sql, ARRAY_N);
            if (is_array($cache_results)) {
                foreach ($cache_results as $row) {
                    $date = $ctx->mt->db->db2ts($row[0]);
                    $blog_url = $row[2];
                    $blog_url = preg_replace('!(https?://(?:[^/]+))/.*!', '$1', $blog_url);
                    $url = $blog_url . $row[1];
                    $url = _strip_index($url, array('blog_file_extension' => $row[3]));
                    $mt->db->_archive_link_cache[$date.';'.$at] = $url;
                }
            }
        }
        return $results;
    }

    function archive_prev_next($args, $content, &$ctx, &$repeat, $tag) {
        $localvars = array('current_timestamp', 'current_timestamp_end', 'entries');
        if (!isset($content)) {
            $ctx->localize($localvars);
            $is_prev = $tag == 'archiveprevious';
            $ts = $ctx->stash('current_timestamp');
            $author = $ctx->stash('author');
            if (!$ts || !$author) {
                return $ctx->error(
                   "You used an <mt$tag> without a date context set up.");
            }
            $order = $is_prev ? 'previous' : 'next';

            $at = $ctx->stash('current_archive_type');
            if ($at == 'Author-Monthly') {
                $wide = 'MONTHLY';
            } elseif ($at == 'Author-Daily') {
                $wide = 'DAILY';
            } elseif ($at == 'Author-Weekly') {
                $wide = 'WEEKLY';
            } elseif ($at == 'Author-Yearly') {
                $wide = 'YEARLY';
            }

            if ($entry = $this->get_author_entry($ts, $ctx->stash('blog_id'), $author['author_name'], $wide, $order)) {
                $helper = $this->get_helper($wide);
                $ctx->stash('entries', array( $entry ));
                list($start, $end) = $helper($entry['entry_authored_on']);
                $ctx->stash('current_timestamp', $start);
                $ctx->stash('current_timestamp_end', $end);
                $ctx->stash('author', $author);
            } else {
                $ctx->restore($localvars);
                $repeat = false;
            }
        } else {
            $ctx->restore($localvars);
        }
        return $content;
    }

    function get_author_entry($ts, $blog_id, $auth_name, $at, $order) {
        $helper = $this->get_helper($at);
        list($start, $end) = $helper($ts);
        $args = array();
        if ($order == 'previous') {
            $args['current_timestamp_end'] = $this->dec_ts($start);
        } else {
            $args['current_timestamp'] = $this->inc_ts($end);
            $args['base_sort_order'] = 'ascend'; # ascending order
        }
        $args['lastn'] = 1;
        $args['blog_id'] = $blog_id;
        $args['author'] = $auth_name;
        global $mt;
        list($entry) = $mt->db->fetch_entries($args);
        return $entry;
    }

}

class YearlyAuthorBasedArchiver extends DateBasedAuthorArchiver {

    // Override Method
    function get_label($args, $ctx) {
        return $ctx->mt->translate('Author Yearly');
    }
    function get_title($args, $ctx) {
        $author_name = '';
        $author = $ctx->stash('archive_author');
        if (!isset($author)) {
            $author = $ctx->stash('author');
            $author_name = $author['author_nickname'];
            $author_name or $author_name =
                'Author (#'.$author['author_id'].')';
            $author_name .= ': ';
        }
        $stamp = $ctx->stash('current_timestamp');
        list($start) = start_end_year($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $blog = $ctx->stash('blog');
        global $mt;
        $lang = ($blog && $blog['blog_language'] ? $blog['blog_language'] :
            $mt->config('DefaultLanguage'));
            if (strtolower($lang) == 'jp' || strtolower($lang) == 'ja') {
            $format or $format = "%Y&#24180;";
        } else {
            $format or $format = "%Y";
        }

        return $author_name.$ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }
    
    function get_archive_name() {
        return 'Author-Yearly';
    }

    function get_range(&$ctx, &$row) {
        if (is_array($row)) {
            return start_end_year($row[0]);
        } else {
            return start_end_year($row);
        }
    }

    // Functions
    function get_archive_list_data($args) {
        global $mt;
        $blog_id = $args['blog_id'];
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = $args['sort_order'] == 'ascend' ? 'asc'
            :  $args['sort_order'] == 'descend' ? 'desc'
            : '';
        $year_ext = $mt->db->apply_extract_date('year', 'entry_authored_on');
        $ctx = $mt->context();
        $index = $ctx->stash('index_archive');
        #if (!$index) {
            $author = $ctx->stash('archive_author');
            $author or $author = $ctx->stash('author');
            if (isset($author)) {
                $author_filter = " and entry_author_id=".$author['author_id'];
            }
        #}

        $sql = "
            select count(*),
                   $year_ext as y,
                   entry_author_id
              from mt_entry
                   join mt_author on entry_author_id = author_id
             where entry_blog_id = $blog_id
               and entry_status = 2
               $author_filter
             group by
                   $year_ext,
                   entry_author_id
             order by
                   $year_ext $order
                   <LIMIT>";
        $group_sql = $mt->db->apply_limit_sql($sql, $args['lastn'], $args['offset']);
        $results = $mt->db->get_results($group_sql, ARRAY_N);
        if (is_array($results)) {
            $hi = sprintf("%04d0000000000", $results[0][1]);
            $low = sprintf("%04d0000000000", $results[count($results)-1][1]);
        }
        return array($results, null, null);;
    }

    function prepare_list(&$ctx, &$row) {
        $author_id = $row[2];
        $author = $ctx->mt->db->fetch_author($author_id);
        $ctx->stash('author', $author);
    }

    function template_params(&$ctx) {
        $vars =& $ctx->__stash['vars'];
        $vars['archive_template'] = 1;
        $vars['main_template'] = 1;
        $vars['author_yearly_archive'] = 1;
        $vars['archive_class'] = 'author-yearly-archive';
    }
}

class MonthlyAuthorBasedArchiver extends DateBasedAuthorArchiver {

    // Override Method
    function get_label($args, $ctx) {
        return $ctx->mt->translate('Author Monthly');
    }
    function get_title($args, $ctx) {
        $author_name = '';
        $author = $ctx->stash('archive_author');
        if (!isset($author)) {
            $author = $ctx->stash('author');
            $author_name = $author['author_nickname'];
            $author_name or $author_name =
                'Author (#'.$author['author_id'].')';
            $author_name .= ': ';
        }
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_month($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%B %Y";
        return $author_name.$ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }
    
    function get_archive_name() {
        return 'Author-Monthly';
    }

    function get_range(&$ctx, &$row) {
        if (is_array($row)) {
            return start_end_month(sprintf('%04d%02d%02d', $row[0], $row[1], '01'));
        } else {
            return start_end_month($row);
        }
    }

    // Functions
    function get_archive_list_data($args) {
        global $mt;
        $blog_id = $args['blog_id'];
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = $args['sort_order'] == 'ascend' ? 'asc'
            :  $args['sort_order'] == 'descend' ? 'desc'
            : '';
        $year_ext = $mt->db->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $mt->db->apply_extract_date('month', 'entry_authored_on');
        $ctx = $mt->context(); 
        $index = $ctx->stash('index_archive');

        #if (!$index) {
            $author = $ctx->stash('archive_author');
            $author or $author = $ctx->stash('author');
            if (isset($author)) {
                $author_filter = " and entry_author_id=".$author['author_id'];
            }
        #}
        $ts = $ctx->stash('current_timestamp');
        $tsend = $ctx->stash('current_timestamp_end');
        if ($ts && $tsend) {
            $ts = $mt->db->ts2db($ts);
            $tsend = $mt->db->ts2db($tsend);
            $date_filter = "and (entry_authored_on between '$ts' and '$tsend')";
        }

        $sql = "
            select count(*),
                   $year_ext as y,
                   $month_ext as m,
                   entry_author_id
              from mt_entry
                   join mt_author on entry_author_id = author_id
             where entry_blog_id = $blog_id
               and entry_status = 2
               $date_filter
               $author_filter
             group by
                   $year_ext,
                   $month_ext,
                   entry_author_id
             order by
                   $year_ext $order,
                   $month_ext $order
                   <LIMIT>";
        $group_sql = $mt->db->apply_limit_sql($sql, $args['lastn'], $args['offset']);
        $results = $mt->db->get_results($group_sql, ARRAY_N);
        if (is_array($results)) {
            $hi = sprintf("%04d%02d00000000", $results[0][1], $results[0][2]);
            $low = sprintf("%04d%02d00000000", $results[count($results)-1][1], $results[count($results)-1][2]);
        }
        return array($results, null, null);;
    }

    function prepare_list(&$ctx, &$row) {
        $author_id = $row[3];
        $author = $ctx->mt->db->fetch_author($author_id);
        $ctx->stash('author', $author);
    }

    function template_params(&$ctx) {
        $vars =& $ctx->__stash['vars'];
        $vars['archive_template'] = 1;
        $vars['main_template'] = 1;
        $vars['author_monthly_archive'] = 1;
        $vars['archive_class'] = 'author-monthly-archive';
    }
}

class DailyAuthorBasedArchiver extends DateBasedAuthorArchiver {

    // Override Method
    function get_label($args, $ctx) {
        return $ctx->mt->translate('Author Daily');
    }
    function get_title($args, $ctx) {
        $author_name = '';
        $author = $ctx->stash('archive_author');
        if (!isset($author)) {
            $author = $ctx->stash('author');
            $author_name = $author['author_nickname'];
            $author_name or $author_name =
                'Author (#'.$author['author_id'].')';
            $author_name .= ': ';
        }
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_day($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%x";
        return $author_name.$ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }
    
    function get_archive_name() {
        return 'Author-Daily';
    }

    function get_range(&$ctx, &$row) {
        if (is_array($row)) {
            $d = sprintf("%04d%02d%02d000000", $row[0], $row[1], $row[2]);
            return start_end_day($d);
        } else {
            return start_end_day($row);
        }
    }

    // Functions
    function get_archive_list_data($args) {
        global $mt;
        $blog_id = $args['blog_id'];
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = $args['sort_order'] == 'ascend' ? 'asc'
            :  $args['sort_order'] == 'descend' ? 'desc'
            : '';
        $year_ext = $mt->db->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $mt->db->apply_extract_date('month', 'entry_authored_on');
        $day_ext = $mt->db->apply_extract_date('day', 'entry_authored_on');
        $ctx = $mt->context();
        $index = $ctx->stash('index_archive');
        #if (!$index) {
            $author = $ctx->stash('archive_author');
            $author or $author = $ctx->stash('author');
            if (isset($author)) {
                $author_filter = " and entry_author_id=".$author['author_id'];
            }
        #}
        $ts = $ctx->stash('current_timestamp');
        $tsend = $ctx->stash('current_timestamp_end');
        if ($ts && $tsend) {
            $ts = $mt->db->ts2db($ts);
            $tsend = $mt->db->ts2db($tsend);
            $date_filter = "and (entry_authored_on between '$ts' and '$tsend')";
        }

        $sql = "
            select count(*),
                   $year_ext as y,
                   $month_ext as m,
                   $day_ext as d,
                   entry_author_id
              from mt_entry
                   join mt_author on entry_author_id = author_id
             where entry_blog_id = $blog_id
               and entry_status = 2
               $date_filter
               $author_filter
             group by
                   $year_ext,
                   $month_ext,
                   $day_ext,
                   entry_author_id
             order by
                   $year_ext $order,
                   $month_ext $order,
                   $day_ext $order
                   <LIMIT>";
        $group_sql = $mt->db->apply_limit_sql($sql, $args['lastn'], $args['offset']);
        $results = $mt->db->get_results($group_sql, ARRAY_N);
        if (is_array($results)) {
            $hi = sprintf("%04d%02d%02d000000", $results[0][1], $results[0][2], $results[0][3]);
            $low = sprintf("%04d%02d%02d000000", $results[count($results)-1][1], $results[count($results)-1][2], $results[count($results)-1][3]);
        }
        return array($results, null, null);;
    }

    function prepare_list(&$ctx, &$row) {
        $author_id = $row[4];
        $author = $ctx->mt->db->fetch_author($author_id);
        $ctx->stash('author', $author);
    }

    function template_params(&$ctx) {
        $vars =& $ctx->__stash['vars'];
        $vars['archive_template'] = 1;
        $vars['main_template'] = 1;
        $vars['author_daily_archive'] = 1;
        $vars['archive_class'] = 'author-daily-archive';
    }
}

class WeeklyAuthorBasedArchiver extends DateBasedAuthorArchiver {

    // Override Method
    function get_label($args, $ctx) {
        return $ctx->mt->translate('Author Weekly');
    }
    function get_title($args, $ctx) {
        $author_name = '';
        $author = $ctx->stash('archive_author');
        if (!isset($author)) {
            $author = $ctx->stash('author');
            $author_name = $author['author_nickname'];
            $author_name or $author_name =
                'Author (#'.$author['author_id'].')';
            $author_name .= ': ';
        }
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start, $end) = start_end_week($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%x";
        return $author_name
            .$ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx)
            .' - '.$ctx->_hdlr_date(array('ts' => $end, 'format' => $format), $ctx);
    }
    
    function get_archive_name() {
        return 'Author-Weekly';
    }

    function get_range(&$ctx, &$row) {
        if (is_array($row)) {
            $week_yr = substr($row[0], 0, 4);
            $week_wk = substr($row[0], 4);
            list($y, $m, $d) = week2ymd($week_yr, $week_wk);
            return start_end_week(sprintf("%04d%02d%02d000000", $y, $m, $d));
        } else {
            return start_end_week($row);
        }
    }

    // Functions
    function get_archive_list_data($args) {
        global $mt;
        $blog_id = $args['blog_id'];
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = $args['sort_order'] == 'ascend' ? 'asc'
            :  $args['sort_order'] == 'descend' ? 'desc'
            : '';
        $year_ext = $mt->db->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $mt->db->apply_extract_date('month', 'entry_authored_on');
        $day_ext = $mt->db->apply_extract_date('day', 'entry_authored_on');
        $ctx = $mt->context();
        $index = $ctx->stash('index_archive');
        #if (!$index) {
            $author = $ctx->stash('archive_author');
            $author or $author = $ctx->stash('author');
            if (isset($author)) {
                $author_filter = " and entry_author_id=".$author['author_id'];
            }
        #}
        $ts = $ctx->stash('current_timestamp');
        $tsend = $ctx->stash('current_timestamp_end');
        if ($ts && $tsend) {
            $ts = $mt->db->ts2db($ts);
            $tsend = $mt->db->ts2db($tsend);
            $date_filter = "and (entry_authored_on between '$ts' and '$tsend')";
        }

        $sql = "
            select count(*),
                   entry_week_number,
                   entry_author_id
              from mt_entry
                   join mt_author on entry_author_id = author_id
             where entry_blog_id = $blog_id
               and entry_status = 2
               $date_filter
               $author_filter
             group by
                   entry_week_number,
                   entry_author_id
             order by
                   entry_week_number $order
                   <LIMIT>";
        $group_sql = $mt->db->apply_limit_sql($sql, $args['lastn'], $args['offset']);
        $results = $mt->db->get_results($group_sql, ARRAY_N);
        if (is_array($results)) {
            $week_yr = substr($results[0][1], 0, 4);
            $week_num = substr($results[0][1], 4);
            list($y, $m, $d) = week2ymd($week_yr, $week_num);
            $hi = sprintf("%04d%02d%02d000000", $y, $m, $d);
            $week_yr = substr($results[count($result)-1][1], 0, 4);
            $week_num = substr($results[count($result)-1][1], 4);
            list($y, $m, $d) = week2ymd($week_yr, $week_num);
            $low = sprintf("%04d%02d%02d000000", $y, $m, $d);
        }
        return array($results, null, null);;
    }

    function prepare_list(&$ctx, &$row) {
        $author_id = $row[2];
        $author = $ctx->mt->db->fetch_author($author_id);
        $ctx->stash('author', $author);
    }

    function template_params(&$ctx) {
        $vars =& $ctx->__stash['vars'];
        $vars['archive_template'] = 1;
        $vars['main_template'] = 1;
        $vars['author_weekly_archive'] = 1;
        $vars['archive_class'] = 'author-weekly-archive';
    }
}
$archiver = new AuthorBasedArchiver();
$_archivers[$archiver->get_archive_name()] = $archiver;
$archiver = new YearlyAuthorBasedArchiver();
$_archivers[$archiver->get_archive_name()] = $archiver;
$archiver = new MonthlyAuthorBasedArchiver();
$_archivers[$archiver->get_archive_name()] = $archiver;
$archiver = new DailyAuthorBasedArchiver();
$_archivers[$archiver->get_archive_name()] = $archiver;
$archiver = new WeeklyAuthorBasedArchiver();
$_archivers[$archiver->get_archive_name()] = $archiver;

?>
