#!/usr/bin/perl -w
use strict;
use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib" : 'lib';
use FindBin;
use MT;
use CGI::PSGI;
use Plack::App::URLMap;
use Plack::App::WrapCGI;
use CGI::Parse::PSGI;
use IPC::Open3;
use IO::Select;
use POSIX ":sys_wait_h";
use Symbol qw( gensym );

use constant DEBUG => $ENV{MT_PSGI_DEBUG} || 0;
MT->new();

sub reboot {
    my $pidfilepath = MT->config('PIDFilePath')
        or return;
    open my $pidfile, '<', $pidfilepath
        or die "Failed to open pid file $pidfilepath: $!";
    my $pid = do { local $/; <$pidfile> };
    close $pidfile;
    kill 1, $pid;
}

# Hook the MT::Touch::touch and if touching to 'config' object, that means restart in MT.
require MT::Touch;
MT::Touch->add_callback(
    'pre_save',
    5,
    undef,
    sub {
        my ( $cb, $obj ) = @_;
        if ( $obj->object_type eq 'config' ) {
            reboot();
        }
    },
);

my $mt_app = sub {
    my $app_class = shift;
    eval "require $app_class";
    return sub {
        my $env = shift;
        my $cgi = CGI::PSGI->new($env);
        local *ENV = { %ENV, %$env }; # some MT::App method needs this
        my $app = $app_class->new( CGIObject => $cgi );
        delete $app->{init_request};
        MT->set_instance($app);

        # Cheap hack to get the output
        my ($header_sent, $body);
        local *MT::App::send_http_header = sub { $header_sent++ };
        local *MT::App::print = sub { my $self = shift; $body .= "@_" if $header_sent };

        $app->init_request(CGIObject => $cgi);
        $app->{cookies} = do { $cgi->cookie; $cgi->{'.cookies'} }; # wtf
        $app->run;

        # copied from MT::App::send_http_header
        my $type = $app->{response_content_type} || 'text/html';
        if ( my $charset = $app->charset ) {
            $type .= "; charset=$charset"
                if ( $type =~ m!^text/! || $type =~ m!\+xml$! )
                && $type !~ /\bcharset\b/;
        }

        if ($app->{redirect}) {
            $app->{cgi_headers}{-status}   = 302;
            $app->{cgi_headers}{-location} = $app->{redirect};
        } else {
            $app->{cgi_headers}{-status}
                = ( $app->response_code || 200 )
                . ( $app->{response_message} ? ' ' . $app->{response_message} : '' );
        }

        $app->{cgi_headers}{-type} = $type;
        my($status, $headers) = $app->{query}->psgi_header( %{ $app->{cgi_headers} } );
        return [ $status, $headers, [ $body ] ];
    };
};

## Run apps as non persistence cgi
my $mt_cgi = sub {
    my $script = shift;
    return sub {
        my $env = shift;
        if ( $env->{'psgi.streaming'} ) {
            DEBUG && warn "[$$] Bootstrap CGI script in non-buffering mode: $script\n";
            return run_cgi_without_buffering( $env, $script );
        }
        else {
            DEBUG && warn "[$$] Bootstrap CGI script in buffering mode: $script\n";
            return run_cgi_with_buffering( $env, $script );
        }
    };
};

sub run_cgi_with_buffering {
    my $env = shift;
    my $script = shift;
    my $wrap = Plack::App::WrapCGI->new( script => $script, execute => 1 );
    $wrap->($env);
}

sub run_cgi_without_buffering {
    my $env = shift;
    my $script = shift;
    return sub {
        my $respond = shift;
        my $pid;
        my ( $child_in, $child_out, $child_err);
        $child_err = gensym();
        {
            local %ENV = (%ENV, CGI::Emulate::PSGI->emulate_environment($env));
            $pid = open3( $child_in, $child_out, $child_err, $script );
        }
        syswrite $child_in, do {
            local $/;
            my $fh = $env->{'psgi.input'};
            <$fh>;
        };
        my $s = IO::Select->new( $child_out, $child_err );
        my $header = '';
        my $header_sent;
        my $writer;
        while (my @ready = $s->can_read) {
            for my $fh (@ready) {
                if (my $len = sysread($fh, my $buf, 4096) > 0) {
                    if ($fh == $child_out) {
                        if ( $header_sent ) {
                            $writer->write($buf);
                        }
                        else {
                            $header .= $buf;
                            if ( $header =~ /\r\n\r\n/ ) {
                                my $res = CGI::Parse::PSGI::parse_cgi_output(\$header);
                                my %header = @{ $res->[1] };
                                delete $header{'Content-Length'};
                                $res->[1] = [ %header ];
                                my $body = delete $res->[2];
                                $writer = $respond->($res);
                                $body = join '', @$body if 'ARRAY' eq ref $body;
                                $writer->write($body);
                                $header_sent = 1;
                            }
                        }
                    }
                    elsif ( $fh == $child_err ) {
                        syswrite $env->{'psgi.errors'}, $buf;
                    }
                }
                else {
                    $s->remove($fh);
                    close $fh;
                }
            }
        }
        $writer->close if $writer;
    };
}

my %DAEMON_SCRIPTS = (
    cms        => MT->config->AdminScript,
    feeds      => MT->config->ActivityFeedScript,
    comments   => MT->config->CommentScript,
    tb         => MT->config->TrackbackScript,
    new_search => MT->config->SearchScript,
    view       => MT->config->ViewScript,
    atom       => MT->config->AtomScript,
    notify     => MT->config->NotifyScript,
    community  => MT->config->CommunityScript,
);

my %CGI_SCRIPTS = (
    wizard  => 'mt-wizard.cgi',
    check   => 'mt-check.cgi', # TBD: This will fail since no entry is in core registry.
    upgrade => MT->config->UpgradeScript,
    xmlrpc  => MT->config->XMLRPCScript,
);

my $urlmap = Plack::App::URLMap->new;
for my $id ( keys %DAEMON_SCRIPTS ) {
    my $app = MT->registry( applications => $id ) or next;
    my $handler = $app->{handler};
    my $path = $DAEMON_SCRIPTS{$id};
    my $base = $id eq 'cms' ? MT->config->AdminCGIPath || MT->config->CGIPath
             :                MT->config->CGIPath
             ;
    $base =~ s!^https?://[^/]*/!/!;
    $base .= '/' unless $base =~ m!/$!;
    $path = $base . $path;
    DEBUG && warn "Mount $handler in $path\n";
    $urlmap->map( $path, $mt_app->($handler) );
}

for my $id ( keys %CGI_SCRIPTS ) {
    my $app = MT->registry( applications => $id ) or next;
    my $file = $CGI_SCRIPTS{$id};
    my $url = ( $file =~ m!^/! ? '' : '/' ) . $file;
    my $filepath = File::Spec->catfile( $FindBin::Bin, $file );
    $urlmap->map( $url, $mt_cgi->( $filepath ) );
}

$urlmap->to_app;
