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
use MT::ContentFieldType::Date;

my $app = MT->new;

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

done_testing;
