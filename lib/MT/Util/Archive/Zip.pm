# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Util::Archive::Zip;

use strict;
use warnings;

use base qw( MT::ErrorHandler );
use Archive::Zip;

use constant ARCHIVE_TYPE => 'zip';

sub new {
    my $pkg = shift;
    my ($type, $file) = @_;

    return $pkg->error(MT->translate('Type must be zip'))
        unless $type eq ARCHIVE_TYPE;
    
    my $zip = Archive::Zip->new;
    my $obj = { _flushed => 0, _arc => $zip };
    if ( ref $file ) {
        bless $file, 'IO::File';
        my $status = $zip->readFromFileHandle($file);
        return $pkg->error(MT->translate('Could not read from filehandle.'))
            if Archive::Zip::AZ_OK() != $status;
        $obj->{_file} = $file;
        $obj->{_mode} = 'r';
    }
    elsif ((-e $file) && (-r $file)) {
        open my $fh, '<', $file;
        bless $fh, 'IO::File';
        my $status = $zip->readFromFileHandle($fh);
        return $pkg->error(MT->translate('File [_1] is not a zip file.', $file))
            if Archive::Zip::AZ_OK() != $status;
        $obj->{_file} = $fh;
        $obj->{_mode} = 'r';
    }
    elsif (!(-e $file)) {
        $obj->{_file} = $file;
        $obj->{_mode} = 'w';
    }
    bless $obj, $pkg;
    $obj;
}

sub flush {
    my $obj = shift;

    return undef if 'w' ne $obj->{_mode};
    return undef if $obj->{_flushed};

    my $file = $obj->{_file};
    return $obj->error(MT->translate('File [_1] exists; could not overwrite.', $file))
        if -e $file;

    open my $fh, '>', $file;
    bless $fh, 'IO::File';
    $obj->{_file} = $fh;
    $obj->{_arc}->writeToFileHandle($fh);
    $obj->{_flushed} = 1;
}

sub close {
    my $obj = shift;

    $obj->flush;

    close $obj->{_file};
    $obj->{_arc} = undef;
    $obj->{_file}  = undef;
    1;
}

sub type {
    my $obj = shift;
    return ARCHIVE_TYPE;
}

sub is {
    my $obj = shift;
    my ($type) = @_;
    return $type eq ARCHIVE_TYPE ? 1 : 0;
}

sub files {
    my $obj = shift;
    $obj->{_arc}->memberNames;
}

sub extract {
    my $obj = shift;
    my ($path) = @_;
    return $obj->error(MT->translate('Can\'t extract from the object'))
        if 'w' eq $obj->{_mode};

    $path ||= MT->config->TempDir;
    for my $file ( $obj->files ) {
        my $f = File::Spec->catfile( $path, $file );
        $obj->{_arc}->extractMember( $file, $f );
    }
    1;
}

sub add_file {
    my $obj = shift;
    my ($path, $file_path) = @_;
    return $obj->error(MT->translate('Can\'t write to the object'))
        if 'r' eq $obj->{_mode};
    my $filename =
        File::Spec->catfile( $path, $file_path );
    $obj->{_arc}->addFile( $filename, $file_path );
}

sub add_string {
    my $obj = shift;
    my ($string, $file_name) = @_;
    return $obj->error(MT->translate('Can\'t write to the object'))
        if 'r' eq $obj->{_mode};
    return $obj->error(MT->translate('Both data and file name must be specified.'))
        unless $string && $file_name;

    $obj->{_arc}->addString($string, $file_name);
}

1;
__END__

=head1 NAME

MT::Util::Archive::Zip

=head1 SYNOPSIS

Zip compression and extraction package, based on MT::Util::Archive.
See I<MT::Util::Archive> for more details.
