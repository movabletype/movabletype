#! /usr/bin/perl

package MT::FCGI::IIS;

use strict;

use CGI;
use FCGI;

my $fcgi_handling_request = 0;
my $fcgi_exit_requested = 0;

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

            # MT_DIR/lib/MT/FCGI/IIS.pm -> MT_DIR/lib/MT -> MT_DIR/lib -> MT_DIR
            require File::Basename;
            $dir = File::Basename::dirname(
                File::Basename::dirname(
                    File::Basename::dirname(
                        File::Basename::dirname( File::Spec->rel2abs(__FILE__) )
                    )
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

sub import {
    my ($pkg, %param) = @_;
    my $class = $param{App} || $ENV{MT_APP};

    eval "require $class;" or die $@;
    my $app = $class->new();
    my $cfg = $app->config;
    my $max_requests = $cfg->FastCGIMaxRequests;
    my $max_time = $cfg->FastCGIMaxTime;

    $fcgi_handling_request = FCGI::Request();
    while($fcgi_handling_request->Accept() >= 0) {
        $ENV{FAST_CGI_IIS} = $fcgi_handling_request->IsFastCGI();

        $app->{fcgi_startup_time} ||= time;
        $app->{fcgi_request_count} = ( $app->{fcgi_request_count} || 0 ) + 1;

        CGI::initialize_globals();
        my $q = CGI->new;

        local $SIG{__WARN__} = sub { $app->trace( $_[0] ) };
        MT->set_instance($app);
        $app->config->read_config_db();
        $app->init_request( CGIObject => $q );
        $app->{cookies} = do { $q->cookie; $q->{'.cookies'} };
        $app->run;
        
        last if $fcgi_exit_requested;
        last if $max_time && (time - $app->{fcgi_startup_time} >= $max_time);
        last if $max_requests && ($app->{fcgi_request_count} >= $max_requests);
    }
}

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

1;
