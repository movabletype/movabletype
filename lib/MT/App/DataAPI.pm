# Movable Type (r) (C) 2001-2013 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::App::DataAPI;

use strict;
use base qw( MT::App );

use MT::DataAPI::Resource;
use MT::DataAPI::Format;
use MT::App::CMS::Common;
use MT::AccessToken;

our %endpoints = ();

sub id {'data_api'}

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->{template_dir} = 'data_api';
    $app->{default_mode} = 'api';
    $app;
}

sub core_methods {
    my $app = shift;
    return { 'api' => \&api, };
}

sub core_endpoints {
    my $app = shift;
    my $pkg = '$Core::MT::DataAPI::Endpoint::';
    return [
        {   id             => 'list_endpoints',
            route          => '/endpoints',
            version        => 1,
            handler        => "${pkg}Util::endpoints",
            requires_login => 0,
        },
        {   id             => 'authorize',
            route          => '/authorization',
            version        => 1,
            handler        => "${pkg}Auth::authorization",
            format         => 'html',
            requires_login => 0,
        },
        {   id             => 'authenticate',
            route          => '/authentication',
            verb           => 'POST',
            version        => 1,
            handler        => "${pkg}Auth::authentication",
            requires_login => 0,
        },
        {   id             => 'get_token',
            route          => '/token',
            verb           => 'POST',
            version        => 1,
            handler        => "${pkg}Auth::token",
            requires_login => 0,
        },
        {   id             => 'revoke_authentication',
            route          => '/authentication',
            verb           => 'DELETE',
            version        => 1,
            handler        => "${pkg}Auth::revoke_authentication",
            requires_login => 0,
        },
        {   id      => 'revoke_token',
            route   => '/token',
            verb    => 'DELETE',
            version => 1,
            handler => "${pkg}Auth::revoke_token",
        },
        {   id          => 'get_user',
            route       => '/users/:user_id',
            version     => 1,
            handler     => "${pkg}User::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested user.',
            },
            requires_login => 0,
        },
        {   id          => 'update_user',
            route       => '/users/:user_id',
            resources   => ['user'],
            verb        => 'PUT',
            version     => 1,
            handler     => "${pkg}User::update",
            error_codes => {
                403 => 'Do not have permission to update the requested user.',
            },
        },
        {   id             => 'list_blogs_for_user',
            route          => '/users/:user_id/sites',
            version        => 1,
            handler        => "${pkg}Blog::list",
            default_params => {
                limit     => 25,
                offset    => 0,
                sortBy    => 'name',
                sortOrder => 'ascend',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of blogs.',
            },
            requires_login => 0,
        },
        {   id          => 'get_blog',
            route       => '/sites/:blog_id',
            version     => 1,
            handler     => "${pkg}Blog::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested blog.',
            },
            requires_login => 0,
        },
        {   id             => 'list_entries',
            route          => '/sites/:site_id/entries',
            verb           => 'GET',
            version        => 1,
            handler        => "${pkg}Entry::list",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'authored_on',
                sortOrder    => 'descend',
                searchFields => 'title,body,more,keywords,excerpt,basename',
                filterKeys   => 'status',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested entries.',
            },
            requires_login => 0,
        },
        {   id        => 'create_entry',
            route     => '/sites/:site_id/entries',
            resources => ['entry'],
            verb      => 'POST',
            version   => 1,
            handler   => "${pkg}Entry::create",
            default_params => { save_revision => 1, },
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
            },
            requires_login => 0,
        },
        {   id        => 'update_entry',
            route     => '/sites/:site_id/entries/:entry_id',
            resources => ['entry'],
            verb      => 'PUT',
            version   => 1,
            handler   => "${pkg}Entry::update",
            default_params => { save_revision => 1, },
            error_codes =>
                { 403 => 'Do not have permission to update an entry.', },
        },
        {   id      => 'delete_entry',
            route   => '/sites/:site_id/entries/:entry_id',
            verb    => 'DELETE',
            version => 1,
            handler => "${pkg}Entry::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete an entry.', },
        },
        {   id             => 'list_categories',
            route          => '/sites/:site_id/categories',
            verb           => 'GET',
            version        => 1,
            handler        => "${pkg}Category::list",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'user_custom',
                sortOrder    => 'ascend',
                searchFields => 'label,basename',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of categories.',
            },
            requires_login => 0,
        },
        {   id             => 'list_comments',
            route          => '/sites/:site_id/comments',
            verb           => 'GET',
            version        => 1,
            handler        => "${pkg}Comment::list",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'body',
                filterKeys   => 'status,entryStatus',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of comments.',
            },
            requires_login => 0,
        },
        {   id             => 'list_comments_for_entry',
            route          => '/sites/:site_id/entries/:entry_id/comments',
            verb           => 'GET',
            version        => 1,
            handler        => "${pkg}Comment::list_for_entry",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'body',
                filterKeys   => 'status',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of comments.',
            },
            requires_login => 0,
        },
        {   id        => 'create_comment',
            route     => '/sites/:site_id/entries/:entry_id/comments',
            resources => ['comment'],
            verb      => 'POST',
            version   => 1,
            handler   => "${pkg}Comment::create",
            error_codes =>
                { 403 => 'Do not have permission to create a comment.', },
        },
        {   id => 'create_reply_comment',
            route =>
                '/sites/:site_id/entries/:entry_id/comments/:comment_id/replies',
            resources   => ['comment'],
            verb        => 'POST',
            version     => 1,
            handler     => "${pkg}Comment::create_reply",
            error_codes => {
                403 =>
                    'Do not have permission to create a reply to the requested comment.',
            },
        },
        {   id          => 'get_comment',
            route       => '/sites/:site_id/comments/:comment_id',
            version     => 1,
            handler     => "${pkg}Comment::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested comment.',
            },
            requires_login => 0,
        },
        {   id        => 'update_comment',
            route     => '/sites/:site_id/comments/:comment_id',
            resources => ['comment'],
            verb      => 'PUT',
            version   => 1,
            handler   => "${pkg}Comment::update",
            error_codes =>
                { 403 => 'Do not have permission to update a comment.', },
        },
        {   id      => 'delete_comment',
            route   => '/sites/:site_id/comments/:comment_id',
            verb    => 'DELETE',
            version => 1,
            handler => "${pkg}Comment::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete a comment.', },
        },
        {   id             => 'list_trackbacks',
            route          => '/sites/:site_id/trackbacks',
            verb           => 'GET',
            version        => 1,
            handler        => "${pkg}Trackback::list",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'title,excerpt,blogName',
                filterKeys   => 'status',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of trackbacks.',
            },
            requires_login => 0,
        },
        {   id             => 'list_trackbacks_for_entry',
            route          => '/sites/:site_id/entries/:entry_id/trackbacks',
            verb           => 'GET',
            version        => 1,
            handler        => "${pkg}Trackback::list_for_entry",
            default_params => {
                limit        => 10,
                offset       => 0,
                sortBy       => 'id',
                sortOrder    => 'descend',
                searchFields => 'title,excerpt,blogName',
                filterKeys   => 'status',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the list of trackbacks.',
            },
            requires_login => 0,
        },
        {   id          => 'get_trackback',
            route       => '/sites/:site_id/trackbacks/:ping_id',
            version     => 1,
            handler     => "${pkg}Trackback::get",
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested trackback.',
            },
            requires_login => 0,
        },
        {   id        => 'update_trackback',
            route     => '/sites/:site_id/trackbacks/:ping_id',
            resources => ['trackback'],
            verb      => 'PUT',
            version   => 1,
            handler   => "${pkg}Trackback::update",
            error_codes =>
                { 403 => 'Do not have permission to update a trackback.', },
        },
        {   id      => 'delete_trackback',
            route   => '/sites/:site_id/trackbacks/:ping_id',
            verb    => 'DELETE',
            version => 1,
            handler => "${pkg}Trackback::delete",
            error_codes =>
                { 403 => 'Do not have permission to delete a trackback.', },
        },
        {   id             => 'upload_asset',
            route          => '/sites/:site_id/assets/upload',
            verb           => 'POST',
            version        => 1,
            handler        => "${pkg}Asset::upload",
            default_params => {
                autoRenameIfExists   => 0,
                normalizeOrientation => 1,
            },
            error_codes => { 403 => 'Do not have permission to upload.', },
        },
        {   id             => 'list_permissions_for_user',
            route          => '/users/:user_id/permissions',
            version        => 1,
            handler        => "${pkg}Permission::list",
            default_params => {
                limit      => 25,
                offset     => 0,
                sortBy     => 'blog_id',
                sortOrder  => 'ascend',
                filterKeys => 'blogIds',
            },
            error_codes => {
                403 =>
                    'Do not have permission to retrieve the requested user\'s permissions.',
            },
        },
        {   id      => 'publish_entries',
            route   => '/publish/entries',
            verb    => 'GET',
            version => 1,
            handler => "${pkg}Publish::entries",
            error_codes => { 403 => 'Do not have permission to publish.', },
        },
        {   id      => 'get_stats_provider',
            route   => '/sites/:site_id/stats/provider',
            version => 1,
            handler => "${pkg}Stats::provider",
        },
        {   id      => 'list_stats_pageviews_for_path',
            route   => '/sites/:site_id/stats/path/pageviews',
            version => 1,
            handler => "${pkg}Stats::pageviews_for_path",
        },
        {   id      => 'list_stats_visits_for_path',
            route   => '/sites/:site_id/stats/path/visits',
            version => 1,
            handler => "${pkg}Stats::visits_for_path",
        },
        {   id      => 'list_stats_pageviews_for_date',
            route   => '/sites/:site_id/stats/date/pageviews',
            version => 1,
            handler => "${pkg}Stats::pageviews_for_date",
        },
        {   id      => 'list_stats_visits_for_date',
            route   => '/sites/:site_id/stats/date/visits',
            version => 1,
            handler => "${pkg}Stats::visits_for_date",
        },
    ];
}

sub init_plugins {
    my $app = shift;

    # This has to be done prior to plugin initialization since we
    # may have plugins that register themselves using some of the
    # older callback names. The callback aliases are declared
    # in init_core_callbacks.
    MT::App::CMS::Common::init_core_callbacks($app);

    my $pkg = $app->id . '_';
    my $pfx = '$Core::MT::DataAPI::Callback::';
    $app->_register_core_callbacks(
        {
            # entry callbacks
            $pkg
                . 'pre_load_filtered_list.entry' =>
                "${pfx}Entry::cms_pre_load_filtered_list",
            $pkg . 'list_permission_filter.entry' => "${pfx}Entry::can_list",
            $pkg . 'view_permission_filter.entry' => "${pfx}Entry::can_view",

            # user callbacks
            $pkg . 'view_permission_filter.author' => "${pfx}User::can_view",

            # comment callbacks
            $pkg
                . 'view_permission_filter.comment' =>
                "${pfx}Comment::can_view",
            $pkg
                . 'pre_load_filtered_list.comment' =>
                "${pfx}Comment::cms_pre_load_filtered_list",

            # ping callbacks
            $pkg
                . 'view_permission_filter.ping' =>
                "${pfx}Trackback::can_view",
            $pkg
                . 'pre_load_filtered_list.ping' =>
                "${pfx}Trackback::cms_pre_load_filtered_list",

            # permission callbacks
            $pkg
                . 'pre_load_filtered_list.permission' =>
                "${pfx}Permission::cms_pre_load_filtered_list",
            $pkg
                . 'list_permission_filter.permission' =>
                "${pfx}Permission::can_list",
        }
    );

    $app->SUPER::init_plugins(@_);
}

sub _compile_endpoints {
    my ( $app, $version ) = @_;

    my %hash = ();
    my %tree = ();
    my @list = ();

    my @components = MT::Component->select();
    for my $c (@components) {
        my $endpoints
            = $c->registry( 'applications', 'data_api', 'endpoints' );
        next unless defined $endpoints;

        foreach my $e (@$endpoints) {
            $e->{component} = $c;
            $e->{id}          ||= $e->{route};
            $e->{version}     ||= 1;
            $e->{verb}        ||= 'GET';
            $e->{error_codes} ||= {};

            if ( !exists( $e->{requires_login} ) ) {
                $e->{requires_login} = 1;
            }
            $e->{_vars} = [];

            next if $e->{version} > $version;

            my $cur = \%tree;
            ( my $route = $e->{route} ) =~ s#^/+##;
            foreach my $p ( split m#(?=/|\.)|(?<=/|\.)#o, $route ) {
                if ( $p =~ /^:([a-zA-Z_-]+)/ ) {
                    $cur = $cur->{':v'} ||= {};
                    push @{ $e->{_vars} }, $1;
                }
                else {
                    $cur = $cur->{$p} ||= {};
                }
            }

            $cur->{':e'} ||= {};
            if (  !$cur->{':e'}{ lc $e->{verb} }
                || $cur->{':e'}{ lc $e->{verb} }{version} < $e->{version} )
            {
                $cur->{':e'}{ lc $e->{verb} } = $e;
            }

            $hash{ $e->{id} } = $e;
            push @list, $e;
        }
    }

    +{  hash => \%hash,
        tree => \%tree,
        list => \@list,
    };
}

sub endpoints {
    my ( $app, $version ) = @_;
    $endpoints{$version} ||= $app->_compile_endpoints($version);
}

sub current_endpoint {
    my $app = shift;
    $app->request( 'data_api_current_endpoint', @_ ? $_[0] : () );
}

sub current_api_version {
    my $app = shift;
    $app->request( 'data_api_current_version', @_ ? $_[0] : () );
}

sub find_endpoint_by_id {
    my ( $app, $version, $id ) = @_;
    $app->endpoints($version)->{hash}{$id};
}

sub endpoint_url {
    my ( $app, $endpoint, $params ) = @_;
    $endpoint = $app->find_endpoint_by_id($endpoint) unless ref $endpoint;
    return '' unless $endpoint;

    my $replace = sub {
        my ( $whole, $key ) = @_;
        if ( exists $params->{$key} ) {
            my $v = delete $params->{$key};
            $v->can('id') ? $v->id : $v;
        }
        else {
            $whole;
        }
    };

    my $url = $endpoint->{route};
    $url =~ s{(?:(?<=^)|(?<=/|\.))(:([a-zA-Z_-]+))}{$replace->($1, $2)}ge;

    $url . $app->uri_params( args => $params );
}

sub find_endpoint_by_path {
    my ( $app, $verb, $version, $path ) = @_;
    $verb = lc($verb);

    my $endpoints = $app->endpoints($version)->{tree};

    my $handler     = $endpoints;
    my @vars        = ();
    my $auto_format = '';

    $path =~ s#^/+##;
    my @paths = split m#(?=/|\.)|(?<=/|\.)#o, $path;
    while ( my $p = shift @paths ) {
        if ( $handler->{$p} ) {
            $handler = $handler->{$p};
        }
        elsif ( $handler->{':v'} ) {
            $handler = $handler->{':v'};
            push @vars, $p;
        }
        elsif ( $p eq '.' && scalar(@paths) == 1 ) {
            $auto_format = shift @paths;
        }
        else {
            return;
        }
    }

    my $e = $handler->{':e'}{$verb}
        or return;

    my %params = ();
    for ( my $i = 0; $i < scalar( @{ $e->{_vars} } ); $i++ ) {
        $params{ $e->{_vars}[$i] } = $vars[$i];
    }
    $params{format} = $auto_format if $auto_format && !$e->{format};

    $e, \%params;
}

sub current_format {
    my ($app) = @_;
    MT::DataAPI::Format->find_format;
}

sub current_error_format {
    my ($app) = @_;
    my $format = $app->current_format;
    if ( my $invoke = $format->{error_format} ) {
        $format = MT::DataAPI::Format->find_format($invoke);
    }
    $format;
}

sub _request_method {
    my ($app) = @_;
    my $method = lc $app->request_method;
    if ( my $m = $app->param('__method') ) {
        if ( $method eq 'post' || $method eq lc $m ) {
            $method = lc $m;
        }
        else {
            return $app->print_error(
                "Request method is not '$m' or 'POST' with '__method=$m'",
                405 );
        }
    }
    $method;
}

sub _path {
    my ($app) = @_;
    my $path = $app->path_info;
    $path =~ s{.+(?=/v\d+/)}{};
    $path;
}

sub resource_object {
    my ( $app, $name, $original ) = @_;

    my $data_text = $app->param($name)
        or return $app->error( qq{A resource "$name" is required.}, 400 );

    my $data = $app->current_format->{unserialize}->($data_text)
        or return $app->error( 'Invalid data format: ' . $name, 400 );

    my $obj = MT::DataAPI::Resource->to_object( $name, $data, $original );
    return $app->error( 'Failed to convert to the object: ' . $obj->errstr,
        400 )
        if ( $obj->errstr );

    $obj;
}

sub object_to_resource {
    my ( $app, $res, $fields ) = @_;
    my $ref = ref $res;

    if ( UNIVERSAL::can( $res, 'to_resource' ) ) {
        $res->to_resource($fields);
    }
    elsif ( UNIVERSAL::isa( $res, 'MT::Object' )
        || $ref eq 'MT::DataAPI::Resource::Type::ObjectList' )
    {
        MT::DataAPI::Resource->from_object( $res, $fields );
    }
    elsif ( $ref eq 'MT::DataAPI::Resource::Type::Raw' ) {
        $res->content;
    }
    elsif ( $ref eq 'HASH' ) {
        my %result = ();
        foreach my $k ( keys %$res ) {
            $result{$k} = $app->object_to_resource( $res->{$k}, $fields );
        }
        \%result;
    }
    elsif ( $ref eq 'ARRAY' ) {
        [ map { $app->object_to_resource( $_, $fields ) } @$res ];
    }
    else {
        $res;
    }
}

sub mt_authorization_data {
    my ($app) = @_;

    my $header
        = $app->get_header('X-MT-Authorization')
        || ( lc $app->request_method eq 'post'
        && $app->param('X-MT-Authorization') )
        or return undef;

    my %values = ();

    $header =~ s/\A\s+|\s+\z//g;

    my ( $type, $rest ) = split /\s+/, $header, 2;
    return undef unless $type;

    $values{$type} = {};

    while ( $rest =~ m/(\w+)=(?:("|')([^\2]*)\2|([^\s,]*))/g ) {
        $values{$type}{$1} = defined($3) ? $3 : $4;
    }

    \%values;
}

sub authenticate {
    my ($app) = @_;

    my $data = $app->mt_authorization_data;
    return MT::Author->anonymous
        unless $data
        && exists $data->{MTAuth}{accessToken};

    my $session
        = MT::AccessToken->load_session( $data->{MTAuth}{accessToken} || '' )
        or return undef;
    my $user = $app->model('author')->load( $session->get('author_id') )
        or return undef;

    return undef unless $user->is_active;

    $app->{session} = $session;

    $user;
}

sub current_client_id {
    my ($app) = @_;

    my $client_id = $app->request('data_api_current_client_id');
    return $client_id if defined $client_id;

    $client_id = $app->param('clientId') || '';
    $client_id = '' if $client_id !~ m/\A[\w-]+\z/;
    $app->request( 'data_api_current_client_id', $client_id );
}

sub user_cookie {
    my ($app) = @_;
    'mt_data_api_user_' . $app->current_client_id;
}

sub session_kind {
    'DS';    # DS == DataAPI Session
}

sub make_session {
    my ( $app, $auth, $remember ) = @_;
    require MT::Session;
    my $sess = new MT::Session;
    $sess->id( $app->make_magic_token() );
    $sess->kind( $app->session_kind );
    $sess->start(time);
    $sess->set( 'author_id', $auth->id );
    $sess->set( 'client_id', $app->current_client_id );
    $sess->set( 'remember',  1 ) if $remember;
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

sub purge_session_records {
    my $class = shift;

    require MT::Session;

    # remove expired user sessions
    MT::Core::purge_user_session_records( $class->session_kind,
        MT->config->UserSessionTimeout );

    # remove expired access tokens
    MT::AccessToken->purge;

    return '';
}

sub send_http_header {
    my $app = shift;

    $app->set_header( 'X-Content-Type', 'nosniff' );

    return $app->SUPER::send_http_header(@_);
}

sub error {
    my $app  = shift;
    my @args = @_;

    if ( $_[0] && ( $_[0] =~ m/\A\d{3}\z/ || $_[1] ) ) {
        my ( $message, $code, $data ) = do {
            if ( scalar(@_) >= 2 ) {
                @_;
            }
            else {
                ( '', $_[0], undef );
            }
        };
        $app->request(
            'data_api_error_detail',
            {   code    => $code,
                message => $message,
                data    => $data,
            }
        );
        @args = join( ' ', reverse(@_) );
    }

    return $app->SUPER::error(@args);
}

sub print_error {
    my ( $app, $message, $status, $data ) = @_;

    if ( !$status && $message =~ m/\A\d{3}\z/ ) {
        $status  = $message;
        $message = '';
    }
    if ( !$message && $status ) {
        require HTTP::Status;
        $message = HTTP::Status::status_message($status);
    }

    my $format = $app->current_error_format;

    if ( $app->requires_plain_text_result ) {
        $app->response_code(200);
        $app->send_http_header('text/plain');
    }
    else {
        $app->response_code($status);
        $app->send_http_header( $format->{mime_type} );
    }
    $app->{no_print_body} = 1;
    $app->print_encode(
        $format->{serialize}->(
            {   error => {
                    code    => $status + 0,
                    message => $message,
                    ( $data ? ( data => $data ) : () ),
                }
            }
        )
    );

    return undef;
}

sub show_error {
    my $app      = shift;
    my ($param)  = @_;
    my $endpoint = $app->current_endpoint;
    my $error    = $app->request('data_api_error_detail');

    return $app->SUPER::show_error(@_)
        if !$endpoint || ( !$error && $endpoint->{format} eq 'html' );

    if ( !$error ) {
        $error = {
            code => $param->{status} || 500,
            message => $param->{error},
        };
    }

    return $app->print_error( $error->{message}
            || $endpoint->{error_codes}{ $error->{code} },
        $error->{code}, $error->{data} );
}

sub publish_error {
    require MT::App::CMS;
    MT::App::CMS::publish_error(@_);
}

sub permission_denied {
    my $app = shift;
    return $app->error(403);
}

sub set_next_phase_url {
    my $app = shift;
    my ($url) = @_;
    $app->set_header( 'X-MT-Next-Phase-URL', $url );
}

sub requires_plain_text_result {
    my $app = shift;
    lc $app->request_method eq 'post'
        && lc( $app->param('X-MT-Requested-Via') || '' ) eq 'iframe';
}

sub load_default_entry_prefs {
    return q();
}

sub load_default_page_prefs {
    return q();
}

sub api {
    my ($app) = @_;
    my $path = $app->_path;

    my ($version) = ( $path =~ s{\A/?v(\d+)}{} );
    return $app->print_error( 'API Version is required', 400 )
        unless defined($version);

    my $request_method = $app->_request_method
        or return;
    my ( $endpoint, $params )
        = $app->find_endpoint_by_path( $request_method, $version, $path )
        or return $app->print_error( 'Unknown endpoint', 404 );
    my $user = $app->authenticate;

    if ( !$user || ( $endpoint->{requires_login} && $user->is_anonymous ) ) {
        return $app->print_error( 'Unauthorized', 401 );
    }
    $user ||= MT::Author->anonymous;
    $app->user($user);
    $app->permissions(undef);

    if ( my $id = $params->{site_id} ) {
        $app->blog( scalar $app->model('blog')->load($id) )
            or return $app->print_error( 'Site not found', 404 );
        $app->param( 'blog_id', $id );

        $app->permissions( $user->permissions($id) )
            unless $user->is_anonymous;
    }
    else {
        $app->param( 'blog_id', undef );
    }

    foreach my $k (%$params) {
        $app->param( $k, $params->{$k} );
    }
    if ( my $default_params = $endpoint->{default_params} ) {
        my $request_param = $app->param->Vars;
        foreach my $k (%$default_params) {
            if ( !exists( $request_param->{$k} ) ) {
                $app->param( $k, $default_params->{$k} );
            }
        }
    }

    $endpoint->{handler_ref}
        ||= $app->handler_to_coderef( $endpoint->{handler} )
        or return $app->print_error( 'Unknown endpoint', 404 );

    $app->current_endpoint($endpoint);
    $app->current_api_version($version);

    $app->run_callbacks( 'pre_run_data_api.' . $endpoint->{id},
        $app, $endpoint );
    my $response = $endpoint->{handler_ref}->( $app, $endpoint );
    $app->run_callbacks( 'post_run_data_api.' . $endpoint->{id},
        $app, $endpoint, $response );

    my $response_ref = ref $response;

    if (   UNIVERSAL::isa( $response, 'MT::Object' )
        || $response_ref =~ m/\A(?:HASH|ARRAY|MT::DataAPI::Resource::Type::)/
        || UNIVERSAL::can( $response, 'to_resource' ) )
    {
        my $format   = $app->current_format;
        my $fields   = $app->param('fields') || '';
        my $resource = $app->object_to_resource( $response,
            $fields ? [ split ',', $fields ] : undef );
        my $data = $format->{serialize}->($resource);

        if ( $app->requires_plain_text_result ) {
            $app->send_http_header('text/plain');
        }
        else {
            $app->send_http_header( $format->{mime_type} );
        }

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

MT::App::DataAPI

=head1 SYNOPSIS

The I<MT::App::DataAPI> module is the application module for providing Data API.
This module provide the REST interface that is used to
manage blogs, entries, comments, trackbacks, templates, etc.

=cut
