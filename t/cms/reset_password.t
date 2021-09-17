#!/usr/bin/perl -w

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
use MT::Test::App;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);
$admin->email('test@localhost.localdomain');
$admin->save;

{
    my $mail_sent;
    no warnings 'redefine';
    local *MT::Mail::_send_mt_debug = sub {
        my ($class, $hdrs, $body, $mgr) = @_;
        $mail_sent = $body;
    };

    my $app = MT::Test::App->new('MT::App::CMS');
    $app->post_ok({
        __mode => 'recover',
        email  => $admin->email,
    });
    $app->content_like(qr/An email with a link to reset your password has been sent/, "email sent");

    like $mail_sent => qr/A request was made to change your Movable Type password./, 'link to reset';
    my ($url) = $mail_sent =~ m!(/cgi-bin/mt.cgi?\S+)!;
    my $uri = URI->new($url);

    $app->post_ok({
        $uri->query_form,
        password       => 'foo',
        password_again => '',
    });
    $app->content_like(qr/Please confirm your new password/, 'no confirmation');

    $app->post_ok({
        $uri->query_form,
        password       => 'foo',
        password_again => 'bar',
    });
    $app->content_like(qr/Passwords do not match/, 'password mismatch');

    $app->post_ok({
        $uri->query_form,
        password       => 'foo',
        password_again => 'foo',
    });
    $app->content_like(qr/Password should be longer than 8 characters/, 'short password error');

    $app->post_ok({
        $uri->query_form,
        password       => '12345678',
        password_again => '12345678',
    });
    like $app->header_title => qr/Sign in/, 'now redirect to sign in';
}

done_testing;
