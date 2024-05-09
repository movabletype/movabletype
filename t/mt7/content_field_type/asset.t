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
use MT::ContentFieldType::Asset;

my $app = MT->new;

subtest 'options_validation_handler' => sub {

    my $err_format1 = q{A minimum selection number for 'myassets' (mylabel) must be a positive integer greater than or equal to 0.};
    my $err_format2 = q{A maximum selection number for 'myassets' (mylabel) must be a positive integer greater than or equal to 1.};
    my $err_format3 = q{A maximum selection number for 'myassets' (mylabel) must be a positive integer greater than or equal to the minimum selection number.};

    my @test_cases = (
        { min => '', max => '', multiple => 0, error => undef },
        { min => 5,  max => 10, multiple => 0, error => undef },
        { min => 0,  max => 1,  multiple => 0, error => undef },
        { min => -1, max => 10, multiple => 0, error => undef },
        { min => 0,  max => 0,  multiple => 0, error => undef },
        { min => 5,  max => 4,  multiple => 0, error => undef },
        { min => '', max => '', multiple => 1, error => undef },
        { min => 5,  max => 10, multiple => 1, error => undef },
        { min => 0,  max => 1,  multiple => 1, error => undef },
        { min => -1, max => 10, multiple => 1, error => $err_format1 },
        { min => 0,  max => 0,  multiple => 1, error => $err_format2 },
        { min => 5,  max => 4,  multiple => 1, error => $err_format3 },
    );

    for my $case (@test_cases) {
        subtest 'min=' . $case->{min} . ', max:' . $case->{max} => sub {
            my $err = MT::ContentFieldType::Asset::options_validation_handler(
                $app, 'asset', 'myassets', sub { 'mylabel' },
                {
                    'description' => '',
                    'display'     => 'default',
                    'id'          => '10',
                    'min'         => $case->{min},
                    'max'         => $case->{max},
                    'label'       => 'myassets',
                    'multiple'    => $case->{multiple},
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

