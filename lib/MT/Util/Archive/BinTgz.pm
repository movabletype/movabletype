# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Util::Archive::BinTgz;

use strict;
use warnings;
use base qw( MT::ErrorHandler );

use constant ARCHIVE_TYPE => 'tgz';

use MT::FileMgr::Local;
use File::Copy     ();
use File::Temp     ();
use File::Path     ();
use File::Basename ();
use Encode;

our $BinTarPath;
our $HasIPCRun;

sub new {
    my $pkg = shift;
    my ($type, $file) = @_;

    $type =~ s/^bin//;
    return $pkg->error(MT->translate('Type must be tgz.'))
        unless $type eq ARCHIVE_TYPE;

    return unless $pkg->_has_ipc_run;

    my $obj = {};
    if (ref $file) {
        $obj->{_fh}   = $file;
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

sub _has_ipc_run {
    my $class = shift;
    return $HasIPCRun if defined $HasIPCRun;
    eval { require IPC::Run };
    if (my $err = $@) {
        $HasIPCRun = 0;
        return $class->error(MT->translate("Cannot load IPC::Run: [_1]", $err));
    }
    return $HasIPCRun = 1;
}

sub find_bin {
    my $class = shift;
    return $BinTarPath if defined $BinTarPath;
    return unless $class->_has_ipc_run;
    for my $path (MT->config->BinTarPath, '/usr/local/bin/tar', '/usr/bin/tar', '/bin/tar') {
        next unless $path;
        return $BinTarPath = $path if -e $path;
    }
    return $class->error(MT->translate('Cannot find external archiver: [_1]', 'tar'));
}

sub flush {
    my $obj = shift;

    return undef if 'w' ne $obj->{_mode};
    return undef if $obj->{_flushed};

    my $file = $obj->{_file};
    return $obj->error(MT->translate('File [_1] exists; could not overwrite.', $file))
        if -e $file;

    my $bin = $obj->find_bin or return;

    my $tmpdir = $obj->{_tmpdir};

    my $tmpfile = File::Temp::tempnam(MT->config->TempDir, 'mt_archive_list_');
    open my $fh, '>', $tmpfile;
    print $fh join "\n", @{ $obj->{_files} || [] };
    close $fh;

    require Cwd;
    my $cwd  = Cwd::cwd();
    my @cmds = ($bin, "-c", "-z", "-f", $file, "-C", "$tmpdir", "-T", $tmpfile);
    my $res  = IPC::Run::run(\@cmds, \my $in, \my $out, \my $err);
    chdir $cwd;
    unlink $tmpfile;
    $res or return $obj->error(MT->translate('Failed to create an archive [_1]: [_2]', $file, $?));
    delete $obj->{_files};
    $obj->{_flushed} = 1;
}

sub close {
    my $obj = shift;

    $obj->flush or return;

    $obj->{_fh}->close if exists $obj->{_fh};
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
    my ($obj, @flags) = @_;
    my $bin = $obj->find_bin or return;

    if (my $fh = $obj->{_fh}) {
        my $tmpfh = File::Temp->new(TEMPLATE => 'mt_archive_XXXX', TMPDIR => 1);
        $obj->{_tmpfh} = $tmpfh;
        $obj->{_file}  = $tmpfh->filename;
        my $pos = tell $fh;
        seek $fh, 0, 0;
        File::Copy::cp($fh, $tmpfh);
        seek $fh, $pos, 0;
    }

    my $file = $obj->{_file};
    my @cmds = ($bin, "-t", @flags, "-f", $file);
    IPC::Run::run(\@cmds, \my $in, \my $out, \my $err)
        or return $obj->error('Failed to list files of [_1]: [_2]', $file, $?);
    return unless defined $out;
    split /\n/, $out;
}

sub is_safe_to_extract {
    my $obj = shift;

    for my $item ($obj->files("-v")) {
        my ($mode, $usergroup, $size, $date, $time, $file) = split / +/, $item, 6;
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

    my $bin  = $obj->find_bin or return;
    my $file = $obj->{_file};
    my @opts = ("-x");
    push @opts, "-z" if $file =~ /gz$/;
    my @cmds = ($bin, @opts, "-C", $path, "-f", $file);
    IPC::Run::run(\@cmds, \my $in, \my $out, \my $err)
        or return $obj->error('Failed to extract [_1]: [_2]', $obj->{_file}, $?);
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
    my $filename = File::Spec->catfile($path,           $file_path);
    my $tmpfile  = File::Spec->catfile($obj->{_tmpdir}, $file_path);
    my $dir      = File::Basename::dirname($tmpfile);
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
    my $tmpfile = File::Spec->catfile($obj->{_tmpdir}, $file_name);
    my $dir     = File::Basename::dirname($tmpfile);
    File::Path::mkpath($dir) unless -d $dir;
    open my $fh, '>', $tmpfile;
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

MT::Util::Archive::BinTgz

=head1 SYNOPSIS

Zip compression and extraction package, based on MT::Util::Archive.
See I<MT::Util::Archive> for more details.
