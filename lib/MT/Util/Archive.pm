# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Util::Archive;

use strict;
use warnings;

use base qw( MT::ErrorHandler );

sub new {
    my $pkg = shift;
    my ($type, $file) = @_;

    return $pkg->error(MT->translate('Type must be specified'))
        unless $type;

    my $classes = MT->registry('archivers');
    return $pkg->error(MT->translate('Registry could not be loaded'))
        unless $classes && %$classes;

    my $class = $classes->{$type};
    $class = $class->{class} if $class;
    return $pkg->error(MT->translate('Registry could not be loaded'))
        unless $class;

    $class =~ s/::(\w+)$/::Bin$1/ if MT->config->UseExternalArchiver;

    my $obj;
    eval "require $class;";
    if (my $e = $@) {
        return $pkg->error($e);
    }
    eval { $obj = $class->new(@_); };
    if (my $e = $@) {
        return $pkg->error($e);
    } elsif (!defined $obj) {
        return $pkg->error($class->errstr);
    }

    $obj;
}

sub available_formats {
    my $pkg     = shift;
    my $classes = MT->registry('archivers');
    return {} unless $classes && %$classes;

    my @data;
    my $use_bin = MT->config->UseExternalArchiver ? 1 : 0;
    for my $key (sort keys %$classes) {
        my $class = $classes->{$key}->{class};
        $class =~ s/::(\w+)$/::Bin$1/ if $use_bin;
        my $error;
        eval "require $class;";
        if ($@) {
            ($error = $@) =~ s/ at .+? line \d+$//s;
            $error = MT->translate("Cannot load [_1]: [_2]", $class, $error);
        } elsif ($use_bin && !$class->find_bin) {
            $error = $class->errstr;
        }
        my $label = $classes->{$key}->{label};
        if ('CODE' eq ref($label)) {
            $label = $label->();
        }
        push @data,
            {
            key   => $key,
            label => $label,
            class => $class,
            error => $error,
            };
    }
    @data;
}

1;
__END__

=head1 NAME

MT::Util::Archive

=head1 SYNOPSIS

MT::Util::Archive is the utility package for easy extraction and compression
of files in Movable Type, both for core usage and also plugins.  The package
itself is just a simple factory.  The heavy lifting is done in child package
for each compression method.

In the core there are I<MT::Util::Archive::Zip> and I<MT::Util::Archive::Tgz>.
Plugins can add its own extraction and compression methods by creating
the package and register itself to a typename.

=head1 METHODS

=head2 new( 'TypeName', $fh )
=head2 new( 'TypeName', '/path/to/file.ext' )

Creates or reads an archive file and returns an object blessed by 
a package determined in Type parameter.  Returns undef if specified 
type is not in the registry, or some other error during creation of 
the specified package.

=head1 ABSTRACT METHODS

These methods should be overridden by each specific package.

=head2 flush()

Flushes the current content to file.

=head2 close()

Flushes and closes the object (and its associated file handles).

Do not call close method (but DO call flush method) if 
the archive object was created by passing filehandle as 
the second argument to contructor.  Opener should be 
responsible to when to close the handle.

=head2 type()

Returns the typename of the object.

=head2 is( 'TypeName' )

Returns true if the object's type is the one specified in the argument.

=head2 files()

Returns an array of the name of files in the archive file.

=head2 extract( '/path/to/extract' )

Extracts all of the files in the archive file to specified directory.
If the argument is not specified, it defaults to TempDir.

=head2 add_file( '/path/to/thefile', 'file name' )

Adds the specified file into the archive file.

=head2 add_string( 'data to be added', 'file name' )

Adds the specified string as a file.

=head2 add_tree( '/path/to/directory' )

Adds all files incleded in the specified directory into the archive file.
