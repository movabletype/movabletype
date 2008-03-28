# Movable Type (r) Open Source (C) 2005-2008 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$

# WidgetManager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic and GPLv2 License

package MT::Plugin::WidgetManager;

use strict;

use base qw( MT::Plugin );
use constant DEBUG => 0;
our $VERSION = '1.0';

my $plugin = MT::Plugin::WidgetManager->new({
    id          => 'WidgetManager',
    name        => 'Widget Manager',
    description => q(<MT_TRANS phrase="Maintain your blog's widget content using a handy drag and drop interface.">),
    version     => $VERSION,
    author_name => 'Six Apart',
    key         => 'widget-manager',
    l10n_class  => 'WidgetManager::L10N',
});
MT->add_plugin($plugin);

sub instance { $plugin; }

sub init_registry { 
    my $plugin = shift;
    $plugin->registry({
        tags => {
            help_url => sub { MT->translate('http://www.movabletype.org/documentation/appendices/tags/%t.html') },
            function => {
                WidgetManager => '$WidgetManager::WidgetManager::Plugin::_hdlr_widget_manager',
                WidgetSet => '$WidgetManager::WidgetManager::Plugin::_hdlr_widget_manager',
            },
        },
        callbacks => {
            'clone_blog_widgets' => {
                callback => 'MT::Blog::post_clone',
                handler => '$WidgetManager::WidgetManager::Plugin::clone_blog_widgemanagers',
            },
            'remove_blog_widgets' => {
                callback => 'MT::Blog::post_remove',
                handler => '$WidgetManager::WidgetManager::Plugin::remove_blog_widgetmanager',
            },
            'DefaultTemplateFilter' => '$WidgetManager::MT::Plugin::WidgetManager::default_templates',
            'MT::Blog::post_create_default_templates' => '$WidgetManager::WidgetManager::Plugin::create_default_widgetsets',
        },
        applications => {
            cms => {
                methods => {
                    list_widget => '$WidgetManager::WidgetManager::CMS::list',
                    edit_widget => '$WidgetManager::WidgetManager::CMS::edit',
                    delete_widget => '$WidgetManager::WidgetManager::CMS::delete',
                    save_widget => '$WidgetManager::WidgetManager::CMS::save',
                },
                menus => {
                    'design:widgets' => {
                        label => 'Widgets',
                        mode => 'list_widget',
                        order => 200,
                        permission => 'edit_templates',
                        view => "blog",
                    },
                },
                template_snippets => {
                    'widget_manager' => {
                        label => 'Widget Set',
                        content => '<$mt:WidgetSet name="$0"$>',
                        trigger => 'widget',
                    },
                },
            },
        },
    });
}

sub load_selected_modules { 
    require WidgetManager::Plugin; 
    WidgetManager::Plugin::load_selected_modules(@_); 
}

sub default_templates {
    my $cb = shift;
    my ($tmpl_list) = @_;

    my $widgetmgr = MT::Plugin::WidgetManager->instance;
    my $widget_tmpls = $widgetmgr->templates(MT->instance);
    push @$tmpl_list, @$widget_tmpls;
}

sub templates {
    my $plugin = shift;
    my ($app) = @_;
    my $default_widget_templates;

    use File::Spec;
    my $widgets_dir = File::Spec->catfile($plugin->{full_path}, 'default_widgets');
    my $cfg_file = File::Spec->catfile($widgets_dir, 'widgets.cfg');
    
    local(*FH, $_, $/);
    $/ = "\n";
    open FH, $cfg_file or
        return $app->error(MT->translate(
                               "Error opening file '[_1]': [_2]", $cfg_file, "$!" ));
    my $cfg = join('',<FH>);
    eval "$cfg;";
    close FH;

    my @tmpls;
    require MT::Template;
    foreach (@$default_widget_templates) {
        open(TMPL, File::Spec->catfile($widgets_dir, $_->{template})) or die "Error: $!\n";
        while (my $line = <TMPL>) {
            $_->{text} .= $line;
        }
        close TMPL;
        my $tmpl = MT::Template->new;
        $tmpl->{type} = 'widget';
        $tmpl->{name} = $plugin->translate($_->{label});
        $tmpl->{text} = $plugin->translate_templatized($_->{text});
        push @tmpls, $tmpl;
    }
    return \@tmpls;
}

1;
__END__
