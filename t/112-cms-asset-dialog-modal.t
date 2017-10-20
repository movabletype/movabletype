#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test qw( :app :db :data );
plan tests => 1;

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

    ok( $out =~ /<option value="file"/,
        'has Files in Asset Type select box' );
    ok( $out =~ /<option value="video"/,
        'has Videos in Asset Type select box'
    );
    ok( $out =~ /<option value="audio"/,
        'has Audio in Asset Type select box'
    );
    ok( $out =~ /<option value="image"/,
        'has Images in Asset Type select box'
    );

    done_testing();
};
