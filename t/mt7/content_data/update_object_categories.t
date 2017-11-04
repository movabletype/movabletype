## -*- mode: perl; coding: utf-8 -*-

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

my $author_id = 1;
my $blog_id   = 1;

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $category_set
        = MT::Test::Permission->make_category_set( blog_id => $blog_id );
    my @categories;
    for ( 1 .. 3 ) {
        my $cat = MT::Test::Permission->make_category(
            blog_id         => $blog_id,
            category_set_id => $category_set->id,
        );
        push @categories, $cat;
    }

    my $content_type
        = MT::Test::Permission->make_content_type( blog_id => $blog_id );
    my $categories_field = MT::Test::Permission->make_content_field(
        blog_id         => $blog_id,
        content_type_id => $content_type->id,
        type            => 'categories',
    );
    $content_type->fields(
        [   {   id      => $categories_field->id,
                order   => 1,
                type    => $categories_field->type,
                options => {
                    label    => $categories_field->name,
                    multiple => 1,
                },
                uniuque_id => $categories_field->unique_id,
            }
        ]
    );
    $content_type->save or die $content_type->errstr;

    my $content_data = MT::Test::Permission->make_content_data(
        blog_id         => $blog_id,
        content_type_id => $content_type->id,
        data => { $categories_field->id => [ map { $_->id } @categories ] },
    );
});

my $category_set = MT::CategorySet->load( { blog_id => $blog_id } );
my @categories = sort { $a->id <=> $b->id } MT::Category->load( {
    blog_id         => $blog_id,
    category_set_id => $category_set->id,
} );

my $content_type = MT::ContentType->load( { blog_id => $blog_id } );
my $categories_field = MT::ContentField->load({
    blog_id         => $blog_id,
    content_type_id => $content_type->id,
    type            => 'categories',
});

my $content_data = MT::ContentData->load({
    blog_id         => $blog_id,
    content_type_id => $content_type->id,
});

is( MT->model('objectcategory')->count( { object_ds => 'content_field' } ),
    0, 'no old MT::ObjectCategory' );

my @object_categories
    = MT->model('objectcategory')->load( { object_ds => 'content_data' } );
is( scalar @object_categories, 3, '3 new MT::ObjectCategory' );

my $terms = {
    blog_id   => $blog_id,
    object_ds => 'content_data',
    object_id => $content_data->id,
    cf_id     => $categories_field->id,
};
is( MT->model('objectcategory')->count(
        {   %$terms,
            category_id => $categories[0]->id,
            is_primary  => 1,
        }
    ),
    1,
    'MT::ObjectCategory of $category[0]',
);
is( MT->model('objectcategory')->count(
        {   %$terms,
            category_id => $categories[1]->id,
            is_primary  => 0,
        }
    ),
    1,
    'MT::ObjectCategory of $category[1]',
);
is( MT->model('objectcategory')->count(
        {   %$terms,
            category_id => $categories[2]->id,
            is_primary  => 0,
        }
    ),
    1,
    'MT::ObjectCategory of $category[2]',
);

subtest 'Do not remove unchanged record' => sub {
    $content_data->save or die $content_data->errstr;

    is( MT->model('objectcategory')->count( { object_ds => 'content_data' } ),
        3,
        '3 MT::ObjectCategory'
    );

    for my $oc (@object_categories) {
        my $oc_id = $oc->id;
        ok( MT->model('objectcategory')->exist($oc_id),
            "MT::ObjectCategory (ID:$oc_id) is not removed"
        );
    }
};

done_testing;

