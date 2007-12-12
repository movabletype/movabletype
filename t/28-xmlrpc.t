# $Id$

BEGIN { unshift @INC, 't/' }

use lib 't/lib';
use lib 'lib';
use lib 'extlib';

use Test;
use XMLRPC::Lite;
use MT;
use MT::Blog;
use MT::Author;
use MT::Entry;
use MT::Util qw( format_ts );
use strict;

BEGIN { plan tests => 85 }

for (my $i = 0; $i < 85; $i++)
{
    skip(1);
}
exit(0);

use vars qw( $DB_DIR $T_CFG $BASE );
require 'test-common.pl';
my $mt = MT->new( Config => $T_CFG ) or die MT->errstr;

my $script = "$BASE/t/mt-test-rpc.cgi";

open my $fh, ">$script" or die $!;
print $fh <<SCRIPT;
#!/usr/bin/perl -w
use strict;

use XMLRPC::Transport::HTTP;
use File::Spec;

use lib File::Spec->catdir('$BASE', 'lib');

use MT::XMLRPCServer;

\$MT::XMLRPCServer::MT_DIR = File::Spec->catfile('$BASE', 't');

local \$SIG{__WARN__} = sub { };
my \$server = XMLRPC::Transport::HTTP::CGI->new;
\$server->dispatch_to('blogger', 'metaWeblog', 'mt');
\$server->handle;
SCRIPT
close $fh;
chmod 0755, $script;

# TODO: get this script 'running'

my $rpc = XMLRPC::Lite->new;
$rpc->proxy("http://localhost/mt-test-rpc.cgi");

my $som;

my $blog = MT::Blog->load(1);

$som = $rpc->call('blogger.getUsersBlogs', '', 'Chuck D', 'bass');
ok($som && $som->result);
ok(scalar @{ $som->result }, 1);
ok($som->result->[0]{url}, $blog->site_url);
ok($som->result->[0]{blogid}, $blog->id);
ok($som->result->[0]{blogName}, $blog->name);

my $author = MT::Author->load({ name => 'Chuck D' });

$som = $rpc->call('blogger.getUserInfo', '', 'Chuck D', 'bass');
ok($som && $som->result);
ok($som->result->{userid}, $author->id);
ok($som->result->{firstname}, (split /\s+/, $author->name)[0]);
ok($som->result->{lastname}, (split /\s+/, $author->name)[1]);
ok($som->result->{nickname}, $author->nickname || '');
ok($som->result->{email}, $author->email || '');
ok($som->result->{url}, $author->url || '');

$som = $rpc->call('blogger.getUserInfo', '', 'Chuck D', 'wrong');
ok(!$som->result);
ok($som->fault);
ok($som->faultstring, 'Invalid login');
ok($som->faultcode, 1);

$som = $rpc->call('blogger.getUsersBlogs', '', 'Chuck D', 'wrong');
ok(!$som->result);
ok($som->fault);
ok($som->faultstring, 'Invalid login');
ok($som->faultcode, 1);

my $entry1 = MT::Entry->load(1);
ok($entry1);

$som = $rpc->call('blogger.getRecentPosts', '', $blog->id, 'Chuck D', 'bass', 2);
ok($som && $som->result);
ok(scalar @{ $som->result }, 1);
ok($som->result->[0]{userid}, $author->id);
ok($som->result->[0]{postid}, $entry1->id);
ok($som->result->[0]{dateCreated}, format_ts("%Y%m%dT%H:%M:%S", $entry1->created_on));
ok($som->result->[0]{content}, $entry1->text);

$som = $rpc->call('metaWeblog.getRecentPosts', $blog->id, 'Chuck D', 'bass', 2);
ok($som && $som->result);
ok(scalar @{ $som->result }, 1);
ok($som->result->[0]{userid}, $author->id);
ok($som->result->[0]{postid}, $entry1->id);
ok($som->result->[0]{dateCreated}, format_ts("%Y%m%dT%H:%M:%S", $entry1->created_on));
ok($som->result->[0]{description}, $entry1->text);
ok($som->result->[0]{title}, $entry1->title);
ok($som->result->[0]{link}, $entry1->permalink);
ok($som->result->[0]{permaLink}, $entry1->permalink);
ok($som->result->[0]{mt_excerpt}, $entry1->excerpt);
ok($som->result->[0]{mt_text_more}, $entry1->text_more);
ok($som->result->[0]{mt_allow_comments}, $entry1->allow_comments);
ok($som->result->[0]{mt_allow_pings}, $entry1->allow_pings || 0);
ok($som->result->[0]{mt_convert_breaks}, $entry1->convert_breaks || '');
ok($som->result->[0]{mt_keywords}, $entry1->keywords || '');

$som = $rpc->call('blogger.editPost', '', $entry1->id, 'Chuck D', 'bass', 'Foo Bar', 0);
ok($som->result, 1);
$entry1 = MT::Entry->load($entry1->id);
ok($entry1->text, 'Foo Bar');

$som = $rpc->call('metaWeblog.editPost', $entry1->id, 'Chuck D', 'bass', {
    title => 'Title',
    description => 'Description',
    mt_convert_breaks => 'wiki',
    mt_allow_comments => 1,
    mt_allow_pings => 1,
    mt_excerpt => 'Excerpt',
    mt_text_more => 'Extended Entry',
    mt_keywords => 'Keywords',
    mt_tb_ping_urls => [ 'http://127.0.0.1/' ],
    dateCreated => '19770922T15:30:00',
}, 0);
ok($som->result, 1);
$entry1 = MT::Entry->load($entry1->id);
ok($entry1->title, 'Title');
ok($entry1->text, 'Description');
ok($entry1->convert_breaks, 'wiki');
ok($entry1->allow_comments, 1);
ok($entry1->allow_pings, 1);
ok($entry1->excerpt, 'Excerpt');
ok($entry1->text_more, 'Extended Entry');
ok($entry1->keywords, 'Keywords');
ok($entry1->to_ping_urls, 'http://127.0.0.1/');
ok($entry1->to_ping_url_list->[0], 'http://127.0.0.1/');
ok($entry1->created_on, '19770922153000');

$som = $rpc->call('metaWeblog.editPost', $entry1->id, 'Chuck D', 'bass', {
    mt_allow_comments => 2,
}, 0);
ok($som->result, 1);

$som = $rpc->call('metaWeblog.editPost', $entry1->id, 'Chuck D', 'bass', {
    mt_convert_breaks => '',
    mt_text_more => '',
    mt_excerpt => '',
}, 0);
ok($som->result, 1);
$entry1 = MT::Entry->load($entry1->id);
ok($entry1->convert_breaks, '');
ok($entry1->text_more, '');
ok($entry1->excerpt, '');

my $cat1 = MT::Category->load(1);
my $cat2 = MT::Category->load(2);

$som = $rpc->call('mt.getCategoryList', $blog->id, 'Chuck D', 'bass');
ok($som && $som->result);
ok(scalar @{ $som->result }, 2);
ok($som->result->[0]{categoryId}, $cat1->id);
ok($som->result->[0]{categoryName}, $cat1->label);
ok($som->result->[1]{categoryId}, $cat2->id);
ok($som->result->[1]{categoryName}, $cat2->label);

$som = $rpc->call('mt.getPostCategories', $entry1->id, 'Chuck D', 'bass');
ok($som && $som->result);
ok(!scalar @{ $som->result });

$mt->{cfg}->NoPlacementCache(1);

$entry1->{__categories} = undef;
$entry1->{__category} = undef;
$som = $rpc->call('mt.setPostCategories', $entry1->id, 'Chuck D', 'bass', [
    { categoryId => $cat1->id },
]);
ok($som->result, 1);
my $cats = $entry1->categories;
ok(scalar @$cats, 1);
ok($cats->[0]->label, $cat1->label);
ok($entry1->category->label, $cat1->label);

$entry1->{__categories} = undef;
$entry1->{__category} = undef;
$som = $rpc->call('mt.setPostCategories', $entry1->id, 'Chuck D', 'bass', [
    { categoryId => $cat1->id },
    { categoryId => $cat2->id },
]);
ok($som->result, 1);
$cats = $entry1->categories;
ok(scalar @$cats, 2);
ok($entry1->category->label, $cat1->label);

$entry1->{__categories} = undef;
$entry1->{__category} = undef;
$som = $rpc->call('mt.setPostCategories', $entry1->id, 'Chuck D', 'bass', [
    { categoryId => $cat1->id, isPrimary => 1 },
    { categoryId => $cat2->id, isPrimary => 0 },
]);
ok($som->result, 1);
$cats = $entry1->categories;
ok(scalar @$cats, 2);
ok($entry1->category->label, $cat1->label);

$entry1->{__categories} = undef;
$entry1->{__category} = undef;
$som = $rpc->call('mt.setPostCategories', $entry1->id, 'Chuck D', 'bass', [
    { categoryId => $cat1->id, isPrimary => 0 },
    { categoryId => $cat2->id, isPrimary => 1 },
]);
ok($som->result, 1);
$cats = $entry1->categories;
ok(scalar @$cats, 2);
ok($entry1->category->label, $cat2->label);

$entry1->{__categories} = undef;
$entry1->{__category} = undef;
$som = $rpc->call('mt.setPostCategories', $entry1->id, 'Chuck D', 'bass', [ ]);
ok($som->result, 1);
$cats = $entry1->categories;
ok(!scalar @$cats);
ok(!$entry1->category);
