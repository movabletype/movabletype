package constant::override;

use warnings;
use strict;

use Sub::Uplevel;

use Carp;
use constant;

our $VERSION = '0.01';

my $has_been_called = 0; ## no critic

sub _substituted_import
{
    my ($original_import, $default_functionality, $substitute, 
        $ignore, $substitute_fn, $class, @args) = @_;

    if (not @args) {
        return;
    }

    my $pkg = caller(1);

    my $multiple = ref $args[0];
    if ($multiple and ref $args[0] ne 'HASH') {
        croak("Invalid reference type '".$multiple."' ".
                "(must be 'HASH').");
    }

    my %constants;
    if ($multiple) {
        %constants = %{$args[0]};
    }
    else {
        $constants{$args[0]} = undef;
    }

    for my $name (keys %constants) {
        my $full_name = $pkg.'::'.$name;

        if (exists $substitute->{$full_name}) {
            $substitute_fn->($full_name, $substitute->{$full_name});
        }
        elsif (exists $substitute->{$name}) {
            $substitute_fn->($full_name, $substitute->{$name});
        }
        elsif (exists $ignore->{$full_name}) {
            next;
        }
        elsif (exists $ignore->{$name}) {
            next;
        }
        elsif ($default_functionality) {
            my @values = 
                ($multiple) 
                    ? $constants{$name}
                    : @args[1..$#args];
            $substitute_fn->($full_name, @values);
        }
        else {
            uplevel 2, $original_import, ($class, @args);
        }
    }
}

sub import
{
    my $class = shift;
    my %args  = @_;

    my ($ignore, $substitute) = @args{qw(ignore substitute)};
    
    my %ignore     = map { $_ => 1 } @{$args{'ignore'} || []};
    my %substitute = %{$args{'substitute'} || {}};

    my $value_to_fn = sub {
        my (@values) = @_;
        (@values == 1)
            ? (ref $values[0] eq 'CODE') 
                ? $values[0] 
                : sub () { $values[0] }
            : sub () { @values }
    };
    my $substitute_fn = sub {
        my ($binding, @values) = @_;
        no warnings;
        no strict 'refs';   ## no critic
        *{$binding} = $value_to_fn->(@values);
    };

    my $default_functionality = (not $has_been_called);
    $has_been_called = 1;

    ## no critic

    no warnings;
    no strict 'refs'; 

    my $original_import = \&{'constant::import'};
    *{'constant::import'} = sub {
        _substituted_import($original_import, 
                            $default_functionality,
                            \%substitute, 
                            \%ignore, $substitute_fn, @_)
    };

    return 1;
}

1;

__END__

=head1 NAME

constant::override - Override/ignore constants

=head1 SYNOPSIS

    use constant::override ignore     => [ 'SO_CONFIG_FILE' ],
                           substitute => { 'MYCONST1' => 1,
                                           'MYCONST2' => sub { 2 } };

    use constant SO_CONFIG_FILE => 100;
    use constant MYCONST1       => 200;
    use constant MYCONST2       => 300;

    eval { SO_CONFIG_FILE() };      # Undefined function error.
    print MYCONST1,"\n";            # 1.
    print MYCONST2,"\n";            # 2.

=head1 DESCRIPTION

Provides for overriding C<constant>'s import method, so that the
'constant' functions can be replaced with your own functions/values,
or ignored altogether.

C<use constant::override ...> statements must occur before 
C<use constant ...> statements.

=head1 PUBLIC METHODS

=over 4

=item B<import>

Takes a hash of arguments:

=over 8

=item ignore

An arrayref of constant names (may be
package-qualified). Any subsequent attempt to
define a constant with this name will be silently
ignored.

=item substitute

A hashref mapping from constant name (may be
package-qualified) to either a scalar value or a
coderef. Any subsequent attempt to define a
constant with that name will cause the constant to
map to either the specified coderef, or a coderef
that returns the specified scalar value.

=back

Package-qualified constants are preferred to bare constants, and
substituting a constant is preferred to ignoring a constant, when
determining what to do on subsequent calls to C<import>.

=back

=head1 BUGS

Please report any bugs or feature requests to C<bug-constant-override at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=constant-override>.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc constant::override


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=constant-override>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/constant-override>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/constant-override>

=item * Search CPAN

L<http://search.cpan.org/dist/constant-override/>

=back

=head1 AUTHOR

 Tom Harrison
 APNIC Software, C<< <cpan at apnic.net> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2013 APNIC Pty Ltd.

This library is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

The full text of the license can be found in the LICENSE file included
with this module.

=cut
