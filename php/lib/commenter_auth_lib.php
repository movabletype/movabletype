<?php
# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
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

function _auth_icon_url($static_path, $author) {
    $auth_type = $author->author_auth_type;
    if (!$auth_type) {
        return '';
    }

    if ( $author->author_type == 1 ) {
        return $static_path . 'images/logo-mark.svg';
    }

    global $_commenter_auths;
    $authenticator = $_commenter_auths[$auth_type];
    if (!isset($authenticator)) {
        return '';
    }

    $logo = $authenticator->get_logo_small();
    if ( !preg_match("/^https?:\/\//", $logo) || !preg_match("/^\//", $logo) ) {
        $logo = $static_path . $logo;
    }
    return $logo;
}

class BaseCommenterAuthProvider {
    // Abstract Method (needs override)
    function get_key() { }
    function get_label() { }
    function get_logo() { }
    function get_logo_small() { }
}

class LiveJournalCommenterAuth extends BaseCommenterAuthProvider {
    function get_key() {
        return 'LiveJournal';
    }
    function get_label() {
        return 'LiveJournal Commenter Authenticator';
    }
    function get_logo() {
        return 'images/comment/signin_livejournal.png';
    }
    function get_logo_small() {
        return 'images/comment/livejournal_logo.png';
    }
}

class VoxCommenterAuth extends BaseCommenterAuthProvider {
    function get_key() {
        return 'Vox';
    }
    function get_label() {
        return 'Vox Commenter Authenticator';
    }
    function get_logo() {
        return 'images/comment/signin_vox.png';
    }
    function get_logo_small() {
        return 'images/comment/vox_logo.png';
    }
}

class OpenIDCommenterAuth extends BaseCommenterAuthProvider {
    function get_key() {
        return 'OpenID';
    }
    function get_label() {
        return 'OpenID Commenter Authenticator';
    }
    function get_logo() {
        return 'images/comment/signin_openid.png';
    }
    function get_logo_small() {
        return 'images/comment/openid_logo.png';
    }
}

class TypeKeyCommenterAuth extends BaseCommenterAuthProvider {
    function get_key() {
        return 'TypeKey';
    }
    function get_label() {
        return 'TypeKey Commenter Authenticator';
    }
    function get_logo() {
        return 'images/comment/signin_typepad.png';
    }
    function get_logo_small() {
        return 'images/comment/typepad_logo.png';
    }
}

class GoogleCommenterAuth extends BaseCommenterAuthProvider {
    function get_key() {
        return 'Google';
    }
    function get_label() {
        return 'Google Commenter Authenticator';
    }
    function get_logo() {
        return 'images/comment/google.png';
    }
    function get_logo_small() {
        return 'images/comment/google_logo.png';
    }
}

class YahooCommenterAuth extends BaseCommenterAuthProvider {
    function get_key() {
        return 'Yahoo';
    }
    function get_label() {
        return 'Yahoo Commenter Authenticator';
    }
    function get_logo() {
        return 'images/comment/yahoo.png';
    }
    function get_logo_small() {
        return 'images/comment/favicon_yahoo.png';
    }
}

class AIMCommenterAuth extends BaseCommenterAuthProvider {
    function get_key() {
        return 'AIM';
    }
    function get_label() {
        return 'AIM Commenter Authenticator';
    }
    function get_logo() {
        return 'images/comment/aim.png';
    }
    function get_logo_small() {
        return 'images/comment/aim_logo.png';
    }
}

class WordPressCommenterAuth extends BaseCommenterAuthProvider {
    function get_key() {
        return 'WordPress';
    }
    function get_label() {
        return 'WordPress Commenter Authenticator';
    }
    function get_logo() {
        return 'images/comment/wordpress.png';
    }
    function get_logo_small() {
        return 'images/comment/wordpress_logo.png';
    }
}

class YahooJPCommenterAuth extends BaseCommenterAuthProvider {
    function get_key() {
        return 'YahooJP';
    }
    function get_label() {
        return 'Yahoo Japan Commenter Authenticator';
    }
    function get_logo() {
        return 'images/comment/yahoo.png';
    }
    function get_logo_small() {
        return 'images/comment/favicon_yahoo.png';
    }
}

class LivedoorCommenterAuth extends BaseCommenterAuthProvider {
    function get_key() {
        return 'livedoor';
    }
    function get_label() {
        return 'livedoor Commenter Authenticator';
    }
    function get_logo() {
        return 'images/comment/signin_livedoor.png';
    }
    function get_logo_small() {
        return 'images/comment/livedoor_logo.png';
    }
}

class HatenaCommenterAuth extends BaseCommenterAuthProvider {
    function get_key() {
        return 'Hatena';
    }
    function get_label() {
        return 'Hatena Commenter Authenticator';
    }
    function get_logo() {
        return 'images/comment/signin_hatena.png';
    }
    function get_logo_small() {
        return 'images/comment/hatena_logo.png';
    }
}

?>
