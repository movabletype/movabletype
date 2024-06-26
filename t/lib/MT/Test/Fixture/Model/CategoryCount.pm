package MT::Test::Fixture::Model::CategoryCount;
use strict;
use warnings;
use feature 'state';
use base 'MT::Test::Fixture';

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
#   - my_asset1 (ID:3)
#     + type: asset
#
# * content type1 (ID:2)
#   - content field2 (ID:4)
#     + type: categories
#     + category_set_id: 1
#
#   - content field3 (ID:5)
#     + type: categories
#     + category_set_id: 1
#
#   - my_asset2 (ID:6)
#     + type: asset

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
#   - my_asset1: 1, 2, 3
#
# * content data3 (ID:4)
#   - content_type_id: 1
#   - status: draft
#   - content_field1: category0, category1, category2
#
# * content data4 (ID:5)
#   - content_type_id: 2
#   - status: release
#   - content_field2: category0, category1
#
# * content data5 (ID:6)
#   - content_type_id: 2
#   - status: release
#   - content_field3: category0
#
# * content data6 (ID:7)
#   - content_type_id: 2
#   - status: draft
#   - content_field3: category0, $category1, category2
#
# * content data2 (ID:8)
#   - content_type_id: 2
#   - my_asset2: 1, 2, 3

sub prepare_fixture {
    MT::Test->init_db;

    my $blog_id         = 1;
    my $category_set_id = 1;

    # create category set
    my $category_set
        = MT::Test::Permission->make_category_set( blog_id => $blog_id );
    $category_set->id($category_set_id);
    $category_set->save or die $category_set->errstr;

    # create 3 categories
    my @cats;
    my @cat_labels = ( 'a', 'b', 'c' );
    for my $cat_id ( 1 .. 3 ) {
        my $cat = MT::Test::Permission->make_category(
            blog_id         => $category_set->blog_id,
            category_set_id => $category_set->id,
            label           => $cat_labels[ $cat_id - 1 ],
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
        for ( 1 .. 2 ) {
            state $field_id = 1;
            my $cat_field = MT::Test::Permission->make_content_field(
                blog_id         => $ct->blog_id,
                content_type_id => $ct->id,
                type            => 'categories',
                name => 'field' . ( $field_id - 1 ),
            );

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
            $field_id++;
        }

        my $asset_field;
        {
            # MTC-27923 add asset field
            $asset_field = MT::Test::Permission->make_content_field(
                blog_id         => $ct->blog_id,
                content_type_id => $ct->id,
                type            => 'asset',
                name            => 'my_asset'. $ct->id,
            );
            push @field_data, {
                id      => $asset_field->id,
                order   => 1,
                type    => $asset_field->type,
                options => {
                    label    => $asset_field->name,
                    multiple => 1,
                },
                unique_id => $asset_field->unique_id,
            };
        }

        $ct->fields(MT::Test::Fixture::_fix_fields(\@field_data));
        $ct->save or die $ct->errstr;

        # create 4 content data
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
        # MTC-27923
        MT::Test::Permission->make_content_data(
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
            data            => { $asset_field->id => [$cats[0]->id, $cats[1]->id, $cats[2]->id] },
        );
    }
}

1;
