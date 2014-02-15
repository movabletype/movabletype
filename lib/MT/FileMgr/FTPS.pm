# Movable Type (r) (C) 2001-2014 Six Apart, Ltd. All Rights Reserved.
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

    my $verify = MT->config->FTPSSSLVerifyNone ? 0 : 1;
    my $mozilla_ca = eval { require Mozilla::CA; 1 };
    $options{SSL_Client_Certificate} = {
        SSL_verify_mode => $verify,
        ( $verify && $mozilla_ca )
        ? ( SSL_ca_file => Mozilla::CA::SSL_ca_file() )
        : (),
    };

    # Can change the arguments of Net::FTPSSL here.
    MT->run_callbacks(
        'init_ftps',
        host => $_[0],
        opts => \%options,
    );

    my $ftp = $fmgr->{ftp} = Net::FTPSSL->new( $_[0], %options )
        or return $fmgr->error("FTPS connection failed: $@");
    $ftp->login( @_[ 1, 2 ] );
    $fmgr;
}

1;
