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

plan tests => 2 * blocks;

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
