# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$
package MT::CMS::Tools;

use strict;
use warnings;
use Symbol;

use MT::I18N qw( wrap_text );
use MT::Util
    qw( encode_url encode_html decode_html encode_js trim dir_separator is_valid_email );

sub system_check {
    my $app = shift;

    if ( my $blog_id = $app->param('blog_id') ) {
        return $app->return_to_dashboard( redirect => 1 );
    }
    if ( !$app->can_do('open_system_check_screen') ) {
        return $app->permission_denied();
    }

    my %param;

    my $author_class = $app->model('author');
    $param{user_count}
        = $author_class->count( { type => MT::Author::AUTHOR() } );

    $param{commenter_count} = 0;
    $param{screen_id}       = "system-check";

    require MT::Memcached;
    if ( MT::Memcached->is_available ) {
        $param{memcached_enabled} = 1;
        my $inst = MT::Memcached->instance;
        my $key  = 'syscheck-' . $$;
        $inst->add( $key, $$ );
        if ( $inst->get($key) == $$ ) {
            $inst->delete($key);
            $param{memcached_active} = 1;
        }
    }

    $param{server_modperl} = 1 if MT::Util::is_mod_perl1();
    $param{server_fastcgi} = 1 if $ENV{FAST_CGI};

    $param{server_psgi} = $ENV{'psgi.version'} ? 1 : 0;
    $param{syscheck_html} = get_syscheck_content($app) || '';

    $app->add_breadcrumb( $app->translate('System Information') );

    $app->load_tmpl( 'system_check.tmpl', \%param );
}

sub get_syscheck_content {
    my $app     = shift;
    my $sess_id = $app->session->id;
    my $syscheck_url
        = $app->base
        . $app->mt_path
        . $app->config('CheckScript')
        . '?view=tools&version='
        . MT->version_id
        . '&session_id='
        . $sess_id
        . '&language='
        . MT->current_language;

    my $ua = $app->new_ua();
    return unless $ua;
    $ua->max_size(undef) if $ua->can('max_size');

    # Do not verify SSL certificate.
    $ua->ssl_opts( verify_hostname => 0 );

    my $req = new HTTP::Request( GET => $syscheck_url );
    my $resp = $ua->request($req);
    return unless $resp->is_success();
    my $result = $resp->content();
    if ($result) {
        require MT::Sanitize;

        # allowed html
        my $spec
            = '* style class id,ul,li,div,span,br,h2,h3,strong,code,blockquote,p,textarea';
        $result = Encode::decode_utf8($result)
            if !Encode::is_utf8($result)
            ;    # mt-check.cgi always returns by utf-8

        $result = MT::Sanitize->sanitize( $result, $spec );
    }
    return $result;
}

sub start_recover {
    my $app     = shift;
    my ($param) = @_;
    my $cfg     = $app->config;
    $param ||= {};
    $param->{'email'} = $app->param('email');
    $param->{'return_to'}
        = $app->param('return_to')
        || $cfg->ReturnToURL
        || '';

    if ( $param->{return_to} ) {
        $app->is_valid_redirect_target( $param->{return_to} )
            or return $app->errtrans("Invalid request.");
    }

    if ( $param->{recovered} ) {
        $param->{return_to} = MT::Util::encode_js( $param->{return_to} );
    }
    $param->{'can_signin'} = ( ref $app eq 'MT::App::CMS' ) ? 1 : 0;

    $app->add_breadcrumb( $app->translate('Password Recovery') );

    my $blog_id = $app->param('blog_id');
    $param->{'blog_id'} = $blog_id;
    my $tmpl = $app->load_global_tmpl(
        { identifier => 'new_password_reset_form', }, $blog_id );
    if ( !$tmpl || !_exists_system_tmpl($tmpl) ) {
        $tmpl = $app->load_tmpl('cms/dialog/recover.tmpl');
    }
    $param->{system_template} = 1;
    $tmpl->param($param);
    return $tmpl;
}

sub recover_password {
    my $app      = shift;
    my $email    = $app->param('email') || '';
    my $username = $app->param('name');

    $email = trim($email);
    $username = trim($username) if $username;

    if ( !$email ) {
        return $app->start_recover(
            {   error => $app->translate(
                    'Email address is required for password reset.'),
            }
        );
    }
    if ( !is_valid_email($email) ) {
        return $app->start_recover(
            { error => $app->translate('Invalid email address') } );
    }

    my $return_to = $app->param('return_to');
    if ($return_to) {
        $app->is_valid_redirect_target($return_to)
            or return $app->errtrans("Invalid request.");
    }

    # Searching user by email (and username)
    my $class
        = ref $app eq 'MT::App::Upgrader'
        ? 'MT::BasicAuthor'
        : $app->model('author');
    eval "use $class;";

    my @all_authors = $class->load(
        { email => $email, ( $username ? ( name => $username ) : () ) } );
    my @authors;
    my $user;
    foreach (@all_authors) {
        next unless $_->password && ( $_->password ne '(none)' );
        push( @authors, $_ );
    }
    if ( !@authors ) {
        return $app->start_recover( { recovered => 1, } );
    }
    elsif ( @authors > 1 ) {
        return $app->start_recover( { not_unique_email => 1, } );
    }
    $user = pop @authors;

    MT::Util::start_background_task(
        sub {

            # Generate Token
            require MT::Util::Captcha;
            my $salt    = MT::Util::Captcha->_generate_code(8);
            my $expires = time + ( 60 * 60 );
            my $token   = MT::Util::perl_sha1_digest_hex(
                $salt . $expires . $app->config->SecretToken );

            my $return_to = $app->param('return_to');

            $user->password_reset($salt);
            $user->password_reset_expires($expires);
            $user->password_reset_return_to($return_to) if $return_to;
            $user->save;

            # Send mail to user
            my %head = (
                id      => 'recover_password',
                To      => $email,
                From    => $app->config('EmailAddressMain') || '',
                Subject => $app->translate("Password Recovery")
            );
            my $charset = $app->charset;
            my $mail_enc = uc( $app->config('MailEncoding') || $charset );
            $head{'Content-Type'} = qq(text/plain; charset="$mail_enc");

            my $blog_id = $app->param('blog_id');
            my $body    = $app->build_email(
                'recover-password',
                {         link_to_login => $app->base
                        . $app->uri
                        . "?__mode=new_pw&token=$token&email="
                        . encode_url($email)
                        . ( $blog_id ? "&blog_id=$blog_id" : '' ),
                }
            );

            require MT::Util::Mail;
            MT::Util::Mail->send_and_log(\%head, $body) or die $app->translate(
                "Error sending e-mail ([_1]); Please fix the problem, then try again to recover your password.",
                MT::Util::Mail->errstr
            );
        }
    );

    return $app->start_recover( { recovered => 1, } );
}

sub new_password {
    my $app = shift;
    my ($param) = @_;
    $param ||= {};

    my $token = $app->param('token');
    if ( !$token ) {
        return $app->start_recover(
            { error => $app->translate('Password reset token not found'), } );
    }

    my $email = $app->param('email');
    if ( !$email ) {
        return $app->start_recover(
            { error => $app->translate('Email address not found'), } );
    }

    my $class = $app->model('author');
    my @users = $class->load( { email => $email } );
    if ( !@users ) {
        return $app->start_recover(
            { error => $app->translate('User not found'), } );
    }

    # comparing token
    require MT::Util::Captcha;
    my $user;
    for my $u (@users) {
        my $salt    = $u->password_reset;
        my $expires = $u->password_reset_expires;
        next unless $salt and $expires;
        my $compare = MT::Util::perl_sha1_digest_hex(
            $salt . $expires . $app->config->SecretToken );
        if ( $compare eq $token ) {
            if ( time > $u->password_reset_expires ) {
                return $app->start_recover(
                    {   error => $app->translate(
                            'Your request to change your password has expired.'
                        ),
                    }
                );
            }
            $user = $u;
            last;
        }
    }

    if ( !$user ) {
        return $app->start_recover(
            { error => $app->translate('Invalid password reset request'), } );
    }

    # Password reset
    my $new_password = $app->param('password');
    if ($new_password) {
        my $again = $app->param('password_again');
        if ( !$again ) {
            $param->{'error'}
                = $app->translate('Please confirm your new password');
        }
        elsif ( $new_password ne $again ) {
            $param->{'error'} = $app->translate('Passwords do not match');
        }
        else {
            $param->{'error'} = eval {
                $app->verify_password_strength( $user->name, $new_password );
            };
        }

        if ( not $param->{'error'} ) {
            my $redirect = $user->password_reset_return_to || '';

            $user->set_password($new_password);
            $user->password_reset(undef);
            $user->password_reset_expires(undef);
            $user->password_reset_return_to(undef);
            $user->modified_by($user->id);
            $user->save;
            $app->param( 'username', $user->name )
                if $user->type == MT::Author::AUTHOR();

            $app->log({
                message  => $app->translate(q{The password for the user '[_1]' has been recovered.}, $user->name),
                level    => MT::Log::NOTICE(),
                class    => 'system',
                category => 'password-recovery',
            });

            if ( ref $app eq 'MT::App::CMS' && !$redirect ) {
                $app->login;
                return $app->return_to_dashboard( redirect => 1 );
            }
            else {
                if ( !$redirect ) {
                    my $cfg = $app->config;
                    $redirect = $cfg->ReturnToURL || '';
                }
                $app->make_commenter_session($user);
                if ($redirect) {
                    ## just in case
                    $app->is_valid_redirect_target($redirect)
                        or return $app->errtrans("Invalid request.");
                    return $app->redirect( MT::Util::encode_html($redirect) );
                }
                else {
                    return $app->redirect_to_edit_profile();
                }
            }
        }
    }

    $param->{'email'}          = $email;
    $param->{'token'}          = $token;
    $param->{'password'}       = $app->param('password');
    $param->{'password_again'} = $app->param('password_again');
    $param->{'username'}       = $user->name();
    $app->add_breadcrumb( $app->translate('Password Recovery') );

    my $blog_id = $app->param('blog_id');
    $param->{'blog_id'} = $blog_id if $blog_id;
    my $tmpl = $app->load_global_tmpl( { identifier => 'new_password', },
        $blog_id );
    if ( !$tmpl || !_exists_system_tmpl($tmpl) ) {
        $tmpl = $app->load_tmpl('cms/dialog/new_password.tmpl');
    }
    $param->{system_template} = 1;
    $tmpl->param($param);
    return $tmpl;
}

sub do_list_action {
    my $app = shift;

    #$app->validate_magic or return;
    # plugin_action_selector should always (?) be in the query; use it?
    my $action_name = $app->param('action_name');
    my $type        = $app->param('_type');
    my $subtype
        = ( $type eq 'content_data' && $app->param('type') )
        ? '.' . $app->param('type')
        : '';
    my ($the_action)
        = ( grep { $_->{key} eq $action_name }
            @{ $app->list_actions( $type . $subtype ) } );
    return $app->errtrans(
        "That action ([_1]) is apparently not implemented!", $action_name )
        unless $the_action;

    unless ( ref( $the_action->{code} ) ) {
        if ( my $plugin = $the_action->{plugin} ) {
            $the_action->{code}
                = $app->handler_to_coderef( $the_action->{handler}
                    || $the_action->{code} );
        }
    }

    if ( $app->param('all_selected') ) {
        $app->setup_filtered_ids;
    }
    else {
        my @ids = $app->multi_param('id');
        if ( scalar @ids == 1 && $ids[0] =~ /,/ ) {
            $app->multi_param( 'id', split ',', $ids[0] );
        }
    }
    if ( $app->param('xhr') ) {
        my $res = $the_action->{code}->($app);
        if ( !defined $res && !$app->errstr ) {
            return $app->json_error(
                MT->translate(
                    q{Error occurred while attempting to [_1]: [_2]},
                    $the_action->label, $app->errstr
                )
            );
        }
        elsif ( !defined $res ) {
            return;
        }
        return $app->forward( 'filtered_list',
            ( 'HASH' eq ref $res ? %$res : () ) );
    }
    $the_action->{code}->($app);
}

sub do_page_action {
    my $app = shift;

    # plugin_action_selector should always (?) be in the query; use it?
    my $action_name = $app->param('action_name');
    my $type        = $app->param('_type');
    my ($the_action)
        = ( grep { $_->{key} eq $action_name }
            @{ $app->page_actions($type) } );
    return $app->errtrans(
        "That action ([_1]) is apparently not implemented!", $action_name )
        unless $the_action;

    unless ( ref( $the_action->{code} ) ) {
        if ( my $plugin = $the_action->{plugin} ) {
            $the_action->{code}
                = $app->handler_to_coderef( $the_action->{handler}
                    || $the_action->{code} );
        }
    }
    $the_action->{code}->($app);
}

sub test_system_mail {
    my $app = shift;
    my %param;
    if ( $app->param('blog_id') ) {
        return $app->return_to_dashboard( redirect => 1 );
    }

    return $app->permission_denied()
        unless $app->user->is_superuser();

    my $to_email_address = $app->param('to_email_address');
    return $app->json_error(
        $app->translate('Please enter a valid email address.') )
        unless ( MT::Util::is_valid_email($to_email_address) );

    my $cfg = $app->config;
    return $app->json_error(
        $app->translate(
            "You do not have a system email address configured.  Please set this first, save it, then try the test email again."
        )
    ) unless ( $cfg->EmailAddressMain );

    my %head = (
        To      => $to_email_address,
        From    => $cfg->EmailAddressMain,
        Subject => $app->translate("Test email from Movable Type")
    );

    my $body
        = $app->translate("This is the test email sent by Movable Type.");

    require MT::Util::Mail;
    if ( MT::Util::Mail->send_and_log( \%head, $body ) ) {
        return $app->json_result( { success => 1 } );
    }
    else {
        return $app->json_error(
            $app->translate(
                "E-mail was not properly sent. [_1]",
                MT::Util::Mail->errstr
            )
        );
    }
}

sub cfg_system_general {
    my $app = shift;
    my %param;
    if ( $app->param('blog_id') ) {
        return $app->return_to_dashboard( redirect => 1 );
    }

    return $app->permission_denied()
        unless $app->user->is_superuser();
    my $cfg = $app->config;
    $app->add_breadcrumb( $app->translate('General Settings') );
    $param{nav_config}   = 1;
    $param{nav_settings} = 1;
    $param{languages}    = MT::I18N::languages_list( $app,
        $app->config('DefaultUserLanguage') );
    my $tag_delim = $app->config('DefaultUserTagDelimiter') || 'comma';
    $param{"tag_delim_$tag_delim"} = 1;

    ( my $tz = $app->config('DefaultTimezone') ) =~ s![-\.]!_!g;
    $tz =~ s!_00$!!;
    $param{ 'server_offset_' . $tz } = 1;

    my @readonly_configs = qw( EmailAddressMain DebugMode PerformanceLogging
        PerformanceLoggingPath PerformanceLoggingThreshold
        UserLockoutLimit UserLockoutInterval IPLockoutLimit
        IPLockoutInterval LockoutIPWhitelist LockoutNotifyTo
        TrackRevisions DisableNotificationPings OutboundTrackbackLimit
        OutboundTrackbackDomains AllowPings AllowComments
        AutoChangeImageQuality ImageQualityJpeg ImageQualityPng);
    push @readonly_configs, 'BaseSitePath' unless $cfg->HideBaseSitePath;

    my @config_warnings;
    for my $config_directive (@readonly_configs) {
        if ( $app->config->is_readonly($config_directive) ) {
            push( @config_warnings, $config_directive );
            my $flag = "config_warnings_" . ( lc $config_directive );
            $param{$flag} = 1;
        }
    }

    if (@config_warnings) {
        my $config_warning = join( ", ", @config_warnings );

        $param{config_warning} = $app->translate(
            "These setting(s) are overridden by a value in the Movable Type configuration file: [_1]. Remove the value from the configuration file in order to control the value on this page.",
            $config_warning
        );
    }
    $param{system_email_address}            = $cfg->EmailAddressMain;
    $param{system_debug_mode}               = $cfg->DebugMode;
    $param{system_performance_logging}      = $cfg->PerformanceLogging;
    $param{system_performance_logging_path} = $cfg->PerformanceLoggingPath;
    $param{system_performance_logging_threshold}
        = $cfg->PerformanceLoggingThreshold;
    $param{track_revisions}        = $cfg->TrackRevisions;
    $param{saved}                  = $app->param('saved');
    $param{error}                  = $app->param('error');
    $param{warning_sitepath_limit} = $app->param('warning_sitepath_limit');
    $param{screen_class} = "settings-screen system-general-settings";

    # for feedback settings
    $param{comment_disable}      = $cfg->AllowComments            ? 0 : 1;
    $param{ping_disable}         = $cfg->AllowPings               ? 0 : 1;
    $param{disabled_notify_ping} = $cfg->DisableNotificationPings ? 1 : 0;
    my $send = $cfg->OutboundTrackbackLimit || 'any';

    if ( $send =~ m/^(any|off|selected|local)$/ ) {
        $param{ "trackback_send_" . $send } = 1;
        if ( $send eq 'selected' ) {
            my @domains = $cfg->OutboundTrackbackDomains;
            my $domains = join "\n", @domains;
            $param{trackback_send_domains} = $domains;
        }
    }
    else {
        $param{"trackback_send_any"} = 1;
    }

    # for lockout settings
    if ( my $notify_to = $cfg->LockoutNotifyTo ) {
        my @ids = split ';', $notify_to;
        my @sysadmins = MT::Author->load(
            {   id   => \@ids,
                type => MT::Author::AUTHOR()
            },
            {   join => MT::Permission->join_on(
                    'author_id',
                    {   permissions => "\%'administer'\%",
                        blog_id     => '0',
                    },
                    { 'like' => { 'permissions' => 1 } }
                )
            }
        );
        my @names;
        foreach my $a (@sysadmins) {
            push @names, $a->name . '(' . $a->id . ')';
        }
        $param{lockout_notify_ids} = $notify_to;
        $param{lockout_notify_names} = join ',', @names;
    }

    $param{user_lockout_limit}    = $cfg->UserLockoutLimit;
    $param{user_lockout_interval} = $cfg->UserLockoutInterval;
    $param{ip_lockout_limit}      = $cfg->IPLockoutLimit;
    $param{ip_lockout_interval}   = $cfg->IPLockoutInterval;
    $param{failed_login_expiration_frequency}
        = $cfg->FailedLoginExpirationFrequency;
    ( $param{lockout_ip_address_whitelist} = $cfg->LockoutIPWhitelist || '' )
        =~ s/,/\n/g;
    $param{sitepath_limit}        = $cfg->BaseSitePath;
    $param{sitepath_limit_hidden} = $cfg->HideBaseSitePath;
    $param{preflogging_hidden}    = $cfg->HidePerformanceLoggingSettings;

    # Image settings
    $param{auto_change_image_quality} = $cfg->AutoChangeImageQuality;
    $param{image_quality_jpeg}        = $cfg->ImageQualityJpeg;
    $param{image_quality_png}         = $cfg->ImageQualityPng;
    $param{image_driver}              = lc $cfg->ImageDriver;

    $param{saved}        = $app->param('saved');
    $param{screen_class} = "settings-screen system-feedback-settings";
    $app->load_tmpl( 'cfg_system_general.tmpl', \%param );
}

sub save_cfg_system_general {
    my $app = shift;
    $app->validate_magic or return;
    return $app->permission_denied()
        unless $app->user->is_superuser();
    my $cfg = $app->config;
    $app->config( 'TrackRevisions', $app->param('track_revisions') ? 1 : 0,
        1 );
    my $args = {};

    # construct the message to the activity log
    my @meta_messages        = ();
    my $system_email_address = $app->param('system_email_address');
    push( @meta_messages,
        $app->translate( 'Email address is [_1]', $system_email_address ) )
        if ( defined $system_email_address
        && $system_email_address ne $cfg->EmailAddressMain );

    my $system_debug_mode = $app->param('system_debug_mode');
    push( @meta_messages,
        $app->translate( 'Debug mode is [_1]', $system_debug_mode ) )
        if ( defined $system_debug_mode
        and $system_debug_mode =~ /\d+/ );

    my $system_performance_logging
        = $app->param('system_performance_logging');
    my $system_performance_logging_path
        = $app->param('system_performance_logging_path');
    my $system_performance_logging_threshold
        = $app->param('system_performance_logging_threshold');
    if ( not $cfg->HidePerformanceLoggingSettings ) {
        if ($system_performance_logging) {
            push( @meta_messages,
                $app->translate('Performance logging is on') );
        }
        else {
            push( @meta_messages,
                $app->translate('Performance logging is off') );
        }
        push(
            @meta_messages,
            $app->translate(
                'Performance log path is [_1]',
                $system_performance_logging_path
            )
            )
            if ( defined $system_performance_logging_path
            and $system_performance_logging_path =~ /\w+/ );
        push(
            @meta_messages,
            $app->translate(
                'Performance log threshold is [_1]',
                $system_performance_logging_threshold
            )
            )
            if ( defined $system_performance_logging_threshold
            and $system_performance_logging_threshold =~ /\d+/ );
    }

    # actually assign the changes
    $app->config( 'EmailAddressMain', $system_email_address, 1 );
    $app->config( 'DebugMode',        $system_debug_mode,    1 )
        if ( defined $system_debug_mode
        and $system_debug_mode =~ /\d+/ );
    if ( not $cfg->HidePerformanceLoggingSettings ) {
        if ($system_performance_logging) {
            $app->config( 'PerformanceLogging', 1, 1 );
        }
        else {
            $app->config( 'PerformanceLogging', 0, 1 );
        }
        $app->config( 'PerformanceLoggingPath',
            $system_performance_logging_path, 1 )
            if ( defined $system_performance_logging_path
            and $system_performance_logging_path =~ /\w+/ );
        $app->config( 'PerformanceLoggingThreshold',
            $system_performance_logging_threshold, 1 )
            if ( defined $system_performance_logging_threshold
            and $system_performance_logging_threshold =~ /\d+/ );
    }

    my $sitepath_limit = $app->param('sitepath_limit');
    if ( not $cfg->HideBaseSitePath ) {
        if ( not $sitepath_limit ) {
            $app->config( 'BaseSitePath', undef, 1 );
        }
        elsif ( File::Spec->file_name_is_absolute($sitepath_limit)
            && -d $sitepath_limit )
        {
            my $count = 0;
            foreach my $model_name (qw( website blog )) {
                my $class = MT->model($model_name);
                my $iter  = $class->load_iter();
                while ( my $site = $iter->() ) {
                    my $path = $site->column('site_path');
                    if ((      $model_name eq 'website'
                            || $class->is_site_path_absolute($path)
                        )
                        && $path !~ m!^$sitepath_limit/.*!
                        )
                    {
                        $count++;
                    }
                }
            }
            $args->{warning_sitepath_limit} = 1 if $count;

            $app->config( 'BaseSitePath', $sitepath_limit, 1 );
        }
        else {
            return $app->errtrans(
                "Invalid SitePath.  The SitePath should be valid and absolute, not relative"
            );
        }
    }

    # construct the message to the activity log

    my $comment_disable = $app->param('comment_disable');
    if ($comment_disable) {
        push( @meta_messages, $app->translate('Prohibit comments is on') );
    }
    else {
        push( @meta_messages, $app->translate('Prohibit comments is off') );
    }

    my $ping_disable = $app->param('ping_disable');
    if ($ping_disable) {
        push( @meta_messages, $app->translate('Prohibit trackbacks is on') );
    }
    else {
        push( @meta_messages, $app->translate('Prohibit trackbacks is off') );
    }

    my $disable_notify_ping = $app->param('disable_notify_ping');
    if ($disable_notify_ping) {
        push( @meta_messages,
            $app->translate('Prohibit notification pings is on') );
    }
    else {
        push( @meta_messages,
            $app->translate('Prohibit notification pings is off') );
    }
    my $trackback_send = $app->param('trackback_send') || '';
    if ( $trackback_send eq 'any' ) {
        push(
            @meta_messages,
            $app->translate(
                'Outbound trackback limit is [_1]',
                $app->translate('Any site')
            )
        );
    }
    elsif ( $trackback_send eq 'off' ) {
        push(
            @meta_messages,
            $app->translate(
                'Outbound trackback limit is [_1]',
                $app->translate('Disabled')
            )
        );
    }
    elsif ( $trackback_send eq 'local' ) {
        push(
            @meta_messages,
            $app->translate(
                'Outbound trackback limit is [_1]',
                $app->translate('Only to blogs within this system')
            )
        );
    }
    elsif ( $trackback_send eq 'selected' ) {
        push(
            @meta_messages,
            $app->translate(
                'Outbound trackback limit is [_1]',
                $app->translate(
                    'Only to websites on the following domains:'
                        . $app->param(
                        'config_warnings_outboundtrackbackdomains')
                )
            )
        );
    }

    # for lockout settings
    foreach my $hash (
        {   key    => 'lockout_notify_ids',
            cfg    => 'LockoutNotifyTo',
            label  => 'Recipients for lockout notification',
            regex  => qr/\A([\d,;]*)\z/,
            filter => sub { $_[0] =~ s/,/;/g },
        },
        {   key   => 'user_lockout_limit',
            cfg   => 'UserLockoutLimit',
            label => 'User lockout limit',
            regex => qr/\A\s*(\d+)\s*\z/,
        },
        {   key   => 'user_lockout_interval',
            cfg   => 'UserLockoutInterval',
            label => 'User lockout interval',
            regex => qr/\A\s*(\d+)\s*\z/,
        },
        {   key   => 'ip_lockout_limit',
            cfg   => 'IPLockoutLimit',
            label => 'IP address lockout limit',
            regex => qr/\A\s*(\d+)\s*\z/,
        },
        {   key   => 'ip_lockout_interval',
            cfg   => 'IPLockoutInterval',
            label => 'IP address lockout interval',
            regex => qr/\A\s*(\d+)\s*\z/,
        },
        {   key    => 'lockout_ip_address_whitelist',
            cfg    => 'LockoutIPWhitelist',
            label  => 'Lockout IP address whitelist',
            regex  => qr/\A\s*((.|\r|\n)*?)\s*\z/,
            filter => sub {
                $_[0] =~ s/\r|\n/,/g;
                $_[0] =~ s/,+/,/g;
            },
        },
        )
    {
        my $param = $app->param( $hash->{key} );
        $param = '' unless defined $param;
        if ( $param =~ $hash->{regex} ) {
            my $value = $1;
            if ( $hash->{filter} ) {
                $hash->{filter}->($value);
            }
            $cfg->set( $hash->{cfg}, $value, 1 );
            push(
                @meta_messages,
                $app->translate(
                    '[_1] is [_2]',
                    $app->translate( $hash->{label} ),
                    $value || $app->translate('none')
                )
            );
        }
    }

    # image quality settings
    my $auto_quality_change = $app->param('auto_change_image_quality');
    if ($auto_quality_change) {
        push( @meta_messages,
            $app->translate( 'Changing image quality is [_1]', 1 ) );
        $cfg->AutoChangeImageQuality( 1, 1 );
    }
    else {
        push( @meta_messages,
            $app->translate( 'Changing image quality is [_1]', 0 ) );
        $cfg->AutoChangeImageQuality( 0, 1 );
    }

    my $image_quality_jpeg = $app->param('image_quality_jpeg');
    if ( defined $image_quality_jpeg && $image_quality_jpeg =~ /^\d{1,3}$/ ) {
        push(
            @meta_messages,
            $app->translate(
                'Image quality(JPEG) is [_1]',
                $image_quality_jpeg
            )
        );
        $cfg->ImageQualityJpeg( $image_quality_jpeg, 1 );
    }

    my $image_quality_png = $app->param('image_quality_png');
    if ( defined $image_quality_png && $image_quality_png =~ /^\d$/ ) {
        push(
            @meta_messages,
            $app->translate(
                'Image quality(PNG) is [_1]',
                $image_quality_png
            ),
        );
        $cfg->ImageQualityPng( $image_quality_png, 1 );
    }

    # throw the messages in the activity log
    if ( scalar(@meta_messages) > 0 ) {
        my $message = join( ', ', @meta_messages );
        $app->log(
            {   message =>
                    $app->translate('System Settings Changes Took Place'),
                level    => MT::Log::NOTICE(),
                class    => 'system',
                metadata => $message,
                category => 'edit',
            }
        );
    }

    # for feedback settings
    $cfg->AllowComments( ( $comment_disable ? 0 : 1 ), 1 );
    $cfg->AllowPings( ( $ping_disable ? 0 : 1 ), 1 );
    $cfg->DisableNotificationPings( ( $disable_notify_ping ? 1 : 0 ), 1 );
    $trackback_send ||= 'any';
    if ( $trackback_send =~ m/^(any|off|selected|local)$/ ) {
        $cfg->OutboundTrackbackLimit( $trackback_send, 1 );
        if ( $trackback_send eq 'selected' ) {
            my $domains = $app->param('trackback_send_domains') || '';
            $domains =~ s/[\r\n]+/ /gs;
            $domains =~ s/\s{2,}/ /gs;
            my @domains = split /\s/, $domains;
            $cfg->OutboundTrackbackDomains( \@domains, 1 );
        }
    }
    $cfg->save_config();
    $args->{saved} = 1;
    $app->redirect(
        $app->uri(
            'mode' => 'cfg_system_general',
            args   => $args,
        ),
        UseMeta => $ENV{FAST_CGI},
    );
}

sub save_cfg_system_web_services {
    my $app = shift;
    $app->validate_magic or return;
    return $app->permission_denied()
        unless $app->user->is_superuser();

    require MT::CMS::Common;
    MT::CMS::Common::run_web_services_save_config_callbacks($app);

    require MT::CMS::Blog;
    MT::CMS::Blog::save_data_api_settings($app);

    $app->add_return_arg( 'saved'         => 1 );
    $app->add_return_arg( 'saved_changes' => 1 );
    return $app->call_return;
}

sub upgrade {
    my $app = shift;

    if ( $ENV{FAST_CGI} || MT->config->PIDFilePath ) {

        # don't enter the upgrade loop.
        $app->reboot;
    }

    # check for an empty database... no author table would do it...
    my $driver         = MT::Object->driver;
    my $upgrade_script = $app->config('UpgradeScript');
    my $user_class     = MT->model('author');
    if ( !$driver || !$driver->table_exists($user_class) ) {
        return $app->redirect( $app->path
                . $upgrade_script
                . $app->uri_params( mode => 'install' ) );
    }
    return $app->redirect( $app->path . $upgrade_script );
}

sub recover_profile_password {
    my $app = shift;
    $app->validate_magic or return;
    return $app->permission_denied()
        unless $app->user->is_superuser();

    require MT::Auth;
    require MT::Log;
    if ( !MT::Auth->can_recover_password ) {
        $app->log(
            {   message => $app->translate(
                    "Invalid password recovery attempt; Cannot recover the password in this configuration"
                ),
                level    => MT::Log::SECURITY(),
                class    => 'system',
                category => 'recover_profile_password',
            }
        );
        return $app->error(
            "Cannot recover the password in this configuration");
    }

    my $author_id = $app->param('author_id');
    my $author    = MT::Author->load($author_id);

    return $app->error( $app->translate("Invalid author_id") )
        if !$author || $author->type != MT::Author::AUTHOR() || !$author_id;

    my ( $rc, $res ) = reset_password( $app, $author );

    if ($rc) {
        my $url = $app->uri(
            'mode' => 'view',
            args   => { _type => 'author', recovered => 1, id => $author_id }
        );
        $app->redirect($url);
    }
    else {
        $app->error($res);
    }
}

sub _allowed_blog_ids_for_backup {
    my ( $app, $blog_id ) = @_;
    my $blog = $app->model('blog')->load($blog_id)
        or return $blog_id;

    my @blog_ids = ();

    if ( !$blog->is_blog ) {
        my $user  = $app->user;
        my $blogs = $blog->blogs;
        push( @blog_ids,
            grep { $user->permissions($_)->can_do('backup_blog') }
            map  { $_->id } @$blogs );
    }

    @blog_ids, $blog_id;
}

sub _can_write_temp_dir {
    my ($temp_dir) = @_;

    return 1 unless ( $^O eq 'MSWin32' );

    require File::Temp;
    my ( $fh, $filepath );
    eval {
        ( $fh, $filepath ) = File::Temp::tempfile(
            '__' . $$ . '.XXXXXXXX',
            DIR    => $temp_dir,
            UNLINK => 1
        );
    };
    return 0 if $@;

    return 1;
}

sub start_backup {
    my $app     = shift;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');

    return $app->permission_denied()
        unless $app->can_do('start_backup');

    my %param = ();
    if ( defined($blog_id) ) {
        $param{blog_id}     = $blog_id;
        $param{backup_what} = join ',',
            _allowed_blog_ids_for_backup( $app, $blog_id );
    }
    if ($blog_id) {
        $app->add_breadcrumb( $app->translate('Export Site') );
    }
    else {
        $app->add_breadcrumb( $app->translate('Export Sites') );
    }
    $param{system_overview_nav} = 1 unless $blog_id;
    $param{nav_backup} = 1;
    require MT::Util::Archive;
    my @formats = MT::Util::Archive->available_formats();
    $param{archive_formats} = \@formats;

    my $limit = $app->config('CGIMaxUpload') || 2048;
    $param{over_300}  = 1 if $limit >= 300 * 1024;
    $param{over_500}  = 1 if $limit >= 500 * 1024;
    $param{over_1024} = 1 if $limit >= 1024 * 1024;
    $param{over_2048} = 1 if $limit >= 2048 * 1024;

    my $tmp = $app->config('ExportTempDir') || $app->config('TempDir');
    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');
    $fmgr->mkpath($tmp) unless -d $tmp;
    unless ( ( -d $tmp ) && ( -w $tmp ) && _can_write_temp_dir($tmp) ) {
        $param{error}
            = $app->translate(
            'Temporary directory needs to be writable for export to work correctly.  Please check (Export)TempDir configuration directive.'
            );
    }
    $app->load_tmpl( 'backup.tmpl', \%param );
}

sub start_restore {
    my $app     = shift;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');

    return $app->permission_denied()
        unless $app->can_do('start_restore');

    return $app->return_to_dashboard( redirect => 1 )
        if $blog_id;

    my %param = ();
    if ( defined($blog_id) ) {
        $param{blog_id} = $blog_id;
    }

    $app->add_breadcrumb( $app->translate('Import Sites') );

    $param{system_overview_nav} = 1 unless $blog_id;
    $param{nav_backup} = 1;

    eval "require XML::SAX";
    $param{missing_sax} = 1 if $@;

    my $tmp = $app->config('ExportTempDir') || $app->config('TempDir');
    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');
    $fmgr->mkpath($tmp) unless -d $tmp;
    unless ( ( -d $tmp ) && ( -w $tmp ) ) {
        $param{error}
            = $app->translate(
            'Temporary directory needs to be writable for import to work correctly.  Please check (Export)TempDir configuration directive.'
            );
    }

    $app->load_tmpl( 'restore.tmpl', \%param );
}

sub backup {
    my $app     = shift;

    $app->validate_param({
        backup_archive_format => [qw/MAYBE_STRING/],
        backup_what           => [qw/IDS/],
        blog_id               => [qw/ID/],
        size_limit            => [qw/MAYBE_STRING/],
    }) or return;

    my $user    = $app->user;
    my $blog_id = $app->param('blog_id') || 0;
    my $perms   = $app->permissions
        or return $app->permission_denied();
    my $blog_ids = $app->param('backup_what') || '';
    my @blog_ids = split ',', $blog_ids;

    require MT::Util::Log;
    MT::Util::Log::init();

    MT::Util::Log->info('=== Start export.');

    if ( $user->is_superuser ) {

        # Get all target blog_id when system administrator choose website.
        if (@blog_ids) {
            my @child_ids;
            my $blog_class = $app->model('blog');
            foreach my $bid (@blog_ids) {
                my $target = $blog_class->load($bid);
                if ( !$target->is_blog && scalar @{ $target->blogs } ) {
                    my @blogs = map { $_->id } @{ $target->blogs };
                    push @child_ids, @blogs;
                }
            }
            push @blog_ids, @child_ids if @child_ids;
        }
    }
    else {
        return $app->permission_denied()
            unless defined($blog_id) && $perms->can_do('backup_blog');

        # Only System Administrator can do all backup.
        return $app->errtrans('Invalid request')
            unless $blog_ids;

        my @allowed_blog_ids = _allowed_blog_ids_for_backup( $app, $blog_id );
        for my $blog_id (@blog_ids) {
            return $app->permission_denied()
                unless grep { $_ eq $blog_id } @allowed_blog_ids;
        }
    }
    $app->validate_magic() or return;

    my $size = $app->param('size_limit') || 0;
    return $app->errtrans( '[_1] is not a number.', encode_html($size) )
        if $size !~ /^\d+$/;

    my $archive = $app->param('backup_archive_format');
    my $enc     = $app->charset || 'utf-8';
    my @ts      = gmtime(time);
    my $ts      = sprintf "%04d-%02d-%02d-%02d-%02d-%02d", $ts[5] + 1900,
        $ts[4] + 1,
        @ts[ 3, 2, 1, 0 ];
    my $file = "Movable_Type-$ts" . '-Export';

    my $param = { return_args => '__mode=start_backup' };
    $app->{no_print_body} = 1;
    $app->add_breadcrumb(
        $app->translate( $blog_id ? 'Export Site' : 'Export Sites' ),
        $app->uri(
            mode => 'start_backup',
            args => { blog_id => $blog_id },
        )
    );
    $app->add_breadcrumb( $app->translate('Export') );
    $param->{system_overview_nav} = 1 if defined($blog_ids) && $blog_ids;
    $param->{blog_id}  = $blog_id  if $blog_id;
    $param->{blog_ids} = $blog_ids if $blog_ids;
    $param->{nav_backup} = 1;

    local $| = 1;
    $app->send_http_header('text/html');
    $app->print_encode(
        $app->build_page( 'include/backup_start.tmpl', $param ) );
    require File::Temp;
    require File::Spec;
    use File::Copy;
    my $temp_dir = $app->config('ExportTempDir') || $app->config('TempDir');
    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');
    $fmgr->mkpath($temp_dir) unless -d $temp_dir;

    require MT::BackupRestore;
    my $count_term
        = @blog_ids ? { class => '*', blog_id => [ [0], @blog_ids ] }
        : $blog_id ? { class => '*', blog_id => [ 0, $blog_id ] }
        :            { class => '*' };
    my $num_assets = $app->model('asset')->count($count_term);
    my $printer;
    my $splitter;
    my $finisher;
    my $progress = sub { _progress( $app, @_ ); };
    my $fh;
    my $fname;
    my $arc_buf;

    if ( !( $size || $num_assets ) ) {
        $splitter = sub { };

        if ( !$archive ) {
            ( $fh, my $filepath )
                = File::Temp::tempfile( 'xml.XXXXXXXX', DIR => $temp_dir );
            binmode $fh, ":encoding(utf8)";
            ( my $vol, my $dir, $fname ) = File::Spec->splitpath($filepath);
            $printer = sub {
                my ($data) = @_;
                print $fh $data;
                return length($data);
            };
            $finisher = sub {
                my ($asset_files) = @_;
                close $fh;
                _backup_finisher( $app, $fname, $param );
            };
        }
        else {    # archive/compress files
            $printer = sub {
                my ($data) = @_;
                $arc_buf .= $data;
                return length($data);
            };
            $finisher = sub {
                require MT::Util::Archive;
                my ($asset_files) = @_;
                ( my $fh, my $filepath )
                    = File::Temp::tempfile( $archive . '.XXXXXXXX',
                    DIR => $temp_dir );
                ( my $vol, my $dir, $fname )
                    = File::Spec->splitpath($filepath);
                close $fh;
                unlink $filepath;
                my $arc = MT::Util::Archive->new( $archive, $filepath );
                $arc->add_string( Encode::encode_utf8($arc_buf),
                    "$file.xml" );
                $arc->add_string(
                    "<manifest xmlns='"
                        . MT::BackupRestore::NS_MOVABLETYPE()
                        . "'><file type='backup' name='$file.xml' /></manifest>",
                    "$file.manifest"
                );
                $arc->close;
                _backup_finisher( $app, $fname, $param );
            };
        }
    }
    else {
        my @files;
        my $filename = File::Spec->catfile( $temp_dir, $file . "-1.xml" );
        $fh = gensym();
        open $fh, ">", $filename or die "Couldn't open $filename: $!";
        my $url = $app->uri . "?__mode=backup_download&name=$file-1.xml";
        $url .= "&magic_token=" . $app->current_magic
            if defined( $app->current_magic );
        $url .= "&blog_id=$blog_id" if defined($blog_id);
        push @files,
            {
            url      => $url,
            filename => $file . "-1.xml"
            };
        $printer = sub {
            require bytes;
            my ($data) = @_;
            $data = Encode::encode_utf8($data)
                if Encode::is_utf8($data);
            print $fh $data;
            return bytes::length($data);
        };
        $splitter = sub {
            my ( $findex, $header ) = @_;

            print $fh '</movabletype>';
            close $fh;
            my $filename
                = File::Spec->catfile( $temp_dir, $file . "-$findex.xml" );
            $fh = gensym();
            open $fh, ">", $filename or die "Couldn't open $filename: $!";
            my $url
                = $app->uri
                . "?__mode=backup_download&name=$file-$findex.xml";
            $url .= "&magic_token=" . $app->current_magic
                if defined( $app->current_magic );
            $url .= "&blog_id=$blog_id" if defined($blog_id);
            push @files,
                {
                url      => $url,
                filename => $file . "-$findex.xml"
                };
            print $fh $header;
        };
        $finisher = sub {
            my ($asset_files) = @_;
            close $fh;
            my $filename = File::Spec->catfile( $temp_dir, "$file.manifest" );
            $fh = gensym();
            open $fh, ">", $filename or die "Couldn't open $filename: $!";
            print $fh "<manifest xmlns='"
                . MT::BackupRestore::NS_MOVABLETYPE() . "'>\n";
            for my $file (@files) {
                my $name = $file->{filename};
                print $fh "<file type='backup' name='$name' />\n";
            }
            require MT::FileMgr::Local;
            for my $id ( keys %$asset_files ) {
                my $name = $id . '-' . $asset_files->{$id}->[2];
                my $tmp = File::Spec->catfile( $temp_dir, $name );
                unless (
                    copy(
                        MT::FileMgr::Local::_local(
                            $asset_files->{$id}->[1]
                        ),
                        MT::FileMgr::Local::_local($tmp)
                    )
                    )
                {
                    $app->log(
                        {   message => $app->translate(
                                'Copying file [_1] to [_2] failed: [_3]',
                                $asset_files->{$id}->[1],
                                $tmp, $!
                            ),
                            level    => MT::Log::WARNING(),
                            class    => 'system',
                            category => 'backup'
                        }
                    );
                    next;
                }
                my $xml_name = $asset_files->{$id}->[2];
                require MT::Util;
                print $fh "<file type='asset' name='"
                    . MT::Util::encode_xml( $xml_name, 1, 1 )
                    . "' asset_id='"
                    . $id
                    . "' />\n";
                my $url
                    = $app->uri
                    . "?__mode=backup_download&assetname="
                    . MT::Util::encode_url($name);
                $url .= "&magic_token=" . $app->current_magic
                    if defined( $app->current_magic );
                $url .= "&blog_id=$blog_id" if defined($blog_id);
                push @files,
                    {
                    url      => $url,
                    filename => MT::FileMgr::Local::_local($name),
                    };
            }
            print $fh "</manifest>\n";
            close $fh;
            my $url
                = $app->uri . "?__mode=backup_download&name=$file.manifest";
            $url .= "&magic_token=" . $app->current_magic
                if defined( $app->current_magic );
            $url .= "&blog_id=$blog_id" if defined($blog_id);
            push @files,
                {
                url      => $url,
                filename => "$file.manifest"
                };
            if ( !$archive ) {

                for my $f (@files) {
                    $f->{filename}
                        = MT::FileMgr::Local::_syserr( $f->{filename} )
                        if ( $f->{filename}
                        && !Encode::is_utf8( $f->{filename} ) );
                }
                $param->{files_loop} = \@files;
                $param->{tempdir}    = $temp_dir;
                my @fnames = map { $_->{filename} } @files;
                _backup_finisher( $app, \@fnames, $param );
            }
            else {
                my ( $fh_arc, $filepath )
                    = File::Temp::tempfile( $archive . '.XXXXXXXX',
                    DIR => $temp_dir );
                ( my $vol, my $dir, $fname )
                    = File::Spec->splitpath($filepath);
                require MT::Util::Archive;
                close $fh_arc;
                unlink $filepath;
                my $arc = MT::Util::Archive->new( $archive, $filepath );
                for my $f (@files) {
                    $arc->add_file( $temp_dir, $f->{filename} );
                }
                $arc->close;

                # for safery, don't unlink before closing $arc here.
                for my $f (@files) {
                    unlink File::Spec->catfile( $temp_dir, $f->{filename} );
                }
                _backup_finisher( $app, $fname, $param );
            }
        };
    }

    my @tsnow    = gmtime(time);
    my $metadata = {
        backup_by => MT::Util::encode_xml( $app->user->name, 1 ) . '(ID: '
            . $app->user->id . ')',
        backup_on => sprintf(
            "%04d-%02d-%02dT%02d:%02d:%02d",
            $tsnow[5] + 1900,
            $tsnow[4] + 1,
            @tsnow[ 3, 2, 1, 0 ]
        ),
        backup_what    => join( ',', @blog_ids ),
        schema_version => $app->config('SchemaVersion'),
    };
    eval {
        MT::BackupRestore->backup( \@blog_ids, $printer, $splitter, $finisher,
            $progress, $size * 1024,
            $enc, $metadata );
    };
    if ($@) {

        # Abnormal end
        $param->{error} = $@;
        close $fh;
        _backup_finisher( $app, $fname, $param );
    }

    MT::Util::Log->info('=== End   export.');

}

sub backup_download {
    my $app     = shift;
    my $user    = $app->user;
    my $blog_id = $app->param('blog_id');
    unless ( $user->is_superuser ) {
        my $perms = $app->permissions;
        return $app->permission_denied()
            unless defined($perms)
            && defined($blog_id)
            && $perms->can_do('backup_download');
    }
    $app->validate_magic() or return;
    my $filename  = $app->param('filename');
    my $assetname = $app->param('assetname');
    my $temp_dir  = $app->config('ExportTempDir') || $app->config('TempDir');
    my $newfilename;

    $app->{hide_goback_button} = 1;

    if ( defined($assetname) ) {
        my $sess = MT::Session->load( { kind => 'BU', name => $assetname } );
        if ( !defined($sess) || !$sess ) {
            return $app->errtrans("Specified file was not found.");
        }
        $newfilename = $filename = $assetname;
        $sess->remove;
    }
    elsif ( defined($filename) ) {
        my $sess = MT::Session->load( { kind => 'BU', name => $filename } );
        if ( !defined($sess) || !$sess ) {
            return $app->errtrans("Specified file was not found.");
        }
        my @ts = gmtime( $sess->start );
        my $ts = sprintf "%04d-%02d-%02d-%02d-%02d-%02d", $ts[5] + 1900,
            $ts[4] + 1, @ts[ 3, 2, 1, 0 ];
        $newfilename = "Movable_Type-$ts" . '-Export';
        $sess->remove;
    }
    else {
        $newfilename = $app->param('name') || '';
        return
            if $newfilename
            !~ /Movable_Type-\d{4}-\d{2}-\d{2}-\d{2}-\d{2}-\d{2}-Export(?:-\d+)?\.\w+/;
        $filename = $newfilename;
    }

    require File::Spec;
    my $fname = File::Spec->catfile( $temp_dir, $filename );

    my $contenttype;
    if ( !defined($assetname) && ( $filename =~ m/^xml\..+$/i ) ) {
        my $enc = $app->charset || 'utf-8';
        $contenttype = "text/xml; charset=$enc";
        $newfilename .= '.xml';
    }
    elsif ( $filename =~ m/^tgz\..+$/i ) {
        $contenttype = 'application/x-tar-gz';
        $newfilename .= '.tar.gz';
    }
    elsif ( $filename =~ m/^zip\..+$/i ) {
        $contenttype = 'application/zip';
        $newfilename .= '.zip';
    }
    else {
        $contenttype = 'application/octet-stream';
        if ( $app->param->user_agent =~ /MSIE/ ) {
            $newfilename = Encode::encode( 'Shift_JIS', $newfilename );
        }
    }

    if ( open( my $fh, "<", MT::FileMgr::Local::_local($fname) ) ) {
        binmode $fh;
        $app->{no_print_body} = 1;
        $app->set_header( "Content-Disposition" => 'attachment; filename="'
                . $newfilename
                . '"' );
        $app->send_http_header($contenttype);
        while ( read $fh, my ($chunk), 8192 ) {
            $app->print($chunk);
        }
        close $fh;
        $app->log(
            {   message => $app->translate(
                    '[_1] successfully downloaded export file ([_2])',
                    $app->user->name, $fname
                ),
                level    => MT::Log::INFO(),
                class    => 'system',
                category => 'restore'
            }
        );
        MT::FileMgr::Local->delete($fname);
    }
    else {
        $app->errtrans('Specified file was not found.');
    }
}

sub restore {
    my $app  = shift;
    my $user = $app->user;
    return $app->permission_denied()
        unless $app->can_do('restore_blog');
    $app->validate_magic() or return;

    require MT::Util::Log;
    MT::Util::Log::init();

    MT::Util::Log->info('=== Start import.');

    my ($fh) = $app->upload_info('file');
    my $uploaded = $app->param('file');
    my ( $volume, $directories, $uploaded_filename );
    ( $volume, $directories, $uploaded_filename )
        = File::Spec->splitpath($uploaded)
        if defined($uploaded);
    $app->mode('start_restore');

    $app->log(
        {   message  => (
                $uploaded_filename
                ? MT->translate( 'Started importing sites: [_1]', $uploaded_filename )
                : MT->translate('Started importing sites')
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'restore',
        }
    );

    if ( defined($uploaded_filename)
        && ( $uploaded_filename =~ /^.+\.manifest$/i ) )
    {
        return restore_upload_manifest( $app, $fh );
    }

    my $param = { return_args => '__mode=dashboard' };

    $app->add_breadcrumb(
        $app->translate('Import Sites'),
        $app->uri( mode => 'start_restore' )
    );
    $app->add_breadcrumb( $app->translate('Import') );
    $param->{system_overview_nav} = 1;
    $param->{nav_backup}          = 1;

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    $app->print_encode( $app->build_page( 'restore_start.tmpl', $param ) );
    my $return_error = sub {
        $app->print_encode(
            $app->build_page( "restore_end.tmpl", { error => $_[0] } ) );
        return 1;
    };

    # Set flag
    $app->request( '__restore_in_progress', 1 );

    require File::Path;

    my $error = '';
    my $result;
    if ( !$fh ) {
        $param->{restore_upload} = 0;
        my $dir = $app->config('ImportPath');
        my ( $blog_ids, $asset_ids );
        eval {
            ( $blog_ids, $asset_ids )
                = restore_directory( $app, $dir, \$error );
        };
        $app->request( '__restore_in_progress', undef );
        return $return_error->($@) if $@;

        if ( defined $blog_ids ) {
            $param->{open_dialog} = 1;
            $param->{blog_ids}    = join( ',', @$blog_ids );
            $param->{asset_ids}   = join( ',', @$asset_ids )
                if defined $asset_ids;
            $param->{tmp_dir} = $dir;
        }
        elsif ( defined $asset_ids ) {
            my %asset_ids = @$asset_ids;
            my %error_assets;
            eval {
                _restore_non_blog_asset( $app, $dir, $asset_ids,
                    \%error_assets );
            };
            return $return_error->($@) if $@;
            if (%error_assets) {
                my $data;
                while ( my ( $key, $value ) = each %error_assets ) {
                    $data .= $app->translate( 'MT::Asset#[_1]: ', $key )
                        . $value . "\n";
                }
                my $message
                    = $app->translate(
                    'Some of the actual files for assets could not be imported.'
                    );
                $app->log(
                    {   message  => $message,
                        level    => MT::Log::WARNING(),
                        class    => 'system',
                        category => 'restore',
                        metadata => $data,
                    }
                );
                $error .= $message;
            }
        }
    }
    else {
        $param->{restore_upload} = 1;
        if ( $uploaded_filename =~ /^.+\.xml$/i ) {
            my $blog_ids = eval { restore_file( $app, $fh, \$error ) };
            return $return_error->($@) if $@;
            if ( defined $blog_ids ) {
                $param->{open_dialog} = 1;
                $param->{blog_ids} = join( ',', @$blog_ids );
            }
        }
        else {
            require MT::Util::Archive;
            my $arc;
            if ( $uploaded_filename =~ /^.+\.tar(\.gz)?$/i ) {
                $arc = MT::Util::Archive->new( 'tgz', $fh );
            }
            elsif ( $uploaded_filename =~ /^.+\.zip$/i ) {
                $arc = MT::Util::Archive->new( 'zip', $fh );
            }
            else {
                $error
                    = $app->translate(
                    'Please use xml, tar.gz, zip, or manifest as a file extension.'
                    );
            }
            if ( !$arc or !$arc->is_safe_to_extract ) {
                $result = 0;
                $param->{restore_success} = 0;
                if ($error) {
                    $param->{error} = $error;
                }
                else {
                    $error = MT->translate(
                          !$arc                     ? 'Unknown file format'
                        : !$arc->is_safe_to_extract ? 'Unsafe archive'
                        :                             ''
                    );
                    $app->log(
                        {   message  => $error . ":$uploaded_filename",
                            level    => MT::Log::WARNING(),
                            class    => 'system',
                            category => 'restore',
                            metadata => MT::Util::Archive->errstr,
                        }
                    );
                }
                $app->print_encode($error);
                $app->print_encode(
                    $app->build_page( "restore_end.tmpl", $param ) );
                close $fh if $fh;
                $app->request( '__restore_in_progress', undef );
                return 1;
            }
            my $temp_dir = $app->config('ExportTempDir') || $app->config('TempDir');
            require File::Temp;
            my $tmp = File::Temp::tempdir( $uploaded_filename . 'XXXX',
                DIR => $temp_dir );
            $tmp = Encode::decode( MT->config->PublishCharset, $tmp );

            MT::Util::Log->info( '=== Start extract ' . $uploaded_filename );

            $arc->extract($tmp);

            MT::Util::Log->info( '=== End   extract ' . $uploaded_filename );

            $arc->close;
            my ( $blog_ids, $asset_ids );
            eval {
                ( $blog_ids, $asset_ids )
                    = restore_directory( $app, $tmp, \$error );
            };
            $app->request( '__restore_in_progress', undef );
            return $return_error->($@) if $@;

            if ( defined $blog_ids ) {
                $param->{open_dialog} = 1;
                $param->{blog_ids} = join( ',', @$blog_ids )
                    if defined $blog_ids;
                $param->{asset_ids} = join( ',', @$asset_ids )
                    if defined $asset_ids;
                $param->{tmp_dir} = $tmp;
            }
            elsif ( defined $asset_ids ) {
                my %asset_ids = @$asset_ids;
                my %error_assets;
                eval {
                    _restore_non_blog_asset( $app, $tmp, \%asset_ids,
                        \%error_assets );
                };
                return $return_error->($@) if $@;
                if (%error_assets) {
                    my $data;
                    while ( my ( $key, $value ) = each %error_assets ) {
                        $data .= $app->translate( 'MT::Asset#[_1]: ', $key )
                            . $value . "\n";
                    }
                    my $message
                        = $app->translate(
                        'Some of the actual files for assets could not be imported.'
                        );
                    $app->log(
                        {   message  => $message,
                            level    => MT::Log::WARNING(),
                            class    => 'system',
                            category => 'restore',
                            metadata => $data,
                        }
                    );
                    $error .= $message;
                }
            }
        }
    }
    $param->{restore_success} = !$error;
    $param->{error} = $error if $error;
    if ( ( exists $param->{open_dialog} ) && ( $param->{open_dialog} ) ) {
        $param->{dialog_mode} = 'dialog_adjust_sitepath';
        $param->{dialog_params}
            = 'magic_token='
            . $app->current_magic
            . '&amp;blog_ids='
            . $param->{blog_ids}
            . '&amp;tmp_dir='
            . encode_url( $param->{tmp_dir} );
        if ( ( $param->{restore_upload} ) && ( $param->{restore_upload} ) ) {
            $param->{dialog_params} .= '&amp;restore_upload=1';
        }
        if ( ( $param->{error} ) && ( $param->{error} ) ) {
            $param->{dialog_params}
                .= '&amp;error=' . encode_url( $param->{error} );
        }
    }

    $app->print_encode( $app->build_page( "restore_end.tmpl", $param ) );
    close $fh if $fh;

    MT::Util::Log->info('=== End   import.');

    1;
}

sub restore_premature_cancel {
    my $app  = shift;
    my $user = $app->user;
    return $app->permission_denied()
        if !$user->is_superuser;
    $app->validate_magic() or return;

    require JSON;
    my $deferred_json = $app->param('deferred_json');
    my $deferred = $deferred_json ? JSON::from_json($deferred_json) : undef;
    my $param = { restore_success => 1 };
    if ( defined $deferred && ( scalar( keys %$deferred ) ) ) {
        _log_dirty_restore( $app, $deferred );
        my $log_url
            = $app->uri( mode => 'list', args => { '_type' => 'log' } );
        $param->{restore_success} = 0;
        my $message
            = $app->translate(
            'Some objects were not imported because their parent objects were not imported.'
            );
        $param->{error}
            = $message . '  '
            . $app->translate( "Detailed information is in the activity log.",
            $log_url );
    }
    else {
        $app->log(
            {   message => $app->translate(
                    '[_1] has canceled the multiple files import operation prematurely.',
                    $app->user->name
                ),
                level    => MT::Log::WARNING(),
                class    => 'system',
                category => 'restore',
            }
        );
    }
    $app->redirect(
        $app->uri( mode => 'list', args => { '_type' => 'log' } ) );
}

sub _restore_non_blog_asset {
    my ( $app, $tmp_dir, $asset_ids, $error_assets ) = @_;
    require MT::FileMgr;
    my $fmgr = MT::FileMgr->new('Local');
    foreach my $new_id ( keys %$asset_ids ) {
        my $asset = $app->model('asset')->load($new_id);
        next unless $asset;
        my $old_id   = $asset_ids->{$new_id};
        my $filename = $old_id . '-' . $asset->file_name;
        my $file     = File::Spec->catfile( $tmp_dir, $filename );
        MT::BackupRestore->restore_asset( $file, $asset, $old_id, $fmgr,
            $error_assets, sub { $app->print_encode(@_); } );
    }
}

sub adjust_sitepath {
    my $app  = shift;
    my $user = $app->user;
    return $app->permission_denied()
        if !$user->is_superuser;
    $app->validate_magic() or return;

    require MT::BackupRestore;

    my $tmp_dir   = $app->param('tmp_dir');
    my $error     = $app->param('error') || q();
    my $asset_ids = $app->param('asset_ids') || '';
    my %asset_ids = split ',', $asset_ids;

    my $redirect     = $app->param('redirect');
    my $current_file = $app->param('current_file');
    my $assets       = $app->param('assets');

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    $app->print_encode( $app->build_page( 'dialog/restore_start.tmpl', {} ) );

    my $asset_class = $app->model('asset');
    my %error_assets;
    my %blogs_meta;
    my $path_limit;
    my $path_limit_quote;
    if ( $path_limit = $app->config->BaseSitePath ) {
        $path_limit = File::Spec->catdir( $path_limit, "PATH" );
        $path_limit =~ s/PATH$//;
        $path_limit_quote = quotemeta($path_limit);
    }
    my @p = $app->multi_param;
    foreach my $p (@p) {
        next unless $p =~ /^site_path_(\d+)/;
        my $id   = $1;
        my $blog = $app->model('blog')->load($id)
            or return $app->error(
            $app->translate( 'Cannot load site #[_1].', $id ) );
        my $original           = $blog->clone();
        my $old_site_path      = $app->param("old_site_path_$id");
        my $old_site_url       = $app->param("old_site_url_$id");
        my $site_path          = $app->param("site_path_$id") || q();
        my $site_url           = $app->param("site_url_$id") || q();
        my $site_url_path      = $app->param("site_url_path_$id") || q();
        my $site_url_subdomain = $app->param("site_url_subdomain_$id")
            || q();
        $site_url_subdomain .= '.'
            if $site_url_subdomain && $site_url_subdomain !~ /\.$/;
        my $parent_id          = $app->param("parent_id_$id");
        my $site_path_absolute = $app->param("site_path_absolute_$id")
            || q();
        my $use_absolute = $app->param("use_absolute_$id") || q();

        my $site_name = $app->param("site_name_$id");
        $blog->name($site_name) if defined $site_name && $site_name ne '';

        if ($use_absolute) {
            $site_path = $app->param("site_path_absolute_$id") || q();
            if ( $path_limit and ( $site_path !~ m/^$path_limit_quote/i ) ) {
                $site_path = $path_limit;
            }
        }
        elsif ( $path_limit
            and !$blog->is_blog
            and ( $site_path !~ m/^$path_limit_quote/i ) )
        {
            $site_path = $path_limit;
        }
        $blog->site_path($site_path);

        $blog->parent_id($parent_id)
            if $blog->is_blog() && $parent_id;
        if ($site_url_path) {
            $blog->site_url("$site_url_subdomain/::/$site_url_path");
        }
        else {
            $blog->site_url($site_url);
        }

        if ( $site_url || $site_url_path || $site_path ) {
            $app->print_encode(
                $app->translate(
                    "Changing Site Path for the site '[_1]' (ID:[_2])...",
                    encode_html( $blog->name ),
                    $blog->id
                )
            );
        }
        else {
            $app->print_encode(
                $app->translate(
                    "Removing Site Path for the site '[_1]' (ID:[_2])...",
                    encode_html( $blog->name ),
                    $blog->id
                )
            );
        }
        my $old_archive_path = $app->param("old_archive_path_$id");
        my $old_archive_url  = $app->param("old_archive_url_$id");
        my $archive_path     = $app->param("archive_path_$id") || q();
        my $archive_url      = $app->param("archive_url_$id") || q();
        my $archive_url_path = $app->param("archive_url_path_$id")
            || q();
        my $archive_url_subdomain
            = $app->param("archive_url_subdomain_$id") || q();
        $archive_url_subdomain .= '.'
            if $archive_url_subdomain && $archive_url_subdomain !~ /\.$/;
        my $archive_path_absolute
            = $app->param("archive_path_absolute_$id") || q();
        my $use_absolute_archive
            = $app->param("use_absolute_archive_$id") || q();

        if ($use_absolute_archive) {
            $archive_path = $archive_path_absolute;
            if ( $path_limit
                and ( $archive_path !~ m/^$path_limit_quote/i ) )
            {
                $archive_path = $path_limit;
            }
        }
        $blog->archive_path($archive_path);

        if ($archive_url_path) {
            $blog->archive_url("$archive_url_subdomain/::/$archive_url_path");
        }
        else {
            $blog->archive_url($archive_url);
        }
        if (   ( $old_archive_url && ( $archive_url || $archive_url_path ) )
            || ( $old_archive_path && $archive_path ) )
        {
            $app->print_encode(
                "\n"
                    . $app->translate(
                    "Changing Archive Path for the site '[_1]' (ID:[_2])...",
                    encode_html( $blog->name ),
                    $blog->id
                    )
            );
        }
        elsif ( $old_archive_url || $old_archive_path ) {
            $app->print_encode(
                "\n"
                    . $app->translate(
                    "Removing Archive Path for the site '[_1]' (ID:[_2])...",
                    encode_html( $blog->name ),
                    $blog->id
                    )
            );
        }
        _call_pre_save_blog( $app, $blog, $original )
            or $app->print_encode( $app->translate("failed") . "\n" ), next;
        $blog->save
            or $app->print_encode( $app->translate("failed") . "\n" ), next;
        $app->print_encode( $app->translate("ok") . "\n" );

        ## Change FileInfo
        my $fileinfo_class = $app->model('fileinfo');
        my @fileinfo = $fileinfo_class->load( { blog_id => $id } );

        my $delim = $^O eq 'MSWin32' ? '\\' : '/';

        foreach my $fi (@fileinfo) {

            ### Change fileinfo_file_path

            # Use adequate path according to archive type.
            my ( $old_path, $path );
            if ( $fi->archive_type eq 'index' || $fi->archive_type eq 'Page' )
            {
                $old_path = $old_site_path;
                $path     = $blog->site_path;
            }
            else {
                $old_path
                    = $old_archive_path ? $old_archive_path : $old_site_path;
                $path = $blog->archive_path;
            }

            my $old_delim        = $fi->file_path =~ m/^\// ? '/' : '\\';
            my $quoted_old_delim = quotemeta $old_delim;
            my $quoted_old_path  = quotemeta $old_path;

            # Remove site/archive path part in fileinfo_file_path.
            my $file_path = $fi->file_path;
            if ( $blog->is_blog ) {
                $file_path =~ s/^.*$quoted_old_path(.*)$/$1/;
                $file_path =~ s/$quoted_old_delim$//;
            }
            else {
                $file_path =~ s/^$quoted_old_path//;
            }

            # Replace delimiters if needing.
            $file_path =~ s/^$quoted_old_delim//;
            if ( $old_delim ne $delim ) {
                $file_path =~ s/$quoted_old_delim/$delim/g;
            }

            $fi->file_path( File::Spec->catfile( $path, $file_path ) );

            $app->print_encode(
                $app->translate(
                    "Changing file path for FileInfo record (ID:[_1])...",
                    $fi->id
                )
            );

            ## Change fileinfo_url
            my ( $old_rel_url, $rel_url );
            if ( $blog->is_blog ) {

                # Add slash to the head and the end of rel_url if needing.
                $old_rel_url = $old_site_path;
                $old_rel_url = '/' . $old_rel_url
                    unless $old_rel_url =~ m/^\//;
                $old_rel_url = $old_rel_url . '/'
                    unless $old_rel_url =~ m/\/$/;

                $rel_url = $site_url_path;
                $rel_url = '/' . $rel_url unless $rel_url =~ m/^\//;
                $rel_url = $rel_url . '/' unless $rel_url =~ m/\/$/;
            }
            else {
                # Leave directory only.
                ($old_rel_url)
                    = ( $old_site_url =~ m|^(?:[^:]*\:\/\/)?[^/]*(.*)| );
                ($rel_url) = ( $site_url =~ m|^(?:[^:]*\:\/\/)?[^/]*(.*)| );
            }

            my $url                = $fi->url;
            my $quoted_old_rel_url = quotemeta $old_rel_url;

            # Replace old rel_url with new one.
            $url =~ s!$quoted_old_rel_url!$rel_url!;

            $fi->url($url);

            $app->print_encode(
                "\n"
                    . $app->translate(
                    "Changing URL for FileInfo record (ID:[_1])...", $fi->id
                    )
            );

            $fi->save
                or $app->print_encode( $app->translate("failed") . "\n" ),
                next;
            $app->print_encode( $app->translate("ok") . "\n" );
        }

        $blogs_meta{$id} = {
            'old_archive_path' => $old_archive_path,
            'old_archive_url'  => $old_archive_url,
            'archive_path'     => $blog->archive_path,
            'archive_url'      => $blog->archive_url,
            'old_site_path'    => $old_site_path,
            'old_site_url'     => $old_site_url,
            'site_path'        => $blog->site_path,
            'site_url'         => $blog->site_url,
        };
        next unless %asset_ids;

        my $fmgr = ( $site_path || $archive_path ) ? $blog->file_mgr : undef;
        next unless defined $fmgr;

        my @assets = $asset_class->load( { blog_id => $id, class => '*' } );
        foreach my $asset (@assets) {
            my $path = $asset->column('file_path');
            my $url  = $asset->column('url');
            if ($archive_path) {
                $path =~ s/^\Q$old_archive_path\E/$archive_path/i;
                $asset->file_path($path);
            }
            if ($archive_url) {
                $url =~ s/^\Q$old_archive_url\E/$archive_url/i;
                $asset->url($url);
            }
            if ($site_path) {
                $path =~ s/^\Q$old_site_path\E/$site_path/i;
                $asset->file_path($path);
            }
            if ($site_url) {
                $url =~ s/^\Q$old_site_url\E/$site_url/i;
                $asset->url($url);
            }
            $app->print_encode(
                $app->translate(
                    "Changing file path for the asset '[_1]' (ID:[_2])...",
                    encode_html( $asset->label ),
                    $asset->id
                )
            );
            $asset->save
                or $app->print_encode( $app->translate("failed") . "\n" ),
                next;
            $app->print_encode( $app->translate("ok") . "\n" );
            unless ($redirect) {
                my $old_id   = delete $asset_ids{ $asset->id };
                my $filename = "$old_id-" . $asset->file_name;
                my $file     = File::Spec->catfile( $tmp_dir, $filename );
                MT::BackupRestore->restore_asset( $file, $asset, $old_id,
                    $fmgr, \%error_assets, sub { $app->print_encode(@_); } );
            }
        }
    }
    unless ($redirect) {
        _restore_non_blog_asset( $app, $tmp_dir, \%asset_ids,
            \%error_assets );
    }
    if (%error_assets) {
        my $data;
        while ( my ( $key, $value ) = each %error_assets ) {
            $data .= $app->translate( 'MT::Asset#[_1]: ', $key )
                . $value . "\n";
        }
        my $message = $app->translate(
            'Some of the actual files for assets could not be imported.');
        $app->log(
            {   message  => $message,
                level    => MT::Log::WARNING(),
                class    => 'system',
                category => 'restore',
                metadata => $data,
            }
        );
        $error .= $message;
    }

    if ($tmp_dir) {
        if ( $app->param('restore_upload') ) {
            require File::Path;
            File::Path::rmtree($tmp_dir);
        }
        else {
            opendir my $dh,
                $tmp_dir
                or return $app->error(
                MT->translate(
                    "Cannot open directory '[_1]': [_2]",
                    $tmp_dir, "$!"
                )
                );
            my $manifest;
            for my $f ( readdir $dh ) {
                next if $f !~ /^.+\.manifest$/i;
                $manifest = File::Spec->catfile( $tmp_dir,
                    Encode::decode( MT->config->PublishCharset, $f ) );
                last;
            }
            closedir $dh;
            if ($manifest) {
                my $fh = gensym;
                open $fh, "<", $manifest
                    or return $app->error(
                    MT->translate( "Cannot open [_1].", $manifest ) );
                seek( $fh, 0, 0 ) or return undef;
                require XML::SAX;
                require MT::BackupRestore::ManifestFileHandler;
                my $handler = MT::BackupRestore::ManifestFileHandler->new();

                require MT::Util;
                my $parser = MT::Util::sax_parser();
                $parser->{Handler} = $handler;
                eval { $parser->parse_file($fh); };
                if ( my $e = $@ ) {
                    die $e;
                }
                require MT::FileMgr;
                my $fmgr    = MT::FileMgr->new('Local');
                my $backups = $handler->{backups};
                my $errors;
                unless ($backups) {
                    return $app->error(
                        MT->translate(
                            "Manifest file [_1] was not a valid Movable Type exported manifest file.",
                            $manifest
                        )
                    );
                }
                else {
                    my $files = $backups->{files};
                    for my $file (@$files) {
                        my $filepath = File::Spec->catfile( $tmp_dir, $file );
                        $fmgr->delete($filepath)
                            or $errors .= $app->translate(
                            "Could not remove exported file [_1] from the filesystem: [_2]",
                            $filepath, $fmgr->errstr
                            ) . "\n";
                    }
                    my $assets = $backups->{assets};
                    for my $asset (@$assets) {
                        my $asset_name
                            = $asset->{asset_id} . '-' . $asset->{name};
                        my $filepath
                            = File::Spec->catfile( $tmp_dir, $asset_name );
                        $fmgr->delete($filepath)
                            or $errors .= $app->translate(
                            "Could not remove exported file [_1] from the filesystem: [_2]",
                            $filepath, $fmgr->errstr
                            ) . "\n";
                    }
                }
                $fmgr->delete($manifest)
                    or $errors .= $app->translate(
                    "Could not remove exported file [_1] from the filesystem: [_2]",
                    $manifest, $fmgr->errstr
                    ) . "\n";
                if ($errors) {
                    my $message = $app->translate(
                        'Some of the exported files could not be removed.');
                    $app->log(
                        {   message  => $message,
                            level    => MT::Log::WARNING(),
                            class    => 'system',
                            category => 'restore',
                            metadata => $errors,
                        }
                    );
                    $error .= $message;
                }
            }
        }
    }

    my $param = {};
    if ( $redirect && $current_file ) {
        $param->{restore_end}
            = 0;    # redirect=1 means we are from multi-uploads
        $param->{blogs_meta} = MT::Util::to_json( \%blogs_meta );
        $param->{next_mode}  = 'dialog_restore_upload';
    }
    else {
        $param->{restore_end} = 1;
    }
    if ($error) {
        $param->{error}     = $error;
        $param->{error_url} = $app->base
            . $app->uri( mode => 'list', args => { '_type' => 'log' } );
    }
    for my $key (
        qw(files last redirect is_dirty is_asset objects_json deferred_json))
    {
        $param->{$key} = $app->param($key);
    }
    $param->{name}   = $current_file;
    $param->{assets} = encode_html($assets);
    $app->print_encode(
        $app->build_page( 'dialog/restore_end.tmpl', $param ) );
}

sub dialog_restore_upload {
    my $app  = shift;
    my $user = $app->user;
    return $app->permission_denied()
        if !$user->is_superuser;
    $app->validate_magic() or return;

    my $current        = $app->param('current_file');
    my $last           = $app->param('last');
    my $files          = $app->param('files');
    my $assets_json    = $app->param('assets');
    my $is_asset       = $app->param('is_asset') || 0;
    my $schema_version = $app->param('schema_version')
        || $app->config('SchemaVersion');
    my $overwrite_template = $app->param('overwrite_templates') ? 1 : 0;

    my $objects  = {};
    my $deferred = {};
    require JSON;
    my $deferred_json = $app->param('deferred_json');
    my $objects_json  = $app->param('objects_json');
    $deferred = JSON::from_json($deferred_json) if $deferred_json;

    my ($fh) = $app->upload_info('file');

    my $param = {};
    $param->{start}         = $app->param('start') || 0;
    $param->{is_asset}      = $is_asset;
    $param->{name}          = $current;
    $param->{files}         = $files;
    $param->{assets}        = $assets_json;
    $param->{last}          = $last;
    $param->{redirect}      = 1;
    $param->{is_dirty}      = $app->param('is_dirty');
    $param->{objects_json}  = $objects_json if $objects_json;
    $param->{deferred_json} = MT::Util::to_json($deferred)
        if defined($deferred);
    $param->{blogs_meta}          = $app->param('blogs_meta');
    $param->{schema_version}      = $schema_version;
    $param->{overwrite_templates} = $overwrite_template;

    my $uploaded = $app->param('file') || $app->param('fname');
    if ( defined($uploaded) ) {
        $uploaded =~ s!\\!/!g;    ## Change backslashes to forward slashes
        $uploaded =~ s!^.*/!!;    ## Get rid of full directory paths
        if ( $uploaded =~ m!\.\.|\0|\|! ) {
            $param->{error}
                = $app->translate( "Invalid filename '[_1]'", $uploaded );
            return $app->load_tmpl( 'dialog/restore_upload.tmpl', $param );
        }
        $uploaded
            = Encode::is_utf8($uploaded)
            ? $uploaded
            : Encode::decode( $app->charset, $uploaded );
    }
    if ( defined($uploaded) ) {
        if ( $current ne $uploaded ) {
            close $fh if $uploaded;
            $param->{error}
                = $app->translate( 'Please upload [_1] in this page.',
                $current );
            return $app->load_tmpl( 'dialog/restore_upload.tmpl', $param );
        }
    }

    if ( !$fh ) {
        $param->{error} = $app->translate('File was not uploaded.')
            if !( $app->param('redirect') );
        return $app->load_tmpl( 'dialog/restore_upload.tmpl', $param );
    }

    $app->{no_print_body} = 1;

    local $| = 1;
    $app->send_http_header('text/html');

    $app->print_encode(
        $app->build_page( 'dialog/restore_start.tmpl', $param ) );

    if ( $objects_json ) {
        my $objects_tmp = JSON::from_json($objects_json);
        my %class2ids;

        # { MT::CLASS#OLD_ID => NEW_ID }
        for my $key ( keys %$objects_tmp ) {
            my ( $class, $old_id ) = split '#', $key;
            if ( exists $class2ids{$class} ) {
                my $newids = $class2ids{$class}->{newids};
                push @$newids, $objects_tmp->{$key};
                my $keymaps = $class2ids{$class}->{keymaps};
                push @$keymaps,
                    { newid => $objects_tmp->{$key}, oldid => $old_id };
            }
            else {
                $class2ids{$class} = {
                    newids  => [ $objects_tmp->{$key} ],
                    keymaps => [
                        { newid => $objects_tmp->{$key}, oldid => $old_id }
                    ]
                };
            }
        }
        for my $class ( keys %class2ids ) {
            eval "require $class;";
            next if $@;
            my $newids  = $class2ids{$class}->{newids};
            my $keymaps = $class2ids{$class}->{keymaps};
            my @objs    = $class->load( { id => $newids } );
            for my $obj (@objs) {
                my @old_ids = grep { $_->{newid} eq $obj->id } @$keymaps;
                my $old_id = $old_ids[0]->{oldid};
                $objects->{"$class#$old_id"} = $obj;
            }
        }
    }

    my $assets;
    $assets = JSON::from_json( decode_html($assets_json) )
        if ( defined($assets_json) && $assets_json );
    $assets = [] if !defined($assets);
    my $asset;
    my @errors;
    my $error_assets = {};
    require MT::BackupRestore;
    my $blog_ids;
    my $asset_ids;

    if ($is_asset) {
        $asset = shift @$assets;
        $asset->{fh} = $fh;
        my $blogs_meta = JSON::from_json( $app->param('blogs_meta') || '{}' );
        MT::BackupRestore->_restore_asset_multi( $asset, $objects,
            $error_assets, sub { $app->print_encode(@_); }, $blogs_meta );
        if ( defined( $error_assets->{ $asset->{asset_id} } ) ) {
            $app->log(
                {   message => $app->translate('Importing a file failed: ')
                        . $error_assets->{ $asset->{asset_id} },
                    level    => MT::Log::WARNING(),
                    class    => 'system',
                    category => 'restore',
                }
            );
        }
    }
    else {
        ( $blog_ids, $asset_ids ) = eval {
            MT::BackupRestore->restore_process_single_file( $fh, $objects,
                $deferred, \@errors, $schema_version, $overwrite_template,
                sub { _progress( $app, @_ ) } );
        };
        if ($@) {
            $last = 1;
        }
    }

    my @files = split( ',', $files );
    my $file_next;
    $file_next = shift @files if scalar(@files);
    if ( !defined($file_next) ) {
        if ( scalar(@$assets) ) {
            $asset             = $assets->[0];
            $file_next         = $asset->{asset_id} . '-' . $asset->{name};
            $param->{is_asset} = 1;
        }
    }
    $param->{files}  = join( ',', @files );
    $param->{assets} = encode_html( MT::Util::to_json($assets) );
    $param->{name}   = $file_next;
    if ( 0 < scalar(@files) ) {
        $param->{last} = 0;
    }
    elsif ( 0 >= scalar(@$assets) - 1 ) {
        $param->{last} = 1;
    }
    else {
        $param->{last} = 0;
    }
    $param->{is_dirty} = scalar( keys %$deferred );

    if ( $last && defined($blog_ids) && scalar(@$blog_ids) ) {
        $param->{error}     = join( '; ', @errors );
        $param->{next_mode} = 'dialog_adjust_sitepath';
        $param->{blog_ids}  = join( ',', @$blog_ids );
        $param->{asset_ids} = join( ',', @$asset_ids )
            if defined($asset_ids);
    }
    elsif ($last) {
        $param->{restore_end} = 1;
        if ( $param->{is_dirty} ) {
            _log_dirty_restore( $app, $deferred );
            my $log_url = $app->base
                . $app->uri( mode => 'list', args => { '_type' => 'log' } );
            $param->{error}
                = $app->translate(
                'Some objects were not imported because their parent objects were not imported.'
                );
            $param->{error_url} = $log_url;
        }
        elsif ( scalar( keys %$error_assets ) ) {
            $param->{error} = $app->translate(
                'Some of the files were not imported correctly.');
            my $log_url
                = $app->uri( mode => 'list', args => { '_type' => 'log' } );
            $param->{error_url} = $log_url;
        }
        elsif ( scalar @errors ) {
            $param->{error} = join '; ', @errors;
            my $log_url
                = $app->uri( mode => 'list', args => { '_type' => 'log' } );
            $param->{error_url} = $log_url;
        }
        else {
            $app->log(
                {   message => $app->translate(
                        "Successfully imported objects to Movable Type system by user '[_1]'",
                        $app->user->name
                    ),
                    level    => MT::Log::INFO(),
                    class    => 'system',
                    category => 'restore'
                }
            );
            $param->{ok_url}
                = $app->uri( mode => 'start_restore', args => {} );
        }
    }
    else {
        my %objects_json;
        %objects_json = map { $_ => $objects->{$_}->id } keys %$objects;
        $param->{objects_json}  = MT::Util::to_json( \%objects_json );
        $param->{deferred_json} = MT::Util::to_json($deferred);

        $param->{error} = join( '; ', @errors );
        if ( defined($blog_ids) && scalar(@$blog_ids) ) {
            $param->{next_mode} = 'dialog_adjust_sitepath';
            $param->{blog_ids}  = join( ',', @$blog_ids );
            $param->{asset_ids} = join( ',', @$asset_ids )
                if defined($asset_ids);
        }
        else {
            $param->{next_mode} = 'dialog_restore_upload';
        }
    }
    MT->run_callbacks( 'restore', $objects, $deferred, \@errors,
        sub { _progress( $app, @_ ) } );

    $app->print_encode(
        $app->build_page( 'dialog/restore_end.tmpl', $param ) );
    close $fh if $fh;
}

sub dialog_adjust_sitepath {
    my $app  = shift;
    my $user = $app->user;
    return $app->permission_denied()
        if !$user->is_superuser;
    $app->validate_magic() or return;

    $app->validate_param({
        asset_ids      => [qw/MAYBE_IDS/],
        blog_ids       => [qw/IDS/],
        current_file   => [qw/MAYBE_STRING/],
        error          => [qw/MAYBE_STRING/],
        restore_upload => [qw/MAYBE_STRING/],
        tmp_dir        => [qw/MAYBE_STRING/],
    }) or return;

    my $tmp_dir    = $app->param('tmp_dir');
    my $error      = $app->param('error') || q();
    my $uploaded   = $app->param('restore_upload') || 0;
    my @blog_ids   = split ',', $app->param('blog_ids') || '';
    my $asset_ids  = $app->param('asset_ids');
    my $blog_class = $app->model('blog');
    my @blogs      = $blog_class->load( { id => \@blog_ids } );
    my ( @blogs_loop, @website_loop );
    my $param = {};

    foreach my $blog (@blogs) {
        if ( $blog->is_blog() ) {
            my $params = {
                name          => $blog->name,
                id            => $blog->id,
                old_site_path => $blog->column('site_path'),
                $blog->column('archive_path')
                ? ( old_archive_path => $blog->column('archive_path') )
                : (),
                $blog->column('parent_id') ? ( parent_id => $blog->parent_id )
                : (),
            };
            $params->{site_path_absolute} = 1
                if $blog_class->is_site_path_absolute(
                $blog->column('site_path') );
            $params->{archive_path_absolute} = 1
                if exists( $params->{old_archive_path} )
                && $blog_class->is_site_path_absolute(
                $blog->column('archive_path') );
            $params->{old_site_url} = $blog->site_url;
            my @raw_site_url = $blog->raw_site_url;
            if ( 2 == @raw_site_url ) {
                my $subdomain = $raw_site_url[0];
                $subdomain =~ s/\.$//;
                $params->{old_site_url_subdomain} = $subdomain;
                $params->{old_site_url_path}      = $raw_site_url[1];
            }
            $params->{old_archive_url} = $blog->archive_url
                if $blog->column('archive_url');
            my @raw_archive_url = $blog->raw_archive_url;
            if ( 2 == @raw_archive_url ) {
                my $subdomain = $raw_archive_url[0];
                $subdomain =~ s/\.$//;
                $params->{old_archive_url_subdomain} = $subdomain;
                $params->{old_archive_url_path}      = $raw_archive_url[1];
            }
            $param->{enabled_archives} = 1
                if $params->{old_archive_url}
                || $params->{old_archive_url_subdomain}
                || $params->{old_archive_url_path}
                || $params->{old_archive_path};
            push @blogs_loop, $params;
        }
        else {
            my $sitepath = $blog->column('site_path');
            if ( my $limited = $app->config->BaseSitePath ) {
                $limited = File::Spec->catdir( $limited, "PATH" );
                $limited =~ s/PATH$//;
                my $limited_quote = quotemeta($limited);
                if ( $sitepath !~ m/^$limited_quote/i ) {
                    $sitepath = $limited;
                }
            }
            push @website_loop,
                {
                name          => $blog->name,
                id            => $blog->id,
                old_site_path => $sitepath,
                old_site_url  => $blog->column('site_url'),
                };
        }
    }

    # Load all website
    my $iter = MT->model('website')->load_iter();
    my @all_websites;
    while ( my $website = $iter->() ) {
        push @all_websites,
            {
            website_name      => $website->name,
            website_id        => $website->id,
            website_site_path => $website->site_path,
            website_site_url  => $website->site_url,
            };
    }

    $param = { blogs_loop => \@blogs_loop, tmp_dir => $tmp_dir, %$param };
    $param->{error}          = $error         if $error;
    $param->{restore_upload} = $uploaded      if $uploaded;
    $param->{asset_ids}      = $asset_ids     if $asset_ids;
    $param->{website_loop}   = \@website_loop if @website_loop;
    $param->{all_websites}   = \@all_websites if @all_websites;
    $param->{path_separator} = MT::Util->dir_separator;
    if ( my $limit = $app->config->BaseSitePath ) {
        $param->{sitepath_limited} = $limit;
        $limit = File::Spec->catdir( $limit, "PATH" );
        $limit =~ s/PATH$//;
        $param->{sitepath_limited_trail} = $limit;
    }

  # There is a danger that the asset_id list will ballon and make a request
  # URL that is longer then allowed. This function have two ways to be called:
  # 1. As open-dialog command, from the restore window, and with GET
  # 2. a part of dialog chain, from dialog_restore_upload, with POST
  # if this was called using GET, then the asset list will be read from
  # the calling page
    $param->{request_method} = $app->request_method();
    for my $key (
        qw(files assets last redirect is_dirty is_asset objects_json deferred_json)
        )
    {
        $param->{$key} = $app->param($key) if $app->param($key);
    }
    $param->{name}      = $app->param('current_file');
    $param->{screen_id} = "adjust-sitepath";
    $app->load_tmpl( 'dialog/adjust_sitepath.tmpl', $param );
}

sub convert_to_html {
    my $app       = shift;
    my $format    = $app->param('format') || '';
    my @formats   = split /\s*,\s*/, $format;
    my $text      = $app->param('text') || '';
    my $text_more = $app->param('text_more') || '';
    my $result    = {
        text      => $app->apply_text_filters( $text,      \@formats ),
        text_more => $app->apply_text_filters( $text_more, \@formats ),
        format    => $formats[0],
    };
    return $app->json_result($result);
}

sub recover_passwords {
    my $app = shift;
    my @id  = $app->multi_param('id');

    return $app->permission_denied()
        unless $app->user->can_manage_users_groups();

    my $class
        = ref $app eq 'MT::App::Upgrader'
        ? 'MT::BasicAuthor'
        : $app->model('author');
    eval "use $class;";

    my @msg_loop;
    foreach (@id) {
        my $author = $class->load($_)
            or next;
        my ( $rc, $res ) = reset_password( $app, $author );
        push @msg_loop, { message => $res };
    }

    $app->load_tmpl( 'recover_password_result.tmpl',
        { message_loop => \@msg_loop, return_url => $app->return_uri } );
}

sub reset_password {
    my $app = shift;
    my ($author) = @_;

    require MT::Auth;
    require MT::Log;
    if ( !MT::Auth->can_recover_password ) {
        $app->log(
            {   message => $app->translate(
                    "Invalid password recovery attempt; cannot recover password in this configuration"
                ),
                level    => MT::Log::SECURITY(),
                class    => 'system',
                category => 'recover_password',
            }
        );
        return ( 0,
            $app->translate("Cannot recover password in this configuration")
        );
    }

    return ( 0, $app->translate("Invalid request.") )
        unless $author;

    return (
        0,
        $app->translate(
            "User '[_1]' (user #[_2]) does not have email address",
            $author->name, $author->id
        )
    ) unless $author->email;

    # Generate Token
    require MT::Util::Captcha;
    my $salt    = MT::Util::Captcha->_generate_code(8);
    my $expires = time + ( 60 * 60 );
    my $token   = MT::Util::perl_sha1_digest_hex(
        $salt . $expires . $app->config->SecretToken );

    $author->password_reset($salt);
    $author->password_reset_expires($expires);
    $author->password_reset_return_to(undef);
    $author->save;

    my $message
        = $app->translate(
        "A password reset link has been sent to [_3] for user  '[_1]' (user #[_2]).",
        $author->name, $author->id, $author->email );
    $app->log(
        {   message  => $message,
            level    => MT::Log::SECURITY(),
            class    => 'system',
            category => 'recover_password'
        }
    );

    # Send mail to user
    my $email = $author->email;
    my %head  = (
        id      => 'recover_password',
        To      => $email,
        From    => $app->config('EmailAddressMain') || $email,
        Subject => $app->translate("Password Recovery")
    );
    my $charset = $app->charset;
    my $mail_enc = uc( $app->config('MailEncoding') || $charset );
    $head{'Content-Type'} = qq(text/plain; charset="$mail_enc");

    my $body = $app->build_email(
        'recover-password',
        {         link_to_login => $app->base
                . $app->uri
                . "?__mode=new_pw&token=$token&email="
                . encode_url($email),
        }
    );

    require MT::Util::Mail;
    MT::Util::Mail->send_and_log(\%head, $body) or return $app->error($app->translate(
        "Error sending e-mail ([_1]); Please fix the problem, then try again to recover your password.",
        MT::Util::Mail->errstr
    ));

    ( 1, $message );
}

sub restore_file {
    my $app = shift;
    my ( $fh, $errormsg ) = @_;
    my $schema_version = $app->config->SchemaVersion;

    #my $schema_version =
    #  $app->param('ignore_schema_conflict')
    #  ? 'ignore'
    #  : $app->config('SchemaVersion');
    my $overwrite_template
        = $app->param('overwrite_global_templates') ? 1 : 0;

    require MT::BackupRestore;
    my ( $deferred, $blogs )
        = MT::BackupRestore->restore_file( $fh, $errormsg, $schema_version,
        $overwrite_template, sub { _progress( $app, @_ ); } );

    if ( !defined($deferred) || scalar( keys %$deferred ) ) {
        _log_dirty_restore( $app, $deferred );
        my $log_url
            = $app->uri( mode => 'list', args => { '_type' => 'log' } );
        $$errormsg .= '; ' if $$errormsg;
        $$errormsg .= $app->translate(
            'Some objects were not imported because their parent objects were not imported.  Detailed information is in the activity log.',
            $log_url
        );
        return $blogs;
    }
    if ($$errormsg) {
        $app->log(
            {   message  => $$errormsg,
                level    => MT::Log::ERROR(),
                class    => 'system',
                category => 'restore',
            }
        );
        return $blogs;
    }

    $app->log(
        {   message => $app->translate(
                "Successfully imported objects to Movable Type system by user '[_1]'",
                $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'restore'
        }
    );

    $blogs;
}

sub restore_directory {
    my $app = shift;
    my ( $dir, $error ) = @_;

    if ( !-d $dir ) {
        $$error = $app->translate( '[_1] is not a directory.', $dir );
        return ( undef, undef );
    }

    my $schema_version = $app->config->SchemaVersion;

    #my $schema_version =
    #  $app->param('ignore_schema_conflict')
    #  ? 'ignore'
    #  : $app->config('SchemaVersion');

    my $overwrite_template
        = $app->param('overwrite_global_templates') ? 1 : 0;

    my @errors;
    my %error_assets;
    require MT::BackupRestore;
    my ( $deferred, $blogs, $assets )
        = MT::BackupRestore->restore_directory( $dir, \@errors,
        \%error_assets, $schema_version, $overwrite_template,
        sub { _progress( $app, @_ ); } );

    if ( scalar @errors ) {
        $$error = $app->translate('Error occurred during import process.');
        $app->log(
            {   message  => $$error,
                level    => MT::Log::WARNING(),
                class    => 'system',
                category => 'restore',
                metadata => join( '; ', @errors ),
            }
        );
    }

    if ( scalar( keys %error_assets ) ) {
        my $data;
        while ( my ( $key, $value ) = each %error_assets ) {
            $data .= $app->translate( 'MT::Asset#[_1]: ', $key )
                . $value . "\n";
        }
        my $message = $app->translate('Some of files could not be imported.');
        $app->log(
            {   message  => $message,
                level    => MT::Log::WARNING(),
                class    => 'system',
                category => 'restore',
                metadata => $data,
            }
        );
        $$error .= $message;
    }

    if ( scalar( keys %$deferred ) ) {
        _log_dirty_restore( $app, $deferred );
        my $log_url
            = $app->uri( mode => 'list', args => { '_type' => 'log' } );
        $$error = $app->translate(
            'Some objects were not imported because their parent objects were not imported.  Detailed information is in the activity log.',
            $log_url
        );
        return ( $blogs, $assets );
    }

    return ( $blogs, $assets ) if $$error;

    $app->log(
        {   message => $app->translate(
                "Successfully imported objects to Movable Type system by user '[_1]'",
                $app->user->name
            ),
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'restore'
        }
    );
    return ( $blogs, $assets );
}

sub restore_upload_manifest {
    my $app  = shift;
    my ($fh) = @_;
    my $user = $app->user;
    return $app->permission_denied()
        if !$user->is_superuser;
    $app->validate_magic() or return;

    require MT::BackupRestore;
    my $backups = MT::BackupRestore->process_manifest($fh);
    return $app->errtrans(
        "Uploaded file was not a valid Movable Type exported manifest file.")
        if !defined($backups);

    my $files  = $backups->{files};
    my $assets = $backups->{assets};
    my $file_next;
    $file_next = shift @$files if defined($files) && scalar(@$files);
    my $assets_json;
    my $param = {};

    if ( !defined($file_next) ) {
        if ( scalar(@$assets) > 0 ) {
            my $asset = shift @$assets;
            $file_next = $asset->{name};
            $param->{is_asset} = 1;
        }
    }
    $assets_json = encode_url( MT::Util::to_json($assets) )
        if scalar(@$assets) > 0;
    $param->{files}    = join( ',', @$files );
    $param->{assets}   = $assets_json;
    $param->{filename} = $file_next;
    $param->{last}     = scalar(@$files) ? 0 : ( scalar(@$assets) ? 0 : 1 );
    $param->{open_dialog}    = 1;
    $param->{schema_version} = $app->config->SchemaVersion;

    #$param->{schema_version} =
    #  $app->param('ignore_schema_conflict')
    #  ? 'ignore'
    #  : $app->config('SchemaVersion');
    $param->{overwrite_templates}
        = $app->param('overwrite_global_templates') ? 1 : 0;

    $param->{dialog_mode} = 'dialog_restore_upload';
    $param->{dialog_params}
        = 'start=1'
        . '&amp;magic_token='
        . $app->current_magic
        . '&amp;files='
        . $param->{files}
        . '&amp;assets='
        . $param->{assets}
        . '&amp;current_file='
        . $param->{filename}
        . '&amp;last='
        . $param->{'last'}
        . '&amp;schema_version='
        . $param->{schema_version}
        . '&amp;overwrite_templates='
        . $param->{overwrite_templates}
        . '&amp;redirect=1';
    if ( length $param->{dialog_params} > 2083 )
    {    # 2083 is Maximum URL length in IE
        $param->{error} = $app->translate(
            "Manifest file '[_1]' is too large. Please use import directory for importing.",
            $param->{filename}
        );
        $param->{open_dialog} = 0;
        $app->mode('start_restore');
    }
    $app->load_tmpl( 'restore.tmpl', $param );

    #close $fh if $fh;
}

sub _backup_finisher {
    my $app = shift;
    my ( $fnames, $param ) = @_;
    unless ( ref $fnames ) {
        $fnames = [$fnames];
    }
    $param->{filename}       = $fnames->[0];
    $param->{backup_success} = 1
        unless $param->{error};
    require MT::Session;
    MT::Session->remove( { kind => 'BU' } );
    foreach my $fname (@$fnames) {
        my $sess = MT::Session->new;
        $sess->id( $app->make_magic_token() );
        $sess->kind('BU');    # BU == Backup
        $sess->name($fname);
        $sess->start(time);
        $sess->save;
    }
    my $message;
    if ( my $blog_id = $param->{blog_id} || $param->{blog_ids} ) {
        $message = $app->translate(
            "Site(s) (ID:[_1]) was/were successfully exported by user '[_2]'",
            $blog_id, $app->user->name
        );
    }
    else {
        $message
            = $app->translate(
            "Movable Type system was successfully exported by user '[_1]'",
            $app->user->name );
    }
    $app->log(
        {   message  => $message,
            level    => MT::Log::INFO(),
            class    => 'system',
            category => 'restore'
        }
    );
    $app->print_encode(
        $app->build_page( 'include/backup_end.tmpl', $param ) );
}

sub _progress {
    my $app = shift;
    my $ids = $app->request('progress_ids') || {};

    my ( $str, $id ) = @_;
    if ( $id && $ids->{$id} ) {
        my $str_js = encode_js($str);
        $app->print_encode(
            qq{<script type="text/javascript">progress('$str_js', '$id');</script>}
        );
    }
    elsif ($id) {
        $ids->{$id} = 1;
        $app->print_encode(qq{\n<span id="$id">$str</span>});
    }
    else {
        $app->print_encode("<span>$str</span>");
    }

    $app->request( 'progress_ids', $ids );
}

sub _log_dirty_restore {
    my $app = shift;
    my ($deferred) = @_;
    my %deferred_by_class;
    for my $key ( keys %$deferred ) {
        my ( $class, $id ) = split( '#', $key );
        if ( exists $deferred_by_class{$class} ) {
            push @{ $deferred_by_class{$class} }, $id;
        }
        else {
            $deferred_by_class{$class} = [$id];

        }
    }
    while ( my ( $class_name, $ids ) = each %deferred_by_class ) {
        my $message = $app->translate(
            'Some [_1] were not imported because their parent objects were not imported.',
            $class_name
        );
        $app->log(
            {   message  => $message,
                level    => MT::Log::WARNING(),
                class    => 'system',
                category => 'restore',
                metadata => 'ID:' . join( ', ', @$ids ),
            }
        );
    }
    1;
}

sub login_json {
    my $app = shift;
    return $app->json_result( { magic_token => $app->current_magic, } );
}

sub _exists_system_tmpl {
    my ($tmpl) = @_;
    my $set = MT->registry('default_templates');
    my $scope = $tmpl->blog_id ? 'system' : 'global:system';
    return $set->{$scope}{ $tmpl->identifier } ? 1 : 0;
}

sub _call_pre_save_blog {
    my ( $app, $blog, $original ) = @_;
    my @types = ('blog');
    if ( !$blog->is_blog() ) {
        push @types, 'website';
    }
    my $filter_result = 1;
    for my $t (@types) {
        $filter_result &&= $app->run_callbacks( 'cms_pre_save.' . $t, $app, $blog, $original );
    }
    return $filter_result;
}

1;
