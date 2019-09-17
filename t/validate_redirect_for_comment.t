use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/lib"; # t/lib
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

sub _contains {
    my ( $html, $str ) = @_;
    ok $html =~ /\Q$str\E/, "contains $str";
}

sub _doesnt_contain {
    my ( $html, $str ) = @_;
    ok $html !~ /\Q$str\E/, "doesn't contain $str";
}

sub _bad_url_isnt_exposed {
    my $html = shift;
    ok $html !~ qr/(<(a|form|meta)\s[^>]+$BAD_URL[^>]+>)/s
        or note "BAD_URL is exposed as $1";
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
    is $res->code => 200;
    my $html = $res->decoded_content;
    _contains( $html, 'Confirmation' );
    _contains( $html, 'Your comment has been submitted' );
    _doesnt_contain( $html, 'Comment Submission Error' );
    _doesnt_contain( $html, 'Invalid request' );
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
    my $html = $res->decoded_content;
    _doesnt_contain( $html, 'Confirmation' );
    _doesnt_contain( $html, 'Your comment has been submitted' );
    _contains( $html, 'An error occurred' );
    _contains( $html, 'Invalid request' );
    _bad_url_isnt_exposed($html);

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
    is $res->code => 200;
    my $html = $res->decoded_content;
    _doesnt_contain( $html, 'An error occurred' );
    _doesnt_contain( $html, 'Invalid request' );
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
    is $res->code => 200;
    my $html = $res->decoded_content;
    ## XXX: should be an error?
    _doesnt_contain( $html, 'An error occurred' );
    _doesnt_contain( $html, 'Invalid request' );
    _bad_url_isnt_exposed($html);
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
        }
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _contains( $html, 'http-equiv="refresh"' );    ## redirect
    _doesnt_contain( $html, 'An error occurred' );
    _doesnt_contain( $html, 'Invalid request' );
    _doesnt_contain( $html,
        'You are trying to redirect to external resources' );
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
        }
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _contains( $html, 'An error occurred' );
    _contains( $html, 'You are trying to redirect to external resources' );
    _bad_url_isnt_exposed($html);
};

subtest 'valid signup (get)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->get(
        {   __mode     => 'signup',
            blog_id    => 1,
            return_url => $GOOD_URL,
        }
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _doesnt_contain( $html, 'An error occurred' );
    _doesnt_contain( $html, 'Invalid request' );
};

## BAD_URL wasn't exposed
subtest 'invalid signup (get)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->get(
        {   __mode     => 'signup',
            blog_id    => 1,
            return_url => $BAD_URL,
        }
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    ## XXX: should be an error?
    _doesnt_contain( $html, 'An error occurred' );
    _doesnt_contain( $html, 'Invalid request' );
    _bad_url_isnt_exposed($html);
};

subtest 'valid signup (post)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->post(
        {   __mode        => 'do_signup',
            blog_id       => 1,
            return_url    => $GOOD_URL,
            external_auth => 1,
            username      => 'new commenter',
            nickname      => 'new commenter',
            email         => 'new_commenter@example.com',
            password      => 'Nelson',
            pass_verify   => 'Nelson',
            url           => '',
        }
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _contains( $html, 'Thanks for signing up' );
    _contains( $html, 'To complete the registration process' );
    _doesnt_contain( $html, 'An error occurred' );
    _doesnt_contain( $html, 'Invalid request' );
};

## BAD_URL was exposed in <a>
subtest 'invalid signup (post)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->post(
        {   __mode        => 'do_signup',
            blog_id       => 1,
            return_url    => $BAD_URL,
            external_auth => 1,
            username      => 'new commenter2',
            nickname      => 'new commenter2',
            email         => 'new_commenter2@example.com',
            password      => 'Nelson',
            pass_verify   => 'Nelson',
            url           => '',
        }
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _contains( $html, 'An error occurred' );
    _contains( $html, 'Invalid request' );
    _bad_url_isnt_exposed($html);
};

subtest 'valid start_recover (get)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->get(
        {   __mode     => 'start_recover',
            return_url => $GOOD_URL,
        }
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    _doesnt_contain( $html, 'An error occurred' );
    _doesnt_contain( $html, 'Invalid request' );
};

## BAD_URL wasn't exposed
subtest 'invalid start_recover (get)' => sub {
    my $app = MT::Test::App->new('MT::App::Comments');
    my $res = $app->get(
        {   __mode     => 'start_recover',
            return_url => $BAD_URL,
        }
    );
    is $res->code => 200;
    my $html = $res->decoded_content;
    ## XXX: should be an error?
    ## _contains( $html, 'An error occurred' );
    ## _contains( $html, 'Invalid request' );
    _bad_url_isnt_exposed($html);
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
    is $res->code => 200;
    my $html = $res->decoded_content;
    _contains( $html, 'Your Profile' );
    _doesnt_contain( $html, 'An error occurred' );
    _doesnt_contain( $html, 'Invalid request' );
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
    is $res->code => 200;
    my $html = $res->decoded_content;
    ## XXX: should be an error?
    _doesnt_contain( $html, 'Your Profile' );
    _contains( $html, 'An error occurred' );
    _contains( $html, 'Invalid request' );
    _bad_url_isnt_exposed($html);
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
    is $res->code => 200;
    my $html = $res->decoded_content;
    _contains( $html, 'Your Profile' );
    _contains( $html, 'Commenter profile has successfully been updated.' );
    _doesnt_contain( $html, 'An error occurred' );
    _doesnt_contain( $html, 'Invalid request' );
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
    is $res->code => 200;
    my $html = $res->decoded_content;
    _doesnt_contain( $html, 'Your Profile' );
    _doesnt_contain( $html,
        'Commenter profile has successfully been updated.' );
    _contains( $html, 'An error occurred' );
    _contains( $html, 'Invalid request' );
    _bad_url_isnt_exposed($html);
};

subtest 'valid do_register (get)' => sub {
    my $app   = MT::Test::App->new('MT::App::Comments');
    my $email = 'new_commenter3@example.com';
    my $res   = $app->post(
        {   __mode        => 'do_signup',
            blog_id       => 1,
            return_url    => $GOOD_URL,
            external_auth => 1,
            username      => 'new commenter3',
            nickname      => 'new commenter3',
            email         => $email,
            password      => 'Nelson',
            pass_verify   => 'Nelson',
            url           => '',
        }
    );
    is $res->code => 200;

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
    is $res->code => 200;

    my $html = $res->decoded_content;
    _contains( $html, 'Thanks for the confirmation.' );
    _doesnt_contain( $html, 'An error occurred' );
    _doesnt_contain( $html, 'Invalid request' );
};

subtest 'invalid do_register (get)' => sub {
    my $app   = MT::Test::App->new('MT::App::Comments');
    my $email = 'new_commenter4@example.com';
    my $res   = $app->post(
        {   __mode        => 'do_signup',
            blog_id       => 1,
            return_url    => $GOOD_URL,
            external_auth => 1,
            username      => 'new commenter4',
            nickname      => 'new commenter4',
            email         => $email,
            password      => 'Nelson',
            pass_verify   => 'Nelson',
            url           => '',
        }
    );
    is $res->code => 200;

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
    is $res->code => 200;

    my $html = $res->decoded_content;
    _doesnt_contain( $html, 'Thanks for the confirmation.' );
    _contains( $html, 'An error occurred' );
    _contains( $html, 'Invalid request' );
};

subtest 'valid reply (via dialog_post_comment) from CMS' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($melody);

    my $comment = MT::Comment->load({blog_id => 1});

    my $res = $app->post({
        __mode => 'do_reply',
        reply_to => $comment->id,
        blog_id => 1,
        return_url => $GOOD_URL,
        'comment-reply' => 'my test reply',
    });
    is $res->code => 200;
    my $html = $res->decoded_content;
    ## the following changes window.top.location
    _contains( $html, "jQuery\.fn\.mtDialog\.close('$GOOD_URL')" );
    _doesnt_contain( $html, 'Invalid request' );
};

subtest 'invalid reply (via dialog_post_comment) from CMS' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($melody);

    my $comment = MT::Comment->load({blog_id => 1});

    my $res = $app->post({
        __mode => 'do_reply',
        reply_to => $comment->id,
        blog_id => 1,
        return_url => $BAD_URL,
        'comment-reply' => 'my test reply',
    });
    is $res->code => 200;
    my $html = $res->decoded_content;
    _contains( $html, 'Invalid request' );
    _doesnt_contain( $html, "jQuery\.fn\.mtDialog\.close('$BAD_URL')" );
};

done_testing;
