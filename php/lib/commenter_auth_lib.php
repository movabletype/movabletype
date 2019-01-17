<?php
# Movable Type (r) (C) 2001-2019 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

# Do not remove providers when they are disabled,
# because the output of MT tags should keep same.
global $_commenter_auths;
$provider = new OpenIDCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;
$provider = new VoxCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;
$provider = new LiveJournalCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;
$provider = new TypeKeyCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;
$provider = new GoogleCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;
$provider = new YahooCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;
$provider = new AIMCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;
$provider = new WordPressCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;
$provider = new YahooJPCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;
$provider = new LivedoorCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;
$provider = new HatenaCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;

function _auth_icon_url($static_path, $author)
{
    $auth_type = $author->author_auth_type;
    if (!$auth_type) {
        return '';
    }

    if ($author->author_type == 1) {
        return $static_path . 'images/logo-mark.svg';
    }

    global $_commenter_auths;
    $authenticator = $_commenter_auths[$auth_type];
    if (!isset($authenticator)) {
        return '';
    }

    $logo = $authenticator->get_logo_small();
    if (!preg_match("/^https?:\/\//", $logo) || !preg_match("/^\//", $logo)) {
        $logo = $static_path . $logo;
    }
    return $logo;
}

class BaseCommenterAuthProvider
{
    // Abstract Method (needs override)
    public function get_key()
    {
    }
    public function get_label()
    {
    }
    public function get_logo()
    {
    }
    public function get_logo_small()
    {
    }
}

class LiveJournalCommenterAuth extends BaseCommenterAuthProvider
{
    public function get_key()
    {
        return 'LiveJournal';
    }
    public function get_label()
    {
        return 'LiveJournal Commenter Authenticator';
    }
    public function get_logo()
    {
        return 'images/comment/signin_livejournal.png';
    }
    public function get_logo_small()
    {
        return 'images/comment/livejournal_logo.png';
    }
}

class VoxCommenterAuth extends BaseCommenterAuthProvider
{
    public function get_key()
    {
        return 'Vox';
    }
    public function get_label()
    {
        return 'Vox Commenter Authenticator';
    }
    public function get_logo()
    {
        return 'images/comment/signin_vox.png';
    }
    public function get_logo_small()
    {
        return 'images/comment/vox_logo.png';
    }
}

class OpenIDCommenterAuth extends BaseCommenterAuthProvider
{
    public function get_key()
    {
        return 'OpenID';
    }
    public function get_label()
    {
        return 'OpenID Commenter Authenticator';
    }
    public function get_logo()
    {
        return 'images/comment/signin_openid.png';
    }
    public function get_logo_small()
    {
        return 'images/comment/openid_logo.png';
    }
}

class TypeKeyCommenterAuth extends BaseCommenterAuthProvider
{
    public function get_key()
    {
        return 'TypeKey';
    }
    public function get_label()
    {
        return 'TypeKey Commenter Authenticator';
    }
    public function get_logo()
    {
        return 'images/comment/signin_typepad.png';
    }
    public function get_logo_small()
    {
        return 'images/comment/typepad_logo.png';
    }
}

class GoogleCommenterAuth extends BaseCommenterAuthProvider
{
    public function get_key()
    {
        return 'Google';
    }
    public function get_label()
    {
        return 'Google Commenter Authenticator';
    }
    public function get_logo()
    {
        return 'images/comment/google.png';
    }
    public function get_logo_small()
    {
        return 'images/comment/google_logo.png';
    }
}

class YahooCommenterAuth extends BaseCommenterAuthProvider
{
    public function get_key()
    {
        return 'Yahoo';
    }
    public function get_label()
    {
        return 'Yahoo Commenter Authenticator';
    }
    public function get_logo()
    {
        return 'images/comment/yahoo.png';
    }
    public function get_logo_small()
    {
        return 'images/comment/favicon_yahoo.png';
    }
}

class AIMCommenterAuth extends BaseCommenterAuthProvider
{
    public function get_key()
    {
        return 'AIM';
    }
    public function get_label()
    {
        return 'AIM Commenter Authenticator';
    }
    public function get_logo()
    {
        return 'images/comment/aim.png';
    }
    public function get_logo_small()
    {
        return 'images/comment/aim_logo.png';
    }
}

class WordPressCommenterAuth extends BaseCommenterAuthProvider
{
    public function get_key()
    {
        return 'WordPress';
    }
    public function get_label()
    {
        return 'WordPress Commenter Authenticator';
    }
    public function get_logo()
    {
        return 'images/comment/wordpress.png';
    }
    public function get_logo_small()
    {
        return 'images/comment/wordpress_logo.png';
    }
}

class YahooJPCommenterAuth extends BaseCommenterAuthProvider
{
    public function get_key()
    {
        return 'YahooJP';
    }
    public function get_label()
    {
        return 'Yahoo Japan Commenter Authenticator';
    }
    public function get_logo()
    {
        return 'images/comment/yahoo.png';
    }
    public function get_logo_small()
    {
        return 'images/comment/favicon_yahoo.png';
    }
}

class LivedoorCommenterAuth extends BaseCommenterAuthProvider
{
    public function get_key()
    {
        return 'livedoor';
    }
    public function get_label()
    {
        return 'livedoor Commenter Authenticator';
    }
    public function get_logo()
    {
        return 'images/comment/signin_livedoor.png';
    }
    public function get_logo_small()
    {
        return 'images/comment/livedoor_logo.png';
    }
}

class HatenaCommenterAuth extends BaseCommenterAuthProvider
{
    public function get_key()
    {
        return 'Hatena';
    }
    public function get_label()
    {
        return 'Hatena Commenter Authenticator';
    }
    public function get_logo()
    {
        return 'images/comment/signin_hatena.png';
    }
    public function get_logo_small()
    {
        return 'images/comment/hatena_logo.png';
    }
}
