<?php
require_once("MTUtil.php");

// Create default archivers
global $_archivers;

// Date-based archives
register_archiver(new YearlyArchiver());
register_archiver(new MonthlyArchiver());
register_archiver(new WeeklyArchiver());
register_archiver(new DailyArchiver());
register_archiver(new MonthlyArchiver());

// Indivudual archives
register_archiver(new IndividualArchiver());
register_archiver(new PageArchiver());

// Author-based archives
register_archiver(new AuthorBasedArchiver());
register_archiver(new YearlyAuthorBasedArchiver());
register_archiver(new MonthlyAuthorBasedArchiver());
register_archiver(new WeeklyAuthorBasedArchiver());
register_archiver(new DailyAuthorBasedArchiver());

// Date-based category archives
register_archiver(new YearlyCategoryArchiver());
register_archiver(new MonthlyCategoryArchiver());
register_archiver(new DailyCategoryArchiver());
register_archiver(new WeeklyCategoryArchiver());

function register_archiver($archiver) {
    global $_archivers;
    $_archivers[$archiver->get_archive_name()] = $archiver;
}

function _hdlr_archive_prev_next($args, $content, &$ctx, &$repeat, $tag) {
    global $_archivers;
    $at = $args['archive_type'];
    $at or $at = $ctx->stash('current_archive_type');
    if ($at == 'Category') {
        require_once("block.mtcategorynext.php");
        return smarty_block_mtcategorynext($args, $content, $ctx, $repeat);
    }
    $archiver = $_archivers[$at];
    if (!isset($archiver)) {
        $repeat = false;
        return '';
    }
    return $archiver->archive_prev_next($args, $content, $ctx, $repeat, $tag, $at);
}

class BaseArchiver {
    // Abstract Method (needs override)
    function get_label($args, $ctx) { }
    function get_title($args, $ctx) { }
    function get_range(&$ctx, &$row) { }
    function get_archive_name() { }
    function &get_archive_list($ctx, $args) { }
    function get_archive_link_sql($ctx, $ts, $at, $args) { }
    function archive_prev_next($args, $content, &$ctx, &$repeat, $tag) { }
    function prepare_list(&$ctx, &$row) { }
    function setup_args($ctx, &$args) { }
    function template_params(&$ctx) { }
}

class PageArchiver extends BaseArchiver {
    function get_label($args, $ctx) {
        return $ctx->mt->translate("Page");
    }

    function get_archive_name() {
        return 'Page';
    }

    function template_params(&$ctx) {
        $vars =& $ctx->__stash['vars'];
        $vars['main_template'] = 1;
        $vars['archive_template'] = 1;
        $vars['page_template'] = 1;
        $vars['feedback_template'] = 1;
        $vars['page_archive'] = 1;
        $vars['archive_class'] = 'page-archive';
    }
}

class IndividualArchiver extends BaseArchiver {
    // Override Method
    function get_label($args, $ctx) {
        return $ctx->mt->translate("Individual");
    }

    function get_title($args, $ctx) {
        return $ctx->tag('EntryTitle', $args);
    }

    function get_range(&$ctx, &$row) {
        if (is_array($row)) {
            $period_start = $row[1];
        } else {
            $period_start = $row;
        }
        $period_start = preg_replace('/[^0-9]/', '', $period_start);
        return start_end_day($period_start, $ctx->stash('blog'));
    }

    function get_archive_name() {
        return 'Individual';
    }
    
    function &get_archive_list($ctx, $args) {
        return $ctx->mt->db->get_archive_list($args);
    }

    function get_archive_link_sql($ctx, $ts, $at, $args) {
        return '';
    }

    function archive_prev_next($args, $content, &$ctx, &$repeat, $tag) {
        return $ctx->error(
            "You used an <mt$tag> without a date context set up.");
    }

    function prepare_list(&$ctx, &$row) {
        $entry_id = $row[0];
        $entry = $ctx->mt->db->fetch_entry($entry_id);
        $ctx->stash('entry', $entry);
        $ctx->stash('entries', array());
    }

    function template_params(&$ctx) {
        $vars =& $ctx->__stash['vars'];
        $vars['main_template'] = 1;
        $vars['archive_template'] = 1;
        $vars['entry_template'] = 1;
        $vars['feedback_template'] = 1;
        $vars['archive_class'] = 'entry-archive';
    }
}

class DateBasedArchiver extends BaseArchiver {

    // Override Method
    function archive_prev_next($args, $content, &$ctx, &$repeat, $tag, $at) {
        $localvars = array('current_timestamp', 'current_timestamp_end', 'entries');
        if (!isset($content)) {
            $ctx->localize($localvars);
            $is_prev = $tag == 'archiveprevious';
            $ts = $ctx->stash('current_timestamp');
            if (!$ts) {
                return $ctx->error(
                   "You used an <mt$tag> without a date context set up.");
            }
            $order = $is_prev ? 'previous' : 'next';
            $helper = $this->get_helper($at);
            if ($entry = $this->get_entry($ts, $ctx->stash('blog_id'), $at, $order)) {
                $ctx->stash('entries', array( $entry ));
                list($start, $end) = $helper($entry['entry_authored_on']);
                $ctx->stash('current_timestamp', $start);
                $ctx->stash('current_timestamp_end', $end);
            } else {
                $ctx->restore($localvars);
                $repeat = false;
            }
        } else {
            $ctx->restore($localvars);
        }
        return $content;
    }

    // Functions
    function get_helper($at) {
        if (strtoupper($at) == 'YEARLY') {
            return 'start_end_year';
        } elseif (strtoupper($at) == 'MONTHLY') {
            return 'start_end_month';
        } elseif (strtoupper($at) == 'WEEKLY') {
            return 'start_end_week';
        } elseif (strtoupper($at) == 'DAILY') {
            return 'start_end_day';
        } else {
            return null;
        }
    }

    function get_entry($ts, $blog_id, $at, $order) {
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
        global $mt;
        list($entry) = $mt->db->fetch_entries($args);
        return $entry;
    }

    function dec_ts($ts) {
        $y = substr($ts, 0, 4);
        $mo = substr($ts, 4, 2);
        $d = substr($ts, 6, 2);
        $h = substr($ts, 8, 2);
        $m = substr($ts, 10, 2);
        $s = substr($ts, 12, 2);
        $s--;
        if ($s == -1) {
            $s = 59; $m--;
            if ($m == -1) {
                $m = 59; $h--;
                if ($h == -1) {
                    $h = 23; $d--;
                    if ($d == 0) {
                        $mo--;
                        if ($mo == 0) {
                            $mo = 12; $y--;
                        }
                        $d = days_in($mo, $y);
                    }
                }
            }
        }
        return sprintf("%04d%02d%02d%02d%02d%02d", $y, $mo, $d, $h, $m, $s);
    }

    function inc_ts($ts) {
        $y = substr($ts, 0, 4);
        $mo = substr($ts, 4, 2);
        $d = substr($ts, 6, 2);
        $h = substr($ts, 8, 2);
        $m = substr($ts, 10, 2);
        $s = substr($ts, 12, 2);
        $s++;
        if ($s == 60) {
            $s = 0; $m++;
            if ($m == 60) {
                $m = 0; $h++;
                if ($h == 24) {
                    $h = 0; $d++;
                    $days = days_in($mo, $y);
                    if ($d > $days) {
                        $d = 1; $mo++;
                        if ($mo == 13) {
                            $mo = 1; $y++;
                        }
                    }
                }
            }
        }
        return sprintf("%04d%02d%02d%02d%02d%02d", $y, $mo, $d, $h, $m, $s);
    }

    function template_params(&$ctx) {
        $vars =& $ctx->__stash['vars'];
        $vars['datebased_archive'] = 1;
    }
}

class YearlyArchiver extends DateBasedArchiver {

    function YearlyArchiver() { }

    // Override Method
    function get_label($args, $ctx) {
        return $ctx->mt->translate('Yearly');
    }
    function get_archive_name() {
        return 'Yearly';
    }

    function get_title($args, $ctx) {
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
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
        
        return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    function get_range(&$ctx, &$row) {
        if (is_array($row)) {
            $period_start = sprintf("%04d0101000000", $row[0]);
        } else {
            $period_start = $row;
        }
        return start_end_year($period_start, $ctx->stash('blog'));
    }

    function &get_archive_list($ctx, $args) {
        return $ctx->mt->db->get_archive_list($args);
    }
    
    function get_archive_link_sql($ctx, $ts, $at, $args) {
        return '';
    }

    function template_params(&$ctx) {
        parent::template_params($ctx);
        $vars =& $ctx->__stash['vars'];
        $vars['archive_template'] = 1;
        $vars['main_template'] = 1;
        $vars['datebased_only_archive'] = 1;
        $vars['datebased_yearly_archive'] = 1;
        $vars['archive_class'] = 'datebased-yearly-archive';
        $vars['module_yearly_archives'] = 1;
    }
}

class MonthlyArchiver extends DateBasedArchiver {

    function MonthlyArchiver() { }

    // Override Method
    function get_label($args, $ctx) {
        return $ctx->mt->translate('Monthly');
    }
    function get_archive_name() {
        return 'Monthly';
    }

    function get_title($args, $ctx) {
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_month($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%B %Y";
        return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    function get_range(&$ctx, &$row) {
        if (is_array($row)) {
            $period_start = sprintf("%04d%02d01000000", $row[0], $row[1]);
        } else {
            $period_start = $row;
        }
        return start_end_month($period_start, $ctx->stash('blog'));
    }

    function &get_archive_list($ctx, $args) {
        return $ctx->mt->db->get_archive_list($args);
    }
    
    function get_archive_link_sql($ctx, $ts, $at, $args) {
        return '';
    }

    function template_params(&$ctx) {
        parent::template_params($ctx);
        $vars =& $ctx->__stash['vars'];
        $vars['archive_template'] = 1;
        $vars['main_template'] = 1;
        $vars['datebased_only_archive'] = 1;
        $vars['datebased_monthly_archive'] = 1;
        $vars['archive_class'] = 'datebased-monthly-archive';
        $vars['module_monthly_archives'] = 1;
    }
}

class DailyArchiver extends DateBasedArchiver {

    function DailyArchiver() { }

    // Override Method
    function get_label($args, $ctx) {
        return $ctx->mt->translate('Daily');
    }
    function get_archive_name() {
        return 'Daily';
    }

    function get_title($args, $ctx) {
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_day($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%x";
        return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    function get_range(&$ctx, &$row) {
        if (is_array($row)) {
            $period_start = sprintf("%04d%02d%02d000000", $row[0], $row[1], $row[2]);
        } else {
            $period_start = $row;
        }
        return start_end_day($period_start, $ctx->stash('blog'));
    }

    function &get_archive_list($ctx, $args) {
        return $ctx->mt->db->get_archive_list($args);
    }
    
    function get_archive_link_sql($ctx, $ts, $at, $args) {
        return '';
    }

    function template_params(&$ctx) {
        parent::template_params($ctx);
        $vars =& $ctx->__stash['vars'];
        $vars['archive_template'] = 1;
        $vars['main_template'] = 1;
        $vars['datebased_only_archive'] = 1;
        $vars['datebased_daily_archive'] = 1;
        $vars['archive_class'] = 'datebased-daily-archive';
    }
}

class WeeklyArchiver extends DateBasedArchiver {

    function WeeklyArchiver() { }

    // Override Method
    function get_label($args, $ctx) {
        return $ctx->mt->translate('Weekly');
    }
    function get_archive_name() {
        return 'Weekly';
    }

    function get_title($args, $ctx) {
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start, $end) = start_end_week($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%x";
        return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx)
            . ' - ' .
            $ctx->_hdlr_date(array('ts' => $end, 'format' => $format), $ctx);
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

    function &get_archive_list($ctx, $args) {
        return $ctx->mt->db->get_archive_list($args);
    }
    
    function get_archive_link_sql($ctx, $ts, $at, $args) {
        return '';
    }

    function template_params(&$ctx) {
        parent::template_params($ctx);
        $vars =& $ctx->__stash['vars'];
        $vars['archive_template'] = 1;
        $vars['main_template'] = 1;
        $vars['datebased_only_archive'] = 1;
        $vars['datebased_weekly_archive'] = 1;
        $vars['archive_class'] = 'datebased-weekly-archive';
    }
}

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
            require_once('block.mtauthorprevious.php');
            return smarty_block_mtauthorprevious($args, $content, $ctx, $repeat);
        } elseif ($tag == 'archivenext') {
            require_once('block.mtauthornext.php');
            return smarty_block_mtauthornext($args, $content, $ctx, $repeat);
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
        $vars['module_author_archives'] = 1;
        $vars['module_author-monthly_archives'] = 1;
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

    function template_params(&$ctx) {
        parent::template_params($ctx);
        $vars =& $ctx->__stash['vars'];
        $vars['archive_template'] = 1;
        $vars['main_template'] = 1;
        $vars['author_archive'] = 1;
    }

    function get_author_name ($ctx) {
        global $_archivers;
        $curr_at = $ctx->stash('current_archive_type');
        $archiver = $_archivers[$curr_at];
        $auth = $ctx->stash('author');
        $author_name = '';

        if ($ctx->stash('index_archive')
            || !isset($archiver)
            || (isset($archiver) && !isset($auth))
            || !$ctx->stash('inside_archive_list'))
        {
            $author = $ctx->stash('archive_author');
            $author or $author = $ctx->stash('author');
            if (isset($author)) {
                $author_name = $author['author_nickname'];
                $author_name or $author_name =
                    'Author (#'.$author['author_id'].')';
                $author_name .= ': ';
            }
        }
        return $author_name;
    }
}

class YearlyAuthorBasedArchiver extends DateBasedAuthorArchiver {

    // Override Method
    function get_label($args, $ctx) {
        return $ctx->mt->translate('Author Yearly');
    }
    function get_title($args, $ctx) {
        $author_name = parent::get_author_name($ctx);
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
        parent::template_params($ctx);
        $vars =& $ctx->__stash['vars'];
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
        $author_name = parent::get_author_name($ctx);
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
        $inside = $ctx->stash('inside_archive_list');
        if (!isset($inside)) {
          $inside = false;
        }
        if ($inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db->ts2db($ts);
                $tsend = $mt->db->ts2db($tsend);
                $date_filter = "and (entry_authored_on between '$ts' and '$tsend')";
            }
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
        parent::template_params($ctx);
        $vars =& $ctx->__stash['vars'];
        $vars['author_monthly_archive'] = 1;
        $vars['archive_class'] = 'author-monthly-archive';
        $vars['module_author-monthly_archives'] = 1;
        $vars['module_author_archives'] = 1;
    }
}

class DailyAuthorBasedArchiver extends DateBasedAuthorArchiver {

    // Override Method
    function get_label($args, $ctx) {
        return $ctx->mt->translate('Author Daily');
    }
    function get_title($args, $ctx) {
        $author_name = parent::get_author_name($ctx);
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
        $inside = $ctx->stash('inside_archive_list');
        if (!isset($inside)) {
          $inside = false;
        }
        if ($inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db->ts2db($ts);
                $tsend = $mt->db->ts2db($tsend);
                $date_filter = "and (entry_authored_on between '$ts' and '$tsend')";
            }
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
        parent::template_params($ctx);
        $vars =& $ctx->__stash['vars'];
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
        $author_name = parent::get_author_name($ctx);
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
        $inside = $ctx->stash('inside_archive_list');
        if (!isset($inside)) {
          $inside = false;
        }
        if ($inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db->ts2db($ts);
                $tsend = $mt->db->ts2db($tsend);
                $date_filter = "and (entry_authored_on between '$ts' and '$tsend')";
            }
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
        parent::template_params($ctx);
        $vars =& $ctx->__stash['vars'];
        $vars['author_weekly_archive'] = 1;
        $vars['archive_class'] = 'author-weekly-archive';
    }
}

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

    function setup_args($ctx, &$args) {
        if ($cat = $ctx->stash('category')) {
            $args['category_id'] = $cat['category_id'];
        }
    }

    function get_categorized_entry($ts, $blog_id, $cat_id, $at, $order) {
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
        $args['category_id'] = $cat_id;
        global $mt;
        list($entry) = $mt->db->fetch_entries($args);
        return $entry;
    }

    function template_params(&$ctx) {
        parent::template_params($ctx);
        $vars =& $ctx->__stash['vars'];
        $vars['archive_template'] = 1;
        $vars['main_template'] = 1;
        $vars['category_archive'] = 1;
    }

    function get_category_name ($ctx) {
        global $_archivers;
        $curr_at = $ctx->stash('current_archive_type');
        $archiver = $_archivers[$curr_at];
        $cat = $ctx->stash('category');
        $cat_name = '';

        if ($ctx->stash('index_archive')
            || !isset($archiver)
            || (isset($archiver) && !isset($cat))
            || !$ctx->stash('inside_archive_list'))
        {
            $cat = $ctx->stash('archive_category');
            $cat or $cat = $ctx->stash('category');
            if (isset($cat)) {
                $cat_name = $cat['category_label'].": ";
            }
        }
        return $cat_name;
    }
}

class YearlyCategoryArchiver extends DateBasedCategoryArchiver {
    // Override method
    function get_label($args, $ctx) {
        return $ctx->mt->translate('Category Yearly');
    }
    function get_title($args, $ctx) {
        $cat_name = parent::get_category_name($ctx);
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

    function template_params(&$ctx) {
        parent::template_params($ctx);
        $vars =& $ctx->__stash['vars'];
        $vars['category_yearly_archive'] = 1;
        $vars['archive_class'] = 'category-yearly-archive';
    }
}

class MonthlyCategoryArchiver extends DateBasedCategoryArchiver {
    // Override method
    function get_label($args, $ctx) {
        return $ctx->mt->translate('Category Monthly');
    }
    function get_title($args, $ctx) {
        $cat_name = parent::get_category_name($ctx);
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

    function template_params(&$ctx) {
        parent::template_params($ctx);
        $vars =& $ctx->__stash['vars'];
        $vars['archive_class'] = 'category-monthlyl-archive';
        $vars['category-monthly_archive'] = 1;
        $vars['module_category-monthly_archives'] = 1;
        $vars['module_category_archives'] = 1;
    }
}

class DailyCategoryArchiver extends DateBasedCategoryArchiver {
    // Override method
    function get_label($args, $ctx) {
        return $ctx->mt->translate('Category Daily');
    }
    function get_title($args, $ctx) {
        $cat_name = parent::get_category_name($ctx);
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

    function template_params(&$ctx) {
        parent::template_params($ctx);
        $vars =& $ctx->__stash['vars'];
        $vars['category_daily_archive'] = 1;
        $vars['archive_class'] = 'category-daily-archive';
    }
}

class WeeklyCategoryArchiver extends DateBasedCategoryArchiver {
    // Override method
    function get_label($args, $ctx) {
        return $ctx->mt->translate('Category Weekly');
    }
    function get_title($args, $ctx) {
        $cat_name = parent::get_category_name($ctx);
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

    function template_params(&$ctx) {
        parent::template_params($ctx);
        $vars =& $ctx->__stash['vars'];
        $vars['category_weekly_archive'] = 1;
        $vars['archive_class'] = 'category-weekly-archive';
    }
}
?>
