package UNIVERSAL::require;
$UNIVERSAL::require::VERSION = '0.19';

# We do this because UNIVERSAL.pm uses CORE::require().  We're going
# to put our own require() into UNIVERSAL and that makes an ambiguity.
# So we load it up beforehand to avoid that.
BEGIN { require UNIVERSAL }

package UNIVERSAL;

use 5.006;
use strict;
use warnings;
use Carp;

# regexp for valid module name. Lifted from Module::Runtime
my $module_name_rx = qr/[A-Z_a-z][0-9A-Z_a-z]*(?:::[0-9A-Z_a-z]+)*/;

our $Level = 0;

=pod

=head1 NAME

UNIVERSAL::require - require() modules from a variable [deprecated]

=head1 SYNOPSIS

  # This only needs to be said once in your program.
  require UNIVERSAL::require;

  # Same as "require Some::Module"
  my $module = 'Some::Module';
  $module->require or die $@;

  # Same as "use Some::Module"
  BEGIN { $module->use or die $@ }


=head1 DESCRIPTION

Before using this module, you should look at the alternatives,
some of which are listed in SEE ALSO below.

This module provides a safe mechanism for loading a module at runtime,
when you have the name of the module in a variable.

If you've ever had to do this...

    eval "require $module";

to get around the bareword caveats on require(), this module is for
you.  It creates a universal require() class method that will work
with every Perl module and its secure.  So instead of doing some
arcane eval() work, you can do this:

    $module->require;

It doesn't save you much typing, but it'll make a lot more sense to
someone who's not a ninth level Perl acolyte.

=head1 Methods

=head3 require

  my $return_val = $module->require           or die $@;
  my $return_val = $module->require($version) or die $@;

This works exactly like Perl's require, except without the bareword
restriction, and it doesn't die.  Since require() is placed in the
UNIVERSAL namespace, it will work on B<any> module.  You just have to
use UNIVERSAL::require somewhere in your code.

Should the module require fail, or not be a high enough $version, it
will simply return false and B<not die>.  The error will be in
$@ as well as $UNIVERSAL::require::ERROR.

    $module->require or die $@;

=cut

sub require {
    my($module, $want_version) = @_;

    $UNIVERSAL::require::ERROR = '';

    croak("UNIVERSAL::require() can only be run as a class method")
      if ref $module; 

    croak("invalid module name '$module'") if $module !~ /\A$module_name_rx\z/;

    croak("UNIVERSAL::require() takes no or one arguments") if @_ > 2;

    my($call_package, $call_file, $call_line) = caller($Level);

    # Load the module.
    my $file = $module . '.pm';
    $file =~ s{::}{/}g;

    # For performance reasons, check if its already been loaded.  This makes
    # things about 4 times faster.
    # We use the eval { } to make sure $@ is not set. See RT #44444 for details
    return eval { 1 } if $INC{$file};

    my $return = eval qq{ 
#line $call_line "$call_file"
CORE::require(\$file); 
};

    # Check for module load failure.
    if( !$return ) {
        $UNIVERSAL::require::ERROR = $@;
        return $return;
    }

    # Module version check.
    if( @_ == 2 ) {
        eval qq{
#line $call_line "$call_file"
\$module->VERSION($want_version);
1;
}       or do {
            $UNIVERSAL::require::ERROR = $@;
            return 0;
        };
    }
    return $return;
}


=head3 use

    my $require_return = $module->use           or die $@;
    my $require_return = $module->use(@imports) or die $@;

Like C<UNIVERSAL::require>, this allows you to C<use> a $module without
having to eval to work around the bareword requirement.  It returns the
same as require.

Should either the require or the import fail it will return false.  The
error will be in $@.

If possible, call this inside a BEGIN block to emulate a normal C<use>
as closely as possible.

    BEGIN { $module->use }

=cut

sub use {
    my($module, @imports) = @_;

    local $Level = 1;
    my $return = $module->require or return 0;

    my($call_package, $call_file, $call_line) = caller;

    eval qq{
package $call_package;
#line $call_line "$call_file"
\$module->import(\@imports);
1;
}   or do {
        $UNIVERSAL::require::ERROR = $@;
        return 0;
    };

    return $return;
}


=head1 SECURITY NOTES

UNIVERSAL::require makes use of C<eval STRING>.  In previous versions
of UNIVERSAL::require it was discovered that one could craft a class
name which would result in code being executed.  This hole has been
closed.  The only variables now exposed to C<eval STRING> are the
caller's package, filename and line which are not tainted.

UNIVERSAL::require is taint clean.


=head1 COPYRIGHT

Copyright 2001, 2005 by Michael G Schwern E<lt>schwern@pobox.comE<gt>.

This program is free software; you can redistribute it and/or 
modify it under the same terms as Perl itself.

See F<http://www.perl.com/perl/misc/Artistic.html>


=head1 AUTHOR

Michael G Schwern <schwern@pobox.com>

Now maintained by Neil Bowers (NEILB).

=head1 SEE ALSO

L<Module::Load> provides functions for loading code,
and importing functions.
It's actively maintained.

L<Module::Runtime> provides a number of usesful functions
for require'ing and use'ing modules,
and associated operations.

L<Mojo::Loader> is a class loader and plugin framework.
L<Module::Loader> is a stand-alone module that was inspired
by C<Mojo::Loader>.

There are many other modules that may be of interest on CPAN.
An old review of some of them can be read at
L<https://neilb.org/reviews/module-loading.html>.

L<perlfunc/require>.

=cut


1;
