<?php
require_once("MTUtil.php");
require_once("archive_lib.php");

class DateBasedCategoryArchiver extends DateBasedArchiver {
    // Override method
    function &get_archive_list($ctx, $args) {
        global $mt;
        list($results, $hi, $low) = 
            $this->get_archive_list_data($args);
        if(is_array($results)) {
            $blog_id = $args['blog_id'];
            $range = "'$low' and '$hi'";
            $at = $ctx->stash('current_archive_type');
            $link_cache_sql = "
                select fileinfo_startdate, fileinfo_url, blog_site_url, blog_file_extension
                  from mt_fileinfo, mt_templatemap, mt_blog
                 where fileinfo_startdate between $range
                   and fileinfo_archive_type = '$at'
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
        $blog_id or $blog_id = intval($ctx->stash('blog_id'));
        $cat = $ctx->stash('category');
        $cat_id = $cat['category_id'];
        if (isset($ts)) {
            if ($at == 'Category-Monthly') {
                $ts = substr($ts, 0, 6) . '01000000';
            } elseif ($at == 'Category-Daily') {
                $ts = substr($ts, 0, 8) . '000000';
            } elseif ($at == 'Category-Weekly') {
                require_once("MTUtil.php");
                list($ws, $we) = start_end_week($ts);
                $ts = $ws;
            } elseif ($at == 'Category-Yearly') {
                $ts = substr($ts, 0, 4) . '0101000000';
            }
            $start_filter = "and fileinfo_startdate = '$ts'";
        } else {
            // find a most oldest link when timestamp was not presented
            $order = "order by fileinfo_startdate asc";
        }

        $sql = "select fileinfo_url
                  from mt_fileinfo, mt_templatemap
                 where fileinfo_blog_id = $blog_id
                   and fileinfo_archive_type = '".$ctx->mt->db->escape($at)."'
                   and fileinfo_category_id = '$cat_id'
                   and templatemap_id = fileinfo_templatemap_id
                   and templatemap_is_preferred = 1
                   $start_filter
                 $order";
        return $sql;
    }

    function archive_prev_next($args, $content, &$ctx, &$repeat, $tag) {
        $localvars = array('current_timestamp', 'current_timestamp_end', 'entries');
        if (!isset($content)) {
            $ctx->localize($localvars);
            $is_prev = $tag == 'archiveprevious';
            $ts = $ctx->stash('current_timestamp');
            $category = $ctx->stash('category');
            if (!$ts || !$category) {
                return $ctx->error(
                   "You used an <mt$tag> without a date context set up.");
            }
            $order = $is_prev ? 'previous' : 'next';

            $at = $ctx->stash('current_archive_type');
            if ($at == 'Category-Monthly') {
                $wide = 'MONTHLY';
            } elseif ($at == 'Category-Daily') {
                $wide = 'DAILY';
            } elseif ($at == 'Category-Weekly') {
                $wide = 'WEEKLY';
            } elseif ($at == 'Category-Yearly') {
                $wide = 'YEARLY';
            }

            if ($entry = $this->get_categorized_entry($ts, $ctx->stash('blog_id'), $category['category_id'], $wide, $order)) {
                $helper = $this->get_helper($wide);
                $ctx->stash('entries', array( $entry ));
                list($start, $end) = $helper($entry['entry_authored_on']);
                $ctx->stash('current_timestamp', $start);
                $ctx->stash('current_timestamp_end', $end);
                $ctx->stash('category', $category);
            } else {
                $ctx->restore($localvars);
                $repeat = false;
            }
        } else {
            $ctx->restore($localvars);
        }
        return $content;
    }

    function get_categorized_entry($ts, $blog_id, $cat_id, $at, $order) {
        $helper = $this->get_helper($at);
        list($start, $end) = $helper($ts);
        $args = array();
        if ($order == 'previous') {
            $args['current_timestamp_end'] = $this->dec_ts($start);
        } else {
            $args['current_timestamp'] = $this->inc_ts($end);
            $args['sort_order'] = 'ascend'; # ascending order
        }
        $args['lastn'] = 1;
        $args['blog_id'] = $blog_id;
        $args['category_id'] = $cat_id;
        global $mt;
        list($entry) = $mt->db->fetch_entries($args);
        return $entry;
    }
}

class YearlyCategoryArchiver extends DateBasedCategoryArchiver {
    // Override method
    function get_title($args, $ctx) {
        $cat_name = '';
        $cat = $ctx->stash('archive_category');
        if (!isset($cat)) {
            $cat = $ctx->stash('category');
            if (isset($cat)) {
                $cat_name = $cat['category_label'].": ";
            }
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
        return $cat_name.$ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    function get_range(&$ctx, &$row) {
        if (is_array($row)) {
            return start_end_year($row[0]);
        } else {
            return start_end_year($row);
        }
    }

    function get_archive_name() {
        return 'Category-Yearly';
    }

    function get_archive_list_data($args) {
        global $mt;
        $blog_id = $args['blog_id'];
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = $args['sort_order'] == 'ascend' ? 'asc'
            : $args['sort_order'] == 'descend' ? 'desc'
            : '';
        $year_ext = $mt->db->apply_extract_date('year', 'entry_authored_on');
        $ctx = $mt->context();
        $index = $ctx->stash('index_archive');
        #if (!$index) {
            $cat = $ctx->stash('archive_category');
            $cat or $cat = $ctx->stash('category');
            if (isset($cat)){
                $cat_filter = " and placement_category_id=".$cat['category_id'];
        
            }
        #}
        $sql = "
            select count(*),
                   $year_ext as y,
                   placement_category_id
              from mt_entry join mt_placement on entry_id = placement_entry_id
                   join mt_category on placement_category_id = category_id
             where entry_blog_id = $blog_id
               and entry_status = 2
               and entry_class = 'entry'
               $cat_filter
             group by
                   $year_ext,
                   placement_category_id
             order by
                   $year_ext $order
                   <LIMIT>";
        $group_sql = $mt->db->apply_limit_sql($sql, $args['lastn'], $args['offset']);
        $results = $mt->db->get_results($group_sql, ARRAY_N);
        if (is_array($results)) {
            $hi = sprintf("%04d0000000000", $results[0][1]);
            $low = sprintf("%04d0000000000", $results[count($results)-1][1]);
        }
        return array($results, $hi, $low);
    }

    function prepare_list(&$ctx, &$row) {
        $category_id = $row[2];
        $category = $ctx->mt->db->fetch_category($category_id);
        $ctx->stash('category', $category);
    }
}

class MonthlyCategoryArchiver extends DateBasedCategoryArchiver {
    // Override method
    function get_title($args, $ctx) {
        $cat_name = '';
        $cat = $ctx->stash('archive_category');
        if (!isset($cat)) {
            $cat = $ctx->stash('category');
            if (isset($cat)) {
                $cat_name = $cat['category_label'].": ";
            }
        }
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_month($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%B %Y";
        return $cat_name.$ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    function get_range(&$ctx, &$row) {
        if (is_array($row)) {
            return start_end_month(sprintf('%04d%02d%02d', $row[0], $row[1], "01"));
        } else {
            return start_end_month($row);
        }
    }

    function get_archive_name() {
        return 'Category-Monthly';
    }

    function get_archive_list_data($args) {
        global $mt;
        $blog_id = $args['blog_id'];
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = $args['sort_order'] == 'ascend' ? 'asc'
            : $args['sort_order'] == 'descend' ? 'desc'
            : '';
        $year_ext = $mt->db->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $mt->db->apply_extract_date('month', 'entry_authored_on');
        $ctx = $mt->context();
        $index = $ctx->stash('index_archive');
        #if (!$index) {
            $cat = $ctx->stash('archive_category');
            $cat or $cat = $ctx->stash('category');
            if(isset($cat)) {
                $cat_filter = " and placement_category_id=".$cat['category_id'];
        
            }
        #}
        $sql = "
            select count(*),
                   $year_ext as y,
                   $month_ext as m,
                   placement_category_id
              from mt_entry join mt_placement on entry_id = placement_entry_id
                   join mt_category on placement_category_id = category_id
             where entry_blog_id = $blog_id
               and entry_status = 2
               and entry_class = 'entry'
               $cat_filter
             group by
                   $year_ext,
                   $month_ext,
                   placement_category_id
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
        return array($results, $hi, $low);;
    }

    function prepare_list(&$ctx, &$row) {
        $category_id = $row[3];
        $category = $ctx->mt->db->fetch_category($category_id);
        $ctx->stash('category', $category);
    }
}

class DailyCategoryArchiver extends DateBasedCategoryArchiver {
    // Override method
    function get_title($args, $ctx) {
        $cat_name = '';
        $cat = $ctx->stash('archive_category');
        if (!isset($cat)) {
            $cat = $ctx->stash('category');
            if (isset($cat)) {
                $cat_name = $cat['category_label'].": ";
            }
        }
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_day($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%x";
        return $cat_name.$ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    function get_range(&$ctx, &$row) {
        if (is_array($row)) {
            return start_end_day(sprintf('%04d%02d%02d', $row[0], $row[1], $row[2]));
        } else {
            return start_end_day($row);
        }
    }

    function get_archive_name() {
        return 'Category-Daily';
    }

    function get_archive_list_data($args) {
        global $mt;
        $blog_id = $args['blog_id'];
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = $args['sort_order'] == 'ascend' ? 'asc'
            : $args['sort_order'] == 'descend' ? 'desc'
            : '';
        $year_ext = $mt->db->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $mt->db->apply_extract_date('month', 'entry_authored_on');
        $day_ext = $mt->db->apply_extract_date('day', 'entry_authored_on');
        $ctx = $mt->context();
        $index = $ctx->stash('index_archive');
        #if (!$index) {
            $cat = $ctx->stash('archive_category');
            $cat or $cat = $ctx->stash('category');
            if(isset($cat)) {
                $cat_filter = " and placement_category_id=".$cat['category_id'];
        
            }
        #}
        $sql = "
            select count(*),
                   $year_ext as y,
                   $month_ext as m,
                   $day_ext as d,
                   placement_category_id
              from mt_entry join mt_placement on entry_id = placement_entry_id
                   join mt_category on placement_category_id = category_id
             where entry_blog_id = $blog_id
               and entry_status = 2
               and entry_class = 'entry'
               $cat_filter
             group by
                   placement_category_id,
                   $year_ext,
                   $month_ext,
                   $day_ext
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
        return array($results, $hi, $low);
    }

    function prepare_list(&$ctx, &$row) {
        $category_id = $row[4];
        $category = $ctx->mt->db->fetch_category($category_id);
        $ctx->stash('category', $category);
    }
}

class WeeklyCategoryArchiver extends DateBasedCategoryArchiver {
    // Override method
    function get_title($args, $ctx) {
        $cat_name = '';
        $cat = $ctx->stash('archive_category');
        if (!isset($cat)) {
            $cat = $ctx->stash('category');
            if (isset($cat)) {
                $cat_name = $cat['category_label'].": ";
            }
        }
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start, $end) = start_end_week($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%x";
        return $cat_name
            .$ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx)
            ." - ".$ctx->_hdlr_date(array('ts' => $end, 'format' => $format), $ctx);
    }

    function get_range(&$ctx, &$row) {
        if (is_array($row)) {
            $week_yr = substr($row[0], 0, 4);
            $week_wk = substr($row[0], 4);
            list($y, $m, $d) = week2ymd($week_yr, $week_wk);
            $period_start = sprintf("%04d%02d%02d000000", $y, $m, $d);
        } else {
            $period_start = $row;
        }
        return start_end_week($period_start, $ctx->stash('blog'));
    }

    function get_archive_name() {
        return 'Category-Weekly';
    }

    function get_archive_list_data($args) {
        global $mt;
        $blog_id = $args['blog_id'];
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = $args['sort_order'] == 'ascend' ? 'asc'
            : $args['sort_order'] == 'descend' ? 'desc'
            : '';
        $ctx = $mt->context();
        $index = $ctx->stash('index_archive');
        #if (!$index) {
            $cat = $ctx->stash('archive_category');
            $cat or $cat = $ctx->stash('category');
            if(isset($cat)) {
                $cat_filter = " and placement_category_id=".$cat['category_id'];
        
            }
        #}
        $sql = "
            select count(*),
                   entry_week_number,
                   placement_category_id
              from mt_entry join mt_placement on entry_id = placement_entry_id
                   join mt_category on placement_category_id = category_id
             where entry_blog_id = $blog_id
               and entry_status = 2
               and entry_class = 'entry'
               $cat_filter
             group by
                   entry_week_number,
                   placement_category_id
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
        return array($results, $hi, $low);
    }

    function prepare_list(&$ctx, &$row) {
        $category_id = $row[2];
        $category = $ctx->mt->db->fetch_category($category_id);
        $ctx->stash('category', $category);
    }
}

$archiver = new YearlyCategoryArchiver();
$_archivers[$archiver->get_archive_name()] = $archiver;
$archiver = new MonthlyCategoryArchiver();
$_archivers[$archiver->get_archive_name()] = $archiver;
$archiver = new DailyCategoryArchiver();
$_archivers[$archiver->get_archive_name()] = $archiver;
$archiver = new WeeklyCategoryArchiver();
$_archivers[$archiver->get_archive_name()] = $archiver;
?>
