#------------------------------------------------------------------------------
# File:         Reconyx.pm
#
# Description:  Reconyx maker notes tags
#
# Revisions:    2011-01-11 - P. Harvey Created
#------------------------------------------------------------------------------

package Image::ExifTool::Reconyx;

use strict;
use vars qw($VERSION);

$VERSION = '1.01';

# maker notes for Reconyx Hyperfire cameras (ref PH)
%Image::ExifTool::Reconyx::Main = (
    GROUPS => { 0 => 'MakerNotes', 2 => 'Camera' },
    PROCESS_PROC => \&Image::ExifTool::ProcessBinaryData,
    WRITE_PROC => \&Image::ExifTool::WriteBinaryData,
    CHECK_PROC => \&Image::ExifTool::CheckBinaryData,
    TAG_PREFIX => 'Reconyx',
    FORMAT => 'int16u',
    WRITABLE => 1,
    FIRST_ENTRY => 0,
    NOTES => q{
        The following tags are extracted from the maker notes of Reconyx Hyperfire
        cameras such as the HC500, HC600 and PC900.
    },
    0x06 => {
        Name => 'TriggerMode',
        Format => 'string[2]',
        PrintConv => {
            M => 'Motion Detection',
            T => 'Time Lapse',
        },
    },
    0x07 => {
        Name => 'Sequence',
        Format => 'int16u[2]',
        PrintConv => '$val =~ s/ / of /; $val',
        PrintConvInv => 'join(" ", $val=~/\d+/g)',
    },
    0x0b => {
        Name => 'DateTimeOriginal',
        Description => 'Date/Time Original',
        Format => 'int16u[6]',
        Groups => { 2 => 'Time' },
        Shift => 'Time',
        ValueConv => q{
            my @a = split ' ', $val;
            sprintf('%.4d:%.2d:%.2d %.2d:%.2d:%.2d', @a[5,3,4,2,1,0]);
        },
        ValueConvInv => q{
            my @a = ($val =~ /\d+/g);
            return undef unless @a >= 6;
            join ' ', @a[5,4,3,1,2,0];
        },
        PrintConv => '$self->ConvertDateTime($val)',
        PrintConvInv => '$val',
    },
    0x12 => {
        Name => 'MoonPhase',
        Groups => { 2 => 'Time' },
        PrintConv => {
            0 => 'New',
            1 => 'New Crescent',
            2 => 'First Quarter',
            3 => 'Waxing Gibbous',
            4 => 'Full',
            5 => 'Waning Gibbous',
            6 => 'Last Quarter',
            7 => 'Old Crescent',
        },
    },
    0x13 => {
        Name => 'AmbientTemperatureFahrenheit',
        PrintConv => '"$val F"',
        PrintConvInv => '$val=~/(\d+)/ ? $1 : $val',
    },
    0x14 => {
        Name => 'AmbientTemperature',
        PrintConv => '"$val C"',
        PrintConvInv => '$val=~/(\d+)/ ? $1 : $val',
    },
    0x15 => {
        Name => 'SerialNumber',
        Format => 'undef[30]',
        RawConv => '$_ = $self->Decode($val, "UCS2"); s/\0.*//; $_',
    },
    0x28 => {
        Name => 'InfraredIlluminator',
        PrintConv => {
            0 => 'Off',
            1 => 'On',
        },
    },
    0x2b => {
        Name => 'UserLabel',
        Format => 'string[16]', # 16 chars according to user manual
    },
);


__END__

=head1 NAME

Image::ExifTool::Reconyx - Reconyx maker notes tags

=head1 SYNOPSIS

This module is loaded automatically by Image::ExifTool when required.

=head1 DESCRIPTION

This module contains definitions required by Image::ExifTool to interpret
maker notes in Reconyx cameras.

=head1 AUTHOR

Copyright 2003-2011, Phil Harvey (phil at owl.phy.queensu.ca)

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 SEE ALSO

L<Image::ExifTool::TagNames/Reconyx Tags>,
L<Image::ExifTool(3pm)|Image::ExifTool>

=cut
