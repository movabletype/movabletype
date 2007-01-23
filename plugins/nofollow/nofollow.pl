# Nofollow plugin for Movable Type
# Author: Six Apart http://www.sixapart.com
# Released under the Artistic License
#
# $Id$

package MT::Plugin::Nofollow;

use strict;
use MT;

use vars qw( $VERSION );
$VERSION = '2.01';

my $plugin;
eval {
    require MT::Plugin;
    $plugin = MT::Plugin->new({
        name => 'Nofollow',
        description => "<MT_TRANS phrase=\"Adds a 'nofollow' relationship to comment and TrackBack hyperlinks to reduce spam.\">",
        doc_link => 'http://www.sixapart.com/movabletype/news/2005/01/movable_type_nofollow_p.html',
        author_name => 'Six Apart, Ltd.',
        author_link => 'http://www.sixapart.com/',
        version => $VERSION,
        config_template => \&template,
        settings => new MT::PluginSettings([
            ['follow_auth_links', { Default => 1 }]
        ]),
    });
    MT->add_plugin($plugin);
};

use MT::Template::Context;

my $tags_to_filter = {
    CommentBody       => [0, \&MT::Template::Context::_hdlr_comment_body],
    CommentPreviewBody       => [0, \&MT::Template::Context::_hdlr_comment_body],
    CommentAuthorLink => [0, \&MT::Template::Context::_hdlr_comment_author_link],
    CommentPreviewAuthorLink => [0, \&MT::Template::Context::_hdlr_comment_author_link],
    Pings             => [1, \&MT::Template::Context::_hdlr_pings]
};

foreach (keys %$tags_to_filter) {
    my $meth = $tags_to_filter->{$_}->[0] ? 'add_container_tag' : 'add_tag';
    MT::Template::Context->$meth( $_ => \&nofollowfy_hdlr );
}
MT::Template::Context->add_global_filter('nofollowfy' => \&nofollowfy);

sub template {
    my $tmpl = <<'EOT';
    <div class="setting">
    <div class="label">
    <label for="follow_auth_links"><MT_TRANS phrase="Restrict:"></label>
    </div>
    <div class="field">
    <p><input value="1" type="checkbox" name="follow_auth_links" id="follow_auth_links" <TMPL_IF NAME=FOLLOW_AUTH_LINKS>checked="checked"</TMPL_IF> />
    <MT_TRANS phrase="Don't add nofollow to links in comments by trusted commenters"></p>
    </div> 
    </div>
EOT
}

sub config {
    my $config = {};
    if ($plugin) {
        require MT::Request;
        my ($scope) = (@_);
        $config = MT::Request->instance->cache('nofollow_config_'.$scope);
        if (!$config) {
            $config = $plugin->get_config_hash($scope);
            MT::Request->instance->cache('nofollow_config_'.$scope, $config);
        }
    }
    $config;
}

sub nofollowfy_hdlr {
    my ($ctx, $args, $cond) = @_;

    my $blog = $ctx->stash('blog');
    my $config = config('blog:'.$blog->id);

    my $tag = $ctx->stash('tag');
    if ($tag =~ m/Comment(Preview)?AuthorLink/) {
        $args->{no_redirect} = 1 unless exists $args->{no_redirect};
    }
    my $fn = $tags_to_filter->{$tag}->[1];
    my $out = $fn->($ctx, $args, $cond);

    my $sanitize_spec;
    if (exists $args->{__sanitize}) {
        $sanitize_spec = $args->{__sanitize};
    } else {
        # calculate the effective sanitize setting for this tag
        $sanitize_spec = $args->{sanitize};
        if (((!defined $sanitize_spec) || ($sanitize_spec))
            && !$tags_to_filter->{$tag}->[0]) {
            # if user specified a sanitize="1", blank that out so we can
            # pull the spec from the blog or global setting.
            $sanitize_spec = '' if (defined $sanitize_spec) && ($sanitize_spec eq '1');
            $sanitize_spec ||= $ctx->stash('blog')->sanitize_spec
                || MT::ConfigMgr->instance->GlobalSanitizeSpec || '';
        }
        $args->{__sanitize} = $sanitize_spec;
    }

    # if user requests sanitize filtering, do that now so
    # before we add the 'rel' attribute to hyperlinks
    if ($sanitize_spec) {
        require MT::Sanitize;
        $out = MT::Sanitize->sanitize($out, $sanitize_spec);
    }

    # force sanitize attribute to 0 so the global sanitize
    # filter doesn't reprocess and strip out our 'rel' attribute
    $args->{sanitize} = '0';

    if (($tag =~ m/Comment/) && ($config->{follow_auth_links})) {
        my $comment = $ctx->stash('comment');
        if ($comment) {
            my $commenter_id = $comment->commenter_id;
            if ($commenter_id) {
                require MT::Author;
                my $commenter = MT::Author->load($commenter_id);
                if ($commenter) {
                    # return links as-is for approved commenters
                    return $out if $commenter->status($ctx->stash('blog_id')) == MT::Author::APPROVED();
                }
            }
        }
    }

    # finally, nofollowfize any hyperlinks...
    nofollowfy($out, '1', $ctx);
}

sub nofollowfy {
    my ($str, $arg, $ctx) = @_;
    return $str unless $arg;
    $str =~ s#<\s*a\s([^>]*\s*href\s*=[^>]*)>#
        my @attr = $1 =~ /[^=\s]*\s*=\s*"[^"]*"|[^=\s]*\s*=\s*'[^']*'|[^=\s]*\s*=[^\s]*/g;
        my @rel = grep { /^rel\s*=/i } @attr;
        my $rel;
        $rel = pop @rel if @rel;
        if ($rel) {
            $rel =~ s/^(rel\s*=\s*['"]?)/$1nofollow /i;
        } else {
            $rel = 'rel="nofollow"';
        }
        @attr = grep { !/^rel\s*=/i } @attr;
        '<a ' . (join ' ', @attr) . ' ' . $rel . '>';
    #xieg;
    $str;
}

1;
