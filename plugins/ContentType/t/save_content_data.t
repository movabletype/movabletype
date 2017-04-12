use strict;
use warnings;

use JSON;
use Test::More;

use lib qw( lib extlib t/lib );
use MT::Test qw( :app :db );

use ContentType::App::CMS;
use MT::Author;
use MT::ContentData;
use MT::ContentFieldIndex;
use MT::ContentType;
use MT::Entity;

local $ENV{REMOTE_ADDR}     = '127.0.0.1';
local $ENV{HTTP_USER_AGENT} = 'mt_test';

my $admin = MT::Author->load(1);

my $content_type = MT::ContentType->new;
$content_type->set_values(
    {   blog_id    => 1,
        name       => 'test content type',
        unique_key => ContentType::App::CMS::_generate_unique_key(),
    }
);
$content_type->save or die $content_type->errstr;

my $entity = MT::Entity->new;
$entity->set_values(
    {   blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
        name            => 'single text',
        type            => 'single_line_text',
        unique_key      => ContentType::App::CMS::_generate_unique_key(),
    }
);
$entity->save or die $entity->errstr;

my $entities = [
    {   id         => $entity->id,
        label      => 0,
        name       => $entity->name,
        order      => 1,
        type       => $entity->type,
        unique_key => $entity->unique_key,
    }
];
$content_type->entities( JSON::encode_json($entities) );
$content_type->save or die $content_type->errstr;

subtest 'mode=save_content_data' => sub {
    my $app = _run_app(
        'MT::App::CMS',
        {   __test_user             => $admin,
            __request_method        => 'POST',
            __mode                  => 'save_content_data',
            blog_id                 => $content_type->blog_id,
            content_type_id         => $content_type->id,
            'entity-' . $entity->id => 'test input',
        },
    );
    my $out = delete $app->{__test_output};
    ok( $out =~ /saved=1/,   'content data has been saved' );
    ok( $out =~ /302 Found/, 'redirect to list_content_data screen' );

    my $content_data = MT::ContentData->load(
        { blog_id => $content_type->blog_id, ct_id => $content_type->id } );
    ok( $content_data, 'got content data' );
    is( $content_data->data,
        '{"' . $entity->id . '":"test input"}',
        'content data has content field data'
    );

    my $cf_idx = MT::ContentFieldIndex->load(
        {   content_type_id  => $content_type->id,
            content_field_id => $entity->id,
            content_data_id  => $content_data->id,
        }
    );
    ok( $cf_idx, 'got content field index' );
    is( $cf_idx->value_varchar, 'test input',
        'content field data is set in content field index' );
};

done_testing;

