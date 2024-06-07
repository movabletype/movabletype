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

    # config directive set by MT::Test::Env
    $ENV{MT_CONFIG_EMAIL_ADDRESS_MAIN} = 'mt_test@localhost.localdomain';

    # config directive that has a default value
    $ENV{MT_CONFIG_CMSSEARCHLIMIT} = 1000;

    # config_directive that has no default value
    $ENV{MT_CONFIG_RsyncOptions} = '-v';
}

use MT::Test::PHP;
use MT::Test::Tag;

$test_env->prepare_fixture('db');

my $cnf = MT->config;
is $cnf->EmailAddressMain => $ENV{MT_CONFIG_EMAIL_ADDRESS_MAIN}, "EmailAddressMain is overriden by the env";
is $cnf->CMSSearchLimit   => $ENV{MT_CONFIG_CMSSEARCHLIMIT},     "CMSSearchLimit is overriden by the env";
is $cnf->RsyncOptions     => $ENV{MT_CONFIG_RsyncOptions},       "RsyncOptions is overriden by the env";

$cnf->EmailAddressMain('something different', 1);
$cnf->CMSSearchLimit('something different', 1);
$cnf->RsyncOptions('something different', 1);
$cnf->save_config;

is $cnf->EmailAddressMain => $ENV{MT_CONFIG_EMAIL_ADDRESS_MAIN}, "EmailAddressMain is still overriden by the env";
is $cnf->CMSSearchLimit   => $ENV{MT_CONFIG_CMSSEARCHLIMIT},     "CMSSearchLimit is still overriden by the env";
is $cnf->RsyncOptions     => $ENV{MT_CONFIG_RsyncOptions},       "RsyncOptions is still overriden by the env";

my $config = $cnf->stringify_config;
unlike $config => qr/(EmailAddressMain|CMSSearchLimit|RsyncOptions)/, "keys set by the env are not listed in the stringified config";
unlike $config => qr/something different/, "no 'something different'";

MT::Test::Tag->run_perl_tests(1);
MT::Test::Tag->run_php_tests(1);

done_testing;

__DATA__

=== env with underscores
--- template
<mt:var name="config.EmailAddressMain">
--- expected eval
$ENV{MT_CONFIG_EMAIL_ADDRESS_MAIN}

=== env without underscores
--- template
<mt:var name="config.CMSSearchLimit">
--- expected eval
$ENV{MT_CONFIG_CMSSEARCHLIMIT}

=== env with mixed cases
--- template
<mt:var name="config.RsyncOptions">
--- expected eval
$ENV{MT_CONFIG_RsyncOptions}
