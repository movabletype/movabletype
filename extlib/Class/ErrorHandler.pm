# $Id: ErrorHandler.pm 22194 2006-01-25 22:20:57Z bchoate $

package Class::ErrorHandler;
use strict;

use vars qw( $VERSION $ERROR );
$VERSION = '0.01';

sub error {
    my $msg = $_[1] || '';
    if (ref($_[0])) {
        $_[0]->{_errstr} = $msg;
    } else {
        $ERROR = $msg;
    }
    return;
}

sub errstr {
    ref($_[0]) ? $_[0]->{_errstr} : $ERROR
}

1;
__END__

=head1 NAME

Class::ErrorHandler - Base class for error handling

=head1 SYNOPSIS

    package Foo;
    use base qw( Class::ErrorHandler );

    sub class_method {
        my $class = shift;
        ...
        return $class->error("Help!")
            unless $continue;
    }

    sub object_method {
        my $obj = shift;
        ...
        return $obj->error("I am no more")
            unless $continue;
    }

    package main;
    use Foo;

    Foo->class_method or die Foo->errstr;

    my $foo = Foo->new;
    $foo->object_method or die $foo->errstr;

=head1 DESCRIPTION

I<Class::ErrorHandler> provides an error-handling mechanism that's generic
enough to be used as the base class for a variety of OO classes. Subclasses
inherit its two error-handling methods, I<error> and I<errstr>, to
communicate error messages back to the calling program.

On failure (for whatever reason), a subclass should call I<error> and return
to the caller; I<error> itself sets the error message internally, then
returns C<undef>. This has the effect of the method that failed returning
C<undef> to the caller. The caller should check for errors by checking for a
return value of C<undef>, and calling I<errstr> to get the value of the
error message on an error.

As demonstrated in the L<SYNOPSIS>, I<error> and I<errstr> work as both class
methods and object methods.

=head1 USAGE

=head2 Class->error($message)

=head2 $object->error($message)

Sets the error message for either the class I<Class> or the object
I<$object> to the message I<$message>. Returns C<undef>.

=head2 Class->errstr

=head2 $object->errstr

Accesses the last error message set in the class I<Class> or the
object I<$object>, respectively, and returns that error message.

=head1 LICENSE

I<Class::ErrorHandler> is free software; you may redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR & COPYRIGHT

Except where otherwise noted, I<Class::ErrorHandler> is Copyright 2004
Benjamin Trott, cpan@stupidfool.org. All rights reserved.

=cut
