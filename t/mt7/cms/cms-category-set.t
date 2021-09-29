use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;

our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

$test_env->prepare_fixture('db');

my $website = MT->model('website')->load or die;
my $blog_id = $website->id;

my $admin = MT->model('author')->load;
unless ($admin->is_superuser) {
    $admin->is_superuser(1);
    $admin->save or die;
}

# https://movabletype.atlassian.net/browse/MTC-26597
subtest 'remove category_set related to invalid content_field' => sub {
    my $remove_catset = MT::Test::Permission->make_category_set(blog_id => $blog_id,);
    MT::Test::Permission->make_content_field(
        blog_id            => $blog_id,
        content_type_id    => undef,
        name               => 'missing content field',
        related_cat_set_id => $remove_catset->id,
        type               => 'categories',
    );

    my $return_args         = "__mode=list&blog_id=$blog_id&_type=category_set&does_act=1";
    my $encoded_return_args = quotemeta $return_args;

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode      => 'delete',
        _type       => 'category_set',
        action_name => 'delete',
        blog_id     => $blog_id,
        return_args => $return_args,
        id          => $remove_catset->id,
    });

    ## XXX: no message?
    ok $app->last_location->query_param('saved_deleted');
    ok !$app->generic_error, 'no error message is showed';
    is(
        MT->model('category_set')->load($remove_catset->id),
        undef, 'category_set has been removed'
    );
};

done_testing;
