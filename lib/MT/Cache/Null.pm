# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Cache::Null;

use strict;

sub new {
    my $class = shift;
    my (%param) = @_;
    my $self = bless \%param, $class;
    return $self;
}

sub get {
    my MT::Cache::Null $self = shift;
    my ($key) = @_;
    return;
}

sub get_multi {
    my MT::Cache::Null $self = shift;
    my @keys = @_;
    return;
}

sub delete {
    my MT::Cache::Null $self = shift;
    my ($key, $time) = @_;
    return;
}
*remove = \&delete;

sub add {
    return;
}

sub replace {
    return;
}

sub set {
    return;
}

sub _set {
    my $cmdname = shift;
    my MT::Cache::Null $self = shift;
    my ($key, $val, $exptime) = @_;
    return;
}

sub purge_stale {
    my MT::Cache::Null $self = shift;
    return;
}

sub flush_all {
    my MT::Cache::Null $self = shift;
    return;
}

sub DESTROY {}

1;
__END__

=head1 NAME

MT::Cache::Null - Null object compatible with the MT::Cache interface.

=head1 DESCRIPTION

I<MT::Cache::Null> provides interface to MT::Cache, but does absolutely
nothing.

=head1 USAGE

See POD of I<MT::Cache::Session> for details.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut

