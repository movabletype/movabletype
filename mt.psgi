#!/usr/bin/perl -w
use strict;
use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib" : 'lib';
use FindBin;
use MT;
use CGI::PSGI;
use Plack::App::URLMap;
use Plack::App::WrapCGI;
use Plack::Builder;
use CGI::Parse::PSGI;
use IPC::Open3;
use IO::Select;
use Symbol qw( gensym );
use Plack::Request;
use XMLRPC::Transport::HTTP::Plack;
use Plack::App::Directory;

use constant DEBUG => $ENV{MT_PSGI_DEBUG} || 0;
MT->new();

my $mt_app = sub {
    my $app_class = shift;
    return sub {
        my $env = shift;
        eval "require $app_class";
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

sub url_for {
    my ( $id, $script ) = @_;
    my $base
        = $id eq 'cms'
        ? MT->config->AdminCGIPath || MT->config->CGIPath
        : MT->config->CGIPath;
    $base   =~ s!^https?://[^/]*/!/!;
    $base   =~ s!/$!!;
    $script =~ s!^/!!;
    return $base . '/' . $script;
}

my $urlmap = Plack::App::URLMap->new;
my %APPS   = map {
    map { $_ => 1 } keys %$_
} @{ MT::Component->registry('applications') };

for my $id ( keys %APPS ) {
    my $app = MT->registry( applications => $id ) or next;
    my $script = $app->{script};
    $script = MT->handler_to_coderef($script) unless ref $script;
    $script = $script->();
    my $type = $app->{type};
    if ( $type eq 'run_once' ) {
        my $url = url_for( $id, $script );
        my $filepath = File::Spec->catfile( $FindBin::Bin, $script );
        DEBUG && warn "Mount CGI File ($filepath) in ($url)\n";
        $urlmap->map( $url, $mt_cgi->($filepath) );
    }
    elsif ( $type eq 'xmlrpc' ) {
        my $handler = $app->{handler};
        my $server;
        $server = XMLRPC::Transport::HTTP::Plack->new;
        $server->dispatch_to( 'blogger', 'metaWeblog', 'mt', 'wp' );
        my $url = url_for( $id, $script );
        DEBUG && warn "Mount xmlrpc server $handler in $url\n";
        $urlmap->map( $url, sub {
            eval "require $handler";
            my $env = shift;
            my $req = Plack::Request->new($env);
            $server->handle($req);
        });
    }
    else {
        my $handler = $app->{handler};
        my $url = url_for( $id, $script );
        DEBUG && warn "Mount $handler in $url\n";
        $urlmap->map( $url, $mt_app->($handler) );
    }
}

## Mount mt-static directory
my $url = MT->config->StaticWebPath;
$url =~ s!^https?://[^/]*!!;
my $path = MT->config->StaticFilePath;
$urlmap->map( $url, Plack::App::Directory->new({ root => MT->config->StaticFilePath }) );

builder {
    $urlmap->to_app;
}
