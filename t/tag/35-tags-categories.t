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

        MT::Test::Permission->make_category(
            blog_id => $blog_id,
            label   => 'foo',
        );
        MT::Test::Permission->make_category(
            blog_id => $blog_id,
            label   => 'bar',
        );
        MT::Test::Permission->make_category(
            blog_id => $blog_id,
            label   => 'baz',
        );

        my $catset1 = MT::Test::Permission->make_category_set(
            blog_id => $blog_id,
            name    => 'catset1',
        );
        $catset1->id($catset1_id);
        $catset1->save or die $catset1->errstr;
        if ( $catset1->id != $catset1_id ) {
            die '$catset1->id is ' . ( $catset1->id || 'not set' );
        }

        MT::Test::Permission->make_category(
            blog_id         => $blog_id,
            category_set_id => $catset1->id,
            label           => 'abc',
        );
        MT::Test::Permission->make_category(
            blog_id         => $blog_id,
            category_set_id => $catset1->id,
            label           => 'def',
        );
        MT::Test::Permission->make_category(
            blog_id         => $blog_id,
            category_set_id => $catset1->id,
            label           => 'ghi',
        );

        my $catset2 = MT::Test::Permission->make_category_set(
            blog_id => $blog_id,
            name    => 'catset2',
        );
        $catset2->id($catset2_id);
        $catset2->save or die $catset2->errstr;
        if ( $catset2->id != $catset2_id ) {
            die '$catset2->id is ' . ( $catset2->id || 'not set' );
        }

        MT::Test::Permission->make_category(
            blog_id         => $blog_id,
            category_set_id => $catset2->id,
            label           => '123',
        );
        MT::Test::Permission->make_category(
            blog_id         => $blog_id,
            category_set_id => $catset2->id,
            label           => '456',
        );
        MT::Test::Permission->make_category(
            blog_id         => $blog_id,
            category_set_id => $catset2->id,
            label           => '789',
        );
    }
);

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MTCategories
--- template
<MTCategories show_empty="1"><MTCategoryLabel>
</MTCategories>
--- expected
bar
baz
foo

=== MTCategories category_set_id="1"
--- template
<MTCategories category_set_id="1" show_empty="1"><MTCategoryLabel>
</MTCategories>
--- expected
abc
def
ghi

=== MTCategories with category_set context
--- template
<MTCategorySets id="1"><MTCategories show_empty="1"><MTCategoryLabel>
</MTCategories></MTCategorySets>
--- expected
abc
def
ghi

=== MTCategories with category_set context and category_set_id modifier
--- template
<MTCategorySets id="1"><MTCategories category_set_id="2" show_empty="1"><MTCategoryLabel>
</MTCategories></MTCategorySets>
--- expected
123
456
789
