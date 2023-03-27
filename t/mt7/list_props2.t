use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';
}

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;

use MT::ContentData;
use MT::ListProperty;

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

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

    my $fields = [{
        id      => $content_field->id,
        order   => 1,
        type    => $content_field->type,
        options => {
            display  => 'force',
            hint     => '',
            label    => 1,
            required => 1,
        },
    }];
    $content_type->fields($fields);
    $content_type->save or die $content_type->errstr;
});

my $content_type = MT::ContentType->load({ name => 'test content type' });

MT->request->reset;

my $content_data = MT::Test::Permission->make_content_data(
    blog_id         => $content_type->blog_id,
    author_id       => 1,
    content_type_id => $content_type->id,
    data            => { 1 => 'test' },
);

MT::CMS::ContentType::init_content_type(undef, MT->instance);

subtest 'entry' => sub {
    my $app  = MT->instance;
    my $prop = MT::ListProperty->list_properties('entry');
    is_deeply(
        [sort keys %$prop],
        [
            '__id',
            '__legacy',
            '__mobile',
            'author_id',
            'author_name',
            'author_status',
            'authored_on',
            'basename',
            'blog_id',
            'blog_name',
            'category',
            'category_id',
            'content',
            'created_on',
            'current_context',
            'current_user',
            'excerpt',
            'id',
            'modified_by',
            'modified_on',
            'pack',
            'status',
            'tag',
            'text',
            'text_more',
            'title',
            'unpublished_on'
        ],
        'right keys'
    );

    is_deeply(
        [grep { $prop->{$_}->has('condition') } sort keys %$prop],
        [
            '__id',
            'blog_name',
            'current_context',
            'current_user'
        ],
        'right keys'
    );

    is(keys %MT::ListProperty::CachedListProperties, 1, 'cache is stored');
};

subtest 'content_data' => sub {
    %MT::ListProperty::CachedListProperties = ();

    my $app  = MT->instance;
    my $prop = MT::ListProperty->list_properties('content_data.content_data_1');
    is_deeply(
        [sort keys %$prop],
        [
            '__id',
            '__legacy',
            '__mobile',
            'author_id',
            'author_name',
            'author_status',
            'authored_on',
            'blog_id',
            'blog_name',
            'content',
            'content_field_1',
            'created_on',
            'current_context',
            'current_user',
            'id',
            'label',
            'modified_by',
            'modified_on',
            'pack',
            'status',
            'unpublished_on'
        ],
        'right keys'
    );

    is_deeply(
        [grep { $prop->{$_}->has('condition') } sort keys %$prop],
        [
            '__id',
            'current_user'
        ],
        'right keys'
    );

    is(keys %MT::ListProperty::CachedListProperties, 1, 'cache is stored');
};

done_testing;
