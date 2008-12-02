package MT::Auth::GoogleOpenId;

use strict;
use base qw( MT::Auth::OpenID );

# TODO: remove these once core code supports SREG - BugID:71011
sub NS_OPENID_AX { "http://openid.net/srv/ax/1.0" }

sub login {
    my $class = shift;
    my ($app) = @_;
    my $q = $app->{query};
    return $app->errtrans("Invalid request.")
        unless $q->param('blog_id');
    my $blog = MT::Blog->load(scalar $q->param('blog_id'));
    my %param = $app->param_hash;
    my $csr = _get_csr(\%param, $blog) or return;
    my $identity = $q->param('openid_url');
    if (!$identity &&
        (my $u = $q->param('openid_userid')) && $class->can('url_for_userid')) {
        $identity = $class->url_for_userid($u);
    }
    my $claimed_identity = $csr->claimed_identity($identity);
    if (!$claimed_identity) {
        my ($err_code, $err_msg) = ($csr->errcode, $csr->errtext);
        if ($err_code eq 'no_head_tag' || $err_code eq 'no_identity_server' || $err_code eq 'url_gone') {
            $err_msg = $app->translate('The address entered does not appear to be an OpenID');
        }
        elsif ($err_code eq 'empty_url' || $err_code eq 'bogus_url') {
            $err_msg = $app->translate('The text entered does not appear to be a web address');
        }
        elsif ($err_code eq 'url_fetch_error') {
            $err_msg =~ s{ \A Error \s fetching \s URL: \s }{}xms;
            $err_msg = $app->translate('Unable to connect to [_1]: [_2]', $identity, $err_msg);
        }
        return $app->error($app->translate("Could not verify the OpenID provided: [_1]", $err_msg));
    }

    my %params = $class->check_url_params( $app, $blog );

    $claimed_identity->set_extension_args(NS_OPENID_AX(), {
        'mode' => 'fetch_request',
        'required' => 'email',
        'type.email' => 'http://schema.openid.net/contact/email',
    });

    my $check_url = $claimed_identity->check_url(
        ( %params, delayed_return => 1 )
    );

    return $app->redirect($check_url);
}

sub _get_ua {
    my $ua = MT->new_ua( { paranoid => 1 } );
    delete $ua->{max_size};
    return $ua;
}

sub _get_csr {
    my ($params, $blog) = @_;
    my $secret = MT->config->SecretToken;
    my $ua = _get_ua() or return;
    require Net::OpenID::Consumer;
    Net::OpenID::Consumer->new(
        ua => $ua,
        args => $params,
        consumer_secret => $secret,
    );
}

# FIXME: The only change from the super class method was
# where this fetches email from AX attribute.
# FogBugz Case #82894
sub handle_sign_in {
    my $class = shift;
    my ($app, $auth_type) = @_;
    my $q = $app->{query};
    my $INTERVAL = 60 * 60 * 24 * 7;

    $auth_type ||= 'OpenID';

    my $blog = MT::Blog->load($q->param('blog_id'));

    my $cmntr;
    my $session;

    my %param = $app->param_hash;
    my $csr = _get_csr(\%param, $blog) or return 0;

    if(my $setup_url = $csr->user_setup_url( post_grant => 'return' )) {
        return $app->redirect($setup_url);
    } elsif(my $vident = $csr->verified_identity) {
        my $name = $vident->url;
        $cmntr = $app->model('author')->load(
            {
                name => $name,
                type => MT::Author::COMMENTER(),
                auth_type => $auth_type,
            }
        );
        my $nick;
        if ( $cmntr ) {
            if ( ( $cmntr->modified_on
                && ( ts2epoch($blog, $cmntr->modified_on) > time - $INTERVAL ) )
              || ( $cmntr->created_on
                && ( ts2epoch($blog, $cmntr->created_on) > time - $INTERVAL ) ) )
            {
                $nick = $cmntr->nickname;
            }
            else {
                $nick = $class->get_nickname($vident);
                $cmntr->nickname($nick);
                $cmntr->save or return 0;
            }
        }
        else {
            $nick = $class->get_nickname($vident);
            $cmntr = $app->_make_commenter(
                email       => $class->get_email($vident),
                nickname    => $nick,
                name        => $name,
                url         => $vident->url,
                auth_type   => $auth_type,
                external_id => MT::Auth::OpenID::_url_hash($vident->url),
            );
        }
        return 0 unless $cmntr;

        $nick = $name unless $nick;

        # Signature was valid, so create a session, etc.
        $session = $app->make_commenter_session($cmntr);
        unless ($session) {
            $app->error($app->errstr() || $app->translate("Couldn't save the session"));
            return 0;
        }

        if (my $userpic = $cmntr->userpic) {
            my @stat = stat($userpic->file_path());
            my $mtime = $stat[9];
            if ( $mtime > time - $INTERVAL ) {
                # newer than 7 days ago, don't download the userpic
                return $cmntr;
            }
        }

        if ( my $userpic = $class->get_userpicasset($vident) ) {
            $userpic->tags('@userpic');
            $userpic->created_by($cmntr->id);
            $userpic->save;
            if (my $userpic = $cmntr->userpic) {
                # Remove the old userpic thumb so the new userpic's will be generated
                # in its place.
                my $thumb_file = $cmntr->userpic_file();
                my $fmgr = MT::FileMgr->new('Local');
                if ($fmgr->exists($thumb_file)) {
                    $fmgr->delete($thumb_file);
                }

                $userpic->remove;
            }
            $cmntr->userpic_asset_id($userpic->id);
            $cmntr->save;
        }
    } else {
        # If there's no signature, then we trust the cookie.
        my %cookies = $app->cookies();
        my $cookie_name = MT::App::COMMENTER_COOKIE_NAME();
        if ($cookies{$cookie_name}
            && ($session = $cookies{$cookie_name}->value())) 
        {
            require MT::Session;
            require MT::Author;
            my $sess = MT::Session->load({id => $session});
            if ($sess) {
                $cmntr = MT::Author->load({name => $sess->name,
                                           type => MT::Author::COMMENTER(),
                                           auth_type => $auth_type});
            }
        }
    }
    unless ($cmntr) {
        return 0;
    }
    return $cmntr;
}

sub get_nickname {
    my $class = shift;
    my $email = $class->get_email(@_);
    if ( $email =~ /^(.+)\@gmail\.com$/ ) {
        return $1;
    }
    $class->SUPER::get_nickname(@_);    
}

sub get_email {
    my $class = shift;
    my ($vident) = @_;

    # Try AX extension first
    my $fields = $vident->extension_fields(NS_OPENID_AX());
    my $email = $fields->{'value.email'} if exists $fields->{'value.email'};
    return $email if defined $email;
    return q();
}

1;
__END__
