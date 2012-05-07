# Movable Type (r) Open Source (C) 2005-2012 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package StyleCatcher::Library;
use strict;
use warnings;
use MT;
use base qw( MT::ErrorHandler Class::Accessor::Fast );
use StyleCatcher::Util;

my @KEYS = qw(description_label label order url class);
__PACKAGE__->mk_accessors('key', @KEYS);

sub new {
    my $pkg = shift;
    my ($id) = @_;
    my $reg = MT->registry( stylecatcher_libraries => $id )
        or return;
    my $class = $reg->{class} || 'Default';
    my $inst_class = 'StyleCatcher::Library::' . $class;
    do { eval "require $inst_class"; 1; } or die $@;
    my $obj = bless { key => $id }, $inst_class;
    return $obj->init($reg);
}

sub init {
    my $self = shift;
    my ($reg) = @_;
    @{$self}{@KEYS} = @{$reg}{@KEYS};
    return $self;
}

sub component {
    return MT->component('StyleCatcher');
}

sub translate {
    my $self = shift;
    return $self->component->translate(@_);
}

sub listify {
    my $self = shift;
    my $hash = {
        key               => $self->key,
        url               => $self->url,
        order             => $self->order,
        label             => $self->label,
        description_label => $self->description_label,
    };
    for (qw( label description_label )) {
        $hash->{$_} = $hash->{$_}->()
            if ref $hash->{$_};
    }
    return $hash;
}

sub themes { die "Abstract method!" }
sub theme  { die "Abstract method!" }
sub apply  { die "Abstract method!" }



1;
