<?php
require_once("MTUtil.php");

global $_archive_helpers;
$_archive_helpers = array(
    'Yearly' => 'start_end_year',
    'Monthly' => 'start_end_month',
    'Weekly' => 'start_end_week',
    'Daily' => 'start_end_day'
);
function _hdlr_archive_prev_next($args, $content, &$ctx, &$repeat, $tag) {
    $localvars = array('conditional', 'current_timestamp', 'current_timestamp_end', 'entries');
    if (!isset($content)) {
        $ctx->localize($localvars);
        $is_prev = $tag == 'ArchivePrevious';
        $ts = $ctx->stash('current_timestamp');
        if (!$ts) {
            return $ctx->error(
               "You used an <MT$tag> without a date context set up.");
        }
        $at = $args['archive_type'];
        $at or $at = $ctx->stash('current_archive_type');
        #$ctx->stash('current_archive_type', $at);
        global $_archive_helpers;
        /*if (!isset($_archive_helpers[$at])) {
            return $ctx->error(
                "<MT$tag> can be used only with Daily, Weekly, or Monthly archives.");
        }*/
        $order = $is_prev ? 'previous' : 'next';
        $helper = $_archive_helpers[$at];
        if ($entry = get_entry($ts, $ctx->stash('blog_id'), $at, $order)) {
            $ctx->stash('entries', array( $entry ));
            list($start, $end) = $helper($entry['entry_created_on']);
            $ctx->stash('current_timestamp', $start);
            $ctx->stash('current_timestamp_end', $end);
            $ctx->stash('conditional', 1);
        } else {
            $ctx->restore($localvars);
            $ctx->stash('conditional', 0);
            $repeat = false;
        }
    } else {
        $ctx->restore($localvars);
    }
    return $content;
}

function get_entry($ts, $blog_id, $at, $order) {
    global $_archive_helpers;
    $helper = $_archive_helpers[$at];
    list($start, $end) = $helper($ts);
    $args = array();
    if ($order == 'previous') {
        $args['current_timestamp_end'] = dec_ts($start);
    } else {
        $args['current_timestamp'] = inc_ts($end);
        $args['sort_order'] = 'ascend'; # ascending order
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
                        $mo = 1; $y--;
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

function _al_Individual_group_end() {
    return 1;
}
function _al_Individual_section_title($args, &$ctx) {
    $entry = $ctx->stash('entry');
    return $entry['title'];
}
function _al_Individual_section_timestamp($entry, $grp) {
    return array($grp[1], $grp[1]);
}
function _al_Daily_group_end(&$ctx, &$entry, &$cur) {
    $stamp = $entry['entry_created_on'];
    list($sod) = start_end_day($stamp, $ctx->stash('blog'));
    $end = !$cur || $sod == $cur ? 0 : 1;
    $cur = $sod;
    return $end;
}       
function _al_Daily_section_title($args, &$ctx) {
    $stamp = $ctx->stash('current_timestamp'); #$entry['entry_created_on'];
    list($start) = start_end_day($stamp, $ctx->stash('blog'));
    $format = $args['format'];
    $format or $format = "%x";
    return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
}           
function _al_Daily_section_timestamp(&$ctx, &$row) {
    $period_start = sprintf("%04d%02d%02d000000", $row[0], $row[1], $row[2]);
    return start_end_day($period_start, $ctx->stash('blog'));
}
function _al_Weekly_group_end(&$ctx, &$entry, &$cur) {
    $stamp = $entry['entry_created_on'];
    list($sow) = start_end_week($stamp, $ctx->stash('blog'));
    $end = !$cur || $sow == $cur ? 0 : 1;
    $cur = $sow;
    return $end;
}
function _al_Weekly_section_title($args, &$ctx) {
    $stamp = $ctx->stash('current_timestamp'); # $entry['entry_created_on'];
    list($start, $end) = start_end_week($stamp, $ctx->stash('blog'));
    $format = $args['format'];
    $format or $format = "%x";
    return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format ), $ctx) .
        ' - ' .
        $ctx->_hdlr_date(array('ts' => $end, 'format' => $format ), $ctx);
}
function _al_Weekly_section_timestamp(&$ctx, &$row) {
    $year = $row[0];
    $week = $year % 100;
    $year -= $week; $year /= 100;
    list($y, $m, $d) = week2ymd($year, $week);
    return start_end_week(sprintf("%04d%02d%02d000000", $y, $m, $d));
}
function _al_Monthly_group_end(&$ctx, &$entry, &$cur) {
    $stamp = $entry['entry_created_on'];
    list($som) = start_end_month($stamp, $ctx->stash('blog'));
    $end = !$cur || $som == $cur ? 0 : 1;
    $cur = $som;
    return $end;
}
function _al_Monthly_section_title($args, &$ctx) {
    $stamp = $ctx->stash('current_timestamp'); #$entry['entry_created_on'];
    list($start) = start_end_month($stamp, $ctx->stash('blog'));
    $format = $args['format'];
    $format or $format = "%B %Y";
    return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
}
function _al_Monthly_section_timestamp(&$ctx, &$row) {
    $period_start = sprintf("%04d%02d01000000", $row[0], $row[1]);
    return start_end_month($period_start, $ctx->stash('blog'));
}
function _al_Yearly_group_end() {
}
function _al_Yearly_section_title($args, &$ctx) {
    $stamp = $ctx->stash('current_timestamp'); #$entry['entry_created_on'];
    list($start) = start_end_year($stamp, $ctx->stash('blog'));
    $format = $args['format'];
    $format or $format = "%Y";
    return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
}
function _al_Yearly_section_timestamp(&$ctx, &$row) {
    return array(sprintf("%04d0101000000", $row[0]),
                 sprintf("%04d1231235959", $row[0]));
}
?>
