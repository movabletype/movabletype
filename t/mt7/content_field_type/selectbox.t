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
use MT::ContentFieldType::SelectBox;

my $app = MT->new;

subtest 'field_html_params', sub {
    my @test_cases = (
        { value   => 0,
          options => {
              values => [ { label => 'foo', value => 1 } ],
              multiple => 0,
              required => 1,
          },
          expected => {
              multiple => '',
              multiple_class => '',
              options_values => [ { l => 'foo', v => 1 } ],
              required => 'required'
          }
        },
        { value   => 0,
          options => {
              values => [ { label => 'foo', value => 1 } ],
              multiple => 0,
              required => 0,
          },
          expected => {
              multiple => '',
              multiple_class => '',
              options_values => [ { l => 'foo', v => 1 } ],
              required => ''
          }
        },
        { value   => 1,
          options => {
              values => [ { label => 'foo', value => 1 } ],
              multiple => 0,
              required => 1,
          },
          expected => {
              multiple => '',
              multiple_class => '',
              options_values => [ { l => 'foo', v => 1, selected => 'selected="selected"' } ],
              required => 'required'
          }
        },
        { value   => 1,
          options => {
              values => [ { label => 'foo', value => 1 }, { label => 'bar', value => 2 } ],
              min => 1,
              max => 2,
              multiple => 1,
              required => 1,
          },
          expected => {
              multiple => 'multiple data-mt-max-select="2" data-mt-min-select="1"',
              multiple_class => 'multiple-select',
              options_values => [
                  { l => 'foo', v => 1, selected => 'selected="selected"' },
                  { l => 'bar', v => 2 }
              ],
              required => 'required'
          }
        },
        { value   => 1,
          options => {
              values => [ { label => 'foo', value => 1 }, { label => 'bar', value => 2 } ],
              min => 1,
              multiple => 1,
              required => 1,
          },
          expected => {
              multiple => 'multiple data-mt-min-select="1"',
              multiple_class => 'multiple-select',
              options_values => [
                  { l => 'foo', v => 1, selected => 'selected="selected"' },
                  { l => 'bar', v => 2 }
              ],
              required => 'required'
          }
        },
        { value   => 1,
          options => {
              values => [ { label => 'foo', value => 1 }, { label => 'bar', value => 2 } ],
              max => 2,
              multiple => 1,
              required => 1,
          },
          expected => {
              multiple => 'multiple data-mt-max-select="2"',
              multiple_class => 'multiple-select',
              options_values => [
                  { l => 'foo', v => 1, selected => 'selected="selected"' },
                  { l => 'bar', v => 2 }
              ],
              required => 'required'
          }
        },
    );
    for my $i (0..$#test_cases) {
        my $case = $test_cases[$i];
        my $result = MT::ContentFieldType::SelectBox::field_html_params(
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

    my $err_format11 = 'You must enter at least one label-value pair.';
    my $err_format12 = 'A label for each value is required.';
    my $err_format13 = 'A value for each label is required.';
    my $err_format21 = q{A minimum selection number for 'myselectbox' (mylabel) must be a positive integer greater than or equal to 0.};
    my $err_format22 = q{A maximum selection number for 'myselectbox' (mylabel) must be a positive integer greater than or equal to 1.};
    my $err_format23 = q{A maximum selection number for 'myselectbox' (mylabel) must be a positive integer greater than or equal to the minimum selection number.};

    my @test_cases = (
        { values => undef,
          error => $err_format11
        },
        { values => [],
          error => undef
        },
        { values => [{ value => 1 }],
          error => $err_format12
        },
        { values => [{ label => 'foo' }],
          error => $err_format13
        },
        { values => [{ label => '', value => '' }],
          error => undef
        },
        { values => [{ label => 'foo', value => 1 }],
          error => undef
        },
        { values => [{ label => 'foo', value => 'foo' }],
          error => undef
        },
        { values => [{ label => 'foo', value => 1 },{ value => 2 }],
          error => $err_format12
        },
        { values => [{ label => 'foo', value => 1 },{ label => 'bar' }],
          error => $err_format13
        },
        { values => [{ label => 'foo', value => 1 },{ label => 'bar', value => 2 }],
          error => undef
        },
        { values => undef,
          multiple => 0,
          min => '',
          max => '',
          error => $err_format11
        },
        { values => [{ value => 1 }],
          multiple => 0,
          min => '',
          max => '',
          error => $err_format12
        },
        { values => [{ label => 'foo' }],
          multiple => 0,
          min => '',
          max => '',
          error => $err_format13
        },
        { values => [],
          multiple => 0,
          min => '',
          max => '',
          error => undef
        },
        { values => [],
          multiple => 1,
          min => '',
          max => '',
          error => undef
        },
        { values => [],
          multiple => 1,
          min => 5,
          max => 10,
          error => undef
        },
        { values => [],
          multiple => 1,
          min => 0,
          max => 1,
          error => undef
        },
        { values => [],
          multiple => 1,
          min => -1,
          max => 10,
          error => $err_format21
        },
        { values => [],
          multiple => 1,
          min => 0,
          max => 0,
          error => $err_format22
        },
        { values => [],
          multiple => 1,
          min => 5,
          max => 4,
          error => $err_format23
        },
    );

    for my $i (0..$#test_cases) {
        my $case = $test_cases[$i];
        subtest 'case=' . $i => sub {
            my $err = MT::ContentFieldType::SelectBox::options_validation_handler(
                $app, 'select_box', 'myselectbox', sub { 'mylabel' },
                {
                    'description' => '',
                    'display'     => 'default',
                    'id'          => '10',
                    'values'      => $case->{values},
                    'min'         => $case->{min},
                    'max'         => $case->{max},
                    'multiple'    => $case->{multiple},
                    'label'       => 'myselectbox',
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

subtest 'ss_validator_multiple' => sub {
    my $field_data = {
        options => {
            label    => 'myselectbox',
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
        { name => 'undef',         data => undef,             error => undef },
        { name => '[0]',           data => [0],               error => undef },
        { name => 'invalid value', data => 'invalid',         error => 'Invalid values in "myselectbox" field: invalid' },
        { name => 'below min',     data => [],                error => 'Options greater than or equal to 1 must be selected in "myselectbox" field.' },
        { name => 'above max',     data => ['foo', 'bar', 0], error => 'Options less than or equal to 2 must be selected in "myselectbox" field.' },
    );

    for my $case (@test_cases) {
        is MT::ContentFieldType::SelectBox::ss_validator_multiple($app, $field_data, $case->{data}),
            $case->{error}, $case->{name};
    }
};

done_testing;
