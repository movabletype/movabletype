# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::App::API;

use strict;
use base qw( MT::App );

use MT::API::Resource;
use MT::App::CMS::Common;

our ( %endpoints, %resources ) = ();

sub id {'api'}

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->{template_dir} = 'api';
    $app->{default_mode} = 'api';
    $app;
}

sub core_methods {
    my $app = shift;
    return { 'api' => \&api, };
}

sub core_endpoints {
    my $app = shift;
    my $pkg = '$Core::MT::API::Endpoint::';
    return [
        {   id             => 'authorization',
            route          => '/authorization',
            version        => 1,
            handler        => "${pkg}Auth::authorization",
            format         => 'html',
            requires_login => 0,
        },
        {   id             => 'authentication',
            route          => '/authentication',
            method         => 'POST',
            version        => 1,
            handler        => "${pkg}Auth::authentication",
            requires_login => 0,
        },
        {   id             => 'token',
            route          => '/token',
            version        => 1,
            handler        => "${pkg}Auth::token",
            requires_login => 0,
        },
        {   id          => 'get_user',
            route       => '/users/:user_id',
            version     => 1,
            handler     => "${pkg}User::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested user.',
            },
        },
        {   id          => 'update_user',
            route       => '/users/:user_id',
            resources   => ['user'],
            method      => 'PUT',
            version     => 1,
            handler     => "${pkg}User::update",
            error_codes => {
                403 => 'Do not have permission to update the requested user.',
            },
        },
        {   id          => 'list_blogs',
            route       => '/users/:user_id/sites',
            version     => 1,
            handler     => "${pkg}Blog::list",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of blogs.',
            },
        },
        {   id      => 'list_entries',
            route   => '/sites/:site_id/entries',
            method  => 'GET',
            version => 1,
            handler => "${pkg}Entry::list",
            param   => {
                limit      => 10,
                offset     => 0,
                sort_by    => 'authored_on',
                sort_order => 'descend',
                search_fields =>
                    'title,text,text_more,keywords,excerpt,basename',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of entries.',
            },
        },
        {   id        => 'create_entry',
            route     => '/sites/:site_id/entries',
            resources => ['entry'],
            method    => 'POST',
            version   => 1,
            handler   => "${pkg}Entry::create",
            error_codes =>
                { 403 => 'Do not have permission to create an entry.', },
        },
        {   id          => 'get_entry',
            route       => '/sites/:site_id/entries/:entry_id',
            version     => 1,
            handler     => "${pkg}Entry::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested entry.',
            }
        },
        {   id        => 'update_entry',
            route     => '/sites/:site_id/entries/:entry_id',
            resources => ['entry'],
            method    => 'PUT',
            version   => 1,
            handler   => "${pkg}Entry::update",
            error_codes =>
                { 403 => 'Do not have permission to update an entry.', }
        },
        {   id      => 'delete_entry',
            route   => '/sites/:site_id/entries/:entry_id',
            method  => 'DELETE',
            version => 1,
            handler => "${pkg}Entry::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete an entry.', }
        },
    ];
}

sub core_resources {
    my $app = shift;
    my $pkg = '$Core::MT::API::Resource::';
    return {
        'entry' => {
            fields           => "${pkg}Entry::fields",
            updatable_fields => "${pkg}Entry::updatable_fields",
        },
        'comment' => {
            fields           => "${pkg}Comment::fields",
            updatable_fields => "${pkg}Comment::updatable_fields",
        },
        'user' => {
            fields           => "${pkg}User::fields",
            updatable_fields => "${pkg}User::updatable_fields",
        },
        'author' => 'user',
        'blog'   => {
            fields           => "${pkg}Blog::fields",
            updatable_fields => "${pkg}Blog::updatable_fields",
        },
        'website' => {
            fields           => "${pkg}Website::fields",
            updatable_fields => "${pkg}Website::updatable_fields",
        },
    };
}

sub init_plugins {
    my $app = shift;

    # This has to be done prior to plugin initialization since we
    # may have plugins that register themselves using some of the
    # older callback names. The callback aliases are declared
    # in init_core_callbacks.
    MT::App::CMS::Common::init_core_callbacks($app);
    $app->SUPER::init_plugins(@_);
}

sub _compile_endpoints {
    my ( $app, $version ) = @_;

    my %tree = ();
    my $endpoints_list = $app->registry( 'applications', 'api', 'endpoints' );
    foreach my $endpoints (@$endpoints_list) {
        foreach my $e (@$endpoints) {
            $e->{id}          ||= $e->{route};
            $e->{version}     ||= 1;
            $e->{method}      ||= 'GET';
            $e->{format}      ||= 'json';
            $e->{error_codes} ||= {};

            if ( !exists( $e->{requires_login} ) ) {
                $e->{requires_login} = 1;
            }
            $e->{_vars} = [];

            next if $e->{version} > $version;

            my $cur = \%tree;
            foreach my $p ( split /\//o, $e->{route} ) {
                next unless $p;
                foreach my $s ( split /\./o, $p ) {
                    if ( $s =~ /^:([a-zA-Z_-]+)/ ) {
                        $cur = $cur->{':v'} ||= {};
                        push @{ $e->{_vars} }, $1;
                    }
                    else {
                        $cur = $cur->{$s} ||= {};
                    }
                }
            }

            $cur->{':e'} ||= {};
            if (  !$cur->{':e'}{ lc $e->{method} }
                || $cur->{':e'}{ lc $e->{method} }{version} < $e->{version} )
            {
                $cur->{':e'}{ lc $e->{method} } = $e;
            }
        }
    }

    \%tree;
}

sub endpoints {
    my ( $app, $version, $path ) = @_;
    $endpoints{$version} ||= $app->_compile_endpoints($version);
}

sub _endpoint {
    my ( $app, $method, $version, $path ) = @_;

    my $endpoints = $app->endpoints($version);

    my $handler = $endpoints;
    my @vars    = ();
    foreach my $p ( split /\//, $path ) {
        next unless $p;
        foreach my $s ( split /\./, $p ) {
            if ( $handler->{$s} ) {
                $handler = $handler->{$s};
            }
            elsif ( $handler->{':v'} ) {
                $handler = $handler->{':v'};
                push @vars, $s;
            }
        }
    }

    my $e      = $handler->{':e'}{ lc $method };
    my %params = ();
    if ($e) {
        for ( my $i = 0; $i < scalar( @{ $e->{_vars} } ); $i++ ) {
            $params{ $e->{_vars}[$i] } = $vars[$i];
        }
    }

    $e, \%params;
}

sub _request_method {
    my ($app) = @_;
    my $method = lc $ENV{REQUEST_METHOD};
    if ( $method eq 'post' && ( my $m = $app->param('__method') ) ) {
        $method = lc $m;
    }
    $method;
}

sub _path {
    my ($app) = @_;
    my $path = $ENV{PATH_INFO};
    $path =~ s{.+(?=/v\d+/)}{};
    $path;
}

sub resource {
    my ( $app, $key ) = @_;

    if ( !%resources ) {
        my $reg = $app->registry( 'applications', 'api', 'resources' );
        %resources
            = map { $_ => ref( $reg->{$_} ) ? +{} : $reg->{$_} } keys %$reg;
    }

    my $res;
    my $resource_key;
    for my $k (
        ref $key
        ? ( $key->class_type || '',
            $key->datasource . '.' . ( $key->class_type || '' ),
            $key->datasource
        )
        : ($key)
        )
    {

        $resource_key = $k;
        $res = $resources{$k} and last;
    }

    return unless $res;

    if ( !ref $res ) {
        $resources{$resource_key} = $res = $app->resource($res);
    }

    return unless $res;

    if ( !$res->{fields} ) {
        for my $k (qw(fields updatable_fields)) {
            $res->{$k} = [
                map {@$_} @{
                    $app->registry(
                        'applications', 'api',
                        'resources',    $resource_key,
                        $k
                    )
                    }
            ];
        }
    }

    $res;
}

sub resource_object {
    my ( $app, $name, $original ) = @_;

    my $json_text = $app->param($name)
        or return undef;

    # TODO if error
    my $data = MT::Util::from_json($json_text);

    MT::API::Resource->to_object( $app, $name, $data, $original );
}

sub convert_object {
    my ( $app, $res, $fields ) = @_;
    my $ref = ref $res;

    if ( UNIVERSAL::isa( $res, 'MT::Object' ) ) {

        # TODO if resource class is not found
        MT::API::Resource->from_object( $app, $res, $fields );
    }
    elsif ( $ref eq 'HASH' ) {
        my %result = ();
        foreach my $k ( keys %$res ) {
            $result{$k} = $app->convert_object( $res->{$k}, $fields );
        }
        \%result;
    }
    elsif ( $ref eq 'ARRAY' ) {
        [ map { $app->convert_object( $_, $fields ) } @$res ];
    }
    else {
        $res;
    }
}

sub _encode_json {
    my ( $app, $res ) = @_;
    my $obj = $app->convert_object( $res, $app->param('fields') || '' );
    MT::Util::to_json( $obj, { ascii => 1 } );
}

sub authenticate {
    my ($app) = @_;

    my $header = $app->get_header('X-MT-Authorization')
        or undef;

    if ( $header =~ m/\A\s*MTAuth\s+access_token=(\w+)/ ) {
        my $token = $1;
        require MT::AccessToken;
        my $session = MT::AccessToken->load_session($token)
            or return undef;
        return $app->model('author')->load( $session->get('author_id') );
    }

    undef;
}

sub user_cookie {
    'mt_api_user';
}

sub session_kind {
    'PS';    # PS == API Session
}

sub make_session {
    my ( $app, $auth, $remember ) = @_;
    require MT::Session;
    my $sess = new MT::Session;
    $sess->id( $app->make_magic_token() );
    $sess->kind( $app->session_kind );
    $sess->start(time);
    $sess->set( 'author_id', $auth->id );
    $sess->set( 'remember', 1 ) if $remember;
    $sess->save;
    $sess;
}

sub session_user {
    my $app = shift;
    my ( $author, $session_id, %opt ) = @_;
    return undef unless $author && $session_id;
    if ( $app->{session} ) {
        if ( $app->{session}->get('author_id') == $author->id ) {
            return $author;
        }
    }

    require MT::Session;
    my $timeout
        = $opt{permanent}
        ? ( 360 * 24 * 365 * 10 )
        : $app->config->UserSessionTimeout;
    my $sess = MT::Session::get_unexpired_value(
        $timeout,
        {   id   => $session_id,
            kind => $app->session_kind,
        }
    );
    $app->{session} = $sess;

    return undef if !$sess;
    if ( $sess && ( $sess->get('author_id') == $author->id ) ) {
        return $author;
    }
    else {
        return undef;
    }
}

sub start_session {
    my $app = shift;
    my ( $user, $remember ) = @_;
    if ( !defined $user ) {
        $user = $app->user;
        my ( $x, $y );
        ( $x, $y, $remember )
            = split( /::/, $app->cookie_val( $app->user_cookie ) );
    }
    my $session = $app->make_session( $user, $remember );
    $app->{session} = $session;
}

sub error {
    my $app  = shift;
    my @args = @_;

    if ( $_[0] && ( $_[0] =~ m/\A\d{3}\z/ || $_[1] ) ) {
        my ( $message, $code ) = do {
            if ( scalar(@_) == 2 ) {
                @_;
            }
            else {
                ( '', $_[0] );
            }
        };
        $app->request(
            'api_error_detail',
            {   code    => $code,
                message => $message,
            }
        );
        @args = join( ' ', reverse(@_) );
    }

    return $app->SUPER::error(@args);
}

sub json_error {
    my ( $app, $message, $status ) = @_;

    if ( !$status && $message =~ m/\A\d{3}\z/ ) {
        $status  = $message;
        $message = '';
    }
    if ( !$message && $status ) {
        require HTTP::Status;
        $message = HTTP::Status::status_message($status);
    }

    $app->response_code($status);
    $app->send_http_header('application/json');
    $app->{no_print_body} = 1;
    $app->print_encode(
        MT::Util::to_json(
            {   error => {
                    message => $message,
                    code    => $status,
                }
            }
        )
    );
    return undef;
}

sub show_error {
    my $app = shift;
    my ($param) = @_;

    my $endpoint = $app->request('api_current_endpoint');
    my $error    = $app->request('api_error_detail');

    return $app->SUPER::show_error(@_) if !$endpoint || !$error;

    return $app->json_error( $error->{message}
            || $endpoint->{error_codes}{ $error->{code} },
        $error->{code} );
}

sub api_version {
    my ( $app, $version ) = @_;
    if ( defined($version) ) {
        $app->request( 'api_version', $version );
    }
    else {
        $app->request('api_version');
    }
}

sub api {
    my ($app) = @_;
    my $path = $app->_path;

    my ($version) = ( $path =~ s{\A/?v(\d+)}{} );
    return $app->json_error( 'API Version is required', 400 )
        unless defined($version);
    $app->api_version($version);

    my ( $endpoint, $params )
        = $app->_endpoint( $app->_request_method, $version, $path )
        or return $app->json_error( 'Unknown endpoint', 404 );
    my $user = $app->authenticate;

    if ( $endpoint->{requires_login} && !$user ) {
        return $app->json_error( 'Unauthorized', 401 );
    }
    $app->user($user);

    if ( my $id = $params->{site_id} ) {
        $app->blog( scalar $app->model('blog')->load($id) )
            or return $app->json_error( 'Site not found', 404 );
        $app->param( 'blog_id', $id );
    }

    foreach my $k (%$params) {
        $app->param( $k, $params->{$k} );
    }
    if ( my $default_param = $endpoint->{param} ) {
        my $request_param = $app->param->Vars;
        foreach my $k (%$default_param) {
            if ( !exists( $request_param->{$k} ) ) {
                $app->param( $k, $default_param->{$k} );
            }
        }
    }

    my $code = $app->handler_to_coderef( $endpoint->{handler} )
        or return $app->json_error( 'Unknown endpoint', 404 );

    $app->request( 'api_current_endpoint', $endpoint );
    $app->run_callbacks( 'pre_run_api.' . $endpoint->{id}, $app, $endpoint );
    my $response = $code->( $app, $endpoint );
    $app->run_callbacks( 'post_run_api.' . $endpoint->{id},
        $app, $endpoint, $response );

    if ( UNIVERSAL::isa( $response, 'MT::Template' ) ) {
        $response;
    }
    elsif (ref $response eq 'HASH'
        || ref $response eq 'ARRAY'
        || UNIVERSAL::isa( $response, 'MT::Object' ) )
    {
        my $data = $app->_encode_json($response);
        $app->send_http_header('application/json');
        $app->{no_print_body} = 1;
        $app->print_encode($data);
        undef;
    }
    else {
        $response;
    }
}

1;
__END__

=head1 NAME

MT::App::CMS

=head1 SYNOPSIS

The I<MT::App::CMS> module is the primary application module for
Movable Type. It is the administrative interface that is used to
manage blogs, entries, comments, trackbacks, templates, etc.

=cut
