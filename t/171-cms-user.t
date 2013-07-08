#!/usr/bin/perl
use strict;
use warnings;

use lib qw( lib extlib ../lib ../extlib t/lib );

BEGIN {
    $ENV{MT_CONFIG} = 'mysql-test.cfg';
}

use MT;
use MT::CMS::User;
use MT::Test qw( :app :db );
use MT::Test::Permission;
use Test::More;

MT->new;
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
        ok( $out !~ m/saved=1&saved_added=1/, 'Not created active user with other user\'s name.' );
        ok( $out =~ m/A user with the same name already exists\./,
            'Error message: A user with the same name already exists.' );

        $out = $test->(
            {   name   => 'aikawa',
                status => MT::Author::INACTIVE(),
            }
        );
        ok( $out !~ m/saved=1&saved_added=1/, 'Not created inactive user with other user\'s name.' );
        ok( $out =~ m/A user with the same name already exists\./,
            'Error message: A user with the same name already exists.' );
    };

    subtest 'Original name user' => sub {
        my $out = $test->(
            {   name   => 'ichikawa',
                status => MT::Author::ACTIVE(),
            }
        );
        ok( $out =~ m/saved=1&saved_added=1/, 'Created active user with original name.' );

        $test->(
            {   name   => 'ukawa',
                status => MT::Author::INACTIVE(),
            }
        );
        ok( $out =~ m/saved=1&saved_added=1/, 'Created inactive user with original name.' );
    };

    subtest 'Empty name user' => sub {
        my $out = $test->(
            {   name   => '',
                status => MT::Author::ACTIVE(),
            }
        );
        ok( $out !~ m/saved=1&saved_added=1/,  'Not created active user with empty name.' );
        ok( $out =~ m/User requires username/, 'Error message: User requires username' );

        $out = $test->(
            {   name   => '',
                status => MT::Author::INACTIVE(),
            }
        );
        ok( $out =~ m/saved=1&saved_added=1/, 'Created inactive user with empty name.' );

        $out = $test->(
            {   name   => '',
                status => MT::Author::INACTIVE(),
            }
        );
        ok( $out =~ m/saved=1&saved_added=1/, 'Created second inactive user with emtpy name.' );

        my $latest_user = MT::Author->load( undef,
            { sort => 'created_on', direction => 'descend' } );
        $out = $test->(
            {   name   => '',
                status => MT::Author::INACTIVE(),
                id     => $latest_user->id,
            }
        );
        ok( $out =~ m/saved=1&saved_changes=1/, 'Updated inactive user with empty name.' );

        $out = $test->(
            {   name   => '',
                status => MT::Author::ACTIVE(),
                id     => $latest_user->id,
            }
        );
        ok( $out !~ m/saved=1&saved_changes=1/, 'Not updated active user with empty name.' );
        ok( $out =~ m/User requires username/,  'Error message: User requires username.' );

    };
};

done_testing;
