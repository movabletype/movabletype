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
my $blog2 = MT::Test::Permission->make_blog( name => 'blog2' );
my $blog3 = MT::Test::Permission->make_blog(
    name                => 'blog3',
    image_default_width => 400
);

subtest 'Entry default image settings.' => sub {
    subtest 'No default image set' => sub {
        my $output = entry_config_request();
        ok( $output, 'Output' ) or return;
        check_image_option_template($output);
    };

    subtest 'default image set' => sub {
        my $blog_module = Test::MockModule->new('MT::Blog');
        $blog_module->mock(
            'image_default_width',
            sub {
                return 500;
            }
        );

        my $output = entry_config_request();
        ok( $output, 'Output' ) or return;
        check_image_option_template( $output, 1, 500 );

    };
};

subtest 'Save default image settings for entry.' => sub {
    subtest 'default image width set' => sub {
        my $output = entry_config_save_request( $blog2, 1, 444 );
        ok( $output, 'Output' ) or return;

        like( $output, qr/Status.*302/, '302 status' );
        my $check = MT::Blog->load( $blog2->id );
        is( 444, $check->image_default_width, 'Default width setting is OK' );
    };

    subtest 'Restore default' => sub {
        my $output = entry_config_save_request( $blog3, 0, 333 );
        ok( $output, 'Output' ) or return;

        like( $output, qr/Status.*302/, '302 status' );
        my $check = MT::Blog->load( $blog3->id );

        is( 0, $check->image_default_width, 'Default width setting is OK' );
    };
};

done_testing;

sub entry_config_request {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $author,
            __request_method => 'GET',
            __mode           => 'cfg_entry',
            __type           => 'website',
            blog_id          => $blog->id,
        }
    );
    my $output = delete $app->{__test_output};
    return $output || '';
}

sub entry_config_save_request {
    my ( $blog_obj, $thumb, $width ) = @_;
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user         => $author,
            __request_method    => 'POST',
            __mode              => 'save',
            _type               => 'website',
            id                  => $blog_obj->id,
            blog_id             => $blog_obj->id,
            cfg_screen          => 'cfg_entry',
            list_on_index       => 10,
            days_or_posts       => 'posts',
            sort_order_posts    => 'descend',
            words_in_excerpt    => 40,
            date_language       => 'ja',
            basename_limit      => 100,
            status_default      => 2,
            convert_paras       => 'richtext',
            entry_custom_prefs  => 'title',
            entry_custom_prefs  => 'text',
            entry_custom_prefs  => 'category',
            entry_custom_prefs  => 'tags',
            entry_custom_prefs  => 'assets',
            page_custom_prefs   => 'title',
            page_custom_prefs   => 'text',
            page_custom_prefs   => 'tags',
            page_custom_prefs   => 'assets',
            content_css         => '',
            nwc_smart_replace   => 0,
            nwc_title           => 1,
            nwc_text            => 1,
            nwc_text_more       => 1,
            nwc_keywords        => 1,
            nwc_excerpt         => 1,
            nwc_tags            => 1,
            image_default_align => 'none',
            image_default_thumb => $thumb,
            image_default_width => $width,
        }
    );
    my $output = delete $app->{__test_output};
    return $output || '';
}

sub check_image_option_template {
    my ( $output, $custom, $width ) = @_;
    my $selected = '';
    if ($custom) {
        $selected = 'selected=\"selected\"';
        like(
            $output,
            qr/<input type=\"text\" name=\"image_default_width\".*(value=\"$width\")/,
            'Set input value.'
        );
    }

    like( $output, qr/<label>(Side width)<\/label>/,
        'set side width label.' );
    like(
        $output,
        qr/<option (value=\"0\").*(Original size).*<\/option>/s,
        'Set side width original item value.'
    );
    like(
        $output,
        qr/<option (value=\"1\").*$selected.*(Custom\.\.\.).*<\/option>/s,
        'Set side width default item value when custom.'
    );
}
