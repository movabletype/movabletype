#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::FailWarnings;
use MT::Test::Env;

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::ListProperty;

my $valid_msg  = 'blog_name bulk_sort valid';
my $alpha_msg  = 'blog_name bulk_sort alpha';
my $system_msg = 'blog_name bulk_sort system';
my $orphan_msg = 'blog_name bulk_sort orphan';

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $website = MT::Test::Permission->make_website(
        name => 'bulk_sort website',
    );
    my $blog = MT::Test::Permission->make_blog(
        name      => 'z bulk_sort blog',
        parent_id => $website->id,
    );
    my $alpha_blog = MT::Test::Permission->make_blog(
        name      => 'a bulk_sort blog',
        parent_id => $website->id,
    );

    MT::Test::Permission->make_log(
        blog_id => $blog->id,
        message => $valid_msg,
    );
    MT::Test::Permission->make_log(
        blog_id => $alpha_blog->id,
        message => $alpha_msg,
    );
    MT::Test::Permission->make_log(
        blog_id => 0,
        message => $system_msg,
    );
    MT::Test::Permission->make_log(
        blog_id => 99999999,
        message => $orphan_msg,
    );
});

my $mt = MT->new;
ok($mt, 'MT initializes');

MT->request->reset;
my $prop = MT::ListProperty->instance('log', 'blog_name');
ok($prop, 'blog_name list property is available for logs');

sub load_log_by_message {
    my ($message) = @_;
    my $log = MT->model('log')->load({ message => $message });
    ok($log, "loaded log: $message");
    return $log;
}

sub sort_key_for_log {
    my ($log) = @_;
    return '' unless $log && $log->blog_id;

    my $blog = MT->model('blog')->load($log->blog_id, { no_class => 1 });
    return $blog ? $blog->name : '';
}

subtest 'bulk_sort does not warn for undefined blog name cases' => sub {
    my $valid  = load_log_by_message($valid_msg);
    my $alpha  = load_log_by_message($alpha_msg);
    my $system = load_log_by_message($system_msg);
    my $orphan = load_log_by_message($orphan_msg);
    return unless $valid && $alpha && $system && $orphan;

    my @input  = ($valid, $system, $alpha, $orphan);
    my @sorted = $prop->bulk_sort(\@input);

    is_deeply(
        [map { sort_key_for_log($_) } @input],
        ['z bulk_sort blog', '', 'a bulk_sort blog', ''],
        'input order is intentionally unsorted',
    );
    is_deeply(
        [map { sort_key_for_log($_) } @sorted],
        ['', '', 'a bulk_sort blog', 'z bulk_sort blog'],
        'bulk_sort sorts logs by blog name',
    );
};

done_testing;
