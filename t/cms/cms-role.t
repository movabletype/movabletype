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
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

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

done_testing;
