<?php
# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

require_once('MTUtil.php');

function _hdlr_archive_prev_next($args, $content, &$ctx, &$repeat, $tag) {
    $at = $args['archive_type'];
    $at or $at = $ctx->stash('current_archive_type');
    if ($at == 'Category') {
        require_once("block.mtcategorynext.php");
        return smarty_block_mtcategorynext($args, $content, $ctx, $repeat);
    }
    $archiver = ArchiverFactory::get_archiver($at);
    if (!isset($archiver)) {
        $repeat = false;
        return '';
    }
    return $archiver->archive_prev_next($args, $content, $repeat, $tag, $at);
}

interface ArchiveType {
    public function get_label($args = null);
    public function get_title($args);
    public function get_archive_list($args);
    public function archive_prev_next($args, $content, &$repeat, $tag, $at);
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

        'Category' => null,
        'Category-Yearly' => 'YearlyCategoryArchiver',
        'Category-Monthly' => 'MonthlyCategoryArchiver',
        'Category-Weekly' => 'WeeklyCategoryArchiver',
        'Category-Daily' => 'DailyCategoryArchiver'
    );
    private static $_archivers = array();

    private function __construct() { }

    public static function get_archiver($at) {
        if (empty($at))
            return null;
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
        return $mt->translate("Individual");
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
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $sql = "
                entry_blog_id = $blog_id
                and entry_status = 2
                and entry_class = 'entry'
                order by entry_authored_on $order";
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
        $ctx->stash('entries', array());
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars['entry_archive']     = 1;
        $vars['archive_template']  = 1;
        $vars['entry_template']    = 1;
        $vars['feedback_template'] = 1;
        $vars['archive_class']     = 'entry-archive';
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
        return $mt->translate("Page");
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $blog_id = $args['blog_id'];
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $sql = "
                entry_blog_id = $blog_id
                and entry_status = 2
                and entry_class = 'page'
                order by entry_authored_on $order";
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

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $vars =& $ctx->__stash['vars'];
        $vars['archive_template']  = 1;
        $vars['page_template']     = 1;
        $vars['feedback_template'] = 1;
        $vars['page_archive']      = 1;
        $vars['archive_class']     = 'page-archive';
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

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $vars =& $ctx->__stash['vars'];
        $vars['archive_listing']   = 1;
        $vars['archive_template']  = 1;
        $vars['datebased_archive'] = 1;
    }
}

class YearlyArchiver extends DateBasedArchiver {

    // Override Method
    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('Yearly');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_year($stamp, $ctx->stash('blog'));
        $format = $args['format'];
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

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        parent::template_params($ctx);

        $vars =& $ctx->__stash['vars'];
        $vars['datebased_only_archive']   = 1;
        $vars['datebased_yearly_archive'] = 1;
        $vars['archive_class']            = 'datebased-yearly-archive';
        $vars['module_yearly_archives']   = 1;
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();

        $blog_id = $args['blog_id'];
        $at = $args['archive_type'];
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

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
        return $mt->translate('Monthly');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_month($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%B %Y";
        return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d", $period_start['y'], $period_start['m']);
        return start_end_month($period_start, $ctx->stash('blog'));
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        parent::template_params($ctx);

        $vars =& $ctx->__stash['vars'];
        $vars['datebased_only_archive']    = 1;
        $vars['datebased_monthly_archive'] = 1;
        $vars['archive_class']             = 'datebased-monthly-archive';
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
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $year_ext = $mt->db()->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $mt->db()->apply_extract_date('month', 'entry_authored_on');

        $sql = "
                select count(*) as entry_count,
                       $year_ext as y,
                       $month_ext as m
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                   and entry_class = 'entry'
                   $date_filter
                 group by
                       $year_ext,
                       $month_ext
                 order by
                       $year_ext $order,
                       $month_ext $order";

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);

        return empty($results) ? null : $results->GetArray();
    }
}

class DailyArchiver extends DateBasedArchiver {
    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('Daily');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_day($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%x";
        return $ctx->_hdlr_date(array('ts' => $start, 'format' => $format), $ctx);
    }

    public function get_range($period_start) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        if (is_array($period_start))
            $period_start = sprintf("%04d%02d%02d", $period_start['y'], $period_start['m'], $period_start['d']);
        return start_end_day($period_start, $ctx->stash('blog'));
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        parent::template_params($ctx);

        $vars =& $ctx->__stash['vars'];
        $vars['datebased_only_archive']  = 1;
        $vars['datebased_daily_archive'] = 1;
        $vars['archive_class']           = 'datebased-daily-archive';
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
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $year_ext = $mt->db()->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $mt->db()->apply_extract_date('month', 'entry_authored_on');
        $day_ext = $mt->db()->apply_extract_date('day', 'entry_authored_on');

        $sql = "
                select count(*) as entry_count,
                       $year_ext as y,
                       $month_ext as m,
                       $day_ext as d
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                   and entry_class = 'entry'
                   $date_filter
                 group by
                       $year_ext,
                       $month_ext,
                       $day_ext
                 order by
                       $year_ext $order,
                       $month_ext $order,
                       $day_ext $order";

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);

        return empty($results) ? null : $results->GetArray();
    }
}

class WeeklyArchiver extends DateBasedArchiver {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('Weekly');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start, $end) = start_end_week($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%x";
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

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        parent::template_params($ctx);

        $vars =& $ctx->__stash['vars'];
        $vars['datebased_only_archive']   = 1;
        $vars['datebased_weekly_archive'] = 1;
        $vars['archive_class']            = 'datebased-weekly-archive';
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
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';

        $sql = "
                select count(*) as entry_count,
                       entry_week_number
                  from mt_entry
                 where entry_blog_id = $blog_id
                   and entry_status = 2
                   and entry_class = 'entry'
                   $date_filter
                 group by entry_week_number
                 order by entry_week_number $order";

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);

        return empty($results) ? null : $results->GetArray();
    }
}

class AuthorBasedArchiver implements ArchiveType {

    public function get_label($args = null) {
        $mt = MT::get_instance();
        return $mt->translate('Author');
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
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
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

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $vars =& $ctx->__stash['vars'];
        $vars['archive_template']               = 1;
        $vars['author_archive']                 = 1;
        $vars['archive_class']                  = 'author-archive';
        $vars['module_author-monthly_archives'] = 1;
        $vars['archive_listing']                = 1;
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
        return $mt->translate('Author Yearly');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $author_name = parent::get_author_name();
        $stamp = $ctx->stash('current_timestamp');
        list($start) = start_end_year($stamp, $ctx->stash('blog'));
        $format = $args['format'];
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
            $period_start = sprintf("%04d%02d", $period_start['y'], $period_start['m']);
        return start_end_year($period_start);
    }

    protected function get_archive_list_data($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $blog_id = $args['blog_id'];
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = $args['sort_order'] == 'descend' ? 'desc' : 'asc';
        $year_ext = $mt->db()->apply_extract_date('year', 'entry_authored_on');
        $index = $ctx->stash('index_archive');
        #if (!$index) {
            $author = $ctx->stash('archive_author');
            $author or $author = $ctx->stash('author');
            if (isset($author)) {
                $author_filter = " and entry_author_id=".$author->author_id;
            }
        #}

        $sql = "
            select count(*) as record_count,
                   $year_ext as y,
                   entry_author_id,
                   author_name
              from mt_entry
                   join mt_author on entry_author_id = author_id
             where entry_blog_id = $blog_id
                   and entry_class = 'entry'
                   and entry_status = 2
                   $author_filter
             group by
                   $year_ext,
                   entry_author_id,
                   author_name
             order by
                   author_name $auth_order,
                   $year_ext $order";

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        parent::template_params();

        $vars =& $ctx->__stash['vars'];
        $vars['author_yearly_archive'] = 1;
        $vars['archive_class']         = 'author-yearly-archive';
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
        return $mt->translate('Author Monthly');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $author_name = parent::get_author_name();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_month($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%B %Y";
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
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = $args['sort_order'] == 'descend' ? 'desc' : 'asc';
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

        $sql = "
            select count(*) as record_count,
                   $year_ext as y,
                   $month_ext as m,
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
                   entry_author_id,
                   author_name
             order by
                   author_name $auth_order,
                   $year_ext $order,
                   $month_ext $order";

        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        parent::template_params($ctx);

        $vars =& $ctx->__stash['vars'];
        $vars['archive_class']                  = 'author-monthly-archive';
        $vars['author_monthly_archive']         = 1;
        $vars['module_author-monthly_archives'] = 1;
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
        return $mt->translate('Author Daily');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $author_name = parent::get_author_name($ctx);
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_day($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%x";
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
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = $args['sort_order'] == 'descend' ? 'desc' : 'asc';
        $year_ext = $mt->db()->apply_extract_date('year', 'entry_authored_on');
        $month_ext = $mt->db()->apply_extract_date('month', 'entry_authored_on');
        $day_ext = $mt->db()->apply_extract_date('day', 'entry_authored_on');

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

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        parent::template_params($ctx);

        $vars =& $ctx->__stash['vars'];
        $vars['author_daily_archive'] = 1;
        $vars['archive_class']        = 'author-daily-archive';
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
        return $mt->translate('Author Weekly');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $author_name = parent::get_author_name($ctx);
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start, $end) = start_end_week($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%x";
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
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $auth_order = $args['sort_order'] == 'descend' ? 'desc' : 'asc';
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

        $sql = "
            select count(*) as record_count,
                   entry_week_number,
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
                   entry_week_number,
                   entry_author_id,
                   author_name
             order by
                   author_name $auth_order,
                   entry_week_number $order";
        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        parent::template_params($ctx);

        $vars =& $ctx->__stash['vars'];
        $vars['author_weekly_archive'] = 1;
        $vars['archive_class']         = 'author-weekly-archive';
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

        $sql = "fileinfo_blog_id = $blog_id
                and fileinfo_archive_type = '".$mt->db()->escape($at)."'
                and fileinfo_category_id = '$cat_id'
                and templatemap_is_preferred = 1
                $start_filter
                $order";
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

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        parent::template_params($ctx);

        $vars =& $ctx->__stash['vars'];
        $vars['archive_class']            = "category-archive";
        $vars['category_archive']         = 1;
        $vars['archive_template']         = 1;
        $vars['archive_listing']          = 1;
        $vars['module_category_archives'] = 1;
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
        return $mt->translate('Category Yearly');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $cat_name = parent::get_category_name();
        $stamp = $ctx->stash('current_timestamp');
        list($start) = start_end_year($stamp, $ctx->stash('blog'));
        $format = $args['format'];
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
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = $args['sort_order'] == 'descend' ? 'desc' : 'asc';
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
        $sql = "
            select count(*) as entry_count,
                   $year_ext as y,
                   placement_category_id,
                   category_label
              from mt_entry join mt_placement on entry_id = placement_entry_id
                   join mt_category on placement_category_id = category_id
             where entry_blog_id = $blog_id
               and entry_status = 2
               and entry_class = 'entry'
               $cat_filter
               $date_filter
             group by
                   $year_ext,
                   placement_category_id,
                   category_label
             order by
                   category_label $cat_order,
                   $year_ext $order";
        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        parent::template_params($ctx);

        $vars =& $ctx->__stash['vars'];
        $vars['category_yearly_archive'] = 1;
        $vars['archive_class']           = 'category-yearly-archive';
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
        return $mt->translate('Category Monthly');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $cat_name = parent::get_category_name($ctx);
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_month($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%B %Y";
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
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = $args['sort_order'] == 'descend' ? 'desc' : 'asc';
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
        $sql = "
            select count(*) as entry_count,
                   $year_ext as y,
                   $month_ext as m,
                   placement_category_id,
                   category_label
              from mt_entry join mt_placement on entry_id = placement_entry_id
                   join mt_category on placement_category_id = category_id
             where entry_blog_id = $blog_id
               and entry_status = 2
               and entry_class = 'entry'
               $cat_filter
               $date_filter
             group by
                   $year_ext,
                   $month_ext,
                   placement_category_id,
                   category_label
             order by
                   category_label $cat_order,
                   $year_ext $order,
                   $month_ext $order";
        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        parent::template_params($ctx);

        $vars =& $ctx->__stash['vars'];
        $vars['archive_class']                    = 'category-monthly-archive';
        $vars['category_monthly_archive']         = 1;
        $vars['module_category-monthly_archives'] = 1;
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
        return $mt->translate('Category Daily');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        $cat_name = parent::get_category_name();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start) = start_end_day($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%x";
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
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = $args['sort_order'] == 'descend' ? 'desc' : 'asc';
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
        $sql = "
            select count(*) as entry_count,
                   $year_ext as y,
                   $month_ext as m,
                   $day_ext as d,
                   placement_category_id,
                   category_label
              from mt_entry join mt_placement on entry_id = placement_entry_id
                   join mt_category on placement_category_id = category_id
             where entry_blog_id = $blog_id
               and entry_status = 2
               and entry_class = 'entry'
               $cat_filter
               $date_filter
             group by
                   placement_category_id,
                   $year_ext,
                   $month_ext,
                   $day_ext,
                   category_label
             order by
                   category_label $cat_order,
                   $year_ext $order,
                   $month_ext $order,
                   $day_ext $order";
        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }    

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        parent::template_params($ctx);

        $vars =& $ctx->__stash['vars'];
        $vars['category_daily_archive'] = 1;
        $vars['archive_class']          = 'category-daily-archive';
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
        return $mt->translate('Category Weekly');
    }

    public function get_title($args) {
        $mt = MT::get_instance();
        $ctx =& $mt->context();
        $cat_name = parent::get_category_name();
        $stamp = $ctx->stash('current_timestamp'); #$entry['entry_authored_on'];
        list($start, $end) = start_end_week($stamp, $ctx->stash('blog'));
        $format = $args['format'];
        $format or $format = "%x";
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
        $order = $args['sort_order'] == 'ascend' ? 'asc' : 'desc';
        $cat_order = $args['sort_order'] == 'descend' ? 'desc' : 'asc';

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
        $sql = "
            select count(*) as entry_count,
                   entry_week_number,
                   placement_category_id,
                   category_label
              from mt_entry join mt_placement on entry_id = placement_entry_id
                   join mt_category on placement_category_id = category_id
             where entry_blog_id = $blog_id
               and entry_status = 2
               and entry_class = 'entry'
               $cat_filter
               $date_filter
             group by
                   entry_week_number,
                   placement_category_id,
                   category_label
             order by
                   category_label $cat_order,
                   entry_week_number $order";
        $limit = isset($args['lastn']) ? $args['lastn'] : -1;
        $offset = isset($args['offset']) ? $args['offset'] : -1;
        $results = $mt->db()->SelectLimit($sql, $limit, $offset);
        return empty($results) ? null : $results->GetArray();
    }

    public function template_params() {
        $mt = MT::get_instance();
        $ctx =& $mt->context();

        parent::template_params();

        $vars =& $ctx->__stash['vars'];
        $vars['category_weekly_archive'] = 1;
        $vars['archive_class']           = 'category-weekly-archive';
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
