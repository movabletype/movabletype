# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Callback;

use strict;

use MT::ErrorHandler;
@MT::Callback::ISA = qw( MT::ErrorHandler );

sub new {
    my $class = shift;
    my ($cb) = ref$_[0] ? @_ : {@_};
    bless $cb, $class;
}

sub name {
    my $cb = shift;
    $cb->{name};
}

sub invoke {
    my $cb = shift;
    return $cb->{code}->($cb, @_);
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

=over 4

=item name

Returns the registered name of the callback.

=item invoke

Executes the callback, passing the MT::Callback object as the first
parameter, followed by any parameters sent to the invoke method.

=item plugin

Returns the 'plugin' element associated with the callback object.

=back

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
        my ($eh, $args) = @_;
        ....
    }

Each object I<returned> by load() or by an iterator will,
before it is returned, be processeed by all callbacks registered as
E<lt>classE<gt>::post_load. An example E<lt>classE<gt>::post_load
function 
    
    sub post_load {
        my ($eh, $args, $obj) = @_;
        ....
    }

The C<$args> parameter for both the C<pre_load> and C<post_load>
callback is an array reference of all parameters
that were supplied to the load or load_iter methods.

=item * save()

Callbacks for the save method might be written as follows:

    sub pre_save {
        my ($eh, $obj, $original) = @_;
        ....
    }

    sub post_save {
        my ($eh, $obj, $original) = @_;
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
        my ($eh, $obj) = @_;
        ....
    }

The signature for the post_remove operation is the same.

E<lt>classE<gt>::pre_remove_all and
E<lt>classE<gt>::post_remove_all are called at the very beginning and
very end of the respective operations, with no arguments except the
MT::Callback object.

=back

=head1 ERROR HANDLING

The first argument to any callback routine is an L<MT::Callback>
object. You can use this object to return errors to MT.

To signal an error, just use its error() method:

    sub my_callback {
        my ($eh, $arg2, $arg3) = @_;

        ....

        if (some_condition) {
            return $eh->error("The foofiddle was invalid.");
        } 
        ...
    }

=head1 AUTHOR & COPYRIGHTS

Please see the I<MT> manpage for author, copyright, and license information.

=cut
