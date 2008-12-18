<?php
# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

global $_commenter_auths;
$provider = new OpenIDCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;
$provider = new VoxCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;
$provider = new LiveJournalCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;
$provider = new TypeKeyCommenterAuth();
$_commenter_auths[$provider->get_key()] = $provider;

function _auth_icon_url($static_path, $author) {
    $auth_type = $author["author_auth_type"];
    if (!$auth_type) {
        return '';
    }

    if ( $author["author_type"] == 1 ) {
        return $static_path . 'images/comment/mt_logo.png';
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

?>
