# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Util::Archive::Tgz;

use strict;
use warnings;

use base qw( MT::ErrorHandler );
use Archive::Tar;
use IO::Compress::Gzip;
use IO::Uncompress::Gunzip;

use constant ARCHIVE_TYPE => 'tgz';

sub new {
    my $pkg = shift;
    my ($type, $file) = @_;

    return $pkg->error(MT->translate('Type must be tgz.'))
        unless $type eq ARCHIVE_TYPE;
    
    my $obj = {};
    if ( ref $file ) {
        bless $file, 'IO::File';
        my $z = new IO::Uncompress::Gunzip $file;
        unless ($z) {
            $z = $file;
        }
        my $tar;
        eval { $tar = Archive::Tar->new($z); };
        return $pkg->error(MT->translate('Could not read from filehandle.'))
            unless $tar;
        $obj->{_arc}  = $tar;
        $obj->{_mode} = 'r';
    }
    elsif ((-e $file) && (-r $file)) {
        my $z;
        if ( $file =~ /\.t?gz$/i ) {
            open my $fh, '<', $file;
            bless $fh, 'IO::File';
            $z = new IO::Uncompress::Gunzip $fh
                or return $pkg->error($@);
        }
        else {
            open $z, '<', $file;
        }
        my $tar = Archive::Tar->new($z)
            or return $pkg->error(MT->translate('File [_1] is not a tgz file.', $file));
        $obj->{_arc}  = $tar;
        $obj->{_mode} = 'r';
    }
    elsif (!(-e $file)) {
        $obj->{_arc}  = Archive::Tar->new();
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
    my $z = IO::Compress::Gzip->new($fh);
    $obj->{_arc}->write($z);
    $obj->{_file} = $z;
    $obj->{_flushed} = 1;
}

sub close {
    my $obj = shift;

    $obj->flush;

    $obj->{_file}->close
        if exists $obj->{_file};
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
    $obj->{_arc}->list_files;
}

sub extract {
    my $obj = shift;
    my ($path) = @_;
    return $obj->error(MT->translate('Can\'t extract from the object'))
        if 'w' eq $obj->{_mode};

    $path ||= MT->config->TempDir;
    for my $file ( $obj->files ) {
        my $f = File::Spec->catfile( $path, $file );
        $obj->{_arc}->extract_file( $file, $f );
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
    my $arc = $obj->{_arc};
    my @arc_files = $arc->add_files($filename);
    $arc_files[0]->rename( $file_path );
}

sub add_string {
    my $obj = shift;
    my ($string, $file_name) = @_;
    return $obj->error(MT->translate('Can\'t write to the object'))
        if 'r' eq $obj->{_mode};
    return $obj->error(MT->translate('Both data and file name must be specified.'))
        unless $string && $file_name;

    $obj->{_arc}->add_data($file_name, $string);
}

1;
__END__

=head1 NAME

MT::Util::Archive::Zip

=head1 SYNOPSIS

Zip compression and extraction package, based on MT::Util::Archive.
See I<MT::Util::Archive> for more details.
