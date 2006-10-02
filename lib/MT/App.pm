# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::App;
use strict;

use File::Spec;

use MT::Request;
use MT::Util qw( encode_html offset_time_list decode_html encode_url );
use MT::Author qw( AUTHOR );
use MT;
@MT::App::ISA = qw( MT );

my $COOKIE_NAME = 'mt_user';
use vars qw( %Global_actions );
sub add_methods {
    my $this = shift;
    my %meths = @_;
    if (ref($this)) {
        for my $meth (keys %meths) {
            $this->{vtbl}{$meth} = $meths{$meth};
        }
    } else {
        for my $meth (keys %meths) {
            $Global_actions{$this}{$meth} = $meths{$meth};
        }
    }
}

sub add_plugin_action {
    my $app = shift;

    my ($object_type, $action_link, $link_text) = @_;
    my $plugin_envelope = $MT::plugin_envelope;
    my $plugin_sig = $MT::plugin_sig;
    unless ($plugin_envelope) {
        warn "MT->add_plugin_action improperly called outside of MT plugin load loop.";
        return;
    }
    $action_link .= '?' unless $action_link =~ m.\?.;
    push @{$MT::Plugins{$plugin_sig}{actions}}, "$object_type Action" if $plugin_sig;
    my $page = $app->config('AdminCGIPath') || $app->config('CGIPath');
    $page .= '/' unless $page =~ m!/$!;
    $page .= $plugin_envelope . '/' if $plugin_envelope;
    $page .= $action_link;
    my $param = { page => $page,
        link_text => $link_text,
        orig_link_text => $link_text,
        plugin => $plugin_sig };
    $app->{plugin_actions} ||= {};
    push @{$app->{plugin_actions}{$object_type}}, $param;
}

sub plugin_actions {
    my $app = shift;
    my ($type) = @_;
    my $actions = $app->{plugin_actions}{$type};
    if ($actions) {
        # translate the link text here...
        foreach (@$actions) {
            if ($_->{plugin}) {
                my $plugin = $MT::Plugins{$_->{plugin}}{object};
                $_->{link_text} = $plugin->translate($_->{orig_link_text});
            } else {
                $_->{link_text} = $app->translate($_->{orig_link_text});
            }
        }
    }
    $actions;
}

sub response_code {
    my $app = shift;
    $app->{response_code} = shift if @_;
    $app->{response_code};
}

sub response_message {
    my $app = shift;
    $app->{response_message} = shift if @_;
    $app->{response_message};
}

sub response_content_type {
    my $app = shift;
    $app->{response_content_type} = shift if @_;
    $app->{response_content_type};
}

sub charset {
    my $app = shift;
    $app->{charset} = shift if @_;
    return $app->{charset} if $app->{charset};
    $app->{charset} = $app->config('PublishCharset') || $app->language_handle->encoding;
}

sub send_http_header {
    my $app = shift;
    my($type) = @_;
    $type ||= 'text/html';
    if (my $charset = $app->charset) {
        $type .= "; charset=$charset"
            if $type =~ m!^text/! && $type !~ /\bcharset\b/;
    }
    if ($ENV{MOD_PERL}) {
        if ($app->{response_message}) {
            $app->{apache}->status_line(($app->response_code || 200) . " " 
                                        . $app->{response_message});
        } else {
            $app->{apache}->status($app->response_code || 200);
        }
        $app->{apache}->send_http_header($type);
    } else {
        $app->{cgi_headers}{-status} = ($app->response_code || 200) . " "
                                     . ($app->{response_message} || "");
        $app->{cgi_headers}{-type} = $type;
        print $app->{query}->header(%{ $app->{cgi_headers} });
    }
}

sub print {
    my $app = shift;
    if ($ENV{MOD_PERL}) {
        $app->{apache}->print(@_);
    } else {
        CORE::print(@_);
    }
}

my $TransparentProxyIPs = 0;

sub handler ($$) {
    my $class = shift;
    my($r) = @_;
    require Apache::Constants;
    if (lc($r->dir_config('Filter') || '') eq 'on') {
        $r = $r->filter_register;
    }
    my $config_file = $r->dir_config('MTConfig');
    my $mt_dir = $r->dir_config('MTHome');
    my %params = (Config => $config_file, ApacheObject => $r,
                  ( $mt_dir ? ( Directory => $mt_dir ) : () ));
    my $app = $class->new( %params )
        or die $class->errstr;

    MT->set_instance($app);
    $app->init_request(%params);

    my $cfg = $app->config;
    if (my @extra = $r->dir_config('MTSetVar')) {
        for my $d (@extra) {
            my($var, $val) = $d =~ /^\s*(\S+)\s+(.+)$/;
            $cfg->set($var, $val);
        }
    }

    $app->run;
    return Apache::Constants::OK();
}

sub new {
    my $pkg = shift;
    my $app = $pkg->SUPER::new(@_);
    $app->{init_request} = 0;
    $app;
}

sub init {
    my $app = shift;
    my %param = @_;
    $app->{apache} = $param{ApacheObject} if exists $param{ApacheObject};
    $app->SUPER::init(%param) or return;
    $app->{vtbl} = { };
    $app->{is_admin} = 0;
    $app->{template_dir} = 'cms';
    $app->{user_class} = 'MT::Author';
    $app->{plugin_template_path} = 'tmpl';
    $app->{plugin_actions} ||= {};
    # stash this for use after app object is destroyed
    $TransparentProxyIPs = MT::ConfigMgr->instance()->TransparentProxyIPs;
    MT->add_callback('*::post_save', 0, $app, \&cb_mark_blog );

    $_->init_app($app) foreach @MT::Plugins;

    $app->init_request(@_);

    $app;
}

sub init_request {
    my $app = shift;
    my %param = @_;

    return if $app->{init_request};

    if ($app->{request_read_config}) {
        $app->read_config(\%param) or return;
        $app->{request_read_config} = 0;
    }

    # @req_vars: members of the app object which are request-specific
    # and are cleared at the beginning of each request.
    my @req_vars = qw(mode __path_info _blog redirect login_again
        no_print_body response_code response_content_type response_message
        author cgi_headers breadcrumbs goback cache_templates warning_trace
        cookies _errstr request_method);
    delete $app->{$_} foreach @req_vars;
    $app->{trace} = '';
    $app->{author} = $app->{$COOKIE_NAME} = undef;
    if ($ENV{MOD_PERL}) {
        require Apache::Request;
        $app->{apache} = $param{ApacheObject} || Apache->request;
        $app->{query} = Apache::Request->instance($app->{apache},
            POST_MAX => $app->config('CGIMaxUpload'));
    } else {
        if ($param{CGIObject}) {
            $app->{query} = $param{CGIObject};
        } else {
            if (my $path_info = $ENV{PATH_INFO}) {
                if ($path_info =~ m/\.cgi$/) {
                    # some CGI environments (notably 'sbox') leaves PATH_INFO
                    # defined which interferes with CGI.pm determining the
                    # request url.
                    delete $ENV{PATH_INFO};
                }
            }
            require CGI;
            $CGI::POST_MAX = $app->config('CGIMaxUpload');
            $app->{query} = CGI->new( $app->{no_read_body} ? {} : () );
        }
    }
    $app->{return_args} = $app->{query}->param('return_args');
    $app->cookies;

    # Backward compatible assignment; now that plugin actions are
    # actually stored in the app object, the MT::PluginActions
    # hash variable needs to point to it.
    *MT::PluginActions = $app->{plugin_actions};

    ## Initialize the MT::Request singleton for this particular request.
    $app->request->reset();
    $app->request('App-Class', ref $app);
    $_->init_request($app) foreach @MT::Plugins;

    $app->{init_request} = 1;
}

sub cb_mark_blog {
    my ($eh, $obj) = @_;
    my $obj_type = ref $obj;
    return if ($obj_type eq 'MT::Author' ||
               $obj_type eq 'MT::Log' || $obj_type eq 'MT::Session' ||
               (($obj_type ne 'MT::Blog') && !$obj->column('blog_id')));
    my $mt_req = MT->instance->request;
    my $blogs_touched = $mt_req->stash('blogs_touched') || {};
    if ($obj_type eq 'MT::Blog') {
        $blogs_touched->{$obj->id} = 0;
    } else {
        $blogs_touched->{$obj->blog_id}++;
    }
    $mt_req->stash('blogs_touched', $blogs_touched);
}

sub touch_blogs {
    my $blogs_touched = MT->instance->request('blogs_touched') or return;
    foreach my $blog_id (keys %$blogs_touched) {
        next unless $blog_id;
        my $blog = MT::Blog->load($blog_id, {cached_ok=>1});
        $blog->touch();
        $blog->save() or die $blog->errstr;
    }
}

sub add_breadcrumb {
    my $app = shift;
    push @{ $app->{breadcrumbs} }, {
        bc_name => $_[0],
        bc_uri => $_[1],
    }
}

sub is_authorized { 1 }

sub user_cookie { return $COOKIE_NAME }

sub user {
    my $app = shift;
    $app->{author};
}

sub session {
    my $app = shift;
    my $sess = $app->{session};
    return unless $sess;
    if (@_) {
        my $setting = shift;
        @_ ? $sess->set($setting, @_) : $sess->get($setting);
    } else {
        $sess;
    }
}

sub make_magic_token {
    my @alpha = ('a'..'z', 'A'..'Z', 0..9);
    my $token = join '', map $alpha[rand @alpha], 1..40;
    $token;
}

sub make_session {
    my $auth = shift;
    require MT::Session;
    my $sess = new MT::Session;
    $sess->id(make_magic_token());
    $sess->kind('US');  # US == User Session
    $sess->start(time);
    $sess->set('author_id', $auth->id);
    $sess->save;
    $sess;
}

# given credentials in the form of a username, optional password, and
# session ID ("token"), this returns the corresponding author object
# if the credentials are legit, 0 if insufficient credentials were there,
# or undef if they were actually incorrect
sub session_user {
    my $app = shift;
    my ($user, $pass, $session_id, %opt) = @_;

    return 0 unless $user && ($session_id || $pass);

    my $user_class = $app->{user_class};
    eval "use $user_class;";
    return $app->error($app->translate("Error loading [_1]: [_2]", $user_class, $@)) if $@;
    my $author = $user_class->load({ name => $user, type => AUTHOR });
    if (!$author) {
        require MT::Log;
        $app->log({
            message => $app->translate("Failed login attempt by unknown user '[_1]'", $user),
            level => MT::Log::WARNING(),
        });
        return undef;
    }


    if ($pass) {
        if ($author->is_valid_password($pass, $opt{already_crypted})) {
            return $author;
        } else {
            require MT::Log;
            $app->log({
                message => $app->translate("Failed login attempt with incorrect password by user '[_1]' (ID: [_2])", $user, $author->id),
                level => MT::Log::WARNING(),
            });
            return undef;
        }
    } elsif ($session_id) {
        require MT::Session;
        my $timeout = $opt{permanent} ? (360*24*365*10)
            : MT::ConfigMgr->instance->UserSessionTimeout;
        my $sess = MT::Session::get_unexpired_value($timeout,
                                                    { id => $session_id, 
                                                      kind => 'US' });
        $app->{session} = $sess;

        return 0 if !$sess;
        if ($sess && ($sess->get('author_id') == $author->id)) {
            return $author;
        } else {
            return undef;
        }
    }
}

sub start_session {
    my $app = shift;
    my ($author, $remember) = @_;
    if (!defined $author) {
        $author = $app->{author};
        my ($x, $y);
        ($x, $y, $remember) = split(/::/, $app->cookie_val($app->user_cookie));
    }
    my $session = make_session($author);
    my %arg = (-name => $COOKIE_NAME,
               -value => join('::',
                              $author->name,
                              $session->id,
                              $remember),
               -path => $app->config('CookiePath') || $app->mt_path
               );
    $arg{-expires} = '+10y' if $remember;
    $app->{session} = $session;
    $app->bake_cookie(%arg);
    \%arg;
}

# MT::App::login
#   Working from the query object, determine whether the session is logged in,
#   perform any session/cookie maintenance, and if we're logged in, 
#   return a pair
#     ($author, $first_time)
#   where $author is an author object and $first_time is true iff this
#   is the first request of a session. $first_time is returned just
#   for any plugins that might need it, since historically the logging
#   and session management was done by the calling code.

sub login {
    my $app = shift;
    my $q = $app->{query};
    my $cookies = $app->cookies;
    my($user, $pass, $remember, $crypted, $session_id);
    $remember = $q->param('remember') ? 1 : 0;
    if ($cookies->{$COOKIE_NAME}) {
        ($user, $session_id, $remember) = split /::/, $cookies->{$COOKIE_NAME}->value;
    }
    if ($q->param('username') && $q->param('password')) {
        $user = $q->param('username');
        $pass = $q->param('password');
    }

    my $author = $app->session_user($user, $pass, $session_id,
                                    permanent => $remember);       # FIXME: lame

    if ($author) {
        # Login valid
        $app->{author} = $app->{$COOKIE_NAME} = $author;
        if ($pass) {
            # Presence of 'password' indicates this is a login request;
            # do session/cookie management.
            $app->start_session($author, $remember);
            $app->request('fresh_login', 1);
            $app->log($app->translate("User '[_1]' (ID:[_2]) logged in successfully", $author->name, $author->id));
        }
        return ($author, defined($pass));
    } else {
        ## Login invalid, so get rid of cookie (if it exists) and let the
        ## user know.
        $app->clear_login_cookie;
        if (!defined($author)) {
            return $app->error($app->translate('Invalid login.'));
        } else {
            return undef;
        }
    }
}

sub logout {
    my $app = shift;
    if (my $user = $app->user) {
        $app->log($app->translate("User '[_1]' (ID:[_2]) logged out",
                                  $user->name, $user->id));
        $user->remove_sessions;
        delete $app->{author};
    }
    $app->clear_login_cookie;
    $app->build_page('login.tmpl', {logged_out => 1, no_breadcrumbs => 1});
}

sub clear_login_cookie {
    my $app = shift;
    $app->bake_cookie(-name => $COOKIE_NAME, -value => '', -expires => '-1y',
        -path => $app->config('CookiePath') || $app->mt_path);
}

sub request_content {
    my $app = shift;
    unless (exists $app->{request_content}) {
        if ($ENV{MOD_PERL}) {
            ## Read from $app->{apache}
            my $r = $app->{apache};
            my $len = $app->get_header('Content-length');
            $r->read($app->{request_content}, $len);
        } else {
            ## Read from STDIN
            my $len = $ENV{CONTENT_LENGTH} || 0;
            read STDIN, $app->{request_content}, $len;
        }
    }
    $app->{request_content};
}

sub get_header {
    my $app = shift;
    my($key) = @_;
    if ($ENV{MOD_PERL}) {
        return $app->{apache}->header_in($key);
    } else {
        ($key = uc($key)) =~ tr/-/_/;
        return $ENV{'HTTP_' . $key};
    }
}

sub set_header {
    my $app = shift;
    my($key, $val) = @_;
    if ($ENV{MOD_PERL}) {
        $app->{apache}->header_out($key, $val);
    } else {
        unless ($key =~ /^-/) {
            ($key = lc($key)) =~ tr/-/_/;
            $key = '-' . $key;
        }
        if ($key eq '-cookie') {
            push @{$app->{cgi_headers}{$key}}, $val;
        } else {
            $app->{cgi_headers}{$key} = $val;
        }
    }
}

sub request_method {
    my $app = shift;
    if (@_) {
        $app->{request_method} = shift;
    } elsif (!exists $app->{request_method}) {
        if ($ENV{MOD_PERL}) {
            $app->{request_method} = Apache->request->method;
        } else {
            $app->{request_method} = $ENV{REQUEST_METHOD};
        }
    }
    $app->{request_method};
}

sub cookie_val {
    my $app = shift;
    my $cookies = $app->cookies;
    if ($cookies && $cookies->{$_[0]}) {
        return $cookies->{$_[0]}->value() || "";
    }
    return "";
}

sub bake_cookie {
    my $app = shift;
    my %param = @_;
    my $cfg = $app->config;
    if ((!exists $param{'-secure'}) && $app->is_secure) {
        $param{'-secure'} = 1;
    }
    unless ($param{-path}) {
        $param{-path} = $cfg->CookiePath || $app->path;
    }
    if (!$param{-domain} && $cfg->CookieDomain) {
        $param{-domain} = $cfg->CookieDomain;
    }
    if ($ENV{MOD_PERL}) {
        require Apache::Cookie;
        my $cookie = Apache::Cookie->new($app->{apache}, %param);
        if ($param{-expires} && ($cookie->expires =~ m/%/)) {
            # Fix for oddball Apache::Cookie error reported on Windows.
            require CGI::Util;
            $cookie->expires(CGI::Util::expires($param{-expires}, 'cookie'));
        }
        $cookie->bake;
    } else {
        require CGI::Cookie;
        my $cookie = CGI::Cookie->new(%param);
        $app->set_header('-cookie', $cookie);
    }
}

sub cookies {
    my $app = shift;
    unless ($app->{cookies}) {
        my $class = $ENV{MOD_PERL} ? 'Apache::Cookie' : 'CGI::Cookie';
        eval "use $class;";
        $app->{cookies} = $class->fetch;
    }
    return wantarray ? %{ $app->{cookies} } : $app->{cookies}
        if $app->{cookies};
}

sub show_error {
    my $app = shift;
    my($error) = @_;
    my $tmpl;
    if ($MT::DebugMode && $@) {
        $error = '<pre>'.encode_html($error).'</pre>';
    } else {
        $error = encode_html($error);
    }
    $error =~ s!(http://\S+)!<a href="$1" target="_blank">$1</a>!g;
    $tmpl = $app->load_tmpl('error.tmpl') or
        return "Can't load error template; got error '" . $app->errstr .
               "'. Giving up. Original error was <pre>$error</pre>";
    $tmpl->param(ERROR => $error);
    $tmpl->param(GOBACK => $app->{goback} || 'history.back()');
    $app->l10n_filter($tmpl->output);
}

sub pre_run {
    my $app = shift;
    if (my $auth = $app->{author}) {
        $app->set_language($auth->column('preferred_language'))
            if $auth->column('preferred_language');
    }
    $app->{breadcrumbs} = [];
    MT->run_callbacks((ref $app) . '::pre_run', $app);
    1;
}

sub post_run { MT->run_callbacks((ref $_[0]) . '::post_run', $_[0]); 1 }

sub run {
    my $app = shift;
    my $q = $app->param;

    ## Add the Pragma: no-cache header.
    if ($ENV{MOD_PERL}) {
        $app->{apache}->no_cache(1);
    } else {
        $q->cache('no');
    }

    my($body);
    eval {
        if ($ENV{MOD_PERL}) {
            unless ($app->{no_read_body}) {
                my $status = $q->parse;
                unless ($status == Apache::Constants::OK()) {
                    die $app->translate('The file you uploaded is too large.') .
                        "\n<!--$status-->";
                }
            }
        } else {
            my $err;
            eval { $err = $q->cgi_error };
            unless ($@) {
                if ($err && $err =~ /^413/) {
                    die $app->translate('The file you uploaded is too large.') .
                        "\n";
                }
            }
        }

        REQUEST:
        {
            if ($app->{requires_login}) {
                my ($author) = $app->login;
                if (!$author || !$app->is_authorized) {
                    $body = $app->build_page('login.tmpl',{error => $app->errstr,
                                                           no_breadcrumbs => 1})
                        or $body = $app->show_error( $app->errstr );
                    last REQUEST;
                }
            }

            $app->pre_run;
            my $mode = $app->mode;
            $mode = 'default' unless defined $mode;
            my $code;
            if (my $meths = $Global_actions{ref($app)}) {
                $code = $meths->{$mode} if exists $meths->{$mode};
            }
            $code ||= $app->{vtbl}{$mode} if $app->{vtbl} && $mode;
            unless ($code) {
                my $meth = "mode_$mode";
                if ($app->can($meth)) {
                    no strict 'refs';
                    $code = \&{ *{ ref($app).'::'.$meth } };
                }
            }
            if ($code) {
                $body = $code->($app) if $code;
            } else {
                $app->error($app->translate('Unknown action [_1]', $mode));
            }
            $app->post_run;
            unless (defined $body || $app->{redirect} || $app->{login_again}) {
                if ($app->{no_print_body}) {
                    $app->print($app->errstr);
                } else {
                    $body = $app->show_error( $app->errstr );
                }
            }
        }  ## end REQUEST block
    };
    $body = $app->show_error($@) if $@;

    if ((!defined $body) && $app->{login_again}) {
        # login again!
        $body = $app->build_page('login.tmpl', {error => $app->errstr,
                                                no_breadcrumbs => 1})
            or $body = $app->show_error( $app->errstr );
    }

    if (my $url = $app->{redirect}) {
        if ($app->{redirect_use_meta}) {
            $app->send_http_header();
            $app->print('<meta http-equiv="refresh" content="0;url=' . 
                        $app->{redirect} . '">');
        } else {
            if ($ENV{MOD_PERL}) {
                $app->{apache}->header_out(Location => $url);
                $app->response_code(Apache::Constants::REDIRECT());
                $app->send_http_header;
            } else {
                print $q->redirect(-uri => $url, %{ $app->{cgi_headers} });
            }
        }
    } else {
        unless ($app->{no_print_body}) {
            $app->send_http_header;
            if ($MT::DebugMode) {
                if ($body =~ m!</body>!i) {
                    if ($app->{trace} &&
                        (!defined $app->{warning_trace} || $app->{warning_trace})) {
                        my $panel = "<div class=\"debug-panel\">" . encode_html($app->{trace}) . "</div>";
                        $body =~ s!(</body>)!$panel$1!i;
                    }
                }
            }
            $app->print($body);
        }
    }
    $app->takedown();
}

sub mode {
    my $app = shift;
    if (@_) {
        $app->{mode} = shift;
    } else {
        if (my $mode = $app->param('__mode')) {
            $mode =~ s/[<>"']//g;
            $app->{mode} ||= $mode;
        }
    }
    $app->{mode} || $app->{default_mode} || 'default';
}

sub takedown {
    my $app = shift;

    MT->run_callbacks('TakeDown', $app);   # arg is the app object

    $app->touch_blogs;

    my $sess = $app->session;
    $sess->save if $sess && $sess->is_dirty;

    my $driver = $MT::Object::DRIVER;
    $driver->clear_cache if $driver;

    $app->request->finish;
    delete $app->{request};
    delete $app->{cookies};
    $app->{request_read_config} = 1;
}

sub l10n_filter { $_[0]->translate_templatized($_[1]) }

sub template_paths {
    my $app = shift;
    my @paths;
    my $path = $app->config('TemplatePath');
    if ($app->{plugin_template_path}) {
        if (File::Spec->file_name_is_absolute($app->{plugin_template_path})) {
            push @paths, $app->{plugin_template_path}
                if -d $app->{plugin_template_path};
        } else {
            my $dir = File::Spec->catdir($app->app_dir,
                                         $app->{plugin_template_path}); 
            if (-d $dir) {
                push @paths, $dir;
            } else {
                $dir = File::Spec->catdir($app->mt_dir,
                                          $app->{plugin_template_path});
                push @paths, $dir if -d $dir;
            }
        }
    }
    if (my $alt_path = $app->config('AltTemplatePath')) {
        if (-d $alt_path) {    # AltTemplatePath is absolute
            push @paths, File::Spec->catdir($alt_path,
                                            $app->{template_dir})
                if $app->{template_dir};
            push @paths, $alt_path;
        }
    }
    push @paths, File::Spec->catdir($path, $app->{template_dir})
        if $app->{template_dir};
    push @paths, $path;
    @paths;
}

sub find_file {
    my $app = shift;
    my ($paths, $file) = @_;
    my $filename;
    foreach my $p (@$paths) {
        my $filepath = File::Spec->canonpath(File::Spec->catfile($p, $file));
        $filename = File::Spec->canonpath($filepath);
        return $filename if -f $filename;
    }
    undef;
}

sub load_tmpl {
    my $app = shift;
    my($file, @p) = @_;
    my $cfg = $app->config;
    require HTML::Template;
    my $tmpl;
    my $err;
    my @paths = $app->template_paths;

    my $cache_dir;
    if (!$app->config('NoLocking')) {
        my $path = $cfg->TemplatePath;
        $cache_dir = File::Spec->catdir($path, 'cache');
        undef $cache_dir if (!-d $cache_dir) || (!-w $cache_dir);
    }

    my $type = {'SCALAR' => 'scalarref', 'ARRAY' => 'arrayref'}->{ref $file}
        || 'filename';
    eval {
        $tmpl = HTML::Template->new(
            type => $type, source => $file,
            path => \@paths,
            search_path_on_include => 1,
            die_on_bad_params => 0, global_vars => 1,
            loop_context_vars => 1,
            $cache_dir ? (file_cache_dir => $cache_dir, file_cache => 1,
                          file_cache_dir_mode => 0777) : (),
            filter => sub {
                my $fname = $HTML::Template::this_file;
                if ($fname) {
                    $fname = File::Basename::basename($fname);
                    $fname =~ s/\.tmpl$//;
                    $app->run_callbacks(ref($app) . "::AppTemplateSource.$fname", $app, $_[0]);
                } else {
                    $app->run_callbacks(ref($app)."::AppTemplateSource", $app, $_[0]);
                }
                $_[0];
            },
            @p);
    };
    $err = $@;
    return $app->error(
        $app->translate("Loading template '[_1]' failed: [_2]", $file, $err))
        if $err;
    $app->set_default_tmpl_params($tmpl);
    $tmpl;
}

sub set_default_tmpl_params {
    my $app = shift;
    my ($tmpl) = @_;
    if (my $author = $app->user) {
        $tmpl->param(author_id => $author->id);
        $tmpl->param(author_name => $author->name);
    }
    ## We do this in load_tmpl because show_error and login don't call
    ## build_page; so we need to set these variables here.
    $tmpl->param(static_uri => $app->static_path);
    $tmpl->param(script_url => $app->uri);
    $tmpl->param(mt_url => $app->mt_uri);
    $tmpl->param(script_path => $app->path);
    $tmpl->param(script_full_url => $app->base . $app->uri);
    $tmpl->param(mt_version => MT->version_id);
    $tmpl->param(mt_product_code => MT->product_code);
    $tmpl->param(mt_product_name => $app->translate(MT->product_name));
    my $lang = $app->current_language;
    $tmpl->param(language_tag => $lang);
    $lang =~ s/[-_].+//;
    $tmpl->param("language_$lang" => 1);
    $tmpl->param(language_encoding => $app->charset);
}

sub process_mt_template {
    my $app = shift;
    my ($body) = @_;
    $body =~ s@<MT_ACTION\s+mode="(\w+)"(?:\s+([^>]*))?>@
        my $mode = $1; my %args;
        %args = $2 =~ m/\s*(\w+)="([^"]*?)"\s*/g if defined $2; # "
        MT::Util::encode_html($app->uri(mode => $mode, args => \%args));
    @ge;
    # Strip out placeholder wrappers to facilitate tmpl_* callbacks
    $body =~ s/<\/?MT_(\w+):(\w+)>//g;
    $body;
}

sub tmpl_prepend {
    my $app = shift;
    my ($tmpl, $section, $id, $content) = @_;
    $$tmpl =~ s/(<MT_\U$section:$id>)/$1$content/;
}

sub tmpl_replace {
    my $app = shift;
    my ($tmpl, $section, $id, $content) = @_;
    $$tmpl =~ s/(<MT_\U$section:$id>).*?(<\/MT_\U$section:$id>)/$1$content$2/s;
}

sub tmpl_append {
    my $app = shift;
    my ($tmpl, $section, $id, $content) = @_;
    $$tmpl =~ s/(<\/MT_\U$section:$id>)/$content$1/;
}

sub tmpl_select {
    my $app = shift;
    my ($tmpl, $section, $id) = @_;
    $$tmpl =~ m/<MT_\U$section:$id>(.*?)<\/MT_\U$section:$id>/s ? $1 : '';
}

sub build_page {
    my $app = shift;
    my($file, $param) = @_;
    my $tmpl;
    my $mode = $app->mode;
    $param->{"mode_$mode"} ||= 1;
    $param->{breadcrumbs} = $app->{breadcrumbs};
    if ($param->{breadcrumbs}[-1]) {
        $param->{breadcrumbs}[-1]{is_last} = 1;
        $param->{page_titles} = [ reverse @{ $app->{breadcrumbs} } ];
    }
    pop @{ $param->{page_titles} };
    if (my $lang_id = $app->current_language) {
        $param->{local_lang_id} ||= lc $lang_id if $lang_id !~ m/^en/i;
    }
    $param->{magic_token} = $app->current_magic if $app->{author};
    my $tmpl_file;
    if (UNIVERSAL::isa($file, 'HTML::Template')) {
        $tmpl = $file;
        $app->run_callbacks(ref($app) . '::AppTemplateParam', $app, $param, $tmpl);
    } else {
        $tmpl = $app->load_tmpl($file) or return;
        $tmpl_file = $file;
        $tmpl_file =~ s/\.tmpl$//;
        $app->run_callbacks(ref($app) . '::AppTemplateParam.' . $tmpl_file, $app, $param, $tmpl);
    }
    if (($mode && ($mode !~ m/delete/)) && ($app->{login_again} ||
        ($app->{requires_login} && !$app->{author}))) {
        ## If it's a login screen, direct the user to where they were going
        ## (query params including mode and all) unless they were logging in,
        ## logging out, or deleting something.
        my $q = $app->{query};
        if ($mode) {
            my @query = map { {name => $_, value => scalar $q->param($_)}; }
                grep { ($_ ne 'username') && ($_ ne 'password') && ($_ ne 'submit') } $q->param;
            $param->{query_params} = \@query;
        }
        $param->{login_again} = $app->{login_again};
    }
    my $output = $app->build_page_in_mem($tmpl, $param);
    if ($tmpl_file) {
        $app->run_callbacks(ref($app) . '::AppTemplateOutput.'.$tmpl_file, $app, \$output, $param, $tmpl);
    } else {
        $app->run_callbacks(ref($app) . '::AppTemplateOutput', $app, \$output, $param, $tmpl);
    }
    $output;
}

sub build_page_in_mem {
    my $app = shift;
    my($tmpl, $param) = @_;
    $tmpl->param(%$param);
    $app->translate_templatized($app->process_mt_template($tmpl->output));
}

sub current_magic {
    my $app = shift;
    my $sess = $app->session;
    return ($sess ? $sess->id : undef);
}

sub validate_magic {
    my $app = shift;
    return 1
        if ($app->param('username') && $app->param('password')
            && $app->request('fresh_login') == 1);
    $app->{login_again} = 1, return undef
        unless $app->current_magic eq $app->param('magic_token');;
    1;
}

sub delete_param {
    my $app = shift;
    my($key) = @_;
    my $q = $app->{query};
    return unless $q;
    if ($ENV{MOD_PERL}) {
        my $tab = $q->parms;
        $tab->unset($key);
    } else {
        $q->delete($key);
    }
}

sub param_hash {
    my $app = shift;
    my $q = $app->{query};
    return () unless $q;
    my @params = $q->param();
    my %result;
    foreach my $p (@params) {
        $result{$p} = $q->param($p);
    }
    %result;
}

## Path/server/script-name determination methods

sub query_string {
    my $app = shift;
    $ENV{MOD_PERL} ? $app->{apache}->args : $app->{query}->query_string;
}

sub return_uri {
    $_[0]->uri . '?' . $_[0]->return_args;
}

sub call_return {
    my $app = shift;
    $app->add_return_arg(@_) if @_;
    $app->redirect($app->return_uri);
}

sub state_params {
    my $app = shift;
    return $app->{state_params} ? @{ $app->{state_params} } : ();
}

# make_return_args 
# Creates a query string that refers to the same view as the one we're
# already rendering.
sub make_return_args {
    my $app = shift;

    my @vars = $app->state_params;
    my %args;
    foreach my $v (@vars) {
        if (my @p = $app->param($v)) {
            $args{$v} = (scalar @p > 1 && $v eq 'filter_val') ? \@p : $p[0];
        }
    }
    my $return = $app->uri_params(mode => $app->mode, 'args' => \%args);
    $return =~ s/^\?//;
    $return;
}

sub return_args {
    $_[0]->{return_args} = $_[1] if $_[1];
    $_[0]->{return_args};
}

sub add_return_arg {
    my $app = shift;
    if (scalar @_ == 1) {
        $app->{return_args} .= '&' . shift;
    } else {
        my (%args) = @_;
        foreach my $a (sort keys %args) {
            if (ref $args{$a} eq 'ARRAY') {
                $app->{return_args} .= '&' . $a . '=' . encode_url($_) foreach @{$args{$a}};
            } else {
                $app->{return_args} .= '&' . $a . '=' . encode_url($args{$a});
            }
        }
    }
}

sub base {
    my $app = shift;
    return $app->{__host} if exists $app->{__host};
    my $cfg = $app->config;
    my $path = $app->{is_admin} ?
        ($cfg->AdminCGIPath || $cfg->CGIPath) :
        $cfg->CGIPath;
    if ($path =~ m!^(https?://[^/]+)!i) {
        (my $host = $1) =~ s!/$!!;
        return $app->{__host} = $host;
    }
    # determine hostname from environment (supports relative CGI paths)
    if (my $host = $ENV{HTTP_HOST}) {
        return $app->{__host} = 'http' . ($app->is_secure ? 's' : '') . '://' . $host;
    }
    '';
}

*path = \&mt_path;
sub mt_path {
    my $app = shift;
    return $app->{__mt_path} if exists $app->{__mt_path};

    my $cfg = $app->config;
    my $path;
    $path = $app->{is_admin} ?
        ($cfg->AdminCGIPath || $cfg->CGIPath) :
        $cfg->CGIPath;
    if ($path =~ m!^https?://[^/]+(/?.*)$!i) {
        $path = $1;
    } elsif (!$path) {
        $path = '/';
    }
    $path .= '/' unless substr($path, -1, 1) eq '/';
    $app->{__mt_path} = $path;
}

sub app_path {
    my $app = shift;
    return $app->{__path} if exists $app->{__path};

    my $path;
    if ($ENV{MOD_PERL}) {
        $path = $app->{apache}->uri;
        $path =~ s!/[^/]*$!!;
    } elsif ($app->{query}) {
        $path = $app->{query}->url;
        $path =~ s!/[^/]*$!!;
        $path =~ s/%40/@/;    # '@' within path is okay
    } else {
        $path = $app->mt_path;
    }
    if ($path =~ m!^https?://[^/]+(/?.*)$!i) {
        $path = $1;
    } elsif (!$path) {
        $path = '/';
    }
    $path .= '/' unless substr($path, -1, 1) eq '/';
    $app->{__path} = $path;
}

sub envelope { '' }

sub static_path {
    my $app = shift;
    my $spath = $app->config('StaticWebPath');
    if (!$spath) {
        $spath = $app->path . 'mt-static/';
    } else {
        $spath .= '/' unless $spath =~ m!/$!;
    }
    $spath;
}

sub script {
    my $app = shift;
    return $app->{__script} if exists $app->{__script};
    my $script = $ENV{MOD_PERL} ? $app->{apache}->uri : $ENV{SCRIPT_NAME};
    if (!$script) {
        require File::Basename; import File::Basename qw(basename);
        $script = basename($0);
    }
    $script =~ s!/$!!;
    $script = (split /\//, $script)[-1];
    $app->{__script} = $script;
}

sub uri {
    my $app = shift;
    $app->{is_admin} ? $app->mt_uri(@_) : $app->app_uri(@_);
}
sub app_uri {
    my $app = shift;
    $app->app_path . $app->script . $app->uri_params(@_);
}
        # app_uri refers to the active app script
sub mt_uri {
    my $app = shift;
    $app->mt_path . MT::ConfigMgr->instance->AdminScript . $app->uri_params(@_);
}
        # mt_uri refers to mt's script even if we're in a plugin.
sub uri_params {
    my $app = shift;
    my (%param) = @_;
    my @params;
    push @params, '__mode=' . $param{mode} if $param{mode};
    if ($param{args}) {
        foreach my $p (keys %{$param{args}}) {
            if (ref $param{args}{$p}) {
                push @params, ($p . '=' . encode_url($_)) foreach @{$param{args}{$p}};
            } else {
                push @params, ($p . '=' . encode_url($param{args}{$p}));
            }
        }
    }
    @params ? '?' . (join '&', @params) : '';
}

sub path_info {
    my $app = shift;
    return $app->{__path_info} if exists $app->{__path_info};
    my $path_info;
    if ($ENV{MOD_PERL}) {
        ## mod_perl often leaves part of the script name (Location)
        ## in the path info, for some reason. This should remove it.
        $path_info = $app->{apache}->path_info;
        if ($path_info) {
            my($script_last) = $app->{apache}->location =~ m!/([^/]+)$!;
            $path_info =~ s!^/$script_last!!;
        }
    } else {
        $path_info = $app->{query}->path_info;
    }
    $app->{__path_info} = $path_info;
}

sub is_secure {
    my $app = shift;
    $ENV{MOD_PERL} ? $app->{apache}->subprocess_env('https') :
        $app->{query}->protocol() eq 'https';
}

sub redirect {
    my $app = shift;
    my($url, %options) = @_;
    $app->{redirect_use_meta} = $options{UseMeta};
    unless ($url =~ m!^https?://!i) {
        $url = $app->base . $url;
    }
    $app->{redirect} = $url;
    return;
}

sub param {
    my $app = shift;
    return unless $app->{query};
    if (@_) {
        $app->{query}->param(@_);
    } else {
        wantarray ? ( $app->{query}->param ) : $app->{query};
    }
}

sub blog {
    my $app = shift;
    $app->{_blog} = shift if @_;
    return $app->{_blog} if $app->{_blog};
    return undef unless $app->{query};
    my $blog_id = $app->param('blog_id');
    if ($blog_id) {
        $app->{_blog} = MT::Blog->load($blog_id, {cached_ok=>1});
    }
    return $app->{_blog};
}

## Logging/tracing

sub log {
    my $app = shift;
    my($msg) = @_;
    require MT::Log;
    my $log = MT::Log->new;
    if (ref $msg eq 'HASH') {
        $log->set_values($msg);
        $msg = $msg->{'message'} || '';
    } elsif ((ref $msg) && (UNIVERSAL::isa($msg, 'MT::Log'))) {
        $log = $msg;
    } else {
        $log->message($msg);
    }
    $log->ip($app->remote_ip);
    if (my $blog = $app->blog) {
        $log->blog_id($blog->id);
    }
    if (my $user = $app->user) {
        $log->author_id($user->id);
    }
    $log->level(MT::Log::INFO())
        unless defined $log->level;
    $log->class('system')
        unless defined $log->class;
    $log->save;
}

sub trace {
    my $app = shift;
    $app->{trace} .= "@_";
    if ($MT::DebugMode & 2) {
        require Carp;
        $app->{trace} .= Carp::longmess("Stack trace:");
    }
}

sub remote_ip {
    my $app = shift;
    my $ip = $TransparentProxyIPs
        ? $app->get_header('X-Forwarded-For')
        : ($ENV{MOD_PERL}
           ? $app->{apache}->connection->remote_ip
           : $ENV{REMOTE_ADDR});
    $ip ||= '127.0.0.1';
    if ($ip =~ m/,/) {
        $ip =~ s/.+,\s*//;
    }
    $ip;
}

sub errtrans {
    my $app = shift;
    $app->error($app->translate(@_));
}

sub DESTROY {
    ## Destroy the Request object, which is used for caching
    ## per-request data. We have to do this manually, because in
    ## a persistent environment, the object will not go out of scope.
    ## Same with the ConfigMgr object and ObjectDriver.
    MT::Request->finish();
    undef $MT::Object::DRIVER;
    undef $MT::ConfigMgr::cfg;
}

1;
__END__

=head1 NAME

MT::App - Movable Type base web application class

=head1 SYNOPSIS

    package MT::App::Foo;
    use MT::App;
    @MT::App::Foo::ISA = qw( MT::App );

    package main;
    my $app = MT::App::Foo->new;
    $app->run;

=head1 DESCRIPTION

L<MT::App> is the base class for Movable Type web applications. It provides
support for an application running using standard CGI, or under
L<Apache::Registry>, or as a L<mod_perl> handler. L<MT::App> is not meant to
be used directly, but rather as a base class for other web applications using
the Movable Type framework (for example, L<MT::App::CMS>).

=head1 USAGE

L<MT::App> subclasses the L<MT> class, which provides it access to the
publishing methods in that class.

=head1 CALLBACKS

=over 4

=item <package>::AppTemplateSource

=item <package>::AppTemplateSource.<filename>

	callback($eh, $app, \$tmpl)

Executed after loading the HTML::Template file.  The E<lt>packageE<gt> portion
is the full package name of the application running. For example,

	MT::App::CMS::AppTemplateSource.menu

Is the full callback name for loading the menu.tmpl file under the
L<MT::App::CMS> application. The "MT::App::CMS::AppTemplateSource" callback is
also invoked for all templates loading by the CMS.  Finally, you can also hook
into:

	*::AppTemplateSource

as a wildcard callback name to capture any C<HTML::Template> files that are 
loaded regardless of application.

=item <package>::AppTemplateParam

=item <package>::AppTemplateParam.<filename>

	callback($eh, $app, \%param, $tmpl)

This callback is invoked in conjunction with the MT::App-E<gt>build_page
method. The $param argument is a hashref of L<HTML::Template> parameter
data that will eventually be passed to the template to produce the page.

=item <package>::AppTemplateOutput

=item <package>::AppTemplateOutput.<filename>

	callback($eh, $app, \$tmpl_str, \%param, $tmpl)

This callback is invoked in conjunction with the MT::App-E<gt>build_page
method. The C<$tmpl_str> parameter is a string reference for the page that
was built by the MT::App-E<gt>build_page method. Since it is a reference,
it can be modified by the callback. The C<$param> parameter is a hash reference to the parameter data that was given to build the page. The C<$tmpl>
parameter is the L<HTML::Template> object used to generate the page.

=back

=head1 METHODS

Following are the list of methods specific to L<MT::App>:

=head2 MT::App->new

Constructs and returns a new L<MT::App> object.

=head2 $app->init_request

Invoked at the start of each request. This method is a good place to
initialize any settings that are request-specific. When overriding this
method, B<always> call the superclass C<init_request> method.

One such setting is the C<requires_login> member element that controls
whether the active application mode requires the user to login first.

Example:

    sub init_request {
        my $app = shift;
        $app->SUPER::init_request(@_);
        $app->{requires_login} = 1 unless $app->mode eq 'unprotected';
    }

=head2 $app->run

Runs the application. This gathers the input, chooses the method to execute,
executes it, and prints the output to the client.

If an error occurs during the execution of the application, L<run> handles all
of the errors thrown either through the L<MT::ErrorHandler> or through C<die>.

=head2 $app->login

Checks the user's credentials, first by looking for a login cookie, then by
looking for the C<username> and C<password> CGI parameters. In both cases,
the username and password are verified for validity. This method does not set
the user's login cookie, however--that should be done by the caller (in most
cases, the caller is the L<run> method).

On success, returns the L<MT::Author> object representing the author who logged
in, and a boolean flag; if the boolean flag is true, it indicates the the login
credentials were obtained from the CGI parameters, and thus that a cookie
should be set by the caller. If the flag is false, the credentials came from
an existing cookie.

On an authentication error, L<login> removes any authentication cookies that
the user might have on his or her browser, then returns C<undef>, and the
error message can be obtained from C<$app-E<gt>errstr>.

=head2 $app->logout

A handler method for logging the user out of the application.

=head2 $app->send_http_header([ $content_type ])

Sends the HTTP header to the client; if C<$content_type> is specified, the
I<Content-Type> header is set to C<$content_type>. Otherwise, C<text/html> is
used as the default.

In a L<mod_perl> context, this calls the L<Apache::send_http_header> method;
in a CGI context, the L<CGI::header> method is called.

=head2 $app->print(@data)

Sends data C<@data> to the client.

In a L<mod_perl> context, this calls the L<Apache::print> method; in a CGI
context, data is printed directly to STDOUT.

=head2 $app->bake_cookie(%arg)

Bakes a cookie to be sent to the client.

C<%arg> can contain any valid parameters to the C<new> methods of
L<CGI::Cookie> (or L<Apache::Cookie>--both take the same parameters). These
include C<-name>, C<-value>, C<-path>, C<-secure>, and C<-expires>.

If you do not include the C<-path> parameter in C<%arg>, it will be set
automatically to C<$app-E<gt>path> (below).

In a L<mod_perl> context, this method uses L<Apache::Cookie>; in a CGI context,
it uses L<CGI::Cookie>.

This method will automatically assign a "secure" flag for the cookie if it the current HTTP request is using the https protocol. To forcibly disable the secure flag, provide a C<-secure> argument with a value of 0.

=head2 $app->cookies

Returns a reference to a hash containing cookie objects, where the objects are
either of class L<Apache::Cookie> (in a L<mod_perl> context) or L<CGI::Cookie>
(in a CGI context).

=head2 $app->user_cookie

Returns the string of the cookie name used for the user login cookie.

=head2 $app->user

Returns the object of the logged in user. Typically a L<MT::Author>
object.

=head2 $app->clear_login_cookie

Sends a cookie back to the user's browser which clears their existing
authenication cookie.

=head2 $app->current_magic

Returns the active user's "magic token" which is used to validate posted data
with the C<validate_magic> method.

=head2 $app->make_magic_token

Creates a new "magic token" string which is a random set of characters.
The 

=head2 $app->load_tmpl($file[, @params])

Loads a L<HTML::Template> template using the filename specified. See the
documentation for the C<build_page> method to learn about how templates
are located. The optional C<@params> are passed to the L<HTML::Template>
constructor.

=head2 $app->charset

Gets or sets the application's character set based on the "PublishCharset"
configuration setting or the encoding of the active language
(C<$app-E<gt>current_language>).

=head2 $app->add_return_arg(%param)

Adds one or more arguments to the list of 'return' arguments that are
use to construct a return URL.

Example:

    $app->add_return_arg(finished_task => 1)
    $app->call_return;

This will redirect the user back to the URL they came from, adding a
new 'finished_task' query parameter to the URL.

=head2 $app->call_return

Invokes C<$app-E<gt>redirect> using the C<$app-E<gt>return_uri> method
as the address.

=head2 $app->make_return_args

Constructs the list of return arguments using the
data available from C<$app-E<gt>state_params> and C<$app->E<gt>mode>.

=head2 $app->mode([$mode])

Gets or sets the active application run mode.

=head2 $app->state_params

Returns a list of the parameter names that preserve the given state
of the application. These are declared during the application's C<init>
method, using the C<state_params> member element.

Example:

    $app->{state_params} = ['filter','page','blog_id'];

=head2 $app->return_args([$args])

Gets or sets a string containing query parameters which is used by
C<return_uri> in constructing a 'return' address for the current
request.

=head2 $app->return_uri

Returns a string composed of the C<$app-E<gt>uri> and the
C<$app-E<gt>return_args>.

=head2 $app->uri_params(%param)

A utility method that assembles the query portion of a URI, taking
a mode and set of parameters. The string returned does include the '?'
character if query parameters exist.

Example:

    my $query_str = $app->uri_params(mode => 'go',
                                     args => { 'this' => 'that' });
    # $query_str == '?__mode=go&this=that'

=head2 $app->session([$element[,$value]])

Returns the active user's session object. This also acts as a get/set
method for assigning arbitrary data into the user's session record.
At the end of the active request, any unsaved session data is written
to the L<MT::Session> record.

Example:

    # saves the value of a 'color' parameter into the user's session
    # this value will persist from one request to the next, but will
    # be cleared when the user logs out or has to reauthenicate.
    $app->session('color', $app->param('color'))

=head2 $app->start_session

Initializes a new user session by both calling C<make_session> and
setting the user's login cookie.

=head2 $app->make_session

Creates a new user session MT::Session record for the active user.

=head2 $app->show_error($error)

Handles the display of an application error.

=head2 $app->static_path

Returns the application's static web path.

=head2 $app->takedown

Called at the end of the web request for cleanup purposes.

=head2 $app->add_breadcrumb($name, $uri)

Adds to the navigation history path that is displayed to the end user when
using the application.  The last breadcrumb should always be a reference to
the active mode of the application. Example:

    $app->add_breadcrumb('Edit Foo',
        $app->uri_params(mode => 'edit',
                         args => { '_type' => 'foo' }));

=head2 $app->add_methods(%arg)

Used to supply the application class with a list of available run modes and
the code references for each of them. C<%arg> should be a hash list of
methods and the code reference for it. Example:

    $app->add_methods(
        'one' => \&one,
        'two' => \&two,
        'three' => \&three,
    );

=head2 $app->add_plugin_action($where, $action_link, $link_text)

Adds a link to the given plugin action from the location specified by
$where. This allows plugins to create actions that apply to, for
example, the entry which the user is editing. The type of object the
user was editing, and its ID, are passed as parameters.

Values that are used from the $where parameter are as follows:

=over 4

=item * list_entries

=item * list_commenters

=item * list_comments

=item * <type>
(Where <type> is any object that the user can already edit, such as
'entry,' 'comment,' 'commenter,' 'blog,' etc.)

=back

The C<$where> value will be passed to the given action_link as a CGI
parameter called C<from>. For example, on the list_entries page, a
link will appear to:

    <action_link>&from=list_entries

If the $where is a single-item page, such as an entry-editing page,
then the action_link will also receive a CGI parameter C<id> whose
value is the ID of the object under consideration:

    <action_link>&from=entry&id=<entry-id>

Note that the link is always formed by appending an ampersand. Thus,
if your $action_link is simply the name of a CGI script, such as
my-plugin.cgi, you'll want to append a '?' to the argument you pass:

    MT->add_plugin_action('entry', 'my-plugin.cgi?', \
                          'Touch this entry with MyPlugin')

Finally, the $link_text parameter specifies the text of the link; this
value will be wrapped in E<lt>a> tags that point to the $action_link.

=head2 $app->app_path

Returns the path portion of the active URI.

=head2 $app->app_uri

Returns the current application's URI.

=head2 $app->mt_path

Returns the path portion of the URI that is used for accessing the MT CGI
scripts.

=head2 $app->mt_uri

Returns the full URI of the MT "admin" script (typically a reference to
mt.cgi).

=head2 $app->blog

Returns the active weblog, if available. The I<blog_id> query
parameter identifies this weblog.

=head2 $app->build_page($tmpl_name, \%param)

Builds an application page to be sent to the client; the page name is specified
in C<$tmpl_name>, which should be the name of a template containing valid
L<HTML::Template> markup. C<\%param> is a hash ref whose keys and values will
be passed to L<HTML::Template::param> for use in the template.

On success, returns a scalar containing the page to be sent to the client. On
failure, returns C<undef>, and the error message can be obtained from
C<$app-E<gt>errstr>.

=head2 How does build_page find a template?

The C<build_page> function looks in several places for an app
template. Two configuration directives can modify these search paths,
and application and plugin code can also affect them.

The I<TemplatePath> config directive is an absolute path to the directory
where MT's core application templates live. It defaults to the I<mt_dir>
plus an additional path segment of 'tmpl'.

The optional I<AltTemplatePath> config directive is a path (absolute
or relative) to a directory where some 'override templates' may
live. An override template takes the place of one of MT's core
application templates, and is used interchangeably with the core
template. This allows power users to customize the look and feel of
the MT application. If I<AltTemplatePath> is relative, its base path
is the value of the Movable Type configuration file.

Next, any application built on the C<MT::App> foundation can define
its own I<template_dir> parameter, which identifies a subdirectory of
TemplatePath (or AltTemplatePath) where that application's templates
can be found. I<template_dir> defaults to C<cms>. Most templates will
be found in this directory, but sometimes the template search will
fall through to the parent directory, where a default error template
is found, for example. I<template_dir> should rightly have been named
I<application_template_dir>, since it is application-specific.

Finally, a plugin can specify its I<plugin_template_path>, which
locates a directory where the templates for that plugin's own
interface are found. If the I<plugin_template_path> is relative, it
may be relative to either the I<app_dir>, or the I<mt_dir>; the former
takes precedence if it exists. (for a definition of I<app_dir> and
I<mt_dir>, see L<perldoc MT>)

Given these values, the order of search is as follows:

=over 4

=item * I<plugin_template_path>

=item * I<AltTemplatePath>

=item * I<AltTemplatePath>F</>I<template_dir>

=item * I<TemplatePath>/I<template_dir>

=item * I<TemplatePath>

=back

If a template with the given name is not found in any of these
locations, an ugly error is thrown to the user.

=head2 $app->cookie_val($name)

Returns the value of a given cookie.

=head2 $app->delete_param($param)

Clears the value of a given CGI parameter.

=head2 $app->errtrans($msg[, @param])

Translates the C<$msg> text, passing through C<@param> for any parameters
within the message. This also sets the error state of the application,
assinging the translated text as the error message.

=head2 $app->get_header($header)

Returns the value of the specified HTTP header.

=head2 MT::App->handler

The mod_perl handler used when the application is run as a native
mod_perl handler.

=head2 $app->init(@param)

Initializes the application object, setting default values and establishing
the parameters necessary to run.  The @param values are passed through
to the parent class, the C<MT> package.

This method needs to be invoked by any subclass when the object is
initialized.

=head2 $app->is_authorized

Returns a true value if the active user is authorized to access the
application. By default, this always returns true; subclasses may
override it to check app-specific authorization. A login attempt will
be rejected with a generic error message at the MT::App level, if
is_authorized returns false, but MT::App subclasses may wish to
perform additional checks which produce more specific error messages.

Subclass authors can assume that $app->{author} is populated with the
authenticated user when this routine is invoked, and that CGI query
object is available through $app->{query} and $app->param().

=head2 $app->is_secure

Returns a boolean result based on whether the application request is
happening over a secure (HTTPS) connection.

=head2 $app->l10n_filter

Alias for C<MT-E<gt>translate_templatized>.

=head2 $app->param($name[, $value])

Interface for getting and setting CGI query parameters. Example:

    my $title = $app->param('entry_title');

Versions of MT before 3.16 did not support the MT::App::param()
method. In that environment, $app->{query} is a CGI object whose
C<param> method works identically with this one.

=head2 $app->param_hash

Returns a hash reference containing all of the query parameter names
and their values. Example:

    my $data = $app->param_hash;
    my $title = $data->{entry_title};

=head2 $app->post_run

This method is invoked, with no parameters, immediately following the
execution of the requested C<__mode> handler. Its return value is ignored.

C<post_run> will be invoked whether or not the C<__mode> handler returns an
error state through the MT::ErrorHandler mechanism, but it will not be
invoked if the handler C<die>s.

App subclasses can override this method with tasks to be executed
after any C<__mode> handler but before the page is delivered to the
client. Such a method should invoke C<SUPER::post_run> to ensure that
MT's core post-run tasks are executed.

=head2 $app->pre_run

This method is invoked, with no parameters, before dispatching to the
requested C<__mode> handler. Its return value is ignored.

C<pre_run> is not invoked if the request could not be authenticated.
If C<pre_run> is invoked and does not C<die>, the C<__mode> handler
B<will> be invoked.

App subclasses can override this method with tasks to be executed
before, and regardless of, the C<__mode> specified in the
request. Such an overriding method should invoke C<SUPER::pre_run> to
ensure that MT's core pre-run tasks are executed.

=head2 $app->query_string

Returns the CGI query string of the active request.

=head2 $app->request_content

Returns a scalar containing the POSTed data of the active HTTP
request. This will force the request body to be read, even if
$app->{no_read_body} is true. TBD: document no_read_body.

=head2 $app->request_method

Returns the method of the active HTTP request, typically either "GET"
or "POST".

=head2 $app->response_content_type([$type])

Gets or sets the HTTP response Content-Type header.

=head2 $app->response_code([$code])

Gets or sets the HTTP response code: the numerical value that begins
the "status line." Defaults to 200.

=head2 $app->response_message([$message])

Gets or sets the HTTP response message, better known as the "reason
phrase" of the "status line." E.g., if these calls were executed:

   $app->response_code("404");
   $app->response_message("Thingy Not Found");

This status line might be returned to the client:

   404 Thingy Not Found

By default, the reason phrase is an empty string, but an appropriate
reason phrase may be assigned by the webserver based on the response
code.

=head2 $app->set_header($name, $value)

Adds an HTTP header to the response with the given name and value.

=head2 $app->validate_magic

Checks for a I<magic_token> HTTP parameter and validates it for the current
author.  If it is invalid, an error message is assigned to the application
and a false result is returned. If it is valid, it returns 1. Example:

    return unless $app->validate_magic;

To populate a form with a valid magic token, place the token value in a
hidden form field:

    <input type="hidden" name="magic_token" value="<TMPL_VAR NAME=MAGIC_TOKEN>" />

If you're protecting a hyperlink, add the token to the query parameters
for that link.

=head2 $app->redirect($url, [option1 => option1_val, ...])

Redirects the client to the URL C<$url>. If C<$url> is not an absolute
URL, it is prepended with the value of C<$app-E<gt>base>.

By default, the redirection is accomplished by means of a Location
header and a 302 Redirect response.

If the option C<UseMeta =E<gt> 1> is given, the request will be redirected
by issuing a text/html entity body that contains a "meta redirect"
tag. This option can be used to work around clients that won't accept
cookies as part of a 302 Redirect response.

=head2 $app->base

The protocol and domain of the application. For example, with the full URI
F<http://www.foo.com/mt/mt.cgi>, this method will return F<http://www.foo.com>.

=head2 $app->path

The path component of the URL of the application directory. For
example, with the full URL F<http://www.foo.com/mt/mt.cgi>, this
method will return F</mt/>.

=head2 $app->script

In CGI mode, the filename of the active CGI script. For example, with
the full URL F<http://www.foo.com/mt/mt.cgi>, this method will return
F<mt.cgi>.

In mod_perl mode, the Request-URI without any query string.

=head2 $app->uri([%params])

The concatenation of C<$app-E<gt>path> and C<$app-E<gt>script>. For example,
with the full URI F<http://www.foo.com/mt/mt.cgi>, this method will return
F</mt/mt.cgi>. If C<%params> exist, they are passed to the
C<$app-E<gt>uri_params> method for processing.

Example:

    return $app->redirect($app->uri(mode => 'go', args => {'this'=>'that'}));

=head2 $app->path_info

The path_info for the request (that is, whatever is left in the URI
after removing the path to the script itself).

=head2 $app->log($msg)

Adds the message C<$msg> to the activity log. The log entry will be tagged
with the IP address of the client running the application (that is, of the
browser that made the HTTP request), using C<$app-E<gt>remote_ip>.

=head2 $app->trace(@msg)

Adds a trace message by concatenating all the members of C<@msg> to the
internal tracing mechanism; trace messages are then displayed at the
top of the output page sent to the client.  These messages are
displayed when the I<DebugMode> configuration parameter is
enabled. This is useful for debugging.

=head2 $app->remote_ip

The IP address of the client.

In a L<mod_perl> context, this calls L<Apache::Connection::remote_ip>; in a
CGI context, this uses C<$ENV{REMOTE_ADDR}>.

=head1 STANDARD APPLICATION TEMPLATE PARAMETERS

When loading an application template, a number of parameters are preset for
you. The following are some parameters that are assigned by C<MT::App> itself:

=over 4

=item * AUTHOR_ID
=item * AUTHOR_NAME

The MT::Author ID and username of the currently logged-in user.

=item * MT_VERSION

The value returned by MT->version_id. Typically just the release version
number, but for special releases such as betas, this may also include
an identifying suffix (ie "3.2b").

=item * MT_PRODUCT_CODE

A product code defined by Six Apart to identify the edition of Movable Type.
Currently, the valid values include:

    MT  - Movable Type Personal or Movable Type Commercial editions
    MTE - Movable Type Enterprise

=item * MT_PRODUCT_NAME

The name of the product in use.

=item * LANGUAGE_TAG

The active language identifier of the currently logged-in user (or default
language for the MT installation if there is no logged in user).

=item * LANGUAGE_xx

A parameter dynamically named for testing for particular languages.

Sample usage:

    <TMPL_IF NAME=LANGUAGE_FR>Parlez-vous Francias?</TMPL_IF>

Note that this is not a recommended way to localize your application. This
is intended for including or excluding portions of a template based on the
active language.

=item * LANGUAGE_ENCODING

Provides the character encoding that is configured for the application. This
maps to the "PublishCharset" MT configuration setting.

=item * STATIC_URI

This provides the mt-config.cgi setting for "StaticWebPath" or "AdminCGIPath",
depending on whether the active CGI is an admin CGI script or not (most
likely it is, if it's meant to be used by an administrator (mt.cgi) and not
an end user such as mt-comments.cgi).

Sample usage:

    <TMPL_VAR NAME=STATIC_URI>images/logo.gif

With a StaticWebPath of '/mt/', this produces:

    /mt/mt-static/images/logo.gif

or, if StaticWebPath is 'http://example.com/mt-static/':

    http://example.com/mt-static/images/logo.gif

=item * SCRIPT_URL

Returns the relative URL to the active CGI script.

Sample usage:

    <TMPL_VAR NAME=SCRIPT_URL>?__mode=blah

which may output:

    /mt/plugins/myplugin/myplugin.cgi?__mode=blah


=item * MT_URI

Yields the relative URL to the primary Movable Type application script
(mt.cgi or the configured 'AdminScript').

Sample usage:

    <TMPL_VAR NAME=MT_URI>?__mode=view&_type=entry&id=1&blog_id=1

producing:

    /mt/mt.cgi?__mode=view&_type=entry&id=1&blog_id=1

=item * SCRIPT_PATH

The path portion of URL for script

Sample usage:

    <TMPL_VAR NAME=SCRIPT_PATH>mt-check.cgi

producing:

    /mt/mt-check.cgi

=item * SCRIPT_FULL_URL

The complete URL to the active script. This is useful when needing to output
the full script URL, including the protocol and domain.

Sample usage:

    <TMPL_VAR NAME=SCRIPT_FULL_URL>?__mode=blah

Which produces something like this:

    http://example.com/mt/plugins/myplugin/myplugin.cgi

=back

=head1 AUTHOR & COPYRIGHTS

Please see the L<MT> manpage for author, copyright, and license information.

=cut
