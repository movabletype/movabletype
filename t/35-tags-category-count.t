use strict;
use warnings;

use lib qw( t/lib lib extlib );

use MT::Test::Tag;

# plan tests => 2 * blocks;
plan tests => scalar blocks;

use MT::Test qw( :db );
use MT::Test::Permission;

use MT::Entry;

filters {
    template => [qw( chomp )],
    expected => [qw( chomp )],
};

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
    my $ct = MT::Test::Permission->make_content_type( blog_id => $blog_id );
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
        }
        else {
            $cat_field->id( $field_id + 2 );
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
        data =>
            { $category_fields[ $ct->id - 1 ][1]->id => [ $cats[0]->id ] },
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

MT::Test::Tag->run_perl_tests($blog_id);

# MT::Test::Tag->run_php_test($blog_id);

__END__

=== MTCategoryCount
--- template
<MTCategories category_set_id="1" show_empty="1" sort="label"><MTCategoryLabel>:<MTCategoryCount>
</MTCategories>
--- expected
a:4
b:2
c:0

=== MTCategoryCount content_type_id="1"
--- template
<MTCategories category_set_id="1" show_empty="1" sort="label"><MTCategoryLabel>:<MTCategoryCount content_type_id="1">
</MTCategories>
--- expected
a:2
b:1
c:0

=== MTCategoryCount content_field_id="1"
--- template
<MTCategories category_set_id="1" show_empty="1" sort="label"><MTCategoryLabel>:<MTCategoryCount content_field_id="1">
</MTCategories>
--- expected
a:1
b:1
c:0

