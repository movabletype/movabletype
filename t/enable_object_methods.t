use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
$ENV{MT_APP} = 'MT::App::CMS';
MT::Test->init_app;

my $enable_methods
    = MT->registry( 'applications', 'cms', 'enable_object_methods' );
my $disable_methods
    = MT->registry( 'applications', 'cms', 'disable_object_methods' );

for my $obj ( keys %$enable_methods ) {
    my $enable_registy = $enable_methods->{$obj};
    my $disable_registy = $disable_methods->{$obj} || {};

    for my $method (qw/ delete edit save /) {
        my $enable_value = $enable_registy->{$method};
        $enable_value = $enable_value->() if ref $enable_value eq 'CODE';

        my $disable_value = $disable_registy->{$method};
        $disable_value = $disable_value->() if ref $disable_value eq 'CODE';

        is( !!$enable_value, !$disable_value, "$obj - $method" );
    }
}

done_testing;

