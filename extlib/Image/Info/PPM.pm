package Image::Info::PPM;

# Copyright 2000, Gisle Aas.
#
# This library is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

=begin register

MAGIC: /^P[1-6]/

=item PBM/PGM/PPM

All information available is extracted.

=end register

=cut

use strict;
use vars qw/$VERSION/;

$VERSION = 0.04;

sub process_file {
    my($info, $fh) = @_;

    my @header;
    my $type;
    my $num_wanted = 3;
    my $binary;
    my $read_header;

    local($/, $_) = ("\n");
    while (<$fh>) {
	if (s/#\s*(.*)//) {
	    $info->push_info(0, "Comment", $1);
	}
	push(@header, split(' '));
	if (!$type && @header) {
	    $type = shift(@header);
	    $type =~ s/^P// || die;
	    $binary++ if $type > 3;
	    $type = "p" . qw/p b g/[$type % 3] . "m";
	    $num_wanted = 2 if $type eq "pbm";
	}

	for (@header) {
	    unless (/^\d+$/) {
		die "Badly formatted $type file";
	    }
	    $_ += 0; # strip leading zeroes
	}

	next unless @header >= $num_wanted;

	# Now we know everything there is to know...
	$read_header = 1;
	$info->push_info(0, "file_media_type" => "image/$type");
	$info->push_info(0, "file_ext" => "$type");
	$info->push_info(0, "width", shift @header);
	$info->push_info(0, "height", shift @header);
	$info->push_info(0, "resolution", "1/1");

        if ($type eq "ppm") {
	    my $MSV = shift @header;

	    $info->push_info(0, "MaxSampleValue", $MSV);
	    $info->push_info(0, "color_type", "RGB");

	    $info->push_info(0, "SamplesPerPixel", 3);
	    if ($binary) {
		for (1..3) {
		    $info->push_info(0, "BitsPerSample", int(log($MSV + 1) / log(2) ) );
		}
           }
	}
	else {
	    $info->push_info(0, "color_type", "Gray");
	    $info->push_info(0, "SamplesPerPixel", 1);
	    $info->push_info(0, "BitsPerSample", ($type eq "pbm") ? 1 : 8)
		if $binary;
	    $info->push_info(0, "MaxSampleValue", shift @header) if $type ne 'pbm';
	}
	last;
    }

    if (!$read_header) {
	$info->push_info(0, 'error' => 'Incomplete PBM/PGM/PPM header');
    }
}

1;

=pod

=head1 NAME

Image::Info::PPM - PPM support Image::Info

=head1 SYNOPSIS

 use Image::Info qw(image_info dim);

 my $info = image_info("image.ppm");
 if (my $error = $info->{error}) {
     die "Can't parse image info: $error\n";
 }
 my($w, $h) = dim($info);

=head1 DESCRIPTION

This modules adds ppm support to L<Image::Info>.

It is loaded and used automatically.

=head1 METHODS

=head2 process_file()
    
	$info->process_file($source, $options);

Processes one file and sets the found info fields in the C<$info> object.

=head1 AUTHOR

Gisle Aas.

=head1 LICENSE

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
