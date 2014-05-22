# File    : Net::FTPSSL
# Author  : cleach <cleach at cpan dot org>
# Created : 01 March 2005
# Version : 0.23
# Revision: $Id: FTPSSL.pm,v 1.24 2005/10/23 14:37:12 kral Exp $

package Net::FTPSSL;

use strict;
use warnings;

# Enforce a minimum version of this module or Net::FTPSSL hangs!
# If you plan on using ccc(), the minimum should be v1.18 instead!
use IO::Socket::SSL 1.08;

use vars qw( $VERSION @EXPORT $ERRSTR );
use base ( 'Exporter', 'IO::Socket::SSL' );
use IO::Socket::INET;
use Net::SSLeay::Handle;
use File::Basename;
use File::Copy;
use Time::Local;
use Sys::Hostname;
use Carp qw( carp croak );
use Errno qw/ EINTR /;

$VERSION = "0.23";
@EXPORT  = qw( IMP_CRYPT  EXP_CRYPT  CLR_CRYPT
               DATA_PROT_CLEAR  DATA_PROT_PRIVATE
               DATA_PROT_SAFE   DATA_PROT_CONFIDENTIAL
               CMD_INFO  CMD_OK      CMD_MORE    CMD_REJECT
               CMD_ERROR CMD_PROTECT CMD_PENDING );
$ERRSTR = "No Errors Detected Yet.";

# Command Channel Protection Levels
use constant IMP_CRYPT => "I";
use constant EXP_CRYPT => "E";       # Default
use constant CLR_CRYPT => "C";

# Data Channel Protection Levels
use constant DATA_PROT_CLEAR        => "C";   # Least secure!
use constant DATA_PROT_SAFE         => "S";
use constant DATA_PROT_CONFIDENTIAL => "E";
use constant DATA_PROT_PRIVATE      => "P";   # Default & most secure!

# Valid FTP Result codes
use constant CMD_INFO    => 1;
use constant CMD_OK      => 2;
use constant CMD_MORE    => 3;
use constant CMD_REJECT  => 4;
use constant CMD_ERROR   => 5;
use constant CMD_PROTECT => 6;
use constant CMD_PENDING => 0;

# File transfer modes
use constant MODE_BINARY => "I";
use constant MODE_ASCII  => "A";   # Default

# The Data Connection Setup Commands ...
# Passive Options ... (All pasive modes are currently supported)
use constant FTPS_PASV   => 1;    # Default mode ...
use constant FTPS_EPSV_1 => 2;    # EPSV 1 - Internet Protocol Version 4
use constant FTPS_EPSV_2 => 3;    # EPSV 2 - Internet Protocol Version 6
# Active Options ... (No active modes are currently supported)
use constant FTPS_PORT   => 4;
use constant FTPS_EPRT_1 => 5;    # EPRT 1 - Internet Protocol Version 4
use constant FTPS_EPRT_2 => 6;    # EPRT 2 - Internet Protocol Version 6

# Misc constants
use constant TRACE_MOD => 5;   # How many iterations between ".".  Must be >= 2.

# Primarily used while the call to new() is in scope!
my $FTPS_ERROR;


sub new {
  my $self         = shift;
  my $type         = ref($self) || $self;
  my $host         = shift;
  my $arg          = (ref ($_[0]) eq "HASH") ? $_[0] : {@_};

  # The hash to pass to start_ssl() ...
  my %ssl_args;

  # The main purpose of this option is to allow users to specify
  # client certificates when their FTPS server requires them.
  # This hash applies to both the command & data channels.
  # Tags specified here overrided normal options if any tags
  # conflict.  Any other use of this option is unsupported.
  # See IO::Socket::SSL for supported options.
  if (ref ($arg->{SSL_Client_Certificate}) eq "HASH") {
     %ssl_args = %{$arg->{SSL_Client_Certificate}}
  } elsif (ref ($arg->{SSL_Advanced}) eq "HASH") {
     %ssl_args = %{$arg->{SSL_Advanced}};       # Depreciated in v0.18
     print STDERR "SSL_Advanced has been depreciated, use SSL_Client_Certificate instead!\n";
  } else {
     # Stops the Man-In-The-Middle (MITM) security warning from start_ssl()
     # when it calls configure_SSL() in IO::Socket::SSL.
     # To plug that MITM security hole requires the use of certificates,
     # all that's being done here is supressing the warning.
     $ssl_args{SSL_verify_mode} = Net::SSLeay::VERIFY_NONE();
  }

  # Now onto processing the regular hash of arguments provided ...
  my $encrypt_mode = $arg->{Encryption} || EXP_CRYPT;
  my $port         = $arg->{Port}   || (($encrypt_mode eq IMP_CRYPT) ? 990 : 21);
  my $debug        = $arg->{Debug}  || 0;
  my $trace        = $arg->{Trace}  || 0;
  my $timeout      = $ssl_args{Timeout} || $arg->{Timeout} || 120;
  my $buf_size     = $arg->{Buffer} || 10240;
  my $data_prot    = ($encrypt_mode eq CLR_CRYPT) ? DATA_PROT_CLEAR
                                 : ($arg->{DataProtLevel} || DATA_PROT_PRIVATE);
  my $use_ssl      = $arg->{useSSL} || 0;
  my $die          = $arg->{Croak}  || $arg->{Die};
  my $pres_ts      = $arg->{PreserveTimestamp} || 0;
  my $use_logfile  = $debug && (defined $arg->{DebugLogFile} &&
                                $arg->{DebugLogFile} ne "");
  my $localaddr    = $ssl_args{LocalAddr} || $arg->{LocalAddr};
  my $pret         = $arg->{Pret} || 0;

  # Used to work arround some FTPS servers behaving badly!
  my $pasvHost     = $arg->{OverridePASV};
  my $fixHelp      = $arg->{OverrideHELP};

  # Used to emulate bug # 73115 (Expects an offset on where to insert "\n".
  my $emulate_bug  = $arg->{EmulateBug} || 0;   # Undocumented feature.


  # Determine where to write the Debug info to ...
  my $pv = sprintf ("%s  [%vd]", $], $^V);   # The version of perl!
  if ( $use_logfile ) {
     my $open_mode = ( $debug == 2 ) ? ">>" : ">";
     my $f = $arg->{DebugLogFile};
     unlink ( $f )  if ( -f $f && $open_mode ne ">>" );
     my $f_exists = (-f $f);
     open ( $FTPS_ERROR, "$open_mode $f" ) or
               _croak_or_return (undef, 1, 0,
                                 "Can't create debug logfile: $f ($!)");
     unless ( $f_exists ) {
        print $FTPS_ERROR "\nNet-FTPSSL Version: $VERSION\n\n";
        print $FTPS_ERROR "Perl: $pv,  OS: $^O\n\n";
     } else {
        print $FTPS_ERROR "\n\n";
     }
     $debug = 2;                  # Already know Debug is turned on ...
  } elsif ( $debug ) {
     $debug = 1;                  # Force to a specific Debug value ...

#    open ( $FTPS_ERROR, ">&STDERR" ) or
#              _croak_or_return (undef, 1, 0,
#                             "Can't attach the debug logfile to STDERR. ($!)");
#    $FTPS_ERROR->autoflush (1);

     print STDERR "\nNet-FTPSSL Version: $VERSION\n\n";
     print STDERR "Perl: $pv,  OS: $^O\n\n";
  }

  if ( $debug ) {
     _print_LOG (undef, "Server (port): $host ($port)\n\n");
     _print_LOG (undef, "Keys: (" . join ("), (", keys %${arg}) . ")\n");
     _print_LOG (undef, "Values: (" . join ("), (", values %${arg}) . ")\n\n");
  }

  # Determines if we die if we will also need to write to the error log file ...
  my $dbg_flg = $die ? ( $debug == 2 ? 1 : 0 ) : $debug;

  return _croak_or_return (undef, $die, $dbg_flg, "Host undefined")  unless $host;

  return _croak_or_return (undef, $die, $dbg_flg,
                           "Encryption mode unknown!  ($encrypt_mode)")
      if ( $encrypt_mode ne IMP_CRYPT && $encrypt_mode ne EXP_CRYPT &&
           $encrypt_mode ne CLR_CRYPT );

  return _croak_or_return (undef, $die, $dbg_flg,
                           "Data Channel mode unknown! ($data_prot)")
      if ( $data_prot ne DATA_PROT_CLEAR &&
           $data_prot ne DATA_PROT_SAFE &&
           $data_prot ne DATA_PROT_CONFIDENTIAL &&
           $data_prot ne DATA_PROT_PRIVATE );

  # We start with a clear connection, because I don't know if the
  # connection will be implicit or explicit or remain clear after all.
  my $socket;

  if (exists $arg->{ProxyArgs}) {
     # Establishing a Proxy Connection ...
     my %proxyArgs = %{$arg->{ProxyArgs}};

     $proxyArgs{'remote-host'} = $host;
     $proxyArgs{'remote-port'} = $port;

     eval {
        require Net::HTTPTunnel;    # So not everyone has to install this module ...

        $socket = Net::HTTPTunnel->new ( %proxyArgs );
     };
     if ($@) {
         return _croak_or_return (undef, $die, $dbg_flg, "Missing Perl Module Error:\n" . $@);
     }
     unless ( defined $socket ) {
        my $pmsg = ($proxyArgs{'proxy-host'} || "undef") . ":" . ($proxyArgs{'proxy-port'} || "undef");
        return _croak_or_return (undef, $die, $dbg_flg,
                                 "Can't open HTTPTunnel proxy connection! ($pmsg) to ($host:$port)");
     }
     ${*$socket}{myProxyArgs} = \%proxyArgs;

  } else {
     # Establishing a Direct Connection ...
     my %socketArgs = (  PeerAddr => $host,
                         PeerPort => $port,
                         Proto    => 'tcp',
                         Timeout  => $timeout
                      );
     $socketArgs{LocalAddr} = $localaddr  if (defined $localaddr);

     $socket = IO::Socket::INET->new ( %socketArgs )
                   or
            return _croak_or_return (undef, $die, $dbg_flg,
                                  "Can't open tcp connection! ($host:$port)");
     ${*$socket}{mySocketOpts} = \%socketArgs;
  }

  _my_autoflush ( $socket );

  ${*$socket}{debug} = $debug;
  ${*$socket}{Croak} = $die;

  my $obj;

  if ( $encrypt_mode eq CLR_CRYPT ) {
     # Catch the banner from the connection request ...
     return _croak_or_return ($socket)  unless ( response($socket) == CMD_OK );

     # Leave the command channel clear for regular FTP.
     $obj = $socket;
     bless ( $obj, $type );
     ${*$obj}{_SSL_opened} = 0;      # To get rid of warning on quit ...

  } else {
     # Determine the SSL_version to use ...
     my $mode = $use_ssl ? "SSLv23" : "TLSv1";

     # Determine the options to use in start_SSL() ...
     # ------------------------------------------------------------------------
     # Only SSL_version & Timeout are supported.  All others are unsupported.
     # Doing this merge as a courtesy, so the regular options can be overridden
     # by the SSL_Client_Certificate functionality.
     # ------------------------------------------------------------------------
     if (defined $ssl_args{SSL_version}) {
        $mode = $ssl_args{SSL_version};        # Mode was overridden.
        $use_ssl = ( $mode !~ m/^TLSv1$/i );   # Reset in case it conflicts ...
     } else {
        $ssl_args{SSL_version} = $mode;        # Nothing overridden.
     }
     $ssl_args{Timeout} = $timeout  unless (exists $ssl_args{Timeout});
     # ------------------------------------------------------------------------

     if ( $encrypt_mode eq EXP_CRYPT ) {
        # Catch the banner from the connection request ...
        return _croak_or_return ($socket) unless (response ($socket) == CMD_OK);

        # In explicit mode FTPSSL sends an AUTH TLS/SSL command, catch the msgs
        command( $socket, "AUTH", ($use_ssl ? "SSL" : "TLS") );
        return _croak_or_return ($socket) unless (response ($socket) == CMD_OK);
     }

     # Now transform the clear connection into a SSL one on our end.
     $obj = $type->start_SSL( $socket, %ssl_args )
               or return _croak_or_return ( $socket, undef,
                                      "$mode: " . IO::Socket::SSL::errstr () );

     if ( $encrypt_mode eq IMP_CRYPT ) {
        # Catch the banner from the implicit connection request ...
        return $obj->_croak_or_return ()  unless ( $obj->response() == CMD_OK );
     }
  }


  # --------------------------------------
  # Check if overriding "_help()" ...
  # --------------------------------------
  if ( defined $fixHelp ) {
     my %helpHash;

     if ( ref ($fixHelp) eq "ARRAY" ) {
        foreach (@{$fixHelp}) {
          $helpHash{uc($_)} = 1;
        }
     } elsif ( $fixHelp ) {
       ${*$obj}{OverrideHELP} = 1;   # All FTP commands supported ...
     }

     # Set the "cache" tags used by "_help()" so that it can still be called!
     ${*$obj}{help_cmds_found} = \%helpHash;
     ${*$obj}{help_cmds_msg} = "214 HELP Command Overriden by request.";

     # Will always return false for supported("SITE", "xxx") ...
     ${*$obj}{help_SITE_msg} = ${*$obj}{help_cmds_msg};

     # Causes direct calls to _help($cmd) to skip the server hit.
     ${*$obj}{help_cmds_no_syntax_available} = 1;
  }
  # --------------------------------------
  # End overriding "_help()" ...
  # --------------------------------------

  # These options control the behaviour of the Net::FTPSSL class ...
  ${*$obj}{Host}         = $host;
  ${*$obj}{Crypt}        = $encrypt_mode;
  ${*$obj}{debug}        = $debug;
  ${*$obj}{trace}        = $trace;
  ${*$obj}{buf_size}     = $buf_size;
  ${*$obj}{type}         = MODE_ASCII;
  ${*$obj}{data_prot}    = $data_prot;
  ${*$obj}{Croak}        = $die;
  ${*$obj}{FixPutTs}     = ${*$obj}{FixGetTs} = $pres_ts;
  ${*$obj}{OverridePASV} = $pasvHost;
  ${*$obj}{dcsc_mode}    = FTPS_PASV;
  ${*$obj}{Pret}         = $pret;
  ${*$obj}{EmulateBug}   = $emulate_bug;

  ${*$obj}{ftpssl_filehandle} = $FTPS_ERROR  if ( $debug == 2 );
  $FTPS_ERROR = undef;

  # Must be last for certificates to work correctly ...
  if ( (ref ($arg->{SSL_Client_Certificate}) eq "HASH") ||
       (ref ($arg->{SSL_Advanced}) eq "HASH") ) {
     # Reuse the command channel context ...
     my %ssl_reuse = ( SSL_reuse_ctx => ${*$obj}{_SSL_ctx} );
     ${*$obj}{myContext}   = \%ssl_reuse;
  }

  # Print out the details of the SSL object.  It's TRUE only for debugging!
  if ( $debug ) {
     $obj->_debug_print_hash ( $host, $port, $encrypt_mode );
  }

  return $obj;
}

#-----------------------------------------------------------------------
# TODO:  Adding ACCT (Account) support (response 332 [CMD_MORE] on password)

sub login {
  my ( $self, $user, $pass ) = @_;

  ${*$self}{_hide_value_in_response_} = $user;
  ${*$self}{_mask_value_in_response_} = "++++++";

  my $logged_on = $self->_test_croak ( $self->_user ($user) &&
                                       $self->_passwd ($pass) );

  delete ( ${*$self}{_hide_value_in_response_} );
  delete ( ${*$self}{_mask_value_in_response_} );

  if ( $logged_on ) {
     $self->supported ("HELP");     # So help is always called early instead of later.

     if ( ${*$self}{FixPutTs} && ! $self->supported ("MFMT") ) {
        ${*$self}{FixPutTs} = 0;    # Not supported by this server after all!
     }
     if ( ${*$self}{FixGetTs} && ! $self->supported ("MDTM") ) {
        ${*$self}{FixGetTs} = 0;    # Not supported by this server after all!
     }
  }

  return ( $logged_on );
}

#-----------------------------------------------------------------------

sub quit {
  my $self = shift;
  $self->_quit() or return 0;   # Don't do a croak here, since who tests?
  _my_close ($self);            # Old way $self->close();
  $self->_close_LOG ()  if ( ${*$self}{debug} );
  return 1;
}

sub force_epsv {
  my $self = shift;
  my $epsv_mode = shift || "1";

  unless ($epsv_mode eq "1" || $epsv_mode eq "2") {
    return $self->croak_or_return (0, "Invalid IP Protocol Flag ($epsv_mode)");
  }

  # Don't resend the command to the FTPS server if it was sent before!
  if ( ${*$self}{dcsc_mode} != FTPS_EPSV_1 &&
       ${*$self}{dcsc_mode} != FTPS_EPSV_2 ) {
    unless ($self->command ("EPSV", "ALL")->response () == CMD_OK) {
       return $self->_croak_or_return ();
    }
  }

  # Now that only EPSV is supported, remember which one was requested ...
  # You can no longer swap back to PASV, PORT or EPRT.
  ${*$self}{dcsc_mode} = ($epsv_mode eq "1") ? FTPS_EPSV_1 : FTPS_EPSV_2;

  # Now check out if the requested EPSV mode was actually supported ...
  unless ($self->command ("EPSV", $epsv_mode)->response () == CMD_OK) {
     return $self->_croak_or_return ();
  }

  # So the server will release the returned port!
  $self->_abort();

  return (1);    # Success!
}

sub _pasv {
  my $self = shift;
  # Leaving the other arguments on the stack (for use by PRET if called)

  my ($host, $port) = ("", "");

  if ( ${*$self}{Pret} ) {
     unless ( $self->command ("PRET", @_)->response () == CMD_OK ) {
        $self->_croak_or_return ();
        return ($host, $port);
     }
  }

  unless ( $self->command ("PASV")->response () == CMD_OK ) {
     if ( ${*$self}{Pret} ) {
        # Prevents infinite recursion on failure if PRET is already set ...
        $self->_croak_or_return ();

     } elsif ( $self->last_message () =~ m/(^|\s)PRET($|[\s.!?])/i ) {
        # Turns PRET on for all future calls to _pasv()!
        # Stays on even if it still doesn't work with PRET!
        ${*$self}{Pret} = 1;
        $self->_print_DBG ("<<+ Auto-adding PRET option!\n");
        ($host, $port) = $self->_pasv (@_);

     } else {
        $self->_croak_or_return ();
     }

     return ($host, $port);
  }

  # [227] [Entering Passive Mode] ([h1,h2,h3,h4,p1,p2]).
  my $msg = $self->last_message ();
  unless ($msg =~ m/(\d+)\s(.*)\(((\d+,?)+)\)\.?/) {
     $self->_croak_or_return (0, "Can't parse the PASV response.");
     return ($host, $port);
  }

  my @address = split( /,/, $3 );

  $host = join( '.', @address[ 0 .. 3 ] );
  $port = $address[4] * 256 + $address[5];

  if ( ${*$self}{OverridePASV} ) {
     my $ip = $host;
     $host = ${*$self}{OverridePASV};
     $self->_print_DBG ( "--- Overriding PASV IP Address $ip with $host\n" );
  }

  return ($host, $port);
}

sub _epsv {
  my $self = shift;
  my $ipver = shift;

  $self->command ("EPSV", ($ipver == FTPS_EPSV_1) ? "1" : "2");
  unless ( $self->response () == CMD_OK ) {
     $self->_croak_or_return ();
     return ("", "");
  }

  # [227] [Entering Extended Passive Mode] (|||<port>|).
  my $msg = $self->last_message ();
  unless ($msg =~ m/[(](.)(.)(.)(\d+)(.)[)]/) {
     $self->_croak_or_return (0, "Can't parse the EPSV response.");
     return ("", "");
  }

  my ($s1, $s2, $s3, $port, $s4) = ($1, $2, $3, $4, $5);

  # By definition, EPSV must use the same host for the DC as the CC.
  return (${*$self}{Host}, $port);
}

sub prep_data_channel {
  my $self = shift;
  # Leaving other arguments on the stack (for use by PRET if called via PASV)

  # Should only do this for encrypted Command Channels.
  if ( ${*$self}{Crypt} ne CLR_CRYPT ) {
     $self->_pbsz();
     unless ($self->_prot()) { return $self->_croak_or_return (); }
  }

  # Determine what host/port pairs to use for the data channel ...
  my $mode = ${*$self}{dcsc_mode};
  my ($host, $port);
  if ( $mode == FTPS_PASV ) {
     ($host, $port) = $self->_pasv (@_);
  } elsif ( $mode == FTPS_EPSV_1 || $mode == FTPS_EPSV_2 ) {
     ($host, $port) = $self->_epsv ($mode);
  } else {
     my $err = ($mode == FTPS_PORT ||
                $mode == FTPS_EPRT_1 || $mode == FTPS_EPRT_2)
                   ? "Active FTP mode ($mode)"
                   : "Unknown FTP mode ($mode)";
     return $self->_croak_or_return (0, "Currently doesn't support $err when requesting the data channel port to use!");
  }

  $self->_print_DBG ("--- Host ($host)  Port ($port)\n");

  # Already decided not to call croak earlier if this happens.
  return (0)   if ($host eq "" || $port eq "");

  # Returns if the data channel was established or not ...
  return ( $self->_open_data_channel ($host, $port) );
}

sub _open_data_channel {
  my $self = shift;
  my $host = shift;
  my $port = shift;

  # Warning: also called by t/10-complex.t func check_for_pasv_issue(),
  # so verify still works there if any significant changes are made here.

  # We don't care about any context features here, only in _get_data_channel().
  # You can't apply these features until after the command using the data
  # channel has been sent to the FTPS server and the FTPS server responds
  # to the socket you are creating below!

  my $msg = "";
  my %proxyArgs;
  if (exists ${*$self}{myProxyArgs} ) {
     %proxyArgs = %{${*$self}{myProxyArgs}};
     $msg = ($proxyArgs{'proxy-host'} || "undef") . ":" . ($proxyArgs{'proxy-port'} || "undef");

     # Update the host & port to connect to through the proxy server ...
     $proxyArgs{'remote-host'} = $host;
     $proxyArgs{'remote-port'} = $port;
  }

  my $socket;

  if ( ${*$self}{data_prot} eq DATA_PROT_PRIVATE ) {
     if (exists ${*$self}{myProxyArgs} ) {
        # Set the proxy paramters for all future data connections ...
        Net::SSLeay::set_proxy ( $proxyArgs{'proxy-host'}, $proxyArgs{'proxy-port'},
                                 $proxyArgs{'proxy-user'}, $proxyArgs{'proxy-pass'} );
        $msg = " (via proxy $msg)";
     }

# carp "MSG=($msg)\n" . "proxyhost=($Net::SSLeay::proxyhost--$Net::SSLeay::proxyport)\n" . "auth=($Net::SSLeay::proxyauth--$Net::SSLeay::CRLF)\n";

     $socket = Net::SSLeay::Handle->make_socket( $host, $port )
               or return $self->_croak_or_return (0,
                      "Can't open private data connection to $host:$port $msg");

# carp "Socket Created!\n";

  } elsif ( ${*$self}{data_prot} eq DATA_PROT_CLEAR && exists ${*$self}{myProxyArgs} ) {
     $socket = Net::HTTPTunnel->new ( %proxyArgs ) or
             return $self->_croak_or_return (0,
                   "Can't open HTTP Proxy data connection tunnel from $msg to $host:$port");

  # } elsif ( ${*$self}{data_prot} eq DATA_PROT_CLEAR && exists ${*$self}{mySocketOpts} ) {
  } elsif ( ${*$self}{data_prot} eq DATA_PROT_CLEAR ) {
     my %socketArgs = %{${*$self}{mySocketOpts}};
     $socketArgs{PeerAddr} = $host;
     $socketArgs{PeerPort} = $port;

     $socket = IO::Socket::INET->new( %socketArgs ) or
                  return $self->_croak_or_return (0,
                             "Can't open clear data connection to $host:$port");

  } else {
     # TODO: Fix so DATA_PROT_SAFE & DATA_PROT_CONFIDENTIAL work.
     return $self->_croak_or_return (0, "Currently doesn't support mode ${*$self}{data_prot} for data channels to $host:$port");
  }

  ${*$self}{data_ch} = \*$socket;  # Must call _get_data_channel() before using.

  return 1;   # Data Channel was established!
}

sub _get_data_channel {
   my $self = shift;

   # $self->_debug_print_hash ("host", "port", ${*$self}{data_prot}, ${*$self}{data_ch});

   my $io;
   if ( ${*$self}{data_prot} eq DATA_PROT_PRIVATE && exists (${*$self}{myContext}) ) {
      my %ssl_opts = %{${*$self}{myContext}};
      my $mode = $ssl_opts{SSL_version};

      $io = IO::Socket::SSL->start_SSL ( ${*$self}{data_ch}, \%ssl_opts )
               or return $self->_croak_or_return ( 0,
                                      "$mode: " . IO::Socket::SSL::errstr () );

   } elsif ( ${*$self}{data_prot} eq DATA_PROT_PRIVATE ) {
      $io = IO::Handle->new ();
      tie ( *$io, "Net::SSLeay::Handle", ${*$self}{data_ch} );

   } elsif ( ${*$self}{data_prot} eq DATA_PROT_CLEAR ) {
      $io = ${*$self}{data_ch};

   } else {
      # TODO: Fix so DATA_PROT_SAFE & DATA_PROT_CONFIDENTIAL work.
      return $self->_croak_or_return (0, "Currently doesn't support mode ${*$self}{data_prot} for data channels.");
   }

   _my_autoflush ( $io );

   # $self->_debug_print_hash ("host", "port", ${*$self}{data_prot}, $io);

   return ( $io );
}

# Note: This doesn't reference $self on purpose! (so not a bug!) See Bug Id 82094
sub _my_autoflush {
   my $skt = shift;

   if ( $skt->can ('autoflush') ) {
      $skt->autoflush (1);
   } else {
      # So turn it on manually instead ...
      my $oldFh = select $skt;
      $| = 1;
      select $oldFh;
   }

   return;
}

# Note: This doesn't reference $self on purpose! (so not a bug!) See Bug Id 82094
sub _my_close {
   my $io = shift;

   if ( $io->can ('close') ) {
      $io->close ();
   } else {
      close ($io);
   }

   return;
}

sub nlst {
  my $self = shift;

  return ( $self->list (@_) );
}

# Returns an empty array on failure ...

sub list {
  my $self = shift;
  my $path = shift || undef;     # Causes "" to be treated as "."!
  my $pattern = shift || undef;  # Only wild cards are * and ? (same as ls cmd)

  my $dati = "";

  # "(caller(1))[3]" returns undef if not called by another Net::FTPSSL method!
  my $c = (caller(1))[3];
  my $nlst_flg = ( defined $c && $c eq "Net::FTPSSL::nlst" );

  unless ( $self->prep_data_channel( $nlst_flg ? "NLST" : "LIST" ) ) {
    return ();    # Already decided not to call croak if you get here!
  }

  unless ( $nlst_flg ? $self->_nlst($path) : $self->_list($path) ) {
     $self->_croak_or_return ();
     return ();
  }

  my ( $tmp, $io, $size );

  $size = ${*$self}{buf_size};

  $io = $self->_get_data_channel ();
  unless ( defined $io ) {
     return ();   # Already decided not to call croak if you get here!
  }

  while ( my $len = sysread $io, $tmp, $size ) {
    unless ( defined $len ) {
      next if $! == EINTR;
      my $type = $nlst_flg ? 'nlst()' : 'list()';
      $self->_croak_or_return (0, "System read error on read while $type: $!");
      _my_close ($io);    # Old way $io->close();
      return ();
    }
    $dati .= $tmp;
  }

  _my_close ($io);    # Old way $io->close();

  # To catch the expected "226 Closing data connection."
  if ( $self->response() != CMD_OK ) {
     $self->_croak_or_return ();
     return ();
  }

  # Convert to use local separators ...
  # Required for callback functionality ...
  $dati =~ s/\015\012/\n/g;

  # Remove that pesky total that isn't returned from all FTPS servers.
  # This way we are consistant for everyone!
  # Another reason to strip it out is that it's the total block size,
  # not the total number of files.  Which gets confusing.
  # Works no matter where the total is in the string ...
  unless ( $nlst_flg ) {
     $dati =~ s/^\n//s   if ( $dati =~ s/^\s*total\s+\d+\s*$//mi );
     $dati =~ s/\n\n/\n/s;    # In case total not 1st line ...
  }

  # What if we asked to use patterns to limit the listing returned ?
  if ( defined $pattern ) {
     my $p = $pattern;   # So can display original pattern later on.

     # Convert from shell wild cards into a perl regular expression ...
     $pattern =~ s/([.+])/\\$1/g;
     $pattern =~ s/[?]/./g;

     if ( $nlst_flg ) {
        if ( $pattern =~ m/[*]/ ) {
           # Don't allow path separators in the string ...
           # Can't do this with regular expressions ...
           $pattern = join ( "[^\\\\/]*", split (/\*/, $pattern . "XXX") );
           $pattern =~ s/XXX$//;
        }
        $pattern = '(^|[\\\\/])' . $pattern . '$';

     } else {
        $pattern =~ s/[*]/\\S*/g;    # No spaces in file's name is allowed!
        $pattern = '\s+(' . $pattern . ')($|\s+->\s+)';
     }

     $self->_print_DBG ( "PATTERN: <- $p => $pattern ->\n" );

     # Now only keep those files that match the pattern.
     my @res;
     foreach ( split ( /\n/, $dati ) ) {
        push (@res, $_)  if ( $_ =~ m/$pattern/i );
     }
     $dati = join ("\n", @res);
  }

  my $len = length ($dati);
  my $lvl = $nlst_flg ? 2 : 1;
  my $total = 0;

  if ( $len > 0 ) {
     $total = $self->_call_callback ($lvl, \$dati, \$len, 0);
  }

  # Process trailing call back info if present.
  my $trail;
  ($trail, $len, $total) = $self->_end_callback ($lvl, $total);
  if ( $trail ) {
     $dati .= $trail;
  }

  return $dati ? split( /\n/, $dati ) : ();
}

sub _get_local_file_size {
  my $self      = shift;
  my $file_name = shift;

  # Return the trivial cases ...
  return (0) unless ( -f $file_name);
  return (-s $file_name) if ( ${*$self}{type} eq MODE_BINARY );

  # If we get here, we know we are transfering the file in ASCII mode ...
  my $fd;
  unless ( open( $fd, "< $file_name" ) ) {
     return $self->_croak_or_return(0,
                             "Can't open file in ASCII mode! ($file_name) $!");
  }

  my ($len, $offset) = (0, 0);
  my $data;
  my $size = ${*$self}{buf_size} || 2048;

  while ( $len = sysread ( $fd, $data, $size ) ) {
    # print STDERR "Line: ($len, $data)\n";
    $data =~ s/\n/\015\012/g;
    $len = length ($data);
    $offset += $len;
  }

  unless ( defined $len ) {
    unless ( $! == EINTR ) {
       return $self->_croak_or_return (0,
                                "System read error on calculating OFFSET: $!");
    }
  }

  close ($fd);

  return ($offset);
}

sub _get_local_file_truncate {
  my $self      = shift;
  my $file_name = shift;
  my $offset    = shift;    # Value > 0.

  my $max_offset = $self->_get_local_file_size ( $file_name );
  return (undef)  unless ( defined $offset );

  if ( $offset > $max_offset ) {
    return $self->_croak_or_return (0,
                "OFFSET ($offset) is larger than the local file ($max_offset)");
  }

  # Exactly the size of the file ...
  return ( $offset )  if ( $offset == $max_offset );

  # It's smaller & non-zero, so now we must truncate the local file ...
  my $fd;
  unless ( open( $fd, "+< $file_name" ) ) {
     return $self->_croak_or_return(0,
                        "Can't open file in read/write mode! ($file_name): $!");
  }

  my $pos = 0;
  if ( ${*$self}{type} eq MODE_BINARY ) {
     unless ( binmode $fd ) {
      return $self->_croak_or_return(0, "Can't set binary mode to local file!");
     }
     $pos = $offset;

  } else {
     # ASCII Mode ...
     # For some OS, $off & $pos are always the same,
     # while for other OS they differ once the 1st <CR>
     # was hit!
     my ($len, $off) = (0, 0);
     my $data;
     my $size = ${*$self}{buf_size} || 2048;

     $size = $offset  if ( $size > $offset );

     while ( $len = sysread ( $fd, $data, $size ) ) {
       # print STDERR "Line: ($len, $data)\n";
       my $cr_only = ($data eq "\n");
       $data =~ s/\n/\015\012/g;
       $off += length ($data);
       my $diff = $offset - $off;

       # The offset was between the \015 & \012
       # (Bogus for a lot of OS, so must fix offset one char smaller.)
       if ( $diff == -1 && $cr_only ) {
          my $old = $offset--;
          $self->_print_DBG ("<<+ 222 HOT FIX  ==> Offset ($old ==> $offset) "
                             . "Since can't truncate between \\015 & \\012 "
                             . "in ASCII mode!\n");
          # Use the last $pos value, no need to recalculate it ...
          last;
       }

       # Found the requested offset ...
       if ( $diff == 0 ) {
          $pos = sysseek ( $fd, 0, 1 );  # Current position in the file
          last;
       }

       # Still more data to read ...
       if ( $diff > 0 ) {
          $pos = sysseek ( $fd, 0, 1 );  # Current position in the file
          $size = $diff  if ( $size > $diff );

       # Read past my offset value ... So re-read the last line again
       # with a smaller buffer size!
       } else {
          $pos = sysseek ( $fd, $pos, 0 );  # The previous position in the file
          $off -= length ($data);
          $size += $diff;    # Diff is negative here ...
       }

       last  unless ($pos);
     }  # End while ...

     unless ( defined $len ) {
       unless ( $! == EINTR ) {
          return $self->_croak_or_return (0,
                                "System read error on calculating OFFSET: $!");
       }
     }
  }   # End else ASCII ...

  unless ($pos) { 
     return $self->_croak_or_return (0,
                                "System seek error before Truncation: $!");
  }

  unless ( truncate ( $fd, $pos ) ) {
     return $self->_croak_or_return (0, "Truncate File Error: $!");
  }

  close ( $fd );

  return ( $offset );
}

sub get {
  my $self     = shift;
  my $file_rem = shift;
  my $file_loc = shift;
  my $offset   = shift || ${*$self}{net_ftpssl_rest_offset} || 0;

  # Clear out this messy restart() cluge for next time ...
  delete ( ${*$self}{net_ftpssl_rest_offset} );

  if ( $offset < -1 ) {
    return $self->_croak_or_return(0, "Invalid file offset ($offset)!");
  }

  my ( $size, $localfd );
  my $close_file = 0;

  unless ($file_loc) {
    $file_loc = basename($file_rem);
  }

  $size = ${*$self}{buf_size} || 2048;

  if ( ref($file_loc) && ref($file_loc) eq "GLOB" ) {
    if ( $offset == -1 ) {
      return $self->_croak_or_return(0,
                            "Invalid file offset ($offset) for a file handle!");
    }
    $localfd = \*$file_loc;

  } else {
    # Calculate the file offset to send to the FTPS server via REST ...
    if ($offset == -1) {
      $offset = $self->_get_local_file_size ($file_loc);
      return (undef)  unless (defined $offset);
    } elsif ($offset) {
      $offset = $self->_get_local_file_truncate ($file_loc, $offset);
      return (undef)  unless (defined $offset);
    }

    # Now we can open the file we need to write to ...
    my $mode = ($offset) ? ">>" : ">";
    unless ( open( $localfd, "$mode $file_loc" ) ) {
      return $self->_croak_or_return(0,
                             "Can't create/open local file! ($mode $file_loc)");
    }
    $close_file = 1;
  }

  my $fix_cr_issue = 1;
  if ( ${*$self}{type} eq MODE_BINARY ) {
    unless ( binmode $localfd ) {
      if ( $close_file ) {
         close ($localfd);
         unlink ($file_loc) unless ($offset);
      }
      return $self->_croak_or_return(0, "Can't set binary mode to local file!");
    }
    $fix_cr_issue = 0;
  }

  unless ( $self->prep_data_channel( "RETR", $file_rem ) ) {
    if ( $close_file ) {
       close ($localfd);
       unlink ($file_loc) unless ($offset);
    }
    return undef;    # Already decided not to call croak if you get here!
  }

  # "(caller(1))[3]" returns undef if not called by another Net::FTPSSL method!
  my $c = (caller(1))[3];
  my $cb_idx = ( defined $c && $c eq "Net::FTPSSL::xget" ) ? 2 : 1;
  my $func = ( $cb_idx == 1 ) ? "get" : "xget";


  # Check if the "get" failed ...
  my $rest = ($offset) ? $self->_rest ($offset) : 1;
  unless ( $rest && $self->_retr($file_rem) ) {
     if ($close_file) {
        close ($localfd);
        unlink ($file_loc) unless ($offset);
     }

     if ( $offset && $rest ) {
        my $msg = $self->last_message ();
        $self->_rest (0);                  # Must clear out on failure!
        ${*$self}{last_ftp_msg} = $msg;    # Restore original error message!
     }

     return $self->_croak_or_return ();
  }

  my ( $data, $written, $io );

  $io = $self->_get_data_channel ();
  unless ( defined $io ) {
     if ( $close_file ) {
        close ($localfd);
        unlink ($file_loc) unless ($offset);
     }
     return undef;   # Already decided not to call croak if you get here!
  }

  print STDERR "$func() trace ."  if (${*$self}{trace});
  my $cnt = 0;
  my $prev = "";
  my $total = 0;
  my $len;

  while ( ( $len = sysread $io, $data, $size ) ) {
    unless ( defined $len ) {
      next if $! == EINTR;
      close ($localfd)  if ( $close_file );
      return $self->_croak_or_return (0, "System read error on $func(): $!");
    }

    if ( $fix_cr_issue ) {
       # What if the line only contained \015 ?  (^M)
       if ( $data eq "\015" ) {
          $prev .= "\015";
          next;
       }

       # What if this line was truncated? (Ends with \015 instead of \015\012)
       # Can't test with reg expr since m/(\015)$/s & m/(\015\012)$/s same!
       # Don't care if it was truncated anywhere else!
       my $last_char = substr ($data, -1);
       if ( $last_char eq "\015" ) {
          $data =~ s/^(.+).$/$prev$1/s;
          $prev = $last_char;
       }

       # What if the previous line was truncated?  But not this one.
       elsif ( $prev ne "" ) {
          $data = $prev . $data;
          $prev = "";
       }

       $data =~ s/\015\012/\n/g;
       $len = length ($data);
    }

    print STDERR "."  if (${*$self}{trace} && ($cnt % TRACE_MOD) == 0);
    ++$cnt;

    $total = $self->_call_callback ($cb_idx, \$data, \$len, $total);

    if ( $len > 0 ) {
       $written = syswrite $localfd, $data, $len;
       return $self->_croak_or_return (0, "System write error on $func(): $!")
             unless (defined $written);
    }
  }

  # Potentially write a last ASCII char to the file ...
  if ($prev ne "") {
    $len = length ($prev);
    $total = $self->_call_callback ($cb_idx, \$prev, \$len, $total);
    if ( $len > 0 ) {
       $written = syswrite $localfd, $prev, $len;
       return $self->_croak_or_return (0, "System write error on $func(prev): $!")
             unless (defined $written);
    }
  }

  # Process trailing "callback" info if returned.
  my $trail;
  ($trail, $len, $total) = $self->_end_callback ($cb_idx, $total);
  if ( $trail ) {
    $written = syswrite $localfd, $trail, $len;
    return $self->_croak_or_return (0, "System write error on $func(trail): $!")
          unless (defined $written);
  }

  print STDERR ". done! (" . $self->_fmt_num ($total) . " byte(s))\n"  if (${*$self}{trace});

  _my_close ($io);    # Old way $io->close();

  # To catch the expected "226 Closing data connection."
  if ( $self->response() != CMD_OK ) {
     close ($localfd)  if ( $close_file );
     return $self->_croak_or_return ();
  }

  if ( $close_file ) {
     close ($localfd);
     if ( ${*$self}{FixGetTs} ) {
        my $tm = $self->_mdtm ( $file_rem );
        utime ( $tm, $tm, $file_loc )  if ( $tm );
     }
  }

  return 1;
}


sub put {               # Regular put (STOR command)
  my $self = shift;
  my ($resp, $msg1, $msg2, $requested_file_name, $tm) = $self->_common_put (@_);

  if ( $resp && ${*$self}{FixPutTs} && defined $tm ) {
     $self->_mfmt ($tm, $requested_file_name);
  }

  return ( $resp );
}

sub append {            # Append put (APPE command)
  my $self = shift;
  my ($resp, $msg1, $msg2, $requested_file_name, $tm) = $self->_common_put (@_);

  if ( $resp && ${*$self}{FixPutTs} && defined $tm ) {
     $self->_mfmt ($tm, $requested_file_name);
  }

  return ( $resp );
}

sub uput {              # Unique put (STOU command)
  my $self = shift;
  my ($resp, $msg1, $msg2, $requested_file_name, $tm) = $self->_common_put (@_);

  # Now lets get the real name of the file generated!
  if ( $resp ) {
    # The file name may appear in either message returned.  (The 150 or 226 msg)
    # So lets check both messages merged together!
    my $msg = $msg1 . "\n" . $msg2;

    if ( $msg =~ m/(FILE|name):\s*([^\s)]+)($|[\s)])/im ) {
       $requested_file_name = $2;   # We found an actual name to use ...
    }

    # TODO: Figure out other uput variants to check for besides the ones above.

    # Until then, if we can't find the file name used in the messages,
    # we'll just have to assume that the default file name was used!

    # Now lets update the timestamp for that file on the server ...
    if ( ${*$self}{FixPutTs} && defined $tm ) {
       $self->_mfmt ($tm, $requested_file_name);
    }

    return ( $requested_file_name );
  }

  return ( undef );
}

# Makes sure the scratch file name generated appears in the same directory as
# the real file unless you provide a prefix with a directory as part of it.
sub _get_scratch_file {
   my $self    = shift;
   my $prefix  = shift;   # May include a path
   my $body    = shift;
   my $postfix = shift;
   my $file    = shift;   # The final file name to use (may include a path)

   # So we don't override "", which is OK for these 2 parts.
   $prefix  = "_tmp."  unless ( defined $prefix );
   $postfix = ".tmp"   unless ( defined $postfix );

   # Determine if we need to parse by OS or FTP path rules ... (get vs put)
   # And get default body to use if none was supplied or it's ""!
   my $c = (caller(1))[3];
   my $os;
   if ( defined $c && $c eq "Net::FTPSSL::xput" ) {
      $os = fileparse_set_fstype ("FTP");    # Follow Unix instead of OS rules.
      # Client Name + process PID ... Unique on remote server ...
      $body = $body || (hostname () . ".$$");
   } else {
      $os = fileparse_set_fstype ();         # Follow local OS rules.
      # reverse(Client Name) + process PID ... Unique on local server ...
      $body = $body || (reverse (hostname ()) . ".$$");
   }

   # Makes sure the scratch file and the final file will appear in the same
   # directory unless the user overrides the directory as part of the prefix!
   my ($base, $dir, $type) = fileparse ($file);
   if ( $base ne $file ) {
      # The file is not in the current direcory ...
      my ($pbase, $pdir, $ptype) = fileparse ($prefix);
      if ( $pbase eq $prefix ) {
         # Prefix has no path, so put it in the file's directory!
         $prefix = $dir . $prefix;
      }
   }

   # Return to the previously remembered OS rules again!  (Avoids side affects!)
   fileparse_set_fstype ($os);

   my $scratch_name = $prefix . $body . $postfix;

   if ( $scratch_name eq $file ) {
      return $self->_croak_or_return (0, "The scratch name and final name are the same!  ($file)  It's required that they must be different!" );
   }

   return ( $scratch_name );
}

sub xput {              # A variant of the regular put (STOR command)
   my $self = shift;
   my $file_loc = shift;
   my $file_rem = shift;

   # See _get_scratch_file() for the default values if undef!
   my ($prefix, $postfix, $body) = (shift, shift, shift);

   unless ($file_rem) {
     if ( ref($file_loc) && ref($file_loc) eq "GLOB" ) {
       return $self->_croak_or_return (0, "When you pass a stream, you must specify the remote filename.");
     }

     $file_rem = basename ($file_loc);
   }

   my $scratch_name = $self->_get_scratch_file ($prefix, $body, $postfix,
                                                $file_rem);
   return undef  unless ($scratch_name);

   my $help = $self->_help ();
   unless ( $help->{STOR} && $help->{DELE} && $help->{RNFR} && $help->{RNTO} ) {
      return $self->_croak_or_return (0, "Function xput is not supported by this server.");
   }

   # Now lets send the file.  Make sure we can't die during this process ...
   my $die = ${*$self}{Croak};
   ${*$self}{Croak} = 0;

   my ($resp, $msg1, $msg2, $requested_file_name, $tm) =
                              $self->_common_put ($file_loc, $scratch_name);

   if ( $resp ) {
     # Delete any file sitting on the server with the final name we want to use
     # to avoid file permission issues.  Usually the file won't exist so the
     # delete will fail ...
     $self->delete ( $file_rem );

     # Now lets make it visible to the file recognizer ...
     $resp = $self->rename ( $requested_file_name, $file_rem );

     # Now lets update the timestamp for the file on the server ...
     # It's not an error if the file recognizer grabs it before the
     # timestamp is reset ...
     if ( $resp && ${*$self}{FixPutTs} && defined $tm ) {
        $self->_mfmt ($tm, $file_rem);
     }
   }

   # Delete the scratch file on error, but don't return this as the error msg.
   # We want the actual error encounterd from the put or rename commands!
   unless ($resp) {
     $msg1 = ${*$self}{last_ftp_msg};
     $self->delete ( $scratch_name );
     ${*$self}{last_ftp_msg} = $msg1;
   }

   # Now allow us to die again if we must ...
   ${*$self}{Croak} = $die;

   return ( $self->_test_croak ( $resp ) );
}

sub xget {              # A variant of the regular get (RETR command)
   my $self     = shift;
   my $file_rem = shift;
   my $file_loc = shift;

   # See _get_scratch_file() for the default values if undef!
   my ($prefix, $postfix, $body) = (shift, shift, shift);

   unless ( $file_loc ) {
     $file_loc = basename ($file_rem);
   }

   if ( ref($file_loc) && ref($file_loc) eq "GLOB" ) {
      return $self->_croak_or_return (0, "xget doesn't support file_loc being an open file handle.");
   }

   my $scratch_name = $self->_get_scratch_file ( $prefix, $body, $postfix,
                                                 $file_loc );
   return undef  unless ($scratch_name);

   if (defined ${*$self}{net_ftpssl_rest_offset}) {
      return $self->_croak_or_return (0, "Can't call restart() before xget()!");
   }

   # In this case, we can die if we must, no required post work here ...
   my $resp = $self->get ( $file_rem, $scratch_name, undef );

   # Make it visisble to the local file recognizer on success ...
   if ( $resp ) {
      $self->_print_DBG ( "<<+ renamed $scratch_name to $file_loc\n" );
      unlink ( $file_loc );    # To avoid potential permission issues ...
      move ( $scratch_name, $file_loc ) or
           return $self->_croak_or_return (0, "Can't rename the local scratch file!");
   }

   return ( $self->_test_croak ( $resp ) );
}

sub _put_offset_fix {
  my $self     = shift;
  my $offset   = shift;
  my $len      = shift;
  my $data     = shift;

  # Determine if we can send any of this data to the server ...
  if ( $offset >= $len ) {
    # Can't send anything form the data buffer this time ...
    $offset -= $len;      # Result is >= 0
    $len = 0;
    $data = "";

  } elsif ( $offset ) {
    # Sending a partial data buffer, stripping off leading chars ...
    my $p = "." x $offset;
    $data =~ s/^$p//s;    # Use option "s" since $data has "\n" in it.
    $len -= $offset;      # Result is >= 0
    $offset = 0;
  }

  return ($offset, $len, $data);
}

sub _common_put {
  my $self     = shift;
  my $file_loc = shift;
  my $file_rem = shift;
  my $offset   = shift || ${*$self}{net_ftpssl_rest_offset} || 0;

  # Clear out this messy restart() cluge for next time ...
  delete ( ${*$self}{net_ftpssl_rest_offset} );

  if ( ref($file_loc) eq "GLOB" && ! $file_rem ) {
    return $self->_croak_or_return (0, "When you pass a stream, you must specify the remote filename.");
  }

  unless ($file_rem) {
    $file_rem = basename ($file_loc);
  }

  if ( $offset < -1 ) {
    return $self->_croak_or_return(0, "Invalid file offset ($offset)!");
  }

  # Find out which of 4 "put" functions called me ...
  my $func = (caller(1))[3] || ":unknown";
  $func =~ m/:([^:]+)$/;
  $func = $1;

  if ( $offset && $func ne "put" && $func ne "append" ) {
    return $self->_croak_or_return(0, "Function $func() doesn't support RESTart.");
  }

  if ( $offset == -1 ) {
    $offset = $self->size ($file_rem);
    unless ( defined $offset ) {
       return (undef);       # Already did croak test in size().
    }
  }

  my ( $size, $localfd );
  my $close_file = 0;

  $size = ${*$self}{buf_size} || 2048;

  if ( ref($file_loc) eq "GLOB" ) {
    $localfd = \*$file_loc;

  } else {
    unless ( open( $localfd, "< $file_loc" ) ) {
      return $self->_croak_or_return (0, "Can't open local file! ($file_loc)");
    }
    $close_file = 1;
  }

  my $fix_cr_issue = 1;
  if ( ${*$self}{type} eq MODE_BINARY ) {
    unless ( binmode $localfd ) {
      return $self->_croak_or_return(0, "Can't set binary mode to local file!");
    }
    $fix_cr_issue = 0;
  }

  # Set in case we require the use of the PRET command ...
  my $cmd = "";
  if ( $func eq "uput" ) {
     $cmd = "STOU";
  } elsif ( $func eq "xput" )  {
     $cmd = "STOR";
  } elsif ( $func eq "put" )  {
     $cmd = "STOR";
  } elsif ( $func eq "append" )  {
     $cmd = "APPE";
  }

  unless ( $self->prep_data_channel( $cmd, $file_rem ) ) {
    close ($localfd)  if ($close_file);
    return undef;    # Already decided not to call croak if you get here!
  }

  # If alloc_size is already set, I skip this part
  unless ( defined ${*$self}{alloc_size} ) {
    if ( $close_file && -f $file_loc ) {
      my $size = -s $file_loc;
      $self->alloc($size);
    }
  }

  delete ${*$self}{alloc_size};

  # Issue the correct "put" request ...
  my ($response, $restart) = (0, 1);
  if ( $func eq "uput" ) {
     $response = $self->_stou ($file_rem);
  } elsif ( $func eq "xput" )  {
     $response = $self->_stor ($file_rem);
  } elsif ( $func eq "put" )  {
     $restart = ($offset) ? $self->_rest ($offset) : 1;
     $response = $self->_stor ($file_rem);
  } elsif ( $func eq "append" )  {
     # Just uses OFFSET, doesn't send REST out.
     $response = $self->_appe ($file_rem);
  }

  # If the "put" request fails ...
  unless ($restart && $response) {
     close ($localfd)  if ($close_file);
     if ( $restart && $offset && $func eq "get" ) {
       $self->_rest (0);
     }
     return ( $self->_croak_or_return (), undef, undef, $file_rem, undef );
  }

  # The "REST" command doesn't affect file streams ...
  $offset = 0  unless ($close_file);

  my $put_msg = $self->last_message ();

  my ( $data, $written, $io );

  $io = $self->_get_data_channel ();
  unless ( defined $io ) {
     close ($localfd)  if ($close_file);
     return undef;   # Already decided not to call croak if you get here!
  }

  print STDERR "$func() trace ."  if (${*$self}{trace});
  my $cnt = 0;
  my $total = 0;
  my $len;

  while ( ( $len = sysread $localfd, $data, $size ) ) {
    unless ( defined $len ) {
      next if $! == EINTR;
      return $self->_croak_or_return (0, "System read error on $func(): $!");
    }

    $total = $self->_call_callback (2, \$data, \$len, $total);

    if ($fix_cr_issue) {
       $data =~ s/\n/\015\012/g;
       $len = length ($data);
    }

    # Determine if we can send any of this data to the server ...
    if ( $offset ) {
       ($offset, $len, $data) = $self->_put_offset_fix ( $offset, $len, $data );
    }

    print STDERR "."  if (${*$self}{trace} && ($cnt % TRACE_MOD) == 0);
    ++$cnt;

    if ( $len > 0 ) {
       $written = syswrite $io, $data, $len;
       return $self->_croak_or_return (0, "System write error on $func(): $!")
           unless (defined $written);
    }
  }    # End while sysread() loop!


  # Process trailing call back info if present.
  my $trail;
  ($trail, $len, $total) = $self->_end_callback (2, $total);
  if ( $trail ) {
    if ($fix_cr_issue) {
       $trail =~ s/\n/\015\012/g;
       $len = length ($trail);
    }

    # Determine if we can send any of this data to the server ...
    if ( $offset ) {
       ($offset, $len, $data) = $self->_put_offset_fix ( $offset, $len, $data );
    }

    if ( $len > 0 ) {
      $written = syswrite $io, $trail, $len;
      return $self->_croak_or_return (0, "System write error on $func(): $!")
           unless (defined $written);
    }
  }

  print STDERR ". done! (" . $self->_fmt_num ($total) . " byte(s))\n"  if (${*$self}{trace});

  my $tm;
  if ($close_file) {
     close ($localfd);
     if ( ${*$self}{FixPutTs} ) {
        $tm = (stat ($file_loc))[9];   # Get's the local file's timestamp!
     }
  }

  _my_close ($io);    # Old way $io->close();

  # To catch the expected "226 Closing data connection."
  if ( $self->response() != CMD_OK ) {
     return $self->_croak_or_return ();
  }

  return ( 1, $put_msg, $self->last_message (), $file_rem, $tm );
}


# On some servers this command always fails!  So no croak test!
# It's also why supported gets called.
# Just be aware of HELP issue (OverrideHELP option)
sub alloc {
  my $self = shift;
  my $size = shift;

  if ( $self->supported ("ALLO") &&
       $self->_alloc($size) ) {
    ${*$self}{alloc_size} = $size;
  }
  else {
    return 0;
  }

  return 1;
}

sub delete {
  my $self = shift;
  return ($self->_test_croak ($self->command("DELE", @_)->response == CMD_OK));
}

sub auth {
  my $self = shift;
  return ($self->_test_croak ($self->command("AUTH", "TLS")->response == CMD_OK));
}

sub pwd {
  my $self = shift;
  my $path;

  $self->command("PWD")->response();

  if ( ${*$self}{last_ftp_msg} =~ /\"(.*)\".*/ )
  {
    # 257 "/<PATH>/" is current directory.
    # "Quote-doubling" convention - RFC 959, Appendix II
    ( $path = $1 ) =~ s/\"\"/\"/g;
    return $path;
  }
  else {
    return $self->_croak_or_return ();
  }
}

sub cwd {
  my $self = shift;
  return ( $self->_test_croak ($self->command("CWD", @_)->response == CMD_OK) );
}

sub noop {
  my $self = shift;
  return ( $self->_test_croak ($self->command("NOOP")->response() == CMD_OK) );
}

sub rename {
  my $self     = shift;
  my $old_name = shift;
  my $new_name = shift;

  return ( $self->_test_croak ( $self->_rnfr ($old_name) &&
                                $self->_rnto ($new_name) ) );
}

sub cdup {
  my $self = shift;
  return ( $self->_test_croak ($self->command("CDUP")->response() == CMD_OK) );
}

# TODO: Make mkdir() working with recursion.
sub mkdir {
    my $self = shift;
    my $dir = shift;
    $self->command("MKD", $dir);
    return ( $self->_test_croak ($self->response == CMD_OK) );
}

# TODO: Make rmdir() working with recursion.
sub rmdir {
    my $self = shift;
    my $dir = shift;
    $self->command("RMD", $dir);
    return ( $self->_test_croak ($self->response == CMD_OK) );
}

sub site {
  my $self = shift;

  return ($self->_test_croak ($self->command("SITE", @_)->response == CMD_OK));
}

# A true boolean func, should never call croak!
sub supported {
   my $self = shift;
   my $cmd = uc (shift || "");
   my $sub_cmd = uc (shift || "");

   my $result = 0;        # Assume invalid FTP command

   # It will cache the result so OK to call multiple times.
   my $help = $self->_help ();

   # Only finds exact matches, no abbreviations like some FTP servers allow.
   if ( ${*$self}{OverrideHELP} || exists $help->{$cmd} ) {
      $result = 1;           # Was a valid FTP command
      ${*$self}{last_ftp_msg} = "214 The $cmd command is supported.";
   } else {
      ${*$self}{last_ftp_msg} = "502 Unknown command $cmd.";
   }

   # Are we validating a SITE sub-command?
   if ($result && $cmd eq "SITE" && $sub_cmd ne "") {
      my $help2 = $self->_help ($cmd);
      if ( exists $help2->{$sub_cmd} ) {
         ${*$self}{last_ftp_msg} = "214 The $cmd sub-command $sub_cmd is supported.";
      } else {
         ${*$self}{last_ftp_msg} = "502 Unknown $cmd sub-command - $sub_cmd.";
         $result = 0;     # It failed after all!
      }
   }

   # Are we validating a FEAT sub-command?
   if ($result && $cmd eq "FEAT" && $sub_cmd ne "") {
      my $feat2 = $self->_feat ();
      if ( exists $feat2->{$sub_cmd} ) {
         ${*$self}{last_ftp_msg} = "214 The $cmd sub-command $sub_cmd is supported.";
      } else {
         ${*$self}{last_ftp_msg} = "502 Unknown $cmd sub-command - $sub_cmd.";
         $result = 0;     # It failed after all!
      }
   }

   $self->_print_DBG ( "<<+ " . ${*$self}{last_ftp_msg} . "\n" );

   return ($result);
}

# The Clear Command Channel func is only valid after login.
sub ccc {
   my $self = shift;
   my $prot = shift || ${*$self}{data_prot};

   if ( ${*$self}{Crypt} eq CLR_CRYPT ) {
      return $self->_croak_or_return (undef, "Command Channel already clear!");
   }

   # Set the data channel to the requested security level ...
   # This command is no longer supported after the CCC command executes.
   unless ($self->_pbsz() && $self->_prot ($prot)) {
      return $self->_croak_or_return ();
   }

   # Do before the CCC command so we know which command is available to clear
   # out the command channel with.  All servers should support one or the other.
   my $ccc_fix_cmd = $self->supported ("NOOP") ? "NOOP" : "PWD";

   # Request that just the commnad channel go clear ...
   unless ( $self->command ("CCC")->response () == CMD_OK ) {
      return $self->_croak_or_return ();
   }
   ${*$self}{Crypt} = CLR_CRYPT;

   # Save before stop_SSL() removes the bless.
   my $bless_type = ref ($self);

   # -------------------------------------------------------------------------
   # Stop SSL, but leave the socket open!
   # Converts $self to IO::Socket::INET object instead of Net::FTPSSL
   # NOTE: SSL_no_shutdown => 1 doesn't work on some boxes, and when 0,
   #       it hangs on others without the SSL_fast_shutdown => 1 cmd.
   # -------------------------------------------------------------------------
   unless ( $self->stop_SSL ( SSL_no_shutdown => 0, SSL_fast_shutdown => 1 ) ) {
      return $self->_croak_or_return (undef, "Command Channel downgrade failed!");
   }

   # Bless back to Net::FTPSSL from IO::Socket::INET ...
   bless ( $self, $bless_type );
   ${*$self}{_SSL_opened} = 0;      # To get rid of warning on quit ...

   # -------------------------------------------------------------------------
   # This is a hack, but seems to resolve the command channel corruption
   # problem where 1st command or two afer CCC may fail or look strange ...
   # I've even caught it a few times sending back 2 independant OK responses
   # to a single command!
   # -------------------------------------------------------------------------
   my $ok = CMD_ERROR;
   foreach ( 1...3 ) {
      $ok = $self->command ($ccc_fix_cmd)->response ();
      last  if ( $ok == CMD_OK );
   }

   if ( $ok == CMD_OK ) {
      # Complete the hack, now force a failure response!
      # And if the server was still confused ?
      # Keep asking for responses until we get our error!
      $self->command ("xxxx");
      while ( $self->response () == CMD_OK ) {
         my $tmp = CMD_ERROR;   # A no-op command for loop body ...
      }
   }
   # -------------------------------------------------------------------------
   # End hack of CCC command recovery.
   # -------------------------------------------------------------------------

   return ( $self->_test_croak ( $ok == CMD_OK ) );
}


# Allow the user to send a FTP command directly, BE CAREFUL !!
# Since doing unsupported stuff, we can never call croak!
# Also not all unsupported stuff will show up in supported().

sub quot {
   my $self = shift;
   my $cmd  = shift;

   # Format the command for testing ...
   my $cmd2 = uc ($cmd || "");
   $cmd2 = $1  if ( $cmd2 =~ m/^\s*(\S+)(\s|$)/ );

   my $msg = "";   # Assume all is OK ...

   # The following FTP commands are known to open a data channel
   if ( $cmd2 eq "STOR" || $cmd2 eq "RETR" ||
        $cmd2 eq "NLST" || $cmd2 eq "LIST" ||
        $cmd2 eq "STOU" || $cmd2 eq "APPE" ) {
      $msg = "x23 Data Connections are not supported via quot().  [$cmd2]";

   } elsif ( $cmd2 eq "CCC" ) {
      $msg = "x22 Why didn't you call CCC directly via it's interface?";

   } elsif ( $cmd2 eq "" ) {
      $msg = "x21 Where is the needed command?";
   }

   if ( $msg ne "" ) {
      ${*$self}{last_ftp_msg} = $msg;
      substr (${*$self}{last_ftp_msg}, 0, 1) = CMD_REJECT;
      $self->_print_DBG ( "<<+ " . ${*$self}{last_ftp_msg} . "\n" );
      return (CMD_REJECT);
   }

   return ( $self->command ($cmd, @_)->response () );
}

#-----------------------------------------------------------------------
#  Type setting function
#-----------------------------------------------------------------------

sub ascii {
  my $self = shift;
  ${*$self}{type} = MODE_ASCII;
  return $self->_test_croak ($self->_type(MODE_ASCII));
}

sub binary {
  my $self = shift;
  ${*$self}{type} = MODE_BINARY;
  return $self->_test_croak ($self->_type(MODE_BINARY));
}

#-----------------------------------------------------------------------
#  Internal functions
#-----------------------------------------------------------------------

sub _user {
  my $self = shift;
  my $resp = $self->command ( "USER", @_ )->response ();
  return ( $resp == CMD_OK || $resp == CMD_MORE );
}

sub _passwd {
  my $self = shift;
  my $resp = $self->command ( "PASS", @_ )->response ();
  return ( $resp == CMD_OK || $resp == CMD_MORE );
}

sub _quit {
  my $self = shift;
  return ( $self->command ("QUIT")->response () == CMD_OK );
}

sub _prot {
  my $self = shift;
  my $opt = shift || ${*$self}{data_prot};

  # C, S, E or P.
  my $resp = ( $self->command ( "PROT", $opt )->response () == CMD_OK );

  # Check if someone changed the data channel protection mode ...
  if ($resp && $opt ne ${*$self}{data_prot}) {
    ${*$self}{data_prot} = $opt;   # They did change it!
  }

  return ( $resp );
}

# Depreciated, only present to make backwards compatible with v0.05 & earlier.
sub _protp {
  my $self = shift;
  return ($self->_prot (DATA_PROT_PRIVATE));
}

sub _pbsz {
  my $self = shift;
  return ( $self->command ( "PBSZ", "0" )->response () == CMD_OK );
}

sub _nlst {
  my $self = shift;
  return ( $self->command ( "NLST", @_ )->response () == CMD_INFO );
}

sub _list {
  my $self = shift;
  return ( $self->command ( "LIST", @_ )->response () == CMD_INFO );
}

sub _type {
  my $self = shift;
  return ( $self->command ( "TYPE", @_ )->response () == CMD_OK );
}

sub _rest {
  my $self = shift;
  return ( $self->command ( "REST", @_ )->response () == CMD_MORE );
}

sub _retr {
  my $self = shift;
  return ( $self->command ( "RETR", @_ )->response () == CMD_INFO );
}

sub _stor {
  my $self = shift;
  return ( $self->command ( "STOR", @_ )->response () == CMD_INFO );
}

sub _appe {
  my $self = shift;
  return ( $self->command ( "APPE", @_ )->response () == CMD_INFO );
}

sub _stou {
  my $self = shift;
  return ( $self->command ( "STOU", @_ )->response () == CMD_INFO );
}

sub _abort {
  my $self = shift;
  return ( $self->command ("ABOR")->response () == CMD_OK );
}

sub _alloc {
  my $self = shift;
  return ( $self->command ( "ALLO", @_ )->response () == CMD_OK );
}

sub _rnfr {
  my $self = shift;
  return ( $self->command ( "RNFR", @_ )->response () == CMD_MORE );
}

sub _rnto {
  my $self = shift;
  return ( $self->command ( "RNTO", @_ )->response () == CMD_OK );
}

sub mfmt {
  my $self = shift;
  $self->command( "MFMT", @_ );
  return ( $self->_test_croak ($self->response () == CMD_OK) );
}

sub _mfmt {
  my $self = shift;
  my $timestamp = shift;  # (stat ($loc_file))[9] - The local file's timestamp!

  # Convert it into YYYYMMDDHHMMSS format (GM Time) [ gmtime() vs localtime() ]
  my ($sec, $min, $hr, $day, $mon, $yr, $wday, $yday, $isdst) =
                  gmtime ( $timestamp );

  my $time = sprintf ("%04d%02d%02d%02d%02d%02d",
                      $yr + 1900, $mon + 1, $day, $hr, $min, $sec);

  return ( $self->command ( "MFMT", $time, @_ )->response () == CMD_OK );
}

sub mdtm {
  my $self = shift;

  my $gmt_time_str;

  $self->command( "MDTM", @_ );

  if ( $self->response () == CMD_OK &&
       ${*$self}{last_ftp_msg} =~ m/(^|\D)(\d{14})($|\D)/ ) {
    $gmt_time_str = $2;   # The timestamp on the remote server: YYYYMMDDHHMMSS.
  }

  return ( $self->_test_croak ($gmt_time_str) );  # In GMT time ...
}

sub _mdtm {
  my $self = shift;

  my $timestamp;

  if ( $self->command ("MDTM", @_)->response () == CMD_OK &&
       ${*$self}{last_ftp_msg} =~ m/(^|\D)(\d{14})($|\D)/ ) {
    my $time_str = $2;    # The timestamp on the remote server: YYYYMMDDHHMMSS.

    # Now convert it into the internal format used by Perl ...
    $time_str =~ m/^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$/;
    my ($yr, $mon, $day, $hr, $min, $sec) = ($1 - 1900, $2 - 1, $3, $4, $5, $6);

    # Use GMT Time  [ timegm() vs timelocal() ]
    $timestamp = timegm ( $sec, $min, $hr, $day, $mon, $yr );
  }

  return ( $timestamp );
}

sub size {
  my $self = shift;

  if ( $self->command ("SIZE", @_)->response () == CMD_OK &&
       ${*$self}{last_ftp_msg} =~ m/\d+\s+(\d+)($|\D)/ ) {
        return ( $1 );   # The size in bytes!  May be zero!
  }

  return ( $self->_test_croak (undef) );
}

#-----------------------------------------------------------------------
#  Checks what commands are available on the remote server
#-----------------------------------------------------------------------

sub _help {
   # Only shift off self, bug otherwise!
   my $self = shift;
   my $cmd = uc ($_[0] || "");   # Converts undef to "". (Do not do a shift!)

   # Check if requesting a list of all commands or details on specific commands.
   my $all_cmds = ($cmd eq "");
   my $site_cmd = ($cmd eq "SITE");

   my %help;

   # Only possible if _help() is called before 1st call to supported()!
   unless ( $all_cmds || exists ${*$self}{help_cmds_msg} ) {
      $self->_help ();
   }

   # Now see if we've cached the result previously ...
   if ($all_cmds && exists ${*$self}{help_cmds_msg}) {
      ${*$self}{last_ftp_msg} = ${*$self}{help_cmds_msg};
      my $hlp = ${*$self}{help_cmds_found};
      return ( (defined $hlp) ? $hlp : \%help );

   } elsif (exists ${*$self}{"help_${cmd}_msg"}) {
      ${*$self}{last_ftp_msg} = ${*$self}{"help_${cmd}_msg"};
      my $hlp = ${*$self}{"help_${cmd}_found"};
      return ( (defined $hlp) ? $hlp : \%help );

   } elsif ( exists ${*$self}{help_cmds_no_syntax_available} ) {
      ${*$self}{last_ftp_msg} = "503 Syntax for ${cmd} is not available.";
      # $self->_print_DBG ( "<<+ " . ${*$self}{last_ftp_msg} . "\n" );
      return ( \%help );
   }

   if ($all_cmds) {
      $self->command ("HELP");
   } else {
      $self->command ("HELP", @_);
   }

   # Now lets see if we need to parse the result to get a hash of the
   # supported FTP commands on the other server ...
   if ($self->response () == CMD_OK && ($all_cmds || $site_cmd)) {
      my $helpmsg = $self->last_message ();
      my @lines = split (/\n/, $helpmsg);

      foreach my $line (@lines) {
         # Strip off the code & separator or leading blanks if multi line.
         $line =~ s/(^[0-9]+[\s-]?)|(^\s+)//;
         my $lead = $1;

         next  if ($line eq "");

         # Skip over the start/end part of the response ...
         # Doesn't work for all servers!
         # next  if ( defined $lead && $lead =~ m/^\d+[\s-]?$/ );

         my @lst = split (/[\s,.]+/, $line);  # Break into individual commands

         if ( $site_cmd && $lst[0] eq "SITE" && $lst[1] =~ m/^[A-Z]+$/ ) {
            $help{$lst[1]} = 1;    # Each line: "SITE CMD mixed-case-usage"
         }
         # Now only process if nothing is in lower case (ie: its a comment)
         # All commands must be in upper case, some special chars not allowed.
         # Commands ending in "*" are currently turned off.
         elsif ( $line !~ m/[a-z()]/ ) {
            foreach (@lst) {
               $help{$_} = 1   if ($_ !~ m/[*]$/);
            }
         }
      }

      # If we don't find anything, it's a problem.  So don't cache if false ...
      if (scalar (keys %help) > 0) {
         if ($all_cmds) {
            if ($help{FEAT}) {
               # Add the assumed OPTS command required if FEAT is supported!
               # Even though not all servers support OPTS as is required with FEAT.
               $help{OPTS} = 1;       # RFC 2389

               # Now put any features into the help response as well ...
               my $feat = $self->_feat ();
               foreach (keys %{$feat}) {
                  $help{$_} = $feat->{$_}  unless ($help{$_});
               }
            }

            ${*$self}{help_cmds_found} = \%help;
            ${*$self}{help_cmds_msg} = $helpmsg;

         } elsif ( ${*$self}{help_cmds_msg} eq $helpmsg ) {
            # "HELP SITE" just repeated same HELP text as regular "HELP" cmd ...
            # So can't tell what SITE sub-commands are actually supported here.
            my %empty;
            %help = %empty;

            ${*$self}{last_ftp_msg} = ${*$self}{help_SITE_msg} =
                            "503 Site level help is not available.";
            $self->_print_DBG ( "<<+ " . ${*$self}{help_SITE_msg} . "\n" );
            ${*$self}{help_cmds_no_syntax_available} = 1;

         } else {
            # We got some useful SITE sub-commands to report on.
            ${*$self}{help_SITE_msg} = $helpmsg;
            ${*$self}{help_SITE_found} = \%help;
         }
      }

   } elsif ($all_cmds || $site_cmd) {
      # Got here when the "HELP" or "HELP SITE" commands failed ...
      $cmd = "cmds"  if ($all_cmds);
      ${*$self}{"help_${cmd}_msg"} = $self->last_message ();

   } else {
      # All other individual "HELP xxx" commands ...
      # (on some machines it returns cmd syntax)
      # You can only get here by calling _help("xxx") directly in your code!
      my $msg = $self->last_message ();
      if ( $msg eq ${*$self}{help_cmds_msg} ) {
         # Repeated the generic "HELP" response ...
         ${*$self}{last_ftp_msg} = ${*$self}{"help_${cmd}_msg"} =
                         "503 Syntax for ${cmd} is not available.";
         ${*$self}{help_cmds_no_syntax_available} = 1;
         $self->_print_DBG ( "<<+ " . ${*$self}{"help_${cmd}_msg"} . "\n" );
      } else {
         ${*$self}{"help_${cmd}_msg"} = $msg;
      }
   }

   return (\%help);
}

#-----------------------------------------------------------------------
# Returns the list of features supported by this server ...
#-----------------------------------------------------------------------

sub _feat {
   my $self = shift;

   my %res;

   # Check to see if we've cached the result previously ...
   # Must use slightly different nameing convenion than used
   # in _help() to avoid conflicts.
   if (exists ${*$self}{help_FEAT_msg2}) {
      ${*$self}{last_ftp_msg} = ${*$self}{help_FEAT_msg2};
      my $hlp = ${*$self}{help_FEAT_found2};
      return ( (defined $hlp) ? $hlp : \%res );
   }

   if ( $self->command ("FEAT")->response () == CMD_OK ) {
      my @lines = split (/\n/, $self->last_message ());

      foreach my $line (@lines) {
         # Strip off the code & separator or leading blanks if multi line.
         $line =~ s/(^[0-9]+[\s-]?)|(^\s+)//;
         my $lead = $1;

         # Skip over the start/end part of the response ...
         next if ( defined $lead && $lead =~ m/^\d+[\s-]?$/ );

         my @lst = split (/[\s,.]+/, $line);  # Break into individual parts

         $res{$lst[0]} = 2;    # Only 1st part is the command ...
      }

      # Cache the results from this command ...
      ${*$self}{help_FEAT_found2} = \%res;
   }

   # Cache the response from this command ...
   ${*$self}{help_FEAT_msg2} = $self->last_message ();

   return (\%res);
}

#-----------------------------------------------------------------------
#  Enable/Disable the Croak logic!
#  Returns the previous Croak setting!
#-----------------------------------------------------------------------

sub set_croak {
   my $self = shift;
   my $turn_on = shift;

   my $res = ${*$self}{Croak} || 0;

   if ( defined $turn_on ) {
      if ( $turn_on ) {
         ${*$self}{Croak} = 1;
      } elsif ( exists ( ${*$self}{Croak} ) ) {
         delete ( ${*$self}{Croak} );
      }
   }

   return ( $res );
}

#-----------------------------------------------------------------------
#  Boolean check for croak!
#  Uses the current message as the croak message on error!
#-----------------------------------------------------------------------

sub _test_croak {
   my $self = shift;
   my $true = shift;

   unless ( $true ) {
      $ERRSTR = ${*$self}{last_ftp_msg};
      if ( ${*$self}{Croak} ) {
         my $c = (caller(1))[3];
         if ( defined $c && $c ne "Net::FTPSSL::login" ) {
            $self->_abort ();
            $self->quit ();
            ${*$self}{last_ftp_msg} = $ERRSTR;
         }

         croak ( $ERRSTR . "\n" );
      }
   }

   return ( $true );
}

#-----------------------------------------------------------------------
#  Error handling - Decides if to Croak or return undef ...
#  Has 2 modes, a regular member func & when not a member func ...
#-----------------------------------------------------------------------

sub _croak_or_return {
   my $self = shift;

   # The error code to use if we update the last message!
   # Or if we print it to FTPS_ERROR & we don't croak!
   my $err = CMD_ERROR . CMD_ERROR . CMD_ERROR;

   unless (defined $self) {
      # Called this way only by new() before $self is created ...
      my $should_we_die = shift;
      my $should_we_print = shift;
      $ERRSTR = shift || "Unknown Error";

      _print_LOG ( undef, "<<+ $err " . $ERRSTR . "\n" ) if ( $should_we_print );
      croak ( $ERRSTR . "\n" )   if ( $should_we_die );

   } else {
      # Called this way as a memeber func by everyone else ...
      my $replace_mode = shift;  # 1 - append, 0 - replace,
                                 # undef - leave last_message() unchanged
      my $msg = shift;
      $ERRSTR = $msg || ${*$self}{last_ftp_msg};

      # Do 1st so updated if caller trapped the Croak!
      if ( defined $replace_mode && uc ($msg || "") ne ""  ) {
         if ($replace_mode && uc (${*$self}{last_ftp_msg} || "") ne "" ) {
            ${*$self}{last_ftp_msg} .= "\n" . $err . " " . $msg;
         } else {
            ${*$self}{last_ftp_msg} = $err . " " . $msg;
         }
      }

      if ( ${*$self}{Croak} ) {
         my $c = (caller(1))[3] || "";

         # Trying to prevent infinite recursion ...
         if ( ref($self) eq "Net::FTPSSL" &&
                    (! exists ${*$self}{_command_failed_}) &&
                    (! exists ${*$self}{recursion}) &&
                    $c ne "Net::FTPSSL::command" &&
                    $c ne "Net::FTPSSL::response" ) {
            ${*$self}{recursion} = "TRUE";
            my $tmp = ${*$self}{last_ftp_msg};
            $self->_abort ();
            $self->quit ();
            ${*$self}{last_ftp_msg} = $tmp;
         }

         # Only do if writing the message to the error log file ...
         if ( defined $replace_mode && uc ($msg || "") ne "" &&
              ${*$self}{debug} == 2 ) {
            _print_LOG ( $self, "<<+ $err " . $msg . "\n" );
         }

         croak ( $ERRSTR . "\n" );
      }

      # Handles both cases of writing to STDERR or the error log file ...
      if ( defined $replace_mode && uc ($msg || "") ne "" && ${*$self}{debug} ) {
         _print_LOG ( $self, "<<+ $err " . $msg . "\n" );
      }
   }

   return ( undef );
}

#-----------------------------------------------------------------------
# Messages handler
# -----------------------------------------------------------------------------
# Called by both Net::FTPSSL and IO::Socket::INET classes.
#-----------------------------------------------------------------------

sub command {
  my $self = shift;
  my @args;
  my $data;

  # Remove any previous failure ...
  delete ( ${*$self}{_command_failed_} );

  # remove undef values from the list.
  # Maybe I have to find out why those undef were passed.
  @args = grep defined($_), @_ ;

  $data = join( " ",
                map { /\n/
                      ? do { my $n = $_; $n =~ tr/\n/ /; $n }
                      : $_;
                    } @args
              );

  # Log the command being executed ...
  if ( ${*$self}{debug} ) {
     my $prefix = ( ref($self) eq "Net::FTPSSL" ) ? ">>> " : "SKT >>> ";
     if ( $data =~ m/^PASS\s/ ) {
        _print_LOG ( $self, $prefix . "PASS *******\n" ); # Don't echo passwords
     } elsif ( $data =~ m/^USER\s/ ) {
        _print_LOG ( $self, $prefix . "USER +++++++\n" ); # Don't echo user names
     } else {
        _print_LOG ( $self, $prefix . $data . "\n" );     # Echo everything else
     }
  }

  $data .= "\015\012";

  my $len = length $data;
  my $written = syswrite( $self, $data, $len );
  unless ( defined $written ) {
    ${*$self}{_command_failed_} = "ERROR";
    my $err_msg = "Can't write command on socket: $!";
    carp "$err_msg";                    # This prints a warning.
    _my_close ($self);                  # Old way $self->close();
    # Not called as an object member in case $self not a FTPSSL obj.
    _croak_or_return ($self, 0, $err_msg);
    return $self;  # Included here due to non-standard _croak_or_return() usage.
  }

  return $self;    # So can directly call response()!
}

# -----------------------------------------------------------------------------
# Some responses take multiple lines to finish. ("211-" [more] vs "211 " [done])
# Some responses have CR's embeded in them.  (ie: no code in the next line)
# Sometimes the data channel response comes with the open data connection msg.
#     (Especially if the data channel is not encrypted or the file is small.)
# So be careful, you will be blocked if you read past the last row of the
# current response or return the wrong code if you get into the next response!
#     (And will probably hang the next time response() is called.)
# So far the only thing I haven't seen is a call to sysread() returning a
# partial line response!  (Drat, that just happened!  See 0.20 Change notes.)
# -----------------------------------------------------------------------------
# Called by both Net::FTPSSL and IO::Socket::INET classes.
# -----------------------------------------------------------------------------
# Returns a single digit response code! (The CMD_* constants!)
# -----------------------------------------------------------------------------
sub response {
  my $self = shift;

  # Only continue if the command() call worked!
  # Otherwise on failure this method will hang!
  # We already printed out the failure message in command() if not croaking!
  return (CMD_ERROR)  if ( exists ${*$self}{_command_failed_} );

  ${*$self}{last_ftp_msg} = "";   # Clear out the message
  my $prefix = ( ref($self) eq "Net::FTPSSL" ) ? "<<< " : "SKT <<< ";

  my ( $data, $code, $sep, $desc ) = ( "", CMD_ERROR, "-", "" );

  while ($sep eq "-") {
     if ( exists ${*$self}{next_ftp_msg} ) {
        # The previous call to response() left behind some unprocessed data.
        # So lets use the left over data instead of calling sysread().
        $data = ${*$self}{next_ftp_msg};
        delete ( ${*$self}{next_ftp_msg} );   # No more left over data!
     } else {
        # Now lets read the response from the command channel.
        my $read = sysread( $self, $data, 4096);
        unless( $read ) {
          # Not called as an object member in case $self not a FTPSSL obj.
          _croak_or_return ($self, 0, (defined $read)
                                ? "Can't read command channel socket: $!"
                                : "Unexpected EOF on command channel socket: $!");
          return (CMD_ERROR);
        }
     }

     # Now lets process the response messages we've read in.  See the comments
     # above this function on why this code is such a mess.
     my @lines = split( "\015\012", $data );
     my $done = 0;
     my $remember = 0;

     foreach my $line ( @lines ) {
       if ( $remember ) {
          # Continuing to save the next response for next time ...
          _print_LOG ( $self, "Saving rest of the next response! ($line)\n" )  if ( ${*$self}{debug} );
          ${*$self}{next_ftp_msg} .= "\015\012" . $line;
          next;
       }

       if ( $done ) {
          # We read past the end of the current response into the next one ...
          _print_LOG ( $self, "Attempted to read past end of response! ($line)\n" )  if ( ${*$self}{debug} );
          ${*$self}{next_ftp_msg} = $line;
          $remember = 1;
          next;
       }

       # Check if the response is complete ...
       if ( $line =~ m/^(\d+)([-\s]?)(.*)$/s ) {
          ($code, $sep, $desc) = ($1, $2, $3);

          # Fix for bug # 73115 ...
          $sep = "-"  if (length ($code) < 3 && $sep eq "" and $desc eq "");
       }

       # Save the unedited message ...
       ${*$self}{last_ftp_msg} .= $line;

       if (${*$self}{debug}) {
          # Do we need to hide a value in the logged response ???
          if ( exists ${*$self}{_hide_value_in_response_} ) {
            my $val = _mask_regex_chars ($self, ${*$self}{_hide_value_in_response_});
            my $mask = ${*$self}{_mask_value_in_response_} || "????";
            $line =~ s/$val/<$mask>/g;
          }

          _print_LOG ( $self, $prefix . $line . "\n" );
       }

       if ( $sep eq '-' ) {
          ${*$self}{last_ftp_msg} .= "\n";       # Restore the internal <CR>.
       } else {
          $done = 1;            # The response is complete now.
       }
     }    # End for $line loop
  }       # End while $sep loop

  if (${*$self}{EmulateBug}) {
     # So I can test out the rest of the code by inserting random "\n" into
     # the response.  Bug # 73115 did this for the code above, but I also
     # needed to debug the rest of the class when this happened, and I don't
     # have a server that does this.
     my $tmp = "." x ${*$self}{EmulateBug};
     ${*$self}{last_ftp_msg} =~ s/^($tmp)/$1\n/;
     if ( ${*$self}{debug} ) {
        $tmp = substr( ${*$self}{last_ftp_msg}, 0, 1 );
        _print_LOG ( $self, "(start-bug-fix-start-bug-fix)\n" );
        _print_LOG ( $self, ${*$self}{last_ftp_msg} );
        _print_LOG ( $self, "\n========== ($tmp) ===========\n" );
     }
  }

  # Returns the 1st digit of the 3 digit status code!
  return substr( ${*$self}{last_ftp_msg}, 0, 1 );
}

sub last_message {
   my $self = shift;
   return ${*$self}{last_ftp_msg};
}

#-----------------------------------------------------------------------
# Not in POD on purpose.  It's an internal work arround for a debug issue.
#    Replace all chars known to cause issues with RegExp by putting
#    a "\" in front of it to remove the chars special meaning.
#    (less messy than putting it into square brackets ...)
#-----------------------------------------------------------------------
sub _mask_regex_chars {
   my $self = shift;
   my $mask = shift;

   $mask =~ s/([([?+*\\^$).])/\\$1/g;

   return ($mask);
}

#-----------------------------------------------------------------------
#  Added to make backwards compatible with Net::FTP
#-----------------------------------------------------------------------
sub message {
   my $self = shift;
   return ${*$self}{last_ftp_msg};
}

sub last_status_code {
   my $self = shift;

   my $code = CMD_ERROR;
   if ( defined ${*$self}{last_ftp_msg} ) {
      $code = substr (${*$self}{last_ftp_msg}, 0, 1);
   }

   return ($code);
}

sub restart {
   my $self = shift;
   my $offset = shift;
   ${*$self}{net_ftpssl_rest_offset} = $offset;
   return (1);
}

#-----------------------------------------------------------------------
# Implements data channel call back functionality ...
#-----------------------------------------------------------------------
sub set_callback {
   my $self = shift;
   my $func_ref = shift;          # The callback function to call.
   my $end_func_ref = shift;      # The end callback function to call.
   my $cb_work_area_ref = shift;  # Optional ref to the callback work area!

   if ( defined $func_ref && defined $end_func_ref ) {
      ${*$self}{callback_func}     = $func_ref;
      ${*$self}{callback_end_func} = $end_func_ref;
      ${*$self}{callback_data}     = $cb_work_area_ref;
   } else {
      delete ( ${*$self}{callback_func} );
      delete ( ${*$self}{callback_end_func} );
      delete ( ${*$self}{callback_data} );
   }

   return;
}

sub _end_callback {
   my $self = shift;
   my $offset = shift;   # Always >= 1.  Index to original function called.
   my $total = shift;

   my $res;
   my $len = 0;

   # Is there an end callback function to use ?
   if ( defined ${*$self}{callback_end_func} ) {
      $res = &{${*$self}{callback_end_func}} ( (caller($offset))[3], $total,
                                               ${*$self}{callback_data} );

      # Now check the results for terminating the call back.
      if (defined $res) {
         if ($res eq "") {
            $res = undef;      # Make it easier to work with.
         } else {
            $len = length ($res);
            $total += $len;
         }
      }
   }

   return ($res, $len, $total);
}

sub _call_callback {
   my $self = shift;
   my $offset = shift;   # Always >= 1.  Index to original function called.

   my $data_ref = shift;
   my $data_len_ref = shift;
   my $total_len = shift;

   # Is there is a callback function to use ?
   if ( defined ${*$self}{callback_func} ) {

      # Allowed to modify contents of $data_ref & $data_len_ref ...
      &{${*$self}{callback_func}} ( (caller($offset))[3],
                                    $data_ref, $data_len_ref, $total_len,
                                    ${*$self}{callback_data} );
   }

   # Calculate the new total length to use for next time ...
   $total_len += (defined $data_len_ref ? ${$data_len_ref} : 0);

   return ($total_len);
}

sub _fmt_num {
   my $self = shift;
   my $num = shift;

   # Change: 1234567890 --> 1,234,567,890
   while ( $num =~ s/(\d)(\d{3}(\D|$))/$1,$2/ ) { }

   return ( $num );
}

#-----------------------------------------------------------------------
# To assist in debugging the Certificate hash for this class ...
#-----------------------------------------------------------------------

sub _debug_print_hash
{
   my $self = shift;
   my $host = shift;
   my $port = shift;
   my $mode = shift;
   my $obj  = shift || $self;   # So can log any object type ...

   $self->_print_LOG ( "\nObject " . ref($obj) . " Details ..." );
   $self->_print_LOG ( " ($host:$port - $mode)" )  if (defined $host);
   $self->_print_LOG ( "\n" );

   foreach (sort keys %{*$obj}) {
      unless ( defined $host ) {
         next   unless ( m/^(io_|_SSL|SSL)/ );
      }
      my $val = ${*$obj}{$_};
      $val = "(undef)"  unless (defined $val);
      $val = join ("\n         ", split (/\n/, $val))  unless (ref($val));
      $self->_print_LOG ( "  $_ ==> $val\n" );
      if ($val =~ m/HASH\(0/) {
         foreach (sort keys %{$val}) {
           my $y = $val->{$_};
           $y = "(undef)"  unless (defined $y);
           $y = join ("\n                   ", split (/\n/, $y)) unless (ref($y));
           $self->_print_LOG ( "        -- $_ ===> $y\n" );
           if ($y =~ m/HASH\(0/) {
              foreach (sort keys %{$y}) {
                 my $z = $y->{$_};
                 $z = "(undef)"  unless (defined $z);
                 $z = join ("\n                       ", split (/\n/, $z)) unless (ref($z));
                 $self->_print_LOG ( "            -- $_ ----> $z\n" );
              }
           }
         }
      }
   }
   $self->_print_LOG ( "\n" );

   return;
}

#-----------------------------------------------------------------------
# Provided so each class instance gets its own log file to write to.
#-----------------------------------------------------------------------
# Always writes to the log when called ...
sub _print_LOG
{
   my $self = shift;
   my $msg = shift;

   if ( defined $self && exists ${*$self}{ftpssl_filehandle} ) {
      my $FILE = ${*$self}{ftpssl_filehandle};
      print $FILE $msg;          # Write to file ...
   } elsif ( defined $FTPS_ERROR ) {
      print $FTPS_ERROR $msg;    # Write to file when called during new() ...
   } else {
      print STDERR $msg;         # Write to screen anyone ?
   }
}

# Only write to the log if debug is turned on ...
# So we don't have to test everywhere ...
sub _print_DBG
{
   my $self = shift;
   if ( defined $self && ${*$self}{debug} ) {
     $self->_print_LOG ( @_ );   # Only if debug is turned on ...
   }
}

sub _close_LOG
{
  my $self = shift; 

  if ( defined $self && exists ${*$self}{ftpssl_filehandle} ) {
     my $FILE = ${*$self}{ftpssl_filehandle};
     close ($FILE);
     delete ( ${*$self}{ftpssl_filehandle} );
     # ${*$self}{debug} = 1;
  }
}

#-----------------------------------------------------------------------

1;

__END__

=head1 NAME

Net::FTPSSL - A FTP over SSL/TLS class

=head1 VERSION 0.23

=head1 SYNOPSIS

  use Net::FTPSSL;

  my $ftps = Net::FTPSSL->new('ftp.yoursecureserver.com', 
                              Encryption => EXP_CRYPT,
                              Debug => 1) 
    or die "Can't open ftp.yoursecureserver.com\n$Net::FTPSSL::ERRSTR";

  $ftps->login('anonymous', 'user@localhost') 
    or die "Can't login: ", $ftps->last_message();

  $ftps->cwd("/pub") or die "Can't change directory: " . $ftps->last_message();

  $ftps->get("file") or die "Can't get file: " . $ftps->last_message();

  $ftps->quit();

Had you included I<Croak =E<gt> 1> as an option to I<new>, you could have left
off the I<or die> checks and your I<die> messages would be more specific to the
actual problem encountered!

=head1 DESCRIPTION

C<Net::FTPSSL> is a class implementing a simple FTP client over a Secure
Sockets Layer (SSL) or Transport Layer Security (TLS) connection written in
Perl as described in RFC959 and RFC2228.  It will use TLS by default.

=head1 CONSTRUCTOR

=over 4

=item new( HOST [, OPTIONS ] )

Creates a new B<Net::FTPSSL> object and opens a connection with the
C<HOST>. C<HOST> is the address of the FTPS server and it's a required
argument. OPTIONS are passed in a hash like fashion, using key and value
pairs.  If you wish you can also pass I<OPTIONS> as a hash reference.

If it can't create a new B<Net::FTPSSL> object, it will return I<undef> unless
you set the I<Croak> option.  In either case you will find the cause of the
failure in B<$Net::FTPSSL::ERRSTR>.

C<OPTIONS> are:

B<Encryption> - The connection can be implicitly (B<IMP_CRYPT>) encrypted,
explicitly (B<EXP_CRYPT>) encrypted, or regular FTP (B<CLR_CRYPT>).
In explicit cases the connection begins clear and became encrypted after an
"AUTH" command is sent, while implicit starts off encrypted.  For B<CLR_CRYPT>,
the connection never becomes encrypted.  Default value is B<EXP_CRYPT>.

B<Port> - The I<port> number to connect to on the remote FTPS server.  The
default I<port> is 21 for B<EXP_CRYPT> and B<CLR_CRYPT>.  But for B<IMP_CRYPT>
the default I<port> is 990.  You only need to provide a I<port> if you need to
override the default value.

B<DataProtLevel> - The level of security on the data channel.  The default is
B<DATA_PROT_PRIVATE>, where the data is also encrypted. B<DATA_PROT_CLEAR> is
for data sent as clear text.  B<DATA_PROT_SAFE> and B<DATA_PROT_CONFIDENTIAL>
are not currently supported.  If B<CLR_CRYPT> was selected, the data channel
is always B<DATA_PROT_CLEAR> and can't be overridden.

B<useSSL> - Use this option to connect to the server using SSL instead of TLS.
TLS is the default encryption type and the more secure of the two protocols.
Set B<useSSL =E<gt> 1> to use SSL.

B<ProxyArgs> - A hash reference to pass to the proxy server.  When a proxy
server is encountered, this class uses I<Net::HTTPTunnel> to get through to
the server you need to talk to.  See I<Net::HTTPTunnel> for what values are
supported.  Options I<remote-host> and I<remote-port> are hard coded to the
same values as provided by I<HOST> and I<PORT> above and can not be overriden.

B<PreserveTimestamp> - During all I<puts> and I<gets>, attempt to preserve the
file's timestamp.  By default it will not preserve the timestamps.

B<Pret> - Set if you are talking to a distributed FTPS server like I<DrFtpd>
that needs a B<PRET> command issued before all calls to B<PASV>.  You only need
to use this option if the server barfs at the B<PRET> auto-detect logic.

B<Trace> - Turns on/off (1/0) put/get download tracing to STDERR.  The default
is off.

B<Debug> - This turns the debug tracing option on/off. Default is off. (0,1,2)

B<DebugLogFile> - Redirects the output of B<Debug> from F<STDERR> to the
requested error log file name.  This option is ignored unless B<Debug> is also
turned on.  Enforced this way for backwards compatibility.  If B<Debug> is set
to B<2>, the log file will be opened in I<append> mode instead of creating a
new log file.  This file is closed when I<quit> is called and B<Debug> messages
go back to F<STDERR> again afterwards.

B<Croak> - Force most methods to call I<croak()> on failure instead of returning
I<FALSE>.  The default is to return I<FALSE> or I<undef> on failure.  When it
croaks, it will attempt to close the FTPS connection as well, preserving the
last message before it attempts to close the connection.  Allowing the server
to know the client is going away.  This will cause I<$Net::FTPSSL::ERRSTR> to
be set as well.

B<SSL_Client_Certificate> - Expects a reference to a hash.  It's main purpose
is to allow you to use client certificates when talking to your I<FTPS> server.
Options here apply to the creation of the command channel.  And when a data
channel is needed later, it uses the B<SSL_reuse_ctx> option to reuse the
command channel's context.

See I<start_SSL()> in I<IO::Socket::SSL> for more details on this and other
options available besides those for certificates.  If an option provided via
this hash conflicts with other options we would normally use, the entries in
this hash take precedence.  If all you want to do is have the data channel use
B<SSL_reuse_ctx>, just provide an empty hash.

B<Buffer> - This is the block size that I<Net::FTPSSL> will use when a transfer
is made. Default value is 10240.

B<Timeout> - Set a connection timeout value. Default value is 120.

B<LocalAddr> - Local address to use for all socket connections, this argument
will be passed to all L<IO::Socket::INET> calls.

B<OverridePASV> - Some I<FTPS> servers sitting behind a firewall incorrectly
return their local IP Address instead of their external IP Address used
outside the firewall where the client is.  To use this option to correct this
problem, you must specify the correct host to use for the I<data channel>
connection.  This should usually match what you provided as the host!

B<OverrideHELP> - Some I<FTPS> servers on encrypted connections incorrectly send
back part of the response to the B<HELP> command in clear text instead of it all
being encrypted, breaking the command channel connection.  This class calls
B<HELP> internally via I<supported()> for some conditional logic, making a work
around necessary to be able to talk to such servers.

This option supports three distinct modes to support your needs.  You can pass
a reference to an array that lists all the B<FTP> commands your sever supports,
you can set it to B<1> to say all commands are supported, or set it to B<0> to
say none of the commands are supported.  See I<supported()> for more details.

This option can also be usefull when your server doesn't support the I<HELP>
command itself and you need to trigger some of the conditional logic.

B<SSL_Advanced> - Depreciated, use I<SSL_Client_Certificate> instead.  This is
now just an alias for I<SSL_Client_Certificate> for backwards compatibility.
If both are used, this option is ignored.

=back

=head1 METHODS

Most of the methods return I<true> or I<false>, true when the operation was
a success and false when failed. Methods like B<list> or B<nlst> return an
empty array when they fail.  This behavior can be modified by the B<Croak>
option.

=over 4

=item login( USER, PASSWORD )

Use the given information to log into the FTPS server.

=item quit()

This method breaks the connection to the FTPS server.  It will also close the
file pointed to by option I<DebugLogFile>.

=item force_epsv( [1/2] )

Used to force B<EPSV> instead of B<PASV> when establishing a data channel.
Once this method is called, it is imposible to swap back to B<PASV>.  This
method should be called as soon as possible after you log in if B<EPSV> is
required.

It does this by sending "B<EPSV ALL>" to the server.  Afterwards the server
will reject all B<EPTR>, B<PORT> and B<PASV> commands.

After "B<EPSV ALL>" is sent, it will attempt to verify your choice of IP
Protocol to use: B<1> or B<2> (v4 or v6).  The default is B<1>.  It will use
the selected protocol for all future B<EPSV> calls.  If you need to change which
protocol to use, you may call this function a second time to swap to the other
B<EPSV> Protocol.

This method returns true if it succeeds, or false if it fails.

=item set_croak( [1/0] )

Used to turn the I<Croak> option on/off after the I<Net::FTPSSL> object has been
created.  It returns the previous I<Croak> settings before the change is made.
If you don't provide an argument, all it does is return the current setting.
Provided in case the I<Croak> option proves to be too restrictive in some cases.

=item list( [DIRECTORY [, PATTERN]] )

This method returns a list of files in a format similar to this: (Server Specific)

 drwxrwx--- 1 owner group          512 May 31 11:16 .
 drwxrwx--- 1 owner group          512 May 31 11:16 ..
 drwxrwx--- 1 owner group          512 Oct 27  2004 foo
 drwxrwx--- 1 owner group          512 Oct 27  2004 pub
 drwxrwx--- 1 owner group          512 Mar 29 12:09 bar

If I<DIRECTORY> is omitted, the method will return the list of the current
directory.

If I<PATTERN> is provided, it would limit the result similar to the unix I<ls>
command or the Windows I<dir> command.  The only wild cards supported are
B<*> and B<?>.  (Match 0 or more chars.  Or any one char.) So a pattern of
I<f*>, I<?Oo> or I<FOO> would find just I<foo> from the list above.  Files with
spaces in their name can cause strange results when searching for a pattern.

=item nlst( [DIRECTORY [, PATTERN]] )

Same as C<list> but returns the list in this format:

 foo
 pub
 bar

Spaces in the filename do not cause problems with the I<PATTERN> with C<nlst>.
Personally, I suggest using nlst instead of list.

=item ascii()

Sets the file transfer mode to ASCII.  I<CR LF> transformations will be done.
ASCII is the default transfer mode.

=item binary()

Sets the file transfer mode to binary. No I<CR LF> transformation will be done.

=item put( LOCAL_FILE [, REMOTE_FILE [, OFFSET]] )

Stores the I<LOCAL_FILE> onto the remote ftps server. I<LOCAL_FILE> may be a
file handle, but in this case I<REMOTE_FILE> is required.
It returns B<undef> if I<put()> fails.

If you provide an I<OFFSET>, this method assumes you are attempting to
continue with an upload that was aborted earlier.  And it's your responsibility
to verify that it's the same file on the server you tried to upload earlier.  By
providing the I<OFFSET>, this function will send a B<REST> command to the FTPS
Server to skip over that many bytes before it starts writing to the file.  This
method will also skip over the requested I<OFFSET> after opening the
I<LOCAL_FILE> for reading, but if passed a file handle it will assume you've
already positioned it correctly.  If you provide an I<OFFSET> of B<-1>, this
method will calculate the offset for you by issuing a I<SIZE> command against
the file on the FTPS server.  So I<REMOTE_FILE> must already exist to use
B<-1>, or it's an error. It is also an error to make I<OFFSET> larger than the
I<REMOTE_FILE>.

If the I<OFFSET> you provide turns out to be smaller than the current size of
I<REMOVE_FILE>, the server will truncate the I<REMOTE_FILE> to that size before
appending to the end of I<REMOTE_FILE>.  (This may not be consistent across
all FTPS Servers, so don't depend on this feature without testing it first.)

If the option I<PreserveTimestamp> was used, and the FTPS server supports it,
it will attempt to reset the timestamp on I<REMOTE_FILE> to the timestamp on
I<LOCAL_FILE>.

=item append( LOCAL_FILE [, REMOTE_FILE [, OFFSET]] )

Appends the I<LOCAL_FILE> onto the I<REMOTE_FILE> on the ftps server.  If
I<REMOTE_FILE> doesn't exist, the file will be created.  I<LOCAL_FILE> may be
a file handle, but in this case I<REMOTE_FILE> is required and I<OFFSET> is
ignored.  It returns B<undef> if I<append()> fails.

If you provide an I<OFFSET>, it will skip over that number of bytes in the
I<LOCAL_FILE> except when it was a file handle, but B<will not> send a B<REST>
command to the server.  It will just append to the end of I<REMOTE_FILE>
on the server.  You can also provide an I<OFFSET> of B<-1> with the same
limitations as with I<put()>.  If you need the B<REST> command sent to the
FTPS server, use I<put()> instead.

If the option I<PreserveTimestamp> was used, and the FTPS server supports it,
it will attempt to reset the timestamp on I<REMOTE_FILE> to the timestamp on
I<LOCAL_FILE>.

=item uput( LOCAL_FILE, [REMOTE_FILE] )

Stores the I<LOCAL_FILE> onto the remote ftps server. I<LOCAL_FILE> may be a
file handle, but in this case I<REMOTE_FILE> is required.  If I<REMOTE_FILE>
already exists on the ftps server, a unique name is calculated by the server
for use instead.

If the file transfer succeeds, this function will return the actual name used
on the remote ftps server.  If it can't figure that out, it will return what
was used for I<REMOTE_FILE>.  On failure this method will return B<undef>.

If the option I<PreserveTimestamp> was used, and the FTPS server supports it,
it will attempt to reset the timestamp on the remote file using the file name
being returned by this function to the timestamp on I<LOCAL_FILE>.  So if the
wrong name is being returned, the wrong file will get it's timestamp updated.

=item xput( LOCAL_FILE, [REMOTE_FILE, [PREFIX, [POSTFIX, [BODY]]]] )

Use when the directory you are dropping I<REMOTE_FILE> into is monitored by
a file recognizer that might pick the file up before the file transfer has
completed.  So the file is transferred using a temporary name using a naming
convention that the file recognizer will ignore and is guaranteed to be unique.
Once the file transfer successfully completes, it will be I<renamed> to
I<REMOTE_FILE> for immediate pickup by the file recognizer.  If you requested
to preserve the file's timestamp, this step is done after the file is renamed
and so can't be 100% guaranteed if the file recognizer picks it up first. Since
if it was done before the rename, other more serious problems could crop up if
the resulting timestamp was old enough.

On failure this function will attempt to I<delete> the scratch file for you if
its at all possible.  You will have to talk to your FTPS server administrator on
good values for I<PREFIX> and I<POSTFIX> if the defaults are no good for you.

B<PREFIX> defaults to I<_tmp.> unless you override it.  Set to "" if you need
to suppress the I<PREFIX>.  This I<PREFIX> can be a path to another directory
if needed, but that directory must already exist!  Set to I<undef> to keep this
default and you need to change the default for I<POSTFIX> or I<BODY>.

B<POSTFIX> defaults to I<.tmp> unless you override it.  Set to "" if you need
to suppress the I<POSTFIX>.  Set to I<undef> to keep this default and you need
to change the default for I<BODY>.

B<BODY> defaults to I<client-name.PID> so that you are guaranteed the temp file
will have an unique name on the remote server.  It is strongly recommended that
you don't override this value.

So the temp scratch file would be called something like this by default:
S<I<_tmp.testclient.51243.tmp>>.

As a final note, if I<REMOTE_FILE> has path information in it's name, the temp
scratch file will have the same directory added to it unless you override the
I<PREFIX> with a different directory to drop the scratch file into.  This avoids
forcing you to change into the requested directory first when you have multiple
files to send out into multiple directories.

=item get( REMOTE_FILE [, LOCAL_FILE [, OFFSET]] )

Retrieves the I<REMOTE_FILE> from the ftps server. I<LOCAL_FILE> may be a
filename or a file handle.  It returns B<undef> if I<get()> fails.  You don't
usually need to use I<OFFSET>.

If you provide an I<OFFSET>, this method assumes your are attempting to
continue with a download that was aborted earlier.  And it's your responsibility
to verify that it's the same file you tried to download earlier.  By providing
the I<OFFSET>, it will send a B<REST> command to the FTPS Server to skip over
that many bytes before it starts downloading the file again.  If you provide an
I<OFFSET> of B<-1>, this method will calculate the offset for you based on the
size of I<LOCAL_FILE> using the current transfer mode.  (I<ASCII> or I<BINARY>).
It is an error to set it to B<-1> if the I<LOCAL_FILE> is a file handle.

On the client side of the download, the I<OFFSET> will do the following:
Open the file and truncate everything after the given I<OFFSET>.  So if you
give an I<OFFSET> that is too big, it's an error.  If it's too small, the
file will be truncated to that I<OFFSET> before appending what's being
downloaded.  If the I<LOCAL_FILE> is a file handle, it will assume the file
handle has already been positioned to the proper I<OFFEST> and it will not
perform a truncate.  Instead it will just append to that file handle's
current location.  Just beware that using huge I<OFFSET>s in B<ASCII> mode
can be a bit slow if the I<LOCAL_FILE> needs to be truncated.

If the option I<PreserveTimestamp> was used, and the FTPS Server supports it,
it will attempt to reset the timestamp on I<LOCAL_FILE> to the timestamp on
I<REMOTE_FILE> after the download completes.

=item xget( REMOTE_FILE, [LOCAL_FILE, [PREFIX, [POSTFIX, [BODY]]]] )

The inverse of I<xput>, where the file recognizer is on the client side.  The
only other difference being what B<BODY> defaults to.  It defaults to
I<reverse(testclient).PID>.  So your default scratch file would be something
like: S<I<_tmp.tneilctset.51243.tmp>>.

Just be aware that in this case B<LOCAL_FILE> can no longer be a file handle.

=item delete( REMOTE_FILE )

Deletes the indicated I<REMOTE_FILE>.

=item cwd( DIR )

Attempts to change directory to the directory given in I<DIR> on the remote
server.

=item pwd( )

Returns the full pathname of the current directory on the remote server.

=item cdup( )

Changes directory to the parent of the current directory on the remote server.

=item mkdir( DIR )

Creates the indicated directory I<DIR> on the remote server. No recursion at
the moment.

=item rmdir( DIR )

Removes the empty indicated directory I<DIR> on the remote server. No recursion
at the moment.

=item noop( )

It requires no action other than the server send an OK reply.

=item rename( OLD, NEW )

Allows you to rename the file on the remote server.

=item site( ARGS )

Send a SITE command to the remote server and wait for a response.

=item mfmt( time_str, remote_file ) or _mfmt( timestamp, remote_file )

Both are boolean functions that attempt to reset the remote file's timestamp on
the FTPS server and returns true on success.  The 1st version can call croak on
failure if I<Croak> is turned on, while the 2nd version will not do this.  The
other difference between these two functions is the format of the file's
timestamp to use.

I<time_str> expects the timestamp to be GMT time in format I<YYYYMMDDHHMMSS>.
While I<timestamp> expects to be in the same format as returned by
I<localtime()>.

=item mdtm( remote_file )  or  _mdtm( remote_file )

The 1st version returns the file's timestamp as a string in I<YYYYMMDDHHMMSS>
format using GMT time, it will return I<undef> or call croak on failure.

The 2nd version returns the file's timestamp in the same format as returned by
I<localtime()> and will never call croak.

=item size( remote_file )

This function will return I<undef> or croak on failure.  Otherwise it will
return the file's size in bytes, which may also be zero bytes! Just be aware
for text files that the size returned may not match the file's actual size after
the file has been downloaded to your system in I<ASCII> mode.  This is an OS
specific issue.  It will always match if you are using I<BINARY> mode.

Also I<SIZE> may return a different size for I<ASCII> & I<BINARY> modes.
This issue depends on what OS the FTPS server is running under.  Should they
be different, the I<ASCII> size will be the I<BINARY> size plus the number of
lines in the file.

=item quot( CMD [,ARGS] )

Send a command, that I<Net::FTPSSL> does not directly support, to the remote
server and wait for a response.  You are responsible for parsing anything
you need from I<message()> yourself.

Returns the most significant digit of the response code.  So it will ignore
the B<Croak> request.

B<WARNING> This call should only be used on commands that do not require
data connections.  Misuse of this method can hang the connection if the
internal list of FTP commands using a data channel is incomplete.

=item ccc( [ DataProtLevel ] )

Sends the clear command channel request to the FTPS server.  If you provide the
I<DataProtLevel>, it will change it from the current data protection level to
this one before it sends the B<CCC> command.  After the B<CCC> command, the
data channel protection level can not be changed again and will always remain
at this setting.  Once you execute the B<CCC> request, you will have to create
a new I<Net::FTPSSL> object to secure the command channel again.  I<Due
to security concerns it is recommended that you do not use this method.>

If the version of I<IO::Socket::SSL> you have installed is too old, this
function will not work since I<stop_SSL> won't be defined (like in v1.08).  So 
it is recommended that you be on at least I<version 1.18> or later if you plan
on using this function.

=item supported( CMD [,SITE_OPT] )

Returns B<TRUE> if the remote server supports the given command.  I<CMD> must
match exactly.  This function will ignore the B<Croak> request.

If the I<CMD> is SITE or FEAT and I<SITE_OPT> is supplied, it will also check
if the specified I<SITE_OPT> sub-command is supported by that command.  Not
all servers will support the use of I<SITE_OPT>.

It determines if a command is supported by calling B<HELP> and parses the
results for a match.  And if B<FEAT> is supported it calls B<FEAT> and adds
these commands to the B<HELP> list.  The results are cached so B<HELP> and
B<FEAT> are only called once.

Some rare servers send the B<HELP> results partially encrypted and partially in
clear text, causing the encrypted channel to break.  In that case you will need
to override this method for things to work correctly with these non-conforming
servers.  See the I<OverrideHELP> option in the constructor for how to do this.

Some servers don't support the B<HELP> command itself!  When this happens, this
method will always return B<FALSE> unless you set the I<OverrideHELP> option in
the constructor.

This method is used internally for conditional logic only when checking if the
following 5 I<FTP> commands are allowed: B<ALLO>, B<NOOP>, B<HELP>, B<MFMT> and
B<MDTM>.  The B<ALLO> command is used with all I<put>/I<get> command sequences.
The other four are not checked that often.  Function I<xput> also tests for four
more commands indirectly: B<STOR>, B<DELE>, B<RNFR> and B<RNTO>.

=item last_message() or message()

Use either one to collect the last response from the FTPS server.  This is the
same response printed to I<STDERR> when Debug is turned on.  It may also contain
any fatal error message encountered.

If you couldn't create a I<Net::FTPSSL> object, you should get your error
message from I<$Net::FTPSSL::ERRSTR> instead.  Be careful since
I<$Net::FTPSSL::ERRSTR> is shared between instances of I<Net::FTPSSL>, while
I<message> & I<last_message> B<are not> shared between instances!

=item last_status_code( )

Returns the one digit status code associated with the last response from the
FTPS server.  The status is the first digit from the full 3 digit response code.

The possible values are exposed via the following B<7> constants:
CMD_INFO, CMD_OK, CMD_MORE, CMD_REJECT, CMD_ERROR, CMD_PROTECT and CMD_PENDING.

=item restart( OFFSET )

Set the byte offset at which to begin the next data transfer.  I<Net::FTPSSL>
simply records this value and uses it during the next data transfer.  For
this reason this method will never return an error, but setting it may cause
subsequent data transfers to fail.

I recommend using the OFFSET directly in I<get()>, I<put()>, and I<append()>
instead of using this method.  It was only added to make I<Net::FTPSSL>
compatible with I<Net::FTP>.  A non-zero offset in those methods will override
what you provide here.  If you call any of the other I<get()>/I<put()> variants
after calling this function, you will get an error.

It is OK to use an I<OFFSET> of B<-1> here to have I<Net::FTPSSL> calculate
the correct I<OFFSET> for you before it get's used.  Just like if you had
provided it directly to the I<get()>, I<put()>, and I<append()> calls.

This I<OFFSET> will be automatically zeroed out the 1st time it is used.

=item set_callback( [cb_func_ref, end_cb_func_ref [, cb_data_ref]] )

This function allows the user to define a callback function to use whenever a
data channel to the server is open.  If either B<cb_func_ref> or
B<end_cb_func_ref> is undefined, it disables the callback functionality, since
both are required for call backs to function properly.

The B<cb_func_ref> is a reference to a function to handle processing the
data channel data.  This is a I<void> function that can be called multiple
times.  It is called each time a chunk of data is read from or written to the
data channel.

The B<end_cb_func_ref> is a reference to a function to handle closing the
callback for this data channel connection.  This function is allowed to return
a string of additional data to process before the data channel is closed.  It
is called only once per command after processing all the data channel data.

The B<cb_data_ref> is an optional reference to an I<array> or I<hash> that the
caller can use to store values between calls to the callback function and the
end callback function.  If you don't need such a work area, it's safe to not
provide one.  The I<Net::FTPSSL> class doesn't look at this reference.

The callback function must take the following B<5> arguments:

   B<callback> (ftps_func_name, data_ref, data_len_ref, total_len, cb_data_ref);

The I<ftps_func_name> will tell what I<Net::FTPSSL> function requested the
callback so that your I<callback> function can determine what the data is for
and do conditional logic accordingly.  We don't provide a reference to the
I<Net::FTPSSL> object itself since the class is not recursive.  Each
I<Net::FTPSSL> object should have it's own I<cb_dat_ref> to work with.  But
methods within the class can share one.

Since we pass the data going through the data channel as a reference, you are
allowed to modify the data.  But if you do, be sure to update I<data_len_ref>
to the new data length as well if it changes.  Otherwise you will get buggy
responses.  Just be aware that if you change the length, more than likely you'll
be unable to reliably restart an upload or download via I<restart()> or using
I<OFFSET> in the I<put> & I<get> commands.

Finally, the I<total_len> is how many bytes have already been processed.  It
does not include the data passed for the current I<callback> call.  So it will
always be zero the first time it's called.

Once we finish processing data for the data channel, a different callback
function will be called to tell you that the data channel is closing.  That will
be your last chance to affect what is going over the data channel and to do any
needed post processing.  The end callback function must take the following
arguments:

   $end = B<end_callback> (ftps_func_name, total_len, cb_data_ref);

These arguments have the same meaning as for the callback function, except that
this function allows you to optionally provide additional data to/from the data
channel.  If reading from the data channel, it will treat the return value as
the last data returned before it was closed.  Otherwise it will be written to
the data channel before it is closed.  Please return I<undef> if there is
nothing extra for the I<Net::FTPSSL> command to process.

You should also take care to clean up the contents of I<cb_data_ref> in the
I<end_callback> function.  Otherwise the next callback sequence that uses this
work area may behave strangely.

As a final note, should the data channel be empty, it is very likely that just
the I<end_callback> function will be called without any calls to the I<callback>
function.

=back

=head1 AUTHORS

Marco Dalla Stella - <kral at paranoici dot org>

Curtis Leach - <cleach at cpan dot org> - As of v0.05

=head1 SEE ALSO

I<Net::Cmd>

I<Net::FTP>

I<Net::SSLeay::Handle>

I<IO::Socket::SSL>

RFC 959 - L<ftp://ftp.rfc-editor.org/in-notes/rfc959.txt>

RFC 2228 - L<ftp://ftp.rfc-editor.org/in-notes/rfc2228.txt>

RFC 2246 - L<ftp://ftp.rfc-editor.org/in-notes/rfc2246.txt>

RFC 4217 - L<ftp://ftp.rfc-editor.org/in-notes/rfc4217.txt>

=head1 CREDITS

Graham Barr <gbarr at pobox dot com> - for have written such a great
collection of modules (libnet).

=head1 BUGS

Please report any bugs with a FTPS log file created via options B<Debug=E<gt>1>
and B<DebugLogFile=E<gt>"file.txt"> along with your sample code at
L<http://search.cpan.org/~cleach/Net-FTPSSL-0.23/FTPSSL.pm>.

Patches are appreciated when a log file and sample code are also provided.

=head1 COPYRIGHT

Copyright (c) 2009 - 2013 Curtis Leach. All rights reserved.

Copyright (c) 2005 Marco Dalla Stella. All rights reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

