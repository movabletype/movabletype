use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}
$test_env->prepare_fixture('db');

use MT::Test;
use MT::Test::Permission;
use MT::ContentFieldType::Time;

my $blog = MT::Test::Permission->make_blog;
my $app = MT->instance;
$app->blog($blog);

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

subtest 'options_pre_save_handler' => sub {
    my @test_cases = (
        { initial_time => '00:00:00', expected => '1970-01-01 00:00:00' },
        { initial_time => '',           expected => undef },
    );
    for my $i (0..$#test_cases)  {
        my $case = $test_cases[$i];
        my $options = {
            description   => '',
            display       => 'default',
            id            => '10',
            initial_time  => $case->{initial_time},
            label         => 'mydate',
            required      => 0,
        };
        MT::ContentFieldType::Time::options_pre_save_handler( $app, 'time_only', $options );
        is $options->{initial_value}, $case->{expected}, "case=${i}";
    }
};

subtest 'options_pre_load_handler' => sub {
    my @test_cases = (
        { initial_value => '1970-01-01 00:00:00', expected => '00:00:00' },
        { initial_value => '',                    expected => undef },
    );
    for my $i (0..$#test_cases)  {
        my $case = $test_cases[$i];
        my $options = {
            description   => '',
            display       => 'default',
            id            => '10',
            initial_value => $case->{initial_value},
            label         => 'mydate',
            required      => 0,
        };
        MT::ContentFieldType::Time::options_pre_load_handler( $app, 'time_only', undef, $options );
        is $options->{initial_time}, $case->{expected}, "case=${i}";
    }
};

# DEPRECATED
subtest 'feed_value_handler' => sub {
    my $field_data = {
        id      => 1,
        order   => 1,
        options => {
            description   => '',
            display       => 'default',
            id            => '10',
            initial_value => '23:59:59',
            label         => 'mydate',
            required      => 0,
        },
    };
      
    my $result = MT::ContentFieldType::Time::feed_value_handler( $app, $field_data, '20010101000000' );
    is $result, '00:00:00';
};

subtest 'preview_handler' => sub {
    my $result = MT::ContentFieldType::Time::preview_handler( $app, '20010101000000' );
    is $result, '00:00:00';
};

done_testing;
