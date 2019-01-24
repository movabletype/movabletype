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

$test_env->prepare_fixture(
    sub {
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
            data =>
                { $categories_field->id => [ map { $_->id } @categories ] },
        );
    }
);

my $category_set = MT::CategorySet->load( { blog_id => $blog_id } );

my $content_type = MT::ContentType->load( { blog_id => $blog_id } );
my $categories_field = MT::ContentField->load(
    {   blog_id         => $blog_id,
        content_type_id => $content_type->id,
        type            => 'categories',
    }
);

my $content_data = MT::ContentData->load(
    {   blog_id         => $blog_id,
        content_type_id => $content_type->id,
    }
);

subtest 'initial state' => sub {
    my @categories = sort { $a->id <=> $b->id } MT::Category->load(
        {   blog_id         => $blog_id,
            category_set_id => $category_set->id,
        }
    );
    is( scalar @categories, 3, '3 categories exist' );

    is( scalar @{ $content_data->data->{ $categories_field->id } },
        3, '3 data exist in categories field' );

    my @object_categories
        = MT->model('objectcategory')
        ->load( { object_ds => 'content_data' } );
    is( scalar @object_categories, 3, '3 MT::ObjectCategory exist' );

    my @cf_idx = MT->model('content_field_index')->load(
        {   content_data_id  => $content_data->id,
            content_field_id => $categories_field->id,
        }
    );
    is( scalar @cf_idx, 3, '3 MT::ContentFieldIndex exist' );
};

subtest 'remove category' => sub {
    my @categories = MT::Category->load(
        {   blog_id         => $blog_id,
            category_set_id => $category_set->id,
        }
    );
    is( scalar @categories, 3, '3 categories exist' );

    $categories[0]->remove or die $categories[0]->errstr;

    $content_data->refresh;
    is( scalar @{ $content_data->data->{ $categories_field->id } },
        2, '1 data has been removed in categories field' );

    my @object_categories
        = MT->model('objectcategory')
        ->load( { object_ds => 'content_data' } );
    is( scalar @object_categories,
        2, '1 MT::ObjectCategory has been removed' );

    my @cf_idx = MT->model('content_field_index')->load(
        {   content_data_id  => $content_data->id,
            content_field_id => $categories_field->id,
        }
    );
    is( scalar @cf_idx, 2, '1 MT::ContentFieldIndex has been removed' );
};

subtest 'remove objectcategory' => sub {
    my @categories = MT::Category->load(
        {   blog_id         => $blog_id,
            category_set_id => $category_set->id,
        }
    );
    is( scalar @categories, 2, '2 categories exist' );

    my $objcat = MT->model('objectcategory')->load(
        {   blog_id     => $blog_id,
            object_ds   => 'content_data',
            object_id   => $content_data->id,
            cf_id       => $categories_field->id,
            category_id => $categories[0]->id,
        }
    ) or die MT->model('objectcategory')->errstr;
    $objcat->remove or die $objcat->errstr;

    $content_data->refresh;
    is( scalar @{ $content_data->data->{ $categories_field->id } },
        1, '1 data has been removed in categories field' );

    my @object_categories
        = MT->model('objectcategory')
        ->load( { object_ds => 'content_data' } );
    is( scalar @object_categories,
        1, '1 MT::ObjectCategory has been removed' );

    my @cf_idx = MT->model('content_field_index')->load(
        {   content_data_id  => $content_data->id,
            content_field_id => $categories_field->id,
        }
    );
    is( scalar @cf_idx, 1, '1 MT::ContentFieldIndex has been removed' );
};

done_testing;

