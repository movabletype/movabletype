package Image::Info::SVG::XMLSimple;

$VERSION = '1.05';

use strict;
no strict 'refs';
use XML::Simple;

sub process_file {
    my($info, $source) = @_;
    my(@comments, @warnings, %info, $comment, $img, $imgdata, $xs);
    local($_);

    while(<$source>){
	if( ! exists($info{standalone}) && /standalone="(.+?)"/ ){
	    $info{standalone} = $1;
	}
	if( /<!--/ .. /-->/ ){
	    $comment .= $_;
	}
	if( /-->/ ){
	    $comment =~ s/<!--\s*//;
	    $comment =~ s/\s*-->//;
	    chomp($comment);
	    push @comments, $comment;
	    $comment = '';
	}
	$imgdata .= $_;
    }

    if( $imgdata !~ /<svg/ ){
	return $info->push_info(0, "error", "Not a valid SVG image");
    }

    local $SIG{__WARN__} = sub {
	push(@warnings, @_);
    };

    # XML::SAX::PurePerl is the only SAX parser which is not capable
    # of expanding external entities, so it's the only one not
    # vulnerable against XXE processing. On the other hand,
    # XML::SAX::PurePerl is probably the slowest parser, but for
    # speed one should use XML::LibXML instead.
    local $XML::Simple::PREFERRED_PARSER = 'XML::SAX::PurePerl';
    $xs = XML::Simple->new;
    $img = $xs->XMLin($imgdata);

#    use Data::Dumper; print Dumper($img);

    $info->push_info(0, "color_type" => "sRGB");
    $info->push_info(0, "file_ext" => "svg");
    # "image/svg+xml" is the official MIME type
    $info->push_info(0, "file_media_type" => "image/svg+xml");

    $info->push_info(0, "height", $img->{height});
    $info->push_info(0, "width", $img->{width});
    $info->push_info(0, "SVG_StandAlone", $info{standalone});
    $info->push_info(0, "SVG_Version", $img->{version} || 'unknown');

    # XXX Description, title etc. could be tucked away in a <g> :-(
    $info->push_info(0, "ImageDescription", $img->{desc}) if $img->{desc};
    $info->push_info(0, "SVG_Title", $img->{title}) if $img->{title};

#    $info->push_info(0, "SamplesPerPixel", -1);
#    $info->push_info(0, "resolution", "1/1");
#    $info->push_info(0, "BitsPerSample", 8);

    if( $img->{image} ){
	if( ref($img->{image}) eq 'ARRAY' ){
	    foreach my $img (@{$img->{image}}){
		$info->push_info(0, "SVG_Image", $img->{'xlink:href'});
	    }
	}
	else{
	    $info->push_info(0, "SVG_Image", $img->{image}->{'xlink:href'});
	}
    }

    for (@comments) {
	$info->push_info(0, "Comment", $_);
    }
    
    for (@warnings) {
	$info->push_info(0, "Warn", $_);
    }
}
1;
__END__

