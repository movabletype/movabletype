use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}


use lib qw( t/lib lib extlib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT::Test::Tag;
plan tests => 2 * blocks;

use MT;
use MT::Test qw( :db );
use MT::Test::Permission;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

my $blog_id         = 1;
my $category_set_id = 1;

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

my $category_order = join( ',', map { $_->id } ( $foo, $bar, $baz ) );

my $blog = MT->model('blog')->load($blog_id) or die MT->model('blog')->errstr;
$blog->category_order($category_order);
$blog->save or die $blog->errstr;

my $category_set
    = MT::Test::Permission->make_category_set( blog_id => $blog_id );
$category_set->id($category_set_id);
$category_set->save or die $category_set->errstr;
if ( $category_set->id != $category_set_id ) {
    die 'category_set->id is ' . ( $category_set->id || 'not set' );
}

my $abc = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'abc',
);
my $def = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'def',
);
my $ghi = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'ghi',
);

my $category_set_order
    = join( ',', map { $_->id } ( $def, $abc, $ghi ) );
$category_set->order($category_set_order);
$category_set->save or die $category_set->errstr;

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MTCategoryNext
--- template
<MTSubCategories top="1"><MTCategoryNext show_empty="1"><MTCategoryLabel>
</MTCategoryNext></MTSubCategories>
--- expected
bar
baz

=== MTCategoryNext with category_set_id = 1
--- template
<MTSubCategories category_set_id="1" top="1"><MTCategoryNext show_empty="1"><MTCategoryLabel>
</MTCategoryNext></MTSubCategories>
--- expected
abc
ghi

