use 5.005003;
package boolean;
use strict; use warnings;

$boolean::VERSION = '0.30';

my ($true, $false);

use overload
    '""' => sub { ${$_[0]} },
    '!' => sub { ${$_[0]} ? $false : $true },
    fallback => 1;

use base 'Exporter';
@boolean::EXPORT = qw(true false boolean);
@boolean::EXPORT_OK = qw(isTrue isFalse isBoolean);
%boolean::EXPORT_TAGS = (
    all    => [@boolean::EXPORT, @boolean::EXPORT_OK],
    test   => [qw(isTrue isFalse isBoolean)],
);

sub import {
    my @options = grep $_ ne '-truth', @_;
    $_[0]->truth if @options != @_;
    @_ = @options;
    goto &Exporter::import;
}

my ($true_val, $false_val, $bool_vals);

BEGIN {
    my $have_readonly = eval { require Readonly };
    # If both JSON::XS and Readonly::XS are used, an error will occur.
    $have_readonly &&= !eval { require Readonly::XS };

    my $t = 1;
    my $f = 0;
    $true  = do {bless \$t, 'boolean'};
    $false = do {bless \$f, 'boolean'};

    if ( $have_readonly ) {
        Readonly::Scalar($t => $t);
        Readonly::Scalar($f => $f);
    }

    $true_val  = overload::StrVal($true);
    $false_val = overload::StrVal($false);
    $bool_vals = {$true_val => 1, $false_val => 1};
}

sub true()  { $true }
sub false() { $false }
sub boolean($) {
    die "Not enough arguments for boolean::boolean" if scalar(@_) == 0;
    die "Too many arguments for boolean::boolean" if scalar(@_) > 1;
    return not(defined $_[0]) ? false :
    "$_[0]" ? $true : $false;
}
sub isTrue($)  {
    not(defined $_[0]) ? false :
    (overload::StrVal($_[0]) eq $true_val)  ? true : false;
}
sub isFalse($) {
    not(defined $_[0]) ? false :
    (overload::StrVal($_[0]) eq $false_val) ? true : false;
}
sub isBoolean($) {
    not(defined $_[0]) ? false :
    (exists $bool_vals->{overload::StrVal($_[0])}) ? true : false;
}

sub truth {
    # enable modifying true and false
    &Internals::SvREADONLY( \ !!0, 0);
    &Internals::SvREADONLY( \ !!1, 0);
    # turn perl internal booleans into blessed booleans:
    ${ \ !!0 } = $false;
    ${ \ !!1 } = $true;
    # make true and false read-only again
    &Internals::SvREADONLY( \ !!0, 1);
    &Internals::SvREADONLY( \ !!1, 1);
}

sub TO_JSON { ${$_[0]} ? \1 : \0 }

1;

=encoding utf8

=head1 NAME

boolean - Boolean support for Perl

=head1 SYNOPSIS

    use boolean;

    do &always if true;
    do &never if false;

    do &maybe if boolean($value)->isTrue;

and:

    use boolean ':all';

    $guess = int(rand(2)) % 2 ? true : false;

    do &something if isTrue($guess);
    do &something_else if isFalse($guess);

and:

    use boolean -truth;

    die unless ref(42 == 42) eq 'boolean';
    die unless ("foo" =~ /bar/) eq '0';

=head1 DESCRIPTION

Most programming languages have a native C<Boolean> data type.
Perl does not.

Perl has a simple and well known Truth System. The following scalar
values are false:

    $false1 = undef;
    $false2 = 0;
    $false3 = 0.0;
    $false4 = '';
    $false5 = '0';

Every other scalar value is true.

This module provides basic Boolean support, by defining two special
objects: C<true> and C<false>.

=head1 RATIONALE

When sharing data between programming languages, it is important to
support the same group of basic types. In Perlish programming languages,
these types include: Hash, Array, String, Number, Null and Boolean. Perl
lacks native Boolean support.

Data interchange modules like YAML and JSON can now C<use boolean> to
encode/decode/roundtrip Boolean values.

=head1 FUNCTIONS

This module defines the following functions:

=over

=item true

This function returns a scalar value which will evaluate to true. The
value is a singleton object, meaning there is only one "true" value in a
Perl process at any time. You can check to see whether the value is the
"true" object with the isTrue function described below.

=item false

This function returns a scalar value which will evaluate to false. The
value is a singleton object, meaning there is only one "false" value in
a Perl process at any time. You can check to see whether the value is
the "false" object with the isFalse function described below.

=item boolean($scalar)

Casts the scalar value to a boolean value. If C<$scalar> is true, it
returns C<boolean::true>, otherwise it returns C<boolean::false>.

=item isTrue($scalar)

Returns C<boolean::true> if the scalar passed to it is the
C<boolean::true> object. Returns C<boolean::false> otherwise.

=item isFalse($scalar)

Returns C<boolean::true> if the scalar passed to it is the
C<boolean::false> object. Returns C<boolean::false> otherwise.

=item isBoolean($scalar)

Returns C<boolean::true> if the scalar passed to it is the
C<boolean::true> or C<boolean::false> object. Returns C<boolean::false>
otherwise.

=back

=head1 METHODS

Since true and false return objects, you can call methods on them.

=over

=item $boolean->isTrue

Same as isTrue($boolean).

=item $boolean->isFalse

Same as isFalse($boolean).

=back

=head1 USE OPTIONS

By default this module exports the C<true>, C<false> and C<boolean> functions.

The module also defines these export tags:

=over

=item :all

Exports C<true>, C<false>, C<boolean>, C<isTrue>, C<isFalse>, C<isBoolean>

=back

=head2 -truth

You can specify the C<-truth> option to override truth operators to return
C<boolean> values.

    use boolean -truth;
    print ref("hello" eq "world"), "\n";

Prints:

    boolean

C<-truth> can be used with the other import options.

=head1 JSON SUPPORT

JSON.pm will encode Perl data with boolean.pm values correctly if you use the
C<convert_blessed> option:

    use JSON;
    use boolean -truth;
    my $json = JSON->new->convert_blessed;
    say $json->encode({false => (0 == 1)});     # Says: '{"false":false}',

=head1 AUTHOR

Ingy döt Net <ingy@cpan.org>

=head1 COPYRIGHT

Copyright (c) 2007, 2008, 2010, 2011, 2013. Ingy döt Net.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://www.perl.com/perl/misc/Artistic.html

=cut
