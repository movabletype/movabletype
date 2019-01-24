#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use utf8;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DeleteFilesAtRebuild => 1,
        RebuildAtDelete => 1,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use Test::Base;
use MT::Test::ArchiveType;

use MT;
use MT::Test;
my $app = MT->instance;

$test_env->prepare_fixture('archive_type');

filters {
    MT::Test::ArchiveType->filter_spec
};

my @maps = grep {$_->archive_type =~ /ContentType\-Category\-/} MT::Test::ArchiveType->template_maps;

MT::Test::ArchiveType->run_tests(@maps);

done_testing;

__END__

=== MTC-26069
--- stash
{
    cd => 'cd_same_apple_orange',
    cat_field => 'cf_same_catset_fruit',
    category => 'cat_apple',
    entry => 'entry_author1_ruler_eraser',
    entry_category => 'cat_eraser',
    page => 'page_author1_coffee',
}
--- template
<mt:ArchiveList><mt:ArchiveTitle>
</mt:ArchiveList>
--- expected_contenttype_category_daily
October 31, 2018
October 31, 2017
--- expected_contenttype_category_monthly
October 2018
October 2017
--- expected_contenttype_category_weekly
October 28, 2018 - November  3, 2018
October 29, 2017 - November  4, 2017
--- expected_contenttype_category_yearly
2018
2017
