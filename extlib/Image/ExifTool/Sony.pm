#------------------------------------------------------------------------------
# File:         Sony.pm
#
# Description:  Sony EXIF Maker Notes tags
#
# Revisions:    04/06/2004  - P. Harvey Created
#
# References:   1) http://www.cybercom.net/~dcoffin/dcraw/
#               2) http://homepage3.nifty.com/kamisaka/makernote/makernote_sony.htm (2006/08/06)
#               3) Thomas Bodenmann private communication
#               4) Philippe Devaux private communication (A700)
#               5) Marcus Holland-Moritz private communication (A700)
#               6) Andrey Tverdokhleb private communication
#               7) Rudiger Lange private communication (A700)
#               8) Igal Milchtaich private communication
#               9) Michael Reitinger private communication (DSC-TX7)
#               10) http://www.klingebiel.com/tempest/hd/pmp.html
#               11 Mike Battilana private communication
#               JD) Jens Duttke private communication
#------------------------------------------------------------------------------

package Image::ExifTool::Sony;

use strict;
use vars qw($VERSION);
use Image::ExifTool qw(:DataAccess :Utils);
use Image::ExifTool::Exif;
use Image::ExifTool::Minolta;

$VERSION = '1.49';

sub ProcessSRF($$$);
sub ProcessSR2($$$);
sub WriteSR2($$$);

my %sonyLensTypes;  # filled in based on Minolta LensType's

# ExposureProgram values (ref PH, mainly decoded from A200)
my %sonyExposureProgram = (
    0 => 'Auto', # (same as 'Program AE'?)
    1 => 'Manual',
    2 => 'Program AE',
    3 => 'Aperture-priority AE',
    4 => 'Shutter speed priority AE',
    8 => 'Program Shift A', #7
    9 => 'Program Shift S', #7
    19 => 'Night Portrait', # (A330)
    18 => 'Sunset', # (A330)
    17 => 'Sports', # (A330)
    21 => 'Macro', # (A330)
    20 => 'Landscape', # (A330)
    16 => 'Portrait', # (A330)
    35 => 'Auto No Flash', # (A330)
);

my %binaryDataAttrs = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    WRITE_PROC => \&Image::ExifTool::WriteBinaryData,
    CHECK_PROC => \&Image::ExifTool::CheckBinaryData,
    WRITABLE => 1,
    FIRST_ENTRY => 0,
);

%Image::ExifTool::Sony::Main = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    0x0102 => { #5/JD
        Name => 'Quality',
        Writable => 'int32u',
        PrintConv => {
            0 => 'RAW',
            1 => 'Super Fine',
            2 => 'Fine',
            3 => 'Standard',
            4 => 'Economy',
            5 => 'Extra Fine',
            6 => 'RAW + JPEG',
            7 => 'Compressed RAW',
            8 => 'Compressed RAW + JPEG',
        },
    },
    0x0104 => { #5/JD
        Name => 'FlashExposureComp',
        Description => 'Flash Exposure Compensation',
        Writable => 'rational64s',
    },
    0x0105 => { #5/JD
        Name => 'Teleconverter',
        Writable => 'int32u',
        PrintHex => 1,
        PrintConv => {
            0 => 'None',
            72 => 'Minolta AF 2x APO (D)',
            80 => 'Minolta AF 2x APO II',
            136 => 'Minolta AF 1.4x APO (D)',
            144 => 'Minolta AF 1.4x APO II',
        },
    },
    0x0112 => { #JD
        Name => 'WhiteBalanceFineTune',
        Format => 'int32s',
        Writable => 'int32u',
    },
    0x0114 => [ #PH
        {
            Name => 'CameraSettings',
            Condition => '$$self{Model} =~ /DSLR-A(200|230|300|350|700|850|900)\b/',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Sony::CameraSettings',
                ByteOrder => 'BigEndian',
            },
        },
        {
            Name => 'CameraSettings2',
            Condition => '$$self{Model} =~ /DSLR-A(330|380)\b/',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Sony::CameraSettings2',
                ByteOrder => 'BigEndian',
            },
        },
        {
            Name => 'CameraSettingsUnknown',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Sony::CameraSettingsUnknown',
                ByteOrder => 'BigEndian',
            },
        },
    ],
    0x0115 => { #JD
        Name => 'WhiteBalance',
        Writable => 'int32u',
        PrintHex => 1,
        PrintConv => {
            0x00 => 'Auto',
            0x01 => 'Color Temperature/Color Filter',
            0x10 => 'Daylight',
            0x20 => 'Cloudy',
            0x30 => 'Shade',
            0x40 => 'Tungsten',
            0x50 => 'Flash',
            0x60 => 'Fluorescent',
            0x70 => 'Custom',
        },
    },
    0x0e00 => {
        Name => 'PrintIM',
        Description => 'Print Image Matching',
        SubDirectory => {
            TagTable => 'Image::ExifTool::PrintIM::Main',
        },
    },
    # the next 3 tags have a different meaning for some models (with format int32u)
    0x1000 => { #9 (F88, multi burst mode only)
        Name => 'MultiBurstMode',
        Condition => '$format eq "undef"',
        Notes => 'MultiBurst tags valid only for models with this feature, like the F88',
        Writable => 'undef',
        Format => 'int8u',
        PrintConv => { 0 => 'Off', 1 => 'On' },
    },
    0x1001 => { #9 (F88, multi burst mode only)
        Name => 'MultiBurstImageWidth',
        Condition => '$format eq "int16u"',
        Writable => 'int16u',
    },
    0x1002 => { #9 (F88, multi burst mode only)
        Name => 'MultiBurstImageHeight',
        Condition => '$format eq "int16u"',
        Writable => 'int16u',
    },
    0x1003 => { #9 (TX7, panorama mode only)
        Name => 'Panorama',
        SubDirectory => { TagTable => 'Image::ExifTool::Sony::Panorama' },
    },
    0x2001 => { #PH (JPEG images from all DSLR's except the A100)
        Name => 'PreviewImage',
        Writable => 'undef',
        DataTag => 'PreviewImage',
        # Note: the preview data starts with a 32-byte proprietary Sony header
        WriteCheck => 'return $val=~/^(none|.{32}\xff\xd8\xff)/s ? undef : "Not a valid image"',
        RawConv => q{
            return \$val if $val =~ /^Binary/;
            $val = substr($val,0x20) if length($val) > 0x20;
            return \$val if $val =~ s/^.(\xd8\xff\xdb)/\xff$1/s;
            $$self{PreviewError} = 1 unless $val eq 'none';
            return undef;
        },
        # must construct 0x20-byte header which contains length, width and height
        ValueConvInv => q{
            return 'none' unless $val;
            my $e = new Image::ExifTool;
            my $info = $e->ImageInfo(\$val,'ImageWidth','ImageHeight');
            return undef unless $$info{ImageWidth} and $$info{ImageHeight};
            my $size = Set32u($$info{ImageWidth}) . Set32u($$info{ImageHeight});
            return Set32u(length $val) . $size . ("\0" x 8) . $size . ("\0" x 4) . $val;
        },
    },
    # 0x2002 - probably Sharpness (PH guess)
    0x2004 => { #PH (NEX-5)
        Name => 'Contrast',
        Writable => 'int32s',
        PrintConv => '$val > 0 ? "+$val" : $val',
        PrintConvInv => '$val',
    },
    0x2005 => { #PH (NEX-5)
        Name => 'Saturation',
        Writable => 'int32s',
        PrintConv => '$val > 0 ? "+$val" : $val',
        PrintConvInv => '$val',
    },
    0x2006 => { #PH
        Name => 'Sharpness',
        Writable => 'int32s',
        PrintConv => '$val > 0 ? "+$val" : $val',
        PrintConvInv => '$val',
    },
    0x2007 => { #PH
        Name => 'Brightness',
        Writable => 'int32s',
        PrintConv => '$val > 0 ? "+$val" : $val',
        PrintConvInv => '$val',
    },
    0x2008 => { #PH
        Name => 'LongExposureNoiseReduction',
        Writable => 'int32u',
        PrintHex => 1,
        PrintConv => {
            0 => 'Off',
            1 => 'On',
            0xffff0000 => 'Off 2',
            0xffff0001 => 'On 2',
        },
    },
    0x2009 => { #PH
        Name => 'HighISONoiseReduction',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Off',
            1 => 'Low',
            2 => 'Normal',
            3 => 'High',
            256 => 'Auto',
        },
    },
    0x200a => { #PH (A550)
        Name => 'HDR',
        Writable => 'int32u',
        PrintHex => 1,
        PrintConv => {
            0x0 => 'Off',
            0x10001 => 'Auto',
            0x10010 => '1.0 EV', # (NEX_5)
            0x10011 => '1.5 EV',
            0x10012 => '2.0 EV',
            0x10013 => '2.5 EV',
            0x10014 => '3.0 EV',
            0x10015 => '3.5 EV',
            0x10016 => '4.0 EV',
            0x10017 => '4.5 EV',
            0x10018 => '5.0 EV',
            0x10019 => '5.5 EV',
            0x1001a => '6.0 EV', # (SLT-A55V)
        },
    },
    0x200b => { #PH
        Name => 'MultiFrameNoiseReduction',
        Writable => 'int32u',
        PrintConv => {
            0 => 'Off',
            1 => 'On',
            255 => 'n/a',
        },
    },
    0x3000 => {
        Name => 'ShotInfo',
        SubDirectory => {
            TagTable => 'Image::ExifTool::Sony::ShotInfo',
        },
    },
    # 0x3000: data block that includes DateTimeOriginal string
    0xb000 => { #8
        Name => 'FileFormat',
        Writable => 'int8u',
        Count => 4,
        # dynamically set the file type to SR2 because we could have assumed ARW up till now
        RawConv => q{
            $self->OverrideFileType($$self{TIFF_TYPE} = 'SR2') if $val eq '1 0 0 0';
            return $val;
        },
        PrintConv => {
            '0 0 0 2' => 'JPEG',
            '1 0 0 0' => 'SR2',
            '2 0 0 0' => 'ARW 1.0',
            '3 0 0 0' => 'ARW 2.0',
            '3 1 0 0' => 'ARW 2.1',
            '3 2 0 0' => 'ARW 2.2', # (NEX-5)
            # what about cRAW images?
        },
    },
    0xb001 => { # ref http://forums.dpreview.com/forums/read.asp?forum=1037&message=33609644
        # (ARW and SR2 images only)
        Name => 'SonyModelID',
        Writable => 'int16u',
        PrintConvColumns => 2,
        PrintConv => {
            2 => 'DSC-R1',
            256 => 'DSLR-A100',
            257 => 'DSLR-A900',
            258 => 'DSLR-A700',
            259 => 'DSLR-A200',
            260 => 'DSLR-A350',
            261 => 'DSLR-A300',
            263 => 'DSLR-A380/A390', #PH (A390)
            264 => 'DSLR-A330',
            265 => 'DSLR-A230',
            266 => 'DSLR-A290', #PH
            269 => 'DSLR-A850',
            273 => 'DSLR-A550',
            274 => 'DSLR-A500', #PH
            275 => 'DSLR-A450', # (http://dev.exiv2.org/issues/show/0000611)
            278 => 'NEX-5', #PH
            279 => 'NEX-3', #PH
            280 => 'SLT-A33', #PH
            281 => 'SLT-A55V', #PH
            282 => 'DSLR-A560', #PH
            283 => 'DSLR-A580', # (http://u88.n24.queensu.ca/exiftool/forum/index.php/topic,2881.0.html)
        },
    },
    0xb020 => { #2
        Name => 'ColorReproduction',
        # observed values: None, Standard, Vivid, Real, AdobeRGB - PH
        Writable => 'string',
    },
    0xb021 => { #2
        Name => 'ColorTemperature',
        Writable => 'int32u',
        PrintConv => '$val ? $val : "Auto"',
        PrintConvInv => '$val=~/Auto/i ? 0 : $val',
    },
    0xb022 => { #7
        Name => 'ColorCompensationFilter',
        Format => 'int32s',
        Writable => 'int32u', # (written incorrectly as unsigned by Sony)
        Notes => 'negative is green, positive is magenta',
    },
    0xb023 => { #PH (A100) - (set by mode dial)
        Name => 'SceneMode',
        Writable => 'int32u',
        PrintConv => \%Image::ExifTool::Minolta::minoltaSceneMode,
    },
    0xb024 => { #PH (A100)
        Name => 'ZoneMatching',
        Writable => 'int32u',
        PrintConv => {
            0 => 'ISO Setting Used',
            1 => 'High Key',
            2 => 'Low Key',
        },
    },
    0xb025 => { #PH (A100)
        Name => 'DynamicRangeOptimizer',
        Writable => 'int32u',
        PrintConv => {
            0 => 'Off',
            1 => 'Standard',
            2 => 'Advanced Auto',
            3 => 'Auto', # (A550)
            8 => 'Advanced Lv1', #JD
            9 => 'Advanced Lv2', #JD
            10 => 'Advanced Lv3', #JD
            11 => 'Advanced Lv4', #JD
            12 => 'Advanced Lv5', #JD
            16 => 'Lv1', # (NEX_5)
            17 => 'Lv2',
            18 => 'Lv3',
            19 => 'Lv4',
            20 => 'Lv5',
        },
    },
    0xb026 => { #PH (A100)
        Name => 'ImageStabilization',
        Writable => 'int32u',
        PrintConv => { 0 => 'Off', 1 => 'On' },
    },
    0xb027 => { #2
        Name => 'LensType',
        Writable => 'int32u',
        SeparateTable => 1,
        PrintConv => \%sonyLensTypes,
    },
    0xb028 => { #2
        # (used by the DSLR-A100)
        Name => 'MinoltaMakerNote',
        # must check for zero since apparently a value of zero indicates the IFD doesn't exist
        # (dumb Sony -- they shouldn't write this tag if the IFD is missing!)
        Condition => '$$valPt ne "\0\0\0\0"',
        Flags => 'SubIFD',
        SubDirectory => {
            TagTable => 'Image::ExifTool::Minolta::Main',
            Start => '$val',
        },
    },
    0xb029 => { #2 (set by creative style menu)
        Name => 'ColorMode',
        Writable => 'int32u',
        PrintConv => \%Image::ExifTool::Minolta::sonyColorMode,
    },
    0xb02b => { #PH (A550 JPEG and A200, A230, A300, A350, A380, A700 and A900 ARW)
        Name => 'FullImageSize',
        Writable => 'int32u',
        Count => 2,
        # values stored height first, so swap to get "width height"
        ValueConv => 'join(" ", reverse split(" ", $val))',
        ValueConvInv => 'join(" ", reverse split(" ", $val))',
        PrintConv => '$val =~ tr/ /x/; $val',
        PrintConvInv => '$val =~ tr/x/ /; $val',
    },
    0xb02c => { #PH (A550 JPEG and A200, A230, A300, A350, A380, A700 and A900 ARW)
        Name => 'PreviewImageSize',
        Writable => 'int32u',
        Count => 2,
        ValueConv => 'join(" ", reverse split(" ", $val))',
        ValueConvInv => 'join(" ", reverse split(" ", $val))',
        PrintConv => '$val =~ tr/ /x/; $val',
        PrintConvInv => '$val =~ tr/x/ /; $val',
    },
    0xb040 => { #2
        Name => 'Macro',
        Writable => 'int16u',
        RawConv => '$val == 65535 ? undef : $val',
        PrintConv => {
            0 => 'Off',
            1 => 'On',
            2 => 'Close Focus', #9
            65535 => 'n/a', #PH (A100)
        },
    },
    0xb041 => { #2
        Name => 'ExposureMode',
        Writable => 'int16u',
        RawConv => '$val == 65535 ? undef : $val',
        PrintConv => {
            0 => 'Auto',
            1 => 'Portrait', #PH (HX1)
            2 => 'Beach', #9
            4 => 'Snow', #9
            5 => 'Landscape',
            6 => 'Program',
            7 => 'Aperture Priority',
            8 => 'Shutter Priority',
            9 => 'Night Scene / Twilight',#2/9
            10 => 'Hi-Speed Shutter', #9
            11 => 'Twilight Portrait', #9
            12 => 'Soft Snap', #9
            13 => 'Fireworks', #9
            14 => 'Smile Shutter', #9 (T200)
            15 => 'Manual',
            18 => 'High Sensitivity', #9
            20 => 'Advanced Sports Shooting', #9
            29 => 'Underwater', #9
            33 => 'Gourmet', #9
            34 => 'Panorama', #PH (HX1)
            35 => 'Handheld Twilight', #PH (HX1/TX1)
            36 => 'Anti Motion Blur', #PH (TX1)
            37 => 'Pet', #9
            38 => 'Backlight Correction HDR', #9
            65535 => 'n/a', #PH (A100)
        },
    },
    0xb042 => { #9
        Name => 'FocusMode',
        Writable => 'int16u',
        RawConv => '$val == 65535 ? undef : $val',
        PrintConv => {
            1 => 'AF-S', # (called Single-AF by Sony)
            2 => 'AF-C', # (called Monitor-AF by Sony)
            4 => 'Permanent-AF', # (TX7)
            65535 => 'n/a', #PH (A100)
        },
    },
    0xb043 => { #9
        Name => 'AFMode',
        Writable => 'int16u',
        RawConv => '$val == 65535 ? undef : $val',
        PrintConv => {
            0 => 'Default', # (takes this value after camera reset, but can't be set back once changed)
            1 => 'Multi AF',
            2 => 'Center AF',
            3 => 'Spot AF',
            4 => 'Flexible Spot AF', # (T200)
            6 => 'Touch AF',
            14 => 'Manual Focus', # (T200)
            15 => 'Face Detected', # (not set when in face detect mode and no faces detected)
            65535 => 'n/a', #PH (A100)
        },
    },
    0xb044 => { #9
        Name => 'AFIlluminator',
        Writable => 'int16u',
        RawConv => '$val == 65535 ? undef : $val',
        PrintConv => {
            0 => 'Off',
            1 => 'Auto',
            65535 => 'n/a', #PH (A100)
        },
    },
    0xb047 => { #2
        Name => 'Quality',
        Writable => 'int16u',
        RawConv => '$val == 65535 ? undef : $val',
        PrintConv => {
            0 => 'Normal',
            1 => 'Fine',
            65535 => 'n/a', #PH (A100)
        },
    },
    0xb048 => { #9
        Name => 'FlashLevel',
        Writable => 'int16s',
        RawConv => '$val == -1 ? undef : $val',
        PrintConv => {
            -32768 => 'Low',
            -1 => 'n/a', #PH (A100)
            0 => 'Normal',
            32767 => 'High',
        },
    },
    0xb049 => { #9
        Name => 'ReleaseMode',
        Writable => 'int16u',
        RawConv => '$val == 65535 ? undef : $val',
        PrintConv => {
            0 => 'Normal',
            2 => 'Burst',
            5 => 'Exposure Bracketing',
            6 => 'White Balance Bracketing', # (HX5)
            65535 => 'n/a', #PH (A100)
        },
    },
    0xb04a => { #9
        Name => 'SequenceNumber',
        Notes => 'shot number in continuous burst',
        Writable => 'int16u',
        RawConv => '$val == 65535 ? undef : $val',
        PrintConv => {
            0 => 'Single',
            65535 => 'n/a', #PH (A100)
            OTHER => sub { shift }, # pass all other numbers straight through
        },
    },
    0xb04b => { #2/PH
        Name => 'Anti-Blur',
        Writable => 'int16u',
        RawConv => '$val == 65535 ? undef : $val',
        PrintConv => {
            0 => 'Off',
            1 => 'On (Continuous)', #PH (NC)
            2 => 'On (Shooting)', #PH (NC)
            65535 => 'n/a',
        },
    },
    0xb04e => { #2
        Name => 'LongExposureNoiseReduction',
        Writable => 'int16u',
        RawConv => '$val == 65535 ? undef : $val',
        PrintConv => {
            0 => 'Off',
            1 => 'On',
            65535 => 'n/a', #PH (A100)
        },
    },
    0xb04f => { #PH (TX1)
        Name => 'DynamicRangeOptimizer',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Off',
            1 => 'Standard',
            2 => 'Plus',
        },
    },
    0xb052 => { #PH (TX1)
        Name => 'IntelligentAuto',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Off',
            1 => 'On',
            2 => 'Advanced', #9
        },
    },
    0xb054 => { #PH (TX1)
        Name => 'WhiteBalance',
        Writable => 'int16u',
        Priority => 0, # (until more values are filled in)
        PrintConv => {
            0 => 'Auto',
            4 => 'Manual',
            5 => 'Daylight',
            6 => 'Cloudy', #9
            7 => 'White Flourescent', #9      (Sony "Fluorescent 1 (White)")
            8 => 'Cool White Flourescent', #9 (Sony "Fluorescent 2 (Natural White)")
            9 => 'Day White Flourescent', #9  (Sony "Fluorescent 3 (Day White)")
            14 => 'Incandescent',
            15 => 'Flash', #9
            17 => 'Underwater 1 (Blue Water)', #9
            18 => 'Underwater 2 (Green Water)', #9
        },
    },
);

# "SEMC MS" maker notes
%Image::ExifTool::Sony::Ericsson = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Image' },
    NOTES => 'Maker notes found in images from some Sony Ericsson phones.',
    0x2000 => {
        Name => 'MakerNoteVersion',
        Writable => 'undef',
        Count => 4,
    },
    0x201 => {
        Name => 'PreviewImageStart',
        IsOffset => 1,
        MakerPreview => 1, # force preview inside maker notes
        OffsetPair => 0x202,
        DataTag => 'PreviewImage',
        Writable => 'int32u',
        Protected => 2,
        Notes => 'a small 320x200 preview image',
    },
    0x202 => {
        Name => 'PreviewImageLength',
        OffsetPair => 0x201,
        DataTag => 'PreviewImage',
        Writable => 'int32u',
        Protected => 2,
    },
);

# Camera settings (ref PH) (decoded mainly from A200)
%Image::ExifTool::Sony::CameraSettings = (
    %binaryDataAttrs,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    FORMAT => 'int16u',
    NOTES => q{
        Camera settings for the A200, A230, A300, A350, A700, A850 and A900.  Some
        tags are only valid for certain models.
    },
    0x04 => { #7 (A700, not valid for other models)
        Name => 'DriveMode',
        Condition => '$$self{Model} =~ /DSLR-A700\b/',
        Notes => 'A700 only',
        PrintConv => {
            1 => 'Single Frame',
            2 => 'Continuous High',
            4 => 'Self-timer 10 sec',
            5 => 'Self-timer 2 sec',
            7 => 'Continuous Bracketing',
            12 => 'Continuous Low',
            18 => 'White Balance Bracketing Low',
            19 => 'D-Range Optimizer Bracketing Low',
        },
    },
    0x06 => { #7 (A700, not valid for other models)
        Name => 'WhiteBalanceFineTune',
        Condition => '$$self{Model} =~ /DSLR-A700\b/',
        Format => 'int16s',
        Notes => 'A700 only',
    },
    0x10 => { #7 (A700, not confirmed for other models)
        Name => 'FocusMode',
        PrintConv => {
            0 => 'Manual',
            1 => 'AF-S',
            2 => 'AF-C',
            3 => 'AF-A',
        },
    },
    0x11 => { #JD (A700)
        Name => 'AFAreaMode',
        PrintConv => {
            0 => 'Wide',
            1 => 'Local',
            2 => 'Spot',
        },
    },
    0x12 => { #7 (A700, not confirmed for other models)
        Name => 'LocalAFAreaPoint',
        Format => 'int16u',
        Condition => '$$self{Model} !~ /DSLR-A230/',
        PrintConv => {
            1 => 'Center',
            2 => 'Top',
            3 => 'Top-Right',
            4 => 'Right',
            5 => 'Bottom-Right',
            6 => 'Bottom',
            7 => 'Bottom-Left',
            8 => 'Left',
            9 => 'Top-Left',
            10 => 'Far Right',
            11 => 'Far Left',
            # have seen value of 128 for A230, A330, A380 - PH
        },
    },
    0x15 => { #7
        Name => 'MeteringMode',
        Condition => '$$self{Model} !~ /DSLR-A230/',
        PrintConv => {
            1 => 'Multi-segment',
            2 => 'Center-weighted Average',
            4 => 'Spot',
        },
    },
    0x16 => {
        Name => 'ISOSetting',
        Condition => '$$self{Model} !~ /DSLR-A230/',
        # 0 indicates 'Auto' (I think)
        ValueConv => '$val ? exp(($val/8-6)*log(2))*100 : $val',
        ValueConvInv => '$val ? 8*(log($val/100)/log(2)+6) : $val',
        PrintConv => '$val ? sprintf("%.0f",$val) : "Auto"',
        PrintConvInv => '$val =~ /auto/i ? 0 : $val',
    },
    0x18 => { #7
        Name => 'DynamicRangeOptimizerMode',
        Condition => '$$self{Model} !~ /DSLR-A230/',
        PrintConv => {
            0 => 'Off',
            1 => 'Standard',
            2 => 'Advanced Auto',
            3 => 'Advanced Level',
            4097 => 'Auto', #PH (A550)
        },
    },
    0x19 => { #7
        Name => 'DynamicRangeOptimizerLevel',
        Condition => '$$self{Model} !~ /DSLR-A230/',
    },
    0x1a => { # style actually used (combination of mode dial + creative style menu)
        Name => 'CreativeStyle',
        Condition => '$$self{Model} !~ /DSLR-A230/',
        PrintConv => {
            1 => 'Standard',
            2 => 'Vivid',
            3 => 'Portrait',
            4 => 'Landscape',
            5 => 'Sunset',
            6 => 'Night View/Portrait',
            8 => 'B&W',
            9 => 'Adobe RGB', # A900
            11 => 'Neutral',
            12 => 'Clear', #7
            13 => 'Deep', #7
            14 => 'Light', #7
            15 => 'Autumn', #7
            16 => 'Sepia', #7
        },
    },
    0x1c => {
        Name => 'Sharpness',
        ValueConv => '$val - 10',
        ValueConvInv => '$val + 10',
        PrintConv => '$val > 0 ? "+$val" : $val',
        PrintConvInv => '$val',
    },
    0x1d => {
        Name => 'Contrast',
        ValueConv => '$val - 10',
        ValueConvInv => '$val + 10',
        PrintConv => '$val > 0 ? "+$val" : $val',
        PrintConvInv => '$val',
    },
    0x1e => {
        Name => 'Saturation',
        ValueConv => '$val - 10',
        ValueConvInv => '$val + 10',
        PrintConv => '$val > 0 ? "+$val" : $val',
        PrintConvInv => '$val',
    },
    0x1f => { #7
        Name => 'ZoneMatchingValue',
        Condition => '$$self{Model} !~ /DSLR-A230/',
        ValueConv => '$val - 10',
        ValueConvInv => '$val + 10',
        PrintConv => '$val > 0 ? "+$val" : $val',
        PrintConvInv => '$val',
    },
    0x22 => { #7
        Name => 'Brightness',
        Condition => '$$self{Model} !~ /DSLR-A230/',
        ValueConv => '$val - 10',
        ValueConvInv => '$val + 10',
        PrintConv => '$val > 0 ? "+$val" : $val',
        PrintConvInv => '$val',
    },
    0x23 => {
        Name => 'FlashMode',
        PrintConv => {
            0 => 'ADI',
            1 => 'TTL',
        },
    },
    0x28 => { #7
        Name => 'PrioritySetupShutterRelease',
        Condition => '$$self{Model} =~ /DSLR-A700\b/',
        Notes => 'A700 only',
        PrintConv => {
            0 => 'AF',
            1 => 'Release',
        },
    },
    0x29 => { #7
        Name => 'AFIlluminator',
        Condition => '$$self{Model} =~ /DSLR-A700\b/',
        Notes => 'A700 only',
        PrintConv => {
            0 => 'Auto',
            1 => 'Off',
        },
    },
    0x2a => { #7
        Name => 'AFWithShutter',
        Condition => '$$self{Model} =~ /DSLR-A700\b/',
        Notes => 'A700 only',
        PrintConv => { 0 => 'On', 1 => 'Off' },
    },
    0x2b => { #7
        Name => 'LongExposureNoiseReduction',
        Condition => '$$self{Model} =~ /DSLR-A700\b/',
        Notes => 'A700 only',
        PrintConv => { 0 => 'Off', 1 => 'On' },
    },
    0x2c => { #7
        Name => 'HighISONoiseReduction',
        Condition => '$$self{Model} =~ /DSLR-A700\b/',
        Notes => 'A700 only',
        0 => 'Normal',
        1 => 'Low',
        2 => 'High',
        3 => 'Off',
    },
    0x2d => { #7
        Name => 'ImageStyle',
        Condition => '$$self{Model} =~ /DSLR-A700\b/',
        Notes => 'A700 only',
        PrintConv => {
            1 => 'Standard',
            2 => 'Vivid',
            9 => 'Adobe RGB',
            11 => 'Neutral',
            129 => 'StyleBox1',
            130 => 'StyleBox2',
            131 => 'StyleBox3',
        },
    },
    # 0x2d - A900:1=?,4=?,129=std,130=vivid,131=neutral,132=portrait,133=landscape,134=b&w
    0x3c => {
        Name => 'ExposureProgram',
        Priority => 0,
        PrintConv => \%sonyExposureProgram,
    },
    0x3d => {
        Name => 'ImageStabilization',
        PrintConv => { 0 => 'Off', 1 => 'On' },
    },
    0x3f => { # (verified for A330/A380)
        Name => 'Rotation',
        PrintConv => {
            0 => 'Horizontal (normal)',
            1 => 'Rotate 90 CW', #(NC)
            2 => 'Rotate 270 CW',
        },
    },
    0x54 => {
        Name => 'SonyImageSize',
        PrintConv => {
            1 => 'Large',
            2 => 'Medium',
            3 => 'Small',
        },
    },
    0x55 => { #7
        Name => 'AspectRatio',
        PrintConv => {
            1 => '3:2',
            2 => '16:9',
        },
    },
    0x56 => { #PH/7
        Name => 'Quality',
        PrintConv => {
            0 => 'RAW',
            2 => 'CRAW',
            34 => 'RAW + JPEG',
            35 => 'CRAW + JPEG',
            16 => 'Extra Fine',
            32 => 'Fine',
            48 => 'Standard',
        },
    },
    0x58 => { #7
        Name => 'ExposureLevelIncrements',
        PrintConv => {
            33 => '1/3 EV',
            50 => '1/2 EV',
        },
    },            
);

# Camera settings (ref PH) (A330 and A380)
%Image::ExifTool::Sony::CameraSettings2 = (
    %binaryDataAttrs,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    FORMAT => 'int16u',
    NOTES => 'Camera settings for the A330 and A380.',
    0x10 => { #7 (A700, not confirmed for other models)
        Name => 'FocusMode',
        PrintConv => {
            0 => 'Manual',
            1 => 'AF-S',
            2 => 'AF-C',
            3 => 'AF-A',
        },
    },
    0x11 => { #JD (A700)
        Name => 'AFAreaMode',
        PrintConv => {
            0 => 'Wide',
            1 => 'Local',
            2 => 'Spot',
        },
    },
    0x12 => { #7 (A700, not confirmed for other models)
        Name => 'LocalAFAreaPoint',
        Format => 'int16u',
        PrintConv => {
            1 => 'Center',
            2 => 'Top',
            3 => 'Top-Right',
            4 => 'Right',
            5 => 'Bottom-Right',
            6 => 'Bottom',
            7 => 'Bottom-Left',
            8 => 'Left',
            9 => 'Top-Left',
            10 => 'Far Right',
            11 => 'Far Left',
            # see value of 128 for some models
        },
    },
    0x13 => {
        Name => 'MeteringMode',
        PrintConv => {
            1 => 'Multi-segment',
            2 => 'Center-weighted Average',
            4 => 'Spot',
        },
    },
    0x14 => { # A330/A380
        Name => 'ISOSetting',
        # 0 indicates 'Auto' (?)
        ValueConv => '$val ? exp(($val/8-6)*log(2))*100 : $val',
        ValueConvInv => '$val ? 8*(log($val/100)/log(2)+6) : $val',
        PrintConv => '$val ? sprintf("%.0f",$val) : "Auto"',
        PrintConvInv => '$val =~ /auto/i ? 0 : $val',
    },
    0x16 => {
        Name => 'DynamicRangeOptimizerMode',
        PrintConv => {
            0 => 'Off',
            1 => 'Standard',
            2 => 'Advanced Auto',
            3 => 'Advanced Level',
        },
    },
    0x17 => {
        Name => 'DynamicRangeOptimizerLevel',
    },
    0x18 => { # A380
        Name => 'CreativeStyle',
        PrintConv => {
            1 => 'Standard',
            2 => 'Vivid',
            3 => 'Portrait',
            4 => 'Landscape',
            5 => 'Sunset',
            6 => 'Night View/Portrait',
            8 => 'B&W',
            9 => 'Adobe RGB',
            11 => 'Neutral',
        },
    },
    0x19 => {
        Name => 'Sharpness',
        ValueConv => '$val - 10',
        ValueConvInv => '$val + 10',
        PrintConv => '$val > 0 ? "+$val" : $val',
        PrintConvInv => '$val',
    },
    0x1a => {
        Name => 'Contrast',
        ValueConv => '$val - 10',
        ValueConvInv => '$val + 10',
        PrintConv => '$val > 0 ? "+$val" : $val',
        PrintConvInv => '$val',
    },
    0x1b => {
        Name => 'Saturation',
        ValueConv => '$val - 10',
        ValueConvInv => '$val + 10',
        PrintConv => '$val > 0 ? "+$val" : $val',
        PrintConvInv => '$val',
    },
    0x23 => {
        Name => 'FlashMode',
        PrintConv => {
            0 => 'ADI',
            1 => 'TTL',
        },
    },
    # 0x27 - also related to CreativeStyle:
    #  A380:1=std,2=vivid,3=portrait,4=landscape,5=sunset,7=night view,8=b&w
    0x3c => {
        Name => 'ExposureProgram',
        Priority => 0,
        PrintConv => \%sonyExposureProgram,
    },
    0x3f => { # (verified for A330/A380)
        Name => 'Rotation',
        PrintConv => {
            0 => 'Horizontal (normal)',
            1 => 'Rotate 90 CW', #(NC)
            2 => 'Rotate 270 CW',
        },
    },
    0x54 => {
        Name => 'SonyImageSize',
        PrintConv => {
            1 => 'Large',
            2 => 'Medium',
            3 => 'Small',
        },
    },
    # 0x56 - something to do with JPEG quality?
);

# Camera settings for other models
%Image::ExifTool::Sony::CameraSettingsUnknown = (
    %binaryDataAttrs,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    FORMAT => 'int16u',
);

# shot information (ref PH)
%Image::ExifTool::Sony::ShotInfo = (
    %binaryDataAttrs,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Image' },
    DATAMEMBER => [ 0x02, 0x30, 0x32 ],
    IS_SUBDIR => [ 0x48, 0x5e ],
    # 0x00 - byte order 'II'
    0x02 => {
        Name => 'FaceInfoOffset',
        Format => 'int16u',
        DataMember => 'FaceInfoOffset',
        Writable => 0,
        RawConv => '$$self{FaceInfoOffset} = $val',
    },
    0x06 => {
        Name => 'SonyDateTime',
        Format => 'string[20]',
        Groups => { 2 => 'Time' },
        Shift => 'Time',
        PrintConv => '$self->ConvertDateTime($val)',
        PrintConvInv => '$self->InverseDateTime($val,0)',
    },
    0x30 => { #Jeffrey Friedl
        Name => 'FacesDetected',
        DataMember => 'FacesDetected',
        Format => 'int16u',
        RawConv => '$$self{FacesDetected} = $val',
    },
    0x32 => {
        Name => 'FaceInfoLength', # length of a single FaceInfo entry
        DataMember => 'FaceInfoLength',
        Format => 'int16u',
        Writable => 0,
        RawConv => '$$self{FaceInfoLength} = $val',
    },
    #0x34 => {
    #    # values: 'DC5303320222000', 'DC6303320222000' or 'DC7303320222000'
    #    Name => 'UnknownString',
    #    Format => 'string[16]',
    #    Unknown => 1,
    #},
    0x48 => { # (most models: DC5303320222000 and DC6303320222000)
        Name => 'FaceInfo1',
        Condition => q{
            $$self{FacesDetected} and
            $$self{FaceInfoOffset} == 0x48 and
            $$self{FaceInfoLength} == 0x20
        },
        SubDirectory => { TagTable => 'Image::ExifTool::Sony::FaceInfo1' },
    },
    0x5e => { # (HX7V: DC7303320222000)
        Name => 'FaceInfo2',
        Condition => q{
            $$self{FacesDetected} and
            $$self{FaceInfoOffset} == 0x5e and
            $$self{FaceInfoLength} == 0x25
        },
        SubDirectory => { TagTable => 'Image::ExifTool::Sony::FaceInfo2' },
    },
);

%Image::ExifTool::Sony::FaceInfo1 = (
    %binaryDataAttrs,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Image' },
    0x00 => {
        Name => 'Face1Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 1 ? undef : $val',
        Notes => q{
            top, left, height and width of detected face.  Coordinates are relative to
            the full-sized unrotated image, with increasing Y downwards
        },
    },
    0x20 => {
        Name => 'Face2Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 2 ? undef : $val',
    },
    0x40 => {
        Name => 'Face3Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 3 ? undef : $val',
    },
    0x60 => {
        Name => 'Face4Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 4 ? undef : $val',
    },
    0x80 => {
        Name => 'Face5Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 5 ? undef : $val',
    },
    0xa0 => {
        Name => 'Face6Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 6 ? undef : $val',
    },
    0xc0 => {
        Name => 'Face7Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 7 ? undef : $val',
    },
    0xe0 => {
        Name => 'Face8Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 8 ? undef : $val',
    },
);

%Image::ExifTool::Sony::FaceInfo2 = (
    %binaryDataAttrs,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Image' },
    0x00 => {
        Name => 'Face1Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 1 ? undef : $val',
        Notes => q{
            top, left, height and width of detected face.  Coordinates are relative to
            the full-sized unrotated image, with increasing Y downwards
        },
    },
    0x25 => {
        Name => 'Face2Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 2 ? undef : $val',
    },
    0x4a => {
        Name => 'Face3Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 3 ? undef : $val',
    },
    0x6f => {
        Name => 'Face4Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 4 ? undef : $val',
    },
    0x94 => {
        Name => 'Face5Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 5 ? undef : $val',
    },
    0xb9 => {
        Name => 'Face6Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 6 ? undef : $val',
    },
    0xde => {
        Name => 'Face7Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 7 ? undef : $val',
    },
    0x103 => {
        Name => 'Face8Position',
        Format => 'int16u[4]',
        RawConv => '$$self{FacesDetected} < 8 ? undef : $val',
    },
);

# panorama info for cameras such as the HX1, HX5, TX7 (ref 9/PH)
%Image::ExifTool::Sony::Panorama = (
    %binaryDataAttrs,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Image' },
    FORMAT => 'int32u',
    NOTES => q{
        Tags found only in panorama images from Sony cameras such as the HX1, HX5
        and TX7.  The width/height values of these tags are not affected by camera
        rotation -- the width is always the longer dimension.
    },
    # 0: 257
    1 => 'PanoramaFullWidth', # (including black/grey borders)
    2 => 'PanoramaFullHeight',
    3 => {
        Name => 'PanoramaDirection',
        PrintConv => {
            0 => 'Right to Left',
            1 => 'Left to Right',
        },
    },
    # crop area to remove black/grey borders from full image
    4 => 'PanoramaCropLeft',
    5 => 'PanoramaCropTop', #PH guess (NC)
    6 => 'PanoramaCropRight',
    7 => 'PanoramaCropBottom',
    # 8: 1728 (HX1), 1824 (HX5/TX7) (value8/value9 = 16/9)
    8 => 'PanoramaFrameWidth', #PH guess (NC)
    # 9: 972 (HX1), 1026 (HX5/TX7)
    9 => 'PanoramaFrameHeight', #PH guess (NC)
    # 10: 3200-3800 (HX1), 4000-4900 (HX5/TX7)
    10 => 'PanoramaSourceWidth', #PH guess (NC)
    # 11: 800-1800 (larger for taller panoramas)
    11 => 'PanoramaSourceHeight', #PH guess (NC)
    # 12-15: 0
);

# tag table for SRF0 IFD (ref 1)
%Image::ExifTool::Sony::SRF = (
    PROCESS_PROC => \&ProcessSRF,
    GROUPS => { 0 => 'MakerNotes', 1 => 'SRF#', 2 => 'Camera' },
    NOTES => q{
        The maker notes in SRF (Sony Raw Format) images contain 7 IFD's with family
        1 group names SRF0 through SRF6.  SRF0 and SRF1 use the tags in this table,
        while SRF2 through SRF5 use the tags in the next table, and SRF6 uses
        standard EXIF tags.  All information other than SRF0 is encrypted, but
        thanks to Dave Coffin the decryption algorithm is known.  SRF images are
        written by the Sony DSC-F828 and DSC-V3.
    },
    # tags 0-1 are used in SRF1
    0 => {
        Name => 'SRF2Key',
        Notes => 'key to decrypt maker notes from the start of SRF2',
        RawConv => '$self->{SRF2Key} = $val',
    },
    1 => {
        Name => 'DataKey',
        Notes => 'key to decrypt the rest of the file from the end of the maker notes',
        RawConv => '$self->{SRFDataKey} = $val',
    },
    # SRF0 contains a single unknown tag with TagID 0x0003
);

# tag table for Sony RAW Format (ref 1)
%Image::ExifTool::Sony::SRF2 = (
    PROCESS_PROC => \&ProcessSRF,
    GROUPS => { 0 => 'MakerNotes', 1 => 'SRF#', 2 => 'Camera' },
    NOTES => "These tags are found in the SRF2 through SRF5 IFD's.",
    # the following tags are used in SRF2-5
    2 => 'SRF6Offset', #PH
    # SRFDataOffset references 2220 bytes of unknown data for the DSC-F828 - PH
    3 => { Name => 'SRFDataOffset', Unknown => 1 }, #PH
    4 => { Name => 'RawDataOffset' }, #PH
    5 => { Name => 'RawDataLength' }, #PH
);

# tag table for Sony RAW 2 Format Private IFD (ref 1)
%Image::ExifTool::Sony::SR2Private = (
    PROCESS_PROC => \&ProcessSR2,
    WRITE_PROC => \&WriteSR2,
    GROUPS => { 0 => 'MakerNotes', 1 => 'SR2', 2 => 'Camera' },
    NOTES => q{
        The SR2 format uses the DNGPrivateData tag to reference a private IFD
        containing these tags.  SR2 images are written by the Sony DSC-R1, but
        this information is also written to ARW images by other models.
    },
    0x7200 => {
        Name => 'SR2SubIFDOffset',
        # (adjusting offset messes up calculations for AdobeSR2 in DNG images)
        # Flags => 'IsOffset',
        # (can't set OffsetPair or else DataMember won't be set when writing)
        # OffsetPair => 0x7201,
        DataMember => 'SR2SubIFDOffset',
        RawConv => '$$self{SR2SubIFDOffset} = $val',
    },
    0x7201 => {
        Name => 'SR2SubIFDLength',
        # (can't set OffsetPair or else DataMember won't be set when writing)
        # OffsetPair => 0x7200,
        DataMember => 'SR2SubIFDLength',
        RawConv => '$$self{SR2SubIFDLength} = $val',
    },
    0x7221 => {
        Name => 'SR2SubIFDKey',
        Format => 'int32u',
        Notes => 'key to decrypt SR2SubIFD',
        DataMember => 'SR2SubIFDKey',
        RawConv => '$$self{SR2SubIFDKey} = $val',
        PrintConv => 'sprintf("0x%.8x", $val)',
    },
    0x7240 => { #PH
        Name => 'IDC_IFD',
        Groups => { 1 => 'SonyIDC' },
        Condition => '$$valPt !~ /^\0\0\0\0/',   # (just in case this could be zero)
        Flags => 'SubIFD',
        SubDirectory => {
            DirName => 'SonyIDC',
            TagTable => 'Image::ExifTool::SonyIDC::Main',
            Start => '$val',
        },
    },
    0x7241 => { #PH
        Name => 'IDC2_IFD',
        Groups => { 1 => 'SonyIDC' },
        Condition => '$$valPt !~ /^\0\0\0\0/',   # may be zero if dir doesn't exist
        Flags => 'SubIFD',
        SubDirectory => {
            DirName => 'SonyIDC2',
            TagTable => 'Image::ExifTool::SonyIDC::Main',
            Start => '$val',
            Base => '$start',
            MaxSubdirs => 20,   # (A900 has 10 null entries, but IDC writes only 1)
            RelativeBase => 1,  # needed to write SubIFD with relative offsets
        },
    },
    0x7250 => { #1
        Name => 'MRWInfo',
        Condition => '$$valPt !~ /^\0\0\0\0/',   # (just in case this could be zero)
        SubDirectory => {
            TagTable => 'Image::ExifTool::MinoltaRaw::Main',
        },
    },
);

%Image::ExifTool::Sony::SR2SubIFD = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    GROUPS => { 0 => 'MakerNotes', 1 => 'SR2SubIFD', 2 => 'Camera' },
    SET_GROUP1 => 1, # set group1 name to directory name for all tags in table
    NOTES => 'Tags in the encrypted SR2SubIFD',
    0x7303 => 'WB_GRBGLevels', #1
    0x74c0 => { #PH
        Name => 'SR2DataIFD',
        Groups => { 1 => 'SR2DataIFD' }, # (needed to set SubIFD DirName)
        Flags => 'SubIFD',
        SubDirectory => {
            TagTable => 'Image::ExifTool::Sony::SR2DataIFD',
            Start => '$val',
            MaxSubdirs => 20, # an A700 ARW has 14 of these! - PH
        },
    },
    0x7313 => 'WB_RGGBLevels', #6
    0x74a0 => 'MaxApertureAtMaxFocal', #PH
    0x74a1 => 'MaxApertureAtMinFocal', #PH
    0x7820 => 'WB_RGBLevelsDaylight', #6
    0x7821 => 'WB_RGBLevelsCloudy', #6
    0x7822 => 'WB_RGBLevelsTungsten', #6
    0x7825 => 'WB_RGBLevelsShade', #6
    0x7826 => 'WB_RGBLevelsFluorescent', #6
    0x7828 => 'WB_RGBLevelsFlash', #6
);

%Image::ExifTool::Sony::SR2DataIFD = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    GROUPS => { 0 => 'MakerNotes', 1 => 'SR2DataIFD', 2 => 'Camera' },
    SET_GROUP1 => 1, # set group1 name to directory name for all tags in table
    # 0x7313 => 'WB_RGGBLevels', (duplicated in all SR2DataIFD's)
    0x7770 => { #PH
        Name => 'ColorMode',
        Priority => 0,
    },
);

# tags found in DSC-F1 PMP header (ref 10)
%Image::ExifTool::Sony::PMP = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    WRITE_PROC => \&Image::ExifTool::WriteBinaryData,
    CHECK_PROC => \&Image::ExifTool::CheckBinaryData,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Image' },
    FIRST_ENTRY => 0,
    NOTES => q{
        These tags are written in the proprietary-format header of PMP images from
        the DSC-F1.
    },
    8 => { #PH
        Name => 'JpgFromRawStart',
        Format => 'int32u',
        Notes => q{
            OK, not really a RAW file, but this mechanism is used to allow extraction of
            the JPEG image from a PMP file
        },
    },
    12 => { Name => 'JpgFromRawLength',Format => 'int32u' },
    22 => { Name => 'SonyImageWidth',  Format => 'int16u' },
    24 => { Name => 'SonyImageHeight', Format => 'int16u' },
    27 => {
        Name => 'Orientation',
        PrintConv => {
            0 => 'Horizontal (normal)',
            1 => 'Rotate 270 CW',#11
            2 => 'Rotate 180',
            3 => 'Rotate 90 CW',#11
        },
    },
    29 => {
        Name => 'ImageQuality',
        PrintConv => {
            8 => 'Snap Shot',
            23 => 'Standard',
            51 => 'Fine',
        },
    },
    # 40 => ImageWidth again (int16u)
    # 42 => ImageHeight again (int16u)
    52 => { Name => 'Comment',         Format => 'string[19]' },
    76 => {
        Name => 'DateTimeOriginal',
        Description => 'Date/Time Original',
        Format => 'int8u[6]',
        Groups => { 2 => 'Time' },
        ValueConv => q{
            my @a = split ' ', $val;
            $a[0] += $a[0] < 70 ? 2000 : 1900;
            sprintf('%.4d:%.2d:%.2d %.2d:%.2d:%.2d', @a);
        },
        PrintConv => '$self->ConvertDateTime($val)',
    },
    84 => {
        Name => 'ModifyDate',
        Format => 'int8u[6]',
        Groups => { 2 => 'Time' },
        ValueConv => q{
            my @a = split ' ', $val;
            $a[0] += $a[0] < 70 ? 2000 : 1900;
            sprintf('%.4d:%.2d:%.2d %.2d:%.2d:%.2d', @a);
        },
        PrintConv => '$self->ConvertDateTime($val)',
    },
    102 => {
        Name => 'ExposureTime',
        Format => 'int16s',
        RawConv => '$val <= 0 ? undef : $val',
        ValueConv => '2 ** (-$val / 100)',
        PrintConv => 'Image::ExifTool::Exif::PrintExposureTime($val)',
    },
    106 => { # (NC -- not written by DSC-F1)
        Name => 'FNumber',
        Format => 'int16s',
        RawConv => '$val <= 0 ? undef : $val',
        ValueConv => '$val / 100', # (likely wrong)
    },
    108 => { # (NC -- not written by DSC-F1)
        Name => 'ExposureCompensation',
        Format => 'int16s',
        RawConv => '($val == -1 or $val == -32768) ? undef : $val',
        ValueConv => '$val / 100', # (probably wrong too)
    },
    112 => { # (NC -- not written by DSC-F1)
        Name => 'FocalLength',
        Format => 'int16s',
        Groups => { 2 => 'Camera' },
        RawConv => '$val <= 0 ? undef : $val',
        ValueConv => '$val / 100',
        PrintConv => 'sprintf("%.1f mm",$val)',
    },
    118 => {
        Name => 'Flash',
        Groups => { 2 => 'Camera' },
        PrintConv => { 0 => 'No Flash', 1 => 'Fired' },
    },
);

# fill in Sony LensType lookup based on Minolta values
{
    my $minoltaTypes = \%Image::ExifTool::Minolta::minoltaLensTypes;
    %sonyLensTypes = %$minoltaTypes;
    my $notes = $$minoltaTypes{Notes};
    delete $$minoltaTypes{Notes};
    my $id;
    foreach $id (sort { $a <=> $b } keys %$minoltaTypes) {
        # higher numbered lenses are missing last digit of ID for some Sony models
        next if $id < 10000;
        my $sid = int($id/10);
        my $i;
        my $lens = $$minoltaTypes{$id};
        if ($sonyLensTypes{$sid}) {
            # put lens name with "or" first in list
            if ($lens =~ / or /) {
                my $tmp = $sonyLensTypes{$sid};
                $sonyLensTypes{$sid} = $lens;
                $lens = $tmp;
            }
            for (;;) {
                $i = ($i || 0) + 1;
                $sid = int($id/10) . ".$i";
                last unless $sonyLensTypes{$sid};
            }
        }
        $sonyLensTypes{$sid} = $lens;
    }
    $$minoltaTypes{Notes} = $sonyLensTypes{Notes} = $notes;
}

#------------------------------------------------------------------------------
# Read Sony DSC-F1 PMP file
# Inputs: 0) ExifTool object ref, 1) dirInfo ref
# Returns: 1 on success when reading, 0 if this isn't a valid PMP file
sub ProcessPMP($$)
{
    my ($exifTool, $dirInfo) = @_;
    my $raf = $$dirInfo{RAF};
    my $buff;
    $raf->Read($buff, 128) == 128 or return 0;
    # validate header length (124 bytes)
    $buff =~ /^.{8}\0{3}\x7c.{112}\xff\xd8\xff\xdb$/s or return 0;
    $exifTool->SetFileType();
    SetByteOrder('MM');
    $exifTool->FoundTag(Make => 'Sony');
    $exifTool->FoundTag(Model => 'DSC-F1');
    # extract information from 124-byte header
    my $tagTablePtr = GetTagTable('Image::ExifTool::Sony::PMP');
    my %dirInfo = ( DataPt => \$buff, DirName => 'PMP' );
    $exifTool->ProcessDirectory(\%dirInfo, $tagTablePtr);
    # process JPEG image
    $raf->Seek(124, 0);
    $$dirInfo{Base} = 124;
    $exifTool->ProcessJPEG($dirInfo);
    return 1;
}

#------------------------------------------------------------------------------
# Decrypt Sony data (ref 1)
# Inputs: 0) data reference, 1) start offset, 2) data length, 3) decryption key
# Returns: nothing (original data buffer is updated with decrypted data)
# Notes: data length should be a multiple of 4
sub Decrypt($$$$)
{
    my ($dataPt, $start, $len, $key) = @_;
    my ($i, $j, @pad);
    my $words = int ($len / 4);

    for ($i=0; $i<4; ++$i) {
        my $lo = ($key & 0xffff) * 0x0edd + 1;
        my $hi = ($key >> 16) * 0x0edd + ($key & 0xffff) * 0x02e9 + ($lo >> 16);
        $pad[$i] = $key = (($hi & 0xffff) << 16) + ($lo & 0xffff);
    }
    $pad[3] = ($pad[3] << 1 | ($pad[0]^$pad[2]) >> 31) & 0xffffffff;
    for ($i=4; $i<0x7f; ++$i) {
        $pad[$i] = (($pad[$i-4]^$pad[$i-2]) << 1 |
                    ($pad[$i-3]^$pad[$i-1]) >> 31) & 0xffffffff;
    }
    my @data = unpack("x$start N$words", $$dataPt);
    for ($i=0x7f,$j=0; $j<$words; ++$i,++$j) {
        $data[$j] ^= $pad[$i & 0x7f] = $pad[($i+1) & 0x7f] ^ $pad[($i+65) & 0x7f];
    }
    substr($$dataPt, $start, $words*4) = pack('N*', @data);
}

#------------------------------------------------------------------------------
# Set the ARW file type and decide between SubIFD and A100DataOffset
# Inputs: 0) ExifTool object ref, 1) reference to tag 0x14a raw data
# Returns: true if tag 0x14a is a SubIFD, false otherwise
sub SetARW($$)
{
    my ($exifTool, $valPt) = @_;

    # assume ARW for now -- SR2's get identified when FileFormat is parsed
    $exifTool->OverrideFileType($$exifTool{TIFF_TYPE} = 'ARW');

    # this should always be a SubIFD for models other than the A100
    return 1 unless $$exifTool{Model} eq 'DSLR-A100' and length $$valPt == 4;

    # for the A100, IFD0 tag 0x14a is either a pointer to the raw data if this is
    # an original image, or a SubIFD offset if the image was edited by Sony IDC,
    # so assume it points to the raw data if it isn't a valid IFD (this assumption
    # will be checked later when we try to parse the SR2Private directory)
    my %subdir = (
        DirStart => Get32u($valPt, 0),
        Base     => 0,
        RAF      => $$exifTool{RAF},
        AllowOutOfOrderTags => 1, # doh!
    );
    return Image::ExifTool::Exif::ValidateIFD(\%subdir);
}

#------------------------------------------------------------------------------
# Finish writing ARW image, patching necessary Sony quirks, etc
# Inputs: 0) ExifTool ref, 1) dirInfo ref, 2) EXIF data ref, 3) image data reference
# Returns: undef on success, error string otherwise
# Notes: (it turns that all of this is for the A100 only)
sub FinishARW($$$$)
{
    my ($exifTool, $dirInfo, $dataPt, $imageData) = @_;

    # pre-scan IFD0 to get IFD entry offsets for each tag
    my $dataLen = length $$dataPt;
    return 'Truncated IFD0' if $dataLen < 2;
    my $n = Get16u($dataPt, 0);
    return 'Truncated IFD0' if $dataLen < 2 + 12 * $n;
    my ($i, %entry, $dataBlock, $pad, $dataOffset);
    for ($i=0; $i<$n; ++$i) {
        my $entry = 2 + $i * 12;
        $entry{Get16u($dataPt, $entry)} = $entry;
    }
    # fix up SR2Private offset and A100DataOffset (A100 only)
    if ($entry{0xc634} and $$exifTool{MRWDirData}) {
        return 'Unexpected MRW block' unless $$exifTool{Model} eq 'DSLR-A100';
        return 'Missing A100DataOffset' unless $entry{0x14a} and $$exifTool{A100DataOffset};
        # account for total length of image data
        my $totalLen = 8 + $dataLen;
        if (ref $imageData) {
            foreach $dataBlock (@$imageData) {
                my ($pos, $size, $pad) = @$dataBlock;
                $totalLen += $size + $pad;
            }
        }
        # align MRW block on an even 4-byte boundary
        my $remain = $totalLen & 0x03;
        $pad = 4 - $remain and $totalLen += $pad if $remain;
        # set offset for the MRW directory data
        Set32u($totalLen, $dataPt, $entry{0xc634} + 8);
        # also pad MRWDirData data to an even 4 bytes (just to be safe)
        $remain = length($$exifTool{MRWDirData}) & 0x03;
        $$exifTool{MRWDirData} .= "\0" x (4 - $remain) if $remain;
        $totalLen += length $$exifTool{MRWDirData};
        # fix up A100DataOffset
        $dataOffset = $$exifTool{A100DataOffset};
        Set32u($totalLen, $dataPt, $entry{0x14a} + 8);
    }
    # patch double-referenced and incorrectly-sized A100 PreviewImage
    if ($entry{0x201} and $$exifTool{A100PreviewStart} and
        $entry{0x202} and $$exifTool{A100PreviewLength})
    {
        Set32u($$exifTool{A100PreviewStart}, $dataPt, $entry{0x201} + 8);
        Set32u($$exifTool{A100PreviewLength}, $dataPt, $entry{0x202} + 8);
    }
    # write TIFF IFD structure
    my $outfile = $$dirInfo{OutFile};
    my $header = GetByteOrder() . Set16u(0x2a) . Set32u(8);
    Write($outfile, $header, $$dataPt) or return 'Error writing';
    # copy over image data
    if (ref $imageData) {
        $exifTool->CopyImageData($imageData, $outfile) or return 'Error copying image data';
    }
    # write MRW data if necessary
    if ($$exifTool{MRWDirData}) {
        Write($outfile, "\0" x $pad) if $pad;   # write padding if necessary
        Write($outfile, $$exifTool{MRWDirData});
        delete $$exifTool{MRWDirData};
        # set TIFF_END to copy over the MRW image data
        $$exifTool{TIFF_END} = $dataOffset if $dataOffset;
    }
    return undef;
}

#------------------------------------------------------------------------------
# Process SRF maker notes
# Inputs: 0) ExifTool object ref, 1) dirInfo ref, 2) tag table ref
# Returns: 1 on success
sub ProcessSRF($$$)
{
    my ($exifTool, $dirInfo, $tagTablePtr) = @_;
    my $dataPt = $$dirInfo{DataPt};
    my $start = $$dirInfo{DirStart};
    my $verbose = $exifTool->Options('Verbose');

    # process IFD chain
    my ($ifd, $success);
    for ($ifd=0; ; ) {
        # switch tag table for SRF2-5 and SRF6
        if ($ifd == 2) {
            $tagTablePtr = GetTagTable('Image::ExifTool::Sony::SRF2');
        } elsif ($ifd == 6) {
            # SRF6 uses standard EXIF tags
            $tagTablePtr = GetTagTable('Image::ExifTool::Exif::Main');
        }
        my $srf = $$dirInfo{DirName} = "SRF$ifd";
        $exifTool->{SET_GROUP1} = $srf;
        $success = Image::ExifTool::Exif::ProcessExif($exifTool, $dirInfo, $tagTablePtr);
        delete $exifTool->{SET_GROUP1};
        last unless $success;
#
# get pointer to next IFD
#
        my $count = Get16u($dataPt, $$dirInfo{DirStart});
        my $dirEnd = $$dirInfo{DirStart} + 2 + $count * 12;
        last if $dirEnd + 4 > length($$dataPt);
        my $nextIFD = Get32u($dataPt, $dirEnd);
        last unless $nextIFD;
        $nextIFD -= $$dirInfo{DataPos}; # adjust for position of makernotes data
        $$dirInfo{DirStart} = $nextIFD;
#
# decrypt next IFD data if necessary
#
        ++$ifd;
        my ($key, $len);
        if ($ifd == 1) {
            # get the key to decrypt IFD1
            my $cp = $start + 0x8ddc;    # why?
            my $ip = $cp + 4 * unpack("x$cp C", $$dataPt);
            $key = unpack("x$ip N", $$dataPt);
            $len = $cp + $nextIFD;  # decrypt up to $cp
        } elsif ($ifd == 2) {
            # get the key to decrypt IFD2
            $key = $exifTool->{SRF2Key};
            $len = length($$dataPt) - $nextIFD; # decrypt rest of maker notes
        } else {
            next;   # no decryption needed
        }
        # decrypt data
        Decrypt($dataPt, $nextIFD, $len, $key) if defined $key;
        next unless $verbose > 2;
        # display decrypted data in verbose mode
        $exifTool->VerboseDir("Decrypted SRF$ifd", 0, $nextIFD + $len);
        $exifTool->VerboseDump($dataPt,
            Prefix => "$exifTool->{INDENT}  ",
            Start => $nextIFD,
            DataPos => $$dirInfo{DataPos},
        );
    }
}

#------------------------------------------------------------------------------
# Write SR2 data
# Inputs: 0) ExifTool object ref, 1) dirInfo ref, 2) tag table ref
# Returns: 1 on success when reading, or SR2 directory or undef when writing
sub WriteSR2($$$)
{
    my ($exifTool, $dirInfo, $tagTablePtr) = @_;
    $exifTool or return 1;      # allow dummy access
    my $buff = '';
    $$dirInfo{OutFile} = \$buff;
    return ProcessSR2($exifTool, $dirInfo, $tagTablePtr);
}

#------------------------------------------------------------------------------
# Read/Write SR2 IFD and its encrypted subdirectories
# Inputs: 0) ExifTool object ref, 1) dirInfo ref, 2) tag table ref
# Returns: 1 on success when reading, or SR2 directory or undef when writing
sub ProcessSR2($$$)
{
    my ($exifTool, $dirInfo, $tagTablePtr) = @_;
    my $raf = $$dirInfo{RAF};
    my $dataPt = $$dirInfo{DataPt};
    my $dataPos = $$dirInfo{DataPos};
    my $dataLen = $$dirInfo{DataLen} || length $$dataPt;
    my $base = $$dirInfo{Base} || 0;
    my $outfile = $$dirInfo{OutFile};

    # clear SR2 member variables to be safe
    delete $$exifTool{SR2SubIFDOffset};
    delete $$exifTool{SR2SubIFDLength};
    delete $$exifTool{SR2SubIFDKey};

    # make sure we have the first 4 bytes available to test directory type
    my $buff;
    if ($dataLen < 4 and $raf) {
        my $pos = $dataPos + ($$dirInfo{DirStart}||0) + $base;
        if ($raf->Seek($pos, 0) and $raf->Read($buff, 4) == 4) {
            $dataPt = \$buff;
            undef $$dirInfo{DataPt};    # must load data from file
            $raf->Seek($pos, 0);
        }
    }
    # this may either be a normal IFD, or a MRW data block
    # (only original ARW images from the A100 use the MRW block)
    my $dataOffset;
    if ($dataPt and $$dataPt =~ /^\0MR[IM]/) {
        my ($err, $srfPos, $srfLen, $dataOffset);
        $dataOffset = $$exifTool{A100DataOffset};
        if ($dataOffset) {
            # save information about the RAW data trailer so it will be preserved
            $$exifTool{KnownTrailer} = { Name => 'A100 RAW Data', Start => $dataOffset };
        } else {
            $err = 'A100DataOffset tag is missing from A100 ARW image';
        }
        $raf or $err = 'Unrecognized SR2 structure';
        unless ($err) {
            $srfPos = $raf->Tell();
            $srfLen = $dataOffset - $srfPos;
            unless ($srfLen > 0 and $raf->Read($buff, $srfLen) == $srfLen) {
                $err = 'Error reading MRW directory';
            }
        }
        if ($err) {
            $outfile and $exifTool->Error($err), return undef;
            $exifTool->Warn($err);
            return 0;
        }
        my %dirInfo = ( DataPt => \$buff );
        require Image::ExifTool::MinoltaRaw;
        if ($outfile) {
            # save MRW data to be written last
            $$exifTool{MRWDirData} = Image::ExifTool::MinoltaRaw::WriteMRW($exifTool, \%dirInfo);
            return $$exifTool{MRWDirData} ? "\0\0\0\0\0\0" : undef;
        } else {
            if (not $outfile and $$exifTool{HTML_DUMP}) {
                $exifTool->HDump($srfPos, $srfLen, '[A100 SRF Data]');
            }
            return Image::ExifTool::MinoltaRaw::ProcessMRW($exifTool, \%dirInfo);
        }
    } elsif ($$exifTool{A100DataOffset}) {
        my $err = 'Unexpected A100DataOffset tag';
        $outfile and $exifTool->Error($err), return undef;
        $exifTool->Warn($err);
        return 0;
    }
    my $verbose = $exifTool->Options('Verbose');
    my $result;
    if ($outfile) {
        $result = Image::ExifTool::Exif::WriteExif($exifTool, $dirInfo, $tagTablePtr);
        return undef unless $result;
        $$outfile .= $result;

    } else {
        $result = Image::ExifTool::Exif::ProcessExif($exifTool, $dirInfo, $tagTablePtr);
    }
    return $result unless $result and $$exifTool{SR2SubIFDOffset};
    # only take first offset value if more than one!
    my @offsets = split ' ', $exifTool->{SR2SubIFDOffset};
    my $offset = shift @offsets;
    my $length = $exifTool->{SR2SubIFDLength};
    my $key = $exifTool->{SR2SubIFDKey};
    my @subifdPos;
    if ($offset and $length and defined $key) {
        my $buff;
        # read encrypted SR2SubIFD from file
        if (($raf and $raf->Seek($offset+$base, 0) and
                $raf->Read($buff, $length) == $length) or
            # or read from data (when processing Adobe DNGPrivateData)
            ($offset - $dataPos >= 0 and $offset - $dataPos + $length < $dataLen and
                ($buff = substr($$dataPt, $offset - $dataPos, $length))))
        {
            Decrypt(\$buff, 0, $length, $key);
            # display decrypted data in verbose mode
            if ($verbose > 2 and not $outfile) {
                $exifTool->VerboseDir("Decrypted SR2SubIFD", 0, $length);
                $exifTool->VerboseDump(\$buff, Addr => $offset + $base);
            }
            my $num = '';
            my $dPos = $offset;
            for (;;) {
                my %dirInfo = (
                    Base => $base,
                    DataPt => \$buff,
                    DataLen => length $buff,
                    DirStart => $offset - $dPos,
                    DirName => "SR2SubIFD$num",
                    DataPos => $dPos,
                );
                my $subTable = GetTagTable('Image::ExifTool::Sony::SR2SubIFD');
                if ($outfile) {
                    my $fixup = new Image::ExifTool::Fixup;
                    $dirInfo{Fixup} = $fixup;
                    $result = $exifTool->WriteDirectory(\%dirInfo, $subTable);
                    return undef unless $result;
                    # save position of this SubIFD
                    push @subifdPos, length($$outfile);
                    # add this directory to the returned data
                    $$fixup{Start} += length($$outfile);
                    $$outfile .= $result;
                    $dirInfo->{Fixup}->AddFixup($fixup);
                } else {
                    $result = $exifTool->ProcessDirectory(\%dirInfo, $subTable);
                }
                last unless @offsets;
                $offset = shift @offsets;
                $num = ($num || 1) + 1;
            }

        } else {
            $exifTool->Warn('Error reading SR2 data');
        }
    }
    if ($outfile and @subifdPos) {
        # the SR2SubIFD must be padded to a multiple of 4 bytes for the encryption
        my $sr2Len = length($$outfile) - $subifdPos[0];
        if ($sr2Len & 0x03) {
            my $pad = 4 - ($sr2Len & 0x03);
            $sr2Len += $pad;
            $$outfile .= ' ' x $pad;
        }
        # save the new SR2SubIFD Length and Key to be used later for encryption
        $$exifTool{SR2SubIFDLength} = $sr2Len;
        my $newKey = $$exifTool{VALUE}{SR2SubIFDKey};
        $$exifTool{SR2SubIFDKey} = $newKey if defined $newKey;
        # update SubIFD pointers manually and add to fixup, and set SR2SubIFDLength
        my $n = Get16u($outfile, 0);
        my ($i, %found);
        for ($i=0; $i<$n; ++$i) {
            my $entry = 2 + 12 * $i;
            my $tagID = Get16u($outfile, $entry);
            # only interested in SR2SubIFDOffset (0x7200) and SR2SubIFDLength (0x7201)
            next unless $tagID == 0x7200 or $tagID == 0x7201;
            $found{$tagID} = 1;
            my $fmt = Get16u($outfile, $entry + 2);
            if ($fmt != 0x04) { # must be int32u
                $exifTool->Error("Unexpected format ($fmt) for SR2SubIFD tag");
                return undef;
            }
            if ($tagID == 0x7201) { # SR2SubIFDLength
                Set32u($sr2Len, $outfile, $entry + 8);
                next;
            }
            my $tag = 'SR2SubIFDOffset';
            my $valuePtr = @subifdPos < 2 ? $entry+8 : Get32u($outfile, $entry+8);
            my $pos;
            foreach $pos (@subifdPos) {
                Set32u($pos, $outfile, $valuePtr);
                $dirInfo->{Fixup}->AddFixup($valuePtr, $tag);
                undef $tag;
                $valuePtr += 4;
            }
        }
        unless ($found{0x7200} and $found{0x7201}) {
            $exifTool->Error('Missing SR2SubIFD tag');
            return undef;
        }
    }
    return $outfile ? $$outfile : $result;
}

1; # end

__END__

=head1 NAME

Image::ExifTool::Sony - Sony EXIF maker notes tags

=head1 SYNOPSIS

This module is loaded automatically by Image::ExifTool when required.

=head1 DESCRIPTION

This module contains definitions required by Image::ExifTool to interpret
Sony maker notes EXIF meta information.

=head1 NOTES

Also see Minolta.pm since Sony DSLR models use structures originating from
Minolta.

=head1 AUTHOR

Copyright 2003-2011, Phil Harvey (phil at owl.phy.queensu.ca)

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 REFERENCES

=over 4

=item L<http://www.cybercom.net/~dcoffin/dcraw/>

=item L<http://homepage3.nifty.com/kamisaka/makernote/makernote_sony.htm>

=item L<http://www.klingebiel.com/tempest/hd/pmp.html>

=back

=head1 ACKNOWLEDGEMENTS

Thanks to Thomas Bodenmann, Philippe Devaux, Jens Duttke, Marcus
Holland-Moritz, Andrey Tverdokhleb, Rudiger Lange, Igal Milchtaich and
Michael Reitinger for help decoding some tags.

=head1 SEE ALSO

L<Image::ExifTool::TagNames/Sony Tags>,
L<Image::ExifTool::TagNames/Minolta Tags>,
L<Image::ExifTool(3pm)|Image::ExifTool>

=cut
