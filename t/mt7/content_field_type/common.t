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

subtest 'options_pre_save_handler_multiple' => sub {
    my $code       = \&MT::ContentFieldType::Common::options_pre_save_handler_multiple;
    my $options    = {};
    my $value_elem = { label => 'foo', value => 'foov' };

    subtest 'valueIds are empty' => sub {
        $options->{values} = [{%$value_elem}, {%$value_elem}];
        $code->($app, 'checkboxes', undef, $options);
        is_deeply([map { $_->{valueId} } @{ $options->{values} }], [1, 2], 'right valueId assigned');
    };

    subtest 'valueIds are already exists' => sub {
        $options->{values} = [
            { %$value_elem, valueId => 1 },
            { %$value_elem, valueId => 2 }];
        $code->($app, 'checkboxes', undef, $options);
        is_deeply([map { $_->{valueId} } @{ $options->{values} }], [1, 2], 'right valueId assigned');
    };

    subtest 'some valueIds are exists' => sub {
        $options->{values} = [
            { %$value_elem, valueId => 1 },
            {%$value_elem},
        ];
        $code->($app, 'checkboxes', undef, $options);
        is_deeply([map { $_->{valueId} } @{ $options->{values} }], [1, 2], 'right valueId assigned');
    };

    subtest 'valueId exists sparsely' => sub {
        $options->{values} = [
            {%$value_elem},
            { %$value_elem, valueId => 3 },
            {%$value_elem},
            { %$value_elem, valueId => 5 },
            { %$value_elem},
        ];
        $code->($app, 'checkboxes', undef, $options);
        is_deeply([map { $_->{valueId} } @{ $options->{values} }], [1, 3, 4, 5, 6], 'right valueId assigned');
    };
};

done_testing;
