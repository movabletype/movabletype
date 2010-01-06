# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::FileMgr::DAV;
use strict;

use MT::FileMgr;
@MT::FileMgr::DAV::ISA = qw( MT::FileMgr );

use MT;
use HTTP::DAV;

sub init {
    my $fmgr = shift;
    $fmgr->SUPER::init(@_);
    my $dav = $fmgr->{dav} = HTTP::DAV->new;
    $dav->get_user_agent->agent('MovableType/' . MT->version_id);
    $dav->credentials( -url => $_[0], -user => $_[1], -pass => $_[2] )
        or return $fmgr->error(MT->translate("DAV connection failed: [_1]", $dav->message));
    $dav->open( -url => $_[0] )
        or return $fmgr->error(MT->translate("DAV open failed: [_1]", $dav->message));
    $fmgr;
}

{
    my $Error;

    sub cb {
        my($status, $msg, $url, $so_far, $length, $data) = @_;
        if ($status == 0) {
            $Error = $msg;
        }
    }

    sub get_data {
        my $fmgr = shift;
        my($from, $type) = @_;
        my($data);
        undef $Error;
        $fmgr->{dav}->get(-url => $from, -to => \$data, -callback => \&cb )
            or return $fmgr->error(MT->translate("DAV get failed: [_1]", $Error));
        $data;
    }

    sub put {
        my $fmgr = shift;
        my($from, $to, $type) = @_;
        undef $Error;
        if ($fmgr->is_handle($from)) {
            ## Gather the data into a scalar, because currently
            ## HTTP::DAV::put only reads from disk or from 
            binmode($from);
            my $data;
            while (<$from>) {
                $data .= $_;
            }
            return $fmgr->put_data($data, $to, $type);
        } 
        $fmgr->{dav}->put(-local => $from, -url => $to, -callback => \&cb )
            or return $fmgr->error(MT->translate("DAV put failed: [_1]", $Error));
        -s $from;
    }

    sub put_data {
        my $fmgr = shift;
        my($data, $to, $type) = @_;
        undef $Error;
        $fmgr->{dav}->put(-local => \$data, -url => $to, -callback => \&cb )
            or return $fmgr->error(MT->translate("DAV put failed: [_1]", $Error));
        length($data);
    }

    sub delete {
        my $fmgr = shift;
        my ($path) = @_;
        $fmgr->{dav}->delete(-url => $path, -callback => \&cb)
            or return $fmgr->error(MT->translate("Deleting '[_1]' failed: [_2]", $path, $Error));
        1;
    }
}

sub exists {
    my $fmgr = shift;
    $fmgr->{dav}->propfind($_[0]) ? 1 : 0;
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
    my $dav = $fmgr->{dav};
    $path =~ s!/$!!;
    my @path = split(m!(?=/+)!, $path);
    my @dir;
    for my $piece (@path) {
        push @dir, $piece;
        my $this = join '/', @dir;
        unless ($fmgr->exists($this)) {
            $dav->mkcol($this)
                or return $fmgr->error(MT->translate("Creating path '[_1]' failed: [_2]", $this,
                    $dav->message));
        }
    }
    1;
}

sub rename {
    my $fmgr = shift;
    my($from, $to) = @_;
    $fmgr->{dav}->move(-url => $from, -dest => $to)
        or return $fmgr->error(MT->translate("Renaming '[_1]' to '[_2]' failed: [_3]", $from, $to,
            $fmgr->{dav}->message);
    1;
}

1;
