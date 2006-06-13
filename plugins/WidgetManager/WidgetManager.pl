#!/usr/bin/perl -w

# WidgetManager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic License
#
# $Id$

package MT::Plugin::WidgetManager;

use strict;
use MT;
use constant DEBUG => 0;

use vars qw( $VERSION $plugin );
$VERSION = '1.0 Beta 4';

unless ($plugin) {
    eval {
        require MT::Plugin;
        @MT::Plugin::WidgetManager::ISA = ('MT::Plugin');
        $plugin = MT::Plugin::WidgetManager->new({
              name        => 'Widget Manager',
              description => "<MT_TRANS phrase=\"Maintain your weblog's widget content using a handy drag and drop interface.\">",
              version     => $VERSION,
              author_name => 'Six Apart',
              key => 'widget-manager',
              l10n_class => 'WidgetManager::L10N',
        });
        MT->add_plugin($plugin);
    };
    MT->add_plugin_action('blog','widget-manager.cgi?', "Manage my Widgets");
    MT->add_plugin_action('list_template','widget-manager.cgi?', "Manage my Widgets");
    MT->add_callback('MT::App::CMS::AppTemplateParam.menu', 9, $plugin,
        \&verify_permission);
    MT->add_callback('MT::App::CMS::AppTemplateParam.list_template', 9, $plugin,
        \&verify_permission);

    require MT::Template::Context;
    MT::Template::Context->add_tag(WidgetManager => sub { $plugin->runner('_hdlr_widget_manager', @_) });
}                                                                                                        

sub instance { $plugin; }

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

sub verify_permission {
    my ($eh, $app, $param, $tmpl) = @_;
    unless ($app->user->is_superuser ||
            $param->{'can_edit_templates'}) {
        @{$param->{plugin_action_loop}} = grep { $_->{'orig_link_text'} ne 'Manage my Widgets' } @{$param->{plugin_action_loop}};
    }
    1;
}




1;

__END__

