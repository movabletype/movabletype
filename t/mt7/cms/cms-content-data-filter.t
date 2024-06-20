use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use JSON;

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
my $site    = MT::Test::Permission->make_website(name => 'my website');
my $blog_id = $site->id;

my $ct1 = MT::Test::Permission->make_content_type(blog_id => $blog_id, name => 'child');
my $cf1 = MT::Test::Permission->make_content_field(
    blog_id         => $blog_id,
    content_type_id => $ct1->id,
    type            => 'single_line_text',
    name            => 'my_text',
);
$ct1->fields([{
    id        => $cf1->id,
    order     => 1,
    type      => $cf1->type,
    label     => 1,
    name      => $cf1->name,
    unique_id => $cf1->unique_id,
}]);
$ct1->save or die $ct1->errstr;

my $cd1 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct1->id,
    label           => 'test child cd',
    data            => { $cf1->id => 'child_cd' },
);

my $ct2 = MT::Test::Permission->make_content_type(blog_id => $blog_id, name => 'parent');
my $cf2 = MT::Test::Permission->make_content_field(
    blog_id                 => $blog_id,
    content_type_id         => $ct2->id,
    related_content_type_id => $ct1->id,
    type                    => 'content_type',
    name                    => 'my_ct',
);
$ct2->fields([{
    id        => $cf2->id,
    order     => 1,
    type      => $cf2->type,
    name      => $cf2->name,
    options   => { label => $cf1->name, source => $ct1->id },
    unique_id => $cf2->unique_id,
}]);
$ct2->save or die $ct2->errstr;

my $cd2 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $ct2->id,
    label           => 'test parent cd',
    data            => { $cf2->id => [$cd1->id] },
);

subtest 'listing with less privileged user' => sub {

    local $ENV{HTTP_X_REQUESTED_WITH} = 'XMLHttpRequest';

    my $test_formdata = {
        'blog_id'    => $ct2->blog_id,
        '__mode'     => 'filtered_list',
        'datasource' => 'content_data.content_data_' . $ct2->id,
        'columns'    => "label," . sprintf('content_field_%d', $cf2->id),
        'items'      => JSON::encode_json([{
                type => sprintf('content_field_%d_content_field_%d', $cf2->id, $cf1->id),
                args => { string => 'child_cd', option => 'contains' },
            },
        ]),
    };

    subtest 'permitted (MTC-29208)' => sub {
        my $user = MT::Test::Permission->make_author(name => 'user2', nickname => 'user2');
        my $role = MT::Test::Permission->make_role(name => 'My Role', permissions => "'manage_content_data'");
        my $blog = MT::Blog->load($ct2->blog_id);
        MT::Association->link($user, $role, $blog);

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($user);
        my $res = $app->post_ok($test_formdata);
        my $json = MT::Util::from_json($res->decoded_content);
        ok($json->{result}{count} == 1, 'got result without error');
        like($json->{result}{objects}[0][1], qr/test parent cd/, 'right label'); # col1
        like($json->{result}{objects}[0][2], qr/test child cd/,  'right label'); # col2
    };

    subtest 'not permitted' => sub {
        my $user = MT::Test::Permission->make_author(name => 'user1', nickname => 'user1');
        my $app  = MT::Test::App->new('MT::App::CMS');
        $app->login($user);
        my $res = $app->post_ok($test_formdata);
        my $json = MT::Util::from_json($res->decoded_content);
        is $json->{error}, "Permission denied\n";
    };
};

done_testing;
