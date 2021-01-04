# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Callback;

use strict;
use warnings;

use MT::ErrorHandler;
@MT::Callback::ISA = qw( MT::ErrorHandler );

sub new {
    my $class = shift;
    my ($cb) = ref $_[0] ? @_ : {@_};
    bless $cb, $class;
}

sub name {
    my $cb = shift;
    $cb->{method} || $cb->{name};
}

sub method {
    my $cb = shift;
    $cb->{method};
}

sub invoke {
    my $cb = shift;
    unless ( ref( $cb->{code} ) ) {
        $cb->{code} = MT->handler_to_coderef( $cb->{code} );
    }
    return $cb->{code}->( $cb, @_ );
}

sub plugin {
    my $cb = shift;
    $cb->{plugin};
}

1;
__END__

=head1 NAME

MT::Callback - Movable Type wrapper for executable code with error state

=head1 SYNOPSIS

  $cb = new MT::Callback(name => <name>, code => sub { <callback code> });

E<lt>nameE<gt> is a human-readable string which identifies the
surrounding body of code, for example the name of a plugin--the name
will help identify errors in the activity log.

=head1 METHODS

=head2 new(\%param) or new(%param)

Constructs a new object, using the given parameters. The parameters
recognized for a callback object are:

=over 4

=item name

The name of the callback.

=item code

A coderef that is invoked when running the callback.

=item plugin

The L<MT::Plugin> that is associated with this callback.

=item priority

The priority to assign for the callback, which determines the order
it is invoked when multiple callbacks are tied to the same method.

=item method

The name of the method this callback is associated with.

=back

=head2 $cb->name()

Returns the registered name of the callback.

=head2 $cb->invoke(@params)

Executes the callback, passing the MT::Callback object as the first
parameter, followed by any parameters sent to the invoke method.

=head2 $cb->plugin()

Returns the 'plugin' element associated with the callback object.

=head1 CALLBACK CALLING CONVENTIONS

The parameters passed to each callback routine depends on the operation
in questions, as follows:

=over 4

=item * load(), load_iter()

Before loading items from the database, load() and load_iter()
call the callback registered as <class>::pre_load, allowing a callback
writer to munge the arguments before the database is
called.

An example E<lt>classE<gt>::pre_load might be written as follows:

    sub pre_load {
        my ($cb, $args) = @_;
        ....
    }

Each object I<returned> by load() or by an iterator will,
before it is returned, be processeed by all callbacks registered as
E<lt>classE<gt>::post_load. An example E<lt>classE<gt>::post_load
function 
    
    sub post_load {
        my ($cb, $args, $obj) = @_;
        ....
    }

The C<$args> parameter for both the C<pre_load> and C<post_load>
callback is an array reference of all parameters
that were supplied to the load or load_iter methods.

=item * save()

Callbacks for the save method might be written as follows:

    sub pre_save {
        my ($cb, $obj, $original) = @_;
        ....
    }

    sub post_save {
        my ($cb, $obj, $original) = @_;
        ....
    }

By altering the $obj in pre_save, you can affect what data gets stored
in the database.

By creating pre_save and post_load functions which have inverse
effects on the object, you might be able to store data in the database
in a special form, while keeping the usual in-memory representation.

=item * remove()

E<lt>classE<gt>::pre_remove and E<lt>classE<gt>::post_remove
are called at the very beginning and very end of the respective
operations. The callback routine is called as follows:

    sub pre_remove {
        my ($cb, $obj) = @_;
        ....
    }

The signature for the post_remove operation is the same.

=back

=head1 ERROR HANDLING

The first argument to any callback routine is an L<MT::Callback>
object. You can use this object to return errors to MT.

To signal an error, just use its error() method:

    sub my_callback {
        my ($cb, $arg2, $arg3) = @_;

        ....

        if (some_condition) {
            return $cb->error("The foofiddle was invalid.");
        } 
        ...
    }

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
