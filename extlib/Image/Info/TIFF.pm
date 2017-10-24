package Image::Info::TIFF;

$VERSION = 0.05;

use strict;
use Config;
use Carp qw(confess);
use Image::TIFF;

my @types = (
  [ "ERROR INVALID TYPE",     "?", 0],
  [ "BYTE",      "C", 1],
  [ "ASCII",     "A", 1],
  [ "SHORT",     "S", 2],
  [ "LONG",      "L", 4],
  [ "RATIONAL",  "N2", 8],
  [ "SBYTE",     "c", 1],
  [ "UNDEFINED", "a", 1],
  [ "SSHORT",    "s", 2],
  [ "SLONG",     "l", 4],
  [ "SRATIONAL", "N2", 8],
  [ "FLOAT",     "f", 4],  
  [ "DOUBLE",    "d", 8],  
);

sub _hostbyteorder {
    my $hbo = $Config{byteorder};
    # we only care about the order, not the length (for 64 bit, it might
    # be 12345678)
    if ($hbo =~ /^1234/) { return '1234' }
    if ($hbo =~ /4321$/) { return '4321' }
    die "Unexpected host byteorder: $hbo";
}

sub _read
{
    # read bytes, and move the file pointer forward
    my($source, $len) = @_;
    my $buf;
    my $n = read($source, $buf, $len);
    die "read failed: $!" unless defined $n;
    die "short read ($len/$n) at pos " . tell($source) unless $n == $len;
    $buf;
}

sub _readbytes
{
    # read bytes, but make the file pointer stand still
    my ($fh,$offset,$len) = @_;
    my $curoffset = tell($fh);
    my $buf;
    seek($fh,$offset,0);
    my $n = read($fh,$buf,$len);
    confess("short read($n/$len)") unless $n == $len;
    # back to before.
    seek($fh,$curoffset,0);
    return $buf;
}

sub _readrational
{
    my ($fh,$offset,$byteorder,$count,$ar,$signed) = @_;
    my $curoffset = tell($fh);
    my $buf;
    seek($fh,$offset,0);
    while ($count > 0) {
	my $num;
	my $denom;
	if ($signed) {
	    $num = unpack("l",_read_order($fh,4,$byteorder));
	    $denom = unpack("l",_read_order($fh,4,$byteorder));
	} else {
	    $num = unpack("L",_read_order($fh,4,$byteorder));
	    $denom = unpack("L",_read_order($fh,4,$byteorder));
	}
	push(@{$ar},new Image::TIFF::Rational($num,$denom));
	$count--;
    }
    # back to before.
    seek($fh,$curoffset,0);
}

sub _read_order
{
    my($source, $len,$byteorder) = @_;

    my $buf = _read($source,$len);
    # maybe reverse the read data?
    if ($byteorder ne _hostbyteorder()) {
	my @bytes = unpack("C$len",$buf);
	my @newbytes;
	# swap bytes
	for (my $i = $len-1; $i >= 0; $i--) {
	    push(@newbytes,$bytes[$i]);
	}
	$buf = pack("C$len",@newbytes);
    }
    $buf;
}

my %order = (
	     "MM\x00\x2a" => '4321',
	     "II\x2a\x00" => '1234',
	     );

sub process_file
{
    my($info, $fh) = @_;

    my $soi = _read($fh, 4);
    die "TIFF: SOI missing" unless (defined($order{$soi}));
    # XXX: should put this info in all pages?
    $info->push_info(0, "file_media_type" => "image/tiff");
    $info->push_info(0, "file_ext" => "tif");

    my $byteorder = $order{$soi};
    my $ifdoff = unpack("L",_read_order($fh,4,$byteorder));
    my $page = 0;
    do {
      # print "TIFF Directory at $ifdoff\n";
      $ifdoff = _process_ifds($info,$fh,$page,0,$byteorder,$ifdoff);
      $page++;
    } while ($ifdoff);
}

sub _process_ifds {
    my($info, $fh, $page, $tagsseen, $byteorder, $ifdoffset) = @_;
    my $curpos = tell($fh);
    seek($fh,$ifdoffset,0);

    my $n = unpack("S",_read_order($fh, 2, $byteorder)); ## Number of entries
    my $i = 1;
    while ($n > 0) {
	# process one IFD entry
	my $tag = unpack("S",_read_order($fh,2,$byteorder));
	my $fieldtype = unpack("S",_read_order($fh,2,$byteorder));
	unless ($types[$fieldtype]) {
	  my $warnmsg = "Unrecognised fieldtype $fieldtype, ignoring following entries";
	  warn "$warnmsg\n";
	  $info->push_info($page, "Warn" => $warnmsg);
	  return 0;
	}
        my ($typename, $typepack, $typelen) = @{$types[$fieldtype]};
	my $count = unpack("L",_read_order($fh,4,$byteorder));
        my $value_offset_orig = _read_order($fh,4,$byteorder);
	my $value_offset = unpack("L", $value_offset_orig);
	my $val;
        ## The 4 bytes of $value_offset may actually contains the value itself,
        ## if it fits into 4 bytes.
        my $len = $typelen * $count;
        if ($len <= 4) {
          if (($byteorder ne _hostbyteorder()) && ($len != 4)) {
	    my @bytes = unpack("C4", $value_offset_orig);
	    for (my $i=0; $i < 4 - $len; $i++) { shift @bytes; }
	    $value_offset_orig = pack("C$len", @bytes);
          } 
          @$val = unpack($typepack x $count, $value_offset_orig);
        } elsif ($fieldtype == 2) {
          ## ASCII text. The last byte is a NUL, which we don't need
          ## to include in the Perl string, so read one less than the count.
          @$val = _readbytes($fh, $value_offset, $count - 1);
	} elsif ($fieldtype == 5) {
	  ## Unsigned Rational
	  $val = [];
	  _readrational($fh,$value_offset,$byteorder,$count,$val,0);
        } elsif ($fieldtype == 10) {
	  ## Signed Rational
	  $val = [];
          _readrational($fh,$value_offset,$byteorder,$count,$val,1);
        } else {
          ## Just read $count thingies from the offset
	  @$val = unpack($typepack x $count, _readbytes($fh, $value_offset, $typelen * $count));
	}
	#look up tag
	my $tn =  Image::TIFF->exif_tagname($tag);
        foreach my $v (@$val) {
	  if (ref($tn)) {
	    $v = $$tn{$v};
	    $tn = $$tn{__TAG__};
	  }
        }
	if ($tn eq "NewSubfileType") {
	    # start new page if necessary
	    if ($tagsseen) {
		$page++;
		$tagsseen = 0;
	    }
	} else {
	    $tagsseen = 1;
	}
        my $vval;
        ## If only one value, use direct
        if (@$val <= 1) {
          $val = $val->[0] || '';
          $vval = $val;
        } else {
          $vval = '(' . join(',',@$val) . ')';
        }
	# print "$page/$i:$value_offset:$tag ($tn), fieldtype: $fieldtype, count: $count = $vval\n";
	if ($tn eq "ExifOffset") {
	    # parse ExifSubIFD
            # print "ExifSubIFD at $value_offset\n";
	    _process_ifds($info,$fh,$page,$tagsseen,$byteorder,$value_offset);
	}
	$info->push_info($page, $tn => $val);
	$n--;
	$i++;
    }
    my $ifdoff = unpack("L",_read_order($fh,4,$byteorder));
    #print "next dir at $ifdoff\n";
    seek($fh,$curpos,0);
    return $ifdoff if $ifdoff;
    0;
}
1;

__END__

=pod

=head1 NAME

Image::Info::TIFF - TIFF support for Image::Info

=head1 SYNOPSIS

 use Image::Info qw(image_info dim);

 my $info = image_info("image.tif");
 if (my $error = $info->{error}) {
     die "Can't parse image info: $error\n";
 }
 print $info->{BitPerSample};

 my($w, $h) = dim($info);

=head1 DESCRIPTION

This module adds TIFF support for Image::Info.


=head1 METHODS

=head2 process_file()

        $info->process_file($source, $options);

Processes one file and sets the found info fields in the C<$info> object.

=head1 SEE ALSO

L<Image::Info>

=head1 AUTHOR

Jerrad Pierce <belg4mit@mit.edu>/<webmaster@pthbb.org>

Patches and fixes by Ben Wheeler.

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=begin register

MAGIC: /^MM\x00\x2a/
MAGIC: /^II\x2a\x00/

The C<TIFF> spec can be found at:
L<http://partners.adobe.com/public/developer/tiff/>

The EXIF spec can be found at:
L<http://www.exif.org/specifications.html>

=end register

=cut
