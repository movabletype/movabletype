#!/usr/bin/perl -w

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;

$test_env->prepare_fixture('db_data');

plan tests => 26;

{
    note('test MT::CMS::Blog::_update_finfos');

    ok( MT->model('blog')->load(1), 'have a blog #1' );

    # This test blog has:
    #   6 index templates
    #   6 published entries across 6 different years
    #   4 pages
    #   2 placements (entry-category mappings)
    #   individual, monthly, weekly, daily, category and page archives

    sub finfos_of_type {
        return MT->model('fileinfo')
            ->count( { blog_id => 1, archive_type => shift } );
    }

    is( finfos_of_type('index'), 6,
        'blog #1 has 6 index template fileinfos' );
    is( finfos_of_type('Individual'),
        6, 'blog #1 has 6 individual fileinfos' );
    is( finfos_of_type('Daily'),    6, 'blog #1 has 6 daily fileinfos' );
    is( finfos_of_type('Monthly'),  6, 'blog #1 has 6 monthly fileinfos' );
    is( finfos_of_type('Weekly'),   6, 'blog #1 has 6 weekly fileinfos' );
    is( finfos_of_type('Yearly'),   0, 'blog #1 has 0 yearly fileinfos' );
    is( finfos_of_type('Page'),     4, 'blog #1 has 4 page fileinfos' );
    is( finfos_of_type('Category'), 2, 'blog #1 has 2 category fileinfos' );
    is( finfos_of_type('Author'), 2, 'blog #1 has 2 author fileinfos' );

    my $total_fileinfos = MT->model('fileinfo')->count( { blog_id => 1 } );
    is( $total_fileinfos, 38, 'blog #1 has 38 fileinfos' );

    my $static_fileinfos = MT->model('fileinfo')->count(
        {   blog_id => 1,
            virtual => [ \"= 0", \"is null" ],
        }
    );
    is( $static_fileinfos, 38, "all blog #1's fileinfos are static" );

    my $mapped_fileinfos = MT->model('fileinfo')->count(
        {   blog_id        => 1,
            templatemap_id => \"is not null",
        }
    );
    is( $mapped_fileinfos, 32,
        "blog #1 has 32 fileinfos for archive pages (fileinfos with template maps)"
    );

    require MT::CMS::Blog;
    my $ret = MT::CMS::Blog::_update_finfos( MT->instance, 1 );

    ok( $ret, 'set all finfos virtual' );
    note( MT->instance->errstr ) if !$ret;
    is( MT->model('fileinfo')->count(
            {   blog_id => 1,
                virtual => [ \"= 0", \"is null" ],
            }
        ),
        0,
        'no static finfos after setting all virtual'
    );
    is( MT->model('fileinfo')->count(
            {   blog_id => 1,
                virtual => 1,
            }
        ),
        $total_fileinfos,
        'all virtual finfos after setting all virtual'
    );

    $ret = MT::CMS::Blog::_update_finfos( MT->instance, 0 );

    ok( $ret, 'set all finfos static again' );
    is( MT->model('fileinfo')->count(
            {   blog_id => 1,
                virtual => [ \"= 0", \"is null" ],
            }
        ),
        $total_fileinfos,
        'all finfos are static after setting all static'
    );
    is( MT->model('fileinfo')->count(
            {   blog_id => 1,
                virtual => 1,
            }
        ),
        0,
        'no virtual finfos after setting all static'
    );

    is( MT->model('fileinfo')->count(
            {   blog_id => 1,
                id      => 1,
            }
        ),
        1,
        'blog #1 has fileinfo #1'
    );

    note('test basic condition (not used by app)');
    $ret = MT::CMS::Blog::_update_finfos( MT->instance, 1, { id => 1 } );

    ok( $ret, 'set fileinfo #1 virtual' );
    is( MT->model('fileinfo')->count(
            {   blog_id => 1,
                id      => 1,
                virtual => 1,
            }
        ),
        1,
        'fileinfo #1 is in fact virtual'
    );
    is( MT->model('fileinfo')->count(
            {   blog_id => 1,
                virtual => [ \"= 0", \"is null" ],
            }
        ),
        $total_fileinfos - 1,
        'all fileinfos except one are static'
    );

    MT::CMS::Blog::_update_finfos( MT->instance, 0 )
        or BAIL_OUT('could not reset fileinfos after basic condition test');

    note('test template map presence as used in app');
    $ret = MT::CMS::Blog::_update_finfos( MT->instance, 1,
        { templatemap_id => \"is not null" } );

    ok( $ret, 'set fileinfos with templatemaps virtual' );
    is( MT->model('fileinfo')->count(
            {   blog_id        => 1,
                templatemap_id => \"is null",
                virtual        => 1,
            }
        ),
        0,
        'no index fileinfos are virtual'
    );
    is( MT->model('fileinfo')->count(
            {   blog_id => 1,
                virtual => 1,
            }
        ),
        32,
        '32 other fileinfos are virtual'
    );
}

1;

