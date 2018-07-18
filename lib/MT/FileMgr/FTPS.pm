# Movable Type (r) (C) 2001-2018 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::FileMgr::FTPS;
use strict;
use warnings;

use MT::FileMgr::FTP;
@MT::FileMgr::FTPS::ISA = qw( MT::FileMgr::FTP );

use Net::FTPSSL;

sub init {
    my $fmgr    = shift;
    my %options = ();
    $options{Port}  = $_[3] if $_[3];
    $options{Debug} = 1     if $MT::DebugMode;

    my $verify
        = ( MT->config->SSLVerifyNone || MT->config->FTPSSSLVerifyNone )
        ? 0
        : 1;
    my $mozilla_ca = eval { require Mozilla::CA; 1 };
    $options{SSL_Client_Certificate} = {
        SSL_verify_mode => $verify,
        SSL_version     => MT->config->SSLVersion
            || MT->config->FTPSSSLVersion
            || 'SSLv23:!SSLv3:!SSLv2',
        SSL_verifycn_name   => $_[0],
        SSL_verifycn_scheme => 'ftp',
        $mozilla_ca ? ( SSL_ca_file => Mozilla::CA::SSL_ca_file() ) : (),
    };

    # Overwrite the arguments of Net::FTPSSL.
    my $ftps_opts = MT->config->FTPSOptions;
    if ( ref($ftps_opts) eq 'HASH' && %$ftps_opts ) {
        %options = ( %options, %$ftps_opts );
    }

    my $ftp = $fmgr->{ftp} = Net::FTPSSL->new( $_[0], %options )
        or return $fmgr->error("FTPS connection failed: $@");
    $ftp->login( @_[ 1, 2 ] );
    $fmgr;
}

1;
