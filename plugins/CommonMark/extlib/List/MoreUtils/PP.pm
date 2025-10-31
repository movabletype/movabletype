package List::MoreUtils::PP;

use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.430';

=pod

=head1 NAME

List::MoreUtils::PP - Provide List::MoreUtils pure Perl implementation

=head1 SYNOPSIS

  BEGIN { $ENV{LIST_MOREUTILS_PP} = 1; }
  use List::MoreUtils qw(:all);

=cut

## no critic (Subroutines::ProhibitSubroutinePrototypes, Subroutines::RequireArgUnpacking)
## no critic (Subroutines::ProhibitManyArgs)

sub any (&@)
{
    my $f = shift;
    foreach (@_)
    {
        return 1 if $f->();
    }
    return 0;
}

sub all (&@)
{
    my $f = shift;
    foreach (@_)
    {
        return 0 unless $f->();
    }
    return 1;
}

sub none (&@)
{
    my $f = shift;
    foreach (@_)
    {
        return 0 if $f->();
    }
    return 1;
}

sub notall (&@)
{
    my $f = shift;
    foreach (@_)
    {
        return 1 unless $f->();
    }
    return 0;
}

sub one (&@)
{
    my $f     = shift;
    my $found = 0;
    foreach (@_)
    {
        $f->() and $found++ and return 0;
    }
    return $found;
}

sub any_u (&@)
{
    my $f = shift;
    return if !@_;
    $f->() and return 1 foreach (@_);
    return 0;
}

sub all_u (&@)
{
    my $f = shift;
    return if !@_;
    $f->() or return 0 foreach (@_);
    return 1;
}

sub none_u (&@)
{
    my $f = shift;
    return if !@_;
    $f->() and return 0 foreach (@_);
    return 1;
}

sub notall_u (&@)
{
    my $f = shift;
    return if !@_;
    $f->() or return 1 foreach (@_);
    return 0;
}

sub one_u (&@)
{
    my $f = shift;
    return if !@_;
    my $found = 0;
    foreach (@_)
    {
        $f->() and $found++ and return 0;
    }
    return $found;
}

sub reduce_u(&@)
{
    my $code = shift;

    # Localise $a, $b
    my ($caller_a, $caller_b) = do
    {
        my $pkg = caller();
        ## no critic (TestingAndDebugging::ProhibitNoStrict, ValuesAndExpressions::ProhibitCommaSeparatedStatements)
        no strict 'refs';
        \*{$pkg . '::a'}, \*{$pkg . '::b'};
    };

    ## no critic (Variables::RequireInitializationForLocalVars)
    local (*$caller_a, *$caller_b);
    *$caller_a = \();
    for (0 .. $#_)
    {
        *$caller_b = \$_[$_];
        *$caller_a = \($code->());
    }

    return ${*$caller_a};
}

sub reduce_0(&@)
{
    my $code = shift;

    # Localise $a, $b
    my ($caller_a, $caller_b) = do
    {
        my $pkg = caller();
        ## no critic (TestingAndDebugging::ProhibitNoStrict, ValuesAndExpressions::ProhibitCommaSeparatedStatements)
        no strict 'refs';
        \*{$pkg . '::a'}, \*{$pkg . '::b'};
    };

    ## no critic (Variables::RequireInitializationForLocalVars)
    local (*$caller_a, *$caller_b);
    *$caller_a = \0;
    for (0 .. $#_)
    {
        *$caller_b = \$_[$_];
        *$caller_a = \($code->());
    }

    return ${*$caller_a};
}

sub reduce_1(&@)
{
    my $code = shift;

    # Localise $a, $b
    my ($caller_a, $caller_b) = do
    {
        my $pkg = caller();
        ## no critic (TestingAndDebugging::ProhibitNoStrict, ValuesAndExpressions::ProhibitCommaSeparatedStatements)
        no strict 'refs';
        \*{$pkg . '::a'}, \*{$pkg . '::b'};
    };

    ## no critic (Variables::RequireInitializationForLocalVars)
    local (*$caller_a, *$caller_b);
    *$caller_a = \1;
    for (0 .. $#_)
    {
        *$caller_b = \$_[$_];
        *$caller_a = \($code->());
    }

    return ${*$caller_a};
}

sub true (&@)
{
    my $f     = shift;
    my $count = 0;
    $f->() and ++$count foreach (@_);
    return $count;
}

sub false (&@)
{
    my $f     = shift;
    my $count = 0;
    $f->() or ++$count foreach (@_);
    return $count;
}

sub firstidx (&@)
{
    my $f = shift;
    foreach my $i (0 .. $#_)
    {
        local *_ = \$_[$i];
        return $i if $f->();
    }
    return -1;
}

sub firstval (&@)
{
    my $test = shift;
    foreach (@_)
    {
        return $_ if $test->();
    }
    ## no critic (Subroutines::ProhibitExplicitReturnUndef)
    return undef;
}

sub firstres (&@)
{
    my $test = shift;
    foreach (@_)
    {
        my $testval = $test->();
        $testval and return $testval;
    }
    ## no critic (Subroutines::ProhibitExplicitReturnUndef)
    return undef;
}

sub onlyidx (&@)
{
    my $f = shift;
    my $found;
    foreach my $i (0 .. $#_)
    {
        local *_ = \$_[$i];
        $f->() or next;
        defined $found and return -1;
        $found = $i;
    }
    return defined $found ? $found : -1;
}

sub onlyval (&@)
{
    my $test   = shift;
    my $result = undef;
    my $found  = 0;
    foreach (@_)
    {
        $test->() or next;
        $result = $_;
        ## no critic (Subroutines::ProhibitExplicitReturnUndef)
        $found++ and return undef;
    }
    return $result;
}

sub onlyres (&@)
{
    my $test   = shift;
    my $result = undef;
    my $found  = 0;
    foreach (@_)
    {
        my $rv = $test->() or next;
        $result = $rv;
        ## no critic (Subroutines::ProhibitExplicitReturnUndef)
        $found++ and return undef;
    }
    return $found ? $result : undef;
}

sub lastidx (&@)
{
    my $f = shift;
    foreach my $i (reverse 0 .. $#_)
    {
        local *_ = \$_[$i];
        return $i if $f->();
    }
    return -1;
}

sub lastval (&@)
{
    my $test = shift;
    my $ix;
    for ($ix = $#_; $ix >= 0; $ix--)
    {
        local *_ = \$_[$ix];
        my $testval = $test->();

        # Simulate $_ as alias
        $_[$ix] = $_;
        return $_ if $testval;
    }
    ## no critic (Subroutines::ProhibitExplicitReturnUndef)
    return undef;
}

sub lastres (&@)
{
    my $test = shift;
    my $ix;
    for ($ix = $#_; $ix >= 0; $ix--)
    {
        local *_ = \$_[$ix];
        my $testval = $test->();

        # Simulate $_ as alias
        $_[$ix] = $_;
        return $testval if $testval;
    }
    ## no critic (Subroutines::ProhibitExplicitReturnUndef)
    return undef;
}

sub insert_after (&$\@)
{
    my ($f, $val, $list) = @_;
    my $c = &firstidx($f, @$list);
    @$list = (@{$list}[0 .. $c], $val, @{$list}[$c + 1 .. $#$list],) and return 1 if $c != -1;
    return 0;
}

sub insert_after_string ($$\@)
{
    my ($string, $val, $list) = @_;
    my $c = firstidx { defined $_ and $string eq $_ } @$list;
    @$list = (@{$list}[0 .. $c], $val, @{$list}[$c + 1 .. $#$list],) and return 1 if $c != -1;
    return 0;
}

sub apply (&@)
{
    my $action = shift;
    &$action foreach my @values = @_;
    return wantarray ? @values : $values[-1];
}

sub after (&@)
{
    my $test = shift;
    my $started;
    my $lag;
    ## no critic (BuiltinFunctions::RequireBlockGrep)
    return grep $started ||= do
    {
        my $x = $lag;
        $lag = $test->();
        $x;
    }, @_;
}

sub after_incl (&@)
{
    my $test = shift;
    my $started;
    return grep { $started ||= $test->() } @_;
}

sub before (&@)
{
    my $test = shift;
    my $more = 1;
    return grep { $more &&= !$test->() } @_;
}

sub before_incl (&@)
{
    my $test = shift;
    my $more = 1;
    my $lag  = 1;
    ## no critic (BuiltinFunctions::RequireBlockGrep)
    return grep $more &&= do
    {
        my $x = $lag;
        $lag = !$test->();
        $x;
    }, @_;
}

sub indexes (&@)
{
    my $test = shift;
    return grep {
        local *_ = \$_[$_];
        $test->()
    } 0 .. $#_;
}

sub pairwise (&\@\@)
{
    my $op = shift;

    # Symbols for caller's input arrays
    use vars qw{ @A @B };
    local (*A, *B) = @_;

    # Localise $a, $b
    my ($caller_a, $caller_b) = do
    {
        my $pkg = caller();
        ## no critic (TestingAndDebugging::ProhibitNoStrict, ValuesAndExpressions::ProhibitCommaSeparatedStatements)
        no strict 'refs';
        \*{$pkg . '::a'}, \*{$pkg . '::b'};
    };

    # Loop iteration limit
    my $limit = $#A > $#B ? $#A : $#B;

    ## no critic (Variables::RequireInitializationForLocalVars)
    # This map expression is also the return value
    local (*$caller_a, *$caller_b);
    ## no critic (BuiltinFunctions::ProhibitComplexMappings)
    return map {
        # Assign to $a, $b as refs to caller's array elements
        (*$caller_a, *$caller_b) = \($#A < $_ ? undef : $A[$_], $#B < $_ ? undef : $B[$_]);

        # Perform the transformation
        $op->();
    } 0 .. $limit;
}

sub each_array (\@;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@)
{
    return each_arrayref(@_);
}

sub each_arrayref
{
    my @list  = @_;    # The list of references to the arrays
    my $index = 0;     # Which one the caller will get next
    my $max   = 0;     # Number of elements in longest array

    # Get the length of the longest input array
    foreach (@list)
    {
        unless (ref $_ eq 'ARRAY')
        {
            require Carp;
            Carp::croak("each_arrayref: argument is not an array reference\n");
        }
        $max = @$_ if @$_ > $max;
    }

    # Return the iterator as a closure wrt the above variables.
    return sub {
        if (@_)
        {
            my $method = shift;
            unless ($method eq 'index')
            {
                require Carp;
                Carp::croak("each_array: unknown argument '$method' passed to iterator.");
            }

            ## no critic (Subroutines::ProhibitExplicitReturnUndef)
            return undef if $index == 0 || $index > $max;
            # Return current (last fetched) index
            return $index - 1;
        }

        # No more elements to return
        return if $index >= $max;
        my $i = $index++;

        # Return ith elements
        ## no critic (BuiltinFunctions::RequireBlockMap)
        return map $_->[$i], @list;
    }
}

sub natatime ($@)
{
    my $n    = shift;
    my @list = @_;
    return sub { return splice @list, 0, $n; }
}

# "leaks" when lexically hidden in arrayify
my $flatten;
$flatten = sub {
    return map { (ref $_ and ("ARRAY" eq ref $_ or overload::Method($_, '@{}'))) ? ($flatten->(@{$_})) : ($_) } @_;
};

sub arrayify
{
    return map { $flatten->($_) } @_;
}

sub mesh (\@\@;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@)
{
    my $max = -1;
    $max < $#$_ && ($max = $#$_) foreach @_;
    ## no critic (BuiltinFunctions::ProhibitComplexMappings)
    return map {
        my $ix = $_;
        ## no critic (BuiltinFunctions::RequireBlockMap)
        map $_->[$ix], @_;
    } 0 .. $max;
}

sub zip6 (\@\@;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@)
{
    my $max = -1;
    $max < $#$_ && ($max = $#$_) foreach @_;
    ## no critic (BuiltinFunctions::ProhibitComplexMappings)
    return map {
        my $ix = $_;
        ## no critic (BuiltinFunctions::RequireBlockMap)
        [map $_->[$ix], @_];
    } 0 .. $max;
}

sub listcmp (\@\@;\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@\@)
{
    my %ret;
    for (my $i = 0; $i < scalar @_; ++$i)
    {
        my %seen;
        my $k;
        foreach my $w (grep { defined $_ and not $seen{$k = $_}++ } @{$_[$i]})
        {
            $ret{$w} ||= [];
            push @{$ret{$w}}, $i;
        }
    }
    return %ret;
}

sub uniq (@)
{
    my %seen = ();
    my $k;
    my $seen_undef;
    return grep { defined $_ ? not $seen{$k = $_}++ : not $seen_undef++ } @_;
}

sub singleton (@)
{
    my %seen = ();
    my $k;
    my $seen_undef;
    return grep { 1 == (defined $_ ? $seen{$k = $_} : $seen_undef) }
      grep { defined $_ ? not $seen{$k = $_}++ : not $seen_undef++ } @_;
}

sub duplicates (@)
{
    my %seen = ();
    my $k;
    my $seen_undef;
    return grep { 1 < (defined $_ ? $seen{$k = $_} : $seen_undef) }
      grep { defined $_ ? not $seen{$k = $_}++ : not $seen_undef++ } @_;
}

sub frequency (@)
{
    my %seen = ();
    my $k;
    my $seen_undef;
    my %h = map { defined $_ ? ($_ => $seen{$k = $_}) : () }
      grep { defined $_ ? not $seen{$k = $_}++ : not $seen_undef++ } @_;
    wantarray or return (scalar keys %h) + ($seen_undef ? 1 : 0);
    undef $k;
    return (%h, $seen_undef ? (\$k => $seen_undef) : ());
}

sub occurrences (@)
{
    my %seen = ();
    my $k;
    my $seen_undef;
    my @ret;
    foreach my $l (map { $_ } grep { defined $_ ? not $seen{$k = $_}++ : not $seen_undef++ } @_)
    {
        my $n = defined $l ? $seen{$l} : $seen_undef;
        defined $ret[$n] or $ret[$n] = [];
        push @{$ret[$n]}, $l;
    }
    return @ret;
}

sub mode (@)
{
    my %seen = ();
    my ($max, $k, $seen_undef) = (1);

    foreach (@_) { defined $_ ? ($max < ++$seen{$k = $_} and ++$max) : ($max < ++$seen_undef and ++$max) }
    wantarray or return $max;

    my @ret = ($max);
    foreach my $l (grep { $seen{$_} == $max } keys %seen)
    {
        push @ret, $l;
    }
    $seen_undef and $seen_undef == $max and push @ret, undef;
    return @ret;
}

sub samples ($@)
{
    my $n = shift;
    if ($n > @_)
    {
        require Carp;
        Carp::croak(sprintf("Cannot get %d samples from %d elements", $n, scalar @_));
    }

    for (my $i = @_; @_ - $i > $n;)
    {
        my $idx  = @_ - $i;
        my $swp  = $idx + int(rand(--$i));
        my $xchg = $_[$swp];
        $_[$swp] = $_[$idx];
        $_[$idx] = $xchg;
    }

    return splice @_, 0, $n;
}

sub minmax (@)
{
    return unless @_;
    my $min = my $max = $_[0];

    for (my $i = 1; $i < @_; $i += 2)
    {
        if ($_[$i - 1] <= $_[$i])
        {
            $min = $_[$i - 1] if $min > $_[$i - 1];
            $max = $_[$i]     if $max < $_[$i];
        }
        else
        {
            $min = $_[$i]     if $min > $_[$i];
            $max = $_[$i - 1] if $max < $_[$i - 1];
        }
    }

    if (@_ & 1)
    {
        my $i = $#_;
        if ($_[$i - 1] <= $_[$i])
        {
            $min = $_[$i - 1] if $min > $_[$i - 1];
            $max = $_[$i]     if $max < $_[$i];
        }
        else
        {
            $min = $_[$i]     if $min > $_[$i];
            $max = $_[$i - 1] if $max < $_[$i - 1];
        }
    }

    return ($min, $max);
}

sub minmaxstr (@)
{
    return unless @_;
    my $min = my $max = $_[0];

    for (my $i = 1; $i < @_; $i += 2)
    {
        if ($_[$i - 1] le $_[$i])
        {
            $min = $_[$i - 1] if $min gt $_[$i - 1];
            $max = $_[$i]     if $max lt $_[$i];
        }
        else
        {
            $min = $_[$i]     if $min gt $_[$i];
            $max = $_[$i - 1] if $max lt $_[$i - 1];
        }
    }

    if (@_ & 1)
    {
        my $i = $#_;
        if ($_[$i - 1] le $_[$i])
        {
            $min = $_[$i - 1] if $min gt $_[$i - 1];
            $max = $_[$i]     if $max lt $_[$i];
        }
        else
        {
            $min = $_[$i]     if $min gt $_[$i];
            $max = $_[$i - 1] if $max lt $_[$i - 1];
        }
    }

    return ($min, $max);
}

sub part (&@)
{
    my ($code, @list) = @_;
    my @parts;
    push @{$parts[$code->($_)]}, $_ foreach @list;
    return @parts;
}

sub bsearch(&@)
{
    my $code = shift;

    my $rc;
    my $i = 0;
    my $j = @_;
    ## no critic (ControlStructures::ProhibitNegativeExpressionsInUnlessAndUntilConditions)
    do
    {
        my $k = int(($i + $j) / 2);

        $k >= @_ and return;

        local *_ = \$_[$k];
        $rc = $code->();

        $rc == 0
          and return wantarray ? $_ : 1;

        if ($rc < 0)
        {
            $i = $k + 1;
        }
        else
        {
            $j = $k - 1;
        }
    } until $i > $j;

    return;
}

sub bsearchidx(&@)
{
    my $code = shift;

    my $rc;
    my $i = 0;
    my $j = @_;
    ## no critic (ControlStructures::ProhibitNegativeExpressionsInUnlessAndUntilConditions)
    do
    {
        my $k = int(($i + $j) / 2);

        $k >= @_ and return -1;

        local *_ = \$_[$k];
        $rc = $code->();

        $rc == 0 and return $k;

        if ($rc < 0)
        {
            $i = $k + 1;
        }
        else
        {
            $j = $k - 1;
        }
    } until $i > $j;

    return -1;
}

sub lower_bound(&@)
{
    my $code  = shift;
    my $count = @_;
    my $first = 0;
    while ($count > 0)
    {
        my $step = $count >> 1;
        my $it   = $first + $step;
        local *_ = \$_[$it];
        if ($code->() < 0)
        {
            $first = ++$it;
            $count -= $step + 1;
        }
        else
        {
            $count = $step;
        }
    }

    return $first;
}

sub upper_bound(&@)
{
    my $code  = shift;
    my $count = @_;
    my $first = 0;
    while ($count > 0)
    {
        my $step = $count >> 1;
        my $it   = $first + $step;
        local *_ = \$_[$it];
        if ($code->() <= 0)
        {
            $first = ++$it;
            $count -= $step + 1;
        }
        else
        {
            $count = $step;
        }
    }

    return $first;
}

sub equal_range(&@)
{
    my $lb = &lower_bound(@_);
    my $ub = &upper_bound(@_);
    return ($lb, $ub);
}

sub binsert (&$\@)
{
    my $lb = &lower_bound($_[0], @{$_[2]});
    splice @{$_[2]}, $lb, 0, $_[1];
    return $lb;
}

sub bremove (&\@)
{
    my $lb = &lower_bound($_[0], @{$_[1]});
    return splice @{$_[1]}, $lb, 1;
}

sub qsort(&\@)
{
    require Carp;
    Carp::croak("It's insane to use a pure-perl qsort");
}

sub slide(&@)
{
    my $op = shift;
    my @l  = @_;

    ## no critic (TestingAndDebugging::ProhibitNoStrict, ValuesAndExpressions::ProhibitCommaSeparatedStatements)
    # Localise $a, $b
    my ($caller_a, $caller_b) = do
    {
        my $pkg = caller();
        no strict 'refs';
        \*{$pkg . '::a'}, \*{$pkg . '::b'};
    };

    ## no critic (Variables::RequireInitializationForLocalVars)
    # This map expression is also the return value
    local (*$caller_a, *$caller_b);
    ## no critic (BuiltinFunctions::ProhibitComplexMappings)
    return map {
        # Assign to $a, $b as refs to caller's array elements
        (*$caller_a, *$caller_b) = \($l[$_], $l[$_ + 1]);

        # Perform the transformation
        $op->();
    } 0 .. ($#l - 1);
}

sub slideatatime ($$@)
{
    my ($m, $w, @list) = @_;
    my $n = $w - $m - 1;
    return $n >= 0
      ? sub { my @r = splice @list, 0, $m; $#list < $n and $n = $#list; @r and push @r, (@list ? @list[0 .. $n] : ()); return @r; }
      : sub { return splice @list, 0, $m; };
}

sub sort_by(&@)
{
    my ($code, @list) = @_;
    return map { $_->[0] }
      sort     { $a->[1] cmp $b->[1] }
      map      { [$_, scalar($code->())] } @list;
}

sub nsort_by(&@)
{
    my ($code, @list) = @_;
    return map { $_->[0] }
      sort     { $a->[1] <=> $b->[1] }
      map      { [$_, scalar($code->())] } @list;
}

## no critic (Subroutines::ProhibitUnusedPrivateSubroutines)
sub _XScompiled { return 0 }

=head1 SEE ALSO

L<List::Util>

=head1 AUTHOR

Jens Rehsack E<lt>rehsack AT cpan.orgE<gt>

Adam Kennedy E<lt>adamk@cpan.orgE<gt>

Tassilo von Parseval E<lt>tassilo.von.parseval@rwth-aachen.deE<gt>

=head1 COPYRIGHT AND LICENSE

Some parts copyright 2011 Aaron Crane.

Copyright 2004 - 2010 by Tassilo von Parseval

Copyright 2013 - 2017 by Jens Rehsack

All code added with 0.417 or later is licensed under the Apache License,
Version 2.0 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

All code until 0.416 is licensed under the same terms as Perl itself,
either Perl version 5.8.4 or, at your option, any later version of
Perl 5 you may have available.

=cut

1;
