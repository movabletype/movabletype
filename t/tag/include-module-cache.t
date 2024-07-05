#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use Test::MockTime::HiRes qw(mock_time);
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
use MT::Memcached;
use MT::Test::Memcached;
use MT::Touch;

my $app = MT->instance;

$test_env->prepare_fixture('db');

my $blog = MT::Blog->load(1);
$blog->include_cache(1);
$blog->include_system('');
$blog->save;

my $template = MT::Test::Permission->make_template(
    blog_id          => $blog->id,
    type             => 'custom',
    name             => 'MyTemplate',
    text             => 'MODULE-CONTENT',
    include_with_ssi => 0,
);

MT::Test::Tag->vars->{no_php_memcached} = !MT::Test::PHP->supports_memcached;

_teardown();

mock_time {
    MT::Test::Tag->run_perl_tests(
        $blog->id,
        sub {
            my $block = $_[1];
            setup($block);
            MT::Memcached->cleanup;    # unset is_available flag so that cache driver can be switchable
        });
} time();

_teardown();

MT::Test::Tag->run_php_tests(
    $blog->id,
    sub {
        my $block = $_[0];
        setup($block);
        return;
    });

_teardown();

my ($i, $memd, $memd_server);

sub setup {
    my ($block, $perl) = @_;
    if (defined($block->reset_test_count)) {
        $i = 1;
        require MT::Cache::Negotiate;
        my $cache_driver = MT::Cache::Negotiate->new;
        $cache_driver->flush_all;
    }

    if (my $str = $block->template_module_cache_setting) {
        my $hash = eval($block->template_module_cache_setting);
        while (my ($key, $val) = each(%$hash)) {
            $template->$key($val);
        }
    }

    $template->text('MODULE-CONTENT' . $i++);
    $template->modified_by(1);    # make sure modified_on is set
    $template->save;
    sleep(1);                     # make sure cache get ttl is 1 second at least

    MT::Touch->touch($blog->id, $template->cache_expire_event) if defined($block->do_touch);
}

sub memcached_filter {
    my $val = shift;
    $val =~ s{MEMCACHED_SERVER}{$memd_server};
    return $val;
}

sub _teardown {
    $memd->stop if $memd;
    $memd        = MT::Test::Memcached->new or plan skip_all => "Memcached is not available";
    $memd_server = $memd->address;
    $i           = 1;

    # avoid Use of uninitialized value $ret in scalar chop at /usr/local/share/perl5/5.38/Cache/Memcached.pm line 872
    use Cache::Memcached;
    Cache::Memcached->new({ 'servers' => [$memd_server] })->set("dummy", "dummy");

    # reset for php test because perl mocktime overtake the real wall clock
    MT::Touch->touch($blog->id, ['entry', 'author']);
}

done_testing;

__DATA__

=== include module cache 1
--- reset_test_count
--- mt_config
{MemcachedServers => []]}
--- template_module_cache_setting
{cache_expire_type => undef}
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT1

=== include module cache 2
--- template
<mt:Include module="MyTemplate" cache="1">
--- expected
MODULE-CONTENT2

=== include module cache 3
--- template
<mt:Include module="MyTemplate" cache="1">
--- expected
MODULE-CONTENT2
--- expected_php_todo
MODULE-CONTENT2

=== include module cache 4
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT4

=== include module cache (cache_expire_type=2, type=entry) 1
--- reset_test_count
--- mt_config
{MemcachedServers => []}
--- template_module_cache_setting
{cache_expire_type => 2, cache_expire_event => 'entry'}
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT1

=== include module cache (cache_expire_type=2, type=entry) 2
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT1
--- expected_php_todo
MODULE-CONTENT1

=== include module cache (cache_expire_type=2, type=entry) 3
--- do_touch
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT3
--- expected_php_todo
MODULE-CONTENT3

=== include module cache (cache_expire_type=2, type=author) 1
--- reset_test_count
--- mt_config
{MemcachedServers => []}
--- template_module_cache_setting
{cache_expire_type => 2, cache_expire_event => 'author'}
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT1

=== include module cache (cache_expire_type=2, type=author) 2
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT1
--- expected_php_todo
MODULE-CONTENT1

=== include module cache (cache_expire_type=2, type=author) 3
--- do_touch
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT3
--- expected_php_todo
MODULE-CONTENT3

=== include module cache with memcached 1
--- reset_test_count
--- mt_config memcached_filter
{MemcachedServers => ['MEMCACHED_SERVER']}
--- template_module_cache_setting
{cache_expire_type => undef}
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT1

=== include module cache with memcached 2
--- skip_php
[% no_php_memcached %]
--- template
<mt:Include module="MyTemplate" cache="1">
--- expected
MODULE-CONTENT2

=== include module cache with memcached 3
--- skip_php
[% no_php_memcached %]
--- template
<mt:Include module="MyTemplate" cache="1">
--- expected
MODULE-CONTENT2

=== include module cache with memcached 4
--- skip_php
[% no_php_memcached %]
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT4
