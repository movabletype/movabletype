#!/usr/bin/perl
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
use MT::Test;

MT::Test->init_db;
is(MT->config('DefaultAccessAllowed'), 1); # core default
my $mgr = MT->config;
$mgr->set('DefaultAccessAllowed', 0, 1);   # write explicitly into DB
is(MT->config('DefaultAccessAllowed'), 0); # value retrieved
MT::Test->init_db;
is(MT->config('DefaultAccessAllowed'), 1); # core default again
$mgr->set('DefaultAccessAllowed', 0, 0);
MT::Test->init_db;
is(MT->config('DefaultAccessAllowed'), 0); # file value is prefered

# env

is $mgr->EmailAddressMain => $ENV{MT_CONFIG_EMAIL_ADDRESS_MAIN}, "EmailAddressMain is overriden by the env";
is $mgr->CMSSearchLimit   => $ENV{MT_CONFIG_CMSSEARCHLIMIT},     "CMSSearchLimit is overriden by the env";
is $mgr->RsyncOptions     => $ENV{MT_CONFIG_RsyncOptions},       "RsyncOptions is overriden by the env";

$mgr->EmailAddressMain('something different', 1);
$mgr->CMSSearchLimit('something different', 1);
$mgr->RsyncOptions('something different', 1);
$mgr->save_config;

is $mgr->EmailAddressMain => $ENV{MT_CONFIG_EMAIL_ADDRESS_MAIN}, "EmailAddressMain is still overriden by the env";
is $mgr->CMSSearchLimit   => $ENV{MT_CONFIG_CMSSEARCHLIMIT},     "CMSSearchLimit is still overriden by the env";
is $mgr->RsyncOptions     => $ENV{MT_CONFIG_RsyncOptions},       "RsyncOptions is still overriden by the env";

my $config = $mgr->stringify_config;
unlike $config => qr/(EmailAddressMain|CMSSearchLimit|RsyncOptions)/, "keys set by the env are not listed in the stringified config";
unlike $config => qr/something different/, "no 'something different'";

done_testing;
