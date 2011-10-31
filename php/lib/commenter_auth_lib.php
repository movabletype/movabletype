<?php
# Movable Type (r) Open Source (C) 2001-2011 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

function _auth_icon_url($static_path, $author) {
    $auth_type = $author->author_auth_type;
    if (!$auth_type) {
        return '';
    }

    if ( $author->author_type == 1 ) {
        return $static_path . 'images/comment/mt_logo.png';
    }

    $authenticator = CommenterAuthProviderFactory::get_provider( $auth_type );
    if (!isset($authenticator)) {
        return '';
    }

    $logo = $authenticator->get_logo_small();
    if ( !preg_match("/^https?:\/\//", $logo) || !preg_match("/^\//", $logo) ) {
        $logo = $static_path . $logo;
    }
    return $logo;
}

interface CommenterAuthProvider {
    public function get_key();
    public function get_label();
    public function get_logo();
    public function get_logo_small();
}

class CommenterAuthProviderFactory {
    private static $_commenter_auths = array(
        'LiveJournal' => 'LiveJournalCommenterAuth',
        'OpenID'      => 'OpenIDCommenterAuth',
        'TypeKey'     => 'TypeKeyCommenterAuth',
        'Google'      => 'GoogleCommenterAuth',
        'Yahoo'       => 'YahooCommenterAuth',
        'AIM'         => 'AIMCommenterAuth',
        'WordPress'   => 'WordPressCommenterAuth',
        'YahooJP'     => 'YahooJPCommenterAuth',
        'livedoor'    => 'LivedoorCommenterAuth',
        'Hatena'      => 'HatenaCommenterAuth',
        'Vox'         => 'VoxCommenterAuth',
    );

    private static $_provider = array();

    private function __construct() { }

    public static function get_provider($type) {
        if (empty($type)) {
            require_once('class.exception.php');
            throw new MTException('Illegal commenter auth type');
        }
        if (!array_key_exists($type, CommenterAuthProviderFactory::$_commenter_auths)) {
            require_once('class.exception.php');
            throw new MTException('Undefined commenter auth type. (' . $type . ')');
        }

        $class = CommenterAuthProviderFactory::$_commenter_auths[$type];
        if (!empty($class)) {
            $instance = new $class;
            if (!empty($instance) and $instance instanceof CommenterAuthProvider)
                CommenterAuthProviderFactory::$_provider[$type] = $instance;
        } else {
            CommenterAuthProviderFactory::$_provider[$type] = null;
        }

        return CommenterAuthProviderFactory::$_provider[$type];
    }

    public static function add_provider($type, $class) {
        if (empty($type) or empty($class))
            return null;

        CommenterAuthProviderFactory::$_commenter_auths[$type] = $class;
        return true;
    }
}

class LiveJournalCommenterAuth implements CommenterAuthProvider {
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

class VoxCommenterAuth implements CommenterAuthProvider {
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

class OpenIDCommenterAuth implements CommenterAuthProvider {
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

class TypeKeyCommenterAuth implements CommenterAuthProvider {
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

class GoogleCommenterAuth implements CommenterAuthProvider {
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

class YahooCommenterAuth implements CommenterAuthProvider {
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

class AIMCommenterAuth implements CommenterAuthProvider {
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

class WordPressCommenterAuth implements CommenterAuthProvider {
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

class YahooJPCommenterAuth implements CommenterAuthProvider {
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

class LivedoorCommenterAuth implements CommenterAuthProvider {
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

class HatenaCommenterAuth implements CommenterAuthProvider {
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
