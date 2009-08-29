#!/usr/bin/perl
# $Id$
use strict;
use warnings;
use IPC::Open2;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

$| = 1;

use lib 't/lib', 'extlib', 'lib', '../lib', '../extlib';
use MT::Test qw(:db :data);
use Test::More;
use JSON -support_by_pp;
use MT;
use MT::Util qw(ts2epoch epoch2ts);
use MT::Template::Context;
use MT::Builder;

require POSIX;

my $mt = MT->new();

local $/ = undef;
open F, "<t/35-tags.dat";
my $test_json = <F>;
close F;

$test_json =~ s/^ *#.*$//mg;
$test_json =~ s/# *\d+ *(?:TBD.*)? *$//mg;

my $json = new JSON;
$json->loose(1); # allows newlines inside strings
my $test_suite = $json->decode($test_json);

# Ok. We are now ready to test!
plan tests => (scalar(@$test_suite)) + 3;

my $blog_name_tmpl = MT::Template->load({name => "blog-name", blog_id => 1});
ok($blog_name_tmpl, "'blog-name' template found");

my $ctx = MT::Template::Context->new;
my $blog = MT::Blog->load(1);
ok($blog, "Test blog loaded");
$ctx->stash('blog', $blog);
$ctx->stash('blog_id', $blog->id);
$ctx->stash('builder', MT::Builder->new);

my $entry  = MT::Entry->load( 1 );
ok($entry, "Test entry loaded");

# entry we want to capture is dated: 19780131074500
my $tsdiff = time - ts2epoch($blog, '19780131074500');
my $daysdiff = int($tsdiff / (60 * 60 * 24));
my %const = (
    CFG_FILE => MT->instance->{cfg_file},
    VERSION_ID => MT->instance->version_id,
    CURRENT_WORKING_DIRECTORY => MT->instance->server_path,
    STATIC_CONSTANT => '1',
    DYNAMIC_CONSTANT => '',
    DAYS_CONSTANT1 => $daysdiff + 1,
    DAYS_CONSTANT2 => $daysdiff - 1,
    CURRENT_YEAR => POSIX::strftime("%Y", localtime),
    CURRENT_MONTH => POSIX::strftime("%m", localtime),
);

$test_json =~ s/\Q$_\E/$const{$_}/g for keys %const;
$test_suite = $json->decode($test_json);

$ctx->{current_timestamp} = '20040816135142';

my $num = 1;
foreach my $test_item (@$test_suite) {
    unless ($test_item->{r}) {
        pass("perl test skip " . $num++);
        next;
    }
    local $ctx->{__stash}{entry} = $entry if $test_item->{t} =~ m/<MTEntry/;
    $ctx->{__stash}{entry} = undef if $test_item->{t} =~ m/MTComments|MTPings/;
    $ctx->{__stash}{entries} = undef if $test_item->{t} =~ m/MTEntries|MTPages/;
    $ctx->stash('comment', undef);
    my $result = build($ctx, $test_item->{t});
    is($result, $test_item->{e}, "perl test " . $num++);
}

sub build {
    my($ctx, $markup) = @_;
    my $b = $ctx->stash('builder');
    my $tokens = $b->compile($ctx, $markup);
    print('# -- error compiling: ' . $b->errstr), return undef
        unless defined $tokens;
    my $res = $b->build($ctx, $tokens);
    print '# -- error building: ' . ($b->errstr ? $b->errstr : '') . "\n"
        unless defined $res;
    return $res;
}
