# Extensible Archives plugins for Movable Type
# Author: Six Apart http://www.sixapart.com
# Released under the Artistic License
#
# $Id$
package MT::Plugin::ExtensibleArchives::DatebasedCategoriesArchive;

use strict;
use base qw( MT::Plugin );

use MT;
use MT::Util qw( start_end_period start_end_day start_end_year
                 start_end_week start_end_month week2ymd dirify );
use MT::WeblogPublisher;

my $plugin = __PACKAGE__->new({
    name => "Date-based Categories Archives",
    version => '1.0',
    description => "<MT_TRANS phrase=\"TBD\">",
    author_name => "Six Apart, Ltd.",
    author_link => "http://www.sixapart.com/",
    l10n_class => 'DatebasedCategoriesArchive::L10N',
});
MT->add_plugin($plugin);

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        'archive_types' => {
        'Category-Yearly' =>
        ArchiveType(
            name => 'Category-Yearly',
            archive_label => \&yearly_archive_label,
            archive_file => \&yearly_archive_file,
            archive_title => \&yearly_archive_title,
            date_range => \&yearly_date_range,
            archive_group_iter => \&yearly_group_iter,
            archive_group_entries => \&yearly_group_entries,
            default_archive_templates => [
                ArchiveFileTemplate(label => 'category/sub_category/yyyy/index.html',
                                    template => '%c/%y/%i',
                                    default => 1),
                ArchiveFileTemplate(label => 'category/sub-category/yyyy/index.html',
                                    template => '%-c/%y/%i'),
            ],
            dynamic_template => 'category/<$MTCategoryID$>/<$MTArchiveDate format="%Y"$>',
            dynamic_support => 1,
            date_based => 1,
            category_based => 1,
            template_params => {
                archive_class => "category-yearly-archive",
                category_yearly_archive => 1,
                main_template => 1,
                archive_template => 1,
            },
        ),
        'Category-Monthly' =>
        ArchiveType(
            name => 'Category-Monthly',
            archive_label => \&monthly_archive_label,
            archive_file => \&monthly_archive_file,
            archive_title => \&monthly_archive_title,
            date_range => \&monthly_date_range,
            archive_group_iter => \&monthly_group_iter,
            archive_group_entries => \&monthly_group_entries,
            default_archive_templates => [
                ArchiveFileTemplate(label => 'category/sub_category/yyyy/mm/index.html',
                                    template => '%c/%y/%m/%i',
                                    default => 1),
                ArchiveFileTemplate(label => 'category/sub-category/yyyy/mm/index.html',
                                    template => '%-c/%y/%m/%i'),
            ],
            dynamic_template => 'category/<$MTCategoryID$>/<$MTArchiveDate format="%Y%m"$>',
            dynamic_support => 1,
            date_based => 1,
            category_based => 1,
            template_params => {
                archive_class => "category-monthly-archive",
                category_monthly_archive => 1,
                'module_category-monthly_archives' => 1,
                module_category_archives => 1,
                main_template => 1,
                archive_template => 1,
            },
        ),
        'Category-Daily' =>
        ArchiveType(
            name => 'Category-Daily',
            archive_label => \&daily_archive_label,
            archive_file => \&daily_archive_file,
            archive_title => \&daily_archive_title,
            date_range => \&daily_date_range,
            archive_group_iter => \&daily_group_iter,
            archive_group_entries => \&daily_group_entries,
            default_archive_templates => [
                ArchiveFileTemplate(label => 'category/sub_category/yyyy/mm/dd/index.html',
                                    template => '%c/%y/%m/%d/%i',
                                    default => 1),
                ArchiveFileTemplate(label => 'category/sub-category/yyyy/mm/dd/index.html',
                                    template => '%-c/%y/%m/%d/%i'),
            ],
            dynamic_template => 'category/<$MTCategoryID$>/<$MTArchiveDate format="%Y%m%d"$>',
            dynamic_support => 1,
            date_based => 1,
            category_based => 1,
            template_params => {
                archive_class => "category-daily-archive",
                category_daily_archive => 1,
                main_template => 1,
                archive_template => 1,
            },
        ),
        'Category-Weekly' =>
        ArchiveType(
            name => 'Category-Weekly',
            archive_label => \&weekly_archive_label,
            archive_file => \&weekly_archive_file,
            archive_title => \&weekly_archive_title,
            date_range => \&weekly_date_range,
            archive_group_iter => \&weekly_group_iter,
            archive_group_entries => \&weekly_group_entries,
            default_archive_templates => [
                ArchiveFileTemplate(label => 'category/sub_category/yyyy/mm/day-week/index.html',
                                    template => '%c/%y/%m/%d-week/%i',
                                    default => 1),
                ArchiveFileTemplate(label => 'category/sub-category/yyyy/mm/day-week/index.html',
                                    template => '%-c/%y/%m/%d-week/%i'),
            ],
            dynamic_template => 'section/<$MTCategoryID$>/week/<$MTArchiveDate format="%Y%m%d"$>',
            dynamic_support => 1,
            date_based => 1,
            category_based => 1,
            template_params => {
                archive_class => "category-weekly-archive",
                category_weekly_archive => 1,
                main_template => 1,
                archive_template => 1,
            },
        )
    }});
}

sub _display_category {
    my $ctx = shift;
    my $tmpl = $ctx->stash('template');
    my $at = $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    my $cat = '';
    if (!$tmpl || $tmpl->type eq 'index' ||
        !$archiver || ($archiver && !$archiver->category_based) ||
        !$ctx->{inside_archive_list})
    {
        $cat = $ctx->stash('archive_category') || $ctx->stash('category');
        $cat = $cat ? $cat->label.': ' : '';
    }
    return $cat;
}

sub yearly_archive_label {
    $plugin->translate('CATEGORY-YEARLY_ADV');
}

sub yearly_archive_file {
    my ($ctx, %param) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog = $ctx->{__stash}{blog};
    my $cat = $ctx->{__stash}{cat} || $ctx->{__stash}{category};
    my $entry = $ctx->{__stash}{entry};
    my $file;

    my $this_cat = $cat ? $cat : ($entry ? $entry->category : undef);
    if ($file_tmpl) {
        ($ctx->{current_timestamp}, $ctx->{current_timestamp_end}) =
            start_end_year($timestamp, $blog);
        $ctx->stash('archive_category', $this_cat);
        $ctx->{inside_mt_categories} = 1;
        $ctx->{__stash}{category} = $this_cat;
    } else {
        if (!$this_cat) {
            return "";
        }
        my $label = '';
        $label = dirify($this_cat->label);
        if ($label !~ /\w/) {
            $label = $this_cat ? "cat" .  $this_cat->id : "";
        }
        my $start = start_end_year($timestamp, $blog);
        my($year) = unpack 'A4', $start;
        $file = sprintf("%s/%04d/index", $this_cat->category_path, $year);
    }
    $file;
}

sub yearly_date_range { start_end_year(@_) }

sub yearly_archive_title {
    my ($ctx, $entry_or_ts) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_year($stamp, $ctx->stash('blog'));
    my $year = MT::Template::Context::_hdlr_date($ctx, { ts => $start, 'format' => "%Y" });
    my $lang = lc MT->current_language || 'en_us';
    $lang = 'ja' if lc($lang) eq 'jp';
    my $cat = _display_category($ctx);

    sprintf("%s%s%s", $cat, $year, ($lang eq 'ja' ? '&#24180;' : ''));
}

sub yearly_group_iter {
    my ($ctx, $args) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order = ($args->{sort_order} || '') eq 'ascend' ? 'ascend' : 'descend';
    my $cat_order =  $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ($sort_order eq 'ascend') ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;
    my $tmpl = $ctx->stash('template');
    my $cat = $ctx->stash('archive_category') || $ctx->stash('category');
    my @data = ();
    my $count = 0;

    require MT::Placement;
    require MT::Entry;
    my $loop_sub = sub {
        my $c = shift;
        my $entry_iter = MT::Entry->count_group_by(
                    {blog_id => $blog->id,
                     status => MT::Entry::RELEASE()},
                    {group => ["extract(year from authored_on)"],
                     sort => "extract(year from authored_on) $order",
                     'join' => [ 'MT::Placement', 'entry_id',
                          { category_id => $c->id } ]})
            or return $ctx->error("Couldn't get yearly archive list");
        while (my @row = $entry_iter->()) {
            my $hash = {
                year => $row[1],
                category => $c,
                count => $row[0],
            };
            push(@data, $hash);
            return $count+1 if (defined($limit) && ($count+1) == $limit);
            $count++;
        }
    };

    if ($cat) {
        $loop_sub->($cat);
    } else {
        require MT::Category;
        my $iter = MT::Category->load_iter({ blog_id => $blog->id },
            { 'sort' => 'label', direction => $cat_order });
        while (my $category = $iter->()) {
            $loop_sub->($category);
            last if (defined($limit) && $count == $limit);
        } 
    }

    my $loop = @data;
    my $curr = 0;

    return sub {
        if( $curr < $loop) {
            my $date = sprintf("%04d%02d%02d000000",
                $data[$curr]->{year}, 1, 1);
            my ($start, $end) = start_end_year($date);
            my $count = $data[$curr]->{count};
            my %hash = (
                category => $data[$curr]->{category},
                year => $data[$curr]->{year},
                start => $start,
                end => $end,
            );
            $curr++;
            return ($count, %hash);
        }
        undef;
    }
}

sub yearly_group_entries {
    my ($ctx, %param) = @_;

    my $ts = %param ? sprintf("%04d%02d%02d000000",
            $param{year}, 1, 1) : $ctx->stash('current_timestamp');
    my $cat = %param ? $param{category} : $ctx->stash('archive_category');

    date_based_category_entries($ctx, 'Category-Yearly',
        $cat, $ts) ;
}

sub monthly_archive_label {
    $plugin->translate('CATEGORY-MONTHLY_ADV');
}

sub monthly_archive_file {
    my ($ctx, %param) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog = $ctx->{__stash}{blog};
    my $cat = $ctx->{__stash}{cat} || $ctx->{__stash}{category};
    my $entry = $ctx->{__stash}{entry};
    my $file;

    my $this_cat = $cat ? $cat : ($entry ? $entry->category : undef);
    if ($file_tmpl) {
        ($ctx->{current_timestamp}, $ctx->{current_timestamp_end}) =
            start_end_month($timestamp, $blog);
        $ctx->stash('archive_category', $this_cat);
        $ctx->{inside_mt_categories} = 1;
        $ctx->{__stash}{category} = $this_cat;
    } else {
        if (!$this_cat) {
            return "";
        }
        my $label = '';
        $label = dirify($this_cat->label);
        if ($label !~ /\w/) {
            $label = $this_cat ? "cat" .  $this_cat->id : "";
        }
        my $start = start_end_month($timestamp, $blog);
        my($year, $month) = unpack 'A4A2', $start;
        $file = sprintf("%s/%04d/%02d/index", $this_cat->category_path, $year, $month);
    }
    $file;
}

sub monthly_date_range { start_end_month(@_) }

sub monthly_archive_title {
    my ($ctx, $entry_or_ts) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_month($stamp, $ctx->stash('blog'));
    my $date = MT::Template::Context::_hdlr_date($ctx, { ts => $start, 'format' => "%B %Y" });
    my $cat = _display_category($ctx);

    sprintf("%s%s", $cat, $date);
}

sub monthly_group_iter {
    my ($ctx, $args) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order = ($args->{sort_order} || '') eq 'ascend' ? 'ascend' : 'descend';
    my $cat_order =  $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ($sort_order eq 'ascend') ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;
    my $tmpl = $ctx->stash('template');
    my $cat = $ctx->stash('archive_category') || $ctx->stash('category');
    my @data = ();
    my $count = 0;
    my $ts = $ctx->{current_timestamp};
    my $tsend = $ctx->{current_timestamp_end};

    require MT::Placement;
    require MT::Entry;
    my $loop_sub = sub {
        my $c = shift;
        my $entry_iter = MT::Entry->count_group_by(
                    {blog_id => $blog->id,
                     status => MT::Entry::RELEASE(),
                     ($ts && $tsend ? (authored_on => [$ts, $tsend] ) : ()),
                    },
                    {($ts && $tsend ? (range_incl => { authored_on => 1 }) : ()),
                     group => ["extract(year from authored_on)",
                               "extract(month from authored_on)"],
                     sort => "extract(year from authored_on) $order,
                              extract(month from authored_on) $order",
                     'join' => [ 'MT::Placement', 'entry_id',
                          { category_id => $c->id } ]})
            or return $ctx->error("Couldn't get yearly archive list");
        while (my @row = $entry_iter->()) {
            my $hash = {
                year => $row[1],
                month => $row[2],
                category => $c,
                count => $row[0],
            };
            push(@data, $hash);
            return $count+1 if (defined($limit) && ($count+1) == $limit);
            $count++;
        }
    };

    if ($cat) {
        $loop_sub->($cat);
    } else {
        require MT::Category;
        my $iter = MT::Category->load_iter({ blog_id => $blog->id },
            { 'sort' => 'label', direction => $cat_order });
        while (my $category = $iter->()) {
            $loop_sub->($category);
            last if (defined($limit) && $count == $limit);
        } 
    }

    my $loop = @data;
    my $curr = 0;

    return sub {
        if( $curr < $loop) {
            my $date = sprintf("%04d%02d%02d000000",
                $data[$curr]->{year}, $data[$curr]->{month}, 1);
            my ($start, $end) = start_end_month($date);
            my $count = $data[$curr]->{count};
            my %hash = (
                category => $data[$curr]->{category},
                year => $data[$curr]->{year},
                month => $data[$curr]->{month},
                start => $start,
                end => $end,
            );
            $curr++;
            return ($count, %hash);
        }
        undef;
    }
}

sub monthly_group_entries {
    my ($ctx, %param) = @_;

    my $ts = %param ? sprintf("%04d%02d%02d000000",
            $param{year}, $param{month}, 1) : $ctx->stash('current_timestamp');
    my $cat = %param ? $param{category} : $ctx->stash('archive_category');

    date_based_category_entries($ctx, 'Category-Monthly',
        $cat, $ts) ;
}

sub daily_archive_label {
    $plugin->translate('CATEGORY-DAILY_ADV');
}

sub daily_archive_file {
    my ($ctx, %param) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog = $ctx->{__stash}{blog};
    my $cat = $ctx->{__stash}{cat} || $ctx->{__stash}{category};
    my $entry = $ctx->{__stash}{entry};
    my $file;

    my $this_cat = $cat ? $cat : ($entry ? $entry->category : undef);
    if ($file_tmpl) {
        ($ctx->{current_timestamp}, $ctx->{current_timestamp_end}) =
            start_end_day($timestamp, $blog);
        $ctx->stash('archive_category', $this_cat);
        $ctx->{inside_mt_categories} = 1;
        $ctx->{__stash}{category} = $this_cat;
    } else {
        if (!$this_cat) {
            return "";
        }
        my $label = '';
        $label = dirify($this_cat->label);
        if ($label !~ /\w/) {
            $label = $this_cat ? "cat" .  $this_cat->id : "";
        }
        my $start = start_end_day($timestamp, $blog);
        my($year, $month, $day) = unpack 'A4A2A2', $start;
        $file = sprintf("%s/%04d/%02d/%02d/index", $this_cat->category_path, $year, $month, $day);
    }
    $file;
}

sub daily_date_range { start_end_day(@_) }

sub daily_archive_title {
    my ($ctx, $entry_or_ts) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_day($stamp, $ctx->stash('blog'));
    my $date = MT::Template::Context::_hdlr_date($ctx, { ts => $start, 'format' => "%x" });
    my $cat = _display_category($ctx);

    sprintf("%s%s", $cat, $date);
}

sub daily_group_iter {
    my ($ctx, $args) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order = ($args->{sort_order} || '') eq 'ascend' ? 'ascend' : 'descend';
    my $cat_order =  $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ($sort_order eq 'ascend') ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;
    my $tmpl = $ctx->stash('template');
    my $cat = $ctx->stash('archive_category') || $ctx->stash('category');
    my @data = ();
    my $count = 0;
    my $ts = $ctx->{current_timestamp};
    my $tsend = $ctx->{current_timestamp_end};

    require MT::Placement;
    require MT::Entry;
    my $loop_sub = sub {
        my $c = shift;
        my $entry_iter = MT::Entry->count_group_by(
                    {blog_id => $blog->id,
                     status => MT::Entry::RELEASE(),
                      ($ts && $tsend ? (authored_on => [$ts, $tsend] ) : ()),
                     },
                     {($ts && $tsend ? (range_incl => { authored_on => 1 }) : ()),
                     group => ["extract(year from authored_on)",
                               "extract(month from authored_on)",
                               "extract(day from authored_on)"],
                     sort => "extract(year from authored_on) $order,
                              extract(month from authored_on) $order,
                              extract(day from authored_on) $order",
                     'join' => [ 'MT::Placement', 'entry_id',
                          { category_id => $c->id } ]})
            or return $ctx->error("Couldn't get yearly archive list");
        while (my @row = $entry_iter->()) {
            my $hash = {
                year => $row[1],
                month => $row[2],
                day => $row[3],
                category => $c,
                count => $row[0],
            };
            push(@data, $hash);
            return $count+1 if (defined($limit) && ($count+1) == $limit);
            $count++;
        }
    };

    if ($cat) {
        $loop_sub->($cat);
    } else {
        require MT::Category;
        my $iter = MT::Category->load_iter({ blog_id => $blog->id },
            { 'sort' => 'label', direction => $cat_order });
        while (my $category = $iter->()) {
            $loop_sub->($category);
            last if (defined($limit) && $count == $limit);
        } 
    }

    my $loop = @data;
    my $curr = 0;

    return sub {
        if( $curr < $loop) {
            my $date = sprintf("%04d%02d%02d000000",
                $data[$curr]->{year}, $data[$curr]->{month}, $data[$curr]->{day});
            my ($start, $end) = start_end_day($date);
            my $count = $data[$curr]->{count};
            my %hash = (
                category => $data[$curr]->{category},
                year => $data[$curr]->{year},
                month => $data[$curr]->{month},
                day => $data[$curr]->{day},
                start => $start,
                end => $end,
            );
            $curr++;
            return ($count, %hash);
        }
        undef;
    }
}

sub daily_group_entries {
    my ($ctx, %param) = @_;

    my $ts = %param ? sprintf("%04d%02d%02d000000",
            $param{year}, $param{month}, $param{day}) : $ctx->stash('current_timestamp');
    my $cat = %param ? $param{category} : $ctx->stash('archive_category');

    date_based_category_entries($ctx, 'Category-Daily',
        $cat, $ts) ;
}

sub weekly_archive_label {
    $plugin->translate('CATEGORY-WEEKLY_ADV');
}

sub weekly_archive_file {
    my ($ctx, %param) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog = $ctx->{__stash}{blog};
    my $cat = $ctx->{__stash}{cat} || $ctx->{__stash}{category};
    my $entry = $ctx->{__stash}{entry};
    my $file;

    my $this_cat = $cat ? $cat : ($entry ? $entry->category : undef);
    if ($file_tmpl) {
        ($ctx->{current_timestamp}, $ctx->{current_timestamp_end}) =
            start_end_week($timestamp, $blog);
        $ctx->stash('archive_category', $this_cat);
        $ctx->{inside_mt_categories} = 1;
        $ctx->{__stash}{category} = $this_cat;
    } else {
        if (!$this_cat) {
            return "";
        }
        my $label = '';
        $label = dirify($this_cat->label);
        if ($label !~ /\w/) {
            $label = $this_cat ? "cat" .  $this_cat->id : "";
        }
        my $start = start_end_week($timestamp, $blog);
        my($year, $month, $day) = unpack 'A4A2A2', $start;
        $file = sprintf("%s/%04d/%02d/%02d-week/index", $this_cat->category_path, $year, $month, $day);
    }
    $file;
}

sub weekly_date_range { start_end_week(@_) }

sub weekly_archive_title {
    my ($ctx, $entry_or_ts) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my ($start, $end) = start_end_week($stamp, $ctx->stash('blog'));
    my $start_date = MT::Template::Context::_hdlr_date($ctx, { ts => $start, 'format' => "%x" });
    my $end_date = MT::Template::Context::_hdlr_date($ctx, { ts => $end, 'format' => "%x" });
    my $cat = _display_category($ctx);

    sprintf("%s%s - %s", $cat, $start_date, $end_date);
}

sub weekly_group_iter {
    my ($ctx, $args) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order = ($args->{sort_order} || '') eq 'ascend' ? 'ascend' : 'descend';
    my $cat_order =  $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ($sort_order eq 'ascend') ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;
    my $tmpl = $ctx->stash('template');
    my $cat = $ctx->stash('archive_category') || $ctx->stash('category');
    my @data = ();
    my $count = 0;
    my $ts = $ctx->{current_timestamp};
    my $tsend = $ctx->{current_timestamp_end};

    require MT::Placement;
    require MT::Entry;
    my $loop_sub = sub {
        my $c = shift;
        my $entry_iter = MT::Entry->count_group_by(
                    {blog_id => $blog->id,
                     status => MT::Entry::RELEASE(),
                      ($ts && $tsend ? (authored_on => [$ts, $tsend] ) : ()),
                     },
                     {($ts && $tsend ? (range_incl => { authored_on => 1 }) : ()),
                     group => ["week_number"],
                     sort => "week_number $order",
                     'join' => [ 'MT::Placement', 'entry_id',
                          { category_id => $c->id } ]})
            or return $ctx->error("Couldn't get weekly archive list");
        while (my @row = $entry_iter->()) {
            my ($year, $week) = unpack 'A4A2', $row[1];
            my $hash = {
                year => $year,
                week => $week,
                category => $c,
                count => $row[0],
            };
            push(@data, $hash);
            return $count+1 if (defined($limit) && ($count+1) == $limit);
            $count++;
        }
    };

    if ($cat) {
        $loop_sub->($cat);
    } else {
        require MT::Category;
        my $iter = MT::Category->load_iter({ blog_id => $blog->id },
            { 'sort' => 'label', direction => $cat_order });
        while (my $category = $iter->()) {
            $loop_sub->($category);
            last if (defined($limit) && $count == $limit);
        } 
    }

    my $loop = @data;
    my $curr = 0;

    return sub {
        if( ($curr) < $loop) {
            my $date = sprintf("%04d%02d%02d000000",
                week2ymd($data[$curr]->{year}, $data[$curr]->{week}));
            my ($start, $end) = start_end_week($date);
            my $count = $data[$curr]->{count};
            my %hash = (
                category => $data[$curr]->{category},
                year => $data[$curr]->{year},
                week => $data[$curr]->{week},
                start => $start,
                end => $end,
            );
            $curr++;
            return ($count, %hash);
        }
        undef;
    }
}

sub weekly_group_entries {
    my ($ctx, %param) = @_;
    my $ts = %param ? sprintf("%04d%02d%02d000000",
            week2ymd($param{year}, $param{week})) : $ctx->stash('current_timestamp');
    my $cat = %param ? $param{category} : $ctx->stash('archive_category');

    date_based_category_entries($ctx, 'Category-Weekly',
        $cat, $ts) ;
}
 
sub date_based_category_entries {
    my ($ctx, $at, $cat, $ts) = @_;

    my $blog = $ctx->stash('blog');
    my $archiver = MT->publisher->archiver($at);
    my ($start, $end);
    if ($ts) {
        ($start, $end) = $archiver->date_range->($ts);
    } else {
        $start = $ctx->{current_timestamp};
        $end = $ctx->{current_timestamp_end};
    }
    my @entries = MT::Entry->load({blog_id => $blog->id,
                     status => MT::Entry::RELEASE(),
                     authored_on => [ $start, $end ]},
                     {range => {authored_on => 1},
                      'join' => [ 'MT::Placement', 'entry_id',
                                  { category_id => $cat->id } ]})
        or return $ctx->error("Couldn't get $at archive list");
    \@entries;
}

1;
