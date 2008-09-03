#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 4;

use lib qw( lib plugins/MultiBlog plugins/MultiBlog/lib t/lib );

use MT::Test;
use MT::Template::Context;

my $mt = MT->new;
my $ctx = MT::Template::Context->new;

sub tag_ok {
    my ($tag) = @_;
    $tag =~ s/^MT//;
    ok($ctx->handler_for($tag), "tag handler for $tag exists");
}

tag_ok ('MTMultiBlog');
tag_ok ('MTOtherBlog');
tag_ok ('MTMultiBlogLocalBlog');
tag_ok ('MTMultiBlogIfLocalBlog');
