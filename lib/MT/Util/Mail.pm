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

1;
