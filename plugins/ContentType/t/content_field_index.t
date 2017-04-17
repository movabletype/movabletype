use strict;
use warnings;

use Test::More;

use lib qw( lib extlib t/lib );
use MT;
use MT::Test qw( :db );

use MT::ContentData;
use MT::ContentField;
use MT::ContentFieldIndex;
use MT::ContentType;

subtest 'load_or_new' => sub {
    subtest 'new' => sub {
        my $terms = {
            content_type_id  => 1,
            content_data_id  => 2,
            content_field_id => 3,
        };

        my $cf_idx = MT::ContentFieldIndex->load_or_new($terms);

        ok( $cf_idx->isa('MT::ContentFieldIndex'),
            'get MT::ContentFieldIndex instance'
        );
        ok( !$cf_idx->id, 'get new instance' );
        is( $cf_idx->content_type_id,  1, 'content_type_id is 1' );
        is( $cf_idx->content_data_id,  2, 'content_data_id is 2' );
        is( $cf_idx->content_field_id, 3, 'content_field_id is 3' );
    };

    subtest 'load' => sub {

        # prepare
        my $ct = MT::ContentType->new;
        $ct->set_values(
            {   blog_id => 1,
                name    => 'test content type',
            }
        );
        $ct->save or die $ct->errstr;

        my $cf = MT::ContentField->new;
        $cf->set_values(
            {   blog_id         => $ct->blog_id,
                content_type_id => $ct->id,
                name            => 'single text',
                type            => 'single_line_text',
            }
        );
        $cf->save or die $cf->errstr;

        my $fields = [
            {   id         => $cf->id,
                label      => 1,
                name       => $cf->name,
                order      => 1,
                type       => $cf->type,
                unique_key => $cf->unique_key,
            }
        ];
        $ct->fields($fields);
        $ct->save or die $ct->errstr;

        my $cd = MT::ContentData->new;
        $cd->set_values(
            {   blog_id         => $ct->blog_id,
                author_id       => 1,
                content_type_id => $ct->id,
            }
        );
        $cd->data( { $cf->id => 'test text' } );
        $cd->save or die $cd->errstr;

        # do
        my $terms = {
            content_type_id  => $ct->id,
            content_data_id  => $cd->id,
            content_field_id => $cf->id,
        };
        my $cf_idx = MT::ContentFieldIndex->load_or_new($terms);

        # test
        ok( $cf_idx->isa('MT::ContentFieldIndex'),
            'get MT::ContentFieldIndex instance'
        );
        ok( $cf_idx->id, 'load existing instance' );
        is( $cf_idx->content_type_id => $ct->id,
            'content_type_id is ' . $ct->id
        );
        is( $cf_idx->content_data_id => $cd->id,
            'content_data_id is ' . $cd->id
        );
        is( $cf_idx->content_field_id => $cf->id,
            'content_field_id is ' . $cf->id
        );
    };
};

subtest 'set_value' => sub {
    my $cf_idx = MT::ContentFieldIndex->new;

    ok( $cf_idx->set_value( 'varchar', 'abc' ), 'set varchar' );
    is( $cf_idx->value_varchar, 'abc', 'get varchar' );

    ok( $cf_idx->set_value( 'blob', 'aiueo' ), 'set blob' );
    is( $cf_idx->value_blob, 'aiueo', 'get blob' );

    ok( $cf_idx->set_value( 'datetime', '20170413000000' ), 'set datetime' );
    is( $cf_idx->value_datetime, '20170413000000', 'get datetime' );

    ok( $cf_idx->set_value( 'integer', 123 ), 'set integer' );
    is( $cf_idx->value_integer, 123, 'get integer' );

    ok( $cf_idx->set_value( 'float', 3.141592 ), 'set float' );
    is( $cf_idx->value_float, 3.141592, 'get float' );

    # irregular tests
    ok( !$cf_idx->set_value( 'INVALID_TYPE', 'irohani' ),
        'set invalid type' );
    ok( !$cf_idx->set_value( '',    'hoheto' ),      'set empty string' );
    ok( !$cf_idx->set_value( undef, 'chirinuruwo' ), 'set undef' );
};

done_testing;

