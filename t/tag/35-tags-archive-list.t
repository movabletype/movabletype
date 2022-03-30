#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
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
my $app = MT->instance;

$test_env->prepare_fixture('db');

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

my $mt = MT->instance;

my $blog = MT::Blog->load($blog_id);
$blog->archive_type('Author');
$blog->save or die $blog->errstr;

my $author1 = MT::Test::Permission->make_author( name => 'author1' );
my $author2 = MT::Test::Permission->make_author( name => 'author2' );

my $role_author = MT->model('role')->load( { name => 'Author' } ) or die;
MT->model('association')->link( $blog, $role_author, $author1 );
MT->model('association')->link( $blog, $role_author, $author2 );

my $entry1 = MT::Test::Permission->make_entry(
    author_id => $author1->id,
    blog_id   => $blog_id,
);
my $entry2 = MT::Test::Permission->make_entry(
    author_id => $author2->id,
    blog_id   => $blog_id,
);

my $cat1 = MT::Test::Permission->make_category(
    blog_id => $blog_id,
    label   => 'cat1',
);
my $cat2 = MT::Test::Permission->make_category(
    blog_id => $blog_id,
    label   => 'cat2',
);

MT::Test::Permission->make_placement(
    blog_id     => $blog_id,
    entry_id    => $entry1->id,
    category_id => $cat1->id,
);
MT::Test::Permission->make_placement(
    blog_id     => $blog_id,
    entry_id    => $entry2->id,
    category_id => $cat2->id,
);

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MTArchiveList type="Author"
--- template
<MTArchiveList type="Author"><MTArchiveTitle>
</MTArchiveList>
--- expected
test1
test2

=== MTArchiveList type="Author" sort_order="ascend"
--- template
<MTArchiveList type="Author" sort_order="ascend"><MTArchiveTitle>
</MTArchiveList>
--- expected
test1
test2

=== MTArchiveList type="Author" sort_order="descend"
--- template
<MTArchiveList type="Author" sort_order="descend"><MTArchiveTitle>
</MTArchiveList>
--- expected
test2
test1

=== MTArchiveList type="Category"
--- template
<MTArchiveList type="Category"><MTArchiveTitle>
</MTArchiveList>
--- expected
cat1
cat2

=== MTArchiveList type="Category" sort_order="ascend"
--- template
<MTArchiveList type="Category" sort_order="ascend"><MTArchiveTitle>
</MTArchiveList>
--- expected
cat1
cat2

=== MTArchiveList type="Category" sort_order="descend"
--- template
<MTArchiveList type="Category" sort_order="descend"><MTArchiveTitle>
</MTArchiveList>
--- expected
cat2
cat1
