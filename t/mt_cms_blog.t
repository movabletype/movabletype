#!/usr/bin/perl -w

use strict;
use warnings;

use lib 't/lib';
use MT::Test qw(:db :data);

use Test::More;


plan tests => 3;

{
    diag('test MT::CMS::Blog::_update_finfos');

    ok(MT->model('blog')->load(1), 'have a blog #1');

    my $total_fileinfos = MT->model('fileinfo')->count({ blog_id => 1 });
    ok($total_fileinfos, 'blog #1 has fileinfos');

    my $static_fileinfos = MT->model('fileinfo')->count({
        blog_id => 1, 
        virtual => [ \"= 0", \"is null" ],
    });
    is($static_fileinfos, $total_fileinfos, "all blog #1's fileinfos are static");

    require MT::CMS::Blog;
    my $ret = MT::CMS::Blog::_update_finfos(MT->instance, 1);
    ok($ret, 'set all finfos virtual');
    diag(MT->errstr) if !$ret;
    is(MT->model('fileinfo')->count({
        blog_id => 1,
        virtual => [ \"= 0", \"is null" ],
    }), 0, 'no static finfos after setting all virtual');
    is(MT->model('fileinfo')->count({
        blog_id => 1,
        virtual => 1,
    }), $total_fileinfos, 'all virtual finfos after setting all virtual');
}

1;

