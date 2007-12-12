# Copyright 2002-2006 Appnel Internet Solutions, LLC
# This code is distributed with permission by Six Apart
package FeedsWidget::CMS;

use strict;
use MT::I18N qw( encode_text );

sub start {
    my $app     = shift;
    my $blog_id = $app->param('blog_id')
      or return $app->error('blog_id is required.');
    my $blog = MT::Blog->load($blog_id)
      or return $app->error(MT::Blog->errstr);
    my $p = {blog_id => $blog_id, site_url => $blog->site_url};
    $p->{need_uri} = $app->param('need_uri');
    $p->{help_url} = $app->{help_url};
    $app->build_page("start.tmpl", $p);
}

sub select {
    my $app     = shift;
    my $blog_id = $app->param('blog_id')
      or return $app->error('blog_id is required.');
    my $blog = MT::Blog->load($blog_id)
      or return $app->error(MT::Blog->errstr);
    my $uri = $app->param('uri');
    unless ($uri) {
        $app->add_return_arg(__mode => 'feedswidget_start', blog_id => $blog_id, need_uri => 1);
        return $app->call_return();
    }
    $uri = 'http://' . $uri unless $uri =~ m{^https?://};
    require MT::Util;
    my $p = {blog_id => $blog_id, site_url => $blog->site_url};
    require MT::Feeds::Find;
    my @feeds = MT::Feeds::Find->find($uri);
    unless (@feeds) {
        $p->{not_found}  = 1;
        $p->{wizard_uri} = $app->uri( mode => "feedswidget_select", args => { blog_id => $blog_id });
        $p->{uri}        = $uri;
        if (my $url = wm_url($app, $blog_id)) {
            $p->{wm_url} = $url;
            $p->{wm_is}  = 1;
        }
        return $app->build_page("msg.tmpl", $p);
    } elsif (@feeds == 1) {    # skip to the next step if only one choice
        my $redirect = $app->uri( mode => "feedswidget_config", args => { blog_id => $blog_id, uri => $feeds[0]->{uri} });
        return $app->redirect($redirect);
    }
    MT::Util::mark_odd_rows(\@feeds);
    $p->{feeds}    = \@feeds;
    $p->{help_url} = $app->{help_url};
    $app->build_page("select.tmpl", $p);
}

sub configuration {
    my $app     = shift;
    my $blog_id = $app->param('blog_id')
      or return $app->error('blog_id is required.');
    my $blog = MT::Blog->load($blog_id)
      or return $app->error(MT::Blog->errstr);
    my $uri = $app->param('uri')
      or
      return $app->redirect($app->uri( mode => "feedswidget_select", args => { blog_id => $blog_id }));
    my $p = {blog_id => $blog_id, site_url => $blog->site_url};
    require MT::Feeds::Lite;
    my $feed = MT::Feeds::Lite->fetch($uri);
    unless ($feed) {
        $p->{feederr}    = 1;
        $p->{wizard_uri} = $app->uri( mode => "feedswidget_select", args => { blog_id => $blog_id });
        $p->{uri}        = $uri;
        if (my $url = wm_url($app, $blog_id)) {
            $p->{wm_url} = $url;
            $p->{wm_is}  = 1;
        }
        return $app->build_page("msg.tmpl", $p);
    }
    my $title = $feed->find_title($feed->feed);
    my $enc = MT->config->PublishCharset;
    $title = encode_text(MT::I18N::utf8_off($title), 'utf-8', $enc);
    require MT::Util;
    $title = MT::Util::remove_html($title);
    $p->{feed_title} = $title || $uri;
    $p->{feed_uri}   = $uri;
    $p->{help_url}   = $app->{help_url};
    $app->build_page("config.tmpl", $p);
}

sub save {
    my $app     = shift;
    my $blog_id = $app->param('blog_id')
      or $app->error('blog_id is required.');
    my $blog = MT::Blog->load($blog_id)
      or return $app->error(MT::Blog->errstr);
    my $uri = $app->param('uri')
      or
      return $app->redirect($app->uri( mode => "feedswidget_config", args => { blog_id => $blog_id }));
    my $lastn = $app->param('lastn');
    my $title = $app->param('feed_title') || $uri;

    my $p = {blog_id => $blog_id, site_url => $blog->site_url};
    # $title here is unknown length, so trim resulting template name to
    # 255 bytes, which is the size of the template name field.
    my $name = substr($title, 0, 255);
    require MT::Template;
    my $i = 0;
    while (
           MT::Template->load(
                          {blog_id => $blog_id, name => $name, type => 'widget'}
           )
      ) {
        $i++;
        my $suffix = " $i";
        $name = substr($title, 0, 255 - length($suffix));
        $name .= $suffix;
    }
    my $tmpl = MT::Template->new;
    $tmpl->blog_id($blog_id);
    $tmpl->name($name);
    $tmpl->type('widget');
    $lastn = " lastn=\"$lastn\"" if $lastn;
    $title = MT::Util::encode_html($title);
    my $txt = <<TEXT;
<div class="widget-feed widget">
<MTFeed uri="$uri">
<h3 class="widget-header">$title</h3>
<div class="widget-content">
<ul><MTFeedEntries$lastn>
<li><a href="<\$MTFeedEntryLink encode_html="1"\$>"><\$MTFeedEntryTitle\$></a></li>
</MTFeedEntries></ul>
</div>
</MTFeed>
</div>
TEXT
    $tmpl->text($txt);
    $tmpl->save or return $app->error($tmpl->errstr);
    $p->{module}     = $name;
    $p->{module_id}  = $tmpl->id;
    $p->{saved}      = 1;
    $p->{wizard_uri} = $app->uri( mode => "feedswidget_select", args => { blog_id => $blog_id });
    $p->{uri}        = $uri;
    if (my $url = wm_url($app, $blog_id)) {
        $p->{wm_url} = $url;
        $p->{wm_is}  = 1;
    }
    $p->{help_url} = $app->{help_url};
    $app->build_page("msg.tmpl", $p);
}

sub wm_url {
    my $app = shift;
    my ($blog_id) = @_;
    return undef unless $app->component('WidgetManager');
    return $app->uri(mode => 'list_widget', args => { blog_id => $blog_id });
}

1;
