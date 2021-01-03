# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Request;
use strict;
use warnings;

use base qw( MT::ErrorHandler );

use vars qw( $r );

sub instance {
    return $r if $r;
    $r = __PACKAGE__->new;
}

sub finish { undef $r }

sub reset { $r->{__stash} = {} if $r }

sub new {
    my $req = bless { __stash => {} }, $_[0];
    $req;
}

sub stash {
    my $req = shift;
    my $key = shift;
    $req->{__stash}->{$key} = shift if @_;
    $req->{__stash}->{$key};
}
*cache = \&stash;

1;
__END__

=head1 NAME

MT::Request - Movable Type request cache

=head1 SYNOPSIS

    use MT::Request;
    my $r = MT::Request->instance;
    $r->cache('foo', $foo);

    ## Later and elsewhere...
    my $foo = $r->cache('foo');

=head1 DESCRIPTION

I<MT::Request> is a very simple singleton object which lasts only for one
particular request to the application, and thus can be used for caching data
that you would like to disappear after the application request exists (and not
for the lifetime of the application).

=head1 USAGE

=head2 MT::Request->instance

Returns the I<MT::Request> singleton.

=head2 new

This is an internal method used by C<MT::Request-E<gt>instance>.

=head2 $r->cache($key [, $value ])

Given a key I<$key>, returns the cached value of the key in the cache held by
the object I<$r>. Given a value I<$value> and a key I<$key>, sets the value of
the key I<$key> in the cache. I<$value> can be a simple scalar, a reference,
an object, etc.

=head2 $r->stash($key [, $value ])

C<stash> is an alias to C<cache>.

=head2 $r->finish()

This method sets the given request (I<$r>) to C<undef>.

=head2 $r->reset()

This method sets the request object's I<__stash> attribute to C<{}>
(nothing).

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
