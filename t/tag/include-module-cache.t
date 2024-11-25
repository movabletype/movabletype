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
use MT::Memcached;
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

my ($i, $memd);

for my $cache_driver ('session', 'memcached') {

    MT::Memcached->cleanup;    # unset is_available flag so that cache driver can be switchable
    my $memcached_servers;
    if ($cache_driver eq 'memcached') {
        next if $^O eq 'MSWin32';
        require MT::Test::Memcached;
        $memd              = MT::Test::Memcached->new;
        $memcached_servers = [$memd->address];
    } else {
        $memcached_servers = [];
    }
    MT->config('MemcachedServers', $memcached_servers);
    MT->config('MemcachedServers', $memcached_servers, 1);
    MT->config->save_config;

    subtest 'cache driver is right one' => sub {
        require MT::Cache::Negotiate;
        my $cache_driver = MT::Cache::Negotiate->new;
        my $driver       = $cache_driver->{__cache_driver};
        if (@$memcached_servers) {
            is(ref($driver), 'MT::Memcached', 'cache driver is memcached');
            $cache_driver->set('writable', 'working');
            is($cache_driver->get('writable'), 'working', 'mecached is working');
            ok(MT::Memcached->is_available, 'memcached is available');
        } else {
            is(ref($driver), 'MT::Cache::Session', 'cache driver is session');
        }
    };

    subtest $cache_driver => sub {
        MT::Test::Tag->run_perl_tests($blog->id, sub { setup($_[1]); });
    };

SKIP: {
        subtest $cache_driver => sub {
            plan skip_all => "PHP does not support memcached", 1 unless MT::Test::PHP->supports_memcached;
            MT::Test::Tag->run_php_tests($blog->id, sub { setup($_[0]); return; });
        };
    }
}

sub setup {
    my ($block) = @_;

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
    $template->modified_by(1) if defined($block->set_template_modified_on);
    $template->save;
    sleep(1);    # make sure cache get ttl is 1 second at least

    if (defined($block->do_touch)) {
        MT::Touch->touch($blog->id, $template->cache_expire_event);
        sleep(1);
    }
}

done_testing;

__DATA__

=== cache not enabled
--- reset_test_count
--- template_module_cache_setting
{cache_expire_type => undef}
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT1

=== set cache by attribute
--- template
<mt:Include module="MyTemplate" cache="1">
--- expected
MODULE-CONTENT2

=== get cache by attribute
--- template
<mt:Include module="MyTemplate" cache="1">
--- expected
MODULE-CONTENT2

=== cache is not used
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT4

=== make sure get cache again
--- template
<mt:Include module="MyTemplate" cache="1">
--- expected
MODULE-CONTENT2

=== cache expires by template modified_on
--- set_template_modified_on
--- template
<mt:Include module="MyTemplate" cache="1">
--- expected
MODULE-CONTENT6

=== with cache_expire_type=2, type=entry 1 set cache
--- reset_test_count
--- template_module_cache_setting
{cache_expire_type => 2, cache_expire_event => 'entry'}
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT1

=== with cache_expire_type=2, type=entry 2 get cache
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT1

=== with cache_expire_type=2, type=entry 3 cache expires by object touch
--- do_touch
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT3

=== with cache_expire_type=2, type=entry 4 get cache again
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT3

=== with cache_expire_type=2, type=entry 5 cache expires by template modified_on
--- set_template_modified_on
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT5

=== with cache_expire_type=2, type=author 1 set cache
--- reset_test_count
--- template_module_cache_setting
{cache_expire_type => 2, cache_expire_event => 'author'}
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT1

=== with cache_expire_type=2, type=author 2 get cache
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT1

=== with cache_expire_type=2, type=author 3 cache expires by object touch
--- do_touch
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT3
