#!/usr/bin/perl -w

use strict;
use warnings;

use lib 't/lib';
use MT::Test qw(:newdb);

use Test::More;


plan tests => 8;

{
    diag('test MT::CMS::Tools::upgrade');

    # Uninitialize MT so our MT instance can be a new MT::App::CMS, not the MT
    # that MT::Test instantiated.
    undef $MT::mt_inst;
    eval { undef %MT::mt_inst };
    undef @MT::Components;
    undef %MT::Components;
    undef %MT::Plugins;
    undef $MT::MT_DIR;

    require MT::App::CMS;
    my $app = MT::App::CMS->instance;
    diag('Object types are: ' . join(q{, }, keys %{ MT->registry('object_types') }));

    require MT::CMS::Tools;
    my $ret = MT::CMS::Tools::upgrade($app);

    ok(!defined $ret, 'result of upgrade() is not page content');
    ok(!$app->errstr, 'upgrade() did not error');
    diag($app->errstr) if $app->errstr;
    ok(MT->instance->{redirect}, 'app has a redirect url');

    like(MT->instance->{redirect}, qr/ \b__mode=install\b /xms, "app's redirect url uses install mode");

    # magic 'install' of db tables
    MT::Test->init_upgrade();
    MT::Test->init_data();

    $ret = MT::CMS::Tools::upgrade(MT->instance);

    ok(!defined $ret, 'result of upgrade() is not page content');
    ok(!$app->errstr, 'upgrade() did not error');
    diag($app->errstr) if $app->errstr;
    ok(MT->instance->{redirect}, 'app has a redirect url');

    unlike(MT->instance->{redirect}, qr/ install /xms, "app's redirect url does not use install mode");
}

1;

