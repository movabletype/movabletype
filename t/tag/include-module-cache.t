#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use File::Temp qw( tempfile );
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Tag;

my $app = MT->instance;

$test_env->prepare_fixture('db');

my $blog = MT::Blog->load(1);
$blog->include_cache(1);
$blog->save;

my $template = MT::Test::Permission->make_template(
    blog_id => $blog->id, type => 'custom', name => 'MyTemplate', text => 'MODULE-CONTENT');

my $i;

sub setup {
    $template->text('MODULE-CONTENT' . $i++);
    $template->save;
    return;
}

$i = 1;
MT::Test::Tag->run_perl_tests($blog->id, \&setup);
$i = 1;
MT::Test::Tag->run_php_tests($blog->id, \&setup);

done_testing;

__DATA__

=== include module cache
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT1

=== include module cache
--- template
<mt:Include module="MyTemplate" cache="1">
--- expected
MODULE-CONTENT2

=== include module cache
--- template
<mt:Include module="MyTemplate" cache="1">
--- expected
MODULE-CONTENT2
