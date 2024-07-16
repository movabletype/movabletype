package MT::Test::App;

use Role::Tiny::With;
use strict;
use warnings;
use CGI;
use CGI::Cookie;
use HTTP::Response;
use URI;
use URI::QueryParam;
use Test::More;
use JSON;
use File::Basename;

with qw(
    MT::Test::Role::Request
    MT::Test::Role::WebQuery
);

my %Initialized;

sub import {
    my ($class, @roles) = @_;
    Role::Tiny->apply_roles_to_package($class, @roles) if @roles;
}

sub apply_role {
    my ($self, @roles) = @_;
    Role::Tiny->apply_roles_to_object($self, @roles);
}

sub init {
    my ($class, $app_class) = @_;

    return if $Initialized{$app_class};

    eval "require $app_class; 1;" or die "Can't load $app_class";

    # kill __test_output for a new request
    require MT;
    MT->add_callback(
        "${app_class}::init_request",
        1, undef,
        sub {
            $_[1]->{__test_output}    = '';
            $_[1]->{redirect}         = 0;
            $_[1]->{upgrade_required} = 0;
        },
    ) or die(MT->errstr);
    {
        no warnings 'redefine';
        *MT::App::print = sub {
            my $app = shift;
            if ($_[0] =~ /^Status:/) {
                my $res = HTTP::Response->parse($app->{__test_output});
                if (!$res->content) {
                    $app->{__test_output} = '';
                }
            }
            $app->{__test_output} ||= '';
            $app->{__test_output} .= join('', @_);
        };
    }
    $Initialized{$app_class} = 1;
}

sub new {
    my $class = shift;
    my %args  = (@_ == 1) ? (app_class => shift) : @_;

    $args{app_class} ||= $ENV{MT_APP} || 'MT::App::CMS';

    if ($args{app_class} !~ /^MT::App::/) {
        $args{app_class} = "MT::App::$args{app_class}";
    }

    if ($ENV{MT_TEST_RUN_APP_AS_CGI}) {
        $args{server} = $class->launch_server($args{app_class});
        $class->init($args{app_class});
    } else {
        $class->init($args{app_class});
    }

    bless \%args, $class;
}

sub launch_server {
    my ($class, $app_class) = @_;
    require Test::TCP;
    my %mapping = (
        'MT::App::DataAPI'             => 'mt-data-api.cgi',
        'MT::App::Search'              => 'mt-search.cgi',
        'MT::App::Search::ContentData' => 'mt-cdsearch.cgi',
        'MT::App::Upgrader'            => 'mt-upgrade.cgi',
    );
    my $script = join "/", $ENV{MT_HOME}, $mapping{$app_class} || "mt.cgi";
    my $sep    = $^O eq 'MSWin32' ? ';' : ':';
    Test::TCP->new(
        code => sub {
            my $port = shift;
            exec "plackup", "-I", "$ENV{MT_HOME}/lib", -"I", "$ENV{MT_HOME}/extlib", "-MPlack::App::WrapCGI", "--port", $port,
                "-e", "\$ENV{PERL5LIB} = '$ENV{PERL5LIB}$sep$ENV{MT_HOME}/t/lib'; Plack::App::WrapCGI->new(script => '$script', execute => 1)->to_app";
        },
    );
}

sub base_url {
    my $self = shift;
    my $port = $self->{server} ? ":" . $self->{server}->port : "";
    return "http://localhost$port";
}

sub login {
    my ($self, $user) = @_;
    $self->{user} = $user;
    delete $self->{session};
    delete $self->{access_token};
    if (my $app = MT->app) {
        delete $app->{perms};
    }
}

sub request {
    my ($self, $params, $is_redirect) = @_;
    $self->{locations} = undef unless $is_redirect;

    my $res =
          $self->{server}
        ? $self->_request_locally($params)
        : $self->_request_internally($params);

    $self->{content} = $res->decoded_content // '';

    $self->{html_content} = '';

    my $content_type = $res->headers->content_type;

    # redirect?
    my $location;
    if ($res->header('Location')) {
        $location = $res->header('Location');
    } elsif ($content_type =~ /html/ and $self->{content} =~ /window\.location\s*=\s*(['"])(\S+)\1/) {
        $location = $2;
    }
    if ($location) {
        Test::More::note "REDIRECTING TO $location";
        my $uri    = URI->new($location);
        my $params = $uri->query_form_hash;

        # avoid processing multiple requests in a second
        sleep 1;

        my $max_redirect = $self->{max_redirect} || 10;
        if (!defined $max_redirect or $max_redirect > @{$self->{locations} || []}) {
            push @{ $self->{locations} ||= [] }, $uri;
            return $self->request($params, 1) unless $self->{no_redirect};
        }
    }

    # json response?
    if ($content_type =~ /json/ or $self->{content} =~ /\A\s*[\{\[]/) {
        if (my $json = eval { decode_json($self->{content}) }) {
            if (ref $json eq 'HASH') {
                if (ref $json->{result} eq 'HASH' && $json->{result}{messages} && @{ $json->{result}{messages} || [] }) {
                    note explain $json->{result}{messages};
                }
                if ($json->{error}) {
                    note "ERROR: " . encode_json($json->{error});
                }
            }
        }
    } elsif ($content_type =~ /html/ and $self->{content}) {
        if (my $message = $self->message_text) {
            if ($message =~ /Compilation failed/) {
                BAIL_OUT $message;
            }
            note $message;
        } elsif (my $error = $self->generic_error) {
            note "ERROR: $error";
        }
    }

    $self->{res} = $res;
}

sub _request_locally {
    my ($self, $params) = @_;
    CGI::initialize_globals();
    $self->_clear_cache;

    my $app_params = $self->_app_params($params);
    my $cgi        = $self->_create_cgi_object($params);
    my $app        = $self->{app_class}->new(CGIObject => $cgi);
    my $url        = URI->new($self->base_url);
    if ($app_params->{__path_info}) {
        $url->path($app_params->{__path_info});
    }
    my $method = uc($app_params->{request_method} || 'GET');

    MT->set_instance($app);
    $app->{init_request} = 0;
    $app->init_request(CGIObject => $cgi);
    $self->{_app} = $app;

    $self->_clear_cache;

    my @headers;
    if (my $user = $self->{user}) {
        if ($self->{session}) {
            require MT::Session;
            my $sess = MT::Session->load($self->{session}) or delete $self->{session};
            $params->{magic_token} = $sess->get('magic_token') if $method eq 'POST';
        }
        if (!$self->{session}) {
            require MT::App;
            my $sess = MT::App::make_session($user, 1);
            $self->{session}       = $sess->id;
            $params->{magic_token} = $sess->get('magic_token') if $method eq 'POST';
            if ($self->{app_class} eq 'MT::App::DataAPI') {
                require MT::AccessToken;
                require MT::Util::UniqueID;
                my $token = MT::Util::UniqueID::create_magic_token();
                MT::AccessToken->new(id => $token, session_id => $sess->id, start => time)->save;
                $self->{access_token} = $token;
            }
        }
        if ($self->{app_class} eq 'MT::App::DataAPI') {
            push @headers, 'X-MT-Authorization' => "MTAuth accessToken=" . $self->{access_token};
        } else {
            require CGI::Cookie;
            my %cookie = (
                -name    => 'mt_user',
                -value   => Encode::encode_utf8(join '::', $user->name, $self->{session}, 1),
                -expires => '+10y',
            );
            push @headers, 'Cookie' => CGI::Cookie->new(\%cookie)->as_string;
        }
        for my $k (sort grep {/^HTTP_./} keys %ENV) {
            my $f = ($k =~ /^HTTP_(.+)/)[0];
            push @headers, $f => $ENV{$k};
        }
    }

    require HTTP::Request::Common;
    my $req;
    if ($method eq 'GET') {
        $url->query_form_hash($params);
        $req = HTTP::Request::Common::GET($url, @headers);
    } elsif ($method eq 'POST') {
        if (my $upload = delete $params->{__test_upload}) {
            my ($key, $src) = @$upload;
            $params->{$key} = [$src];
            $req = HTTP::Request::Common::POST($url, @headers, Content_Type => 'form-data', Content => [%$params]);
        } else {
            $req = HTTP::Request::Common::POST($url, [%$params], @headers);
        }
    } elsif ($method eq 'PUT') {
        if (my $upload = delete $params->{__test_upload}) {
            my ($key, $src) = @$upload;
            $params->{$key} = [$src];
            $req = HTTP::Request::Common::PUT($url, @headers, Content_Type => 'form-data', Content => [%$params]);
        } else {
            $req = HTTP::Request::Common::PUT($url, [%$params], @headers);
        }
    } elsif ($method eq 'DELETE') {
        $url->query_form_hash($params);
        $req = HTTP::Request::Common::DELETE($url, @headers);
    } else {
        Carp::confess "$method is not supported";
    }

    require LWP::UserAgent;
    my $ua = LWP::UserAgent->new;
    $ua->max_redirect(0);
    my $res = $ua->request($req);
}

sub _script_name {
    my $self = shift;
    my ($name) = $self->{app_class} =~ /::(\w+)$/;
    MT->config($name . 'Script') || MT->config->AdminScript;
}

sub _request_internally {
    my ($self, $params) = @_;
    local $ENV{HTTP_HOST} = 'localhost';    ## for app->base
    local $ENV{SCRIPT_NAME} = $self->_script_name;
    CGI::initialize_globals();
    $self->_clear_cache;

    my $app_params = $self->_app_params($params);
    my $cgi        = $self->_create_cgi_object($params);
    my $app        = $self->{app_class}->new(CGIObject => $cgi);
    MT->set_instance($app);
    $app->{init_request} = 0;
    $app->init_request(CGIObject => $cgi);
    $self->{_app} = $app;

    for my $key (keys %$app_params) {
        $app->{$key} = $app_params->{$key};
    }

    my $login;
    my $api_login;
    if (my $user = $self->{user}) {
        if (!$self->{session}) {
            $app->start_session($user, 1) unless $app->{session};
            $self->{session} = $app->{session}->id;
        } else {
            $app->session_user($user, $self->{session});
        }
        $app->param('magic_token', $app->current_magic);
        $app->user($user);
        my $cookie_name  = $app->user_cookie;
        my $cookie_value = join '::', $user->name, $self->{session};
        $app->{cookies} = { $cookie_name => CGI::Cookie->new(-name => $cookie_name, -value => $cookie_value) };
        my $org_login = \&MT::App::login;
        $login = sub {
            my $mt = shift;
            if ($mt->param('username') && $mt->param('password')) {
                return $org_login->($mt);
            }
            if (MT->has_plugin('MFA') && $0 !~ /\bMFA\b/) {
                $mt->session(mfa_verified => 1);
            }
            return ($user, 0)
        };
        if ($self->{app_class} eq 'MT::App::DataAPI') {
            $api_login = sub { return $user->is_active && $user->can_sign_in_data_api ? $user : undef };
        }
    }
    no warnings 'redefine';
    local *MT::App::login                 = $login     if $login;
    local *MT::App::DataAPI::authenticate = $api_login if $api_login;

    $app->run;

    my $out = delete $app->{__test_output};
    my $res = HTTP::Response->parse($out);
}

sub _app {
    my $self = shift;
    $self->{_app} || MT->app;
}

sub locations {
    my ($self, $id) = @_;
    return unless $self->{locations};
    $self->{locations}[$id];
}

sub last_location {
    my $self = shift;
    $self->locations(-1);
}

my %app_params_mapping = (
    __request_method => 'request_method',
    __path_info      => '__path_info',
);

sub _app_params {
    my ($self, $params) = @_;
    my %app_params;
    for my $key (keys %app_params_mapping) {
        next unless exists $params->{$key};
        $app_params{ $app_params_mapping{$key} } = delete $params->{$key};
    }
    \%app_params;
}

sub _create_cgi_object {
    my ($self, $params) = @_;
    my $cgi = CGI->new;
    while (my ($k, $v) = each %$params) {
        if ($k eq '__test_upload') {
            my ($key, $src) = @$v;
            require CGI::File::Temp;
            my $fh = CGI::File::Temp->new(UNLINK => 1)
                or die "CGI::File::Temp: $!";
            my $basename = basename($src);
            if ($^O eq 'MSWin32') {
                require Encode;
                Encode::from_to($basename, 'cp932', 'utf8');
            }
            $fh->_mp_filename($basename);
            binmode $fh;
            local $/;
            open my $in, '<', $src or die "Can't open $src: $!";
            binmode $in;
            my $body = <$in>;
            close $in;
            print $fh $body;
            seek $fh, 0, 0;
            $cgi->param($key, $fh);
        } else {
            $cgi->param($k, ref $v eq 'ARRAY' ? @$v : $v);
        }
    }
    $self->{cgi} = $cgi;
}

sub _clear_cache {
    my $self = shift;
    unless (MT->config->DisableObjectCache) {
        for my $model (MT->loaded_models) {
            $model->driver->clear_cache;
        }
    }
    MT->instance->request->reset;
}

sub trans {
    my ($self, $message) = @_;
    MT->translate($message);
}

1;
