use strict;
use warnings;

use Test::More;

use lib qw( lib extlib t/lib );
use MT;
use MT::Test qw( :db );

use MT::ContentField;
use MT::ContentFieldIndex;
use MT::ContentType;
use MT::ContentData;

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
    is( $got->id, $ct->id, '$ct->id is ' . $ct->id );
};

done_testing;

