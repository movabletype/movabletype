#!/usr/bin/perl -w

use strict;
use warnings;

use lib 't/lib';
use MT::Test qw(:cms :db :data);

use Test::More;


plan tests => 10;

{
    diag('test MT::CMS::Blog::list_tag_for()');

    isa_ok(MT->instance, 'MT::App::CMS', 'our mt app');

    require MT::CMS::Tag;
    MT->instance->user(MT->model('author')->load(1));
    my $ret = MT::CMS::Tag::list_tag_for(MT->instance,
        TagObjectType => 'entry',
        Package       => MT->model('entry'),
    );
    ok($ret, 'yay finished');
    diag('ERROR: ' . MT->instance->errstr) if !$ret;

    isa_ok($ret, 'MT::Template', 'list_tag_for() result');
    my $loop = $ret->param('object_loop');
    ok($loop, 'list_tag_for() result has an object_loop');
    isa_ok($loop, 'ARRAY', 'result object_loop is really a loop');
    isa_ok($loop->[0], 'HASH', 'result object_loop is a loop of hashrefs');

    is(scalar @$loop, 3, 'result object_loop has four objects');
    is($loop->[0]->{tag_name}, 'anemones', 'first tag in loop is anemones');
    is($loop->[1]->{tag_name}, 'rain', 'third tag in loop is rain');
    is($loop->[2]->{tag_name}, 'verse', 'fourth tag in loop is verse');
}

1;

