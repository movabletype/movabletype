# Copyright 2002-2006 Appnel Internet Solutions, LLC
# This code is distributed with permission by Six Apart
package MT::FeedsLite;
use strict;

use vars qw($VERSION);
$VERSION = '1.01';

my $plugin = MT::Plugin::FeedsLite->new;
MT->add_plugin($plugin);

MT->add_plugin_action('blog',          'index.cgi?', "Create a feed widget");
MT->add_plugin_action('list_template', 'index.cgi?', "Create a feed widget");

use MT::Template::Context;

MT::Template::Context->add_container_tag(Feed => \&feed);
MT::Template::Context->add_tag(FeedTitle => \&feed_title);
MT::Template::Context->add_tag(FeedLink  => \&feed_link);
MT::Template::Context->add_container_tag(FeedEntries => \&entries);
MT::Template::Context->add_tag(FeedEntryTitle => \&entry_title);
MT::Template::Context->add_tag(FeedEntryLink  => \&entry_link);
MT::Template::Context->add_tag(FeedInclude    => \&include);

use constant LITE  => 'MT::Plugin::FeedsLite';
use constant ENTRY => 'MT::Plugin::FeedsLite::entry';

# Returns link if okay, "#" if not.
sub sanitize_link {
    my $link = shift;
    $link = '' unless defined $link;
    $link =~ s/^\s+//;
    # check for malicious protocols
    require MT::Util;
    my $dec_val = MT::Util::decode_html($link);
    $dec_val =~ s/&#0*58(?:=;|[^0-9])/:/;
    $dec_val =~ s/&#x0*3[Aa](?:=;|[^a-fA-F0-9])/:/;
    if ((my $prot) = $dec_val =~ m/^(.+?):/) {
        return "#" if $prot =~ m/[\r\n\t]/;
        $prot =~ s/\s+//gs;
        return "#" if $prot =~ m/[^a-zA-Z0-9\+]/;
        return "#" if $prot =~ m/script$/i;
    }
    return "#" unless $link =~ m/^https?:/i;
    $link;
}

sub feed {
    my ($ctx, $args, $cond) = @_;
    my $uri = $args->{uri}
      or return
      $ctx->error(
         $plugin->translate(
                       "'[_1]' is a required argument of [_2]", 'uri', 'MTFeeds'
         )
      );
    require MT::Feeds::Lite;
    my $lite = MT::Feeds::Lite->fetch($uri)
      or return '';    # or should we insert an error message in the template?
    my $entries = $lite->entries;
    $ctx->stash(LITE, $lite);
    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $html    = '';
    my $out     = $builder->build($ctx, $tokens, $cond)
      or return $ctx->error($builder->errstr);
    $ctx->stash(LITE, undef);
    $out;
}

sub feed_title {
    my ($ctx, $args) = @_;
    my $lite = $ctx->stash(LITE)
      or return _error($ctx);
    require MT::Util;
    my $title = $lite->find_title($lite->feed);
    $title = '' unless defined $title;
    $title = MT::Util::remove_html($title)
        unless (exists $args->{remove_html}) && !$args->{remove_html};
    $title = MT::Util::encode_html($title)
        unless (exists $args->{encode_html}) && !$args->{encode_html};
    delete $args->{encode_html} if exists $args->{encode_html};
    delete $args->{remove_html} if exists $args->{remove_html};
    $title;
}

sub feed_link {
    my $ctx  = shift;
    my $lite = $ctx->stash(LITE)
      or return _error($ctx);
    my $link = $lite->find_link($lite->feed);
    sanitize_link($link);
}

sub entries {
    my ($ctx, $args, $cond) = @_;
    my $lite = $ctx->stash(LITE)
      or return _error($ctx);
    my $e      = $lite->entries;
    my $offset = $args->{offset} || 0;
    my $last   =
      ($args->{lastn} && $args->{lastn} < @$e) ? $offset + $args->{lastn} : @$e;
    my $builder = $ctx->stash('builder');
    my $tokens  = $ctx->stash('tokens');
    my $html    = '';
    for (my $i = $offset ; $i < $last ; $i++) {
        $ctx->stash(ENTRY, $e->[$i]);
        my $out = $builder->build($ctx, $tokens, $cond)
          or return $ctx->error($builder->errstr);
        $html .= $out;
    }
    $ctx->stash(ENTRY, undef);
    $html;
}

sub entry_title {
    my ($ctx, $args, $cond) = @_;
    my $lite = $ctx->stash(LITE)
      or return _error($ctx);
    my $entry = $ctx->stash(ENTRY)
      or return _error($ctx);
    my $title = $lite->find_title($entry);
    $title = '' unless defined $title;
    $title = MT::Util::remove_html($title)
        unless (exists $args->{remove_html}) && !$args->{remove_html};
    $title = MT::Util::encode_html($title)
        unless (exists $args->{encode_html}) && !$args->{encode_html};
    delete $args->{encode_html} if exists $args->{encode_html};
    delete $args->{remove_html} if exists $args->{remove_html};
    $title;
}

sub entry_link {
    my $ctx  = shift;
    my $lite = $ctx->stash(LITE)
      or return _error($ctx);
    my $entry = $ctx->stash(ENTRY)
      or return _error($ctx);
    my $link = $lite->find_link($entry);
    sanitize_link($link);
}

sub include {
    my ($ctx, $args) = @_;
    my $uri = $args->{uri}
      or return
      $ctx->error(
                  $plugin->translate(
                                "'[_1]' is a required argument of [_2]", 'uri',
                                'MTFeedInclude'
                  )
      );
    my $lastn = $args->{lastn} ? ' lastn="' . $args->{lastn} . '"' : '';
    my $body  = <<BODY;
<MTFeed uri="$uri">
<h2><\$MTFeedTitle\$></h2>
<ul><MTFeedEntries$lastn>
<li><a href="<\$MTFeedEntryLink encode_html="1"\$>"><\$MTFeedEntryTitle\$></a></li>
</MTFeedEntries></ul>
</MTFeed>
BODY
    require MT::Template;
    my $t = MT::Template->new;
    my $c = MT::Template::Context->new;
    $t->blog_id($ctx->stash('blog_id'));
    $t->text($body);
    $t->build($c) or $ctx->error($t->errstr);
}

#--- utility

sub _error {
    $_[0]->error($plugin->translate('MT[_1] was not used in the proper context.',
                 $_[0]->stash('tag')));
}

package MT::Plugin::FeedsLite;
use strict;
use base qw( MT::Plugin );

sub key         { __PACKAGE__ }
sub name        { 'Feeds.App Lite' }
sub author_name { 'Appnel Solutions' }
sub author_link { 'http://www.appnel.com/' }
sub plugin_link { '' }
sub version     { $MT::FeedsLite::VERSION }
sub doc_link    { 'docs/index.html' }

sub description {
    return <<DESC;
<p class="plugin-desc"><MT_TRANS phrase="Feeds.App Lite helps you republish feeds on your blogs. Want to do more with feeds in Movable Type?"> <a href="http://code.appnel.com/feeds-app" target="_blank"><MT_TRANS phrase="Upgrade to Feeds.App"></a>.</p>
DESC
}

sub init { }

sub load_config {
    my $plugin = shift;
    my ($param, $scope) = @_;
    $plugin->SUPER::load_config(@_);
    my $blog_id = $scope;
    $blog_id =~ s{\D}{}g;
    $param->{blog_id}    = $blog_id;
    $param->{wizard_uri} = $plugin->envelope . '/index.cgi';
}

1;
