=head1 NAME

Types::Serialiser - simple data types for common serialisation formats

=encoding utf-8

=head1 SYNOPSIS

=head1 DESCRIPTION

This module provides some extra datatypes that are used by common
serialisation formats such as JSON or CBOR. The idea is to have a
repository of simple/small constants and containers that can be shared by
different implementations so they become interoperable between each other.

=cut

package Types::Serialiser;

use common::sense; # required to suppress annoying warnings

our $VERSION = '1.0';

=head1 SIMPLE SCALAR CONSTANTS

Simple scalar constants are values that are overloaded to act like simple
Perl values, but have (class) type to differentiate them from normal Perl
scalars. This is necessary because these have different representations in
the serialisation formats.

=head2 BOOLEANS (Types::Serialiser::Boolean class)

This type has only two instances, true and false. A natural representation
for these in Perl is C<1> and C<0>, but serialisation formats need to be
able to differentiate between them and mere numbers.

=over 4

=item $Types::Serialiser::true, Types::Serialiser::true

This value represents the "true" value. In most contexts is acts like
the number C<1>. It is up to you whether you use the variable form
(C<$Types::Serialiser::true>) or the constant form (C<Types::Serialiser::true>).

The constant is represented as a reference to a scalar containing C<1> -
implementations are allowed to directly test for this.

=item $Types::Serialiser::false, Types::Serialiser::false

This value represents the "false" value. In most contexts is acts like
the number C<0>. It is up to you whether you use the variable form
(C<$Types::Serialiser::false>) or the constant form (C<Types::Serialiser::false>).

The constant is represented as a reference to a scalar containing C<0> -
implementations are allowed to directly test for this.

=item $is_bool = Types::Serialiser::is_bool $value

Returns true iff the C<$value> is either C<$Types::Serialiser::true> or
C<$Types::Serialiser::false>.

For example, you could differentiate between a perl true value and a
C<Types::Serialiser::true> by using this:

   $value && Types::Serialiser::is_bool $value

=item $is_true = Types::Serialiser::is_true $value

Returns true iff C<$value> is C<$Types::Serialiser::true>.

=item $is_false = Types::Serialiser::is_false $value

Returns false iff C<$value> is C<$Types::Serialiser::false>.

=back

=head2 ERROR (Types::Serialiser::Error class)

This class has only a single instance, C<error>. It is used to signal
an encoding or decoding error. In CBOR for example, and object that
couldn't be encoded will be represented by a CBOR undefined value, which
is represented by the error value in Perl.

=over 4

=item $Types::Serialiser::error, Types::Serialiser::error

This value represents the "error" value. Accessing values of this type
will throw an exception.

The constant is represented as a reference to a scalar containing C<undef>
- implementations are allowed to directly test for this.

=item $is_error = Types::Serialiser::is_error $value

Returns false iff C<$value> is C<$Types::Serialiser::error>.

=back

=cut

BEGIN {
   # for historical reasons, and to avoid extra dependencies in JSON::PP,
   # we alias *Types::Serialiser::Boolean with JSON::PP::Boolean.
   package JSON::PP::Boolean;

   *Types::Serialiser::Boolean:: = *JSON::PP::Boolean::;
}

{
   # this must done before blessing to work around bugs
   # in perl < 5.18 (it seems to be fixed in 5.18).
   package Types::Serialiser::BooleanBase;

   use overload
      "0+"     => sub { ${$_[0]} },
      "++"     => sub { $_[0] = ${$_[0]} + 1 },
      "--"     => sub { $_[0] = ${$_[0]} - 1 },
      fallback => 1;

   @Types::Serialiser::Boolean::ISA = Types::Serialiser::BooleanBase::;
}

our $true  = do { bless \(my $dummy = 1), Types::Serialiser::Boolean:: };
our $false = do { bless \(my $dummy = 0), Types::Serialiser::Boolean:: };
our $error = do { bless \(my $dummy    ), Types::Serialiser::Error::   };

sub true  () { $true  }
sub false () { $false }
sub error () { $error }

sub is_bool  ($) {           UNIVERSAL::isa $_[0], Types::Serialiser::Boolean:: }
sub is_true  ($) {  $_[0] && UNIVERSAL::isa $_[0], Types::Serialiser::Boolean:: }
sub is_false ($) { !$_[0] && UNIVERSAL::isa $_[0], Types::Serialiser::Boolean:: }
sub is_error ($) {           UNIVERSAL::isa $_[0], Types::Serialiser::Error::   }

package Types::Serialiser::Error;

sub error {
   require Carp;
   Carp::croak ("caught attempt to use the Types::Serialiser::error value");
};

use overload
   "0+"     => \&error,
   "++"     => \&error,
   "--"     => \&error,
   fallback => 1;

=head1 NOTES FOR XS USERS

The recommended way to detect whether a scalar is one of these objects
is to check whether the stash is the C<Types::Serialiser::Boolean> or
C<Types::Serialiser::Error> stash, and then follow the scalar reference to
see if it's C<1> (true), C<0> (false) or C<undef> (error).

While it is possible to use an isa test, directly comparing stash pointers
is faster and guaranteed to work.

For historical reasons, the C<Types::Serialiser::Boolean> stash is
just an alias for C<JSON::PP::Boolean>. When printed, the classname
with usually be C<JSON::PP::Boolean>, but isa tests and stash pointer
comparison will normally work correctly (i.e. Types::Serialiser::true ISA
JSON::PP::Boolean, but also ISA Types::Serialiser::Boolean).

=head1 A GENERIC OBJECT SERIALIATION PROTOCOL

This section explains the object serialisation protocol used by
L<CBOR::XS>. It is meant to be generic enough to support any kind of
generic object serialiser.

This protocol is called "the Types::Serialiser object serialisation
protocol".

=head2 ENCODING

When the encoder encounters an object that it cannot otherwise encode (for
example, L<CBOR::XS> can encode a few special types itself, and will first
attempt to use the special C<TO_CBOR> serialisation protocol), it will
look up the C<FREEZE> method on the object.

Note that the C<FREEZE> method will normally be called I<during> encoding,
and I<MUST NOT> change the data structure that is being encoded in any
way, or it might cause memory corruption or worse.

If it exists, it will call it with two arguments: the object to serialise,
and a constant string that indicates the name of the data model. For
example L<CBOR::XS> uses C<CBOR>, and the L<JSON> and L<JSON::XS> modules
(or any other JSON serialiser), would use C<JSON> as second argument.

The C<FREEZE> method can then return zero or more values to identify the
object instance. The serialiser is then supposed to encode the class name
and all of these return values (which must be encodable in the format)
using the relevant form for Perl objects. In CBOR for example, there is a
registered tag number for encoded perl objects.

The values that C<FREEZE> returns must be serialisable with the serialiser
that calls it. Therefore, it is recommended to use simple types such as
strings and numbers, and maybe array references and hashes (basically, the
JSON data model). You can always use a more complex format for a specific
data model by checking the second argument, the data model.

The "data model" is not the same as the "data format" - the data model
indicates what types and kinds of return values can be returned from
C<FREEZE>. For example, in C<CBOR> it is permissible to return tagged CBOR
values, while JSON does not support these at all, so C<JSON> would be a
valid (but too limited) data model name for C<CBOR::XS>. similarly, a
serialising format that supports more or less the same data model as JSON
could use C<JSON> as data model without losing anything.

=head2 DECODING

When the decoder then encounters such an encoded perl object, it should
look up the C<THAW> method on the stored classname, and invoke it with the
classname, the constant string to identify the data model/data format, and
all the return values returned by C<FREEZE>.

=head2 EXAMPLES

See the C<OBJECT SERIALISATION> section in the L<CBOR::XS> manpage for
more details, an example implementation, and code examples.

Here is an example C<FREEZE>/C<THAW> method pair:

   sub My::Object::FREEZE {
      my ($self, $model) = @_;

      ($self->{type}, $self->{id}, $self->{variant})
   }

   sub My::Object::THAW {
      my ($class, $model, $type, $id, $variant) = @_;

      $class->new (type => $type, id => $id, variant => $variant)
   }

=head1 BUGS

The use of L<overload> makes this module much heavier than it should be
(on my system, this module: 4kB RSS, overload: 260kB RSS).

=head1 SEE ALSO

Currently, L<JSON::XS> and L<CBOR::XS> use these types.

=head1 AUTHOR

 Marc Lehmann <schmorp@schmorp.de>
 http://home.schmorp.de/

=cut

1

