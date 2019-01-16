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

use MT;
use MT::Test;
use MT::Test::Permission;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

my $blog_id    = 1;
my $catset1_id = 1;
my $catset2_id = 2;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $foo = MT::Test::Permission->make_category(
            blog_id => $blog_id,
            label   => 'foo',
        );
        my $bar = MT::Test::Permission->make_category(
            blog_id => $blog_id,
            label   => 'bar',
        );
        my $baz = MT::Test::Permission->make_category(
            blog_id => $blog_id,
            label   => 'baz',
        );

        my $c123 = MT::Test::Permission->make_category(
            blog_id => $blog_id,
            parent  => $foo->id,
            label   => 'c123',
        );

        my $category_order
            = join( ',', map { $_->id } ( $foo, $c123, $bar, $baz ) );

        my $blog = MT->model('blog')->load($blog_id)
            or die MT->model('blog')->errstr;
        $blog->category_order($category_order);
        $blog->save or die $blog->errstr;

        my $catset1
            = MT::Test::Permission->make_category_set( blog_id => $blog_id );
        $catset1->id($catset1_id);
        $catset1->save or die $catset1->errstr;
        if ( $catset1->id != $catset1_id ) {
            die '$catset1->id is ' . ( $catset1->id || 'not set' );
        }

        my $abc = MT::Test::Permission->make_category(
            blog_id         => $blog_id,
            category_set_id => $catset1->id,
            label           => 'abc',
        );
        my $def = MT::Test::Permission->make_category(
            blog_id         => $blog_id,
            category_set_id => $catset1->id,
            label           => 'def',
        );
        my $ghi = MT::Test::Permission->make_category(
            blog_id         => $blog_id,
            category_set_id => $catset1->id,
            label           => 'ghi',
        );

        my $c456 = MT::Test::Permission->make_category(
            blog_id         => $blog_id,
            category_set_id => $catset1_id,
            parent          => $ghi->id,
            label           => 'c456',
        );

        my $catset1_order
            = join( ',', map { $_->id } ( $def, $abc, $c456, $ghi ) );
        $catset1->order($catset1_order);
        $catset1->save or die $catset1->errstr;

        my $catset2 = MT::Test::Permission->make_category_set(
            blog_id => $blog_id,
            name    => 'catset2',
        );
        $catset2->id($catset2_id);
        $catset2->save or die $catset2->errstr;
        if ( $catset2->id != $catset2_id ) {
            die '$catset2->id is ' . ( $catset2->id || 'not set' );
        }

        my $cat123 = MT::Test::Permission->make_category(
            blog_id         => $blog_id,
            category_set_id => $catset2->id,
            label           => '123',
        );
        my $cat456 = MT::Test::Permission->make_category(
            blog_id         => $blog_id,
            category_set_id => $catset2->id,
            label           => '456',
        );
        my $cat789 = MT::Test::Permission->make_category(
            blog_id         => $blog_id,
            category_set_id => $catset2->id,
            label           => '789',
        );

        my $catset2_order
            = join( ',', map { $_->id } ( $cat123, $cat456, $cat789 ) );
        $catset2->order($catset2_order);
        $catset2->save or die $catset2->errstr;
    }
);

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MTSubCategories category="foo"
--- template
<MTSubCategories category="foo"><MTCategoryLabel>
</MTSubCategories>
--- expected
c123

=== MTSubCategories category_set_id="1" category="ghi"
--- template
<MTSubCategories category_set_id="1" category="ghi"><MTCategoryLabel>
</MTSubCategories>
--- expected
c456

=== MTSubCategories category="foo" include_current="1"
--- template
<MTSubCategories category="foo" include_current="1"><MTCategoryLabel>
</MTSubCategories>
--- expected
foo

=== MTSubCategories category_set_id="1" category="ghi" include_current="1"
--- template
<MTSubCategories category_set_id="1" category="ghi" include_current="1"><MTCategoryLabel>
</MTSubCategories>
--- expected
ghi

=== MTSubCategories top="1"
--- template
<MTSubCategories top="1"><MTCategoryLabel>
</MTSubCategories>
--- expected
foo
bar
baz

=== MTSubCategories category_set_id="1" top="1"
--- template
<MTSubCategories category_set_id="1" top="1"><MTCategoryLabel>
</MTSubCategories>
--- expected
def
abc
ghi

=== MTSubCategories top="1" sort_by="label" sort_order="descend"
--- template
<MTSubCategories top="1" sort_by="label" sort_order="descend"><MTCategoryLabel>
</MTSubCategories>
--- expected
foo
baz
bar

=== MTSubCategories category_set_id="1" top="1" sort_by="label" sort_order="descend"
--- template
<MTSubCategories category_set_id="1" top="1" sort_by="label" sort_order="descend"><MTCategoryLabel>
</MTSubCategories>
--- expected
ghi
def
abc

=== MTSubCategories with category_set context
--- template
<MTCategorySets id="1"><MTSubCategories top="1"><MTCategoryLabel>
</MTSubCategories></MTCategorySets>
--- expected
def
abc
ghi

=== MTSubCategories with category_set context and category_set_id modifier
--- template
<MTCategorySets id="1"><MTSubCategories category_set_id="2" top="1"><MTCategoryLabel>
</MTSubCategories></MTCategorySets>
--- expected
123
456
789
