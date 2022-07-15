use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Fixture;
use MT::Test::App;
use MT::Test::CMSSearch;

$test_env->prepare_fixture('content_data');

my $objs    = MT::Test::Fixture::ContentData->load_objs;
my $author  = MT->model('author')->load(1);
my $blog_id = $objs->{blog_id};
my $ct_id   = $objs->{content_type}{ct_multi}{content_type}->id;

subtest 'basic' => sub {
    my %params = (
        _type           => 'content_data',
        blog_id         => $blog_id,
        do_search       => 1,
        content_type_id => $ct_id,
    );
    test_search({
        author => $author,
        params => { %params, search => 'text' },
        ids    => [3, 4],
    });
    test_search({
        author => $author,
        params => { %params, search => 'single line text' },
        ids    => [3, 4],
    });
};

subtest 'is_limited' => sub {
    my $cf_id1 = $objs->{content_type}{ct_multi}{content_field}{cf_single_line_text}->id;
    my $cf_id2 = $objs->{content_type}{ct_multi}{content_field}{cf_multi_line_text}->id;

    my %params = (
        _type           => 'content_data',
        blog_id         => $blog_id,
        do_search       => 1,
        content_type_id => $ct_id,
        is_limited      => 1,
    );
    test_search({
        author => $author,
        params => { %params, search_cols => ['__field:' . $cf_id1], search => 'text' },
        ids    => [3, 4],
    });
    test_search({
        author => $author,
        params => { %params, search_cols => ['__field:' . $cf_id1], search => 'multi1' },
        ids    => [3],
    });
    test_search({
        author => $author,
        params => { %params, search_cols => ['__field:' . $cf_id2], search => 'text' },
        ids    => [3, 4],
    });
    test_search({
        author => $author,
        params => { %params, search_cols => ['__field:' . $cf_id2], search => 'text2' },
        ids    => [4],
    });
};

subtest 'dateranged for authored_on' => sub {
    my %params = (
        _type              => 'content_data',
        blog_id            => $blog_id,
        do_search          => 1,
        content_type_id    => $ct_id,
        search             => 'text',
        is_dateranged      => 1,
        date_time_field_id => 0,
        timefrom           => '',
        timeto             => '',
    );
    test_search({
        author => $author,
        params => { %params, from => '2017-05-29', to => '2017-06-01' },
        ids    => [3, 4],
    });
    test_search({
        author => $author,
        params => { %params, from => '2017-06-01', to => '2017-05-29' },
        ids    => [3, 4],
    });
    SKIP: {
        skip 'SKIP until the implementation of date range is fixed.';
        # This test causes the query to be {'authored_on' => ['000000','235959']}
        # Since the values are illegal date format, the result would be nothing or everything 
        # depending on the environment.
        test_search({
            author => $author,
            params => {%params},
            ids    => [],
        });
    }
};

subtest 'dateranged for content fields' => sub {
    my $cf_id3 = $objs->{content_type}{ct_multi}{content_field}{cf_datetime}->id;
    my $cf_id4 = $objs->{content_type}{ct_multi}{content_field}{cf_date}->id;
    my $cf_id5 = $objs->{content_type}{ct_multi}{content_field}{cf_time}->id;

    my %params = (
        _type           => 'content_data',
        blog_id         => $blog_id,
        do_search       => 1,
        content_type_id => $ct_id,
        search          => 'text',
        is_dateranged   => 1,
        timefrom        => '',
        timeto          => '',
    );

    # 20170603180500
    test_search({
        author => $author,
        params => { %params, date_time_field_id => $cf_id3, from => '2017-06-03', to => '2017-06-04' },
        ids    => [3],
    });

    # 20170605000000
    test_search({
        author => $author,
        params => { %params, date_time_field_id => $cf_id4, from => '2017-06-05', to => '2017-06-06' },
        ids    => [3],
    });

    # 19700101123456
    test_search({
        author => $author,
        params => { %params, date_time_field_id => $cf_id5, timefrom => '12:34:55', timeto => '12:34:57' },
        ids    => [3],
    });
};

done_testing;
