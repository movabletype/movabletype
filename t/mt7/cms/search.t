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

$test_env->prepare_fixture('search_replace');

my $objs    = MT::Test::Fixture::SearchReplace->load_objs;
my $author  = MT->model('author')->load(1);
my $blog_id = $objs->{blog_id};
my $ct_id   = $objs->{content_type}{ct_multi}{content_type}->id;

subtest 'content_data' => sub {
    subtest 'basic' => sub {
        my %params = (
            _type           => 'content_data',
            blog_id         => $blog_id,
            do_search       => 1,
            content_type_id => $ct_id,
        );
        test_search({
            author           => $author,
            params           => { %params, search => 'text' },
            expected_obj_ids => [
                $objs->{content_data}{cd_multi}->id,
                $objs->{content_data}{cd_multi2}->id,
            ],
        });
        test_search({
            author           => $author,
            params           => { %params, search => 'single line text' },
            expected_obj_ids => [
                $objs->{content_data}{cd_multi}->id,
                $objs->{content_data}{cd_multi2}->id,
            ],
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
            author           => $author,
            params           => { %params, search_cols => ['__field:' . $cf_id1], search => 'text' },
            expected_obj_ids => [
                $objs->{content_data}{cd_multi}->id,
                $objs->{content_data}{cd_multi2}->id,
            ],
        });
        test_search({
            author           => $author,
            params           => { %params, search_cols => ['__field:' . $cf_id1], search => 'multi1' },
            expected_obj_ids => [
                $objs->{content_data}{cd_multi}->id,
            ],
        });
        test_search({
            author           => $author,
            params           => { %params, search_cols => ['__field:' . $cf_id2], search => 'text' },
            expected_obj_ids => [
                $objs->{content_data}{cd_multi}->id,
                $objs->{content_data}{cd_multi2}->id,
            ],
        });
        test_search({
            author           => $author,
            params           => { %params, search_cols => ['__field:' . $cf_id2], search => 'text2' },
            expected_obj_ids => [
                $objs->{content_data}{cd_multi2}->id,
            ],
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
            author           => $author,
            params           => { %params, from => '2017-05-29', to => '2017-06-01' },
            expected_obj_ids => [
                $objs->{content_data}{cd_multi}->id,
                $objs->{content_data}{cd_multi2}->id,
            ],
        });
        test_search({
            author           => $author,
            params           => { %params, from => '2017-06-01', to => '2017-05-29' },
            expected_obj_ids => [
                $objs->{content_data}{cd_multi}->id,
                $objs->{content_data}{cd_multi2}->id,
            ],
        });
        test_search({
            author           => $author,
            params           => {%params},
            expected_obj_ids => [
                $objs->{content_data}{cd_multi}->id,
                $objs->{content_data}{cd_multi2}->id,
            ],
        });
        test_search({
            author           => $author,
            params           => {%params, from => '2017-05-29', to => undef},
            expected_obj_ids => [
                $objs->{content_data}{cd_multi}->id,
                $objs->{content_data}{cd_multi2}->id,
            ],
        });
        test_search({
            author           => $author,
            params           => {%params, from => undef, to => '2017-05-29'},
            expected_obj_ids => [],
        });
    };

    subtest 'dateranged for content fields' => sub {

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

        subtest 'type of datetime' => sub {
            $params{date_time_field_id} = $objs->{content_type}{ct_multi}{content_field}{cf_datetime}->id;

            subtest 'without time' => sub {
                # --[Date1]--[cd_multi]--[Date2]--[cd_multi2]--
                # cd_multi:  2017-06-03 18:05:00
                # cd_multi2: 2020-06-03 18:05:00
                my $date1 = '2017-06-02';
                my $date2 = '2017-06-04';

                test_search({
                    author           => $author,
                    params           => { %params, from => $date1, to => $date2 },
                    expected_obj_ids => [
                        $objs->{content_data}{cd_multi}->id,
                    ],
                });
                test_search({
                    author           => $author,
                    params           => { %params, to => $date1 },
                    expected_obj_ids => [],
                });
                test_search({
                    author           => $author,
                    params           => { %params, from => $date1 },
                    expected_obj_ids => [
                        $objs->{content_data}{cd_multi}->id,
                        $objs->{content_data}{cd_multi2}->id,
                    ],
                });
                test_search({
                    author           => $author,
                    params           => { %params, to => $date2 },
                    expected_obj_ids => [
                        $objs->{content_data}{cd_multi}->id,
                    ],
                });
                test_search({
                    author           => $author,
                    params           => { %params, from => $date2 },
                    expected_obj_ids => [
                        $objs->{content_data}{cd_multi2}->id,
                    ],
                });
            };

            subtest 'with time' => sub {
                plan skip_all => 'NOT IMPLEMENTED';
                # See also https://movabletype.atlassian.net/browse/MTC-27148

                # --[DateTime1]--[cd_multi]--[DateTime2]--[cd_multi2]--
                # cd_multi:  2017-06-03 18:05:00
                # cd_multi2: 2020-06-03 18:05:00
                my ($date1, $time1) = ('2017-06-03', '12:00:00');
                my ($date2, $time2) = ('2017-06-03', '19:00:00');

                test_search({
                    author           => $author,
                    params           => { %params, from => $date1, timefrom => $time1, to => $date2, timeto => $time2 },
                    expected_obj_ids => [
                        $objs->{content_data}{cd_multi}->id,
                    ],
                });
                test_search({
                    author           => $author,
                    params           => { %params, to => $date1, timeto => $time1 },
                    expected_obj_ids => [],
                });
                test_search({
                    author           => $author,
                    params           => { %params, from => $date1, timefrom => $time1 },
                    expected_obj_ids => [
                        $objs->{content_data}{cd_multi}->id,
                        $objs->{content_data}{cd_multi2}->id,
                    ],
                });
                test_search({
                    author           => $author,
                    params           => { %params, to => $date2, timeto => $time2 },
                    expected_obj_ids => [
                        $objs->{content_data}{cd_multi}->id,
                    ],
                });
                test_search({
                    author           => $author,
                    params           => { %params, from => $date2, timefrom => $time2 },
                    expected_obj_ids => [
                        $objs->{content_data}{cd_multi2}->id,
                    ],
                });
            };
        };

        subtest 'type of date' => sub {
            $params{date_time_field_id} = $objs->{content_type}{ct_multi}{content_field}{cf_date}->id;

            # --[Date1]--[cd_multi]--[Date2]--[cd_multi2]--
            # cd_multi:  2017-06-05
            # cd_multi2: 2020-06-05
            my $date1 = '2017-06-04';
            my $date2 = '2017-06-06';

            test_search({
                author           => $author,
                params           => { %params, from => $date1, to => $date2 },
                expected_obj_ids => [
                    $objs->{content_data}{cd_multi}->id,
                ],
            });
            test_search({
                author           => $author,
                params           => { %params, to => $date1 },
                expected_obj_ids => [],
            });
            test_search({
                author           => $author,
                params           => { %params, from => $date1 },
                expected_obj_ids => [
                    $objs->{content_data}{cd_multi}->id,
                    $objs->{content_data}{cd_multi2}->id,
                ],
            });
            test_search({
                author           => $author,
                params           => { %params, to => $date2 },
                expected_obj_ids => [
                    $objs->{content_data}{cd_multi}->id,
                ],
            });
            test_search({
                author           => $author,
                params           => { %params, from => $date2 },
                expected_obj_ids => [
                    $objs->{content_data}{cd_multi2}->id,
                ],
            });
        };

        subtest 'type of time' => sub {
            $params{date_time_field_id} = $objs->{content_type}{ct_multi}{content_field}{cf_time}->id;

            # --[Time1]--[cd_multi]--[Time2]--[cd_multi2]--
            # cd_multi:  12:34:56
            # cd_multi2: 15:34:56
            my $time1 = '12:34:55';
            my $time2 = '12:34:57';

            test_search({
                author           => $author,
                params           => { %params, timefrom => $time1, timeto => $time2 },
                expected_obj_ids => [
                    $objs->{content_data}{cd_multi}->id,
                ],
            });
            test_search({
                author           => $author,
                params           => { %params, timeto => $time1 },
                expected_obj_ids => [],
            });
            test_search({
                author           => $author,
                params           => { %params, timefrom => $time1 },
                expected_obj_ids => [
                    $objs->{content_data}{cd_multi}->id,
                    $objs->{content_data}{cd_multi2}->id,
                ],
            });
            test_search({
                author           => $author,
                params           => { %params, timeto => $time2 },
                expected_obj_ids => [
                    $objs->{content_data}{cd_multi}->id,
                ],
            });
            test_search({
                author           => $author,
                params           => { %params, timefrom => $time2 },
                expected_obj_ids => [
                    $objs->{content_data}{cd_multi2}->id,
                ],
            });
        };
    };
};

subtest 'template' => sub {
    my %params = (
        _type           => 'template',
        blog_id         => $blog_id,
        do_search       => 1,
        is_limited      => 1,
        search_cols     => 'name',
    );
    test_search({
        author                    => $author,
        params                    => { %params, search => 'author_yearly' },
        expected_obj_ignore_order => 1, # XXX Fix the app to make search order predictable
        expected_obj_names        => [
            'tmpl_contenttype_author_yearly_Content Type',
            'tmpl_contenttype_author_yearly_case 0',
            'tmpl_contenttype_author_yearly_test content data',
            'tmpl_contenttype_author_yearly_test multiple content data',
            'tmpl_author_yearly',
        ],
    });
};

subtest 'asset' => sub {
    my %params = (
        _type       => 'asset',
        blog_id     => $blog_id,
        do_search   => 1,
        is_limited  => 1,
        search_cols => 'label',
    );
    test_search({
        author             => $author,
        params             => { %params, search => 'Sample' },
        expected_obj_names => [
            'Sample Image 1',
            'Sample Image 2',
            'Sample Image 3',
        ],
    });
};

subtest 'blog' => sub {
    my %params = (
        _type       => 'blog',
        do_search   => 1,
        is_limited  => 1,
        search_cols => 'name',
    );
    test_search({
        author             => $author,
        params             => { %params, search => 'site' },
        expected_obj_names => ['My Site'],
    });
};

subtest 'website' => sub {
    my %params = (
        _type       => 'website',
        do_search   => 1,
        is_limited  => 1,
        search_cols => 'name',
    );
    test_search({
        author             => $author,
        params             => { %params, search => 'site' },
        expected_obj_names => ['First Website'],
    });
};

done_testing;
