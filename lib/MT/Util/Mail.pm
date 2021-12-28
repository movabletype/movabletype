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
    my ($mail_module) = @_;
    $module = undef;
    $mail_module ||= MT->config->MailModule || 'MT::Mail';
    $mail_module = 'MT::Mail::MIME::'. $mail_module if $mail_module !~ /^MT::Mail/;

    eval "require $mail_module;";
    return $module = bless({}, $mail_module) unless $@;

    Carp::carp($@);
    return MT->error(MT->translate('Error loading mail module: [_1].', $mail_module));
}

BEGIN { find_module() }

sub send {
    my ($class, @args) = @_;
    return $module->send(@args) if $module;
    return MT->error(MT->translate('Error loading mail module: [_1].', MT->config->MailModule || 'MT::Mail'));
}

sub errstr {
    my ($class) = @_;
    return $module ? $module->errstr : $class->SUPER::errstr;
}

sub can_use {
    my ($class, @mods) = @_;

    my @err;
    for my $mod (@mods) {
        eval "use $mod;";
        push @err, $mod if $@;
    }

    if (@err) {
        $class->error(MT->translate("Following required module(s) were not found: ([_1])", (join ', ', @err)));
        return;
    }

    return 1;
}

1;
