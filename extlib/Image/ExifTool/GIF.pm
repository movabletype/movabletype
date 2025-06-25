#------------------------------------------------------------------------------
# File:         GIF.pm
#
# Description:  Read and write GIF meta information
#
# Revisions:    10/18/2005 - P. Harvey Separated from ExifTool.pm
#               05/23/2008 - P. Harvey Added ability to read/write XMP
#               10/28/2011 - P. Harvey Added ability to read/write ICC_Profile
#
# References:   1) http://www.w3.org/Graphics/GIF/spec-gif89a.txt
#               2) http://www.adobe.com/devnet/xmp/
#               3) http://graphcomp.com/info/specs/ani_gif.html
#               4) http://www.color.org/icc_specs2.html
#               5) http://www.midiox.com/mmgif.htm
#------------------------------------------------------------------------------

package Image::ExifTool::GIF;

use strict;
use vars qw($VERSION);
use Image::ExifTool qw(:DataAccess :Utils);

$VERSION = '1.21';

# road map of directory locations in GIF images
my %gifMap = (
    XMP         => 'GIF',
    ICC_Profile => 'GIF',
);

# application extensions that we can write, and the order they are written
my @appExtensions = ( 'XMP Data/XMP', 'ICCRGBG1/012' );

%Image::ExifTool::GIF::Main = (
    GROUPS => { 2 => 'Image' },
    VARS => { NO_ID => 1 },
    NOTES => q{
        This table lists information extracted from GIF images. See
        L<http://www.w3.org/Graphics/GIF/spec-gif89a.txt> for the official GIF89a
        specification.
    },
    GIFVersion => { },
    FrameCount => { Notes => 'number of animated images' },
    Text       => { Notes => 'text displayed in image' },
    Comment    => {
        # for documentation only -- flag as writable for the docs, but
        # it won't appear in the TagLookup because there is no WRITE_PROC
        Writable => 2,
    },
    Duration   => {
        Notes => 'duration of a single animation iteration',
        PrintConv => 'sprintf("%.2f s",$val)',
    },
    ScreenDescriptor => {
        SubDirectory => { TagTable => 'Image::ExifTool::GIF::Screen' },
    },
    Extensions => { # (for documentation only)
        SubDirectory => { TagTable => 'Image::ExifTool::GIF::Extensions' },
    },
    TransparentColor => { },
);

# GIF89a application extensions:
%Image::ExifTool::GIF::Extensions = (
    GROUPS => { 2 => 'Image' },
    NOTES => 'Tags extracted from GIF89a application extensions.',
    WRITE_PROC => sub { return 1 }, # (dummy proc to facilitate writable directories)
    'NETSCAPE/2.0' => { #3
        Name => 'Animation',
        SubDirectory => { TagTable => 'Image::ExifTool::GIF::Animation' },
    },
    'XMP Data/XMP' => { #2
        Name => 'XMP',
        # IncludeLengthBytes indicates the length bytes are part of the data value...
        #  undef = data may contain nulls and is split into 255-byte blocks
        #  1 = data may not contain nulls and is not split; NULL padding is added as necessary
        #  2 = data is not split and may be edited in place; 257-byte landing zone is added
        #  (Terminator may be specified for a value of 1 above, but must be specified for 2)
        IncludeLengthBytes => 2,
        Terminator => q(<\\?xpacket end=['"][wr]['"]\\?>), # (regex to match end of valid data)
        Writable => 2,  # (writable directory!)
        SubDirectory => { TagTable => 'Image::ExifTool::XMP::Main' },
    },
    'ICCRGBG1/012' => { #4
        Name => 'ICC_Profile',
        Writable => 2,  # (writable directory!)
        SubDirectory => { TagTable => 'Image::ExifTool::ICC_Profile::Main' },
    },
    'MIDICTRL/Jon' => { #5
        Name => 'MIDIControl',
        SubDirectory => { TagTable => 'Image::ExifTool::GIF::MIDIControl' },
    },
    'MIDISONG/Dm7' => { #5
        Name => 'MIDISong',
        Groups => { 2 => 'Audio' },
        Binary => 1,
    },
    'C2PA_GIF/' => { #https://c2pa.org/specifications/ (NC) (authentication code is 0x010000 binary, so removed from tag ID)
        Name => 'JUMBF',
        SubDirectory => { TagTable => 'Image::ExifTool::Jpeg2000::Main' },
    },
);

# GIF locical screen descriptor
%Image::ExifTool::GIF::Screen = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 2 => 'Image' },
    NOTES => 'Information extracted from the GIF logical screen descriptor.',
    0 => {
        Name => 'ImageWidth',
        Format => 'int16u',
    },
    2 => {
        Name => 'ImageHeight',
        Format => 'int16u',
    },
    4.1 => {
        Name => 'HasColorMap',
        Mask => 0x80,
        PrintConv => { 0 => 'No', 1 => 'Yes' },
    },
    4.2 => {
        Name => 'ColorResolutionDepth',
        Mask => 0x70,
        ValueConv => '$val + 1',
    },
    4.3 => {
        Name => 'BitsPerPixel',
        Mask => 0x07,
        ValueConv => '$val + 1',
    },
    5 => 'BackgroundColor',
    6 => {
        Name => 'PixelAspectRatio',
        RawConv => '$val ? $val : undef',
        ValueConv => '($val + 15) / 64',
    },
);

# GIF Netscape 2.0 animation extension (ref 3)
%Image::ExifTool::GIF::Animation = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 2 => 'Image' },
    NOTES => 'Information extracted from the "NETSCAPE2.0" animation extension.',
    1 => {
        Name => 'AnimationIterations',
        Format => 'int16u',
        PrintConv => '$val ? $val : "Infinite"',
    },
);

# GIF MIDICTRL extension (ref 5)
%Image::ExifTool::GIF::MIDIControl = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 2 => 'Audio' },
    NOTES => 'Information extracted from the MIDI control block extension.',
    0 => 'MIDIControlVersion',
    1 => 'SequenceNumber',
    2 => 'MelodicPolyphony',
    3 => 'PercussivePolyphony',
    4 => {
        Name => 'ChannelUsage',
        Format => 'int16u',
        PrintConv => 'sprintf("0x%.4x", $val)',
    },
    6 => {
        Name => 'DelayTime',
        Format => 'int16u',
        ValueConv => '$val / 100',
        PrintConv => '$val . " s"',
    },
);

#------------------------------------------------------------------------------
# Read/write meta information in GIF image
# Inputs: 0) ExifTool object reference, 1) Directory information ref
# Returns: 1 on success, 0 if this wasn't a valid GIF file, or -1 if
#          an output file was specified and a write error occurred
sub ProcessGIF($$)
{
    my ($et, $dirInfo) = @_;
    my $outfile = $$dirInfo{OutFile};
    my $raf = $$dirInfo{RAF};
    my $verbose = $et->Options('Verbose');
    my $out = $et->Options('TextOut');
    my ($a, $s, $ch, $length, $buff);
    my ($err, $newComment, $setComment, $nvComment, $newExt);
    my ($addDirs, %doneDir);
    my ($frameCount, $delayTime) = (0, 0);

    # verify this is a valid GIF file
    return 0 unless $raf->Read($buff, 6) == 6
        and $buff =~ /^GIF(8[79]a)$/
        and $raf->Read($s, 7) == 7;

    my $ver = $1;
    my $rtnVal = 0;
    my $tagTablePtr = GetTagTable('Image::ExifTool::GIF::Main');
    my $extTable = GetTagTable('Image::ExifTool::GIF::Extensions');
    SetByteOrder('II');

    if ($outfile) {
        # add any user-defined writable app extensions to the list
        my $ext;
        foreach $ext (sort keys %$extTable) {
            next unless ref $$extTable{$ext} eq 'HASH';
            my $extInfo = $$extTable{$ext};
            next unless $$extInfo{SubDirectory} and $$extInfo{Writable} and not $gifMap{$$extInfo{Name}};
            $gifMap{$$extInfo{Name}} = 'GIF';
            push @appExtensions, $ext;
        }
        $et->InitWriteDirs(\%gifMap, 'XMP'); # make XMP the preferred group for GIF
        $addDirs = $$et{ADD_DIRS};
        # determine if we are editing the File:Comment tag
        my $delGroup = $$et{DEL_GROUP};
        $newComment = $et->GetNewValue('Comment', \$nvComment);
        $setComment = 1 if $nvComment or $$delGroup{File};
        # change to GIF 89a if adding comment, XMP or ICC_Profile
        $buff = 'GIF89a' if %$addDirs or defined $newComment;
        Write($outfile, $buff, $s) or $err = 1;
        $newExt = $et->GetNewTagInfoHash($extTable);
    } else {
        $et->SetFileType();   # set file type
        $et->HandleTag($tagTablePtr, 'GIFVersion', $ver);
        $et->HandleTag($tagTablePtr, 'ScreenDescriptor', $s);
    }
    my $flags = Get8u(\$s, 4);
    if ($flags & 0x80) { # does this image contain a color table?
        # calculate color table size
        $length = 3 * (2 << ($flags & 0x07));
        $raf->Read($buff, $length) == $length or return 0; # skip color table
        Write($outfile, $buff) or $err = 1 if $outfile;
    }
#
# loop through GIF blocks
#
Block:
    for (;;) {
        last unless $raf->Read($ch, 1);
        # write out any new metadata now if this isn't an extension block
        if ($outfile and ord($ch) != 0x21) {
            # write the comment first if necessary
            if (defined $newComment and $$nvComment{IsCreating}) {
                # write comment marker
                Write($outfile, "\x21\xfe") or $err = 1;
                $verbose and print $out "  + Comment = $newComment\n";
                my $len = length($newComment);
                # write out the comment in 255-byte chunks, each
                # chunk beginning with a length byte
                my $n;
                for ($n=0; $n<$len; $n+=255) {
                    my $size = $len - $n;
                    $size > 255 and $size = 255;
                    my $str = substr($newComment,$n,$size);
                    Write($outfile, pack('C',$size), $str) or $err = 1;
                }
                Write($outfile, "\0") or $err = 1;  # empty chunk as terminator
                undef $newComment;
                undef $nvComment;   # delete any other extraneous comments
                ++$$et{CHANGED};    # increment file changed flag
            }
            # add application extensions if necessary
            my $ext;
            my @new = sort keys %$newExt;
            foreach $ext (@appExtensions, @new) {
                my $extInfo = $$extTable{$ext};
                my $name = $$extInfo{Name};
                if ($$newExt{$ext}) {
                    delete $$newExt{$ext};
                    $doneDir{$name} = 1;    # (we wrote this as a block instead)
                    $buff = $et->GetNewValue($extInfo);
                    $et->VerboseValue("+ GIF:$name", $buff);
                } elsif (exists $$addDirs{$name} and not defined $doneDir{$name}) {
                    $doneDir{$name} = 1;
                    my $tbl = GetTagTable($$extInfo{SubDirectory}{TagTable});
                    my %dirInfo = ( Parent => 'GIF' );
                    $verbose and print $out "Creating $name application extension block:\n";
                    $buff = $et->WriteDirectory(\%dirInfo, $tbl);
                } else {
                    next;
                }
                if (defined $buff and length $buff) {
                    ++$$et{CHANGED};
                    Write($outfile, "\x21\xff\x0b", substr($ext,0,8), substr($ext,9,3)) or $err = 1;
                    my $pos = 0;
                    if (not $$extTable{$ext}{IncludeLengthBytes}) {
                        my $len = length $buff;
                        while ($pos < length $buff) {
                            my $n = length($buff) - $pos;
                            $n = 255 if $n > 255;
                            Write($outfile, chr($n), substr($buff, $pos, $n)) or $err = 1;
                            $pos += $n;
                        }
                        Write($outfile, "\0") or $err = 1;  # write null terminator
                    } elsif ($$extTable{$ext}{IncludeLengthBytes} < 2) {
                        $pos += ord(substr($buff,$pos,1)) + 1 while $pos < length $buff;
                        # write data, null padding and terminator
                        Write($outfile, $buff, "\0" x ($pos - length($buff) + 1)) or $err = 1;
                    } else {
                        # write data, landing zone and null terminator
                        Write($outfile, $buff, pack('C*',1,reverse(0..255),0)) or $err = 1;
                    }
                    ++$doneDir{$name};  # set to 2 to indicate we added it
                } else {
                    $verbose and print $out "  -> no $name to add\n";
                }
            }
        }
        if (ord($ch) == 0x2c) {
            ++$frameCount;
            Write($outfile, $ch) or $err = 1 if $outfile;
            # image descriptor
            last unless $raf->Read($buff, 8) == 8 and $raf->Read($ch, 1);
            Write($outfile, $buff, $ch) or $err = 1 if $outfile;
            if ($verbose and not $outfile) {
                my ($left, $top, $w, $h) = unpack('v*', $buff);
                print $out "Image: left=$left top=$top width=$w height=$h\n";
            }
            if (ord($ch) & 0x80) { # does color table exist?
                $length = 3 * (2 << (ord($ch) & 0x07));
                # skip the color table
                last unless $raf->Read($buff, $length) == $length;
                Write($outfile, $buff) or $err = 1 if $outfile;
            }
            # skip "LZW Minimum Code Size" byte
            last unless $raf->Read($buff, 1);
            Write($outfile,$buff) or $err = 1 if $outfile;
            # skip image blocks
            for (;;) {
                last unless $raf->Read($ch, 1);
                Write($outfile, $ch) or $err = 1 if $outfile;
                last unless ord($ch);
                last unless $raf->Read($buff, ord($ch));
                Write($outfile,$buff) or $err = 1 if $outfile;
            }
            next;  # continue with next field
        }
#               last if ord($ch) == 0x3b;  # normal end of GIF marker
        unless (ord($ch) == 0x21) {
            if ($outfile) {
                Write($outfile, $ch) or $err = 1;
                # copy the rest of the file
                while ($raf->Read($buff, 65536)) {
                    Write($outfile, $buff) or $err = 1;
                }
            }
            $rtnVal = 1;
            last;
        }
        # get extension block type/size
        last unless $raf->Read($s, 2) == 2;
        # get marker and block size
        ($a,$length) = unpack("C"x2, $s);

        if ($a == 0xfe) {                           # comment extension

            my $comment = '';
            while ($length) {
                last unless $raf->Read($buff, $length) == $length;
                $et->VerboseDump(\$buff) unless $outfile;
                # add buffer to comment string
                $comment .= $buff;
                last unless $raf->Read($ch, 1);  # read next block header
                $length = ord($ch);  # get next block size
            }
            last if $length;    # was a read error if length isn't zero
            if ($outfile) {
                my $isOverwriting;
                if ($setComment) {
                    if ($nvComment) {
                        $isOverwriting = $et->IsOverwriting($nvComment,$comment);
                        # get new comment again (may have been shifted)
                        $newComment = $et->GetNewValue($nvComment) if defined $newComment;
                    } else {
                        # group delete, or deleting additional comments after writing one
                        $isOverwriting = 1;
                    }
                }
                if ($isOverwriting) {
                    ++$$et{CHANGED};     # increment file changed flag
                    $et->VerboseValue('- GIF:Comment', $comment);
                    $comment = $newComment;
                    $et->VerboseValue('+ GIF:Comment', $comment) if defined $comment;
                    undef $nvComment;   # just delete remaining comments
                } else {
                    undef $setComment;  # leave remaining comments alone
                }
                if (defined $comment) {
                    # write comment marker
                    Write($outfile, "\x21\xfe") or $err = 1;
                    my $len = length($comment);
                    # write out the comment in 255-byte chunks, each
                    # chunk beginning with a length byte
                    my $n;
                    for ($n=0; $n<$len; $n+=255) {
                        my $size = $len - $n;
                        $size > 255 and $size = 255;
                        my $str = substr($comment,$n,$size);
                        Write($outfile, pack('C',$size), $str) or $err = 1;
                    }
                    Write($outfile, "\0") or $err = 1;  # empty chunk as terminator
                }
                undef $newComment;  # don't write the new comment again
            } else {
                $rtnVal = 1;
                $et->FoundTag('Comment', $comment) if $comment;
                undef $comment;
                # assume no more than one comment in FastScan mode
                last if $et->Options('FastScan');
            }
            next;

        } elsif ($a == 0xff and $length == 0x0b) {  # application extension

            last unless $raf->Read($buff, $length) == $length;
            my $hdr = "$ch$s$buff";
            # add "/" for readability
            my $tag = substr($buff, 0, 8) . '/' . substr($buff, 8);
            $tag =~ tr/\0-\x1f//d;   # remove nulls and control characters
            $verbose and print $out "Application Extension: $tag\n";

            my $extInfo = $$extTable{$tag};
            my ($subdir, $inclLen, $justCopy, $name);
            if ($extInfo) {
                if ($outfile and $$newExt{$$extInfo{TagID}}) {
                    delete $$newExt{$$extInfo{TagID}};  # don't create again
                    # (write as a block -- don't define $subdir)
                } else {
                    $subdir = $$extInfo{SubDirectory};
                }
                $inclLen = $$extInfo{IncludeLengthBytes};
                $name = $$extInfo{Name};
                # rewrite as-is unless this is a writable
                $justCopy = 1 if $outfile and not $$extInfo{Writable};
            } else {
                $justCopy = 1 if $outfile;
            }
            Write($outfile, $hdr) or $err = 1 if $justCopy;

            # read the extension data
            my $dat = '';
            for (;;) {
                $raf->Read($ch, 1) or last Block;   # read next block header
                $length = ord($ch) or last;         # get next block size
                $raf->Read($buff, $length) == $length or last Block;
                Write($outfile, $ch, $buff) or $err = 1 if $justCopy;
                $dat .= $inclLen ? $ch . $buff : $buff;
            }
            if ($justCopy) {
                Write($outfile, "\0") or $err = 1;
                next;
            } elsif ($inclLen) {
                # remove landing zone or padding
                if ($$extInfo{Terminator} and $dat =~ /$$extInfo{Terminator}/g) {
                    $dat = substr($dat, 0, pos($dat));
                } elsif ($dat =~ /\0/g) {
                    $dat = substr($dat, 0, pos($dat) - 1);
                }
            }
            if ($subdir) {
                my %dirInfo = (
                    DataPt  => \$dat,
                    DataLen => length $dat,
                    DirLen  => length $dat,
                    DirName => $name,
                    Parent  => 'GIF',
                );
                my $subTable = GetTagTable($$subdir{TagTable});
                unless ($outfile) {
                    $et->ProcessDirectory(\%dirInfo, $subTable);
                    next;
                }
                next if $justCopy;
                if ($doneDir{$name} and $doneDir{$name} > 1) {
                    $et->Warn("Duplicate $name block created");
                }
                $buff = $et->WriteDirectory(\%dirInfo, $subTable);
                if (defined $buff) {
                    next unless length $buff;   # delete this extension if length is zero
                    $dat = $buff;
                }
                $doneDir{$name} = 1;
            } elsif ($outfile and not $justCopy) {
                my $nvHash = $et->GetNewValueHash($extInfo);
                if ($nvHash and $et->IsOverwriting($nvHash, $dat)) {
                    ++$$et{CHANGED};
                    my $val = $et->GetNewValue($extInfo);
                    $et->VerboseValue("- GIF:$name", $dat);
                    next unless defined $val and length $val;
                    $dat = $val;
                    $et->VerboseValue("+ GIF:$name", $dat);
                    $doneDir{$name} = 1;    # (possibly wrote dir as a block)
                }
            } elsif (not $outfile) {
                $et->HandleTag($extTable, $tag, $dat);
                next;
            }
            Write($outfile, $hdr) or $err = 1;  # write extension header
            if ($inclLen) {
                # check for null just to be safe
                $et->Error("$name contained NULL character") if $inclLen and $dat =~ /\0/;
                if ($inclLen > 1) {
                    # add landing zone (without terminator, which will be added later)
                    $dat .= pack('C*',1,reverse(0..255)) if $inclLen;
                } else {
                    # pad with nulls as required
                    my $pos = 0;
                    $pos += ord(substr($dat,$pos,1)) + 1 while $pos < length $dat;
                    $dat .= "\0" x ($pos - length($dat));
                }
                # write data and landing zone
                Write($outfile, $dat) or $err = 1;
            } else {
                # write as sub-blocks
                my $pos = 0;
                my $len = length $dat;
                while ($pos < $len) {
                    my $n = $len - $pos;
                    $n = 255 if $n > 255;
                    Write($outfile, chr($n), substr($dat, $pos, $n)) or $err = 1;
                    $pos += $n;
                }
            }
            Write($outfile, "\0") or $err = 1;  # write null terminator
            next;

        } elsif ($a == 0xf9 and $length == 4) {     # graphic control extension

            last unless $raf->Read($buff, $length) == $length;
            # sum the individual delay times
            my $delay = Get16u(\$buff, 1);
            $delayTime += $delay;
            $verbose and printf $out "Graphic Control: delay=%.2f\n", $delay / 100;
            # get transparent colour
            my $bits = Get8u(\$buff, 0);
            $et->HandleTag($tagTablePtr, 'TransparentColor', Get8u(\$buff,3)) if $bits & 0x01;
            $raf->Seek(-$length, 1) or last;

        } elsif ($a == 0x01 and $length == 12) {    # plain text extension

            last unless $raf->Read($buff, $length) == $length;
            Write($outfile, $ch, $s, $buff) or $err = 1 if $outfile;
            if ($verbose and not $outfile) {
                my ($left, $top, $w, $h) = unpack('v4', $buff);
                print $out "Text: left=$left top=$top width=$w height=$h\n";
            }
            my $text = '';
            for (;;) {
                last unless $raf->Read($ch, 1);
                $length = ord($ch) or last;
                last unless $raf->Read($buff, $length) == $length;
                Write($outfile, $ch, $buff) or $err = 1 if $outfile; # write block
                $text .= $buff;
            }
            Write($outfile, "\0") or $err = 1 if $outfile;  # write terminator block
            $et->HandleTag($tagTablePtr, 'Text', $text);
            next;
        }
        Write($outfile, $ch, $s) or $err = 1 if $outfile;
        # skip the block
        while ($length) {
            last unless $raf->Read($buff, $length) == $length;
            Write($outfile, $buff) or $err = 1 if $outfile;
            last unless $raf->Read($ch, 1);  # read next block header
            Write($outfile, $ch) or $err = 1 if $outfile;
            $length = ord($ch);  # get next block size
        }
    }
    unless ($outfile) {
        $et->HandleTag($tagTablePtr, 'FrameCount', $frameCount) if $frameCount > 1;
        $et->HandleTag($tagTablePtr, 'Duration', $delayTime/100) if $delayTime;
    }

    # set return value to -1 if we only had a write error
    $rtnVal = -1 if $rtnVal and $err;
    return $rtnVal;
}


1;  #end

__END__

=head1 NAME

Image::ExifTool::GIF - Read and write GIF meta information

=head1 SYNOPSIS

This module is loaded automatically by Image::ExifTool when required.

=head1 DESCRIPTION

This module contains definitions required by Image::ExifTool to read and
write GIF meta information.

=head1 AUTHOR

Copyright 2003-2025, Phil Harvey (philharvey66 at gmail.com)

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 REFERENCES

=over 4

=item L<http://www.w3.org/Graphics/GIF/spec-gif89a.txt>

=item L<http://www.adobe.com/devnet/xmp/>

=item L<http://graphcomp.com/info/specs/ani_gif.html>

=item L<http://www.color.org/icc_specs2.html>

=item L<http://www.midiox.com/mmgif.htm>

=back

=head1 SEE ALSO

L<Image::ExifTool(3pm)|Image::ExifTool>

=cut
