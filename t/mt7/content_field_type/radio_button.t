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
use MT::ContentFieldType::RadioButton;

my $app = MT->new;

subtest 'field_html_params', sub {
    my @test_cases = (
        { value   => 0,
          options => {
              values   => [{ label => 'foo', value => 1 }],
              required => 1,
          },
          expected => {
              options_values => [{ l => 'foo', v => 1 }],
              required       => 'required'
          }
        },
        { value   => 1,
          options => {
              values   => [{ label => 'foo', value => 1 }],
              required => 1,
          },
          expected => {
              options_values => [ { l => 'foo', v => 1, checked => 'checked="checked"' } ],
              required       => 'required'
          }
        },
        { value   => 1,
          options => {
              values   => [{ label => 'foo', value => 1 }],
              required => 0,
          },
          expected => {
              options_values => [{ l => 'foo', v => 1, checked => 'checked="checked"' }],
              required       => ''
          }
        },
        { value   => 1,
          options => {
              values   => [{ label => 'foo', value => 1 }, { label => 'bar', value => 2 }],
              required => 1,
          },
          expected => {
              options_values => [
                  { l => 'foo', v => 1, checked => 'checked="checked"' },
                  { l => 'bar', v => 2 }
              ],
              required => 'required'
          }
        },
    );
    for my $i (0..$#test_cases) {
        my $case = $test_cases[$i];
        my $result = MT::ContentFieldType::RadioButton::field_html_params(
            $app,
            { id      => 1,
              order   => 1,
              value   => $case->{value},
              options => $case->{options},
            }
        );

        is_deeply $result, $case->{expected}, "case=${i}";
    }
};

subtest 'options_validation_handler' => sub {

    my $err_format1 = 'You must enter at least one label-value pair.';
    my $err_format2 = 'A label of values is required.';
    my $err_format3 = 'A value of values is required.';

    my @test_cases = (
        { values => undef,                                                           error => $err_format1 },
        { values => [],                                                              error => undef },
        { values => [{ value => 1 }],                                                error => $err_format2 },
        { values => [{ label => 'foo' }],                                            error => $err_format3 },
        { values => [{ label => '', value => '' }],                                  error => undef },
        { values => [{ label => 'foo', value => 1 }],                                error => undef },
        { values => [{ label => 'foo', value => 'foo' }],                            error => undef },
        { values => [{ label => 'foo', value => 1 },{ value => 2 }],                 error => $err_format2 },
        { values => [{ label => 'foo', value => 1 },{ label => 'bar' }],             error => $err_format3 },
        { values => [{ label => 'foo', value => 1 },{ label => 'bar', value => 2 }], error => undef },
    );

    for my $i (0..$#test_cases) {
        my $case = $test_cases[$i];
        subtest 'case=' . $i => sub {
            my $err = MT::ContentFieldType::RadioButton::options_validation_handler(
                $app, 'radio_button', 'myradiobutton', sub { 'mylabel' },
                {
                    'description' => '',
                    'display'     => 'default',
                    'id'          => '10',
                    'values'      => $case->{values},
                    'label'       => 'myradiobutton',
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
