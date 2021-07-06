###############################################################################
#
# This file copyright (c) 2015 by Randy J. Ray, all rights reserved
#
# Copying and distribution are permitted under the terms of the Artistic
# License 2.0 (http://www.opensource.org/licenses/artistic-license-2.0.php) or
# the GNU LGPL (http://www.opensource.org/licenses/lgpl-2.1.php).
#
###############################################################################
#
# Once upon a time, this code was lifted almost verbatim from wwwis by Alex
# Knowles, alex@ed.ac.uk. Since then, even I barely recognize it. It has
# contributions, fixes, additions and enhancements from all over the world.
#
# See the file ChangeLog for change history.
#
###############################################################################

package Image::Size;

require 5.006001;

# These are the Perl::Critic policies that are being turned off globally:
## no critic(RequireBriefOpen)
## no critic(ProhibitAutomaticExportation)

use strict;
use warnings;
use bytes;
use vars qw(
    @EXPORT @EXPORT_OK %EXPORT_TAGS $VERSION $NO_CACHE %CACHE
    $GIF_BEHAVIOR @TYPE_MAP %PCD_MAP $PCD_SCALE $READ_IN $LAST_POS
);

use Exporter 'import';

BEGIN
{
    @EXPORT      = qw(imgsize);
    @EXPORT_OK   = qw(imgsize html_imgsize attr_imgsize
                      %CACHE $NO_CACHE $PCD_SCALE $GIF_BEHAVIOR);
    %EXPORT_TAGS = ('all' => [ @EXPORT_OK ]);

    $VERSION = '3.300';
    $VERSION = eval $VERSION; ## no critic(ProhibitStringyEval)

    # Default behavior for GIFs is to return the "screen" size
    $GIF_BEHAVIOR = 0;
}

# This allows people to specifically request that the cache not be used
$NO_CACHE = 0;

# Package lexicals - invisible to outside world, used only in imgsize
#
# Mapping of patterns to the sizing routines
@TYPE_MAP = (
    qr{^GIF8[79]a}               => \&gifsize,
    qr{^\xFF\xD8}                => \&jpegsize,
    qr{^\x89PNG\x0d\x0a\x1a\x0a} => \&pngsize,
    qr{^P[1-7]}                  => \&ppmsize, # also XVpics
    qr{#define\s+\S+\s+\d+}      => \&xbmsize,
    qr{/[*] XPM [*]/}            => \&xpmsize,
    qr{^MM\x00\x2a}              => \&tiffsize,
    qr{^II\x2a\x00}              => \&tiffsize,
    qr{^BM}                      => \&bmpsize,
    qr{^8BPS}                    => \&psdsize,
    qr{^PCD_OPA}                 => \&pcdsize,
    qr{^FWS}                     => \&swfsize,
    qr{^CWS}                     => \&swfmxsize,
    qr{^\x8aMNG\x0d\x0a\x1a\x0a} => \&mngsize,
    qr{^\x01\x00\x00\x00}        => \&emfsize,
    qr{^RIFF(?s:....)WEBP}       => \&webpsize,
    qr{^\x00\x00\x01\x00}        => \&icosize,
    qr{^\x00\x00\x02\x00}        => \&cursize,
);
# Kodak photo-CDs are weird. Don't ask me why, you really don't want details.
%PCD_MAP = ( 'base/16' => [ 192,  128  ],
             'base/4'  => [ 384,  256  ],
             'base'    => [ 768,  512  ],
             'base4'   => [ 1536, 1024 ],
             'base16'  => [ 3072, 2048 ],
             'base64'  => [ 6144, 4096 ], );
# Default scale for PCD images
$PCD_SCALE = 'base';

# These are lexically-scoped anonymous subroutines for reading the three
# types of input streams. When the input to imgsize() is typed, then the
# lexical "read_in" is assigned one of these, thus allowing the individual
# routines to operate on these streams abstractly.

my $read_io = sub {
    my $handle = shift;
    my ($length, $offset) = @_;

    if (defined($offset) && ($offset != $LAST_POS))
    {
        $LAST_POS = $offset;
        return q{} if (! seek $handle, $offset, 0);
    }

    my ($buffer, $rtn) = (q{}, 0);
    $rtn = read $handle, $buffer, $length;
    if (! $rtn)
    {
        $buffer = q{};
    }
    $LAST_POS = tell $handle;

    return $buffer;
};

my $read_buf = sub {
    my $buf = shift;
    my ($length, $offset) = @_;

    if (defined($offset) && ($offset != $LAST_POS))
    {
        $LAST_POS = $offset;
        return q{} if ($LAST_POS > length ${$buf});
    }

    my $content = substr ${$buf}, $LAST_POS, $length;
    $LAST_POS += length $content;

    return $content;
};

sub imgsize ## no critic(ProhibitExcessComplexity)
{
    my $stream = shift;

    my ($handle, $header);
    my ($x, $y, $id, $mtime, @list);
    # These only used if $stream is an existing open FH
    my ($save_pos, $need_restore) = (0, 0);
    # This is for when $stream is a locally-opened file
    my $need_close = 0;
    # This will contain the file name, if we got one
    my $file_name = undef;

    $header = q{};

    if (ref($stream) eq 'SCALAR')
    {
        $handle = $stream;
        $READ_IN = $read_buf;
        $header = substr ${$handle} || q{}, 0, 256;
    }
    elsif (ref $stream)
    {
        # I no longer require $stream to be in the IO::* space. So I'm assuming
        # you don't hose yourself by passing a ref that can't do fileops. If
        # you do, you fix it.
        $handle = $stream;
        $READ_IN = $read_io;
        $save_pos = tell $handle;
        $need_restore = 1;

        # First alteration (didn't wait long, did I?) to the existing handle:
        #
        # assist dain-bramaged operating systems -- SWD
        # SWD: I'm a bit uncomfortable with changing the mode on a file
        # that something else "owns" ... the change is global, and there
        # is no way to reverse it.
        # But image files ought to be handled as binary anyway.
        binmode $handle;
        seek $handle, 0, 0;
        read $handle, $header, 256;
        seek $handle, 0, 0;
    }
    else
    {
        if (! $NO_CACHE)
        {
            require Cwd;
            require File::Spec;

            if (! File::Spec->file_name_is_absolute($stream))
            {
                $stream = File::Spec->catfile(Cwd::cwd(), $stream);
            }
            $mtime = (stat $stream)[9];
            if (-e "$stream" and exists $CACHE{$stream})
            {
                @list = split /,/, $CACHE{$stream}, 4;

                # Don't return the cache if the file is newer.
                if ($mtime <= $list[0])
                {
                    return @list[1 .. 3];
                }
                # In fact, clear it
                delete $CACHE{$stream};
            }
        }

        # first try to open the stream
        require Symbol;
        $handle = Symbol::gensym();
        if (! open $handle, '<', $stream)
        {
            return (undef, undef, "Can't open image file $stream: $!");
        }

        $need_close = 1;
        # assist dain-bramaged operating systems -- SWD
        binmode $handle;
        read $handle, $header, 256;
        seek $handle, 0, 0;
        $READ_IN = $read_io;
        $file_name = $stream;
    }
    $LAST_POS = 0;

    # Right now, $x, $y and $id are undef. If the while-loop below doesn't
    # match the header to a file-type and call a subroutine, then the later
    # block that tried Image::Magick will default to setting the id/error to
    # "unknown file type".
    my $tm_idx = 0;
    while ($tm_idx < @TYPE_MAP)
    {
        if ($header =~ $TYPE_MAP[$tm_idx])
        {
            ($x, $y, $id) = $TYPE_MAP[$tm_idx + 1]->($handle);
            last;
        }
        $tm_idx += 2;
    }

    # Added as an afterthought: I'm probably not the only one who uses the
    # same shaded-sphere image for several items on a bulleted list:
    if (! ($NO_CACHE or (ref $stream) or (! defined $x)))
    {
        $CACHE{$stream} = join q{,}, $mtime, $x, $y, $id;
    }

    # If we were passed an existing file handle, we need to restore the
    # old filepos:
    if ($need_restore)
    {
        seek $handle, $save_pos, 0;
    }
    # ...and if we opened the file ourselves, we need to close it
    if ($need_close)
    {
        close $handle; ## no critic(RequireCheckedClose)
    }

    if (! defined $id)
    {
        if ($file_name)
        {
            # Image::Magick operates on file names.
            ($x, $y, $id) = imagemagick_size($file_name);
        }
        else
        {
            $id = 'Data stream is not a known image file format';
        }
    }

    # results:
    return (wantarray) ? ($x, $y, $id) : ();
}

sub imagemagick_size
{
    my $file_name = shift;

    my $module_name;
    # First see if we have already loaded Graphics::Magick or Image::Magick
    # If so, just use whichever one is already loaded.
    if (exists $INC{'Graphics/Magick.pm'})
    {
        $module_name = 'Graphics::Magick';
    }
    elsif (exists $INC{'Image/Magick.pm'})
    {
        $module_name = 'Image::Magick';
    }
    # If neither are already loaded, try loading either one.
    elsif (_load_magick_module('Graphics::Magick'))
    {
       $module_name = 'Graphics::Magick';
    }
    elsif (_load_magick_module('Image::Magick'))
    {
       $module_name = 'Image::Magick';
    }

    if ($module_name)
    {
        my $img = $module_name->new();
        my $x = $img->Read($file_name);
        # Image::Magick error handling is a bit weird, see
        # <http://www.simplesystems.org/ImageMagick/www/perl.html#erro>
        if("$x") {
            return (undef, undef, "$x");
        } else {
            return ($img->Get('width', 'height', 'format'));
        }

    }
    else {
        return (undef, undef, 'Data stream is not a known image file format');
    }
}

# load Graphics::Magick or Image::Magick if one is not already loaded.
sub _load_magick_module {
    my $module_name = shift;
    my $retval = eval {
        local $SIG{__DIE__} = q{};
        require $module_name;
        1;
    };
    return $retval ? 1 : 0;
}


sub html_imgsize
{
    my @args = @_;
    @args = imgsize(@args);

    # Use lowercase and quotes so that it works with xhtml.
    return ((defined $args[0]) ?
            sprintf('width="%d" height="%d"', @args[0,1]) :
            undef);
}

sub attr_imgsize
{
    my @args = @_;
    @args = imgsize(@args);

    return ((defined $args[0]) ?
            (('-width', '-height', @args)[0, 2, 1, 3]) :
            undef);
}

# This used only in gifsize:
sub img_eof
{
    my $stream = shift;

    if (ref($stream) eq 'SCALAR')
    {
        return ($LAST_POS >= length ${$stream});
    }

    return eof $stream;
}

# Simple converter-routine used by SWF and CWS code
sub _bin2int
{
    my $val = shift;
    # "no critic" because I want it clear which args are being used by
    # substr() versus unpack().
    ## no critic (ProhibitParensWithBuiltins)
    return unpack 'N', pack 'B32', substr(('0' x 32) . $val, -32);
}

###########################################################################
# Subroutine gets the size of the specified GIF
###########################################################################
sub gifsize ## no critic(ProhibitExcessComplexity)
{
    my $stream = shift;

    my ($cmapsize, $buf, $sh, $sw, $x, $y, $type);

    my $gif_blockskip = sub {
        my ($skip, $blocktype) = @_;
        my ($lbuf);

        $READ_IN->($stream, $skip);        # Skip header (if any)
        while (1)
        {
            if (img_eof($stream))
            {
                return (undef, undef,
                        "Invalid/Corrupted GIF (at EOF in GIF $blocktype)");
            }
            $lbuf = $READ_IN->($stream, 1);  # Block size
            last if ord($lbuf) == 0;         # Block terminator
            $READ_IN->($stream, ord $lbuf);  # Skip data
        }
    };

    if ($GIF_BEHAVIOR > 2)
    {
        return (undef, undef,
                "\$Image::Size::GIF_BEHAVIOR out of range: $GIF_BEHAVIOR");
    }

    # Skip over the identifying string, since we already know this is a GIF
    $type = $READ_IN->($stream, 6);
    if (length($buf = $READ_IN->($stream, 7)) != 7 )
    {
        return (undef, undef, 'Invalid/Corrupted GIF (bad header)');
    }
    ($sw, $sh, $x) = unpack 'vv C', $buf;
    if ($GIF_BEHAVIOR == 0)
    {
        return ($sw, $sh, 'GIF');
    }

    if ($x & 0x80)
    {
        $cmapsize = 3 * (2**(($x & 0x07) + 1));
        if (! $READ_IN->($stream, $cmapsize))
        {
            return (undef, undef,
                    'Invalid/Corrupted GIF (global color map too small?)');
        }
    }

    # Before we start this loop, set $sw and $sh to 0s and use them to track
    # the largest sub-image in the overall GIF.
    $sw = $sh = 0;

  FINDIMAGE:
    while (1)
    {
        if (img_eof($stream))
        {
            # At this point, if we haven't returned then the user wants the
            # largest of the sub-images. So, if $sh and $sw are still 0s, then
            # we didn't see even one Image Descriptor block. Otherwise, return
            # those two values.
            if ($sw and $sh)
            {
                return ($sw, $sh, 'GIF');
            }
            else
            {
                return (undef, undef,
                        'Invalid/Corrupted GIF (no Image Descriptors)');
            }
        }
        $buf = $READ_IN->($stream, 1);
        ($x) = unpack 'C', $buf;
        if ($x == 0x2c)
        {
            # Image Descriptor (GIF87a, GIF89a 20.c.i)
            if (length($buf = $READ_IN->($stream, 8)) != 8)
            {
                return (undef, undef,
                        'Invalid/Corrupted GIF (missing image header?)');
            }
            ($x, $y) = unpack 'x4 vv', $buf;
            return ($x, $y, 'GIF') if ($GIF_BEHAVIOR == 1);
            if ($x > $sw and $y > $sh)
            {
                $sw = $x;
                $sh = $y;
            }
        }
        if ($x == 0x21)
        {
            # Extension Introducer (GIF89a 23.c.i, could also be in GIF87a)
            $buf = $READ_IN->($stream, 1);
            ($x) = unpack 'C', $buf;
            if ($x == 0xF9)
            {
                # Graphic Control Extension (GIF89a 23.c.ii)
                $READ_IN->($stream, 6);    # Skip it
                next FINDIMAGE;       # Look again for Image Descriptor
            }
            elsif ($x == 0xFE)
            {
                # Comment Extension (GIF89a 24.c.ii)
                $gif_blockskip->(0, 'Comment');
                next FINDIMAGE;       # Look again for Image Descriptor
            }
            elsif ($x == 0x01)
            {
                # Plain Text Label (GIF89a 25.c.ii)
                $gif_blockskip->(13, 'text data');
                next FINDIMAGE;       # Look again for Image Descriptor
            }
            elsif ($x == 0xFF)
            {
                # Application Extension Label (GIF89a 26.c.ii)
                $gif_blockskip->(12, 'application data');
                next FINDIMAGE;       # Look again for Image Descriptor
            }
            else
            {
                return (undef, undef,
                        sprintf 'Invalid/Corrupted GIF (Unknown ' .
                                'extension %#x)', $x);
            }
        }
        else
        {
            return (undef, undef,
                    sprintf 'Invalid/Corrupted GIF (Unknown code %#x)', $x);
        }
    }

    return (undef, undef, 'gifsize fell through to the end, error');
}

sub xbmsize
{
    my $stream = shift;

    my $input;
    my ($x, $y, $id) = (undef, undef, 'Could not determine XBM size');

    $input = $READ_IN->($stream, 1024);
    if ($input =~ /^\#define\s*\S*\s*(\d+)\s*\n\#define\s*\S*\s*(\d+)/ix)
    {
        ($x, $y) = ($1, $2);
        $id = 'XBM';
    }

    return ($x, $y, $id);
}

# Added by Randy J. Ray, 30 Jul 1996
# Size an XPM file by looking for the "X Y N W" line, where X and Y are
# dimensions, N is the total number of colors defined, and W is the width of
# a color in the ASCII representation, in characters. We only care about X & Y.
sub xpmsize
{
    my $stream = shift;

    my $line;
    my ($x, $y, $id) = (undef, undef, 'Could not determine XPM size');

    while ($line = $READ_IN->($stream, 1024))
    {
        if ($line =~ /"\s*(\d+)\s+(\d+)(\s+\d+\s+\d+){1,2}\s*"/)
        {
            ($x, $y) = ($1, $2);
            $id = 'XPM';
            last;
        }
    }

    return ($x, $y, $id);
}

# pngsize : gets the width & height (in pixels) of a png file
# cor this program is on the cutting edge of technology! (pity it's blunt!)
#
# Re-written and tested by tmetro@vl.com
sub pngsize
{
    my $stream = shift;

    my ($x, $y, $id) = (undef, undef, 'Could not determine PNG size');
    my ($offset, $length);

    # Offset to first Chunk Type code = 8-byte ident + 4-byte chunk length + 1
    $offset = 12; $length = 4;
    if ($READ_IN->($stream, $length, $offset) eq 'IHDR')
    {
        # IHDR = Image Header
        $length = 8;
        ($x, $y) = unpack 'NN', $READ_IN->($stream, $length);
        $id = 'PNG';
    }

    return ($x, $y, $id);
}

# mngsize: gets the width and height (in pixels) of an MNG file.
# See <URL:http://www.libpng.org/pub/mng/spec/> for the specification.
#
# Basically a copy of pngsize.
sub mngsize
{
    my $stream = shift;

    my ($x, $y, $id) = (undef, undef, 'Could not determine MNG size');
    my ($offset, $length);

    # Offset to first Chunk Type code = 8-byte ident + 4-byte chunk length + 1
    $offset = 12; $length = 4;
    if ($READ_IN->($stream, $length, $offset) eq 'MHDR')
    {
        # MHDR = Image Header
        $length = 8;
        ($x, $y) = unpack 'NN', $READ_IN->($stream, $length);
        $id = 'MNG';
    }

    return ($x, $y, $id);
}

# jpegsize: gets the width and height (in pixels) of a jpeg file
# Andrew Tong, werdna@ugcs.caltech.edu           February 14, 1995
# modified slightly by alex@ed.ac.uk
# and further still by rjray@blackperl.com
# optimization and general re-write from tmetro@vl.com
sub jpegsize
{
    my $stream = shift;

    my $MARKER     = chr 0xff; # Section marker

    my $SIZE_FIRST = 0xC0;   # Range of segment identifier codes
    my $SIZE_LAST  = 0xC3;   #  that hold size info.

    my ($x, $y, $id) = (undef, undef, 'Could not determine JPEG size');

    my ($marker, $code, $length);
    my $segheader;

    # Dummy read to skip header ID
    $READ_IN->($stream, 2);
    while (1)
    {
        $segheader = $READ_IN->($stream, 2);

        # Extract the segment header.
        ($marker, $code) = unpack 'a a', $segheader;

        while ( $code eq $MARKER && ($marker = $code) ) {
            $segheader = $READ_IN->($stream, 1);
            ($code) = unpack 'a', $segheader;
        }
        $segheader = $READ_IN->($stream, 2);
        $length = unpack 'n', $segheader;

        # Verify that it's a valid segment.
        if ($marker ne $MARKER)
        {
            # Was it there?
            $id = 'JPEG marker not found';
            last;
        }
        elsif ((ord($code) >= $SIZE_FIRST) && (ord($code) <= $SIZE_LAST))
        {
            # Segments that contain size info
            $length = 5;
            my $buf = $READ_IN->($stream, $length);
            # unpack dies on truncated data
            last if (length($buf) < $length);
            ($y, $x) = unpack 'xnn', $buf;
            $id = 'JPG';
            last;
        }
        else
        {
            # Dummy read to skip over data
            $READ_IN->($stream, ($length - 2));
        }
    }

    return ($x, $y, $id);
}

# ppmsize: gets data on the PPM/PGM/PBM family.
#
# Contributed by Carsten Dominik <dominik@strw.LeidenUniv.nl>
sub ppmsize
{
    my $stream = shift;

    my ($x, $y, $id) =
        (undef, undef, 'Unable to determine size of PPM/PGM/PBM data');
    my $n;
    my @table = qw(nil PBM PGM PPM PBM PGM PPM);

    my $header = $READ_IN->($stream, 1024);

    # PPM file of some sort
    $header =~ s/^\#.*//mg;
    if ($header =~ /^(?:P([1-7]))\s+(\d+)\s+(\d+)/)
    {
        ($n, $x, $y) = ($1, $2, $3);

        if ($n == 7)
        {
            # John Bradley's XV thumbnail pics (from inwap@jomis.Tymnet.COM)
            $id = 'XV';
            ($x, $y) = ($header =~ /IMGINFO:(\d+)x(\d+)/s);
        }
        else
        {
            $id = $table[$n];
        }
    }

    return ($x, $y, $id);
}

# tiffsize: size a TIFF image
#
# Contributed by Cloyce Spradling <cloyce@headgear.org>
sub tiffsize
{
    my $stream = shift;

    my ($x, $y, $id) = (undef, undef, 'Unable to determine size of TIFF data');

    my $endian = 'n';           # Default to big-endian; I like it better
    my $header = $READ_IN->($stream, 4);
    if ($header =~ /II\x2a\x00/o)
    {
        # little-endian
        $endian = 'v';
    }

    # Set up an association between data types and their corresponding
    # pack/unpack specification.  Don't take any special pains to deal with
    # signed numbers; treat them as unsigned because none of the image
    # dimensions should ever be negative. (I hope.)
    my @packspec = ( undef,      # nothing (shouldn't happen)
                     'C',        # BYTE (8-bit unsigned integer)
                     undef,      # ASCII
                     $endian,    # SHORT (16-bit unsigned integer)
                     uc $endian, # LONG (32-bit unsigned integer)
                     undef,      # RATIONAL
                     'c',        # SBYTE (8-bit signed integer)
                     undef,      # UNDEFINED
                     $endian,    # SSHORT (16-bit unsigned integer)
                     uc $endian, # SLONG (32-bit unsigned integer)
                     );

    my $offset = $READ_IN->($stream, 4, 4); # Get offset to IFD
    $offset = unpack uc $endian, $offset; # Fix it so we can use it

    my $ifd = $READ_IN->($stream, 2, $offset); # Get num. of directory entries
    my $num_dirent = unpack $endian, $ifd; # Make it useful
    $offset += 2;
    $num_dirent = $offset + ($num_dirent * 12); # Calc. maximum offset of IFD

    # Do all the work
    $ifd = q{};
    my $tag = 0;
    my $type = 0;
    while ((! defined $x) || (! defined$y)) {
        $ifd = $READ_IN->($stream, 12, $offset);   # Get first directory entry
        last if (($ifd eq q{}) || ($offset > $num_dirent));
        $offset += 12;
        $tag = unpack $endian, $ifd;               # ...and decode its tag
        $type = unpack $endian, substr $ifd, 2, 2; # ...and the data type
        # Check the type for sanity.
        next if (($type > @packspec+0) || (! defined $packspec[$type]));
        if ($tag == 0x0100)    # ImageWidth (x)
        {
            # Decode the value
            $x = unpack $packspec[$type], substr $ifd, 8, 4;
        }
        elsif ($tag == 0x0101) # ImageLength (y)
        {
            # Decode the value
            $y = unpack $packspec[$type], substr $ifd, 8, 4;
        }
    }

    # Decide if we were successful or not
    if (defined $x and defined $y)
    {
        $id = 'TIF';
    }
    else
    {
        $id = q{};
        if (! defined $x)
        {
            $id = 'ImageWidth ';
        }
        if (! defined $y)
        {
            if ($id ne q{})
            {
                $id .= 'and ';
            }
            $id .= 'ImageLength ';
        }
        $id .= 'tag(s) could not be found';
    }

    return ($x, $y, $id);
}

# bmpsize: size a Windows-ish BitMaP image
#
# Adapted from code contributed by Aldo Calpini <a.calpini@romagiubileo.it>
sub bmpsize
{
    my $stream = shift;

    my ($x, $y, $id) = (undef, undef, 'Unable to determine size of BMP data');
    my $buffer;

    $buffer = $READ_IN->($stream, 26);
    my $header_size = unpack 'x14V', $buffer;
    if ($header_size == 12)
    {
        ($x, $y) = unpack 'x18vv', $buffer;     # old OS/2 header
    }
    else
    {
        ($x, $y) = unpack 'x18VV', $buffer;     # modern Windows header
    }
    if (defined $x and defined $y)
    {
        $id = 'BMP';
    }

    return ($x, $y, $id);
}

# psdsize: determine the size of a PhotoShop save-file (*.PSD)
sub psdsize
{
    my $stream = shift;

    my ($x, $y, $id) = (undef, undef, 'Unable to determine size of PSD data');
    my $buffer;

    $buffer = $READ_IN->($stream, 26);
    ($y, $x) = unpack 'x14NN', $buffer;
    if (defined $x and defined $y)
    {
        $id = 'PSD';
    }

    return ($x, $y, $id);
}

# swfsize: determine size of ShockWave/Flash files. Adapted from code sent by
# Dmitry Dorofeev <dima@yasp.com>
sub swfsize
{
    my $image  = shift;
    my $header = $READ_IN->($image, 33);

    my $ver = _bin2int(unpack 'B8', substr $header, 3, 1);
    my $bs = unpack 'B133', substr $header, 8, 17;
    my $bits = _bin2int(substr $bs, 0, 5);
    my $x = int _bin2int(substr $bs, 5+$bits, $bits)/20;
    my $y = int _bin2int(substr $bs, 5+$bits*3, $bits)/20;

    return ($x, $y, 'SWF');
}

# Suggested by Matt Mueller <mueller@wetafx.co.nz>, and based on a piece of
# sample Perl code by a currently-unknown author. Credit will be placed here
# once the name is determined.
sub pcdsize
{
    my $stream = shift;

    my ($x, $y, $id) = (undef, undef, 'Unable to determine size of PCD data');
    my $buffer = $READ_IN->($stream, 0xf00);

    # Second-tier sanity check
    if (substr($buffer, 0x800, 3) ne 'PCD')
    {
        return ($x, $y, $id);
    }

    my $orient = ord(substr $buffer, 0x0e02, 1) & 1; # Clear down to one bit
    ($x, $y) = @{$Image::Size::PCD_MAP{lc $Image::Size::PCD_SCALE}}
        [($orient ? (0, 1) : (1, 0))];

    return ($x, $y, 'PCD');
}

# swfmxsize: determine size of compressed ShockWave/Flash MX files. Adapted
# from code sent by Victor Kuriashkin <victor@yasp.com>
sub swfmxsize
{
    my $image = shift;

    my $retval = eval {
        local $SIG{__DIE__} = q{};
        require Compress::Zlib;
        1;
    };
    if (! $retval)
    {
        return (undef, undef, "Error loading Compress::Zlib: $@");
    }

    my $header = $READ_IN->($image, 1058);
    my $ver = _bin2int(unpack 'B8', substr $header, 3, 1);

    my ($d, $status) = Compress::Zlib::inflateInit();
    $header = substr $header, 8, 1024;
    $header = $d->inflate($header);

    my $bs = unpack 'B133', substr $header, 0, 17;
    my $bits = _bin2int(substr $bs, 0, 5);
    my $x = int _bin2int(substr $bs, 5+$bits, $bits)/20;
    my $y = int _bin2int(substr $bs, 5+$bits*3, $bits)/20;

    return ($x, $y, 'CWS');
}

# Windows EMF files, requested by Jan v/d Zee
sub emfsize
{
    my $image = shift;

    my ($x, $y);
    my $buffer = $READ_IN->($image, 24);

    my ($topleft_x, $topleft_y, $bottomright_x, $bottomright_y) =
        unpack 'x8V4', $buffer;

    # The four values describe a box *around* the image, not *of* the image.
    # In other words, the dimensions are not inclusive.
    $x = $bottomright_x - $topleft_x - 1;
    $y = $bottomright_y - $topleft_y - 1;

    return ($x, $y, 'EMF');
}

# WEBP files, see https://developers.google.com/speed/webp/docs/riff_container
# Added by Baldur Kristinsson, github.com/bk
sub webpsize {
    my $img = shift;

    # There are 26 bytes of lead-in, before the width and height info:
    # 1. WEBP container
    #    - 'RIFF', 4 bytes
    #    - filesize, 4 bytes
    #    - 'WEBP', 4 bytes
    # 2. VP8 frame
    #    - 'VP8', 3 bytes
    #    - frame meta, 8 bytes
    #    - marker, 3 bytes
    my $buf = $READ_IN->($img, 4, 26);
    my ($raw_w, $raw_h) = unpack 'SS', $buf;
    my $b14 = 2**14 - 1;

    # The width and height values contain a 2-bit scaling factor,
    # which is left-shifted by 14 bits. We ignore this, since it seems
    # not to be relevant for our purposes. WEBP images in actual use
    # all seem to have a scaling factor of 0, anyway. (The meaning
    # of the scaling factor is as follows: 0=no upscale, 1=upscale by 5/4,
    # 2=upscale by 5/3, 3=upscale by 2).
    #
    # my $wscale = $raw_w >> 14;
    # my $hscale = $raw_h >> 14;
    my $x = $raw_w & $b14;
    my $y = $raw_h & $b14;

    return ($x, $y, 'WEBP');
}

# ICO files, originally contributed by Thomas Walloschke <thw@cpan.org>,
# see https://rt.cpan.org/Public/Bug/Display.html?id=46279
# (revised by Baldur Kristinsson, github.com/bk)
sub icosize {
    my $img = shift;
    my ($x, $y) = unpack 'CC', $READ_IN->($img, 2, 6);
    if ($x == 0) { $x = 256; }
    if ($y == 0) { $y = 256; }
    return ($x, $y, 'ICO');
}

# CUR files, originally contributed by Thomas Walloschke <thw@cpan.org>,
# see https://rt.cpan.org/Public/Bug/Display.html?id=46279
# (revised by Baldur Kristinsson, github.com/bk)
sub cursize {
    my ($x, $y, $ico) = icosize(shift);
    return ($x, $y, 'CUR');
}


1;

__END__

=encoding utf8

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
    ($buf_x, $buf_y) = imgsize(\$buf);
    # Assuming that $buf was the data, imgsize() needed a
    $ reference to a scalar

=head1 DESCRIPTION

The B<Image::Size> library is based upon the C<wwwis> script written by
Alex Knowles I<(alex@ed.ac.uk)>, a tool to examine HTML and add 'width' and
'height' parameters to image tags. The sizes are cached internally based on
file name, so multiple calls on the same file name (such as images used
in bulleted lists, for example) do not result in repeated computations.

=head1 SUBROUTINES/METHODS

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
format returned is dually suited to both HTML and XHTML.

=item attr_imgsize(I<stream>)

Returns the width and height of I<stream> as part of a 4-element list useful
for routines that use hash tables for the manipulation of named parameters,
such as the Tk or CGI libraries. A typical return value looks like
C<("-width", X, "-height", Y)>. If the underlying call to C<imgsize> fails,
B<undef> is returned.

=back

By default, only C<imgsize()> is exported. Any one or combination of the three
may be explicitly imported, or all three may be with the tag B<:all>.

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

=head2 Recognized Formats

Image::Size natively understands and sizes data in the following formats:

=over 4

=item GIF

=item JPG

=item XBM

=item XPM

=item PPM family (PPM/PGM/PBM)

=item XV thumbnails

=item PNG

=item MNG

=item TIF

=item BMP

=item PSD (Adobe PhotoShop)

=item SWF (ShockWave/Flash)

=item CWS (FlashMX, compressed SWF, Flash 6)

=item PCD (Kodak PhotoCD, see notes below)

=item EMF (Windows Enhanced Metafile Format)

=item WEBP

=item ICO (Microsoft icon format)

=item CUR (Microsoft mouse cursor format)

=back

Additionally, if the B<Image::Magick> module is present, the file types
supported by it are also supported by Image::Size.  See also L<"CAVEATS">.

When using the C<imgsize> interface, there is a third, unused value returned
if the programmer wishes to save and examine it. This value is the identity of
the data type, expressed as a 2-3 letter abbreviation as listed above. This is
useful when operating on open file handles or in-memory data, where the type
is as unknown as the size.  The two support routines ignore this third return
value, so those wishing to use it must use the base C<imgsize> routine.

Note that when the B<Image::Magick> fallback is used (for all non-natively
supported files), the data type identity comes directly from the 'format'
parameter reported by B<Image::Magick>, so it may not meet the 2-3 letter
abbreviation format.  For example, a WBMP file might be reported as
'Wireless Bitmap (level 0) image' in this case.

=head2 Information Caching and C<$NO_CACHE>

When a filename is passed to any of the sizing routines, the default behavior
of the library is to cache the resulting information. The modification-time of
the file is also recorded, to determine whether the cache should be purged and
updated. This was originally added due to the fact that a number of CGI
applications were using this library to generate attributes for pages that
often used the same graphical element many times over.

However, the caching can lead to problems when the files are generated
dynamically, at a rate that exceeds the resolution of the modification-time
value on the filesystem. Thus, the optionally-importable control variable
C<$NO_CACHE> has been introduced. If this value is anything that evaluates to a
non-false value (be that the value 1, any non-null string, etc.) then the
cacheing is disabled until such time as the program re-enables it by setting
the value to false.

The parameter C<$NO_CACHE> may be imported as with the B<imgsize> routine, and
is also imported when using the import tag B<C<:all>>. If the programmer
chooses not to import it, it is still accessible by the fully-qualified package
name, B<$Image::Size::NO_CACHE>.

=head2 Sharing the Cache Between Processes

If you are using B<Image::Size> in a multi-thread or multi-process environment,
you may wish to enable sharing of the cached information between the
processes (or threads). Image::Size does not natively provide any facility
for this, as it would add to the list of dependencies.

To make it possible for users to do this themselves, the C<%CACHE> hash-table
that B<Image::Size> uses internally for storage may be imported in the B<use>
statement. The user may then make use of packages such as B<IPC::MMA>
(L<IPC::MMA|IPC::MMA>) that can C<tie> a hash to a shared-memory segment:

    use Image::Size qw(imgsize %CACHE);
    use IPC::MMA;

    ...

    tie %CACHE, 'IPC::MM::Hash', $mmHash; # $mmHash via mm_make_hash
    # Now, forked processes will share any changes made to the cache

=head2 Sizing PhotoCD Images

With version 2.95, support for the Kodak PhotoCD image format is
included. However, these image files are not quite like the others. One file
is the source of the image in any of a range of pre-set resolutions (all with
the same aspect ratio). Supporting this here is tricky, since there is nothing
inherent in the file to limit it to a specific resolution.

The library addresses this by using a scale mapping, and requiring the user
(you) to specify which scale is preferred for return. Like the C<$NO_CACHE>
setting described earlier, this is an importable scalar variable that may be
used within the application that uses B<Image::Size>. This parameter is called
C<$PCD_SCALE>, and is imported by the same name. It, too, is also imported
when using the tag B<C<:all>> or may be referenced as
B<$Image::Size::PCD_SCALE>.

The parameter should be set to one of the following values:

        base/16
        base/4
        base
        base4
        base16
        base64

Note that not all PhotoCD disks will have included the C<base64>
resolution. The actual resolutions are not listed here, as they are constant
and can be found in any documentation on the PCD format. The value of
C<$PCD_SCALE> is treated in a case-insensitive manner, so C<base> is the same
as C<Base> or C<BaSe>. The default scale is set to C<base>.

Also note that the library makes no effort to read enough of the PCD file to
verify that the requested resolution is available. The point of this library
is to read as little as necessary so as to operate efficiently. Thus, the only
real difference to be found is in whether the orientation of the image is
portrait or landscape. That is in fact all that the library extracts from the
image file.

=head2 Controlling Behavior with GIF Images

GIF images present a sort of unusual situation when it comes to reading size.
Because GIFs can be a series of sub-images to be played as an animated
sequence, what part does the user want to get the size for?

When dealing with GIF files, the user may control the behavior by setting the
global value B<$Image::Size::GIF_BEHAVIOR>. Like the PCD setting, this may
be imported when loading the library. Three values are recognized by the
GIF-handling code:

=over 4

=item Z<>0

This is the default value. When this value is chosen, the returned dimensions
are those of the "screen". The "screen" is the display area that the GIF
declares in the first data block of the file. No sub-images will be greater
than this in size; if they are, the specification dictates that they be
cropped to fit within the box.

This is also the fastest method for sizing the GIF, as it reads the least
amount of data from the image stream.

=item Z<>1

If this value is set, then the size of the first sub-image within the GIF is
returned. For plain (non-animated) GIF files, this would be the same as the
screen (though it doesn't have to be, strictly-speaking).

When the first image descriptor block is read, the code immediately returns,
making this only slightly-less efficient than the previous setting.

=item Z<>2

If this value is chosen, then the code loops through all the sub-images of the
animated GIF, and returns the dimensions of the largest of them.

This option requires that the full GIF image be read, in order to ensure that
the largest is found.

=back

Any value outside this range will produce an error in the GIF code before any
image data is read.

The value of dimensions other than the view-port ("screen") is dubious.
However, some users have asked for that functionality.

=head1 Image::Size AND WEBSERVERS

There are a few approaches to getting the most out of B<Image::Size> in a
multi-process webserver environment. The two most common are pre-caching and
using shared memory. These examples are focused on Apache, but should be
adaptable to other server approaches as well.

=head2 Pre-Caching Image Data

One approach is to include code in an Apache start-up script that reads the
information on all images ahead of time. A script loaded via C<PerlRequire>,
for example, becomes part of the server memory before child processes are
created. When the children are created, they come into existence with a
pre-primed cache already available.

The shortcoming of this approach is that you have to plan ahead of time for
which image files you need to cache. Also, if the list is long-enough it
can slow server start-up time.

The advantage is that it keeps the information centralized in one place and
thus easier to manage and maintain. It also requires no additional CPAN
modules.

=head2 Shared Memory Caching

Another approach is to introduce a shared memory segment that the individual
processes all have access to. This can be done with any of a variety of
shared memory modules on CPAN.

Probably the easiest way to do this is to use one of the packages that allow
the tying of a hash to a shared memory segment. You can use this in
combination with importing the hash table variable that is used by
B<Image::Size> for the cache, or you can refer to it explicitly by full
package name:

    use IPC::Shareable;
    use Image::Size;

    tie %Image::Size::CACHE, 'IPC::Shareable', 'size', { create => 1 };

That example uses B<IPC::Shareable> (see L<IPC::Shareable|IPC::Shareable>) and
uses the option to the C<tie> command that tells B<IPC::Shareable> to create
the segment. Once the initial server process starts to create children, they
will all share the tied handle to the memory segment.

Another package that provides this capability is B<IPC::MMA> (see
L<IPC::MMA|IPC::MMA>), which provides shared memory management via the I<mm>
library from Ralf Engelschall (details available in the documentation for
B<IPC::MMA>):

    use IPC::MMA;
    use Image::Size qw(%CACHE);

    my $mm = mm_create(65536, '/tmp/test_lockfile');
    my $mmHash = mm_make_hash($mm);
    tie %CACHE, 'IPC::MM::Hash', $mmHash;

As before, this is done in the start-up phase of the webserver. As the
child processes are created, they inherit the pointer to the existing shared
segment.

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

=head1 DIAGNOSTICS

The base routine, C<imgsize>, returns B<undef> as the first value in its list
when an error has occurred. The third element contains a descriptive
error message.

The other two routines simply return B<undef> in the case of error.

=head1 CAVEATS

Caching of size data can only be done on inputs that are file names. Open
file handles and scalar references cannot be reliably transformed into a
unique key for the table of cache data. Buffers could be cached using the
MD5 module, and perhaps in the future I will make that an option. I do not,
however, wish to lengthen the dependency list by another item at this time.

As B<Image::Magick> operates on file names, not handles, the use of it is
restricted to cases where the input to C<imgsize> is provided as file name.

=head1 SEE ALSO

L<Image::Magick|Image::Magick> and L<Image::Info|Image::Info> Perl modules at
CPAN. The B<Graphics::Magick> Perl API at
L<http://www.graphicsmagick.org/perl.html>.

=head1 CONTRIBUTORS

Perl module interface by Randy J. Ray I<(rjray@blackperl.com)>, original
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
Dmitry Dorofeev I<(dima@yasp.com)>. Though I neglected to take note of who
supplied the PSD (PhotoShop) code, a bug was identified by Alex Weslowski
<aweslowski@rpinteractive.com>, who also provided a test image. PCD support
was adapted from a script made available by Phil Greenspun, as guided to my
attention by Matt Mueller I<mueller@wetafx.co.nz>. A thorough read of the
documentation and source by Philip Newton I<Philip.Newton@datenrevision.de>
found several typos and a small buglet. Ville Skytt� I<(ville.skytta@iki.fi)>
provided the MNG and the Image::Magick fallback code. Craig MacKenna
I<(mackenna@animalhead.com)> suggested making the cache available so that it
could be used with shared memory, and helped test my change before release.

=head1 BUGS

Please report any bugs or feature requests to
C<bug-image-size at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Image-Size>. I will be
notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Image-Size>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Image-Size>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Image-Size>

=item * Search CPAN

L<http://search.cpan.org/dist/Image-Size>

=item * Project page on GitHub

L<http://github.com/rjray/image-size>

=back

=head1 REPOSITORY

L<https://github.com/rjray/image-size>

=head1 LICENSE AND COPYRIGHT

This file and the code within are copyright (c) 1996-2009 by Randy J. Ray.

Copying and distribution are permitted under the terms of the Artistic
License 2.0 (L<http://www.opensource.org/licenses/artistic-license-2.0.php>) or
the GNU LGPL 2.1 (L<http://www.opensource.org/licenses/lgpl-2.1.php>).

=head1 AUTHOR

Randy J. Ray C<< <rjray@blackperl.com> >>

=cut
