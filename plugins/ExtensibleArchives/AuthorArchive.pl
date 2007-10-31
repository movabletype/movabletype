# Extensible Archives plugins for Movable Type
# Author: Six Apart http://www.sixapart.com
# Released under the Artistic License
#
# $Id$
package MT::Plugin::ExtensibleArchives::AuthorArchive;

use strict;
use base qw( MT::Plugin );

use MT;
use MT::Util qw( dirify start_end_day start_end_year 
                 start_end_week start_end_month week2ymd );

my $plugin = __PACKAGE__->new({
    name => "Author Archives",
    version => '1.0',
    description => "<MT_TRANS phrase=\"TBD\">",
    author_name => "Six Apart, Ltd.",
    author_link => "http://www.sixapart.com/",
    l10n_class => 'AuthorArchive::L10N',
});
MT->add_plugin($plugin);

use MT::WeblogPublisher;
sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        archive_types => {
        'Author' =>
        ArchiveType(
            name => 'Author',
            archive_label => \&author_archive_label,
            archive_file => \&author_archive_file,
            archive_title => \&author_archive_title,
            archive_group_iter => \&author_group_iter,
            archive_group_entries => \&author_group_entries,
            default_archive_templates => [
                ArchiveFileTemplate(label => 'author_display_name/index.html',
                                    template => '%a/%f',
                                    default => 1),
                ArchiveFileTemplate(label => 'author-display-name/index.html',
                                    template => '%-a/%f'),
            ],
            dynamic_template => 'author/<$MTEntryAuthorID$>/<$MTEntryID$>',
            dynamic_support => 1,
            author_based => 1,
            template_params => {
                archive_class => "author-archive",
                'module_author-monthly_archives' => 1,
                module_author_archives => 1,
                main_template => 1,
                author_archive => 1,
                archive_template => 1,
            },
        ),
        'Author-Yearly' =>
        ArchiveType(
            name => 'Author-Yearly',
            archive_label => \&author_yearly_archive_label,
            archive_file => \&author_yearly_archive_file,
            archive_title => \&author_yearly_archive_title,
            archive_group_iter => \&author_yearly_group_iter,
            archive_group_entries => \&author_yearly_group_entries,
            date_range => \&author_yearly_date_range,
            default_archive_templates => [
                ArchiveFileTemplate(label => 'author_display_name/yyyy/index.html',
                                    template => '%a/%y/%f',
                                    default => 1),
                ArchiveFileTemplate(label => 'author-display-name/yyyy/index.html',
                                    template => '%-a/%y/%f'),
            ],
            dynamic_template => 'author/<$MTEntryAuthorID$>/<$MTArchiveDate format="%Y"$>',
            dynamic_support => 1,
            author_based => 1,
            date_based => 1,
            template_params => {
                archive_class => "author-yearly-archive",
                author_yearly_archive => 1,
                main_template => 1,
                archive_template => 1,
            },
        ),
        'Author-Monthly' =>
        ArchiveType(
            name => 'Author-Monthly',
            archive_label => \&author_monthly_archive_label,
            archive_file => \&author_monthly_archive_file,
            archive_title => \&author_monthly_archive_title,
            archive_group_iter => \&author_monthly_group_iter,
            archive_group_entries => \&author_monthly_group_entries,
            date_range => \&author_monthly_date_range,
            default_archive_templates => [
                ArchiveFileTemplate(label => 'author_display_name/yyyy/mm/index.html',
                                    template => '%a/%y/%m/%f',
                                    default => 1),
                ArchiveFileTemplate(label => 'author-display-name/yyyy/mm/index.html',
                                    template => '%-a/%y/%m/%f'),
            ],
            dynamic_template => 'author/<$MTEntryAuthorID$>/<$MTArchiveDate format="%Y%m"$>',
            dynamic_support => 1,
            author_based => 1,
            date_based => 1,
            template_params => {
                archive_class => "author-monthly-archive",
                author_monthly_archive => 1,
                'module_author-monthly_archives' => 1,
                module_author_archives => 1,
                main_template => 1,
                archive_template => 1,
            },
        ),
        'Author-Weekly' =>
        ArchiveType(
            name => 'Author-Weekly',
            archive_label => \&author_weekly_archive_label,
            archive_file => \&author_weekly_archive_file,
            archive_title => \&author_weekly_archive_title,
            archive_group_iter => \&author_weekly_group_iter,
            archive_group_entries => \&author_weekly_group_entries,
            date_range => \&author_weekly_date_range,
            default_archive_templates => [
                ArchiveFileTemplate(label => 'author_display_name/yyyy/mm/day-week/index.html',
                                    template => '%a/%y/%m/%d-week/%f',
                                    default => 1),
                ArchiveFileTemplate(label => 'author-display-name/yyyy/mm/day-week/index.html',
                                    template => '%-a/%y/%m/%d-week/%f'),
            ],
            dynamic_template => 'author/<$MTEntryAuthorID$>/week/<$MTArchiveDate format="%Y%m%d"$>',
            dynamic_support => 1,
            author_based => 1,
            date_based => 1,
            template_params => {
                archive_class => "author-weekly-archive",
                author_weekly_archive => 1,
                main_template => 1,
                archive_template => 1,
            },
        ),
        'Author-Daily' =>
        ArchiveType(
            name => 'Author-Daily',
            archive_label => \&author_daily_archive_label,
            archive_file => \&author_daily_archive_file,
            archive_title => \&author_daily_archive_title,
            archive_group_iter => \&author_daily_group_iter,
            archive_group_entries => \&author_daily_group_entries,
            date_range => \&author_daily_date_range,
            default_archive_templates => [
                ArchiveFileTemplate(label => 'author_display_name/yyyy/mm/dd/index.html',
                                    template => '%a/%y/%m/%d/%f',
                                    default => 1),
                ArchiveFileTemplate(label => 'author-display-name/yyyy/mm/dd/index.html',
                                    template => '%-a/%y/%m/%d/%f'),
            ],
            dynamic_template => 'author/<$MTEntryAuthorID$>/<$MTArchiveDate format="%Y%m%d"$>',
            dynamic_support => 1,
            author_based => 1,
            date_based => 1,
            template_params => {
                archive_class => "author-daily-archive",
                author_daily_archive => 1,
                main_template => 1,
                archive_template => 1,
            },
        ),
    }});
}

# returns a title for this active archive type
sub author_archive_title {
    my ($ctx) = @_;
    my $a = $ctx->stash('author');
    $a ? $a->nickname || $plugin->translate('Author (#[_1])', $a->id) : '';
}

sub author_archive_label {
    $plugin->translate('AUTHOR_ADV');
}

# returns the archive file path and name for this archive type
sub author_archive_file {
    my ($ctx, %param) = @_;
    my $file_tmpl = $param{Template};
    my $author = $ctx->{__stash}{author};
    my $entry = $ctx->{__stash}{entry};
    my $file;

    my $this_author = $author ? $author : ($entry ? $entry->author : undef);
    return "" unless $this_author;

    my $name = dirify($this_author->nickname);
    $name = "author" . $this_author->id if $name !~ /\w/;
    $ctx->{__stash}{current_author_name} = $name;
    if (!$file_tmpl){
        $file = sprintf("%s/index", $name);
    }
    $file;
}

sub author_group_iter {
    my ($ctx, $args) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order = ($args->{sort_order} || '') eq 'ascend' ? 'ascend' : 'descend';
    my $auth_order =  $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ($sort_order eq 'ascend') ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;
    require MT::Entry;
    require MT::Author;
    my $auth_iter = MT::Author->load_iter( undef,
        { sort => 'name', direction => $auth_order, join => ['MT::Entry', 'author_id',
          { status => MT::Entry::RELEASE(), blog_id => $blog->id }, { unique => 1 } ] });
    my $i = 0;
    return sub {
        while (my $a = $auth_iter->()) {
            last if defined($limit) && $i == $limit;
            my $count = MT::Entry->count({blog_id => $blog->id,
                     status => MT::Entry::RELEASE(),
                     author_id => $a->id});
            next if $count == 0 && !$args->{show_empty};
            $i++;
            return ($count, author => $a);
        }
        undef;
    };
}

sub author_group_entries {
    my ($ctx, %param) = @_;
    my $blog = $ctx->stash('blog');
    my $a = $param{author} || $ctx->stash('author');
    return [] unless $a;
    require MT::Entry;
    my @entries = MT::Entry->load({ blog_id => $blog->id,
        author_id => $a->id, status => MT::Entry::RELEASE() });
    \@entries;
}

sub _display_name {
    my ($ctx) = shift;
    my $tmpl = $ctx->stash('template');
    my $at = $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    my $author = '';
    if (($tmpl && $tmpl->type eq 'index') ||
        !$archiver || ($archiver && !$archiver->author_based) ||
        !$ctx->{inside_archive_list})
    {
        $author = $ctx->stash('author');
        $author = $author ?
                    $author->nickname ?
                        $author->nickname.": "
                        : $plugin->translate('Author (#[_1])', $author->id)
                    : '';
    }
    return $author;
}

# ----- Date based -----
sub author_yearly_archive_title {
    my ($ctx, $entry_or_ts) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_year($stamp);
    my $year = MT::Template::Context::_hdlr_date($ctx, { ts => $start, 'format' => "%Y" });
    my $lang = lc MT->current_language || 'en_us';
    $lang = 'ja' if lc($lang) eq 'jp';        
    my $author = _display_name($ctx);

    sprintf("%s%s%s", $author, $year, ($lang eq 'ja' ? '&#24180;' : ''));
}

sub author_yearly_archive_label {
    $plugin->translate('AUTHOR-YEARLY_ADV');
}

sub author_yearly_archive_file {
    my ($ctx, %param) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $author = $ctx->{__stash}{author};
    my $entry = $ctx->{__stash}{entry};
    my $file;
    my $this_author = $author ? $author : ($entry ? $entry->author : undef);
        return "" unless $this_author;
    my $name = dirify($this_author->nickname);
    if ($name eq '' || !$file_tmpl){
        return "" unless $this_author;
        $name = "author" .  $this_author->id if $name !~ /\w/;
        my $start = start_end_year($timestamp);
        my($year) = unpack 'A4', $start;
        $file = sprintf("%s/%04d/index", $name, $year);
    } else {
        ($ctx->{current_timestamp}, $ctx->{current_timestamp_end}) =
            start_end_year($timestamp);
    }
    $file;
}

sub author_yearly_group_iter {
    my ($ctx, $args) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order = ($args->{sort_order} || '') eq 'ascend' ? 'ascend' : 'descend';
    my $auth_order =  $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ($sort_order eq 'ascend') ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;

    my $tmpl = $ctx->stash('template');
    my @data = ();
    my $count = 0;
    
    my $at = $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    my $author;
    # if (($tmpl && $tmpl->type ne 'index') &&
    #     ($archiver && $archiver->author_based))
    # {
        $author = $ctx->stash('author');
    # }
    
    require MT::Entry;
    my $loop_sub = sub {
        my $auth = shift;
        my $count_iter = MT::Entry->count_group_by(
            { blog_id => $blog->id,
              author_id => $auth->id,
              status => MT::Entry::RELEASE()},
            { group => ["extract(year from authored_on)"],
              'sort' => "extract(year from authored_on) $order"})
            or return $ctx->error("Couldn't get monthly archive list");

        while (my @row = $count_iter->()) {
            my $hash = {
                year => $row[1],
                author => $auth,
                count => $row[0],
            };
            push(@data, $hash);
            return $count+1 if (defined($limit) && ($count+1) == $limit);
            $count++;
        }
        return $count;
    };

    # Count entry by author
    if ($author) {
        $loop_sub->($author);
    } else {
        # load authors
        require MT::Author;
        my $iter;
        $iter = MT::Author->load_iter( undef,
            { sort => 'name', direction => $auth_order, join => ['MT::Entry', 'author_id',
            { status => MT::Entry::RELEASE(), blog_id => $blog->id }, { unique => 1 } ] });
    
        while (my $a = $iter->()) {
            $loop_sub->($a);
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
                author => $data[$curr]->{author},
                year => $data[$curr]->{year},
                start => $start,
                end => $end
            );
            $curr++;
            return ($count, %hash);
        }
        undef;
    }
}

sub author_yearly_group_entries {
    my ($ctx, %param) = @_;
    my $ts = %param ? sprintf("%04d%02d%02d000000",
            $param{year}, 1, 1) : $ctx->stash('current_timestamp');
    my $author = %param ? $param{author} : $ctx->stash('author');
    date_based_author_entries($ctx, 'Author-Yearly', $author, $ts);
}

sub author_yearly_date_range { start_end_year(@_) }

sub author_monthly_archive_title {
    my ($ctx, $entry_or_ts) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_month($stamp);
    my $date = MT::Template::Context::_hdlr_date($ctx, { ts => $start, 'format' => "%B %Y" });
    my $author = _display_name($ctx);

    sprintf("%s%s", $author, $date);
}

sub author_monthly_archive_label {
    $plugin->translate('AUTHOR-MONTHLY_ADV');
}

sub author_monthly_archive_file {
    my ($ctx, %param) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $author = $ctx->{__stash}{author};
    my $entry = $ctx->{__stash}{entry};
    my $file;
    my $this_author = $author ? $author : ($entry ? $entry->author : undef);
        return "" unless $this_author;
    my $name = dirify($this_author->nickname);
    if ($name eq '' || !$file_tmpl){
        return "" unless $this_author;
        $name = "author" .  $this_author->id if $name !~ /\w/;
        my $start = start_end_month($timestamp);
        my($year, $month) = unpack 'A4A2', $start;
        $file = sprintf("%s/%04d/%02d/index", $name, $year, $month);
    } else {
        ($ctx->{current_timestamp}, $ctx->{current_timestamp_end}) =
            start_end_month($timestamp);
    }
    $file;
}

sub author_monthly_group_iter {
    my ($ctx, $args) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order = ($args->{sort_order} || '') eq 'ascend' ? 'ascend' : 'descend';
    my $auth_order =  $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ($sort_order eq 'ascend') ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;

    my $tmpl = $ctx->stash('template');
    my @data = ();
    my $count = 0;
    
    my $at = $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    my $author;

    my $ts = $ctx->{current_timestamp};
    my $tsend = $ctx->{current_timestamp_end};

    # if (($tmpl && $tmpl->type ne 'index') &&
    #     ($archiver && $archiver->author_based))
    # {
        $author = $ctx->stash('author');
    # }
    
    require MT::Entry;
    my $loop_sub = sub {
        my $auth = shift;
        my $count_iter = MT::Entry->count_group_by(
            { blog_id => $blog->id,
              author_id => $auth->id,
              status => MT::Entry::RELEASE(),
              ( $ts && $tsend ? ( authored_on => [ $ts, $tsend ] ) : () ),
            },
            { ( $ts && $tsend ? ( range_incl => { authored_on => 1 } ): () ),
              group => ["extract(year from authored_on)",
                        "extract(month from authored_on)"],
              'sort' => "extract(year from authored_on) $order,
                         extract(month from authored_on) $order"})
            or return $ctx->error("Couldn't get monthly archive list");

        while (my @row = $count_iter->()) {
            my $hash = {
                year => $row[1],
                month => $row[2],
                author => $auth,
                count => $row[0],
            };
            push(@data, $hash);
            return $count+1 if (defined($limit) && ($count+1) == $limit);
            $count++;
        }
        return $count;
    };
    
    # Count entry by author
    if ($author) {
        $loop_sub->($author);
    } else {
        # load authors
        require MT::Author;
        my $iter;
        $iter = MT::Author->load_iter( undef,
            { sort => 'name', direction => $auth_order, join => ['MT::Entry', 'author_id',
            { status => MT::Entry::RELEASE(), blog_id => $blog->id }, { unique => 1 } ] });
    
        while (my $a = $iter->()) {
            $loop_sub->($a);
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
                author => $data[$curr]->{author},
                year => $data[$curr]->{year},
                month => $data[$curr]->{month},
                start => $start,
                end => $end
            );
            $curr++;
            return ($count, %hash);
        }
        undef;
    }
}

sub author_monthly_group_entries {
    my ($ctx, %param) = @_;
    my $ts = %param ? sprintf("%04d%02d%02d000000",
            $param{year}, $param{month}, 1) : $ctx->stash('current_timestamp');
    my $author = %param ? $param{author} : $ctx->stash('author');
    date_based_author_entries($ctx, 'Author-Monthly', $author, $ts);
}

sub author_monthly_date_range { start_end_month(@_) }

sub author_weekly_archive_title {
    my ($ctx, $entry_or_ts) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my ($start, $end) = start_end_week($stamp);
    my $start_date = MT::Template::Context::_hdlr_date($ctx, { ts => $start, 'format' => "%x" });
   my $end_date = MT::Template::Context::_hdlr_date($ctx, { ts => $end, 'format' => "%x" });
    my $author = _display_name($ctx);

    sprintf("%s%s - %s", $author, $start_date, $end_date);
}

sub author_weekly_archive_label {
    $plugin->translate('AUTHOR-WEEKLY_ADV');
}

sub author_weekly_archive_file {
    my ($ctx, %param) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $author = $ctx->{__stash}{author};
    my $entry = $ctx->{__stash}{entry};
    my $file;
    my $this_author = $author ? $author : ($entry ? $entry->author : undef);
        return "" unless $this_author;
    my $name = dirify($this_author->nickname);
    if ($name eq '' || !$file_tmpl){
        return "" unless $this_author;
        $name = "author" .  $this_author->id if $name !~ /\w/;
        my $start = start_end_week($timestamp);
        my($year, $month, $day) = unpack 'A4A2A2', $start;
        $file = sprintf("%s/%04d/%02d/%02d-week/index", $name, $year, $month, $day);
    } else {
        ($ctx->{current_timestamp}, $ctx->{current_timestamp_end}) =
            start_end_week($timestamp);
    }
    $file;
}

sub author_weekly_group_iter {
    my ($ctx, $args) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order = ($args->{sort_order} || '') eq 'ascend' ? 'ascend' : 'descend';
    my $auth_order =  $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ($sort_order eq 'ascend') ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;

    my $tmpl = $ctx->stash('template');
    my @data = ();
    my $count = 0;

    my $ts = $ctx->{current_timestamp};
    my $tsend = $ctx->{current_timestamp_end};

    my $at = $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    my $author;
    # if (($tmpl && $tmpl->type ne 'index') &&
    #     ($archiver && $archiver->author_based)) 
    # {
        $author = $ctx->stash('author');
    # }
    
    require MT::Entry;
    my $loop_sub = sub {
        my $auth = shift;
        my $count_iter = MT::Entry->count_group_by(
            { blog_id => $blog->id,
              author_id => $auth->id,
              status => MT::Entry::RELEASE(),
              ( $ts && $tsend ? ( authored_on => [ $ts, $tsend ] ) : () ),
            },
            { ( $ts && $tsend ? ( range_incl => { authored_on => 1 } ): () ),
              group => ["week_number"],
              'sort' => "week_number $order"})
            or return $ctx->error("Couldn't get weekly archive list");

        while (my @row = $count_iter->()) {
            my ($year, $week) = unpack 'A4A2', $row[1];
            my $hash = {
                year => $year,
                week => $week,
                author => $auth,
                count => $row[0],
            };
            push(@data, $hash);
            return $count+1 if (defined($limit) && ($count+1) == $limit);
            $count++;
        }
        return $count;
    };
    
    # Count entry by author
    if ($author) {
        $loop_sub->($author);
    } else {
        # load authors
        require MT::Author;
        my $iter;
        $iter = MT::Author->load_iter( undef,
            { sort => 'name', direction => $auth_order, join => ['MT::Entry', 'author_id',
            { status => MT::Entry::RELEASE(), blog_id => $blog->id }, { unique => 1 } ] });

        while (my $a = $iter->()) {
            $loop_sub->($a);
            last if (defined($limit) && $count == $limit);
        }
    }

    my $loop = @data;
    my $curr = 0;

    return sub {
        if( $curr < $loop) {
            my $date = sprintf("%04d%02d%02d000000",
                week2ymd($data[$curr]->{year}, $data[$curr]->{week}));
            my ($start, $end) = start_end_week($date);
            my $count = $data[$curr]->{count};
            my %hash = (
                author => $data[$curr]->{author},
                year => $data[$curr]->{year},
                week => $data[$curr]->{week},
                start => $start,
                end => $end
            );
            $curr++;
            return ($count, %hash);
        }
        undef;
    }
}

sub author_weekly_group_entries {
    my ($ctx, %param) = @_;
    my $ts = %param ? sprintf("%04d%02d%02d000000",
            week2ymd($param{year}, $param{week})) : $ctx->stash('current_timestamp');
    my $author = %param ? $param{author} : $ctx->stash('author');
    date_based_author_entries($ctx, 'Author-Weekly', $author, $ts);
}

sub author_weekly_date_range { start_end_week(@_) }

sub author_daily_archive_title {
    my ($ctx, $entry_or_ts) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_day($stamp);
    my $date = MT::Template::Context::_hdlr_date($ctx, { ts => $start, 'format' => "%x" });
    my $author = _display_name($ctx);

    sprintf("%s%s", $author, $date);
}

sub author_daily_archive_label {
    $plugin->translate('AUTHOR-DAILY_ADV');
}

sub author_daily_archive_file {
    my ($ctx, %param) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $author = $ctx->{__stash}{author};
    my $entry = $ctx->{__stash}{entry};
    my $file;
    my $this_author = $author ? $author : ($entry ? $entry->author : undef);
        return "" unless $this_author;
    my $name = dirify($this_author->nickname);
    if ($name eq '' || !$file_tmpl){
        return "" unless $this_author;
        $name = "author" .  $this_author->id if $name !~ /\w/;
        my $start = start_end_day($timestamp);
        my($year, $month, $day) = unpack 'A4A2A2', $start;
        $file = sprintf("%s/%04d/%02d/%02d/index", $name, $year, $month, $day);
    } else {
        ($ctx->{current_timestamp}, $ctx->{current_timestamp_end}) =
            start_end_day($timestamp);
    }
    $file;
}

sub author_daily_group_iter {
    my ($ctx, $args) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order = ($args->{sort_order} || '') eq 'ascend' ? 'ascend' : 'descend';
    my $auth_order =  $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ($sort_order eq 'ascend') ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;

    my $tmpl = $ctx->stash('template');
    my @data = ();
    my $count = 0;

    my $ts = $ctx->{current_timestamp};
    my $tsend = $ctx->{current_timestamp_end};
    
    my $at = $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    my $author;
    # if (($tmpl && $tmpl->type ne 'index') &&
    #     ($archiver && $archiver->author_based)) 
    # {
        $author = $ctx->stash('author');
    # }
    
    require MT::Entry;
    my $loop_sub = sub {
        my $auth = shift;
        my $count_iter = MT::Entry->count_group_by(
            { blog_id => $blog->id,
              author_id => $auth->id,
              status => MT::Entry::RELEASE(),
              ( $ts && $tsend ? ( authored_on => [ $ts, $tsend ] ) : () ),
            },
            { ( $ts && $tsend ? ( range_incl => { authored_on => 1 } ): () ),
              group => ["extract(year from authored_on)",
                        "extract(month from authored_on)",
                        "extract(day from authored_on)"],
              'sort' => "extract(year from authored_on) $order,
                         extract(month from authored_on) $order,
                         extract(day from authored_on) $order"})
            or return $ctx->error("Couldn't get monthly archive list");

        while (my @row = $count_iter->()) {
            my $hash = {
                year => $row[1],
                month => $row[2],
                day => $row[3],
                author => $auth,
                count => $row[0],
            };
            push(@data, $hash);
            return $count+1 if (defined($limit) && ($count+1) == $limit);
            $count++;
        }
        return $count;
    };
    
    # Count entry by author
    if ($author) {
        $loop_sub->($author);
    } else {
        # load authors
        require MT::Author;
        my $iter;
        $iter = MT::Author->load_iter( undef,
            { sort => 'name', direction => $auth_order, join => ['MT::Entry', 'author_id',
            { status => MT::Entry::RELEASE(), blog_id => $blog->id }, { unique => 1 } ] });
    
        while (my $a = $iter->()) {
            $loop_sub->($a);
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
                author => $data[$curr]->{author},
                year => $data[$curr]->{year},
                month => $data[$curr]->{month},
                day => $data[$curr]->{day},
                start => $start,
                end => $end
            );
            $curr++;
            return ($count, %hash);
        }
        undef;
    }
}

sub author_daily_group_entries {
    my ($ctx, %param) = @_;
    my $ts = %param ? sprintf("%04d%02d%02d000000",
            $param{year}, $param{month}, $param{day}) : $ctx->stash('current_timestamp');
    my $author = %param ? $param{author} : $ctx->stash('author');
    date_based_author_entries($ctx, 'Author-Daily', $author, $ts);
}

sub author_daily_date_range { start_end_day(@_) }

sub date_based_author_entries {
    my ($ctx, $at, $author, $ts) = @_;

    my $blog = $ctx->stash('blog');
    my $archiver = MT->publisher->archiver($at);
    my ($start, $end);
    if ($ts) {
        ($start, $end) = $archiver->date_range->($ts);
    } else {
        $start = $ctx->{current_timestamp};
        $end = $ctx->{current_timestamp_end};
    }
    my @entries = MT::Entry->load(
        { blog_id => $blog->id,
          author_id => $author->id,
          status => MT::Entry::RELEASE(),
          authored_on => [ $start, $end ]},
        { range => {authored_on => 1}, })
        or return $ctx->error("Couldn't get $at archive list");
    \@entries;
}

1;

