# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Util::Archive::Zip;

use strict;
use warnings;

use base qw( MT::ErrorHandler );
use Archive::Zip;

use constant ARCHIVE_TYPE => 'zip';

use MT::FileMgr::Local;
use Encode;

sub new {
    my $pkg = shift;
    my ($type, $file) = @_;

    return $pkg->error(MT->translate('Type must be zip'))
        unless $type eq ARCHIVE_TYPE;

    my $zip = Archive::Zip->new;
    my $obj = { _flushed => 0, _arc => $zip };
    if (ref $file) {
        bless $file, 'IO::File';
        my $status = $zip->readFromFileHandle($file);
        return $pkg->error(MT->translate('Could not read from filehandle.'))
            if Archive::Zip::AZ_OK() != $status;
        $obj->{_fh}   = $file;
        $obj->{_mode} = 'r';
    } elsif ((-e $file) && (-r $file)) {
        open my $fh, '<:raw', $file or die "Couldn't open $file: $!";
        bless $fh, 'IO::File';
        my $status = $zip->readFromFileHandle($fh);
        return $pkg->error(MT->translate('File [_1] is not a zip file.', $file))
            if Archive::Zip::AZ_OK() != $status;
        $obj->{_file} = $file;
        $obj->{_fh}   = $fh;
        $obj->{_mode} = 'r';
    } elsif (!(-e $file)) {
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

    open my $fh, '>:raw', $file or die "Couldn't open $file: $!";
    bless $fh, 'IO::File';
    $obj->{_fh} = $fh;
    $obj->{_arc}->writeToFileHandle($fh);
    $obj->{_flushed} = 1;
}

sub close {
    my $obj = shift;

    $obj->flush;

    close $obj->{_fh};
    $obj->{_arc}  = undef;
    $obj->{_file} = undef;
    $obj->{_fh}   = undef;
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

sub is_safe_to_extract {
    my $obj = shift;

    for my $member ($obj->{_arc}->members) {
        my $file = $member->fileName;
        if ($member->isSymbolicLink) {
            return $obj->error(MT->translate("[_1] in the archive is not a regular file", $file));
        }
        if (File::Spec->file_name_is_absolute($file)) {
            return $obj->error(MT->translate("[_1] in the archive is an absolute path", $file));
        }
        my ($vol, $dirs, $basename) = File::Spec->splitpath($file);
        if (grep { $_ eq '..' } File::Spec->splitdir($dirs)) {
            return $obj->error(MT->translate("[_1] in the archive contains ..", $file));
        }
    }
    1;
}

sub extract {
    my $obj = shift;
    my ($path) = @_;
    return $obj->error(MT->translate('Cannot extract from the object'))
        if 'w' eq $obj->{_mode};

    $path ||= MT->config->TempDir;
    for my $file ($obj->files) {
        my $file_enc = Encode::decode('Shift_JIS', $file);
        my $f        = File::Spec->catfile($path, $file_enc);
        $obj->{_arc}->extractMember($file, MT::FileMgr::Local::_local($f));
    }
    1;
}

sub add_file {
    my $obj = shift;
    my ($path, $file_path) = @_;
    return $obj->error(MT->translate('Cannot write to the object'))
        if 'r' eq $obj->{_mode};
    my $filename = File::Spec->catfile($path, $file_path);
    $file_path = Encode::encode('Shift_JIS', $file_path)
        if Encode::is_utf8($file_path);
    $obj->{_arc}->addFile($filename, $file_path);
}

sub add_string {
    my $obj = shift;
    my ($string, $file_name) = @_;
    return $obj->error(MT->translate('Cannot write to the object'))
        if 'r' eq $obj->{_mode};
    return $obj->error(MT->translate('Both data and file name must be specified.'))
        unless $string && $file_name;
    $file_name = Encode::encode('Shift_JIS', $file_name)
        if Encode::is_utf8($file_name);
    $obj->{_arc}->addString($string, $file_name);
}

sub add_tree {
    my $obj = shift;
    my ($dir_path) = @_;
    return $obj->error(MT->translate('Cannot write to the object'))
        if 'r' eq $obj->{_mode};
    $obj->{_arc}->addTree($dir_path, '');
}

1;
__END__

=head1 NAME

MT::Util::Archive::Zip

=head1 SYNOPSIS

Zip compression and extraction package, based on MT::Util::Archive.
See I<MT::Util::Archive> for more details.
