#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../../t/lib";    # t/lib
use Test::More;

use MT::Test::Env;
our $test_env;
use MT::Test::Fixture;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Serialize;
use MT::ContentStatus;
use MT::Test::App;

### Make test data
$test_env->prepare_fixture(sub {
    MT::Test->init_db;

    my $site = MT::Test::Permission->make_website(name => 'my website');

    my $admin = MT::Author->load(1);

    my $content_type = MT::Test::Permission->make_content_type(
        blog_id => $site->id,
        name    => 'test content type',
    );

    my $content_field = MT::Test::Permission->make_content_field(
        blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
        name            => 'single line text',
        type            => 'single_line_text',
    );
    my $content_field_2 = MT::Test::Permission->make_content_field(
        blog_id         => $content_type->blog_id,
        content_type_id => $content_type->id,
        name            => 'multi line text',
        type            => 'multi_line_text',
    );
    my $field_data = [{
            id        => $content_field->id,
            order     => 1,
            type      => $content_field->type,
            options   => { label => $content_field->name, },
            unique_id => $content_field->unique_id,
        },
        {
            id        => $content_field_2->id,
            order     => 2,
            type      => $content_field_2->type,
            options   => { label => $content_field_2->name, },
            unique_id => $content_field_2->unique_id,
        },
    ];
    $content_type->fields($field_data);
    $content_type->save or die $content_type->errstr;

    my $content_data = MT::Test::Permission->make_content_data(
        blog_id         => $site->id,
        author_id       => $admin->id,
        content_type_id => $content_type->id,
        label           => 'cd1',
        status          => MT::ContentStatus::HOLD(),
        data            => {
            $content_field->id   => 'test text',
            $content_field_2->id => 'test text2'
        },
        convert_breaks => MT::Serialize->serialize(\{ $content_field_2->id => 'markdown' }),
    );
});

my $site         = MT->model('website')->load({ name => 'my website' });
my $content_data = MT->model('content_data')->load({ label => 'cd1' });

subtest 'to push copy button' => sub {
    subtest 'is permitted by "System Administrator" (system)' => sub {
        my $admin = MT->model('author')->load(1);
        die unless $admin && $admin->is_superuser;

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode          => 'copy_this_content_data',
            _type           => 'content_data',
            type            => 'content_data_' . $content_data->content_type_id,
            blog_id         => $content_data->blog_id,
            content_type_id => $content_data->content_type_id,
            origin          => $content_data->id,
        });
        $app->has_no_invalid_request;
        $app->has_no_permission_error;
    };

    subtest 'is permitted by "Manage All Content Data" (system)' => sub {
        my $user = MT::Test::Permission->make_author(
            name     => 'manage_all_content_data_system',
            nickname => 'Manage All Content Data (system)',
        );
        $user->can_manage_content_data(1);
        $user->save or die $user->errstr;

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($user);
        $app->get_ok({
            __mode          => 'copy_this_content_data',
            _type           => 'content_data',
            type            => 'content_data_' . $content_data->content_type_id,
            blog_id         => $content_data->blog_id,
            content_type_id => $content_data->content_type_id,
            origin          => $content_data->id,
        });
        $app->has_no_invalid_request;
        $app->has_no_permission_error;
    };

    subtest 'is permitted by "Manage All Content Data" (site)' => sub {
        my $user = MT::Test::Permission->make_author(
            name     => 'manage_all_content_data_site',
            nickname => 'Manage All Content Data (site)',
        );
        my $role = MT::Test::Permission->make_role(
            name        => 'manage_all_content_data_site',
            permissions => "'manage_content_data'",
        );
        MT->model('association')->link($user => $role => $site) or die MT->model('association')->errstr;

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($user);
        $app->get_ok({
            __mode          => 'copy_this_content_data',
            _type           => 'content_data',
            type            => 'content_data_' . $content_data->content_type_id,
            blog_id         => $content_data->blog_id,
            content_type_id => $content_data->content_type_id,
            origin          => $content_data->id,
        });
        $app->has_no_invalid_request;
        $app->has_no_permission_error;
    };

    subtest 'is permitted by "Create Content Data" and "Edit All Content Data" permission (content type)' => sub {
        my $user = MT::Test::Permission->make_author(
            name     => 'edit_all_content_data_content_type',
            nickname => 'Edit All Content Data (content type)',
        );
        my $create_permission = 'create_content_data:' . $content_data->ct_unique_id;
        my $edit_permission   = 'edit_all_content_data:' . $content_data->ct_unique_id;
        my $role              = MT::Test::Permission->make_role(
            name        => 'edit_all_content_data_content_type',
            permissions => "'${create_permission}','${edit_permission}'",
        );
        MT->model('association')->link($user => $role => $site) or die MT->model('association')->errstr;

        _test_permission_ok($user, $content_data);
    };

    subtest 'is permitted by "Create Content Data" and "Publish Content Data" (content type) with content data owned by' => sub {
        my $user = MT::Test::Permission->make_author(
            name     => 'publish_content_data_content_type',
            nickname => 'Publish Content Data (content type)',
        );
        my $create_permission  = 'create_content_data:' . $content_data->ct_unique_id;
        my $publish_permission = 'publish_content_data:' . $content_data->ct_unique_id;
        my $role               = MT::Test::Permission->make_role(
            name        => 'publish_content_data_content_type',
            permissions => "'${create_permission}','${publish_permission}'",
        );
        MT->model('association')->link($user => $role => $site) or die MT->model('association')->errstr;

        $content_data->author_id($user->id);
        $content_data->save or die $content_data->errstr;

        _test_permission_ok($user, $content_data);
    };

    subtest 'is permitted by "Create Content Data" with draft content data owned by' => sub {
        my $user = MT::Test::Permission->make_author(
            name     => 'create_content_data_content_type',
            nickname => 'Create Content Data (content type)',
        );
        my $permission = 'create_content_data:' . $content_data->ct_unique_id;
        my $role       = MT::Test::Permission->make_role(
            name        => 'publish_content_data_content_type',
            permissions => "'${permission}'",
        );
        MT->model('association')->link($user => $role => $site) or die MT->model('association')->errstr;

        $content_data->author_id($user->id);
        $content_data->status(MT::ContentStatus::HOLD());
        $content_data->save or die $content_data->errstr;

        _test_permission_ok($user, $content_data);
    };

    subtest 'is not permitted by "Create Content Data" with content data not owned by' => sub {
        my $user       = MT->model('author')->load({ name => 'create_content_data_content_type' })  or die MT->model('author')->errstr;
        my $other_user = MT->model('author')->load({ name => 'publish_content_data_content_type' }) or die MT->model('author')->errstr;

        $content_data->author_id($other_user->id);
        $content_data->save or die $content_data->errstr;

        # _test_permission_not_ok
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($user);
        $app->get_ok({
            __mode          => 'copy_this_content_data',
            _type           => 'content_data',
            type            => 'content_data_' . $content_data->content_type_id,
            blog_id         => $content_data->blog_id,
            content_type_id => $content_data->content_type_id,
            origin          => $content_data->id,
        });
        $app->has_no_invalid_request;
        $app->has_permission_error;
    };
};

done_testing();

sub _test_permission_ok {
    my ($user, $content_data) = @_;
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($user);
    $app->get_ok({
        __mode          => 'copy_this_content_data',
        _type           => 'content_data',
        type            => 'content_data_' . $content_data->content_type_id,
        blog_id         => $content_data->blog_id,
        content_type_id => $content_data->content_type_id,
        origin          => $content_data->id,
    });
    $app->has_no_invalid_request;
    $app->has_no_permission_error;
}
