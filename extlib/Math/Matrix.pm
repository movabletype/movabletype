# -*- mode: perl; coding: utf-8-unix -*-

package Math::Matrix;

use strict;
use warnings;

use Carp;
use Scalar::Util 'blessed';

our $VERSION = '0.94';
our $eps = 0.00001;

use overload

  '+'  => sub {
              my ($x, $y, $swap) = @_;
              $x -> add($y);
          },

  '-'  => sub {
              my ($x, $y, $swap) = @_;
              if ($swap) {
                  return $x -> neg() if !ref($y) && $y == 0;

                  my $class = ref $x;
                  return $class -> new($y) -> sub($x);
              }
              $x -> sub($y);
          },

  '*'  => sub {
              my ($x, $y, $swap) = @_;
              $x -> mul($y);
          },

  '**' => sub {
              my ($x, $y, $swap) = @_;
              if ($swap) {
                  my $class = ref $x;
                  return $class -> new($y) -> pow($x);
              }
              $x -> pow($y);
          },

  '==' => sub {
              my ($x, $y, $swap) = @_;
              $x -> meq($y);
          },

  '!=' => sub {
              my ($x, $y, $swap) = @_;
              $x -> mne($y);
          },

  'int' => sub {
               my ($x, $y, $swap) = @_;
               $x -> int();
           },

  'abs' => sub {
               my ($x, $y, $swap) = @_;
               $x -> abs();
           },

  '~'  => 'transpose',
  '""' => 'as_string',
  '='  => 'clone';

=pod

=encoding utf8

=head1 NAME

Math::Matrix - multiply and invert matrices

=head1 SYNOPSIS

    use Math::Matrix;

    # Generate a random 3-by-3 matrix.
    srand(time);
    my $A = Math::Matrix -> new([rand, rand, rand],
                                [rand, rand, rand],
                                [rand, rand, rand]);
    $A -> print("A\n");

    # Append a fourth column to $A.
    my $x = Math::Matrix -> new([rand, rand, rand]);
    my $E = $A -> concat($x -> transpose);
    $E -> print("Equation system\n");

    # Compute the solution.
    my $s = $E -> solve;
    $s -> print("Solutions s\n");

    # Verify that the solution equals $x.
    $A -> multiply($s) -> print("A*s\n");

=head1 DESCRIPTION

This module implements various constructors and methods for creating and
manipulating matrices.

All methods return new objects, so, for example, C<$X-E<gt>add($Y)> does not
modify C<$X>.

    $X -> add($Y);         # $X not modified; output is lost
    $X = $X -> add($Y);    # this works

Some operators are overloaded (see L</OVERLOADING>) and allow the operand to be
modified directly.

    $X = $X + $Y;          # this works
    $X += $Y;              # so does this

=head1 METHODS

=head2 Constructors

=over 4

=item new()

Creates a new object from the input arguments and returns it.

If a single input argument is given, and that argument is a reference to array
whose first element is itself a reference to an array, it is assumed that the
argument contains the whole matrix, like this:

    $x = Math::Matrix->new([[1, 2, 3], [4, 5, 6]]); # 2-by-3 matrix
    $x = Math::Matrix->new([[1, 2, 3]]);            # 1-by-3 matrix
    $x = Math::Matrix->new([[1], [2], [3]]);        # 3-by-1 matrix

If a single input argument is given, and that argument is not a reference to an
array, a 1-by-1 matrix is returned.

    $x = Math::Matrix->new(1);                      # 1-by-1 matrix

Note that all the folling cases result in an empty matrix:

    $x = Math::Matrix->new([[], [], []]);
    $x = Math::Matrix->new([[]]);
    $x = Math::Matrix->new([]);

If C<L</new()>> is called as an instance method with no input arguments, a zero
filled matrix with identical dimensions is returned:

    $b = $a->new();     # $b is a zero matrix with the size of $a

Each row must contain the same number of elements.

=cut

sub new {
    my $that = shift;
    my $class = ref($that) || $that;
    my $self = [];

    # If called as an instance method and no arguments are given, return a
    # zero matrix of the same size as the invocand.

    if (ref($that) && (@_ == 0)) {
        @$self = map [ (0) x @$_ ], @$that;
    }

    # Otherwise return a new matrix based on the input arguments. The object
    # data is a blessed reference to an array containing the matrix data. This
    # array contains a list of arrays, one for each row, which in turn contains
    # a list of elements. An empty matrix has no rows.
    #
    #   [[ 1, 2, 3 ], [ 4, 5, 6 ]]  2-by-3 matrix
    #   [[ 1, 2, 3 ]]               1-by-3 matrix
    #   [[ 1 ], [ 2 ], [ 3 ]]       3-by-1 matrix
    #   [[ 1 ]]                     1-by-1 matrix
    #   []                          empty matrix

    else {

        my $data;

        # If there is a single argument, and that is not a reference,
        # assume new() has been called as, e.g., $class -> new(3).

        if (@_ == 1 && !ref($_[0])) {
            $data = [[ $_[0] ]];
        }

        # If there is a single argument, and that is a reference to an array,
        # and that array contains at least one element, and that element is
        # itself a reference to an array, then assume new() has been called
        # with the matrix as one argument, i.e., a reference to an array of
        # arrays, e.g., $class -> new([ [1, 2], [3, 4] ]) ...

        elsif (@_ == 1 && ref($_[0]) eq 'ARRAY'
               && @{$_[0]} > 0 && ref($_[0][0]) eq 'ARRAY')
        {
            $data = $_[0];
        }

        # ... otherwise assume that each argument to new() is a row. Note that
        # new() called with no arguments results in an empty matrix.

        else {
            $data = [ @_ ];
        }

        # Sanity checking.

        if (@$data) {
            my $nrow = @$data;
            my $ncol;

            for my $i (0 .. $nrow - 1) {
                my $row = $data -> [$i];

                # Verify that the row is a reference to an array.

                croak "row with index $i is not a reference to an array"
                  unless ref($row) eq 'ARRAY';

                # In the first round, get the number of elements, i.e., the
                # number of columns in the matrix. In the successive
                # rounds, verify that each row has the same number of
                # elements.

                if ($i == 0) {
                    $ncol = @$row;
                } else {
                    croak "each row must have the same number of elements"
                      unless @$row == $ncol;
                }
            }

            # Copy the data into $self only if the matrix is non-emtpy.

            @$self = map [ @$_ ], @$data if $ncol;
        }
    }

    bless $self, $class;
}

=pod

=item new_from_sub()

Creates a new matrix object by doing a subroutine call to create each element.

    $sub = sub { ... };
    $x = Math::Matrix -> new_from_sub($sub);          # 1-by-1
    $x = Math::Matrix -> new_from_sub($sub, $m);      # $m-by-$m
    $x = Math::Matrix -> new_from_sub($sub, $m, $n);  # $m-by-$n

The subroutine is called in scalar context with two input arguments, the row and
column indices of the element to be created. Note that no checks are performed
on the output of the subroutine.

Example 1, a 4-by-4 identity matrix can be created with

    $sub = sub { $_[0] == $_[1] ? 1 : 0 };
    $x = Math::Matrix -> new_from_sub($sub, 4);

Example 2, the code

    $x = Math::Matrix -> new_from_sub(sub { 2**$_[1] }, 1, 11);

creates the following 1-by-11 vector with powers of two

    [ 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024 ]

Example 3, the code, using C<$i> and C<$j> for increased readability

    $sub = sub {
        ($i, $j) = @_;
        $d = $j - $i;
        return $d == -1 ? 5
             : $d ==  0 ? 6
             : $d ==  1 ? 7
             : 0;
    };
    $x = Math::Matrix -> new_from_sub($sub, 5);

creates the tridiagonal matrix

    [ 6 7 0 0 0 ]
    [ 5 6 7 0 0 ]
    [ 0 5 6 7 0 ]
    [ 0 0 5 6 7 ]
    [ 0 0 0 5 6 ]

=cut

sub new_from_sub {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 4;
    my $class = shift;

    croak +(caller(0))[3], " is a class method, not an instance method"
      if ref $class;

    my $sub = shift;
    croak "The first input argument must be a code reference"
      unless ref($sub) eq 'CODE';

    my ($nrow, $ncol) = @_ == 0 ? (1, 1)
                      : @_ == 1 ? (@_, @_)
                      :           (@_);

    my $x = bless [], $class;
    for my $i (0 .. $nrow - 1) {
        for my $j (0 .. $ncol - 1) {
            $x -> [$i][$j] = $sub -> ($i, $j);
        }
    }

    return $x;
}

=pod

=item new_from_rows()

Creates a new matrix by assuming each argument is a row vector.

    $x = Math::Matrix -> new_from_rows($y, $z, ...);

For example

    $x = Math::Matrix -> new_from_rows([1, 2, 3],[4, 5, 6]);

returns the matrix

    [ 1 2 3 ]
    [ 4 5 6 ]

=cut

sub new_from_rows {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    my $class = shift;

    croak +(caller(0))[3], " is a class method, not an instance method"
      if ref $class;

    my @args = ();
    for (my $i = 0 ; $i <= $#_ ; ++$i) {
        my $x = $_[$i];
        $x = $class -> new($x)
          unless defined(blessed($x)) && $x -> isa($class);
        if ($x -> is_vector()) {
            push @args, $x -> to_row();
        } else {
            push @args, $x;
        }
    }

    $class -> new([]) -> catrow(@args);
}

=pod

=item new_from_cols()

Creates a matrix by assuming each argument is a column vector.

    $x = Math::Matrix -> new_from_cols($y, $z, ...);

For example,

    $x = Math::Matrix -> new_from_cols([1, 2, 3],[4, 5, 6]);

returns the matrix

    [ 1 4 ]
    [ 2 5 ]
    [ 3 6 ]

=cut

sub new_from_cols {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    my $class = shift;

    croak +(caller(0))[3], " is a class method, not an instance method"
      if ref $class;

    $class -> new_from_rows(@_) -> swaprc();
}

=pod

=item id()

Returns a new identity matrix.

    $I = Math::Matrix -> id($n);    # $n-by-$n identity matrix
    $I = $x -> id($n);              # $n-by-$n identity matrix
    $I = $x -> id();                # identity matrix with size of $x

=cut

sub id {
    my $self = shift;
    my $ref = ref $self;
    my $class = $ref || $self;

    my $n;
    if (@_) {
        $n = shift;
    } else {
        if ($ref) {
            my ($mx, $nx) = $self -> size();
            croak "When id() is called as an instance method, the invocand",
              " must be a square matrix" unless $mx == $nx;
            $n = $mx;
        } else {
            croak "When id() is called as a class method, the size must be",
              " given as an input argument";
        }
    }

    bless [ map [ (0) x ($_ - 1), 1, (0) x ($n - $_) ], 1 .. $n ], $class;
}

=pod

=item new_identity()

This is an alias for C<L</id()>>.

=cut

sub new_identity {
    id(@_);
}

=pod

=item eye()

This is an alias for C<L</id()>>.

=cut

sub eye {
    new_identity(@_);
}

=pod

=item exchg()

Exchange matrix.

    $x = Math::Matrix -> exchg($n);     # $n-by-$n exchange matrix

=cut

sub exchg {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $class = shift;

    my $n = shift;
    bless [ map [ (0) x ($n - $_), 1, (0) x ($_ - 1) ], 1 .. $n ], $class;
}

=pod

=item scalar()

Returns a scalar matrix, i.e., a diagonal matrix with all the diagonal elements
set to the same value.

    # Create an $m-by-$m scalar matrix where each element is $c.
    $x = Math::Matrix -> scalar($c, $m);

    # Create an $m-by-$n scalar matrix where each element is $c.
    $x = Math::Matrix -> scalar($c, $m, $n);

Multiplying a matrix A by a scalar matrix B is effectively the same as multiply
each element in A by the constant on the diagonal of B.

=cut

sub scalar {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 4;
    my $class = shift;

    croak +(caller(0))[3], " is a class method, not an instance method"
      if ref $class;

    my $c = shift;
    my ($m, $n) = @_ == 0 ? (1, 1)
                : @_ == 1 ? (@_, @_)
                :           (@_);
    croak "The number of rows must be equal to the number of columns"
      unless $m == $n;

    bless [ map [ (0) x ($_ - 1), $c, (0) x ($n - $_) ], 1 .. $m ], $class;
}

=pod

=item zeros()

Create a zero matrix.

    # Create an $m-by-$m matrix where each element is 0.
    $x = Math::Matrix -> zeros($m);

    # Create an $m-by-$n matrix where each element is 0.
    $x = Math::Matrix -> zeros($m, $n);

=cut

sub zeros {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 3;
    my $self = shift;
    $self -> constant(0, @_);
};

=pod

=item ones()

Create a matrix of ones.

    # Create an $m-by-$m matrix where each element is 1.
    $x = Math::Matrix -> ones($m);

    # Create an $m-by-$n matrix where each element is 1.
    $x = Math::Matrix -> ones($m, $n);

=cut

sub ones {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 3;
    my $self = shift;
    $self -> constant(1, @_);
};

=pod

=item inf()

Create a matrix of positive infinities.

    # Create an $m-by-$m matrix where each element is Inf.
    $x = Math::Matrix -> inf($m);

    # Create an $m-by-$n matrix where each element is Inf.
    $x = Math::Matrix -> inf($m, $n);

=cut

sub inf {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 3;
    my $self = shift;

    require Math::Trig;
    my $inf = Math::Trig::Inf();
    $self -> constant($inf, @_);
};

=pod

=item nan()

Create a matrix of NaNs (Not-a-Number).

    # Create an $m-by-$m matrix where each element is NaN.
    $x = Math::Matrix -> nan($m);

    # Create an $m-by-$n matrix where each element is NaN.
    $x = Math::Matrix -> nan($m, $n);

=cut

sub nan {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 3;
    my $self = shift;

    require Math::Trig;
    my $inf = Math::Trig::Inf();
    my $nan = $inf - $inf;
    $self -> constant($nan, @_);
};

=pod

=item constant()

Returns a constant matrix, i.e., a matrix whose elements all have the same
value.

    # Create an $m-by-$m matrix where each element is $c.
    $x = Math::Matrix -> constant($c, $m);

    # Create an $m-by-$n matrix where each element is $c.
    $x = Math::Matrix -> constant($c, $m, $n);

=cut

sub constant {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 4;
    my $class = shift;

    croak +(caller(0))[3], " is a class method, not an instance method"
      if ref $class;

    my $c = shift;
    my ($m, $n) = @_ == 0 ? (1, 1)
                : @_ == 1 ? (@_, @_)
                :           (@_);

    bless [ map [ ($c) x $n ], 1 .. $m ], $class;
}

=pod

=item rand()

Returns a matrix of uniformly distributed random numbers in the range [0,1).

    $x = Math::Matrix -> rand($m);          # $m-by-$m matrix
    $x = Math::Matrix -> rand($m, $n);      # $m-by-$n matrix

To generate an C<$m>-by-C<$n> matrix of uniformly distributed random numbers in
the range [0,C<$a>), use

    $x = $a * Math::Matrix -> rand($m, $n);

To generate an C<$m>-by-C<$n> matrix of uniformly distributed random numbers in
the range [C<$a>,C<$b>), use

    $x = $a + ($b - $a) * Math::Matrix -> rand($m, $n);

See also C<L</randi()>> and C<L</randn()>>.

=cut

sub rand {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 3;
    my $class = shift;

    croak +(caller(0))[3], " is a class method, not an instance method"
      if ref $class;

    my ($nrow, $ncol) = @_ == 0 ? (1, 1)
                      : @_ == 1 ? (@_, @_)
                      :           (@_);

    my $x = bless [], $class;
    for my $i (0 .. $nrow - 1) {
        for my $j (0 .. $ncol - 1) {
            $x -> [$i][$j] = CORE::rand;
        }
    }

    return $x;
}

=pod

=item randi()

Returns a matrix of uniformly distributed random integers.

    $x = Math::Matrix -> randi($max);                 # 1-by-1 matrix
    $x = Math::Matrix -> randi($max, $n);             # $n-by-$n matrix
    $x = Math::Matrix -> randi($max, $m, $n);         # $m-by-$n matrix

    $x = Math::Matrix -> randi([$min, $max]);         # 1-by-1 matrix
    $x = Math::Matrix -> randi([$min, $max], $n);     # $n-by-$n matrix
    $x = Math::Matrix -> randi([$min, $max], $m, $n); # $m-by-$n matrix

See also C<L</rand()>> and C<L</randn()>>.

=cut

sub randi {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 4;
    my $class = shift;

    croak +(caller(0))[3], " is a class method, not an instance method"
      if ref $class;

    my ($min, $max);
    my $lim = shift;
    if (ref($lim) eq 'ARRAY') {
        ($min, $max) = @$lim;
    } else {
        $min = 0;
        $max = $lim;
    }

    my ($nrow, $ncol) = @_ == 0 ? (1, 1)
                      : @_ == 1 ? (@_, @_)
                      :           (@_);

    my $c = $max - $min + 1;
    my $x = bless [], $class;
    for my $i (0 .. $nrow - 1) {
        for my $j (0 .. $ncol - 1) {
            $x -> [$i][$j] = $min + CORE::int(CORE::rand($c));
        }
    }

    return $x;
}

=pod

=item randn()

Returns a matrix of random numbers from the standard normal distribution.

    $x = Math::Matrix -> randn($m);         # $m-by-$m matrix
    $x = Math::Matrix -> randn($m, $n);     # $m-by-$n matrix

To generate an C<$m>-by-C<$n> matrix with mean C<$mu> and standard deviation
C<$sigma>, use

    $x = $mu + $sigma * Math::Matrix -> randn($m, $n);

See also C<L</rand()>> and C<L</randi()>>.

=cut

sub randn {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 3;
    my $class = shift;

    croak +(caller(0))[3], " is a class method, not an instance method"
      if ref $class;

    my ($nrow, $ncol) = @_ == 0 ? (1, 1)
                      : @_ == 1 ? (@_, @_)
                      :           (@_);

    my $nelm  = $nrow * $ncol;
    my $twopi = 2 * atan2 0, -1;

    # The following might generate one value more than we need.

    my $x = [];
    for (my $k = 0 ; $k < $nelm ; $k += 2) {
        my $c1 = sqrt(-2 * log(CORE::rand));
        my $c2 = $twopi * CORE::rand;
        push @$x, $c1 * cos($c2), $c1 * sin($c2);
    }
    pop @$x if @$x > $nelm;

    $x = bless [ $x ], $class;
    $x -> reshape($nrow, $ncol);
}

=pod

=item clone()

Clones a matrix and returns the clone.

    $b = $a->clone;

=cut

sub clone {
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    my $class = ref $x;

    croak +(caller(0))[3], " is an instance method, not a class method"
      unless $class;

    my $y = [ map [ @$_ ], @$x ];
    bless $y, $class;
}

=pod

=item diagonal()

A constructor method that creates a diagonal matrix from a single list or array
of numbers.

    $p = Math::Matrix->diagonal(1, 4, 4, 8);
    $q = Math::Matrix->diagonal([1, 4, 4, 8]);

The matrix is zero filled except for the diagonal members, which take the
values of the vector.

The method returns B<undef> in case of error.

=cut

#
# Either class or object call, create a square matrix with the same
# dimensions as the passed-in list or array.
#
sub diagonal {
    my $that = shift;
    my $class = ref($that) || $that;
    my @diag = @_;
    my $self = [];

    # diagonal([2,3]) -> diagonal(2,3)
    @diag = @{$diag[0]} if (ref $diag[0] eq "ARRAY");

    my $len = scalar @diag;
    return undef if ($len == 0);

    for my $idx (0..$len-1) {
        my @r = (0) x $len;
        $r[$idx] = $diag[$idx];
        push(@{$self}, [@r]);
    }
    bless $self, $class;
}

=pod

=item tridiagonal()

A constructor method that creates a matrix from vectors of numbers.

    $p = Math::Matrix->tridiagonal([1, 4, 4, 8]);
    $q = Math::Matrix->tridiagonal([1, 4, 4, 8], [9, 12, 15]);
    $r = Math::Matrix->tridiagonal([1, 4, 4, 8], [9, 12, 15], [4, 3, 2]);

In the first case, the main diagonal takes the values of the vector, while both
of the upper and lower diagonals's values are all set to one.

In the second case, the main diagonal takes the values of the first vector,
while the upper and lower diagonals are each set to the values of the second
vector.

In the third case, the main diagonal takes the values of the first vector,
while the upper diagonal is set to the values of the second vector, and the
lower diagonal is set to the values of the third vector.

The method returns B<undef> in case of error.

=cut

#
# Either class or object call, create a square matrix with the same
# dimensions as the passed-in list or array.
#
sub tridiagonal {
    my $that = shift;
    my $class = ref($that) || $that;
    my(@up_d, @main_d, @low_d);
    my $self = [];

    #
    # Handle the different ways the tridiagonal vectors could
    # be passed in.
    #
    if (ref $_[0] eq "ARRAY") {
        @main_d = @{$_[0]};

        if (ref $_[1] eq "ARRAY") {
            @up_d = @{$_[1]};

            if (ref $_[2] eq "ARRAY") {
                @low_d = @{$_[2]};
            }
        }
    } else {
        @main_d = @_;
    }

    my $len = scalar @main_d;
    return undef if ($len == 0);

    #
    # Default the upper and lower diagonals if no vector
    # was passed in for them.
    #
    @up_d = (1) x ($len -1) if (scalar @up_d == 0);
    @low_d = @up_d if (scalar @low_d == 0);

    #
    # First row...
    #
    my @arow = (0) x $len;
    @arow[0..1] = ($main_d[0], $up_d[0]);
    push (@{$self}, [@arow]);

    #
    # Bulk of the matrix...
    #
    for my $idx (1 .. $#main_d - 1) {
        my @r = (0) x $len;
        @r[$idx-1 .. $idx+1] = ($low_d[$idx-1], $main_d[$idx], $up_d[$idx]);
        push (@{$self}, [@r]);
    }

    #
    # Last row.
    #
    my @zrow = (0) x $len;
    @zrow[$len-2..$len-1] = ($low_d[$#main_d -1], $main_d[$#main_d]);
    push (@{$self}, [@zrow]);

    bless $self, $class;
}

=pod

=item blkdiag()

Create block diagonal matrix. Returns a block diagonal matrix given a list of
matrices.

    $z = Math::Matrix -> blkdiag($x, $y, ...);

=cut

sub blkdiag {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    #croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $class = shift;

    my $y = [];
    my $nrowy = 0;
    my $ncoly = 0;

    for my $i (0 .. $#_) {
        my $x = $_[$i];

        $x = $class -> new($x)
          unless defined(blessed($x)) && $x -> isa($class);

        my ($nrowx, $ncolx) = $x -> size();

        # Upper right submatrix.

        for my $i (0 .. $nrowy - 1) {
            for my $j (0 .. $ncolx - 1) {
                $y -> [$i][$ncoly + $j] = 0;
            }
        }

        # Lower left submatrix.

        for my $i (0 .. $nrowx - 1) {
            for my $j (0 .. $ncoly - 1) {
                $y -> [$nrowy + $i][$j] = 0;
            }
        }

        # Lower right submatrix.

        for my $i (0 .. $nrowx - 1) {
            for my $j (0 .. $ncolx - 1) {
                $y -> [$nrowy + $i][$ncoly + $j] = $x -> [$i][$j];
            }
        }

        $nrowy += $nrowx;
        $ncoly += $ncolx;
    }

    bless $y, $class;
}

=pod

=back

=head2 Identify matrices

=over 4

=item is_empty()

Returns 1 is the invocand is empty, i.e., it has no elements.

    $bool = $x -> is_empty();

=cut

sub is_empty {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    return $x -> nelm() == 0;
}

=pod

=item is_scalar()

Returns 1 is the invocand is a scalar, i.e., it has one element.

    $bool = $x -> is_scalar();

=cut

sub is_scalar {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    return $x -> nelm() == 1 ? 1 : 0;
}

=pod

=item is_vector()

Returns 1 is the invocand is a vector, i.e., a row vector or a column vector.

    $bool = $x -> is_vector();

=cut

sub is_vector {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    return $x -> is_col() || $x -> is_row() ? 1 : 0;
}

=pod

=item is_row()

Returns 1 if the invocand has exactly one row, and 0 otherwise.

    $bool = $x -> is_row();

=cut

sub is_row {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    return $x -> nrow() == 1 ? 1 : 0;
}

=pod

=item is_col()

Returns 1 if the invocand has exactly one column, and 0 otherwise.

    $bool = $x -> is_col();

=cut

sub is_col {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    return $x -> ncol() == 1 ? 1 : 0;
}

=pod

=item is_square()

Returns 1 is the invocand is square, and 0 otherwise.

    $bool = $x -> is_square();

=cut

sub is_square {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    my ($nrow, $ncol) = $x -> size();
    return $nrow == $ncol ? 1 : 0;
}

=pod

=item is_symmetric()

Returns 1 is the invocand is symmetric, and 0 otherwise.

    $bool = $x -> is_symmetric();

An symmetric matrix satisfies x(i,j) = x(j,i) for all i and j, for example

    [  1  2 -3 ]
    [  2 -4  5 ]
    [ -3  5  6 ]

=cut

sub is_symmetric {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my ($nrow, $ncol) = $x -> size();
    return 0 unless $nrow == $ncol;

    for my $i (1 .. $nrow - 1) {
        for my $j (0 .. $i - 1) {
            return 0 unless $x -> [$i][$j] == $x -> [$j][$i];
        }
    }

    return 1;
}

=pod

=item is_antisymmetric()

Returns 1 is the invocand is antisymmetric a.k.a. skew-symmetric, and 0
otherwise.

    $bool = $x -> is_antisymmetric();

An antisymmetric matrix satisfies x(i,j) = -x(j,i) for all i and j, for
example

    [  0  2 -3 ]
    [ -2  0  4 ]
    [  3 -4  0 ]

=cut

sub is_antisymmetric {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my ($nrow, $ncol) = $x -> size();
    return 0 unless $nrow == $ncol;

    # Check the diagonal.

    for my $i (0 .. $nrow - 1) {
        return 0 unless $x -> [$i][$i] == 0;
    }

    # Check the off-diagonal.

    for my $i (1 .. $nrow - 1) {
        for my $j (0 .. $i - 1) {
            return 0 unless $x -> [$i][$j] == -$x -> [$j][$i];
        }
    }

    return 1;
}

=pod

=item is_persymmetric()

Returns 1 is the invocand is persymmetric, and 0 otherwise.

    $bool = $x -> is_persymmetric();

A persymmetric matrix is a square matrix which is symmetric with respect to the
anti-diagonal, e.g.:

    [ f  h  j  k ]
    [ c  g  i  j ]
    [ b  d  g  h ]
    [ a  b  c  f ]

=cut

sub is_persymmetric {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    $x -> fliplr() -> is_symmetric();
}

=pod

=item is_hankel()

Returns 1 is the invocand is a Hankel matric a.k.a. a catalecticant matrix, and
0 otherwise.

    $bool = $x -> is_hankel();

A Hankel matrix is a square matrix in which each ascending skew-diagonal from
left to right is constant, e.g.:

    [ e f g h i ]
    [ d e f g h ]
    [ c d e f g ]
    [ b c d e f ]
    [ a b c d e ]

=cut

sub is_hankel {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my ($nrow, $ncol) = $x -> size();
    return 0 unless $nrow == $ncol;

    # Check the lower triangular part.

    for my $i (0 .. $nrow - 2) {
        my $first = $x -> [$i][0];
        for my $k (1 .. $nrow - $i - 1) {
            return 0 unless $x -> [$i + $k][$k] == $first;
        }
    }

    # Check the strictly upper triangular part.

    for my $j (1 .. $ncol - 2) {
        my $first = $x -> [0][$j];
        for my $k (1 .. $nrow - $j - 1) {
            return 0 unless $x -> [$k][$j + $k] == $first;
        }
    }

    return 1;
}

=pod

=item is_zero()

Returns 1 is the invocand is a zero matrix, and 0 otherwise. A zero matrix
contains no element whose value is different from zero.

    $bool = $x -> is_zero();

=cut

sub is_zero {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    return $x -> is_constant(0);
}

=pod

=item is_one()

Returns 1 is the invocand is a matrix of ones, and 0 otherwise. A matrix of
ones contains no element whose value is different from one.

    $bool = $x -> is_one();

=cut

sub is_one {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    return $x -> is_constant(1);
}

=pod

=item is_constant()

Returns 1 is the invocand is a constant matrix, and 0 otherwise. A constant
matrix is a matrix where no two elements have different values.

    $bool = $x -> is_constant();

=cut

sub is_constant {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;

    my ($nrow, $ncol) = $x -> size();

    # An empty matrix contains no elements that are different from $c.

    return 1 if $nrow * $ncol == 0;

    my $c = @_ ? shift() : $x -> [0][0];
    for my $i (0 .. $nrow - 1) {
        for my $j (0 .. $ncol - 1) {
            return 0 if $x -> [$i][$j] != $c;
        }
    }

    return 1;
}

=pod

=item is_identity()

Returns 1 is the invocand is an identity matrix, and 0 otherwise. An
identity matrix contains ones on the main diagonal and zeros elsewhere.

    $bool = $x -> is_identity();

=cut

sub is_identity {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my ($nrow, $ncol) = $x -> size();
    return 0 unless $nrow == $ncol;

    for my $i (0 .. $nrow - 1) {
        for my $j (0 .. $ncol - 1) {
            return 0 if $x -> [$i][$j] != ($i == $j ? 1 : 0);
        }
    }

    return 1;
}

=pod

=item is_exchg()

Returns 1 is the invocand is an exchange matrix, and 0 otherwise.

    $bool = $x -> is_exchg();

An exchange matrix contains ones on the main anti-diagonal and zeros elsewhere,
for example

    [ 0 0 1 ]
    [ 0 1 0 ]
    [ 1 0 0 ]

=cut

sub is_exchg {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my ($nrow, $ncol) = $x -> size();
    return 0 unless $nrow == $ncol;

    my $imax = $nrow - 1;
    for my $i (0 .. $nrow - 1) {
        for my $j (0 .. $ncol - 1) {
            return 0 if $x -> [$i][$j] != ($i + $j == $imax ? 1 : 0);
        }
    }

    return 1;
}

=pod

=item is_bool()

Returns 1 is the invocand is a boolean matrix, and 0 otherwise.

    $bool = $x -> is_bool();

A boolean matrix is a matrix is a matrix whose entries are either 0 or 1, for
example

    [ 0 1 1 ]
    [ 1 0 0 ]
    [ 0 1 0 ]

=cut

sub is_bool {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my ($nrow, $ncol) = $x -> size();

    for my $i (0 .. $nrow - 1) {
        for my $j (0 .. $ncol - 1) {
            my $val = $x -> [$i][$j];
            return 0 if $val != 0 && $val != 1;
        }
    }

    return 1;
}

=pod

=item is_perm()

Returns 1 is the invocand is an permutation matrix, and 0 otherwise.

    $bool = $x -> is_perm();

A permutation matrix is a square matrix with exactly one 1 in each row and
column, and all other elements 0, for example

    [ 0 1 0 ]
    [ 1 0 0 ]
    [ 0 0 1 ]

=cut

sub is_perm {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my ($nrow, $ncol) = $x -> size();
    return 0 unless $nrow == $ncol;

    my $rowsum = [ (0) x $nrow ];
    my $colsum = [ (0) x $ncol ];

    for my $i (0 .. $nrow - 1) {
        for my $j (0 .. $ncol - 1) {
            my $val = $x -> [$i][$j];
            return 0 if $val != 0 && $val != 1;
            if ($val == 1) {
                return 0 if ++$rowsum -> [$i] > 1;
                return 0 if ++$colsum -> [$j] > 1;
            }
        }
    }

    for my $i (0 .. $nrow - 1) {
        return 0 if $rowsum -> [$i] != 1;
        return 0 if $colsum -> [$i] != 1;
    }

    return 1;
}

=pod

=item is_int()

Returns 1 is the invocand is an integer matrix, i.e., a matrix of integers, and
0 otherwise.

    $bool = $x -> is_int();

=cut

sub is_int {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my ($nrow, $ncol) = $x -> size();

    for my $i (0 .. $nrow - 1) {
        for my $j (0 .. $ncol - 1) {
            return 0 unless $x -> [$i][$j] == int $x -> [$i][$j];
        }
    }

    return 1;
}

=pod

=item is_diag()

Returns 1 is the invocand is diagonal, and 0 otherwise.

    $bool = $x -> is_diag();

A diagonal matrix is a square matrix where all non-zero elements, if any, are on
the main diagonal. It has the following pattern, where only the elements marked
as C<x> can be non-zero,

    [ x 0 0 0 0 ]
    [ 0 x 0 0 0 ]
    [ 0 0 x 0 0 ]
    [ 0 0 0 x 0 ]
    [ 0 0 0 0 x ]

=cut

sub is_diag {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    $x -> is_band(0);
}

=pod

=item is_adiag()

Returns 1 is the invocand is anti-diagonal, and 0 otherwise.

    $bool = $x -> is_adiag();

A diagonal matrix is a square matrix where all non-zero elements, if any, are on
the main antidiagonal. It has the following pattern, where only the elements
marked as C<x> can be non-zero,

    [ 0 0 0 0 x ]
    [ 0 0 0 x 0 ]
    [ 0 0 x 0 0 ]
    [ 0 x 0 0 0 ]
    [ x 0 0 0 0 ]

=cut

sub is_adiag {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    $x -> is_aband(0);
}

=pod

=item is_tridiag()

Returns 1 is the invocand is tridiagonal, and 0 otherwise.

    $bool = $x -> is_tridiag();

A tridiagonal matrix is a square matrix with nonzero elements only on the
diagonal and slots horizontally or vertically adjacent the diagonal (i.e., along
the subdiagonal and superdiagonal). It has the following pattern, where only the
elements marked as C<x> can be non-zero,

    [ x x 0 0 0 ]
    [ x x x 0 0 ]
    [ 0 x x x 0 ]
    [ 0 0 x x x ]
    [ 0 0 0 x x ]

=cut

sub is_tridiag {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    $x -> is_band(1);
}

=pod

=item is_atridiag()

Returns 1 is the invocand is anti-tridiagonal, and 0 otherwise.

    $bool = $x -> is_tridiag();

A anti-tridiagonal matrix is a square matrix with nonzero elements only on the
anti-diagonal and slots horizontally or vertically adjacent the diagonal (i.e.,
along the anti-subdiagonal and anti-superdiagonal). It has the following
pattern, where only the elements marked as C<x> can be non-zero,

    [ 0 0 0 x x ]
    [ 0 0 x x x ]
    [ 0 x x x 0 ]
    [ x x x 0 0 ]
    [ x x 0 0 0 ]

=cut

sub is_atridiag {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    $x -> is_aband(1);
}

=pod

=item is_pentadiag()

Returns 1 is the invocand is pentadiagonal, and 0 otherwise.

    $bool = $x -> is_pentadiag();

A pentadiagonal matrix is a square matrix with nonzero elements only on the
diagonal and the two diagonals above and below the main diagonal. It has the
following pattern, where only the elements marked as C<x> can be non-zero,

    [ x x x 0 0 0 ]
    [ x x x x 0 0 ]
    [ x x x x x 0 ]
    [ 0 x x x x x ]
    [ 0 0 x x x x ]
    [ 0 0 0 x x x ]

=cut

sub is_pentadiag {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    $x -> is_band(2);
}

=pod

=item is_apentadiag()

Returns 1 is the invocand is anti-pentadiagonal, and 0 otherwise.

    $bool = $x -> is_pentadiag();

A anti-pentadiagonal matrix is a square matrix with nonzero elements only on the
anti-diagonal and two anti-diagonals above and below the main anti-diagonal. It
has the following pattern, where only the elements marked as C<x> can be
non-zero,

    [ 0 0 0 x x x ]
    [ 0 0 x x x x ]
    [ 0 x x x x x ]
    [ x x x x x 0 ]
    [ x x x x 0 0 ]
    [ x x x 0 0 0 ]

=cut

sub is_apentadiag {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    $x -> is_aband(2);
}

=pod

=item is_heptadiag()

Returns 1 is the invocand is heptadiagonal, and 0 otherwise.

    $bool = $x -> is_heptadiag();

A heptadiagonal matrix is a square matrix with nonzero elements only on the
diagonal and the two diagonals above and below the main diagonal. It has the
following pattern, where only the elements marked as C<x> can be non-zero,

    [ x x x x 0 0 ]
    [ x x x x x 0 ]
    [ x x x x x x ]
    [ x x x x x x ]
    [ 0 x x x x x ]
    [ 0 0 x x x x ]

=cut

sub is_heptadiag {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    $x -> is_band(3);
}

=pod

=item is_aheptadiag()

Returns 1 is the invocand is anti-heptadiagonal, and 0 otherwise.

    $bool = $x -> is_heptadiag();

A anti-heptadiagonal matrix is a square matrix with nonzero elements only on the
anti-diagonal and two anti-diagonals above and below the main anti-diagonal. It
has the following pattern, where only the elements marked as C<x> can be
non-zero,

    [ 0 0 x x x x ]
    [ 0 x x x x x ]
    [ x x x x x x ]
    [ x x x x x x ]
    [ x x x x x 0 ]
    [ x x x x 0 0 ]

=cut

sub is_aheptadiag {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    $x -> is_aband(3);
}

=pod

=item is_band()

Returns 1 is the invocand is a band matrix with a specified bandwidth, and 0
otherwise.

    $bool = $x -> is_band($k);

A band matrix is a square matrix with nonzero elements only on the diagonal and
on the C<$k> diagonals above and below the main diagonal. The bandwidth C<$k>
must be non-negative.

    $bool = $x -> is_band(0);   # is $x diagonal?
    $bool = $x -> is_band(1);   # is $x tridiagonal?
    $bool = $x -> is_band(2);   # is $x pentadiagonal?
    $bool = $x -> is_band(3);   # is $x heptadiagonal?

See also C<L</is_aband()>> and C<L</bandwidth()>>.

=cut

sub is_band {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my ($nrow, $ncol) = $x -> size();
    return 0 unless $nrow == $ncol;     # must be square

    my $k = shift;                      # bandwidth
    croak "Bandwidth can not be undefined" unless defined $k;
    if (ref $k) {
        $k = $class -> new($k)
          unless defined(blessed($k)) && $k -> isa($class);
        croak "Bandwidth must be a scalar" unless $k -> is_scalar();
        $k = $k -> [0][0];
    }

    return 0 if $nrow <= $k;            # if the band doesn't fit inside
    return 1 if $nrow == $k + 1;        # if the whole band fits exactly

    for my $i (0 .. $nrow - $k - 2) {
        for my $j ($k + 1 + $i .. $ncol - 1) {
            return 0 if ($x -> [$i][$j] != 0 ||
                         $x -> [$j][$i] != 0);
        }
    }

    return 1;
}

=pod

=item is_aband()

Returns 1 is the invocand is "anti-banded" with a specified bandwidth, and 0
otherwise.

    $bool = $x -> is_aband($k);

Some examples

    $bool = $x -> is_aband(0);  # is $x anti-diagonal?
    $bool = $x -> is_aband(1);  # is $x anti-tridiagonal?
    $bool = $x -> is_aband(2);  # is $x anti-pentadiagonal?
    $bool = $x -> is_aband(3);  # is $x anti-heptadiagonal?

A band matrix is a square matrix with nonzero elements only on the diagonal and
on the C<$k> diagonals above and below the main diagonal. The bandwidth C<$k>
must be non-negative.

A "anti-banded" matrix is a square matrix with nonzero elements only on the
anti-diagonal and C<$k> anti-diagonals above and below the main anti-diagonal.

See also C<L</is_band()>> and C<L</bandwidth()>>.

=cut

sub is_aband {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my ($nrow, $ncol) = $x -> size();
    return 0 unless $nrow == $ncol;     # must be square

    my $k = shift;                      # bandwidth
    croak "Bandwidth can not be undefined" unless defined $k;
    if (ref $k) {
        $k = $class -> new($k)
          unless defined(blessed($k)) && $k -> isa($class);
        croak "Bandwidth must be a scalar" unless $k -> is_scalar();
        $k = $k -> [0][0];
    }

    return 0 if $nrow <= $k;            # if the band doesn't fit inside
    return 1 if $nrow == $k + 1;        # if the whole band fits exactly

    # Check upper part.

    for my $i (0 .. $nrow - $k - 2) {
        for my $j (0 .. $nrow - $k - 2 - $i) {
            return 0 if $x -> [$i][$j] != 0;
        }
    }

    # Check lower part.

    for my $i ($k + 1 .. $nrow - 1) {
        for my $j ($nrow - $i + $k .. $nrow - 1) {
            return 0 if $x -> [$i][$j] != 0;
        }
    }

    return 1;
}

=pod

=item is_triu()

Returns 1 is the invocand is upper triangular, and 0 otherwise.

    $bool = $x -> is_triu();

An upper triangular matrix is a square matrix where all non-zero elements are on
or above the main diagonal. It has the following pattern, where only the
elements marked as C<x> can be non-zero. It has the following pattern, where
only the elements marked as C<x> can be non-zero,

    [ x x x x ]
    [ 0 x x x ]
    [ 0 0 x x ]
    [ 0 0 0 x ]

=cut

sub is_triu {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my $nrow = $x -> nrow();
    my $ncol = $x -> ncol();

    return 0 unless $nrow == $ncol;

    for my $i (1 .. $nrow - 1) {
        for my $j (0 .. $i - 1) {
            return 0 unless $x -> [$i][$j] == 0;
        }
    }

    return 1;
}

=pod

=item is_striu()

Returns 1 is the invocand is strictly upper triangular, and 0 otherwise.

    $bool = $x -> is_striu();

A strictly upper triangular matrix is a square matrix where all non-zero
elements are strictly above the main diagonal. It has the following pattern,
where only the elements marked as C<x> can be non-zero,

    [ 0 x x x ]
    [ 0 0 x x ]
    [ 0 0 0 x ]
    [ 0 0 0 0 ]

=cut

sub is_striu {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my $nrow = $x -> nrow();
    my $ncol = $x -> ncol();

    return 0 unless $nrow == $ncol;

    for my $i (0 .. $nrow - 1) {
        for my $j (0 .. $i) {
            return 0 unless $x -> [$i][$j] == 0;
        }
    }

    return 1;
}

=pod

=item is_tril()

Returns 1 is the invocand is lower triangular, and 0 otherwise.

    $bool = $x -> is_tril();

A lower triangular matrix is a square matrix where all non-zero elements are on
or below the main diagonal. It has the following pattern, where only the
elements marked as C<x> can be non-zero,

    [ x 0 0 0 ]
    [ x x 0 0 ]
    [ x x x 0 ]
    [ x x x x ]

=cut

sub is_tril {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my $nrow = $x -> nrow();
    my $ncol = $x -> ncol();

    return 0 unless $nrow == $ncol;

    for my $i (0 .. $nrow - 1) {
        for my $j ($i + 1 .. $ncol - 1) {
            return 0 unless $x -> [$i][$j] == 0;
        }
    }

    return 1;
}

=pod

=item is_stril()

Returns 1 is the invocand is strictly lower triangular, and 0 otherwise.

    $bool = $x -> is_stril();

A strictly lower triangular matrix is a square matrix where all non-zero
elements are strictly below the main diagonal. It has the following pattern,
where only the elements marked as C<x> can be non-zero,

    [ 0 0 0 0 ]
    [ x 0 0 0 ]
    [ x x 0 0 ]
    [ x x x 0 ]

=cut

sub is_stril {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my $nrow = $x -> nrow();
    my $ncol = $x -> ncol();

    return 0 unless $nrow == $ncol;

    for my $i (0 .. $nrow - 1) {
        for my $j ($i .. $ncol - 1) {
            return 0 unless $x -> [$i][$j] == 0;
        }
    }

    return 1;
}

=pod

=item is_atriu()

Returns 1 is the invocand is upper anti-triangular, and 0 otherwise.

    $bool = $x -> is_atriu();

An upper anti-triangular matrix is a square matrix where all non-zero elements
are on or above the main anti-diagonal. It has the following pattern, where only
the elements marked as C<x> can be non-zero,

    [ x x x x ]
    [ x x x 0 ]
    [ x x 0 0 ]
    [ x 0 0 0 ]

=cut

sub is_atriu {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my $nrow = $x -> nrow();
    my $ncol = $x -> ncol();

    return 0 unless $nrow == $ncol;

    for my $i (1 .. $nrow - 1) {
        for my $j ($ncol - $i .. $ncol - 1) {
            return 0 unless $x -> [$i][$j] == 0;
        }
    }

    return 1;
}

=pod

=item is_satriu()

Returns 1 is the invocand is strictly upper anti-triangular, and 0 otherwise.

    $bool = $x -> is_satriu();

A strictly anti-triangular matrix is a square matrix where all non-zero elements
are strictly above the main diagonal. It has the following pattern, where only
the elements marked as C<x> can be non-zero,

    [ x x x 0 ]
    [ x x 0 0 ]
    [ x 0 0 0 ]
    [ 0 0 0 0 ]

=cut

sub is_satriu {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my $nrow = $x -> nrow();
    my $ncol = $x -> ncol();

    return 0 unless $nrow == $ncol;

    for my $i (0 .. $nrow - 1) {
        for my $j ($ncol - $i - 1 .. $ncol - 1) {
            return 0 unless $x -> [$i][$j] == 0;
        }
    }

    return 1;
}

=pod

=item is_atril()

Returns 1 is the invocand is lower anti-triangular, and 0 otherwise.

    $bool = $x -> is_atril();

A lower anti-triangular matrix is a square matrix where all non-zero elements
are on or below the main anti-diagonal. It has the following pattern, where only
the elements marked as C<x> can be non-zero,

    [ 0 0 0 x ]
    [ 0 0 x x ]
    [ 0 x x x ]
    [ x x x x ]

=cut

sub is_atril {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my $nrow = $x -> nrow();
    my $ncol = $x -> ncol();

    return 0 unless $nrow == $ncol;

    for my $i (0 .. $nrow - 1) {
        for my $j (0 .. $ncol - $i - 2) {
            return 0 unless $x -> [$i][$j] == 0;
        }
    }

    return 1;
}

=pod

=item is_satril()

Returns 1 is the invocand is strictly lower anti-triangular, and 0 otherwise.

    $bool = $x -> is_satril();

A strictly lower anti-triangular matrix is a square matrix where all non-zero
elements are strictly below the main anti-diagonal. It has the following
pattern, where only the elements marked as C<x> can be non-zero,

    [ 0 0 0 0 ]
    [ 0 0 0 x ]
    [ 0 0 x x ]
    [ 0 x x x ]

=cut

sub is_satril {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my $nrow = $x -> nrow();
    my $ncol = $x -> ncol();

    return 0 unless $nrow == $ncol;

    for my $i (0 .. $nrow - 1) {
        for my $j (0 .. $ncol - $i - 1) {
            return 0 unless $x -> [$i][$j] == 0;
        }
    }

    return 1;
}

=pod

=back

=head2 Identify elements

This section contains methods for identifying and locating elements within an
array. See also C<L</Scalar comparison>>.

=over 4

=item find()

Returns the location of each non-zero element.

    $K = $x -> find();          # linear index
    ($I, $J) = $x -> find();    # subscripts

For example, to find the linear index of each element that is greater than or
equal to 1, use

    $K = $x -> sge(1) -> find();

=cut

sub find {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my ($m, $n) = $x -> size();

    my $I = [];
    my $J = [];
    for my $j (0 .. $n - 1) {
        for my $i (0 .. $m - 1) {
            next unless $x->[$i][$j];
            push @$I, $i;
            push @$J, $j;
        }
    }

    return $I, $J if wantarray;

    my $K = [ map { $m * $J -> [$_] + $I -> [$_] } 0 .. $#$I ];
    return $K;
}

=pod

=item is_finite()

Returns a matrix of ones and zeros. The element is one if the corresponding
element in the invocand matrix is finite, and zero otherwise.

    $y = $x -> is_finite();

=cut

sub is_finite {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    require Math::Trig;
    my $pinf = Math::Trig::Inf();       # positiv infinity
    my $ninf = -$pinf;                  # negative infinity

    bless [ map { [
                   map {
                       $ninf < $_ && $_ < $pinf ? 1 : 0
                   } @$_
                  ] } @$x ], ref $x;
}

=pod

=item is_inf()

Returns a matrix of ones and zeros. The element is one if the corresponding
element in the invocand matrix is positive or negative infinity, and zero
otherwise.

    $y = $x -> is_inf();

=cut

sub is_inf {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    require Math::Trig;
    my $pinf = Math::Trig::Inf();       # positiv infinity
    my $ninf = -$pinf;                  # negative infinity

    bless [ map { [
                   map {
                       $_ == $pinf || $_ == $ninf ? 1 : 0;
                   } @$_
                  ] } @$x ], ref $x;
}

=pod

=item is_nan()

Returns a matrix of ones and zeros. The element is one if the corresponding
element in the invocand matrix is a NaN (Not-a-Number), and zero otherwise.

    $y = $x -> is_nan();

=cut

sub is_nan {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    bless [ map [ map { $_ != $_ ? 1 : 0 } @$_ ], @$x ], ref $x;
}

=pod

=item all()

Tests whether all of the elements along various dimensions of a matrix are
non-zero. If the dimension argument is not given, the first non-singleton
dimension is used.

    $y = $x -> all($dim);
    $y = $x -> all();

=cut

sub all {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(\&_all, @_);
}

=pod

=item any()

Tests whether any of the elements along various dimensions of a matrix are
non-zero. If the dimension argument is not given, the first non-singleton
dimension is used.

    $y = $x -> any($dim);
    $y = $x -> any();

=cut

sub any {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(\&_any, @_);
}

=pod

=item cumall()

A cumulative variant of C<L</all()>>. If the dimension argument is not given,
the first non-singleton dimension is used.

    $y = $x -> cumall($dim);
    $y = $x -> cumall();

=cut

sub cumall {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(\&_cumall, @_);
}

=pod

=item cumany()

A cumulative variant of C<L</all()>>. If the dimension argument is not given,
the first non-singleton dimension is used.

    $y = $x -> cumany($dim);
    $y = $x -> cumany();

=cut

sub cumany {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(\&_cumany, @_);
}

=pod

=back

=head2 Basic properties

=over 4

=item size()

You can determine the dimensions of a matrix by calling:

    ($m, $n) = $a -> size;

=cut

sub size {
    my $self = shift;
    my $m = @{$self};
    my $n = $m ? @{$self->[0]} : 0;
    ($m, $n);
}

=pod

=item nelm()

Returns the number of elements in the matrix.

    $n = $x -> nelm();

=cut

sub nelm {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    return @$x ? @$x * @{$x->[0]} : 0;
}

=pod

=item nrow()

Returns the number of rows.

    $m = $x -> nrow();

=cut

sub nrow {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    return scalar @$x;
}

=pod

=item ncol()

Returns the number of columns.

    $n = $x -> ncol();

=cut

sub ncol {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    return @$x ? scalar(@{$x->[0]}) : 0;
}

=pod

=item npag()

Returns the number of pages. A non-matrix has one page.

    $n = $x -> pag();

=cut

sub npag {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    return @$x ? 1 : 0;
}

=pod

=item ndim()

Returns the number of dimensions. This is the number of dimensions along which
the length is different from one.

    $n = $x -> ndim();

=cut

sub ndim {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    my ($nrow, $ncol) = $x -> size();
    my $ndim = 0;
    ++$ndim if $nrow != 1;
    ++$ndim if $ncol != 1;
    return $ndim;
}

=pod

=item bandwidth()

Returns the bandwidth of a matrix. In scalar context, returns the number of the
non-zero diagonal furthest away from the main diagonal. In list context,
separate values are returned for the lower and upper bandwidth.

    $n = $x -> bandwidth();
    ($l, $u) = $x -> bandwidth();

The bandwidth is a non-negative integer. If the bandwidth is 0, the matrix is
diagonal or zero. If the bandwidth is 1, the matrix is tridiagonal. If the
bandwidth is 2, the matrix is pentadiagonal etc.

A matrix with the following pattern, where C<x> denotes a non-zero value, would
return 2 in scalar context, and (1,2) in list context.

    [ x x x 0 0 0 ]
    [ x x x x 0 0 ]
    [ 0 x x x x 0 ]
    [ 0 0 x x x x ]
    [ 0 0 0 x x x ]
    [ 0 0 0 0 x x ]

See also C<L</is_band()>> and C<L</is_aband()>>.

=cut

sub bandwidth {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my ($nrow, $ncol) = $x -> size();

    my $upper = 0;
    my $lower = 0;

    for my $i (0 .. $nrow - 1) {
        for my $j (0 .. $ncol - 1) {
            next if $x -> [$i][$j] == 0;
            my $dist = $j - $i;
            if ($dist > 0) {
                $upper = $dist if $dist > $upper;
            } else {
                $lower = $dist if $dist < $lower;
            }
        }
    }

    $lower = -$lower;
    return $lower, $upper if wantarray;
    return $lower > $upper ? $lower : $upper;
}

=pod

=back

=head2 Manipulate matrices

These methods are for combining matrices, splitting matrices, extracing parts of
a matrix, inserting new parts into a matrix, deleting parts of a matrix etc.
There are also methods for shuffling elements around (relocating elements)
inside a matrix.

These methods are not concerned with the values of the elements.

=over 4

=item catrow()

Concatenate rows, i.e., concatenate matrices vertically. Any number of arguments
is allowed. All non-empty matrices must have the same number or columns. The
result is a new matrix.

    $x = Math::Matrix -> new([1, 2], [4, 5]);   # 2-by-2 matrix
    $y = Math::Matrix -> new([3, 6]);           # 1-by-2 matrix
    $z = $x -> catrow($y);                      # 3-by-2 matrix

=cut

sub catrow {
    my $x = shift;
    my $class = ref $x;

    my $ncol;
    my $z = bless [], $class;           # initialize output

    for my $y ($x, @_) {
        my $ncoly = $y -> ncol();
        next if $ncoly == 0;            # ignore empty $y

        if (defined $ncol) {
            croak "All operands must have the same number of columns in ",
              (caller(0))[3] unless $ncoly == $ncol;
        } else {
            $ncol = $ncoly;
        }

        push @$z, map [ @$_ ], @$y;
    }

    return $z;
}

=pod

=item catcol()

Concatenate columns, i.e., matrices horizontally. Any number of arguments is
allowed. All non-empty matrices must have the same number or rows. The result is
a new matrix.

    $x = Math::Matrix -> new([1, 2], [4, 5]);   # 2-by-2 matrix
    $y = Math::Matrix -> new([3], [6]);         # 2-by-1 matrix
    $z = $x -> catcol($y);                      # 2-by-3 matrix

=cut

sub catcol {
    my $x = shift;
    my $class = ref $x;

    my $nrow;
    my $z = bless [], $class;           # initialize output

    for my $y ($x, @_) {
        my $nrowy = $y -> nrow();
        next if $nrowy == 0;            # ignore empty $y

        if (defined $nrow) {
            croak "All operands must have the same number of rows in ",
              (caller(0))[3] unless $nrowy == $nrow;
        } else {
            $nrow = $nrowy;
        }

        for my $i (0 .. $nrow - 1) {
            push @{ $z -> [$i] }, @{ $y -> [$i] };
        }
    }

    return $z;
}

=pod

=item getrow()

Get the specified row(s). Returns a new matrix with the specified rows. The
number of rows in the output is identical to the number of elements in the
input.

    $y = $x -> getrow($i);                  # get one
    $y = $x -> getrow([$i0, $i1, $i2]);     # get multiple

=cut

sub getrow {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $idx = shift;
    croak "Row index can not be undefined" unless defined $idx;
    if (ref $idx) {
        $idx = __PACKAGE__ -> new($idx)
          unless defined(blessed($idx)) && $idx -> isa($class);
        $idx = $idx -> to_row();
        $idx = $idx -> [0];
    } else {
        $idx = [ $idx ];
    }

    my ($nrowx, $ncolx) = $x -> size();

    my $y = [];
    for my $iy (0 .. $#$idx) {
        my $ix = $idx -> [$iy];
        croak "Row index value $ix too large for $nrowx-by-$ncolx matrix in ",
          (caller(0))[3] if $ix >= $nrowx;
        $y -> [$iy] = [ @{ $x -> [$ix] } ];
    }

    bless $y, $class;
}

=pod

=item getcol()

Get the specified column(s). Returns a new matrix with the specified columns.
The number of columns in the output is identical to the number of elements in
the input.

    $y = $x -> getcol($j);                  # get one
    $y = $x -> getcol([$j0, $j1, $j2]);     # get multiple

=cut

sub getcol {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $idx = shift;
    croak "Column index can not be undefined" unless defined $idx;
    if (ref $idx) {
        $idx = __PACKAGE__ -> new($idx)
          unless defined(blessed($idx)) && $idx -> isa($class);
        $idx = $idx -> to_row();
        $idx = $idx -> [0];
    } else {
        $idx = [ $idx ];
    }

    my ($nrowx, $ncolx) = $x -> size();

    my $y = [];
    for my $jy (0 .. $#$idx) {
        my $jx = $idx -> [$jy];
        croak "Column index value $jx too large for $nrowx-by-$ncolx matrix in ",
          (caller(0))[3] if $jx >= $ncolx;
        for my $i (0 .. $nrowx - 1) {
            $y -> [$i][$jy] = $x -> [$i][$jx];
        }
    }

    bless $y, $class;
}

=pod

=item delrow()

Delete row(s). Returns a new matrix identical to the invocand but with the
specified row(s) deleted.

    $y = $x -> delrow($i);                  # delete one
    $y = $x -> delrow([$i0, $i1, $i2]);     # delete multiple

=cut

sub delrow {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $idxdel = shift;
    croak "Row index can not be undefined" unless defined $idxdel;
    if (ref $idxdel) {
        $idxdel = __PACKAGE__ -> new($idxdel)
          unless defined(blessed($idxdel)) && $idxdel -> isa($class);
        $idxdel = $idxdel -> to_row();
        $idxdel = $idxdel -> [0];
    } else {
        $idxdel = [ $idxdel ];
    }

    my $nrowx = $x -> nrow();

    # This should be made faster.

    my $idxget = [];
    for my $i (0 .. $nrowx - 1) {
        my $seen = 0;
        for my $idx (@$idxdel) {
            if ($i == int $idx) {
                $seen = 1;
                last;
            }
        }
        push @$idxget, $i unless $seen;
    }

    my $y = [];
    @$y = map [ @$_ ], @$x[ @$idxget ];
    bless $y, $class;
}

=pod

=item delcol()

Delete column(s). Returns a new matrix identical to the invocand but with the
specified column(s) deleted.

    $y = $x -> delcol($j);                  # delete one
    $y = $x -> delcol([$j0, $j1, $j2]);     # delete multiple

=cut

sub delcol {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $idxdel = shift;
    croak "Column index can not be undefined" unless defined $idxdel;
    if (ref $idxdel) {
        $idxdel = __PACKAGE__ -> new($idxdel)
          unless defined(blessed($idxdel)) && $idxdel -> isa($class);
        $idxdel = $idxdel -> to_row();
        $idxdel = $idxdel -> [0];
    } else {
        $idxdel = [ $idxdel ];
    }

    my ($nrowx, $ncolx) = $x -> size();

    # This should be made faster.

    my $idxget = [];
    for my $j (0 .. $ncolx - 1) {
        my $seen = 0;
        for my $idx (@$idxdel) {
            if ($j == int $idx) {
                $seen = 1;
                last;
            }
        }
        push @$idxget, $j unless $seen;
    }

    my $y = [];
    if (@$idxget) {
        for my $row (@$x) {
            push @$y, [ @{$row}[ @$idxget ] ];
        }
    }
    bless $y, $class;
}

=pod

=item concat()

Concatenate two matrices horizontally. The matrices must have the same number of
rows. The result is a new matrix or B<undef> in case of error.

    $x = Math::Matrix -> new([1, 2], [4, 5]);   # 2-by-2 matrix
    $y = Math::Matrix -> new([3], [6]);         # 2-by-1 matrix
    $z = $x -> concat($y);                      # 2-by-3 matrix

=cut

sub concat {
    my $self   = shift;
    my $other  = shift;
    my $result =  $self->clone();

    return undef if scalar(@{$self}) != scalar(@{$other});
    for my $i (0 .. $#{$self}) {
        push @{$result->[$i]}, @{$other->[$i]};
    }
    $result;
}

=pod

=item splicerow()

Row splicing. This is like Perl's built-in splice() function, except that it
works on the rows of a matrix.

    $y = $x -> splicerow($offset);
    $y = $x -> splicerow($offset, $length);
    $y = $x -> splicerow($offset, $length, $a, $b, ...);

The built-in splice() function modifies the first argument and returns the
removed elements, if any. However, since splicerow() does not modify the
invocand, it returns the modified version as the first output argument and the
removed part as a (possibly empty) second output argument.

    $x = Math::Matrix -> new([[ 1,  2],
                              [ 3,  4],
                              [ 5,  6],
                              [ 7,  8]]);
    $a = Math::Matrix -> new([[11, 12],
                              [13, 14]]);
    ($y, $z) = $x -> splicerow(1, 2, $a);

Gives C<$y>

    [  1  2 ]
    [ 11 12 ]
    [ 13 14 ]
    [  7  8 ]

and C<$z>

    [  3  4 ]
    [  5  6 ]

=cut

sub splicerow {
    croak "Not enough input arguments" if @_ < 1;
    my $x = shift;
    my $class = ref $x;

    my $offs = 0;
    my $len  = $x -> nrow();
    my $repl = $class -> new([]);

    if (@_) {
        $offs = shift;
        croak "Offset can not be undefined" unless defined $offs;
        if (ref $offs) {
            $offs = $class -> new($offs)
              unless defined(blessed($offs)) && $offs -> isa($class);
            croak "Offset must be a scalar" unless $offs -> is_scalar();
            $offs = $offs -> [0][0];
        }

        if (@_) {
            $len = shift;
            croak "Length can not be undefined" unless defined $len;
            if (ref $len) {
                $len = $class -> new($len)
                  unless defined(blessed($len)) && $len -> isa($class);
                croak "length must be a scalar" unless $len -> is_scalar();
                $len = $len -> [0][0];
            }

            if (@_) {
                $repl = $repl -> catrow(@_);
            }
        }
    }

    my $y = $x -> clone();
    my $z = $class -> new([]);

    @$z = splice @$y, $offs, $len, @$repl;
    return wantarray ? ($y, $z) : $y;
}

=pod

=item splicecol()

Column splicing. This is like Perl's built-in splice() function, except that it
works on the columns of a matrix.

    $y = $x -> splicecol($offset);
    $y = $x -> splicecol($offset, $length);
    $y = $x -> splicecol($offset, $length, $a, $b, ...);

The built-in splice() function modifies the first argument and returns the
removed elements, if any. However, since splicecol() does not modify the
invocand, it returns the modified version as the first output argument and the
removed part as a (possibly empty) second output argument.

    $x = Math::Matrix -> new([[ 1, 3, 5, 7 ],
                              [ 2, 4, 6, 8 ]]);
    $a = Math::Matrix -> new([[11, 13],
                              [12, 14]]);
    ($y, $z) = $x -> splicerow(1, 2, $a);

Gives C<$y>

    [ 1  11  13  7 ]
    [ 2  12  14  8 ]

and C<$z>

    [ 3  5 ]
    [ 4  6 ]

=cut

sub splicecol {
    croak "Not enough input arguments" if @_ < 1;
    my $x = shift;
    my $class = ref $x;

    my ($nrowx, $ncolx) = $x -> size();

    my $offs = 0;
    my $len  = $ncolx;
    my $repl = $class -> new([]);

    if (@_) {
        $offs = shift;
        croak "Offset can not be undefined" unless defined $offs;
        if (ref $offs) {
            $offs = $class -> new($offs)
              unless defined(blessed($offs)) && $offs -> isa($class);
            croak "Offset must be a scalar" unless $offs -> is_scalar();
            $offs = $offs -> [0][0];
        }

        if (@_) {
            $len = shift;
            croak "Length can not be undefined" unless defined $len;
            if (ref $len) {
                $len = $class -> new($len)
                  unless defined(blessed($len)) && $len -> isa($class);
                croak "length must be a scalar" unless $len -> is_scalar();
                $len = $len -> [0][0];
            }

            if (@_) {
                $repl = $repl -> catcol(@_);
            }
        }
    }

    my $y = $x -> clone();
    my $z = $class -> new([]);

    if ($offs > $len) {
        carp "splicecol() offset past end of array";
        $offs = $len;
    }

    # The case when we are not removing anything from the invocand matrix: If
    # the offset is identical to the number of columns in the invocand matrix,
    # just appending the replacement matrix to the invocand matrix.

    if ($offs == $len) {
        unless ($repl -> is_empty()) {
            for my $i (0 .. $nrowx - 1) {
                push @{ $y -> [$i] }, @{ $repl -> [$i] };
            }
        }
    }

    # The case when we are removing everything from the invocand matrix: If the
    # offset is zero, and the length is identical to the number of columns in
    # the invocand matrix, replace the whole invocand matrix with the
    # replacement matrix.

    elsif ($offs == 0 && $len == $ncolx) {
        @$z = @$y;
        @$y = @$repl;
    }

    # The case when we are removing parts of the invocand matrix.

    else {
        if ($repl -> is_empty()) {
            for my $i (0 .. $nrowx - 1) {
                @{ $z -> [$i] } = splice @{ $y -> [$i] }, $offs, $len;
            }
        } else {
            for my $i (0 .. $nrowx - 1) {
                @{ $z -> [$i] } = splice @{ $y -> [$i] }, $offs, $len, @{ $repl -> [$i] };
            }
        }
    }

    return wantarray ? ($y, $z) : $y;
}

=pod

=item swaprc()

Swap rows and columns. This method does nothing but shuffle elements around. For
real numbers, swaprc() is identical to the transpose() method.

A subclass implementing a matrix of complex numbers should provide a transpose()
method that also takes the complex conjugate of each elements. The swaprc()
method, on the other hand, should only shuffle elements around.

=cut

sub swaprc {
    my $x = shift;
    my $class = ref $x;

    my $y = bless [], $class;
    my $ncolx = $x -> ncol();
    return $y if $ncolx == 0;

    for my $j (0 .. $ncolx - 1) {
        push @$y, [ map $_->[$j], @$x ];
    }
    return $y;
}

=pod

=item flipud()

Flip upside-down, i.e., flip along dimension 1.

    $y = $x -> flipud();

=cut

sub flipud {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    my $class = ref $x;

    my $y = [ reverse map [ @$_ ], @$x ];
    bless $y, $class;;
}

=pod

=item fliplr()

Flip left-to-right, i.e., flip along dimension 2.

    $y = $x -> fliplr();

=cut

sub fliplr {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    my $class = ref $x;

    my $y = [ map [ reverse @$_ ], @$x ];
    bless $y, $class;
}

=pod

=item flip()

Flip along various dimensions of a matrix. If the dimension argument is not
given, the first non-singleton dimension is used.

    $y = $x -> flip($dim);
    $y = $x -> flip();

See also C<L</flipud()>> and C<L</fliplr()>>.

=cut

sub flip {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(sub { reverse @_ }, @_);
}

=pod

=item rot90()

Rotate 90 degrees counterclockwise.

    $y = $x -> rot90();     # rotate 90 degrees counterclockwise
    $y = $x -> rot90($n);   # rotate 90*$n degrees counterclockwise

=cut

sub rot90 {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $n = 1;
    if (@_) {
        $n = shift;
        if (ref $n) {
            $n = $class -> new($n)
              unless defined(blessed($n)) && $n -> isa($class);
            croak "Argument must be a scalar" unless $n -> is_scalar();
            $n = $n -> [0][0];
        }
        croak "Argument must be an integer" unless $n == int $n;
    }

    my $y = [];

    # Rotate 0 degrees, i.e., clone.

    $n %= 4;
    if ($n == 0) {
        $y = [ map [ @$_ ], @$x ];
    }

    # Rotate 90 degrees.

    elsif ($n == 1) {
        my ($nrowx, $ncolx) = $x -> size();
        my $jmax = $ncolx - 1;
        for my $i (0 .. $nrowx - 1) {
            for my $j (0 .. $ncolx - 1) {
                $y -> [$jmax - $j][$i] = $x -> [$i][$j];
            }
        }
    }

    # Rotate 180 degrees.

    elsif ($n == 2) {
        $y = [ map [ reverse @$_ ], reverse @$x ];
    }

    # Rotate 270 degrees.

    elsif ($n == 3) {
        my ($nrowx, $ncolx) = $x -> size();
        my $imax = $nrowx - 1;
        for my $i (0 .. $nrowx - 1) {
            for my $j (0 .. $ncolx - 1) {
                $y -> [$j][$imax - $i] = $x -> [$i][$j];
            }
        }
    }

    bless $y, $class;
}

=pod

=item rot180()

Rotate 180 degrees.

    $y = $x -> rot180();

=cut

sub rot180 {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    $x -> rot90(2);
}

=pod

=item rot270()

Rotate 270 degrees counterclockwise, i.e., 90 degrees clockwise.

    $y = $x -> rot270();

=cut

sub rot270 {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    $x -> rot90(3);
}

=pod

=item repelm()

Repeat elements.

    $x -> repelm($y);

Repeats each element in $x the number of times specified in $y.

If $x is the matrix

    [ 4 5 6 ]
    [ 7 8 9 ]

and $y is

    [ 3 2 ]

the returned matrix is

    [ 4 4 5 5 6 6 ]
    [ 4 4 5 5 6 6 ]
    [ 4 4 5 5 6 6 ]
    [ 7 7 8 8 9 9 ]
    [ 7 7 8 8 9 9 ]
    [ 7 7 8 8 9 9 ]

=cut

sub repelm {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = __PACKAGE__ -> new($y)
      unless defined(blessed($y)) && $y -> isa(__PACKAGE__);
    croak "Input argument must contain two elements"
      unless $y -> nelm() == 2;

    my ($nrowx, $ncolx) = $x -> size();

    $y = $y -> to_col();
    my $nrowrep = $y -> [0][0];
    my $ncolrep = $y -> [1][0];

    my $z = [];
    for my $ix (0 .. $nrowx - 1) {
        for my $jx (0 .. $ncolx - 1) {
            for my $iy (0 .. $nrowrep - 1) {
                for my $jy (0 .. $ncolrep - 1) {
                    my $iz = $ix * $nrowrep + $iy;
                    my $jz = $jx * $ncolrep + $jy;
                    $z -> [$iz][$jz] = $x -> [$ix][$jx];
                }
            }
        }
    }

    bless $z, $class;
}

=pod

=item repmat()

Repeat elements.

    $x -> repmat($y);

Repeats the matrix $x the number of times specified in $y.

If $x is the matrix

    [ 4 5 6 ]
    [ 7 8 9 ]

and $y is

    [ 3 2 ]

the returned matrix is

    [ 4 5 6 4 5 6 ]
    [ 7 8 9 7 8 9 ]
    [ 4 5 6 4 5 6 ]
    [ 7 8 9 7 8 9 ]
    [ 4 5 6 4 5 6 ]
    [ 7 8 9 7 8 9 ]

=cut

sub repmat {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = __PACKAGE__ -> new($y)
      unless defined(blessed($y)) && $y -> isa(__PACKAGE__);
    croak "Input argument must contain two elements"
      unless $y -> nelm() == 2;

    my ($nrowx, $ncolx) = $x -> size();

    $y = $y -> to_col();
    my $nrowrep = $y -> [0][0];
    my $ncolrep = $y -> [1][0];

    my $z = [];
    for my $ix (0 .. $nrowx - 1) {
        for my $jx (0 .. $ncolx - 1) {
            for my $iy (0 .. $nrowrep - 1) {
                for my $jy (0 .. $ncolrep - 1) {
                    my $iz = $iy * $nrowx + $ix;
                    my $jz = $jy * $ncolx + $jx;
                    $z -> [$iz][$jz] = $x -> [$ix][$jx];
                }
            }
        }
    }

    bless $z, $class;
}

=pod

=item reshape()

Returns a reshaped copy of a matrix. The reshaping is done by creating a new
matrix and looping over the elements in column major order. The new matrix must
have the same number of elements as the invocand matrix. The following returns
an C<$m>-by-C<$n> matrix,

    $y = $x -> reshape($m, $n);

The code

    $x = Math::Matrix -> new([[1, 3, 5, 7], [2, 4, 6, 8]]);
    $y = $x -> reshape(4, 2);

creates the matrix $x

    [ 1  3  5  7 ]
    [ 2  4  6  8 ]

and returns a reshaped copy $y

    [ 1  5 ]
    [ 2  6 ]
    [ 3  7 ]
    [ 4  8 ]

=cut

sub reshape {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 3;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 3;
    my $x = shift;
    my $class = ref $x;

    my ($nrowx, $ncolx) = $x -> size();
    my $nelmx = $nrowx * $ncolx;

    my ($nrowy, $ncoly) = @_;
    my $nelmy = $nrowy * $ncoly;

    croak "when reshaping, the number of elements can not change in ",
      (caller(0))[3] unless $nelmx == $nelmy;

    my $y = [];

    # No reshaping; just clone.

    if ($nrowx == $nrowy && $ncolx == $ncoly) {
        $y = [ map [ @$_ ], @$x ];
    }

    elsif ($nrowx == 1) {

        # Reshape from a row vector to a column vector.

        if ($ncoly == 1) {
            $y = [ map [ $_ ], @{ $x -> [0] } ];
        }

        # Reshape from a row vector to a matrix.

        else {
            my $k = 0;
            for my $j (0 .. $ncoly - 1) {
                for my $i (0 .. $nrowy - 1) {
                    $y -> [$i][$j] = $x -> [0][$k++];
                }
            }
        }
    }

    elsif ($ncolx == 1) {

        # Reshape from a column vector to a row vector.

        if ($nrowy == 1) {
            $y = [[ map { @$_ } @$x ]];
        }

        # Reshape from a column vector to a matrix.

        else {
            my $k = 0;
            for my $j (0 .. $ncoly - 1) {
                for my $i (0 .. $nrowy - 1) {
                    $y -> [$i][$j] = $x -> [$k++][0];
                }
            }
        }
    }

    # The invocand is a matrix. This code works in all cases, but is somewhat
    # slower than the specialized code above.

    else {
        for my $k (0 .. $nelmx - 1) {
            my $ix = $k % $nrowx;
            my $jx = ($k - $ix) / $nrowx;
            my $iy = $k % $nrowy;
            my $jy = ($k - $iy) / $nrowy;
            $y -> [$iy][$jy] = $x -> [$ix][$jx];
        }
    }

    bless $y, $class;
}

=pod

=item to_row()

Reshape to a row.

    $x -> to_row();

This method reshapes the matrix into a single row. It is essentially the same
as, but faster than,

    $x -> reshape(1, $x -> nelm());

=cut

sub to_row {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    my $class = ref $x;

    my $y = bless [], $class;

    my $ncolx = $x -> ncol();
    return $y if $ncolx == 0;

    for my $j (0 .. $ncolx - 1) {
        push @{ $y -> [0] }, map $_->[$j], @$x;
    }
    return $y;
}

=pod

=item to_col()

Reshape to a column.

    $y = $x -> to_col();

This method reshapes the matrix into a single column. It is essentially the same
as, but faster than,

    $x -> reshape($x -> nelm(), 1);

=cut

sub to_col {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my $class = ref $x;

    my $y = bless [], $class;

    my $ncolx = $x -> ncol();
    return $y if $ncolx == 0;

    for my $j (0 .. $ncolx - 1) {
        push @$y, map [ $_->[$j] ], @$x;
    }
    return $y;
}

=pod

=item to_permmat()

Permutation vector to permutation matrix. Converts a vector of zero-based
permutation indices to a permutation matrix.

    $P = $v -> to_permmat();

For example

    $v = Math::Matrix -> new([[0, 3, 1, 4, 2]]);
    $m = $v -> to_permmat();

gives the permutation matrix C<$m>

    [ 1 0 0 0 0 ]
    [ 0 0 0 1 0 ]
    [ 0 1 0 0 0 ]
    [ 0 0 0 0 1 ]
    [ 0 0 1 0 0 ]

=cut

sub to_permmat {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $v = shift;
    my $class = ref $v;

    my $n = $v -> nelm();
    my $P = $class -> zeros($n, $n);    # initialize output
    return $P if $n == 0;               # if emtpy $v

    croak "Invocand must be a vector" unless $v -> is_vector();
    $v = $v -> to_col();

    for my $i (0 .. $n - 1) {
        my $j = $v -> [$i][0];
        croak "index out of range" unless 0 <= $j && $j < $n;
        $P -> [$i][$j] = 1;
    }

    return $P;
}

=pod

=item to_permvec()

Permutation matrix to permutation vector. Converts a permutation matrix to a
vector of zero-based permutation indices.

    $v = $P -> to_permvec();

    $v = Math::Matrix -> new([[0, 3, 1, 4, 2]]);
    $m = $v -> to_permmat();

Gives the permutation matrix C<$m>

    [ 1 0 0 0 0 ]
    [ 0 0 0 1 0 ]
    [ 0 1 0 0 0 ]
    [ 0 0 0 0 1 ]
    [ 0 0 1 0 0 ]

See also C<L</to_permmat()>>.

=cut

sub to_permvec {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $P = shift;
    my $class = ref $P;

    croak "Invocand matrix must be square" unless $P -> is_square();
    my $n = $P -> nrow();

    my $v = $class -> zeros($n, 1);     # initialize output

    my $seen = [ (0) x $n ];            # keep track of the ones

    for my $i (0 .. $n - 1) {
        my $k;
        for my $j (0 .. $n - 1) {
            next if $P -> [$i][$j] == 0;
            if ($P -> [$i][$j] == 1) {
                croak "invalid permutation matrix; more than one row has",
                  " an element with value 1 in column $j" if $seen->[$j]++;
                $k = $j;
                next;
            }
            croak "invalid permutation matrix; element ($i,$j)",
              " is neither 0 nor 1";
        }
        croak "invalid permutation matrix; row $i has no element with value 1"
          unless defined $k;
        $v->[$i][0] = $k;
    }

    return $v;
}

=pod

=item triu()

Upper triangular part. Extract the upper triangular part of a matrix and set all
other elements to zero.

    $y = $x -> triu();
    $y = $x -> triu($n);

The optional second argument specifies how many diagonals above or below the
main diagonal should also be set to zero. The default value of C<$n> is zero
which includes the main diagonal.

=cut

sub triu {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $n = 0;
    if (@_) {
        $n = shift;
        if (ref $n) {
            $n = $class -> new($n)
              unless defined(blessed($n)) && $n -> isa($class);
            croak "Argument must be a scalar" unless $n -> is_scalar();
            $n = $n -> [0][0];
        }
        croak "Argument must be an integer" unless $n == int $n;
    }

    my ($nrowx, $ncolx) = $x -> size();

    my $y = [];
    for my $i (0 .. $nrowx - 1) {
        for my $j (0 .. $ncolx - 1) {
            $y -> [$i][$j] = $j - $i >= $n ? $x -> [$i][$j] : 0;
        }
    }

    bless $y, $class;
}

=pod

=item tril()

Lower triangular part. Extract the lower triangular part of a matrix and set all
other elements to zero.

    $y = $x -> tril();
    $y = $x -> tril($n);

The optional second argument specifies how many diagonals above or below the
main diagonal should also be set to zero. The default value of C<$n> is zero
which includes the main diagonal.

=cut

sub tril {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $n = 0;
    if (@_) {
        $n = shift;
        if (ref $n) {
            $n = $class -> new($n)
              unless defined(blessed($n)) && $n -> isa($class);
            croak "Argument must be a scalar" unless $n -> is_scalar();
            $n = $n -> [0][0];
        }
        croak "Argument must be an integer" unless $n == int $n;
    }

    my ($nrowx, $ncolx) = $x -> size();

    my $y = [];
    for my $i (0 .. $nrowx - 1) {
        for my $j (0 .. $ncolx - 1) {
            $y -> [$i][$j] = $j - $i <= $n ? $x -> [$i][$j] : 0;
        }
    }

    bless $y, $class;
}

=pod

=item slice()

Extract columns:

    a->slice(1,3,5);

=cut

sub slice {
    my $self = shift;
    my $class = ref($self);
    my $result = [];

    for my $i (0 .. $#$self) {
        push @$result, [ @{$self->[$i]}[@_] ];
    }

    bless $result, $class;
}

=pod

=item diagonal_vector()

Extract the diagonal as an array:

    $diag = $a->diagonal_vector;

=cut

sub diagonal_vector {
    my $self = shift;
    my @diag;
    my $idx = 0;
    my($m, $n) = $self->size();

    croak "Not a square matrix" if $m != $n;

    foreach my $r (@{$self}) {
        push @diag, $r->[$idx++];
    }
    return \@diag;
}

=pod

=item tridiagonal_vector()

Extract the diagonals that make up a tridiagonal matrix:

    ($main_d, $upper_d, $lower_d) = $a->tridiagonal_vector;

=cut

sub tridiagonal_vector {
    my $self = shift;
    my(@main_d, @up_d, @low_d);
    my($m, $n) = $self->size();
    my $idx = 0;

    croak "Not a square matrix" if $m != $n;

    foreach my $r (@{$self}) {
        push @low_d, $r->[$idx - 1] if ($idx > 0);
        push @main_d, $r->[$idx++];
        push @up_d, $r->[$idx] if ($idx < $m);
    }
    return ([@main_d],[@up_d],[@low_d]);
}

=pod

=back

=head2 Mathematical functions

=head3 Addition

=over 4

=item add()

Addition. If one operands is a scalar, it is treated like a constant matrix with
the same size as the other operand. Otherwise ordinary matrix addition is
performed.

    $z = $x -> add($y);

See also C<L</madd()>> and C<L</sadd()>>.

=cut

sub add {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y) unless defined(blessed($y)) && $y -> isa($class);

    $x -> is_scalar() || $y -> is_scalar() ? $x -> sadd($y) : $x -> madd($y);
}

=pod

=item madd()

Matrix addition. Add two matrices of the same dimensions. An error is thrown if
the matrices don't have the same size.

    $z = $x -> madd($y);

See also C<L</add()>> and C<L</sadd()>>.

=cut

sub madd {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y) unless defined(blessed($y)) && $y -> isa($class);

    my ($nrowx, $ncolx) = $x -> size();
    my ($nrowy, $ncoly) = $y -> size();

    croak "Can't add $nrowx-by-$ncolx matrix to $nrowy-by-$ncoly matrix"
      unless $nrowx == $nrowy && $ncolx == $ncoly;

    my $z = [];
    for my $i (0 .. $nrowx - 1) {
        for my $j (0 .. $ncolx - 1) {
            $z->[$i][$j] = $x->[$i][$j] + $y->[$i][$j];
        }
    }

    bless $z, $class;
}

=pod

=item sadd()

Scalar (element by element) addition with scalar expansion. This method places
no requirements on the size of the input matrices.

    $z = $x -> sadd($y);

See also C<L</add()>> and C<L</madd()>>.

=cut

sub sadd {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;

    my $sub = sub { $_[0] + $_[1] };
    $x -> sapply($sub, @_);
}

=pod

=back

=head3 Subtraction

=over 4

=item sub()

Subtraction. If one operands is a scalar, it is treated as a constant matrix
with the same size as the other operand. Otherwise, ordinarly matrix subtraction
is performed.

    $z = $x -> sub($y);

See also C<L</msub()>> and C<L</ssub()>>.

=cut

sub sub {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y) unless defined(blessed($y)) && $y -> isa($class);

    $x -> is_scalar() || $y -> is_scalar() ? $x -> ssub($y) : $x -> msub($y);
}

=pod

=item msub()

Matrix subtraction. Subtract two matrices of the same size. An error is thrown
if the matrices don't have the same size.

    $z = $x -> msub($y);

See also C<L</sub()>> and C<L</ssub()>>.

=cut

sub msub {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y) unless defined(blessed($y)) && $y -> isa($class);

    my ($nrowx, $ncolx) = $x -> size();
    my ($nrowy, $ncoly) = $y -> size();

    croak "Can't subtract $nrowy-by-$ncoly matrix from $nrowx-by-$ncolx matrix"
      unless $nrowx == $nrowy && $ncolx == $ncoly;

    my $z = [];
    for my $i (0 .. $nrowx - 1) {
        for my $j (0 .. $ncolx - 1) {
            $z->[$i][$j] = $x->[$i][$j] - $y->[$i][$j];
        }
    }

    bless $z, $class;
}

=pod

=item ssub()

Scalar (element by element) subtraction with scalar expansion. This method
places no requirements on the size of the input matrices.

    $z = $x -> ssub($y);

See also C<L</sub()>> and C<L</msub()>>.

=cut

sub ssub {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;

    my $sub = sub { $_[0] - $_[1] };
    $x -> sapply($sub, @_);
}

=pod

=item subtract()

This is an alias for C<L</msub()>>.

=cut

sub subtract {
    my $x = shift;
    $x -> sub(@_);
}

=pod

=back

=head3 Negation

=over 4

=item neg()

Negation. Negate a matrix.

    $y = $x -> neg();

It is effectively equivalent to

    $y = $x -> map(sub { -$_ });

=cut

sub neg {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    bless [ map [ map -$_, @$_ ], @$x ], ref $x;
}

=pod

=item negative()

This is an alias for C<L</neg()>>.

=cut

sub negative {
    my $x = shift;
    $x -> neg(@_);
}

=pod

=back

=head3 Multiplication

=over 4

=item mul()

Multiplication. If one operands is a scalar, it is treated as a constant matrix
with the same size as the other operand. Otherwise, ordinary matrix
multiplication is performed.

    $z = $x -> mul($y);

=cut

sub mul {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y) unless defined(blessed($y)) && $y -> isa($class);

    $x -> is_scalar() || $y -> is_scalar() ? $x -> smul($y) : $x -> mmul($y);
}

=pod

=item mmul()

Matrix multiplication. An error is thrown if the sizes don't match; the number
of columns in the first operand must be equal to the number of rows in the
second operand.

    $z = $x -> mmul($y);

=cut

sub mmul {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y) unless defined(blessed($y)) && $y -> isa($class);

    my $mx = $x -> nrow();
    my $nx = $x -> ncol();

    my $my = $y -> nrow();
    my $ny = $y -> ncol();

    croak "Can't multiply $mx-by-$nx matrix with $my-by-$ny matrix"
      unless $nx == $my;

    my $z = [];
    my $l = $nx - 1;            # "inner length"
    for my $i (0 .. $mx - 1) {
        for my $j (0 .. $ny - 1) {
            $z -> [$i][$j] = _sum(map $x -> [$i][$_] * $y -> [$_][$j], 0 .. $l);
        }
    }

    bless $z, $class;
}

=pod

=item smul()

Scalar (element by element) multiplication with scalar expansion. This method
places no requirements on the size of the input matrices.

    $z = $x -> smul($y);

=cut

sub smul {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;

    my $sub = sub { $_[0] * $_[1] };
    $x -> sapply($sub, @_);
}

=pod

=item mmuladd()

Matrix fused multiply and add. If C<$x> is a C<$p>-by-C<$q> matrix, then C<$y>
must be a C<$q>-by-C<$r> matrix and C<$z> must be a C<$p>-by-C<$r> matrix. An
error is thrown if the sizes don't match.

    $w = $x -> mmuladd($y, $z);

The fused multiply and add is equivalent to, but computed with higher accuracy
than

    $w = $x -> mmul($y) -> madd($z);

This method can be used to improve the solution of linear systems.

=cut

sub mmuladd {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 3;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 3;
    my $x = shift;
    my $class = ref $x;

    my ($mx, $nx) = $x -> size();

    my $y = shift;
    $y = $class -> new($y) unless defined(blessed($y)) && $y -> isa($class);
    my ($my, $ny) = $y -> size();

    croak "Can't multiply $mx-by-$nx matrix with $my-by-$ny matrix"
      unless $nx == $my;

    my $z = shift;
    $z = $class -> new($z) unless defined(blessed($z)) && $z -> isa($class);
    my ($mz, $nz) = $z -> size();

    croak "Can't add $mz-by-$nz matrix to $mx-by-$ny matrix"
      unless $mz == $mx && $nz == $ny;

    my $w = [];
    my $l = $nx - 1;            # "inner length"
    for my $i (0 .. $mx - 1) {
        for my $j (0 .. $ny - 1) {
            $w -> [$i][$j]
              = _sum(map($x -> [$i][$_] * $y -> [$_][$j], 0 .. $l),
                     $z -> [$i][$j]);
        }
    }

    bless $w, $class;
}

=pod

=item kron()

Kronecker tensor product.

    $A -> kronprod($B);

If C<$A> is an C<$m>-by-C<$n> matrix and C<$B> is a C<$p>-by-C<$q> matrix, then
C<< $A -> kron($B) >> is an C<$m>*C<$p>-by-C<$n>*C<$q> matrix formed by taking
all possible products between the elements of C<$A> and the elements of C<$B>.

=cut

sub kron {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y) unless defined(blessed($y)) && $y -> isa($class);

    my ($nrowx, $ncolx) = $x -> size();
    my ($nrowy, $ncoly) = $y -> size();

    my $z = bless [], $class;

    for my $ix (0 .. $nrowx - 1) {
        for my $jx (0 .. $ncolx - 1) {
            for my $iy (0 .. $nrowy - 1) {
                for my $jy (0 .. $ncoly - 1) {
                    my $iz = $ix * $nrowx + $iy;
                    my $jz = $jx * $ncolx + $jy;
                    $z -> [$iz][$jz] = $x -> [$ix][$jx] * $y -> [$iy][$jy];
                }
            }
        }
    }

    return $z;
}

=pod

=item multiply()

This is an alias for C<L</mmul()>>.

=cut

sub multiply {
    my $x = shift;
    $x -> mmul(@_);
}

=pod

=item multiply_scalar()

Multiplies a matrix and a scalar resulting in a matrix of the same dimensions
with each element scaled with the scalar.

    $a->multiply_scalar(2);  scale matrix by factor 2

=cut

sub multiply_scalar {
    my $self = shift;
    my $factor = shift;
    my $result = $self->new();

    my $last = $#{$self->[0]};
    for my $i (0 .. $#{$self}) {
        for my $j (0 .. $last) {
            $result->[$i][$j] = $factor * $self->[$i][$j];
        }
    }
    $result;
}

=pod

=back

=head3 Powers

=over 4

=item pow()

Power function.

This is an alias for C<L</mpow()>>.

See also C<L</spow()>>.

=cut

sub pow {
    my $x = shift;
    $x -> mpow(@_);
}

=pod

=item mpow()

Matrix power. The second operand must be a non-negative integer.

    $y = $x -> mpow($n);

The following example

    $x = Math::Matrix -> new([[0, -2],[1, 4]]);
    $y = 4;
    $z = $x -> pow($y);

returns the matrix

    [ -28  -96 ]
    [  48  164 ]

See also C<L</spow()>>.

=cut

sub mpow {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    croak "Invocand matrix must be square in ", (caller(0))[3]
      unless $x -> is_square();

    my $n = shift;
    croak "Exponent can not be undefined" unless defined $n;
    if (ref $n) {
        $n = $class -> new($n) unless defined(blessed($n)) && $n -> isa($class);
        croak "Exponent must be a scalar in ", (caller(0))[3]
          unless $n -> is_scalar();
        $n = $n -> [0][0];
    }
    croak "Exponent must be an integer" unless $n == int $n;

    return $class -> new([]) if $x -> is_empty();

    my ($nrowx, $ncolx) = $x -> size();
    return $class -> id($nrowx, $ncolx) if $n == 0;
    return $x -> clone()                if $n == 1;

    my $neg = $n < 0;
    $n = -$n if $neg;

    my $y = $class -> id($nrowx, $ncolx);
    my $tmp = $x;
    while (1) {
        my $rem = $n % 2;
        $y *= $tmp if $rem;
        $n = ($n - $rem) / 2;
        last if $n == 0;
        $tmp = $tmp * $tmp;
    }

    $y = $y -> minv() if $neg;

    return $y;
}

=pod

=item spow()

Scalar (element by element) power function. This method doesn't require the
matrices to have the same size.

    $z = $x -> spow($y);

See also C<L</mpow()>>.

=cut

sub spow {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;

    my $sub = sub { $_[0] ** $_[1] };
    $x -> sapply($sub, @_);
}

=pod

=back

=head3 Inversion

=over 4

=item inv()

This is an alias for C<L</minv()>>.

=cut

sub inv {
    my $x = shift;
    $x -> minv();
}

=pod

=item invert()

Invert a Matrix using C<solve>.

=cut

sub invert {
    my $M = shift;
    my ($m, $n) = $M->size;
    croak "Can't invert $m-by-$n matrix; matrix must be square"
      if $m != $n;
    my $I = $M->new_identity($n);
    ($M->concat($I))->solve;
}

=pod

=item minv()

Matrix inverse. Invert a matrix.

    $y = $x -> inv();

See the section L</IMPROVING THE SOLUTION OF LINEAR SYSTEMS> for a list of
additional parameters that can be used for trying to obtain a better solution
through iteration.

=cut

sub minv {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    #croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    my $class = ref $x;

    my $n = $x -> nrow();
    return $class -> id($n) -> mldiv($x, @_);
}

=pod

=item sinv()

Scalar (element by element) inverse. Invert each element in a matrix.

    $y = $x -> sinv();

=cut

sub sinv {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    bless [ map [ map 1/$_, @$_ ], @$x ], ref $x;
}

=pod

=item mldiv()

Matrix left division. Returns the solution x of the linear system of equations
A*x = y, by computing A^(-1)*y.

    $x = $y -> mldiv($A);

This method also handles overdetermined and underdetermined systems. There are
three cases

=over 4

=item *

If A is a square matrix, then

    x = A\y = inv(A)*y

so that A*x = y to within round-off accuracy.

=item *

If A is an M-by-N matrix where M > N, then A\y is computed as

    A\y = (A'*A)\(A'*y) = inv(A'*A)*(A'*y)

where A' denotes the transpose of A. The returned matrix is the least squares
solution to the linear system of equations A*x = y, if it exists. The matrix
A'*A must be non-singular.

=item *

If A is an where M < N, then A\y is computed as

    A\y = A'*((A*A')\y)

This solution is not unique. The matrix A*A' must be non-singular.

=back

See the section L</IMPROVING THE SOLUTION OF LINEAR SYSTEMS> for a list of
additional parameters that can be used for trying to obtain a better solution
through iteration.

=cut

sub mldiv {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    #croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $y = shift;
    my $class = ref $y;

    my $A = shift;
    $A = $class -> new($A) unless defined(blessed($A)) && $A -> isa($class);

    my ($m, $n) = $A -> size();

    if ($m > $n) {

        # If A is an M-by-N matrix where M > N, i.e., an overdetermined system,
        # compute (A'*A)\(A'*y) by doing a one level deep recursion.

        my $At = $A -> transpose();
        return $At -> mmul($y) -> mldiv($At -> mmul($A), @_);

    } elsif ($m < $n) {

        # If A is an M-by-N matrix where M < N, i.e., and underdetermined
        # system, compute A'*((A*A')\y) by doing a one level deep recursion.
        # This solution is not unique.

        my $At = $A -> transpose();
        return $At -> mldiv($At -> mmul($A), @_);
    }

    # If extra arguments are given ...

    if (@_) {

        require Config;
        my $max_iter = 20;
        my $rel_tol  = ($Config::Config{uselongdouble} ||
                        $Config::Config{usequadmath}) ? 1e-19 : 1e-9;
        my $abs_tol  = 0;
        my $debug;

        while (@_) {
            my $param = shift;
            croak "parameter name can not be undefined" unless defined $param;

            croak "missing value for parameter '$param'" unless @_;
            my $value = shift;

            if ($param eq 'MaxIter') {
                croak "value for parameter 'MaxIter' can not be undefined"
                  unless defined $value;
                croak "value for parameter 'MaxIter' must be a positive integer"
                  unless $value > 0 && $value == int $value;
                $max_iter = $value;
                next;
            }

            if ($param eq 'RelTol') {
                croak "value for parameter 'RelTol' can not be undefined"
                  unless defined $value;
                croak "value for parameter 'RelTol' must be non-negative"
                  unless $value >= 0;
                $rel_tol = $value;
                next;
            }

            if ($param eq 'AbsTol') {
                croak "value for parameter 'AbsTol' can not be undefined"
                  unless defined $value;
                croak "value for parameter 'AbsTol' must be non-negative"
                  unless $value >= 0;
                $abs_tol = $value;
                next;
            }

            if ($param eq 'Debug') {
                $debug = $value;
                next;
            }

            croak "unknown parameter '$param'";
        }

        if ($debug) {
            printf "\n";
            printf "max_iter = %24d\n", $max_iter;
            printf "rel_tol  = %24.15e\n", $rel_tol;
            printf "abs_tol  = %24.15e\n", $abs_tol;
        }

        my $y_norm = _hypot(map { @$_ } @$y);

        my $x = $y -> mldiv($A);

        my $x_best;
        my $iter_best;
        my $abs_err_best;
        my $rel_err_best;

        for (my $iter = 1 ; ; $iter++) {

            # Compute the residuals.

            my $r = $A -> mmuladd($x, -$y);

            # Compute the errors.

            my $r_norm  = _hypot(map @$_, @$r);
            my $abs_err = $r_norm;
            my $rel_err = $y_norm == 0 ? $r_norm : $r_norm / $y_norm;

            if ($debug) {
                printf "\n";
                printf "iter     = %24d\n", $iter;
                printf "r_norm   = %24.15e\n", $r_norm;
                printf "y_norm   = %24.15e\n", $y_norm;
                printf "abs_err  = %24.15e\n", $abs_err;
                printf "rel_err  = %24.15e\n", $rel_err;
            }

            # See if this is the first round or we have an new all-time best.

            if ($iter == 1 ||
                $abs_err < $abs_err_best ||
                $rel_err < $rel_err_best)
            {
                $x_best       = $x;
                $iter_best    = $iter;
                $abs_err_best = $abs_err;
                $rel_err_best = $rel_err;
            }

            if ($abs_err_best <= $abs_tol || $rel_err_best <= $rel_tol) {
                last;
            } else {

                # If we still haven't got the desired result, but have reached
                # the maximum number of iterations, display a warning.

                if ($iter == $max_iter) {
                    carp "mldiv() stopped because the maximum number of",
                      " iterations (max. iter = $max_iter) was reached without",
                      " converging to any of the desired tolerances (",
                      "rel_tol = ", $rel_tol, ", ",
                      "abs_tol = ", $abs_tol, ").",
                      " The best iterate (iter. = ", $iter_best, ") has",
                      " a relative residual of ", $rel_err_best, " and",
                      " an absolute residual of ", $abs_err_best, ".";
                    last;
                }
            }

            # Compute delta $x.

            my $d = $r -> mldiv($A);

            # Compute the improved solution $x.

            $x -= $d;
        }

        return $x_best, $rel_err_best, $abs_err_best, $iter_best if wantarray;
        return $x_best;
    }

    # If A is an M-by-M, compute A\y directly.

    croak "mldiv(): sizes don't match" unless $y -> nrow() == $n;

    # Create the augmented matrix.

    my $x = $A -> catcol($y);

    # Perform forward elimination.

    my ($rowperm, $colperm);
    eval { ($x, $rowperm, $colperm) = $x -> felim_fp() };
    croak "mldiv(): matrix is singular or close to singular" if $@;

    # Perform backward substitution.

    eval { $x = $x -> bsubs() };
    croak "mldiv(): matrix is singular or close to singular" if $@;

    # Remove left half to keep only the augmented matrix.

    $x = $x -> splicecol(0, $n);

    # Reordering the rows is only necessary when full (complete) pivoting is
    # used above. If partial pivoting is used, this reordeing could be skipped,
    # but it executes so fast that it causes no harm to do it anyway.

    @$x[ @$colperm ] = @$x;

    return $x;
}

=pod

=item sldiv()

Scalar (left) division.

    $x -> sldiv($y);

For scalars, there is no difference between left and right division, so this is
just an alias for C<L</sdiv()>>.

=cut

sub sldiv {
    my $x = shift;
    $x -> sdiv(@_)
}

=pod

=item mrdiv()

Matrix right division. Returns the solution x of the linear system of equations
x*A = y, by computing x = y/A = y*inv(A) = (A'\y')', where A' and y' denote the
transpose of A and y, respectively, and \ is matrix left division (see
C<L</mldiv()>>).

    $x = $y -> mrdiv($A);

See the section L</IMPROVING THE SOLUTION OF LINEAR SYSTEMS> for a list of
additional parameters that can be used for trying to obtain a better solution
through iteration.

=cut

sub mrdiv {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    #croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $y = shift;
    my $class = ref $y;

    my $A = shift;
    $A = $class -> new($A) unless defined(blessed($A)) && $A -> isa($class);

    $y -> transpose() -> mldiv($A -> transpose(), @_) -> transpose();
}

=pod

=item srdiv()

Scalar (right) division.

    $x -> srdiv($y);

For scalars, there is no difference between left and right division, so this is
just an alias for C<L</sdiv()>>.

=cut

sub srdiv {
    my $x = shift;
    $x -> sdiv(@_)
}

=pod

=item sdiv()

Scalar division. Performs scalar (element by element) division.

    $x -> sdiv($y);

=cut

sub sdiv {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;

    my $sub = sub { $_[0] / $_[1] };
    $x -> sapply($sub, @_);
}

=pod

=item mpinv()

Matrix pseudo-inverse, C<(A'*A)^(-1)*A'>, where "C<'>" is the transpose
operator.

See the section L</IMPROVING THE SOLUTION OF LINEAR SYSTEMS> for a list of
additional parameters that can be used for trying to obtain a better solution
through iteration.

=cut

sub mpinv {
    my $A = shift;

    my $At = $A -> transpose();
    return $At -> mldiv($At -> mmul($A), @_);
}

=pod

=item pinv()

This is an alias for C<L</mpinv()>>.

=cut

sub pinv {
    my $x = shift;
    $x -> mpinv();
}

=pod

=item pinvert()

This is an alias for C<L</mpinv()>>.

=cut

sub pinvert {
    my $x = shift;
    $x -> mpinv();
}

=pod

=item solve()

Solves a equation system given by the matrix. The number of colums must be
greater than the number of rows. If variables are dependent from each other,
the second and all further of the dependent coefficients are 0. This means the
method can handle such systems. The method returns a matrix containing the
solutions in its columns or B<undef> in case of error.

=cut

sub solve {
    my $self  = shift;
    my $class = ref($self);

    my $m    = $self->clone();
    my $mr   = $#{$m};
    my $mc   = $#{$m->[0]};
    my $f;
    my $try;

    return undef if $mc <= $mr;
  ROW: for(my $i = 0; $i <= $mr; $i++) {
        $try=$i;
        # make diagonal element nonzero if possible
        while (abs($m->[$i]->[$i]) < $eps) {
            last ROW if $try++ > $mr;
            my $row = splice(@{$m},$i,1);
            push(@{$m}, $row);
        }

        # normalize row
        $f = $m->[$i]->[$i];
        for (my $k = 0; $k <= $mc; $k++) {
            $m->[$i]->[$k] /= $f;
        }
        # subtract multiple of designated row from other rows
        for (my $j = 0; $j <= $mr; $j++) {
            next if $i == $j;
            $f = $m->[$j]->[$i];
            for (my $k = 0; $k <= $mc; $k++) {
                $m->[$j]->[$k] -= $m->[$i]->[$k] * $f;
            }
        }
    }

    # Answer is in augmented column
    $class -> new([ @{ $m -> transpose }[$mr+1 .. $mc] ]) -> transpose;
}

=pod

=back

=head3 Factorisation

=over 4

=item chol()

Cholesky decomposition.

    $L = $A -> chol();

Every symmetric, positive definite matrix A can be decomposed into a product of
a unique lower triangular matrix L and its transpose, so that A = L*L', where L'
denotes the transpose of L. L is called the Cholesky factor of A.

=cut

sub chol {
    my $x = shift;
    my $class = ref $x;

    croak "Input matrix must be a symmetric" unless $x -> is_symmetric();

    my $y = [ map [ (0) x @$x ], @$x ];         # matrix of zeros
    for my $i (0 .. $#$x) {
        for my $j (0 .. $i) {
            my $z = $x->[$i][$j];
            $z -= $y->[$i][$_] * $y->[$j][$_] for 0 .. $j;
            if ($i == $j) {
                croak "Matrix is not positive definite" if $z < 0;
                $y->[$i][$j] = sqrt($z);
            } else {
                croak "Matrix is not positive definite" if $y->[$j][$j] == 0;
                $y->[$i][$j] = $z / $y->[$j][$j];
            }
        }
    }
    bless $y, $class;
}

=pod

=back

=head3 Miscellaneous matrix functions

=over 4

=item transpose()

Returns the transposed matrix. This is the matrix where colums and rows of the
argument matrix are swapped.

A subclass implementing matrices of complex numbers should provide a
C<L</transpose()>> method that takes the complex conjugate of each element.

=cut

sub transpose {
    my $x = shift;
    my $class = ref $x;

    my $y = bless [], $class;
    my $ncolx = $x -> ncol();
    return $y if $ncolx == 0;

    for my $j (0 .. $ncolx - 1) {
        push @$y, [ map $_->[$j], @$x ];
    }
    return $y;
}

=pod

=item minormatrix()

Minor matrix. The (i,j) minor matrix of a matrix is identical to the original
matrix except that row i and column j has been removed.

    $y = $x -> minormatrix($i, $j);

See also C<L</minor()>>.

=cut

sub minormatrix {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 3;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 3;
    my $x = shift;
    my $class = ref $x;

    my ($m, $n) = $x -> size();

    my $i = shift;
    croak "Row index value $i outside of $m-by-$n matrix"
      unless 0 <= $i && $i < $m;

    my $j = shift;
    croak "Column index value $j outside of $m-by-$n matrix"
      unless 0 <= $j && $j < $n;

    # We could just use the following, which is simpler, but also slower:
    #
    #     $x -> delrow($i) -> delcol($j);

    my @rowidx = 0 .. $m - 1;
    splice @rowidx, $i, 1;

    my @colidx = 0 .. $n - 1;
    splice @colidx, $j, 1;

    bless [ map [ @{$_}[@colidx] ], @{$x}[@rowidx] ], $class;
}

=pod

=item minor()

Minor. The (i,j) minor of a matrix is the determinant of the (i,j) minor matrix.

    $y = $x -> minor($i, $j);

See also C<L</minormatrix()>>.

=cut

sub minor {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 3;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 3;
    my $x = shift;

    croak "Matrix must be square" unless $x -> is_square();

    $x -> minormatrix(@_) -> determinant();
}

=pod

=item cofactormatrix()

Cofactor matrix. Element (i,j) in the cofactor matrix is the (i,j) cofactor,
which is (-1)^(i+j) multiplied by the determinant of the (i,j) minor matrix.

    $y = $x -> cofactormatrix();

=cut

sub cofactormatrix {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    my ($m, $n) = $x -> size();
    croak "matrix must be square" unless $m == $n;

    my $y = [];
    for my $i (0 .. $m - 1) {
        for my $j (0 .. $n - 1) {
            $y -> [$i][$j] = (-1) ** ($i + $j) * $x -> minor($i, $j);
        }
    }

    bless $y;
}

=pod

=item cofactor()

Cofactor. The (i,j) cofactor of a matrix is (-1)**(i+j) times the (i,j) minor of
the matrix.

    $y = $x -> cofactor($i, $j);

=cut

sub cofactor {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 3;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 3;
    my $x = shift;

    my ($m, $n) = $x -> size();
    croak "matrix must be square" unless $m == $n;

    my ($i, $j) = @_;
    (-1) ** ($i + $j) * $x -> minor($i, $j);
}

=pod

=item adjugate()

Adjugate of a matrix. The adjugate, also called classical adjoint or adjunct, of
a square matrix is the transpose of the cofactor matrix.

    $y = $x -> adjugate();

=cut

sub adjugate {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    $x -> cofactormatrix() -> transpose();
}

=pod

=item det()

Determinant. Returns the determinant of a matrix. The matrix must be square.

    $y = $x -> det();

The matrix is computed by forward elimination, which might cause round-off
errors. So for example, the determinant might be a non-integer even for an
integer matrix.

=cut

sub det {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;
    my $class = ref $x;

    my ($nrowx, $ncolx) = $x -> size();
    croak "matrix must be square" unless $nrowx == $ncolx;

    # Create the augmented matrix.

    $x = $x -> catcol($class -> id($nrowx));

    # Perform forward elimination.

    my ($iperm, $jperm, $iswap, $jswap);
    eval { ($x, $iperm, $jperm, $iswap, $jswap) = $x -> felim_fp() };

    # Compute the product of the elements on the diagonal.

    my $det = 1;
    for (my $i = 0 ; $i < $nrowx ; ++$i) {
        last if ($det *= $x -> [$i][$i]) == 0;
    }

    # Adjust the sign according to the number of inversions.

    $det = ($iswap + $jswap) % 2 ? -$det : $det;

    return $det;
}

=pod

=item determinant()

This is an alias for C<L</det()>>.

=cut

sub determinant {
    my $x = shift;
    $x -> det(@_);
}

=pod

=item detr()

Determinant. Returns the determinant of a matrix. The matrix must be square.

    $y = $x -> determinant();

The determinant is computed by recursion, so it is generally much slower than
C<L</det()>>.

=cut

sub detr {
    my $x = shift;
    my $class = ref($x);
    my $imax = $#$x;
    my $jmax = $#{$x->[0]};

    return undef unless $imax == $jmax;     # input must be a square matrix

    # Matrix is 3 × 3

    return
        $x -> [0][0] * ($x -> [1][1] * $x -> [2][2] - $x -> [1][2] * $x -> [2][1])
      - $x -> [0][1] * ($x -> [1][0] * $x -> [2][2] - $x -> [1][2] * $x -> [2][0])
      + $x -> [0][2] * ($x -> [1][0] * $x -> [2][1] - $x -> [1][1] * $x -> [2][0])
      if $imax == 2;

    # Matrix is 2 × 2

    return $x -> [0][0] * $x -> [1][1] - $x -> [1][0] * $x -> [0][1]
      if $imax == 1;

    # Matrix is 1 × 1

    return $x -> [0][0] if $imax == 0;

    # Matrix is N × N for N > 3.

    my $det = 0;

    # Create a matrix with column 0 removed. We only need to do this once.
    my $x0 = bless [ map [ @{$_}[1 .. $jmax] ], @$x ], $class;

    for my $i (0 .. $imax) {

        # Create a matrix with row $i and column 0 removed.
        my $x1 = bless [ map [ @$_ ], @{$x0}[ 0 .. $i-1, $i+1 .. $imax ] ], $class;

        my $term = $x1 -> determinant();
        $term *= $i % 2 ? -$x->[$i][0] : $x->[$i][0];

        $det += $term;
    }

    return $det;
}

=pod

=back

=head3 Elementwise mathematical functions

These method work on each element of a matrix.

=over 4

=item int()

Truncate to integer. Truncates each element to an integer.

    $y = $x -> int();

This function is effectivly the same as

    $y = $x -> map(sub { int });

=cut

sub int {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    bless [ map [ map int($_), @$_ ], @$x ], ref $x;
}

=pod

=item floor()

Round to negative infinity. Rounds each element to negative infinity.

    $y = $x -> floor();

=cut

sub floor {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    bless [ map { [
                   map {
                       my $ix = CORE::int($_);
                       ($ix <= $_) ? $ix : $ix - 1;
                   } @$_
                  ] } @$x ], ref $x;
}

=pod

=item ceil()

Round to positive infinity. Rounds each element to positive infinity.

    $y = $x -> int();

=cut

sub ceil {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    bless [ map { [
                   map {
                       my $ix = CORE::int($_);
                     ($ix >= $_) ? $ix : $ix + 1;
                   } @$_
                  ] } @$x ], ref $x;
}

=pod

=item abs()

Absolute value. The absolute value of each element.

    $y = $x -> abs();

This is effectivly the same as

    $y = $x -> map(sub { abs });

=cut

sub abs {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    bless [ map [ map abs($_), @$_ ], @$x ], ref $x;
}

=pod

=item sign()

Sign function. Apply the sign function to each element.

    $y = $x -> sign();

This is effectivly the same as

    $y = $x -> map(sub { $_ <=> 0 });

=cut

sub sign {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    bless [ map [ map { $_ <=> 0 } @$_ ], @$x ], ref $x;
}

=pod

=back

=head3 Columnwise or rowwise mathematical functions

These method work along each column or row of a matrix. Some of these methods
return a matrix with the same size as the invocand matrix. Other methods
collapse the dimension, so that, e.g., if the method is applied to the first
dimension a I<p>-by-I<q> matrix becomes a 1-by-I<q> matrix, and if applied to
the second dimension, it becomes a I<p>-by-1 matrix. Others, like C<L</diff()>>,
reduces the length along the dimension by one, so a I<p>-by-I<q> matrix becomes
a (I<p>-1)-by-I<q> or a I<p>-by-(I<q>-1) matrix.

=over 4

=item sum()

Sum of elements along various dimensions of a matrix. If the dimension argument
is not given, the first non-singleton dimension is used.

    $y = $x -> sum($dim);
    $y = $x -> sum();

=cut

sub sum {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(\&_sum, @_);
}

=pod

=item prod()

Product of elements along various dimensions of a matrix. If the dimension
argument is not given, the first non-singleton dimension is used.

    $y = $x -> prod($dim);
    $y = $x -> prod();

=cut

sub prod {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(\&_prod, @_);
}

=pod

=item mean()

Mean of elements along various dimensions of a matrix. If the dimension argument
is not given, the first non-singleton dimension is used.

    $y = $x -> mean($dim);
    $y = $x -> mean();

=cut

sub mean {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(\&_mean, @_);
}

=pod

=item hypot()

Hypotenuse. Computes the square root of the sum of the square of each element
along various dimensions of a matrix. If the dimension argument is not given,
the first non-singleton dimension is used.

    $y = $x -> hypot($dim);
    $y = $x -> hypot();

For example,

    $x = Math::Matrix -> new([[3,  4],
                              [5, 12]]);
    $y = $x -> hypot(2);

returns the 2-by-1 matrix

    [  5 ]
    [ 13 ]

=cut

sub hypot {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(\&_hypot, @_);
}

=pod

=item min()

Minimum of elements along various dimensions of a matrix. If the dimension
argument is not given, the first non-singleton dimension is used.

    $y = $x -> min($dim);
    $y = $x -> min();

=cut

sub min {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(\&_min, @_);
}

=pod

=item max()

Maximum of elements along various dimensions of a matrix. If the dimension
argument is not given, the first non-singleton dimension is used.

    $y = $x -> max($dim);
    $y = $x -> max();

=cut

sub max {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(\&_max, @_);
}

=pod

=item median()

Median of elements along various dimensions of a matrix. If the dimension
argument is not given, the first non-singleton dimension is used.

    $y = $x -> median($dim);
    $y = $x -> median();

=cut

sub median {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(\&_median, @_);
}

=pod

=item cumsum()

Returns the cumulative sum along various dimensions of a matrix. If the
dimension argument is not given, the first non-singleton dimension is used.

    $y = $x -> cumsum($dim);
    $y = $x -> cumsum();

=cut

sub cumsum {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(\&_cumsum, @_);
}

=pod

=item cumprod()

Returns the cumulative product along various dimensions of a matrix. If the
dimension argument is not given, the first non-singleton dimension is used.

    $y = $x -> cumprod($dim);
    $y = $x -> cumprod();

=cut

sub cumprod {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(\&_cumprod, @_);
}

=pod

=item cummean()

Returns the cumulative mean along various dimensions of a matrix. If the
dimension argument is not given, the first non-singleton dimension is used.

    $y = $x -> cummean($dim);
    $y = $x -> cummean();

=cut

sub cummean {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(\&_cummean, @_);
}

=pod

=item diff()

Returns the differences between adjacent elements. If the dimension argument is
not given, the first non-singleton dimension is used.

    $y = $x -> diff($dim);
    $y = $x -> diff();

=cut

sub diff {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    $x -> apply(\&_diff, @_);
}

=pod

=item vecnorm()

Return the C<$p>-norm of the elements of C<$x>. If the dimension argument is not
given, the first non-singleton dimension is used.

    $y = $x -> vecnorm($p, $dim);
    $y = $x -> vecnorm($p);
    $y = $x -> vecnorm();

The C<$p>-norm of a vector is defined as the C<$p>th root of the sum of the
absolute values fo the elements raised to the C<$p>th power.

=cut

sub vecnorm {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 3;
    my $x = shift;
    my $class = ref $x;

    my $p = 2;
    if (@_) {
        $p = shift;
        croak 'When the \$p argument is given, it can not be undefined'
          unless defined $p;
        if (ref $p) {
            $p = $class -> new($p)
              unless defined(blessed($p)) && $p -> isa($class);
            croak 'The $p argument must be a scalar' unless $p -> is_scalar();
            $p = $p -> [0][0];
        }
    }

    my $sub = sub { _vecnorm($p, @_) };
    $x -> apply($sub, @_);
}

=pod

=item apply()

Applies a subroutine to each row or column of a matrix. If the dimension
argument is not given, the first non-singleton dimension is used.

    $y = $x -> apply($sub, $dim);
    $y = $x -> apply($sub);

The subroutine is passed a list with all elements in a single column or row.

=cut

sub apply {
    my $x = shift;
    my $class = ref $x;

    my $sub = shift;

    # Get the size of the input $x.

    my ($nrowx, $ncolx) = $x -> size();

    # Get the dimension along which to apply the subroutine.

    my $dim;
    if (@_) {
        $dim = shift;
        croak "Dimension can not be undefined" unless defined $dim;
        if (ref $dim) {
            $dim = $class -> new($dim)
              unless defined(blessed($dim)) && $dim -> isa($class);
            croak "Dimension must be a scalar" unless $dim -> is_scalar();
            $dim = $dim -> [0][0];
            croak "Dimension must be a positive integer"
              unless $dim > 0 && $dim == CORE::int($dim);
        }
        croak "Dimension must be 1 or 2" unless $dim == 1 || $dim == 2;
    } else {
        $dim = $nrowx > 1 ? 1 : 2;
    }

    # Initialise output.

    my $y = [];

    # Work along the first dimension, i.e., each column.

    my ($nrowy, $ncoly);
    if ($dim == 1) {
        $nrowy = 0;
        for my $j (0 .. $ncolx - 1) {
            my @col = $sub -> (map $_ -> [$j], @$x);
            if ($j == 0) {
                $nrowy = @col;
            } else {
                croak "The number of elements in each column must be the same"
                  unless $nrowy == @col;
            }
            $y -> [$_][$j] = $col[$_] for 0 .. $#col;
        }
        $y = [] if $nrowy == 0;
    }

    # Work along the second dimension, i.e., each row.

    elsif ($dim == 2) {
        $ncoly = 0;
        for my $i (0 .. $nrowx - 1) {
            my @row = $sub -> (@{ $x -> [$i] });
            if ($i == 0) {
                $ncoly = @row;
            } else {
                croak "The number of elements in each row must be the same"
                  unless $ncoly == @row;
            }
            $y -> [$i] = [ @row ];
        }
        $y = [] if $ncoly == 0;
    }

    bless $y, $class;
}

=pod

=back

=head2 Comparison

=head3 Matrix comparison

Methods matrix comparison. These methods return a scalar value.

=over 4

=item meq()

Matrix equal to. Returns 1 if two matrices are identical and 0 otherwise.

    $bool = $x -> meq($y);

=cut

sub meq {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y)
      unless defined(blessed($y)) && $y -> isa($class);

    my ($nrowx, $ncolx) = $x -> size();
    my ($nrowy, $ncoly) = $y -> size();

    # Quick exit if the sizes don't match.

    return 0 unless $nrowx == $nrowy && $ncolx == $ncoly;

    # Compare the elements.

    for my $i (0 .. $nrowx - 1) {
        for my $j (0 .. $ncolx - 1) {
            return 0 if $x->[$i][$j] != $y->[$i][$j];
        }
    }
    return 1;
}

=pod

=item mne()

Matrix not equal to. Returns 1 if two matrices are different and 0 otherwise.

    $bool = $x -> mne($y);

=cut

sub mne {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y)
      unless defined(blessed($y)) && $y -> isa($class);

    my ($nrowx, $ncolx) = $x -> size();
    my ($nrowy, $ncoly) = $y -> size();

    # Quick exit if the sizes don't match.

    return 1 unless $nrowx == $nrowy && $ncolx == $ncoly;

    # Compare the elements.

    for my $i (0 .. $nrowx - 1) {
        for my $j (0 .. $ncolx - 1) {
            return 1 if $x->[$i][$j] != $y->[$i][$j];
        }
    }
    return 0;
}

=pod

=item equal()

Decide if two matrices are equal. The criterion is, that each pair of elements
differs less than $Math::Matrix::eps.

    $bool = $x -> equal($y);

=cut

sub equal {
    my $A = shift;
    my $B = shift;

    my $jmax = $#{$A->[0]};
    for my $i (0 .. $#{$A}) {
        for my $j (0 .. $jmax) {
            return 0 if CORE::abs($A->[$i][$j] - $B->[$i][$j]) >= $eps;
        }
    }
    return 1;
}

=pod

=back

=head3 Scalar comparison

Each of these methods performs scalar (element by element) comparison and
returns a matrix of ones and zeros. Scalar expansion is performed if necessary.

=over 4

=item seq()

Scalar equality. Performs scalar (element by element) comparison of two
matrices.

    $bool = $x -> seq($y);

=cut

sub seq {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y)
      unless defined(blessed($y)) && $y -> isa($class);

    $x -> sapply(sub { $_[0] == $_[1] ? 1 : 0 }, $y);
}

=pod

=item sne()

Scalar (element by element) not equal to. Performs scalar (element by element)
comparison of two matrices.

    $bool = $x -> sne($y);

=cut

sub sne {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y)
      unless defined(blessed($y)) && $y -> isa($class);

    $x -> sapply(sub { $_[0] != $_[1] ? 1 : 0 }, $y);
}

=pod

=item slt()

Scalar (element by element) less than. Performs scalar (element by element)
comparison of two matrices.

    $bool = $x -> slt($y);

=cut

sub slt {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y)
      unless defined(blessed($y)) && $y -> isa($class);

    $x -> sapply(sub { $_[0] < $_[1] ? 1 : 0 }, $y);
}

=pod

=item sle()

Scalar (element by element) less than or equal to. Performs scalar
(element by element) comparison of two matrices.

    $bool = $x -> sle($y);

=cut

sub sle {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y)
      unless defined(blessed($y)) && $y -> isa($class);

    $x -> sapply(sub { $_[0] <= $_[1] ? 1 : 0 }, $y);
}

=pod

=item sgt()

Scalar (element by element) greater than. Performs scalar (element by element)
comparison of two matrices.

    $bool = $x -> sgt($y);

=cut

sub sgt {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y)
      unless defined(blessed($y)) && $y -> isa($class);

    $x -> sapply(sub { $_[0] > $_[1] ? 1 : 0 }, $y);
}

=pod

=item sge()

Scalar (element by element) greater than or equal to. Performs scalar
(element by element) comparison of two matrices.

    $bool = $x -> sge($y);

=cut

sub sge {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y)
      unless defined(blessed($y)) && $y -> isa($class);

    $x -> sapply(sub { $_[0] >= $_[1] ? 1 : 0 }, $y);
}

=pod

=item scmp()

Scalar (element by element) comparison. Performs scalar (element by element)
comparison of two matrices. Each element in the output matrix is either -1, 0,
or 1 depending on whether the elements are less than, equal to, or greater than
each other.

    $bool = $x -> scmp($y);

=cut

sub scmp {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 2;
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y)
      unless defined(blessed($y)) && $y -> isa($class);

    $x -> sapply(sub { $_[0] <=> $_[1] }, $y);
}

=pod

=back

=head2 Vector functions

=over 4

=item dot_product()

Compute the dot product of two vectors. The second operand does not have to be
an object.

    # $x and $y are both objects
    $x = Math::Matrix -> new([1, 2, 3]);
    $y = Math::Matrix -> new([4, 5, 6]);
    $p = $x -> dot_product($y);             # $p = 32

    # Only $x is an object.
    $p = $x -> dot_product([4, 5, 6]);      # $p = 32

=cut

sub dot_product {
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y)
      unless defined(blessed($y)) && $y -> isa($class);

    croak "First argument must be a vector"  unless $x -> is_vector();
    $x = $x -> to_row() unless $x -> is_row();

    croak "Second argument must be a vector" unless $x -> is_vector();
    $y = $y -> to_col() unless $x -> is_col();

    croak "The two vectors must have the same length"
      unless $x -> nelm() == $y -> nelm();

    $x -> multiply($y) -> [0][0];
}

=pod

=item outer_product()

Compute the outer product of two vectors. The second operand does not have to be
an object.

    # $x and $y are both objects
    $x = Math::Matrix -> new([1, 2, 3]);
    $y = Math::Matrix -> new([4, 5, 6, 7]);
    $p = $x -> outer_product($y);

    # Only $x is an object.
    $p = $x -> outer_product([4, 5, 6, y]);

=cut

sub outer_product {
    my $x = shift;
    my $class = ref $x;

    my $y = shift;
    $y = $class -> new($y)
      unless defined(blessed($y)) && $y -> isa($class);

    croak "First argument must be a vector"  unless $x -> is_vector();
    $x = $x -> to_col() unless $x -> is_col();

    croak "Second argument must be a vector" unless $x -> is_vector();
    $y = $y -> to_row() unless $x -> is_row();

    $x -> multiply($y);
}

=pod

=item absolute()

Compute the absolute value (i.e., length) of a vector.

    $v = Math::Matrix -> new([3, 4]);
    $a = $v -> absolute();                  # $v = 5

=cut

sub absolute {
    my $x = shift;
    croak "Argument must be a vector"  unless $x -> is_vector();

    _hypot(@{ $x -> to_row() -> [0] });
}

=pod

=item normalize()

Normalize a vector, i.e., scale a vector so its length becomes 1.

    $v = Math::Matrix -> new([3, 4]);
    $u = $v -> normalize();                 # $u = [ 0.6, 0.8 ]

=cut

sub normalize {
    my $vector = shift;
    my $length = $vector->absolute();
    return undef
      unless $length;
    $vector->multiply_scalar(1 / $length);
}

=pod

=item cross_product()

Compute the cross-product of vectors.

    $x = Math::Matrix -> new([1,3,2],
                             [5,4,2]);
    $p = $x -> cross_product();             # $p = [ -2, 8, -11 ]

=cut

sub cross_product {
    my $vectors = shift;
    my $class = ref($vectors);

    my $dimensions = @{$vectors->[0]};
    return undef
      unless $dimensions == @$vectors + 1;

    my @axis;
    foreach my $column (0..$dimensions-1) {
        my $tmp = $vectors->slice(0..$column-1,
                                  $column+1..$dimensions-1);
        my $scalar = $tmp->determinant;
        $scalar *= ($column % 2) ? -1 : 1;
        push @axis, $scalar;
    }
    my $axis = $class->new(\@axis);
    $axis = $axis->multiply_scalar(($dimensions % 2) ? 1 : -1);
}

=pod

=back

=head2 Conversion

=over 4

=item as_string()

Creates a string representation of the matrix and returns it.

    $x = Math::Matrix -> new([1, 2], [3, 4]);
    $s = $x -> as_string();

=cut

sub as_string {
    my $self = shift;
    my $out = "";
    for my $row (@{$self}) {
        for my $col (@{$row}) {
            $out = $out . sprintf "%10.5f ", $col;
        }
        $out = $out . sprintf "\n";
    }
    $out;
}

=pod

=item as_array()

Returns the matrix as an unblessed Perl array, i.e., and ordinary, unblessed
reference.

    $y = $x -> as_array();      # ref($y) returns 'ARRAY'

=cut

sub as_array {
    my $x = shift;
    [ map [ @$_ ], @$x ];
}

=pod

=back

=head2 Matrix utilities

=head3 Apply a subroutine to each element

=over 4

=item map()

Call a subroutine for every element of a matrix, locally setting C<$_> to each
element and passing the matrix row and column indices as input arguments.

    # square each element
    $y = $x -> map(sub { $_ ** 2 });

    # set strictly lower triangular part to zero
    $y = $x -> map(sub { $_[0] > $_[1] ? 0 : $_ })'

=cut

sub map {
    my $x = shift;
    my $class = ref $x;

    my $sub = shift;
    croak "The first input argument must be a code reference"
      unless ref($sub) eq 'CODE';

    my $y = [];
    my ($nrow, $ncol) = $x -> size();
    for my $i (0 .. $nrow - 1) {
        for my $j (0 .. $ncol - 1) {
            local $_ = $x -> [$i][$j];
            $y -> [$i][$j] = $sub -> ($i, $j);
        }
    }

    bless $y, $class;
}

=pod

=item sapply()

Applies a subroutine to each element of a matrix, or each set of corresponding
elements if multiple matrices are given, and returns the result. The first
argument is the subroutine to apply. The following arguments, if any, are
additional matrices on which to apply the subroutine.

    $w = $x -> sapply($sub);            # single operand
    $w = $x -> sapply($sub, $y);        # two operands
    $w = $x -> sapply($sub, $y, $z);    # three operands

Each matrix element, or corresponding set of elements, are passed to the
subroutine as input arguments.

When used with a single operand, this method is similar to the C<L</map()>>
method, the syntax is different, since C<L</sapply()>> supports multiple
operands.

See also C<L</map()>>.

=over 4

=item *

The subroutine is run in scalar context.

=item *

No checks are done on the return value of the subroutine.

=item *

The number of rows in the output matrix equals the number of rows in the operand
with the largest number of rows. Ditto for columns. So if C<$x> is 5-by-2
matrix, and C<$y> is a 3-by-4 matrix, the result is a 5-by-4 matrix.

=item *

For each operand that has a number of rows smaller than the maximum value, the
rows are recyled. Ditto for columns.

=item *

Don't modify the variables $_[0], $_[1] etc. inside the subroutine. Otherwise,
there is a risk of modifying the operand matrices.

=item *

If the matrix elements are objects that are not cloned when the "=" (assignment)
operator is used, you might have to explicitly clone the objects used inside the
subroutine. Otherwise, the elements in the output matrix might be references to
objects in the operand matrices, rather than references to new objects.

=back

Some examples

=over 4

=item One operand

With one operand, i.e., the invocand matrix, the subroutine is applied to each
element of the invocand matrix. The returned matrix has the same size as the
invocand. For example, multiplying the matrix C<$x> with the scalar C<$c>

    $sub = sub { $c * $_[0] };      # subroutine to multiply by $c
    $z = $x -> sapply($sub);        # multiply each element by $c

=item Two operands

When two operands are specfied, the subroutine is applied to each pair of
corresponding elements in the two operands. For example, adding two matrices can
be implemented as

    $sub = sub { $_[0] * $_[1] };
    $z = $x -> sapply($sub, $y);

Note that if the matrices have different sizes, the rows and/or columns of the
smaller are recycled to match the size of the larger. If C<$x> is a
C<$p>-by-C<$q> matrix and C<$y> is a C<$r>-by-C<$s> matrix, then C<$z> is a
max(C<$p>,C<$r>)-by-max(C<$q>,C<$s>) matrix, and

    $z -> [$i][$j] = $sub -> ($x -> [$i % $p][$j % $q],
                              $y -> [$i % $r][$j % $s]);

Because of this recycling, multiplying the matrix C<$x> with the scalar C<$c>
(see above) can also be implemented as

    $sub = sub { $_[0] * $_[1] };
    $z = $x -> sapply($sub, $c);

Generating a matrix with all combinations of C<$x**$y> for C<$x> being 4, 5, and
6 and C<$y> being 1, 2, 3, and 4 can be done with

    $c = Math::Matrix -> new([[4], [5], [6]]);      # 3-by-1 column
    $r = Math::Matrix -> new([[1, 2, 3, 4]]);       # 1-by-4 row
    $x = $c -> sapply(sub { $_[0] ** $_[1] }, $r);  # 3-by-4 matrix

=item Multiple operands

In general, the sapply() method can have any number of arguments. For example,
to compute the sum of the four matrices C<$x>, C<$y>, C<$z>, and C<$w>,

    $sub = sub {
               $sum = 0;
               for $val (@_) {
                   $sum += $val;
               };
               return $sum;
           };
    $sum = $x -> sapply($sub, $y, $z, $w);

=back

=cut

sub sapply {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 2;
    my $x = shift;
    my $class = ref $x;

    # Get the subroutine to apply on all the elements.

    my $sub = shift;
    croak "input argument must be a reference to a subroutine"
      unless ref($sub) eq 'CODE';

    my $y = bless [], $class;

    # For speed, treat a single matrix operand as a special case.

    if (@_ == 0) {
        my ($nrowx, $ncolx) = $x -> size();
        return $y if $nrowx * $ncolx == 0;      # quick exit if $x is empty

        for my $i (0 .. $nrowx - 1) {
            for my $j (0 .. $ncolx - 1) {
                $y -> [$i][$j] = $sub -> ($x -> [$i][$j]);
            }
        }

        return $y;
    }

    # Create some auxiliary arrays.

    my @args = ($x, @_);    # all matrices
    my @size = ();          # size of each matrix
    my @nelm = ();          # number of elements in each matrix

    # Loop over the input arguments to perform some checks and get their
    # properties. Also get the size (number of rows and columns) of the output
    # matrix.

    my $nrowy = 0;
    my $ncoly = 0;

    for my $k (0 .. $#args) {

        # Make sure the k'th argument is a matrix object.

        $args[$k] = $class -> new($args[$k])
          unless defined(blessed($args[$k])) && $args[$k] -> isa($class);

        # Get the number of rows, columns, and elements in the k'th argument,
        # and save this information for later.

        my ($nrowk, $ncolk) = $args[$k] -> size();
        $size[$k] = [ $nrowk, $ncolk ];
        $nelm[$k] = $nrowk * $ncolk;

        # Update the size of the output matrix.

        $nrowy = $nrowk if $nrowk > $nrowy;
        $ncoly = $ncolk if $ncolk > $ncoly;
    }

    # We only accept empty matrices if all matrices are empty.

    my $n_empty = grep { $_ == 0 } @nelm;
    return $y if $n_empty == @args;     # quick exit if all are empty

    # At ths point, we know that not all matrices are empty, but some might be
    # empty. We only continue if none are empty.

    croak "Either all or none of the matrices must be empty in ", (caller(0))[3]
      unless $n_empty == 0;

    # Loop over the subscripts into the output matrix.

    for my $i (0 .. $nrowy - 1) {
        for my $j (0 .. $ncoly - 1) {

            # Initialize the argument list for the subroutine call that will
            # give the value for element ($i,$j) in the output matrix.

            my @elms = ();

            # Loop over the matrices.

            for my $k (0 .. $#args) {

                # Get the number of rows and columns in the k'th matrix.

                my $nrowk = $size[$k][0];
                my $ncolk = $size[$k][1];

                # Compute the subscripts of the element to use in the k'th
                # matrix.

                my $ik = $i % $nrowk;
                my $jk = $j % $ncolk;

                # Get the element from the k'th matrix to use in this call.

                $elms[$k] = $args[$k][$ik][$jk];
            }

            # Now we have the argument list for the subroutine call.

            $y -> [$i][$j] = $sub -> (@elms);
        }
    }

    return $y;
}

=pod

=back

=head3 Forward elimination

These methods take a matrix as input, performs forward elimination, and returns
a matrix where all elements below the main diagonal are zero. In list context,
four additional arguments are returned: an array with the row permutations, an
array with the column permutations, an integer with the number of row swaps and
an integer with the number of column swaps performed during elimination.

The permutation vectors can be converted to permutation matrices with
C<L</to_permmat()>>.

=over

=item felim_np()

Perform forward elimination with no pivoting.

    $y = $x -> felim_np();

Forward elimination without pivoting may fail even when the matrix is
non-singular.

This method is provided mostly for illustration purposes.

=cut

sub felim_np {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    $x = $x -> clone();
    my $nrow = $x -> nrow();
    my $ncol = $x -> ncol();

    my $imax = $nrow - 1;
    my $jmax = $ncol - 1;

    my $iperm = [ 0 .. $imax ];         # row permutation vector
    my $jperm = [ 0 .. $imax ];         # column permutation vector
    my $iswap = 0;                      # number of row swaps
    my $jswap = 0;                      # number of column swaps

    my $debug = 0;

    printf "\nfelim_np(): before 0:\n\n%s\n", $x if $debug;

    for (my $i = 0 ; $i <= $imax && $i <= $jmax ; ++$i) {

        # The so far remaining unreduced submatrix starts at element ($i,$i).

        # Skip this round, if all elements below (i,i) are zero.

        my $saw_non_zero = 0;
        for (my $u = $i + 1 ; $u <= $imax ; ++$u) {
            if ($x->[$u][$i] != 0) {
                $saw_non_zero = 1;
                last;
            }
        }
        next unless $saw_non_zero;

        # Since we don't use pivoting, element ($i,$i) must be non-zero.

        if ($x->[$i][$i] == 0) {
            croak "No pivot element found for row $i";
        }

        # Subtract row $i from each row $u below $i.

        for (my $u = $i + 1 ; $u <= $imax ; ++$u) {
            for (my $j = $jmax ; $j >= $i ; --$j) {
                $x->[$u][$j] -= ($x->[$i][$j] * $x->[$u][$i]) / $x->[$i][$i];
            }

            # In case of round-off errors.

            $x->[$u][$i] *= 0;
        }

        printf "\nfelim_np(): after %u:\n\n%s\n\n", $i, $x if $debug;
    }

    return $x, $iperm, $jperm, $iswap, $jswap if wantarray;
    return $x;
}

=pod

=item felim_tp()

Perform forward elimination with trivial pivoting, a variant of partial
pivoting.

    $y = $x -> felim_tp();

If A is a p-by-q matrix, and the so far remaining unreduced submatrix starts at
element (i,i), the pivot element is the first element in column i that is
non-zero.

This method is provided mostly for illustration purposes.

=cut

sub felim_tp {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    croak "felim_tp(): too many input arguments" if @_ > 0;

    $x = $x -> clone();
    my $nrow = $x -> nrow();
    my $ncol = $x -> ncol();

    my $imax = $nrow - 1;
    my $jmax = $ncol - 1;

    my $iperm = [ 0 .. $imax ];         # row permutation vector
    my $jperm = [ 0 .. $imax ];         # column permutation vector
    my $iswap = 0;                      # number of row swaps
    my $jswap = 0;                      # number of column swaps

    my $debug = 0;

    printf "\nfelim_tp(): before 0:\n\n%s\n", $x if $debug;

    for (my $i = 0 ; $i <= $imax && $i <= $jmax ; ++$i) {

        # The so far remaining unreduced submatrix starts at element ($i,$i).

        # Skip this round, if all elements below (i,i) are zero.

        my $saw_non_zero = 0;
        for (my $u = $i + 1 ; $u <= $imax ; ++$u) {
            if ($x->[$u][$i] != 0) {
                $saw_non_zero = 1;
                last;
            }
        }
        next unless $saw_non_zero;

        # The pivot element is the first element in column $i (in the unreduced
        # submatrix) that is non-zero.

        my $p;          # index of pivot row

        for (my $u = $i ; $u <= $imax ; ++$u) {
            if ($x->[$u][$i] != 0) {
                $p = $u;
                last;
            }
        }

        printf "\nfelim_tp(): pivot element is (%u,%u)\n", $p, $i if $debug;

        # Swap rows $i and $p.

        if ($p != $i) {
            ($x->[$i], $x->[$p]) = ($x->[$p], $x->[$i]);
            ($iperm->[$i], $iperm->[$p]) = ($iperm->[$p], $iperm->[$i]);
            $iswap++;
        }

        # Subtract row $i from all following rows.

        for (my $u = $i + 1 ; $u <= $imax ; ++$u) {

            for (my $j = $jmax ; $j >= $i ; --$j) {
                $x->[$u][$j] -= ($x->[$i][$j] * $x->[$u][$i]) / $x->[$i][$i];
            }

            # In case of round-off errors.

            $x->[$u][$i] *= 0;
        }

        printf "\nfelim_tp(): after %u:\n\n%s\n\n", $i, $x if $debug;
    }

    return $x, $iperm, $jperm, $iswap, $jswap if wantarray;
    return $x;
}

=pod

=item felim_pp()

Perform forward elimination with (unscaled) partial pivoting.

    $y = $x -> felim_pp();

If A is a p-by-q matrix, and the so far remaining unreduced submatrix starts at
element (i,i), the pivot element is the element in column i that has the largest
absolute value.

This method is provided mostly for illustration purposes.

=cut

sub felim_pp {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    croak "felim_pp(): too many input arguments" if @_ > 0;

    $x = $x -> clone();
    my $nrow = $x -> nrow();
    my $ncol = $x -> ncol();

    my $imax = $nrow - 1;
    my $jmax = $ncol - 1;

    my $iperm = [ 0 .. $imax ];         # row permutation vector
    my $jperm = [ 0 .. $imax ];         # column permutation vector
    my $iswap = 0;                      # number of row swaps
    my $jswap = 0;                      # number of column swaps

    my $debug = 0;

    printf "\nfelim_pp(): before 0:\n\n%s\n", $x if $debug;

    for (my $i = 0 ; $i <= $imax && $i <= $jmax ; ++$i) {

        # The so far remaining unreduced submatrix starts at element ($i,$i).

        # Skip this round, if all elements below (i,i) are zero.

        my $saw_non_zero = 0;
        for (my $u = $i + 1 ; $u <= $imax ; ++$u) {
            if ($x->[$u][$i] != 0) {
                $saw_non_zero = 1;
                last;
            }
        }
        next unless $saw_non_zero;

        # The pivot element is the element in column $i (in the unreduced
        # submatrix) that has the largest absolute value.

        my $p;                  # index of pivot row
        my $max_abs_val = 0;

        for (my $u = $i ; $u <= $imax ; ++$u) {
            my $abs_val = CORE::abs($x->[$u][$i]);
            if ($abs_val > $max_abs_val) {
                $max_abs_val = $abs_val;
                $p = $u;
            }
        }

        printf "\nfelim_pp(): pivot element is (%u,%u)\n", $p, $i if $debug;

        # Swap rows $i and $p.

        if ($p != $i) {
            ($x->[$p], $x->[$i]) = ($x->[$i], $x->[$p]);
            ($iperm->[$p], $iperm->[$i]) = ($iperm->[$i], $iperm->[$p]);
            $iswap++;
        }

        # Subtract row $i from all following rows.

        for (my $u = $i + 1 ; $u <= $imax ; ++$u) {

            for (my $j = $jmax ; $j >= $i ; --$j) {
                $x->[$u][$j] -= ($x->[$i][$j] * $x->[$u][$i]) / $x->[$i][$i];
            }

            # In case of round-off errors.

            $x->[$u][$i] *= 0;
        }

        printf "\nfelim_pp(): after %u:\n\n%s\n\n", $i, $x if $debug;
    }

    return $x, $iperm, $jperm, $iswap, $jswap if wantarray;
    return $x;
}

=pod

=item felim_sp()

Perform forward elimination with scaled pivoting, a variant of partial pivoting.

    $y = $x -> felim_sp();

If A is a p-by-q matrix, and the so far remaining unreduced submatrix starts at
element (i,i), the pivot element is the element in column i that has the largest
absolute value relative to the other elements on the same row.

=cut

sub felim_sp {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    croak "felim_sp(): too many input arguments" if @_ > 0;

    $x = $x -> clone();
    my $nrow = $x -> nrow();
    my $ncol = $x -> ncol();

    my $imax = $nrow - 1;
    my $jmax = $ncol - 1;

    my $iperm = [ 0 .. $imax ];         # row permutation vector
    my $jperm = [ 0 .. $imax ];         # column permutation vector
    my $iswap = 0;                      # number of row swaps
    my $jswap = 0;                      # number of column swaps

    my $debug = 0;

    printf "\nfelim_sp(): before 0:\n\n%s\n", $x if $debug;

    for (my $i = 0 ; $i <= $imax && $i <= $jmax ; ++$i) {

        # The so far remaining unreduced submatrix starts at element ($i,$i).

        # Skip this round, if all elements below (i,i) are zero.

        my $saw_non_zero = 0;
        for (my $u = $i + 1 ; $u <= $imax ; ++$u) {
            if ($x->[$u][$i] != 0) {
                $saw_non_zero = 1;
                last;
            }
        }
        next unless $saw_non_zero;

        # The pivot element is the element in column $i (in the unreduced
        # submatrix) that has the largest absolute value relative to the other
        # elements on the same row.

        my $p;
        my $max_abs_ratio = 0;

        for (my $u = $i ; $u <= $imax ; ++$u) {

            # Find the element with the largest absolute value in row $u.

            my $max_abs_val = 0;
            for (my $v = $i ; $v <= $jmax ; ++$v) {
                my $abs_val = CORE::abs($x->[$u][$v]);
                $max_abs_val = $abs_val if $abs_val > $max_abs_val;
            }

            next if $max_abs_val == 0;

            # Find the ratio for this row and see if it the best so far.

            my $abs_ratio = CORE::abs($x->[$u][$i]) / $max_abs_val;
            #croak "column ", $i + 1, " has only zeros"
            #  if $ratio == 0;

            if ($abs_ratio > $max_abs_ratio) {
                $max_abs_ratio = $abs_ratio;
                $p = $u;
            }

        }

        printf "\nfelim_sp(): pivot element is (%u,%u)\n", $p, $i if $debug;

        # Swap rows $i and $p.

        if ($p != $i) {
            ($x->[$p], $x->[$i]) = ($x->[$i], $x->[$p]);
            ($iperm->[$p], $iperm->[$i]) = ($iperm->[$i], $iperm->[$p]);
            $iswap++;
        }

        # Subtract row $i from all following rows.

        for (my $u = $i + 1 ; $u <= $imax ; ++$u) {

            for (my $j = $jmax ; $j >= $i ; --$j) {
                $x->[$u][$j] -= ($x->[$i][$j] * $x->[$u][$i]) / $x->[$i][$i];
            }

            # In case of round-off errors.

            $x->[$u][$i] *= 0;
        }

        printf "\nfelim_sp(): after %u:\n\n%s\n\n", $i, $x if $debug;
    }

    return $x, $iperm, $jperm, $iswap, $jswap if wantarray;
    return $x;
}

=pod

=item felim_fp()

Performs forward elimination with full pivoting.

    $y = $x -> felim_fp();

The elimination is done with full pivoting, also called complete pivoting or
total pivoting. If A is a p-by-q matrix, and the so far remaining unreduced
submatrix starts at element (i,i), the pivot element is the element in the whole
submatrix that has the largest absolute value. With full pivoting, both rows and
columns might be swapped.

=cut

sub felim_fp {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    croak "felim_fp(): too many input arguments" if @_ > 0;

    $x = $x -> clone();
    my $nrow = $x -> nrow();
    my $ncol = $x -> ncol();

    my $imax = $nrow - 1;
    my $jmax = $ncol - 1;

    my $iperm = [ 0 .. $imax ];         # row permutation vector
    my $jperm = [ 0 .. $imax ];         # column permutation vector
    my $iswap = 0;                      # number of row swaps
    my $jswap = 0;                      # number of column swaps

    my $debug = 0;

    printf "\nfelim_fp(): before 0:\n\n%s\n", $x if $debug;

    for (my $i = 0 ; $i <= $imax && $i <= $jmax ; ++$i) {

        # The so far remaining unreduced submatrix starts at element ($i,$i).
        # The pivot element is the element in the whole submatrix that has the
        # largest absolute value.

        my $p;                  # index of pivot row
        my $q;                  # index of pivot column

        # Loop over each row and column in the submatrix to find the element
        # with the largest absolute value.

        my $max_abs_val = 0;
        for (my $u = $i ; $u <= $imax ; ++$u) {
            for (my $v = $i ; $v <= $imax && $v <= $jmax ; ++$v) {
                my $abs_val = CORE::abs($x->[$u][$v]);
                if ($abs_val > $max_abs_val) {
                    $max_abs_val = $abs_val;
                    $p = $u;
                    $q = $v;
                }
            }
        }

        # If we didn't find a pivot element, it means that the so far unreduced
        # submatrix contains zeros only, in which case we're done.

        last unless defined $p;

        printf "\nfelim_fp(): pivot element is (%u,%u)\n", $p, $q if $debug;

        # Swap rows $i and $p.

        if ($p != $i) {
            printf "\nfelim_fp(): swapping rows %u and %u\n", $p, $i if $debug;
            printf "\nfrom this:\n\n%s\n", $x if $debug;
            ($x->[$p], $x->[$i]) = ($x->[$i], $x->[$p]);
            printf "\nto this:\n\n%s\n", $x if $debug;
            ($iperm->[$p], $iperm->[$i]) = ($iperm->[$i], $iperm->[$p]);
            $iswap++;
        }

        # Swap columns $i and $q.

        if ($q != $i) {
            printf "\nfelim_fp(): swapping columns %u and %u\n", $q, $i if $debug;
            printf "\nfrom this:\n\n%s\n", $x if $debug;
            for (my $u = 0 ; $u <= $imax ; ++$u) {
                ($x->[$u][$q], $x->[$u][$i]) = ($x->[$u][$i], $x->[$u][$q]);
            }
            printf "\nto this:\n\n%s\n", $x if $debug;
            ($jperm->[$q], $jperm->[$i]) = ($jperm->[$i], $jperm->[$q]);
            $jswap++;
        }

        # Subtract row $i from all following rows.

        for (my $u = $i + 1 ; $u <= $imax ; ++$u) {

            for (my $j = $jmax ; $j >= $i ; --$j) {
                $x->[$u][$j] -= ($x->[$i][$j] * $x->[$u][$i]) / $x->[$i][$i];
            }

            # In case of round-off errors.

            $x->[$u][$i] *= 0;
        }

        printf "\nfelim_fp(): after %u:\n\n%s\n\n", $i, $x if $debug;
    }

    return $x, $iperm, $jperm, $iswap, $jswap if wantarray;
    return $x;
}

=pod

=back

=head3 Back-substitution

=over 4

=item bsubs()

Performs back-substitution.

    $y = $x -> bsubs();

The leftmost square portion of the matrix must be upper triangular.

=cut

sub bsubs {
    croak "Not enough arguments for ", (caller(0))[3] if @_ < 1;
    croak "Too many arguments for ", (caller(0))[3] if @_ > 1;
    my $x = shift;

    croak "bsubs(): too many input arguments" if @_ > 0;

    my $nrow = $x -> nrow();
    my $ncol = $x -> ncol();

    my $imax = $nrow - 1;
    my $jmax = $ncol - 1;

    my $debug = 0;

    printf "\nbsubs(): before 0:\n\n%s\n", $x if $debug;

    for (my $i = 0 ; $i <= $imax ; ++$i) {

        # Check the elements below ($i,$i). They should all be zero.

        for (my $k = $i + 1 ; $k <= $imax ; ++$k) {
            croak "matrix is not upper triangular; element ($i,$i) is non-zero"
              unless $x->[$k][$i] == 0;
        }

        # There is no rows above the first row to perform back-substitution on.

        next if $i == 0;

        # If the element on the diagonal is zero, we can't use it to perform
        # back-substitution. However, this is not a problem if all the elements
        # above ($i,$i) are zero.

        if ($x->[$i][$i] == 0) {
            my $non_zero = 0;
            my $k;
            for ($k = 0 ; $k < $i ; ++$k) {
                if ($x->[$k][$i] != 0) {
                    $non_zero++;
                    last;
                }
            }
            if ($non_zero) {
                croak "bsubs(): back substitution failed; diagonal element",
                  " ($i,$i) is zero, but ($k,$i) isn't";
                next;
            }
        }

        # Subtract row $i from each row $u above row $i.

        for (my $u = $i - 1 ; $u >= 0 ; --$u) {

            # From row $u subtract $c times of row $i.

            my $c = $x->[$u][$i] / $x->[$i][$i];

            for (my $j = $jmax ; $j >= $i ; --$j) {
                $x->[$u][$j] -= $c * $x->[$i][$j];
            }

            # In case of round-off errors.  (Will they ever happen?)

            $x->[$u][$i] *= 0;
        }

        printf "\nbsubs(): after %u:\n\n%s\n\n", $i, $x if $debug;
    }

    # Normalise.

    for (my $i = 0 ; $i <= $imax ; ++$i) {
        next if $x->[$i][$i] == 1;      # row is already normalized
        next if $x->[$i][$i] == 0;      # row can't be normalized
        for (my $j = $imax + 1 ; $j <= $jmax ; ++$j) {
            $x->[$i][$j] /= $x->[$i][$i];
        }
        $x->[$i][$i] = 1;
    }

    printf "\nbsubs(): after normalisation:\n\n%s\n\n", $x if $debug;

    return $x;
}

=pod

=back

=head2 Miscellaneous methods

=over 4

=item print()

Prints the matrix on STDOUT. If the method has additional parameters, these are
printed before the matrix is printed.

=cut

sub print {
    my $self = shift;

    print @_ if scalar(@_);
    print $self->as_string;
}

=pod

=item version()

Returns a string contining the package name and version number.

=cut

sub version {
    return "Math::Matrix $VERSION";
}

# Internal utility methods.

# Compute the sum of all elements using Neumaier's algorithm, an improvement
# over Kahan's algorithm.
#
# See
# https://en.wikipedia.org/wiki/Kahan_summation_algorithm#Further_enhancements

sub _sum {
    my $sum = 0;
    my $c = 0;

    for (@_) {
        my $t = $sum + $_;
        if (CORE::abs($sum) >= CORE::abs($_)) {
            $c += ($sum - $t) + $_;
        } else {
            $c += ($_ - $t) + $sum;
        }
        $sum = $t;
    }

    return $sum + $c;
}

# _prod LIST
#

sub _prod {
    my $prod = 1;
    $prod *= $_ for @_;
    return $prod;
}

# _mean LIST
#
# Method for finding the mean.

sub _mean {
    return 0 unless @_;
    _sum(@_) / @_;
}

# Method used to calculate the length of the hypotenuse of a right-angle
# triangle. It is designed to avoid errors arising due to limited-precision
# calculations performed on computers. E.g., with double-precision arithmetic:
#
#     sqrt(3e200**2 + 4e200**2)    # = Inf, due to overflow
#     _hypot(3e200, 4e200)         # = 5e200, which is correct
#
#     sqrt(3e-200**2 + 4e-200**2)  # = 0, due to underflow
#     _hypot(3e-200, 4e-200)       # = 5e-200, which is correct
#
# See https://en.wikipedia.org/wiki/Hypot

sub _hypot {
    my @x = map { CORE::abs($_) } @_;

    # Compute the maximum value.

    my $max = _max(@x);
    return 0 if $max == 0;

    # Scale and square the values.

    for (@x) {
        $_ /= $max;
        $_ *= $_;
    }

    $max * sqrt(_sum(@x))
}

# _sumsq LIST
#
# Sum of squared absolute values.

sub _sumsq {
    _sum(map { $_ * $_ } map { CORE::abs($_) } @_);
}

# _vecnorm P, LIST
#
# Vector P-norm. If the input is $x[0], $x[1], ..., then the output is
#
#   (abs($x[0])**$p + abs($x[1])**$p + ...)**(1/$p)

sub _vecnorm {
    my $p = shift;
    my @x = map { CORE::abs($_) } @_;

    return _sum(@x) if $p == 1;

    require Math::Trig;
    my $inf = Math::Trig::Inf();

    return _max(@x) if $p == $inf;

    # Compute the maximum value.

    my $max = 0;
    for (@x) {
        $max = $_ if $_ > $max;
    }

    # Scale and apply power function.

    for (@x) {
        $_ /= $max;
        $_ **= $p;
    }

    $max * _sum(@x) ** (1/$p);
}

# _min LIST
#
# Minimum value.

sub _min {
    my $min = shift;
    for (@_) {
        $min = $_ if $_ < $min;
    }

    return $min;
}

# _max LIST
#
# Maximum value.

sub _max {
    my $max = shift;
    for (@_) {
        $max = $_ if $_ > $max;
    }

    return $max;
}

# _median LIST
#
# Method for finding the median.

sub _median {
    my @x = sort { $a <=> $b } @_;
    if (@x % 2) {
         $x[$#x / 2];
    } else {
        ($x[@x / 2] + $x[@x / 2 - 1]) / 2;
    }
}

# _any LIST
#
# Method that returns 1 if at least one value in LIST is non-zero and 0
# otherwise.

sub _any {
    for (@_) {
        return 1 if $_ != 0;
    }
    return 0;
}

# _all LIST
#
# Method that returns 1 if all values in LIST are non-zero and 0 otherwise.

sub _all {
    for (@_) {
        return 0 if $_ == 0;
    }
    return 1;
}

# _cumsum LIST
#
# Cumulative sum. If the input is $x[0], $x[1], ..., then output element $y[$i]
# is the sum of the elements $x[0], $x[1], ..., $x[$i].

sub _cumsum {
    my @sum = ();

    my $sum = 0;
    my $c = 0;

    for (@_) {
        my $t = $sum + $_;
        if (CORE::abs($sum) >= CORE::abs($_)) {
            $c += ($sum - $t) + $_;
        } else {
            $c += ($_ - $t) + $sum;
        }
        $sum = $t;
        push @sum, $sum + $c;
    }

    return @sum;
}

# _cumprod LIST
#
# Cumulative product. If the input is $x[0], $x[1], ..., then output element
# $y[$i] is the product of the elements $x[0], $x[1], ..., $x[$i].

sub _cumprod {
    my @prod = shift;
    push @prod, $prod[-1] * $_ for @_;
    return @prod;
}

# _cummean LIST
#
# Cumulative mean. If the input is $x[0], $x[1], ..., then output element $y[$i]
# is the mean of the elements $x[0], $x[1], ..., $x[$i].

sub _cummean {
    my @mean = ();
    my $sum = 0;
    for my $i (0 .. $#_) {
        $sum += $_[$i];
        push @mean, $sum / ($i + 1);
    }
    return @mean;
}

# _cummean LIST
#
# Cumulative minimum. If the input is $x[0], $x[1], ..., then output element
# $y[$i] is the minimum of the elements $x[0], $x[1], ..., $x[$i].

sub _cummin {
    my @min = shift;
    for (@_) {
        push @min, $min[-1] < $_ ? $min[-1] : $_;
    }
    return @min;
}

# _cummax LIST
#
# Cumulative maximum. If the input is $x[0], $x[1], ..., then output element
# $y[$i] is the maximum of the elements $x[0], $x[1], ..., $x[$i].

sub _cummax {
    my @max = shift;
    for (@_) {
        push @max, $max[-1] > $_ ? $max[-1] : $_;
    }
    return @max;
}

# _cumany LIST
#
# Cumulative any. If the input is $x[0], $x[1], ..., then output element $y[$i]
# is 1 if at least one of the elements $x[0], $x[1], ..., $x[$i] is non-zero,
# and 0 otherwise.

sub _cumany {
    my @any = ();
    for (@_) {
        if ($_ != 0) {
            push @any, (1) x (@_ - @any);
            last;
        }
        push @any, 0;
    }
    return @any;
}

# _cumall LIST
#
# Cumulative all. If the input is $x[0], $x[1], ..., then output element $y[$i]
# is 1 if all of the elements $x[0], $x[1], ..., $x[$i] are non-zero, and 0
# otherwise.

sub _cumall {
    my @all = ();
    for (@_) {
        if ($_ == 0) {
            push @all, (0) x (@_ - @all);
            last;
        }
        push @all, 1;
    }
    return @all;
}

# _diff LIST
#
# Difference. If the input is $x[0], $x[1], ..., then output element $y[$i] =
# $x[$i+1] - $x[$i].

sub _diff {
    my @diff = ();
    for my $i (1 .. $#_) {
        push @diff, $_[$i] - $_[$i - 1];
    }
    return @diff;
}

=pod

=back

=head1 OVERLOADING

The following operators are overloaded.

=over 4

=item C<+> and C<+=>

Matrix or scalar addition. Unless one or both of the operands is a scalar, both
operands must have the same size.

    $C  = $A + $B;      # assign $A + $B to $C
    $A += $B;           # assign $A + $B to $A

Note that

=item C<-> and C<-=>

Matrix or scalar subtraction. Unless one or both of the operands is a scalar,
both operands must have the same size.

    $C  = $A + $B;      # assign $A - $B to $C
    $A += $B;           # assign $A - $B to $A

=item C<*> and C<*=>

Matrix or scalar multiplication. Unless one or both of the operands is a scalar,
the number of columns in the first operand must be equal to the number of rows
in the second operand.

    $C  = $A * $B;      # assign $A * $B to $C
    $A *= $B;           # assign $A * $B to $A

=item C<**> and C<**=>

Matrix power. The second operand must be a scalar.

    $C  = $A * $B;      # assign $A ** $B to $C
    $A *= $B;           # assign $A ** $B to $A

=item C<==>

Equal to.

    $A == $B;           # is $A equal to $B?

=item C<!=>

Not equal to.

    $A != $B;           # is $A not equal to $B?

=item C<neg>

Negation.

    $B = -$A;           # $B is the negative of $A

=item C<~>

Transpose.

    $B = ~$A;           # $B is the transpose of $A

=item C<abs>

Absolute value.

    $B = abs $A;        # $B contains absolute values of $A

=item C<int>

Truncate to integer.

    $B = int $A;        # $B contains only integers

=back

=head1 IMPROVING THE SOLUTION OF LINEAR SYSTEMS

The methods that do an explicit or implicit matrix left division accept some
additional parameters. If these parameters are specified, the matrix left
division is done repeatedly in an iterative way, which often gives a better
solution.

=head2 Background

The linear system of equations

    $A * $x = $y

can be solved for C<$x> with

    $x = $y -> mldiv($A);

Ideally C<$A * $x> should equal C<$y>, but due to numerical errors, this is not
always the case. The following illustrates how to improve the solution C<$x>
computed above:

    $r = $A -> mmuladd($x, -$y);    # compute the residual $A*$x-$y
    $d = $r -> mldiv($A);           # compute the delta for $x
    $x -= $d;                       # improve the solution $x

This procedure is repeated, and at each step, the absolute error

    ||$A*$x - $y|| = ||$r||

and the relative error

    ||$A*$x - $y|| / ||$y|| = ||$r|| / ||$y||

are computed and compared to the tolerances. Once one of the stopping criteria
is satisfied, the algorithm terminates.

=head2 Stopping criteria

The algorithm stops when at least one of the errors are within the specified
tolerances or the maximum number of iterations is reached. If the maximum number
of iterations is reached, but noen of the errors are within the tolerances, a
warning is displayed and the best solution so far is returned.

=head2 Parameters

=over 4

=item MaxIter

The maximum number of iterations to perform. The value must be a positive
integer. The default is 20.

=item RelTol

The limit for the relative error. The value must be a non-negative. The default
value is 1e-19 when perl is compiled with long doubles or quadruple precision,
and 1e-9 otherwise.

=item AbsTol

The limit for the absolute error. The value must be a non-negative. The default
value is 0.

=item Debug

If this parameter does not affect when the algorithm terminates, but when set to
non-zero, some information is displayed at each step.

=back

=head2 Example

If

    $A = [[  8, -8, -5,  6, -1,  3 ],
          [ -7, -1,  5, -9,  5,  6 ],
          [ -7,  8,  9, -2, -4,  3 ],
          [  3, -4,  5,  5,  3,  3 ],
          [  9,  8, -3, -4,  1,  6 ],
          [ -8,  9, -1,  3,  5,  2 ]];

    $y = [[  80, -13 ],
          [  -2, 104 ],
          [ -57, -27 ],
          [  47, -28 ],
          [   5,  77 ],
          [  91, 133 ]];

the result of C<< $x = $y -> mldiv($A); >>, using double precision arithmetic,
is the approximate solution

    $x = [[ -2.999999999999998, -5.000000000000000 ],
          [ -1.000000000000000,  3.000000000000001 ],
          [ -5.999999999999997, -8.999999999999996 ],
          [  8.000000000000000, -2.000000000000003 ],
          [  6.000000000000003,  9.000000000000002 ],
          [  7.999999999999997,  8.999999999999995 ]];

The residual C<< $res = $A -> mmuladd($x, -$y); >> is

    $res = [[  1.24344978758018e-14,  1.77635683940025e-15 ],
            [  8.88178419700125e-15, -5.32907051820075e-15 ],
            [ -1.24344978758018e-14,  1.77635683940025e-15 ],
            [ -7.10542735760100e-15, -4.08562073062058e-14 ],
            [ -1.77635683940025e-14, -3.81916720471054e-14 ],
            [  1.24344978758018e-14,  8.43769498715119e-15 ]];

and the delta C<< $dx = $res -> mldiv($A); >> is

    $dx = [[   -8.592098303124e-16, -2.86724066474914e-15 ],
           [ -7.92220125658508e-16, -2.99693950082398e-15 ],
           [ -2.22533360993874e-16,  3.03465504177947e-16 ],
           [  6.47376093198353e-17, -1.12378127899388e-15 ],
           [  6.35204502123966e-16,  2.40938179521241e-15 ],
           [  1.55166908001001e-15,  2.08339859425849e-15 ]];

giving the improved, and in this case exact, solution C<< $x -= $dx; >>,

    $x = [[ -3, -5 ],
          [ -1,  3 ],
          [ -6, -9 ],
          [  8, -2 ],
          [  6,  9 ],
          [  8,  9 ]];

=head1 SUBCLASSING

The methods should work fine with any kind of numerical objects, provided that
the assignment operator C<=> is overloaded, so that Perl knows how to create a
copy.

You can check the behaviour of the assignment operator by assigning a value to a
new variable, modify the new variable, and check whether this also modifies the
original value. Here is an example:

    $x = Some::Class -> new(0);           # create object $x
    $y = $x;                              # create new variable $y
    $y++;                                 # modify $y
    print "it's a clone\n" if $x != $y;   # is $x modified?

The subclass might need to implement some methods of its own. For instance, if
each element is a complex number, a transpose() method needs to be implemented
to take the complex conjugate of each value. An as_string() method might also be
useful for displaying the matrix in a format more suitable for the subclass.

Here is an example showing Math::Matrix::Complex, a fully-working subclass of
Math::Matrix, where each element is a Math::Complex object.

    use strict;
    use warnings;

    package Math::Matrix::Complex;

    use Math::Matrix;
    use Scalar::Util 'blessed';
    use Math::Complex 1.57;     # "=" didn't clone before 1.57

    our @ISA = ('Math::Matrix');

    # We need a new() method to make sure every element is an object.

    sub new {
        my $self = shift;
        my $x = $self -> SUPER::new(@_);

        my $sub = sub {
            defined(blessed($_[0])) && $_[0] -> isa('Math::Complex')
              ? $_[0]
              : Math::Complex -> new($_[0]);
        };

        return $x -> sapply($sub);
    }

    # We need a transpose() method, since the transpose of a matrix
    # with complex numbers also takes the conjugate of all elements.

    sub transpose {
        my $x = shift;
        my $y = $x -> SUPER::transpose(@_);

        return $y -> sapply(sub { ~$_[0] });
    }

    # We need an as_string() method, since our parent's methods
    # doesn't format complex numbers correctly.

    sub as_string {
        my $self = shift;
        my $out = "";
        for my $row (@$self) {
            for my $elm (@$row) {
                $out = $out . sprintf "%10s ", $elm;
            }
            $out = $out . sprintf "\n";
        }
        $out;
    }

    1;

=head1 BUGS

Please report any bugs or feature requests via
L<https://github.com/pjacklam/p5-Math-Matrix/issues>.

Old bug reports and feature requests can be found at
L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Math-Matrix>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Math::Matrix

You can also look for information at:

=over 4

=item * GitHub Source Repository

L<https://github.com/pjacklam/p5-Math-Matrix>

=item * MetaCPAN

L<https://metacpan.org/release/Math-Matrix>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Math-Matrix>

=item * CPAN Testers PASS Matrix

L<http://pass.cpantesters.org/distro/A/Math-Matrix.html>

=item * CPAN Testers Reports

L<http://www.cpantesters.org/distro/A/Math-Matrix.html>

=item * CPAN Testers Matrix

L<http://matrix.cpantesters.org/?dist=Math-Matrix>

=back

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2020-2021, Peter John Acklam

Copyright (C) 2013, John M. Gamble <jgamble@ripco.com>, all rights reserved.

Copyright (C) 2009, oshalla
https://rt.cpan.org/Public/Bug/Display.html?id=42919

Copyright (C) 2002, Bill Denney <gte273i@prism.gatech.edu>, all rights
reserved.

Copyright (C) 2001, Brian J. Watson <bjbrew@power.net>, all rights reserved.

Copyright (C) 2001, Ulrich Pfeifer <pfeifer@wait.de>, all rights reserved.
Copyright (C) 1995, Universität Dortmund, all rights reserved.

Copyright (C) 2001, Matthew Brett <matthew.brett@mrc-cbu.cam.ac.uk>

This program is free software; you may redistribute it and/or modify it under
the same terms as Perl itself.

=head1 AUTHORS

Peter John Acklam E<lt>pjacklam@gmail.comE<gt> (2020-2021)

Ulrich Pfeifer E<lt>pfeifer@ls6.informatik.uni-dortmund.deE<gt> (1995-2013)

Brian J. Watson E<lt>bjbrew@power.netE<gt>

Matthew Brett E<lt>matthew.brett@mrc-cbu.cam.ac.ukE<gt>

=cut

1;
