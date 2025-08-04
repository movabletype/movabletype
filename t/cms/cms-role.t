#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage               => 'en_US',    ## for now
        DisableContentFieldPermission => 0,
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test::Permission;
use MT::Test::App;

$test_env->prepare_fixture('db');

MT->instance;
my $admin = MT::Author->load(1);

subtest 'Role name should not be duplicated' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');

    $app->login($admin);

    for my $ct ( 0 .. 1 ) {
        $app->get_ok(
            {   __mode  => 'view',
                _type   => 'role',
                blog_id => 0,
            }
        );
        is $app->page_title => "Create Role", "correct title";

        ok my $form = $app->forms, "form exists";

        my $role_name = 'Test Role';
        $form->param( name       => $role_name );
        $form->param( permission => 'administer_site' );
        $app->post_ok( $form->click );

        if ( !$ct ) {
            is $app->page_title   => "Edit Role", "correct title";
            like $app->message_text => qr/Your changes have been saved./,
                "correct message";
            my $role = MT::Role->load( { name => $role_name } );
            ok $role, "and role does exist";
        }
        else {
            is $app->page_title => $app->trans("An error occurred"), "error page is shown";
            like $app->generic_error =>
                qr/Another role already exists by that name./,
                "correct error";
        }
    }
};

subtest 'Content Type Privileges' => sub {
    subtest 'with no content type' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'role',
            blog_id => 0,
        });

        $app->content_unlike('Content Type Privileges');
        $app->content_unlike('Content Field Privileges');
    };

    subtest 'with content type' => sub {
        my $site = MT->model('website')->load;

        my $content_type_1 = MT::Test::Permission->make_content_type(
            blog_id => $site->id,
            name    => 'test content type 1',
        );
        my $ct1_content_field_1 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_1->blog_id,
            content_type_id => $content_type_1->id,
            name            => 'single line text',
            type            => 'single_line_text',
        );
        my $ct1_content_field_2 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_1->blog_id,
            content_type_id => $content_type_1->id,
            name            => 'multi line text',
            type            => 'multi_line_text',
        );
        my $ct1_field_data = [{
                id        => $ct1_content_field_1->id,
                order     => 1,
                type      => $ct1_content_field_1->type,
                options   => { label => $ct1_content_field_1->name, },
                unique_id => $ct1_content_field_1->unique_id,
            },
            {
                id        => $ct1_content_field_2->id,
                order     => 1,
                type      => $ct1_content_field_2->type,
                options   => { label => $ct1_content_field_2->name, },
                unique_id => $ct1_content_field_2->unique_id,
            },
        ];
        $content_type_1->fields($ct1_field_data);
        $content_type_1->save or die $content_type_1->errstr;

        my $content_type_2 = MT::Test::Permission->make_content_type(
            blog_id => $site->id,
            name    => 'test content type 2',
        );
        my $ct2_content_field_1 = MT::Test::Permission->make_content_field(
            blog_id         => $content_type_2->blog_id,
            content_type_id => $content_type_2->id,
            name            => 'number',
            type            => 'number',
        );
        my $ct2_field_data = [{
                id        => $ct2_content_field_1->id,
                order     => 1,
                type      => $ct2_content_field_1->type,
                options   => { label => $ct2_content_field_1->name, },
                unique_id => $ct2_content_field_1->unique_id,
            },
        ];
        $content_type_2->fields($ct2_field_data);
        $content_type_2->save or die $content_type_2->errstr;

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'view',
            _type   => 'role',
            blog_id => 0,
        });

        _content_like_count($app, 'Content Type Privileges', 1);

        _content_like_count($app, 'Manage Content Data',   2);
        _content_like_count($app, 'Create Content Data',   2);
        _content_like_count($app, 'Publish Content Data',  2);
        _content_like_count($app, 'Edit All Content Data', 2);

        _content_like_count($app, 'Content Field Privileges', 2);

        _content_like_count($app, 'single line text', 1);
        _content_like_count($app, 'multi line text',  1);
    };
};

done_testing;

sub _content_like_count {
    my ($self, $pattern, $count, $message) = @_;
    $pattern = qr/\Q$pattern\E/ unless ref $pattern;
    is scalar(() = $self->content =~ /$pattern/g), $count // 1, $message // "content contains $pattern $count " . ($count >= 2 ? 'times' : 'time');
}
