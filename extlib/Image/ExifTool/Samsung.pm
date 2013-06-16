#------------------------------------------------------------------------------
# File:         Samsung.pm
#
# Description:  Samsung EXIF maker notes tags
#
# Revisions:    2010/03/01 - P. Harvey Created
#
# References:   1) Tae-Sun Park private communication
#------------------------------------------------------------------------------

package Image::ExifTool::Samsung;

use strict;
use vars qw($VERSION);
use Image::ExifTool qw(:DataAccess :Utils);
use Image::ExifTool::Exif;

$VERSION = '1.05';

sub WriteSTMN($$$);
sub ProcessINFO($$$);

# Samsung "STMN" maker notes (ref PH)
%Image::ExifTool::Samsung::Type1 = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    WRITE_PROC => \&WriteSTMN,
    CHECK_PROC => \&Image::ExifTool::CheckBinaryData,
    WRITABLE => 1,
    FORMAT => 'int32u',
    FIRST_ENTRY => 0,
    IS_OFFSET => [ 2 ],   # tag 2 is 'IsOffset'
    GROUPS => { 0 => 'MakerNotes', 2 => 'Image' },
    NOTES => q{
        Tags found in the binary "STMN" format maker notes written by a number of
        Samsung models.
    },
    0 => {
        Name => 'MakerNoteVersion',
        Format => 'undef[8]',
    },
    2 => {
        Name => 'PreviewImageStart',
        OffsetPair => 3,  # associated byte count tagID
        DataTag => 'PreviewImage',
        IsOffset => 3,
        Protected => 2,
    },
    3 => {
        Name => 'PreviewImageLength',
        OffsetPair => 2,   # point to associated offset
        DataTag => 'PreviewImage',
        Protected => 2,
    },
);

# Samsung maker notes (ref PH)
%Image::ExifTool::Samsung::Type2 = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    WRITABLE => 1,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Image' },
    NOTES => q{
        Tags found in the EXIF-format maker notes of cameras such as the NX10,
        ST500, ST550, ST1000 and WB5000.
    },
    0x0001 => {
        Name => 'MakerNoteVersion',
        Writable => 'undef',
        Count => 4,
    },
    0x0021 => { #1
        Name => 'PictureWizard',
        Writable => 'int16u',
        Count => 5,
        PrintConv => q{
            my @a = split ' ', $val;
            return $val unless @a == 5;
            sprintf("Mode: %d, Col: %d, Sat: %d, Sha: %d, Con: %d",
                    $a[0], $a[1], $a[2]-4, $a[3]-4, $a[4]-4);
        },
        PrintConvInv => q{
            my @a = ($val =~ /[+-]?\d+/g);
            return $val unless @a >= 5;
            sprintf("%d %d %d %d %d", $a[0], $a[1], $a[2]+4, $a[3]+4, $a[4]+4);
        },
    },
    # 0x0023 - string: "0123456789" (PH)
    0x0035 => {
        Name => 'PreviewIFD',
        Condition => '$$self{TIFF_TYPE} eq "SRW"', # (not an IFD in JPEG images)
        Groups => { 1 => 'PreviewIFD' },
        Flags => 'SubIFD',
        SubDirectory => {
            TagTable => 'Image::ExifTool::Nikon::PreviewIFD',
            ByteOrder => 'Unknown',
            Start => '$val',
        },
    },
    0x0043 => { #1 (NC)
        Name => 'CameraTemperature',
        Groups => { 2 => 'Camera' },
        Writable => 'rational64s',
        # (DPreview samples all 0.2 C --> pre-production model)
        PrintConv => '"$val C"',
        PrintConvInv => '$val=~s/ ?C//; $val',
    },
    # 0x00a0 - undef[8192]: white balance information (ref 1):
    #   At byte 5788, the WBAdjust: "Adjust\0\X\0\Y\0\Z\xee\xea\xce\xab", where
    #   Y = BA adjust (0=Blue7, 7=0, 14=Amber7), Z = MG (0=Magenta7, 7=0, 14=Green7)
#
# the following tags found only in SRW images
#
    # 0xa000 - DigitalZoomRatio? #1
    0xa001 => { #1
        Name => 'FirmwareName',
        Groups => { 2 => 'Camera' },
        Writable => 'string',
    },
    0xa003 => { #1 (SRW images only)
        Name => 'LensType',
        Groups => { 2 => 'Camera' },
        Writable => 'int16u',
        PrintConv => {
            0 => 'Built-in', #PH (EX1, WB2000)
            1 => 'Samsung 30mm F2 Pancake',
            2 => 'Samsung Zoom 18-55mm F3.5-5.6 OIS',
            3 => 'Samsung Zoom 50-200mm F4-5.6 ED OIS',
            # what about the non-OIS version of the 18-55,
            # which was supposed to be available before the 20-50?
            4 => 'Samsung 20-50mm F3.5-5.6 Compact Zoom', #PH
            5 => 'Samsung 20mm F2.8 Pancake', #PH (guess)
        },
    },
    # 0xa004 - lens firmware version? #1
    # 0xa005 - or maybe this is a SerialNumber? (PH)
    0xa010 => { #1
        Name => 'SensorAreas',
        Groups => { 2 => 'Camera' },
        Notes => 'full and valid sensor areas',
        Writable => 'int32u',
        Count => 8,
    },
    0xa013 => { #1
        Name => 'ExposureCompensation',
        Writable => 'rational64s',
    },
    0xa014 => { #1
        Name => 'ISO',
        Writable => 'int32u',
    },
    0xa018 => { #1
        Name => 'ExposureTime',
        Writable => 'rational64u',
        PrintConv => 'Image::ExifTool::Exif::PrintExposureTime($val)',
        PrintConvInv => 'Image::ExifTool::Exif::ConvertFraction($val)',
    },
    0xa019 => { #1
        Name => 'FNumber',
        Writable => 'rational64u',
        PrintConv => 'sprintf("%.1f",$val)',
        PrintConvInv => '$val',
    },
    0xa01a => { #1
        Name => 'FocalLengthIn35mmFormat',
        Groups => { 2 => 'Camera' },
        Format => 'int32u',
        ValueConv => '$val / 10',
        ValueConvInv => '$val * 10',
        PrintConv => '"$val mm"',
        PrintConvInv => '$val=~s/\s*mm$//;$val',
    },
    0xa021 => { #1
        Name => 'WB_RGGBLevels',
        Writable => 'int32u',
        Count => 4,
    },
);

# INFO tags in Samsung MP4 videos (ref PH)
%Image::ExifTool::Samsung::INFO = (
    PROCESS_PROC => \&ProcessINFO,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Video' },
    NOTES => q{
        This information is found in MP4 videos from Samsung models such as the
        SMX-C20N.
    },
    EFCT => 'Effect', # (guess)
    QLTY => 'Quality',
    # MDEL - value: 0
    # ASPT - value: 1, 2
);

# Samsung MP4 TAGS information (PH - from WP10 sample)
# --> very similar to Sanyo MP4 information
%Image::ExifTool::Samsung::MP4 = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    NOTES => q{
        This information is found in Samsung MP4 videos from models such as the
        WP10.
    },
    0x00 => {
        Name => 'Make',
        Format => 'string[24]',
        PrintConv => 'ucfirst(lc($val))',
    },
    0x18 => {
        Name => 'Model',
        Description => 'Camera Model Name',
        Format => 'string[16]',
    },
    0x2e => { # (NC)
        Name => 'ExposureTime',
        Format => 'int32u',
        ValueConv => '$val ? 10 / $val : 0',
        PrintConv => 'Image::ExifTool::Exif::PrintExposureTime($val)',
    },
    0x32 => {
        Name => 'FNumber',
        Format => 'rational64u',
        PrintConv => 'sprintf("%.1f",$val)',
    },
    0x3a => { # (NC)
        Name => 'ExposureCompensation',
        Format => 'rational64s',
        PrintConv => '$val ? sprintf("%+.1f", $val) : 0',
    },
    0x6a => {
        Name => 'ISO',
        Format => 'int32u',
    },
    0x7d => {
        Name => 'Software',
        Format => 'string[32]',
        # (these tags are not at a constant offset for Sanyo videos,
        #  so just to be safe use this to validate subsequent tags)
        RawConv => q{
            $val =~ /^SAMSUNG/ or return undef;
            $$self{SamsungMP4} = 1;
            return $val;
        },
    },
    0xf8 => {
        Name => 'ThumbnailWidth',
        Condition => '$$self{SamsungMP4}',
        Format => 'int32u',
    },
    0xfc => {
        Name => 'ThumbnailHeight',
        Condition => '$$self{SamsungMP4}',
        Format => 'int32u',
    },
    0x100 => {
        Name => 'ThumbnailLength',
        Condition => '$$self{SamsungMP4}',
        Format => 'int32u',
    },
    0x104 => {
        Name => 'ThumbnailOffset',
        Condition => '$$self{SamsungMP4}',
        IsOffset => 1,
        Format => 'int32u',
        RawConv => '$val + 0xf4',
    },
);

#------------------------------------------------------------------------------
# Process Samsung MP4 INFO data
# Inputs: 0) ExifTool ref, 1) dirInfo ref, 2) tag table ref
# Returns: 1 on success
sub ProcessINFO($$$)
{
    my ($exifTool, $dirInfo, $tagTablePtr) = @_;
    my $dataPt = $$dirInfo{DataPt};
    my $pos = $$dirInfo{DirStart};
    my $len = $$dirInfo{DirLen};
    my $end = $pos + $len;
    $exifTool->VerboseDir('INFO', undef, $len);
    while ($pos + 8 <= $end) {
        my $tag = substr($$dataPt, $pos, 4);
        my $val = Get32u($dataPt, $pos + 4);
        unless ($$tagTablePtr{$tag}) {
            my $name = "Samsung_INFO_$tag";
            $name =~ tr/-_0-9a-zA-Z//dc;
            Image::ExifTool::AddTagToTable($tagTablePtr, $tag, { Name => $name }) if $name;
        }
        $exifTool->HandleTag($tagTablePtr, $tag, $val);
        $pos += 8;
    }
    return 1;
}

#------------------------------------------------------------------------------
# Write Samsung STMN maker notes
# Inputs: 0) ExifTool object ref, 1) source dirInfo ref, 2) tag table ref
# Returns: Binary data block or undefined on error
sub WriteSTMN($$$)
{
    my ($exifTool, $dirInfo, $tagTablePtr) = @_;
    # create a Fixup for the PreviewImage
    $$dirInfo{Fixup} = new Image::ExifTool::Fixup;
    my $val = Image::ExifTool::WriteBinaryData($exifTool, $dirInfo, $tagTablePtr);
    # force PreviewImage into the trailer even if it fits in EXIF segment
    $$exifTool{PREVIEW_INFO}{IsTrailer} = 1 if $$exifTool{PREVIEW_INFO};
    return $val;
}

1;  # end

__END__

=head1 NAME

Image::ExifTool::Samsung - Samsung EXIF maker notes tags

=head1 SYNOPSIS

This module is loaded automatically by Image::ExifTool when required.

=head1 DESCRIPTION

This module contains definitions required by Image::ExifTool to interpret
Samsung maker notes in EXIF information.

=head1 AUTHOR

Copyright 2003-2011, Phil Harvey (phil at owl.phy.queensu.ca)

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 ACKNOWLEDGEMENTS

Thanks to Tae-Sun Park for decoding some tags.

=head1 SEE ALSO

L<Image::ExifTool::TagNames/Samsung Tags>,
L<Image::ExifTool(3pm)|Image::ExifTool>

=cut
