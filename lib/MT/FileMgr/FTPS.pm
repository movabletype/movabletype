# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::FileMgr::FTPS;
use strict;

use MT::FileMgr::FTP;
@MT::FileMgr::FTPS::ISA = qw( MT::FileMgr::FTP );

use Net::FTPSSL;

sub init {
    my $fmgr    = shift;
    my %options = ();
    $options{Port} = $_[3] if $_[3];
    my $ftp = $fmgr->{ftp} = Net::FTPSSL->new( $_[0], %options )
        or return $fmgr->error("FTPS connection failed: $@");
    $ftp->login( @_[ 1, 2 ] );
    $fmgr;
}

1;
