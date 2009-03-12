# ======================================================================
#
# Copyright (C) 2000 Lincoln D. Stein
# Formatting changed to match the layout layed out in Perl Best Practices
# (by Damian Conway) by Martin Kutter in 2008
#
# ======================================================================

package IO::SessionSet;

use strict;
use Carp;
use IO::Select;
use IO::Handle;
use IO::SessionData;

use vars '$DEBUG';
$DEBUG = 0;

# Class method new()
# Create a new Session set.
# If passed a listening socket, use that to
# accept new IO::SessionData objects automatically.
sub new {
    my $pack = shift;
    my $listen = shift;
    my $self = bless { 
        sessions     => {},
        readers      => IO::Select->new(),
        writers      => IO::Select->new(),
        }, $pack;
    # if initialized with an IO::Handle object (or subclass)
    # then we treat it as a listening socket.
    if ( defined($listen) and $listen->can('accept') ) { 
        $self->{listen_socket} = $listen;
        $self->{readers}->add($listen);
    }
    return $self;
}

# Object method: sessions()
# Return list of all the sessions currently in the set.
sub sessions {
    return values %{shift->{sessions}}
};

# Object method: add()
# Add a handle to the session set.  Will automatically
# create a IO::SessionData wrapper around the handle.
sub add {
    my $self = shift;
    my ($handle,$writeonly) = @_;
    warn "Adding a new session for $handle.\n" if $DEBUG;
    return $self->{sessions}{$handle} = 
        $self->SessionDataClass->new($self,$handle,$writeonly);
}

# Object method: delete()
# Remove a session from the session set.  May pass either a handle or
# a corresponding IO::SessionData wrapper.
sub delete {
    my $self = shift;
    my $thing = shift;
    my $handle = $self->to_handle($thing);
    my $sess = $self->to_session($thing);
    warn "Deleting session $sess handle $handle.\n" if $DEBUG;
    delete $self->{sessions}{$handle};
    $self->{readers}->remove($handle);
    $self->{writers}->remove($handle);
}

# Object method: to_handle()
# Return a handle, given either a handle or a IO::SessionData object.
sub to_handle {
    my $self = shift;
    my $thing = shift;
    return $thing->handle if $thing->isa('IO::SessionData');
    return $thing if defined (fileno $thing);
    return;  # undefined value
}

# Object method: to_session
# Return a IO::SessionData object, given either a handle or the object itself.
sub to_session {
    my $self = shift;
    my $thing = shift;
    return $thing if $thing->isa('IO::SessionData');
    return $self->{sessions}{$thing} if defined (fileno $thing);
    return;  # undefined value
}

# Object method: activate()
# Called with parameters ($session,'read'|'write' [,$activate])
# If called without the $activate argument, will return true
# if the indicated handle is on the read or write IO::Select set.
# May use either a session object or a handle as first argument.
sub activate {
    my $self = shift;
    my ($thing,$rw,$act) = @_;
    croak 'Usage $obj->activate($session,"read"|"write" [,$activate])'
        unless @_ >= 2;
    my $handle = $self->to_handle($thing);
    my $select = lc($rw) eq 'read' ? 'readers' : 'writers';
    my $prior = defined $self->{$select}->exists($handle);
    if (defined $act && $act != $prior) {
        $self->{$select}->add($handle)        if $act;
        $self->{$select}->remove($handle) unless $act;
        warn $act ? 'Activating' : 'Inactivating',
            " handle $handle for ",
            $rw eq 'read' ? 'reading':'writing',".\n" if $DEBUG;
    }
    return $prior;
}

# Object method: wait()
# Wait for I/O.  Handles writes automatically.  Returns a list of 
# IO::SessionData objects ready for reading.  
# If there is a listen socket, then will automatically do an accept()
# and return a new IO::SessionData object for that.
sub wait {
    my $self = shift;
    my $timeout = shift;

    # Call select() to get the list of sessions that are ready for 
    # reading/writing.
    warn "IO::Select->select() returned error: $!"
        unless my ($read,$write) = 
            IO::Select->select($self->{readers},$self->{writers},undef,$timeout);

    # handle queued writes automatically
    foreach (@$write) {
        my $session = $self->to_session($_);
        warn "Writing pending data (",$session->pending+0," bytes) for $_.\n" 
            if $DEBUG;
        my $rc = $session->write;
    }

    # Return list of sessions that are ready for reading.
    # If one of the ready handles is the listen socket, then
    # create a new session.
    # Otherwise return the ready handles as a list of IO::SessionData objects.
    my @sessions;
    foreach (@$read) {
        if ($_ eq $self->{listen_socket}) {
            my $newhandle = $_->accept;
            warn "Accepting a new handle $newhandle.\n" if $DEBUG;
            my $newsess = $self->add($newhandle) if $newhandle;
            push @sessions,$newsess;
        }
        else {
            push @sessions,$self->to_session($_);
        }
    }
    return @sessions;
}

# Class method: SessionDataClass
# Return the string containing the name of the session data
# wrapper class.  Subclass and override to use a different
# session data class.
sub SessionDataClass {  return 'IO::SessionData'; }

1;
