# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::App::Comments;
use strict;

use base 'MT::App';

use MT::Comment;
use MT::I18N qw( wrap_text );
use MT::Util
    qw( remove_html encode_html encode_url decode_url is_valid_email is_valid_url is_url escape_unicode format_ts encode_js epoch2ts );
use MT::Entry qw(:constants);
use MT::Author;
use MT::JunkFilter qw(:constants);

sub id {'comments'}

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods(
        login          => \&login_form,
        login_external => \&login_external,
        do_login       => \&do_login,
        signup         => \&signup,
        do_signup      => \&do_signup,

        # register         => \&register,
        do_register    => \&do_register,
        preview        => \&preview,
        post           => \&post,
        handle_sign_in => { handler => \&handle_sign_in, charset => 'utf-8' },
        userinfo       => \&userinfo,
        verify_session => \&verify_session,
        edit_profile   => \&edit_commenter_profile,
        save_profile   => \&save_commenter_profile,
        red            => \&do_red,
        generate_captcha => \&generate_captcha,

        start_recover => \&start_recover,
        recover       => \&recover,
        new_pw        => \&new_pw,

        comment_listing => \&comment_listing,

        recover_lockout => 'MT::CMS::User::recover_lockout',
    );
    $app->{template_dir}         = 'comment';
    $app->{plugin_template_path} = '';
    $app->init_commenter_authenticators;
    $app->init_captcha_providers();
    MT->add_callback( 'CommentThrottleFilter', 1, undef,
        \&MT::App::Comments::_builtin_throttle );
    $app;
}

sub init_request {
    my $app = shift;
    $app->SUPER::init_request(@_);
    $app->set_no_cache;
    $app->{default_mode} = 'post';
    my $q = $app->param;

    if ( my $blog_id = $q->param('blog_id') ) {
        if ( $blog_id ne int($blog_id) ) {
            die $app->translate("Invalid request");
        }
    }

    # Global '_type' parameter check; if we get something
    # special character, die
    if ( my $type = $app->param('_type') ) {
        if ( $type =~ /\W/ ) {
            die $app->translate("Invalid request");
        }
    }

    ## We don't really have a __mode parameter, because we have to
    ## use named submit buttons for Preview and Post. So we hack it.
    if (   $q->param('post')
        || $q->param('post_x')
        || $q->param('post.x') )
    {
        $app->mode('post');
    }
    elsif ($q->param('preview')
        || $q->param('preview_x')
        || $q->param('preview.x') )
    {
        $app->mode('preview');
    }
    elsif ($q->param('reply')
        || $q->param('reply_x')
        || $q->param('reply.x') )
    {
        $app->mode('reply');
    }
    elsif ($q->param('reply_preview')
        || $q->param('reply_preview_x')
        || $q->param('reply_preview.x') )
    {
        $app->mode('reply_preview');
    }
    elsif ( $app->path_info =~ /captcha/ ) {
        $app->mode('generate_captcha');
    }
}

sub load_core_tags {
    return {};
}

#
# $app->_get_commenter_session()
# Creates a commenter record based on the cookies in the $app, if
# one already exists corresponding to the browser's session.
#
# Returns a pair ($session_obj, $commenter) where $session_obj is
# a MT::Session object and $commenter is an MT::Author record. Both
# values are undef when no session is active.
#
sub _get_commenter_session {
    my $app = shift;
    return $app->get_commenter_session();
}

sub login_form {
    my $app   = shift;
    my %param = @_;

    require MT::Lockout;
    if ( MT::Lockout->is_locked_out( $app, $app->remote_ip ) ) {
        $app->{hide_goback_button} = 1;
        return $app->errtrans("Invalid request");
    }

    my $param = {
        blog_id    => ( $app->param('blog_id')    || 0 ),
        static     => ( $app->param('static')     || '' ),
        return_url => ( $app->param('return_url') || '' ),
    };
    $param->{entry_id} = $app->param('entry_id') if $app->param('entry_id');
    while ( my ( $key, $val ) = each %param ) {
        $param->{$key} = $val;
    }

    my $blog = MT::Blog->load( $param->{blog_id} );
    my $external_authenticators
        = $app->external_authenticators( $blog, $param );

    if (@$external_authenticators) {
        $param->{auth_loop}      = $external_authenticators;
        $param->{default_signin} = $external_authenticators->[0]->{key}
            unless exists $param->{default_signin};
    }

    $app->build_page( 'login.tmpl', $param );
}

sub login_external {
    my $app = shift;
    my $q   = $app->param;

    my $authenticator = MT->commenter_authenticator( $q->param('key') );
    my $auth_class    = $authenticator->{class};
    eval "require $auth_class;";
    if ( my $e = $@ ) {
        return $app->handle_error( $e, 403 );
    }
    $auth_class->login($app);
}

sub _create_commenter_assign_role {
    my $app = shift;
    my ($blog_id) = @_;
    require MT::Auth;
    my $error = MT::Auth->sanity_check($app);
    if ($error) {
        $app->log(
            {   message  => $error,
                level    => MT::Log::ERROR(),
                class    => 'system',
                category => 'register_commenter'
            }
        );
        return undef;
    }
    my $commenter = $app->model('author')->new;
    $commenter->name( $app->param('username') );
    $commenter->nickname( $app->param('nickname') );
    $commenter->set_password( $app->param('password') );
    $commenter->email( $app->param('email') );
    $commenter->external_id( $app->param('external_id') );
    $commenter->type( MT::Author::AUTHOR() );
    $commenter->status( MT::Author::ACTIVE() );
    $commenter->auth_type( $app->config->AuthenticationModule );
    return undef unless ( $commenter->save );

    require MT::Role;
    require MT::Association;
    my $role = MT::Role->load_same( undef, undef, 1, 'comment' );
    my $blog = MT::Blog->load($blog_id);
    if ( $role && $blog ) {
        MT::Association->link( $commenter => $role => $blog );
    }
    else {
        my $blog_name = $blog ? $blog->name : '(Blog not found)';
        $app->log(
            {   message => MT->translate(
                    "Error assigning commenting rights to user '[_1] (ID: [_2])' for weblog '[_3] (ID: [_4])'. No suitable commenting role was found.",
                    $commenter->name, $commenter->id,
                    $blog_name,       $blog->id,
                ),
                level    => MT::Log::ERROR(),
                class    => 'system',
                category => 'new'
            }
        );
    }
    $app->user($commenter);
    $commenter;
}

sub do_login {
    my $app     = shift;
    my $q       = $app->param;
    my $name    = $q->param('username');
    my $blog_id = $q->param('blog_id');
    my $blog    = MT::Blog->load($blog_id)
        or return $app->error(
        $app->translate( 'Cannot load blog #[_1].', $blog_id ) );
    my $auths = $blog->commenter_authenticators;
    if ( $auths !~ /MovableType/ ) {
        $app->log(
            {   message => $app->translate(
                    'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.',
                    $name, $blog->name, $blog_id
                ),
                level    => MT::Log::WARNING(),
                category => 'login_commenter',
            }
        );
        return $app->login_form( error => $app->translate('Invalid login.') );
    }

    require MT::Auth;
    my $ctx = MT::Auth->fetch_credentials( { app => $app } );
    $ctx->{blog_id} = $blog_id;
    my $result = MT::Auth->validate_credentials($ctx);
    my ( $message, $error );
    if (   ( MT::Auth::NEW_LOGIN() == $result )
        || ( MT::Auth::NEW_USER() == $result )
        || ( MT::Auth::SUCCESS() == $result ) )
    {
        my $commenter = $app->user;
        if ( $q->param('external_auth') && !$commenter ) {
            $app->param( 'name', $name );
            if ( MT::Auth::NEW_USER() == $result ) {
                $commenter = $app->_create_commenter_assign_role(
                    $q->param('blog_id') );
                return $app->login_form(
                    error => $app->translate('Invalid login') )
                    unless $commenter;
            }
            elsif ( MT::Auth::NEW_LOGIN() == $result ) {
                my $registration = $app->config->CommenterRegistration;
                unless (
                       $registration
                    && $registration->{Allow}
                    && (   $app->config->ExternalUserManagement
                        || $blog->allow_commenter_regist )
                    )
                {
                    return $app->login_form(
                        error => $app->translate(
                            'Successfully authenticated, but signing up is not allowed.  Please contact your Movable Type system administrator.'
                        )
                    ) unless $commenter;
                }
                else {
                    return $app->signup(
                        error => $app->translate('You need to sign up first.')
                    ) unless $commenter;
                }
            }
        }
        MT::Auth->new_login( $app, $commenter );
        if ( $app->_check_commenter_author( $commenter, $blog_id ) ) {
            my $sid = $app->make_commenter_session($commenter);
            my $ott = MT->model('session')->new();
            $ott->kind('OT');    # One time Token
            $ott->id( MT::App::make_magic_token() );
            $ott->start(time);
            $ott->duration( time + 5 * 60 );
            $ott->set( sid => $sid );
            $ott->save
                or return $app->error(
                $app->translate(
                    "The login could not be confirmed because of a database error ([_1])",
                    $ott->errstr
                )
                );
            return $app->redirect_to_target(
                fragment => '_login_' . $ott->id );
        }
        $error   = $app->translate("Permission denied.");
        $message = $app->translate(
            "Login failed: permission denied for user '[_1]'", $name );
    }
    elsif (MT::Auth::INVALID_PASSWORD() == $result
        || MT::Auth::SESSION_EXPIRED() == $result )
    {
        $message = $app->translate(
            "Login failed: password was wrong for user '[_1]'", $name );
    }
    elsif ( MT::Auth::INACTIVE() == $result ) {
        $message
            = $app->translate( "Failed login attempt by disabled user '[_1]'",
            $name );
    }
    elsif ( MT::Auth::LOCKED_OUT() == $result ) {
        $message = $app->translate('Invalid login.');
    }
    else {
        $message
            = $app->translate( "Failed login attempt by unknown user '[_1]'",
            $name );
    }
    $app->log(
        {   message  => $message,
            level    => MT::Log::SECURITY(),
            category => 'login_commenter',
            class    => 'system',
        }
    );
    $ctx->{app} ||= $app;
    MT::Auth->invalidate_credentials($ctx);
    return $app->login_form( error => $error
            || $app->translate("Invalid login") );
}

sub signup {
    my $app = shift;
    my %opt = @_;

    my $param = {};
    $param->{$_} = $app->param($_)
        foreach qw(blog_id entry_id static username return_url );
    my $blog = $app->model('blog')->load( $param->{blog_id} || 0 )
        or return $app->error(
        $app->translate( 'Cannot load blog #[_1].', $param->{blog_id} ) );
    my $cfg = $app->config;
    if ( my $registration = $cfg->CommenterRegistration ) {
        return $app->handle_error(
            $app->translate('Signing up is not allowed.') )
            unless $registration->{Allow} && $blog->allow_commenter_regist;
        if ( my $provider
            = MT->effective_captcha_provider( $blog->captcha_provider ) )
        {
            $param->{captcha_fields} = $provider->form_fields( $blog->id );
        }
        $param->{$_} = $opt{$_} foreach keys %opt;
        $param->{ 'auth_mode_' . $cfg->AuthenticationModule } = 1;
        return $app->build_page( 'signup.tmpl', $param );
    }
    $app->handle_error( $app->translate('Signing up is not allowed.') );
}

sub do_signup {
    my $app = shift;
    my $q   = $app->param;

    return $app->error( $app->translate("Invalid request") )
        if $app->request_method() ne 'POST';

    my $param = {};
    $param->{$_} = $q->param($_)
        foreach
        qw(blog_id entry_id static email url username nickname return_url );

    return $app->errtrans("Invalid request")
        unless $param->{blog_id};

    my $blog = $app->model('blog')->load( $param->{blog_id} || 0 )
        or return $app->error(
        $app->translate( 'Cannot load blog #[_1].', $param->{blog_id} ) );

    my $cfg = $app->config;
    if ( my $registration = $cfg->CommenterRegistration ) {
        return $app->handle_error(
            $app->translate('Signing up is not allowed.') )
            unless $registration->{Allow} && $blog->allow_commenter_regist;
    }
    else {
        return $app->handle_error(
            $app->translate('Signing up is not allowed.') );
    }

    my $filter_result = $app->run_callbacks( 'api_save_filter.author', $app );

    my $user;
    $user = $app->create_user_pending($param) if $filter_result;
    unless ($user) {
        my $blog = $app->model('blog')->load( $param->{blog_id} )
            or return $app->error(
            $app->translate( 'Cannot load blog #[_1].', $param->{blog_id} ) );
        if ( my $provider
            = MT->effective_captcha_provider( $blog->captcha_provider ) )
        {
            $param->{captcha_fields} = $provider->form_fields( $blog->id );
        }
        $param->{error} = $app->errstr;
        $param->{ 'auth_mode_' . $app->config->AuthenticationModule } = 1;
        return $app->build_page( 'signup.tmpl', $param );
    }

    ## Assign default role
    $user->add_default_roles;

    my $original = $user->clone();
    $app->run_callbacks( 'api_post_save.author', $app, $user, $original );

    ## Send confirmation email in the background.
    MT::Util::start_background_task(
        sub {
            $app->_send_signup_confirmation( $user->id, $user->email,
                $param->{entry_id}, $param->{blog_id},
                $param->{static} || $param->{return_url} );
        }
    );

    my $entry = MT::Entry->load( $param->{entry_id} )
        if ( $param->{entry_id} );
    if ($entry) {
        my $entry_url = $entry->permalink;
        $app->build_page( 'signup_thanks.tmpl',
            { email => $user->email, entry_url => $entry_url } );
    }
    else {
        $app->build_page(
            'signup_thanks.tmpl',
            {   email => $user->email,
                return_url =>
                    is_valid_url( $param->{return_url} || $param->{static} )
            }
        );
    }
}

sub _send_signup_confirmation {
    my $app = shift;
    my ( $id, $email, $entry_id, $blog_id, $static ) = @_;
    my $cfg = $app->config;

    my $blog = MT::Blog->load($blog_id)
        or return $app->error(
        $app->translate( 'Cannot load blog #[_1].', $blog_id ) );
    my $entry;
    $entry = MT::Entry->load($entry_id)
        if $entry_id;
    my $author = $entry ? $entry->author : q();

    my $token = $app->make_magic_token;

    my $subject  = $app->translate('Movable Type Account Confirmation');
    my $cgi_path = $app->config('CGIPath');
    $cgi_path .= '/' unless $cgi_path =~ m!/$!;
    my $url 
        = $cgi_path 
        . $cfg->CommentScript
        . $app->uri_params(
        'mode' => 'do_register',
        args   => {
            'token' => $token,
            $entry ? ( 'entry_id' => $entry->id ) : (),
            'blog_id' => $blog_id,
            'email'   => $email,
            'static'  => $static,
        },
        );

    if ( $url =~ m!^/! ) {
        my ($blog_domain) = $blog->site_url =~ m|(.+://[^/]+)|;
        $url = $blog_domain . $url;
    }

    my $param = {
        blog        => $blog,
        confirm_url => $url,
        author      => $author,
    };
    my $body = MT->build_email( 'commenter_confirm.tmpl', $param );

    require MT::Mail;
    my $from_addr;
    my $reply_to;
    if ( $cfg->EmailReplyTo ) {
        $reply_to = $cfg->EmailAddressMain;
    }
    else {
        $from_addr = $cfg->EmailAddressMain;
    }
    $from_addr = undef if $from_addr && !is_valid_email($from_addr);
    $reply_to  = undef if $reply_to  && !is_valid_email($reply_to);

    unless ( $from_addr || $reply_to ) {
        $app->log(
            {   message =>
                    MT->translate("System Email Address is not configured."),
                level    => MT::Log::ERROR(),
                class    => 'system',
                category => 'email'
            }
        );
        return;
    }

    my %head = (
        id => 'commenter_confirm',
        To => $email,
        $from_addr ? ( From       => $from_addr ) : (),
        $reply_to  ? ( 'Reply-To' => $reply_to )  : (),
        Subject => $subject,
    );
    my $charset = $cfg->MailEncoding || $cfg->PublishCharset;
    $head{'Content-Type'} = qq(text/plain; charset="$charset");

    ## Save it in session to purge later
    require MT::Session;
    my $sess = MT::Session->new;
    $sess->id($token);
    $sess->kind('CR');    # CR == Commenter Registration
    $sess->email($email);
    $sess->name($id);
    $sess->start(time);
    $sess->duration( time + 60 * 60 * 24 );
    $sess->set( blog_id => $blog_id );
    $sess->save;

    MT::Mail->send( \%head, $body )
        or die MT::Mail->errstr();
}

sub do_register {
    my $app = shift;
    my $q   = $app->param;
    my $cfg = $app->config;

    my $q_blog_id = $q->param('blog_id');
    my $entry_id  = $q->param('entry_id');
    my $static    = $q->param('static');
    my $email     = $q->param('email');
    my $token     = $q->param('token');

    if ($static) {
        return $app->errtrans('Invalid request.')
            unless $app->is_valid_redirect_target;
    }

    ## Token expiration check
    require MT::Session;
    my $commenter;
    my $sess = MT::Session->load(
        { id => $token, kind => 'CR', email => $email } );

    unless ($sess) {
        my $msg = $app->translate(
            'Your confirmation has expired. Please register again.');
        if ($static) {
            $msg .= '&nbsp;'
                . $app->translate(
                '<a href="[_1]">Return to the original page.</a>', $static );
        }
        return $app->forward( 'signup', message => $msg );
    }
    $sess->remove;

    $commenter = MT::Author->load( $sess->name )
        or return $app->errtrans("Invalid request.");

    if ( $sess->start() < ( time - 60 * 60 * 24 ) ) {
        $commenter->remove;
        my $msg = $app->translate(
            'Your confirmation have expired. Please register again.');
        if ($static) {
            $msg .= '&nbsp;'
                . $app->translate(
                '<a href="[_1]">Return to the original page.</a>', $static );
        }
        return $app->forward( 'signup', message => $msg );
    }

    my $blog_id = $sess->get('blog_id');

    my $error = sub {
        $commenter->remove;
        return $app->errtrans(@_);
    };

    return $error->("Invalid request.")
        unless $blog_id == $q_blog_id;

    my $blog = $app->model('blog')->load($blog_id)
        or return $error->( 'Cannot load blog #[_1].', $blog_id );

    my $registration = $cfg->CommenterRegistration
        or return $error->('Signing up is not allowed.');

    return $error->('Signing up is not allowed.')
        unless $registration->{Allow} && $blog->allow_commenter_regist;

    $commenter->status( MT::Author::ACTIVE() );
    $commenter->save
        or $app->forward( 'signup', error => $commenter->errstr );

    $app->log(
        {   message => $app->translate(
                "Commenter '[_1]' (ID:[_2]) has been successfully registered.",
                $commenter->name,
                $commenter->id
            ),
            level    => MT::Log::INFO(),
            class    => 'author',
            category => 'new',
        }
    );
    require MT::Role;
    require MT::Association;
    my $role = MT::Role->load_same( undef, undef, 1, 'comment' );

    if ( $role && $blog ) {
        MT::Association->link( $commenter => $role => $blog );
    }
    else {
        $app->log(
            {   message => MT->translate(
                    "Error assigning commenting rights to user '[_1] (ID: [_2])' for weblog '[_3] (ID: [_4])'. No suitable commenting role was found.",
                    $commenter->name, $commenter->id,
                    $blog->name,      $blog->id,
                ),
                level    => MT::Log::ERROR(),
                class    => 'system',
                category => 'new'
            }
        );
    }

    if ( my $ids = $registration->{Notify} ) {
        ## Send notification email in the background.
        MT::Util::start_background_task(
            sub {
                $app->_send_registration_notification( $commenter, $entry_id,
                    $blog_id, $ids );
            }
        );
    }

    $app->login_form(
        message => $app->translate(
            'Thanks for the confirmation.  Please sign in to comment.')
    );
}

sub _send_registration_notification {
    my $app = shift;
    my ( $user, $entry_id, $blog_id, $ids ) = @_;

    my $blog = MT::Blog->load($blog_id)
        or return $app->error(
        $app->translate( 'Cannot load blog #[_1].', $blog_id ) );
    my $subject = $app->translate( "[_1] registered to the blog '[_2]'",
        $user->name, $blog->name );

    my $url = $app->mt_uri(
        mode => 'view',
        args => {
            '_type' => 'author',
            id      => $user->id
        }
    );

    if ( $url =~ m!^/! ) {
        my ($blog_domain) = $blog->site_url =~ m|(.+://[^/]+)|;
        $url = $blog_domain . $url;
    }

    my $param = {
        blog        => $blog,
        commenter   => $user,
        profile_url => $url
    };
    my $body = MT->build_email( 'commenter_notify.tmpl', $param );

    $app->_send_sysadmins_email( $ids, 'commenter_notify', $body, $subject,
        $user->email );
}

sub generate_captcha {
    my $app = shift;

    my $pi = $app->path_info;
    $pi =~ s!^/!!;
    my $cmtscript = $app->config('CommentScript');
    $pi =~ s!.*\Q$cmtscript\E/!!;
    $pi =~ s,captcha/,,;            #remove prefix..
    my ( $blog_id, $token ) = split '/', $pi;
    unless ( $blog_id && $token ) {
        $app->error('Required parameter was missing.');
        return undef;
    }
    my $blog = $app->model('blog')->load($blog_id)
        or return $app->error(
        $app->translate( 'Cannot load blog #[_1].', $blog_id ) );
    if ( my $provider
        = MT->effective_captcha_provider( $blog->captcha_provider ) )
    {
        my $image_data
            = $provider->generate_captcha( $app, $blog_id, $token );
        if ($image_data) {
            $app->{no_print_body} = 1;
            $app->set_header( 'Cache-Control' => 'no-cache' );
            $app->set_header( 'Expires'       => '-1' );
            $app->send_http_header('image/png');
            $app->print($image_data);
            return 1;
        }
    }
    return undef;
}

sub do_red {
    my $app = shift;
    my $q   = $app->param;
    my $id  = $q->param('id')
        or return $app->error( $app->translate("No id") );
    my $comment = MT::Comment->load($id)
        or return $app->error( $app->translate("No such comment") );
    return $app->error( $app->translate("No such comment") )
        unless ( $comment->visible );
    my $uri = encode_html( $comment->url );
    return <<HTML;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html><head><title>Redirecting...</title>
<meta name="robots" content="noindex, nofollow">
<script type="text/javascript">
window.onload = function() { document.location = '$uri'; };
</script></head>
<body>
<p><a href="$uri">Click here</a> if you are not redirected</p>
</body>
</html>
HTML
}

# _builtin_throttle is the builtin throttling code
# others can be added by plugins
# a filtering callback must return true or false; true
#    means OK, false means filter it out.
sub _builtin_throttle {
    my $eh      = shift;
    my $app     = shift;
    my ($entry) = @_;
    my $cfg     = $app->config;

    my $throttle_period = $cfg->ThrottleSeconds;
    my $user_ip         = $app->remote_ip;
    return 1 if ( $throttle_period <= 0 );    # Disabled by ThrottleSeconds 0

    require MT::Util;
    my @ts = MT::Util::offset_time_list( time - $throttle_period,
        $entry->blog_id );
    my $from = sprintf(
        "%04d%02d%02d%02d%02d%02d",
        $ts[5] + 1900,
        $ts[4] + 1,
        @ts[ 3, 2, 1, 0 ]
    );

    if (MT::Comment->exist(
            {   ip         => $user_ip,
                created_on => [$from],
                blog_id    => $entry->blog_id
            },
            { range => { created_on => 1 } }
        )
        )
    {
        return 0;    # Put a collar on that puppy.
    }

    return 1 unless $cfg->ShowIPInformation;

    # If IP banning is enabled, check for lots of comments from
    # the user's IP within the throttle period * 10; if they
    # exceed 8 comments within that period, ban the IP.

    @ts = MT::Util::offset_time_list( time - $throttle_period * 10 - 1,
        $entry->blog_id );
    $from = sprintf(
        "%04d%02d%02d%02d%02d%02d",
        $ts[5] + 1900,
        $ts[4] + 1,
        @ts[ 3, 2, 1, 0 ]
    );
    my $count = MT::Comment->count(
        {   ip         => $user_ip,
            created_on => [$from],
            blog_id    => $entry->blog_id
        },
        { range => { created_on => 1 } }
    );
    if ( $count >= 8 ) {
        require MT::IPBanList;
        my $ipban = MT::IPBanList->new();
        $ipban->blog_id( $entry->blog_id );
        $ipban->ip($user_ip);
        $ipban->save();
        $app->log(
            {   message => $app->translate(
                    "IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.",
                    $user_ip,
                    10 * $throttle_period
                ),
                class    => 'comment',
                category => 'ip_ban',
                blog_id  => $entry->blog_id,
                level    => MT::Log::INFO(),
                metadata => $user_ip,
            }
        );
        require MT::Mail;
        my $author = $entry->author;
        $app->set_language( $author->preferred_language )
            if $author && $author->preferred_language;

        my $blog = MT::Blog->load( $entry->blog_id )
            or return $app->error(
            $app->translate( 'Cannot load blog #[_1].', $entry->blog_id ) );
        if ( $author && $author->email ) {
            my %head = (
                id      => 'comment_throttle',
                To      => $author->email,
                From    => $cfg->EmailAddressMain,
                Subject => '['
                    . $blog->name . '] '
                    . $app->translate("IP Banned Due to Excessive Comments")
            );
            my $charset = $cfg->MailEncoding || $cfg->PublishCharset;
            $head{'Content-Type'} = qq(text/plain; charset="$charset");
            my $body = $app->build_email(
                'comment_throttle.tmpl',
                {   blog             => $blog,
                    throttled_ip     => $user_ip,
                    throttle_seconds => 10 * $throttle_period,
                }
            );
            $body = wrap_text( $body, 72 );
            MT::Mail->send( \%head, $body );
        }
        return 0;
    }
    return 1;
}

sub post {
    my $app = shift;
    my $q   = $app->param;

    return $app->error( $app->translate("Invalid request") )
        if $app->request_method() ne 'POST';

    my $entry_id = int( $q->param('entry_id') )
        or return $app->error( $app->translate("No entry_id") );
    require MT::Entry;
    my $entry = MT::Entry->load($entry_id)
        or return $app->error(
        $app->translate( "No such entry '[_1]'.", encode_html($entry_id) ) );
    return $app->error(
        $app->translate( "No such entry '[_1]'.", encode_html($entry_id) ) )
        if $entry->status != RELEASE;

    require MT::IPBanList;
    my $iter = MT::IPBanList->load_iter( { blog_id => $entry->blog_id } );
    while ( my $ban = $iter->() ) {
        my $banned_ip = $ban->ip;
        if ( $app->remote_ip =~ /$banned_ip/ ) {
            return $app->handle_error( $app->translate("Invalid request") );
        }
    }

    my $blog = $app->model('blog')->load( $entry->blog_id )
        or return $app->error(
        $app->translate( 'Cannot load blog #[_1].', $entry->blog_id ) );

    my $armor = $q->param('armor');
    if ( defined $armor ) {

        # For this to work, we must create a site path exactly like
        # <MTBlogSitePath> does.
        my $path = $blog->site_path;
        $path .= '/' unless $path =~ m!/$!;
        my $site_path_sha1 = MT::Util::perl_sha1_digest_hex($path);
        if ( $armor ne $site_path_sha1 ) {
            return $app->handle_error( $app->translate("Invalid request") );
        }
    }

    # Run all the Comment-throttling callbacks
    my $passed_filter
        = MT->run_callbacks( 'CommentThrottleFilter', $app, $entry );

    $passed_filter
        || return $app->handle_error( $app->translate("_THROTTLED_COMMENT"),
        "403 Throttled" );

    my $cfg = $app->config;
    if ( my $state = $q->param('comment_state') ) {
        require MT::Serialize;
        my $ser = MT::Serialize->new( $cfg->Serializer );
        $state = $ser->unserialize( pack 'H*', $state );
        $state = $$state;
        for my $f ( keys %$state ) {
            $q->param( $f, $state->{$f} );
        }
    }
    unless ( $cfg->AllowComments && $entry->allow_comments eq '1' ) {
        return $app->handle_error(
            $app->translate("Comments are not allowed on this entry.") );
    }

    my $text = $q->param('text') || '';
    $text =~ s/^\s+|\s+$//g;
    if ( $text eq '' ) {
        return $app->handle_error(
            $app->translate("Comment text is required.") );
    }

    # validate session parameter
    if ( my $sid = $q->param('sid') ) {
        my ( $sess_obj, $commenter ) = $app->_get_commenter_session();
        if ( $sess_obj && $commenter && ( $sess_obj->id eq $sid ) ) {

            # well, everything is okay
        }
        else {
            return $app->handle_error(
                $app->translate(
                    "Your session has expired. Please sign in again to comment."
                )
            );
        }
    }

    my ( $comment, $commenter ) = _make_comment( $app, $entry, $blog );
    return $app->handle_error(
        $app->translate( "An error occurred: [_1]", $app->errstr() ) )
        unless $comment;

    return $app->handle_error(
        $app->translate(
            "Your session has expired. Please sign in again to comment."
        )
    ) if ( $commenter && !$q->param('sid') );

    if ( !$blog->allow_unreg_comments ) {
        if ( !$commenter ) {
            return $app->handle_error(
                $app->translate("Registration is required.") );
        }
    }
    if (   $blog->require_comment_emails()
        && !$commenter
        && !(
               $comment->author
            && $comment->email
            && is_valid_email( $comment->email )
        )
        )
    {
        return $app->handle_error(
            $app->translate("Name and E-mail address are required.") );
    }
    if ( $blog->allow_unreg_comments() ) {
        $comment->email( $q->param('email') ) unless $comment->email();
    }

    if ( $comment->email ) {
        if ( my $fixed = is_valid_email( $comment->email ) ) {
            $comment->email($fixed);
        }
        elsif ( $comment->email =~ /^[0-9A-F]{40}$/i ) {

            # It's a FOAF-style mbox hash; accept it if blog config says to.
            return $app->handle_error("A real email address is required")
                if ( !$commenter && $blog->require_comment_emails() );
        }
        else {
            return $app->handle_error(
                $app->translate(
                    "Invalid email address '[_1]'",
                    $comment->email
                )
            );
        }
    }
    if ( $comment->url ) {
        if ( my $fixed = is_valid_url( $comment->url ) ) {
            $comment->url($fixed);
        }
        else {
            return $app->handle_error(
                $app->translate( "Invalid URL '[_1]'", $comment->url ) );
        }
    }

    if (!$commenter
        && ( my $provider
            = MT->effective_captcha_provider( $blog->captcha_provider ) )
        )
    {
        unless ( $provider->validate_captcha($app) ) {
            return $app->handle_error(
                $app->translate("Text entered was wrong.  Try again.") );
        }
    }

    $app->param( '_type', 'comment' );
    if ( !$app->run_callbacks( 'api_save_filter.comment', $app ) ) {
        return $app->handle_error( $app->errstr );
    }

    $comment = $app->eval_comment( $blog, $commenter, $comment, $entry );
    return $app->preview('pending') unless $comment;

    $app->user($commenter);
    $comment->save
        or $app->log(
        {   message => $app->translate(
                "Comment save failed with [_1]",
                $comment->errstr
            ),
            blog_id  => $blog->id,
            class    => 'comment',
            level    => MT::Log::ERROR(),
            category => 'new',
        }
        );
    if ( $comment->id && !$comment->is_junk ) {

        $app->run_callbacks( 'api_post_save.comment',
            $app, $comment, $commenter );
        $entry->modified_on( epoch2ts( $blog, time ) );
        $entry->save;

        $app->log(
            {   message => $app->translate(
                    'Comment on "[_1]" by [_2].', $entry->title,
                    $comment->author
                ),
                class    => 'comment',
                category => 'new',
                blog_id  => $blog->id,
                metadata => $comment->id,
            }
        );
    }

    # Form a link to the comment
    my $comment_link;
    if ( !$q->param('static') ) {
        my $url = $app->base . $app->uri;
        $url .= '?entry_id=' . $q->param('entry_id');
        $comment_link = $url;
    }
    else {
        my $static = $q->param('static');
        if ( $static eq '1' ) {

            # I think what we really want is the individual archive.
            $comment_link = $entry->permalink;
        }
        else {
            $static =~ s/[\r\n].*$//s;
            $comment_link = $static . '#comment-' . $comment->id;
        }
    }

    if ( $comment->visible ) {
        $app->publisher->start_time(time);

        # Rebuild the entry synchronously so that if the user gets
        # redirected to the indiv. page it will be up-to-date.
        $app->rebuild_entry( Entry => $entry->id, PreferredArchiveOnly => 1 )
            or return $app->handle_error(
            $app->translate( "Publishing failed: [_1]", $app->errstr ) );
    }

    if ( $comment->is_junk ) {
        $app->run_tasks('JunkExpiration');
        return $app->preview('pending');
    }
    if ( !$comment->visible ) {
        $app->_send_comment_notification( $comment, $comment_link, $entry,
            $blog, $commenter );
        return $app->preview('pending');
    }

    # Index rebuilds and notifications are done in the background.
    MT::Util::start_background_task(
        sub {
            $app->rebuild_entry(
                Entry             => $entry->id,
                BuildDependencies => 1
                )
                or return $app->handle_error(
                $app->translate( "Publishing failed: [_1]", $app->errstr ) );

            $app->_send_comment_notification( $comment, $comment_link, $entry,
                $blog, $commenter );
            _expire_sessions( $cfg->CommentSessionTimeout );
        }
    );

    if ( $blog->use_comment_confirmation ) {
        my $tmpl = MT::Template->load(
            { type => 'comment_response', blog_id => $entry->blog_id } );
        unless ($tmpl) {
            require MT::DefaultTemplates;
            $tmpl
                = MT::DefaultTemplates->load(
                { identifier => 'comment_response' } )
                or return $app->handle_error(
                $app->translate("Cannot load template") );
            $tmpl->blog_id( $entry->blog_id );
            my $curr_lang = MT->current_language;
            $app->set_language( $blog->language );
            $tmpl->text( $app->translate_templatized( $tmpl->text ) );
            $app->set_language($curr_lang);
        }
        my $ctx = $tmpl->context;
        $tmpl->param(
            {   'body_class'                => 'mt-comment-confirmation',
                'comment_link'              => $comment_link,
                'comment_response_template' => 1,
                'comment_confirmation'      => 1,
                'system_template'           => 1
            }
        );
        $ctx->stash( 'entry',     $entry );
        $ctx->stash( 'comment',   $comment );
        $ctx->stash( 'commenter', $commenter ) if $commenter;
        my $html = $tmpl->output();
        $html = $tmpl->errstr unless defined $html;
        return $html;
    }
    else {
        return $app->redirect($comment_link);
    }
}

sub eval_comment {
    my $app = shift;
    my ( $blog, $commenter, $comment, $entry ) = @_;

    if (   $commenter
        && ( $commenter->type == MT::Author::COMMENTER() )
        && ( $commenter->commenter_status( $blog->id )
            == MT::Author::BLOCKED() )
        )
    {
        return undef;
    }

    my $commenter_status;
    if ($commenter) {
        $commenter_status = $commenter->commenter_status( $entry->blog_id );
        if ( $commenter_status == MT::Author::APPROVED() ) {
            if ( $blog->publish_trusted_commenters ) {
                $comment->approve;
                return $comment;
            }
            else {
                $comment->moderate;
                return $comment;
            }
        }
        if ( $commenter_status == MT::Author::PENDING() ) {

            # just in case record doesn't exist...
            $commenter->pending( $entry->blog_id );
        }
        if ( $commenter_status == MT::Author::BANNED() ) {
            return undef;
        }
    }

    my $not_declined = MT->run_callbacks( 'CommentFilter', $app, $comment );
    return unless $not_declined;

    MT::JunkFilter->filter($comment);

    ## Here comes the built-in logic for deciding whether the
    ## comment is moderated or published.

    # from here to #mark should set "visible" no matter what
    if ( $comment->is_junk ) {
        $comment->visible(0);    # forcibly set to unpublished
    }
    elsif ( !defined $comment->visible ) {
        if ($commenter) {
            if ( $blog->publish_authd_untrusted_commenters ) {
                $comment->approve;
            }
            else {
                $comment->moderate;
            }
        }
        else {

            # We don't have a commenter object, but the user wasn't booted
            # so unless moderation is on, we can publish the comment.
            if ( $blog->publish_unauthd_commenters ) {
                $comment->approve;
            }
            else {
                $comment->moderate;
            }
        }
    }

    #mark

    $comment;
}

sub _check_commenter_author {
    my $app = shift;
    my ( $commenter, $blog_id ) = @_;

    return 0 unless $blog_id;

    # Using MT::Author::commenter_status here, since it also
    # takes the permission "restrictions" into account.
    my $status = $commenter->commenter_status($blog_id);

    # INACTIVE == BANNED
    return 0 if $status == MT::Author::BANNED();
    return 0 if $commenter->status == MT::Author::BANNED();

    # NOT using $status for this test, since $status may be
    # assigned 'PENDING' by 'commenter_status' if no permission
    # record exists at all. We want to check below to see if
    # commenting permission is auto-vivified based on blog configuration
    # in such a case.
    if ( MT::Author::PENDING() == $commenter->status() ) {
        $app->error(
            $app->translate(
                "Failed comment attempt by pending registrant '[_1]'",
                $commenter->name
            )
        );
        return 0;
    }
    elsif ( $commenter->blog_perm($blog_id)->can_do('post_comment') ) {
        return 1;
    }
    else {

        # No explicit permissions are given for this commenter, so
        # see if blog is configured as "open to registration" for
        # commenting. If it is, auto-assign commenting permissions
        # for this blog only.
        if ( my $registration = $app->config->CommenterRegistration ) {
            my $blog = MT::Blog->load($blog_id)
                or return $app->error(
                $app->translate( 'Cannot load blog #[_1].', $blog_id ) );
            if ($registration->{Allow}
                && (   $app->config->ExternalUserManagement
                    || $blog->allow_commenter_regist )
                )
            {

                # By policy, this blog permits this type of user
                # and they are not banned (as they have no blog perms/
                # restrictions, so permit this comment)
                return 1;
            }
        }
    }
    $app->error(
        $app->translate(
            "Login failed: permission denied for user '[_1]'",
            $commenter->name
        )
    );
    return 0;
}

#
# $app->_make_comment($entry)
#
# _make_comment creates an MT::Comment record attached to the $entry,
# based on the query information in $app (It neeeds the whole app object
# so it can get the user's IP). Also creates an MT::Author record
# representing the person who placed the comment, if necessary.
#
# Always returns a pair ($comment, $commenter). The latter is undef if
# there is no commenter for the session (or if there is no active
# session).
#
# Validation of the comment data is left to the caller.
#
sub _make_comment {
    my ( $app, $entry, $blog ) = @_;
    my $q = $app->param;

    my $nick  = $q->param('author');
    my $email = $q->param('email');
    my ( $sess_obj, $commenter );
    if ( $blog->accepts_registered_comments ) {
        ( $sess_obj, $commenter ) = $app->_get_commenter_session();
    }
    if ( $commenter && ( 'do_reply' ne $app->mode ) ) {
        if ( MT::Author::AUTHOR() == $commenter->type ) {
            if ( $blog->commenter_authenticators !~ /MovableType/ ) {
                $commenter = undef;
            }
            else {
                unless (
                    $app->_check_commenter_author( $commenter, $blog->id ) )
                {
                    $app->error( $app->translate('Permission denied.') );
                    return ( undef, undef );
                }
            }
        }
    }
    if ($commenter) {
        $nick = $commenter->nickname()
            || $app->translate('Registered User');
        $email = $commenter->email();
    }

    my $url = $q->param('url') || '';  #($commenter ? $commenter->url() : '');
    my $comment = MT::Comment->new;
    if ($commenter) {
        $comment->commenter_id( $commenter->id );
    }
    ## Strip linefeed characters.
    my $text = $q->param('text');
    $text = '' unless defined $text;
    $text =~ tr/\r//d;
    $comment->ip( $app->remote_ip );
    $comment->blog_id( $entry->blog_id );
    $comment->entry_id( $entry->id );
    $comment->author( remove_html($nick) );
    $comment->email( remove_html($email) );
    $url = is_valid_url($url);
    $comment->url( $url eq 'http://' ? '' : $url );
    $comment->text($text);

    #$comment->visible(0); # leave as undefined
    $comment->is_junk(0);

    # strip of any null characters (done after junk checks so they can
    # monitor for that kind of activity)
    for my $field (qw(author email url text)) {
        my $val = $comment->column($field);
        if ( $val =~ m/\x00/ ) {
            $val =~ tr/\x00//d;
            $comment->column( $field, $val );
        }
    }

    if ( my $parent_id = $app->param('parent_id') ) {

        # verify that parent_id is for a comment that is
        # published for this entry
        my $parent_comment = MT::Comment->load($parent_id);
        if (   $parent_comment
            && $parent_comment->is_published()
            && $parent_comment->entry_id == $entry->id )
        {
            $comment->parent_id($parent_id);
        }
        else {
            return $app->error("Invalid 'parent_id' parameter.");
        }
    }

    return ( $comment, $commenter );
}

sub preview { my $app = shift; do_preview( $app, $app->{query}, @_ ) }

sub _make_commenter {
    my $app = shift;
    return $app->make_commenter(@_);
}

# TBD: Move this to MT::Session and store expiration date in
# the record
sub _expire_sessions {
    my ($timeout) = @_;

    require MT::Session;
    my @old_sessions = MT::Session->load(
        {   start => [ 0, time() - $timeout ],
            kind  => 'SI'
        },
        { range => { start => 1 } }
    );
    foreach (@old_sessions) {
        $_->remove();
    }
}

# This actually handles a UI-level sign-in or sign-out request.
sub handle_sign_in {
    my $app = shift;
    my $q   = $app->param;

    my $result = 0;
    my $sess;
    if ( $q->param('logout') ) {
        my ( $s, $commenter ) = $app->_get_commenter_session();

        # invalidate credentials in auth layer
        if ($commenter) {
            require MT::Auth;
            my $ctx = MT::Auth->fetch_credentials( { app => $app } );
            my $cmntr_sess
                = $app->session_user( $commenter, $ctx->{session_id},
                permanent => $ctx->{permanent} );
            if ($cmntr_sess) {
                $app->user($commenter);
                MT::Auth->invalidate_credentials( { app => $app } );
            }
        }

        my %cookies = $app->cookies();
        $app->_invalidate_commenter_session( \%cookies );
        $app->user($commenter) if $commenter;
        $result = 1;
    }
    else {
        my $authenticator = MT->commenter_authenticator( $q->param('key') );
        my $auth_class    = $authenticator->{class};
        eval "require $auth_class;";
        if ( my $e = $@ ) {
            return $app->handle_error( $e, 403 );
        }
        ( $result, $sess )
            = $auth_class->handle_sign_in( $app, $q->param('key') );
        unless ($sess) {
            my $cmtr_sess = MT::Session->load(
                {   kind => 'SI',
                    name => $result->name,
                },
                {   limit     => 1,
                    sort      => "start",
                    direction => "descend",
                }
            );
            $sess = $cmtr_sess->id
                if $cmtr_sess && $cmtr_sess->get('author_id') == $result->id;
            if ( $cmtr_sess && $cmtr_sess->get('author_id') == $result->id ) {
                my $cfg     = $app->config;
                my $timeout = $cfg->CommentSessionTimeout;
                $sess = $cmtr_sess->id
                    if $cmtr_sess->start() >= time - $timeout;
            }
        }
    }

    $app->run_callbacks( 'post_signin.external', $app, $result );

    return $app->handle_error(
        $app->errstr() || $app->translate(
            "The sign-in attempt was not successful; Please try again."),
        403
    ) unless $result;
    if ($sess) {
        my $ott = MT->model('session')->new();
        $ott->kind('OT');    # One time Token
        $ott->id( MT::App::make_magic_token() );
        $ott->start(time);
        $ott->duration( time + 5 * 60 );
        $ott->set( sid => $sess );
        $ott->save
            or return $app->error(
            $app->translate(
                "The login could not be confirmed because of a database error ([_1])",
                $ott->errstr
            )
            );
        return $app->redirect_to_target( fragment => '_login_' . $ott->id );
    }
    $app->redirect_to_target();
}

sub redirect_to_target {
    my $app  = shift;
    my $q    = $app->param;
    my %opts = @_;
    my $cfg  = $app->config;
    my $target;
    require MT::Util;
    my $static = $q->param('static') || $q->param('return_url') || '';

    if ( ( $static eq '' ) || ( $static eq '1' ) ) {
        require MT::Entry;
        my $entry = MT::Entry->load( $q->param('entry_id') || 0 )
            or return $app->error(
            $app->translate(
                'Cannot load entry #[_1].',
                $q->param('entry_id')
            )
            );
        $target = $entry->archive_url;
    }
    elsif ( $static ne '' ) {
        my $blog = $app->model('blog')->load( scalar $q->param('blog_id') )
            or return $app->error(
            $app->translate(
                'Cannot load blog #[_1].', $q->param('blog_id')
            )
            );
        if ( !$app->is_valid_redirect_target ) {
            return $app->error(
                $app->translate(
                    q{You are trying to redirect to external resources. If you trust the site, please click the link: [_1]},
                    encode_html($static)
                )
            );
        }

        $target = MT::Util::encode_html($static);
    }
    $target =~ s!#.*$!!;    # strip off any existing anchor

    if ( $q->param('logout') ) {
        if ( $app->user
            && ( 'TypeKey' eq $app->user->auth_type ) )
        {
            return $app->redirect(
                $cfg->SignOffURL
                    . "&_return="
                    . MT::Util::encode_url( $target . '#_logout' ),
                UseMeta => 1
            );
        }
    }
    my $fragment = $opts{fragment};
    $target .= '#' . $fragment if $opts{fragment};
    return $app->redirect( $target, UseMeta => 1 );
}

sub verify_session {
    my $app   = shift;
    my $jsonp = $app->param('jsonp');
    $jsonp = undef if $jsonp !~ m/^\w+$/;
    return $app->error("Invalid request.") unless $jsonp;
    $app->{no_print_body} = 1;
    $app->send_http_header("text/javascript");

    my $out = { error => 'Failed to get Commenter Information' };
    {
        my $sid = $app->param('sid');
        my $sess
            = MT::Session::get_unexpired_value(
            MT->config->UserSessionTimeOut, $sid )
            or last;
        my $commenter
            = MT->model('author')->load( $sess->thaw_data->{author_id} )
            or last;
        $out = { verified => 1 };
    }
    $app->print_encode( "$jsonp(" . MT::Util::to_json($out) . ");\n" );
    return undef;

}

sub userinfo {
    my $app   = shift;
    my $jsonp = $app->param('jsonp');
    $jsonp = undef if $jsonp !~ m/^\w+$/;
    return $app->error("Invalid request.") unless $jsonp;
    $app->{no_print_body} = 1;
    $app->send_http_header("text/javascript");

    my $out = { error => 'Failed to get Commenter Information' };
TRY: {
        my ( $commenter, $sess );
        if ( my $sid = $app->param('sid') ) {
            $sess = MT::Session::get_unexpired_value(
                MT->config->UserSessionTimeOut,
                { id => $sid, kind => 'SI' }
            ) or last TRY;
        }
        elsif ( my $ot = $app->param('ott') ) {
            my $ott
                = MT::Session::get_unexpired_value( 5 * 60,
                { id => $ot, kind => 'OT' } )
                or last TRY;
            $sess
                = MT::Session::get_unexpired_value(
                MT->config->UserSessionTimeOut,
                { id => $ott->get('sid'), kind => 'SI' } )
                or last TRY;
            $ott->remove();
        }
        if ($sess) {
            $commenter
                = MT->model('author')->load( $sess->thaw_data->{author_id} )
                or last TRY;
        }
        $out = {
            sid  => $sess->id,
            name => $commenter->nickname
                || $app->translate('(Display Name not set)'),
            url => $commenter->url
                || '',
            email => $commenter->email
                || '',
            userpic => scalar $commenter->userpic_url,
            profile => "",                               # profile link url
            is_authenticated => 1,
            is_author => ( $commenter->type == MT::Author::AUTHOR() ? 1 : 0 ),
            is_trusted   => 0,
            is_anonymous => 0,
            can_post     => 0,
            can_comment  => 0,
            is_banned    => 0,
        };

        my $blog_id = $app->param('blog_id');
        my $blog    = $app->model('blog')->load($blog_id)
            if $blog_id;
        if ( $blog_id && $blog ) {
            my $blog_perms = $commenter->blog_perm($blog_id);
            my $banned = $commenter->is_banned($blog_id) ? 1 : 0;
            $banned = 0 if $blog_perms && $blog_perms->can_administer;
            $banned ||= 1 if $commenter->status == MT::Author::BANNED();
            $out->{is_banned} = $banned;

            my $can_comment = $banned ? 0 : 1;
            $can_comment = 0
                unless $blog->allow_unreg_comments
                    || $blog->allow_reg_comments;
            $out->{can_comment} = $can_comment;
            $out->{can_post}
                = ( $blog_perms && $blog_perms->can_create_post ) ? 1 : 0;
            $out->{is_trusted}
                = ( $commenter->is_trusted($blog_id) ? 1 : 0 ),
                ;
        }
    }
    $app->print_encode( "$jsonp(" . MT::Util::to_json($out) . ");\n" );
    return undef;
}

sub comment_listing {
    my $app = shift;

    my $jsonp = $app->param('jsonp');
    if ( defined($jsonp) && $jsonp !~ m/^\w+$/ ) {
        return $app->error("Invalid request.");
    }
    $app->{no_print_body} = 1;
    $app->send_http_header('text/javascript');

    require MT::Entry;
    require MT::Comment;
    require MT::Template;
    require MT::Template::Context;

    my $entry_id = $app->param('entry_id');
    return '1;' if ( !$entry_id );
    my $entry = MT::Entry->load($entry_id);
    return '1;' if ( !$entry );
    my $offset = $app->param('offset');
    $offset ||= 0;

    if ( $offset !~ /^\d+$/ ) {
        $offset = 0;
    }
    my $limit = $app->param('limit');
    $limit ||= 100;
    if ( $limit !~ /^\d+$/ ) {
        $limit = 100;
    }
    my $direction = 'ascend';
    if ( $app->param('direction') eq 'descend' ) {
        $direction = 'descend';
    }
    my $method = $app->param('method');
    $method ||= 'displayComments';
    my $tmpl = MT::Template->load(
        {   identifier => 'comment_listing',
            blog_id    => $entry->blog_id
        }
    );
    return '1;' if ( !$tmpl );
    my $total = MT::Comment->count( { entry_id => $entry_id, visible => 1 } );
    my @comments = MT::Comment->load( { entry_id => $entry_id, visible => 1 },
        { limit => $limit, offset => $offset, direction => $direction } );
    my $ctx = MT::Template::Context->new;
    $ctx->stash( 'entry',    $entry );
    $ctx->stash( 'entry_id', $entry->id );
    $ctx->stash( 'comments', \@comments );
    $ctx->var( 'commentTotal',     $total );
    $ctx->var( 'commentLimit',     $limit );
    $ctx->var( 'commentOffset',    $offset );
    $ctx->var( 'commentDirection', $direction );
    $ctx->var( 'cacheKey',         scalar $app->param('cacheKey') );

    my $json = $tmpl->build($ctx);
    if ($jsonp) {
        $app->print_encode("$jsonp($json);\n");
    }
    else {
        $app->print_encode($json);
    }

    return 1;
}

# deprecated
sub _commenter_status {
    my $app              = shift;
    my ($commenter_id)   = @_;
    my $blog_id          = $app->param('blog_id') || 0;
    my $commenter_status = '0';
    my $user             = $app->model('author')->load($commenter_id);
    if ( $user && $user->is_superuser ) {
        $commenter_status = 'AUTHOR';
    }
    else {

        # FIXME: this may be incomplete since the user
        # may in fact be able to comment on other blogs;
        # they just haven't signed into them yet
        my $perm = MT::Permission->load(
            {   blog_id     => $blog_id,
                permissions => { like => "\%'comment'\%" },
                author_id   => $commenter_id
            }
        );
        if ($perm) {
            if ( $perm->is_restricted('comment')
                && !$perm->can_do('force_post_comment') )
            {
                $commenter_status = '0';
            }
            else {
                $commenter_status = 'AUTHOR';
            }
        }
        elsif ( MT::Author::COMMENTER() == $user->type ) {
            $commenter_status = 'COMMENTER';
        }
        elsif ( $app->_check_commenter_author( $user, $blog_id ) ) {
            $commenter_status = 'AUTHOR';
        }
    }
    $commenter_status;
}

sub handle_error {
    my $app = shift;
    my ( $err, $status_line ) = @_;
    my $html = do_preview( $app, $app->{query}, $err )
        || return "An error occurred: " . $err;
    $app->{status_line} = $status_line;
    $html;
}

sub do_preview {
    my ( $app, $q, $err ) = @_;

    return $app->error( $app->translate("Invalid request") )
        if $app->request_method() ne 'POST';

    my $cfg = $app->config;
    require MT::Template;
    require MT::Template::Context;
    require MT::Entry;
    require MT::Util;
    require MT::Comment;
    require MT::Blog;
    my $entry_id = $q->param('entry_id')
        || return $app->error(
        $app->translate(
            'No entry was specified; perhaps there is a template problem?')
        );
    my $entry = MT::Entry->load($entry_id)
        || return $app->error(
        $app->translate(
            "Somehow, the entry you tried to comment on does not exist")
        );
    my $ctx  = MT::Template::Context->new;
    my $blog = MT::Blog->load( $entry->blog_id );

    my ( $comment, $commenter ) = $app->_make_comment( $entry, $blog );
    return $app->translate( "An error occurred: [_1]", $app->errstr() )
        unless $comment;

    ## Set timestamp as we would usually do in ObjectDriver.
    my @ts = MT::Util::offset_time_list( time, $entry->blog_id );
    my $ts = sprintf "%04d%02d%02d%02d%02d%02d", $ts[5] + 1900, $ts[4] + 1,
        @ts[ 3, 2, 1, 0 ];
    $comment->created_on($ts);
    $comment->commenter_id( $commenter->id ) if $commenter;

    $ctx->stash( 'comment', $comment );

    unless ($err) {
        ## Serialize comment state, then hex-encode it.
        require MT::Serialize;
        my $ser   = MT::Serialize->new( $cfg->Serializer );
        my $state = $comment->get_values;
        $state->{static} = $q->param('static');
        $ctx->stash( 'comment_state', unpack 'H*',
            $ser->serialize( \$state ) );
    }
    $ctx->stash( 'comment_is_static', $q->param('static') );
    $ctx->stash( 'entry',             $entry );
    $ctx->{current_timestamp} = $ts;
    $ctx->stash( 'commenter', $commenter );
    my ($tmpl);
    $err ||= '';
    if ($err) {
        $tmpl = MT::Template->load(
            {   type    => 'comment_response',
                blog_id => $entry->blog_id
            }
        );
        unless ($tmpl) {
            require MT::DefaultTemplates;
            $tmpl
                = MT::DefaultTemplates->load(
                { identifier => 'comment_response' } )
                or
                return $app->error( $app->translate("Cannot load template") );
            $tmpl->blog_id( $entry->blog_id );
            my $curr_lang = MT->current_language;
            $app->set_language( $blog->language );
            $tmpl->text( $app->translate_templatized( $tmpl->text ) );
            $app->set_language($curr_lang);
            $tmpl->text( $app->translate_templatized( $tmpl->text ) );
        }
        if ( $err eq 'pending' ) {
            $tmpl->context($ctx);
            $tmpl->param(
                {   'body_class'                => 'mt-comment-pending',
                    'comment_response_template' => 1,
                    'comment_pending'           => 1,
                    'return_to'                 => $entry->permalink || '',
                    'system_template'           => 1
                }
            );
        }
        else {
            $ctx->stash( 'error_message', $err );
            $tmpl->context($ctx);
            $tmpl->param(
                {   'body_class'                => 'mt-comment-error',
                    'comment_response_template' => 1,
                    'comment_error'             => 1,
                    'return_to'       => $app->param('return_url') || '',
                    'system_template' => 1
                }
            );
        }
    }
    else {
        $tmpl = MT::Template->load(
            {   type    => 'comment_preview',
                blog_id => $entry->blog_id
            }
        );
        unless ($tmpl) {
            require MT::DefaultTemplates;
            $tmpl
                = MT::DefaultTemplates->load(
                { identifier => 'comment_preview' } )
                or
                return $app->error( $app->translate("Cannot load template") );
            $tmpl->blog_id( $entry->blog_id );
            my $curr_lang = MT->current_language;
            $app->set_language( $blog->language );
            $tmpl->text( $app->translate_templatized( $tmpl->text ) );
            $app->set_language($curr_lang);
            $tmpl->text( $app->translate_templatized( $tmpl->text ) );
        }
        $tmpl->context($ctx);
        $tmpl->param(
            {   'body_class'               => 'mt-comment-preview',
                'comment_preview'          => 1,
                'comment_preview_template' => 1,
                'system_template'          => 1
            }
        );
    }

    my @data;
    $app->run_callbacks( 'cms_pre_preview', $app, $comment, \@data );

    my %cond;
    my $html = $tmpl->build( $ctx, \%cond );
    $html = $tmpl->errstr unless defined $html;
    $html;
}

sub edit_commenter_profile {
    my $app = shift;

    my ( $sess_obj, $commenter ) = $app->get_commenter_session();
    if ($commenter) {
        $app->user($commenter);
        $app->{session} = $sess_obj;

        my $url;
        my $entry_id = $app->param('entry_id');
        if ($entry_id) {
            my $entry = MT::Entry->load($entry_id);
            return $app->handle_error(
                $app->translate("Invalid entry ID provided") )
                unless $entry;
            $url = $entry->permalink;
        }
        else {
            $url = is_valid_url( $app->param('static')
                    || $app->param('return_url') );
        }

        my $blog_id = $app->param('blog_id');

        $app->user($commenter);
        my $param = {
            id       => $commenter->id,
            name     => $commenter->name,
            nickname => $commenter->nickname,
            email    => $commenter->email,
            url      => $commenter->url,
            blog_id  => $blog_id,
            $entry_id ? ( entry_url => $url ) : ( return_url => $url ),
        };
        $param->{ 'auth_mode_' . $commenter->auth_type } = 1;
        require MT::Auth;
        $param->{'email_required'} = MT::Auth->can_recover_password ? 1 : 0;

        if (    ( $commenter->auth_type eq 'MT' )
            and ( $commenter->column('password') !~ /^\$6\$|{SHA}/ )
            and ( not $param->{error} ) )
        {
            $param->{error} = $app->translate(
                "For improved security, please change your password");
        }

        return $app->build_page( 'profile.tmpl', $param );
    }
    return $app->handle_error( $app->translate('Invalid login') );
}

sub save_commenter_profile {
    my $app = shift;
    my $q   = $app->param;

    return $app->error( $app->translate("Invalid request") )
        if $app->request_method() ne 'POST';

    my ( $sess_obj, $cmntr ) = $app->get_commenter_session();
    return $app->handle_error( $app->translate('Invalid login') )
        unless $cmntr;

    my %param = map { $_ => scalar( $q->param($_) ) }
        qw( name nickname email password pass_verify url entry_url return_url external_auth blog_id );
    $param{blog_id} =~ s/\D//g if defined $param{blog_id};

    $param{ 'auth_mode_' . $cmntr->auth_type } = 1;

    $app->user($cmntr);
    $app->{session} = $sess_obj;

    my $original = $cmntr->clone();

    $app->validate_magic
        or return $app->handle_error( $app->translate('Invalid request') );

    if ( 'MT' eq $cmntr->auth_type ) {
        my $nickname = $param{nickname};
        unless ( $nickname && $param{email} ) {
            $param{error}
                = $app->translate('All required fields must be populated.');
            return $app->build_page( 'profile.tmpl', \%param );
        }
        if ( $nickname =~ m/([<>])/ ) {
            $param{error} = $app->translate(
                "[_1] contains an invalid character: [_2]",
                $app->translate("Display Name"),
                encode_html($1)
            );
            return $app->build_page( 'profile.tmpl', \%param );
        }
        if ( $param{password} ne $param{pass_verify} ) {
            $param{error} = $app->translate('Passwords do not match.');
            return $app->build_page( 'profile.tmpl', \%param );
        }
        require MT::Auth;
        if ($param{password}
            && not MT::Auth->is_valid_password(
                $cmntr, scalar( $q->param('old_pass') )
            )
            )
        {
            $param{error}
                = $app->translate('Failed to verify the current password.');
            return $app->build_page( 'profile.tmpl', \%param );
        }
    }
    my $email = $param{email};
    if ( $email && !is_valid_email($email) ) {
        $param{error} = $app->translate('Email Address is invalid.');
        return $app->build_page( 'profile.tmpl', \%param );
    }
    if ( $email && $email =~ m/([<>])/ ) {
        $param{error} = $app->translate(
            "[_1] contains an invalid character: [_2]",
            $app->translate("Email Address"),
            encode_html($1)
        );
        return $app->build_page( 'profile.tmpl', \%param );
    }
    if ( $param{url}
        && ( !is_url( $param{url} ) || ( $param{url} =~ m/[<>]/ ) ) )
    {
        $param{error} = $app->translate('URL is invalid.');
        return $app->build_page( 'profile.tmpl', \%param );
    }

    if ( !$app->run_callbacks( 'api_save_filter.author', $app ) ) {
        $param{error} = $app->errstr;
        return $app->build_page( 'profile.tmpl', \%param );
    }

    $cmntr->nickname( $param{nickname} ) if $param{nickname};
    $cmntr->email( $param{email} )       if $param{email};
    $cmntr->url( $param{url} )           if $param{url};
    $cmntr->set_password( $param{password} )
        if $param{password} && 'MT' eq $cmntr->auth_type;
    if (    ( $cmntr->column('password') !~ /^\$6\$|{SHA}/ )
        and ( 'MT' eq $cmntr->auth_type )
        and ( not $param{error} ) )
    {
        $param{error} = $app->translate(
            "For improved security, please change your password");
    }

    $cmntr->modified_on( epoch2ts( undef, time ) );
    if ( $cmntr->save ) {
        $app->run_callbacks( 'api_post_save.author', $app, $cmntr,
            $original );

        $param{saved} = $app->translate(
            'Commenter profile has successfully been updated.');
    }
    else {
        $param{error}
            = $app->translate( 'Commenter profile could not be updated: [_1]',
            $cmntr->errstr );
    }
    $param{magic_token} = $app->current_magic;

    return $app->build_page( 'profile.tmpl', \%param );
}

sub blog {
    my $app = shift;
    return $app->{_blog} if $app->{_blog};
    return undef unless $app->{query};
    if ( my $entry_id = $app->param('entry_id') ) {
        require MT::Entry;
        my $entry = MT::Entry->load($entry_id);
        return undef unless $entry;
        $app->{_blog} = $entry->blog if $entry;
    }
    elsif ( my $blog_id = $app->param('blog_id') ) {
        $app->{_blog} = MT::Blog->load( int($blog_id) );
    }
    return $app->{_blog};
}

sub start_recover {
    require MT::CMS::Tools;
    MT::CMS::Tools::start_recover(@_);
}

sub recover {
    require MT::CMS::Tools;
    MT::CMS::Tools::recover_password(@_);
}

sub new_pw {
    require MT::CMS::Tools;
    MT::CMS::Tools::new_password(@_);
}

sub redirect_to_edit_profile {
    my $app = shift;
    return $app->redirect( $app->uri( mode => 'edit_profile' ) );
}

1;
__END__

=head1 NAME

MT::App::Comments

=head1 SYNOPSIS

The application-level callbacks of the C<MT::App::Comments> application
are documented here.

=head1 METHODS

=head2 $app->init

Initializes the application and defines the serviceable modes.

=head2 $app->init_request

Initializes the application to service the request.

=head2 $app->do_preview($cgi[, $err])

Handles the comment preview request and displays the preview using
the Comment Preview blog template. If C<$err> is specified, the
error message is relayed to the user using the Comment Error blog
template.

=head2 $app->blog

Returns the L<MT::Blog> object related to the entry being commented on.

=head2 $app->eval_comment

Evaluates the comment being posted in a variety of ways and an L<MT::Comment>
object is returned. If the comment request is rejected due to throttling,
no object is returned and the Comment Pending blog template is displayed.

=head2 $app->handle_error

Returns an error message to the user using the Comment Error blog template.

=head1 APPLICATION MODES

=head2 $app->commenter_name_js

Returns some JavaScript code that sets the 'commenter_name' variable
based on the 'tk_commenter' cookie that is accessible to the comments
CGI script.

=head2 $app->do_red

Handles a commenter URL redirect, where the comment_id points to a
L<MT::Comment> object with a URL. The response redirects the user to
that URL. The comment must be approved and published.

Note: This behavior has been deprecated in favor of using the 'nofollow'
plugin.

=head2 $app->handle_sign_in

Handles the sign-in process for a sign-in request handled by external 
such authentication APIs as TypeKey and OpenID.

=head2 $app->post

Mode that handles posting of a new comment.

=head2 $app->preview

Mode for previewing a comment before posting.

=head1 CALLBACKS

=over 4

=item CommentThrottleFilter

Called as soon as a new comment has been received. The callback must
return a boolean value. If the return value is false, the incoming
comment data will be discarded and the app will output an error page
about throttling. A CommentThrottleFilter callback has the following
signature:

    sub comment_throttle_filter($cb, $app, $entry)
    {
        ...
    }

I<$app> is the C<MT::App::Comments> object, whose interface is documented
in L<MT::App::Comments>, and I<$entry> is the entry on which the
comment is to be placed.

Note that no comment object is passed, because it has not yet been
built. As such, this callback can be used to tell the application to
exit early from a comment attempt, before much processing takes place.

When more than one CommentThrottleFilter is installed, the data is
discarded unless all callbacks return true.

=item CommentFilter

Called once the comment object has been constructed, but before saving
it. If any CommentFilter callback returns false, the comment will not
be saved. The callback has the following signature:

    sub comment_filter($cb, $app, $comment)
    {
        ...
    }

=back

=head1 SPAM PROTECTION

Spam filtering (or "Junk" filtering in MT terminology) is handled using
the L<MT::JunkFilter> package and plugins that implement them. Please
refer to that module for further documentation.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=cut
