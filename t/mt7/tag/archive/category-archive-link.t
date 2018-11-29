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

MT::Test::ArchiveType->run_tests;

done_testing;

__END__

=== mt:CategoryArchiveLink with stash
--- stash
{ entry => 'entry_author1_ruler_eraser', page => 'page_author1_coffee', cd => 'cd_same_apple_orange', dt_field => 'cf_same_date', cat_field => 'cf_same_catset_other_fruit', category => 'cat_orange' }
--- template
<mt:CategoryArchiveLink>
--- expected_error
MTCategoryArchiveLink must be used in a category context
--- expected_individual
http://narnia.na/cat-clip/cat-compass/cat-ruler/
--- expected_php_todo_page
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26151
--- expected_page
http://narnia.na/folder-green-tea/folder-cola/folder-coffee/
--- expected_category
http://narnia.na/cat-clip/cat-compass/cat-ruler/
--- expected_category_daily
http://narnia.na/cat-clip/cat-compass/cat-ruler/
--- expected_category_weekly
http://narnia.na/cat-clip/cat-compass/cat-ruler/
--- expected_category_monthly
http://narnia.na/cat-clip/cat-compass/cat-ruler/
--- expected_category_yearly
http://narnia.na/cat-clip/cat-compass/cat-ruler/
--- expected_php_todo_contenttype
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26152
--- expected_contenttype
http://narnia.na/cat-strawberry/cat-orange/
--- expected_php_todo_contenttype_author
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26153
--- expected_contenttype_author
http://narnia.na/cat-strawberry/cat-orange/
--- expected_php_todo_contenttype_author_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26153
--- expected_contenttype_author_daily
http://narnia.na/cat-strawberry/cat-orange/
--- expected_php_todo_contenttype_author_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26153
--- expected_contenttype_author_monthly
http://narnia.na/cat-strawberry/cat-orange/
--- expected_php_todo_contenttype_author_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26153
--- expected_contenttype_author_weekly
http://narnia.na/cat-strawberry/cat-orange/
--- expected_php_todo_contenttype_author_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26153
--- expected_contenttype_author_yearly
http://narnia.na/cat-strawberry/cat-orange/
--- expected_contenttype_category
http://narnia.na/cat-strawberry/cat-orange/
--- expected_contenttype_category_daily
http://narnia.na/cat-strawberry/cat-orange/
--- expected_contenttype_category_weekly
http://narnia.na/cat-strawberry/cat-orange/
--- expected_contenttype_category_monthly
http://narnia.na/cat-strawberry/cat-orange/
--- expected_contenttype_category_yearly
http://narnia.na/cat-strawberry/cat-orange/
--- expected_php_todo_contenttype_daily
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26153
--- expected_contenttype_daily
http://narnia.na/cat-strawberry/cat-orange/
--- expected_php_todo_contenttype_monthly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26153
--- expected_contenttype_monthly
http://narnia.na/cat-strawberry/cat-orange/
--- expected_php_todo_contenttype_weekly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26153
--- expected_contenttype_weekly
http://narnia.na/cat-strawberry/cat-orange/
--- expected_php_todo_contenttype_yearly
--- FIXME
https://movabletype.atlassian.net/browse/MTC-26153
--- expected_contenttype_yearly
http://narnia.na/cat-strawberry/cat-orange/
