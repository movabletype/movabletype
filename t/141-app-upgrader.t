#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'upgrader-test.cfg';
}

use lib 'lib', 'extlib', 't/lib', '../lib', '../extlib';
use MT::Test qw( :app );
use MT::Test::Permission;
use Test::More;

my ( $app, $out );

subtest 'Check displaying both website and blog themes in install view' =>
    sub {
    $app = _run_app(
        'MT::App::Upgrader',
        {   __request_method       => 'POST',
            __mode                 => 'init_user',
            admin_username         => 'admin',
            admin_nickname         => 'admin',
            admin_email            => 'miuchi+test@sixapart.com',
            use_system_email       => 'on',
            preferred_language     => 'en-us',
            admin_password         => 'password',
            admin_password_confirm => 'password',
            continue               => 1,
        },
    );
    $out = delete $app->{__test_output};

    my $title = '<title>Create Your First Website | Movable Type</title>';
    like( $out, qr/$title/, '"Create Website" view is displayed.' );
    my $optgrp_website = quotemeta '<optgroup label="Website">';
    like( $out, qr/$optgrp_website/,
        '"Create Website" view has website\'s optgroup tag.' );
    my $optgrp_blog = quotemeta '<optgroup label="Blog">';
    like( $out, qr/$optgrp_blog/,
        '"Create Website" view has blog\'s optgroup tag.' );
    };

done_testing;
