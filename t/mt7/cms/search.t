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
};

sub mod_date {
    my ($ts, %args) = @_;

    my @parted = split(/\D/, $ts);
    $parted[$args{field}] += $args{add} if $args{field};
    
    if ($args{format} && $args{format} eq 'date') {
        return sprintf('%04d%02d%02d', @parted[0,1,2]);
    }
    if ($args{format} && $args{format} eq 'time') {
        return sprintf('%02d%02d%02d', @parted[3,4,5]);
    }
    return sprintf('%04d%02d%02d%02d%02d%02d', @parted);
}

subtest 'content_data with daterange' => sub {
    my $cf_datetime = $objs->{content_type}{ct_multi}{content_field}{cf_datetime};
    my $cf_date     = $objs->{content_type}{ct_multi}{content_field}{cf_date};
    my $cf_time     = $objs->{content_type}{ct_multi}{content_field}{cf_time};
    my @dates       = (
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
    my %time_shift = (
        $cf_datetime => { field => 0, add => 10 },    # 10 year later
        $cf_date     => { field => 0, add => 20 },    # 20 year later
        $cf_time     => { field => 3, add => 5 },     # 5 hour later
    );
    my %cds = map {
        my $date = $_;
        my $cd = MT::Test::Permission->make_content_data(
            authored_on     => mod_date($date),
            blog_id         => $blog_id,
            content_type_id => $ct_id,
            identifier      => $date,
            label           => 'daterangetest-' . $date,
            data            => {
                $cf_datetime->id => mod_date($date, %{ $time_shift{$cf_datetime} }),
                $cf_date->id     => mod_date($date, %{ $time_shift{$cf_date} }, format => 'date'),
                $cf_time->id     => '19700101' . mod_date($date, %{ $time_shift{$cf_time} }, format => 'time'),
            },
        );
        ($date => $cd);
    } List::Util::shuffle @dates;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);
    $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
    $app->change_tab('content_data');
    $app->change_content_type($ct_id);

    require JSON;
    my $json = JSON->new;

    my $test = sub {
        my ($cf, $from, $timefrom, $to, $timeto, $expected, $skip) = @_;
        $from     = mod_date($dates[$from],     %{ $time_shift{$cf} }, format => 'date') if $from;
        $timefrom = mod_date($dates[$timefrom], %{ $time_shift{$cf} }, format => 'time') if $timefrom;
        $to       = mod_date($dates[$to],       %{ $time_shift{$cf} }, format => 'date') if $to;
        $timeto   = mod_date($dates[$timeto],   %{ $time_shift{$cf} }, format => 'time') if $timeto;
        subtest $json->encode([$cf ? $cf->name : 'authored_on', $from, $timefrom, $to, $timeto]) => sub {
            plan skip_all => 'XXX ' . $skip if $skip;
            $app->search(
                'daterangetest-', {
                    is_dateranged      => 1,
                    date_time_field_id => ($cf ? $cf->id : 0),
                    from               => $from,
                    timefrom           => $timefrom,
                    to                 => $to,
                    timeto             => $timeto,
                });
            is_deeply($app->found_titles, [map { $_->label } @$expected]);
        };
    };

    # cf, from, timefrom, to, timeto, expected
    $test->('',           '', '', '', '', [@cds{ @dates[reverse(0 .. 8)] }], 'imcomplete-daterange');
    $test->('',           2,  '', 6,  '', [@cds{ @dates[reverse(1 .. 7)] }]);
    $test->('',           6,  '', 2,  '', [@cds{ @dates[reverse(1 .. 7)] }]);
    $test->('',           '', '', 2,  '', [@cds{ @dates[reverse(0 .. 3)] }], 'imcomplete-daterange');
    $test->('',           2,  '', '', '', [@cds{ @dates[reverse(1 .. 8)] }], 'imcomplete-daterange');
    $test->('',           '', '', 6,  '', [@cds{ @dates[reverse(0 .. 7)] }], 'imcomplete-daterange');
    $test->('',           6,  '', '', '', [@cds{ @dates[reverse(5 .. 8)] }], 'imcomplete-daterange');
    $test->($cf_datetime, 2,  '', 6,  '', [@cds{ @dates[reverse(1 .. 7)] }]);
    $test->($cf_datetime, 6,  '', 2,  '', [@cds{ @dates[reverse(1 .. 7)] }]);
    $test->($cf_datetime, '', '', 2,  '', [@cds{ @dates[reverse(0 .. 3)] }], 'imcomplete-daterange');
    $test->($cf_datetime, 2,  '', '', '', [@cds{ @dates[reverse(1 .. 8)] }], 'imcomplete-daterange');
    $test->($cf_datetime, '', '', 6,  '', [@cds{ @dates[reverse(0 .. 7)] }], 'imcomplete-daterange');
    $test->($cf_datetime, 7,  '', '', '', [@cds{ @dates[reverse(5 .. 8)] }], 'imcomplete-daterange');
    $test->($cf_datetime, 2,  2,  6,  6,  [@cds{ @dates[reverse(2 .. 6)] }], 'time-not-implemented');
    $test->($cf_datetime, 6,  6,  2,  2,  [@cds{ @dates[reverse(2 .. 6)] }], 'time-not-implemented');
    $test->($cf_datetime, '', '', 2,  2,  [@cds{ @dates[reverse(0 .. 2)] }], 'imcomplete-daterange, time-not-implemented');
    $test->($cf_datetime, 2,  2,  '', '', [@cds{ @dates[reverse(2 .. 8)] }], 'imcomplete-daterange, time-not-implemented');
    $test->($cf_datetime, '', '', 6,  6,  [@cds{ @dates[reverse(0 .. 6)] }], 'imcomplete-daterange, time-not-implemented');
    $test->($cf_datetime, 6,  6,  '', '', [@cds{ @dates[reverse(6 .. 8)] }], 'imcomplete-daterange, time-not-implemented');
    $test->($cf_date,     2,  '', 6,  '', [@cds{ @dates[reverse(1 .. 7)] }]);
    $test->($cf_date,     6,  '', 2,  '', [@cds{ @dates[reverse(1 .. 7)] }]);
    $test->($cf_date,     '', '', 2,  '', [@cds{ @dates[reverse(0 .. 3)] }], 'imcomplete-daterange');
    $test->($cf_date,     2,  '', '', '', [@cds{ @dates[reverse(1 .. 8)] }], 'imcomplete-daterange');
    $test->($cf_date,     '', '', 6,  '', [@cds{ @dates[reverse(0 .. 7)] }], 'imcomplete-daterange');
    $test->($cf_date,     6,  '', '', '', [@cds{ @dates[reverse(5 .. 8)] }], 'imcomplete-daterange');
    $test->($cf_time,     '', 2,  '', 6,  [@cds{ @dates[reverse(2 .. 6)] }]);
    $test->($cf_time,     '', 6,  '', 2,  [@cds{ @dates[reverse(2 .. 6)] }]);
    $test->($cf_time,     '', '', '', 2,  [@cds{ @dates[reverse(0 .. 2)] }], 'imcomplete-daterange');
    $test->($cf_time,     '', 2,  '', '', [@cds{ @dates[reverse(2 .. 8)] }], 'imcomplete-daterange');
    $test->($cf_time,     '', '', '', 6,  [@cds{ @dates[reverse(0 .. 6)] }], 'imcomplete-daterange');
    $test->($cf_time,     '', 6,  '', '', [@cds{ @dates[reverse(6 .. 8)] }], 'imcomplete-daterange');

    subtest 'eccentric cases' => sub {
        # cf, from, timefrom, to, timeto, expected
        $test->($cf_datetime, 6,  '', 6,  6,  [@cds{ @dates[reverse(5 .. 6)] }], 'imcomplete-daterange');
        $test->($cf_datetime, 6,  6,  6,  '', [@cds{ @dates[reverse(5 .. 6)] }], 'imcomplete-daterange');
        $test->($cf_datetime, 6,  '', '', 6,  [@cds{ @dates[reverse(5 .. 8)] }], 'imcomplete-daterange');
        $test->($cf_datetime, '', 6,  6,  '', [@cds{ @dates[reverse(0 .. 7)] }], 'imcomplete-daterange');
    };

    $_->remove for values %cds;
};

subtest q{contaminated date_time_field_id on entry tab is ignored} => sub {
    plan skip_all => 'XXX MTC-28541';

    my $cf_id = $objs->{content_type}{ct_multi}{content_field}{cf_datetime}->id;
    my $app   = MT::Test::App->new('MT::App::CMS');
    $app->login($author);
    $app->get_ok({ __mode => 'search_replace', blog_id => $blog_id });
    $app->change_tab('content_data');
    $app->search('a', { is_dateranged => 1, from => '1964-03-01', to => '1963-01-01', date_time_field_id => $cf_id });
    $app->change_tab('entry');
    $app->search('Verse', {});
    ok !$app->generic_error, 'no error';
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
