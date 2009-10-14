###############################################################################
#
# This file copyright (c) 2000 by Randy J. Ray, all rights reserved
#
# Copying and distribution are permitted under the terms of the Artistic
# License as distributed with Perl versions 5.005 and later.
#
###############################################################################
#
# Once upon a time, this code was lifted almost verbatim from wwwis by Alex
# Knowles, alex@ed.ac.uk. Since then, even I barely recognize it. It has
# contributions, fixes, additions and enhancements from all over the world.
#
# See the file README for change history.
#
###############################################################################

package Image::Size;

require 5.002;

use strict;
use Cwd 'cwd';
use File::Spec;
use Symbol;
use Exporter;
use vars qw(@ISA @EXPORT @EXPORT_OK %EXPORT_TAGS $revision $VERSION
            $read_in $last_pos);

@ISA         = qw(Exporter);
@EXPORT      = qw(imgsize);
@EXPORT_OK   = qw(imgsize html_imgsize attr_imgsize);
%EXPORT_TAGS = ('all' => [@EXPORT_OK]);

$revision    = q$Id: Size.pm,v 1.24 2001/04/13 08:52:41 rjray Exp $;
$VERSION     = "2.93";

# Package lexicals - invisible to outside world, used only in imgsize
#
# Cache of files seen, and mapping of patterns to the sizing routine
my %cache = ();

my %type_map = ( '^GIF8[7,9]a'              => \&gifsize,
                 "^\xFF\xD8"                => \&jpegsize,
                 "^\x89PNG\x0d\x0a\x1a\x0a" => \&pngsize,
                 "^P[1-7]"                  => \&ppmsize, # also XVpics
                 '\#define\s+\S+\s+\d+'     => \&xbmsize,
                 '\/\* XPM \*\/'            => \&xpmsize,
                 '^MM\x00\x2a'              => \&tiffsize,
                 '^II\x2a\x00'              => \&tiffsize,
                 '^BM'                      => \&bmpsize,
                 '^8BPS'                    => \&psdsize,
		 '^FWS'                     => \&swfsize);

#
# These are lexically-scoped anonymous subroutines for reading the three
# types of input streams. When the input to imgsize() is typed, then the
# lexical "read_in" is assigned one of these, thus allowing the individual
# routines to operate on these streams abstractly.
#

my $read_io = sub {
    my $handle = shift;
    my ($length, $offset) = @_;

    if (defined($offset) && ($offset != $last_pos))
    {
        $last_pos = $offset;
        return '' if (! seek($handle, $offset, 0));
    }

    my ($data, $rtn) = ('', 0);
    $rtn = read $handle, $data, $length;
    $data = '' unless ($rtn);
    $last_pos = tell $handle;

    $data;
};

my $read_buf = sub {
    my $buf = shift;
    my ($length, $offset) = @_;

    if (defined($offset) && ($offset != $last_pos))
    {
        $last_pos = $offset;
        return '' if ($last_pos > length($$buf));
    }

    my $data = substr($$buf, $last_pos, $length);
    $last_pos += length($data);

    $data;
};

1;

sub imgsize
{
    my $stream = shift;

    my ($handle, $header);
    my ($x, $y, $id, $mtime, @list);
    # These only used if $stream is an existant open FH
    my ($save_pos, $need_restore) = (0, 0);
    # This is for when $stream is a locally-opened file
    my $need_close = 0;

    $header = '';

    if (ref($stream) eq "SCALAR")
    {
        $handle = $stream;
        $read_in = $read_buf;
        $header = substr($$handle, 0, 256);
    }
    elsif (ref $stream)
    {
        #
        # I no longer require $stream to be in the IO::* space. So I'm assuming
        # you don't hose yourself by passing a ref that can't do fileops. If
        # you do, you fix it.
        #
        $handle = $stream;
        $read_in = $read_io;
        $save_pos = tell $handle;
        $need_restore = 1;

        #
        # First alteration (didn't wait long, did I?) to the existant handle:
        #
        # assist dain-bramaged operating systems -- SWD
        # SWD: I'm a bit uncomfortable with changing the mode on a file
        # that something else "owns" ... the change is global, and there
        # is no way to reverse it.
        # But image files ought to be handled as binary anyway.
        #
        binmode($handle);
        seek($handle, 0, 0);
        read $handle, $header, 256;
        seek($handle, 0, 0);
    }
    else
    {
        $stream = File::Spec->catfile(cwd(),$stream)
            unless File::Spec->file_name_is_absolute($stream);
        $mtime = (stat $stream)[9];
        if (-e "$stream" and exists $cache{$stream})
        {
            @list = split(/,/, $cache{$stream}, 4);

            # Don't return the cache if the file is newer.
            return @list[1 .. 3] unless ($list[0] < $mtime);
            # In fact, clear it
            delete $cache{$stream};
        }

        #first try to open the stream
        $handle = gensym;
        open($handle, "< $stream") or
            return (undef, undef, "Can't open image file $stream: $!");

        $need_close = 1;
        # assist dain-bramaged operating systems -- SWD
        binmode($handle);
        read $handle, $header, 256;
        seek($handle, 0, 0);
        $read_in = $read_io;
    }
    $last_pos = 0;

    #
    # Oh pessimism... set the values of $x and $y to the error condition. If
    # the grep() below matches the data to one of the known types, then the
    # called subroutine will override these...
    #
    $id = "Data stream is not a known image file format";
    $x  = undef;
    $y  = undef;

    grep($header =~ /$_/ && (($x, $y, $id) = &{$type_map{$_}}($handle)),
         keys %type_map);

    #
    # Added as an afterthought: I'm probably not the only one who uses the
    # same shaded-sphere image for several items on a bulleted list:
    #
    $cache{$stream} = join(',', $mtime, $x, $y, $id)
        unless (ref $stream or (! defined $x));

    #
    # If we were passed an existant file handle, we need to restore the
    # old filepos:
    #
    seek($handle, $save_pos, 0) if $need_restore;
    # ...and if we opened the file ourselves, we need to close it
    close($handle) if $need_close;

    # results:
    return (wantarray) ? ($x, $y, $id) : ();
}

sub html_imgsize
{
    my @args = imgsize(@_);

    # Use lowercase and quotes so that it works with xhtml.
    return ((defined $args[0]) ?
            sprintf('width="%d" height="%d"', @args) :
            undef);
}

sub attr_imgsize
{
    my @args = imgsize(@_);

    return ((defined $args[0]) ?
            (('-width', '-height', @args)[0, 2, 1, 3]) :
            undef);
}

# This used only in gifsize:
sub img_eof
{
    my $stream = shift;

    return ($last_pos >= length($$stream)) if (ref($stream) eq "SCALAR");

    eof $stream;
}

###########################################################################
# Subroutine gets the size of the specified GIF
###########################################################################
sub gifsize
{
    my $stream = shift;

    my ($cmapsize, $buf, $h, $w, $x, $y, $type);

    my $gif_blockskip = sub {
        my ($skip, $type) = @_;
        my ($lbuf);

        &$read_in($stream, $skip);        # Skip header (if any)
        while (1)
        {
            if (&img_eof($stream))
            {
                return (undef, undef,
                        "Invalid/Corrupted GIF (at EOF in GIF $type)");
            }
            $lbuf = &$read_in($stream, 1);        # Block size
            last if ord($lbuf) == 0;     # Block terminator
            &$read_in($stream, ord($lbuf));  # Skip data
        }
    };

    $type = &$read_in($stream, 6);
    if (length($buf = &$read_in($stream, 7)) != 7 )
    {
        return (undef, undef, "Invalid/Corrupted GIF (bad header)");
    }
    ($x) = unpack("x4 C", $buf);
    if ($x & 0x80)
    {
        $cmapsize = 3 * (2**(($x & 0x07) + 1));
        if (! &$read_in($stream, $cmapsize))
        {
            return (undef, undef,
                    "Invalid/Corrupted GIF (global color map too small?)");
        }
    }

  FINDIMAGE:
    while (1)
    {
        if (&img_eof($stream))
        {
            return (undef, undef,
                    "Invalid/Corrupted GIF (at EOF w/o Image Descriptors)");
        }
        $buf = &$read_in($stream, 1);
        ($x) = unpack("C", $buf);
        if ($x == 0x2c)
        {
            # Image Descriptor (GIF87a, GIF89a 20.c.i)
            if (length($buf = &$read_in($stream, 8)) != 8)
            {
                return (undef, undef,
                        "Invalid/Corrupted GIF (missing image header?)");
            }
            ($x, $w, $y, $h) = unpack("x4 C4", $buf);
            $x += $w * 256;
            $y += $h * 256;
            return ($x, $y, 'GIF');
        }
        if ($x == 0x21)
        {
            # Extension Introducer (GIF89a 23.c.i, could also be in GIF87a)
            $buf = &$read_in($stream, 1);
            ($x) = unpack("C", $buf);
            if ($x == 0xF9)
            {
                # Graphic Control Extension (GIF89a 23.c.ii)
                &$read_in($stream, 6);    # Skip it
                next FINDIMAGE;       # Look again for Image Descriptor
            }
            elsif ($x == 0xFE)
            {
                # Comment Extension (GIF89a 24.c.ii)
                &$gif_blockskip(0, "Comment");
                next FINDIMAGE;       # Look again for Image Descriptor
            }
            elsif ($x == 0x01)
            {
                # Plain Text Label (GIF89a 25.c.ii)
                &$gif_blockskip(13, "text data");
                next FINDIMAGE;       # Look again for Image Descriptor
            }
            elsif ($x == 0xFF)
            {
                # Application Extension Label (GIF89a 26.c.ii)
                &$gif_blockskip(12, "application data");
                next FINDIMAGE;       # Look again for Image Descriptor
            }
            else
            {
                return (undef, undef,
                        sprintf("Invalid/Corrupted GIF (Unknown " .
                                "extension %#x)", $x));
            }
        }
        else
        {
            return (undef, undef,
                    sprintf("Invalid/Corrupted GIF (Unknown code %#x)",
                            $x));
        }
    }
}

sub xbmsize
{
    my $stream = shift;

    my $input;
    my ($x, $y, $id) = (undef, undef, "Could not determine XBM size");

    $input = &$read_in($stream, 1024);
    if ($input =~ /^\#define\s*\S*\s*(\d+)\s*\n\#define\s*\S*\s*(\d+)/si)
    {
        ($x, $y) = ($1, $2);
        $id = 'XBM';
    }

    ($x, $y, $id);
}

# Added by Randy J. Ray, 30 Jul 1996
# Size an XPM file by looking for the "X Y N W" line, where X and Y are
# dimensions, N is the total number of colors defined, and W is the width of
# a color in the ASCII representation, in characters. We only care about X & Y.
sub xpmsize
{
    my $stream = shift;

    my $line;
    my ($x, $y, $id) = (undef, undef, "Could not determine XPM size");

    while ($line = &$read_in($stream, 1024))
    {
        next unless ($line =~ /"\s*(\d+)\s+(\d+)(\s+\d+\s+\d+){1,2}\s*"/s);
        ($x, $y) = ($1, $2);
        $id = 'XPM';
        last;
    }

    ($x, $y, $id);
}


# pngsize : gets the width & height (in pixels) of a png file
# cor this program is on the cutting edge of technology! (pity it's blunt!)
#
# Re-written and tested by tmetro@vl.com
sub pngsize
{
    my $stream = shift;

    my ($x, $y, $id) = (undef, undef, "could not determine PNG size");
    my ($offset, $length);

    # Offset to first Chunk Type code = 8-byte ident + 4-byte chunk length + 1
    $offset = 12; $length = 4;
    if (&$read_in($stream, $length, $offset) eq 'IHDR')
    {
        # IHDR = Image Header
        $length = 8;
        ($x, $y) = unpack("NN", &$read_in($stream, $length));
        $id = 'PNG';
    }

    ($x, $y, $id);
}

# jpegsize: gets the width and height (in pixels) of a jpeg file
# Andrew Tong, werdna@ugcs.caltech.edu           February 14, 1995
# modified slightly by alex@ed.ac.uk
# and further still by rjray@tsoft.com
# optimization and general re-write from tmetro@vl.com
sub jpegsize
{
    my $stream = shift;

    my $MARKER      = "\xFF";       # Section marker.

    my $SIZE_FIRST  = 0xC0;         # Range of segment identifier codes
    my $SIZE_LAST   = 0xC3;         #  that hold size info.

    my ($x, $y, $id) = (undef, undef, "could not determine JPEG size");

    my ($marker, $code, $length);
    my $segheader;

    # Dummy read to skip header ID
    &$read_in($stream, 2);
    while (1)
    {
        $length = 4;
        $segheader = &$read_in($stream, $length);

        # Extract the segment header.
        ($marker, $code, $length) = unpack("a a n", $segheader);

        # Verify that it's a valid segment.
        if ($marker ne $MARKER)
        {
            # Was it there?
            $id = "JPEG marker not found";
            last;
        }
        elsif ((ord($code) >= $SIZE_FIRST) && (ord($code) <= $SIZE_LAST))
        {
            # Segments that contain size info
            $length = 5;
            ($y, $x) = unpack("xnn", &$read_in($stream, $length));
            $id = 'JPG';
            last;
        }
        else
        {
            # Dummy read to skip over data
            &$read_in($stream, ($length - 2));
        }
    }

    ($x, $y, $id);
}

# ppmsize: gets data on the PPM/PGM/PBM family.
#
# Contributed by Carsten Dominik <dominik@strw.LeidenUniv.nl>
sub ppmsize
{
    my $stream = shift;

    my ($x, $y, $id) = (undef, undef,
                        "Unable to determine size of PPM/PGM/PBM data");
    my $n;

    my $header = &$read_in($stream, 1024);

    # PPM file of some sort
    $header =~ s/^\#.*//mg;
    ($n, $x, $y) = ($header =~ /^(P[1-6])\s+(\d+)\s+(\d+)/s);
    $id = "PBM" if $n eq "P1" || $n eq "P4";
    $id = "PGM" if $n eq "P2" || $n eq "P5";
    $id = "PPM" if $n eq "P3" || $n eq "P6";
    if ($n eq 'P7')
    {
        # John Bradley's XV thumbnail pics (thanks to inwap@jomis.Tymnet.COM)
        $id = 'XV';
        ($x, $y) = ($header =~ /IMGINFO:(\d+)x(\d+)/s);
    }

    ($x, $y, $id);
}

# tiffsize: size a TIFF image
#
# Contributed by Cloyce Spradling <cloyce@headgear.org>
sub tiffsize {
    my $stream = shift;

    my ($x, $y, $id) = (undef, undef, "Unable to determine size of TIFF data");

    my $endian = 'n';           # Default to big-endian; I like it better
    my $header = &$read_in($stream, 4);
    $endian = 'v' if ($header =~ /II\x2a\x00/o); # little-endian

    # Set up an association between data types and their corresponding
    # pack/unpack specification.  Don't take any special pains to deal with
    # signed numbers; treat them as unsigned because none of the image
    # dimensions should ever be negative.  (I hope.)
    my @packspec = ( undef,     # nothing (shouldn't happen)
                     'C',       # BYTE (8-bit unsigned integer)
                     undef,     # ASCII
                     $endian,   # SHORT (16-bit unsigned integer)
                     uc($endian), # LONG (32-bit unsigned integer)
                     undef,     # RATIONAL
                     'c',       # SBYTE (8-bit signed integer)
                     undef,     # UNDEFINED
                     $endian,   # SSHORT (16-bit unsigned integer)
                     uc($endian), # SLONG (32-bit unsigned integer)
                     );

    my $offset = &$read_in($stream, 4, 4); # Get offset to IFD
    $offset = unpack(uc($endian), $offset); # Fix it so we can use it

    my $ifd = &$read_in($stream, 2, $offset); # Get number of directory entries
    my $num_dirent = unpack($endian, $ifd); # Make it useful
    $offset += 2;
    $num_dirent = $offset + ($num_dirent * 12); # Calc. maximum offset of IFD

    # Do all the work
    $ifd = '';
    my $tag = 0;
    my $type = 0;
    while (!defined($x) || !defined($y)) {
        $ifd = &$read_in($stream, 12, $offset); # Get first directory entry
        last if (($ifd eq '') || ($offset > $num_dirent));
        $offset += 12;
        $tag = unpack($endian, $ifd); # ...and decode its tag
        $type = unpack($endian, substr($ifd, 2, 2)); # ...and the data type
        # Check the type for sanity.
        next if (($type > @packspec+0) || (!defined($packspec[$type])));
        if ($tag == 0x0100) {   # ImageWidth (x)
            # Decode the value
            $x = unpack($packspec[$type], substr($ifd, 8, 4));
        } elsif ($tag == 0x0101) {      # ImageLength (y)
            # Decode the value
            $y = unpack($packspec[$type], substr($ifd, 8, 4));
        }
    }

    # Decide if we were successful or not
    if (defined($x) && defined($y)) {
        $id = 'TIF';
    } else {
        $id = '';
        $id = 'ImageWidth ' if (!defined($x));
        if (!defined ($y)) {
            $id .= 'and ' if ($id ne '');
            $id .= 'ImageLength ';
        }
        $id .= 'tag(s) could not be found';
    }

    ($x, $y, $id);
}

# bmpsize: size a Windows-ish BitMaP image
#
# Adapted from code contributed by Aldo Calpini <a.calpini@romagiubileo.it>
sub bmpsize
{
    my ($stream) = shift;

    my ($x, $y, $id) = (undef, undef, "Unable to determine size of TIFF data");
    my ($buffer);

    $buffer = &$read_in($stream, 26);
    ($x, $y) = unpack("x18VV", $buffer);
    $id = 'BMP' if (defined $x and defined $y);

    ($x, $y, $id);
}

# psdsize: determine the size of a PhotoShop save-file (*.PSD)
sub psdsize
{
    my ($stream) = shift;

    my ($x, $y, $id) = (undef, undef, "Unable to determine size of PSD data");
    my ($buffer);

    $buffer = &$read_in($stream, 26);
    ($x, $y) = unpack("x14NN", $buffer);
    $id = 'PSD' if (defined $x and defined $y);

    ($x, $y, $id);
}

# swfsize: determine size of ShockWave/Flash files. Adapted from code sent by
# Dmitry Dorofeev <dima@yasp.com>
sub swfsize
{
    my ($image) = @_;
    my $header = &$read_in($image, 33);

    sub _bin2int { unpack("N", pack("B32", substr("0" x 32 . shift, -32))); }

    my $ver = _bin2int(unpack 'B8', substr($header, 3, 1));
    my $bs = unpack 'B133', substr($header, 8, 17);
    my $bits = _bin2int(substr($bs, 0, 5));
    my $x = int(_bin2int(substr($bs, 5+$bits, $bits))/20);
    my $y = int(_bin2int(substr($bs, 5+$bits*3, $bits))/20);

    return ($x, $y, 'SWF');
}

=head1 NAME

Image::Size - read the dimensions of an image in several popular formats

=head1 SYNOPSIS

    use Image::Size;
    # Get the size of globe.gif
    ($globe_x, $globe_y) = imgsize("globe.gif");
    # Assume X=60 and Y=40 for remaining examples

    use Image::Size 'html_imgsize';
    # Get the size as 'width="X" height="Y"' for HTML generation
    $size = html_imgsize("globe.gif");
    # $size == 'width="60" height="40"'

    use Image::Size 'attr_imgsize';
    # Get the size as a list passable to routines in CGI.pm
    @attrs = attr_imgsize("globe.gif");
    # @attrs == ('-width', 60, '-height', 40)

    use Image::Size;
    # Get the size of an in-memory buffer
    ($buf_x, $buf_y) = imgsize($buf);

=head1 DESCRIPTION

The B<Image::Size> library is based upon the C<wwwis> script written by
Alex Knowles I<(alex@ed.ac.uk)>, a tool to examine HTML and add 'width' and
'height' parameters to image tags. The sizes are cached internally based on
file name, so multiple calls on the same file name (such as images used
in bulleted lists, for example) do not result in repeated computations.

B<Image::Size> provides three interfaces for possible import:

=over

=item imgsize(I<stream>)

Returns a three-item list of the X and Y dimensions (width and height, in
that order) and image type of I<stream>. Errors are noted by undefined
(B<undef>) values for the first two elements, and an error string in the third.
The third element can be (and usually is) ignored, but is useful when
sizing data whose type is unknown.

=item html_imgsize(I<stream>)

Returns the width and height (X and Y) of I<stream> pre-formatted as a single
string C<'width="X" height="Y"'> suitable for addition into generated HTML IMG
tags. If the underlying call to C<imgsize> fails, B<undef> is returned. The
format returned should be dually suited to both HTML and XHTML.

=item attr_imgsize(I<stream>)

Returns the width and height of I<stream> as part of a 4-element list useful
for routines that use hash tables for the manipulation of named parameters,
such as the Tk or CGI libraries. A typical return value looks like
C<("-width", X, "-height", Y)>. If the underlying call to C<imgsize> fails,
B<undef> is returned.

=back

By default, only C<imgsize()> is imported. Any one or
combination of the three may be imported, or all three may be with the
tag B<:all>.

=head2 Input Types

The sort of data passed as I<stream> can be one of three forms:

=over

=item string

If an ordinary scalar (string) is passed, it is assumed to be a file name
(either absolute or relative to the current working directory of the
process) and is searched for and opened (if found) as the source of data.
Possible error messages (see DIAGNOSTICS below) may include file-access
problems.

=item scalar reference

If the passed-in stream is a scalar reference, it is interpreted as pointing
to an in-memory buffer containing the image data.

        # Assume that &read_data gets data somewhere (WWW, etc.)
        $img = &read_data;
        ($x, $y, $id) = imgsize(\$img);
        # $x and $y are dimensions, $id is the type of the image

=item Open file handle

The third option is to pass in an open filehandle (such as an object of
the C<IO::File> class, for example) that has already been associated with
the target image file. The file pointer will necessarily move, but will be
restored to its original position before subroutine end.

        # $fh was passed in, is IO::File reference:
        ($x, $y, $id) = imgsize($fh);
        # Same as calling with filename, but more abstract.

=back

=head2 Recognizd Formats

Image::Size understands and sizes data in the following formats:

=over 4

=item GIF

=item JPG

=item XBM

=item XPM

=item PPM family (PPM/PGM/PBM)

=item PNG

=item TIF

=item BMP

=item PSD (Adobe PhotoShop)

=item SWF (ShockWave/Flash)

=back

When using the C<imgsize> interface, there is a third, unused value returned
if the programmer wishes to save and examine it. This value is the three-
letter identity of the data type. This is useful when operating on open
file handles or in-memory data, where the type is as unknown as the size.
The two support routines ignore this third return value, so those wishing to
use it must use the base C<imgsize> routine.

=head1 DIAGNOSTICS

The base routine, C<imgsize>, returns B<undef> as the first value in its list
when an error has occured. The third element contains a descriptive
error message.

The other two routines simply return B<undef> in the case of error.

=head1 MORE EXAMPLES

The B<attr_imgsize> interface is also well-suited to use with the Tk
extension:

    $image = $widget->Photo(-file => $img_path, attr_imgsize($img_path));

Since the C<Tk::Image> classes use dashed option names as C<CGI> does, no
further translation is needed.

This package is also well-suited for use within an Apache web server context.
File sizes are cached upon read (with a check against the modified time of
the file, in case of changes), a useful feature for a B<mod_perl> environment
in which a child process endures beyond the lifetime of a single request.
Other aspects of the B<mod_perl> environment cooperate nicely with this
module, such as the ability to use a sub-request to fetch the full pathname
for a file within the server space. This complements the HTML generation
capabilities of the B<CGI> module, in which C<CGI::img> wants a URL but
C<attr_imgsize> needs a file path:

    # Assume $Q is an object of class CGI, $r is an Apache request object.
    # $imgpath is a URL for something like "/img/redball.gif".
    $r->print($Q->img({ -src => $imgpath,
                        attr_imgsize($r->lookup_uri($imgpath)->filename) }));

The advantage here, besides not having to hard-code the server document root,
is that Apache passes the sub-request through the usual request lifecycle,
including any stages that would re-write the URL or otherwise modify it.

=head1 CAVEATS

Caching of size data can only be done on inputs that are file names. Open
file handles and scalar references cannot be reliably transformed into a
unique key for the table of cache data. Buffers could be cached using the
MD5 module, and perhaps in the future I will make that an option. I do not,
however, wish to lengthen the dependancy list by another item at this time.

=head1 SEE ALSO

C<http://www.tardis.ed.ac.uk/~ark/wwwis/> for a description of C<wwwis>
and how to obtain it.

=head1 AUTHORS

Perl module interface by Randy J. Ray I<(rjray@tsoft.com)>, original
image-sizing code by Alex Knowles I<(alex@ed.ac.uk)> and Andrew Tong
I<(werdna@ugcs.caltech.edu)>, used with their joint permission.

Some bug fixes submitted by Bernd Leibing I<(bernd.leibing@rz.uni-ulm.de)>.
PPM/PGM/PBM sizing code contributed by Carsten Dominik
I<(dominik@strw.LeidenUniv.nl)>. Tom Metro I<(tmetro@vl.com)> re-wrote the JPG
and PNG code, and also provided a PNG image for the test suite. Dan Klein
I<(dvk@lonewolf.com)> contributed a re-write of the GIF code.  Cloyce Spradling
I<(cloyce@headgear.org)> contributed TIFF sizing code and test images. Aldo
Calpini I<(a.calpini@romagiubileo.it)> suggested support of BMP images (which
I I<really> should have already thought of :-) and provided code to work
with. A patch to allow html_imgsize to produce valid output for XHTML, as
well as some documentation fixes was provided by Charles Levert
I<(charles@comm.polymtl.ca)>. The ShockWave/Flash support was provided by
Dmitry Dorofeev I<(dima@yasp.com)>.

=cut
