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
    my $command = $class->_write_command($args{test_env});
    bless { command => $command }, $class;
}

sub _write_command {
    my ($class, $test_env) = @_;

    my $command = $test_env->save_file('bin/sendmail.pl', <<"SENDMAIL");
#!$^X
use strict;
use warnings;
use Getopt::Long;
GetOptions(\\my \%opts => "from|f", "oi", "t");

my \$mail = do { local \$/; <STDIN> };

print STDERR "MAIL: \$mail\\n" if \$ENV{TEST_VERBOSE};
open my \$fh, '>', "$ENV{MT_TEST_ROOT}/mail";
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
