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

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

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

    my $page1 = MT::Test::Permission->make_page( blog_id => $blog_id, );
    my $page2 = MT::Test::Permission->make_page( blog_id => $blog_id, );
    my $page3 = MT::Test::Permission->make_page( blog_id => $blog_id, );

    MT::Test::Permission->make_placement(
        blog_id     => $blog_id,
        entry_id    => $page1->id,
        category_id => $foo->id,
    );

    MT::Test::Permission->make_placement(
        blog_id     => $blog_id,
        entry_id    => $page2->id,
        category_id => $bar->id,
    );

    MT::Test::Permission->make_placement(
        blog_id     => $blog_id,
        entry_id    => $page3->id,
        category_id => $baz->id,
    );
});

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MTFolderCount content_field_id="1"
--- template
<MTFolders show_empty="1" sort="label"><MTFolderLabel>:<MTFolderCount content_field_id="1">
</MTFolders>
--- expected
bar:1
baz:1
foo:1

=== MTFolderCount content_type_id="1"
--- template
<MTFolders show_empty="1" sort="label"><MTFolderLabel>:<MTFolderCount content_type_id="1">
</MTFolders>
--- expected
bar:1
baz:1
foo:1

