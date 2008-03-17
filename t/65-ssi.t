#!/usr/bin/perl -w

use strict;
use warnings;

use lib 'extlib';
use lib 'lib';
use lib 't/lib';

use Test::More qw(no_plan);

use MT;

use vars qw( $DB_DIR $T_CFG );
use MT::Test qw(:db :data);

my $mt = MT->instance( Config => $T_CFG ) or die MT->errstr;
isa_ok($mt, 'MT');


my $blog = MT->model('blog')->load(1);

my $include = MT->model('template')->new;
$include->blog_id($blog->id);
$include->name('Included Template');
$include->type('custom');
$include->text('template was included at <mt:date format="%X %x"> <mt:getvar name="woot">');
$include->save;

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
$tmpl->text(q(hi <mt:include module="Included Template" key="woot" ttl="1000"> bye));

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
$tmpl->text(q(hi <mt:include module="Included Template" key="woot" ttl="1000"> bye));

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
$tmpl->text(q(hi <mt:include module="Included Template" key="woot" ttl="1000" ssi="1"> bye));

$ctx = MT::Template::Context->new;
$ctx->{__stash}{vars}{woot} = 'terrible';
$out = $tmpl->build($ctx, {});

ok(defined $out, 'test template built');
my $sitepath = $blog->site_path;
like($out, qr(\Ahi <!--#include file="${sitepath}includes_c/woo/woot.html" --> bye\z)ms,
    'test template included template by ssi');


$tmpl = MT->model('template')->new;
$tmpl->blog_id($blog->id);
$tmpl->text(q(hi <mt:include module="Included Template" key="w" ttl="1000" ssi="1"> bye));

$ctx = MT::Template::Context->new;
$ctx->{__stash}{vars}{woot} = 'terrible';
$out = $tmpl->build($ctx, {});

ok(defined $out, 'test template built');
$sitepath = $blog->site_path;
like($out, qr(\Ahi <!--#include file="${sitepath}includes_c/w/w.html" --> bye\z)ms,
    'test template included template by ssi');

