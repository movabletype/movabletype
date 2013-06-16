#------------------------------------------------------------------------------
# File:         Casio.pm
#
# Description:  Casio EXIF maker notes tags
#
# Revisions:    12/09/2003 - P. Harvey Created
#               09/10/2004 - P. Harvey Added MakerNote2 (thanks to Joachim Loehr)
#
# References:   1) http://park2.wakwak.com/~tsuruzoh/Computer/Digicams/exif-e.html
#               2) Joachim Loehr private communication
#               3) http://homepage3.nifty.com/kamisaka/makernote/makernote_casio.htm
#               4) http://www.gvsoft.homedns.org/exif/makernote-casio.html
#               5) Robert Chi private communication (EX-F1)
#               JD) Jens Duttke private communication
#------------------------------------------------------------------------------

package Image::ExifTool::Casio;

use strict;
use vars qw($VERSION);
use Image::ExifTool::Exif;

$VERSION = '1.32';

# older Casio maker notes (ref 1)
%Image::ExifTool::Casio::Main = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    WRITABLE => 1,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    0x0001 => {
        Name => 'RecordingMode' ,
        Writable => 'int16u',
        PrintConv => {
            1 => 'Single Shutter',
            2 => 'Panorama',
            3 => 'Night Scene',
            4 => 'Portrait',
            5 => 'Landscape',
            7 => 'Panorama', #4
            10 => 'Night Scene', #4
            15 => 'Portrait', #4
            16 => 'Landscape', #4
        },
    },
    0x0002 => {
        Name => 'Quality',
        Writable => 'int16u',
        PrintConv => { 1 => 'Economy', 2 => 'Normal', 3 => 'Fine' },
    },
    0x0003 => {
        Name => 'FocusMode',
        Writable => 'int16u',
        PrintConv => {
            2 => 'Macro',
            3 => 'Auto',
            4 => 'Manual',
            5 => 'Infinity',
            7 => 'Spot AF', #4
        },
    },
    0x0004 => [
        {
            Name => 'FlashMode',
            Condition => '$self->{Model} =~ /^QV-(3500EX|8000SX)/',
            Writable => 'int16u',
            PrintConv => {
                1 => 'Auto',
                2 => 'On',
                3 => 'Off',
                4 => 'Off', #4
                5 => 'Red-eye Reduction', #4
            },
        },
        {
            Name => 'FlashMode',
            Writable => 'int16u',
            PrintConv => {
                1 => 'Auto',
                2 => 'On',
                3 => 'Off',
                4 => 'Red-eye Reduction',
            },
        },
    ],
    0x0005 => {
        Name => 'FlashIntensity',
        Writable => 'int16u',
        PrintConv => {
            11 => 'Weak',
            12 => 'Low', #4
            13 => 'Normal',
            14 => 'High', #4
            15 => 'Strong',
        },
    },
    0x0006 => {
        Name => 'ObjectDistance',
        Writable => 'int32u',
        ValueConv => '$val / 1000', #4
        ValueConvInv => '$val * 1000',
        PrintConv => '"$val m"',
        PrintConvInv => '$val=~s/\s*m$//;$val',
    },
    0x0007 => {
        Name => 'WhiteBalance',
        Writable => 'int16u',
        PrintConv => {
            1 => 'Auto',
            2 => 'Tungsten',
            3 => 'Daylight',
            4 => 'Fluorescent',
            5 => 'Shade',
            129 => 'Manual',
        },
    },
    # 0x0009 Bulb? (ref unknown)
    0x000a => {
        Name => 'DigitalZoom',
        Writable => 'int32u',
        PrintHex => 1,
        PrintConv => {
            0x10000 => 'Off',
            0x10001 => '2x',
            0x19999 => '1.6x', #4
            0x20000 => '2x', #4
            0x33333 => '3.2x', #4
            0x40000 => '4x', #4
        },
    },
    0x000b => {
        Name => 'Sharpness',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Normal',
            1 => 'Soft',
            2 => 'Hard',
            16 => 'Normal', #4
            17 => '+1', #4
            18 => '-1', #4
         },
    },
    0x000c => {
        Name => 'Contrast',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Normal',
            1 => 'Low',
            2 => 'High',
            16 => 'Normal', #4
            17 => '+1', #4
            18 => '-1', #4
        },
    },
    0x000d => {
        Name => 'Saturation',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Normal',
            1 => 'Low',
            2 => 'High',
            16 => 'Normal', #4
            17 => '+1', #4
            18 => '-1', #4
        },
    },
    0x0014 => {
        Name => 'ISO',
        Writable => 'int16u',
        Priority => 0,
    },
    0x0015 => { #JD (Similar to Type2 0x2001)
        Name => 'FirmwareDate',
        Writable => 'string',
        Format => 'undef', # the 'string' contains nulls
        Count => 18,
        PrintConv => q{
            $_ = $val;
            if (/^(\d{2})(\d{2})\0\0(\d{2})(\d{2})\0\0(\d{2})(.{2})\0{2}$/) {
                my $yr = $1 + ($1 < 70 ? 2000 : 1900);
                my $sec = $6;
                $val = "$yr:$2:$3 $4:$5";
                $val .= ":$sec" if $sec=~/^\d{2}$/;
                return $val;
            }
            tr/\0/./;  s/\.+$//;
            return "Unknown ($_)";
        },
        PrintConvInv => q{
            $_ = $val;
            if (/^(19|20)(\d{2}):(\d{2}):(\d{2}) (\d{2}):(\d{2})$/) {
                return "$2$3\0\0$4$5\0\0$6\0\0\0\0";
            } elsif (/^Unknown\s*\((.*)\)$/i) {
                $_ = $1;  tr/./\0/;
                return $_;
            } else {
                return undef;
            }
        },
    },
    0x0016 => { #4
        Name => 'Enhancement',
        Writable => 'int16u',
        PrintConv => {
            1 => 'Off',
            2 => 'Red',
            3 => 'Green',
            4 => 'Blue',
            5 => 'Flesh Tones',
        },
    },
    0x0017 => { #4
        Name => 'ColorFilter',
        Writable => 'int16u',
        PrintConv => {
            1 => 'Off',
            2 => 'Black & White',
            3 => 'Sepia',
            4 => 'Red',
            5 => 'Green',
            6 => 'Blue',
            7 => 'Yellow',
            8 => 'Pink',
            9 => 'Purple',
        },
    },
    0x0018 => { #4
        Name => 'AFPoint',
        Writable => 'int16u',
        Notes => 'may not be valid for all models', #JD
        PrintConv => {
            1 => 'Center',
            2 => 'Upper Left',
            3 => 'Upper Right',
            4 => 'Near Left/Right of Center',
            5 => 'Far Left/Right of Center',
            6 => 'Far Left/Right of Center/Bottom',
            7 => 'Top Near-Left',
            8 => 'Near Upper/Left',
            9 => 'Top Near-Right',
            10 => 'Top Left',
            11 => 'Top Center',
            12 => 'Top Right',
            13 => 'Center Left',
            14 => 'Center Right',
            15 => 'Bottom Left',
            16 => 'Bottom Center',
            17 => 'Bottom Right',
        },
    },
    0x0019 => { #4
        Name => 'FlashIntensity',
        Writable => 'int16u',
        PrintConv => {
            1 => 'Normal',
            2 => 'Weak',
            3 => 'Strong',
        },
    },
    0x0e00 => {
        Name => 'PrintIM',
        Description => 'Print Image Matching',
        # crazy I know, but the offset for this value is entry-based
        # (QV-2100, QV-2900UX, QV-3500EX and QV-4000) even though the
        # offsets for other values isn't
        EntryBased => 1,
        SubDirectory => {
            TagTable => 'Image::ExifTool::PrintIM::Main',
        },
    },
);

# ref 2:
%Image::ExifTool::Casio::Type2 = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    WRITABLE => 1,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    0x0002 => {
        Name => 'PreviewImageSize',
        Groups => { 2 => 'Image' },
        Writable => 'int16u',
        Count => 2,
        PrintConv => '$val =~ tr/ /x/; $val',
        PrintConvInv => '$val =~ tr/x/ /; $val',
    },
    0x0003 => {
        Name => 'PreviewImageLength',
        Groups => { 2 => 'Image' },
        OffsetPair => 0x0004, # point to associated offset
        DataTag => 'PreviewImage',
        Writable => 'int32u',
        Protected => 2,
    },
    0x0004 => {
        Name => 'PreviewImageStart',
        Groups => { 2 => 'Image' },
        Flags => 'IsOffset',
        OffsetPair => 0x0003, # point to associated byte count
        DataTag => 'PreviewImage',
        Writable => 'int32u',
        Protected => 2,
    },
    0x0008 => {
        Name => 'QualityMode',
        Writable => 'int16u',
        PrintConv => {
           0 => 'Economy',
           1 => 'Normal',
           2 => 'Fine',
        },
    },
    0x0009 => {
        Name => 'CasioImageSize',
        Groups => { 2 => 'Image' },
        Writable => 'int16u',
        PrintConv => {
            0 => '640x480',
            4 => '1600x1200',
            5 => '2048x1536',
            20 => '2288x1712',
            21 => '2592x1944',
            22 => '2304x1728',
            36 => '3008x2008',
        },
    },
    0x000d => {
        Name => 'FocusMode',
        Writable => 'int16u',
        PrintConv => {
           0 => 'Normal',
           1 => 'Macro',
        },
    },
    0x0014 => {
        Name => 'ISO',
        Writable => 'int16u',
        Priority => 0,
        PrintConv => {
           3 => 50,
           4 => 64,
           6 => 100,
           9 => 200,
        },
    },
    0x0019 => {
        Name => 'WhiteBalance',
        Writable => 'int16u',
        PrintConv => {
           0 => 'Auto',
           1 => 'Daylight',
           2 => 'Shade',
           3 => 'Tungsten',
           4 => 'Fluorescent',
           5 => 'Manual',
        },
    },
    0x001d => {
        Name => 'FocalLength',
        Writable => 'rational64u',
        PrintConv => 'sprintf("%.1f mm",$val)',
        PrintConvInv => '$val=~s/\s*mm$//;$val',
    },
    0x001f => {
        Name => 'Saturation',
        Writable => 'int16u',
        PrintConv => {
           0 => 'Low',
           1 => 'Normal',
           2 => 'High',
        },
    },
    0x0020 => {
        Name => 'Contrast',
        Writable => 'int16u',
        PrintConv => {
           0 => 'Low',
           1 => 'Normal',
           2 => 'High',
        },
    },
    0x0021 => {
        Name => 'Sharpness',
        Writable => 'int16u',
        PrintConv => {
           0 => 'Soft',
           1 => 'Normal',
           2 => 'Hard',
        },
    },
    0x0e00 => {
        Name => 'PrintIM',
        Description => 'Print Image Matching',
        Writable => 0,
        SubDirectory => {
            TagTable => 'Image::ExifTool::PrintIM::Main',
        },
    },
    0x2000 => {
        # this image data is also referenced by tags 3 and 4
        # (nasty that they double-reference the image!)
        %Image::ExifTool::previewImageTagInfo,
    },
    0x2001 => { #PH
        # I downloaded images from 12 different EX-Z50 cameras, and they showed
        # only 3 distinct dates here (2004:08:31 18:55, 2004:09:13 14:14, and
        # 2004:11:26 17:07), so I'm guessing this is a firmware version date - PH
        Name => 'FirmwareDate',
        Writable => 'string',
        Format => 'undef', # the 'string' contains nulls
        Count => 18,
        PrintConv => q{
            $_ = $val;
            if (/^(\d{2})(\d{2})\0\0(\d{2})(\d{2})\0\0(\d{2})\0{4}$/) {
                my $yr = $1 + ($1 < 70 ? 2000 : 1900);
                return "$yr:$2:$3 $4:$5";
            }
            tr/\0/./;  s/\.+$//;
            return "Unknown ($_)";
        },
        PrintConvInv => q{
            $_ = $val;
            if (/^(19|20)(\d{2}):(\d{2}):(\d{2}) (\d{2}):(\d{2})$/) {
                return "$2$3\0\0$4$5\0\0$6\0\0\0\0";
            } elsif (/^Unknown\s*\((.*)\)$/i) {
                $_ = $1;  tr/./\0/;
                return $_;
            } else {
                return undef;
            }
        },
    },
    0x2011 => {
        Name => 'WhiteBalanceBias',
        Writable => 'int16u',
        Count => 2,
    },
    0x2012 => {
        Name => 'WhiteBalance',
        Writable => 'int16u',
        PrintConv => {
           0 => 'Manual',
           1 => 'Daylight', #3
           3 => 'Shade', #3
           4 => 'Flash?',
           6 => 'Fluorescent', #3
           9 => 'Tungsten?', #PH (EX-Z77)
           10 => 'Tungsten', #3
           12 => 'Flash',
        },
    },
    0x2021 => { #JD (guess)
        Name => 'AFPointPosition',
        Writable => 'int16u',
        Count => 4,
        PrintConv => q{
            my @v = split ' ', $val;
            return 'n/a' if $v[0] == 65535 or not $v[1] or not $v[3];
            sprintf "%.2g %.2g", $v[0]/$v[1], $v[2]/$v[3];
        },
    },
    0x2022 => {
        Name => 'ObjectDistance',
        Writable => 'int32u',
        ValueConv => '$val >= 0x20000000 ? "inf" : $val / 1000',
        ValueConvInv => '$val eq "inf" ? 0x20000000 : $val * 1000',
        PrintConv => '$val eq "inf" ? $val : "$val m"',
        PrintConvInv => '$val=~s/\s*m$//;$val',
    },
    # 0x2023 looks interesting (values 0,1,2,3,5 in samples) - PH
    #        - 1 for makeup mode shots (portrait?) (EX-Z450)
    0x2034 => {
        Name => 'FlashDistance',
        Writable => 'int16u',
    },
    # 0x203e - normally 62000, but 62001 for anti-shake mode - PH
    0x2076 => { #PH (EX-Z450)
        # ("Enhancement" was taken already, so call this "SpecialEffect" for lack of a better name)
        Name => 'SpecialEffectMode',
        Writable => 'int8u',
        Count => 3,
        PrintConv => {
            '0 0 0' => 'Off',
            '1 0 0' => 'Makeup',
            '2 0 0' => 'Mist Removal',
            '3 0 0' => 'Vivid Landscape',
            # have also seen '1 1 1', '2 2 4', '4 3 3', '4 4 4'
            # '0 0 14' and '0 0 42' - premium auto night shot (EX-Z2300)
        },
    },
    0x3000 => {
        Name => 'RecordMode',
        Writable => 'int16u',
        PrintConv => {
            2 => 'Program AE', #3
            3 => 'Shutter Priority', #3
            4 => 'Aperture Priority', #3
            5 => 'Manual', #3
            6 => 'Best Shot', #3
            17 => 'Movie', #PH (UHQ?)
            19 => 'Movie (19)', #PH (HQ?, EX-P505)
            20 => 'YouTube Movie', #PH
            '2 0' => 'Program AE', #PH (NC)
            '3 0' => 'Shutter Priority', #PH (NC)
            '4 0' => 'Aperture Priority', #PH (NC)
            '5 0' => 'Manual', #PH (NC)
            '6 0' => 'Best Shot', #PH (NC)
        },
    },
    0x3001 => { #3
        Name => 'ReleaseMode',
        Writable => 'int16u',
        PrintConv => {
            1 => 'Normal',
            3 => 'AE Bracketing',
            11 => 'WB Bracketing',
            13 => 'Contrast Bracketing', #(not sure about translation - PH)
            19 => 'High Speed Burst', #PH (EX-FH25, 40fps)
            # have also seen: 2, 7(common), 14, 18 - PH
        },
    },
    0x3002 => {
        Name => 'Quality',
        Writable => 'int16u',
        PrintConv => {
           1 => 'Economy',
           2 => 'Normal',
           3 => 'Fine',
        },
    },
    0x3003 => {
        Name => 'FocusMode',
        Writable => 'int16u',
        PrintConv => {
           0 => 'Manual', #(guess at translation)
           1 => 'Focus Lock', #(guess at translation)
           2 => 'Macro', #3
           3 => 'Single-Area Auto Focus',
           5 => 'Infinity', #PH
           6 => 'Multi-Area Auto Focus',
           8 => 'Super Macro', #PH (EX-Z2300)
        },
    },
    0x3006 => {
        Name => 'HometownCity',
        Writable => 'string',
    },
    0x3007 => {
        Name => 'BestShotMode',
        Writable => 'int16u',
        # unfortunately these numbers are model-dependent,
        # so we can't use a lookup as usual - PH
        PrintConv => '$val ? $val : "Off"',
        PrintConvInv => '$val=~/(\d+)/ ? $1 : 0',
    },
    0x3008 => { #3
        Name => 'AutoISO',
        Writable => 'int16u',
        PrintConv => {
            1 => 'On',
            2 => 'Off',
            7 => 'On (high sensitivity)', #PH
            8 => 'On (anti-shake)', #PH
            10 => 'High Speed', #PH (EX-FC150)
        },
    },
    0x3009 => { #PH (EX-Z77)
        Name => 'AFMode',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Off',
            1 => 'On',
            # have seen 2, 3(portrait) and 5(auto mode)
            4 => 'Face Recognition', # "Family First"
        },
    },
    0x3011 => { #3
        Name => 'Sharpness',
        Format => 'int16s',
        Writable => 'undef',
    },
    0x3012 => { #3
        Name => 'Contrast',
        Format => 'int16s',
        Writable => 'undef',
    },
    0x3013 => { #3
        Name => 'Saturation',
        Format => 'int16s',
        Writable => 'undef',
    },
    0x3014 => {
        Name => 'ISO',
        Writable => 'int16u',
        Priority => 0,
    },
    0x3015 => {
        Name => 'ColorMode',
        Writable => 'int16u',
        PrintConv => {  
            0 => 'Off',
            2 => 'Black & White', #PH (EX-Z400,FH20)
            3 => 'Sepia', #PH (EX-Z400)
        },
    },
    0x3016 => {
        Name => 'Enhancement',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Off',
            1 => 'Scenery', #PH (NC) (EX-Z77)
            3 => 'Green', #PH (EX-Z77)
            5 => 'Underwater', #PH (NC) (EX-Z77)
            9 => 'Flesh Tones', #PH (EX-Z77)
        },
    },
    0x3017 => {
        Name => 'ColorFilter',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Off',
            1 => 'Blue', #PH (FH20,Z400)
            3 => 'Green', #PH (FH20)
            4 => 'Yellow', #PH (FH20)
            5 => 'Red', #PH (FH20,Z77)
            6 => 'Purple', #PH (FH20,Z77,Z400)
            7 => 'Pink', #PH (FH20)
        },
    },
    0x301b => { #PH
        Name => 'UnknownMode',
        Writable => 'int16u',
        Unknown => 1,
        PrintConv => {
            0 => 'Normal',
            8 => 'Silent Movie',
            39 => 'HDR', # (EX-ZR10)
            45 => 'Premium Auto', # (EX-2300)
            47 => 'Painting', # (EX-2300)
            49 => 'Crayon Drawing', # (EX-2300)
            51 => 'Panorama', # (EX-ZR10)
            52 => 'Art HDR', # (EX-ZR10)
        },
    },
    0x301c => { #3
        Name => 'SequenceNumber', # for continuous shooting
        Writable => 'int16u',
    },
    0x301d => { #3
        Name => 'BracketSequence',
        Writable => 'int16u',
        Count => 2,
    },
    # 0x301e - MultiBracket ? (ref 3)
    0x3020 => { #3
        Name => 'ImageStabilization',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Off',
            1 => 'On',
            2 => 'Best Shot',
            # 3 observed in MOV videos (EX-V7)
            # (newer models write 2 numbers here - PH)
            '0 0' => 'Off', #PH
            # have seen '0 1' for EX-Z2000 which has 5 modes: Auto, Camera AS, Image AS, DEMO, Off
            '16 0' => 'Slow Shutter', #PH (EX-Z77)
            '18 0' => 'Anti-Shake', #PH (EX-Z77)
            '20 0' => 'High Sensitivity', #PH (EX-Z77)
            '0 3' => 'CCD Shift', #PH (guess)
            '2 3' => 'High Speed Anti-Shake', #PH (EX-FC150)
        },
    },
    0x302a => { #PH (EX-Z450)
        Name => 'LightingMode', #(just guessing here)
        Writable => 'int16u',
        PrintConv => {
            0 => 'Off',
            1 => 'High Dynamic Range', # (EX-Z77 anti-blur shot)
            5 => 'Shadow Enhance Low', #(NC)
            6 => 'Shadow Enhance High', #(NC)
        },
    },
    0x302b => { #PH (EX-Z77)
        Name => 'PortraitRefiner',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Off',
            1 => '+1',
            2 => '+2',
        },
    },
    0x3030 => { #PH (EX-Z450)
        Name => 'SpecialEffectLevel',
        Writable => 'int16u',
    },
    0x3031 => { #PH (EX-Z450)
        Name => 'SpecialEffectSetting',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Off',
            1 => 'Makeup',
            2 => 'Mist Removal',
            3 => 'Vivid Landscape',
            16 => 'Art Shot', # (EX-Z2300)
        },
    },
    0x3103 => { #5
        Name => 'DriveMode',
        Writable => 'int16u',
        PrintConvColumns => 2,
        PrintConv => {
            OTHER => sub {
                # handle new values of future models
                my ($val, $inv) = @_;
                return $val =~ /(\d+)/ ? $1 : undef if $inv;
                return "Continuous ($val fps)";
            },
            0 => 'Single Shot', #PH (NC)
            1 => 'Continuous Shooting', # (1 fps for the EX-F1)
            2 => 'Continuous (2 fps)',
            3 => 'Continuous (3 fps)',
            4 => 'Continuous (4 fps)',
            5 => 'Continuous (5 fps)',
            6 => 'Continuous (6 fps)',
            7 => 'Continuous (7 fps)',
            10 => 'Continuous (10 fps)',
            12 => 'Continuous (12 fps)',
            15 => 'Continuous (15 fps)',
            20 => 'Continuous (20 fps)',
            30 => 'Continuous (30 fps)',
            40 => 'Continuous (40 fps)', #PH (EX-FH25)
            60 => 'Continuous (60 fps)',
            240 => 'Auto-N',
        },
    },
    0x4001 => { #PH (AVI videos)
        Name => 'CaptureFrameRate',
        Writable => 'int16u',
        Count => -1,
        ValueConv => q{
            my @v=split(" ",$val);
            return $val / 1000 if @v == 1;
            return $v[1] ? "$v[1]-$v[0]" : ($v[0] > 10000 ? $v[0] / 1000 : $v[0]);
        },
        ValueConvInv => '$val <= 60 ? $val * 1000 : int($val) . " 0"',
    },
    # 0x4002 - AVI videos, related to video quality or size - PH
    0x4003 => { #PH (AVI and MOV videos)
        Name => 'VideoQuality',
        Writable => 'int16u',
        PrintConv => {
            1 => 'Standard',
            # 2 - could this be LP?
            3 => 'HD (720p)',
            4 => 'Full HD (1080p)', # (EX-ZR10, 30fps 1920x1080)
            5 => 'Low', # used in High Speed modes
        },
    },
);

# Casio APP1 QVCI segment found in QV-7000SX images (ref PH)
%Image::ExifTool::Casio::QVCI = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    FIRST_ENTRY => 0,
    NOTES => q{
        This information is found in the APP1 QVCI segment of JPEG images from the
        Casio QV-7000SX.
    },
    0x2c => {
        Name => 'CasioQuality',
        PrintConv => {
            1 => 'Economy',
            2 => 'Normal',
            3 => 'Fine',
            4 => 'Super Fine',
        },
    },
    0x37 => {
        Name => 'FocalRange',
        Unknown => 1,
    },
    0x4d => {
        Name => 'DateTimeOriginal',
        Description => 'Date/Time Original',
        Format => 'string[20]',
        Groups => { 2 => 'Time' },
        ValueConv => '$val=~tr/./:/; $val=~s/(\d+:\d+:\d+):/$1 /; $val',
        PrintConv => '$self->ConvertDateTime($val)',
    },
    0x62 => {
        Name => 'ModelType',
        Format => 'string[7]',
    },
    0x72 => { # could be serial number or manufacture date in form YYMMDDxx ?
        Name => 'ManufactureIndex',
        Format => 'string[9]',
    },
    0x7c => {
        Name => 'ManufactureCode',
        Format => 'string[9]',
    },
);

# tags in Casio AVI videos (ref PH)
%Image::ExifTool::Casio::AVI = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    FIRST_ENTRY => 0,
    NOTES => 'This information is found in Casio GV-10 AVI videos.',
    0 => {
        Name => 'Software', # (equivalent to RIFF Software tag)
        Format => 'string',
    },
);


1;  # end

__END__

=head1 NAME

Image::ExifTool::Casio - Casio EXIF maker notes tags

=head1 SYNOPSIS

This module is loaded automatically by Image::ExifTool when required.

=head1 DESCRIPTION

This module contains definitions required by Image::ExifTool to interpret
Casio maker notes in EXIF information.

=head1 AUTHOR

Copyright 2003-2011, Phil Harvey (phil at owl.phy.queensu.ca)

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 REFERENCES

=over 4

=item L<http://park2.wakwak.com/~tsuruzoh/Computer/Digicams/exif-e.html>

=back

=head1 ACKNOWLEDGEMENTS

Thanks to Joachim Loehr for adding support for the type 2 maker notes, and
Jens Duttke and Robert Chi for decoding some tags.

=head1 SEE ALSO

L<Image::ExifTool::TagNames/Casio Tags>,
L<Image::ExifTool(3pm)|Image::ExifTool>

=cut
