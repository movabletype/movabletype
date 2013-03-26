# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::App::API;

use strict;
use base qw( MT::App );

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
            method         => 'GET',
            version        => 1,
            handler        => "${pkg}Auth::authorization",
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
            method         => 'POST',
            version        => 1,
            handler        => "${pkg}Auth::token",
            requires_login => 0,
        },
        {   id      => 'get_user',
            route   => '/users/:user_id',
            method  => 'GET',
            version => 1,
            handler => "${pkg}User::get",
        },
        {   id      => 'list_blogs',
            route   => '/users/{user_id}/sites',
            method  => 'GET',
            version => 1,
            handler => "${pkg}Blog::list",
        },
        {   id      => 'list_entries',
            route   => '/sites/:site_id/entries',
            method  => 'GET',
            version => 1,
            handler => "${pkg}Entry::list",
        },
    ];
}

sub core_resources {
    my $app = shift;
    my $pkg = 'MT::API::Resource::';
    return {
        'entry'   => "${pkg}Entry",
        'comment' => "${pkg}Comment",
        'user'    => "${pkg}User",
        'blog'    => "${pkg}Blog",
        'website' => "${pkg}Website",
    };
}

sub init_core_callbacks {
    my $app = shift;
    my $pkg = 'cms_';
    my $pfx = '$Core::MT::CMS::';
    $app->_register_core_callbacks(
        {

            # notification callbacks
            $pkg
                . 'save_permission_filter.notification' =>
                "${pfx}AddressBook::can_save",
            $pkg
                . 'delete_permission_filter.notification' =>
                "${pfx}AddressBook::can_delete",
            $pkg
                . 'save_filter.notification' =>
                "${pfx}AddressBook::save_filter",
            $pkg
                . 'post_delete.notification' =>
                "${pfx}AddressBook::post_delete",
            $pkg
                . 'pre_load_filtered_list.notification' =>
                "${pfx}AddressBook::cms_pre_load_filtered_list",

            # banlist callbacks
            $pkg
                . 'save_permission_filter.banlist' =>
                "${pfx}BanList::can_save",
            $pkg
                . 'delete_permission_filter.banlist' =>
                "${pfx}BanList::can_delete",
            $pkg . 'save_filter.banlist' => "${pfx}BanList::save_filter",
            $pkg
                . 'pre_load_filtered_list.banlist' =>
                "${pfx}BanList::cms_pre_load_filtered_list",

            # associations
            $pkg
                . 'delete_permission_filter.association' =>
                "${pfx}User::can_delete_association",
            $pkg
                . 'pre_load_filtered_list.association' =>
                "${pfx}User::cms_pre_load_filtered_list_assoc",
            'list_template_param.association' =>
                "${pfx}User::template_param_list",

            # user callbacks
            $pkg . 'edit.author'                   => "${pfx}User::edit",
            $pkg . 'view_permission_filter.author' => "${pfx}User::can_view",
            $pkg . 'save_permission_filter.author' => "${pfx}User::can_save",
            $pkg
                . 'delete_permission_filter.author' =>
                "${pfx}User::can_delete",
            $pkg . 'save_filter.author' => "${pfx}User::save_filter",
            $pkg . 'pre_save.author'    => "${pfx}User::pre_save",
            $pkg . 'post_save.author'   => "${pfx}User::post_save",
            $pkg . 'post_delete.author' => "${pfx}User::post_delete",
            $pkg . 'pre_load_filtered_list.author' => sub {
                my ( $cb, $app, $filter, $opts, $cols ) = @_;
                my $terms = $opts->{terms};
                $terms->{type} = MT::Author::AUTHOR();
            },
            $pkg . 'pre_load_filtered_list.commenter' => sub {
                my ( $cb, $app, $filter, $opts, $cols ) = @_;
                my $terms = $opts->{terms};
                my $args  = $opts->{args};
                $args->{joins} ||= [];
                push @{ $args->{joins} }, MT->model('permission')->join_on(
                    undef,
                    [   { blog_id => 0 },
                        '-and',
                        { author_id => \'= author_id', },
                        '-and',
                        [   { permissions => { like => '%comment%' } },
                            '-or',
                            { restrictions => { like => '%comment%' } },
                            '-or',
                            [   { permissions => \'IS NULL' },
                                '-and',
                                { restrictions => \'IS NULL' },
                            ],
                        ],
                    ],
                );
            },
            $pkg . 'pre_load_filtered_list.member' => sub {
                my ( $cb, $app, $filter, $opts, $cols ) = @_;
                my $terms = $opts->{terms};
                my $args  = $opts->{args};
                $args->{joins} ||= [];
                if ( MT->config->SingleCommunity ) {
                    $terms->{type} = 1;
                    push @{ $args->{joins} },
                        MT->model('association')->join_on(
                        undef,
                        [   {   blog_id   => $opts->{blog_id},
                                author_id => { not => 0 },
                            },
                            'and',
                            { author_id => \'= author_id', },
                        ],
                        { unique => 1, },
                        );
                }
                else {
                    push @{ $args->{joins} },
                        MT->model('permission')->join_on(
                        undef,
                        {   blog_id   => $opts->{blog_id},
                            author_id => { not => 0 },
                        },
                        {   unique    => 1,
                            condition => { author_id => \'= author_id', },
                            type      => 'inner'
                        },
                        );
                    push @{ $args->{joins} },
                        MT->model('association')->join_on(
                        undef,
                        [   [   { blog_id => $opts->{blog_id}, },
                                '-or',
                                { blog_id => \' is null', },
                            ],
                        ],
                        {   type      => 'left',
                            condition => { author_id => \'= author_id', },
                            unique    => 1,
                        },
                        );
                }
            },

            # website callbacks
            $pkg . 'post_save.website'   => "${pfx}Website::post_save",
            $pkg . 'edit.website'        => "${pfx}Website::edit",
            $pkg . 'post_delete.website' => "${pfx}Website::post_delete",
            $pkg
                . 'save_permission_filter.website' =>
                "${pfx}Website::can_save",
            $pkg
                . 'delete_permission_filter.website' =>
                "${pfx}Website::can_delete",
            $pkg
                . 'pre_load_filtered_list.website' =>
                "${pfx}Website::cms_pre_load_filtered_list",
            $pkg . 'filtered_list_param.website' => sub {
                my ( $cb, $app, $param, $objs ) = @_;
                if ( $param->{not_deleted} ) {
                    $param->{messages} ||= [];
                    push @{ $param->{messages} },
                        {
                        cls => 'alert',
                        msg => MT->translate(
                            'Some websites were not deleted. You need to delete blogs under the website first.',
                        )
                        };
                }
            },

            $pkg
                . 'view_permission_filter.website' =>
                "${pfx}Website::can_view",

            # blog callbacks
            $pkg . 'edit.blog'                   => "${pfx}Blog::edit",
            $pkg . 'view_permission_filter.blog' => "${pfx}Blog::can_view",
            $pkg . 'save_permission_filter.blog' => "${pfx}Blog::can_save",
            $pkg
                . 'delete_permission_filter.blog' => "${pfx}Blog::can_delete",
            $pkg . 'pre_save.blog'    => "${pfx}Blog::pre_save",
            $pkg . 'post_save.blog'   => "${pfx}Blog::post_save",
            $pkg . 'save_filter.blog' => "${pfx}Blog::save_filter",
            $pkg . 'post_delete.blog' => "${pfx}Blog::post_delete",
            $pkg
                . 'pre_load_filtered_list.blog' =>
                "${pfx}Blog::cms_pre_load_filtered_list",

            # folder callbacks
            $pkg . 'edit.folder' => "${pfx}Folder::edit",
            $pkg
                . 'view_permission_filter.folder' => "${pfx}Folder::can_view",
            $pkg
                . 'save_permission_filter.folder' => "${pfx}Folder::can_save",
            $pkg
                . 'delete_permission_filter.folder' =>
                "${pfx}Folder::can_delete",
            $pkg . 'pre_save.folder'    => "${pfx}Folder::pre_save",
            $pkg . 'post_save.folder'   => "${pfx}Folder::post_save",
            $pkg . 'save_filter.folder' => "${pfx}Folder::save_filter",
            $pkg . 'post_delete.folder' => "${pfx}Folder::post_delete",

            # category callbacks
            $pkg . 'edit.category' => "${pfx}Category::edit",
            $pkg
                . 'view_permission_filter.category' =>
                "${pfx}Category::can_view",
            $pkg
                . 'save_permission_filter.category' =>
                "${pfx}Category::can_save",
            $pkg
                . 'delete_permission_filter.category' =>
                "${pfx}Category::can_delete",
            $pkg . 'pre_save.category'    => "${pfx}Category::pre_save",
            $pkg . 'post_save.category'   => "${pfx}Category::post_save",
            $pkg . 'save_filter.category' => "${pfx}Category::save_filter",
            $pkg . 'post_delete.category' => "${pfx}Category::post_delete",
            'list_template_param.category' =>
                "${pfx}Category::template_param_list",
            $pkg
                . 'pre_load_filtered_list.category' =>
                "${pfx}Category::pre_load_filtered_list",
            $pkg
                . 'filtered_list_param.category' =>
                "${pfx}Category::filtered_list_param",
            'list_template_param.folder' =>
                "${pfx}Category::template_param_list",
            $pkg
                . 'pre_load_filtered_list.folder' =>
                "${pfx}Category::pre_load_filtered_list",
            $pkg
                . 'filtered_list_param.folder' =>
                "${pfx}Category::filtered_list_param",

            # comment callbacks
            $pkg . 'edit.comment' => "${pfx}Comment::edit",
            $pkg
                . 'view_permission_filter.comment' =>
                "${pfx}Comment::can_view",
            $pkg
                . 'save_permission_filter.comment' =>
                "${pfx}Comment::can_save",
            $pkg
                . 'delete_permission_filter.comment' =>
                "${pfx}Comment::can_delete",
            $pkg . 'pre_save.comment'    => "${pfx}Comment::pre_save",
            $pkg . 'post_save.comment'   => "${pfx}Comment::post_save",
            $pkg . 'post_delete.comment' => "${pfx}Comment::post_delete",
            $pkg
                . 'pre_load_filtered_list.comment' =>
                "${pfx}Comment::cms_pre_load_filtered_list",

            # commenter callbacks
            $pkg . 'edit.commenter' => "${pfx}Comment::edit_commenter",
            $pkg
                . 'view_permission_filter.commenter' =>
                "${pfx}Comment::can_view_commenter",
            $pkg
                . 'delete_permission_filter.commenter' =>
                "${pfx}Comment::can_delete_commenter",

            # entry callbacks
            $pkg . 'edit.entry'                   => "${pfx}Entry::edit",
            $pkg . 'view_permission_filter.entry' => "${pfx}Entry::can_view",
            $pkg
                . 'delete_permission_filter.entry' =>
                "${pfx}Entry::can_delete",
            $pkg . 'pre_save.entry'    => "${pfx}Entry::pre_save",
            $pkg . 'post_save.entry'   => "${pfx}Entry::post_save",
            $pkg . 'post_delete.entry' => "${pfx}Entry::post_delete",
            $pkg
                . 'pre_load_filtered_list.entry' =>
                "${pfx}Entry::cms_pre_load_filtered_list",

            # page callbacks
            $pkg . 'edit.page'                   => "${pfx}Page::edit",
            $pkg . 'view_permission_filter.page' => "${pfx}Page::can_view",
            $pkg
                . 'delete_permission_filter.page' => "${pfx}Page::can_delete",
            $pkg . 'save_permission_filter.page' => "${pfx}Page::can_save",
            $pkg . 'pre_save.page'               => "${pfx}Page::pre_save",
            $pkg . 'post_save.page'              => "${pfx}Page::post_save",
            $pkg . 'post_delete.page'            => "${pfx}Page::post_delete",
            $pkg
                . 'pre_load_filtered_list.page' =>
                "${pfx}Page::cms_pre_load_filtered_list",

            # ping callbacks
            $pkg . 'edit.ping' => "${pfx}TrackBack::edit",
            $pkg
                . 'view_permission_filter.ping' =>
                "${pfx}TrackBack::can_view",
            $pkg
                . 'save_permission_filter.ping' =>
                "${pfx}TrackBack::can_save",
            $pkg
                . 'delete_permission_filter.ping' =>
                "${pfx}TrackBack::can_delete",
            $pkg . 'pre_save.ping'    => "${pfx}TrackBack::pre_save",
            $pkg . 'post_save.ping'   => "${pfx}TrackBack::post_save",
            $pkg . 'post_delete.ping' => "${pfx}TrackBack::post_delete",
            $pkg
                . 'pre_load_filtered_list.ping' =>
                "${pfx}TrackBack::cms_pre_load_filtered_list",

            # template callbacks
            $pkg . 'edit.template' => "${pfx}Template::edit",
            $pkg
                . 'view_permission_filter.template' =>
                "${pfx}Template::can_view",
            $pkg
                . 'save_permission_filter.template' =>
                "${pfx}Template::can_save",
            $pkg
                . 'delete_permission_filter.template' =>
                "${pfx}Template::can_delete",
            $pkg . 'pre_save.template'    => "${pfx}Template::pre_save",
            $pkg . 'post_save.template'   => "${pfx}Template::post_save",
            $pkg . 'post_delete.template' => "${pfx}Template::post_delete",
            'restore' => "${pfx}Template::restore_widgetmanagers",

            # tags
            $pkg . 'delete_permission_filter.tag' => "${pfx}Tag::can_delete",
            $pkg . 'post_delete.tag'              => "${pfx}Tag::post_delete",
            $pkg
                . 'pre_load_filtered_list.tag' =>
                "${pfx}Tag::cms_pre_load_filtered_list",

            # junk-related callbacks
            #'HandleJunk' => \&_builtin_spam_handler,
            #'HandleNotJunk' => \&_builtin_spam_unhandler,
            $pkg . 'not_junk_test' => "${pfx}Common::not_junk_test",

            # assets
            $pkg . 'edit.asset'                   => "${pfx}Asset::edit",
            $pkg . 'view_permission_filter.asset' => "${pfx}Asset::can_view",
            $pkg
                . 'delete_permission_filter.asset' =>
                "${pfx}Asset::can_delete",
            $pkg . 'save_permission_filter.asset' => "${pfx}Asset::can_save",
            $pkg . 'pre_save.asset'               => "${pfx}Asset::pre_save",
            $pkg . 'post_save.asset'              => "${pfx}Asset::post_save",
            $pkg . 'post_delete.asset'  => "${pfx}Asset::post_delete",
            $pkg . 'save_filter.asset'  => "${pfx}Asset::cms_save_filter",
            'template_param.edit_asset' => "${pfx}Asset::template_param_edit",
            $pkg
                . 'pre_load_filtered_list.asset' =>
                "${pfx}Asset::cms_pre_load_filtered_list",

            # log
            $pkg
                . 'pre_load_filtered_list.log' =>
                "${pfx}Log::cms_pre_load_filtered_list",
            'list_template_param.log' => "${pfx}Log::template_param_list",

            # role
            $pkg
                . 'save_permission_filter.role' =>
                "${pfx}User::can_save_role",
            $pkg
                . 'delete_permission_filter.role' =>
                "${pfx}User::can_delete_role",
        }
    );
}

sub init_plugins {
    my $app = shift;

    # This has to be done prior to plugin initialization since we
    # may have plugins that register themselves using some of the
    # older callback names. The callback aliases are declared
    # in init_core_callbacks.
    $app->init_core_callbacks();
    $app->SUPER::init_plugins(@_);
}

sub _endpoint {
    my ( $app, $method, $version, $path ) = @_;

    my %tree = ();
    my $endpoints_list = $app->registry( 'applications', 'api', 'endpoints' );
    foreach my $endpoints (@$endpoints_list) {
        foreach my $e (@$endpoints) {
            $e->{version} ||= 1;
            $e->{method}  ||= 'GET';
            if ( !exists( $e->{requires_login} ) ) {
                $e->{requires_login} = 1;
            }
            $e->{vars} = [];

            next if $e->{version} > $version;

            my $cur = \%tree;
            foreach my $p ( split /\//o, $e->{route} ) {
                next unless $p;
                foreach my $s ( split /\./o, $p ) {
                    if ( $s =~ /^:([a-zA-Z_-]+)/ ) {
                        $cur = $cur->{':v'} ||= {};
                        push @{ $e->{vars} }, $1;
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

    my $handler = \%tree;
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
        for ( my $i = 0; $i < scalar( @{ $e->{vars} } ); $i++ ) {
            $params{ $e->{vars}[$i] } = $vars[$i];
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

sub _resources {
    my ($app) = @_;

    my $resources = $app->registry( 'applications', 'api', 'resources' );
    return +{ map { $app->model($_) => $resources->{$_}, } keys %$resources };
}

sub _convert_object {
    my ( $app, $res ) = @_;
    my $ref = ref $res;

    my $resources = $app->_resources;
    if ( UNIVERSAL::isa( $res, 'MT::Object' ) ) {

        # TODO if resource is not found
        eval( 'require ' . $resources->{$ref} . ';' );
        $resources->{$ref}->from_object( $app, $res );
    }
    elsif ( $ref eq 'HASH' ) {
        my %result = ();
        foreach my $k ( keys %$res ) {
            $result{$k} = $app->_convert_object( $res->{$k} );
        }
        return \%result;
    }
    elsif ( $ref eq 'ARRAY' ) {
        return [ map { $app->_convert_object($_) } @$res ];
    }
    else {
        $res;
    }
}

sub _encode_json {
    my ( $app, $res ) = @_;
    my $obj = $app->_convert_object($res);
    MT::Util::to_json($obj);
}

sub _request_header {
    my ( $app, $key ) = @_;

    my $headers = undef;
    if ( $ENV{MOD_PERL} && exists( $app->{apache} ) ) {
        $headers = $app->{apache}->headers_in();
    }
    else {
        $headers = \%ENV;
    }

    $key = uc($key);
    $key =~ s/-/_/g;

    $headers->{ 'HTTP_' . $key };
}

sub authenticate {
    my ($app) = @_;

    my $header = $app->_request_header('X-MT-Authorization')
        or undef;

    if ( $header =~ m/MTAuth access_token=(\w+)/ ) {
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

sub make_session {
    my ( $app, $auth, $remember ) = @_;
    require MT::Session;
    my $sess = new MT::Session;
    $sess->id( $app->make_magic_token() );
    $sess->kind('PS');    # PS == API Session
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
            kind => 'PS'
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

sub json_error {
    my ( $app, $status, $message ) = @_;
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
    return $app->json_error( 400, 'API Version is required' )
        unless defined($version);
    $app->api_version($version);

    my ( $endpoint, $params )
        = $app->_endpoint( $app->_request_method, $version, $path );
    my $user = $app->authenticate;

    if ( $endpoint->{requires_login} && !$user ) {
        return $app->json_error( 401, 'Authentication required' );
    }
    $app->user($user);

    if ( my $id = $params->{site_id} ) {
        $app->blog( scalar $app->model('blog')->load($id) )
            or return $app->json_error( 404, 'Site not found' );
        $app->param('blog_id', $id);
    }

    foreach my $k (%$params) {
        $app->param( $k, $params->{$k} );
    }

    my $code = $app->handler_to_coderef( $endpoint->{handler} )
        or return $app->json_error( 404, 'Unknown endpoint' );
    my $res = $code->($app);

    if ( UNIVERSAL::isa( $res, 'MT::Template' ) ) {
        $res;
    }
    elsif (ref $res eq 'HASH'
        || ref $res eq 'ARRAY'
        || UNIVERSAL::isa( $res, 'MT::Object' ) )
    {
        $app->send_http_header('application/json');
        $app->{no_print_body} = 1;
        $app->print_encode( $app->_encode_json($res) );
        undef;
    }
    else {
        $res;
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
