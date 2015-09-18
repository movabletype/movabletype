#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib qw( lib extlib t/lib );

use MT::Test qw( :app :db );
use MT::Test::Permission;

use Test::More;
use MT;

my $plugin = MT->component('GoogleOpenIDConnect');

# Website
my $website = MT::Test::Permission->make_website();

require GoogleOpenIDConnect::Auth::GoogleOIDC;
my $reason;

subtest 'webservice conditions' => sub {

    # no data
    my $error_msg
        = '<a href="?__mode=cfg_web_services&amp;blog_id='
        . $website->id . '">'
        . $plugin->translate('Set up Google OpenID Connect') . '</a>';

    my $return;

    $return = GoogleOpenIDConnect::Auth::GoogleOIDC::condition( $website,
        \$reason );
    ok( $reason eq $error_msg, 'no plugin data' );
    ok( $return == 0,          'condition return value' );

    # client_secret not data
    $plugin->save_config(
        {   client_id     => 'client_id',
            client_secret => '',
        },
        'system'
    );

    $reason = '';
    $return = GoogleOpenIDConnect::Auth::GoogleOIDC::condition( $website,
        \$reason );
    ok( $reason eq $error_msg, 'client_secret not data' );
    ok( $return == 0,          'condition return value' );

    $plugin->reset_config();

    # client_secret not data
    $plugin->save_config(
        {   client_id     => '',
            client_secret => 'client_secret',
        },
        'system'
    );

    $reason = '';
    $return = GoogleOpenIDConnect::Auth::GoogleOIDC::condition( $website,
        \$reason );
    ok( $reason eq $error_msg, 'client_id not data' );
    ok( $return == 0,          'condition return value' );

    $plugin->reset_config();

    $plugin->save_config(
        {   client_id     => 'client_id',
            client_secret => 'client_secret',
        },
        'system'
    );

    $reason = '';
    $return = GoogleOpenIDConnect::Auth::GoogleOIDC::condition( $website,
        \$reason );
    ok( $reason eq '', 'plugin data ok' );
    ok( $return == 1,  'condition return value' );
    $plugin->reset_config();

    # website data
    $plugin->save_config(
        {   client_id     => 'client_id',
            client_secret => 'client_secret',
        },
        'blog:' . $website->id
    );

    $reason = '';
    $return = GoogleOpenIDConnect::Auth::GoogleOIDC::condition( $website,
        \$reason );
    ok( $reason eq '', 'plugin data ok' );
    ok( $return == 1,  'condition return value' );
};

done_testing();

