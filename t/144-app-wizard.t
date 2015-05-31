use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use Test::More;
use File::Copy;

use lib 't/lib', 'lib', 'extlib';
use MT::Test qw( :app );
use MT::App::Wizard;

# Generate dummy mt-config.cgi when not existing.
my $no_config_file;
if ( $no_config_file = !-e 'mt-config.cgi' ) {
    copy( 't/mysql-test.cfg', 'mt-config.cgi' )
        or plan skip_all => 'Cannot generate mt-config.cgi';
}

END {
    if ($no_config_file) {
        unlink 'mt-config.cgi';
    }
}

subtest 'MT::App::Wizard behavior when mt-config.cgi exists' => sub {
    my $app = _run_app(
        'MT::App::Wizard',
        {   __request_method => 'GET',
            __mode           => 'retry',
            step             => 'configure',
        },
    );
    my $out = delete $app->{__test_output};

    ok( $out, 'Request: mt-wizard.cgi?__mode=retry&step=configure' );

    {
        my $title
            = quotemeta '<h1 id="page-title">Configuration File Exists</h1>';
        ok( $out =~ m/$title/, 'Title is "Configuration File Exists"' );
    }

    {
        my $title
            = quotemeta '<h1 id="page-title">Database Configuration</h1>';
        ok( $out !~ m/$title/, 'Title is not "Database Configuration"' );
    }
};

done_testing;
