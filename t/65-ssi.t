#!/usr/bin/perl -w

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

use MT;

use MT::Test;

$test_env->prepare_fixture('db_data');

my $mt = MT->instance or die MT->errstr;
isa_ok($mt, 'MT');


my $blog = MT->model('blog')->load(1);
$blog->include_cache(1);
$blog->save;

my $include = MT->model('template')->new;
$include->blog_id($blog->id);
$include->name('Included Template');
$include->type('custom');
$include->text('template was included at <mt:date format="%X %x"> <mt:getvar name="woot">');
$include->save;

my $include_id = $include->id;

my $tmpl = MT->model('template')->new;
$tmpl->blog_id($blog->id);
$tmpl->text(q(hi <mt:include module="Included Template"> bye));

require MT::Template::Context;
my $ctx = MT::Template::Context->new;
my $out = $tmpl->build($ctx, {});

ok(defined $out, 'test template built');
diag($tmpl->errstr) if !defined $out;
like($out, qr{ template \s was \s included }xms, 'test template included included template');


$tmpl = MT->model('template')->new;
$tmpl->blog_id($blog->id);
$tmpl->text(q(hi <mt:include module="Included Template" cache_key="woot" ttl="1000"> bye));

$ctx = MT::Template::Context->new;
$ctx->{__stash}{vars}{woot} = 'awesome';
$out = $tmpl->build($ctx, {});

ok(defined $out, 'test template built');
diag($tmpl->errstr) if !defined $out;
like($out, qr{ template \s was \s included }xms, 'test template included cached included template');
like($out, qr{ awesome }xms, 'test template included variable value');


my $first_text = $out;

$tmpl = MT->model('template')->new;
$tmpl->blog_id($blog->id);
$tmpl->text(q(hi <mt:include module="Included Template" cache_key="woot" ttl="1000"> bye));

$ctx = MT::Template::Context->new;
$ctx->{__stash}{vars}{woot} = 'terrible';
$out = $tmpl->build($ctx, {});

ok(defined $out, 'test template built');
like($out, qr{ template \s was \s included }xms, 'test template included cached included template again');
like($out, qr{ awesome }xms, 'test template included old cached variable value');


$blog->include_system('shtml');
$blog->save;

$tmpl = MT->model('template')->new;
$tmpl->blog_id($blog->id);
$tmpl->text(q(hi <mt:include module="Included Template" cache_key="woot" ttl="1000" ssi="1"> bye));

$ctx = MT::Template::Context->new;
$ctx->{__stash}{vars}{woot} = 'terrible';
$out = $tmpl->build($ctx, {});

ok(defined $out, 'test template built');
my $site_url = $blog->site_url;
$site_url =~ s{ \A \w+ :// [^/]+ }{}xms;
$site_url =~ s{ / \z }{}xms;
like($out, qr(\Ahi <!--#include virtual="${site_url}/includes_c/woot/included_template_$include_id.html" --> bye\z)ms,
    'test template included template by ssi');


$tmpl = MT->model('template')->new;
$tmpl->blog_id($blog->id);
$tmpl->text(q(hi <mt:include module="Included Template" cache_key="w" ttl="1000" ssi="1"> bye));

$ctx = MT::Template::Context->new;
$ctx->{__stash}{vars}{woot} = 'terrible';
$out = $tmpl->build($ctx, {});

ok(defined $out, 'test template built');
$site_url = $blog->site_url;
$site_url =~ s{ \A \w+ :// [^/]+ }{}xms;
$site_url =~ s{ / \z }{}xms;
like($out, qr(\Ahi <!--#include virtual="${site_url}/includes_c/w/included_template_$include_id.html" --> bye\z)ms,
    'test template included template by ssi');

$tmpl = MT->model('template')->new;
$tmpl->blog_id($blog->id);
$tmpl->text(q(hi <mt:include module="Included Template" key="w" ttl="1000" ssi="1"> bye));

$ctx = MT::Template::Context->new;
$ctx->{__stash}{vars}{woot} = 'terrible';
$out = $tmpl->build($ctx, {});

ok(defined $out, 'test template built');
$site_url = $blog->site_url;
$site_url =~ s{ \A \w+ :// [^/]+ }{}xms;
$site_url =~ s{ / \z }{}xms;
like($out, qr(\Ahi <!--#include virtual="${site_url}/includes_c/w/included_template_$include_id.html" --> bye\z)ms,
    'test template included template by ssi using \'key\' with relative path');


$tmpl = MT->model('template')->new;
$tmpl->blog_id($blog->id);
$tmpl->text(q(hi <mt:include module="Included Template" ttl="1000" ssi="1"> bye));

$ctx = MT::Template::Context->new;
$ctx->{__stash}{vars}{woot} = 'terrible';
$out = $tmpl->build($ctx, {});

ok(defined $out, 'test template built');
$site_url = $blog->site_url;
$site_url =~ s{ \A \w+ :// [^/]+ }{}xms;
$site_url =~ s{ / \z }{}xms;
like($out, qr(\Ahi <!--#include virtual="${site_url}/includes_c/included_template_$include_id.html" --> bye\z)ms,
    'test template included template by ssi without \'key\'');


$tmpl = MT->model('template')->new;
$tmpl->blog_id($blog->id);
$tmpl->text(q(hi <mt:include module="Included Template" cache_key="/w" ttl="1000" ssi="1"> bye));

$ctx = MT::Template::Context->new;
$ctx->{__stash}{vars}{woot} = 'terrible';
$out = $tmpl->build($ctx, {});

ok(defined $out, 'test template built');
$site_url = $blog->site_url;
$site_url =~ s{ \A \w+ :// [^/]+ }{}xms;
$site_url =~ s{ / \z }{}xms;
like($out, qr(\Ahi <!--#include virtual="${site_url}/w/included_template_$include_id.html" --> bye\z)ms,
    'test template included template by ssi with \'key\' absolute path');

done_testing;
