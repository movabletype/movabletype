package MT::Test::SendmailMock;

use strict;
use warnings;

sub sendmail_config {
    my ($class, %env) = @_;
    return (
        MailTransfer => 'sendmail',
        SendMailPath => 'TEST_ROOT/bin/sendmail.pl',
        %env,
    );
}

sub new {
    my ($class, %args) = @_;
    bless { command => _write_command() }, $class;
}

sub _write_command {

    mkdir($ENV{MT_TEST_ROOT} . '/bin') unless (-d $ENV{MT_TEST_ROOT} . '/bin');
    my $command        = $ENV{MT_TEST_ROOT} . '/bin/sendmail.pl';
    my $last_mail_file = _last_mail_file();

    open my $fh, '>', $command or die "$command: $!";
    print $fh <<"SENDMAIL";
#!$^X
use strict;
use warnings;
use Getopt::Long;
GetOptions(\\my \%opts => "from|f", "oi", "t");

my \$mail = do { local \$/; <STDIN> };

print STDERR "MAIL: \$mail\\n" if \$ENV{TEST_VERBOSE};
open my \$fh, '>', "$last_mail_file";
print \$fh \$mail, "\\n";
SENDMAIL
    chmod 0755, $command;
    return $command;
}

sub last_sent_mail {
    return do { open my $fh, '<', _last_mail_file() or return; local $/; <$fh> }
}

sub _last_mail_file { "$ENV{MT_TEST_ROOT}/mail" }

1;
