#!/usr/bin/perl

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

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Tag;

my $app = MT->instance;

$test_env->prepare_fixture('db');


sub compress {
    my $d = shift;
    $d =~ s{[\x0d\x0a\s]}{ }g;
    $d =~ s{\s$}{};
    $d;
}

filters {
    template => [qw( compress )],
    expected => [qw( compress )],
};

MT::Test::Tag->run_perl_tests(1, \&_set_mapping_url_perl);
MT::Test::Tag->run_php_tests(1, \&_set_mapping_url_php);

sub _set_mapping_url_perl {
    my ($ctx, $block) = @_;
    $ctx->stash('limit',  2);
    $ctx->stash('offset', 2);
    $ctx->stash('count',  5);
}

sub _set_mapping_url_php {
    my ($block) = @_;
    return <<"PHP";
\$ctx->stash('__pager_limit', 2);
\$ctx->stash('__pager_offset', 2);
\$ctx->stash('__pager_total_count', 5);
PHP
}

done_testing;

__DATA__

=== test PagerBlock
--- template
left<mt:PagerBlock>
left<current><mt:IfCurrentPage><mt:PagerLink></mt:IfCurrentPage></current>
<prev><mt:IfPreviousResults><mt:PreviousLink></mt:IfPreviousResults></prev>
<more><mt:IfMoreResults><mt:NextLink></mt:IfMoreResults></more>
</mt:PagerBlock>
--- expected
left
left<current></current> <prev>limit=2&page=1</prev> <more>limit=2&page=3</more>
 left<current>limit=2&page=2</current> <prev>limit=2&page=1</prev> <more>limit=2&page=3</more>
 left<current></current> <prev>limit=2&page=1</prev> <more>limit=2&page=3</more>
--- expected_php
left
 left<current></current> <prev>?limit=2</prev> <more>?limit=2&offset=4</more>
  left<current>?limit=2&offset=2</current> <prev>?limit=2</prev> <more>?limit=2&offset=4</more>
  left<current></current> <prev>?limit=2</prev> <more>?limit=2&offset=4</more>

=== test PagerBlock
--- template
<mt:CurrentPage> / <mt:TotalPages>
--- expected
2 / 3
