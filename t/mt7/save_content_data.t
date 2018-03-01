## -*- mode: perl; coding: utf-8 -*-

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

use MT::Author;
use MT::ContentData;
use MT::ContentFieldIndex;
use MT::ContentStatus;

MT::Test->init_app;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        my $admin = MT::Author->load(1);
        my $user = MT::Test::Permission->make_author( name => 'test user', );
        $user->is_superuser(1);
        $user->save or die $user->errstr;

        my $content_type = MT::Test::Permission->make_content_type(
            blog_id => 1,
            name    => 'test content type',
        );

        my $content_field = MT::Test::Permission->make_content_field(
            blog_id         => $content_type->blog_id,
            content_type_id => $content_type->id,
            name            => 'single text',
            type            => 'single_line_text',
        );

        my $fields = [
            {   id        => $content_field->id,
                label     => 1,
                name      => $content_field->name,
                order     => 1,
                type      => $content_field->type,
                unique_id => $content_field->unique_id,
            }
        ];
        $content_type->fields($fields);
        $content_type->save or die $content_type->errstr;
    }
);

my $admin = MT::Author->load(1);
my $user = MT::Author->load( { name => 'test user' } );

my $content_type = MT::ContentType->load( { name => 'test content type' } );
my $content_field = MT::ContentField->load( { name => 'single text' } );

my ( $content_data, $cf_idx );

subtest 'mode=save_content_data (create)' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            blog_id          => $content_type->blog_id,
            content_type_id  => $content_type->id,
            status           => MT::ContentStatus::HOLD(),
            'content-field-' . $content_field->id => 'test input',
            _type                                 => 'content_data',
            type => 'content_data_' . $content_type->id,
        },
    );
    my $out = delete $app->{__test_output};
    ok( $out =~ /saved_added=1/, 'content data has been saved' );
    ok( $out =~ /302 Found/,     'redirect to list_content_data screen' );

    # check content data
    $content_data = MT::ContentData->load(
        {   blog_id         => $content_type->blog_id,
            author_id       => 1,
            content_type_id => $content_type->id
        }
    );
    ok( $content_data, 'got content data' );
    is( keys %{ $content_data->data },
        1, 'content data has 1 content field data' );
    is( $content_data->data->{ $content_field->id },
        'test input', 'content field data' );

    is( $content_data->author_id,   $admin->id, 'author_id is admin ID' );
    is( $content_data->created_by,  $admin->id, 'created_by is admin ID' );
    is( $content_data->modified_by, undef,      'modified_by is undef' );

    # check content field
    $cf_idx = MT::ContentFieldIndex->load(
        {   content_type_id  => $content_type->id,
            content_field_id => $content_field->id,
            content_data_id  => $content_data->id,
        }
    );
    ok( $cf_idx, 'got content field index' );
    is( $cf_idx->value_varchar, 'test input',
        'content field data is set in content field index' );
};

subtest 'mode=save_content_data (update)' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user      => $user,
            __request_method => 'POST',
            __mode           => 'save',
            id               => $content_data->id,
            blog_id          => $content_type->blog_id,
            content_type_id  => $content_type->id,
            status           => MT::ContentStatus::HOLD(),
            'content-field-' . $content_field->id => 'test input update',
            _type                                 => 'content_data',
            type => 'content_data_' . $content_type->id,
        },
    );
    my $out = delete $app->{__test_output};
    ok( $out =~ /saved_changes=1/, 'content data has been saved' );
    ok( $out =~ /302 Found/,       'redirect to list_content_data screen' );

    # check content data
    is( MT::ContentData->count, 1, 'content data count is 1' );
    is( MT::ContentData->load->id,
        $content_data->id, 'content data ID is not changed' );

    $content_data = MT::ContentData->load( $content_data->id );
    is( keys %{ $content_data->data },
        1, 'content data has 1 content field data' );
    is( $content_data->data->{ $content_field->id },
        'test input update',
        'content field data has bee updated'
    );

    is( $content_data->author_id,   $admin->id, 'author_id is admin ID' );
    is( $content_data->created_by,  $admin->id, 'created_by is admin ID' );
    is( $content_data->modified_by, $user->id,  'modified_by is user ID' );

    # check content field
    is( MT::ContentFieldIndex->count, 1, 'content field count is 1' );
    is( MT::ContentFieldIndex->load->id,
        $cf_idx->id, 'content field ID is not changed' );

    $cf_idx = MT::ContentFieldIndex->load( $cf_idx->id );
    is( $cf_idx->value_varchar,
        'test input update',
        'content field data has been updated in content field index'
    );
};

done_testing;

