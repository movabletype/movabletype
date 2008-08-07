# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::FileMgr::SFTP;
use strict;

use MT::FileMgr;
@MT::FileMgr::SFTP::ISA = qw( MT::FileMgr );

use Net::SFTP;
use Net::SFTP::Constants qw( SSH2_FILEXFER_ATTR_PERMISSIONS );
use Net::SFTP::Attributes;

sub init {
    my $fmgr = shift;
    $fmgr->SUPER::init(@_);
    eval {
        $fmgr->{sftp} = Net::SFTP->new($_[0],
            user => $_[1],
            password => $_[2],
            debug => MT->config('NetSFTPDebug') || 0);
    };
    if ($@) {
        return $fmgr->error(MT->translate("SFTP connection failed: [_1]", $@));
    }
    $fmgr;
}

sub get_data {
    my $fmgr = shift;
    my($from, $type) = @_;
    my $data;
    eval {
        my $sftp = $fmgr->{sftp};
        $data = $sftp->get($from);
    };
    if ($@) {
        return $fmgr->error(MT->translate("SFTP get failed: [_1]", $@));
    }
    $data;
}

sub put {
    my $fmgr = shift;
    my($from, $to, $type) = @_;
    my $src;
    if ($fmgr->is_handle($from)) {
        ## Write the data out to a temporary file, because currently
        ## Net::SFTP::put only reads from disk.
        require File::Temp;
        my($fh, $temp) = File::Temp::tempfile();
        binmode($fh);
        binmode($from);
        while (<$from>) {
            print $fh $_;
        }
        close $fh;
        $src = $temp;
    } else {
        $src = $from;
    }
    my $size;
    eval {
        my $sftp = $fmgr->{sftp};
        $sftp->put($src, $to);
        my $attr = $sftp->do_stat($to);
        $size = $attr->size;
    };
    if ($@) {
        return $fmgr->error(MT->translate("SFTP put failed: [_1]", $@));
    }
    $size;
}

sub put_data {
    my $fmgr = shift;
    my($data, $to, $type) = @_;

    ## Write the data out to a temporary file, because currently
    ## Net::SFTP::put only reads from disk.
    require File::Temp;
    my($fh, $temp) = File::Temp::tempfile();
    binmode($fh);
    print $fh $data;
    close $fh;
    eval {
        $fmgr->{sftp}->put($temp, $to);
    };
    if ($@) {
        return $fmgr->error(MT->translate("SFTP put failed: [_1]", $@));
    }
    unlink($temp);
    length($data);
}

sub exists {
    my $fmgr = shift;
    my($path) = @_;
    my $exists;
    eval {
        local $SIG{__WARN__} = sub { };
        $exists = $fmgr->{sftp}->do_realpath($path) ? 1 : 0;
    };
    $exists;
}

sub can_write {
    my $fmgr = shift;
    my ($path) = @_;
    my $data = '1';
    my $to = $path . "/__$$\temp.tmp";
    $fmgr->put_data('1', $to) or return;
    $fmgr->delete($to) or return;
    1;
}

sub mkpath {
    my $fmgr = shift;
    my($path) = @_;
    eval {
        my $sftp = $fmgr->{sftp};
        $path =~ s!/$!!;
        my @path = split(m!(?=/+)!, $path);
        my @dir;
        my $a = Net::SFTP::Attributes->new;
        $a->flags($a->flags | SSH2_FILEXFER_ATTR_PERMISSIONS);
        $a->perm(0777);
        for my $piece (@path) {
            push @dir, $piece;
            $sftp->do_mkdir(join('', @dir), $a);
        }
    };
    if ($@) {
        return $fmgr->error(MT->translate("Creating path '[_1]' failed: [_2]", $path, $@));
    }
    1;
}

sub rename {
    my $fmgr = shift;
    my($from, $to) = @_;
    eval {
        $fmgr->{sftp}->do_rename($from, $to);
    };
    if ($@) {
        return $fmgr->error(MT->translate("Renaming '[_1]' to '[_2]' failed: [_3]", $from, $to, $@));
    }
    1;
}

sub delete {
    my $fmgr = shift;
    my ($path) = @_;
    $fmgr->{sftp}->do_remove($path)
        or return $fmgr->error(MT->translate("Deleting '[_1]' failed: [_2]", $path, $@));
    1;
}

sub DESTROY {
    $_[0]->{sftp}->close if $_[0]->{sftp} && $_[0]->{sftp}->can('close');
}

1;
