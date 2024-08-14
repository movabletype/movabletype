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
use MT::ContentFieldType::DateTime;

my $blog = MT::Test::Permission->make_blog;
my $app = MT->instance;
$app->blog($blog);

subtest 'options_validation_handler' => sub {

    my $err_format = q{Invalid date '%s %s'; An initial date/time value must be in the format YYYY-MM-DD HH:MM:SS.};
    my @test_cases = (
        { initial_date => '2001-12-30', initial_time => '00:00:00', error => undef },
        { initial_date => '2001-13-00', initial_time => '00:00:00', error => $err_format },
        { initial_date => '2001-01-32', initial_time => '00:00:00', error => $err_format },
        { initial_date => '2001-02-28', initial_time => '00:00:00', error => undef },
        { initial_date => '2001-02-29', initial_time => '00:00:00', error => $err_format },
        { initial_date => '2001-03-31', initial_time => '00:00:00', error => undef },
        { initial_date => '2001-03-32', initial_time => '00:00:00', error => $err_format },
        { initial_date => '2001-04-30', initial_time => '00:00:00', error => undef },
        { initial_date => '2001-04-31', initial_time => '00:00:00', error => $err_format },
        { initial_date => '2004-02-29', initial_time => '00:00:00', error => undef },
        { initial_date => '2004-02-30', initial_time => '00:00:00', error => $err_format },
        { initial_date => 'aaaa-bb-cc', initial_time => '00:00:00', error => $err_format },
        { initial_date => '2001-01-01', initial_time => '00:00:00', error => undef },
        { initial_date => '2001-01-01', initial_time => '00:00:60', error => $err_format },
        { initial_date => '2001-01-01', initial_time => '00:60:00', error => $err_format },
        { initial_date => '2001-01-01', initial_time => '12:10:59', error => undef },
        { initial_date => '2001-01-01', initial_time => '23:59:59', error => undef },
        { initial_date => '2001-01-01', initial_time => '24:00:00', error => $err_format },
        { initial_date => '2001-01-01', initial_time => 'aa:bb:cc', error => $err_format },
    );

    for my $case (@test_cases) {
        subtest "inital_date=$case->{initial_date}, initial_time=$case->{initial_time}" => sub {
            my $err = MT::ContentFieldType::DateTime::options_validation_handler(
                $app, 'datetime', 'mydatetime', sub { },
                {
                    'description'  => '',
                    'display'      => 'default',
                    'id'           => '10',
                    'initial_date' => $case->{initial_date},
                    'initial_time' => $case->{initial_time},
                    'label'        => 'mydatetime',
                    'required'     => 0,
                },
            );
            if (!$case->{error}) {
                is $err, undef, 'no error';
            } else {
                is $err, sprintf($case->{error}, $case->{initial_date}, $case->{initial_time}), 'right error';
            }
        };
    }
};

subtest 'options_pre_save_handler' => sub {
    my @test_cases = (
        { initial_date => '2001-01-01', initial_time => '23:59:59', expected => '2001-01-01 23:59:59' },
        { initial_date => '2001-01-01', initial_time => '',         expected => '2001-01-01 00:00:00' },
        { initial_date => '',           initial_time => '23:59:59', expected => '1970-01-01 23:59:59' },
        { initial_date => '',           initial_time => '',         expected => undef },
    );
    for my $i (0..$#test_cases)  {
        my $case = $test_cases[$i];
        my $options = {
            description   => '',
            display       => 'default',
            id            => '10',
            initial_date  => $case->{initial_date},
            initial_time  => $case->{initial_time},
            label         => 'mydatetime',
            required      => 0,
        };
        MT::ContentFieldType::DateTime::options_pre_save_handler( $app, 'datetime', undef, $options );
        is $options->{initial_value}, $case->{expected}, "case=${i}";
    }
};

subtest 'options_pre_load_handler' => sub {
    my @test_cases = (
        { initial_value => '2001-01-01 00:00:00', expected => { initial_date => '2001-01-01', initial_time => '00:00:00' } },
        { initial_value => '',                    expected => undef },
    );
    for my $i (0..$#test_cases)  {
        my $case = $test_cases[$i];
        my $options = {
            description   => '',
            display       => 'default',
            id            => '10',
            initial_value => $case->{initial_value},
            label         => 'mydatetime',
            required      => 0,
        };
        MT::ContentFieldType::DateTime::options_pre_load_handler( $app, $options );
        is $options->{initial_date}, $case->{expected}{initial_date}, "case=${i} initial_date";
        is $options->{initial_time}, $case->{expected}{initial_time}, "case=${i} initial_time";
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
            initial_value => '1970-01-01',
            label         => 'mydatetime',
            required      => 0,
        },
    };

    my $result = MT::ContentFieldType::DateTime::feed_value_handler( $app, $field_data, '20010101000000' );
    is $result, '2001-01-01 00:00:00';
};

subtest 'preview_handler' => sub {
    my $result = MT::ContentFieldType::DateTime::preview_handler( $app, '20010101000000' );
    is $result, '2001-01-01 00:00:00';
};

done_testing;
