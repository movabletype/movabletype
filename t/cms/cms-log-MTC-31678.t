#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    # force Text::CSV to fail to load.
    $ENV{PERL_TEXT_CSV} = 'Invalid Value';

    $test_env = MT::Test::Env->new(
        CSVExportWithBOM => 0
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Blog;
use MT::Author;
use MT::Test;
use MT::Test::App;
use MT::Test::Permission;
use IO::String;
use utf8;

$test_env->prepare_fixture('db');

my $website = MT::Test::Permission->make_website(
    name => 'my website',
);
my $author = MT::Author->load(1);

subtest "setup log" => sub {

    MT::Test::Permission->make_log(
        blog_id     => $website->id,
        author_id   => $author->id,
        message     => 'edit entry',
        category    => 'edit',
        class       => 'entry',
        ip          => '127.0.0.1',
        created_on  => '20260829033000',    # server_offset => -3.5
        modified_on => '20260829033000',
    );

    my @logs = MT::Log->load({ class => 'entry', blog_id => $website->id });
    ok scalar(@logs), "logs exist";
};

subtest 'download is successful in spite of Text::CSV failing' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($author);

    my $args = {
        __mode  => 'export_log',
        blog_id => $website->id,
        _type   => 'log',
    };

    my $res     = $app->post_ok($args);
    my $content = $res->content;
    my $io      = IO::String->new($content);

    require Text::CSV_PP;
    my $csv = Text::CSV_PP->new({ binary => 1 });

    is_deeply($csv->getline($io), [qw/timestamp ip weblog by message metadata/]);
    is_deeply(
        $csv->getline_all($io),
        [['2026-08-29 00:00:00', '127.0.0.1', 'my website', 'Melody', "edit entry", '']]);

    close $io;
};

done_testing;
