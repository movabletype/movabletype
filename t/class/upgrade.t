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

use MT;
use MT::Upgrade;

my $mt  = MT->instance;
my $cfg = $mt->config;

subtest 'needs_upgrade_schema_version' => sub {
    $cfg->SchemaVersion(undef);
    ok( MT::Upgrade->needs_upgrade_schema_version,
        'true when current is undefined'
    );

    $cfg->SchemaVersion(1);
    $MT::SCHEMA_VERSION = 1.5;
    ok( MT::Upgrade->needs_upgrade_schema_version,
        'true when current is smaller than new'
    );

    $cfg->SchemaVersion(3);
    $MT::SCHEMA_VERSION = 2;
    ok( !MT::Upgrade->needs_upgrade_schema_version,
        'false when current is bigger than new'
    );

    $cfg->SchemaVersion(5.6);
    $MT::SCHEMA_VERSION = 5.6;
    ok( !MT::Upgrade->needs_upgrade_schema_version,
        'false when current is equal to old'
    );
};

subtest 'needs_upgrade_mt_version' => sub {
    $cfg->MTVersion(undef);
    ok( MT::Upgrade->needs_upgrade_mt_version,
        'true when current is undefined'
    );

    $cfg->MTVersion(1);
    $MT::VERSION = 1.5;
    ok( MT::Upgrade->needs_upgrade_mt_version,
        'true when current is smaller than new'
    );

    $cfg->MTVersion(3);
    $MT::VERSION = 2;
    ok( !MT::Upgrade->needs_upgrade_mt_version,
        'true when current is bigger than new'
    );

    $cfg->MTVersion(5.6);
    $MT::VERSION = 5.6;
    ok( !MT::Upgrade->needs_upgrade_mt_version,
        'true when current is equal to new'
    );
};

subtest 'needs_upgrade_mt_release_number' => sub {
    $cfg->MTVersion(undef);
    $cfg->MTReleaseNumber(4);
    $MT::RELEASE_NUMBER = 3;
    ok( MT::Upgrade->needs_upgrade_mt_release_number,
        'true when current version_number is undefined'
    );

    $cfg->MTVersion(1);
    $MT::VERSION = 2;
    $cfg->MTReleaseNumber(4);
    $MT::RELEASE_NUMBER = 3;
    ok( MT::Upgrade->needs_upgrade_mt_release_number,
        'true when current version_number is smaller than new one' );

    $cfg->MTVersion(2);
    $MT::VERSION = 1;
    $cfg->MTReleaseNumber(3);
    $MT::RELEASE_NUMBER = 4;
    ok( !MT::Upgrade->needs_upgrade_mt_release_number,
        'false when current version_number is bigger than new one'
    );
    $cfg->MTReleaseNumber(undef);
    ok( MT::Upgrade->needs_upgrade_mt_release_number,
        'true when current release_number is undefined'
    );

    $cfg->MTVersion(1);
    $MT::VERSION = 2;
    $cfg->MTReleaseNumber(3);
    $MT::RELEASE_NUMBER = 4;
    ok( MT::Upgrade->needs_upgrade_mt_release_number,
        'true when current version_nubmer/release_number is smaller than new one'
    );

    $cfg->MTVersion(1);
    $MT::VERSION = 1;
    $cfg->MTReleaseNumber(3);
    $MT::RELEASE_NUMBER = 4;
    ok( MT::Upgrade->needs_upgrade_mt_release_number,
        'true when current version_number is equal to new one and current release_number is smaller than new one'
    );

    $cfg->MTVersion(1);
    $MT::VERSION = 2;
    $cfg->MTReleaseNumber(4);
    $MT::RELEASE_NUMBER = 4;
    ok( MT::Upgrade->needs_upgrade_mt_release_number,
        'false when current release_number is equal to new one'
    );

    $cfg->MTVersion(1);
    $MT::VERSION = 2;
    $cfg->MTReleaseNumber(4);
    $MT::RELEASE_NUMBER = 3;
    ok( MT::Upgrade->needs_upgrade_mt_release_number,
        'false when current release_number is bigger than new one' );
};

done_testing;

