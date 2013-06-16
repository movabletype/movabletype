#------------------------------------------------------------------------------
# File:         PanasonicRaw.pm
#
# Description:  Read/write Panasonic/Leica RAW/RW2/RWL meta information
#
# Revisions:    2009/03/24 - P. Harvey Created
#               2009/05/12 - PH Added RWL file type (same format as RW2)
#
# References:   1) CPAN forum post by 'hardloaf' (http://www.cpanforum.com/threads/2183)
#               2) http://www.cybercom.net/~dcoffin/dcraw/
#              JD) Jens Duttke private communication (TZ3,FZ30,FZ50)
#------------------------------------------------------------------------------

package Image::ExifTool::PanasonicRaw;

use strict;
use vars qw($VERSION);
use Image::ExifTool qw(:DataAccess :Utils);
use Image::ExifTool::Exif;

$VERSION = '1.02';

sub ProcessJpgFromRaw($$$);
sub WriteJpgFromRaw($$$);

my %jpgFromRawMap = (
    IFD1         => 'IFD0',
    EXIF         => 'IFD0', # to write EXIF as a block
    ExifIFD      => 'IFD0',
    GPS          => 'IFD0',
    SubIFD       => 'IFD0',
    GlobParamIFD => 'IFD0',
    PrintIM      => 'IFD0',
    InteropIFD   => 'ExifIFD',
    MakerNotes   => 'ExifIFD',
    IFD0         => 'APP1',
    MakerNotes   => 'ExifIFD',
    Comment      => 'COM',
);

# Tags found in Panasonic RAW/RW2/RWL images (ref PH)
%Image::ExifTool::PanasonicRaw::Main = (
    GROUPS => { 0 => 'EXIF', 1 => 'IFD0', 2 => 'Image'},
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    WRITE_GROUP => 'IFD0',   # default write group
    NOTES => 'These tags are found in IFD0 of Panasonic/Leica RAW, RW2 and RWL images.',
    0x01 => {
        Name => 'PanasonicRawVersion',
        Writable => 'undef',
    },
    0x02 => 'SensorWidth', #1/PH
    0x03 => 'SensorHeight', #1/PH
    0x04 => 'SensorTopBorder', #JD
    0x05 => 'SensorLeftBorder', #JD
    0x06 => 'ImageHeight', #1/PH
    0x07 => 'ImageWidth', #1/PH
    # observed values for unknown tags - PH
    # 0x08: 1
    # 0x09: 1,3,4
    # 0x0a: 12
    # 0x0b: 0x860c,0x880a,0x880c
    # 0x0c: 2 (only Leica Digilux 2)
    # 0x0d: 0,1
    # 0x0e,0x0f,0x10: 4095
    # 0x18,0x19,0x1a,0x1c,0x1d,0x1e: 0
    # 0x1b,0x27,0x29,0x2a,0x2b,0x2c: [binary data]
    # 0x2d: 2,3
    0x11 => { #JD
        Name => 'RedBalance',
        Writable => 'int16u',
        ValueConv => '$val / 256',
        ValueConvInv => 'int($val * 256 + 0.5)',
        Notes => 'found in Digilux 2 RAW images',
    },
    0x12 => { #JD
        Name => 'BlueBalance',
        Writable => 'int16u',
        ValueConv => '$val / 256',
        ValueConvInv => 'int($val * 256 + 0.5)',
    },
    0x17 => { #1
        Name => 'ISO',
        Writable => 'int16u',
    },
    0x24 => { #2
        Name => 'WBRedLevel',
        Writable => 'int16u',
    },
    0x25 => { #2
        Name => 'WBGreenLevel',
        Writable => 'int16u',
    },
    0x26 => { #2
        Name => 'WBBlueLevel',
        Writable => 'int16u',
    },
    0x2e => { #JD
        Name => 'JpgFromRaw', # (writable directory!)
        Writable => 'undef',
        # protect this tag because it contains all the metadata
        Flags => [ 'Binary', 'Protected', 'NestedHtmlDump', 'BlockExtract' ],
        Notes => 'processed as an embedded document because it contains full EXIF',
        WriteCheck => '$val eq "none" ? undef : $self->CheckImage(\$val)',
        DataTag => 'JpgFromRaw',
        RawConv => '$self->ValidateImage(\$val,$tag)',
        SubDirectory => {
            # extract information from embedded image since it is metadata-rich,
            # unless HtmlDump option set (note that the offsets will be relative,
            # not absolute like they should be in verbose mode)
            TagTable => 'Image::ExifTool::JPEG::Main',
            WriteProc => \&WriteJpgFromRaw,
            ProcessProc => \&ProcessJpgFromRaw,
        },
    },
    0x10f => {
        Name => 'Make',
        Groups => { 2 => 'Camera' },
        Writable => 'string',
        DataMember => 'Make',
        # save this value as an ExifTool member variable
        RawConv => '$self->{Make} = $val',
    },
    0x110 => {
        Name => 'Model',
        Description => 'Camera Model Name',
        Groups => { 2 => 'Camera' },
        Writable => 'string',
        DataMember => 'Model',
        # save this value as an ExifTool member variable
        RawConv => '$self->{Model} = $val',
    },
    0x111 => {
        Name => 'StripOffsets',
        # (this value is 0xffffffff for some models, and RawDataOffset must be used)
        Flags => [ 'IsOffset', 'PanasonicHack' ],
        OffsetPair => 0x117,  # point to associated byte counts
        ValueConv => 'length($val) > 32 ? \$val : $val',
    },
    0x112 => {
        Name => 'Orientation',
        Writable => 'int16u',
        PrintConv => \%Image::ExifTool::Exif::orientation,
        Priority => 0,  # so IFD1 doesn't take precedence
    },
    0x116 => {
        Name => 'RowsPerStrip',
        Priority => 0,
    },
    0x117 => {
        Name => 'StripByteCounts',
        # (note that this value may represent something like uncompressed byte count
        # for RAW/RW2/RWL images from some models, and is zero for some other models)
        OffsetPair => 0x111,   # point to associated offset
        ValueConv => 'length($val) > 32 ? \$val : $val',
    },
    0x118 => {
        Name => 'RawDataOffset', #PH (RW2/RWL)
        IsOffset => '$$exifTool{TIFF_TYPE} =~ /^(RW2|RWL)$/', # (invalid in DNG-converted files)
        PanasonicHack => 1,
        OffsetPair => 0x117, # (use StripByteCounts as the offset pair)
    },
    # 0x119 undef[32] - lens distortion data? (http://thinkfat.blogspot.com/2009/02/dissecting-panasonic-rw2-files.html)
    0x2bc => { # PH Extension!!
        Name => 'ApplicationNotes',
        Writable => 'int8u', # (writable directory!)
        Format => 'undef',
        Flags => [ 'Binary', 'Protected' ],
        SubDirectory => {
            DirName => 'XMP',
            TagTable => 'Image::ExifTool::XMP::Main',
        },
    },
    0x83bb => { # PH Extension!!
        Name => 'IPTC-NAA', # (writable directory!)
        Format => 'undef',      # convert binary values as undef
        Writable => 'int32u',   # but write int32u format code in IFD
        WriteGroup => 'IFD0',
        Flags => [ 'Binary', 'Protected' ],
        SubDirectory => {
            DirName => 'IPTC',
            TagTable => 'Image::ExifTool::IPTC::Main',
        },
    },
    0x8769 => {
        Name => 'ExifOffset',
        Groups => { 1 => 'ExifIFD' },
        Flags => 'SubIFD',
        SubDirectory => {
            TagTable => 'Image::ExifTool::Exif::Main',
            DirName => 'ExifIFD',
            Start => '$val',
        },
    },
    0x8825 => {
        Name => 'GPSInfo',
        Groups => { 1 => 'GPS' },
        Flags => 'SubIFD',
        SubDirectory => {
            DirName => 'GPS',
            TagTable => 'Image::ExifTool::GPS::Main',
            Start => '$val',
        },
    },
);

#------------------------------------------------------------------------------
# Patch for writing non-standard Panasonic RAW/RW2/RWL raw data
# Inputs: 0) offset info ref, 1) raf ref, 2) IFD number
# Returns: error string, or undef on success
# OffsetInfo is a hash by tag ID of lists with the following elements:
#  0 - tag info ref
#  1 - pointer to int32u offset in IFD or value data
#  2 - value count
#  3 - reference to list of original offset values
#  4 - IFD format number
sub PatchRawDataOffset($$$)
{
    my ($offsetInfo, $raf, $ifd) = @_;
    my $stripOffsets = $$offsetInfo{0x111};
    my $stripByteCounts = $$offsetInfo{0x117};
    my $rawDataOffset = $$offsetInfo{0x118};
    my $err;
    $err = 1 unless $ifd == 0;
    $err = 1 unless $stripOffsets and $stripByteCounts and $$stripOffsets[2] == 1;
    if ($rawDataOffset) {
        $err = 1 unless $$rawDataOffset[2] == 1;
        $err = 1 unless $$stripOffsets[3][0] == 0xffffffff or $$stripByteCounts[3][0] == 0;
    }
    $err and return 'Unsupported Panasonic/Leica RAW variant';
    if ($rawDataOffset) {
        # update StripOffsets along with this tag if it contains a reasonable value
        unless ($$stripOffsets[3][0] == 0xffffffff) {
            # save pointer to StripOffsets value for updating later
            push @$rawDataOffset, $$stripOffsets[1];
        }
        # handle via RawDataOffset instead of StripOffsets
        $stripOffsets = $$offsetInfo{0x111} = $rawDataOffset;
        delete $$offsetInfo{0x118};
    }
    # determine the length of the raw data
    my $pos = $raf->Tell();
    $raf->Seek(0, 2) or $err = 1; # seek to end of file
    my $len = $raf->Tell() - $$stripOffsets[3][0];
    $raf->Seek($pos, 0);
    # quick check to be sure the raw data length isn't unreasonable
    # (the 22-byte length is for '<Dummy raw image data>' in our tests)
    $err = 1 if ($len < 1000 and $len != 22) or $len & 0x80000000;
    $err and return 'Error reading Panasonic raw data';
    # update StripByteCounts info with raw data length
    # (note that the original value is maintained in the file)
    $$stripByteCounts[3][0] = $len;

    return undef;
}

#------------------------------------------------------------------------------
# Write meta information to Panasonic JpgFromRaw in RAW/RW2/RWL image
# Inputs: 0) ExifTool object ref, 1) dirInfo ref, 2) tag table ref
# Returns: updated image data, or undef if nothing changed
sub WriteJpgFromRaw($$$)
{
    my ($exifTool, $dirInfo, $tagTablePtr) = @_;
    my $dataPt = $$dirInfo{DataPt};
    my $byteOrder = GetByteOrder();
    my $fileType = $$exifTool{FILE_TYPE};   # RAW, RW2 or RWL
    my $dirStart = $$dirInfo{DirStart};
    if ($dirStart) { # DirStart is non-zero in DNG-converted RW2/RWL
        my $dirLen = $$dirInfo{DirLen} | length($$dataPt) - $dirStart;
        my $buff = substr($$dataPt, $dirStart, $dirLen);
        $dataPt = \$buff;
    }
    my $raf = new File::RandomAccess($dataPt);
    my $outbuff;
    my %dirInfo = (
        RAF => $raf,
        OutFile => \$outbuff,
    );
    $$exifTool{BASE} = $$dirInfo{DataPos};
    $$exifTool{FILE_TYPE} = $$exifTool{TIFF_TYPE} = 'JPEG';
    # use a specialized map so we don't write XMP or IPTC (or other junk) into the JPEG
    my $editDirs = $$exifTool{EDIT_DIRS};
    my $addDirs = $$exifTool{ADD_DIRS};
    $exifTool->InitWriteDirs(\%jpgFromRawMap);
    # don't add XMP segment (IPTC won't get added because it is in Photoshop record)
    delete $$exifTool{ADD_DIRS}{XMP};
    my $result = $exifTool->WriteJPEG(\%dirInfo);
    # restore variables we changed
    $$exifTool{BASE} = 0;
    $$exifTool{FILE_TYPE} = 'TIFF';
    $$exifTool{TIFF_TYPE} = $fileType;
    $$exifTool{EDIT_DIRS} = $editDirs;
    $$exifTool{ADD_DIRS} = $addDirs;
    SetByteOrder($byteOrder);
    return $result > 0 ? $outbuff : $$dataPt;
}

#------------------------------------------------------------------------------
# Extract meta information from an Panasonic JpgFromRaw
# Inputs: 0) ExifTool object reference, 1) dirInfo reference
# Returns: 1 on success, 0 if this wasn't a valid JpgFromRaw image
sub ProcessJpgFromRaw($$$)
{
    my ($exifTool, $dirInfo, $tagTablePtr) = @_;
    my $dataPt = $$dirInfo{DataPt};
    my $byteOrder = GetByteOrder();
    my $fileType = $$exifTool{FILE_TYPE};   # RAW, RW2 or RWL
    my $tagInfo = $$dirInfo{TagInfo};
    my $verbose = $exifTool->Options('Verbose');
    my ($indent, $out);
    $tagInfo or $exifTool->Warn('No tag info for Panasonic JpgFromRaw'), return 0;
    my $dirStart = $$dirInfo{DirStart};
    if ($dirStart) { # DirStart is non-zero in DNG-converted RW2/RWL
        my $dirLen = $$dirInfo{DirLen} | length($$dataPt) - $dirStart;
        my $buff = substr($$dataPt, $dirStart, $dirLen);
        $dataPt = \$buff;
    }
    $$exifTool{BASE} = $$dirInfo{DataPos} + ($dirStart || 0);
    $$exifTool{FILE_TYPE} = $$exifTool{TIFF_TYPE} = 'JPEG';
    $$exifTool{DOC_NUM} = 1;
    # extract information from embedded JPEG
    my %dirInfo = (
        Parent => 'RAF',
        RAF    => new File::RandomAccess($dataPt),
    );
    if ($verbose) {
        my $indent = $$exifTool{INDENT};
        $$exifTool{INDENT} = '  ';
        $out = $exifTool->Options('TextOut');
        print $out '--- DOC1:JpgFromRaw ',('-'x56),"\n";
    }
    my $rtnVal = $exifTool->ProcessJPEG(\%dirInfo);
    # restore necessary variables for continued RW2/RWL processing
    $$exifTool{BASE} = 0;
    $$exifTool{FILE_TYPE} = 'TIFF';
    $$exifTool{TIFF_TYPE} = $fileType;
    delete $$exifTool{DOC_NUM};
    SetByteOrder($byteOrder);
    if ($verbose) {
        $$exifTool{INDENT} = $indent;
        print $out ('-'x76),"\n";
    }
    return $rtnVal;
}

1;  # end

__END__

=head1 NAME

Image::ExifTool::PanasonicRaw - Read/write Panasonic/Leica RAW/RW2/RWL meta information

=head1 SYNOPSIS

This module is loaded automatically by Image::ExifTool when required.

=head1 DESCRIPTION

This module contains definitions required by Image::ExifTool to read and
write meta information in Panasonic/Leica RAW, RW2 and RWL images.

=head1 AUTHOR

Copyright 2003-2011, Phil Harvey (phil at owl.phy.queensu.ca)

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 REFERENCES

=over 4

=item L<http://www.cybercom.net/~dcoffin/dcraw/>

=back

=head1 SEE ALSO

L<Image::ExifTool::TagNames/PanasonicRaw Tags>,
L<Image::ExifTool(3pm)|Image::ExifTool>

=cut
