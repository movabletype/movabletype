# ======================================================================
#
# Copyright (C) 2000 Lincoln D. Stein
# Slightly modified by Paul Kulchenko to work on multiple platforms
#
# ======================================================================

package IO::SessionData;

use strict;
use Carp;
use IO::SessionSet;
use vars '$VERSION';
$VERSION = 1.02;

use constant BUFSIZE => 3000;

BEGIN {
  my @names = qw(EWOULDBLOCK EAGAIN EINPROGRESS);
  my %WOULDBLOCK = 
    (eval {require Errno} ? map {Errno->can($_)->() => 1} grep {Errno->can($_)} @names : ()),
    (eval {require POSIX} ? map {POSIX->can($_)->() => 1} grep {POSIX->can($_)} @names : ());

  sub WOULDBLOCK { $WOULDBLOCK{$_[0]+0} }
}

# Class method: new()
# Create a new IO::SessionData object.  Intended to be called from within
# IO::SessionSet, not directly.
sub new {
  my $pack = shift;
  my ($sset,$handle,$writeonly) = @_;
  # make the handle nonblocking (but check for 'blocking' method first)
  # thanks to Jos Clijmans <jos.clijmans@recyfin.be>
  $handle->blocking(0) if $handle->can('blocking');
  my $self = bless {
                outbuffer   => '',
                sset        => $sset,
                handle      => $handle,
                write_limit => BUFSIZE,
                writeonly   => $writeonly,
                choker      => undef,
                choked      => 0,
               },$pack;
  $self->readable(1) unless $writeonly;
  return $self;
}

# Object method: handle()
# Return the IO::Handle object corresponding to this IO::SessionData
sub handle   { return shift->{handle}   }

# Object method: sessions()
# Return the IO::SessionSet controlling this object.
sub sessions { return shift->{sset} }

# Object method: pending()
# returns number of bytes pending in the out buffer
sub pending { return length shift->{outbuffer} }

# Object method: write_limit([$bufsize])
# Get or set the limit on the size of the write buffer.
# Write buffer will grow to this size plus whatever extra you write to it.
sub write_limit { 
  my $self = shift;
  return defined $_[0] ? $self->{write_limit} = $_[0] 
                       : $self->{write_limit};
}

# set a callback to be called when the contents of the write buffer becomes larger
# than the set limit.
sub set_choke {
  my $self = shift;
  return defined $_[0] ? $self->{choker} = $_[0] 
                       : $self->{choker};
}

# Object method: write($scalar)
# $obj->write([$data]) -- append data to buffer and try to write to handle
# Returns number of bytes written, or 0E0 (zero but true) if data queued but not
# written. On other errors, returns undef.
sub write {
  my $self = shift;
  return unless my $handle = $self->handle; # no handle
  return unless defined $self->{outbuffer}; # no buffer for queued data

  $self->{outbuffer} .= $_[0] if defined $_[0];

  my $rc;
  if ($self->pending) { # data in the out buffer to write
    local $SIG{PIPE}='IGNORE';
    # added length() to make it work on Mac. Thanks to Robin Fuller <rfuller@broadjump.com>
    $rc = syswrite($handle,$self->{outbuffer},length($self->{outbuffer}));

    # able to write, so truncate out buffer apropriately
    if ($rc) {
      substr($self->{outbuffer},0,$rc) = '';
    } elsif (WOULDBLOCK($!)) {  # this is OK
      $rc = '0E0';
    } else { # some sort of write error, such as a PIPE error
      return $self->bail_out($!);
    }
  } else {
    $rc = '0E0';   # nothing to do, but no error either
  }
  
  $self->adjust_state;
  
  # Result code is the number of bytes successfully transmitted
  return $rc;
}

# Object method: read($scalar,$length [,$offset])
# Just like sysread(), but returns the number of bytes read on success,
# 0EO ("0 but true") if the read would block, and undef on EOF and other failures.
sub read {
  my $self = shift;
  return unless my $handle = $self->handle;
  my $rc = sysread($handle,$_[0],$_[1],$_[2]||0);
  return $rc if defined $rc;
  return '0E0' if WOULDBLOCK($!);
  return;
}

# Object method: close()
# Close the session and remove it from the monitored list.
sub close {
  my $self = shift;
  unless ($self->pending) {
    $self->sessions->delete($self);
    CORE::close($self->handle);
  } else {
    $self->readable(0);
    $self->{closing}++;  # delayed close
    }
}

# Object method: adjust_state()
# Called periodically from within write() to control the
# status of the handle on the IO::SessionSet's IO::Select sets
sub adjust_state {
  my $self = shift;

  # make writable if there's anything in the out buffer
  $self->writable($self->pending > 0);

  # make readable if there's no write limit, or the amount in the out
  # buffer is less than the write limit.
  $self->choke($self->write_limit <= $self->pending) if $self->write_limit;

  # Try to close down the session if it is flagged
  # as in the closing state.
  $self->close if $self->{closing};
}

# choke gets called when the contents of the write buffer are larger
# than the limit.  The default action is to inactivate the session for further
# reading until the situation is cleared.
sub choke {
  my $self = shift;
  my $do_choke = shift;
  return if $self->{choked} == $do_choke;  # no change in state
  if (ref $self->set_choke eq 'CODE') {
    $self->set_choke->($self,$do_choke);
  } else {
    $self->readable(!$do_choke);
  }
  $self->{choked} = $do_choke;
}

# Object method: readable($flag)
# Flag the associated IO::SessionSet that we want to do reading on the handle.
sub readable {
  my $self = shift;
  my $is_active = shift;
  return if $self->{writeonly};
  $self->sessions->activate($self,'read',$is_active);
}

# Object method: writable($flag)
# Flag the associated IO::SessionSet that we want to do writing on the handle.
sub writable {
  my $self = shift;
  my $is_active = shift;
  $self->sessions->activate($self,'write',$is_active);
}

# Object method: bail_out([$errcode])
# Called when an error is encountered during writing (such as a PIPE).
# Default behavior is to flush all buffered outgoing data and to close
# the handle.
sub bail_out {
  my $self = shift;
  my $errcode = shift;           # save errorno
  delete $self->{outbuffer};     # drop buffered data
  $self->close;
  $! = $errcode;                 # restore errno
  return;
}

1;
