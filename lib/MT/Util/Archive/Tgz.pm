# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
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

use MT::FileMgr::Local;
use Encode;

sub new {
    my $pkg = shift;
    my ($type, $file) = @_;

    return $pkg->error(MT->translate('Type must be tgz.'))
        unless $type eq ARCHIVE_TYPE;

    my $obj = {};
    if (ref $file) {
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
    } elsif ((-e $file) && (-r $file)) {
        my $z;
        if ($file =~ /\.t?gz$/i) {
            open my $fh, '<:raw', $file or die "Couldn't open $file: $!";
            bless $fh, 'IO::File';
            $z = new IO::Uncompress::Gunzip $fh
                or return $pkg->error($@);
        } else {
            open $z, '<:raw', $file or die "Couldn't open $file: $!";
        }
        my $tar = Archive::Tar->new($z)
            or return $pkg->error(MT->translate('File [_1] is not a tgz file.', $file));
        $obj->{_arc}  = $tar;
        $obj->{_file} = $file;
        $obj->{_mode} = 'r';
    } elsif (!(-e $file)) {
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

    open my $fh, '>:raw', $file or die "Couldn't open $file: $!";
    bless $fh, 'IO::File';
    my $z = IO::Compress::Gzip->new($fh);
    $obj->{_arc}->write($z);
    $obj->{_fh}      = $z;
    $obj->{_flushed} = 1;
}

sub close {
    my $obj = shift;

    $obj->flush;

    $obj->{_fh}->close
        if exists $obj->{_fh};
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
    $obj->{_arc}->list_files;
}

sub is_safe_to_extract {
    my $obj = shift;

    for my $archive_tar_file ($obj->{_arc}->get_files) {
        my $file = $archive_tar_file->full_path;
        if (!$archive_tar_file->is_file && !$archive_tar_file->is_dir) {
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
        my $file_enc = Encode::is_utf8($file) ? $file : Encode::decode_utf8($file);
        my $f        = File::Spec->catfile($path, $file_enc);
        $obj->{_arc}->extract_file($file, MT::FileMgr::Local::_local($f));
    }
    1;
}

sub add_file {
    my $obj = shift;
    my ($path, $file_path) = @_;
    return $obj->error(MT->translate('Cannot write to the object'))
        if 'r' eq $obj->{_mode};
    my $encoded_path = $file_path;
    $encoded_path = MT::FileMgr::Local::_syserr($encoded_path)
        if !Encode::is_utf8($encoded_path);
    $encoded_path = Encode::encode_utf8($encoded_path)
        if Encode::is_utf8($encoded_path);
    my $filename  = File::Spec->catfile($path, $file_path);
    my $arc       = $obj->{_arc};
    my @arc_files = $arc->add_files($filename);
    $arc_files[0]->rename($encoded_path);
}

sub add_string {
    my $obj = shift;
    my ($string, $file_name) = @_;
    return $obj->error(MT->translate('Cannot write to the object'))
        if 'r' eq $obj->{_mode};
    return $obj->error(MT->translate('Both data and file name must be specified.'))
        unless $string && $file_name;

    $obj->{_arc}->add_data($file_name, $string);
}

sub add_tree {
    my $obj = shift;
    my ($dir_path) = @_;
    return $obj->error(MT->translate('Cannot write to the object'))
        if 'r' eq $obj->{_mode};
    my $arc = $obj->{_arc};
    require File::Find;
    require File::Spec;
    require Cwd;
    my $oldcwd = File::Spec->rel2abs(Cwd::getcwd());
    chdir $dir_path;
    $arc->setcwd($dir_path);
    my $sub = sub {
        my $file = $File::Find::name;
        return if -d $file;
        my $rel = File::Spec->abs2rel($file, $dir_path);
        $arc->add_files($rel);
    };
    File::Find::find({ wanted => $sub, no_chdir => 1, }, $dir_path);
    chdir $oldcwd;
}

1;
__END__

=head1 NAME

MT::Util::Archive::Tgz

=head1 SYNOPSIS

Tar/Gzip compression and extraction package, based on MT::Util::Archive.
See I<MT::Util::Archive> for more details.
