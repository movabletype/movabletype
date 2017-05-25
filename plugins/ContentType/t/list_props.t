use strict;
use warnings;

use Test::MockModule;
use Test::More;

use lib qw( lib extlib t/lib );
use MT;
use MT::Test qw( :app :db );

use MT::ContentData;
use MT::ContentType;
use MT::ContentField;
use MT::ContentFieldIndex;
use MT::ListProperty;
use ContentType::ListProperties;

my $content_type = MT::ContentType->new;
$content_type->set_values(
    {   blog_id => 1,
        name    => 'test content type',
    }
);
$content_type->save or die $content_type->errstr;

my $content_field = MT::ContentField->new;
$content_field->set_values(
    {   blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
        name            => 'single text',
        type            => 'single_line_text',
    }
);
$content_field->save or die $content_field->errstr;

my $fields = [
    {   id      => $content_field->id,
        order   => 1,
        type    => $content_field->type,
        options => {
            display  => 'force',
            hint     => '',
            label    => 1,
            required => 1,
        },
    }
];
$content_type->fields($fields);
$content_type->save or die $content_type->errstr;

subtest 'make_list_properties' => sub {
    my $props = ContentType::ListProperties::make_list_properties;
    ok( $props && ref $props eq 'HASH', 'make_list_properties returns hash' );
};

subtest 'make_title' => sub {
    my $prop = MT::ListProperty->new( 'content_data_1', 'content_field_1' );
    my $content_data = MT::ContentData->new;
    $content_data->set_values(
        {   blog_id         => $content_type->blog_id,
            author_id       => 1,
            content_type_id => $content_type->id,
        }
    );
    $content_data->data( { 1 => 'test' } );
    $content_data->save or die $content_data->errstr;
    my $app = MT->instance;

    my $html
        = ContentType::ListProperties::make_title_html( $prop, $content_data,
        $app );
    ok( $html =~ /^<span class/, 'no error occurs' );
};

done_testing;

