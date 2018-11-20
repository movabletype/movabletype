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
use MT::Test;
my $app = MT->instance;

$test_env->prepare_fixture('archive_type');

filters {
    MT::Test::ArchiveType->filter_spec
};

my $objs = MT::Test::Fixture::ArchiveType->load_objs;
for my $cd_label ( keys %{ $objs->{content_data} } ) {
    my $key = $cd_label . '_unique_id';
    my $cd  = $objs->{content_data}->{$cd_label};
    MT::Test::ArchiveType->vars->{$key} = $cd->unique_id;
}

MT::Test::ArchiveType->run_tests;

done_testing;

__END__

=== mt:ArchiveFile
--- stash
{ entry => 'entry_author1_ruler_eraser', page => 'page_author1_coffee', entry_category => 'cat_ruler', cd => 'cd_same_apple_orange', dt_field => 'cf_same_date', cat_field => 'cf_same_catset_other_fruit', category => 'cat_orange' }
--- template
<mt:ArchiveFile>
--- expected
index.html
--- expected_individual
entry_author1_ruler_eraser.html
--- expected_page
page_author1_coffee.html
--- expected_contenttype
[% cd_same_apple_orange_unique_id %].html
