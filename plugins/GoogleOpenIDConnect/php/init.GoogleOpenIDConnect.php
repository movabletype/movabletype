<?php

require_once('commenter_auth_lib.php');

class GoogleOIDCCommenterAuth extends BaseCommenterAuthProvider {
    function get_key() {
        return 'GoogleOpenIDConnect';
    }
    function get_label() {
        return 'Google OIDC Commenter Authenticator';
    }
    function get_logo() {
        return 'images/comment/google.png';
    }
    function get_logo_small() {
        return 'images/comment/google_logo.png';
    }
}

global $_commenter_auths;
$provider = new GoogleOIDCCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;
