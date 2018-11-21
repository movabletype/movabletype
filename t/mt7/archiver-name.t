use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

my @archive_types = MT->publisher->archive_types;

plan tests => scalar @archive_types;

for my $archive_type (@archive_types) {
    my $archiver = MT->publisher->archiver($archive_type);
    is( $archiver->name, $archive_type );
}

done_testing;
