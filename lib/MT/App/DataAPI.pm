# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::App::DataAPI;

use strict;
use warnings;
use base qw( MT::App );

use MT::DataAPI::Endpoint::v1;
use MT::DataAPI::Endpoint::v2;
use MT::DataAPI::Endpoint::v3;
use MT::DataAPI::Endpoint::v4;
use MT::DataAPI::Endpoint::v5;
use MT::DataAPI::Resource;
use MT::DataAPI::Format;
use MT::App::CMS;
use MT::App::CMS::Common;
use MT::App::Search;
use MT::App::Search::Common;
use MT::AccessToken;

our %endpoints = ();
our %schemas   = ();

sub id                 {'data_api'}
sub DEFAULT_VERSION () {5}
sub API_VERSION ()     {5.0}

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
    return [{
            id              => 'openapi',
            route           => '/',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::OpenAPI::build_schema',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::OpenAPI::openapi_spec',
            requires_login  => 0,
        },
        {
            id              => 'version',
            route           => '/version',
            version         => 1,
            requires_login  => 0,
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Version::version_openapi_spec',
        },
        {
            id              => 'list_endpoints',
            route           => '/endpoints',
            version         => 1,
            handler         => '$Core::MT::DataAPI::Endpoint::Util::endpoints',
            openapi_handler => '$Core::MT::DataAPI::Endpoint::Util::endpoints_openapi_spec',
            requires_login  => 0,
        },
        @{ MT::DataAPI::Endpoint::v1->endpoints },
        @{ MT::DataAPI::Endpoint::v2->endpoints },
        @{ MT::DataAPI::Endpoint::v3->endpoints },
        @{ MT::DataAPI::Endpoint::v4->endpoints },
        @{ MT::DataAPI::Endpoint::v5->endpoints },
    ];
}

sub init_plugins {
    my $app = shift;

    # This has to be done prior to plugin initialization since we
    # may have plugins that register themselves using some of the
    # older callback names. The callback aliases are declared
    # in init_core_callbacks.
    MT::App::CMS::Common::init_core_callbacks($app);
    MT::App::Search::Common::init_core_callbacks($app);

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
            $pkg . 'save_filter.entry' => "${pfx}Entry::save_filter",

            # page callbacks
            $pkg
                . 'pre_load_filtered_list.page' =>
                "${pfx}Page::cms_pre_load_filtered_list",
            $pkg . 'list_permission_filter.page' => "${pfx}Page::can_list",
            $pkg . 'view_permission_filter.page' => "${pfx}Page::can_view",
            $pkg . 'save_filter.page'            => "${pfx}Page::save_filter",

            # user callbacks
            $pkg
                . 'pre_load_filtered_list.author' =>
                "${pfx}User::pre_load_filtered_list",
            $pkg . 'view_permission_filter.author' => "${pfx}User::can_view",
            $pkg . 'save_filter.author' => "${pfx}User::save_filter",

            # permission callbacks
            $pkg
                . 'pre_load_filtered_list.permission' =>
                "${pfx}Permission::cms_pre_load_filtered_list",
            $pkg
                . 'list_permission_filter.permission' =>
                "${pfx}Permission::can_list",

            # category callbacks
            $pkg
                . 'view_permission_filter.category' =>
                "${pfx}Category::can_view",
            $pkg . 'save_filter.category' => "${pfx}Category::save_filter",
            $pkg
                . 'save_permission_filter.category' =>
                "${pfx}Category::can_save",

            # folder callbacks
            $pkg
                . 'view_permission_filter.folder' => "${pfx}Folder::can_view",
            $pkg . 'save_filter.folder' => "${pfx}Folder::save_filter",

            # asset callbacks
            $pkg
                . 'pre_load_filtered_list.asset' =>
                "${pfx}Asset::cms_pre_load_filtered_list",
            $pkg . 'pre_save.asset' => "${pfx}Asset::pre_save",

            # blog callbacks
            $pkg
                . 'pre_load_filtered_list.blog' =>
                "${pfx}Blog::cms_pre_load_filtered_list",
            $pkg . 'save_filter.blog' => "${pfx}Blog::save_filter",

            # website callbacks
            $pkg . 'save_filter.website' => "${pfx}Website::save_filter",

            # role callbacks
            $pkg . 'save_filter.role'            => "${pfx}Role::save_filter",
            $pkg . 'view_permission_filter.role' => "${pfx}Role::can_view",

            # log callbacks
            $pkg . 'view_permission_filter.log'   => "${pfx}Log::can_view",
            $pkg . 'save_permission_filter.log'   => "${pfx}Log::can_save",
            $pkg . 'save_filter.log'              => "${pfx}Log::save_filter",
            $pkg . 'delete_permission_filter.log' => "${pfx}Log::can_delete",
            $pkg . 'post_delete.log'              => "${pfx}Log::post_delete",

            # tag callbacks
            $pkg
                . 'pre_load_filtered_list.tag' =>
                "${pfx}Tag::cms_pre_load_filtered_list",
            $pkg . 'view_permission_filter.tag'   => "${pfx}Tag::can_view",
            $pkg . 'save_permission_filter.tag'   => "${pfx}Tag::can_save",
            $pkg . 'delete_permission_filter.tag' => "${pfx}Tag::can_delete",

            # template callbacks
            $pkg
                . 'list_permission_filter.template' =>
                "${pfx}Template::can_list",
            $pkg
                . 'view_permission_filter.template' =>
                "${pfx}Template::can_view",
            $pkg . 'save_filter.template' => "${pfx}Template::save_filter",

            # widget callbacks
            $pkg
                . 'save_permission_filter.widget' =>
                '$Core::MT::CMS::Template::can_save',
            $pkg . 'save_filter.widget' => "${pfx}Widget::save_filter",
            $pkg . 'pre_save.widget' => '$Core::MT::CMS::Template::pre_save',
            $pkg
                . 'post_save.widget' => '$Core::MT::CMS::Template::post_save',

            # widgetset callbacks
            $pkg
                . 'save_permission_filter.widgetset' =>
                '$Core::MT::CMS::Template::can_save',
            $pkg . 'save_filter.widgetset' => "${pfx}WidgetSet::save_filter",
            $pkg
                . 'pre_save.widgetset' =>
                '$Core::MT::CMS::Template::pre_save',
            $pkg
                . 'post_save.widgetset' =>
                '$Core::MT::CMS::Template::post_save',

            # templatemap callbacks
            $pkg
                . 'list_permission_filter.templatemap' =>
                "${pfx}TemplateMap::can_list",
            $pkg
                . 'view_permission_filter.templatemap' =>
                "${pfx}TemplateMap::can_view",
            $pkg
                . 'save_permission_filter.templatemap' =>
                "${pfx}TemplateMap::can_save",
            $pkg
                . 'save_filter.templatemap' =>
                "${pfx}TemplateMap::save_filter",
            $pkg . 'pre_save.templatemap'  => "${pfx}TemplateMap::pre_save",
            $pkg . 'post_save.templatemap' => "${pfx}TemplateMap::post_save",
            $pkg
                . 'delete_permission_filter.templatemap' =>
                "${pfx}TemplateMap::can_delete",
            $pkg
                . 'post_delete.templatemap' =>
                "${pfx}TemplateMap::post_delete",

            # plugin callbacks
            $pkg
                . 'list_permission_filter.plugin' => "${pfx}Plugin::can_list",
            $pkg
                . 'view_permission_filter.plugin' => "${pfx}Plugin::can_view",

            # category_set callbacks
            $pkg
                . 'save_filter.category_set' =>
                "${pfx}CategorySet::save_filter",

            # content_type callbacks
            $pkg
                . 'save_filter.content_type' =>
                "${pfx}ContentType::save_filter",

            # content_field callbacks
            $pkg
                . 'save_filter.content_field' =>
                "${pfx}ContentField::save_filter",

            # content_data callbacks
            $pkg
                . 'list_permission_filter.content_data' =>
                "${pfx}ContentData::can_list",
            $pkg
                . 'view_permission_filter.content_data' =>
                "${pfx}ContentData::can_view",
            $pkg
                . 'pre_load_filtered_list.content_data' =>
                "${pfx}ContentData::cms_pre_load_filtered_list",
            $pkg
                . 'save_filter.content_data' =>
                "${pfx}ContentData::save_filter",

            # group callbacks
            $pkg . 'save_filter.group' => "${pfx}Group::save_filter",

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

            next if $e->{version} > $version;

            $e->{_vars} = [];

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

sub fields_to_schema {
    my ($app, $resource_name) = @_;
    my $schema = {
        type => 'object',
    };
    my $resource = MT::DataAPI::Resource->resource($resource_name);
    for my $field (@{ $resource->{fields} }) {
        if ($field->{schema}) {
            $schema->{properties}{ $field->{name} } = {
                %{ $field->{schema} },
            };
        } elsif (defined $field->{type} && $field->{type} =~ m/MT::DataAPI::Resource::DataType::Object\z/) {
            $schema->{properties}{ $field->{name} }{type} = 'object';
            for my $key (@{ $field->{fields} }) {
                $schema->{properties}{ $field->{name} }{properties}{$key} = {
                    type => 'string',
                };
            }
        } elsif (defined $field->{type} && $field->{type} =~ m/MT::DataAPI::Resource::DataType::/) {
            my $type_schema = $app->handler_to_coderef($field->{type} . '::schema')->();
            $schema->{properties}{ $field->{name} } = {
                %$type_schema,
            };
        } elsif (defined $field->{type}) {
            $schema->{properties}{ $field->{name} } = {
                type => $field->{type},
            };
        } else {
            $schema->{properties}{ $field->{name} } = {
                type => 'string',
            };
        }
    }
    my $updatable_schema;
    if (scalar(@{ $resource->{updatable_fields} })) {
        $schema->{description} = 'Updatable fields are ' . join(', ', map { $_->{name} } @{ $resource->{updatable_fields} });
        $updatable_schema->{type} = 'object';
        for my $f (@{ $resource->{updatable_fields} }) {
            my $field_name = $f->{name};
            if (exists $schema->{properties}{$field_name}) {
                $updatable_schema->{properties}{$field_name} = $schema->{properties}{$field_name};
            }
            if ($f->{schema}) {
                $updatable_schema->{properties}{ $field_name } = {
                    %{ $f->{schema} },
                };
            }
        }
    }
    return ($schema, $updatable_schema);
}

sub _compile_schemas {
    my ($app, $version) = @_;
    my %hash       = ();
    my @components = MT::Component->select();
    for my $c (@components) {
        my $resources = $c->registry('applications', 'data_api', 'resources');
        next unless defined $resources;
        for my $key (keys %$resources) {
            if (ref($resources->{$key}) eq 'ARRAY') {
                for my $v (@{ $resources->{$key} }) {
                    $v->{version} ||= 1;
                    next if $v->{version} > $version;
                    ($hash{$key}, my $updatable_schema) = $app->fields_to_schema($key);
                    if ($updatable_schema) {
                        $hash{"${key}_updatable"} = $updatable_schema;
                    }
                }
            } else {
                # alias
                next;
            }
        }
    }
    return \%hash;
}

sub schemas {
    my ($app, $version) = @_;
    $schemas{$version} ||= $app->_compile_schemas($version);
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
    $endpoint
        = $app->find_endpoint_by_id( $app->current_api_version, $endpoint )
        unless ref $endpoint;
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

    $url . $app->uri_params( args => $params || {} );
}

sub find_endpoints_by_path {
    my $app = shift;
    $app->find_endpoint_by_path( '*', @_ );
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
    while (@paths) {
        my $p = shift @paths;
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

    if ( $verb eq '*' ) {
        return $handler->{':e'};
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

sub _version_path {
    my ($app) = @_;
    my $path = $app->_path;

    $path =~ s{\A/?v(\d+)}{};
    ( $1, $path );
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

    if ( $ref && UNIVERSAL::can( $res, 'to_resource' ) ) {
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

    my $header = $app->get_header('X-MT-Authorization')
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
    require MT::Util::UniqueID;
    my $new_id = MT::Util::UniqueID::create_session_id();
    my $token  = MT::Util::UniqueID::create_magic_token();
    my $sess = new MT::Session;
    $sess->id( $new_id );
    $sess->kind( $app->session_kind );
    $sess->start(time);
    $sess->set( 'author_id', $auth->id );
    $sess->set( 'client_id', $app->current_client_id );
    $sess->set( 'magic_token', $token );
    $sess->set( 'remember',  1 ) if $remember;
    $sess->save;
    $sess;
}

sub session_user {
    my $app = shift;
    my ( $author, $session_id, %opt ) = @_;
    return undef unless $author && $session_id;
    if ( !$app->{session} ) {
        require MT::Session;
        my $timeout
            = $opt{permanent}
            ? ( 360 * 24 * 365 * 10 )
            : $app->config->UserSessionTimeout;
        $app->{session} = MT::Session::get_unexpired_value(
            $timeout,
            {   id   => $session_id,
                kind => $app->session_kind,
            }
        );
    }
    my $sess = $app->{session} or return undef;

    if ( $sess->get('author_id') == $author->id ) {
        my $start = time;
        $sess->start($start);
        $sess->set(start => $start) unless $sess->get('start');
        $sess->save;
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

sub send_cors_http_header {
    my $app    = shift;
    my $config = $app->config;

    my $origin       = $app->get_header('Origin');
    my $allow_origin = $config->DataAPICORSAllowOrigin
        or return;

    if ( $allow_origin ne '*' ) {
        return unless $origin;

        my ($match_origin) = grep { $_ eq $origin } split /\s*,\s*/,
            $allow_origin;
        return unless $match_origin;
        $allow_origin = $match_origin;
    }

    $app->set_header( 'Access-Control-Allow-Origin' => $allow_origin );
    $app->set_header( 'XDomainRequestAllowed'       => 1 );
    $app->set_header(
        'Access-Control-Allow-Methods' => $config->DataAPICORSAllowMethods );
    $app->set_header(
        'Access-Control-Allow-Headers' => $config->DataAPICORSAllowHeaders );
    $app->set_header( 'Access-Control-Expose-Headers' =>
            $config->DataAPICORSExposeHeaders );
}

sub send_http_header {
    my $app = shift;

    $app->set_header( 'X-Content-Type-Options' => 'nosniff' );
    $app->set_header( 'Cache-Control'          => 'no-cache' );

    $app->send_cors_http_header(@_);

    return $app->SUPER::send_http_header(@_);
}

sub default_options_response {
    my $app = shift;

    my $endpoints = $app->find_endpoints_by_path( $app->_version_path )
        || {};

    $app->set_header( 'Allow' =>
            join( ', ', sort( map { uc $_ } keys %$endpoints ), 'OPTIONS' ) );
    $app->send_http_header();
    $app->{no_print_body} = 1;

    undef;
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

    my $format             = $app->current_error_format;
    my $http_response_code = $status;
    my $mime_type          = $format->{mime_type};

    if ( $app->requires_plain_text_result ) {
        $http_response_code = 200;
        $mime_type          = 'text/plain';
    }
    if ( $app->param('suppressResponseCodes') ) {
        $http_response_code = 200;
    }

    $app->response_code($http_response_code);
    $app->send_http_header($mime_type);

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
        if ( !$error
        && $endpoint
        && ( $endpoint->{format} || '' ) eq 'html' );

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
    MT::App::CMS::load_default_entry_prefs(@_);
}

sub load_default_page_prefs {
    MT::App::CMS::load_default_page_prefs(@_);
}

sub api {
    my ($app) = @_;
    my ( $version, $path ) = $app->_version_path;

    # Special handler for get version information.
    if ( $path eq '/version' ) {
        my $raw = {
            endpointVersion => 'v' . $app->DEFAULT_VERSION(),
            apiVersion      => $app->API_VERSION(),
        };
        my $format = $app->current_format;
        my $data   = $format->{serialize}->($raw);

        $app->send_http_header( $format->{mime_type} );
        $app->{no_print_body} = 1;
        $app->print_encode($data);
        return undef;
    }

    return $app->print_error( 'API Version is required', 400 )
        unless defined $version;

    my $request_method = $app->_request_method
        or return;
    my ( $endpoint, $params )
        = $app->find_endpoint_by_path( $request_method, $version, $path )
        or return
        lc($request_method) eq 'options'
        ? $app->default_options_response
        : $app->print_error( 'Unknown endpoint', 404 );
    my $user = $app->authenticate;

    if ( !$user || ( $endpoint->{requires_login} && $user->is_anonymous ) ) {
        return $app->print_error( 'Unauthorized', 401 );
    }
    $user ||= MT::Author->anonymous;
    $app->user($user);
    $app->permissions(undef);

    if ( defined $params->{site_id} ) {
        my $id = $params->{site_id};
        if ($id) {
            my $site = $app->blog( scalar $app->model('blog')->load($id) )
                or return $app->print_error( 'Site not found', 404 );
        }
        $app->param( 'blog_id', $id );

        require MT::CMS::Blog;
        if (   !$user->is_superuser
            && !MT::CMS::Blog::data_api_is_enabled( $app, $id, $app->blog ) )
        {
            return $app->print_error(403);
        }

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
        my %request_param_key = map { $_ => 1 } $app->multi_param;
        foreach my $k (%$default_params) {
            if ( !exists( $request_param_key{$k} ) ) {
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
        || ($response_ref && UNIVERSAL::can( $response, 'to_resource' ) ) )
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
    elsif ( lc($request_method) eq 'options' && !$response ) {
        $app->send_http_header();
        $app->{no_print_body} = 1;
        undef;
    }
    else {
        $response;
    }
}

sub has_valid_limit_and_offset {
    my ($app) = shift;
    my ( $limit, $offset ) = @_;

    return $app->errtrans( '[_1] must be a number.', 'limit' )
        if ( defined $limit && $limit !~ /\A[0-9]+\z/ );
    return $app->errtrans( '[_1] must be a number.', 'offset' )
        if ( defined $offset && $offset !~ /\A[0-9]+\z/ );

    return $app->errtrans(
        '[_1] must be an integer and between [_2] and [_3].',
        'limit', 1, 2147483647 )
        if ( defined $limit && ( $limit < 1 || $limit > 2147483647 ) );
    return $app->errtrans(
        '[_1] must be an integer and between [_2] and [_3].',
        'offset', 0, 2147483647 )
        if ( defined $offset && ( $offset < 0 || $offset > 2147483647 ) );

    1;
}

# MT::App::CMS

sub load_entry_prefs {
    MT::App::CMS::load_entry_prefs(@_);
}

sub _parse_entry_prefs {
    MT::App::CMS::_parse_entry_prefs(@_);
}

sub validate_magic {
    my ($app) = @_;
    return $app->user && $app->user->id;
}

1;
__END__

=head1 NAME

MT::App::DataAPI

=head1 SYNOPSIS

    use MT::App::DataAPI;
    MT::DataAPI->current_endpoint;

=head1 DESCRIPTION

The I<MT::App::DataAPI> module is the application module for providing Data API.
This module provide the REST interface that is used to
manage blogs, entries, comments, trackbacks, templates, etc.

=head1 METHODS

=head2 MT::App::DataAPI->endpoints($version)

Returns the compiled endpoints data for specified $version.
The compiled endpoints data contains the following three type of values.

=over 4

=item hash

A hash map of ID-endpoint.

=item tree

A data of a tree structure built with the path of the I<route>

=item list

A list.

=back

=head2 MT::App::DataAPI->DEFAULT_VERSION

Returns the default version number.

=head2 MT::App::DataAPI->current_endpoint

Returns an endpoint of current request.

=head2 MT::App::DataAPI->current_api_version

Returns API version of current request.

=head2 MT::App::DataAPI->find_endpoint_by_id($version, $id)

Returns an endpoint whose ID is $id.

=head2 MT::App::DataAPI->find_endpoints_by_path($version, $path)

Returns all endpoints related to C<$path>.

=head2 MT::App::DataAPI->find_endpoint_by_path($verb, $version, $path)

Returns an endpoints related to C<$path> and C<$verb>.

=head2 MT::App::DataAPI->endpoint_url($endpoint[, $params])

Returns an URL for specified endpoint.

Both endpoint data and ID can be specified as C<$endpoint>.
If ID is specified, find endpoint by L<MT::App::DataAPI-E<gt>find_endpoint_by_id> with L<MT::App::DataAPI-E<gt>current_api_version>.

C<$params> is query parameter to a endpoint.

=head2 MT::App::DataAPI->current_format

Returns a format of current request.

=head2 MT::App::DataAPI->current_error_format

Returns a format to return error of current request.

=head2 MT::App::DataAPI->resource_object($name[, $original])

Returns an object that restored from request data.

C<$original> is optional parameter. The result object is cloned from C<$original>, then be overwritten by data that is restored from request.

=head2 MT::App::DataAPI->object_to_resource($objects[, $fields]);

Any data can be specified as C<$objects>.
If C<$objects> is a L<MT::Object>, converted to resource via L<MT::DataAPI::Resource-E<gt>from_object>.

=head2 $app->mt_authorization_data

Returns a hash map which extracted I<X-MT-Authorization> request header.

=head2 MT::App::DataAPI->current_client_id

Returns a client ID of current request.

=head2 MT::App::DataAPI->purge_session_records

Purge DataAPI's session records.

=head2 $app->error($message[, $code])

Set a error message and status code.

If only C<$message> is specified, simplly will be set error message to C<$app>,
If C<$code> is specified with C<$message>, will be set status code for response.
If only C<$code> is specified, will be set status code for response .

    $app->error( 'Invalid request'Bad Request', 400 );
    $app->error( 400 );

=head2 $app->print_error($message, $status[, $data]])

Print error message immediately.

If C<$message> is empty, C<$message> is automatically set up by C<$status>.

If C<$data> is specifyed, C<$data> will be printed as an optional data.

=head2 $app->set_next_phase_url($url)

Set an URL for redirecting to next phase.

=cut
