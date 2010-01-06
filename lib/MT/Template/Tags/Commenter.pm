# Movable Type (r) Open Source (C) 2001-2010 Six Apart Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::Template::Tags::Commenter;

use strict;

use MT;

###########################################################################

=head2 IfExternalUserManagement

A conditional tag that returns true when external user management is
turned on.

=cut

sub _hdlr_if_external_user_management {
    my ($ctx) = @_;
    return $ctx->{config}->ExternalUserManagement;
}

###########################################################################

=head2 IfCommenterRegistrationAllowed

A conditional tag that returns true when user registration is
turned on.

=cut

sub _hdlr_if_commenter_registration_allowed {
    my ($ctx) = @_;
    my $registration = $ctx->{config}->CommenterRegistration;
    my $blog = $ctx->stash('blog');
    return $registration->{Allow}
        && ( $blog && $blog->allow_commenter_regist );
}

###########################################################################

=head2 CommenterIfTrusted

Deprecated in favor of the L<IfCommenterTrusted> tag.

=for tags deprecated

=cut

###########################################################################

=head2 IfCommenterTrusted

A conditional tag that displays its contents if the commenter in context
has been marked as trusted.

=for tags comments, authentication

=cut

sub _hdlr_commenter_trusted {
    my ($ctx, $args, $cond) = @_;
    my $a = $ctx->stash('commenter');
    return '' unless $a;
    if ($a->is_trusted($ctx->stash('blog_id'))) {
        return 1;
    } else {
        return 0;
    }
}

###########################################################################

=head2 IfCommenterIsAuthor

Conditional tag that is true when the current comment was left
by a user who is also a native MT user.

=cut

###########################################################################

=head2 IfCommenterIsEntryAuthor

Conditional tag that is true when the current comment was left
by the author of the current entry in context.

=for tags comments

=cut

sub _hdlr_commenter_isauthor {
    my ($ctx, $args, $cond) = @_;
    my $a = $ctx->stash('commenter');
    return 0 unless $a;
    if ($a->type == MT::Author::AUTHOR()) {
        my $tag = lc $ctx->stash('tag');
        if ($tag eq 'ifcommenterisentryauthor') {
            my $c = $ctx->stash('comment');
            my $e = $c ? $c->entry : $ctx->stash('entry');
            if ($e) {
                if ($e->author_id == $a->id) {
                    return 1;
                }
            }
        } else {
            return 1;
        }
    }
    return 0;
}

###########################################################################

=head2 CommenterNameThunk

Used to populate the commenter_name Javascript variable. Deprecated in
favor of the L<UserSessionState> tag.

=for tags deprecated

=cut

sub _hdlr_commenter_name_thunk {
    my $ctx = shift;
    my $cfg = $ctx->{config};
    my $blog = $ctx->stash('blog') || MT::Blog->load($ctx->stash('blog_id'));
    return $ctx->error(MT->translate('Can\'t load blog #[_1].', $ctx->stash('blog_id'))) unless $blog;
    my ($blog_domain) = $blog->archive_url =~ m|://([^/]*)|;
    my $cgi_path = $ctx->cgi_path;
    my ($mt_domain) = $cgi_path =~ m|://([^/]*)|;
    $mt_domain ||= '';
    if ($blog_domain ne $mt_domain) {
        my $cmt_script = $cfg->CommentScript;
        return "<script type='text/javascript' src='$cgi_path$cmt_script?__mode=cmtr_name_js'></script>";
    } else {
        return "<script type='text/javascript'>var commenter_name = getCookie('commenter_name')</script>";
    }
}

###########################################################################

=head2 CommenterUsername

This template tag returns the username of the current commenter in context.
If no name exists, then it returns an empty string.

B<Example:>

    <mt:Entries>
        <h1><$mt:EntryTitle$></h1>
        <mt:Comments>
            <a name="comment-<$mt:CommentID$>"></a>
            <p><$mt:CommentBody$></p>
            <cite><a href="/profiles/<$mt:CommenterID$>"><$mt:CommenterUsername$></a></cite>
        </mt:Comments>
    </mt:Entries>

=for tags comments

=cut

sub _hdlr_commenter_username {
    my ($ctx) = @_;
    my $a = $ctx->stash('commenter');
    return $a ? $a->name : '';
}

###########################################################################

=head2 CommenterName

The name of the commenter for the comment currently in context.

B<Example:>

    <$mt:CommenterName$>

=for tags comments

=cut

sub _hdlr_commenter_name {
    my ($ctx) = @_;
    my $a = $ctx->stash('commenter');
    my $name = $a ? $a->nickname || '' : '';
    $name = $ctx->invoke_handler('commentauthor') unless $name;
    return $name;
}

###########################################################################

=head2 CommenterEmail

The email address of the commenter. The spam_protect global filter may
be used.

B<Example:>

    <$mt:CommenterEmail$>

=for tags comments

=cut

sub _hdlr_commenter_email {
    my ($ctx) = @_;
    my $a = $ctx->stash('commenter');
    return '' if $a && $a->email !~ m/@/;
    return $a ? $a->email || '' : '';
}

###########################################################################

=head2 CommenterAuthType

Returns a string which identifies what authentication provider the commenter
in context used to authenticate him/herself. Commenter context is created by
either MTComments or MTCommentReplies template tag. For example, 'MT' will be
returned when the commenter in context is authenticated by Movable Type. When
the commenter in context is authenticated by Vox, 'Vox' will be returned.

B<Example:>

    <mt:Comments>
      <$mt:CommenterName$> (<$mt:CommenterAuthType$>) said:
      <$mt:CommentBody$>
    </mt:Comments>

=for tags comments, authentication

=cut

sub _hdlr_commenter_auth_type {
    my ($ctx) = @_;
    my $a = $ctx->stash('commenter');
    return $a ? $a->auth_type || '' : '';
}

###########################################################################

=head2 CommenterAuthIconURL

Returns URL to a small (16x16) image represents in what authentication
provider the commenter in context is authenticated. Commenter context
is created by either a L<Comments> or L<CommentReplies> block tag. For
commenters authenticated by Movable Type, it will be a small spanner
logo of Movable Type. Otherwise, icon image is provided by each of
authentication provider. Movable Type provides images for Vox,
LiveJournal and OpenID out of the box.

B<Example:>

    <mt:Comments>
        <$mt:CommenterName$><$mt:CommenterAuthIconURL$>:
        <$mt:CommentBody$>
    </mt:Comments>

=for tags comments, authentication

=cut

sub _hdlr_commenter_auth_icon_url {
    my ($ctx, $args) = @_;
    my $a = $ctx->stash('commenter');
    return q() unless $a;
    my $size = $args->{size} || 'logo_small';
    my $url = $a->auth_icon_url($size);
    if ($url =~ m!^/!) {
        # relative path, prepend blog domain
        my $blog = $ctx->stash('blog');
        if ($blog) {
            my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
            $url = $blog_domain . $url;
        }
    }
    return $url;
}

###########################################################################

=head2 CommenterID

Outputs the numeric ID of the current commenter in context.

=for tags comments

=cut

sub _hdlr_commenter_id {
    my ($ctx) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $cmntr = $ctx->stash('commenter') or return '';
    return $cmntr->id;
}

###########################################################################

=head2 CommenterURL

Outputs the URL from the profile of the current commenter in context.

=for tags comments

=cut

sub _hdlr_commenter_url {
    my ($ctx) = @_;
    my $c = $ctx->stash('comment')
        or return $ctx->_no_comment_error();
    my $cmntr = $_[0]->stash('commenter') or return '';
    return $cmntr->url || '';
}

###########################################################################

=head2 UserSessionState

Returns a JSON-formatted data structure that represents the user that is
currently logged in.

=for tags comments, authentication

=cut

sub _hdlr_user_session_state {
    my ($ctx, $args, $cond) = @_;
    my $app = MT->app;
    return 'null' unless $app->can('session_state');

    my ( $state, $commenter ) = $app->session_state();
    my $json = MT::Util::to_json($state);
    return $json;
}

###########################################################################

=head2 UserSessionCookieTimeout

Returns the value of the C<UserSessionCookieTimeout> configuration setting.

=for tags comments, configuration, authentication

=cut

sub _hdlr_user_session_cookie_timeout {
    my ($ctx) = @_;
    return $ctx->{config}->UserSessionCookieTimeout;
}

###########################################################################

=head2 UserSessionCookiePath

Returns the value of the C<UserSessionCookiePath> configuration setting.

The C<UserSessionCookiePath> may also use MT tags. If it does, they will
be evaluated for the blog in context.

=for tags comments, configuration, authentication

=cut

sub _hdlr_user_session_cookie_path {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $blog_id = $blog ? $blog->id : '0';
    my $blog_path = $ctx->stash('blog_cookie_path_' . $blog_id);
    if (!defined $blog_path) {
        $blog_path = $ctx->{config}->UserSessionCookiePath;
        if ($blog_path =~ m/<\$?mt/i) { # hey, a MT tag! lets evaluate
            my $builder = $ctx->stash('builder');
            my $tokens = $builder->compile($ctx, $blog_path);
            return $ctx->error($builder->errstr) unless defined $tokens;
            $blog_path = $builder->build($ctx, $tokens, $cond);
            return $ctx->error($builder->errstr) unless defined $blog_path;
        }
        $ctx->stash('blog_cookie_path_' . $blog_id, $blog_path);
    }
    return $blog_path;
}

###########################################################################

=head2 UserSessionCookieDomain

Returns the value of the C<UserSessionCookieDomain> configuration setting,
or the domain name of the blog currently in context. Any "www" subdomain
will be ignored (ie, "www.sixapart.com" becomes ".sixapart.com").

The C<UserSessionCookieDomain> may also use MT tags. If it does, they will
be evaluated for the blog in context.

=for tags comments, configuration, authentication

=cut

sub _hdlr_user_session_cookie_domain {
    my ($ctx, $args, $cond) = @_;
    my $blog = $ctx->stash('blog');
    my $blog_id = $blog ? $blog->id : '0';
    my $blog_domain = $ctx->stash('blog_cookie_domain_' . $blog_id);
    if (!defined $blog_domain) {
        $blog_domain = $ctx->{config}->UserSessionCookieDomain;
        if ($blog_domain =~ m/<\$?mt/i) { # hey, a MT tag! lets evaluate
            my $builder = $ctx->stash('builder');
            my $tokens = $builder->compile($ctx, $blog_domain);
            return $ctx->error($builder->errstr) unless defined $tokens;
            $blog_domain = $builder->build($ctx, $tokens, $cond);
            return $ctx->error($builder->errstr) unless defined $blog_domain;
        }
        # strip off common 'www' subdomain
        $blog_domain =~ s/^www\.//;
        $blog_domain = '.' . $blog_domain unless $blog_domain =~ m/^\./;
        $ctx->stash('blog_cookie_domain_' . $blog_id, $blog_domain);
    }
    return $blog_domain;
}

###########################################################################

=head2 UserSessionCookieName

Returns the value of the C<UserSessionCookieName> configuration setting.
If the setting contains the C<%b> string, it will replaced with the blog ID
of the blog currently in context.

B<Example:>

    <$mt:UserSessionCookieName$>

=for tags comments, configuration

=cut

sub _hdlr_user_session_cookie_name {
    my ($ctx) = @_;
    my $name = $ctx->{config}->UserSessionCookieName;
    if ($name =~ m/%b/) {
        my $blog_id = '0';
        if (my $blog = $ctx->stash('blog')) {
            $blog_id = $blog->id;
        }
        $name =~ s/%b/$blog_id/g;
    }
    return $name;
}

# FIXME: Unused?
sub _hdlr_if_commenter_pending {
    my ($ctx, $args, $cond) = @_;
    my $cmtr = $ctx->stash('commenter');
    my $blog = $ctx->stash('blog');
    if ($cmtr && $blog && $cmtr->commenter_status($blog->id) == MT::Author::PENDING()) {
        return 1;
    } else {
        return 0;
    }
}

1;
