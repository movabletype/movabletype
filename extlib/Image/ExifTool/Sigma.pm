#------------------------------------------------------------------------------
# File:         Sigma.pm
#
# Description:  Sigma/Foveon EXIF maker notes tags
#
# Revisions:    04/06/2004 - P. Harvey Created
#               02/20/2007 - PH added SD14 tags
#               24/06/2010 - PH decode some SD15 tags
#
# Reference:    http://www.x3f.info/technotes/FileDocs/MakerNoteDoc.html
#------------------------------------------------------------------------------

package Image::ExifTool::Sigma;

use strict;
use vars qw($VERSION);
use Image::ExifTool::Exif;

$VERSION = '1.09';

%Image::ExifTool::Sigma::Main = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    WRITABLE => 'string',
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    0x0002 => 'SerialNumber',
    0x0003 => 'DriveMode',
    0x0004 => 'ResolutionMode',
    0x0005 => 'AFMode',
    0x0006 => 'FocusSetting',
    0x0007 => 'WhiteBalance',
    0x0008 => {
        Name => 'ExposureMode',
        PrintConv => { #PH
            A => 'Aperture-priority AE',
            M => 'Manual',
            P => 'Program AE',
            S => 'Shutter speed priority AE',
        },
    },
    0x0009 => {
        Name => 'MeteringMode',
        PrintConv => { #PH
            A => 'Average',
            C => 'Center-weighted average',
            8 => 'Multi-segment',
        },
    },
    0x000a => 'LensFocalRange',
    0x000b => 'ColorSpace',
    # SIGMA PhotoPro writes these tags as strings, but some cameras (at least) write them as rational
    0x000c => [
        {
            Name => 'ExposureCompensation',
            Condition => '$format eq "string"',
            ValueConv => '$val =~ s/Expo:\s*//, $val',
            ValueConvInv => 'IsFloat($val) ? sprintf("Expo:%+.1f",$val) : undef',
        },
        { #PH
            Name => 'ExposureAdjust',
            Writable => 'rational64s',
            Unknown => 1,
        },
    ],
    0x000d => [
        {
            Name => 'Contrast',
            Condition => '$format eq "string"',
            ValueConv => '$val =~ s/Cont:\s*//, $val',
            ValueConvInv => 'IsFloat($val) ? sprintf("Cont:%+.1f",$val) : undef',
        },
        { #PH
            Name => 'Contrast',
            Writable => 'rational64s',
        },
    ],
    0x000e => [
        {
            Name => 'Shadow',
            Condition => '$format eq "string"',
            ValueConv => '$val =~ s/Shad:\s*//, $val',
            ValueConvInv => 'IsFloat($val) ? sprintf("Shad:%+.1f",$val) : undef',
        },
        { #PH
            Name => 'Shadow',
            Writable => 'rational64s',
        },
    ],
    0x000f => [
        {
            Name => 'Highlight',
            Condition => '$format eq "string"',
            ValueConv => '$val =~ s/High:\s*//, $val',
            ValueConvInv => 'IsFloat($val) ? sprintf("High:%+.1f",$val) : undef',
        },
        { #PH
            Name => 'Highlight',
            Writable => 'rational64s',
        },
    ],
    0x0010 => [
        {
            Name => 'Saturation',
            Condition => '$format eq "string"',
            ValueConv => '$val =~ s/Satu:\s*//, $val',
            ValueConvInv => 'IsFloat($val) ? sprintf("Satu:%+.1f",$val) : undef',
        },
        { #PH
            Name => 'Saturation',
            Writable => 'rational64s',
        },
    ],
    0x0011 => [
        {
            Name => 'Sharpness',
            Condition => '$format eq "string"',
            ValueConv => '$val =~ s/Shar:\s*//, $val',
            ValueConvInv => 'IsFloat($val) ? sprintf("Shar:%+.1f",$val) : undef',
        },
        { #PH
            Name => 'Sharpness',
            Writable => 'rational64s',
        },
    ],
    0x0012 => [
        {
            Name => 'X3FillLight',
            Condition => '$format eq "string"',
            ValueConv => '$val =~ s/Fill:\s*//, $val',
            ValueConvInv => 'IsFloat($val) ? sprintf("Fill:%+.1f",$val) : undef',
        },
        { #PH
            Name => 'X3FillLight',
            Writable => 'rational64s',
        },
    ],
    0x0014 => [
        {
            Name => 'ColorAdjustment',
            Condition => '$format eq "string"',
            ValueConv => '$val =~ s/CC:\s*//, $val',
            ValueConvInv => 'IsInt($val) ? "CC:$val" : undef',
        },
        { #PH
            Name => 'ColorAdjustment',
            Writable => 'rational64s',
            Count => 3,
        },
    ],
    0x0015 => 'AdjustmentMode',
    0x0016 => {
        Name => 'Quality',
        ValueConv => '$val =~ s/Qual:\s*//, $val',
        ValueConvInv => 'IsInt($val) ? "Qual:$val" : undef',
    },
    0x0017 => 'Firmware',
    0x0018 => 'Software',
    0x0019 => 'AutoBracket',
    0x001a => [ #PH
        {
            Name => 'PreviewImageStart',
            Condition => '$format eq "int32u"',
            IsOffset => 1,
            OffsetPair => 0x001b,
            DataTag => 'PreviewImage',
            Writable => 'int32u',
            Protected => 2,
        },{ # (written by Sigma Photo Pro)
            Name => 'ChrominanceNoiseReduction',
            ValueConv => '$val =~ s/Chro:\s*//, $val',
            ValueConvInv => 'IsFloat($val) ? sprintf("Chro:%+.1f",$val) : undef',
        },
    ],
    0x001b => [ #PH
        {
            Name => 'PreviewImageLength',
            Condition => '$format eq "int32u"',
            OffsetPair => 0x001a,
            DataTag => 'PreviewImage',
            Writable => 'int32u',
            Protected => 2,
        },{ # (written by Sigma Photo Pro)
            Name => 'LuminanceNoiseReduction',
            ValueConv => '$val =~ s/Luma:\s*//, $val',
            ValueConvInv => 'IsFloat($val) ? sprintf("Luma:%+.1f",$val) : undef',
        },
    ],
    0x001c => { #PH
        Name => 'PreviewImageSize',
        Writable => 'int16u',
        Count => 2,
    },
    0x001d => { #PH
        Name => 'MakerNoteVersion',
        Writable => 'undef',
    },
    # 0x001e - int16u: 0, 4, 13 - flash mode?
    0x001f => { #PH (NC)
        Name => 'AFPoint',
        # values: "", "Center", "Center,Center", "Right,Right"
    },
    # 0x0020-21 - string: " "
    0x0022 => { #PH (NC)
        Name => 'FileFormat',
        # values: "JPG", "JPG-S" or "X3F"
    },
    # 0x0023 - string: "", 10, 83, 131, 145, 150, 152, 169
    0x0024 => 'Calibration',
    # 0x0025 - string: "", "0.70", "0.90"
    # 0x0026-2b - int32u: 0
    0x002c => { #PH
        Name => 'ColorMode',
        Writable => 'int32u',
        PrintConv => {
            0 => 'n/a',
            1 => 'Sepia',
            2 => 'B&W',
            3 => 'Standard',
            4 => 'Vivid',
            5 => 'Neutral',
            6 => 'Portrait',
            7 => 'Landscape',
        },
    },
    # 0x002d - int32u: 0
    # 0x002e - rational64s: (the negative of FlashExposureComp, but why?)
    # 0x002f - int32u: 0, 1
    0x0030 => { #PH
        Name => 'LensApertureRange',
        Notes => 'changes with focal length. MaxAperture for some models',
    },
    0x0031 => { #PH
        Name => 'FNumber',
        Writable => 'rational64u',
        PrintConv => 'sprintf("%.1f",$val)',
        PrintConvInv => '$val',
    },
    0x0032 => { #PH
        Name => 'ExposureTime',
        Writable => 'rational64u',
        PrintConv => 'Image::ExifTool::Exif::PrintExposureTime($val)',
        PrintConvInv => 'Image::ExifTool::Exif::ConvertFraction($val)',
    },
    0x0033 => { #PH
        Name => 'ExposureTime2',
        Writable => 'string',
        ValueConv => '$val * 1e-6',
        ValueConvInv => 'int($val * 1e6 + 0.5)',
        PrintConv => 'Image::ExifTool::Exif::PrintExposureTime($val)',
        PrintConvInv => 'Image::ExifTool::Exif::ConvertFraction($val)',
    },
    0x0034 => { #PH
        Name => 'BurstShot',
        Writable => 'int32u',
    },
    # 0x0034 - int32u: 0,1,2,3 or 4
    0x0035 => { #PH
        Name => 'ExposureCompensation',
        Writable => 'rational64s',
        # add a '+' sign to positive values
        PrintConv => '$val and $val =~ s/^(\d)/\+$1/; $val',
        PrintConvInv => '$val',
    },
    # 0x0036 - string: "                    "
    # 0x0037-38 - string: ""
    0x0039 => { #PH
        Name => 'SensorTemperature',
        # (string format)
        PrintConv => 'IsInt($val) ? "$val C" : $val',
        PrintConvInv => '$val=~s/ ?C$//; $val',
    },
    0x003a => { #PH
        Name => 'FlashExposureComp',
        Writable => 'rational64s',
    },
    0x003b => { #PH (how is this different from other Firmware?)
        Name => 'Firmware',
        Priority => 0,
    },
    0x003c => 'WhiteBalance', #PH
    0x003d => { #PH (new for SD15)
        Name => 'PictureMode',
        Notes => 'same as ColorMode, but "Standard" when ColorMode is Sepia or B&W',
    },
);

1;  # end

__END__

=head1 NAME

Image::ExifTool::Sigma - Sigma/Foveon EXIF maker notes tags

=head1 SYNOPSIS

This module is loaded automatically by Image::ExifTool when required.

=head1 DESCRIPTION

This module contains definitions required by Image::ExifTool to interpret
Sigma and Foveon maker notes in EXIF information.

=head1 AUTHOR

Copyright 2003-2011, Phil Harvey (phil at owl.phy.queensu.ca)

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 REFERENCES

=over 4

=item L<http://www.x3f.info/technotes/FileDocs/MakerNoteDoc.html>

=back

=head1 SEE ALSO

L<Image::ExifTool::TagNames/Sigma Tags>,
L<Image::ExifTool(3pm)|Image::ExifTool>

=cut
