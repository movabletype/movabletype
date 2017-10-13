#!/usr/bin/perl
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

BEGIN {
    eval 'use Net::SMTPS; 1'
        or plan skip_all => 'Net::SMTPS is not installed';
    eval 'use Test::MockModule; 1'
        or plan skip_all => 'Test::MockModule is not installed';
    eval 'use Test::MockObject; 1'
        or plan skip_all => 'Test::MockObject is not installed';
}

use MT;
use MT::Mail;

# mock
my ( $MECH, $SUPPORTS );
my $mock = Test::MockObject->new;
$mock->mock(
    'auth',
    sub {
        $MECH = $_[3];
        0;    # Authentication failure
    }
);
$mock->mock(
    'supports',
    sub {
        $SUPPORTS;
    }
);
$mock->mock(
    'message',
    sub {
        'mocked';
    }
);

my $mock_smtp = Test::MockModule->new('Net::SMTPS');
$mock_smtp->mock( 'new', sub {$mock} );

# initalize mt
my $cfg = MT->instance->config;

$cfg->MailTransfer('smtp');
$cfg->SMTPAuth('starttls');
$cfg->SMTPUser('dummy');
$cfg->SMTPPassword('dummy');

# test
{
    $SUPPORTS = 'DIGEST-MD5 CRAM-MD5';
    _send_mail();
    my @mech = grep {$_} split /\s+/, $MECH;
    is_deeply( \@mech, ['CRAM-MD5'], 'Disable "DIGEST-MD5"' );
}

{
    $SUPPORTS = 'DIGEST-MD5';
    _send_mail();
    my @mech = grep {$_} split /\s+/, $MECH;
    is( scalar @mech, 0, 'Disable "DIGEST-MD5"' );
}

{
    $SUPPORTS = 'DIGEST-MD5 CRAM-MD5';
    $cfg->SMTPAuthSASLMechanism('DIGEST-MD5');
    _send_mail();
    my @mech = grep {$_} split /\s+/, $MECH;
    is_deeply( \@mech, ['DIGEST-MD5'], 'Use SMTPAuthSASLMechanism value' );
}

sub _send_mail {
    my $mail   = 'miuchi@sixapart.com';
    my $header = {
        From    => $mail,
        To      => $mail,
        Subject => 'test mail',
    };
    my $body = 'This is a test mail. Thanks.';

    MT::Mail->send( $header, $body );    # Authentication failure
}

done_testing;

