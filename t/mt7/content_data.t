use strict;
use warnings;

use Test::More;

use lib qw( lib extlib t/lib );
use MT::Test qw( :db );
use MT::Test::Permission;

use MT::ContentFieldIndex;

my $ct = MT::Test::Permission->make_content_type(
    blog_id => 1,
    name    => 'test content type',
);

my $cf = MT::Test::Permission->make_content_field(
    blog_id         => $ct->blog_id,
    content_type_id => $ct->id,
    name            => 'single text',
    type            => 'single_line_text',
);

my $fields = [
    {   id        => $cf->id,
        label     => 1,
        name      => $cf->name,
        order     => 1,
        type      => $cf->type,
        unique_id => $cf->unique_id,
    }
];
$ct->fields($fields);
$ct->save or die $ct->errstr;

my $cd = MT::Test::Permission->make_content_data(
    blog_id         => $ct->blog_id,
    author_id       => 1,
    content_type_id => $ct->id,
    data            => { $cf->id => 'test text' },
);

subtest 'save' => sub {
    my $cf_idx = MT::ContentFieldIndex->load(
        {   content_type_id  => $ct->id,
            content_data_id  => $cd->id,
            content_field_id => $cf->id,
        }
    );
    ok( $cf_idx,
        'created MT::ContentFieldIndex after saving MT::ContentData' );
    is( $cf_idx->value_varchar, 'test text', 'same data is set' );
};

subtest 'content_type' => sub {
    my $got = $cd->content_type;
    ok( $got->isa('MT::ContentType'), 'get MT::ContentType instance' );
    is( $got->id, $cd->content_type_id,
        '$cd->content_type->id is same as $cd->content_type_id' );
};

subtest 'author' => sub {
    my $got = $cd->author;
    ok( $got->isa('MT::Author'), 'get MT::Author instance' );
    is( $got->id, $cd->author_id,
        '$cd->author->id is same as $cd->author_id' );
};

subtest 'unique_id' => sub {
    my $cd = MT::ContentData->new;
    $cd->set_values(
        {   author_id       => 1,
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
        }
    );

    $cd->unique_id('123');
    is( $cd->unique_id, undef, 'cannot set unique_id' );

    $cd->save or die $cd->errstr;
    ok( $cd->unique_id, 'set unique_id after save' );
    is( length $cd->unique_id, 40, 'length of unique_id is 40' );

    my $unique_id = $cd->unique_id;
    $cd->unique_id( $unique_id . '456' );
    is( $cd->unique_id, $unique_id, 'cannot set unique_id' );

    my $cd2 = MT::ContentData->new;
    $cd2->set_values(
        {   author_id       => 1,
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
        }
    );
    $cd2->save or die $cd2->errstr;
    $cd2->column( 'unique_id', $cd->unique_id );
    $cd2->save;
    ok( $cd2->errstr, 'unique_id column must be unique' );
};

subtest 'ct_unique_id' => sub {
    my $cd = MT::ContentData->new;
    $cd->set_values(
        {   author_id       => 1,
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
        }
    );

    $cd->ct_unique_id('123');
    is( $cd->ct_unique_id, undef, 'cannot set ct_unique_id' );

    $cd->save or die $cd->errstr;
    is( $cd->ct_unique_id, $ct->unique_id,
        'ct_unique_id is set when creating content data' );

    my $ct_unique_id = $cd->ct_unique_id;
    $cd->ct_unique_id('456');
    is( $cd->ct_unique_id, $ct_unique_id, 'cannot set ct_unique_id' );
};

subtest 'identifier' => sub {
    my $terms = {
        author_id       => 1,
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
    };
    my $cd1 = MT::Test::Permission->make_content_data( %$terms,
        identifier => 'identifier' );
    is( $cd1->identifier, 'identifier', 'identifier is "identifier"' );

    my $cd2 = MT::Test::Permission->make_content_data(%$terms);
    is( $cd2->identifier, $cd2->unique_id,
        'identifier is same as unique_id' );

};

subtest 'gather_changed_cols' => sub {
    my $cd = MT::Test::Permission->make_content_data(
        author_id       => 1,
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
    );
    my $cd_orig = $cd->clone;

    $cd->gather_changed_cols($cd_orig);
    is( $cd->{changed_revisioned_cols}, undef, 'same data column' );

    $cd->data( { abc => 1 } );

    $cd->gather_changed_cols($cd_orig);
    is_deeply( $cd->{changed_revisioned_cols},
        ['data'], 'different data column' );

    $cd_orig->data( { abc => 1 } );

    $cd->gather_changed_cols($cd_orig);
    is( $cd->{changed_revisioned_cols}, undef, 'same data column' );
};

done_testing;

