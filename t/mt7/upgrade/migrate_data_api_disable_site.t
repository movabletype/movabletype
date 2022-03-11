use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Upgrade;

$test_env->prepare_fixture('db');

subtest 'Migrate DataAPIDisableSite as disalbed' => sub {
    my $website = MT::Test::Permission->make_website(name => 'my website');
    is($website->allow_data_api, undef);
    _update_data_api_disable_site($website, 1); # Add to DataAPIDisableSite 

    MT::Test::Upgrade->upgrade(from => 7.0045);

    $website = MT->model('website')->load($website->id);
    is($website->allow_data_api, 0);
};

subtest 'Migrate DataAPIDisableSite as enabled' => sub {
    my $website = MT::Test::Permission->make_website(name => 'my website');
    is($website->allow_data_api, undef);
    _update_data_api_disable_site($website, 0); # No add to DataAPIDisableSite 

    MT::Test::Upgrade->upgrade(from => 7.0045);

    $website = MT->model('website')->load($website->id);
    is($website->allow_data_api, 1);
};

subtest 'Clean up DataAPIDisableSite after this migration with system config' => sub {
    MT->config->DataAPIDisableSite('0,1000,1001', 1);
    MT->config->save_config;

    MT::Test::Upgrade->upgrade(from => 7.0045);

    is(MT->config->DataAPIDisableSite, '0');
};

subtest 'Clean up DataAPIDisableSite after this migration' => sub {
    MT->config->DataAPIDisableSite('1000,1001', 1);
    MT->config->save_config;

    MT::Test::Upgrade->upgrade(from => 7.0045);

    is(MT->config->DataAPIDisableSite, '');
};

subtest 'Clean up DataAPIDisableSite after this migration from MT5' => sub {
    my $website = MT::Test::Permission->make_website(name => 'my website');

    MT::Test::Upgrade->upgrade(from => 5);

    $website = MT->model('website')->load($website->id);
    is($website->allow_data_api, 0);
    is(MT->config->DataAPIDisableSite, '');
};

sub _update_data_api_disable_site {
    my ($site, $adding) = @_;
    my $cfg = MT->config;
    my $previous_data_api_disable_site = $cfg->DataAPIDisableSite;
    my %previous_data_api_disable_site = map { $_ => 1 } split ',', $previous_data_api_disable_site;
    if ($adding) {
        $previous_data_api_disable_site{$site->id} = $adding;
    } else {
        delete $previous_data_api_disable_site{$site->id};
    }
    my $new_data_api_disable_site = join ',', sort { $a <=> $b } keys %previous_data_api_disable_site;
    $cfg->DataAPIDisableSite($new_data_api_disable_site, 1);
    $cfg->save_config;
}

done_testing;
