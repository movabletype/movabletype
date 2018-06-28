#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

BEGIN {
    use File::Basename qw( dirname );
    use File::Spec;
    my $plugin_home = dirname( dirname( File::Spec->rel2abs(__FILE__) ) );
    push @INC, "$plugin_home/lib", "$plugin_home/extlib";
}
use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

$test_env->prepare_fixture('db_data');

my $mt    = MT->instance;
my $admin = $mt->model('author')->load(1);
my $blog  = $mt->model('blog')->load(1);

subtest 'blockeditor_dialog_list_asset' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'blockeditor_dialog_list_asset',
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

    ok( $out =~ /<div id="listing"/, 'has listing' );
};

subtest 'blockeditor_dialog_list_asset_permission' => sub {
    # Author
    my $user = MT::Test::Permission->make_author(
        name     => 'test_user',
        nickname => 'User Test',
    );

    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'POST',
            __mode           => 'blockeditor_dialog_list_asset',
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
    ok( $out =~ m!permission=1!i, "blockeditor_dialog_list_asset by non permitted user." );
};

done_testing();

