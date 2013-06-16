#------------------------------------------------------------------------------
# File:         Jpeg2000.pm
#
# Description:  Read JPEG 2000 meta information
#
# Revisions:    02/11/2005 - P. Harvey Created
#               06/22/2007 - PH Added write support (EXIF, IPTC and XMP only)
#
# References:   1) http://www.jpeg.org/public/fcd15444-2.pdf
#               2) ftp://ftp.remotesensing.org/jpeg2000/fcd15444-1.pdf
#------------------------------------------------------------------------------

package Image::ExifTool::Jpeg2000;

use strict;
use vars qw($VERSION);
use Image::ExifTool qw(:DataAccess :Utils);

$VERSION = '1.16';

sub ProcessJpeg2000Box($$$);

my %resolutionUnit = (
    -3 => 'km',
    -2 => '100 m',
    -1 => '10 m',
     0 => 'm',
     1 => '10 cm',
     2 => 'cm',
     3 => 'mm',
     4 => '0.1 mm',
     5 => '0.01 mm',
     6 => 'um',
);

# map of where information is written in JPEG2000 image
my %jp2Map = (
    IPTC         => 'UUID-IPTC',
    IFD0         => 'UUID-EXIF',
    XMP          => 'UUID-XMP',
   'UUID-IPTC'   => 'JP2',
   'UUID-EXIF'   => 'JP2',
   'UUID-XMP'    => 'JP2',
  # jp2h         => 'JP2',  (not yet functional)
  # ICC_Profile  => 'jp2h', (not yet functional)
    IFD1         => 'IFD0',
    EXIF         => 'IFD0', # to write EXIF as a block
    ExifIFD      => 'IFD0',
    GPS          => 'IFD0',
    SubIFD       => 'IFD0',
    GlobParamIFD => 'IFD0',
    PrintIM      => 'IFD0',
    InteropIFD   => 'ExifIFD',
    MakerNotes   => 'ExifIFD',
);

# UUID's for writable UUID directories (by tag name)
my %uuid = (
    'UUID-EXIF'   => 'JpgTiffExif->JP2',
    'UUID-IPTC'   => "\x33\xc7\xa4\xd2\xb8\x1d\x47\x23\xa0\xba\xf1\xa3\xe0\x97\xad\x38",
    'UUID-XMP'    => "\xbe\x7a\xcf\xcb\x97\xa9\x42\xe8\x9c\x71\x99\x94\x91\xe3\xaf\xac",
  # (can't yet write GeoJP2 information)
  # 'UUID-GeoJP2' => "\xb1\x4b\xf8\xbd\x08\x3d\x4b\x43\xa5\xae\x8c\xd7\xd5\xa6\xce\x03",
);

# JPEG 2000 "box" (ie. atom) names
%Image::ExifTool::Jpeg2000::Main = (
    GROUPS => { 2 => 'Image' },
    PROCESS_PROC => \&ProcessJpeg2000Box,
    WRITE_PROC => \&ProcessJpeg2000Box,
    NOTES => q{
        The tags below are extracted from JPEG 2000 images, however ExifTool
        currently writes only EXIF, IPTC and XMP tags in these images.
    },
   'jP  ' => 'JP2Signature', # (ref 1)
   "jP\x1a\x1a" => 'JP2Signature', # (ref 2)
    prfl => 'Profile',
    ftyp => {
        Name => 'FileType',
        SubDirectory => { TagTable => 'Image::ExifTool::Jpeg2000::FileType' },
    },
    rreq => 'ReaderRequirements',
    jp2h => {
        Name => 'JP2Header',
        SubDirectory => { },
    },
        # JP2Header sub boxes...
        ihdr => {
            Name => 'ImageHeader',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Jpeg2000::ImageHeader',
            },
        },
        bpcc => 'BitsPerComponent',
        colr => [
            {
                Name => 'ICC_Profile',
                Condition => '$$valPt =~ /^(\x02|\x03)/',
                SubDirectory => {
                    TagTable => 'Image::ExifTool::ICC_Profile::Main',
                    Start => '$valuePtr + 3',
                },
            },
            {
                Name => 'Colorspace',
                Condition => '$$valPt =~ /^\x01/',
                Format => 'binary',
                ValueConv => 'unpack("x3N", $val)',
                PrintConv => {
                    16 => 'sRGB',
                    17 => 'Grayscale',
                    18 => 'sYCC',
                },
            },
            {
                Name => 'ColorSpecification',
                Binary => 1,
            },
        ],
        pclr => 'Palette',
        cdef => 'ComponentDefinition',
       'res '=> {
            Name => 'Resolution',
            SubDirectory => { },
        },
            # Resolution sub boxes...
            resc => {
                Name => 'CaptureResolution',
                SubDirectory => {
                    TagTable => 'Image::ExifTool::Jpeg2000::CaptureResolution',
                },
            },
            resd => {
                Name => 'DisplayResolution',
                SubDirectory => {
                    TagTable => 'Image::ExifTool::Jpeg2000::DisplayResolution',
                },
            },
    jpch => {
        Name => 'CodestreamHeader',
        SubDirectory => { },
    },
        # CodestreamHeader sub boxes...
       'lbl '=> {
            Name => 'Label',
            Format => 'string',
        },
        cmap => 'ComponentMapping',
        roid => 'ROIDescription',
    jplh => {
        Name => 'CompositingLayerHeader',
        SubDirectory => { },
    },
        # CompositingLayerHeader sub boxes...
        cgrp => 'ColorGroup',
        opct => 'Opacity',
        creg => 'CodestreamRegistration',
    dtbl => 'DataReference',
    ftbl => {
        Name => 'FragmentTable',
        Subdirectory => { },
    },
        # FragmentTable sub boxes...
        flst => 'FragmentList',
    cref => 'Cross-Reference',
    mdat => 'MediaData',
    comp => 'Composition',
    copt => 'CompositionOptions',
    inst => 'InstructionSet',
    asoc => 'Association',
    nlst => 'NumberList',
    bfil => 'BinaryFilter',
    drep => 'DesiredReproductions',
        # DesiredReproductions sub boxes...
        gtso => 'GraphicsTechnologyStandardOutput',
    chck => 'DigitalSignature',
    mp7b => 'MPEG7Binary',
    free => 'Free',
    jp2c => 'ContiguousCodestream',
    jp2i => {
        Name => 'IntellectualProperty',
        SubDirectory => {
            TagTable => 'Image::ExifTool::XMP::Main',
        },
    },
   'xml '=> {
        Name => 'XML',
        SubDirectory => {
            TagTable => 'Image::ExifTool::XMP::Main',
        },
    },
    uuid => [
        {
            Name => 'UUID-EXIF',
            Condition => '$$valPt=~/^JpgTiffExif->JP2/',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Exif::Main',
                ProcessProc => \&Image::ExifTool::ProcessTIFF,
                WriteProc => \&Image::ExifTool::WriteTIFF,
                DirName => 'EXIF',
                Start => '$valuePtr + 16',
            },
        },
        {
            Name => 'UUID-IPTC',
            Condition => '$$valPt=~/^\x33\xc7\xa4\xd2\xb8\x1d\x47\x23\xa0\xba\xf1\xa3\xe0\x97\xad\x38/',
            SubDirectory => {
                TagTable => 'Image::ExifTool::IPTC::Main',
                Start => '$valuePtr + 16',
            },
        },
        {
            Name => 'UUID-XMP',
            # ref http://www.adobe.com/products/xmp/pdfs/xmpspec.pdf
            Condition => '$$valPt=~/^\xbe\x7a\xcf\xcb\x97\xa9\x42\xe8\x9c\x71\x99\x94\x91\xe3\xaf\xac/',
            SubDirectory => {
                TagTable => 'Image::ExifTool::XMP::Main',
                Start => '$valuePtr + 16',
            },
        },
        {
            Name => 'UUID-GeoJP2',
            # ref http://www.remotesensing.org/jpeg2000/
            Condition => '$$valPt=~/^\xb1\x4b\xf8\xbd\x08\x3d\x4b\x43\xa5\xae\x8c\xd7\xd5\xa6\xce\x03/',
            SubDirectory => {
                TagTable => 'Image::ExifTool::Exif::Main',
                ProcessProc => \&Image::ExifTool::ProcessTIFF,
                Start => '$valuePtr + 16',
            },
        },
        {
            Name => 'UUID-Unknown',
        },
    ],
    uinf => {
        Name => 'UUIDInfo',
        SubDirectory => { },
    },
        # UUIDInfo sub boxes...
        ulst => 'UUIDList',
       'url '=> {
            Name => 'URL',
            Format => 'string',
        },
);

%Image::ExifTool::Jpeg2000::ImageHeader = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 2 => 'Image' },
    0 => {
        Name => 'ImageHeight',
        Format => 'int32u',
    },
    4 => {
        Name => 'ImageWidth',
        Format => 'int32u',
    },
    8 => {
        Name => 'NumberOfComponents',
        Format => 'int16u',
    },
    10 => {
        Name => 'BitsPerComponent',
        PrintConv => q{
            $val == 0xff and return 'Variable';
            my $sign = ($val & 0x80) ? 'Signed' : 'Unsigned';
            return (($val & 0x7f) + 1) . " Bits, $sign";
        },
    },
    11 => {
        Name => 'Compression',
        PrintConv => {
            0 => 'Uncompressed',
            1 => 'Modified Huffman',
            2 => 'Modified READ',
            3 => 'Modified Modified READ',
            4 => 'JBIG',
            5 => 'JPEG',
            6 => 'JPEG-LS',
            7 => 'JPEG 2000',
            8 => 'JBIG2',
        },
    },
);

# (ref fcd15444-1/2/6.pdf)
# (also see http://developer.apple.com/mac/library/documentation/QuickTime/QTFF/QTFFChap1/qtff1.html)
%Image::ExifTool::Jpeg2000::FileType = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 2 => 'Video' },
    FORMAT => 'int32u',
    0 => {
        Name => 'MajorBrand',
        Format => 'undef[4]',
        PrintConv => {
            'jp2 ' => 'JPEG 2000 Image (.JP2)',           # image/jp2
            'jpm ' => 'JPEG 2000 Compound Image (.JPM)',  # image/jpm
            'jpx ' => 'JPEG 2000 with extensions (.JPX)', # image/jpx
        },
    },
    1 => {
        Name => 'MinorVersion',
        Format => 'undef[4]',
        ValueConv => 'sprintf("%x.%x.%x", unpack("nCC", $val))',
    },
    2 => {
        Name => 'CompatibleBrands',
        Format => 'undef[$size-8]',
        # ignore any entry with a null, and return others as a list
        ValueConv => 'my @a=($val=~/.{4}/sg); @a=grep(!/\0/,@a); \@a', 
    },
);

%Image::ExifTool::Jpeg2000::CaptureResolution = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 2 => 'Image' },
    FORMAT => 'int8s',
    0 => {
        Name => 'CaptureYResolution',
        Format => 'rational32u',
    },
    4 => {
        Name => 'CaptureXResolution',
        Format => 'rational32u',
    },
    8 => {
        Name => 'CaptureYResolutionUnit',
        SeparateTable => 'ResolutionUnit',
        PrintConv => \%resolutionUnit,
    },
    9 => {
        Name => 'CaptureXResolutionUnit',
        SeparateTable => 'ResolutionUnit',
        PrintConv => \%resolutionUnit,
    },
);

%Image::ExifTool::Jpeg2000::DisplayResolution = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 2 => 'Image' },
    FORMAT => 'int8s',
    0 => {
        Name => 'DisplayYResolution',
        Format => 'rational32u',
    },
    4 => {
        Name => 'DisplayXResolution',
        Format => 'rational32u',
    },
    8 => {
        Name => 'DisplayYResolutionUnit',
        SeparateTable => 'ResolutionUnit',
        PrintConv => \%resolutionUnit,
    },
    9 => {
        Name => 'DisplayXResolutionUnit',
        SeparateTable => 'ResolutionUnit',
        PrintConv => \%resolutionUnit,
    },
);

#------------------------------------------------------------------------------
# Create new JPEG 2000 boxes when writing
# (Currently only supports adding certain UUID boxes)
# Inputs: 0) ExifTool object ref, 1) Output file or scalar ref
# Returns: 1 on success
sub CreateNewBoxes($$)
{
    my ($exifTool, $outfile) = @_;
    my $addDirs = $$exifTool{AddJp2Dirs};
    delete $$exifTool{AddJp2Dirs};
    my $dirName;
    foreach $dirName (sort keys %$addDirs) {
        next unless $uuid{$dirName};
        my $tagInfo;
        foreach $tagInfo (@{$Image::ExifTool::Jpeg2000::Main{uuid}}) {
            next unless $$tagInfo{Name} eq $dirName;
            my $subdir = $$tagInfo{SubDirectory};
            my $tagTable = GetTagTable($$subdir{TagTable});
            my %dirInfo = (
                DirName => $$subdir{DirName} || $dirName,
                Parent => 'JP2',
            );
            my $newdir = $exifTool->WriteDirectory(\%dirInfo, $tagTable, $$subdir{WriteProc});
            if (defined $newdir and length $newdir) {
                my $boxhdr = pack('N', length($newdir) + 24) . 'uuid' . $uuid{$dirName};
                Write($outfile, $boxhdr, $newdir) or return 0;
                last;
            }
        }
    }
    return 1;
}

#------------------------------------------------------------------------------
# Process JPEG 2000 box
# Inputs: 0) ExifTool object reference, 1) dirInfo reference, 2) Pointer to tag table
# Returns: 1 on success when reading, or -1 on write error
#          (or JP2 box or undef when writing from buffer)
sub ProcessJpeg2000Box($$$)
{
    my ($exifTool, $dirInfo, $tagTablePtr) = @_;
    my $dataPt = $$dirInfo{DataPt};
    my $dataLen = $$dirInfo{DataLen};
    my $dataPos = $$dirInfo{DataPos};
    my $dirLen = $$dirInfo{DirLen} || 0;
    my $dirStart = $$dirInfo{DirStart} || 0;
    my $raf = $$dirInfo{RAF};
    my $outfile = $$dirInfo{OutFile};
    my $dirEnd = $dirStart + $dirLen;
    my ($err, $outBuff, $verbose);

    if ($outfile) {
        unless ($raf) {
            # buffer output to be used for return value
            $outBuff = '';
            $outfile = \$outBuff;
        }
    } else {
        # (must not set verbose flag when writing!)
        $verbose = $exifTool->{OPTIONS}->{Verbose};
    }
    # loop through all contained boxes
    my ($pos, $boxLen);
    for ($pos=$dirStart; ; $pos+=$boxLen) {
        my ($boxID, $buff, $valuePtr);
        if ($raf) {
            $dataPos = $raf->Tell();
            my $n = $raf->Read($buff,8);
            unless ($n == 8) {
                $n and $err = '', last;
                if ($outfile) {
                    CreateNewBoxes($exifTool, $outfile) or $err = 1;
                }
                last;
            }
            $dataPt = \$buff;
            $dirLen = 8;
            $pos = 0;
        } elsif ($pos >= $dirEnd - 8) {
            $err = '' unless $pos == $dirEnd;
            last;
        }
        $boxLen = unpack("x$pos N",$$dataPt);
        $boxID = substr($$dataPt, $pos+4, 4);
        $pos += 8;
        if ($boxLen == 1) {
            if (not $raf and $pos < $dirLen - 8) {
                $err = 'JPEG 2000 format error';
            } else {
                $err = "Can't currently handle huge JPEG 2000 boxes";
            }
            last;
        } elsif ($boxLen == 0) {
            if ($raf) {
                if ($outfile) {
                    CreateNewBoxes($exifTool, $outfile) or $err = 1;
                    # copy over the rest of the file
                    Write($outfile, $$dataPt) or $err = 1;
                    while ($raf->Read($buff, 65536)) {
                        Write($outfile, $buff) or $err = 1;
                    }
                }
                last;   # (ignore the rest of the file when reading)
            }
            $boxLen = $dirLen - $pos;
        } else {
            $boxLen -= 8;
        }
        $boxLen < 0 and $err = 'Invalid JPEG 2000 box length', last;
        my $tagInfo = $exifTool->GetTagInfo($tagTablePtr, $boxID);
        unless (defined $tagInfo or $verbose) {
            # no need to process this box
            if ($raf) {
                if ($outfile) {
                    Write($outfile, $$dataPt) or $err = 1;
                    $raf->Read($buff,$boxLen) == $boxLen or $err = '', last;
                    Write($outfile, $buff) or $err = 1;
                } else {
                    $raf->Seek($boxLen, 1) or $err = 'Seek error', last;
                }
            } elsif ($outfile) {
                Write($outfile, substr($$dataPt, $pos-8, $boxLen+8)) or $err = '', last;
            }
            next;
        }
        if ($raf) {
            # read the box data
            $dataPos = $raf->Tell();
            $raf->Read($buff,$boxLen) == $boxLen or $err = '', last;
            $valuePtr = 0;
            $dataLen = $boxLen;
        } elsif ($boxLen + $pos > $dirStart + $dirLen) {
            $err = '';
            last;
        } else {
            $valuePtr = $pos;
        }
        if (defined $tagInfo and not $tagInfo) {
            # GetTagInfo() required the value for a Condition
            my $tmpVal = substr($$dataPt, $valuePtr, $boxLen < 128 ? $boxLen : 128);
            $tagInfo = $exifTool->GetTagInfo($tagTablePtr, $boxID, \$tmpVal);
        }
        # delete all UUID boxes if deleting all information
        if ($outfile and $boxID eq 'uuid' and $exifTool->{DEL_GROUP}->{'*'}) {
            $exifTool->VPrint(0, "  Deleting $$tagInfo{Name}\n");
            ++$exifTool->{CHANGED};
            next;
        }
        if ($verbose) {
            $exifTool->VerboseInfo($boxID, $tagInfo,
                Table  => $tagTablePtr,
                DataPt => $dataPt,
                Size   => $boxLen,
                Start  => $valuePtr,
            );
            next unless $tagInfo;
        }
        if ($$tagInfo{SubDirectory}) {
            my $subdir = $$tagInfo{SubDirectory};
            my $subdirStart = $valuePtr;
            if (defined $$subdir{Start}) {
                #### eval Start ($valuePtr)
                $subdirStart = eval($$subdir{Start});
            }
            my $subdirLen = $boxLen - ($subdirStart - $valuePtr);
            my %subdirInfo = (
                Parent => 'JP2',
                DataPt => $dataPt,
                DataPos => $dataPos,
                DataLen => $dataLen,
                DirStart => $subdirStart,
                DirLen => $subdirLen,
                DirName => $$subdir{DirName} || $$tagInfo{Name},
                OutFile => $outfile,
                Base => $dataPos + $subdirStart,
            );
            my $subTable = GetTagTable($$subdir{TagTable}) || $tagTablePtr;
            if ($outfile) {
                # remove this directory from our create list
                delete $exifTool->{AddJp2Dirs}->{$$tagInfo{Name}};
                my $newdir;
                # only edit writable UUID boxes
                if ($uuid{$$tagInfo{Name}}) {
                    $newdir = $exifTool->WriteDirectory(\%subdirInfo, $subTable, $$subdir{WriteProc});
                    next if defined $newdir and not length $newdir; # next if deleting the box
                }
                # use old box data if not changed
                defined $newdir or $newdir = substr($$dataPt, $subdirStart, $subdirLen);
                my $prefixLen = $subdirStart - $valuePtr;
                my $boxhdr = pack('N', length($newdir) + 8 + $prefixLen) . $boxID;
                $boxhdr .= substr($$dataPt, $valuePtr, $prefixLen) if $prefixLen;
                Write($outfile, $boxhdr, $newdir) or $err = 1;
            } elsif (not $exifTool->ProcessDirectory(\%subdirInfo, $subTable, $$subdir{ProcessProc})) {
                if ($subTable eq $tagTablePtr) {
                    $err = 'JPEG 2000 format error';
                } else {
                    $err = "Unrecognized $$tagInfo{Name} box";
                }
                last;
            }
        } elsif ($$tagInfo{Format} and not $outfile) {
            # only save tag values if Format was specified
            my $val = ReadValue($dataPt, $valuePtr, $$tagInfo{Format}, undef, $boxLen);
            $exifTool->FoundTag($tagInfo, $val) if defined $val;
        } elsif ($outfile) {
            my $boxhdr = pack('N', $boxLen + 8) . $boxID;
            Write($outfile, $boxhdr, substr($$dataPt, $valuePtr, $boxLen)) or $err = 1;
        }
    }
    if (defined $err) {
        $err or $err = 'Truncated JPEG 2000 box';
        if ($outfile) {
            $exifTool->Error($err) unless $err eq '1';
            return $raf ? -1 : undef;
        }
        $exifTool->Warn($err);
    }
    return $outBuff if $outfile and not $raf;
    return 1;
}

#------------------------------------------------------------------------------
# Read/write meta information from a JPEG 2000 image
# Inputs: 0) ExifTool object reference, 1) dirInfo reference
# Returns: 1 on success, 0 if this wasn't a valid JPEG 2000 file, or -1 on write error
sub ProcessJP2($$)
{
    my ($exifTool, $dirInfo) = @_;
    my $raf = $$dirInfo{RAF};
    my $outfile = $$dirInfo{OutFile};
    my $hdr;

    # check to be sure this is a valid JPG2000 file
    return 0 unless $raf->Read($hdr,12) == 12;
    return 0 unless $hdr eq "\x00\x00\x00\x0cjP  \x0d\x0a\x87\x0a" or     # (ref 1)
                    $hdr eq "\x00\x00\x00\x0cjP\x1a\x1a\x0d\x0a\x87\x0a"; # (ref 2)

    if ($outfile) {
        Write($outfile, $hdr) or return -1;
        $exifTool->InitWriteDirs(\%jp2Map);
        # save list of directories to create
        my %addDirs = %{$$exifTool{ADD_DIRS}};
        $$exifTool{AddJp2Dirs} = \%addDirs;
    } else {
        my ($buff, $fileType);
        # recognize JPX and JPM as unique types of JP2
        if ($raf->Read($buff, 12) == 12 and $buff =~ /^.{4}ftyp(.{4})/s) {
            $fileType = 'JPX' if $1 eq 'jpx ';
            $fileType = 'JPM' if $1 eq 'jpm ';
        }
        $raf->Seek(-length($buff), 1) if defined $buff;
        $exifTool->SetFileType($fileType);
    }
    SetByteOrder('MM'); # JPEG 2000 files are big-endian
    my %dirInfo = (
        RAF => $raf,
        DirName => 'JP2',
        OutFile => $$dirInfo{OutFile},
    );
    my $tagTablePtr = GetTagTable('Image::ExifTool::Jpeg2000::Main');
    return $exifTool->ProcessDirectory(\%dirInfo, $tagTablePtr);
}

1;  # end

__END__

=head1 NAME

Image::ExifTool::Jpeg2000 - Read JPEG 2000 meta information

=head1 SYNOPSIS

This module is used by Image::ExifTool

=head1 DESCRIPTION

This module contains routines required by Image::ExifTool to read JPEG 2000
files.

=head1 AUTHOR

Copyright 2003-2011, Phil Harvey (phil at owl.phy.queensu.ca)

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 REFERENCES

=over 4

=item L<http://www.jpeg.org/public/fcd15444-2.pdf>

=item L<ftp://ftp.remotesensing.org/jpeg2000/fcd15444-1.pdf>

=back

=head1 SEE ALSO

L<Image::ExifTool::TagNames/Jpeg2000 Tags>,
L<Image::ExifTool(3pm)|Image::ExifTool>

=cut

