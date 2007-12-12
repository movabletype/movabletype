# Movable Type (r) Open Source (C) 2005-2007 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# CommentByGoogleAccount plugin for Movable Type
# Author: Six Apart (http://www.sixapart.com)
# Released under the Artistic and GPLv2 License

package MT::Plugin::CommentByGoogleAccount;

use strict;
use base qw( MT::Plugin );
use MT::Util qw( encode_url );

my $plugin = new MT::Plugin::CommentByGoogleAccount({
    name => "Comment by Google Account",
    version => '0.1',
    description => "<MT_TRANS phrase=\"You can allow readers to authenticate themselves via Google Account to comment on posts.\">",
    author_name => "Six Apart, Ltd.",
    author_link => "http://www.sixapart.com/",
    settings => new MT::PluginSettings([
        ['google_commenter_nickname'],
    ]),
    config_template => 'config.tmpl',
    #l10n_class => 'CommentByGoogleAccount::L10N',
});
MT->add_plugin($plugin);

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        'commenter_authenticators' => {
            'google' => {
                label => 'Google',
                class => 'CommentByGoogleAccount',
                login_form => <<Google,
<p><a href="<TMPL_VAR NAME=URL>">Click here</a> to sign in via your Google account.</p>
Google
                login_form_params => sub {
        my ($key, $blog_id, $entry_id, $static) = @_;

        require MT::Template::Context;
        my $ctx = MT::Template::Context->new;
        require MT::Blog;
        $ctx->stash('blog', MT::Blog->load($blog_id));
        my $path = MT::Template::Context::_hdlr_cgi_path($ctx);
        $path .= MT::ConfigMgr->instance->CommentScript;
        my $next = "$path?__mode=handle_sign_in&key=google&blog_id=$blog_id&entry_id=$entry_id&static=$static";
        $next = encode_url($next);

        ## temporarily use Google Base as our scope.  TODO: determine how to correctly do this
        my $url = "http://www.google.com/accounts/AuthSubRequest?scope=http%3A%2F%2Fwww.google.com%2Fbase&next=$next&session=0";
        return {
            url => $url,
        };
                },
            },
        },
    });
}

sub instance { $plugin }

sub load_config {
    my $plugin = shift;
    my ($param, $scope) = @_;

    $plugin->SUPER::load_config(@_);
    $param->{Caption} = $plugin->translate("Commenter's nickname to be used:");
}

1;
