#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use utf8;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete      => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Test::Base;
use MT::Test::ArchiveType;

use MT;
my $app = MT->instance;

$test_env->prepare_fixture('archive_type');

filters {
    MT::Test::ArchiveType->filter_spec
};

my @ct_maps = grep { $_->archive_type =~ /^ContentType-(?:.*)Weekly/ }
    MT::Test::ArchiveType->template_maps;
MT::Test::ArchiveType->run_tests(@ct_maps);

done_testing;

__END__

=== MTArchiveList (cf_same_date, cf_same_catset_fruit)
--- stash
{
    cd             => 'cd_same_apple_orange',
    dt_field       => 'cf_same_date',
    cat_field      => 'cf_same_catset_fruit',
    category       => 'cat_apple',
    entry          => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page           => 'page_author1_coffee',
}
--- template
<MTArchiveList content_type="ct_with_same_catset"><MTArchiveDate>
</MTArchiveList>
--- expected_contenttype_author_weekly
September 20, 2020 12:00 AM
September 22, 2019 12:00 AM
--- expected_contenttype_category_weekly
September 20, 2020 12:00 AM
September 22, 2019 12:00 AM
--- expected_contenttype_weekly
September 26, 2021 12:00 AM
September 20, 2020 12:00 AM
September 22, 2019 12:00 AM

