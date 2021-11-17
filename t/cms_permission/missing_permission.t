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

use MT::Test;
use MT::Test::Fixture;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture('db');
my $objs = MT::Test::Fixture->prepare({
    author  => [qw/author/],
    website => [{
            name => 'first_site',
        },
        {
            name => 'second_site',
        },
    ],
    content_type => {
        ct => {
            website => 'first_site',
            fields  => [
                cf_multi => {
                    type => 'multi_line_text',
                    name => 'value',
                },
            ],
        },
        ct2 => {
            website => 'second_site',
            fields  => [
                cf_multi2 => {
                    type => 'multi_line_text',
                    name => 'value',
                },
            ],
        },
    },
    role => {
        test_role => [
            { content_type => 'ct',  permission => 'manage_content_data' },
            { content_type => 'ct2', permission => 'manage_content_data' },
        ],
    },
});

my $admin       = MT::Author->load(1);
my $first_site  = $objs->{website}{first_site};
my $second_site = $objs->{website}{second_site};

subtest 'remove sites that relate to the test role' => sub {
    my $role = MT::Role->load({ name => 'test_role' });
    note explain [split ',', $role->permissions];

    MT::Permission->reset_permissions;

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->post_ok({
        __mode      => 'itemset_action',
        _type       => 'website',
        action_name => 'delete',
        blog_id     => 0,
        return_args => '__mode%3Dlist%26_type%3Dwebsite%26blog_id%3D0%26does_act%3D1',
        id          => $second_site->id,
    });
    ok !$app->generic_error, "no error";

    $test_env->clear_mt_cache;
    $role = MT::Role->load({ name => 'test_role' });
    note explain [split ',', $role->permissions];

    MT::Permission->reset_permissions;

    $app->post_ok({
        __mode      => 'itemset_action',
        _type       => 'website',
        action_name => 'delete',
        blog_id     => 0,
        return_args => '__mode%3Dlist%26_type%3Dwebsite%26blog_id%3D0%26does_act%3D1',
        id          => $first_site->id,
    });
    ok !$app->generic_error, "no error";

    $test_env->clear_mt_cache;
    $role = MT::Role->load({ name => 'test_role' });
    note explain [split ',', $role->permissions];
};

done_testing;
