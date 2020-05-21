#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';

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
    ok( $out =~ m!permission=1!i,
        "blockeditor_dialog_list_asset by non permitted user." );
};

subtest 'blockeditor_dialog_insert_options' => sub {
    my $out = request_insert_option();

    ok( $out, 'Output' ) or return;
    like( $out, qr/<label.*(Side width)<\/label>/, 'set side width label.' );
    like(
        $out,
        qr/<option (value=\"0\").*>.*(Original size).*<\/option>/s,
        'Set side width original item value.'
    );
    like(
        $out,
        qr/<option (value=\"1\").*(Custom\.\.\.).*<\/option>/s,
        'Set side width default item value when custom.'
    );
    like( $out, qr/<label>(Alignment)<\/label>/, 'Alignment label.' );
};

subtest 'blockeditor_dialog_insert_options:image_width' => sub {
    subtest 'No default width setting in the entry settings.' => sub {
        subtest 'the width of the asset image is 600px or more.' => sub {
            my $asset_module = Test::MockModule->new('MT::Asset::Image');
            $asset_module->mock(
                'image_width',
                sub {
                    return 601;
                }
            );
            my $out = request_insert_option();
            ok( $out, 'Output' ) or return;
            like(
                $out,
                qr/(<input type=\"number\" name=\"thumb_width-).*(value=\"600\")/,
                'Width value is 600px.'
            );
        };

        subtest 'the width of the asset image is less than 600px.' => sub {
            my $asset_module = Test::MockModule->new('MT::Asset::Image');
            $asset_module->mock(
                'image_width',
                sub {
                    return 400;
                }
            );
            my $out = request_insert_option();
            ok( $out, 'Output' ) or return;
            like(
                $out,
                qr/(<input type=\"number\" name=\"thumb_width-).*(value=\"400\")/,
                'Width value is 400px.'
            );
        };
    };

    subtest
        'the default width of the image is 600px or more in the entry settings.'
        => sub {
        my $blog_module = Test::MockModule->new('MT::Blog');
        $blog_module->mock(
            'image_default_width',
            sub {
                return 601;
            }
        );

        subtest 'the width of the asset image is 600px or more.' => sub {
            my $asset_module = Test::MockModule->new('MT::Asset::Image');
            $asset_module->mock(
                'image_width',
                sub {
                    return 601;
                }
            );
            my $out = request_insert_option();
            ok( $out, 'Output' ) or return;
            like(
                $out,
                qr/(<input type=\"number\" name=\"thumb_width-).*(value=\"600\")/,
                'Width value is 600px.'
            );
        };

        subtest 'the width of the asset image is less than 600px.' => sub {
            my $asset_module = Test::MockModule->new('MT::Asset::Image');
            $asset_module->mock(
                'image_width',
                sub {
                    return 400;
                }
            );
            my $out = request_insert_option();
            ok( $out, 'Output' ) or return;
            like(
                $out,
                qr/(<input type=\"number\" name=\"thumb_width-).*(value=\"600\")/,
                'Width value is 600px.'
            );
        };
        };

    subtest
        'the default width of the image is less than 600px in the entry settings.'
        => sub {
        my $blog_module = Test::MockModule->new('MT::Blog');
        $blog_module->mock(
            'image_default_width',
            sub {
                return 500;
            }
        );

        subtest 'the width of the asset image is 600px or more.' => sub {
            my $asset_module = Test::MockModule->new('MT::Asset::Image');
            $asset_module->mock(
                'image_width',
                sub {
                    return 601;
                }
            );
            my $out = request_insert_option();
            ok( $out, 'Output' ) or return;
            like(
                $out,
                qr/(<input type=\"number\" name=\"thumb_width-).*(value=\"500\")/,
                'Width value is 500px.'
            );
        };

        subtest 'the width of the asset image is less than 600px.' => sub {
            my $asset_module = Test::MockModule->new('MT::Asset::Image');
            $asset_module->mock(
                'image_width',
                sub {
                    return 400;
                }
            );
            my $out = request_insert_option();
            ok( $out, 'Output' ) or return;
            like(
                $out,
                qr/(<input type=\"number\" name=\"thumb_width-).*(value=\"500\")/,
                'Width value is 500px.'
            );
        };
        };

};

done_testing();

sub request_insert_option {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user         => $admin,
            __request_method    => 'POST',
            __mode              => 'blockeditor_dialog_insert_options',
            __type              => 'asset',
            edit_field          => 'editor-input-content',
            blog_id             => $blog->id,
            dialog_view         => 1,
            no_insert           => 0,
            id                  => 1,
            direct_asset_insert => 1,
            asset_select        => 1,
        }
    );
    my $output = delete $app->{__test_output};
    return $output || '';
}

