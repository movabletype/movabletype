# Widget Manager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package WidgetManager::App;

use strict;
use Data::Dumper;
use vars qw( $DEBUG );
use MT::App;
@WidgetManager::App::ISA = qw( MT::App );
use lib 'plugins/WidgetManager/lib';
use WidgetManager::Util;

sub init {
    my $app = shift;
    my %param = @_;
    $app->SUPER::init(%param) or return;

    WidgetManager::Util::debug('Initializing Widget Manager');
    $app->add_methods(
    	      'list'   => \&list,
		      'edit'   => \&edit,
		      'delete' => \&delete,
		      'save'   => \&save,
    );

    $app->{default_mode}   = 'list';
    $app->{user_class}     = 'MT::Author';
    $app->{requires_login} = 1;

    $app->{mtscript_url}   = ($app->{cfg}->AdminCGIPath ? $app->{cfg}->AdminCGIPath : $app->{cfg}->CGIPath) . $app->{cfg}->AdminScript;
    $app->{mmscript_url}   = $app->path . $app->{cfg}->AdminScript;
    $app->{script_url} = $app->{cfg}->CGIPath . 'plugins/WidgetManager/widget-manager.cgi';

    WidgetManager::Util::debug('Finished initializing Widget Manager.');
    return $app;
}

sub init_tmpl {
    my $app = shift;
    WidgetManager::Util::debug('Initializing template file.','  >');
    WidgetManager::Util::debug('Calling MT::App::load_tmpl('.join(', ',@_).')','    >');
    my $tmpl = $app->load_tmpl(@_);
    if (!$tmpl) {
        my $err = $app->plugin->translate("Loading template '[_1]' failed: [_2]", $_[0], $@);
        WidgetManager::Util::debug($err,'    >');
        return $app->error($err);
    }
    else {
        WidgetManager::Util::debug('Template file successfully loaded.','    >');
    }

    require MT::App::CMS;
    MT::App::CMS::is_authorized($app);
    if (my $perms = $app->{perms}) {
        $tmpl->param(can_post => $perms->can_post);
        $tmpl->param(can_upload => $perms->can_upload);
        $tmpl->param(can_edit_entries =>
            $perms->can_post || $perms->can_edit_all_posts);
        $tmpl->param(can_search_replace => $perms->can_edit_all_posts);
        $tmpl->param(can_edit_templates => $perms->can_edit_templates);
        $tmpl->param(can_edit_authors => $perms->can_administer_blog);
        $tmpl->param(can_edit_config => $perms->can_edit_config);
        # FIXME: once we have edit_commenters permission
        $tmpl->param(can_edit_commenters => $perms->can_edit_config());
        $tmpl->param(can_rebuild => $perms->can_rebuild);
        $tmpl->param(can_edit_categories => $perms->can_edit_categories);
        $tmpl->param(can_edit_notifications => $perms->can_edit_notifications);
        $tmpl->param(has_manage_label =>
            $perms->can_edit_templates  || $perms->can_administer_blog ||
            $perms->can_edit_categories || $perms->can_edit_config);
        $tmpl->param(has_posting_label =>
            $perms->can_post  || $perms->can_edit_all_posts ||
            $perms->can_upload);
        $tmpl->param(has_community_label =>
            $perms->can_post  || $perms->can_edit_config ||
            $perms->can_edit_notifications || $perms->can_edit_all_posts);
        $tmpl->param(can_view_log => $perms->can_view_blog_log);
    }

    my $apppath = $app->{__path} || '';

    my $spath = $app->{cfg}->StaticWebPath || $app->path.'mt-static/';
    $spath =~ s/\/*$/\//g;

    my $enc = $app->{cfg}->PublishCharset || $app->language_handle->encoding;

    $tmpl->param(plugin_name       => 'Widget Manager');
    $tmpl->param(plugin_version    => $MT::Plugin::WidgetManager::VERSION);
    $tmpl->param(plugin_author     => 'Six Apart');
    $tmpl->param(mt_url            => $app->{mtscript_url});
    $tmpl->param(mtscript_url      => $app->{mtscript_url});
    $tmpl->param(mmscript_url      => $app->{mmscript_url});
    $tmpl->param(static_uri        => $spath);
    $tmpl->param(script_url        => File::Spec->catdir($apppath,'widget-manager.cgi'));
    $tmpl->param(blog_url          => $app->blog->site_url);
    if (my $lang_id = $app->current_language) {
        $tmpl->param(local_lang_id => lc $lang_id) if $lang_id !~ m/^en/i;
    }
    $tmpl->param(page_titles       => [ reverse @{ $app->{breadcrumbs} } ]);
    $tmpl->param(nav_widgetmanager => 1);

    WidgetManager::Util::debug('MT Script URL: '.$tmpl->param('mtscript_url'),'    >');

    WidgetManager::Util::debug('Finished initializing template file.','  >');
    return $tmpl;
}

sub _permission_check {
    my $app = shift;
    require MT::App::CMS;
    MT::App::CMS::is_authorized($app);
    return ($app->{perms} && $app->{perms}->can_edit_templates);
}

sub save {
    WidgetManager::Util::debug('Calling save...');
    my $app = shift;

    return $app->error($app->plugin->translate('Permission denied.'))
        unless $app->_permission_check;

    my $q = $app->{query};

    my $blog_id = $q->param('blog_id');

    my $str = build_module_list($q->param('modules'));
    WidgetManager::Util::debug('Saving modules to blog #'.$blog_id.": $str");

    # Load the current widgetmanager data
    my $current = $q->param('widgetmanager');
    $current = $q->param('name') if $current eq 'New Widget Manager';
    require WidgetManager::Plugin;
    my $modulesets = $app->plugin->load_selected_modules($blog_id);
    # my $modulesets = WidgetManager::Plugin::load_selected_modules($blog_id);
    $modulesets = {} unless $modulesets;

    # delete old set
    delete $modulesets->{$q->param('widgetmanager')};
    # Handle renaming: Delete the entry that has changed names.
    delete $modulesets->{$q->param('old_name')} unless $q->param('old_name') eq $q->param('name');
    if(exists $modulesets->{$q->param('name')}) {
        return $app->error($app->plugin->translate(
            "Can't duplicate the existing '[_1]' Widget Manager. Please go back and enter a unique name.",
            $q->param('name')))
    }
    # add it back with a potential new name
    $modulesets->{$q->param('name')} = $str;

    $app->plugin->set_config_value('modulesets',$modulesets,"blog:$blog_id");

    $app->{rebuild} = 1;
    return $app->list();
}

sub delete {
    WidgetManager::Util::debug('Calling delete...');
    my $app = shift;

    return $app->error($app->plugin->translate('Permission denied.'))
        unless $app->_permission_check;

    my $q = $app->{query};
    my $blog_id = $q->param('blog_id');

    my $modulesets = $app->plugin->load_selected_modules($blog_id);
    $modulesets = {} unless $modulesets;

    my @ids = $q->param('id');
    delete $modulesets->{$_} for @ids;

    $app->plugin->set_config_value('modulesets',$modulesets,"blog:$blog_id");
    
    $app->{deleted} = 1;
    return $app->list();
}

sub edit {
    WidgetManager::Util::debug('Calling edit...');
    my $app = shift;

    return $app->error($app->plugin->translate('Permission denied.'))
        unless $app->_permission_check;

      $app->install_default_widgets(1);

      my $q = $app->{query};
      my $blog_id = $q->param('blog_id');

      my $tmpl = $app->init_tmpl('edit.tmpl');
      $tmpl->param('blog_id'  => $blog_id);
      $app->add_breadcrumb($app->plugin->translate('Main Menu'),$app->{mtscript_url});
      $app->add_breadcrumb($app->plugin->translate('Widget Manager'),'?__mode=list&blog_id='.$blog_id);
      $app->add_breadcrumb($q->param('widgetmanager'));

      my $modulesets = $app->plugin->load_selected_modules($blog_id);
      $modulesets = {} unless $modulesets;

      my @names = sort keys %$modulesets;
      my $widgetmanager = $q->param('widgetmanager') || $names[0] || '';

      my @selected = split(',',$modulesets->{$widgetmanager});

      my %constraints;
      $constraints{blog_id} = $blog_id;
      $constraints{type}    = 'custom';
      my %options;
      $options{sort}      = 'name';
      $options{direction} = 'ascend';
      require MT::Template;
      my $iter = MT::Template->load_iter( \%constraints, \%options );
      my @avail_modules;
      my @inst_modules;
      while (my $m = $iter->()) {
          my $name = $m->name();
          if ($name =~ s/^(?:Widget|Sidebar): ?//) {
              push @avail_modules, {
                id => $m->id(),
                name => $name,
                selected => in_array($m->id,@selected),
              };
          }
      }
      foreach my $mid (@selected) {
      for (my $i = 0; $i <= $#avail_modules; $i++) {
          if ($avail_modules[$i]->{id} == $mid) {
              WidgetManager::Util::debug($app->plugin->translate("Moving [_1] to list of installed modules", $mid));
              push @inst_modules,$avail_modules[$i];
              splice(@avail_modules,$i,1);
          }
      }
      }

      # Find non-conflicting name for new Widget Manager
      if ($widgetmanager eq 'New Widget Manager') { 
          $widgetmanager = $app->plugin->translate('Widget Manager');
          if (grep(/^\Q$widgetmanager\E$/, @names)) {
              my $i = 1;
              while (grep(/^\Q$widgetmanager $i\E$/, @names)) {
                  $i++;
              }
              $widgetmanager = "$widgetmanager $i";
          }
      }

      my @widgetmanagers = map { { widgetmanager => $_ } } keys %$modulesets;
      $tmpl->param(widgetmanagers => \@widgetmanagers);

      $tmpl->param(available => \@avail_modules);
      $tmpl->param(installed => \@inst_modules);
      $tmpl->param(name      => $widgetmanager);

      $app->{breadcrumbs}[-1]{is_last} = 1;
      $tmpl->param(breadcrumbs       => $app->{breadcrumbs});
      $tmpl->param(plugin_version    => $MT::Plugin::WidgetManager::VERSION);
      $tmpl->param(rebuild           => $app->{rebuild});
      return $app->plugin->l10n_filter($tmpl->output);
}

sub list {
      WidgetManager::Util::debug('Calling list...');
      my $app = shift;

    return $app->error($app->plugin->translate('Permission denied.'))
        unless $app->_permission_check;

      my $q = $app->{query};
      my $blog_id = $q->param('blog_id');

      my $tmpl = $app->init_tmpl('list.tmpl');
      $tmpl->param('blog_id'  => $blog_id);
      $app->add_breadcrumb($app->plugin->translate("Main Menu"),$app->{mtscript_url});
      $app->add_breadcrumb($app->plugin->translate("Widget Manager"));

      $app->install_default_widgets() unless $app->installed;

      my $modulesets = $app->plugin->load_selected_modules($blog_id) || {};

      my (%constraints, %options);
      $constraints{blog_id} = $blog_id;
      $constraints{type}    = 'custom';
      $options{sort}        = 'name';
      $options{direction}   = 'ascend';
      require MT::Template;
      my $iter = MT::Template->load_iter( \%constraints, \%options );
      my %avail;
      while (my $m = $iter->()) {
          my $name = $m->name();
          if ($name =~ s/^(?:Widget|Sidebar): ?//) {
              $avail{$m->id()} = $name;
          }
      }

      my @names = sort keys %$modulesets;
      my $widgetmanager = $q->param('widgetmanager') || $names[0] || '';

      my @widgetmanagers;
      my @keys = sort keys %$modulesets;

      my $offset = $app->param('offset') || 0;
      $tmpl->param( list_start => $offset + 1 );
      $tmpl->param( list_end   => $offset + scalar @keys );

      foreach my $key (@keys) {
          # Collect the available widgets for this key.
          my @w = ();
          for my $w ( split /\s*,\s*/o, $modulesets->{$key} ) {
              push @w, $avail{$w} if $avail{$w};
          }
          push @widgetmanagers,{
            widgetmanager => $key,
            names   => join(', ', @w),
            widgets => $modulesets->{$key}
          };
      }
      if ($widgetmanager eq 'New Widget Manager') { $widgetmanager = $q->param('name'); }

      $tmpl->param(widgetmanagers => \@widgetmanagers);

      $app->{breadcrumbs}[-1]{is_last} = 1;
      $tmpl->param(breadcrumbs       => $app->{breadcrumbs});
      $tmpl->param(plugin_version    => $MT::Plugin::WidgetManager::VERSION);
      $tmpl->param(rebuild           => $app->{rebuild});
      $tmpl->param(deleted           => $app->{deleted});
      return $app->plugin->l10n_filter($tmpl->output);
}

sub build_module_list {
    my $str = shift;
    my @mods = split /;/, $str;
    my @inst;
    for (@mods) {
        my ($id, $col) = /(\d+)=(\d+)\.(\d+)/;
        push @inst, $id if $col == 1;
    }
    return join ',', @inst;
}

sub in_array {
    my ($needle, @haystack) = @_;
    for (@haystack) {
        return 1 if $_ eq $needle;
    }
    return 0;
}

sub install_module {
    my($app, $name, $text) = @_;
    require MT::Template;
    my $tmpl = MT::Template->new;
    $tmpl->blog_id($app->blog->id);
    $tmpl->type('custom');
    $tmpl->name('Widget: ' . $app->plugin->translate($name));
    $tmpl->text($app->plugin->translate_templatized($text));
    $tmpl->save;
    return $tmpl;    
}


sub install_default_widgets {
    my $app = shift;
    my $reinstall = shift;
    my $blog_id = $app->blog->id;
    my @preinstalled;
    my ($tmpl,$default_widget_templates);

    # Gather the existing modules.
    my $modules = {};
    require MT::Template;
    for( MT::Template->load({ blog_id => $blog_id, type => 'custom' }) ) {
        ( my $name = $_->name() ) =~ s/^(?:Widget|Sidebar):\s+(.*?)$/$1/;
        $modules->{$name} = $_->linked_file();  # XXX The linked_file is undef for this plugin modules for some reason.
    }

    use File::Spec;
    my $widgets_dir = File::Spec->catfile($app->app_dir, 'default_widgets');
    my $cfg_file = File::Spec->catfile($widgets_dir, 'widgets.cfg');

    local(*FH, $_, $/);
    $/ = "\n";
    open FH, $cfg_file or
        return $app->error(MT->translate(
            "Error opening file '[_1]': [_2]", $cfg_file, "$!" ));
    my $cfg = join('',<FH>);
    eval "$cfg;";
    close FH;

    foreach (@$default_widget_templates) {
        next if exists $modules->{$app->plugin->translate($_->{name})};
        open(TMPL, File::Spec->catfile($widgets_dir, $_->{template})) or die "Error: $!\n";
        while (my $line = <TMPL>) {
            $_->{text} .= $line;
        }
        close TMPL;
        $tmpl = install_module($app, $_->{name}, $_->{text});
        push @preinstalled, $tmpl->id;
    }

    unless( $reinstall ) {
        # Set the 'installed' bit in the config
        $app->installed(1);

        # Now that the plugin is installed for this blog, create a first widgetmanager
        # with all modules pre-installed.
        
        my $modulesets = {};
        $modulesets->{$app->plugin->translate('First Widget Manager')} = join (',', @preinstalled);

        $app->plugin->set_config_value('modulesets',$modulesets,"blog:$blog_id");
    }
}

sub installed {
    my $config = {};
    my $app = shift;
    my $blog_id = $app->{query}->param('blog_id');
    
    my $plugin = $app->plugin;
    if (@_) {
        # Set the installed bit, save and return
        return $plugin->set_config_value('installed',1,"blog:$blog_id");
    } else {
        # Return early if status check
        return $plugin->get_config_value('installed',"blog:$blog_id");
    }
}

sub plugin {
    return MT::Plugin::WidgetManager->instance;
}

1;
