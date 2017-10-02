use strict;
use warnings;

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

my $top = MT::Test::Permission->make_category(
    blog_id => $blog_id,
    label   => 'top',
);

my $foo = MT::Test::Permission->make_category(
    blog_id => $blog_id,
    parent  => $top->id,
    label   => 'foo',
);
my $bar = MT::Test::Permission->make_category(
    blog_id => $blog_id,
    parent  => $top->id,
    label   => 'bar',
);
my $baz = MT::Test::Permission->make_category(
    blog_id => $blog_id,
    parent  => $top->id,
    label   => 'baz',
);

my $abc = MT::Test::Permission->make_category(
    blog_id => $blog_id,
    parent  => $baz->id,
    label   => 'abc',
);
my $def = MT::Test::Permission->make_category(
    blog_id => $blog_id,
    parent  => $baz->id,
    label   => 'def',
);
my $ghi = MT::Test::Permission->make_category(
    blog_id => $blog_id,
    parent  => $baz->id,
    label   => 'ghi',
);

my $category_order = join( ',',
    map { $_->id } ( $top, $foo, $bar, $baz, $def, $abc, $ghi ) );
my $blog = MT->model('blog')->load($blog_id) or die MT->model('blog')->errstr;
$blog->category_order($category_order);
$blog->save or die $blog->errstr;

my $category_set
    = MT::Test::Permission->make_category_set( blog_id => $blog_id, );
$category_set->id($category_set_id);
$category_set->save or die $category_set->errstr;
if ( $category_set->id != $category_set_id ) {
    die 'category_set->id is ' . ( $category_set->id || 'not set' );
}

my $category_set_top = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'category_set_top',
);

my $category_set_foo = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    parent          => $category_set_top->id,
    category_set_id => $category_set->id,
    label           => 'category_set_foo',
);
my $category_set_bar = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    parent          => $category_set_top->id,
    category_set_id => $category_set->id,
    label           => 'category_set_bar',
);
my $category_set_baz = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    parent          => $category_set_top->id,
    category_set_id => $category_set->id,
    label           => 'category_set_baz',
);

my $category_set_abc = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    parent          => $category_set_baz->id,
    category_set_id => $category_set->id,
    label           => 'category_set_abc',
);
my $category_set_def = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    parent          => $category_set_baz->id,
    category_set_id => $category_set->id,
    label           => 'category_set_def',
);
my $category_set_ghi = MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    parent          => $category_set_baz->id,
    category_set_id => $category_set->id,
    label           => 'category_set_ghi',
);

my $category_set_order = join(
    ',',
    map { $_->id } (
        $category_set_top, $category_set_foo, $category_set_bar,
        $category_set_baz, $category_set_def, $category_set_abc,
        $category_set_ghi
    )
);
$category_set->order($category_set_order);
$category_set->save or die $category_set->errstr;

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MTSubCatsRecurse
--- template
<MTTopLevelCategories><MTCategoryLabel>
<MTSubCatsRecurse></MTTopLevelCategories>
--- expected
top
foo
bar
baz
def
abc
ghi

=== MTSubCatsRecurse
--- template
<MTTopLevelCategories category_set_id="1"><MTCategoryLabel>
<MTSubCatsRecurse></MTTopLevelCategories>
--- expected
category_set_top
category_set_foo
category_set_bar
category_set_baz
category_set_def
category_set_abc
category_set_ghi

