# Movable Type (r) Open Source (C) 2001-2010 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

package MT::Auth::TypeKey;
use strict;

use MT::Util qw( decode_url is_valid_email escape_unicode );

sub password_exists { 0 }

sub handle_sign_in {
    my $class = shift;
    my ($app, $auth_type) = @_;
    my $q = $app->param;

    my $sig_str = $q->param('sig');
    unless ($sig_str) {
        $app->error($app->translate('Sign in requires a secure signature.'));
        return 0;
    }

    my $entry_id = $q->param('entry_id');
    my $entry = MT::Entry->load($entry_id)
        or return 0;
    my $blog = MT::Blog->load($q->param('blog_id') || $entry->blog_id)
        or return 0;

    my $ts = $q->param('ts') || "";
    my $email = $q->param('email') || "";
    my $name = $q->param('name') || "";
    my $nick = $q->param('nick') || "";
    my $cmntr;
    my $session;

    if (!$class->_validate_signature($app, $sig_str, 
                                   token => $blog->effective_remote_auth_token,
                                   email => decode_url($email),
                                   name => decode_url($name),
                                   nick => decode_url($nick),
                                   ts => $ts))
    {
        # Signature didn't match, or timestamp was out of date.
        # This implies tampering, not a user mistake.
        $app->error($app->translate("The sign-in validation failed."));
        return 0;
    }

    if ($blog->require_typekey_emails && !is_valid_email($email)) {
        $q->param('email', '');  # blank out email address since it's invalid
        $app->error($app->translate("This weblog requires commenters to pass an email address. If you'd like to do so you may log in again, and give the authentication service permission to pass your email address."));
        return 0;
    }

    my $url = $app->config('IdentityURL');
    $url .= "/" unless $url =~ m|/$|;
    $url .= $name;

    # Signature was valid, so create a session, etc.
    $cmntr = $app->make_commenter(
        email => $email,
        nickname => $nick,
        name => $name,
        url => $url,
        auth_type => $auth_type,
    );
    return 0 unless $cmntr;
    $session = $app->make_commenter_session($cmntr);
    unless ($session) {
        $app->error($app->errstr() || $app->translate("Couldn't save the session"));
        return 0;
    }
    if ($q->param('sig') && !$cmntr) {
        return 0;
    }
    return $cmntr;
}

my $SIG_WINDOW = 60 * 10;  # ten minute handoff between TP and MT

sub _validate_signature {
    my $class = shift;
    my ($app, $sig_str, %params) = @_;

    # the DSA sig parameter is composed of the two pieces of the
    # real DSA sig, packed in Base64, separated by a colon.
    my ($r, $s) = split /:/, $sig_str;
    $r =~ s/ /+/g;
    $s =~ s/ /+/g;

    $params{email} =~ s/ /+/g;
    require MIME::Base64;
    import MIME::Base64 qw(decode_base64);
    use MT::Util qw(bin2dec);
    $r = bin2dec(decode_base64($r));
    $s = bin2dec(decode_base64($s));

    my $sig = {'s' => $s,
               'r' => $r};
    my $timer = time;
    require MT::Util; import MT::Util ('dsa_verify');
    my $msg;
    if ($app->config('TypeKeyVersion') eq '1.1') {
        $msg = ($params{email} . "::" . $params{name} . "::" .
                $params{nick} . "::" . $params{ts} . "::" . $params{token});
    } else {
        $msg = ($params{email} . "::" . $params{name} . "::" .
                $params{nick} . "::" . $params{ts});
    }

    my $dsa_key;
    require MT::Session;
    $dsa_key = eval { MT::Session->load({id => 'KY',
                                         kind => 'KY'}); } || undef; 
    if ($dsa_key) {
        if ($dsa_key->start() < time - 24 * 60 * 60) {
            $dsa_key = undef;
        }
        $dsa_key = $dsa_key->data if $dsa_key;
    }
    if ( ! $dsa_key ) {
        # Load the override key
        $dsa_key = $app->config->get('SignOnPublicKey');
    }
    # Load the DSA key from the RegKeyURL
    my $key_location = $app->config('RegKeyURL');
    if (!$dsa_key && $key_location) {
        my $ua = $app->new_ua;
        unless ($ua) {
            my $err = $app->translate("Couldn't get public key from url provided");
            $app->log({
                message => $err,
                level => MT::Log::ERROR(),
                class => 'system',
                category => 'commenter_authentication',
            });
            return $app->error($err);
        }
        my $req = new HTTP::Request(GET => $key_location);
        my $resp = $ua->request($req);
        unless ($resp->is_success()) {
            my $err = $app->translate("Couldn't get public key from url provided");
            $app->log({
                message => $err,
                level => MT::Log::ERROR(),
                class => 'system',
                category => 'commenter_authentication',
            });
            return $app->error($err);
        }
        # TBD: Check the content-type
        $dsa_key = $resp->content();

        require MT::Session;
        my $key_cache = new MT::Session();

        my @chs = ('a' .. 'z', '0' .. '9');
        $key_cache->set_values({id => 'KY',
                                data => $dsa_key,
                                kind => 'KY',
                                start => time});
        $key_cache->save();
    }
    if (!$dsa_key) {
        $app->log({
            message => $app->translate("No public key could be found to validate registration."),
            level => MT::Log::ERROR(),
            class => 'system',
            category => 'commenter_authentication',
        });
        return $app->error($app->translate(
                    "No public key could be found to validate registration."));
    }
    my ($p) = $dsa_key =~ /p=([0-9a-f]*)/i;
    my ($q) = $dsa_key =~ /q=([0-9a-f]*)/i;
    my ($g) = $dsa_key =~ /g=([0-9a-f]*)/i;
    my ($pub_key) = $dsa_key =~ /pub_key=([0-9a-f]*)/i;
    $dsa_key = {p=>$p, q=>$q, g=>$g, pub_key=>$pub_key};
    my $valid = dsa_verify(Key => $dsa_key,
                           Signature => $sig,
                           Message => $msg);
    $timer = time - $timer;

    $app->log({
        message => $app->translate("TypePad signature verif'n returned [_1] in [_2] seconds verifying [_3] with [_4]",
            ($valid ? "VALID" : "INVALID"), $timer, $msg, $sig_str),
        class => 'system',
        category => 'commenter_authentication',
        level => MT::Log::WARNING(),
    }) unless $valid;

    $app->log({
        message => $app->translate("The TypePad signature is out of date ([_1] seconds old). Ensure that your server's clock is correct", ($params{ts} - time)),
        class => 'system',
        category => 'commenter_authentication',
        level => MT::Log::WARNING(),
    }) unless ($params{ts} + $SIG_WINDOW >= time);

    return ($valid && $params{ts} + $SIG_WINDOW >= time);
}

1;
