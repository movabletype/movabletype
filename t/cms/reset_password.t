#!/usr/bin/perl -w

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib"; # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;

MT::Test->init_app;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);
$admin->email('test@localhost.localdomain');
$admin->save;

{
    my $mail_sent;
    no warnings 'redefine';
    local *MT::Mail::_send_mt_debug = sub {
        my ( $class, $hdrs, $body, $mgr ) = @_;
        $mail_sent = $body;
    };

    my $app = _run_app(
        'MT::App::CMS',
        {
            __mode => 'recover',
            __request_method => 'POST',
            email => $admin->email,
        },
    );
    my $out = delete $app->{__test_output};
    like $out => qr/An email with a link to reset your password has been sent/, "email sent";

    like $mail_sent => qr/A request was made to change your Movable Type password./, 'link to reset';
    my ($url) = $mail_sent =~ m!(/cgi-bin/mt.cgi?\S+)!;
    my $uri = URI->new($url);

    $app = _run_app(
        'MT::App::CMS',
        {
            __request_method => 'POST',
            $uri->query_form,
            password => 'foo',
            password_again => '',
        }
    );
    $out = delete $app->{__test_output};
    like $out => qr/Please confirm your new password/, 'no confirmation';

    $app = _run_app(
        'MT::App::CMS',
        {
            __request_method => 'POST',
            $uri->query_form,
            password => 'foo',
            password_again => 'bar',
        }
    );
    $out = delete $app->{__test_output};
    like $out => qr/Passwords do not match/, 'password mismatch';

    $app = _run_app(
        'MT::App::CMS',
        {
            __request_method => 'POST',
            $uri->query_form,
            password => 'foo',
            password_again => 'foo',
        }
    );
    $out = delete $app->{__test_output};
    like $out => qr/Password should be longer than 8 characters/, 'short password error';

    $app = _run_app(
        'MT::App::CMS',
        {
            __request_method => 'POST',
            $uri->query_form,
            password => '12345678',
            password_again => '12345678',
        }
    );
    $out = delete $app->{__test_output};
    like $out => qr!Location: /cgi-bin/mt.cgi!, 'now redirect to dashboard';
}

done_testing;
