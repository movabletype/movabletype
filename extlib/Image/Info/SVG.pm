# -*- perl -*-

#
# Author: Slaven Rezic
#
# Copyright (C) 2009,2011,2016,2017 Slaven Rezic. All rights reserved.
# This package is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#

package Image::Info::SVG;

use strict;
use vars qw($VERSION @PREFER_MODULE $USING_MODULE);
$VERSION = '2.04';

@PREFER_MODULE = qw(Image::Info::SVG::XMLLibXMLReader
		    Image::Info::SVG::XMLSimple
		  )
    if !@PREFER_MODULE;

TRY_MODULE: {
    for my $try_module (@PREFER_MODULE) {
	if (eval qq{ require $try_module; 1 }) {
	    my $sub = $try_module . '::process_file';
	    no strict 'refs';
	    *process_file = \&{$sub};
	    $USING_MODULE = $try_module;
	    last TRY_MODULE;
	}
    }
    die "Cannot require any of @PREFER_MODULE...\n";
}

1;

__END__

=pod

=head1 NAME

Image::Info::SVG - SVG support for Image::Info

=head1 SYNOPSIS

 use Image::Info qw(image_info dim);

 my $info = image_info("image.svg");
 if (my $error = $info->{error}) {
     die "Can't parse image info: $error\n";
 }
 my $title = $info->{SVG_Title};

 my($w, $h) = dim($info);

=head1 DESCRIPTION

This modules supplies the standard key names except for
BitsPerSample, Compression, Gamma, Interlace, LastModificationTime, as well as:

=over

=item ImageDescription

The image description, corresponds to <desc>.

=item SVG_Image

A scalar or reference to an array of scalars containing the URI's of
embedded images (JPG or PNG) that are embedded in the image.

=item SVG_StandAlone

Whether or not the image is standalone.

=item SVG_Title

The image title, corresponds to <title>

=item SVG_Version

The URI of the DTD the image conforms to.

=back

=head1 METHODS

=head2 process_file()
    
	$info->process_file($source, $options);

Processes one file and sets the found info fields in the C<$info> object.

=head1 FILES

This module requires either L<XML::LibXML::Reader> or L<XML::Simple>.

=head1 COMPATIBILITY

Previous versions (until Image-Info-1.28) used L<XML::Simple> as the
underlying parser. Since Image-Info-1.29 the default parser is
L<XML::LibXML::Reader> which is much more faster, memory-efficient,
and does not rely on regular expressions for some aspects of XML
parsing. If for some reason you need the old parser, you can force it
by setting the variable C<@Image::Info::SVG::PREFER_MODULE> as early
as possible:

    use Image::Info;
    @Image::Info::SVG::PREFER_MODULE = qw(Image::Info::SVG::XMLSimple Image::Info::SVG::XMLLibXMLReader);

The variable C<$Image::Info::SVG::USING_MODULE> can be queried to see
which parser is in use (after B<Image::Info::SVG> is required).

Since 1.38_50 processing of XML external entities (XXE) is not done
anymore for security reasons in both backends
(B<Image::Info::SVG::XMLLibXMLReader> and
B<Image::Info::SVG::XMLSimple>). Controlling XXE processing behavior
in B<XML::Simple> is not really possible (see
L<https://rt.cpan.org/Ticket/Display.html?id=83794>), so as a
workaround the underlying SAX parser is fixed to L<XML::SAX::PurePerl>
which is uncapable of processing external entities E<0x2014> but
unfortunately it is also a slow parser.

=head1 SEE ALSO

L<Image::Info>, L<XML::LibXML::Reader>, L<XML::Simple>, L<XML::SAX::PurePerl>

=head1 NOTES

For more information about SVG see L<http://www.w3.org/Graphics/SVG/>

Random notes:

  Colors
    # iterate over polygon,rect,circle,ellipse,line,polyline,text for style->stroke: style->fill:?
    #  and iterate over each of these within <g> too?! and recurse?!
    # append <color>'s
    # perhaps even deep recursion through <svg>'s?
  ColorProfile <color-profile>
  RenderingIntent ?
  requiredFeatures
  requiredExtensions
  systemLanguage

=head1 AUTHOR

Jerrad Pierce <belg4mit@mit.edu>/<webmaster@pthbb.org> wrote the original code based on L<XML::Simple>

Slaven Rezic <srezic@cpan.org> wrote the code using L<XML::LibXML::Reader>

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=begin register

MAGIC: /^(<\?xml|[\012\015\t ]*<svg\b)/

Provides a plethora of attributes and metadata of an SVG vector graphic.

=end register

=cut
