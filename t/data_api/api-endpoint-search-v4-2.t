use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Fixture::DataApiSearch;
use MT::Test::DataAPI;
use Test::Deep;

$test_env->prepare_fixture('data_api_search');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $objs     = MT::Test::Fixture::DataApiSearch->load_objs;
my $author   = $app->model('author')->load(1);
my $blog_id1 = 1;
my $blog_id2 = $objs->{blog_id};

subtest 'Simple' => sub {
    my %params = (
        SearchContentTypes => $objs->{content_type}{simple_ct}{content_type}->id,
        cdSearch           => 1,
        IncludeBlogs       => $blog_id2,
    );
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => { %params, search => 'FOO' },
        result => {
            'items' => [
                superhashof({ data => [superhashof({ data => 'FOO BAR' })] }),
                superhashof({ data => [superhashof({ data => 'FOO' })] }),
            ],
            'totalResults' => 2,
        },
    });
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => { %params, search => 'foo bar' },
        result => {
            'items' => [
                superhashof({ data => [superhashof({ data => 'FOO BAR' })] }),
            ],
            'totalResults' => 1,
        },
    });
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => { %params, search => '"FOO BAR" OR "BAZ YADA"' },
        result => {
            'items' => [
                superhashof({ data => [superhashof({ data => 'BAZ YADA' })] }),
                superhashof({ data => [superhashof({ data => 'FOO BAR' })] }),
            ],
            'totalResults' => 2,
        },
    });
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => { %params, search => 'FOO AND "FOO BAR"' },
        result => {
            'items' => [
                superhashof({ data => [superhashof({ data => 'FOO BAR' })] }),
            ],
            'totalResults' => 1,
        },
    });
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => { %params, search => 'NOT "FOO BAR"' },
        result => {
            'items' => [
                superhashof({ data => [superhashof({ data => 'BAZ YADA' })] }),
                superhashof({ data => [superhashof({ data => 'FOO' })] }),
            ],
            'totalResults' => 2,
        },
    });

    subtest 'limit_by' => sub {
        test_data_api({
            path   => '/v4/search',
            method => 'GET',
            params => { %params, search => 'BAR BAZ', limit_by => 'any' },
            result => {
                'items' => [
                    superhashof({ data => [superhashof({ data => 'BAZ YADA' })] }),
                    superhashof({ data => [superhashof({ data => 'FOO BAR' })] }),
                ],
                'totalResults' => 2,
            },
        });
        test_data_api({
            path   => '/v4/search',
            method => 'GET',
            params => { %params, search => 'BAR BAZ', limit_by => 'exclude' },
            result => {
                'items' => [
                    superhashof({ data => [superhashof({ data => 'FOO' })] }),
                ],
                'totalResults' => 1,
            },
        });
    };

    subtest 'IncludeBlogs' => sub {
        my %params = (
            cdSearch           => 1,
            SearchContentTypes => qq{"simple_ct" OR "simple_ct_blog_id1"},
        );
        test_data_api({
            path   => '/v4/search',
            method => 'GET',
            params => { %params, search => 'BAZ', IncludeBlogs => $blog_id2 },
            result => {
                'items' => [
                    superhashof({ blog => { id => $blog_id2 }, data => [superhashof({ data => 'BAZ YADA' })] }),
                ],
                'totalResults' => 1,
            },
        });
        test_data_api({
            path   => '/v4/search',
            method => 'GET',
            params => { %params, search => 'BAZ', IncludeBlogs => $blog_id1 },
            result => {
                'items' => [
                    superhashof({ blog => { id => $blog_id1 }, data => [superhashof({ data => 'BAZ' })] }),
                ],
                'totalResults' => 1,
            },
        });
        test_data_api({
            path   => '/v4/search',
            method => 'GET',
            params => { %params, search => 'BAZ', IncludeBlogs => 'all' },
            result => {
                'items' => [
                    superhashof({ blog => { id => $blog_id1 }, data => [superhashof({ data => 'BAZ' })] }),
                    superhashof({ blog => { id => $blog_id2 }, data => [superhashof({ data => 'BAZ YADA' })] }),
                ],
                'totalResults' => 2,
            },
        });
    };
};

subtest 'pagination' => sub {
    my %params = (
        cdSearch           => 1,
        SearchContentTypes => 'pagination',
        IncludeBlogs       => $blog_id2,
        search             => 'FOO',
    );
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => { %params, limit => 2 },
        result => {
            'items' => [
                superhashof({ label => 'pagination10' }),
                superhashof({ label => 'pagination09' }),
            ],
            'totalResults' => 10,
        },
    });
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => { %params, limit => 2, offset => 1 },
        result => {
            'items' => [
                superhashof({ label => 'pagination09' }),
                superhashof({ label => 'pagination08' }),
            ],
            'totalResults' => 10,
        },
    });
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => { %params, limit => 2, page => 3 },
        result => {
            'items' => [
                superhashof({ label => 'pagination06' }),
                superhashof({ label => 'pagination05' }),
            ],
            'totalResults' => 10,
        },
    });
};

subtest 'content_field => field:needle' => sub {
    my %params = (
        search             => '1',
        SearchContentTypes => $objs->{content_type}{content_field}{content_type}->id,
        cdSearch           => 1,
        IncludeBlogs       => $blog_id2,
    );
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => { %params, content_field => 'mynumber:12345' },
        result => {
            'items' => [
                superhashof({ data  => [superhashof({ data => '12345' }), ignore()]}),
            ],
            'totalResults' => 1,
        },
    });
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => { %params, content_field => 'mynumber:1234' },
        result => {
            'items' => [
                superhashof({ data  => [superhashof({ data => '12342' }), ignore()]}),
                superhashof({ data  => [superhashof({ data => '12341' }), ignore()]}),
                superhashof({ data  => [superhashof({ data => '12345' }), ignore()]}),
            ],
            'totalResults' => 3,
        },
    });
};

subtest 'content_field => field:needle do not return duplication for 1 and 1000 (MTC-28540)' => sub {
    my %params = (
        search             => '1',
        SearchContentTypes => $objs->{content_type}{content_field2}{content_type}->id,
        cdSearch           => 1,
        IncludeBlogs       => $blog_id2,
    );
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => { %params, content_field => 'myasset_image:1' },
        result => {
            'items' => [
                superhashof({
                    label => 'content_field4_2',
                    data  => [superhashof({ data => [1, 1000] }), superhashof({ data => undef })]
                }),
                superhashof({
                    label => 'content_field4',
                    data  => [superhashof({ data => [1, 1000] }), superhashof({ data => [1] })]
                }),
            ],
            'totalResults' => 2,
        },
    });
};

done_testing;
