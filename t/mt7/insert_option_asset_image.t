use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';

    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}
use MT::Test;
use MT::Test::Permission;
use MT::Author;
use MT::Asset;

MT::Test->init_app;

$test_env->prepare_fixture('db_data');

my $author = MT::Author->load(1);

my $blog  = MT::Blog->load(1);
my $blog2 = MT::Test::Permission->make_blog(
    name                  => 'asset_test2',
    'default_image_width' => '300'
);

my $asset = MT::Asset->load( { blog_id => $blog->id, class => 'image' },
    { limit => 1 } );
my $asset2 = MT::Test::Permission->make_asset(
    class   => 'image',
    blog_id => $blog2->id,
    url     => 'http://narnia.na/nana/images/test.jpg',
    file_path =>
        File::Spec->catfile( $ENV{MT_HOME}, "t", 'images', 'test.jpg' ),
    file_name    => 'test.jpg',
    file_ext     => 'jpg',
    image_width  => 640,
    image_height => 480,
    mime_type    => 'image/jpeg',
    label        => 'Userpic A',
    description  => 'Userpic A',
);

subtest 'insert option template' => sub {
    subtest 'No default width setting in the entry settings.' => sub {
        subtest 'the width of the asset image is 600px or more.' => sub {
            my $asset_module = Test::MockModule->new('MT::Asset::Image');
            $asset_module->mock(
                'image_width',
                sub {
                    return 650;
                }
            );

            my $width  = $asset->image_width;
            my $output = request_insert_option($asset);

            ok( $output, 'Output' ) or return;
            check_insert_option_template( $output, $width, 600 );
        };

        subtest 'the width of the asset image is less than 600px.' => sub {
            my $asset_module = Test::MockModule->new('MT::Asset::Image');
            $asset_module->mock(
                'image_width',
                sub {
                    return 500;
                }
            );
            my $width  = $asset->image_width;
            my $output = request_insert_option($asset);

            ok( $output, 'Output' ) or return;
            check_insert_option_template( $output, $width, $width );
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
            my $width  = $blog->image_default_width;
            my $output = request_insert_option($asset);

            ok( $output, 'Output' ) or return;
            check_insert_option_template( $output, $width, 600 );
        };

        subtest 'the width of the asset image is less than 600px.' => sub {
            my $asset_module = Test::MockModule->new('MT::Asset::Image');
            $asset_module->mock(
                'image_width',
                sub {
                    return 400;
                }
            );
            my $width  = $blog->image_default_width;
            my $output = request_insert_option($asset);

            ok( $output, 'Output' ) or return;
            check_insert_option_template( $output, $width, 600 );
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

            my $width  = $blog->image_default_width;
            my $output = request_insert_option($asset);

            ok( $output, 'Output' ) or return;
            check_insert_option_template( $output, $width, $width );
        };

        subtest 'the width of the asset image is less than 600px.' => sub {
            my $asset_module = Test::MockModule->new('MT::Asset::Image');
            $asset_module->mock(
                'image_width',
                sub {
                    return 400;
                }
            );

            my $width  = $blog->image_default_width;
            my $output = request_insert_option($asset);

            ok( $output, 'Output' ) or return;
            check_insert_option_template( $output, $width,
                $blog->image_default_width );
        };
        };
    done_testing;
};

subtest 'insert asset image (default)' => sub {
    my $width        = $asset->image_width;
    my $before_count = MT::Asset->count(
        { blog_id => $asset->blog_id, class => 'image' } );
    my $json   = set_prefs_json( $asset, 0, $width );
    my $output = request_insert_asset( $asset, $json, 0 );

    ok( $output, 'Output' ) or return;
    is( $before_count,
        MT::Asset->count( { blog_id => $asset->blog_id, class => 'image' } ),
        'Use default image.'
    );
    like(
        $output,
        qr/\\\<img.*width=\\\"$width\\\"/,
        'Set the default image width.'
    );

    done_testing;
};

subtest 'insert asset image (custom)' => sub {
    my $width = 300;
    my $before_count
        = MT::Asset->count( { blog_id => $blog2->id, class => 'image' } );

    my $json   = set_prefs_json( $asset2, 1, $width );
    my $output = request_insert_asset( $asset2, $json, 1 );

    ok( $output, 'Output' ) or return;
    is( ( $before_count + 1 ),
        MT::Asset->count( { blog_id => $blog2->id, class => 'image' } ),
        'Add custom width image.'
    );
    like(
        $output,
        qr/\\\<img.*width=\\\"$width\\\"/,
        'Sets a custom width for the image.'
    );

    done_testing;
};

done_testing;

sub request_insert_option {
    my $asset_obj = shift;
    my $app       = _run_app(
        'MT::App::CMS',
        {   __test_user  => $author,
            __method     => 'POST',
            __mode       => 'dialog_insert_options',
            _type        => 'asset',
            dialog_view  => 1,
            no_insert    => 0,
            dialog       => 1,
            id           => $asset_obj->id,
            edit_field   => 'editor-input-content',
            blog_id      => $asset_obj->blog_id,
            force_insert => 1,
            entry_insert => 1,
        },
    );

    my $output = delete $app->{__test_output};
    return $output || '';
}

sub check_insert_option_template {
    my ( $output, $width, $custom_width ) = @_;
    like( $output, qr/<h4.*>Insert Options<\/h4>/, 'Insert Option page.' );
    like( $output, qr/<label>(Side width)<\/label>/,
        'set side width label.' );
    like(
        $output,
        qr/<option (value=\"0\").*(data-width=\"$width\")>.*(Original size).*<\/option>/s,
        'Set side width original item value.'
    );
    like(
        $output,
        qr/<option (value=\"1\").*(data-width=\"$custom_width\").*(Custom\.\.\.).*<\/option>/s,
        'Set side width default item value when custom.'
    );
}

sub set_prefs_json {
    my ( $asset_obj, $thumb, $width ) = @_;
    my $fname = "fname-" . $asset_obj->id;
    my $align = "align-" . $asset_obj->id;

    my $json = JSON::to_json(
        [   {   id           => $asset_obj->id,
                thumb        => $thumb,
                include      => 1,
                $fname       => $asset_obj->file_name,
                thumb_width  => $width,
                thumb_height => '',
                $align       => 'none'
            }
        ],
        { canonical => 1 }
    );

    return $json || '';
}

sub request_insert_asset {
    my ( $asset_obj, $json, $new_entry ) = @_;
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user => $author,
            __method    => 'POST',
            __mode      => 'insert_asset',
            blog_id     => $asset_obj->blog_id,
            edit_field  => 'editor-input-content',
            prefs_json  => $json,
            new_entry   => $new_entry
        },
    );
    my $output = delete $app->{__test_output};
    return $output || '';
}
