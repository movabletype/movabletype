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

use MT::Test;
use MT::ContentFieldType::Table;

my $app = MT->instance;

subtest 'field_html_params', sub {
    my @test_cases = (
        { value    => '<tr><td>1</td></tr>',
          options  => { initial_cols => 1, initial_rows => 1 },
          expected => '<tr><td>1</td></tr>'
        },
        { value    => '',
          options  => { initial_cols => 1, initial_rows => 1 },
          expected => '<tr><td></td></tr>'
        },
        { value    => '',
          options  => { initial_cols => '', initial_rows => '' },
          expected => '<tr><td></td></tr>'
        },
    );
    for my $i (0..$#test_cases) {
        my $case = $test_cases[$i];
        subtest "case=${i}" => sub {
            my $result = MT::ContentFieldType::Table::field_html_params(
                $app,
                {
                    id      => 1,
                    order   => 1,
                    value   => $case->{value},
                    options => $case->{options},
                });

            is $result->{table_value}, $case->{expected}, '';
        };
    }
};

subtest '_create_empty_table', sub {
    my $one_one = MT::ContentFieldType::Table::_create_empty_table( 1, 1 );
    is( $one_one, '<tr><td></td></tr>' );

    my $two_two = MT::ContentFieldType::Table::_create_empty_table( 2, 2 );
    is( $two_two, "<tr><td></td><td></td></tr>\n<tr><td></td><td></td></tr>" );

    my $one_three = MT::ContentFieldType::Table::_create_empty_table( 1, 3 );
    is( $one_three, "<tr><td></td><td></td><td></td></tr>" );
};

subtest 'options_validation_handler' => sub {

    my $err_format1 = q{Initial number of rows for 'mytable' (mylabel) must be a positive integer.};
    my $err_format2 = q{Initial number of columns for 'mytable' (mylabel) must be a positive integer.};

    my @test_cases = (
        { initial_rows => 1,     initial_cols => 1,     error => undef },
        { initial_rows => '',    initial_cols => 1,     error => undef },
        { initial_rows => 1,     initial_cols => '',    error => undef },
        { initial_rows => '',    initial_cols => '',    error => undef },
        { initial_rows => 'foo', initial_cols => 1,     error => $err_format1 },
        { initial_rows => 1,     initial_cols => 'foo', error => $err_format2 },
        { initial_rows => 'foo', initial_cols => '',    error => $err_format1 },
        { initial_rows => '',    initial_cols => 'foo', error => $err_format2 },
        { initial_rows => 'foo', initial_cols => 'foo', error => $err_format1 },
    );
    for my $case (@test_cases) {
        subtest "initial_rows=$case->{initial_rows}, initial_cols=$case->{initial_cols}" => sub {
            my $err = MT::ContentFieldType::Table::options_validation_handler(
                $app, 'table', 'mytable', sub { 'mylabel' },
                {
                    'description'  => '',
                    'display'      => 'default',
                    'id'           => '10',
                    'initial_rows' => $case->{initial_rows},
                    'initial_cols' => $case->{initial_cols},
                    'label'        => 'mytable',
                    'required'     => 0,
                },
            );
            if (!$case->{error}) {
                is $err, undef, 'no error';
            } else {
                is $err, $case->{error}, 'right error';
            }
        };
    }
};

my $field_data = {
    id      => 1,
    order   => 1,
    value   => '',
    options => {
        initial_cols => 1,
        initial_rows => 1,
    },
};

# DEPRECATED
subtest 'feed_value_handler' => sub {
    my @test_cases = (
        { value => '<tr><td>foo</td></tr>', expected => '<table border="1"><tr><td>foo</td></tr></table>' },
        { value => 'foo',                   expected => '<table border="1">foo</table>' },
        { value => '',                      expected => '<table border="1"></table>' },
    );
    for my $i (0..$#test_cases)  {
        my $case = $test_cases[$i];
        my $result = MT::ContentFieldType::Table::feed_value_handler($app, $field_data, $case->{value});
        is $result, $case->{expected}, "case=${i}";
    }
};

subtest 'preview_handler' => sub {
    my @test_cases = (
        { value => '<tr><td>foo</td></tr>', expected => '<table border="1" cellpadding="3"><tr><td>foo</td></tr></table>' },
        { value => 'foo',                   expected => '<table border="1" cellpadding="3">foo</table>' },
        { value => '',                      expected => '' },
    );
    for my $i (0..$#test_cases)  {
        my $case = $test_cases[$i];
        my $result = MT::ContentFieldType::Table::preview_handler($field_data, $case->{value});
        is $result, $case->{expected}, "case=${i}";
    }
};

subtest 'search_result_handler' => sub {
    my @test_cases = (
        { value => '',                                  expected => '' },
        { value => '<tr><td></td></tr>',                expected => '' },
        { value => '<tr><td>foo</td></tr>',             expected => 'foo' },
        { value => ' <tr><td>foo</td></tr>',            expected => 'foo' },
        { value => '<tr><td> foo</td></tr>',            expected => ' foo' },
        { value => '<tr><td>foo </td></tr>',            expected => 'foo ' },
        { value => '<tr><td>foo</td></tr>' ,            expected => 'foo' },
        { value => 'foo<tr><td>bar</td></tr>',          expected => 'foo | bar' },
        { value => '<tr>foo<td>bar</td></tr>',          expected => 'foo | bar' },
        { value => '<tr><td>foo</td>bar</tr>',          expected => 'foo | bar' },
        { value => '<tr><td>foo</td></tr>bar',          expected => 'foo | bar' },
        { value => '<tr><td>foo</td><td>bar</td></tr>', expected => 'foo | bar' },
    );
    for my $i (0..$#test_cases)  {
        my $case = $test_cases[$i];
        my $result = MT::ContentFieldType::Table::search_result_handler($field_data, $case->{value});
        is $result, $case->{expected}, "case=${i}";
    }
};

subtest 'search_handler' => sub {
    my @test_cases = (
        { reg => 'foo', value => '',                         expected => 0 },
        { reg => 'foo', value => '<tr><td></td></tr>',       expected => 0 },
        { reg => 'foo', value => '<tr><td>foo</td></tr>',    expected => 1 },
        { reg => 'foo', value => '<tr><td>bar</td></tr>',    expected => 0 },
        { reg => 'foo', value => 'foo<tr><td>bar</td></tr>', expected => 1 },
    );
    for my $i (0..$#test_cases)  {
        my $case = $test_cases[$i];
        my $result = MT::ContentFieldType::Table::search_handler($case->{reg}, $field_data, $case->{value});
        is $result, $case->{expected}, "case=${i}";
    }
};

done_testing;

