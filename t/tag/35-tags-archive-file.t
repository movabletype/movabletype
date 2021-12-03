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
$blog->archive_type('Page');
$blog->save or die $blog->errstr;

my $page = MT::Test::Permission->make_page( blog_id => $blog_id );

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== MTArchiveFile
--- template
<MTArchiveList type="Page"><MTArchiveFile>
</MTArchiveList>
--- expected
watching_the_river_flow.html
