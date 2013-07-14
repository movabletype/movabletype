# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::FileMgr;

use strict;
use base qw( MT::ErrorHandler );

sub new {
    my $class = shift;
    my $type  = shift;
    $class .= "::" . $type;
    eval "use $class;";
    die "Unsupported file manager $class: $@" if $@;
    my $fmgr = bless {}, $class;
    $fmgr->init(@_)
        or return $class->error( $fmgr->errstr );
    return $fmgr;
}

sub init {
    my $fmgr = shift;
    $fmgr;
}

sub get_data;
sub put;
sub put_data;
sub exists;
sub can_write;
sub mkpath;
sub rename;
sub delete;
sub rmdir;
sub content_is_updated {1}
sub file_mod_time      {undef}
sub file_size          {undef}

sub is_handle {
    my ( $fmgr, $f ) = @_;
    my $fd = ref($f) || ref( \$f ) eq 'GLOB' ? fileno($f) : undef;
    return defined $fd;
}

1;
__END__

=head1 NAME

MT::FileMgr - Base class for file management drivers

=head1 SYNOPSIS

    use MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local')
        or die MT::FileMgr->errstr;
    defined(my $bytes = $fmgr->put($src, $dest))
        or die $fmgr->errstr;

=head1 DESCRIPTION

I<MT::FileMgr> is a base class for file management driver implementations;
it provides an abstraction of file management such that other Movable Type
classes do not have to worry if files should be built locally or through
FTP. For example, the process that rebuilds a user's site only has to build
the content, then pass it off to the I<MT::FileMgr> driver; it does not have
to worry whether the user's site is hosted locally or on an FTP server.
I<MT::FileMgr> dispatches control to the appropriate driver, and the content
is pushed to wherever it needs to be pushed.

=head1 USAGE

=head2 MT::FileMgr->new($type [, @args ])

Loads the driver class I<$type> (either C<FTP> or C<Local>, currently) and
returns a new file manager object blessed into the appropriate driver
subclass.

I<@args> is optional; it will be passed along to the subclass's I<init>
method, for driver-specific initialization. For example, the C<FTP> driver
requires the FTP host, username, and password in I<@args>, whereas the C<Local>
host does not require anything.

If an initialization error occurs, returns C<undef>; see L<ERROR HANDLING>,
below.

=head2 $fmgr->init()

This is an internal method called by C<MT::FileMgr-E<gt>new> that
initializes an L<MT::ConfigMgr/instance> as the I<cfg> attribute.

=head2 $fmgr->put($src, $dest [, $type ])

Puts the contents of the file I<$src> in the path I<$dest>. I<$src> can be
either a filehandle of the path to a local file; I<$dest> must be a path to
a file, either local or remote (depending on the driver).

I<$type> is optional and defines whether the I<put> is for an uploaded file
or for an output HTML file; this tells the I<FileMgr> drivers what mode to
write the files in, what I<umask> settings to use, etc. The two values for
I<$type> are C<upload> and C<output>; C<output> is the default.

Returns the number of bytes "put" (can be 0).

On error, returns C<undef>; see L<ERROR HANDLING>, below.

=head2 $fmgr->put_data($data, $dest [, $type ])

Puts the block of data I<$data> in the path I<$dest>. I<$src> should be a
scalar containing the data, and I<$dest> should be a path to a file, either
local or remote (depending on the driver).

I<$type> is optional and defines whether the I<put_data> is for an uploaded
file or for an output HTML file; this tells the I<FileMgr> drivers what mode
to write the files in, what I<umask> settings to use, etc. The two values for
I<$type> are C<upload> and C<output>; C<output> is the default.

Returns the number of bytes "put" (can be 0).

On error, returns C<undef>; see L<ERROR HANDLING>, below.

=head2 $fmgr->get_data($src [, $type ])

Gets a block of data from the path I<$src>; returns the block of data.
I<$src> should be a path to a file, either local or remote (depending on the
driver).

I<$type> is optional and defines whether the I<get_data> is for an uploaded
file or for an output HTML file; this tells the I<FileMgr> drivers what mode
to write the files in, what I<umask> settings to use, etc. The two values for
I<$type> are C<upload> and C<output>; C<output> is the default.

On error, returns C<undef>; see L<ERROR HANDLING>, below.

=head2 $fmgr->exists($path)

Returns true if the file or directory I<$path> exists, false otherwise.

=head2 $fmgr->mkpath($path)

Creates the path I<$path> recursively; in other words, if any of the
directories in the path do not exist, they are created. Returns true on
success.

On error, returns C<undef>; see L<ERROR HANDLING>, below.

=head2 $fmgr->rename($src, $dest)

Renames the file or directory I<$src> to I<$dest>. Returns true on success.

On error, returns C<undef>; see L<ERROR HANDLING>, below.

=head2 content_is_updated($file, $content)

Returns true if the contents of I<$file> differs from the value in
I<$content>.

=head2 $fmgr->file_mod_time($file)

Returns the modification timestamp for I<$file>.

=head2 $fmgr->is_handle($file)

Return the file descriptor of I<file> or C<undef> if not found.

=head1 ERROR HANDLING

On an error, all of the above methods (except I<exists>) return C<undef>,
and the error message can be obtained by calling the method I<errstr> on the
class or the object (depending on whether the method called was a class method
or an instance method).

For example, called on a class name:

    my $fmgr = MT::FileMgr->new('Local')
        or die MT::FileMgr->errstr;

Or, called on an object:

    defined(my $bytes = $fmgr->put($src, $dest))
        or die $fmgr->errstr;

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
