#!/usr/bin/perl -w

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

use MT::Test;

MT::Test->init_app;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);
$admin->email('test@localhost.localdomain');
$admin->save;

# Run test.
my ($out, $uri);

subtest 'Send recovery email.' => sub {
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
    $out = delete $app->{__test_output};
    like $out => qr/An email with a link to reset your password has been sent/, "email sent";

    like $mail_sent => qr/A request was made to change your Movable Type password./, 'link to reset';
    my ($url) = $mail_sent =~ m!(/cgi-bin/mt.cgi?\S+)!;
    $uri = URI->new($url);
};

subtest 'Recovery failure.' => sub {
    my $app = _run_app(
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

    my ($s, $m, $h, $d, $mo, $y) = gmtime(time);
    my $mod_time = sprintf(
        "%04d%02d%02d%02d%02d%02d",
        1900 + $y, $mo + 1, $d, $h, $m - 1, $s
    );
    $admin->modified_on($mod_time);
    $admin->save();

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

    $admin = MT->model('author')->load(1);
    ok($mod_time ne $admin->modified_on, 'modified_on is updated.');
};

done_testing;
