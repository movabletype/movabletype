<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("MTUtil.php");

function smarty_block_mtcalendar($args, $content, &$ctx, &$repeat) {
    $local_vars = array('cal_entries','cal_day','cal_pad_start','cal_pad_end','cal_days_in_month','cal_prefix','cal_left','CalendarDay','CalendarWeekHeader','CalendarWeekFooter','CalendarIfEntries','CalendarIfNoEntries','CalendarIfToday','CalendarIfBlank','entries','current_timestamp','current_timestamp_end','cal_today','CalendarCellNumber');
    // arguments supported: month, category
    // arguments implemented:
    if (!isset($content)) {
        # first iterations:
        $ctx->localize($local_vars);
        $blog_id = $ctx->stash('blog_id');
        $ts = offset_time_list( time(), $blog_id );
        $today = sprintf("%04d%02d", $ts[5] + 1900, $ts[4] + 1);

        $start_with_offset = 0;
        if (isset($args['weeks_start_with'])) {
            $start_with = substr(strtolower($args['weeks_start_with']), 0, 3);
            $start_with_offsets = array(
                'sun' => 0,
                'mon' => 6,
                'tue' => 5,
                'wed' => 4,
                'thu' => 3,
                'fri' => 2,
                'sat' => 1,
            );
            if (isset($start_with_offsets[$start_with])) {
                $start_with_offset = $start_with_offsets[$start_with];
            }
            else {
                // error: Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat
            }
        }

        $prefix = isset($args['month']) ? $args['month'] : null;
        if ($prefix) {
            if ($prefix == 'this') {
                $ts = $ctx->stash('current_timestamp');
                if (!$ts) {
                    $entry = $ctx->stash('entry');
                    if ($entry) {
                        $ts = $entry->entry_authored_on;
                    } else {
                        return $ctx->error($ctx->mt->translate(
                            'You used an [_1] tag without establishing a date context.', 
                            '<MTCalendar month="this">') );
                    }
                }
                $prefix = substr($ts, 0, 6);
            } elseif ($prefix == 'last') {
                $year = substr($today, 0, 4);
                $month = substr($today, 4, 2);
                if ($month - 1 == 0) {
                    $prefix = ($year - 1) . "12";
                } else {
                    $prefix = ($year . $month) - 1;
                }
            } else {
                // error: Invalid month format: must be YYYYMM
            }
        } else {
            $prefix = $today;
        }
        // gather category name...
        if (isset($args['category']))
            $cat_name = $args['category'];

        // caching isn't necessary since we're not building
        // entire site-- just one page
        $ts = offset_time_list( time(), $blog_id );
        $today .= sprintf("%02d", $ts[3]);
        list($start, $end) = start_end_month($prefix);
        $y = substr($prefix, 0, 4);
        $m = substr($prefix, 4, 2);
        $day = 1;
        $days_in_month = days_in($m, $y);
        $pad_start = (wday_from_ts($y, $m, 1) + $start_with_offset) % 7;
        $pad_end = 6 - ((wday_from_ts($y, $m, $days_in_month) + $start_with_offset) % 7);
        $this_day = $prefix . sprintf("%02d", $day - $pad_start);
        $args = array('current_timestamp' => $start, 'current_timestamp_end' => $end, 'blog_id' => $blog_id, 'lastn' => -1, 'sort_order' => 'ascend');
        if (isset($cat_name))
            $args['category'] = $cat_name;
        $iter = $ctx->mt->db()->fetch_entries($args);
        $ctx->stash('cal_entries', $iter);
        $ctx->stash('cal_pad_start', $pad_start);
        $ctx->stash('cal_pad_end', $pad_end);
        $ctx->stash('cal_days_in_month', $days_in_month);
        $ctx->stash('cal_prefix', $prefix);
        $ctx->stash('cal_today', $today);
        $ctx->stash('CalendarCellNumber', 0);
        $cell = 0;
    } else {
        # subseqent iterations:
        $prefix = $ctx->stash('cal_prefix');
        $day = $ctx->stash('cal_day');
        $pad_start = $ctx->stash('cal_pad_start');
        $pad_end = $ctx->stash('cal_pad_end');
        $days_in_month = $ctx->stash('cal_days_in_month');
        $iter = $ctx->stash('cal_entries');
        $left = $ctx->stash('cal_left');
        $today = $ctx->stash('cal_today');
        $cell = $ctx->stash('CalendarCellNumber');
    }
    !empty($left) or $left = array();
    $entries = array();
    if ($day <= $pad_start + $days_in_month + $pad_end) {
        $is_padding = $day < $pad_start + 1 || $day > $pad_start + $days_in_month;
        $this_day = '';
        if (!$is_padding) {
            $this_day = $prefix . sprintf("%02d", $day - $pad_start);
            $no_loop = 0;
            if (count($left)) {
                if (substr($left[0]->entry_authored_on, 0, 8) == $this_day) {
                    $entries = $left;
                    $left = array();
                } else {
                    $no_loop = 1;
                }
            }
            if (!$no_loop && is_array($iter) && count($iter)) {
                while ($entry = array_shift($iter)) {
                    $e_day = substr($entry->entry_authored_on, 0, 8);
                    if ($e_day != $this_day) {
                        $left[] = $entry;
                        break;
                    }
                    $entries[] = $entry;
                }
            }
            $ctx->stash('cal_left', $left);
            $ctx->stash('entries', $entries);
            $ctx->stash('current_timestamp', $this_day . '000000');
            $ctx->stash('current_timestamp_end', $this_day . '235959');
            $ctx->stash('CalendarDay', $day - $pad_start);
        }
        $ctx->stash('CalendarWeekHeader', ($day - 1) % 7 == 0);
        $ctx->stash('CalendarWeekFooter', $day % 7 == 0);
        $ctx->stash('CalendarIfEntries', !$is_padding && count($entries));
        $ctx->stash('CalendarIfNoEntries', !$is_padding && !count($entries));
        $ctx->stash('CalendarIfToday', $today == $this_day);
        $ctx->stash('CalendarIfBlank', $is_padding);
        $ctx->stash('cal_day', $day + 1);
        $ctx->stash('CalendarCellNumber', $cell+1);
        $ctx->stash('cal_entries', $iter);
        $repeat = true;
    } else {
        $ctx->restore($local_vars);
        $repeat = false;
    }
    return $content;
}
?>
