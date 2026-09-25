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
use MT::ContentFieldType::Common;

my $app = MT->new;

subtest 'ss_validator_multiple' => sub {
    my $field_data = {
        options => {
            label    => 'myfield',
            multiple => 1,
            min      => 1,
            max      => 2,
            values   => [
                { label => 'foo',  value => 'foo' },
                { label => 'bar',  value => 'bar' },
                { label => 'zero', value => 0 },
            ],
        },
    };
    my @test_cases = (
        { name => 'scalar',        data => 'foo',             error => undef },
        { name => 'list',          data => ['foo', 'bar'],    error => undef },
        { name => 'undef',         data => undef,             error => 'Options greater than or equal to 1 must be selected in "myfield" field.' },
        { name => '[0]',           data => [0],               error => undef },
        { name => 'invalid value', data => 'invalid',         error => 'Invalid values in "myfield" field: invalid' },
        { name => 'below min',     data => [],                error => 'Options greater than or equal to 1 must be selected in "myfield" field.' },
        { name => 'above max',     data => ['foo', 'bar', 0], error => 'Options less than or equal to 2 must be selected in "myfield" field.' },
    );

    for my $case (@test_cases) {
        is MT::ContentFieldType::Common::ss_validator_multiple($app, $field_data, $case->{data}),
            $case->{error}, $case->{name};
    }
};

done_testing;
