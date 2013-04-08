# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::PSGI;

use strict;
use warnings;
use parent qw(Plack::Component);
use Plack::Util::Accessor qw(script application url _app);
use MT;
use MT::Component;
use Carp;
use FindBin;
use CGI::PSGI;
use CGI::Parse::PSGI;
use Plack::Builder;
use Plack::Request;
use Plack::App::URLMap;
use Plack::App::WrapCGI;
use Plack::App::Directory;
use Plack::App::File;
use IPC::Open3;
use IO::Select;
use Symbol qw( gensym );
use XMLRPC::Transport::HTTP::Plack;

use constant DEBUG => $ENV{MT_PSGI_DEBUG} || 0;
our $mt = MT->new();

my $mt_app = sub {
    my $app_class = shift;
    return sub {
        my $env = shift;
        eval "require $app_class";
        my $cgi = CGI::PSGI->new($env);
        local *ENV = { %ENV, %$env };    # some MT::App method needs this
        my $app = $app_class->new( CGIObject => $cgi );
        delete $app->{init_request};
        MT->set_instance($app);

        # Cheap hack to get the output
        my ( $header_sent, $body );
        no warnings qw(redefine);
        local *MT::App::send_http_header = sub {
            my $self = shift;
            $self->{response_content_type} = $_[0] if $_[0];
            $header_sent++;
        };
        local *MT::App::print
            = sub { my $self = shift; $body .= "@_" if $header_sent };

        $app->init_request( CGIObject => $cgi );
        $app->{cookies} = do { $cgi->cookie; $cgi->{'.cookies'} };    # wtf
        $app->run;

        # copied from MT::App::send_http_header
        my $type = $app->{response_content_type} || 'text/html';
        if ( my $charset = $app->charset ) {
            $type .= "; charset=$charset"
                if ( $type =~ m!^text/! || $type =~ m!\+xml$! )
                && $type !~ /\bcharset\b/;
        }

        if ( $app->{redirect} ) {
            $app->{cgi_headers}{-status}   = 302;
            $app->{cgi_headers}{-location} = $app->{redirect};
        }
        else {
            $app->{cgi_headers}{-status} = ( $app->response_code || 200 )
                . (
                $app->{response_message}
                ? ' ' . $app->{response_message}
                : ''
                );
        }

        $app->{cgi_headers}{-type} = $type;
        my ( $status, $headers )
            = $app->{query}->psgi_header( %{ $app->{cgi_headers} } );
        return [ $status, $headers, [$body] ];
    };
};

## Run apps as non persistence cgi
my $mt_cgi = sub {
    my $script = shift;
    return sub {
        my $env = shift;
        if ( $env->{'psgi.streaming'} ) {
            DEBUG
                && warn
                "[$$] Bootstrap CGI script in non-buffering mode: $script\n";
            return run_cgi_without_buffering( $env, $script );
        }
        else {
            DEBUG
                && warn
                "[$$] Bootstrap CGI script in buffering mode: $script\n";
            return run_cgi_with_buffering( $env, $script );
        }
    };
};

sub run_cgi_with_buffering {
    my $env    = shift;
    my $script = shift;
    my $wrap   = Plack::App::WrapCGI->new( script => $script, execute => 1 );
    $wrap->($env);
}

sub run_cgi_without_buffering {
    my $env    = shift;
    my $script = shift;
    return sub {
        my $respond = shift;
        my $pid;
        my ( $child_in, $child_out, $child_err );
        $child_err = gensym();
        {
            local %ENV
                = ( %ENV, CGI::Emulate::PSGI->emulate_environment($env) );
            eval {
                $pid = open3( $child_in, $child_out, $child_err, $script );
            };
            die $@ if $@;
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
        while (1) {
            while ( my @ready = $s->can_read ) {
                for my $fh (@ready) {
                    if ( my $len = sysread( $fh, my $buf, 4096 ) > 0 ) {
                        if ( $fh == $child_out ) {
                            if ($header_sent) {
                                $writer->write($buf);
                            }
                            else {
                                $header .= $buf;
                                if ( $header =~ /\r\n\r\n/ ) {
                                    my $res
                                        = CGI::Parse::PSGI::parse_cgi_output(
                                        \$header );
                                    my %header = @{ $res->[1] };
                                    delete $header{'Content-Length'};
                                    $res->[1] = [%header];
                                    my $body = delete $res->[2];
                                    $writer = $respond->($res);
                                    $body = join '', @$body
                                        if 'ARRAY' eq ref $body;
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

            last if waitpid( $pid, 1 ) > 0;
        }
        $writer->close if $writer;
    };
}

sub prepare_app {
    my $self = shift;
    my $app;
    if ( $self->application ) {
        $app = $self->make_app( $self->application );
    }
    else {
        $app = $self->mount_applications( $self->application_list );
    }

    return $self->_app($app);
}

sub application_list {
    my $reg  = MT::Component->registry('applications');
    my %apps = map {
        map { $_ => 1 }
            keys %$_
    } @$reg;
    keys %apps;
}

sub make_app {
    my $self = shift;
    my ($app) = @_;
    $app = MT->registry( applications => $app ) unless ref $app;
    Carp::croak('No application is specified') unless $app;
    my $script = $self->{script} || $app->{script};
    $script = MT->handler_to_coderef($script) unless ref $script;
    $script = $script->();
    my $type = $app->{type} || '';
    my $psgi_app;

    if ( $type eq 'run_once' ) {
        my $filepath = File::Spec->catfile( $FindBin::Bin, $script );
        $psgi_app = $mt_cgi->($filepath);
    }
    elsif ( $type eq 'xmlrpc' ) {
        my $handler = $app->{handler};
        my $server;
        $server = XMLRPC::Transport::HTTP::Plack->new;
        $server->dispatch_to( 'blogger', 'metaWeblog', 'mt', 'wp' );
        $psgi_app = sub {
            eval "require $handler";
            my $env = shift;
            my $req = Plack::Request->new($env);
            $server->handle($req);
        };
    }
    else {
        my $handler = $app->{handler};
        $psgi_app = $mt_app->($handler);
    }
    $self->_app($psgi_app);
}

sub mount_applications {
    my $self           = shift;
    my (@applications) = @_;
    my $urlmap         = Plack::App::URLMap->new;
    for my $app_id (@applications) {
        my $app = MT->registry( applications => $app_id ) unless ref $app_id;
        Carp::croak('No application is specified') unless $app;
        my $base = $app->{cgi_path};
        if ($base) {
            $base = MT->handler_to_coderef($base) unless ref $base;
            $base = $base->();
        }
        else {
            $base = $mt->config->CGIPath;
        }
        $base =~ s!/$!!;
        $base =~ s!^https?://[^/]*!!;
        my $script = $app->{script};
        $script = MT->handler_to_coderef($script) unless ref $script;
        $script = $script->();
        $script =~ s!^/!!;
        my $url      = $base . '/' . $script;
        my $psgi_app = $self->make_app($app);
        $psgi_app = $self->apply_plack_middlewares( $app_id, $psgi_app );
        $urlmap->map( $url, $psgi_app );
    }

    ## Mount mt-static directory
    my $staticurl = $mt->static_path();
    $staticurl =~ s!^https?://[^/]*!!;
    my $staticpath = $mt->static_file_path();
    $urlmap->map( $staticurl,
        Plack::App::Directory->new( { root => $staticpath } )->to_app );

    ## Mount support directory
    my $supporturl = MT->config->SupportURL;
    $supporturl =~ s!^https?://[^/]*!!;
    my $supportpath = MT->config->SupportDirectoryPath;
    $urlmap->map( $supporturl,
        Plack::App::Directory->new( { root => $supportpath } )->to_app );

    ## Mount favicon.ico
    my $static = $staticpath;
    $static .= '/' unless $static =~ m!/$!;
    my $favicon = $static . 'images/favicon.ico';
    $urlmap->map(
        '/favicon.ico' => Plack::App::File->new( { file => $favicon } )->to_app );

    $self->_app( $urlmap->to_app );
}

sub apply_plack_middlewares {
    my ( $self, $app_id, $app ) = @_;

    my $middlewares = MT::Component->registry('plack_middlewares');
    my @middlewares = map { ref $_ eq 'ARRAY' ? @$_ : $_ } @$middlewares;

    my $builder = Plack::Builder->new();
    foreach my $middleware (@middlewares) {
        if ( $middleware->{apply_to} ) {
            my $apply_to = $middleware->{apply_to};
            $apply_to = [$apply_to] unless 'ARRAY' eq ref $apply_to;
            next
                if ( $app_id
                && !( grep { $_ eq 'all' || $_ eq $app_id } @$apply_to ) );
        }

        my $name = $middleware->{name};
        my %options;
        foreach my $opt ( @{ $middleware->{options} } ) {
            if ( $opt->{value} ) {
                $options{ $opt->{key} } = $opt->{value};
            }
            elsif ( $opt->{code} ) {
                my $code = MT->handler_to_coderef( $opt->{code} );
                $options{ $opt->{key} } = $code->() if $code;
            }
            elsif ( $opt->{handler} ) {
                $options{ $opt->{key} }
                    = MT->handler_to_coderef( $opt->{handler} );
            }
        }
        if ( $middleware->{condition} ) {
            my $condition
                = MT->handler_to_coderef( $middleware->{condition} );
            $builder->add_middleware_if( $condition, $name, %options );
        }
        else {
            $builder->add_middleware( $name, %options );
        }
    }

    return $builder->to_app($app);
}

sub call {
    my ( $self, $env ) = @_;
    $self->_app->($env);
}

1;

__END__

=head1 NAME

MT::PSGI - Movable Type as PSGI application


=head1 SYNOPSIS

    # Full stack Movable Type server
    use MT::PSGI;
    use Plack::Builder;
    builder {
        MT::PSGI->new()->to_app();
    }

    # Or, get single MT::App based application
    my $app = MT::PSGI->new( application => 'cms' )->to_app();


=head1 DESCRIPTION

MT::PSGI compiles MT::App into a PSGI application.


=head1 OPTIONS

=over 4

=item application

If application is given, returns single application instance of given application
ID.

    my $cms = MT::PSGI->new( application => 'cms' )->to_app();

Otherwise, returns full stack MT instance, includes all MT applications and
static file servers. Applications will automatically be dispatched according to
Config Directives, e.g. CGIPath, AdminScript, etc.

=back


=head1 REGISTRY

MT::PSGI looks up MT's registry to set up the behavior of application. When
you create a new MT based application and run it on MT::PSGI, need to set proper
values to your application registry.

=over 4

=item applications/YOURAPP/script

Subroutine reference that returns your script's endpoint name. Typically it might
looks like this:

    script => sub { MT->config->MyAppScript },

=item applications/YOURAPP/cgi_path

If you want to mount your application on the path different from other
applications, you can set subroutine reference that returns path to your
application. for example;

    cgi_path => sub { MT->config->MyAlternativeCGIPath },

By default, the value of CGIPath config directive will be used.

=item applications/YOURAPP/type

Specify the application type. Only 'run_once' and 'xmlrpc' are acceptable value.
If type is not given, standard persistent PSGI application will be compiled.

=over 8

=item run_once

Run as non-persistent CGI script with C<fork>/C<exec> model. It's good for
the kind of applications which be excuted infrequently like MT::Upgrader.
Also usable to run old script who have no good cleanup process at exiting.

=item xmlrpc

Special mode for apps which constructed on XMLRPC::Lite. Make PSGI app with
using XMLRPC::Transport::HTTP::Plack.

=back

=item plack_middlewares

You can use Plack::Middleware. The following options can be specified. 

=over 8

=item name

The part after "Plack::Middleware::" of the name of Plack::Middleware to apply is specified.

=item options

Arrangement of middleware's options.

=over 12

=item key

Option's name.

=item parameters

The parameter which can be specified to options is the following three kinds.

=over 16

=item value

The simple value of option.

=item code

Subroutine reference.

=item handler

Handler to subroutine reference.

=back

=back

=item condition

The conditions of middleware application are specified with a code reference or a handler.

=item apply_to

Application ID which applies middleware. You can specify a single ID or multiple ID with array.
If does not specified, just as 'all' is specified.

=back

for example:

    plack_middlewares:
        - name: Auth::Basic
          options:
              - key: authenticator
                handler: Cloud::Auth::Basic::authenticator
          condition: Cloud::Auth::Basic::condition
          apply_to:
              - cms
              - upgrade

=back

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
