package Class::Accessor::Fast;
use base 'Class::Accessor';
use strict;
use B 'perlstring';
$Class::Accessor::Fast::VERSION = '0.51';

sub make_accessor {
    my ($class, $field) = @_;

    eval sprintf q{
        sub {
            return $_[0]{%s} if scalar(@_) == 1;
            return $_[0]{%s}  = scalar(@_) == 2 ? $_[1] : [@_[1..$#_]];
        }
    }, map { perlstring($_) } $field, $field;
}

sub make_ro_accessor {
    my($class, $field) = @_;

    eval sprintf q{
        sub {
            return $_[0]{%s} if @_ == 1;
            my $caller = caller;
            $_[0]->_croak(sprintf "'$caller' cannot alter the value of '%%s' on objects of class '%%s'", %s, %s);
        }
    }, map { perlstring($_) } $field, $field, $class;
}

sub make_wo_accessor {
    my($class, $field) = @_;

    eval sprintf q{
        sub {
            if (@_ == 1) {
                my $caller = caller;
                $_[0]->_croak(sprintf "'$caller' cannot access the value of '%%s' on objects of class '%%s'", %s, %s);
            }
            else {
                return $_[0]{%s} = $_[1] if @_ == 2;
                return (shift)->{%s} = \@_;
            }
        }
    }, map { perlstring($_) } $field, $class, $field, $field;
}

1;

__END__

=head1 NAME

Class::Accessor::Fast - Faster, but less expandable, accessors

=head1 SYNOPSIS

  package Foo;
  use base qw(Class::Accessor::Fast);

  # The rest is the same as Class::Accessor but without set() and get().

=head1 DESCRIPTION

This is a faster but less expandable version of Class::Accessor.
Class::Accessor's generated accessors require two method calls to accomplish
their task (one for the accessor, another for get() or set()).
Class::Accessor::Fast eliminates calling set()/get() and does the access itself,
resulting in a somewhat faster accessor.

The downside is that you can't easily alter the behavior of your
accessors, nor can your subclasses.  Of course, should you need this
later, you can always swap out Class::Accessor::Fast for
Class::Accessor.

Read the documentation for Class::Accessor for more info.

=head1 EFFICIENCY

L<Class::Accessor/EFFICIENCY> for an efficiency comparison.

=head1 AUTHORS

Copyright 2017 Marty Pauley <marty+perl@martian.org>

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=head2 ORIGINAL AUTHOR

Michael G Schwern <schwern@pobox.com>

=head1 SEE ALSO

L<Class::Accessor>

=cut
