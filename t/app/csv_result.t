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
            headers => [ 'Header1', 'Header2' ],
        }
    );

    ok !$result, 'csv_result returns error when filename is missing';
    like $app->errstr, qr/No filename/, 'Error message contains "No filename"';

    my $module = Test::MockModule->new('MT::App');
    my $content_disposition;
    $module->mock(
        'set_header',
        sub {
            shift;
            $content_disposition = $_[1] if $_[0] eq 'Content-Disposition';
        }
    );
    $module->mock( 'send_http_header', sub { } );
    $module->mock( 'print',            sub { } );

    $app->csv_result(
        sub { return; },
        {
            filename => '0',
            headers  => [ 'Header1', 'Header2' ],
        }
    );
    like $content_disposition, qr/\Aattachment;\s*filename\*=UTF-8''0\.csv\z/,
      'filename "0" becomes "0.csv" with filename* (UTF-8)';

    $app->csv_result(
        sub { return; },
        {
            filename => 'report',
            headers  => [ 'Header1', 'Header2' ],
        }
    );
    like $content_disposition,
      qr/\Aattachment;\s*filename\*=UTF-8''report\.csv\z/,
      'filename "report" becomes "report.csv" with filename* (UTF-8)';

    $app->csv_result(
        sub { return; },
        {
            filename => 'data.csv',
            headers  => [ 'Header1', 'Header2' ],
        }
    );
    like $content_disposition,
      qr/\Aattachment;\s*filename\*=UTF-8''data\.csv\z/,
      'filename "data.csv" becomes "data.csv" with filename* (UTF-8)';
};

subtest 'CSVExportWithBOM' => sub {
    my $app = MT->app;
    $app->init_request;

    my $module = Test::MockModule->new('MT::App');
    my $output;
    $module->mock( 'send_http_header', sub { } );
    $module->mock(
        'print',
        sub {
            shift;
            $output .= $_ for @_;
        }
    );

    $output = '';
    my $count1 = 0;
    $app->csv_result(
        sub {
            return if $count1++;
            return [ 'value1', 'value2' ];
        },
        {
            filename => 'test',
            headers  => [ 'Header1', 'Header2' ],
        }
    );
    like $output, qr/^\x{EF}\x{BB}\x{BF}/, 'CSV output has BOM by default';

    # Test with CSVExportWithBOM set to 0
    $output = '';
    my $count2 = 0;
    MT->config->CSVExportWithBOM( 0, 1 );
    $app->csv_result(
        sub {
            return if $count2++;
            return [ 'value1', 'value2' ];
        },
        {
            filename => 'test',
            headers  => [ 'Header1', 'Header2' ],
        }
    );
    unlike $output, qr/^\x{EF}\x{BB}\x{BF}/,
      'CSV output has no BOM when CSVExportWithBOM is 0';

    MT->config->CSVExportWithBOM( 1, 1 );
};

subtest 'CSVExportEscapeFormula' => sub {
    my $app = MT->app;
    $app->init_request;

    my $module = Test::MockModule->new('MT::App');
    my $output;
    $module->mock( 'send_http_header', sub { } );
    $module->mock(
        'print',
        sub {
            shift;
            $output .= $_ for @_;
        }
    );

    $output = '';
    my $count1 = 0;
    $app->csv_result(
        sub {
            return if $count1++;
            return [ '=formula', '+plus', '-minus', '@at' ];
        },
        {
            filename => 'test',
            headers  => [ 'Header1', 'Header2', 'Header3', 'Header4' ],
        }
    );
    like $output, qr/'=formula/, 'Formula starting with = is escaped';
    like $output, qr/'\+plus/,   'Formula starting with + is escaped';
    like $output, qr/'-minus/,   'Formula starting with - is escaped';
    like $output, qr/'\@at/,     'Formula starting with @ is escaped';

    $output = '';
    my $count2 = 0;
    $app->csv_result(
        sub {
            return if $count2++;
            return [ 'normal', '123', 'text-with-dash', 'text with space' ];
        },
        {
            filename => 'test',
            headers  => [ 'Header1', 'Header2', 'Header3', 'Header4' ],
        }
    );
    like $output, qr/normal/,         'Normal text is not escaped';
    like $output, qr/123/,            'Numbers are not escaped';
    like $output, qr/text-with-dash/, 'Text with dash in middle is not escaped';
    like $output, qr/"text with space"/, 'Text with space is not escaped';

    # CSVExportEscapeFormula set to 0
    $output = '';
    my $count3 = 0;
    MT->config->CSVExportEscapeFormula( 0, 1 );
    $app->csv_result(
        sub {
            return if $count3++;
            return [ '=formula', '+plus', '-minus', 'text with space' ];
        },
        {
            filename => 'test',
            headers  => [ 'Header1', 'Header2', 'Header3', 'Header4' ],
        }
    );
    like $output, qr/=formula/,
      'Formula starting with = is not escaped when CSVExportEscapeFormula is 0';
    like $output, qr/\+plus/,
      'Formula starting with + is not escaped when CSVExportEscapeFormula is 0';
    like $output, qr/-minus/,
      'Formula starting with - is not escaped when CSVExportEscapeFormula is 0';
    like $output, qr/"text with space"/,
      'Text with space is not escaped when CSVExportEscapeFormula is 0';

    MT->config->CSVExportEscapeFormula( 1, 1 );
};

done_testing;
