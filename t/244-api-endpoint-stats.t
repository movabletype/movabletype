#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

BEGIN {
    use Test::More;
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

use lib qw(lib extlib t/lib);

eval(
    $ENV{SKIP_REINITIALIZE_DATABASE}
    ? "use MT::Test qw(:app);"
    : "use MT::Test qw(:app :db :data);"
);

use MT::App::DataAPI;
use MT::DataAPI::Endpoint::Stats;

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
