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
use MT::ContentFieldType::Date;

my $blog = MT::Test::Permission->make_blog;
my $app = MT->instance;
$app->blog($blog);

subtest 'options_validation_handler' => sub {

    my $err_format = q{Invalid date '%s'; An initial date value must be in the format YYYY-MM-DD.};
    my @test_cases = (
        { initial_value => '2001-12-30', error => undef },
        { initial_value => '2001-13-00', error => $err_format },
        { initial_value => '2001-01-32', error => $err_format },
        { initial_value => '2001-02-28', error => undef },
        { initial_value => '2001-02-29', error => $err_format },
        { initial_value => '2001-03-31', error => undef },
        { initial_value => '2001-03-32', error => $err_format },
        { initial_value => '2001-04-30', error => undef },
        { initial_value => '2001-04-31', error => $err_format },
        { initial_value => '2004-02-29', error => undef },
        { initial_value => '2004-02-30', error => $err_format },
        { initial_value => 'aaaa-bb-cc', error => $err_format },
    );

    for my $case (@test_cases) {
        subtest 'inital_value=' . $case->{initial_value} => sub {
            my $err = MT::ContentFieldType::Date::options_validation_handler(
                $app, 'date_only', 'mydate', sub { },
                {
                    'description'   => '',
                    'display'       => 'default',
                    'id'            => '10',
                    'initial_value' => $case->{initial_value},
                    'label'         => 'mydate',
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
        { initial_date => '2001-01-01', expected => '2001-01-01 00:00:00' },
        { initial_date => '',           expected => undef },
    );
    for my $i (0..$#test_cases)  {
        my $case = $test_cases[$i];
        my $options = {
            description   => '',
            display       => 'default',
            id            => '10',
            initial_date  => $case->{initial_date},
            label         => 'mydate',
            required      => 0,
        };
        MT::ContentFieldType::Date::options_pre_save_handler( $app, 'date_only', $options );
        is $options->{initial_value}, $case->{expected}, "case=${i}";
    }
};

subtest 'options_pre_load_handler' => sub {
    my @test_cases = (
        { initial_value => '2001-01-01 00:00:00', expected => '2001-01-01' },
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
        MT::ContentFieldType::Date::options_pre_load_handler( $app, 'date_only', undef, $options );
        is $options->{initial_date}, $case->{expected}, "case=${i}";
    }
};

subtest 'feed_value_handler' => sub {
    my $field_data = {
        id      => 1,
        order   => 1,
        options => {
            description   => '',
            display       => 'default',
            id            => '10',
            initial_value => '1970-01-01',
            label         => 'mydate',
            required      => 0,
        },
    };

    my $result = MT::ContentFieldType::Date::feed_value_handler( $app, $field_data, '20010101000000' );
    is $result, '2001-01-01';
};

subtest 'preview_handler' => sub {
    my $result = MT::ContentFieldType::Date::preview_handler( $app, '20010101000000' );
    is $result, '2001-01-01';
};

done_testing;
