# Copyright 2001-2006 Six Apart. This code cannot be redistributed without
# permission from www.sixapart.com.  For more information, consult your
# Movable Type license.
#
# $Id$

package MT::App::Comments;
use strict;

use MT::App;
@MT::App::Comments::ISA = qw( MT::App );

use MT::Comment;
use MT::I18N qw( wrap_text encode_text );
use MT::Util qw( remove_html encode_html decode_url is_valid_email is_valid_url );
use MT::Entry qw(:constants);
use MT::Author qw(:constants);
use MT::JunkFilter qw(:constants);

my $COMMENTER_COOKIE_NAME = "tk_commenter";

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods(
        preview => \&preview,
        post => \&post,
        view => \&view,
        handle_sign_in => \&handle_sign_in,
        cmtr_name_js => \&commenter_name_js,
        red => \&do_red,
    );
    $app;
}

sub init_request {
    my $app = shift;
    $app->SUPER::init_request(@_);

    $app->{default_mode} = 'view';
    my $q = $app->param;

    ## We don't really have a __mode parameter, because we have to
    ## use named submit buttons for Preview and Post. So we hack it.
    if ($q->param('post') || $q->param('post_x') ||
        $q->param('post.x')) {
        $app->mode('post');
    } elsif ($q->param('preview') || $q->param('preview_x') ||
        $q->param('preview.x')) {
        $app->mode('preview');
    }
}

#
# $app->_get_commenter_session()
#
# Creates a commenter record based on the cookies in the $app, if
# one already exists corresponding to the browser's session.
#
# Returns a pair ($session_key, $commenter) where $session_key is the
# key to the MT::Session object (as well as the cookie value) and
# $commenter is an MT::Author record. Both values are undef when no
# session is active.
#
sub _get_commenter_session {
    my $app = shift;
    my $q = $app->{query};
    
    my $session_key;
    
    my %cookies = $app->cookies();
    if (!$cookies{$COMMENTER_COOKIE_NAME}) {
        return (undef, undef);
    }
    $session_key = $cookies{$COMMENTER_COOKIE_NAME}->value() || "";
    $session_key =~ y/+/ /;
    require MT::Session;
    my $sess_obj = MT::Session->load({ id => $session_key });
    my $timeout = $app->{cfg}->CommentSessionTimeout;
    if (!$sess_obj || ($sess_obj->start() + $timeout < time)
         || ($q->param('email') && ($sess_obj->email ne $q->param('email')))
         || ($q->param('author') && ($sess_obj->name ne $q->param('author'))))
    {
        $session_key = undef;
        
        # blotto the cookie
        my %dead_kookee = (-name => $COMMENTER_COOKIE_NAME,
                           -value => '',
                           -path => '/',
                           -expires => '-10y');
        $app->bake_cookie(%dead_kookee);
        my %dead_name_kookee = (-name => "commenter_name",
                                -value => '',
                                -path => '/',
                                -expires => '-10y');
        $app->bake_cookie(%dead_name_kookee);
        $sess_obj->remove() if ($sess_obj);
        $sess_obj = undef;
        return (undef, undef);
    } else {
        # session is valid!
        return ($session_key, MT::Author->load({name => $sess_obj->name,
                                                type=>MT::Author::COMMENTER}));
    }
}

sub do_red {
    my $app = shift;
    my $q = $app->{query};
    my $id = $q->param('id') or return $app->error($app->translate("No id"));
    my $comment = MT::Comment->load($id)
        or return $app->error($app->translate("No such comment"));
    return $app->error($app->translate("No such comment"))
        unless ($comment->visible);
    my $uri = encode_html($comment->url);
    return <<HTML;
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html><head><title>Redirecting...</title>
<meta name="robots" content="noindex, nofollow">
<script type="text/javascript">
window.onload = function() { document.location = '$uri'; };
</script></head>
<body>
<p><a href="$uri">Click here</a> if you are not redirected</p>
</body>
</html>
HTML
}

# _builtin_throttle is the builtin throttling code
# others can be added by plugins
# a filtering callback must return true or false; true
#    means OK, false means filter it out.
sub _builtin_throttle {
    my $eh = shift;
    my $app = shift;
    my ($entry) = @_;

    my $throttle_period = $app->{cfg}->ThrottleSeconds;
    my $user_ip = $app->remote_ip;
    return 1 if ($throttle_period <= 0);    # Disabled by ThrottleSeconds 0

    require MT::Util;
    my @ts = MT::Util::offset_time_list(time - $throttle_period,
                                        $entry->blog_id);
    my $from = sprintf("%04d%02d%02d%02d%02d%02d",
                       $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0]);
    require MT::Comment;
    
    if (MT::Comment->count({ ip => $user_ip,
                             created_on => [$from],
                             blog_id => $entry->blog_id},
                           {range => {created_on => 1} }))
    {
        return 0;                          # Put a collar on that puppy.
    }
    @ts = MT::Util::offset_time_list(time - $throttle_period * 10 - 1,
                                     $entry->blog_id);
    $from = sprintf("%04d%02d%02d%02d%02d%02d",
                    $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0]);
    my $count =  MT::Comment->count({ ip => $user_ip,
                                      created_on => [$from],
                                      blog_id => $entry->blog_id },
                                    { range => {created_on => 1} });
    if ($count >= 8)
    {
        require MT::IPBanList;
        my $ipban = MT::IPBanList->new();
        $ipban->blog_id($entry->blog_id);
        $ipban->ip($user_ip);
        $ipban->save();
        $ipban->commit();
        $app->log({
            message => $app->translate("IP [_1] banned because comment rate exceeded 8 comments in [_2] seconds.", $user_ip, 10 * $throttle_period ),
            class => 'comment',
            category => 'ip_ban',
            blog_id => $entry->blog_id,
            level => MT::Log::INFO(),
            metadata => $user_ip,
        });
        require MT::Mail;
        my $author = $entry->author;
        $app->set_language($author->preferred_language)
            if $author && $author->preferred_language;
        
        my $blog = MT::Blog->load($entry->blog_id);
        if ($author && $author->email) {
            my %head = ( To => $author->email,
                         From => $app->{cfg}->EmailAddressMain,
                         Subject =>
                             '[' . $blog->name . '] ' .
                         $app->translate("IP Banned Due to Excessive Comments"));
            my $charset = $app->{cfg}->MailEncoding || $app->{cfg}->PublishCharset;
            $head{'Content-Type'} = qq(text/plain; charset="$charset");
            my $body = $app->translate('_THROTTLED_COMMENT_EMAIL',
                                       $blog->name, 10 * $throttle_period,
                                       $user_ip, $user_ip);
            $body = wrap_text($body, 72);
            MT::Mail->send(\%head, $body);
        }
        return 0;
    }
    return 1;
}

sub post {
    my $app = shift;
    my $q = $app->{query};

    return $app->error($app->translate("Invalid request"))
        if $app->request_method() ne 'POST';

    my $entry_id = $q->param('entry_id')
        or return $app->error($app->translate("No entry_id"));
    require MT::Entry;
    my $entry = MT::Entry->load($entry_id)
        or return $app->error($app->translate(
            "No such entry '[_1]'.", scalar $q->param('entry_id')));
    return $app->error($app->translate(
                       "No such entry '[_1]'.", scalar $q->param('entry_id')))
        if $entry->status != RELEASE;

    require MT::IPBanList;
    my $iter = MT::IPBanList->load_iter({ blog_id => $entry->blog_id });
    while (my $ban = $iter->()) {
        my $banned_ip = $ban->ip;
        if ($app->remote_ip =~ /$banned_ip/) {
            return $app->handle_error($app->translate(
                                      "You are not allowed to post comments."));
        }
    }

    MT->add_callback('CommentThrottleFilter', 1, undef,
                     \&MT::App::Comments::_builtin_throttle);

    # Run all the Comment-throttling callbacks
    my $passed_filter = MT->run_callbacks('CommentThrottleFilter',
                                          $app, $entry);

    $passed_filter ||
        return $app->handle_error($app->translate("_THROTTLED_COMMENT"),
                                  "403 Throttled");

    my $cfg = $app->{cfg};
    if (my $state = $q->param('comment_state')) {
        require MT::Serialize;
        my $ser = MT::Serialize->new($cfg->Serializer);
        $state = $ser->unserialize(pack 'H*', $state);
        $state = $$state;
        for my $f (keys %$state) {
            $q->param($f, $state->{$f});
        }
    }
    unless ($cfg->AllowComments && $entry->allow_comments eq '1') {
        return $app->handle_error($app->translate(
            "Comments are not allowed on this entry."));
    }

    require MT::Blog;
    my $blog = MT::Blog->load($entry->blog_id);

    my $text = $q->param('text') || '';
    $text =~ s/^\s+|\s+$//g;
    if ($text eq '') {
       return $app->handle_error($app->translate("Comment text is required."));
    } 

    my ($comment, $commenter) = _make_comment($app, $entry);
    my $remember = $q->param('bakecookie') || 0;
    $remember = 0 if $remember eq 'Forget Info'; # another value for '0'
    if ($commenter && $remember) {
        $app->_extend_commenter_session(Duration => "+1y");
    }
    if (!$blog->allow_unreg_comments) {
        if (!$commenter) {
            return $app->handle_error($app->translate(
                                      "Registration is required."))
        }
    }
    if ($blog->require_comment_emails() && 
        !($comment->author && $comment->email && 
          is_valid_email($comment->email)))
    {
        return $app->handle_error($app->translate(
                           "Name and email address are required."));
    }
    if ($blog->allow_unreg_comments()) {
        $comment->email($q->param('email')) unless $comment->email();
    }
    if ($comment->email) {
        if (my $fixed = is_valid_email($comment->email)) {
            $comment->email($fixed);
        } elsif ($comment->email =~ /^[0-9A-F]{40}$/i) {
            # It's a FOAF-style mbox hash; accept it if blog config says to.
            return $app->handle_error("A real email address is required")
                if ($blog->require_comment_emails());
        } else {
            return $app->handle_error($app->translate(
                "Invalid email address '[_1]'", $comment->email));
        }
    }
    if ($comment->url) {
        if (my $fixed = is_valid_url($comment->url, 'stringent')) {
            $comment->url($fixed);
        } else {
            return $app->handle_error($app->translate(
                "Invalid URL '[_1]'", $comment->url));
        }
    }

    $comment = $app->eval_comment($blog, $commenter, $comment, $entry);
    return $app->preview('pending') unless $comment;

    $comment->save or $app->log({
        message => $app->translate("Comment save failed with [_1]",
                              $comment->errstr),
        blog_id => $blog->id,
        class => 'comment',
        level => MT::Log::ERROR()
    });
    if ($comment->id && !$comment->is_junk) {
        $app->log({
            message => $app->translate("New comment for entry #[_1] '[_2]'.", $entry->id, $entry->title),
            class => 'comment',
            category => 'new',
            blog_id => $blog->id,
            metadata => $comment->id,
        });
    }
    if ($commenter) {
        $commenter->url($comment->url) if $comment->url;
        $commenter->save or $app->log({
            message => $app->translate("Commenter save failed with [_1]",
                                    $commenter->errstr),
            class => 'system',
            blog_id => $blog->id,
            level => MT::Log::ERROR()
        });
    }

#    return $app->handle_error($app->errstr()) unless $comment;

    # Form a link to the comment
    my $comment_link;
    if (!$q->param('static')) {
        my $url = $app->base . $app->uri;
        $url .= '?entry_id=' . $q->param('entry_id');
        $url .= '&static=0&arch=1' if ($q->param('arch'));
        $comment_link = $url;
    } else {
        my $static = $q->param('static');
        if ($static eq '1') {
            # I think what we really want is the individual archive.
            $comment_link = $entry->permalink;
        } else {
            $comment_link = $static . '#' . $comment->id;
        }
    }

    if ($comment->visible) {
        # Rebuild the entry synchronously so that if the user gets
        # redirected to the indiv. page it will be up-to-date.
        $app->rebuild_entry( Entry => $entry->id )
            or return $app->error($app->translate(
                                  "Rebuild failed: [_1]", $app->errstr));
    }

    if ($comment->is_junk) {
        $app->run_tasks('JunkExpiration');
        return $app->preview('pending');
    }
    if (!$comment->visible) {
        $app->_send_comment_notification($comment, $comment_link,
                                         $entry, $blog, $commenter);
        return $app->preview('pending');
    }

    # Index rebuilds and notifications are done in the background.
    MT::Util::start_background_task(sub {
        $app->rebuild_indexes( Blog => $blog )
            or return $app->errtrans("Rebuild failed: [_1]",
                                     $app->errstr);
        $app->_send_comment_notification($comment, $comment_link,
                                         $entry, $blog, $commenter);
        _expire_sessions($cfg->CommentSessionTimeout)
    });
    return $app->redirect($comment_link);
}

sub eval_comment {
    my $app = shift;
    my ($blog, $commenter, $comment, $entry) = @_;

    if ($commenter && $commenter->status($blog->id) == MT::Author::BLOCKED) {
        return undef;
    }

    # Before saving this comment, check whether this commenter has
    # placed any other comments on the entry's author's other entries.
    # (on any other entries by the same author as this one)

    my $commenter_has_comment = _commenter_has_comment($commenter, $entry);

    my $commenter_status;
    if ($commenter) {
        $commenter_status = $commenter->status($entry->blog_id);
        if ($commenter_status == APPROVED) {
            if ($blog->publish_trusted_commenters) {
                $comment->approve;
                return $comment;
            } else {
                $comment->moderate;
                return $comment;
            }
        }
        if ($commenter_status == PENDING) {
            # just in case record doesn't exist...
            $commenter->pending($entry->blog_id);
        } 
        if ($commenter_status == BANNED) {
            return undef;
        }
    }

    my $not_declined = MT->run_callbacks('CommentFilter', $app, $comment);
    return unless $not_declined;

    MT::JunkFilter->filter($comment);

    ## Here comes the built-in logic for deciding whether the
    ## comment is moderated or published.

    # from here to #mark should set "visible" no matter what
    if ($comment->is_junk) {
        $comment->visible(0); # forcibly set to unpublished
    } elsif (!defined $comment->visible) {
        if ($commenter) {
            if ($blog->publish_authd_untrusted_commenters) {
                $comment->approve;
            } else {
                $comment->moderate;
            }
        } else {
            # We don't have a commenter object, but the user wasn't booted
            # so unless moderation is on, we can publish the comment.
            if ($blog->publish_unauthd_commenters) {
                $comment->approve;
            } else {
                $comment->moderate;
            }
        }
    }
    #mark

    $comment;
}

# only handles Duration => +xxxu where u is one of y, d, s
sub _extend_commenter_session {
    my $app = shift;
    my %param = @_;
    my %cookies = $app->cookies();
    my $session_key = $cookies{$COMMENTER_COOKIE_NAME}->value() || "";
    $session_key =~ y/+/ /;
    my $sessobj = MT::Session->load($session_key);
    return if !$sessobj; # no point changing the cookie if the session's already lost.
    my ($sign, $number, $units) = $param{Duration} =~ /([+-]?)(\d+)(\w+)/;
    $number *= $sign eq '-' ? -1 : +1;
    $number *= $units eq 'y' ? 60 * 60 * 24 * 365 : 
        $units eq 'd' ? 60 * 60 * 24 : $number;
    $sessobj->start($sessobj->start + $number);
    $sessobj->save();
    my %sess_cookie = (-name => $COMMENTER_COOKIE_NAME,
                       -value => $session_key,
                       -path => '/',
                       -expires => "+${number}s");
    $app->bake_cookie(%sess_cookie);
    my %name_kookee = (-name => "commenter_name",
                       -value => $cookies{commenter_name}->value,
                       -path => '/',
                       -expires => "+${number}s");
    $app->bake_cookie(%name_kookee);
    1;
}

#
# $app->_make_comment($entry)
#
# _make_comment creates an MT::Comment record attached to the $entry,
# based on the query information in $app (It neeeds the whole app object
# so it can get the user's IP). Also creates an MT::Author record
# representing the person who placed the comment, if necessary.
#
# Always returns a pair ($comment, $commenter). The latter is undef if
# there is no commenter for the session (or if there is no active
# session).
#
# Validation of the comment data is left to the caller.
#
sub _make_comment {
    my ($app, $entry) = @_;
    my $q = $app->{query};
    
    my $nick = $q->param('author');
    my $email = $q->param('email');
    my ($session, $commenter) = $app->_get_commenter_session();
    if ($commenter) {
        $nick = $commenter->nickname();
        $email = $commenter->email();
    }
    my $url = $q->param('url') || ''; #($commenter ? $commenter->url() : '');
    my $comment = MT::Comment->new;
    if ($commenter) {
        $comment->commenter_id($commenter->id);
    }
    ## Strip linefeed characters.
    my $text = $q->param('text');
    $text = '' unless defined $text;
    $text =~ tr/\r//d;
    $comment->ip($app->remote_ip);
    $comment->blog_id($entry->blog_id);
    $comment->entry_id($entry->id);
    $comment->author(remove_html($nick));
    $comment->email(remove_html($email));
    $comment->url(is_valid_url($url, 'stringent'));
    $comment->text($text);
    #$comment->visible(0); # leave as undefined
    $comment->is_junk(0);
    
    return ($comment, $commenter);
}

sub _commenter_has_comment {
    my ($commenter, $entry) = @_;

    my $commenter_has_comment = 0;
    if ($commenter) {
        my $other_comment = MT::Comment->load({commenter_id =>
                                               $commenter->id});
        if ($other_comment) {
            my $other_entry
               =MT::Entry->load({author_id => $entry->author_id},
                                {join=>['MT::Comment', 'entry_id',
                                        {commenter_id=>$commenter->id},{}]});
            $commenter_has_comment = !!$other_entry;
        }
    }
    $commenter_has_comment;
}

sub _send_comment_notification {
    my $app = shift;
    my ($comment, $comment_link, $entry, $blog, $commenter) = @_;

    return unless $blog->email_new_comments;

    my $commenter_has_comment = _commenter_has_comment($commenter, $entry);
    my $attn_reqd = $comment->is_moderated;

    if ($blog->email_attn_reqd_comments && !$attn_reqd) {
        return;
    }

    require MT::Mail;
    my $author = $entry->author;
    $app->set_language($author->preferred_language)
        if $author && $author->preferred_language;
    my $from_addr;
    my $reply_to;
    if ($app->{cfg}->EmailReplyTo) {
        $reply_to = $comment->email;
    } else {
        $from_addr = $comment->email;
    }
    $from_addr = undef if $from_addr && !is_valid_email($from_addr);
    $reply_to = undef if $reply_to && !is_valid_email($reply_to);
    if ($author && $author->email && is_valid_email($author->email)) {
        if (!$from_addr) {
            $from_addr = $app->{cfg}->EmailAddressMain || $author->email;
        }
        my %head = ( To => $author->email,
                     $from_addr ? (From => $from_addr) : (),
                     $reply_to ? ('Reply-To' => $reply_to) : (),
                     Subject =>
                     '[' . $blog->name . '] ' .
                     $app->translate("New Comment Posted to '[_1]'",
                                     $entry->title)
                   );
        my $charset = $app->{cfg}->MailEncoding || $app->{cfg}->PublishCharset;
        $head{'Content-Type'} = qq(text/plain; charset="$charset");
        my $base;
        { local $app->{is_admin} = 1;
          $base = $app->base . $app->mt_uri; }
        if ($base =~ m!^/!) {
            my ($blog_domain) = $blog->site_url =~ m|(.+://[^/]+)|;
            $base = $blog_domain . $base;
        }
        my %param = (
                     blog_name => $blog->name,
                     entry_id => $entry->id,
                     entry_title => $entry->title,
                     view_url => $comment_link,
                     edit_url => $base . $app->uri_params('mode' => 'view', args => { blog_id => $blog->id, '_type' => 'comment', id => $comment->id}),
                     ban_url => $base . $app->uri_params('mode' => 'save', args => {'_type' => 'banlist', blog_id => $blog->id, ip => $comment->ip}),
                     comment_ip => $comment->ip,
                     comment_name => $comment->author,
                     (is_valid_email($comment->email)?
                      (comment_email => $comment->email):()),
                     comment_url => $comment->url,
                     comment_text => $comment->text,
                     unapproved => !$comment->visible(),
                    );
        my $body = MT->build_email('new-comment.tmpl', \%param);
        $body = wrap_text($body, 72);
        MT::Mail->send(\%head, $body)
            or return $app->handle_error(MT::Mail->errstr());
    }
}

sub preview { my $app = shift; do_preview($app, $app->{query}, @_) }

sub _make_commenter {
    my $app = shift;
    my %params = @_;
    require MT::Author;
    my $cmntr = MT::Author->load({ name => $params{name},
                                   type => MT::Author::COMMENTER });
    if (!$cmntr) {
        $cmntr = MT::Author->new();
        $cmntr->set_values({email => $params{email},
                            name => $params{name},
                            nickname => $params{nickname},
                            password => "(none)",
                            type => MT::Author::COMMENTER,
                            url => $params{url},
                            });
        $cmntr->save();
    } else {
        $cmntr->set_values({email => $params{email},
                            nickname => $params{nickname},
                            password => "(none)",
                            type => MT::Author::COMMENTER,
                            url => $params{url},
                            });
        $cmntr->save();
    }
    return $cmntr;
}

# TBD: Move this to MT::Session and store expiration date in 
# the record
sub _expire_sessions {
    my ($timeout) = @_;
    
    require MT::Session;
    my @old_sessions = MT::Session->load({start => 
                                              [0, time() - $timeout],
                                          kind => 'SI'},
                                         {range => {start => 1}});
    foreach (@old_sessions) {
        $_->remove() || die "couldn't remove sessions because "
            . $_->errstr();
    }
}

sub _make_commenter_session {
    my $app = shift;
    my ($session_key, $email, $name, $nick) = @_;

    my $enc = $app->charset;
    $nick = encode_text($nick, $enc, 'utf-8');

    my $timeout = $app->{cfg}->CommentSessionTimeout;
    my %kookee = (-name => $COMMENTER_COOKIE_NAME,
                  -value => $session_key,
                  -path => '/',
                  -expires => '+' . $timeout . 's');
    $app->bake_cookie(%kookee);
    my %name_kookee = (-name => "commenter_name",
                       -value => $nick,
                       -path => '/',
                       -expires => '+' . $timeout . 's');
    $app->bake_cookie(%name_kookee);

    require MT::Session;
    my $sess_obj = MT::Session->new();
    $sess_obj->id($session_key);
    $sess_obj->email($email);
    $sess_obj->name($name);
    $sess_obj->start(time);
    $sess_obj->kind("SI");
    $sess_obj->save()
        or return $app->error($app->translate("The login could not be confirmed because of a database error ([_1])", $sess_obj->errstr));
    return $session_key;
}

my $SIG_WINDOW = 60 * 10;  # ten minute handoff between TP and MT

sub _validate_signature {
    my $app = shift;
    my ($sig_str, %params) = @_;

    # the DSA sig parameter is composed of the two pieces of the
    # real DSA sig, packed in Base64, separated by a colon.

#    my ($r, $s) = split /:/, decode_url($sig_str);
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
    if ($app->{cfg}->TypeKeyVersion eq '1.1') {
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
        $dsa_key = $app->{cfg}->get('SignOnPublicKey');
    }
    # Load the DSA key from the RegKeyURL
    my $key_location = $app->{cfg}->RegKeyURL;
    if (!$dsa_key && $key_location) {
        my $ua = $app->new_ua;
        $app->log({
            message => $app->translate("Couldn't get public key from url provided"),
            level => MT::Log::ERROR(),
            class => 'system',
            category => 'commenter_authentication',
        });
        return $app->error($app->translate("Couldn't get public key from url provided"))
            unless $ua;
        my $req = new HTTP::Request(GET => $key_location);
        my $resp = $ua->request($req);
        $app->log({
            message => $app->translate("Couldn't get public key from url provided"),
            level => MT::Log::ERROR(),
            class => 'system',
            category => 'commenter_authentication',
        });
        return $app->error($app->translate("Couldn't get public key from url provided"))
            unless $resp->is_success();
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
        message => $app->translate("TypeKey signature verif'n returned [_1] in [_2] seconds verifying [_3] with [_4]",
            ($valid ? "VALID" : "INVALID"), $timer, $msg, $sig_str),
        class => 'system',
        level => MT::Log::WARNING(),
    }) unless $valid;

    $app->log({
        message => $app->translate("The TypeKey signature is out of date ([_1] seconds old). Ensure that your server's clock is correct", ($params{ts} - time)),
        class => 'system',
        level => MT::Log::WARNING(),
    }) unless ($params{ts} + $SIG_WINDOW >= time);

    return ($valid && $params{ts} + $SIG_WINDOW >= time);
}

sub _handle_sign_in {
    my $app = shift;
    my $q = $app->{query};
    my ($weblog) = @_;

    if ($q->param('logout')) {
        my %cookies = $app->cookies();

        my $cookie_val = ($cookies{$COMMENTER_COOKIE_NAME}
                          ? $cookies{$COMMENTER_COOKIE_NAME}->value()
                          : "");
        #my ($email, $session) = split(/::/, $cookie_val) if $cookie_val;
        my $session = $cookie_val;
        require MT::Session;
        my $sess_obj = MT::Session->load({id => $session });
        $sess_obj->remove() if ($sess_obj);
        
        my $timeout = $app->{cfg}->CommentSessionTimeout;

        my %kookee = (-name => $COMMENTER_COOKIE_NAME,
                      -value => '',
                      -path => '/',
                      -expires => "+${timeout}s");
        $app->bake_cookie(%kookee);
        my %name_kookee = (-name => 'commenter_name',
                           -value => '',
                           -path => '/',
                           -expires => "+${timeout}s");
        $app->bake_cookie(%name_kookee);
        return 1;
    } elsif ($q->param('sig')) {
        my $session = undef;
        my ($email, $name, $nick);
        my $ts = $q->param('ts') || "";
        $email = $q->param('email') || "";
        $name = $q->param('name') || "";
        $nick = $q->param('nick') || "";
        my $sig_str = $q->param('sig');
        my $cmntr;
        if ($sig_str) {
            if (!$app->_validate_signature($sig_str, 
                                           token => $weblog->effective_remote_auth_token,
                                           email => decode_url($email),
                                           name => decode_url($name),
                                           nick => decode_url($nick),
                                           ts => $ts))
            {
                # Signature didn't match, or timestamp was out of date.
                # This implies tampering, not a user mistake.
                return $app->error($app->translate("The sign-in validation failed."));
            }

            if ($weblog->require_comment_emails && !is_valid_email($email)) {
                $q->param('email', '');  # blank out email address since it's invalid
                return $app->error($app->translate("This weblog requires commenters to pass an email address. If you'd like to do so you may log in again, and give the authentication service permission to pass your email address."));
            }

            # Signature was valid, so create a session, etc.
            my $enc = $app->{cfg}->PublishCharset || '';
            my $nick_escaped = MT::Util::escape_unicode($nick);
            $nick = MT::I18N::encode_text($nick, 'utf-8', undef);
            $session = $app->_make_commenter_session($sig_str, $email,
                                                     $name, $nick_escaped)
                || return $app->error($app->errstr()
                                      || $app->translate("Couldn't save the session"));
            $cmntr = $app->_make_commenter(email => $email,
                                           nickname => $nick,
                                           name => $name);
        } else {
            # If there's no signature, then we trust the cookie.
            my %cookies = $app->cookies();
            if ($cookies{$COMMENTER_COOKIE_NAME}
                && ($session = $cookies{$COMMENTER_COOKIE_NAME}->value())) 
            {
                require MT::Session; require MT::Author;
                my $sess = MT::Session->load({id => $session});
                $cmntr = MT::Author->load({name => $sess->name,
                                           type => MT::Author::COMMENTER});
                if ($weblog->require_comment_emails
                    && !is_valid_email($cmntr->email))
                {
                    return $app->error($app->translate("This weblog requires commenters to pass an email address"));
                }
            }
        }
        if ($q->param('sig') && !$cmntr) {
            return $app->handle_error($app->errstr());
        }
        return $cmntr;
    }
}

# This actually handles a UI-level sign-in or sign-out request.
sub handle_sign_in {
    my $app = shift;
    my $q = $app->{query};

    my $entry = MT::Entry->load($q->param('entry_id'))
        or die "No such entry";
    my $weblog = MT::Blog->load($q->param('blog_id') || $entry->blog_id);

    return $app->handle_error($app->translate("Sign in requires a secure signature; logout requires the logout=1 parameter")) 
        unless ($q->param('sig') || $q->param('logout'));
    
    $app->_handle_sign_in($weblog)
        || return $app->handle_error($app->errstr() || 
                  $app->translate("The sign-in attempt was not successful; please try again."), 403);

    my $target;
    if ($q->param('static')) {
        if ($q->param('static') eq 1) {
            require MT::Entry;
            my $entry = MT::Entry->load($q->param('entry_id'));
            $target = $entry->archive_url;
            $target = MT::Util::strip_index($target, $weblog);
        } else {
            $target = $q->param('static');
        }
    } else {
        $target = ($app->{cfg}->CGIPath . $app->{cfg}->CommentScript
                   . "?entry_id=" . $entry->id
                   . ($q->param('arch') ? '&static=0&arch=1' : ''));
    } 
    require MT::Util;
    if ($q->param('logout')) {
        return $app->redirect($app->{cfg}->SignOffURL . "&_return=" .
                              MT::Util::encode_url($target),
                              UseMeta => 1);
    } else {
        return $app->redirect($target, UseMeta => 1);
    }
}

sub commenter_name_js {
    local $SIG{__WARN__} = sub {};
    my $app = shift;
    my $commenter_name = $app->cookie_val('commenter_name');
    # FIXME: how do we know this is coming in as utf-8?
    $commenter_name = encode_text($commenter_name, 'utf-8');

    $app->set_header('Cache-Control' => 'no-cache');
    $app->set_header('Expires' => '-1');

    return "var commenter_name = '$commenter_name';\n";
}

sub view {
    my $app = shift;
    my $q = $app->{query};
    my %param = $app->param_hash();
    my %overrides = ref($_[0]) ? %{$_[0]} : ();
    @param{keys %overrides} = values %overrides;

    my $cmntr;
    my $session_key;

    my $weblog = MT::Blog->load($q->param('blog_id'));

    if ($q->param('logout')) {
        return $app->handle_sign_in($weblog);
    }

    if ($q->param('sig')) {
        $cmntr = $app->_handle_sign_in($weblog)
            || return $app->handle_error($app->translate(
                 "The sign-in validation was not successful. Please make sure your weblog is properly configured and try again."));
        $cmntr = undef if $cmntr == 1;   # 1 is returned on logout.
    } else {
        ($session_key, $cmntr) = $app->_get_commenter_session();
    }

    require MT::Template;
    require MT::Template::Context;

    require MT::Entry;
    my $entry_id = $q->param('entry_id')
        or return $app->error($app->translate("No entry_id"));
    my $entry = MT::Entry->load($entry_id)
        or return $app->error($app->translate(
            "No such entry ID '[_1]'", $entry_id));
    return $app->error($app->translate(
            "No such entry ID '[_1]'", $entry_id))
        if $entry->status != RELEASE;

    my $cfg = $app->{cfg};
    require MT::Blog;
    my $blog = MT::Blog->load($entry->blog_id);
    if ($cmntr) {
        if (!$blog->manual_approve_commenters &&
            ($cmntr->status($entry->blog_id) == PENDING))
        {
            $cmntr->approve($entry->blog_id);
        }
    }

    my $ctx = MT::Template::Context->new;
    $ctx->stash('entry', $entry);
    $ctx->stash('commenter', $cmntr) if ($cmntr);
    $ctx->{current_timestamp} = $entry->created_on;
    my %cond;
    my $tmpl = ($q->param('arch')) ?
        (MT::Template->load({ type => 'individual',
                              blog_id => $entry->blog_id })
            or return $app->error($app->translate(
                 "You must define an Individual template in order to " .
                 "display dynamic comments.")))
    :
        (MT::Template->load({ type => 'comments',
                              blog_id => $entry->blog_id })
            or return $app->error($app->translate(
                 "You must define a Comment Listing template in order to " .
                 "display dynamic comments.")));

    my $html = $tmpl->build($ctx, \%cond);
    $html = MT::Util::encode_html($tmpl->errstr) unless defined $html;
    $html;
}

sub handle_error {
    my $app = shift;
    my($err, $status_line) = @_;
    my $html = do_preview($app, $app->{query}, $err)
        || return "An error occurred: " . $err;
    $app->{status_line} = $status_line;
    $html;
}

sub do_preview {
    my($app, $q, $err) = @_;

    return $app->error($app->translate("Invalid request"))
        if $app->request_method() ne 'POST';

    require MT::Template;
    require MT::Template::Context;
    require MT::Entry;
    require MT::Util;
    require MT::Comment;
    my $entry_id = $q->param('entry_id') 
        || return $app->error($app->translate('No entry was specified; perhaps there is a template problem?'));
    my $entry = MT::Entry->load($entry_id)
        || return $app->error($app->translate("Somehow, the entry you tried to comment on does not exist"));
    my $ctx = MT::Template::Context->new;

    my ($comment, $commenter) = $app->_make_comment($entry);
    return "An error occurred: " . $app->errstr() unless $comment;
    
    ## Set timestamp as we would usually do in ObjectDriver.
    my @ts = MT::Util::offset_time_list(time, $entry->blog_id);
    my $ts = sprintf "%04d%02d%02d%02d%02d%02d",
        $ts[5]+1900, $ts[4]+1, @ts[3,2,1,0];
    $comment->created_on($ts);
    $ctx->stash('comment_preview', $comment);

    unless ($err) {
        ## Serialize comment state, then hex-encode it.
        require MT::Serialize;
        my $ser = MT::Serialize->new($app->{cfg}->Serializer);
        my $state = $comment->column_values;
        $state->{static} = $q->param('static');
        $ctx->stash('comment_state', unpack 'H*', $ser->serialize(\$state));
    }
    $ctx->stash('comment_is_static', $q->param('static'));
    $ctx->stash('entry', $entry);
    $ctx->{current_timestamp} = $ts;
    $ctx->stash('commenter', $commenter);
    my($tmpl);
    $err ||= '';
    if ($err eq 'pending') {
        $tmpl = MT::Template->load({ type => 'comment_pending',
                                     blog_id => $entry->blog_id })
        or return $app->error($app->translate(
            "You must define a Comment Pending template."));
    } elsif ($err) {
        $ctx->stash('error_message', $err);
        $tmpl = MT::Template->load({ type => 'comment_error',
                                     blog_id => $entry->blog_id })
        or return $app->error($app->translate(
            "You must define a Comment Error template."));
    } else {
        $tmpl = MT::Template->load({ type => 'comment_preview',
                                     blog_id => $entry->blog_id })
        or return $app->error($app->translate(
            "You must define a Comment Preview template."));
    }
    require MT::Blog;
    my $blog = MT::Blog->load($entry->blog_id);
    my %cond;
    my $html = $tmpl->build($ctx, \%cond);
    $html = $tmpl->errstr unless defined $html;
    $html;
}

sub blog {
    my $app = shift;
    return $app->{_blog} if $app->{_blog};
    return undef unless $app->{query}; 
    if (my $entry_id = $app->param('entry_id')) {
        require MT::Entry;
        my $entry = MT::Entry->load($entry_id);
        return undef unless $entry;
        $app->{_blog} = $entry->blog if $entry;
    } 
    return $app->{_blog};
}

1;
__END__

=head1 NAME

MT::App::Comments

=head1 SYNOPSIS

The application-level callbacks of the C<MT::App::Comments> application
are documented here.

=head1 CALLBACKS

=over 4

=item CommentThrottleFilter

Called as soon as a new comment has been received. The callback must
return a boolean value. If the return value is false, the incoming
comment data will be discarded and the app will output an error page
about throttling. A CommentThrottleFilter callback has the following
signature:

    sub comment_throttle_filter($eh, $app, $entry)
    {
        ...
    }

I<$app> is the C<MT::App::Comments> object, whose interface is documented
in L<MT::App::Comments>, and I<$entry> is the entry on which the
comment is to be placed.

Note that no comment object is passed, because it has not yet been
built. As such, this callback can be used to tell the application to
exit early from a comment attempt, before much processing takes place.

When more than one CommentThrottleFilter is installed, the data is
discarded unless all callbacks return true.

=item CommentFilter

Called once the comment object has been constructed, but before saving
it. If any CommentFilter callback returns false, the comment will not
be saved. The callback has the following signature:

    sub comment_filter($eh, $app, $comment)
    {
        ...
    }

=back
