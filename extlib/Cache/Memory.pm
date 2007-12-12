=head1 NAME

Cache::Memory - Memory based implementation of the Cache interface

=head1 SYNOPSIS

  use Cache::Memory;

  my $cache = Cache::Memory->new( namespace => 'MyNamespace',
                                  default_expires => '600 sec' );

See Cache for the usage synopsis.

=head1 DESCRIPTION

The Cache::Memory class implements the Cache interface.  This cache stores
data on a per-process basis.  This is the fastest of the cache
implementations, but is memory intensive and data can not be shared between
processes.  It also does not persist after the process dies.  However data will
remain in the cache until cleared or it expires.  The data will be shared
between instances of the cache object, a cache object going out of scope will
not destroy the data.

=cut
package Cache::Memory;

require 5.006;
use strict;
use warnings;
use Heap::Fibonacci;
use Cache::Memory::HeapElem;
use Cache::Memory::Entry;

use base qw(Cache);
use fields qw(namespace);

our $VERSION = '2.04';


# storage for all data
# data is stored in the form:
#   $Store{ns}{key}{data,exp_elem,age_elem,use_elem,rc,validity,handlelock}
#
# Cache::Memory::Entry elements will be passed the final hash as a reference
# when they are constructed.  This reference MUST point to the SAME hash for
# all entries (and also must be the hash in Store{ns}{key}) or data
# inconsistency will occur.  However this means that the key has to persist in
# the store whilst entries exist - regardless of whether there is data stored
# in it or not.  In order to allow the Store{ns}{key} to be safely removed, a
# 'rc' field is used to track the number of entries that have been created for
# the key.
my %Store;

# store sizes
my %Store_Sizes;

# heaps for all the different orderings
# Expiry_Heap is shared between all namespaces
my Heap $Expiry_Heap = Heap::Fibonacci->new();
# In the form $Age_Heaps{namespace} and $Use_Heaps{namespace}
my %Age_Heaps;
my %Use_Heaps;


my $DEFAULT_NAMESPACE = '_';


=head1 CONSTRUCTOR

  my $cache = Cache::Memory->new( %options )

The constructor takes cache properties as named arguments, for example:

  my $cache = Cache::Memory->new( namespace => 'MyNamespace',
                                  default_expires => '600 sec' );

See 'PROPERTIES' below and in the Cache documentation for a list of all
available properties that can be set.

=cut

sub new {
    my Cache::Memory $self = shift;
    my $args = $#_? { @_ } : shift;

    $self = fields::new($self) unless ref $self;
    $self->SUPER::new($args);

    my $ns = $args->{namespace} || $DEFAULT_NAMESPACE;
    $self->{namespace} = $ns;

    # init heaps
    $Age_Heaps{$ns} ||= Heap::Fibonacci->new();
    $Use_Heaps{$ns} ||= Heap::Fibonacci->new();
    
    return $self;
}

=head1 METHODS

See 'Cache' for the API documentation.

=cut

sub entry {
    my Cache::Memory $self = shift;
    my ($key) = @_;
    my $ns = $self->{namespace};

    $Store{$ns}{$key} ||= {};
    return Cache::Memory::Entry->new($self, $key, $Store{$ns}{$key});
}

sub purge {
    #my Cache::Memory $self = shift;
    my $time = time();
    while (my $minimum = $Expiry_Heap->minimum) {
        $minimum->val() <= $time
            or last;
        $Expiry_Heap->extract_minimum;

        my $min_key = $minimum->key();
        my $min_ns = $minimum->namespace();

        my $store_entry = $Store{$min_ns}{$min_key};

        $minimum == delete $store_entry->{exp_elem}
            or die 'Cache::Memory data structure(s) corrupted';

        # there should always be an age element
        my $age_elem = delete $store_entry->{age_elem}
            or die 'Cache::Memory data structure(s) corrupted';
        $Age_Heaps{$min_ns}->delete($age_elem);

        # there should always be a last use element
        my $use_elem = delete $store_entry->{use_elem}
            or die 'Cache::Memory data structure(s) corrupted';
        $Use_Heaps{$min_ns}->delete($use_elem);

        # remove data & decrease store size
        $Store_Sizes{$min_ns} -= length(${delete $store_entry->{data}});

        # remove entire entry if there are no active Entry objects
        delete $Store{$min_ns}{$min_key} unless $store_entry->{rc};
    }
}

sub clear {
    my Cache::Memory $self = shift;
    my $ns = $self->{namespace};

    # empty store & remove elements from expiry heap
    my $nsstore = $Store{$ns};
    foreach my $key (keys %$nsstore) {
        my $store_entry = $nsstore->{$key};

        # simplified form of remove (doesn't deal with heaps)
        my $exp_elem = delete $store_entry->{exp_elem};
        $Expiry_Heap->delete($exp_elem) if $exp_elem;
        delete $store_entry->{age_elem};
        delete $store_entry->{use_elem};
        delete $store_entry->{data};

        # remove entire entry if there are no active Entry objects
        delete $nsstore->{$key} unless $store_entry->{rc};
    }

    # reset store size
    $Store_Sizes{$ns} = 0;

    # recreate age and used heaps (thus emptying them)
    $Age_Heaps{$ns} = Heap::Fibonacci->new();
    $Use_Heaps{$ns} = Heap::Fibonacci->new();
}

sub count {
    my Cache::Memory $self = shift;
    my $count = 0;
    my $nsstore = $Store{$self->{namespace}};
    foreach my $key (keys %$nsstore) {
        $count++ if defined $nsstore->{$key}->{data};
    }
    return $count;
}

sub size {
    my Cache::Memory $self = shift;
    return $Store_Sizes{$self->{namespace}} || 0;
}


=head1 PROPERTIES

Cache::Memory adds the property 'namespace', which allows you to specify a
different caching store area to use from the default.  All methods will work
ONLY on the namespace specified.

 my $ns = $c->namespace();
 $c->set_namespace( $namespace );

For additional properties, see the 'Cache' documentation.

=cut

sub namespace {
    my Cache::Memory $self = shift;
    return $self->{namespace};
}

sub set_namespace {
    my Cache::Memory $self = shift;
    my ($namespace) = @_;
    $self->{namespace} = $namespace;
}


# REMOVAL STRATEGY METHODS

sub remove_oldest {
    my Cache::Memory $self = shift;
    my $minimum = $Age_Heaps{$self->{namespace}}->minimum
        or return undef;
    $minimum == $Store{$minimum->namespace()}{$minimum->key()}{age_elem}
        or die 'Cache::Memory data structure(s) corrupted';
    return $self->remove($minimum->key());
}

sub remove_stalest {
    my Cache::Memory $self = shift;
    my $minimum = $Use_Heaps{$self->{namespace}}->minimum
        or return undef;
    $minimum == $Store{$minimum->namespace()}{$minimum->key()}{use_elem}
        or die 'Cache::Memory data structure(s) corrupted';
    return $self->remove($minimum->key());
}


# SHORTCUT METHODS

sub remove {
    my Cache::Memory $self = shift;
    my ($key) = @_;

    my $ns = $self->{namespace};

    my $store_entry = $Store{$ns}{$key}
        or return undef;

    defined $store_entry->{data}
        or return undef;

    # remove from heap
    my $exp_elem = delete $store_entry->{exp_elem};
    $Expiry_Heap->delete($exp_elem) if $exp_elem;

    my $age_elem = delete $store_entry->{age_elem}
        or die 'Cache::Memory data structure(s) corrupted';
    $Age_Heaps{$ns}->delete($age_elem);

    my $use_elem = delete $store_entry->{use_elem}
        or die 'Cache::Memory data structure(s) corrupted';
    $Use_Heaps{$ns}->delete($use_elem);

    # reduce size of cache iff there is no active handle
    my $size = 0;
    my $dataref = delete $store_entry->{data};
    unless (exists $store_entry->{handlelock}) {
        $size = length($$dataref);
        $Store_Sizes{$ns} -= $size;
    }

    delete $store_entry->{handlelock};

    # remove entire entry if there are no active Entry objects
    delete $Store{$ns}{$key} unless $store_entry->{rc};

    return $size;
}


# UTILITY METHODS

sub add_expiry_to_heap {
    my Cache::Memory $self = shift;
    my ($key, $time) = @_;

    my $exp_elem = Cache::Memory::HeapElem->new($self->{namespace},$key,$time);
    $Expiry_Heap->add($exp_elem);
    return $exp_elem;
}

sub del_expiry_from_heap {
    my Cache::Memory $self = shift;
    my ($key, $exp_elem) = @_;

    $Expiry_Heap->delete($exp_elem);
}

sub add_age_to_heap {
    my Cache::Memory $self = shift;
    my ($key, $time) = @_;
    my $ns = $self->{namespace};

    my $age_elem = Cache::Memory::HeapElem->new($ns,$key,$time);
    $Age_Heaps{$ns}->add($age_elem);
    return $age_elem;
}

sub add_use_to_heap {
    my Cache::Memory $self = shift;
    my ($key, $time) = @_;
    my $ns = $self->{namespace};

    my $use_elem = Cache::Memory::HeapElem->new($ns,$key,$time);
    $Use_Heaps{$ns}->add($use_elem);
    return $use_elem;
}

sub update_last_used {
    my Cache::Memory $self = shift;
    my ($key) = @_;
    my $ns = $self->{namespace};

    my $use_elem = $Store{$ns}{$key}{use_elem}
        or die 'Cache::Memory data structure(s) corrupted';

    $Use_Heaps{$ns}->delete($use_elem);
    $use_elem->val(time());
    $Use_Heaps{$ns}->add($use_elem);
}

sub change_size {
    my Cache::Memory $self = shift;
    my ($size) = @_;
    my $ns = $self->{namespace};

    $Store_Sizes{$ns} += $size;
    $self->check_size($Store_Sizes{$ns}) if $size > 0;
}

sub entry_dropped_final_rc {
    my Cache::Memory $self = shift;
    my ($key) = @_;
    my $ns = $self->{namespace};

    delete $Store{$ns}{$key} unless defined $Store{$ns}{$key}{data};
}


1;
__END__

=head1 SEE ALSO

Cache

=head1 AUTHOR

 Chris Leishman <chris@leishman.org>
 Based on work by DeWitt Clinton <dewitt@unto.net>

=head1 COPYRIGHT

 Copyright (C) 2003-2006 Chris Leishman.  All Rights Reserved.

This module is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND,
either expressed or implied. This program is free software; you can
redistribute or modify it under the same terms as Perl itself.

$Id: Memory.pm,v 1.9 2006/01/31 15:23:58 caleishm Exp $

=cut
