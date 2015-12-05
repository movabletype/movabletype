#!/usr/bin/perl

use strict;
use warnings;

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use lib qw( lib extlib t/lib ../lib ../extlib );
use MT::Test qw( :app :db :data );
use Test::More tests => 1;

my $mt    = MT->instance;
my $admin = $mt->model('author')->load(1);
my $blog  = $mt->model('blog')->load(1);

subtest 'dialog_asset_modal' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'dialog_asset_modal',
            __type           => 'asset',
            edit_field       => 'editor-input-content',
            blog_id          => $blog->id,
            dialog_view      => 1,
            filter           => 'class',
            filter_val       => 'image',
            can_multi        => 1,
            dialog           => 1,
        }
    );
    my $out = delete $app->{__test_output};
    unlike( $out, qr/generic-error/, 'no error' );

    done_testing();
};
