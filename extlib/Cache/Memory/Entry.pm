=head1 NAME

Cache::Memory::Entry - An entry in the memory based implementation of Cache

=head1 SYNOPSIS

  See 'Cache::Entry' for a synopsis.

=head1 DESCRIPTION

This module implements a version of Cache::Entry for the Cache::Memory variant
of Cache.  It should not be created or used directly, please see
'Cache::Memory' or 'Cache::Entry' instead.

=cut
package Cache::Memory::Entry;

require 5.006;
use strict;
use warnings;
use Cache::Memory;
use Storable;
use Carp;

use base qw(Cache::Entry);
use fields qw(store_entry);

our $VERSION = '2.04';


sub new {
    my Cache::Memory::Entry $self = shift;
    my ($cache, $key, $entry) = @_;

    $self = fields::new($self) unless ref $self;
    $self->SUPER::new($cache, $key);

    $self->{store_entry} = $entry;

    # increment the reference count for the entry
    $entry->{rc}++;

    return $self;
}

sub DESTROY {
    my Cache::Memory::Entry $self = shift;
    
    # drop the reference count and signal the cache if required
    unless (--$self->{store_entry}->{rc}) {
        $self->{cache}->entry_dropped_final_rc($self->{key});
    }
}

sub exists {
    my Cache::Memory::Entry $self = shift;

    # ensure pending expiries are removed
    $self->{cache}->purge();

    return defined $self->{store_entry}->{data};
}

sub _set {
    my Cache::Memory::Entry $self = shift;
    my ($data, $expiry) = @_;

    my $cache = $self->{cache};
    my $key = $self->{key};
    my $entry = $self->{store_entry};

    my $exists = defined $entry->{data};
    my $orig_size;

    unless ($exists) {
        # we're creating the element
        my $time = time();

        $entry->{age_elem} = $cache->add_age_to_heap($key, $time);
        $entry->{use_elem} = $cache->add_use_to_heap($key, $time);
        $orig_size = 0;
    }
    elsif (not exists $entry->{handlelock}) {
        # only remove current size if there is no active handle
        $orig_size = length(${$entry->{data}});
    }
    else {
        $orig_size = 0;
    }

    $entry->{data} = \$data;

    # invalidate any active handles
    delete $entry->{handlelock};

    $self->_set_expiry($expiry) if $expiry or $exists;
    $cache->update_last_used($key) if $exists;

    $cache->change_size(length($data) - $orig_size);
    # ensure pending expiries are removed;
    $cache->purge();
}

sub _get {
    my Cache::Memory::Entry $self = shift;

    $self->exists() or return undef;

    my $entry = $self->{store_entry};

    $entry->{handlelock}
        and warnings::warnif('Cache', 'get called whilst write handle is open');

    $self->{cache}->update_last_used($self->{key});

    return ${$self->{store_entry}->{data}};
}

sub size {
    my Cache::Memory::Entry $self = shift;
    defined $self->{store_entry}->{data}
        or return undef;
    return length(${$self->{store_entry}->{data}});
}

sub remove {
    my Cache::Memory::Entry $self = shift;
    # send remove request directly to cache object
    return $self->{cache}->remove($self->{key});
}

sub expiry {
    my Cache::Memory::Entry $self = shift;
    $self->exists() or return undef;
    my $exp_elem = $self->{store_entry}->{exp_elem}
        or return undef;
    return $exp_elem->val();
}

sub _set_expiry {
    my Cache::Memory::Entry $self = shift;
    my ($time) = @_;

    my $cache = $self->{cache};
    my $entry = $self->{store_entry};

    defined $entry->{data}
        or croak "Cannot set expiry on non-existant entry: $self->{key}";

    my $exp_elem = $entry->{exp_elem};

    if ($exp_elem) {
        $cache->del_expiry_from_heap($self->{key}, $exp_elem);
        $entry->{exp_elem} = undef;
    }

    return unless $time;
    $entry->{exp_elem} = $cache->add_expiry_to_heap($self->{key}, $time);
}

# create a handle.  The entry is 'locked' via the use of a 'handlelock'
# element.  The current data reference is reset to an empty string whilst the
# handle is active to allow set and remove to work correctly without
# corrupting size tracking.  If set or remove are used to change the entry,
# this is detected when the handle is closed again and the size is adjusted
# (downwards) and the original data discarded.
sub _handle {
    my Cache::Memory::Entry $self = shift;
    my ($mode, $expiry) = @_;

    require Cache::IOString;

    my $writing = $mode =~ />|\+/;
    my $entry = $self->{store_entry};

    # set the entry to a empty string if the entry doesn't exist or
    # should be truncated
    if (not defined $entry->{data} or $mode =~ /^\+?>$/) {
        # return undef unless we're writing to the string
        $writing or return undef;
        $self->_set('', $expiry);
    }
    else {
        $self->{cache}->update_last_used($self->{key});
    }

    my $dataref = $entry->{data};

    if ($writing) {
        exists $entry->{handlelock}
            and croak "Write handle already active for this entry";

        my $orig_size = length($$dataref);

        # replace data with empty string whilst handle is active
        $entry->{handlelock} = $dataref;

        return Cache::IOString->new($dataref, $mode,
            sub { $self->_handle_closed(shift, $orig_size); });
    }
    else {
        return Cache::IOString->new($dataref, $mode);
    }
}

sub validity {
    my Cache::Memory::Entry $self = shift;
    $self->exists() or return undef;
    my $validity = $self->{store_entry}->{validity};
    # return a clone of the validity if it's a reference
    return Storable::dclone($validity) if ref($validity);
    return $validity;
}

sub set_validity {
    my Cache::Memory::Entry $self = shift;
    my ($data) = @_;

    my $entry = $self->{store_entry};

    # ensure data is not undefined
    unless (defined $entry->{data}) {
    	$self->set('');
    }

    $entry->{validity} = $data;
}


# UTILITY METHODS

sub _handle_closed {
    my Cache::Memory::Entry $self = shift;
    my ($iostring, $orig_size) = @_;
    $orig_size ||= 0;

    my $dataref = $iostring->sref();
    my $entry = $self->{store_entry};

    # ensure the data hasn't been removed or been replaced
    my $removed = !$self->exists();

    # check our handle marker
    if (defined $entry->{handlelock} and $entry->{handlelock} == $dataref) {
        delete $entry->{handlelock};
    }
    else {
        $removed = 1;
    }

    if ($removed) {
        # remove original size and discard dataref
        $self->{cache}->change_size(-$orig_size) if $orig_size;
        return;
    }

    # reinsert data
    $entry->{data} = $dataref;
    my $new_size = length(${$entry->{data}});
    if ($orig_size != $new_size) {
        $self->{cache}->change_size($new_size - $orig_size);
    }
}


1;
__END__

=head1 SEE ALSO

Cache::Entry, Cache::Memory

=head1 AUTHOR

 Chris Leishman <chris@leishman.org>
 Based on work by DeWitt Clinton <dewitt@unto.net>

=head1 COPYRIGHT

 Copyright (C) 2003-2006 Chris Leishman.  All Rights Reserved.

This module is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND,
either expressed or implied. This program is free software; you can
redistribute or modify it under the same terms as Perl itself.

$Id: Entry.pm,v 1.8 2006/01/31 15:23:58 caleishm Exp $

=cut
