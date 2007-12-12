# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::WeblogPublisher;

use strict;
use base qw( MT::ErrorHandler Exporter );

use MT::Util qw( start_end_period start_end_day start_end_year
  start_end_week start_end_month week2ymd
  dirify );
use MT::I18N qw( lowercase );
use File::Basename;

our @EXPORT = qw(ArchiveFileTemplate ArchiveType);
my %ArchiveTypes;

sub ArchiveFileTemplate {
    my %param = @_;
    \%param;
}

sub ArchiveType {
    new MT::ArchiveType(@_);
}

sub new {
    my $class = shift;
    my $this  = {@_};
    my $cfg   = MT->config;
    if ( !exists $this->{NoTempFiles} ) {
        $this->{NoTempFiles} = $cfg->NoTempFiles;
    }
    if ( !exists $this->{PublishCommenterIcon} ) {
        $this->{PublishCommenterIcon} = $cfg->PublishCommenterIcon;
    }
    bless $this, $class;
    $this->init();
    $this;
}

sub init_archive_types {
    my $types = MT->registry("archive_types") || {};
    $ArchiveTypes{$_} = $types->{$_} for keys %$types;
}

sub archive_types {
    init_archive_types() unless %ArchiveTypes;
    keys %ArchiveTypes;
}

sub archiver {
    my $mt = shift;
    my ($at) = @_;
    init_archive_types() unless %ArchiveTypes;
    $at ? $ArchiveTypes{$at} : undef;
}

sub init {
    init_archive_types() unless %ArchiveTypes;
}

sub core_archive_types {
    return {
        'Yearly' => ArchiveType(
            name                  => 'Yearly',
            archive_label         => \&yearly_archive_label,
            archive_file          => \&yearly_archive_file,
            archive_title         => \&yearly_archive_title,
            date_range            => \&yearly_date_range,
            archive_group_iter    => \&yearly_group_iter,
            archive_group_entries => \&yearly_group_entries,
            archive_entries_count => \&yearly_entries_count,
            dynamic_template      => 'archives/<$MTArchiveDate format="%Y"$>',
            default_archive_templates => [
                ArchiveFileTemplate(
                    label    => MT->translate('yyyy/index.html'),
                    template => '%y/%i',
                    default  => 1
                ),
            ],
            dynamic_support => 1,
            date_based      => 1,
            template_params => {
                datebased_only_archive   => 1,
                datebased_yearly_archive => 1,
                module_yearly_archives   => 1,
                main_template            => 1,
                archive_template         => 1,
                archive_class            => "datebased-yearly-archive",
            },
        ),
        'Monthly' => ArchiveType(
            name                  => 'Monthly',
            archive_label         => \&monthly_archive_label,
            archive_file          => \&monthly_archive_file,
            archive_title         => \&monthly_archive_title,
            date_range            => \&monthly_date_range,
            archive_group_iter    => \&monthly_group_iter,
            archive_group_entries => \&monthly_group_entries,
            archive_entries_count => \&monthly_entries_count,
            dynamic_template      => 'archives/<$MTArchiveDate format="%Y%m"$>',
            default_archive_templates => [
                ArchiveFileTemplate(
                    label    => MT->translate('yyyy/mm/index.html'),
                    template => '%y/%m/%i',
                    default  => 1
                ),
            ],
            dynamic_support => 1,
            date_based      => 1,
            template_params => {
                datebased_only_archive    => 1,
                datebased_monthly_archive => 1,
                module_monthly_archives   => 1,
                main_template             => 1,
                archive_template          => 1,
                archive_class             => "datebased-monthly-archive",
            },
        ),
        'Weekly' => ArchiveType(
            name                  => 'Weekly',
            archive_label         => \&weekly_archive_label,
            archive_file          => \&weekly_archive_file,
            archive_title         => \&weekly_archive_title,
            date_range            => \&weekly_date_range,
            archive_group_iter    => \&weekly_group_iter,
            archive_group_entries => \&weekly_group_entries,
            archive_entries_count => \&weekly_entries_count,
            dynamic_template =>
              'archives/week/<$MTArchiveDate format="%Y%m%d"$>',
            default_archive_templates => [
                ArchiveFileTemplate(
                    label    => MT->translate('yyyy/mm/day-week/index.html'),
                    template => '%y/%m/%d-week/%i',
                    default  => 1
                ),
            ],
            dynamic_support => 1,
            date_based      => 1,
            template_params => {
                datebased_only_archive   => 1,
                datebased_weekly_archive => 1,
                main_template            => 1,
                archive_template         => 1,
                archive_class            => "datebased-weekly-archive",
            },
        ),
        'Individual' => ArchiveType(
            name                      => 'Individual',
            archive_label             => \&individual_archive_label,
            archive_file              => \&individual_archive_file,
            archive_title             => \&individual_archive_title,
            archive_group_iter        => \&individual_group_iter,
            dynamic_template          => 'entry/<$MTEntryID$>',
            default_archive_templates => [
                ArchiveFileTemplate(
                    label    => MT->translate('yyyy/mm/entry-basename.html'),
                    template => '%y/%m/%-f',
                    default  => 1
                ),
                ArchiveFileTemplate(
                    label    => MT->translate('yyyy/mm/entry_basename.html'),
                    template => '%y/%m/%f'
                ),
                ArchiveFileTemplate(
                    label => MT->translate('yyyy/mm/entry-basename/index.html'),
                    template => '%y/%m/%-b/%i'
                ),
                ArchiveFileTemplate(
                    label => MT->translate('yyyy/mm/entry_basename/index.html'),
                    template => '%y/%m/%b/%i'
                ),
                ArchiveFileTemplate(
                    label    => MT->translate('yyyy/mm/dd/entry-basename.html'),
                    template => '%y/%m/%d/%-f'
                ),
                ArchiveFileTemplate(
                    label    => MT->translate('yyyy/mm/dd/entry_basename.html'),
                    template => '%y/%m/%d/%f'
                ),
                ArchiveFileTemplate(
                    label =>
                      MT->translate('yyyy/mm/dd/entry-basename/index.html'),
                    template => '%y/%m/%d/%-b/%i'
                ),
                ArchiveFileTemplate(
                    label =>
                      MT->translate('yyyy/mm/dd/entry_basename/index.html'),
                    template => '%y/%m/%d/%b/%i'
                ),
                ArchiveFileTemplate(
                    label => MT->translate(
                        'category/sub-category/entry-basename.html'),
                    template => '%-c/%-f'
                ),
                ArchiveFileTemplate(
                    label => MT->translate(
                        'category/sub-category/entry-basename/index.html'),
                    template => '%-c/%-b/%i'
                ),
                ArchiveFileTemplate(
                    label => MT->translate(
                        'category/sub_category/entry_basename.html'),
                    template => '%c/%f'
                ),
                ArchiveFileTemplate(
                    label => MT->translate(
                        'category/sub_category/entry_basename/index.html'),
                    template => '%c/%b/%i'
                ),
            ],
            dynamic_support => 1,
            entry_based     => 1,
            template_params => {
                main_template     => 1,
                archive_template  => 1,
                entry_template    => 1,
                feedback_template => 1,
                archive_class     => "entry-archive",

                # module_recent_posts => 0,
                # module_monthly_archives => 0,
            },
        ),
        'Page' => ArchiveType(
            name                      => 'Page',
            archive_label             => \&page_archive_label,
            archive_file              => \&page_archive_file,
            archive_title             => \&individual_archive_title,
            archive_group_iter        => \&page_group_iter,
            dynamic_template          => 'page/<$MTEntryID$>',
            default_archive_templates => [
                ArchiveFileTemplate(
                    label    => MT->translate('folder-path/page-basename.html'),
                    template => '%-c/%-f',
                    default  => 1
                ),
                ArchiveFileTemplate(
                    label =>
                      MT->translate('folder-path/page-basename/index.html'),
                    template => '%-c/%-b/%i'
                ),
                ArchiveFileTemplate(
                    label    => MT->translate('folder_path/page_basename.html'),
                    template => '%c/%f'
                ),
                ArchiveFileTemplate(
                    label =>
                      MT->translate('folder_path/page_basename/index.html'),
                    template => '%c/%b/%i'
                ),
            ],
            dynamic_support => 1,
            entry_class     => 'page',
            entry_based     => 1,
            template_params => {
                archive_class     => "page-archive",
                page_archive      => 1,
                main_template     => 1,
                archive_template  => 1,
                page_template     => 1,
                feedback_template => 1,
            },
        ),

# 'Folder' =>
#     ArchiveType( name => 'Folder',
#         archive_label => \&folder_archive_label,
#         archive_file => \&folder_archive_file,
#         archive_title => \&folder_archive_title,
#         archive_group_iter => \&folder_group_iter,
#         archive_group_entries => \&folder_group_entries,
#         dynamic_template => 'folder/<$MTCategoryID$>',
#         default_archive_templates => [
#             ArchiveFileTemplate( Label => MT->translate('folder/sub_folder/index.html'),
#                 template => '%c/%i', Default => 1 ),
#             ArchiveFileTemplate( Label => MT->translate('folder/sub-folder/index.html'),
#                 template => '%-c/%i' ),
#             ],
#         dynamic_support => 1,
#         category_based => 1,
#     ),
        'Daily' => ArchiveType(
            name                  => 'Daily',
            archive_label         => \&daily_archive_label,
            archive_file          => \&daily_archive_file,
            archive_title         => \&daily_archive_title,
            date_range            => \&daily_date_range,
            archive_group_iter    => \&daily_group_iter,
            archive_group_entries => \&daily_group_entries,
            archive_entries_count => \&daily_entries_count,
            dynamic_template => 'archives/<$MTArchiveDate format="%Y%m%d"$>',
            default_archive_templates => [
                ArchiveFileTemplate(
                    label    => MT->translate('yyyy/mm/dd/index.html'),
                    template => '%y/%m/%d/%f',
                    default  => 1
                ),
            ],
            dynamic_support => 1,
            date_based      => 1,
            template_params => {
                archive_class           => "datebased-daily-archive",
                datebased_only_archive  => 1,
                datebased_daily_archive => 1,
                main_template           => 1,
                archive_template        => 1,
            },
        ),
        'Category' => ArchiveType(
            name                      => 'Category',
            archive_label             => \&category_archive_label,
            archive_file              => \&category_archive_file,
            archive_title             => \&category_archive_title,
            archive_group_iter        => \&category_group_iter,
            archive_group_entries     => \&category_group_entries,
            archive_entries_count     => \&category_entries_count,
            dynamic_template          => 'category/<$MTCategoryID$>',
            default_archive_templates => [
                ArchiveFileTemplate(
                    label => MT->translate('category/sub-category/index.html'),
                    template => '%-c/%i',
                    default  => 1
                ),
                ArchiveFileTemplate(
                    label => MT->translate('category/sub_category/index.html'),
                    template => '%c/%i'
                ),
            ],
            dynamic_support => 1,
            category_based  => 1,
            template_params => {
                archive_class                      => "category-archive",
                category_archive                   => 1,
                main_template                      => 1,
                archive_template                   => 1,
                module_category_archives           => 1,
                'module_category-monthly_archives' => 1,
            },
        ),
        'Author' => ArchiveType(
            name                      => 'Author',
            archive_label             => \&author_archive_label,
            archive_file              => \&author_archive_file,
            archive_title             => \&author_archive_title,
            archive_group_iter        => \&author_group_iter,
            archive_group_entries     => \&author_group_entries,
            archive_entries_count     => \&author_entries_count,
            default_archive_templates => [
                ArchiveFileTemplate(
                    label    => 'author-display-name/index.html',
                    template => '%-a/%f',
                    default  => 1
                ),
                ArchiveFileTemplate(
                    label    => 'author_display_name/index.html',
                    template => '%a/%f'
                ),
            ],
            dynamic_template => 'author/<$MTEntryAuthorID$>/<$MTEntryID$>',
            dynamic_support  => 1,
            author_based     => 1,
            template_params  => {
                archive_class                    => "author-archive",
                'module_author-monthly_archives' => 1,
                module_author_archives           => 1,
                main_template                    => 1,
                author_archive                   => 1,
                archive_template                 => 1,
            },
        ),
        'Author-Yearly' => ArchiveType(
            name                      => 'Author-Yearly',
            archive_label             => \&author_yearly_archive_label,
            archive_file              => \&author_yearly_archive_file,
            archive_title             => \&author_yearly_archive_title,
            archive_group_iter        => \&author_yearly_group_iter,
            archive_group_entries     => \&author_yearly_group_entries,
            archive_entries_count     => \&author_yearly_entries_count,
            date_range                => \&author_yearly_date_range,
            default_archive_templates => [
                ArchiveFileTemplate(
                    label    => 'author-display-name/yyyy/index.html',
                    template => '%-a/%y/%f',
                    default  => 1
                ),
                ArchiveFileTemplate(
                    label    => 'author_display_name/yyyy/index.html',
                    template => '%a/%y/%f'
                ),
            ],
            dynamic_template =>
              'author/<$MTEntryAuthorID$>/<$MTArchiveDate format="%Y"$>',
            dynamic_support => 1,
            author_based    => 1,
            date_based      => 1,
            template_params => {
                archive_class         => "author-yearly-archive",
                author_yearly_archive => 1,
                main_template         => 1,
                archive_template      => 1,
            },
        ),
        'Author-Monthly' => ArchiveType(
            name                      => 'Author-Monthly',
            archive_label             => \&author_monthly_archive_label,
            archive_file              => \&author_monthly_archive_file,
            archive_title             => \&author_monthly_archive_title,
            archive_group_iter        => \&author_monthly_group_iter,
            archive_group_entries     => \&author_monthly_group_entries,
            archive_entries_count     => \&author_monthly_entries_count,
            date_range                => \&author_monthly_date_range,
            default_archive_templates => [
                ArchiveFileTemplate(
                    label    => 'author-display-name/yyyy/mm/index.html',
                    template => '%-a/%y/%m/%f',
                    default  => 1
                ),
                ArchiveFileTemplate(
                    label    => 'author_display_name/yyyy/mm/index.html',
                    template => '%a/%y/%m/%f'
                ),
            ],
            dynamic_template =>
              'author/<$MTEntryAuthorID$>/<$MTArchiveDate format="%Y%m"$>',
            dynamic_support => 1,
            author_based    => 1,
            date_based      => 1,
            template_params => {
                archive_class                    => "author-monthly-archive",
                author_monthly_archive           => 1,
                'module_author-monthly_archives' => 1,
                module_author_archives           => 1,
                main_template                    => 1,
                archive_template                 => 1,
            },
        ),
        'Author-Weekly' => ArchiveType(
            name                      => 'Author-Weekly',
            archive_label             => \&author_weekly_archive_label,
            archive_file              => \&author_weekly_archive_file,
            archive_title             => \&author_weekly_archive_title,
            archive_group_iter        => \&author_weekly_group_iter,
            archive_group_entries     => \&author_weekly_group_entries,
            archive_entries_count     => \&author_weekly_entries_count,
            date_range                => \&author_weekly_date_range,
            default_archive_templates => [
                ArchiveFileTemplate(
                    label => 'author-display-name/yyyy/mm/day-week/index.html',
                    template => '%-a/%y/%m/%d-week/%f',
                    default  => 1
                ),
                ArchiveFileTemplate(
                    label => 'author_display_name/yyyy/mm/day-week/index.html',
                    template => '%a/%y/%m/%d-week/%f'
                ),
            ],
            dynamic_template =>
'author/<$MTEntryAuthorID$>/week/<$MTArchiveDate format="%Y%m%d"$>',
            dynamic_support => 1,
            author_based    => 1,
            date_based      => 1,
            template_params => {
                archive_class         => "author-weekly-archive",
                author_weekly_archive => 1,
                main_template         => 1,
                archive_template      => 1,
            },
        ),
        'Author-Daily' => ArchiveType(
            name                      => 'Author-Daily',
            archive_label             => \&author_daily_archive_label,
            archive_file              => \&author_daily_archive_file,
            archive_title             => \&author_daily_archive_title,
            archive_group_iter        => \&author_daily_group_iter,
            archive_group_entries     => \&author_daily_group_entries,
            archive_entries_count     => \&author_daily_entries_count,
            date_range                => \&author_daily_date_range,
            default_archive_templates => [
                ArchiveFileTemplate(
                    label    => 'author-display-name/yyyy/mm/dd/index.html',
                    template => '%-a/%y/%m/%d/%f',
                    default  => 1
                ),
                ArchiveFileTemplate(
                    label    => 'author_display_name/yyyy/mm/dd/index.html',
                    template => '%a/%y/%m/%d/%f'
                ),
            ],
            dynamic_template =>
              'author/<$MTEntryAuthorID$>/<$MTArchiveDate format="%Y%m%d"$>',
            dynamic_support => 1,
            author_based    => 1,
            date_based      => 1,
            template_params => {
                archive_class        => "author-daily-archive",
                author_daily_archive => 1,
                main_template        => 1,
                archive_template     => 1,
            },
        ),
        'Category-Yearly' => ArchiveType(
            name                      => 'Category-Yearly',
            archive_label             => \&cat_yearly_archive_label,
            archive_file              => \&cat_yearly_archive_file,
            archive_title             => \&cat_yearly_archive_title,
            date_range                => \&cat_yearly_date_range,
            archive_group_iter        => \&cat_yearly_group_iter,
            archive_group_entries     => \&cat_yearly_group_entries,
            archive_entries_count     => \&cat_yearly_entries_count,
            default_archive_templates => [
                ArchiveFileTemplate(
                    label    => 'category/sub-category/yyyy/index.html',
                    template => '%-c/%y/%i',
                    default  => 1
                ),
                ArchiveFileTemplate(
                    label    => 'category/sub_category/yyyy/index.html',
                    template => '%c/%y/%i'
                ),
            ],
            dynamic_template =>
              'category/<$MTCategoryID$>/<$MTArchiveDate format="%Y"$>',
            dynamic_support => 1,
            date_based      => 1,
            category_based  => 1,
            template_params => {
                archive_class           => "category-yearly-archive",
                category_yearly_archive => 1,
                main_template           => 1,
                archive_template        => 1,
            },
        ),
        'Category-Monthly' => ArchiveType(
            name                      => 'Category-Monthly',
            archive_label             => \&cat_monthly_archive_label,
            archive_file              => \&cat_monthly_archive_file,
            archive_title             => \&cat_monthly_archive_title,
            date_range                => \&cat_monthly_date_range,
            archive_group_iter        => \&cat_monthly_group_iter,
            archive_group_entries     => \&cat_monthly_group_entries,
            archive_entries_count     => \&cat_monthly_entries_count,
            default_archive_templates => [
                ArchiveFileTemplate(
                    label    => 'category/sub-category/yyyy/mm/index.html',
                    template => '%-c/%y/%m/%i',
                    default  => 1
                ),
                ArchiveFileTemplate(
                    label    => 'category/sub_category/yyyy/mm/index.html',
                    template => '%c/%y/%m/%i'
                ),
            ],
            dynamic_template =>
              'category/<$MTCategoryID$>/<$MTArchiveDate format="%Y%m"$>',
            dynamic_support => 1,
            date_based      => 1,
            category_based  => 1,
            template_params => {
                archive_class            => "category-monthly-archive",
                category_monthly_archive => 1,
                'module_category-monthly_archives' => 1,
                module_category_archives           => 1,
                main_template                      => 1,
                archive_template                   => 1,
            },
        ),
        'Category-Daily' => ArchiveType(
            name                      => 'Category-Daily',
            archive_label             => \&cat_daily_archive_label,
            archive_file              => \&cat_daily_archive_file,
            archive_title             => \&cat_daily_archive_title,
            date_range                => \&cat_daily_date_range,
            archive_group_iter        => \&cat_daily_group_iter,
            archive_group_entries     => \&cat_daily_group_entries,
            archive_entries_count     => \&cat_daily_entries_count,
            default_archive_templates => [
                ArchiveFileTemplate(
                    label    => 'category/sub-category/yyyy/mm/dd/index.html',
                    template => '%-c/%y/%m/%d/%i',
                    default  => 1
                ),
                ArchiveFileTemplate(
                    label    => 'category/sub_category/yyyy/mm/dd/index.html',
                    template => '%c/%y/%m/%d/%i'
                ),
            ],
            dynamic_template =>
              'category/<$MTCategoryID$>/<$MTArchiveDate format="%Y%m%d"$>',
            dynamic_support => 1,
            date_based      => 1,
            category_based  => 1,
            template_params => {
                archive_class          => "category-daily-archive",
                category_daily_archive => 1,
                main_template          => 1,
                archive_template       => 1,
            },
        ),
        'Category-Weekly' => ArchiveType(
            name                      => 'Category-Weekly',
            archive_label             => \&cat_weekly_archive_label,
            archive_file              => \&cat_weekly_archive_file,
            archive_title             => \&cat_weekly_archive_title,
            date_range                => \&cat_weekly_date_range,
            archive_group_iter        => \&cat_weekly_group_iter,
            archive_group_entries     => \&cat_weekly_group_entries,
            archive_entries_count     => \&cat_weekly_entries_count,
            default_archive_templates => [
                ArchiveFileTemplate(
                    label =>
                      'category/sub-category/yyyy/mm/day-week/index.html',
                    template => '%-c/%y/%m/%d-week/%i',
                    default  => 1
                ),
                ArchiveFileTemplate(
                    label =>
                      'category/sub_category/yyyy/mm/day-week/index.html',
                    template => '%c/%y/%m/%d-week/%i'
                ),
            ],
            dynamic_template =>
              'section/<$MTCategoryID$>/week/<$MTArchiveDate format="%Y%m%d"$>',
            dynamic_support => 1,
            date_based      => 1,
            category_based  => 1,
            template_params => {
                archive_class           => "category-weekly-archive",
                category_weekly_archive => 1,
                main_template           => 1,
                archive_template        => 1,
            },
        )
    };

}

sub rebuild {
    my $mt    = shift;
    my %param = @_;
    my $blog;
    unless ( $blog = $param{Blog} ) {
        my $blog_id = $param{BlogID};
        $blog = MT::Blog->load($blog_id)
          or return $mt->error(
            MT->translate(
                "Load of blog '[_1]' failed: [_2]", $blog_id,
                MT::Blog->errstr
            )
          );
    }
    return 1 if $blog->is_dynamic;
    my $at = $blog->archive_type || '';
    my @at = split /,/, $at;
    my $entry_class;
    if ( my $set_at = $param{ArchiveType} ) {
        my %at = map { $_ => 1 } @at;
        return $mt->error(
            MT->translate(
                "Archive type '[_1]' is not a chosen archive type", $set_at
            )
        ) unless $at{$set_at};

        @at = ($set_at);
        my $archiver = $mt->archiver($set_at);
        $entry_class = $archiver->{entry_class} || "entry";
    }
    else {
        $entry_class = '*';
    }

    if (   $param{ArchiveType}
        && ( !$param{Entry} )
        && ( $param{ArchiveType} eq 'Category' ) )
    {

        # Pass to full category rebuild
        return $mt->rebuild_categories(%param);
    }

    if (   $param{ArchiveType}
        && ( !$param{Author} )
        && ( $param{ArchiveType} eq 'Author' ) )
    {
        return $mt->rebuild_authors(%param);
    }

    if (@at) {
        require MT::Entry;
        my %arg = ( 'sort' => 'authored_on', direction => 'descend' );
        $arg{offset} = $param{Offset} if $param{Offset};
        $arg{limit}  = $param{Limit}  if $param{Limit};
        my $pre_iter = MT::Entry->load_iter(
            {
                blog_id => $blog->id,
                class   => $entry_class,
                status  => MT::Entry::RELEASE()
            },
            \%arg
        );
        my ( $next, $curr );
        my $prev = $pre_iter->();
        my $iter = sub {
            ( $next, $curr ) = ( $curr, $prev );
            if ($curr) {
                $prev = $pre_iter->();
            }
            $curr;
        };
        my $cb  = $param{EntryCallback};
        my $fcb = $param{FilterCallback};
        while ( my $entry = $iter->() ) {
            if ($cb) {
                $cb->($entry) || $mt->log( $cb->errstr() );
            }
            if ($fcb) {
                $fcb->($entry) or last;
            }
            for my $at (@at) {
                my $archiver = $mt->archiver($at);

                # Skip this archive type if the archive type doesn't
                # match the kind of entry we've loaded
                next unless $archiver;
                next if $entry->class ne $archiver->entry_class;
                if ( $archiver->category_based ) {
                    my $cats = $entry->categories;
                    for my $cat (@$cats) {
                        $mt->_rebuild_entry_archive_type(
                            Entry       => $entry,
                            Blog        => $blog,
                            Category    => $cat,
                            ArchiveType => $at,
                            NoStatic    => $param{NoStatic},
                            $param{TemplateMap}
                            ? ( TemplateMap => $param{TemplateMap} )
                            : (),
                            $param{TemplateID}
                            ? ( TemplateID =>
                                  $param{TemplateID} )
                            : (),
                        ) or return;
                    }
                }
                elsif ( $archiver->author_based ) {
                    if ( $entry->author ) {
                        $mt->_rebuild_entry_archive_type(
                            Entry       => $entry,
                            Blog        => $blog,
                            ArchiveType => $at,
                            $param{TemplateMap}
                            ? ( TemplateMap => $param{TemplateMap} )
                            : (),
                            $param{TemplateID}
                            ? ( TemplateID =>
                                  $param{TemplateID} )
                            : (),
                            NoStatic => $param{NoStatic},
                            Author   => $entry->author
                        ) or return;
                    }
                }
                else {
                    $mt->_rebuild_entry_archive_type(
                        Entry       => $entry,
                        Blog        => $blog,
                        ArchiveType => $at,
                        $param{TemplateMap}
                        ? ( TemplateMap => $param{TemplateMap} )
                        : (),
                        $param{TemplateID}
                        ? ( TemplateID =>
                              $param{TemplateID} )
                        : (),
                        NoStatic => $param{NoStatic}
                    ) or return;
                }
            }
        }
    }
    unless ( $param{NoIndexes} ) {
        $mt->rebuild_indexes( Blog => $blog ) or return;
    }
    if ( $mt->{PublishCommenterIcon} ) {
        $mt->make_commenter_icon($blog);
    }
    1;
}

sub rebuild_categories {
    my $mt    = shift;
    my %param = @_;
    my $blog;
    unless ( $blog = $param{Blog} ) {
        my $blog_id = $param{BlogID};
        $blog = MT::Blog->load($blog_id)
          or return $mt->error(
            MT->translate(
                "Load of blog '[_1]' failed: [_2]", $blog_id,
                MT::Blog->errstr
            )
          );
    }
    my %arg;
    $arg{'sort'} = 'id';
    $arg{direction} = 'ascend';
    $arg{offset} = $param{Offset} if $param{Offset};
    $arg{limit}  = $param{Limit}  if $param{Limit};
    my $cat_iter = MT::Category->load_iter( { blog_id => $blog->id }, \%arg );
    my $fcb = $param{FilterCallback};

    while ( my $cat = $cat_iter->() ) {
        if ($fcb) {
            $fcb->($cat) or last;
        }
        $mt->_rebuild_entry_archive_type(
            Blog        => $blog,
            Category    => $cat,
            ArchiveType => 'Category',
            $param{TemplateMap}
            ? ( TemplateMap => $param{TemplateMap} )
            : (),
            NoStatic => $param{NoStatic},
        ) or return;
    }
    1;
}

sub rebuild_authors {
    my $mt    = shift;
    my %param = @_;
    my $blog;
    unless ( $blog = $param{Blog} ) {
        my $blog_id = $param{BlogID};
        $blog = MT::Blog->load($blog_id)
          or return $mt->error(
            MT->translate(
                "Load of blog '[_1]' failed: [_2]", $blog_id,
                MT::Blog->errstr
            )
          );
    }
    my %arg;
    $arg{'sort'} = 'id';
    $arg{direction} = 'ascend';
    $arg{offset} = $param{Offset} if $param{Offset};
    $arg{limit}  = $param{Limit}  if $param{Limit};
    require MT::Entry;
    local $arg{join} = MT::Entry->join_on(
        'author_id',
        { blog_id => $blog->id, class => 'entry' },
        { unique  => 1 }
    );
    local $arg{unique} = 1;
    local $arg{status} = MT::Entry::RELEASE();
    my $auth_iter = MT::Author->load_iter( undef, \%arg );
    my $fcb = $param{FilterCallback};

    while ( my $a = $auth_iter->() ) {
        if ($fcb) {
            $fcb->($a) or last;
        }
        $mt->_rebuild_entry_archive_type(
            Blog        => $blog,
            Author      => $a,
            ArchiveType => 'Author',
            $param{TemplateMap}
            ? ( TemplateMap => $param{TemplateMap} )
            : (),
            NoStatic => $param{NoStatic},
        ) or return;
    }
    1;
}

sub make_commenter_icon {
    my $mt   = shift;
    my $blog = shift;
    if ( !UNIVERSAL::isa( $blog, 'MT::Blog' ) ) { $blog = shift; }
    my $identity_link_image = $blog->site_path . "/nav-commenters.gif";
    unless ( -f $identity_link_image ) {
        my $fmgr = $blog->file_mgr;
        unless ( $fmgr->exists( $blog->site_path ) ) {
            $fmgr->mkpath( $blog->site_path )
              or return MT->trans_error( "Error making path '[_1]': [_2]",
                $blog->site_path, $fmgr->errstr );
        }
        my $nav_commenters_gif =
          (     q{47494638396116000f00910200504d4b}
              . q{ffffffffffff00000021f90401000002}
              . q{002c0000000016000f0000022c948fa9}
              . q{19e0bf2208b482a866a51723bd75dee1}
              . q{70e2f83586837ed773a22fd4ba6cede2}
              . q{241c8f7ceff9e95005003b} );
        $nav_commenters_gif = pack( "H*", $nav_commenters_gif );
        eval {
            if ( open( TARGET, ">$identity_link_image" ) )
            {
                print TARGET $nav_commenters_gif;
                close TARGET;
            }
            else {
                MT::log( "Couldn't write authenticated commenter icon to "
                      . $identity_link_image );
                die;
            }
        };
    }
}

#   rebuild_entry
#
# $mt->rebuild_entry(Entry => $entry_id,
#                    Blog => [ $blog | $blog_id ],
#                    [ BuildDependencies => (0 | 1), ]
#                    [ OldPrevious => $old_previous_entry_id,
#                      OldNext => $old_next_entry_id, ]
#                    [ NoStatic => (0 | 1), ]
#                    );
sub rebuild_entry {
    my $mt    = shift;
    my %param = @_;
    my $entry = $param{Entry}
      or return $mt->error(
        MT->translate( "Parameter '[_1]' is required", 'Entry' ) );
    require MT::Entry;
    $entry = MT::Entry->load($entry) unless ref $entry;
    my $blog;
    unless ( $blog = $param{Blog} ) {
        my $blog_id = $entry->blog_id;
        $blog = MT::Blog->load($blog_id)
          or return $mt->error(
            MT->translate(
                "Load of blog '[_1]' failed: [_2]", $blog_id,
                MT::Blog->errstr
            )
          );
    }
    return 1 if $blog->is_dynamic;

    my $at = $blog->archive_type;
    if ( $at && $at ne 'None' ) {
        my @at = split /,/, $at;
        for my $at (@at) {
            my $archiver = $mt->archiver($at);
            next unless $archiver;    # invalid archive type
            next if $entry->class ne $archiver->entry_class;
            if ( $archiver->category_based ) {
                my $cats = $entry->categories;    # (ancestors => 1)
                for my $cat (@$cats) {
                    $mt->_rebuild_entry_archive_type(
                        Entry       => $entry,
                        Blog        => $blog,
                        ArchiveType => $at,
                        Category    => $cat,
                        NoStatic    => $param{NoStatic},
                        $param{TemplateMap}
                        ? ( TemplateMap => $param{TemplateMap} )
                        : (),
                    ) or return;
                }
            }
            else {
                $mt->_rebuild_entry_archive_type(
                    Entry       => $entry,
                    Blog        => $blog,
                    ArchiveType => $at,
                    $param{TemplateMap}
                    ? ( TemplateMap => $param{TemplateMap} )
                    : (),
                    NoStatic => $param{NoStatic},
                    Author   => $entry->author,
                ) or return;
            }
        }
    }

    ## The above will just rebuild the archive pages for this particular
    ## entry. If we want to rebuild all of the entries/archives/indexes
    ## on which this entry could be featured etc., however, we need to
    ## rebuild all of the entry's dependencies. Note that all of these
    ## are not *necessarily* dependencies, depending on the usage of tags,
    ## etc. There is not a good way to determine exact dependencies; it is
    ## easier to just rebuild, rebuild, rebuild.

    return 1
      unless $param{BuildDependencies}
      || $param{BuildIndexes}
      || $param{BuildArchives};

    if ( $param{BuildDependencies} ) {
        ## Rebuild previous and next entry archive pages.
        if ( my $prev = $entry->previous(1) ) {
            $mt->rebuild_entry( Entry => $prev ) or return;

            ## Rebuild the old previous and next entries, if we have some.
            if ( $param{OldPrevious}
                && ( my $old_prev = MT::Entry->load( $param{OldPrevious} ) ) )
            {
                $mt->rebuild_entry( Entry => $old_prev ) or return;
            }
        }
        if ( my $next = $entry->next(1) ) {
            $mt->rebuild_entry( Entry => $next ) or return;

            if ( $param{OldNext}
                && ( my $old_next = MT::Entry->load( $param{OldNext} ) ) )
            {
                $mt->rebuild_entry( Entry => $old_next ) or return;
            }
        }
    }

    if ( $param{BuildDependencies} || $param{BuildIndexes} ) {
        ## Rebuild all indexes, in case this entry is on an index.
        if ( !( exists $param{BuildIndexes} ) || $param{BuildIndexes} ) {
            $mt->rebuild_indexes( Blog => $blog ) or return;
        }
    }

    if ( $param{BuildDependencies} || $param{BuildArchives} ) {
        ## Rebuild previous and next daily, weekly, and monthly archives;
        ## adding a new entry could cause changes to the intra-archive
        ## navigation.
        my %at = map { $_ => 1 } split /,/, $blog->archive_type;
        my @db_at = grep { $ArchiveTypes{$_} && $ArchiveTypes{$_}->date_based } $mt->archive_types;
        for my $at (@db_at) {
            if ( $at{$at} ) {
                my @arg = ( $entry->authored_on, $entry->blog_id, $at );
                my $archiver = $mt->archiver($at);
                if ( my $prev_arch = $mt->get_entry( @arg, 'previous' ) ) {
                    if ( $archiver->category_based ) {
                        my $cats = $prev_arch->categories;
                        for my $cat (@$cats) {
                            $mt->_rebuild_entry_archive_type(
                                NoStatic => $param{NoStatic},
                                Entry    => $prev_arch,
                                Blog     => $blog,
                                Category => $cat,
                                $param{TemplateMap}
                                ? ( TemplateMap => $param{TemplateMap} )
                                : (),
                                ArchiveType => $at
                            ) or return;
                        }
                    }
                    else {
                        $mt->_rebuild_entry_archive_type(
                            NoStatic    => $param{NoStatic},
                            Entry       => $prev_arch,
                            Blog        => $blog,
                            ArchiveType => $at,
                            $param{TemplateMap}
                            ? ( TemplateMap => $param{TemplateMap} )
                            : (),
                            Author => $prev_arch->author
                        ) or return;
                    }
                }
                if ( my $next_arch = $mt->get_entry( @arg, 'next' ) ) {
                    if ( $archiver->category_based ) {
                        my $cats = $next_arch->categories;
                        for my $cat (@$cats) {
                            $mt->_rebuild_entry_archive_type(
                                NoStatic => $param{NoStatic},
                                Entry    => $next_arch,
                                Blog     => $blog,
                                Category => $cat,
                                $param{TemplateMap}
                                ? ( TemplateMap => $param{TemplateMap} )
                                : (),
                                ArchiveType => $at
                            ) or return;
                        }
                    }
                    else {
                        $mt->_rebuild_entry_archive_type(
                            NoStatic    => $param{NoStatic},
                            Entry       => $next_arch,
                            Blog        => $blog,
                            ArchiveType => $at,
                            $param{TemplateMap}
                            ? ( TemplateMap => $param{TemplateMap} )
                            : (),
                            Author => $next_arch->author
                        ) or return;
                    }
                }
            }
        }
    }

    1;
}

sub _rebuild_entry_archive_type {
    my $mt    = shift;
    my %param = @_;
    my $at    = $param{ArchiveType}
      or return $mt->error(
        MT->translate( "Parameter '[_1]' is required", 'ArchiveType' ) );
    return 1 if $at eq 'None';
    my $entry =
      ( $param{ArchiveType} ne 'Category' && $param{ArchiveType} ne 'Author' )
      ? (
        $param{Entry}
          or return $mt->error(
            MT->translate( "Parameter '[_1]' is required", 'Entry' )
          )
      )
      : undef;

    my $blog;
    unless ( $blog = $param{Blog} ) {
        my $blog_id = $entry->blog_id;
        $blog = MT::Blog->load($blog_id)
          or return $mt->error(
            MT->translate(
                "Load of blog '[_1]' failed: [_2]", $blog_id,
                MT::Blog->errstr
            )
          );
    }

    ## Load the template-archive-type map entries for this blog and
    ## archive type. We do this before we load the list of entries, because
    ## we will run through the files and check if we even need to rebuild
    ## anything. If there is nothing to rebuild at all for this entry,
    ## we save some time by not loading the list of entries.
    require MT::TemplateMap;
    my @map;
    if ( $param{TemplateMap} ) {
        @map = ( $param{TemplateMap} );
    }
    else {
        my $cached_maps = MT->instance->request('__cached_maps')
          || MT->instance->request( '__cached_maps', {} );
        if ( my $maps = $cached_maps->{ $at . $blog->id } ) {
            @map = @$maps;
        }
        else {
            @map = MT::TemplateMap->load(
                {
                    archive_type => $at,
                    blog_id      => $blog->id,
                    $param{TemplateID}
                    ? ( template_id => $param{TemplateID} )
                    : ()
                }
            );
            $cached_maps->{ $at . $blog->id } = \@map;
        }
    }
    return 1 unless @map;
    my @map_build;

    my $done = MT->instance->request('__published')
      || MT->instance->request( '__published', {} );
    for my $map (@map) {
        my $file =
          $mt->archive_file_for( $entry, $blog, $at, $param{Category}, $map,
            undef, $param{Author} );
        if ( $file eq '' ) {

            # np
        }
        elsif ( !defined($file) ) {
            return $mt->error( MT->translate( $blog->errstr() ) );
        }
        else {
            push @map_build, $map unless $done->{$file};
            $map->{__saved_output_file} = $file;
        }
    }
    return 1 unless @map_build;
    @map = @map_build;

    my (%cond);
    require MT::Template::Context;
    my $ctx = MT::Template::Context->new;
    $ctx->{current_archive_type} = $at;
    $ctx->{archive_type}         = $at;
    $at ||= "";

    my $archiver = $mt->archiver($at);
    return unless $archiver;

    my $fmgr = $blog->file_mgr;

    # Special handling for pages-- they are always published to the
    # 'site' path instead of the 'archive' path, which is reserved for blog
    # content.
    my $arch_root = ( $at eq 'Page' ) ? $blog->site_path : $blog->archive_path;
    return $mt->error(
        MT->translate("You did not set your blog publishing path") )
      unless $arch_root;

    my $range = $archiver->date_range;
    my ( $start, $end ) = $range ? $range->( $entry->authored_on ) : ();

    ## For each mapping, we need to rebuild the entries we loaded above in
    ## the particular template map, and write it to the specified archive
    ## file template.
    require MT::Template;
    for my $map (@map) {
        $mt->rebuild_file(
            $blog, $arch_root, $map, $at, $ctx, \%cond,
            !$param{NoStatic},
            Category  => $param{Category},
            Entry     => $entry,
            Author    => $param{Author},
            StartDate => $start,
            EndDate   => $end,
        ) or return;
        $done->{ $map->{__saved_output_file} }++;
    }
    1;
}

sub rebuild_file {
    my $mt = shift;
    my ( $blog, $root_path, $map, $at, $ctx, $cond, $build_static, %specifier )
      = @_;
    my $finfo;
    my $archiver = $mt->archiver($at);
    my ( $entry, $start, $end, $category, $author );

    if ( $finfo = $specifier{FileInfo} ) {
        $specifier{Author}   = $finfo->author_id   if $finfo->author_id;
        $specifier{Category} = $finfo->category_id if $finfo->category_id;
        $specifier{Entry}    = $finfo->entry_id    if $finfo->entry_id;
        $map ||= MT::TemplateMap->load( $finfo->templatemap_id );
        $at  ||= $finfo->archive_type;
        if ( $finfo->startdate ) {
            if ( my $range = $archiver->date_range ) {
                my ( $start, $end ) =
                  $range ? $range->( $finfo->startdate ) : ();
                $specifier{StartDate} = $start;
                $specifier{EndDate}   = $end;
            }
        }
    }

    if ( $archiver->category_based ) {
        $category = $specifier{Category};
        die "Category archive type requires Category parameter"
          unless $specifier{Category};
        $category = MT::Category->load($category)
          unless ref $category;
        $ctx->var( 'category_archive', 1 );
        $ctx->{__stash}{archive_category} = $category;
    }
    if ( $archiver->entry_based ) {
        $entry = $specifier{Entry};
        die "$at archive type requires Entry parameter"
          unless $entry;
        require MT::Entry;
        $entry = MT::Entry->load($entry) if !ref $entry;
        $ctx->var( 'entry_archive', 1 );
        $ctx->{__stash}{entry} = $entry;
    }
    if ( $archiver->date_based ) {

        # Date-based archive type
        $start = $specifier{StartDate};
        $end   = $specifier{EndDate};
        die "Date-based archive types require StartDate parameter"
          unless $specifier{StartDate};
        $ctx->var( 'datebased_archive', 1 );
    }
    if ( $archiver->author_based ) {

        # author based archive type
        $author = $specifier{Author};
        die "Author-based archive type requires Author parameter"
          unless $specifier{Author};
        require MT::Author;
        $author = MT::Author->load($author)
          unless ref $author;
        $ctx->var( 'author_archive', 1 );
        $ctx->{__stash}{author} = $author;
    }
    local $ctx->{current_timestamp}     = $start if $start;
    local $ctx->{current_timestamp_end} = $end   if $end;

    my $fmgr = $blog->file_mgr;
    $ctx->{__stash}{blog} = $blog;

    # Calculate file path and URL for the new entry.
    my $file = File::Spec->catfile( $root_path, $map->{__saved_output_file} );
    require MT::FileInfo;

# This kind of testing should be done at the time we save a post,
# not during publishing!!!
# if ($archiver->entry_based) {
#     my $fcount = MT::FileInfo->count({
#         blog_id => $blog->id,
#         entry_id => $entry->id,
#         file_path => $file},
#         { not => { entry_id => 1 } });
#     die MT->translate('The same archive file exists. You should change the basename or the archive path. ([_1])', $file) if $fcount > 0;
# }

    my $url = $blog->archive_url;
    $url = $blog->site_url
      if $archiver->entry_based && $archiver->entry_class eq 'page';
    $url .= '/' unless $url =~ m|/$|;
    $url .= $map->{__saved_output_file};

    my $cached_tmpl = MT->instance->request('__cached_templates')
      || MT->instance->request( '__cached_templates', {} );
    my $tmpl_id = $map->template_id;

    # template specific for this entry (or page, as the case may be)
    if ( $entry && $entry->template_id ) {

        # allow entry to override *if* we're publishing an individual
        # page, and this is the 'preferred' one...
        if ( $archiver->entry_based ) {
            if ( $map->is_preferred ) {
                $tmpl_id = $entry->template_id;
            }
        }
    }

    my $tmpl = $cached_tmpl->{$tmpl_id};
    unless ($tmpl) {
        $tmpl = MT::Template->load($tmpl_id);
        if ($cached_tmpl) {
            $cached_tmpl->{$tmpl_id} = $tmpl;
        }
    }

    $tmpl->context($ctx);

    # From Here
    if ( my $tmpl_param = $archiver->template_params ) {
        $tmpl->param($tmpl_param);
    }

    my ($rel_url) = ( $url =~ m|^(?:[^:]*\:\/\/)?[^/]*(.*)| );
    $rel_url =~ s|//+|/|g;

    ## Untaint. We have to assume that we can trust the user's setting of
    ## the archive_path, and nothing else is based on user input.
    ($file) = $file =~ /(.+)/s;

    # Clear out all the FileInfo records that might point at the page
    # we're about to create
    # FYI: if it's an individual entry, we don't use the date as a
    #      criterion, since this could actually have changed since
    #      the FileInfo was last built. When the date does change,
    #      the old date-based archive doesn't necessarily get fixed,
    #      but if another comes along it will get corrected
    unless ($finfo) {
        my %terms;
        $terms{blog_id}     = $blog->id;
        $terms{category_id} = $category->id if $archiver->category_based;
        $terms{author_id}   = $author->id if $archiver->author_based;
        $terms{entry_id}    = $entry->id if $archiver->entry_based;
        $terms{startdate}   = $start
          if $archiver->date_based && ( !$archiver->entry_based );
        $terms{archive_type}   = $at;
        $terms{templatemap_id} = $map->id;
        my @finfos = MT::FileInfo->load( \%terms );

        if (   ( scalar @finfos == 1 )
            && ( $finfos[0]->file_path eq $file )
            && ( ( $finfos[0]->url || '' ) eq $rel_url )
            && ( $finfos[0]->template_id == $tmpl_id ) )
        {

            # if the shoe fits, wear it
            $finfo = $finfos[0];
        }
        else {

           # if the shoe don't fit, remove all shoes and create the perfect shoe
            foreach (@finfos) { $_->remove(); }

            $finfo = MT::FileInfo->set_info_for_url(
                $rel_url, $file, $at,
                {
                    Blog        => $blog->id,
                    TemplateMap => $map->id,
                    Template    => $tmpl_id,
                    ( $archiver->entry_based && $entry )
                    ? ( Entry => $entry->id )
                    : (),
                    StartDate => $start,
                    ( $archiver->category_based && $category )
                    ? ( Category => $category->id )
                    : (),
                    ( $archiver->author_based )
                    ? ( Author => $author->id )
                    : (),
                }
              )
              || die "Couldn't create FileInfo because "
              . MT::FileInfo->errstr();
        }
    }

    # If you rebuild when you've just switched to dynamic pages,
    # we move the file that might be there so that the custom
    # 404 will be triggered.
    if ( $tmpl->build_dynamic ) {
        rename(
            $finfo->file_path,    # is this just $file ?
            $finfo->file_path . '.static'
        );

        ## If the FileInfo is set to static, flip it to virtual.
        if ( !$finfo->virtual ) {
            $finfo->virtual(1);
            $finfo->save();
        }
    }

    return 1 if ( $tmpl->build_dynamic );
    return 1 if ( $entry && $entry->status != MT::Entry::RELEASE() );

    if ( !$tmpl->build_dynamic ) {
        if (
            $build_static
            && MT->run_callbacks(
                'build_file_filter',
                Context      => $ctx,
                context      => $ctx,
                ArchiveType  => $at,
                archive_type => $at,
                TemplateMap  => $map,
                template_map => $map,
                Blog         => $blog,
                blog         => $blog,
                Entry        => $entry,
                entry        => $entry,
                FileInfo     => $finfo,
                file_info    => $finfo,
                File         => $file,
                file         => $file,
                Template     => $tmpl,
                template     => $tmpl,
                PeriodStart  => $start,
                period_start => $start,
                Category     => $category,
                category     => $category,
            )
          )
        {
            if ( $archiver->archive_group_entries ) {

                # TBD: Would it help to use MT::Promise here?
                my $entries = $archiver->archive_group_entries->($ctx);
                $ctx->stash( 'entries', $entries );
            }

            my $html = undef;
            $ctx->stash( 'blog', $blog );
            $ctx->stash( 'entry', $entry ) if $entry;
            $html = $tmpl->build( $ctx, $cond );
            defined($html)
              or return $mt->error(
                (
                    $category ? MT->translate(
                        "An error occurred publishing [_1] '[_2]': [_3]",
                        lowercase( $category->class_label ),
                        $category->id,
                        $tmpl->errstr
                      )
                    : $entry ? MT->translate(
                        "An error occurred publishing [_1] '[_2]': [_3]",
                        lowercase( $entry->class_label ),
                        $entry->title,
                        $tmpl->errstr
                      )
                    : MT->translate(
"An error occurred publishing date-based archive '[_1]': [_2]",
                        $at . $start,
                        $tmpl->errstr
                    )
                )
              );
            my $orig_html = $html;
            MT->run_callbacks(
                'build_page',
                Context      => $ctx,
                context      => $ctx,
                ArchiveType  => $at,
                archive_type => $at,
                TemplateMap  => $map,
                template_map => $map,
                Blog         => $blog,
                blog         => $blog,
                Entry        => $entry,
                entry        => $entry,
                FileInfo     => $finfo,
                file_info    => $finfo,
                PeriodStart  => $start,
                period_start => $start,
                Category     => $category,
                category     => $category,
                RawContent   => \$orig_html,
                raw_content  => \$orig_html,
                Content      => \$html,
                content      => \$html,
                BuildResult  => \$orig_html,
                build_result => \$orig_html,
                Template     => $tmpl,
                template     => $tmpl,
                File         => $file,
                file         => $file
            );
            ## First check whether the content is actually
            ## changed. If not, we won't update the published
            ## file, so as not to modify the mtime.
            return 1 unless $fmgr->content_is_updated( $file, \$html );

            ## Determine if we need to build directory structure,
            ## and build it if we do. DirUmask determines
            ## directory permissions.
            require File::Spec;
            my $path = dirname($file);
            $path =~ s!/$!!
              unless $path eq '/'; ## OS X doesn't like / at the end in mkdir().
            unless ( $fmgr->exists($path) ) {
                $fmgr->mkpath($path)
                  or return $mt->trans_error( "Error making path '[_1]': [_2]",
                    $path, $fmgr->errstr );
            }

            ## By default we write all data to temp files, then rename
            ## the temp files to the real files (an atomic
            ## operation). Some users don't like this (requires too
            ## liberal directory permissions). So we have a config
            ## option to turn it off (NoTempFiles).
            my $use_temp_files = !$mt->{NoTempFiles};
            my $temp_file = $use_temp_files ? "$file.new" : $file;
            defined( $fmgr->put_data( $html, $temp_file ) )
              or return $mt->trans_error( "Writing to '[_1]' failed: [_2]",
                $temp_file, $fmgr->errstr );
            if ($use_temp_files) {
                $fmgr->rename( $temp_file, $file )
                  or return $mt->trans_error(
                    "Renaming tempfile '[_1]' failed: [_2]",
                    $temp_file, $fmgr->errstr );
            }
            MT->run_callbacks(
                'build_file',
                Context      => $ctx,
                context      => $ctx,
                ArchiveType  => $at,
                archive_type => $at,
                TemplateMap  => $map,
                template_map => $map,
                FileInfo     => $finfo,
                file_info    => $finfo,
                Blog         => $blog,
                blog         => $blog,
                Entry        => $entry,
                entry        => $entry,
                PeriodStart  => $start,
                period_start => $start,
                RawContent   => \$orig_html,
                raw_content  => \$orig_html,
                Content      => \$html,
                content      => \$html,
                BuildResult  => \$orig_html,
                build_result => \$orig_html,
                Template     => $tmpl,
                template     => $tmpl,
                Category     => $category,
                category     => $category,
                File         => $file,
                file         => $file
            );

        }
    }
    1;
}

sub rebuild_indexes {
    my $mt    = shift;
    my %param = @_;
    require MT::Template;
    require MT::Template::Context;
    require MT::Entry;
    my $blog;
    unless ( $blog = $param{Blog} ) {
        my $blog_id = $param{BlogID};
        $blog = MT::Blog->load($blog_id)
          or return $mt->error(
            MT->translate(
                "Load of blog '[_1]' failed: [_2]", $blog_id,
                MT::Blog->errstr
            )
          );
    }
    my $tmpl = $param{Template};
    unless ($blog) {
        $blog = MT::Blog->load( $tmpl->blog_id );
    }
    return 1 if $blog->is_dynamic;
    my $iter;
    if ($tmpl) {
        my $i = 0;
        $iter = sub { $i++ < 1 ? $tmpl : undef };
    }
    else {
        $iter = MT::Template->load_iter(
            {
                type    => 'index',
                blog_id => $blog->id
            }
        );
    }
    local *FH;
    my $site_root = $blog->site_path;
    return $mt->error(
        MT->translate("You did not set your blog publishing path") )
      unless $site_root;
    my $fmgr = $blog->file_mgr;
    while ( my $tmpl = $iter->() ) {
        ## Skip index templates that the user has designated not to be
        ## rebuilt automatically. We need to do the defined-ness check
        ## because we added the flag in 2.01, and for templates saved
        ## before that time, the rebuild_me flag will be undefined. But
        ## we assume that these templates should be rebuilt, since that
        ## was the previous behavior.
        ## Note that dynamic templates do need to be "rebuilt"--the
        ## FileInfo table needs to be maintained.
        if ( !$tmpl->build_dynamic && !$param{Force} ) {
            next if ( defined $tmpl->rebuild_me && !$tmpl->rebuild_me );
        }
        my $file = $tmpl->outfile;
        $file = '' unless defined $file;
        if ( $tmpl->build_dynamic && ( $file eq '' ) ) {
            next;
        }
        return $mt->error(
            MT->translate(
                "Template '[_1]' does not have an Output File.",
                $tmpl->name
            )
        ) unless $file ne '';
        my $url = join( '/', $blog->site_url, $file );
        unless ( File::Spec->file_name_is_absolute($file) ) {
            $file = File::Spec->catfile( $site_root, $file );
        }

        # Everything from here out is identical with rebuild_file
        my ($rel_url) = ( $url =~ m|^(?:[^:]*\:\/\/)?[^/]*(.*)| );
        $rel_url =~ s|//+|/|g;
        ## Untaint. We have to assume that we can trust the user's setting of
        ## the site_path and the template outfile.
        ($file) = $file =~ /(.+)/s;
        my $finfo;
        require MT::FileInfo;
        my @finfos = MT::FileInfo->load(
            {
                blog_id     => $tmpl->blog_id,
                template_id => $tmpl->id
            }
        );
        if (   ( scalar @finfos == 1 )
            && ( $finfos[0]->file_path eq $file )
            && ( ( $finfos[0]->url || '' ) eq $rel_url ) )
        {
            $finfo = $finfos[0];
        }
        else {
            foreach (@finfos) { $_->remove(); }
            $finfo = MT::FileInfo->set_info_for_url(
                $rel_url, $file, 'index',
                {
                    Blog     => $tmpl->blog_id,
                    Template => $tmpl->id,
                }
              )
              || die "Couldn't create FileInfo because " . MT::FileInfo->errstr;
        }
        if ( $tmpl->build_dynamic ) {
            rename( $file, $file . ".static" );

            ## If the FileInfo is set to static, flip it to virtual.
            if ( !$finfo->virtual ) {
                $finfo->virtual(1);
                $finfo->save();
            }
        }

        next if ( $tmpl->build_dynamic );

        ## We're not building dynamically, so if the FileInfo is currently
        ## set as dynamic (virtual), change it to static.
        if ( $finfo && $finfo->virtual ) {
            $finfo->virtual(0);
            $finfo->save();
        }

        my $ctx = MT::Template::Context->new;
        next
          unless (
            MT->run_callbacks(
                'build_file_filter',
                Context      => $ctx,
                context      => $ctx,
                ArchiveType  => 'index',
                archive_type => 'index',
                Blog         => $blog,
                blog         => $blog,
                FileInfo     => $finfo,
                file_info    => $finfo,
                Template     => $tmpl,
                template     => $tmpl,
                File         => $file,
                file         => $file
            )
          );
        $ctx->stash( 'blog', $blog );
        my $html = $tmpl->build($ctx);
        return $mt->error( $tmpl->errstr ) unless defined $html;

        my $orig_html = $html;
        MT->run_callbacks(
            'build_page',
            Context      => $ctx,
            context      => $ctx,
            Blog         => $blog,
            blog         => $blog,
            FileInfo     => $finfo,
            file_info    => $finfo,
            ArchiveType  => 'index',
            archive_type => 'index',
            RawContent   => \$orig_html,
            raw_content  => \$orig_html,
            Content      => \$html,
            content      => \$html,
            BuildResult  => \$orig_html,
            build_result => \$orig_html,
            Template     => $tmpl,
            template     => $tmpl,
            File         => $file,
            file         => $file
        );

        ## First check whether the content is actually changed. If not,
        ## we won't update the published file, so as not to modify the mtime.
        next unless $fmgr->content_is_updated( $file, \$html );

        ## Determine if we need to build directory structure,
        ## and build it if we do. DirUmask determines
        ## directory permissions.
        require File::Spec;
        my $path = dirname($file);
        $path =~ s!/$!!
          unless $path eq '/';    ## OS X doesn't like / at the end in mkdir().
        unless ( $fmgr->exists($path) ) {
            $fmgr->mkpath($path)
              or return $mt->trans_error( "Error making path '[_1]': [_2]",
                $path, $fmgr->errstr );
        }

        ## Update the published file.
        my $use_temp_files = !$mt->{NoTempFiles};
        my $temp_file = $use_temp_files ? "$file.new" : $file;
        defined( $fmgr->put_data( $html, $temp_file ) )
          or return $mt->trans_error( "Writing to '[_1]' failed: [_2]",
            $temp_file, $fmgr->errstr );
        if ($use_temp_files) {
            $fmgr->rename( $temp_file, $file )
              or
              return $mt->trans_error( "Renaming tempfile '[_1]' failed: [_2]",
                $temp_file, $fmgr->errstr );
        }
        MT->run_callbacks(
            'build_file',
            Context      => $ctx,
            context      => $ctx,
            ArchiveType  => 'index',
            archive_type => 'index',
            FileInfo     => $finfo,
            file_info    => $finfo,
            Blog         => $blog,
            blog         => $blog,
            RawContent   => \$orig_html,
            raw_content  => \$orig_html,
            Content      => \$html,
            content      => \$html,
            BuildResult  => \$orig_html,
            build_result => \$orig_html,
            Template     => $tmpl,
            template     => $tmpl,
            File         => $file,
            file         => $file
        );
    }
    1;
}

sub rebuild_from_fileinfo {
    my $pub = shift;
    my ($fi) = @_;

    require MT::Blog;
    require MT::Entry;
    require MT::Category;
    require MT::Template;
    require MT::TemplateMap;
    require MT::Template::Context;

    my $at = $fi->archive_type
      or return $pub->error(
        MT->translate( "Parameter '[_1]' is required", 'ArchiveType' ) );

    # callback for custom archive types
    return
      unless MT->run_callbacks(
        'build_archive_filter',
        archive_type => $at,
        file_info    => $fi
      );

    if ( $at ne 'index' ) {
        return 1 if $at eq 'None';
		my ( $start, $end );
        my $blog = MT::Blog->load( $fi->blog_id )
          if $fi->blog_id;
        my $entry = MT::Entry->load( $fi->entry_id )
          or return $pub->error(
            MT->translate( "Parameter '[_1]' is required", 'Entry' ) )
          if $fi->entry_id;
        if ( $fi->startdate ) {
            my $archiver = $pub->archiver($at);

            if ( my $range = $archiver->date_range ) {
                ( $start, $end ) = $range->( $fi->startdate );
                $entry = MT::Entry->load( { authored_on => [ $start, $end ] },
                    { range_incl => { authored_on => 1 }, limit => 1 } )
                  or return $pub->error(
                    MT->translate( "Parameter '[_1]' is required", 'Entry' ) );
            }
        }
        my $cat = MT::Category->load( $fi->category_id )
          if $fi->category_id;

        ## Load the template-archive-type map entries for this blog and
        ## archive type. We do this before we load the list of entries, because
        ## we will run through the files and check if we even need to rebuild
        ## anything. If there is nothing to rebuild at all for this entry,
        ## we save some time by not loading the list of entries.
        my $map = MT::TemplateMap->load( $fi->templatemap_id );
        my $file = $pub->archive_file_for( $entry, $blog, $at, $cat, $map );
        if ( !defined($file) ) {
            return $pub->error( $blog->errstr() );
        }
        $map->{__saved_output_file} = $file;

        my $ctx = MT::Template::Context->new;
        $ctx->{current_archive_type} = $at;
		if ( $start && $end ) {
        	$ctx->{current_timestamp} = $start;
        	$ctx->{current_timestamp_end} = $end;
		}

        my $arch_root =
          ( $at eq 'Page' ) ? $blog->site_path : $blog->archive_path;
        return $pub->error(
            MT->translate("You did not set your blog publishing path") )
          unless $arch_root;

        my %cond;
        $pub->rebuild_file( $blog, $arch_root, $map, $at, $ctx, \%cond, 1,
            FileInfo => $fi, )
          or return;
    }
    else {
        $pub->rebuild_indexes(
            BlogID   => $fi->blog_id,
            Template => MT::Template->load( $fi->template_id ),
            Force    => 1,
        ) or return;
    }
    1;
}

sub trans_error {
    my $this = shift;
    return $this->error( MT->translate(@_) );
}

sub publish_future_posts {
    my $this = shift;

    require MT::Blog;
    require MT::Entry;
    require MT::Util;
    my $mt            = MT->instance;
    my $total_changed = 0;
    for my $blog ( MT::Blog->load ) {
        my @ts = MT::Util::offset_time_list( time, $blog );
        my $now = sprintf "%04d%02d%02d%02d%02d%02d", $ts[5] + 1900, $ts[4] + 1,
          @ts[ 3, 2, 1, 0 ];
        my $iter = MT::Entry->load_iter(
            {
                blog_id => $blog->id,
                status  => MT::Entry::FUTURE()
            },
            {
                'sort'    => 'authored_on',
                direction => 'descend'
            }
        );
        my @queue;
        while ( my $entry = $iter->() ) {
            push @queue, $entry->id if $entry->authored_on le $now;
        }

        my $changed = 0;
        my @results;
        my %rebuild_queue;
        my %ping_queue;
        foreach my $entry_id (@queue) {
            my $entry = MT::Entry->load($entry_id);
            $entry->status( MT::Entry::RELEASE() );
            $entry->save
              or die $entry->errstr;

            $rebuild_queue{ $entry->id } = $entry;
            $ping_queue{ $entry->id }    = 1;
            my $n = $entry->next(1);
            $rebuild_queue{ $n->id } = $n if $n;
            my $p = $entry->previous(1);
            $rebuild_queue{ $p->id } = $p if $p;
            $changed++;
            $total_changed++;
        }
        if ($changed) {
            my %rebuilt_okay;
            my $rebuilt;
            eval {
                foreach my $id ( keys %rebuild_queue )
                {
                    my $entry = $rebuild_queue{$id};
                    $mt->rebuild_entry( Entry => $entry, Blog => $blog )
                      or die $mt->errstr;
                    $rebuilt_okay{$id} = 1;
                    if ( $ping_queue{$id} ) {
                        $mt->ping_and_save( Entry => $entry, Blog => $blog );
                    }
                    $rebuilt++;
                }
                $mt->rebuild_indexes( Blog => $blog )
                  or die $mt->errstr;
            };
            if ( my $err = $@ ) {

                # a fatal error occured while processing the rebuild
                # step. LOG the error and revert the entry/entries:
                require MT::Log;
                $mt->log(
                    {
                        message => $mt->translate(
"An error occurred while publishing scheduled entries: [_1]",
                            $err
                        ),
                        class   => "system",
                        blog_id => $blog->id,
                        level   => MT::Log::ERROR()
                    }
                );
                foreach my $id (@queue) {
                    next if exists $rebuilt_okay{$id};
                    my $e = $rebuild_queue{$id};
                    next unless $e;
                    $e->status( MT::Entry::FUTURE() );
                    $e->save or die $e->errstr;
                }
            }
        }
    }
    $total_changed > 0 ? 1 : 0;
}

sub remove_entry_archive_file {
    my $mt    = shift;
    my %param = @_;

    my $entry = $param{Entry};
    my $at    = $param{ArchiveType} || 'Individual';
    my $cat   = $param{Category};
    my $auth  = $param{Author};

    require MT::TemplateMap;
    my $blog = $param{Blog};
    unless ($blog) {
        if ($entry) {
            $blog = $entry->blog;
        }
        elsif ($cat) {
            require MT::Blog;
            $blog = MT::Blog->load( $cat->blog_id );
        }
    }
    my @map = MT::TemplateMap->load(
        {
            archive_type => $at,
            blog_id      => $blog->id,
            $param{TemplateID} ? ( template_id => $param{TemplateID} ) : (),
        }
    );
    return 1 unless @map;

    my $fmgr = $blog->file_mgr;
    my $arch_root = ( $at eq 'Page' ) ? $blog->site_path : $blog->archive_path;

    require File::Spec;
    for my $map (@map) {
        my $file =
          $mt->archive_file_for( $entry, $blog, $at, $cat, $map, undef, $auth );
        $file = File::Spec->catfile( $arch_root, $file );
        if ( !defined($file) ) {
            die MT->translate( $blog->errstr() );
            return $mt->error( MT->translate( $blog->errstr() ) );
        }
        $fmgr->delete($file);
    }
    1;
}

##
## archive_file_for takes an entry to determine the timestamps,
## but if the entry is not available it uses the time_start
## and time_end values
##
sub archive_file_for {
    my $mt = shift;

    init_archive_types() unless %ArchiveTypes;

    my ( $entry, $blog, $at, $cat, $map, $timestamp, $author ) = @_;
    return if $at eq 'None';
    my $archiver = $ArchiveTypes{$at};
    return '' unless $archiver;

    my $file;
    if ( $blog->is_dynamic ) {
        require MT::TemplateMap;
		my $archiver = $ArchiveTypes{$at};
		if ($archiver) {
        	$map = MT::TemplateMap->new;
        	$map->file_template( $archiver->dynamic_template );
		}
    }
    unless ($map) {
        my $cache = MT::Request->instance->cache('maps');
        unless ($cache) {
            MT::Request->instance->cache( 'maps', $cache = {} );
        }
        unless ( $map = $cache->{ $blog->id . $at } ) {
            require MT::TemplateMap;
            $map = MT::TemplateMap->load(
                {
                    blog_id      => $blog->id,
                    archive_type => $at,
                    is_preferred => 1
                }
            );
            $cache->{ $blog->id . $at } = $map if $map;
        }
    }
    my $file_tmpl = $map->file_template if $map;
    unless ($file_tmpl) {
        if ( my $tmpls = $archiver->default_archive_templates ) {
            my ($default) = grep { $_->{default} } @$tmpls;
            $file_tmpl = $default->{template} if $default;
        }
    }
    $file_tmpl ||= '';
    my ($ctx);
    if ( $file_tmpl =~ m/\%[_-]?[A-Za-z]/ ) {
        if ( $file_tmpl =~ m/<\$?MT/ ) {
            $file_tmpl =~
s!(<\$?MT[^>]+?>)|(%[_-]?[A-Za-z])!$1 ? $1 : '<MTFileTemplate format="'. $2 . '">'!gie;
        }
        else {
            $file_tmpl = qq{<MTFileTemplate format="$file_tmpl">};
        }
    }
    if ($file_tmpl) {
        require MT::Template::Context;
        $ctx = MT::Template::Context->new;
        $ctx->stash( 'blog', $blog );
    }
    local $ctx->{__stash}{category}         = $cat if $cat;
    local $ctx->{__stash}{archive_category} = $cat if $cat;
    $timestamp = $entry->authored_on() if $entry;
    local $ctx->{__stash}{entry} = $entry if $entry;
    local $ctx->{__stash}{author} =
      $author ? $author : $entry ? $entry->author : undef;

    my %blog_at = map { $_ => 1 } split /,/, $blog->archive_type;
    return '' unless $blog_at{$at};

    $file = $archiver->archive_file->(
        $ctx,
        Timestamp => $timestamp,
        Template  => $file_tmpl
    );
    if ( $file_tmpl && !$file ) {
        local $ctx->{archive_type} = $at;
        require MT::Builder;
        my $build = MT::Builder->new;
        my $tokens = $build->compile( $ctx, $file_tmpl )
          or return $blog->error( $build->errstr() );
        defined( $file = $build->build( $ctx, $tokens ) )
          or return $blog->error( $build->errstr() );
    }
    else {
        my $ext = $blog->file_extension;
        $file .= '.' . $ext if $ext;
    }
    $file;
}

sub get_entry {
    my $mt = shift;
    my ( $ts, $blog_id, $at, $order ) = @_;
    my $range = $mt->archiver($at)->date_range;
    my ( $start, $end ) = $range->($ts);
    if ( $order eq 'previous' ) {
        $order = 'descend';
        $ts    = $start;
    }
    else {
        $order = 'ascend';
        $ts    = $end;
    }
    require MT::Entry;
    my $entry = MT::Entry->load(
        {
            blog_id => $blog_id,
            status  => MT::Entry::RELEASE()
        },
        {
            limit     => 1,
            'sort'    => 'authored_on',
            direction => $order,
            start_val => $ts
        }
    );
    $entry;
}

# Adds an element to the rebuild queue when the plugin is enabled.
sub queue_build_file_filter {
    my $mt = shift;
    my ( $cb, %args ) = @_;

    my $blog = $args{blog};
    return 1 unless $blog && $blog->publish_queue;

    my $fi = $args{file_info};
    return 1 if $fi->{from_queue};

    require MT::TheSchwartz;
    require TheSchwartz::Job;
    my $job = TheSchwartz::Job->new();
    $job->funcname('MT::Worker::Publish');
    $job->uniqkey( $fi->id );
    $job->coalesce( $$ . ':' . ( time - ( time % 100 ) ) );

    # my $at = $fi->archive_type || '';
    #
    # Default priority assignment....
    # if ($at eq 'Individual') {
    #     require MT::TemplateMap;
    #     my $map = MT::TemplateMap->load($fi->templatemap_id);
    #     # Individual archive pages that are the 'permalink' pages should
    #     # have highest build priority.
    #     if ($map && $map->is_preferred) {
    #         $rqf->priority(1);
    #     } else {
    #         $rqf->priority(9);
    #     }
    # } elsif ($at eq 'index') {
    #     # Index pages are second in priority, if they are named 'index'
    #     # or 'default'
    #     if ($fi->file_path =~ m!/(index|default|atom|feed)!i) {
    #         $rqf->priority(3);
    #     } else {
    #         $rqf->priority(9);
    #     }
    # } elsif (($at eq 'Monthly') || ($at eq 'Weekly') || ($at eq 'Daily')) {
    #     $rqf->priority(5);
    # } elsif ($at eq 'Category') {
    #     $rqf->priority(7);
    # }
    #
    # $rqf->save;

    MT::TheSchwartz->insert($job);

    return 0;
}


# ----- ARCHIVING -----

# Prepare sets up a context with the data necessary to build that page
# Archiver returns a filename for the given archive

sub yearly_archive_label {
    MT->translate("YEARLY_ADV");
}

sub yearly_archive_file {
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};

    my $file;
    if ($file_tmpl) {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} ) =
          start_end_month( $timestamp, $blog );
    }
    else {
        my $start = start_end_month( $timestamp, $blog );
        my ( $year, $mon ) = unpack 'A4', $start;
        $file = sprintf( "%04d/index", $year, $mon );
    }

    $file;
}

sub yearly_archive_title {
    my ( $ctx, $entry_or_ts ) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_year( $stamp, $ctx->stash('blog') );
    require MT::Template::Context;
    my $year =
      MT::Template::Context::_hdlr_date( $ctx,
        { ts => $start, 'format' => "%Y" } );
    my $lang = lc MT->current_language || 'en_us';
    $lang = 'ja' if lc($lang) eq 'jp';

    sprintf( "%s%s", $year, ( $lang eq 'ja' ? '&#24180;' : '' ) );
}

sub yearly_date_range { start_end_year(@_) }

sub yearly_group_iter {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $iter;
    my $sort_order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc' : 'desc';

    require MT::Entry;
    $iter = MT::Entry->count_group_by(
        {
            blog_id => $blog->id,
            status  => MT::Entry::RELEASE()
        },
        {
            group => ["extract(year from authored_on)"],
            $args->{lastn} ? ( limit => $args->{lastn} ) : (),
            sort => "extract(year from authored_on) $order"
        }
    ) or return $ctx->error("Couldn't get yearly archive list");

    return sub {
        while ( my @row = $iter->() ) {
            my $date = sprintf( "%04d%02d%02d000000", $row[1], 1, 1 );
            my ( $start, $end ) = start_end_year($date);
            return ( $row[0], year => $row[1], start => $start, end => $end );
        }
        undef;
    };
}

sub yearly_group_entries {
    my ( $ctx, %param ) = @_;
    date_based_group_entries( $ctx, 'Yearly',
        %param ? sprintf( "%04d%02d%02d000000", $param{year}, 1, 1 ) : undef );
}

sub yearly_entries_count {
    my ( $blog, $at, $entry ) = @_;
    return _archive_entries_count(
        {
            Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $entry->authored_on
        }
    );
}

sub monthly_archive_label {
    MT->translate("MONTHLY_ADV");
}

sub monthly_archive_file {
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};

    my $file;
    if ($file_tmpl) {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} ) =
          start_end_month( $timestamp, $blog );
    }
    else {
        my $start = start_end_month( $timestamp, $blog );
        my ( $year, $mon ) = unpack 'A4A2', $start;
        $file = sprintf( "%04d/%02d/index", $year, $mon );
    }

    $file;
}

sub monthly_archive_title {
    my ( $ctx, $entry_or_ts ) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_month( $stamp, $ctx->stash('blog') );
    MT::Template::Context::_hdlr_date( $ctx,
        { ts => $start, 'format' => "%B %Y" } );
}

sub monthly_date_range { start_end_month(@_) }

sub monthly_group_iter {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $iter;
    my $sort_order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc' : 'desc';

    require MT::Entry;
    $iter = MT::Entry->count_group_by(
        {
            blog_id => $blog->id,
            status  => MT::Entry::RELEASE()
        },
        {
            group => [
                "extract(year from authored_on)",
                "extract(month from authored_on)"
            ],
            $args->{lastn} ? ( limit => $args->{lastn} ) : (),
            sort => "extract(year from authored_on) $order,
                       extract(month from authored_on) $order"
        }
    ) or return $ctx->error("Couldn't get monthly archive list");

    return sub {
        while ( my @row = $iter->() ) {
            my $date = sprintf( "%04d%02d%02d000000", $row[1], $row[2], 1 );
            my ( $start, $end ) = start_end_month($date);
            return (
                $row[0],
                year  => $row[1],
                month => $row[2],
                start => $start,
                end   => $end
            );
        }
        undef;
    };
}

sub monthly_group_entries {
    my ( $ctx, %param ) = @_;
    date_based_group_entries( $ctx, 'Monthly',
        %param
        ? sprintf( "%04d%02d%02d000000", $param{year}, $param{month}, 1 )
        : undef );
}

sub monthly_entries_count {
    my ( $blog, $at, $entry ) = @_;
    return _archive_entries_count(
        {
            Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $entry->authored_on
        }
    );
}

sub category_archive_label {
    MT->translate("CATEGORY_ADV");
}

sub category_archive_title {
    my ($ctx) = @_;
    my $c = $ctx->stash('category');
    $c ? $c->label : '';
}

sub category_archive_file {
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};
    my $cat       = $ctx->{__stash}{category};
    my $entry     = $ctx->{__stash}{entry};
    my $file;

    my $this_cat = $cat ? $cat : ( $entry ? $entry->category : undef );
    if ($file_tmpl) {
        $ctx->stash( 'archive_category', $this_cat );
        $ctx->{inside_mt_categories} = 1;
        $ctx->{__stash}{category} = $this_cat;
    }
    else {
        if ( !$this_cat ) {
            return "";
        }
        my $label = '';
        $label = dirify( $this_cat->label );
        if ( $label !~ /\w/ ) {
            $label = $this_cat ? "cat" . $this_cat->id : "";
        }
        $file = sprintf( "%s/index", $this_cat->category_path );
    }
    $file;
}

sub category_group_iter {
    my ( $ctx, $args ) = @_;

    my $blog_id = $ctx->stash('blog')->id;
    require MT::Category;
    my $iter = MT::Category->load_iter( { blog_id => $blog_id },
        { 'sort' => 'label', direction => 'ascend' } );
    require MT::Placement;
    require MT::Entry;

    return sub {
        while ( my $c = $iter->() ) {
            my $args = [
                {
                    blog_id => $blog_id,
                    status  => MT::Entry::RELEASE()
                },
                {
                    'join' => [
                        'MT::Placement', 'entry_id', { category_id => $c->id }
                    ]
                }
            ];
            my $count = MT::Entry->count( undef, $args );
            next unless $count || $args->{show_empty};
            return ( $count, category => $c );
        }
        undef;
      }
}

sub category_group_entries {
    my ( $ctx, %param ) = @_;

    my $c = $ctx->stash('archive_category') || $ctx->stash('category');
    require MT::Entry;
    my @entries = MT::Entry->load(
        { status => MT::Entry::RELEASE() },
        {
            join => [
                'MT::Placement', 'entry_id',
                { category_id => $c->id }, { unqiue => 1 }
            ],
            'sort' => 'authored_on',
            'direction' => 'descend',
        }
    );
    \@entries;
}

sub category_entries_count {
    my ( $blog, $at, $entry ) = @_;
    my $cat = $entry->category;
    return 0 unless $cat;
    return _archive_entries_count(
        {
            Blog        => $blog,
            ArchiveType => $at,
            Category    => $cat
        }
    );
}

sub page_archive_label {
    MT->translate("PAGE_ADV");
}

sub page_archive_file {
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};
    my $page      = $ctx->{__stash}{entry};

    my $file;
    Carp::croak "archive_file_for Page archive needs a page"
      unless $page && $page->isa('MT::Page');
    unless ($file_tmpl) {
        my $basename = $page->basename();
        my $folder   = $page->folder;
        my $folder_path;
        if ($folder) {
            $folder_path = $folder->publish_path || '';
            $file =
              $folder_path ne '' ? $folder_path . '/' . $basename : $basename;
        }
        else {
            $file = $basename;
        }
    }
    return $file;
}

sub page_group_iter {
    my ( $ctx, $args ) = @_;

    require MT::Page;
    my $blog_id = $ctx->stash('blog')->id;
    my $iter    = MT::Page->load_iter(
        {
            blog_id => $blog_id,
            status  => MT::Entry::RELEASE()
        },
        { sort => 'title', direction => 'ascend' }
    );
    return sub {
        while ( my $entry = $iter->() ) {
            return ( 1, entries => [$entry], entry => $entry );
        }
        undef;
      }
}

sub individual_archive_label {
    MT->translate("INDIVIDUAL_ADV");
}

sub individual_archive_file {
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};
    my $entry     = $ctx->{__stash}{entry};

    my $file;
    Carp::confess "archive_file_for Individual archive needs an entry"
      unless $entry;
    if ($file_tmpl) {
        $ctx->{current_timestamp} = $entry->authored_on;
    }
    else {
        my $basename = $entry->basename();
        $basename ||= dirify( $entry->title() );
        $file = sprintf( "%04d/%02d/%s",
            unpack( 'A4A2', $entry->authored_on ), $basename );
    }
    $file;
}

sub individual_archive_title { $_[1]->title }

sub individual_group_iter {
    my ( $ctx, $args ) = @_;

    my $order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';

    my $blog_id = $ctx->stash('blog')->id;
    require MT::Entry;
    my $iter = MT::Entry->load_iter(
        {
            blog_id => $blog_id,
            status  => MT::Entry::RELEASE()
        },
        {
            'sort'    => 'authored_on',
            direction => $order,
            $args->{lastn} ? ( limit => $args->{lastn} ) : ()
        }
    );
    return sub {
        while ( my $entry = $iter->() ) {
            return ( 1, entries => [$entry], entry => $entry );
        }
        undef;
      }
}

sub daily_archive_label {
    MT->translate("DAILY_ADV");
}

sub daily_archive_file {
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};

    my $file;
    if ($file_tmpl) {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} ) =
          start_end_day($timestamp);
    }
    else {
        my $start = start_end_day($timestamp);
        my ( $year, $mon, $mday ) = unpack 'A4A2A2', $start;
        $file = sprintf( "%04d/%02d/%02d/index", $year, $mon, $mday );
    }
    $file;
}

sub daily_archive_title {
    my $stamp = ref $_[1] ? $_[1]->authored_on : $_[1];
    my $start = start_end_day( $stamp, $_[0]->stash('blog') );
    MT::Template::Context::_hdlr_date( $_[0],
        { ts => $start, 'format' => "%x" } );
}

sub daily_date_range { start_end_day(@_) }

sub daily_group_iter {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $iter;
    my $sort_order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc' : 'desc';

    require MT::Entry;
    $iter = MT::Entry->count_group_by(
        {
            blog_id => $blog->id,
            status  => MT::Entry::RELEASE()
        },
        {
            group => [
                "extract(year from authored_on)",
                "extract(month from authored_on)",
                "extract(day from authored_on)"
            ],
            $args->{lastn} ? ( limit => $args->{lastn} ) : (),
            sort => "extract(year from authored_on) $order,
                        extract(month from authored_on) $order,
                        extract(day from authored_on) $order"
        }
    ) or return $ctx->error("Couldn't get daily archive list");

    return sub {
        while ( my @row = $iter->() ) {
            my $date =
              sprintf( "%04d%02d%02d000000", $row[1], $row[2], $row[3] );
            my ( $start, $end ) = start_end_day($date);
            return (
                $row[0],
                year  => $row[1],
                month => $row[2],
                day   => $row[3],
                start => $start,
                end   => $end
            );
        }
        undef;
    };
}

sub daily_group_entries {
    my ( $ctx, %param ) = @_;
    date_based_group_entries(
        $ctx, 'Daily',
        %param
        ? sprintf( "%04d%02d%02d000000",
            $param{year}, $param{month}, $param{day} )
        : undef
    );
}

sub daily_entries_count {
    my ( $blog, $at, $entry ) = @_;
    return _archive_entries_count(
        {
            Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $entry->authored_on
        }
    );
}

sub weekly_archive_label {
    MT->translate("WEEKLY_ADV");
}

sub weekly_archive_file {
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};

    my $file;
    if ($file_tmpl) {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} ) =
          start_end_week($timestamp);
    }
    else {
        my $start = start_end_week($timestamp);
        my ( $year, $mon, $mday ) = unpack 'A4A2A2', $start;
        $file = sprintf( "%04d/%02d/%02d-week/index", $year, $mon, $mday );
    }
    $file;
}

sub weekly_archive_title {
    my $stamp = ref $_[1] ? $_[1]->authored_on : $_[1];
    my ( $start, $end ) = start_end_week( $stamp, $_[0]->stash('blog') );
    MT::Template::Context::_hdlr_date( $_[0],
        { ts => $start, 'format' => "%x" } )
      . ' - '
      . MT::Template::Context::_hdlr_date( $_[0],
        { ts => $end, 'format' => "%x" } );
}

sub weekly_date_range { start_end_week(@_) }

sub weekly_group_iter {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $iter;
    my $sort_order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc' : 'desc';

    require MT::Entry;
    $iter = MT::Entry->count_group_by(
        {
            blog_id => $blog->id,
            status  => MT::Entry::RELEASE()
        },
        {
            group => [ "extract(year from authored_on)", "week_number" ],
            $args->{lastn} ? ( limit => $args->{lastn} ) : (),
            sort => "extract(year from authored_on) $order,
                       week_number $order"
        }
    ) or return $ctx->error("Couldn't get weekly archive list");

    return sub {
        while ( my @row = $iter->() ) {
            my $date =
              sprintf( "%04d%02d%02d000000", week2ymd( $row[1], $row[2] ) );
            my ( $start, $end ) = start_end_week($date);
            return (
                $row[0],
                year  => $row[1],
                week  => $row[2],
                start => $start,
                end   => $end
            );
        }
        undef;
    };
}

sub weekly_group_entries {
    my ( $ctx, %param ) = @_;
    date_based_group_entries(
        $ctx, 'Weekly',
        %param
        ? sprintf( "%04d%02d%02d000000",
            week2ymd( $param{year}, $param{week} ) )
        : undef
    );
}

sub weekly_entries_count {
    my ( $blog, $at, $entry ) = @_;
    return _archive_entries_count(
        {
            Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $entry->authored_on
        }
    );
}

sub _archive_entries_count {
    my ($params) = @_;
    my $blog     = $params->{Blog};
    my $at       = $params->{ArchiveType};
    my $ts       = $params->{Timestamp};
    my $cat      = $params->{Category};
    my $auth     = $params->{Author};
    my ( $start, $end );
    if ($ts) {
        init_archive_types() unless %ArchiveTypes;
		my $archiver = $ArchiveTypes{$at};
        ( $start, $end ) = $archiver->date_range->($ts) if $archiver;
    }

    my $count = MT->model('entry')->count(
        {
            blog_id => $blog->id,
            status  => MT::Entry::RELEASE(),
            ( $ts ? ( authored_on => [ $start, $end ] ) : () ),
            ( $auth ? ( author_id => $auth->id ) : () ),
        },
        {
            ( $ts ? ( range => { authored_on => 1 } ) : () ),
            (
                $cat
                ? (
                    'join' => [
                        'MT::Placement', 'entry_id',
                        { category_id => $cat->id }
                    ]
                  )
                : ()
            ),
        }
    );
    return $count;
}

sub date_based_group_entries {
    my ( $ctx, $at, $ts ) = @_;
    my $blog = $ctx->stash('blog');
    my ( $start, $end );
    if ($ts) {
        init_archive_types() unless %ArchiveTypes;
		my $archiver = $ArchiveTypes{$at};
		if ( $archiver ) {
        	( $start, $end ) = $archiver->date_range->($ts);
        	$ctx->{current_timestamp}     = $start;
        	$ctx->{current_timestamp_end} = $end;
		}
    }
    else {
        $start = $ctx->{current_timestamp};
        $end   = $ctx->{current_timestamp_end};
    }
    require MT::Entry;
    my @entries = MT::Entry->load(
        {
            blog_id     => $blog->id,
            status      => MT::Entry::RELEASE(),
            authored_on => [ $start, $end ]
        },
        {
            range  => { authored_on => 1 },
            'sort' => 'authored_on',
            'direction' => 'descend',
        }
    ) or return $ctx->error("Couldn't get $at archive list");
    \@entries;
}

sub author_archive_title {
    my ($ctx) = @_;
    my $a = $ctx->stash('author');
    $a ? $a->nickname || MT->translate( 'Author (#[_1])', $a->id ) : '';
}

sub author_archive_label {
    MT->translate('AUTHOR_ADV');
}

sub author_archive_file {
    my ( $ctx, %param ) = @_;
    my $file_tmpl = $param{Template};
    my $author    = $ctx->{__stash}{author};
    my $entry     = $ctx->{__stash}{entry};
    my $file;

    my $this_author = $author ? $author : ( $entry ? $entry->author : undef );
    return "" unless $this_author;

    my $name = dirify( $this_author->nickname );
    $name = "author" . $this_author->id if $name !~ /\w/;
    $ctx->{__stash}{current_author_name} = $name;
    if ( !$file_tmpl ) {
        $file = sprintf( "%s/index", $name );
    }
    $file;
}

sub author_group_iter {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $auth_order = $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;
    require MT::Entry;
    require MT::Author;
    my $auth_iter = MT::Author->load_iter(
        undef,
        {
            sort      => 'name',
            direction => $auth_order,
            join      => [
                'MT::Entry', 'author_id',
                { status => MT::Entry::RELEASE(), blog_id => $blog->id },
                { unique => 1 }
            ]
        }
    );
    my $i = 0;
    return sub {

        while ( my $a = $auth_iter->() ) {
            last if defined($limit) && $i == $limit;
            my $count = MT::Entry->count(
                {
                    blog_id   => $blog->id,
                    status    => MT::Entry::RELEASE(),
                    author_id => $a->id
                }
            );
            next if $count == 0 && !$args->{show_empty};
            $i++;
            return ( $count, author => $a );
        }
        undef;
    };
}

sub author_group_entries {
    my ( $ctx, %param ) = @_;
    my $blog = $ctx->stash('blog');
    my $a = $param{author} || $ctx->stash('author');
    return [] unless $a;
    require MT::Entry;
    my @entries = MT::Entry->load(
        {
            blog_id   => $blog->id,
            author_id => $a->id,
            status    => MT::Entry::RELEASE()
        },
        {
            'sort'      => 'authored_on',
            'direction' => 'descend',
        }
    );
    \@entries;
}

sub author_entries_count {
    my ( $blog, $at, $entry ) = @_;
    my $auth = $entry->author;
    return _archive_entries_count(
        {
            Blog        => $blog,
            ArchiveType => $at,
            Author      => $auth
        }
    );
}

sub _display_name {
    my ($ctx)    = shift;
    my $tmpl     = $ctx->stash('template');
    my $at       = $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    my $author   = '';
    if (   ( $tmpl && $tmpl->type eq 'index' )
        || !$archiver
        || ( $archiver && !$archiver->author_based )
        || !$ctx->{inside_archive_list} )
    {
        $author = $ctx->stash('author');
        $author =
            $author
          ? $author->nickname
          ? $author->nickname . ": "
          : MT->translate( 'Author (#[_1])', $author->id )
          : '';
    }
    return $author;
}

sub author_yearly_archive_title {
    my ( $ctx, $entry_or_ts ) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_year($stamp);
    my $year =
      MT::Template::Context::_hdlr_date( $ctx,
        { ts => $start, 'format' => "%Y" } );
    my $lang = lc MT->current_language || 'en_us';
    $lang = 'ja' if lc($lang) eq 'jp';
    my $author = _display_name($ctx);

    sprintf( "%s%s%s", $author, $year, ( $lang eq 'ja' ? '&#24180;' : '' ) );
}

sub author_yearly_archive_label {
    MT->translate('AUTHOR-YEARLY_ADV');
}

sub author_yearly_archive_file {
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $author    = $ctx->{__stash}{author};
    my $entry     = $ctx->{__stash}{entry};
    my $file;
    my $this_author = $author ? $author : ( $entry ? $entry->author : undef );
    return "" unless $this_author;
    my $name = dirify( $this_author->nickname );

    if ( $name eq '' || !$file_tmpl ) {
        return "" unless $this_author;
        $name = "author" . $this_author->id if $name !~ /\w/;
        my $start = start_end_year($timestamp);
        my ($year) = unpack 'A4', $start;
        $file = sprintf( "%s/%04d/index", $name, $year );
    }
    else {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} ) =
          start_end_year($timestamp);
    }
    $file;
}

sub author_yearly_group_iter {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $auth_order = $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;

    my $tmpl  = $ctx->stash('template');
    my @data  = ();
    my $count = 0;

    my $at       = $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    my $author;

    # if (($tmpl && $tmpl->type ne 'index') &&
    #     ($archiver && $archiver->author_based))
    # {
    $author = $ctx->stash('author');

    # }

    require MT::Entry;
    my $loop_sub = sub {
        my $auth       = shift;
        my $count_iter = MT::Entry->count_group_by(
            {
                blog_id   => $blog->id,
                author_id => $auth->id,
                status    => MT::Entry::RELEASE()
            },
            {
                group  => ["extract(year from authored_on)"],
                'sort' => "extract(year from authored_on) $order"
            }
        ) or return $ctx->error("Couldn't get monthly archive list");

        while ( my @row = $count_iter->() ) {
            my $hash = {
                year   => $row[1],
                author => $auth,
                count  => $row[0],
            };
            push( @data, $hash );
            return $count + 1
              if ( defined($limit) && ( $count + 1 ) == $limit );
            $count++;
        }
        return $count;
    };

    # Count entry by author
    if ($author) {
        $loop_sub->($author);
    }
    else {

        # load authors
        require MT::Author;
        my $iter;
        $iter = MT::Author->load_iter(
            undef,
            {
                sort      => 'name',
                direction => $auth_order,
                join      => [
                    'MT::Entry', 'author_id',
                    { status => MT::Entry::RELEASE(), blog_id => $blog->id },
                    { unique => 1 }
                ]
            }
        );

        while ( my $a = $iter->() ) {
            $loop_sub->($a);
            last if ( defined($limit) && $count == $limit );
        }
    }

    my $loop = @data;
    my $curr = 0;

    return sub {
        if ( $curr < $loop ) {
            my $date =
              sprintf( "%04d%02d%02d000000", $data[$curr]->{year}, 1, 1 );
            my ( $start, $end ) = start_end_year($date);
            my $count = $data[$curr]->{count};
            my %hash  = (
                author => $data[$curr]->{author},
                year   => $data[$curr]->{year},
                start  => $start,
                end    => $end
            );
            $curr++;
            return ( $count, %hash );
        }
        undef;
      }
}

sub author_yearly_group_entries {
    my ( $ctx, %param ) = @_;
    my $ts =
      %param
      ? sprintf( "%04d%02d%02d000000", $param{year}, 1, 1 )
      : $ctx->stash('current_timestamp');
    my $author = %param ? $param{author} : $ctx->stash('author');
    date_based_author_entries( $ctx, 'Author-Yearly', $author, $ts );
}

sub author_yearly_entries_count {
    my ( $blog, $at, $entry ) = @_;
    my $auth = $entry->author;
    return _archive_entries_count(
        {
            Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $entry->authored_on,
            Author      => $auth
        }
    );
}

sub author_yearly_date_range { start_end_year(@_) }

sub author_monthly_archive_title {
    my ( $ctx, $entry_or_ts ) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_month($stamp);
    my $date =
      MT::Template::Context::_hdlr_date( $ctx,
        { ts => $start, 'format' => "%B %Y" } );
    my $author = _display_name($ctx);

    sprintf( "%s%s", $author, $date );
}

sub author_monthly_archive_label {
    MT->translate('AUTHOR-MONTHLY_ADV');
}

sub author_monthly_archive_file {
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $author    = $ctx->{__stash}{author};
    my $entry     = $ctx->{__stash}{entry};
    my $file;
    my $this_author = $author ? $author : ( $entry ? $entry->author : undef );
    return "" unless $this_author;
    my $name = dirify( $this_author->nickname );

    if ( $name eq '' || !$file_tmpl ) {
        return "" unless $this_author;
        $name = "author" . $this_author->id if $name !~ /\w/;
        my $start = start_end_month($timestamp);
        my ( $year, $month ) = unpack 'A4A2', $start;
        $file = sprintf( "%s/%04d/%02d/index", $name, $year, $month );
    }
    else {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} ) =
          start_end_month($timestamp);
    }
    $file;
}

sub author_monthly_group_iter {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $auth_order = $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;

    my $tmpl  = $ctx->stash('template');
    my @data  = ();
    my $count = 0;

    my $at       = $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    my $author;

    my $ts    = $ctx->{current_timestamp};
    my $tsend = $ctx->{current_timestamp_end};

    # if (($tmpl && $tmpl->type ne 'index') &&
    #     ($archiver && $archiver->author_based))
    # {
    $author = $ctx->stash('author');

    # }

    require MT::Entry;
    my $loop_sub = sub {
        my $auth       = shift;
        my $count_iter = MT::Entry->count_group_by(
            {
                blog_id   => $blog->id,
                author_id => $auth->id,
                status    => MT::Entry::RELEASE(),
                ( $ts && $tsend ? ( authored_on => [ $ts, $tsend ] ) : () ),
            },
            {
                ( $ts && $tsend ? ( range_incl => { authored_on => 1 } ) : () ),
                group => [
                    "extract(year from authored_on)",
                    "extract(month from authored_on)"
                ],
                'sort' => "extract(year from authored_on) $order,
                         extract(month from authored_on) $order"
            }
        ) or return $ctx->error("Couldn't get monthly archive list");

        while ( my @row = $count_iter->() ) {
            my $hash = {
                year   => $row[1],
                month  => $row[2],
                author => $auth,
                count  => $row[0],
            };
            push( @data, $hash );
            return $count + 1
              if ( defined($limit) && ( $count + 1 ) == $limit );
            $count++;
        }
        return $count;
    };

    # Count entry by author
    if ($author) {
        $loop_sub->($author);
    }
    else {

        # load authors
        require MT::Author;
        my $iter;
        $iter = MT::Author->load_iter(
            undef,
            {
                sort      => 'name',
                direction => $auth_order,
                join      => [
                    'MT::Entry', 'author_id',
                    { status => MT::Entry::RELEASE(), blog_id => $blog->id },
                    { unique => 1 }
                ]
            }
        );

        while ( my $a = $iter->() ) {
            $loop_sub->($a);
            last if ( defined($limit) && $count == $limit );
        }
    }

    my $loop = @data;
    my $curr = 0;

    return sub {
        if ( $curr < $loop ) {
            my $date = sprintf(
                "%04d%02d%02d000000",
                $data[$curr]->{year},
                $data[$curr]->{month}, 1
            );
            my ( $start, $end ) = start_end_month($date);
            my $count = $data[$curr]->{count};
            my %hash  = (
                author => $data[$curr]->{author},
                year   => $data[$curr]->{year},
                month  => $data[$curr]->{month},
                start  => $start,
                end    => $end
            );
            $curr++;
            return ( $count, %hash );
        }
        undef;
      }
}

sub author_monthly_group_entries {
    my ( $ctx, %param ) = @_;
    my $ts =
      %param
      ? sprintf( "%04d%02d%02d000000", $param{year}, $param{month}, 1 )
      : $ctx->stash('current_timestamp');
    my $author = %param ? $param{author} : $ctx->stash('author');
    date_based_author_entries( $ctx, 'Author-Monthly', $author, $ts );
}

sub author_monthly_entries_count {
    my ( $blog, $at, $entry ) = @_;
    my $auth = $entry->author;
    return _archive_entries_count(
        {
            Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $entry->authored_on,
            Author      => $auth
        }
    );
}

sub author_monthly_date_range { start_end_month(@_) }

sub author_weekly_archive_title {
    my ( $ctx, $entry_or_ts ) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my ( $start, $end ) = start_end_week($stamp);
    my $start_date =
      MT::Template::Context::_hdlr_date( $ctx,
        { ts => $start, 'format' => "%x" } );
    my $end_date =
      MT::Template::Context::_hdlr_date( $ctx,
        { ts => $end, 'format' => "%x" } );
    my $author = _display_name($ctx);

    sprintf( "%s%s - %s", $author, $start_date, $end_date );
}

sub author_weekly_archive_label {
    MT->translate('AUTHOR-WEEKLY_ADV');
}

sub author_weekly_archive_file {
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $author    = $ctx->{__stash}{author};
    my $entry     = $ctx->{__stash}{entry};
    my $file;
    my $this_author = $author ? $author : ( $entry ? $entry->author : undef );
    return "" unless $this_author;
    my $name = dirify( $this_author->nickname );

    if ( $name eq '' || !$file_tmpl ) {
        return "" unless $this_author;
        $name = "author" . $this_author->id if $name !~ /\w/;
        my $start = start_end_week($timestamp);
        my ( $year, $month, $day ) = unpack 'A4A2A2', $start;
        $file =
          sprintf( "%s/%04d/%02d/%02d-week/index", $name, $year, $month, $day );
    }
    else {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} ) =
          start_end_week($timestamp);
    }
    $file;
}

sub author_weekly_group_iter {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $auth_order = $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;

    my $tmpl  = $ctx->stash('template');
    my @data  = ();
    my $count = 0;

    my $ts    = $ctx->{current_timestamp};
    my $tsend = $ctx->{current_timestamp_end};

    my $at       = $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    my $author;

    # if (($tmpl && $tmpl->type ne 'index') &&
    #     ($archiver && $archiver->author_based))
    # {
    $author = $ctx->stash('author');

    # }

    require MT::Entry;
    my $loop_sub = sub {
        my $auth       = shift;
        my $count_iter = MT::Entry->count_group_by(
            {
                blog_id   => $blog->id,
                author_id => $auth->id,
                status    => MT::Entry::RELEASE(),
                ( $ts && $tsend ? ( authored_on => [ $ts, $tsend ] ) : () ),
            },
            {
                ( $ts && $tsend ? ( range_incl => { authored_on => 1 } ) : () ),
                group  => ["week_number"],
                'sort' => "week_number $order"
            }
        ) or return $ctx->error("Couldn't get weekly archive list");

        while ( my @row = $count_iter->() ) {
            my ( $year, $week ) = unpack 'A4A2', $row[1];
            my $hash = {
                year   => $year,
                week   => $week,
                author => $auth,
                count  => $row[0],
            };
            push( @data, $hash );
            return $count + 1
              if ( defined($limit) && ( $count + 1 ) == $limit );
            $count++;
        }
        return $count;
    };

    # Count entry by author
    if ($author) {
        $loop_sub->($author);
    }
    else {

        # load authors
        require MT::Author;
        my $iter;
        $iter = MT::Author->load_iter(
            undef,
            {
                sort      => 'name',
                direction => $auth_order,
                join      => [
                    'MT::Entry', 'author_id',
                    { status => MT::Entry::RELEASE(), blog_id => $blog->id },
                    { unique => 1 }
                ]
            }
        );

        while ( my $a = $iter->() ) {
            $loop_sub->($a);
            last if ( defined($limit) && $count == $limit );
        }
    }

    my $loop = @data;
    my $curr = 0;

    return sub {
        if ( $curr < $loop ) {
            my $date = sprintf( "%04d%02d%02d000000",
                week2ymd( $data[$curr]->{year}, $data[$curr]->{week} ) );
            my ( $start, $end ) = start_end_week($date);
            my $count = $data[$curr]->{count};
            my %hash  = (
                author => $data[$curr]->{author},
                year   => $data[$curr]->{year},
                week   => $data[$curr]->{week},
                start  => $start,
                end    => $end
            );
            $curr++;
            return ( $count, %hash );
        }
        undef;
      }
}

sub author_weekly_group_entries {
    my ( $ctx, %param ) = @_;
    my $ts =
      %param
      ? sprintf( "%04d%02d%02d000000", week2ymd( $param{year}, $param{week} ) )
      : $ctx->stash('current_timestamp');
    my $author = %param ? $param{author} : $ctx->stash('author');
    date_based_author_entries( $ctx, 'Author-Weekly', $author, $ts );
}

sub author_weekly_entries_count {
    my ( $blog, $at, $entry ) = @_;
    my $auth = $entry->author;
    return _archive_entries_count(
        {
            Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $entry->authored_on,
            Author      => $auth
        }
    );
}

sub author_weekly_date_range { start_end_week(@_) }

sub author_daily_archive_title {
    my ( $ctx, $entry_or_ts ) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_day($stamp);
    my $date =
      MT::Template::Context::_hdlr_date( $ctx,
        { ts => $start, 'format' => "%x" } );
    my $author = _display_name($ctx);

    sprintf( "%s%s", $author, $date );
}

sub author_daily_archive_label {
    MT->translate('AUTHOR-DAILY_ADV');
}

sub author_daily_archive_file {
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $author    = $ctx->{__stash}{author};
    my $entry     = $ctx->{__stash}{entry};
    my $file;
    my $this_author = $author ? $author : ( $entry ? $entry->author : undef );
    return "" unless $this_author;
    my $name = dirify( $this_author->nickname );

    if ( $name eq '' || !$file_tmpl ) {
        return "" unless $this_author;
        $name = "author" . $this_author->id if $name !~ /\w/;
        my $start = start_end_day($timestamp);
        my ( $year, $month, $day ) = unpack 'A4A2A2', $start;
        $file =
          sprintf( "%s/%04d/%02d/%02d/index", $name, $year, $month, $day );
    }
    else {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} ) =
          start_end_day($timestamp);
    }
    $file;
}

sub author_daily_group_iter {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $auth_order = $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc' : 'desc';
    my $limit = exists $args->{lastn} ? delete $args->{lastn} : undef;

    my $tmpl  = $ctx->stash('template');
    my @data  = ();
    my $count = 0;

    my $ts    = $ctx->{current_timestamp};
    my $tsend = $ctx->{current_timestamp_end};

    my $at       = $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    my $author;

    # if (($tmpl && $tmpl->type ne 'index') &&
    #     ($archiver && $archiver->author_based))
    # {
    $author = $ctx->stash('author');

    # }

    require MT::Entry;
    my $loop_sub = sub {
        my $auth       = shift;
        my $count_iter = MT::Entry->count_group_by(
            {
                blog_id   => $blog->id,
                author_id => $auth->id,
                status    => MT::Entry::RELEASE(),
                ( $ts && $tsend ? ( authored_on => [ $ts, $tsend ] ) : () ),
            },
            {
                ( $ts && $tsend ? ( range_incl => { authored_on => 1 } ) : () ),
                group => [
                    "extract(year from authored_on)",
                    "extract(month from authored_on)",
                    "extract(day from authored_on)"
                ],
                'sort' => "extract(year from authored_on) $order,
                         extract(month from authored_on) $order,
                         extract(day from authored_on) $order"
            }
        ) or return $ctx->error("Couldn't get monthly archive list");

        while ( my @row = $count_iter->() ) {
            my $hash = {
                year   => $row[1],
                month  => $row[2],
                day    => $row[3],
                author => $auth,
                count  => $row[0],
            };
            push( @data, $hash );
            return $count + 1
              if ( defined($limit) && ( $count + 1 ) == $limit );
            $count++;
        }
        return $count;
    };

    # Count entry by author
    if ($author) {
        $loop_sub->($author);
    }
    else {

        # load authors
        require MT::Author;
        my $iter;
        $iter = MT::Author->load_iter(
            undef,
            {
                sort      => 'name',
                direction => $auth_order,
                join      => [
                    'MT::Entry', 'author_id',
                    { status => MT::Entry::RELEASE(), blog_id => $blog->id },
                    { unique => 1 }
                ]
            }
        );

        while ( my $a = $iter->() ) {
            $loop_sub->($a);
            last if ( defined($limit) && $count == $limit );
        }
    }

    my $loop = @data;
    my $curr = 0;

    return sub {
        if ( $curr < $loop ) {
            my $date = sprintf(
                "%04d%02d%02d000000",
                $data[$curr]->{year},
                $data[$curr]->{month},
                $data[$curr]->{day}
            );
            my ( $start, $end ) = start_end_day($date);
            my $count = $data[$curr]->{count};
            my %hash  = (
                author => $data[$curr]->{author},
                year   => $data[$curr]->{year},
                month  => $data[$curr]->{month},
                day    => $data[$curr]->{day},
                start  => $start,
                end    => $end
            );
            $curr++;
            return ( $count, %hash );
        }
        undef;
      }
}

sub author_daily_group_entries {
    my ( $ctx, %param ) = @_;
    my $ts =
      %param
      ? sprintf( "%04d%02d%02d000000", $param{year}, $param{month},
        $param{day} )
      : $ctx->stash('current_timestamp');
    my $author = %param ? $param{author} : $ctx->stash('author');
    date_based_author_entries( $ctx, 'Author-Daily', $author, $ts );
}

sub author_daily_entries_count {
    my ( $blog, $at, $entry ) = @_;
    my $auth = $entry->author;
    return _archive_entries_count(
        {
            Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $entry->authored_on,
            Author      => $auth
        }
    );
}

sub author_daily_date_range { start_end_day(@_) }

sub _display_category {
    my $ctx      = shift;
    my $tmpl     = $ctx->stash('template');
    my $at       = $ctx->{archive_type};
    my $archiver = MT->publisher->archiver($at);
    my $cat      = '';
    if (   !$tmpl
        || $tmpl->type eq 'index'
        || !$archiver
        || ( $archiver && !$archiver->category_based )
        || !$ctx->{inside_archive_list} )
    {
        $cat = $ctx->stash('archive_category') || $ctx->stash('category');
        $cat = $cat ? $cat->label . ': ' : '';
    }
    return $cat;
}

sub date_based_author_entries {
    my ( $ctx, $at, $author, $ts ) = @_;

    my $blog     = $ctx->stash('blog');
    my $archiver = MT->publisher->archiver($at);
    my ( $start, $end );
    if ($ts) {
        ( $start, $end ) = $archiver->date_range->($ts);
    }
    else {
        $start = $ctx->{current_timestamp};
        $end   = $ctx->{current_timestamp_end};
    }
    my @entries = MT::Entry->load(
        {
            blog_id     => $blog->id,
            author_id   => $author->id,
            status      => MT::Entry::RELEASE(),
            authored_on => [ $start, $end ]
        },
        {
            range => { authored_on => 1 },
            'sort' => 'authored_on',
            'direction' => 'descend',
        }
    ) or return $ctx->error("Couldn't get $at archive list");
    \@entries;
}

sub cat_yearly_archive_label {
    MT->translate('CATEGORY-YEARLY_ADV');
}

sub cat_yearly_archive_file {
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};
    my $cat       = $ctx->{__stash}{cat} || $ctx->{__stash}{category};
    my $entry     = $ctx->{__stash}{entry};
    my $file;

    my $this_cat = $cat ? $cat : ( $entry ? $entry->category : undef );
    if ($file_tmpl) {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} ) =
          start_end_year( $timestamp, $blog );
        $ctx->stash( 'archive_category', $this_cat );
        $ctx->{inside_mt_categories} = 1;
        $ctx->{__stash}{category} = $this_cat;
    }
    else {
        if ( !$this_cat ) {
            return "";
        }
        my $label = '';
        $label = dirify( $this_cat->label );
        if ( $label !~ /\w/ ) {
            $label = $this_cat ? "cat" . $this_cat->id : "";
        }
        my $start = start_end_year( $timestamp, $blog );
        my ($year) = unpack 'A4', $start;
        $file = sprintf( "%s/%04d/index", $this_cat->category_path, $year );
    }
    $file;
}

sub cat_yearly_date_range { start_end_year(@_) }

sub cat_yearly_archive_title {
    my ( $ctx, $entry_or_ts ) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_year( $stamp, $ctx->stash('blog') );
    my $year =
      MT::Template::Context::_hdlr_date( $ctx,
        { ts => $start, 'format' => "%Y" } );
    my $lang = lc MT->current_language || 'en_us';
    $lang = 'ja' if lc($lang) eq 'jp';
    my $cat = _display_category($ctx);

    sprintf( "%s%s%s", $cat, $year, ( $lang eq 'ja' ? '&#24180;' : '' ) );
}

sub cat_yearly_group_iter {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $cat_order = $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc'                 : 'desc';
    my $limit = exists $args->{lastn}       ? delete $args->{lastn} : undef;
    my $tmpl  = $ctx->stash('template');
    my $cat   = $ctx->stash('archive_category') || $ctx->stash('category');
    my @data  = ();
    my $count = 0;

    require MT::Placement;
    require MT::Entry;
    my $loop_sub = sub {
        my $c          = shift;
        my $entry_iter = MT::Entry->count_group_by(
            {
                blog_id => $blog->id,
                status  => MT::Entry::RELEASE()
            },
            {
                group => ["extract(year from authored_on)"],
                sort  => "extract(year from authored_on) $order",
                'join' =>
                  [ 'MT::Placement', 'entry_id', { category_id => $c->id } ]
            }
        ) or return $ctx->error("Couldn't get yearly archive list");
        while ( my @row = $entry_iter->() ) {
            my $hash = {
                year     => $row[1],
                category => $c,
                count    => $row[0],
            };
            push( @data, $hash );
            return $count + 1
              if ( defined($limit) && ( $count + 1 ) == $limit );
            $count++;
        }
    };

    if ($cat) {
        $loop_sub->($cat);
    }
    else {
        require MT::Category;
        my $iter = MT::Category->load_iter( { blog_id => $blog->id },
            { 'sort' => 'label', direction => $cat_order } );
        while ( my $category = $iter->() ) {
            $loop_sub->($category);
            last if ( defined($limit) && $count == $limit );
        }
    }

    my $loop = @data;
    my $curr = 0;

    return sub {
        if ( $curr < $loop ) {
            my $date =
              sprintf( "%04d%02d%02d000000", $data[$curr]->{year}, 1, 1 );
            my ( $start, $end ) = start_end_year($date);
            my $count = $data[$curr]->{count};
            my %hash  = (
                category => $data[$curr]->{category},
                year     => $data[$curr]->{year},
                start    => $start,
                end      => $end,
            );
            $curr++;
            return ( $count, %hash );
        }
        undef;
      }
}

sub cat_yearly_group_entries {
    my ( $ctx, %param ) = @_;

    my $ts =
      %param
      ? sprintf( "%04d%02d%02d000000", $param{year}, 1, 1 )
      : $ctx->stash('current_timestamp');
    my $cat = %param ? $param{category} : $ctx->stash('archive_category');

    date_based_category_entries( $ctx, 'Category-Yearly', $cat, $ts );
}

sub cat_yearly_entries_count {
    my ( $blog, $at, $entry ) = @_;
    my $cat = $entry->category;
    return 0 unless $cat;
    return _archive_entries_count(
        {
            Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $entry->authored_on,
            Category    => $cat
        }
    );
}

sub cat_monthly_archive_label {
    MT->translate('CATEGORY-MONTHLY_ADV');
}

sub cat_monthly_archive_file {
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};
    my $cat       = $ctx->{__stash}{cat} || $ctx->{__stash}{category};
    my $entry     = $ctx->{__stash}{entry};
    my $file;

    my $this_cat = $cat ? $cat : ( $entry ? $entry->category : undef );
    if ($file_tmpl) {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} ) =
          start_end_month( $timestamp, $blog );
        $ctx->stash( 'archive_category', $this_cat );
        $ctx->{inside_mt_categories} = 1;
        $ctx->{__stash}{category} = $this_cat;
    }
    else {
        if ( !$this_cat ) {
            return "";
        }
        my $label = '';
        $label = dirify( $this_cat->label );
        if ( $label !~ /\w/ ) {
            $label = $this_cat ? "cat" . $this_cat->id : "";
        }
        my $start = start_end_month( $timestamp, $blog );
        my ( $year, $month ) = unpack 'A4A2', $start;
        $file = sprintf( "%s/%04d/%02d/index",
            $this_cat->category_path, $year, $month );
    }
    $file;
}

sub cat_monthly_date_range { start_end_month(@_) }

sub cat_monthly_archive_title {
    my ( $ctx, $entry_or_ts ) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_month( $stamp, $ctx->stash('blog') );
    my $date =
      MT::Template::Context::_hdlr_date( $ctx,
        { ts => $start, 'format' => "%B %Y" } );
    my $cat = _display_category($ctx);

    sprintf( "%s%s", $cat, $date );
}

sub cat_monthly_group_iter {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $cat_order = $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc'                 : 'desc';
    my $limit = exists $args->{lastn}       ? delete $args->{lastn} : undef;
    my $tmpl  = $ctx->stash('template');
    my $cat   = $ctx->stash('archive_category') || $ctx->stash('category');
    my @data  = ();
    my $count = 0;
    my $ts    = $ctx->{current_timestamp};
    my $tsend = $ctx->{current_timestamp_end};

    require MT::Placement;
    require MT::Entry;
    my $loop_sub = sub {
        my $c          = shift;
        my $entry_iter = MT::Entry->count_group_by(
            {
                blog_id => $blog->id,
                status  => MT::Entry::RELEASE(),
                ( $ts && $tsend ? ( authored_on => [ $ts, $tsend ] ) : () ),
            },
            {
                ( $ts && $tsend ? ( range_incl => { authored_on => 1 } ) : () ),
                group => [
                    "extract(year from authored_on)",
                    "extract(month from authored_on)"
                ],
                sort => "extract(year from authored_on) $order,
                              extract(month from authored_on) $order",
                'join' =>
                  [ 'MT::Placement', 'entry_id', { category_id => $c->id } ]
            }
        ) or return $ctx->error("Couldn't get yearly archive list");
        while ( my @row = $entry_iter->() ) {
            my $hash = {
                year     => $row[1],
                month    => $row[2],
                category => $c,
                count    => $row[0],
            };
            push( @data, $hash );
            return $count + 1
              if ( defined($limit) && ( $count + 1 ) == $limit );
            $count++;
        }
    };

    if ($cat) {
        $loop_sub->($cat);
    }
    else {
        require MT::Category;
        my $iter = MT::Category->load_iter( { blog_id => $blog->id },
            { 'sort' => 'label', direction => $cat_order } );
        while ( my $category = $iter->() ) {
            $loop_sub->($category);
            last if ( defined($limit) && $count == $limit );
        }
    }

    my $loop = @data;
    my $curr = 0;

    return sub {
        if ( $curr < $loop ) {
            my $date = sprintf(
                "%04d%02d%02d000000",
                $data[$curr]->{year},
                $data[$curr]->{month}, 1
            );
            my ( $start, $end ) = start_end_month($date);
            my $count = $data[$curr]->{count};
            my %hash  = (
                category => $data[$curr]->{category},
                year     => $data[$curr]->{year},
                month    => $data[$curr]->{month},
                start    => $start,
                end      => $end,
            );
            $curr++;
            return ( $count, %hash );
        }
        undef;
      }
}

sub cat_monthly_group_entries {
    my ( $ctx, %param ) = @_;

    my $ts =
      %param
      ? sprintf( "%04d%02d%02d000000", $param{year}, $param{month}, 1 )
      : $ctx->stash('current_timestamp');
    my $cat = %param ? $param{category} : $ctx->stash('archive_category');

    date_based_category_entries( $ctx, 'Category-Monthly', $cat, $ts );
}

sub cat_monthly_entries_count {
    my ( $blog, $at, $entry ) = @_;
    my $cat = $entry->category;
    return 0 unless $cat;
    return _archive_entries_count(
        {
            Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $entry->authored_on,
            Category    => $cat
        }
    );
}

sub cat_daily_archive_label {
    MT->translate('CATEGORY-DAILY_ADV');
}

sub cat_daily_archive_file {
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};
    my $cat       = $ctx->{__stash}{cat} || $ctx->{__stash}{category};
    my $entry     = $ctx->{__stash}{entry};
    my $file;

    my $this_cat = $cat ? $cat : ( $entry ? $entry->category : undef );
    if ($file_tmpl) {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} ) =
          start_end_day( $timestamp, $blog );
        $ctx->stash( 'archive_category', $this_cat );
        $ctx->{inside_mt_categories} = 1;
        $ctx->{__stash}{category} = $this_cat;
    }
    else {
        if ( !$this_cat ) {
            return "";
        }
        my $label = '';
        $label = dirify( $this_cat->label );
        if ( $label !~ /\w/ ) {
            $label = $this_cat ? "cat" . $this_cat->id : "";
        }
        my $start = start_end_day( $timestamp, $blog );
        my ( $year, $month, $day ) = unpack 'A4A2A2', $start;
        $file = sprintf( "%s/%04d/%02d/%02d/index",
            $this_cat->category_path, $year, $month, $day );
    }
    $file;
}

sub cat_daily_date_range { start_end_day(@_) }

sub cat_daily_archive_title {
    my ( $ctx, $entry_or_ts ) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my $start = start_end_day( $stamp, $ctx->stash('blog') );
    my $date =
      MT::Template::Context::_hdlr_date( $ctx,
        { ts => $start, 'format' => "%x" } );
    my $cat = _display_category($ctx);

    sprintf( "%s%s", $cat, $date );
}

sub cat_daily_group_iter {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $cat_order = $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc'                 : 'desc';
    my $limit = exists $args->{lastn}       ? delete $args->{lastn} : undef;
    my $tmpl  = $ctx->stash('template');
    my $cat   = $ctx->stash('archive_category') || $ctx->stash('category');
    my @data  = ();
    my $count = 0;
    my $ts    = $ctx->{current_timestamp};
    my $tsend = $ctx->{current_timestamp_end};

    require MT::Placement;
    require MT::Entry;
    my $loop_sub = sub {
        my $c          = shift;
        my $entry_iter = MT::Entry->count_group_by(
            {
                blog_id => $blog->id,
                status  => MT::Entry::RELEASE(),
                ( $ts && $tsend ? ( authored_on => [ $ts, $tsend ] ) : () ),
            },
            {
                ( $ts && $tsend ? ( range_incl => { authored_on => 1 } ) : () ),
                group => [
                    "extract(year from authored_on)",
                    "extract(month from authored_on)",
                    "extract(day from authored_on)"
                ],
                sort => "extract(year from authored_on) $order,
                              extract(month from authored_on) $order,
                              extract(day from authored_on) $order",
                'join' =>
                  [ 'MT::Placement', 'entry_id', { category_id => $c->id } ]
            }
        ) or return $ctx->error("Couldn't get yearly archive list");
        while ( my @row = $entry_iter->() ) {
            my $hash = {
                year     => $row[1],
                month    => $row[2],
                day      => $row[3],
                category => $c,
                count    => $row[0],
            };
            push( @data, $hash );
            return $count + 1
              if ( defined($limit) && ( $count + 1 ) == $limit );
            $count++;
        }
    };

    if ($cat) {
        $loop_sub->($cat);
    }
    else {
        require MT::Category;
        my $iter = MT::Category->load_iter( { blog_id => $blog->id },
            { 'sort' => 'label', direction => $cat_order } );
        while ( my $category = $iter->() ) {
            $loop_sub->($category);
            last if ( defined($limit) && $count == $limit );
        }
    }

    my $loop = @data;
    my $curr = 0;

    return sub {
        if ( $curr < $loop ) {
            my $date = sprintf(
                "%04d%02d%02d000000",
                $data[$curr]->{year},
                $data[$curr]->{month},
                $data[$curr]->{day}
            );
            my ( $start, $end ) = start_end_day($date);
            my $count = $data[$curr]->{count};
            my %hash  = (
                category => $data[$curr]->{category},
                year     => $data[$curr]->{year},
                month    => $data[$curr]->{month},
                day      => $data[$curr]->{day},
                start    => $start,
                end      => $end,
            );
            $curr++;
            return ( $count, %hash );
        }
        undef;
      }
}

sub cat_daily_group_entries {
    my ( $ctx, %param ) = @_;

    my $ts =
      %param
      ? sprintf( "%04d%02d%02d000000", $param{year}, $param{month},
        $param{day} )
      : $ctx->stash('current_timestamp');
    my $cat = %param ? $param{category} : $ctx->stash('archive_category');

    date_based_category_entries( $ctx, 'Category-Daily', $cat, $ts );
}

sub cat_daily_entries_count {
    my ( $blog, $at, $entry ) = @_;
    my $cat = $entry->category;
    return 0 unless $cat;
    return _archive_entries_count(
        {
            Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $entry->authored_on,
            Category    => $cat
        }
    );
}

sub cat_weekly_archive_label {
    MT->translate('CATEGORY-WEEKLY_ADV');
}

sub cat_weekly_archive_file {
    my ( $ctx, %param ) = @_;
    my $timestamp = $param{Timestamp};
    my $file_tmpl = $param{Template};
    my $blog      = $ctx->{__stash}{blog};
    my $cat       = $ctx->{__stash}{cat} || $ctx->{__stash}{category};
    my $entry     = $ctx->{__stash}{entry};
    my $file;

    my $this_cat = $cat ? $cat : ( $entry ? $entry->category : undef );
    if ($file_tmpl) {
        ( $ctx->{current_timestamp}, $ctx->{current_timestamp_end} ) =
          start_end_week( $timestamp, $blog );
        $ctx->stash( 'archive_category', $this_cat );
        $ctx->{inside_mt_categories} = 1;
        $ctx->{__stash}{category} = $this_cat;
    }
    else {
        if ( !$this_cat ) {
            return "";
        }
        my $label = '';
        $label = dirify( $this_cat->label );
        if ( $label !~ /\w/ ) {
            $label = $this_cat ? "cat" . $this_cat->id : "";
        }
        my $start = start_end_week( $timestamp, $blog );
        my ( $year, $month, $day ) = unpack 'A4A2A2', $start;
        $file = sprintf( "%s/%04d/%02d/%02d-week/index",
            $this_cat->category_path, $year, $month, $day );
    }
    $file;
}

sub cat_weekly_date_range { start_end_week(@_) }

sub cat_weekly_archive_title {
    my ( $ctx, $entry_or_ts ) = @_;
    my $stamp = ref $entry_or_ts ? $entry_or_ts->authored_on : $entry_or_ts;
    my ( $start, $end ) = start_end_week( $stamp, $ctx->stash('blog') );
    my $start_date =
      MT::Template::Context::_hdlr_date( $ctx,
        { ts => $start, 'format' => "%x" } );
    my $end_date =
      MT::Template::Context::_hdlr_date( $ctx,
        { ts => $end, 'format' => "%x" } );
    my $cat = _display_category($ctx);

    sprintf( "%s%s - %s", $cat, $start_date, $end_date );
}

sub cat_weekly_group_iter {
    my ( $ctx, $args ) = @_;
    my $blog = $ctx->stash('blog');
    my $sort_order =
      ( $args->{sort_order} || '' ) eq 'ascend' ? 'ascend' : 'descend';
    my $cat_order = $args->{sort_order} ? $args->{sort_order} : 'ascend';
    my $order = ( $sort_order eq 'ascend' ) ? 'asc'                 : 'desc';
    my $limit = exists $args->{lastn}       ? delete $args->{lastn} : undef;
    my $tmpl  = $ctx->stash('template');
    my $cat   = $ctx->stash('archive_category') || $ctx->stash('category');
    my @data  = ();
    my $count = 0;
    my $ts    = $ctx->{current_timestamp};
    my $tsend = $ctx->{current_timestamp_end};

    require MT::Placement;
    require MT::Entry;
    my $loop_sub = sub {
        my $c          = shift;
        my $entry_iter = MT::Entry->count_group_by(
            {
                blog_id => $blog->id,
                status  => MT::Entry::RELEASE(),
                ( $ts && $tsend ? ( authored_on => [ $ts, $tsend ] ) : () ),
            },
            {
                ( $ts && $tsend ? ( range_incl => { authored_on => 1 } ) : () ),
                group => ["week_number"],
                sort  => "week_number $order",
                'join' =>
                  [ 'MT::Placement', 'entry_id', { category_id => $c->id } ]
            }
        ) or return $ctx->error("Couldn't get weekly archive list");
        while ( my @row = $entry_iter->() ) {
            my ( $year, $week ) = unpack 'A4A2', $row[1];
            my $hash = {
                year     => $year,
                week     => $week,
                category => $c,
                count    => $row[0],
            };
            push( @data, $hash );
            return $count + 1
              if ( defined($limit) && ( $count + 1 ) == $limit );
            $count++;
        }
    };

    if ($cat) {
        $loop_sub->($cat);
    }
    else {
        require MT::Category;
        my $iter = MT::Category->load_iter( { blog_id => $blog->id },
            { 'sort' => 'label', direction => $cat_order } );
        while ( my $category = $iter->() ) {
            $loop_sub->($category);
            last if ( defined($limit) && $count == $limit );
        }
    }

    my $loop = @data;
    my $curr = 0;

    return sub {
        if ( ($curr) < $loop ) {
            my $date = sprintf( "%04d%02d%02d000000",
                week2ymd( $data[$curr]->{year}, $data[$curr]->{week} ) );
            my ( $start, $end ) = start_end_week($date);
            my $count = $data[$curr]->{count};
            my %hash  = (
                category => $data[$curr]->{category},
                year     => $data[$curr]->{year},
                week     => $data[$curr]->{week},
                start    => $start,
                end      => $end,
            );
            $curr++;
            return ( $count, %hash );
        }
        undef;
      }
}

sub cat_weekly_group_entries {
    my ( $ctx, %param ) = @_;
    my $ts =
      %param
      ? sprintf( "%04d%02d%02d000000", week2ymd( $param{year}, $param{week} ) )
      : $ctx->stash('current_timestamp');
    my $cat = %param ? $param{category} : $ctx->stash('archive_category');

    date_based_category_entries( $ctx, 'Category-Weekly', $cat, $ts );
}

sub cat_weekly_entries_count {
    my ( $blog, $at, $entry ) = @_;
    my $cat = $entry->category;
    return 0 unless $cat;
    return _archive_entries_count(
        {
            Blog        => $blog,
            ArchiveType => $at,
            Timestamp   => $entry->authored_on,
            Category    => $cat
        }
    );
}

sub date_based_category_entries {
    my ( $ctx, $at, $cat, $ts ) = @_;

    my $blog     = $ctx->stash('blog');
    my $archiver = MT->publisher->archiver($at);
    my ( $start, $end );
    if ($ts) {
        ( $start, $end ) = $archiver->date_range->($ts);
    }
    else {
        $start = $ctx->{current_timestamp};
        $end   = $ctx->{current_timestamp_end};
    }
    my @entries = MT::Entry->load(
        {
            blog_id     => $blog->id,
            status      => MT::Entry::RELEASE(),
            authored_on => [ $start, $end ]
        },
        {
            range => { authored_on => 1 },
            'join' =>
              [ 'MT::Placement', 'entry_id', { category_id => $cat->id } ],
            'sort' => 'authored_on',
            'direction' => 'descend',
        }
    ) or return $ctx->error("Couldn't get $at archive list");
    \@entries;
}

# ----- ARCHIVE TYPE -----
package MT::ArchiveType;

sub new {
    my $pkg  = shift;
    my $self = {@_};
    bless $self, $pkg;
}

sub _getset {
    my $self = shift;
    my $name = shift;

    @_ ? $self->{$name} = $_[0] : $self->{$name};
}

sub name                  { shift->_getset( 'name',                  @_ ) }
sub archive_group_iter    { shift->_getset( 'archive_group_iter',    @_ ) }
sub archive_group_entries { shift->_getset( 'archive_group_entries', @_ ) }
sub archive_entries_count { shift->_getset( 'archive_entries_count', @_ ) }
sub archive_file          { shift->_getset( 'archive_file',          @_ ) }
sub archive_title         { shift->_getset( 'archive_title',         @_ ) }
sub archive_label         { shift->_getset( 'archive_label',         @_ ) }
sub author_based          { shift->_getset( 'author_based',          @_ ) }
sub category_based        { shift->_getset( 'category_based',        @_ ) }
sub date_based            { shift->_getset( 'date_based',            @_ ) }
sub entry_based           { shift->_getset( 'entry_based',           @_ ) }
sub date_range            { shift->_getset( 'date_range',            @_ ) }

sub default_archive_templates {
    shift->_getset( 'default_archive_templates', @_ );
}
sub dynamic_template { shift->_getset( 'dynamic_template', @_ ) }
sub dynamic_support  { shift->_getset( 'dynamic_support',  @_ ) }
sub entry_class      { shift->_getset( 'entry_class',      @_ ) || 'entry' }
sub template_params { shift->_getset('template_params') }

1;

__END__

=head1 NAME

MT::WeblogPublisher - Express weblog templates and content into a specific URL structure

=head1 SYNOPSIS

    use MT::WeblogPublisher;
    my $pub = MT::WeblogPublisher->new;
    $pub->rebuild(Blog => $blog, ArchiveType => "Individual");

=head1 METHODS

=head2 MT::WeblogPublisher->new()

Return a new C<MT::WeblogPublisher>. Additionally, call
L<MT::ConfigMgr/instance> and set the I<NoTempFiles> and
I<PublishCommenterIcon> attributes, if not already set.

=head2 $mt->rebuild( %args )

Rebuilds your entire blog, indexes and archives; or some subset of your blog,
as specified in the arguments.

I<%args> can contain:

=over 4

=item * Blog

An I<MT::Blog> object corresponding to the blog that you would like to
rebuild.

Either this or C<BlogID> is required.

=item * BlogID

The ID of the blog that you would like to rebuild.

Either this or C<Blog> is required.

=item * ArchiveType

The archive type that you would like to rebuild. This should be one of
the following string values: C<Individual>, C<Daily>, C<Weekly>,
C<Monthly>, or C<Category>.

This argument is optional; if not provided, all archive types will be rebuilt.

=item * EntryCallback

A callback that will be called for each entry that is rebuilt. If provided,
the value should be a subroutine reference; the subroutine will be handed
the I<MT::Entry> object for the entry that is about to be rebuilt. You could
use this to keep a running log of which entry is being rebuilt, for example:

    $mt->rebuild(
              BlogID => $blog_id,
              EntryCallback => sub { print $_[0]->title, "\n" },
          );

Or to provide a status indicator:

    use MT::Entry;
    my $total = MT::Entry->count({ blog_id => $blog_id });
    my $i = 0;
    local $| = 1;
    $mt->rebuild(
              BlogID => $blog_id,
              EntryCallback => sub { printf "%d/%d\r", ++$i, $total },
          );
    print "\n";

This argument is optional; by default no callbacks are executed.

=item * NoIndexes

By default I<rebuild> will rebuild the index templates after rebuilding all
of the entries; if you do not want to rebuild the index templates, set the
value for this argument to a true value.

This argument is optional.

=item * Limit

Limit the number of entries to be rebuilt to the last C<N> entries in the
blog. For example, if you set this to C<20> and do not provide an offset (see
L<Offset>, below), the 20 most recent entries in the blog will be rebuilt.

This is only useful if you are rebuilding C<Individual> archives.

This argument is optional; by default all entries will be rebuilt.

=item * Offset

When used with C<Limit>, specifies the entry at which to start rebuilding
your individual entry archives. For example, if you set this to C<10>, and
set a C<Limit> of C<5> (see L<Limit>, above), entries 10-14 (inclusive) will
be rebuilt. The offset starts at C<0>, and the ordering is reverse
chronological.

This is only useful if you are rebuilding C<Individual> archives, and if you
are using C<Limit>.

This argument is optional; by default all entries will be rebuilt, starting
at the first entry.

=back

=head2 $mt->rebuild_entry( %args )

Rebuilds a particular entry in your blog (and its dependencies, if specified).

I<%args> can contain:

=over 4

=item * Entry

An I<MT::Entry> object corresponding to the object you would like to rebuild.

This argument is required.

=item * Blog

An I<MT::Blog> object corresponding to the blog to which the I<Entry> belongs.

This argument is optional; if not provided, the I<MT::Blog> object will be
loaded in I<rebuild_entry> from the I<$entry-E<gt>blog_id> column of the
I<MT::Entry> object passed in. If you already have the I<MT::Blog> object
loaded, however, it makes sense to pass it in yourself, as it will skip one
small step in I<rebuild_entry> (loading the object).

=item * BuildDependencies

Saving an entry can have effects on other entries; so after saving, it is
often necessary to rebuild other entries, to reflect the changes onto all
of the affected archive pages, indexes, etc.

If you supply this parameter with a true value, I<rebuild_indexes> will
rebuild: the archives for the next and previous entries, chronologically;
all of the index templates; the archives for the next and previous daily,
weekly, and monthly archives.

=item * Previous, Next, OldPrevious, OldNext

These values identify entries which may need to be updated now that
"this" entry has changed. When the authored_on field of an entry is
changed, its new neighbors (Previous and Next) need to be rebuilt as
well as its former neighbors (OldPrevious and OldNext).

=item * NoStatic

When this value is true, it acts as a hint to the rebuilding routine
that static output files need not be rebuilt; the "rebuild" operation
is just to update the bookkeeping that supports dynamic rebuilds.

=back

=head2 $mt->rebuild_file($blog, $archive_root, $map, $archive_type, $ctx, \%cond, $build_static, %specifier)

Method responsible for building a single archive page from a template and
writing it to the file management layer.

I<$blog> refers to the target weblog. I<$archive_root> is the target archive
path to publish the file. I<$map> is a L<MT::TemplateMap> object that
relates to publishing the file. I<$archive_type> is one of "Daily",
"Weekly", "Monthly", "Category" or "Individual". I<$ctx> is a handle to
the L<MT::Template::Context> object to use to build the file. I<\%cond>
is a hashref to conditional arguments used to drive the build process.
I<$build_static> is a boolean flag that controls whether static files are
created (otherwise, the records necessary for serving dynamic pages are
created and that is all).

I<%specifier> is a hash that uniquely identifies the specific instance
of the given archive type. That is, for a category archive page it
identifies the category; for a date-based archive page it identifies
which time period is covered by the page; for an individual archive it
identifies the entry. I<%specifier> should contain just one of these
keys:

=over 4

=item * Category

A category ID or L<MT::Category> instance of the category archive page to
be built.

=item * Entry

An entry ID or L<MT::Entry> instance of the entry archive page to be
built.

=item * StartDate

The starting timestamp of the date-based archive to be built.

=back

=head2 $mt->rebuild_indexes( %args )

Rebuilds all of the index templates in your blog, or just one, if you use
the I<Template> argument (below). Only rebuilds templates that are set to
be rebuilt automatically, unless you use the I<Force> (below).

I<%args> can contain:

=over 4

=item * Blog

An I<MT::Blog> object corresponding to the blog whose indexes you would like
to rebuild.

Either this or C<BlogID> is required.

=item * BlogID

The ID of the blog whose indexes you would like to rebuild.

Either this or C<Blog> is required.

=item * Template

An I<MT::Template> object specifying the index template to rebuild; if you use
this argument, I<only> this index template will be rebuilt.

Note that if the template that you specify here is set to not rebuild
automatically, you I<must> specify the I<Force> argument in order to force it
to be rebuilt.

=item * Force

A boolean flag specifying whether or not to rebuild index templates who have
been marked not to be rebuilt automatically.

The default is C<0> (do not rebuild such templates).

=back

=head2 $mt->trans_error

Call L<MT/translate>.

=head2 $mt->make_commenter_icon

Make sure there is a C<nav-commenters.gif> file under the blog I<site_path>.

=head2 $mt->remove_entry_archive_file(%param)

Delete the archive files for an entry based on the following
parameters.  One of a I<Blog>, I<Entry> or I<Category> are required.

=over 4

=item * Blog
=item * Entry
=item * Category
=item * ArchiveType (Default 'Individual')
=item * TemplateID

=back

=head2 $mt->rebuild_categories(%param)

Rebuild category archives based on the following parameters:

=over 4

=item * Blog
=item * BlogID
=item * Limit
=item * Offset
=item * Limit
=item * NoStatic

=back

=head2 $mt->publish_future_posts

Build and publish all scheduled entries with a I<authored_on> timestamp
that is less than the current time.

=head1 CALLBACKS

=over 4

=item BuildFileFilter

This filter is called when Movable Type wants to rebuild a file, but
before doing so. This gives plugins the chance to determine whether a
file should actually be rebuild in particular situations.

A BuildFileFilter callback routine is called as follows:

    sub build_file_filter($eh, %args)
    {
        ...
        return $boolean;
    }

As with other callback funcions, the first parameter is an
C<MT::ErrorHandler> object. This can be used by the callback to
propagate an error message to the surrounding context.

The C<%args> parameters identify the page to be built. See
L<MT::FileInfo> for more information on how a page is determined by
these parameters. Elements in C<%args> are as follows:

=over 4

=item C<Context>

Holds the template context that has been constructed for building (see
C<MT::Template::Context>).

=item C<ArchiveType> 

The archive type of the file, usually one of C<'Index'>,
C<'Individual'>, C<'Category'>, C<'Daily'>, C<'Monthly'>, or
C<'Weekly'>.

=item C<Templatemap>

An C<MT::TemplateMap> object; this singles out which template is being
built, and the filesystem path of the file to be written.

=item C<Blog>

The C<MT::Blog> object representing the blog whose pages are being
rebuilt.

=item C<Entry>

In the case of an individual archive page, this points to the
C<MT::Entry> object whose page is being rebuilt. In the case of an
archive page other than an individual page, this parameter is not
necessarily undefined. It is best to rely on the C<$at> parameter to
determine whether a single entry is on deck to be built.

=item C<PeriodStart> 

In the case of a date-based archive page, this is a timestamp at the
beginning of the period from which entries will be included on this
page, in Movable Type's standard 14-digit "timestamp" format. For
example, if the page is a Daily archive for April 17, 1796, this value
would be 17960417000000. If the page were a Monthly archive for March,
2003, C<$start> would be 20030301000000. Again, this parameter may be
defined even when the page on deck is not a date-based archive page.

=item C<Category>

In the case of a Category archive, this parameter identifies the
category which will be built on the page.

=item C<FileInfo>

If defined, an L<MT::FileInfo> object which contains information about the
file. See L<MT::FileInfo> for more information about what a C<MT::FileInfo>
contains. Chief amongst all the members of C<MT::FileInfo>, for these
purposes, will be the C<virtual> member. This is a boolean value which will be
false if a page was actually created on disk for this "page," and false if no
page was created (because the corresponding template is set to be
built dynamically).

It is possible for the FileInfo parameter to be undefined, namely if the blog has not been configured to publish anything dynamically, or if the
installation is using a data driver that does not support dynamic publishing.

=back

=item BuildPage

BuildPage callbacks are invoked just after a page has been built, but
before the content has been written to the file system.

    sub build_page($eh, %args)
    {
    }

The parameters given are include those sent to the BuildFileFilter callback.
In addition, the following parameters are also given:

=over 4

=item C<Content>

This is a scalar reference to the content that will eventually be
published.

=item C<BuildResult> / (or C<RawContent>, deprecated)

This is a scalar reference to the content originally produced by building
the page. This value is provided mainly for reference; modifications to it
will be ignored.

=back

=item BuildFile

BuildFile callbacks are invoked just after a file has been built.

    sub build_file($eh, %args)
    {
    }

Parameters in %args are as with BuildPage.

=back

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
