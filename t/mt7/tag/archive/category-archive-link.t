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
        DeleteFilesAtRebuild    => 1,
        RebuildAtDelete         => 1,
        MT_TEST_ARCHIVETYPE_PHP => 1,
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

=== Plain mt:CategoryArchiveLink without stash
--- template
<mt:CategoryArchiveLink>
--- expected_error
MTCategoryArchiveLink must be used in a category context

=== Plain mt:CategoryArchiveLink with stash
--- stash
{ cd => 'cd_same_apple_orange', dt_field => 'cf_same_date', cat_field => 'cf_same_catset_other_fruit', category => 'cat_orange' }
--- template
<mt:CategoryArchiveLink>
--- expected_error
MTCategoryArchiveLink must be used in a category context
--- expected
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

=== mt:CategoryArchiveLink with mt:Categories tag, without stash
--- template
<mt:Categories><mt:CategoryArchiveLink>
</mt:Categories>
--- expected
http://narnia.na/cat-clip/cat-compass/
http://narnia.na/cat-eraser/
http://narnia.na/cat-pencil/
http://narnia.na/cat-clip/cat-compass/cat-ruler/

=== mt:CategoryArchiveLink with mt:Categories tag and stash
--- stash
{ cd => 'cd_same_apple_orange', dt_field => 'cf_same_date', cat_field => 'cf_same_catset_other_fruit', category => 'cat_orange' }
--- template
<mt:Categories><mt:CategoryArchiveLink>
</mt:Categories>
--- expected
http://narnia.na/cat-clip/cat-compass/
http://narnia.na/cat-eraser/
http://narnia.na/cat-pencil/
http://narnia.na/cat-clip/cat-compass/cat-ruler/
--- expected_contenttype_category
--- expected_contenttype_category_daily
--- expected_contenttype_category_weekly
--- expected_contenttype_category_monthly
--- expected_contenttype_category_yearly

=== mt:CategoryArchiveLink with mt:CategorySets tag, without stash
--- template
<mt:CategorySets><mt:Categories><mt:CategoryArchiveLink></mt:Categories>
</mt:CategorySets>
--- expected
http://narnia.na/cat-clip/cat-compass/
http://narnia.na/cat-eraser/
http://narnia.na/cat-pencil/
http://narnia.na/cat-clip/cat-compass/cat-ruler/
--- expected_individual
--- expected_page
--- expected_daily
--- expected_weekly
--- expected_monthly
--- expected_yearly
--- expected_author
--- expected_author_daily
--- expected_author_weekly
--- expected_author_monthly
--- expected_author_yearly
--- expected_category
--- expected_category_daily
--- expected_category_weekly
--- expected_category_monthly
--- expected_category_yearly

=== mt:CategoryArchiveLink with mt:CategorySets tag and stash
--- stash
{ cd => 'cd_same_apple_orange', dt_field => 'cf_same_date', cat_field => 'cf_same_catset_other_fruit', category => 'cat_orange' }
--- template
<mt:CategorySets><mt:Categories><mt:CategoryArchiveLink></mt:Categories>
</mt:CategorySets>
--- expected
