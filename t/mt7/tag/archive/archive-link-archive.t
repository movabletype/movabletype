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

=== mt:ArchiveLink
--- stash
{ entry => 'entry_author1_ruler_eraser', entry_category => 'cat_ruler', page => 'page_author1_coffee', cd => 'cd_same_apple_orange', dt_field => 'cf_same_date', cat_field => 'cf_same_catset_other_fruit', category => 'cat_orange' }
--- template
<mt:ArchiveLink>
--- expected_individual
http://narnia.na/2018/12/entry-author1-ruler-eraser.html
--- expected_page
http://narnia.na/folder-green-tea/folder-cola/folder-coffee/page-author1-coffee.html
--- expected_daily
http://narnia.na/2018/12/03/
--- expected_weekly
http://narnia.na/2018/12/02-week/
--- expected_monthly
http://narnia.na/2018/12/
--- expected_yearly
http://narnia.na/2018/
--- expected_author
http://narnia.na/author/author1/
--- expected_author_daily
http://narnia.na/author/author1/2018/12/03/
--- expected_author_weekly
http://narnia.na/author/author1/2018/12/02-week/
--- expected_author_monthly
http://narnia.na/author/author1/2018/12/
--- expected_author_yearly
http://narnia.na/author/author1/2018/
--- expected_category
http://narnia.na/cat-clip/cat-compass/cat-ruler/
--- expected_category_daily
http://narnia.na/cat-clip/cat-compass/cat-ruler/2018/12/03/
--- expected_category_weekly
http://narnia.na/cat-clip/cat-compass/cat-ruler/2018/12/02-week/
--- expected_category_monthly
http://narnia.na/cat-clip/cat-compass/cat-ruler/2018/12/
--- expected_category_yearly
http://narnia.na/cat-clip/cat-compass/cat-ruler/2018/
--- expected_contenttype
http://narnia.na/2019/09/[% cd_same_apple_orange_unique_id %].html
--- expected_contenttype_author
http://narnia.na/author/author1/
--- expected_contenttype_author_daily
http://narnia.na/author/author1/2019/09/26/
--- expected_contenttype_author_weekly
http://narnia.na/author/author1/2019/09/22-week/
--- expected_contenttype_author_monthly
http://narnia.na/author/author1/2019/09/
--- expected_contenttype_author_yearly
http://narnia.na/author/author1/2019/
--- expected_contenttype_category
http://narnia.na/cat-strawberry/cat-orange/
--- expected_php_todo_contenttype_category
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26155
--- expected_contenttype_category_daily
http://narnia.na/cat-strawberry/cat-orange/2019/09/26/
--- expected_contenttype_category_weekly
http://narnia.na/cat-strawberry/cat-orange/2019/09/22-week/
--- expected_contenttype_category_monthly
http://narnia.na/cat-strawberry/cat-orange/2019/09/
--- expected_contenttype_category_yearly
http://narnia.na/cat-strawberry/cat-orange/2019/
--- expected_contenttype_daily
http://narnia.na/2019/09/26/
--- expected_contenttype_weekly
http://narnia.na/2019/09/22-week/
--- expected_contenttype_monthly
http://narnia.na/2019/09/
--- expected_contenttype_yearly
http://narnia.na/2019/
