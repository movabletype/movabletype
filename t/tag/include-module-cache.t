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
use MT::Memcached;
use MT::Test::Memcached;

my $app = MT->instance;

$test_env->prepare_fixture('db');

my $blog = MT::Blog->load(1);
$blog->include_cache(1);
$blog->save;

my $template = MT::Test::Permission->make_template(
    blog_id => $blog->id,
    type    => 'custom',
    name    => 'MyTemplate',
    text    => 'MODULE-CONTENT'
);

MT::Test::Tag->vars->{no_php_memcached} = !MT::Test::PHP->supports_memcached;

_teardown();
MT::Test::Tag->run_perl_tests($blog->id, sub { setup(1) });
_teardown();
MT::Test::Tag->run_php_tests($blog->id, sub { setup() });
_teardown();

my ($i, $memd, $memd_server);

sub setup {
    my $perl = shift;
    $template->text('MODULE-CONTENT' . $i++);
    $template->save;
    MT::Memcached->cleanup if $perl;    # unset is_available flag so that cache driver can be switchable
    sleep(1) unless $perl;              # workaround for fragile memcached test
    return;
}

sub memcached_filter {
    my $val = shift;
    $val =~ s{MEMCACHED_SERVER}{$memd_server};
    return $val;
}

sub _teardown {
    $memd->stop if $memd;
    $memd = MT::Test::Memcached->new or plan skip_all => "Memcached is not available";
    $memd_server = $memd->address;
    $i = 1;
}

done_testing;

__DATA__

=== include module cache 1
--- mt_config
{MemcachedServers => []}
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT1

=== include module cache 2
--- mt_config
{MemcachedServers => []}
--- template
<mt:Include module="MyTemplate" cache="1">
--- expected
MODULE-CONTENT2

=== include module cache 3
--- mt_config
{MemcachedServers => []}
--- template
<mt:Include module="MyTemplate" cache="1">
--- expected
MODULE-CONTENT2

=== include module cache with memcached 1
--- mt_config memcached_filter
{MemcachedServers => 'MEMCACHED_SERVER'}
--- template
<mt:Include module="MyTemplate">
--- expected
MODULE-CONTENT4

=== include module cache with memcached 2
--- skip_php
[% no_php_memcached %]
--- mt_config memcached_filter
{MemcachedServers => 'MEMCACHED_SERVER'}
--- template
<mt:Include module="MyTemplate" cache="1">
--- expected
MODULE-CONTENT5

=== include module cache with memcached 3
--- skip_php
[% no_php_memcached %]
--- mt_config memcached_filter
{MemcachedServers => 'MEMCACHED_SERVER'}
--- template
<mt:Include module="MyTemplate" cache="1">
--- expected
MODULE-CONTENT5
