package Image::TIFF;

# Copyright 1999-2001, Gisle Aas.
# Copyright 2006, 2007 Tels
#
# This library is free software; you can redistribute it and/or
# modify it under the same terms as Perl v5.8.8 itself.

use strict;
use vars qw($VERSION);

$VERSION = '1.09';

my @types = (
  [ "BYTE",      "C1", 1],
  [ "ASCII",     "A1", 1],
  [ "SHORT",     "n1", 2],
  [ "LONG",      "N1", 4],
  [ "RATIONAL",  "N2", 8],
  [ "SBYTE",     "c1", 1],
  [ "UNDEFINED", "a1", 1],
  [ "BINARY",    "a1", 1],  # treat binary data as UNDEFINED	
  [ "SSHORT",    "n1", 2],
  [ "SLONG",     "N1", 4],
  [ "SRATIONAL", "N2", 8],
  [ "FLOAT",     "f1", 4],  # XXX 4-byte IEEE format
  [ "DOUBLE",    "d1", 8],  # XXX 8-byte IEEE format
# XXX TODO:
#  [ "IFD",      "??", ?],  # See ExifTool
);

my %nikon1_tags = (
    0x0003 => "Quality",
    0x0004 => "ColorMode",
    0x0005 => "ImageAdjustment",
    0x0006 => "CCDSensitivity",
    0x0007 => "Whitebalance",
    0x0008 => "Focus",
    0x000A => "DigitalZoom",
    0x000B => "Converter",
);

my %nikon2_tags = (
    0x0001 => "NikonVersion",
    0x0002 => "ISOSetting",
    0x0003 => "ColorMode",
    0x0004 => "Quality",
    0x0005 => "Whitebalance",
    0x0006 => "ImageSharpening",
    0x0007 => "FocusMode",
    0x0008 => "FlashSetting",
    0x0009 => "FlashMetering",
    0x000B => "WBAdjustment",
    0x000F => "ISOSelection",
    0x0080 => "ImageAdjustment",
    0x0082 => "AuxiliaryLens",
    0x0084 => "Lens",
    0x0085 => "ManualFocusDistance",
    0x0086 => "DigitalZoom",
    0x0088 => { __TAG__ => "AFFocusPosition",
                pack("xCxx",0) => "Center",
                pack("xCxx",1) => "Top",
                pack("xCxx",2) => "Bottom",
                pack("xCxx",3) => "Left",
                pack("xCxx",4) => "Right",
              },
    0x008d => "ColorMode",
    0x0090 => "FlashType",
    0x0095 => "NoiseReduction",
    0x0010 => "DataDump",
);

my %olympus_tags = (
    0x0200 => "SpecialMode",
    0x0201 => { __TAG__ => "JpegQual", 0 => "SQ", 1 => "HQ", 2 => "SHQ" },
    0x0202 => { __TAG__ => "Macro", 0 => "Normal", 1 => "Macro" },
    0x0204 => "DigiZoom",
    0x0207 => "SoftwareRelease",
    0x0208 => "PictInfo",
    0x0209 => "CameraID",
    0x0f00 => "DataDump",
);

my %fujifilm_tags = (
    0x0000 => "Version",
    0x1000 => "Quality",
    0x1001 => { __TAG__ => "Sharpness", 
                1 => "Very Soft",
                2 => "Soft",
                3 => "Normal",
                4 => "Hard",
                5 => "Very Hard",
              },
    0x1002 => { __TAG__ => "WhiteBalance",
                0    => "Auto",
                256  => "Daylight",
                512  => "Cloudy",
                768  => "DaylightColor-fluorescence",
                769  => "DaywhiteColor-fluorescence",
                770  => "White-fluorescence",
                1024 => "Incandenscense",
                3840 => "Custom white balance",
              },
    0x1003 => { __TAG__ => "Color", 0 => "Normal", 256 => "High", 512 => "Low" },
    0x1004 => { __TAG__ => "Tone" , 0 => "Normal", 256 => "High", 512 => "Low" },
    0x1010 => { __TAG__ => "FlashMode", 0 => "Auto", 1 => "On", 2 => "Off", 3 => "Red-eye reduction" },
    0x1011 => "FlashStrength",
    0x1020 => { __TAG__ => "Macro", 0 => "Off", 1 => "On"},
    0x1021 => { __TAG__ => "FocusMode", 0 => "Auto", 1 => "Manual" },
    0x1030 => { __TAG__ => "SlowSync", 0 => "Off", 1 => "On"},
    0x1031 => { __TAG__ => "PictureMode",
                0   => "Auto",
                1   => "Portrait",
                2   => "Landscape",
                4   => "Sports",
                5   => "Night",
                6   => "Program AE",
                256 => "Aperture priority",
                512 => "Shutter priority",
                768 => "Manual",
              },
    0x1100 => { __TAG__ => "AutoBracketing", 0 => "Off", 1 => "On"},
    0x1300 => { __TAG__ => "BlurWarning", 0 => "No", 1 => "Yes"},
    0x1301 => { __TAG__ => "FocusWarning", 0 => "No", 1 => "Yes"},
    0x1302 => { __TAG__ => "AEWarning", 0 => "No", 1 => "Yes"},
);

my %casio_tags = (
    0x0001 => { __TAG__ => "RecordingMode",
                1 => "SingleShutter",
                2 => "Panorama",
                3 => "Night scene",
                4 => "Portrait",
                5 => "Landscape",
              },
    0x0002 => { __TAG__ => "Quality", 1 => "Economy", 2 => "Normal", 3 => "Fine" },
    0x0003 => { __TAG__ => "FocusingMode",
                2 => "Macro",
                3 => "Auto",
                4 => "Manual",
                5 => "Infinity",
              },
    0x0004 => { __TAG__ => "FlashMode", 1 => "Auto", 2 => "On", 3 => "Off", 4 => "Red-eye reduction" },
    0x0005 => { __TAG__ => "FlashIntensity", 11 => "Weak", 13 => "Normal", 15 => "Strong" },
    0x0006 => "ObjectDistance",
    0x0007 => { __TAG__ => "WhiteBalance", 
                1 => "Auto",
                2 => "Tungsten",
                3 => "Daylight",
                4 => "Fluorescent",
                5 => "Shade",
                129 => "Manual",
              },
    0x000a => { __TAG__ => "DigitalZoom", 65536 => "Off", 65537 => "2X" },
    0x000b => { __TAG__ => "Sharpness", 0 => "Normal", 1 => "Soft", 2 => "Hard" },
    0x000c => { __TAG__ => "Contrast"  , 0 => "Normal", 1 => "Low", 2 => "High" },
    0x000d => { __TAG__ => "Saturation", 0 => "Normal", 1 => "Low", 2 => "High" },
    0x0014 => { __TAG__ => "CCDSensitivity",
                64  => "Normal",
                125 => "+1.0",
                250 => "+2.0",
                244 => "+3.0",
                80  => "Normal",
                100 => "High",
              },
);

my %canon_0x0001_tags = (
     0 => { __TAG__ => "MacroMode", 1 => "Macro", 2 => "Normal" },
     1 => "SelfTimer",
     2 => { __TAG__ => "Quality", 2 => "Normal", 3 => "Fine", 5 => "SuperFine" },
     3 => 'Tag-0x0001-03',
     4 => { __TAG__ => 'FlashMode',
            0 => 'Flash Not Fired',
            1 => 'Auto',
            2 => 'On',
            3 => 'Red-Eye Reduction',
            4 => 'Slow Synchro',
            5 => 'Auto + Red-Eye Reduction',
            6 => 'On + Red-Eye Reduction',
            16 => 'External Flash'
          },
     5 => { __TAG__ => 'ContinuousDriveMode', 0 => 'Single Or Timer', 1 => 'Continuous' },
     6 => 'Tag-0x0001-06',
     7 => { __TAG__ => 'FocusMode',
            0 => 'One-Shot',
            1 => 'AI Servo',
            2 => 'AI Focus',
            3 => 'MF',
            4 => 'Single',
            5 => 'Continuous',
            6 => 'MF'
          },
     8 => 'Tag-0x0001-08',
     9 => 'Tag-0x0001-09',
    10 => { __TAG__ => 'ImageSize', 0 => 'Large', 1 => 'Medium', 2 => 'Small' },
    11 => { __TAG__ => 'EasyShootingMode',
            0 => 'Full Auto',
            1 => 'Manual',
            2 => 'Landscape',
            3 => 'Fast Shutter',
            4 => 'Slow Shutter',
            5 => 'Night',
            6 => 'B&W',
            7 => 'Sepia',
            8 => 'Portrait',
            9 => 'Sports',
            10 => 'Macro/Close-Up',
            11 => 'Pan Focus'
         },
    12 => { __TAG__ => 'DigitalZoom', 0 => 'None', 1 => '2x', 2 => '4x' },
    13 => { __TAG__ => 'Contrast', 0xFFFF => 'Low', 0 => 'Normal', 1 => 'High' },
    14 => { __TAG__ => 'Saturation', 0xFFFF => 'Low', 0 => 'Normal', 1 => 'High' },
    15 => { __TAG__ => 'Sharpness', 0xFFFF => 'Low', 0 => 'Normal', 1 => 'High' },
    16 => { __TAG__ => 'ISO',
            0 => 'See ISOSpeedRatings Tag',
            15 => 'Auto',
            16 => '50',
            17 => '100',
            18 => '200',
            19 => '400'
         },
    17 => { __TAG__ => 'MeteringMode', 3 => 'Evaluative', 4 => 'Partial', 5 => 'Center-Weighted' },
    18 => { __TAG__ => 'FocusType',
            0 => 'Manual',
            1 => 'Auto',
            3 => 'Close-Up (Macro)',
            8 => 'Locked (Pan Mode)'
         },
    19 => { __TAG__ => 'AFPointSelected',
            0x3000 => 'None { __TAG__ => MF)',
            0x3001 => 'Auto-Selected',
            0x3002 => 'Right',
            0x3003 => 'Center',
            0x3004 => 'Left'
         },
    20 => { __TAG__ => 'ExposureMode',
            0 => 'Easy Shooting',
            1 => 'Program',
            2 => 'Tv-priority',
            3 => 'Av-priority',
            4 => 'Manual',
            5 => 'A-DEP'
         },
    21 => 'Tag-0x0001-21',
    22 => 'Tag-0x0001-22',
    23 => 'LongFocalLengthOfLensInFocalUnits', 
    24 => 'ShortFocalLengthOfLensInFocalUnits',
    25 => 'FocalUnitsPerMM',
    26 => 'Tag-0x0001-26',
    27 => 'Tag-0x0001-27',
    28 => { __TAG__ => 'FlashActivity', 0 => 'Did Not Fire', 1 => 'Fired' },
    29 => { __TAG__ => 'FlashDetails',
            14 => 'External E-TTL',
            13 => 'Internal Flash',
            11 => 'FP Sync Used',
            7 => '2nd ("Rear")-Curtain Sync Used',
            4 => 'FP Sync Enabled'
         },
    30 => 'Tag-0x0001-30',
    31 => 'Tag-0x0001-31',
    32 => { __TAG__ => 'FocusMode', 0 => 'Single', 1 => 'Continuous' },    
);

my %canon_0x0004_tags = (  
    7 => { __TAG__ => 'WhiteBalance',
           0 => 'Auto',
           1 => 'Sunny',
           2 => 'Cloudy',
           3 => 'Tungsten',
           4 => 'Fluorescent',
           5 => 'Flash',
           6 => 'Custom'
         },
    9 => 'SequenceNumber',
    14 => 'AFPointUsed',
    15 => { __TAG__ => 'FlashBias',
           0xFFC0 => '-2 EV',
           0xFFCC => '-1.67 EV',
           0xFFD0 => '-1.50 EV',
           0xFFD4 => '-1.33 EV',
           0xFFE0 => '-1 EV',
           0xFFEC => '-0.67 EV',
           0xFFF0 => '-0.50 EV',
           0xFFF4 => '-0.33 EV',
           0x0000 => '0 EV',
           0x000C => '0.33 EV',
           0x0010 => '0.50 EV',
           0x0014 => '0.67 EV',
           0x0020 => '1 EV',
           0x002C => '1.33 EV',
           0x0030 => '1.50 EV',
           0x0034 => '1.67 EV',
           0x0040 => '2 EV', 
         },
    19 => 'SubjectDistance'
);


my %canon_tags = (
    0x0001 => { __TAG__ => "Custom_0x0001", __ARRAYOFFSET__ => \%canon_0x0001_tags },
    0x0004 => { __TAG__ => "Custom_0x0004", __ARRAYOFFSET__ => \%canon_0x0004_tags },
    0x0006 => "ImageType",
    0x0007 => "FirmwareVersion",
    0x0008 => "ImageNumber",
    0x0009 => "OwnerName",
    0x000c => "SerialNumber",
);

# see http://www.compton.nu/panasonic.html

my %panasonic_tags = (
    0x0001 => { __TAG__ => "ImageQuality",
	2 => 'High',
	3 => 'Normal',
	6 => 'Very High',	#3 (Leica)
	7 => 'Raw', 		#3 (Leica)
	},
    0x0002 => "FirmwareVersion",
    0x0003 => { __TAG__ => "WhiteBalance",
	1 => 'Auto',
	2 => 'Daylight',
	3 => 'Cloudy',
	4 => 'Halogen',
	5 => 'Manual',
	8 => 'Flash',
	10 => 'Black & White', #3 (Leica)
	},
    0x0007 => { __TAG__ => "FocusMode",
	1 => 'Auto',
	2 => 'Manual',
	5 => 'Auto, Continuous',
	4 => 'Auto, Focus button',
	},
    0x000f => { __TAG__ => "SpotMode",
	# XXX TODO: does not decode properly
	"0,1" => 'On',
	"0,16" => 'Off',
	},
    0x001a => { __TAG__ => "ImageStabilizer",
	2 => 'On, Mode 1',
	3 => 'Off',
	4 => 'On, Mode 2',
	},
    0x001c => { __TAG__ => "MacroMode",
	1 => 'On',
	2 => 'Off',
	},
    0x001f => { __TAG__ => "ShootingMode",
	1  => 'Normal',
	2  => 'Portrait',
	3  => 'Scenery',
	4  => 'Sports',
	5  => 'Night Portrait',
	6  => 'Program',
	7  => 'Aperture Priority',
	8  => 'Shutter Priority',
	9  => 'Macro',
	11 => 'Manual',
	13 => 'Panning',
	18 => 'Fireworks',
	19 => 'Party',
	20 => 'Snow',
	21 => 'Night Scenery',
	},
    0x0020 => { __TAG__ => "Audio",
	1 => 'Yes',
	2 => 'No',
	},
    0x0021 => "DataDump",
    0x0022 => "Panasonic 0x0022",
    0x0023 => "WhiteBalanceBias",
    0x0024 => "FlashBias",
    0x0025 => "SerialNumber",
    0x0026 => "Panasonic 0x0026",
    0x0027 => "Panasonic 0x0027",
    0x0028 => { __TAG__ => "ColorEffect",
	1 => 'Off',
	2 => 'Warm',
	3 => 'Cool',
	4 => 'Black & White',
	5 => 'Sepia',
	},
    0x0029 => "Panasonic 0x0029",
    0x002a => { __TAG__ => "BurstMode",
	0 => 'Off',
	1 => 'Low/High Quality',
	2 => 'Infinite',
	},
    0x002b => "ImageSequenceNumber",
    0x002c => { __TAG__ => "Contrast",
	0 => 'Normal',
	1 => 'Low',
	2 => 'High',
	0x100 => 'Low',		# Leica
	0x110 => 'Normal',	# Leica
	0x120 => 'High',	# Leica
	},
    0x002d => { __TAG__ => "NoiseReduction",
	0 => 'Standard',
	1 => 'Low',
	2 => 'High',
	},
    0x002e => { __TAG__ => "SelfTimer",
	1 => 'Off',
	2 => '10s',
	3 => '2s',
	},
    0x002f => "Panasonic 0x002f",
    0x0030 => "Panasonic 0x0030",
    0x0031 => "Panasonic 0x0031",
    0x0032 => "Panasonic 0x0032",
);

# format:
#    "Make Model" => [ Offset, 'Tag_prefix', ptr to tags ]
# Offset is either 0, or a positive number of Bytes.
# Offset -1 or -2 means a kludge for Fuji or Nikon

my %makernotes = (
    "NIKON CORPORATION NIKON D1"	=> [0,  'NikonD1', \%nikon2_tags],
    "NIKON CORPORATION NIKON D70"	=> [-2, 'NikonD1', \%nikon2_tags],
    "NIKON CORPORATION NIKON D100"	=> [-2, 'NikonD1', \%nikon2_tags],

    # For the following manufacturers we simple discard the model and always
    # decode the MakerNote in the same manner. This makes it work with all
    # models, even yet unreleased ones. (That's better than the very limited
    # list of models we previously had)

    "CANON"		=> [0, 'Canon', \%canon_tags],
    'PANASONIC'		=> [12, 'Panasonic', \%panasonic_tags],
    "FUJIFILM"		=> [-1, 'FinePix', \%fujifilm_tags],
    "CASIO"		=> [0, 'Casio', \%casio_tags],
    "OLYMPUS"		=> [8, 'Olympus', \%olympus_tags],
);

BEGIN
  {
  # add some Nikon cameras
  for my $model (qw/E700 E800 E900 E900S E910 E950/)
    {
    $makernotes{'NIKON ' . $model} = [8, 'CoolPix', \%nikon1_tags];
    }
  for my $model (qw/E880 E990 E995/)
    {
    $makernotes{'NIKON ' . $model} = [0, 'CoolPix', \%nikon2_tags];
    }
  }

my %exif_intr_tags = (
    0x1    => "InteroperabilityIndex",
    0x2    => "InteroperabilityVersion",
    0x1000 => "RelatedImageFileFormat",
    0x1001 => "RelatedImageWidth",
    0x1002 => "RelatedImageLength",
);

# Tag decode helpers
sub components_configuration_decoder;
sub file_source_decoder;
sub scene_type_decoder;

my %exif_tags = (
    0x828D => "CFARepeatPatternDim",
    0x828E => "CFAPattern",
    0x828F => "BatteryLevel",
    0x8298 => "Copyright",
    0x829A => "ExposureTime",
    0x829D => "FNumber",
    0x83BB => "IPTC/NAA",
    0x8769 => "ExifOffset",
    0x8773 => "InterColorProfile",
    0x8822 => { __TAG__ => "ExposureProgram",
		0 => "unknown",
		1 => "Manual",
		2 => "Program",
		3 => "Aperture priority",
		4 => "Shutter priority",
		5 => "Program creative",
		6 => "Program action",
		7 => "Portrait",
		8 => "Landscape",
		# 9 .. 255 reserved
	      },
    0x8824 => "SpectralSensitivity",
    0x8827 => "ISOSpeedRatings",
    0x8828 => "OECF",
    0x9000 => "ExifVersion",
    0x9003 => "DateTimeOriginal",
    0x9004 => "DateTimeDigitized",
    0x9101 => { __TAG__ => "ComponentsConfiguration",
                DECODER => \&components_configuration_decoder,
              },
    0x9102 => "CompressedBitsPerPixel",
    0x9201 => "ShutterSpeedValue",
    0x9202 => "ApertureValue",
    0x9203 => "BrightnessValue",
    0x9204 => "ExposureBiasValue",
    0x9205 => "MaxApertureValue",
    0x9206 => "SubjectDistance",
    0x9207 => { __TAG__ => "MeteringMode",
		0 => "unknown",
		1 => "Average",
		2 => "CenterWeightedAverage",
		3 => "Spot",
		4 => "MultiSpot",
		5 => "Pattern",
		6 => "Partial",
		# 7 .. 254 reserved in EXIF 1.2
		255 => "other",
	      },
    0x9208 => { __TAG__ => "LightSource",
		0 => "unknown",
		1 => "Daylight",
		2 => "Fluorescent",
		3 => "Tungsten",
		4 => "Flash",
		# 5 .. 8 reserved in EXIF 2.2
		9 => "Fine weather",
		10 => "Cloudy weather",
		11 => "Shade",
		12 => "Daylight fluorescent (D 5700-7100K)",
		13 => "Day white fluorescent (N 4600-5400K)",
		14 => "Cool white fluorescent (W 3900-4500K)",
		15 => "White fluorescent (WW 3200-3700K)",		
		17 => "Standard light A",
		18 => "Standard light B",
		19 => "Standard light C",
		20 => "D55",
		21 => "D65",
		22 => "D75",
		23 => "D50",
		24 => "ISO studio tungesten",		
		# 25 .. 254 reserved in EXIF 2.2
		255 => "other light source",
	      },
    0x9209 => { __TAG__ => "Flash",
		0x0000 => "Flash did not fire",
		0x0001 => "Flash fired",
		0x0005 => "Strobe return light not detected",
		0x0007 => "Strobe return light detected",
		0x0009 => "Flash fired, compulsory flash mode",
		0x000D => "Flash fired, compulsory flash mode, return light not detected",
		0x000F => "Flash fired, compulsory flash mode, return light detected",
		0x0010 => "Flash did not fire, compulsory flash mode",
		0x0018 => "Flash did not fire, auto mode",
		0x0019 => "Flash fired, auto mode",
		0x001D => "Flash fired, auto mode, return light not detected",
		0x001F => "Flash fired, auto mode, return light detected",
		0x0020 => "No flash function",
		0x0041 => "Flash fired, red-eye reduction mode",
		0x0045 => "Flash fired, red-eye reduction mode, return light not detected",
		0x0047 => "Flash fired, red-eye reduction mode, return light detected",
		0x0049 => "Flash fired, compulsory flash mode, red-eye reduction mode",
		0x004D => "Flash fired, compulsory flash mode, red-eye reduction mode, return light not detected",
		0x004F => "Flash fired, compulsory flash mode, red-eye reduction mode, return light detected",
		0x0059 => "Flash fired, auto mode, red-eye reduction mode",
		0x005D => "Flash fired, auto mode, return light not detected, red-eye reduction mode",
		0x005F => "Flash fired, auto mode, return light detected, red-eye reduction mode"
		},
    0x920A => "FocalLength",
    0x9214 => "SubjectArea",
    0x927C => "MakerNote",
    0x9286 => "UserComment",
    0x9290 => "SubSecTime",
    0x9291 => "SubSecTimeOriginal",
    0x9292 => "SubSecTimeDigitized",
    0xA000 => "FlashPixVersion",
    0xA001 => "ColorSpace",
    0xA002 => "ExifImageWidth",
    0xA003 => "ExifImageLength",
    0xA004 => "RelatedAudioFile",
    0xA005 => {__TAG__ => "InteroperabilityOffset",
	       __SUBIFD__ => \%exif_intr_tags,
	      },
    0xA20B => "FlashEnergy",                  # 0x920B in TIFF/EP
    0xA20C => "SpatialFrequencyResponse",     # 0x920C    -  -
    0xA20E => "FocalPlaneXResolution",        # 0x920E    -  -
    0xA20F => "FocalPlaneYResolution",        # 0x920F    -  -
    0xA210 => { __TAG__ => "FocalPlaneResolutionUnit",     # 0x9210    -  -
		1 => "pixels",
		2 => "dpi",
		3 => "dpcm",
	      },
    0xA214 => "SubjectLocation",              # 0x9214    -  -
    0xA215 => "ExposureIndex",                # 0x9215    -  -
    0xA217 => {__TAG__ => "SensingMethod",
		1 => "Not defined",
		2 => "One-chip color area sensor",
		3 => "Two-chip color area sensor",
		4 => "Three-chip color area sensor",
		5 => "Color sequential area sensor",
		7 => "Trilinear sensor",
		8 => "Color sequential linear sensor"
		},
    0xA300 => {__TAG__ => "FileSource",
               DECODER => \&file_source_decoder,
              },
    0xA301 => {__TAG__ => "SceneType",
               DECODER => \&scene_type_decoder,
              },
    0xA302 => "CFAPattern",
    0xA401 => {__TAG__ => "CustomRendered",
		0 => "Normal process",
		1 => "Custom process"
		},
    0xA402 => {__TAG__ => "ExposureMode",
		0 => "Auto exposure",
		1 => "Manual exposure",
		2 => "Auto bracket"
		},
    0xA403 => {__TAG__ => "WhiteBalance",
		0 => "Auto white balance",
		1 => "Manual white balance"
		},
    0xA404 => "DigitalZoomRatio",
    0xA405 => "FocalLengthIn35mmFilm",
    0xA406 => {__TAG__ => "SceneCaptureType",
		0 => "Standard",
		1 => "Landscape",
		2 => "Portrait",
		3 => "Night Scene"
		},
    0xA407 => {__TAG__ => "GainControl",
		0 => "None",
		1 => "Low gain up",
		2 => "High gain up",
		3 => "Low gain down",
		4 => "High gain down"
		},
    0xA408 => {__TAG__ => "Contrast",
		0 => "Normal",
		1 => "Soft",
		2 => "Hard"
		},
    0xA409 => {__TAG__ => "Saturation",
		0 => "Normal",
		1 => "Low saturation",
		2 => "High saturation"
		},
    0xA40A => {__TAG__ => "Sharpness",
		0 => "Normal",
		1 => "Soft",
		2 => "Hard"
		},
    0xA40B => "DeviceSettingDescription",
    0xA40C => {__TAG__ => "SubjectDistanceRange",
		0 => "Unknown",
		1 => "Macro",
		2 => "Close view",
		3 => "Distant view"
		},
    0xA420 => "ImageUniqueID",
);

my %gps_tags = (
    0x0000 => 'GPSVersionID',
    0x0001 => 'GPSLatitudeRef',
    0x0002 => 'GPSLatitude',
    0x0003 => 'GPSLongitudeRef',
    0x0004 => 'GPSLongitude',
    0x0005 => 'GPSAltitudeRef',
    0x0006 => 'GPSAltitude',
    0x0007 => 'GPSTimeStamp',
    0x0008 => 'GPSSatellites',
    0x0009 => 'GPSStatus',
    0x000A => 'GPSMeasureMode',
    0x000B => 'GPSDOP',
    0x000C => 'GPSSpeedRef',
    0x000D => 'GPSSpeed',
    0x000E => 'GPSTrackRef',
    0x000F => 'GPSTrack',
    0x0010 => 'GPSImgDirectionRef',
    0x0011 => 'GPSImgDirection',
    0x0012 => 'GPSMapDatum',
    0x0013 => 'GPSDestLatitudeRef',
    0x0014 => 'GPSDestLatitude',
    0x0015 => 'GPSDestLongitudeRef',
    0x0016 => 'GPSDestLongitude',
    0x0017 => 'GPSDestBearingRef',
    0x0018 => 'GPSDestBearing',
    0x0019 => 'GPSDestDistanceRef',
    0x001A => 'GPSDestDistance',
    0x001B => 'GPSProcessingMethod',
    0x001C => 'GPSAreaInformation',
    0x001D => 'GPSDateStamp',
    0x001E => 'GPSDifferential',
);

my %tiff_tags = (
  254   => { __TAG__ => "NewSubfileType",
	     1 => "ReducedResolution",
	     2 => "SinglePage",
	     4 => "TransparencyMask",
	 },
  255   => { __TAG__ => "SubfileType",
	     1 => "FullResolution",
	     2 => "ReducedResolution",
	     3 => "SinglePage",
	   },
  256   => "width",
  257   => "height",
  258   => "BitsPerSample",
  259   => { __TAG__ => "Compression",
		1 => "PackBytes",
		2 => "CCITT Group3",
		3 => "CCITT T4",
		4 => "CCITT T6",
		5 => "LZW",
		6 => "JPEG",
		7 => "JPEG DCT",
		8 => "Deflate (Adobe)",
		32766 => "NeXT 2-bit RLE",
		32771 => "#1 w/ word alignment",
		32773 => "PackBits (Macintosh RLE)",
		32809 => "ThunderScan RLE",
		32895 => "IT8 CT w/padding",
		32896 => "IT8 Linework RLE",
		32897 => "IT8 Monochrome picture",
		32898 => "IT8 Binary line art",
		32908 => "Pixar companded 10bit LZW",
		32909 => "Pixar companded 11bit ZIP",
		32946 => "Deflate",
           },
  262   => { __TAG__ => "PhotometricInterpretation",
	     0 => "WhiteIsZero",
	     1 => "BlackIsZero",
	     2 => "RGB",
	     3 => "RGB Palette",
	     4 => "Transparency Mask",
	     5 => "CMYK",
	     6 => "YCbCr",
	     8 => "CIELab",
	   },
  263   => { __TAG__ => "Threshholding",
	     1 => "NoDithering",
	     2 => "OrderedDither",
	     3 => "Randomized",
	   },
  266   => { __TAG__ => "FillOrder",
	     1 => "LowInHigh",
	     2 => "HighInLow",
	   },
  269   => "DocumentName",
  270   => "ImageDescription",
  271   => "Make",
  272   => "Model",
  273   => "StripOffsets",
  274   => { __TAG__ => "Orientation",
	     1 => "top_left",
	     2 => "top_right",
	     3 => "bot_right",
	     4 => "bot_left",
	     5 => "left_top",
	     6 => "right_top",
	     7 => "right_bot",
	     8 => "left_bot",
	   },
  277   => "SamplesPerPixel",
  278   => "RowsPerStrip",
  279   => "StripByteCounts",
  282   => "XResolution",
  283   => "YResolution",
  284   => {__TAG__ => "PlanarConfiguration",
	    1 => "Chunky", 2 => "Planar",
	},
  296   => {__TAG__ => "ResolutionUnit",
	    1 => "pixels", 2 => "dpi", 3 => "dpcm",
	   },
  297   => "PageNumber",
  301   => "TransferFunction",
  305   => "Software",
  306   => "DateTime",
  315   => "Artist",
  316   => "Host",
  318   => "WhitePoint",
  319   => "PrimaryChromaticities",
  320   => "ColorMap",
  513   => "JPEGInterchangeFormat",
  514   => "JPEGInterchangeFormatLength",
  529   => "YCbCrCoefficients",
  530   => "YCbCrSubSampling",
  531   => "YCbCrPositioning",
  532   => "ReferenceBlackWhite",
  33432 => "Copyright",
  34665 => { __TAG__ => "ExifOffset",
	     __SUBIFD__ => \%exif_tags,
	   },
  34853 => { __TAG__ => "GPSInfo",
             __SUBIFD__ => \%gps_tags,
	   },
);


sub new
{
    my $class = shift;
    my $source = shift;

    if (!ref($source)) {
	local(*F);
	open(F, $source) || return;
	binmode(F);
	$source = \*F;
    }

    if (ref($source) ne "SCALAR") {
	# XXX should really only read the file on demand
	local($/);  # slurp mode
	my $data = <$source>;
	$source = \$data;
    }

    my $self = bless { source => $source }, $class;

    for ($$source) {
	my $byte_order = substr($_, 0, 2);
	$self->{little_endian} = ($byte_order eq "II");
	$self->{version} = $self->unpack("n", substr($_, 2, 2));

	my $ifd = $self->unpack("N", substr($_, 4, 4));
	while ($ifd) {
	    push(@{$self->{ifd}}, $ifd);
	    my($num_fields) = $self->unpack("x$ifd n", $_);

	    my $substr_ifd = substr($_, $ifd + 2 + $num_fields*12, 4);
	    last unless defined $substr_ifd; # bad TIFF header, eg: substr idx > length($substr_ifd)

	    my $next_ifd = $self->unpack("N", $substr_ifd);

	    # guard against (bug #26127)
	    $next_ifd = 0 if $next_ifd > length($_);
	    # guard against looping ifd (bug #26130)
	    if ($next_ifd <= $ifd) {
		# bad TIFF header - would cause a loop or strange results
	        last;
            }
        $ifd = $next_ifd;
	}
    }

    $self;
}

sub unpack
{
    my $self = shift;
    my $template = shift;
    if ($self->{little_endian}) {
	$template =~ tr/nN/vV/;
    }
    #print "UNPACK $template\n";
    CORE::unpack($template, $_[0]);
}

sub num_ifds
{
    my $self = shift;
    scalar @{$self->{ifd}};
}

sub ifd
{
    my $self = shift;
    my $num = shift || 0;
    my @ifd;

    $self->add_fields($self->{ifd}[$num], \@ifd);
}

sub tagname
{
    $tiff_tags{$_[1]} || sprintf "Tag-0x%04x",$_[1];
}

sub exif_tagname
{
    $tiff_tags{$_[1]} || $exif_tags{$_[1]} || sprintf "Tag-0x%04x",$_[1];
}

sub add_fields
{
    my($self, $offset, $ifds, $tags, $voff_plus) = @_;
    return unless $offset;
    # guard against finding the same offset twice (bug #29088)
    return if $self->{seen_offset}{$offset}++;
    $tags ||= \%tiff_tags;

    for (${$self->{source}}) {  # alias as $_
	last if $offset > length($_) - 2;  # bad offset
	my $entries = $self->unpack("x$offset n", $_);
	my $max_entries = int((length($_) - $offset - 2) / 12);
	# print "ENTRIES $entries $max_entries\n";
	if ($entries > $max_entries) {
	    # Hmmm, something smells bad here...  parsing garbage
	    $entries = $max_entries;
	    last;
	}
      FIELD:
	for my $i (0 .. $entries-1) {
	    my $entry_offset = 2 + $offset + $i*12;
	    my($tag, $type, $count, $voff) =
		$self->unpack("nnNN", substr($_, $entry_offset, 12));
	    #print STDERR "TAG $tag $type $count $voff\n";

	    if ($type == 0 || $type > @types) {
		# unknown type code might indicate that we are parsing garbage
		print STDERR "# Ignoring unknown type code $type\n";
		next;
	    }

	    # extract type information
	    my($tmpl, $vlen);
	    ($type, $tmpl, $vlen) = @{$types[$type-1]};

	    die "Undefined type while parsing" unless $type;

	    if ($count * $vlen <= 4) {
		$voff = $entry_offset + 8;
	    }
	    elsif ($voff + $count * $vlen > length($_)) {
		# offset points outside of string, corrupt entry ignore
		print STDERR "# ignoring offset pointer outside of string\n";
		next;
	    }
	    else {
		$voff += $voff_plus || 0;
	    }

	    $tmpl =~ s/(\d+)$/$count*$1/e;

	    my @v = $self->unpack("x$voff $tmpl", $_);

	    if ($type =~ /^S(SHORT|LONG|RATIONAL)/) {
		my $max = 2 ** ($1 eq "SHORT" ? 15 : 31);
		$v[0] -= ($max * 2) if $v[0] >= $max;
	    }

	    my $val = (@v > 1) ? \@v : $v[0];
	    bless $val, "Image::TIFF::Rational" if $type =~ /^S?RATIONAL$/;

	    if ($type eq 'ASCII' || $type eq 'UNDEFINED')
		{
		if ($val =~ /\0[^\0]+\z/)
		    {
		    # cut out the first "ASCII\0" and take the remaining text
		    # (fix bug #29243 parsing of UserComment)
		    # XXX TODO: this needs to handle UNICODE, too:
		    $val =~ /\0([^\0]+)/;
		    $val = '' . ($1 || '');
		    }
		else
		    {
		    # avoid things like "Foo\x00\x00\x00" by removing trailing nulls
		    # this needs to handle UNICODE, too:
		    $val =~ /^([^\0]*)/;
		    $val = '' . ($1 || '');
		    }
		}

	    $tag = $tags->{$tag} || $self->tagname($tag);

	    if ($tag eq 'MakerNote')
		{
        	my $maker = uc($self->{Make} || '');
		$maker =~ /^([A-Z]+)/; $maker = $1 || ''; # "OLYMPUS ..." > "OLYMPUS"

		# if 'Panasonic' doesn't exist, try 'Panasonic DMC-FZ5'
		$maker = $self->{Make}.' '.$self->{Model}
		    unless exists $makernotes{$maker};

		if (exists $makernotes{$maker}) {
                    my ($ifd_off, $tag_prefix, $sub) = @{$makernotes{$maker}};

		    #print STDERR "# Decoding Makernotes from $maker\n";

                    $self->{tag_prefix} = $tag_prefix;
	            if ($ifd_off == -1 && length($val) >= 12) {
               		# fuji kludge -  http://www.butaman.ne.jp/~tsuruzoh/Computer/Digicams/exif-e.html#APP4
                	my $save_endian = $self->{little_endian};
                	$self->{little_endian} = 1;
                	$ifd_off = $self->unpack("N", substr($val, 8, 4));
			$self->add_fields($voff+$ifd_off, $ifds, $sub, $voff);
                	$self->{little_endian} = $save_endian;
                    } elsif ($ifd_off == -2) {
			# Nikon D70/D100 kludge -- word "Nikon" and 5
			# bytes of data is tacked to the front of MakerNote;
			# all EXIF offsets are relative to MakerNote section
			my ($nikon_voff);
			$nikon_voff = 0;
			if (substr($val, 0, 5) eq 'Nikon') {
			    $nikon_voff = $voff+10;
			}
			#print "IFD_OFF $ifd_off NIKON_VOFF $nikon_voff\n";
	        	$self->add_fields($voff+18, $ifds, $sub, $nikon_voff);
		    } else {
	        	$self->add_fields($voff+$ifd_off, $ifds, $sub)
                    }
            	    delete $self->{tag_prefix};
	    	    next FIELD;
		}
            }

	    if (ref($tag)) {
		die "Assert" unless ref($tag) eq "HASH";
		if (my $sub = $tag->{__SUBIFD__}) {
		    next if $val < 0 || $val > length($_);
		    #print "SUBIFD $tag->{__TAG__} $val ", length($_), "\n";
		    $self->add_fields($val, $ifds, $sub);
		    next FIELD;
		}
		if (my $sub = $tag->{__ARRAYOFFSET__}) {
		    my $prefix; $prefix = $tag = $self->{tag_prefix} . '-' if $self->{tag_prefix};	    
		    for (my $i=0; $i < @$val; $i++) {
		      if ( exists($sub->{$i}) )
		      { if ( ref($sub->{$i}) eq "HASH" && exists($sub->{$i}->{__TAG__}) ) 
		      	{ if ( exists($sub->{$i}->{$val->[$i]}) ) 
		      	    {
		  	    push @$ifds, [ $prefix . $sub->{$i}->{__TAG__}, $type, $count, 
		      	         $sub->{$i}->{$val->[$i]} ]; 
			    }
		          else 
		            { 
				push @$ifds, [ $prefix . $sub->{$i}->{__TAG__}, $type, $count, 
				   "Unknown (" . $val->[$i] . ")" ];
			    }
		      	}
		        else
		        { push @$ifds, [ $prefix . $sub->{$i}, $type, $count, $val->[$i] ]; }
		      }
		    }
		    next FIELD;
		}
		#hack for UNDEFINED values, they all have different
		#meanings depending on tag
		$val = &{$tag->{DECODER}}($self,$val) if defined($tag->{DECODER});
		$val = $tag->{$val} if exists $tag->{$val};
		$tag = $tag->{__TAG__};
	    }

        $tag = $self->{tag_prefix} . '-' . $tag if $self->{tag_prefix};

        #if ( $val =~ m/ARRAY/ ) { $val = join(', ',@$val); }
	    push @$ifds, [ $tag, $type, $count, $val ];

        $self->{$tag} = $val if ($tag eq 'Make' or $tag eq 'Model');
	}
    }

    $ifds;
}

sub components_configuration_decoder
{
    my $self = shift;
    my $val = shift;
    my $rv = "";
    my %v = ( 
                0 => undef,
                1 => 'Y',
                2 => 'Cb',
                3 => 'Cr',
                4 => 'R',
                5 => 'G',
                6 => 'B',
            );
return join ( '', map { $v{$_} if defined($v{$_}) } $self->unpack('c4',$val) );
}

sub file_source_decoder
{
    my $self = shift;
    my $val = shift;
    my %v = ( 
                3 => "(DSC) Digital Still Camera",
            );
    $val = $self->unpack('c',$val); 
    return $v{$val} if $v{$val};
    "Other";
}

sub scene_type_decoder
{
    my $self = shift;
    my $val = shift;
    my %v = ( 
                1 => "Directly Photographed Image",
            );
    $val = $self->unpack('c',$val); 
    return $v{$val} if $v{$val};
    "Other";
}

package Image::TIFF::Rational;

use overload '""' => \&as_string,
             '0+' => \&as_float,
             fallback => 1;

sub new {
    my($class, $a, $b) = @_;
    bless [$a, $b], $class;
}

sub as_string {
    my $self = shift;
    #warn "@$self";
    "$self->[0]/$self->[1]";
}

sub as_float {
    my $self = shift;

    # We check here because some stupid cameras (Samsung Digimax 200)
    # use rationals with 0 denominator (found in thumbnail resolution spec).
    if ($self->[1]) {
	return $self->[0] / $self->[1];
    }
    else {
 	return $self->[0];
    }
}

1;
