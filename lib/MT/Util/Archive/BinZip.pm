# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Util::Archive::BinZip;

use strict;
use warnings;
use base qw( MT::ErrorHandler );

use constant ARCHIVE_TYPE => 'zip';

use MT::Util::Archive::TempFile;
use File::Copy     ();
use File::Temp     ();
use File::Path     ();
use File::Basename ();
use Encode;
use IPC::Run3 ();

our $BinZipPath;
our $BinUnzipPath;

sub new {
    my $pkg = shift;
    my ($type, $file) = @_;

    $type =~ s/^bin//;
    return $pkg->error(MT->translate('Type must be zip'))
        unless $type eq ARCHIVE_TYPE;

    my $obj = {};
    if (ref $file) {
        my $tmpfile = MT::Util::Archive::TempFile->new('mt_archive_XXXX');
        my $pos     = tell $file;
        seek $file, 0, 0;
        File::Copy::cp($file, "$tmpfile");
        seek $file, $pos, 0;
        $obj->{_file} = $tmpfile;
        $obj->{_mode} = 'r';
    } elsif ((-e $file) && (-r $file)) {
        $obj->{_file} = $file;
        $obj->{_mode} = 'r';
    } elsif (!(-e $file)) {
        $obj->{_file}   = $file;
        $obj->{_mode}   = 'w';
        $obj->{_tmpdir} = File::Temp->newdir(TEMPLATE => 'mt_archive_XXXX', DIR => MT->config->TempDir);
    }
    bless $obj, $pkg;
    $obj;
}

sub find_bin {
    my $self = shift;
    if (ref $self) {
        if ($self->{_mode} eq 'r') {
            return $self->find_unzip;
        } else {
            return $self->find_zip;
        }
    }
    return unless $self->find_zip;
    return unless $self->find_unzip;
    return 1;
}

sub find_zip {
    my $class = shift;
    return $BinZipPath if defined $BinZipPath;
    for my $path (MT->config->BinZipPath, '/usr/local/bin/zip', '/usr/bin/zip') {
        next unless $path;
        return $BinZipPath = $path if -e $path;
    }
    return $class->error(MT->translate('Cannot find external archiver: [_1]', 'zip'));
}

sub find_unzip {
    my $class = shift;
    return $BinUnzipPath if defined $BinUnzipPath;
    for my $path (MT->config->BinUnzipPath, '/usr/local/bin/unzip', '/usr/bin/unzip') {
        next unless $path;
        return $BinUnzipPath = $path if -e $path;
    }
    return $class->error(MT->translate('Cannot find external archiver: [_1]', 'unzip'));
}

sub flush {
    my $obj = shift;

    return undef if 'w' ne $obj->{_mode};
    return undef if $obj->{_flushed};

    my $bin  = $obj->find_bin or return;
    my $file = $obj->{_file};

    my $tmpdir = $obj->{_tmpdir};

    my $list = join "\n", @{ $obj->{_files} || [] };

    require Cwd;
    my $cwd = Cwd::cwd;
    chdir $tmpdir;
    my @cmds = ($bin, "-r", $file, '-@');
    eval { IPC::Run3::run3(\@cmds, \$list) };
    my $error = $@;
    chdir $cwd;
    return $obj->error(MT->translate('Failed to create an archive [_1]: [_2]', $file, $error)) if $error;
    delete $obj->{_files};

    if ($file !~ /\.zip\z/ && -e "$file.zip") {
        rename "$file.zip" => $file or return $obj->error(MT->translate('Failed to rename an archive [_1]: [_2]', $file, $!));
    }
    $obj->{_flushed} = 1;
}

sub close {
    my $obj = shift;

    $obj->flush or return;

    $obj->{_file} = undef;
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
    my ($obj, @opts) = @_;
    my $bin = $obj->find_unzip or return;

    my $file = $obj->{_file};
    my @cmds = ($bin, "-Z", "-1", @opts, $file);
    my $out;
    eval { IPC::Run3::run3(\@cmds, undef, \$out) };
    return $obj->error('Failed to list files of [_1]: [_2]', $file, $@) if $@;
    return unless defined $out;
    my @lines = split /\n/, $out;
    return @lines unless @opts;

    shift @lines;    # Archive: ...
    shift @lines;    # Zip file size...
    pop @lines;      # total files;
    my @modified;
    for my $line (@lines) {
        my @items = split /\s+/, $line;
        my $perm  = $items[0];
        my $file  = $items[-1];
        if (substr($perm, 0, 1) eq 'l') {
            $file .= ' -> link';
        }
        push @modified, $file;
    }
    return @modified;
}

sub is_safe_to_extract {
    my $obj = shift;

    for my $file ($obj->files("-s")) {
        if ($file =~ s/\s*\->.*\z//) {
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

    my $bin = $obj->find_unzip or return;

    my $file = $obj->{_file};
    my @cmds = ($bin, "-d", $path, $file);
    eval { IPC::Run3::run3(\@cmds) };
    return $obj->error('Failed to extract [_1]: [_2]', $obj->{_file}, $@) if $@;
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
    my $tmpfile = File::Spec->catfile($obj->{_tmpdir}, $file_path);
    my $dir     = File::Basename::dirname($tmpfile);
    File::Path::mkpath($dir) unless -d $dir;
    File::Copy::cp($filename, $tmpfile);
    push @{ $obj->{_files} ||= [] }, $file_path;
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
    my $tmpfile = File::Spec->catfile($obj->{_tmpdir}, $file_name);
    my $dir     = File::Basename::dirname($tmpfile);
    File::Path::mkpath($dir) unless -d $dir;
    open my $fh, '>:raw', $tmpfile;
    binmode $fh;
    print $fh $string;
    CORE::close $fh;
    push @{ $obj->{_files} ||= [] }, $file_name;
}

sub add_tree {
    my $obj = shift;
    my ($dir_path) = @_;
    return $obj->error(MT->translate('Cannot write to the object'))
        if 'r' eq $obj->{_mode};
    require File::Find;
    require File::Spec;
    my $sub = sub {
        my $file = $File::Find::name;
        return if -d $file;
        my $rel = File::Spec->abs2rel($file, $dir_path);
        $obj->add_file($dir_path, $rel);
    };
    File::Find::find({ wanted => $sub, no_chdir => 1, }, $dir_path);
}

1;
__END__

=head1 NAME

MT::Util::Archive::BinZip

=head1 SYNOPSIS

Zip compression and extraction package, based on MT::Util::Archive.
See I<MT::Util::Archive> for more details.
