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
use MT::ContentFieldType::Checkboxes;

my $app = MT->new;

subtest 'options_validation_handler' => sub {

    my $valid_values = [
        { 'checked' => '', 'label' => 'foo', 'value' => 'foo_val' },
        { 'checked' => '', 'label' => 'bar', 'value' => 'bar_val' },
    ];
    my $err_format11 = q{A minimum selection number for 'mycheckbox' (mylabel) must be a positive integer greater than or equal to 0.};
    my $err_format12 = q{A maximum selection number for 'mycheckbox' (mylabel) must be a positive integer greater than or equal to 1.};
    my $err_format13 = q{A maximum selection number for 'mycheckbox' (mylabel) must be a positive integer greater than or equal to the minimum selection number.};

    my $invalid_values1 = [{ 'checked' => '', 'label' => 'foo' }];
    my $err_format21    = q{A value for each label is required.};

    my $invalid_values2 = [{ 'checked' => '', 'value' => 'foo_val' }];
    my $err_format22    = q{A label for each value is required.};

    my $err_format3 = q{You must enter at least one label-value pair.};

    my @test_cases = (
        { min => '', max => '', values => $valid_values,    error => undef },
        { min => 5,  max => 10, values => $valid_values,    error => undef },
        { min => 0,  max => 1,  values => $valid_values,    error => undef },
        { min => -1, max => 10, values => $valid_values,    error => $err_format11 },
        { min => 0,  max => 0,  values => $valid_values,    error => $err_format12 },
        { min => 5,  max => 4,  values => $valid_values,    error => $err_format13 },
        { min => 0,  max => 5,  values => $invalid_values1, error => $err_format21 },
        { min => 0,  max => 5,  values => $invalid_values2, error => $err_format22 },
        { min => 0,  max => 5,  values => undef,            error => $err_format3 },
    );

    for my $case (@test_cases) {
        subtest 'min=' . $case->{min} . ', max:' . $case->{max} => sub {
            my $err = MT::ContentFieldType::Checkboxes::options_validation_handler(
                $app, 'checkboxes', 'mycheckbox', sub { 'mylabel' },
                {
                    'description' => '',
                    'display'     => 'default',
                    'id'          => '10',
                    'min'         => $case->{min},
                    'max'         => $case->{max},
                    'values'      => $case->{values},
                    'label'       => 'mycheckbox',
                    'required'    => 0,
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
