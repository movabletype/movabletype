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
    is( $cd->unique_id, undef, 'canot set unique_id' );

    $cd->save or die $cd->errstr;
    ok( $cd->unique_id, 'set unique_id after save' );
    is( length $cd->unique_id, 40, 'length of unique_id is 40' );

    my $unique_id = $cd->unique_id;
    $cd->unique_id( $unique_id . '456' );
    is( $cd->unique_id, $unique_id, 'cannot set unique_id' );
};

done_testing;

