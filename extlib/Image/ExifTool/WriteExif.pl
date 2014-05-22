#------------------------------------------------------------------------------
# File:         WriteExif.pl
#
# Description:  Write EXIF meta information
#
# Revisions:    12/13/2004 - P. Harvey Created
#------------------------------------------------------------------------------

package Image::ExifTool::Exif;

use strict;
use vars qw($VERSION $AUTOLOAD @formatSize @formatName %formatNumber
            %compression %photometricInterpretation %orientation);

use Image::ExifTool::Fixup;

sub InsertWritableProperties($$;$);

# some information may be stored in different IFD's with the same meaning.
# Use this lookup to decide when we should delete information that is stored
# in another IFD when we write it to the preferred IFD.
my %crossDelete = (
    ExifIFD => 'IFD0',
    IFD0    => 'ExifIFD',
);

# mandatory tag default values
my %mandatory = (
    IFD0 => {
        0x011a => 72,       # XResolution
        0x011b => 72,       # YResolution
        0x0128 => 2,        # ResolutionUnit (inches)
        0x0213 => 1,        # YCbCrPositioning (centered)
      # 0x8769 => ????,     # ExifOffset
    },
    IFD1 => {
        0x0103 => 6,        # Compression (JPEG)
        0x011a => 72,       # XResolution
        0x011b => 72,       # YResolution
        0x0128 => 2,        # ResolutionUnit (inches)
    },
    ExifIFD => {
        0x9000 => '0230',   # ExifVersion
        0x9101 => "1 2 3 0",# ComponentsConfiguration
        0xa000 => '0100',   # FlashpixVersion
        0xa001 => 0xffff,   # ColorSpace (uncalibrated)
      # 0xa002 => ????,     # ExifImageWidth
      # 0xa003 => ????,     # ExifImageHeight
    },
    GPS => {
        0x0000 => '2 3 0 0',# GPSVersionID
    },
    InteropIFD => {
        0x0002 => '0100',   # InteropVersion
    },
);

# The main EXIF table is unique because the tags from this table may appear
# in many different directories.  For this reason, we introduce a
# "WriteGroup" member to the tagInfo that tells us the preferred location
# for writing each tag.  Here is the lookup for Writable flag (format)
# and WriteGroup for all writable tags
# - WriteGroup is ExifIFD unless otherwise specified
# - Protected is 1 if the tag shouldn't be copied with SetNewValuesFromFile()
my %writeTable = (
    0x0001 => {             # InteropIndex
        Protected => 1,
        Writable => 'string',
        WriteGroup => 'InteropIFD',
    },
    0x0002 => {             # InteropVersion
        Protected => 1,
        Writable => 'undef',
        Mandatory => 1,
        WriteGroup => 'InteropIFD',
    },
    0x000b => {             # ProcessingSoftware
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0x00fe => {             # SubfileType
        Protected => 1,
        Writable => 'int32u',
        WriteGroup => 'IFD0',
    },
    0x00ff => {             # OldSubfileType
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'IFD0',
    },
    0x0100 => {             # ImageWidth
        Protected => 1,
        Writable => 'int32u',
        WriteGroup => 'IFD0',
    },
    0x0101 => {             # ImageHeight
        Protected => 1,
        Writable => 'int32u',
        WriteGroup => 'IFD0',
    },
    0x0102 => {             # BitsPerSample
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'IFD0',
        Count => -1, # can be 1 or 3: -1 means 'variable'
    },
    0x0103 => {             # Compression
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'IFD0',
        Mandatory => 1,
    },
    0x0106 => {             # PhotometricInterpretation
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'IFD0',
    },
    0x0107 => {             # Thresholding
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'IFD0',
    },
    0x0108 => {             # CellWidth
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'IFD0',
    },
    0x0109 => {             # CellLength
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'IFD0',
    },
    0x010a => {             # FillOrder
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'IFD0',
    },
    0x010d => {             # DocumentName
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0x010e => {             # ImageDescription
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0x010f => {             # Make
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0x0110 => {             # Model
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0x0112 => {             # Orientation
        Writable => 'int16u',
        WriteGroup => 'IFD0',
    },
    0x0115 => {             # SamplesPerPixel
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'IFD0',
    },
    0x0116 => {             # RowsPerStrip
        Protected => 1,
        Writable => 'int32u',
        WriteGroup => 'IFD0',
    },
    0x0118 => {             # MinSampleValue
        Writable => 'int16u',
        WriteGroup => 'IFD0',
    },
    0x0119 => {             # MaxSampleValue
        Writable => 'int16u',
        WriteGroup => 'IFD0',
    },
    0x011a => {             # XResolution
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Mandatory => 1,
    },
    0x011b => {             # YResolution
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Mandatory => 1,
    },
    0x011c => {             # PlanarConfiguration
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'IFD0',
    },
    0x011d => {             # PageName
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0x011e => {             # XPosition
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
    },
    0x011f => {             # YPosition
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
    },
    0x0122 => {             # GrayResponseUnit
        Writable => 'int16u',
        WriteGroup => 'IFD0',
    },
    0x0128 => {             # ResolutionUnit
        Writable => 'int16u',
        WriteGroup => 'IFD0',
        Mandatory => 1,
    },
    0x0129 => {             # PageNumber
        Writable => 'int16u',
        WriteGroup => 'IFD0',
        Count => 2,
    },
    0x012d => {             # TransferFunction
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'IFD0',
        Count => 768,
    },
    0x0131 => {             # Software
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0x0132 => {             # ModifyDate
        Writable => 'string',
        Shift => 'Time',
        WriteGroup => 'IFD0',
        PrintConvInv => '$self->InverseDateTime($val,0)',
    },
    0x013b => {             # Artist
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0x013c => {             # HostComputer
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0x013d => {             # Predictor
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'IFD0',
    },
    0x013e => {             # WhitePoint
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Count => 2,
    },
    0x013f => {             # PrimaryChromaticities
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Count => 6,
    },
    0x0141 => {             # HalftoneHints
        Writable => 'int16u',
        WriteGroup => 'IFD0',
        Count => 2,
    },
    0x0142 => {             # TileWidth
        Protected => 1,
        Writable => 'int32u',
        WriteGroup => 'IFD0',
    },
    0x0143 => {             # TileLength
        Protected => 1,
        Writable => 'int32u',
        WriteGroup => 'IFD0',
    },
    0x014c => {             # InkSet
        Writable => 'int16u',
        WriteGroup => 'IFD0',
    },
    0x0150 => {             # TargetPrinter
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0x013c => {             # HostComputer
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0x0211 => {             # YCbCrCoefficients
        Protected => 1,
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Count => 3,
    },
    0x0212 => {             # YCbCrSubSampling
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'IFD0',
        Count => 2,
    },
    0x0213 => {             # YCbCrPositioning
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'IFD0',
        Mandatory => 1,
    },
    0x0214 => {             # ReferenceBlackWhite
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Count => 6,
    },
    0x1000 => {             # RelatedImageFileFormat
        Protected => 1,
        Writable => 'string',
        WriteGroup => 'InteropIFD',
    },
    0x1001 => {             # RelatedImageWidth
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'InteropIFD',
    },
    0x1002 => {             # RelatedImageHeight (more commonly RelatedImageLength)
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'InteropIFD',
    },
    0x4746 => {             # Rating (MicrosoftPhoto)
        Writable => 'int16u',
        WriteGroup => 'IFD0',
        Avoid => 1,
    },
    0x4749 => {             # RatingPercent (MicrosoftPhoto)
        Writable => 'int16u',
        WriteGroup => 'IFD0',
        Avoid => 1,
    },
    0x828d => {             # CFARepeatPatternDim
        Protected => 1,
        Writable => 'int16u',
        WriteGroup => 'SubIFD',
        Count => 2,
    },
    0x828e => {             # CFAPattern2
        Protected => 1,
        Writable => 'int8u',
        WriteGroup => 'SubIFD',
        Count => -1,
    },
    0x8298 => {             # Copyright
        Writable => 'string',
        WriteGroup => 'IFD0',
        RawConvInv => sub {
            my ($val, $self) = @_;
            # encode if necessary
            my $enc = $self->Options('CharsetEXIF');
            $val = $self->Encode($val,$enc) if $enc and $val !~ /\0/;
            if ($val =~ /(.*?)\s*[\n\r]+\s*(.*)/s) {
                return $1 . "\0" unless length $2;
                # photographer copyright set to ' ' if it doesn't exist, according to spec.
                return((length($1) ? $1 : ' ') . "\0" . $2 . "\0");
            }
            return $val . "\0";
        },
    },
#
# Most of the tags below this belong in the ExifIFD...
#
    0x829a => {             # ExposureTime
        Writable => 'rational64u',
        PrintConvInv => 'Image::ExifTool::Exif::ConvertFraction($val)',
    },
    0x829d => {             # FNumber
        Writable => 'rational64u',
        PrintConvInv => '$val',
    },
    0x8546 => {             # SEMInfo
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0x8822 => 'int16u',     # ExposureProgram
    0x8824 => 'string',     # SpectralSensitivity
    0x8827 => {             # ISO
        Writable => 'int16u',
        Count => -1,
        PrintConvInv => '$val=~tr/,//d; $val',
    },
    0x882a => {             # TimeZoneOffset
        Writable => 'int16s',
        Count => -1, # can be 1 or 2
        Notes => q{
            1 or 2 values: 1. The time zone offset of DateTimeOriginal from GMT in
            hours, 2. If present, the time zone offset of ModifyDate
        },
    },
    0x882b => 'int16u',     # SelfTimerMode
    0x8830 => 'int16u',     # SensitivityType
    0x8831 => 'int32u',     # StandardOutputSensitivity
    0x8832 => 'int32u',     # RecommendedExposureIndex
    0x8833 => 'int32u',     # ISOSpeed
    0x8834 => 'int32u',     # ISOSpeedLatitudeyyy
    0x8835 => 'int32u',     # ISOSpeedLatitudezzz
    0x9000 => {             # ExifVersion
        Writable => 'undef',
        Mandatory => 1,
        PrintConvInv => '$val=~tr/.//d; $val=~/^\d{4}$/ ? $val : undef',
    },
    0x9003 => {             # DateTimeOriginal
        Writable => 'string',
        Shift => 'Time',
        PrintConvInv => '$self->InverseDateTime($val,0)',
    },
    0x9004 => {             # CreateDate
        Writable => 'string',
        Shift => 'Time',
        PrintConvInv => '$self->InverseDateTime($val,0)',
    },
    0x9101 => {             # ComponentsConfiguration
        Protected => 1,
        Writable => 'undef',
        Count => 4,
        Mandatory => 1,
        ValueConvInv => '$val=~tr/,//d; $val',  # (so we can copy from XMP with -n)
    },
    0x9102 => {             # CompressedBitsPerPixel
        Protected => 1,
        Writable => 'rational64u',
    },
    0x9201 => {             # ShutterSpeedValue
        Writable => 'rational64s',
        ValueConvInv => '$val>0 ? -log($val)/log(2) : -100',
        # do eval to convert things like '1/100'
        PrintConvInv => 'Image::ExifTool::Exif::ConvertFraction($val)',
    },
    0x9202 => {             # ApertureValue
        Writable => 'rational64u',
        ValueConvInv => '$val>0 ? 2*log($val)/log(2) : 0',
        PrintConvInv => '$val',
    },
    0x9203 => 'rational64s',# BrightnessValue
    0x9204 => {             # ExposureCompensation
        Writable => 'rational64s',
        # do eval to convert things like '+2/3'
        PrintConvInv => 'Image::ExifTool::Exif::ConvertFraction($val)',
    },
    0x9205 => {             # MaxApertureValue
        Writable => 'rational64u',
        ValueConvInv => '$val>0 ? 2*log($val)/log(2) : 0',
        PrintConvInv => '$val',
    },
    0x9206 => {             # SubjectDistance
        Writable => 'rational64u',
        PrintConvInv => '$val=~s/\s*m$//;$val',
    },
    0x9207 => 'int16u',     # MeteringMode
    0x9208 => 'int16u',     # LightSource
    0x9209 => 'int16u',     # Flash
    0x920a => {             # FocalLength
        Writable => 'rational64u',
        PrintConvInv => '$val=~s/\s*mm$//;$val',
    },
    0x9211 => 'int32u',     # ImageNumber
    0x9212 => 'string',     # SecurityClassification
    0x9213 => 'string',     # ImageHistory
    0x9214 => {             # SubjectArea
        Writable => 'int16u',
        Count => -1, # 2, 3 or 4 values
    },
#    0x927c => 'undef',      # MakerNotes
    0x9286 => {             # UserComment
        Writable => 'undef',
        #  (starts with "ASCII\0\0\0", "UNICODE\0", "JIS\0\0\0\0\0" or "\0\0\0\0\0\0\0\0")
        RawConvInv => 'Image::ExifTool::Exif::EncodeExifText($self,$val)',
        # SHOULD ADD SPECIAL LOGIC TO ALLOW CONDITIONAL OVERWRITE OF
        # "UNKNOWN" VALUES FILLED WITH SPACES
    },
    0x9290 => {             # SubSecTime
        Writable => 'string',
        # extract fractional seconds from a full date/time value
        ValueConvInv => '$val=~/^(\d+)\s*$/ ? $1 : ($val=~/\.(\d+)/ ? $1 : undef)',
    },
    0x9291 => {             # SubSecTimeOriginal
        Writable => 'string',
        ValueConvInv => '$val=~/^(\d+)\s*$/ ? $1 : ($val=~/\.(\d+)/ ? $1 : undef)',
    },
    0x9292 => {             # SubSecTimeDigitized
        Writable => 'string',
        ValueConvInv => '$val=~/^(\d+)\s*$/ ? $1 : ($val=~/\.(\d+)/ ? $1 : undef)',
    },
    0x935c => {             # ImageSourceData
        Writable => 'undef',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
#    0x9928 => 'undef',      # Opto-ElectricConversionFactor
    0x9c9b => {             # XPTitle
        Writable => 'int8u',
        WriteGroup => 'IFD0',
        Notes => q{
            tags 0x9c9b-0x9c9f are used by Windows Explorer; special characters
            in these values are converted to UTF-8 by default, or Windows Latin1
            with the -L option.  XPTitle is ignored by Windows Explorer if
            ImageDescription exists
        },
        ValueConvInv => '$self->Encode($val,"UCS2","II") . "\0\0"',
    },
    0x9c9c => {             # XPComment
        Writable => 'int8u',
        WriteGroup => 'IFD0',
        ValueConvInv => '$self->Encode($val,"UCS2","II") . "\0\0"',
    },
    0x9c9d => {             # XPAuthor
        Writable => 'int8u',
        WriteGroup => 'IFD0',
        Notes => 'ignored by Windows Explorer if Artist exists',
        ValueConvInv => '$self->Encode($val,"UCS2","II") . "\0\0"',
    },
    0x9c9e => {             # XPKeywords
        Writable => 'int8u',
        WriteGroup => 'IFD0',
        ValueConvInv => '$self->Encode($val,"UCS2","II") . "\0\0"',
    },
    0x9c9f => {             # XPSubject
        Writable => 'int8u',
        WriteGroup => 'IFD0',
        ValueConvInv => '$self->Encode($val,"UCS2","II") . "\0\0"',
    },
    0xa000 => {             # FlashpixVersion
        Writable => 'undef',
        Mandatory => 1,
        PrintConvInv => '$val=~tr/.//d; $val=~/^\d{4}$/ ? $val : undef',
    },
    0xa001 => {             # ColorSpace
        Writable => 'int16u',
        Mandatory => 1,
    },
    0xa002 => {             # ExifImageWidth (could also be int32u)
        Writable => 'int16u',
        Mandatory => 1,
    },
    0xa003 => {             # ExifImageHeight (could also be int32u)
        Writable => 'int16u',
        Mandatory => 1,
    },
    0xa004 => 'string',     # RelatedSoundFile
    0xa20b => {             # FlashEnergy
        Writable => 'rational64u',
        Count => -1, # 1 or 2 (ref 12)
    },
#    0xa20c => 'undef',      # SpatialFrequencyResponse
    0xa20e => 'rational64u',# FocalPlaneXResolution
    0xa20f => 'rational64u',# FocalPlaneYResolution
    0xa210 => 'int16u',     # FocalPlaneResolutionUnit
    0xa214 => {             # SubjectLocation
        Writable => 'int16u',
        Count => 2,
    },
    0xa215 => 'rational64u',# ExposureIndex
    0xa217 => 'int16u',     # SensingMethod
    0xa300 => {             # FileSource
        Writable => 'undef',
        ValueConvInv => '($val=~/^\d+$/ and $val < 256) ? chr($val) : $val',
    },
    0xa301 => {             # SceneType
        Writable => 'undef',
        ValueConvInv => 'chr($val)',
    },
    0xa302 => {             # CFAPattern
        Writable => 'undef',
        RawConvInv => q{
            my @a = split ' ', $val;
            return $val if @a <= 2; # also accept binary data for backward compatibility
            return pack(GetByteOrder() eq 'II' ? 'v2C*' : 'n2C*', @a);
        },
        PrintConvInv => 'Image::ExifTool::Exif::GetCFAPattern($val)',
    },
    0xa401 => 'int16u',     # CustomRendered
    0xa402 => 'int16u',     # ExposureMode
    0xa403 => 'int16u',     # WhiteBalance
    0xa404 => 'rational64u',# DigitalZoomRatio
    0xa405 => {             # FocalLengthIn35mmFormat
        Writable => 'int16u',
        PrintConvInv => '$val=~s/\s*mm$//;$val',
    },
    0xa406 => 'int16u',     # SceneCaptureType
    0xa407 => 'int16u',     # GainControl
    0xa408 => {             # Contrast
        Writable => 'int16u',
        PrintConvInv => 'Image::ExifTool::Exif::ConvertParameter($val)',
    },
    0xa409 => {             # Saturation
        Writable => 'int16u',
        PrintConvInv => 'Image::ExifTool::Exif::ConvertParameter($val)',
    },
    0xa40a => {             # Sharpness
        Writable => 'int16u',
        PrintConvInv => 'Image::ExifTool::Exif::ConvertParameter($val)',
    },
#    0xa40b => 'undef',      # DeviceSettingDescription
    0xa40c => 'int16u',     # SubjectDistanceRange
    0xa420 => 'string',     # ImageUniqueID
    0xa430 => 'string',     # OwnerName
    0xa431 => 'string',     # SerialNumber
    0xa432 => {             # LensInfo
        Writable => 'rational64u',
        Count => 4,
        PrintConvInv => \&ConvertLensInfo,
    },
    0xa433 => 'string',     # LensMake
    0xa434 => 'string',     # LensModel
    0xa435 => 'string',     # LensSerialNumber
    0xa500 => 'rational64u',# Gamma
#
# DNG stuff (mostly in IFD0, "Raw IFD" in SubIFD)
#
    0xc612 => {             # DNGVersion
        Writable => 'int8u',
        WriteGroup => 'IFD0',
        Count => 4,
        Protected => 1, # (confuses Apple Preview if written to a TIFF image)
        PrintConvInv => '$val =~ tr/./ /; $val',
    },
    0xc613 => {             # DNGBackwardVersion
        Writable => 'int8u',
        WriteGroup => 'IFD0',
        Count => 4,
        Protected => 1,
        PrintConvInv => '$val =~ tr/./ /; $val',
    },
    0xc614 => {             # UniqueCameraModel
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0xc615 => {             # LocalizedCameraModel
        Writable => 'string',
        WriteGroup => 'IFD0',
        PrintConvInv => '$val',
    },
    0xc618 => {             # LinearizationTable
        Writable => 'int16u',
        WriteGroup => 'SubIFD',
        Count => -1,
        Protected => 1,
    },,
    0xc619 => {             # BlackLevelRepeatDim
        Writable => 'int16u',
        WriteGroup => 'SubIFD',
        Count => 2,
        Protected => 1,
    },
    0xc61a => {             # BlackLevel
        Writable => 'rational64u',
        WriteGroup => 'SubIFD',
        Count => -1,
        Protected => 1,
    },
    0xc61b => {             # BlackLevelDeltaH
        Writable => 'rational64s',
        WriteGroup => 'SubIFD',
        Count => -1,
        Protected => 1,
    },
    0xc61c => {             # BlackLevelDeltaV
        Writable => 'rational64s',
        WriteGroup => 'SubIFD',
        Count => -1,
        Protected => 1,
    },
    0xc61d => {             # WhiteLevel
        Writable => 'int32u',
        WriteGroup => 'SubIFD',
        Count => -1,
        Protected => 1,
    },
    0xc61e => {             # DefaultScale
        Writable => 'rational64u',
        WriteGroup => 'SubIFD',
        Count => 2,
        Protected => 1,
    },
    0xc61f => {             # DefaultCropOrigin
        Writable => 'int32u',
        WriteGroup => 'SubIFD',
        Count => 2,
        Protected => 1,
    },
    0xc620 => {             # DefaultCropSize
        Writable => 'int32u',
        WriteGroup => 'SubIFD',
        Count => 2,
        Protected => 1,
    },
    0xc621 => {             # ColorMatrix1
        Writable => 'rational64s',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc622 => {             # ColorMatrix2
        Writable => 'rational64s',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc623 => {             # CameraCalibration1
        Writable => 'rational64s',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc624 => {             # CameraCalibration2
        Writable => 'rational64s',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc625 => {             # ReductionMatrix1
        Writable => 'rational64s',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc626 => {             # ReductionMatrix2
        Writable => 'rational64s',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc627 => {             # AnalogBalance
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc628 => {             # AsShotNeutral
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc629 => {             # AsShotWhiteXY
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Count => 2,
        Protected => 1,
    },
    0xc62a => {             # BaselineExposure
        Writable => 'rational64s',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc62b => {             # BaselineNoise
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc62c => {             # BaselineSharpness
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc62d => {             # BayerGreenSplit
        Writable => 'int32u',
        WriteGroup => 'SubIFD',
        Protected => 1,
    },
    0xc62e => {             # LinearResponseLimit
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc62f => {             # CameraSerialNumber
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0xc630 => {             # DNGLensInfo
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Count => 4,
        PrintConvInv => \&ConvertLensInfo,
    },
    0xc631 => {             # ChromaBlurRadius
        Writable => 'rational64u',
        WriteGroup => 'SubIFD',
        Protected => 1,
    },
    0xc632 => {             # AntiAliasStrength
        Writable => 'rational64u',
        WriteGroup => 'SubIFD',
        Protected => 1,
    },
    0xc633 => {             # ShadowScale
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc635 => {             # MakerNoteSafety
        Writable => 'int16u',
        WriteGroup => 'IFD0',
    },
    0xc65a => {             # CalibrationIlluminant1
        Writable => 'int16u',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc65b => {             # CalibrationIlluminant2
        Writable => 'int16u',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc65c => {             # BestQualityScale
        Writable => 'rational64u',
        WriteGroup => 'SubIFD',
        Protected => 1,
    },
    0xc65d => {             # RawDataUniqueID
        Writable => 'int8u',
        WriteGroup => 'IFD0',
        Count => 16,
        Count => 16,
        ValueConvInv => 'pack("H*", $val)',
        Protected => 1,
    },
    0xc68b => {             # OriginalRawFileName
        Writable => 'string',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc68d => {             # ActiveArea
        Writable => 'int32u',
        WriteGroup => 'SubIFD',
        Count => 4,
        Protected => 1,
    },
    0xc68e => {             # MaskedAreas
        Writable => 'int32u',
        WriteGroup => 'SubIFD',
        Count => 4,
        Protected => 1,
    },
    0xc68f => {             # AsShotICCProfile (writable directory)
        WriteGroup => 'IFD0',
        Protected => 1,
        WriteCheck => q{
            require Image::ExifTool::ICC_Profile;
            return Image::ExifTool::ICC_Profile::ValidateICC(\$val);
        },
    },
    0xc690 => {             # AsShotPreProfileMatrix
        Writable => 'rational64s',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc691 => {             # CurrentICCProfile (writable directory)
        Writable => 'undef',
        WriteGroup => 'IFD0',
        Protected => 1,
        WriteCheck => q{
            require Image::ExifTool::ICC_Profile;
            return Image::ExifTool::ICC_Profile::ValidateICC(\$val);
        },
    },
    0xc692 => {             # CurrentPreProfileMatrix
        Writable => 'rational64s',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc6bf => {             # ColorimetricReference
        Writable => 'int16u',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc6d2 => {             # PanasonicTitle (Panasonic DMC-TZ5, not a DNG tag)
        Writable => 'undef',
        WriteGroup => 'IFD0',
        ValueConvInv => '$self->Encode($val,"UTF8")',
    },
    0xc6d3 => {             # PanasonicTitle2 (Panasonic DMC-FS7, not a DNG tag)
        Writable => 'undef',
        WriteGroup => 'IFD0',
        ValueConvInv => '$self->Encode($val,"UTF8")',
    },
    0xc6f3 => {             # CameraCalibrationSig
        Writable => 'string',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc6f4 => {             # ProfileCalibrationSig
        Writable => 'string',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc6f6 => {             # AsShotProfileName
        Writable => 'string',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc6f7 => {             # NoiseReductionApplied
        Writable => 'rational64u',
        WriteGroup => 'SubIFD',
        Protected => 1,
    },
    0xc6f8 => {             # ProfileName
        Writable => 'string',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc6f9 => {             # ProfileHueSatMapDims
        Writable => 'int32u',
        WriteGroup => 'IFD0',
        Count => 3,
        Protected => 1,
    },
    0xc6fa => {             # ProfileHueSatMapData1
        Writable => 'float',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc6fb => {             # ProfileHueSatMapData2
        Writable => 'float',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc6fc => {             # ProfileToneCurve
        Writable => 'float',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc6fd => {             # ProfileEmbedPolicy
        Writable => 'int32u',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc6fe => {             # ProfileCopyright
        Writable => 'string',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc714 => {             # ForwardMatrix1
        Writable => 'rational64s',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc715 => {             # ForwardMatrix2
        Writable => 'rational64s',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc716 => {             # PreviewApplicationName
        Writable => 'string',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc717 => {             # PreviewApplicationVersion
        Writable => 'string',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc718 => {             # PreviewSettingsName
        Writable => 'string',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc719 => {             # PreviewSettingsDigest
        Writable => 'int8u',
        WriteGroup => 'IFD0',
        Protected => 1,
        ValueConvInv => 'pack("H*", $val)',
    },
    0xc71a => {             # PreviewColorSpace
        Writable => 'int32u',
        WriteGroup => 'IFD0',
        Protected => 1,
        PrintConv => {
            0 => 'Unknown',
            1 => 'Gray Gamma 2.2',
            2 => 'sRGB',
            3 => 'Adobe RGB',
            4 => 'ProPhoto RGB',
        },
    },
    0xc71b => {             # PreviewDateTime
        Writable => 'string',
        WriteGroup => 'IFD0',
        Protected => 1,
        ValueConvInv => q{
            require Image::ExifTool::XMP;
            return Image::ExifTool::XMP::FormatXMPDate($val);
        },
        PrintConvInv => '$self->InverseDateTime($val,1,1)',
    },
    0xc71c => {             # RawImageDigest
        Writable => 'int8u',
        WriteGroup => 'IFD0',
        Count => 16,
        Protected => 1,
        ValueConvInv => 'pack("H*", $val)',
    },
    0xc71d => {             # OriginalRawFileDigest
        Writable => 'int8u',
        WriteGroup => 'IFD0',
        Count => 16,
        Protected => 1,
        ValueConvInv => 'pack("H*", $val)',
    },
    0xc725 => {             # ProfileLookTableDims
        Writable => 'int32u',
        WriteGroup => 'IFD0',
        Count => 3,
        Protected => 1,
    },
    0xc726 => {             # ProfileLookTableData
        Writable => 'float',
        WriteGroup => 'IFD0',
        Count => -1,
        Protected => 1,
    },
    0xc761 => {             # NoiseProfile
        Writable => 'double',
        WriteGroup => 'SubIFD',
        Count => -1,
        Protected => 1,
    },
    0xc763 => {             # TimeCodes
        Writable => 'int8u',
        WriteGroup => 'IFD0',
        Count => -1, # (8 * number of time codes, max 10)
        ValueConvInv => q{
            my @a = map hex, split /[. ]+/, $val;
            join ' ', @a;
        },
        PrintConvInv => q{
            my @a = split ' ', $val;
            my @v;
            foreach (@a) {
                my @td = reverse split /T/;
                my $tz = 0x39; # default to unknown timezone
                if ($td[0] =~ s/([-+])(\d+):(\d+)$//) {
                    if ($3 == 0) {
                        $tz = hex(($1 eq '-') ? $2 : 0x26 - $2);
                    } elsif ($3 == 30) {
                        if ($1 eq '-') {
                            $tz = $2 + 0x0a;
                            $tz += 0x0a if $tz > 0x0f;
                        } else {
                            $tz = 0x3f - $2;
                            $tz -= 0x0a if $tz < 0x3a;
                        }
                    } elsif ($3 == 45) {
                        $tz = 0x32 if $1 eq '+' and $2 == 12;
                    }
                }
                my @t = split /[:.]/, $td[0];
                push @t, '00' while @t < 4;
                my $bg;
                if ($td[1]) {
                    # date was specified: fill in date & timezone
                    my @d = split /[-]/, $td[1];
                    next if @d < 3;
                    $bg = sprintf('.%.2d.%.2d.%.2d.%.2x', $d[2], $d[1], $d[0]%100, $tz);
                    $t[0] = sprintf('%.2x', hex($t[0]) + 0xc0); # set BGF1+BGF2
                } else { # time only
                    $bg = '.00.00.00.00';
                }
                push @v, join('.', reverse(@t[0..3])) . $bg;
            }
            join ' ', @v;
        },
    },
    0xc764 => {             # FrameRate
        Writable => 'rational64s',
        WriteGroup => 'IFD0',
        PrintConvInv => '$val',
    },
    0xc772 => {             # TStop
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Count => -1, # (1 or 2)
        PrintConvInv => '$val=~tr/-/ /; $val',
    },
    0xc789 => {             # ReelName
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0xc791 => {             # OriginalDefaultFinalSize
        Writable => 'int32u',
        WriteGroup => 'IFD0',
        Count => 2,
        Protected => 1,
    },
    0xc792 => {             # OriginalBestQualitySize
        Writable => 'int32u',
        WriteGroup => 'IFD0',
        Count => 2,
        Protected => 1,
    },
    0xc793 => {             # OriginalDefaultCropSize
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Count => 2,
        Protected => 1,
    },
    0xc7a1 => {             # CameraLabel
        Writable => 'string',
        WriteGroup => 'IFD0',
    },
    0xc7a3 => {             # ProfileHueSatMapEncoding
        Writable => 'int32u',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc7a4 => {             # ProfileLookTableEncoding
        Writable => 'int32u',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc7a5 => {             # BaselineExposureOffset
        Writable => 'rational64u',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc7a6 => {             # DefaultBlackRender
        Writable => 'int32u',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc7a7 => {             # NewRawImageDigest
        Writable => 'int8u',
        WriteGroup => 'IFD0',
        Count => 16,
        Protected => 1,
        ValueConvInv => 'pack("H*", $val)',
    },
    0xc7a8 => {             # RawToPreviewGain
        Writable => 'double',
        WriteGroup => 'IFD0',
        Protected => 1,
    },
    0xc7b5 => {             # DefaultUserCrop
        Writable => 'rational64u',
        WriteGroup => 'SubIFD',
        Count => 4,
        Protected => 1,
    },
    # --- end DNG tags ---
    0xea1d => {             # OffsetSchema
        Writable => 'int32s',
    },
    # tags produced by Photoshop Camera RAW
    # (avoid creating these tags unless there is no other option)
    0xfde8 => {
        Name => 'OwnerName',
        Condition => '$$self{TIFF_TYPE} ne "DCR"', # (used for another purpose in Kodak DCR images)
        Avoid => 1,
        PSRaw => 1,
        Writable => 'string',
        ValueConv => '$val=~s/.*: //;$val',
        ValueConvInv => q{"Owner's Name: $val"},
        Notes => q{
            tags 0xfde8-0xfdea and 0xfe4c-0xfe58 are generated by Photoshop Camera RAW.
            Some names are the same as other EXIF tags, but ExifTool will avoid writing
            these unless they already exist in the file
        },
    },
    0xfde9 => {
        Name => 'SerialNumber',
        Condition => '$$self{TIFF_TYPE} ne "DCR"', # (used for another purpose in Kodak DCR SubIFD)
        Avoid => 1,
        PSRaw => 1,
        Writable => 'string',
        ValueConv => '$val=~s/.*: //;$val',
        ValueConvInv => q{"Serial Number: $val"},
    },
    0xfdea => {
        Name => 'Lens',
        Condition => '$$self{TIFF_TYPE} ne "DCR"', # (used for another purpose in Kodak DCR SubIFD)
        Avoid => 1,
        PSRaw => 1,
        Writable => 'string',
        ValueConv => '$val=~s/.*: //;$val',
        ValueConvInv => q{"Lens: $val"},
    },
    0xfe4c => {
        Name => 'RawFile',
        Avoid => 1,
        PSRaw => 1,
        Writable => 'string',
        ValueConv => '$val=~s/.*: //;$val',
        ValueConvInv => q{"Raw File: $val"},
    },
    0xfe4d => {
        Name => 'Converter',
        Avoid => 1,
        PSRaw => 1,
        Writable => 'string',
        ValueConv => '$val=~s/.*: //;$val',
        ValueConvInv => q{"Converter: $val"},
    },
    0xfe4e => {
        Name => 'WhiteBalance',
        Avoid => 1,
        PSRaw => 1,
        Writable => 'string',
        ValueConv => '$val=~s/.*: //;$val',
        ValueConvInv => q{"White Balance: $val"},
    },
    0xfe51 => {
        Name => 'Exposure',
        Avoid => 1,
        PSRaw => 1,
        Writable => 'string',
        ValueConv => '$val=~s/.*: //;$val',
        ValueConvInv => q{"Exposure: $val"},
    },
    0xfe52 => {
        Name => 'Shadows',
        Avoid => 1,
        PSRaw => 1,
        Writable => 'string',
        ValueConv => '$val=~s/.*: //;$val',
        ValueConvInv => q{"Shadows: $val"},
    },
    0xfe53 => {
        Name => 'Brightness',
        Avoid => 1,
        PSRaw => 1,
        Writable => 'string',
        ValueConv => '$val=~s/.*: //;$val',
        ValueConvInv => q{"Brightness: $val"},
    },
    0xfe54 => {
        Name => 'Contrast',
        Avoid => 1,
        PSRaw => 1,
        Writable => 'string',
        ValueConv => '$val=~s/.*: //;$val',
        ValueConvInv => q{"Contrast: $val"},
    },
    0xfe55 => {
        Name => 'Saturation',
        Avoid => 1,
        PSRaw => 1,
        Writable => 'string',
        ValueConv => '$val=~s/.*: //;$val',
        ValueConvInv => q{"Saturation: $val"},
    },
    0xfe56 => {
        Name => 'Sharpness',
        Avoid => 1,
        PSRaw => 1,
        Writable => 'string',
        ValueConv => '$val=~s/.*: //;$val',
        ValueConvInv => q{"Sharpness: $val"},
    },
    0xfe57 => {
        Name => 'Smoothness',
        Avoid => 1,
        PSRaw => 1,
        Writable => 'string',
        ValueConv => '$val=~s/.*: //;$val',
        ValueConvInv => q{"Smoothness: $val"},
    },
    0xfe58 => {
        Name => 'MoireFilter',
        Avoid => 1,
        PSRaw => 1,
        Writable => 'string',
        ValueConv => '$val=~s/.*: //;$val',
        ValueConvInv => q{"Moire Filter: $val"},
    },
);

# insert our writable properties into main EXIF tag table
InsertWritableProperties(\%Image::ExifTool::Exif::Main, \%writeTable, \&CheckExif);

#------------------------------------------------------------------------------
# Inverse print conversion for LensInfo
# Inputs: 0) lens info string
# Returns: PrintConvInv of string
sub ConvertLensInfo($)
{
    my $val = shift;
    my @a = GetLensInfo($val, 1); # (allow unknown "?" values)
    return @a ? join(' ', @a) : $val;
}

#------------------------------------------------------------------------------
# Get binary CFA Pattern from a text string
# Inputs: Print-converted CFA pattern (ie. '[Blue,Green][Green,Red]')
# Returns: CFA pattern as a string of numbers
sub GetCFAPattern($)
{
    my $val = shift;
    my @rows = split /\]\s*\[/, $val;
    @rows or warn("Rows not properly bracketed by '[]'\n"), return undef;
    my @cols = split /,/, $rows[0];
    @cols or warn("Colors not separated by ','\n"), return undef;
    my $ny = @cols;
    my @a = (scalar(@rows), scalar(@cols));
    my %cfaLookup = (red=>0, green=>1, blue=>2, cyan=>3, magenta=>4, yellow=>5, white=>6);
    my $row;
    foreach $row (@rows) {
        @cols = split /,/, $row;
        @cols == $ny or warn("Inconsistent number of colors in each row\n"), return undef;
        foreach (@cols) {
            tr/ \]\[//d;    # remove remaining brackets and any spaces
            my $c = $cfaLookup{lc($_)};
            defined $c or warn("Unknown color '$_'\n"), return undef;
            push @a, $c;
        }
    }
    return "@a";
}

#------------------------------------------------------------------------------
# validate raw values for writing
# Inputs: 0) ExifTool ref, 1) tagInfo hash ref, 2) raw value ref
# Returns: error string or undef (and possibly changes value) on success
sub CheckExif($$$)
{
    my ($exifTool, $tagInfo, $valPtr) = @_;
    my $format = $$tagInfo{Format} || $$tagInfo{Writable} || $tagInfo->{Table}{WRITABLE};
    if (not $format or $format eq '1') {
        if ($tagInfo->{Groups}{0} eq 'MakerNotes') {
            return undef;   # OK to have no format for makernotes
        } else {
            return 'No writable format';
        }
    }
    return Image::ExifTool::CheckValue($valPtr, $format, $$tagInfo{Count});
}

#------------------------------------------------------------------------------
# encode exif ASCII/Unicode text from UTF8 or Latin
# Inputs: 0) ExifTool ref, 1) text string
# Returns: encoded string
# Note: MUST be called Raw conversion time so the EXIF byte order is known!
sub EncodeExifText($$)
{
    my ($exifTool, $val) = @_;
    # does the string contain special characters?
    if ($val =~ /[\x80-\xff]/) {
        my $order = $exifTool->GetNewValues('ExifUnicodeByteOrder');
        return "UNICODE\0" . $exifTool->Encode($val,'UCS2',$order);
    } else {
        return "ASCII\0\0\0$val";
    }
}

#------------------------------------------------------------------------------
# insert writable properties into main tag table
# Inputs: 0) tag table ref, 1) reference to writable properties
#         2) [optional] CHECK_PROC reference
sub InsertWritableProperties($$;$)
{
    my ($tagTablePtr, $writeTablePtr, $checkProc) = @_;
    my $tag;
    $checkProc and $tagTablePtr->{CHECK_PROC} = $checkProc;
    foreach $tag (keys %$writeTablePtr) {
        my $writeInfo = $$writeTablePtr{$tag};
        my @infoList = GetTagInfoList($tagTablePtr, $tag);
        if (@infoList) {
            my $tagInfo;
            foreach $tagInfo (@infoList) {
                if (ref $writeInfo) {
                    my $key;
                    foreach $key (keys %$writeInfo) {
                        $$tagInfo{$key} = $$writeInfo{$key} unless defined $$tagInfo{$key};
                    }
                } else {
                    $$tagInfo{Writable} = $writeInfo unless defined $$tagInfo{Writable};
                }
            }
        } else {
            AddTagToTable($tagTablePtr, $tag, $writeInfo);
        }
    }
}

#------------------------------------------------------------------------------
# rebuild maker notes to properly contain all value data
# (some manufacturers put value data outside maker notes!!)
# Inputs: 0) ExifTool object ref, 1) tag table ref, 2) dirInfo ref
# Returns: new maker note data (and creates MAKER_NOTE_FIXUP), or undef on error
sub RebuildMakerNotes($$$)
{
    my ($exifTool, $tagTablePtr, $dirInfo) = @_;
    my $dirStart = $$dirInfo{DirStart};
    my $dirLen = $$dirInfo{DirLen};
    my $dataPt = $$dirInfo{DataPt};
    my $dataPos = $$dirInfo{DataPos} || 0;
    my $rtnValue;
    my %subdirInfo = %$dirInfo;

    delete $exifTool->{MAKER_NOTE_FIXUP};

    # don't need to rebuild text, BinaryData or PreviewImage maker notes
    my $tagInfo = $$dirInfo{TagInfo};
    my $subdir = $$tagInfo{SubDirectory};
    my $proc = $$subdir{ProcessProc} || $$tagTablePtr{PROCESS_PROC} || \&ProcessExif;
    if (($proc ne \&ProcessExif and $$tagInfo{Name} =~ /Text/) or
         $proc eq \&Image::ExifTool::ProcessBinaryData or
        ($$tagInfo{PossiblePreview} and $dirLen > 6 and
         substr($$dataPt, $dirStart, 3) eq "\xff\xd8\xff"))
    {
        return substr($$dataPt, $dirStart, $dirLen);
    }
    my $saveOrder = GetByteOrder();
    my $loc = Image::ExifTool::MakerNotes::LocateIFD($exifTool,\%subdirInfo);
    if (defined $loc) {
        my $makerFixup = $subdirInfo{Fixup} = new Image::ExifTool::Fixup;
        # create new exiftool object to rewrite the directory without changing it
        my $newTool = new Image::ExifTool;
        $newTool->Options(
            IgnoreMinorErrors => $$exifTool{OPTIONS}{IgnoreMinorErrors},
            FixBase           => $$exifTool{OPTIONS}{FixBase},
        );
        $newTool->Init();   # must do this before calling WriteDirectory()!
        # don't copy over preview image
        $newTool->SetNewValue(PreviewImage => '');
        # copy all transient members over in case they are used for writing
        # (Make, Model, etc)
        foreach (grep /[a-z]/, keys %$exifTool) {
            $$newTool{$_} = $$exifTool{$_};
        }
        # fix base offsets if specified
        $newTool->Options(FixBase => $exifTool->Options('FixBase'));
        # set GENERATE_PREVIEW_INFO flag so PREVIEW_INFO will be generated
        $newTool->{GENERATE_PREVIEW_INFO} = 1;
        # drop any large tags
        $newTool->{DROP_TAGS} = 1;
        # initialize other necessary data members
        $newTool->{FILE_TYPE} = $exifTool->{FILE_TYPE};
        $newTool->{TIFF_TYPE} = $exifTool->{TIFF_TYPE};
        # rewrite maker notes
        $rtnValue = $newTool->WriteDirectory(\%subdirInfo, $tagTablePtr);
        if (defined $rtnValue and length $rtnValue) {
            # add the dummy/empty preview image if necessary
            if ($newTool->{PREVIEW_INFO}) {
                $makerFixup->SetMarkerPointers(\$rtnValue, 'PreviewImage', length($rtnValue));
                $rtnValue .= $newTool->{PREVIEW_INFO}{Data};
                delete $newTool->{PREVIEW_INFO};
            }
            # add makernote header
            if ($loc) {
                my $hdr = substr($$dataPt, $dirStart, $loc);
                # special case: convert Pentax/Samsung DNG maker notes to JPEG style
                # (in JPEG, Pentax makernotes are absolute and start with "AOC\0")
                if ($hdr =~ s/^(PENTAX |SAMSUNG)\0/AOC\0/) {
                    # save fixup so we will adjust to absolute offsets when writing
                    $exifTool->{MAKER_NOTE_FIXUP} = $makerFixup;
                }
                $rtnValue = $hdr . $rtnValue;
                # adjust fixup for shift in start position
                $makerFixup->{Start} += length $hdr;
            }
            # shift offsets according to original position of maker notes,
            # and relative to the makernotes Base
            $makerFixup->{Shift} += $dataPos + $dirStart +
                                    $$dirInfo{Base} - $subdirInfo{Base};
            # repair incorrect offsets if offsets were fixed
            $makerFixup->{Shift} += $subdirInfo{FixedBy} || 0;
            # fix up pointers to the specified offset
            $makerFixup->ApplyFixup(\$rtnValue);
            # save fixup information unless offsets were relative
            unless ($subdirInfo{Relative}) {
                # set shift so offsets are all relative to start of maker notes
                $makerFixup->{Shift} -= $dataPos + $dirStart;
                $exifTool->{MAKER_NOTE_FIXUP} = $makerFixup;    # save fixup for later
            }
        }
    }
    SetByteOrder($saveOrder);

    return $rtnValue;
}

#------------------------------------------------------------------------------
# Sort IFD directory entries
# Inputs: 0) data reference, 1) directory start, 2) number of entries
sub SortIFD($$$)
{
    my ($dataPt, $dirStart, $numEntries) = @_;
    my ($index, %entries);
    # split the directory into separate entries
    my $newDir = '';
    for ($index=0; $index<$numEntries; ++$index) {
        my $entry = $dirStart + 2 + 12 * $index;
        my $tagID = Get16u($dataPt, $entry);
        my $entryData = substr($$dataPt, $entry, 12);
        # silly software can pad directories with zero entries -- put these at the end
        $tagID = 0x10000 unless $tagID or $index == 0;
        # add new entry (allow for duplicate tag ID's, which shouldn't normally happen)
        if ($entries{$tagID}) {
            $entries{$tagID} .= $entryData;
        } else {
            $entries{$tagID} = $entryData;
        }
    }
    # sort the directory entries
    my @sortedTags = sort { $a <=> $b } keys %entries;
    foreach (@sortedTags) {
        $newDir .= $entries{$_};
    }
    # replace original directory with new, sorted one
    substr($$dataPt, $dirStart + 2, 12 * $numEntries) = $newDir;
}

#------------------------------------------------------------------------------
# Validate IFD entries (strict validation to test possible chained IFD's)
# Inputs: 0) dirInfo ref (must have RAF set), 1) optional DirStart
# Returns: true if IFD looks OK
sub ValidateIFD($;$)
{
    my ($dirInfo, $dirStart) = @_;
    my $raf = $$dirInfo{RAF} or return 0;
    my $base = $$dirInfo{Base};
    $dirStart = $$dirInfo{DirStart} || 0 unless defined $dirStart;
    my $offset = $dirStart + ($$dirInfo{DataPos} || 0);
    my ($buff, $index);
    $raf->Seek($offset + $base, 0) and $raf->Read($buff,2) == 2 or return 0;
    my $numEntries = Get16u(\$buff,0);
    $numEntries > 1 and $numEntries < 64 or return 0;
    my $len = 12 * $numEntries;
    $raf->Read($buff, $len) == $len or return 0;
    my $lastID = -1;
    for ($index=0; $index<$numEntries; ++$index) {
        my $entry = 12 * $index;
        my $tagID = Get16u(\$buff, $entry);
        $tagID > $lastID or $$dirInfo{AllowOutOfOrderTags} or return 0;
        my $format = Get16u(\$buff, $entry+2);
        $format > 0 and $format <= 13 or return 0;
        my $count = Get32u(\$buff, $entry+4);
        $count > 0 or return 0;
        $lastID = $tagID;
    }
    return 1;
}

#------------------------------------------------------------------------------
# Get sorted list of offsets used in IFD
# Inputs: 0) data ref, 1) directory start, 2) dataPos, 3) IFD entries, 4) tag table ref
# Returns: 0) sorted list of offsets (only offsets after the end of the IFD)
#          1) hash of list indices keyed by offset value
# Notes: This is used in a patch to fix the count for tags in Kodak SubIFD3
sub GetOffList($$$$$)
{
    my ($dataPt, $dirStart, $dataPos, $numEntries, $tagTablePtr) = @_;
    my $ifdEnd = $dirStart + 2 + 12 * $numEntries + $dataPos;
    my ($index, $offset, %offHash);
    for ($index=0; $index<$numEntries; ++$index) {
        my $entry = $dirStart + 2 + 12 * $index;
        my $format = Get16u($dataPt, $entry + 2);
        next if $format < 1 or $format > 13;
        my $count = Get16u($dataPt, $entry + 4);
        my $size = $formatSize[$format] * $count;
        if ($size <= 4) {
            my $tagID = Get16u($dataPt, $entry);
            next unless ref $$tagTablePtr{$tagID} eq 'HASH' and $$tagTablePtr{$tagID}{FixCount};
        }
        my $offset = Get16u($dataPt, $entry + 8);
        $offHash{$offset} = 1 if $offset >= $ifdEnd;
    }
    # set offset hash values to indices in list
    my @offList = sort keys %offHash;
    $index = 0;
    foreach $offset (@offList) {
        $offHash{$offset} = $index++;
    }
    return(\@offList, \%offHash);
}

#------------------------------------------------------------------------------
# Update TIFF_END member if defined
# Inputs: 0) ExifTool ref, 1) end of valid TIFF data
sub UpdateTiffEnd($$)
{
    my ($exifTool, $end) = @_;
    if (defined $exifTool->{TIFF_END} and
        $exifTool->{TIFF_END} < $end)
    {
        $exifTool->{TIFF_END} = $end;
    }
}

#------------------------------------------------------------------------------
# Handle error while writing EXIF
# Inputs: 0) ExifTool ref, 1) error string, 2) tag table ref
# Returns: undef on fatal error, or '' if minor error is ignored
sub ExifErr($$$)
{
    my ($exifTool, $errStr, $tagTablePtr) = @_;
    # MakerNote errors are minor by default
    my $minor = ($tagTablePtr->{GROUPS}{0} eq 'MakerNotes');
    if ($tagTablePtr->{VARS} and $tagTablePtr->{VARS}{MINOR_ERRORS}) {
        $exifTool->Warn("$errStr. IFD dropped.") and return '' if $minor;
        $minor = 1;
    }
    return undef if $exifTool->Error($errStr, $minor);
    return '';
}

#------------------------------------------------------------------------------
# Read/Write IFD with TIFF-like header (used by DNG 1.2)
# Inputs: 0) ExifTool object ref, 1) dirInfo ref, 2) tag table ref
# Returns: Reading: 1 on success, otherwise returns 0 and sets a Warning
#          Writing: new data block or undef on error
sub ProcessTiffIFD($$$)
{
    my ($exifTool, $dirInfo, $tagTablePtr) = @_;
    $exifTool or return 1;    # allow dummy access
    my $raf = $$dirInfo{RAF};
    my $base = $$dirInfo{Base} || 0;
    my $dirName = $$dirInfo{DirName};
    my $magic = $dirInfo->{Subdir}{Magic} || 0x002a;
    my $buff;

    # structured with a TIFF-like header and relative offsets
    $raf->Seek($base, 0) and $raf->Read($buff, 8) == 8 or return 0;
    unless (SetByteOrder(substr($buff,0,2)) and Get16u(\$buff, 2) == $magic) {
        my $msg = "Invalid $dirName header";
        if ($$dirInfo{IsWriting}) {
            $exifTool->Error($msg);
            return undef;
        } else {
            $exifTool->Warn($msg);
            return 0;
        }
    }
    my $offset = Get32u(\$buff, 4);
    my %dirInfo = (
        DirName  => $$dirInfo{DirName},
        Parent   => $$dirInfo{Parent},
        Base     => $base,
        DataPt   => \$buff,
        DataLen  => length $buff,
        DataPos  => 0,
        DirStart => $offset,
        DirLen   => length($buff) - $offset,
        RAF      => $raf,
        NewDataPos => 8,
    );
    if ($$dirInfo{IsWriting}) {
        # rewrite the Camera Profile IFD
        my $newDir = WriteExif($exifTool, \%dirInfo, $tagTablePtr);
        # don't add header if error writing directory ($newDir is undef)
        # or if directory is being deleted ($newDir is empty)
        return $newDir unless $newDir;
        # return directory with TIFF-like header
        return GetByteOrder() . Set16u($magic) . Set32u(8) . $newDir;
    }
    if ($exifTool->{HTML_DUMP}) {
        my $tip = sprintf("Byte order: %s endian\nIdentifier: 0x%.4x\n%s offset: 0x%.4x",
                          (GetByteOrder() eq 'II') ? 'Little' : 'Big', $magic, $dirName, $offset);
        $exifTool->HDump($base, 8, "$dirName header", $tip, 0);
    }
    return ProcessExif($exifTool, \%dirInfo, $tagTablePtr);
}

#------------------------------------------------------------------------------
# Write EXIF directory
# Inputs: 0) ExifTool object ref, 1) source dirInfo ref, 2) tag table ref
# Returns: Exif data block (may be empty if no Exif data) or undef on error
# Notes: Increments ExifTool CHANGED flag for each tag changed.  Also updates
#        TIFF_END if defined with location of end of original TIFF image.
# Returns IFD data in the following order:
#   1. IFD0 directory followed by its data
#   2. SubIFD directory followed by its data, thumbnail and image
#   3. GlobalParameters, EXIF, GPS, Interop IFD's each with their data
#   4. IFD1,IFD2,... directories each followed by their data
#   5. Thumbnail and/or image data for each IFD, with IFD0 image last
sub WriteExif($$$)
{
    my ($exifTool, $dirInfo, $tagTablePtr) = @_;
    $exifTool or return 1;      # allow dummy access to autoload this package
    my $origDirInfo = $dirInfo; # save original dirInfo
    my $dataPt = $$dirInfo{DataPt};
    unless ($dataPt) {
        my $emptyData = '';
        $dataPt = \$emptyData;
    }
    my $dataPos = $$dirInfo{DataPos} || 0;
    my $dirStart = $$dirInfo{DirStart} || 0;
    my $dataLen = $$dirInfo{DataLen} || length($$dataPt);
    my $dirLen = $$dirInfo{DirLen} || ($dataLen - $dirStart);
    my $base = $$dirInfo{Base} || 0;
    my $firstBase = $base;
    my $raf = $$dirInfo{RAF};
    my $dirName = $$dirInfo{DirName} || 'unknown';
    my $fixup = $$dirInfo{Fixup} || new Image::ExifTool::Fixup;
    my $imageDataFlag = $$dirInfo{ImageData} || '';
    my $verbose = $exifTool->Options('Verbose');
    my $out = $exifTool->Options('TextOut');
    my ($nextIfdPos, %offsetData, $inMakerNotes);
    my (@offsetInfo, %xDelete, $strEnc);
    my $deleteAll = 0;
    my $newData = '';   # initialize buffer to receive new directory data
    my @imageData;      # image data blocks to copy later if requested
    my $name = $$dirInfo{Name};
    $name = $dirName unless $name and $dirName eq 'MakerNotes' and $name !~ /^MakerNote/;

    # set encoding for strings
    $strEnc = $exifTool->Options('CharsetEXIF') if $$tagTablePtr{GROUPS}{0} eq 'EXIF';

    # allow multiple IFD's in IFD0-IFD1-IFD2... chain
    $$dirInfo{Multi} = 1 if $dirName =~ /^(IFD0|SubIFD)$/ and not defined $$dirInfo{Multi};
    $inMakerNotes = 1 if $tagTablePtr->{GROUPS}{0} eq 'MakerNotes';
    my $ifd;
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# loop through each IFD
#
    for ($ifd=0; ; ++$ifd) {  # loop through multiple IFD's

        # save pointer to start of this IFD within the newData
        my $newStart = length($newData);
        my @subdirs;    # list of subdirectory data and tag table pointers
        # determine if directory is contained within our data
        my $mustRead;
        if ($dirStart < 0 or $dirStart > $dataLen-2) {
            $mustRead = 1;
        } elsif ($dirLen > 2) {
            my $len = 2 + 12 * Get16u($dataPt, $dirStart);
            $mustRead = 1 if $dirStart + $len > $dataLen;
        }
        # read IFD from file if necessary
        if ($mustRead) {
            if ($raf) {
                # read the count of entries in this IFD
                my $offset = $dirStart + $dataPos;
                my ($buff, $buf2);
                unless ($raf->Seek($offset + $base, 0) and $raf->Read($buff,2) == 2) {
                    return ExifErr($exifTool, "Bad IFD or truncated file in $name", $tagTablePtr);
                }
                my $len = 12 * Get16u(\$buff,0);
                # (also read next IFD pointer if available)
                unless ($raf->Read($buf2, $len+4) >= $len) {
                    return ExifErr($exifTool, "Error reading $name", $tagTablePtr);
                }
                $buff .= $buf2;
                # make copy of dirInfo since we're going to modify it
                my %newDirInfo = %$dirInfo;
                $dirInfo = \%newDirInfo;
                # update directory parameters for the newly loaded IFD
                $dataPt = $$dirInfo{DataPt} = \$buff;
                $dirStart = $$dirInfo{DirStart} = 0;
                $dataPos = $$dirInfo{DataPos} = $offset;
                $dataLen = $$dirInfo{DataLen} = length $buff;
                $dirLen = $$dirInfo{DirLen} = $dataLen;
                # only account for nextIFD pointer if we are going to use it
                $len += 4 if $dataLen==$len+6 and ($$dirInfo{Multi} or $buff =~ /\0{4}$/);
                UpdateTiffEnd($exifTool, $offset+$base+2+$len);
            } elsif ($dirLen) {
                # error if we can't load IFD (unless we are creating
                # from scratch, in which case dirLen will be zero)
                my $str = $exifTool->Options('IgnoreMinorErrors') ? 'Deleted bad' : 'Bad';
                $exifTool->Error("$str $name directory", 1);
            }
        }
        my ($index, $dirEnd, $numEntries);
        if ($dirStart + 4 < $dataLen) {
            $numEntries = Get16u($dataPt, $dirStart);
            $dirEnd = $dirStart + 2 + 12 * $numEntries;
            if ($dirEnd > $dataLen) {
                return ExifErr($exifTool, "Truncated $name directory", $tagTablePtr);
            }
            # sort entries if necessary (but not in maker notes IFDs)
            unless ($inMakerNotes) {
                my $lastID = -1;
                for ($index=0; $index<$numEntries; ++$index) {
                    my $tagID = Get16u($dataPt, $dirStart + 2 + 12 * $index);
                    # check for proper sequence (but ignore null entries at end)
                    if ($tagID < $lastID and $tagID) {
                        SortIFD($dataPt, $dirStart, $numEntries);
                        $exifTool->Warn("Entries in $name were out of sequence. Fixed.",1);
                        last;
                    }
                    $lastID = $tagID;
                }
            }
        } else {
            $numEntries = 0;
            $dirEnd = $dirStart;
        }

        # loop through new values and accumulate all information for this IFD
        my (%set, %mayDelete, $tagInfo);
        my $wrongDir = $crossDelete{$dirName};
        foreach $tagInfo ($exifTool->GetNewTagInfoList($tagTablePtr)) {
            my $tagID = $$tagInfo{TagID};
            # evaluate conditional lists now if necessary
            if (ref $tagTablePtr->{$tagID} eq 'ARRAY' or $$tagInfo{Condition}) {
                my $curInfo = $exifTool->GetTagInfo($tagTablePtr, $tagID);
                if (defined $curInfo and not $curInfo) {
                    # need value to evaluate the condition
                    my ($val) = $exifTool->GetNewValues($tagInfo);
                    # must convert to binary for evaluating in Condition
                    if ($$tagInfo{Format} and defined $val) {
                        $val = WriteValue($val, $$tagInfo{Format}, $$tagInfo{Count});
                    }
                    if (defined $val) {
                        my $fmt = $$tagInfo{Writable} || $$tagInfo{Format} || 'undef';
                        my $cnt = $$tagInfo{Count} || 1;
                        # always use old format/count for Condition in maker notes
                        if ($inMakerNotes) {
                            for ($index=0; $index<$numEntries; ++$index) {
                                my $entry = $dirStart + 2 + 12 * $index;
                                my $id = Get16u($dataPt, $entry);
                                if ($id eq $tagID) {
                                    my $f = Get16u($dataPt, $entry + 2);
                                    if ($formatName[$f]) {
                                        $fmt = $formatName[$f];
                                        $cnt = Get32u($dataPt, $entry + 4);
                                    }
                                    last;
                                }
                            }
                        }
                        $curInfo = $exifTool->GetTagInfo($tagTablePtr, $tagID, \$val, $fmt, $cnt);
                    } else {
                        # may want to delete this, but we need to see the value first
                        $mayDelete{$tagID} = 1;
                    }
                }
                # don't set this tag unless valid for the current condition
                next unless defined $curInfo and $curInfo eq $tagInfo;
            }
            if ($$tagInfo{WriteCondition}) {
                my $self = $exifTool;   # set $self to be used in eval
                #### eval WriteCondition ($self)
                unless (eval $$tagInfo{WriteCondition}) {
                    $@ and warn $@;
                    next;
                }
            }
            my $nvHash = $exifTool->GetNewValueHash($tagInfo, $dirName);
            unless ($nvHash) {
                next unless $wrongDir;
                # delete stuff from the wrong directory if setting somewhere else
                $nvHash = $exifTool->GetNewValueHash($tagInfo, $wrongDir);
                # don't cross delete if not overwriting
                next unless $exifTool->IsOverwriting($nvHash);
                # don't cross delete if specifically deleting from the other directory
                # (Note: don't call GetValue() here because it shouldn't be called
                #  if IsOverwriting returns < 0 -- ie. when shifting)
                next if not defined $$nvHash{Value} and $nvHash->{WantGroup} and
                        lc($nvHash->{WantGroup}) eq lc($wrongDir);
                # remove this tag if found in this IFD
                $xDelete{$tagID} = 1;
            }
            if ($set{$tagID}) {
                # this tag is being set twice, which can happen if two Condition's
                # were true for this tag.  Hopefully the only case where this can
                # happen is the MakerNotes tag since it may store two very different
                # types of information (MakerNotes and PreviewImage), but we want
                # to store the MakerNotes if both are available
                if ($tagID == 0x927c and $dirName =~ /^(ExifIFD|IFD0)$/) {
                    next if $$tagInfo{Name} eq 'PreviewImage';
                } else {
                    $exifTool->Warn(sprintf("Multiple new values for $name tag 0x%.4x",$tagID));
                }
            }
            $set{$tagID} = $tagInfo;
        }
        
        # fix base offsets (some cameras incorrectly write maker notes in IFD0)
        if ($dirName eq 'MakerNotes' and $$dirInfo{Parent} =~ /^(ExifIFD|IFD0)$/ and
            $$exifTool{TIFF_TYPE} !~ /^(ARW|SR2)$/ and not $$exifTool{LeicaTrailerPos} and
            Image::ExifTool::MakerNotes::FixBase($exifTool, $dirInfo))
        {
            # update local variables from fixed values
            $base = $$dirInfo{Base};
            $dataPos = $$dirInfo{DataPos};
        }

        # initialize variables to handle mandatory tags
        my $mandatory = $mandatory{$dirName};
        my ($allMandatory, $addMandatory);
        if ($mandatory) {
            # use X/Y resolution values from JFIF if available
            if ($dirName eq 'IFD0' and defined $$exifTool{JFIFYResolution}) {
                my %ifd0Vals = %$mandatory;
                $ifd0Vals{0x011a} = $$exifTool{JFIFXResolution};
                $ifd0Vals{0x011b} = $$exifTool{JFIFYResolution};
                $ifd0Vals{0x0128} = $$exifTool{JFIFResolutionUnit} + 1;
                $mandatory = \%ifd0Vals;
            }
            $allMandatory = $addMandatory = 0; # initialize to zero
            # add mandatory tags if creating a new directory
            unless ($numEntries) {
                foreach (keys %$mandatory) {
                    $set{$_} or $set{$_} = $$tagTablePtr{$_};
                }
            }
        } else {
            undef $deleteAll;   # don't remove directory (no mandatory entries)
        }
        my ($addDirs, @newTags);
        if ($inMakerNotes) {
            $addDirs = { };     # can't currently add new directories in MakerNotes
            # allow non-permanent makernotes tags to be added
            # (note: we may get into trouble if there are too many of these
            #  because we allow out-of-order tags in MakerNote IFD's but our
            #  logic to add new tags relies on ordered entries)
            foreach (keys %set) {
                my $perm = $set{$_}{Permanent};
                push @newTags, $_ if defined $perm and not $perm;
            }
            @newTags = sort { $a <=> $b } @newTags if @newTags > 1;
        } else {
            # get a hash of directories we will be writing in this one
            $addDirs = $exifTool->GetAddDirHash($tagTablePtr, $dirName);
            # make a union of tags & dirs (can set whole dirs, like MakerNotes)
            my %allTags = ( %set, %$addDirs );
            # make sorted list of new tags to be added
            @newTags = sort { $a <=> $b } keys(%allTags);
        }
        my $dirBuff = '';   # buffer for directory data
        my $valBuff = '';   # buffer for value data
        my @valFixups;      # list of fixups for offsets in valBuff
        # fixup for offsets in dirBuff
        my $dirFixup = new Image::ExifTool::Fixup;
        my $entryBasedFixup;
        my $lastTagID = -1;
        my ($oldInfo, $oldFormat, $oldFormName, $oldCount, $oldSize, $oldValue, $oldImageData);
        my ($readFormat, $readFormName, $readCount); # format for reading old value(s)
        my ($entry, $valueDataPt, $valueDataPos, $valueDataLen, $valuePtr, $valEnd);
        my ($offList, $offHash, $ignoreCount, $fixCount);
        my $oldID = -1;
        my $newID = -1;

        # patch for Canon EOS 40D firmware 1.0.4 bug (incorrect directory counts)
        if ($inMakerNotes and $$exifTool{Model} eq 'Canon EOS 40D') {
            my $fmt = Get16u($dataPt, $dirStart + 2 + 12 * ($numEntries - 1) + 2);
            if ($fmt < 1 or $fmt > 13) {
                # adjust the number of directory entries
                --$numEntries;
                $dirEnd -= 12;
                $ignoreCount = 1;
            }
        }
#..............................................................................
# loop through entries in new directory
#
        $index = 0;
Entry:  for (;;) {

            if (defined $oldID and $oldID == $newID) {
#
# read next entry from existing directory
#
                if ($index < $numEntries) {
                    $entry = $dirStart + 2 + 12 * $index;
                    $oldID = Get16u($dataPt, $entry);
                    $readFormat = $oldFormat = Get16u($dataPt, $entry+2);
                    $readCount = $oldCount = Get32u($dataPt, $entry+4);
                    undef $oldImageData;
                    if ($oldFormat < 1 or $oldFormat > 13) {
                        my $msg = "Bad format ($oldFormat) for $name entry $index";
                        # patch to preserve invalid directory entries in SubIFD3 of
                        # various Kodak Z-series cameras (Z812, Z1085IS, Z1275)
                        # and some Sony cameras such as the DSC-P10
                        if ($dirName eq 'MakerNotes' and (($$exifTool{Make}=~/KODAK/i and
                            $$dirInfo{Name} and $$dirInfo{Name} eq 'SubIFD3') or
                            ($numEntries == 12 and $$exifTool{Make} eq 'SONY' and $index >= 8)))
                        {
                            $dirBuff .= substr($$dataPt, $entry, 12);
                            ++$index;
                            $newID = $oldID;    # we wrote this
                            $exifTool->Warn($msg, 1);
                            next;
                        }
                        # don't write out null directory entry
                        if ($oldFormat==0 and $index and $oldCount==0) {
                            $ignoreCount = ($ignoreCount || 0) + 1;
                            # must keep same directory size to avoid messing up our fixed offsets
                            $dirBuff .= ("\0" x 12) if $$dirInfo{FixBase};
                            ++$index;
                            $newID = $oldID;    # pretend we wrote this
                            next;
                        }
                        return ExifErr($exifTool, $msg, $tagTablePtr);
                    }
                    $readFormName = $oldFormName = $formatName[$oldFormat];
                    $valueDataPt = $dataPt;
                    $valueDataPos = $dataPos;
                    $valueDataLen = $dataLen;
                    $valuePtr = $entry + 8;
                    # try direct method first for speed
                    $oldInfo = $$tagTablePtr{$oldID};
                    if (ref $oldInfo ne 'HASH' or $$oldInfo{Condition}) {
                        # must get unknown tags too
                        # (necessary so we don't miss a tag we want to Drop)
                        my $unk = $exifTool->Options(Unknown => 1);
                        $oldInfo = $exifTool->GetTagInfo($tagTablePtr, $oldID);
                        $exifTool->Options(Unknown => $unk);
                    }
                    # patch incorrect count in Kodak SubIFD3 tags
                    if ($oldCount < 2 and $oldInfo and $$oldInfo{FixCount}) {
                        $offList or ($offList, $offHash) = GetOffList($dataPt, $dirStart, $dataPos,
                                                                      $numEntries, $tagTablePtr);
                        my $i = $$offHash{Get32u($dataPt, $valuePtr)};
                        if (defined $i and $i < $#$offList) {
                            $oldCount = int(($$offList[$i+1] - $$offList[$i]) / $formatSize[$oldFormat]);
                            $fixCount = ($fixCount || 0) + 1 if $oldCount != $readCount;
                        }
                    }
                    $oldSize = $oldCount * $formatSize[$oldFormat];
                    my $readFromFile;
                    if ($oldSize > 4) {
                        $valuePtr = Get32u($dataPt, $valuePtr);
                        # fix valuePtr if necessary
                        if ($$dirInfo{FixOffsets}) {
                            $valEnd or $valEnd = $dataPos + $dirStart + 2 + 12 * $numEntries + 4;
                            my ($tagID, $size, $wFlag) = ($oldID, $oldSize, 1);
                            #### eval FixOffsets ($valuePtr, $valEnd, $size, $tagID, $wFlag)
                            eval $$dirInfo{FixOffsets};
                            unless (defined $valuePtr) {
                                unless ($$exifTool{DROP_TAGS}) {
                                    my $tagStr = $oldInfo ? $$oldInfo{Name} : sprintf("tag 0x%.4x",$oldID);
                                    return undef if $exifTool->Error("Bad $name offset for $tagStr", $inMakerNotes);
                                }
                                ++$index;  $oldID = $newID;  next;  # drop this tag
                            }
                        }
                        # offset shouldn't point into TIFF or IFD header
                        my $suspect = ($valuePtr < 8);
                        # convert offset to pointer in $$dataPt
                        if ($$dirInfo{EntryBased} or (ref $$tagTablePtr{$oldID} eq 'HASH' and
                            $tagTablePtr->{$oldID}{EntryBased}))
                        {
                            $valuePtr += $entry;
                        } else {
                            $valuePtr -= $dataPos;
                        }
                        # value shouldn't overlap our directory
                        $suspect = 1 if $valuePtr < $dirEnd and $valuePtr+$oldSize > $dirStart;
                        # get value by seeking in file if we are allowed
                        if ($valuePtr < 0 or $valuePtr+$oldSize > $dataLen) {
                            my ($pos, $tagStr, $invalidPreview, $tmpInfo);
                            if ($oldInfo) {
                                $tagStr = $$oldInfo{Name};
                            } elsif (defined $oldInfo) {
                                $tmpInfo = $exifTool->GetTagInfo($tagTablePtr, $oldID, \ '', $oldFormName, $oldCount);
                                $tagStr = $$tmpInfo{Name} if $tmpInfo;
                            }
                            $tagStr or $tagStr = sprintf("tag 0x%.4x",$oldID);
                            # allow PreviewImage to run outside EXIF segment in JPEG images
                            if (not $raf) {
                                if ($tagStr eq 'PreviewImage') {
                                    $raf = $exifTool->{RAF};
                                    if ($raf) {
                                        $pos = $raf->Tell();
                                        if ($oldInfo and $$oldInfo{ChangeBase}) {
                                            # adjust base offset for this tag only
                                            #### eval ChangeBase ($dirStart,$dataPos)
                                            my $newBase = eval $$oldInfo{ChangeBase};
                                            $valuePtr += $newBase;
                                        }
                                    } else {
                                        $invalidPreview = 1;
                                    }
                                } elsif ($tagStr eq 'MakerNoteLeica6') {
                                    # save information about Leica makernote trailer
                                    $$exifTool{LeicaTrailer} = {
                                        TagInfo => $oldInfo || $tmpInfo,
                                        Offset  => $base + $valuePtr + $dataPos,
                                        Size    => $oldSize,
                                        Fixup   => new Image::ExifTool::Fixup,
                                    },
                                    $invalidPreview = 2;
                                    # remove SubDirectory to prevent processing (for now)
                                    my %copy = %{$oldInfo || $tmpInfo};
                                    delete $copy{SubDirectory};
                                    delete $copy{MakerNotes};
                                    $oldInfo = \%copy;
                                }
                            }
                            if ($oldSize > BINARY_DATA_LIMIT and $$origDirInfo{ImageData} and
                                (not defined $oldInfo or ($oldInfo and not $$oldInfo{SubDirectory})))
                            {
                                # copy huge data blocks later instead of loading into memory
                                $oldValue = ''; # dummy empty value
                                # copy this value later unless writing a new value
                                unless ($set{$oldID}) {
                                    my $pad = $oldSize & 0x01 ? 1 : 0;
                                    # save block information to copy later (set directory offset later)
                                    $oldImageData = [$base+$valuePtr+$dataPos, $oldSize, $pad];
                                }
                            } elsif ($raf) {
                                my $success = ($raf->Seek($base+$valuePtr+$dataPos, 0) and
                                               $raf->Read($oldValue, $oldSize) == $oldSize);
                                if (defined $pos) {
                                    $raf->Seek($pos, 0);
                                    undef $raf;
                                    # (sony A700 has 32-byte header on PreviewImage)
                                    unless ($success and $oldValue =~ /^(\xff\xd8\xff|(.|.{33})\xd8\xff\xdb)/s) {
                                        $invalidPreview = 1;
                                        $success = 1;   # continue writing directory anyway
                                    }
                                }
                                unless ($success) {
                                    return undef if $exifTool->Error("Error reading value for $name entry $index", $inMakerNotes);
                                    ++$index;  $oldID = $newID;  next;  # drop this tag
                                }
                            } elsif (not $invalidPreview) {
                                return undef if $exifTool->Error("Bad $name offset for $tagStr", $inMakerNotes);
                                ++$index;  $oldID = $newID;  next;  # drop this tag
                            }
                            if ($invalidPreview) {
                                # set value for invalid preview
                                if ($exifTool->{FILE_TYPE} eq 'JPEG') {
                                    # define dummy value for preview (or Leica MakerNote) to write later
                                    # (value must be larger than 4 bytes to generate PREVIEW_INFO,
                                    # and an even number of bytes so it won't be padded)
                                    $oldValue = 'LOAD_PREVIEW';
                                } else {
                                    $oldValue = 'none';
                                    $oldSize = length $oldValue;
                                }
                                $valuePtr = 0;
                            } else {
                                UpdateTiffEnd($exifTool, $base+$valuePtr+$dataPos+$oldSize);
                            }
                            # update pointers for value just read from file
                            $valueDataPt = \$oldValue;
                            $valueDataPos = $valuePtr + $dataPos;
                            $valueDataLen = $oldSize;
                            $valuePtr = 0;
                            $readFromFile = 1;
                        }
                        if ($suspect) {
                            my $tagStr = $oldInfo ? $$oldInfo{Name} : sprintf('tag 0x%.4x', $oldID);
                            my $str = "Suspicious $name offset for $tagStr";
                            if ($inMakerNotes) {
                                $exifTool->Warn($str, 1);
                            } else {
                                return undef if $exifTool->Error($str, 1);
                            }
                        }
                    }
                    # read value if we haven't already
                    $oldValue = substr($$valueDataPt, $valuePtr, $oldSize) unless $readFromFile;
                    # get tagInfo using value if necessary
                    if (defined $oldInfo and not $oldInfo) {
                        my $unk = $exifTool->Options(Unknown => 1);
                        $oldInfo = $exifTool->GetTagInfo($tagTablePtr, $oldID, \$oldValue, $oldFormName, $oldCount);
                        $exifTool->Options(Unknown => $unk);
                        # now that we have the value, we can resolve the Condition to finally
                        # determine whether we want to delete this tag or not
                        if ($mayDelete{$oldID} and $oldInfo and (not @newTags or $newTags[0] != $oldID)) {
                            my $nvHash = $exifTool->GetNewValueHash($oldInfo, $dirName);
                            if (not $nvHash and $wrongDir) {
                                # delete from wrong directory if necessary
                                $nvHash = $exifTool->GetNewValueHash($oldInfo, $wrongDir);
                                $nvHash and $xDelete{$oldID} = 1;
                            }
                            if ($nvHash) {
                                # we want to delete this tag after all, so insert it into our list
                                $set{$oldID} = $oldInfo;
                                unshift @newTags, $oldID;
                            }
                        }
                    }
                    # make sure we are handling the 'ifd' format properly
                    if (($oldFormat == 13 or $oldFormat == 18) and
                        (not $oldInfo or not $$oldInfo{SubIFD}))
                    {
                        my $str = sprintf('%s tag 0x%.4x IFD format not handled', $name, $oldID);
                        $exifTool->Error($str, $inMakerNotes);
                    }
                    # override format we use to read the value if specified
                    if ($oldInfo) {
                        # check for tags which must be integers
                        if (($$oldInfo{IsOffset} or $$oldInfo{SubIFD}) and
                            not $intFormat{$oldFormName})
                        {
                            $exifTool->Error("Invalid format ($oldFormName) for $name $$oldInfo{Name}", $inMakerNotes);
                            ++$index;  $oldID = $newID;  next;  # drop this tag
                        }
                        if ($$oldInfo{Drop} and $$exifTool{DROP_TAGS} and
                            ($$oldInfo{Drop} == 1 or $$oldInfo{Drop} < $oldSize))
                        {
                            ++$index;  $oldID = $newID;  next;  # drop this tag
                        }
                        if ($$oldInfo{Format}) {
                            $readFormName = $$oldInfo{Format};
                            $readFormat = $formatNumber{$readFormName};
                            unless ($readFormat) {
                                # we aren't reading in a standard EXIF format, so rewrite in old format
                                $readFormName = $oldFormName;
                                $readFormat = $oldFormat;
                            }
                            # adjust number of items to read if format size changed
                            $readCount = $oldSize / $formatSize[$readFormat];
                        }
                    }
                    if ($oldID <= $lastTagID and not $inMakerNotes) {
                        my $str = $oldInfo ? "$$oldInfo{Name} tag" : sprintf('tag 0x%x',$oldID);
                        if ($oldID == $lastTagID) {
                            $exifTool->Warn("Duplicate $str in $name");;
                        } else {
                            $exifTool->Warn("\u$str out of sequence in $name");
                        }
                    }
                    $lastTagID = $oldID;
                    ++$index;               # increment index for next time
                } else {
                    undef $oldID;           # no more existing entries
                }
            }
#
# write out all new tags, up to and including this one
#
            $newID = $newTags[0];
            my $isNew;  # -1=tag is old, 0=tag same as existing, 1=tag is new
            if (not defined $oldID) {
                last unless defined $newID;
                $isNew = 1;
            } elsif (not defined $newID) {
                # maker notes will have no new tags defined
                if ($set{$oldID}) {
                    $newID = $oldID;
                    $isNew = 0;
                } else {
                    $isNew = -1;
                }
            } else {
                $isNew = $oldID <=> $newID;
            }
            my $newInfo = $oldInfo;
            my $newFormat = $oldFormat;
            my $newFormName = $oldFormName;
            my $newCount = $oldCount;
            my $ifdFormName;
            my $newValue;
            my $newValuePt = $isNew >= 0 ? \$newValue : \$oldValue;
            my $isOverwriting;

            if ($isNew >= 0) {
                # add, edit or delete this tag
                shift @newTags; # remove from list
                if ($set{$newID}) {
#
# set the new tag value (or 'next' if deleting tag)
#
                    $newInfo = $set{$newID};
                    $newCount = $$newInfo{Count};
                    my ($val, $newVal, $n);
                    my $nvHash = $exifTool->GetNewValueHash($newInfo, $dirName);
                    if ($isNew > 0) {
                        # don't create new entry unless requested
                        if ($nvHash) {
                            next unless $$nvHash{IsCreating};
                            if ($$newInfo{IsOverwriting}) {
                                my $proc = $$newInfo{IsOverwriting};
                                $isOverwriting = &$proc($exifTool, $nvHash, $val, \$newVal);
                            } else {
                                $isOverwriting = $exifTool->IsOverwriting($nvHash);
                            }
                        } else {
                            next if $xDelete{$newID};       # don't create if cross deleting
                            $newVal = $$mandatory{$newID};  # get value for mandatory tag
                            $isOverwriting = 1;
                        }
                        # convert using new format
                        if ($$newInfo{Format}) {
                            $newFormName = $$newInfo{Format};
                            # use Writable flag to specify IFD format code
                            $ifdFormName = $$newInfo{Writable};
                        } else {
                            $newFormName = $$newInfo{Writable};
                            unless ($newFormName) {
                                warn("No format for $name $$newInfo{Name}\n");
                                next;
                            }
                        }
                        $newFormat = $formatNumber{$newFormName};
                    } elsif ($nvHash or $xDelete{$newID}) {
                        unless ($nvHash) {
                            $nvHash = $exifTool->GetNewValueHash($newInfo, $wrongDir);
                        }
                        # read value
                        if (length $oldValue >= $oldSize) {
                            $val = ReadValue(\$oldValue, 0, $readFormName, $readCount, $oldSize);
                        } else {
                            $val = '';
                        }
                        # determine write format (by default, use 'Writable' format)
                        my $writable = $$newInfo{Writable};
                        # (or use existing format if 'Writable' not specified)
                        $writable = $oldFormName unless $writable and $writable ne '1';
                        # (and override write format with 'Format' if specified)
                        my $writeForm = $$newInfo{Format} || $writable;
                        if ($writeForm ne $newFormName) {
                            # write in specified format
                            $newFormName = $writeForm;
                            $newFormat = $formatNumber{$newFormName};
                            # use different IFD format code if necessary
                            if ($inMakerNotes) {
                                # always preserve IFD format in maker notes
                                $ifdFormName = $oldFormName;
                            } elsif ($writable ne $newFormName) {
                                # use specified IFD format
                                $ifdFormName = $writable;
                            }
                        }
                        if ($inMakerNotes and $readFormName ne 'string' and $readFormName ne 'undef') {
                            # keep same size in maker notes unless string or binary
                            $newCount = $oldCount * $formatSize[$oldFormat] / $formatSize[$newFormat];
                        }
                        if ($$newInfo{IsOverwriting}) {
                            my $proc = $$newInfo{IsOverwriting};
                            $isOverwriting = &$proc($exifTool, $nvHash, $val, \$newVal);
                        } else {
                            $isOverwriting = $exifTool->IsOverwriting($nvHash, $val);
                        }
                    }
                    if ($isOverwriting) {
                        $newVal = $exifTool->GetNewValues($nvHash) unless defined $newVal;
                        # value undefined if deleting this tag
                        # (also delete tag if cross-deleting and this isn't a date/time shift)
                        if (not defined $newVal or ($xDelete{$newID} and not defined $$nvHash{Shift})) {
                            if ($$newInfo{RawConvInv} and defined $$nvHash{Value}) {
                                # error in RawConvInv, so rewrite existing tag
                                goto NoOverwrite; # GOTO!
                            }
                            unless ($isNew) {
                                ++$exifTool->{CHANGED};
                                $exifTool->VerboseValue("- $dirName:$$newInfo{Name}", $val);
                            }
                            next;
                        }
                        if ($newCount and $newCount < 0) {
                            # set count to number of values if variable
                            my @vals = split ' ',$newVal;
                            $newCount = @vals;
                        }
                        # convert to binary format
                        $newValue = WriteValue($newVal, $newFormName, $newCount);
                        unless (defined $newValue) {
                            $exifTool->Warn("Invalid value for $dirName:$$newInfo{Name}");
                            goto NoOverwrite; # GOTO!
                        }
                        if (length $newValue) {
                            # limit maximum value length in JPEG images
                            # (max segment size is 65533 bytes and the min EXIF size is 96 incl an additional IFD entry)
                            if ($$exifTool{FILE_TYPE} eq 'JPEG' and length($newValue) > 65436 and
                                $$newInfo{Name} ne 'PreviewImage')
                            {
                                my $name = $$newInfo{MakerNotes} ? 'MakerNotes' : $$newInfo{Name};
                                $exifTool->Warn("$name too large to write in JPEG segment");
                                goto NoOverwrite; # GOTO!
                            }
                            # re-code if necessary
                            if ($strEnc and $newFormName eq 'string') {
                                $newValue = $exifTool->Encode($newValue, $strEnc);
                            }
                        } else {
                            $exifTool->Warn("Can't write zero length $$newInfo{Name} in $tagTablePtr->{GROUPS}{1}");
                            goto NoOverwrite; # GOTO!
                        }
                        if ($isNew >= 0) {
                            $newCount = length($newValue) / $formatSize[$newFormat];
                            ++$exifTool->{CHANGED};
                            if (defined $allMandatory) {
                                # not all mandatory if we are writing any tag specifically
                                if ($nvHash) {
                                    undef $allMandatory;
                                    undef $deleteAll;
                                } else {
                                    ++$addMandatory;    # count mandatory tags that we added
                                }
                            }
                            if ($verbose > 1) {
                                $exifTool->VerboseValue("- $dirName:$$newInfo{Name}", $val) unless $isNew;
                                my $str = $nvHash ? '' : ' (mandatory)';
                                $exifTool->VerboseValue("+ $dirName:$$newInfo{Name}", $newVal, $str);
                            }
                        }
                    } else {
NoOverwrite:            next if $isNew > 0;
                        $isNew = -1;        # rewrite existing tag
                    }
                    # set format for EXIF IFD if different than conversion format
                    if ($ifdFormName) {
                        $newFormName = $ifdFormName;
                        $newFormat = $formatNumber{$newFormName};
                    }

                } elsif ($isNew > 0) {
#
# create new subdirectory
#
                    # newInfo may not be defined if we try to add a mandatory tag
                    # to a directory that doesn't support it (ie. IFD1 in RW2 images)
                    $newInfo = $$addDirs{$newID} or next;
                    # make sure we don't try to generate a new MakerNotes directory
                    # or a SubIFD
                    next if $$newInfo{MakerNotes} or $$newInfo{Name} eq 'SubIFD';
                    my $subTable;
                    if ($newInfo->{SubDirectory}{TagTable}) {
                        $subTable = Image::ExifTool::GetTagTable($newInfo->{SubDirectory}{TagTable});
                    } else {
                        $subTable = $tagTablePtr;
                    }
                    # create empty source directory
                    my %sourceDir = (
                        Parent => $dirName,
                        Fixup => new Image::ExifTool::Fixup,
                    );
                    $sourceDir{DirName} = $newInfo->{Groups}{1} if $$newInfo{SubIFD};
                    $newValue = $exifTool->WriteDirectory(\%sourceDir, $subTable);
                    # only add new directory if it isn't empty
                    next unless defined $newValue and length($newValue);
                    # set the fixup start location
                    if ($$newInfo{SubIFD}) {
                        # subdirectory is referenced by an offset in value buffer
                        my $subdir = $newValue;
                        $newValue = Set32u(0xfeedf00d);
                        push @subdirs, {
                            DataPt => \$subdir,
                            Table => $subTable,
                            Fixup => $sourceDir{Fixup},
                            Offset => length($dirBuff) + 8,
                            Where => 'dirBuff',
                        };
                        $newFormName = 'int32u';
                        $newFormat = $formatNumber{$newFormName};
                    } else {
                        # subdirectory goes directly into value buffer
                        $sourceDir{Fixup}{Start} += length($valBuff);
                        # use Writable to set format, otherwise 'undef'
                        $newFormName = $$newInfo{Writable};
                        unless ($newFormName and $formatNumber{$newFormName}) {
                            $newFormName = 'undef';
                        }
                        $newFormat = $formatNumber{$newFormName};
                        push @valFixups, $sourceDir{Fixup};
                    }
                } elsif ($$newInfo{Format} and $$newInfo{Writable} and $$newInfo{Writable} ne '1') {
                    # use specified write format
                    $newFormName = $$newInfo{Writable};
                    $newFormat = $formatNumber{$newFormName};
                } elsif ($$addDirs{$newID} and $newInfo ne $$addDirs{$newID}) {
                    # this can happen if we are trying to add a directory that doesn't exist
                    # in this type of file (ie. try adding a SubIFD tag to an A100 image)
                    $isNew = -1;
                }
            }
            if ($isNew < 0) {
                # just rewrite existing tag
                $newID = $oldID;
                $newValue = $oldValue;
                $newFormat = $oldFormat; # (just in case it changed)
                $newFormName = $oldFormName;
                # set offset of this entry in the directory so we can update the pointer
                # and save block information to copy this large block later
                if ($oldImageData) {
                    $$oldImageData[3] = $newStart + length($dirBuff) + 2;
                    push @imageData, $oldImageData;
                    $$origDirInfo{ImageData} = \@imageData;
                }
            }
            if ($newInfo) {
#
# load necessary data for this tag (thumbnail image, etc)
#
                if ($$newInfo{DataTag} and $isNew >= 0) {
                    my $dataTag = $$newInfo{DataTag};
                    # load data for this tag
                    unless (defined $offsetData{$dataTag} or $dataTag eq 'LeicaTrailer') {
                        # prefer tag from Composite table if it exists (otherwise
                        # PreviewImage data would be taken from Extra tag)
                        my $compInfo = $Image::ExifTool::Composite{$dataTag};
                        $offsetData{$dataTag} = $exifTool->GetNewValues($compInfo || $dataTag);
                        my $err;
                        if (defined $offsetData{$dataTag}) {
                            my $len = length $offsetData{$dataTag};
                            if ($dataTag eq 'PreviewImage') {
                                # must set DEL_PREVIEW flag now if preview fit into IFD
                                $$exifTool{DEL_PREVIEW} = 1 if $len <= 4;
                            } elsif ($exifTool->{FILE_TYPE} eq 'JPEG' and $len > 60000) {
                                delete $offsetData{$dataTag};
                                $err = "$dataTag not written (too large for JPEG segment)";
                            }
                        } else {
                            $err = "$dataTag not found";
                        }
                        if ($err) {
                            $exifTool->Warn($err) if $$newInfo{IsOffset};
                            delete $set{$newID};    # remove from list of tags we are setting
                            next;
                        }
                    }
                }
#
# write maker notes
#
                if ($$newInfo{MakerNotes}) {
                    # don't write new makernotes if we are deleting this group
                    if ($exifTool->{DEL_GROUP}{MakerNotes} and
                       ($exifTool->{DEL_GROUP}{MakerNotes} != 2 or $isNew <= 0))
                    {
                        if ($isNew <= 0) {
                            ++$exifTool->{CHANGED};
                            $verbose and print $out "  Deleting MakerNotes\n";
                        }
                        next;
                    }
                    my $saveOrder = GetByteOrder();
                    if ($isNew >= 0 and $set{$newID}) {
                        # we are writing a whole new maker note block
                        # --> add fixup information if necessary
                        my $nvHash = $exifTool->GetNewValueHash($newInfo, $dirName);
                        if ($nvHash and $nvHash->{MAKER_NOTE_FIXUP}) {
                            # must clone fixup because we will be shifting it
                            my $makerFixup = $nvHash->{MAKER_NOTE_FIXUP}->Clone();
                            my $valLen = length($valBuff);
                            $makerFixup->{Start} += $valLen;
                            push @valFixups, $makerFixup;
                        }
                    } else {
                        # update maker notes if possible
                        my %subdirInfo = (
                            Base     => $base,
                            DataPt   => $valueDataPt,
                            DataPos  => $valueDataPos,
                            DataLen  => $valueDataLen,
                            DirStart => $valuePtr,
                            DirLen   => $oldSize,
                            DirName  => 'MakerNotes',
                            Name     => $$newInfo{Name},
                            Parent   => $dirName,
                            TagInfo  => $newInfo,
                            RAF      => $raf,
                        );
                        my ($subTable, $subdir, $loc, $writeProc, $notIFD);
                        if ($$newInfo{SubDirectory}) {
                            my $sub = $$newInfo{SubDirectory};
                            $subdirInfo{FixBase} = 1 if $$sub{FixBase};
                            $subdirInfo{FixOffsets} = $$sub{FixOffsets};
                            $subdirInfo{EntryBased} = $$sub{EntryBased};
                            $subdirInfo{NoFixBase} = 1 if defined $$sub{Base};
                            $subdirInfo{AutoFix} = $$sub{AutoFix};
                        }
                        # get the proper tag table for these maker notes
                        if ($oldInfo and $$oldInfo{SubDirectory}) {
                            $subTable = $$oldInfo{SubDirectory}{TagTable};
                            $subTable and $subTable = Image::ExifTool::GetTagTable($subTable);
                            $writeProc = $$oldInfo{SubDirectory}{WriteProc};
                            $notIFD = $$oldInfo{NotIFD};
                        } else {
                            $exifTool->Warn('Internal problem getting maker notes tag table');
                        }
                        $subTable or $subTable = $tagTablePtr;
                        if ($writeProc and
                            $writeProc eq \&Image::ExifTool::MakerNotes::WriteUnknownOrPreview and
                            $oldValue =~ /^\xff\xd8\xff/)
                        {
                            $loc = 0;
                        } elsif (not $notIFD) {
                            # look for IFD-style maker notes
                            $loc = Image::ExifTool::MakerNotes::LocateIFD($exifTool,\%subdirInfo);
                        }
                        if (defined $loc) {
                            # we need fixup data for this subdirectory
                            $subdirInfo{Fixup} = new Image::ExifTool::Fixup;
                            # rewrite maker notes
                            my $changed = $$exifTool{CHANGED};
                            $subdir = $exifTool->WriteDirectory(\%subdirInfo, $subTable, $writeProc);
                            if ($changed == $$exifTool{CHANGED} and $subdirInfo{Fixup}->IsEmpty()) {
                                # return original data if nothing changed and no fixups
                                undef $subdir;
                            }
                        } elsif ($$subTable{PROCESS_PROC} and
                                 $$subTable{PROCESS_PROC} eq \&Image::ExifTool::ProcessBinaryData)
                        {
                            my $sub = $$oldInfo{SubDirectory};
                            if (defined $$sub{Start}) {
                                #### eval Start ($valuePtr)
                                my $start = eval $$sub{Start};
                                $loc = $start - $valuePtr;
                                $subdirInfo{DirStart} = $start;
                                $subdirInfo{DirLen} -= $loc;
                            } else {
                                $loc = 0;
                            }
                            # rewrite maker notes
                            $subdir = $exifTool->WriteDirectory(\%subdirInfo, $subTable);
                        } elsif (not $notIFD) {
                            my $msg = 'Maker notes could not be parsed';
                            if ($$exifTool{FILE_TYPE} eq 'JPEG') {
                                $exifTool->Warn($msg, 1);
                            } else {
                                $exifTool->Error($msg, 1);
                            }
                        }
                        if (defined $subdir) {
                            next unless length $subdir;
                            my $valLen = length($valBuff);
                            # restore existing header and substitute the new
                            # maker notes for the old value
                            $newValue = substr($oldValue, 0, $loc) . $subdir;
                            my $makerFixup = $subdirInfo{Fixup};
                            my $previewInfo = $exifTool->{PREVIEW_INFO};
                            if ($subdirInfo{Relative}) {
                                # apply a one-time fixup to $loc since offsets are relative
                                $makerFixup->{Start} += $loc;
                                # shift all offsets to be relative to new base
                                my $baseShift = $valueDataPos + $valuePtr + $base - $subdirInfo{Base};
                                $makerFixup->{Shift} += $baseShift;
                                $makerFixup->ApplyFixup(\$newValue);
                                if ($previewInfo) {
                                    # remove all but PreviewImage fixup (since others shouldn't change)
                                    foreach (keys %{$makerFixup->{Pointers}}) {
                                        /_PreviewImage$/ or delete $makerFixup->{Pointers}{$_};
                                    }
                                    # zero pointer so we can see how it gets shifted later
                                    $makerFixup->SetMarkerPointers(\$newValue, 'PreviewImage', 0);
                                    # set the pointer to the start of the EXIF information
                                    # add preview image fixup to list of value fixups
                                    $makerFixup->{Start} += $valLen;
                                    push @valFixups, $makerFixup;
                                    $previewInfo->{BaseShift} = $baseShift;
                                    $previewInfo->{Relative} = 1;
                                }
                            # don't shift anything if relative flag set to zero (Pentax patch)
                            } elsif (not defined $subdirInfo{Relative}) {
                                # shift offset base if shifted in the original image or if FixBase
                                # was used, but be careful of automatic FixBase with negative shifts
                                # since they may lead to negative (invalid) offsets (casio_edit_problem.jpg)
                                my $baseShift = $base - $subdirInfo{Base};
                                if ($subdirInfo{AutoFix}) {
                                    $baseShift = 0;
                                } elsif ($subdirInfo{FixBase} and $baseShift < 0 and
                                    # allow negative base shift if offsets are bigger (PentaxOptioWP.jpg)
                                    (not $subdirInfo{MinOffset} or $subdirInfo{MinOffset} + $baseShift < 0))
                                {
                                    my $fixBase = $exifTool->Options('FixBase');
                                    if (not defined $fixBase) {
                                        my $str = $exifTool->Options('IgnoreMinorErrors') ? 'ignored' : 'fix or ignore?';
                                        $exifTool->Error("MakerNotes offsets may be incorrect ($str)", 1);
                                    } elsif ($fixBase eq '') {
                                        $exifTool->Warn('Fixed incorrect MakerNotes offsets');
                                        $baseShift = 0;
                                    }
                                }
                                $makerFixup->{Start} += $valLen + $loc;
                                $makerFixup->{Shift} += $baseShift;
                                # permanently fix makernote offset errors
                                $makerFixup->{Shift} += $subdirInfo{FixedBy} || 0;
                                push @valFixups, $makerFixup;
                                if ($previewInfo and not $previewInfo->{NoBaseShift}) {
                                    $previewInfo->{BaseShift} = $baseShift;
                                }
                            }
                            $newValuePt = \$newValue;   # write new value
                        }
                    }
                    SetByteOrder($saveOrder);

                # process existing subdirectory unless we are overwriting it entirely
                } elsif ($$newInfo{SubDirectory} and $isNew <= 0 and not $isOverwriting
                    # don't edit directory if Writable is set to 0
                    and (not defined $$newInfo{Writable} or $$newInfo{Writable}))
                {

                    my $subdir = $$newInfo{SubDirectory};
                    if ($$newInfo{SubIFD}) {
#
# rewrite existing sub IFD's
#
                        my $subTable = $tagTablePtr;
                        if ($$subdir{TagTable}) {
                            $subTable = Image::ExifTool::GetTagTable($$subdir{TagTable});
                        }
                        # determine directory name for this IFD
                        my $subdirName = $newInfo->{Groups}{1} || $$newInfo{Name};
                        # all makernotes directory names must be 'MakerNotes'
                        $subdirName = 'MakerNotes' if $subTable->{GROUPS}{0} eq 'MakerNotes';
                        # must handle sub-IFD's specially since the values
                        # are actually offsets to subdirectories
                        unless ($readCount) {   # can't have zero count
                            return undef if $exifTool->Error("$name entry $index has zero count", 2);
                            next;
                        }
                        my $writeCount = 0;
                        my $i;
                        $newValue = '';    # reset value because we regenerate it below
                        for ($i=0; $i<$readCount; ++$i) {
                            my $off = $i * $formatSize[$readFormat];
                            my $pt = ReadValue($valueDataPt, $valuePtr + $off,
                                               $readFormName, 1, $oldSize - $off);
                            my $subdirStart = $pt - $dataPos;
                            my $subdirBase = $base;
                            if ($$subdir{Base}) {
                                my $start = $subdirStart + $dataPos;
                                #### eval Base ($start,$base)
                                $subdirBase += eval $$subdir{Base};
                            }
                            # add IFD number if more than one
                            $subdirName =~ s/\d*$/$i/ if $i;
                            my %subdirInfo = (
                                Base     => $subdirBase,
                                DataPt   => $dataPt,
                                DataPos  => $dataPos - $subdirBase + $base,
                                DataLen  => $dataLen,
                                DirStart => $subdirStart,
                                DirName  => $subdirName,
                                Name     => $$newInfo{Name},
                                TagInfo  => $newInfo,
                                Parent   => $dirName,
                                Fixup    => new Image::ExifTool::Fixup,
                                RAF      => $raf,
                                Subdir   => $subdir,
                                # set ImageData only for 1st level SubIFD's
                                ImageData=> $imageDataFlag eq 'Main' ? 'SubIFD' : undef,
                            );
                            # pass on header pointer only for certain sub IFD's
                            $subdirInfo{HeaderPtr} = $$dirInfo{HeaderPtr} if $$newInfo{SubIFD} == 2;
                            if ($$subdir{RelativeBase}) {
                                # apply one-time fixup if offsets are relative (Sony IDC hack)
                                delete $subdirInfo{Fixup};
                                delete $subdirInfo{ImageData};
                            }
                            # is the subdirectory outside our current data?
                            if ($subdirStart < 0 or $subdirStart + 2 > $dataLen) {
                                if ($raf) {
                                    # reset SubDirectory buffer (we will load it later)
                                    my $buff = '';
                                    $subdirInfo{DataPt} = \$buff;
                                    $subdirInfo{DataLen} = 0;
                                } else {
                                    my @err = ("Can't read $subdirName data", $inMakerNotes);
                                    if ($$subTable{VARS} and $subTable->{VARS}{MINOR_ERRORS}) {
                                        $exifTool->Warn($err[0] . '. Ignored.');
                                    } elsif ($exifTool->Error(@err)) {
                                        return undef;
                                    }
                                    next Entry; # don't write this directory
                                }
                            }
                            my $subdirData = $exifTool->WriteDirectory(\%subdirInfo, $subTable, $$subdir{WriteProc});
                            unless (defined $subdirData) {
                                # WriteDirectory should have issued an error, but check just in case
                                $exifTool->Error("Error writing $subdirName") unless $$exifTool{VALUE}{Error};
                                return undef;
                            }
                            unless (length $subdirData) {
                                next unless $inMakerNotes;
                                # don't delete MakerNote Sub-IFD's, write empty IFD instead
                                $subdirData = "\0" x 6;
                                # reset SubIFD ImageData and Fixup just to be safe
                                delete $subdirInfo{ImageData};
                                delete $subdirInfo{Fixup};
                            }
                            # handle data blocks that we will transfer later
                            if (ref $subdirInfo{ImageData}) {
                                push @imageData, @{$subdirInfo{ImageData}};
                                $$origDirInfo{ImageData} = \@imageData;
                            }
                            # temporarily set value to subdirectory index
                            # (will set to actual offset later when we know what it is)
                            $newValue .= Set32u(0xfeedf00d);
                            my ($offset, $where);
                            if ($readCount > 1) {
                                $offset = length($valBuff) + $i * 4;
                                $where = 'valBuff';
                            } else {
                                $offset = length($dirBuff) + 8;
                                $where = 'dirBuff';
                            }
                            # add to list of subdirectories we will append later
                            push @subdirs, {
                                DataPt    => \$subdirData,
                                Table     => $subTable,
                                Fixup     => $subdirInfo{Fixup},
                                Offset    => $offset,
                                Where     => $where,
                                ImageData => $subdirInfo{ImageData},
                            };
                            ++$writeCount;  # count number of subdirs written
                        }
                        next unless length $newValue;
                        # must change location of subdir offset if we deleted
                        # a directory and only one remains
                        if ($writeCount < $readCount and $writeCount == 1) {
                            $subdirs[-1]{Where} = 'dirBuff';
                            $subdirs[-1]{Offset} = length($dirBuff) + 8;
                        }
                        # set new format to int32u for IFD
                        $newFormName = $$newInfo{FixFormat} || 'int32u';
                        $newFormat = $formatNumber{$newFormName};
                        $newValuePt = \$newValue;

                    } elsif ((not defined $$subdir{Start} or
                             $$subdir{Start} =~ /\$valuePtr/) and
                             $$subdir{TagTable})
                    {
#
# rewrite other existing subdirectories ('$valuePtr' type only)
#
                        # set subdirectory Start and Base
                        my $subdirStart = $valuePtr;
                        if ($$subdir{Start}) {
                            #### eval Start ($valuePtr)
                            $subdirStart = eval $$subdir{Start};
                            # must adjust directory size if start changed
                            $oldSize -= $subdirStart - $valuePtr;
                        }
                        my $subdirBase = $base;
                        if ($$subdir{Base}) {
                            my $start = $subdirStart + $valueDataPos;
                            #### eval Base ($start,$base)
                            $subdirBase += eval $$subdir{Base};
                        }
                        my $subFixup = new Image::ExifTool::Fixup;
                        my %subdirInfo = (
                            Base     => $subdirBase,
                            DataPt   => $valueDataPt,
                            DataPos  => $valueDataPos - $subdirBase + $base,
                            DataLen  => $valueDataLen,
                            DirStart => $subdirStart,
                            DirName  => $$subdir{DirName},
                            DirLen   => $oldSize,
                            Parent   => $dirName,
                            Fixup    => $subFixup,
                            RAF      => $raf,
                            TagInfo  => $newInfo,
                        );
                        unless ($oldSize) {
                            # replace with dummy data if empty to prevent WriteDirectory
                            # routines from accessing data they shouldn't
                            my $tmp = '';
                            $subdirInfo{DataPt} = \$tmp;
                            $subdirInfo{DataLen} = 0;
                            $subdirInfo{DirStart} = 0;
                            $subdirInfo{DataPos} += $subdirStart;
                        }
                        my $subTable = Image::ExifTool::GetTagTable($$subdir{TagTable});
                        my $oldOrder = GetByteOrder();
                        SetByteOrder($$subdir{ByteOrder}) if $$subdir{ByteOrder};
                        $newValue = $exifTool->WriteDirectory(\%subdirInfo, $subTable, $$subdir{WriteProc});
                        SetByteOrder($oldOrder);
                        if (defined $newValue) {
                            my $hdrLen = $subdirStart - $valuePtr;
                            if ($hdrLen) {
                                $newValue = substr($$valueDataPt, $valuePtr, $hdrLen) . $newValue;
                                $subFixup->{Start} += $hdrLen;
                            }
                            $newValuePt = \$newValue;
                        } else {
                            $newValuePt = \$oldValue;
                        }
                        unless (length $$newValuePt) {
                            # don't delete a previously empty makernote directory
                            next if $oldSize or not $inMakerNotes;
                        }
                        if ($subFixup->{Pointers} and $subdirInfo{Base} == $base) {
                            $subFixup->{Start} += length $valBuff;
                            push @valFixups, $subFixup;
                        } else {
                            # apply fixup in case we added a header ($hdrLen above)
                            $subFixup->ApplyFixup(\$newValue);
                        }
                    }

                } elsif ($$newInfo{OffsetPair}) {
#
# keep track of offsets
#
                    my $dataTag = $$newInfo{DataTag} || '';
                    if ($dataTag eq 'CanonVRD') {
                        # must decide now if we will write CanonVRD information
                        my $hasVRD;
                        if ($exifTool->{NEW_VALUE}{$Image::ExifTool::Extra{CanonVRD}}) {
                            # adding or deleting as a block
                            $hasVRD = $exifTool->GetNewValues('CanonVRD') ? 1 : 0;
                        } elsif ($exifTool->{DEL_GROUP}{CanonVRD} or
                                 $exifTool->{DEL_GROUP}{Trailer})
                        {
                            $hasVRD = 0;    # deleting as a group
                        } else {
                            $hasVRD = ($$newValuePt ne "\0\0\0\0");
                        }
                        if ($hasVRD) {
                            # add a fixup, and set this offset later
                            $dirFixup->AddFixup(length($dirBuff) + 8, $dataTag);
                        } else {
                            # there is (or will soon be) no VRD information, so set pointer to zero
                            $newValue = "\0" x length($$newValuePt);
                            $newValuePt = \$newValue;
                        }
                    } elsif ($dataTag eq 'OriginalDecisionData') {
                        # handle Canon OriginalDecisionData (no associated length tag)
                        # - I'm going out of my way here to preserve data which is
                        #   invalidated anyway by our edits
                        my $odd;
                        my $oddInfo = $Image::ExifTool::Composite{OriginalDecisionData};
                        if ($oddInfo and $exifTool->{NEW_VALUE}{$oddInfo}) {
                            $odd = $exifTool->GetNewValues($dataTag);
                            if ($verbose > 1) {
                                print $out "    - $dirName:$dataTag\n" if $$newValuePt ne "\0\0\0\0";
                                print $out "    + $dirName:$dataTag\n" if $odd;
                            }
                            ++$exifTool->{CHANGED};
                        } elsif ($$newValuePt ne "\0\0\0\0") {
                            if (length($$newValuePt) == 4) {
                                require Image::ExifTool::Canon;
                                my $offset = Get32u($newValuePt,0);
                                # absolute offset in JPEG images only
                                $offset += $base unless $$exifTool{FILE_TYPE} eq 'JPEG';
                                $odd = Image::ExifTool::Canon::ReadODD($exifTool, $offset);
                                $odd = $$odd if ref $odd;
                            } else {
                                $exifTool->Error("Invalid $$newInfo{Name}",1);
                            }
                        }
                        if ($odd) {
                            my $newOffset = length($valBuff);
                            # (ODD offset is absolute in JPEG, so add base offset!)
                            $newOffset += $base if $$exifTool{FILE_TYPE} eq 'JPEG';
                            $newValue = Set32u($newOffset);
                            $dirFixup->AddFixup(length($dirBuff) + 8, $dataTag);
                            $valBuff .= $odd;   # add original decision data
                        } else {
                            $newValue = "\0\0\0\0";
                        }
                        $newValuePt = \$newValue;
                    } else {
                        my $offsetInfo = $offsetInfo[$ifd];
                        # save original values (for updating TIFF_END later)
                        my @vals;
                        if ($isNew <= 0) {
                            my $oldOrder = GetByteOrder();
                            # Minolta A200 stores these in the wrong byte order!
                            SetByteOrder($$newInfo{ByteOrder}) if $$newInfo{ByteOrder};
                            @vals = ReadValue(\$oldValue, 0, $readFormName, $readCount, $oldSize);
                            SetByteOrder($oldOrder);
                        }
                        # only support int32 pointers (for now)
                        if ($formatSize[$newFormat] != 4 and $$newInfo{IsOffset}) {
                            $isNew > 0 and warn("Internal error (Offset not int32)"), return undef;
                            $newCount != $readCount and warn("Wrong count!"), return undef;
                            # change to int32
                            $newFormName = 'int32u';
                            $newFormat = $formatNumber{$newFormName};
                            $newValue = WriteValue(join(' ',@vals), $newFormName, $newCount);
                            unless (defined $newValue) {
                                warn "Internal error writing offsets for $$newInfo{Name}\n";
                                return undef;
                            }
                        }
                        $offsetInfo or $offsetInfo = $offsetInfo[$ifd] = { };
                        # save location of valuePtr in new directory
                        # (notice we add 10 instead of 8 for valuePtr because
                        # we will put a 2-byte count at start of directory later)
                        my $ptr = $newStart + length($dirBuff) + 10;
                        $newCount or $newCount = 1; # make sure count is set for offsetInfo
                        # save value pointer and value count for each tag
                        $offsetInfo->{$newID} = [$newInfo, $ptr, $newCount, \@vals, $newFormat];
                    }

                } elsif ($$newInfo{DataMember}) {

                    # save any necessary data members (Make, Model, etc)
                    my $formatStr = $newFormName;
                    my $count = $newCount;
                    # change to specified format if necessary
                    if ($$newInfo{Format} and $$newInfo{Format} ne $formatStr) {
                        $formatStr = $$newInfo{Format};
                        my $format = $formatNumber{$formatStr};
                        # adjust number of items for new format size
                        $count = int(length($$newValuePt) / $formatSize[$format]) if $format;
                    }
                    my $val = ReadValue($newValuePt,0,$formatStr,$count,length($$newValuePt));
                    my $conv = $$newInfo{RawConv};
                    if ($conv) {
                        # let the RawConv store the (possibly converted) data member
                        if (ref $conv eq 'CODE') {
                            &$conv($val, $exifTool);
                        } else {
                            my ($self, $tag, $taginfo) = ($exifTool, $$newInfo{Name}, $newInfo);
                            #### eval RawConv ($self, $val, $tag, $tagInfo)
                            eval $conv;
                        }
                    } else {
                        $$exifTool{$$newInfo{DataMember}} = $val;
                    }
                }
            }
#
# write out the directory entry
#
            my $newSize = length($$newValuePt);
            my $fsize = $formatSize[$newFormat];
            my $offsetVal;
            $newCount = int(($newSize + $fsize - 1) / $fsize);  # set proper count
            if ($newSize > 4) {
                # zero-pad to an even number of bytes (required by EXIF standard)
                # and make sure we are a multiple of the format size
                while ($newSize & 0x01 or $newSize < $newCount * $fsize) {
                    $$newValuePt .= "\0";
                    ++$newSize;
                }
                my $entryBased;
                if ($$dirInfo{EntryBased} or ($newInfo and $$newInfo{EntryBased})) {
                    $entryBased = 1;
                    $offsetVal = Set32u(length($valBuff) - length($dirBuff));
                } else {
                    $offsetVal = Set32u(length $valBuff);
                }
                my ($dataTag, $putFirst);
                ($dataTag, $putFirst) = @$newInfo{'DataTag','PutFirst'} if $newInfo;
                if ($dataTag) {
                    if ($dataTag eq 'PreviewImage' and ($exifTool->{FILE_TYPE} eq 'JPEG' or
                        $$exifTool{GENERATE_PREVIEW_INFO}))
                    {
                        # hold onto the PreviewImage until we can determine if it fits
                        $exifTool->{PREVIEW_INFO} or $exifTool->{PREVIEW_INFO} = {
                            Data => $$newValuePt,
                            Fixup => new Image::ExifTool::Fixup,
                        };
                        $exifTool->{PREVIEW_INFO}{ChangeBase} = 1 if $$newInfo{ChangeBase};
                        if ($$newInfo{IsOffset} and $$newInfo{IsOffset} eq '2') {
                            $exifTool->{PREVIEW_INFO}{NoBaseShift} = 1;
                        }
                        # use original preview size if we will attempt to load it later
                        $newCount = $oldCount if $$newValuePt eq 'LOAD_PREVIEW';
                        $$newValuePt = '';
                    } elsif ($dataTag eq 'LeicaTrailer' and $$exifTool{LeicaTrailer}) {
                        $$newValuePt = '';
                    }
                }
                if ($putFirst and $$dirInfo{HeaderPtr}) {
                    my $hdrPtr = $$dirInfo{HeaderPtr};
                    # place this value immediately after the TIFF header
                    $offsetVal = Set32u(length $$hdrPtr);
                    $$hdrPtr .= $$newValuePt;
                } else {
                    $valBuff .= $$newValuePt;       # add value data to buffer
                    # must save a fixup pointer for every pointer in the directory
                    if ($entryBased) {
                        $entryBasedFixup or $entryBasedFixup = new Image::ExifTool::Fixup;
                        $entryBasedFixup->AddFixup(length($dirBuff) + 8, $dataTag);
                    } else {
                        $dirFixup->AddFixup(length($dirBuff) + 8, $dataTag);
                    }
                }
            } else {
                $offsetVal = $$newValuePt;      # save value in offset if 4 bytes or less
                # must pad value with zeros if less than 4 bytes
                $newSize < 4 and $offsetVal .= "\0" x (4 - $newSize);
            }
            # write the directory entry
            $dirBuff .= Set16u($newID) . Set16u($newFormat) .
                        Set32u($newCount) . $offsetVal;
            # update flag to keep track of mandatory tags
            while (defined $allMandatory) {
                if (defined $$mandatory{$newID}) {
                    # values must correspond to mandatory values
                    my $form = $$newInfo{Format} || $newFormName;
                    my $mandVal = WriteValue($$mandatory{$newID}, $form, $newCount);
                    if (defined $mandVal and $mandVal eq $$newValuePt) {
                        ++$allMandatory;        # count mandatory tags
                        last;
                    }
                }
                undef $deleteAll;
                undef $allMandatory;
            }
        }
        if ($ignoreCount) {
            my $y = $ignoreCount > 1 ? 'ies' : 'y';
            my $verb = $$dirInfo{FixBase} ? 'Ignored' : 'Removed';
            $exifTool->Warn("$verb $ignoreCount invalid entr$y from $name", 1);
        }
        if ($fixCount) {
            my $s = $fixCount > 1 ? 's' : '';
            $exifTool->Warn("Fixed invalid count$s for $fixCount $name tag$s", 1);
        }
#..............................................................................
# write directory counts and nextIFD pointer and add value data to end of IFD
#
        # determine now if there is or will be another IFD after this one
        my $nextIfdOffset;
        if ($dirEnd + 4 <= $dataLen) {
            $nextIfdOffset = Get32u($dataPt, $dirEnd);
        } else {
            $nextIfdOffset = 0;
        }
        my $isNextIFD = ($$dirInfo{Multi} and ($nextIfdOffset or
                        # account for the case where we will create the next IFD
                        # (IFD1 only, but not in TIFF-format images)
                        ($dirName eq 'IFD0' and $$exifTool{ADD_DIRS}{'IFD1'} and
                         $$exifTool{FILE_TYPE} ne 'TIFF')));
        # calculate number of entries in new directory
        my $newEntries = length($dirBuff) / 12;
        # delete entire directory if we deleted a tag and only mandatory tags remain or we
        # attempted to create a directory with only mandatory tags and there is no nextIFD
        if ($allMandatory and not $isNextIFD and ($newEntries < $numEntries or $numEntries == 0)) {
            $newEntries = 0;
            $dirBuff = '';
            $valBuff = '';
            undef $dirFixup;    # no fixups in this directory
            ++$deleteAll if defined $deleteAll;
            $verbose > 1 and print $out "    - $allMandatory mandatory tag(s)\n";
            $exifTool->{CHANGED} -= $addMandatory;    # didn't change these after all
        }
        if ($ifd and not $newEntries) {
            $verbose and print $out "  Deleting IFD1\n";
            last;   # don't write IFD1 if empty
        }
        # apply one-time fixup for entry-based offsets
        if ($entryBasedFixup) {
            $entryBasedFixup->{Shift} = length($dirBuff) + 4;
            $entryBasedFixup->ApplyFixup(\$dirBuff);
            undef $entryBasedFixup;
        }
        # add directory entry count to start of IFD and next IFD pointer to end
        # (temporarily set next IFD pointer to zero)
        $newData .= Set16u($newEntries) . $dirBuff . Set32u(0);
        # get position of value data in newData
        my $valPos = length($newData);
        # go back now and set next IFD pointer if this isn't the first IFD
        if ($nextIfdPos) {
            # set offset to next IFD
            Set32u($newStart, \$newData, $nextIfdPos);
            $fixup->AddFixup($nextIfdPos,'NextIFD');    # add fixup for this offset in newData
        }
        # remember position of 'next IFD' pointer so we can set it next time around
        $nextIfdPos = $valPos - 4;
        # add value data after IFD
        $newData .= $valBuff;
#
# add any subdirectories, adding fixup information
#
        if (@subdirs) {
            my $subdir;
            foreach $subdir (@subdirs) {
                my $len = length($newData);         # position of subdirectory in data
                my $subdirFixup = $$subdir{Fixup};
                if ($subdirFixup) {
                    $$subdirFixup{Start} += $len;
                    $fixup->AddFixup($subdirFixup);
                }
                my $imageData = $$subdir{ImageData};
                my $blockSize = 0;
                # must also update start position for ImageData fixups
                if (ref $imageData) {
                    my $blockInfo;
                    foreach $blockInfo (@$imageData) {
                        my ($pos, $size, $pad, $entry, $subFix) = @$blockInfo;
                        if ($subFix) {
                            $$subFix{Start} += $len;
                            # save expected image data offset for calculating shift later
                            $$subFix{BlockLen} = length(${$$subdir{DataPt}}) + $blockSize;
                        }
                        $blockSize += $size + $pad;
                    }
                }
                $newData .= ${$$subdir{DataPt}};    # add subdirectory to our data
                undef ${$$subdir{DataPt}};          # free memory now
                # set the pointer
                my $offset = $$subdir{Offset};
                # if offset is in valBuff, it was added to the end of dirBuff
                # (plus 4 bytes for nextIFD pointer)
                $offset += length($dirBuff) + 4 if $$subdir{Where} eq 'valBuff';
                $offset += $newStart + 2;           # get offset in newData
                # check to be sure we got the right offset
                unless (Get32u(\$newData, $offset) == 0xfeedf00d) {
                    $exifTool->Error("Internal error while rewriting $name");
                    return undef;
                }
                # set the offset to the subdirectory data
                Set32u($len, \$newData, $offset);
                $fixup->AddFixup($offset);  # add fixup for this offset in newData
            }
        }
        # add fixup for all offsets in directory according to value data position
        # (which is at the end of this directory)
        if ($dirFixup) {
            $dirFixup->{Start} = $newStart + 2;
            $dirFixup->{Shift} = $valPos - $dirFixup->{Start};
            $fixup->AddFixup($dirFixup);
        }
        # add valueData fixups, adjusting for position of value data
        my $valFixup;
        foreach $valFixup (@valFixups) {
            $valFixup->{Start} += $valPos;
            $fixup->AddFixup($valFixup);
        }
        # stop if no next IFD pointer
        last unless $isNextIFD;   # stop unless scanning for multiple IFD's
        if ($nextIfdOffset) {
            # continue with next IFD
            $dirStart = $nextIfdOffset - $dataPos;
        } else {
            # create IFD1 if necessary
            $verbose and print $out "  Creating IFD1\n";
            my $ifd1 = "\0" x 2;  # empty IFD1 data (zero entry count)
            $dataPt = \$ifd1;
            $dirStart = 0;
            $dirLen = $dataLen = 2;
        }
        # increment IFD name
        my $ifdNum = $dirName =~ s/(\d+)$// ? $1 : 0;
        $dirName .= $ifdNum + 1;
        $name =~ s/\d+$//;
        $name .= $ifdNum + 1;
        $$exifTool{DIR_NAME} = $$exifTool{PATH}[-1] = $dirName;
        next unless $nextIfdOffset;

        # guard against writing the same directory twice
        my $addr = $nextIfdOffset + $base;
        if ($exifTool->{PROCESSED}{$addr}) {
            $exifTool->Error("$name pointer references previous $exifTool->{PROCESSED}{$addr} directory", 1);
            last;
        }
        $exifTool->{PROCESSED}{$addr} = $name;

        if ($dirName eq 'SubIFD1' and not ValidateIFD($dirInfo, $dirStart)) {
            if ($exifTool->{TIFF_TYPE} eq 'TIFF') {
                $exifTool->Error('Ignored bad IFD linked from SubIFD', 1);
            } elsif ($verbose) {
                $exifTool->Warn('Ignored bad IFD linked from SubIFD');
            }
            last;   # don't write bad IFD
        }
        if ($exifTool->{DEL_GROUP}{$dirName}) {
            $verbose and print $out "  Deleting $dirName\n";
            $raf and $exifTool->Error("Deleting $dirName also deletes subsequent" .
                                      " IFD's and possibly image data", 1);
            ++$exifTool->{CHANGED};
            if ($exifTool->{DEL_GROUP}{$dirName} == 2 and
                $exifTool->{ADD_DIRS}{$dirName})
            {
                my $emptyIFD = "\0" x 2;    # start with empty IFD
                $dataPt = \$emptyIFD;
                $dirStart = 0;
                $dirLen = $dataLen = 2;
            } else {
                last;   # don't write this IFD (or any subsequent IFD)
            }
        } else {
            $verbose and print $out "  Rewriting $name\n";
        }
    }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    # do our fixups now so we can more easily calculate offsets below
    $fixup->ApplyFixup(\$newData);
#
# determine total block size for deferred data
#
    my $numBlocks = scalar @imageData;  # save this so we scan only existing blocks later
    my $blockSize = 0;  # total size of blocks to copy later
    my $blockInfo;
    foreach $blockInfo (@imageData) {
        my ($pos, $size, $pad) = @$blockInfo;
        $blockSize += $size + $pad;
    }
#
# copy over image data for IFD's, starting with the last IFD first
#
    if (@offsetInfo) {
        my $ttwLen;     # length of MRW TTW segment
        my @writeLater; # write image data last
        for ($ifd=$#offsetInfo; $ifd>=-1; --$ifd) {
            # build list of offsets to process
            my @offsetList;
            if ($ifd >= 0) {
                my $offsetInfo = $offsetInfo[$ifd] or next;
                # patch Panasonic RAW/RW2 StripOffsets/StripByteCounts if necessary
                my $stripOffsets = $$offsetInfo{0x111};
                if ($stripOffsets and $$stripOffsets[0]{PanasonicHack}) {
                    require Image::ExifTool::PanasonicRaw;
                    my $err = Image::ExifTool::PanasonicRaw::PatchRawDataOffset($offsetInfo, $raf, $ifd);
                    $err and $exifTool->Error($err);
                }
                my $tagID;
                # loop through all tags in reverse order so we save thumbnail
                # data before main image data if both exist in the same IFD
                foreach $tagID (reverse sort keys %$offsetInfo) {
                    my $tagInfo = $offsetInfo->{$tagID}[0];
                    next unless $$tagInfo{IsOffset}; # handle byte counts with offsets
                    my $sizeInfo = $offsetInfo->{$$tagInfo{OffsetPair}};
                    $sizeInfo or $exifTool->Error("No size tag for $dirName:$$tagInfo{Name}"), next;
                    my $dataTag = $$tagInfo{DataTag};
                    # write TIFF image data (strips or tiles) later if requested
                    if ($raf and defined $$origDirInfo{ImageData} and
                        ($tagID == 0x111 or $tagID == 0x144 or
                          # also defer writing of other big data such as JpgFromRaw in NEF
                          ($$sizeInfo[3][0] and
                           # (calculate approximate combined size of all blocks)
                           $$sizeInfo[3][0] * scalar(@{$$sizeInfo[3]}) > 1000000)) and
                        # but don't defer writing if replacing with new value
                        (not defined $dataTag or not defined $offsetData{$dataTag}))
                    {
                        push @writeLater, [ $offsetInfo->{$tagID}, $sizeInfo ];
                    } else {
                        push @offsetList, [ $offsetInfo->{$tagID}, $sizeInfo ];
                    }
                }
            } else {
                last unless @writeLater;
                @offsetList = @writeLater;
            }
            my $offsetPair;
            foreach $offsetPair (@offsetList) {
                my ($tagInfo, $offsets, $count, $oldOffset) = @{$$offsetPair[0]};
                my ($cntInfo, $byteCounts, $count2, $oldSize, $format) = @{$$offsetPair[1]};
                # must be the same number of offset and byte count values
                unless ($count == $count2) {
                    $exifTool->Error("Offsets/ByteCounts disagree on count for $$tagInfo{Name}");
                    return undef;
                }
                my $formatStr = $formatName[$format];
                # follow pointer to value data if necessary
                $count > 1 and $offsets = Get32u(\$newData, $offsets);
                my $n = $count * $formatSize[$format];
                $n > 4 and $byteCounts = Get32u(\$newData, $byteCounts);
                if ($byteCounts < 0 or $byteCounts + $n > length($newData)) {
                    $exifTool->Error("Error reading $$tagInfo{Name} byte counts");
                    return undef;
                }
                # get offset base and data pos (abnormal for some preview images)
                my ($dbase, $dpos, $wrongBase, $subIfdDataFixup);
                if ($$tagInfo{IsOffset} eq '2') {
                    $dbase = $firstBase;
                    $dpos = $dataPos + $base - $firstBase;
                } else {
                    $dbase = $base;
                    $dpos = $dataPos;
                }
                # use different base if necessary for some offsets (Minolta A200)
                if ($$tagInfo{WrongBase}) {
                    my $self = $exifTool;
                    #### eval WrongBase ($self)
                    $wrongBase = eval $$tagInfo{WrongBase} || 0;
                    $dbase += $wrongBase;
                    $dpos -= $wrongBase;
                } else {
                    $wrongBase = 0;
                }
                my $oldOrder = GetByteOrder();
                my $dataTag = $$tagInfo{DataTag};
                # use different byte order for values of this offset pair if required (Minolta A200)
                SetByteOrder($$tagInfo{ByteOrder}) if $$tagInfo{ByteOrder};
                # transfer the data referenced by all offsets of this tag
                for ($n=0; $n<$count; ++$n) {
                    my ($oldEnd, $size);
                    if (@$oldOffset and @$oldSize) {
                        # calculate end offset of this block
                        $oldEnd = $$oldOffset[$n] + $$oldSize[$n];
                        # update TIFF_END as if we read this data from file
                        UpdateTiffEnd($exifTool, $oldEnd + $dbase);
                    }
                    my $offsetPos = $offsets + $n * 4;
                    my $byteCountPos = $byteCounts + $n * $formatSize[$format];
                    if ($$tagInfo{PanasonicHack}) {
                        # use actual raw data length (may be different than StripByteCounts!)
                        $size = $$oldSize[$n];
                    } else {
                        # use size of new data
                        $size = ReadValue(\$newData, $byteCountPos, $formatStr, 1, 4);
                    }
                    my $offset = $$oldOffset[$n];
                    if (defined $offset) {
                        $offset -= $dpos;
                    } elsif ($size != 0xfeedfeed) {
                        $exifTool->Error('Internal error (no offset)');
                        return undef;
                    }
                    my $newOffset = length($newData) - $wrongBase;
                    my $buff;
                    # look for 'feed' code to use our new data
                    if ($size == 0xfeedfeed) {
                        unless (defined $dataTag) {
                            $exifTool->Error("No DataTag defined for $$tagInfo{Name}");
                            return undef;
                        }
                        unless (defined $offsetData{$dataTag}) {
                            $exifTool->Error("Internal error (no $dataTag)");
                            return undef;
                        }
                        if ($count > 1) {
                            $exifTool->Error("Can't modify $$tagInfo{Name} with count $count");
                            return undef;
                        }
                        $buff = $offsetData{$dataTag};
                        if ($formatSize[$format] != 4) {
                            $exifTool->Error("$$cntInfo{Name} is not int32");
                            return undef;
                        }
                        # set the data size
                        $size = length($buff);
                        Set32u($size, \$newData, $byteCountPos);
                    } elsif ($ifd < 0) {
                        # pad if necessary (but don't pad contiguous image blocks)
                        my $pad = 0;
                        ++$pad if $size & 0x01 and ($n+1 >= $count or not $oldEnd or
                                  $oldEnd != $$oldOffset[$n+1]);
                        # preserve original image padding if specified
                        if ($$origDirInfo{PreserveImagePadding} and $n+1 < $count and
                            $oldEnd and $$oldOffset[$n+1] > $oldEnd)
                        {
                            $pad = $$oldOffset[$n+1] - $oldEnd;
                        }
                        # copy data later
                        push @imageData, [$offset+$dbase+$dpos, $size, $pad];
                        $newOffset += $blockSize;   # data comes after other deferred data
                        # create fixup for SubIFD ImageData
                        if ($imageDataFlag eq 'SubIFD' and not $subIfdDataFixup) {
                            $subIfdDataFixup = new Image::ExifTool::Fixup;
                            $imageData[-1][4] = $subIfdDataFixup;
                        }
                        $size += $pad; # account for pad byte if necessary
                        # return ImageData list
                        $$origDirInfo{ImageData} = \@imageData;
                    } elsif ($offset >= 0 and $offset+$size <= $dataLen) {
                        # take data from old dir data buffer
                        $buff = substr($$dataPt, $offset, $size);
                    } elsif ($$exifTool{TIFF_TYPE} eq 'MRW') {
                        # TTW segment must be an even 4 bytes long, so pad now if necessary
                        my $n = length $newData;
                        $buff = ($n & 0x03) ? "\0" x (4 - ($n & 0x03)) : '';
                        $size = length($buff);
                        # data exists after MRW TTW segment
                        $ttwLen = length($newData) + $size unless defined $ttwLen;
                        $newOffset = $offset + $dpos + $ttwLen - $dataLen;
                    } elsif ($raf and $raf->Seek($offset+$dbase+$dpos,0) and
                             $raf->Read($buff,$size) == $size)
                    {
                        # (data was read OK)
                        # patch incorrect ThumbnailOffset in Sony A100 1.00 ARW images
                        if ($$exifTool{TIFF_TYPE} eq 'ARW' and $$tagInfo{Name} eq 'ThumbnailOffset' and
                            $$exifTool{Model} eq 'DSLR-A100' and $buff !~ /^\xff\xd8\xff/)
                        {
                            my $pos = $offset + $dbase + $dpos;
                            my $try;
                            if ($pos < 0x10000 and $raf->Seek($pos+0x10000,0) and
                                $raf->Read($try,$size) == $size and $try =~ /^\xff\xd8\xff/)
                            {
                                $buff = $try;
                                $exifTool->Warn('Adjusted incorrect A100 ThumbnailOffset', 1);
                            } else {
                                $exifTool->Error('Invalid ThumbnailImage');
                            }
                        }
                    } elsif ($$tagInfo{Name} eq 'ThumbnailOffset' and $offset>=0 and $offset<$dataLen) {
                        # Grrr.  The Canon 350D writes the thumbnail with an incorrect byte count
                        my $diff = $offset + $size - $dataLen;
                        $exifTool->Warn("ThumbnailImage runs outside EXIF data by $diff bytes (truncated)",1);
                        # set the size to the available data
                        $size -= $diff;
                        unless (WriteValue($size, $formatStr, 1, \$newData, $byteCountPos)) {
                            warn 'Internal error writing thumbnail size';
                        }
                        # get the truncated image
                        $buff = substr($$dataPt, $offset, $size);
                    } elsif ($$tagInfo{Name} eq 'PreviewImageStart' and $exifTool->{FILE_TYPE} eq 'JPEG') {
                        # try to load the preview image using the specified offset
                        undef $buff;
                        my $r = $exifTool->{RAF};
                        if ($r and not $raf) {
                            my $tell = $r->Tell();
                            # read and validate
                            undef $buff unless $r->Seek($offset+$base+$dataPos,0) and
                                               $r->Read($buff,$size) == $size and
                                               $buff =~ /^.\xd8\xff[\xc4\xdb\xe0-\xef]/s;
                            $r->Seek($tell, 0) or $exifTool->Error('Seek error'), return undef;
                        }
                        # set flag if we must load PreviewImage
                        $buff = 'LOAD_PREVIEW' unless defined $buff;
                    } else {
                        my $dataName = $dataTag || $$tagInfo{Name};
                        return undef if $exifTool->Error("Error reading $dataName data in $name", $inMakerNotes);
                        $buff = '';
                    }
                    if ($$tagInfo{Name} eq 'PreviewImageStart') {
                        if ($$exifTool{FILE_TYPE} eq 'JPEG' and not $$tagInfo{MakerPreview}) {
                            # hold onto the PreviewImage until we can determine if it fits
                            $exifTool->{PREVIEW_INFO} or $exifTool->{PREVIEW_INFO} = {
                                Data => $buff,
                                Fixup => new Image::ExifTool::Fixup,
                            };
                            if ($$tagInfo{IsOffset} and $$tagInfo{IsOffset} eq '2') {
                                $exifTool->{PREVIEW_INFO}{NoBaseShift} = 1;
                            }
                            if ($offset >= 0 and $offset+$size <= $dataLen) {
                                # set flag indicating this preview wasn't in a trailer
                                $exifTool->{PREVIEW_INFO}{WasContained} = 1;
                            }
                            $buff = '';
                        } elsif ($$exifTool{TIFF_TYPE} eq 'ARW' and $$exifTool{Model}  eq 'DSLR-A100') {
                            # the A100 double-references the same preview, so ignore the
                            # second one (the offset and size will be patched later)
                            next if $$exifTool{A100PreviewLength};
                            $$exifTool{A100PreviewLength} = length $buff if defined $buff;
                        }
                    }
                    # update offset accordingly and add to end of new data
                    Set32u($newOffset, \$newData, $offsetPos);
                    # add a pointer to fix up this offset value (marked with DataTag name)
                    $fixup->AddFixup($offsetPos, $dataTag);
                    # also add to subIfdDataFixup if necessary
                    $subIfdDataFixup->AddFixup($offsetPos, $dataTag) if $subIfdDataFixup;
                    # must also (sometimes) update StripOffsets in Panasonic RW2 images
                    my $otherPos = $$offsetPair[0][5];
                    if ($otherPos and $$tagInfo{PanasonicHack}) {
                        Set32u($newOffset, \$newData, $otherPos);
                        $fixup->AddFixup($otherPos, $dataTag);
                    }
                    if ($ifd >= 0) {
                        # buff length must be even (Note: may have changed since $size was set)
                        $buff .= "\0" if length($buff) & 0x01;
                        $newData .= $buff;      # add this strip to the data
                    } else {
                        $blockSize += $size;    # keep track of total size
                    }
                }
                SetByteOrder($oldOrder);
            }
        }
        # verify that nothing else got written after determining TTW length
        if (defined $ttwLen and $ttwLen != length($newData)) {
            $exifTool->Error('Internal error writing MRW TTW');
        }
    }
#
# set offsets and generate fixups for tag values which were too large for memory
#
    $blockSize = 0;
    foreach $blockInfo (@imageData) {
        my ($pos, $size, $pad, $entry, $subFix) = @$blockInfo;
        if (defined $entry) {
            my $format = Get16u(\$newData, $entry + 2);
            if ($format < 1 or $format > 13) {
                $exifTool->Error('Internal error copying huge value');
                last;
            } else {
                # set count and offset in directory entry
                Set32u($size / $formatSize[$format], \$newData, $entry + 4);
                Set32u(length($newData)+$blockSize, \$newData, $entry + 8);
                $fixup->AddFixup($entry + 8);
                # create special fixup for SubIFD data
                if ($imageDataFlag eq 'SubIFD') {
                    my $subIfdDataFixup = new Image::ExifTool::Fixup;
                    $subIfdDataFixup->AddFixup($entry + 8);
                    # save fixup in imageData list
                    $$blockInfo[4] = $subIfdDataFixup; 
                }
                # must reset entry pointer so we don't use it again in a parent IFD!
                $$blockInfo[3] = undef;
            }
        }
        # apply additional shift required for contained SubIFD image data offsets
        if ($subFix and defined $$subFix{BlockLen} and $numBlocks > 0) {
            # our offset expects the data at the end of the SubIFD block (BlockLen + Start),
            # but it will actually be at length($newData) + $blockSize.  So adjust
            # accordingly (and subtract an extra Start because this shift is applied later)
            $subFix->{Shift} += length($newData) - $$subFix{BlockLen} - 2 * $$subFix{Start} + $blockSize;
            $subFix->ApplyFixup(\$newData);
        }
        $blockSize += $size + $pad;
        --$numBlocks;
    }
#
# apply final shift to new data position if this is the top level IFD
#
    unless ($$dirInfo{Fixup}) {
        my $hdrPtr = $$dirInfo{HeaderPtr};
        my $newDataPos = $hdrPtr ? length $$hdrPtr : $$dirInfo{NewDataPos} || 0;
        # adjust CanonVRD offset to point to end of regular TIFF if necessary
        # (NOTE: This will be incorrect if multiple trailers exist,
        #  but it is unlikely that it could ever be correct in this case anyway.
        #  Also, this doesn't work for JPEG images (but CanonDPP doesn't set
        #  this when editing JPEG images anyway))
        $fixup->SetMarkerPointers(\$newData, 'CanonVRD', length($newData) + $blockSize);
        if ($newDataPos) {
            $fixup->{Shift} += $newDataPos;
            $fixup->ApplyFixup(\$newData);
        }
        # save fixup for adjusting Leica trailer offset if necessary
        $$exifTool{LeicaTrailer}{Fixup}->AddFixup($fixup) if $$exifTool{LeicaTrailer};
        # save fixup for PreviewImage in JPEG file if necessary
        my $previewInfo = $exifTool->{PREVIEW_INFO};
        if ($previewInfo) {
            my $pt = \$previewInfo->{Data}; # image data or 'LOAD_PREVIEW' flag
            # now that we know the size of the EXIF data, first test to see if our new image fits
            # inside the EXIF segment (remember about the TIFF and EXIF headers: 8+6 bytes)
            if (($$pt ne 'LOAD_PREVIEW' and length($$pt) + length($newData) + 14 <= 0xfffd and
                not $previewInfo->{IsTrailer}) or
                $previewInfo->{IsShort}) # must fit in this segment if using short pointers
            {
                # It fits! (or must exist in EXIF segment), so fixup the
                # PreviewImage pointers and stuff the preview image in here
                my $newPos = length($newData) + $newDataPos;
                $newPos += ($previewInfo->{BaseShift} || 0);
                if ($previewInfo->{Relative}) {
                    # calculate our base by looking at how far the pointer got shifted
                    $newPos -= ($fixup->GetMarkerPointers(\$newData, 'PreviewImage') || 0);
                }
                $fixup->SetMarkerPointers(\$newData, 'PreviewImage', $newPos);
                $newData .= $$pt;
                # set flag to delete old preview unless it was contained in the EXIF
                $exifTool->{DEL_PREVIEW} = 1 unless $exifTool->{PREVIEW_INFO}{WasContained};       
                delete $exifTool->{PREVIEW_INFO};   # done with our preview data
            } else {
                # Doesn't fit, or we still don't know, so save fixup information
                # and put the preview at the end of the file
                $previewInfo->{Fixup} or $previewInfo->{Fixup} = new Image::ExifTool::Fixup;
                $previewInfo->{Fixup}->AddFixup($fixup);
            }
        } elsif (defined $newData and $deleteAll) {
            $newData = '';  # delete both IFD0 and IFD1 since only mandatory tags remain
        } elsif ($$exifTool{A100PreviewLength}) {
            # save preview image start for patching A100 quirks later
            $$exifTool{A100PreviewStart} = $fixup->GetMarkerPointers(\$newData, 'PreviewImage');
        }
        # save location of last IFD for use in Canon RAW header
        if ($newDataPos == 16) {
            my @ifdPos = $fixup->GetMarkerPointers(\$newData,'NextIFD');
            $$origDirInfo{LastIFD} = pop @ifdPos;
        }
        # recrypt SR2 SubIFD data if necessary
        my $key = $$exifTool{SR2SubIFDKey};
        if ($key) {
            my $start = $fixup->GetMarkerPointers(\$newData, 'SR2SubIFDOffset');
            my $len = $$exifTool{SR2SubIFDLength};
            # (must subtract 8 for size of TIFF header)
            if ($start and $start - 8 + $len <= length $newData) {
                require Image::ExifTool::Sony;
                Image::ExifTool::Sony::Decrypt(\$newData, $start - 8, $len, $key);
            }
        }
    }
    # return empty string if no entries in directory
    # (could be up to 10 bytes and still be empty)
    $newData = '' if defined $newData and length($newData) < 12;

    return $newData;    # return our directory data
}

1; # end

__END__

=head1 NAME

Image::ExifTool::WriteExif.pl - Write EXIF meta information

=head1 SYNOPSIS

This file is autoloaded by Image::ExifTool::Exif.

=head1 DESCRIPTION

This file contains routines to write EXIF metadata.

=head1 AUTHOR

Copyright 2003-2013, Phil Harvey (phil at owl.phy.queensu.ca)

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 SEE ALSO

L<Image::ExifTool::Exif(3pm)|Image::ExifTool::Exif>,
L<Image::ExifTool(3pm)|Image::ExifTool>

=cut
