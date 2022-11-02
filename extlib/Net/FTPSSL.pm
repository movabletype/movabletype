# File    : Net::FTPSSL
# Author  : cleach <cleach at cpan dot org>
# Created : 01 March 2005
# Version : 0.42
# Revision: -Id: FTPSSL.pm,v 1.24 2005/10/23 14:37:12 cleach Exp -

package Net::FTPSSL;

use strict;
use warnings;

# Enforce a minimum version of this module or Net::FTPSSL hangs!
# v1.08 works, v1.18 added ccc() support.
# Don't use v1.79 to v1.85 due to misleading warnings.
use IO::Socket::SSL 1.26;

use vars qw( $VERSION @EXPORT $ERRSTR );
use base ( 'Exporter', 'IO::Socket::SSL' );

# Only supports IPv4 (to also get IPv6 must use IO::Socket::IP instead. v0.20)
use IO::Socket::INET;

use Net::SSLeay::Handle;
use File::Basename;
use File::Copy;
use Time::Local;
use Sys::Hostname;
use Carp qw( carp croak );
use Errno qw/ EINTR /;

@EXPORT  = qw( IMP_CRYPT  EXP_CRYPT   CLR_CRYPT
               DATA_PROT_CLEAR   DATA_PROT_PRIVATE
               DATA_PROT_SAFE    DATA_PROT_CONFIDENTIAL
               CMD_INFO   CMD_OK      CMD_MORE    CMD_REJECT
               CMD_ERROR  CMD_PROTECT CMD_PENDING );
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

# -------- Above Exported ---- Below don't bother to export --------

# File transfer modes (the mixed modes have no code)
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
use constant TRACE_MOD => 10;  # How many iterations between ".".  Must be >= 5.

# Primarily used while the call to new() is still in scope!
my $FTPS_ERROR;

# Used to handle trapping all warnings accross class instances
my %warn_list;

# Tells if possible to use IPv6 in connections.
my $ipv6;
my $IOCLASS;
my $family_key;     # Domain or Family
my $debug_log_msg;  # Used if Debug is turned on


BEGIN {
    $VERSION = "0.42";              # The version of this module!

    my $type = "IO::Socket::SSL";
    $ipv6 = 0;                      # Assume IPv4 only ...
    $IOCLASS = "IO::Socket::INET";  # Assume IPv4 only ...
    $family_key = "Domain";         # Traditional ...
    my $msg;

    my $ioOrig = $IOCLASS;

    # Can we use IPv6 vs IPv4?  Let IO::Socket::SSL make the decision for us!
    # The logic gets real messy otherwise.
    if ( ! $type->can ("can_ipv6") ) {
       $msg = "No IPv6 support available.  You must 1st upgrade $type to support it!";

    } elsif ( $type->can_ipv6 () ) {
       $ipv6 = 1;                        # Yes!  IPv6 can be suporteed!
       $IOCLASS = $type->can_ipv6 ();    # Get which IPv6 module SSL uses.
       $family_key = "Family"   if ( $IOCLASS eq "IO::Socket::IP" );
       my $ver = $IOCLASS->VERSION;
       $msg = "IPv6 support available via $IOCLASS ($ver)  Key: ($family_key)";

    } else {
       $msg = "No IPv6 support available.  Missing required modules!";
    }

    # Now let's provide the logfile header information ...
    # Done here so only have to generate this information one time!
    my $pv = sprintf ("%s  [%vd]", $], $^V);   # The version of perl!

    # Required info when opening a CPAN ticket against this module ...
    $debug_log_msg = "\n"
                   . "Net-FTPSSL Version: $VERSION\n";

    # Print out versions of critical modules we depend on ...
    foreach ( "IO-Socket-SSL",  "Net-SSLeay",
              "IO-Socket-INET", "IO-Socket-INET6",
              "IO-Socket-IP",   "IO",
              "Socket" ) {
       my $mod = $_;
       $mod =~ s/-/::/g;
       my $ver = $mod->VERSION;
       if ( defined $ver ) {
          $debug_log_msg .= "$_ Version: $ver\n";
       } else {
          $debug_log_msg .= "$_ might not be installed.\n";
       }
    }

    $debug_log_msg .= "\n${msg}\n\n"
                    . "Perl: $pv,  OS: $^O\n\n";

    # Comment out/remove when ready to implement iIPv6 ...
    $IOCLASS = $ioOrig;  $family_key = "Domain";
    $debug_log_msg .= "***** IPv6 not yet supported in Net::FTPSSL! *****\n\n";
}

# ============================================================================

sub new {
  my $self         = shift;
  my $type         = ref($self) || $self;
  my $host         = shift;
  my $arg          = (ref ($_[0]) eq "HASH") ? $_[0] : {@_};


  # Make sure to reset in case previous call to new generated an error!
  $ERRSTR = "No Errors Detected Yet.";

  # Used as a quick way to detect if the caller passed us SSL_* arguments ...
  my $found_ssl_args = 0;

  # The hash to pass to start_ssl() ...
  my %ssl_args;

  # Depreciated in v0.18 (in 2011) and fatal in v0.26 (2015)
  # Will remove this test sometime in 2017/2018!
  if (ref ($arg->{SSL_Advanced}) eq "HASH") {
     %ssl_args = %{$arg->{SSL_Advanced}};
     $ERRSTR = "SSL_Advanced is no longer supported!  Using a separate hash is no longer required for adding SSL options!";
     croak ("\n" . $ERRSTR . "\n");
  }

  # May depreciate in the near future in favor of the "grep" loop below!
  # Debating the merrits of having two ways to do this.
  if (ref ($arg->{SSL_Client_Certificate}) eq "HASH") {
     # The main purpose of this option was to allow users to specify
     # client certificates when their FTPS server requires them.
     # This hash applies to both the command & data channels.
     # Tags specified here overrided normal options if any tags
     # conflict.
     # See IO::Socket::SSL for supported options.
     %ssl_args = %{$arg->{SSL_Client_Certificate}};
     $found_ssl_args = 1;
  }

  # See IO::Socket::SSL for supported options.
  # Provides a way to directly pass needed SSL_* arguments to this module.
  # There is only one Net::FTPSSL option that starts with SSL_, so skipping it!
  for (grep { m{^SSL_} } keys %{$arg}) {
     next  if ( $_ eq "SSL_Client_Certificate" );   # The FTPSSL opt to skip!
     $ssl_args{$_} = $arg->{$_};
     $found_ssl_args = 1;
  }

  # Only add if not using certificates & the caller didn't provide a value ...
  unless ( $ssl_args{SSL_use_cert} || $ssl_args{SSL_verify_mode} ) {
     # Stops the Man-In-The-Middle (MITM) security warning from start_ssl()
     # when it calls configure_SSL() in IO::Socket::SSL.
     # To plug that MITM security hole requires the use of certificates,
     # so all that's being done here is supressing the warning.  The MITM
     # security hole is still open!
     # That warning is now a fatal error in newer versions of IO::Socket::SSL.
     # warn "WARNING: Your connection is vunerable to the MITM attacks\n";
     $ssl_args{SSL_verify_mode} = Net::SSLeay::VERIFY_NONE();
  }

  # --------------------------------------------------------------------------
  # Will hold all the control options to this class
  # Similar in use as _SSL_arguments ...
  my %ftpssl_args;

  # Now onto processing the regular hash of arguments provided ...
  my $encrypt_mode = $arg->{Encryption} || EXP_CRYPT;
  my $port         = $arg->{Port}   || (($encrypt_mode eq IMP_CRYPT) ? 990 : 21);
  my $debug        = $arg->{Debug}  || 0;
  my $trace        = $arg->{Trace}  || 0;
  my $timeout      = $ssl_args{Timeout} || $arg->{Timeout} || 120;
  my $buf_size     = $arg->{Buffer} || 10240;
  my $data_prot    = ($encrypt_mode eq CLR_CRYPT) ? DATA_PROT_CLEAR
                                 : ($arg->{DataProtLevel} || DATA_PROT_PRIVATE);
  my $die          = $arg->{Croak}  || $arg->{Die};
  my $pres_ts      = $arg->{PreserveTimestamp} || 0;
  my $use__ssl     = $arg->{useSSL} || 0;       # Being depreciated.

  my ($use_logfile, $use_glob) = (0, 0);
  if ( $debug && defined $arg->{DebugLogFile} ) {
     $use_logfile  = (ref ($arg->{DebugLogFile}) eq "" &&
                      $arg->{DebugLogFile} ne "");
     $use_glob     = _isa_glob (undef, $arg->{DebugLogFile});
  }
  my $localaddr    = $ssl_args{LocalAddr} || $arg->{LocalAddr};
  my $pret         = $arg->{Pret} || 0;
  my $domain       = $arg->{Domain} || $arg->{Family};
  my $xWait        = $arg->{xWait} || 0;

  my $reuseSession = $arg->{ReuseSession} || 0;

  # Default to true unless you request to disable it or no encryption used ...
  my $enableCtx    = ($arg->{DisableContext} || $encrypt_mode eq CLR_CRYPT) ? 0 : 1;

  # Used to work arround some FTPS servers behaving badly!
  my $pasvHost     = $arg->{OverridePASV};
  my $fixHelp      = $arg->{OverrideHELP};

  # --------------------------------------------------------------------------
  # if ( $debug && ! exists $arg->{DebugLogFile} ) {
  #   # So will write any debug comments to STDERR ...
  #   $IO::Socket::SSL::DEBUG = 3;
  # }

  # A special case used for further debugging the response!
  # This special value is undocumented in the POD on purpose!
  my $debug_extra = ($debug == 99) ? 1 : 0;

  # Special case for eliminating listing help text during login!
  my $no_login_help = ($debug == 90) ? 1 : 0;

  my $f_exists = 0;

  # Determine where to write the Debug info to ...
  if ( $use_logfile ) {
     my $open_mode = ( $debug == 2 ) ? ">>" : ">";
     my $f = $arg->{DebugLogFile};
     unlink ( $f )  if ( -f $f && $open_mode ne ">>" );
     $f_exists = (-f $f);

     # Always calls die on failure to open the requested log file ...
     open ( $FTPS_ERROR, "$open_mode $f" ) or
               _croak_or_return (undef, 1, 0,
                                 "Can't create debug logfile: $f ($!)");

     $FTPS_ERROR->autoflush (1);

     $debug = 2;        # Save the file handle & later close it ...

  } elsif ( $use_glob ) {
     $FTPS_ERROR = $arg->{DebugLogFile};
     $debug = 3;        # Save the file handle, but never close it ...
  }

  if ( $use_logfile || $use_glob ) {
     unless ( $f_exists ) {
        print $FTPS_ERROR $debug_log_msg;
     } else {
        print $FTPS_ERROR "\n\n";
     }

  } elsif ( $debug ) {
     $debug = 1;                  # No file handle to save ...

#    open ( $FTPS_ERROR, ">&STDERR" ) or
#              _croak_or_return (undef, 1, 0,
#                             "Can't attach the debug logfile to STDERR. ($!)");
#    $FTPS_ERROR->autoflush (1);

     print STDERR $debug_log_msg;
  }

  if ( $debug ) {
     _print_LOG (undef, "Server (port): $host ($port)\n\n");
     _print_LOG (undef, "Keys: (",   join ("), (", keys %${arg}),   ")\n");
     _print_LOG (undef, "Values: (", join ("), (", values %${arg}), ")\n\n");
  }

  # Determines if we die if we will also need to write to the error log file ...
  my $dbg_flg = $die ? ( $debug >= 2 ? 1 : 0 ) : $debug;

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

  if ( $ipv6 && defined $domain ) {
     my $fmly = (exists $arg->{Domain}) ? "Domain" : "Family";
     $domain = _validate_domain ( $type, $fmly, $domain, $dbg_flg, $die );
     return ( undef )  unless (defined $domain);
  }

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
     $ftpssl_args{myProxyArgs} = \%proxyArgs;

  } else {
     # Establishing a Direct Connection ...
     my %socketArgs = ( PeerAddr => $host,
                        PeerPort => $port,
                        Proto    => 'tcp',
                        Timeout  => $timeout
                      );
     $socketArgs{LocalAddr} = $localaddr  if (defined $localaddr);
     $socketArgs{$family_key} = $domain   if ($ipv6 && defined $domain);

     $socket = $IOCLASS->new ( %socketArgs )
     # $socket = IO::Socket::INET->new ( %socketArgs )
                   or
            return _croak_or_return (undef, $die, $dbg_flg,
                                  "Can't open tcp connection! ($host:$port)");
     $ftpssl_args{mySocketOpts} = \%socketArgs;
  }

  _my_autoflush ( $socket );

  # Save so we can log socket activity if needed ...
  $ftpssl_args{debug}   = $debug;
  $ftpssl_args{debug_extra} = $debug_extra;
  $ftpssl_args{Croak}   = $die;
  $ftpssl_args{Timeout} = $timeout;

  # Bug Id: 120341 says this will be removed from socket by start_SSL() call.
  ${*$socket}{_FTPSSL_arguments} = \%ftpssl_args;

  my $obj;

  if ( $encrypt_mode eq CLR_CRYPT ) {
     # Catch the banner from the connection request ...
     return _croak_or_return ($socket)  unless ( response($socket) == CMD_OK );

     # Leave the command channel clear for regular FTP.
     $obj = $socket;
     bless ( $obj, $type );
     ${*$obj}{_SSL_opened} = 0;      # To get rid of SSL warning on quit ...

  } else {
     # Determine the options to use in start_SSL() ...
     # ------------------------------------------------------------------------
     # Reset SSL_version & Timeout in %ssl_args so these options can be
     # applied to the SSL_Client_Certificate functionality.
     # ------------------------------------------------------------------------
     my $mode;
     my $use_ssl_flag;
     if (defined $ssl_args{SSL_version}) {
        $mode = $ssl_args{SSL_version};             # Mode was overridden.
        $use_ssl_flag = ( $mode =~ m/^SSLv/i );     # Bug ID 115296
     } elsif ( $use__ssl ) {
        $mode = $ssl_args{SSL_version} = "SSLv23";  # SSL per override
        $use_ssl_flag = 1;
        warn ("Option useSSL has been depreciated.  Use option SSL_version instead.\n");
     } else {
        $mode = $ssl_args{SSL_version} = "TLSv12";  # TLS v1.2 per defaults
        $use_ssl_flag = 0;
     }
     $ssl_args{Timeout} = $timeout  unless (exists $ssl_args{Timeout});

     # ------------------------------------------------------------------------
     # The options for Reusing the Session ...
     # ------------------------------------------------------------------------
     if ( $reuseSession ) {
        $ssl_args{SSL_session_cache} = IO::Socket::SSL::Session_Cache->new (4 + $reuseSession);
        $ssl_args{SSL_session_key} = "Net-FTPSSL-${VERSION}-$$:${port}";
     }

     # _debug_print_hash (undef, "Socket call", "initialization", "?", $socket);
     # _debug_print_hash (undef, "Before start_SSL() call", "initialization", "?", \%ssl_args);
     # ------------------------------------------------------------------------

     # Can we use SNI?
     if ( $type->can ("can_client_sni") && $type->can_client_sni () ) {
        $ssl_args{SSL_hostname} = $host  if (! exists $ssl_args{SSL_hostname});
     }

     if ( $encrypt_mode eq EXP_CRYPT ) {
        # Catch the banner from the connection request ...
        return _croak_or_return ($socket) unless (response ($socket) == CMD_OK);

        # In explicit mode FTPSSL sends an AUTH TLS/SSL command, catch the msgs
        command( $socket, "AUTH", ($use_ssl_flag ? "SSL" : "TLS") );
        return _croak_or_return ($socket) unless (response ($socket) == CMD_OK);
     }

     # ------------------------------------------------------------------------
     # Now transform the clear connection into a SSL one on our end.
     # Messy since newer IO::Socket::SSL modules remove {_FTPSSL_arguments}!
     # Bug Id: 120341.
     # ------------------------------------------------------------------------
     $obj = $type->start_SSL( $socket, %ssl_args );
     unless ( $obj ) {
        unless ( exists ${*$socket}{_FTPSSL_arguments} ) {
           ${*$socket}{_FTPSSL_arguments} = \%ftpssl_args;
           _print_LOG (undef, "Restoring _FTPSSL_arguments to \$socket.\n")  if ( $debug );
        }
        return _croak_or_return ( $socket, undef,
                                  "$mode: " . IO::Socket::SSL::errstr () );
     }

     unless ( exists ${*$obj}{_FTPSSL_arguments} ) {
        ${*$obj}{_FTPSSL_arguments} = \%ftpssl_args;
        $obj->_print_LOG ("Restoring _FTPSSL_arguments to \$obj.\n")  if ( $debug );
     }
     # ------------------------------------------------------------------------

     if ( $encrypt_mode eq IMP_CRYPT ) {
        # Catch the banner from the implicit connection request ...
        return $obj->_croak_or_return ()  unless ( $obj->response() == CMD_OK );
     }

     $ftpssl_args{start_SSL_opts} = \%ssl_args;
  }


  # --------------------------------------
  # Check if overriding "_help()" ...
  # --------------------------------------
  if ( defined $fixHelp ) {
     my %helpHash;

     $ftpssl_args{OverrideHELP} = 0;     # So we know OverrideHELP was used ...
     if ( ref ($fixHelp) eq "ARRAY" ) {
        foreach (@{$fixHelp}) {
          my $k = uc ($_);
          $helpHash{$k} = 1  if ( $k ne "HELP" );
        }
     } elsif ( $fixHelp == -1 ) {
       $ftpssl_args{removeHELP} = 1;     # Uses FEAT to list commands supported!
     } elsif ( $fixHelp ) {
       $ftpssl_args{OverrideHELP} = 1;   # All FTP commands supported ...
     }

     # Set the "cache" tags used by "_help()" so that it can still be called!
     $ftpssl_args{help_cmds_found} = \%helpHash;
     $ftpssl_args{help_cmds_msg} = "214 HELP Command Overridden by request.";

     # Causes direct calls to _help($cmd) to skip the server hit. (HELP $cmd)
     $ftpssl_args{help_cmds_no_syntax_available} = 1;

     # When you get here, OverrideHELP is either "0" or "1"!
  }
  # --------------------------------------
  # End overriding "_help()" ...
  # --------------------------------------

  # These options control the behaviour of the Net::FTPSSL class ...
  $ftpssl_args{Host}          = $host;
  $ftpssl_args{Crypt}         = $encrypt_mode;
  $ftpssl_args{debug}         = $debug;
  $ftpssl_args{debug_extra}   = $debug_extra;
  $ftpssl_args{debug_no_help} = $no_login_help;
  $ftpssl_args{trace}         = $trace;
  $ftpssl_args{buf_size}      = $buf_size;
  $ftpssl_args{type}          = MODE_ASCII;
  $ftpssl_args{data_prot}     = $data_prot;
  $ftpssl_args{Croak}         = $die;
  $ftpssl_args{FixPutTs}      = $ftpssl_args{FixGetTs} = $pres_ts;
  $ftpssl_args{OverridePASV}  = $pasvHost  if (defined $pasvHost);
  $ftpssl_args{dcsc_mode}     = FTPS_PASV;
  $ftpssl_args{Pret}          = $pret;
  $ftpssl_args{Timeout}       = $timeout;
  $ftpssl_args{xWait}         = $xWait     if ( $xWait );

  $ftpssl_args{ftpssl_filehandle} = $FTPS_ERROR  if ( $debug >= 2 );
  $FTPS_ERROR = undef;

  # Must be last for certificates to work correctly ...
  if ( $reuseSession || $enableCtx ||
       ref ($arg->{SSL_Client_Certificate}) eq "HASH" ) {
     # Reuse the command channel context ...
     my %ssl_reuse = ( SSL_reuse_ctx => ${*$obj}{_SSL_ctx} );

     # Added to fix CPAN Bug Id: 101388 ...
     my $key = "SSL_ca_file";
     if ( exists ${*$obj}{_SSL_arguments}->{$key} ) {
        $ssl_reuse{$key} = ${*$obj}{_SSL_arguments}->{$key};
     }
     $key = "SSL_verifycn_name";
     if ( exists ${*$obj}{_SSL_arguments}->{$key} ) {
        $ssl_reuse{$key} = ${*$obj}{_SSL_arguments}->{$key};
     }
     $key = "SSL_verifycn_scheme";
     if ( exists ${*$obj}{_SSL_arguments}->{$key} ) {
        $ssl_reuse{$key} = ${*$obj}{_SSL_arguments}->{$key};
     } elsif ( exists $ssl_args{$key} ) {
        $ssl_reuse{$key} = $ssl_args{$key};
     }

     # Fix for Bug Ids # 104407 & 76108.  (Session Reuse!)
     $key = "SSL_session_key";
     if ( exists ${*$obj}{_SSL_arguments}->{$key} && ! exists $ssl_reuse{$key} ) {
        $ssl_reuse{$key} = ${*$obj}{_SSL_arguments}->{$key};
        # $obj->_print_LOG ("\n  *** Adding: $key --> $ssl_reuse{$key} ***\n");
     }

     $ftpssl_args{myContext} = \%ssl_reuse;
  }

  # -------------------------------------------------------------------------
  # Print out the details of the SSL object.  It's TRUE only for debugging!
  # -------------------------------------------------------------------------
  if ( $debug ) {
     if ( ref ($arg->{SSL_Client_Certificate}) eq "HASH" ) {
        $obj->_debug_print_hash ( "SSL_Client_Certificate", "options",
                                $encrypt_mode, $arg->{SSL_Client_Certificate} );
     }
     $obj->_debug_print_hash ( "SSL", "arguments", $encrypt_mode, \%ssl_args );
     $obj->_debug_print_hash ( $host, $port, $encrypt_mode, undef, "*" );
  }

  return $obj;
}

#-----------------------------------------------------------------------
# TODO:  Adding ACCT (Account) support (response 332 [CMD_MORE] on password)

sub login {
  my ( $self, $user, $pass ) = @_;

  my $arg = ${*$self}{_FTPSSL_arguments};

  if ( defined $user && $user ne "" ) {
     $arg->{_hide_value_in_response_} = $user;
     $arg->{_mask_value_in_response_} = "++++++";
  }

  my $logged_on = $self->_test_croak ( $self->_user ($user) &&
                                       $self->_passwd ($pass) );

  delete ( $arg->{_hide_value_in_response_} );
  delete ( $arg->{_mask_value_in_response_} );

  if ( $logged_on ) {
     # Check if we want to supress the help logging ...
     my $save = $arg->{debug};
     if ( $arg->{debug_no_help} ) {
        delete $arg->{debug};
     }

     # So _help is always called early instead of later.
     $self->supported ("HELP");

     $arg->{debug} = $save;  # Re-enabled again!

     # Printing to the log for info purposes only.
     if ( $arg->{debug} && $arg->{debug_extra} ) {
        my %h = %{$self->_help ()};
        foreach ( sort keys %h ) {
           $h{$_} = sprintf ("%s[%s]", $_,  $h{$_});
        }
        my $hlp = join ("), (", sort values %h);

        if ( $hlp eq "" ) {
           my $msg = ( $arg->{OverrideHELP} ) ? "All" : "No";
           $self->_print_LOG ("HELP: () --> $msg FTP Commands.\n");
        } else {
           $self->_print_LOG ("HELP: ($hlp)\n");
        }
     }

     # Check if these commands are not supported by this server after all!
     if ( $arg->{FixPutTs} && ! $self->supported ("MFMT") ) {
        $arg->{FixPutTs} = 0;
     }
     if ( $arg->{FixGetTs} && ! $self->supported ("MDTM") ) {
        $arg->{FixGetTs} = 0;
     }
  }

  return ( $logged_on );
}

#-----------------------------------------------------------------------

sub quit {
  my $self = shift;
  $self->_quit() or return 0;   # Don't do a croak here, since who tests?
  _my_close ($self);            # Old way $self->close();
  return 1;
}

#-----------------------------------------------------------------------

sub force_epsv {
  my $self = shift;
  my $epsv_mode = shift || "1";

  unless ($epsv_mode eq "1" || $epsv_mode eq "2") {
    return $self->croak_or_return (0, "Invalid IP Protocol Flag ($epsv_mode)");
  }

  # Don't resend the command to the FTPS server if it was sent before!
  if ( ${*$self}{_FTPSSL_arguments}->{dcsc_mode} != FTPS_EPSV_1 &&
       ${*$self}{_FTPSSL_arguments}->{dcsc_mode} != FTPS_EPSV_2 ) {
    unless ($self->command ("EPSV", "ALL")->response () == CMD_OK) {
       return $self->_croak_or_return ();
    }
  }

  # Now that only EPSV is supported, remember which one was requested ...
  # You can no longer swap back to PASV, PORT or EPRT.
  ${*$self}{_FTPSSL_arguments}->{dcsc_mode} = ($epsv_mode eq "1") ? FTPS_EPSV_1 : FTPS_EPSV_2;

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

  if ( ${*$self}{_FTPSSL_arguments}->{Pret} ) {
     unless ( $self->command ("PRET", @_)->response () == CMD_OK ) {
        $self->_croak_or_return ();
        return ($host, $port);
     }
  }

  unless ( $self->command ("PASV")->response () == CMD_OK ) {
     if ( ${*$self}{_FTPSSL_arguments}->{Pret} ) {
        # Prevents infinite recursion on failure if PRET is already set ...
        $self->_croak_or_return ();

     } elsif ( $self->last_message () =~ m/(^|\s)PRET($|[\s.!?])/i ) {
        # Turns PRET on for all future calls to _pasv()!
        # Stays on even if it still doesn't work with PRET!
        ${*$self}{_FTPSSL_arguments}->{Pret} = 1;
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

  if ( ${*$self}{_FTPSSL_arguments}->{OverridePASV} ) {
     my $ip = $host;
     $host = ${*$self}{_FTPSSL_arguments}->{OverridePASV};
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
  return (${*$self}{_FTPSSL_arguments}->{Host}, $port);
}

sub prep_data_channel {
  my $self = shift;
  # Leaving other arguments on the stack (for use by PRET if called via PASV)

  # Should only do this for encrypted Command Channels.
  if ( ${*$self}{_FTPSSL_arguments}->{Crypt} ne CLR_CRYPT ) {
     $self->_pbsz();
     unless ($self->_prot()) { return $self->_croak_or_return (); }
  }

  # Determine what host/port pairs to use for the data channel ...
  my $mode = ${*$self}{_FTPSSL_arguments}->{dcsc_mode};
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

  # Warning: also called by t/06-login.t func check_for_pasv_issue(),
  # so verify still works there if any significant changes are made here.

  # We don't care about any context features here, only in _get_data_channel().
  # You can't apply these features until after the command using the data
  # channel has been sent to the FTPS server and the FTPS server responds
  # to the socket you are creating below!

  # Makes it easier to refrence all those pesky values over & over again.
  my $ftps_ref = ${*$self}{_FTPSSL_arguments};

  my $msg = "";
  my %proxyArgs;
  if (exists $ftps_ref->{myProxyArgs} ) {
     %proxyArgs = %{$ftps_ref->{myProxyArgs}};
     $msg = ($proxyArgs{'proxy-host'} || "undef") . ":" . ($proxyArgs{'proxy-port'} || "undef");

     # Update the host & port to connect to through the proxy server ...
     $proxyArgs{'remote-host'} = $host;
     $proxyArgs{'remote-port'} = $port;
  }

  my $socket;

  if ( $ftps_ref->{data_prot} eq DATA_PROT_PRIVATE ) {
     if (exists $ftps_ref->{myProxyArgs} ) {
        # Set the proxy parameters for all future data connections ...
        Net::SSLeay::set_proxy ( $proxyArgs{'proxy-host'}, $proxyArgs{'proxy-port'},
                                 $proxyArgs{'proxy-user'}, $proxyArgs{'proxy-pass'} );
        $msg = " (via proxy $msg)";
     }

     # carp "MSG=($msg)\n" . "proxyhost=($Net::SSLeay::proxyhost--$Net::SSLeay::proxyport)\n" . "auth=($Net::SSLeay::proxyauth--$Net::SSLeay::CRLF)\n";

     $socket = Net::SSLeay::Handle->make_socket( $host, $port )
               or return $self->_croak_or_return (0,
                      "Can't open private data connection to $host:$port $msg");

  } elsif ( $ftps_ref->{data_prot} eq DATA_PROT_CLEAR && exists $ftps_ref->{myProxyArgs} ) {
     $socket = Net::HTTPTunnel->new ( %proxyArgs ) or
             return $self->_croak_or_return (0,
                   "Can't open HTTP Proxy data connection tunnel from $msg to $host:$port");

  } elsif ( $ftps_ref->{data_prot} eq DATA_PROT_CLEAR ) {
     my %socketArgs = %{$ftps_ref->{mySocketOpts}};
     $socketArgs{PeerAddr} = $host;
     $socketArgs{PeerPort} = $port;

     $socket = $IOCLASS->new ( %socketArgs ) or
     # $socket = IO::Socket::INET->new( %socketArgs ) or
                  return $self->_croak_or_return (0,
                             "Can't open clear data connection to $host:$port");

  } else {
     # TODO: Fix so DATA_PROT_SAFE & DATA_PROT_CONFIDENTIAL work.
     return $self->_croak_or_return (0, "Currently doesn't support mode $ftps_ref->{data_prot} for data channels to $host:$port");
  }

  $ftps_ref->{data_ch} = \*$socket;     # Must call _get_data_channel() before using.
  $ftps_ref->{data_host} = $host;       # Save the IP Address used ...

  return 1;   # Data Channel was established!
}

sub _get_data_channel {
   my $self = shift;

   # Makes it easier to refrence all those pesky values over & over again.
   my $ftps_ref = ${*$self}{_FTPSSL_arguments};

   # $self->_debug_print_hash ("host", "port", $ftps_ref->{data_prot}, $ftps_ref->{data_ch});

   my $io;
   if ( $ftps_ref->{data_prot} eq DATA_PROT_PRIVATE && exists ($ftps_ref->{myContext}) ) {
      my %ssl_opts = %{$ftps_ref->{myContext}};
      my $mode = ${*$self}{_SSL_arguments}->{SSL_version};

      # Can we use SNI?
      if ( $self->can ("can_client_sni") && $self->can_client_sni () ) {
         $ssl_opts{SSL_hostname} = $ftps_ref->{data_host};
      }

      $io = IO::Socket::SSL->start_SSL ( $ftps_ref->{data_ch}, \%ssl_opts )
               or return $self->_croak_or_return ( 0,
                                      "$mode: " . IO::Socket::SSL::errstr () );

   } elsif ( $ftps_ref->{data_prot} eq DATA_PROT_PRIVATE ) {
      $io = IO::Handle->new ();
      tie ( *$io, "Net::SSLeay::Handle", $ftps_ref->{data_ch} );

   } elsif ( $ftps_ref->{data_prot} eq DATA_PROT_CLEAR ) {
      $io = $ftps_ref->{data_ch};

   } else {
      # TODO: Fix so DATA_PROT_SAFE & DATA_PROT_CONFIDENTIAL work.
      return $self->_croak_or_return (0, "Currently doesn't support mode $ftps_ref->{data_prot} for data channels.");
   }

   _my_autoflush ( $io );

   # $self->_debug_print_hash ("host", "port", $ftps_ref->{data_prot}, $io, "=");

   return ( $io );
}

# Note: This doesn't reference $self on purpose! (so not a bug!)
#       See Bug Id 82094
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

# Note: This doesn't reference $self on purpose! (so not a bug!)
#       See Bug Id 82094
sub _my_close {
   my $io = shift;

   if ( $io->can ('close') ) {
      $io->close ();
   } else {
      close ($io);
   }

   return;
}

# The Shell wild cards are "*" & "?" only.
# So want to convert a shell pattern into its equivalent RegExp.
# Which means disabling all RegExp chars with special meaning and
# converting shell wild cards into its RegExp wild equivalent.
# Handles them all even if they are not legal in a file's name.
sub _convert_shell_pattern_to_regexp
{
  my $self         = shift;
  my $pattern      = shift;
  my $disable_star = shift;

  if ( $pattern ) {
     # There are 8 problem chars with special meaning in a RegExp ...
     # Chars:  . + ^ | $ \ * ?
     # But want to drop "*" & "?" since they are shell wild cards as well.
     $pattern =~ s/([.+^|\$\\])/\\$1/g;     # Ex: '.' to '\.'

     # As do these 3 types of brackets: (), {}, []
     $pattern =~ s/([(){}[\]])/\\$1/g;

     # Now convert the "?" into it's equivalent RegExp value ...
     $pattern =~ s/[?]/./g;          # All '?' to '.'.

     # Now convert the "*" into it's equivalent RegExp value ...
     unless ( $disable_star ) {
        $pattern =~ s/[*]/.*/g;     # All '*' to '.*'.
     }
  }

  return ( $pattern );
}


sub nlst {
  my $self    = shift;
  my $pattern = $_[1];

  if ( $pattern ) {
     $pattern = $self->_convert_shell_pattern_to_regexp ( $pattern, 1 );

     if ( $pattern =~ m/[*]/ ) {
        # Don't allow path separators in the string ...
        # Can't do this with regular expressions ...
        $pattern = join ( "[^\\\\/]*", split (/\*/, $pattern . "XXX") );
        $pattern =~ s/XXX$//;
     }
     $pattern = '(^|[\\\\/])' . $pattern . '$';
  }

  return ( $self->_common_list ("NLST", $pattern, @_) );
}

sub list {
  my $self    = shift;
  my $pattern = $_[1];

  if ( $pattern ) {
     $pattern = $self->_convert_shell_pattern_to_regexp ( $pattern, 1 );

     $pattern =~ s/[*]/\\S*/g;       # No spaces in file's name is allowed!
     $pattern = '\s+(' . $pattern . ')($|\s+->\s+)';   # -> is symbolic link!
  }

  return ( $self->_common_list ("LIST", $pattern, @_) );
}

# Get List details ...
sub mlsd {
  my $self    = shift;
  my $pattern = $_[1];

  if ( $pattern ) {
     $pattern = $self->_convert_shell_pattern_to_regexp ( $pattern, 0 );
     $pattern = '; ' . $pattern . '$';
  }

  return ( $self->_common_list ("MLSD", $pattern, @_) );
}

# Get file details ...
sub mlst {
  my $self = shift;
  my $file = shift;

  my $info;
  if ( $self->command ( "MLST", $file, @_ )->response () == CMD_OK ) {
     my @lines = split ("\n", $self->last_message ());
     $info = $lines[1];
     $info =~ s/^\s+//;
  }

  return ( $self->_test_croak ($info) );
}


sub parse_mlsx {
  my $self      = shift;
  my $features  = shift;    # Fmt: tag=val;tag=val;tag=val;...; file
  my $lowercase = shift || 0;

  my $empty;   # The return value on error ...
  return ( $empty ) unless ( $features );

  my ($feat_lst, $file) = split (/; /, $features, 2);
  return ( $empty )  unless ( defined $feat_lst && defined $file && $file );

  $feat_lst = lc ($feat_lst)  if ( $lowercase );

  # Now that we know it parses, lets grab the data.
  my %data;
  $data{";file;"} = $file;
  foreach ( split (/;/, $feat_lst) ) {
     return ( $empty )  unless ( $_ =~ m/=/ );   # tag=val format?

     my ($tag, $val) = split (/=/, $_, 2);
     return ( $empty )   unless ( $tag );        # Missing tag?

     $data{$tag} = (defined $val) ? $val : "";
  }

  return ( \%data );     # The parse worked!
}


# Returns an empty array on failure ...
sub _common_list {
  my $self      = shift;
  # ----- The Calculated Arguments -------------------------
  my $lst_cmd   = shift;           # LIST, NLST, or MLSD.
  my $pattern   = shift || "";     # The corrected pattern as a perl regular expression.
  # ----- The Forwarded Arguments --------------------------
  my $path      = shift || undef;  # Causes "" to be treated as "."!
  my $orig_ptrn = shift || undef;  # Only wild cards are * and ? (same as ls cmd)
  my $ftype     = shift || 0;      # Only used for MLSD!

  my $dati = "";

  # Open the data channel before issuing the appropriate list command ...
  unless ( $self->prep_data_channel( $lst_cmd ) ) {
    return ();    # Already decided not to call croak if you get here!
  }

  # Run the requested list type command ...
  unless ( $self->command ( $lst_cmd, $path )->response () == CMD_INFO ) {
     $self->_croak_or_return ();
     return ();
  }

  my ( $tmp, $io, $size );

  $size = ${*$self}{_FTPSSL_arguments}->{buf_size};

  $io = $self->_get_data_channel ();
  unless ( defined $io ) {
     return ();   # Already decided not to call croak if you get here!
  }

  while ( my $len = sysread $io, $tmp, $size ) {
    unless ( defined $len ) {
      next if $! == EINTR;
      my $type = lc ($lst_cmd) . "()";
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
  if ( $lst_cmd eq "LIST" ) {
     $dati =~ s/^\n//s   if ( $dati =~ s/^\s*total\s+\d+\s*$//mi );
     $dati =~ s/\n\n/\n/s;    # In case total not 1st line ...
  }

  # What if we asked to use patterns to limit the listing returned ?
  if ( $pattern ) {
     $self->_print_DBG ( "MAKE PATTERN: <- $orig_ptrn => $pattern ->\n" );

     # Now only keep those files that match the pattern.
     $dati = $self->_apply_list_pattern ($dati, $pattern);
  }

  my $mlsd_flg =( $lst_cmd eq "MLSD" && $ftype != 0 );
  $dati = $self->_apply_ftype_filter ($dati, $ftype)  if ($mlsd_flg);

  my $len = length ($dati);
  my $cblvl = 2;       # Offset to the calling function.
  my $total = 0;

  if ( $len > 0 ) {
     my $cb;
     ($total, $cb) = $self->_call_callback ($cblvl, \$dati, \$len, 0);
     if ( $cb ) {
        $dati = $self->_apply_list_pattern ($dati, $pattern);
        $dati = $self->_apply_ftype_filter ($dati, $ftype)  if ($mlsd_flg);
     }
  }

  # Process trailing call back info if present.
  my $trail;
  ($trail, $len, $total) = $self->_end_callback ($cblvl, $total);
  $trail = $self->_apply_list_pattern ($trail, $pattern);
  $trail = $self->_apply_ftype_filter ($$trail, $ftype)  if ($mlsd_flg);
  if ( $trail ) {
     $dati .= $trail;
  }

  return $dati ? split( /\n/, $dati ) : ();
}

# Filter the results based on the given pattern ...
sub _apply_list_pattern {
   my $self    = shift;
   my $data    = shift;
   my $pattern = shift;

   if ( $data && $pattern ) {
     $self->_print_DBG ( " USE PATTERN: $pattern\n" );
      my @res;
      foreach ( split ( /\n/, $data ) ) {
         push (@res, $_)  if ( $_ =~ m/$pattern/i );
      }
      $data = join ("\n", @res);
      $data .= "\n"   if ( $data );
   }

   return ($data);
}

# Filter the results based on the file type ... (MLSD only)
sub _apply_ftype_filter {
   my $self  = shift;
   my $data  = shift;
   my $ftype = shift;

   if ( $data && $ftype ) {
      my @types = qw / ALL REGULAR_DIRECTORY REGULAR_FILE SPECIAL_FILE SPECIAL_DIRECTORY /;
      $self->_print_DBG ( " FILE TYPE FILTER: $types[$ftype]\n" );
      my $type_active = 0;    # Assume the "type" attribute wasn't returned!
      my @res;

      # For each row that has a type attribute returned ...
      foreach ( split ( /\n/, $data ) ) {
         if ( $_ =~ m/(^|;)type=([^;]*);/i ) {
            my $t = lc ( $2 );
            $type_active = 1;    # The "type" attribute was returned!

            my $isSpecialDir = ( $t eq "cdir" || $t eq "pdir" );
            my $isRegDir = ( $t eq "dir" );
            my $isDir = ( $isRegDir || $isSpecialDir );
            my $isFile = ( $t eq "file" );

            if ( $ftype == 1 && $isRegDir ) {
               push (@res, $_);    # It's a regular directory ...
            } elsif ( $ftype == 2 && $isFile ) {
               push (@res, $_);    # It's a regular file ...
            } elsif ( $ftype == 3 && (! $isDir) && (! $isFile) ) {
               push (@res, $_);    # It's a special file ...
            } elsif ( $ftype == 4 && $isSpecialDir ) {
               push (@res, $_);    # It's a special directory ...
            }
         }
      }

      unless ( $type_active ) {
         warn ("Turn on TYPE feature with OPTS before filtering on file type!\n");
      }

      $data = join ("\n", @res);
      $data .= "\n"   if ( $data );
   }

   return ($data);
}

sub _get_local_file_size {
  my $self      = shift;
  my $file_name = shift;

  # Return the trivial cases ...
  return (0) unless ( -f $file_name);
  return (-s $file_name) if ( ${*$self}{_FTPSSL_arguments}->{type} eq MODE_BINARY );

  # If we get here, we know we are transfering the file in ASCII mode ...
  my $fd;
  unless ( open( $fd, "< $file_name" ) ) {
     return $self->_croak_or_return(0,
                             "Can't open file in ASCII mode! ($file_name) $!");
  }

  my ($len, $offset) = (0, 0);
  my $data;
  my $size = ${*$self}{_FTPSSL_arguments}->{buf_size} || 2048;

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
  if ( ${*$self}{_FTPSSL_arguments}->{type} eq MODE_BINARY ) {
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
     my $size = ${*$self}{_FTPSSL_arguments}->{buf_size} || 2048;

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
          $self->_print_DBG ("<<+ 222 HOT FIX  ==> Offset ($old ==> $offset) ",
                             "Since can't truncate between \\015 & \\012 ",
                             "in ASCII mode!\n");
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
  my $offset   = shift || ${*$self}{_FTPSSL_arguments}->{net_ftpssl_rest_offset} || 0;

  # Clear out this messy restart() cluge for next time ...
  delete ( ${*$self}{_FTPSSL_arguments}->{net_ftpssl_rest_offset} );

  if ( $offset < -1 ) {
    return $self->_croak_or_return(0, "Invalid file offset ($offset)!");
  }

  my ( $size, $localfd );
  my $close_file = 0;

  unless ($file_loc) {
    $file_loc = basename($file_rem);
  }

  $size = ${*$self}{_FTPSSL_arguments}->{buf_size} || 2048;

  if ( $self->_isa_glob ($file_loc) ) {
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
  if ( ${*$self}{_FTPSSL_arguments}->{type} eq MODE_BINARY ) {
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
        ${*$self}{_FTPSSL_arguments}->{last_ftp_msg} = $msg;    # Restore original error message!
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

  my $trace_flag = ${*$self}{_FTPSSL_arguments}->{trace};
  print STDERR "$func() trace ."  if ($trace_flag);
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

    print STDERR "."  if ($trace_flag && ($cnt % TRACE_MOD) == 0);
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

  print STDERR ". done! (" . $self->_fmt_num ($total) . " byte(s))\n"  if ($trace_flag);

  _my_close ($io);    # Old way $io->close();

  # To catch the expected "226 Closing data connection."
  if ( $self->response() != CMD_OK ) {
     close ($localfd)  if ( $close_file );
     return $self->_croak_or_return ();
  }

  if ( $close_file ) {
     close ($localfd);
     if ( ${*$self}{_FTPSSL_arguments}->{FixGetTs} ) {
        my $tm = $self->_mdtm ( $file_rem );
        utime ( $tm, $tm, $file_loc )  if ( $tm );
     }
  }

  return 1;
}


sub put {               # Regular put (STOR command)
  my $self = shift;
  my ($resp, $msg1, $msg2, $requested_file_name, $tm) = $self->_common_put (@_);

  if ( $resp && ${*$self}{_FTPSSL_arguments}->{FixPutTs} && defined $tm ) {
     $self->_mfmt ($tm, $requested_file_name);
  }

  return ( $resp );
}

sub append {            # Append put (APPE command)
  my $self = shift;
  my ($resp, $msg1, $msg2, $requested_file_name, $tm) = $self->_common_put (@_);

  if ( $resp && ${*$self}{_FTPSSL_arguments}->{FixPutTs} && defined $tm ) {
     $self->_mfmt ($tm, $requested_file_name);
  }

  return ( $resp );
}

sub uput {              # Unique put (STOU command)
  my $self = shift;
  my ($resp, $msg1, $msg2, $requested_file_name, $tm) = $self->_common_put (@_);

  # Now lets get the real name of the file uploaded!
  if ( $resp ) {
    # The file name may appear in either message returned.  (The 150 or 226 msg)
    # So lets check both messages merged together!
    my $msg = $msg1 . "\n" . $msg2;

    # -------------------------------------------------------
    # *** Assumes no spaces are in the new file's name! ***
    # -------------------------------------------------------
    if ( $msg =~ m/(FILE|name):\s*([^\s)]+)($|[\s)])/im ) {
       $requested_file_name = $2;   # We found an actual name to use ...

    } elsif ( $msg =~ m/Transfer starting for\s+([^\s]+)($|\s)/im ) {
       $requested_file_name = $1;   # We found an actual name to use ...
       $requested_file_name =~ s/[.]$//;   # Remove optional trailing ".".

    } elsif ( ${*$self}{_FTPSSL_arguments}->{uput} == 1 ) {
       # The alternate STOU command format was used where the remote
       # ftps server won't allow us to recomend any hints!
       # So we don't know what the remote server used for a filename
       # if it didn't appear in either of the message formats!
       $requested_file_name = "?";

    } else {
       $tm = undef;    # Disable's PreserveTimestamp if using default guess ...
    }

    # TODO: Figure out other uput variants to check for besides the ones above.

    # Until then, if we can't find the file name used in the messages,
    # we'll just have to assume that the default file name was used if
    # we were not explicitly told it wasn't being used!

    if ( $requested_file_name ne "?" ) {
       # Now lets update the timestamp for that file on the server ...
       # It's allowed to fail since we are not 100% sure of the remote name used!
       if ( ${*$self}{_FTPSSL_arguments}->{FixPutTs} && defined $tm ) {
          $self->_mfmt ($tm, $requested_file_name);
       }

       # Fix done in v0.25
       # Some servers returned the full path to the file.  But that sometimes
       # causes issues.  So always strip off the path information.
       $requested_file_name = basename ($requested_file_name);
    }

    return ( $requested_file_name );
  }

  return ( undef );        # Fatal error & Croak is turned off.
}


sub uput2 {             # Unique put (STOU command)
   my $self     = shift;
   my $file_loc = $_[0];

   my %before;
   foreach ( $self->nlst () ) { $before{$_} = 1; }
   return (undef)  if ($self->last_status_code () != CMD_OK);

   my $found_file;
   {
      # Temporarily disable timestamps ...
      local ${*$self}{_FTPSSL_arguments}->{FixPutTs} = 0;
      $found_file = $self->put (@_);
   }

   if ( defined $found_file ) {
      my @after;
      foreach ( $self->nlst () ) {
         push ( @after, $_ )  unless ( $before{$_} );
      }

      # Did we find only one possible answer?
      my $cnt = @after;
      if ( $cnt == 1 ) {
         $found_file = $after[0];     # Yes!
      } else {
         $found_file = $self->_croak_or_return ("?", "Can't determine what the file was called.  Found '${cnt}' candidates!");
      }

      # Do we update the timestamp on the uploaded file ?
      if ( $cnt == 1 &&
           ${*$self}{_FTPSSL_arguments}->{FixPutTs} &&
           ! $self->_isa_glob ($file_loc) ) {
         my $tm = (stat ($file_loc))[9];   # Get's the local file's timestamp!
         $self->_mfmt ($tm, $found_file);
      }
   }

   return ( $found_file );
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
   if ( defined $c &&
       ( $c eq "Net::FTPSSL::xput" || $c eq "Net::FTPSSL::xtransfer" ) ) {
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
     if ( $self->_isa_glob ($file_loc) ) {
       return $self->_croak_or_return (0, "When you pass a stream, you must specify the remote filename.");
     }

     $file_rem = basename ($file_loc);
   }

   my $scratch_name = $self->_get_scratch_file ($prefix, $body, $postfix,
                                                $file_rem);
   return undef  unless ($scratch_name);

   unless ( $self->all_supported ( "STOR", "DELE", "RNFR", "RNTO" ) ) {
      return $self->_croak_or_return (0, "Function xput is not supported by this server.");
   }

   # Now lets send the file.  Make sure we can't die during this process ...
   my $die = ${*$self}{_FTPSSL_arguments}->{Croak};
   ${*$self}{_FTPSSL_arguments}->{Croak} = 0;

   my ($resp, $msg1, $msg2, $requested_file_name, $tm) =
                              $self->_common_put ($file_loc, $scratch_name);

   if ( $resp ) {
     $self->_xWait ();   # Some servers require a wait before you may move on!

     # Delete any file sitting on the server with the final name we want to use
     # to avoid file permission issues.  Usually the file won't exist so the
     # delete will fail ...
     $self->delete ( $file_rem );

     # Now lets make it visible to the file recognizer ...
     $resp = $self->rename ( $requested_file_name, $file_rem );

     # Now lets update the timestamp for the file on the server ...
     # It's not an error if the file recognizer grabs it before the
     # timestamp is reset ...
     if ( $resp && ${*$self}{_FTPSSL_arguments}->{FixPutTs} && defined $tm ) {
        $self->_mfmt ($tm, $file_rem);
     }
   }

   # Delete the scratch file on error, but don't return this as the error msg.
   # We want the actual error encounterd from the put or rename commands!
   unless ($resp) {
     $msg1 = ${*$self}{_FTPSSL_arguments}->{last_ftp_msg};
     $self->delete ( $scratch_name );
     ${*$self}{_FTPSSL_arguments}->{last_ftp_msg} = $msg1;
   }

   # Now allow us to die again if we must ...
   ${*$self}{_FTPSSL_arguments}->{Croak} = $die;

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

   if ( $self->_isa_glob ($file_loc) ) {
      return $self->_croak_or_return (0, "xget doesn't support file_loc being an open file handle.");
   }

   my $scratch_name = $self->_get_scratch_file ( $prefix, $body, $postfix,
                                                 $file_loc );
   return undef  unless ($scratch_name);

   if (defined ${*$self}{_FTPSSL_arguments}->{net_ftpssl_rest_offset}) {
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

# Doesn't do the CF/LF transformation.
# It lets the source & dest servers do it if it's necessary!
# Please note that $self & $dest_ftp will write to different log files!
sub transfer {
   my $self        = shift;
   my $dest_ftp    = shift;        # A Net::FTPSSL object.
   my $remote_file = shift || "";
   my $dest_file   = shift || $remote_file;
   my $offset      = shift || ${*$self}{_FTPSSL_arguments}->{net_ftpssl_rest_offset} || 0;

   # Verify we are dealing with a Net::FTPSSL object ...
   if ( ref($dest_ftp) eq "" || ref($dest_ftp) ne __PACKAGE__ ) {
      return $self->_croak_or_return(0, "The destination server must be a valid Net::FTPSSL object! (" . ref($dest_ftp) . ")");
   }

   my $sArg = ${*$self}{_FTPSSL_arguments};
   my $dArg = ${*$dest_ftp}{_FTPSSL_arguments};

   # Clear out this messy restart() cluge for next time ...
   delete ( $sArg->{net_ftpssl_rest_offset} );

   # Don't care if this value was set or not.  Just remove it!
   # We just use any offset from ${*$self} instead ...
   delete ( $dArg->{net_ftpssl_rest_offset} );

   my ($stmp, $dtmp) = ($sArg->{Croak} || 0, $dArg->{Croak} || 0);
   if ( $stmp != $dtmp ) {
      my $msg = "Both connections must use the same Croak Settings for the transfer!";
      $msg .= "  (${stmp} vs ${dtmp})";
      $dest_ftp->_print_DBG ("<<+ 555 $msg\n");
      return $self->_croak_or_return (0, $msg);
   }

   ($stmp, $dtmp) = ($sArg->{type}, $dArg->{type});
   if ( $stmp ne $dtmp ) {
      my $msg = "Both connections must use ASCII or BIN for the transfer!";
      $msg .= "  (${stmp} vs ${dtmp})";
      $dest_ftp->_print_DBG ("<<+ 555 $msg\n");
      return $self->_croak_or_return(0, $msg);
   }

   my $size = $sArg->{buf_size} || 2048;

   # Validate the remaining arguments ...
   if ( ref($remote_file) || $remote_file eq "" ) {
      return $self->_croak_or_return(0, "The remote file must be a file name!");
   }
   if ( ref($dest_file) || $dest_file eq "" ) {
      return $self->_croak_or_return(0, "The destination file must be a file name!");
   }
   if ( $offset < -1 ) {
      return $self->_croak_or_return(0, "Invalid file offset ($offset)!");
   }

   # "(caller(1))[3]" returns undef if not called by another Net::FTPSSL method!
   my $c = (caller(1))[3];
   my $cb_idx = ( defined $c && $c eq "Net::FTPSSL::xtransfer" ) ? 2 : 1;
   my $func = ( $cb_idx == 1 ) ? "transfer" : "xtransfer";
   my $func2 = ( $cb_idx == 1 ) ? "Transfer" : "xTransfer";

   $self->_print_DBG ( "+++ Starting $func2 Between Servers +++\n");
   $dest_ftp->_print_DBG ( "--- Starting $func2 Between Servers ---\n");

   # Calculate the file offset to send to the FTPS source server via REST ...
   if ($offset == -1) {
      $offset = $dest_ftp->size ($dest_file);
      return (undef)  unless (defined $offset);
   }

   # -------------------------------------------------
   # Set up the transfer destination server ... (put)
   # -------------------------------------------------
   return (undef)  unless ( $dest_ftp->prep_data_channel ("STOR", $dest_file) );
   my $restart  = ($offset) ? $dest_ftp->_rest ($offset) : 1;
   my $response = $dest_ftp->_stor ($dest_file);
   unless ($restart && $response) {
      $dest_ftp->_rest (0)  if ($restart && $offset);
      return ($dest_ftp->_croak_or_return (), undef, undef, $dest_file, undef);
   }
   # my $put_msg = $dest_ftp->last_message ();
   my $dio = $dest_ftp->_get_data_channel ();
   return (undef)  unless (defined $dio);

   # -------------------------------------------------
   # Set up the transfer source server ... (get)
   # -------------------------------------------------
   unless ( $self->prep_data_channel( "RETR", $remote_file ) ) {
      _my_close ($dio);
      $dest_ftp->response ();
      return (undef);     # Already decided not to call croak if you get here!
   }
   my $rest = ($offset) ? $self->_rest ($offset) : 1;
   unless ( $rest && $self->_retr ($remote_file) ) {
      if ( $offset && $rest ) {
         my $msg = $self->last_message ();
         $self->_rest (0);                  # Must clear out on failure!
         $sArg->{last_ftp_msg} = $msg;    # Restore original error message!
      }
      _my_close ($dio);
      $dest_ftp->response ();
      return ($self->_croak_or_return ());
   }

   my $sio = $self->_get_data_channel ();
   unless (defined $sio) {
      _my_close ($dio);
      $dest_ftp->response ();
      return (undef)
   }

   my $trace_flag = $sArg->{trace};
   print STDERR "$func() trace ."  if ($trace_flag);

   my ($cnt, $total, $len) = (0, 0, 0);
   my $data;
   my $written;

   # So simple without CR/LF transformations ...
   while ( $len = sysread ($sio, $data, $size) ) {
      unless ( defined $len ) {
         next  if ( $! == EINTR );
         _my_close ($dio);
         $dest_ftp->response ();
         return $self->_croak_or_return (0, "System read error on $func(): $!");
      }

      print STDERR "."  if ($trace_flag && ($cnt % TRACE_MOD) == 0);
      ++$cnt;

      $total = $self->_call_callback ($cb_idx, \$data, \$len, $total);

      # Write to the destination server ...
      if ($len > 0) {
         $written = syswrite ($dio, $data, $len);
         unless (defined $written) {
            _my_close ($sio);
            $self->response ();
            return ($dest_ftp->_croak_or_return (0, "System write error on $func(): $!"));
         }
      }
   }   # End while reading from the source server ...


   # Process trailing "callback" info if returned.
   my $trail;
   ($trail, $len, $total) = $self->_end_callback ($cb_idx, $total);

   # Write to the destination server ...
   if ($trail && $len > 0) {
      $written = syswrite ($dio, $trail, $len);
      unless (defined $written) {
         _my_close ($sio);
         $self->response ();
         return ($dest_ftp->_croak_or_return (0, "System write error on $func(): $!"));
      }
   }

   print STDERR ". done!", $self->_fmt_num ($total) . " byte(s)\n"  if ($trace_flag);

   # Lets finish off both connections ...
   _my_close ($sio);
   _my_close ($dio);
   my $resp1 = $self->response ();
   my $resp2 = $dest_ftp->response ();

   if ($resp1 != CMD_OK || $resp2 != CMD_OK) {
      return ($self->_croak_or_return ());
   }

   # Preserve the timestamp on the transfered file ...
   if ($cb_idx == 1 && $sArg->{FixGetTs} && $dArg->{FixPutTs}) {
      my $tm = $self->_mdtm ($remote_file);
      $dest_ftp->_mfmt ($tm, $dest_file);
   }

   $self->_print_DBG ( "+++ $func2 Between Servers Completed +++\n");
   $dest_ftp->_print_DBG ( "--- $func2 Between Servers Completed ---\n");

   return (1);
}

sub xtransfer {
   my $self        = shift;
   my $dest_ftp    = shift;        # A Net::FTPSSL object.
   my $remote_file = shift || "";
   my $dest_file   = shift || $remote_file;

   # See _get_scratch_file() for default valuies if undef!
   my ($prefix, $postfix, $body) = (shift, shift, shift);

   if ( ref($dest_ftp) eq "" || ref($dest_ftp) ne __PACKAGE__ ) {
      return $self->_croak_or_return(0, "The destination server must be a valid Net::FTPSSL object! (" . ref($dest_ftp) . ")");
   }

   my $sArg = ${*$self}{_FTPSSL_arguments};
   my $dArg = ${*$dest_ftp}{_FTPSSL_arguments};

   if (defined $sArg->{net_ftpssl_rest_offset}) {
      return $self->_croak_or_return (0, "Can't call restart() before xtransfer()!");
   }
   if (defined $dArg->{net_ftpssl_rest_offset}) {
      return $dest_ftp->_croak_or_return (0, "Can't call restart() before xtransfer()!");
   }

   if ( $self->_isa_glob ($remote_file) ) {
      return $self->_croak_or_return (0, "xtransfer doesn't support REMOTE_FILE being an open file handle.");
   }
   if ( $self->_isa_glob ($dest_file) ) {
      return $self->_croak_or_return (0, "xtransfer doesn't support DEST_FILE being an open file handle.");
   }

   # Check if allowed on the destination server ...
   unless ( $dest_ftp->all_supported ( "STOR", "DELE", "RNFR", "RNTO" ) ) {
      return $dest_ftp->_croak_or_return (0, "Function xtransfer is not supported by the destination server.");
   }

   my $scratch_name = $self->_get_scratch_file ( $prefix, $body, $postfix,
                                                 $dest_file );
   return undef  unless ($scratch_name);

   # Save the current die settings for both servers ...
   my ($sdie, $ddie) = ($sArg->{Croak} || 0, $dArg->{Croak} || 0);
   if ( $sdie != $ddie ) {
      return $self->_croak_or_return (0, "xtransfer requires the Croak setting to be the same on both servers (${sdie} vs ${ddie})");
   }

   # Disable calling "die" on errors ... (save the current Croak setting again)
   ($sdie, $ddie) = ($sArg->{Croak}, $dArg->{Croak});
   (${*$self}{_FTPSSL_arguments}->{Croak}, ${*$dest_ftp}{_FTPSSL_arguments}->{Croak}) = (0, 0);

   # Now lets send the file, we can no longer die during this process ...
   my $resp = $self->transfer ($dest_ftp, $remote_file, $scratch_name, undef);

   if ( $resp ) {
      $dest_ftp->_xWait ();     # Some servers require a wait before moving on!

      # Delete any file sitting on the server with the final name we want to use
      # to avoid file permission issues.  Usually the file won't exist so the
      # delete will fail ...
      $dest_ftp->delete ( $dest_file );

      # Now lets make it visible to the file recognizer ...
      $resp = $dest_ftp->rename ( $scratch_name, $dest_file );

      # Now lets update the timestamp for the file on the dest server ...
      # It's not an error if the file recognizer grabs it before the
      # timestamp is reset ...
      if ($resp && $sArg->{FixGetTs} && $dArg->{FixPutTs}) {
         my $tm = $self->_mdtm ($remote_file);
         $dest_ftp->_mfmt ($tm, $dest_file);
      }
   }

   # Delete the scratch file on error, but don't return this as the error msg.
   # We want the actual error encounterd from the put or rename commands!
   unless ($resp) {
      my $msg1 = $dArg->{last_ftp_msg};
      $dest_ftp->delete ( $scratch_name );
      $dArg->{last_ftp_msg} = $msg1;
   }

   # Now allow us to die again if we must ...
   ($sArg->{Croak}, $dArg->{Croak}) = ($sdie, $ddie);

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
  my $offset   = shift || ${*$self}{_FTPSSL_arguments}->{net_ftpssl_rest_offset} || 0;

  # Clear out this messy restart() cluge for next time ...
  delete ( ${*$self}{_FTPSSL_arguments}->{net_ftpssl_rest_offset} );

  if ( $self->_isa_glob ($file_loc) && ! $file_rem ) {
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

  $size = ${*$self}{_FTPSSL_arguments}->{buf_size} || 2048;

  if ( $self->_isa_glob ($file_loc) ) {
    $localfd = \*$file_loc;

  } else {
    unless ( open( $localfd, "< $file_loc" ) ) {
      return $self->_croak_or_return (0, "Can't open local file! ($file_loc)");
    }
    $close_file = 1;
  }

  my $fix_cr_issue = 1;
  if ( ${*$self}{_FTPSSL_arguments}->{type} eq MODE_BINARY ) {
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
  unless ( defined ${*$self}{_FTPSSL_arguments}->{alloc_size} ) {
    if ( $close_file && -f $file_loc ) {
      my $size = -s $file_loc;
      $self->alloc($size);
    }
  }

  delete ${*$self}{_FTPSSL_arguments}->{alloc_size};

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

  my $trace_flag = ${*$self}{_FTPSSL_arguments}->{trace};
  print STDERR "$func() trace ."  if ($trace_flag);
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

    print STDERR "."  if ($trace_flag && ($cnt % TRACE_MOD) == 0);
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

  print STDERR ". done! (" . $self->_fmt_num ($total) . " byte(s))\n"  if ($trace_flag);

  my $tm;
  if ($close_file) {
     close ($localfd);
     if ( ${*$self}{_FTPSSL_arguments}->{FixPutTs} ) {
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
    ${*$self}{_FTPSSL_arguments}->{alloc_size} = $size;
  }
  else {
    return 0;
  }

  return 1;
}

sub delete {
  my $self = shift;
  return ($self->_test_croak ($self->command("DELE", @_)->response() == CMD_OK));
}

sub auth {
  my $self = shift;
  return ($self->_test_croak ($self->command("AUTH", "TLS")->response() == CMD_OK));
}

sub pwd {
  my $self = shift;
  my $path;

  $self->command("PWD")->response();

  if ( ${*$self}{_FTPSSL_arguments}->{last_ftp_msg} =~ /\"(.*)\".*/ )
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
  return ( $self->_test_croak ($self->command("CWD", @_)->response() == CMD_OK) );
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
    return ( $self->_test_croak ($self->response() == CMD_OK) );
}

# TODO: Make rmdir() working with recursion.
sub rmdir {
    my $self = shift;
    my $dir = shift;
    $self->command("RMD", $dir);
    return ( $self->_test_croak ($self->response() == CMD_OK) );
}

sub site {
  my $self = shift;

  return ($self->_test_croak ($self->command("SITE", @_)->response() == CMD_OK));
}

# A true boolean func, should never call croak!
sub supported {
   my $self = shift;
   my $cmd = uc (shift || "");
   my $sub_cmd = uc (shift || "");

   my $result = 0;        # Assume invalid FTP command
   my $arg = ${*$self}{_FTPSSL_arguments};

   # It will cache the result so OK to call multiple times.
   my $help = $self->_help ();

   # Only finds exact matches, no abbreviations like some FTP servers allow.
   if ( exists $arg->{OverrideHELP} && $cmd eq "HELP" ) {
      $arg->{last_ftp_msg} = "503 Unsupported command $cmd.";
   } elsif ( $arg->{OverrideHELP} || $help->{$cmd} ) {
      $result = 1;           # It is a valid FTP command
      $arg->{last_ftp_msg} = "214 The $cmd command is supported.";
   } else {
      $arg->{last_ftp_msg} = "502 Unknown command $cmd.";
   }

   # Are we validating a SITE sub-command?
   if ($result && $cmd eq "SITE" && $sub_cmd ne "") {
      my $help2 = $self->_help ($cmd);
      if ( $help2->{$sub_cmd} ) {
         $arg->{last_ftp_msg} = "214 The SITE sub-command $sub_cmd is supported.";
      } elsif ( scalar (keys %{$help2}) > 0 ) {
         $arg->{last_ftp_msg} = "502 Unknown SITE sub-command - $sub_cmd.";
         $result = 0;     # It failed after all!
      } else {
         $arg->{last_ftp_msg} = "503 Can't validate SITE sub-commands - $sub_cmd.";
         $result = -1;    # Maybe/mabye not supported!
      }
   }

   # Are we validating a FEAT sub-command?
   # Everything in the hash is a valid command.  But it's value is frequently "".
   # So must use "exists $fest2->{$cmd}" for all tests!
   if ($result && $cmd eq "FEAT" && $sub_cmd ne "") {
      my $feat2 = $self->_feat ();
      if ( exists $feat2->{$sub_cmd} ) {
         $arg->{last_ftp_msg} = "214 The FEAT sub-command $sub_cmd is supported.";
         if ( exists $feat2->{OPTS} && exists $feat2->{OPTS}->{$sub_cmd} ) {
            $arg->{last_ftp_msg} .= "  And its behaviour may be modified by OPTS.";
         }
      } else {
         $arg->{last_ftp_msg} = "502 Unknown FEAT sub-command - $sub_cmd.";
         $result = 0;     # It failed after all!
      }
   }

   # Are we validating a OPTS sub-command?
   # It's a special case of FEAT!
   if ($result && $cmd eq "OPTS" && $sub_cmd ne "") {
      my $feat3 = $self->_feat ();
      if ( exists $feat3->{OPTS} && exists $feat3->{OPTS}->{$sub_cmd} ) {
         $arg->{last_ftp_msg} = "214 The FEAT sub-command $sub_cmd may be modified by the OPTS command.";
      } elsif ( exists $feat3->{sub_cmd} ) {
         $arg->{last_ftp_msg} = "504 The FEAT sub-command $sub_cmd may not be modified by the OPTS command.";
      } else {
         $arg->{last_ftp_msg} = "505 The FEAT sub-command $sub_cmd doesn't exist and so can't be modified by the OPTS command.";
      }
   }

   $self->_print_DBG ( "<<+ ", $self->last_message (), "\n" );

   return ($result);
}


# A true boolean func, should never call croak!
sub all_supported {
   my $self = shift;
   # Leave the rest of the options on the @_ array ...

   my $cnt = 0;
   foreach ( @_ ) {
      next   unless (defined $_ && $_ ne "");
      ++$cnt;
      next   if ($self->supported ($_));
      return (0);    # Something wasn't supported!
   }

   return ( ($cnt >= 1) ? 1 : 0 );
}


# Hacks the _help() cache, otherwise can't modify the supported logic!
sub fix_supported {
   my $self = shift;
   my $mode = shift;  # True Add/False Remove
   # Leave the rest of the options on the @_ array ...

   # Can't update supported() if using OverrideHELP => 1. (Everything supported)
   return (0)  if ( ${*$self}{_FTPSSL_arguments}->{OverrideHELP} );

   # Holds the real cached help values ...
   my $help = ${*$self}{_FTPSSL_arguments}->{help_cmds_found};
   return (0)  unless ( defined $help );

   # Flag to tell if you can add/remove the HELP command from supported!
   my $help_flag = ( exists ${*$self}{_FTPSSL_arguments}->{OverrideHELP} ||
                     exists ${*$self}{_FTPSSL_arguments}->{removeHELP} );

   my $cnt = 0;
   foreach ( @_ ) {
      my $key = uc ($_);

      next  if ( $key eq "HELP" && $help_flag );

      if ( $mode && ! exists $help->{$key} ) {
         $help->{$key} = 3;      # Add the command as supported.
         ++$cnt;

      } elsif ( ! $mode && exists $help->{$key} ) {
         delete $help->{$key};   # Remove the command as supported.
         ++$cnt;
      }
   }

   return ( $cnt );
}


# The Clear Command Channel func is only valid after login.
sub ccc {
   my $self = shift;
   my $prot = shift || ${*$self}{_FTPSSL_arguments}->{data_prot};

   if ( ${*$self}{_FTPSSL_arguments}->{Crypt} eq CLR_CRYPT ) {
      return $self->_croak_or_return (undef, "Command Channel already clear!");
   }

   # Set the data channel to the requested security level ...
   # This command is no longer supported after the CCC command executes.
   unless ($self->_pbsz() && $self->_prot ($prot)) {
      return $self->_croak_or_return ();
   }

   # Do before the CCC command so we know which command is available to clear
   # out the command channel with.  All servers should support one or the other.
   # We also want commands that return just one line!  [To make it less likely
   # that the hack will cause response() to hang or get out of sync when
   # unrecognizable junk is returned for the hack.]
   my $ccc_fix_cmd = $self->supported ("NOOP") ? "NOOP" : "PWD";

   # Request that just the commnad channel go clear ...
   unless ( $self->command ("CCC")->response () == CMD_OK ) {
      return $self->_croak_or_return ();
   }
   ${*$self}{_FTPSSL_arguments}->{Crypt} = CLR_CRYPT;

   # Save before stop_SSL() removes the bless.
   my $bless_type = ref ($self);

   # Give the command channel a chance to stabalize again.
   sleep (1);

   # -------------------------------------------------------------------------
   # Stop SSL, but leave the socket open!
   # Converts $self to IO::Socket::INET object instead of Net::FTPSSL
   # NOTE: SSL_no_shutdown => 1 doesn't work on some boxes, and when 0,
   #       it hangs on others without the SSL_fast_shutdown => 1 option.
   # -------------------------------------------------------------------------
   unless ( $self->stop_SSL ( SSL_no_shutdown => 0, SSL_fast_shutdown => 1 ) ) {
      return $self->_croak_or_return (undef, "Command Channel downgrade failed!");
   }

   # Bless back to Net::FTPSSL from IO::Socket::INET ...
   bless ( $self, $bless_type );
   ${*$self}{_SSL_opened} = 0;      # To get rid of warning on quit ...

   # Give the command channel a chance to stabalize again.
   sleep (1);

   # -------------------------------------------------------------------------
   # This is a hack, but it seems to resolve the command channel corruption
   # problem where the 1st command or two afer CCC may fail or look strange ...
   # I've even caught it a few times sending back 2 independant OK responses
   # to a single command!
   # ------------------------------------------------------------------------
   my $ok = CMD_ERROR;
   foreach ( 1..4 ) {
      $ok = $self->command ($ccc_fix_cmd)->response (1);   # This "1" is a hack!

      # Do char compare since not always a number.
      last  if ( defined $ok && $ok eq CMD_OK );
      $ok = CMD_ERROR;
   }

   if ( $ok == CMD_OK ) {
      # Complete the hack, now force a failure response!
      # And if the server was still confused ?
      # Keep asking for responses until we get our error!
      $self->command ("xxxxNOOP");
      while ( $self->response () == CMD_OK ) {
         my $tmp = CMD_ERROR;   # A no-op command for loop body ...
      }
   }
   # -------------------------------------------------------------------------
   # End hack of CCC command recovery.
   # -------------------------------------------------------------------------

   return ( $self->_test_croak ( $ok == CMD_OK ) );
}


#-----------------------------------------------------------------------
# Allow the user to send a random FTP command directly, BE CAREFUL !!
# Since doing unsupported stuff, we can never call croak!
# Also not all unsupported stuff will show up via supported().
# So all we can do is try to prevent commands known to have side affects.
#-----------------------------------------------------------------------
sub quot {
   my $self = shift;
   my $cmd  = shift;

   # Format the command for testing ...
   my $cmd2 = (defined $cmd) ? uc ($cmd) : "";
   $cmd2 = $1  if ( $cmd2 =~ m/^\s*(\S+)(\s|$)/ );

   my $msg = "";   # Assume all is OK ...

   # The following FTP commands are known to open a data channel
   if ( $cmd2 eq "STOR" || $cmd2 eq "RETR" ||
        $cmd2 eq "NLST" || $cmd2 eq "LIST" ||
        $cmd2 eq "STOU" || $cmd2 eq "APPE" ||
        $cmd2 eq "MLSD" ) {
      $msg = "x23 Data Connections are not supported via quot().  [$cmd2]";

   } elsif ( $cmd2 eq "CCC" ) {
      $msg = "x22 Why didn't you call CCC directly via it's interface?";

   } elsif ( $cmd2 eq "" ) {
      $msg = "x21 Where is the needed command?";
      $cmd = "";    # Making sure it isn't undefined.

   } elsif ( $cmd2 eq "HELP" &&
              ( exists ${*$self}{_FTPSSL_arguments}->{OverrideHELP} ||
                exists ${*$self}{_FTPSSL_arguments}->{removeHELP} ) ) {
      $msg = "x20 Why did you try to call HELP after you overrode all calls to it?";

   } else {
      # Strip off leading spaces, some servers choak on them!
      $cmd =~ s/^\s+//;
   }

   if ( $msg ne "" ) {
      my $cmd_str = join (" ", $cmd, @_);
      ${*$self}{_FTPSSL_arguments}->{last_ftp_msg} = $msg;
      $self->_change_status_code (CMD_REJECT);
      $self->_print_DBG ( ">>+ ", $cmd_str, "\n" );
      $self->_print_DBG ( "<<+ ", $self->last_message (), "\n" );
      return (CMD_REJECT);
   }

   return ( $self->command ($cmd, @_)->response () );
}

#-----------------------------------------------------------------------
#  Type setting function
#-----------------------------------------------------------------------

sub ascii {
  my $self = shift;
  ${*$self}{_FTPSSL_arguments}->{type} = MODE_ASCII;
  return $self->_test_croak ($self->_type(MODE_ASCII));
}

sub binary {
  my $self = shift;
  ${*$self}{_FTPSSL_arguments}->{type} = MODE_BINARY;
  return $self->_test_croak ($self->_type(MODE_BINARY));
}

# Server thinks it's ASCII & Client thinks it's BINARY
sub mixedModeAI {
  my $self = shift;
  ${*$self}{_FTPSSL_arguments}->{type} = MODE_BINARY;
  return $self->_test_croak ($self->_type(MODE_ASCII));
}

# Server thinks it's BINARY & Client thinks it's ASCII
sub mixedModeIA {
  my $self = shift;
  ${*$self}{_FTPSSL_arguments}->{type} = MODE_ASCII;
  return $self->_test_croak ($self->_type(MODE_BINARY));
}

#-----------------------------------------------------------------------
#  Internal functions
#-----------------------------------------------------------------------

sub _xWait {
  my $self = shift;

  my $slp = ${*$self}{_FTPSSL_arguments}->{xWait};

  if ( $slp ) {
     $self->_print_DBG ("---- ", "Sleeping ${slp} second(s)\n");
     sleep ( $slp );
  }
}

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
  my $opt = shift || ${*$self}{_FTPSSL_arguments}->{data_prot};

  # C, S, E or P.
  my $resp = ( $self->command ( "PROT", $opt )->response () == CMD_OK );

  # Check if someone changed the data channel protection mode ...
  if ($resp && $opt ne ${*$self}{_FTPSSL_arguments}->{data_prot}) {
    ${*$self}{_FTPSSL_arguments}->{data_prot} = $opt;   # They did change it!
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

  # Works for most non-windows FTPS servers ...
  ${*$self}{_FTPSSL_arguments}->{uput} = 0;   # Conditionally uses scratch name.
  my $res = $self->command ( "STOU", @_ )->response ();
  return ( 1 ) if ( $res == CMD_INFO );

  # Some windows servers won't allow any arguments ...
  # They always use a scratch name!  (But don't always return what it is.)
  my $msg = $self->last_message ();
  if ( $res == CMD_ERROR && $msg =~ m/Invalid number of parameters/ ) {
     ${*$self}{_FTPSSL_arguments}->{uput} = 1;   # Will always use scratch name.
     $res = $self->command ( "STOU" )->response ();
  }

  return ( $res == CMD_INFO );
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

# Uses the PreserveTimestamp kludge!
# If not preserving timestamps, assumes GMT!
sub _mfmt {
  my $self = shift;
  my $timestamp = shift;    # (stat ($loc_file))[9] - The local file's timestamp!
  my $remote_file = shift;
  my $local = shift;        # True Local / False GMT / Undef use PreserveTimestamp

  # Asks if the FTPS server is using GMT or Local time for the returned timestamp.
  my $GMT_flag = 1;         # Assume GMT ...
  if ( defined $local ) {
     $GMT_flag = $local ? 0 : 1;    # Override PreserveTimestamp option ...
  } elsif ( ${*$self}{_FTPSSL_arguments}->{FixPutTs} < 0 ) {
     $GMT_flag = 0;                 # PreserveTimestamp said to use Local Time ...
  }

  # Convert it into YYYYMMDDHHMMSS format (GM Time) [ gmtime() vs localtime() ]
  my ($sec, $min, $hr, $day, $mon, $yr, $wday, $yday, $isdst);

  # Using perl's built-in functions here. (years offset of 1900.)
  if ( $GMT_flag ) {
     # Use GMT Time  [ gmtime() vs timegm() ]
     ($sec, $min, $hr, $day, $mon, $yr, $wday, $yday, $isdst) =
                  gmtime ( $timestamp );
  } else {
     # Use Local Time  [ localtime() vs timelocal() ]
     ($sec, $min, $hr, $day, $mon, $yr, $wday, $yday, $isdst) =
                  localtime ( $timestamp );
  }

  my $time = sprintf ("%04d%02d%02d%02d%02d%02d",
                      $yr + 1900, $mon + 1, $day, $hr, $min, $sec);

  # Upload the file's new timestamp ...
  return ( $self->command ( "MFMT", $time, $remote_file )->response () == CMD_OK );
}


# Parses the remote FTPS server's response for the file's timestamp!
# Now in a separate function due to server bug reported by Net::FTP!
# Returns:  undef or the timestamp in YYYYMMDDHHMMSS (len 14) format!
sub _internal_mdtm_parse {
  my $self = shift;

  # Get the message returned by the FTPS server for the MDTM command ...
  my $msg = ${*$self}{_FTPSSL_arguments}->{last_ftp_msg};

  my $gmt_time_str;

  # Check for the expected timestamp format ...
  if ( $msg =~ m/(^|\D)(\d{14})($|\D)/ ) {
     $gmt_time_str = $2;   # The timestamp on the remote server: YYYYMMDDHHMMSS.

  # According to Net::FTP, some idiotic FTP server bug used
  # ("19%d", tm.tm_year") instead of ("%d", tm.tm_year+1900)
  # to format the year.  So converting it into the expected format!
  # This way this bug isn't propagated outside this function!
  # Fix doesn't work for dates before 1-1-1910, which should never happen!
  } elsif ( $msg =~ m/(^|\D)19(\d{3})(\d{10})($|\D)/ ) {
     my ( $yr, $rest ) = ( $2, $3 );

     # The corrected date ...
     $gmt_time_str = sprintf ("%04d%s", 1900 + $yr, $rest);

     $self->_print_DBG ("---- ", "Bad Year: 19${yr}${rest}!  ",
                        "Converting to ${gmt_time_str}\n");
  }

  return ( $gmt_time_str );
}

sub mdtm {
  my $self = shift;

  my $gmt_time_str;

  if ( $self->command( "MDTM", @_ )-> response () == CMD_OK ) {
     $gmt_time_str = $self->_internal_mdtm_parse ();
  }

  return ( $self->_test_croak ($gmt_time_str) );  # In GMT time ...
}

# Uses the PreserveTimestamp kludge!
# If not preserving timestamps, assumes GMT!
sub _mdtm {
  my $self = shift;
  my $remote_file = shift;
  my $local = shift;        # True Local / False GMT / Undef use PreserveTimestamp

  my $timestamp;            # The return value ...

  # Asks if the FTPS server is using GMT or Local time for the returned timestamp.
  my $GMT_flag = 1;         # Assume GMT ...
  if ( defined $local ) {
     $GMT_flag = $local ? 0 : 1;    # Override PreserveTimestamp option ...
  } elsif ( ${*$self}{_FTPSSL_arguments}->{FixGetTs} < 0 ) {
     $GMT_flag = 0;                 # PreserveTimestamp said to use Local Time ...
  }

  # Collect the timestamp from the FTPS server ...
  if ( $self->command ("MDTM", $remote_file)->response () == CMD_OK ) {
     my $time_str = $self->_internal_mdtm_parse ();

     # Now convert it into the internal format used by Perl ...
     if ( defined $time_str &&
          $time_str =~ m/^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})$/ ) {
        my ($yr, $mon, $day, $hr, $min, $sec) = ($1, $2, $3, $4, $5, $6);

        # Using Time::Local functions here.
        # (Not a true inverse of the built-in funcs with regards to the year.)
        if ( $GMT_flag ) {
           # Use GMT Time  [ timegm() vs gmtime() ]
           $timestamp = timegm ( $sec, $min, $hr, $day, $mon - 1, $yr );
        } else {
           # Use Local Time  [ timelocal() vs localtime() ]
           $timestamp = timelocal ( $sec, $min, $hr, $day, $mon - 1, $yr );
        }
     }
  }

  return ( $timestamp );
}

sub size {
   my $self = shift;
   my $file = shift;
   my $skip_mlst = shift || 0;   # Not in POD on purpose!

   # The expected option ...
   if ( $self->supported ("SIZE") ) {
      if ( $self->command ("SIZE", $file, @_)->response () == CMD_OK &&
           $self->message () =~ m/\d+\s+(\d+)($|\D)/ ) {
         return ( $1 );      # The size in bytes!  May be zero!
      }
   }

   # Will only set to 1 if we know the file is really a directory!
   my $skip_stat = 0;

   # Not implemented on many FTPS servers ...
   # But is the most reliable way if it is ...
   # It returns the size for all file types, not just regular files!
   if ( $self->supported ("MLST") && ! $skip_mlst ) {
      # Must use "OPTS MLST SIZE" if the size feature is currently disabled.
      my $data = $self->parse_mlsx ( $self->mlst ($file), 1 );
      if ( $data ) {
         if ( exists $data->{size} ) {
            return ( $data->{size} );  # The size in bypes!  May be zero!

         # Is it a directory?  If so, we'd like to skip executing "STAT".
         } elsif ( exists $data->{type} ) {
            my $t = $data->{type};
            $skip_stat = 1  if ( $t eq "dir" || $t eq "cdir" || $t eq "pdir" );
         }

         warn ("Turn on SIZE feature with OPTS before using this function!\n");
      }
   }

   # Note: If $file is in fact a directory, STAT will return the directory's
   # contents!  Which can be very slow if there are tons of files in the dir!
   if ( $self->supported ("STAT") && ! $skip_stat ) {
      if ( $self->command ("STAT", $file, @_)->response () == CMD_OK ) {
         my @msg = split ("\n", $self->message ());
         my $cnt = @msg;
         my $rFile = $self->_mask_regex_chars ( basename ($file) );

         # ... Size Filename
         if ( $cnt == 3 && $msg[1] =~ m/\s(\d+)\s+${rFile}/ ) {
            return ( $1 );     # The size in bytes!  May be zero!
         }
         # ... Size Month Day HH:MM Filename
         if ( $cnt == 3 && $msg[1] =~ m/\s(\d+)\s+(\S+)\s+(\d+)\s+(\d+:\d+)\s+${rFile}/ ) {
            return ( $1 );     # The size in bytes!  May be zero!
         }
      }
   }

   return ( $self->_test_croak (undef) );   # It's not a regular file!
}

sub ls {
   my $self = shift;
   return ( $self->nlst (@_) );
}

sub dir {
   my $self = shift;
   return ( $self->list (@_) );
}

sub is_file {
   my $self = shift;
   my $file = shift;

   my $isFile = 0;    # Assume not a regular file ...

   # Now let's disable Croak so we can't die during this test ...
   my $die = $self->set_croak (0);

   # Not implemented on many FTPS servers ...
   # But it's the most reliable way if it is ...
   if ( $self->supported ("MLST") ) {
      # Must use "OPTS MLST TYPE" if the type feature is currently disabled.
      my $data = $self->parse_mlsx ( $self->mlst ($file), 1 );

      # We now know something was found, but we don't yet know what it is!
      if ( $data ) {
         if ( exists $data->{type} ) {
            my $t = $data->{type};
            $isFile = ( $t eq "file" ) ? 1 : 0;
            $self->set_croak ( $die );           # Restore the croak settings!
            return ( $isFile );
         }
         warn ("Turn on TYPE feature with OPTS before using this function!\n");
      }
   }

   my $size = $self->size ( $file, 1 );

   $self->set_croak ( $die );              # Restore the croak settings!

   if ( defined $size && $size >= 0 ) {
      return ( 1 );    # It's a plain file!  We successfully got it's size!
   }

   return ( 0 );       # It's not a plain file or it doesn't exist!
}

sub is_dir {
   my $self = shift;
   my $dir  = shift;

   my $isDir = 0;     # Assume not a directory ...

   # The current direcory!
   my $curDir = $self->pwd ();

   # Now let's disable Croak so we can't die during this test ...
   my $die = $self->set_croak (0);

   # Not implemented on many FTPS servers ...
   # But it's the most reliable way if it is ...
   if ( $self->supported ("MLST") ) {
      # Must use "OPTS MLST TYPE" if the type feature is currently disabled.
      my $data = $self->parse_mlsx ( $self->mlst ($dir), 1 );

      # We now know something was found, but we don't yet know what it is!
      if ( $data ) {
         if ( exists $data->{type} ) {
            my $t = $data->{type};
            $isDir = ( $t eq "dir" || $t eq "cdir" || $t eq "pdir" ) ? 1 : 0;
            $self->set_croak ( $die );           # Restore the croak settings!
            return ( $isDir );
         }
         warn ("Turn on TYPE feature with OPTS before using this function!\n");
      }
   }

   # Check if it's a directory we have access to ...
   if ( $self->cwd ( $dir ) ) {
      $self->cwd ( $curDir );
      $isDir = 1;

   } else {
      # At this point if it's really a directory, we don't have access to it.
      # And parsing error messages really isn't an option.

      # So what if we now assume it it might be a directory if "is_file()"
      # returns false and we can see that the file does exists via "nlst()"?

      # I don't really like that no-access test, too many chances for false
      # positives, so I'm open to better ideas!  I'll leave this code disabled
      # until I can mull this over some more.

      # Currently disabled ...
      if ( 1 != 1 ) {
         # If it isn't a regular file, then it might yet still be a directory!
         unless ( $self->is_file ( $dir ) ) {
            # Now check if we can see a file of this name ...
            my @lst = $self->nlst (dirname ($dir), basename ($dir));
            if ( scalar (@lst) ) {
               # It may or may not be a directory ...
               $self->_print_DBG ("--- Found match: ", $lst[0], "\n");
               $isDir = 1;
            }
         }
      }
   }

   $self->set_croak ( $die );              # Restore the croak settings!

   return ( $isDir );
}

sub copy_cc_to_dc {
   my $self = shift;
   my $args = (ref ($_[0]) eq "ARRAY") ? $_[0] : \@_;

   my %dcValues;
   if ( exists ${*$self}{_FTPSSL_arguments}->{myContext} ) {
      %dcValues = %{${*$self}{_FTPSSL_arguments}->{myContext}};
   }

   my $cnt = 0;
   foreach ( @{$args} ) {
      my $val;
      if ( exists ${*$self}{_SSL_arguments}->{$_} ) {
         $val = ${*$self}{_SSL_arguments}->{$_};

      } elsif ( exists ${*$self}{_FTPSSL_arguments}->{start_SSL_opts}->{$_} ) {
         $val = ${*$self}{_FTPSSL_arguments}->{start_SSL_opts}->{$_};

      } elsif ( exists ${*$self}{$_} ) {
         $val = ${*$self}{$_};

      } else {
         $self->_print_DBG ("No such Key defined for the CC: ", $_, "\n");
         next;
      }

      $dcValues{$_} = $val;
      ++$cnt;
   }

   # Update with the new Data Channel options ...
   if ( $cnt > 0 ) {
      ${*$self}{_FTPSSL_arguments}->{myContext} = \%dcValues;
   }

   if ( ${*$self}{_FTPSSL_arguments}->{debug} ) {
      $self->_debug_print_hash ( "DC Hash", "options", "cc2dc($cnt)", \%dcValues, "#" );
   }

   return ( $cnt );
}

sub set_dc_from_hash {
   my $self = shift;
   my $args = (ref ($_[0]) eq "HASH") ? $_[0] : {@_};

   my %dcValues;
   if ( exists ${*$self}{_FTPSSL_arguments}->{myContext} ) {
      %dcValues = %{${*$self}{_FTPSSL_arguments}->{myContext}};
   }

   my $cnt = 0;
   foreach my $key ( keys %{$args} ) {
      my $val = $args->{$key};

      if ( defined $val ) {
         # Add the requested value to the DC hash ...
         $dcValues{$key} = $val;
         ++$cnt;

      } elsif ( exists $dcValues{$key} ) {
         # Delete the requested value from the DC hash ...
         delete $dcValues{$key};
         ++$cnt;
      }
   }

   # Update with the new Data Channel options ...
   if ( $cnt > 0 ) {
      ${*$self}{_FTPSSL_arguments}->{myContext} = \%dcValues;
   }

   if ( ${*$self}{_FTPSSL_arguments}->{debug} ) {
      $self->_debug_print_hash ( "DC Hash", "options", "setdc($cnt)", \%dcValues, "%" );
   }

   return ( $cnt );
}

#-----------------------------------------------------------------------
#  Checks what commands are available on the remote server
#  If a "*" follows a command, it's unimplemented!
#  The caller is free to modify the returned hash refrence.
#  It's just a copy of what's been cached, not the original!
#-----------------------------------------------------------------------
#  The returned hash may contain both active & disabled FTP commands.
#  If disabled, the command's value will be 0.  Otherwise it will
#  contain a non-zero value.  So testing using "exists" is BAD form now.
#-----------------------------------------------------------------------
#  Please remember that when OverrideHELP=>1 is used, it will always
#  return an empty hash!!!
#-----------------------------------------------------------------------

sub _help {
   # Only shift off self, bug otherwise!
   my $self = shift;
   my $cmd = uc ($_[0] || "");   # Converts undef to "". (Do not do a shift!)

   # Check if requesting a list of all commands or details on specific commands.
   my $all_cmds = ($cmd eq "");
   my $site_cmd = ($cmd eq "SITE");

   my %help;
   my $arg = ${*$self}{_FTPSSL_arguments};

   # Only possible if _help() is called before 1st call to supported()!
   unless ( $all_cmds || exists $arg->{help_cmds_msg} ) {
      $self->_help ();
   }

   # Use FEAT instead of HELP to populate the supported hash!
   # Assuming the HELP command itself is broken!  "via OverrideHELP=>-1"
   if ( exists $arg->{removeHELP} && $arg->{removeHELP} == 1 ) {
      my $ft = $self->_feat ();
      $ft->{FEAT} = 2  if (scalar (keys %{$ft}) > 0);
      foreach ( keys %{$ft} ) { $ft->{$_} = 2; }  # So always TRUE

      $arg->{help_cmds_found} = $ft;
      $arg->{help_cmds_msg}   = $self->last_message ();

      $self->_site_help ( $arg->{help_cmds_found} );
      $arg->{removeHELP} = 2;     # So won't execute again ...
   }

   # Now see if we've cached any results previously ...
   my $key;
   if ($all_cmds && exists $arg->{help_cmds_msg}) {
      $arg->{last_ftp_msg} = $arg->{help_cmds_msg};
      $key = "help_cmds_found";
      %help = %{$arg->{$key}}  if ( exists $arg->{$key} );
      return ( \%help );

   } elsif (exists $arg->{"help_${cmd}_msg"}) {
      $arg->{last_ftp_msg} = $arg->{"help_${cmd}_msg"};
      $key = "help_${cmd}_found";
      %help = %{$arg->{$key}}  if ( exists $arg->{$key} );
      return ( \%help );

   } elsif ( exists $arg->{help_cmds_no_syntax_available} ) {
      if ( exists $arg->{help_cmds_found}->{$cmd} || $arg->{OverrideHELP} ) {
         $arg->{last_ftp_msg} = "503 Syntax for ${cmd} is not available.";
      } else {
         $arg->{last_ftp_msg} = "501 Unknown command ${cmd}.";
      }
      # $self->_print_DBG ( "<<+ ", $self->last_message (), "\n" );
      return ( \%help );    # The empty hash ...
   }

   # From here on out, we will get at least one server hit ...

   my $sts;
   if ($all_cmds) {
      $sts = $self->command ("HELP")->response ();
      $arg->{help_cmds_msg} = $self->last_message ();
      $arg->{help_cmds_no_syntax_available} = 1  if ( $sts != CMD_OK );
   } else {
      $sts = $self->command ("HELP", @_)->response ();
      $arg->{"help_${cmd}_msg"} = $self->last_message ();
   }

   # If failure, return empty hash ...
   return (\%help)  if ( $sts != CMD_OK );

   # Check if "HELP" & "HELP CMD" return the same thing ...
   if ( (! $all_cmds) && $arg->{help_cmds_msg} eq $self->last_message () ) {
      $arg->{help_cmds_no_syntax_available} = 1;
      delete $arg->{"help_${cmd}_msg"};  # Delete this wrong message ...
      return ( $self->_help ($cmd) );    # Recursive to get the right error msg!
   }

   # HELP ...
   if ( $all_cmds ) {
      %help = %{$self->_help_parse (0)};

      # If we don't find anything for HELP, it's a problem.
      # So don't cache if false ...
      if (scalar (keys %help) > 0) {
         if ($help{FEAT}) {
            # Now put any new features into the help response as well ...
            my $feat = $self->_feat ();
            foreach (keys %{$feat}) {
               $help{$_} = 2  unless (exists $help{$_});
            }
         }

         my %siteHelp;
         my $msg;
         if ($help{SITE}) {
            # See if this returns a usage statement or a list of SITE commands!
            %siteHelp = %{$self->_help ("SITE")};
            $msg = $self->message () if ( $self->last_status_code() == CMD_OK );
         }

         # Do only if no SITE details yet ...
         if (scalar (keys %siteHelp) == 0) {
            $self->_site_help (\%help, $msg);
         }

         my %lclHelp = %help;
         $arg->{help_cmds_found} = \%lclHelp;
      }

   # HELP SITE ...
   } elsif ( $site_cmd ) {
      %help = %{$self->_help_parse (1)};

      # If we find something, it means it's returning the list of SITE commands.
      # Some servers do this rather than returning a syntax statement.
      if (scalar (keys %help) > 0) {
         my %siteHelp = %help;
         $arg->{help_SITE_found} = \%siteHelp;
      }

   # HELP some_other_command ...
   } else {
      # Nothing really to do here ...
   }

   return (\%help);
}

#---------------------------------------------------------------------------
# Try to get a list of SITE commands supported.
#---------------------------------------------------------------------------
sub _site_help
{
   my $self = shift;
   my $help = shift;     # Parent help hash
   my $msg  = shift;     # Optional override message.

   my $arg = ${*$self}{_FTPSSL_arguments};

   # Not calling site() in case Croak is turned on.
   # It's not a fatal error if this call fails ...
   # my $ok = $self->site ("HELP");
   my $ok = ($self->command("SITE", "HELP")->response() == CMD_OK);

   $arg->{help_SITE_msg} = $self->last_message ();

   if ( $ok ) {
      my $siteHelp = $self->_help_parse (1);

      if (scalar (keys %{$siteHelp}) > 0) {
         if ( defined $help ) {
            $help->{SITE}  = -1  unless ( exists $help->{SITE} );
         }
         $siteHelp->{HELP} = -1  unless ( exists $siteHelp->{HELP} );
         $arg->{help_SITE_found} = $siteHelp;

         # Only do optional override of the cached message on success!
         $arg->{help_SITE_msg} = $msg  if ( $msg );
      }
   }

   return;
}

#---------------------------------------------------------------------------
# Handles the parsing of the "HELP", "HELP SITE" & "SITE HELP" commands ...
# Not all servers return a list of commands for the 2nd two items.
#---------------------------------------------------------------------------
sub _help_parse {
   my $self     = shift;
   my $site_cmd = shift;      # Only 0 for HELP.

   # This value is used to distinguish which call set the hash entry.
   # No logic is based on it.  Just done to ease debugging later on!
   my $flag = ($site_cmd) ? -2 : 1;

   my $helpmsg = $self->last_message ();
   my @lines = split (/\n/, $helpmsg);

   my %help;

   foreach my $line (@lines) {
      # Strip off the code & separator or leading blanks if multi line.
      $line =~ s/((^[0-9]+[\s-]?)|(^\s*))//;
      my $lead = $1;

      next  if ($line eq "");

      # Skip over the start/end part of the response ...
      # Doesn't work for all servers!
      # next  if ( defined $lead && $lead =~ m/^\d+[\s-]?$/ );

      # Make sure no space between command & the * that marks it unsupported!
      # May be more than one hit per line ...
      $line =~ s/(\S)\s+[*]($|\s|,)/$1*$2/g;

      my @lst = split (/[\s,.]+/, $line);  # Break into individual commands

      if ( $site_cmd && $lst[0] eq "SITE" && $lst[1] =~ m/^[A-Z]+$/ ) {
         $help{$lst[1]} = 1;    # Each line: "SITE CMD mixed-case-usage"
      }
      # Now only process if nothing is in lower case (ie: its a comment)
      # All commands must be in upper case, some special chars not allowed.
      # Commands ending in "*" are currently turned off.
      elsif ( $line !~ m/[a-z()]/ ) {
         foreach (@lst) {
            # $help{$_} = 1   if ($_ !~ m/[*]$/);
            if ($_ !~ m/^(.+)[*]$/) {
               $help{$_} = $flag;   # Record enabled for all options ...
            } elsif ( $site_cmd == 0 ) {
               $help{$1} = 0;       # Record command is disabled for HELP.
            }
         }
      }
   }

   return (\%help);
}

#-----------------------------------------------------------------------
# Returns a hash of features supported by this server ...
# It's always uses the cache after the 1st call ... this list never changes!
# Making this a static list!
# This is the version used internally by _help & supported!
#-----------------------------------------------------------------------

sub _feat {
   my $self = shift;

   my $arg = ${*$self}{_FTPSSL_arguments};

   # Check to see if we've cached the result previously ...
   # Must use slightly different naming convenion than used
   # in _help() to avoid conflicts.  [set in feat()]
   if (exists $arg->{help_FEAT_msg2}) {
      $arg->{last_ftp_msg} = $arg->{help_FEAT_msg2};
      my %hlp = %{$arg->{help_FEAT_found2}};
      return ( \%hlp );
   }

   my $res = $self->feat (1);   # Undocumented opt to disable Croak if on!

   return ($res);   # Feel free to modify it if you wish!  Won't harm anything!
}


#-----------------------------------------------------------------------
# Returns a hash of features supported by this server ...
# It's conditionally cached based on the results of the 1st call to FEAT!
# So on some servers this list will be static, while on others dynamic!
#-----------------------------------------------------------------------
# The FEAT command returns one line per command, with optional behaviors.
# If the command ends in "*", the command isn't supported by FEAT!
# And if not supported it won't show up in the hash!
#   Format:  CMD [behavior]
#-----------------------------------------------------------------------
# If one or more commands have behaviors, then it's possible for the
# results of the FEAT command to change based on calls to
#    "OPTS CMD behavior"
# So if even one command has a behavior, there will be a server hit
# to see if the FEAT results changed.  It will also add OPTS to the hash!
# Otherwise the results are cached!
#-----------------------------------------------------------------------
# Note: {help_FEAT_found2} & {help_FEAT_msg2} are used here since it's
#       possible that {help_FEAT_found} & {help_FEAT_msg} can be auto
#       generated via "HELP FEAT"  [during a call to _help("FEAT").]
#       These special vars are only used in feat() & _feat().
#-----------------------------------------------------------------------
sub feat {
   my $self = shift;
   my $disable_croak = shift;    # Undocumented option in POD on purpose!
                                 # Only used when called from _feat()!

   my $arg = ${*$self}{_FTPSSL_arguments};

   my %res;

   # Conditionally use the cache if the server will always return a static list!
   # It will be static if the OPTS command isn't supported!
   if ( exists $arg->{help_FEAT_found2} &&
        ! exists $arg->{help_FEAT_found2}->{OPTS} ) {
      $arg->{last_ftp_msg} = $arg->{help_FEAT_msg2};
      %res = %{$arg->{help_FEAT_found2}};
      return ( \%res );
   }

   # Check if a request has been made to not honor HELP if in the FEAT list.
   my $remove = "";
   if ( $arg->{removeHELP} ) {
      $remove = "-1";
   } elsif ( exists $arg->{OverrideHELP} ) {
      $remove = $arg->{OverrideHELP};
      if ( $remove == 0 ) {
         my @lst = keys %{$arg->{help_cmds_found}};
         $remove = "[array]"  if ($#lst != -1);
      }
   }
   my $mask = "HELP * OverrideHELP=>${remove} says to remove this command.";

   # Check if a request has been made to not honor HELP if in the FEAT list.
   if ( $remove ne "" ) {
      $arg->{_hide_value_in_response_} = "HELP";
      $arg->{_mask_value_in_response_} = $mask;
   }

   my $status = $self->command ("FEAT")->response ();

   if ( $remove ne "" ) {
      $arg->{last_ftp_msg} =~ s/HELP/<${mask}>/i;
      delete $arg->{_hide_value_in_response_};
      delete $arg->{_mask_value_in_response_};
   }

   if ( $status == CMD_OK ) {
      my @lines = split (/\n/, $self->last_message ());
      my %behave;

      my $may_change = 0;    # Assume always returns an unchanging list ...
      foreach my $line (@lines) {
         # Strip off the code & separator or leading blanks if multi line.
         $line =~ s/((^[0-9]+[\s-]?)|(^\s*))//;
         my $lead = $1;

         # Skip over the start/end part of the response ...
         next if ( defined $lead && $lead =~ m/^\d+[\s-]?$/ );

         next if ( $line eq "" );             # Skip over all blank lines

         my @part = split (/\s+/, $line);

         # Command ends in "*" or the next part is "*" ???
         # Used to conditionally remove the HELP cmd if necessary ...
         # Otherwise not sure if this test ever really happens ...
         next if ($part[0] =~ m/[*]$/ || (defined $part[1] && $part[1] eq "*"));

         # The value is the rest of the command ...
         if ( $#part == 0 ) {
            $res{$part[0]} = "";     # No behavior defined.
         } else {
            # Save the behavior!
            $behave{$part[0]} = $res{$part[0]} = (split (/\s+/, $line, 2))[1];
            $may_change = 1;
         }
      }

      if ( $may_change ) {
         # Added per RFC 2389: It says OPTS is an assumed command if FEAT is
         # supported.  But some servers fail to implement OPTS if there are
         # no features it can modify.  So adding OPTS to the hash only if at
         # least one FEAT command has a behavior string defined!
         # If no behaviors are defined it will assume the OPTS command isn't
         # supported after all!
         my $msg = (exists $res{OPTS}) ? "Updating OPTS Command!"
                                       : "Auto-adding OPTS Command!";
         $self->_print_DBG ("<<+ ", CMD_INFO, "11 ", $msg, "\n");

         # Adding hash reference to list all valid OPTS commands ...
         $res{OPTS} = \%behave;
      }
   }

   # Only cache the results if the 1st time called!  This cache is only used by
   # this method if OPTS is not supported!  But its always used by _feat()!
   unless ( exists $arg->{help_FEAT_msg2} ) {
      my %res2 = %res;
      $arg->{help_FEAT_found2} = \%res2;
      $arg->{help_FEAT_msg2} = $self->last_message ();
   }

   unless ( $status == CMD_OK || $disable_croak ) {
      $self->_croak_or_return ();
   }

   return (\%res);   # The caller is free to modify the hash if they wish!
}

#-----------------------------------------------------------------------
#  Enable/Disable the Croak logic!
#  Returns the previous Croak setting!
#-----------------------------------------------------------------------

sub set_croak {
   my $self = shift;
   my $turn_on = shift;

   my $res = ${*$self}{_FTPSSL_arguments}->{Croak} || 0;

   if ( defined $turn_on ) {
      if ( $turn_on ) {
         ${*$self}{_FTPSSL_arguments}->{Croak} = 1;
      } elsif ( exists ( ${*$self}{_FTPSSL_arguments}->{Croak} ) ) {
         delete ( ${*$self}{_FTPSSL_arguments}->{Croak} );
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
      $ERRSTR = ${*$self}{_FTPSSL_arguments}->{last_ftp_msg};
      if ( ${*$self}{_FTPSSL_arguments}->{Croak} ) {
         my $c = (caller(1))[3];
         if ( defined $c && $c ne "Net::FTPSSL::login" ) {
            $self->_abort ();
            $self->quit ();
            ${*$self}{_FTPSSL_arguments}->{last_ftp_msg} = $ERRSTR;
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

      _print_LOG ( undef, "<<+ $err ", $ERRSTR, "\n" ) if ( $should_we_print );
      croak ( $ERRSTR . "\n" )   if ( $should_we_die );

   } else {
      # Called this way as a memeber func by everyone else ...
      my $replace_mode = shift;  # 1 - append, 0 - replace,
                                 # undef - leave last_message() unchanged
      my $msg = shift;
      $ERRSTR = $msg || ${*$self}{_FTPSSL_arguments}->{last_ftp_msg};

      # Do 1st so updated if caller trapped the Croak!
      if ( defined $replace_mode && uc ($msg || "") ne ""  ) {
         if ($replace_mode && uc (${*$self}{_FTPSSL_arguments}->{last_ftp_msg} || "") ne "" ) {
            ${*$self}{_FTPSSL_arguments}->{last_ftp_msg} .= "\n" . $err . " " . $msg;
         } else {
            ${*$self}{_FTPSSL_arguments}->{last_ftp_msg} = $err . " " . $msg;
         }
      }

      if ( ${*$self}{_FTPSSL_arguments}->{Croak} ) {
         my $c = (caller(1))[3] || "";

         # Trying to prevent infinite recursion ...
         # Also reseting the PIPE Signal in case catastrophic failure detected!
         if ( ref($self) eq __PACKAGE__ &&
                    (! exists ${*$self}{_FTPSSL_arguments}->{_command_failed_}) &&
                    (! exists ${*$self}{_FTPSSL_arguments}->{recursion}) &&
                    $c ne "Net::FTPSSL::command" &&
                    $c ne "Net::FTPSSL::response" ) {
            ${*$self}{_FTPSSL_arguments}->{recursion} = "TRUE";
            my $tmp = ${*$self}{_FTPSSL_arguments}->{last_ftp_msg};
            local $SIG{PIPE} = "IGNORE";   # Limits scope to just current block!
            $self->_abort ();
            $self->quit ();
            ${*$self}{_FTPSSL_arguments}->{last_ftp_msg} = $tmp;
         }

         # Only do if writing the message to the error log file ...
         if ( defined $replace_mode && uc ($msg || "") ne "" &&
              ${*$self}{_FTPSSL_arguments}->{debug} == 2 ) {
            _print_LOG ( $self, "<<+ $err ", $msg, "\n" );
         }

         croak ( $ERRSTR . "\n" );
      }

      # Handles both cases of writing to STDERR or the error log file ...
      if ( defined $replace_mode && uc ($msg || "") ne "" && ${*$self}{_FTPSSL_arguments}->{debug} ) {
         _print_LOG ( $self, "<<+ $err " . $msg . "\n" );
      }
   }

   return ( undef );
}

#-----------------------------------------------------------------------
# Messages handler
# ----------------------------------------------------------------------
# Called by both Net::FTPSSL and IO::Socket::INET classes.
#-----------------------------------------------------------------------

sub command {
  my $self = shift;  # Remaining arg(s) accessed directly.

  my @args;
  my $data;

  # Remove any previous failure ...
  delete ( ${*$self}{_FTPSSL_arguments}->{_command_failed_} );

  # remove undef values from the list.
  # Maybe I have to find out why those undef were passed.
  @args = grep ( defined($_), @_ );

  $data = join( " ",
                map { /\n/
                      ? do { my $n = $_; $n =~ tr/\n/ /; $n }
                      : $_;
                    } @args
              );

  # Log the command being executed ...
  if ( ${*$self}{_FTPSSL_arguments}->{debug} ) {
     my $prefix = ( ref($self) eq __PACKAGE__ ) ? ">>> " : "SKT >>> ";
     if ( $data =~ m/^PASS\s/ ) {
        _print_LOG ( $self, $prefix, "PASS *******\n" ); # Don't echo passwords
     } elsif ( $data =~ m/^USER\s/ ) {
        _print_LOG ( $self, $prefix, "USER +++++++\n" ); # Don't echo user names
     } else {
        _print_LOG ( $self, $prefix, $data, "\n" );      # Echo everything else
     }
  }

  $data .= "\015\012";

  my $len = length $data;
  my $written = syswrite( $self, $data, $len );
  unless ( defined $written ) {
    ${*$self}{_FTPSSL_arguments}->{_command_failed_} = "ERROR";
    my $err_msg = "Can't write command on socket: $!";
    carp "$err_msg";                    # This prints a warning.
    # Not called as an object member in case $self not a Net::FTPSSL obj.
    _my_close ($self);                  # Old way $self->close();
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
# Hence using func($self, ...) instead of $self->func(...)
# -----------------------------------------------------------------------------
# Returns a single digit response code! (The CMD_* constants!)
# -----------------------------------------------------------------------------
sub response {
  my $self     = shift;
  my $ccc_mess = shift || 0;  # Only set by the CCC command!  Hangs if not used.

  # The buffer size to use during the sysread() call on the command channel.
  my $buffer_size = 4096;

  # Uncomment to experiment with variable buffer sizes.
  # Very usefull in debugging _response_details () & simulating server issues.
  # Supports any value >= 1.
  # $buffer_size = 10;

  # The warning to use when printing past the end of the current response!
  # Used in place of $prefix in certain conditions.
  my $warn = "Warning: Attempted to read past end of response! ";

  # Only continue if the command() call worked!
  # Otherwise on failure this method will hang!
  # We already printed out the failure message in command() if not croaking!
  return (CMD_ERROR)  if ( exists ${*$self}{_FTPSSL_arguments}->{_command_failed_} );

  ${*$self}{_FTPSSL_arguments}->{last_ftp_msg} = "";   # Clear out the message
  my $prefix = ( ref($self) eq __PACKAGE__ ) ? "<<< " : "SKT <<< ";

  my $timeout = ${*$self}{_FTPSSL_arguments}->{Timeout};

  my $sep = ( ${*$self}{_FTPSSL_arguments}->{debug} && ${*$self}{_FTPSSL_arguments}->{debug_extra} ) ? "===============" : undef;

  # Starting a new message ...
  ${*$self}{_FTPSSL_arguments}->{last_ftp_msg} = "";
  my $data = "";
  my ($done, $complete) = (0, 1);

  # Check if we need to process anything read in past the previous command.
  # Hopefully under normal conditions we'll find nothing to process.
  if ( exists ${*$self}{_FTPSSL_arguments}->{next_ftp_msg} ) {
     _print_LOG ( $self, "Info: Response found from previous read ...\n")  if ( ${*$self}{_FTPSSL_arguments}->{debug} );
     $data = ${*$self}{_FTPSSL_arguments}->{next_ftp_msg};
     delete ( ${*$self}{_FTPSSL_arguments}->{next_ftp_msg} );
     ($done, $complete) = _response_details ($self, $prefix, \$data, 0, $ccc_mess);
     if ( $done && $complete ) {
        _print_edited_response ( $self, $prefix, ${*$self}{_FTPSSL_arguments}->{last_ftp_msg}, $sep, 0 );
        _print_edited_response ( $self, $warn, ${*$self}{_FTPSSL_arguments}->{next_ftp_msg}, $sep, 2 );
        return last_status_code ( $self );
     }

     # Should never happen, but using very short timeout on continued commands.
     $timeout = 2;
  }

  # Check if there is data still pending on the command channel ...
  my $rin = "";
  vec ($rin, fileno($self), 1) = 1;
  my $res = select ( $rin, undef, undef, $timeout );
  if ( $res > 0 ) {
     # Now lets read the response from the command channel itself.
     my $cnt = 0;
     while ( sysread( $self, $data, $buffer_size ) ) {
        ($done, $complete) = _response_details ($self, $prefix, \$data, $done, $ccc_mess);
        ++$cnt;
        last  if ($done && $complete);
     }

     # Check for errors ...
     if ( $done && $complete ) {
        # A no-op to protect against random setting of "$!" on no real error!
        my $nothing = "";

     } elsif ( $cnt == 0 || $! ne "" ) {
        if ($cnt > 0) {
          # Will put brackes arround the error reponse!
          _print_edited_response ( $self, $prefix, ${*$self}{_FTPSSL_arguments}->{last_ftp_msg}, $sep, 1 );
          _print_edited_response ( $self, $warn, ${*$self}{_FTPSSL_arguments}->{next_ftp_msg}, $sep, 2 );
        }
        _croak_or_return ($self, 0, "Unexpected EOF on Command Channel [$cnt] ($done, $complete) ($!)");
        return (CMD_ERROR);
     }

  } elsif ( ${*$self}{_FTPSSL_arguments}->{last_ftp_msg} ne "" ) {
     # A Timeout here is OK, it meant the previous command was complete.
     my $nothing = "";

  } else {
     # Will put brackes arround the error reponse!
     _print_edited_response ( $self, $prefix, ${*$self}{_FTPSSL_arguments}->{last_ftp_msg}, $sep, 1 );
     _print_edited_response ( $self, $warn, ${*$self}{_FTPSSL_arguments}->{next_ftp_msg}, $sep, 2 );
     _croak_or_return ($self, 0, "Timed out waiting for a response! [$res] ($!)");
     return (CMD_ERROR);
  }

  # Now print out the final patched together responses ...
  _print_edited_response ( $self, $prefix, ${*$self}{_FTPSSL_arguments}->{last_ftp_msg}, $sep, 0 );
  _print_edited_response ( $self, $warn, ${*$self}{_FTPSSL_arguments}->{next_ftp_msg}, $sep, 2 );

  # Returns the 1st digit of the 3 digit status code!
  return last_status_code ( $self );
}

#-----------------------------------------------------------------------
# Mask sensitive information before it's written to the log file.
# Separated out since done in multiple places.
#-----------------------------------------------------------------------
sub _print_edited_response {
   my $self    = shift;
   my $prefix  = shift;   # "<<< " vs "SKT <<< ".
   my $msg     = shift;   # The response to print.  (may be undef)
   my $sep     = shift;   # An optional separator string.
   my $bracket = shift;   # 0 or 1 or 2.

   # Tells which separator to use to break up lines in $msg!
   my $breakStr = ($bracket == 2) ? "\015\012" : "\n";

   # A safety check to simplify when calling with undefined {next_ftp_msg}.
   unless (defined $msg) {
      return;
   }

   if ( ${*$self}{_FTPSSL_arguments}->{debug} ) {
      # Do we need to hide a value in the logged response ???
      if ( exists ${*$self}{_FTPSSL_arguments}->{_hide_value_in_response_} ) {
         my $val = _mask_regex_chars ($self, ${*$self}{_FTPSSL_arguments}->{_hide_value_in_response_});
         my $mask = ${*$self}{_FTPSSL_arguments}->{_mask_value_in_response_} || "????";
         $msg =~ s/\s${val}($|[\s.!,])/ <$mask>${1}/g;
      }

      if ($bracket) {
         $msg = $prefix . "[" . join ("]\n${prefix}[", split ($breakStr, $msg)) . "]";
      } else {
         $msg = $prefix . join ("\n$prefix", split ($breakStr, $msg));
      }

      if ( defined $sep && $sep !~ m/^\s*$/ ) {
         $msg = "Start: " . $sep . "\n" . $msg . "\nEnd::: " . $sep;
      }
      _print_LOG ( $self, $msg, "\n");
   }

   return;
}

#-----------------------------------------------------------------------
# Broken out from response() in order to simplify the logic.
# The previous version was getting way too convoluted to support.
# Any bugs in this function easily causes things to hang or insert
# random <CR> into the returned messages!
#-----------------------------------------------------------------------
# If you need to turn on the logging for this method use "Debug => 99"
# in the constructor!
#-----------------------------------------------------------------------
# What a line should look like
#    <code>-<desc>   ---  Continuation line(s) [repeateable]
#    <code> <desc>   ---  Response completed line
#    Anything else means it's a Continuation line with embedded <CR>'s.
#    I think its safe to say the response completed line dosn't have
#    any extra <CR>'s embeded in it.  Otherwise it's kind of difficult
#    to know when to stop reading from the socket & risk hangs.
#-----------------------------------------------------------------------
# But what I actually saw in many cases: (list not complete)
#     2
#     13-First Line
#     213
#     -Second Line
#     213-
#     Third Line
#     213-Fourth
#      Line
# Turns out sysread() isn't generous.  It returns as little as possible
# sometimes.  Even when there is plenty of space left in the buffer.
# Hence the strange behaviour above.  But once all the pieces are put
# together properly, you see what you expected in the 1st place.
#-----------------------------------------------------------------------
# Returns if it thinks the current response is done & complete or not.
#    end_respnose   - (passed as "$status" next time called)
#        0 - Response isn't complete yet.
#        1 - Response was done, but may or may not be truncated in <desc>.
#    response_complete - Tells if the final line is complete or truncated.
#        0 - Line was truncated!
#        1 - Last line was complete!
# Both must be true to stop reading from the socket.
# If we've read past the response into the next one, we don't stop
# reading until the overflow response is complete as well.  Otherwise
# the Timeout logic might not work properly later on.
#-----------------------------------------------------------------------
# The data buffer.  I've seen the following:
#    1) A line begining with: \012  (The \015 ended the pevious buffer)
#    2) A line ending with:   \015  (The \012 started the next buffer)
#    3) Lines not ending with: \015\012
#    4) A line only containing: \015\012
#    5) A line only containing: \012
#    6) Lines ending with: \015\012
# If you see the 1st three items, you know there is more to read
# from the socket.  If you see the last 3 items, it's possible
# that the next read from the socket will hang if you've already
# seen the response complete message.  So be careful here!
#-----------------------------------------------------------------------
sub _response_details {
   my $self       = shift;
   my $prefix     = shift;   # "<<< " vs "SKT <<< ".
   my $data_ref   = shift;   # The data buffer to parse ...
   my $status     = shift;   # 0 or 1   (the returned status from previous call)

   my $ccc_kludge = shift;   # Tells us if we are dealing with a corrupted CC
                             # due to the aftermath of a CCC command!
                             # 1st <CR> hit terminates the command in this case!

   # The return values ...
   my ($end_response, $response_complete) = (0, 0);

   # A more restrictive option for turning on logging is needed in this method.
   # Otherwise too much info is written to the logs and it is very confusing.
   #    (Debug => 99 turns this extra logging on!)
   # So only use this special option if we need to debug this one method!
   my $debug = ${*$self}{_FTPSSL_arguments}->{debug} && ${*$self}{_FTPSSL_arguments}->{debug_extra};

   # Assuming that if the line doesn't end in a <CR>, the response is truncated
   # and we'll need the next sysread() to continue with the response.
   # Split drops trailing <CR>, so need this flag to detect this.
   my $end_with_cr = (substr (${$data_ref}, -2) eq "\015\012") ? 1 : 0;

   if ( $debug ) {
      my $type = ( exists ${*$self}{_FTPSSL_arguments}->{next_ftp_msg} ) ? "Overflow" : "Current";
      my $k = $ccc_kludge ? ", Kludge: $ccc_kludge" : "";
      _print_LOG ($self, "In _response_details ($type, Status: $status, len = ", length (${$data_ref}), ", End: ${end_with_cr}${k})\n");
   }

   my ($ref, $splt);
   if ( exists ${*$self}{_FTPSSL_arguments}->{next_ftp_msg} ) {
      $ref = \${*$self}{_FTPSSL_arguments}->{next_ftp_msg};
      $splt = "\015\012";
   } else {
      $ref = \${*$self}{_FTPSSL_arguments}->{last_ftp_msg};
      $splt = "\n";
   }

   # Sysread() does split the \015 & \012 to seperate lines, so test for it!
   # And fix the problem as well if it's found!
   my $index = 0;
   if ( substr (${$data_ref}, 0, 1) eq "\012" ) {
      # It hangs if I strip off from $data_ref, so handle later! (via $index)
      if ( substr (${$ref}, -1) eq "\015" ) {
         substr (${$ref}, -1) = $splt;    # Replace with proper terminator.
         $index = 1;
         _print_LOG ($self, "Fixed 015/012 split!\n")  if ( $debug );
         if ( ${$data_ref} eq "\012" ) {
            return ($status || $ccc_kludge, 1);     # Only thing on the line.
         }
      }
   }

   # Check if the last line from the previous call was trucated ...
   my $trunc = "";
   if ( ${$ref} ne "" && substr (${$ref}, -length($splt)) ne $splt ) {
      $trunc = (split ($splt, ${$ref}))[-1];
   }

   my @term;
   my @data;
   if ( $end_with_cr ) {
      # Protects from split throwing away trailing empty lines ...
      @data = split( "\015\012", substr ( ${$data_ref}, $index ) . "|" );
      pop (@data);
   } else {
      # Last line was truncated ...
      @data = split( "\015\012", substr ( ${$data_ref}, $index ) );
   }

   # Tag which lines are complete! (Only the last one can be truncated)
   foreach (0..$#data) {
      $term[$_] = 1;
   }
   $term[-1] = $end_with_cr;

   # Current command or rolled over to the next command ???
   my (@lines, @next, @line_term, @next_term);
   if ( exists ${*$self}{_FTPSSL_arguments}->{next_ftp_msg} ) {
      @next = @data;
      @next_term = @term;
      @data = @term = @lines;     # All are now empty.
   } else {
      @lines = @data;
      @line_term = @term;
      @data  = @term = @next;     # All are now empty.
   }

   # ------------------------------------------------------------------------
   # Now lets process the response messages we've read in.  See the comments
   # above response() on why this code is such a mess.
   # But it's much cleaner than it used to be.
   # ------------------------------------------------------------------------
   my ( $code, $sep, $desc, $done ) = ( CMD_ERROR, "-", "", 0 );
   my ( $line, $term );

   foreach ( 0..$#lines ) {
      $line = $lines[$_];
      $term = $line_term[$_];

      # If the previous line was the end of the response ...
      # There can be no <CR> in that line!
      # So if true, it means we've read past the end of the response!
      if ( $done ) {
         push (@next, $line);
         push (@next_term, $term);
         next;
      }

      # Always represents the start of a new line ...
      my $test = $trunc . $line;
      $trunc = "";   # No longer possible for previous line to be truncated.

      # Check if this line marks the response complete! (If sep is a space)
      if ( $test =~ m/^(\d{3})([-\s])(.*)$/s ) {
         ($code, $sep, $desc) = ($1, $2, $3);
         $done = ($sep eq " ") ? $term : 0;

         # Update the return status ...
         $end_response = ($sep eq " ") ? 1: 0;
         $response_complete = $term;
      }

      # The CCC command messes up the Command Channel for a while!
      # So we need this work arround to immediately stop processing
      # to avoid breaking the command channel or hanging things.
      if ( $ccc_kludge && $term && ! $done ) {
         _print_LOG ( $self, "Kludge: 1st CCC work around detected ...\n")  if ( $debug );
         $end_response = $response_complete = $done = 1;
      }

      # Save the unedited message ...
      ${*$self}{_FTPSSL_arguments}->{last_ftp_msg} .= $line;

      # Write to the log file if requested ...
      # But due to random splits, it risks not masking properly!
      _print_edited_response ( $self, $prefix, $line, undef, 1 )  if ( $debug );

      # Finish the current line ...
      if ($sep eq "-" && $term) {
         ${*$self}{_FTPSSL_arguments}->{last_ftp_msg} .= "\n";    # Restore the internal <CR>.
      }
   }

   # ------------------------------------------------------------------------
   # Process the response to the next command ... (read in with this one)
   # Shouldn't happen, but it sometimes does ...
   # ------------------------------------------------------------------------
   my $warn = "Warning: Attempting to read past end of response! ";
   my $next_kludge = 0;
   $done = 0;
   foreach ( 0..$#next ) {
      $next_kludge = 1;
      $line = $next[$_];
      $term = $next_term[$_];

      # We've read past the end of the current response into the next one ...
      _print_edited_response ( $self, $warn, $line, undef, 2 )  if ( $debug );

      if ( ! exists ${*$self}{_FTPSSL_arguments}->{next_ftp_msg} ) {
         ${*$self}{_FTPSSL_arguments}->{next_ftp_msg} = $line;
      } elsif ( $trunc ne "" ) {
         ${*$self}{_FTPSSL_arguments}->{next_ftp_msg} .= $line;
      } else {
         ${*$self}{_FTPSSL_arguments}->{next_ftp_msg} .= "\015\012" . $line;
      }

      # Always represents the start of a new line ...
      my $test = $trunc . $line;
      $trunc = "";   # No longer possible for previous line to be truncated.

      # Check if this line marks the response complete! (If sep is a space)
      if ( $test =~ m/^(\d{3})([-\s])(.*)$/s ) {
         ($code, $sep, $desc) = ($1, $2, $3);
         $done = ($sep eq " ") ? $term : 0;

         # Update the return status ...
         $end_response = ($sep eq " ") ? 1: 0;
         $response_complete = $term;
      }
   }

   if ( $end_with_cr && exists ${*$self}{_FTPSSL_arguments}->{next_ftp_msg} ) {
      ${*$self}{_FTPSSL_arguments}->{next_ftp_msg} .= "\015\012";
   }

   # Complete the Kludge! (Only needed if entered the @next loop!)
   if ( $ccc_kludge && $next_kludge && ! ($end_response && $response_complete) ) {
      _print_LOG ( $self, "Kludge: 2nd CCC work around detected ...\n")  if ( $debug );
      $end_response = $response_complete = 1;
   }

   return ($end_response, $response_complete);
}

#-----------------------------------------------------------------------

sub last_message {
   my $self = shift;
   return ${*$self}{_FTPSSL_arguments}->{last_ftp_msg};
}

#-----------------------------------------------------------------------
# This method sets up a trap so that warnings can be written to my logs.
# Always call like:  $ftps->trapWarn().
#-----------------------------------------------------------------------
sub trapWarn {
   my $self  = shift;
   my $force = shift || 0;   # Only used by some of the t/*.t test cases!
                             # Do not use the $force parameter otherwise!
                             # You've been warned!

   my $res = 0;    # Warnings are not yet trapped ...

   # Only trap warnings if a debug log is turned on to write to ...
   if ( defined $self && ${*$self}{_FTPSSL_arguments}->{debug} &&
        ($force || exists ${*$self}{_FTPSSL_arguments}->{ftpssl_filehandle}) ) {
      my $tmp = $SIG{__WARN__};

      # Must do as an inline function call so things will go to
      # the proper log file.
      my $func_ref = sub { $self->_print_LOG ("WARNING: ", $_[0]); };

      $warn_list{$self} = $func_ref;

      # This test prevents a recursive trap ...
      if (! exists $warn_list{OTHER}) {
         $warn_list{OTHER} = $tmp;
         $SIG{__WARN__} = __PACKAGE__ . "::_handleWarn";
      }

      $res = 1;     # The warnings are trapped now ...
   }

   return ($res);   # Whether trapped or not!
}

# Warning, this method cannot be called as a member function.
# So it will never reference $self!  It's also not documented in the POD!
# See trapWarn() instead!
sub _handleWarn {
   my $warn = shift;   # The warning being processed ...

   # Print warning to each of the registered log files.
   # Will always be a reference to the function to call!
   my $func_ref;
   foreach ( keys %warn_list ) {
      next   if ($_ eq "OTHER");
      $func_ref = $warn_list{$_};
      $func_ref->( $warn );    # Prints to an open Net::FTPSSL log file ...
   }

   # Was there any parent we replaced to chain the warning to?
   if (exists $warn_list{OTHER} && defined $warn_list{OTHER}) {
      $func_ref = $warn_list{OTHER};
      if (ref ($func_ref) eq "CODE") {
         $func_ref->( $warn );
      } elsif ( $func_ref eq "" || $func_ref eq "DEFAULT" ) {
         print STDERR "$warn\n";
      } elsif ( $func_ref ne "IGNORE" ) {
         &{\&{$func_ref}}($warn);   # Will throw exception if doesn't exist!
      }
   }
}

# Called automatically when an instance of Net::FTPSSL goes out of scope!
# Only called if new() was successfull!  Used so we could remove all this
# termination logic from quit()!
sub DESTROY {
   my $self = shift;

   if ( ${*$self}{_FTPSSL_arguments}->{debug} ) {
      # Disable optional trapping of the warnings written to the log file
      # now that we're going out of scope!
      if ( exists $warn_list{$self} ) {
         delete ($warn_list{$self});
      }

      # Now let's close the log file itself ...
      $self->_close_LOG ();

      # Comment out this Debug Statement when no longer needed!
      # print STDERR "Good Bye FTPSSL instance! (", ref($self), ")  [$self]\n";
   }
}

# Called automatically when this module is removed from memory.
# NOTE: Due to how Perl's garbage collector works, in many cases END may be
#       called before DESTROY is called!  Not what you'd expect!
sub END {
   # Restore to original setting when the module gets unloaded from memory!
   # If this entry wasn't created, then we never redirected any warnings!
   if ( exists $warn_list{OTHER} ) {
      $SIG{__WARN__} = $warn_list{OTHER};
      delete ( $warn_list{OTHER} );
      # print STDERR "Good Bye FTPSSL! (", $SIG{__WARN__}, ")\n";
   }
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
   return ${*$self}{_FTPSSL_arguments}->{last_ftp_msg};
}

sub last_status_code {
   my $self = shift;

   my $code = CMD_ERROR;
   if ( defined ${*$self}{_FTPSSL_arguments}->{last_ftp_msg} ) {
      $code = substr (${*$self}{_FTPSSL_arguments}->{last_ftp_msg}, 0, 1);
   }

   return ($code);
}

sub _change_status_code {
   my $self = shift;
   my $code = shift;   # Should be a single digit.  Strange behaviour otherwise!

   if ( defined ${*$self}{_FTPSSL_arguments}->{last_ftp_msg} ) {
      substr (${*$self}{_FTPSSL_arguments}->{last_ftp_msg}, 0, 1) = $code;
   }

   return;
}

sub restart {
   my $self = shift;
   my $offset = shift;
   ${*$self}{_FTPSSL_arguments}->{net_ftpssl_rest_offset} = $offset;
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
      ${*$self}{_FTPSSL_arguments}->{callback_func}     = $func_ref;
      ${*$self}{_FTPSSL_arguments}->{callback_end_func} = $end_func_ref;
      ${*$self}{_FTPSSL_arguments}->{callback_data}     = $cb_work_area_ref;
   } else {
      delete ( ${*$self}{_FTPSSL_arguments}->{callback_func} );
      delete ( ${*$self}{_FTPSSL_arguments}->{callback_end_func} );
      delete ( ${*$self}{_FTPSSL_arguments}->{callback_data} );
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
   if ( defined ${*$self}{_FTPSSL_arguments}->{callback_end_func} ) {
      $res = &{${*$self}{_FTPSSL_arguments}->{callback_end_func}} ( (caller($offset))[3], $total,
                                               ${*$self}{_FTPSSL_arguments}->{callback_data} );

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
   my $self   = shift;
   my $offset = shift;   # Always >= 1.  Index to original function called.
   my $data_ref     = shift;
   my $data_len_ref = shift;
   my $total_len    = shift;

   my $cb_flag = 0;

   # Is there is a callback function to use ?
   if ( defined ${*$self}{_FTPSSL_arguments}->{callback_func} ) {

      # Allowed to modify contents of $data_ref & $data_len_ref ...
      &{${*$self}{_FTPSSL_arguments}->{callback_func}} ( (caller($offset))[3],
                                    $data_ref, $data_len_ref, $total_len,
                                    ${*$self}{_FTPSSL_arguments}->{callback_data} );
      $cb_flag = 1;
   }

   # Calculate the new total length to use for next time ...
   $total_len += (defined $data_len_ref ? ${$data_len_ref} : 0);

   if ( wantarray ) {
      return ($total_len, $cb_flag);
   }
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
# To assist in debugging the flags being used by this module ...
#-----------------------------------------------------------------------

sub _debug_print_hash
{
   my $self = shift;
   my $host = shift;
   my $port = shift;
   my $mode = shift;
   my $obj  = shift || $self;   # So can log most GLOB object types ...
   my $sep  = shift;            # The optional separator char to print out.

   _print_LOG ( $self, "\nObject ", ref($obj), " Details ..." );
   _print_LOG ( $self, " ($host:$port - $mode)" )  if (defined $host);
   _print_LOG ( $self, "\n" );

   # Fix to support non-GLOB object types ...
   my @lst;
   my $hash = 0;
   if ( ref ($obj) eq "HASH" ) {
      @lst = sort keys %{$obj};
      $hash = 1;
   } else {
      # It's a GLOB reference ...
      @lst = sort keys %{*$obj};
   }

   # The separators to use ...
   my @seps = ( "==>", "===>",
                "---->",   "++++>",   "====>",
                "----->",  "+++++>",  "=====>",
                "------>", "++++++>", "======>" );

   # To help detect infinite recursive loops ...
   my %loop;
   my %empty;

   foreach (@lst) {
      unless ( defined $host ) {
         next   unless ( m/^(io_|_SSL|SSL)/ );
      }
      my $val = ($hash) ? $obj->{$_} : ${*$obj}{$_};

      %loop = %empty;     # Empty out the hash again ...
      _print_hash_tree ( $self, "  ", 0, $_, $val, \@seps, \%loop );
   }

   if (defined $sep && $sep !~ m/^\s*$/) {
      _print_LOG ( $self, $sep x 60, "\n");
   } else {
      _print_LOG ( $self, "\n" );
   }

   return;
}

# Recursive so can handle unlimited depth of hash trees ...
sub _print_hash_tree
{
   my $self     = shift;
   my $indent   = shift;
   my $lvl      = shift;   # Index to the $sep_ref array reference.
   my $lbl      = shift;
   my $val      = shift;
   my $sep_ref  = shift;   # An array reference.
   my $loop_ref = shift;   # A hash ref to detect infinit recursion with.

   my $prefix = ($lvl == 0) ? "" : "-- ";
   my $sep = (defined $sep_ref->[$lvl]) ? $sep_ref->[$lvl] : ".....>";

   # Make sure it always has a value ...
   $val = "(undef)"  unless (defined $val);

   # Fix indentation in case "\n" appears in the value ...
   $val = join ("\n${indent}  ", split (/\n/, $val)) unless (ref($val));

   # Fix in case it's a scalar reference ...
   $val .= "  [" . ${$val} . "]"  if ($val =~ m/SCALAR\(0/);

   my $msg = "${indent}${prefix}${lbl} ${sep} ${val}";

   # How deep to indent for the next level ... (add 4 spaces)
   $indent .= "    ";

   if ( $val =~ m/ARRAY\(0/ ) {
      my $lst = join (", ", @{$val});
      _print_LOG ( $self, $msg, "\n" );
      _print_LOG ( $self, "${indent}[", $lst, "]\n" );

   } elsif ( $val =~ m/HASH\((0x[\da-zA-Z]+)\)/ ) {
      my $key = $1;         # The Hash address ...
      my %start = %{$loop_ref};

      _print_LOG ( $self, $msg );
      if ( exists $loop_ref->{$key} ) {
         _print_LOG ($self, " ... Infinite Hash Loop Detected!\n");
      } else {
         $start{$key} = $loop_ref->{$key} = $val;
         _print_LOG ( $self, "\n" );
         foreach (sort keys %{$val}) {
            %{$loop_ref} = %start;
            _print_hash_tree ( $self, $indent, $lvl + 1, $_, $val->{$_},
                                      $sep_ref, $loop_ref );
         }
      }

   # Else not an ARRAY or HASH ...
   } else {
      _print_LOG ( $self, $msg, "\n" );
   }
}

#-----------------------------------------------------------------------
# Provided so each class instance gets its own log file to write to.
#-----------------------------------------------------------------------
# Always writes to the log when called ...
sub _print_LOG
{
   my $self = shift;
   my $msg = shift;

   my $FILE;

   # Determine where to write the log message to ...
   if ( defined $self && exists ${*$self}{_FTPSSL_arguments}->{ftpssl_filehandle} ) {
      $FILE = ${*$self}{_FTPSSL_arguments}->{ftpssl_filehandle};     # A custom log file ...
   } elsif ( defined $FTPS_ERROR ) {
      $FILE = $FTPS_ERROR;       # Write to file when called during new() ...
   } else {
      $FILE = \*STDERR;          # Write to screen anyone ?
   }

   while ( defined $msg ) {
      print $FILE $msg;          # Write to the log file ...
      $msg = shift;
   }
}

# Only write to the log if debug is turned on ...
# So we don't have to test everywhere ...
# Done this way so can be called in new() on a socket as well.
sub _print_DBG
{
   my $self = shift;
   if ( defined $self && ${*$self}{_FTPSSL_arguments}->{debug} ) {
      _print_LOG ( $self, @_ );   # Only if debug is turned on ...
   }
}

sub get_log_filehandle
{
   my $self = shift;

   my $FILE;
   if ( defined $self && exists ${*$self}{_FTPSSL_arguments}->{ftpssl_filehandle} ) {
      $FILE = ${*$self}{_FTPSSL_arguments}->{ftpssl_filehandle};
   }

   return ($FILE);
}

sub _close_LOG
{
  my $self = shift; 

  if ( defined $self && exists ${*$self}{_FTPSSL_arguments}->{ftpssl_filehandle} ) {
     my $FILE = ${*$self}{_FTPSSL_arguments}->{ftpssl_filehandle};
     close ($FILE)   if ( ${*$self}{_FTPSSL_arguments}->{debug} == 2 );
     delete ( ${*$self}{_FTPSSL_arguments}->{ftpssl_filehandle} );
     ${*$self}{_FTPSSL_arguments}->{debug} = 1;     # Back to using STDERR again ...
  }
}

# A helper method to tell if it can be counted as a GLOB ...
sub _isa_glob
{
   my $self = shift;
   my $fh   = shift;

   my $res = 0;    # Assume not a file handle/GLOB ...

   if ( defined $fh ) {
      my $tmp = ref ( $fh );
      if ( $tmp ) {
         $res = 1   if ( $tmp eq "GLOB" || $fh->isa ("IO::Handle") );
      }
   }

   return ( $res );
}

#-----------------------------------------------------------------------
# If the Domain/Family is passed as a string, this function will convert
# it into the needed numerical value.  [Only called by new().]
sub _validate_domain {
   my $type   = shift;   # It's a string, not an Net::FTPSSL object!
   my $family = shift;   # The tag used for this value.
   my $domain = shift;   # Should never be undef when called.
   my $debug  = shift;
   my $die    = shift;

   my $ret;

   if ( $domain =~ m/^\d+$/ ) {
      $ret = $domain;        # Already a numeric value, so just return it ...

   # Valid domains are inherited functions named after the value!
   } elsif ( $domain =~ m/^AF_/i ) {
      if ( $type->can ( uc ($domain) ) ) {
         my $func = $type . "::" . uc ($domain) . "()";
         $ret = eval $func;    # Call the function to convert it to an integer!
      }
   }

   unless ( defined $ret ) {
      _croak_or_return ( undef, $die, $debug,
                         "Unknown value \"${domain}\" for option ${family}." );
   }

   # Return the domain/family as a numeric value.
   # Can be undef if invalid & Croak is turned off.
   return ( $ret );
}


#-----------------------------------------------------------------------

1;

__END__

=head1 NAME

Net::FTPSSL - A FTP over TLS/SSL class

=head1 VERSION 0.42

Z<>

=head1 SYNOPSIS

  use Net::FTPSSL;

  my $ftps = Net::FTPSSL->new('ftp.your-secure-server.com', 
                              Encryption => EXP_CRYPT,
                              Debug => 1, DebugLogFile => "myLog.txt",
                              Croak => 1);

  $ftps->trapWarn ();     # Only call if opening a CPAN bug report.

  $ftps->login('anonymous', 'user@localhost');

  $ftps->cwd("/pub");

  $ftps->get("file");

  $ftps->quit();

Since I included I<Croak =E<gt> 1> as an option to I<new>, it automatically
called I<die> for me if any I<Net::FTPSSL> command failed.  So there was no need
for any messy error checking in my code example!

=head1 DESCRIPTION

C<Net::FTPSSL> is a class implementing a simple FTP client over a Transport
Layer Security (B<TLS>) or Secure Sockets Layer (B<SSL>) connection written in
Perl as described in RFC959 and RFC2228.  It will use TLS v1.2 by default,
since TLS is more secure than SSL.  But if you wish to downgrade you may use
B<SSL_version> to do so.

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

B<ProxyArgs> - A hash reference to pass to the proxy server.  When a proxy
server is encountered, this class uses I<Net::HTTPTunnel> to get through to
the server you need to talk to.  See I<Net::HTTPTunnel> for what values are
supported.  Options I<remote-host> and I<remote-port> are hard coded to the
same values as provided by I<HOST> and I<PORT> above and cannot be overridden.

B<PreserveTimestamp> - During all I<puts> and I<gets>, attempt to preserve the
file's timestamp.  By default it will not preserve the timestamps.

Set to a value B<E<gt>> zero if the I<MDTM> & I<MFMT> commands properly use GMT.
Set to a value B<E<lt>> zero if the server incorrectly uses it's local time zone
instead.  Using the wrong value can result in really wacky modify times on your
files if you choose the wrong one for your server.  F<t/10-complex.t> does
include a test to try to guess which one the server uses.

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
new log file.  This log file is closed when this class instance goes out of
scope.

Instead of a file name, you may instead specify an open file handle or GLOB and
it will write the logs there insead.  (I<Not really recommended.>)

B<Croak> - Force most methods to call I<croak()> on failure instead of returning
I<FALSE>.  The default is to return I<FALSE> or I<undef> on failure.  When it
croaks, it will attempt to close the FTPS connection as well, preserving the
last message before it attempts to close the connection.  Allowing the server
to know the client is going away.  This will cause I<$Net::FTPSSL::ERRSTR> to
be set as well.

B<ReuseSession> - Tells the B<FTP/S> server that we wish to reuse the I<command
channel> session for all I<data channel> connections.  (0/1/2/etc.)  It defaults
to B<0>, no reuse.

When requested, it will use a default I<session cache size> of B<5>, but you
can increase the cache's size by setting the I<ReuseSession> to a larger value.
Where the I<session cache size> is (4 + the I<ReuseSession> value).

B<DisableContext> - Tells the B<FTP/S> server that we don't wish to reuse the
I<command channel> context for all I<data channel> connections.  (0/1)  If
option I<ReuseSession> or I<SSL_Client_Certificate> are also used, this option
is ignored!  By default the context is always reused on encrypted data channels
via B<SSL_reuse_ctx>.

B<SSL_*> - SSL arguments which can be applied when I<start_SSL()> is finally
called to encrypt the command channel.  See I<IO::Socket::SSL> for a list of
valid arguments.

This is an alternative to using the I<SSL_Client_Certificate> option.  But
any B<SSL_*> options provided here overrides what's provided in that hash.

B<SSL_Client_Certificate> - Expects a reference to a hash.  It's main purpose
is to allow you to use client certificates when talking to your I<FTP/S> server.
Options here apply to the creation of the command channel.  And when a data
channel is needed later, it uses the B<SSL_reuse_ctx> option to reuse the
command channel's context.

See I<start_SSL()> in I<IO::Socket::SSL> for more details on this and other
options available besides those for certificates.  If an option provided via
this hash conflicts with other options we would normally use, the entries in
this hash take precedence, except for any direct B<SSL_*> options provided in
both places.

B<Domain> - Specify the domain to use, i.e. I<AF_INET> or I<AF_INET6>.  This
argument will be passed to the I<IO::Socket::*> class when creating the socket
connection.  It's a way to enforce using I<IPv4> vs I<IPv6> even when it would
default to the other.  B<Family> is an accepted alias for the B<Domain> tag if
you prefer it.

B<Buffer> - This is the block size that I<Net::FTPSSL> will use when a transfer
is made over the I<Data Channel>. Default value is 10240.  It does not affect
the I<Command Channel>.

B<Timeout> - Set a connection timeout value. Default value is 120.

B<xWait> - Used with I<xput> & I<xtransfer>.  Tells how long to wait after the
upload has completed before renaming the file.  The default is no wait, but
if you specify a number here, it will wait that number of seconds before
issuing the rename command.  Some servers force you to wait a bit before it
will honor the I<RNTO> part of the rename command.

B<LocalAddr> - Local address to use for all socket connections, this argument
will be passed to all L<IO::Socket::INET> calls.

B<OverridePASV> - Some I<FTPS> servers sitting behind a firewall incorrectly
return their local IP Address instead of their external IP Address used
outside the firewall where the client is.  To use this option to correct this
problem, you must specify the correct host to use for the I<data channel>
connection.  This should usually match what you provided as the host!  But if
this server also does load balancing, you are out of luck.  This option may not
be able to help you if multiple IP Addresses can be returned.

B<OverrideHELP> - Some I<FTPS> servers on encrypted connections incorrectly send
back part of the response to the B<HELP> command in clear text instead of it all
being encrypted, breaking the command channel connection.  This module calls
B<HELP> internally via I<supported()> for some conditional logic, making a work
around necessary to be able to talk to such servers.

This option supports B<four> distinct modes to support your needs.  You can pass
a reference to an array that lists all the B<FTP> commands your sever supports,
you can set it to B<1> to say all commands are supported, set it to B<0> to say
none of the commands are supported, or finally set it to B<-1> to call B<FEAT>
instead of B<HELP> for the list of supported commands.  See I<supported()> or
I<fix_supported()> for more details.

This option can also be usefull when your server doesn't support the I<HELP>
command itself and you need to trigger some of the conditional logic.

B<useSSL> - This option is being depreciated in favor of L<IO::Socket::SSL>'s
B<SSL_version> option.  It's just a quick and dirty way to downgrade your
connection from B<TLS> to B<SSL> which is no longer recommended.

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

This method breaks the connection to the FTPS server.

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

This method returns a list of files in a format similar to this: (Server
Specific)

 drwxrwx--- 1 owner group          512 May 31 11:16 .
 drwxrwx--- 1 owner group          512 May 31 11:16 ..
 -rwxrwx--- 1 owner group          512 Oct 27  2004 foo
 -rwxrwx--- 1 owner group          512 Oct 27  2004 pub
 drwxrwx--- 1 owner group          512 Mar 29 12:09 bar

If I<DIRECTORY> is omitted, the method will return the list of the current
directory.

If I<PATTERN> is provided, it would limit the result similar to the unix I<ls>
command or the Windows I<dir> command.  The only wild cards supported are
B<*> and B<?>.  (Match 0 or more chars.  Or any one char.) So a pattern of
I<f*>, I<?Oo> or I<FOO> would find just I<foo> from the list above.  Files with
spaces in their name can cause strange results when searching with a pattern.

=item nlst( [DIRECTORY [, PATTERN]] )

Same as C<list> but returns the list in this format:

 foo
 pub
 bar

Spaces in the filename do not cause problems with the I<PATTERN> with C<nlst>.
Personally, I suggest using nlst instead of list.

=item mlsd( [DIRECTORY [, PATTERN [, FTYPE]]] )

Returns a list of files/directories in a standardized machine readable format
designed for easy parsing.  Where the list of features about each file/directory
is defined by your FTPS server and may be modifiable by you.

 modify=20041027194930;type=file;size=28194; foo
 modify=20041027194932;type=file;size=3201931; pub
 modify=20180329120944;type=dir;size=256; bar

Spaces in the filename do not cause problems with the I<PATTERN> with C<mlsd>.

If I<FTYPE> is provided, it does additional filtering based on type of file.
If the I<type> attribute isn't returned, and I<FTYPE> is non-zero, it will
filter out everything!
  0 - All file types. (default)
  1 - Regular Directories only.
  2 - Regular Files only.
  3 - Special Files only.
  4 - Special Directories only.

=item mlst( FILE )

Requests the FTPS server return the feature set for the requested I<FILE>.
Where I<FILE> may be any type of file or directory exactly matching the given
name.

If the requested file/directory doesn't exist it will return B<undef> or croak.
If it exists it will return the features about the file the same way I<mlsd>
does, but the returned filename may contain path info.  Where I<dir> is the
current directory name.

For example if we were looking for file B<pub> again:
  modify=20041027194932;type=file;size=3201931; /dir/pub

=item parse_mlsx( VALUE [, LOWER_CASE_FLAG] )

Takes the I<VALUE> returned by I<mlst> or one of the array values from I<mlsd>
and converts it into a hash.  Where key "B<;file;>" is the filename and anything
else was a feature describing the file.

It returns a hash reference containing the data.  If the I<LINE> isn't in the
proper format, it returns B<undef>.  The only key that's guarenteed to exist
in the hash after a successsful parse is "B<;file;>".  All other keys/features
returned are based on how your FTPS server has been configured.

For example:
  Type=File;Size=3201931; Pub
  would return (Type=>File, Size=>3201931, ;file;=>Pub)

But if I<LOWER_CASE_FLAG> was set to a non-zero value, it would then convert
everything B<I<except>> the file's name into lower case.
  Type=File;Size=3201931; Pub
  would return (type=>file, size=>3201931, ;file;=>Pub)

=item ascii()

Sets the file transfer mode to ASCII.  I<CR LF> transformations will be done.
ASCII is the default transfer mode.

=item binary()

Sets the file transfer mode to binary. No I<CR LF> transformation will be done.

=item mixedModeAI()

Mixture of ASCII & binary mode.  The server does I<CR LF> transformations while
the client side does not.  (For a really weird server)

=item mixedModeIA()

Mixture of binary & ASCII mode.  The client does I<CR LF> transformations while
the server side does not.  (For a really weird server)

=item put( LOCAL_FILE [, REMOTE_FILE [, OFFSET]] )

Stores the I<LOCAL_FILE> onto the remote ftps server. I<LOCAL_FILE> may be a
open I<IO::Handle> or GLOB, but in this case I<REMOTE_FILE> is required.
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
appending to the end of I<REMOTE_FILE>.  (I<This may not be consistent across
all FTPS Servers, so don't depend on this feature without testing it first.>)

If the option I<PreserveTimestamp> was used, and the FTPS server supports it,
it will attempt to reset the timestamp on I<REMOTE_FILE> to the timestamp on
I<LOCAL_FILE>.

=item append( LOCAL_FILE [, REMOTE_FILE [, OFFSET]] )

Appends the I<LOCAL_FILE> onto the I<REMOTE_FILE> on the ftps server.  If
I<REMOTE_FILE> doesn't exist, the file will be created.  I<LOCAL_FILE> may be
a open I<IO::Handle> or GLOB, but in this case I<REMOTE_FILE> is required and
I<OFFSET> is ignored.  It returns B<undef> if I<append()> fails.

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

Stores the I<LOCAL_FILE> onto the remote FTPS server. I<LOCAL_FILE> may be an
open I<IO::Handle> or GLOB, but in this case I<REMOTE_FILE> is required.  Do
not put any path info in I<REMOTE_FILE>!  Its default is I<LOCAL_FILE>.

This command can be implemented differently on different FTPS servers.  On some
servers it ignores I<REMOTE_FILE> and just assigns it a unique name.  On other
servers it uses I<REMOTE_FILE> as a starting point.  In either case sometimes
it returns the final file name used and on other servers it keeps it a secret.

So if your FTPS server honors the I<REMOTE_FILE> it may use that name on the
upload if it doesn't already exist.  But if it already exists, then it will
generate a unique name instead.

If the file transfer succeeds, this function will try to return the actual
name used on the remote FTPS server.  If the server accepts the I<REMOTE_FILE>
hint and doesn't return the filename, it will assume I<REMOTE_FILE>.  If it
doesn't accept I<REMOTE_FILE> and doesn't return the name used, we'll return a
single 'B<?>' instead.  In this case the request worked, but this command has no
way to figure out what name was generated on the remote FTPS server and we know
I<REMOTE_FILE> is wrong!  So we want to return a printable value that will
evaluate to B<true> for success but still tell you the actual name used is
unknown!

Just be aware that spaces in the filename used on the FTPS server could mean an
incomplete filename is returned by this method.

If the option I<PreserveTimestamp> was used, and the FTPS server supports it,
it will attempt to reset the timestamp on the remote file using the file name
being returned by this function to the timestamp on I<LOCAL_FILE>.  So if the
wrong name is being returned, the wrong file could get its timestamp updated.

=item uput2( LOCAL_FILE, [REMOTE_FILE] )

A much, much slower version of I<uput>.  Only useful when regular I<uput> can't
determine the actual filename used for the upload to your FTPS server or it
returns the wrong answer for that server.  And you really, really need the
right filename!

It gets the right answer by calling I<nlst>, I<uput>, and then I<nlst> again.
And as long as there is only one new file returned in the 2nd I<nlst> call, we
have the actual filename used on the FTPS server.  So having spaces in this
filename causes no issues.

This function assumes you are uploading to the FTPS server's current directory.
Since the I<uput> command doesn't always honor I<REMOTE_FILE> on all servers.

It returns B<undef> if the upload fails.  It retuns 'B<?>' if it still can't
figure out what the FTPS server called the file after the upload (very rare and
unusual).  Otherwise it's the name of the file on the FTPS server.

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
filename or a open I<IO::Handle> or GLOB.  It returns B<undef> if I<get()>
fails.  You don't usually need to use I<OFFSET>.

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

Just be aware that in this case B<LOCAL_FILE> can no longer be a open
I<IO::Handle> or glob.

=item transfer( dest_server, REMOTE_FILE [, DEST_FILE [, OFFSET]] )

Retrieves the I<REMOTE_FILE> from the current ftps server and uploads it to
the I<dest_server> as I<DEST_FILE> without making any copy of the file on your
local file system.  If I<DEST_FILE> isn't provided, it uses I<REMOTE_FILE>
on the I<dest_server>.

It assumes that I<dest_server> is an F<Net::FTPSSL> object and you have
already successfully logged onto I<dest_server> and set both ends to either
binary or ascii mode!  So this function skips over the CR/LF logic and lets
the other servers handle it.  You must also set the I<Croak> option to the
same value on both ends.

Finally, if logging is turned on, the logs to this function will be split
between the logs on each system.  So the logs may be a bit of a pain to follow
since you'd need to look in two places for each half.

=item xtransfer( dest_server, REMOTE_FILE, [DEST_FILE, [PREFIX,

[POSTFIX, [BODY]]]] )

Same as I<transfer>, but it uses a temporary filename on the I<dest_server>
during the transfer.  And then renames it to I<DEST_FILE> afterwards.

See I<xput> for the meaning of the remaining parameters.

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

=item mfmt( time_str, remote_file ) or _mfmt( timestamp, remote_file [, local_flag] )

Both are boolean functions that attempt to reset the remote file's timestamp on
the FTPS server and returns true on success.  The 1st version can call croak on
failure if I<Croak> is turned on, while the 2nd version will not do this.  The
other difference between these two functions is the format of the file's
timestamp to use.

I<time_str> expects the timestamp to be GMT time in format I<YYYYMMDDHHMMSS>.
While I<timestamp> expects to be in the same format as returned by
I<localtime()> and converts it to the I<YYYYMMDDHHMMSS> format for you in GMT
time.

But some servers incorectly use local time instead of GMT.  So the I<local_flag>
option was added to tell it to use local time instead of GMT time when
converting the timestamp into a string.  When used internally by this module,
this functionality is controlled by I<PreserveTimestamp> instead.

=item mdtm( remote_file )  or  _mdtm( remote_file [, local_flag] )

The 1st version returns the file's timestamp as a string in I<YYYYMMDDHHMMSS>
format using GMT time, it will return I<undef> or call croak on failure.
(Some servers incorrectly use local time instead.)

The 2nd version returns the file's timestamp in the same format as returned by
I<gmtime()> and will never call croak.  But some servers incorectly use local
time instead of GMT.  So the I<local_flag> option was added to tell it to use
local time instead of GMT time for this conversion.  When used internally by
this module, this functionality is controlled by I<PreserveTimestamp> instead.

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

Finally if the file isn't a regular file, it may in some cases return I<undef>.
Depending on which FTP command was available to calculate the file's size with.

=item dir( [DIRECTORY [, PATTERN]] )

This is an alias to B<list>.  Returns an array of filenames in the long detailed
format.

=item ls( [DIRECTORY [, PATTERN]] )

This is an alias to B<nlst>.  Returns an array of filenames in name only format.

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
data channel protection level cannot be changed again and will always remain
at this setting.  Once you execute the B<CCC> request, you will have to create
a new I<Net::FTPSSL> object to secure the command channel again.  I<Due
to security concerns it is recommended that you do not use this method.>

=item supported( CMD [, SUB_CMD] )

Returns B<TRUE> if the remote server supports the given command.  I<CMD> must
match exactly.  This function will ignore the B<Croak> request.

If the I<CMD> is SITE, FEAT or OPTS and I<SUB_CMD> is supplied, it will also
check if the specified I<SUB_CMD> sub-command is supported by that command.
Not all servers will support the use of I<SUB_CMD>.

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

This command assumes that the B<FTP/S> server is configured correctly.  But
I've run into some servers where B<HELP> says a command is present when it's
really unknown.  So I'm assuming the reverse may be true sometimes as well.
So when you hit this issue, use I<OverrideHELP> or I<fix_supported> to work
arround this problem.

This method is used internally for conditional logic such as when checking if
I<ALLO> is supported during any file upload requests.  In all there are about
a dozen different commands checked internally in various situations.

=item all_supported( CMD1 [, CMD2 [, CMD3 [, CMD4 [, ...]]]] )

Similar to I<supported>, except that it tests everything in this list of one or
more I<FTP> commands passed to it to see if they are supported.  If the list is
empty, or if even one command in the list isn't supported, it returns B<FALSE>.
Otherwise it returns B<TRUE>.  It will also ignore the B<Croak> request.

=item fix_supported( MODE, CMD1 [, CMD2 [, CMD3 [, CMD4 [, ...]]]] )

Sometimes the FTPS server lies to us about what commands are supported.  This
function provides a way to give the I<supported> command updates.  This method
is a NOOP if I<OverrideHELP =E<gt> 1> was used.  Any other I<OverrideHELP>
option will cause B<HELP> to be ignored if it's one of the commands.

If B<MODE> is true, it adds these commands to the list of supported commands.

If B<MODE> is false, it removes these commands as being supported.

Returns the number of FTP commands added/removed from support!

=item feat()

Asks the server for a list of features supported by this server.  It returns the
list of commands as keys to a hash reference whose value (behavior) is usually
the empty string.  But if a command returns more details about the command, the
command's value in the hash will be those details (aka behavior).
S<Ex: B<MLST> I<size*;create;modify*;perm;media-type>,> where B<MLST> would be
the hash key & the rest of the line describes that command's behavior.

While the B<OPTS> command is never returned by a I<FEAT> call to the server, it
will be automtically added to this hash if any command listed has a behavior
string after it.  Since B<OPTS> only has meaning if at least one command has
a behavior string defined.  And many servers only implement the B<OPTS> command
if there is a behavior that can be modified.  So in this case B<OPTS> will
point to a hash of commands the B<OPTS> command can modify!

So if the B<OPTS> command appears in the hash, then each call to F<feat> will
result in a server hit.  Otherwise the result is cached.  This is because
calls to B<OPTS> could modify the behaviour of B<FEAT>.

If I<OverrideHELP> was used, B<HELP> will be removed from the B<FEAT> hash
returned since you stated this server doesn't support the B<HELP> command.

Should the I<FEAT> command fail for any reason, the returned hash reference
will be empty or B<Croak> will be called.

=item restart( OFFSET )

Set the byte offset at which to begin the next data transfer.  I<Net::FTPSSL>
simply records this value and uses it during the next data transfer.  For
this reason this method will never return an error, but setting it may cause
subsequent data transfers to fail.

I recommend using the OFFSET directly in I<get()>, I<put()>, I<append()> and
I<transfer()> instead of using this method.  It was only added to make
I<Net::FTPSSL> compatible with I<Net::FTP>.  A non-zero offset in those methods
will override what you provide here.  If you call any of the other
I<get()>/I<put()> variants after calling this function, you will get an error.

It is OK to use an I<OFFSET> of B<-1> here to have I<Net::FTPSSL> calculate
the correct I<OFFSET> for you before it get's used.  Just like if you had
provided it directly to the I<get()>, I<put()>, I<append()> and I<transfer()>
calls.

This I<OFFSET> will be automatically zeroed out after the 1st time it is used.

=item is_file( FILE )

Returns true if the passed I<FILE> name is recognized as a regular file on the
remote FTPS server.  Otherwise it returns false.

If the I<MLST> command is supported with the B<TYPE> feature turned on we
can get a definitive answer.  Otherwise it's assumed a regular file if the
I<size> function works! (I<IE. returns a size E<gt>= 0 Bytes>.)

=item is_dir( DIRECTORY )

Returns true if the passed I<DIRECTORY> name is recognized as a directory on
the remote FTPS server.  It returns false if it can't prove it or it's not a
directory.

If the I<MLST> command is supported with the B<TYPE> feature turned on we
can get a definitive answer.  Otherwise it's assumed a directory if you can
I<cwd> into it.

But if it's using this backup method and your login doesn't have permission
to I<cwd> into that directory, this function B<will not> recognize it as a
directory, even if it really is one!

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

=item get_log_filehandle()

Returns the open file handle for the file specified by the B<DebugLogFile>
option specified by C<new()>.  If you did not use this option, it will return
undef.

Just be aware that once this object goes out of scope, the returned file handle
becomes invalid.

=item set_dc_from_hash( HASH )

This function provides you a way to micro manage the I<SSL> characteristics
of the FTPS Data Channel without having to hack the Net::FTPSSL code base.
It should be called as soon as possible after the call to B<new()>.

It takes a I<HASH> as it's argument.  Either by value or by address.
This hash of key/value pairs will be used to control the Data Channel
I<SSL> options.

If the key's value is set to I<undef>, it is an instruction to delete an
existing Data Channel option.  If the key has a value it is an instruction to
add this key/value pair to the Data Channel options.  If the option already
exists, it will override that value.

It returns the number of entries updated for the Data Channel.

=item copy_cc_to_dc( FORCE, ARRAY )

This function provides you a way to copy some of the I<SSL> options used
to manage the Command Channel over to the Data Channel as well without
having to hack the Net::FTPSSL code base.  It should be called as soon
as possible after the call to B<new()>.

It takes an I<ARRAY> as it's arguments.  Either by value or by address.
It looks up each array value in the Command Channel's I<SSL> characteristics
and copies them over to use as a Data Channel option.

If the option doen't exist for the Command Channel, that array entry is ignored.

If the option is already set in the Data Channel, the array entry overrides
the current value in the Data Channel.

It returns the number of entries updated for the Data Channel.

=item trapWarn()

This method is only active if I<Debug> is turned on with I<DebugLogFile>
provided as well.  Otherwise calling it does nothing.  This trap for I<warnings>
is automatically turned off when the the instance of this class goes out of
scope.  It returns B<1> if the trap was turned on, else B<0> if it wasn't.

Calling this method causes all B<Perl> I<warnings> to be written to the log
file you specified when you called I<new()>.  The I<warnings> will appear in
the log file when they occur to assist in debugging this module.  It
automatically puts the word I<WARNING:> in front of the message being logged.

So this method is only really useful if you wish to open a B<CPAN> ticket to
report a problem with I<Net::FTPSSL> and you think having the generated warning
showing up in the logs will help in getting your issue resolved.

You may call this method for multiple I<Net::FTPSSL> instances and it will
cause the I<warning> to be written to multiple log files.

If your program already traps I<warnings> before you call this method, this
code will forward the warning to your trap logic as well.

=back

=head1 INTERPRETING THE LOGS

The logs generated by I<Net::FTPSSL> are very easy to interpret.  After you get
past the initial configuration information needed to support opening a I<CPAN>
ticket, it's basically the B<FTPS> traffic going back and forth between your
perl I<Client> and the I<FTPS Server> you are talking to.

Each line begins with a prefix that tells what is happening.

C<E<gt>E<gt>E<gt>> - Represents outbound traffic sent to the FTPS Server.

C<E<lt>E<lt>E<lt>> - Represents inbound traffic received from the FTPS Server.

C<E<lt>E<lt>+> - Represents messages from I<Net::FTPSSL> itself in response to
a request that doesn't hit the I<FTPS Server>.

C<WARNING:> - Represents a trapped I<perl warning> written to the logs.

C<SKT E<gt>E<gt>E<gt>> & C<SKT E<lt>E<lt>E<lt>> represent socket traffic
before the I<Net::FTPSSL> object gets created.

There are a couple of other rare variants to the above theme.  But they are
purely information only.  So this is basically it.

=head1 AUTHORS

Marco Dalla Stella - <kral at paranoici dot org>

Curtis Leach - <cleach at cpan dot org> - As of v0.05

=head1 SEE ALSO

I<Net::Cmd>

I<Net::FTP>

I<Net::SSLeay::Handle>

I<IO::Socket::SSL>

RFC 959 - L<http://www.rfc-editor.org/info/rfc959>

RFC 2228 - L<http://www.rfc-editor.org/info/rfc2228>

RFC 2246 - L<http://www.rfc-editor.org/info/rfc2246>

RFC 4217 - L<http://www.rfc-editor.org/info/rfc4217>

=head1 CREDITS

Graham Barr <gbarr at pobox dot com> - for have written such a great
collection of modules (libnet).

=head1 BUGS

Please report any bugs with a FTPS log file created via options B<Debug=E<gt>1>
and B<DebugLogFile=E<gt>"file.txt"> along with your sample code at
L<https://metacpan.org/pod/Net::FTPSSL>.

Patches are appreciated when a log file and sample code are also provided.

=head1 COPYRIGHT

Copyright (c) 2009 - 2019 Curtis Leach. All rights reserved.

Copyright (c) 2005 Marco Dalla Stella. All rights reserved.

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

