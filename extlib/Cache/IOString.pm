=head1 NAME

Cache::IOString - wrapper for IO::String to use in Cache implementations

=head1 DESCRIPTION

This module implements a derived class of IO::String that handles access 
modes and allows callback on close.  It is for use by Cache implementations
and should not be used directly.

=cut
package Cache::IOString;

require 5.006;
use strict;
use warnings;
use IO::String;

our @ISA = qw(IO::String);


sub open {
    my $self = shift;
    my ($dataref, $mode, $close_callback) = @_;
    return $self->new(@_) unless ref($self);

    # check mode
    my $read;
    my $write;
    if ($mode =~ /^\+?>>?$/) {
        $write = 1;
        $read = 1 if $mode =~ /^\+/;
    }
    elsif ($mode =~ /^\+?<$/) {
        $read = 1;
        $write = 1 if $mode =~ /^\+/;
    }

    $self->SUPER::open($dataref);

    *$self->{_cache_read} = $read;
    *$self->{_cache_write} = $write;
    *$self->{_cache_close_callback} = $close_callback;

    if ($write) {
        if ($mode =~ /^\+?>>$/) {
            # append
            $self->seek(0, 2);
        }
        elsif ($mode =~ /^\+?>$/) {
            # truncate
            $self->truncate(0);
        }
    }

    return $self;
}

sub close {
    my $self = shift;
    delete *$self->{_cache_read};
    delete *$self->{_cache_write};
    *$self->{_cache_close_callback}->($self) if *$self->{_cache_close_callback};
    delete *$self->{_cache_close_callback};
    $self->SUPER::close(@_);
}

sub DESTROY {
    my $self = shift;
    *$self->{_cache_close_callback}->($self) if *$self->{_cache_close_callback};
}

sub pad {
    my $self = shift;
    return undef unless *$self->{_cache_write};
    return $self->SUPER::pad(@_);
}

sub getc {
    my $self = shift;
    return undef unless *$self->{_cache_read};
    return $self->SUPER::getc(@_);
}

sub ungetc {
    my $self = shift;
    return undef unless *$self->{_cache_read};
    return $self->SUPER::ungetc(@_);
}

sub seek {
    my $self = shift;
    # call setpos if not writing to ensure a seek past the end doesn't extend
    # the string.  Probably should really return undef in that situation.
    return $self->SUPER::setpos(@_) unless *$self->{_cache_write};
    return $self->SUPER::seek(@_);
}

sub getline {
    my $self = shift;
    return undef unless *$self->{_cache_read};
    return $self->SUPER::getline(@_);
}

sub truncate {
    my $self = shift;
    return undef unless *$self->{_cache_write};
    return $self->SUPER::truncate(@_);
}

sub read {
    my $self = shift;
    return undef unless *$self->{_cache_read};
    return $self->SUPER::read(@_);
}

sub write {
    my $self = shift;
    return undef unless *$self->{_cache_write};
    return $self->SUPER::write(@_);
}

*GETC = \&getc;
*READ = \&read;
*WRITE = \&write;
*SEEK = \&seek;
*CLOSE = \&close;


1;
__END__

=head1 SEE ALSO

Cache::Entry, Cache::File, Cache::RemovalStrategy

=head1 AUTHOR

 Chris Leishman <chris@leishman.org>
 Based on work by DeWitt Clinton <dewitt@unto.net>

=head1 COPYRIGHT

 Copyright (C) 2003-2006 Chris Leishman.  All Rights Reserved.

This module is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY KIND,
either expressed or implied. This program is free software; you can
redistribute or modify it under the same terms as Perl itself.

$Id: IOString.pm,v 1.3 2006/01/31 15:23:58 caleishm Exp $

=cut
