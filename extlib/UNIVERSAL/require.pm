package UNIVERSAL::require;
$UNIVERSAL::require::VERSION = '0.11';

# We do this because UNIVERSAL.pm uses CORE::require().  We're going
# to put our own require() into UNIVERSAL and that makes an ambiguity.
# So we load it up beforehand to avoid that.
BEGIN { require UNIVERSAL }

package UNIVERSAL;

use strict;

use vars qw($Level);
$Level = 0;

=pod

=head1 NAME

  UNIVERSAL::require - require() modules from a variable

=head1 SYNOPSIS

  # This only needs to be said once in your program.
  require UNIVERSAL::require;

  # Same as "require Some::Module"
  my $module = 'Some::Module';
  $module->require or die $@;

  # Same as "use Some::Module"
  BEGIN { $module->use or die $@ }


=head1 DESCRIPTION

If you've ever had to do this...

    eval "require $module";

to get around the bareword caveats on require(), this module is for
you.  It creates a universal require() class method that will work
with every Perl module and its secure.  So instead of doing some
arcane eval() work, you can do this:

    $module->require;

It doesn't save you much typing, but it'll make alot more sense to
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

    die("UNIVERSAL::require() can only be run as a class method")
      if ref $module; 

    die("UNIVERSAL::require() takes no or one arguments") if @_ > 2;

    my($call_package, $call_file, $call_line) = caller($Level);

    # Load the module.
    my $file = $module . '.pm';
    $file =~ s{::}{/}g;

    # For performance reasons, check if its already been loaded.  This makes
    # things about 4 times faster.
    return 1 if $INC{$file};

    my $return = eval qq{ 
#line $call_line "$call_file"
CORE::require(\$file); 
};

    # Check for module load failure.
    if( $@ ) {
        $UNIVERSAL::require::ERROR = $@;
        return $return;
    }

    # Module version check.
    if( @_ == 2 ) {
        eval qq{
#line $call_line "$call_file"
\$module->VERSION($want_version);
};

        if( $@ ) {
            $UNIVERSAL::require::ERROR = $@;
            return 0;
        }
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
};

    if( $@ ) {
        $UNIVERSAL::require::ERROR = $@;
        return 0;
    }

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


=head1 SEE ALSO

L<Module::Load>,  L<perlfunc/require>, L<http://dev.perl.org/rfc/253.pod>

=cut


1;
