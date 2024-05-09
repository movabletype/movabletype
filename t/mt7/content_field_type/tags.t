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
use MT::ContentFieldType::Tags;

subtest 'options_validation_handler' => sub {
    my $app = MT->instance;

    my $err_format = q{An initial value for 'mytags' (mylabel) must be an shorter than 255 characters};

    my @test_cases = (
        { initial_value => '',        error => undef },
        { initial_value => 'a' x 255, error => undef },
        { initial_value => 'a' x 256, error => $err_format },
    );
    for my $case (@test_cases) {
        subtest "initial_value=$case->{initial_value}" => sub {
            my $err = MT::ContentFieldType::Tags::options_validation_handler(
                $app, 'tags', 'mytags', sub { 'mylabel' },
                {
                    'description'   => '',
                    'display'       => 'default',
                    'id'            => '10',
                    'initial_value' => $case->{initial_value},
                    'label'         => 'mytags',
                    'required'      => 0,
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


