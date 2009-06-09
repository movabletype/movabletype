#!/usr/bin/perl

use strict;
use warnings;

use lib 't/lib', 'lib', 'extlib';
use Test::More tests => 5;

BEGIN {
        $ENV{MT_APP} = 'MT::App::CMS';
}

use MT;
use MT::Mail;
use MT::Test qw( :app :db :data );

my $blog = MT::Blog->load(1);
my $user = MT::Author->load(2);

# force email to be sent and see if it shows up in stderr
my $app = MT::App->instance;
my $cfg = $app->config;
$cfg->EmailAddressMain('user@example.com', 1);
$cfg->save_config;


my ($app_to_run, $out);

# test if the email manager shows up
$app_to_run = _run_app(
        'MT::App::CMS',
        { __test_user => $user, __mode => 'cfg_system', to_email_address => 'anotheruser@anotherexample.com' }
);
$out = delete $app_to_run->{__test_output};
ok ($out, "Global template search results are present");
ok ($out =~ /Send email to/i, "Send email to label is present");
ok ($out =~ /Send email to/i, "The email address where you want to send test email to label is present");
ok ($out =~ /Send email to/i, "Send test email button is present");
