# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::FileMgr::FTP;
use strict;

use MT::FileMgr;
@MT::FileMgr::FTP::ISA = qw( MT::FileMgr );

use Net::FTP;

sub init {
    my $fmgr = shift;
    $fmgr->SUPER::init(@_);
    my %options = ();
    $options{Port} = $_[3] if $_[3];
    my $ftp = $fmgr->{ftp} = Net::FTP->new( $_[0], %options )
        or return $fmgr->error("FTP connection failed: $@");
    $ftp->login( @_[ 1, 2 ] );
    $fmgr;
}

sub get_data {
    my $fmgr = shift;
    my ( $from, $type ) = @_;
    if ( $type && $type eq 'upload' ) {
        $fmgr->{ftp}->binary;
    }
    else {
        $fmgr->{ftp}->ascii;
    }
    local *FH;
    tie *FH, 'MT::FileMgr::FTP::StringTie';
    {
        ## Turn off warnings when we make the get call, because
        ## Net::FTP::*::read adds a number to an unitialized value,
        ## and this causes a warning with perl -wT.
        local $^W = 0;
        $fmgr->{ftp}->get( $from, \*FH )
            or return $fmgr->error("FTP get failed: $@");
    }
    tied(*FH)->buffer;
}

sub put {
    my $fmgr = shift;
    my ( $from, $to, $type ) = @_;
    if ( $type && $type eq 'upload' ) {
        $fmgr->{ftp}->binary;
    }
    else {
        $fmgr->{ftp}->ascii;
    }
    $fmgr->{ftp}->put( $from, $to )
        or return $fmgr->error("FTP put failed: $@");
    $fmgr->{ftp}->size($to);
}

sub put_data {
    my $fmgr = shift;
    my ( $data, $to, $type ) = @_;
    if ( $type && $type eq 'upload' ) {
        $fmgr->{ftp}->binary;
    }
    else {
        $fmgr->{ftp}->ascii;
    }
    local *FH;
    tie *FH, 'MT::FileMgr::FTP::StringTie', $data;
    $fmgr->{ftp}->put( \*FH, $to )
        or return $fmgr->error("FTP put failed: $@");
    length($data);
}

sub exists {
    my $fmgr = shift;
    $fmgr->{ftp}->mdtm( $_[0] ) ? 1 : 0;
}

sub can_write {
    my $fmgr   = shift;
    my ($path) = @_;
    my $data   = '1';
    my $to     = $path . "/__$$\temp.tmp";
    $fmgr->put_data( '1', $to ) or return;
    $fmgr->delete($to) or return;
    1;
}

sub mkpath {
    my $fmgr = shift;
    my ($path) = @_;
    $fmgr->{ftp}->mkdir( $path, 1 )
        or return $fmgr->error(
        MT->translate( "Creating path '[_1]' failed: [_2]", $path, $@ ) );
    1;
}

sub rename {
    my $fmgr = shift;
    my ( $from, $to ) = @_;
    $fmgr->{ftp}->rename( $from, $to )
        or return $fmgr->error(
        MT->translate(
            "Renaming '[_1]' to '[_2]' failed: [_3]",
            $from, $to, $@
        )
        );
    1;
}

sub delete {
    my $fmgr = shift;
    my ($path) = @_;
    $fmgr->{ftp}->delete($path)
        or return $fmgr->error(
        MT->translate( "Deleting '[_1]' failed: [_2]", $path, $@ ) );
    1;
}

sub rmdir {
    my $fmgr = shift;
    my ($path) = @_;
    $fmgr->{ftp}->rmdir($path)
        or return $fmgr->error(
        MT->translate( "Deleting '[_1]' failed: [_2]", $path, $@ ) );
    1;
}

sub pwd {
    my $fmgr = shift;
    $fmgr->{ftp}->pwd();
}

sub list {
    my $fmgr = shift;
    my ($path) = @_;
    $fmgr->{ftp}->list($path);
}

sub DESTROY { $_[0]->{ftp}->quit if $_[0]->{ftp} }

package MT::FileMgr::FTP::StringTie;
use strict;

sub TIEHANDLE { bless { buf => $_[1], offset => 0 }, $_[0] }
sub FILENO {6}

sub READ {
    return unless length( $_[0]->{buf} ) > $_[0]->{offset};
    $_[1] = substr $_[0]->{buf}, $_[0]->{offset}, $_[2];
    $_[0]->{offset} = _min( length( $_[0]->{buf} ), $_[0]->{offset} + $_[2] );
}

sub WRITE {
    my $str
        = substr( $_[1], $_[3] ? $_[3] : 0, $_[2] ? $_[2] : length( $_[1] ) );
    $_[0]->{buf} .= $str;
    length($str);
}

sub PRINT {
    my $str
        = substr( $_[1], $_[3] ? $_[3] : 0, $_[2] ? $_[2] : length( $_[1] ) );
    $_[0]->{buf} .= $str;
    length($str);
}
sub BINMODE {1}
sub _min    { $_[0] < $_[1] ? $_[0] : $_[1] }
sub buffer  { $_[0]->{buf} }

1;
