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

use MT::Test::Fixture::SearchReplace;
use MT::Test::DataAPI;
use JSON;

$test_env->prepare_fixture('search_replace');

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

# preparation.
my $objs    = MT::Test::Fixture::SearchReplace->load_objs;
my $author  = $app->model('author')->load(1);
my $blog_id = $objs->{blog_id};
my $ct_id   = $objs->{content_type}{ct_multi}{content_type}->id;

# test.

# my $is_deeply_org = \&is_deeply;
# *is_deeply = sub {
#     my $ret = $is_deeply_org->(@_) or note explain \$_[0];
#     return $ret;
# };

subtest 'Simple' => sub {
    my %params = (
        SearchContentTypes => $ct_id,
        cdSearch           => 1,
        IncludeBlogs       => $blog_id,
    );
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, search => 'text' },
        complete => expected_labels(
            'cd_multi9',
            'cd_multi7',
            'cd_multi6',
            'cd_multi5',
            'cd_multi4',
            'cd_multi3',
            'cd_multi2',
            'cd_multi',
        ),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, search => 'single text' },
        complete => expected_labels('cd_multi2', 'cd_multi'),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, search => '"text multi1" OR "text multi2"' },
        complete => expected_labels('cd_multi2', 'cd_multi'),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, search => 'single AND "text multi2"' },
        complete => expected_labels('cd_multi2'),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, search => 'NOT "text multi2"' },
        complete => expected_labels(
            'cd_multi10',
            'cd_multi9',
            'cd_multi8',
            'cd_multi7',
            'cd_multi6',
            'cd_multi5',
            'cd_multi4',
            'cd_multi3',
            'cd_multi',
        ),
    });
};

subtest 'IncludeBlogs => all' => sub {
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => {
            search             => 'text',
            SearchContentTypes => $ct_id,
            cdSearch           => 1,
            IncludeBlogs       => 'all',
        },
        complete => expected_labels(
            'cd_multi9',
            'cd_multi7',
            'cd_multi6',
            'cd_multi5',
            'cd_multi4',
            'cd_multi3',
            'cd_multi2',
            'cd_multi',
        ),
    });
};

subtest 'search type of A OR B' => sub {
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => {
            search             => 'text',
            SearchContentTypes => qq{"test content data" OR "test multiple content data"},
            cdSearch           => 1,
            IncludeBlogs       => $blog_id,
        },
        complete => expected_labels(
            'cd_multi9',
            'cd_multi7',
            'cd_multi6',
            'cd_multi5',
            'cd_multi4',
            'cd_multi3',
            'cd_multi2',
            'cd',
            'cd_multi',
        ),
    });
};

subtest 'pagination' => sub {
    my %params = (
        cdSearch     => 1,
        IncludeBlogs => $blog_id,
    );
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => {
            %params,
            search             => 'single multi1',
            SearchContentTypes => $ct_id,
            limit_by           => 'all',
        },
        complete => expected_labels('cd_multi'),
    });
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => {
            %params,
            search             => 'multi1 multi2',
            SearchContentTypes => $ct_id,
            limit_by           => 'any',
        },
        complete => expected_labels('cd_multi2', 'cd_multi'),
    });
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => {
            %params,
            search             => 'multi2',
            SearchContentTypes => $ct_id,
            limit_by           => 'exclude',
        },
        complete => expected_labels(
            'cd_multi10',
            'cd_multi9',
            'cd_multi8',
            'cd_multi7',
            'cd_multi6',
            'cd_multi5',
            'cd_multi4',
            'cd_multi3',
            'cd_multi',
        ),
    });
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => {
            %params,
            search             => 'text',
            SearchContentTypes => $ct_id,
            limit              => 1,
        },
        complete => expected_labels('cd_multi9'),
    });
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => {
            %params,
            search             => 'text',
            SearchContentTypes => qq{"test content data" OR "test multiple content data"},
            offset             => 1,
        },
        complete => expected_labels(
            'cd_multi7',
            'cd_multi6',
            'cd_multi5',
            'cd_multi4',
            'cd_multi3',
            'cd_multi2',
            'cd',
            'cd_multi',
        ),
    });
    test_data_api({
        path   => '/v4/search',
        method => 'GET',
        params => {
            %params,
            search             => 'text',
            SearchContentTypes => qq{"test content data" OR "test multiple content data"},
            limit              => 1,
            page               => 3,
        },
        complete => expected_labels('cd_multi6'),
    });
};

subtest 'archive_type' => sub {
    my %params = (
        search             => 'text',
        SearchContentTypes => qq{"test content data" OR "test multiple content data"},
        cdSearch           => 1,
        IncludeBlogs       => $blog_id,
    );
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, archive_type => 'Yearly', year => '2017' },
        complete => expected_labels(
            'cd_multi9',
            'cd_multi7',
            'cd_multi6',
            'cd_multi5',
            'cd_multi4',
            'cd_multi3',
            'cd_multi2',
            'cd',
            'cd_multi',
        ),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, archive_type => 'Monthly', year => '2017', month => '05' },
        complete => expected_labels(
            'cd',
            'cd_multi',
        ),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, archive_type => 'Daily', year => '2017', month => '05', day => '30' },
        complete => expected_labels(
            'cd',
            'cd_multi',
        ),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, archive_type => 'Weekly', year => '2017', month => '05', day => '31' },
        complete => expected_labels(
            'cd_multi5',
            'cd_multi4',
            'cd_multi3',
            'cd_multi2',
            'cd',
            'cd_multi',
        ),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, archive_type => 'Yearly', year => '2020', date_field => 'date_only' },
        complete => expected_labels('cd_multi2'),
    });
};

subtest 'author' => sub {
    my %params = (
        search             => 'text',
        SearchContentTypes => $ct_id,
        cdSearch           => 1,
        IncludeBlogs       => $blog_id,
    );
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, author => 'author' },
        complete => expected_labels(
            'cd_multi9',
            'cd_multi7',
            'cd_multi6',
            'cd_multi5',
            'cd_multi4',
            'cd_multi3',
            'cd_multi2',
            'cd_multi',
        ),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, author => 'unknown' },
        complete => expected_labels(),
    });
};

subtest 'content_field => field:needle' => sub {
    my %params = (
        search             => 'text',
        SearchContentTypes => $ct_id,
        cdSearch           => 1,
        IncludeBlogs       => $blog_id,
    );
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, content_field => 'number:123456789' },
        complete => expected_labels('cd_multi2'),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, content_field => 'number:12345' },
        complete => expected_labels('cd_multi2', 'cd_multi'),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, content_field => 'categories:3' },
        complete => expected_labels('cd_multi'),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, content_field => 'categories:999' },
        complete => expected_labels(),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, content_field => 'asset_image:2' },
        complete => expected_labels('cd_multi2', 'cd_multi'),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, content_field => 'asset_image:1' },
        complete => expected_labels('cd_multi'),
        note     => 'MTC-28540 do not return duplication for 1 and 1000',
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, content_field => 'asset_image:1000' },
        complete => expected_labels('cd_multi'),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, content_field => q{single line text:multi1 OR multi2} },
        complete => expected_labels('cd_multi2', 'cd_multi'),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, content_field => q{single line text:multi2 AND text} },
        complete => expected_labels('cd_multi2'),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, content_field => q{single line text:NOT multi2} },
        complete => expected_labels(
            'cd_multi3',
            'cd_multi',
        ),
    });
};

subtest 'SearchSortBy' => sub {
    my %params = (
        search             => 'text',
        SearchContentTypes => qq{"test content data" OR "test multiple content data"},
        cdSearch           => 1,
        IncludeBlogs       => $blog_id,
    );
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, SearchResultDisplay => 'ascend', SearchSortBy => 'created_on,id' },
        complete => expected_labels(
            'cd_multi',
            'cd_multi2',
            'cd_multi3',
            'cd_multi4',
            'cd_multi5',
            'cd_multi6',
            'cd_multi7',
            'cd_multi9',
            'cd',
        ),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, SearchResultDisplay => 'descend', SearchSortBy => 'created_on,id' },
        complete => expected_labels(
            'cd',
            'cd_multi9',
            'cd_multi7',
            'cd_multi6',
            'cd_multi5',
            'cd_multi4',
            'cd_multi3',
            'cd_multi2',
            'cd_multi',
        ),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, SearchResultDisplay => 'ascend', SearchSortBy => 'field:number,id' },
        complete => expected_labels(
            'cd_multi3',
            'cd_multi4',
            'cd_multi5',
            'cd_multi6',
            'cd_multi7',
            'cd_multi9',
            'cd_multi',
            'cd',
            'cd_multi2',
        ),
    });
    test_data_api({
        path     => '/v4/search',
        method   => 'GET',
        params   => { %params, SearchResultDisplay => 'descend', SearchSortBy => 'field:number,id' },
        complete => expected_labels(
            'cd_multi2',
            'cd',
            'cd_multi',
            'cd_multi9',
            'cd_multi7',
            'cd_multi6',
            'cd_multi5',
            'cd_multi4',
            'cd_multi3',
        ),
    });
};

# end
done_testing;

sub expected_labels {
    my @expected_labels = @_;
    return sub {
        my ($data, $body) = @_;
        my $json      = decode_json($body);
        my @got_label = map { $_->{label} } @{ $json->{items} || [] };
        is_deeply(\@got_label, \@expected_labels, 'expected cd labels');
    };
}
