#------------------------------------------------------------------------------
# File:         Vorbis.pm
#
# Description:  Read Ogg Vorbis meta information
#
# Revisions:    11/10/2006 - P. Harvey Created
#
# References:   1) http://www.xiph.org/vorbis/doc/
#               2) http://flac.sourceforge.net/ogg_mapping.html
#------------------------------------------------------------------------------

package Image::ExifTool::Vorbis;

use strict;
use vars qw($VERSION);
use Image::ExifTool qw(:DataAccess :Utils);

$VERSION = '1.02';

my $MAX_PACKETS = 2;    # maximum packets to scan from each stream at start of file

sub ProcessComments($$$);
sub DecodeCoverArt($);

# Vorbis comment tags
%Image::ExifTool::Vorbis::Main = (
    NOTES => q{
        ExifTool extracts the following Vorbis information from Ogg files.  As well
        as this, ExifTool also extracts FLAC and ID3 information from Ogg files.
    },
    1 => {
        Name => 'Identification',
        SubDirectory => { TagTable => 'Image::ExifTool::Vorbis::Identification' },
    },
    3 => {
        Name => 'Comments',
        SubDirectory => { TagTable => 'Image::ExifTool::Vorbis::Comments' },
    },
);

%Image::ExifTool::Vorbis::Identification = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    GROUPS => { 2 => 'Audio' },
    0 => {
        Name => 'VorbisVersion',
        Format => 'int32u',
    },
    4 => 'AudioChannels',
    5 => {
        Name => 'SampleRate',
        Format => 'int32u',
    },
    9 => {
        Name => 'MaximumBitrate',
        Format => 'int32u',
        RawConv => '$val || undef',
        PrintConv => 'ConvertBitrate($val)',
    },
    13 => {
        Name => 'NominalBitrate',
        Format => 'int32u',
        RawConv => '$val || undef',
        PrintConv => 'ConvertBitrate($val)',
    },
    17 => {
        Name => 'MinimumBitrate',
        Format => 'int32u',
        RawConv => '$val || undef',
        PrintConv => 'ConvertBitrate($val)',
    },
);

%Image::ExifTool::Vorbis::Comments = (
    PROCESS_PROC => \&ProcessComments,
    GROUPS => { 2 => 'Audio' },
    NOTES => q{
        The tags below are only some common tags found in the Vorbis comments of Ogg
        Vorbis and Ogg FLAC audio files, however ExifTool will extract values from
        any tag found, even if not listed here.
    },
    vendor    => { Notes => 'from comment header' },
    TITLE     => { Name => 'Title' },
    VERSION   => { Name => 'Version' },
    ALBUM     => { Name => 'Album' },
    TRACKNUMBER=>{ Name => 'TrackNumber' },
    ARTIST    => { Name => 'Artist',       Groups => { 2 => 'Author' }, List => 1 },
    PERFORMER => { Name => 'Performer',    Groups => { 2 => 'Author' }, List => 1 },
    COPYRIGHT => { Name => 'Copyright',    Groups => { 2 => 'Author' } },
    LICENSE   => { Name => 'License',      Groups => { 2 => 'Author' } },
    ORGANIZATION=>{Name => 'Organization', Groups => { 2 => 'Author' } },
    DESCRIPTION=>{ Name => 'Description' },
    GENRE     => { Name => 'Genre' },
    DATE      => { Name => 'Date',         Groups => { 2 => 'Time' } },
    LOCATION  => { Name => 'Location',     Groups => { 2 => 'Location' } },
    CONTACT   => { Name => 'Contact',      Groups => { 2 => 'Author' }, List => 1 },
    ISRC      => { Name => 'ISRCNumber' },
    COVERARTMIME => { Name => 'CoverArtMIMEType' },
    COVERART  => {
        Name => 'CoverArt',
        Notes => 'base64-encoded image',
        ValueConv => q{
            require Image::ExifTool::XMP;
            Image::ExifTool::XMP::DecodeBase64($val);
        },
    },
    REPLAYGAIN_TRACK_PEAK => { Name => 'ReplayGainTrackPeak' },
    REPLAYGAIN_TRACK_GAIN => { Name => 'ReplayGainTrackGain' },
    REPLAYGAIN_ALBUM_PEAK => { Name => 'ReplayGainAlbumPeak' },
    REPLAYGAIN_ALBUM_GAIN => { Name => 'ReplayGainAlbumGain' },
    # observed in "Xiph.Org libVorbis I 20020717" ogg:
    ENCODED_USING => { Name => 'EncodedUsing' },
    ENCODED_BY  => { Name => 'EncodedBy' },
    COMMENT     => { Name => 'Comment' },
);

#------------------------------------------------------------------------------
# Process Vorbis Comments
# Inputs: 0) ExifTool object ref, 1) dirInfo ref, 2) tag table ref
# Returns: 1 on success, otherwise returns 0 and sets a Warning
sub ProcessComments($$$)
{
    my ($exifTool, $dirInfo, $tagTablePtr) = @_;
    my $dataPt = $$dirInfo{DataPt};
    my $dataPos = $$dirInfo{DataPos};
    my $pos = $$dirInfo{DirStart} || 0;
    my $end = $$dirInfo{DirLen} ? $pos + $$dirInfo{DirLen} : length $$dataPt;
    my ($num, $index);

    SetByteOrder('II');
    for (;;) {
        last if $pos + 4 > $end;
        my $len = Get32u($dataPt, $pos);
        last if $pos + 4 + $len > $end;
        my $start = $pos + 4;
        my $buff = substr($$dataPt, $start, $len);
        $pos = $start + $len;
        my ($tag, $val);
        if (defined $num) {
            $buff =~ /(.*?)=(.*)/s or last;
            ($tag, $val) = ($1, $2);
        } else {
            $tag = 'vendor';
            $val = $buff;
            $num = ($pos + 4 < $end) ? Get32u($dataPt, $pos) : 0;
            $exifTool->VPrint(0, "  + [Vorbis comments with $num entries]\n");
            $pos += 4;
        }
        # add tag to table unless it exists already
        unless ($$tagTablePtr{$tag}) {
            my $name = ucfirst(lc($tag));
            # remove invalid characters in tag name and capitalize following letters
            $name =~ s/[^\w-]+(.?)/\U$1/sg;
            $name =~ s/([a-z0-9])_([a-z])/$1\U$2/g;
            Image::ExifTool::AddTagToTable($tagTablePtr, $tag, { Name => $name });
        }
        $exifTool->HandleTag($tagTablePtr, $tag, $val,
            Index   => $index,
            DataPt  => $dataPt,
            DataPos => $dataPos,
            Start   => $start,
            Size    => $len,
        );
        # all done if this was our last tag
        $num-- or return 1;
        $index = (defined $index) ? $index + 1 : 0;
    }
    $exifTool->Warn('Format error in Vorbis comments');
    return 0;
}

#------------------------------------------------------------------------------
# Process Ogg packet
# Inputs: 0) ExifTool object ref, 1) data ref, 2) tag table ref
# Returns: 1 on success
sub ProcessPacket($$$)
{
    my ($exifTool, $dataPt, $tagTablePtr) = @_;
    if ($$dataPt =~ /^(.)vorbis/s) {
        my $tag = ord($1);
        my $tagInfo = $exifTool->GetTagInfo($tagTablePtr, $tag);
        return 0 unless $tagInfo and $$tagInfo{SubDirectory};
        my %dirInfo = (
            DataPt => $dataPt,
            DirName => $$tagInfo{Name},
            DirStart => 7,
        );
        my $table = GetTagTable($tagInfo->{SubDirectory}->{TagTable});
        return $exifTool->ProcessDirectory(\%dirInfo, $table);
    }
    return 0;
}

#------------------------------------------------------------------------------
# Extract information from an Ogg Vorbis or Ogg FLAC file
# Inputs: 0) ExifTool object reference, 1) dirInfo reference
# Returns: 1 on success, 0 if this wasn't a valid Ogg Vorbis file
sub ProcessOGG($$)
{
    my ($exifTool, $dirInfo) = @_;

    # must first check for leading/trailing ID3 information
    unless ($exifTool->{DoneID3}) {
        require Image::ExifTool::ID3;
        Image::ExifTool::ID3::ProcessID3($exifTool, $dirInfo) and return 1;
    }
    my $raf = $$dirInfo{RAF};
    my $verbose = $exifTool->Options('Verbose');
    my $out = $exifTool->Options('TextOut');
    my ($success, $page, $packets, $streams) = (0,0,0,0);
    my ($buff, $tagTablePtr, $flag, $stream, %val, $numFlac);

    for (;;) {
        # must read ahead to next page to see if it is a continuation
        # (this code would be a lot simpler if the continuation flag
        #  was on the leading instead of the trailing page!)
        if ($raf and $raf->Read($buff, 28) == 28) {
            # validate magic number
            unless ($buff =~ /^OggS/) {
                $success and $exifTool->Warn('Lost synchronization');
                last;
            }
            unless ($success) {
                # set file type and initialize on first page
                $success = 1;
                $exifTool->SetFileType();
                SetByteOrder('II');
                $tagTablePtr = GetTagTable('Image::ExifTool::Vorbis::Main');
            }
            $flag = Get8u(\$buff, 5);       # page flag
            $stream = Get32u(\$buff, 14);   # stream serial number
            ++$streams if $flag & 0x02;     # count start-of-stream pages
            ++$packets unless $flag & 0x01; # keep track of packet count
        } else {
            # all done unless we have to process our last packet
            last unless %val;
            ($stream) = sort keys %val;     # take a stream
            $flag = 0;                      # no continuation
            undef $raf;                     # flag for done reading
        }

        if (defined $numFlac) {
            # stop to process FLAC headers if we hit the end of file
            last unless $raf;
            --$numFlac; # one less header packet to read
        } else {
            # can finally process previous packet from this stream
            # unless this is a continuation page
            if (defined $val{$stream} and not $flag & 0x01) {
                ProcessPacket($exifTool, \$val{$stream}, $tagTablePtr);
                delete $val{$stream};
                # only read the first $MAX_PACKETS packets from each stream
                if ($packets > $MAX_PACKETS * $streams or not defined $raf) {
                    last unless %val;   # all done (success!)
                    next;               # process remaining stream(s)
                }
            }
            # stop processing Ogg Vorbis if we have scanned enough packets
            last if $packets > $MAX_PACKETS * $streams and not %val;
        }

        # continue processing the current page
        my $pageNum = Get32u(\$buff, 18);   # page sequence number
        my $nseg = Get8u(\$buff, 26);       # number of segments
        # calculate total data length
        my $dataLen = Get8u(\$buff, 27);
        if ($nseg) {
            $raf->Read($buff, $nseg-1) == $nseg-1 or last;
            my @segs = unpack('C*', $buff);
            # could check that all these (but the last) are 255...
            foreach (@segs) { $dataLen += $_ }
        }
        if (defined $page) {
            if ($page == $pageNum) {
                ++$page;
            } else {
                $exifTool->Warn('Missing page(s) in Ogg file');
                undef $page;
            }
        }
        # read page data
        $raf->Read($buff, $dataLen) == $dataLen or last;
        if ($verbose > 1) {
            printf $out "Page %d, stream 0x%x, flag 0x%x (%d bytes)\n",
                   $pageNum, $stream, $flag, $dataLen;
            $exifTool->VerboseDump(\$buff, DataPos => $raf->Tell() - $dataLen);
        }
        if (defined $val{$stream}) {
            $val{$stream} .= $buff;     # add this continuation page
        } elsif (not $flag & 0x01) {    # ignore remaining pages of a continued packet
            # ignore the first page of any packet we aren't parsing
            if ($buff =~ /^(.)vorbis/s and $$tagTablePtr{ord($1)}) {
                $val{$stream} = $buff;      # save this page
            } elsif ($buff =~ /^\x7fFLAC..(..)/s) {
                $numFlac = unpack('n',$1);
                $val{$stream} = substr($buff, 9);
            }
        }
        if (defined $numFlac) {
            # stop to process FLAC headers if we have them all
            last if $numFlac <= 0;
        } elsif (defined $val{$stream} and $flag & 0x04) {
            # process Ogg Vorbis packet now if end-of-stream bit is set
            ProcessPacket($exifTool, \$val{$stream}, $tagTablePtr);
            delete $val{$stream};
        }
    }
    if (defined $numFlac and defined $val{$stream}) {
        # process FLAC headers as if it was a complete FLAC file
        require Image::ExifTool::FLAC;
        my %dirInfo = ( RAF => new File::RandomAccess(\$val{$stream}) );
        Image::ExifTool::FLAC::ProcessFLAC($exifTool, \%dirInfo);
    }
    return $success;
}

1;  # end

__END__

=head1 NAME

Image::ExifTool::Vorbis - Read Ogg Vorbis meta information

=head1 SYNOPSIS

This module is used by Image::ExifTool

=head1 DESCRIPTION

This module contains definitions required by Image::ExifTool to extract meta
information from Ogg Vorbis and Ogg FLAC audio files.

=head1 AUTHOR

Copyright 2003-2011, Phil Harvey (phil at owl.phy.queensu.ca)

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 REFERENCES

=over 4

=item L<http://www.xiph.org/vorbis/doc/>

=item L<http://flac.sourceforge.net/ogg_mapping.html>

=back

=head1 SEE ALSO

L<Image::ExifTool::TagNames/Vorbis Tags>,
L<Image::ExifTool(3pm)|Image::ExifTool>

=cut

