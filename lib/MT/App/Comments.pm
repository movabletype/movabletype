# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::App::Comments;
use strict;

use MT::App;
@MT::App::Comments::ISA = qw( MT::App );

use MT::Comment;
use MT::I18N qw( wrap_text encode_text );
use MT::Util
  qw( remove_html encode_html encode_url decode_url is_valid_email is_valid_url escape_unicode format_ts );
use MT::Entry qw(:constants);
use MT::Author;
use MT::JunkFilter qw(:constants);

sub id { 'comments' }

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods(
        login            => \&login,
        login_external   => \&login_external,
        do_login         => \&do_login,
        signup           => \&signup,
        do_signup        => \&do_signup,
        register         => \&register,
        do_register      => \&do_register,
        preview          => \&preview,
        post             => \&post,
        view             => \&view,
        handle_sign_in   => \&handle_sign_in,
        cmtr_name_js     => \&commenter_name_js,
        edit_profile     => \&edit_commenter_profile,
        save_profile     => \&save_commenter_profile,
        red              => \&do_red,
        generate_captcha => \&generate_captcha,
        reply            => \&reply,
        do_reply         => \&do_reply,
        reply_preview    => \&reply_preview,
    );
    $app->{template_dir} = 'comment';
    $app->init_commenter_authenticators;
    $app->init_captcha_providers();
    $app;
}

sub init_request {
    my $app = shift;
    $app->SUPER::init_request(@_);

    $app->{default_mode} = 'view';
    my $q = $app->param;

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

#
# $app->_get_commenter_session() #
# Creates a commenter record based on the cookies in the $app, if
# one already exists corresponding to the browser's session.
#
# Returns a pair ($session_key, $commenter) where $session_key is the
# key to the MT::Session object (as well as the cookie value) and
# $commenter is an MT::Author record. Both values are undef when no
# session is active.
#
sub _get_commenter_session {
    my $app = shift;
    my $q   = $app->param;

    my $session_key;

    my %cookies = $app->cookies();
    if ( !$cookies{ $app->COMMENTER_COOKIE_NAME() } ) {
        return ( undef, undef );
    }
    $session_key = $cookies{ $app->COMMENTER_COOKIE_NAME() }->value() || "";
    $session_key =~ y/+/ /;
    my $cfg = $app->config;
    require MT::Session;
    my $sess_obj = MT::Session->load( { id => $session_key } );
    my $timeout = $cfg->CommentSessionTimeout;
    my $user;

    if ( $sess_obj
        && ( $user = MT::Author->load( { name => $sess_obj->name } ) ) )
    {
        return ( $session_key, $user ) if $user->type eq MT::Author::AUTHOR();
    }
    if (   !$sess_obj
        || ( $sess_obj->start() + $timeout < time )
        || ( $q->param('email') && ( $sess_obj->email ne $q->param('email') ) )
        || ( $q->param('author') && ( $user->nickname ne $q->param('author') ) )
      )
    {
        $app->_invalidate_commenter_session( \%cookies );
        return ( undef, undef );
    }
    else {

        # session is valid!
        return ( $session_key, $user );
    }
}

sub login {
    my $app   = shift;
    my %param = @_;

    my $param = {
        blog_id => ($app->param('blog_id') || 0),
        static  => ($app->param('static') || ''),
        return_url => ($app->param('return_url') || ''),
    };
    $param->{entry_id} = $app->param('entry_id') if $app->param('entry_id');
    while ( my ( $key, $val ) = each %param ) {
        $param->{$key} = $val;
    }

    my $external_authenticators = [];

    my $ca_reg = $app->registry("commenter_authenticators");

    my $blog = MT::Blog->load( $param->{blog_id} );
    my @auths = split ',', $blog->commenter_authenticators;
    my %otherauths;
    foreach my $key (@auths) {
        if ( $key eq 'MovableType' ) {
            $param->{enabled_MovableType} = 1;
            $param->{default_signin} = 'MovableType';
            my $cfg = $app->config;
            if ( my $registration = $cfg->CommenterRegistration ) {
                if (   ( $cfg->AuthenticationModule eq 'MT' )
                    || ( !$cfg->ExternalUserManagement ) )
                {
                    $param->{registration_allowed} = $registration->{Allow}
                      && $blog->allow_commenter_regist ? 1 : 0;
                }
            }
            require MT::Auth;
            $param->{can_recover_password} = MT::Auth->can_recover_password;
            next;
        }
        my $auth = $ca_reg->{$key};
        next unless $auth;
        if (   $key ne 'TypeKey'
            && $key ne 'OpenID'
            && $key ne 'Vox'
            && $key ne 'LiveJournal' )
        {
            push @$external_authenticators,
              {
                name       => $auth->{label},
                key        => $auth->{key},
                login_form => $app->_get_options_html($key),
                exists($auth->{logo}) ? (logo => $auth->{logo}) : (),
              };
        }
        else {
            $otherauths{$key} = {
                name       => $auth->{label},
                key        => $auth->{key},
                login_form => $app->_get_options_html($key),
                exists($auth->{logo}) ? (logo => $auth->{logo}) : (),
            };
        }
    }

    unshift @$external_authenticators, $otherauths{'TypeKey'}
      if exists $otherauths{'TypeKey'};
    unshift @$external_authenticators, $otherauths{'Vox'}
      if exists $otherauths{'Vox'};
    unshift @$external_authenticators, $otherauths{'LiveJournal'}
      if exists $otherauths{'LiveJournal'};
    unshift @$external_authenticators, $otherauths{'OpenID'}
      if exists $otherauths{'OpenID'};

    if ( @$external_authenticators ) {
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
            {
                message  => $error,
                level    => MT::Log::ERROR(),
                class    => 'system',
                category => 'register_commenter'
            }
        );
        return undef;
    }
    my $commenter = MT::Author->new;
    $commenter->name( $app->param('username') );
    $commenter->nickname( $app->param('nickname') );
    $commenter->set_password( $app->param('password') );
    $commenter->email( $app->param('email') );
    $commenter->external_id( $app->param('external_id') );
    $commenter->type( MT::Author::AUTHOR() );
    $commenter->status( MT::Author::ACTIVE() );
    return undef unless ( $commenter->save );

    require MT::Role;
    require MT::Association;
    my $role = MT::Role->load_same( undef, undef, 1, 'comment' );
    if ( $role && ( my $blog = MT::Blog->load($blog_id) ) ) {
        MT::Association->link( $commenter => $role => $blog );
    }
    else {
        $app->log(
            {
                message => MT->translate(
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
    $app->user($commenter);
    $commenter;
}

sub do_login {
    my $app     = shift;
    my $q       = $app->param;
    my $name    = $q->param('username');
    my $blog_id = $q->param('blog_id');
    my $blog    = MT::Blog->load($blog_id);
    my $auths   = $blog->commenter_authenticators;
    if ( $auths !~ /MovableType/ ) {
        $app->log(
            {
                message => $app->translate(
'Invalid commenter login attempt from [_1] to blog [_2](ID: [_3]) which does not allow Movable Type native authentication.',
                    $name, $blog->name, $blog_id
                ),
                level    => MT::Log::WARNING(),
                category => 'login_commenter',
            }
        );
        return $app->login( error => $app->translate('Invalid login.') );
    }

    require MT::Auth;
    my $ctx = MT::Auth->fetch_credentials( { app => $app } );
    $ctx->{blog_id} = $blog_id;
    my $result = MT::Auth->validate_credentials($ctx);
    my $message;
    if (   ( MT::Auth::NEW_LOGIN() == $result )
        || ( MT::Auth::SUCCESS() == $result ) )
    {
        my $commenter = $app->user;
        if ( $q->param('external_auth') && !$commenter ) {
            $app->param( 'name', $name );
            $commenter =
              $app->_create_commenter_assign_role( $q->param('blog_id') );
            return $app->signup( error => $app->translate('Invalid login') )
              unless $commenter;
        }
        MT::Auth->new_login( $app, $commenter );
        if ( $app->_check_commenter_author( $commenter, $blog_id ) ) {
            $app->_make_commenter_session( $app->make_magic_token,
                $commenter->email, $commenter->name,
                ($commenter->nickname || 'User#' . $commenter->id),
                $commenter->id, undef, $ctx->{permanent} ? '+10y' : 0 );
            #$app->start_session( $commenter, $ctx->{permanent} ? 1 : 0 );
            return $app->redirect_to_target;
        }
        $message =
          $app->translate( "Login failed: permission denied for user '[_1]'",
            $name );
    }
    elsif ( MT::Auth::INVALID_PASSWORD() == $result ) {
        $message =
          $app->translate( "Login failed: password was wrong for user '[_1]'",
            $name );
    }
    elsif ( MT::Auth::INACTIVE() == $result ) {
        $message =
          $app->translate( "Failed login attempt by disabled user '[_1]'",
            $name );
    }
    else {
        $message =
          $app->translate( "Failed login attempt by unknown user '[_1]'",
            $name );
    }
    $app->log(
        {
            message  => $message,
            level    => MT::Log::WARNING(),
            category => 'login_commenter',
        }
    );
    MT::Auth->invalidate_credentials($ctx);
    if ( $q->param('external_auth') ) {
        return $app->signup( error => $app->translate('Invalid login') );
    }
    else {
        return $app->login( error => $app->translate('Invalid login.') );
    }
}

sub signup {
    my $app   = shift;
    my %opt   = @_;
    my $param = {};
    $param->{$_} = $app->param($_) foreach qw(blog_id entry_id static);
    my $blog = $app->model('blog')->load( $param->{blog_id} );
    my $cfg  = $app->config;
    if ( my $registration = $cfg->CommenterRegistration ) {
        return $app->handle_error(
            $app->translate('Signing up is not allowed.') )
          unless $registration->{Allow} && $blog->allow_commenter_regist;
        if ( my $provider = MT->effective_captcha_provider( $blog->captcha_provider ) ) {
            $param->{captcha_fields} = $provider->form_fields( $blog->id );
        }
        $param->{error} = $opt{error} if $opt{error};
        $param->{ 'auth_mode_' . $cfg->AuthenticationModule } = 1;
        return $app->build_page( 'signup.tmpl', $param );
    }
    $app->handle_error( $app->translate('Signing up is not allowed.') );
}

sub do_signup {
    my $app = shift;
    my $q   = $app->param;

    my $cfg   = $app->config;
    my $param = {};
    $param->{$_} = $q->param($_)
      foreach
      qw(blog_id entry_id static email url username nickname email hint);
    $param->{ 'auth_mode_' . $cfg->AuthenticationModule } = 1;

    my $blog = $app->model('blog')->load( $param->{blog_id} );

    if ( my $provider = MT->effective_captcha_provider( $blog->captcha_provider ) ) {
        $param->{captcha_fields} = $provider->form_fields( $blog->id );
    }

    if ( $q->param('password') ne $q->param('pass_verify') ) {
        $param->{error} = $app->translate('Passwords do not match.');
        return $app->build_page( 'signup.tmpl', $param );
    }

    my $name = $q->param('username');
    if ( defined $name ) {
        $name =~ s/(^\s+|\s+$)//g;
        $param->{name} = $name;
    }
    unless ( defined($name) && $name ) {
        $param->{error} = $app->translate("User requires username.");
        return $app->build_page( 'signup.tmpl', $param );
    }

    my $nickname = $q->param('nickname');
    unless ($nickname) {
        $param->{error} = $app->translate("User requires display name.");
        return $app->build_page( 'signup.tmpl', $param );
    }

    my $existing = MT::Author->count( { name => $name } );
    $param->{error} =
      $app->translate("A user with the same name already exists.");
    return $app->build_page( 'signup.tmpl', $param ) if $existing;

    my $password = $q->param('password');
    unless ($password) {
        $param->{error} = $app->translate("User requires password.");
        return $app->build_page( 'signup.tmpl', $param );
    }

    my $hint = $q->param('hint');
    unless ($hint) {
        $param->{error} =
          $app->translate("User requires password recovery word/phrase.");
        return $app->build_page( 'signup.tmpl', $param );
    }

    my $email = $q->param('email');
    if ($email) {
        unless ( is_valid_email($email) ) {
            delete $param->{email};
            $param->{error} = $app->translate("Email Address is invalid.");
            return $app->build_page( 'signup.tmpl', $param );
        }
    }
    else {
        delete $param->{email};
        $param->{error} =
          $app->translate("Email Address is required for password recovery.");
        return $app->build_page( 'signup.tmpl', $param );
    }

    my $url = $q->param('url');
    if ( $url && !is_valid_url($url) ) {
        delete $param->{url};
        $param->{error} = $app->translate("URL is invalid.");
        return $app->build_page( 'signup.tmpl', $param );
    }

    if ( my $provider = MT->effective_captcha_provider( $blog->captcha_provider ) ) {
        unless ( $provider->validate_captcha($app) ) {
            $param->{error} =
              $app->translate("Text entered was wrong.  Try again.");
            $param->{captcha_fields} = $provider->form_fields( $blog->id );
            return $app->build_page( 'signup.tmpl', $param );
        }
    }

    my $commenter = MT::Author->new;
    $commenter->name($name);
    $commenter->nickname($nickname);
    $commenter->set_password( $q->param('password') );
    $commenter->email($email);
    $commenter->url($url)   if $url;
    $commenter->hint($hint) if $hint;
    $commenter->type( MT::Author::AUTHOR() );
    $commenter->status( MT::Author::PENDING() );

    unless ( $commenter->save ) {
        $param->{error} =
          $app->translate(
            "Something wrong happened when trying to process signup: [_1]",
            $commenter->errstr );
        return $app->build_page( 'signup.tmpl', $param );
    }

    ## Send confirmation email in the background.
    MT::Util::start_background_task(
        sub {
            $app->_send_signup_confirmation( $commenter->id, $email,
                $param->{entry_id}, $param->{blog_id}, $param->{static} );
        }
    );

    my $entry = MT::Entry->load( $param->{entry_id} );
    if ($entry) {
        my $entry_url = $entry->permalink;
        $app->build_page( 'signup_thanks.tmpl',
            { email => $email, entry_url => $entry_url } );
    }
    else {
        $app->build_page( 'signup_thanks.tmpl',
            { email => $email, return_url => is_valid_url( $param->{static} ) }
        );
    }
}

sub _send_signup_confirmation {
    my $app = shift;
    my ( $id, $email, $entry_id, $blog_id, $static ) = @_;
    my $cfg = $app->config;

    my $blog   = MT::Blog->load($blog_id);
    my $entry  = MT::Entry->load($entry_id);
    my $author = $entry ? $entry->author : q();

    my $token = $app->make_magic_token;

    my $subject = $app->translate('Movable Type Account Confirmation');
    my $url     = $app->mt_path 
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
        blog_name   => $blog->name,
        email       => $email,
        confirm_url => $url,
    };
    if ( $author && ( $author->nickname ) ) {
        $param->{author_name} = $author->nickname;
    }
    else {
        $param->{author_name} = 'Movable Type';
    }
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
            {
                message =>
                  MT->translate("System Email Address is not configured."),
                level    => MT::Log::ERROR(),
                class    => 'system',
                category => 'email'
            }
        );
        return;
    }

    my %head = (
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
    $sess->save;

    MT::Mail->send( \%head, $body )
      or return $app->handle_error( MT::Mail->errstr() );
}

sub do_register {
    my $app = shift;
    my $q   = $app->param;
    my $cfg = $app->config;

    my $entry_id = $q->param('entry_id');
    my $blog_id  = $q->param('blog_id');
    my $static   = $q->param('static');
    my $email    = $q->param('email');
    my $token    = $q->param('token');

    my $param = {};
    $param->{$_} = $app->param($_) foreach qw(blog_id entry_id static);

    my $blog = $app->model('blog')->load($blog_id);
    ## Token expiration check
    require MT::Session;
    my $commenter;
    my $sess =
      MT::Session->load( { id => $token, kind => 'CR', email => $email } );
    if ($sess) {
        $commenter = MT::Author->load( $sess->name );
        if ( $sess->start() < ( time - 60 * 60 * 24 ) ) {
            $commenter->remove;
            $sess->remove;
            $sess = $commenter = undef;
        }
    }
    unless ($sess) {
        if ( my $provider = MT->effective_captcha_provider( $blog->captcha_provider ) ) {
            $param->{captcha_fields} = $provider->form_fields( $blog->id );
        }
        return $app->build_page( 'signup.tmpl', $param );
    }
    $sess->remove;

    $commenter->status( MT::Author::ACTIVE() );
    if ( $commenter->save ) {
        $app->log(
            {
                message => $app->translate(
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
                {
                    message => MT->translate(
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
    }
    else {
        if ( my $provider = MT->effective_captcha_provider( $blog->captcha_provider ) ) {
            $param->{captcha_fields} = $provider->form_fields( $blog->id );
        }
        $param->{error} = $commenter->errstr;
        return $app->build_page( 'signup.tmpl', $param );
    }

    if ( my $registration = $cfg->CommenterRegistration ) {
        if ( my $ids = $registration->{Notify} ) {
            ## Send notification email in the background.
            MT::Util::start_background_task(
                sub {
                    $app->_send_registration_notification( $commenter->name,
                        $email, $entry_id, $blog_id, $ids );
                }
            );
        }
    }

    $app->login(
        message => $app->translate(
            'Thanks for the confirmation.  Please sign in to comment.')
    );
}

sub _send_registration_notification {
    my $app = shift;
    my ( $username, $email, $entry_id, $blog_id, $ids ) = @_;
    my $cfg = $app->config;

    my @ids = split ',', $ids;
    my @sysadmins = MT::Author->load(
        {
            id   => \@ids,
            type => MT::Author::AUTHOR()
        },
        {
            join => MT::Permission->join_on(
                'author_id',
                {
                    permissions => "\%'administer'\%",
                    blog_id     => '0',
                },
                { 'like' => { 'permissions' => 1 } }
            )
        }
    );
    my $blog    = MT::Blog->load($blog_id);
    my $subject = $app->translate( "[_1] registered to the blog '[_2]'",
        $username, $blog->name );
    foreach my $a (@sysadmins) {
        next unless $a->email && is_valid_email( $a->email );

        my $param = {
            blogname => $blog->name,
            username => $username,
        };
        my $body = MT->build_email( 'commenter_notify.tmpl', $param );

        require MT::Mail;

        my $from_addr;
        my $reply_to;
        if ( $cfg->EmailReplyTo ) {
            $reply_to = $cfg->EmailAddressMain || $email;
        }
        else {
            $from_addr = $cfg->EmailAddressMain || $email;
        }
        $from_addr = undef if $from_addr && !is_valid_email($from_addr);
        $reply_to  = undef if $reply_to  && !is_valid_email($reply_to);

        unless ( $from_addr || $reply_to ) {
            $app->log(
                {
                    message =>
                      MT->translate("System Email Address is not configured."),
                    level    => MT::Log::ERROR(),
                    class    => 'system',
                    category => 'email'
                }
            );
            return;
        }

        my %head = (
            To => $a->email,
            $from_addr ? ( From       => $from_addr ) : (),
            $reply_to  ? ( 'Reply-To' => $reply_to )  : (),
            Subject => $subject,
        );
        my $charset = $cfg->MailEncoding || $cfg->PublishCharset;
        $head{'Content-Type'} = qq(text/plain; charset="$charset");
        MT::Mail->send( \%head, $body );
    }
}

sub generate_captcha {
    my $app = shift;

    my $pi = $app->path_info; 
    $pi =~ s!^/!!;
    my $cmtscript = $app->config('CommentScript');
    $pi =~ s!.*\Q$cmtscript\E/!!;
    $pi =~ s,captcha/,,; #remove prefix.. 
    my ($blog_id, $token) = split '/', $pi;
    unless ( $blog_id && $token ) {
        $app->error('Required parameter was missing.');
        return undef;
    }
    my $blog = $app->model('blog')->load($blog_id);
    if ( my $provider = MT->effective_captcha_provider( $blog->captcha_provider ) ) {
        my $image_data = $provider->generate_captcha($app, $blog_id, $token);
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
    my $id  = $q->param('id') or return $app->error( $app->translate("No id") );
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
    my @ts =
      MT::Util::offset_time_list( time - $throttle_period, $entry->blog_id );
    my $from = sprintf(
        "%04d%02d%02d%02d%02d%02d",
        $ts[5] + 1900,
        $ts[4] + 1,
        @ts[ 3, 2, 1, 0 ]
    );
    require MT::Comment;

    if (
        MT::Comment->count(
            {
                ip         => $user_ip,
                created_on => [$from],
                blog_id    => $entry->blog_id
            },
            { range => { created_on => 1 } }
        )
      )
    {
        return 0;    # Put a collar on that puppy.
    }
    @ts = MT::Util::offset_time_list( time - $throttle_period * 10 - 1,
        $entry->blog_id );
    $from = sprintf(
        "%04d%02d%02d%02d%02d%02d",
        $ts[5] + 1900,
        $ts[4] + 1,
        @ts[ 3, 2, 1, 0 ]
    );
    my $count = MT::Comment->count(
        {
            ip         => $user_ip,
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
            {
                message => $app->translate(
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

        my $blog = MT::Blog->load( $entry->blog_id );
        if ( $author && $author->email ) {
            my %head = (
                To      => $author->email,
                From    => $cfg->EmailAddressMain,
                Subject => '['
                  . $blog->name . '] '
                  . $app->translate("IP Banned Due to Excessive Comments")
            );
            my $charset = $cfg->MailEncoding || $cfg->PublishCharset;
            $head{'Content-Type'} = qq(text/plain; charset="$charset");
            my $body =
              $app->translate( '_THROTTLED_COMMENT_EMAIL', $blog->name,
                10 * $throttle_period,
                $user_ip, $user_ip );
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

    my $entry_id = $q->param('entry_id')
      or return $app->error( $app->translate("No entry_id") );
    require MT::Entry;
    my $entry = MT::Entry->load($entry_id)
      or return $app->error(
        $app->translate(
            "No such entry '[_1]'.", scalar $q->param('entry_id')
        )
      );
    return $app->error(
        $app->translate(
            "No such entry '[_1]'.", scalar $q->param('entry_id')
        )
    ) if $entry->status != RELEASE;

    require MT::IPBanList;
    my $iter = MT::IPBanList->load_iter( { blog_id => $entry->blog_id } );
    while ( my $ban = $iter->() ) {
        my $banned_ip = $ban->ip;
        if ( $app->remote_ip =~ /$banned_ip/ ) {
            return $app->handle_error(
                $app->translate("You are not allowed to add comments.") );
        }
    }

    MT->add_callback( 'CommentThrottleFilter', 1, undef,
        \&MT::App::Comments::_builtin_throttle );

    # Run all the Comment-throttling callbacks
    my $passed_filter =
      MT->run_callbacks( 'CommentThrottleFilter', $app, $entry );

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

    my $blog = $app->model('blog')->load( $entry->blog_id );

    my $text = $q->param('text') || '';
    $text =~ s/^\s+|\s+$//g;
    if ( $text eq '' ) {
        return $app->handle_error(
            $app->translate("Comment text is required.") );
    }

    my ( $comment, $commenter ) = _make_comment( $app, $entry, $blog );
    return $app->handle_error(
        $app->translate( "An error occurred: [_1]", $app->errstr() ) )
      unless $comment;

    my $remember = $q->param('bakecookie') || 0;
    $remember = 0 if $remember eq 'Forget Info';    # another value for '0'
    if ( $commenter && $remember ) {
        $app->_extend_commenter_session( Duration => "+1y" );
    }
    if ( !$blog->allow_unreg_comments ) {
        if ( !$commenter ) {
            return $app->handle_error(
                $app->translate("Registration is required.") );
        }
    }
    if (
           $blog->require_comment_emails()
        && !$commenter
        && !(
               $comment->author
            && $comment->email
            && is_valid_email( $comment->email )
        )
      )
    {
        return $app->handle_error(
            $app->translate("Name and email address are required.") );
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
        if ( my $fixed = is_valid_url( $comment->url, 'stringent' ) ) {
            $comment->url($fixed);
        }
        else {
            return $app->handle_error(
                $app->translate( "Invalid URL '[_1]'", $comment->url ) );
        }
    }

    if ( !$commenter && ( my $provider = MT->effective_captcha_provider( $blog->captcha_provider ) ) ) {
        unless ( $provider->validate_captcha($app) ) {
            return $app->handle_error(
                $app->translate("Text entered was wrong.  Try again.") );
        }
    }

    $comment = $app->eval_comment( $blog, $commenter, $comment, $entry );
    return $app->preview('pending') unless $comment;

    $app->user($commenter);
    $comment->save
      or $app->log(
        {
            message => $app->translate(
                "Comment save failed with [_1]",
                $comment->errstr
            ),
            blog_id => $blog->id,
            class   => 'comment',
            level   => MT::Log::ERROR()
        }
      );
    if ( $comment->id && !$comment->is_junk ) {
        $app->log(
            {
                message => $app->translate(
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
    if ($commenter) {
        $commenter->url( $comment->url ) if $comment->url;
        $commenter->save
          or $app->log(
            {
                message => $app->translate(
                    "Commenter save failed with [_1]",
                    $commenter->errstr
                ),
                class   => 'system',
                blog_id => $blog->id,
                level   => MT::Log::ERROR()
            }
          );
    }

    #    return $app->handle_error($app->errstr()) unless $comment;

    # Form a link to the comment
    my $comment_link;
    if ( !$q->param('static') ) {
        my $url = $app->base . $app->uri;
        $url .= '?entry_id=' . $q->param('entry_id');
        $url .= '&static=0&arch=1' if ( $q->param('arch') );
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
            $comment_link = $static . '#' . $comment->id;
        }
    }

    if ( $comment->visible ) {

        # Rebuild the entry synchronously so that if the user gets
        # redirected to the indiv. page it will be up-to-date.
        $app->rebuild_entry( Entry => $entry->id )
          or return $app->error(
            $app->translate( "Publish failed: [_1]", $app->errstr ) );
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
            $app->rebuild_indexes( Blog => $blog )
              or return $app->errtrans( "Publish failed: [_1]", $app->errstr );
            $app->_send_comment_notification( $comment, $comment_link, $entry,
                $blog, $commenter );
            _expire_sessions( $cfg->CommentSessionTimeout )
              if ( $commenter && ( $commenter->type ne MT::Author::AUTHOR() ) );
        }
    );

    if ( $blog->use_comment_confirmation ) {
        my $tmpl =
          MT::Template->load(
            { type => 'comment_response', blog_id => $entry->blog_id } );
        unless ($tmpl) {
            require MT::DefaultTemplates;
            ($tmpl) = MT::DefaultTemplates->load({ type => 'comment_response' });
            $tmpl->text( $app->translate_templatized( $tmpl->text ) );
        }
        my $ctx = $tmpl->context;
        $tmpl->param(
            { 'body_class' => 'mt-comment-confirmation', 'comment_link' => $comment_link } );
        $ctx->stash('entry', $entry);
        $ctx->stash('comment', $comment);
        $ctx->stash('commenter', $commenter) if $commenter;
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
        && ( $commenter->commenter_status( $blog->id ) == MT::Author::BLOCKED() ) )
    {
        return undef;
    }

    # Before saving this comment, check whether this commenter has
    # placed any other comments on the entry's author's other entries.
    # (on any other entries by the same author as this one)

    my $commenter_has_comment = _commenter_has_comment( $commenter, $entry );

    my $commenter_status;
    if ($commenter) {
        if ( MT::Author::COMMENTER() eq $commenter->type ) {
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
        elsif ( MT::Author::AUTHOR() eq $commenter->type ) {
            $comment->approve;
            return $comment;
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

# only handles Duration => +xxxu where u is one of y, d, s
sub _extend_commenter_session {
    my $app         = shift;
    my %param       = @_;
    my %cookies     = $app->cookies();
    my $session_key = $cookies{ $app->COMMENTER_COOKIE_NAME() }->value() || "";
    $session_key =~ y/+/ /;
    my $sessobj = MT::Session->load($session_key);
    return
      if
      !$sessobj;   # no point changing the cookie if the session's already lost.
    my ( $sign, $number, $units ) = $param{Duration} =~ /([+-]?)(\d+)(\w+)/;
    $number *= $sign eq '-' ? -1 : +1;
    $number *=
        $units eq 'y' ? 60 * 60 * 24 * 365
      : $units eq 'd' ? 60 * 60 * 24
      :                 $number;
    $sessobj->start( $sessobj->start + $number );
    $sessobj->save();
    my %sess_cookie = (
        -name    => $app->COMMENTER_COOKIE_NAME(),
        -value   => $session_key,
        -path    => '/',
        -expires => "+${number}s"
    );
    $app->bake_cookie(%sess_cookie);
    my %name_kookee = (
        -name    => "commenter_name",
        -value   => $cookies{commenter_name}->value,
        -path    => '/',
        -expires => "+${number}s"
    );
    $app->bake_cookie(%name_kookee);
    1;
}

sub _check_commenter_author {
    my $app = shift;
    my ( $commenter, $blog_id ) = @_;
    return 0 if $commenter->status == MT::Author::INACTIVE();
    if ( MT::Author::PENDING() eq $commenter->status ) {
        $app->error(
            $app->translate(
                "Failed comment attempt by pending registrant '[_1]'",
                $commenter->name
            )
        );
        return 0;
    }
    elsif ( $commenter->blog_perm($blog_id)->can_comment ) {
        return 1;
    }
    else {
        if ( my $registration = $app->config->CommenterRegistration ) {
            my $blog = MT::Blog->load($blog_id);
            if ( $registration->{Allow} && $blog->allow_commenter_regist ) {
                my $perm = $commenter->blog_perm($blog_id);
                return 0 unless $perm->is_empty;
                require MT::Role;
                require MT::Association;
                my $role = MT::Role->load_same( undef, undef, 1, 'comment' );
                if ( $role && $blog ) {
                    MT::Association->link( $commenter => $role => $blog );
                }
                else {
                    $app->log(
                        {
                            message => MT->translate(
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
    my ( $session, $commenter );
    if ( $blog->accepts_registered_comments ) {
        ( $session, $commenter ) = $app->_get_commenter_session();
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

    my $url = $q->param('url') || '';    #($commenter ? $commenter->url() : '');
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
    $url = is_valid_url( $url, 'stringent' );
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

    return ( $comment, $commenter );
}

sub _commenter_has_comment {
    my ( $commenter, $entry ) = @_;

    my $commenter_has_comment = 0;
    if ($commenter) {
        my $other_comment =
          MT::Comment->load( { commenter_id => $commenter->id } );
        if ($other_comment) {
            my $other_entry = MT::Entry->load(
                { author_id => $entry->author_id },
                {
                    join => [
                        'MT::Comment', 'entry_id',
                        { commenter_id => $commenter->id }, {}
                    ]
                }
            );
            $commenter_has_comment = !!$other_entry;
        }
    }
    $commenter_has_comment;
}

sub _send_comment_notification {
    my $app = shift;
    my ( $comment, $comment_link, $entry, $blog, $commenter ) = @_;

    return unless $blog->email_new_comments;

    my $cfg                   = $app->config;
    my $commenter_has_comment = _commenter_has_comment( $commenter, $entry );
    my $attn_reqd             = $comment->is_moderated;

    if ( $blog->email_attn_reqd_comments && !$attn_reqd ) {
        return;
    }

    require MT::Mail;
    my $author = $entry->author;
    $app->set_language( $author->preferred_language )
      if $author && $author->preferred_language;
    my $from_addr;
    my $reply_to;
    if ( $cfg->EmailReplyTo ) {
        $reply_to = $comment->email;
    }
    else {
        $from_addr = $comment->email;
    }
    $from_addr = undef if $from_addr && !is_valid_email($from_addr);
    $reply_to  = undef if $reply_to  && !is_valid_email($reply_to);
    if ( $author && $author->email ) {  # } && is_valid_email($author->email)) {
        if ( !$from_addr ) {
            $from_addr = $cfg->EmailAddressMain || $author->email;
            $from_addr = $comment->author . ' <' . $from_addr . '>'
              if $comment->author;
        }
        my %head = (
            To => $author->email,
            $from_addr ? ( From       => $from_addr ) : (),
            $reply_to  ? ( 'Reply-To' => $reply_to )  : (),
            Subject => '['
              . $blog->name . '] '
              . $app->translate( "New Comment Added to '[_1]'", $entry->title )
        );
        my $charset = $cfg->MailEncoding || $cfg->PublishCharset;
        $head{'Content-Type'} = qq(text/plain; charset="$charset");
        my $base;
        {
            local $app->{is_admin} = 1;
            $base = $app->base . $app->mt_uri;
        }
        if ( $base =~ m!^/! ) {
            my ($blog_domain) = $blog->site_url =~ m|(.+://[^/]+)|;
            $base = $blog_domain . $base;
        }
        my $nonce =
          MT::Util::perl_sha1_digest_hex( $comment->id
              . $comment->created_on
              . $blog->id
              . $cfg->SecretToken );
        my $approve_link = $base
          . $app->uri_params(
            'mode' => 'approve_item',
            args   => {
                blog_id => $blog->id,
                '_type' => 'comment',
                id      => $comment->id,
                nonce   => $nonce
            }
          );
        my $spam_link = $base
          . $app->uri_params(
            'mode' => 'unapprove_item',
            args   => {
                blog_id => $blog->id,
                '_type' => 'comment',
                id      => $comment->id,
                nonce   => $nonce
            }
          );
        my %param = (
            blog_name   => $blog->name,
            entry_id    => $entry->id,
            entry_title => $entry->title,
            view_url    => $comment_link,
            approve_url => $approve_link,
            spam_url    => $spam_link,
            edit_url    => $base
              . $app->uri_params(
                'mode' => 'view',
                args   => {
                    blog_id => $blog->id,
                    '_type' => 'comment',
                    id      => $comment->id
                }
              ),
            ban_url => $base
              . $app->uri_params(
                'mode' => 'save',
                args   => {
                    '_type' => 'banlist',
                    blog_id => $blog->id,
                    ip      => $comment->ip
                }
              ),
            comment_ip   => $comment->ip,
            comment_name => $comment->author,
            (
                is_valid_email( $comment->email )
                ? ( comment_email => $comment->email )
                : ()
            ),
            comment_url  => $comment->url,
            comment_text => wrap_text( $comment->text, 72 ),
            unapproved   => !$comment->visible(),
        );
        my $body = MT->build_email( 'new-comment.tmpl', \%param );
        MT::Mail->send( \%head, $body )
          or return $app->handle_error( MT::Mail->errstr() );
    }
}

sub preview { my $app = shift; do_preview( $app, $app->{query}, @_ ) }

sub _make_commenter {
    my $app    = shift;
    my %params = @_;
    require MT::Author;
    my $cmntr = MT::Author->load(
        {
            name => $params{name},
            type => MT::Author::COMMENTER
        }
    );
    if ( !$cmntr ) {
        $cmntr = MT::Author->new();
        $cmntr->set_values(
            {
                email    => $params{email},
                name     => $params{name},
                nickname => $params{nickname},
                password => "(none)",
                type     => MT::Author::COMMENTER,
                url      => $params{url},
            }
        );
        $cmntr->save();
    }
    else {
        $cmntr->set_values(
            {
                email    => $params{email},
                nickname => $params{nickname},
                password => "(none)",
                type     => MT::Author::COMMENTER,
                url      => $params{url},
            }
        );
        $cmntr->save();
    }
    return $cmntr;
}

# TBD: Move this to MT::Session and store expiration date in
# the record
sub _expire_sessions {
    my ($timeout) = @_;

    require MT::Session;
    my @old_sessions = MT::Session->load(
        {
            start => [ 0, time() - $timeout ],
            kind  => 'SI'
        },
        { range => { start => 1 } }
    );
    foreach (@old_sessions) {
        $_->remove() || die "couldn't remove sessions because " . $_->errstr();
    }
}

# This actually handles a UI-level sign-in or sign-out request.
sub handle_sign_in {
    my $app = shift;
    my $q   = $app->param;

    my $result = 0;
    if ( $q->param('logout') ) {
        my ( $s, $commenter ) = $app->_get_commenter_session();
        #if ($commenter) {
        #    require MT::Auth;
        #    my $ctx = MT::Auth->fetch_credentials( { app => $app } );
        #    my $cmntr_sess =
        #      $app->session_user( $commenter, $ctx->{session_id},
        #        permanent => $ctx->{permanent} );
        #    if ($cmntr_sess) {
        #        $app->user($commenter);
        #        MT::Auth->invalidate_credentials( { app => $app } );
        #    }
        #}

        my %cookies = $app->cookies();
        $app->_invalidate_commenter_session( \%cookies );
        $result = 1;
    }
    else {
        my $authenticator = MT->commenter_authenticator( $q->param('key') );
        my $auth_class    = $authenticator->{class};
        eval "require $auth_class;";
        if ( my $e = $@ ) {
            return $app->handle_error( $e, 403 );
        }
        $result = $auth_class->handle_sign_in($app);
    }

    return $app->handle_error(
        $app->errstr() || $app->translate(
            "The sign-in attempt was not successful; please try again."),
        403
    ) unless $result;

    $app->redirect_to_target;
}

sub redirect_to_target {
    my $app = shift;
    my $q   = $app->param;

    my $cfg = $app->config;
    my $target;
    require MT::Util;
    if ( $q->param('static') ) {
        if ( $q->param('static') eq 1 ) {
            require MT::Entry;
            my $entry = MT::Entry->load( $q->param('entry_id') );
            $target = $entry->archive_url;
            my $blog = MT::Blog->load( $entry->blog_id );
            $target = MT::Util::strip_index( $target, $blog );
        }
        else {
            $target = $q->param('static');
        }
    }
    else {
        $target =
          (     $cfg->CGIPath
              . $cfg->CommentScript
              . "?entry_id="
              . $q->param('entry_id')
              . ( $q->param('arch') ? '&static=0&arch=1' : '' ) );
    }
    if ( $q->param('logout') ) {
        return $app->redirect(
            $cfg->SignOffURL . "&_return=" . MT::Util::encode_url($target),
            UseMeta => 1 );
    }
    else {
        return $app->redirect( $target, UseMeta => 1 );
    }
}

sub commenter_name_js {
    local $SIG{__WARN__} = sub { };
    my $app            = shift;
    my $commenter_name = $app->cookie_val('commenter_name');
    my $ids            = $app->cookie_val('commenter_id') || q();
    my $commenter_url  = $app->cookie_val('commenter_url') || q();

    my $commenter_id;
    if ($ids) {
        my @ids = split ':', $ids;
        $commenter_id    = $ids[0];
        my $blog_ids     = $ids[1];
    }

    # FIXME: how do we know this is coming in as utf-8?
    $commenter_name = encode_text( $commenter_name, 'utf-8' );

    $app->set_header( 'Cache-Control' => 'no-cache' );
    $app->set_header( 'Expires'       => '-1' );

    if ($commenter_id) {
        my @blogs;
        my $user = $app->model('author')->load($commenter_id);
        if ($user && $user->is_superuser) {
            @blogs = $app->model('blog')->load;
        }
        else {
            @blogs = $app->model('blog')->load(undef,
              {
                join => MT::Permission->join_on('blog_id',
                  {
                    permissions => "\%'comment'\%",
                    author_id   => $commenter_id
                  },
                  { 'like' => { 'permissions' => 1 } }
                )
              }
            );
        }
        my $blog_ids = "'" . join("','", map { $_->id } @blogs) . "'";
        $commenter_id .= ":$blog_ids";
    }
    return
"commenter_name = '$commenter_name';\ncommenter_id=\"$commenter_id\";\ncommenter_url='$commenter_url'\n";
}

sub view {
    my $app       = shift;
    my $q         = $app->param;
    my %param     = $app->param_hash();
    my %overrides = ref( $_[0] ) ? %{ $_[0] } : ();
    @param{ keys %overrides } = values %overrides;

    my $cmntr;
    my $session_key;

    if ( $q->param('logout') ) {
        return $app->handle_sign_in;
    }

    if ( $q->param('sig') ) {
        $cmntr = $app->handle_sign_in
          or return $app->handle_error(
            $app->translate(
"The sign-in validation was not successful. Please make sure your weblog is properly configured and try again."
            )
          );
    }
    else {
        ( $session_key, $cmntr ) = $app->_get_commenter_session();
    }

    require MT::Template;
    require MT::Template::Context;

    require MT::Entry;
    my $entry_id = $q->param('entry_id')
      or return $app->error( $app->translate("No entry_id") );
    my $entry = MT::Entry->load($entry_id)
      or return $app->error(
        $app->translate( "No such entry ID '[_1]'", $entry_id ) );
    return $app->error(
        $app->translate( "No such entry ID '[_1]'", $entry_id ) )
      if $entry->status != RELEASE;

    my $cfg = $app->config;
    require MT::Blog;
    my $blog = MT::Blog->load( $entry->blog_id );
    if ($cmntr) {
        if (   !$blog->manual_approve_commenters
            && ( $cmntr->type == MT::Author::COMMENTER() )
            && ( $cmntr->commenter_status( $entry->blog_id ) == MT::Author::PENDING() ) )
        {
            $cmntr->approve( $entry->blog_id );
        }
    }

    my $ctx = MT::Template::Context->new;
    $ctx->stash( 'entry', $entry );
    $ctx->stash( 'commenter', $cmntr ) if ($cmntr);
    $ctx->{current_timestamp} = $entry->authored_on;
    my %cond;
    my $tmpl = MT::Template->load(
            {
                type    => 'individual',
                blog_id => $entry->blog_id
            }
          );

    unless ($tmpl) {
        # Load default template and translate it
        require MT::DefaultTemplates;
        ($tmpl) = MT::DefaultTemplates->load( { type => 'individual' } );
        $tmpl->text( $app->translate_templatized( $tmpl->text ) );
    }

    my $html = $tmpl->build( $ctx, \%cond );
    $html = MT::Util::encode_html( $tmpl->errstr ) unless defined $html;
    $html;
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
        my $state = $comment->column_values;
        $state->{static} = $q->param('static');
        $ctx->stash( 'comment_state', unpack 'H*', $ser->serialize( \$state ) );
    }
    $ctx->stash( 'comment_is_static', $q->param('static') );
    $ctx->stash( 'entry',             $entry );
    $ctx->{current_timestamp} = $ts;
    $ctx->stash( 'commenter', $commenter );
    my ($tmpl);
    $err ||= '';
    if ($err) {
        $tmpl = MT::Template->load(
            {
                type    => 'comment_response',
                blog_id => $entry->blog_id
            }
          );
        unless ($tmpl) {
            require MT::DefaultTemplates;
            ($tmpl) = MT::DefaultTemplates->load({ type => 'comment_response' });
            $tmpl->text( $app->translate_templatized( $tmpl->text ) );
        }
        if ( $err eq 'pending' ) {
            $tmpl->param('body_class', 'mt-comment-pending');
        }
        else {
            $ctx->stash( 'error_message', $err );
            $tmpl->param('body_class', 'mt-comment-error');
        }
    }
    else {
        $tmpl = MT::Template->load(
            {
                type    => 'comment_preview',
                blog_id => $entry->blog_id
            }
          );
        unless ($tmpl) {
            require MT::DefaultTemplates;
            ($tmpl) = MT::DefaultTemplates->load({ type => 'comment_preview' });
            $tmpl->text( $app->translate_templatized( $tmpl->text ) );
        }
        $tmpl->param('body_class', 'mt-comment-preview');
    }
    my %cond;
    my $html = $tmpl->build( $ctx, \%cond );
    $html = $tmpl->errstr unless defined $html;
    $html;
}

sub edit_commenter_profile {
    my $app = shift;

    my $id = $app->param('commenter');
    return $app->handle_error( $app->translate('Invalid commenter ID') )
      unless $id =~ /\d+/;

    my $url;
    my $entry_id = $app->param('entry_id');
    if ($entry_id) {
        my $entry = MT::Entry->load($entry_id);
        return $app->handle_error( $app->translate("No entry ID provided") )
          unless $entry;
        $url = $entry->permalink;
    }
    else {
        $url = is_valid_url( $app->param('static') );
    }

    my ( $session, $commenter ) = $app->_get_commenter_session();
    if ($commenter) {
        #require MT::Auth;
        #my $ctx = MT::Auth->fetch_credentials( { app => $app } );
        #my $cmntr_sess =
        #  $app->session_user( $commenter, $ctx->{session_id},
        #    permanent => $ctx->{permanent} );
        #return $app->handle_error( $app->translate('Invalid login') )
        #  unless $cmntr_sess;

        my $blog_id = $app->param('blog_id');
        return $app->handle_error( $app->translate('Permission denied') )
          unless $commenter->blog_perm($blog_id)->can_comment;

        $app->user($commenter);
        my $param = {
            id       => $commenter->id,
            name     => $commenter->name,
            nickname => $commenter->nickname,
            email    => $commenter->email,
            hint     => $commenter->hint,
            url      => $commenter->url,
            $entry_id ? ( entry_url => $url ) : ( return_url => $url ),
        };
        $param->{ 'auth_mode_' . $app->config->AuthenticationModule } = 1;
        return $app->build_page( 'profile.tmpl', $param );
    }
    return $app->handle_error( $app->translate('Invalid login') );
}

sub save_commenter_profile {
    my $app = shift;
    my $q   = $app->param;

    my %param =
      map { $_ => scalar( $q->param($_) ) }
      qw( id name nickname email password pass_verify hint url entry_url return_url external_auth);
    $param{ 'auth_mode_' . $app->config->AuthenticationModule } = 1;

    unless ( $param{id} =~ /\d+/ ) {
        $param{error} = $app->translate('Invalid commenter ID');
        return $app->build_page( 'profile.tmpl', \%param );
    }

    my $cmntr = MT::Author->load( $param{id} );
    unless ($cmntr) {
        $param{error} = $app->translate('Invalid commenter ID');
        return $app->build_page( 'profile.tmpl', \%param );
    }

    #require MT::Auth;
    #my $ctx = MT::Auth->fetch_credentials( { app => $app } );
    #my $cmntr_sess =
    #  $app->session_user( $cmntr, $ctx->{session_id},
    #    permanent => $ctx->{permanent} );
    #return $app->handle_error( $app->translate('Invalid login') )
    #  unless $cmntr_sess;

    $app->user($cmntr);
    $app->validate_magic
      or return $app->handle_error( $app->translate('Invalid request') );

    unless ( $param{external_auth} ) {
        unless ( $param{nickname} && $param{email} && $param{hint} ) {
            $param{error} =
              $app->translate('All required fields must have valid values.');
            return $app->build_page( 'profile.tmpl', \%param );
        }
        if ( $param{password} ne $param{pass_verify} ) {
            $param{error} = $app->translate('Passwords do not match.');
            return $app->build_page( 'profile.tmpl', \%param );
        }
    }
    if ( $param{email} && !is_valid_email( $param{email} ) ) {
        $param{error} = $app->translate('Email Address is invalid.');
        return $app->build_page( 'profile.tmpl', \%param );
    }
    if ( $param{url} && !is_valid_url( $param{url} ) ) {
        $param{error} = $app->translate('URL is invalid.');
        return $app->build_page( 'profile.tmpl', \%param );
    }

    my $renew_session =
      $param{nickname} && ( $param{nickname} ne $cmntr->nickname ) ? 1 : 0;
    $cmntr->nickname( $param{nickname} ) if $param{nickname};
    $cmntr->email( $param{email} )       if $param{email};
    $cmntr->hint( $param{hint} )         if $param{hint};
    $cmntr->url( $param{url} )           if $param{url};
    $cmntr->set_password( $param{password} )
      if $param{password} && !$param{external_auth};
    if ( $cmntr->save ) {
        $param{saved} =
          $app->translate('Commenter profile has successfully been updated.');
    }
    else {
        $param{error} =
          $app->translate( 'Commenter profile could not be updated: [_1]',
            $cmntr->errstr );
    }
    if ($renew_session) {
        $app->_make_commenter_session( $app->make_magic_token, $cmntr->email,
            $cmntr->name,
            ($cmntr->nickname || 'User#' . $cmntr->id),
            $cmntr->id );
        #    $app->start_session( $cmntr, $ctx->{permanent} );
    }
    $param{ 'auth_mode_' . $app->config->AuthenticationModule } = 1;
    return $app->build_page( 'profile.tmpl', \%param );
}

sub _prepare_reply {
    my $app = shift;
    my $q   = $app->param;

    my $parent = MT::Comment->load( $q->param('reply_to') );
    my $entry  = MT::Entry->load( $parent->entry_id );
    unless ( $parent->is_published ) {
        $app->error(
            $app->translate("You can't reply to unpublished comment.") );
        return ( undef, undef, $parent, $entry );
    }

    my $blog = MT::Blog->load( $entry->blog_id );
    my ( $comment, $commenter ) = $app->_make_comment( $entry, $blog );
    unless ( $comment
        && $commenter
        && ( MT::Author::AUTHOR() == $commenter->type ) )
    {
        unless ($commenter) {
            $app->error(
                $app->translate(
"Your session has been ended.  Cancel the dialog and login again."
                )
            );
        }
        else {
            $app->error(
                $app->translate( "An error occurred: [_1]", $app->errstr() ) );
        }
        return ( undef, undef, $parent, $entry );
    }

    require MT::Auth;
    my $ctx = MT::Auth->fetch_credentials( { app => $app } );
    $commenter =
      $app->session_user( $commenter, $ctx->{session_id},
        permanent => $ctx->{permanent} );
    unless ($commenter) {
        $app->error(
            $app->translate(
"Your session has been ended.  Cancel the dialog and login again."
            )
        );
        return ( undef, undef, $parent, $entry );
    }

    $app->user($commenter);
    unless ( $app->validate_magic ) {
        $app->error( $app->translate("Invalid request.") );
        return ( undef, undef, $parent, $entry );
    }

    ( $comment, $commenter, $parent, $entry );
}

#TODO: this should be refactored for more general use
sub reply {
    my $app = shift;
    my $q   = $app->param;

    my $reply_to    = encode_html( $q->param('reply_to') );
    my $magic_token = encode_html( $q->param('magic_token') );
    my $blog_id     = encode_html( $q->param('blog_id') );
    my $return_url  = encode_html( $q->param('return_url') );
    my $text        = encode_html( $q->param('text') );
    my $indicator   = $app->static_path . 'images/indicator.gif';
    my $url         = $app->uri;
    <<SPINNER;
<html><head><style type="text/css">
#dialog-indicator {position: relative;top: 200px;
background: url($indicator)
no-repeat;width: 66px;height: 66px;margin: 0 auto;
}</style><script type="text/javascript">
function init() { var f = document.getElementById('f'); f.submit(); }
window.setTimeout("init()", 1500);
</script></head><body>
<div align="center"><div id="dialog-indicator"></div>
<form id="f" method="post" action="$url">
<input type="hidden" name="__mode" value="do_reply" />
<input type="hidden" name="reply_to" value="$reply_to" />
<input type="hidden" name="magic_token" value="$magic_token" />
<input type="hidden" name="blog_id" value="$blog_id" />
<input type="hidden" name="return_url" value="$return_url" />
<input type="hidden" name="text" value="$text" />
</form></div></body></html>
SPINNER
}

sub do_reply {
    my $app = shift;
    my $q   = $app->param;

    my $param = {
        reply_to    => $q->param('reply_to'),
        magic_token => $q->param('magic_token'),
        blog_id     => $q->param('blog_id'),
    };

    my ( $comment, $commenter, $parent, $entry ) = $app->_prepare_reply;

    $param->{commenter_name} = $parent->author;
    $param->{entry_title}    = $entry->title;
    $param->{comment_created_on} =
      format_ts( "%Y-%m-%d %H:%M:%S", $parent->created_on );
    $param->{comment_text} = $parent->text;
    $param->{comment_script_url} =
      $app->config('CGIPath') . $app->config('CommentScript');

    $app->{template_dir} = 'cms';
    return $app->build_page( 'dialog/comment_reply.tmpl',
        { %$param, error => $app->errstr } )
      unless $comment;

    $comment->parent_id( $param->{reply_to} );
    $comment->approve;
    return $app->handle_error(
        $app->translate( "An error occurred: [_1]", $comment->errstr() ) )
      unless $comment->save;

    MT::Util::start_background_task(
        sub {
            $app->rebuild_entry( Entry => $parent->entry_id )
              or return $app->errtrans( "Publish failed: [_1]", $app->errstr );
            $app->rebuild_indexes( Blog => $parent->blog )
              or return $app->errtrans( "Publish failed: [_1]", $app->errstr );
            $app->_send_comment_notification( $comment, q(), $entry,
                MT::Blog->load( $param->{blog_id} ), $commenter );
        }
    );
    return $app->build_page( 'dialog/comment_reply.tmpl',
        { closing => 1, return_url => $q->param('return_url') } );
}

sub reply_preview {
    my $app = shift;
    my $q   = $app->param;
    my $cfg = $app->config;

    my $param = {
        reply_to    => $q->param('reply_to'),
        magic_token => $q->param('magic_token'),
        blog_id     => $q->param('blog_id'),
    };
    my ( $comment, $commenter, $parent, $entry ) = $app->_prepare_reply;

    $param->{commenter_name} = $parent->author;
    $param->{entry_title}    = $entry->title;
    $param->{comment_created_on} =
      format_ts( "%Y-%m-%d %H:%M:%S", $parent->created_on );
    $param->{comment_text} = $parent->text;
    $param->{comment_script_url} =
      $app->config('CGIPath') . $app->config('CommentScript');

    $app->{template_dir} = 'cms';
    return $app->build_page( 'dialog/comment_reply.tmpl',
        { %$param, error => $app->errstr } )
      unless $comment;

    my $cmt_tmpl = $app->model('template')->load(
      { identifier => 'comment_detail' });
    my $tmpl_name = $cmt_tmpl->name;
    require MT::Template;
    my $tmpl = MT::Template->new(
        type   => 'scalarref',
        source => \"<\$MTInclude module=\"$tmpl_name\"\$>",
    );
    my $ctx = MT::Template::Context->new;
    ## Set timestamp as we would usually do in ObjectDriver.
    my @ts = MT::Util::offset_time_list( time, $entry->blog_id );
    my $ts = sprintf "%04d%02d%02d%02d%02d%02d", $ts[5] + 1900, $ts[4] + 1,
      @ts[ 3, 2, 1, 0 ];
    $comment->created_on($ts);
    $comment->commenter_id( $commenter->id ) if $commenter;
    $ctx->stash( 'comment', $comment );

    require MT::Serialize;
    my $ser   = MT::Serialize->new( $cfg->Serializer );
    my $state = $comment->column_values;
    $state->{static} = $q->param('static');
    $ctx->stash( 'comment_state', unpack 'H*', $ser->serialize( \$state ) );
    $ctx->stash( 'comment_is_static', 1 );
    $ctx->stash( 'entry',             $entry );
    $ctx->{current_timestamp} = $ts;
    $ctx->stash( 'commenter', $commenter );
    $ctx->stash( 'blog_id',   $parent->blog_id );
    $ctx->stash( 'blog',      $parent->blog );
    my %cond;
    my $html = $tmpl->build( $ctx, \%cond );
    return $app->build_page( 'dialog/comment_reply.tmpl',
        { %$param, error => $tmpl->errstr } )
      unless defined $html;

    return $app->build_page( 'dialog/comment_reply.tmpl',
        { %$param, text => $q->param('text'), preview_html => $html } );
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
    return $app->{_blog};
}

sub _get_options_tmpl {
    my $self = shift;
    my ($authenticator) = @_;

    my $tmpl = $authenticator->{login_form};
    return q() unless $tmpl;
    return $tmpl->($authenticator) if ref $tmpl eq 'CODE';
    if ( $tmpl =~ /\s/ ) {
        return $tmpl;
    }
    else {    # no spaces in $tmpl; must be a filename...
        if ( my $plugin = $authenticator->{plugin} ) {
            return $plugin->load_tmpl($tmpl) or die $plugin->errstr;
        }
        else {
            return MT->instance->load_tmpl($tmpl);
        }
    }
}

sub _get_options_html {
    my $app           = shift;
    my ($key)         = @_;
    my $authenticator = MT->commenter_authenticator($key);
    return q() unless $authenticator;

    my $snip_tmpl = $app->_get_options_tmpl($authenticator);
    return q() unless $snip_tmpl;

    require MT::Template;
    my $tmpl;
    if ( ref $snip_tmpl ne 'MT::Template' ) {
        $tmpl = MT::Template->new(
            type   => 'scalarref',
            source => ref $snip_tmpl ? $snip_tmpl : \$snip_tmpl
        );
    }
    else {
        $tmpl = $snip_tmpl;
    }

    $app->set_default_tmpl_params($tmpl);
    if ( my $p = $authenticator->{login_form_params} ) {
        my $params = $p->(
            $key,
            $app->param('blog_id'),
            $app->param('entry_id') || undef,
            $app->param('static')
        );
        $tmpl->param($params) if $params;
    }
    my $html = $tmpl->output();
    if ( UNIVERSAL::isa( $authenticator, 'MT::Plugin' )
        && ( $html =~ m/<__trans / ) )
    {
        $html = $authenticator->translate_templatized($html);
    }
    $html;
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

=head2 $app->view

Mode for displaying a dynamic view of comments for a particular entry.

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

=head1 SPAM PROTECTION

Spam filtering (or "Junk" filtering in MT terminology) is handled using
the L<MT::JunkFilter> package and plugins that implement them. Please
refer to that module for further documentation.

=head1 AUTHOR & COPYRIGHT

Please see the I<MT> manpage for author, copyright, and license information.

=back
