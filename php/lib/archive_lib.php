<?php
require_once("MTUtil.php");

// Create default archivers
global $_archivers;
$archiver = new YearlyArchiver();
$_archivers[$archiver->get_archive_name()] = $archiver;
$archiver = new MonthlyArchiver();
$_archivers[$archiver->get_archive_name()] = $archiver;
$archiver = new DailyArchiver();
$_archivers[$archiver->get_archive_name()] = $archiver;
$archiver = new WeeklyArchiver();
$_archivers[$archiver->get_archive_name()] = $archiver;
$archiver = new IndividualArchiver();
$_archivers[$archiver->get_archive_name()] = $archiver;

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
    function get_title($args, $ctx) { }
    function get_range(&$ctx, &$row) { }
    function get_archive_name() { }
    function &get_archive_list($ctx, $args) { }
    function get_archive_link_sql($ctx, $ts, $at, $args) { }
    function archive_prev_next($args, $content, &$ctx, &$repeat, $tag) { }
    function prepare_list(&$ctx, &$row) { }
}

class IndividualArchiver extends BaseArchiver {
    // Override Method
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
}

class YearlyArchiver extends DateBasedArchiver {

    function YearlyArchiver() { }

    // Override Method
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
}

class MonthlyArchiver extends DateBasedArchiver {

    function MonthlyArchiver() { }

    // Override Method
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
}

class DailyArchiver extends DateBasedArchiver {

    function DailyArchiver() { }

    // Override Method
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
}

class WeeklyArchiver extends DateBasedArchiver {

    function WeeklyArchiver() { }

    // Override Method
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
}
?>
