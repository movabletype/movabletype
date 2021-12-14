<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once("MTUtil.php");

function smarty_block_mtcontentcalendar($args, $content, &$ctx, &$repeat) {
    $local_vars = array('cal_contents','cal_day','cal_pad_start','cal_pad_end','cal_days_in_month','cal_prefix','cal_left','CalendarDay','CalendarWeekHeader','CalendarWeekFooter','CalendarIfContents','CalendarIfNoContents','CalendarIfToday','CalendarIfBlank','contents','current_timestamp','current_timestamp_end','cal_today','CalendarCellNumber', 'cal_date_field_id');
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
                return $ctx->error(
                    $ctx->mt->translate(
                        "Invalid weeks_start_with format: must be Sun|Mon|Tue|Wed|Thu|Fri|Sat"
                    )
                );
            }
        }

        $prefix = isset($args['month']) ? $args['month'] : null;
        if ($prefix) {
            if ($prefix == 'this') {
                $ts = $ctx->stash('current_timestamp');
                if (!$ts) {
                    $cd = $ctx->stash('content');
                    if ($cd) {
                        $ts = $cd->cd_authored_on;
                    } else {
                        return $ctx->error($ctx->mt->translate(
                            'You used an [_1] tag without a date context set up.', 
                            '<MTContentCalendar month="this">') );
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
            } elseif ($prefix == 'next') {
                $year  = substr($today, 0, 4);
                $month = substr($today, 4, 2);
                if ( $month + 1 == 13 ) {
                    $prefix = ($year + 1) . "01";
                }
                else {
                    $prefix = ($year . $month) + 1;
                }
            } else {
                // error: Invalid month format: must be YYYYMM
                if( strlen($prefix) != 6 ){
                    return $ctx->error($ctx->mt->translate(
                        "Invalid month format: must be YYYYMM"
                    ));
                }
            }
        } else {
            $prefix = $today;
        }
        $cat_field_id = 0;
        if(isset($args['category_set'])){
            $id = $args['category_set'];

            if(preg_match('/^[0-9]+$/',$id))
                $category_set = $ctx->mt->db()->fetch_category_set($id);
            if(empty($category_set)){
                $category_sets = $ctx->mt->db()->fetch_category_sets(array(
                    'blog_id' => $blog_id,
                    'name' => $id,
                    'limit' => 1,
                ));
                if($category_sets)
                    $category_set = $category_sets[0];
            }
            if(isset($category_set)){
                $cat_set_name    = $category_set->name;
                $category_set_id = $category_set->id;
                
                $cat_fields = $ctx->mt->db()->fetch_content_fields(array(
                  'blog_id' => $blog_id,
                  'related_cat_set_id' => $category_set_id,
                ));
                if($cat_fields){
                  $cat_field = $cat_fields[0];
                  $cat_field_unique_id = $cat_field->unique_id;
                  $cat_field_id = $cat_field->id;
                }
            }
        }
        // gather category name...
        if (isset($args['category'])){
            $cat_name = $args['category'];
            $category_param = array(
              'label'   => $cat_name,
              'blog_id' => $blog_id,
            );
            if(isset($category_set_id)){
                $category_param['category_set_id'] = $category_set_id;
            } else {
                $category_param['category_set_id'] = '> 0';
            }
            $cats = $ctx->mt->db()->fetch_categories($category_param);
            if(!$cats){
                return $ctx->error($ctx->mt->translate(
                    "No such category '[_1]'",
                    $cat_name
                ));
            } else {
                $cat = $cats[0];
            }
        } else {
            $cat_name = '';
        }
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

        $content_type = $ctx->stash('content_type');
        if(isset($args['content_type'])){
            $content_types = $ctx->mt->db()->fetch_content_types(array('content_type' => $args['content_type']));
            if (isset($content_types)) {
                $content_type = $content_types[0];
            }
        }

        $contents_args = array('current_timestamp' => $start, 'current_timestamp_end' => $end, 'blog_id' => $blog_id, 'lastn' => -1, 'sort_order' => 'ascend');
        if(isset($args['date_field']))
          $contents_args['date_field'] = $args['date_field'];
        if(isset($args['category_set']))
          $contents_args['category_set'] = $args['category_set'];
        if(isset($args['category']))
          $contents_args['category'] = $args['category'];

        $iter = $ctx->mt->db()->fetch_contents($contents_args, isset($content_type_id) ? $content_type_id : null);
        $dt_field    = 'cd_authored_on';
        $dt_field_id = 0;
        if ( !empty($args['date_field']) && ($arg = $args['date_field']) ) {
            if (   $arg === 'authored_on'
                || $arg === 'modified_on'
                || $arg === 'created_on' )
            {
                $dt_field = 'cd_' . $arg;
            }
            else {
                if (preg_match('/^[0-9]+$/', $arg))
                    $date_cfs = $ctx->mt->db()->fetch_content_fields(array('id' => $arg));
                if (!isset($date_cfs))
                    $date_cfs = $ctx->mt->db()->fetch_content_fields(array('unique_id' => $arg));
                if (!isset($date_cfs))
                    $date_cfs = $ctx->mt->db()->fetch_content_fields(array('name' => $arg));
                if (isset($date_cfs)) {
                    $date_cf = $date_cfs[0];
                    $dt_field_id = $date_cf->id;
                }
            }
        }


        $ctx->stash('cal_contents', $iter);
        $ctx->stash('cal_pad_start', $pad_start);
        $ctx->stash('cal_pad_end', $pad_end);
        $ctx->stash('cal_days_in_month', $days_in_month);
        $ctx->stash('cal_prefix', $prefix);
        $ctx->stash('cal_today', $today);
        $ctx->stash('CalendarCellNumber', 0);
        $ctx->stash('cal_date_field_id', $dt_field_id);
        $cell = 0;
    } else {
        # subseqent iterations:
        $prefix = $ctx->stash('cal_prefix');
        $day = $ctx->stash('cal_day');
        $pad_start = $ctx->stash('cal_pad_start');
        $pad_end = $ctx->stash('cal_pad_end');
        $days_in_month = $ctx->stash('cal_days_in_month');
        $iter = $ctx->stash('cal_contents');
        $left = $ctx->stash('cal_left');
        $today = $ctx->stash('cal_today');
        $cell = $ctx->stash('CalendarCellNumber');
        $dt_field_id = $ctx->stash('cal_date_field_id');
    }
    !empty($left) or $left = array();
    if ($day <= $pad_start + $days_in_month + $pad_end) {
        $is_padding = $day < $pad_start + 1 || $day > $pad_start + $days_in_month;
        $this_day = '';
        if (!$is_padding) {
            $this_day = $prefix . sprintf("%02d", $day - $pad_start);
            $no_loop = 0;
            if (isset($left) && count($left)) {
                $data = $left[0]->data();
                $datetime = '';
                if(isset($data[$dt_field_id])){
                    $datetime = $data[$dt_field_id];
                } else {
                    $datetime = $ctx->mt->db()->db2ts($left[0]->authored_on);
                }
                if ( $datetime && substr($datetime, 0, 8) == $this_day) {
                    $cds = $left;
                    $left = array();
                } else {
                    $no_loop = 1;
                }
            }
            if (!$no_loop && is_array($iter) && count($iter)) {
                while ($cd = array_shift($iter)) {
                    $data = $cd->data();
                    if(isset($data[$dt_field_id])){
                        $datetime = $data[$dt_field_id];
                    } else {
                        $datetime = $ctx->mt->db()->db2ts($cd->authored_on);
                    }
                    $cd_day = '';
                    if($datetime){
                        $cd_day = substr($datetime, 0, 8);
                    }
                    if ($cd_day != $this_day) {
                        $left[] = $cd;
                        break;
                    }
                    $cds[] = $cd;
                }
            }
            $ctx->stash('cal_left', $left);
            $ctx->stash('contents', isset($cds) ? $cds : null);
            $ctx->stash('current_timestamp', $this_day . '000000');
            $ctx->stash('current_timestamp_end', $this_day . '235959');
            $ctx->stash('CalendarDay', $day - $pad_start);
        }
        $count = 0;
        if (isset($cds)) {
            $count = count($cds);
        }
        $ctx->stash('CalendarWeekHeader', ($day - 1) % 7 == 0);
        $ctx->stash('CalendarWeekFooter', $day % 7 == 0);
        $ctx->stash('CalendarIfContents', !$is_padding && $count);
        $ctx->stash('CalendarIfNoContents', !$is_padding && !$count);
        $ctx->stash('CalendarIfToday', $today == $this_day);
        $ctx->stash('CalendarIfBlank', $is_padding);
        $ctx->stash('cal_day', $day + 1);
        $ctx->stash('CalendarCellNumber', $cell+1);
        $ctx->stash('cal_contents', $iter);
        $repeat = true;
    } else {
        $ctx->restore($local_vars);
        $repeat = false;
    }
    return $content;
}
?>
