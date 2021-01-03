# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Promise;
use strict;
use warnings;
use Exporter;
*import                 = \&Exporter::import;
@MT::Promise::EXPORT_OK = qw(delay force lazy);

sub new {
    my ( $class, $code ) = @_;
    my $this = \$code;
    bless $this, $class;
}

sub delay {
    my ($this) = @_;
    __PACKAGE__->new($this);
}

sub lazy (&) {
    my ($this) = @_;
    __PACKAGE__->new($this);
}

sub force {
    my $this = shift;
    return $this if ( ref $this ne 'MT::Promise' );
    if ( ref $$this eq 'CODE' ) {
        $$this = $$this->(@_);
    }
    else {
        return $$this;
    }
}

1;

__END__

=head1 NAME

MT::Promise - Faux-lazy evaluation for Perl

=head1 SYNOPSIS

    sub work_hard {
        # some costly operation
    }

    use MT::Promise qw(delay lazy force);

    # slickest
    $meaning_of_life = lazy { work_hard(); return 42 };
    # kinda slick
    $meaning_of_life = delay(sub { work_hard(); return 42 });
    # clunky ...
    $meaning_of_life = new MT::promise(sub { work_hard(); return 42; });

    print force($meaning_of_life);
    # prints:
    # 42

=head1 DESCRIPTION

A promise is like a value, but the value itself hasn't been computed
yet. At any time, you can "force" the promise to get its value; the
first time it's forced, the computation of the value takes place and
the value is stored. Thereafter, forcing it uses the stored value
instead of re-computing it.

This is useful if some bit of code may be expecting a value in a
certain place, but you don't know up front whether that value will
really be needed. To use this optimization, the expectant code needs
to expect a promise, of course, since it has to call C<force> to get
the value. But you don't have to worry about whether the value will be
needed or which bit of code will need it first--that will shake out at
runtime.

=head1 USAGE

=head2 lazy

There are three forms for creating promises. The C<lazy> form is the slickest:

    my $red = foo($arg);
    my $value = lazy {
        $green = green($red);
        $blue = blue($red, $green);
    }

=head2 delay

The C<delay> form can be useful if you want to delay the evaluation of
a routine that already has a name:

   my $value = delay \&costly_function;

but it should be pointed out that costly_function in this case must be
a thunk--it must not expect any arguments. Typically, you end up
using a closure or the C<lazy> form to encapsulate the arguments:

  my $value1 = lazy { fibonacci(8675309) };

This is almost precisely like $value2 = fibonacci(865309) except that
(a) you have to force $value1, and (b) the 8675309th fibonacci won't
be calculated if it's never C<force>d.

=head2 new

Last and least, you can use C<new> to create a promise, though it's
clunkier than the other methods:

   my $value = new MT::Promise(sub { fibonacci(8675309) });

This would be useful if you were sub-classing promise for some reason.

=head2 force

Force the promise to get its value. The first time, the computation of
the value happens and the value is stored for subsequent access.

=head1 NOTES

Note that if you use the name of a variable declared outside the lazy
block, such as

    my $red;
    my $value = lazy { foo($red) }

then $value will carry around a reference to $red for as long as
$value lives. This is important to keep in mind as it's possible to
create a circular reference without realizing it. You've got to try
pretty hard, though.

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
