use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../../../lib";    # t/lib
use Test::More;
use MT::Test::Env;

BEGIN {
    plan skip_all => 'Not for Windows now' if $^O eq 'MSWin32';
}

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use JSON ();
use URI;
use Selenium::Waiter;

use MT;
use MT::ContentStatus;
use MT::Serialize;

use MT::Test;
use MT::Test::App;
use MT::Test::Fixture;
use MT::Test::Fixture::ContentData;
use MT::Test::Permission;
use MT::Test::Selenium;

$test_env->prepare_fixture('db');
my $spec = MT::Test::Fixture::ContentData->fixture_spec;

#### change fixture data for this test

# remove \$invalid_id
$spec->{content_data}{cd}{data}{cf_tags}         = ['tag2',      'tag1'];
$spec->{content_data}{cd}{data}{cf_categories}   = ['category2', 'category1'];
$spec->{content_data}{cd}{data}{cf_image}        = ['test2.jpg', 'test.jpg'];
$spec->{content_data}{cd}{data}{cf_image_single} = ['test2.jpg'];
$spec->{content_data}{cd}{data}{cf_content_type} = ['cd2'];

# radio button field should have a scalar value
$spec->{content_data}{cd}{data}{cf_radio} = 3;

# undef is changed to emptry string after saving
$spec->{content_data}{cd}{block_editor_data} = '';

####

my $objs = MT::Test::Fixture->prepare($spec);

# clear cache in MT::ContentType->load_all
MT->request->reset;

my $admin = $objs->{author}{author};
$admin->is_superuser(1);
$admin->save or die $admin->errstr;

my $blog = $objs->{blog}{'My Site'};
my $ct   = $objs->{content_type}{ct}{content_type};
my $cd   = $objs->{content_data}{cd};
my $cf   = $objs->{content_type}{ct}{content_field};

my $cf_single_line_text         = $cf->{cf_single_line_text};
my $cf_single_line_text_no_data = $cf->{cf_single_line_text_no_data};
my $cf_multi_line_text          = $cf->{cf_multi_line_text};
my $cf_number                   = $cf->{cf_number};
my $cf_url                      = $cf->{cf_url};
my $cf_embedded_text            = $cf->{cf_embedded_text};
my $cf_datetime                 = $cf->{cf_datetime};
my $cf_date                     = $cf->{cf_date};
my $cf_time                     = $cf->{cf_time};
my $cf_select_box               = $cf->{cf_select_box};
my $cf_radio                    = $cf->{cf_radio};
my $cf_checkboxes               = $cf->{cf_checkboxes};
my $cf_list                     = $cf->{cf_list};
my $cf_tables                   = $cf->{cf_tables};
my $cf_tags                     = $cf->{cf_tags};
my $cf_categories               = $cf->{cf_categories};
my $cf_image                    = $cf->{cf_image};
my $cf_image_single             = $cf->{cf_image_single};
my $cf_content_type             = $cf->{cf_content_type};
my $cf_text_label               = $cf->{cf_text_label};

subtest 'create content data screen' => sub {
    subtest 'has no copy button' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode          => 'view',
            _type           => 'content_data',
            type            => 'content_data_' . $ct->id,
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
        });
        $app->content_unlike('An error occurred');

        $app->content_unlike('Copy This Content Data');
        $app->html_content_unlike('id="copy-this-content-data-widget"');
    };
};

my $selenium = MT::Test::Selenium->new($test_env);
$selenium->login($admin);

subtest 'edit content data screen' => sub {
    subtest 'has copy button' => sub {
        $selenium->request({
            __request_method => 'GET',
            __mode           => 'view',
            _type            => 'content_data',
            type             => 'content_data_' . $ct->id,
            blog_id          => $ct->blog_id,
            content_type_id  => $ct->id,
            id               => $cd->id,
        });
        $selenium->wait_until_ready;

        my $content = $selenium->content;
        unlike $content, qr/An error occured/,       'no error occurred';
        like $content,   qr/Copy This Content Data/, 'found "Copy This Content Data" text';
        ok $selenium->find('div#copy-this-content-data-widget'), 'found div#copy-this-content-data-widget';
    };

    subtest 'moves to copied content data screen by clicking button' => sub {
        $selenium->scroll_and_click('button#copy-this-content-data');
        $selenium->wait_until_ready;

        my $quoted_base_url = quotemeta $selenium->base_url;
        my $moved_uri       = URI->new($selenium->driver->get_current_url);
        like $moved_uri->as_string, qr/^$quoted_base_url/, 'moved to ' . $selenium->base_url;
        is_deeply(
            $moved_uri->query_form_hash,
            {
                __mode          => 'copy_this_content_data',
                _type           => 'content_data',
                type            => 'content_data_' . $ct->id,
                blog_id         => $ct->blog_id,
                content_type_id => $ct->id,
                origin          => $cd->id,
            },
            'moved to ' . $moved_uri->as_string,
        );
    };

    subtest 'saves copied data by clicking button' => sub {
        $selenium->scroll_and_click('button[name="status"][type="submit"]');
        $selenium->wait_until_ready;
        unlike $selenium->content, qr/An error occured/, 'no error occurred';

        my $saved_uri = URI->new($selenium->driver->get_current_url);
        my ($saved_cd_id) = $saved_uri =~ /(?:[?&])id=(\d+)/;
        is_deeply(
            $saved_uri->query_form_hash,
            {
                __mode          => 'view',
                _type           => 'content_data',
                type            => 'content_data_' . $ct->id,
                blog_id         => $ct->blog_id,
                content_type_id => $ct->id,
                id              => $saved_cd_id,
                saved_added     => 1,
            },
            'saved: ' . $saved_uri->as_string,
        );

        my $saved_cd = MT->model('content_data')->load($saved_cd_id) or die MT->model('content_data')->errstr;

        is $saved_cd->blog_id,         $cd->blog_id,         'blog_id: ' . $cd->blog_id;
        is $saved_cd->content_type_id, $cd->content_type_id, 'content_type_id: ' . $cd->content_type_id;
        is $saved_cd->ct_unique_id,    $cd->ct_unique_id,    'ct_unique_id: ' . $cd->ct_unique_id;

        _is_content_data_field($saved_cd, $cd, $cf_single_line_text);
        _is_content_data_field($saved_cd, $cd, $cf_single_line_text_no_data, \&_undef2empty);
        _is_content_data_field($saved_cd, $cd, $cf_multi_line_text,          \&_crlf2lf);
        _is_content_data_field($saved_cd, $cd, $cf_number);
        _is_content_data_field($saved_cd, $cd, $cf_url);
        _is_content_data_field($saved_cd, $cd, $cf_embedded_text, \&_crlf2lf);
        _is_content_data_field($saved_cd, $cd, $cf_datetime);
        _is_content_data_field($saved_cd, $cd, $cf_date);
        _is_content_data_field($saved_cd, $cd, $cf_time);
        _is_deeply_content_data_field($saved_cd, $cd, $cf_select_box);
        _is_content_data_field($saved_cd, $cd, $cf_radio);
        _is_deeply_content_data_field($saved_cd, $cd, $cf_checkboxes);
        _is_deeply_content_data_field($saved_cd, $cd, $cf_list);
        _is_content_data_field($saved_cd, $cd, $cf_tables, \&_tables_filter);
        _is_deeply_content_data_field($saved_cd, $cd, $cf_tags);
        _is_deeply_content_data_field($saved_cd, $cd, $cf_categories);
        _is_deeply_content_data_field($saved_cd, $cd, $cf_image);
        _is_deeply_content_data_field($saved_cd, $cd, $cf_image_single);
        _is_deeply_content_data_field($saved_cd, $cd, $cf_content_type);
        _is_content_data_field($saved_cd, $cd, $cf_text_label, \&_undef2empty);

        is $saved_cd->label,  'Copy of ' . $cd->label,   'label: Copy of ' . $cd->label;
        is $saved_cd->status, MT::ContentStatus::HOLD(), 'status: ' . MT::ContentStatus::HOLD();
        is_deeply(MT::Serialize->unserialize($saved_cd->convert_breaks), MT::Serialize->unserialize($cd->convert_breaks), 'convert_breaks');
        is $saved_cd->block_editor_data, $cd->block_editor_data, 'block_editor_data: ' . $cd->block_editor_data;
    };
};

subtest 'copied content data screen (create content data screen)' => sub {
    subtest 'returns error with invalid origin parameter' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);

        $app->get_ok({
            __mode          => 'copy_this_content_data',
            _type           => 'content_data',
            type            => 'content_data_' . $ct->id,
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            origin          => 'invalid parameter',
        });
        $app->content_like('An error occurred');
    };

    subtest 'ignores id parameter' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);

        $app->get_ok({
            __mode          => 'copy_this_content_data',
            _type           => 'content_data',
            type            => 'content_data_' . $ct->id,
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            origin          => $cd->id,
            id              => $cd->id,
        });
        $app->content_unlike('An error occurred');

        $app->content_unlike('Copy This Content Data');
        $app->html_content_unlike('id="copy-this-content-data-widget"');
    };

    subtest 'has no copy button' => sub {
        $selenium->request({
            __request_method => 'GET',
            __mode           => 'copy_this_content_data',
            _type            => 'content_data',
            type             => 'content_data_' . $ct->id,
            blog_id          => $ct->blog_id,
            content_type_id  => $ct->id,
            origin           => $cd->id,
        });
        $selenium->wait_until_ready;
        my $content = $selenium->content;
        unlike $content, qr/An error occured/, 'no error occurred';

        unlike $content, qr/Copy This Content Data/, 'found "Copy This Content Data" text';
        my $widget_exists = wait_until { $selenium->driver->execute_script('return jQuery("div#copy-this-content-data-widget").length;') };
        ok !$widget_exists, 'found no copy this content data widget';
    };

    subtest 'has no copy data without required permission' => sub {
        my $user = MT::Test::Permission->make_author(
            name     => 'no required permission user',
            nickname => 'no required permission user',
        );
        my $permission = 'create_content_data:' . $cd->ct_unique_id;
        my $role       = MT::Test::Permission->make_role(
            name        => 'no required permission role',
            permissions => "'${permission}'",
        );
        MT->model('association')->link($user => $role => $blog) or die MT->model('association')->errstr;

        $selenium = MT::Test::Selenium->new($test_env);
        $selenium->login($user);
        $selenium->request({
            __request_method => 'GET',
            __mode           => 'copy_this_content_data',
            _type            => 'content_data',
            type             => 'content_data_' . $ct->id,
            blog_id          => $ct->blog_id,
            content_type_id  => $ct->id,
            origin           => $cd->id,
        });
        $selenium->wait_until_ready;
        like $selenium->driver->get_current_url, qr/permission=1/, 'permission errror occurred';
    };
};

done_testing;

# for Windows environment
sub _crlf2lf {
    my ($str) = @_;
    $str =~ s/\r\n/\n/g;
    return $str;
}

sub _undef2empty {
    my ($value) = @_;
    if (!defined $value) {
        return '';
    }
    return $value;
}

sub _tables_filter {
    my ($str) = @_;
    $str =~ s/[\s\r\n]+//g;
    return $str;
}

sub _is_content_data_field {
    my ($got_cd, $expected_cd, $cf, $filter) = @_;
    if ($filter) {
        my $test_name = $cf->id . ': ' . $cf->name . ' (with filter)';
        is $filter->($got_cd->data->{ $cf->id }), $filter->($expected_cd->data->{ $cf->id }), $test_name;
    } else {
        my $test_name = $cf->id . ': ' . $cf->name;
        is $got_cd->data->{ $cf->id }, $expected_cd->data->{ $cf->id }, $test_name;
    }
}

sub _is_deeply_content_data_field {
    my ($got_cd, $expected_cd, $cf) = @_;
    my $test_name = $cf->id . ': ' . $cf->name . ' (is_deeply)';
    is_deeply $got_cd->data->{ $cf->id }, $expected_cd->data->{ $cf->id }, $test_name;
}

