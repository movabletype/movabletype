## -*- mode: perl; coding: utf-8 -*-

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::Upgrade;

my $blog_id = 1;

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my @tags;
    for my $name ( 'foo', 'bar', 'baz' ) {
        my $tag = MT::Test::Permission->make_tag( name => $name );
        push @tags, $tag;
    }

    my $content_type
        = MT::Test::Permission->make_content_type( blog_id => $blog_id );
    my $tags_field = MT::Test::Permission->make_content_field(
        blog_id         => $blog_id,
        content_type_id => $content_type->id,
        type            => 'tags',
        name            => 'my tags',
    );
    $content_type->fields(
        [   {   id      => $tags_field->id,
                order   => 1,
                type    => $tags_field->type,
                options => {
                    label    => $tags_field->name,
                    multiple => 1,
                },
                unique_id => $tags_field->unique_id,
            }
        ]
    );
    $content_type->save or die $content_type->errstr;

    my $content_data = MT::Test::Permission->make_content_data(
        blog_id         => $blog_id,
        content_type_id => $content_type->id,
        data            => { $tags_field->id => [ map { $_->id } @tags ] },
        identifier      => 'my content data',
    );
});

my @tags;
for my $name ( 'foo', 'bar', 'baz' ) {
    my $tag = MT::Tag->load( { name => $name } );
    push @tags, $tag;
}

my $content_data = MT::ContentData->load( { identifier => 'my content data' } );
my $tags_field = MT::ContentField->load( { name => 'my tags' } );

my @object_tags = MT->model('objecttag')->load(
    {   blog_id           => $blog_id,
        object_datasource => 'content_data',
        object_id         => $content_data->id,
        cf_id             => $tags_field->id,
    }
);
is( scalar @object_tags, 3, '3 new MT::ObjectTag' );

for my $ot (@object_tags) {
    $ot->object_datasource('content_field');
    $ot->object_id( $tags_field->id );
    $ot->cf_id(0);
    $ot->save or die $ot->errstr;
}

is( MT->model('objecttag')->count( { object_datasource => 'content_field' } ),
    3,
    '3 old MT::ObjectTag'
);
is( MT->model('objecttag')->count( { object_datasource => 'content_data' } ),
    0,
    'no new MT::ObjectTag'
);

MT::Test::Upgrade->upgrade( from => 7.0019 );

is( MT->model('objecttag')->count( { object_datasource => 'content_field' } ),
    0,
    'no old MT::ObjectTag'
);
is( MT->model('objecttag')->count( { object_datasource => 'content_data' } ),
    3,
    '3 new MT::ObjectTag'
);

my $terms = {
    blog_id           => $blog_id,
    object_datasource => 'content_data',
    object_id         => $content_data->id,
    cf_id             => $tags_field->id,
};
is( MT->model('objecttag')->count( { %$terms, tag_id => $tags[0]->id } ),
    1, 'MT::ObjectTag of $tags[0]' );
is( MT->model('objecttag')->count( { %$terms, tag_id => $tags[1]->id } ),
    1, 'MT::ObjectTag of $tags[1]' );
is( MT->model('objecttag')->count( { %$terms, tag_id => $tags[2]->id } ),
    1, 'MT::ObjectTag of $tags[2]' );

done_testing;

