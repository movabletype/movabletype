use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    eval { require Test::MockModule }
        or plan skip_all => 'Test::MockModule is not installed';

    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::App;
use MT::Test::Permission;

$test_env->prepare_fixture('db_data');

my $GOOD_URL = 'http://narnia.na/index.html';
my $BAD_URL  = 'http://foo/index.html';

my $blog = MT::Blog->load(1);
$blog->commenter_authenticators('MovableType');
$blog->save;

my $melody = MT::Author->load(1);
$melody->name('Melody');
$melody->nickname('Melody');
$melody->email('melody@localhost.localdomain');
$melody->set_password('Nelson');
$melody->save;

sub _new_commenter {
    MT::Test::Permission->make_author(@_);
}

sub _login_as_commenter {
    my ( $app, $user ) = @_;

    $app->login($user);

    my $session = MT::App::make_session($user);
    $app->{session} = $session->id;

    my $mock = Test::MockModule->new('MT::App');
    $mock->redefine(
        'get_commenter_session',
        sub {
            my $mt = shift;
            return ( $mt->session, $user );
        }
    );
    $mock;
}

subtest 'valid post' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');

    my $guard = _login_as_commenter( $app, $melody );

    my $res = $app->post(
        {   __mode   => 'post',
            blog_id  => 1,
            static   => $GOOD_URL,
            entry_id => 1,
            __lang   => 'en-us',
            sid      => $app->{session},
            text     => 'Comment Text',
        }
    );
    $app->status_is(200);
    $app->content_like('Confirmation');
    $app->content_like('Your comment has been submitted');
    $app->content_unlike('Comment Submission Error');
    $app->content_unlike('Invalid request');
};

## BAD_URL wasn't exposed in <a> if $blog is configured to use confirmation;
## otherwise, it was used to redirect
subtest 'invalid post' => sub {
    my $app = MT::Test::App->new(
        app_class   => 'MT::App::Comments',
        no_redirect => 1,
    );

    my $guard = _login_as_commenter( $app, $melody );

    ## to force redirection
    my $blog = MT::Blog->load(1);
    $blog->use_comment_confirmation(0);
    $blog->save;

    my $res = $app->post(
        {   __mode   => 'post',
            blog_id  => 1,
            static   => $BAD_URL,
            entry_id => 1,
            __lang   => 'en-us',
            sid      => $app->{session},
            text     => 'Comment Text',
        }
    );
    is $res->code                          => 200;
    isnt $res->headers->header('Location') => $BAD_URL;
    $app->content_unlike('Confirmation');
    $app->content_unlike('Your comment has been submitted');
    $app->content_like('An error occurred');
    $app->content_like('Invalid request');
    $app->content_doesnt_expose($BAD_URL);

    ## restore configuration
    $blog->use_comment_confirmation(1);
    $blog->save;
};

subtest 'valid login_form (get)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->get(
        {   __mode     => 'login',
            blog_id    => 1,
            return_url => $GOOD_URL,
        }
    );
    $app->status_is(200);
    $app->content_unlike('An error occurred');
    $app->content_unlike('Invalid request');
};

## BAD_URL wasn't exposed
subtest 'invalid login_form (get)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->get(
        {   __mode     => 'login',
            blog_id    => 1,
            return_url => $BAD_URL,
        }
    );
    $app->status_is(200);
    ## XXX: should be an error?
    $app->content_unlike('An error occurred');
    $app->content_unlike('Invalid request');
    $app->content_doesnt_expose($BAD_URL);
};

subtest 'valid login_form (post)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->post(
        {   __mode        => 'do_login',
            blog_id       => 1,
            return_url    => $GOOD_URL,
            external_auth => 1,
            username      => 'Melody',
            password      => 'Nelson',
            remember      => 1,
            entry_id      => '',
            static        => '',
        }
    );
    $app->status_is(200);
    $app->content_like('http-equiv="refresh"');    ## redirect
    $app->content_unlike('An error occurred');
    $app->content_unlike('Invalid request');
    $app->content_unlike('You are trying to redirect to external resources');
};

## BAD_URL was exposed in an error message, but it was not clickable
## (opposed to the message: "please click the link")
subtest 'invalid login_form (post)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->post(
        {   __mode        => 'do_login',
            blog_id       => 1,
            return_url    => $BAD_URL,
            external_auth => 1,
            username      => 'Melody',
            password      => 'Nelson',
            remember      => 1,
            entry_id      => '',
            static        => '',
        }
    );
    $app->status_is(200);
    $app->content_like('An error occurred');
    $app->content_like('You are trying to redirect to external resources');
    $app->content_doesnt_expose($BAD_URL);
};

subtest 'valid signup (get)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->get(
        {   __mode     => 'signup',
            blog_id    => 1,
            entry_id   => '',
            return_url => $GOOD_URL,
        }
    );
    $app->status_is(200);
    $app->content_unlike('An error occurred');
    $app->content_unlike('Invalid request');
};

## BAD_URL wasn't exposed
subtest 'invalid signup (get)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->get(
        {   __mode     => 'signup',
            blog_id    => 1,
            entry_id   => '',
            return_url => $BAD_URL,
        }
    );
    $app->status_is(200);
    ## XXX: should be an error?
    $app->content_unlike('An error occurred');
    $app->content_unlike('Invalid request');
    $app->content_doesnt_expose($BAD_URL);
};

subtest 'valid signup (post)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->post(
        {   __mode        => 'do_signup',
            blog_id       => 1,
            return_url    => $GOOD_URL,
            username      => 'new commenter',
            nickname      => 'new commenter',
            email         => 'new_commenter@example.com',
            password      => 'Nelson',
            pass_verify   => 'Nelson',
            url           => '',
            entry_id      => '',
            static        => '',
        }
    );
    $app->status_is(200);
    $app->content_like('Thanks for signing up');
    $app->content_like('To complete the registration process');
    $app->content_unlike('An error occurred');
    $app->content_unlike('Invalid request');
};

## BAD_URL was exposed in <a>
subtest 'invalid signup (post)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->post(
        {   __mode        => 'do_signup',
            blog_id       => 1,
            return_url    => $BAD_URL,
            username      => 'new commenter2',
            nickname      => 'new commenter2',
            email         => 'new_commenter2@example.com',
            password      => 'Nelson',
            pass_verify   => 'Nelson',
            url           => '',
            entry_id      => '',
            static        => '',
        }
    );
    $app->status_is(200);
    $app->content_like('An error occurred');
    $app->content_like('Invalid request');
    $app->content_doesnt_expose($BAD_URL);
};

subtest 'valid signout (get, static = 0)' => sub {
    my $app = MT::Test::App->new(
        app_class   => 'MT::App::Comments',
        no_redirect => 1,
    );

    my $guard = _login_as_commenter( $app, $melody );

    my $res = $app->get(
        {   __mode     => 'handle_sign_in',
            blog_id    => 1,
            return_url => $GOOD_URL,
            logout     => 1,
            static     => 0,
        }
    );
    $app->status_is(200);
    $app->content_like('<meta http-equiv="refresh"');
    $app->content_like($GOOD_URL);
    $app->content_unlike('An error occurred');
    $app->content_unlike('Invalid request');
};

subtest 'invalid signout (get, static = 0)' => sub {
    my $app = MT::Test::App->new(
        app_class   => 'MT::App::Comments',
        no_redirect => 1,
    );

    my $guard = _login_as_commenter( $app, $melody );

    my $res = $app->get(
        {   __mode     => 'handle_sign_in',
            blog_id    => 1,
            return_url => $BAD_URL,
            logout     => 1,
            static     => 0,
        }
    );
    $app->status_is(200);
    $app->content_like('An error occurred');
    $app->content_like('You are trying to redirect to external resources');
    $app->content_doesnt_expose($BAD_URL);
};

subtest 'valid signout (get, static = 1)' => sub {
    my $app = MT::Test::App->new(
        app_class   => 'MT::App::Comments',
        no_redirect => 1,
    );

    my $guard = _login_as_commenter( $app, $melody );

    my $entry     = MT::Entry->load(1);
    my $entry_url = $entry->archive_url;

    my $res = $app->get(
        {   __mode     => 'handle_sign_in',
            blog_id    => 1,
            return_url => $GOOD_URL,
            logout     => 1,
            static     => 1,
            entry_id   => 1,
        }
    );
    $app->status_is(200);
    $app->content_like('<meta http-equiv="refresh"');
    $app->content_like($entry_url);
    $app->content_unlike($GOOD_URL);
    $app->content_unlike('An error occurred');
    $app->content_unlike('Invalid request');
};

subtest 'invalid signout (get, static = 1)' => sub {
    my $app = MT::Test::App->new(
        app_class   => 'MT::App::Comments',
        no_redirect => 1,
    );

    my $guard = _login_as_commenter( $app, $melody );

    my $entry     = MT::Entry->load(1);
    my $entry_url = $entry->archive_url;

    my $res = $app->get(
        {   __mode     => 'handle_sign_in',
            blog_id    => 1,
            return_url => $BAD_URL,
            logout     => 1,
            static     => 1,
            entry_id   => 1,
        }
    );
    $app->status_is(200);
    $app->content_like('<meta http-equiv="refresh"');
    $app->content_like($entry_url);
    $app->content_unlike('An error occurred');
    $app->content_doesnt_expose($BAD_URL);
};

subtest 'valid start_recover (get)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->get(
        {   __mode     => 'start_recover',
            return_url => $GOOD_URL,
        }
    );
    $app->status_is(200);
    $app->content_unlike('An error occurred');
    $app->content_unlike('Invalid request');
};

## BAD_URL wasn't exposed
subtest 'invalid start_recover (get)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->get(
        {   __mode     => 'start_recover',
            return_url => $BAD_URL,
        }
    );
    $app->status_is(200);
    ## XXX: should be an error?
    ## $app->content_like( 'An error occurred' );
    ## $app->content_like( 'Invalid request' );
    $app->content_doesnt_expose($BAD_URL);
};

subtest 'valid edit_profile (get)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');

    my $guard = _login_as_commenter( $app, $melody );

    my $res = $app->get(
        {   __mode     => 'edit_profile',
            blog_id    => 1,
            return_url => $GOOD_URL,
        }
    );
    $app->status_is(200);
    $app->content_like('Your Profile');
    $app->content_unlike('An error occurred');
    $app->content_unlike('Invalid request');
};

## BAD_URL was exposed in <a>
subtest 'invalid edit_profile (get)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');

    my $guard = _login_as_commenter( $app, $melody );

    my $res = $app->get(
        {   __mode     => 'edit_profile',
            blog_id    => 1,
            return_url => $BAD_URL,
        }
    );
    $app->status_is(200);
    ## XXX: should be an error?
    $app->content_unlike('Your Profile');
    $app->content_like('An error occurred');
    $app->content_like('Invalid request');
    $app->content_doesnt_expose($BAD_URL);
};

subtest 'valid save_profile (post)' => sub {
    my $app       = MT::Test::App->new('MT::App::Comments');
    my $commenter = _new_commenter( email => 'commenter1@example.com' );

    my $guard = _login_as_commenter( $app, $commenter );

    my $res = $app->post(
        {   __mode      => 'save_profile',
            blog_id     => 1,
            return_url  => $GOOD_URL,
            name        => $commenter->name,
            nickname    => $commenter->nickname,
            email       => $commenter->email,
            old_pass    => 'pass',
            password    => 'longer password',
            pass_verify => 'longer password',
            url         => '',
        }
    );
    $app->status_is(200);
    $app->content_like('Your Profile');
    $app->content_like('Commenter profile has successfully been updated.');
    $app->content_unlike('An error occurred');
    $app->content_unlike('Invalid request');
};

## BAD_URL was exposed in <a>
subtest 'invalid save_profile (post)' => sub {
    my $app       = MT::Test::App->new('MT::App::Comments');
    my $commenter = _new_commenter( email => 'commenter2@example.com' );

    my $guard = _login_as_commenter( $app, $commenter );

    my $res = $app->post(
        {   __mode      => 'save_profile',
            blog_id     => 1,
            return_url  => $BAD_URL,
            name        => $commenter->name,
            nickname    => $commenter->nickname,
            email       => $commenter->email,
            old_pass    => 'pass',
            password    => 'longer password',
            pass_verify => 'longer password',
            url         => '',
        }
    );
    $app->status_is(200);
    $app->content_unlike('Your Profile');
    $app->content_unlike('Commenter profile has successfully been updated.');
    $app->content_like('An error occurred');
    $app->content_like('Invalid request');
    $app->content_doesnt_expose($BAD_URL);
};

subtest 'valid do_register (get)' => sub {
    my $app   = MT::Test::App->new('MT::App::Comments');
    my $email = 'new_commenter3@example.com';
    my $res   = $app->post(
        {   __mode        => 'do_signup',
            blog_id       => 1,
            return_url    => $GOOD_URL,
            username      => 'new commenter3',
            nickname      => 'new commenter3',
            email         => $email,
            password      => 'Nelson',
            pass_verify   => 'Nelson',
            url           => '',
            entry_id      => '',
            static        => '',
        }
    );
    $app->status_is(200);

    ok my $session = MT::Session->load(
        {   kind  => 'CR',
            email => $email,
        }
    ) or return;

    $res = $app->get(
        {   __mode  => 'do_register',
            blog_id => 1,
            email   => $email,
            token   => $session->id,
            static  => $GOOD_URL,
        }
    );
    $app->status_is(200);
    $app->content_like('Thanks for the confirmation.');
    $app->content_unlike('An error occurred');
    $app->content_unlike('Invalid request');
};

subtest 'invalid do_register (get)' => sub {
    my $app   = MT::Test::App->new('MT::App::Comments');
    my $email = 'new_commenter4@example.com';
    my $res   = $app->post(
        {   __mode        => 'do_signup',
            blog_id       => 1,
            return_url    => $GOOD_URL,
            username      => 'new commenter4',
            nickname      => 'new commenter4',
            email         => $email,
            password      => 'Nelson',
            pass_verify   => 'Nelson',
            url           => '',
            entry_id      => '',
            static        => '',
        }
    );
    $app->status_is(200);

    ok my $session = MT::Session->load(
        {   kind  => 'CR',
            email => $email,
        }
    ) or return;

    $res = $app->get(
        {   __mode  => 'do_register',
            blog_id => 1,
            email   => $email,
            token   => $session->id,
            static  => $BAD_URL,
        }
    );
    $app->status_is(200);
    $app->content_unlike('Thanks for the confirmation.');
    $app->content_like('An error occurred');
    $app->content_like('Invalid request');
};

subtest 'valid reply (via dialog_post_comment) from CMS' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($melody);

    my $comment = MT::Comment->load( { blog_id => 1 } );

    my $res = $app->post(
        {   __mode          => 'do_reply',
            reply_to        => $comment->id,
            blog_id         => 1,
            return_url      => $GOOD_URL,
            'comment-reply' => 'my test reply',
        }
    );
    $app->status_is(200);
    ## the following changes window.top.location
    $app->content_like("jQuery\.fn\.mtDialog\.close('$GOOD_URL')");
    $app->content_unlike('Invalid request');
};

subtest 'invalid reply (via dialog_post_comment) from CMS' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($melody);

    my $comment = MT::Comment->load( { blog_id => 1 } );

    my $res = $app->post(
        {   __mode          => 'do_reply',
            reply_to        => $comment->id,
            blog_id         => 1,
            return_url      => $BAD_URL,
            'comment-reply' => 'my test reply',
        }
    );
    $app->status_is(200);
    $app->content_like('Invalid request');
    $app->content_unlike("jQuery\.fn\.mtDialog\.close('$BAD_URL')");
};

done_testing;
