#!/usr/bin/perl

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

use MT;
use MT::Blog;
use MT::Author;
use MT::Test;
use MT::Test::App;
use MT::Test::Permission;
use MT::Util qw( epoch2ts ts2epoch offset_time format_ts );
use Text::CSV;
use IO::String;
use JSON;
use utf8;

$test_env->prepare_fixture('db_data');

my $website = MT::Test::Permission->make_website(
    name => 'my website',
);
my $author = MT::Author->load(1);

my $now         = time;
my $today       = epoch2ts($website, $now);
my $one_day_ago = epoch2ts($website, ($now - (24 * 60 * 60)));

subtest 'show dialog' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);

    $app->get_ok({ __mode => 'list', blog_id => $website->id, _type => 'log' });
    ok my $link = $app->wq_find('a.icon-download');
    my $query = URI->new($link->attr('href'))->query_form_hash;

    $app->get_ok($query);
    ok my $form = $app->wq_find('form#export-log-form');
    ok $form->find('button#export-log-download');
};

subtest 'download' => sub {
    my @cases = ({
            set_data => sub {
                my $blog = MT::Test::Permission->make_blog(
                    parent_id => $website->id,
                    name      => 'test1',
                );
                MT::Test::Permission->make_log(
                    blog_id     => $blog->id,
                    author_id   => $author->id,
                    message     => 'edit entry',
                    category    => 'edit',
                    class       => 'entry',
                    ip          => '127.0.0.1',
                    created_on  => '20050131074500',
                    modified_on => '20050131074600',
                );
                return $blog;
            },
            args     => {},
            expected => [
                ['2005-01-31 04:15:00', '127.0.0.1', 'test1', 'Melody', "edit entry", ''],
            ],
        },
        {
            set_data => sub {
                my $blog = MT::Test::Permission->make_blog(
                    parent_id => $website->id,
                    name      => 'test2',
                );
                MT::Test::Permission->make_log(
                    blog_id     => $blog->id,
                    author_id   => $author->id,
                    message     => "edit\nentry",
                    category    => 'edit',
                    class       => 'entry',
                    ip          => '127.0.0.1',
                    created_on  => '20050131074500',
                    modified_on => '20050131074600',
                );
                return $blog;
            },
            args     => {},
            expected => [
                ['2005-01-31 04:15:00', '127.0.0.1', 'test2', 'Melody', "edit\nentry", ''],
            ],
        },
        {
            set_data => sub {
                my $blog = MT::Test::Permission->make_blog(
                    parent_id => $website->id,
                    name      => 'test3',
                );
                MT::Test::Permission->make_log(
                    blog_id     => $blog->id,
                    message     => "log message",
                    metadata    => "log metadata",
                    created_on  => '20050131074500',
                    modified_on => '20050131074600',
                );
                return $blog;
            },
            args     => {},
            expected => [
                ['2005-01-31 04:15:00', '', 'test3', '', 'log message', "log metadata"],
            ],
        },
        {
            set_data => sub {
                my $blog = MT::Test::Permission->make_blog(
                    parent_id => $website->id,
                    name      => 'test3-2',
                );
                MT::Test::Permission->make_log(
                    blog_id     => $blog->id,
                    message     => "ログメッセージ",
                    metadata    => "ログメタデータ",
                    created_on  => '20050131074500',
                    modified_on => '20050131074600',
                );
                return $blog;
            },
            args     => {},
            expected => [
                ['2005-01-31 04:15:00', '', 'test3-2', '', 'ログメッセージ', "ログメタデータ"],
            ],
        },
        {
            set_data => sub {
                my $blog = MT::Test::Permission->make_blog(
                    parent_id => $website->id,
                    name      => 'test4',
                );
                MT::Test::Permission->make_log(
                    blog_id     => $blog->id,
                    message     => "log message",
                    metadata    => JSON->new->pretty->canonical->encode({ key1 => "foo", key2 => "bar" }),
                    created_on  => '20050131074500',
                    modified_on => '20050131074600',
                );
                return $blog;
            },
            args     => {},
            expected => [
                ['2005-01-31 04:15:00', '', 'test4', '', 'log message', "{\n   \"key1\" : \"foo\",\n   \"key2\" : \"bar\"\n}\n"],
            ],
        },
        {
            set_data => sub {
                my $blog = MT::Test::Permission->make_blog(
                    parent_id => $website->id,
                    name      => 'test5',
                );
                MT::Test::Permission->make_log(
                    blog_id     => $blog->id,
                    message     => "log message",
                    created_on  => '20050131074500',
                    modified_on => '20050131074600',
                );
                return $blog;
            },
            args     => {},
            expected => [
                ['2005-01-31 04:15:00', '', 'test5', '', 'log message', ''],
            ],
        },
        {
            set_data => sub {
                my $blog = MT::Test::Permission->make_blog(
                    parent_id => $website->id,
                    name      => 'test6',
                );
                MT::Test::Permission->make_log(
                    blog_id     => $blog->id,
                    message     => "log message",
                    created_on  => '20050131074500',
                    modified_on => '20050131074600',
                );
                return $blog;
            },
            args => {
                type => 'range',
                from => '2005-01-30',
                to   => '2005-01-31',
            },
            expected => [
                ['2005-01-31 04:15:00', '', 'test6', '', 'log message', ''],
            ],
        },
        {
            set_data => sub {
                my $blog = MT::Test::Permission->make_blog(
                    parent_id => $website->id,
                    name      => 'test6-2',
                );
                MT::Test::Permission->make_log(
                    blog_id     => $blog->id,
                    message     => "log message",
                    created_on  => '20050131074500',
                    modified_on => '20050131074600',
                );
                return $blog;
            },
            args => {
                type => 'range',
                from => '2005-01-30',
            },
            expected => [
                ['2005-01-31 04:15:00', '', 'test6-2', '', 'log message', ''],
            ],
        },
        {
            set_data => sub {
                my $blog = MT::Test::Permission->make_blog(
                    parent_id => $website->id,
                    name      => 'test6-3',
                );
                MT::Test::Permission->make_log(
                    blog_id     => $blog->id,
                    message     => "log message",
                    created_on  => '20050131074500',
                    modified_on => '20050131074600',
                );
                return $blog;
            },
            args => {
                type => 'range',
                to   => '2005-01-31',
            },
            expected => [
                ['2005-01-31 04:15:00', '', 'test6-3', '', 'log message', ''],
            ],
        },
        {
            set_data => sub {
                my $blog = MT::Test::Permission->make_blog(
                    parent_id => $website->id,
                    name      => 'test7',
                );

                MT::Test::Permission->make_log(
                    blog_id     => $blog->id,
                    message     => "log message",
                    created_on  => $one_day_ago,
                    modified_on => $one_day_ago,
                );

                MT::Test::Permission->make_log(
                    blog_id     => $blog->id,
                    message     => "log message",
                    created_on  => $today,
                    modified_on => $today,
                );

                return $blog;
            },
            args => {
                type => 'days',
                days => 1,
            },
            expected => [
                map {
                    ## All Log records are saved with GMT, so do trick here.
                    my $epoch = ts2epoch(undef, $_, 1);
                    $epoch = offset_time($epoch, $website);
                    my $ts = epoch2ts($website, $epoch, 1);
                    [format_ts('%Y-%m-%d %H:%M:%S', $ts, $website), '', 'test7', '', 'log message', ''],
                } ($today)
            ],
        },
        {
            set_data => sub {
                my $blog = MT::Test::Permission->make_blog(
                    parent_id => $website->id,
                    name      => 'test8',
                );
                for my $i (0 .. 1) {
                    MT::Test::Permission->make_log(
                        blog_id     => $blog->id,
                        message     => "log message",
                        created_on  => "2005013${i}074500",
                        modified_on => "2005013${i}074600",
                    );
                }
                return $blog;
            },
            args => {
                type   => 'before',
                origin => '2005-01-31',
            },
            expected => [
                ['2005-01-30 04:15:00', '', 'test8', '', 'log message', ''],
            ],
        },
        {
            set_data => sub {
                my $blog = MT::Test::Permission->make_blog(
                    parent_id => $website->id,
                    name      => 'test8-2',
                );
                for my $i (0 .. 1) {
                    MT::Test::Permission->make_log(
                        blog_id     => $blog->id,
                        message     => "log message",
                        created_on  => "2005013${i}074500",
                        modified_on => "2005013${i}074600",
                    );
                }
                return $blog;
            },
            args => {
                type => 'before',
            },
            expected => [
                ['2005-01-30 04:15:00', '', 'test8-2', '', 'log message', ''],
                ['2005-01-31 04:15:00', '', 'test8-2', '', 'log message', ''],
            ],
        },
        {
            set_data => sub {
                my $blog = MT::Test::Permission->make_blog(
                    parent_id => $website->id,
                    name      => 'test9',
                );
                for my $i (0 .. 1) {
                    MT::Test::Permission->make_log(
                        blog_id     => $blog->id,
                        message     => "log message",
                        created_on  => "2005013${i}074500",
                        modified_on => "2005013${i}074600",
                    );
                }
                return $blog;
            },
            args => {
                type   => 'after',
                origin => '2005-01-30',
            },
            expected => [
                ['2005-01-31 04:15:00', '', 'test9', '', 'log message', ''],
            ],
        },
        {
            set_data => sub {
                my $blog = MT::Test::Permission->make_blog(
                    parent_id => $website->id,
                    name      => 'test9-2',
                );
                for my $i (0 .. 1) {
                    MT::Test::Permission->make_log(
                        blog_id     => $blog->id,
                        message     => "log message",
                        created_on  => "2005013${i}074500",
                        modified_on => "2005013${i}074600",
                    );
                }
                return $blog;
            },
            args => {
                type => 'after',
            },
            expected => [
                ['2005-01-30 04:15:00', '', 'test9-2', '', 'log message', ''],
                ['2005-01-31 04:15:00', '', 'test9-2', '', 'log message', ''],
            ],
        },
    );

    for my $index (0 .. $#cases) {
        my $case = $cases[$index];
        subtest "case: $index" => sub {
            my $blog = $case->{set_data}();
            my $app  = MT::Test::App->new('MT::App::CMS');
            $app->login($author);

            my $args = {
                __mode  => 'export_log',
                blog_id => $blog->id,
                _type   => 'log',
                ($case->{args} ? %{ $case->{args} } : ()),
            };

            my $res = $app->post_ok($args);
            my $content = $res->content;
            $content =~ s/^\xEF\xBB\xBF//;
            my $io  = IO::String->new($content);
            my $csv = Text::CSV->new({ binary => 1 });

            is_deeply($csv->getline($io),     [qw/timestamp ip weblog by message metadata/]);
            is_deeply($csv->getline_all($io), $case->{expected});

            close $io;
        };
    }
};

done_testing;
