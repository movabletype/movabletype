package MT::App::FeedsWidget;
use strict;

use base qw( MT::App );

sub init {
    my $app = shift;
    $app->SUPER::init(@_) or return;
    $app->add_methods(
                      start    => \&start,
                      'select' => \&select,
                      config   => \&configuration,
                      save     => \&save
    );
    $app->{default_mode}   = 'start';
    $app->{template_dir}   = 'cms';
    $app->{plugins_dir}    = 'feeds-app-lite';
    $app->{requires_login} = 1;
    $app->{user_class}     = 'MT::Author';
    $app;
}

sub start {
    my $app     = shift;
    my $blog_id = $app->param('blog_id')
      or return $app->error('blog_id is required.');
    my $blog = MT::Blog->load($blog_id)
      or return $app->error(MT::Blog->errstr);
    my $p = {blog_id => $blog_id, site_url => $blog->site_url};
    $p->{need_uri} = $app->param('need_uri');
    $app->build_page("start.tmpl", $p);
}

sub select {
    my $app     = shift;
    my $blog_id = $app->param('blog_id')
      or return $app->error('blog_id is required.');
    my $blog = MT::Blog->load($blog_id)
      or return $app->error(MT::Blog->errstr);
    my $uri = $app->param('uri')
      or return $app->redirect($app->app_uri . "?blog_id=$blog_id&need_uri=1");
    $uri = 'http://' . $uri unless $uri =~ m{^https?://};
    require MT::Util;
    my $p = {blog_id => $blog_id, site_url => $blog->site_url};
    require MT::Feeds::Find;
    my @feeds = MT::Feeds::Find->find($uri);
    unless (@feeds) {
        $p->{not_found}  = 1;
        $p->{wizard_uri} = $app->uri . '?blog_id=' . $blog_id;
        $p->{uri}        = $uri;	
        $p->{wm_url}     = $app->wm_url . '?blog_id=' . $blog_id;
        return $app->build_page("msg.tmpl", $p);
    } elsif (@feeds == 1) {    # skip to the next step if only one choice
        my $redirect = $app->app_uri;
        $redirect .= "?__mode=config&blog_id=$blog_id";
        $redirect .= '&uri=' . MT::Util::encode_url($feeds[0]->{uri});
        return $app->redirect($redirect);
    }
    MT::Util::mark_odd_rows(\@feeds);
    $p->{feeds} = \@feeds;
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
      return $app->redirect($app->app_uri . "?__mode=select&blog_id=$blog_id");
    my $p = {blog_id => $blog_id, site_url => $blog->site_url};
    require MT::Feeds::Lite;
    my $feed = MT::Feeds::Lite->fetch($uri);
    unless ($feed) {
        $p->{feederr}    = 1;
        $p->{wizard_uri} = $app->uri . '?blog_id=' . $blog_id;
        $p->{uri}        = $uri;
        $p->{wm_url}     = $app->wm_url . '?blog_id=' . $blog_id;
        return $app->build_page("msg.tmpl", $p);
    }
    $p->{feed_title} = $feed->find_title($feed->feed) || $uri;
    $p->{feed_uri} = $uri;
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
      return $app->redirect($app->app_uri . "?__mode=config&blog_id=$blog_id");
    my $lastn = $app->param('lastn');
    my $title = $app->param('feed_title');
    my $p     = {blog_id => $blog_id, site_url => $blog->site_url};
    my $name  = "Widget: $title";
    require MT::Template;
    my $i;
    map { $_->remove } MT::Template->load({blog_id => '', type => 'custom'});
    while (
           MT::Template->load(
                          {blog_id => $blog_id, name => $name, type => 'custom'}
           )
      ) {
        $i++;
        $name = "Widget: $title $i";
    }
    my $tmpl = MT::Template->new;
    $tmpl->blog_id($blog_id);
    $tmpl->name($name);
    $tmpl->type('custom');
    $lastn = " lastn=\"$lastn\"" if $lastn;
    $title = MT::Util::encode_html($title);
    my $txt = <<TEXT;
<MTFeeds uri="$uri">
<h2>$title</h2>
<ul><MTFeedEntries$lastn>
<li><a href="<MTFeedEntryLink>"><MTFeedEntryTitle encode_html="1"></a></li>
</MTFeedEntries></ul>
</MTFeeds>
TEXT
    $tmpl->text($txt);
    $tmpl->save or return $app->error($tmpl->errstr);
    $p->{module}     = $name;
    $p->{saved}      = 1;
    $p->{wizard_uri} = $app->uri . '?blog_id=' . $blog_id;
    $p->{uri}        = $uri;
    $p->{wm_url}     = $app->wm_url . '?blog_id=' . $blog_id;
    $app->build_page("msg.tmpl", $p);
}

sub wm_url {
    my $app = shift;
    eval { require WidgetManager::App; };
    # if { MT::Plugin::WidgetManager::VERSION } is better

    unless ($@) {
        my $wm = WidgetManager::App->new( Directory => $app->config_dir );
        return $wm->{script_url};
    }
}

1;
