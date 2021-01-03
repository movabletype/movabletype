# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Tool;

use strict;
use warnings;
use charnames qw( :full );

use Carp qw( croak );
use English qw( -no_match_vars );
use Getopt::Long;

sub show_help {
    my $class = shift;
    my $help  = $class->help();

    # TODO: strip spaces more smartly for people who may format
    # their help() methods differently.
    $help =~ s/ ^ [\N{SPACE}]{4} //xmsg;
    print $help;
}

sub show_usage {
    my $class = shift;
    print qq{usage:  $PROGRAM_NAME },
        join( qq{\n        $PROGRAM_NAME }, $class->usage() ),
        qq{\n};
}

sub usage;
sub help;
sub options { }

sub set_up_app {

    # TODO: a Tool should probably be its own App, so we can use *all*
    # the MT::App infrastructure. For now fake it like rpt does.
    require MT;
    my $mt = MT->new() or die MT->errstr;

    $mt->{vtbl}                 = {};
    $mt->{is_admin}             = 0;
    $mt->{template_dir}         = 'cms';
    $mt->{user_class}           = 'MT::Author';
    $mt->{plugin_template_path} = 'tmpl';
    $mt->run_callbacks( 'init_app', $mt );

    return $mt;
}

sub main {
    my $class = shift;

    $class->set_up_app();

    my $verbose;
    my $opts_good = GetOptions(
        'help!' => sub { $class->show_usage(); $class->show_help(); exit; },
        'usage!' => sub { $class->show_usage(); exit; },
        'verbose|v+' => \$verbose,

        $class->options(),
    );
    $class->show_usage(), exit if !$opts_good;

    return $verbose;
}

1;

__END__

=head1 NAME

MT::Tool - shared infrastructure for command line tools

=head1 SYNOPSIS

    package Foobar::Tool::MakeQuuxen
    use strict;

    use lib  qw( extlib lib );
    use base qw( MT::Tool );

    sub help {
        q{
            --special    Make extra special quuxen.
        };
    }

    sub usage { '[--special]' }

    my ($special);

    sub options {
        return (
            'special!' => \$special,
        );
    }

    sub main {
        my $class = shift;
        ($verbose) = $class->SUPER::main(@_);

        ## Make those quuxen!
        ...
    }

    __PACKAGE__->main() unless caller;

    1;

=head1 DESCRIPTION

I<MT::Tool> provides shared infrastructure around command line tools for MT
applications. With these, you can provide a standard interface for your tools
similar to MT's other command line applications.

=head1 USAGE

=head2 use base qw( MT::Tool )

Declares the current package is a new tool conforming to the MT::Tool
interface. The following class methods should be defined as appropriate for
your tool.

=head2 $class-E<gt>help()

Return the text to use for your tool's C<--help> command.

=head2 $class-E<gt>usage()

Return the option text to use for your tool's C<--usage> command. The text is
also used for the C<--help> synopsis and when invalid options are used.

=head2 $class-E<gt>options()

Return the definition of your tool's additional options, as a hash suitable to
pass to Getopt::Long's C<GetOptions()>. The most common definitions for
Getopt::Long options are:

=over 4

=item * C<I<option>!>

Your option is a flag users can specify up to once. A bound variable will be
set when the flag is found.

The contrary option C<--noI<option>> will be automatically provided. It will
clear the bound variable.

=item * C<I<option>+>

Your option is a flag users can specify more than once. A bound variable will
be B<incremented> when the flag is found.

=item * C<I<option>=s>

Your option takes a string argument. A bound scalar will be set to the argument
the user specifies when the option is found. If an arrayref is bound instead,
arguments will be added to the list when the option is given more than once.

=item * C<I<option>|I<o>>

Your option is availble both as the long form C<--I<option>> and the
abbreviated short form C<-I<o>>. Abbreviated forms can be combined with any of
the type declarations above.

=back

=head2 $class-E<gt>main()

Perform your tool's task. Your implementation should call MT::Tool's
implementation to parse your options and handle the standard options such as
C<--help>. MT::Tool's implementation will return the level of verbosity
requested by the user (that is, how many times the C<-v> option was used).

=head2 $tool-E<gt>set_up_app()

This helper method creates a MT instance and configures it to look like
a L<MT::App> instance (although, it isn't), and invokes the 'init_app'
callback using this instance.

=head2 $class-E<gt>show_help

Displays command-line help provided by the C<MT::Tool> subclass L<help>
method.

=head2 $class-E<gt>show_usage

Displays commnad-line usage instructions provided by the C<MT::Tool>
subclass L<usage> method.

=head1 SEE ALSO

Getopt::Long

=cut
