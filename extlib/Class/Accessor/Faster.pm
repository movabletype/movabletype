package Class::Accessor::Faster;
use base 'Class::Accessor';
use strict;
use B 'perlstring';
$Class::Accessor::Faster::VERSION = '0.51';

my %slot;
sub _slot {
    my($class, $field) = @_;
    my $n = $slot{$class}->{$field};
    return $n if defined $n;
    $n = keys %{$slot{$class}};
    $slot{$class}->{$field} = $n;
    return $n;
}

sub new {
    my($proto, $fields) = @_;
    my($class) = ref $proto || $proto;
    my $self = bless [], $class;

    $fields = {} unless defined $fields;
    for my $k (keys %$fields) {
        my $n = $class->_slot($k);
        $self->[$n] = $fields->{$k};
    }
    return $self;
}

sub make_accessor {
    my($class, $field) = @_;
    my $n = $class->_slot($field);
    eval sprintf q{
        sub {
            return $_[0][%d] if scalar(@_) == 1;
            return $_[0][%d]  = scalar(@_) == 2 ? $_[1] : [@_[1..$#_]];
        }
    }, $n, $n;
}

sub make_ro_accessor {
    my($class, $field) = @_;
    my $n = $class->_slot($field);
    eval sprintf q{
        sub {
            return $_[0][%d] if @_ == 1;
            my $caller = caller;
            $_[0]->_croak(sprintf "'$caller' cannot alter the value of '%%s' on objects of class '%%s'", %s, %s);
        }
    }, $n, map(perlstring($_), $field, $class);
}

sub make_wo_accessor {
    my($class, $field) = @_;
    my $n = $class->_slot($field);
    eval sprintf q{
        sub {
            if (@_ == 1) {
                my $caller = caller;
                $_[0]->_croak(sprintf "'$caller' cannot access the value of '%%s' on objects of class '%%s'", %s, %s);
            }
            else {
                return $_[0][%d] = $_[1] if @_ == 2;
                return (shift)->[%d] = \@_;
            }
        }
    }, map(perlstring($_), $field, $class), $n, $n;
}

1;

__END__

=head1 NAME

Class::Accessor::Faster - Even faster, but less expandable, accessors

=head1 SYNOPSIS

  package Foo;
  use base qw(Class::Accessor::Faster);

=head1 DESCRIPTION

This is a faster but less expandable version of Class::Accessor::Fast.

Class::Accessor's generated accessors require two method calls to accomplish
their task (one for the accessor, another for get() or set()).

Class::Accessor::Fast eliminates calling set()/get() and does the access itself,
resulting in a somewhat faster accessor.

Class::Accessor::Faster uses an array reference underneath to be faster.

Read the documentation for Class::Accessor for more info.

=head1 AUTHORS

Copyright 2017 Marty Pauley <marty+perl@martian.org>

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=head1 SEE ALSO

L<Class::Accessor>

=cut
