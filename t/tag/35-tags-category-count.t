use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => (1 + 2) * blocks;

use MT::Test;
use MT::Test::Permission;

use MT::Entry;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

my $blog_id = 1;
$test_env->prepare_fixture('model/category_count');

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MTCategoryCount
--- template
<MTCategories category_set_id="1" show_empty="1" sort="label"><MTCategoryLabel>: <MTCategoryCount>
</MTCategories>
--- expected
a: 4
b: 2
c: 0

=== MTCategoryCount content_type="id"
--- template
<MTCategories category_set_id="1" show_empty="1" sort="label"><MTCategoryLabel>: <MTCategoryCount content_type="1">
</MTCategories>
--- expected
a: 2
b: 1
c: 0

=== MTCategoryCount content_field="id"
--- template
<MTCategories category_set_id="1" show_empty="1" sort="label"><MTCategoryLabel>: <MTCategoryCount content_field="1">
</MTCategories>
--- expected
a: 1
b: 1
c: 0

=== MTCategoryCount content_field_name="name"
--- template
<MTCategories category_set_id="1" show_empty="1" sort="label"><MTCategoryLabel>: <MTCategoryCount content_field="field0">
</MTCategories>
--- expected
a: 1
b: 1
c: 0

=== MTCategoryCount without show_empty
--- template
<MTCategories category_set_id="1"><mt:CategoryLabel>: <mt:CategoryCount>
</MTCategories>
--- expected
a: 4
b: 2

=== MTCategoryCount content_type="id" ct from context
--- template
<mt:Contents sort_by="id" sort_order="ascend">CT<mt:ContentID>:
<MTCategories category_set_id="1" show_empty="1" sort="label"><MTCategoryLabel>: <MTCategoryCount>
</MTCategories></mt:Contents>
--- expected
CT1:
a: 2
b: 1
c: 0
CT2:
a: 2
b: 1
c: 0
CT4:
a: 2
b: 1
c: 0
CT5:
a: 2
b: 1
c: 0
CT6:
a: 2
b: 1
c: 0
CT8:
a: 2
b: 1
c: 0

=== MTCategoryCount content_type="id" ct from context and content_type specified in numeric
--- template
<mt:Contents sort_by="id" sort_order="ascend">CT<mt:ContentID>:
<MTCategories category_set_id="1" show_empty="1" sort="label"><MTCategoryLabel>: <MTCategoryCount content_type="1">
</MTCategories></mt:Contents>
--- expected
CT1:
a: 2
b: 1
c: 0
CT2:
a: 2
b: 1
c: 0
CT4:
a: 2
b: 1
c: 0
CT5:
a: 2
b: 1
c: 0
CT6:
a: 2
b: 1
c: 0
CT8:
a: 2
b: 1
c: 0

=== MTCategoryCount content_type="id" ct from context and content_type specified in numeric
--- template
<mt:Contents sort_by="id" sort_order="ascend">CT<mt:ContentID>:
<MTCategories category_set_id="1" show_empty="1" sort="label"><MTCategoryLabel>: <MTCategoryCount content_type="1">
</MTCategories></mt:Contents>
--- expected
CT1:
a: 2
b: 1
c: 0
CT2:
a: 2
b: 1
c: 0
CT4:
a: 2
b: 1
c: 0
CT5:
a: 2
b: 1
c: 0
CT6:
a: 2
b: 1
c: 0
CT8:
a: 2
b: 1
c: 0

=== MTCategoryCount content_type="id" ct from context and content_type specified in non numeric
--- template
<mt:Contents sort_by="id" sort_order="ascend">CT<mt:ContentID>:
<MTCategories category_set_id="1" show_empty="1" sort="label"><MTCategoryLabel>: <MTCategoryCount content_type="ct2">
</MTCategories></mt:Contents>
--- expected
CT1:
a: 2
b: 1
c: 0
CT2:
a: 2
b: 1
c: 0
CT4:
a: 2
b: 1
c: 0
CT5:
a: 2
b: 1
c: 0
CT6:
a: 2
b: 1
c: 0
CT8:
a: 2
b: 1
c: 0
