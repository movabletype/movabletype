use strict;
use warnings;

use JSON;
use Test::MockModule;
use Test::More;

use lib qw( lib extlib t/lib );
use MT;
use MT::Test qw( :db );

use MT::ContentType;
use MT::Entity;
use MT::ContentFieldIndex;
use ContentType::App::CMS;
use ContentType::ListProperties;

local $ENV{REMOTE_ADDR}     = '127.0.0.1';
local $ENV{HTTP_USER_AGENT} = 'mt_test';

subtest 'make_list_properties' => sub {
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

    my $called = 0;
    my $module = Test::MockModule->new('MT::ContentFieldIndex');
    $module->mock( 'make_terms', sub { $called++ } );

    my $props = ContentType::ListProperties::make_list_properties;

    ok( $props && ref $props eq 'HASH', 'make_list_properties returns hash' );

    my $terms = $props->{ 'content_data_' . $content_type->id }
        { 'entity_' . $entity->id }{terms};
    is( ref $terms, 'CODE',
        '$props->{content_data_?}{entity_?}{terms} is coderef' );

    $terms->();
    is( $called, 1, 'The coderef is MT::ContentFieldIndex::make_terms' );
};

done_testing;

