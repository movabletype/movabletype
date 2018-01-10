use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

use MT::Entry;
use MT::Request;

# * category set (ID:1)
#   - category0 (ID:1)
#   - category1 (ID:2)
#   - category2 (ID:3)

# * content type0 (ID:1)
#   - content field0 (ID:1)
#     + type: categories
#     + category_set_id: 1
#
#   - content field1 (ID:2)
#     + type: categories
#     + category_set_id: 1
#
# * content type1 (ID:2)
#   - content field2 (ID:3)
#     + type: categories
#     + category_set_id: 1
#
#   - content field3 (ID:4)
#     + type: categories
#     + category_set_id: 1

# * content data0 (ID:1)
#   - content_type_id: 1
#   - status: release
#   - content_field0: category0, category1
#
# * content data1 (ID:2)
#   - content_type_id: 1
#   - status: release
#   - content_field1: cateogry0
#
# * content data2 (ID:3)
#   - content_type_id: 1
#   - status: draft
#   - content_field1: category0, category1, category2
#
# * content data3 (ID:4)
#   - content_type_id: 2
#   - status: release
#   - content_field2: category0, category1
#
# * content data4 (ID:5)
#   - content_type_id: 2
#   - status: release
#   - content_field3: category0
#
# * content data5 (ID:6)
#   - content_type_id: 2
#   - status: draft
#   - content_field3: category0, $category1, category2

my $blog_id         = 1;
my $category_set_id = 1;

$test_env->prepare_fixture(
    sub {
        MT::Test->init_db;

        # create category set
        my $category_set
            = MT::Test::Permission->make_category_set( blog_id => $blog_id );
        $category_set->id($category_set_id);
        $category_set->save or die $category_set->errstr;

        # create 3 categories
        my @cats;
        for my $cat_id ( 1 .. 3 ) {
            my $cat = MT::Test::Permission->make_category(
                blog_id         => $category_set->blog_id,
                category_set_id => $category_set->id,
            );
            $cat->id($cat_id);
            $cat->save or die $cat->errstr;

            push @cats, $cat;
        }

        # create 2 content types
        my ( @content_types, @category_fields );
        for my $ct_id ( 1 .. 2 ) {
            my $ct = MT::Test::Permission->make_content_type(
                blog_id => $blog_id,
                name    => "ct$ct_id"
            );
            $ct->id($ct_id);
            $ct->save or die $ct->errstr;
            push @content_types, $ct;

            my @field_data;

            # create 2 category fields
            for my $field_id ( 1 .. 2 ) {
                my $cat_field = MT::Test::Permission->make_content_field(
                    blog_id         => $ct->blog_id,
                    content_type_id => $ct->id,
                    type            => 'categories',
                );
                if ( $ct_id == 1 ) {
                    $cat_field->id($field_id);
                    $cat_field->name( 'field' . ( $field_id - 1 ) );
                }
                else {
                    $cat_field->id( $field_id + 2 );
                    $cat_field->name( 'field' . ( $field_id + 2 - 1 ) );
                }
                $cat_field->save or die $cat_field->errstr;

                $category_fields[ $ct->id - 1 ] ||= [];
                push @{ $category_fields[ $ct->id - 1 ] }, $cat_field;

                my $data = {
                    id      => $cat_field->id,
                    order   => $cat_field->id,
                    type    => $cat_field->type,
                    options => {
                        label        => $cat_field->name,
                        category_set => $category_set->id,
                        multiple     => 1,
                    },
                    unique_id => $cat_field->id,
                };
                push @field_data, $data;
            }

            $ct->fields( \@field_data );
            $ct->save or die $ct->errstr;

            # create 2 content data
            MT::Test::Permission->make_content_data(
                blog_id         => $ct->blog_id,
                content_type_id => $ct->id,
                data            => {
                    $category_fields[ $ct->id - 1 ][0]->id =>
                        [ $cats[0]->id, $cats[1]->id ]
                },
            );
            MT::Test::Permission->make_content_data(
                blog_id         => $ct->blog_id,
                content_type_id => $ct->id,
                data            => {
                    $category_fields[ $ct->id - 1 ][1]->id => [ $cats[0]->id ]
                },
            );
            MT::Test::Permission->make_content_data(
                blog_id         => $ct->blog_id,
                content_type_id => $ct->id,
                status          => MT::Entry::HOLD(),
                data            => {
                    $category_fields[ $ct->id - 1 ][1]->id =>
                        [ $cats[0]->id, $cats[1]->id, $cats[2]->id ]
                },
            );
        }
    }
);

my @cats = MT::Category->load( { id => [ 1 .. 3 ] } );
my @content_types = MT::ContentType->load( { id => [ 1 .. 2 ] } );
my @category_fields;
for my $ct_id ( 1 .. 2 ) {
    for my $field_id ( 1 .. 2 ) {
        $category_fields[ $ct_id - 1 ][ $field_id - 1 ]
            = MT::ContentField->load(
            { id => ( $ct_id - 1 ) * 2 + $field_id } );
    }
}

subtest 'content_data_count()' => sub {
    is( $cats[0]->content_data_count, 4 );
    is( $cats[1]->content_data_count, 2 );
    is( $cats[2]->content_data_count, 0 );
};

subtest 'content_data_count({ content_type_id => ??? })' => sub {

    # content type0
    is( $cats[0]->content_data_count(
            { content_type_id => $content_types[0]->id }
        ),
        2,
    );
    is( $cats[1]->content_data_count(
            { content_type_id => $content_types[0]->id }
        ),
        1,
    );
    is( $cats[2]->content_data_count(
            { content_type_id => $content_types[0]->id }
        ),
        0,
    );

    # content type1
    is( $cats[0]->content_data_count(
            { content_type_id => $content_types[1]->id }
        ),
        2,
    );
    is( $cats[1]->content_data_count(
            { content_type_id => $content_types[1]->id }
        ),
        1,
    );
    is( $cats[2]->content_data_count(
            { content_type_id => $content_types[1]->id }
        ),
        0,
    );
};

subtest 'content_data_count({ content_field_id => ??? })' => sub {

    # content type0, content field0
    is( $cats[0]->content_data_count(
            { content_field_id => $category_fields[0][0]->id }
        ),
        1,
    );
    is( $cats[1]->content_data_count(
            { content_field_id => $category_fields[0][0]->id }
        ),
        1,
    );
    is( $cats[2]->content_data_count(
            { content_field_id => $category_fields[0][0]->id }
        ),
        0,
    );

    # content type0, content field1
    is( $cats[0]->content_data_count(
            { content_field_id => $category_fields[0][1]->id }
        ),
        1,
    );
    is( $cats[1]->content_data_count(
            { content_field_id => $category_fields[0][1]->id }
        ),
        0,
    );
    is( $cats[2]->content_data_count(
            { content_field_id => $category_fields[0][1]->id }
        ),
        0,
    );

    # content type1, content field2
    is( $cats[0]->content_data_count(
            { content_field_id => $category_fields[1][0]->id }
        ),
        1,
    );
    is( $cats[1]->content_data_count(
            { content_field_id => $category_fields[1][0]->id }
        ),
        1,
    );
    is( $cats[2]->content_data_count(
            { content_field_id => $category_fields[1][0]->id }
        ),
        0,
    );

    # content type1, content field3
    is( $cats[0]->content_data_count(
            { content_field_id => $category_fields[1][1]->id }
        ),
        1,
    );
    is( $cats[1]->content_data_count(
            { content_field_id => $category_fields[1][1]->id }
        ),
        0,
    );
    is( $cats[2]->content_data_count(
            { content_field_id => $category_fields[1][1]->id }
        ),
        0,
    );
};

subtest 'content_data_count({ content_field_name => ??? })' => sub {

    # content type1, content field0
    is( $cats[0]->content_data_count( { content_field_name => 'field0', } ),
        1 );
    is( $cats[1]->content_data_count( { content_field_name => 'field0', } ),
        1 );
    is( $cats[2]->content_data_count( { content_field_name => 'field0', } ),
        0 );

    # content type1, content field1
    is( $cats[0]->content_data_count( { content_field_name => 'field1', } ),
        1 );
    is( $cats[1]->content_data_count( { content_field_name => 'field1', } ),
        0 );
    is( $cats[2]->content_data_count( { content_field_name => 'field1', } ),
        0 );

    # content type2, content field2
    is( $cats[0]->content_data_count( { content_field_name => 'field2', } ),
        1 );
    is( $cats[1]->content_data_count( { content_field_name => 'field2', } ),
        1 );
    is( $cats[2]->content_data_count( { content_field_name => 'field2', } ),
        0 );

    # content type2, content field3
    is( $cats[0]->content_data_count( { content_field_name => 'field3', } ),
        1 );
    is( $cats[1]->content_data_count( { content_field_name => 'field3', } ),
        0 );
    is( $cats[2]->content_data_count( { content_field_name => 'field3', } ),
        0 );
};

subtest 'cache content_data_count while a request' => sub {
    MT::Test::Permission->make_content_data(
        blog_id         => $content_types[0]->blog_id,
        content_type_id => $content_types[0]->id,
        data            => { $category_fields[0][0]->id => [ $cats[0]->id ] },
    );
    is( $cats[0]->content_data_count, 4 );

    MT::Request->reset;
    is( $cats[0]->content_data_count, 5 );
};

done_testing;

