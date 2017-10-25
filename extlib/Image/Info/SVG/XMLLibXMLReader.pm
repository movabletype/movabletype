# -*- perl -*-

#
# $Id: Image_Info_SVG_LibXML.pm,v 1.2 2008/11/22 14:34:16 eserte Exp eserte $
# Author: Slaven Rezic
#
# Copyright (C) 2008,2009,2016 Slaven Rezic. All rights reserved.
# This package is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# Mail: slaven@rezic.de
# WWW:  http://www.rezic.de/eserte/
#

package Image::Info::SVG::XMLLibXMLReader;

use strict;
use vars qw($VERSION);
$VERSION = '1.05';

use XML::LibXML::Reader;

sub process_file {
    my($info, $source) = @_;

    local $_;

    my(@comments, @warnings);
    local $SIG{__WARN__} = sub {
	push(@warnings, @_);
    };

    my $reader = XML::LibXML::Reader->new(IO => $source, load_ext_dtd => 0, expand_entities => 0)
	or die "Cannot read SVG from handle '$source'";
    while($reader->read) {
	last if $reader->nodeType == XML_READER_TYPE_ELEMENT;
    }

    # first XML element
    my $root_name = $reader->name;
    if ($root_name eq 'svg') {
	$info->push_info(0, 'height', $reader->getAttribute('height'));
	$info->push_info(0, 'width', $reader->getAttribute('width'));

	my $version = $reader->getAttribute('version') || 'unknown';
	$info->push_info(0, 'SVG_Version', $version);

    } else {
	return $info->push_info(0, "error", "Not a valid SVG image, got a <$root_name>");
    }

    my $desc;
    while($reader->read) {
	my $type = $reader->nodeType;
	if ($type == XML_READER_TYPE_COMMENT) {
	    push @comments, $reader->value;
	} elsif ($type == XML_READER_TYPE_ELEMENT) {
	    my $name = $reader->name;
	    if (!$desc && $name eq 'desc') {
		require XML::Simple;
		# Don't take any chances which XML::SAX is defaulted
		# by the user. We know that we have XML::LibXML, so
		# use this one.
		local $XML::Simple::PREFERRED_PARSER = 'XML::LibXML::SAX::Parser';
		my $xs = XML::Simple->new;
		my $desc_xml = $reader->readOuterXml;
		$desc = $xs->XMLin($desc_xml);
	    } elsif ($name eq 'title') {
		my $title = $reader->copyCurrentNode(1)->textContent;
		$info->push_info(0, 'SVG_Title', $title) if $title;
	    } elsif ($name eq 'image') {
		my $href = $reader->getAttribute('xlink:href');
		$info->push_info(0, 'SVG_Image', $href) if $href;
	    }
	}
    }

    $info->push_info(0, 'SVG_StandAlone', $reader->standalone == 1 ? "yes" : "no");

    $info->push_info(0, 'ImageDescription', $desc) if $desc;

    $info->push_info(0, "color_type" => "sRGB");
    $info->push_info(0, "file_ext" => "svg");
    # "image/svg+xml" is the official MIME type
    $info->push_info(0, "file_media_type" => "image/svg+xml");

    # XXX how to determine images?
    for (@comments) {
	$info->push_info(0, "Comment", $_);
    }
    
    for (@warnings) {
	$info->push_info(0, "Warn", $_);
    }

}

1;

__END__
