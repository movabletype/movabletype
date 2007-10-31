# Widget Manager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package WidgetManager::CMS;

use strict;

sub plugin {
    return MT->component('WidgetManager');
}

sub _permission_check {
    my $app = MT->instance;
    return ($app->{perms} && $app->{perms}->can_edit_templates);
}

sub save {
    warn 'Calling save...' if $MT::DebugMode;
    my $app = shift;

    return $app->error($app->translate('Permission denied.'))
        unless _permission_check();

    my $q = $app->param();

    my $blog_id = $q->param('blog_id');

    my $str = build_module_list($q->param('modules'));
    warn 'Saving modules to blog #'.$blog_id.": $str" if $MT::DebugMode;

    # Load the current widgetmanager data
    my $current = $q->param('widgetmanager') || '';
    $current = $q->param('name') if $current eq 'New Widget Manager';
    my $modulesets = plugin()->load_selected_modules($blog_id);
    $modulesets = {} unless $modulesets;

    # delete old set
    delete $modulesets->{$q->param('widgetmanager') || ''};
    # Handle renaming: Delete the entry that has changed names.
    delete $modulesets->{$q->param('old_name')}; # unless $q->param('old_name') eq $q->param('name');
    if(exists $modulesets->{$q->param('name')}) {
        return $app->error($app->translate(
            "Can't duplicate the existing '[_1]' Widget Manager. Please go back and enter a unique name.",
            $q->param('name')))
    }
    # add it back with a potential new name
    $modulesets->{$q->param('name')} = $str;

    plugin()->set_config_value('modulesets',$modulesets,"blog:$blog_id");

    return list($app, rebuild => 1);
}

sub delete {
    warn 'Calling delete...' if $MT::DebugMode;
    my $app = shift;

    return $app->error($app->translate('Permission denied.'))
        unless _permission_check();

    my $q = $app->param();
    my $blog_id = $q->param('blog_id');

    my $modulesets = plugin()->load_selected_modules($blog_id);
    $modulesets = {} unless $modulesets;

    my @ids = $q->param('id');
    delete $modulesets->{$_} for @ids;

    plugin()->set_config_value('modulesets',$modulesets,"blog:$blog_id");
    
    return list($app, deleted => 1);
}

sub edit {
    warn 'Calling edit...' if $MT::DebugMode;
    my $app = shift;
    my (%opt) = @_;

    return $app->error($app->translate('Permission denied.'))
        unless _permission_check();

      install_default_widgets(1);

      my $q = $app->param();
      my $blog_id = $q->param('blog_id');

      my $tmpl = $app->load_tmpl('edit.tmpl');
      $tmpl->param('blog_id'  => $blog_id);
      $app->add_breadcrumb($app->translate('Main Menu'),$app->{mtscript_url});
      require MT::Blog;
      my $blog = MT::Blog->load ($blog_id);
      $app->add_breadcrumb($blog->name, $app->mt_uri(mode => 'menu', args => { blog_id => $blog_id }));
      $app->add_breadcrumb($app->translate('Widget Manager'),'?__mode=list_widget&blog_id='.$blog_id);
      $app->add_breadcrumb($q->param('widgetmanager'));

      my $modulesets = plugin()->load_selected_modules($blog_id);
      $modulesets = {} unless $modulesets;

      my @names = sort keys %$modulesets;
      my $widgetmanager = $q->param('widgetmanager') || $names[0] || '';

      my @selected = split(',',$modulesets->{$widgetmanager});

      my %constraints;
      $constraints{blog_id} = $blog_id;
      $constraints{type}    = 'widget';
      my %options;
      $options{sort}      = 'name';
      $options{direction} = 'ascend';
      require MT::Template;
      my $iter = MT::Template->load_iter( \%constraints, \%options );
      my @avail_modules;
      my @inst_modules;
      while (my $m = $iter->()) {
          my $name = $m->name();
          push @avail_modules, {
            id => $m->id(),
            name => $name,
            selected => in_array($m->id,@selected),
          };
      }
      foreach my $mid (@selected) {
          for (my $i = 0; $i <= $#avail_modules; $i++) {
              if ($avail_modules[$i]->{id} == $mid) {
                  warn $app->translate("Moving [_1] to list of installed modules", $mid) if $MT::DebugMode;
                  push @inst_modules,$avail_modules[$i];
                  splice(@avail_modules,$i,1);
              }
          }
      }

      # Find non-conflicting name for new Widget Manager
      if ($widgetmanager eq 'New Widget Manager') { 
          $widgetmanager = $app->translate('Widget Manager');
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
      $tmpl->param(rebuild           => $opt{rebuild});
      # return plugin()->l10n_filter($tmpl->output);
      local $app->{defer_build_page} = 0;
      return $app->build_page($tmpl);
}

sub list {
    my $app = shift;
    warn 'Calling list...' if $MT::DebugMode;
    my (%opt) = @_;

    return $app->return_to_dashboard(redirect => 1)
        unless $app->param('blog_id');

    return $app->return_to_dashboard(permission => 1)
        unless _permission_check();

      my $q = $app->{query};
      my $blog_id = $q->param('blog_id');

      my $tmpl = $app->load_tmpl('list.tmpl');
      $tmpl->param('blog_id'  => $blog_id);
      $app->add_breadcrumb($app->translate("Main Menu"),$app->{mtscript_url});
      require MT::Blog;
      my $blog = MT::Blog->load ($blog_id);
      $app->add_breadcrumb($blog->name,$app->mt_uri( mode => 'menu', args => { blog_id => $blog_id }));
      $app->add_breadcrumb($app->translate("Widget Manager"));

      install_default_widgets() unless installed();

      my $modulesets = plugin()->load_selected_modules($blog_id) || {};

      my (%constraints, %options);
      $constraints{blog_id} = $blog_id;
      $constraints{type}    = 'widget';
      $options{sort}        = 'name';
      $options{direction}   = 'ascend';

      require MT::Template;
      my $iter = MT::Template->load_iter( \%constraints, \%options );
      my %avail;
      while (my $m = $iter->()) {
          my $name = $m->name();
          $avail{$m->id()} = $name;
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
    if ($widgetmanager eq 'New Widget Manager') {
        $widgetmanager = $q->param('name');
    }

    $tmpl->param(widgetmanagers => \@widgetmanagers);

    $app->{breadcrumbs}[-1]{is_last} = 1;
    $tmpl->param(breadcrumbs       => $app->{breadcrumbs});
    $tmpl->param(plugin_version    => $MT::Plugin::WidgetManager::VERSION);
    $tmpl->param(rebuild           => $opt{rebuild});
    $tmpl->param(deleted           => $opt{deleted});
    local $app->{defer_build_page} = 0;
    return $app->build_page($tmpl);
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
    my($name, $text) = @_;
    my $app = MT->instance;
    require MT::Template;
    my $tmpl = MT::Template->new;
    $tmpl->blog_id($app->blog->id);
    $tmpl->type('widget');
    $tmpl->name($app->translate($name));
    $tmpl->text($app->translate_templatized($text));
    $tmpl->save;
    return $tmpl;
}

sub install_default_widgets {
    my $app = MT->instance;
    my $reinstall = shift;
    my $blog_id = $app->blog->id;
    my @preinstalled;
    my ($tmpl,$default_widget_templates);

    # Gather the existing modules.
    my $modules = {};
    require MT::Template;
    for ( MT::Template->load({ blog_id => $blog_id, type => 'widget' }) ) {
        my $name = $_->name();
        $modules->{$name} = $_->linked_file();  # XXX The linked_file is undef for this plugin modules for some reason.
    }

    use File::Spec;
    my $widgets_dir = File::Spec->catfile(plugin()->{full_path}, 'default_widgets');
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
        next if exists $modules->{$app->translate($_->{name})};
        open(TMPL, File::Spec->catfile($widgets_dir, $_->{template})) or die "Error: $!\n";
        while (my $line = <TMPL>) {
            $_->{text} .= $line;
        }
        close TMPL;
        $tmpl = install_module($_->{name}, $_->{text});
        push @preinstalled, $tmpl->id;
    }

    unless( $reinstall ) {
        # Set the 'installed' bit in the config
        installed(1);

        # Now that the plugin is installed for this blog, create a first widgetmanager
        # with all modules pre-installed.

        my $modulesets = {};
        $modulesets->{$app->translate('First Widget Manager')} = join (',', @preinstalled);

        plugin()->set_config_value('modulesets',$modulesets,"blog:$blog_id");
    }
}

sub installed {
    my $config = {};
    my $app = MT->instance;
    my $blog_id = $app->param('blog_id');

    my $plugin = plugin();
    if (@_) {
        # Set the installed bit, save and return
        return $plugin->set_config_value('installed',1,"blog:$blog_id");
    } else {
        # Return early if status check
        return $plugin->get_config_value('installed',"blog:$blog_id");
    }
}

1;
