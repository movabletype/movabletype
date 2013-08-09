#!/usr/bin/perl
use strict;
use warnings;

use lib qw( lib extlib ../lib ../extlib t/lib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT;
use MT::Association;
use MT::CMS::User;
use MT::Role;

use MT::Test qw( :app :db );
use MT::Test::Permission;

use Test::More;

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
            'the selected user(s) could not be re-enabled bacause they had some invalid parameter(s). Please check activity log for more details.';
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
        $msg = quotemeta
            'Some (1) of the selected user(s) could not be re-enabled bacause they had some invalid parameter(s). Please check activity log for more details.';
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
            'Some (5) of the selected user(s) could not be re-enabled bacause they had some invalid parameter(s). Please check activity log for more details.';
        ok( $out =~ m/$msg/,
            'There is a system message: could not be re-enabled five user.' );
    };

    subtest 'Enable users having no name' => sub {
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
                && $out =~ m/not_enabled=2/,
            '2 users having no name have not been enabled.'
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
        ok( $out =~ m/Status: 302 Found/
                && $out =~ m/saved_status=enabled/
                && $out !~ m/not_enabled=/,
            '1 user having name has been enabled.'
        );
    };
};

subtest 'Batch Edit Entries screen' => sub {
    foreach my $blog_type (qw( blog website )) {
        my $blog_class = MT->model($blog_type);
        my %blog_terms = ( class => $blog_type );
        my $blog;
        if ( $blog_class->count( \%blog_terms ) ) {
            $blog = $blog_class->load( \%blog_terms );
        }
        else {
            my $role;
            if ( $blog_type eq 'blog' ) {
                $blog = MT::Test::Permission->make_blog;
                $role = MT::Role->load( { name => 'Blog Administrator' } );
            }
            else {
                $blog = MT::Test::Permission->make_website;
                $role = MT::Role->load( { name => 'Website Administrator' } );
            }
            MT::Association->link( $admin, $role, $blog );
        }
        foreach my $entry_type (qw( entry page )) {
            my $entry_class = MT->model($entry_type);
            my %entry_terms = ( class => $entry_type, blog_id => $blog->id );
            my $entry
                = $entry_class->count( \%entry_terms )
                ? $entry_class->load( \%entry_terms )
                : $entry_type eq 'entry'
                ? MT::Test::Permission->make_entry( blog_id => $blog->id )
                : MT::Test::Permission->make_page( blog_id => $blog->id );
            my $app = _run_app(
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
