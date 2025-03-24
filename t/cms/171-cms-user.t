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

use MT;
use MT::Association;
use MT::CMS::User;
use MT::Role;

use MT::Test;
use MT::Test::App;
use MT::Test::Permission;

$test_env->prepare_fixture('db_data');

MT->instance;
my $admin = MT::Author->load(1);

subtest 'Edit Profile screen' => sub {

    my $test = sub {
        my $args = shift;
        my $app  = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode       => 'view',
            _type        => 'author',
            $args->{id} ? (id => $args->{id}) : (),
        });
        $app->post_form_ok({
            name         => $args->{name},
            nickname     => 'nickname',
            email        => 'test@example.com',
            url          => 'http://example.com/',
            api_password => 'secret',
            auth_type    => 'MT',
            is_superuser => 0,
            status       => $args->{status},
            pass         => 'password',
            pass_verify  => 'password',
        });
        my $saved = {};
        if (my $loc = $app->last_location) {
            $saved->{added}   = $loc->query_param('saved') && $loc->query_param('saved_added');
            $saved->{changed} = $loc->query_param('saved') && $loc->query_param('saved_changes');
        }
        return ($app, $saved);
    };

    subtest 'Existing name user' => sub {
        my ($app, $saved) = $test->({
            name   => 'aikawa',
            status => MT::Author::ACTIVE(),
        });
        ok($saved->{added}, 'Created active user.');

        ($app, $saved) = $test->({
            name   => 'aikawa',
            status => MT::Author::ACTIVE(),
        });
        ok(!$saved->{added}, 'Not created active user with other user\'s name.');
        $app->content_like(
            qr/A user with the same name already exists\./,
            'Error message: A user with the same name already exists.'
        );

        ($app, $saved) = $test->({
            name   => 'aikawa',
            status => MT::Author::INACTIVE(),
        });
        ok(!$saved->{added}, 'Not created inactive user with other user\'s name.');
        $app->content_like(
            qr/A user with the same name already exists\./,
            'Error message: A user with the same name already exists.'
        );
    };

    subtest 'Original name user' => sub {
        my ($app, $saved) = $test->({
            name   => 'ichikawa',
            status => MT::Author::ACTIVE(),
        });
        ok($saved->{added}, 'Created active user with original name.');

        ($app, $saved) = $test->({
            name   => 'ukawa',
            status => MT::Author::INACTIVE(),
        });
        ok($saved->{added}, 'Created inactive user with original name.');
        ok(
            MT::Author->exist({ name => 'ukawa', status => MT::Author::INACTIVE }),
            'User "ukawa" whose status is inactive exists.'
        );
    };

    subtest 'Empty name user' => sub {
        plan skip_all => 'Empty names are not supported on oracle' if lc($test_env->driver) eq 'oracle';

        my ($app, $saved) = $test->({
            name   => '',
            status => MT::Author::ACTIVE(),
        });
        ok(!$saved->{added}, 'Not created active user with empty name.');
        $app->content_like(
            qr/User requires username/,
            'Error message: User requires username'
        );

        ($app, $saved) = $test->({
            name   => '',
            status => MT::Author::INACTIVE(),
        });
        ok($saved->{added}, 'Created inactive user with empty name.');

        ($app, $saved) = $test->({
            name   => '',
            status => MT::Author::INACTIVE(),
        });
        ok($saved->{added}, 'Created second inactive user with emtpy name.');

        my $latest_user = MT::Author->load(
            undef,
            { sort => 'created_on', direction => 'descend' });

        ($app, $saved) = $test->({
            name   => '',
            status => MT::Author::INACTIVE(),
            id     => $latest_user->id,
        });
        ok($saved->{changed}, 'Updated inactive user with empty name.');

        ($app, $saved) = $test->({
            name   => '',
            status => MT::Author::ACTIVE(),
            id     => $latest_user->id,
        });
        ok(!$saved->{changed}, 'Not updated active user with empty name.');
        $app->content_like(
            qr/User requires username/,
            'Error message: User requires username.'
        );
    };
};

subtest 'Manage Users screen' => sub {
    subtest 'Check system messages' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list',
            _type   => 'author',
            blog_id => 0,
        });
        my $msg = quotemeta 'the selected user(s) could not be re-enabled because they had some invalid parameter(s). Please check activity log for more details.';
        $app->content_unlike(qr/$msg/, 'There is no system message.');

        $app->get_ok({
            __mode      => 'list',
            _type       => 'author',
            blog_id     => 0,
            not_enabled => 1,
        });
        my $url_activity_log = $app->_app->uri . '?__mode=list&_type=log&blog_id=0';
        $msg = quotemeta "Some (1) of the selected user(s) could not be re-enabled because they had some invalid parameter(s).";
        $app->content_like(qr/$msg/, 'There is a system message: could not be re-enabled one user.');

        $app->get_ok({
            __mode      => 'list',
            _type       => 'author',
            blog_id     => 0,
            not_enabled => 5,
        });
        $msg = quotemeta "Some (5) of the selected user(s) could not be re-enabled because they had some invalid parameter(s).";
        $app->content_like(qr/$msg/, 'There is a system message: could not be re-enabled five user.');
    };

    subtest 'Enable users having no name' => sub {
        plan skip_all => 'Empty names are not supported on oracle' if lc($test_env->driver) eq 'oracle';

        my $no_name_count = MT::Author->count({ name => '', status => MT::Author::INACTIVE });

        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list',
            _type   => 'author',
            blog_id => 0,
        });
        $app->post_list_action_ok({
            __mode      => 'enable_object',
            action_name => 'enable',
            id          => [map { $_->id } MT::Author->load({ name => '', status => MT::Author::INACTIVE })],
        });
        ok(
                !$app->last_location->query_param('saved_status')
                && $app->last_location->query_param('not_enabled') eq $no_name_count,
            "$no_name_count users having no name have not been enabled."
        );
    };

    subtest 'Enable user having name' => sub {
        my $app = MT::Test::App->new('MT::App::CMS');
        $app->login($admin);
        $app->get_ok({
            __mode  => 'list',
            _type   => 'author',
            blog_id => 0,
        });
        $app->post_list_action_ok({
            __mode      => 'enable_object',
            action_name => 'enable',
            id          => [
                map { $_->id } MT::Author->load({
                    name   => { not => '' },
                    status => MT::Author::INACTIVE
                })
            ],
        });
        ok($app->last_location->query_param('saved_status') eq 'enabled', 'Users have been enabled.');

        ok(!$app->last_location->query_param('not_enabled'), 'There is no user who has not been enabled.');
    };
};

subtest 'Batch Edit Entries screen' => sub {
    my $website = MT->model('website')->load;
    MT::Test::Permission->make_entry(blog_id => $website->id);
    my $role = MT::Role->load({ name => MT->translate('Site Administrator') });
    MT::Association->link($admin, $role, $website);

    foreach my $blog_type (qw( blog website )) {
        my $blog_class = MT->model($blog_type);
        my %blog_terms = (class => $blog_type);
        my $blog       = $blog_class->load(\%blog_terms);
        foreach my $entry_type (qw( entry page )) {
            my $entry_class = MT->model($entry_type);
            my %entry_terms = (class => $entry_type, blog_id => $blog->id);
            my $entry       = $entry_class->load(\%entry_terms);
            my $app         = MT::Test::App->new('MT::App::CMS');
            $app->login($admin);
            $app->get_ok({
                __mode     => 'dialog_select_author',
                blog_id    => $blog->id,
                multi      => 0,
                entry_type => $entry_type,
                idfield    => 'entry_author_id_' . $entry->id,
                namefield  => 'entry_author_name_' . $entry->id,
                dialog     => 1,
            });
            $app->content_unlike(
                qr/Sorry, there is no data for this object set\./,
                'There is one or more author. ( blog_type = ' . $blog_type . ', entry_type = ' . $entry_type . ' )'
            );
        }
    }
};

done_testing;
