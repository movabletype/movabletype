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
        is $cf_idx->value_text, 'a' x 255, 'index data was not truncated';
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
        is $cf_idx->value_text, 'b' x 256, 'index data was not truncated';
    };
};

subtest 'update_cf_idx_multi' => sub {
    my $ct      = MT::Test::Permission->make_content_type(blog_id => $site->id);
    my $cf_list = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'list',
        type            => 'list',
    );
    my $cf_single = MT::Test::Permission->make_content_field(
        blog_id         => $ct->blog_id,
        content_type_id => $ct->id,
        name            => 'single_line_text',
        type            => 'single_line_text',
    );
    my $fields = [{
            id         => $cf_list->id,
            order      => 1,
            type       => $cf_list->type,
            type_label => 'List',
            options    => {
                description => '',
                display     => 'default',
                label       => 'list',
                required    => '0'
            },
            unique_id => $cf_list->unique_id,
        },
        {
            id         => $cf_single->id,
            order      => 2,
            type       => 'single_line_text',
            type_label => 'Single Line Text',
            options    => {
                description   => '',
                display       => 'default',
                initial_value => '',
                label         => 'single',
                max_length    => '255',
                min_length    => '0',
                required      => '0',
            },
            unique_id => $cf_single->unique_id,
        },
    ];
    $ct->fields($fields);
    $ct->save or die $ct->errstr;

    subtest 'update all' => sub {
        my $cd = MT->model('content_data')->new(
            author_id       => $admin->id,
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
        );
        $cd->data({
            $cf_list->id   => ['foo'],
            $cf_single->id => 'bar',
        });
        $cd->save or die $cd->errstr;

        MT->model('content_field_index')->remove({
            content_data_id => $cd->id,
        });
        die if MT->model('content_field_index')->count({ content_data_id => $cd->id });

        $cd->update_cf_idx_multi;

        is scalar MT->model('content_field_index')->count({ content_data_id => $cd->id }), 2;
    };

    subtest 'update specified id' => sub {
        my $cd = MT->model('content_data')->new(
            author_id       => $admin->id,
            blog_id         => $ct->blog_id,
            content_type_id => $ct->id,
        );
        $cd->data({
            $cf_list->id   => ['foo'],
            $cf_single->id => 'bar',
        });
        $cd->save or die $cd->errstr;

        MT->model('content_field_index')->remove({
            content_data_id => $cd->id,
        });
        die if MT->model('content_field_index')->count({ content_data_id => $cd->id });

        $cd->update_cf_idx_multi([$cf_list->id]);

        my @cf_idx = MT->model('content_field_index')->load({ content_data_id => $cd->id });
        is scalar @cf_idx,               1;
        is $cf_idx[0]->content_field_id, $cf_list->id;
    };
};

done_testing;
