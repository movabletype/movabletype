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
use Test::Deep 'cmp_bag';
use MT::Test::Fixture::SearchReplace;

$test_env->prepare_fixture('search_replace');

my $objs    = MT::Test::Fixture::SearchReplace->load_objs;
my $author  = MT->model('author')->load(1);
my $blog_id = $objs->{blog_id};
my $ct_id   = $objs->{content_type}{ct_multi}{content_type}->id;

subtest 'content_data' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);
    $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
    $app->change_tab('content_data');
    $app->change_content_type($ct_id);

    subtest 'basic' => sub {
        $app->search('text', {});
        is_deeply($app->found_titles, ['cd_multi2', 'cd_multi']);

        $app->search('single line text', {});
        is_deeply($app->found_titles, ['cd_multi2', 'cd_multi']);
    };

    subtest 'is_limited' => sub {
        my $cf_id1 = $objs->{content_type}{ct_multi}{content_field}{cf_single_line_text}->id;
        my $cf_id2 = $objs->{content_type}{ct_multi}{content_field}{cf_multi_line_text}->id;

        my %params = (is_limited => 1);
        $app->search('text', { %params, search_cols => ['__field:' . $cf_id1] });
        is_deeply($app->found_titles, ['cd_multi2', 'cd_multi']);

        $app->search('multi1', { %params, search_cols => ['__field:' . $cf_id1] });
        is_deeply($app->found_titles, ['cd_multi']);

        $app->search('text', { %params, search_cols => ['__field:' . $cf_id2] });
        is_deeply($app->found_titles, ['cd_multi2', 'cd_multi']);

        $app->search('text2', { %params, search_cols => ['__field:' . $cf_id2] });
        is_deeply($app->found_titles, ['cd_multi2']);

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
        };
    };

    subtest 'limit' => sub {
        my $cfs = $objs->{content_type}{ct_multi}{content_field};
        my $cd = MT::Test::Permission->make_content_data(
            authored_on     => '19810612223059', # oldest
            blog_id         => $blog_id,
            content_type_id => $ct_id,
            identifier      => "oldest",
            label           => "oldest",
            data            => {
                $cfs->{cf_single_line_text}->id => "oldest",
            },
        );


        subtest 'default limit' => sub {
            $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
            $app->change_tab('content_data');
            $app->change_content_type($ct_id);
            my $cf_id1 = $objs->{content_type}{ct_multi}{content_field}{cf_single_line_text}->id;
            $app->search('oldest', { is_limited => 1, search_cols => ['__field:' . $cf_id1] });
            is_deeply($app->found_titles, ['oldest']);
            ok !$app->have_more_link_exists;
        };

        subtest 'CMSSearchLimit is 1' => sub {

            my $cms_search_limit_org = MT->config('CMSSearchLimit');
            MT->config('CMSSearchLimit', 1);

            $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
            $app->change_tab('content_data');
            $app->change_content_type($ct_id);
            my $cf_id1 = $objs->{content_type}{ct_multi}{content_field}{cf_single_line_text}->id;
            $app->search('oldest', { is_limited => 1, search_cols => ['__field:' . $cf_id1] });
            is_deeply($app->found_titles, []);
            ok !$app->have_more_link_exists;

            subtest 'CMSSearchLimitContentData is 10' => sub {

                my $cms_search_limit_org = MT->config('CMSSearchLimitContentData');
                MT->config('CMSSearchLimitContentData', 10);

                $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
                $app->change_tab('content_data');
                $app->change_content_type($ct_id);
                my $cf_id1 = $objs->{content_type}{ct_multi}{content_field}{cf_single_line_text}->id;
                $app->search('oldest', { is_limited => 1, search_cols => ['__field:' . $cf_id1] });
                is_deeply($app->found_titles, ['oldest']);
                ok !$app->have_more_link_exists;

                MT->config('CMSSearchLimitContentData', $cms_search_limit_org);
            };

            MT->config('CMSSearchLimit', $cms_search_limit_org);
        };

        subtest 'CMSSearchLimit does not affect other tabs' => sub {
            my $cms_search_limit_org    = MT->config('CMSSearchLimit');
            my $cms_search_limit_org_cd = MT->config('CMSSearchLimitContentData');
            MT->config('CMSSearchLimit',            50);
            MT->config('CMSSearchLimitContentData', 10);
            $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
            $app->change_tab('content_data');
            is $app->find_searchform('search_form')->find_input('limit')->value, 10;
            $app->change_tab('entry');
            is $app->find_searchform('search_form')->find_input('limit')->value, 50;
            MT->config('CMSSearchLimitContentData', $cms_search_limit_org_cd);
            MT->config('CMSSearchLimit',            $cms_search_limit_org);
        };

        $cd->remove();
    };
};

subtest 'content_data with daterange' => sub {
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

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);
    $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
    $app->change_tab('content_data');
    $app->change_content_type($ct_id);

    my ($date2, $time2) = split(/ /, $dates[2]);
    my ($date6, $time6) = split(/ /, $dates[6]);
    my ($field, $fcds);
    my $search = sub {
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
        cmp_bag($search->($date2, '', $date6, ''), $date_id_to_label->(1 .. 7), 'normal');
        cmp_bag($search->($date6, '', $date2, ''), $date_id_to_label->(1 .. 7), 'negative range');

        subtest 'unset or half set daterange' => sub {
            plan skip_all => 'incomplete daterange';
            cmp_bag($search->('',     '', $date2, ''), $date_id_to_label->(0 .. 3), 'to only');
            cmp_bag($search->($date2, '', '',     ''), $date_id_to_label->(1 .. 8), 'from only');
            cmp_bag($search->('',     '', $date6, ''), $date_id_to_label->(0 .. 7), 'to only2');
            cmp_bag($search->($date6, '', '',     ''), $date_id_to_label->(5 .. 8), 'from only2');
            cmp_bag($search->('',     '', '',     ''), $date_id_to_label->(0 .. 8), 'no params');
        };
    };

    subtest 'cf_datetime' => sub {
        $field = 'cf_datetime';
        $fcds  = $cds{$field};
        cmp_bag($search->($date2, '', $date6, ''), $date_id_to_label->(1 .. 7), 'normal');
        cmp_bag($search->($date6, '', $date2, ''), $date_id_to_label->(1 .. 7), 'negative range');

        subtest 'unset or half set daterange' => sub {
            plan skip_all => 'incomplete daterange';
            cmp_bag($search->('',     '', $date2, ''), $date_id_to_label->(0 .. 3), 'to only');
            cmp_bag($search->($date2, '', '',     ''), $date_id_to_label->(1 .. 8), 'from only');
            cmp_bag($search->('',     '', $date6, ''), $date_id_to_label->(0 .. 7), 'to only2');
            cmp_bag($search->($date6, '', '',     ''), $date_id_to_label->(5 .. 8), 'from only2');

            subtest 'with time' => sub {
                plan skip_all => 'mot implemented';
                cmp_bag($search->($date2, $time2, $date6, $time6), $date_id_to_label->(2 .. 6), 'normal');
                cmp_bag($search->($date6, $time6, $date2, $time2), $date_id_to_label->(2 .. 6), 'negative range');
                cmp_bag($search->('',     '',     $date2, $time2), $date_id_to_label->(0 .. 2), 'to only');
                cmp_bag($search->($date2, $time2, '',     ''),     $date_id_to_label->(2 .. 8), 'from only');
                cmp_bag($search->('',     '',     $date6, $time6), $date_id_to_label->(0 .. 6), 'to only2');
                cmp_bag($search->($date6, $time6, '',     ''),     $date_id_to_label->(6 .. 8), 'from only2');
            };

            subtest 'eccentric cases' => sub {
                cmp_bag($search->($date6, '',     $date6, $time6), $date_id_to_label->(5 .. 6), 'within a day');
                cmp_bag($search->($date6, $time6, $date6, ''),     $date_id_to_label->(5 .. 6), 'within a day');
                cmp_bag($search->($date6, '',     '',     $time6), $date_id_to_label->(5 .. 8), 'within a day');
                cmp_bag($search->('',     $time6, $date6, ''),     $date_id_to_label->(0 .. 7), 'within a day');
            };
        };
    };

    subtest 'cf_date' => sub {
        $field = 'cf_date';
        $fcds  = $cds{$field};
        cmp_bag($search->($date2, '', $date6, ''), $date_id_to_label->(1 .. 7), 'normal');
        cmp_bag($search->($date6, '', $date2, ''), $date_id_to_label->(1 .. 7), 'negative range');

        subtest 'unset or half set daterange' => sub {
            plan skip_all => 'incomplete daterange';
            cmp_bag($search->('',     '', $date2, ''), $date_id_to_label->(0 .. 3), 'to only');
            cmp_bag($search->($date2, '', '',     ''), $date_id_to_label->(1 .. 8), 'from only');
            cmp_bag($search->('',     '', $date6, ''), $date_id_to_label->(0 .. 7), 'to only2');
            cmp_bag($search->($date6, '', '',     ''), $date_id_to_label->(5 .. 8), 'from only2');
        };
    };

    subtest 'cf_time' => sub {
        $field = 'cf_time';
        $fcds  = $cds{$field};
        cmp_bag($search->('', $time2, '', $time6), $date_id_to_label->(2 .. 6), 'normal');
        cmp_bag($search->('', $time6, '', $time2), $date_id_to_label->(2 .. 6), 'negative range');

        subtest 'unset or half set daterange' => sub {
            plan skip_all => 'incomplete daterange';
            cmp_bag($search->('', '',     '', $time2), $date_id_to_label->(0 .. 2), 'to only');
            cmp_bag($search->('', $time2, '', ''),     $date_id_to_label->(2 .. 8), 'from only');
            cmp_bag($search->('', '',     '', $time6), $date_id_to_label->(0 .. 6), 'to only2');
            cmp_bag($search->('', $time6, '', ''),     $date_id_to_label->(6 .. 8), 'from only2');
        };
    };

    for my $fcds (values %cds) {
        $_->remove for values %$fcds;
    }
};

subtest q{contaminated date_time_field_id on entry tab is ignored} => sub {
    my $entry = MT::Test::Permission->make_entry(
        blog_id     => $blog_id,
        author_id   => $author->id,
        title       => 'contamination-test',
        authored_on => '20010101120000',
    );
    my $cf_id = $objs->{content_type}{ct_multi}{content_field}{cf_datetime}->id;
    my $app   = MT::Test::App->new('MT::App::CMS');
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
    my $app = MT::Test::App->new('MT::App::CMS');
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
                'tmpl_author_yearly',
            ] }
        ],
        'author_yearly templates hit'
    );
};

subtest 'asset' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);
    $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
    $app->change_tab('asset');

    $app->search('Sample', { is_limited => 1, search_cols => 'label' });
    is_deeply($app->found_titles, ['Sample Image 1', 'Sample Image 2', 'Sample Image 3']);
};

subtest 'blog' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);
    $app->get_ok({ __mode => 'search_replace', blog_id => 1 });
    $app->change_tab('blog');

    $app->search('site', { is_limited => 1, search_cols => 'name' });
    is_deeply($app->found_titles, ['My Site']);

    $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
    ok !$app->tab_exists('blog'), 'blog tab is not available';
};

subtest 'website' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
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

    my $app = MT::Test::App->new('MT::App::CMS');
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

subtest 'dialog_grant_role' => sub {
    require JSON;

    # XXX move to role
    my $expected = sub {
        my ($app, $names, $pager) = @_;
        my $json = eval { JSON::decode_json($app->content) };
        ok !$@, 'json is ok';
        my $wq    = Web::Query::LibXML->new($json->{html});
        my @links = $wq->find('tr td:nth-of-type(2) .panel-label') || ();
        my @names = map { my $txt = $_; $txt =~ s{^\s+|\s+$}{}g; $txt } map { $_->text } @links;
        is_deeply(\@names, $names, 'right authors');
        for my $key (keys %{$pager}) {
            is($json->{pager}->{$key}, $pager->{$key}, qq{right value for pager key:$key});
        }
        note explain $json;
    };

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);

    $app->get_ok({ __mode => 'dialog_grant_role', blog_id => $blog_id });
    $app->dialog_grant_role_search('o');
    $expected->($app, ['author', 'Melody'], { limit => 25, listTotal => 2, offset => 0, rows => 2 });

    $app->get_ok({ __mode => 'dialog_grant_role', blog_id => 0 });
    $app->dialog_grant_role_search('o');
    $expected->($app, ['author', 'Melody'], { limit => 25, listTotal => 2, offset => 0, rows => 2 });
};

done_testing;
