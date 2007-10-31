#!/usr/bin/perl -w

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
    description => "<MT_TRANS phrase=\"Maintain your weblog's widget content using a handy drag and drop interface.\">",
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
                WidgetManager => sub { $plugin->runner('_hdlr_widget_manager', @_) },
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
                        label => 'Widgets',
                        mode => 'list_widget',
                        order => 201,
                        permission => 'edit_templates',
                        requires_blog => 1,
                    },
                },
            },
        },
    });
}

sub runner {
    my $plugin = shift;
    my $method = shift;
    require WidgetManager::Plugin;
    return $_->($plugin, @_) if $_ = \&{"WidgetManager::Plugin::$method"};
    die $plugin->translate("Failed to find WidgetManager::Plugin::[_1]", $method);
}

sub load_selected_modules { 
    require WidgetManager::Plugin; 
    WidgetManager::Plugin::load_selected_modules(@_); 
}

1;
__END__
