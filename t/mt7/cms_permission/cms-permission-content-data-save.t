#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;

use MT::Test::Env;
our $test_env;
use MT::Test::Fixture;

BEGIN {
    $test_env = MT::Test::Env->new(
        DisableContentFieldPermission => 0,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Serialize;
use MT::ContentStatus;
use MT::Test::App;

$ENV{MT_TEST_IGNORE_FIXTURE} = 1;

### Make test data
my $objs = $test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $site = MT::Test::Permission->make_website(name => 'my website');

    my $admin = MT::Author->load(1);
    my $user  = MT::Test::Permission->make_author(
        name     => 'aikawa',
        nickname => 'Ichiro Aikawa',
    );

    my $content_type = MT::Test::Permission->make_content_type(
        blog_id => $site->id,
        name    => 'test content type',
    );

    my $content_field = MT::Test::Permission->make_content_field(
        blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
        name            => 'single line text',
        type            => 'single_line_text',
    );
    my $content_field_2 = MT::Test::Permission->make_content_field(
        blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
        name            => 'multi line text',
        type            => 'multi_line_text',
    );
    my $field_data = [{
            id        => $content_field->id,
            order     => 1,
            type      => $content_field->type,
            options   => { label => $content_field->name, },
            unique_id => $content_field->unique_id,
        },
        {
            id        => $content_field_2->id,
            order     => 2,
            type      => $content_field_2->type,
            options   => { label => $content_field_2->name, },
            unique_id => $content_field_2->unique_id,
        },
    ];
    $content_type->fields($field_data);
    $content_type->save or die $content_type->errstr;

    my $cd_admin = MT::Test::Permission->make_content_data(
        blog_id         => $site->id,
        author_id       => $admin->id,
        content_type_id => $content_type->id,
        label           => 'cd1',
        status          => MT::ContentStatus::HOLD(),
        data            => {
            $content_field->id   => 'test text',
            $content_field_2->id => 'test text2'
        },
        convert_breaks => MT::Serialize->serialize(\{ $content_field_2->id => 'markdown' }),
    );

    my $permitted_action = 'content_type:' . $content_type->unique_id . '-content_field:' . $content_field->unique_id;

    my $edit_all_action = "edit_all_content_data:" . $content_type->unique_id;
    my $edit_field_role = MT::Test::Permission->make_role(
        name        => 'Edit Content Field "' . $content_field->name . '"',
        permissions => "'${edit_all_action}','${permitted_action}'"
    );
    require MT::Association;
    MT::Association->link($user => $edit_field_role => $site);
});

my $site = MT->model('website')->load({ name => 'my website' });
my $user = MT->model('author')->load({ name => 'aikawa' });
my $content_type =
    MT->model('content_type')->load({ name => 'test content type' });
my $cd_admin        = MT->model('cd')->load({ label => 'cd1' });
my $content_field   = MT->model('cf')->load({ name  => 'single line text' });
my $content_field_2 = MT->model('cf')->load({ name  => 'multi line text' });

# save to DB to test with Cloud.pack
MT->config->DisableContentFieldPermission(0, 1);
MT->config->save_config;

subtest 'authorized fields' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);
    $app->post_ok({
        __mode                                => 'save',
        blog_id                               => $site->id,
        content_type_id                       => $content_type->id,
        _type                                 => 'content_data',
        type                                  => 'content_data_' . $content_type->id,
        save_revision                         => 0,
        data_label                            => 'cd1',
        status                                => MT::ContentStatus::HOLD(),
        id                                    => $cd_admin->id,
        'content-field-' . $content_field->id => 'edit test text',
    });
    $app->has_no_permission_error('edit by aikawa');

    my $saved_cd = MT::ContentData->load($cd_admin->id);
    is(
        $saved_cd->data->{ $content_field->id },
        'edit test text',
        'test field1'
    );
    is(
        $saved_cd->data->{ $content_field_2->id }, 'test text2',
        'test field2'
    );
    my $convert_breaks = MT::Serialize->unserialize($saved_cd->convert_breaks);
    is(
        $$convert_breaks->{ $content_field_2->id },
        'markdown', 'test convert breaks'
    );
};

subtest 'Unauthorized fields' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);
    $app->post_ok({
        __mode                                                      => 'save',
        blog_id                                                     => $site->id,
        content_type_id                                             => $content_type->id,
        _type                                                       => 'content_data',
        type                                                        => 'content_data_' . $content_type->id,
        save_revision                                               => 0,
        data_label                                                  => 'cd1',
        status                                                      => MT::ContentStatus::HOLD(),
        id                                                          => $cd_admin->id,
        'content-field-' . $content_field->id                       => 'test text',
        'content-field-' . $content_field_2->id                     => 'edit test text2',
        'content-field-' . $content_field_2->id . '_convert_breaks' => 'richtext',
    });
    $app->has_no_permission_error('edit by aikawa');

    my $saved_cd = MT::ContentData->load($cd_admin->id);
    is($saved_cd->data->{ $content_field->id }, 'test text', 'test field1');
    is(
        $saved_cd->data->{ $content_field_2->id }, 'test text2',
        'test field2'
    );
    my $convert_breaks = MT::Serialize->unserialize($saved_cd->convert_breaks);
    is(
        $$convert_breaks->{ $content_field_2->id },
        'markdown', 'test convert breaks'
    );
};

done_testing();
