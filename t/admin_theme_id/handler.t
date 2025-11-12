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

my $cfg = MT->instance->config;

subtest 'single fallback id' => sub {
    $cfg->AdminThemeId('admin2025');
    $cfg->FallbackAdminThemeIds(['admin2023']);

    is scalar $cfg->AdminThemeId, 'admin2025';
    is_deeply [$cfg->AdminThemeId],          ['admin2025', 'admin2023', ''];
    is_deeply [$cfg->FallbackAdminThemeIds], ['admin2023'];
};

subtest 'multiple fallback ids' => sub {
    $cfg->AdminThemeId('admin2025');
    $cfg->FallbackAdminThemeIds(['admin2023', 'admin2021']);

    is scalar $cfg->AdminThemeId, 'admin2025';
    is_deeply [$cfg->AdminThemeId], ['admin2025', 'admin2023', 'admin2021', ''];
    is_deeply [$cfg->FallbackAdminThemeIds], ['admin2023', 'admin2021'];
};

subtest 'duplicated fallback ids' => sub {
    $cfg->AdminThemeId('admin2025');
    $cfg->FallbackAdminThemeIds(['admin2023', 'admin2025', '']);

    is scalar $cfg->AdminThemeId, 'admin2025';
    is_deeply [$cfg->AdminThemeId],          ['admin2025', 'admin2023', ''];
    is_deeply [$cfg->FallbackAdminThemeIds], ['admin2023', 'admin2025', ''];
};

subtest 'no fallback id' => sub {
    $cfg->AdminThemeId(undef);
    $cfg->FallbackAdminThemeIds([]);

    is scalar $cfg->AdminThemeId, 'admin2025';
    is_deeply [$cfg->AdminThemeId],          ['admin2025', ''];
    is_deeply [$cfg->FallbackAdminThemeIds], [];
};

subtest 'no admin ids' => sub {
    $cfg->AdminThemeId('');
    $cfg->FallbackAdminThemeIds(undef);

    is scalar $cfg->AdminThemeId, '';
    is_deeply [$cfg->AdminThemeId],          [''];
    is_deeply [$cfg->FallbackAdminThemeIds], [];
};

done_testing;
