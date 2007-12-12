# WidgetManager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

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
                        label => 'Widget Sets',
                        mode => 'list_widget',
                        order => 201,
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
                list_filters => {
                    template => {
                        widget_templates => {
                            label => "Widgets",
                            order => 500,
                            handler => sub {
                                my ($terms) = @_;
                                $terms->{type} = 'widget';
                            },
                        },
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

1;
__END__
