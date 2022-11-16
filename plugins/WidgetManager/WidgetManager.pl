# Movable Type (r) (C) Six Apart Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

# WidgetManager plugin for Movable Type
# Author: Byrne Reese, Six Apart (http://www.sixapart.com)
# Released under the Artistic and GPLv2 License

package MT::Plugin::WidgetManager;

use strict;

use base qw( MT::Plugin );
use constant DEBUG => 0;
use MT::Template;
use MT::Util qw( escape_unicode );

our $VERSION = '1.1';

my $plugin = MT::Plugin::WidgetManager->new(
    {   id   => 'WidgetManager',
        name => 'Widget Manager Upgrade Assistant',
        description =>
            q(<MT_TRANS phrase="Widget Manager version 1.1; This version of the plugin is to upgrade data from older version of Widget Manager that has been shipped with Movable Type to the Movable Type core schema.  No other features are included.  You can safely remove this plugin after installing/upgrading Movable Type.">),
        version        => $VERSION,
        schema_version => $VERSION,
        author_name    => 'Six Apart Ltd.',
        author_link    => 'http://www.movabletype.org/',
        key            => 'widget-manager',
        l10n_class     => 'WidgetManager::L10N',
    }
);
MT->add_plugin($plugin);

sub instance { $plugin; }

sub init_registry {
    my $plugin = shift;
    $plugin->registry(
        {   upgrade_functions => {
                'upgrade_widgetmanagers_nv' => {

                    # this is to workaround absence of PluginSchemaVersion
                    code     => \&upgrade_widgetmanagers,
                    priority => 3.12
                },
                'upgrade_widgetmanagers' => {
                    version_limit => 1.1,
                    code          => \&upgrade_widgetmanagers,
                }
            },
        }
    );
    return 1;
}

sub _disable_widgetmanager {
    my $switch = MT->config('PluginSwitch') || {};
    $switch->{ $plugin->{plugin_sig} } = 0;
    MT->config( 'PluginSwitch', $switch, 1 );
    MT->config->save_config();
}

sub _translate_escape {
    my $trans = $plugin->translate(@_);
    return $trans if $MT::Upgrade::CLI;
    return MT::Util::escape_unicode($trans);
}

sub upgrade_widgetmanagers {
    my $upg = shift;

    require MT::PluginData;
    my $iter = MT::PluginData->load_iter( { plugin => $plugin->key } );
    while ( my $pd = $iter->() ) {
        next unless $plugin->key eq $pd->plugin;
        my ($blog_id) = $pd->key =~ /configuration:blog:(\d+)/;
        next unless $blog_id;
        my $config = $pd->data;
        next unless $config;
        my $modulesets = $config->{modulesets};
        next unless $modulesets;
        foreach my $mod_key ( keys %$modulesets ) {
            $upg->progress(
                _translate_escape(
                    'Moving storage of Widget Manager [_2]...', $mod_key
                )
            );
            my $tmpl_ids = $modulesets->{$mod_key};
            my $tmpl     = MT::Template->new;
            $tmpl->blog_id($blog_id);
            $tmpl->name($mod_key);
            $tmpl->type('widgetset');
            $tmpl->build_dynamic(0);
            $tmpl->rebuild_me(0);
            $tmpl->modulesets($tmpl_ids);
            $tmpl->save_widgetset
                or $upg->progress( _translate_escape('Failed.') ), next;
            $upg->progress( _translate_escape('Done.') );
        }
        $pd->remove;
    }
    _disable_widgetmanager;
}

1;
__END__
