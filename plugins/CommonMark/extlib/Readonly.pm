package Readonly;
use 5.005;
use strict;

#use warnings;
#no warnings 'uninitialized';
package Readonly;
our $VERSION = '2.05';
$VERSION = eval $VERSION;

# Autocroak (Thanks, MJD)
# Only load Carp.pm if module is croaking.
sub croak {
    require Carp;
    goto &Carp::croak;
}

# These functions may be overridden by Readonly::XS, if installed.
use vars qw/$XSokay/;    # Set to true in Readonly::XS, if available

# Predeclare the following, so we can use them recursively
sub _ARRAY (\@);
sub _HASH (\%);

# For perl 5.8.x or higher
# These functions are exposed in perl 5.8.x (Thanks, Leon!)
# They may be overridden by Readonly::XS, if installed on old perl versions
if ($] < 5.008) {    # 'Classic' perl
    *is_sv_readonly = sub ($) {0};
    *make_sv_readonly
        = sub ($) { die "make_sv_readonly called but not overridden" };

    # See if we can use the XS stuff.
    $Readonly::XS::MAGIC_COOKIE = $Readonly::XS::MAGIC_COOKIE
        = "Do NOT use or require Readonly::XS unless you're me.";
    eval 'use Readonly::XS';
}
else {               # Modern perl doesn't need Readonly::XS
    *is_sv_readonly = sub ($) { Internals::SvREADONLY($_[0]) };
    *make_sv_readonly
        = sub ($) { Internals::SvREADONLY($_[0], 1) };
    $XSokay = 1;     # We're using the new built-ins so this is a white lie
}

# Undo setting readonly
sub _SCALAR ($) {
    my ($r_var) = @_;
    if ($XSokay) {
        Internals::SvREADONLY($r_var, 0) if is_sv_readonly($r_var);
    }
    else {
        return if tied($r_var) !~ 'Readonly::Scalar';
        my $r_scalar;
        {
            my $obj = tied $$r_var;
            $r_scalar = $obj;
        }
        untie $r_var;
        $r_var = $r_scalar;
    }
}

sub _ARRAY (\@) {
    my ($r_var) = @_;
    return if !tied(@$r_var);
    return if tied(@$r_var) !~ 'Readonly::Array';
    my $r_array;
    {
        my $obj = tied @$r_var;
        $r_array = $obj;
    }
    untie @$r_var;
    @$r_var = @$r_array;

    # Recursively check child elements for references; clean if Readonly
    foreach (@$r_var) {
        my $_reftype = ref $_;
        if ($_reftype eq 'SCALAR') { _SCALAR($_) }
        elsif ($_reftype eq 'ARRAY') {
            _ARRAY(@$_);
        }
        elsif ($_reftype eq 'HASH') {
            _HASH(%$_);
        }
    }
}

sub _HASH (\%) {
    my ($r_var) = @_;
    return if !tied(%$r_var);
    return if tied(%$r_var) !~ 'Readonly::Hash';
    my $r_hash;
    {
        my $obj = tied %$r_var;
        $r_hash = $obj;
    }
    untie %$r_var;
    %$r_var = %$r_hash;

    # Recursively check child elements for references; clean if Readonly
    foreach (values %$r_var) {
        my $_reftype = ref $_;
        if ($_reftype eq 'SCALAR') { _SCALAR($_) }
        elsif ($_reftype eq 'ARRAY') {
            _ARRAY(@$_);
        }
        elsif ($_reftype eq 'HASH') {
            _HASH(%$_);
        }
    }
}

# Common error messages, or portions thereof
use vars qw/$MODIFY $REASSIGN $ODDHASH/;
$MODIFY   = 'Modification of a read-only value attempted';
$REASSIGN = 'Attempt to reassign a readonly';
$ODDHASH  = 'May not store an odd number of values in a hash';

# ----------------
# Read-only scalars
# ----------------
package Readonly::Scalar;

sub STORABLE_freeze {
    my ($self, $cloning) = @_;
    Readonly::_SCALAR($$self) if $cloning;
}

sub TIESCALAR {
    my $whence
        = (caller 2)[3];    # Check if naughty user is trying to tie directly.
    Readonly::croak "Invalid tie"
        unless $whence && $whence =~ /^Readonly::(?:Scalar1?|Readonly)$/;
    my $class = shift;
    Readonly::croak "No value specified for readonly scalar" unless @_;
    Readonly::croak "Too many values specified for readonly scalar"
        unless @_ == 1;
    my $value = shift;
    return bless \$value, $class;
}

sub FETCH {
    my $self = shift;
    return $$self;
}
*STORE = *STORE = sub { Readonly::croak $Readonly::MODIFY };
*UNTIE = *UNTIE
    = sub { Readonly::croak $Readonly::MODIFY if caller() ne 'Readonly' };

# ----------------
# Read-only arrays
# ----------------
package Readonly::Array;

sub STORABLE_freeze {
    my ($self, $cloning) = @_;
    Readonly::_ARRAY(@$self) if $cloning;
}

sub TIEARRAY {
    my $whence
        = (caller 1)[3];    # Check if naughty user is trying to tie directly.
    Readonly::croak "Invalid tie" unless $whence =~ /^Readonly::Array1?$/;
    my $class = shift;
    my @self  = @_;
    return bless \@self, $class;
}

sub FETCH {
    my $self  = shift;
    my $index = shift;
    return $self->[$index];
}

sub FETCHSIZE {
    my $self = shift;
    return scalar @$self;
}

BEGIN {
    eval q{
        sub EXISTS
           {
           my $self  = shift;
           my $index = shift;
           return exists $self->[$index];
           }
    } if $] >= 5.006;    # couldn't do "exists" on arrays before then
}
*STORE = *STORESIZE = *EXTEND = *PUSH = *POP = *UNSHIFT = *SHIFT = *SPLICE
    = *CLEAR = *STORE = *STORESIZE = *EXTEND = *PUSH = *POP = *UNSHIFT
    = *SHIFT = *SPLICE = *CLEAR = sub { Readonly::croak $Readonly::MODIFY};
*UNTIE = *UNTIE
    = sub { Readonly::croak $Readonly::MODIFY if caller() ne 'Readonly' };

# ----------------
# Read-only hashes
# ----------------
package Readonly::Hash;

sub STORABLE_freeze {
    my ($self, $cloning) = @_;
    Readonly::_HASH(%$self) if $cloning;
}

sub TIEHASH {
    my $whence
        = (caller 1)[3];    # Check if naughty user is trying to tie directly.
    Readonly::croak "Invalid tie" unless $whence =~ /^Readonly::Hash1?$/;
    my $class = shift;

    # must have an even number of values
    Readonly::croak $Readonly::ODDHASH unless (@_ % 2 == 0);
    my %self = @_;
    return bless \%self, $class;
}

sub FETCH {
    my $self = shift;
    my $key  = shift;
    return $self->{$key};
}

sub EXISTS {
    my $self = shift;
    my $key  = shift;
    return exists $self->{$key};
}

sub FIRSTKEY {
    my $self  = shift;
    my $dummy = keys %$self;
    return scalar each %$self;
}

sub NEXTKEY {
    my $self = shift;
    return scalar each %$self;
}
*STORE = *DELETE = *CLEAR = *STORE = *DELETE = *CLEAR
    = sub { Readonly::croak $Readonly::MODIFY};
*UNTIE = *UNTIE
    = sub { Readonly::croak $Readonly::MODIFY if caller() ne 'Readonly'; };

# ----------------------------------------------------------------
# Main package, containing convenience functions (so callers won't
# have to explicitly tie the variables themselves).
# ----------------------------------------------------------------
package Readonly;
use Exporter;
use vars qw/@ISA @EXPORT @EXPORT_OK %EXPORT_TAGS/;
push @ISA,       'Exporter';
push @EXPORT,    qw/Readonly/;
push @EXPORT_OK, qw/Scalar Array Hash Scalar1 Array1 Hash1/;

# Predeclare the following, so we can use them recursively
sub Scalar ($$);
sub Array (\@;@);
sub Hash (\%;@);

# Returns true if a string begins with "Readonly::"
# Used to prevent reassignment of Readonly variables.
sub _is_badtype {
    my $type = $_[0];
    return lc $type if $type =~ s/^Readonly:://;
    return;
}

# Shallow Readonly scalar
sub Scalar1 ($$) {
    croak "$REASSIGN scalar" if is_sv_readonly($_[0]);
    my $badtype = _is_badtype(ref tied $_[0]);
    croak "$REASSIGN $badtype" if $badtype;

    # xs method: flag scalar as readonly
    if ($XSokay) {
        $_[0] = $_[1];
        make_sv_readonly($_[0]);
        return;
    }

    # pure-perl method: tied scalar
    my $tieobj = eval { tie $_[0], 'Readonly::Scalar', $_[1] };
    if ($@) {
        croak "$REASSIGN scalar" if substr($@, 0, 43) eq $MODIFY;
        die $@;    # some other error?
    }
    return $tieobj;
}

# Shallow Readonly array
sub Array1 (\@;@) {
    my $badtype = _is_badtype(ref tied $_[0]);
    croak "$REASSIGN $badtype" if $badtype;
    my $aref = shift;
    return tie @$aref, 'Readonly::Array', @_;
}

# Shallow Readonly hash
sub Hash1 (\%;@) {
    my $badtype = _is_badtype(ref tied $_[0]);
    croak "$REASSIGN $badtype" if $badtype;
    my $href = shift;

    # If only one value, and it's a hashref, expand it
    if (@_ == 1 && ref $_[0] eq 'HASH') {
        return tie %$href, 'Readonly::Hash', %{$_[0]};
    }

    # otherwise, must have an even number of values
    croak $ODDHASH unless (@_ % 2 == 0);
    return tie %$href, 'Readonly::Hash', @_;
}

# Deep Readonly scalar
sub Scalar ($$) {
    croak "$REASSIGN scalar" if is_sv_readonly($_[0]);
    my $badtype = _is_badtype(ref tied $_[0]);
    croak "$REASSIGN $badtype" if $badtype;
    my $value = $_[1];

 # Recursively check passed element for references; if any, make them Readonly
    foreach ($value) {
        if    (ref eq 'SCALAR') { Scalar my $v => $$_; $_ = \$v }
        elsif (ref eq 'ARRAY')  { Array my @v  => @$_; $_ = \@v }
        elsif (ref eq 'HASH')   { Hash my %v   => $_;  $_ = \%v }
    }

    # xs method: flag scalar as readonly
    if ($XSokay) {
        $_[0] = $value;
        make_sv_readonly($_[0]);
        return;
    }

    # pure-perl method: tied scalar
    my $tieobj = eval { tie $_[0], 'Readonly::Scalar', $value };
    if ($@) {
        croak "$REASSIGN scalar" if substr($@, 0, 43) eq $MODIFY;
        die $@;    # some other error?
    }
    return $tieobj;
}

# Deep Readonly array
sub Array (\@;@) {
    my $badtype = _is_badtype(ref tied @{$_[0]});
    croak "$REASSIGN $badtype" if $badtype;
    my $aref   = shift;
    my @values = @_;

# Recursively check passed elements for references; if any, make them Readonly
    foreach (@values) {
        if    (ref eq 'SCALAR') { Scalar my $v => $$_; $_ = \$v }
        elsif (ref eq 'ARRAY')  { Array my @v  => @$_; $_ = \@v }
        elsif (ref eq 'HASH')   { Hash my %v   => $_;  $_ = \%v }
    }

    # Lastly, tie the passed reference
    return tie @$aref, 'Readonly::Array', @values;
}

# Deep Readonly hash
sub Hash (\%;@) {
    my $badtype = _is_badtype(ref tied %{$_[0]});
    croak "$REASSIGN $badtype" if $badtype;
    my $href   = shift;
    my @values = @_;

    # If only one value, and it's a hashref, expand it
    if (@_ == 1 && ref $_[0] eq 'HASH') {
        @values = %{$_[0]};
    }

    # otherwise, must have an even number of values
    croak $ODDHASH unless (@values % 2 == 0);

# Recursively check passed elements for references; if any, make them Readonly
    foreach (@values) {
        if    (ref eq 'SCALAR') { Scalar my $v => $$_; $_ = \$v }
        elsif (ref eq 'ARRAY')  { Array my @v  => @$_; $_ = \@v }
        elsif (ref eq 'HASH')   { Hash my %v   => $_;  $_ = \%v }
    }
    return tie %$href, 'Readonly::Hash', @values;
}

sub Clone(\[$@%]) {
    require Storable;
    my $retval = Storable::dclone($_[0]);
    $retval = $$retval if ref $retval eq 'REF';
    my $reftype = ref $retval;
    if ($reftype eq 'SCALAR') {
        _SCALAR($retval);
        return $$retval;
    }
    elsif ($reftype eq 'ARRAY') {
        _ARRAY(@$retval);
    }
    elsif ($reftype eq 'HASH') {
        _HASH(%$retval);
        return %$retval if wantarray;
    }
    return $retval;
}

# Common entry-point for all supported data types
eval q{sub Readonly} . ($] < 5.008 ? '' : '(\[$@%]@)') . <<'SUB_READONLY';
{
    if (ref $_[0] eq 'SCALAR')
    {
        croak $MODIFY if is_sv_readonly ${$_[0]};
        my $badtype = _is_badtype (ref tied ${$_[0]});
        croak "$REASSIGN $badtype" if $badtype;
        croak "Readonly scalar must have only one value" if @_ > 2;

        # Because of problems with handling \$ prototypes declarations like
        # Readonly my @a = ... and Readonly my %h = ... are also caught here
        croak 'Invalid initialization by assignment'
            if @_ == 1 && defined ${$_[0]};

        my $tieobj = eval {tie ${$_[0]}, 'Readonly::Scalar', $_[1]};
        # Tie may have failed because user tried to tie a constant, or we screwed up somehow.
        if ($@)
        {
            croak $MODIFY if $@ =~ /^$MODIFY at/;    # Point the finger at the user.
            die "$@\n";        # Not a modify read-only message; must be our fault.
        }
        return $tieobj;
    }
    elsif (ref $_[0] eq 'ARRAY')
    {
        my $aref = shift;
        return Array @$aref, @_;
    }
    elsif (ref $_[0] eq 'HASH')
    {
        my $href = shift;
        croak $ODDHASH  if @_%2 != 0  &&  !(@_ == 1  && ref $_[0] eq 'HASH');
        return Hash %$href, @_;
    }
    elsif (ref $_[0])
    {
        croak "Readonly only supports scalar, array, and hash variables.";
    }
    else
    {
        croak "First argument to Readonly must be a reference.";
    }
}
SUB_READONLY
1;

=head1 NAME

Readonly - Facility for creating read-only scalars, arrays, hashes

=head1 Synopsis

    use Readonly;

    # Deep Read-only scalar
    Readonly::Scalar    $sca => $initial_value;
    Readonly::Scalar my $sca => $initial_value;

    # Deep Read-only array
    Readonly::Array    @arr => @values;
    Readonly::Array my @arr => @values;

    # Deep Read-only hash
    Readonly::Hash    %has => (key => value, key => value, ...);
    Readonly::Hash my %has => (key => value, key => value, ...);
    # or:
    Readonly::Hash    %has => {key => value, key => value, ...};

    # You can use the read-only variables like any regular variables:
    print $sca;
    $something = $sca + $arr[2];
    next if $has{$some_key};

    # But if you try to modify a value, your program will die:
    $sca = 7;
    push @arr, 'seven';
    delete $has{key};
    # The error message is "Modification of a read-only value attempted"

    # Alternate form (Perl 5.8 and later)
    Readonly    $sca => $initial_value;
    Readonly my $sca => $initial_value;
    Readonly    @arr => @values;
    Readonly my @arr => @values;
    Readonly    %has => (key => value, key => value, ...);
    Readonly my %has => (key => value, key => value, ...);
    Readonly my $sca; # Implicit undef, readonly value

    # Alternate form (for Perls earlier than v5.8)
    Readonly    \$sca => $initial_value;
    Readonly \my $sca => $initial_value;
    Readonly    \@arr => @values;
    Readonly \my @arr => @values;
    Readonly    \%has => (key => value, key => value, ...);
    Readonly \my %has => (key => value, key => value, ...);

=head1 Description

This is a facility for creating non-modifiable variables. This is useful for
configuration files, headers, etc. It can also be useful as a development and
debugging tool for catching updates to variables that should not be changed.

=head1 Variable Depth

Readonly has the ability to create both deep and shallow readonly variables.

If you pass a C<$ref>, an C<@array> or a C<%hash> to corresponding functions
C<::Scalar()>, C<::Array()> and C<::Hash()>, then those functions recurse over
the data structure, marking everything as readonly. The entire structure is
then non-modifiable. This is normally what you want.

If you want only the top level to be readonly, use the alternate (and poorly
named) C<::Scalar1()>, C<::Array1()>, and C<::Hash1()> functions.

Plain C<Readonly()> creates what the original author calls a "shallow"
readonly variable, which is great if you don't plan to use it on anything but
only one dimensional scalar values.

C<Readonly::Scalar()> makes the variable 'deeply' readonly, so the following
snippet kills over as you expect:

 use Readonly;

 Readonly::Scalar my $ref => { 1 => 'a' };
 $ref->{1} = 'b';
 $ref->{2} = 'b';

While the following snippet does B<not> make your structure 'deeply' readonly:

 use Readonly;

 Readonly my $ref => { 1 => 'a' };
 $ref->{1} = 'b';
 $ref->{2} = 'b';

=head1

=head1 The Past

The following sections are updated versions of the previous authors
documentation.

=head2 Comparison with "use constant"

Perl provides a facility for creating constant values, via the L<constant>
pragma. There are several problems with this pragma.

=over 2

=item * The constants created have no leading sigils.

=item * These constants cannot be interpolated into strings.

=item * Syntax can get dicey sometimes.  For example:

    use constant CARRAY => (2, 3, 5, 7, 11, 13);
    $a_prime = CARRAY[2];        # wrong!
    $a_prime = (CARRAY)[2];      # right -- MUST use parentheses

=item * You have to be very careful in places where barewords are allowed.

For example:

    use constant SOME_KEY => 'key';
    %hash = (key => 'value', other_key => 'other_value');
    $some_value = $hash{SOME_KEY};        # wrong!
    $some_value = $hash{+SOME_KEY};       # right

(who thinks to use a unary plus when using a hash to scalarize the key?)

=item * C<use constant> works for scalars and arrays, not hashes.

=item * These constants are global to the package in which they're declared;
cannot be lexically scoped.

=item * Works only at compile time.

=item * Can be overridden:

    use constant PI => 3.14159;
    ...
    use constant PI => 2.71828;

(this does generate a warning, however, if you have warnings enabled).

=item * It is very difficult to make and use deep structures (complex data
structures) with C<use constant>.

=back

=head1 Comparison with typeglob constants

Another popular way to create read-only scalars is to modify the symbol table
entry for the variable by using a typeglob:

    *a = \'value';

This works fine, but it only works for global variables ("my" variables have
no symbol table entry). Also, the following similar constructs do B<not> work:

    *a = [1, 2, 3];      # Does NOT create a read-only array
    *a = { a => 'A'};    # Does NOT create a read-only hash

=head2 Pros

Readonly.pm, on the other hand, will work with global variables and with
lexical ("my") variables. It will create scalars, arrays, or hashes, all of
which look and work like normal, read-write Perl variables. You can use them
in scalar context, in list context; you can take references to them, pass them
to functions, anything.

Readonly.pm also works well with complex data structures, allowing you to tag
the whole structure as nonmodifiable, or just the top level.

Also, Readonly variables may not be reassigned. The following code will die:

    Readonly::Scalar $pi => 3.14159;
    ...
    Readonly::Scalar $pi => 2.71828;

=head2 Cons

Readonly.pm used to impose a performance penalty. It was pretty slow. How
slow? Run the C<eg/benchmark.pl> script that comes with Readonly. On my test
system, "use constant" (const), typeglob constants (tglob), regular read/write
Perl variables (normal/literal), and the new Readonly (ro/ro_simple) are all
about the same speed, the old, tie based Readonly.pm constants were about 1/22
the speed.

However, there is relief. There is a companion module available, Readonly::XS.
You won't need this if you're using Perl 5.8.x or higher.

I repeat, you do not need Readonly::XS if your environment has perl 5.8.x or
higher. Please see section entitled L<Internals|/"Internals"> for more.

=head1 Functions

=over 4

=item Readonly::Scalar $var => $value;

Creates a nonmodifiable scalar, C<$var>, and assigns a value of C<$value> to
it. Thereafter, its value may not be changed. Any attempt to modify the value
will cause your program to die.

A value I<must> be supplied. If you want the variable to have C<undef> as its
value, you must specify C<undef>.

If C<$value> is a reference to a scalar, array, or hash, then this function
will mark the scalar, array, or hash it points to as being Readonly as well,
and it will recursively traverse the structure, marking the whole thing as
Readonly. Usually, this is what you want. However, if you want only the
C<$value> marked as Readonly, use C<Scalar1>.

If $var is already a Readonly variable, the program will die with an error
about reassigning Readonly variables.

=item Readonly::Array @arr => (value, value, ...);

Creates a nonmodifiable array, C<@arr>, and assigns the specified list of
values to it. Thereafter, none of its values may be changed; the array may not
be lengthened or shortened or spliced. Any attempt to do so will cause your
program to die.

If any of the values passed is a reference to a scalar, array, or hash, then
this function will mark the scalar, array, or hash it points to as being
Readonly as well, and it will recursively traverse the structure, marking the
whole thing as Readonly. Usually, this is what you want. However, if you want
only the hash C<%@arr> itself marked as Readonly, use C<Array1>.

If C<@arr> is already a Readonly variable, the program will die with an error
about reassigning Readonly variables.

=item Readonly::Hash %h => (key => value, key => value, ...);

=item Readonly::Hash %h => {key => value, key => value, ...};

Creates a nonmodifiable hash, C<%h>, and assigns the specified keys and values
to it. Thereafter, its keys or values may not be changed. Any attempt to do so
will cause your program to die.

A list of keys and values may be specified (with parentheses in the synopsis
above), or a hash reference may be specified (curly braces in the synopsis
above). If a list is specified, it must have an even number of elements, or
the function will die.

If any of the values is a reference to a scalar, array, or hash, then this
function will mark the scalar, array, or hash it points to as being Readonly
as well, and it will recursively traverse the structure, marking the whole
thing as Readonly. Usually, this is what you want. However, if you want only
the hash C<%h> itself marked as Readonly, use C<Hash1>.

If C<%h> is already a Readonly variable, the program will die with an error
about reassigning Readonly variables.

=item Readonly $var => $value;

=item Readonly @arr => (value, value, ...);

=item Readonly %h => (key => value, ...);

=item Readonly %h => {key => value, ...};

=item Readonly $var;

The C<Readonly> function is an alternate to the C<Scalar>, C<Array>, and
C<Hash> functions. It has the advantage (if you consider it an advantage) of
being one function. That may make your program look neater, if you're
initializing a whole bunch of constants at once. You may or may not prefer
this uniform style.

It has the disadvantage of having a slightly different syntax for versions of
Perl prior to 5.8.  For earlier versions, you must supply a backslash, because
it requires a reference as the first parameter.

    Readonly \$var => $value;
    Readonly \@arr => (value, value, ...);
    Readonly \%h   => (key => value, ...);
    Readonly \%h   => {key => value, ...};

You may or may not consider this ugly.

Note that you can create implicit undefined variables with this function like
so C<Readonly my $var;> while a verbose undefined value must be passed to the
standard C<Scalar>, C<Array>, and C<Hash> functions.

=item Readonly::Scalar1 $var => $value;

=item Readonly::Array1 @arr => (value, value, ...);

=item Readonly::Hash1 %h => (key => value, key => value, ...);

=item Readonly::Hash1 %h => {key => value, key => value, ...};

These alternate functions create shallow Readonly variables, instead of deep
ones. For example:

    Readonly::Array1 @shal => (1, 2, {perl=>'Rules', java=>'Bites'}, 4, 5);
    Readonly::Array  @deep => (1, 2, {perl=>'Rules', java=>'Bites'}, 4, 5);

    $shal[1] = 7;           # error
    $shal[2]{APL}='Weird';  # Allowed! since the hash isn't Readonly
    $deep[1] = 7;           # error
    $deep[2]{APL}='Weird';  # error, since the hash is Readonly

=back

=head1 Cloning

When cloning using L<Storable> or L<Clone> you will notice that the value stays
readonly, which is correct. If you want to clone the value without copying the
readonly flag, use the C<Clone> function:

    Readonly::Scalar my $scalar => {qw[this that]};
    # $scalar->{'eh'} = 'foo'; # Modification of a read-only value attempted
    my $scalar_clone = Readonly::Clone $scalar;
    $scalar_clone->{'eh'} = 'foo';
    # $scalar_clone is now {this => 'that', eh => 'foo'};

The new variable (C<$scalar_clone>) is a mutable clone of the original
C<$scalar>.

=head1 Examples

These are a few very simple examples:

=head2 Scalars

A plain old read-only value

    Readonly::Scalar $a => "A string value";

The value need not be a compile-time constant:

    Readonly::Scalar $a => $computed_value;

=head2 Arrays/Lists

A read-only array:

    Readonly::Array @a => (1, 2, 3, 4);

The parentheses are optional:

    Readonly::Array @a => 1, 2, 3, 4;

You can use Perl's built-in array quoting syntax:

    Readonly::Array @a => qw/1 2 3 4/;

You can initialize a read-only array from a variable one:

    Readonly::Array @a => @computed_values;

A read-only array can be empty, too:

    Readonly::Array @a => ();
    Readonly::Array @a;        # equivalent

=head2 Hashes

Typical usage:

    Readonly::Hash %a => (key1 => 'value1', key2 => 'value2');

A read-only hash can be initialized from a variable one:

    Readonly::Hash %a => %computed_values;

A read-only hash can be empty:

    Readonly::Hash %a => ();
    Readonly::Hash %a;        # equivalent

If you pass an odd number of values, the program will die:

    Readonly::Hash %a => (key1 => 'value1', "value2");
    # This dies with "May not store an odd number of values in a hash"

=head1 Exports

Historically, this module exports the C<Readonly> symbol into the calling
program's namespace by default. The following symbols are also available for
import into your program, if you like: C<Scalar>, C<Scalar1>, C<Array>,
C<Array1>, C<Hash>, and C<Hash1>.

=head1 Internals

Some people simply do not understand the relationship between this module and
Readonly::XS so I'm adding this section. Odds are, they still won't understand
but I like to write so...

In the past, Readonly's "magic" was performed by C<tie()>-ing variables to the
C<Readonly::Scalar>, C<Readonly::Array>, and C<Readonly::Hash> packages (not
to be confused with the functions of the same names) and acting on C<WRITE>,
C<READ>, et. al. While this worked well, it was slow. Very slow. Like 20-30
times slower than accessing variables directly or using one of the other
const-related modules that have cropped up since Readonly was released in
2003.

To 'fix' this, Readonly::XS was written. If installed, Readonly::XS used the
internal methods C<SvREADONLY> and C<SvREADONLY_on> to lock simple scalars. On
the surface, everything was peachy but things weren't the same behind the
scenes. In edge cases, code performed very differently if Readonly::XS was
installed and because it wasn't a required dependency in most code, it made
downstream bugs very hard to track.

In the years since Readonly::XS was released, the then private internal
methods have been exposed and can be used in pure perl. Similar modules were
written to take advantage of this and a patch to Readonly was created. We no
longer need to build and install another module to make Readonly useful on
modern builds of perl.

=over

=item * You do not need to install Readonly::XS.

=item * You should stop listing Readonly::XS as a dependency or expect it to
be installed.

=item * Stop testing the C<$Readonly::XSokay> variable!

=back

=head1 Requirements

Please note that most users of Readonly no longer need to install the
companion module Readonly::XS which is recommended but not required for perl
5.6.x and under. Please do not force it as a requirement in new code and do
not use the package variable C<$Readonly::XSokay> in code/tests. For more, see
L<the section on Readonly's new internals/Internals>.

There are no non-core requirements.

=head1 Bug Reports

If email is better for you, L<my address is mentioned below|/"Author"> but I
would rather have bugs sent through the issue tracker found at
http://github.com/sanko/readonly/issues.

=head1 Acknowledgements

Thanks to Slaven Rezic for the idea of one common function (Readonly) for all
three types of variables (13 April 2002).

Thanks to Ernest Lergon for the idea (and initial code) for deeply-Readonly
data structures (21 May 2002).

Thanks to Damian Conway for the idea (and code) for making the Readonly
function work a lot smoother under perl 5.8+.

=head1 Author

Sanko Robinson <sanko@cpan.org> - http://sankorobinson.com/

CPAN ID: SANKO

Original author: Eric J. Roode, roode@cpan.org

=head1 License and Legal

Copyright (C) 2013-2016 by Sanko Robinson <sanko@cpan.org>

Copyright (c) 2001-2004 by Eric J. Roode. All Rights Reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
