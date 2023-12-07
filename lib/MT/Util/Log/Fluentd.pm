# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::Util::Log::Fluentd;
use strict;
use warnings;
use MT;
use base qw(MT::Util::Log);
use Fluent::Logger;

sub requires_path { 0 }

sub new {
    my ($self, $logger_level, $log_file) = @_;

    my %opts = %{ MT->config->FluentLoggerOption || {} };
    $opts{tag_prefix} ||= 'mt';

    my $logger = Fluent::Logger->new(%opts);

    return bless { logger => $logger }, $self;
}

sub debug {
    my ($self, $msg) = @_;
    $self->{logger}->post('debug', { message => $msg })
        or do { print STDERR $self->{logger}->errstr . "\n" if $MT::DebugMode };
}

sub info {
    my ($self, $msg) = @_;
    $self->{logger}->post('info', { message => $msg })
        or do { print STDERR $self->{logger}->errstr . "\n" if $MT::DebugMode };
}

sub notice {
    my ($self, $msg) = @_;
    $self->{logger}->post('notice', { message => $msg })
        or do { print STDERR $self->{logger}->errstr . "\n" if $MT::DebugMode };
}

sub warn {
    my ($self, $msg) = @_;
    $self->{logger}->post('warn', { message => $msg })
        or do { print STDERR $self->{logger}->errstr . "\n" if $MT::DebugMode };
}

sub error {
    my ($self, $msg) = @_;
    $self->{logger}->post('error', { message => $msg })
        or do { print STDERR $self->{logger}->errstr . "\n" if $MT::DebugMode };
}

1;
