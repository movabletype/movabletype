#!/usr/bin/perl -w

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
use MT::Test::AnyEventSMTPServer;
our $test_env;
BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
        TrustedHosts    => ['*'],
        MT::Test::AnyEventSMTPServer->smtp_config(),
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test;
use MT::Test::App;

$test_env->prepare_fixture('db');

my $admin = MT::Author->load(1);
$admin->email('test@localhost.localdomain');
$admin->save;

# Run test.
my $uri;
my $server = MT::Test::AnyEventSMTPServer->new;

subtest 'Send recovery email.' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');

    $app->post_ok({
        __mode => 'recover',
        email  => $admin->email,
    });
    $app->content_like(qr/An email with a link to reset your password has been sent/, "email sent");

    my $mail_sent = $server->last_sent_mail;
    like $mail_sent => qr/A request was made to change your Movable Type password./, 'link to reset';
    my ($url) = $mail_sent =~ m!(/cgi-bin/mt.cgi?\S+)!;
    $uri = URI->new($url);
};

subtest 'Recover password.' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');

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

    my ($s, $m, $h, $d, $mo, $y) = gmtime(time);
    my $mod_time = sprintf(
        "%04d%02d%02d%02d%02d%02d",
        1900 + $y, $mo + 1, $d, $h, $m - 1, $s
    );
    $admin->modified_on($mod_time);
    $admin->save();

    $app->post_ok({
        $uri->query_form,
        password       => '12345678',
        password_again => '12345678',
    });
    like $app->header_title => qr/Sign in/, 'now redirect to sign in';

    $admin = MT->model('author')->load(1);
    ok($mod_time ne $admin->modified_on, 'modified_on is updated.');
};

done_testing;
