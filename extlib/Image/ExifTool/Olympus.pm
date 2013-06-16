#------------------------------------------------------------------------------
# File:         Olympus.pm
#
# Description:  Olympus/Epson EXIF maker notes tags
#
# Revisions:    12/09/2003 - P. Harvey Created
#               11/11/2004 - P. Harvey Added Epson support
#
# References:   1) http://park2.wakwak.com/~tsuruzoh/Computer/Digicams/exif-e.html
#               2) http://www.cybercom.net/~dcoffin/dcraw/
#               3) http://www.ozhiker.com/electronics/pjmt/jpeg_info/olympus_mn.html
#               4) Markku HŠnninen private communication (tests with E-1)
#               5) RŽmi Guyomarch from http://forums.dpreview.com/forums/read.asp?forum=1022&message=12790396
#               6) Frank Ledwon private communication (tests with E/C-series cameras)
#               7) Michael Meissner private communication
#               8) Shingo Noguchi, PhotoXP (http://www.daifukuya.com/photoxp/)
#               9) Mark Dapoz private communication
#              10) Lilo Huang private communication (E-330)
#              11) http://olypedia.de/Olympus_Makernotes
#              12) Ioannis Panagiotopoulos private communication (E-510)
#              13) Chris Shaw private communication (E-3)
#              14) Viktor Lushnikov private communication (E-400)
#              15) Yrjo Rauste private communication (E-30)
#              16) Godfrey DiGiorgi private communcation (E-P1) + http://forums.dpreview.com/forums/read.asp?message=33187567
#              17) Martin Hibers private communication
#              18) Tomasz Kawecki private communication
#------------------------------------------------------------------------------

package Image::ExifTool::Olympus;

use strict;
use vars qw($VERSION);
use Image::ExifTool::Exif;
use Image::ExifTool::APP12;

$VERSION = '1.76';

sub PrintLensInfo($$$);

my %offOn = ( 0 => 'Off', 1 => 'On' );

# lookup for Olympus LensType values
my %olympusLensTypes = (
    '0 0 0'  => 'None',
    # Olympus lenses
    '0 1 0'  => 'Olympus Zuiko Digital ED 50mm F2.0 Macro',
    '0 1 1'  => 'Olympus Zuiko Digital 40-150mm F3.5-4.5', #8
    '0 1 16' => 'Olympus M.Zuiko Digital ED 14-42mm F3.5-5.6', #PH (E-P1 pre-production)
    '0 2 0'  => 'Olympus Zuiko Digital ED 150mm F2.0',
    '0 2 16' => 'Olympus M.Zuiko Digital 17mm F2.8 Pancake', #PH (E-P1 pre-production)
    '0 3 0'  => 'Olympus Zuiko Digital ED 300mm F2.8',
    '0 3 16' => 'Olympus M.Zuiko Digital ED 14-150mm F4.0-5.6', #11
    '0 4 16' => 'Olympus M.Zuiko Digital ED 9-18mm F4.0-5.6', #11
    '0 5 0'  => 'Olympus Zuiko Digital 14-54mm F2.8-3.5',
    '0 5 1'  => 'Olympus Zuiko Digital Pro ED 90-250mm F2.8', #9
    '0 5 16' => 'Olympus M.Zuiko Digital ED 14-42mm F3.5-5.6', #11
    '0 6 0'  => 'Olympus Zuiko Digital ED 50-200mm F2.8-3.5',
    '0 6 1'  => 'Olympus Zuiko Digital ED 8mm F3.5 Fisheye', #9
    '0 7 0'  => 'Olympus Zuiko Digital 11-22mm F2.8-3.5',
    '0 7 1'  => 'Olympus Zuiko Digital 18-180mm F3.5-6.3', #6
    '0 8 1'  => 'Olympus Zuiko Digital 70-300mm F4.0-5.6', #7 (seen as release 1 - PH)
    '0 9 16' => 'Olympus M.Zuiko Digital 14-42mm F3.5-5.6 II', #PH (E-PL2)
    '0 21 0' => 'Olympus Zuiko Digital ED 7-14mm F4.0',
    '0 23 0' => 'Olympus Zuiko Digital Pro ED 35-100mm F2.0', #7
    '0 24 0' => 'Olympus Zuiko Digital 14-45mm F3.5-5.6',
    '0 32 0' => 'Olympus Zuiko Digital 35mm F3.5 Macro', #9
    '0 34 0' => 'Olympus Zuiko Digital 17.5-45mm F3.5-5.6', #9
    '0 35 0' => 'Olympus Zuiko Digital ED 14-42mm F3.5-5.6', #PH
    '0 36 0' => 'Olympus Zuiko Digital ED 40-150mm F4.0-5.6', #PH
    '0 48 0' => 'Olympus Zuiko Digital ED 50-200mm F2.8-3.5 SWD', #7
    '0 49 0' => 'Olympus Zuiko Digital ED 12-60mm F2.8-4.0 SWD', #7
    '0 50 0' => 'Olympus Zuiko Digital ED 14-35mm F2.0 SWD', #PH
    '0 51 0' => 'Olympus Zuiko Digital 25mm F2.8', #PH
    '0 52 0' => 'Olympus Zuiko Digital ED 9-18mm F4.0-5.6', #7
    '0 53 0' => 'Olympus Zuiko Digital 14-54mm F2.8-3.5 II', #PH
    # Sigma lenses
    '1 1 0'  => 'Sigma 18-50mm F3.5-5.6', #8
    '1 2 0'  => 'Sigma 55-200mm F4.0-5.6 DC',
    '1 3 0'  => 'Sigma 18-125mm F3.5-5.6 DC',
    '1 4 0'  => 'Sigma 18-125mm F3.5-5.6', #7
    '1 5 0'  => 'Sigma 30mm F1.4', #10
    '1 6 0'  => 'Sigma 50-500mm F4.0-6.3 EX DG APO HSM RF', #6
    '1 7 0'  => 'Sigma 105mm F2.8 DG', #PH
    '1 8 0'  => 'Sigma 150mm F2.8 DG HSM', #PH
    '1 16 0' => 'Sigma 24mm F1.8 EX DG Aspherical Macro', #PH
    '1 17 0' => 'Sigma 135-400mm F4.5-5.6 DG ASP APO RF', #11
    '1 18 0' => 'Sigma 300-800mm F5.6 EX DG APO', #11
    '1 20 0' => 'Sigma 50-500mm F4.0-6.3 EX DG APO HSM RF', #11
    '1 21 0' => 'Sigma 10-20mm F4.0-5.6 EX DC HSM', #11
    '1 22 0' => 'Sigma 70-200mm F2.8 EX DG Macro HSM II', #11
    '1 23 0' => 'Sigma 50mm F1.4 EX DG HSM', #11
    # Leica lenses (ref 11)
    '2 1 0'  => 'Leica D Vario Elmarit 14-50mm F2.8-3.5 Asph.',
    '2 1 16' => 'Lumix G Vario 14-45mm F3.5-5.6 Asph. Mega OIS', #16
    '2 2 0'  => 'Leica D Summilux 25mm F1.4 Asph.',
    '2 2 16' => 'Lumix G Vario 45-200mm F4-5.6 Mega OIS', #16
    '2 3 1'  => 'Leica D Vario Elmar 14-50mm F3.8-5.6 Asph.', #14 (L10 kit)
    '2 3 16' => 'Lumix G Vario HD 14-140mm F4-5.8 Asph. Mega OIS', #16
    '2 4 0'  => 'Leica D Vario Elmar 14-150mm F3.5-5.6', #13
    '2 4 16' => 'Lumix G Vario 7-14mm F4 Asph.', #PH (E-P1 pre-production)
    '2 5 16' => 'Lumix G 20mm F1.7 Asph.', #16
    '2 8 16' => 'Lumix G Fisheye 8mm F3.5', #PH
    '3 1 0'  => 'Leica D Vario Elmarit 14-50mm F2.8-3.5 Asph.',
    '3 2 0'  => 'Leica D Summilux 25mm F1.4 Asph.',
);

# ArtFilter and MagicFilter values (ref PH)
my %filters = (
    '0 0 0 0'    => 'Off', # ArtFilter
    '0 1280 0 0' => 'Off', # MagicFilter
    '1 1280 0 0' => 'Soft Focus',
    '2 1280 0 0' => 'Pop Art',
    '3 1280 0 0' => 'Pale & Light Color',
    '4 1280 0 0' => 'Light Tone',
    '5 1280 0 0' => 'Pin Hole',
    '6 1280 0 0' => 'Grainy Film',
    '9 1280 0 0' => 'Diorama',
    '10 1280 0 0' => 'Cross Process',
    '12 1280 0 0' => 'Fish Eye',
    '13 1280 0 0' => 'Drawing',
);

# tag information for WAV "Index" tags
my %indexInfo = (
    Format => 'int32u',
    RawConv => '$val == 0xffffffff ? undef : $val',
    ValueConv => '$val / 1000',
    PrintConv => 'ConvertDuration($val)',
);

# Olympus tags
%Image::ExifTool::Olympus::Main = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    WRITABLE => 1,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
#
# Tags 0x0000 through 0x0103 are the same as Konica/Minolta cameras (ref 3)
# (removed 0x0101-0x0103 because they weren't supported by my samples - PH)
#
    0x0000 => {
        Name => 'MakerNoteVersion',
        Writable => 'undef',
    },
    0x0001 => {
        Name => 'MinoltaCameraSettingsOld',
        SubDirectory => {
            TagTable => 'Image::ExifTool::Minolta::CameraSettings',
            ByteOrder => 'BigEndian',
        },
    },
    0x0003 => {
        Name => 'MinoltaCameraSettings',
        SubDirectory => {
            TagTable => 'Image::ExifTool::Minolta::CameraSettings',
            ByteOrder => 'BigEndian',
        },
    },
    0x0040 => {
        Name => 'CompressedImageSize',
        Writable => 'int32u',
    },
    0x0081 => {
        Name => 'PreviewImageData',
        Binary => 1,
        Writable => 0,
    },
    0x0088 => {
        Name => 'PreviewImageStart',
        Flags => 'IsOffset',
        OffsetPair => 0x0089, # point to associated byte count
        DataTag => 'PreviewImage',
        Writable => 0,
        Protected => 2,
    },
    0x0089 => {
        Name => 'PreviewImageLength',
        OffsetPair => 0x0088, # point to associated offset
        DataTag => 'PreviewImage',
        Writable => 0,
        Protected => 2,
    },
    0x0100 => {
        Name => 'ThumbnailImage',
        Writable => 'undef',
        WriteCheck => '$self->CheckImage(\$val)',
        Binary => 1,
    },
    0x0104 => { #11
        Name => 'BodyFirmwareVersion',
        Writable => 'string',
    },
#
# end Konica/Minolta tags
#
    0x0200 => {
        Name => 'SpecialMode',
        Notes => q{
            3 numbers: 1. Shooting mode: 0=Normal, 2=Fast, 3=Panorama;
            2. Sequence Number; 3. Panorama Direction: 1=Left-Right,
            2=Right-Left, 3=Bottom-Top, 4=Top-Bottom
        },
        Writable => 'int32u',
        Count => 3,
        PrintConv => sub { #3
            my $val = shift;
            my @v = split ' ', $val;
            return $val unless @v >= 3;
            my @v0 = ('Normal','Unknown (1)','Fast','Panorama');
            my @v2 = ('(none)','Left to Right','Right to Left','Bottom to Top','Top to Bottom');
            $val = $v0[$v[0]] || "Unknown ($v[0])";
            $val .= ", Sequence: $v[1]";
            $val .= ', Panorama: ' . ($v2[$v[2]] || "Unknown ($v[2])");
            return $val;
        },
    },
    0x0201 => {
        Name => 'Quality',
        Writable => 'int16u',
        Notes => q{
            Quality values are decoded based on the CameraType tag. All types
            represent SQ, HQ and SHQ as sequential integers, but in general
            SX-type cameras start with a value of 0 for SQ while others start
            with 1
        },
        # These values are different for different camera types
        # (can't have Condition based on CameraType because it isn't known
        #  when this tag is extracted)
        PrintConv => sub {
            my ($val, $self) = @_;
            my %t1 = ( # all SX camera types except SX151
                0 => 'SQ (Low)',
                1 => 'HQ (Normal)',
                2 => 'SHQ (Fine)',
                6 => 'RAW', #PH - C5050WZ
            );
            my %t2 = ( # all other types
                1 => 'SQ (Low)',
                2 => 'HQ (Normal)',
                3 => 'SHQ (Fine)',
                4 => 'RAW',
                5 => 'Medium-Fine', #PH
                6 => 'Small-Fine', #PH
                33 => 'Uncompressed', #PH - C2100Z
            );
            my $conv = $self->{CameraType} =~ /^SX(?!151\b)/ ? \%t1 : \%t2;
            return $$conv{$val} ? $$conv{$val} : "Unknown ($val)";
        },
        # (no PrintConvInv because we don't know CameraType at write time)
    },
    0x0202 => {
        Name => 'Macro',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Off',
            1 => 'On',
            2 => 'Super Macro', #6
        },
    },
    0x0203 => { #6
        Name => 'BWMode',
        Description => 'Black And White Mode',
        Writable => 'int16u',
        PrintConv => \%offOn,
    },
    0x0204 => {
        Name => 'DigitalZoom',
        Writable => 'rational64u',
        PrintConv => '$val=~/\./ or $val.=".0"; $val',
        PrintConvInv => '$val',
    },
    0x0205 => { #6
        Name => 'FocalPlaneDiagonal',
        Writable => 'rational64u',
        PrintConv => '"$val mm"',
        PrintConvInv => '$val=~s/\s*mm$//;$val',
    },
    0x0206 => { #6
        Name => 'LensDistortionParams',
        Writable => 'int16s',
        Count => 6,
    },
    0x0207 => { #PH (was incorrectly FirmwareVersion, ref 1,3)
        Name => 'CameraType',
        Writable => 'string',
        DataMember => 'CameraType',
        RawConv => '$self->{CameraType} = $val',
    },
    0x0208 => {
        Name => 'TextInfo',
        SubDirectory => {
            TagTable => 'Image::ExifTool::Olympus::TextInfo',
        },
    },
    0x0209 => {
        Name => 'CameraID',
        Format => 'string', # this really should have been a string
    },
    0x020b => { #PH
        Name => 'EpsonImageWidth',
        Writable => 'int16u',
    },
    0x020c => { #PH
        Name => 'EpsonImageHeight',
        Writable => 'int16u',
    },
    0x020d => { #PH
        Name => 'EpsonSoftware',
        Writable => 'string',
    },
    0x0280 => { #PH
        %Image::ExifTool::previewImageTagInfo,
        Notes => 'found in ERF and JPG images from some Epson models',
        Format => 'undef',
        Writable => 'int8u',
    },
    0x0300 => { #6
        Name => 'PreCaptureFrames',
        Writable => 'int16u',
    },
    0x0301 => { #11
        Name => 'WhiteBoard',
        Writable => 'int16u',
    },
    0x0302 => { #6
        Name => 'OneTouchWB',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Off',
            1 => 'On',
            2 => 'On (Preset)',
        },
    },
    0x0303 => { #11
        Name => 'WhiteBalanceBracket',
        Writable => 'int16u',
    },
    0x0304 => { #11
        Name => 'WhiteBalanceBias',
        Writable => 'int16u',
    },
   # 0x0305 => 'PrintMaching', ? #11
    0x0403 => { #11
        Name => 'SceneMode',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Normal',
            1 => 'Standard',
            2 => 'Auto',
            3 => 'Intelligent Auto', #PH (guess, u7040)
            4 => 'Portrait',
            5 => 'Landscape+Portrait',
            6 => 'Landscape',
            7 => 'Night Scene',
            8 => 'Night+Portrait',
            9 => 'Sport',
            10 => 'Self Portrait',
            11 => 'Indoor',
            12 => 'Beach & Snow',
            13 => 'Beach',
            14 => 'Snow',
            15 => 'Self Portrait+Self Timer',
            16 => 'Sunset',
            17 => 'Cuisine',
            18 => 'Documents',
            19 => 'Candle',
            20 => 'Fireworks',
            21 => 'Available Light',
            22 => 'Vivid',
            23 => 'Underwater Wide1',
            24 => 'Underwater Macro',
            25 => 'Museum',
            26 => 'Behind Glass',
            27 => 'Auction',
            28 => 'Shoot & Select1',
            29 => 'Shoot & Select2',
            30 => 'Underwater Wide2',
            31 => 'Digital Image Stabilization',
            32 => 'Face Portrait',
            33 => 'Pet',
            34 => 'Smile Shot',
            101 => 'Magic Filter', #PH
        },
    },
    0x0404 => { #PH (D595Z, C7070WZ)
        Name => 'SerialNumber',
        Writable => 'string',
    },
    0x0405 => { #11
        Name => 'Firmware',
        Writable => 'string',
    },
    0x0e00 => {
        Name => 'PrintIM',
        Description => 'Print Image Matching',
        Writable => 0,
        SubDirectory => {
            TagTable => 'Image::ExifTool::PrintIM::Main',
        },
    },
    0x0f00 => {
        Name => 'DataDump',
        Writable => 0,
        Binary => 1,
    },
    0x0f01 => { #6
        Name => 'DataDump2',
        Writable => 0,
        Binary => 1,
    },
    0x0f04 => {
        Name => 'ZoomedPreviewStart',
        # NOTE: this tag is not currently updated properly when the image is rewritten!
        OffsetPair => 0xf05,
        DataTag => 'ZoomedPreviewImage',
        Writable => 'int32u',
        Protected => 2,
    },
    0x0f05 => {
        Name => 'ZoomedPreviewLength',
        OffsetPair => 0xf04,
        DataTag => 'ZoomedPreviewImage',
        Writable => 'int32u',
        Protected => 2,
    },
    0x0f06 => {
        Name => 'ZoomedPreviewSize',
        Writable => 'int16u',
        Count => 2,
    },
    0x1000 => { #6
        Name => 'ShutterSpeedValue',
        Writable => 'rational64s',
        Priority => 0,
        ValueConv => 'abs($val)<100 ? 2**(-$val) : 0',
        ValueConvInv => '$val>0 ? -log($val)/log(2) : -100',
        PrintConv => 'Image::ExifTool::Exif::PrintExposureTime($val)',
        PrintConvInv => 'Image::ExifTool::Exif::ConvertFraction($val)',
    },
    0x1001 => { #6
        Name => 'ISOValue',
        Writable => 'rational64s',
        Priority => 0,
        ValueConv => '100 * 2 ** ($val - 5)',
        ValueConvInv => '$val>0 ? log($val/100)/log(2)+5 : 0',
        PrintConv => 'int($val * 100 + 0.5) / 100',
        PrintConvInv => '$val',
    },
    0x1002 => { #6
        Name => 'ApertureValue',
        Writable => 'rational64s',
        Priority => 0,
        ValueConv => '2 ** ($val / 2)',
        ValueConvInv => '$val>0 ? 2*log($val)/log(2) : 0',
        PrintConv => 'sprintf("%.1f",$val)',
        PrintConvInv => '$val',
    },
    0x1003 => { #6
        Name => 'BrightnessValue',
        Writable => 'rational64s',
        Priority => 0,
    },
    0x1004 => { #3
        Name => 'FlashMode',
        Writable => 'int16u',
        PrintConv => {
            2 => 'On', #PH
            3 => 'Off', #PH
        },
    },
    0x1005 => { #6
        Name => 'FlashDevice',
        Writable => 'int16u',
        PrintConv => {
            0 => 'None',
            1 => 'Internal',
            4 => 'External',
            5 => 'Internal + External',
        },
    },
    0x1006 => { #6
        Name =>'ExposureCompensation',
        Writable => 'rational64s',
    },
    0x1007 => { #6 (E-10, E-20 and C2500L - numbers usually around 30-40)
        Name => 'SensorTemperature',
        Writable => 'int16s',
    },
    0x1008 => { #6
        Name => 'LensTemperature',
        Writable => 'int16s',
    },
    0x1009 => { #11
        Name => 'LightCondition',
        Writable => 'int16u',
    },
    0x100a => { #11
        Name => 'FocusRange',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Normal',
            1 => 'Macro',
        },
    },
    0x100b => { #6
        Name => 'FocusMode',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Auto',
            1 => 'Manual',
        },
    },
    0x100c => { #6
        Name => 'ManualFocusDistance',
        Writable => 'rational64u',
        PrintConv => '"$val mm"', #11
        PrintConvInv => '$val=~s/\s*mm$//; $val',
    },
    0x100d => { #6
        Name => 'ZoomStepCount',
        Writable => 'int16u',
    },
    0x100e => { #6
        Name => 'FocusStepCount',
        Writable => 'int16u',
    },
    0x100f => { #6
        Name => 'Sharpness',
        Writable => 'int16u',
        Priority => 0,
        PrintConv => {
            0 => 'Normal',
            1 => 'Hard',
            2 => 'Soft',
        },
    },
    0x1010 => { #6
        Name => 'FlashChargeLevel',
        Writable => 'int16u',
    },
    0x1011 => { #3
        Name => 'ColorMatrix',
        Writable => 'int16u',
        Format => 'int16s',
        Count => 9,
    },
    0x1012 => { #3
        Name => 'BlackLevel',
        Writable => 'int16u',
        Count => 4,
    },
    0x1013 => { #11
        Name => 'ColorTemperatureBG',
        Writable => 'int16u',
        Unknown => 1, # (doesn't look like a temperature)
    },
    0x1014 => { #11
        Name => 'ColorTemperatureRG',
        Writable => 'int16u',
        Unknown => 1, # (doesn't look like a temperature)
    },
    0x1015 => { #6
        Name => 'WBMode',
        Writable => 'int16u',
        Count => 2,
        PrintConv => {
            '1'   => 'Auto',
            '1 0' => 'Auto',
            '1 2' => 'Auto (2)',
            '1 4' => 'Auto (4)',
            '2 2' => '3000 Kelvin',
            '2 3' => '3700 Kelvin',
            '2 4' => '4000 Kelvin',
            '2 5' => '4500 Kelvin',
            '2 6' => '5500 Kelvin',
            '2 7' => '6500 Kelvin',
            '2 8' => '7500 Kelvin',
            '3 0' => 'One-touch',
        },
    },
    0x1017 => { #2
        Name => 'RedBalance',
        Writable => 'int16u',
        Count => 2,
        ValueConv => '$val=~s/ .*//; $val / 256',
        ValueConvInv => '$val*=256;"$val 64"',
    },
    0x1018 => { #2
        Name => 'BlueBalance',
        Writable => 'int16u',
        Count => 2,
        ValueConv => '$val=~s/ .*//; $val / 256',
        ValueConvInv => '$val*=256;"$val 64"',
    },
    0x1019 => { #11
        Name => 'ColorMatrixNumber',
        Writable => 'int16u',
    },
    # 0x101a is same as CameraID ("OLYMPUS DIGITAL CAMERA") for C2500L - PH
    0x101a => { #3
        Name => 'SerialNumber',
        Writable => 'string',
    },
    0x101b => { #11
        Name => 'ExternalFlashAE1_0',
        Writable => 'int32u',
        Unknown => 1, # (what are these?)
    },
    0x101c => { #11
        Name => 'ExternalFlashAE2_0',
        Writable => 'int32u',
        Unknown => 1,
    },
    0x101d => { #11
        Name => 'InternalFlashAE1_0',
        Writable => 'int32u',
        Unknown => 1,
    },
    0x101e => { #11
        Name => 'InternalFlashAE2_0',
        Writable => 'int32u',
        Unknown => 1,
    },
    0x101f => { #11
        Name => 'ExternalFlashAE1',
        Writable => 'int32u',
        Unknown => 1,
    },
    0x1020 => { #11
        Name => 'ExternalFlashAE2',
        Writable => 'int32u',
        Unknown => 1,
    },
    0x1021 => { #11
        Name => 'InternalFlashAE1',
        Writable => 'int32u',
        Unknown => 1,
    },
    0x1022 => { #11
        Name => 'InternalFlashAE2',
        Writable => 'int32u',
        Unknown => 1,
    },
    0x1023 => { #6
        Name => 'FlashExposureComp',
        Writable => 'rational64s',
    },
    0x1024 => { #11
        Name => 'InternalFlashTable',
        Writable => 'int16u',
    },
    0x1025 => { #11
        Name => 'ExternalFlashGValue',
        Writable => 'rational64s',
    },
    0x1026 => { #6
        Name => 'ExternalFlashBounce',
        Writable => 'int16u',
        PrintConv => {
            0 => 'No',
            1 => 'Yes',
        },
    },
    0x1027 => { #6
        Name => 'ExternalFlashZoom',
        Writable => 'int16u',
    },
    0x1028 => { #6
        Name => 'ExternalFlashMode',
        Writable => 'int16u',
    },
    0x1029 => { #3
        Name => 'Contrast',
        Writable => 'int16u',
        PrintConv => { #PH (works with E1)
            0 => 'High',
            1 => 'Normal',
            2 => 'Low',
        },
    },
    0x102a => { #3
        Name => 'SharpnessFactor',
        Writable => 'int16u',
    },
    0x102b => { #3
        Name => 'ColorControl',
        Writable => 'int16u',
        Count => 6,
    },
    0x102c => { #3
        Name => 'ValidBits',
        Writable => 'int16u',
        Count => 2,
    },
    0x102d => { #3
        Name => 'CoringFilter',
        Writable => 'int16u',
    },
    0x102e => { #PH
        Name => 'OlympusImageWidth',
        Writable => 'int32u',
    },
    0x102f => { #PH
        Name => 'OlympusImageHeight',
        Writable => 'int32u',
    },
    0x1030 => { #11
        Name => 'SceneDetect',
        Writable => 'int16u',
    },
    0x1031 => { #11
        Name => 'SceneArea',
        Writable => 'int32u',
        Count => 8,
        Unknown => 1, # (numbers don't make much sense?)
    },
    # 0x1032 HAFFINAL? #11
    0x1033 => { #11
        Name => 'SceneDetectData',
        Writable => 'int32u',
        Count => 720,
        Binary => 1,
        Unknown => 1, # (but what does it mean?)
    },
    0x1034 => { #3
        Name => 'CompressionRatio',
        Writable => 'rational64u',
    },
    0x1035 => { #6
        Name => 'PreviewImageValid',
        Writable => 'int32u',
        PrintConv => { 0 => 'No', 1 => 'Yes' },
    },
    0x1036 => { #6
        Name => 'PreviewImageStart',
        Flags => 'IsOffset',
        OffsetPair => 0x1037, # point to associated byte count
        DataTag => 'PreviewImage',
        Writable => 'int32u',
        Protected => 2,
    },
    0x1037 => { #6
        # (may contain data from multiple previews - PH, FE320)
        Name => 'PreviewImageLength',
        OffsetPair => 0x1036, # point to associated offset
        DataTag => 'PreviewImage',
        Writable => 'int32u',
        Protected => 2,
    },
    0x1038 => { #11
        Name => 'AFResult',
        Writable => 'int16u',
    },
    0x1039 => { #6
        Name => 'CCDScanMode',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Interlaced',
            1 => 'Progressive',
        },
    },
    0x103a => { #6
        Name => 'NoiseReduction',
        Writable => 'int16u',
        PrintConv => \%offOn,
    },
    0x103b => { #6
        Name => 'FocusStepInfinity',
        Writable => 'int16u',
    },
    0x103c => { #6
        Name => 'FocusStepNear',
        Writable => 'int16u',
    },
    0x103d => { #11
        Name => 'LightValueCenter',
        Writable => 'rational64s',
    },
    0x103e => { #11
        Name => 'LightValuePeriphery',
        Writable => 'rational64s',
    },
    0x103f => { #11
        Name => 'FieldCount',
        Writable => 'int16u',
        Unknown => 1, # (but what does it mean?)
    },
#
# Olympus really screwed up the format of the following subdirectories (for the
# E-1 and E-300 anyway). Not only is the subdirectory value data not included in
# the size, but also the count is 2 bytes short for the subdirectory itself
# (presumably the Olympus programmers forgot about the 2-byte entry count at the
# start of the subdirectory).  This mess is straightened out and these subdirs
# are written properly when ExifTool rewrites the file.  Note that this problem
# has been fixed by Olympus in the new-style IFD maker notes since a standard
# SubIFD offset value is used.  As written by the camera, the old style
# directories have format 'undef' or 'string', and the new style has format
# 'ifd'.  However, some older versions of exiftool may have rewritten the new
# style as 'int32u', so handle both cases. - PH
#
    0x2010 => [ #PH
        {
            Name => 'Equipment',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2, # (so HtmlDump doesn't show these as double-referenced)
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::Equipment',
                ByteOrder => 'Unknown',
            },
        },
        {
            Name => 'EquipmentIFD',
            Groups => { 1 => 'MakerNotes' },    # SubIFD needs group 1 set
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::Equipment',
                Start => '$val',
            },
        },
    ],
    0x2020 => [ #PH
        {
            Name => 'CameraSettings',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::CameraSettings',
                ByteOrder => 'Unknown',
            },
        },
        {
            Name => 'CameraSettingsIFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::CameraSettings',
                Start => '$val',
            },
        },
    ],
    0x2030 => [ #PH
        {
            Name => 'RawDevelopment',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::RawDevelopment',
                ByteOrder => 'Unknown',
            },
        },
        {
            Name => 'RawDevelopmentIFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::RawDevelopment',
                Start => '$val',
            },
        },
    ],
    0x2031 => [ #11
        {
            Name => 'RawDev2',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::RawDevelopment2',
                ByteOrder => 'Unknown',
            },
        },
        {
            Name => 'RawDev2IFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::RawDevelopment2',
                Start => '$val',
            },
        },
    ],
    0x2040 => [ #PH
        {
            Name => 'ImageProcessing',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::ImageProcessing',
                ByteOrder => 'Unknown',
            },
        },
        {
            Name => 'ImageProcessingIFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::ImageProcessing',
                Start => '$val',
            },
        },
    ],
    0x2050 => [ #PH
        {
            Name => 'FocusInfo',
            Condition => '$format ne "ifd" and $format ne "int32u" and not $$self{OlympusCAMER}',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FocusInfo',
                ByteOrder => 'Unknown',
            },
        },
        {
            Name => 'FocusInfoIFD',
            Condition => 'not $$self{OlympusCAMER}',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FocusInfo',
                Start => '$val',
            },
        },
        {
            # ASCII-based camera parameters if makernotes starts with "CAMER\0"
            # (or for Sony models starting with "SONY PI\0" or "PREMI\0")
            Name => 'CameraParameters',
            Writable => 'undef',
            Binary => 1,
        },
    ],
    0x2100 => [
        { #11
            Name => 'Olympus2100',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
            },
        },
        { #PH
            Name => 'Olympus2100IFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
                Start => '$val',
            },
        },
    ],
    0x2200 => [
        { #11
            Name => 'Olympus2200',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
            },
        },
        { #PH
            Name => 'Olympus2200IFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
                Start => '$val',
            },
        },
    ],
    0x2300 => [
        { #11
            Name => 'Olympus2300',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
            },
        },
        { #PH
            Name => 'Olympus2300IFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
                Start => '$val',
            },
        },
    ],
    0x2400 => [
        { #11
            Name => 'Olympus2400',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
            },
        },
        { #PH
            Name => 'Olympus2400IFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
                Start => '$val',
            },
        },
    ],
    0x2500 => [
        { #11
            Name => 'Olympus2500',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
            },
        },
        { #PH
            Name => 'Olympus2500IFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
                Start => '$val',
            },
        },
    ],
    0x2600 => [
        { #11
            Name => 'Olympus2600',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
            },
        },
        { #PH
            Name => 'Olympus2600IFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
                Start => '$val',
            },
        },
    ],
    0x2700 => [
        { #11
            Name => 'Olympus2700',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
            },
        },
        { #PH
            Name => 'Olympus2700IFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
                Start => '$val',
            },
        },
    ],
    0x2800 => [
        { #11
            Name => 'Olympus2800',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
            },
        },
        { #PH
            Name => 'Olympus2800IFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
                Start => '$val',
            },
        },
    ],
    0x2900 => [
        { #11
            Name => 'Olympus2900',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
            },
        },
        { #PH
            Name => 'Olympus2900IFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::FETags',
                ByteOrder => 'Unknown',
                Start => '$val',
            },
        },
    ],
    0x3000 => [
        { #6
            Name => 'RawInfo',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::RawInfo',
                ByteOrder => 'Unknown',
            },
        },
        { #PH
            Name => 'RawInfoIFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::RawInfo',
                Start => '$val',
            },
        },
    ],
    0x4000 => [ #PH
        {
            Name => 'MainInfo',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::Main',
                ByteOrder => 'Unknown',
            },
        },
        {
            Name => 'MainInfoIFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::Main',
                Start => '$val',
            },
        },
    ],
    0x5000 => [ #PH
        {
            Name => 'UnknownInfo',
            Condition => '$format ne "ifd" and $format ne "int32u"',
            NestedHtmlDump => 2,
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::UnknownInfo',
                ByteOrder => 'Unknown',
            },
        },
        {
            Name => 'UnknownInfoIFD',
            Groups => { 1 => 'MakerNotes' },
            Flags => 'SubIFD',
            FixFormat => 'ifd',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Olympus::UnknownInfo',
                Start => '$val',
            },
        },
    ],
);

# TextInfo tags
%Image::ExifTool::Olympus::TextInfo = (
    PROCESS_PROC => \&Image::ExifTool::APP12::ProcessAPP12,
    NOTES => q{
        This information is in text format (similar to APP12 information, but with
        spaces instead of linefeeds).  Below are tags which have been observed, but
        any information found here will be extracted, even if the tag is not listed.
    },
    GROUPS => { 0 => 'MakerNotes', 1 => 'Olympus', 2 => 'Image' },
    Resolution => { },
    Type => {
        Name => 'CameraType',
        Groups => { 2 => 'Camera' },
        DataMember => 'CameraType',
        RawConv => '$self->{CameraType} = $val',
    },
);

# Olympus Equipment IFD
%Image::ExifTool::Olympus::Equipment = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    WRITABLE => 1,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    0x000 => { #PH
        Name => 'EquipmentVersion',
        Writable => 'undef',
        RawConv => '$val=~s/\0+$//; $val',  # (may be null terminated)
        Count => 4,
    },
    0x100 => { #6
        Name => 'CameraType2',
        Writable => 'string',
        Count => 6,
    },
    0x101 => { #PH
        Name => 'SerialNumber',
        Writable => 'string',
        Count => 32,
        PrintConv => '$val=~s/\s+$//;$val',
        PrintConvInv => 'pack("A31",$val)', # pad with spaces to 31 chars
    },
    0x102 => { #6
        Name => 'InternalSerialNumber',
        Notes => '16 digits: 0-3=model, 4=year, 5-6=month, 8-12=unit number',
        Writable => 'string',
        Count => 32,
    },
    0x103 => { #6
        Name => 'FocalPlaneDiagonal',
        Writable => 'rational64u',
        PrintConv => '"$val mm"',
        PrintConvInv => '$val=~s/\s*mm$//;$val',
    },
    0x104 => { #6
        Name => 'BodyFirmwareVersion',
        Writable => 'int32u',
        PrintConv => '$val=sprintf("%x",$val);$val=~s/(.{3})$/\.$1/;$val',
        PrintConvInv => '$val=sprintf("%.3f",$val);$val=~s/\.//;hex($val)',
    },
    0x201 => { #6
        Name => 'LensType',
        Writable => 'int8u',
        Count => 6,
        Notes => q{
            6 numbers: 0. Make, 1. Unknown, 2. Model, 3. Sub-model, 4-5. Unknown.  Only
            the Make, Model and Sub-model are used to determine the lens model
        },
        # Have seen these values for the unknown numbers:
        # 1: 0
        # 4: 0, 2(Olympus lenses for which I have also seen 0 for this number)
        # 5: 0, 16(new Lumix lenses)
        ValueConv => 'my @a = split(" ",$val); "$a[0] $a[2] $a[3]"',
        # set unknown values to zero when writing
        ValueConvInv => 'my @a=split(" ",$val); "$a[0] 0 $a[1] $a[2] 0 0"',
        PrintConv => \%olympusLensTypes,
    },
    # apparently the first 3 digits of the lens s/n give the type (ref 4):
    # 010 = 50macro
    # 040 = EC-14
    # 050 = 14-54
    # 060 = 50-200
    # 080 = EX-25
    # 101 = FL-50
    # 272 = EC-20 #7
    0x202 => { #PH
        Name => 'LensSerialNumber',
        Writable => 'string',
        Count => 32,
        PrintConv => '$val=~s/\s+$//;$val',
        PrintConvInv => 'pack("A31",$val)', # pad with spaces to 31 chars
    },
    0x203 => { #17
        Name => 'LensModel',
        Writable => 'string',
    },
    0x204 => { #6
        Name => 'LensFirmwareVersion',
        Writable => 'int32u',
        PrintConv => '$val=sprintf("%x",$val);$val=~s/(.{3})$/\.$1/;$val',
        PrintConvInv => '$val=sprintf("%.3f",$val);$val=~s/\.//;hex($val)',
    },
    0x205 => { #11
        Name => 'MaxApertureAtMinFocal',
        Writable => 'int16u',
        ValueConv => '$val ? sqrt(2)**($val/256) : 0',
        ValueConvInv => '$val>0 ? int(512*log($val)/log(2)+0.5) : 0',
        PrintConv => 'sprintf("%.1f",$val)',
        PrintConvInv => '$val',
    },
    0x206 => { #5
        Name => 'MaxApertureAtMaxFocal',
        Writable => 'int16u',
        ValueConv => '$val ? sqrt(2)**($val/256) : 0',
        ValueConvInv => '$val>0 ? int(512*log($val)/log(2)+0.5) : 0',
        PrintConv => 'sprintf("%.1f",$val)',
        PrintConvInv => '$val',
    },
    0x207 => { #PH
        Name => 'MinFocalLength',
        Writable => 'int16u',
    },
    0x208 => { #PH
        Name => 'MaxFocalLength',
        Writable => 'int16u',
    },
    0x20a => { #9
        Name => 'MaxApertureAtCurrentFocal',
        Writable => 'int16u',
        ValueConv => '$val ? sqrt(2)**($val/256) : 0',
        ValueConvInv => '$val>0 ? int(512*log($val)/log(2)+0.5) : 0',
        PrintConv => 'sprintf("%.1f",$val)',
        PrintConvInv => '$val',
    },
    0x20b => { #11
        Name => 'LensProperties',
        Writable => 'int16u',
        PrintConv => 'sprintf("0x%x",$val)',
        PrintConvInv => '$val',
    },
    0x301 => { #6
        Name => 'Extender',
        Writable => 'int8u',
        Count => 6,
        Notes => q{
            6 numbers: 0. Make, 1. Unknown, 2. Model, 3. Sub-model, 4-5. Unknown.  Only
            the Make and Model are used to determine the extender model
        },
        ValueConv => 'my @a = split(" ",$val); "$a[0] $a[2]"',
        ValueConvInv => 'my @a=split(" ",$val); "$a[0] 0 $a[1] 0 0 0"',
        PrintConv => {
            '0 0'   => 'None',
            '0 4'   => 'Olympus Zuiko Digital EC-14 1.4x Teleconverter',
            '0 8'   => 'Olympus EX-25 Extension Tube',
            '0 16'  => 'Olympus Zuiko Digital EC-20 2.0x Teleconverter', #7
        },
    },
    0x302 => { #4
        Name => 'ExtenderSerialNumber',
        Writable => 'string',
        Count => 32,
    },
    0x303 => { #9
        Name => 'ExtenderModel',
        Writable => 'string',
    },
    0x304 => { #6
        Name => 'ExtenderFirmwareVersion',
        Writable => 'int32u',
        PrintConv => '$val=sprintf("%x",$val);$val=~s/(.{3})$/\.$1/;$val',
        PrintConvInv => '$val=sprintf("%.3f",$val);$val=~s/\.//;hex($val)',
    },
    0x1000 => { #6
        Name => 'FlashType',
        Writable => 'int16u',
        PrintConv => {
            0 => 'None',
            2 => 'Simple E-System',
            3 => 'E-System',
        },
    },
    0x1001 => { #6
        Name => 'FlashModel',
        Writable => 'int16u',
        PrintConv => {
            0 => 'None',
            1 => 'FL-20', # (or subtronic digital or Inon UW flash, ref 11)
            2 => 'FL-50', # (or Metzblitz+SCA or Cullmann 34, ref 11)
            3 => 'RF-11',
            4 => 'TF-22',
            5 => 'FL-36',
            6 => 'FL-50R', #11 (or Metz mecablitz digital)
            7 => 'FL-36R', #11
            # have seen value of 9 - PH
        },
    },
    0x1002 => { #6
        Name => 'FlashFirmwareVersion',
        Writable => 'int32u',
        PrintConv => '$val=sprintf("%x",$val);$val=~s/(.{3})$/\.$1/;$val',
        PrintConvInv => '$val=sprintf("%.3f",$val);$val=~s/\.//;hex($val)',
    },
    0x1003 => { #4
        Name => 'FlashSerialNumber',
        Writable => 'string',
        Count => 32,
    },
);

# Olympus camera settings IFD
%Image::ExifTool::Olympus::CameraSettings = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    WRITABLE => 1,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    0x000 => { #PH
        Name => 'CameraSettingsVersion',
        Writable => 'undef',
        RawConv => '$val=~s/\0+$//; $val',  # (may be null terminated)
        Count => 4,
    },
    0x100 => { #6
        Name => 'PreviewImageValid',
        Writable => 'int32u',
        PrintConv => { 0 => 'No', 1 => 'Yes' },
    },
    0x101 => { #PH
        Name => 'PreviewImageStart',
        Flags => 'IsOffset',
        OffsetPair => 0x102,
        DataTag => 'PreviewImage',
        Writable => 'int32u',
        Protected => 2,
    },
    0x102 => { #PH
        Name => 'PreviewImageLength',
        OffsetPair => 0x101,
        DataTag => 'PreviewImage',
        Writable => 'int32u',
        Protected => 2,
    },
    0x200 => { #4
        Name => 'ExposureMode',
        Writable => 'int16u',
        PrintConv => {
            1 => 'Manual',
            2 => 'Program', #6
            3 => 'Aperture-priority AE',
            4 => 'Shutter speed priority AE',
            5 => 'Program-shift', #6
        }
    },
    0x201 => { #6
        Name => 'AELock',
        Writable => 'int16u',
        PrintConv => \%offOn,
    },
    0x202 => { #PH/4
        Name => 'MeteringMode',
        Writable => 'int16u',
        PrintConv => {
            2 => 'Center-weighted average',
            3 => 'Spot',
            5 => 'ESP',
            261 => 'Pattern+AF', #6
            515 => 'Spot+Highlight control', #6
            1027 => 'Spot+Shadow control', #6
        },
    },
    0x203 => { #11 (some E-models only)
        Name => 'ExposureShift',
        Writable => 'rational64s',
    },
    0x300 => { #6
        Name => 'MacroMode',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Off',
            1 => 'On',
            2 => 'Super Macro', #11
        },
    },
    0x301 => { #6
        Name => 'FocusMode',
        Writable => 'int16u',
        Count => -1,
        Notes => '1 or 2 values',
        PrintConv => [{
            0 => 'Single AF',
            1 => 'Sequential shooting AF',
            2 => 'Continuous AF',
            3 => 'Multi AF',
            5 => 'Face detect', #11
            10 => 'MF',
        }, { BITMASK => { #11
            0 => 'S-AF',
            2 => 'C-AF',
            4 => 'MF',
            5 => 'Face detect',
            6 => 'Imager AF',
            8 => 'AF sensor',
        }}],
    },
    0x302 => { #6
        Name => 'FocusProcess',
        Writable => 'int16u',
        Count => -1,
        Notes => '1 or 2 values',
        PrintConv => [{
            0 => 'AF Not Used',
            1 => 'AF Used',
        }],
        # 2nd value written only by some models (u1050SW, u9000, uT6000, uT6010,
        # uT8000, E-30, E-420, E-450, E-520, E-620, E-P1 and E-P2): - PH
        # observed values when "AF Not Used": 0, 16
        # observed values when "AF Used": 64, 96(face detect on), 256
    },
    0x303 => { #6
        Name => 'AFSearch',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Not Ready',
            1 => 'Ready',
        },
    },
    0x304 => { #PH/4
        Name => 'AFAreas',
        Notes => 'coordinates range from 0 to 255',
        Format => 'int32u',
        Count => 64,
        PrintConv => 'Image::ExifTool::Olympus::PrintAFAreas($val)',
    },
    0x0305 => { #PH
        Name => 'AFPointSelected',
        Notes => 'coordinates expressed as a percent',
        Format => 'rational64s',
        Count => 5,
        ValueConv => '$val =~ s/\S* //; $val', # ignore first undefined value
        ValueConvInv => '"undef $val"',
        PrintConv => q{
            return $val if $val =~ /undef/;
            sprintf("(%d%%,%d%%) (%d%%,%d%%)", map {$_ * 100} split(" ",$val));
        }
    },
    0x307 => { #15
        Name => 'AFFineTuneAdj',
        Format => 'int16s',
        Count => 3, # not sure what the 3 values mean
    },
    0x400 => { #6
        Name => 'FlashMode',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Off',
            BITMASK => {
                0 => 'On',
                1 => 'Fill-in',
                2 => 'Red-eye',
                3 => 'Slow-sync',
                4 => 'Forced On',
                5 => '2nd Curtain',
            },
        },
    },
    0x401 => { #6
        Name => 'FlashExposureComp',
        Writable => 'rational64s',
    },
    # 0x402 - FlashMode? bit0=TTL, bit2=SuperFP (ref 11)
    0x403 => { #11
        Name => 'FlashRemoteControl',
        Writable => 'int16u',
        PrintHex => 1,
        PrintConv => {
            0 => 'Off',
            0x01 => 'Channel 1, Low',
            0x02 => 'Channel 2, Low',
            0x03 => 'Channel 3, Low',
            0x04 => 'Channel 4, Low',
            0x09 => 'Channel 1, Mid',
            0x0a => 'Channel 2, Mid',
            0x0b => 'Channel 3, Mid',
            0x0c => 'Channel 4, Mid',
            0x11 => 'Channel 1, High',
            0x12 => 'Channel 2, High',
            0x13 => 'Channel 3, High',
            0x14 => 'Channel 4, High',
        },
    },
    0x404 => { #11
        Name => 'FlashControlMode',
        Writable => 'int16u',
        Count => 3,
        PrintConv => [{
            0 => 'Off',
            3 => 'TTL',
            4 => 'Auto',
            5 => 'Manual',
        }],
    },
    0x405 => { #11
        Name => 'FlashIntensity',
        Writable => 'rational64s',
        Count => 3,
        PrintConv => '$val eq "undef undef undef" ? "n/a" : $val',
        PrintConvInv => '$val eq "n/a" ? "undef undef undef" : $val',
    },
    0x406 => { #11
        Name => 'ManualFlashStrength',
        Writable => 'rational64s',
        Count => 3,
        PrintConv => '$val eq "undef undef undef" ? "n/a" : $val',
        PrintConvInv => '$val eq "n/a" ? "undef undef undef" : $val',
    },
    0x500 => { #6
        Name => 'WhiteBalance2',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Auto',
            16 => '7500K (Fine Weather with Shade)',
            17 => '6000K (Cloudy)',
            18 => '5300K (Fine Weather)',
            20 => '3000K (Tungsten light)',
            21 => '3600K (Tungsten light-like)',
            33 => '6600K (Daylight fluorescent)',
            34 => '4500K (Neutral white fluorescent)',
            35 => '4000K (Cool white fluorescent)',
            48 => '3600K (Tungsten light-like)',
            256 => 'Custom WB 1',
            257 => 'Custom WB 2',
            258 => 'Custom WB 3',
            259 => 'Custom WB 4',
            512 => 'Custom WB 5400K',
            513 => 'Custom WB 2900K',
            514 => 'Custom WB 8000K',
        },
    },
    0x501 => { #PH/4
        Name => 'WhiteBalanceTemperature',
        Writable => 'int16u',
        PrintConv => '$val ? $val : "Auto"',
        PrintConvInv => '$val=~/^\d+$/ ? $val : 0',
    },
    0x502 => {  #PH/4
        Name => 'WhiteBalanceBracket',
        Writable => 'int16s',
    },
    0x503 => { #PH/4/6
        Name => 'CustomSaturation',
        Writable => 'int16s',
        Count => 3,
        Notes => '3 numbers: 1. CS Value, 2. Min, 3. Max',
        PrintConv => q{
            my ($a,$b,$c)=split ' ',$val;
            if ($self->{Model} =~ /^E-1\b/) {
                $a-=$b; $c-=$b;
                return "CS$a (min CS0, max CS$c)";
            } else {
                return "$a (min $b, max $c)";
            }
        },
    },
    0x504 => { #PH/4
        Name => 'ModifiedSaturation',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Off',
            1 => 'CM1 (Red Enhance)',
            2 => 'CM2 (Green Enhance)',
            3 => 'CM3 (Blue Enhance)',
            4 => 'CM4 (Skin Tones)',
        },
    },
    0x505 => { #PH/4
        Name => 'ContrastSetting',
        Writable => 'int16s',
        Count => 3,
        Notes => 'value, min, max',
        PrintConv => 'my @v=split " ",$val; "$v[0] (min $v[1], max $v[2])"',
        PrintConvInv => '$val=~tr/-0-9 //dc;$val',
    },
    0x506 => { #PH/4
        Name => 'SharpnessSetting',
        Writable => 'int16s',
        Count => 3,
        Notes => 'value, min, max',
        PrintConv => 'my @v=split " ",$val; "$v[0] (min $v[1], max $v[2])"',
        PrintConvInv => '$val=~tr/-0-9 //dc;$val',
    },
    0x507 => { #PH/4
        Name => 'ColorSpace',
        Writable => 'int16u',
        PrintConv => { #6
            0 => 'sRGB',
            1 => 'Adobe RGB',
            2 => 'Pro Photo RGB',
        },
    },
    0x509 => { #6
        Name => 'SceneMode',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Standard',
            6 => 'Auto', #6
            7 => 'Sport',
            8 => 'Portrait',
            9 => 'Landscape+Portrait',
            10 => 'Landscape',
            11 => 'Night Scene',
            12 => 'Self Portrait', #11
            13 => 'Panorama', #6
            14 => '2 in 1', #11
            15 => 'Movie', #11
            16 => 'Landscape+Portrait', #6
            17 => 'Night+Portrait',
            18 => 'Indoor', #11 (Party - PH)
            19 => 'Fireworks',
            20 => 'Sunset',
            21 => 'Beauty Skin', #PH
            22 => 'Macro',
            23 => 'Super Macro', #11
            24 => 'Food', #11
            25 => 'Documents',
            26 => 'Museum',
            27 => 'Shoot & Select', #11
            28 => 'Beach & Snow',
            29 => 'Self Protrait+Timer', #11
            30 => 'Candle',
            31 => 'Available Light', #11
            32 => 'Behind Glass', #11
            33 => 'My Mode', #11
            34 => 'Pet', #11
            35 => 'Underwater Wide1', #6
            36 => 'Underwater Macro', #6
            37 => 'Shoot & Select1', #11
            38 => 'Shoot & Select2', #11
            39 => 'High Key',
            40 => 'Digital Image Stabilization', #6
            41 => 'Auction', #11
            42 => 'Beach', #11
            43 => 'Snow', #11
            44 => 'Underwater Wide2', #6
            45 => 'Low Key', #6
            46 => 'Children', #6
            47 => 'Vivid', #11
            48 => 'Nature Macro', #6
            49 => 'Underwater Snapshot', #11
            50 => 'Shooting Guide', #11
            51 => 'Face Portrait', #PH (NC)
            52 => 'Smile Shot', #PH (NC)
            53 => 'Quick Shutter', #PH (NC)
            54 => 'Slow Shutter', #PH (NC)
            55 => 'Bird Watching', #PH (NC)
            56 => 'Multiple Exposure', #PH (NC)
            57 => 'e-Portrait', #PH (NC)
            58 => 'Beauty Fix', #PH (NC)
            59 => 'Soft Background', #PH (NC)
        },
    },
    0x50a => { #PH/4/6
        Name => 'NoiseReduction',
        Writable => 'int16u',
        PrintConv => {
            BITMASK => {
                0 => 'Noise Reduction',
                1 => 'Noise Filter',
                2 => 'Noise Filter (ISO Boost)',
                3 => 'Auto', #11
            },
        },
    },
    0x50b => { #6
        Name => 'DistortionCorrection',
        Writable => 'int16u',
        PrintConv => \%offOn,
    },
    0x50c => { #PH/4
        Name => 'ShadingCompensation',
        Writable => 'int16u',
        PrintConv => \%offOn,
    },
    0x50d => { #PH/4
        Name => 'CompressionFactor',
        Writable => 'rational64u',
    },
    0x50f => { #6
        Name => 'Gradation',
        Writable => 'int16s',
        Notes => '3 or 4 values',
        Count => -1,
        Relist => [ [0..2], 3 ], # join values 0-2 for PrintConv
        PrintConv => [{
           '-1 -1 1' => 'Low Key',
            '0 -1 1' => 'Normal',
            '1 -1 1' => 'High Key',
        },{
            0 => 'User-Selected',
            1 => 'Auto-Override',
        }],
    },
    0x520 => { #6
        Name => 'PictureMode',
        Writable => 'int16u',
        Notes => '1 or 2 values',
        Count => -1,
        PrintConv => [{
            1 => 'Vivid',
            2 => 'Natural',
            3 => 'Muted',
            4 => 'Portrait',
            5 => 'i-Enhance', #11
            256 => 'Monotone',
            512 => 'Sepia',
        }],
    },
    0x521 => { #6
        Name => 'PictureModeSaturation',
        Writable => 'int16s',
        Count => 3,
        Notes => 'value, min, max',
        PrintConv => 'my @v=split " ",$val; "$v[0] (min $v[1], max $v[2])"',
        PrintConvInv => '$val=~tr/-0-9 //dc;$val',
    },
    0x522 => { #6
        Name => 'PictureModeHue',
        Writable => 'int16s',
        Unknown => 1, # (needs verification)
    },
    0x523 => { #6
        Name => 'PictureModeContrast',
        Writable => 'int16s',
        Count => 3,
        Notes => 'value, min, max',
        PrintConv => 'my @v=split " ",$val; "$v[0] (min $v[1], max $v[2])"',
        PrintConvInv => '$val=~tr/-0-9 //dc;$val',
    },
    0x524 => { #6
        Name => 'PictureModeSharpness',
        # verified as the Sharpness setting in the Picture Mode menu for the E-410
        Writable => 'int16s',
        Count => 3,
        Notes => 'value, min, max',
        PrintConv => 'my @v=split " ",$val; "$v[0] (min $v[1], max $v[2])"',
        PrintConvInv => '$val=~tr/-0-9 //dc;$val',
    },
    0x525 => { #6
        Name => 'PictureModeBWFilter',
        Writable => 'int16s',
        PrintConv => {
            0 => 'n/a',
            1 => 'Neutral',
            2 => 'Yellow',
            3 => 'Orange',
            4 => 'Red',
            5 => 'Green',
        },
    },
    0x526 => { #6
        Name => 'PictureModeTone',
        Writable => 'int16s',
        PrintConv => {
            0 => 'n/a',
            1 => 'Neutral',
            2 => 'Sepia',
            3 => 'Blue',
            4 => 'Purple',
            5 => 'Green',
        },
    },
    0x527 => { #12
        Name => 'NoiseFilter',
        Writable => 'int16s',
        Count => 3,
        PrintConv => {
           '-2 -2 1' => 'Off',
           '-1 -2 1' => 'Low',
           '0 -2 1' => 'Standard',
           '1 -2 1' => 'High',
        },
    },
    0x529 => { #PH
        Name => 'ArtFilter',
        Writable => 'int16u',
        Count => 4,
        PrintConv => \%filters,
    },
    0x52c => { #PH
        Name => 'MagicFilter',
        Writable => 'int16u',
        Count => 4,
        PrintConv => \%filters,
    },
    0x600 => { #PH/4
        Name => 'DriveMode',
        Writable => 'int16u',
        Count => -1,
        Notes => '2 or 3 numbers: 1. Mode, 2. Shot number, 3. Mode bits',
        PrintConv => q{
            my ($a,$b,$c) = split ' ',$val;
            return 'Single Shot' unless $a;
            if ($a == 5 and defined $c) {
                $a = DecodeBits($c, { #6
                    0 => 'AE',
                    1 => 'WB',
                    2 => 'FL',
                    3 => 'MF',
                }) . ' Bracketing';
                $a =~ s/, /+/g;
            } else {
                my %a = (
                    1 => 'Continuous Shooting',
                    2 => 'Exposure Bracketing',
                    3 => 'White Balance Bracketing',
                    4 => 'Exposure+WB Bracketing', #6
                );
                $a = $a{$a} || "Unknown ($a)";
            }
            return "$a, Shot $b";
        },
    },
    0x601 => { #6
        Name => 'PanoramaMode',
        Writable => 'int16u',
        Notes => '2 numbers: 1. Mode, 2. Shot number',
        PrintConv => q{
            my ($a,$b) = split ' ',$val;
            return 'Off' unless $a;
            my %a = (
                1 => 'Left to Right',
                2 => 'Right to Left',
                3 => 'Bottom to Top',
                4 => 'Top to Bottom',
            );
            return ($a{$a} || "Unknown ($a)") . ', Shot ' . $b;
        },
    },
    0x603 => { #PH/4
        Name => 'ImageQuality2',
        Writable => 'int16u',
        PrintConv => {
            1 => 'SQ',
            2 => 'HQ',
            3 => 'SHQ',
            4 => 'RAW',
            5 => 'SQ (5)', # (E-500)
        },
    },
    0x604 => { #PH
        Name => 'ImageStabilization',
        Writable => 'int32u',
        DataMember => 'ImageStabilization',
        RawConv => '$$self{ImageStabilization} = $val',
        PrintConv => {
            0 => 'Off',
            1 => 'On, Mode 1',
            2 => 'On, Mode 2',
            3 => 'On, Mode 3',
        },
    },
    0x900 => { #11
        Name => 'ManometerPressure',
        Writable => 'int16u',
        ValueConv => '$val / 10',
        ValueConvInv => '$val * 10',
        PrintConv => '"$val kPa"',
        PrintConvInv => '$val=~s/ ?kPa//i; $val',
    },
    0x901 => { #PH (u770SW)
        # 2 numbers: 1st looks like meters above sea level, 2nd is usually 3x the 1st (feet?)
        Name => 'ManometerReading',
        Writable => 'int32s',
        Count => 2,
        ValueConv => 'my @a=split(" ",$val); $_ /= 10 foreach @a; "@a"',
        ValueConvInv => 'my @a=split(" ",$val); $_ *= 10 foreach @a; "@a"',
        PrintConv => '$val=~s/(\S+) (\S+)/$1 m, $2 ft/; $val',
        PrintConvInv => '$val=~s/ ?(m|ft)//gi; $val',
    },
    0x902 => { #11
        Name => 'ExtendedWBDetect',
        Writable => 'int16u',
        PrintConv => \%offOn,
    },
    0x903 => { #11
        Name => 'LevelGaugeRoll',
        Writable => 'int16u',
        PrintConv => \%offOn,
    },
    0x904 => { #11
        Name => 'LevelGaugePitch',
        Writable => 'int16u',
        PrintConv => \%offOn,
    },
);

# Olympus RAW processing IFD (ref 6)
%Image::ExifTool::Olympus::RawDevelopment = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    WRITABLE => 1,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    0x000 => { #PH
        Name => 'RawDevVersion',
        Writable => 'undef',
        RawConv => '$val=~s/\0+$//; $val',  # (may be null terminated)
        Count => 4,
    },
    0x100 => {
        Name => 'RawDevExposureBiasValue',
        Writable => 'rational64s',
    },
    0x101 => {
        Name => 'RawDevWhiteBalanceValue',
        Writable => 'int16u',
    },
    0x102 => {
        Name => 'RawDevWBFineAdjustment',
        Writable => 'int16s',
    },
    0x103 => {
        Name => 'RawDevGrayPoint',
        Writable => 'int16u',
        Count => 3,
    },
    0x104 => {
        Name => 'RawDevSaturationEmphasis',
        Writable => 'int16s',
        Count => 3,
    },
    0x105 => {
        Name => 'RawDevMemoryColorEmphasis',
        Writable => 'int16u',
    },
    0x106 => {
        Name => 'RawDevContrastValue',
        Writable => 'int16s',
        Count => 3,
    },
    0x107 => {
        Name => 'RawDevSharpnessValue',
        Writable => 'int16s',
        Count => 3,
    },
    0x108 => {
        Name => 'RawDevColorSpace',
        Writable => 'int16u',
        PrintConv => { #11
            0 => 'sRGB',
            1 => 'Adobe RGB',
            2 => 'Pro Photo RGB',
        },
    },
    0x109 => {
        Name => 'RawDevEngine',
        Writable => 'int16u',
        PrintConv => { #11
            0 => 'High Speed',
            1 => 'High Function',
            2 => 'Advanced High Speed',
            3 => 'Advanced High Function',
        },
    },
    0x10a => {
        Name => 'RawDevNoiseReduction',
        Writable => 'int16u',
        PrintConv => { #11
            BITMASK => {
                0 => 'Noise Reduction',
                1 => 'Noise Filter',
                2 => 'Noise Filter (ISO Boost)',
            },
        },
    },
    0x10b => {
        Name => 'RawDevEditStatus',
        Writable => 'int16u',
        PrintConv => { #11
            0 => 'Original',
            1 => 'Edited (Landscape)',
            6 => 'Edited (Portrait)',
            8 => 'Edited (Portrait)',
        },
    },
    0x10c => {
        Name => 'RawDevSettings',
        Writable => 'int16u',
        PrintConv => { #11
            BITMASK => {
                0 => 'WB Color Temp',
                1 => 'WB Gray Point',
                2 => 'Saturation',
                3 => 'Contrast',
                4 => 'Sharpness',
                5 => 'Color Space',
                6 => 'High Function',
                7 => 'Noise Reduction',
            },
        },
    },
);

# Olympus RAW processing B IFD (ref 11)
%Image::ExifTool::Olympus::RawDevelopment2 = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    WRITABLE => 1,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    0x000 => {
        Name => 'RawDevVersion',
        Writable => 'undef',
        RawConv => '$val=~s/\0+$//; $val',  # (may be null terminated)
        Count => 4,
    },
    0x100 => {
        Name => 'RawDevExposureBiasValue',
        Writable => 'rational64s',
    },
    0x101 => {
        Name => 'RawDevWhiteBalance',
        Writable => 'int16u',
        PrintConv => {
            1 => 'Color Temperature',
            2 => 'Gray Point',
        },
    },
    0x102 => {
        Name => 'RawDevWhiteBalanceValue',
        Writable => 'int16u',
    },
    0x103 => {
        Name => 'RawDevWBFineAdjustment',
        Writable => 'int16s',
    },
    0x104 => {
        Name => 'RawDevGrayPoint',
        Writable => 'int16u',
        Count => 3,
    },
    0x105 => {
        Name => 'RawDevContrastValue',
        Writable => 'int16s',
        Count => 3,
    },
    0x106 => {
        Name => 'RawDevSharpnessValue',
        Writable => 'int16s',
        Count => 3,
    },
    0x107 => {
        Name => 'RawDevSaturationEmphasis',
        Writable => 'int16s',
        Count => 3,
    },
    0x108 => {
        Name => 'RawDevMemoryColorEmphasis',
        Writable => 'int16u',
    },
    0x109 => {
        Name => 'RawDevColorSpace',
        Writable => 'int16u',
        PrintConv => {
            0 => 'sRGB',
            1 => 'Adobe RGB',
            2 => 'Pro Photo RGB',
        },
    },
    0x10a => {
        Name => 'RawDevNoiseReduction',
        Writable => 'int16u',
        PrintConv => {
            BITMASK => {
                0 => 'Noise Reduction',
                1 => 'Noise Filter',
                2 => 'Noise Filter (ISO Boost)',
            },
        },
    },
    0x10b => {
        Name => 'RawDevEngine',
        Writable => 'int16u',
        PrintConv => {
            0 => 'High Speed',
            1 => 'High Function',
        },
    },
    0x10c => {
        Name => 'RawDevPictureMode',
        Writable => 'int16u',
        PrintConv => {
            1 => 'Vivid',
            2 => 'Natural',
            3 => 'Muted',
            256 => 'Monotone',
            512 => 'Sepia',
        },
    },
    0x10d => {
        Name => 'RawDevPMSaturation',
        Writable => 'int16s',
        Count => 3,
    },
    0x10e => {
        Name => 'RawDevPMContrast',
        Writable => 'int16s',
        Count => 3,
    },
    0x10f => {
        Name => 'RawDevPMSharpness',
        Writable => 'int16s',
        Count => 3,
    },
    0x110 => {
        Name => 'RawDevPM_BWFilter',
        Writable => 'int16u',
        PrintConv => {
            1 => 'Neutral',
            2 => 'Yellow',
            3 => 'Orange',
            4 => 'Red',
            5 => 'Green',
        },
    },
    0x111 => {
        Name => 'RawDevPMPictureTone',
        Writable => 'int16u',
        PrintConv => {
            1 => 'Neutral',
            2 => 'Sepia',
            3 => 'Blue',
            4 => 'Purple',
            5 => 'Green',
        },
    },
    0x112 => {
        Name => 'RawDevGradation',
        Writable => 'int16s',
        Count => 3,
    },
    0x113 => {
        Name => 'RawDevSaturation3',
        Writable => 'int16s',
        Count => 3, #(NC)
    },
    0x119 => {
        Name => 'RawDevAutoGradation',
        Writable => 'int16u', #(NC)
        PrintConv => \%offOn,
    },
    0x120 => {
        Name => 'RawDevPMNoiseFilter',
        Writable => 'int16u', #(NC)
    },
);

# Olympus Image processing IFD
%Image::ExifTool::Olympus::ImageProcessing = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    WRITABLE => 1,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    0x000 => { #PH
        Name => 'ImageProcessingVersion',
        Writable => 'undef',
        RawConv => '$val=~s/\0+$//; $val',  # (may be null terminated)
        Count => 4,
    },
    0x100 => { #6
        Name => 'WB_RBLevels',
        Writable => 'int16u',
        Count => 2,
    },
    0x102 => { #11
        Name => 'WB_RBLevels3000K',
        Writable => 'int16u',
        Count => 2,
    },
    0x103 => { #11
        Name => 'WB_RBLevels3300K',
        Writable => 'int16u',
        Count => 2,
    },
    0x104 => { #11
        Name => 'WB_RBLevels3600K',
        Writable => 'int16u',
        Count => 2,
    },
    0x105 => { #11
        Name => 'WB_RBLevels3900K',
        Writable => 'int16u',
        Count => 2,
    },
    0x106 => { #11
        Name => 'WB_RBLevels4000K',
        Writable => 'int16u',
        Count => 2,
    },
    0x107 => { #11
        Name => 'WB_RBLevels4300K',
        Writable => 'int16u',
        Count => 2,
    },
    0x108 => { #11
        Name => 'WB_RBLevels4500K',
        Writable => 'int16u',
        Count => 2,
    },
    0x109 => { #11
        Name => 'WB_RBLevels4800K',
        Writable => 'int16u',
        Count => 2,
    },
    0x10a => { #11
        Name => 'WB_RBLevels5300K',
        Writable => 'int16u',
        Count => 2,
    },
    0x10b => { #11
        Name => 'WB_RBLevels6000K',
        Writable => 'int16u',
        Count => 2,
    },
    0x10c => { #11
        Name => 'WB_RBLevels6600K',
        Writable => 'int16u',
        Count => 2,
    },
    0x10d => { #11
        Name => 'WB_RBLevels7500K',
        Writable => 'int16u',
        Count => 2,
    },
    0x10e => { #11
        Name => 'WB_RBLevelsCWB1',
        Writable => 'int16u',
        Count => 2,
    },
    0x10f => { #11
        Name => 'WB_RBLevelsCWB2',
        Writable => 'int16u',
        Count => 2,
    },
    0x110 => { #11
        Name => 'WB_RBLevelsCWB3',
        Writable => 'int16u',
        Count => 2,
    },
    0x111 => { #11
        Name => 'WB_RBLevelsCWB4',
        Writable => 'int16u',
        Count => 2,
    },
    0x113 => { #11
        Name => 'WB_GLevel3000K',
        Writable => 'int16u',
    },
    0x114 => { #11
        Name => 'WB_GLevel3300K',
        Writable => 'int16u',
    },
    0x115 => { #11
        Name => 'WB_GLevel3600K',
        Writable => 'int16u',
    },
    0x116 => { #11
        Name => 'WB_GLevel3900K',
        Writable => 'int16u',
    },
    0x117 => { #11
        Name => 'WB_GLevel4000K',
        Writable => 'int16u',
    },
    0x118 => { #11
        Name => 'WB_GLevel4300K',
        Writable => 'int16u',
    },
    0x119 => { #11
        Name => 'WB_GLevel4500K',
        Writable => 'int16u',
    },
    0x11a => { #11
        Name => 'WB_GLevel4800K',
        Writable => 'int16u',
    },
    0x11b => { #11
        Name => 'WB_GLevel5300K',
        Writable => 'int16u',
    },
    0x11c => { #11
        Name => 'WB_GLevel6000K',
        Writable => 'int16u',
    },
    0x11d => { #11
        Name => 'WB_GLevel6600K',
        Writable => 'int16u',
    },
    0x11e => { #11
        Name => 'WB_GLevel7500K',
        Writable => 'int16u',
    },
    0x11f => { #11
        Name => 'WB_GLevel',
        Writable => 'int16u',
    },
    0x200 => { #6
        Name => 'ColorMatrix',
        Writable => 'int16u',
        Format => 'int16s',
        Count => 9,
    },
    # color matrices (ref 11):
    # 0x0201-0x020d are sRGB color matrices
    # 0x020e-0x021a are Adobe RGB color matrices
    # 0x021b-0x0227 are ProPhoto RGB color matrices
    # 0x0228 and 0x0229 are ColorMatrix for E-330
    # 0x0250-0x0252 are sRGB color matrices
    # 0x0253-0x0255 are Adobe RGB color matrices
    # 0x0256-0x0258 are ProPhoto RGB color matrices
    0x300 => { #11
        Name => 'Enhancer',
        Writable => 'int16u',
    },
    0x301 => { #11
        Name => 'EnhancerValues',
        Writable => 'int16u',
        Count => 7,
    },
    0x310 => { #11
        Name => 'CoringFilter',
        Writable => 'int16u',
    },
    0x0311 => { #11
        Name => 'CoringValues',
        Writable => 'int16u',
        Count => 7,
    },
    0x600 => { #11
        Name => 'BlackLevel2',
        Writable => 'int16u',
        Count => 4,
    },
    0x610 => { #11
        Name => 'GainBase',
        Writable => 'int16u',
    },
    0x611 => { #4/6
        Name => 'ValidBits',
        Writable => 'int16u',
        Count => 2,
    },
    0x612 => { #11
        Name => 'CropLeft',
        Writable => 'int16u',
        Count => 2,
    },
    0x613 => { #11
        Name => 'CropTop',
        Writable => 'int16u',
        Count => 2,
    },
    0x614 => { #PH/11
        Name => 'CropWidth',
        Writable => 'int32u',
    },
    0x615 => { #PH/11
        Name => 'CropHeight',
        Writable => 'int32u',
    },
    # 0x800 LensDistortionParams, float[9] (ref 11)
    # 0x801 LensShadingParams, int16u[16] (ref 11)
    # 0x1010-0x1012 are the processing options used in camera or in
    # Olympus software, which 0x050a-0x050c are in-camera only (ref 6)
    0x1010 => { #PH/4
        Name => 'NoiseReduction2',
        Writable => 'int16u',
        PrintConv => {
            BITMASK => {
                0 => 'Noise Reduction',
                1 => 'Noise Filter',
                2 => 'Noise Filter (ISO Boost)',
            },
        },
    },
    0x1011 => { #6
        Name => 'DistortionCorrection2',
        Writable => 'int16u',
        PrintConv => \%offOn,
    },
    0x1012 => { #PH/4
        Name => 'ShadingCompensation2',
        Writable => 'int16u',
        PrintConv => \%offOn,
    },
    0x101c => { #11
        Name => 'MultipleExposureMode',
        Writable => 'int16u',
        Count => 2,
        PrintConv => [{
            0 => 'Off',
            2 => 'On (2 frames)',
            3 => 'On (3 frames)',
        }],
    },
    0x1103 => { #PH
        Name => 'UnknownBlock',
        Writable => 'undef',
        Notes => 'unknown 142kB block in ORF images, not copied to JPEG images',
        # 'Drop' because too large for APP1 in JPEG images
        Flags => [ 'Unknown', 'Binary', 'Drop' ],
    },
    0x1112 => { #11
        Name => 'AspectRatio',
        Writable => 'int8u',
        Count => 2,
        PrintConv => {
            '1 1' => '4:3',
            '2 2' => '3:2',
            '3 3' => '16:9',
            '4 4' => '6:6',
            '5 5' => '5:4',
            '6 6' => '7:6',
            '7 7' => '6:5',
            '8 8' => '7:5',
            '9 9' => '3:4',
        },
    },
    0x1113 => { #11
        Name => 'AspectFrame',
        Writable => 'int16u',
        Count => 4,
    },
    0x1200 => { #11/PH
        Name => 'FacesDetected',
        Writable => 'int32u',
        Count => -1,
        Notes => '2 or 3 values',
    },
    0x1201 => { #11/PH
        Name => 'FaceDetectArea',
        Writable => 'int16s',
        Count => -1, # (varies with model)
        Binary => 1, # (too long)
        Notes => q{
            for models with 2 values in FacesDetected this gives X/Y coordinates in the
            FaceDetectFrame for all 4 corners of the face rectangle.  For models with 3
            values in FacesDetected this gives X/Y coordinates, size and rotation angle
            of the face detect square
        },
    },
    0x1202 => { #PH
        Name => 'MaxFaces',
        Writable => 'int32u',
        Count => 3,
    },
    0x1203 => { #PH
        Name => 'FaceDetectFrameSize',
        Writable => 'int16u',
        Count => 6,
        Notes => 'width/height of the full face detect frame',
    },
    0x1207 => { #PH
        Name => 'FaceDetectFrameCrop',
        Writable => 'int16s',
        Count => 12,
        Notes => 'X/Y offset and width/height of the cropped face detect frame',
    },
);

# Olympus Focus Info IFD
%Image::ExifTool::Olympus::FocusInfo = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    WRITABLE => 1,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    0x000 => { #PH
        Name => 'FocusInfoVersion',
        Writable => 'undef',
        RawConv => '$val=~s/\0+$//; $val',  # (may be null terminated)
        Count => 4,
    },
    0x209 => { #PH/4
        Name => 'AutoFocus',
        Writable => 'int16u',
        PrintConv => \%offOn,
        Unknown => 1, #6
    },
    0x210 => { #11
        Name => 'SceneDetect',
        Writable => 'int16u',
    },
    0x211 => { #11
        Name => 'SceneArea',
        Writable => 'int32u',
        Count => 8,
        Unknown => 1, # (numbers don't make much sense?)
    },
    0x212 => { #11
        Name => 'SceneDetectData',
        Writable => 'int32u',
        Count => 720,
        Binary => 1,
        Unknown => 1, # (but what does it mean?)
    },
    0x300 => { #6
        Name => 'ZoomStepCount',
        Writable => 'int16u',
    },
    0x301 => { #11
        Name => 'FocusStepCount',
        Writable => 'int16u',
    },
    0x303 => { #11
        Name => 'FocusStepInfinity',
        Writable => 'int16u',
    },
    0x304 => { #11
        Name => 'FocusStepNear',
        Writable => 'int16u',
    },
    0x305 => { #4
        Name => 'FocusDistance',
        Writable => 'rational64u',
        # this rational value looks like it is in mm when the denominator is
        # 1 (E-1), and cm when denominator is 10 (E-300), so if we ignore the
        # denominator we are consistently in mm - PH
        Format => 'int32u',
        Count => 2,
        ValueConv => q{
            my ($a,$b) = split ' ',$val;
            return 0 if $a == 0xffffffff;
            return $a / 1000;
        },
        ValueConvInv => q{
            return '4294967295 1' unless $val;
            $val = int($val * 1000 + 0.5);
            return "$val 1";
        },
        PrintConv => '$val ? "$val m" : "inf"',
        PrintConvInv => '$val eq "inf" ? 0 : $val=~s/\s*m$//, $val',
    },
    0x308 => [ # NEED A BETTER WAY TO DETERMINE WHICH MODELS USE WHICH ENCODING!
        {
            Name => 'AFPoint',
            Condition => '$$self{Model} =~ /E-(3|5|30)\b/',
            Writable => 'int16u',
            PrintHex => 1,
            # decoded by ref 6
            Notes => q{
                for the E-3, E-5 and E-30 the value is separated into 2 parts: low 5 bits
                give AF point, upper bits give AF target selection mode
            },
            ValueConv => '($val & 0x1f) . " " . ($val & 0xffe0)',
            ValueConvInv => 'my @v=split(" ",$val); @v == 2 ? $v[0] + $v[1] : $val',
            PrintConv => [
                {
                    0x00 => '(none)',
                    0x01 => 'Top-left (horizontal)',
                    0x02 => 'Top-center (horizontal)',
                    0x03 => 'Top-right (horizontal)',
                    0x04 => 'Left (horizontal)',
                    0x05 => 'Mid-left (horizontal)',
                    0x06 => 'Center (horizontal)',
                    0x07 => 'Mid-right (horizontal)',
                    0x08 => 'Right (horizontal)',
                    0x09 => 'Bottom-left (horizontal)',
                    0x0a => 'Bottom-center (horizontal)',
                    0x0b => 'Bottom-right (horizontal)',
                    0x0c => 'Top-left (vertical)',
                    0x0d => 'Top-center (vertical)',
                    0x0e => 'Top-right (vertical)',
                    0x0f => 'Left (vertical)',
                    0x10 => 'Mid-left (vertical)',
                    0x11 => 'Center (vertical)',
                    0x12 => 'Mid-right (vertical)',
                    0x13 => 'Right (vertical)',
                    0x14 => 'Bottom-left (vertical)',
                    0x15 => 'Bottom-center (vertical)',
                    0x16 => 'Bottom-right (vertical)',
                },
                {
                    0x00 => 'Single Target',
                    0x40 => 'All Target',
                    0x80 => 'Dynamic Single Target',
                }
            ],
        },{ #PH (models with 7-point AF)
            Name => 'AFPoint',
            Condition => '$$self{Model} =~ /E-(520|600|620)\b/',
            Notes => 'models with 7-point AF',
            Writable => 'int16u',
            PrintHex => 1,
            ValueConv => '($val & 0x1f) . " " . ($val & 0xffe0)',
            ValueConvInv => 'my @v=split(" ",$val); @v == 2 ? $v[0] + $v[1] : $val',
            PrintConv => [
                {
                    0x00 => '(none)',
                    0x01 => 'Center',
                    # need to fill this in...
                },
                {
                    0x00 => 'Single Target',
                    0x40 => 'All Target', # (guess)
                },
            ]
        },{ #11
            Name => 'AFPoint',
            Writable => 'int16u',
            Notes => 'other models',
            RawConv => '($val or $$self{Model} ne "E-P1") ? $val : undef',
            PrintConv => {
                # (E-P1 always writes 0, maybe other models do too - PH)
                0 => 'Left (or n/a)',
                1 => 'Center (horizontal)', #6 (E-510)
                2 => 'Right',
                3 => 'Center (vertical)', #6 (E-510)
                255 => 'None',
            },
        }
    ],
    # 0x31a Continuous AF parameters?
    # 0x328 Related to AF (maybe Imager AF data?) (ref PH, E-PL1):
    #  - offset 0x2a (int8u)  ImagerAFMode?  0=Manual, 1=Auto
    #  - offset 0x30 (int16u) AFAreaXPosition
    #  - offset 0x32 (int16u) AFAreaWidth (202)
    #  - offset 0x34 (int16u) AFAreaYPosition
    #  - offset 0x36 (int16u) AFAreaHeight (50)
    #  (AF area positions above give the top-left coordinates of the AF area in the
    #   AF frame. Increasing Y is downwards, and the AF frame size is about 1280x256)
    # 0x1200-0x1209 Flash information:
    0x1201 => { #6
        Name => 'ExternalFlash',
        Writable => 'int16u',
        Count => 2,
        PrintConv => {
            '0 0' => 'Off',
            '1 0' => 'On',
        },
    },
    0x1203 => { #11
        Name => 'ExternalFlashGuideNumber',
        Writable => 'rational64s',
        Unknown => 1, # (needs verification)
    },
    0x1204 => { #11(reversed)/7
        Name => 'ExternalFlashBounce',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Bounce or Off',
            1 => 'Direct',
        },
    },
    0x1205 => { #11 (ref converts to mm using table)
        Name => 'ExternalFlashZoom',
        Writable => 'rational64u',
    },
    0x1208 => { #6
        Name => 'InternalFlash',
        Writable => 'int16u',
        Count => -1,
        PrintConv => {
            '0'   => 'Off',
            '1'   => 'On',
            '0 0' => 'Off',
            '1 0' => 'On',
        },
    },
    0x1209 => { #6
        Name => 'ManualFlash',
        Writable => 'int16u',
        Count => 2,
        Notes => '2 numbers: 1. 0=Off, 1=On, 2. Flash strength',
        PrintConv => q{
            my ($a,$b) = split ' ',$val;
            return 'Off' unless $a;
            $b = ($b == 1) ? 'Full' : "1/$b";
            return "On ($b strength)";
        },
    },
    0x1500 => { #6
        Name => 'SensorTemperature',
        Writable => 'int16s',
        Notes => q{
            approximately Celsius for E-1, unknown calibration for E-3/410/420/510, and
            always zero for E-300/330/400/500, divide by 10 for E-P1?
        },
    },
    0x1600 => { # ref http://fourthirdsphoto.com/vbb/showpost.php?p=107607&postcount=15
        Name => 'ImageStabilization',
        # (the other value is more reliable, so ignore this totally if the other exists)
        Condition => 'not defined $$self{ImageStabilization}',
        Writable => 'undef',
        # if the first 4 bytes are non-zero, then bit 0x01 of byte 44
        # gives the stabilization mode
        PrintConv => q{
            $val =~ /^\0{4}/ ? 'Off' : 'On, ' .
            (unpack('x44C',$val) & 0x01 ? 'Mode 1' : 'Mode 2')
        },
    },
    # 0x102a same as Subdir4-0x300
);

# Olympus raw information tags (ref 6)
%Image::ExifTool::Olympus::RawInfo = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    NOTES => 'These tags are found only in ORF images of some models (ie. C8080WZ).',
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    0x000 => {
        Name => 'RawInfoVersion',
        Writable => 'undef',
        RawConv => '$val=~s/\0+$//; $val',  # (may be null terminated)
        Count => 4,
    },
    0x100 => {
        Name => 'WB_RBLevelsUsed',
        Writable => 'int16u',
        Count => 2,
    },
    0x110 => {
        Name => 'WB_RBLevelsAuto',
        Writable => 'int16u',
        Count => 2,
    },
    0x120 => {
        Name => 'WB_RBLevelsShade',
        Writable => 'int16u',
        Count => 2,
    },
    0x121 => {
        Name => 'WB_RBLevelsCloudy',
        Writable => 'int16u',
        Count => 2,
    },
    0x122 => {
        Name => 'WB_RBLevelsFineWeather',
        Writable => 'int16u',
        Count => 2,
    },
    0x123 => {
        Name => 'WB_RBLevelsTungsten',
        Writable => 'int16u',
        Count => 2,
    },
    0x124 => {
        Name => 'WB_RBLevelsEveningSunlight',
        Writable => 'int16u',
        Count => 2,
    },
    0x130 => {
        Name => 'WB_RBLevelsDaylightFluor',
        Writable => 'int16u',
        Count => 2,
    },
    0x131 => {
        Name => 'WB_RBLevelsDayWhiteFluor',
        Writable => 'int16u',
        Count => 2,
    },
    0x132 => {
        Name => 'WB_RBLevelsCoolWhiteFluor',
        Writable => 'int16u',
        Count => 2,
    },
    0x133 => {
        Name => 'WB_RBLevelsWhiteFluorescent',
        Writable => 'int16u',
        Count => 2,
    },
    0x200 => {
        Name => 'ColorMatrix2',
        Format => 'int16s',
        Writable => 'int16u',
        Count => 9,
    },
    # 0x240 => 'ColorMatrixDefault', ?
    # 0x250 => 'ColorMatrixSaturation', ?
    # 0x251 => 'ColorMatrixHue', ?
    # 0x252 => 'ColorMatrixContrast', ?
    # 0x300 => sharpness-related
    # 0x301 => list of sharpness-related values
    0x310 => {
        Name => 'CoringFilter',
        Writable => 'int16u',
    },
    0x311 => {
        Name => 'CoringValues',
        Writable => 'int16u',
        Count => 11,
    },
    0x600 => {
        Name => 'BlackLevel2',
        Writable => 'int16u',
        Count => 4,
    },
    0x601 => {
        Name => 'YCbCrCoefficients',
        Notes => 'stored as int16u[6], but extracted as rational32u[3]',
        Format => 'rational32u',
    },
    0x611 => {
        Name => 'ValidPixelDepth',
        Writable => 'int16u',
        Count => 2,
    },
    0x612 => { #11
        Name => 'CropLeft',
        Writable => 'int16u',
    },
    0x613 => { #11
        Name => 'CropTop',
        Writable => 'int16u',
    },
    0x614 => {
        Name => 'CropWidth',
        Writable => 'int32u',
    },
    0x615 => {
        Name => 'CropHeight',
        Writable => 'int32u',
    },
    0x1000 => {
        Name => 'LightSource',
        Writable => 'int16u',
        PrintConv => {
            0 => 'Unknown',
            16 => 'Shade',
            17 => 'Cloudy',
            18 => 'Fine Weather',
            20 => 'Tungsten (Incandescent)',
            22 => 'Evening Sunlight',
            33 => 'Daylight Fluorescent',
            34 => 'Day White Fluorescent',
            35 => 'Cool White Fluorescent',
            36 => 'White Fluorescent',
            256 => 'One Touch White Balance',
            512 => 'Custom 1-4',
        },
    },
    # the following 5 tags all have 3 values: val, min, max
    0x1001 => {
        Name => 'WhiteBalanceComp',
        Writable => 'int16s',
        Count => 3,
    },
    0x1010 => {
        Name => 'SaturationSetting',
        Writable => 'int16s',
        Count => 3,
    },
    0x1011 => {
        Name => 'HueSetting',
        Writable => 'int16s',
        Count => 3,
    },
    0x1012 => {
        Name => 'ContrastSetting',
        Writable => 'int16s',
        Count => 3,
    },
    0x1013 => {
        Name => 'SharpnessSetting',
        Writable => 'int16s',
        Count => 3,
    },
    # settings written by Camedia Master 4.x
    0x2000 => {
        Name => 'CMExposureCompensation',
        Writable => 'rational64s',
    },
    0x2001 => {
        Name => 'CMWhiteBalance',
        Writable => 'int16u',
    },
    0x2002 => {
        Name => 'CMWhiteBalanceComp',
        Writable => 'int16s',
    },
    0x2010 => {
        Name => 'CMWhiteBalanceGrayPoint',
        Writable => 'int16u',
        Count => 3,
    },
    0x2020 => {
        Name => 'CMSaturation',
        Writable => 'int16s',
        Count => 3,
    },
    0x2021 => {
        Name => 'CMHue',
        Writable => 'int16s',
        Count => 3,
    },
    0x2022 => {
        Name => 'CMContrast',
        Writable => 'int16s',
        Count => 3,
    },
    0x2023 => {
        Name => 'CMSharpness',
        Writable => 'int16s',
        Count => 3,
    },
);

# Olympus unknown information tags
%Image::ExifTool::Olympus::UnknownInfo = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
);

# Tags found only in some FE models
%Image::ExifTool::Olympus::FETags = (
    WRITE_PROC => \&Image::ExifTool::Exif::WriteExif,
    CHECK_PROC => \&Image::ExifTool::Exif::CheckExif,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    NOTES => q{
        Some FE models write a large number of tags here, but most of this
        information remains unknown.
    },
    0x0100 => {
        Name => 'BodyFirmwareVersion',
        Writable => 'string',
    },
);

# tags in Olympus QuickTime videos (ref PH)
# (similar information in Kodak,Minolta,Nikon,Olympus,Pentax and Sanyo videos)
%Image::ExifTool::Olympus::MOV1 = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    FIRST_ENTRY => 0,
    NOTES => q{
        This information is found in MOV videos from Olympus models such as the
        D540Z, D595Z, FE100, FE110, FE115, FE170 and FE200.
    },
    0x00 => {
        Name => 'Make',
        Format => 'string[24]',
    },
    0x18 => {
        Name => 'Model',
        Format => 'string[8]',
    },
    # (01 00 at offset 0x20)
    0x26 => {
        Name => 'ExposureUnknown',
        Unknown => 1,
        Format => 'int32u',
        # this conversion doesn't work for all models (ie. gives "1/100000")
        ValueConv => '$val ? 10 / $val : 0',
        PrintConv => 'Image::ExifTool::Exif::PrintExposureTime($val)',
    },
    0x2a => {
        Name => 'FNumber',
        Format => 'rational64u',
        PrintConv => 'sprintf("%.1f",$val)',
    },
    0x32 => { #(NC)
        Name => 'ExposureCompensation',
        Format => 'rational64s',
        PrintConv => 'Image::ExifTool::Exif::PrintFraction($val)',
    },
  # 0x44 => WhiteBalance ?
    0x48 => {
        Name => 'FocalLength',
        Format => 'rational64u',
        PrintConv => 'sprintf("%.1f mm",$val)',
    },
  # 0xb1 => 'ISO', #(I don't think this works - PH)
);

# tags in Olympus QuickTime videos (ref PH)
# (similar information in Kodak,Minolta,Nikon,Olympus,Pentax and Sanyo videos)
%Image::ExifTool::Olympus::MOV2 = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    FIRST_ENTRY => 0,
    NOTES => q{
        This information is found in MOV videos from Olympus models such as the
        FE120, FE140 and FE190.
    },
    0x00 => {
        Name => 'Make',
        Format => 'string[24]',
    },
    0x18 => {
        Name => 'Model',
        Format => 'string[24]',
    },
    # (01 00 at offset 0x30)
    0x36 => {
        Name => 'ExposureTime',
        Format => 'int32u',
        ValueConv => '$val ? 10 / $val : 0',
        PrintConv => 'Image::ExifTool::Exif::PrintExposureTime($val)',
    },
    0x3a => {
        Name => 'FNumber',
        Format => 'rational64u',
        PrintConv => 'sprintf("%.1f",$val)',
    },
    0x42 => { #(NC)
        Name => 'ExposureCompensation',
        Format => 'rational64s',
        PrintConv => 'Image::ExifTool::Exif::PrintFraction($val)',
    },
    0x58 => {
        Name => 'FocalLength',
        Format => 'rational64u',
        PrintConv => 'sprintf("%.1f mm",$val)',
    },
    0xc1 => {
        Name => 'ISO',
        Format => 'int16u',
    },
);

# tags in Olympus MP4 videos (ref PH)
%Image::ExifTool::Olympus::MP4 = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    FIRST_ENTRY => 0,
    NOTES => q{
        This information is found in MP4 videos from Olympus models such as the
        u7040 and u9010.
    },
    0x00 => {
        Name => 'Make',
        Format => 'string[24]',
    },
    0x18 => {
        Name => 'Model',
        Format => 'string[24]',
    },
    0x28 => {
        Name => 'FNumber',
        Format => 'rational64u',
        PrintConv => 'sprintf("%.1f",$val)',
    },
    0x30 => { #(NC)
        Name => 'ExposureCompensation',
        Format => 'rational64s',
        PrintConv => 'Image::ExifTool::Exif::PrintFraction($val)',
    },
    # NEED MORE SAMPLES TO DECODE THIS
);

# tags in Olympus AVI videos (ref PH)
%Image::ExifTool::Olympus::AVI = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    FIRST_ENTRY => 0,
    NOTES => 'This information is found in Olympus AVI videos.',
    0x12 => {
        Name => 'Make',
        Format => 'string[24]',
    },
    0x2c => {
        Name => 'ModelType',
        Format => 'string[24]',
    },
    0x5e => {
        Name => 'FNumber',
        Format => 'rational64u',
        PrintConv => 'sprintf("%.1f",$val)',
    },
    0x83 => {
        Name => 'DateTime1',
        Format => 'string[24]',
        Groups => { 2 => 'Time' },
    },
    0x9d => {
        Name => 'DateTime2',
        Format => 'string[24]',
        Groups => { 2 => 'Time' },
    },
    0x12d => {
        Name => 'ThumbnailLength',
        Format => 'int32u',
    },
    0x131 => {
        Name => 'ThumbnailImage',
        Format => 'undef[$val{0x12d}]',
        Notes => '160x120 JPEG thumbnail image',
        RawConv => '$self->ValidateImage(\$val,$tag)',
    },
);

# tags in WAV files from Olympus PCM linear recorders (ref 18)
%Image::ExifTool::Olympus::WAV = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Audio' },
    FIRST_ENTRY => 0,
    NOTES => q{
        This information is found in WAV files from Olympus PCM linear recorders
        like the LS-5, LS-10, LS-11.
    },
    0x0c => {
        Name => 'Model',
        Format => 'string[16]',
    },
    0x1c => {
        Name => 'FileNumber',
        Format => 'int32u',
        PrintConv => 'sprintf("%.4d", $val)',
    },
    0x26 => {
        Name => 'DateTimeOriginal',
        Description => 'Date/Time Original',
        Groups => { 2 => 'Time' },
        Format => 'undef[12]',
        Notes => 'time at start of recording',
        ValueConv => q{
            return undef unless $val =~ /^(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$/;
            my $y = $1 < 70 ? "20$1" : "19$1";
            return "$y:$2:$3 $4:$5:$6";
        },
        PrintConv => '$self->ConvertDateTime($val)',
    },
    0x32 => {
        Name => 'DateTimeEnd',
        Groups => { 2 => 'Time' },
        Format => 'undef[12]',
        Notes => 'time at end of recording',
        ValueConv => q{
            return undef unless $val =~ /^(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$/;
            my $y = $1 < 70 ? "20$1" : "19$1";
            return "$y:$2:$3 $4:$5:$6";
        },
        PrintConv => '$self->ConvertDateTime($val)',
    },
    0x3e => {
        Name => 'RecordingTime',
        Format => 'undef[6]',
        ValueConv => '$val =~ s/^(\d{2})(\d{2})/$1:$2:/; $val',
    },
    0x200 => {
        Name => 'Duration',
        Format => 'int32u',
        ValueConv => '$val / 1000',
        PrintConv => 'ConvertDuration($val)',
    },
    0x20a => { Name => 'Index01', %indexInfo },
    0x214 => { Name => 'Index02', %indexInfo },
    0x21e => { Name => 'Index03', %indexInfo },
    0x228 => { Name => 'Index04', %indexInfo },
    0x232 => { Name => 'Index05', %indexInfo },
    0x23c => { Name => 'Index06', %indexInfo },
    0x246 => { Name => 'Index07', %indexInfo },
    0x250 => { Name => 'Index08', %indexInfo },
    0x25a => { Name => 'Index09', %indexInfo },
    0x264 => { Name => 'Index10', %indexInfo },
    0x26e => { Name => 'Index11', %indexInfo },
    0x278 => { Name => 'Index12', %indexInfo },
    0x282 => { Name => 'Index13', %indexInfo },
    0x28c => { Name => 'Index14', %indexInfo },
    0x296 => { Name => 'Index15', %indexInfo },
    0x2a0 => { Name => 'Index16', %indexInfo },
);

# Olympus composite tags
%Image::ExifTool::Olympus::Composite = (
    GROUPS => { 2 => 'Camera' },
    ExtenderStatus => {
        Notes => q{
            Olympus cameras have the quirk that they may retain the extender settings
            after the extender is removed until the camera is powered off.  This tag is
            an attempt to represent the actual status of the extender.
        },
        Require => {
            0 => 'Olympus:Extender',
            1 => 'Olympus:LensType',
            2 => 'MaxApertureValue',
        },
        ValueConv => 'Image::ExifTool::Olympus::ExtenderStatus($val[0],$prt[1],$val[2])',
        PrintConv => {
            0 => 'Not attached',
            1 => 'Attached',
            2 => 'Removed',
        },
    },
    ZoomedPreviewImage => {
        Require => {
            0 => 'ZoomedPreviewStart',
            1 => 'ZoomedPreviewLength',
        },
        RawConv => 'Image::ExifTool::Exif::ExtractImage($self,$val[0],$val[1],"ZoomedPreviewImage")',
    },
);

# add our composite tags
Image::ExifTool::AddCompositeTags('Image::ExifTool::Olympus');


#------------------------------------------------------------------------------
# Determine if the extender (EX-25/EC-14) was really attached (ref 9)
# Inputs: 0) Extender, 1) LensType string, 2) MaxApertureAtMaxFocal
# Returns: 0=not attached, 1=attached, 2=could have been removed
# Notes: Olympus has a bug in the in-camera firmware which results in the
# extender information being cached and written into the EXIF data even after
# the extender has been removed.  You must power cycle the camera to prevent it
# from writing the cached extender information into the EXIF data.
sub ExtenderStatus($$$)
{
    my ($extender, $lensType, $maxAperture) = @_;
    my @info = split ' ', $extender;
    # validate that extender identifier is reasonable
    return 0 unless @info >= 2 and $info[1];
    # if it's not an EC-14 (id 0 4) then assume it was really attached
    # (other extenders don't seem to affect the reported max aperture)
    return 1 if "$info[0] $info[1]" ne '0 4';
    # get the maximum aperture for this lens (in $1)
    $lensType =~ / F(\d+(.\d+)?)/ or return 1;
    # If the maximum aperture at the maximum focal length is greater than the
    # known max/max aperture of the lens, then the extender must be attached
    return ($maxAperture - $1 > 0.2) ? 1 : 2;
}

#------------------------------------------------------------------------------
# Print AF points
# Inputs: 0) AF point data (string of integers)
# Notes: I'm just guessing that the 2nd and 4th bytes are the Y coordinates,
# and that more AF points will show up in the future (derived from E-1 images,
# and the E-1 uses just one of 3 possible AF points, all centered in Y) - PH
sub PrintAFAreas($)
{
    my $val = shift;
    my @points = split ' ', $val;
    my %afPointNames = (
        0x36794285 => 'Left',
        0x79798585 => 'Center',
        0xBD79C985 => 'Right',
    );
    $val = '';
    my $pt;
    foreach $pt (@points) {
        next unless $pt;
        $val and $val .= ', ';
        $afPointNames{$pt} and $val .= $afPointNames{$pt} . ' ';
        my @coords = unpack('C4',pack('N',$pt));
        $val .= "($coords[0],$coords[1])-($coords[2],$coords[3])";
    }
    $val or $val = 'none';
    return $val;
}

#------------------------------------------------------------------------------
# Process ORF file
# Inputs: 0) ExifTool object reference, 1) directory information reference
# Returns: 1 if this looked like a valid ORF file, 0 otherwise
sub ProcessORF($$)
{
    my ($exifTool, $dirInfo) = @_;
    return $exifTool->ProcessTIFF($dirInfo);
}

1;  # end

__END__

=head1 NAME

Image::ExifTool::Olympus - Olympus/Epson maker notes tags

=head1 SYNOPSIS

This module is loaded automatically by Image::ExifTool when required.

=head1 DESCRIPTION

This module contains definitions required by Image::ExifTool to interpret
Olympus or Epson maker notes in EXIF information.

=head1 AUTHOR

Copyright 2003-2011, Phil Harvey (phil at owl.phy.queensu.ca)

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 REFERENCES

=over 4

=item L<http://park2.wakwak.com/~tsuruzoh/Computer/Digicams/exif-e.html>

=item L<http://www.cybercom.net/~dcoffin/dcraw/>

=item L<http://www.ozhiker.com/electronics/pjmt/jpeg_info/olympus_mn.html>

=item L<http://olypedia.de/Olympus_Makernotes>

=back

=head1 ACKNOWLEDGEMENTS

Thanks to Markku Hanninen, Remi Guyomarch, Frank Ledwon, Michael Meissner,
Mark Dapoz, Ioannis Panagiotopoulos and Tomasz Kawecki for their help
figuring out some Olympus tags, and Lilo Huang, Chris Shaw and Viktor
Lushnikov for adding to the LensType list.

=head1 SEE ALSO

L<Image::ExifTool::TagNames/Olympus Tags>,
L<Image::ExifTool(3pm)|Image::ExifTool>

=cut
