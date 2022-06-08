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
    my ($class, $hdrs, $body) = @_;

    unless ($Module) {
        return MT->error(MT->translate('Error loading mail module: [_1].', MT->config->MailModule || 'MT::Mail'));
    }

    if ($Module eq 'MT::Mail' && ref($body)) {
        return $class->error(MT->translate(q{MT::Mail doesn't support file attachments. Please change MailModule setting.}));
    }

    return $Module->send($hdrs, $body);
}

sub errstr {
    my ($class) = @_;
    return $Module ? $Module->errstr : $class->SUPER::errstr;
}

1;
