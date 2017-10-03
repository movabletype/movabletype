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

my $blog_id = 1;

my $foo = MT::Test::Permission->make_folder(
    blog_id => $blog_id,
    label   => 'foo',
);
my $bar = MT::Test::Permission->make_folder(
    blog_id => $blog_id,
    label   => 'bar',
);
my $baz = MT::Test::Permission->make_folder(
    blog_id => $blog_id,
    label   => 'baz',
);

my $folder_order = join( ',', map { $_->id } ( $foo, $bar, $baz ) );

my $blog = MT->model('blog')->load($blog_id) or die MT->model('blog')->errstr;
$blog->folder_order($folder_order);
$blog->save or die $blog->errstr;

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MTFolderNext
--- template
<MTSubFolders top="1"><MTFolderNext show_empty="1"><MTFolderLabel>
</MTFolderNext></MTSubFolders>
--- expected
bar
baz

