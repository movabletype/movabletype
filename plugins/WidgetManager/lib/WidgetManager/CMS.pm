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
    return ($app->user && $app->user->blog_perm($app->param('blog_id'))->can_edit_templates);
}

sub save {
    my $app = shift;

    return $app->error($app->translate('Permission denied.'))
        unless _permission_check();

    my $q = $app->param();

    my $blog_id = scalar $q->param('blog_id');

    my $str = build_module_list($q->param('modules'));

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

    return $app->redirect( $app->uri( mode => 'list_widget', args => { blog_id => $blog_id, rebuild => 1 } ) );
}

sub delete {
    my $app = shift;

    return $app->error($app->translate('Permission denied.'))
        unless _permission_check();

    my $q = $app->param();
    my $blog_id = scalar $q->param('blog_id');

    my $modulesets = plugin()->load_selected_modules($blog_id);
    $modulesets = {} unless $modulesets;

    my @ids = $q->param('id');
    delete $modulesets->{$_} for @ids;

    plugin()->set_config_value('modulesets',$modulesets,"blog:$blog_id");
    
    return $app->redirect( $app->uri( mode => 'list_widget', args => { blog_id => $blog_id, deleted => 1 } ) );
}

sub edit {
    my $app = shift;
    my (%opt) = @_;

    return $app->error($app->translate('Permission denied.'))
        unless _permission_check();

      my $q = $app->param();
      my $blog_id = scalar $q->param('blog_id');

      install_default_widgets($blog_id, 1);

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

      # Find non-conflicting name for new Widget Manager
      if ($widgetmanager eq $app->translate('New Widget Set')) { 
          $widgetmanager = $app->translate('Widget Manager');
          if (grep(/^\Q$widgetmanager\E$/, @names)) {
              my $i = 1;
              while (grep(/^\Q$widgetmanager $i\E$/, @names)) {
                  $i++;
              }
              # $widgetmanager = "$widgetmanager $i";
              $widgetmanager = "";
          }
      }

      my @selected = exists($modulesets->{$widgetmanager})
        ? split(/\s*,\s*/,$modulesets->{$widgetmanager})
        : ();

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
                  push @inst_modules,$avail_modules[$i];
                  splice(@avail_modules,$i,1);
              }
          }
      }

      my @widgetmanagers = map { { widgetmanager => $_ } } keys %$modulesets;
      $tmpl->param(object_loop => \@widgetmanagers);

      $tmpl->param(available => \@avail_modules);
      $tmpl->param(installed => \@inst_modules);
      $tmpl->param(name      => $widgetmanager);

      $app->{breadcrumbs}[-1]{is_last} = 1;
      $tmpl->param(breadcrumbs       => $app->{breadcrumbs});
      $tmpl->param(plugin_version    => $MT::Plugin::WidgetManager::VERSION);
      $tmpl->param(rebuild           => $opt{rebuild});
      return $app->build_page($tmpl);
}

sub list {
    my $app = shift;
    my (%opt) = @_;

    return $app->return_to_dashboard(redirect => 1)
        unless $app->param('blog_id');

    return $app->return_to_dashboard(permission => 1)
        unless _permission_check();

      my $q = $app->{query};
      my $blog_id = scalar $q->param('blog_id');

      my $tmpl = $app->load_tmpl('list.tmpl');
      $tmpl->param('blog_id'  => $blog_id);
      $app->add_breadcrumb($app->translate("Main Menu"),$app->{mtscript_url});
      require MT::Blog;
      my $blog = MT::Blog->load ($blog_id);
      $app->add_breadcrumb($blog->name,$app->mt_uri( mode => 'menu', args => { blog_id => $blog_id }));
      $app->add_breadcrumb($app->translate("Widget Manager"));

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
          for my $w ( split /\s*,\s*/, $modulesets->{$key} ) {
              push @w, $avail{$w} if $avail{$w};
          }
          push @widgetmanagers,{
            widgetmanager => $key,
            names   => join(',', @w),
            widgets => $modulesets->{$key}
          };
    }
    if ($widgetmanager eq 'New Widget Manager') {
        $widgetmanager = $q->param('name');
    }

    $tmpl->param(object_loop => \@widgetmanagers);
    $tmpl->param(object_type => "widgetset");

    $app->{breadcrumbs}[-1]{is_last} = 1;
    $tmpl->param(breadcrumbs       => $app->{breadcrumbs});
    $tmpl->param(plugin_version    => $MT::Plugin::WidgetManager::VERSION);
    $tmpl->param(rebuild           => $app->param('rebuild') || 0);
    $tmpl->param(deleted           => $app->param('deleted') || 0);
    $tmpl->param(listing_screen => 1);
    $tmpl->param(screen_id => "list-widget-set");
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
    my($blog_id, $name, $text) = @_;
    my $app = MT->instance;
    require MT::Template;
    my $tmpl = MT::Template->new;
    $tmpl->blog_id($blog_id);
    $tmpl->type('widget');
    $tmpl->name($app->translate($name));
    $tmpl->text($app->translate_templatized($text));
    $tmpl->save;
    return $tmpl;
}

sub create_default_widgetsets {
    my $app = MT->instance;
    my ($blog_id) = @_;

    my ( %constraints, %options );
    $constraints{blog_id} = $blog_id;
    $constraints{type}    = 'widget';
    $options{sort}        = 'name';
    $options{direction}   = 'ascend';

    require MT::Template;
    my $iter = MT::Template->load_iter( \%constraints, \%options );
    my %widgets;
    while ( my $tmpl = $iter->() ) {
        my $name = $tmpl->name();
        $widgets{$name} = $tmpl->id();
    }

    my $widgetsets = [
        {
            label   => '2-column layout - Sidebar',
            widgets => [
                'Search',
                'About This Page',
                'Home Page Widgets Group',
                'Archive Widgets Group',
                'Page Listing',
                'Syndication',
                'Powered By',
            ],
        },
        {
            label   => '3-column layout - Primary Sidebar',
            widgets => [
                'Archive Widgets Group',
                'Page Listing',
                'Syndication',
                'Powered By',
            ],
        },
        {
            label   => '3-column layout - Secondary Sidebar',
            widgets => [
                'Search',
                'Home Page Widgets Group',
                'About This Page',
            ],
        },
    ];

    my $modulesets = plugin()->load_selected_modules($blog_id);
    $modulesets = {} unless $modulesets;

    foreach my $widgetset ( @{$widgetsets} ) {
        my $label = plugin()->translate( $widgetset->{label} );
        my @ids;
        foreach my $widget ( @{ $widgetset->{widgets} } ) {
            my $name = plugin()->translate($widget);
            push @ids, $widgets{$name} if $widgets{$name};
        }
        $modulesets->{$label} = join ',', @ids;
    }

    plugin()->set_config_value( 'modulesets', $modulesets, "blog:$blog_id" );
}

sub install_default_widgets {
    my $app = MT->instance;
    my ( $blog_id, $reinstall ) = @_;
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
        next if exists $modules->{plugin()->translate($_->{label})};
        open(TMPL, File::Spec->catfile($widgets_dir, $_->{template})) or die "Error: $!\n";
        while (my $line = <TMPL>) {
            $_->{text} .= $line;
        }
        close TMPL;
        $tmpl = install_module($blog_id, $_->{label}, $_->{text});
    }

    unless( $reinstall ) {
        # Set the 'installed' bit in the config
        installed($blog_id, 1);

        # Now that the plugin is installed for this blog, create a default widget sets
        # with all modules pre-installed.
        create_default_widgetsets($blog_id);
    }
}

sub installed {
    my $config = {};
    my $app = MT->instance;
    my ( $blog_id, $save ) = @_;

    my $plugin = plugin();
    if ($save) {
        # Set the installed bit, save and return
        return $plugin->set_config_value('installed',1,"blog:$blog_id");
    } else {
        # Return early if status check
        return $plugin->get_config_value('installed',"blog:$blog_id");
    }
}

1;
