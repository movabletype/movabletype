#!/usr/bin/perl

use strict;
use warnings;

use lib qw( t/lib lib extlib ../lib ../extlib );
use Test::More tests => 20;

BEGIN {
    $ENV{MT_APP} = 'MT::App::Comments';
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT;
use MT::Blog;
use MT::Comment;
use MT::Entry;
use MT::Template;
use MT::Test qw( :app :db :data );

my @blogs = MT::Blog->load();
foreach my $blog (@blogs) {
    my $tmpl = MT::Template->load(
        {
            name    => 'Comment Listing',
            blog_id => $blog->id,
        }
    );
    unless ($tmpl) {
        my $text =
<<TEXT;
{
	"direction": "<mt:Var name="commentDirection">",
	"comments": "<mt:Comments sort_order="\$commentDirection"><mt:Include module="Comment Detail" replace="\","\\" replace='"','\"' strip_linefeeds="1"></mt:Comments>"
}
TEXT

        $tmpl = MT::Template->new;
        $tmpl->blog_id($blog->id);
        $tmpl->name('Comment Listing');
        $tmpl->text($text);
        $tmpl->save;
    }
}

my @entries = MT::Entry->load();
foreach my $entry (@entries) {
    my $app = _run_app( 'MT::App::Comments', { __mode => 'comment_listing', entry_id => $entry->id } );
    my $output = delete $app->{__test_output};
    ok ($output, "comment_listing ran and returned something");
    my @comments = MT::Comment->load({ entry_id => $entry->id });
    next unless (@comments);
    foreach my $comment (@comments) {
        my $id = $comment->id;
        if ( $comment->visible() ) {
            ok ($output =~ /comment-$id/, "Comment was found: $output");
        }
        else {
            ok ($output !~ /comment-$id/, "Invisible comment was hidden: $output");
        }
    }
}
