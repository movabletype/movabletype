# Copyright 2001-2007 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::Auth::OpenID;
use strict;

use MT::Util qw( decode_url is_valid_email escape_unicode );
use MT::I18N qw( encode_text );

sub login {
    my $class = shift;
    my ($app) = @_;
    my $q = $app->{query};
    return $app->errtrans("Invalid request.")
        unless $q->param('blog_id');
    my $blog = MT::Blog->load(scalar $q->param('blog_id'));
    my %param = $app->param_hash;
    my $csr = _get_csr(\%param, $blog);
    my $identity = $q->param('openid_url');
    if (!$identity &&
        (my $u = $q->param('openid_userid')) && $class->can('url_for_userid')) {
        $identity = $class->url_for_userid($u);
    }
    my $claimed_identity = $csr->claimed_identity($identity)
        or return $app->error($app->translate("Could not discover claimed identity: [_1]", $csr->err));

    my $root = $class->_get_root($blog);
    my $return_to = $app->base . $app->uri . '?__mode=handle_sign_in'
        . '&blog_id=' . $q->param('blog_id')
        . '&static=' . $q->param('static')
        . '&key=' . $q->param('key');
    $return_to .= '&entry_id=' . $q->param('entry_id') if $q->param('entry_id');

    my $check_url = $claimed_identity->check_url(
        return_to => $return_to,
        trust_root => $root,
    );

    return $app->redirect($check_url);
}

sub handle_sign_in {
    my $class = shift;
    my ($app, $auth_type) = @_;
    my $q = $app->{query};

    $auth_type ||= 'OpenID';

    my $blog = MT::Blog->load($q->param('blog_id'));

    my $cmntr;
    my $session;

    my %param = $app->param_hash;
    my $csr = _get_csr(\%param, $blog);

    if(my $setup_url = $csr->user_setup_url( post_grant => 'return' )) {
        return $app->redirect($setup_url);
    } elsif(my $vident = $csr->verified_identity) {
        my $name = $vident->url;
        my $nick = $class->get_nickname($vident);

        # Signature was valid, so create a session, etc.
        my $enc = $app->{cfg}->PublishCharset || '';
        my $nick_escaped = escape_unicode($nick);
        $nick = encode_text($nick, 'utf-8', undef);
        $session = $app->_make_commenter_session($app->make_magic_token, q(),
                                                 $name, $nick_escaped, undef, $name);
        unless ($session) {
            $app->error($app->errstr() || $app->translate("Couldn't save the session"));
            return 0;
        }
        $cmntr = $app->_make_commenter(
            email       => q(),
            nickname    => $nick,
            name        => $name,
            url         => $vident->url,
            auth_type   => $auth_type,
            external_id => _url_hash($vident->url),
        );
    } else {
        # If there's no signature, then we trust the cookie.
        my %cookies = $app->cookies();
        if ($cookies{$app->COMMENTER_COOKIE_NAME()}
            && ($session = $cookies{$app->COMMENTER_COOKIE_NAME()}->value())) 
        {
            require MT::Session;
            require MT::Author;
            my $sess = MT::Session->load({id => $session});
            $cmntr = MT::Author->load({name => $sess->name,
                                       type => MT::Author::COMMENTER(),
                                       auth_type => $auth_type});
        }
    }
    unless ($cmntr) {
        return 0;
    }
    return $cmntr;
}

sub _get_csr {
    my ($params, $blog) = @_;
    my $secret = MT->config->SecretToken;
    my $ua = eval { require LWPx::ParanoidAgent; LWPx::ParanoidAgent->new; };
    unless ($ua) {
        require LWP::UserAgent;
        $ua = LWP::UserAgent->new;
    }
    require Net::OpenID::Consumer;
    Net::OpenID::Consumer->new(
        ua => $ua,
        args => $params,
        consumer_secret => $secret,
    );
}

sub get_nickname {
    my $class = shift;
    my ($vident) = @_;
    _get_nickname(@_);
}

sub _get_nickname {
    my ($vident) = @_;

    my $ua = eval { require LWPx::ParanoidAgent; 1; }
           ? LWPx::ParanoidAgent->new
           : LWP::UserAgent->new
           ;

    ## FOAF
    if(my $foaf_url = $vident->declared_foaf) {
        my $resp = $ua->get($foaf_url);
        if($resp->is_success) {
            my $name;

            require XML::XPath;
            my $xml = XML::XPath->new( xml => $resp->content );
            $xml->set_namespace('RDF', 'http://www.w3.org/1999/02/22-rdf-syntax-ns#');
            $xml->set_namespace('FOAF', 'http://xmlns.com/foaf/0.1/');
            if(my ($name_el) = $xml->findnodes('/RDF:RDF/FOAF:Person/FOAF:name')) {
                $name = $name_el->string_value;
            }
            $xml->cleanup;

            return MT::I18N::utf8_off($name) if $name;
        }
    }

    ## Atom
    if(my $atom_url = $vident->declared_atom) {
        my $resp = $ua->get($atom_url);
        if($resp->is_success) {
            my $name;

            require XML::XPath;
            my $xml = XML::XPath->new( xml => $resp->content );
            if(my ($name_el) = $xml->findnodes('/feed/author/name')) {
                $name = $name_el->string_value;
            }
            $xml->cleanup;
            
            return MT::I18N::utf8_off($name) if $name;
        }
    }

    return $vident->display ? $vident->display : $vident->url;
}

sub _url_hash {
    my ($url) = @_;

    if (eval { require Digest::MD5; 1; }) {
        return Digest::MD5::md5_hex($url);
    }
    return substr $url, 0, 255;
}

sub _get_root {
    my $class = shift;
    my ($blog) = @_;
    my $path = MT->config->CGIPath;
    if ($path =~ m!^/!) {
        # relative path, prepend blog domain
        my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
        $path = $blog_domain . $path;
    }
    $path .= '/' unless $path =~ m!/$!;
    $path;
}

1;
