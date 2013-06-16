#------------------------------------------------------------------------------
# File:         Microsoft.pm
#
# Description:  Definitions for custom Microsoft tags
#
# Revisions:    2010/10/01 - P. Harvey Created
#
# References:   1) http://research.microsoft.com/en-us/um/redmond/groups/ivm/hdview/hdmetadataspec.htm
#------------------------------------------------------------------------------

package Image::ExifTool::Microsoft;

use strict;
use vars qw($VERSION);
use Image::ExifTool::XMP;

$VERSION = '1.03';

# tags written by Microsoft HDView (ref 1)
%Image::ExifTool::Microsoft::Stitch = (
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    WRITE_PROC => \&Image::ExifTool::WriteBinaryData,
    CHECK_PROC => \&Image::ExifTool::CheckBinaryData,
    WRITABLE => 1,
    FORMAT => 'float',
    FIRST_ENTRY => 0,
    GROUPS => { 0 => 'MakerNotes', 2 => 'Image' },
    NOTES => q{
        Information found in the Microsoft custom EXIF tag 0x4748, as written by
        Windows Live Photo Gallery.
    },
    0 => {
        Name => 'PanoramicStitchVersion',
        Format => 'int32u',
    },
    1 => {
        Name => 'PanoramicStitchCameraMotion',
        Format => 'int32u',
        PrintConv => {
            2 => 'Rigid Scale',
            3 => 'Affine',
            4 => '3D Rotation',
            5 => 'Homography',
        },
    },
    2 => {
        Name => 'PanoramicStitchMapType',
        Format => 'int32u',
        PrintConv => {
            0 => 'Perspective',
            1 => 'Horizontal Cylindrical',
            2 => 'Horizontal Spherical',
            257 => 'Vertical Cylindrical',
            258 => 'Vertical Spherical',
        },
    },
    3 => 'PanoramicStitchTheta0',
    4 => 'PanoramicStitchTheta1',
    5 => 'PanoramicStitchPhi0',
    6 => 'PanoramicStitchPhi1',
);

# Microsoft Photo schema properties (MicrosoftPhoto) (ref PH)
%Image::ExifTool::Microsoft::XMP = (
    %Image::ExifTool::XMP::xmpTableDefaults,
    GROUPS => { 0 => 'XMP', 1 => 'XMP-microsoft', 2 => 'Image' },
    NAMESPACE => 'MicrosoftPhoto',
    TABLE_DESC => 'XMP Microsoft',
    VARS => { NO_ID => 1 },
    NOTES => q{
        Microsoft Photo 1.0 schema XMP tags.  This is likely not a complete list,
        but represents tags which have been observed in sample images.  The actual
        namespace prefix is "MicrosoftPhoto", but ExifTool shortens this to
        "XMP-microsoft" in the family 1 group name.
    },
    CameraSerialNumber => { },
    DateAcquired       => { Groups => { 2 => 'Time' }, %Image::ExifTool::XMP::dateTimeInfo },
    FlashManufacturer  => { },
    FlashModel         => { },
    LastKeywordIPTC    => { List => 'Bag' },
    LastKeywordXMP     => { List => 'Bag' },
    LensManufacturer   => { },
    LensModel          => { },
    Rating => {
        Name => 'RatingPercent',
        Notes => q{
            normal Rating values of 1,2,3,4 and 5 stars correspond to RatingPercent
            values of 1,25,50,75 and 99 respectively
        },
    },
);

# Microsoft Photo 1.1 schema properties (MP1 - written as 'prefix0' by MSPhoto) (ref PH)
%Image::ExifTool::Microsoft::MP1 = (
    %Image::ExifTool::XMP::xmpTableDefaults,
    GROUPS => { 0 => 'XMP', 1 => 'XMP-MP1', 2 => 'Image' },
    NAMESPACE => 'MP1',
    TABLE_DESC => 'XMP Microsoft Photo',
    VARS => { NO_ID => 1 },
    NOTES => q{
        Microsoft Photo 1.1 schema XMP tags which have been observed.
    },
    PanoramicStitchCameraMotion => {
        PrintConv => {
            'RigidScale' => 'Rigid Scale',
            'Affine'     => 'Affine',
            '3DRotation' => '3D Rotation',
            'Homography' => 'Homography',
        },
    },
    PanoramicStitchMapType => {
        PrintConv => {
            'Perspective'            => 'Perspective',
            'Horizontal-Cylindrical' => 'Horizontal Cylindrical',
            'Horizontal-Spherical'   => 'Horizontal Spherical',
            'Vertical-Cylindrical'   => 'Vertical Cylindrical',
            'Vertical-Spherical'     => 'Vertical Spherical',
        },
    },
    PanoramicStitchPhi0   => { Writable => 'real' },
    PanoramicStitchPhi1   => { Writable => 'real' },
    PanoramicStitchTheta0 => { Writable => 'real' },
    PanoramicStitchTheta1 => { Writable => 'real' },
);

# Microsoft Photo 1.2 schema properties (MP) (ref PH)
my %sRegions = (
    STRUCT_NAME => 'Regions',
    NAMESPACE   => 'MPReg',
    Rectangle => { },
    PersonDisplayName => { },
);
%Image::ExifTool::Microsoft::MP = (
    %Image::ExifTool::XMP::xmpTableDefaults,
    GROUPS => { 0 => 'XMP', 1 => 'XMP-MP', 2 => 'Image' },
    NAMESPACE => 'MP',
    TABLE_DESC => 'XMP Microsoft Photo',
    VARS => { NO_ID => 1 },
    NOTES => q{
        Microsoft Photo 1.2 schema XMP tags which have been observed.
    },
    RegionInfo => {
        Name => 'RegionInfoMP',
        Struct => {
            STRUCT_NAME => 'RegionInfoMP',
            NAMESPACE   => 'MPRI',
            Regions   => { Struct => \%sRegions, List => 'Bag' },
        },
    },
    RegionInfoRegionsRectangle => {
        Name => 'RegionRectangle',
        Flat => 1,
    },
    RegionInfoRegionsPersonDisplayName => {
        Name => 'RegionPersonDisplayName',
        Flat => 1,
    },
);


1;  # end

__END__

=head1 NAME

Image::ExifTool::Microsoft - Definitions for custom Microsoft tags

=head1 SYNOPSIS

This module is used by Image::ExifTool

=head1 DESCRIPTION

This module contains definitions required by Image::ExifTool to interpret
Microsoft-specific EXIF and XMP tags.

=head1 AUTHOR

Copyright 2003-2011, Phil Harvey (phil at owl.phy.queensu.ca)

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 REFERENCES

=over 4

=item L<http://research.microsoft.com/en-us/um/redmond/groups/ivm/hdview/hdmetadataspec.htm>

=back

=head1 SEE ALSO

L<Image::ExifTool::TagNames/Microsoft Tags>,
L<Image::ExifTool(3pm)|Image::ExifTool>

=cut

