# Copyright 2002-2006 Appnel Internet Solutions, LLC
# This code is distributed with permission by Six Apart
package MT::Feeds::Lite::CacheMgr;
use strict;

use base qw(MT::ErrorHandler);

use MT::PluginData;

sub new { bless {}, $_[0] }

sub set {
    my ($self, $key, $data) = @_;
    return $self->error('A parameter is missing.')
      unless $key && $data;
    my $pdo = MT::PluginData->load({plugin => ref $self, key => $key});
    unless ($pdo) {
        $pdo = MT::PluginData->new;
        $pdo->plugin(ref $self);
        $pdo->key($key);
    }
    $pdo->data($data);
    $pdo->save or die $pdo->errstr;
}

sub get {
    my ($self, $key) = @_;
    return $self->error('A parameter is missing.') unless $key;
    my $pdo = MT::PluginData->load({plugin => ref $self, key => $key});
    $pdo ? $pdo->data : undef;
}

sub remove {
    my ($self, $key) = @_;
    return $self->error('A parameter is missing.') unless $key;
    my $pdo = MT::PluginData->load({plugin => ref $self, key => $key});
    return unless $pdo;
    $pdo->remove or die $pdo->errstr;
}

sub exists { defined $_[0]->get($_[1]) }

1;
