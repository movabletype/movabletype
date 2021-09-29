#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',  ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
    $ENV{MT_APP}    = 'MT::App::CMS';
}

use MT::Test::Tag;
plan tests => 2 * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;

$test_env->prepare_fixture('db');
MT::Test::Permission->make_entry(blog_id => 1, status => 2, author_id => 1) for (1..2);

MT::Test::Tag->run_perl_tests(1);
MT::Test::Tag->run_php_tests(1);

__END__

=== mt:AuthorEntriesCount
--- template
<mt:Authors site_ids="1"><mt:AuthorEntriesCount></mt:Authors>
--- expected
2
