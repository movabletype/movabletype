#!/usr/bin/perl
use strict;
use warnings;

use Test::More;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib qw( t t/lib ./extlib ./lib);

use MT::Test;
MT::Test->init_app;
MT::Test->init_db;
MT->instance;
use MT::Asset;

subtest 'handler_for_file' => sub {
    my $pkg = MT::Asset->handler_for_asset('sample.jpg');
    ok( $pkg,                       "JPEG" );
    ok( $pkg eq 'MT::Asset::Image', "JPEG" );
};

subtest 'handler_for_oembed' => sub {
    my $pkg; 

    $pkg = MT::Asset->handler_for_asset('https://www.youtube.com/watch?v=gagagagagagaga');
    ok( $pkg,                                 "YouTube" );
    ok( $pkg eq 'MT::Asset::oEmbed::YouTube', "YouTube" );

    $pkg = MT::Asset->handler_for_asset('https://vimeo.com/000000000');
    ok( $pkg,                        "vimeo" );
    ok( $pkg eq 'MT::Asset::oEmbed', "vimeo" );
};

subtest 'New YouTube' => sub {
    my $asset = MT::Asset::oEmbed::YouTube->new;
    ok( $asset, "YouTube->new" );

    $asset->url('https://www.youtube.com/watch?v=q2-_TNyh4W4');
    $asset->get_embed();
    ok( $asset->title eq 'Introduction of the coding style at Six Apart', 'YouTube->title' );

    $asset->blog_id(1);
    $asset->save;
    ok( $asset->id, "YouTube->save" );
};

done_testing();
