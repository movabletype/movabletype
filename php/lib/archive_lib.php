<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

require_once('MTUtil.php');

function _hdlr_archive_prev_next($args, $content, &$ctx, &$repeat, $tag) {
    $at = isset($args['archive_type']) ? $args['archive_type'] : null;
    $at or $at = $ctx->stash('current_archive_type');
    try {
        $archiver = ArchiverFactory::get_archiver($at);
    } catch (Exception $e) {
    }
    if (!isset($archiver)) {
        $repeat = false;
        return '';
    }
    return $archiver->archive_prev_next($args, $content, $repeat, $tag, $at);
}

function _get_join_on($ctx, $at, $blog_id, $cat = NULL, $cat_field_id = NULL) {
    $maps = $ctx->mt->db()->fetch_templatemap(array(
        'blog_id' => $blog_id,
        'content_type_id' => $ctx->stash('content_type')->id,
        'preferred' => 1,
        'type' => $at
    ));
    if (!empty($maps) && is_array($maps)) {
        $map = $maps[0];
        $dt_field_id = $map->templatemap_dt_field_id;
        if ($cat)
            $cat_field_id = $map->templatemap_cat_field_id;
    }

    $join_on = '';
    if (isset($dt_field_id) && $dt_field_id) {
        $join_on .= "join mt_cf_idx dt_cf_idx";
        $join_on .= " on cd_id = dt_cf_idx.cf_idx_content_data_id";
        $join_on .= " and dt_cf_idx.cf_idx_content_field_id = $dt_field_id\n";

        $dt_target_col = 'dt_cf_idx.cf_idx_value_datetime';
    }
    $cat_target_col = null;
    if ($cat) {
        $cat_id = $cat->category_id;

        $join_on .= "join mt_cf_idx cat_cf_idx";
        $join_on .= " on cd_id = cat_cf_idx.cf_idx_content_data_id";
        $join_on .= " and cat_cf_idx.cf_idx_content_field_id = $cat_field_id";
        $join_on .= " and cat_cf_idx.cf_idx_value_integer = $cat_id\n";

        $join_on .= "join mt_category";
        $join_on .= " on category_id = cat_cf_idx.cf_idx_value_integer";
        $join_on .= " and category_id = $cat_id";

        $cat_target_col = 'cat_cf_idx.cf_idx_value_integer';
    }

    if (!isset($dt_target_col))
        $dt_target_col = 'cd_authored_on';

    return array ($dt_target_col, $cat_target_col, $join_on, isset($dt_field_id) ? $dt_field_id : null);
}

function _get_content_type_filter($args) {
    $mt = MT::get_instance();
    $ctx =& $mt->context();
    if (isset($args['content_type']) && $args['content_type']) {
        if (is_numeric($args['content_type'])) {
            $content_type = $mt->db()->fetch_content_type($args['content_type']);
        }
        if (isset($content_type)) {
            $content_type_filter = 'and cd_content_type_id = ' . $args['content_type'];
        }
        else {
            $content_types = $mt->db()->fetch_content_types($args);
            if (isset($content_types)) {
                $content_type = $content_types[0];
                $content_type_filter = 'and cd_content_type_id = ' . $content_type->id;
            }
        }
    }
    elseif ($ctx->stash('content_type')) {
        $content_type_filter = 'and cd_content_type_id = ' . $ctx->stash('content_type')->id;
    }
    return $content_type_filter;
}

interface ArchiveType {
    public function get_label($args = null);
    public function get_title($args);
    public function get_archive_list($args);
    public function archive_prev_next($args, $content, &$repeat, $tag, $at);
    public function get_template_params();
    public function template_params();
    public function get_range($period_start);
    public function prepare_list($row);
    public function setup_args(&$args);
    public function get_archive_link_sql($ts, $at, $args);
    public function is_date_based();
}

class ArchiverFactory {
    private static $_archive_types = array(
        'Yearly' => 'YearlyArchiver',
        'Monthly' => 'MonthlyArchiver',
        'Weekly' => 'WeeklyArchiver',
        'Daily' => 'DailyArchiver',

        'Individual' => 'IndividualArchiver',
        'Page' => 'PageArchiver',

        'Author' => 'AuthorBasedArchiver',
        'Author-Yearly' => 'YearlyAuthorBasedArchiver',
        'Author-Monthly' => 'MonthlyAuthorBasedArchiver',
        'Author-Weekly' => 'WeeklyAuthorBasedArchiver',
        'Author-Daily' => 'DailyAuthorBasedArchiver',

        'Category' => 'CategoryArchiver',
        'Category-Yearly' => 'YearlyCategoryArchiver',
        'Category-Monthly' => 'MonthlyCategoryArchiver',
        'Category-Weekly' => 'WeeklyCategoryArchiver',
        'Category-Daily' => 'DailyCategoryArchiver',

        'ContentType' => 'ContentTypeArchiver',
        'ContentType-Daily' => 'ContentTypeDailyArchiver',
        'ContentType-Weekly' => 'ContentTypeWeeklyArchiver',
        'ContentType-Monthly' => 'ContentTypeMonthlyArchiver',
        'ContentType-Yearly' => 'ContentTypeYearlyArchiver',
        'ContentType-Author' => 'ContentTypeAuthorArchiver',
        'ContentType-Author-Daily' => 'ContentTypeAuthorDailyArchiver',
        'ContentType-Author-Weekly' => 'ContentTypeAuthorWeeklyArchiver',
        'ContentType-Author-Monthly' => 'ContentTypeAuthorMonthlyArchiver',
        'ContentType-Author-Yearly' => 'ContentTypeAuthorYearlyArchiver',
        'ContentType-Category' => 'ContentTypeCategoryArchiver',
        'ContentType-Category-Daily' => 'ContentTypeCategoryDailyArchiver',
        'ContentType-Category-Weekly' => 'ContentTypeCategoryWeeklyArchiver',
        'ContentType-Category-Monthly' => 'ContentTypeCategoryMonthlyArchiver',
        'ContentType-Category-Yearly' => 'ContentTypeCategoryYearlyArchiver',
    );
    private static $_archivers = array();

    private function __construct() { }

    public static function get_archiver($at) {
        if (empty($at)) {
            require_once('class.exception.php');
            throw new MTException('Illegal archive type');
        }
        if (!array_key_exists($at, ArchiverFactory::$_archive_types)) {
            require_once('class.exception.php');
            throw new MTException('Undefined archive type. (' . $at . ')');
        }

        $class = ArchiverFactory::$_archive_types[$at];
        if (!empty($class)) {
            $instance = new $class;
            if (!empty($instance) and $instance instanceof ArchiveType)
                ArchiverFactory::$_archivers[$at] = $instance;
        } else {
            ArchiverFactory::$_archivers[$at] = null;
        }
        
        return ArchiverFactory::$_archivers[$at]; 
    }

    public static function add_archiver($at, $class) {
        if (empty($at) or empty($class))
            return null;

        ArchiverFactory::$_archive_types[$at] = $class;
        return true;
    }
}

class IndividualArchiver implements ArchiveType {
    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate("INDIVIDUAL_ADV");
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        return encode_html( strip_tags( $ctx->tag('EntryTitle', $args) ) );
    }

    public function get_range($period_start) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $period_start = preg_replace('/[^0-9]/', '', $period_start);
        return start_end_day($period_start, $ctx->stash('blog'));
    }

    public function get_archive_list($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        list($results) = $this->get_archive_list_data($args);
        return $results;
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $blog_id = $args['blog_id'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $sql = "
                entry_blog_id = $blog_id
                and entry_status = 2
                and entry_class = 'entry'
                order by entry_authored_on $order, entry_id asc";
        $extras = array();
        $extras['limit'] = isset($args['lastn']) ? $args['lastn'] : -1;
        $extras['offset'] = isset($args['offset']) ? $args['offset'] : -1;

        require_once('class.mt_entry.php');
        $entry = new Entry();
        $results = $entry->Find($sql, false, false, $extras);
        return empty($results) ? null : array($results, null, null);
    }

    public function archive_prev_next($args, $content, &$repeat, $tag, $at) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $tag = $ctx->this_tag();
        if ($tag == 'mtarchivenext') {
            require_once("block.mtentrynext.php");
            return smarty_block_mtentrynext($args, $content, $ctx, $repeat);
        } else {
            require_once("block.mtentryprevious.php");
            return smarty_block_mtentryprevious($args, $content, $ctx, $repeat);
        }
    }

    public function prepare_list($row) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $ctx->stash('entry', $row);
        $ctx->stash('entries', array($row));
    }

    public function get_template_params() {
        $array = array(
            'entry_archive'     => 1,
            'archive_template'  => 1,
            'entry_template'    => 1,
            'feedback_template' => 1,
            'archive_class'     => 'entry-archive'
        );
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += IndividualArchiver::get_template_params();
    }

    public function setup_args(&$args) {
        return true;
    }

    public function get_archive_link_sql($ts, $at, $args) {
        return '';
    }

    public function is_date_based() {
        return false;
    }
}

class PageArchiver extends IndividualArchiver {
    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate("PAGE_ADV");
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $blog_id = $args['blog_id'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $sql = "
                entry_blog_id = $blog_id
                and entry_status = 2
                and entry_class = 'page'
                order by entry_authored_on $order, entry_id asc";
        $extras = array();
        $extras['limit'] = isset($args['lastn']) ? $args['lastn'] : -1;
        $extras['offset'] = isset($args['offset']) ? $args['offset'] : -1;

        require_once('class.mt_page.php');
        $page = new Page();
        $results = $page->Find($sql, false, false, $extras);
        return empty($results) ? null : array($results, null, null);
    }

    public function archive_prev_next($args, $content, &$repeat, $tag, $at) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $tag = $ctx->this_tag();
        if ($tag == 'mtarchivenext') {
            require_once("block.mtpagenext.php");
            return smarty_block_mtpagenext($args, $content, $ctx, $repeat);
        } else {
            require_once("block.mtpageprevious.php");
            return smarty_block_mtpageprevious($args, $content, $ctx, $repeat);
        }
    }

    public function get_template_params() {
        $array = array(
            'archive_template'  => 1,
            'page_template'     => 1,
            'feedback_template' => 1,
            'page_archive'      => 1,
            'archive_class'     => 'page-archive'
        );
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += PageArchiver::get_template_params();
    }
}

abstract class DateBasedArchiver implements ArchiveType {

    abstract protected function get_update_link_args($results);
    abstract protected function get_helper();

    public function is_date_based() { return true; }

    public function prepare_list($row) { return true; }

    public function setup_args(&$args) { return true; }

    public function get_archive_link_sql($ts, $at, $args) { return ''; }

    public function archive_prev_next($args, $content, &$repeat, $tag, $at) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
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
            $helper = $this->get_helper();
            if ($entry = $this->get_entry($ts, $ctx->stash('blog_id'), $at, $order)) {
                $ctx->stash('entries', array( $entry ));
                list($start, $end) = $helper($entry->entry_authored_on);
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

    public function get_archive_list($args) {
        $mt = MT::get_instance();

        $ctx =& $mt->context();

        $results = $this->get_archive_list_data($args);

        if (!empty($results)) {
                $update_args = $this->get_update_link_args($results);
                $args = array_merge($args, $update_args);

                $mt->db()->update_archive_link_cache($args);
        }

        return $results;
    }

    protected function get_archive_list_data($args) {
        return array();
    }

    protected function get_entry($ts, $blog_id, $at, $order) {
        $helper = $this->get_helper();
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
        $mt = MT::get_instance();
        list($entry) = $mt->db()->fetch_entries($args);
        return $entry;
    }

    protected function dec_ts($ts) {
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

    protected function inc_ts($ts) {
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

    public function get_template_params() {
        $array = array(
            'archive_listing'   => 1,
            'archive_template'  => 1,
            'datebased_archive' => 1
        );
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += DateBasedArchiver::get_template_params();
    }
}

class YearlyArchiver extends DateBasedArchiver {

    // Override Method
    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('YEARLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_year($stamp, $ctx->stash('blog'));
        $format = isset($args['format']) ? $args['format'] : null;
        $blog = $ctx->stash('blog');
        $lang = ($blog && $blog->blog_language ? $blog->blog_language :
            $mt->config('DefaultLanguage'));
        if (strtolower($lang) == 'jp' || strtolower($lang) == 'ja') {
            $format or $format = "%Y&#24180;";
        } else {
            $format or $format = "%Y";
        }

        return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        if (is_array($period_start))
            $period_start = sprintf("%04d", $period_start['y']);

        return start_end_year($period_start, $ctx->stash('blog'));
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);
            $args['hi'] = sprintf("%04d1231235959", $results[0]['y']);
            $args['low'] = sprintf("%04d0101000000", $results[$count - 1]['y']);
        }
        return $args;
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['datebased_only_archive']   = 1;
        $array['datebased_yearly_archive'] = 1;
        $array['archive_class']            = 'datebased-yearly-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += YearlyArchiver::get_template_params();
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $year_ext = $mt->db()->apply_extract_date('year', 'entry_authored_on');

        $sql = "
                select count(*) as entry_count,
                       $year_ext as y
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                   and entry_class = 'entry'
                 group by
                       $year_ext
                 order by
                       $year_ext $order";

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    protected function get_helper() {
        return 'start_end_year';
    }
}

class MonthlyArchiver extends DateBasedArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('MONTHLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_month($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%B %Y';
        return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d", $period_start['y'], $period_start['m']);
        return start_end_month($period_start, $ctx->stash('blog'));
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['datebased_only_archive']    = 1;
        $array['datebased_monthly_archive'] = 1;
        $array['archive_class']             = 'datebased-monthly-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += MonthlyArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_month';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);
            $args['hi'] = sprintf("%04d%02d32", $results[0]['y'], $results[0]['m']);
            $args['low'] = sprintf("%04d%02d00", $results[$count - 1]['y'], $results[0]['m']);
        }
        return $args;
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $inside = $ctx->stash('inside_archive_list');
        if (isset($inside) && $inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and (entry_authored_on between '$ts' and '$tsend')";
            }
        }
        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $year_ext = $mt->db()->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $mt->db()->apply_extract_date('month', 'entry_authored_on');

        $sql = implode(' ', array(
            "select count(*) as entry_count, $year_ext as y, $month_ext as m from mt_entry",
            "where entry_blog_id = $blog_id and entry_status = 2 and entry_class = 'entry'",
            isset($date_filter) ? $date_filter : '',
            "group by $year_ext, $month_ext order by $year_ext $order, $month_ext $order"
        ));

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }
}

class DailyArchiver extends DateBasedArchiver {
    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('DAILY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_day($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%x';
        return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d%02d", $period_start['y'], $period_start['m'], $period_start['d']);
        return start_end_day($period_start, $ctx->stash('blog'));
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['datebased_only_archive']  = 1;
        $array['datebased_daily_archive'] = 1;
        $array['archive_class']           = 'datebased-daily-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += DailyArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_day';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);
            $args['hi'] = sprintf("%04d%02d32", $results[0]['y'], $results[0]['m']);
            $args['low'] = sprintf("%04d%02d00", $results[$count - 1]['y'], $results[0]['m']);
        }
        return $args;
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $inside = $ctx->stash('inside_archive_list');
        if (isset($inside) && $inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and (entry_authored_on between '$ts' and '$tsend')";
            }
        }

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $year_ext = $mt->db()->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $mt->db()->apply_extract_date('month', 'entry_authored_on');
        $day_ext = $mt->db()->apply_extract_date('day', 'entry_authored_on');

        $sql = implode(' ', array(
            'select count(*) as entry_count,',
            "$year_ext as y,",
            "$month_ext as m,",
            "$day_ext as d",
            'from mt_entry',
            "where entry_blog_id = $blog_id",
            'and entry_status = 2',
            "and entry_class = 'entry'",
            isset($date_filter) ? $date_filter : '',
            "group by $year_ext, $month_ext, $day_ext order by $year_ext $order, $month_ext $order, $day_ext $order"
        ));

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);

        return empty($results) ? null : $results->GetArray();
    }
}

class WeeklyArchiver extends DateBasedArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('WEEKLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start, $end) = start_end_week($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%x';
        return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx)
            . ' - ' .
            $ctx->_hdlr_date(array('ts' => $end, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        if (is_array($period_start)) {
            require_once('MTUtil.php');
            $week_yr = substr($period_start['entry_week_number'], 0, 4);
            $week_num = substr($period_start['entry_week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);

            $period_start = sprintf("%04d%02d%02d000000", $y, $m, $d);
        }
        return start_end_week($period_start, $ctx->stash('blog'));
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['datebased_only_archive']   = 1;
        $array['datebased_weekly_archive'] = 1;
        $array['archive_class']            = 'datebased-weekly-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += WeeklyArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_week';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);

            require_once("MTUtil.php");
            $week_yr = substr($results[0]['entry_week_number'], 0, 4);
            $week_num = substr($results[0]['entry_week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);
            $args['hi'] = sprintf("%04d%02d%02d", $y, $m, $d);

            $week_yr = substr($results[$count - 1]['entry_week_number'], 0, 4);
            $week_num = substr($results[$count - 1]['entry_week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);
            $args['low'] = sprintf("%04d%02d%02d", $y, $m, $d);
        }
        return $args;
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $inside = $ctx->stash('inside_archive_list');
        if (isset($inside) && $inside) {
            $ts = $ctx->stash('current_timestamp');

            if ($ts && $tsend) {
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and (entry_authored_on between '$ts' and '$tsend')";
            }
        }

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $sql = implode(' ', array(
            "select count(*) as entry_count, entry_week_number from mt_entry",
            "where entry_blog_id = $blog_id and entry_status = 2 and entry_class = 'entry'",
            isset($date_filter) ? $date_filter : '',
            "group by entry_week_number order by entry_week_number $order"
        ));

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);

        return empty($results) ? null : $results->GetArray();
    }
}

class AuthorBasedArchiver implements ArchiveType {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('AUTHOR_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $author_name = '';
        $author = $ctx->stash('archive_author');
        if (!isset($archive_author)) {
            $author = $ctx->stash('author');
            if (isset($author)) {
                $author_name = $author->author_nickname;
                $author_name or $author_name =
                    $mt->translate('(Display Name not set)');
            }
        }
        return encode_html( strip_tags( $author_name ) );
    }

    public function get_archive_list($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $results = $this->get_archive_list_data($args);

        if(!empty($results)) {
            $update_args['blog_id'] = $args['blog_id'];
            $update_args['archive_type'] = $ctx->stash('current_archive_type');
            $mt->db()->update_archive_link_cache($update_args);
        }
        return $results;
    }

    public function get_archive_link_sql($ts, $at, $args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = intval($args['blog_id']);
        $author = $ctx->stash('author');
        if ( empty( $author ) ) {
            $entry = $ctx->stash('entry');
            if ( !empty( $entry ) ) {
                $author = $entry->author();
            }
            $content = $ctx->stash('content');
            if ( !empty( $content ) ) {
                $author = $content->author();
            }
        }
        $auth_id = $author->author_id;
        $at or $at = $ctx->stash('current_archive_type');

        $sql = " fileinfo_blog_id = $blog_id
                 and fileinfo_archive_type = '".$mt->db()->escape($at)."'
                 and fileinfo_author_id = '$auth_id'
                 and templatemap_is_preferred = 1";
        return $sql;
    }

    public function archive_prev_next($args, $content, &$repeat, $tag, $at) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        if ($tag == 'archiveprevious') {
            require_once('block.mtauthorprevious.php');
            return smarty_block_mtauthorprevious($args, $content, $ctx, $repeat);
        } elseif ($tag == 'archivenext') {
            require_once('block.mtauthornext.php');
            return smarty_block_mtauthornext($args, $content, $ctx, $repeat);
        }

        return $ctx->error("Error in tag: $tag");
    }

    public function prepare_list($row) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $author_id = $row['entry_author_id'];
        $author = $mt->db()->fetch_author($author_id);
        $ctx->stash('author', $author);
    }

    public function setup_args(&$args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        if ($auth = $ctx->stash('author')) {
            $args['author'] = $auth->author_name;
        }
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $blog_id = $args['blog_id'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';
        $sql = "
            select count(*) as entry_count,
                   entry_author_id,
                   author_name
              from mt_entry
                   join mt_author on entry_author_id = author_id
             where entry_blog_id = $blog_id
               and entry_status = 2
               and entry_class = 'entry'
             group by
                   entry_author_id,
                   author_name
             order by
                   author_name $order";
        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function get_template_params() {
        $array = array(
            'archive_template'     => 1,
            'author_archive'       => 1,
            'author_based_archive' => 1,
            'archive_class'        => 'author-archive',
            'archive_listing'      => 1
        );
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $vars =& $ctx->__stash['vars'];
        $vars += AuthorBasedArchiver::get_template_params();
    }

    public function is_date_based() {
        return false;
    }

    public function get_range($period_start) {
        return null;
    }
}

abstract class DateBasedAuthorArchiver extends DateBasedArchiver {

    public function setup_args(&$args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        if ($auth = $ctx->stash('author')) {
            $args['author'] = $auth->author_name;
        }
    }

    public function get_archive_link_sql($ts, $at, $args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = intval($args['blog_id']);
        $author = $ctx->stash('author');
        $auth_id = $author->author_id;
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

        $sql = ($ts ? "fileinfo_startdate = '$ts' and" : "") .
               " fileinfo_blog_id = $blog_id
                 and fileinfo_archive_type = '".$mt->db()->escape($at)."'
                 and fileinfo_author_id = '$auth_id'
                 and templatemap_is_preferred = 1";
        return $sql;
    }

    public function archive_prev_next($args, $content, &$repeat, $tag, $at) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

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

            if ($entry = $this->get_author_entry($ts, $ctx->stash('blog_id'), $author->author_name, $order)) {
                $helper = $this->get_helper();
                $ctx->stash('entries', array( $entry ));
                list($start, $end) = $helper($entry->entry_authored_on);
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

    public function get_author_entry($ts, $blog_id, $auth_name, $order) {
        $helper = $this->get_helper();
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

        $mt = MT::get_instance();
        list($entry) = $mt->db()->fetch_entries($args);
        return $entry;
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['author_based_archive'] = 1;
        return $array;
    }

    public function template_params() {
        AuthorBasedArchiver::template_params();
        parent::template_params();
    }

    protected function get_author_name () {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $curr_at = $ctx->stash('current_archive_type');
        $archiver = ArchiverFactory::get_archiver($curr_at);
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
                $author_name = $author->author_nickname;
                $author_name or $author_name =
                    $mt->translate('(Display Name not set)');
                $author_name .= ': ';
            }
        }
        return $author_name;
    }

    public function prepare_list($row) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $author_id = $row['entry_author_id'];
        $author = $mt->db()->fetch_author($author_id);
        $ctx->stash('author', $author);
    }
}

class YearlyAuthorBasedArchiver extends DateBasedAuthorArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('AUTHOR-YEARLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $author_name = parent::get_author_name();
        $stamp = $ctx->stash('current_timestamp');
        list($start) = start_end_year($stamp, $ctx->stash('blog'));
        $format = isset($args['format']) ? $args['format'] : null;
        $blog = $ctx->stash('blog');

        $lang = ($blog && $blog->blog_language ? $blog->blog_language :
            $mt->config('DefaultLanguage'));
            if (strtolower($lang) == 'jp' || strtolower($lang) == 'ja') {
            $format or $format = "%Y&#24180;";
        } else {
            $format or $format = "%Y";
        }

        return encode_html( strip_tags( $author_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d", $period_start['y'], isset($period_start['m']) ? $period_start['m'] : 1);
        return start_end_year($period_start);
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';
        $year_ext = $mt->db()->apply_extract_date('year', 'entry_authored_on');
        $index = $ctx->stash('index_archive');
        #if (!$index) {
            $author = $ctx->stash('archive_author');
            $author or $author = $ctx->stash('author');
            if (isset($author)) {
                $author_filter = " and entry_author_id=".$author->author_id;
            }
        #}
        $sql = implode(' ', array(
            "select count(*) as record_count, $year_ext as y, entry_author_id, author_name",
            "from mt_entry join mt_author on entry_author_id = author_id",
            "where entry_blog_id = $blog_id and entry_class = 'entry' and entry_status = 2",
            isset($author_filter) ? $author_filter : '',
            "group by $year_ext, entry_author_id, author_name order by author_name $auth_order, $year_ext $order"
        ));

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['author_yearly_archive'] = 1;
        $array['archive_class']         = 'author-yearly-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += YearlyAuthorBasedArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_year';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($result)) {
            $count = count($results);
            
            $args['hi'] = sprintf("%04d0000000000", $results[0]['y']);
            $args['low'] = sprintf("%04d0000000000", $results[$count - 1]['y']);
        }
        return $args;
    }
}

class MonthlyAuthorBasedArchiver extends DateBasedAuthorArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('AUTHOR-MONTHLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $author_name = parent::get_author_name();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_month($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%B %Y';
        return encode_html( strip_tags( $author_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d", $period_start['y'], $period_start['m']);
        return start_end_month($period_start);
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';
        $year_ext = $mt->db()->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $mt->db()->apply_extract_date('month', 'entry_authored_on');
        $index = $ctx->stash('index_archive');

        #if (!$index) {
            $author = $ctx->stash('archive_author');
            $author or $author = $ctx->stash('author');
            if (isset($author)) {
                $author_filter = " and entry_author_id=".$author->author_id;
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
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and (entry_authored_on between '$ts' and '$tsend')";
            }
        }

        $sql = implode(' ', array(
            "select count(*) as record_count, $year_ext as y, $month_ext as m, entry_author_id, author_name",
            'from mt_entry join mt_author on entry_author_id = author_id',
            "where entry_blog_id = $blog_id and entry_status = 2 and entry_class = 'entry'",
            isset($date_filter) ? $date_filter : '',
            isset($author_filter) ? $author_filter : '',
            "group by $year_ext, $month_ext, entry_author_id, author_name",
            "order by author_name $auth_order, $year_ext $order, $month_ext $order",
        ));

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['archive_class']                  = 'author-monthly-archive';
        $array['author_monthly_archive']         = 1;
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += MonthlyAuthorBasedArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_month';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);
            $hi = sprintf("%04d%02d00000000", $results[0]['y'], $results[0]['m']);
            $low = sprintf("%04d%02d00000000", $results[$count - 1]['y'], $results[$count - 1]['m']);
        }
        return $args;
    }
}

class DailyAuthorBasedArchiver extends DateBasedAuthorArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('AUTHOR-DAILY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $author_name = parent::get_author_name($ctx);
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_day($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%x';
        return encode_html( strip_tags( $author_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d%02d", $period_start['y'], $period_start['m'], $period_start['d']);
        return start_end_day($period_start);
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';
        $year_ext = $mt->db()->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $mt->db()->apply_extract_date('month', 'entry_authored_on');
        $day_ext = $mt->db()->apply_extract_date('day', 'entry_authored_on');

        $index = $ctx->stash('index_archive');
        $author_filter = '';
        #if (!$index) {
            $author = $ctx->stash('archive_author');
            $author or $author = $ctx->stash('author');
            if (isset($author)) {
                $author_filter = " and entry_author_id=".$author->author_id;
            }
        #}
        $inside = $ctx->stash('inside_archive_list');
        if (!isset($inside)) {
          $inside = false;
        }
        $date_filter = '';
        if ($inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and (entry_authored_on between '$ts' and '$tsend')";
            }
        }

        $sql = "
            select count(*) as entry_count,
                   $year_ext as y,
                   $month_ext as m,
                   $day_ext as d,
                   entry_author_id,
                   author_name
              from mt_entry
                   join mt_author on entry_author_id = author_id
             where entry_blog_id = $blog_id
                   and entry_status = 2
                   and entry_class = 'entry'
                   $date_filter
                   $author_filter
             group by
                   $year_ext,
                   $month_ext,
                   $day_ext,
                   entry_author_id,
                   author_name
             order by
                   author_name $auth_order,
                   $year_ext $order,
                   $month_ext $order,
                   $day_ext $order";

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['author_daily_archive'] = 1;
        $array['archive_class']        = 'author-daily-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += DailyAuthorBasedArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_day';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($result)) {
            $count = count($results);
            
            $args['hi'] = sprintf("%04d%02d%02d000000", $results[0]['y'], $results[0]['m'], $results[0]['d']);
            $args['low'] = sprintf("%04d%02d%02d000000", $results[$count - 1]['y'], $results[0]['m'], $results[0]['d']);
        }
        return $args;
    }
}

class WeeklyAuthorBasedArchiver extends DateBasedAuthorArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('AUTHOR-WEEKLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $author_name = parent::get_author_name($ctx);
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start, $end) = start_end_week($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%x';
        return encode_html( strip_tags( $author_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx)
            . ' - ' . $ctx->_hdlr_date(array('ts' => $end, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        if (is_array($period_start)) {
            require_once('MTUtil.php');
            $week_yr = substr($period_start['entry_week_number'], 0, 4);
            $week_num = substr($period_start['entry_week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);

            $period_start = sprintf("%04d%02d%02d000000", $y, $m, $d);
        }
        return start_end_week($period_start);
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';
        $year_ext = $mt->db()->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $mt->db()->apply_extract_date('month', 'entry_authored_on');
        $day_ext = $mt->db()->apply_extract_date('day', 'entry_authored_on');

        $index = $ctx->stash('index_archive');
        #if (!$index) {
            $author = $ctx->stash('archive_author');
            $author or $author = $ctx->stash('author');
            if (isset($author)) {
                $author_filter = " and entry_author_id=".$author->author_id;
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
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and (entry_authored_on between '$ts' and '$tsend')";
            }
        }

        $sql = implode(' ' , array(
            "select count(*) as record_count, entry_week_number, entry_author_id, author_name",
            "from mt_entry", 
            "join mt_author on entry_author_id = author_id",
            "where entry_blog_id = $blog_id and entry_status = 2 and entry_class = 'entry'",
            isset($date_filter) ? $date_filter : '',
            isset($author_filter) ? $author_filter : '',
            "group by entry_week_number, entry_author_id, author_name",
            "order by author_name $auth_order, entry_week_number $order"
        ));
        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['author_weekly_archive'] = 1;
        $array['archive_class']         = 'author-weekly-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += WeeklyAuthorBasedArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_week';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);

            require_once("MTUtil.php");
            $week_yr = substr($results[0]['entry_week_number'], 0, 4);
            $week_num = substr($results[0]['entry_week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);
            $args['hi'] = sprintf("%04d%02d%02d", $y, $m, $d);

            $week_yr = substr($results[$count - 1]['entry_week_number'], 0, 4);
            $week_num = substr($results[$count - 1]['entry_week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);
            $args['low'] = sprintf("%04d%02d%02d", $y, $m, $d);
        }
        return $args;
    }
}

class CategoryArchiver implements ArchiveType {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CATEGORY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $cat_name = $this->get_category_name();
        return encode_html( strip_tags( $cat_name ) );
    }

    protected function get_category_name () {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $curr_at = $ctx->stash('current_archive_type');
        $archiver = ArchiverFactory::get_archiver($curr_at);
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
                $cat_name = $cat->category_label;
            }
        }
        return $cat_name;
    }

    public function get_archive_list($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $results = $this->get_archive_list_data($args);

        if(!empty($results)) {
            $update_args['blog_id'] = $args['blog_id'];
            $update_args['archive_type'] = $ctx->stash('current_archive_type');
            $mt->db()->update_archive_link_cache($update_args);
        }
        return $results;
    }

    public function get_archive_link_sql($ts, $at, $args) { return ''; }

    public function archive_prev_next($args, $content, &$repeat, $tag, $at) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        if ($tag == 'archiveprevious') {
            require_once('block.mtcategoryprevious.php');
            return smarty_block_mtcategoryprevious($args, $content, $ctx, $repeat);
        } elseif ($tag == 'archivenext') {
            require_once('block.mtcategorynext.php');
            return smarty_block_mtcategorynext($args, $content, $ctx, $repeat);
        }

        return $ctx->error("Error in tag: $tag");
    }

    public function prepare_list($row) { return true; }

    public function setup_args(&$args) { return true; }

    protected function get_archive_list_data($args) { return true; }

    public function get_template_params() {
        $array = array(
            'archive_template'       => 1,
            'category_archive'       => 1,
            'category_based_archive' => 1,
            'archive_class'          => 'category-archive',
            'archive_listing'        => 1
        );
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $vars =& $ctx->__stash['vars'];
        $vars += CategoryArchiver::get_template_params();
    }

    public function is_date_based() {
        return false;
    }

    public function get_range($period_start) {
        return null;
    }
}

abstract class DateBasedCategoryArchiver extends DateBasedArchiver {

    public function setup_args(&$args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        if ($cat = $ctx->stash('category')) {
            $args['category_id'] = $cat->category_id;
        }
    }

    public function get_archive_link_sql($ts, $at, $args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = intval($args['blog_id']);
        $blog_id or $blog_id = intval($ctx->stash('blog_id'));
        $cat = $ctx->stash('category');
        $cat_id = $cat->category_id;
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

        $sql = implode(' ', array(
            "fileinfo_blog_id = $blog_id and fileinfo_archive_type = '". $mt->db()->escape($at). "'",
            "and fileinfo_category_id = '$cat_id' and templatemap_is_preferred = 1",
            isset($start_filter) ? $start_filter : '',
            isset($order) ? $order : ''
        ));
        return $sql;
    }

    public function archive_prev_next($args, $content, &$repeat, $tag, $at) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

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

            if ($entry = $this->get_categorized_entry($ts, $ctx->stash('blog_id'), $category->category_id, $at, $order)) {
                $helper = $this->get_helper($at);
                $ctx->stash('entries', array( $entry ));
                list($start, $end) = $helper($entry->entry_authored_on);
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

    protected function get_categorized_entry($ts, $blog_id, $cat_id, $at, $order) {
        $helper = $this->get_helper();
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

        $mt = MT::get_instance();
        list($entry) = $mt->db()->fetch_entries($args);
        return $entry;
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['archive_class']            = 'category-archive';
        $array['category_based_archive']   = 1;
        $array['archive_template']         = 1;
        $array['archive_listing']          = 1;
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += DateBasedCategoryArchiver::get_template_params();
    }

    protected function get_category_name () {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $curr_at = $ctx->stash('current_archive_type');
        $archiver = ArchiverFactory::get_archiver($curr_at);
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
                $cat_name = $cat->category_label.": ";
            }
        }
        return $cat_name;
    }

    public function prepare_list($row) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $category_id = $row['placement_category_id'];
        $category = $mt->db()->fetch_category($category_id);
        $ctx->stash('category', $category);
    }

}

class YearlyCategoryArchiver extends DateBasedCategoryArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CATEGORY-YEARLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $cat_name = parent::get_category_name();
        $stamp = $ctx->stash('current_timestamp');
        list($start) = start_end_year($stamp, $ctx->stash('blog'));
        $format = isset($args['format']) ? $args['format'] : null;
        $blog = $ctx->stash('blog');

        $lang = ($blog && $blog->blog_language ? $blog->blog_language :
            $mt->config('DefaultLanguage'));
            if (strtolower($lang) == 'jp' || strtolower($lang) == 'ja') {
            $format or $format = "%Y&#24180;";
        } else {
            $format or $format = "%Y";
        }
        return encode_html( strip_tags( $cat_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        if (is_array($period_start))
            $period_start = sprintf("%04d", $period_start['y']);
        return start_end_year($period_start);
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';
        $year_ext = $mt->db()->apply_extract_date('year', 'entry_authored_on');

        $index = $ctx->stash('index_archive');
        $inside = $ctx->stash('inside_archive_list');
        if (!isset($inside)) {
          $inside = false;
        }
        if ($inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and entry_authored_on between '$ts' and '$tsend'";
            }
        }
        #if (!$index) {
            $cat = $ctx->stash('archive_category');
            $cat or $cat = $ctx->stash('category');
            if (isset($cat)){
                $cat_filter = " and placement_category_id=".$cat->category_id;

            }
        #}
        $sql = join(' ', array(
            "select count(*) as entry_count,
                $year_ext as y,
                placement_category_id,
                category_label
            from mt_entry join mt_placement on entry_id = placement_entry_id
            join mt_category on placement_category_id = category_id
            where entry_blog_id = $blog_id
                and entry_status = 2
                and entry_class = 'entry'",
            isset($cat_filter) ? $cat_filter : '',
            isset($date_filter) ? $date_filter : '',
            "group by $year_ext, placement_category_id, category_label",
            "order by category_label $cat_order, $year_ext $order"
        ));
        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['category_yearly_archive'] = 1;
        $array['archive_class']           = 'category-yearly-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += YearlyCategoryArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_year';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($result)) {
            $count = count($results);
            
            $args['hi'] = sprintf("%04d0000000000", $results[0]['y']);
            $args['low'] = sprintf("%04d0000000000", $results[$count - 1]['y']);
        }
        return $args;
    }
}

class MonthlyCategoryArchiver extends DateBasedCategoryArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CATEGORY-MONTHLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $cat_name = parent::get_category_name($ctx);
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_month($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%B %Y';
        return encode_html( strip_tags( $cat_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d", $period_start['y'], $period_start['m']);
        return start_end_month($period_start);
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';
        $year_ext = $mt->db()->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $mt->db()->apply_extract_date('month', 'entry_authored_on');

        $index = $ctx->stash('index_archive');
        $inside = $ctx->stash('inside_archive_list');
        if (!isset($inside)) {
          $inside = false;
        }
        if ($inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and entry_authored_on between '$ts' and '$tsend'";
            }
        }
        #if (!$index) {
            $cat = $ctx->stash('archive_category');
            $cat or $cat = $ctx->stash('category');
            if(isset($cat)) {
                $cat_filter = " and placement_category_id=".$cat->category_id;

            }
        #}
        $sql = implode(' ', array(
            'select count(*) as entry_count,',
            "$year_ext as y,",
            "$month_ext as m,",
            'placement_category_id,',
            'category_label',
            "from mt_entry join mt_placement on entry_id = placement_entry_id",
            "join mt_category on placement_category_id = category_id",
            "where entry_blog_id = $blog_id and entry_status = 2 and entry_class = 'entry'",
            isset($cat_filter) ? $cat_filter : '',
            isset($date_filter) ? $date_filter : '',
            "group by $year_ext, $month_ext, placement_category_id, category_label",
            "order by category_label $cat_order, $year_ext $order, $month_ext $order"
        ));

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['archive_class']                    = 'category-monthly-archive';
        $array['category_monthly_archive']         = 1;
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += MonthlyCategoryArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_month';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);
            $hi = sprintf("%04d%02d00000000", $results[0]['y'], $results[0]['m']);
            $low = sprintf("%04d%02d00000000", $results[$count - 1]['y'], $results[$count - 1]['m']);
        }
        return $args;
    }
}

class DailyCategoryArchiver extends DateBasedCategoryArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CATEGORY-DAILY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $cat_name = parent::get_category_name();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_day($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%x';
        return encode_html( strip_tags( $cat_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d%02d", $period_start['y'], $period_start['m'], $period_start['d']);
        return start_end_day($period_start);
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';
        $year_ext = $mt->db()->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $mt->db()->apply_extract_date('month', 'entry_authored_on');
        $day_ext = $mt->db()->apply_extract_date('day', 'entry_authored_on');

        $index = $ctx->stash('index_archive');
        $inside = $ctx->stash('inside_archive_list');
        if (!isset($inside)) {
            $inside = false;
        }
        if ($inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and entry_authored_on between '$ts' and '$tsend'";
            }
        }
        #if (!$index) {
            $cat = $ctx->stash('archive_category');
            $cat or $cat = $ctx->stash('category');
            if(isset($cat)) {
                $cat_filter = " and placement_category_id=".$cat->category_id;

            }
        #}
        $sql = implode(' ', array(
            "select count(*) as entry_count, $year_ext as y, $month_ext as m, $day_ext as d, placement_category_id, category_label",
            'from mt_entry join mt_placement on entry_id = placement_entry_id',
            "join mt_category on placement_category_id = category_id",
            "where entry_blog_id = $blog_id and entry_status = 2 and entry_class = 'entry'",
            isset($cat_filter) ? $cat_filter : '',
            isset($date_filter) ? $date_filter : '',
            "group by placement_category_id, $year_ext, $month_ext, $day_ext, category_label",
            "order by category_label $cat_order, $year_ext $order, $month_ext $order, $day_ext $order",
        ));
        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }    

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['category_daily_archive'] = 1;
        $array['archive_class']          = 'category-daily-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += DailyCategoryArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_day';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($result)) {
            $count = count($results);
            
            $args['hi'] = sprintf("%04d%02d%02d000000", $results[0]['y'], $results[0]['m'], $results[0]['d']);
            $args['low'] = sprintf("%04d%02d%02d000000", $results[$count - 1]['y'], $results[0]['m'], $results[0]['d']);
        }
        return $args;
    }
}

class WeeklyCategoryArchiver extends DateBasedCategoryArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CATEGORY-WEEKLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $cat_name = parent::get_category_name();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start, $end) = start_end_week($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%x';
        return encode_html( strip_tags( $cat_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx)
            . " - " . $ctx->_hdlr_date(array('ts' => $end, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        if (is_array($period_start)) {
            require_once('MTUtil.php');
            $week_yr = substr($period_start['entry_week_number'], 0, 4);
            $week_num = substr($period_start['entry_week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);

            $period_start = sprintf("%04d%02d%02d000000", $y, $m, $d);
        }
        return start_end_week($period_start, $ctx->stash('blog'));
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';

        $index = $ctx->stash('index_archive');
        $inside = $ctx->stash('inside_archive_list');
        if (!isset($inside)) {
          $inside = false;
        }
        if ($inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and entry_authored_on between '$ts' and '$tsend'";
            }
        }
        #if (!$index) {
            $cat = $ctx->stash('archive_category');
            $cat or $cat = $ctx->stash('category');
            if(isset($cat)) {
                $cat_filter = " and placement_category_id=".$cat->category_id;

            }
        #}
        $sql = implode(' ', array(
            "select count(*) as entry_count, entry_week_number, placement_category_id, category_label",
            "from mt_entry join mt_placement on entry_id = placement_entry_id",
            "join mt_category on placement_category_id = category_id",
            "where entry_blog_id = $blog_id and entry_status = 2 and entry_class = 'entry'",
            isset($cat_filter) ? $cat_filter : '',
            isset($date_filter) ? $date_filter : '',
            "group by entry_week_number, placement_category_id, category_label",
            "order by category_label $cat_order, entry_week_number $order"
        ));
        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['category_weekly_archive'] = 1;
        $array['archive_class']           = 'category-weekly-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += WeeklyCategoryArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_week';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);

            require_once("MTUtil.php");
            $week_yr = substr($results[0]['entry_week_number'], 0, 4);
            $week_num = substr($results[0]['entry_week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);
            $args['hi'] = sprintf("%04d%02d%02d", $y, $m, $d);

            $week_yr = substr($results[$count - 1]['entry_week_number'], 0, 4);
            $week_num = substr($results[$count - 1]['entry_week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);
            $args['low'] = sprintf("%04d%02d%02d", $y, $m, $d);
        }
        return $args;
    }
}

class ContentTypeArchiver implements ArchiveType {
    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate("CONTENTTYPE_ADV");
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        return encode_html( strip_tags( $ctx->tag('ContentLabel', $args) ) );
    }

    public function get_range($period_start) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $period_start = preg_replace('/[^0-9]/', '', $period_start);
        return start_end_day($period_start, $ctx->stash('blog'));
    }

    public function get_archive_list($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        list($results) = $this->get_archive_list_data($args);
        return $results;
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $content_type_filter = _get_content_type_filter($args);

        list($dt_target_col, $cat_target_col, $join_on, $dt_field_id) = _get_join_on($ctx, $at, $blog_id);
        $content_field_filder = '';
        if (isset($dt_field_id) && $dt_field_id) {
            $content_field_filter = "and dt_cf_idx.cf_idx_content_field_id = $dt_field_id";
        }

        $sql = implode(' ' , array(
            "cd_blog_id = $blog_id and cd_status = 2",
            isset($content_type_filter) ? $content_type_filter : '',
            isset($content_field_filter) ? $content_field_filter : '',
            "order by $dt_target_col $order, cd_id asc"
        ));
        $extras = array();
        $extras['limit'] = isset($args['lastn']) ? $args['lastn'] : -1;
        $extras['offset'] = isset($args['offset']) ? $args['offset'] : -1;
        if (isset($dt_field_id) && $dt_field_id) {
            $extras['join'] = array(
                'mt_cf_idx dt_cf_idx' => array(
                    'condition' => 'cd_id = dt_cf_idx.cf_idx_content_data_id'
                )
            );
        }

        require_once('class.mt_content_data.php');
        $content = new ContentData();
        $results = $content->Find($sql, false, false, $extras);
        return empty($results) ? null : array($results, null, null);
    }

    public function archive_prev_next($args, $content, &$repeat, $tag, $at) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $tag = $ctx->this_tag();
        if ($tag == 'mtarchivenext') {
            require_once("block.mtcontentnext.php");
            return smarty_block_mtcontentnext($args, $content, $ctx, $repeat);
        } else {
            require_once("block.mtcontentprevious.php");
            return smarty_block_mtcontentprevious($args, $content, $ctx, $repeat);
        }
    }

    public function prepare_list($row) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $ctx->stash('content', $row);
        $ctx->stash('contents', array($row));
    }

    public function get_template_params() {
        $array = array(
            'contenttype_archive' => 1,
            'archive_template'    => 1,
            'archive_class'       => 'contenttype-archive'
        );
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeArchiver::get_template_params();
    }

    public function setup_args(&$args) {
        return true;
    }

    public function get_archive_link_sql($ts, $at, $args) {
        return '';
    }

    public function is_date_based() {
        return false;
    }
}

abstract class ContentTypeDateBasedArchiver implements ArchiveType {

    abstract protected function get_update_link_args($results);
    abstract protected function get_helper();

    public function is_date_based() { return true; }

    public function prepare_list($row) { return true; }

    public function setup_args(&$args) { return true; }

    public function get_archive_link_sql($ts, $at, $args) { return ''; }

    public function archive_prev_next($args, $res, &$repeat, $tag, $at) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $localvars = array('current_timestamp', 'current_timestamp_end', 'contents');
        if (!isset($res)) {
            $ctx->localize($localvars);
            $is_prev = $tag == 'archiveprevious';
            $ts = $ctx->stash('current_timestamp');
            if (!$ts) {
                return $ctx->error(
                   "You used an <mt$tag> without a date context set up.");
            }
            $order = $is_prev ? 'previous' : 'next';
            $helper = $this->get_helper();
            $blog_id = $ctx->stash('blog_id');
            $content_type_id = $ctx->stash('content_type')->id;
            if ($cd = $this->get_content($ts, $blog_id, $at, $order, $content_type_id)) {
                $ctx->stash('contents', array($cd));
                $maps = $ctx->mt->db()->fetch_templatemap(array(
                    'blog_id'         => $blog_id,
                    'content_type_id' => $content_type_id,
                    'preferred'       => 1,
                    'type'            => $at
                ));
                if (isset($maps)) {
                    if (!empty($maps) && is_array($maps)) {
                        $dt_field_id = $maps[0]->templatemap_dt_field_id;
                    }
                    if ($dt_field_id) {
                        $data = $cd->data();
                        $ts = $data[$dt_field_id];
                    }
                    else {
                        $ts = $cd->authored_on;
                    }
                }
                list($start, $end) = $helper($ts);
                $ctx->stash('current_timestamp', $start);
                $ctx->stash('current_timestamp_end', $end);
            } else {
                $ctx->restore($localvars);
                $repeat = false;
            }
        } else {
            $ctx->restore($localvars);
        }
        return $res;
    }

    public function get_archive_list($args) {
        $mt = MT::get_instance();

        $ctx =& $mt->context();

        $results = $this->get_archive_list_data($args);

        if (!empty($results)) {
                $update_args = $this->get_update_link_args($results);
                $args = array_merge($args, $update_args);

                $mt->db()->update_archive_link_cache($args);
        }

        return $results;
    }

    protected function get_archive_list_data($args) {
        return array();
    }

    protected function get_content($ts, $blog_id, $at, $order, $content_type_id) {
        $helper = $this->get_helper();
        list($start, $end) = $helper($ts);
        $args = array();
        if ($order == 'previous') {
            $args['current_timestamp_end'] = $this->dec_ts($start);
        } else {
            $args['current_timestamp'] = $this->inc_ts($end);
            $args['base_sort_order'] = 'ascend'; # ascending order
        }
        $args['_current_timestamp_sort'] = true;
        $args['lastn'] = 1;
        $args['blog_id'] = $blog_id;
        $mt = MT::get_instance();
        list($content) = $mt->db()->fetch_contents($args, $content_type_id);
        return $content;
    }

    protected function dec_ts($ts) {
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

    protected function inc_ts($ts) {
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

    public function get_template_params() {
        $array = array(
            'archive_listing'             => 1,
            'contenttype_archive_listing' => 1,
            'archive_template'            => 1,
            'datebased_archive'           => 1
        );
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeDateBasedArchiver::get_template_params();
    }
}

class ContentTypeDailyArchiver extends ContentTypeDateBasedArchiver {
    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CONTENTTYPE-DAILY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_day($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%x';
        return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d%02d", $period_start['y'], $period_start['m'], $period_start['d']);
        return start_end_day($period_start, $ctx->stash('blog'));
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['datebased_only_archive']  = 1;
        $array['datebased_daily_archive'] = 1;
        $array['archive_class']           = 'contenttype-daily-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeDailyArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_day';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);
            $args['hi'] = sprintf("%04d%02d32", $results[0]['y'], $results[0]['m']);
            $args['low'] = sprintf("%04d%02d00", $results[$count - 1]['y'], $results[0]['m']);
        }
        return $args;
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $content_type_filter = _get_content_type_filter($args);

        list($dt_target_col, $cat_target_col, $join_on) = _get_join_on($ctx, $at, $blog_id);

        $inside = $ctx->stash('inside_archive_list');
        if (isset($inside) && $inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and ($dt_target_col between '$ts' and '$tsend')";
            }
        }

        $year_ext = $mt->db()->apply_extract_date('year', $dt_target_col);
        $month_ext = $mt->db()->apply_extract_date('month', $dt_target_col);
        $day_ext = $mt->db()->apply_extract_date('day', $dt_target_col);

        $sql = implode(' ', array(
            "select count(*) as cd_count,",
            "$year_ext as y,",
            "$month_ext as m,",
            "$day_ext as d",
            'from mt_cd',
            $join_on,
            "where cd_blog_id = $blog_id",
            'and cd_status = 2',
           isset($date_filter) ? $date_filter : '',
           isset($content_type_filter) ? $content_type_filter : '',
           "group by $year_ext, $month_ext, $day_ext",
           "order by $year_ext $order, $month_ext $order, $day_ext $order"
        ));

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);

        return empty($results) ? null : $results->GetArray();
    }
}

class ContentTypeWeeklyArchiver extends ContentTypeDateBasedArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CONTENTTYPE-WEEKLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start, $end) = start_end_week($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%x';
        return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx)
            . ' - ' .
            $ctx->_hdlr_date(array('ts' => $end, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        if (is_array($period_start)) {
            require_once('MTUtil.php');
            $week_yr = substr($period_start['week_number'], 0, 4);
            $week_num = substr($period_start['week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);

            $period_start = sprintf("%04d%02d%02d000000", $y, $m, $d);
        }
        return start_end_week($period_start, $ctx->stash('blog'));
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['datebased_only_archive']   = 1;
        $array['datebased_weekly_archive'] = 1;
        $array['archive_class']            = 'contenttype-weekly-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeWeeklyArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_week';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);

            require_once("MTUtil.php");
            $week_yr = substr($results[0]['week_number'], 0, 4);
            $week_num = substr($results[0]['week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);
            $args['hi'] = sprintf("%04d%02d%02d", $y, $m, $d);

            $week_yr = substr($results[$count - 1]['week_number'], 0, 4);
            $week_num = substr($results[$count - 1]['week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);
            $args['low'] = sprintf("%04d%02d%02d", $y, $m, $d);
        }
        return $args;
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $content_type_filter = _get_content_type_filter($args);

        list($dt_target_col, $cat_target_col, $join_on) = _get_join_on($ctx, $at, $blog_id);

        $inside = $ctx->stash('inside_archive_list');
        if (isset($inside) && $inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and ($dt_target_col between '$ts' and '$tsend')";
            }
        }
        $week_number = $dt_target_col === 'cd_authored_on' ? 'cd_week_number' : 'cf_idx_value_integer';

        $sql = implode(' ', array(
            "select count(*) as cd_count, $week_number week_number",
            "from mt_cd",
            $join_on,
            "where cd_blog_id = $blog_id and cd_status = 2",
            isset($date_filter) ? $date_filter : '',
            $content_type_filter,
            "group by $week_number",
            "order by $week_number $order",
        ));

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);

        return empty($results) ? null : $results->GetArray();
    }
}

class ContentTypeMonthlyArchiver extends ContentTypeDateBasedArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CONTENTTYPE-MONTHLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_month($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%B %Y';
        return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d", $period_start['y'], $period_start['m']);
        return start_end_month($period_start, $ctx->stash('blog'));
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['datebased_only_archive']    = 1;
        $array['datebased_monthly_archive'] = 1;
        $array['archive_class']             = 'contenttype-monthly-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeMonthlyArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_month';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);
            $args['hi'] = sprintf("%04d%02d32", $results[0]['y'], $results[0]['m']);
            $args['low'] = sprintf("%04d%02d00", $results[$count - 1]['y'], $results[0]['m']);
        }
        return $args;
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $content_type_filter = _get_content_type_filter($args);

        list($dt_target_col, $cat_target_col, $join_on) = _get_join_on($ctx, $at, $blog_id);

        $inside = $ctx->stash('inside_archive_list');
        if (isset($inside) && $inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and ($dt_target_col between '$ts' and '$tsend')";
            }
        }

        $year_ext = $mt->db()->apply_extract_date('year', $dt_target_col);
        $month_ext = $mt->db()->apply_extract_date('month', $dt_target_col);

        $sql = implode(' ', array(
            "select count(*) as cd_count, $year_ext as y, $month_ext as m",
            "from mt_cd",
            $join_on,
            "where cd_blog_id = $blog_id and cd_status = 2",
            isset($date_filter) ? $date_filter : '',
            isset($content_type_filter) ? $content_type_filter : '',
            "group by $year_ext, $month_ext",
            "order by $year_ext $order, $month_ext $order"
        ));

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }
}

class ContentTypeYearlyArchiver extends ContentTypeDateBasedArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CONTENTTYPE-YEARLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_year($stamp, $ctx->stash('blog'));
        $format = isset($args['format']) ? $args['format'] : null;
        $blog = $ctx->stash('blog');
        $lang = ($blog && $blog->blog_language ? $blog->blog_language :
            $mt->config('DefaultLanguage'));
            if (strtolower($lang) == 'jp' || strtolower($lang) == 'ja') {
            $format or $format = "%Y&#24180;";
        } else {
            $format or $format = "%Y";
        }

        return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        if (is_array($period_start))
            $period_start = sprintf("%04d", $period_start['y']);

        return start_end_year($period_start, $ctx->stash('blog'));
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);
            $args['hi'] = sprintf("%04d1231235959", $results[0]['y']);
            $args['low'] = sprintf("%04d0101000000", $results[$count - 1]['y']);
        }
        return $args;
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['datebased_only_archive']   = 1;
        $array['datebased_yearly_archive'] = 1;
        $array['archive_class']            = 'contenttype-yearly-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeYearlyArchiver::get_template_params();
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $content_type_filter = _get_content_type_filter($args);

        list($dt_target_col, $cat_target_col, $join_on) = _get_join_on($ctx, $at, $blog_id);

        $year_ext = $mt->db()->apply_extract_date('year', $dt_target_col);

        $sql = "
                select count(*) as cd_count,
                       $year_ext as y
                  from mt_cd
                  $join_on
                 where cd_blog_id = $blog_id
                   and cd_status = 2
                   $content_type_filter
                 group by
                       $year_ext
                 order by
                       $year_ext $order";

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    protected function get_helper() {
        return 'start_end_year';
    }
}

class ContentTypeAuthorArchiver implements ArchiveType {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CONTENTTYPE-AUTHOR_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $author_name = '';
        $author = $ctx->stash('archive_author');
        if (!isset($archive_author)) {
            $author = $ctx->stash('author');
            if (isset($author)) {
                $author_name = $author->author_nickname;
                $author_name or $author_name =
                    $mt->translate('(Display Name not set)');
            }
        }
        return encode_html( strip_tags( $author_name ) );
    }

    public function get_archive_list($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $results = $this->get_archive_list_data($args);

        if(!empty($results)) {
            $update_args['blog_id'] = $args['blog_id'];
            $update_args['archive_type'] = $ctx->stash('current_archive_type');
            $mt->db()->update_archive_link_cache($update_args);
        }
        return $results;
    }

    public function get_archive_link_sql($ts, $at, $args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = intval($args['blog_id']);
        $author = $ctx->stash('author');
        if ( empty( $author ) ) {
            $entry = $ctx->stash('entry');
            if ( !empty( $entry ) ) {
                $author = $entry->author();
            }
            $content = $ctx->stash('content');
            if ( !empty( $content ) ) {
                $author = $content->author();
            }
        }
        $auth_id = $author->author_id;
        $at or $at = $ctx->stash('current_archive_type');

        $sql = " fileinfo_blog_id = $blog_id
                 and fileinfo_archive_type = '".$mt->db()->escape($at)."'
                 and fileinfo_author_id = '$auth_id'
                 and templatemap_is_preferred = 1";
        return $sql;
    }

    public function archive_prev_next($args, $content, &$repeat, $tag, $at) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        if ($tag == 'archiveprevious') {
            require_once('block.mtauthorprevious.php');
            return smarty_block_mtauthorprevious($args, $content, $ctx, $repeat);
        } elseif ($tag == 'archivenext') {
            require_once('block.mtauthornext.php');
            return smarty_block_mtauthornext($args, $content, $ctx, $repeat);
        }

        return $ctx->error("Error in tag: $tag");
    }

    public function prepare_list($row) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $author_id = $row['cd_author_id'];
        $author = $mt->db()->fetch_author($author_id);
        $ctx->stash('author', $author);
    }

    public function setup_args(&$args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        if ($auth = $ctx->stash('author')) {
            $args['author'] = $auth->author_name;
        }
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $blog_id = $args['blog_id'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';

        $content_type_filter = _get_content_type_filter($args);

        $sql = implode(' ', array(
            'select count(*) as cd_count, cd_author_id, author_name',
            'from mt_cd',
            'join mt_author on cd_author_id = author_id',
            "where cd_blog_id = $blog_id and cd_status = 2",
            isset($content_type_filter) ? $content_type_filter : '',
            "group by cd_author_id, author_name order by author_name $order"
        ));
        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function get_template_params() {
        $array = array(
            'archive_template'            => 1,
            'author_archive'              => 1,
            'author_based_archive'        => 1,
            'archive_class'               => 'contenttype-author-archive',
            'archive_listing'             => 1,
            'contenttype_archive_listing' => 1
        );
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeAuthorArchiver::get_template_params();
    }

    public function is_date_based() {
        return false;
    }

    public function get_range($period_start) {
        return null;
    }
}

abstract class ContentTypeDateBasedAuthorArchiver extends ContentTypeDateBasedArchiver {

    public function setup_args(&$args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        if ($auth = $ctx->stash('author')) {
            $args['author'] = $auth->author_name;
        }
    }

    public function get_archive_link_sql($ts, $at, $args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = intval($args['blog_id']);
        $author = $ctx->stash('author');
        $auth_id = $author->author_id;
        $at or $at = $ctx->stash('current_archive_type');
        $ts = $ctx->stash('current_timestamp');

        if ($at == 'ContentType-Author-Monthly') {
            $ts = substr($ts, 0, 6) . '01000000';
        } elseif ($at == 'ContentType-Author-Daily') {
            $ts = substr($ts, 0, 8) . '000000';
        } elseif ($at == 'ContentType-Author-Weekly') {
            require_once("MTUtil.php");
            list($ws, $we) = start_end_week($ts);
            $ts = $ws;
        } elseif ($at == 'ContentType-Author-Yearly') {
            $ts = substr($ts, 0, 4) . '0101000000';
        } else {
            $ts = '';
        }

        $sql = ($ts ? "fileinfo_startdate = '$ts' and" : "") .
               " fileinfo_blog_id = $blog_id
                 and fileinfo_archive_type = '".$mt->db()->escape($at)."'
                 and fileinfo_author_id = '$auth_id'
                 and templatemap_is_preferred = 1";
        return $sql;
    }

    public function archive_prev_next($args, $content, &$repeat, $tag, $at) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $localvars = array('current_timestamp', 'current_timestamp_end', 'contents', 'author');
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
            $blog_id = $ctx->stash('blog_id');
            $content_type_id = $ctx->stash('content_type')->id;
            $maps = $ctx->mt->db()->fetch_templatemap(array(
                'blog_id'         => $blog_id,
                'content_type_id' => $content_type_id,
                'preferred'       => 1,
                'type'            => $at
            ));
            if (!empty($maps) && is_array($maps)) {
                $map = $maps[0];
                $dt_field_id = $map->templatemap_dt_field_id;
            }

            if ($content = $this->get_author_content($ts, $blog_id, $author->author_name, $order, $content_type_id)) {
                $helper = $this->get_helper();
                $ctx->stash('contents', array( $content ));

                if (isset($dt_field_id) && $dt_field_id) {
                    $data = $content->data();
                    list($start, $end) = $helper($data[$dt_field_id]);
                } else {
                    list($start, $end) = $helper($content->cd_authored_on);
                }

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

    public function get_author_content($ts, $blog_id, $auth_name, $order, $content_type_id) {
        $helper = $this->get_helper();
        list($start, $end) = $helper($ts);
        $args = array();
        if ($order == 'previous') {
            $args['current_timestamp_end'] = $this->dec_ts($start);
        } else {
            $args['current_timestamp'] = $this->inc_ts($end);
            $args['base_sort_order'] = 'ascend'; # ascending order
        }
        $args['_current_timestamp_sort'] = true;
        $args['lastn'] = 1;
        $args['blog_id'] = $blog_id;
        $args['author'] = $auth_name;

        $mt = MT::get_instance();
        list($content) = $mt->db()->fetch_contents($args, $content_type_id);
        return $content;
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['author_based_archive'] = 1;
        return $array;
    }

    public function template_params() {
        ContentTypeAuthorArchiver::template_params();
        parent::template_params();
    }

    protected function get_author_name () {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $curr_at = $ctx->stash('current_archive_type');
        $archiver = ArchiverFactory::get_archiver($curr_at);
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
                $author_name = $author->author_nickname;
                $author_name or $author_name =
                    $mt->translate('(Display Name not set)');
                $author_name .= ': ';
            }
        }
        return $author_name;
    }

    public function prepare_list($row) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $author_id = $row['cd_author_id'];
        $author = $mt->db()->fetch_author($author_id);
        $ctx->stash('author', $author);
    }
}

class ContentTypeAuthorYearlyArchiver extends ContentTypeDateBasedAuthorArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CONTENTTYPE-AUTHOR-YEARLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $author_name = parent::get_author_name();
        $stamp = $ctx->stash('current_timestamp');
        list($start) = start_end_year($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : null;
        $blog = $ctx->stash('blog');

        $lang = ($blog && $blog->blog_language ? $blog->blog_language :
            $mt->config('DefaultLanguage'));
            if (strtolower($lang) == 'jp' || strtolower($lang) == 'ja') {
            $format or $format = "%Y&#24180;";
        } else {
            $format or $format = "%Y";
        }

        return encode_html( strip_tags( $author_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d", $period_start['y'], isset($period_start['m']) ? $period_start['m'] : 1);
        return start_end_year($period_start);
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';

        $content_type_filter = _get_content_type_filter($args);

        list($dt_target_col, $cat_target_col, $join_on) = _get_join_on($ctx, $at, $blog_id);

        $year_ext = $mt->db()->apply_extract_date('year', $dt_target_col);

        $author = $ctx->stash('archive_author');
        $author or $author = $ctx->stash('author');
        if (isset($author)) {
            $author_filter = " and cd_author_id=".$author->author_id;
        }

        $sql = implode(' ', array(
            "select count(*) as record_count, $year_ext as y, cd_author_id, author_name",
            "from mt_cd",
            "join mt_author on cd_author_id = author_id $join_on",
            "where cd_blog_id = $blog_id and cd_status = 2",
            isset($author_filter) ? $author_filter : '',
            isset($content_type_filter) ? $content_type_filter : '',
            "group by $year_ext, cd_author_id, author_name",
            "order by author_name $auth_order, $year_ext $order",
        ));

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['author_yearly_archive'] = 1;
        $array['archive_class']         = 'contenttype-author-yearly-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeAuthorYearlyArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_year';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($result)) {
            $count = count($results);
            
            $args['hi'] = sprintf("%04d0000000000", $results[0]['y']);
            $args['low'] = sprintf("%04d0000000000", $results[$count - 1]['y']);
        }
        return $args;
    }
}

class ContentTypeAuthorMonthlyArchiver extends ContentTypeDateBasedAuthorArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CONTENTTYPE-AUTHOR-MONTHLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $author_name = parent::get_author_name();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_month($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%B %Y';
        return encode_html( strip_tags( $author_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d", $period_start['y'], $period_start['m']);
        return start_end_month($period_start);
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';

        $content_type_filter = _get_content_type_filter($args);

        list($dt_target_col, $cat_target_col, $join_on) = _get_join_on($ctx, $at, $blog_id);

        $year_ext = $mt->db()->apply_extract_date('year', $dt_target_col);
        $month_ext = $mt->db()->apply_extract_date('month', $dt_target_col);

        $author = $ctx->stash('archive_author');
        $author or $author = $ctx->stash('author');
        if (isset($author)) {
            $author_filter = " and cd_author_id=".$author->author_id;
        }

        $inside = $ctx->stash('inside_archive_list');
        if (!isset($inside)) {
          $inside = false;
        }
        if ($inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and ($dt_target_col between '$ts' and '$tsend')";
            }
        }

        $sql = implode(' ', array(
            "select count(*) as record_count, $year_ext as y, $month_ext as m, cd_author_id, author_name",
            "from mt_cd",
            "join mt_author on cd_author_id = author_id $join_on",
            "where cd_blog_id = $blog_id and cd_status = 2",
            isset($date_filter) ? $date_filter : '',
            isset($author_filter) ? $author_filter : '',
            isset($content_type_filter) ? $content_type_filter : '',
            "group by $year_ext, $month_ext, cd_author_id, author_name",
            "order by author_name $auth_order, $year_ext $order, $month_ext $order"
        ));

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['archive_class']                  = 'contenttype-author-monthly-archive';
        $array['author_monthly_archive']         = 1;
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeAuthorMonthlyArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_month';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);
            $hi = sprintf("%04d%02d00000000", $results[0]['y'], $results[0]['m']);
            $low = sprintf("%04d%02d00000000", $results[$count - 1]['y'], $results[$count - 1]['m']);
        }
        return $args;
    }
}

class ContentTypeAuthorDailyArchiver extends ContentTypeDateBasedAuthorArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CONTENTTYPE-AUTHOR-DAILY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $author_name = parent::get_author_name($ctx);
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_day($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%x';
        return encode_html( strip_tags( $author_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d%02d", $period_start['y'], $period_start['m'], $period_start['d']);
        return start_end_day($period_start);
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';

        $content_type_filter = _get_content_type_filter($args);

        list($dt_target_col, $cat_target_col, $join_on) = _get_join_on($ctx, $at, $blog_id);

        $year_ext = $mt->db()->apply_extract_date('year', $dt_target_col);
        $month_ext = $mt->db()->apply_extract_date('month', $dt_target_col);
        $day_ext = $mt->db()->apply_extract_date('day', $dt_target_col);

        $author = $ctx->stash('archive_author');
        $author or $author = $ctx->stash('author');
        if (isset($author)) {
            $author_filter = " and cd_author_id=".$author->author_id;
        }

        $inside = $ctx->stash('inside_archive_list');
        if (!isset($inside)) {
          $inside = false;
        }
        if ($inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and ($dt_target_col between '$ts' and '$tsend')";
            }
        }

        $sql = implode(' ', array(
            "select count(*) as cd_count, $year_ext as y, $month_ext as m, $day_ext as d, cd_author_id, author_name",
            "from mt_cd",
            "join mt_author on cd_author_id = author_id $join_on",
            "where cd_blog_id = $blog_id and cd_status = 2",
            isset($date_filter) ? $date_filter : '',
            isset($author_filter) ? $author_filter : '',
            isset($content_type_filter) ? $content_type_filter : '',
            "group by $year_ext, $month_ext, $day_ext, cd_author_id, author_name",
            "order by author_name $auth_order, $year_ext $order, $month_ext $order, $day_ext $order"
        ));

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['author_daily_archive'] = 1;
        $array['archive_class']        = 'contenttype-author-daily-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeAuthorDailyArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_day';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($result)) {
            $count = count($results);
            
            $args['hi'] = sprintf("%04d%02d%02d000000", $results[0]['y'], $results[0]['m'], $results[0]['d']);
            $args['low'] = sprintf("%04d%02d%02d000000", $results[$count - 1]['y'], $results[0]['m'], $results[0]['d']);
        }
        return $args;
    }
}

class ContentTypeAuthorWeeklyArchiver extends ContentTypeDateBasedAuthorArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CONTENTTYPE-AUTHOR-WEEKLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $author_name = parent::get_author_name($ctx);
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start, $end) = start_end_week($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%x';
        return encode_html( strip_tags( $author_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx)
            . ' - ' . $ctx->_hdlr_date(array('ts' => $end, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        if (is_array($period_start)) {
            require_once('MTUtil.php');
            $week_yr = substr($period_start['week_number'], 0, 4);
            $week_num = substr($period_start['week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);

            $period_start = sprintf("%04d%02d%02d000000", $y, $m, $d);
        }
        return start_end_week($period_start);
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';

        $content_type_filter = _get_content_type_filter($args);

        list($dt_target_col, $cat_target_col, $join_on) = _get_join_on($ctx, $at, $blog_id);

        $year_ext = $mt->db()->apply_extract_date('year', $dt_target_col);
        $month_ext = $mt->db()->apply_extract_date('month', $dt_target_col);
        $day_ext = $mt->db()->apply_extract_date('day', $dt_target_col);

        $author = $ctx->stash('archive_author');
        $author or $author = $ctx->stash('author');
        if (isset($author)) {
            $author_filter = " and cd_author_id=".$author->author_id;
        }

        $inside = $ctx->stash('inside_archive_list');
        if (!isset($inside)) {
          $inside = false;
        }
        if ($inside) {
            $ts = $ctx->stash('current_timestamp');
            $tsend = $ctx->stash('current_timestamp_end');
            if ($ts && $tsend) {
                $ts = $mt->db()->ts2db($ts);
                $tsend = $mt->db()->ts2db($tsend);
                $date_filter = "and ($dt_target_col between '$ts' and '$tsend')";
            }
        }
        $week_number = $dt_target_col == 'cd_authored_on' ? 'cd_week_number' : 'cf_idx_value_integer';

        $sql = implode(' ', array(
            "select count(*) as record_count, $week_number week_number, cd_author_id, author_name",
            "from mt_cd",
            "join mt_author on cd_author_id = author_id $join_on",
            "where cd_blog_id = $blog_id and cd_status = 2",
            isset($date_filter) ? $date_filter : '',
            isset($author_filter) ? $author_filter : '',
            isset($content_type_filter) ? $content_type_filter : '',
            "group by $week_number, cd_author_id, author_name order by author_name $auth_order, $week_number $order"
        ));
        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['author_weekly_archive'] = 1;
        $array['archive_class']         = 'contenttype-author-weekly-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeAuthorWeeklyArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_week';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);

            require_once("MTUtil.php");
            $week_yr = substr($results[0]['week_number'], 0, 4);
            $week_num = substr($results[0]['week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);
            $args['hi'] = sprintf("%04d%02d%02d", $y, $m, $d);

            $week_yr = substr($results[$count - 1]['week_number'], 0, 4);
            $week_num = substr($results[$count - 1]['week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);
            $args['low'] = sprintf("%04d%02d%02d", $y, $m, $d);
        }
        return $args;
    }
}

class ContentTypeCategoryArchiver implements ArchiveType {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CONTENTTYPE-CATEGORY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $cat_name = $this->get_category_name();
        return encode_html( strip_tags( $cat_name ) );
    }

    protected function get_category_name () {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $curr_at = $ctx->stash('current_archive_type');
        $archiver = ArchiverFactory::get_archiver($curr_at);
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
                $cat_name = $cat->category_label;
            }
        }
        return $cat_name;
    }

    public function get_archive_list($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $results = $this->get_archive_list_data($args);

        if(!empty($results)) {
            $update_args['blog_id'] = $args['blog_id'];
            $update_args['archive_type'] = $ctx->stash('current_archive_type');
            $mt->db()->update_archive_link_cache($update_args);
        }
        return $results;
    }

    public function get_archive_link_sql($ts, $at, $args) {
        return '';
    }

    public function archive_prev_next($args, $content, &$repeat, $tag, $at) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        if ($tag == 'archiveprevious') {
            require_once('block.mtcategoryprevious.php');
            return smarty_block_mtcategoryprevious($args, $content, $ctx, $repeat);
        } elseif ($tag == 'archivenext') {
            require_once('block.mtcategorynext.php');
            return smarty_block_mtcategorynext($args, $content, $ctx, $repeat);
        }

        return $ctx->error("Error in tag: $tag");
    }

    public function prepare_list($row) { return true; }

    public function setup_args(&$args) {
        return true;
    }

    protected function get_archive_list_data($args) { return true; }

    public function get_template_params() {
        $array = array(
            'archive_template'            => 1,
            'category_archive'            => 1,
            'category_based_archive'      => 1,
            'category_set_based_archive'  => 1,
            'archive_class'               => 'contenttype-category-archive',
            'archive_listing'             => 1,
            'contenttype_archive_listing' => 1
        );
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeCategoryArchiver::get_template_params();
    }

    public function is_date_based() {
        return false;
    }

    public function get_range($period_start) {
        return null;
    }
}

abstract class ContentTypeDateBasedCategoryArchiver extends ContentTypeDateBasedArchiver {

    public function setup_args(&$args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        if ($cat = $ctx->stash('category')) {
            $args['category_id'] = $cat->category_id;
        }
    }

    public function get_archive_link_sql($ts, $at, $args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = intval($args['blog_id']);
        $blog_id or $blog_id = intval($ctx->stash('blog_id'));
        $cat = $ctx->stash('category');
        $cat_id = $cat->category_id;
        if (isset($ts)) {
            if ($at == 'ContentType-Category-Monthly') {
                $ts = substr($ts, 0, 6) . '01000000';
            } elseif ($at == 'ContentType-Category-Daily') {
                $ts = substr($ts, 0, 8) . '000000';
            } elseif ($at == 'ContentType-Category-Weekly') {
                require_once("MTUtil.php");
                list($ws, $we) = start_end_week($ts);
                $ts = $ws;
            } elseif ($at == 'ContentType-Category-Yearly') {
                $ts = substr($ts, 0, 4) . '0101000000';
            }
            $start_filter = "and fileinfo_startdate = '$ts'";
        } else {
            // find a most oldest link when timestamp was not presented
            $order = "order by fileinfo_startdate asc";
        }

        $sql = implode(' ', array(
            "fileinfo_blog_id = $blog_id and fileinfo_archive_type = '".$mt->db()->escape($at)."'",
            "and fileinfo_category_id = '$cat_id'",
            "and templatemap_is_preferred = 1",
            isset($start_filter) ? $start_filter : '',
            isset($order) ? $order : ''
        ));
        return $sql;
    }

    public function archive_prev_next($args, $content, &$repeat, $tag, $at) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $localvars = array('current_timestamp', 'current_timestamp_end', 'contents');
        if (!isset($content)) {
            $ctx->localize($localvars);
            $is_prev = $tag == 'archiveprevious';
            $blog_id = $ctx->stash('blog_id');
            $ts = $ctx->stash('current_timestamp');
            $maps = $ctx->mt->db()->fetch_templatemap(array(
                'blog_id'         => $blog_id,
                'content_type_id' => $ctx->stash('content_type')->id,
                'preferred'       => 1,
                'type'            => $at
            ));
            if (!empty($maps) && is_array($maps)) {
                $map = $maps[0];
                $dt_field_id = $map->templatemap_dt_field_id;
                $cat_field = $map->cat_field();
            }
            $category = $ctx->stash('category');
            if (!(isset($ts) && $ts) || !(isset($cat_field) && $cat_field) || !(isset($category) && $category)) {
                return $ctx->error(
                   "You used an <mt$tag> without context set up.");
            }
            $order = $is_prev ? 'previous' : 'next';

            if ($cd = $this->get_categorized_content($ts, $blog_id, $cat_field, $category->category_id, $at, $order)) {
                $helper = $this->get_helper($at);
                $ctx->stash('contents', array($cd));
                if (preg_match('/^[0-9]+$/', $dt_field_id ?? '') && $dt_field_id) {
                    $data = $cd->data();
                    $ts = $data[$dt_field_id];
                }
                else {
                    $ts = $cd->authored_on;
                }
                list($start, $end) = $helper($ts);
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

    protected function get_categorized_content($ts, $blog_id, $cat_field, $cat_id, $at, $order) {
        $helper = $this->get_helper();
        list($start, $end) = $helper($ts);
        $args = array();
        if ($order == 'previous') {
            $args['current_timestamp_end'] = $this->dec_ts($start);
        } else {
            $args['current_timestamp'] = $this->inc_ts($end);
            $args['base_sort_order'] = 'ascend'; # ascending order
        }
        $args['_current_timestamp_sort'] = true;
        $args['lastn'] = 1;
        $args['blog_id'] = $blog_id;
        $args['field___' . $cat_field->cf_unique_id] = $cat_id;
        $args['_no_use_category_filter'] = true;

        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $content_type = $ctx->stash('content_type');
        if (isset($content_type)) $content_type_id = $content_type->content_type_id;
        $mt = MT::get_instance();
        list($cd) = $mt->db()->fetch_contents($args, $content_type_id);
        return $cd;
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['archive_class']                = 'contenttype-category-archive';
        $array['category_based_archive']       = 1;
        $array['category_set_based_archive']   = 1;
        $array['archive_template']             = 1;
        $array['archive_listing']              = 1;
        $array['content_type_archive_listing'] = 1;
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeDateBasedCategoryArchiver::get_template_params();
    }

    protected function get_category_name () {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $curr_at = $ctx->stash('current_archive_type');
        $archiver = ArchiverFactory::get_archiver($curr_at);
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
                $cat_name = $cat->category_label.": ";
            }
        }
        return $cat_name;
    }

    public function prepare_list($row) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $category_id = $row['category_id'];
        $category = $mt->db()->fetch_category($category_id);
        $ctx->stash('category', $category);
    }

}

class ContentTypeCategoryYearlyArchiver extends ContentTypeDateBasedCategoryArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CONTENTTYPE-CATEGORY-YEARLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $cat_name = parent::get_category_name();
        $stamp = $ctx->stash('current_timestamp');
        list($start) = start_end_year($stamp, $ctx->stash('blog'));
        $format = isset($args['format']) ? $args['format'] : null;
        $blog = $ctx->stash('blog');

        $lang = ($blog && $blog->blog_language ? $blog->blog_language :
            $mt->config('DefaultLanguage'));
            if (strtolower($lang) == 'jp' || strtolower($lang) == 'ja') {
            $format or $format = "%Y&#24180;";
        } else {
            $format or $format = "%Y";
        }
        return encode_html( strip_tags( $cat_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        if (is_array($period_start))
            $period_start = sprintf("%04d", $period_start['y']);
        return start_end_year($period_start);
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $content_type_filter = _get_content_type_filter($args);

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';
        $cat = $ctx->stash('archive_category');
        $cat or $cat = $ctx->stash('category');
        if ($cat) {
            $cats = array($cat);
        }
        else {
            $cat_set_id = isset($args['category_set_id']) ? $args['category_set_id'] : null;
            if (!isset($cat_set_id)) {
                $category_set = $ctx->stash('category_set');
                $cat_set_id = isset($category_set) ? $category_set->category_set_id: '> 0';
            }
            $sort_order = isset($args['sort_order']) ? $args['sort_order'] : null;
            $sort_order or $sort_order = 'ascend';
            $cats = $ctx->mt->db()->fetch_categories(array(
                'blog_id' => $blog_id,
                'show_empty' => 1,
                'class' => 'category',
                'category_set_id' => $cat_set_id,
                'sort_by' => 'label',
                'sort_order' => $sort_order
            ));
        }

        $categories = array();
        $seen_join_on = array();
        foreach ( $cats as $cat ) {
            $objectcategories = $mt->db()->fetch_objectcategory(array('category_id' => array($cat->category_id)));
            $objectcategories = $objectcategories ? $objectcategories : array();
            $cat_field_ids = array();
            foreach ( $objectcategories as $objectcategory ) {
                $cat_field_ids[$objectcategory->objectcategory_cf_id] = 1;
            }
            foreach ( $cat_field_ids as $cat_field_id => $count ) {
                list($dt_target_col, $cat_target_col, $join_on) = _get_join_on($ctx, $at, $blog_id, $cat, $cat_field_id);

                # When a preferred template map exists, $cat_field_id is overridden and $join_on becomes the same
                if ( array_key_exists($join_on, $seen_join_on) ) continue;
                $seen_join_on[$join_on] = 1;

                $year_ext = $mt->db()->apply_extract_date('year', $dt_target_col);

                $inside = $ctx->stash('inside_archive_list');
                if (!isset($inside)) {
                  $inside = false;
                }
                if ($inside) {
                    $ts = $ctx->stash('current_timestamp');
                    $tsend = $ctx->stash('current_timestamp_end');
                    if ($ts && $tsend) {
                        $ts = $mt->db()->ts2db($ts);
                        $tsend = $mt->db()->ts2db($tsend);
                        $date_filter = "and $dt_target_col between '$ts' and '$tsend'";
                    }
                }

                $sql = implode(' ', array(
                    "select count(*) as cd_count, $year_ext as y, $cat_target_col as category_id, category_label",
                    'from mt_cd',
                    $join_on,
                    "where cd_blog_id = $blog_id and cd_status = 2",
                    isset($date_filter) ? $date_filter : '',
                    $content_type_filter,
                    "group by $year_ext, $cat_target_col, category_label",
                    "order by category_label $cat_order, $year_ext $order"
                ));
                $limit = isset($args['lastn']) ? $args['lastn'] : -1;
                $offset = isset($args['offset']) ? $args['offset'] : -1;
                $results = $mt->db()->SelectLimit($sql, $limit, $offset);
                if (!empty($results)) {
                    $array = $results->GetArray();
                    $categories = array_merge($categories, $array);
                }
            }
        }
        return $categories;
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['category_yearly_archive'] = 1;
        $array['archive_class']           = 'contenttype-category-yearly-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeCategoryYearlyArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_year';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($result)) {
            $count = count($results);
            
            $args['hi'] = sprintf("%04d0000000000", $results[0]['y']);
            $args['low'] = sprintf("%04d0000000000", $results[$count - 1]['y']);
        }
        return $args;
    }
}

class ContentTypeCategoryMonthlyArchiver extends ContentTypeDateBasedCategoryArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CONTENTTYPE-CATEGORY-MONTHLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $cat_name = parent::get_category_name($ctx);
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_month($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%B %Y';
        return encode_html( strip_tags( $cat_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d", $period_start['y'], $period_start['m']);
        return start_end_month($period_start);
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $content_type_filter = _get_content_type_filter($args);

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';
        $cat = $ctx->stash('archive_category');
        $cat or $cat = $ctx->stash('category');
        if ($cat) {
            $cats = array($cat);
        }
        else {
            $cat_set_id = isset($args['category_set_id']) ? $args['category_set_id'] : null;
            if (!isset($cat_set_id)) {
                $category_set = $ctx->stash('category_set');
                $cat_set_id = isset($category_set) ? $category_set->category_set_id: '> 0';
            }
            $sort_order = isset($args['sort_order']) ? $args['sort_order'] : null;
            $sort_order or $sort_order = 'ascend';
            $cats = $ctx->mt->db()->fetch_categories(array(
                'blog_id' => $blog_id,
                'show_empty' => 1,
                'class' => 'category',
                'category_set_id' => $cat_set_id,
                'sort_by' => 'label',
                'sort_order' => $sort_order
            ));
        }

        $categories = array();
        $seen_join_on = array();
        foreach ( $cats as $cat ) {
            $objectcategories = $mt->db()->fetch_objectcategory(array('category_id' => array($cat->category_id)));
            $objectcategories = $objectcategories ? $objectcategories : array();
            $cat_field_ids = array();
            foreach ( $objectcategories as $objectcategory ) {
                $cat_field_ids[$objectcategory->objectcategory_cf_id] = 1;
            }
            foreach ( $cat_field_ids as $cat_field_id => $count ) {
                list($dt_target_col, $cat_target_col, $join_on) = _get_join_on($ctx, $at, $blog_id, $cat, $cat_field_id);

                # When a preferred template map exists, $cat_field_id is overridden and $join_on becomes the same
                if ( array_key_exists($join_on, $seen_join_on) ) continue;
                $seen_join_on[$join_on] = 1;

                $year_ext = $mt->db()->apply_extract_date('year', $dt_target_col);
                $month_ext = $mt->db()->apply_extract_date('month', $dt_target_col);

                $index = $ctx->stash('index_archive');
                $inside = $ctx->stash('inside_archive_list');
                if (!isset($inside)) {
                  $inside = false;
                }
                if ($inside) {
                    $ts = $ctx->stash('current_timestamp');
                    $tsend = $ctx->stash('current_timestamp_end');
                    if ($ts && $tsend) {
                        $ts = $mt->db()->ts2db($ts);
                        $tsend = $mt->db()->ts2db($tsend);
                        $date_filter = "and $dt_target_col between '$ts' and '$tsend'";
                    }
                }
                $sql = implode(' ', array(
                    'select count(*) as cd_count,',
                    "$year_ext as y,",
                    "$month_ext as m,",
                    "$cat_target_col as category_id,",
                    'category_label',
                    'from mt_cd',
                    $join_on,
                    "where cd_blog_id = $blog_id and cd_status = 2",
                    isset($date_filter) ? $date_filter : '',
                    isset($content_type_filter) ? $content_type_filter : '',
                    "group by $year_ext, $month_ext, $cat_target_col, category_label",
                    "order by category_label $cat_order, $year_ext $order, $month_ext $order"
                ));
                $limit = isset($args['lastn']) ? $args['lastn'] : -1;
                $offset = isset($args['offset']) ? $args['offset'] : -1;
                $results = $mt->db()->SelectLimit($sql, $limit, $offset);
                if (!empty($results)) {
                    $array = $results->GetArray();
                    $categories = array_merge($categories, $array);
                }
            }
        }
        return $categories;
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['archive_class']                    = 'contenttype-category-monthly-archive';
        $array['category_monthly_archive']         = 1;
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeCategoryMonthlyArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_month';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);
            $hi = sprintf("%04d%02d00000000", $results[0]['y'], $results[0]['m']);
            $low = sprintf("%04d%02d00000000", $results[$count - 1]['y'], $results[$count - 1]['m']);
        }
        return $args;
    }
}

class ContentTypeCategoryDailyArchiver extends ContentTypeDateBasedCategoryArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CONTENTTYPE-CATEGORY-DAILY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $cat_name = parent::get_category_name();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_day($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%x';
        return encode_html( strip_tags( $cat_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d%02d", $period_start['y'], $period_start['m'], $period_start['d']);
        return start_end_day($period_start);
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $content_type_filter = _get_content_type_filter($args);

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';
        $cat = $ctx->stash('archive_category');
        $cat or $cat = $ctx->stash('category');
        if ($cat) {
            $cats = array($cat);
        }
        else {
            $cat_set_id = isset($args['category_set_id']) ? $args['category_set_id'] : null;
            if (!isset($cat_set_id)) {
                $category_set = $ctx->stash('category_set');
                $cat_set_id = isset($category_set) ? $category_set->category_set_id: '> 0';
            }
            $sort_order = isset($args['sort_order']) ? $args['sort_order'] : null;
            $sort_order or $sort_order = 'ascend';
            $cats = $ctx->mt->db()->fetch_categories(array(
                'blog_id' => $blog_id,
                'show_empty' => 1,
                'class' => 'category',
                'category_set_id' => $cat_set_id,
                'sort_by' => 'label',
                'sort_order' => $sort_order
            ));
        }

        $categories = array();
        $seen_join_on = array();
        foreach ( $cats as $cat ) {
            $objectcategories = $mt->db()->fetch_objectcategory(array('category_id' => array($cat->category_id)));
            $objectcategories = $objectcategories ? $objectcategories : array();
            $cat_field_ids = array();
            foreach ( $objectcategories as $objectcategory ) {
                $cat_field_ids[$objectcategory->objectcategory_cf_id] = 1;
            }
            foreach ( $cat_field_ids as $cat_field_id => $count ) {
                list($dt_target_col, $cat_target_col, $join_on) = _get_join_on($ctx, $at, $blog_id, $cat, $cat_field_id);

                # When a preferred template map exists, $cat_field_id is overridden and $join_on becomes the same
                if ( array_key_exists($join_on, $seen_join_on) ) continue;
                $seen_join_on[$join_on] = 1;

                $year_ext = $mt->db()->apply_extract_date('year', $dt_target_col);
                $month_ext = $mt->db()->apply_extract_date('month', $dt_target_col);
                $day_ext = $mt->db()->apply_extract_date('day', $dt_target_col);

                $inside = $ctx->stash('inside_archive_list');
                if (!isset($inside)) {
                    $inside = false;
                }
                if ($inside) {
                    $ts = $ctx->stash('current_timestamp');
                    $tsend = $ctx->stash('current_timestamp_end');
                    if ($ts && $tsend) {
                        $ts = $mt->db()->ts2db($ts);
                        $tsend = $mt->db()->ts2db($tsend);
                        $date_filter = "and $dt_target_col between '$ts' and '$tsend'";
                    }
                }
                $sql = implode(' ', array(
                    'select count(*) as cd_count,',
                    "$year_ext as y,",
                    "$month_ext as m,",
                    "$day_ext as d,",
                    "$cat_target_col as category_id,",
                    'category_label',
                    'from mt_cd',
                    $join_on,
                    "where cd_blog_id = $blog_id",
                    "and cd_status = 2",
                    isset($date_filter) ? $date_filter : '',
                    isset($content_type_filter) ? $content_type_filter : '',
                    "group by $year_ext, $month_ext, $day_ext, $cat_target_col, category_label",
                    "order by category_label $cat_order, $year_ext $order, $month_ext $order, $day_ext $order"
                ));
                $limit = isset($args['lastn']) ? $args['lastn'] : -1;
                $offset = isset($args['offset']) ? $args['offset'] : -1;
                $results = $mt->db()->SelectLimit($sql, $limit, $offset);
                if (!empty($results)) {
                    $array = $results->GetArray();
                    $categories = array_merge($categories, $array);
                }
            }
        }
        return $categories;
    }    

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['category_daily_archive'] = 1;
        $array['archive_class']          = 'contenttype-category-daily-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeCategoryDailyArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_day';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($result)) {
            $count = count($results);
            
            $args['hi'] = sprintf("%04d%02d%02d000000", $results[0]['y'], $results[0]['m'], $results[0]['d']);
            $args['low'] = sprintf("%04d%02d%02d000000", $results[$count - 1]['y'], $results[0]['m'], $results[0]['d']);
        }
        return $args;
    }
}

class ContentTypeCategoryWeeklyArchiver extends ContentTypeDateBasedCategoryArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('CONTENTTYPE-CATEGORY-WEEKLY_ADV');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $cat_name = parent::get_category_name();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start, $end) = start_end_week($stamp, $ctx->stash('blog'));
        $format = !empty($args['format']) ? $args['format'] : '%x';
        return encode_html( strip_tags( $cat_name ) )
            . $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx)
            . " - " . $ctx->_hdlr_date(array('ts' => $end, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        if (is_array($period_start)) {
            require_once('MTUtil.php');
            $week_yr = substr($period_start['week_number'], 0, 4);
            $week_num = substr($period_start['week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);

            $period_start = sprintf("%04d%02d%02d000000", $y, $m, $d);
        }
        return start_end_week($period_start, $ctx->stash('blog'));
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $content_type_filter = _get_content_type_filter($args);

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = !empty($args['sort_order']) && $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = !empty($args['sort_order']) && $args['sort_order'] == 'descend' ? 'desc' : 'asc';
        $cat = $ctx->stash('archive_category');
        $cat or $cat = $ctx->stash('category');
        if ($cat) {
            $cats = array($cat);
        }
        else {
            $cat_set_id = isset($args['category_set_id']) ? $args['category_set_id'] : null;
            if (!isset($cat_set_id)) {
                $category_set = $ctx->stash('category_set');
                $cat_set_id = isset($category_set) ? $category_set->category_set_id: '> 0';
            }
            $sort_order = isset($args['sort_order']) ? $args['sort_order'] : null;
            $sort_order or $sort_order = 'ascend';
            $cats = $ctx->mt->db()->fetch_categories(array(
                'blog_id' => $blog_id,
                'show_empty' => 1,
                'class' => 'category',
                'category_set_id' => $cat_set_id,
                'sort_by' => 'label',
                'sort_order' => $sort_order
            ));
        }

        $categories = array();
        $seen_join_on = array();
        foreach ( $cats as $cat ) {
            $objectcategories = $mt->db()->fetch_objectcategory(array('category_id' => array($cat->category_id)));
            $objectcategories = $objectcategories ? $objectcategories : array();
            $cat_field_ids = array();
            foreach ( $objectcategories as $objectcategory ) {
                $cat_field_ids[$objectcategory->objectcategory_cf_id] = 1;
            }
            foreach ( $cat_field_ids as $cat_field_id => $count ) {
                list($dt_target_col, $cat_target_col, $join_on) = _get_join_on($ctx, $at, $blog_id, $cat, $cat_field_id);

                # When a preferred template map exists, $cat_field_id is overridden and $join_on becomes the same
                if ( array_key_exists($join_on, $seen_join_on) ) continue;
                $seen_join_on[$join_on] = 1;

                $inside = $ctx->stash('inside_archive_list');
                if (!isset($inside)) {
                  $inside = false;
                }
                if ($inside) {
                    $ts = $ctx->stash('current_timestamp');
                    $tsend = $ctx->stash('current_timestamp_end');
                    if ($ts && $tsend) {
                        $ts = $mt->db()->ts2db($ts);
                        $tsend = $mt->db()->ts2db($tsend);
                        $date_filter = "and $dt_target_col between '$ts' and '$tsend'";
                    }
                }
                $week_number = $dt_target_col === 'cd_authored_on' ? 'cd_week_number' : 'dt_cf_idx.cf_idx_value_integer';
                $sql = implode(' ', array(
                    'select count(*) as cd_count,',
                    "$week_number as week_number,",
                    "$cat_target_col as category_id,",
                    'category_label',
                    'from mt_cd',
                    $join_on,
                    "where cd_blog_id = $blog_id and cd_status = 2",
                    isset($date_filter) ? $date_filter : '',
                    isset($content_type_filter) ? $content_type_filter : '',
                    "group by $week_number, $cat_target_col, category_label",
                    "order by category_label $cat_order, $week_number $order"
                ));
                $limit = isset($args['lastn']) ? $args['lastn'] : -1;
                $offset = isset($args['offset']) ? $args['offset'] : -1;
                $results = $mt->db()->SelectLimit($sql, $limit, $offset);
                if (!empty($results)) {
                    $array = $results->GetArray();
                    $categories = array_merge($categories, $array);
                }
            }
        }
        return $categories;
    }

    public function get_template_params() {
        $array = parent::get_template_params();
        $array['category_weekly_archive'] = 1;
        $array['archive_class']           = 'contenttype-category-weekly-archive';
        return $array;
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars += ContentTypeCategoryWeeklyArchiver::get_template_params();
    }

    protected function get_helper() {
        return 'start_end_week';
    }

    protected function get_update_link_args($results) {
        $args = array();
        if (!empty($results)) {
            $count = count($results);

            require_once("MTUtil.php");
            $week_yr = substr($results[0]['week_number'], 0, 4);
            $week_num = substr($results[0]['week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);
            $args['hi'] = sprintf("%04d%02d%02d", $y, $m, $d);

            $week_yr = substr($results[$count - 1]['week_number'], 0, 4);
            $week_num = substr($results[$count - 1]['week_number'], 4);
            list($y,$m,$d) = week2ymd($week_yr, $week_num);
            $args['low'] = sprintf("%04d%02d%02d", $y, $m, $d);
        }
        return $args;
    }
}

# fake for L10N translate("Category")
?>
