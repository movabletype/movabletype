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

use Text::CSV;
use IO::String;
use JSON;

$test_env->prepare_fixture('db_data');

my $website = MT::Test::Permission->make_website(
    name => 'my website',
);
my $author = MT::Author->load(1);

my @cases = (
    {
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
        expected => ['2005-01-31 04:15:00', '127.0.0.1', 'test1', 'Melody', "edit entry", ''],
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
        expected => ['2005-01-31 04:15:00', '127.0.0.1', 'test2', 'Melody', "edit entry", ''],
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
        expected => ['2005-01-31 04:15:00', '', 'test3', '', 'log message', "log metadata"],
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
        expected => ['2005-01-31 04:15:00', '', 'test4', '', 'log message', "{\n   \"key1\" : \"foo\",\n   \"key2\" : \"bar\"\n}\n"],
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
        expected => ['2005-01-31 04:15:00', '', 'test5', '', 'log message', ''],
    },
);

for my $index (0 .. $#cases) {
    my $case = $cases[$index];
    subtest "case: $index" => sub {
        my $blog = $case->{set_data}();
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($author);

        my $res = $app->get_ok({ __mode => 'export_log', blog_id => $blog->id, _type => 'log' });

        my $io = IO::String->new($res->content);
        my $csv = Text::CSV->new({ binary => 1 });

        is_deeply( $csv->getline($io), [qw/timestamp ip weblog by message metadata/] );
        is_deeply( $csv->getline($io), $case->{expected} );

        close $io;
    };
}

done_testing;
