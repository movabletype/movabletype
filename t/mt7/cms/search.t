#!/usr/bin/perl

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
use MT::Test::App qw(MT::Test::Role::CMS::Search);
use Test::Deep qw(cmp_bag);
use MT::Test::Fixture::SearchReplace;

$test_env->prepare_fixture('search_replace');

my $objs    = MT::Test::Fixture::SearchReplace->load_objs;
my $author  = MT->model('author')->load(1);
my $blog_id = $objs->{blog_id};
my $ct_id   = $objs->{content_type}{ct_multi}{content_type}->id;
my $ct2_id  = $objs->{content_type}{ct_field_label}{content_type}->id;

subtest 'unit test MT::CMS::Search::make_terms_for_plain_search and make_terms' => sub {
    require MT::CMS::Search;
    my $terms;
    my $like = { 'escape' => '!', 'op' => 'like', 'value' => '%baz%' };

    $terms = MT::CMS::Search::make_terms_for_plain_search({ foo => 'foo1' }, ['c1'], 'baz');
    is_deeply($terms, [{ 'foo' => 'foo1' }, '-and', [{ 'c1' => $like }]]);

    $terms = MT::CMS::Search::make_terms_for_plain_search({ foo => 'foo1' }, [], 'baz');
    is_deeply($terms, [{ 'foo' => 'foo1' }]);

    $terms = MT::CMS::Search::make_terms_for_plain_search({ foo => 'foo1' }, ['c1', 'c2'], 'baz');
    is_deeply($terms, [{ 'foo' => 'foo1' }, '-and', [{ 'c1' => $like }, '-or', { 'c2' => $like }]]);

    $terms = MT::CMS::Search::make_terms_for_plain_search({ foo => 'foo1' }, ['id', 'c2'], 'baz');
    is_deeply($terms, [{ 'foo' => 'foo1' }, '-and', [{ 'id' => 'baz' }, '-or', { 'c2' => $like }]]);

    $terms = MT::CMS::Search::make_terms_for_plain_search({ foo => 'foo1' }, ['c1', 'id'], 'baz');
    is_deeply($terms, [{ 'foo' => 'foo1' }, '-and', [{ 'c1' => $like }, '-or', { 'id' => 'baz' }]]);

    $terms = MT::CMS::Search::make_terms_for_plain_search({ foo => 'foo1' }, ['__field:c1'], 'baz');
    is_deeply($terms, [{ 'foo' => 'foo1' }, '-and', [{ '__field:c1' => $like }]]);

    $terms = MT::CMS::Search::make_terms_for_plain_search({ foo => 'foo1' }, ['__field:1'], 'baz');
    is_deeply($terms, [{ 'foo' => 'foo1' }, '-and', [{ id => 0 }]]);

    $terms = MT::CMS::Search::make_terms_for_plain_search({ foo => 'foo1' }, [], 'baz');
    is_deeply($terms, [{ 'foo' => 'foo1' }]);

    $terms = MT::CMS::Search::make_terms({ foo => 'foo1' }, ['c1'], 'baz');
    is_deeply($terms, [{ 'foo' => 'foo1' }, '-and', [{ 'c1' => $like }]]);

    $terms = MT::CMS::Search::make_terms({ content_type_id => 1, foo => 'foo1' }, [], 'baz');
    if (MT->config->DisableRegexpSearch) {
        is_deeply($terms, [{ 'content_type_id' => 1, 'foo' => 'foo1' }]);
    } else {
        is_deeply($terms, []);
    }

    $terms = MT::CMS::Search::make_terms({ content_type_id => 1, foo => 'foo1' }, ['c1'], 'baz');
    if (MT->config->DisableRegexpSearch) {
        is_deeply($terms, [{ 'content_type_id' => 1, 'foo' => 'foo1' }, '-and', [{ 'c1' => $like }]]);
    } else {
        is_deeply($terms, []);
    }

    $terms = MT::CMS::Search::make_terms({ content_type_id => 1, foo => 'foo1' }, ['__field:c1'], 'baz');
    if (MT->config->DisableRegexpSearch) {
        is_deeply($terms, [{ 'content_type_id' => 1, 'foo' => 'foo1' }, '-and', [{ '__field:c1' => $like }]]);
    } else {
        is_deeply($terms, []);
    }

    $terms = MT::CMS::Search::make_terms({ content_type_id => 1, foo => 'foo1' }, ['__field:1'], 'baz');
    if (MT->config->DisableRegexpSearch) {
        is_deeply($terms->[2][0], { id => 0 });
        like(ref($terms->[2][2]{id}{value}), qr/::SQL/);
    } else {
        is_deeply($terms, []);
    }
};

subtest 'unit test for cd_idx_sub_query' => sub {
    my $cf_varchar = $objs->{content_type}{ct_multi}{content_field}{cf_single_line_text}->id;
    my $cf_text    = $objs->{content_type}{ct_multi}{content_field}{cf_multi_line_text}->id;
    my $cf_integer = $objs->{content_type}{ct_multi}{content_field}{cf_image}->id;
    my $cf_double  = $objs->{content_type}{ct_multi}{content_field}{cf_number}->id;
    require MT::CMS::Search;
    subtest 'basic' => sub {
        my $stmt = MT::CMS::Search::cd_idx_sub_query('foo', $ct_id, [$cf_varchar, $cf_text]);
        my $sql  = $stmt->as_sql;
        like $sql,   qr/cf_idx_value_varchar/;
        like $sql,   qr/cf_idx_value_text/;
        unlike $sql, qr/cf_idx_value_integer/;
        unlike $sql, qr/cf_idx_value_float/;
        unlike $sql, qr/cf_idx_value_double/;
    };
    subtest 'floating number' => sub {
        my $stmt = MT::CMS::Search::cd_idx_sub_query('0.1', $ct_id, [$cf_double]);
        my $sql  = $stmt->as_sql;
        unlike $sql, qr/cf_idx_value_integer/;
        unlike $sql, qr/cf_idx_value_float/;
        like $sql,   qr/cf_idx_value_double/;
    };
    subtest 'number' => sub {
        my $stmt = MT::CMS::Search::cd_idx_sub_query('123', $ct_id, [$cf_integer]);
        my $sql  = $stmt->as_sql;
        like $sql, qr/cf_idx_value_integer/;
    };
    subtest 'content_type_id not specified' => sub {
        my $stmt = MT::CMS::Search::cd_idx_sub_query('foo', undef, [$cf_varchar]);
        my $sql  = $stmt->as_sql;
        unlike $sql, qr/cf_idx_content_type_id = \?/;
    };
    subtest 'cf id is not given' => sub {
        my $stmt = MT::CMS::Search::cd_idx_sub_query('foo', $ct_id, []);
        is $stmt, undef;
    };
    subtest 'cols limited' => sub {
        my $stmt = MT::CMS::Search::cd_idx_sub_query('foo', 1, [11, 12]);
        my $sql  = $stmt->as_sql;
        like $sql, qr/cf_id IN \(\?,\?\)/;
    };
};

subtest 'content_data' => sub {
    my $app = MT::Test::App->new;
    $app->login($author);
    $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
    $app->change_tab('content_data');
    $app->change_content_type($ct_id);

    subtest 'basic' => sub {
        $app->search('text', {});
        is_deeply($app->found_titles, ['cd_multi2', 'cd_multi']);
        is_deeply($app->found_highlighted_values, [
            'test single line text multi2',
            'test multi line text2 aaaaa',
            'test single line text multi1',
            'test multi line text aaaaa',
        ], 'right values');

        $app->search('single line text', {});
        is_deeply($app->found_titles, ['cd_multi2', 'cd_multi']);
        is_deeply($app->found_highlighted_values, [
            'test single line text multi2',
            'test single line text multi1',
        ], 'right values');
    };

    subtest 'is_limited' => sub {
        my $cf_id1 = $objs->{content_type}{ct_multi}{content_field}{cf_single_line_text}->id;
        my $cf_id2 = $objs->{content_type}{ct_multi}{content_field}{cf_multi_line_text}->id;

        my %params = (is_limited => 1);
        $app->search('text', { %params, search_cols => ['__field:' . $cf_id1] });
        is_deeply($app->found_titles, ['cd_multi2', 'cd_multi']);
        is_deeply($app->found_highlighted_values, [
            'test single line text multi2',
            'test single line text multi1',
        ], 'right values');

        $app->search('multi1', { %params, search_cols => ['__field:' . $cf_id1] });
        is_deeply($app->found_titles, ['cd_multi']);
        is_deeply($app->found_highlighted_values, [
            'test single line text multi1',
        ], 'right values');

        $app->search('text', { %params, search_cols => ['__field:' . $cf_id2] });
        is_deeply($app->found_titles, ['cd_multi2', 'cd_multi']);
        is_deeply($app->found_highlighted_values, [
            'test multi line text2 aaaaa',
            'test multi line text aaaaa',
        ], 'right values');

        $app->search('text2', { %params, search_cols => ['__field:' . $cf_id2] });
        is_deeply($app->found_titles, ['cd_multi2']);
        is_deeply($app->found_highlighted_values, [
            'test multi line text2 aaaaa',
        ], 'right values');

        subtest 'change content_type_id' => sub {
            my $ct_id3 = $objs->{content_type}{ct}{content_type}->id;
            my $cf_id3 = $objs->{content_type}{ct}{content_field}{cf_multi_line_text}->id;
            $app->change_content_type($ct_id3);
            $app->search('text', { search_cols => ['__field:' . $cf_id3] });
            is_deeply($app->found_titles, ['cd']);

            subtest 'illigal cf set (for testing test class)' => sub {
                $app->search('text', { search_cols => ['__field:' . $cf_id2] });
                unlike($app->{cgi}->query_string, qr/search_cols=/, 'illigal search_col is ignored');
                is_deeply($app->found_titles, ['cd']);
            };
            is_deeply($app->found_highlighted_values, [
                'test single line text',
                'test multi line text aaaaa',
            ], 'right values');
        };
    };

    subtest 'search recursively hits data_label' => sub {
        plan skip_all => 'skip for now (MTC-29012)' if MT->config->DisableRegexpSearch;
        $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
        $app->change_tab('content_data');
        $app->change_content_type($ct2_id);
        $app->search('single line text for label', {
            is_limited => 1,
            search_cols => ['label'],
        });
        is_deeply($app->found_titles, ['test single line text for label2', 'test single line text for label']);
        is_deeply($app->found_highlighted_values, [
            'test single line text for label2',
            'test single line text for label',
        ], 'right values');
    };

    subtest 'search specific fields' => sub {
        my $cfs = $objs->{content_type}{ct_multi}{content_field};

        my $tag1     = MT::Test::Permission->make_tag(name => 'xyz061');
        my $tag2     = MT::Test::Permission->make_tag(name => 'xyz062');
        my $cat1     = MT::Test::Permission->make_category(label => 'xyz071');
        my $cat2     = MT::Test::Permission->make_category(label => 'xyz072');
        my $image_id = $objs->{image}->{'test2.jpg'}->id;

        # create matrix data
        #    |field1  |field2  |field3  |...
        # cd1|xyz01   |        |        |
        # cd2|        |xyz02   |        |
        # cd3|        |        |xyz03   |
        # ...
        my %cf_tests = (
            cf_single_line_text => { value => "xyz01 xyz01",                    search => 'xyz01' },
            cf_multi_line_text  => { value => "xyz02\nxyz02",                   search => 'xyz02' },
            cf_number           => { value => '9992598785499925987854',         search => '25987854' },
            cf_url              => { value => 'https://example.jp/xyz03/xyz03', search => 'xyz03' },
            cf_embedded_text    => { value => 'xyz04 \n xyz04',                 search => 'xyz04' },
            cf_select_box       => { value => [1, 1],                           search => 'abc' },
            cf_radio            => { value => [2, 2],                           search => 'def' },
            cf_checkboxes       => { value => [3, 3],                           search => 'ghi' },
            cf_list             => { value => ['xyz051', 'xyz052', 'unknown'],  search => 'xyz05' },
            cf_tags             => { value => [$tag1->id, $tag2->id],           search => 'xyz06' },
            cf_categories       => { value => [$cat1->id, $cat2->id],           search => 'xyz07' },
            cf_image            => { value => [$image_id],                      search => 'Sample Image' },
        );
        my @cds;
        my $authored_on = 20230612223000;
        for my $field (sort keys %cf_tests) {
            my $cd = MT::Test::Permission->make_content_data(
                authored_on     => $authored_on++,
                blog_id         => $blog_id,
                content_type_id => $ct_id,
                identifier      => $field,
                label           => $field,
                data            => { $cfs->{$field}->id => $cf_tests{$field}->{value} },
            );
            push @cds, $cd;
        }
        push @cds, MT::Test::Permission->make_content_data(
            authored_on     => $authored_on++,
            blog_id         => $blog_id,
            content_type_id => $ct_id,
            identifier      => "label",
            label           => "label-xyz08",
            data            => { $cfs->{cf_single_line_text}->id => "NOT INTERESTED" },
        );
        push @cds, MT::Test::Permission->make_content_data(
            authored_on     => $authored_on++,
            blog_id         => $blog_id,
            content_type_id => $ct_id,
            identifier      => "identifier-xyz09",
            label           => "identifier",
            data            => { $cfs->{cf_single_line_text}->id => "NOT INTERESTED" },
        );

        my $app = MT::Test::App->new;
        $app->login($author);
        $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
        $app->change_tab('content_data');
        $app->change_content_type($ct_id);

        # add daterange params for following tests
        $app->search(
            'xyz', {
                is_dateranged      => 1,
                date_time_field_id => 0,
                from               => '20230612223000',
                to                 => '20230612223100',
            });

        subtest 'search for label' => sub {
            $app->search('xyz08');
            is_deeply $app->found_titles, ['label-xyz08'], 'right title';
            is_deeply($app->found_highlighted_values, ['label-xyz08'], 'right values');
        };

        subtest 'search for identifier' => sub {
            $app->search('xyz09');
            is_deeply $app->found_titles, ['identifier'], 'right title';
            is_deeply($app->found_highlighted_values, ['identifier-xyz09'], 'right values');
        };

        my %ref_fields =
            map { $_ => 1 } ('cf_categories', 'cf_tags', 'cf_select_box', 'cf_radio', 'cf_checkboxes', 'cf_image');

        for my $field (sort keys %cf_tests) {
            subtest "search for $field" => sub {
                plan skip_all => 'skip for now (MTC-29012)'
                    if MT->config->DisableRegexpSearch && $ref_fields{$field};
                my $search = $cf_tests{$field}->{search};
                my $value  = $cf_tests{$field}->{value};
                $app->search($search);
                is_deeply $app->found_titles, [$field], 'right title';
                unless ($ref_fields{$field}) {
                    my $flatten = $value;
                    $flatten = join(', ', @$flatten) if ref($flatten) eq 'ARRAY';
                    $flatten =~ s/\n/ /;
                    my $count = () = $flatten =~ /$search/g;
                    is_deeply($app->found_highlighted_values, [($flatten) x $count], 'right highlights');
                }
            };
        }

        subtest 'multiple results in right order' => sub {
            $app->search('xyz');
            my @fields = (
                'identifier',
                'label-xyz08',
                'cf_url',
                'cf_tags',
                'cf_single_line_text',
                'cf_multi_line_text',
                'cf_list',
                'cf_embedded_text',
                'cf_categories',
            );
            @fields = grep { !$ref_fields{$_} } @fields if MT->config->DisableRegexpSearch;
            is_deeply $app->found_titles, \@fields, 'right title';
        };

        subtest 'no result' => sub {
            $app->search('xyz9999');
            is_deeply $app->found_titles, [], 'right title';
            is_deeply($app->found_highlighted_values, [], 'right values');
        };

        subtest 'TODO: reference ids unexpectedly be hit' => sub {
            plan skip_all => 'test for MT_TEST_DISABLE_REGEXP_SEARCH=1'
                unless MT->config->DisableRegexpSearch;

            local $cf_tests{cf_categories}->{search} = $cat1->id;
            local $cf_tests{cf_tags}->{search}       = $tag1->id;
            local $cf_tests{cf_select_box}->{search} = 1;
            local $cf_tests{cf_radio}->{search}      = 2;
            local $cf_tests{cf_checkboxes}->{search} = 3;
            local $cf_tests{cf_image}->{search}      = $image_id;

            for my $field (keys %ref_fields) {
                subtest $field => sub {
                    my $search = $cf_tests{$field}->{search};
                    my $value  = $cf_tests{$field}->{value};
                    $app->search($search, { is_limited => 1, search_cols => ['__field:' . $cfs->{$field}->id] });
                    is_deeply $app->found_titles, [$field], 'right title';
                };
            }
            # drop is_limited for following tests
            $app->search('xyz02', { is_limited => 0 });
        };

        subtest 'CMSSearchLimit' => sub {
            my $cms_search_limit_org = MT->config('CMSSearchLimit');
            $test_env->update_config(CMSSearchLimit => 1);

            $app->search('xyz02');
            is_deeply($app->found_titles, ['cf_multi_line_text']);
            ok !$app->have_more_link_exists;

            subtest 'have more link exists' => sub {
                $app->search('xyz');
                is_deeply($app->found_titles, ['identifier']);
                ok $app->have_more_link_exists;
            };

            $test_env->update_config(CMSSearchLimit => $cms_search_limit_org);
        };

        $_->remove for @cds;
    };

    subtest 'with daterange' => sub {
        my $cfs   = $objs->{content_type}{ct_multi}{content_field};
        my @dates = (
            '2010-05-15 10:30:30',
            '2011-06-15 11:20:30',
            '2011-06-15 11:30:30',    # daterange1
            '2011-06-15 11:40:30',
            '2012-07-15 12:30:30',
            '2013-08-15 13:20:30',
            '2013-08-15 13:30:30',    # daterange2
            '2013-08-15 13:40:30',
            '2014-09-15 14:30:30',
        );
        my $non_target = '2035-01-01 00:00:00';
        my %cds;
        for my $field ('authored_on', 'cf_datetime', 'cf_date', 'cf_time') {
            my %fcds = map {
                my $org         = $_;
                my $format_date = sub {
                    my ($ts, $format) = @_;
                    my @parted = split(/\D/, $ts);
                    return sprintf('%04d%02d%02d%02d%02d%02d', @parted) if $format eq 'datetime';
                    return sprintf('%04d%02d%02d', @parted[0, 1, 2]) if $format eq 'date';
                    return '19700101' . sprintf('%02d%02d%02d', @parted[3, 4, 5]) if $format eq 'time';
                };
                my $authored_on = $format_date->($field eq 'authored_on' ? $org : $non_target, 'datetime');
                my $datetime    = $format_date->($field eq 'cf_datetime' ? $org : $non_target, 'datetime');
                my $date        = $format_date->($field eq 'cf_date'     ? $org : $non_target, 'date');
                my $time        = $format_date->($field eq 'cf_time'     ? $org : $non_target, 'time');
                my $cd          = MT::Test::Permission->make_content_data(
                    authored_on     => $authored_on,
                    blog_id         => $blog_id,
                    content_type_id => $ct_id,
                    identifier      => $org,
                    label           => $field . '-daterangetest-' . $org,
                    data            => {
                        $cfs->{cf_datetime}->id => $datetime,
                        $cfs->{cf_date}->id     => $date,
                        $cfs->{cf_time}->id     => $time,
                    },
                );
                ($org => $cd);
            } List::Util::shuffle @dates;
            $cds{$field} = \%fcds;
        }

        my $app = MT::Test::App->new;
        $app->login($author);
        $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
        $app->change_tab('content_data');
        $app->change_content_type($ct_id);

        my ($date2, $time2) = split(/ /, $dates[2]);
        my ($date6, $time6) = split(/ /, $dates[6]);
        my ($field, $fcds);
        my $test = sub {
            my ($from, $timefrom, $to, $timeto) = @_;
            note join(', ', $from, $timefrom, $to, $timeto);
            $app->search(
                $field . '-daterangetest-', {
                    is_dateranged      => 1,
                    date_time_field_id => ($cfs->{$field} ? $cfs->{$field}->id : 0),
                    from               => $from,
                    timefrom           => $timefrom,
                    to                 => $to,
                    timeto             => $timeto,
                });
            return $app->found_titles;
        };
        my $date_id_to_label = sub {
            return [map { $_->label } @$fcds{ @dates[@_] }];
        };

        subtest 'authored_on' => sub {
            $field = 'authored_on';
            $fcds  = $cds{$field};
            cmp_bag($test->($date2, '', $date6, ''), $date_id_to_label->(1 .. 7), 'normal');
            cmp_bag($test->($date6, '', $date2, ''), $date_id_to_label->(1 .. 7), 'negative range');

            subtest 'unset or half set daterange' => sub {
                plan skip_all => 'incomplete daterange';
                cmp_bag($test->('',     '', $date2, ''), $date_id_to_label->(0 .. 3), 'to only');
                cmp_bag($test->($date2, '', '',     ''), $date_id_to_label->(1 .. 8), 'from only');
                cmp_bag($test->('',     '', $date6, ''), $date_id_to_label->(0 .. 7), 'to only2');
                cmp_bag($test->($date6, '', '',     ''), $date_id_to_label->(5 .. 8), 'from only2');
                cmp_bag($test->('',     '', '',     ''), $date_id_to_label->(0 .. 8), 'no params');
            };
        };

        subtest 'cf_datetime' => sub {
            $field = 'cf_datetime';
            $fcds  = $cds{$field};
            cmp_bag($test->($date2, '', $date6, ''), $date_id_to_label->(1 .. 7), 'normal');
            cmp_bag($test->($date6, '', $date2, ''), $date_id_to_label->(1 .. 7), 'negative range');

            subtest 'unset or half set daterange' => sub {
                plan skip_all => 'incomplete daterange';
                cmp_bag($test->('',     '', $date2, ''), $date_id_to_label->(0 .. 3), 'to only');
                cmp_bag($test->($date2, '', '',     ''), $date_id_to_label->(1 .. 8), 'from only');
                cmp_bag($test->('',     '', $date6, ''), $date_id_to_label->(0 .. 7), 'to only2');
                cmp_bag($test->($date6, '', '',     ''), $date_id_to_label->(5 .. 8), 'from only2');

                subtest 'with time' => sub {
                    plan skip_all => 'mot implemented';
                    cmp_bag($test->($date2, $time2, $date6, $time6), $date_id_to_label->(2 .. 6), 'normal');
                    cmp_bag($test->($date6, $time6, $date2, $time2), $date_id_to_label->(2 .. 6), 'negative range');
                    cmp_bag($test->('',     '',     $date2, $time2), $date_id_to_label->(0 .. 2), 'to only');
                    cmp_bag($test->($date2, $time2, '',     ''),     $date_id_to_label->(2 .. 8), 'from only');
                    cmp_bag($test->('',     '',     $date6, $time6), $date_id_to_label->(0 .. 6), 'to only2');
                    cmp_bag($test->($date6, $time6, '',     ''),     $date_id_to_label->(6 .. 8), 'from only2');
                };

                subtest 'eccentric cases' => sub {
                    cmp_bag($test->($date6, '',     $date6, $time6), $date_id_to_label->(5 .. 6), 'within a day');
                    cmp_bag($test->($date6, $time6, $date6, ''),     $date_id_to_label->(5 .. 6), 'within a day');
                    cmp_bag($test->($date6, '',     '',     $time6), $date_id_to_label->(5 .. 8), 'within a day');
                    cmp_bag($test->('',     $time6, $date6, ''),     $date_id_to_label->(0 .. 7), 'within a day');
                };
            };
        };

        subtest 'cf_date' => sub {
            $field = 'cf_date';
            $fcds  = $cds{$field};
            cmp_bag($test->($date2, '', $date6, ''), $date_id_to_label->(1 .. 7), 'normal');
            cmp_bag($test->($date6, '', $date2, ''), $date_id_to_label->(1 .. 7), 'negative range');

            subtest 'unset or half set daterange' => sub {
                plan skip_all => 'incomplete daterange';
                cmp_bag($test->('',     '', $date2, ''), $date_id_to_label->(0 .. 3), 'to only');
                cmp_bag($test->($date2, '', '',     ''), $date_id_to_label->(1 .. 8), 'from only');
                cmp_bag($test->('',     '', $date6, ''), $date_id_to_label->(0 .. 7), 'to only2');
                cmp_bag($test->($date6, '', '',     ''), $date_id_to_label->(5 .. 8), 'from only2');
            };
        };

        subtest 'cf_time' => sub {
            $field = 'cf_time';
            $fcds  = $cds{$field};
            cmp_bag($test->('', $time2, '', $time6), $date_id_to_label->(2 .. 6), 'normal');
            cmp_bag($test->('', $time6, '', $time2), $date_id_to_label->(2 .. 6), 'negative range');

            subtest 'unset or half set daterange' => sub {
                plan skip_all => 'incomplete daterange';
                cmp_bag($test->('', '',     '', $time2), $date_id_to_label->(0 .. 2), 'to only');
                cmp_bag($test->('', $time2, '', ''),     $date_id_to_label->(2 .. 8), 'from only');
                cmp_bag($test->('', '',     '', $time6), $date_id_to_label->(0 .. 6), 'to only2');
                cmp_bag($test->('', $time6, '', ''),     $date_id_to_label->(6 .. 8), 'from only2');
            };
        };

        for my $fcds (values %cds) {
            $_->remove for values %$fcds;
        }
    };
};

subtest q{contaminated date_time_field_id on entry tab is ignored} => sub {
    my $entry = MT::Test::Permission->make_entry(
        blog_id     => $blog_id,
        author_id   => $author->id,
        title       => 'contamination-test',
        authored_on => '20010101120000',
    );
    my $cf_id = $objs->{content_type}{ct_multi}{content_field}{cf_datetime}->id;
    my $app   = MT::Test::App->new;
    $app->login($author);
    $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
    $app->change_tab('content_data');
    $app->change_content_type($ct_id);
    $app->search('a', { is_dateranged => 1, from => '2001-01-01', to => '2001-01-01', date_time_field_id => $cf_id });
    $app->change_tab('entry');
    ok !$app->generic_error, 'no error';
    is_deeply($app->found_titles, ['contamination-test'], 'search result is also good');
    $app->search('contamination-test', {});
    ok !$app->generic_error, 'no error';
    is_deeply($app->found_titles, ['contamination-test'], 'search result is also good');

    $entry->remove;
};

subtest 'template' => sub {
    my $app = MT::Test::App->new;
    $app->login($author);
    $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
    $app->change_tab('template');

    $app->search('author_yearly', { is_limited => 1, search_cols => 'name' });

    # XXX Fix the app to make search order predictable. We ignore the order for now.
    is_deeply(
        [sort @{ $app->found_titles }],
        [
            sort @{ [
                'tmpl_contenttype_author_yearly_Content Type',
                'tmpl_contenttype_author_yearly_case 0',
                'tmpl_contenttype_author_yearly_test content data',
                'tmpl_contenttype_author_yearly_test multiple content data',
                'tmpl_contenttype_author_yearly_test content data with field label',
                'tmpl_author_yearly',
            ] }
        ],
        'author_yearly templates hit'
    );
};

subtest 'asset' => sub {
    my $app = MT::Test::App->new;
    $app->login($author);
    $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
    $app->change_tab('asset');

    $app->search('Sample', { is_limited => 1, search_cols => 'label' });
    is_deeply($app->found_titles, ['Sample Image 1', 'Sample Image 2', 'Sample Image 3']);
};

subtest 'blog' => sub {
    my $app = MT::Test::App->new;
    $app->login($author);
    $app->get_ok({ __mode => 'search_replace', blog_id => 1 });
    $app->change_tab('blog');

    $app->search('site', { is_limited => 1, search_cols => 'name' });
    is_deeply($app->found_titles, ['My Site']);

    $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
    ok !$app->tab_exists('blog'), 'blog tab is not available';
};

subtest 'website' => sub {
    my $app = MT::Test::App->new;
    $app->login($author);
    $app->get_ok({ __mode => 'search_replace', blog_id => 0 });
    ok $app->tab_exists('website'), 'blog tab is available';
    $app->change_tab('website');
    $app->search('site', { is_limited => 1, search_cols => 'name' });
    is_deeply($app->found_titles, ['First Website']);
};

subtest 'content_data replace' => sub {
    my $cf_id1 = $objs->{content_type}{ct_multi}{content_field}{cf_single_line_text}->id;
    my $cf_id2 = $objs->{content_type}{ct_multi}{content_field}{cf_multi_line_text}->id;

    my @cds;
    for my $num (1 .. 3) {
        push @cds, MT::Test::Permission->make_content_data(
            authored_on     => '20181128181600',
            blog_id         => $blog_id,
            content_type_id => $ct_id,
            identifier      => "ReplaceTest $num identifier",
            label           => "ReplaceTest $num label",
            data            => {
                $cf_id1 => "ReplaceTest $num cf_single_line_text",
                $cf_id2 => "ReplaceTest $num cf_multi_line_text",
            },
        );
    }
    my @cd_ids = map { $_->id } @cds;

    my $app = MT::Test::App->new;
    $app->login($author);

    subtest 'basic' => sub {
        $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
        $app->change_tab('content_data');
        $app->change_content_type($ct_id);
        $app->search('ReplaceTest', {});
        is_deeply($app->found_ids, [@cd_ids[0, 1, 2]], 'found all');
        $app->replace('ReplaceTest-mod', [@cd_ids[0, 1]]);
        is_deeply($app->found_ids, [@cd_ids[1, 0]], 'selected ones are replaced');
        is_deeply($app->found_titles, [
            'ReplaceTest 2 label',
            'ReplaceTest 1 label'
        ], 'selected ones are replaced');

        my @reloaded = MT::ContentData->load({ id => \@cd_ids });
        is($reloaded[0]->identifier,      'ReplaceTest 1 identifier',              'identifier is not replaced');
        is($reloaded[1]->identifier,      'ReplaceTest 2 identifier',              'identifier is not replaced');
        is($reloaded[2]->identifier,      'ReplaceTest 3 identifier',              'identifier is not replaced');
        is($reloaded[0]->data->{$cf_id1}, 'ReplaceTest-mod 1 cf_single_line_text', 'replaced');
        is($reloaded[1]->data->{$cf_id1}, 'ReplaceTest-mod 2 cf_single_line_text', 'replaced');
        is($reloaded[2]->data->{$cf_id1}, 'ReplaceTest 3 cf_single_line_text',     'unchecked cd is not replaced');
        is($reloaded[0]->data->{$cf_id2}, 'ReplaceTest-mod 1 cf_multi_line_text',  'replaced');
        is($reloaded[1]->data->{$cf_id2}, 'ReplaceTest-mod 2 cf_multi_line_text',  'replaced');
        is($reloaded[2]->data->{$cf_id2}, 'ReplaceTest 3 cf_multi_line_text',      'unchecked cd is not replaced');
    };

    subtest 'do it again' => sub {
        $app->search('ReplaceTest', {});
        is_deeply($app->found_ids, [@cd_ids[0, 1, 2]], 'found all');
        $app->replace('ReplaceTest-mod', [@cd_ids[0, 1]]);
        is_deeply($app->found_ids, [@cd_ids[1, 0]], 'selected ones are replaced');
        is_deeply($app->found_titles, [
            'ReplaceTest 2 label',
            'ReplaceTest 1 label'
        ], 'selected ones are replaced');

        my @reloaded = MT::ContentData->load({ id => \@cd_ids });
        is($reloaded[0]->identifier,      'ReplaceTest 1 identifier',                  'identifier is not replaced');
        is($reloaded[1]->identifier,      'ReplaceTest 2 identifier',                  'identifier is not replaced');
        is($reloaded[2]->identifier,      'ReplaceTest 3 identifier',                  'identifier is not replaced');
        is($reloaded[0]->data->{$cf_id1}, 'ReplaceTest-mod-mod 1 cf_single_line_text', 'replaced');
        is($reloaded[1]->data->{$cf_id1}, 'ReplaceTest-mod-mod 2 cf_single_line_text', 'replaced');
        is($reloaded[2]->data->{$cf_id1}, 'ReplaceTest 3 cf_single_line_text',         'unchecked cd is not replaced');
        is($reloaded[0]->data->{$cf_id2}, 'ReplaceTest-mod-mod 1 cf_multi_line_text',  'replaced');
        is($reloaded[1]->data->{$cf_id2}, 'ReplaceTest-mod-mod 2 cf_multi_line_text',  'replaced');
        is($reloaded[2]->data->{$cf_id2}, 'ReplaceTest 3 cf_multi_line_text',          'unchecked cd is not replaced');
    };

    $_->remove for @cds;
};

done_testing;
