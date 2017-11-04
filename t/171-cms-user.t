#!/usr/bin/perl
use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Association;
use MT::CMS::User;
use MT::Role;

use MT::Test;
use MT::Test::Permission;

MT::Test->init_app;

$test_env->prepare_fixture('db_data');

MT->instance;
my $admin = MT::Author->load(1);

subtest 'Edit Profile screen' => sub {

    my $test = sub {
        my $args  = shift;
        my %param = (
            __test_user      => $admin,
            __request_method => 'POST',
            __mode           => 'save',
            _type            => 'author',
            name             => $args->{name},
            nickname         => 'nickname',
            email            => 'test@example.com',
            url              => 'http://example.com/',
            api_password     => 'secret',
            auth_type        => 'MT',
            type             => MT::Author::AUTHOR(),
            is_superuser     => 0,
            status           => $args->{status},
            pass             => 'password',
            pass_verify      => 'password',
            $args->{id} ? ( id => $args->{id} ) : (),
        );
        my $app = _run_app( 'MT::App::CMS', \%param );
        delete $app->{__test_output};
    };

    subtest 'Existing name user' => sub {
        my $out = $test->(
            {   name   => 'aikawa',
                status => MT::Author::ACTIVE(),
            }
        );
        ok( $out =~ m/saved=1&saved_added=1/, 'Created active user.' );

        $out = $test->(
            {   name   => 'aikawa',
                status => MT::Author::ACTIVE(),
            }
        );
        ok( $out !~ m/saved=1&saved_added=1/,
            'Not created active user with other user\'s name.' );
        ok( $out =~ m/A user with the same name already exists\./,
            'Error message: A user with the same name already exists.'
        );

        $out = $test->(
            {   name   => 'aikawa',
                status => MT::Author::INACTIVE(),
            }
        );
        ok( $out !~ m/saved=1&saved_added=1/,
            'Not created inactive user with other user\'s name.' );
        ok( $out =~ m/A user with the same name already exists\./,
            'Error message: A user with the same name already exists.'
        );
    };

    subtest 'Original name user' => sub {
        my $out = $test->(
            {   name   => 'ichikawa',
                status => MT::Author::ACTIVE(),
            }
        );
        ok( $out =~ m/saved=1&saved_added=1/,
            'Created active user with original name.'
        );

        $test->(
            {   name   => 'ukawa',
                status => MT::Author::INACTIVE(),
            }
        );
        ok( $out =~ m/saved=1&saved_added=1/,
            'Created inactive user with original name.' );
        ok( MT::Author->exist(
                { name => 'ukawa', status => MT::Author::INACTIVE }
            ),
            'User "ukawa" whose status is inactive exists.'
        );
    };

    subtest 'Empty name user' => sub {
        my $out = $test->(
            {   name   => '',
                status => MT::Author::ACTIVE(),
            }
        );
        ok( $out !~ m/saved=1&saved_added=1/,
            'Not created active user with empty name.' );
        ok( $out =~ m/User requires username/,
            'Error message: User requires username'
        );

        $out = $test->(
            {   name   => '',
                status => MT::Author::INACTIVE(),
            }
        );
        ok( $out =~ m/saved=1&saved_added=1/,
            'Created inactive user with empty name.'
        );

        $out = $test->(
            {   name   => '',
                status => MT::Author::INACTIVE(),
            }
        );
        ok( $out =~ m/saved=1&saved_added=1/,
            'Created second inactive user with emtpy name.' );

        my $latest_user = MT::Author->load( undef,
            { sort => 'created_on', direction => 'descend' } );
        $out = $test->(
            {   name   => '',
                status => MT::Author::INACTIVE(),
                id     => $latest_user->id,
            }
        );
        ok( $out =~ m/saved=1&saved_changes=1/,
            'Updated inactive user with empty name.'
        );

        $out = $test->(
            {   name   => '',
                status => MT::Author::ACTIVE(),
                id     => $latest_user->id,
            }
        );
        ok( $out !~ m/saved=1&saved_changes=1/,
            'Not updated active user with empty name.'
        );
        ok( $out =~ m/User requires username/,
            'Error message: User requires username.'
        );

    };
};

subtest 'Manage Users screen' => sub {
    subtest 'Check system messages' => sub {
        my $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $admin,
                __mode      => 'list',
                _type       => 'author',
                blog_id     => 0,
            },
        );
        my $out = delete $app->{__test_output};
        my $msg = quotemeta
            'the selected user(s) could not be re-enabled because they had some invalid parameter(s). Please check activity log for more details.';
        ok( $out !~ m/$msg/, 'There is no system message.' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $admin,
                __mode      => 'list',
                _type       => 'author',
                blog_id     => 0,
                not_enabled => 1,
            },
        );
        $out = delete $app->{__test_output};
        my $url_activity_log = $app->uri . '?__mode=list&_type=log&blog_id=0';
        $msg = quotemeta
            "Some (1) of the selected user(s) could not be re-enabled because they had some invalid parameter(s). Please check the <a href='$url_activity_log' class=\"alert-link\">activity log</a> for more details.";
        ok( $out =~ m/$msg/,
            'There is a system message: could not be re-enabled one user.' );

        $app = _run_app(
            'MT::App::CMS',
            {   __test_user => $admin,
                __mode      => 'list',
                _type       => 'author',
                blog_id     => 0,
                not_enabled => 5,
            },
        );
        $out = delete $app->{__test_output};
        $msg = quotemeta
            "Some (5) of the selected user(s) could not be re-enabled because they had some invalid parameter(s). Please check the <a href='$url_activity_log' class=\"alert-link\">activity log</a> for more details.";
        ok( $out =~ m/$msg/,
            'There is a system message: could not be re-enabled five user.' );
    };

    subtest 'Enable users having no name' => sub {
        my $no_name_count = MT::Author->count(
            { name => '', status => MT::Author::INACTIVE } );

        my $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'enable_object',
                _type            => 'author',
                action_name      => 'enable',
                return_args =>
                    '__mode=list&_type=author&blog_id=0&does_act=1',
                id => [
                    map { $_->id } MT::Author->load(
                        { name => '', status => MT::Author::INACTIVE }
                    )
                ],
            },
        );
        my $out = delete $app->{__test_output};
        ok( $out =~ m/Status: 302 Found/
                && $out !~ m/saved_status=enabled/
                && $out =~ m/not_enabled=$no_name_count/,
            "$no_name_count users having no name have not been enabled."
        );
    };

    subtest 'Enable user having name' => sub {
        my $app = _run_app(
            'MT::App::CMS',
            {   __test_user      => $admin,
                __request_method => 'POST',
                __mode           => 'enable_object',
                _type            => 'author',
                action_name      => 'enable',
                return_args =>
                    '__mode=list&_type=author&blog_id=0&does_act=1',
                id => [
                    map { $_->id } MT::Author->load(
                        {   name   => { not => '' },
                            status => MT::Author::INACTIVE
                        }
                    )
                ],
            },
        );
        my $out = delete $app->{__test_output};

        #        ok( $out =~ m/Status: 302 Found/
        #                && $out =~ m/saved_status=enabled/
        #                && $out !~ m/not_enabled=/,
        #            '1 user having name has been enabled.'
        #        );
        ok( $out =~ m/Status: 302 Found/, 'No error occurred.' );

        ok( $out =~ m/saved_status=enabled/, 'Users have been enabled.' );

        # FIXME: Debug code for the above test. This test sometimes fails.
        if ( $out !~ m/saved_status=enabled/ ) {
            warn "\n$out";
        }

        ok( $out !~ m/not_enabled=/,
            'There is no user who has not been enabled.' );
    };
};

subtest 'Batch Edit Entries screen' => sub {
    my $website = MT->model('website')->load;
    MT::Test::Permission->make_entry( blog_id => $website->id );
    my $role = MT::Role->load( { name => 'Site Administrator' } );
    MT::Association->link( $admin, $role, $website );

    foreach my $blog_type (qw( blog website )) {
        my $blog_class = MT->model($blog_type);
        my %blog_terms = ( class => $blog_type );
        my $blog       = $blog_class->load( \%blog_terms );
        foreach my $entry_type (qw( entry page )) {
            my $entry_class = MT->model($entry_type);
            my %entry_terms = ( class => $entry_type, blog_id => $blog->id );
            my $entry       = $entry_class->load( \%entry_terms );
            my $app         = _run_app(
                'MT::App::CMS',
                {   __test_user => $admin,
                    __mode      => 'dialog_select_author',
                    blog_id     => $blog->id,
                    multi       => 0,
                    entry_type  => $entry_type,
                    idfield     => 'entry_author_id_' . $entry->id,
                    namefield   => 'entry_author_name_' . $entry->id,
                    dialog      => 1,
                },
            );
            my $out = delete $app->{__test_output};
            ok( $out !~ m/Sorry, there is no data for this object set\./,
                'There is one or more author. ( blog_type = '
                    . $blog_type
                    . ', entry_type = '
                    . $entry_type . ' )'
            );
        }
    }
};

done_testing;
