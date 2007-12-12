# Movable Type (r) Open Source (C) 2001-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::FileMgr::Local;
use strict;

use MT::FileMgr;
@MT::FileMgr::Local::ISA = qw( MT::FileMgr );

use Symbol;
use Fcntl qw( :DEFAULT :flock );

sub get_data {
    my $fmgr = shift;
    my($from, $type) = @_;
    my($fh);
    if (!$fmgr->is_handle($from)) {
        $fh = gensym();
        open $fh, $from
            or return $fmgr->error(MT->translate(
                "Opening local file '[_1]' failed: [_2]", $from, "$!" ));
    } else {
        $fh = $from;
    }
    if ($type && $type eq 'upload') {
        binmode($fh);
    }
    my($data);
    { local $/; $data = <$fh>; }
    close $fh if !$fmgr->is_handle($from);
    $data;
}

## $type is either 'upload' or 'output'
sub put {
    my $fmgr = shift;
    my($from, $to, $type) = @_;
    my $rv;
    if (!$fmgr->is_handle($from)) {
        my $fh = gensym();
        open $fh, $from
            or return $fmgr->error(MT->translate(
                "Opening local file '[_1]' failed: [_2]", $from, "$!"));
        $rv = _write_file($fmgr, $fh, $to, $type);
        close $fh;
    } else {
        $rv = _write_file($fmgr, $from, $to, $type);
    }
    $rv;
}

*put_data = \&_write_file;

sub _write_file {
    my $fmgr = shift;
    my($from, $to, $type) = @_;
    local *FH;
    my($umask, $perms);
    my $cfg = MT->config;
    if ($type && $type eq 'upload') {
        $umask = $cfg->UploadUmask;
        $perms = $cfg->UploadPerms;
    } else {
        $umask = $cfg->HTMLUmask;
        $perms = $cfg->HTMLPerms;
    }
    my $old = umask(oct $umask);
    sysopen FH, $to, O_RDWR|O_CREAT|O_TRUNC, oct $perms
        or return $fmgr->error(MT->translate(
            "Opening local file '[_1]' failed: [_2]", $to, "$!"));
    if ($type && $type eq 'upload') {
        binmode(FH);
        binmode($from) if $fmgr->is_handle($from);
    }
    ## Lock file unless NoLocking specified.
    flock FH, LOCK_EX unless $cfg->NoLocking;
    seek FH, 0, 0;
    truncate FH, 0;
    my $bytes = 0;
    if ($fmgr->is_handle($from)) {
        while (my $len = read $from, my($block), 8192) {
            print FH $block;
            $bytes += $len;
        }
    } else {
        print FH $from;
        $bytes = length($from);
    }
    close FH;
    umask($old);
    $bytes;
}

sub exists { -e $_[1] }

sub can_write { -w $_[1] }

sub mkpath {
    my $fmgr = shift;
    my($path) = @_;
    require File::Path;
    my $umask = oct MT->config->DirUmask;
    my $old = umask($umask);
    eval { File::Path::mkpath([$path], 0, 0777) };
    return $fmgr->error($@) if $@;
    umask($old);
    1;
}

sub rename {
    my $fmgr = shift;
    my($from, $to) = @_;
    rename $from, $to
       or return $fmgr->error(MT->translate(
           "Renaming '[_1]' to '[_2]' failed: [_3]", $from, $to, "$!"));
    1;
}

sub content_is_updated {
    my $fmgr = shift;
    my($file, $content) = @_;
    return 1 unless -e $file;
    ## If the system has Digest::MD5, compare MD5 hashes; otherwise
    ## read in the file and compare the strings.
    my $fh = gensym();
    open $fh, $file or return 1;
    if (eval { require Digest::MD5; 1 }) {
        my $ctx = Digest::MD5->new;
        $ctx->addfile($fh);
        close $fh;
        my $data;
        if ($] >= 5.007003) {
            require Encode;
            $data = $$content;
            Encode::_utf8_off($data);
        } elsif ($] >= 5.006001) {
            $data = pack 'C0A*', $$content;
        } else {
            $data = $$content;
        }
        return $ctx->digest ne Digest::MD5::md5($data);
    } else {
        my $data;
        binmode $fh;
        while (read $fh, my($chunk), 8192) {
            $data .= $chunk;
        }
        close $fh;
        return $$content ne $data;
    }
}

sub delete {
    my $fmgr = shift;
    my ($file) = @_;

    return 1 unless -e $file or -l $file;
    unlink $file
       or return $fmgr->error(MT->translate(
           "Deleting '[_1]' failed: [_2]", $file, "$!"));
    1;
}

1;
__END__

=head1 NAME

MT::FileMgr::Local

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
