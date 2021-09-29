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

use MT::Entry;
use MT::Request;

$test_env->prepare_fixture('model/category_count');

my @cats = MT::Category->load( { id => [ 1 .. 3 ] } );
my @content_types = MT::ContentType->load( { id => [ 1 .. 2 ] } );
my @category_fields;
for my $ct_id (1 .. 2) {
    my @a = MT::ContentField->load({ content_type_id => $ct_id, type => 'categories' }, { sort => 'id' });
    $category_fields[$ct_id - 1] = \@a;
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
