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
$test_env->prepare_fixture('db');

use MT::Test;
use MT::Test::Permission;
use MT::ContentFieldType::ContentType;

my $blog = MT::Test::Permission->make_blog;
my $content_type = MT::Test::Permission->make_content_type( blog_id => $blog->id );

my $app = MT->instance;
$app->blog($blog);

subtest 'options_validation_handler' => sub {
    my $ct_id = $content_type->id;

    my $err_format11 = 'You must select a source content type.';
    my $err_format21 = 'The source Content Type is not found in this site.';
    my $err_format31 = q{A minimum selection number for 'mycontenttypes' (mylabel) must be a positive integer greater than or equal to 0.};
    my $err_format32 = q{A maximum selection number for 'mycontenttypes' (mylabel) must be a positive integer greater than or equal to 1.};
    my $err_format33 = q{A maximum selection number for 'mycontenttypes' (mylabel) must be a positive integer greater than or equal to the minimum selection number.};

    my @test_cases = (
        { source => '',     multiple => 0, min => '', max => '', error => $err_format11 },
        { source => 0,      multiple => 0, min => '', max => '', error => $err_format11 },
        { source => 999999, multiple => 0, min => '', max => '', error => $err_format21 },
        { source => $ct_id, multiple => 0, min => '', max => '', error => undef },
        { source => $ct_id, multiple => 1, min => '', max => '', error => undef },
        { source => $ct_id, multiple => 1, min => 5,  max => 10, error => undef },
        { source => $ct_id, multiple => 1, min => 0,  max => 1,  error => undef },
        { source => $ct_id, multiple => 1, min => -1, max => 10, error => $err_format31 },
        { source => $ct_id, multiple => 1, min => 0,  max => 0,  error => $err_format32 },
        { source => $ct_id, multiple => 1, min => 5,  max => 4,  error => $err_format33 },
    );

    for my $case (@test_cases) {
        subtest 'min=' . $case->{min} . ', max:' . $case->{max} => sub {
            my $err = MT::ContentFieldType::ContentType::options_validation_handler(
                $app, 'content_type', 'mycontenttypes', sub { 'mylabel' },
                {
                    'source'   => $case->{source},
                    'min'      => $case->{min},
                    'max'      => $case->{max},
                    'label'    => 'mycontenttypes',
                    'multiple' => $case->{multiple},
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

