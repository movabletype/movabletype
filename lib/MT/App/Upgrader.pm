# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::App::Upgrader;
use strict;
use warnings;

use MT::App;
use base qw( MT::App );
use MT::Auth;
use MT::BasicAuthor;
use MT::Util;
use JSON;

sub id {'upgrade'}

use vars qw($MAX_TIME);

sub BEGIN {
    $MAX_TIME = 5;
}

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->{user_class}           = 'MT::BasicAuthor';
    $app->{template_dir}         = 'cms';
    $app->{plugin_template_path} = '';
    $app->{disable_memcached}    = 1;
    $app->{is_admin}             = 1;
    $app;
}

sub uri { $_[0]->mt_path . MT->config->UpgradeScript }

sub core_methods {
    return {
        'main'         => \&main,
        'install'      => \&upgrade,
        'upgrade'      => \&upgrade,
        'run_actions'  => \&run_actions,
        'init_user'    => \&init_user,
        'init_website' => \&init_website,
    };
}

sub needs_upgrade {
    my $app = shift;

    return 1 if MT->schema_version > ( $app->{cfg}->SchemaVersion || 0 );

    foreach my $plugin (@MT::Components) {
        return 1 if $plugin->needs_upgrade;
    }

    return 0;
}

sub init_request {
    my $app = shift;
    $app->SUPER::init_request(@_);
    $app->set_no_cache;
    $app->{default_mode} = 'install';
    delete $app->{response};
    my $mode = $app->mode || $app->{default_mode};
    $app->{requires_login} = $app->needs_upgrade && ( $mode eq 'upgrade' )
        || ( $mode eq 'main' );
}

sub login {
    my $app     = shift;
    my $cookies = $app->{cookies};
    my ( $user, $pass, $remember, $crypted, $cookie_middle );
    my $first_time  = 0;
    my $cookie_name = $app->user_cookie;
    if ( $cookies->{$cookie_name}
        && ( defined $cookies->{$cookie_name}->value ) )
    {
        ( $user, $cookie_middle, $remember ) = split /::/,
            $cookies->{$cookie_name}->value;
    }
    elsif ( $cookies->{'user'} ) {    # 1.1 - 2.661
        ( $user, $cookie_middle, $remember ) = split /::/,
            $cookies->{'user'}->value;
    }
    else {
        $cookie_middle = '';
        $remember      = '';
    }
    if ( $app->param('username') && $app->param('password') ) {
        $first_time = 1;
        $user       = $app->param('username');
        $pass       = $app->param('password');
        $remember   = $app->param('remember') || '';
        $crypted    = 0;
    }
    return unless $user && ( $pass || $cookie_middle );

    require MT::Lockout;

    my $process_login_result = sub {
        eval {
            MT::Lockout->process_login_result( $app, $app->remote_ip, $user,
                $_[0] );
        };
    };

    return
        if
        eval { MT::Lockout->is_locked_out( $app, $app->remote_ip, $user ) };

    my $driver = $MT::Object::DRIVER;
    $driver->clear_cache if $driver && $driver->can('clear_cache');
    if ( my @author = MT::BasicAuthor->load( { name => $user } ) ) {
        foreach my $author (@author) {

            # skip any possible non-authors...
            if ( MT::Auth->password_exists ) {
                next unless $author->password;
                next if $author->password eq '(none)';
            }
            my $valid = 0;
            if ($pass) {
                if ( $author->is_valid_password( $pass, $crypted ) ) {
                    $app->request( 'fresh_login', 1 );
                    $valid = 1;
                }
            }
            elsif ($cookie_middle) {

                # try checking old-style cookie using crypt'd password
                # then try the magic token if user is using new cookie
                # format...
                if (   ( 'MT' eq $app->config->AuthenticationModule )
                    && ( $author->is_valid_password( $cookie_middle, 1 ) ) )
                {
                    $valid = 1;
                }
                elsif ( $cookie_middle eq $author->magic_token ) {
                    $valid = 1;
                }
                elsif (
                    eval {
                        require MT::BasicSession;
                        MT::BasicSession->load($cookie_middle);
                    }
                    )
                {
                    $valid = 1;
                }
            }
            if ($valid) {
                $app->{author} = $author;
                if ( $cookie_middle ne $author->magic_token ) {
                    my %arg = (
                        -name  => $cookie_name,
                        -value => join(
                            '::',
                            $author->name,
                            $author->magic_token,

                            # note this is BasicAuthor::magic_token
                            $remember
                        ),
                        -path => $app->config('CookiePath') || $app->mt_path
                    );
                    $app->bake_cookie(%arg);
                }
                $process_login_result->( MT::Auth::NEW_LOGIN() );
                return ( $author, $first_time );
            }
            else {
                $process_login_result->( MT::Auth::INVALID_PASSWORD() );
                return $app->error( $app->translate('Invalid login.') );
            }
        }
    }
    ## Login invalid, so get rid of cookie (if it exists) and let the
    ## user know.
    $app->bake_cookie(
        -name    => $cookie_name,
        -value   => '',
        -expires => '-1y',
        -path    => $app->config('CookiePath') || $app->mt_path
    ) unless $first_time;
    $process_login_result->( MT::Auth::UNKNOWN() );
    return $app->error( $app->translate('Invalid login.') );
}

# build_page needs to know what to use as the magic token
sub current_magic {
    my $app = shift;
    return $app->{author}->magic_token if $app->{author};
}

sub upgrade {
    my $app = shift;

    return $app->main(@_) unless $app->needs_upgrade;

    my $install_mode;
    my %param;

    my $ver = $^V ? join( '.', unpack 'C*', $^V ) : $];
    my $perl_ver_check = '';
    if ( $] < 5.010001 ) {    # our minimal requirement for support
        $param{version_warning} = 1;
        $param{perl_version}    = $ver;
        $param{perl_minimum}    = '5.10.1';
    }

    my $method = $app->request_method;

    my $driver       = MT::Object->driver;
    my $author_class = MT->model('author');
    if ( !$driver || !$driver->table_exists($author_class) ) {
        $install_mode = 1;
        if ( $method ne 'POST' ) {
            return $app->build_page( "install.tmpl", \%param );
        }
    }

    if ( $method ne 'POST' ) {
        return $app->main();
    }

    $app->validate_magic or return;

    # if code flows here, this is upgrading
    my $steps;
    eval {
        local $app->{upgrading} = 1;
        require MT::Upgrade;
        MT::Upgrade->do_upgrade( Install => 0, DryRun => 1, App => $app );
        my $steps = $app->response->{steps};
        my $fn    = \%MT::Upgrade::functions;
        if ( $steps && @$steps ) {
            @$steps = sort {
                $fn->{ $a->[0] }->{priority} <=> $fn->{ $b->[0] }->{priority}
            } @$steps;
        }
    };
    die $@ if $@;
    $steps = $app->response->{steps};
    my $json_steps;
    if ( $steps && @$steps ) {
        $json_steps = MT::Util::to_json($steps);
    }

    $param{up_to_date} = $json_steps ? 0 : 1;
    $param{initial_steps} = $json_steps;
    $param{mt_admin_url}
        = ( $app->config->AdminCGIPath || $app->config->CGIPath )
        . $app->config->AdminScript;

    return $app->build_page( 'upgrade_runner.tmpl', \%param );
}

my @keys
    = qw( admin_email preferred_language admin_nickname admin_username initial_user initial_password initial_nickname initial_email initial_hint initial_lang initial_external_id use_system_email );

sub init_user {
    my $app = shift;
    my ($param) = @_;

    my $method = $app->request_method;
    if ( $method ne 'POST' ) {
        return $app->main();
    }

    $app->validate_magic or return;

    my $class   = MT->model('author');
    my $ddl     = $class->driver->dbd->ddl_class;
    my $db_defs = $ddl->column_defs($class);
    return $app->error( $app->translate('Invalid request') )
        if $db_defs;

    my %param = $app->unserialize_config;
    if ( !$app->param('continue') ) {
        return $app->build_page( 'install.tmpl', \%param );
    }

    foreach my $key (@keys) {
        $param{$key} = $app->param($key);
    }

    my $initial_user        = $app->param('admin_username');
    my $initial_password    = '';
    my $initial_nickname    = $app->param('admin_nickname') || '';
    my $initial_email       = $app->param('admin_email') || '';
    my $initial_lang        = $app->param('preferred_language');
    my $initial_external_id = '';
    my $initial_use_system  = 0;

    require MT::Auth;
    my $mode = $app->config("AuthenticationModule");

    #my ($pref) = split /\s+/, $mode;

    if ( !MT::Auth->password_exists ) {

        # external authentication; validate password
        my $pass = $app->param('admin_password');

        # validate login
        my $err    = '';
        my $author = new MT::BasicAuthor;
        $author->name($initial_user);
        if ( MT::Auth->is_valid_password( $author, $pass, 0, \$err ) ) {
            $initial_password = $pass;
            $app->param( 'name', $initial_user );
            my $error = MT::Auth->sanity_check($app);
            if ($error) {
                $param{error} = $error;
                return $app->build_page( 'install.tmpl', \%param );
            }
            else {
                $initial_email = $app->param('email') || '';
                $initial_nickname = $app->param('nickname');
                if ( my $external_id = $app->param('external_id') ) {
                    $initial_external_id
                        = MT::Author->unpack_external_id($external_id);
                }
            }
        }
        else {
            $param{error} = $app->translate(
                "Could not authenticate using the credentials provided: [_1].",
                $err
            );
            return $app->build_page( 'install.tmpl', \%param );
        }
    }
    else {
        my $pass  = $app->param('admin_password');
        my $pass2 = $app->param('admin_password_confirm');
        $pass  = '' unless defined $pass;
        $pass2 = '' unless defined $pass2;
        if ( length($pass) ) {
            if ( $pass2 eq $pass ) {
                $initial_password = $pass;
            }
            else {
                $param{error} = $app->translate("Both passwords must match.");
                return $app->build_page( 'install.tmpl', \%param );
            }
        }
        else {
            $param{error} = $app->translate("You must supply a password.");
            return $app->build_page( 'install.tmpl', \%param );
        }
    }
    if ( $mode eq 'MT' and $initial_email ) {
        if ( !MT::Util::is_valid_email($initial_email) ) {
            $param{error} = $app->translate( "Invalid email address '[_1]'",
                $initial_email );
            return $app->build_page( 'install.tmpl', \%param );
        }
    }

    {
        my $eh   = MT::ErrorHandler->new;
        my $user = MT::Author->new;
        $user->set_values(
            {   name        => $initial_user,
                nickname    => $initial_nickname,
                email       => $initial_email,
                lang        => $initial_lang,
                external_id => $initial_external_id,
            }
        );
        $user->set_password($initial_password);
        require MT::CMS::User;
        if (!MT::CMS::User::save_filter(
                $eh, $app, $user,
                $user->clone,
                {   skip_encode_html          => 1,
                    skip_validate_unique_name => 1,
                }
            )
            )
        {
            $param{error} = $eh->errstr;
            return $app->build_page( 'install.tmpl', \%param );
        }
    }

    $initial_use_system = 1
        if $param{use_system_email};

    $param{initial_user}        = $initial_user;
    $param{initial_password}    = $initial_password;
    $param{initial_nickname}    = $initial_nickname;
    $param{initial_email}       = $initial_email;
    $param{initial_lang}        = $initial_lang;
    $param{initial_external_id} = $initial_external_id;
    $param{initial_use_system}  = $initial_use_system;
    $param{config}              = $app->serialize_config(%param);

    my $new_user;
    use URI::Escape;
    $new_user = {
        user_name        => uri_escape_utf8( $param{initial_user} ),
        user_nickname    => uri_escape_utf8( $param{initial_nickname} ),
        user_password    => uri_escape_utf8( $param{initial_password} ),
        user_email       => uri_escape_utf8( $param{initial_email} ),
        user_lang        => $param{initial_lang},
        user_external_id => $param{initial_external_id},
    };

    if ( my $email_system = $param{initial_use_system}
        || $param{use_system_email} )
    {
        $new_user->{'use_system_email'} = $email_system;
    }
    my $steps;
    my $install_mode = 1;
    eval {
        local $app->{upgrading} = 1;
        require MT::Upgrade;
        MT::Upgrade->do_upgrade(
            Install => $install_mode,
            DryRun  => 1,
            App     => $app,
            (   $install_mode
                ? ( User => $new_user )
                : ()
            )
        );
        my $steps = $app->response->{steps};
        my $fn    = \%MT::Upgrade::functions;
        if ( $steps && @$steps ) {
            @$steps = sort {
                $fn->{ $a->[0] }->{priority} <=> $fn->{ $b->[0] }->{priority}
            } @$steps;
        }
    };
    die $@ if $@;
    $steps = $app->response->{steps};
    my $json_steps;
    if ( $steps && @$steps ) {
        $json_steps = MT::Util::to_json($steps);
    }

    $param{installing}    = $install_mode;
    $param{up_to_date}    = $json_steps ? 0 : 1;
    $param{initial_steps} = $json_steps;
    $param{mt_admin_url}
        = ( $app->config->AdminCGIPath || $app->config->CGIPath )
        . $app->config->AdminScript;

    return $app->build_page( 'upgrade_runner.tmpl', \%param );
}

sub init_website {
    my $app = shift;
    my ($param) = @_;
    my %param;

    my $class   = MT->model('website');
    my $ddl     = $class->driver->dbd->ddl_class;
    my $db_defs = $ddl->column_defs($class);
    return $app->error( $app->translate('Invalid request') )
        if $db_defs;

    my $sep = quotemeta MT::Util::dir_separator;

    $param{config}           = $param->{config} || $app->param('config');
    $param{website_name}     = $app->param('website_name');
    $param{website_url}      = $app->param('website_url') || '';
    $param{website_path}     = $app->param('website_path') || '';
    $param{website_timezone} = $app->param('website_timezone');
    $param{website_theme}    = $app->param('website_theme');
    $param{website_path} =~ s!$sep+$!!;
    $param{website_url} .= '/' if $param{website_url} !~ m!/$!;

    my $tz
        = defined( $app->param('website_timezone') )
        ? $app->param('website_timezone')
        : $app->config('DefaultTimezone');
    my $param_name = 'website_timezone_' . $tz;
    $param_name =~ s/[\-\.]/_/g;
    $param{$param_name} = 1;

    require MT::Theme;
    my $theme_loop = MT::Theme->load_theme_loop;
    $param{'theme_loop'}  = $theme_loop;
    $param{'theme_index'} = scalar @$theme_loop;
    if ( my $b_path = $app->config->BaseSitePath ) {
        $param{'sitepath_limited'} = $b_path;

        # making sure that we have a '/' in the end of the path
        $b_path = File::Spec->catdir( $b_path, "PATH" );
        $b_path =~ s/PATH$//;
        $param{'sitepath_limited_trail'} = $b_path;
    }
    if ( !-w $app->support_directory_path() ) {
        $param{'support_unwritable'} = 1;
    }

    if ( $app->param('back') ) {
        return $app->init_user;
    }
    if ( !$app->param('finish') ) {

        # suggest site_path & site_url
        my $path = $param{'sitepath_limited'} || $app->document_root();
        $param{website_path} = File::Spec->catdir($path);

        my $url = $app->base . '/';
        $url =~ s!/cgi(?:-bin)?(/.*)?$!/!;
        $url =~ s!/mt/?$!/!i;
        $param{website_url} = $url;

        return $app->build_page( 'setup_initial_website.tmpl', \%param );
    }

    if ( $param{'support_unwritable'} ) {
        return $app->build_page( 'setup_initial_website.tmpl', \%param );
    }

    # check to publishing path (writable?)
    my $site_path;
    if ( -d $param{website_path} ) {
        $site_path = $param{website_path};
    }
    else {
        my @dirs = File::Spec->splitdir( $param{website_path} );
        pop @dirs;
        $site_path = File::Spec->catdir(@dirs);
    }
    if ( $param{'sitepath_limited'} ) {

        # making sure that we have a '/' or '\' in the end of the path
        my $s_path = File::Spec->catdir( $site_path, "PATH" );
        $s_path =~ s/PATH$//;
        my $l_path = File::Spec->catdir( $param{'sitepath_limited'}, "PATH" );
        $l_path =~ s/PATH$//;
        $l_path = quotemeta($l_path);
        if ( $s_path !~ m/^$l_path/i ) {
            $param{error} = $app->translate(
                "The 'Website Root' provided below is not allowed");
            return $app->build_page( 'setup_initial_website.tmpl', \%param );
        }
    }
    if ( !-w $site_path ) {
        $param{error} = $app->translate(
            "The 'Website Root' provided below is not writable by the web server.  Change the ownership or permissions on this directory, then click 'Finish Install' again.",
            $param{website_path}
        );
        return $app->build_page( 'setup_initial_website.tmpl', \%param );
    }

    my %config = $app->unserialize_config();
    foreach my $key (@keys) {
        $param{$key} = $config{$key};
    }

    my $new_user;
    my $new_website;
    use URI::Escape;
    $new_user = {
        user_name        => uri_escape_utf8( $param{initial_user} ),
        user_nickname    => uri_escape_utf8( $param{initial_nickname} ),
        user_password    => uri_escape_utf8( $param{initial_password} ),
        user_email       => uri_escape_utf8( $param{initial_email} ),
        user_lang        => $param{initial_lang},
        user_external_id => $param{initial_external_id},
    };
    if ( my $email_system = $param{initial_use_system}
        || $param{use_system_email} )
    {
        $new_user->{'use_system_email'} = $email_system;
    }
    $new_website = {
        website_name     => uri_escape_utf8( $param{website_name} ),
        website_url      => uri_escape_utf8( $param{website_url} ),
        website_path     => uri_escape_utf8( $param{website_path} ),
        website_timezone => $param{website_timezone},
        website_theme    => $param{website_theme} || '',
    };

    my $steps;
    my $install_mode = 1;
    eval {
        local $app->{upgrading} = 1;
        require MT::Upgrade;
        MT::Upgrade->do_upgrade(
            Install => $install_mode,
            DryRun  => 1,
            App     => $app,
            (   $install_mode
                ? ( User => $new_user, Website => $new_website )
                : ()
            )
        );
        my $steps = $app->response->{steps};
        my $fn    = \%MT::Upgrade::functions;
        if ( $steps && @$steps ) {
            @$steps = sort {
                $fn->{ $a->[0] }->{priority} <=> $fn->{ $b->[0] }->{priority}
            } @$steps;
        }
    };
    die $@ if $@;
    $steps = $app->response->{steps};
    my $json_steps;
    if ( $steps && @$steps ) {
        $json_steps = MT::Util::to_json($steps);
    }

    $param{installing}    = $install_mode;
    $param{up_to_date}    = $json_steps ? 0 : 1;
    $param{initial_steps} = $json_steps;
    $param{mt_admin_url}
        = ( $app->config->AdminCGIPath || $app->config->CGIPath )
        . $app->config->AdminScript;

    return $app->build_page( 'upgrade_runner.tmpl', \%param );
}

sub finish {
    my $app = shift;

    delete $app->{disable_memcached}
        if exists $app->{disable_memcached};
    require MT::Memcached;
    if ( MT::Memcached->is_available ) {
        my $inst = MT::Memcached->instance;
        $inst->flush_all;
    }

    $app->reboot();

    if ( $app->{author} ) {
        require MT::Author;
        my $author     = MT::Author->load( $app->{author}->id );
        my $cookie_obj = $app->start_session($author);
        my $response   = $app->response;
        $response->{cookie}
            = { map { $_ => $cookie_obj->{$_} } ( keys %$cookie_obj ) };
    }
}

sub run_actions {
    my $app = shift;

    return $app->main(@_) unless $app->needs_upgrade;

    $| = 1;

    $app->{no_print_body} = 1;
    $app->send_http_header('text/plain');

    my $install_mode = $app->param('installing');

    if ( !$install_mode ) {
        $app->login;
    }

    my $schema = $app->{cfg}->SchemaVersion || 0;
    if ($schema) {
        if ( !$app->validate_magic ) {
            $app->response->{error} = $app->translate("Invalid session.");
            return $app->json_response;
        }
    }

    my $steps = $app->param('steps');
    $steps = JSON::from_json($steps);

    my $start = time;
    my @steps = (@$steps);
    my $step;

    my $fn = \%MT::Upgrade::functions;

    eval {
        local $app->{upgrading} = 1;
        require MT::Upgrade;
        MT::Upgrade->init;

        local $MT::Upgrade::App        = $app;
        local $MT::Upgrade::Installing = $install_mode;
        local $MT::Upgrade::MAX_TIME   = $MAX_TIME;

        while ( $step = shift @steps ) {
            my $result    = MT::Upgrade->run_step($step);
            my $new_steps = $app->response->{steps};
            if (@$new_steps) {
                push @steps, @$new_steps;
                @steps = sort {
                    $fn->{ $a->[0] }->{priority}
                        <=> $fn->{ $b->[0] }->{priority}
                } @steps;
                $app->response->{steps} = [];
            }
            last unless $result;

            # don't run for more than our time limit
            last if time > $start + $MAX_TIME;
        }
    };
    if ($@) {
        unshift @steps, $step if $step;
        $app->response->{error} = $@;
    }
    if ( $app->errstr ) {
        unshift @steps, $step;
        $app->response->{error} = $app->errstr;
    }

    if (@steps) {
        @steps = sort {
            $fn->{ $a->[0] }->{priority} <=> $fn->{ $b->[0] }->{priority}
        } @steps;
        $app->response->{steps} = \@steps;
    }

    $app->json_response;
}

sub json_response {
    my $app = shift;

    my $json_text = MT::Util::to_json( $app->response );
    $json_text =~ s/([<>\+])/sprintf("\\u%04x",ord($1))/eg;

    $app->print_encode( ' JSON:' . $json_text );
}

sub response {
    my $self = shift || MT->instance;
    return unless ref $self;
    if ( !$self->{response} ) {
        $self->{response} = { steps => [], progress => [], error => undef };
    }
    $self->{response};
}

sub add_step {
    my $self = shift;
    push @{ $self->response->{steps} }, [@_];
}

sub progress {
    my $app = shift;
    my ( $msg, $make_id ) = @_;
    $msg =~ s/^\s+//gs;
    $msg =~ s/\s+$//gs;
    $msg =~ s/\s+/ /gs;
    if ($make_id) {
        require MT::Util;
        my $id = MT::Util::dirify($make_id);
        $msg = qq{#$id $msg};
    }
    $app->print_encode( $msg . "\n" );
}

sub error {
    my $app = shift;
    my ($msg) = @_;
    $app->SUPER::error(@_);
    return unless ref $app;
    $app->response->{error} = $msg;
    die $msg if ref $app && $app->{upgrading};
    return;
}

sub serialize_config {
    my $app   = shift;
    my %param = @_;

    require MT::Serialize;
    my $ser = MT::Serialize->new('MT');
    my %set;
    foreach my $key (@keys) {
        $set{$key}
            = Encode::is_utf8( $param{$key} )
            ? Encode::encode( $app->charset, $param{$key} )
            : $param{$key};
    }
    my $set = \%set;
    unpack 'H*', $ser->serialize( \$set );
}

sub unserialize_config {
    my $app  = shift;
    my $data = $app->param('config');
    my %config;
    if ($data) {
        $data = pack 'H*', $data;
        require MT::Serialize;
        my $ser     = MT::Serialize->new('MT');
        my $ser_ver = $ser->serializer_version($data);
        if ( !$ser_ver || $ser_ver != $MT::Serialize::SERIALIZER_VERSION ) {
            die $app->translate('Invalid parameter.');
        }
        my $thawed = $ser->unserialize($data);
        if ($thawed) {
            my $saved_cfg = $$thawed;
            if ( keys %$saved_cfg ) {
                foreach my $p ( keys %$saved_cfg ) {
                    $config{$p}
                        = Encode::is_utf8( $saved_cfg->{$p} )
                        ? $saved_cfg->{$p}
                        : Encode::decode( $app->charset, $saved_cfg->{$p} );
                }
            }
        }
    }
    %config;
}

sub main {
    my $app = shift;
    my ($param) = @_;

    my $ver = $^V ? join( '.', unpack 'C*', $^V ) : $];
    my $perl_ver_check = '';
    if ( $] < 5.010001 ) {    # our minimal requirement for support
        $param->{version_warning} = 1;
        $param->{perl_version}    = $ver;
        $param->{perl_minimum}    = '5.10.1';
    }

    my $driver       = MT::Object->driver;
    my $author_class = MT->model('author');
    if ( !$driver || !$driver->table_exists($author_class) ) {
        my $method = $app->request_method;
        if ( $param || ( $method ne 'POST' ) ) {
            $param->{admin_username} ||= $app->param('admin_username') || '';
            return $app->build_page( "install.tmpl", $param );
        }
        $app->validate_magic or return;
        return $app->upgrade();
    }

    my $schema     = $app->{cfg}->SchemaVersion    || 0;
    my $version    = $app->config->MTVersion       || 0;
    my $rel_number = $app->config->MTReleaseNumber || 0;

    if ( $schema >= 3.2 ) {
        my $author;
        eval {
            require MT::Author;
            $author = MT::Author->load( $app->{author}->id );
        };
        if ( $author && !$author->is_superuser ) {
            return $app->errtrans(
                "No permissions. Please contact your Movable Type administrator for assistance with upgrading Movable Type."
            );
        }
    }

    my $cur_schema  = MT->schema_version;
    my $cur_version = MT->version_number;
    my $cur_rel     = MT->release_number;

    if ( $cur_schema > $schema ) {

        # yes, MT itself is needing an upgrade...
        $param->{mt_upgrade} = 1;
    }
    elsif (
        $app->config->NotifyUpgrade
        && (( $cur_version > $version )
            || ( !defined $rel_number
                || ( $cur_version == $version && $cur_rel > $rel_number ) )
        )
        )
    {
        $param->{mt_version_incremented} = 1;
        MT->log(
            {   message => MT->translate(
                    "Movable Type has been upgraded to version [_1].",
                    $app->release_version_id,
                ),
                level    => MT::Log::NOTICE(),
                class    => 'system',
                category => 'upgrade',
            }
        );
        $app->config( 'MTVersion',       $cur_version, 1 );
        $app->config( 'MTReleaseNumber', $cur_rel,     1 );
        $app->config->save_config;
    }

    $param->{help_url}    = $app->help_url();
    $param->{to_schema}   = $cur_schema;
    $param->{from_schema} = $schema;
    $param->{mt_version}  = $app->release_version_id;

    my @plugins;
    my $plugin_ver = $app->{cfg}->PluginSchemaVersion;
    foreach my $plugin (@MT::Components) {
        if ( $plugin->needs_upgrade ) {
            push @plugins,
                {
                name    => $plugin->label,
                version => $plugin->version
                };
        }
    }
    $param->{plugin_upgrades} = \@plugins if @plugins;
    $param->{needs_upgrade} = $param->{mt_upgrade} || ( @plugins > 0 );

    $app->build_page( 'upgrade.tmpl', $param );
}

sub build_page {
    my $app = shift;
    my ( $tmpl, $param ) = @_;
    $param ||= {};
    $param->{no_breadcrumbs} = 1;

    my $auth_mode = $app->config('AuthenticationModule');
    my ($pref) = split /\s+/, $auth_mode;
    $param->{"auth_mode_$pref"} = 1;

    my $auth = $app->user;
    if ( !$auth && $param->{needs_upgrade} ) {
        $auth = $app->login;
    }
    my $langs = $app->supported_languages;
    my @data;
    my $preferred = $app->config('DefaultLanguage');
    $preferred = 'en-us' if ( lc($preferred) eq 'en_us' );

    my $curr_lang = $app->current_language;
    for my $tag ( keys %$langs ) {
        ( my $name = $langs->{$tag} ) =~ s/\w+ English/English/;
        $app->set_language($tag);
        my $row = { l_tag => $tag, l_name => $app->translate($name) };
        $row->{l_selected} = 1 if $preferred eq $tag;
        push @data, $row;
    }
    $app->set_language($curr_lang);
    $param->{languages} = [ sort { $a->{l_name} cmp $b->{l_name} } @data ];

    $app->SUPER::build_page( $tmpl, $param );
}

1;
__END__

=head1 NAME

MT::App::Upgrader

=head1 AUTHOR & COPYRIGHT

Please see L<MT/AUTHOR & COPYRIGHT>.

=cut
