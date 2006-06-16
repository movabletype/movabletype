# Copyright (c) 2000-2004 Dave Rolsky
# All rights reserved.
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.  See the LICENSE
# file that comes with this distribution for more details.
package Params::Validate;

use strict;

require DynaLoader;

if ( $] >= 5.006 )
{
    require XSLoader;
    XSLoader::load( 'Params::Validate', $Params::Validate::VERSION );
}
else
{
    require DynaLoader;
    push @ISA, 'DynaLoader';
    Params::Validate->bootstrap( $Params::Validate::VERSION );
}

my $default_fail = sub { require Carp;
                         Carp::confess($_[0]) };

{
    my %defaults = ( ignore_case   => 0,
		     strip_leading => 0,
		     allow_extra   => 0,
		     on_fail       => $default_fail,
		     stack_skip    => 1,
                     normalize_keys => undef,
		   );

    *set_options = \&validation_options;
    sub validation_options
    {
	my %opts = @_;

	my $caller = caller;

	foreach ( keys %defaults )
	{
	    $opts{$_} = $defaults{$_} unless exists $opts{$_};
	}

	$OPTIONS{$caller} = \%opts;
    }
}

sub _check_regex_from_xs { return $_[0] =~ /$_[1]/ ? 1 : 0 }

BEGIN
{
    if ( $] >= 5.006 && $] < 5.007 )
    {
        eval <<'EOF';
sub check_for_error
{
    if ( defined $Params::Validate::ERROR )
    {
        $Params::Validate::ON_FAIL ||= sub { require Carp; Carp::croak( $_[0] ) };

        $Params::Validate::ON_FAIL->($Params::Validate::ERROR)
    }
}

sub validate_pos (\@@)
{
    local $Params::Validate::ERROR;
    local $Params::Validate::ON_FAIL;
    local $Params::Validate::CALLER = caller;

    my $r;
    if (defined wantarray)
    {
        $r = &_validate_pos;
    }
    else
    {
        &_validate_pos;
    }

    check_for_error();

    return wantarray ? @$r : $r if defined wantarray;
}

sub validate (\@$)
{
    local $Params::Validate::ERROR;
    local $Params::Validate::ON_FAIL;
    local $Params::Validate::CALLER = caller;

    my $r;
    if (defined wantarray)
    {
        $r = &_validate;
    }
    else
    {
        &_validate;
    }

    check_for_error();

    return wantarray ? %$r : $r if defined wantarray;
}

sub validate_with
{
    local $Params::Validate::ERROR;
    local $Params::Validate::ON_FAIL;
    local $Params::Validate::CALLER = caller;

    my $r;
    if (defined wantarray)
    {
        $r = &_validate_with;
    }
    else
    {
        &_validate_with;
    }

    check_for_error();

    my %p = @_;
    if ( UNIVERSAL::isa( $p{spec}, 'ARRAY' ) )
    {
        return wantarray ? @$r : $r if defined wantarray;
    }
    else
    {
        return wantarray ? %$r : $r if defined wantarray;
    }
}
EOF

        die $@ if $@;
    }
    else
    {
        *validate      = \&_validate;
        *validate_pos  = \&_validate_pos;
        *validate_with = \&_validate_with;
    }
}

1;

__END__

=head1 NAME

Params::ValidateXS - XS implementation of Params::Validate

=head1 SYNOPSIS

  See Params::Validate

=head1 DESCRIPTION

This is an XS implementation of Params::Validate.  See the
Params::Validate documentation for details.

=head1 COPYRIGHT

Copyright (c) 2004 David Rolsky.  All rights reserved.  This program
is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

=cut
