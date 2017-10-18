use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}


use Test::MockModule;
use MT::Test qw( :app :db );
use MT::Test::Permission;

use MT::ContentData;
use MT::ListProperty;

my $content_type = MT::Test::Permission->make_content_type(
    blog_id => 1,
    name    => 'test content type',
);

my $content_field = MT::Test::Permission->make_content_field(
    blog_id         => $content_type->blog_id,
    content_type_id => $content_type->id,
    name            => 'single text',
    type            => 'single_line_text',
);

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

subtest 'make_list_props' => sub {
    my $props = MT::ContentData::make_list_props();
    ok( $props && ref $props eq 'HASH', 'make_list_properties returns hash' );
    MT->registry( 'list_properties', $props )
        ;    # registry will be updated after rebooting.
};

subtest 'make_title' => sub {
    my $prop = MT::ListProperty->new( 'content_data.content_data_1', 'content_field_1' );
    my $content_data = MT::Test::Permission->make_content_data(
        blog_id         => $content_type->blog_id,
        author_id       => 1,
        content_type_id => $content_type->id,
        data            => { 1 => 'test' },
    );
    my $app = MT->instance;

    my $html
        = MT::ContentData::_make_title_html( $prop, $content_data, $app );
    ok( $html =~ /^<span class/, 'no error occurs' );
};

done_testing;

