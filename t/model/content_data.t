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

use MT::Test::Permission;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);
my $site  = MT::Test::Permission->make_website(name => 'test site');

subtest 'MTC-30176' => sub {
    my $ct      = MT::Test::Permission->make_content_type(blog_id => $site->id);
    my $cf_list = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'list',
        type            => 'list',
    );
    my $fields = [{
            id      => $cf_list->id,
            order   => 1,
            type    => $cf_list->type,
            options => {
                'description' => '',
                'display'     => 'default',
                'label'       => 'list',
                'required'    => '0'
            },
            unique_id => $cf_list->unique_id,
        },
    ];
    $ct->fields($fields);
    $ct->save or die $ct->errstr;

    subtest 'save 255 character string to list field' => sub {
        my $cd = MT->model('content_data')->new(
            author_id       => $admin->id,
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
        );
        $cd->data({ $cf_list->id => 'a' x 255 });
        ok $cd->save;

        my $cf_idx = MT->model('content_field_index')->load({
            content_data_id  => $cd->id,
            content_field_id => $cf_list->id,
        });
        ok $cf_idx;
        is $cf_idx->value_varchar, 'a' x 255, 'index data was not truncated';
    };

    subtest 'save 256 charcter string to list field' => sub {
        my $cd = MT->model('content_data')->new(
            author_id       => $admin->id,
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
        );
        $cd->data({ $cf_list->id => 'b' x 256 });
        ok $cd->save;

        my $cf_idx = MT->model('content_field_index')->load({
            content_data_id  => $cd->id,
            content_field_id => $cf_list->id,
        });
        ok $cf_idx;
        is $cf_idx->value_varchar, 'b' x 255, 'index data was truncated';
    };
};

done_testing;
