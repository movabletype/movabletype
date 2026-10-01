use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new();
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Util::UniqueID;

subtest 'uuid' => sub {
    my $uuid = MT::Util::UniqueID::create_uuid();
    ok $uuid, "uuid";
};

subtest 'uuid (pp)' => sub {
    local $SIG{__WARN__} = sub {};
    local *UUID::URandom::create_uuid_string = sub { die };

    my $uuid = MT::Util::UniqueID::create_uuid();
    ok $uuid, "uuid";
};

for my $name (qw(md5 sha1 sha256 sha512)) {
    subtest $name => sub {
        no strict 'refs';
        my $func = "MT::Util::UniqueID::create_${name}_id";
        my $id = &$func();
        ok $id, $name;
    };
}

subtest 'magic_token' => sub {
    my $token = MT::Util::UniqueID::create_magic_token();
    ok $token, "magic_token";
};

subtest 'session_id' => sub {
    my $id = MT::Util::UniqueID::create_session_id();
    ok $id, "session_id";
};

subtest 'api_password' => sub {
    my $pass = MT::Util::UniqueID::create_session_id();
    ok $pass, "api_password";
};

done_testing;
