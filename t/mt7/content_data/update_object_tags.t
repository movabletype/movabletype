## -*- mode: perl; coding: utf-8 -*-

use strict;
use warnings;

use Test::More;

use lib qw( t/lib lib extlib );
use MT::Test qw( :db );
use MT::Test::Permission;

my $author_id = 1;
my $blog_id   = 1;

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
);

is( MT->model('objecttag')->count( { object_datasource => 'content_field' } ),
    0,
    'no old MT::ObjectTag',
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

