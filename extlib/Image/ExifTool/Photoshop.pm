#------------------------------------------------------------------------------
# File:         Photoshop.pm
#
# Description:  Read/write Photoshop IRB meta information
#
# Revisions:    02/06/2004 - P. Harvey Created
#               02/25/2004 - P. Harvey Added hack for problem with old photoshops
#               10/04/2004 - P. Harvey Added a bunch of tags (ref Image::MetaData::JPEG)
#                            but left most of them commented out until I have enough
#                            information to write PrintConv routines for them to
#                            display something useful
#               07/08/2005 - P. Harvey Added support for reading PSD files
#               01/07/2006 - P. Harvey Added PSD write support
#               11/04/2006 - P. Harvey Added handling of resource name
#
# References:   1) http://www.fine-view.com/jp/lab/doc/ps6ffspecsv2.pdf
#               2) http://www.ozhiker.com/electronics/pjmt/jpeg_info/irb_jpeg_qual.html
#               3) Matt Mueller private communication (tests with PS CS2)
#               4) http://www.fileformat.info/format/psd/egff.htm
#               5) http://www.telegraphics.com.au/svn/psdparse/trunk/resources.c
#               6) http://libpsd.graphest.com/files/Photoshop%20File%20Formats.pdf
#------------------------------------------------------------------------------

package Image::ExifTool::Photoshop;

use strict;
use vars qw($VERSION $AUTOLOAD $iptcDigestInfo);
use Image::ExifTool qw(:DataAccess :Utils);

$VERSION = '1.41';

sub ProcessPhotoshop($$$);
sub WritePhotoshop($$$);

# map of where information is stored in PSD image
my %psdMap = (
    IPTC         => 'Photoshop',
    XMP          => 'Photoshop',
    EXIFInfo     => 'Photoshop',
    IFD0         => 'EXIFInfo',
    IFD1         => 'IFD0',
    ICC_Profile  => 'Photoshop',
    ExifIFD      => 'IFD0',
    GPS          => 'IFD0',
    SubIFD       => 'IFD0',
    GlobParamIFD => 'IFD0',
    PrintIM      => 'IFD0',
    InteropIFD   => 'ExifIFD',
    MakerNotes   => 'ExifIFD',
);

# Photoshop APP13 tag table
# (set Unknown flag for information we don't want to display normally)
%Image::ExifTool::Photoshop::Main = (
    GROUPS => { 2 => 'Image' },
    PROCESS_PROC => \&ProcessPhotoshop,
    WRITE_PROC => \&WritePhotoshop,
    0x03e8 => { Unknown => 1, Name => 'Photoshop2Info' },
    0x03e9 => { Unknown => 1, Name => 'MacintoshPrintInfo' },
    0x03ea => { Unknown => 1, Name => 'XMLData', Binary => 1 }, #PH
    0x03eb => { Unknown => 1, Name => 'Photoshop2ColorTable' },
    0x03ed => {
        Name => 'ResolutionInfo',
        SubDirectory => {
            TagTable => 'Image::ExifTool::Photoshop::Resolution',
        },
    },
    0x03ee => {
        Name => 'AlphaChannelsNames',
        ValueConv => 'Image::ExifTool::Photoshop::ConvertPascalString($self,$val)',
    },
    0x03ef => { Unknown => 1, Name => 'DisplayInfo' },
    0x03f0 => { Unknown => 1, Name => 'PStringCaption' },
    0x03f1 => { Unknown => 1, Name => 'BorderInformation' },
    0x03f2 => { Unknown => 1, Name => 'BackgroundColor' },
    0x03f3 => { Unknown => 1, Name => 'PrintFlags' },
    0x03f4 => { Unknown => 1, Name => 'BW_HalftoningInfo' },
    0x03f5 => { Unknown => 1, Name => 'ColorHalftoningInfo' },
    0x03f6 => { Unknown => 1, Name => 'DuotoneHalftoningInfo' },
    0x03f7 => { Unknown => 1, Name => 'BW_TransferFunc' },
    0x03f8 => { Unknown => 1, Name => 'ColorTransferFuncs' },
    0x03f9 => { Unknown => 1, Name => 'DuotoneTransferFuncs' },
    0x03fa => { Unknown => 1, Name => 'DuotoneImageInfo' },
    0x03fb => { Unknown => 1, Name => 'EffectiveBW' },
    0x03fc => { Unknown => 1, Name => 'ObsoletePhotoshopTag1' },
    0x03fd => { Unknown => 1, Name => 'EPSOptions' },
    0x03fe => { Unknown => 1, Name => 'QuickMaskInfo' },
    0x03ff => { Unknown => 1, Name => 'ObsoletePhotoshopTag2' },
    0x0400 => { Unknown => 1, Name => 'LayerStateInfo' },
    0x0401 => { Unknown => 1, Name => 'WorkingPath' },
    0x0402 => { Unknown => 1, Name => 'LayersGroupInfo' },
    0x0403 => { Unknown => 1, Name => 'ObsoletePhotoshopTag3' },
    0x0404 => {
        Name => 'IPTCData',
        SubDirectory => {
            DirName => 'IPTC',
            TagTable => 'Image::ExifTool::IPTC::Main',
        },
    },
    0x0405 => { Unknown => 1, Name => 'RawImageMode' },
    0x0406 => { #2
        Name => 'JPEG_Quality',
        SubDirectory => {
            TagTable => 'Image::ExifTool::Photoshop::JPEG_Quality',
        },
    },
    0x0408 => { Unknown => 1, Name => 'GridGuidesInfo' },
    0x0409 => {
        Name => 'PhotoshopBGRThumbnail',
        Notes => 'this is a JPEG image, but in BGR format instead of RGB',
        RawConv => 'my $img=substr($val,0x1c);$self->ValidateImage(\$img,$tag)',
    },
    0x040a => {
        Name => 'CopyrightFlag',
        Writable => 'int8u',
        Groups => { 2 => 'Author' },
        ValueConv => 'join(" ",unpack("C*", $val))',
        ValueConvInv => 'pack("C*",split(" ",$val))',
        PrintConv => { #3
            0 => 'False',
            1 => 'True',
        },
    },
    0x040b => {
        Name => 'URL',
        Writable => 'string',
        Groups => { 2 => 'Author' },
    },
    0x040c => {
        Name => 'PhotoshopThumbnail',
        RawConv => 'my $img=substr($val,0x1c);$self->ValidateImage(\$img,$tag)',
    },
    0x040d => {
        Name => 'GlobalAngle',
        Writable => 'int32u',
        ValueConv => 'unpack("N",$val)',
        ValueConvInv => 'pack("N",$val)',
    },
    0x040e => { Unknown => 1, Name => 'ColorSamplersResource' },
    0x040f => {
        Name => 'ICC_Profile',
        SubDirectory => {
            TagTable => 'Image::ExifTool::ICC_Profile::Main',
        },
    },
    0x0410 => { Unknown => 1, Name => 'Watermark' },
    0x0411 => { Unknown => 1, Name => 'ICC_Untagged' },
    0x0412 => { Unknown => 1, Name => 'EffectsVisible' },
    0x0413 => { Unknown => 1, Name => 'SpotHalftone' },
    0x0414 => { Unknown => 1, Name => 'IDsBaseValue', Description => 'IDs Base Value' },
    0x0415 => { Unknown => 1, Name => 'UnicodeAlphaNames' },
    0x0416 => { Unknown => 1, Name => 'IndexedColourTableCount' },
    0x0417 => { Unknown => 1, Name => 'TransparentIndex' },
    0x0419 => {
        Name => 'GlobalAltitude',
        Writable => 'int32u',
        ValueConv => 'unpack("N",$val)',
        ValueConvInv => 'pack("N",$val)',
    },
    0x041a => { Unknown => 1, Name => 'Slices' },
    0x041b => { Unknown => 1, Name => 'WorkflowURL' },
    0x041c => { Unknown => 1, Name => 'JumpToXPEP' },
    0x041d => { Unknown => 1, Name => 'AlphaIdentifiers' },
    0x041e => { Unknown => 1, Name => 'URL_List' },
    0x0421 => { Unknown => 1, Name => 'VersionInfo' },
    0x0422 => {
        Name => 'EXIFInfo', #PH (Found in EPS and PSD files)
        SubDirectory => {
            TagTable=> 'Image::ExifTool::Exif::Main',
            ProcessProc => \&Image::ExifTool::ProcessTIFF,
            WriteProc => \&Image::ExifTool::WriteTIFF,
        },
    },
    0x0423 => { Unknown => 1, Name => 'ExifInfo2', Binary => 1 }, #5
    0x0424 => {
        Name => 'XMP',
        SubDirectory => {
            TagTable => 'Image::ExifTool::XMP::Main',
        },
    },
    0x0425 => {
        Name => 'IPTCDigest',
        Writable => 'string',
        Protected => 1,
        Notes => q{
            this tag indicates provides a way for XMP-aware applications to indicate
            that the XMP is synchronized with the IPTC.  When writing, special values of
            "new" and "old" represent the digests of the IPTC from the edited and
            original files respectively, and are undefined if the IPTC does not exist in
            the respective file.  Set this to "new" as an indication that the XMP is
            synchronized with the IPTC
        },
        # also note the 'new' feature requires that the IPTC comes before this tag is written
        ValueConv => 'unpack("H*", $val)',
        ValueConvInv => q{
            if (lc($val) eq 'new' or lc($val) eq 'old') {
                {
                    local $SIG{'__WARN__'} = sub { };
                    return lc($val) if eval 'require Digest::MD5';
                }
                warn "Digest::MD5 must be installed\n";
                return undef;
            }
            return pack('H*', $val) if $val =~ /^[0-9a-f]{32}$/i;
            warn "Value must be 'new', 'old' or 32 hexadecimal digits\n";
            return undef;
        }
    },
    0x0426 => { Unknown => 1, Name => 'PrintScale' }, #5
    0x0428 => { Unknown => 1, Name => 'PixelAspectRatio' }, #5
    0x0429 => { Unknown => 1, Name => 'LayerComps' }, #5
    0x042a => { Unknown => 1, Name => 'AlternateDuotoneColors' }, #5
    0x042b => { Unknown => 1, Name => 'AlternateSpotColors' }, #5
    # 0x07d0-0x0bb6 Path information
    0x0bb7 => {
        Name => 'ClippingPathName',
        # convert from a Pascal string (ignoring 6 bytes of unknown data after string)
        ValueConv => q{
            my $len = ord($val);
            $val = substr($val, 0, $len+1) if $len < length($val);
            return Image::ExifTool::Photoshop::ConvertPascalString($self,$val);
        },
    },
    0x2710 => { Unknown => 1, Name => 'PrintFlagsInfo' },
);

# Photoshop JPEG quality record (ref 2)
%Image::ExifTool::Photoshop::JPEG_Quality = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    WRITE_PROC => \&Image::ExifTool::WriteBinaryData,
    CHECK_PROC => \&Image::ExifTool::CheckBinaryData,
    FORMAT => 'int16s',
    GROUPS => { 2 => 'Image' },
    0 => {
        Name => 'PhotoshopQuality',
        Writable => 1,
        PrintConv => '$val + 4',
        PrintConvInv => '$val - 4',
    },
    1 => {
        Name => 'PhotoshopFormat',
        PrintConv => {
            0x0000 => 'Standard',
            0x0001 => 'Optimised',
            0x0101 => 'Progressive',
        },
    },
    2 => {
        Name => 'ProgressiveScans',
        PrintConv => {
            1 => '3 Scans',
            2 => '4 Scans',
            3 => '5 Scans',
        },
    },
);

# Photoshop resolution information #PH
%Image::ExifTool::Photoshop::Resolution = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    WRITE_PROC => \&Image::ExifTool::WriteBinaryData,
    CHECK_PROC => \&Image::ExifTool::CheckBinaryData,
    FORMAT => 'int16u',
    FIRST_ENTRY => 0,
    WRITABLE => 1,
    GROUPS => { 2 => 'Image' },
    0 => {
        Name => 'XResolution',
        Format => 'int32u',
        Priority => 0,
        ValueConv => '$val / 0x10000',
        ValueConvInv => 'int($val * 0x10000 + 0.5)',
        PrintConv => 'int($val * 100 + 0.5) / 100',
        PrintConvInv => '$val',
    },
    2 => {
        Name => 'DisplayedUnitsX',
        PrintConv => {
            1 => 'inches',
            2 => 'cm',
        },
    },
    4 => {
        Name => 'YResolution',
        Format => 'int32u',
        Priority => 0,
        ValueConv => '$val / 0x10000',
        ValueConvInv => 'int($val * 0x10000 + 0.5)',
        PrintConv => 'int($val * 100 + 0.5) / 100',
        PrintConvInv => '$val',
    },
    6 => {
        Name => 'DisplayedUnitsY',
        PrintConv => {
            1 => 'inches',
            2 => 'cm',
        },
    },
);

# Photoshop PSD file header
%Image::ExifTool::Photoshop::Header = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    FORMAT => 'int16u',
    GROUPS => { 2 => 'Image' },
    NOTES => 'This information is found in the PSD file header.',
    6 => 'NumChannels',
    7 => { Name => 'ImageHeight', Format => 'int32u' },
    9 => { Name => 'ImageWidth', Format => 'int32u' },
    11 => 'BitDepth',
    12 => {
        Name => 'ColorMode',
        PrintConvColumns => 2,
        PrintConv => {
            0 => 'Bitmap',
            1 => 'Grayscale',
            2 => 'Indexed',
            3 => 'RGB',
            4 => 'CMYK',
            7 => 'Multichannel',
            8 => 'Duotone',
            9 => 'Lab',
        },
    },
);

# tags for unknown resource types
%Image::ExifTool::Photoshop::Unknown = (
    GROUPS => { 2 => 'Unknown' },
);

# define reference to IPTCDigest tagInfo hash for convenience
$iptcDigestInfo = $Image::ExifTool::Photoshop::Main{0x0425};


#------------------------------------------------------------------------------
# AutoLoad our writer routines when necessary
#
sub AUTOLOAD
{
    return Image::ExifTool::DoAutoLoad($AUTOLOAD, @_);
}

#------------------------------------------------------------------------------
# Convert pascal string(s) to something we can use
# Inputs: 1) Pascal string data
# Returns: Strings, concatenated with ', '
sub ConvertPascalString($$)
{
    my ($exifTool, $inStr) = @_;
    my $outStr = '';
    my $len = length($inStr);
    my $i=0;
    while ($i < $len) {
        my $n = ord(substr($inStr, $i, 1));
        last if $i + $n >= $len;
        $i and $outStr .= ', ';
        $outStr .= substr($inStr, $i+1, $n);
        $i += $n + 1;
    }
    my $charset = $exifTool->Options('CharsetPhotoshop') || 'Latin';
    return $exifTool->Decode($outStr, $charset);
}

#------------------------------------------------------------------------------
# Process Photoshop APP13 record
# Inputs: 0) ExifTool object reference, 1) Reference to directory information
#         2) Tag table reference
# Returns: 1 on success
sub ProcessPhotoshop($$$)
{
    my ($exifTool, $dirInfo, $tagTablePtr) = @_;
    my $dataPt = $$dirInfo{DataPt};
    my $pos = $$dirInfo{DirStart};
    my $dirEnd = $pos + $$dirInfo{DirLen};
    my $verbose = $exifTool->Options('Verbose');
    my $success = 0;

    SetByteOrder('MM');     # Photoshop is always big-endian
    $verbose and $exifTool->VerboseDir('Photoshop', 0, $$dirInfo{DirLen});

    # scan through resource blocks:
    # Format: 0) Type, 4 bytes - '8BIM' (or the rare 'PHUT', 'DCSR' or 'AgHg')
    #         1) TagID,2 bytes
    #         2) Name, pascal string padded to even no. bytes
    #         3) Size, 4 bytes - N
    #         4) Data, N bytes
    while ($pos + 8 < $dirEnd) {
        my $type = substr($$dataPt, $pos, 4);
        my ($ttPtr, $extra, $val, $name);
        if ($type eq '8BIM') {
            $ttPtr = $tagTablePtr;
        } elsif ($type =~ /^(PHUT|DCSR|AgHg)$/) {
            $ttPtr = GetTagTable('Image::ExifTool::Photoshop::Unknown');
        } else {
            $type =~ s/([^\w])/sprintf("\\x%.2x",ord($1))/ge;
            $exifTool->Warn(qq{Bad Photoshop IRB resource "$type"});
            last;
        }
        my $tag = Get16u($dataPt, $pos + 4);
        $pos += 6;  # point to start of name
        my $nameLen = Get8u($dataPt, $pos);
        my $namePos = ++$pos;
        # skip resource block name (pascal string, padded to an even # of bytes)
        $pos += $nameLen;
        ++$pos unless $nameLen & 0x01;
        if ($pos + 4 > $dirEnd) {
            $exifTool->Warn("Bad Photoshop resource block");
            last;
        }
        my $size = Get32u($dataPt, $pos);
        $pos += 4;
        if ($size + $pos > $dirEnd) {
            $exifTool->Warn("Bad Photoshop resource data size $size");
            last;
        }
        $success = 1;
        if ($nameLen) {
            $name = substr($$dataPt, $namePos, $nameLen);
            $extra = qq{, Name="$name"};
        } else {
            $name = '';
        }
        my $tagInfo = $exifTool->GetTagInfo($ttPtr, $tag);
        # append resource name to value if requested (braced by "/#...#/")
        if ($tagInfo and defined $$tagInfo{SetResourceName} and
            $$tagInfo{SetResourceName} eq '1' and $name !~ m{/#})
        {
            $val = substr($$dataPt, $pos, $size) . '/#' . $name . '#/';
        }
        $exifTool->HandleTag($ttPtr, $tag, $val,
            TagInfo => $tagInfo,
            Extra   => $extra,
            DataPt  => $dataPt,
            DataPos => $$dirInfo{DataPos},
            Size    => $size,
            Start   => $pos,
            Parent  => $$dirInfo{DirName},
        );
        $size += 1 if $size & 0x01; # size is padded to an even # bytes
        $pos += $size;
    }
    return $success;
}

#------------------------------------------------------------------------------
# extract information from Photoshop PSD file
# Inputs: 0) ExifTool object reference, 1) dirInfo reference
# Returns: 1 if this was a valid PSD file, -1 on write error
sub ProcessPSD($$)
{
    my ($exifTool, $dirInfo) = @_;
    my $raf = $$dirInfo{RAF};
    my $outfile = $$dirInfo{OutFile};
    my ($data, $err, $tagTablePtr);

    $raf->Read($data, 30) == 30 or return 0;
    $data =~ /^8BPS\0([\x01\x02])/ or return 0;
    SetByteOrder('MM');
    $exifTool->SetFileType($1 eq "\x01" ? 'PSD' : 'PSB'); # set the FileType tag
    my %dirInfo = (
        DataPt => \$data,
        DirStart => 0,
        DirName => 'Photoshop',
    );
    my $len = Get32u(\$data, 26);
    if ($outfile) {
        Write($outfile, $data) or $err = 1;
        $raf->Read($data, $len) == $len or return -1;
        Write($outfile, $data) or $err = 1; # write color mode data
        # initialize map of where things are written
        $exifTool->InitWriteDirs(\%psdMap);
    } else {
        # process the header
        $tagTablePtr = GetTagTable('Image::ExifTool::Photoshop::Header');
        $dirInfo{DirLen} = 30;
        $exifTool->ProcessDirectory(\%dirInfo, $tagTablePtr);
        $raf->Seek($len, 1) or $err = 1;    # skip over color mode data
    }
    $raf->Read($data, 4) == 4 or $err = 1;
    $len = Get32u(\$data, 0);
    $raf->Read($data, $len) == $len or $err = 1;
    $tagTablePtr = GetTagTable('Image::ExifTool::Photoshop::Main');
    $dirInfo{DirLen} = $len;
    my $rtnVal = 1;
    if ($outfile) {
        # rewrite IRB resources
        $data = WritePhotoshop($exifTool, \%dirInfo, $tagTablePtr);
        if ($data) {
            $len = Set32u(length $data);
            Write($outfile, $len, $data) or $err = 1;
            # look for trailer and edit if necessary
            my $trailInfo = Image::ExifTool::IdentifyTrailer($raf);
            if ($trailInfo) {
                my $tbuf = '';
                $$trailInfo{OutFile} = \$tbuf;  # rewrite trailer(s)
                # rewrite all trailers to buffer
                if ($exifTool->ProcessTrailers($trailInfo)) {
                    my $copyBytes = $$trailInfo{DataPos} - $raf->Tell();
                    if ($copyBytes >= 0) {
                        # copy remaining PSD file up to start of trailer
                        while ($copyBytes) {
                            my $n = ($copyBytes > 65536) ? 65536 : $copyBytes;
                            $raf->Read($data, $n) == $n or $err = 1;
                            Write($outfile, $data) or $err = 1;
                            $copyBytes -= $n;
                        }
                        # write the trailer (or not)
                        $exifTool->WriteTrailerBuffer($trailInfo, $outfile) or $err = 1;
                    } else {
                        $exifTool->Warn('Overlapping trailer');
                        undef $trailInfo;
                    }
                } else {
                    undef $trailInfo;
                }
            }
            unless ($trailInfo) {
                # copy over the rest of the file
                while ($raf->Read($data, 65536)) {
                    Write($outfile, $data) or $err = 1;
                }
            }
        } else {
            $err = 1;
        }
        $rtnVal = -1 if $err;
    } elsif ($err) {
        $exifTool->Warn('File format error');
    } else {
        ProcessPhotoshop($exifTool, \%dirInfo, $tagTablePtr);
        # process trailers if they exist
        my $trailInfo = Image::ExifTool::IdentifyTrailer($raf);
        $exifTool->ProcessTrailers($trailInfo) if $trailInfo;
    }
    return $rtnVal;
}

1; # end


__END__

=head1 NAME

Image::ExifTool::Photoshop - Read/write Photoshop IRB meta information

=head1 SYNOPSIS

This module is loaded automatically by Image::ExifTool when required.

=head1 DESCRIPTION

Photoshop writes its own format of meta information called a Photoshop IRB
resource which is located in the APP13 record of JPEG files.  This module
contains the definitions to read this information.

=head1 NOTES

Photoshop IRB blocks may have an associated resource name.  These names are
usually just an empty string, but if not empty they are displayed in the
verbose level 2 (or greater) output.  A special C<SetResourceName> flag may
be set to '1' in the tag information hash to cause the resource name to be
appended to the value when extracted.  If this is done, the returned value
has the form "VALUE/#NAME#/".  When writing, the writer routine looks for
this syntax (if C<SetResourceName> is defined), and and uses the embedded
name to set the name of the new resource.  This allows the resource names to
be preserved when copying Photoshop information via user-defined tags.

=head1 AUTHOR

Copyright 2003-2013, Phil Harvey (phil at owl.phy.queensu.ca)

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 REFERENCES

=over 4

=item L<http://www.fine-view.com/jp/lab/doc/ps6ffspecsv2.pdf>

=item L<http://www.ozhiker.com/electronics/pjmt/jpeg_info/irb_jpeg_qual.html>

=item L<http://www.fileformat.info/format/psd/egff.htm>

=item L<http://libpsd.graphest.com/files/Photoshop%20File%20Formats.pdf>

=back

=head1 SEE ALSO

L<Image::ExifTool::TagNames/Photoshop Tags>,
L<Image::ExifTool(3pm)|Image::ExifTool>,
L<Image::MetaData::JPEG(3pm)|Image::MetaData::JPEG>

=cut
