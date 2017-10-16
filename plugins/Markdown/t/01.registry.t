#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use lib qw(lib extlib t/lib);

use Test::More;
use MT::Test ();

use MT;
my $mt = MT->instance;

ok($mt->component('Markdown/Markdown.pl'), 'Load plugin: Markdown');
ok($mt->component('Markdown/SmartyPants.pl'), 'Load plugin: SmartyPants');

my %registries = (
    'function tag' => {
        registry => [ 'tags', 'function' ],
        names    => [ 'SmartyPantsVersion' ],
    },
    'block tag' => {
        registry => [ 'tags', 'block' ],
        names => [ 'MarkdownOptions' ],
    },
    text_filter => {
        registry => [ 'text_filters' ],
        names => [ 'markdown', 'markdown_with_smartypants' ],
    },
    modifier => {
        registry => [ 'tags', 'modifier' ],
        names => [ 'smarty_pants', 'smart_quotes', 'smart_dashes', 'smart_ellipses' ],
    },
);

for my $k (keys(%registries)) {
    my $registry = $mt->registry(@{ $registries{$k}{registry} });
    for my $name (@{ $registries{$k}{names} }) {
        ok($registry->{$name}, "$k '$name'");
    }
}

done_testing;
