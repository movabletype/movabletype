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

my $category_set
    = MT::Test::Permission->make_category_set( blog_id => $blog_id );
$category_set->id($category_set_id);
$category_set->save or die $category_set->errstr;
if ( $category_set->id != $category_set_id ) {
    die 'category_set->id is ' . ( $category_set->id || 'not set' );
}

MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'abc',
);
MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'def',
);
MT::Test::Permission->make_category(
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
    label           => 'ghi',
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

