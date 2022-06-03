# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Util::Mail;
use strict;
use warnings;
use MT;
use base qw( MT::ErrorHandler );
use Carp;
our $Module;

sub find_module {
    my ($mail_module) = @_;
    $Module = undef;
    $mail_module ||= MT->config->MailModule || 'MT::Mail';
    $mail_module = 'MT::Mail::'. $mail_module if $mail_module !~ /^MT::Mail/;

    eval "require $mail_module;";
    return $Module = $mail_module unless $@;

    Carp::carp($@);
    return MT->error(MT->translate('Error loading mail module: [_1].', $mail_module));
}

BEGIN { find_module() }

sub send {
    my ($class, @args) = @_;
    return $Module->send(@args) if $Module;
    return MT->error(MT->translate('Error loading mail module: [_1].', MT->config->MailModule || 'MT::Mail'));
}

sub send_and_log {
    my ($class, $hdrs, $body) = @_;
    my $success = $class->send($hdrs, $body);

    if (!$success && $Module->errstr) {
        MT->instance->log({
            message  => MT->translate('Error sending mail: [_1]', $Module->errstr),
            level    => MT::Log::ERROR(),
            class    => 'system',
            category => 'email'
        });
    }

    if (my $path = MT->config->MailLogPath) {
        my $result = $success ? 'OK' : 'Fail:' . MT->translate('Error sending mail: [_1]', MT::Util::Mail->errstr);
        _write_log($path, $hdrs, $result);
    }
    
    return $success;
}

sub _get_logging_datetime {
    my ($s, $m, $h, $d, $mo, $y) = localtime(time);
    $y += 1900;
    $mo = ('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')[$mo];
    return sprintf("%02d/%s/%04d:%02d:%02d:%02d UTC", $d, $mo, $y, $h, $m, $s);
}

sub _write_log {
    my ($path, $hdrs, $result) = @_;
    my $dest = $hdrs->{To} || $hdrs->{Bcc};
    $dest = $dest->[0] if ref($dest) eq 'ARRAY';
    my $user     = MT->instance->user;
    my $user_str = $user ? sprintf('%s(id:%d)', $user->name, $user->id) : '-';
    open my $LOG, ">>", $path or return MT->error(MT->translate("Failed to open mail log $path"));
    require Fcntl;
    flock($LOG, Fcntl::LOCK_EX());
    print $LOG sprintf(
        "[%s] %s, %s, %s: %s\n",
        _get_logging_datetime(), $user_str, $dest, $hdrs->{Subject}, $result
    );
    close $LOG;
}

sub errstr {
    my ($class) = @_;
    return $Module ? $Module->errstr : $class->SUPER::errstr;
}

1;
