#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;

BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;

$test_env->prepare_fixture('db');

subtest 'filename validation' => sub {
    my $app = MT->app;
    $app->init_request;

    my $result = $app->csv_result(
        sub { },
        {
            headers => ['Header1', 'Header2'],
        }
    );

    ok !$result, 'csv_result returns error when filename is missing';
    like $app->errstr, qr/No filename/, 'Error message contains "No filename"';

    my $module = Test::MockModule->new('MT::App');
    my $content_disposition;
    $module->mock('set_header', sub {
        shift;
        $content_disposition = $_[1] if $_[0] eq 'Content-Disposition';
    });

    $app->csv_result(
        sub { return; },
        {
            filename => '0',
            headers  => ['Header1', 'Header2'],
        }
    );
    like $content_disposition, qr/filename=0\.csv/, 'filename "0" becomes "0.csv"';

    $app->csv_result(
        sub { return; },
        {
            filename => 'report',
            headers  => ['Header1', 'Header2'],
        }
    );
    like $content_disposition, qr/filename=report\.csv/, 'filename "report" becomes "report.csv"';

    $app->csv_result(
        sub { return; },
        {
            filename => 'data.csv',
            headers  => ['Header1', 'Header2'],
        }
    );
    like $content_disposition, qr/filename=data\.csv$/, 'filename "data.csv" stays "data.csv"';
};

done_testing;
