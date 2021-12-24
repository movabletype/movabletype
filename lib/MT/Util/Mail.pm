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
our $module;

sub find_module {
    my ($mail_class) = @_;
    $mail_class ||= MT->config->MailClass || 'MT::Mail';

    eval "require $mail_class;";
    return $module = $mail_class unless $@;

    Carp::croak($@);
    return MT->error(MT->translate('Error loading mail class: [_1].', $mail_class));
}

BEGIN { find_module() }

sub send {
    my ($class, @args) = @_;
    return $module->send(@args);
}

sub errstr {
    my ($class) = @_;
    return $module ? $module->errstr : $class->SUPER::errstr;
}

sub can_use {
    my ($class, @mods) = @_;

    my @err;
    for my $module (@mods) {
        eval "use $module;";
        push @err, $module if $@;
    }

    if (@err) {
        $class->error(MT->translate("Following required module(s) were not found: ([_1])", (join ', ', @err)));
        return;
    }

    return 1;
}

sub can_use_smtp         { $_[0]->can_use('Net::SMTPS', 'MIME::Base64') }
sub can_use_smtpauth     { $_[0]->can_use_smtp     && $_[0]->can_use('Authen::SASL') }
sub can_use_smtpauth_ssl { $_[0]->can_use_smtpauth && $_[0]->can_use('IO::Socket::SSL', 'Net::SSLeay') }
sub can_use_smtpauth_tls { $_[0]->can_use_smtpauth_ssl }

1;
