#!/usr/bin/perl

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

use MT;
use MT::Util qw( epoch2ts );
use MT::Test qw(:db);
use MT::Test::Permission;
my $app = MT->instance;

my $blog_id = 1;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

my $now = time;
my $today = epoch2ts( MT->model('blog')->load($blog_id), $now );
my $yesterday
    = epoch2ts( MT->model('blog')->load($blog_id), $now - 60 * 60 * 25 );

# Make test data
my $entry_today = MT::Test::Permission->make_entry(
    blog_id     => $blog_id,
    title       => "today's entry",
    authored_on => $today,
);
my $entry_yesterday = MT::Test::Permission->make_entry(
    blog_id     => $blog_id,
    title       => "yesterday's entry",
    authored_on => $yesterday,
);

my $entry_today_comment = MT::Test::Permission->make_comment(
    blog_id    => $blog_id,
    entry_id   => $entry_today->id,
    text       => "today comment",
    created_on => $today,
);

my $entry_yesterday_comment = MT::Test::Permission->make_comment(
    blog_id    => $blog_id,
    entry_id   => $entry_yesterday->id,
    text       => "yesterday comment",
    created_on => $yesterday,
);

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== lastn
--- template
<mt:Entries days="1" lastn="0"><mt:EntryTitle>
</mt:Entries>
--- expected
today's entry
=== recently_commented_on
--- template
<mt:Entries recently_commented_on="1" lastn="0"><mt:EntryTitle>
</mt:Entries>
--- expected
today's entry
