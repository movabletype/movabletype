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
use MT::ContentFieldType::URL;

subtest 'options_validation_handler' => sub {
    my $app = MT->instance;

    my $err_format = q{An initial value for 'myurl' (mylabel) must be shorter than 2000 characters};

    my @test_cases = (
        { initial_value => '',         error => undef },
        { initial_value => 'a' x 2000, error => undef },
        { initial_value => 'a' x 2001, error => $err_format },
    );
    for my $case (@test_cases) {
        subtest "initial_value=$case->{initial_value}" => sub {
            my $err = MT::ContentFieldType::URL::options_validation_handler(
                $app, 'url', 'myurl', sub { 'mylabel' },
                {
                    'description'   => '',
                    'display'       => 'default',
                    'id'            => '10',
                    'initial_value' => $case->{initial_value},
                    'label'         => 'myurl',
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


