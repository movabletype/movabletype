# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Cache::Session;

use strict;
use MT::Session;

sub new {
    my $class = shift;
    my (%param) = @_;
    $param{'ttl'} ||= 0;
    my $self = bless \%param, $class;
    return $self;
}

sub get {
    my MT::Cache::Session $self = shift;
    my ($key) = @_;

    my $record;
    if ( $self->{ttl} ) {
        $record = MT::Session::get_unexpired_value(
            $self->{ttl}, { id => $key, kind => 'CO' } );
    }
    else {
        $record = MT::Session->load( { id => $key, kind => 'CO' } );
    }
    return unless $record;
    return $record->data;
}

sub get_multi {
    my MT::Cache::Session $self = shift;
    my @keys = @_;

    my @tmp = MT::Session->load( { id => \@keys, kind => 'CO' } )
        or return;

    my @records;
    if ( $self->{ttl} ) {
        foreach my $record (@tmp) {
            if ( $record->start() < time - $self->{ttl} ) {
                $record->remove;
                next;
            }
            push @records, $record;
        }
    }
    else {
        @records = @tmp;
    }
    my %values = map { $_->id => $_->data } @records;
    return \%values;
}

sub delete {
    my MT::Cache::Session $self = shift;
    my ($key, $time) = @_;
    MT::Session->remove( { id => $key, kind => 'CO' } )
        or return 0;
    1;
}
*remove = \&delete;

sub add {
    _set("add", @_);
}

sub replace {
    _set("replace", @_);
}

sub set {
    _set("set", @_);
}

sub _set {
    my $cmdname = shift;
    my MT::Cache::Session $self = shift;
    my ($key, $val, $exptime) = @_;

    my $cache = MT::Session->load({
        id   => $key,
        kind => 'CO',
    });
    $cache->remove() if $cache;
    $cache = MT::Session->new;
    $cache->set_values({
        id    => $key,
        kind  => 'CO',
        start => time,
        data  => $val,
    });
    $cache->save();
}

sub flush_all {
    my MT::Cache::Session $self = shift;
    MT::Session->remove({ kind => 'CO' });
}

1;
__END__

=head1 NAME

MT::Cache::Session - Utility package caching data in MT::Session record.

=head1 SYNOPSIS

    my $cache = MT::Cache::Session->new({ttl => 10});
    my $data = $cache->get($key);
    $cache->set($key => $value);
    my $hash = $cache->get_multi($key1, $key2);

=head1 DESCRIPTION

I<MT::Cache::Session> provides a wrapper interface around I<MT::Session>,
with the interface similar to Cache::Memcached.

=head1 USAGE

=head2 $cache->get

Retrieves a key from the cache.  Returns the value or undef.

=head2 $cache->get_multi

Retrieves multiple keys from the cache doing just one query.
Returns a hashref of key/value pairs that were available.

=head2 $cache->set

Unconditionally sets a key to a given value in the memcache.  Returns true
if it was stored successfully.

=head2 $cache->delete

Deletes a key.  You may also use the alternate method name B<remove>,
so MT::Cache::Session looks like the L<Cache::Cache> API.

=head2 $cache->flush_all

Empty all the caches.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
