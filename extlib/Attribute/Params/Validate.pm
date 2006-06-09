package Attribute::Params::Validate;

use strict;
use warnings; # ok to use cause Attribute::Handlers needs 5.6.0+ as well

use attributes;

use Attribute::Handlers;

# this will all be re-exported
use Params::Validate qw(:all);

require Exporter;

use vars qw($VERSION);

our @ISA = qw(Exporter);

my %tags = ( types => [ qw( SCALAR ARRAYREF HASHREF CODEREF GLOB GLOBREF SCALARREF HANDLE UNDEF OBJECT ) ],
	   );

our %EXPORT_TAGS = ( 'all' => [ qw( validation_options ), map { @{ $tags{$_} } } keys %tags ],
		     %tags,
		   );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{all} }, 'validation_options' );

$VERSION = sprintf '%2d.%02d', q$Revision: 1.7 $ =~ /(\d+)\.(\d+)/;


sub UNIVERSAL::Validate : ATTR(CODE, INIT)
{
    _wrap_sub('named', @_);
}

sub UNIVERSAL::ValidatePos : ATTR(CODE, INIT)
{
    _wrap_sub('positional', @_);
}

sub _wrap_sub
{
    my ($type, $package, $symbol, $referent, $attr, $params) = @_;

    my @p = @$params;
    $params = {@p};

    my $subname = $package . '::' . *{$symbol}{NAME};

    my %attributes = map { $_ => 1 } attributes::get($referent);
    my $is_method = $attributes{method};

    {
	no warnings 'redefine';
	no strict 'refs';

	# An unholy mixture of closure and eval.  This is done so that
	# the code to automatically create the relevant scalars from
	# the hash of params can create the scalars in the proper
	# place lexically.

	my $code = <<"EOF";
sub
{
    package $package;
EOF

	$code .= "    my \$object = shift;\n" if $is_method;

	if ($type eq 'named')
	{
	    $code .= "    Params::Validate::validate(\@_, \$params);\n";
	}
	else
	{
	    $code .= "    Params::Validate::validate_pos(\@_, \@p);\n";
	}

	$code .= "    unshift \@_, \$object if \$object;\n" if $is_method;

	$code .= <<"EOF";
    \$referent->(\@_);
}
EOF

	my $sub = eval $code;
	die $@ if $@;

	*{$subname} = $sub;
    }
}

1;


=head1 NAME

Attribute::Params::Validate - Validate method/function parameters using attributes

=head1 SYNOPSIS

  use Attribute::Params::Validate qw(:all);

  # takes named params (hash or hashref)
  # foo is mandatory, bar is optional
  sub foo : Validate( foo => 1, bar => 0 )
  {
      ...
  }

  # takes positional params
  # first two are mandatory, third is optional
  sub bar : ValidatePos( 1, 1, 0 )
  {
      ...
  }

  # for some reason Perl insists that the entire attribute be on one line
  sub foo2 : Validate( foo => { type => ARRAYREF }, bar => { can => [ 'print', 'flush', 'frobnicate' ] }, baz => { type => SCALAR, callbacks => { 'numbers only' => sub { shift() =~ /^\d+$/ }, 'less than 90' => sub { shift() < 90 } } } )
  {
      ...
  }

  # note that this is marked as a method.  This is very important!
  sub baz : Validate( foo => { type => ARRAYREF }, bar => { isa => 'Frobnicator' } ) method
  {
      ...
  }

=head1 DESCRIPTION


The Attribute::Params::Validate module allows you to validate method
or function call parameters just like Params::Validate does.  However,
this module allows you to specify your validation spec as an
attribute, rather than by calling the C<validate> routine.

Please see Params::Validate for more information on how you can
specify what validation is performed.

=head2 EXPORT

This module exports everthing that Params::Validate does except for
the C<validate> and C<validate_pos> subroutines.

=head2 ATTRIBUTES

=over 4

=item * Validate

This attribute corresponse to the C<validate> subroutine in
Params::Validate.

=item * ValidatePos

This attribute corresponse to the C<validate_pos> subroutine in
Params::Validate.

=back

=head2 OO

If you are using this module to mark B<methods> for validation, as
opposed to subroutines, it is crucial that you mark these methods with
the C<:method> attribute, as well as the C<Validate> or C<ValidatePos>
attribute.

If you do not do this, then the object or class used in the method
call will be passed to the validation routines, which is probably not
what you want.

=head2 CAVEATS

You B<must> put all the arguments to the C<Validate> or C<ValidatePos>
attribute on a single line, or Perl will complain.

=head1 SEE ALSO

Params::Validate

=head1 AUTHOR

Dave Rolsky, <autarch@urth.org>

=cut

