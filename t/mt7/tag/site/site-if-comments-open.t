#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../lib"; # t/lib
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
    blog_id  => [qw( chomp )],
    template => [qw( chomp )],
    expected => [qw( chomp )],
    error    => [qw( chomp )],
};

sub _set_php_allow_comments {
    return <<'PHP';
$ctx->mt->config('AllowComments', 1);
PHP
}

MT->config->AllowComments(1);

$test_env->prepare_fixture('db_data');

MT::Test::Tag->run_perl_tests;
MT::Test::Tag->run_php_tests( undef, \&_set_php_allow_comments );

__END__

=== mt:SiteIfCommentsOpen - blog
--- blog_id
1
--- template
<mt:SiteIfCommentsOpen><mt:SiteID></mt:SiteIfCommentsOpen>
--- expected
1

=== mt:SiteIfCommentsOpen - website
--- blog_id
2
--- template
<mt:SiteIfCommentsOpen><mt:SiteID></mt:SiteIfCommentsOpen>
--- expected
2

