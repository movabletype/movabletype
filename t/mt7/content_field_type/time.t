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
use MT::ContentFieldType::Time;

my $app = MT->new;

subtest 'options_validation_handler' => sub {

    my $err_format = q{Invalid time '%s'; An initial time value be in the format HH:MM:SS.};
    my @test_cases = (
        { initial_value => '00:00:00', error => undef },
        { initial_value => '12:10:59', error => undef },
        { initial_value => '23:59:59', error => undef },
        { initial_value => '24:00:00', error => $err_format },
        { initial_value => '00:60:00', error => $err_format },
        { initial_value => '00:00:60', error => $err_format },
        { initial_value => 'aa:bb:cc', error => $err_format },
    );

    for my $case (@test_cases) {
        subtest 'inital_value=' . $case->{initial_value} => sub {
            my $err = MT::ContentFieldType::Time::options_validation_handler(
                $app, 'time_only', 'mytime', sub { },
                {
                    'description'   => '',
                    'display'       => 'default',
                    'id'            => '10',
                    'initial_value' => $case->{initial_value},
                    'label'         => 'mytime',
                    'required'      => 0,
                },
            );
            if (!$case->{error}) {
                is $err, undef, 'no error';
            } else {
                is $err, sprintf($case->{error}, $case->{initial_value}), 'right error';
            }
        };
    }
};

done_testing;
