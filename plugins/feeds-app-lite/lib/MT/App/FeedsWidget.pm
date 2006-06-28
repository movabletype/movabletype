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
    $app->{help_url} = File::Spec->catdir($app->static_path, 'plugins', 
                        'feeds-app-lite', 'docs', 'index.html');
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
    $p->{help_url} = $app->{help_url};
    $app->add_breadcrumb("Main Menu", $app->mt_uri);
    $app->add_breadcrumb($blog->name, $app->mt_uri(mode => 'menu', args => { blog_id => $blog_id }));
    $app->add_breadcrumb('Templates', $app->mt_uri(mode => 'list', args => { _type => 'template', blog_id => $blog_id }));
    $app->add_breadcrumb('Feeds.App Lite', 'index.cgi');

    $app->{breadcrumbs}[-1]{is_last} = 1;
    $p->{breadcrumbs} = $app->{breadcrumbs};
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
        if ($app->wm_url) {
	    $p->{wm_url} = $app->wm_url . '?blog_id=' . $blog_id;
	    $p->{wm_is} = 1;
        }
        $app->add_breadcrumb("Main Menu", $app->mt_uri);
        $app->add_breadcrumb($blog->name, $app->mt_uri(mode => 'menu', args => { blog_id => $blog_id }));
        $app->add_breadcrumb('Templates', $app->mt_uri(mode => 'list', args => { _type => 'template', blog_id => $blog_id }));
        $app->add_breadcrumb('Feeds.App Lite', 'index.cgi');
        return $app->build_page("msg.tmpl", $p);
    } elsif (@feeds == 1) {    # skip to the next step if only one choice
        my $redirect = $app->app_uri;
        $redirect .= "?__mode=config&blog_id=$blog_id";
        $redirect .= '&uri=' . MT::Util::encode_url($feeds[0]->{uri});
        return $app->redirect($redirect);
    }
    MT::Util::mark_odd_rows(\@feeds);
    $p->{feeds} = \@feeds;
    $p->{help_url} = $app->{help_url};
    $app->add_breadcrumb("Main Menu", $app->mt_uri);
    $app->add_breadcrumb($blog->name, $app->mt_uri(mode => 'menu', args => { blog_id => $blog_id }));
    $app->add_breadcrumb('Templates', $app->mt_uri(mode => 'list', args => { _type => 'template', blog_id => $blog_id }));
    $app->add_breadcrumb('Feeds.App Lite', 'index.cgi');
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
        $app->add_breadcrumb("Main Menu", $app->mt_uri);
        $app->add_breadcrumb($blog->name, $app->mt_uri(mode => 'menu', args => { blog_id => $blog_id }));
        $app->add_breadcrumb('Templates', $app->mt_uri(mode => 'list', args => { _type => 'template', blog_id => $blog_id }));
        $app->add_breadcrumb('Feeds.App Lite', 'index.cgi');
        if ($app->wm_url) {
	    $p->{wm_url} = $app->wm_url . '?blog_id=' . $blog_id;
	    $p->{wm_is} = 1;
        }
        return $app->build_page("msg.tmpl", $p);
    }
    $p->{feed_title} = $feed->find_title($feed->feed) || $uri;
    $p->{feed_uri} = $uri;
    $p->{help_url} = $app->{help_url};    
    $app->add_breadcrumb("Main Menu", $app->mt_uri);
    $app->add_breadcrumb($blog->name, $app->mt_uri(mode => 'menu', args => { blog_id => $blog_id }));
    $app->add_breadcrumb('Templates', $app->mt_uri(mode => 'list', args => { _type => 'template', blog_id => $blog_id }));
    $app->add_breadcrumb('Feeds.App Lite', 'index.cgi');
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
    # XXX Hack-truncate feed widget title to the magic literal of 42 characters.
    $title = substr $title, 0, 42;
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
<div class="module-feed module">
<div class="module-content">
<MTFeed uri="$uri">
<h2 class="module-header">$title</h2>
<ul><MTFeedEntries$lastn>
<li><a href="<MTFeedEntryLink>"><MTFeedEntryTitle encode_html="1"></a></li>
</MTFeedEntries></ul>
</MTFeed>
</div>
</div>
TEXT
    $tmpl->text($txt);
    $tmpl->save or return $app->error($tmpl->errstr);
    $p->{module}     = $name;
    $p->{module_id}  = $tmpl->id;
    $p->{saved}      = 1;
    $p->{wizard_uri} = $app->uri . '?blog_id=' . $blog_id;
    $p->{uri}        = $uri;
    $app->add_breadcrumb("Main Menu", $app->mt_uri);
    $app->add_breadcrumb($blog->name, $app->mt_uri(mode => 'menu', args => { blog_id => $blog_id }));
    $app->add_breadcrumb('Templates', $app->mt_uri(mode => 'list', args => { _type => 'template', blog_id => $blog_id }));
    $app->add_breadcrumb('Feeds.App Lite', 'index.cgi');
    if ($app->wm_url) {
        $p->{wm_url} = $app->wm_url . '?blog_id=' . $blog_id;
        $p->{wm_is} = 1;
    }
    $p->{help_url} = $app->{help_url};
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
    return 0;
}

1;
