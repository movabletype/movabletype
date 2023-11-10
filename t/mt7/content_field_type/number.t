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

use MT::ContentFieldType::Number;

my $app = MT->new;

subtest 'options_validation_handler' => sub {
    MT->config('NumberFieldDecimalPlaces', 1);
    MT->config('NumberFieldMaxValue', 5);
    MT->config('NumberFieldMinValue', -5);

    my $err_format11 = "Number of decimal places must be a positive integer.";
    my $err_format12 = "Number of decimal places must be a positive integer and between 0 and 1.";

    my $err_format21 = "A minimum value must be an integer, or must be set with decimal places to use decimal value.";
    my $err_format22 = "A minimum value must be an integer and between -5 and 5";
    my $err_format23 = "A maximum value must be an integer, or must be set with decimal places to use decimal value.";
    my $err_format24 = "A maximum value must be an integer and between -5 and 5";
;
    my $err_format31 = '"mynumber" field value must be less than or equal to %s.';

    my $err_format41 = "An initial value must be an integer, or must be set with decimal places to use decimal value.";
    my $err_format42 = "An initial value must be an integer and between %s and %s";

    my @test_cases = (
        { decimal_places => 'foo', min_value => '',    max_value => '',    initial_value => '', error => $err_format11 },
        { decimal_places => 2,     min_value => '',    max_value => '',    initial_value => '', error => $err_format12 },

        { decimal_places => '',    min_value => 1.1,   max_value => '',    initial_value => '', error => $err_format21 },
        { decimal_places => '',    min_value => -1.1,  max_value => '',    initial_value => '', error => $err_format21 },
        { decimal_places => '',    min_value => 'foo', max_value => '',    initial_value => '', error => $err_format21 },
        { decimal_places => '',    min_value => 5,     max_value => '',    initial_value => '', error => undef },
        { decimal_places => '',    min_value => 6,     max_value => '',    initial_value => '', error => $err_format22 },
        { decimal_places => '',    min_value => -5,    max_value => '',    initial_value => '', error => undef },
        { decimal_places => '',    min_value => -6,    max_value => '',    initial_value => '', error => $err_format22 },
        { decimal_places => 1,     min_value => 5.1,   max_value => '',    initial_value => '', error => $err_format22 },
        { decimal_places => 1,     min_value => -5.1,  max_value => '',    initial_value => '', error => $err_format22 },
        { decimal_places => '',    min_value => '',    max_value => 1.1,   initial_value => '', error => $err_format23 },
        { decimal_places => '',    min_value => '',    max_value => -1.1,  initial_value => '', error => $err_format23 },
        { decimal_places => '',    min_value => '',    max_value => 'foo', initial_value => '', error => $err_format23 },
        { decimal_places => '',    min_value => '',    max_value => 5,     initial_value => '', error => undef },
        { decimal_places => '',    min_value => '',    max_value => 6,     initial_value => '', error => $err_format24 },
        { decimal_places => '',    min_value => '',    max_value => -6,    initial_value => '', error => $err_format24 },
        { decimal_places => 1,     min_value => '',    max_value => 5.1,   initial_value => '', error => $err_format24 },
        { decimal_places => 1,     min_value => '',    max_value => -5.1,  initial_value => '', error => $err_format24 },

        { decimal_places => '',    min_value => 5,     max_value => 5,     initial_value => '', error => undef },
        { decimal_places => '',    min_value => 5,     max_value => 4,     initial_value => '', error => sprintf($err_format31, 4) },
        { decimal_places => 1,     min_value => 4.9,   max_value => 4.9,   initial_value => '', error => undef },
        { decimal_places => 1,     min_value => 4.9,   max_value => 4.8,   initial_value => '', error => sprintf($err_format31, 4.8) },

        { decimal_places => '',    min_value => '',    max_value => '', initial_value => 1.1,   error => $err_format41 },
        { decimal_places => '',    min_value => '',    max_value => '', initial_value => -1.1,  error => $err_format41 },
        { decimal_places => '',    min_value => '',    max_value => '', initial_value => 'foo', error => $err_format41 },
        { decimal_places => '',    min_value => '',    max_value => '', initial_value => 5,     error => undef },
        { decimal_places => '',    min_value => '',    max_value => '', initial_value => -5,    error => undef },
        { decimal_places => 1,     min_value => '',    max_value => '', initial_value => 4.9,   error => undef },
        { decimal_places => 1,     min_value => '',    max_value => '', initial_value => -4.9,  error => undef },
        { decimal_places => '',    min_value => -4,    max_value => 4,  initial_value => 4,     error => undef },
        { decimal_places => '',    min_value => -4,    max_value => 4,  initial_value => -4,    error => undef },
        { decimal_places => '',    min_value => '',    max_value => '', initial_value => 6,     error => sprintf($err_format42, -5, 5) },
        { decimal_places => '',    min_value => '',    max_value => '', initial_value => -6,    error => sprintf($err_format42, -5, 5) },
        { decimal_places => '',    min_value => -4,    max_value => 4,  initial_value => 5,     error => sprintf($err_format42, -4, 4) },
        { decimal_places => '',    min_value => -4,    max_value => 4,  initial_value => -5,    error => sprintf($err_format42, -4, 4) },
        { decimal_places => 1,     min_value => '',    max_value => '', initial_value => 5.1,   error => sprintf($err_format42, -5, 5) },
        { decimal_places => 1,     min_value => '',    max_value => '', initial_value => -5.1,  error => sprintf($err_format42, -5, 5) },
    );

    for my $case (@test_cases) {
        my $test_label =
            sprintf("decimal_places=%s, min_value=%s, max_value=%s, initial_value=%s",
                $case->{decimal_places}, $case->{min_value}, $case->{max_value}, $case->{initial_value} );

        subtest $test_label => sub {
            my $err = MT::ContentFieldType::Number::options_validation_handler(
                $app, 'number', 'mynumber', sub { 'mylabel' },
                {
                    'description'    => '',
                    'display'        => 'default',
                    'id'             => '10',
                    'decimal_places' => $case->{decimal_places},
                    'min_value'      => $case->{min_value},
                    'max_value'      => $case->{max_value},
                    'initial_value'  => $case->{initial_value},
                    'label'          => 'mynumber',
                    'required'       => 0,
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

done_testing;
