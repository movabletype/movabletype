package OAuth::Lite2::Client::WebServer;
use strict;
use warnings;
use base 'Class::ErrorHandler';
use bytes ();

use URI;
use Carp ();
use Try::Tiny qw/try catch/;
use LWP::UserAgent;
use MIME::Base64 qw(encode_base64);
use HTTP::Request;
use HTTP::Headers;
use Params::Validate qw(HASHREF);
use OAuth::Lite2;
use OAuth::Lite2::Util qw(build_content);
use OAuth::Lite2::Client::TokenResponseParser;
use OAuth::Lite2::Client::StateResponseParser;

=head1 NAME

OAuth::Lite2::Client::WebServer - OAuth 2.0 Web Server Profile Client

=head1 SYNOPSIS

    my $client = OAuth::Lite2::Client::WebServer->new(
        id               => q{my_client_id},
        secret           => q{my_client_secret},
        authorize_uri    => q{http://example.org/authorize},
        access_token_uri => q{http://example.org/token},
    );

    # redirect user to authorize page.
    sub start_authorize {
        my $your_app = shift;
        my $redirect_url = $client->uri_to_redirect(
            redirect_uri => q{http://yourapp/callback},
            scope        => q{photo},
            state        => q{optional_state},
        );

        $your_app->res->redirect( $redirect_url );
    }

    # this method corresponds to the url 'http://yourapp/callback'
    sub callback {
        my $your_app = shift;

        my $code = $your_app->request->param("code");

        my $access_token = $client->get_access_token(
            code         => $code,
            redirect_uri => q{http://yourapp/callback},
        ) or return $your_app->error( $client->errstr );

        $your_app->store->save( access_token  => $access_token->access_token  );
        $your_app->store->save( expires_at    => time() + $access_token->expires_in    );
        $your_app->store->save( refresh_token => $access_token->refresh_token );
    }

    sub refresh_access_token {
        my $your_app = shift;

        my $access_token = $client->refresh_access_token(
            refresh_token => $refresh_token,
        ) or return $your_app->error( $client->errstr );

        $your_app->store->save( access_token  => $access_token->access_token  );
        $your_app->store->save( expires_at    => time() + $access_token->expires_in    );
        $your_app->store->save( refresh_token => $access_token->refresh_token );
    }


    sub access_to_protected_resource {
        my $your_app = shift;

        my $access_token  = $your_app->store->get("access_token");
        my $expires_at    = $your_app->store->get("expires_at");
        my $refresh_token = $your_app->store->get("refresh_token");

        unless ($access_token) {
            $your_app->start_authorize();
            return;
        }

        if ($expires_at < time()) {
            $your_app->refresh_access_token();
            return;
        }

        my $req = HTTP::Request->new( GET => q{http://example.org/photo} );
        $req->header( Authorization => sprintf(q{OAuth %s}, $access_token) );
        my $agent = LWP::UserAgent->new;
        my $res = $agent->request($req);
        ...
    }


=head1 DESCRIPTION

Client library for OAuth 2.0 Web Server Profile.

=head1 METHODS

=head2 new( %params )

=over 4

=item id

Client ID

=item secret

Client secret

=item authorize_uri

authorization page uri on auth-server.

=item access_token_uri

token endpoint uri on auth-server.

=item refresh_token_uri

refresh-token endpoint uri on auth-server.
if you omit this, access_token_uri is used instead.

=item agent

user agent. if you omit this, LWP::UserAgent's object is set by default.
You can use your custom agent or preset-agents.

See also

L<OAuth::Lite2::Agent::Dump>
L<OAuth::Lite2::Agent::Strict>
L<OAuth::Lite2::Agent::PSGIMock>

=back

=cut

sub new {

    my $class = shift;

    my %args = Params::Validate::validate(@_, {
        id                => 1,
        secret            => 1,
        # format          => { optional => 1 },
        authorize_uri     => { optional => 1 },
        access_token_uri  => { optional => 1 },
        refresh_token_uri => { optional => 1 },
        agent             => { optional => 1 },
    });

    my $self = bless {
        id                => undef,
        secret            => undef,
        authorize_uri     => undef,
        access_token_uri  => undef,
        refresh_token_uri => undef,
        last_request      => undef,
        last_response     => undef,
        %args,
    }, $class;

    unless ($self->{agent}) {
        $self->{agent} = LWP::UserAgent->new;
        $self->{agent}->agent(
            join "/", __PACKAGE__, $OAuth::Lite2::VERSION);
    }

    $self->{format} ||= 'json';
    $self->{response_parser} = OAuth::Lite2::Client::TokenResponseParser->new;
    $self->{state_response_parser} = OAuth::Lite2::Client::StateResponseParser->new;

    return $self;
}

=head2 uri_to_redirect( %params )

=cut

sub uri_to_redirect {
    my $self = shift;
    my %args = Params::Validate::validate(@_, {
        redirect_uri => 1,
        state        => { optional => 1 },
        scope        => { optional => 1 },
        immediate    => { optional => 1 },
        uri          => { optional => 1 },
        extra        => { optional => 1, type => HASHREF },
    });

    my %params = (
        response_type => 'code',
        client_id     => $self->{id},
        redirect_uri  => $args{redirect_uri},
    );
    $params{state}     = $args{state}     if $args{state};
    $params{scope}     = $args{scope}     if $args{scope};
    $params{immediate} = $args{immediate} if $args{immediate};

    if ($args{extra}) {
        for my $key ( keys %{$args{extra}} ) {
            $params{$key} = $args{extra}{$key};
        }
    }

    my $uri = $args{uri}
        || $self->{authorize_uri}
        || Carp::croak "uri not found";

    $uri = URI->new($uri);
    $uri->query_form(%params);
    return $uri->as_string;
}

=head2 get_access_token( %params )

execute verification,
and returns L<OAuth::Lite2::Client::Token> object.

=over 4

=item code

Authorization-code that is issued beforehand by server

=item redirect_uri

The URL that has used for user authorization's callback

=back

=cut

sub get_access_token {
    my $self = shift;

    my %args = Params::Validate::validate(@_, {
        code            => 1,
        redirect_uri    => 1,
        server_state    => { optional => 1 },
        uri             => { optional => 1 },
        use_basic_schema    => { optional => 1 },
        # secret_type => { optional => 1 },
        # format      => { optional => 1 },
    });

    unless (exists $args{uri}) {
        $args{uri} = $self->{access_token_uri}
            || Carp::croak "uri not found";
    }

    # $args{format} ||= $self->{format};

    my %params = (
        grant_type    => 'authorization_code',
        code          => $args{code},
        redirect_uri  => $args{redirect_uri},
        # format      => $args{format},
    );
    $params{server_state} = $args{server_state} if $args{server_state};

    unless ($args{use_basic_schema}){
        $params{client_id}      = $self->{id};
        $params{client_secret}  = $self->{secret};
    }

    # $params{secret_type} = $args{secret_type}
    #    if $args{secret_type};

    my $content = build_content(\%params);
    my $headers = HTTP::Headers->new;
    $headers->header("Content-Type" => q{application/x-www-form-urlencoded});
    $headers->header("Content-Length" => bytes::length($content));
    $headers->authorization_basic($self->{id}, $self->{secret})    
        if($args{use_basic_schema});
    my $req = HTTP::Request->new( POST => $args{uri}, $headers, $content );

    my $res = $self->{agent}->request($req);
    $self->{last_request}  = $req;
    $self->{last_response} = $res;

    my ($token, $errmsg);
    try {
        $token = $self->{response_parser}->parse($res);
    } catch {
        $errmsg = "$_";
    };
    return $token || $self->error($errmsg);
}

=head2 refresh_access_token( %params )

Refresh access token by refresh_token,
returns L<OAuth::Lite2::Client::Token> object.

=over 4

=item refresh_token

=back

=cut

sub refresh_access_token {
    my $self = shift;

    my %args = Params::Validate::validate(@_, {
        refresh_token => 1,
        # secret_type => { optional => 1 },
        # format      => { optional => 1 },
        uri           => { optional => 1 },
        use_basic_schema    => { optional => 1 },
    });

    unless (exists $args{uri}) {
        $args{uri} = $self->{access_token_uri}
            || Carp::croak "uri not found";
    }

    # $args{format} ||= $self->{format};

    my %params = (
        grant_type    => 'refresh_token',
        refresh_token => $args{refresh_token},
        # format      => $args{format},
    );

    unless ($args{use_basic_schema}){
        $params{client_id}      = $self->{id};
        $params{client_secret}  = $self->{secret};
    }

    # $params{secret_type} = $args{secret_type}
    #   if $args{secret_type};

    my $content = build_content(\%params);
    my $headers = HTTP::Headers->new;
    $headers->header("Content-Type" => q{application/x-www-form-urlencoded});
    $headers->header("Content-Length" => bytes::length($content));
    $headers->authorization_basic($self->{id}, $self->{secret})    
        if($args{use_basic_schema});
    my $req = HTTP::Request->new( POST => $args{uri}, $headers, $content );

    my $res = $self->{agent}->request($req);
    $self->{last_request}  = $req;
    $self->{last_response} = $res;

    my ($token, $errmsg);
    try {
        $token = $self->{response_parser}->parse($res);
    } catch {
        $errmsg = "$_";
    };
    return $token || $self->error($errmsg);

}

=head2 get_server_state

Obtain L<OAuth::Lite2::Client::ServerState> object.

=cut

sub get_server_state {
    my $self = shift;

    my %args = Params::Validate::validate(@_, {
        uri           => { optional => 1 },
    });

    unless (exists $args{uri}) {
        $args{uri} = $self->{access_token_uri}
            || Carp::croak "uri not found";
    }

    my %params = (
        grant_type => 'server_state',
        client_id  => $self->{id},
    );

    my $content = build_content(\%params);
    my $headers = HTTP::Headers->new;
    $headers->header("Content-Type" => q{application/x-www-form-urlencoded});
    $headers->header("Content-Length" => bytes::length($content));
    my $req = HTTP::Request->new( POST => $args{uri}, $headers, $content );

    my $res = $self->{agent}->request($req);
    $self->{last_request}  = $req;
    $self->{last_response} = $res;

    my ($state, $errmsg);
    try {
        $state = $self->{state_response_parser}->parse($res);
    } catch {
        $errmsg = "$_";
    };
    return $state || $self->error($errmsg);

}

=head2 last_request

Returns a HTTP::Request object that is used
when you obtain or refresh access token last time internally.

=head2 last_request

Returns a HTTP::Response object that is used
when you obtain or refresh access token last time internally.

=cut

sub last_request  { $_[0]->{last_request}  }
sub last_response { $_[0]->{last_response} }

=head1 AUTHOR

Ryo Ito, E<lt>ritou.06@gmail.comE<gt>

Lyo Kato, E<lt>lyo.kato@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Lyo Kato

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
