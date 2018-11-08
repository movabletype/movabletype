#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';

    eval { require YAML::Syck }
        or plan skip_all => 'YAML::Syck is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::App::DataAPI;
use MT::DataAPI::Endpoint::Stats;

MT::Test->init_app;

$test_env->prepare_fixture('db_data');

my $app  = MT::App::DataAPI->new;
my $blog = $app->model('blog')->load(1);
( my $spec_dir = __FILE__ ) =~ s/t$/d/;
subtest 'fill_in_archive_info' => sub {
    for my $f (
        glob( File::Spec->catfile( $spec_dir, 'fill_in_archive_info', '*' ) )
        )
    {
        my $suite = YAML::Syck::LoadFile($f);
        for my $data (@$suite) {
            subtest $data->{note} => sub {
                my $result
                    = MT::DataAPI::Endpoint::Stats::fill_in_archive_info(
                    $data->{input}, $blog );
                is_deeply( $result, $data->{output}, 'filled' );
                done_testing();
            };
        }
    }
    done_testing();
};

done_testing();
