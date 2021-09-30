use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::Permission;
use MT::Test::App;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);
my $site  = MT::Test::Permission->make_website(name => 'test site');

subtest 'nothing is duplicated (yet)' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->post_ok({
        __mode      => 'save',
        _type       => 'content_type',
        blog_id     => $site->id,
        return_args => '__mode=view&blog_id=1&_type=content_type',
        name        => 'ct',
        data        => JSON::encode_json([
            { type => 'single_line_text', options => { label => 'field1', description => '', id => 'cf1' }, order => 1 },
            { type => 'single_line_text', options => { label => 'field2', description => '', id => 'cf2' }, order => 2 },
        ]),
    });
    like $app->message_text => qr/Contents type settings has been saved/, "saved";
};

subtest 'duplication in the same content type setting' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->post_ok({
        __mode      => 'save',
        _type       => 'content_type',
        blog_id     => $site->id,
        return_args => '__mode=view&blog_id=1&_type=content_type',
        name        => 'ct2',
        data        => JSON::encode_json([
            { type => 'single_line_text', options => { label => 'field3', description => '' }, order => 1 },
            { type => 'single_line_text', options => { label => 'field3', description => '' }, order => 2 },
        ]),
    });
    like $app->message_text => qr/(Field 'field3' must be unique in this content type.|Saving content field failed: name "field3" is already used.)/, "found duplication";
};

subtest 'duplication in the same content type setting, with different cases' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->post_ok({
        __mode      => 'save',
        _type       => 'content_type',
        blog_id     => $site->id,
        return_args => '__mode=view&blog_id=1&_type=content_type',
        name        => 'ct2',
        data        => JSON::encode_json([
            { type => 'single_line_text', options => { label => 'field3', description => '' }, order => 1 },
            { type => 'single_line_text', options => { label => 'Field3', description => '' }, order => 2 },
        ]),
    });
    like $app->message_text => qr/(Field 'Field3' and 'field3' must not coexist within the same content type.|Saving content field failed: name "field3" is already used.)/i, "found duplication";
};

subtest 'duplication in the same content type setting, with different cases (2)' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->post_ok({
        __mode      => 'save',
        _type       => 'content_type',
        blog_id     => $site->id,
        return_args => '__mode=view&blog_id=1&_type=content_type',
        name        => 'ct2',
        data        => JSON::encode_json([
            { type => 'single_line_text', options => { label => 'FieldA', description => '' }, order => 1 },
            { type => 'single_line_text', options => { label => 'FIELDA', description => '' }, order => 2 },
        ]),
    });
    like $app->message_text => qr/Field 'FieldA' and 'FIELDA' must not coexist within the same content type./, "found duplication";
};

subtest 'duplication in the same content type setting, with different cases' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->post_ok({
        __mode      => 'save',
        _type       => 'content_type',
        blog_id     => $site->id,
        return_args => '__mode=view&blog_id=1&_type=content_type',
        name        => 'ct2',
        data        => JSON::encode_json([
            { type => 'single_line_text', options => { label => 'FieldA', description => '' }, order => 1 },
            { type => 'single_line_text', options => { label => 'fielda', description => '' }, order => 2 },
        ]),
    });
    like $app->message_text => qr/Field 'FieldA' and 'fielda' must not coexist within the same content type./, "found duplication";
};

subtest 'duplication with a broken content type field (SUPPORT-18)' => sub {
    my $field3 = MT->model('content_field')->load({ name => 'field3' });
    if (!$field3) {
        MT::Test::Permission->make_content_field(name => 'field3');
        $field3 = MT->model('content_field')->load({ name => 'field3' });
    }
    ok $field3 && !$field3->content_type_id, "orphan field3 exists";

    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->post_ok({
        __mode      => 'save',
        _type       => 'content_type',
        blog_id     => $site->id,
        return_args => '__mode=view&blog_id=1&_type=content_type',
        name        => 'ct3',
        data        => JSON::encode_json([
            { type => 'single_line_text', options => { label => 'field3', description => '' }, order => 1 },
        ]),
    });
    like $app->message_text => qr/Contents type settings has been saved/, "saved";
};

subtest 'renaming a field as the same name of a removed field in the same content type setting' => sub {
    my $app = MT::Test::App->new;
    $app->login($admin);
    $app->post_ok({
        __mode      => 'save',
        _type       => 'content_type',
        blog_id     => $site->id,
        return_args => '__mode=view&blog_id=1&_type=content_type',
        name        => 'ct4',
        data        => JSON::encode_json([
            { type => 'single_line_text', options => { label => 'field5', description => '' }, order => 1 },
            { type => 'single_line_text', options => { label => 'field6', description => '' }, order => 2 },
        ]),
    });
    like $app->message_text => qr/Contents type settings has been saved/, "saved";

    my $ct4 = MT->model('content_type')->load({ name => 'ct4' });

    my $field5 = MT->model('content_field')->load({ name => 'field5' });

    my $res = $app->post_ok({
        __mode      => 'save',
        _type       => 'content_type',
        blog_id     => $site->id,
        return_args => '__mode=view&blog_id=1&_type=content_type&id=' . $ct4->id,
        name        => 'ct4',
        id          => $ct4->id,
        data        => JSON::encode_json([
            { type => 'single_line_text', options => { label => 'field6', description => '' }, id => $field5->id, order => 1 },
        ]),
    });
    like $app->message_text => qr/Contents type settings has been saved/, "saved";
};

done_testing;
