#!/usr/bin/perl -w

use strict;
use warnings;

use lib 't/lib';
use MT::Test qw(:db :data);

use Test::More;


plan tests => 25;

{
    diag('test MT::CMS::Blog::_update_finfos');

    ok(MT->model('blog')->load(1), 'have a blog #1');
    # This test blog has:
    #   6 index templates
    #   6 published entries across 6 different years
    #   4 pages
    #   2 placements (entry-category mappings)
    #   individual, monthly, weekly, daily, category and page archives

    sub finfos_of_type {
        return MT->model('fileinfo')->count({ blog_id => 1, archive_type => shift });
    }

    is(finfos_of_type('index'),      6, 'blog #1 has 6 index template fileinfos');
    is(finfos_of_type('Individual'), 6, 'blog #1 has 6 individual fileinfos');
    is(finfos_of_type('Daily'),      6, 'blog #1 has 6 daily fileinfos');
    is(finfos_of_type('Monthly'),    6, 'blog #1 has 6 monthly fileinfos');
    is(finfos_of_type('Weekly'),     6, 'blog #1 has 6 weekly fileinfos');
    is(finfos_of_type('Yearly'),     0, 'blog #1 has 0 yearly fileinfos');
    is(finfos_of_type('Page'),       4, 'blog #1 has 4 page fileinfos');
    is(finfos_of_type('Category'),   2, 'blog #1 has 2 category fileinfos');

    my $total_fileinfos = MT->model('fileinfo')->count({ blog_id => 1 });
    is($total_fileinfos, 36, 'blog #1 has 36 fileinfos');

    my $static_fileinfos = MT->model('fileinfo')->count({
        blog_id => 1, 
        virtual => [ \"= 0", \"is null" ],
    });
    is($static_fileinfos, 36, "all blog #1's fileinfos are static");

    my $mapped_fileinfos = MT->model('fileinfo')->count({
        blog_id => 1,
        templatemap_id => \"is not null",
    });
    is($mapped_fileinfos, 30, "blog #1 has 30 fileinfos for archive pages (fileinfos with template maps)");

    require MT::CMS::Blog;
    my $ret = MT::CMS::Blog::_update_finfos(MT->instance, 1);

    ok($ret, 'set all finfos virtual');
    diag(MT->instance->errstr) if !$ret;
    is(MT->model('fileinfo')->count({
        blog_id => 1,
        virtual => [ \"= 0", \"is null" ],
    }), 0, 'no static finfos after setting all virtual');
    is(MT->model('fileinfo')->count({
        blog_id => 1,
        virtual => 1,
    }), $total_fileinfos, 'all virtual finfos after setting all virtual');

    $ret = MT::CMS::Blog::_update_finfos(MT->instance, 0);

    ok($ret, 'set all finfos static again');
    is(MT->model('fileinfo')->count({
        blog_id => 1,
        virtual => [ \"= 0", \"is null" ],
    }), $total_fileinfos, 'all finfos are static after setting all static');
    is(MT->model('fileinfo')->count({
        blog_id => 1,
        virtual => 1,
    }), 0, 'no virtual finfos after setting all static');

    is(MT->model('fileinfo')->count({
        blog_id => 1,
        id      => 1,
    }), 1, 'blog #1 has fileinfo #1');

    diag('test basic condition (not used by app)');
    $ret = MT::CMS::Blog::_update_finfos(MT->instance, 1, { id => 1 });

    ok($ret, 'set fileinfo #1 virtual');
    is(MT->model('fileinfo')->count({
        blog_id => 1,
        id      => 1,
        virtual => 1,
    }), 1, 'fileinfo #1 is in fact virtual');
    is(MT->model('fileinfo')->count({
        blog_id => 1,
        virtual => [ \"= 0", \"is null" ],
    }), $total_fileinfos - 1, 'all fileinfos except one are static');

    MT::CMS::Blog::_update_finfos(MT->instance, 0)
        or BAIL_OUT('could not reset fileinfos after basic condition test');

    diag('test template map presence as used in app');
    $ret = MT::CMS::Blog::_update_finfos(MT->instance, 1, { templatemap_id => \"is not null" });

    ok($ret, 'set fileinfos with templatemaps virtual');
    is(MT->model('fileinfo')->count({
        blog_id => 1,
        templatemap_id => \"is null",
        virtual => 1,
    }), 0, 'no index fileinfos are virtual');
    is(MT->model('fileinfo')->count({
        blog_id => 1,
        virtual => 1,
    }), 30, '18 other fileinfos are virtual');
}

1;

