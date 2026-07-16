use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../lib";
use Test::More;
use MT::Test::Env;

our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::DataAPI;
use MT::Test::Permission;

my $blog_id = 1;

$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $category_set = MT::Test::Permission->make_category_set(
        blog_id => $blog_id,
        name    => 'filter category set',
    );
    my $category = MT::Test::Permission->make_category(
        blog_id         => $blog_id,
        category_set_id => $category_set->id,
        label           => 'filter category',
    );
    my $content_type = MT::Test::Permission->make_content_type(
        blog_id => $blog_id,
        name    => 'filter content type',
    );
    my $content_field = MT::Test::Permission->make_content_field(
        blog_id            => $blog_id,
        content_type_id    => $content_type->id,
        related_cat_set_id => $category_set->id,
        name               => 'category_set',
        type               => 'categories',
    );

    $content_type->fields([{
        id        => $content_field->id,
        label     => 1,
        name      => $content_field->name,
        order     => 1,
        type      => $content_field->type,
        unique_id => $content_field->unique_id,
    }]);
    $content_type->save or die $content_type->errstr;
});

use MT::App::DataAPI;
my $app = MT::App::DataAPI->new;

my $content_type = MT->model('content_type')->load({ name => 'filter content type' });
my $category_set = MT->model('category_set')->load({ name => 'filter category set' });

my $suite = suite();
test_data_api($suite);

done_testing;

sub suite {
    return +[{
            note         => 'category_set field filter for content type: match',
            path         => "/v4/sites/$blog_id/contentTypes",
            method       => 'GET',
            is_superuser => 1,
            params       => {
                items => [{
                    type => 'category_set',
                    args => {
                        value => $category_set->id,
                    }
                }],
            },
            result => sub {
                +{
                    totalResults => 1,
                    items        => MT::DataAPI::Resource->from_object([$content_type]),
                };
            },
        },
        {
            note         => 'category_set field filter for content type: not match',
            path         => "/v4/sites/$blog_id/contentTypes",
            method       => 'GET',
            is_superuser => 1,
            params       => {
                items => [{
                    type => 'category_set',
                    args => {
                        option => 'option',
                        value  => $category_set->id + 1,
                    }
                }],
            },
            result => sub {
                +{
                    totalResults => 0,
                    items        => [],
                };
            },
        },
    ];
}
