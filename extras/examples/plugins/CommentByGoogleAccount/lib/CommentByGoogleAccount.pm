# Movable Type (r) Open Source (C) 2001-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# CommentByGoogleAccount plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic and GPLv2 License

package CommentByGoogleAccount;
use strict;

use base qw(MT::ErrorHandler);
use MT::Util qw( escape_unicode );
use MT::I18N qw( encode_text );

## Google does not give third party applications access to these data...
my $nick = 'I am Google';
my $email = q();
my $url = 'http://www.google.com/';
my $name = $nick;

sub handle_sign_in {
    my $class = shift;
    my ($app, $auth_type) = @_;
    my $q = $app->{query};
    
    my $sys_config = MT::Plugin::CommentByGoogleAccount->instance->get_config_hash;
    my $nick = $sys_config->{google_commenter_nickname} || 'Google Account';

    my $cmntr;
    my $session;

    if ($q->param('token')) {
        # Redirected == Authenticated in Google Account API.

        my $enc = $app->{cfg}->PublishCharset || '';
        my $nick_escaped = escape_unicode($nick);
        $nick = encode_text($nick, 'utf-8', undef);
        $cmntr = $app->_make_commenter(
            email => $email,
            nickname => $nick,
            name => $name,
            url => $url,
            auth_type => $auth_type,
        );

        $session = $app->make_commenter_session($cmntr);
        unless ($session) {
            $app->error($app->errstr() || $app->translate("Couldn't save the session"));
            return 0;
        }
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
                                       type => MT::Author::COMMENTER()});
        }
    }
    if ($q->param('token') && !$cmntr) {
        return 0;
    }
    return $cmntr;
}
