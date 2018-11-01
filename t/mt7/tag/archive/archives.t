#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => 2 * 31 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

my $vars = {};

sub var {
    for my $line (@_) {
        for my $key ( keys %{$vars} ) {
            my $replace = quotemeta "[% ${key} %]";
            my $value   = $vars->{$key};
            $line =~ s/$replace/$value/g;
        }
    }
    @_;
}

filters {
    archive_type => [qw( chomp )],
    template     => [qw( chomp )],
    expected     => [qw( chomp )],
};

$test_env->prepare_fixture('db');

my @archive_types = MT->publisher->archive_types;
my $archive_types = join ',', @archive_types;

my $template_params = {
    'Individual' => <<'PARAMS',
archive_class: entry-archive
archive_template: 1
entry_archive: 1
entry_template: 1
feedback_template: 1
PARAMS
    'Page' => <<'PARAMS',
archive_class: page-archive
archive_template: 1
feedback_template: 1
page_archive: 1
page_template: 1
PARAMS
    'Daily' => <<'PARAMS',
archive_class: datebased-daily-archive
archive_listing: 1
archive_template: 1
datebased_archive: 1
datebased_daily_archive: 1
datebased_only_archive: 1
PARAMS
    'Weekly' => <<'PARAMS',
archive_class: datebased-weekly-archive
archive_listing: 1
archive_template: 1
datebased_archive: 1
datebased_only_archive: 1
datebased_weekly_archive: 1
PARAMS
    'Monthly' => <<'PARAMS',
archive_class: datebased-monthly-archive
archive_listing: 1
archive_template: 1
datebased_archive: 1
datebased_monthly_archive: 1
datebased_only_archive: 1
PARAMS
    'Yearly' => <<'PARAMS',
archive_class: datebased-yearly-archive
archive_listing: 1
archive_template: 1
datebased_archive: 1
datebased_only_archive: 1
datebased_yearly_archive: 1
PARAMS
    'Author' => <<'PARAMS',
archive_class: author-archive
archive_listing: 1
archive_template: 1
author_archive: 1
author_based_archive: 1
PARAMS
    'Author-Daily' => <<'PARAMS',
archive_class: author-daily-archive
archive_listing: 1
archive_template: 1
author_based_archive: 1
author_daily_archive: 1
datebased_archive: 1
PARAMS
    'Author-Weekly' => <<'PARAMS',
archive_class: author-weekly-archive
archive_listing: 1
archive_template: 1
author_based_archive: 1
author_weekly_archive: 1
datebased_archive: 1
PARAMS
    'Author-Monthly' => <<'PARAMS',
archive_class: author-monthly-archive
archive_listing: 1
archive_template: 1
author_based_archive: 1
author_monthly_archive: 1
datebased_archive: 1
PARAMS
    'Author-Yearly' => <<'PARAMS',
archive_class: author-yearly-archive
archive_listing: 1
archive_template: 1
author_based_archive: 1
author_yearly_archive: 1
datebased_archive: 1
PARAMS
    'Category' => <<'PARAMS',
archive_class: category-archive
archive_listing: 1
archive_template: 1
category_archive: 1
category_based_archive: 1
PARAMS
    'Category-Daily' => <<'PARAMS',
archive_class: category-daily-archive
archive_listing: 1
archive_template: 1
category_based_archive: 1
category_daily_archive: 1
datebased_archive: 1
PARAMS
    'Category-Weekly' => <<'PARAMS',
archive_class: category-weekly-archive
archive_listing: 1
archive_template: 1
category_based_archive: 1
category_weekly_archive: 1
datebased_archive: 1
PARAMS
    'Category-Monthly' => <<'PARAMS',
archive_class: category-monthly-archive
archive_listing: 1
archive_template: 1
category_based_archive: 1
category_monthly_archive: 1
datebased_archive: 1
PARAMS
    'Category-Yearly' => <<'PARAMS',
archive_class: category-yearly-archive
archive_listing: 1
archive_template: 1
category_based_archive: 1
category_yearly_archive: 1
datebased_archive: 1
PARAMS
    'ContentType' => <<'PARAMS',
archive_class: contenttype-archive
archive_template: 1
contenttype_archive: 1
PARAMS
    'ContentType-Daily' => <<'PARAMS',
archive_class: contenttype-daily-archive
archive_listing: 1
archive_template: 1
contenttype_archive_listing: 1
datebased_archive: 1
datebased_daily_archive: 1
datebased_only_archive: 1
PARAMS
    'ContentType-Weekly' => <<'PARAMS',
archive_class: contenttype-weekly-archive
archive_listing: 1
archive_template: 1
contenttype_archive_listing: 1
datebased_archive: 1
datebased_only_archive: 1
datebased_weekly_archive: 1
PARAMS
    'ContentType-Monthly' => <<'PARAMS',
archive_class: contenttype-monthly-archive
archive_listing: 1
archive_template: 1
contenttype_archive_listing: 1
datebased_archive: 1
datebased_monthly_archive: 1
datebased_only_archive: 1
PARAMS
    'ContentType-Yearly' => <<'PARAMS',
archive_class: contenttype-yearly-archive
archive_listing: 1
archive_template: 1
contenttype_archive_listing: 1
datebased_archive: 1
datebased_only_archive: 1
datebased_yearly_archive: 1
PARAMS
    'ContentType-Author' => <<'PARAMS',
archive_class: contenttype-author-archive
archive_listing: 1
archive_template: 1
author_archive: 1
author_based_archive: 1
contenttype_archive_listing: 1
PARAMS
    'ContentType-Author-Daily' => <<'PARAMS',
archive_class: contenttype-author-daily-archive
archive_listing: 1
archive_template: 1
author_based_archive: 1
author_daily_archive: 1
contenttype_archive_listing: 1
datebased_archive: 1
PARAMS
    'ContentType-Author-Weekly' => <<'PARAMS',
archive_class: contenttype-author-weekly-archive
archive_listing: 1
archive_template: 1
author_based_archive: 1
author_weekly_archive: 1
contenttype_archive_listing: 1
datebased_archive: 1
PARAMS
    'ContentType-Author-Monthly' => <<'PARAMS',
archive_class: contenttype-author-monthly-archive
archive_listing: 1
archive_template: 1
author_based_archive: 1
author_monthly_archive: 1
contenttype_archive_listing: 1
datebased_archive: 1
PARAMS
    'ContentType-Author-Yearly' => <<'PARAMS',
archive_class: contenttype-author-yearly-archive
archive_listing: 1
archive_template: 1
author_based_archive: 1
author_yearly_archive: 1
contenttype_archive_listing: 1
datebased_archive: 1
PARAMS
    'ContentType-Category' => <<'PARAMS',
archive_class: contenttype-category-archive
archive_listing: 1
archive_template: 1
category_archive: 1
category_based_archive: 1
category_set_based_archive: 1
contenttype_archive_listing: 1
PARAMS
    'ContentType-Category-Daily' => <<'PARAMS',
archive_class: contenttype-category-daily-archive
archive_listing: 1
archive_template: 1
category_based_archive: 1
category_daily_archive: 1
category_set_based_archive: 1
contenttype_archive_listing: 1
datebased_archive: 1
PARAMS
    'ContentType-Category-Weekly' => <<'PARAMS',
archive_class: contenttype-category-weekly-archive
archive_listing: 1
archive_template: 1
category_based_archive: 1
category_set_based_archive: 1
category_weekly_archive: 1
contenttype_archive_listing: 1
datebased_archive: 1
PARAMS
    'ContentType-Category-Monthly' => <<'PARAMS',
archive_class: contenttype-category-monthly-archive
archive_listing: 1
archive_template: 1
category_based_archive: 1
category_monthly_archive: 1
category_set_based_archive: 1
contenttype_archive_listing: 1
datebased_archive: 1
PARAMS
    'ContentType-Category-Yearly' => <<'PARAMS',
archive_class: contenttype-category-yearly-archive
archive_listing: 1
archive_template: 1
category_based_archive: 1
category_set_based_archive: 1
category_yearly_archive: 1
contenttype_archive_listing: 1
datebased_archive: 1
PARAMS
};

foreach my $archive_type (@archive_types) {
    MT::Test::Tag->vars->{archive_type} = $archive_type;
    MT::Test::Tag->vars->{template_params}
        = $template_params->{$archive_type};
    chomp MT::Test::Tag->vars->{template_params};
    MT::Test::Tag->run_perl_tests(
        $blog_id,
        sub {
            my ( $ctx, $block ) = @_;
            my $site = $ctx->stash('blog');
            $site->archive_type(
                defined $block->archive_type
                ? $block->archive_type
                : $archive_types
            );
        },
    );
    MT::Test::Tag->run_php_tests(
        $blog_id,
        sub {
            my ($block) = @_;
            my $archive_type
                = defined $block->archive_type
                ? $block->archive_type
                : $archive_types;
            return <<"PHP";
\$site = \$db->fetch_blog(\$blog_id);
\$site->archive_type = "$archive_type";
\$site->save();
PHP
        },
    );
}

__END__

=== Some ArchiveTypes with type
--- skip
1
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26073
https://movabletype.atlassian.net/browse/MTC-26074
https://movabletype.atlassian.net/browse/MTC-26075
--- template
<mt:Archives type="[% archive_type %]">
<mt:ArchiveType>
***
<mt:loop name="template_params" sort_by="key"><mt:var name="__key__">: <mt:var name="__value__">
</mt:loop>
</mt:Archives>
--- expected
[% archive_type %]
***
[% template_params %]

=== Some ArchiveTypes with archive_type
--- template
<mt:Archives archive_type="[% archive_type %]">
<mt:ArchiveType>
</mt:Archives>
--- expected
[% archive_type %]

=== Empty with type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26065
--- archive_type

--- template
<mt:Archives type="[% archive_type %]">
<mt:ArchiveType>
</mt:Archives>
--- expected
[% archive_type %]

=== Empty with archive_type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26065
--- archive_type

--- template
<mt:Archives archive_type="[% archive_type %]">
<mt:ArchiveType>
</mt:Archives>
--- expected
[% archive_type %]

=== None with type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26065
--- archive_type
None
--- template
<mt:Archives type="[% archive_type %]">
<mt:ArchiveType>
</mt:Archives>
--- expected
[% archive_type %]

=== None with archive_type
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26065
--- archive_type
None
--- template
<mt:Archives archive_type="[% archive_type %]">
<mt:ArchiveType>
</mt:Archives>
--- expected
[% archive_type %]
