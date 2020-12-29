# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::Bootstrap;

use strict;
use warnings;

sub BEGIN {
    my ( $dir, $orig_dir );
    require File::Spec;
    if ( !( $dir = $ENV{MT_HOME} ) ) {
        if ( ( $ENV{SCRIPT_FILENAME} || $0 ) =~ m!(.*([/\\]))! ) {
            $orig_dir = $dir = $1;
            my $slash = $2;
            $dir =~ s!(?:[/\\]|^)(?:plugins[/\\].*|tools[/\\])$!$slash!;
            $dir = '' if ( $dir =~ m!^\.?[\\/]$! );
        }
        elsif ( $] >= 5.006 ) {

         # MT_DIR/lib/MT/Bootstrap.pm -> MT_DIR/lib/MT -> MT_DIR/lib -> MT_DIR
            require File::Basename;
            $dir = File::Basename::dirname(
                File::Basename::dirname(
                    File::Basename::dirname( File::Spec->rel2abs(__FILE__) )
                )
            );
        }
        unless ($dir) {
            $orig_dir = $dir = $ENV{PWD} || '.';
            $dir =~ s!(?:[/\\]|^)(?:plugins[/\\].*|tools[/\\]?)$!!;
        }
        $ENV{MT_HOME} = $dir;
    }
    unshift @INC, File::Spec->catdir( $dir,      'extlib' );
    unshift @INC, File::Spec->catdir( $orig_dir, 'lib' )
        if $orig_dir && ( $orig_dir ne $dir );
}

my $fcgi_exit_requested   = 0;
my $fcgi_handling_request = 0;

sub fcgi_sig_handler {
    my $sig = shift;
    $fcgi_exit_requested = $sig;
    if ($fcgi_handling_request) {

       # With exit requested flag set, FastCGI loop will exit when it is done.
        print STDERR
            "Movable Type: SIG$sig caught. Exiting gracefully after current request.\n";
    }
    else {

        # Not currently handling a request, so just go ahead and exit.
        print STDERR "Movable Type: SIG$sig caught. Exiting gracefully.\n";
        exit(1);
    }
}

sub import {
    my ( $pkg, %param ) = @_;

    # use 'App' parameter, or MT_APP from the environment
    my $class = $param{App} || $ENV{MT_APP};

    if ($class) {

        # When running under FastCGI, the initial invocation of the
        # script has a bare environment. We can use this to test
        # for FastCGI.
        require MT::Util;
        my $fast_cgi = MT::Util::check_fast_cgi( $param{FastCGI} );

        # ready to run now... run inside an eval block so we can gracefully
        # die if something bad happens
        my $app;
        eval {

            # line __LINE__ __FILE__
            require MT;
            eval "# line "
                . __LINE__ . " "
                . __FILE__
                . "\nrequire $class; 1;"
                or die $@;
            if ($fast_cgi) {
                $ENV{FAST_CGI} = 1;

                # Signal handling needs FAIL_ACCEPT_ON_INTR set:
                # "If set, Accept will fail if interrupted. It not set, it
                # will just keep on waiting."
                require FCGI;
                $CGI::Fast::Ext_Request
                    = FCGI::Request( \*STDIN, \*STDOUT, \*STDERR, \%ENV, 0,
                    FCGI::FAIL_ACCEPT_ON_INTR() );
                my ( $max_requests, $max_time, $cfg );

        # catch SIGHUP, SIGUSR1 and SIGTERM and allow request to finish before
        # exiting.
        # TODO: handle SIGPIPE more gracefully.
                $SIG{HUP}  = \&fcgi_sig_handler;
                $SIG{USR1} = \&fcgi_sig_handler unless $^O eq 'MSWin32';
                $SIG{TERM} = \&fcgi_sig_handler;
                $SIG{PIPE} = 'IGNORE';

                $app = $class->new(%param) or die $class->errstr;
                delete $app->{init_request};

           # we set the "handling request" flag so the signal handler can exit
           # immediately when requests aren't being handled.
                while ( $fcgi_handling_request = ( my $cgi = new CGI::Fast ) )
                {
                    $ENV{FAST_CGI} = 1;
                    $app->{fcgi_startup_time} ||= time;
                    $app->{fcgi_request_count}
                        = ( $app->{fcgi_request_count} || 0 ) + 1;

                    unless ($cfg) {
                        $cfg          = $app->config;
                        $max_requests = $cfg->FastCGIMaxRequests;
                        $max_time     = $cfg->FastCGIMaxTime;
                    }

                    local $SIG{__WARN__} = sub { $app->trace( $_[0] ) };
                    MT->set_instance($app);
                    $app->config->read_config_db();
                    $app->init_request( CGIObject => $cgi );
                    $app->run;

                    $fcgi_handling_request = 0;

                    # Check for caught signal
                    if ($fcgi_exit_requested) {
                        print STDERR
                            "Movable Type: FastCGI request loop exiting. Caught signal SIG$fcgi_exit_requested.\n";
                        last;
                    }

                    # Check for timeout for this process
                    elsif ( $max_time
                        && ( time - $app->{fcgi_startup_time} >= $max_time ) )
                    {
                        last;
                    }

                    # Check for max executions for this process
                    elsif ( $max_requests
                        && ( $app->{fcgi_request_count} >= $max_requests ) )
                    {
                        last;
                    }
                    else {
                        require MT::Touch;
                        require MT::Util;

                        # Avoid an error when using SQL Server.
                        my $latest_touch
                            = sub { MT::Touch->latest_touch( 0, 'config' ) };
                        my $touched
                            = MT->config->ObjectDriver =~ /MSSQLServer/i
                            ? eval { $latest_touch->() }
                            : $latest_touch->();

                        if ($touched) {

                            # Should get UNIX epoch with no_offset flag,
                            # since MT::Touch uses gmtime always.
                            $touched
                                = MT::Util::ts2epoch( undef, $touched, 1 );
                            if ( $touched > $app->{fcgi_startup_time} ) {
                                last;
                            }
                        }
                    }

                    # force closing of connection here
                    $CGI::Fast::Ext_Request->Finish();
                }
                $CGI::Fast::Ext_Request->LastCall();

                # closing FastCGI's listening socket, so the server won't
                # open new connections to us
                require POSIX;
                POSIX::close(0);
                $CGI::Fast::Ext_Request->Finish();
            }
            else {
                $ENV{FAST_CGI} = 0;
                $app = $class->new(%param) or die $class->errstr;
                local $SIG{__WARN__} = sub { $app->trace( $_[0] ) };
                $app->init_request;
                $app->run;
            }
        };
        if ( my $err = $@ ) {
            if ( !$app && $err =~ m/Missing configuration file/ ) {

                # Preserve before overwriting.
                my $mt_home = $ENV{MT_HOME};

                # If using FastCGI, populate environment hash.
                new CGI::Fast if $ENV{FAST_CGI};

                my $host = $ENV{SERVER_NAME} || $ENV{HTTP_HOST};
                $host =~ s/:\d+//;
                my $port = $ENV{SERVER_PORT};
                my $uri = $ENV{REQUEST_URI} || $ENV{SCRIPT_NAME};
                if ( $uri =~ m/(\/mt\.(f?cgi|f?pl)(\?.*)?)$/ ) {
                    my $script = $1;
                    my $ext    = $2;

                    my $file;
                    if (-f File::Spec->catfile( $mt_home, "mt-wizard.$ext" ) )
                    {
                        $file = '/mt-wizard.' . $ext;
                    }
                    elsif (
                        -f File::Spec->catfile( $mt_home, 'mt-wizard.cgi' ) )
                    {
                        $file = '/mt-wizard.cgi';    # default file name
                    }

                    if ($file) {
                        $uri =~ s/\Q$script\E//;
                        $uri .= $file;

                        my $prot = $port == 443 ? 'https' : 'http';
                        my $cgipath = "$prot://$host";
                        $cgipath .= ":$port"
                            unless $port == 443
                            or $port == 80;
                        $cgipath .= $uri;
                        print "Status: 302 Moved\n";
                        print "Location: " . $cgipath . "\n\n";
                        exit;
                    }
                }
            }

            my $charset = 'utf-8';
            eval {

                # line __LINE__ __FILE__
                my $cfg = MT::ConfigMgr->instance;    #this is needed
                $app ||= MT->instance;
                my $c = $app->find_config;
                $app->{cfg}->read_config($c);
                $charset = $app->{cfg}->PublishCharset;
            };
            if (   $app
                && UNIVERSAL::isa( $app, 'MT::App' )
                && !UNIVERSAL::isa( $app, 'MT::App::Wizard' ) )
            {
                require MT::I18N;
                my $enc = MT::I18N::guess_encoding($err);
                $err = Encode::decode( $enc, $err )
                    unless Encode::is_utf8($err);
                eval {

                    # line __LINE__ __FILE__
                    if ( !$MT::DebugMode
                        && ( $err =~ m/^(.+?)( at .+? line \d+)(.*)$/s ) )
                    {
                        $err = $1;
                    }
                    my %param = ( error => $err );
                    if ( $err =~ m/Bad ObjectDriver/ ) {
                        $param{error_database_connection} = 1;
                    }
                    elsif ( $err =~ m/Bad CGIPath/ ) {
                        $param{error_cgi_path} = 1;
                    }
                    elsif ( $err =~ m/Missing configuration file/ ) {
                        $param{error_config_file} = 1;
                    }
                    my $page = $app->show_error(\%param)
                        or die $app->errstr;
                    print "Content-Type: text/html; charset=$charset\n\n";
                    $app->print_encode($page);
                    exit;
                };
                $err = $@;
            }
            elsif ( $app && UNIVERSAL::isa( $app, 'MT::App::Wizard' ) ) {
                ## Because mt-config.cgi was not found in this time.
                $err = '';
            }

            if ($err) {
                if ( !$MT::DebugMode
                    && ( $err =~ m/^(.+?)( at .+? line \d+)(.*)$/s ) )
                {
                    $err = $1;
                }
                print "Content-Type: text/plain; charset=$charset\n\n";
                print $app
                    ? Encode::encode( $charset,
                    $app->translate( "Got an error: [_1]", $err ) )
                    : "Got an error: " . Encode::encode( $charset, $err );
            }
        }
    }
}

1;
__END__

=head1 NAME

MT::Bootstrap

=head1 DESCRIPTION

Startup module used to simplify MT application CGIs.

=head1 SYNOPSIS

Movable Type CGI scripts should utilize the C<MT::Bootstrap> module
to invoke the application code itself. When run, it is necessary
to add the MT "lib" directory to the Perl include path.

Example (for CGIs in the main MT directory itself):

    #!/usr/bin/perl -w
    use strict;
    use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib" : 'lib';
    use MT::Bootstrap App => 'MT::App::CMS';

Example (for CGIs in a plugin subdirectory, ie MT/plugins/plugin_x):

    #!/usr/bin/perl -w
    use strict;
    use lib "lib", ($ENV{MT_HOME} ? "$ENV{MT_HOME}/lib" : "../../lib");
    use MT::Bootstrap App => 'MyApp';

=head1 METHODS

=head2 fcgi_sig_handler($sig)

This is a signal handler for the FastCGI mode. Waits to complete a request
in processing and terminates the FastCGI process.

=cut
